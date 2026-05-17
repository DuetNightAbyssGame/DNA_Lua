local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties

local Dungeon = Class("Dungeon", CustomTypes.CustomAttr)
	Dungeon.__Props__ = {
		-- 副本id
		DungeonId = prop.prop("Int", "client save"),

		-- 状态
		State = prop.prop("Int", "client save", 1), -- 0:未解锁，1:已解锁

		-- 阵容预设
		Squad = prop.prop("Int", "client save", 0),

		-- 总进入次数
		EnterCount = prop.prop("Int", "client save"),

		-- 总通关次数
		PassCount = prop.prop("Int", "client save"),

		-- 是否通关
		IsPass = prop.prop("Bool", "client save"),

		-- 神庙玩法专属：最高星级
		MaxStar = prop.prop("Int", "client save", 0),

		-- 钢铁之证奖励预选
		IronSurvivalDropId = prop.prop("Int", "client save", 1),

		-- 当前副本唯一Id
		DungeonSid = prop.prop("ObjId", "save"),

		-- 副本持久化数据
		PersistenceData = prop.prop("Str", "save"),

		-- 自动轮次
		AutoProgress = prop.prop("Int", "client save", 0),

		-- 副本名
		DungeonName = prop.getter("Data", "DungeonName"),
		-- 副本胜利奖励
		DungeonReward = prop.getter("Data", "DungeonReward"),
		-- 副本类型
		DungeonType = prop.getter("Data", "DungeonType"),
		-- 副本通关模式
		DungeonWinMode = prop.getter("Data", "DungeonWinMode"),
		-- 首通奖励
		FirstCompleteReward = prop.getter("Data", "FirstCompleteReward"),
		-- 是否为周本
		IsWeeklyDungeon = prop.getter("Data", "IsWeeklyDungeon"),
		-- 是否为Mod本
		IsModDungeon = prop.getter("Data", "IsModDungeon"),
	}

	function Dungeon:Data()
		return DataMgr.Dungeon[self.DungeonId]
	end

	function Dungeon:Init(DungeonId)
		if not DungeonId then
			return
		end
		self.DungeonId = DungeonId
		self.IsPass = false
	end

	function Dungeon:AddEnterCount()
		self.EnterCount = self.EnterCount + 1
	end

	function Dungeon:RefreshDungeonSid(Sid)
		self.DungeonSid = Sid
	end

	-- 返回是否为第一次通关
	function Dungeon:SetPass()
		self.PassCount = self.PassCount + 1
		if self.IsPass then
			return false
		else
			self.IsPass = true
			return true
		end
	end

	function Dungeon:PersistentData(DataStr)
		if not DataStr then
			return
		end

		self.PersistenceData = DataStr
	end

	function Dungeon:GetPersistenceData()
		return self.PersistenceData
	end


	FormatProperties(Dungeon)




local DungeonDict = Class("DungeonDict", CustomTypes.CustomDict)
	DungeonDict.KeyType = BaseTypes.Int
	DungeonDict.ValueType = Dungeon

	function DungeonDict:NewDungeon(DungeonId)
		local dungeon = Dungeon(DungeonId)
		return dungeon
	end

	function DungeonDict:IsPassed(DungeonId)
		local Dungeon = self[DungeonId]
		if not Dungeon then
			return false
		end

		return Dungeon.IsPass
	end


return {Dungeon = Dungeon, DungeonDict = DungeonDict}
