
local GameModeDungeonBase = DungeonClass.Class()

GameModeDungeonBase.__Component__ = {
	"BluePrints.DungeonObject.DungeonBase",
	"BluePrints.DungeonObject.GameMode.GameModeDungeonRPC",
	"BluePrints.DungeonObject.GameMode.GameModeDungeonReplicatedProperty",
	"BluePrints.DungeonObject.GameMode.GameModeCProperty",
}

DungeonClass.AssembleComponents(GameModeDungeonBase)
return GameModeDungeonBase