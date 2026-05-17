
require "UnLua"
local MiscUtils = require "Utils.MiscUtils"
local BP_BattleEventComponent_C = Class()

--function BP_BattleEventComponent_C:Initialize(Initializer)
--end

function BP_BattleEventComponent_C:ReceiveBeginPlay()
	-- self.Overridden.ReceiveBeginPlay(self)
	self.Battle = self:GetOwner()
	if not IsAuthority(self.Battle) then
		self.RegisterBattleEvent = MiscUtils.EmptyFunction
		self.UnregisterBattleEvent = MiscUtils.EmptyFunction
		self.TriggerBattleEvent = MiscUtils.EmptyFunction
		return
	end

	-- self.BattleEventDelegates = {}
	-- for _, EventName in ipairs(BattleEventName) do
	-- 	if self[EventName] and self[EventName]:IsBound() then
	-- 		self.BattleEventDelegates = self.BattleEventDelegates or {}
	-- 		self.BattleEventDelegates[EventName] = self[EventName]
	-- 	end
	-- end
	-- if not self.BattleEventDelegates then
	-- 	self.BattleEventBroadcast = MiscUtils.EmptyFunction
	-- end
	-- self:RefreshDelegates()
end

-- function BP_BattleEventComponent_C:RefreshDelegates_Lua(DeleNames)
-- 	-- for _, EventName in ipairs(BattleEventName) do
-- 	-- 	if self[EventName] and self[EventName]:IsBound() then
-- 	-- 		self.T = self.T or {}
-- 	-- 		self.T[EventName] = self[EventName]
-- 	-- 	end
-- 	-- end
-- 	self.BattleEventDelegates = {}

-- 	for _, EventName in pairs(DeleNames) do
-- 		self.BattleEventDelegates[EventName] = self[EventName]
-- 	end
-- 	if IsEmptyTable(self.BattleEventDelegates) then
-- 		self.BattleEventBroadcast = MiscUtils.EmptyFunction
-- 	else
-- 		self.BattleEventBroadcast = BP_BattleEventComponent_C.BattleEventBroadcast
-- 	end
-- end

-- -- 这个只给Battle用，角色被动的在PassiveEffectComponent
-- function BP_BattleEventComponent_C:TriggerBattleEvent(EventName, Character, ...)
-- 	if not Character then
-- 		return
-- 	end

-- 	-- Battle直接注册的
-- 	self:BattleEventBroadcast(EventName, Character, ...)

-- 	if Character.TriggerCharacterEvent then
-- 		local EventOwner = Character
-- 		if not Character:IsCharacter() then
-- 			EventOwner = nil
-- 		end
-- 		-- 战斗单位蓝图的被动（直接挂在蓝图上）
-- 		Character:TriggerCharacterEvent(EventName, EventOwner, ...)
-- 	end

-- 	-- 触发被动
-- 	self:TriggerPassiveEvent(EventName, Character, ...)
-- end

-- function BP_BattleEventComponent_C:BattleEventBroadcast(EventName, Character, ...)
-- 	-- Battle直接注册的
-- 	local Event = self:GetEvent(EventName)
-- 	if Event then
-- 		Event:Broadcast(Character, ...)
-- 	end
-- end

-- -- 广播给队友
-- function BP_BattleEventComponent_C:BattleEventBroadcastTeammate(EventName, Character, ...) 
-- 	local BattleEventListeners = Battle(self).AllMulticastBattleEvent[EventName]
-- 	if not BattleEventListeners then return end
	
-- 	local CharacterCamp = Character:GetCamp()
-- 	for Listener, EventDelegates in pairs(BattleEventListeners) do 
-- 		if not Listener then 
-- 			DebugPrint("Tianyi@ Event Listener is nil, something happened..")
-- 			goto continue
-- 		end
-- 		if Listener == Character then goto continue end
-- 		if Listener:GetCamp() == CharacterCamp then 
-- 			for _, EventDelegate in ipairs(EventDelegates) do 
-- 				EventDelegate:Broadcast(Character, ...)
-- 			end
-- 		end
-- 		::continue::
-- 	end
-- end

-- function BP_BattleEventComponent_C:HasEvent()
-- 	return self.BattleEventDelegates
-- end

-- function BP_BattleEventComponent_C:GetEvent(EventName)
-- 	return self.BattleEventDelegates and self.BattleEventDelegates[EventName]
-- end


-- -- 触发被动
-- function BP_BattleEventComponent_C:TriggerPassiveEvent(EventName, Character, ...)
-- 	-- 如果没有TriggerPassiveEvent函数，表示Character是非角色的对象
-- 	-- Character一定是角色，否则不能走下面的逻辑
-- 	if not Character.TriggerPassiveEvent then
-- 		return
-- 	end

-- 	-- 广播事件给队友
-- 	if BattleEventName.TeammateEvent[EventName] then 
-- 		self:BattleEventBroadcastTeammate(EventName, Character, ...)
-- 		return
-- 	end
	
-- 	if Character:CanTriggerPassive(EventName) then
-- 		-- 被动蓝图的被动
-- 		Character:TriggerPassiveEvent(EventName, Character, ...)
-- 	end
-- end

return BP_BattleEventComponent_C
