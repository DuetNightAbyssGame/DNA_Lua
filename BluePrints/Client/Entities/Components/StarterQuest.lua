local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

local Component = {}

function Component:GMPhaseQuestComplete(EventId , StarterQuestID)
	self:CallServerMethod("GMPhaseQuestComplete", EventId, StarterQuestID)
end

function Component:_OnLoginSuccess()
	local bUnlocked = self:CheckUIUnlocked("StarterQuest")
	if not bUnlocked then
        self.StarterQuest_UnlockKey = self:BindOnUIFirstTimeUnlock("StarterQuest", function()
            ActivityUtils.ChangeStarterQuestReddot()
        end)
    else
        ActivityUtils.ChangeStarterQuestReddot()
    end
end

function Component:LeaveWorld()
	if self.StarterQuest_UnlockKey then
        self:UnBindOnUIFirstTimeUnlock("StarterQuest", self.StarterQuest_UnlockKey)
    end
end

function Component:StarterQuestGetReward(StarterQuestId)
	self.logger.info("StarterQuestGetReward",StarterQuestId)
    local function Cb(ErrCode)
		DebugPrint("StarterQuestGetReward",ErrorCode:Name(ErrCode))
		if (ErrorCode:Check(ErrCode, UIConst.Tip_CommonToast)) then
			EventManager:FireEvent(EventID.OnUpdateActivityEvent, "QuestGetReward", StarterQuestId)
			local RewardIds = DataMgr.StarterQuestDetail[StarterQuestId].QuestReward
			if (RewardIds ~= nil) then
				local AllRewards = RewardUtils:GetRewards(RewardIds, nil)
				UIManager(GWorld.GameInstance):LoadUINew("GetItemPage", nil, nil, nil, AllRewards)
			end
			-- 刷新红点信息
			local ActivityId = DataMgr.StarterQuestDetail[StarterQuestId].EventId
			ActivityUtils.ChangeStarterQuestReddot()
			EventManager:FireEvent(EventID.OnUpdateActivityEvent, "QuestRefreshReddot", ActivityId)
		end
    end
	self:CallServer("RpcStarterQuestGetReward", Cb,StarterQuestId) 
end

function Component:NotifyPhaseQuestComplete(EventId, QuestId)
	DebugPrint("NotifyPhaseQuestComplete <EventId,QuestId>",EventId,QuestId)
	if DataMgr.EventMain[EventId].SubExcel == "StarterQuestDetail" then
		self:NotifyStarterQuestComplete(EventId,QuestId)
	end
end

function Component:NotifyStarterQuestComplete(EventId, StarterQuestId)
	StarterQuestId = StarterQuestId or EventId
	DebugPrint("NotifyStarterQuestComplete StarterQuestId:",StarterQuestId)
	if not StarterQuestId then 
		DebugPrint("NotifyStarterQuestComplete Error Empty StarterQuestId:")
		return
	end
	local CurQuestPhaseId = DataMgr.StarterQuestDetail[StarterQuestId].QuestPhaseId
	EventManager:FireEvent(EventID.OnUpdateActivityEvent, "QuestComplete", StarterQuestId)
end


function Component:GetAllStarterQuest(PhaseId,Cb)
	if not Cb then
		Cb = function(Rewards) 
			if (Rewards ~= nil and #Rewards > 0) then
				local RewardIds = {}
				for _, RewardInfo in ipairs(Rewards) do
					if (type(RewardInfo) == "table") then
						for _, v in ipairs(RewardInfo) do
							table.insert(RewardIds, v)
						end
					else
						table.insert(RewardIds, RewardInfo)
					end
				end
				local AllRewards = RewardUtils:GetRewards(RewardIds, nil)
				UIManager(GWorld.GameInstance):LoadUINew("GetItemPage", nil, nil, nil, AllRewards)
			end
			EventManager:FireEvent(EventID.OnUpdateActivityEvent, "QuestGetAllReward", PhaseId)
			-- 刷新红点信息
			local ActivityId = DataMgr.StarterQuestPhase[PhaseId].EventId
			ActivityUtils.ChangeStarterQuestReddot()
			EventManager:FireEvent(EventID.OnUpdateActivityEvent, "QuestRefreshReddot", ActivityId)
			-- PrintTable(Rewards,10,"GetAllyStarterQuest")
		end
	end

	local PrepareSend = {}
	for _, StarterQuestId in ipairs(DataMgr.StarterQuestPhaseMap[PhaseId]) do
		if self.StarterQuests[StarterQuestId]:IsComplete() == true then
			table.insert(PrepareSend,StarterQuestId)
		end
	end
	if CommonUtils.Size(PrepareSend) == 0 then
		Cb(nil)
		return
	end

	local Rewards = {}
	local Count = CommonUtils.Size(PrepareSend)
	for _, StarterQuestId in ipairs(PrepareSend) do
		self:CallServer("RpcStarterQuestGetReward", function (errcode)
			Count = Count - 1
			if errcode == ErrorCode.RET_SUCCESS then
				table.insert(Rewards,DataMgr.StarterQuestDetail[StarterQuestId].QuestReward)
			end
			if Count == 0 then
				Cb(Rewards)
			end
		end,StarterQuestId)
	end
end

function Component:_OnPropChangeStarterQuests()
	ActivityUtils.ChangeStarterQuestReddot()
end


function Component:TestCondition()
	self.logger.info("TestCondition",self:CheckCondition(465456))
	-- self.logger.info("CheckEventIsOpen",ActivityUtils.CheckEventIsOpen(104001, nil, true))
end

return Component
