require "UnLua"

local CommonUtils = require "Utils.CommonUtils"
local SerializeUtils = require "Utils.SerializeUtils"
local WalnutUtils = require "BluePrints.UI.WBP.Walnut.WalnutChoice.WalnutUtils"
local ProgressSnapShotComponent = {}

---@class RandomCreatorInfo @单个随机点数据类型
---@field RandomRuleId 		number
---@field RandomTableId 	number
---@field RandomLevelName 	string
---@field RandomIdxInRule 	number
---@field ItemData 			table

function ProgressSnapShotComponent:TryResetBattleEid()
	if GWorld:GetAvatar() and GWorld:GetAvatar():IsInBigWorld() then
		return
	end
	if not self:GetProgressData() then 
		return
	end
	if not self:NeedProgressRecover() then
		return
	end
	local LastEid = self:GetProgressData()["Eid"]
	if not LastEid or LastEid == 0 then
		return
	end
	self:SetBattleEid(LastEid)
end

function ProgressSnapShotComponent:NeedProgressRecover()
	local ProgressData = self:GetProgressData()
	if not ProgressData then
		return false
	end
	local DungeonId = self.DungeonId or UE4.UGameplayStatics.GetGameInstance(self):GetCurrentDungeonId()
	if DungeonId ~= ProgressData["DungeonId"] then
		return false
	end
	return true
end

function ProgressSnapShotComponent:GetProgressData()
	if self.ProgressData == nil then
		local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
		self.ProgressData = GameInstance:GetProgressData()
	end
	return self.ProgressData
end

function ProgressSnapShotComponent:GetPlayerSliceData()
	local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
	return GameInstance:GetPlayerSliceData()
end

function ProgressSnapShotComponent:GetProgressDataJsonName()
	-- 进入副本时获取JSON
	local ProgressData = self:GetProgressData()
	if ProgressData then
		return ProgressData["JsonName"]
	end
	return nil
end

function ProgressSnapShotComponent:GetProgressDataDungeonId()
	local ProgressData = self:GetProgressData()
	if ProgressData then
		return ProgressData["DungeonId"]
	end
	return nil
end

function ProgressSnapShotComponent:GetProgressDataPlayerTransform()
	-- 进入副本时获取玩家位置
	local ProgressData = self:GetProgressData()
	if ProgressData then
		return CommonUtils:UnSerializeFTransform(ProgressData["PlayerTransform"])
	end
	return nil
end

function ProgressSnapShotComponent:TriggerProgressRecover()
	local ProgressData = self:GetProgressData()
	if ProgressData then
		local RecoverStage = "OnBattle"
		if ProgressData.IsRougeLike then
			self:RougeRecoverProgressData()
		elseif ProgressData.IsAbyss then
			self:AbyssRecoverProgressData()
		else
			-- 进行Dungeon的Json和玩家位置的恢复,这一步在进入副本的那一刻就已经执行
			RecoverStage = self:RecoverProgressData()
		end

		-- todo 这个改枚举 放const表里吧
		if RecoverStage == "OnVoteBegin" then
			self:ExecuteNextStepOfDungeonVote()
			self:DoCustomLogicOnRecoverToVoteEnd()
		elseif RecoverStage == "OnBattle" then
			self:OnProgressRecoverSucceed()
		end
	end
end

---@type fun() : boolean @是否启用无尽本进度恢复功能
function ProgressSnapShotComponent:CheckProgressSnapShotEnable()
	if not IsStandAlone(self) then
		return false
	end
	if not Const.ProgressRecoverDungeonType[self.EMGameState.GameModeType] then
		return false
	end
	return true
end

function ProgressSnapShotComponent:RecordProgressData()
	if not self:CheckProgressSnapShotEnable() then
		return
	end

	local ResData, _Data = self:GenerateProgressData("OnBattle")
	-- 发送给服务器
	UE4.UGameplayStatics.GetGameInstance(self):ClearProgressData()
	GWorld:GetAvatar():SaveProgressData(ResData)
end

---@type fun() : table 		@生成存储数据
---@param CurStage string 	@存储发生的时机，"OnBattle" 为下一轮开始时，"OnVoteBegin" 为刚发过UpdateDungeonProgress即将开始投票时
function ProgressSnapShotComponent:GenerateProgressData(CurStage)
	DebugPrint("ProgressSnapShotComponent: RecordProgressData")
	local StaticCreatorData = {}  -- {Data}  根据Data中是否存在ItemData判断 存在为机关 反之为怪物
	local RandomCreatorData = {}
	local PlayerData = {}

	-- 做当前副本内数据的快照
	local DungeonData = self:TriggerDungeonComponentFun("RecordDungeonRoundData")

	-- 做当前怪物静态点/随机点的快照
	for _, Monster in pairs(self.EMGameState.MonsterMap) do
		if IsValid(Monster) and not Monster:IsDead() and Monster.CreatorType == "StaticCreator" then
			if Monster.RandomCreatorId ~= 0 then
				local TmpData = {
					RandomRuleId = Monster.RandomRuleId,
					RandomTableId = Monster.RandomTableId,
					RandomLevelName = self.RandomActorManager:GetCreatorRegionDataLevelName(Monster.RandomRuleId,Monster.RandomCreatorId),
					RandomIdxInRule = self.RandomActorManager:GetCreatorRegionDataIdxInRule(Monster.RandomRuleId,Monster.RandomCreatorId),
				}
				if self:IsRandomCreatorInfoValid(TmpData, true) then
					table.insert(RandomCreatorData, TmpData)
				else
					DebugPrint("ProgressSnapShotComponent: 尝试存储非法随机点数据 Monster Eid", Monster.Eid, "UnitId", Monster.UnitId, "RandomCreatorId", Monster.RandomCreatorId)
				end
			elseif Monster.CreatorId ~= 0 then
				local TmpData = {
					StaticCreatorId = Monster.CreatorId,
					PrivateEnable = Monster.PrivateEnable,
					LevelName = self:GetActorLevelName(Monster);
				}
				table.insert(StaticCreatorData, TmpData)
			end
		end
	end

	--Npc
	for _, Monster in pairs(self.EMGameState.NpcMap) do
		if IsValid(Monster) and not Monster:IsDead() and Monster.CreatorType == "StaticCreator" then
			-- npc类甚至没有定义RandomCreatorId变量，说明不能用随机点刷npc，这段逻辑先干掉吧
			-- if Monster.RandomCreatorId ~= 0 then
			-- 	local TmpData = {
			-- 		RandomRuleId = Monster.RandomRuleId,
			-- 		RandomTableId = Monster.RandomTableId,
			-- 		RandomLevelName = self.RandomActorManager:GetCreatorRegionDataLevelName(Monster.RandomRuleId,Monster.RandomCreatorId),
			-- 		RandomIdxInRule = self.RandomActorManager:GetCreatorRegionDataIdxInRule(Monster.RandomRuleId,Monster.RandomCreatorId),
			-- 	}
			-- 	if self:IsRandomCreatorInfoValid(TmpData, true) then
			-- 		table.insert(RandomCreatorData, TmpData)
			-- 	else
			-- 		DebugPrint("ProgressSnapShotComponent: 尝试存储非法随机点数据 Npc Eid", Monster.Eid, "UnitId", Monster.UnitId, "RandomCreatorId", Monster.RandomCreatorId)
			-- 	end
			if Monster.CreatorId ~= 0 then
				if not Monster:IsPetNpc() then
					local TmpData = {
						StaticCreatorId = Monster.CreatorId,
						PrivateEnable = Monster.PrivateEnable,
						LevelName = self:GetActorLevelName(Monster);
					}
					table.insert(StaticCreatorData, TmpData)
				end
			end
		end
	end

	-- 做当前机关静态点/随机点的快照
	for _, CombatItem in pairs(self.EMGameState.CombatItemMap) do
		if IsValid(CombatItem) then
			-- 某些机关处于即将销毁的状态，如果存了，恢复后他就不会销毁了。所以干脆不存
			if CombatItem.CanDungeonSave and not CombatItem:CanDungeonSave() then
				DebugPrint("ProgressSnapShotComponent: CombatItem 即将销毁, 不存储", CombatItem:GetName(), CombatItem.Eid, CombatItem.CreatorId, CombatItem.UnitType)
			else
				if CombatItem.RandomCreatorId ~= 0 then
					local TmpData = {
						RandomRuleId = CombatItem.RandomRuleId,
						RandomTableId = CombatItem.RandomTableId,
						RandomLevelName = self.RandomActorManager:GetCreatorRegionDataLevelName(CombatItem.RandomRuleId, CombatItem.RandomCreatorId),
						RandomIdxInRule = self.RandomActorManager:GetCreatorRegionDataIdxInRule(CombatItem.RandomRuleId, CombatItem.RandomCreatorId),
						ItemData = CombatItem:GetDungeonSaveData() or {},
					}
					if self:IsRandomCreatorInfoValid(TmpData, true) then
						table.insert(RandomCreatorData, TmpData)
					else
						DebugPrint("ProgressSnapShotComponent: 尝试存储非法随机点数据 CombatItem Eid", CombatItem.Eid, "UnitId", CombatItem.UnitId, "RandomCreatorId", CombatItem.RandomCreatorId)
					end
				elseif CombatItem.CreatorId ~= 0 then
					if not CombatItem.IsPetDefenceMechanism then
						local TmpData = {
							StaticCreatorId = CombatItem.CreatorId,
							ItemData = CombatItem:GetDungeonSaveData() or {},
							PrivateEnable = CombatItem.PrivateEnable,
							LevelName = self:GetActorLevelName(CombatItem);
						}
						table.insert(StaticCreatorData, TmpData)
					end
				end
			end
		end
	end

	-- 做当前副本序列化数据的快照
	local TmpDungeonSnapShotData = TArray(FSnapShotInfo())
	self:GetDungeonSnapShotData(TmpDungeonSnapShotData)
	local DungeonSnapShotData = {}
	for i,j in pairs(TmpDungeonSnapShotData) do
		table.insert(DungeonSnapShotData, j)
		-- DebugPrint("序列化数据 :", i, "LevelName:", j.LevelName, "UnitId:", j.UnitId, "UnitType:", j.UnitType, 
        --     "SnapShotId:", j.SnapShotId, "Location:", j.Loc, "CreatorId:", j.CreatorId, "PrivateEnable:", j.PrivateEnable)
	end
	

	-- 做当前关卡JSON的快照
	local DungeonId = self.DungeonId
	local JsonName = UE4.URuntimeCommonFunctionLibrary.GetLevelLoadJsonName(self)
	local Eid = self:GetBattleEid()

	-- 做当前玩家身上数据的快照
	local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
	local PlayerTransform = CommonUtils:SerializeFTransform(Player:GetTransform())
	PlayerData = {
		HpPercent = Player:GetAttr("HpPercent"),
		CurrentLevelId = {}
	}
	for _, LevelId in pairs(Player.CurrentLevelId) do
		table.insert(PlayerData.CurrentLevelId, LevelId)
	end

	-- 做当前成就相关数据的快照
	local BattleAchievementData = {}
	if Player.BattleAchievement then
		-- 成就按轮次上报功能
		local DelayedTargetValues = {}
		for k,v in pairs(Player.BattleAchievement.DelayedTargetValues) do
			DelayedTargetValues[k] = v
		end
		BattleAchievementData.DelayedTargetValues = DelayedTargetValues
		local TopProcessedValue = {}
		for k,v in pairs(Player.BattleAchievement.TopProcessedValue) do
			TopProcessedValue[k] = v
		end
		BattleAchievementData.TopProcessedValue = TopProcessedValue
	end

	-- 做子关卡GameMode FirstActiveEnable的快照
	local SubGameModeData = {}
	for LevelName, SubGameMode in pairs(self.LevelGameMode.SubGameModeInfo) do
		SubGameModeData[LevelName] = SubGameMode.GameModeFirstActiveEnable
	end

	--- DungeonEvent相关 ---
	-- DungeonUIInfo
	local DungeonUIInfoData = {
		TexturePath = self.EMGameState.DungeonUIInfo.TexturePath,
		TextTitle = self.EMGameState.DungeonUIInfo.TextTitle,
		TextMap = self.EMGameState.DungeonUIInfo.TextMap,
	}

	-- DungeonEvent
	local DungeonEventData = {}
	for i = 1, self.EMGameState.DungeonEvent:Num() do
        local Event = self.EMGameState.DungeonEvent:GetValueByIdx(i-1)
        if Event ~= "ShowPetDefenseDynamicEvent" and Event ~= "ShowPetDefenseProgress" then		-- 不恢复宠物相关ui
			DungeonEventData[i] = Event
		end
    end
	------------------------

	-- 存储死亡次数
	local PlayerController = UE.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
	local PlayerState = PlayerController.PlayerState
	local RecoveryCountInfo = {}
	RecoveryCountInfo.RecoveryCount = PlayerState.RecoveryCount
	RecoveryCountInfo.RecoveryMaxCount = PlayerState.RecoveryMaxCount

	-- 死亡暂离自动复活
	if Player and Player:IsDead() and RecoveryCountInfo.RecoveryCount then
		RecoveryCountInfo.RecoveryCount = RecoveryCountInfo.RecoveryCount + 1
	end

	-- 副本计时
	local DungeonTimeData = {}
	DungeonTimeData.GameTime = self.EMGameState:GetGameEndTime()
	DungeonTimeData.PlayerTime = PlayerState:GetPlayerEndTime()

	-- 轮次自动进行
	local AutoNextRoundInfo = {}
	AutoNextRoundInfo.TicketId = GWorld.GameInstance:GetTicketId()
	local CachedWalnutId, CachedWalnutType = WalnutUtils:GetWalnutCacheIdByDungeonId(self.DungeonId)
	AutoNextRoundInfo.WalnutId = CachedWalnutId
	AutoNextRoundInfo.WalnutType = CachedWalnutType

	local ResData = {
		Eid = Eid,
		DungeonId = DungeonId,
		JsonName = JsonName,
		PlayerData = PlayerData,
		PlayerTransform = PlayerTransform,
		DungeonSnapShotData = DungeonSnapShotData,
		DungeonData = DungeonData,
		StaticCreatorData = StaticCreatorData,
		RandomCreatorData = RandomCreatorData,
		SubGameModeData = SubGameModeData,
		BattleAchievementData = BattleAchievementData,
		DungeonUIInfoData = DungeonUIInfoData,
		DungeonEventData = DungeonEventData,
		RecoveryCountInfo = RecoveryCountInfo,
		DungeonTimeData = DungeonTimeData,
		AutoNextRoundInfo = AutoNextRoundInfo,
		CurStage = CurStage,
	}
	PrintTable(ResData, 6)

	return ResData, TmpDungeonSnapShotData
end

---@return string @返回存储阶段，方便后续按阶段恢复进度
function ProgressSnapShotComponent:RecoverProgressData()
	local ProgressData = self:GetProgressData()
	if not ProgressData then 
		DebugPrint("ProgressSnapShotComponent       error  no data")
		return
	end
	DebugPrint("ProgressSnapShotComponent: RecoverProgressData")
	PrintTable(ProgressData, 6)
	UE4.UGameplayStatics.GetGameInstance(self):ClearProgressData()

	-- 恢复玩家血量
	local PlayerHpPercent = ProgressData.PlayerData.HpPercent or 1.0
	local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
	Player:SetAttr("Hp", Player:GetAttr("MaxHp") * PlayerHpPercent)
	-- Todo: 下面应该调一下同步血条ui的接口

	-- 恢复玩家CurrentLevelId
	local PlayerCurrentLevelId = ProgressData.PlayerData.CurrentLevelId
	local LevelIdArray = TArray(FString)
	for _, LevelId in pairs(PlayerCurrentLevelId) do
		LevelIdArray:Add(LevelId)
	end
	Player:SetCurrentLevelId(LevelIdArray)

	-- 成就相关数据恢复
	if ProgressData.BattleAchievementData and Player.BattleAchievement then
		for k,v in pairs(ProgressData.BattleAchievementData.DelayedTargetValues) do
			Player.BattleAchievement.DelayedTargetValues:Add(k, v)
		end
		for k,v in pairs(ProgressData.BattleAchievementData.TopProcessedValue) do
			Player.BattleAchievement.TopProcessedValue:Add(k, v)
		end
	end

	-- 激活一遍静态点
	for _, Data in pairs(ProgressData.StaticCreatorData) do 
		local Creator = self.EMGameState:GetStaticCreatorInfo(Data.StaticCreatorId, Data.PrivateEnable, Data.LevelName)  -- 机关
		if Creator then
			-- 怪物、机关初始化完毕后会检查当前关卡是否加载，如果未加载会销毁并变回序列化数据
			-- 所以即使恢复前关卡已经加载，恢复后直接激活也不会有问题
			if Data.ItemData then  -- 依赖于机关是否有ItemData进行判断，不是很好但先这样 
				Creator:RealActiveStaticCreator({DungeonState = Data.ItemData}) -- DungeonState：机关恢复数据
			else
				Creator:RealActiveStaticCreator()
			end
		else
			DebugPrint("ProgressSnapShotComponent: 找不到静态点,, StaticCreatorId", Data.StaticCreatorId, "PrivateEnable", Data.PrivateEnable, "LevelName", Data.LevelName)
		end
	end

	-- 激活一遍随机点
	for i, RandomData in pairs(ProgressData.RandomCreatorData) do
		if self:IsRandomCreatorInfoValid(RandomData, false) then
			self.RandomActorManager:ProgressDataRecoverRandomActor(RandomData.RandomRuleId, RandomData.RandomLevelName, RandomData.RandomIdxInRule, RandomData.RandomTableId, RandomData.ItemData)
		end
	end

	-- 进行副本的数据恢复,优先级低
	-- 理论上不会出现，恢复前关卡没加载，恢复后关卡加载了的情况
	self:TriggerDungeonComponentFun("RecoverDungeonRoundData", ProgressData.DungeonData)

	-- 复制序列化数据
	self:SetDungeonSnapShotData(ProgressData.DungeonSnapShotData)
	-- for i, j in pairs(ProgressData.DungeonSnapShotData) do
	-- 	DebugPrint("恢复序列化数据 :", i, "LevelName:", j.LevelName, "UnitId:", j.UnitId, "UnitType:", j.UnitType, 
    --         "SnapShotId:", j.SnapShotId, "Location:", j.Loc, "CreatorId:", j.CreatorId, "PrivateEnable:", j.PrivateEnable)
	-- end

	-- 子关卡SubGameMode FirstActiveEnable恢复
	for LevelName, FirstActiveEnable in pairs(ProgressData.SubGameModeData) do
		local SubGameMode = self.LevelGameMode.SubGameModeInfo:FindRef(LevelName)
		if SubGameMode then
			SubGameMode.GameModeFirstActiveEnable = FirstActiveEnable
		else
			DebugPrint("ProgressSnapShot 子GameMode不存在，LevelName：", LevelName)
		end
	end

	--- DungeonEvent相关 ---
	-- DungeonUIInfo
	self.EMGameState.DungeonUIInfo.TexturePath = ProgressData.DungeonUIInfoData.TexturePath
	self.EMGameState.DungeonUIInfo.TextTitle = ProgressData.DungeonUIInfoData.TextTitle
	self.EMGameState.DungeonUIInfo.TextMap = ProgressData.DungeonUIInfoData.TextMap
	self.EMGameState:MarkDungeonUIInfoAsDirtyData()

	-- DungeonEvent
	for _, Event in pairs(ProgressData.DungeonEventData) do
		self:AddDungeonEvent(Event)
	end
	-------------------------

	-- 恢复死亡次数
	Player:SetRecoveryCount(ProgressData.RecoveryCountInfo.RecoveryCount)
	Player:SetRecoveryMaxCount(ProgressData.RecoveryCountInfo.RecoveryMaxCount)

	-- 恢复副本计时
	if ProgressData.DungeonTimeData then
		self.EMGameState.RecoveredGameTime = ProgressData.DungeonTimeData.GameTime or 0
		if Player.PlayerState then
			Player.PlayerState.RecoveredPlayerTime = ProgressData.DungeonTimeData.PlayerTime or 0
		end
	end

	-- 恢复轮次自动进行
	if ProgressData.AutoNextRoundInfo then
		local SavedTickId = ProgressData.AutoNextRoundInfo.TicketId
		if SavedTickId then
			GWorld.GameInstance:SetTicketId(SavedTickId)
		end
		local SavedWalnutId = ProgressData.AutoNextRoundInfo.WalnutId
		local SavedWalnutType = ProgressData.AutoNextRoundInfo.WalnutType
		if SavedWalnutId and SavedWalnutType then
			WalnutUtils:SetWalnutCacheId(SavedWalnutId, SavedWalnutType)
		end
	end

	local ResCurStage = ProgressData.CurStage or "OnBattle"
	if self:IsWalnutDungeon() and (ResCurStage == "OnVoteBegin") then
		local Avatar = GWorld:GetAvatar()
		if Avatar then
			local CurWalnutId = Avatar.Walnuts.WalnutId
			-- 可能出现 客户端还没收到选核桃成功的rpc 就直接关闭了客户端的情况，
			-- 导致服务器那边已经选了核桃，但是客户端恢复后还需要再选一次核桃
			-- 因此这里根据玩家是否选择过核桃进行修正：-1为选择不装备，0为还未作出选择，>0为对应核桃；若做出过选择则跳过选核桃阶段
			if (CurWalnutId == -1) or (CurWalnutId > 0) then
				ResCurStage = "OnBattle"
			end
		end
	end
	return ResCurStage
end 

function ProgressSnapShotComponent:OnProgressRecoverSucceed()
	-- 目前暂不支持添加代码
	self.Overridden.OnProgressRecoverSucceed(self)
end

-- 投票后选门票 选核桃都是后来加的流程，因此在恢复后且需要弹出选门票或核桃时，需要做一些额外的逻辑处理
function ProgressSnapShotComponent:DoCustomLogicOnRecoverToVoteEnd()
	-- 生存特殊处理，策划在OnProgressRecoverSucceed后面做了诸如维生装置定时刷新等逻辑，必须调一次（OnBattle重复调用其实没有影响
	-- 挖掘 防御，OnProgressRecoverSucceed和OnBattle是同一逻辑，所以无需再走一次
	if self.EMGameState.GameModeType == "SurvivalMini" then
		self:OnProgressRecoverSucceed()
	end

	-- 弹出选核桃流程特殊处理，需要补充全局暂停。tag用"NextWalnutRecover"，这个tag会在NextWalnut阶段结束后移除
	-- 门票的CommonDialog弹窗已有全局暂停，就不处理了
	if self:IsWalnutDungeon() then
		-- 不能当前帧就暂停，等ui开启再暂停吧
		EventManager:AddEvent(EventID.OnDungeonWalnutChoiceUIOpen, self, function()
			EventManager:RemoveEvent(EventID.OnDungeonWalnutChoiceUIOpen, self)
			self:SetGamePaused("NextWalnutRecover", true)
		end)
	end
end

---@type fun() : boolean	@判断即将存入/恢复的随机点数据是否正常
---@param TmpInfo RandomCreatorInfo
---@param IsRecord boolean	@是否是存储时发生的
function ProgressSnapShotComponent:IsRandomCreatorInfoValid(TmpInfo, IsRecord)
	if (not TmpInfo.RandomLevelName) or (TmpInfo.RandomLevelName == "") then
		ScreenPrint("ProgressSnapShotComponent: 非法的随机点数据, RandomLevelName非法  是否发生在存储时: "..tostring(IsRecord))
		return false
	end

	if not TmpInfo.RandomRuleId then
		ScreenPrint("ProgressSnapShotComponent: 非法的随机点数据, RandomRuleId为空  是否发生在存储时: "..tostring(IsRecord))
		return false
	end

	if not TmpInfo.RandomTableId then
		ScreenPrint("ProgressSnapShotComponent: 非法的随机点数据, RandomTableId为空  是否发生在存储时: "..tostring(IsRecord))
		return false
	end

	return true
end

-------- 肉鸽玩法恢复相关 ----------
function ProgressSnapShotComponent:RougeRecordProgressData(PassRoomExtraInfo)
	if self:IsAllRoomPassed() then
		DebugPrint("ProgressSnapShotComponent: 所有房间已通关后不允许存储")
		return
	end
	if self:IsDungeonInSettlement() then
		DebugPrint("ProgressSnapShotComponent: 副本已结算后不允许存储")
		return
	end

	local IsCurRoomClear = GWorld.RougeLikeManager:IsCurRougeLikeRoomClear()
	local IsInEvent = GWorld.RougeLikeManager.IsListeningDealRewardEvent or false
	DebugPrint("ProgressSnapShotComponent: RougeRecordProgressData 当前房间是否通关：", IsCurRoomClear, "是否正处于事件关的事件中", IsInEvent)

	
	-- 做是否通关的快照，用于判断返回后是否需要激活OnFirstActive
	-- 仅需要存储是否通关，激活OnFirstActive在恢复时做
	
	-- 是否需要弹出ui，依赖传入PassRoomExtraInfo值进行判断

	-- 是否需要重新生成传送点，依赖是否通关进行判断

	-- 存储死亡次数
	local PlayerController = UE.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
	local PlayerState = PlayerController.PlayerState
	local RecoveryCountInfo = {}
	RecoveryCountInfo.RecoveryCount = PlayerState.RecoveryCount
	RecoveryCountInfo.RecoveryMaxCount = PlayerState.RecoveryMaxCount

	local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
	-- 死亡暂离自动复活
	if Player and Player:IsDead() and RecoveryCountInfo.RecoveryCount then
		RecoveryCountInfo.RecoveryCount = RecoveryCountInfo.RecoveryCount + 1
	end

	-- 存储Buff
	DebugPrint("Tianyi@ 开始暂存肉鸽Buff")
	local BuffsSnapshot = {}
	local BuffManager = Player.BuffManager
	if BuffManager then 
		BuffsSnapshot = BuffManager:GetBuffsSnapshot()
		PrintTable(BuffsSnapshot, 6, "BuffsSnapshot", true)
	end

	local StaticCreatorData = {}
	-- 做当前机关的快照（暂时默认机关只由静态点刷出来）
	for _, CombatItem in pairs(self.EMGameState.CombatItemMap) do
		if IsValid(CombatItem) then
			if CombatItem.CreatorId ~= 0 and CombatItem.UnitId ~= 112 then 		-- 炮台不要恢复 否则会恢复多（分支临时这么处理吧，主干再研究）
				local TmpData = {
					StaticCreatorId = CombatItem.CreatorId,
					ItemData = CombatItem:GetDungeonSaveData() or {},
					PrivateEnable = CombatItem.PrivateEnable,
					LevelName = self:GetActorLevelName(CombatItem);
				}
				table.insert(StaticCreatorData, TmpData)
				--StaticCreatorData[CombatItem.CreatorId] = TmpData
			end
		end
	end

	-- 做当前NPC的快照（暂时仅用于商人的恢复，但接口更通用以兼容所有静态点刷出来的NPC）
	for _, NPC in pairs(self.EMGameState.NpcMap) do
		if IsValid(NPC) then
			if NPC.CreatorId then
				local TmpData = {
					StaticCreatorId = NPC.CreatorId,
					PrivateEnable = NPC.PrivateEnable,
					LevelName = self:GetActorLevelName(NPC);
				}
				table.insert(StaticCreatorData, TmpData)
			end
		end
	end

	-- 商人shop信息恢复
	local ShopInfo = GWorld.RougeLikeManager.StaticCreatorIdToShopId

	-- 战斗关进度的存储
	local BattleProgressNums = {}
	BattleProgressNums.Count = self.EMGameState.RougeBattleCount
	BattleProgressNums.MaxNum = self.EMGameState.RougeBattleMaxNum

	--蓝图数据存储
	local DataSetObj=GWorld.RougeLikeManager:GetOrAddDataSetObject()
	local DataSetObjInfo={}
	local ExtraInt=DataSetObj.ExtraInt:ToTable()
	DataSetObjInfo["SetInt"]=ExtraInt
	local ExtraBool=DataSetObj.ExtraBool:ToTable()
	DataSetObjInfo["SetBool"]=ExtraBool
	local ExtraFloat=DataSetObj.ExtraFloat:ToTable()
	DataSetObjInfo["SetFloat"]=ExtraFloat
	local ExtraVector=DataSetObj.ExtraVector:ToTable()
	DataSetObjInfo["SetVector"]=ExtraVector
	local SaveLocations=DataSetObj.SaveLocations:ToTable()
	DataSetObjInfo["SaveLoc"]=SaveLocations
	local ExtraString=DataSetObj.ExtraString:ToTable()
	DataSetObjInfo["SetString"]=ExtraString

	-- 盗宝怪刷新概率存储
	local TreasureMonInfo = {}
	TreasureMonInfo.TreasureMonProb = self.TreasureMonsterSpawnProbability
	TreasureMonInfo.TreasureMonCreatedNum = self.TreasureMonsterCreatedNum

	-- DungeonUIInfo
	local DungeonUIInfoData = {}
	if self.EMGameState.DungeonUIInfo.TextMap ~= "" then
		DungeonUIInfoData = {
			TexturePath = self.EMGameState.DungeonUIInfo.TexturePath,
			TextTitle = self.EMGameState.DungeonUIInfo.TextTitle,
			TextMap = self.EMGameState.DungeonUIInfo.TextMap,
			RougeLikeSubTaskText = self.RougeLikeSubTaskText,
		}
	end
	local IsSimpleDesc=GWorld.RougeLikeManager.IsSimpleDesc
	local IsListeningDealRewardEvent = GWorld.RougeLikeManager.IsListeningDealRewardEvent
	local ResData = {
		IsRougeLike = true,
		DungeonId = self.DungeonId,
		PassRoomExtraInfo = PassRoomExtraInfo,
		RecoveryCountInfo = RecoveryCountInfo,
		StaticCreatorData = StaticCreatorData,
		BattleProgressNums = BattleProgressNums,
		ShopInfo = ShopInfo,
		BuffsSnapshot = BuffsSnapshot,
		DataSetObjInfo=DataSetObjInfo,
		TreasureMonInfo = TreasureMonInfo,
		DungeonUIInfoData = DungeonUIInfoData,
		IsSimpleDesc = IsSimpleDesc,
		IsListeningDealRewardEvent = IsListeningDealRewardEvent,
	}
	PrintTable(ResData, 6, "ResData")

	-- 发送给服务器
	UE4.UGameplayStatics.GetGameInstance(self):ClearProgressData()
	GWorld:GetAvatar():SaveProgressData(ResData)
end

function ProgressSnapShotComponent:RougeRecoverProgressData()
	local ProgressData = self:GetProgressData()
	if not ProgressData then 
		DebugPrint("ProgressSnapShotComponent       error  no data")
		return
	end

	local IsCurRoomClear = GWorld.RougeLikeManager:IsCurRougeLikeRoomClear()
	local IsInEvent = ProgressData.IsListeningDealRewardEvent or false					-- 似乎没有什么很好的方式判断是否处于 SelectEvent 到 PassRoom这个期间。就先按客户端这个标记的存储恢复来判断吧

	DebugPrint("ProgressSnapShotComponent: RougeRecoverProgressData 当前房间是否通关：", IsCurRoomClear, "是否正处于事件关的事件中", IsInEvent)
	PrintTable(ProgressData, 6)
	UE4.UGameplayStatics.GetGameInstance(self):ClearProgressData()

	-- 恢复死亡次数
	local PlayerController = UE.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
	local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
	local PlayerState = PlayerController.PlayerState
	PlayerState:SetRecoveryCount(ProgressData.RecoveryCountInfo.RecoveryCount)
	PlayerState:SetRecoveryMaxCount(ProgressData.RecoveryCountInfo.RecoveryMaxCount)

	-- 恢复Buff
	local BuffsSnapshot = ProgressData.BuffsSnapshot 
	local RecoveredBuffsNum = 0
	DebugPrint("Tianyi@ 开始恢复Buff")
	for _, BuffSnapshot in ipairs(BuffsSnapshot) do 
		local BuffId = BuffSnapshot.BuffId
		local BuffConfig = DataMgr.Buff[BuffId] 
		if not BuffConfig then 
			DebugPrint("Tianyi@ Buff恢复失败, 存在非法BuffId: ", BuffId)
			goto continue 
		end

		local MergeRule2 = BuffConfig.MergeRule2
		if MergeRule2 == "Merge" then 
			local LastTime = BuffSnapshot.bForever and -1 or BuffSnapshot.LastTime
			local AddedBuffs = Battle(self):AddBuffToTarget(Player, Player, BuffId, LastTime, BuffSnapshot.Value, Player, BuffSnapshot.Layer)
			if AddedBuffs:Num() > 0 then 
				RecoveredBuffsNum = RecoveredBuffsNum + 1 
			end
		elseif MergeRule2 == "NewFree" then 
			-- NewFree需要一层一层添加
			local AddedBuffs = nil
			for i = 1, #BuffSnapshot.FreeLayerInfos do 
				local FreeLayerInfo = BuffSnapshot.FreeLayerInfos[i]
				if i == 1 then 
					local LastTime = FreeLayerInfo.bForever and -1 or FreeLayerInfo.LastTime
					AddedBuffs = Battle(self):AddBuffToTarget(Player, Player, BuffId, LastTime, FreeLayerInfo.Value, Player, 1)
					if AddedBuffs:Num() > 0 then 
						RecoveredBuffsNum = RecoveredBuffsNum + 1 
					end
				else 
					if AddedBuffs then 
						local AddedBuff = AddedBuffs:GetRef(1)
						if AddedBuff then 
							Battle(self):IncreaseBuffLayerFromTarget(AddedBuff, Player, FreeLayerInfo.LastTime, FreeLayerInfo.Value, Player:GetSkillLevelInfo(), 1, false)
						end
					else
						DebugPrint("Tianyi@ AddedBuffs is nil")
					end
				end
			end
		end
		::continue::
	end

	if #BuffsSnapshot > 0 then 
		Player:RefreshBuff()
		if RecoveredBuffsNum == #BuffsSnapshot then
			DebugPrint("Tianyi@ Buff恢复成功")
		else
			DebugPrint("Tianyi@ Buff恢复失败, 恢复了" .. tostring(RecoveredBuffsNum) .. "个Buff, 但总共有" .. tostring(#BuffsSnapshot) .. "个Buff")
		end
	end

	--恢复DataSet
	local DataSetObjInfo=ProgressData.DataSetObjInfo
	local DataSetObj=GWorld.RougeLikeManager:GetOrAddDataSetObject()

	-- 恢复盗宝怪刷新概率
	if ProgressData.TreasureMonInfo then
		self.TreasureMonsterCreatedNum = ProgressData.TreasureMonInfo.TreasureMonCreatedNum
		self.TreasureMonsterSpawnProbability = ProgressData.TreasureMonInfo.TreasureMonProb
	end

	-- 恢复实时保存数据
	local PlayerSliceData = self:GetPlayerSliceData()
	local Length = PlayerSliceData:Length()
	local TypeExist = {}
	local BlueprintValueKeyExist = {}
	for i = Length, 1, -1 do 
		local SerializedPlayerSliceData = SerializeUtils:UnSerialize(PlayerSliceData[i])

		local Type = SerializedPlayerSliceData.Type 
		local Value = SerializedPlayerSliceData.Value
		if TypeExist[Type] then goto continue end
		DebugPrint("Tianyi@ Reocver Player State, Type = " .. tostring(Type) .. " Value = ")
		PrintTable(Value, 10)
		if Type == Const.RougeSliceInfoType.RecoverCount then
			Player:SetRecoveryCount(Value.RecoveryCount)
			TypeExist[Type] = true
		elseif Type == Const.RougeSliceInfoType.TreasureMonCount then
			self.TreasureMonsterCreatedNum = Value.TreasureMonCount
			DebugPrint("RougeLike Recover, TreasureMonsterCreatedNum =", self.TreasureMonsterCreatedNum)
			TypeExist[Type] = true
		elseif Type == Const.RougeSliceInfoType.BlueprintValue then 
			if not BlueprintValueKeyExist[Value.Key] then 
				local DataType = Value.DataType 
				local DataValue = Value.DataValue
				DataSetObjInfo[DataType] = DataSetObjInfo[DataType] or {}
				DataSetObjInfo[DataType][Value.Key] = DataValue
				BlueprintValueKeyExist[Value.Key] = true
			end

		end
		::continue::
	end
	UE4.UGameplayStatics.GetGameInstance(self):ClearPlayerSliceData()


	--GWorld.RougeLikeManager:SetDataSetObject(DataSetObj)
	for FuncName, MapName in pairs(DataSetObjInfo) do
		for key, value in pairs(MapName) do
			local DataSetFunc = GWorld.RougeLikeManager[FuncName]
			if DataSetFunc and type(DataSetFunc) == 'function' then
				DataSetFunc(GWorld.RougeLikeManager,key,value)
				DebugPrint("Tianyi@ 恢复了蓝图数据: ", key, value)
			else
				DebugPrint("Tianyi@ 恢复蓝图数据失败, 不存在该函数: ", FuncName)
			end
		end
	end

    Battle(self):TriggerBattleEvent(BattleEventName.RougeParamRecover,Player, GWorld.RougeLikeManager)

-------- 肉鸽流程阶段恢复 ---------
--- 流程恢复只需要关注以下几个重要节点：
--- 战斗关：进入房间 EnterRoom、房间通关 PassRoom
--- 事件关：进入房间 EnterRoom、选择事件 SelectEvent、房间通关 PassRoom
--- 其他：通关时播story

	-- 机关状态恢复、NPC恢复
	if IsInEvent or IsCurRoomClear then
		local StaticCreatorData = ProgressData.StaticCreatorData
		if StaticCreatorData then
			for _, Data in pairs(StaticCreatorData) do
				local Creator = self.EMGameState:GetStaticCreatorInfo(Data.StaticCreatorId, Data.PrivateEnable, Data.LevelName)  -- 机关
				if Creator then  
					if Data.ItemData then
						Creator:RealActiveStaticCreator({DungeonState = Data.ItemData}) -- DungeonState：机关恢复数据
					else
						Creator:RealActiveStaticCreator()
					end
				else
					DebugPrint("找不到静态点,, StaticCreatorId", Data.StaticCreatorId, "PrivateEnable", Data.PrivateEnable, "LevelName", Data.LevelName)
				end
			end
		end

		-- 商人信息恢复
		local ShopInfo = ProgressData.ShopInfo
		if ShopInfo then
			GWorld.RougeLikeManager.StaticCreatorIdToShopId = ShopInfo
		end
	end

	-- 是否需要激活OnFirstActive(通常策划会用于配置刷新怪物/机关)
	if IsInEvent or IsCurRoomClear then
		for LevelName, SubGameMode in pairs(self.LevelGameMode.SubGameModeInfo) do
			SubGameMode.GameModeFirstActiveEnable = false
			DebugPrint("ProgressSnapShotComponent: SubGameMode", LevelName, SubGameMode:GetName(), "关闭OnFirstActive")
		end
	end

	-- 任务栏
	if IsInEvent or IsCurRoomClear then
		if ProgressData.DungeonUIInfoData.TextMap and ProgressData.DungeonUIInfoData.TextMap ~= "" then
			local TexturePath = ProgressData.DungeonUIInfoData.TexturePath
			local TextTitle = ProgressData.DungeonUIInfoData.TextTitle
			local TextMap = ProgressData.DungeonUIInfoData.TextMap
			--self:NotifyClientShowDungeonTask("", TexturePath, TextTitle, TextMap)
			self:NotifyClientShowDungeonTaskNew(TexturePath, TextTitle, TextMap)

			local RougeLikeSubTaskText = ProgressData.DungeonUIInfoData.RougeLikeSubTaskText
			if RougeLikeSubTaskText then
				self:InitRougeLikeSubTask(RougeLikeSubTaskText)
			end
		end
	end

	-- 战斗关进度ui恢复
	if IsCurRoomClear then
		local BattleProgressNums = ProgressData.BattleProgressNums
		if BattleProgressNums then
			self.EMGameState:SetRougeBattleNums(BattleProgressNums.Count, BattleProgressNums.MaxNum)
		end
	end
	
	--3选一奖励界面简述
	GWorld.RougeLikeManager.IsSimpleDesc=ProgressData.IsSimpleDesc

	-- 监听获得奖励界面恢复
	if ProgressData.IsListeningDealRewardEvent and not IsCurRoomClear then
		GWorld.RougeLikeManager:ListenDealRewardEvent()

		-- 如果EventId不为0，说明对应游戏/战斗事件还未结束，应该恢复为 继续进行事件（即 下面的self:PostCustomEvent(GameModeEvent)）
		if GWorld.RougeLikeManager.EventId <= 0 then

			-- 补充OnPassEvent，TryEventPassRoom相关逻辑
			-- 如果客户端在收到OnPassEvent前就掉线，暂离返回后根据奖励类型有三种情况
			-- 1. 三选一奖励，在选择奖励后会FireEvent
			-- 2. 单个奖励，SetTreasue/SetBlessings后会FireEvent （理论上不用在这里处理，保持一致
			-- 3. 无奖励，不会FireEvent，因此需要在这里补充

			if GWorld.RougeLikeManager.RandomBlessings:Num() <= 0 and GWorld.RougeLikeManager.RandomTreasures:Num() <= 0 then
				EventManager:FireEvent(EventID.OnRougeDealEventReward)
			end
		end
	end

	-- 重新弹出传送点
	if IsCurRoomClear then
		local RecoveryFlag = true
		GWorld.RougeLikeManager:OnPassRoom(RecoveryFlag)  -- 参数暂时用不上，就不传了
	end

	-- 事件关已触发事件后恢复
	-- 应该只需要用RougeLikeManager.EventId来判断
	local CurrentEventId = GWorld.RougeLikeManager.EventId
	DebugPrint("ProgressSnapShotComponent 当前事件ID为：", CurrentEventId)
	if CurrentEventId > 0 then
		local GameModeEvent = DataMgr.RougeLikeEventSelect[CurrentEventId].GameModeEvent
		if GameModeEvent then
			DebugPrint("ProgressSnapShotComponent: 恢复触发事件关事件", GameModeEvent)
			self:PostCustomEvent(GameModeEvent)
		end
	end

	-- 肉鸽通关播Story
	-- 不能仅依赖RougeLikeManager.StoryId判断，因为房间通关的事件也有RougeLikeManager.StoryId，无法区分
	-- 所以存储时也必须存储是否为要播RougeFinishedStory
	if ProgressData.PassRoomExtraInfo.IsRougeFinished then
		if GWorld.RougeLikeManager.StoryId ~= 0 then
			DebugPrint("ProgressSnapShotComponent: 恢复触发通关Story", GWorld.RougeLikeManager.StoryId, "是否通关:", ProgressData.PassRoomExtraInfo.IsWin)
			self:ShowFinishRougeStory(ProgressData.PassRoomExtraInfo.IsWin)
		else
			DebugPrint("ProgressSnapShotComponent: 恢复直接通关! 是否通关:", ProgressData.PassRoomExtraInfo.IsWin)
			local LoadingUI = GWorld.GameInstance:GetLoadingUI()
			if LoadingUI then
				EventManager:AddEvent(EventID.CloseLoading, self, function()
					EventManager:RemoveEvent(EventID.CloseLoading, self)
					self:AddTimer(5, function()
						self:TriggerRealFinish(ProgressData.PassRoomExtraInfo.IsWin)
					end)
				end)
			else
				self:TriggerRealFinish(ProgressData.PassRoomExtraInfo.IsWin)
			end
		end
	end
end
-----------------------------------------------------------------

function ProgressSnapShotComponent:AbyssRecordProgressData(AbyssInfo)
	DebugPrint("ProgressSnapShotComponent: AbyssRecordProgressData")

	-- 做当前关卡JSON的快照
	local JsonName = UE4.URuntimeCommonFunctionLibrary.GetLevelLoadJsonName(self)

	-- 做当前玩家位置的快照
	local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
	local PlayerTransform = CommonUtils:SerializeFTransform(Player:GetTransform())
	-- -- 做当前玩家LevelId的快照		不存了 Loading后会自动更新CurrentLevelId
	-- local PlayerCurrentLevelId = {}
	-- for _, LevelId in pairs(Player.CurrentLevelId) do
	-- 	table.insert(PlayerCurrentLevelId, LevelId)
	-- end

	local ResData = {
		IsAbyss = true,
		DungeonId = self.DungeonId,
		AbyssLogicServerInfo = self:GetDungeonComponent().AbyssLogicServerInfo,
		JsonName = JsonName,
		PlayerTransform = PlayerTransform,
		--PlayerCurrentLevelId = PlayerCurrentLevelId,
		LastLevelId = AbyssInfo.LastLevelId,
		NewLevelId = AbyssInfo.NewLevelId,
		AbyssRoomIndex = self:TriggerDungeonComponentFun("GetAbyssRoomIndex"),
		PreAbyssLevelProgress = GWorld.GameInstance.PreAbyssLevelProgress,
	}
	PrintTable(ResData, 6)

	-- 发送给服务器
	UE4.UGameplayStatics.GetGameInstance(self):ClearProgressData()
	GWorld:GetAvatar():SaveProgressData(ResData)
end

function ProgressSnapShotComponent:AbyssRecoverProgressData()
	local ProgressData = self:GetProgressData()
	if not ProgressData then 
		DebugPrint("ProgressSnapShotComponent    Abyss   error  no data")
		return
	end
	DebugPrint("ProgressSnapShotComponent: AbyssRecoverProgressData")
	PrintTable(ProgressData, 6)
	UE4.UGameplayStatics.GetGameInstance(self):ClearProgressData()

	-- -- 恢复玩家CurrentLevelId
	-- local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
	-- local PlayerCurrentLevelId = ProgressData.PlayerCurrentLevelId
	-- local LevelIdArray = TArray(FString)
	-- for _, LevelId in pairs(PlayerCurrentLevelId) do
	-- 	LevelIdArray:Add(LevelId)
	-- end
	-- Player:SetCurrentLevelId(LevelIdArray)

	-- InitAbyssBaseInfo
	self:TriggerDungeonComponentFun("InitGlobalPassive")
	self:GetDungeonComponent().AbyssRoomIndex = ProgressData.AbyssRoomIndex
	self:TriggerDungeonComponentFun("TriggerStartNextRoom", ProgressData.LastLevelId, ProgressData.NewLevelId)
	
	--上一次最佳通过房间数（esc/结算用）
	GWorld.GameInstance.PreAbyssLevelProgress = ProgressData.PreAbyssLevelProgress
end

function ProgressSnapShotComponent:GetProgressDataAbyssLogicServerInfo()
	local ProgressData = self:GetProgressData()
	if ProgressData then
		return ProgressData.AbyssLogicServerInfo
	end
	return nil
end

return ProgressSnapShotComponent

