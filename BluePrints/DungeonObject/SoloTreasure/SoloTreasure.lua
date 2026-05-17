
-- 自热更，只需要更新代码，旧的副本不影响，下一个创建的副本会自动用新的代码
-- 禁止在代码中动态require

local ServerDungeon = DungeonClass.Class()
ServerDungeon.__Name__ = "ServerDungeon"
ServerDungeon.__Component__ = {
	-- 服务器专属写这里
	"BluePrints.DungeonObject.Server.ServerDungeonBase",

	-- Skynet专属
	"src.components.dungeon_components.ServerBaseDungeonObject",

		-- 共有的写这里
	"BluePrints.DungeonObject.SoloTreasure.SoloTreasureGameStruct",
	"BluePrints.DungeonObject.SoloTreasure.DungeonSoloTreasure",
	"BluePrints.DungeonObject.DungeonComponent.TableDrivenServerEventComponent"
}


local GameModeDungeon = DungeonClass.Class()
GameModeDungeon.__Name__ = "GameModeDungeon"
GameModeDungeon.__Component__ = {
	-- 共有的写这里
	"BluePrints.DungeonObject.SoloTreasure.ClientDungeonSoloTreasure",

	-- GameMode专属写这里
	"BluePrints.DungeonObject.GameMode.GameModeDungeonBase",
}

-- 搜打撤客户端逻辑暂时都写在GameModeSoloTreasure里
--local ClientDungeon = DungeonClass.Class()
--ClientDungeon.__Name__ = "ClientDungeon"
--ClientDungeon.__Component__ = {
-- 	-- 客户端专属写这里
-- 	"BluePrints.DungeonObject.Client.ClientDungeonBase",
-- 	"BluePrints.DungeonObject.SoloTreasure.ClientSoloTreasureBagComponent",
		
-- 	-- 共有的写这里
-- 	"BluePrints.DungeonObject.SoloTreasure.ClientDungeonSoloTreasure",
-- }


-- 搜打撤不支持DS
--local DedicatedServerDungeon = DungeonClass.Class()
--DedicatedServerDungeon.__Name__ = "DedicatedServerDungeon"
--DedicatedServerDungeon.__Component__ = {
-- 	-- 共有的写这里
-- 	--"BluePrints.DungeonObject.SoloTreasure.SoloTreasureGameStruct",
-- 	"BluePrints.DungeonObject.SoloTreasure.DungeonSoloTreasure",

-- 	-- 服务器专属写这里
-- 	"BluePrints.DungeonObject.Server.ServerDungeonBase",

-- 	-- DedicatedDedicatedServer专属
-- 	"BluePrints.DungeonObject.DedicatedServer.DedicatedServerBase"
-- }

local Dungeon = {
	Server = ServerDungeon,
	--DedicatedServer = DedicatedServerDungeon,
	GameMode = GameModeDungeon,
	--Client = ClientDungeon,
}

local CreateFunction = function(Type)
	local Value = Dungeon[Type]
	DungeonClass.AssembleComponents(Value)
	return Value()
end

return CreateFunction