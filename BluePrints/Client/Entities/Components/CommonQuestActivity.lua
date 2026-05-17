local ReturnUtils = require "BluePrints.UI.WBP.Activity.Widget.Return.ReturnUtils"
local GuildWarUtils = require "BluePrints.UI.WBP.Activity.Widget.GuildWar.GuildWarUtils"
local AprilFoolDayUtils = require "BluePrints.UI.WBP.Activity.Widget.Fool.AprilFoolDayUtils"
local AutoChessRewardModel = require "BluePrints.UI.AutoChess.WBP_AutoChess_Reward_Model"
local ActivityUtils = require "BluePrints.UI.WBP.Activity.ActivityUtils"
local SoloTreasure = require "BluePrints.UI.WBP.SoloTreasure.Widget.WBP_SoloTreasure_Reward_Model"
local Component = {}
function Component:EnterWorld()
    GuildWarUtils.RefreshQuestReddot(true)
    EventManager:AddEvent(EventID.OnLoginSuccess, self, self.OnLoginSuccess)
    ReturnUtils.RefreshComeBackTaskQuestReddot()
    if ActivityUtils.CheckEventIsOpen(CommonConst.SoloTreasureEventId,nil,false) then
        local NeedRefresh = false
        if DataMgr.EventPortal and DataMgr.EventPortal[CommonConst.SoloTreasureEventId] then
            local Condition = DataMgr.EventPortal[CommonConst.SoloTreasureEventId].JumpUnlockCondition
            local Avatar = GWorld:GetAvatar()
            if Condition and ConditionUtils.CheckCondition(Avatar, Condition) then
                NeedRefresh = true
            end
            if NeedRefresh then
                SoloTreasure:RefreshReddotInfo(true)
            end
        end
    end
end

function Component:LeaveWorld()
    EventManager:RemoveEvent(EventID.OnLoginSuccess, self)
end

function Component:CommonQuestActivityGetPhaseReward(InCallBack,EventId, QuestPhaseId)
    self.logger.info("CommonQuestActivityGetPhaseReward", EventId, QuestPhaseId)
    local function Cb(Ret, Rewards)
        if not ErrorCode:Check(Ret) then
			DebugPrint("CommonQuestActivityGetPhaseReward",ErrorCode:Name(Ret))
			return
		end
        if InCallBack then
            InCallBack(Ret, Rewards)
        end
    end
	self:CallServer("CommonQuestActivityGetPhaseReward", Cb, EventId, QuestPhaseId) 
end

function Component:CommonQuestActivityGetReward(InCallBack,EventId, CommonQuestId)
    self.logger.info("CommonQuestActivityGetReward", EventId, CommonQuestId)
    local function Cb(Ret, Rewards)
        if not ErrorCode:Check(Ret) then
            DebugPrint("CommonQuestActivityGetReward",ErrorCode:Name(Ret))
			return
		end
        if InCallBack then
            InCallBack(Ret, Rewards)
        end
    end
	self:CallServer("CommonQuestActivityGetReward", Cb, EventId, CommonQuestId) 
end

function Component:CommonQuestActivityGetFinishReward(InCallBack, Id)
    self.logger.info("CommonQuestActivityGetFinishReward", Id)
    local function Cb(Ret, Rewards)
        if not ErrorCode:Check(Ret) then
            DebugPrint("CommonQuestActivityGetFinishReward",ErrorCode:Name(Ret))
			return
		end
        if InCallBack then
            InCallBack(Ret, Rewards)
        end
    end
	self:CallServer("CommonQuestActivityGetFinishReward", Cb, Id) 
end

function Component:CheckCommonQuestActivityHasRewardToGet(EventId, QuestPhaseId)
    if EventId and QuestPhaseId then
        local CommonQuestActivity = self.CommonQuestActivity[EventId] or {}
        for QuestId,Info in pairs(CommonQuestActivity) do
            local CommonQuestDetail = DataMgr.CommonQuestDetail[QuestId]
            if CommonQuestDetail and CommonQuestDetail.QuestPhaseId == QuestPhaseId and not Info.RewardsGot and Info.Progress >= Info.Target then
                return true
            end
        end
        return false
    else
        return false
    end
end

function Component:CheckCommonQuestActivityHasFinishRewardToGet(FinishRewardId)
    if not FinishRewardId then
        return false
    end
    local CommonQuestRewardData = DataMgr.CommonQuestReward[FinishRewardId]
    if not CommonQuestRewardData then
        return false
    end
    local EventId = CommonQuestRewardData.EventId
    local QuestIds = CommonQuestRewardData.QuestId or {}
    if EventId and QuestIds then
        if not self.CommonQuestBases[EventId] then
            return false
        end
        if self.CommonQuestBases[EventId]:IsFinishRewardGot(FinishRewardId) then
            return false
        end
        local CommonQuestActivity = self.CommonQuestActivity[EventId]
        if not CommonQuestActivity then
            return false
        end
        for _,QuestId in pairs(QuestIds) do
            if not CommonQuestActivity[QuestId] then
                return false
            end
            if CommonQuestActivity[QuestId].Progress < CommonQuestActivity[QuestId].Target then
                return false
            end
        end
        return true
    else
        return false
    end
end

function Component:_OnPropChangeCommonQuestActivity(EventIDs, OldValue)
    GuildWarUtils.RefreshQuestReddot()
    AprilFoolDayUtils.RefreshQuestReddot()
    ReturnUtils.RefreshComeBackTaskQuestReddot()
    if ActivityUtils.CheckEventIsOpen(CommonConst.SoloTreasureEventId,nil,false) then
        local NeedRefresh = false
        if DataMgr.EventPortal and DataMgr.EventPortal[CommonConst.SoloTreasureEventId] then
            local Condition = DataMgr.EventPortal[CommonConst.SoloTreasureEventId].JumpUnlockCondition
            local Avatar = GWorld:GetAvatar()
            if Condition and ConditionUtils.CheckCondition(Avatar, Condition) then
                NeedRefresh = true
            end
            if NeedRefresh then
                SoloTreasure:RefreshReddotInfo()
            end
        end
    end
    if ActivityUtils.CheckEventIsOpen(CommonConst.AutoChessEventId,nil,false) then
         AutoChessRewardModel:RefreshReddotInfo()
    end
    for _, EventId in pairs(EventIDs) do
        if EventId == CommonConst.AutoChessEventId or EventId == CommonConst.SoloTreasureEventId then
            EventManager:FireEvent(EventID.RefreshAcvitityRewardPanel)
        end
    end

end
function Component:OnLoginSuccess()
    AprilFoolDayUtils.RefreshQuestReddot(true)
     if ActivityUtils.CheckEventIsOpen(CommonConst.AutoChessEventId,nil,false) then
        AutoChessRewardModel:RefreshReddotInfo(true)
    end
    if ActivityUtils.CheckEventIsOpen(CommonConst.SoloTreasureEventId,nil,false) then
        local NeedRefresh = false
        if DataMgr.EventPortal and DataMgr.EventPortal[CommonConst.SoloTreasureEventId] then
            local Condition = DataMgr.EventPortal[CommonConst.SoloTreasureEventId].JumpUnlockCondition
            local Avatar = GWorld:GetAvatar()
            if Condition and ConditionUtils.CheckCondition(Avatar, Condition) then
                NeedRefresh = true
            end
            if NeedRefresh then
                SoloTreasure:RefreshReddotInfo(true)
            end
        end
    end
end

return Component