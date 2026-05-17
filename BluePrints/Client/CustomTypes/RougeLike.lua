local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties
-- local SerializeUtils = require "Utils.SerializeUtils"

local RougeServerBuild = Class("RougeServerBuild", CustomTypes.CustomAttr)
	RougeServerBuild.__Props__ = {
		-- 效果Id
		Id = prop.prop("Int", "save"),
		-- 生效房间类型
		RoomType = prop.prop("IntSet", ""), -- 读表，不存档
		-- 生效房间数
		RoomCount = prop.prop("Int", "save"),
		-- 是否触发过，这里给默认值为true，因为大部分情况下都是true，这样可以减少落档数据量
		bTriggered = prop.prop("Bool", "save", true),
	}
	FormatProperties(RougeServerBuild)

	function RougeServerBuild:Init(Id)
		self.Id = Id
		self:InitRoomType()

		local Info = DataMgr.RougeLikeServerBuild[Id]
		self.RoomCount = Info.RoomCount
		self.bTriggered = false
	end

	function RougeServerBuild:InitRoomType()
		local Info = DataMgr.RougeLikeServerBuild[self.Id]
		local RoomType = Info.RoomType
		if not RoomType then
			self.RoomType:AddElement(0)
		else
			for i=1, #RoomType do
				self.RoomType:AddElement(Info.RoomType[i])
			end
		end
	end

	function RougeServerBuild:CanEffect(RoomType)
		if self.RoomType:IsEmpty() then
			self:InitRoomType()
		end

		if self.RoomType:HasElement(0) then
			return not self:IsFinishEffect()
		end

		if self.RoomType:HasElement(RoomType) then
			return not self:IsFinishEffect()
		end

		return false
	end

	function RougeServerBuild:TriggerEffect(bRoomEnd)
		if not self.bTriggered then
			self.bTriggered = true
		end

		if not bRoomEnd then
			return
		end

		if self.RoomCount <= 0 then
			return
		end

		self.RoomCount = self.RoomCount - 1
	end

	function RougeServerBuild:IsFinishEffect()
		return self.RoomCount == 0 and self.bTriggered
	end

local RougeServerBuildList = Class("RougeServerBuildList", CustomTypes.CustomList)
	RougeServerBuildList.ValueType = RougeServerBuild

local RougeServerBuildTotalList = Class("RougeServerBuildTotalList", CustomTypes.CustomList)
	RougeServerBuildTotalList.ValueType = RougeServerBuildList

local IndependentServerBuild = Class("IndependentServerBuild", CustomTypes.CustomDict)
	IndependentServerBuild.KeyType = BaseTypes.Str -- tag
	IndependentServerBuild.ValueType = RougeServerBuild

local RougeServerBuildInfo = Class("RougeServerBuildInfo", CustomTypes.CustomAttr)
	RougeServerBuildInfo.__Props__ = {
		-- 效果Id
		RougeServerBuild = prop.prop("RougeServerBuildTotalList", "save"),
		-- 当前生效的效果索引
		CurrentIndex = prop.prop("Int", "save", 1),

		-- 独立效果
		IndependentServerBuild = prop.prop("IndependentServerBuild", "save")
	}
	FormatProperties(RougeServerBuildInfo)

	function RougeServerBuildInfo:Init(ServerBuild)
		if not ServerBuild then
			return
		end

		for i=1, #ServerBuild do
			local EffectList = ServerBuild[i]
			local TotalList = RougeServerBuildList()
			for j=1, #EffectList do
				TotalList:Append(RougeServerBuild(EffectList[j]))
			end

			self.RougeServerBuild:Append(TotalList)
		end
	end

	function RougeServerBuildInfo:IsFinishAllEffects()
		return self.CurrentIndex > self.RougeServerBuild:Length()
	end

local RougeServerBuildManager = Class("RougeServerBuildManager", CustomTypes.CustomDict)
	RougeServerBuildManager.KeyType = BaseTypes.Str -- tag
	RougeServerBuildManager.ValueType = RougeServerBuildInfo

	function RougeServerBuildManager:AddServerBuild(Tag, ServerBuild)
		self:AddValue(Tag, RougeServerBuildInfo(ServerBuild))
	end

	function RougeServerBuildManager:RemoveServerBuild(Tag)
		self:RemoveValue(Tag)
	end

	function RougeServerBuildManager:AddIndependentServerBuild(SourceTag, Tag, ServerBuild)
		if not self[SourceTag] then
			-- 不允许出现向不存在的Source ServerBuild中添加独立ServerBuild
			return
		end

		local IndependentServerBuild = self[SourceTag].IndependentServerBuild

		local ServerBuild = RougeServerBuild(ServerBuild)
		IndependentServerBuild:AddValue(Tag, ServerBuild)
		return ServerBuild
	end

	function RougeServerBuildManager:RemoveIndependentServerBuild(SourceTag, Tag)
		if not self[SourceTag] then
			return
		end

		local IndependentServerBuild = self[SourceTag].IndependentServerBuild
		IndependentServerBuild:RemoveValue(Tag)
	end

local RougeAwardInfo = Class("RougeAwardInfo", CustomTypes.CustomAttr)
	RougeAwardInfo.__Props__ = {
		-- 等级
		Level = prop.prop("Int", "save", 1),
		-- 是否激活
		bActive = prop.prop("Bool", "save", true),
		-- 当前是否生效
		bEffected = prop.prop("Bool", "save", true),
	}
	FormatProperties(RougeAwardInfo)

	function RougeAwardInfo:Init(Level, EffectStartRoomIndex)
		self.Level = Level
		self.EffectStartRoomIndex = EffectStartRoomIndex
	end

	function RougeAwardInfo:SetEffectDuration(Duration, RoomType)
		self.EffectDuration = Duration
		self.EffectRoomType:Clear()
		for i=1, #RoomType do
			self.EffectRoomType:AddElement(RoomType[i])
		end
	end

	function RougeAwardInfo:IsRoomValid(RoomType)
		if self.EffectRoomType:IsEmpty() == 0 then
			return true
		end

		if self.EffectRoomType:HasElement(0) then
			return true
		end

		if self.EffectRoomType:HasElement(RoomType) then
			return true
		end

		return false
	end

	function RougeAwardInfo:Dump()
		--local Data = {}
		--for k, _ in pairs(self.__Class__.Props) do
		--	Data[k] = self[k]
		--end
		--return Data

		local Data = self:all_dump(self)
		return Data
	end

local RougeAwardDict = Class("RougeAwardDict", CustomTypes.CustomDict)
	RougeAwardDict.KeyType = BaseTypes.Int
	RougeAwardDict.ValueType = RougeAwardInfo

	function RougeAwardDict:AddAward(AwardId, Level, RoomIndex)
		local AwardInfo = RougeAwardInfo(Level, RoomIndex)
		self:AddValue(AwardId, AwardInfo)
		return AwardInfo
	end

	function RougeAwardDict:RemoveAward(AwardId)
		local AwardInfo = self:Get(AwardId)
		self:RemoveValue(AwardId)
		return AwardInfo
	end

	function RougeAwardDict:Dump()
		local Data = {}
		for k, v in pairs(self._inner) do
			Data[k] = v:Dump()
		end
		return Data
	end

local AutoUpgrade = Class("AutoUpgrade", CustomTypes.CustomAttr)
	AutoUpgrade.__Props__ = {
		-- 自动升级等级
		Level = prop.prop("Int", "save", 1),
		-- 品质
		Rarity = prop.prop("IntSet", "save"),
	}
	FormatProperties(AutoUpgrade)

	function AutoUpgrade:Init(Level, Rarity)
		self.Level = Level
		for i=1, #Rarity do
			self.Rarity:AddElement(Rarity[i])
		end
	end

local AutoUpgradeDict = Class("AutoUpgradeDict", CustomTypes.CustomDict)
	AutoUpgradeDict.KeyType = BaseTypes.Str
	AutoUpgradeDict.ValueType = AutoUpgrade

	function AutoUpgradeDict:AddAutoUpgrade(Tag, Level, Rarity)
		self:AddValue(Tag, AutoUpgrade(Level, Rarity))
	end

	function AutoUpgradeDict:RemoveAutoUpgrade(Tag)
		self:RemoveValue(Tag)
	end

local DeathCounter = Class("DeathCounter", CustomTypes.CustomAttr)
	DeathCounter.__Props__ = {
		-- 源Tag
		SourceTag = prop.prop("Str", "save"),
		-- 死亡次数
		Count = prop.prop("Int", "save", 0),
		-- 目标计数
		TargetCount = prop.prop("Int", "save"),
		-- 怪物类型
		MonsterType = prop.prop("Str", "save"),
		-- 后触发ServerBuild
		ServerBuild = prop.prop("Int", "save"),
	}
	FormatProperties(DeathCounter)

	function DeathCounter:Init(SourceTag, MonsterType, Count, ServerBuild)
		self.SourceTag = SourceTag
		self.TargetCount = Count
		self.MonsterType = MonsterType
		self.ServerBuild = ServerBuild
	end

local DeathCounterDict = Class("DeathCounterDict", CustomTypes.CustomDict)
	DeathCounterDict.KeyType = BaseTypes.Str
	DeathCounterDict.ValueType = DeathCounter

	function DeathCounterDict:AddDeathCounter(Tag, MonsterType, Count, ServerBuild)
		self:AddValue(Tag, DeathCounter(Tag, MonsterType, Count, ServerBuild))
	end

	function DeathCounterDict:RemoveDeathCounter(Tag)
		self:RemoveValue(Tag)
	end

local GroupWeightRate = Class("GroupWeightRate", CustomTypes.CustomAttr)
	GroupWeightRate.__Props__ = {
		-- 组Id
		GroupIds = prop.prop("IntSet", "save"),
		-- 组权重
		WeightRate = prop.prop("Float", "save", 1.0),
	}
	FormatProperties(GroupWeightRate)

	function GroupWeightRate:Init(GroupIds, WeightRate)
		for i=1, #GroupIds do
			self.GroupIds:AddElement(GroupIds[i])
		end

		self.WeightRate = WeightRate
	end

local GroupWeightRateDict = Class("GroupWeightRateDict", CustomTypes.CustomDict)
	GroupWeightRateDict.KeyType = BaseTypes.Str -- Tag
	GroupWeightRateDict.ValueType = GroupWeightRate

	function GroupWeightRateDict:AddGroupWeightRate(Tag, GroupIds, WeightRate)
		self:AddValue(Tag, GroupWeightRate(GroupIds, WeightRate))
	end

	function GroupWeightRateDict:RemoveGroupWeightRate(Tag)
		self:RemoveValue(Tag)
	end

local RougeLike = Class("RougeLike", CustomTypes.CustomAttr)
	RougeLike.__Props__ = {
		-- 当前赛季Id
		SeasonId = prop.prop("Int", "save"),
		-- 当前难度Id
		DifficultyId = prop.prop("Int", "save"),
		-- 副本类玩法Sid
		DungeonSid = prop.prop("ObjId", "save"),
		-- 当前房间index
		RoomIndex = prop.prop("Int", "save", 0),
		-- 当前房间编号
		RoomId = prop.prop("Int", "save", -1),
		-- 已通过房间
		PassRooms = prop.prop("IntList", "save"),
		-- 随机结果
		RandomRooms = prop.prop("IntList", "save"),
		RandomBlessings = prop.prop("IntList", "save"),
		RandomBlessingId = prop.prop("Int", "save"),
		RandomTreasures = prop.prop("IntList", "save"),
		RandomTreasureId = prop.prop("Int", "save"),

		-- 最大刷新次数
		MaxRefreshTime = prop.prop("Str2IntDict", "save"),

		-- 当前已刷新次数
		RefreshTime = prop.prop("Int", "save"),

		-- 刻印
		Blessings = prop.prop("RougeAwardDict", "save"),
		-- 宝物
		Treasures = prop.prop("RougeAwardDict", "save"),

		-- 肉鸽商店信息
		Shop = prop.prop("RougeLikeShop.RougeLikeShopDict", "save"),

		-- 积分
		Score = prop.prop("Str2IntDict", "save"),

		-- 暂离快照
		DungeonInfo = prop.prop("Str", "save"), -- 角色主体信息
		GameInfo = prop.prop("Str", "save"), -- 游戏主体信息和角色动态信息
		PlayerSliceInfo = prop.prop("StrList", "save"), -- 角色动态补充信息切片


		-- 当前事件
		EventId = prop.prop("Int", "save", 0),

		-- 当前剧情事件
		StoryId = prop.prop("Int", "save", 0),
		-- 是否可触发剧情事件
		bCanTriggerStory = prop.prop("Int", "save", 1),
		-- 是否已触发剧情事件结算
		bStoryTriggered = prop.prop("Int", "save", 0),
		-- 已经触发的剧情事件
		StoryHistory = prop.prop("Int2IntDict", "save"),

		-- 额外参数
		TokenExtraRate = prop.prop("Str2FloatDict", "save"),
		EndPointsExtraRate = prop.prop("Str2FloatDict", "save"),
		ShopDiscount = prop.prop("Str2FloatDict", "save"),

		RecoverTimes = prop.prop("Str2IntDict", "save"),
		RecoverCost = prop.prop("Str2IntDict", "save"),
		RecoverTagQueue = prop.prop("StrList", "save"),

		ExtraTreasureList = prop.prop("IntList", "save"),
		ExtraBlessingList = prop.prop("IntList", "save"),
		ModifiedChoiceNumber = prop.prop("Str2IntDict", "save"),
		ModifiedChoiceNumberStack = prop.prop("StrList", "save"),
		bRandomChoice = prop.prop("StrSet", "save"),
		bDisableGetToken = prop.prop("StrSet", "save"),

		OverrideRefreshCost = prop.prop("Str2IntDict", "save"),
		OverrideRefreshTimes = prop.prop("Str2IntDict", "save"),
		RefreshRate = prop.prop("Str2FloatDict", "save"),

		MRTAutoUpgrade = prop.prop("AutoUpgradeDict", "save"),

		DeathCounter = prop.prop("DeathCounterDict", "save"),

		OverrideBlessingMRTLimitRarity = prop.prop("Str2IntListDict", "save"),
		OverrideBlessingMRTLimitRarityTagStack = prop.prop("StrList", "save"),

		OverrideTreasureMRTLimitRarity = prop.prop("Str2IntListDict", "save"),
		OverrideTreasureMRTLimitRarityTagStack = prop.prop("StrList", "save"),

		BlessingGroupWeightRate = prop.prop("GroupWeightRateDict", "save"),
		TreasureGroupWeightRate = prop.prop("GroupWeightRateDict", "save"),

		-- ServerBuildManager
		ServerBuildManager = prop.prop("RougeServerBuildManager", "save"),

		-- 盗宝怪奖励参数
		TMRewardIndex = prop.prop("Int", "save", 1),

		-- 读表值
		-- 代币Id
		TokenId = prop.getter("Data", "TokenId"),
		-- 天赋Id
		TalentId = prop.getter("Data", "TalentId"),
		-- 局外商店代币Id
		OuterShopTokenId = prop.getter("Data", "OuterShopTokenId"),
	}

	function RougeLike:Init(SeasonId, DifficultyId)
		self.SeasonId = SeasonId
		self.DifficultyId = DifficultyId
		self:AddMaxRefreshTime(self:GenTag("Default"), DataMgr.RougeLikeSeason[SeasonId].MRTLimitTimes)
		self.DungeonSid = GWorld.IdManager.GenId()
	end

	function RougeLike:Data()
		return DataMgr.RougeLikeSeason[self.SeasonId]
	end

	function RougeLike:EnterRoom(RoomId)
		if self.RoomId == RoomId then
			return ErrorCode.RET_ROUGELIKE_ROOM_REPEAT
		end

		-- @SnowMoon 只能从提供的房间列表中选择进入，这样就可以不用判断重复房间的问题，因为随机出来的房间一定是可以进的
		if not CommonUtils.HasValue(self.RandomRooms, RoomId) then
			return ErrorCode.RET_ROUGELIKE_ROOM_CANNOT_ENTER
		end

		if self.StoryId > 0 then
			return ErrorCode.RET_ROUGELIKE_STORY_NOT_FINISH
		end

		self.RoomId = RoomId
		self.RoomIndex = self.RoomIndex + 1
		self.EventId = 0 -- 重置事件Id
		self.bStoryTriggered = 0 -- 重置剧情事件结算状态
		self:SetShopCanRefresh() -- 进入新的房间刷新商店
		return ErrorCode.RET_SUCCESS
	end

	function RougeLike:GetCurrentRoomType()
		if self.RoomId == -1 then
			return 0
		end

		local RoomInfo = DataMgr.RougeLikeRoom[self.RoomId]
		if not RoomInfo then
			return 0
		end

		return RoomInfo.RoomType
	end

	function RougeLike:PassRoom(Time)
		-- @SnowMoon 有可能房间会随机一整轮，所以可能出现重复的Id，不能直接用存在性判定重复通关
		if self.RoomIndex == self.PassRooms:Length() then
			return ErrorCode.RET_ROUGELIKE_ROOM_PASS_REPEAT
		end
		self.PassRooms:Append(self.RoomId)
		local ScoreInfo = DataMgr.RougeLikeRoom[self.RoomId]
		self:UpdateScore(self:GenTag("PassRoom", self.RoomId), ScoreInfo.EndPointsBase)
		local ExtraScore = ScoreInfo.EndPointsExtras
		if not ExtraScore then
			ExtraScore = 0
		else
			ExtraScore = ExtraScore - math.floor(Time)
		end

		if ExtraScore < 0 then
			ExtraScore = 0
		end
		self:UpdateScore(self:GenTag("PassRoomExtra", self.RoomId), ExtraScore)
		return ErrorCode.RET_SUCCESS
	end

	function RougeLike:GenTag(...)
		return table.concat({...}, "_")
	end

    function RougeLike:SplitTag(Tag)
		local result = {}
		for str in string.gmatch(Tag, "([^_]+)") do
			table.insert(result, str)
		end
		return result
	end

	function RougeLike:AddMaxRefreshTime(Tag, Count)
		self.MaxRefreshTime:AddValue(Tag, Count)
	end

	function RougeLike:RemoveMaxRefreshTime(Tag)
		self.MaxRefreshTime:RemoveValue(Tag)
	end

	function RougeLike:GetMaxRefreshTime()
		local count = 0
		for _, v in pairs(self.MaxRefreshTime) do
			count = count + v
		end
		return count
	end

	function RougeLike:GetRefreshCost()
		local SortedTags = {}
		for k, v in pairs(self.OverrideRefreshCost) do
			local bInserted = false
			for i=1, #SortedTags do
				local CompKey = SortedTags[i]
				local CompValue = self.OverrideRefreshCost[CompKey]
				if v < CompValue then
					table.insert(SortedTags, i, k)
					bInserted = true
					break
				end
			end

			if not bInserted then
				table.insert(SortedTags, k)
			end
		end

		local LeftTime = self.RefreshTime
		local Index = 1
		local CostTag
		while LeftTime >= 0 do
			CostTag = SortedTags[Index]
			if not CostTag then
				break
			end

			local TagTime = self.OverrideRefreshTimes[CostTag]
			LeftTime = LeftTime - TagTime
			Index = Index + 1
		end

		local OriginCost = self.OverrideRefreshCost[CostTag]
		if not OriginCost then
			-- 所有的Override次数都用完了，使用默认刷新方案
			OriginCost = DataMgr.RougeLikeSeason[self.SeasonId].MRTCost
		end

		return math.ceil(OriginCost * self:GetRefreshRate())
	end

	function RougeLike:GetRefreshRate()
		local rate = 1 -- 默认为1
		for _, v in pairs(self.RefreshRate) do
			rate = rate * v
		end
		return rate
	end

	function RougeLike:ResetRandomRooms(RandomRooms)
		self.RandomRooms:Clear()
		if not RandomRooms then
			return
		end

		for i=1, #RandomRooms do
			self.RandomRooms:Append(RandomRooms[i])
		end
	end

	function RougeLike:ResetRandomBlessings(RandomBlessings, RandomBlessingId)
		self.RandomBlessings:Clear()
		self.RandomBlessingId = RandomBlessingId or -1

		if not RandomBlessings then
			return
		end

		local len = #RandomBlessings
		if #RandomBlessings == 0 then
			return
		end

		for i=1, len do
			self.RandomBlessings:Append(RandomBlessings[i])
		end
	end

	function RougeLike:ResetRandomTreasures(RandomTreasures, RandomTreasureId)
		self.RandomTreasures:Clear()
		self.RandomTreasureId = RandomTreasureId or -1

		if not RandomTreasures then
			return
		end

		local len = #RandomTreasures
		if #RandomTreasures == 0 then
			return
		end

		for i=1, len do
			self.RandomTreasures:Append(RandomTreasures[i])
		end
	end

	function RougeLike:SetShopCanRefresh(bRefresh)
		if bRefresh ~= nil and bRefresh == false then
			self.bShopRefresh = 0
		else
			self.bShopRefresh = 1
		end
	end

	function RougeLike:ResetShop()
		self.Shop:Clear()
	end

	function RougeLike:NewShop(ShopRandomId, Blessings, Treasures, Items)
		local ShopInfo = self.Shop:NewShop(Blessings, Treasures, Items)
		self.Shop[ShopRandomId] = ShopInfo
	end

	function RougeLike:DumpShop()
		local result = {}
		for k, v in pairs(self.Shop) do
			result[k] = {
				ShopBlessing = v.ShopBlessing,
				ShopTreasure = v.ShopTreasure,
				ShopItem = v.ShopItem,
			}
		end

		return result
	end

	function RougeLike:UpdateScore(Tag, Value)
		if not Value then
			self.Score:RemoveValue(Tag)
		else
			self.Score:AddValue(Tag, Value)
		end
	end

	function RougeLike:GetScore()
		local fv = 0
		for _, v in pairs(self.Score) do
			fv = fv + v
		end
		return fv
	end

	function RougeLike:GetTokenExtraRate()
		local rate = 1 -- 默认为1
		for _, v in pairs(self.TokenExtraRate) do
			rate = rate + v
		end
		return math.max(rate, 0)
	end

	function RougeLike:GetEndPointsExtraRate()
		local rate = 1 -- 默认为1
		for _, v in pairs(self.EndPointsExtraRate) do
			rate = rate + v
		end
		return math.max(rate, 0)
	end

	function RougeLike:GetShopDiscount()
		local rate = 1 -- 默认为1
		for _, v in pairs(self.ShopDiscount) do
			rate = rate * v
		end
		return math.max(rate, 0)
	end

	function RougeLike:GetModifiedChoiceNumber()
		local number = -1
		local len = self.ModifiedChoiceNumberStack:Length()
		if len > 0 then
			number = self.ModifiedChoiceNumber:Get(self.ModifiedChoiceNumberStack:Get(len))
		end

		return number
	end

	function RougeLike:GetOverrideMRTLimitRarity(AwardType, DefaultLimitRarity)
		local LimitRarityKey = "Override" .. AwardType .. "MRTLimitRarity"
		local LimitRarity = self[LimitRarityKey]
		local LimitRarityTagStack = self[LimitRarityKey.. "TagStack"]
		if LimitRarityTagStack:IsEmpty() then
			return DefaultLimitRarity
		end

		local Len = LimitRarityTagStack:Length()
		local Rarity = LimitRarity:Get(LimitRarityTagStack:Get(Len))
		local ret = {}
		for i=1, Rarity:Length() do
			ret[i] = Rarity:Get(i)
		end

		return ret
	end

	function RougeLike:GetGroupWeightRate(AwardType, GroupId)
		local BaseRate = 1
		local GroupWeight = self[AwardType.. "GroupWeightRate"]
		for _, attr in pairs(GroupWeight) do
			if attr.GroupIds:HasElement(GroupId) then
				BaseRate = BaseRate * attr.WeightRate
			end
		end

		return BaseRate
	end

	function RougeLike:IsRandomChoice()
		return not self.bRandomChoice:IsEmpty()
	end

	function RougeLike:IsCanGetToken()
		return self.bDisableGetToken:IsEmpty()
	end

	function RougeLike:SaveDungeonInfo(PlayerInfo, SquadInfo, CommonCombatInfo)
		local DungeonInfo = {
			PlayerInfo,
			SquadInfo,
			CommonCombatInfo,
		}
		self.DungeonInfo = SerializeUtils:Serialize(DungeonInfo)
	end

	function RougeLike:GetDungeonInfo()
		return table.unpack(SerializeUtils:UnSerialize(self.DungeonInfo))
	end

	function RougeLike:SavePlayerSliceInfo(SliceInfo)
		self.PlayerSliceInfo:Append(SliceInfo)
	end

	function RougeLike:SetCanTriggerStory(bCanTrigger)
		self.bCanTriggerStory = bCanTrigger and 1 or 0
	end

	function RougeLike:CanTriggerStory()
		return self.bCanTriggerStory == 1
	end

	function RougeLike:IsStoryEventFinished()
		return self.StoryId == 0 and self.bStoryTriggered == 1
	end

	function RougeLike:CheckAllFrontEvent(FrontEvents)
		if not FrontEvents then
			return true
		end

		local function CheckConditionUnit(EventDict)
			for EventCondition, IndexCondition in pairs(EventDict) do
				local SelectIndex = self.StoryHistory:Get(EventCondition)
				if not SelectIndex then
					return false
				end

				local bInCondition = false
				for i=1, #IndexCondition do
					local v = IndexCondition[i]
					if v == 0 or v == SelectIndex then
						bInCondition = true
						break
					end
				end

				if not bInCondition then
					return false
				end
			end

			return true
		end

		for i=1,#FrontEvents do
			if CheckConditionUnit(FrontEvents[i]) then
				return true
			end
		end

		return false
	end

	FormatProperties(RougeLike)

local RougeLikeDict = Class("RougeLikeDict", CustomTypes.CustomDict)
	RougeLikeDict.KeyType = BaseTypes.Int
	RougeLikeDict.ValueType = RougeLike

	function RougeLikeDict:NewRougeLike(SeasonId, DifficultyId)
		return RougeLike(SeasonId, DifficultyId)
	end

return {
	RougeAwardInfo = RougeAwardInfo,
	RougeLike = RougeLike,
	RougeLikeDict = RougeLikeDict,
	RougeServerBuild = RougeServerBuild,
	RougeServerBuildList = RougeServerBuildList,
	RougeServerBuildTotalList = RougeServerBuildTotalList,
	RougeServerBuildInfo = RougeServerBuildInfo,
	RougeServerBuildManager = RougeServerBuildManager,
	RougeAwardDict = RougeAwardDict,
	DeathCounterDict = DeathCounterDict,
	AutoUpgradeDict = AutoUpgradeDict,
	IndependentServerBuild = IndependentServerBuild,
	AutoUpgrade = AutoUpgrade,
	DeathCounter = DeathCounter,
	GroupWeightRateDict = GroupWeightRateDict,
	GroupWeightRate = GroupWeightRate,
}
