--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_BuffDialogItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Button_Area.OnHovered:Add(self, self.OnCellHovered)
    self.Button_Area.OnUnhovered:Add(self, self.OnCellUnhovered)
    self.Button_Area.OnPressed:Add(self, self.OnCellPressed)
    self.Button_Area.OnReleased:Add(self, self.OnCellReleased)
    self.Button_Area.OnClicked:Add(self, self.OnCellClicked)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:BP_OnEntryReleased()
    if (self.Content) then
        self.Content.Entry = nil
    end
end

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.Content.Entry = self
    self:SetIsUnlock()
    self.Buff:Init(nil,true,self.Content.Type,false,nil,self.Content.IsUnlock,false)
    self.Buff:InitBuffInfo(self.Content.BuffId)
    self.Text_BuffName:SetText(GText(self.Content.Name))
    self.Text_BuffDesc:SetText(GText(self.Content.Des))
    self.Text_BuffDesc_Lock:SetText(GText(self.Content.LockDes))
    self:SetCanCancelSelection(self.Content.CanCancelSelection)
    self:SetSelected(self.Content.IsSelect)
    self:SetReddot()
    self:BindEventOnClicked(self.Content.ClickEvent.Obj,self.Content.ClickEvent.Func,table.unpack(Content.ClickEvent.Params))
end

function M:BindEventOnClicked(Obj, Func, ...)
    if not Obj or not Func then
        return
    end
    self.Obj = Obj
    self.Func = Func
    self.Params = { ... }
end

function M:SetSelected(IsSelect)
    self.Content.IsSelect = IsSelect
    if IsSelect then
        self.Com_List:SelectCell()
        if self.Content.IsUnlock then
            self.WidgetSwitcher_Option:SetActiveWidgetIndex(1)
        end
    else
        self.Com_List:OnCellUnSelect()
        if self.Content.IsUnlock then
            self.WidgetSwitcher_Option:SetActiveWidgetIndex(0)
        end
    end
end

function M:SetSelectedByClick(IsSelect)
    self.Content.IsSelect = IsSelect
    if IsSelect then
        self.WidgetSwitcher_Option:SetActiveWidgetIndex(1)
    else
        self.WidgetSwitcher_Option:SetActiveWidgetIndex(0)
    end
end

function M:SetCanCancelSelection(CanCancelSelection)
    self.Com_List:SetCanCancelSelection(CanCancelSelection)
end

function M:CheckIsUnlock()
    local BuffInfo = nil
    local CurEventId = DataMgr.PaotaiEventConstant.PaotaiGameEventId.ConstantValue
    if self.Content.Type == "Normal" then
        BuffInfo = DataMgr.PaotaiGameProp
    elseif self.Content.Type == "Weapon" then
        BuffInfo = DataMgr.PaotaiGameWeapon
    end
    if BuffInfo then
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            local Info = BuffInfo[self.Content.Id]
            if not Info then
                return false
            end
            if not Info.DungeonId then
                return true
            end
            local IsUnlock = false
            local PaotaiGame = Avatar.PaotaiGame
            local PaotaiMiniGameInfo = DataMgr.PaotaiMiniGame[Info.DungeonId]
            if PaotaiGame and PaotaiMiniGameInfo then
                local PaotaiGameEventInfo = PaotaiGame[CurEventId]
                local PaotaiGameLevelInfo = nil
                if PaotaiGameEventInfo then
                    PaotaiGameLevelInfo = PaotaiGameEventInfo[Info.DungeonId]
                end
                if PaotaiGameLevelInfo then
                    local MaxScore = PaotaiGameLevelInfo.MaxScore or 0
                    local StarNum = 0
                    for _,TargetScore in ipairs(PaotaiMiniGameInfo.Level) do
                        if MaxScore >= TargetScore then
                            StarNum = StarNum + 1
                        end
                    end
                    if StarNum >= DataMgr.PaotaiEventConstant.PreDungeonRequiredStar.ConstantValue then
                        IsUnlock = true
                    end
                end
            end
            return IsUnlock
        else
            return false
        end
    else
        return false
    end
end

function M:SetIsUnlock()
    self.Content.IsUnlock = self:CheckIsUnlock()
    if self.Content.IsUnlock then
        self.Com_List:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.WidgetSwitcher_Text:SetActiveWidgetIndex(0)
    else
        self.Com_List:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.WidgetSwitcher_Text:SetActiveWidgetIndex(1)
        self.WidgetSwitcher_Option:SetActiveWidgetIndex(2)
    end
end

function M:OnCellClicked()
    if not ReddotManager.GetTreeNode("PaotaiEventNewBuff") then
        ReddotManager.AddNodeEx("PaotaiEventNewBuff")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("PaotaiEventNewBuff")
    if CacheDetail[self.Content.BuffId] == 1 then
        CacheDetail[self.Content.BuffId] = 0
        ReddotManager.DecreaseLeafNodeCount("PaotaiEventNewBuff")
        self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

    local Ans = false
    if self.Obj and self.Func then
        Ans = self.Func(self.Obj, table.unpack(self.Params))
    end
    if Ans then
        self.Com_List:OnCellClicked()
    end
end

function M:OnCellHovered()
    self.Com_List:OnCellHovered()
end

function M:OnCellUnhovered()
    self.Com_List:OnCellUnhovered()
end

function M:OnCellPressed()
    self.Com_List:OnCellPressed()
end

function M:OnCellReleased()
    self.Com_List:OnCellReleased()
end

function M:SetReddot()
    if not ReddotManager.GetTreeNode("PaotaiEventNewBuff") then
        ReddotManager.AddNodeEx("PaotaiEventNewBuff")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("PaotaiEventNewBuff")
    if CacheDetail[self.Content.BuffId] == 1 then
        self.New:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

return M
