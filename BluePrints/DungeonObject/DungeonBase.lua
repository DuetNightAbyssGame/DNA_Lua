
local DungeonBase = DungeonClass.Class()

DungeonBase.__Component__ = {
	"BluePrints.DungeonObject.BaseDungeonObject",

	"BluePrints.DungeonObject.DungeonComponent.DungeonUniqueLogic",
	"BluePrints.DungeonObject.DungeonComponent.MechanismDungeonLogic",
	"BluePrints.DungeonObject.DungeonComponent.DropDungeonLogic",
	"BluePrints.DungeonObject.DungeonComponent.MonsterDungeonLogic",
	"BluePrints.DungeonObject.DungeonComponent.ServerStaticCreator",
	-- "BluePrints.DungeonObject.DungeonComponent.ServerMonsterSpawn",
	"BluePrints.DungeonObject.DungeonComponent.ServerMonsterSpawnManager",
	"BluePrints.DungeonObject.DungeonComponent.ServerRandomCreator",
	"BluePrints.DungeonObject.DungeonComponent.DungeonFinishComponent",
}

DungeonClass.AssembleComponents(DungeonBase)
return DungeonBase