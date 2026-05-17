local ReturnUtils = require "Blueprints.UI.WBP.Activity.Widget.Return.ReturnUtils"
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"
local ReturnActivityController = require "BluePrints.UI.WBP.Activity.Widget.Return.ReturnActivityController"
local Component = {}

function Component:EnterWorld()
    ReturnUtils.RefreshComeBackTaskNewReddot()
    ReturnUtils.RefreshComeBackTaskRewardReddot()
end

function Component:ComeBackGetBackReward(InCallBack, TargetWidget)
	self.logger.info("ComeBackGetBackReward")
    local function Cb(ErrCode,Ret)
        DebugPrint("ComeBackGetBackReward",ErrorCode:Name(ErrCode))
        if InCallBack then
            InCallBack(ErrCode,Ret)
        end
        if ErrCode == ErrorCode.RET_SUCCESS then
            local ComeBackRewardNode = ReddotManager.GetTreeNode("ComeBackReward")
            if ComeBackRewardNode and ComeBackRewardNode.Count > 0 then
                ReddotManager.DecreaseLeafNodeCount("ComeBackReward", ComeBackRewardNode.Count)
            end
            ActivityReddotHelper.RefreshReddotNode(TargetWidget.CurActivityId)
        end
    end
	self:CallServer("ComeBackGetBackReward", Cb) 
end

function Component:ComeBackGetLoginReward(InCallBack, TargetWidget, AllValidIndex)
	self.logger.info("ComeBackGetLoginReward")
    local function Cb(ErrCode,Ret)
        DebugPrint("ComeBackGetLoginReward",ErrorCode:Name(ErrCode))
        if ErrCode == ErrorCode.RET_SUCCESS then
            TargetWidget:RefreshRewardByState()
            ReturnUtils.ShowReturnActiGetItemPage(AllValidIndex, TargetWidget)
            local SignNode = ReddotManager.GetTreeNode("ComeBackSignIn")
            if SignNode then
                local CurCount = SignNode and SignNode.Count or 0
                if CurCount > 0 then
                    ReddotManager.DecreaseLeafNodeCount("ComeBackSignIn", CurCount)
                end
                ActivityReddotHelper.RefreshReddotNode(TargetWidget.CurActivityId)
            end
        end
        if InCallBack then
            InCallBack(ErrCode, Ret)
        end
    end
	self:CallServer("ComeBackGetLoginReward", Cb) 
end

function Component:ComeBackGetQuestProgressReward(InCallBack)
	self.logger.info("ComeBackGetQuestProgressReward")
    local function Cb(ErrCode,Rewards)
        DebugPrint("ComeBackGetQuestProgressReward",ErrorCode:Name(ErrCode))
        if InCallBack then
            InCallBack(ErrCode,Rewards)
        end
    end
	self:CallServer("ComeBackGetQuestProgressReward", Cb) 
end

function Component:OnComeBackActivityOpen(EventId)
    self.logger.info("OnComeBackActivityOpen", EventId)
    local EventMainExcel = DataMgr.EventMain[DataMgr.ComeBackEventConstant.CurrentEventId.ConstantValue]
    if not EventMainExcel then return end
    local Avatar = GWorld:GetAvatar()
    if (ConditionUtils.CheckCondition(Avatar, EventMainExcel.EventUnlockCondition) == false) then
		return false
	end
    if ReturnActivityController then
        ReturnActivityController:TryDisplayReturnWelcomBanner()
    end
    ReturnUtils.RefreshComeBackTaskQuestReddot()
    ReturnUtils.RefreshComeBackTaskNewReddot(true)
end

function Component:GetCurrentComeBackData(EventId)
    local EventId = EventId or DataMgr.ComeBackEventConstant.CurrentEventId.ConstantValue
    return self.ComeBacks[EventId]
end

function Component:IsComeBackPhaseUnlocked(EventId, PhaseIndex, PhaseUnlockInterval)
    local EventId = EventId or DataMgr.ComeBackEventConstant.CurrentEventId.ConstantValue
    if not ActivityUtils.CheckComeBackEventIsOpen(EventId) then
        return false
    end
    if not PhaseUnlockInterval then
        local ComeBackQuestConf = ReturnUtils.GetCurrentComeBackQuestInfo()
        if not ComeBackQuestConf then
            return false
        end
        PhaseUnlockInterval = ComeBackQuestConf.PhaseUnlockInterval
    end
    local EventDuration = DataMgr.ComeBackEventConstant.EventDuration.ConstantValue
    local UnlockTime = self.ComeBackExpireTime - EventDuration * CommonConst.SECOND_IN_DAY + (PhaseIndex-1) * PhaseUnlockInterval * CommonConst.SECOND_IN_HOUR
    return TimeUtils.NowTime() >= UnlockTime
end

function Component:GetPhaseUnlockTime(PhaseIndex, PhaseUnlockInterval)
    if not PhaseUnlockInterval then
        local ComeBackQuestConf = ReturnUtils.GetCurrentComeBackQuestInfo()
        if not ComeBackQuestConf then
            return ""
        end
        PhaseUnlockInterval = ComeBackQuestConf.PhaseUnlockInterval
    end
    local EventDuration = DataMgr.ComeBackEventConstant.EventDuration.ConstantValue
    local UnlockTime = self.ComeBackExpireTime - EventDuration * CommonConst.SECOND_IN_DAY + (PhaseIndex-1) * PhaseUnlockInterval * CommonConst.SECOND_IN_HOUR
    return UIUtils.GetLeftTimeStrStyle1(UnlockTime)
end

function Component:OnComeBackDailyRefresh(EventId)
    self.logger.info("OnComeBackDailyRefresh", EventId)
    self:RequestSyncNowTime(function()
        EventManager:FireEvent(EventID.OnComeBackNewPhaseUnlocked)
        ReturnUtils.RefreshComeBackTaskNewReddot()
        ReturnUtils.RefreshComeBackTaskQuestReddot()
    end)
end

function Component:RequestSyncNowTime(InCallback)
    local function cb(ret, timestamp)
        if ret == ErrorCode.RET_SUCCESS then
            TimeUtils.OnRequestSetNowTime(timestamp)
            if InCallback then
                InCallback(timestamp)
            end
        end
    end
    self:CallServer("RequestSetNowTime", cb, TimeUtils.NowTime())
end

return Component