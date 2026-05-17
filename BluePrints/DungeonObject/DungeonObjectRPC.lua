
local DungeonObjectRPC = DungeonClass.Class()

DungeonObjectRPC.__Name__ = "DungeonObjectRPC"

DungeonObjectRPC.__Component__ = {
}

-- 通知副本事件到Server
function DungeonObjectRPC:NotifyServerDungeonEvent(EventName, ...)
	-- 平台自己实现
end

-- Server接收触发副本事件
function DungeonObjectRPC:OnNotifyServerDungeonEvent(EventName, ...)
	print("DungeonObjectRPC:OnNotifyServerDungeonEvent: ", EventName)
	local FunName = "OnNotifyServerDungeonEvent_"..EventName
	if self[FunName] then
		return self[FunName](self, ...)
	else
		-- todo报错
		print("DungeonObjectRPC:OnNotifyServerDungeonEvent No Fun, FunName:", FunName)
	end
end

-- 通知副本事件到GameMode
function DungeonObjectRPC:NotifyGameModeDungeonEvent(EventName, ...)
	-- 平台自己实现
end

-- GameMode接收副本事件
function DungeonObjectRPC:OnNotifyGameModeDungeonEvent(EventName, ...)
	print("DungeonObjectRPC:OnNotifyGameModeDungeonEvent: ", EventName)
	local FunName = "OnNotifyGameModeDungeonEvent_"..EventName
	if self[FunName] then
		self[FunName](self, ...)
		return
	end

	if self.GameMode then
		self.GameMode:OnNotifyGameModeDungeonEvent(EventName, ...)
	else
		print("DungeonObjectRPC:OnNotifyGameModeDungeonEvent GameMode nil or No Fun, FunName:", FunName)
	end
end

-- 通知事件到Client
function DungeonObjectRPC:NotifyClientDungeonEvent(EventName, ...)
	-- 平台自己实现
end

-- Client接收副本事件
function DungeonObjectRPC:OnNotifyClientDungeonEvent(EventName, ...)
	print("DungeonObjectRPC:OnNotifyClientDungeonEvent: ", EventName)
	local FunName = "OnNotifyClientDungeonEvent_"..EventName
	if self[FunName] then
		self[FunName](self, ...)
	else
		-- todo报错
		print("DungeonObjectRPC:OnNotifyClientDungeonEvent No Fun, FunName:", FunName)
	end
end

DungeonClass.AssembleComponents(DungeonObjectRPC)
return DungeonObjectRPC