

local MiscUtils = require "Utils.MiscUtils"
local BattleEvents = {
    -- 'MonsterHatred',
}

local BattleEventLogic = {}

function BattleEventLogic:ReceiveBeginPlay()
	if not IsAuthority(self) then
		self.RegisterBattleEvent = MiscUtils.EmptyFunction
		self.UnregisterBattleEvent = MiscUtils.EmptyFunction
		self.TriggerBattleEvent = MiscUtils.EmptyFunction

		-- self.TickBattleEvents = MiscUtils.EmptyFunction
		return
	end

	self.Components = {}
    self.TickableComponents = {}
	-- 所有战斗事件
	self.AllBattleEvent = {}
	self.BattleEventIndex = 1

	-- 战斗广播事件
	self.AllMulticastBattleEvent = {}


	self:InitBattleEvent()
end

function BattleEventLogic:InitBattleEvent()
	for _, EventPath in pairs(BattleEvents) do
        local Module = require("BluePrints.Combat.BattleEvents."..EventPath)
        table.insert(self.Components, Module)
        if Module.Tick then
            table.insert(self.TickableComponents, Module)
        end
        Module:Init(self)
    end

    -- if #self.TickableComponents == 0 then
    --     self.TickBattleEvents = MiscUtils.EmptyFunction
    -- end
end

function BattleEventLogic:InitBattleEventWithPath(EventPath)
	local Module = require("BluePrints.Combat.BattleEvents."..EventPath)
	table.insert(self.Components, Module)
	if Module.Tick then
		table.insert(self.TickableComponents, Module)
	end
	Module:Init(self)
    -- if #self.TickableComponents == 0 then
    --     self.TickBattleEvents = MiscUtils.EmptyFunction
    -- end
	Module.EventPath="BluePrints.Combat.BattleEvents."..EventPath
end

function BattleEventLogic:DestoryBattleEvent(EventPath)
	local Path="BluePrints.Combat.BattleEvents."..EventPath
	if self.Components then
        for _, Module in pairs(self.Components) do
			if Module.EventPath==Path then
    			Module:Destroy(self)
				return
			end
        end
    end
end
-- function BattleEventLogic:TickBattleEvents(DeltaSeconds)
--     for i = 1, #self.TickableComponents do
--         self.TickableComponents[i]:Tick(DeltaSeconds)
--     end
-- end

-- 事件注册 -- 
-- function BattleEventLogic:RegisterBattleEvent(EventName, Object, Func, Priority)
-- 	if type(Func) == 'string' then
-- 		Func = Object[Func]
-- 	end
-- 	self:RegisterBattleEventEx(EventName, Object, Func, Priority)
-- 	-- if not self.AllBattleEvent[EventName] then
-- 	-- 	self.AllBattleEvent[EventName] = {}
-- 	-- end

-- 	-- table.insert(self.AllBattleEvent[EventName], {
-- 	-- 	Object = Object,
-- 	-- 	FuncName = FuncName,
-- 	-- 	Priority = Priority or 0,
-- 	-- 	Index = self.BattleEventIndex,
-- 	-- 	CanExecute = true,
-- 	-- 	ExtraInfo = ExtraInfo,
-- 	-- })
-- 	-- self.BattleEventIndex = self.BattleEventIndex + 1
-- 	-- table.sort(self.AllBattleEvent[EventName], function(Data1, Data2)
-- 	-- 	return Data1.Priority > Data2.Priority or ((Data1.Priority == Data2.Priority) and (Data1.Index < Data2.Index))
-- 	-- end)
-- 	-- -- PrintTable(self.AllBattleEvent,3)
-- end

-- -- 事件取消注册 -- 
-- function BattleEventLogic:UnregisterBattleEvent(EventName, Object, Func)
-- 	if type(Func) == 'string' then
-- 		Func = Object[Func]
-- 	end
-- 	self:UnregisterBattleEventEx(EventName, Object, Func)
-- 	-- local Events = self.AllBattleEvent[EventName]
-- 	-- assert(Events, 'BattleEvent: ' .. EventName .. ' is nil!!!')

-- 	-- for Index, Data in ipairs(Events) do
-- 	-- 	if Data.Object == Object and Data.FuncName == FuncName then
-- 	-- 		Data.CanExecute = false
-- 	-- 		table.remove(Events, Index)
-- 	-- 		if #Events == 0 then
-- 	-- 			self.AllBattleEvent[EventName] = nil
-- 	-- 		end
-- 	-- 		-- PrintTable(self.AllBattleEvent,3)
-- 	-- 		return
-- 	-- 	end
-- 	-- end
-- 	-- assert(ERROR, 'UnregisterBattleEvent: ' .. EventName .. ' failed!!!')
-- end

-- function BattleEventLogic:UnregisterBattleEventByObject(Object)
-- 	for _, EventName in pairs(CommonUtils.Keys(self.AllBattleEvent)) do
-- 		local Events = self.AllBattleEvent[EventName]
-- 		for Index = #Events, 1, -1 do
-- 			local Data = Events[Index]
-- 			if Data.Object == Object then
-- 				Data.CanExecute = false
-- 				table.remove(Events, Index)
-- 				if #Events == 0 then
-- 					self.AllBattleEvent[EventName] = nil
-- 				end
-- 			end
-- 		end
-- 	end
-- end

-- 注册广播事件 --
-- function BattleEventLogic:RegiesterMulticastBattleEvent(EventName, Character, EventDelegate)
-- 	if not self.AllMulticastBattleEvent[EventName] then 
-- 		self.AllMulticastBattleEvent[EventName] = {}
-- 	end

-- 	if not self.AllMulticastBattleEvent[EventName][Character] then 
-- 		self.AllMulticastBattleEvent[EventName][Character] = {}
-- 	end

-- 	table.insert(self.AllMulticastBattleEvent[EventName][Character], EventDelegate)
-- 	-- DebugPrint("Tianyi@ " .. Character:GetEid() .. " 开始监听事件: " .. EventName)
-- end

-- -- 取消注册广播事件
-- function BattleEventLogic:UnRegisterMulticastBattleEvent(EventName, Character, EventDelegate)
-- 	local Listeners = self.AllMulticastBattleEvent[EventName] 
-- 	if Listeners[Character] then 
-- 		local Listener = Listeners[Character] 
		
-- 		for Index = #Listener, 1, -1 do 
-- 			local EventDel = Listener[Index] 
-- 			if EventDel == EventDelegate then 
-- 				table.remove(Listener, Index) 
-- 			end
-- 		end
		
-- 		if #Listener <= 0 then 
-- 			Listeners[Character] = nil 
-- 		end
-- 	end
-- end


-- -- 事件触发 -- 
-- function BattleEventLogic:TriggerBattleEvent(EventName, ...)
-- 	-- -- 战斗机制 
-- 	-- self:TriggerLuaBattleEvent(EventName, ...)

-- 	-- -- 被动
-- 	-- self.BattleEvent:TriggerBattleEvent(EventName, ...)
-- end

-- function BattleEventLogic:TriggerLuaBattleEvent(EventName, ...)
-- 	if not self.AllBattleEvent or not self.AllBattleEvent[EventName] then
-- 		return
-- 	end
	
-- 	local FindInValid = nil
-- 	-- 遍历当前事件的所有物体的事件表
-- 	for _, Data in ipairs(MiscUtils.IValues(self.AllBattleEvent[EventName])) do
-- 		local Object = Data.Object
-- 		local ExtraInfo = Data.ExtraInfo
-- 		if (ExtraInfo and ExtraInfo.LuaEvent) or IsValid(Object) then
-- 			if Data.CanExecute then
-- 				local FuncName = Data.FuncName
-- 				local Func = Object[FuncName]
-- 				if Func then
-- 					Func(Object, ...)
-- 				end
-- 			end
-- 		else
-- 			Data.CanExecute = false
-- 			if not FindInValid then
-- 				FindInValid = {}
-- 			end
-- 			table.insert(FindInValid, Data)
-- 		end
-- 	end

-- 	if FindInValid then
-- 		-- PrintTable({MSG=self.AllBattleEvent[EventName]},3)
-- 		-- PrintTable({FindInValid=FindInValid},3)
-- 		for Index,Data in ipairs(FindInValid) do
-- 			self:UnregisterBattleEvent(EventName, Data.Object, Data.FuncName)
-- 		end
-- 		-- PrintTable({MSG=self.AllBattleEvent[EventName]},3)
-- 	end
-- end

return BattleEventLogic
