-- Source Excel file path: ..\datas\Dungeon.xlsx
local LocalTimeProxy = (DataMgr or {})["LocalTimeProxy"] or function(x) return x end
local ReadOnly = (DataMgr or {})["ReadOnly"] or function(n, x) return x end
return ReadOnly("DungeonRandomEventType", {
	Butcher = {
		Des = "DynQuest_FortHuishou_Title",
		EventID = "Butcher",
		Icon = "/Game/UI/Texture/Dynamic/Atlas/Dungeon/T_Dungeon_Event_Lizhan.T_Dungeon_Event_Lizhan",
		Remark = "Butcher",
	},
	Chest = {
		Des = "DynQuest_DaJie_Title",
		EventID = "Chest",
		Icon = "/Game/UI/Texture/Dynamic/Atlas/Dungeon/T_Dungeon_Event_Dajie.T_Dungeon_Event_Dajie",
		Remark = "Chest",
	},
	Pet = {
		Des = "DynQuest_IcelakePet_Title",
		EventID = "Pet",
		Icon = "/Game/UI/Texture/Dynamic/Atlas/Dungeon/T_Dungeon_Event_Pet.T_Dungeon_Event_Pet",
		Remark = "Pet",
	},
	Treasure = {
		Des = "DynQuest_DaJie_Title",
		EventID = "Treasure",
		Icon = "/Game/UI/Texture/Dynamic/Atlas/Dungeon/T_Dungeon_Event_Dajie.T_Dungeon_Event_Dajie",
		Remark = "Treasure",
	},
})