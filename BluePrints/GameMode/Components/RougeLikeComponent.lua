
require "UnLua"
require "Const"
local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"

local RougeLikeComponent = {}

------------------RougeLike--------------------------
--------- GameMode Rougelike 相关 --------------------
function RougeLikeComponent:TriggerRougeLikeEnd(IsWin)
    if not GWorld.RougeLikeManager then
		self.EMGameState:ShowDungeonError("TriggerRougeLikeEnd 拿不到 RougeLikeManager", Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.FindObject)
        return
    end

	DebugPrint("TriggerRougeLikeEnd RoomId", GWorld.RougeLikeManager.RoomId)

    local TotalTime = self.LevelGameMode:StopAndGetRougeLikeTimer()

    local function Callback()
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            local TotalTime = self.LevelGameMode:StopAndGetRougeLikeTimer()
            Avatar:PassRoom(TotalTime)
        else 
            self.EMGameState:ShowDungeonError("TriggerRougeLikeEnd 拿不到 Avatar", Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.FindObject)
        end
        -- DebugPrint("TriggerRougeLikeEnd ", IsWin, "! 时间膨胀结束，上报服务器PassRoom")
    end
    if IsWin then
        local RoomInfo = DataMgr.RougeLikeRoom[GWorld.RougeLikeManager.RoomId]
        local TypeInfo = DataMgr.RougeLikeRoomType[RoomInfo.RoomType]
        if TypeInfo.EnableTimeDilation then
            GWorld.RougeLikeManager:EnterRougeLikeBulletTime(0.2, 1, Callback)
        else
            Callback()
        end
    else
        Callback()
    end
    -- DebugPrint("TriggerRougeLikeEnd ", IsWin, "! 开始时间膨胀")
end

function RougeLikeComponent:FinishRougeLike(IsWin, AvatarEids)
	if self:IsDungeonInSettlement() then
		return
	end

	local RealFinishRougeLike = function(bStoryEvent)
		DebugPrint("RougeLikeComponent:RealFinishRougeLike bStoryEvent", bStoryEvent)
        if bStoryEvent then
			self:ShowFinishRougeStory(IsWin, AvatarEids)
		else
			self:TriggerRealFinish(IsWin, AvatarEids)
		end
	end

	GWorld.RougeLikeManager:TriggerRecordProgressData({
		IsRougeFinished = true,
		IsWin = IsWin,
	})

	local Avatar = GWorld:GetAvatar()
	Avatar:PreFinishRougeLike(RealFinishRougeLike, IsWin)
end

function RougeLikeComponent:ShowFinishRougeStory(IsWin, AvatarEids)
	EventManager:AddEvent(EventID.OnRougeLikeStoryEventEnd, self, function()
		DebugPrint("RougeLikeComponent:ReceivedEvent EventID.OnRougeLikeStoryEventEnd")
		EventManager:RemoveEvent(EventID.OnRougeLikeStoryEventEnd, self)
		self:TriggerRealFinish(IsWin, AvatarEids)
	end)
	GWorld.RougeLikeManager:ShowRougeStoryEvent()
end

function RougeLikeComponent:TriggerRealFinish(IsWin, AvatarEids)
	if IsWin then
		self:TriggerDungeonWin()
	else
		if AvatarEids then
			self:TriggerPlayerFailed(AvatarEids)
		else
			self:TriggerDungeonFailed()
		end
	end
end

-- 从一个房间到另一个房间时会调用（从外面到第一个房间时不会）
function RougeLikeComponent:OnRougeLikeEnterNextRoom()
    DebugPrint("RougeLike OnRougeLikeEnterNextRoom RoomIndex:", GWorld.RougeLikeManager.RoomIndex, "RoomId:", GWorld.RougeLikeManager.RoomId)

	if GWorld.RougeLikeManager.IsListeningDealRewardEvent then
		self.EMGameState:ShowDungeonError("RougeLike Error! 进入下一房间时,ListeningDealRewardEvent没有被清除！联系ljl检查！", Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Process)
		GWorld.RougeLikeManager.IsListeningDealRewardEvent = false
	end

	--     2025.2.7 掩体功能废弃
    -- self.CoverComponent:ClearCoverPointInfo()
    -- self.CoverComponent:InitCoverInfoAreas(self.EMGameState.CoverpointInfos)

    GWorld.RougeLikeManager:RemoveDataManagerInfos(self.RougeLikeLastRoomId, true)
    GWorld.RougeLikeManager:RegisterNextRoomData(self.RougeLikeCurRoomId)
    --DebugPrint("RougeLike 打印MonsterSpawnDivision", self.EMGameState.MonsterSpawnPointParams:Num(), self.EMGameState.MonsterSpawnPointParams:GetRef(1).Loc)
    self:ClearMonsterSpawnDivisions()
    self:InitMonsterSpawnDivisions(self.EMGameState.MonsterSpawnPointParams)

	-- 重置数量，放在每次进入下一个房间的时候做
    self:RefreshRougeBattleUI(false, true)

	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	Battle(self):TriggerBattleEvent(BattleEventName.RougeEnterNewRoom, Player)
end

--rouge专用的创建特殊怪方法
function RougeLikeComponent:CreateProbabilityMonster(MonsterType, MonsterID)
	if not MonsterID then
		return
	end
	local LevelLoader = self.LevelGameMode:GetLevelLoader()
	if LevelLoader == nil then
		return
	end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	local PlayerLocation = GameMode:GetAllPlayer()[1].CurrentLocation--肉鸽目前是单机副本，无联机
	local TargetLocation = UKismetMathLibrary.Vector_Zero()
	local LocationValid = false
	for i = 1, GameMode.EmergencyMonsterSpawnLoc.RandomTime do
		if UNavigationSystemV1.K2_GetRandomLocationInNavigableRadius(
			self, PlayerLocation, TargetLocation, self.EmergencyMonsterSpawnLoc.MaxDistance) == true
			and math.abs(PlayerLocation.Z - TargetLocation.Z) <= self.EmergencyMonsterSpawnLoc.MaxZDistance
			and LevelLoader:GetLevelIdByLocation(PlayerLocation) == LevelLoader:GetLevelIdByLocation(TargetLocation)
			and UNavigationFunctionLibrary.CheckTwoPosHasPath(PlayerLocation, TargetLocation, self) == EPathConnectType.HasPath
		then
			LocationValid = true
			break
		end
	end

	if LocationValid == false then
		TargetLocation = GameMode:GetMonsterCustomLoc(nil)
	end
	if UKismetMathLibrary.EqualEqual_VectorVector(TargetLocation, UKismetMathLibrary.Vector_Zero(), 0.001) == false then
		local Context = AEventMgr.CreateUnitContext()
		Context.UnitType = "Monster"
		Context.UnitId = MonsterID
		Context.Loc = TargetLocation
		Context.MonsterSpawn = GameMode.LevelGameMode.FixedMonsterSpawn
		Context.IntParams:Add("Level", GameMode:GetFixedGamemodeLevel())
		GameMode.EMGameState.EventMgr:CreateUnitNew(Context, false)
		self[MonsterType.."MonsterSpawnProbability"] = nil
	end
end

--创建前准备
function RougeLikeComponent:PreCreateProbabilityMonster(MonsterType, MonsterId)
	self:CreateProbabilityMonster(MonsterType, MonsterId)
	self[MonsterType.."MonsterTimer"] = nil
end

--检测是否满足条件创建，满足则创建
function RougeLikeComponent:CheckCreateProbabilityMonster(MonsterType)
	DebugPrint("[THY] RougeLike CheckCreateSpecialMonster", MonsterType)
	--房间低于最低刷新层不刷
	if GWorld.RougeLikeManager.RoomIndex < DataMgr.RougeLikeDifficulty[GWorld.RougeLikeManager.DifficultyId]["TMMinRoom"] then
		 return
	end
	--房间类型不匹配不刷
	local RoomInfo = DataMgr.RougeLikeRoom[self.RougeLikeCurRoomId]
	if RoomInfo and RoomInfo.RoomType ~= 1 and RoomInfo.RoomType ~= 6 then
		DebugPrint("[THY]  CheckCreateSpecialMonster: RoomInfo.RoomType ~= 1 and RoomInfo.RoomType ~= 6")
		return
	end

	if self[MonsterType.."MonsterTimer"] ~= nil then
		return
	end
	local DifficultyInfo = DataMgr.RougeLikeDifficulty[GWorld.RougeLikeManager.DifficultyId]
	if not DifficultyInfo then 
		return 
	end

	--刷新数量超过上限不刷
	if not self[MonsterType.."MonsterCreatedNum"] then
        self[MonsterType.."MonsterCreatedNum"] = 0
    end
	if  not (self[MonsterType.."MonsterCreatedNum"] < DifficultyInfo["TMMaxNum"]) then
		DebugPrint("[THY] ThisMonsterCreatedNum is upper limit", self[MonsterType.."MonsterCreatedNum"])
		self[MonsterType.."MonsterTimer"] = nil
		return
	end

	--没摇到刷新概率不刷
	if math.random() > self[MonsterType.."MonsterSpawnProbability"] then
		return
	end
		
	--设置概率怪的创建时间
	local MonsterBornTime = math.random(DifficultyInfo["TMBornTime"][1], DifficultyInfo["TMBornTime"][2])
	DebugPrint("[THY] After ", MonsterBornTime, "s, CreateTreasureMonster, and TreasureMonsterCreatedNum is", self[MonsterType.."MonsterCreatedNum"] + 1)
	self[MonsterType.."MonsterTimer"] = self:AddTimer(
		MonsterBornTime, function() self:PreCreateProbabilityMonster(MonsterType, DifficultyInfo["TMId"]) end, false)
end

--对应类型关卡更新概率怪出现概率
function RougeLikeComponent:SetProbabilityMonsterSpawnProbability(MonsterType, RoomInfo, DifficultyInfo)
	if not DifficultyInfo or not DifficultyInfo.TMProbability then
		return
	end
	if RoomInfo.RoomType ~= 1 and RoomInfo.RoomType ~= 6 then
		return
	end
	if self[MonsterType.."MonsterSpawnProbability"] then
		self[MonsterType.."MonsterSpawnProbability"] = self[MonsterType.."MonsterSpawnProbability"] + DifficultyInfo.TMProbability[2]
	else
		self[MonsterType.."MonsterSpawnProbability"] = DifficultyInfo.TMProbability[1]
	end
    DebugPrint("[THY] RougeLike",MonsterType, "MonsterSpawnProbability is ", self[MonsterType.."MonsterSpawnProbability"])
end

function RougeLikeComponent:TryCreateProbabilityMonsterInRougeLike()
	local RoomInfo = DataMgr.RougeLikeRoom[self.LevelGameMode.RougeLikeCurRoomId]
	local DifficultyInfo = DataMgr.RougeLikeDifficulty[GWorld.RougeLikeManager.DifficultyId]
	if RoomInfo and DifficultyInfo then
		--目前只有盗宝怪一种，后续有新增概率怪可以在配置表中配置怪物类型，然后从表中取值，替代下面的“Treasure”
		--更新特殊怪刷新概率
		self.LevelGameMode:SetProbabilityMonsterSpawnProbability("Treasure", RoomInfo, DifficultyInfo)
		--检查是否满足创建特殊怪要求，满足则创建
		self.LevelGameMode:CheckCreateProbabilityMonster("Treasure")
		return
	end
	DebugPrint("RoomInfo or DifficultyInfo can not be found")
end

-- 每个房间初始化完成后都会调用
function RougeLikeComponent:OnRougeLikeRoomInit()
    self.RougeLikeLastRoomId = self.RougeLikeCurRoomId
    self.RougeLikeCurRoomId = GWorld.RougeLikeManager.RoomId
    DebugPrint("RougeLike OnRougeLikeRoomInit", GWorld.RougeLikeManager.RoomIndex, "LastRoomId:", self.RougeLikeLastRoomId, "CurRoomId:", self.RougeLikeCurRoomId)
    self:SetRougeLikeGameModeLevel()
    self:StartRougeLikeTimer()

	self:ShowRougeLikeSubTask(false)
end

function RougeLikeComponent:SetRougeLikeGameModeLevel()
    local RougeLikeManager = GWorld.RougeLikeManager
    if not IsValid(RougeLikeManager) then
		self.EMGameState:ShowDungeonError("RougeLike Error! 找不到GWorld.RougeLikeManager", Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.FindObject)
        return
    end

    local DifficultyInfo = DataMgr.RougeLikeDifficulty[RougeLikeManager.DifficultyId]
    if not DifficultyInfo then
		self.EMGameState:ShowDungeonError("RougeLike Error! 没有对应RougeLikeDifficulty, DifficultyId: "..RougeLikeManager.DifficultyId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
        return
    end

    local RoomLevel = DifficultyInfo.RoomLevel
    if not RoomLevel then
		self.EMGameState:ShowDungeonError("RougeLike Error! 没有对应RoomLevel, DifficultyId: ", RougeLikeManager.DifficultyId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
        return
    end
    local GameModeLevel = RoomLevel[RougeLikeManager.RoomIndex] or 0
    self:SetGameModeLevel(GameModeLevel)
    DebugPrint("RougeLike SetRougeLikeGameModeLevel Succeed! DifficultyId: ", RougeLikeManager.DifficultyId ," RoomIndex: ", RougeLikeManager.RoomIndex, " GameModeLevel: ", GameModeLevel)
end

function RougeLikeComponent:StartRougeLikeTimer()
    self.RougeLikeTotalTime = 0
    local RougeLikeTimer = function()
        self.RougeLikeTotalTime = self.RougeLikeTotalTime + 0.1
    end
    self:AddTimer(0.1, RougeLikeTimer, true, 0, "RougeLikeTimer")
    DebugPrint("RougeLike TimerStart")
end

function RougeLikeComponent:StopAndGetRougeLikeTimer()
    self:RemoveTimer("RougeLikeTimer")
    DebugPrint("RougeLike TimerStop. TotalTime:", self.RougeLikeTotalTime)
    return self.RougeLikeTotalTime or 0
end

function RougeLikeComponent:SpawnRougeLikeRoomShops()
    if GWorld.RougeLikeManager == nil then
        return
    end
    GWorld.RougeLikeManager:SpawnRoomShops()
end

-- 用来处理肉鸽左侧ui的显隐状态
function RougeLikeComponent:RefreshRougeBattleUI(IsShow, IsResetCount)
    -- rouge只有单机
	local NewUIState
	-- 用DungeonUIState来控制显隐状态，然后调ui本身的Refresh方法，根据State更新显隐状态（好像onrep_uistate也可以实现 先这样吧）
	if IsShow then
		NewUIState = Const.EDungeonUIState.OnTarget
	else
		NewUIState = Const.EDungeonUIState.None
	end
	self.EMGameState:SetDungeonUIState(NewUIState)

    local UIManager = GWorld.GameInstance:GetGameUIManager()
    if not UIManager then return end
    local RougeBattleUI = UIManager:GetUIObj("Rouge_BattleProgress")
    if RougeBattleUI then
        RougeBattleUI:RefreshVisibility()
    end
	if IsResetCount then
		self.EMGameState:SetRougeBattleNums(0)
	end
end

function RougeLikeComponent:InitRougeLikeSubTask(DisplayText)
	self:ShowRougeLikeSubTask(true, DisplayText)
end

function RougeLikeComponent:ShowRougeLikeSubTask(IsShow, DisplayText)
	local TaskBar = TaskUtils:GetTaskBarWidget()
	if not TaskBar then
		DebugPrint("RougeLikeComponent:ShowRougeLikeSubTask, 找不到任务栏")
		return
	end

	if IsShow then
		self.LevelGameMode.RougeLikeSubTaskText = DisplayText
		TaskBar:AddOptionalTask(DisplayText)
	else
		self.LevelGameMode.RougeLikeSubTaskText = nil
		TaskBar:RemoveOptionalTask()
	end
end

function RougeLikeComponent:TriggerRougeLikePassEvent(MiniGameName, FinialScore, IsWin)
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		self.EMGameState:ShowDungeonError("EMGameMode::TriggerRougeLikePassEvent No  Avatar", Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.FindObject)
		return
	end

	-- 用是否存在MiniGameName来判断是否是小游戏模式
	if MiniGameName == "" then
		DebugPrint("RougeLikeComponent::TriggerRougeLikePassEvent NotGame")
		Avatar:PassEvent()
	else
		DebugPrint("RougeLikeComponent::TriggerRougeLikePassEvent MiniGameName", MiniGameName, "FinialScore", FinialScore, "IsWin", IsWin)
		local CustomData = {}
		CustomData.Score = FinialScore
		Avatar:PassEvent(IsWin, CustomData)
	end
end

function RougeLikeComponent:SpeciaMonsterOnDeadReal(MonsterType, UnitId)
	local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar:IsInRougeLike() then
		DebugPrint("[THY]  MonsterIsDead")

		if MonsterType ~= "Treasure" then
			-- 这个接口目前暂时只有盗宝皎皎再用，为了避免可能的报错，先return掉
			return
		end
		local DifficultyInfo = DataMgr.RougeLikeDifficulty[GWorld.RougeLikeManager.DifficultyId]
		if not DifficultyInfo then
			return
		end
		DebugPrint("RougeLikeComponent:SpeciaMonsterOnDeadReal UnitId", UnitId, "TMId", DifficultyInfo.TMId)
		if UnitId ~= DifficultyInfo.TMId then
			return
		end

		if self[MonsterType.."MonsterCreatedNum"] then
			self[MonsterType.."MonsterCreatedNum"] = self[MonsterType.."MonsterCreatedNum"] + 1
		else
			self[MonsterType.."MonsterCreatedNum"] = 1
		end
        Avatar:TriggerTMGetReward()

		-- 存储盗宝怪计数
		if MonsterType == "Treasure" then
			Avatar:SavePlayerSlice({
				Type = Const.RougeSliceInfoType.TreasureMonCount,
				Value = {TreasureMonCount = self.TreasureMonsterCreatedNum}})
			DebugPrint("RougeLike SaveTreasureMonCount =", self.TreasureMonsterCreatedNum)
		end
    end
end
function RougeLikeComponent:SpeciaMonsterOnDead(UnitId)
	--目前写死，以后有多种概率怪是可以通过配置表配置读表传MonsterType
	self:SpeciaMonsterOnDeadReal("Treasure", UnitId)
end

-- 判断整个肉鸽通关:已通关的房间等于肉鸽房间总数
-- todo: 等一个更官方的判断方法
function RougeLikeComponent:IsAllRoomPassed()
	local DifficultyInfo = DataMgr.RougeLikeDifficulty[GWorld.RougeLikeManager.DifficultyId]
	if not DifficultyInfo then return false end
	local RoomRandom = DifficultyInfo.RoomRandom
	if not RoomRandom then return false end
	local TotalRoomNum = #RoomRandom

	local PassRoomNum = GWorld.RougeLikeManager.PassRooms:Num()
	return TotalRoomNum == PassRoomNum
end

function RougeLikeComponent:TriggerAllContractDungeonEffect()
	GWorld.RougeLikeManager:TriggerAllContractDungeonEffect()
end

function RougeLikeComponent:GetContractMonsterNum()
	local RougeLikeManager = GWorld.RougeLikeManager
	local Contracts = RougeLikeManager.Contract
	local MonsterNum = 0
	if Contracts ~= nil then
		for k, v in pairs(Contracts) do 
			local RoomType = DataMgr.RougeLikeRoom[RougeLikeManager.RoomId].RoomType
			local ContractData = DataMgr.RougelikeContract[k]
			local UnitType = ContractData.UnitType
			if UnitType == "Monster" then
				local EffectRoomTypes = ContractData.RoomType
				for i = 1, #EffectRoomTypes do
					if RoomType == EffectRoomTypes[i] then
						MonsterNum = MonsterNum + ContractData.UnitNum[v]
						break
					end
				end
			end
		end
	end
	DebugPrint("HTY GetContractMonsterNum: ", MonsterNum)
	return MonsterNum
end

function RougeLikeComponent:StartRougeMiniGame(MiniGameName, MiniGameId)
	local FunName = "StartRouge"..MiniGameName.."MiniGame"
	if self[FunName] then
		DebugPrint("RougeLikeComponent:StartRougeMiniGame MiniGameName", MiniGameName, "MiniGameId", MiniGameId)
		self.EMGameState.RougeMiniGameProgressing = true
		self.RougeMiniGameName = MiniGameName
		self[FunName](self, MiniGameId)
	else
		self.EMGameState:ShowDungeonError("RougeLikeComponent:StartRougeMiniGame FunName", FunName, "未实现 或 不存在该玩法", Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Implement)
	end
end

function RougeLikeComponent:EndRougeMiniGame(IsWin)
	if self.RougeMiniGameName then
		local FunName = "EndRouge"..self.RougeMiniGameName.."MiniGame"
		if self[FunName] then
			DebugPrint("RougeLikeComponent:EndRougeMiniGame MiniGameName", self.RougeMiniGameName)
			self[FunName](self, IsWin)
			self.EMGameState.RougeMiniGameProgressing = false
			self.RougeMiniGameName = nil
		else
			self.EMGameState:ShowDungeonError("RougeLikeComponent:StartRougeMiniGame FunName", FunName, "未实现 或 不存在该玩法", Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Implement)
		end
	end
end

function RougeLikeComponent:RougeShowUITip(TextTip, IsWarning)
	if IsWarning then
		local LastTime = 2
		UIManager(self):ShowUITip(UIConst.Tip_CommonWarning, TextTip, LastTime)
	else
		UIManager(self):LoadUINew("ExploreToastSuccess",TextTip)
	end
end

--region 炮台小游戏相关
function RougeLikeComponent:OnCanonMonsterDead(Monster)
	if not IsValid(Monster) then
		self.EMGameState:ShowDungeonError("RougeLikeComponent:OnCanonMonsterDead Monster is nil", Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.FindObject)
		return
	end
	local DeathReason = Monster.MonsterDeathReason
	DebugPrint("RougeLikeComponent:OnCanonMonsterDead UnitId", Monster.UnitId, "DeathReason", EDeathReason:GetNameByValue(DeathReason))

	local AddScore = 0
	local CononInfo = DataMgr.CanonMiniGame[Monster.UnitId]
	if CononInfo then
		if DeathReason == EDeathReason.KillSelf then
			AddScore = CononInfo.SelfKillScore or 0
		else
			AddScore = CononInfo.KillScore or 0
		end
	end
	self:AddCanonScore(AddScore)
end

function RougeLikeComponent:AddCanonScore(Score)
	self.CanonScore = (self.CanonScore or 0) + Score
	EventManager:FireEvent(EventID.UpdateRankStarScore, self.CanonScore, Score)
	DebugPrint("RougeLikeComponent:AddCanonScore Score", Score, "CurrentScore:", self.CanonScore)
end

function RougeLikeComponent:GetCanonScore()
	return self.CanonScore or 0
end

function RougeLikeComponent:StartRougeCanonMiniGame(MiniGameId)
	self:OnWaveStart()

	local CurrentEventId = GWorld.RougeLikeManager.EventId
    local MiniGameScoreId = DataMgr.RougeLikeEventSelect[CurrentEventId].MiniGameScoreId
    local Info = DataMgr.RougeLikeMiniGameScore[MiniGameScoreId]
	local ScoreTable = {}
    for Index,Score in ipairs(Info.MiniGameScore) do
		ScoreTable[Index] = Score
    end
	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    GameMode:NotifyClientShowRankStarScoreUI(GText("RougeMiniGamePoints"),
		GText("RougeMiniGamePointsLv3")..ScoreTable[3], GText("RougeMiniGamePointsLv2")..ScoreTable[2], GText("RougeMiniGamePointsLv1")..ScoreTable[1],
		ScoreTable[3], ScoreTable[2], ScoreTable[1])

	EventManager:FireEvent(EventID.StartRougeCanonMiniGame)
end

function RougeLikeComponent:EndRougeCanonMiniGame(IsWin)
	self:EndInteractive()
	self:RemoveTimer("RougeCanonStartCountDown")
	self:RemoveTimer("RougeCanonShowToast")
	if CommonUtils.HasClientTimerStruct("RougeCanonTimer") then
		self:BpDelTimer("RougeCanonTimer")
	end
	self:RemoveRougeCanonTimer_Lua()
	local GuideCountDownFloat = UIManager(self):GetUIObj("GuideCountDown")
    if GuideCountDownFloat then
        GuideCountDownFloat:OnCountDownEnd()
    end
	local WaveStartBP = self:GetWaveStartBP()
	if WaveStartBP then
		if WaveStartBP:GetParent() then
			WaveStartBP:OnOutAnimationEnd()
		else
			WaveStartBP:Close()
		end
	end
	EventManager:FireEvent(EventID.EndRougeCanonMiniGame)

	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    GameMode:NotifyClientUnShowRankStarUI()
	local FinialScore = self:GetCanonScore()
	self:TriggerRougeLikePassEvent("Canon", FinialScore, IsWin)
	-- self:TriggerRougeLikeEnd(IsWin)		不要了 统一走PassEvent之后的EventPassRoom

	self:PostCustomEvent("CanonGameEnd")
end

function RougeLikeComponent:RealStartRougeCanon()
	self:PostCustomEvent("CanonGameMonsterStart")
	self:StartRougeCanonTimer()
end

function RougeLikeComponent:StartRougeCanonTimer()
	self:BpAddTimer("RougeCanonTimer", self.TotalTime, false)
	self:RougeCanonTimer_Lua()
end

function RougeLikeComponent:BpOnTimerEnd_RougeCanonTimer()
	self:EndRougeCanonMiniGame(true)
end

function RougeLikeComponent:RougeCanonTimer_Lua()
    local CommonClientTimerUI = UIManager(self):GetUIObj("DungeonCaptureFloat")
    if not CommonClientTimerUI then
        CommonClientTimerUI = UIManager(self):LoadUINew("DungeonCaptureFloat")
    end
    CommonClientTimerUI:InitClientTimerByHandleName("RougeCanonTimer", "UI_HUD_Countdown", -1)
end

function RougeLikeComponent:RemoveRougeCanonTimer_Lua()
    local CommonClientTimerUI = UIManager(self):GetUIObj("DungeonCaptureFloat")
    if not CommonClientTimerUI then
        return
    end
    CommonClientTimerUI:CloseClientTimerByHandleName()
end

function RougeLikeComponent:EndInteractive()
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	if Player then
		local Eid = Player.MechanismEid
		if Eid ~= 0 then
			local Mechanism = Battle(GWorld.GameInstance):GetEntity(Eid)
			if Mechanism and Mechanism.ChestInteractiveComponent then
				Mechanism.ChestInteractiveComponent:ForceEndInteractive(Player, false, Const.ForceEndInteractive)
			end
		end
	end
end

function RougeLikeComponent:GetWaveStartBP()
    local WaveStartBP = UIManager(self):GetUIObj("WaveStartBP")
    if not WaveStartBP then
        WaveStartBP = UIManager(self):LoadUINew("WaveStartBP")
    end
	WaveStartBP:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
	return WaveStartBP
end

function RougeLikeComponent:OnWaveStart()
	local ToastShowTime = 1
    local WaveStartBP = self:GetWaveStartBP()
	if WaveStartBP then
		WaveStartBP:SetVisibility(ESlateVisibility.Collapsed)
		WaveStartBP.Text_WaveStart:SetText(GText("RougePaotaiMiniGameStart"))
		WaveStartBP:UnbindAllFromAnimationFinished(WaveStartBP.Out)
        WaveStartBP:BindToAnimationFinished(WaveStartBP.Out, {WaveStartBP, WaveStartBP.Close})
		self:AddTimer(self.Countdown, function()
			WaveStartBP:SetVisibility(ESlateVisibility.HitTestInvisible)
			WaveStartBP:PlayInAnimation()
			self:RealStartRougeCanon()
		end,false,0,"RougeCanonStartCountDown")
		self:AddTimer(self.Countdown + ToastShowTime, function()
			WaveStartBP:PlayOutAnimation()
		end,false,0,"RougeCanonShowToast")
	end
	self:ShowCountDown()
end

function RougeLikeComponent:ShowCountDown()
    local GuideCountDownFloat = UIManager(self):GetUIObj("GuideCountDown")
    if not GuideCountDownFloat then
        GuideCountDownFloat = UIManager(self):LoadUINew("GuideCountDown")
    end
	GuideCountDownFloat:InitializeData(self.Countdown)
end

--endregion

--region 摩尔斯码小游戏相关
function RougeLikeComponent:StartRougeMorseMiniGame(MiniGameId)
	local MorseMiniGameInfo = DataMgr.MorseMiniGame[MiniGameId]
	assert(MorseMiniGameInfo, "MorseMiniGame读表不存在，MiniGameId:"..MiniGameId)

	self.CurMorseMiniGameId = MiniGameId
	UIManager(self):LoadUINew("Morse", MorseMiniGameInfo.Difficulty, MorseMiniGameInfo.TotalTime, self, self.EndRougeMiniGame)
end

function RougeLikeComponent:EndRougeMorseMiniGame(IsWin)
	assert(self.CurMorseMiniGameId, "CurMorseMiniGameId不存在！")
	local MorseMiniGameInfo = DataMgr.MorseMiniGame[self.CurMorseMiniGameId]
	local FinialScore = 0
	if IsWin then
		FinialScore = MorseMiniGameInfo.SuccScore
	else
		FinialScore = MorseMiniGameInfo.FailScore
	end

	self:TriggerRougeLikePassEvent("Morse", FinialScore, IsWin)

	--self:PostCustomEvent("MorseGameEnd")		不要了 统一走PassEvent之后的EventPassRoom
end

--endregion

function RougeLikeComponent:FillRougeLikeErrorLog(MsgTable)
	table.insert(MsgTable, "副本状态GameModeState: "..EGameModeState:GetNameByValue(self.GameState.GameModeState).."\n")
	table.insert(MsgTable, "当前副本是否结算: "..tostring(self:IsDungeonInSettlement()).."\n")
	table.insert(MsgTable, "战斗关进度："..tostring(self.EMGameState.RougeBattleCount).."/"..tostring(self.EMGameState.RougeBattleMaxNum).."\n")
	table.insert(MsgTable, "盗宝怪刷新数: "..tostring(self.TreasureMonsterCreatedNum).."\n")
	table.insert(MsgTable, "盗宝怪刷新概率: "..tostring(self.TreasureMonsterSpawnProbability).."\n")

	local PlayerController = UE.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
	if PlayerController then
		local PlayerState = PlayerController.PlayerState
		if PlayerState then
			table.insert(MsgTable, "玩家死亡(复活)次数 / 最大死亡(复活)次数："..tostring(PlayerState.RecoveryCount).."/"..tostring(PlayerState.RecoveryMaxCount).."\n")
		end
	end

	local MiniGameName = ""
	for LevelName, SubGameMode in pairs(self.SubGameModeInfo) do
		MiniGameName = SubGameMode.RougeMiniGameName
	end
	table.insert(MsgTable, "当前MiniGame名称: "..tostring(MiniGameName).."\n")
end

------------------------------------------------------

return RougeLikeComponent