local ServerDomStaticCreator = require "Datas.ServerDomLevel_data.ServerDomStaticCreator"

local ServerStaticCreator = DungeonClass.Class()

ServerStaticCreator.__Name__ = "ServerStaticCreator"

ServerStaticCreator.__Component__ = {
}

function ServerStaticCreator:ActiveStaticCreator(StaticCreatorIds)
	-- 读表check
	if not StaticCreatorIds or CommonUtils.IsEmpty(StaticCreatorIds) then
		return
	end
	local Infos = {}
	for i, Id in pairs(StaticCreatorIds) do
		local StaticCreatorInfo = self:GetStaticCreatorInfo(Id)
		if not StaticCreatorInfo then
			goto continue
		end

		local Unit = nil
		local FunName = "Create"..StaticCreatorInfo.UnitType
		if self[FunName] then
			Unit = self[FunName](self, StaticCreatorInfo.UnitId, "StaticCreator", Id)
		end
		if not Unit then
			goto continue
		end

		local Info = {}
		Info.UnitId = Unit.UnitId
		Info.StaticCreatorId = StaticCreatorInfo.StaticCreatorId
		Info.UniqueId = Unit.UniqueId

		table.insert(Infos, Info)
		::continue::
	end

	if CommonUtils.IsEmpty(Infos) then
		return
	end
	self:NotifyGameModeActiveStaticCreator(Infos)
end

function ServerStaticCreator:OnNotifyServerDungeonEvent_ServerTriggerActiveStaticCreator(StaticCreatorIds)
	print("OnNotifyServerDungeonEvent_ServerTriggerActiveStaticCreator", StaticCreatorIds)
	self:ActiveStaticCreator(StaticCreatorIds)
end

function ServerStaticCreator:ServerInitAutoActiveStaticCreator()
	local StaticCreatorIds = self:GetAutoActiveStaticCreatorInfo()
	self:ActiveStaticCreator(StaticCreatorIds)
end


function ServerStaticCreator:NotifyGameModeActiveStaticCreator(Infos)
	self:NotifyGameModeDungeonEvent("ServerActiveStaticCreator", Infos)
	if self.OnServerActiveStaticCreator then
		self:OnServerActiveStaticCreator(Infos)
	end
end

function ServerStaticCreator:GetStaticCreatorInfo(StaticCreatorId)
	local DungeonId = self.DungeonId
	if not ServerDomStaticCreator[DungeonId] then
		return nil
	end
	if not ServerDomStaticCreator[DungeonId][StaticCreatorId] then
		return nil
	end
	local StaticCreatorInfo = ServerDomStaticCreator[DungeonId][StaticCreatorId]
	if StaticCreatorInfo.UnitId and StaticCreatorInfo.UnitType then
		return StaticCreatorInfo
	end
	return nil
end

function ServerStaticCreator:GetAutoActiveStaticCreatorInfo()
	local DungeonId = self.DungeonId
	local StaticCreatorIds = {}
	if not ServerDomStaticCreator[DungeonId] then
		return StaticCreatorIds
	end
	local CreatorDatas = ServerDomStaticCreator[DungeonId]
	for Id, Creator in pairs(CreatorDatas) do
		if Creator and Creator.AutoActive == true and Creator.UnitId and Creator.UnitType then
			table.insert(StaticCreatorIds, Id)
		end
	end
	return StaticCreatorIds
end

DungeonClass.AssembleComponents(ServerStaticCreator)
return ServerStaticCreator