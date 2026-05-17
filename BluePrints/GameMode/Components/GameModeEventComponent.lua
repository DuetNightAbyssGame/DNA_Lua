require "UnLua"
local EStorylineActorEventType = require 'StoryCreator.StoryLogic.StorylineUtils'.EActorEventType

local GameModeEventComponent = {}

-- 获取对应的副本组件
-- function GameModeEventComponent:GetDungeonComponent()
-- 	if self:IsInDungeon() then
-- 		if self.DungeonComponent == nil then
-- 			local GameState = self.EMGameState or UE4.UGameplayStatics.GetGameState(self)
-- 			if GameState.GameModeType == "Temple" or GameState.GameModeType == "Party" then
-- 				self.DungeonComponent = self:GetSubDungeonComponent()
-- 			else
-- 				self.DungeonComponent = self['BP_'..GameState.GameModeType..'Component']
-- 			end
-- 			return self.DungeonComponent
-- 		end
-- 		return self.DungeonComponent

--	else
-- function GameModeEventComponent:GetDungeonComponentInRegion()
-- 		if not self.RegionSpecialQuest then
-- 			return nil
-- 		end
-- 		if self.RegionDungeonComponent == nil then
-- 			self.RegionDungeonComponent = self['BP_'..self.RegionSpecialQuest..'Component']
-- 			if self.RegionDungeonComponent ~= nil then
-- 				return self.RegionDungeonComponent
-- 			end
-- 			if self.ActiveRegionSubGameMode ~= nil then
-- 				self.RegionDungeonComponent = self.ActiveRegionSubGameMode['BP_'..self.RegionSpecialQuest..'Component']
-- 				if self.RegionDungeonComponent ~= nil then
-- 					return self.RegionDungeonComponent
-- 				end
-- 			end
-- 			for LevelName, SubGameMode in pairs(self.SubGameModeInfo) do
-- 				self.RegionDungeonComponent = SubGameMode['BP_'..self.RegionSpecialQuest..'Component']
-- 				if self.RegionDungeonComponent ~= nil then
-- 					return self.RegionDungeonComponent
-- 				end
-- 			end
-- 		end
-- 		return self.RegionDungeonComponent
-- 	--end
-- end

-- 获取对应的副本成就组件
function GameModeEventComponent:GetDungeonAchieveComponent()
	if self.DungeonAchieveComponent ~= nil then
		return self.DungeonAchieveComponent
	end
	if not self:IsInDungeon() then
		return nil
	end
	local GameState = self.EMGameState or UE4.UGameplayStatics.GetGameState(self)
	self.DungeonAchieveComponent = self['BP_'..GameState.GameModeType..'AchieveComponent']
	-- 允许在没有专用成就组件时，策划配置基类成就组件
	if not self.DungeonAchieveComponent then
		self.DungeonAchieveComponent = self.BP_DungeonAchieveComponent
	end
	return self.DungeonAchieveComponent
end

function GameModeEventComponent:GetSubDungeonComponent()
	local GameState = self.EMGameState or UE4.UGameplayStatics.GetGameState(self)
	local GameModeComponentName = 'BP_'..GameState.GameModeType..'Component'
	for LevelName, SubGameMode in pairs(self.SubGameModeInfo) do
		local SubDungeonComponent = SubGameMode[GameModeComponentName]
		if SubDungeonComponent == nil then
			DebugPrint("GameModeEventComponent Error! 神庙/派对玩法子关卡缺少神庙/派对组件，请策划检查相关配置")
		end
		return SubDungeonComponent
	end
end

-- 获取对应的事件扩展组件
function GameModeEventComponent:GetGameModeEventComponent()
	if self.GameModeEventComponent ~= nil then
		return self.GameModeEventComponent
	end
	if self:IsInDungeon() then 
		self.GameModeEventComponent = self.GameModeEvent
	elseif self:IsInRegion() and self.LevelGameMode.RegionId then
		local RegionComponentName = "GameModeEvent_"..self.LevelGameMode.RegionId
		self.GameModeEventComponent = self[RegionComponentName]
	end
	return self.GameModeEventComponent
end

function GameModeEventComponent:TriggerUploadDungeonAchievement(PlayerEids)
	if self:GetDungeonAchieveComponent() then
		local ResPlayerEids = PlayerEids or {}
		if PlayerEids == nil then
			for _, PlayerCharacter in pairs(self:GetAllPlayer()) do
				table.insert(ResPlayerEids, PlayerCharacter.Eid)
			end
		end
		self:GetDungeonAchieveComponent():UploadDungeonAchievement(ResPlayerEids)
	end
end

-----------------------------------------------------------------------------------

-- 触发  副本  Component的对应事件,只用于给蓝图/lua 广播的事件通知，此处EventName必须为事件分发器
function GameModeEventComponent:TriggerGameModeEvent(EventName, ...)
	if not self:GetDungeonComponent() then
		return
	end
	if self:GetDungeonComponent()[EventName] and self:GetDungeonComponent()[EventName]:IsBound() then 
		self:GetDungeonComponent()[EventName]:Broadcast(...)
	end
end

-- 触发  副本(代码)  Component_Lua的对应方法，主要用于玩法自己的内部流程
-- 通用方法   GameMode:TriggerDungeonComponentFun("OnStaticCreatorEvent",xxx)，这个不是事件，只是Function
function GameModeEventComponent:TriggerDungeonComponentFun(FunName, ...)
	if self:GetDungeonComponent() and self:GetDungeonComponent()[FunName] then
		return self:GetDungeonComponent()[FunName](self:GetDungeonComponent(), ...)
	end
	return nil
end

-- 蓝图事件扩展化   子关卡也可以使用
function GameModeEventComponent:TriggerBPGameModeEvent(Name, ...)
	if not self:GetGameModeEventComponent() then
		return
	end
	local FunName = "TriggerBPGameModeEvent_"..Name
	if self[FunName] then
		self[FunName](self, ...)
	end
end

-- 触发STL的事件  仅限区域
function GameModeEventComponent:TriggerSTLEvent(Name, ...)
	if self:IsInDungeon() then
		return
	end
	if not GWorld.StoryMgr then 
		return
	end
	local FunName = "TriggerSTLEvent_"..Name
	if self[FunName] then
		self[FunName](self, ...)
	end
end

-- 触发副本成就
function GameModeEventComponent:TriggerDungeonAchieve(EventName, PlayerEid, ...)
	DebugPrint("GameModeAchieve: EventName:", EventName)
	if not self:GetDungeonAchieveComponent() then
		return
	end
	if not self:GetDungeonAchieveComponent()[EventName] then
		return
	end
	self:GetDungeonAchieveComponent()[EventName](self:GetDungeonAchieveComponent(), PlayerEid, ...)
end

-- 抽一个接口给蓝图用
function GameModeEventComponent:TriggerDungeonAchieve_Bp(EventName, PlayerEid)
	self:TriggerDungeonAchieve(EventName, PlayerEid)
end

--------------------------蓝图事件扩展化实现-----------------------
function GameModeEventComponent:TriggerBPGameModeEvent_OnCustomEvent(ParaName)
	local EventName = "OnCustomEvent_"..ParaName
	if self:GetGameModeEventComponent()[EventName] and self:GetGameModeEventComponent()[EventName]:IsBound() then
		self:GetGameModeEventComponent()[EventName]:Broadcast()
	end
end

function GameModeEventComponent:TriggerBPGameModeEvent_OnTriggerAOIBase(...)
	local TriggerEventId, TriggerBase, ActorEid, TriggerType = ...
	local EventName = "OnTriggerAOIBase_"..TriggerEventId
	if self:GetGameModeEventComponent()[EventName] and self:GetGameModeEventComponent()[EventName]:IsBound() then
		self:GetGameModeEventComponent()[EventName]:Broadcast(TriggerBase)
	end
end

function GameModeEventComponent:TriggerBPGameModeEvent_BpOnTimerEnd(ParaName)
	local EventName = "BpOnTimerEnd_"..ParaName
	if self:GetGameModeEventComponent()[EventName] and self:GetGameModeEventComponent()[EventName]:IsBound() then
		self:GetGameModeEventComponent()[EventName]:Broadcast()
	end
end

function GameModeEventComponent:TriggerBPGameModeEvent_OnBossDead(ParaName)
	local EventName = "OnBossDead_"..ParaName.UnitId
	if self:GetGameModeEventComponent()[EventName] and self:GetGameModeEventComponent()[EventName]:IsBound() then
		self:GetGameModeEventComponent()[EventName]:Broadcast()
	end
end
-----------------------------------------------------------------


--------------------------区域STL事件回调触发实现------------------
function GameModeEventComponent:TriggerSTLEvent_OnTriggerAOIBase(...)
	local TriggerEventId, TriggerBase, ActorEid, TriggerType = ...
	GWorld.StoryMgr:TryExecStorylineActorEvent(TriggerEventId, EStorylineActorEventType.OnTriggerAOIBase, {
		TriggerBase = TriggerBase,
		ActorEid = ActorEid,
		TriggerType = TriggerType
	})
end

function GameModeEventComponent:TriggerSTLEvent_STLPostStaticCreatorEvent(...)
	local Actor = ...
	DebugPrint("STL Node TriggerSTLEvent_STLPostStaticCreatorEvent CreatorId:", Actor.CreatorId)
	GWorld.StoryMgr:TryExecStorylineActorEvent(Actor.CreatorId, EStorylineActorEventType.OnCreated, {
		Actor = Actor
	})
end

function GameModeEventComponent:TriggerSTLEvent_OnSTLActorDestroyed(...)
	local Actor, DestroyReason = ...
	GWorld.StoryMgr:TryExecStorylineActorEvent(Actor.CreatorId, EStorylineActorEventType.OnActorDestroyed, {
		Actor = Actor,
		DestroyReason = DestroyReason
	})
end

function GameModeEventComponent:TriggerSTLEvent_OnSTLMonsterdDeath(...)
	local MonsterC, KillMineRoleEid, KillMineSkillId, DeathReason = ...
	GWorld.StoryMgr:TryExecStorylineActorEvent(MonsterC.CreatorId, EStorylineActorEventType.OnMonsterDeath, {
		MonsterC = MonsterC,
		KillMineRoleEid = KillMineRoleEid,
		KillMineSkillId =KillMineSkillId,
		DeathReason = DeathReason
	})
end

-----------------------------------------------------------------

return GameModeEventComponent