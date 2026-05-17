--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_Fort_ItemBuff_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Button_Area.OnHovered:Add(self, self.OnBtnHovered)
    self.Button_Area.OnUnhovered:Add(self, self.OnBtnUnhovered)
    self.Button_Area.OnPressed:Add(self, self.OnBtnPressed)
    self.Button_Area.OnReleased:Add(self, self.OnBtnReleased)
    self.Button_Area.OnClicked:Add(self, self.OnBtnClicked)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    ReddotManager.RemoveListener("PaotaiEventNewBuff",self)
end

function M:Init(ClickEvent, CantClick, Type, NeedJudgeLockIcon, Index, IsUnlockFromContent, NeedAddListener)
    if ClickEvent then
        self:BindEventOnClicked(ClickEvent.Obj,ClickEvent.Func,ClickEvent.Params)
    end
    if CantClick then
        self.Button_Area:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self.Button_Area:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    self.IsUnlock = true
    self.Type = Type
    self.Index = Index
    if NeedJudgeLockIcon then
        if Type == "Weapon" then
            self.IsUnlock = self:CheckWeaponBuffIsUnlock()
        elseif Type == "Normal" then
            self.IsUnlock = self:CheckNormalBuffIsUnlock(Index)
        end
    else
        self.IsUnlock = IsUnlockFromContent
        if self.IsUnlock then
            self:PlayAnimation(self.Normal)
        else
            self:PlayAnimation(self.Forbidden)
        end
    end
    if self.IsUnlock then
        self.Icon_Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self.Icon_Lock:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
    if NeedAddListener then
        if not ReddotManager.GetTreeNode("PaotaiEventNewBuff") then
            ReddotManager.AddNodeEx("PaotaiEventNewBuff")
        end
        ReddotManager.AddListenerEx("PaotaiEventNewBuff",self,self.UpdateReddot)
    end
end

function M:InitBuffInfo(BuffId)
    self.BuffId = BuffId
    if self.BuffId then
        self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
    else
        self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
        return
    end
    local PaotaiBuff = {
        DataMgr.PaotaiGameProp,
        DataMgr.PaotaiGameWeapon
    }
    for _,Buffs in pairs(PaotaiBuff) do
        for _,Info in pairs(Buffs) do
            if Info.BuffId == self.BuffId then
                local IconPath = Info.PropIcon or Info.WeaponIcon
                local Icon = LoadObject(IconPath)
                self.Img_Buff:SetBrushFromTexture(Icon)
                return
            end
        end
    end
end

function M:InitBuffReddotAndNew(BuffId)
    if BuffId then
        self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
        local ShowNew = self:CheckShowNew()
        if ShowNew then
            self.New:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        else
            self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    else
        self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
        if self.IsUnlock then
            self.Reddot:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        else
            self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
end

function M:BindEventOnClicked(Obj, Func, Params)
    if not Obj or not Func then
        return
    end
    self.Obj = Obj
    self.Func = Func
    self.Params = Params
end

function M:OnBtnHovered()
	self.IsHovering = true
    if self.IsSelect then
        return
    end
	if self.IsPressing then
        return
    end
	self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
end

function M:OnBtnUnhovered()
	self.IsHovering = false
    if self.IsSelect then
        return
    end
	if not self.IsPressing then
		self:StopAllAnimations()
		self:PlayAnimation(self.Unhover)
	end
end

function M:OnBtnPressed()
	self.IsPressing = true
    if self.IsSelect then
        return
    end
	self:StopAllAnimations()
    self:PlayAnimation(self.Press)
end

function M:OnBtnReleased()
    self.IsPressing = false
    if self.IsSelect then
        return
    end
    if not self.IsHovering then
        self:StopAllAnimations()
        self:PlayAnimationReverse(self.Normal)
    else
        self:StopAllAnimations()
        self:PlayAnimationReverse(self.Hover)
    end
end

function M:OnBtnClicked()
    if self.IsSelect then
        return
    end
	self:StopAllAnimations()
	self:PlayAnimation(self.Click)
    if self.Obj and self.Func then
        self.Func(self.Obj, table.unpack(self.Params))
    end
end

function M:SetSelected(IsSelect)
    self.IsSelect = IsSelect
    self:StopAllAnimations()
    if self.IsSelect then
        self:PlayAnimation(self.Selected)
    else
        self:PlayAnimation(self.Normal)
    end
end

function M:CheckNormalBuffIsUnlock(Index)
    Index = Index or 0
    local NormalBuffInfo = DataMgr.PaotaiGameProp
    local Avatar = GWorld:GetAvatar()
    local BuffNum = 0
    if Avatar then
        for Id, Info in pairs(NormalBuffInfo) do
            if not Info.DungeonId then
                BuffNum = BuffNum + 1
            else
                local DungeonsInfo = Avatar.Dungeons[Info.DungeonId]
                if DungeonsInfo and DungeonsInfo.IsPass then
                    BuffNum = BuffNum + 1
                end
            end
        end
    end
    if Index <= BuffNum then
        return true
    else
        return false
    end
end

function M:CheckWeaponBuffIsUnlock()
    local WeaponBuffInfo = DataMgr.PaotaiGameWeapon
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        for Id, Info in pairs(WeaponBuffInfo) do
            if not Info.DungeonId then
                return true
            end
            local DungeonsInfo = Avatar.Dungeons[Info.DungeonId]
            if DungeonsInfo and DungeonsInfo.IsPass then
                return true
            end
        end
    end
    return false
end

function M:UpdateReddot()
    if self.BuffId then
        local ShowNew = self:CheckShowNew()
        if ShowNew then
            self.New:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        else
            self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
end

function M:CheckShowNew()
    local BuffInfos = nil
    if self.Type == "Normal" then
        BuffInfos = DataMgr.PaotaiGameProp
    elseif self.Type == "Weapon" then
        BuffInfos = DataMgr.PaotaiGameWeapon
    end
    if not BuffInfos then
        return false
    end
    if not ReddotManager.GetTreeNode("PaotaiEventNewBuff") then
        ReddotManager.AddNodeEx("PaotaiEventNewBuff")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("PaotaiEventNewBuff")
    local ShowNew = false
    for _,Info in pairs(BuffInfos) do
        if CacheDetail[Info.BuffId] == 1 then
            ShowNew = true
            break
        end
    end
    return ShowNew
end

return M
