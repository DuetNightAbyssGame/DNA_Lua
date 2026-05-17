--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Play_TaskDaily_P_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

--function M:Initialize(Initializer)
--end

-- function M:Construct()
--     M.Super.Construct(self)
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:OnListItemObjectSet(Content)
    --EventManager:AddEvent(EventID.DailyTaskRewardChange, self, self.OnDailyTaskRewardChange)
    self.Data = Content
    self.Parent = Content.Parent
    self:InitItemContent()
    self:AddInputMethodChangedListen()
    self.Btn_Goto.bAutoButtonChange = false
end

function M:InitItemContent()
    self.Mobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
    self.IsEnter = false
    --self:PlayAnimation(self.In)
    self.Text_Desc:SetText(GText(self.Data.DailyTasktDes))
    self:RefreshRewardInfoList(self.Data.QuestReward)
    self:RefreshView()
    self.IsMenuOpen = false
    self.Parent.Btn_Reward:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad  then
        self:UpdateUIStyleInPlatform(true)
    end
end

function M:BP_OnEntryReleased()
    -- if (self.Data) then
    --     self.Data = nil
    -- end
    -- self:PlayAnimation(self.Normal)
end

-- 更新奖励信息列表
---@param DungeonReward number[] @奖励Id列表[RewardView]
function M:RefreshRewardInfoList(DungeonReward)
    if not DungeonReward then
        DebugPrint("SL DungeonReward is nil")
        return
    end

    local RewardInfo = DataMgr.Reward[DungeonReward[1]]
    if RewardInfo then
        local Ids = RewardInfo.Id or {}
        local RewardCount = RewardInfo.Count or {}
        local TableName = RewardInfo.Type or {}
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        local ItemId = Ids[1]
        Content.IsShowDetails = true
        Content.Id = ItemId
        Content.UnitId = ItemId
        Content.ItemType = TableName[1]
        Content.Count = RewardUtils:GetCount(RewardCount[1])
        Content.Icon = ItemUtils.GetItemIconPath(ItemId, TableName[1])
        Content.Rarity = ItemUtils.GetItemRarity(ItemId, TableName[1])
        Content.UnitName = ItemUtils:GetDropName(ItemId, TableName[1])
        Content.Parent = self
        --Content.HandleMouseDown = true

        self.Item_Reward:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
        self.Item_Reward:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
        self.Item_Reward:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
        self.Item_Reward:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
        self.Item_Reward:Init(Content)
        self.Item_Reward:BindEvents(self,{
            OnMenuOpenChanged = self.OnStuffMenuOpenChanged,
        })
    end
end

function M:OnStuffMenuOpenChanged(bIsOpen)
    if (UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad) then
        return
    end

    self.IsMenuOpen = bIsOpen
    if (bIsOpen) then
        self:UpdatKeyDisplay("")
    else
        self:UpdatKeyDisplay("RewardWidget")
    end
    self:UpdateUIStyleInPlatform(true)
end

function M:RefreshView()
    local PlayerAvatar = GWorld:GetAvatar()
    if PlayerAvatar then
        local DailyTaskAchvsServerData = PlayerAvatar.DailyTaskAchvs[self.Data.DailyGoalTaskId]
        self.Text_Progress:SetText(DailyTaskAchvsServerData.Progress .. "/" ..
            DailyTaskAchvsServerData.Target)
        self.Text_Complete:SetText(DailyTaskAchvsServerData.Progress .. "/" ..
            DailyTaskAchvsServerData.Target)

        self.DailyTaskServerData = PlayerAvatar.DailyTasks[self.Data.DailyGoalTaskId]

        if self.DailyTaskServerData.State == CommonConst.DailyTaskState.Doing then --未完成
            if self.Data.JumpUIId then
                self.Btn_Goto:BindEventOnClicked(self, self.GoToSystem)
                self.Btn_Goto:SetText(GText("UI_BattlePass_QuestJump"))
                self.WS_Text:SetActiveWidgetIndex(0)
            else
                self.WS_Text:SetActiveWidgetIndex(1)
                self.Text_Progressing:SetText(GText("UI_Archive_CollectionInProgress"))
            end
            self:PlayAnimation(self.Normal)
        elseif self.DailyTaskServerData.State == CommonConst.DailyTaskState.Complete then
            self.Btn_Reward:BindEventOnClicked(self, self.ReceiveReward)
            self.Btn_Reward:SetText(GText("UI_Achievement_GetReward"))
            self:PlayAnimation(self.Normal)
        elseif self.DailyTaskServerData.State == CommonConst.DailyTaskState.GetReward then
            --self:StopAllAnimations()
            self:PlayAnimation(self.Recived)
        end
        self.Switch_Btn:SetActiveWidgetIndex(self.DailyTaskServerData.State - 1)
    end
end

function M:ReceiveReward()
    local PlayerAvatar = GWorld:GetAvatar()
    if not PlayerAvatar then
        return
    end
    DebugPrint("GetDailyTaskReward 领取  " ,self.Data.DailyGoalTaskId)
    PlayerAvatar:GetDailyTaskReward(self.Data.DailyGoalTaskId)
end

function M:GoToSystem()
    local JumpSuccess = PageJumpUtils:JumpToTargetPageByJumpId(self.Data.JumpUIId) --self.Data.JumpUIId  49
    if JumpSuccess then
        UIManager(self):HideNpcById(910003, true, "StyleOfPlay")
    end
    -- if (IsInActiveTime) then
    -- else
    --     UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_GameEvent_EventEnd"))
    -- end
end

function M:OnDailyTaskRewardChange(DailyTaskId)
    if DailyTaskId == self.Data.DailyGoalTaskId then
        --self.Switch_Btn:SetActiveWidgetIndex(self.DailyTaskServerData.State - 1)
        self:RefreshView()
    end
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and self.FocusTypeName == "SelfWidget" then
        local PlayerAvatar = GWorld:GetAvatar()
        if not PlayerAvatar then return end
        local DailyTaskServerData = PlayerAvatar.DailyTasks[self.Data.DailyGoalTaskId]
        if DailyTaskServerData.State == CommonConst.DailyTaskState.Doing then --未完成
            if self.Data.JumpUIId and not self.Item_Reward:HasAnyUserFocus() then
                self:GoToSystem()
            end
        elseif DailyTaskServerData.State == CommonConst.DailyTaskState.Complete then
            self:ReceiveReward()
        end
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
    self.IsEnter = true
    if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad or self:IsAnimationPlaying(self.In) then
        return
    end
    --self:UpdatKeyDisplay("SelfWidget")
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
    if self.IsMenuOpen then return end
    self:UpdateUIStyleInPlatform(false)
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
    self.IsEnter = false
    if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad or self:IsAnimationPlaying(self.In) then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Unhover)
    self:UpdateUIStyleInPlatform(true)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    end
    if (IsEventHandled) then
        return UWidgetBlueprintLibrary.Handled()
    else
        return UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    if InKeyName == "Gamepad_LeftThumbstick" then
        if not self.Item_Reward:HasAnyUserFocus() then
            self.Item_Reward:SetFocus()
            self:UpdatKeyDisplay("RewardWidget")
        else
            self:SetFocus()
            self:UpdatKeyDisplay("SelfWidget")
        end
        self:UpdateUIStyleInPlatform(self.Item_Reward:HasAnyUserFocus())
        IsEventHandled = true
    elseif InKeyName == "Gamepad_FaceButton_Right" then
        if self.Item_Reward:HasFocusedDescendants() or self.Item_Reward:HasAnyUserFocus() then
            self:SetFocus()
            self:UpdateUIStyleInPlatform(false)
            self:UpdatKeyDisplay("SelfWidget")
            IsEventHandled = true
        end
    elseif InKeyName == Const.GamepadFaceButtonUp then
        self.Parent:ClaimAllTaskRewards()
    else
        if self.Item_Reward:HasFocusedDescendants() or self.Item_Reward:HasAnyUserFocus() then
            IsEventHandled = true
        end
    end
    return IsEventHandled
end


function M:OnFocusReceived(MyGeometry, InFocusEvent)
    self:UpdatKeyDisplay("SelfWidget")
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self.Parent.Btn_Reward:SetGamePadImg("Y")
        self.Parent.Btn_Reward:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

-- 更新按键显示
function M:UpdatKeyDisplay(FocusTypeName)
    if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad or self.Mobile then
        return
    end
    local StyleOfPlay = UIManager(self):GetUIObj("StyleOfPlay")
    if not StyleOfPlay then
        return
    end

    self.FocusTypeName = FocusTypeName
    if FocusTypeName == "RewardWidget" then
        local BottomKeyInfo = {
            {
                GamePadInfoList = {
                    { Type = "Img", ImgShortPath = "A", Owner = self }
                },
                Desc = GText("UI_Controller_CheckDetails"),
                bLongPress = false,
            },
            {
                KeyInfoList = { { Type = "Text", Text = "Esc", ClickCallback = self.Parent.CloseSelf, Owner = self } },
                GamePadInfoList = {
                    { Type = "Img", ImgShortPath = "B", Owner = self }
                },
                Desc = GText("UI_BACK"),
            },

        }
        StyleOfPlay.ComTab.Left_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.Right_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)

        if self.Parent.TaskRoot then
            self.Parent.TaskRoot.Tab.Key_Left:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Parent.TaskRoot.Tab.Key_Right:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        self.Parent.Panel_Controller_Reward:SetVisibility(ESlateVisibility.Collapsed)
        -- 更新界面按键提示
        StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
    elseif FocusTypeName == "SelfWidget" then
        local BottomKeyInfo = {
            {
                KeyInfoList = { { Type = "Text", Text = "Esc",  ClickCallback = self.Parent.CloseSelf, Owner = self } },
                GamePadInfoList = {
                    { Type = "Img", ImgShortPath = "B", Owner = self }
                },
                Desc = GText("UI_BACK"),
            },

        }
        StyleOfPlay.ComTab.Left_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        StyleOfPlay.ComTab.Right_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        if self.Parent.TaskRoot then
            self.Parent.TaskRoot.Tab.Key_Left:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.Parent.TaskRoot.Tab.Key_Right:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
        self.Parent:UpdateUIStyleInPlatform()
        StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
    else
        local BottomKeyInfo = {}
        StyleOfPlay.ComTab.Left_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.Right_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        if self.Parent.TaskRoot then
            self.Parent.TaskRoot.Tab.Key_Left:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Parent.TaskRoot.Tab.Key_Right:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        self.Parent.Btn_Reward:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
        -- 更新界面按键提示
        StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
    end
end

-- function M:OnAnimationFinished(InAnimation)
--     if InAnimation == self.In then
--         if self.IsEnter then
--             if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
--                 self:StopAllAnimations()
--                 self:PlayAnimation(self.Hover)
--                 self:UpdateUIStyleInPlatform(false)
--             end
--             return
--         else
--             if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
--                 self:UpdateUIStyleInPlatform(true)
--             end
--         end
--     end
-- end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 输入设备切换通知
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if self:HasFocusedDescendants() or self:HasAnyUserFocus() then
        if IsUseKeyAndMouse then
            self:StopAllAnimations()
            self:PlayAnimation(self.Normal)
            self.Parent.Btn_Reward:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
        else
            self.Parent.Btn_Reward:SetGamePadImg("Y")
            self.Parent.Btn_Reward:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end

        self:UpdateUIStyleInPlatform(true)
    end

    self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    if self.Mobile then return end
    --如果是pc或者特殊原因需要显示为pc时
    if (IsUseKeyAndMouse) then
        self.Key_Controller_Item:SetVisibility(ESlateVisibility.Collapsed)
        self.Btn_Reward:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
        --self.Parent.Btn_Reward:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Btn_Goto:SetPCVisibility(true)
    else
        self.Key_Controller_Item:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Key_Controller_Item:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Img",
                    ImgShortPath = "LS",
                },
            },
        })
        self.Btn_Goto:SetPCVisibility(false)
        self.Btn_Reward:SetGamePadImg("A")
        self.Btn_Reward:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    end
end

return M
