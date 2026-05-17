
local ClientDungeonRPC = DungeonClass.Class()

ClientDungeonRPC.__Component__ = {
}

-- 通知事件到Server
function ClientDungeonRPC:NotifyServerDungeonEvent(...)
	local ServerEntity = GWorld:GetServerEntity()
	if ServerEntity then
		ServerEntity:NotifyServerDungeonEvent(...)
	end
end

-- 通知事件到GameMode
function ClientDungeonRPC:NotifyGameModeDungeonEvent(...)
	-- 临时
	local ServerEntity = GWorld:GetServerEntity()
	if not ServerEntity then
		return
	end
	local DungeonObject = ServerEntity:GetDungeonObject()
	if not DungeonObject then
		return
	end
	DungeonObject:OnNotifyGameModeDungeonEvent(...)
end

-- 通知事件到Client
function ClientDungeonRPC:NotifyClientDungeonEvent(...)
	self:NotifyClientDungeonEvent(...)
end

DungeonClass.AssembleComponents(ClientDungeonRPC)
return ClientDungeonRPC