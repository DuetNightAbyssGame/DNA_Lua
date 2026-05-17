--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_TabItem_SP_P_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    self.Btn.OnClicked:Add(self, self.Btn_Click)
    self.Btn.OnPressed:Add(self, self.Btn_Press)
    self.Btn.OnHovered:Add(self, self.Btn_Hover)
    self.Btn.OnUnhovered:Add(self, self.Btn_UnHover)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--    Info = {
--             Text = "任务"   Tab文本
--             TabId = 1, Tab的Id,
--             IconPath = "/Game/UI/UI_PNG/Atlas/Tab/T_Tab_All.T_Tab_All", 图片路径
--             ShowRedDot = 1, 显示红点,
--             IsNew = 1, 显示新图标,
--             ShowRedDotNum = 10, 显示数量红点
--             IsLocked = false,  是否此Tab仍处于锁定状态（true为锁定，默认不锁定）
--             IsForbidden = false,  是否此Tab处于禁用状态（true为禁用，默认不禁用）
--             LockReasonText = GText("UI_RegionMap_MaxMark"), 未解锁点击提示文本
--           }     

function M:Update(Idx, Info)
    self.Info = Info
    Info.UI = self
    self.Idx = Idx
    self.IsLocked = Info.IsLocked
    if (Info.IconPath) then
        local Icon = LoadObject(Info.IconPath)
        local Material = self.Icon_Tab:GetDynamicMaterial()
        Material:SetTextureParameterValue("IconTex", Icon)
    end
    self.Text_Tab:SetText(Info.Text)
    if (self.IsLocked) then
        -- 当前内容已锁定
        self:PlayAnimation(self.Lock)
    end
    if (self.Reddot) then
        self:SetReddot(Info.IsNew, Info.ShowRedDot)
    end
    if (self.Reddot_Num) then
        self:SetReddotNum(Info.ShowRedDotNum)
    end
    self.bClickEnable = not Info.IsForbidden
    if (not self.bClickEnable) then
        -- 当前内容已禁用
        self:PlayAnimation(self.Forbidden)
    end
    if(Info.IsOn)then
        self.IsOn = Info.IsOn
        if (self:IsAnimationPlaying(self.UnHover)) then
            self:StopAnimation(self.UnHover)
        end
        self:PlayAnimation(self.Click,0,1,0,1000)
    else
        self:PlayAnimation(self.Normal,0,1,0,1000)
    end
    -- 如果self.Idx是奇数就显示self.Base
    if (self.Idx % 2 == 1) then
        self.Base:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.Base:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

function M:GetTabId()
    return self.Info.TabId
end

function M:GetTabIndex()
    return self.Idx
end

function M:SetSwitchOn(IsOn, IsNeedPressAnim)
    -- 未解锁的状态点击出个提示
    if (self.IsLocked) then
        local ShowTextContent = self.Info.LockReasonText or "Not Define!!!!"
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, ShowTextContent)
        return
    end
    self.IsOn = IsOn
    if (IsOn) then
        -- self:StopAllAnimations()
        if (self:IsAnimationPlaying(self.UnHover)) then
            self:StopAnimation(self.UnHover)
        end
        if (IsNeedPressAnim) then
            local function PlayPressAnimFinished()
                -- self.Panel_Name:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
                self:PlayAnimation(self.Click) 
            end
            self:UnbindAllFromAnimationFinished(self.Press)
            self:BindToAnimationFinished(self.Press, {self, PlayPressAnimFinished})
            self:PlayAnimation(self.Press)
        else
            self:PlayAnimation(self.Click)
        end
        if(self.EventSwitchOn)then
            self.EventSwitchOn(self.ObjSwitchOn,self)
        end
    else
        self:StopAllAnimations()
        self:PlayAnimation(self.Normal)
        if(self.EventSwitchOff)then
            self.EventSwitchOff(self.ObjSwitchOff,self)
        end
    end
end

function M:BindEventOnHoverOnOrOff(Obj,Event)
    self.ObjHoverOnOrOff = Obj
    self.EventHoverOnOrOff = Event
end

function M:UnbindEventOnHoverOnOrOff()
    self.ObjHoverOnOrOff = nil
    self.EventHoverOnOrOff = nil
end

function M:BindEventOnSwitchOn(Obj,Event)
    self.ObjSwitchOn = Obj
    self.EventSwitchOn = Event
end

function M:UnbindEventOnSwitchOn()
    self.ObjSwitchOn = nil
    self.EventSwitchOn = nil
end

function M:BindEventOnSwitchOff(Obj,Event)
    self.ObjSwitchOff = Obj
    self.EventSwitchOff = Event
end

function M:UnbindEventOnSwitchOff()
    self.ObjSwitchOff = nil
    self.EventSwitchOff = nil
end

function M:BindSoundFunc(func,Receiver)
    self.SoundFunc = func
    self.SoundFuncReceiver = Receiver
end

function M:BindHoverSoundFunc(func,Receiver)
    self.HoverSoundFunc = func
    self.SoundFuncReceiver = Receiver
end

function M:SetClickEnable(bEnable)
    self.bClickEnable = bEnable
end

function M:SetLockInfo(bUnLock)
    self.IsLocked = bUnLock
    if (bUnLock) then
        self:PlayAnimation(self.Normal)
    else
        self:PlayAnimation(self.Lock)
    end
end

function M:IsTabLocked()
    return self.IsLocked
end

function M:GetIsCanSelect()
    return self.bClickEnable and not self.IsLocked
end

function M:Btn_Click()
    if (not self.bClickEnable) then
        -- 禁用点击
        return
    end
    if(self.SoundFunc)then
        self.SoundFunc(self.SoundFuncReceiver,self.Idx)
    end
    if(not self.IsOn)then
        self:SetSwitchOn(true, false)
    end
end

function M:Btn_Press()
    if (self.IsOn or self.IsLocked or not self.bClickEnable) then
        return
    end
    if (self:IsAnimationPlaying(self.Press)) then
        return
    end
    self:UnbindAllFromAnimationFinished(self.Press)
    self:PlayAnimation(self.Press)
end

function M:Btn_Hover()
    --选中或者未解锁的时候不触发Hover动画
    if (self.IsOn or self.IsLocked or not self.bClickEnable) then
        return
    end
    if(self.HoverSoundFunc)then
        self.HoverSoundFunc(self.SoundFuncReceiver,self.Idx)
    end
    self:PlayAnimation(self.Hover)
    if(self.EventHoverOnOrOff)then
        self.EventHoverOnOrOff(self.ObjHoverOnOrOff, self, true)
    end
end

function M:Btn_UnHover()
    --选中或者未解锁的时候不触发UnHover动画
    if(self.IsOn or self.IsLocked or not self.bClickEnable)then
        return
    end
    if (self:IsAnimationPlaying(self.Hover)) then
        self:StopAnimation(self.Hover)
    end
    -- if (self:IsAnimationPlaying(self.Press)) then
    --     self:StopAnimation(self.Press)
    -- end
    -- self:StopAllAnimations()
    self:PlayAnimation(self.UnHover)
    if(self.EventHoverOnOrOff)then
        self.EventHoverOnOrOff(self.ObjHoverOnOrOff, self, false)
    end
end

---@param IsNew boolean 是否显示 新 样式的红点
---@param Upgradeable boolean 是否显示 普通 样式的红点
---@param OtherReddot boolean 是否切换成另一样式的红点(灰色)
function M:SetReddot(IsNew,Upgradeable,OtherReddot)
    self.IsNew = IsNew
    self.Upgradeable = Upgradeable
    self.OtherReddot = OtherReddot
    if(IsNew)then
        self.Reddot:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.New:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        return
    end
    self.New:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    if(self.Reddot) then
        if(OtherReddot)then
            self.Reddot:SetReddotStyle(1)
            self.Reddot:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        elseif(Upgradeable)then
            self.Reddot:SetReddotStyle(0)
            self.Reddot:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        else
            self.Reddot:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
    end
end

---@param RedNum number 红点数量
function M:SetReddotNum(RedNum)
    if (RedNum ~= nil and RedNum > 0) then
        self.Reddot_Num:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Reddot_Num:SetNum(RedNum)
    else
        self.Reddot_Num:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:OnAddedToFocusPath(InFocusEvent)
    self:Btn_Click()
end

return M
