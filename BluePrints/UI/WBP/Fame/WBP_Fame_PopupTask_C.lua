--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local RegionFameController = require("BluePrints.UI.WBP.Fame.RegionFameController")
local RegionFameModel = RegionFameController:GetModel()

---@type WBP_Fame_PopupTask_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.BtnAccept.Button_Area.OnClicked:Add(self, self.OnAcceptBtnClicked)
    self.BtnAbandon.Button_Area.OnClicked:Add(self, self.OnAbandonBtnClicked)
    self.BtnReward.Button_Area.OnClicked:Add(self, self.OnRewardBtnClicked)
end

function M:Destruct()
    rawset(self, "InitedGamePadKey", nil)
    self.BtnAccept.Button_Area.OnClicked:Remove(self, self.OnAcceptBtnClicked)
    self.BtnAbandon.Button_Area.OnClicked:Remove(self, self.OnAbandonBtnClicked)
    self.BtnReward.Button_Area.OnClicked:Remove(self, self.OnRewardBtnClicked)
end

function M:Init(Content)
    rawset(self, "TaskId", Content.TaskId)
    rawset(self, "RegionId", Content.RegionId)
    rawset(self, "MaxLevel", Content.MaxLevel)
    -- 当前接取的任务ID
    rawset(self, "DoingTaskId", Content.DoingTaskId)
    rawset(self, "HasCanClaimTask", Content.HasCanClaimTask)
    rawset(self, "CurrentLevel", Content.CurrentLevel)
    -- rawset(self, "AcceptRecurringTaskCallback", Content.AcceptRecurringTaskCallback)
    rawset(self, "AbandonRecurringTaskCallback", Content.AbandonRecurringTaskCallback)
    rawset(self, "GetRecurringTaskRewardCallback", Content.GetRecurringTaskRewardCallback)
    -- 接取任务时的时间戳 可以为nil
    rawset(self, "DoingTaskTimestamp", Content.DoingTaskTimestamp)
    rawset(self, "Parent", Content.Parent)
    rawset(self, "OnMenuOpenChanged", Content.OnMenuOpenChanged)

    -- 当前任务的进度
    local TaskProgress = RegionFameModel:GetTargetRecurringTaskProgress(self.RegionId, self.TaskId)
    rawset(self, "TaskProgress", TaskProgress)
    rawset(self, "TaskState", Content.TaskState)
    self:InitTaskDetail()

    -- EMUIAnimationSubsystem:EMPlayAnimation(self, self.In)
    self:UpdateGamePadStyle()
end

-- 更新手柄滑动提示
function M:UpdateGamePadeSwipeTip()
    local TargetList = self.ScrollBox_1
    -- 文本是否超框
    local TextOverflow = TargetList:GetScrollOffsetOfEnd() ~= 0
    if TextOverflow then
        self.WBP_Com_KeyImg:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.WBP_Com_KeyImg:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:InitTaskDetail()
    local RecurringTaskData = DataMgr.RecurringTask[self.TaskId]
    if not RecurringTaskData then
        return
    end

    local TaskDetail = RecurringTaskData.StarterQuestDes
    local TempStr = {
        [1] = "副本任务描述1（临时）\n副本任务描述2（临时）\n副本任务描述3（临时）\n副本任务描述4（临时）\n副本任务描述5（临时）\n副本任务描述6（临时）\n副本任务描述7（临时）\n副本任务描述8（临时）\n副本任务描述9（临时）\n副本任务描述10（临时）",
        [2] = "副本任务描述（临时）"
    }
    TaskDetail = TaskDetail and TaskDetail or TempStr[math.random(1,2)]
    local TaskProgressText = RegionFameModel:GetTaskDesProgress(self.RegionId, self.TaskId)
    self.TextTaskDetails_1:SetText(string.format(GText(TaskDetail), TaskProgressText))
    self.TextTaskCondition:SetText(GText("RecurringTask_Condition"))
    self.TextTaskReward:SetText(GText("RecurringTask_Reward"))

    local TaskType = RecurringTaskData.Type
    if TaskType == 1 then
        self.Condition:SetVisibility(UIConst.VisibilityOp.Hidden)
    else
        self.Condition:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end

    local TaskConditionCount = #RecurringTaskData.ExpCount
    local MaxTaskCount = 3
    for i = 1, MaxTaskCount do
        local StarCondition = self["StarCondition0"..i]
        local StarReward = self["StarReward0"..i]
        if i <= TaskConditionCount then
            local ConditionCompleted = self.TaskProgress >= RecurringTaskData.Times[i]
            if TaskType == 1 then
                -- 单一任务不显示任务条件
                StarCondition:SetVisibility(UIConst.VisibilityOp.Hidden)
            else
                local ConditionDescribe = RecurringTaskData["TaskCondition"..i]
                ConditionDescribe = ConditionDescribe and ConditionDescribe or "副本阶段"..i.."任务描述（临时）"

                if ConditionCompleted then
                    StarCondition.StarSwitcher:SetActiveWidgetIndex(1)
                    StarCondition.TextDetails:SetRenderOpacity(1)
                else
                    StarCondition.StarSwitcher:SetActiveWidgetIndex(0)
                    StarCondition.TextDetails:SetRenderOpacity(0.6)
                end

                StarCondition.TextDetails:SetText(GText(ConditionDescribe))
                StarCondition:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            end
            local bCanGet = false
            if ConditionCompleted and self.TaskState ~= CommonConst.RecurringTaskState.AlreadyClaimed then
                bCanGet = true
            end

            local Content = {}
            Content.Type = TaskType
            Content.Level = i

            Content.Id = RecurringTaskData.Resource
            local ResourceInfo = DataMgr.Resource[RecurringTaskData.Resource]
            Content.Icon = ResourceInfo.Icon
            Content.ItemType = "Resource"
            Content.Count = RecurringTaskData.ExpCount[i]
            Content.IsShowDetails = true
            Content.bCanGet = bCanGet
            Content.CanGetStyle = "Gold"
            -- 物品详情Tips 开关状态改变回调
            Content.OnMenuOpenChangedEvents = {Obj = self.Parent, Callback = self.OnMenuOpenChanged}
            StarReward:Init(Content)
            StarReward:SetVisibility(UIConst.VisibilityOp.Visible)
        else
            StarCondition:SetVisibility(UIConst.VisibilityOp.Hidden)
            StarReward:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end

    -- 无遮罩：当前任务是正在进行的任务（或无任务进行中）且任务等级是可接取最高等级，或任务处于可领奖状态
    local bIsCurrentOrNoTask = (self.DoingTaskId == nil or self.DoingTaskId == self.TaskId)
    local bShouldHideMask = (bIsCurrentOrNoTask and self.CurrentLevel >= self.MaxLevel)
                         or (self.TaskState == CommonConst.RecurringTaskState.CanClaim)

    -- 有其他任务可领取时，未接取的任务强制显示遮罩以拦截点击
    local bForceShowMask = self.HasCanClaimTask and self.TaskState == CommonConst.RecurringTaskState.NotAccept
    local bShowDone = not bShouldHideMask or bForceShowMask
    
    self.Done:SetVisibility(bShowDone and UIConst.VisibilityOp.Visible or UIConst.VisibilityOp.Collapsed)

    self:RefreshBtnState()
    self:RefreshCountdown()
end

function M:RefreshCountdown()
    if not self.DoingTaskTimestamp or self.DoingTaskId ~= self.TaskId then
        self:RemoveTimer("UpdateRemainingTime",true)
        self.Group_Time:SetVisibility(UIConst.VisibilityOp.Collapsed)
        return
    end
    local UpdateRemainingTime = function ()
        local RemainingTimeText = UIUtils.GetRemainingTimeByTimestamp(self.DoingTaskTimestamp, true)
        self.TextTime:SetText(RemainingTimeText)
    end

    UpdateRemainingTime()
    self:AddTimer(1, UpdateRemainingTime, true, 0, "UpdateRemainingTime", true)
    self.Group_Time:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:RefreshBtnState()
    --- 隐藏所有按钮的情况 
    --- 等级小于正在进行的任务等级，并且任务没有开始过
    local ActiveBtnIndex = 0
    if self.CurrentLevel < self.MaxLevel and self.TaskState == CommonConst.RecurringTaskState.NotAccept then
        -- 当前任务不可接取
        ActiveBtnIndex = 4
        self.BtnDisable:SetText(GText("RecurringTask_CantAccept"))
        self.WidgetSwitcher_0:SetActiveWidgetIndex(ActiveBtnIndex)
        return
    end

    -- 当前循环任务是否已经领奖
    if self.TaskState == CommonConst.RecurringTaskState.AlreadyClaimed then
        ActiveBtnIndex = 3
        self.HintDone:SetText(GText("RecurringTask_Completed"))
    elseif self.TaskState == CommonConst.RecurringTaskState.CanClaim then
        ActiveBtnIndex = 2
        self.BtnReward:SetText(GText("UI_GameEvent_ClaimReward"))
    elseif self.TaskState == CommonConst.RecurringTaskState.Doing then
        ActiveBtnIndex = 1
        self.BtnAbandon:SetTextColor(self.AbandonText_Color)
        self.BtnAbandon:SetText(GText("RecurringTask_Abandon"))
    else
        if self.DoingTaskId == nil and not self.HasCanClaimTask then
            -- 当前没有进行中的任务，且无可领取的任务
            ActiveBtnIndex = 0
            self.BtnAccept:SetText(GText("RecurringTask_Accept"))
        else
            -- 当前任务不可接取（有进行中或可领取的任务）
            ActiveBtnIndex = 4
            self.BtnDisable:SetText(GText("RecurringTask_CantAccept"))
        end
    end
    self.WidgetSwitcher_0:SetActiveWidgetIndex(ActiveBtnIndex)
    self.WidgetSwitcher_0:SetVisibility(UIConst.VisibilityOp.Visible)
end

function M:OnAcceptBtnClicked()
    if self.DoingTaskId ~= nil or self.HasCanClaimTask then
        return
    end

	local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:TakeRecurringQuest(self.RegionId, self.TaskId, function(Ret, ReputationId, QuestId)
            DebugPrint("WYX AcceptRecurringTaskCallback", Ret, ReputationId, QuestId)
            if Ret == ErrorCode.RET_SUCCESS then
                self.Parent.RefreshRecurringTaskDetail(self.Parent)
                self:PlayAnimation(self.Click)
                return
            end

            local Error = DataMgr.ErrorCode[Ret]
            if Error ~= nil then
                UIManager(self):ShowError(Ret, 1.5)
            else
                UIManager(self):ShowUITip(UIConst.Tip_CommonToast, string.format("ErrorCode :%d", Ret))
            end
        end)
    end
end

function M:OnAbandonBtnClicked()
	local Avatar = GWorld:GetAvatar()
    if Avatar then
        local Params = {}
        Params.RightCallbackFunction = function()
            Avatar:CancelRecurringQuest(self.RegionId, self.TaskId, self.AbandonRecurringTaskCallback)
        end
        Params.LeftCallbackFunction = function()
            self:AddTimer(0.25, function()
                self.Parent:SetFocus()
            end)
        end
        UIManager(self):ShowCommonPopupUI(100302, Params)
    end
end

function M:OnRewardBtnClicked()
	local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:GetRecurringQuestReward(self.RegionId, self.TaskId, self.GetRecurringTaskRewardCallback)
    end
end

function M:Destruct()
    self:RemoveTimer("UpdateRemainingTime",true)
end

---------------------------------手柄--------------------------------
-- 处理手柄按下A键
function M:HandleGamePadPressA()
    if self.TaskState == CommonConst.RecurringTaskState.NotAccept then
        self:OnAcceptBtnClicked()
    elseif self.TaskState == CommonConst.RecurringTaskState.Doing then
        self:OnAbandonBtnClicked()
    elseif self.TaskState == CommonConst.RecurringTaskState.CanClaim then
        self:OnRewardBtnClicked()
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click", "", nil)
end

function M:FocusReward()
    self.StarReward01.Item_S:SetFocus()
    rawset(self, "bFocusReward", true)
end

function M:Handle_OnGamePadButtonDown(InKeyName)
    local IsEventHandled = false
    if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
        self:HandleGamePadPressA()
        IsEventHandled = true
    elseif InKeyName == UIConst.GamePadKey.LeftThumb then
        self:FocusReward()
        IsEventHandled = true
    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
        if self.bFocusReward then
            self:SetFocus()
            rawset(self, "bFocusReward", false)
            IsEventHandled = true
        end
    end
    return IsEventHandled
end

function M:Handle_OnPCButtonDown(InKeyName)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:Handle_OnGamePadButtonDown(InKeyName)
    else
        IsEventHandled = self:Handle_OnPCButtonDown(InKeyName)
    end

    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local Speed = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
    if (InKeyName == "Gamepad_RightY") then
        local TargetList = self.ScrollBox_1
        local CurScrollOffset = TargetList:GetScrollOffset()
        local ScrollOffset = math.clamp(CurScrollOffset - Speed,0, TargetList:GetScrollOffsetOfEnd())
        TargetList:SetScrollOffset(ScrollOffset)
    end
    return self.Unhandle
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if self.Parent.CurInputDeviceType == ECommonInputType.Gamepad then
        rawset(self, "bFocused", true)
        self:PlayAnimation(self.Hover)
        self:UpdateGamePadStyle()
        self.Parent:SetFocusRecurringTask(self)
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnFocusLost(InFocusEvent)
    rawset(self, "bFocusReward", false)
    if self.Parent.CurInputDeviceType == ECommonInputType.Gamepad then
        if self.bFocused then
            self:PlayAnimation(self.UnHover)
        end
        rawset(self, "bFocused", false)
        self:UpdateGamePadStyle()
    end
end

function M:UpdateGamePadStyle()
    if not self.Parent then
        return
    end
    if self.Parent.CurInputDeviceType == ECommonInputType.Gamepad and self.bFocused then
        self:UpdateMouseGamePadImage()
        self:UpdateGamePadeSwipeTip()
        self.WBP_Com_KeyImg_10:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self:SetAllBtnPCVisibility(false)
    else
        if self.bFocused then
            self:PlayAnimation(self.UnHover)
        end
        self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.WBP_Com_KeyImg_10:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self:SetAllBtnPCVisibility(true)
    end
end

function M:SetAllBtnPCVisibility(IsShow)
    self.BtnAccept:SetPCVisibility(IsShow)
    self.BtnAbandon:SetPCVisibility(IsShow)
    self.BtnReward:SetGamePadVisibility(IsShow and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:UpdateMouseGamePadImage()
    if self.InitedGamePadKey then
        return
    end
    local CurGamepadName = self.Parent.CurGamepadName
    -- 手柄资源选择按键图片
    self.WBP_Com_KeyImg:CreateCommonKey({KeyInfoList = {{
        Type = "Img",
        ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("RV", CurGamepadName)}
    }})
    self.WBP_Com_KeyImg_10:CreateCommonKey({KeyInfoList = {{
        Type = "Img",
        ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("LS", CurGamepadName)}
    }})

    rawset(self, "InitedGamePadKey", true)
end

return M
