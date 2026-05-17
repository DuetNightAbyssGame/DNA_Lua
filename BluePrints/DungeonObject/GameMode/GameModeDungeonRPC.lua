
local GameModeDungeonRPC = DungeonClass.Class()

GameModeDungeonRPC.__Component__ = {
}

-- 通知事件到Server
function GameModeDungeonRPC:NotifyServerDungeonEvent(...)
	local ServerEntity = GWorld:GetServerEntity()
	if ServerEntity then
		ServerEntity:NotifyServerDungeonEvent(...)
	end
end

function GameModeDungeonRPC:NotifyServerDungeonEventWithCallback(Callback, EventName, ...)
	local ServerEntity = GWorld:GetServerEntity()
	if ServerEntity then
		ServerEntity:NotifyServerDungeonEventWithCallback(Callback, EventName, ...)
	end
end

-- 通知事件到GameMode
function GameModeDungeonRPC:NotifyGameModeDungeonEvent(...)
	self:OnNotifyGameModeDungeonEvent(...)
end

-- 通知事件到Client
function GameModeDungeonRPC:NotifyClientDungeonEvent(...)
	-- 临时
	local Avatar = GWorld:GetAvatar()
	if Avatar and Avatar.ClientDungeonObject then
		Avatar.ClientDungeonObject:OnNotifyClientDungeonEvent(...)
	end
end

DungeonClass.AssembleComponents(GameModeDungeonRPC)
return GameModeDungeonRPC