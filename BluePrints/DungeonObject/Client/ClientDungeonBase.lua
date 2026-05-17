
local ClientDungeonBase = DungeonClass.Class()

ClientDungeonBase.__Component__ = {
	"BluePrints.DungeonObject.DungeonBase",

	"BluePrints.DungeonObject.Client.ClientDungeonRPC",
}

DungeonClass.AssembleComponents(ClientDungeonBase)
return ClientDungeonBase