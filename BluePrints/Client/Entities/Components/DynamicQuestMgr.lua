local Component = {}
local TimeUtils = require "Utils.TimeUtils"
local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
--检测动态事件是否处于不可触发状态
-- 动态事件在派遣列表中，可触发；
-- 不可触发事件的状态包括：
-- 玩家正处于事件触发状态中
-- 玩家正处于事件触发成功、事件完成的公共重置时间中（GCD）
-- 事件自身的CD中
-- 当日已完成的限次事件的次数已经超过上限
-- 事件的触发条件是否满足
-- 事件触发的玩家等级是否满足
function Component:CheckDynamicQuestIsInCantTriggerState(DynamicQuestId)
    DynamicQuestId = tonumber(DynamicQuestId)
    if self:IsInDynamicEvent() then
        DebugPrint("[动态事件]尝试触发动态事件Id"..tostring(DynamicQuestId).."失败，任务处于进行中 "..TimeUtils.TimeToHMSStr())
        return false
    end
    if self.CurrentDispatchList:HasValue(DynamicQuestId) then
        return true
    end
    local DynamicQuest = self.DynamicQuests[DynamicQuestId]
    if DynamicQuest then
        if DynamicQuest:IsInCD() then
            DebugPrint("[动态事件]尝试触发动态事件Id"..tostring(DynamicQuestId).."失败，任务处于CD中 "..TimeUtils.TimeToHMSStr())
            return false
        end
        local NowTime = TimeUtils.NowTime()
        if (NowTime - self.DynamicQuestGlobalCD) < DataMgr.GlobalConstant.DynQuestGCD.ConstantValue then
            DebugPrint("[动态事件]尝试触发动态事件Id"..tostring(DynamicQuestId).."失败，任务处于全局CD中 "..TimeUtils.TimeToHMSStr())
            return false
        end
        if DynamicQuest.DayLimit and self.TodayLimitDynamicQuestTimes == DataMgr.GlobalConstant.DynLimitCount.ConstantValue then
            DebugPrint("[动态事件]尝试触发动态事件Id"..tostring(DynamicQuestId).."失败，任务处于当日次数上限中 "..TimeUtils.TimeToHMSStr())
            return false
        end
        if DynamicQuest.ChanceCondition then
            if not self:CheckCondition(DynamicQuest.ChanceCondition) then
                DebugPrint("[动态事件]尝试触发动态事件Id"..tostring(DynamicQuestId).."失败，任务触发条件不满足 "..TimeUtils.TimeToHMSStr())
                return false
            end
        end
        local DynamicQuestInfo = DynamicQuest:Data()
        if DynamicQuestInfo and DynamicQuestInfo.PlayerLevel then
            local PlayerLevel = DynamicQuestInfo.PlayerLevel
            if self.Level < PlayerLevel[1] or self.Level > PlayerLevel[2] then
                DebugPrint("[动态事件]尝试触发动态事件Id"..tostring(DynamicQuestId).."失败，任务触发等级不满足 "..TimeUtils.TimeToHMSStr())
                return false
            end
        end
    else
        return false
    end
    return true
end

--检查所有动态事件是否已触发
function Component:CheckAllDynamicQuestAlreadyTrigger(DynamicQuestId)
    for DQId,DynamicQuest in pairs(self.DynamicQuests) do
        if DQId ~= DynamicQuestId then
            if DynamicQuest.LastEndTime > 0 then
                return false
            end
        end
    end
    return true
end

--检测某个动态事件是否是首次触发,用于触发开始事件正在进行中时
function Component:CheckDynamicQuestIsFirstTrigger(DynamicQuestId)
    local DynamicQuest = self.DynamicQuests[DynamicQuestId]
    if DynamicQuest then
        local IsDoing = DynamicQuest:IsDoing()
        if IsDoing and (DynamicQuest.StartTime and DynamicQuest.StartTime > 0)
        and (not DynamicQuest.LastEndTime or DynamicQuest.LastEndTime == 0) then
            return true
        end
    end
    return false
end

--服务端通知客户端动态事件已激活
function Component:OnActivateDynamicQuest(DynamicQuestId)
    self.logger.debug("OnActivateDynamicQuest", DynamicQuestId)
    --加载过程中不激活，由加载结束后统一激活
    local Avatar = GWorld:GetAvatar()
    if Avatar and not Avatar:IsInEnterBigWorld() then
        if not ClientEventUtils:CheckDynamicEventStarted(DynamicQuestId) then
            --ClientEventUtils:ClearCurrentActiveDynamicEvent()
            ClientEventUtils:StartDynamicEvent(DynamicQuestId)
        else
            local CurrentEvent=ClientEventUtils:GetCurrentActiveDynamicEvent(DynamicQuestId)
            CurrentEvent:ActivateTrigger()
        end
        --ClientEventUtils:StartDynamicEvent(DynamicQuestId)
    end
end

--通知服务端开始动态事件判定
function Component:TriggerDynamicQuestBegin(DynamicQuestId,InCallback)
    DynamicQuestId = tonumber(DynamicQuestId)
    self.logger.debug("TriggerDynamicQuestBegin", DynamicQuestId)
	local function Callback(Ret)
		self.logger.debug("TriggerDynamicQuestBegin callback", Ret, DynamicQuestId)
        if InCallback then
            InCallback(Ret)
        end
    end
    self:CallServer("TriggerDynamicQuestBegin", Callback, DynamicQuestId)
end

-- function Component:OnDynamicQuestBegin(DynamicQuestId)
--     self.logger.debug("OnDynamicQuestBegin", DynamicQuestId)
-- end

--通知服务端动态事件结束
---@param TriggerType String:Success,Fail
function Component:TriggerDynamicQuestEnd(DynamicQuestId,TriggerType,InCallback,DialogueId)
    local NewDialogueId = "-1"
    if DialogueId ~= nil then
        NewDialogueId = DialogueId
    end
    NewDialogueId = tonumber(NewDialogueId)
    DynamicQuestId = tonumber(DynamicQuestId)
    self.logger.debug("TriggerDynamicQuestEnd", DynamicQuestId,TriggerType)
	local function Callback(Ret)
		self.logger.debug("TriggerDynamicQuestEnd callback", Ret, DynamicQuestId,TriggerType,NewDialogueId)
        if InCallback then
            InCallback()
        end
    end
    self:CallServer("TriggerDynamicQuestEnd", Callback, DynamicQuestId,TriggerType,NewDialogueId)
end

--保底时间到期后服务端通知动态事件结束
function Component:OnDynamicQuestEnd(DynamicQuestId)
    self.logger.debug("OnDynamicQuestEnd", DynamicQuestId)
    local Avatar = GWorld:GetAvatar()
    --加载过程中不主动结束，实际触发盒已经销毁
    if Avatar and not Avatar:IsInEnterBigWorld() then
    local DynamicEvent=ClientEventUtils:GetCurrentDoingDynamicEvent()
    if DynamicEvent then
          DynamicEvent:OnFinishEvent(false)
    end
    end
end

--今日动态事件次数变更
---@param IsLimit Bool true-达上限；false-重置
function Component:OnDynamicQuestDayLimitTimesChange(IsLimit)
    self.logger.debug("OnDynamicQuestDayLimitTimesChange", IsLimit)
end

return Component