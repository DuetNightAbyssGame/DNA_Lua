--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local NormalTaskNewReddotName = "JJGameTask_Normal_New"
local NormalRewardReddotName = "JJGameTask_Normal_Reward"
local EMCache = require "EMCache.EMCache"

---@type WBP_Activity_JJGame_NormalSubItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.Common.TimerMgr"})

local TaskType = {
    Daily = {1,2},
    Cycle = 3,
    Achievement = 4,
}
---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Text_InfinityNum:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Image_IconInfinity:SetVisibility(UIConst.VisibilityOp.Collapsed)
    
    self.Text_Doing:SetText(GText("UI_Event_MidTerm_InProgress"))
    self.Btn_Jump:SetText(GText("UI_Event_MidTerm_GotoTask"))
    self.Text_WaitRefresh:SetText(GText("UI_Event_MidTerm_RefreshTask"))
    self.Btn_Jump.Button_Area.OnClicked:Add(self,self.OnJumpClicked)
    self.Btn_Jump:SetGamepadIconVisibility(false)
    self.Btn_CanGet.Text_GetReward:SetText(GText("UI_Achievement_GetReward"))
    self.Btn_CanGet.Btn_GetReward.OnClicked:Add(self,self.OnCanGetClicked)
    self.Btn_Controller.OnClicked:Add(self,self.OnControllerClicked)
    self.Avatar = GWorld:GetAvatar()
    self.MidTermConst = DataMgr.MidTermGoalConstant
    self.MidTermGoalEventId = self.MidTermConst["MidTermGoalEventId"].ConstantValue
    self:InitListenEvent()
    self:RefreshBaseInfo()
    
end

function M:Destruct()
    self.Btn_Jump.Button_Area.OnClicked:Clear()
    self.Btn_CanGet.Btn_GetReward.OnClicked:Clear()
    self.Btn_Controller.OnClicked:Clear()
    ReddotManager.RemoveListener(NormalTaskNewReddotName, self)
end

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.TaskId = Content.Id
    self.Owner = Content.Owner
    self.TaskConfig = Content.TaskConfig
    self.TaskProp = Content.TaskProp
    self.JJGameBase = self.Owner.JJGameBase
    self.YesterdayRewardGot = Content.YesterdayRewardGot
    Content.SelfWidget = self
    self._Avatar = GWorld:GetAvatar()
    self.Text_RewardNum:SetText(Content.Point)
    self.Text_Desc:SetText(GText(Content.Desc))
    self.MidTermGoals = self._Avatar.MidTermGoals[self.MidTermGoalEventId] or {}
    self.TaskFinishCount = self.MidTermGoals.TaskFinishCount[self.TaskId] or 0
    self.Progress = self.TaskProp.Progress or 0
    if self.Progress >= self.TaskProp.Target then
        if self.TaskProp.RewardsGot then
            self.WS_Btn:SetActiveWidgetIndex(3)
        else
            self.Content.CanGet = true
            self.WS_Btn:SetActiveWidgetIndex(2)
        end
    elseif Content.TaskConfig.JumpUIId then
        self.WS_Btn:SetActiveWidgetIndex(1)
        self.JumpUIId = Content.TaskConfig.JumpUIId
    else
        self.WS_Btn:SetActiveWidgetIndex(0)
    end
    
    if Content.TaskType == TaskType.Cycle then
        local TaskFinishCount = self.MidTermGoals.TaskFinishCount[self.TaskId] or 0
        self.Text_InfinityNum:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Image_IconInfinity:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self:UpdateInfinityNum(TaskFinishCount)
        if TaskFinishCount > 0 then
            self.Content.CanGet = true
            self.WS_Btn:SetActiveWidgetIndex(2)
            if not self.YesterdayRewardGot then
                self.Btn_CanGet.Btn_GetReward:SetForbidden(true)
            else
                self.Btn_CanGet.Btn_GetReward:SetForbidden(false)
            end
        end
    else
        -- if not self.YesterdayRewardGot then
        --     self.WS_Btn:SetActiveWidgetIndex(4)
        --     self.Text_RewardNum:SetText("?")
        --     self.Text_Desc:SetText(GText("? ? ? ? ? ?"))
        -- else
        local PlayReminder = EMCache:Get("MidTermReminder_"..self.TaskId,true)
        if not PlayReminder then
            self:PlayAnimation(self.VX_Reminder)
            EMCache:Set("MidTermReminder_"..self.TaskId,true,true)
        end
        -- end
    end
    
    if Content.TaskConfig.TargetId then
        if CommonUtils.Size(Content.TaskConfig.TargetId) > 1 then
            self.IsMultiTarget = true
            self.TargetId = Content.TaskConfig.TargetId
        else
            self.IsMultiTarget = false
            self.TargetId = Content.TaskConfig.TargetId[1]
        end
    end
    self:UpdateGetRewardNum()
    --红点
    ReddotManager.AddListenerEx(NormalTaskNewReddotName, self, self.UpdateNormalTaskNewReddot)
    if CommonUtils.GetDeviceTypeByPlatformName() == "Mobile" then
        self:PlayAnimation(self.In) --常规任务由list改为vb，需手动播放入场动画
    end
end

function M:BP_OnEntryReleased()
    ReddotManager.RemoveListener(NormalTaskNewReddotName, self)
end

function M:OnCanGetClicked()
    AudioManager(self):PlayUISound(self, "event:/ui/activity/wenmingboyi_normal_btn_click", nil, nil)
    self.JJGameBase:GetTaskReward(self, self.Owner.Owner, self.TaskId)
end

function M:OnControllerClicked()
    if self.CurInputDevice ~= ECommonInputType.Gamepad then return end
    if self.WS_Btn:GetActiveWidgetIndex() == 2 then
        self:OnCanGetClicked()
    elseif self.WS_Btn:GetActiveWidgetIndex() == 1 then
        self:OnJumpClicked()
    end
end

function M:UpdateGetRewardNum()
    local Avatar = GWorld:GetAvatar()
    local TaskProp = self.TaskProp
    local Progress = TaskProp.Progress or 0
    local Target = TaskProp.Target or 0
    local Num = tostring(Progress) .. "/" .. tostring(Target)
    self.Text_GetRewardNum:SetText(Num)
    self.Text_DoingNum:SetText(Num)
    self.Text_JumpNum:SetText(Num)
end

function M:UpdateInfinityNum(finishCount)
    if finishCount then
        self.Text_InfinityNum:SetText(string.format(GText("UI_Event_MidTerm_RepeatCount"),finishCount))
    end
end

function M:OnJumpClicked()
    PageJumpUtils:JumpToTargetPageByJumpId(self.JumpUIId)
end

function M:OnAchvFinished(TaskId)
    -- 检查TaskId是否匹配
    if TaskId == self.TaskId then
        self.Content.CanGet = true
        self.WS_Btn:SetActiveWidgetIndex(2)
        DebugPrint("任务", self.TaskId, "已完成，可以领取奖励")
        self:UpdateGetRewardNum()
        if self.Content.TaskType == TaskType.Cycle then
            self:AddTimer(0.1,function()
                self:UpdateInfinityNum(self.Avatar.MidTermTasksRecord[self.TaskId].FinishCount)
            end)
        end
    end
end

-- function M:TryIncreaceNormalRewardReddot()
--     local CacheKey = NormalRewardReddotName
--     local CacheData = ReddotManager.GetLeafNodeCacheDetail(NormalRewardReddotName)
--     if CacheData and CacheData[CacheKey] == nil then
--         CacheData[CacheKey] = true
--         ReddotManager.IncreaseLeafNodeCount(NormalRewardReddotName)
--     end
-- end

function M:OnMidTermTaskProgressChange(TaskId, Progress)
    if TaskId == self.TaskId then
        self:UpdateGetRewardNum()
    end
end

--region 手柄
function M:InitListenEvent()
    local PlayerController = self:GetOwningPlayer()
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function M:RefreshBaseInfo()
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.CurGamepadName = CurGamepadName
    local IsUseGamepad = CurInputDevice == ECommonInputType.Gamepad
    if (IsUseGamepad) then
        --手柄
        self.Btn_Controller:SetVisibility(UIConst.VisibilityOp.Visible)
        self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        if self:HasAnyUserFocus() or self:HasFocusedDescendants() then
            self:PlayAnimation(self.Hover)
        end
    else
        self.Btn_Controller:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self:SetVisibility(UIConst.VisibilityOp.Visible)
        self:StopAnimation(self.Hover)
        self:PlayAnimation(self.Normal)
    end
    self.CurInputDevice = CurInputDevice
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if InKeyName == "Gamepad_FaceButton_Bottom" then
        
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if self.CurInputDevice == ECommonInputType.Gamepad then
        self.Btn_Controller:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Btn_Controller:SetFocus()
        self:PlayAnimation(self.Hover)
    end
    return UIUtils.Handle
end

-- function M:BP_GetDesiredFocusTarget()
--     -- if self.CurInputDevice == ECommonInputType.Gamepad then
--     --     return self.Btn_Controller
--     -- end
-- end

function M:OnAddedToFocusPath(InFocusEvent)
    if self.CurInputDevice == ECommonInputType.Gamepad then
        self.Owner.Owner.CurFocusTask = self.Content
        self:PlayAnimation(self.Hover)
        self.Btn_Jump:SetGamepadIconVisibility(true)
        self.Btn_CanGet.Key_GetReward:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.Normal)
    self.Btn_Jump:SetGamepadIconVisibility(false)
    self.Btn_CanGet.Key_GetReward:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

--endregion
function M:UpdateNormalTaskNewReddot(Count)
    if not self.TaskProp then return end
    local CacheKey = self.TaskProp.UniqueID or ""
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(NormalTaskNewReddotName)
    if not CacheData then return end
    if CacheData[CacheKey] and Count > 0 then
        self.New:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.New:SetVisibility(UIConst.VisibilityOp.Hidden)
    end
end

return M