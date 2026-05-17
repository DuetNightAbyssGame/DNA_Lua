local RewardBox = require "BluePrints.Client.CustomTypes.SimpleRewardBox"
---@type ClientAvatar
local Component = {}

-- @SnowMoon 客户端生成奖励，游戏逻辑统一调用通用奖励接口处理，通用接口会根据状态做接口重定向以保证最终正确性

function Component:EnterWorld()
	self.CachedDungeonRewards = RewardBox:New()
	self.CachedDungeonProgressRewards = {}
end

---------------------------------------------------- 通用奖励接口 -------------------------------------------------------

function Component:TriggerRewardEvent(LogicRewards)
	DebugPrint("TriggerRewardEvent")
	local function InnerTriggerRewardEvent(Eid)
		local LogicReward = LogicRewards[Eid]
		if not LogicReward then
			return
		end

		local UpValues = LogicReward.UpValues
		local Rewards = LogicReward.Rewards

		local function Callback(RewardHandler, Rewards)
			assert(RewardHandler ~= 0, "TriggerRewardEvent RewardHandler == 0")

			local GameMode = GWorld.GameInstance:GetCurrentGameMode()
			if RewardHandler > 0 then
				DebugPrint("TriggerRewardEvent in Dungeon")
				for i=1, #Rewards do
					local Reward = Rewards[i]
					local Reason, Transform, ExtraInfo, CB = table.unpack(UpValues[i])
					if Reason == CommonConst.RewardReason.PickUp then
						self:OnPickUp(GameMode, Reward, Reason, ExtraInfo, true)
					else
						self:OnGetRewardInDungeon(GameMode, Reward, Reason, Transform, ExtraInfo)
					end

					if CB then
						CB(Reward)
					end
				end
			else
				DebugPrint("TriggerRewardEvent in Region")
				for i=1, #Rewards do
					local Reason, Transform, ExtraInfo, CB = table.unpack(UpValues[i])
					local Reward, RewardDropDatas
					if Reason == CommonConst.RewardReason.PickUp then
						self:OnPickUp(GameMode, Rewards[i], Reason, ExtraInfo, false)
					else
						Reward, RewardDropDatas = table.unpack(Rewards[i])
						self:HandleRewardInRegion(GameMode, Reward, Reason, Transform, ExtraInfo, RewardDropDatas)
					end

					if CB then
						CB(Reward, RewardDropDatas)
					end
				end
			end
		end

		self:CallServer("TriggerRewardEvent", Callback, Rewards)
	end
	InnerTriggerRewardEvent(self.Eid) -- 触发自己的奖励
	InnerTriggerRewardEvent(-1) -- 触发非自己击杀的奖励
end

------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------- 副本类奖励 ---------------------------------------------------------

function Component:OnGetRewardInDungeon(GameMode, Rewards, Reason, Transform, ExtraInfo)
	DebugPrintTable(Rewards, 5)
	GameMode:ResolveRewardsInBattle(Rewards, Reason, Transform, ExtraInfo, {Avatar = CommonUtils.ObjId2Str(self.Eid)})
	self:CacheDungeonRewards(Rewards)
end

function Component:OnPickUp(GameMode, Reward, Reason, ExtraInfo, bInDungeon)
	if bInDungeon then
		local Tag = ExtraInfo.bExtra and "Extra" or "Normal"
		self.CachedDungeonRewards:Merge(Reward, nil, RewardBox:GetTag(Tag))
	end

	for Type, RewardInfo in pairs(Reward) do
		UIUtils.ShowDungeonRewardUI(RewardInfo, Reason, string.sub(Type, 1, -2))
	end

	local Resource = Reward.Resources
	if not Resource then
		return
	end

	local Player = UGameplayStatics.GetPlayerCharacter(GameMode, 0)
	for Id, Count in pairs(Resource) do
		Count = RewardBox:GetCount(Count)
		GameMode:TriggerOnPlayerGetResource(Player, Id, Count)
		DebugPrint('OnPlayerGetResource FireEvent',Id, ExtraInfo and ExtraInfo.WorldRegionEid or 'None')
		EventManager:FireEvent(EventID.OnPlayerGetResource, Id, ExtraInfo)
	end
end

function Component:ServerOnPickUp(Reward, ExtraInfo)
	local GameMode = GWorld.GameInstance:GetCurrentGameMode()
	self:OnPickUp(GameMode, Reward, CommonConst.RewardReason.PickUp, ExtraInfo, false)
end

function Component:ServerOnGetRewardInDungeon(Rewards, Reason, ExtraInfo)
	local GameMode = GWorld.GameInstance:GetCurrentGameMode()
	GameMode:ResolveRewardsInBattle(Rewards, Reason, nil, ExtraInfo, {Avatar = CommonUtils.ObjId2Str(self.Eid)})
	self:CacheDungeonRewards(Rewards)
end

function Component:OnShowRewardInDungeon(ClientResult)
	DebugPrint("OnShowRewardInDungeon")
	for i=1, #ClientResult do
		local Result = ClientResult[i]
		self:CacheRewardsAndShowUI(Result[1], Result[2])
	end
end

function Component:CacheRewardsAndShowUI(Rewards, Reason)
	self:CacheDungeonRewards(Rewards)
	UIUtils.OnGetRewardShowUI(Rewards, Reason)
end

function Component:CacheDungeonRewards(Rewards)
	self.CachedDungeonRewards:Merge(Rewards)
end

function Component:ResetCachedDungeonRewards()
	self.CachedDungeonRewards:Clear()
	self.CachedDungeonProgressRewards = {}
end

function Component:GetCachedDungeonRewards()
	return self.CachedDungeonRewards
end

function Component:UpdateDungeonRewards(RewardList)
	DebugPrintTable(RewardList, 5)
	local MaxProgress = 0
	for k, v in pairs(RewardList) do
		self.CachedDungeonProgressRewards[k] = v
		if k > MaxProgress then
			MaxProgress = k
		end
	end
	EventManager:FireEvent(EventID.OnUpdateRewardProgress, MaxProgress)
end

function Component:GetCachedDungeonProgressRewards()
	return self.CachedDungeonProgressRewards
end

function Component:OnGmGetDropInDungeon(Id, Count)
	DebugPrint("OnGmGetDropInDungeon", Id, Count)
	GWorld:GetBPAvatar():GetDrop(Id, Count)
end

------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------- 区域奖励 ----------------------------------------------------------

function Component:HandleRewardInRegion(GameMode, Rewards, Reason, Transform, ExtraInfo, RewardDropDatas)
	if not Rewards or type(Rewards) ~= "table" or next(Rewards) == nil then return end
	if RewardDropDatas then--服务器创建的区域数据，直接填充客户端缓存
		for _,table in pairs(RewardDropDatas) do
			for _,RegionBaseData in pairs(table) do
				GameMode:GetRegionDataMgrSubSystem().DataLibrary:SetUnitRegionCacheData(RegionBaseData.RegionDataType, 
				RegionBaseData.SubRegionId, RegionBaseData.LevelName, RegionBaseData.WorldRegionEid, RegionBaseData)
			end
		end
	end
	GameMode:ResolveRewardsInBattle(Rewards, Reason, Transform, ExtraInfo, {
		RewardDropDatas = RewardDropDatas,
		Avatar = CommonUtils.ObjId2Str(self.Eid),
	})
	UIUtils.OnGetRewardShowUI(Rewards, Reason)
end

------------------------------------------------------------------------------------------------------------------------

function Component:GetCharTrialReward(Callback, EventId)
	local function cb (ret, Reward)
		if not ErrorCode:Check(ret) then
			return
		end

		PrintTable(Reward, 3)
		if Callback then
			Callback(EventId, Reward)
		end
	end

	self:CallServer("GetCharTrialReward", cb, EventId)
end

function Component:OnRewardRateUpdate(Type, Rate)
	print(_G.LogTag, "OnRewardRateUpdate", Type, Rate)
	self.RewardParams[Type.."Rate"] = Rate
	if Type == "Exp" and Rate and GWorld.BP_Avatar then
		GWorld.BP_Avatar.AvatarExpRate = Rate
	end	
end

return Component
