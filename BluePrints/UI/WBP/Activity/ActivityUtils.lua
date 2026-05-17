require "UnLua"
local TimeUtils = require "Utils.TimeUtils"
local ActivityCommon = require "BluePrints.UI.WBP.Activity.ActivityCommon"
local EMCache = require "EMCache.EMCache"
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"
local EastSeasonQuestUtils = require "BluePrints.UI.WBP.Activity.Widget.EastSeason.EastSeasonQuestUtils"

local ActivityUtils = {}

ActivityUtils.EnumPlayerTaskState = {
	NotStart = 1,
	NotComplete = 2,
	NotUnlock = 3,
	NotGetReward = 4,
	Completed = 5,
}

ActivityUtils.EnumPlayerSignRewardState = {
	NotSign = 1,
	SignedNotRecv = 2,
	Completed = 3,
}

ActivityUtils.ServerPropertyName = {
	DailyLogin = "DailyLogin",
	StarterQuests = "StarterQuests",
	CharTrial = "CharTrial",
	OnlyClient = "OnlyClient",
	ConditionReward = "ConditionReward",
}

ActivityUtils.Id2ReddotNodeName = {
	[103001] = "RougeMain",
	[103002] = "AbyssMain",
	[106001] = "TrainingLevel",
	[103005] = "ZhiliuReward",
	[103006] = "MidTermGoal",
}

local AccessoryDropActivityIds = {
    103020
}

function ActivityUtils.CheckEventIsInActiveTime(EventID, EventMainExcel)
	local NowTime = TimeUtils.NowTime()
	if (EventMainExcel == nil) then
		EventMainExcel = DataMgr.EventMain[EventID]
	end
	if not EventMainExcel then
		return false
	end

	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return false
	end
	local bServerActivityTimeOpen = nil
	if EventID and Avatar.ActivityTimeOpen and Avatar.ActivityTimeOpen[EventID] ~= nil and type(Avatar.ActivityTimeOpen[EventID]) == "table" then
		if next(Avatar.ActivityTimeOpen[EventID]) then
			bServerActivityTimeOpen = true
		else
			bServerActivityTimeOpen = false
		end
	elseif EventID and Avatar.ActivityTimeOpen and Avatar.ActivityTimeOpen[EventID] ~= nil and type(Avatar.ActivityTimeOpen[EventID]) == "boolean" then
		bServerActivityTimeOpen = Avatar.ActivityTimeOpen[EventID]
	else
		bServerActivityTimeOpen = false
	end
	
	if bServerActivityTimeOpen then
		-- 活动在服务端处于开启时间
		return true
	else
		local RealEndTime = EventMainExcel.RewardEndTime == nil and EventMainExcel.EventEndTime or EventMainExcel.RewardEndTime
		local StartTime = EventMainExcel.EventStartTime or 0
		if (RealEndTime and NowTime >= RealEndTime:GetTime()) or (StartTime and NowTime < StartTime:GetTime()) then
			-- 活动结束或未开始
			return false
		elseif (EventMainExcel.EventEndCondition and ConditionUtils.CheckCondition(Avatar, EventMainExcel.EventEndCondition)) then
			-- 活动结束条件达成
			return false
		end
	end
	return true
end

---@param EventID number 表里填的EventID
---@param EventMainExcel table 额外的配置信息，如果不填的话，直接用Event.xlsx之中对应的Config
---@param IsUseRewardTime boolean 是否用奖励时间，默认用的是活动结束时间（奖励可领取时间有可能比活动时间晚，此时入口仍然需要开放）
---@param UnlockRuleName string 系统解锁的条件名字（某个活动开启的前置条件）
function ActivityUtils.CheckEventIsOpen(EventID, EventMainExcel, IsUseRewardTime, UnlockRuleName)
	if ActivityCommon.GlobalPakForbidTabId[EventID] and UE.AHotUpdateGameMode.IsGlobalPak() then
		return false
	end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
	local NowTime = TimeUtils.NowTime()
    if (EventMainExcel == nil) then
        EventMainExcel = DataMgr.EventMain[EventID]
    end

	if not EventMainExcel then
		return false
	end

	-- 判断活动是否处于开启状态
	if (not Avatar.ActivityTimeOpen) then
		return false
	end

	local bServerActivityTimeOpen = nil
	if EventID and Avatar.ActivityTimeOpen and Avatar.ActivityTimeOpen[EventID] ~= nil and type(Avatar.ActivityTimeOpen[EventID]) == "table" then
		if next(Avatar.ActivityTimeOpen[EventID]) then
			bServerActivityTimeOpen = true
		else
			bServerActivityTimeOpen = false
		end
	elseif EventID and Avatar.ActivityTimeOpen and Avatar.ActivityTimeOpen[EventID] ~= nil and type(Avatar.ActivityTimeOpen[EventID]) == "boolean" then
		bServerActivityTimeOpen = Avatar.ActivityTimeOpen[EventID]
	else
		bServerActivityTimeOpen = false
	end

	if not bServerActivityTimeOpen then
		local IsActivityOpenAndInRewardTime = false
		local IsNotEventEndTimeAndPermanenEventTime = false
		local IsActivityOpenAndInEventEndTime = false
		local IsNotEventEndTimeAndNotPermanenEventTime = false
		local bEventIsInActiveTime = ActivityUtils.CheckEventIsInActiveTime(EventID, EventMainExcel)
		--没配EventEndTime 但配了PermanenEventTime,且大于EventStartTime
		if bEventIsInActiveTime and (not EventMainExcel.EventEndTime) and EventMainExcel.PermanenEventTime then
			IsNotEventEndTimeAndPermanenEventTime = true
		end
		--没配EventEndTime 且没配PermanenEventTime,且大于EventStartTime
		if bEventIsInActiveTime and (not EventMainExcel.EventEndTime) and (not EventMainExcel.PermanenEventTime) then
			IsNotEventEndTimeAndNotPermanenEventTime = true
		end
		-- 活动结束后，判断是否需要用奖励时间
		if (IsUseRewardTime and (EventMainExcel.EventEndTime and NowTime > EventMainExcel.EventEndTime:GetTime()) and (EventMainExcel.RewardEndTime and NowTime < EventMainExcel.RewardEndTime:GetTime())) then
			IsActivityOpenAndInRewardTime = true
		end
		-- 是否在活动时间内
		if bEventIsInActiveTime then
			IsActivityOpenAndInEventEndTime = true
		end
		if (not IsActivityOpenAndInRewardTime) and 
		(not IsNotEventEndTimeAndPermanenEventTime) and 
		(not IsActivityOpenAndInEventEndTime) and 
		(not IsNotEventEndTimeAndNotPermanenEventTime) then
			return false
		end
	end

	local OfflineActivity = Avatar.OfflineActivity
	if (OfflineActivity and OfflineActivity[EventID]) then
		return false
	end

	-- if EventMainExcel.EventEndCondition then
	-- 	if (ConditionUtils.CheckCondition(Avatar, EventMainExcel.EventEndCondition)) then
	-- 		return false
	-- 	end
	-- end

	-- Event解锁条件是否满足
	if (ConditionUtils.CheckCondition(Avatar, EventMainExcel.EventUnlockCondition) == false) then
		return false
	end

	-- 系统打开条件是否满足(所属系统Activity), 后续和#策划ZDC 讨论后，不需要判断这个条件, 因为本身活动打开条件也有条件
	-- if (UnlockRuleName ~= nil and not Avatar:CheckSystemUICanOpen(UnlockRuleName)) then
	-- 	return false
	-- end

	-- 如果是社区关注活动，并且是B站服或外服，则不显示
	if (EventID == DataMgr["EventConstant"]["FollowCommunityEvent"].ConstantValue and ActivityUtils.IsBilibiliServer()) then
		return false
	end
	return true
end

-- 判断现在是不是B站服
function ActivityUtils.IsBilibiliServer()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    local ChannelId = Avatar.ChannelId
    -- 遍历所有渠道配置
    for id, channelInfo in pairs(DataMgr.ChannelInfo) do
        if id == ChannelId then
            return channelInfo.Provider == CommonConst.CHANNEL_PROVIDER.BILI
        end
    end
    return false
end

function ActivityUtils.GetCurSignRewardState(SignDayIndex, SignServerData)
    if (SignServerData == nil) then
        return ActivityUtils.EnumPlayerSignRewardState.NotSign
    elseif (not SignServerData:IsSignInday(SignDayIndex)) then
        return ActivityUtils.EnumPlayerSignRewardState.NotSign
    elseif (SignServerData:CanRecvReward(SignDayIndex)) then
        return ActivityUtils.EnumPlayerSignRewardState.SignedNotRecv
    else
        return ActivityUtils.EnumPlayerSignRewardState.Completed
    end
end

function ActivityUtils.GetCurQuestState(QuestServerData, PlayerPhaseId)
    if (QuestServerData == nil) then
        return ActivityUtils.EnumPlayerTaskState.NotStart
    elseif (not QuestServerData:IsComplete()) then
        return ActivityUtils.EnumPlayerTaskState.NotComplete
	elseif (not ActivityUtils.CheckIsTaskUnlock(QuestServerData:GetUniqueID(), PlayerPhaseId)) then
        return ActivityUtils.EnumPlayerTaskState.NotUnlock
    elseif (QuestServerData:CanRecvReward()) then
        return ActivityUtils.EnumPlayerTaskState.NotGetReward
    else
        return ActivityUtils.EnumPlayerTaskState.Completed
    end
end

function ActivityUtils.IsComeBackEvent(EventID)
    return EventID == DataMgr.ComeBackEventConstant.CurrentEventId.ConstantValue
end

function ActivityUtils.CheckComeBackEventIsOpen(EventID)
	local Avatar = GWorld:GetAvatar()
	local EventMainExcel = DataMgr.EventMain[EventID]
	if (ConditionUtils.CheckCondition(Avatar, EventMainExcel.EventUnlockCondition) == false) then
		return false
	end
	local NowTime = TimeUtils.NowTime()
    if Avatar and Avatar.ComeBacks[EventID] and Avatar.ComeBackExpireTime and Avatar.ComeBackExpireTime > NowTime then
		return true
	end
    return false
end

function ActivityUtils.GetCurrentAllActivity()
    local AllActivityTabIdx, InvaildEventIdList = {}, {}
	for key, TabConfigInfo in pairs(DataMgr.EventTab) do
		if (type(TabConfigInfo.EventId) == "table") then
			local EventConfigData = DataMgr.EventMain[TabConfigInfo.EventId[1]]
			if ActivityUtils.IsComeBackEvent(TabConfigInfo.EventId[1]) then
				if ActivityUtils.CheckComeBackEventIsOpen(TabConfigInfo.EventId[1]) then
					table.insert(AllActivityTabIdx, TabConfigInfo.EventTabId) -- 还有问题，需要考虑配表回归活动交替时的情况
				else
					for _, InvalidEventId in ipairs(TabConfigInfo.EventId) do
						table.insert(InvaildEventIdList, InvalidEventId)
					end
				end
			else
				if (ActivityUtils.CheckEventIsOpen(TabConfigInfo.EventId[1], EventConfigData, true, "GameEvent")) then
					table.insert(AllActivityTabIdx, TabConfigInfo.EventTabId)
				else
					for _, InvalidEventId in ipairs(TabConfigInfo.EventId) do
						table.insert(InvaildEventIdList, InvalidEventId)
					end
				end
			end
		else
			local EventConfigData = DataMgr.EventMain[TabConfigInfo.EventId]
			if (ActivityUtils.CheckEventIsOpen(TabConfigInfo.EventId, EventConfigData, true, "GameEvent")) then
				table.insert(AllActivityTabIdx, TabConfigInfo.EventTabId)
			else
				table.insert(InvaildEventIdList, TabConfigInfo.EventId)
			end
		end
	end

	table.sort(AllActivityTabIdx, function(Data1, Data2)
		if (DataMgr.EventTab[Data1].Sequence == DataMgr.EventTab[Data2].Sequence) then
			return DataMgr.EventTab[Data1].EventTabId < DataMgr.EventTab[Data2].EventTabId
		else
			return DataMgr.EventTab[Data1].Sequence > DataMgr.EventTab[Data2].Sequence
		end
	end)

	local AllActivityID = {}
	for _, v in ipairs(AllActivityTabIdx) do
		local EventConfigData = DataMgr.EventTab[v]
		if (type(EventConfigData.EventId) == "table") then
			table.insert(AllActivityID, EventConfigData.EventId)
		else
			table.insert(AllActivityID, {EventConfigData.EventId})
		end
	end

	for index, InvalidCheckEventId in ipairs(InvaildEventIdList) do
		-- DebugPrint("ActivityUtils.GetCurrentAllActivity TryClearActivityReddotCommon== InvalidCheckEventId is ", InvalidCheckEventId)
		ActivityUtils.TryClearActivityReddotCommon(InvalidCheckEventId)
	end

    return AllActivityID, AllActivityTabIdx
end

-- 这个函数获得的活动是不判断解锁条件的，因为从副本出来的时候活动可能会有属性未同步
function ActivityUtils.GetCurrentAllActivityWithoutSystemCheck()
    local AllActivityTabIdx = {}

	for key, TabConfigInfo in pairs(DataMgr.EventTab) do
		if (type(TabConfigInfo.EventId) == "table") then
			local EventConfigData = DataMgr.EventMain[TabConfigInfo.EventId[1]]
			if ActivityUtils.IsComeBackEvent(TabConfigInfo.EventId[1]) then
				if ActivityUtils.CheckComeBackEventIsOpen(TabConfigInfo.EventId[1]) then
					table.insert(AllActivityTabIdx, TabConfigInfo.EventTabId) -- 还有问题，需要考虑配表回归活动交替时的情况
				end
			else
				if (ActivityUtils.CheckEventIsOpen(TabConfigInfo.EventId[1], EventConfigData, true, nil)) then
					table.insert(AllActivityTabIdx, TabConfigInfo.EventTabId)
				end
			end
		else
			local EventConfigData = DataMgr.EventMain[TabConfigInfo.EventId]
			if (ActivityUtils.CheckEventIsOpen(TabConfigInfo.EventId, EventConfigData, true, nil)) then
				table.insert(AllActivityTabIdx, TabConfigInfo.EventTabId)
			end
		end
	end

	table.sort(AllActivityTabIdx, function(Data1, Data2)
		if (DataMgr.EventTab[Data1].Sequence == DataMgr.EventTab[Data2].Sequence) then
			return DataMgr.EventTab[Data1].EventTabId < DataMgr.EventTab[Data2].EventTabId
		else
			return DataMgr.EventTab[Data1].Sequence > DataMgr.EventTab[Data2].Sequence
		end
	end)

	local AllActivityID = {}
	for _, v in ipairs(AllActivityTabIdx) do
		local EventConfigData = DataMgr.EventTab[v]
		if (type(EventConfigData.EventId) == "table") then
			table.insert(AllActivityID, EventConfigData.EventId)
		else
			table.insert(AllActivityID, {EventConfigData.EventId})
		end
	end

    return AllActivityID, AllActivityTabIdx
end

function ActivityUtils.CheckIsTaskUnlock(QuestId, PlayerPhaseId)
	local QuestConfigData = DataMgr.CommonQuestDetail[QuestId]
	if (QuestConfigData == nil) then
		return
	end
	local PhaseId = QuestConfigData.QuestPhaseId
	return PhaseId <= PlayerPhaseId
end

function ActivityUtils.CheckIsQuestPhaseIdReached(ActivityID, QuestPhaseId)
	local CurrentPhaseId = EMCache:Get("CommonQuestsCurPhaseId", true)
	if (CurrentPhaseId and CurrentPhaseId >= QuestPhaseId) then
		return true
	end
	return false
end
-- 判断当前阶段活动是否完成
function ActivityUtils.CheckIsCurrentTaskAllDone(PlayerPhaseId)
    local QuestIdValue, IsCurrentPhaseTaskAllDone, PlayerAvatar, IsShowRedDot = DataMgr.QuestPhaseId2QuestId[PlayerPhaseId], true, GWorld:GetAvatar(), false
    for _, v in ipairs(QuestIdValue) do
        local QuestConfigData = DataMgr.CommonQuestDetail[v]
        local QuestServerData = PlayerAvatar.StarterQuests[v]
        local CurQuestState = ActivityUtils.GetCurQuestState(QuestServerData, PlayerPhaseId)

		if (IsCurrentPhaseTaskAllDone and CurQuestState ~= ActivityUtils.EnumPlayerTaskState.Completed) then
            IsCurrentPhaseTaskAllDone = false
        end
        if (not IsShowRedDot and CurQuestState == ActivityUtils.EnumPlayerTaskState.NotGetReward and QuestConfigData.QuestReward ~= nil) then
            IsShowRedDot = true
        end
    end

	return IsCurrentPhaseTaskAllDone, IsShowRedDot
end

function ActivityUtils.OnGetTryOutActivityRewardBack(ActivityID, AllRewards)
	-- 展开奖励获得
	UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, AllRewards, false, nil, nil, false)
	ActivityReddotHelper.TrySubReddotCount(ActivityUtils, ActivityID, "Red")
	EventManager:FireEvent(EventID.OnUpdateActivityEvent, "TryOutGetReward", ActivityID)
end

--region 红点树相关 ----------------------------------
function ActivityUtils.RefreshActivityReddotNode()
	local AllActivityInfo,AllActivityTabIdxes = ActivityUtils.GetCurrentAllActivity()
	for i, ActivityInfo in ipairs(AllActivityInfo) do
		for index, ActivityID in ipairs(ActivityInfo) do
			ActivityReddotHelper.RefreshReddotNode(ActivityID)
		end
	end
end

function ActivityUtils.TryAddActivityReddotCommon(CacheKey, ActivityID)
	ActivityReddotHelper.TryAddReddotCount(nil, ActivityID, CacheKey)
end

function ActivityUtils.TrySubActivityReddotCommon(CacheKey, ActivityID)
	ActivityReddotHelper.TrySubReddotCount(nil, ActivityID, CacheKey)
end

function ActivityUtils.TryClearActivityReddotCommon(ActivityID)
    local ReddotName = ActivityReddotHelper.GetEventMainNodeName(ActivityID)
    if ReddotName then
        ReddotManager.ClearLeafNodeCount(ReddotName, false, {bClearAll=true})
    end
end

function ActivityUtils.GetReddotCachInfoByKey(CacheKey, ActivityID)
	local ReddotName = ActivityReddotHelper.GetEventMainNodeName(ActivityID)
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotName)
	if CacheDetail then
		return CacheDetail[CacheKey] 
	end
end
--endregion

--region 新手委托
function ActivityUtils.CheckIsStarterQuestUnlock(QuestId, PlayerPhaseId)
	local QuestConfigData = DataMgr.StarterQuestDetail[QuestId]
	if (QuestConfigData == nil) then
		return
	end
	local PhaseId = QuestConfigData.QuestPhaseId
	return PhaseId <= PlayerPhaseId
end
function ActivityUtils.GetCurStarterQuestState(QuestServerData, PlayerPhaseId)
    if (QuestServerData == nil) then
        return ActivityUtils.EnumPlayerTaskState.NotStart
    elseif (not QuestServerData:IsComplete()) then
        return ActivityUtils.EnumPlayerTaskState.NotComplete
	elseif (not ActivityUtils.CheckIsStarterQuestUnlock(QuestServerData:GetUniqueID(), PlayerPhaseId)) then
        return ActivityUtils.EnumPlayerTaskState.NotUnlock
    elseif (QuestServerData:CanRecvReward()) then
        return ActivityUtils.EnumPlayerTaskState.NotGetReward
    else
        return ActivityUtils.EnumPlayerTaskState.Completed
    end
end
function ActivityUtils:CheckStarterQuestIsNeedShowReddot()
	local IsNeedShowRed, PlayerAvatar = false, GWorld:GetAvatar()
	local AllQuestServerData = PlayerAvatar.StarterQuests
	local CurrentPhaseId = EMCache:Get("StarterQuestsCurPhaseId", true)
	if (CurrentPhaseId == nil) then
		CurrentPhaseId = ActivityCommon.DefaultPhaseId
	end
	local QuestIdValue = DataMgr.StarterQuestPhaseMap[CurrentPhaseId] or {}
	for _, v in ipairs(QuestIdValue) do
		local QuestServerData = AllQuestServerData[v]
		local CurQuestState = ActivityUtils.GetCurStarterQuestState(QuestServerData, CurrentPhaseId)
		if (CurQuestState == ActivityUtils.EnumPlayerTaskState.NotGetReward) then
			IsNeedShowRed = true
			break
		end
	end
	return IsNeedShowRed
end
function ActivityUtils.ChangeStarterQuestReddot()
	if not ReddotManager.GetTreeNode("StarterQuest") then
        ReddotManager.AddNode("StarterQuest")
    end
	local IsNeedShowRed = ActivityUtils.CheckStarterQuestIsNeedShowReddot()
    if IsNeedShowRed then
		local Node = ReddotManager.GetTreeNode("StarterQuest")
		if Node.Count<=0 then
        	ReddotManager.IncreaseLeafNodeCount("StarterQuest", 1)
		end
    else
		ReddotManager.ClearLeafNodeCount("StarterQuest", true)
	end
end
-- 判断新手活动是否完成
function ActivityUtils.CheckStarterQuestAllDone()
    local PlayerAvatar = GWorld:GetAvatar()
	local CurrentPhaseId = EMCache:Get("StarterQuestsCurPhaseId", true)
	if (CurrentPhaseId == nil) then
		CurrentPhaseId = ActivityCommon.DefaultPhaseId
	end
    for _,QuestServerData in pairs(PlayerAvatar.StarterQuests) do
        local CurQuestState = ActivityUtils.GetCurStarterQuestState(QuestServerData, CurrentPhaseId)
		if CurQuestState ~= ActivityUtils.EnumPlayerTaskState.Completed then
            return false
        end
    end
	return true
end
-- 判断当前阶段新手活动是否完成
function ActivityUtils.CheckIsCurrentStarterQuestAllDone(PlayerPhaseId)
    local QuestIdValue, PlayerAvatar = DataMgr.StarterQuestPhaseMap[PlayerPhaseId], GWorld:GetAvatar()
    for _, v in ipairs(QuestIdValue) do
        local QuestServerData = PlayerAvatar.StarterQuests[v]
        local CurQuestState = ActivityUtils.GetCurStarterQuestState(QuestServerData, PlayerPhaseId)
		if CurQuestState ~= ActivityUtils.EnumPlayerTaskState.Completed then
            return false
        end
    end
	return true
end
--endregion

-- 判断活动是否未解锁
function ActivityUtils.CheckIsActivityLock(PageConfigData)
	local IsLock = false
    local PlayerAvatar = GWorld:GetAvatar()
	if (PlayerAvatar and PageConfigData and PageConfigData.JumpUnlockCondition) then
		if (not ConditionUtils.CheckCondition(PlayerAvatar, PageConfigData.JumpUnlockCondition)) then
            IsLock = true
		end
	end
	return IsLock
end



-- 打开活动结算页面
function ActivityUtils.OpenActivitySettlement(ActivityId, DungeonId, Params)
	local EventSettlementConfigData = DataMgr.EventSettlementPage[1]
	--同时对应唯一活动id和副本id不太适合拥有大量副本的活动（如自走棋）。所以当不传入副本id时，只会去匹配活动id
	for Id, ConfigData in pairs(DataMgr.EventSettlementPage) do
		if DungeonId then
			if ConfigData.EventId == ActivityId and ConfigData.DungeonId == DungeonId then
            	EventSettlementConfigData = ConfigData
        	end
		else
			if ConfigData.EventId == ActivityId then
            	EventSettlementConfigData = ConfigData
        	end
		end
    end
	local SettlementPage = nil
	local UIManager = GWorld.GameInstance:GetGameUIManager()
	if (CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance) == CommonConst.CLIENT_DEVICE_TYPE.PC) then
		SettlementPage = UIManager:CreateWidget(EventSettlementConfigData.PCBluePrint, true, 59)
	else
		SettlementPage = UIManager:CreateWidget(EventSettlementConfigData.MobileBluePrint or EventSettlementConfigData.PCBluePrint, true, 59)
	end
	if SettlementPage then
		SettlementPage:InitParams(Params)
	end
	return SettlementPage
end

-- 判断一个活动是否是常驻活动
function ActivityUtils.CheckIsPermanentEvent(ActivityId)
	local MainConfigInfo = DataMgr.EventMain[ActivityId]
	if not MainConfigInfo then
		return false
	end
	local bPermanentEvent = false
	local PermanenEventTime = MainConfigInfo.PermanenEventTime
	local EventEndTime = MainConfigInfo.EventEndTime
	local TimeUtils = require "Utils.TimeUtils"
	local NowTime = TimeUtils.NowTime()
	if ((not EventEndTime) and PermanenEventTime and NowTime >= PermanenEventTime) then
		bPermanentEvent = true
	end
	return bPermanentEvent
end

--活动页面剩余时间刷新接口
--@param TargetUI 				活动页面UI
--@param TargetTimeUI 			剩余时间子控件(通常是Activity_Time)
--@param bCheckNextDayFiveStamp 是否下一个凌晨5点刷新
function ActivityUtils.RefreshLeftTime(TargetUI, TargetTimeUI, bCheckNextDayFiveStamp, OverrideEventEndTime)
	if not TargetUI or not TargetTimeUI then return end
	local ActivityEndTime
	if OverrideEventEndTime then
        ActivityEndTime = OverrideEventEndTime
	else
		ActivityEndTime = DataMgr.EventMain[TargetUI.CurActivityId].EventEndTime
    end
	local RewardEndTime = DataMgr.EventMain[TargetUI.CurActivityId].RewardEndTime
	local PermanenEventTime = DataMgr.EventMain[TargetUI.CurActivityId].PermanenEventTime
	local NowTime = TimeUtils.NowTime()
	if (not ActivityEndTime) and (PermanenEventTime) and NowTime <= PermanenEventTime then
		ActivityEndTime = PermanenEventTime
	end
    local RemainActivityTimeDict, ActivityTimeCount = UIUtils.GetLeftTimeStrStyle2(ActivityEndTime)
    local IsActivityTimeOut = ActivityTimeCount == 0
	local bActuallyEnd = false
	if TargetUI.IsComplete and bCheckNextDayFiveStamp then
        local NextDayFiveStamp = TimeUtils.TimestampNextClock(5)
        if ActivityEndTime == nil then
            ActivityEndTime = NextDayFiveStamp
        end
        local minStamp = math.min(NextDayFiveStamp, ActivityEndTime)
        RemainActivityTimeDict = UIUtils.GetLeftTimeStrStyle2(minStamp)
		ActivityUtils.SetLeftTimeView(TargetTimeUI, false, false, RemainActivityTimeDict, true)
        return
    end
    if (IsActivityTimeOut) and (not RewardEndTime) then
		if TargetTimeUI and not ActivityEndTime then
			TargetTimeUI:SetForeverTimeText(GText("UI_GameEvent_EventTimeRemain"))
		else
			ActivityUtils.SetLeftTimeView(TargetTimeUI, false, false, RemainActivityTimeDict)
			bActuallyEnd = true
        end
        TargetUI:RemoveTimer("RefreshLeftTime")
	elseif (IsActivityTimeOut) and (RewardEndTime) then
		local RemainRewardTimeDict, RewardTimeCount = UIUtils.GetLeftTimeStrStyle2(RewardEndTime)
		ActivityUtils.SetLeftTimeView(TargetTimeUI, false, true, RemainRewardTimeDict)
		if (RewardTimeCount == 0) then
			TargetUI:RemoveTimer("RefreshLeftTime")
			bActuallyEnd = true
		end
    else
		ActivityUtils.SetLeftTimeView(TargetTimeUI, false, false, RemainActivityTimeDict)
    end

	if PermanenEventTime and NowTime >= PermanenEventTime then
		TargetTimeUI:SetForeverTimeText(GText("UI_GameEvent_EventTimeRemain"))
	end

	--如果活动已结束，且当前在该活动页，强刷一下
	if bActuallyEnd and TargetUI.ParentWidget and TargetUI.ParentTabId == TargetUI.ParentWidget.CurTabId then
		if TargetUI.ParentWidget.GenerateAllDataInfo then
			TargetUI.ParentWidget.NeedJumpToTabId = nil
			TargetUI.ParentWidget.CurActivityId = nil
			TargetUI.ParentWidget.NormalStateCurActivityId = nil
			TargetUI.ParentWidget.LimitStateCurActivityId = nil
			TargetUI.ParentWidget:GenerateAllDataInfo()
			return
		end
	end

	--如果是活动跳转的页面，且活动已结束，且当前在该活动页，直接关闭界面
	if bActuallyEnd and TargetUI and TargetUI.ParentTabId then
		if TargetUI.CloseSelf then
			TargetUI:CloseSelf()
		end
	end
end

--设置活动页面剩余时间
--@param TargetTimeUI 		剩余时间子控件(通常是Activity_Time)
--@param IsHideTimeInfo 	是否隐藏时间信息
--@param IsActivityTimeOut  是否活动时间已到
--@param TimeDictInfo 		时间字典信息
--@param IsComplete 		是否活动已完成
function ActivityUtils.SetLeftTimeView(TargetTimeUI, IsHideTimeInfo, IsActivityTimeOut, TimeDictInfo, IsComplete)
    if (IsComplete) then
        TargetTimeUI:SetTimeText(GText("UI_Event_RemoveRemainTime"), TimeDictInfo)
        return
    end
    if (IsHideTimeInfo) then
        TargetTimeUI:SetForeverTimeText(GText("UI_GameEvent_EventTimeRemain"))
        return
    end
    if (IsActivityTimeOut) then
        TargetTimeUI:SetTimeText(GText("UI_GameEvent_RewardTimeRemain"), TimeDictInfo)
    else
        TargetTimeUI:SetTimeText(GText("UI_GameEvent_EventTimeRemain"), TimeDictInfo)
    end
end

--判断是否是一个有效的TabId，即对应的活动处于Open状态
function ActivityUtils.IsTabIdValid(TabId)
	local EventTabData = DataMgr.EventTab[TabId]
	if not EventTabData then return false end
	local EventIds = EventTabData.EventId
    for _, EventID in ipairs(EventIds) do
        local EventMainExcel = DataMgr.EventMain[EventID]
        if ActivityUtils.CheckEventIsOpen(EventID, EventMainExcel, true, nil) then
            return true
        end
    end
    return false
end

function ActivityUtils.SetUpJustifyOfJap(TextBlock1, TextBlock2)
    if CommonConst.SystemLanguage == CommonConst.SystemLanguages.JP then
        if TextBlock1 then
            TextBlock1:SetJustification(ETextJustify.Left)
        end

        if TextBlock2 then
            TextBlock2:SetJustification(ETextJustify.Left)
        end
    end
end

function ActivityUtils.IsAccessoryDropActivity(ActivityId)
	for _, Id in pairs(AccessoryDropActivityIds) do
		if Id == ActivityId then
			return true 
		end
	end

	return false
end

return ActivityUtils