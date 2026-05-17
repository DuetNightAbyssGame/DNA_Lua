-- ---解注释，可以开启LuaPanda调试器，仅在纯客户端的非正式环境下生效
-- if not UE.UNeModeFunctionLibrary.IsDedicatedServer(UE.UEngine:GetDefaultObject()) and not UE.URuntimeCommonFunctionLibrary.IsDistribution() then
-- 	require("LuaPanda").start()
-- end
require "UnLua"
require "DataMgr"
local EMCache = require "EMCache.EMCache"
local EMLuaConst = require "EMLuaConst"
local TimeUtils = require "Utils.TimeUtils"
local ReddotManager = require "BluePrints.UI.Reddot.ReddotManager"
local CdnTool = require "BluePrints.UI.GameLogin.CdnTool"
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local MiscUtils = require "Utils.MiscUtils"
local SettingUtils = require "Utils.SettingUtils"
local GuildWarUtils = require "BluePrints.UI.WBP.Activity.Widget.GuildWar.GuildWarUtils"

local Language2ESystemLanguage = {
	TextMapContent = ESystemLanguage.TextMapContent,
	ContentEN = ESystemLanguage.ContentEN,
	ContentJP = ESystemLanguage.ContentJP,
	ContentKR = ESystemLanguage.ContentKR,
	ContentTC = ESystemLanguage.ContentTC,
	ContentDE = ESystemLanguage.ContentDE,
	ContentFR = ESystemLanguage.ContentFR,
	ContentES = ESystemLanguage.ContentES,
}

---@type BP_EMGameInstance_C|TimerMgr
local BP_EMGameInstance_C = Class({"BluePrints.Common.TimerMgr", "BluePrints.Common.DelayFrameComponent"})

	
function BP_EMGameInstance_C:OnLoginSuccess()
	local StorySubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UStorySubsystem:StaticClass())
	StorySubsystem:TryInitVars()
	if Const.OpenVerifyArray then
		self:InitVerifyArray()
	end
end

function BP_EMGameInstance_C:GetInt(TableName, VarName)
	local TableObj = require(string.format("%s", TableName))
	local VarValue = TableObj[VarName]
	if VarValue == nil then
		return 0
	end
	return VarValue
end

function BP_EMGameInstance_C:IsBanSmallLevelScalability(Value)
	if CommonUtils.HasValue(Const.BanSmallLevelScalabilityLevel, Value) then
		return true
	end
	return false
end

function BP_EMGameInstance_C:GetSerializeDistanceRatio(ScalabilityLevel, PlatformName)
	local Ratio = 1.0
	if PlatformName == "IOS" or self:GetUseMapPhoneInPC() then
		Ratio = Const.IOSSerializeDistanceRatio[ScalabilityLevel] or Ratio
	end
	return Ratio
end

--字体相关的性能优化指令设置
function BP_EMGameInstance_C:_FontOptimizeSetting()
	UKismetSystemLibrary.ExecuteConsoleCommand(self, "Slate.MaxFontAtlasPagesBeforeFlush 2")
	UKismetSystemLibrary.ExecuteConsoleCommand(self, "Slate.MaxFontNonAtlasTexturesBeforeFlush 4")
	local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
    --开启字体LRUCache之后，由于字体不会全部清掉，可以考虑打开异步
	if PlatformName == "Android" then
		UKismetSystemLibrary.ExecuteConsoleCommand(self, "Slate.Font.AsyncLazyLoad 1") 
		UKismetSystemLibrary.ExecuteConsoleCommand(self, "Slate.Font.RemoveLastNoUseFontFace 1")  --开启字体Lru缓存
		UKismetSystemLibrary.ExecuteConsoleCommand(self, "Slate.Font.ForcePreserveFontFaceCount 6")
		UKismetSystemLibrary.ExecuteConsoleCommand(self, "Slate.GrowFontAtlasFrameWindow 10")
	elseif PlatformName == "IOS" then
		UKismetSystemLibrary.ExecuteConsoleCommand(self, "Slate.Font.AsyncLazyLoad 1")
		UKismetSystemLibrary.ExecuteConsoleCommand(self, "Slate.Font.RemoveLastNoUseFontFace 1")  --开启字体Lru缓存
		UKismetSystemLibrary.ExecuteConsoleCommand(self, "Slate.Font.ForcePreserveFontFaceCount 4")
		UKismetSystemLibrary.ExecuteConsoleCommand(self, "Slate.GrowFontAtlasFrameWindow 5")
	end
end

function BP_EMGameInstance_C:InitReady()
	GWorld.IsDev = self:GetIsDev()
	if IsDedicatedServer(self) then
		GWorld.bDebugServer = self.bDebugServer
		print(_G.LogTag, "DebugServer", GWorld.bDebugServer)
		--self:GetDSAssetsManager():PreLoadAssets()
	else
		self:_FontOptimizeSetting()
	end

	if URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
		DebugPrint("Check Open FX Budget in Editor ", Const.bEditorOpenFXBudget)
		if Const.bEditorOpenFXBudget then
			UKismetSystemLibrary.ExecuteConsoleCommand(self, "fx.Niagara.ForceAutoPooling 1", nil)
		else
			UKismetSystemLibrary.ExecuteConsoleCommand(self, "fx.Niagara.ForceAutoPooling 0", nil)
		end
	end
	

	self:CreateAvatar()
	GWorld.GameInstance = self
	if not URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
		---@type BP_Battle_C
		_G.Battle = function(Context) return GWorld.Battle end
	end
	--DebugPrint("IsDedicatedServer", self:IsDedicatedServer(), Hostnum, DungeonId)
	-- LuaMemoryManager:EnableLuaMemoryMonitor()
	
	-- 打完Patch ReloadAllBank Reset Volume
	self:InitGameSystemVoice()

	-- GWorld全局变量绑定
	GWorld.NetworkMgr = self:GetNetworkManager()
	GWorld.NetworkMgr:GetTcpInstance():InitSuccessLua()
	GWorld.BP_Avatar = self:GetAvatar()
end

function BP_EMGameInstance_C:OnPostWorldCleanup(World, bSessionEnded, bCleanupResources)
	if World:GetName() == self:GetWorld():GetName() then
		if not GWorld:GetAvatar() then
			EventManager:CheckIsLeak()
		end
	end
end

function BP_EMGameInstance_C:NowTime()
    return TimeUtils.NowTime()
end

function BP_EMGameInstance_C:SetWorldStandardTime_Lua()
    if IsStandAlone(self) or IsClient(self) then
    	TimeUtils.RequestSetNowTime()
    end
end

function BP_EMGameInstance_C:OnStart_Lua(GroupId)
	GWorld.IsDev = self:GetIsDev()
	if IsDedicatedServer(self) and not GWorld.bDebugServer then
		self:HandleDSConnect(GroupId)
	end
end

function BP_EMGameInstance_C:OnUpdateNetDriverInfo(ip, port)
	DebugPrint(ip, port)
	if IsDedicatedServer(self) and not GWorld.bDebugServer then
		local DSEntity = GWorld:GetDSEntity()
		if DSEntity then
			DSEntity:UpdateNetDriverInfo(ip, port)
		end
	elseif MiscUtils.IsListenServer(self) then
		local Avatar = GWorld:GetAvatar()
		if Avatar then
			Avatar:UpdateNetDriverInfo(ip, port)
		end
	end
end

function BP_EMGameInstance_C:SetInstance2GWorld()
	GWorld.GameInstance = self
	GWorld.IsDev = self:GetIsDev()
	GWorld:IsDedicatedServer()
	_G.EMUIAnimationSubsystem = USubsystemBlueprintLibrary.GetWorldSubsystem(self, UEMUIAnimationSubsystem)
end

function BP_EMGameInstance_C:HandleDSConnect(GroupId)
	if GroupId == -1 then
		GroupId = Const.DS_Default_GroupId
	end

	self.DSConnectHostnum = GroupId
	local Host = GroupId
	local BattleServerList = require "BluePrints/UI/GameLogin/BattleServerList"
	local ServerInfo = BattleServerList[Host]
	if not ServerInfo then
		DebugNetPrint("HandleDSConnect error with no BattleServerInfo", GroupId)
		return
	end

	local TargetIp, TargetPort
	local Ip = ServerInfo.ip
	if type(Ip) == "string" then
		TargetIp = Ip
	else
		TargetIp = Ip[math.random(1, #Ip)]
	end

	local Port = ServerInfo.port
	if type(Port) == "number" then
		TargetPort = Port
	else
		TargetPort = Port[math.random(1, #Port)]
	end

	DebugNetPrint("HandleDSConnect", Host, TargetIp, TargetPort)
	GWorld.NetworkMgr:ConnectServer(Host, TargetIp, TargetPort)
end

function BP_EMGameInstance_C:IsNullDungeonId(DungeonId)
	return DungeonId == -1
end

function BP_EMGameInstance_C:GetDataInt(TableName, TableId, PropertyName)
	-- body
	local Data = DataMgr[TableName]
	if Data ~= nil then
		local Row = Data[TableId]
		if Row ~= nil then
			local Value = Row[PropertyName]
			if Value ~= nil then
				return Value
			end
		end
	end

	return 0
end


-- 处理服务器因网络原因将客户端踢出的情况
function BP_EMGameInstance_C:HandleNetworkError(FailureType, bIsServer)
	print(_G.LogTag, "HandleNetworkError", FailureType, bIsServer)
	if not bIsServer and not self.bHandleNetError then
		self.bHandleNetError = true
		GWorld.NetworkMgr:DisconnectAndReturnLogin()
	elseif bIsServer then
		ServerPrint("HandleNetworkError", FailureType, bIsServer)
		--self:CloseDS("HandleNetworkError")
	end
end

function BP_EMGameInstance_C:GetDsType()
	if self.DSType == CommonConst.DSType.Leaf then
		return "Leaf"
	elseif self.DSType == CommonConst.DSType.Child then
		return "Child"
	elseif self.DSType == CommonConst.DSType.Root then
		return "Root"
	end
	return "None"
end

function BP_EMGameInstance_C:OnSubProcessInit(RandomSeed)
	math.randomseed(RandomSeed) -- 重新设置随机数种子
	if self.DSType == CommonConst.DSType.Leaf then
		self:AddTimer(2, function ()
			self:GetDSAssetsManager():TryCheckPreLoadAssets()
		end )
	end
end

-- 设置固定出生坐标，不使用startpoint出生点
---@param Rotation FRotator
function BP_EMGameInstance_C:SetFixedStartPoint(Location, Rotation, ControllerRotation, bDead)
	print(_G.LogTag, "SetFixedStartPoint", Location, Rotation)
	self.UseFixedStartPoint = true
	self.StartLocation = Location
	self.StartRotation = Rotation
	self.StartControllerRotation = ControllerRotation
	self.bCharacterDead = bDead
end

-- 重置固定出生点设定
function BP_EMGameInstance_C:ResetFixedStartPoint()
	print(_G.LogTag, "ResetFixedStartPoint")
	self.UseFixedStartPoint = false
	self.bCharacterDead = nil
end

function BP_EMGameInstance_C:IsUseFixedStartPoint()
	return self.UseFixedStartPoint or false
end

function BP_EMGameInstance_C:SetStartSpotWithFixedTransform(StartSpot)
	if not self.UseFixedStartPoint then
		return false
	end

	StartSpot:K2_SetActorTransform(UE4.FTransform(self.StartRotation:ToQuat(), self.StartLocation), false, nil, false)
	StartSpot:K2_SetActorLocation(self.StartLocation, false, nil, false)
	StartSpot:K2_SetActorRotation(self.StartRotation, false, nil, false)
	return true
end

function BP_EMGameInstance_C:CachePlayerCharacterInfo(...)
	self.PlayerCharacterInfo = table.pack(...)
end

function BP_EMGameInstance_C:ConsumePlayerCharacterInfo(PlayerCharacter)
	if not self.PlayerCharacterInfo then
		return
	end

	local EndPointSeqEnable, EndPointLocation, EndPointRotation = table.unpack(self.PlayerCharacterInfo)
	PlayerCharacter:SetEndPointInfo(EndPointSeqEnable, EndPointLocation, EndPointRotation)
	self.PlayerCharacterInfo = nil
end

function BP_EMGameInstance_C:PreInitGameMode(CustomPreInitInfo)
	self.CustomPreInitInfo = CustomPreInitInfo
end

function BP_EMGameInstance_C:ConsumeGameModePreInitInfo()
	local Info = self.CustomPreInitInfo
	self.CustomPreInitInfo = nil
	return Info
end

function BP_EMGameInstance_C:OnPlayerControllerGameEnd(IsWin, BattleInfo, ScenePlayers)
	self.DungeonIdCache = self:GetCurrentDungeonId()
	local GameState = UE4.UGameplayStatics.GetGameState(self)

	local SceneManager = self:GetSceneManager()

	if SceneManager ~= nil then
		-- 通知SceneManager副本结束，以便做一些其他工作
		SceneManager:OnDungeonEnd_ToSceneManager(IsWin, BattleInfo, GameState.GameModeType, GameState.DungeonId)
	end

	self.IsDSOnDungeonFinish = nil

	if GameState.GameModeType == "Training" or GameState.GameModeType == "Trial" then
		DebugPrint("DungeonSettlement: 训练场或角色试玩玩法，直接退出副本")
		local Avatar = GWorld:GetAvatar()
		Avatar:ExitDungeonSettlement()
		return
	end

	GameState:TriggerClientEvent("OnDungeonSettlement")
        
	--进入结算页面的标识
	self.IsInSettlementScene = true
	local WalnutChoiceUI = UIManager(self):GetUIObj("WalnutChoice")
    if WalnutChoiceUI then
        WalnutChoiceUI:Close()
    end
	self:OnPlayerControllerGameEnd_Internal(IsWin,BattleInfo, ScenePlayers)
    GameState:CheckPreloadRecordData_Lua()
end

-- 梦魇残声结算时会初始化魅影，需要等魅影和玩家全部初始化完才能播动画
function BP_EMGameInstance_C:CalculatePhantom()
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
	local PhantomTeammates = Player:GetPhantomTeammates()
	local Num = 0
	for _, Target in pairs(PhantomTeammates) do
		if Target ~= Player and not Target:IsDead() then
			Num = Num + 1
		end
	end
	self.PhantomTeammatesNum = Num
	self.InitPhantomTeammates = 0
	DebugPrint("CalculatePhantom PhantomTeammatesNum", self.PhantomTeammatesNum)
end

function BP_EMGameInstance_C:AddOnPhantomInitReadyEvent()
	if self.PhantomTeammatesNum > 0 then
		EventManager:AddEvent(EventID.OnPhantomInitReady, self, self.OnSettlementPhantomInitReady)
	end
end

function BP_EMGameInstance_C:OnPlayerControllerGameEnd_Internal(IsWin, BattleInfo, ScenePlayers)
	self:PushGameEndInfo(IsWin, BattleInfo)

	local Avatar = GWorld:GetAvatar()
	local IsHardBoss = Avatar and Avatar:IsInHardBoss()
	local WorldCompositionSubSystem = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(self, UE4.UWorldCompositionSubSystem)
	local AvatarStatusEnable = Avatar and not WorldCompositionSubSystem and not Avatar:IsInRougeLike() -- 肉鸽暂时不切换场景, WC场景不切换场景（梦魇+区域副本）
	if AvatarStatusEnable and not Avatar:IsInNarrowDungeon()  then
		GWorld.DungeonSettlementAgainInVisible = true
	end

	self.IsMoveToTempScene = false
	-- 当黑幕完成需要做的事。
	local OnBlackInFinished = nil
	local DungeonId= self:GetCurrentDungeonId()
	self.ScenePlayers = ScenePlayers
	OnBlackInFinished = function()
		local Avatar = GWorld:GetAvatar()
		if AvatarStatusEnable and Avatar:CheckMoveToTempScene(DungeonId, IsWin) then
			EventManager:AddEvent(EventID.OnMainCharacterBeginPlay, self, self.OnSettlementPlayerCharacterBeginPlay)
			--EventManager:AddEvent(EventID.OnMainCharacterInitReady, self, self.OnSettlementPlayerCharacterInitReady)
			EventManager:AddEvent(EventID.OnNotifyClientToCloseLoading, self, self.OnSettlementPlayerCharacterInitReady)		-- 修改了触发时机，应该监听切换完world之后，服务器NotifyClientToCloseLoading的时机
			self.IsMoveToTempScene = true
			self.NeedPlayTempSceneMonstage = true
		else
			self:CalculatePhantom()
			self:OnBlackScreenSyncFinished(IsHardBoss)
		end
	end

	-- 暂存战斗数据
	self:RecordCombatData()

	-- 开始结算。
	local BlackUI = self:CreateDungeonBlackScreen(true, OnBlackInFinished, IsWin)

	-- 开启仅 UI 输入模式。
	local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
	local PlayerCharacter = PlayerController:GetMyPawn()
	PlayerCharacter:ResetIdle()
end

function BP_EMGameInstance_C:RecordCombatData()  -- 由于弹结算界面之前会切一次场景、清空Player，在切场景之前暂存一下结算界面需要的战斗数据
	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	self.CombatData = {}
	self.CombatData.AutoChessBattleInfo = GameMode and GameMode:TriggerDungeonComponentFun("GetAutoChessBattleInfo")
	local EMGameState = UE4.UGameplayStatics.GetGameState(self)
	if EMGameState then
		self.CombatData.MVPFactor = EMGameState.MVPFactor
	end
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
	if Player then
		self.CombatData.TakeDamagePercentage = Player.PlayerState.TakeDamagePercentage
		self.CombatData.TakedDamage = Player:GetTakedDamage()
		self.CombatData.TakedShieldDamage = Player:GetShieldTakedDamage()
		self.CombatData.TakedHeal = Player:GetTakedHeal()

		self.CombatData.DeadCount = Player:GetRecoveryCount()
		if Player:IsDead() then
			self.CombatData.DeadCount = self.CombatData.DeadCount + 1
		end

		self.CombatData.DamagePercentage = Player.PlayerState.DamagePercentage or 0
    	self.CombatData.TotalDamage = Player:GetFinalDamage() or 0
    	self.CombatData.MeleeDamage = Player:GetMeleeDamage() or 0
    	self.CombatData.RangedDamage = Player:GetRangedDamage() or 0
    	self.CombatData.SkillDamage = (Player:GetSkillDamage() or 0) + (Player:GetSummonDamage() or 0)
		self.CombatData.SupportDamage = Player:GetSupportDamage() or 0
		self.CombatData.GiveHealing = Player:GetGiveHealing() or 0

		self.CombatData.TotalKill = Player:GetTotalKillCount() or 0
    	self.CombatData.MeleeKill = Player:GetMeleeKillCount() or 0
    	self.CombatData.RangedKill = Player:GetRangedKillCount() or 0
    	self.CombatData.SkillKill = (Player:GetSkillKillCount() or 0) + (Player:GetSummonKillCount() or 0)
		self.CombatData.SupportKill = Player:GetSupportKillCount() or 0

		self.CombatData.SpConsume = Player:GetSpConsume() or 0
		self.CombatData.BulletConsume = Player:GetBulletConsume() or 0
		self.CombatData.ChestOpenedCount = Player:GetChestOpenedCount() or 0
		self.CombatData.BreakableItemCount = Player:GetBreakableItemCount() or 0
		self.CombatData.MaxComboCount = Player:GetMaxComboCount() or 0
		self.CombatData.MaxDamage = Player:GetMaxDamage() or 0

		self.CombatData.OldBattleInfo = {
			Char_OldBattleInfo = Player.PlayerState:GetOldBattleInfo("Char"),
			MeleeWeapon_OldBattleInfo = Player.PlayerState:GetOldBattleInfo("MeleeWeapon"),
			RangedWeapon_OldBattleInfo = Player.PlayerState:GetOldBattleInfo("RangedWeapon"),
			Player_OldBattleInfo = Player.PlayerState:GetOldBattleInfo("Player")
		}
		self.CombatData.CurBattleInfo = {}
		self.CombatData.CurBattleInfo.Char_CurBattleInfo = {
			Exp = Player:GetAttr("Exp"),
			Level = Player:GetAttr("Level"),
		}
		if Player.MeleeWeapon then
			self.CombatData.CurBattleInfo.MeleeWeapon_CurBattleInfo = {
				Exp = Player.MeleeWeapon:GetAttr("Exp"),
				Level = Player.MeleeWeapon:GetAttr("Level"),
			}
		end
		if Player.RangedWeapon then
			self.CombatData.CurBattleInfo.RangedWeapon_CurBattleInfo = {
				Exp = Player.RangedWeapon:GetAttr("Exp"),
				Level = Player.RangedWeapon:GetAttr("Level"),
			}
		end

		local Weapon = Player:GetCurrentWeapon()
		if Weapon then
			self.CombatData.CurrentWeaponType = Weapon:GetWeaponType()
			self.CombatData.CurrentWeaponMeleeOrRanged = Weapon:GetWeaponMeleeOrRanged()
		end

		local GameMode = UE4.UGameplayStatics.GetGameMode(self)
		local GameState = UE4.UGameplayStatics.GetGameState(self)
		if GameMode and GameState and GameState.GameModeType == "Temple" then
			self.CombatData.StarLevel = GameMode:TriggerDungeonComponentFun("GetStarLevel")
			self.CombatData.FailReason = GameMode:TriggerDungeonComponentFun("GetPlayerFailReason")
			self.CombatData.Score = GameMode:TriggerDungeonComponentFun("GetScore")
			self.CombatData.Collection = GameMode:TriggerDungeonComponentFun("GetCollection")
			self.CombatData.RemainTempleTime = GameMode:TriggerDungeonComponentFun("GetRemainTempleTime")
			self.CombatData.TempleTime = GameState.TempleTime
			self.CombatData.MaxTempleStar = GameState.MaxTempleStar
		end
		if GameState and GameState.GameModeType == "Party" then
			self.CombatData.StarLevel = GameState.CurPartyStar
			self.CombatData.NumOfPlayers = GameState.PartyPlayerDisPercent.Items:Num()
			self.CombatData.PartyPlayerCompleteTime = {}
			for i = 1, GameState.PartyPlayerCompleteTime:Num() do
				self.CombatData.PartyPlayerCompleteTime[i] = GameState.PartyPlayerCompleteTime:GetRef(i)
			end
		end
		if GameMode and GameState and GameState.GameModeType == "FeinaEvent" then
			self.CombatData.CurScore = GameMode:TriggerDungeonComponentFun("GetStar")
			local Avatar = GWorld:GetAvatar()
			local DungeonId = self:GetCurrentDungeonId()
			if Avatar and Avatar.FeiNaDungeonData and Avatar.FeiNaDungeonData[DungeonId] and Avatar.FeiNaDungeonData[DungeonId].MaxProgress then
				self.CombatData.MaxScore = Avatar.FeiNaDungeonData[DungeonId].MaxProgress
			end
			if Avatar and Avatar.Dungeons[DungeonId] and not Avatar.Dungeons[DungeonId].IsPass then
				self.CombatData.NotPass = true
			end
		end
		if GameMode and GameState and GameState.GameModeType == "Paotai" then
			self.CombatData.CurScore = GameMode:TriggerDungeonComponentFun("GetScore")
			self.CombatData.CurStar = GameMode:TriggerDungeonComponentFun("GetStar")
			local EventId = DataMgr.PaotaiEventConstant.PaotaiGameEventId.ConstantValue
			local Avatar = GWorld:GetAvatar()
			local DungeonId = self:GetCurrentDungeonId()
			if Avatar and Avatar.PaotaiGame and Avatar.PaotaiGame[EventId] and Avatar.PaotaiGame[EventId][DungeonId] and Avatar.PaotaiGame[EventId][DungeonId].MaxScore then
				self.CombatData.MaxScore = Avatar.PaotaiGame[EventId][DungeonId].MaxScore
			end
		end
		if GameState and GameState.GameModeType == "SoloRaid" then
			self.CombatData.MaxScore = GameState.SoloRaidHistoryMaxScore or 0
		end
		if GameState and GameState.GameModeType == "MonsterRush" then
			self.CombatData.FinishTime = GameMode:TriggerDungeonComponentFun("GetFinishTime") or 0
		end
		--联机玩家战斗数据统计
		local Avatar = GWorld:GetAvatar()
		self.CombatData.IsInOnlineDungeon = Avatar:IsInMultiDungeon()
		self.CombatData.TeammateDamageInfos = Player:GetTeammateDamageInfos():ToTable()
		for _, value in ipairs(self.CombatData.TeammateDamageInfos) do
			--队友的数据目前只有伤害 击杀数 和 它的魅影伤害
			if value.TeammateEid then
				if TeamController:GetModel() and TeamController:GetModel():GetTeamMember(value.TeammateEid) then
					value.Index = TeamController:GetModel():GetTeamMember(value.TeammateEid).Index
				end
			end
		end
		
		self.CombatData.TeammateNum = Player:GetTeammateDamageInfos() and Player:GetTeammateDamageInfos():Num() or 0
		--魅影战斗数据统计
		self.CombatData.PhantomAttrInfos = Player:GetPhantomAttrInfos():ToTable()
		self.CombatData.PhantomNum = Player:GetPhantomAttrInfos() and Player:GetPhantomAttrInfos():Num() or 0

		self.GameEndTime = TimeUtils.NowTime()

		self:FillTempTeamInfo(GameState, Player)

		--撤离时间
		local ServerEntity = GWorld:GetServerEntity()
		if not ServerEntity then
		    DebugPrint("ServerEntity get nil")
		    return
		end
		local DungeonObject = ServerEntity:GetDungeonObject()
		if not DungeonObject then
		    DebugPrint("DungeonObject get nil")
		    return
		end
		self.CombatData.EvacuationTime = DungeonObject.EvacuationTime or 0
	end
	PrintTable(self.CombatData, 5)
end

function BP_EMGameInstance_C:CalculateMVP()
	local ScenePlayers = self.ScenePlayers

	-- 玩家本人的phantom，去除人质
    local PhantomsData = self.CombatData.PhantomAttrInfos
    local TeammateData = self.CombatData.TeammateDamageInfos or {}
    local CurTeammateNum = 0
    
	--检测下有几个真人玩家
    local RealPlayerNum = 0
    for _, Player in ipairs(ScenePlayers) do
        if Player.IsMainPlayer or (not Player.IsPhantom) then
            RealPlayerNum = RealPlayerNum + 1
        end
    end

	local IsInOnlineDungeon = false
    if RealPlayerNum > 1 then
        IsInOnlineDungeon = true
    else
        IsInOnlineDungeon = false
    end

	self.MVPInfo = {}
	local ScenePlayers = self.ScenePlayers
	local MVPFactor = 0
	if self.CombatData and self.CombatData.MVPFactor then
		MVPFactor = self.CombatData.MVPFactor
	end
	DebugPrint("CalculateMVP MVPFactor:", MVPFactor)
	local TeamTotalDamage = 0
	local DamageTable = {}
    
    if not IsInOnlineDungeon then 
        --单机
        for _, Player in ipairs(ScenePlayers) do
			local Damage = 0
            if Player.IsMainPlayer then
				Damage = self.CombatData.TotalDamage
            elseif PhantomsData and #PhantomsData > 0 then
                local PhantomData = nil
				for _, value in pairs(PhantomsData) do
					local PlayerRoleId = nil
					if Player.RoleId then
						PlayerRoleId = Player.RoleId
					elseif Player.RoleInfo and Player.RoleInfo.RoleId then
						PlayerRoleId = Player.RoleInfo.RoleId
					end
					if PlayerRoleId == value.PhantomRoleId then
						PhantomData = value
					end
				end
				if PhantomData then
					Damage = PhantomData.FinalDamage
				end
            end
			TeamTotalDamage = TeamTotalDamage + Damage
			table.insert(DamageTable, Damage)
        end
    else
        --联机
        for _, Player in ipairs(ScenePlayers) do
			local Damage = 0
            if Player.IsMainPlayer then
				Damage = self.CombatData.TotalDamage
            else
                if not Player.IsPhantom then
                    CurTeammateNum = CurTeammateNum + 1
                    local Teammate = TeammateData[CurTeammateNum]
                    if Teammate then
						Damage = Teammate.FinalDamage
                    end
                else
					-- 目前队友要有魅影只能是2人联机
					local PhantomData = nil
					-- 找自己身上的魅影数据
					DebugPrint("CalculateMVP Player.IsMainPlayerPhantom", Player.IsMainPlayerPhantom)
					if Player.IsMainPlayerPhantom then
						for _, value in pairs(PhantomsData) do
							local PlayerRoleId = nil
							if Player.RoleId then
								PlayerRoleId = Player.RoleId
							elseif Player.RoleInfo and Player.RoleInfo.RoleId then
								PlayerRoleId = Player.RoleInfo.RoleId
							end
							if PlayerRoleId == value.PhantomRoleId then
								PhantomData = value
							end
						end
						if PhantomData then
							Damage = PhantomData.FinalDamage
						else
							DebugPrint("Error CalculateMVP PhantomData is nil", Player.RoleId)
						end
                    else
                        -- 队友魅影
                        local TeammatePhantomData = TeammateData[1] and TeammateData[1].PhantomAttrInfo
                        if TeammatePhantomData then
							Damage = TeammatePhantomData.FinalDamage
                        else
                            DebugPrint("Error CalculateMVP TeammatePhantomData is nil", Player.RoleId)
                        end
                    end
                end
            end
			TeamTotalDamage = TeamTotalDamage + Damage
			table.insert(DamageTable, Damage)
        end
    end

	for i, Damage in ipairs(DamageTable) do
		local DamageRatio = 0
		if TeamTotalDamage > 0 then
			DamageRatio = Damage / TeamTotalDamage
		end
		local Player = ScenePlayers[i]
		local CurScore = 0
		local PlayerRoleId = nil
		if Player.RoleId then
			PlayerRoleId = Player.RoleId
		elseif Player.RoleInfo and Player.RoleInfo.RoleId then
			PlayerRoleId = Player.RoleInfo.RoleId
		end
		local BattleCharInfo = DataMgr.BattleChar[PlayerRoleId]
		if BattleCharInfo then
			local BaseMVPScore = BattleCharInfo.BaseMVPScore or 0
			CurScore = DamageRatio * (BaseMVPScore + MVPFactor)
		end
		local IsCurrentMVP = false
		if self.MVPInfo.MVPScore == nil or CurScore > self.MVPInfo.MVPScore then
			IsCurrentMVP = true
		elseif CurScore == self.MVPInfo.MVPScore then
			-- 玩家和玩家比/魅影和魅影比，RoleId小的为MVP
			if (Player.IsPhantom and self.MVPInfo.IsPhantom) or (not Player.IsPhantom and not self.MVPInfo.IsPhantom) then
				if PlayerRoleId < self.MVPInfo.RoleId then
					IsCurrentMVP = true
				end
			else
				-- 玩家比魅影，玩家为MVP
				if not Player.IsPhantom then
					IsCurrentMVP = true
				end
			end
		end
		DebugPrint("CalculateMVP PlayerIndex: ", i, "PlayerName: ", Player.ScenePlayerName, "PlayerDamage: ", Damage, "PlayerScore: ", CurScore)
		if IsCurrentMVP then
			self.MVPInfo.MVPScore = CurScore
			self.MVPInfo.MVPDamage = Damage
			self.MVPInfo.MVPIndex = i
			self.MVPInfo.MVPName = Player.ScenePlayerName
			self.MVPInfo.IsPhantom = Player.IsPhantom
			self.MVPInfo.RoleId = PlayerRoleId
			local MVPFolder = nil
			local MVPMontage = nil
			if Player.MVPId then
				local Data = DataMgr.CharAccessory[Player.MVPId]
				MVPFolder = Data and Data.MVPKey
				MVPMontage = Data and Data.Montage
			end
			self.MVPInfo.MVPFolder = MVPFolder
			self.MVPInfo.MVPMontage = MVPMontage
		end
	end

	DebugPrint("CalculateMVP MVPScore: ", self.MVPInfo.MVPScore, "MVPIndex", self.MVPInfo.MVPIndex, "MVPName", self.MVPInfo.MVPName)
end

function BP_EMGameInstance_C:FillTempTeamInfo(GameState, Player)
	self.CombatData.TempTeamInfo = {}
	if not GameState or not Player then
		return
	end

	for _, PlayerState in pairs(GameState.PlayerArray) do
		if PlayerState then
			local Info = {}
			Info.IsMainPlayer = PlayerState.Eid == Player.Eid
			Info.Eid = PlayerState.Eid
			Info.Uid = PlayerState.Uid
			Info.PlayerLevel = PlayerState.PlayerLevel
			Info.PlayerName = PlayerState.PlayerName
			Info.HeadIconId = PlayerState.HeadIconId
			-- Info.HeadFrameId = PlayerState.HeadFrameId 这个在PlayerState上拿不到，先不传看看效果
			self.CombatData.TempTeamInfo[PlayerState.Uid] = Info
			DebugPrint("ljl@FillTempTeamInfo Uid", Info.Uid)
		end
	end
end

function BP_EMGameInstance_C:PushGameEndInfo(...)
	self.GameEndInfo = table.pack(...)
end

function BP_EMGameInstance_C:EnablePlayerCharacterInput()
	local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
	local PlayerCharacter = PlayerController:GetMyPawn()
	PlayerCharacter:EnableInput(PlayerController)
end

function BP_EMGameInstance_C:CreateDungeonBlackScreen(ShowFade, Callback, IsWin)
	local UIManager = GWorld.GameInstance:GetGameUIManager()
	DebugPrint("DungeonSettlement: CreateDungeonBlackScreen")
	return UIManager:LoadUINew("DungeonBlackScreen", ShowFade, Callback, IsWin)
end

function BP_EMGameInstance_C:OnBlackScreenSyncFinished(IsHardBoss)
	DebugPrint("OnBlackScreenSyncFinished")
	self:OnSettlementPlayerCharacterBeginPlay()
	if not IsHardBoss or self.PhantomTeammatesNum == 0 then
		self:OnCharaterReset()
		self:OnSettlementPlayerCharacterInitReady()
	end
end

-- 切换场景 UI 会被卸载掉，因此在该函数还原 UI 状态，如果切换场景失败，重复加载 UI 也是无效的。
function BP_EMGameInstance_C:OnSettlementPlayerCharacterBeginPlay()
	EventManager:RemoveEvent(EventID.OnMainCharacterBeginPlay, self)
	DebugPrint("DungeonSettlement: OnSettlementPlayerCharacterBeginPlay")
	local BlackUI = self:CreateDungeonBlackScreen(false)
	self.GameEndInfo = nil

	-- local EnvirCreatClass = LoadClass('/Game/Asset/Scene/common/EnvirSystem/EnvirCreat.EnvirCreat_C')
	-- local EnvirCreat = UGameplayStatics.GetActorOfClass(self, EnvirCreatClass)
	-- if not EnvirCreat  and EnvirCreatClass then
	-- 	self:GetWorld():SpawnActor(EnvirCreatClass, FTransform())
	-- 	DebugPrint('Settlement Spawn EnvirCreat')
	-- end
end

function BP_EMGameInstance_C:OnSettlementPhantomInitReady()
	DebugPrint("OnSettlementPhantomInitReady")
	self.InitPhantomTeammates = self.InitPhantomTeammates + 1
	if self.InitPhantomTeammates >= self.PhantomTeammatesNum then
		EventManager:RemoveEvent(EventID.OnPhantomInitReady, self)
		self:OnCharaterReset()
		self:OnSettlementPlayerCharacterInitReady()
	end
end

function BP_EMGameInstance_C:OnCharaterReset()
	local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
	PlayerCharacter:InitCharacterInfo(PlayerCharacter.InfoForInit)
	PlayerCharacter:ResetIdle()
	USkillFeatureFunctionLibrary.SKillFeatureForceStop()
end

function BP_EMGameInstance_C:OnSettlementPlayerCharacterInitReady()
	--EventManager:RemoveEvent(EventID.OnMainCharacterInitReady, self)
	EventManager:RemoveEvent(EventID.OnNotifyClientToCloseLoading, self)
	self.bPlayerCharacterInitReady = true
	self:TryDungeonSettlement()
end

function BP_EMGameInstance_C:PushLogicServerCallbackInfo(...)
	-- 副本强退后 再上线会触发副本结算 逻辑服会结算并发一次奖
	-- 但是这次发奖不应该缓存下来，否则可能导致下次结算时按这次发奖缓存的信息结算
	if WorldTravelSubsystem() and WorldTravelSubsystem():GetCurrentSceneId() == 0 then
		DebugPrint("TryDungeonSettlement SceneId为0，丢弃此次逻辑服结算数据！")
		return
	end

	--进入结算页面的标识 -- 单机中途关闭游戏 再上线会触发这个 先注释掉
	-- self.IsInSettlementScene = true
	self.LogicServerCallbackInfo = table.pack(...)
	self:TryDungeonSettlement()
end

-- 使用ExitLevel结算
function BP_EMGameInstance_C:SetExitLevelEndPointInfo(Transformation)
	print(_G.LogTag, "SetExitLevelEndPointInfo", Transformation.Translation, Transformation.Rotation)
	self.UseExitLevel = true
	self.ExitLevelEndPointTransformation = Transformation
end

function BP_EMGameInstance_C:TryDungeonSettlement()
	DebugPrint("DungeonSettlement: TryDungeonSettlement", self.bPlayerCharacterInitReady, self.LogicServerCallbackInfo)
	if self.bPlayerCharacterInitReady and self.LogicServerCallbackInfo then

		self.SettlemetnLevelLoader = self:GetSceneManager():GetLevelLoader()
		if not self.SettlemetnLevelLoader then
			local EMLevelLoaderClass = LoadClass('/Game/BluePrints/Common/Level/BP_SettlementLevelLoader.BP_SettlementLevelLoader')
			if EMLevelLoaderClass then
				self.SettlemetnLevelLoader = self:GetWorld():SpawnActor(EMLevelLoaderClass, FTransform())
			end
		end
		
		if CommonUtils.GetRuntimePlatform(self) ~= "Mobile" then
			local PostProcessVolumeActor=UGameplayStatics.GetActorOfClass(self,APostProcessVolume:StaticClass())
			local RVTVolumeActor=UGameplayStatics.GetActorOfClass(self,ARuntimeVirtualTextureVolume:StaticClass())
			if PostProcessVolumeActor and not RVTVolumeActor then--CBT2先写死吧，最好是让场编把rvt加回去
				local PPVTrans=PostProcessVolumeActor:GetTransform()
				local RVTTrans=UKismetMathLibrary.MakeTransform(PPVTrans.Translation-PPVTrans.Scale3D*200,FRotator(),PPVTrans.Scale3D*(200/0.5)*2)
				local RVTVolume1 = self:GetWorld():SpawnActor(ARuntimeVirtualTextureVolume:StaticClass(), RVTTrans, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
				local RVTVolume2 = self:GetWorld():SpawnActor(ARuntimeVirtualTextureVolume:StaticClass(), RVTTrans, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
				RVTVolume1.VirtualTextureComponent.VirtualTexture=LoadObject('/Game/Asset/Scene/common/3Texture/RVT/RVT_DefaultColor.RVT_DefaultColor')
				RVTVolume1.VirtualTextureComponent.StreamingTexture=LoadObject('/Game/Asset/Scene/common/3Texture/RVT/RVT_Color_SVT.RVT_Color_SVT')
				RVTVolume2.VirtualTextureComponent.VirtualTexture=LoadObject('/Game/Asset/Scene/common/3Texture/RVT/RVT_DefaultHeight.RVT_DefaultHeight')
				RVTVolume2.VirtualTextureComponent.StreamingTexture=LoadObject('/Game/Asset/Scene/common/3Texture/RVT/RVT_Height_SVT.RVT_Height_SVT')
				URuntimeCommonFunctionLibrary.MarkRVTVolumeDirty(RVTVolume1)
				URuntimeCommonFunctionLibrary.MarkRVTVolumeDirty(RVTVolume2)
			elseif not PostProcessVolumeActor then
				DebugPrint('DungeonSettlement:No PostProcessVolume So No RuntimeVirtualVolume')
			end
		end
		local CurrentDungeonId = self:GetCurrentDungeonId()
		if CurrentDungeonId ~= 0 then
			EventManager:FireEvent(EventID.SystemGuideExitDungeon, self:GetCurrentDungeonId())
		end
		PrintTable(self.LogicServerCallbackInfo, 5)
		self.bPlayerCharacterInitReady = nil
		local Avatar = GWorld:GetAvatar()
		if not Avatar then
			DebugPrint("Error: DungeonSettlement: 找不到Avatar!")
		end
		local CurDungeonType = WorldTravelSubsystem():GetCurrentDungeonType()
		local LogicServerInfo = CommonUtils.DeepCopy(self.LogicServerCallbackInfo)
		self.LogicServerCallbackInfo = nil

		local IsWin = table.unpack(LogicServerInfo)	-- 只取第一个就行
		local DungeonId = self:GetCurrentDungeonId()
		local DungeonData = DataMgr.Dungeon[DungeonId]
		local ForcePlayWinMontage = IsWin
		if DungeonData and DungeonData.ForcePlayWinMontage then
			ForcePlayWinMontage = true
		end
		local DoMvp = IsWin and not (Avatar and Avatar:IsInRougeLike()) 
			and not (CurDungeonType and (CurDungeonType == CommonConst.DungeonType.Abyss or CurDungeonType == CommonConst.DungeonType.Party))
			and not (DataMgr.Dungeon[CurrentDungeonId] and DataMgr.Dungeon[CurrentDungeonId].IsGameEventDungeon) and not (CurDungeonType == "SoloTreasure")
		self:CalculateMVP()
		if DoMvp then
			if self.MVPInfo.MVPFolder == nil then
				DoMvp = false
			end
		end
		local UIManager = GWorld.GameInstance:GetGameUIManager()
		local OnMVPFinished = function()
			-- 不走MVP的时候直接在黑屏之前播结算动作
			local Params = {}
			Params.BlackScreenHandle = "BlackScreenMVP"
			if DoMvp then
				UIManager:ShowCommonBlackScreen(Params)
				if self.SettlemetnLevelLoader then
					self.SettlemetnLevelLoader:UnloadPreviewLevel(self.PreviewLevelName)
				end
				if self.MVPInfo.MVPCharacter then
					self.MVPInfo.MVPCharacter:StopMVPSequence()
					self.MVPInfo.MVPCharacter:K2_SetActorLocation(self.MVPInfo.MVPCharacterOriginLoc, false, nil, true)
					self.MVPInfo.MVPCharacter:K2_SetActorRotation(self.MVPInfo.MVPCharacterOriginRot, false, nil, true)
				end
				-- self:PlayerDungeonSettlement(ForcePlayWinMontage)
				self:AddTimer(0.5, function()
					UIManager:HideCommonBlackScreen("BlackScreenMVP")
					self:PlayerDungeonSettlement(ForcePlayWinMontage)
					if Avatar and Avatar:IsInRougeLike() then
						UIManager:LoadUINew("RougeSettlement", LogicServerInfo)
					elseif CurDungeonType and CurDungeonType == CommonConst.DungeonType.Abyss then
						UIManager:LoadUINew("AbyssSettlement", LogicServerInfo)
					elseif DataMgr.Dungeon[CurrentDungeonId] and DataMgr.Dungeon[CurrentDungeonId].IsGameEventDungeon then
						self:LoadGameEventSettlementUI(CurrentDungeonId, CurDungeonType, LogicServerInfo)
					elseif CurrentDungeonId == 80401 then
						self:LoadGameEventSettlementUI(CurrentDungeonId, CurDungeonType, LogicServerInfo)
					else
						UIManager:LoadUINew("DungeonSettlement", LogicServerInfo, self.DungeonIdCache, self.CombatData)
					end
				end)
			else
				if Avatar and Avatar:IsInRougeLike() then
					UIManager:LoadUINew("RougeSettlement", LogicServerInfo)
				elseif CurDungeonType and CurDungeonType == CommonConst.DungeonType.Abyss then
					UIManager:LoadUINew("AbyssSettlement", LogicServerInfo)
				elseif DataMgr.Dungeon[CurrentDungeonId] and DataMgr.Dungeon[CurrentDungeonId].IsGameEventDungeon then
					self:LoadGameEventSettlementUI(CurrentDungeonId, CurDungeonType, LogicServerInfo)
				elseif CurrentDungeonId == 80401 then
					self:LoadGameEventSettlementUI(CurrentDungeonId, CurDungeonType, LogicServerInfo)
				elseif CurDungeonType == "SoloTreasure" then
					local IsSoloWin = false
					if LogicServerInfo then
						IsSoloWin = LogicServerInfo[1]
					end
					if IsSoloWin and LogicServerInfo[7] and LogicServerInfo[7].ItemList and LogicServerInfo[7].ItemList[1] then
						UIManager:LoadUINew("SoloTreasureItemSettlement", LogicServerInfo)
					else
						UIManager:LoadUINew("SoloTreasureEvacuation", LogicServerInfo)
					end
				else
					UIManager:LoadUINew("DungeonSettlement", LogicServerInfo, self.DungeonIdCache, self.CombatData)
				end
			end
		end
		local OnBlackOutFinished = function()
			--重置进入结算页面的标识
			--先写这儿吧，以后可以挪到DungeonMgr退出副本的逻辑里
			self.IsInSettlementScene = nil
			local GameState = UE4.UGameplayStatics.GetGameState(self)
			if GameState then
				-- GameInstance上的标记销毁后，在GameState上重新标记（前者能保证切场景前后，后者会随着退出临时场景而销毁）
				GameState.IsInSettlementScene = true
			end

			-- 不走MVP直接进结算界面
			if not DoMvp then
				OnMVPFinished()
			else
				UIManager:LoadUINew("SettlementMVP", OnMVPFinished, self.MVPInfo.MVPDamage, self.MVPInfo.MVPName, self:GetPlayerMVPDataByIndex(self.MVPInfo.MVPIndex))
			end
		end
		local bSkipOutAnim = false
		if DataMgr.Dungeon[CurrentDungeonId] and DataMgr.Dungeon[CurrentDungeonId].IsGameEventDungeon then
			bSkipOutAnim = true
		end
		local BlackUI = UIManager:GetUI("DungeonBlackScreen")
		if not DoMvp then
			-- 播放MVP先加载MVP临时场景，加载完再黑幕淡出
			BlackUI:FadeOut(OnBlackOutFinished, bSkipOutAnim)
		end

		-- 肉鸽暂时不播结算蒙太奇
		if Avatar and Avatar:IsInRougeLike() then
			return
		end
		local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
		local PlayerCharacter = PlayerController:GetMyPawn()
		if self.UseExitLevel then
			local CurrentLevelEndPointTransform = self.ExitLevelEndPointTransformation
			local CurrentLevelEndPointLocation = CurrentLevelEndPointTransform.Translation
			local CurrentLevelEndPointRotation = CurrentLevelEndPointTransform.Rotation:ToRotator()
			PlayerCharacter:SetEndPointInfo(true, CurrentLevelEndPointLocation, CurrentLevelEndPointRotation)
			self.UseExitLevel = false
		end
		PlayerCharacter:SetCanInteractiveTrigger(false)
		if IsWin then
			local GameState = UE4.UGameplayStatics.GetGameState(self)
			if GameState then
				GameState:OnWCDungeonSettlement()
			end
		end
		self:PrePlayerDungeonSettlement(ForcePlayWinMontage)
		-- 不走MVP直接播结算界面动作
		if not DoMvp then
			self:PlayerDungeonSettlement(ForcePlayWinMontage)
		else
			------- 加载MVP场景 -------
			local PreviewSceneType = CommonConst.EPreviewSceneType.PreviewMVP
			local Path = CommonConst.PreviewScenePaths[PreviewSceneType]
			self.PreviewLevelName = "PreviewLevel" .. PreviewSceneType
			local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
			self.SettlemetnLevelLoader:LoadPreviewLevel(self.PreviewLevelName, Path, 
			function()
				-- self:SetPreviewLevelSkyBoxColor(self.SettlemetnLevelLoader, PreviewLevelName)
				BlackUI:FadeOut(OnBlackOutFinished, bSkipOutAnim)
				if self.MVPInfo.MVPCharacter then
					self.MVPInfo.MVPCharacterOriginLoc = self.MVPInfo.MVPCharacter:K2_GetActorLocation()
					self.MVPInfo.MVPCharacterOriginRot = self.MVPInfo.MVPCharacter:K2_GetActorRotation()
					self.MVPInfo.MVPCharacter:K2_SetActorLocation(FVector(200000,200000,200000), false, nil, true)
					self.MVPInfo.MVPCharacter:K2_SetActorRotation(FRotator(0, 0, 0), false, nil, true)
					self.MVPInfo.MVPCharacter:PlayDungeonSettlementMVPMontage(self.MVPInfo.MVPMontage)
					self.MVPInfo.MVPCharacter:PlayDungeonSettlementMVPSequence(self.MVPInfo.MVPFolder)
				end
			end, FVector(200000,200000,200000), FRotator(0,0,0))
		end
	end
end

function BP_EMGameInstance_C:IsInTempScene()
	-- 新增了一个标识，SinglePlayerController的NotifyClientGameEnd，也就是收到场景服rpc的那一刻；到结算真正开始期间（也就是IsInSettlementScene置为true前）
	-- 因为之前做过一些客户端loading时收到服务器rpc相关的处理，现在OnPlayerControllerGameEnd调用时机会延后到关loading后
	-- 可能遇到以下情况：1.Loading时收到场景服结算的rpc，2.NotifyClientToCloseLoading触发客户端事件，3.该函数被调用
	-- 导致：某些已结算期间不希望执行的客户端事件被指执行；因此新增该标识用以区分
	if self.IsDSOnDungeonFinish then
		return true
	end
	-- 客户端开始结算 到 TryDungeonSettlement 期间（即切场景完毕+收到逻辑服rpc）的标识
	if self.IsInSettlementScene then
		return true
	end
	-- TryDungeonSettlement 后的标识，会随着切world而销毁
	local GameState = UE4.UGameplayStatics.GetGameState(self)
	if GameState and GameState.IsInSettlementScene then
		return true
	end
	return false
end

function BP_EMGameInstance_C:PrePlayerDungeonSettlement(PlayWinMontage)
	self.DungeonSettlementCharacter = {}
	self.DungeonSettlementData = nil
	local EMGameState = UE4.UGameplayStatics.GetGameState(self)
	if EMGameState then
		EMGameState.SettlementCharacters:Clear()
	end
	-- local WorldCompositionSubSystem = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(self, UE4.UWorldCompositionSubSystem)
	local IsInDungeon = EMGameState and EMGameState:IsInDungeon()
	if self.ScenePlayers ~= nil then
		local Avatar = GWorld:GetAvatar()
		if Avatar then
			if Avatar:IsInHardBoss() and not IsInDungeon then
				local HardBossId = Avatar.HardBossInfo.HardBossId
				DebugPrint("BP_EMGameInstance_C:PrePlayerDungeonSettlement HardBossId:", HardBossId)
				self.DungeonSettlementData = DataMgr.HardBossMain[HardBossId]
				if self.DungeonSettlementData == nil then
					EMGameState:ShowDungeonError("PrePlayerDungeonSettlement 梦魇SettlementData为空，请检查配表数据 HardBossId: "..HardBossId, 
						Const.DungeonErrorType.Settlement, Const.DungeonErrorTitle.Config)
				end
			else
				local DungeonId = self:GetCurrentDungeonId()
				DebugPrint("BP_EMGameInstance_C:PrePlayerDungeonSettlement DungeonId:", DungeonId)
				self.DungeonSettlementData = DataMgr.Dungeon[DungeonId]
				if self.DungeonSettlementData == nil then
					EMGameState:ShowDungeonError("PrePlayerDungeonSettlement 副本SettlementData为空，请检查配表数据 DungeonId: "..DungeonId, 
						Const.DungeonErrorType.Settlement, Const.DungeonErrorTitle.Config)
				end
			end
		end
		if self.DungeonSettlementData == nil then
			DebugPrint("error: BP_EMGameInstance_C:PrePlayerDungeonSettlement SettlementData is nil!")
		end
		
		local OriginLoc, OriginRot = self:CalculateSettlementOriginLoc(self.IsMoveToTempScene)
		local OriginTransform = FTransform(OriginRot:ToQuat(), OriginLoc)
		for i = 1, #self.ScenePlayers do
			if self.ScenePlayers[i].IsMainPlayer then
				-- DebugPrint("BP_EMGameInstance_C:PrePlayerDungeonSettlement MainPlayer Index:", i, "RoleId:", self.ScenePlayers[i].RoleId)
				local MainPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
				MainPlayer:InitCharacterInfo(self.ScenePlayers[i])
				-- DebugPrint("Player ScenePlayer table")
				-- DebugPrintTable(self.ScenePlayers[i], 5)
				MainPlayer:ResetOnSetEndPoint()
				MainPlayer:SetMainPlayerDungeonSettlementTransform(self.IsMoveToTempScene, OriginLoc, OriginRot)
				MainPlayer:OnPreDungeonSettlement()
				self.DungeonSettlementCharacter[i] = MainPlayer
				if i ~= self.MVPInfo.MVPIndex then
					MainPlayer:SetActorHideTag("SettlementMVP", true, false, true)
				else
					self.MVPInfo.MVPCharacter = MainPlayer
				end
				-- 如果有魅影和队友则隐藏，用于区域梦魇和区域副本
				local Teammates = MainPlayer:GetAllTeammates()
				for _, Target in pairs(Teammates) do
					if Target ~= MainPlayer then
						Target:SetActorHideTag("DungeonSettlement", true, false, true)
					end
				end
				if self.ScenePlayers[i].IsDead and TeamController then
					TeamController:SendTeamLeave()
					TeamController:GetModel():SetTeam(nil)
				end
			else
				if PlayWinMontage then
					-- DebugPrint("BP_EMGameInstance_C:PrePlayerDungeonSettlement Teammate Index:", i, "RoleId:", self.ScenePlayers[i].RoleId)
					if self.DungeonSettlementData and self.DungeonSettlementData.NotShowTeammate then
						goto continue
					end
					local CurrentCharacter = self:GetWorld():SpawnActor(LoadClass('/Game/BluePrints/Char/BP_PlayerCharacter.BP_PlayerCharacter_C'), OriginTransform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
					CurrentCharacter:InitCharacterInfo(self.ScenePlayers[i])
					-- DebugPrint("Player Teammate table", i)
					-- DebugPrintTable(self.ScenePlayers[i], 5)
					CurrentCharacter:ResetOnSetEndPoint()
					CurrentCharacter:SetOtherPlayerDungeonSettlementTransform()
					-- if self.DungeonSettlementData then
					-- 	CurrentCharacter:OnDungeonSettlementByIndex(i, self.ScenePlayers[i].CurrentWeaponType, self.ScenePlayers[i].CurrentWeaponMeleeOrRanged, self.DungeonSettlementData)
					-- end
					CurrentCharacter:SetActorHideTag("InGame", false);
					self.DungeonSettlementCharacter[i] = CurrentCharacter
					if i ~= self.MVPInfo.MVPIndex then
						CurrentCharacter:SetActorHideTag("SettlementMVP", true, false, true)
					else
						self.MVPInfo.MVPCharacter = CurrentCharacter
					end
					if EMGameState then
						EMGameState.SettlementCharacters:Add(CurrentCharacter)
					end
				end
				::continue::
			end
		end
	else
		if EMGameState then
			local Avatar = GWorld:GetAvatar()
			if Avatar then
				if Avatar:IsInHardBoss() and not IsInDungeon then
					local HardBossId = Avatar.HardBossInfo.HardBossId
					EMGameState:ShowDungeonError("PrePlayerDungeonSettlement ScenePlayers为空，无法正常做结算表现 HardBossId: "..HardBossId, 
						Const.DungeonErrorType.Settlement, Const.DungeonErrorTitle.DataNil)
				else
					local DungeonId = self:GetCurrentDungeonId()
					EMGameState:ShowDungeonError("PrePlayerDungeonSettlement ScenePlayers为空，无法正常做结算表现 DungeonId: "..DungeonId, 
						Const.DungeonErrorType.Settlement, Const.DungeonErrorTitle.DataNil)
				end
			end
		end
	end
end

function BP_EMGameInstance_C:PlayerDungeonSettlement(PlayWinMontage)
	if self.ScenePlayers ~= nil then
		for i = 1, #self.ScenePlayers do
			if self.ScenePlayers[i].IsMainPlayer then
				local Character = self.DungeonSettlementCharacter[i]
				if self.DungeonSettlementData and Character then
					Character:ResetIdle()
					Character:OnDungeonSettlement(PlayWinMontage, i, self.DungeonSettlementData)
					Character:SetActorHideTag("SettlementMVP", false, false, true)
				end
			else
				if PlayWinMontage then
					local Character = self.DungeonSettlementCharacter[i]
					if self.DungeonSettlementData and Character then
						Character:ResetIdle()
						Character:OnDungeonSettlementByIndex(i, self.ScenePlayers[i].CurrentWeaponType, self.ScenePlayers[i].CurrentWeaponMeleeOrRanged, self.DungeonSettlementData)
						Character:SetActorHideTag("SettlementMVP", false, false, true)
					end
				end
			end
		end
	end
end

function BP_EMGameInstance_C:CalculateSettlementOriginLoc(IsMoveToTempScene)
	local MainPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
	if IsMoveToTempScene then
        -- 切换场景按表里配的位置来
        local EndPointSeqEnable, EndPointLocation, EndPointRotation = MainPlayer:GetEndPointInfo()
        if EndPointSeqEnable then
            return EndPointLocation, EndPointRotation
        end
    else
        local EMGameState = UE4.UGameplayStatics.GetGameState(self)
		-- local IsInDungeon = EMGameState and EMGameState:IsInDungeon()
        local Avatar = GWorld:GetAvatar()
		local WorldCompositionSubSystem = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(self, UE4.UWorldCompositionSubSystem)
		local WCIsInDungeon = WorldCompositionSubSystem and WorldCompositionSubSystem:WCIsInDungeon()
        --如果是非WC联机梦魇残声，单机WC读表，拼接关联机走初始位置
        if Avatar and Avatar:IsInHardBoss() and not WCIsInDungeon then
			-- WC单机
			if Avatar.HardBossInfo then
				local HardBossId = Avatar.HardBossInfo.HardBossId
				if DataMgr.HardBossMain[HardBossId] then
					local PosDisplayName = DataMgr.HardBossMain[HardBossId].PosDisplayName
					local PlayerPoint = EMGameState:GetTargetPoint(PosDisplayName)
					local PlayerPointLoc = PlayerPoint:K2_GetActorLocation()
					local PlayerPointRot = PlayerPoint:K2_GetActorRotation()
					return PlayerPointLoc, PlayerPointRot
				end
			else
				local EndPointSeqEnable, EndPointLocation, EndPointRotation = MainPlayer:GetEndPointInfo()
				if EndPointSeqEnable then
					return EndPointLocation, EndPointRotation
				end
			end
		-- 不切换场景，如果是WC联机，找策划关卡中配置点位最近的
        else
			if WCIsInDungeon then
				local GameState = UE4.UGameplayStatics.GetGameState(self)
				if GameState then
					local SettlementPoint = GameState:GetNearestSettlementPoint(MainPlayer:K2_GetActorLocation())
					if SettlementPoint then
						local SettlementPointLoc = SettlementPoint:K2_GetActorLocation()
						local SettlementPointRot = SettlementPoint:K2_GetActorRotation()
						DebugPrint("CalculateSettlementOriginLoc Find Nearest Settlement Point:", SettlementPointLoc, SettlementPointRot)
						return SettlementPointLoc, SettlementPointRot
					end
				end
			end
		end
    end
	return FVector(0, 0, 0), FRotator(0, 0, 0)
end

function BP_EMGameInstance_C:ProcessSettlementCharacter()
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
	Player:SetActorEnableCollision(true)
	local EMGameState = UE4.UGameplayStatics.GetGameState(self)
	if EMGameState then
		for i = 1, EMGameState.SettlementCharacters:Length() do
			local CurrentCharacter = EMGameState.SettlementCharacters:GetRef(i)
			if IsValid(CurrentCharacter) then
				CurrentCharacter:K2_DestroyActor()
			end
		end
		EMGameState.SettlementCharacters:Clear()
	end
	local PhantomTeammates = Player:GetPhantomTeammates()
	for _, Target in pairs(PhantomTeammates) do
		if Target ~= Player then
			Target:SetActorHideTag("DungeonSettlement", false, false, true)
			-- local Components = TArray(USceneComponent)
			-- URuntimeCommonFunctionLibrary.SetSceneComponentHiddenInGame(Target:K2_GetRootComponent(), false, true, "DungeonSettlement", Components)
		end
	end
end

function BP_EMGameInstance_C:LoadGameEventSettlementUI(CurrentDungeonId, CurDungeonType, LogicServerInfo)
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		DebugPrint("Error: DungeonSettlement: 找不到Avatar!")
		return
	end
	local IsWin, BattleInfo, Rewards, DungeonRewards, PlayerTime, GameTime, ClientRes = table.unpack(LogicServerInfo)
	local UIManager = GWorld.GameInstance:GetGameUIManager()
	if CurDungeonType and CurDungeonType == "FeinaEvent" then
		local DungeonInfo = DataMgr.FeinaEventDungeon[CurrentDungeonId]
		local CurScore = 0
		local MaxScore = 0
		if self.CombatData and self.CombatData.CurScore then
			CurScore = self.CombatData.CurScore
		end
		if self.CombatData and self.CombatData.MaxScore then
			MaxScore = self.CombatData.MaxScore
		end

		-- local FirstStarScere = DungeonInfo.Level[1]
		-- if CurScore < FirstStarScere then
		-- 	IsWin = false
		-- end

		local Params =
		{
			LevelScore = CurScore,
			IsWin = IsWin,
			Text_Title = "FeinaEvent_DungeonFinish_Title",
			Text_GetReward = "UI_Dungeon_First_Reward",
			ActivityId = DungeonInfo.SettlementId,
			IsNewRecord = CurScore > MaxScore,
			DungeonId = CurrentDungeonId,
		}

		Params.ScoreInfo = {
			{text = string.format(GText("FeinaEvent_DungeonTask_1"), DungeonInfo.Level[1]), isFinish = CurScore >= DungeonInfo.Level[1]},
			{text = string.format(GText("FeinaEvent_DungeonTask_1"), DungeonInfo.Level[2]), isFinish = CurScore >= DungeonInfo.Level[2]},
			{text = string.format(GText("FeinaEvent_DungeonTask_1"), DungeonInfo.Level[3]), isFinish = CurScore >= DungeonInfo.Level[3]},
		}

		if DungeonRewards and next(DungeonRewards) ~= nil then
			Params.RewardsInfo = DungeonRewards
		end

		Params.ContinueCallback = function()
			Avatar:EnterDungeon(CurrentDungeonId)
		end
		ActivityUtils.OpenActivitySettlement(DungeonInfo.SettlementId, CurrentDungeonId, Params)
	elseif CurDungeonType and CurDungeonType == "Paotai" then
		local CurScore = 0
		local MaxScore = 0
		local CurStar = 0
		if self.CombatData and self.CombatData.CurScore then
			CurScore = self.CombatData.CurScore
		end
		if self.CombatData and self.CombatData.MaxScore then
			MaxScore = self.CombatData.MaxScore
		end
		if self.CombatData and self.CombatData.CurStar then
			CurStar = self.CombatData.CurStar
		end
		local CurEventId = DataMgr.PaotaiEventConstant["PaotaiGameEventId"].ConstantValue
		local Params =
		{
			LevelScore = CurScore,
			IsWin = IsWin,
			Text_Title = "FeinaEvent_DungeonFinish_Title",
			Text_GetReward = "FeinaEvent_DungeonFinish_Reward",
			ActivityId = CurEventId,
			IsNewRecord = CurScore > MaxScore,
			DungeonId = CurrentDungeonId,
		}
		Params.ScoreInfo = {}
		-- 根据CurStar设置isFinish状态，前CurStar个项目设为true，其余设为false
		local LeveDes = DataMgr.PaotaiMiniGame[CurrentDungeonId].LeveDes
		for i = 1, #LeveDes do
			table.insert(Params.ScoreInfo, {
				text = string.format(GText(LeveDes[i]), DataMgr.PaotaiMiniGame[CurrentDungeonId].Level[i]),
				isFinish = i <= CurStar
			})
		end
		Params.ContinueCallback = function()
			local CustomParams = {
				PaotaiId = DataMgr.PaotaiMiniGame[CurrentDungeonId].Id
			}
			Avatar:EnterEventDungeon(nil,CurrentDungeonId,nil,CurEventId,CustomParams)
		end
		ActivityUtils.OpenActivitySettlement(DataMgr.PaotaiEventConstant["PaotaiGameEventId"].ConstantValue, CurrentDungeonId, Params)
	elseif CurDungeonType and CurDungeonType == "SoloRaid" then
		local CurScore = 0
		local MaxScore = 0
		local RawTimeRemain = 0
		if ClientRes and ClientRes["ResRaidScore"] then
			CurScore = ClientRes["ResRaidScore"]
		end
		if ClientRes and ClientRes["RawTimeRemain"] then
			RawTimeRemain = ClientRes["RawTimeRemain"]
		end
		MaxScore = self.CombatData.MaxScore or 0
		local Avatar = GWorld:GetAvatar()
		if not Avatar then
			return nil 
		end
		local CurrentRaidSeasonId = Avatar.CurrentRaidSeasonId
		local RaidSeason = Avatar.RaidSeasons[CurrentRaidSeasonId]
		local EventId = DataMgr.RaidSeason[CurrentRaidSeasonId] and DataMgr.RaidSeason[CurrentRaidSeasonId].EventId or DataMgr.RaidSeason[1].EventId
		
		local IsShowReturnText = false
		local RaidDungeonConfig = DataMgr.RaidDungeon[CurrentDungeonId]
		if RaidDungeonConfig and RaidDungeonConfig.TicketNum then
			for _, TicketCount in pairs(RaidDungeonConfig.TicketNum) do
				if TicketCount and TicketCount > 0 then
					IsShowReturnText = true
					break
				end
			end
		end
		
		-- 合并 Rewards 和 DungeonRewards
		-- 递归合并函数，处理嵌套的table结构
		local function MergeRewardTable(target, source)
			if not source then
				return
			end
			for key, value in pairs(source) do
				if type(value) == "table" then
					-- 如果是table，递归合并
					if not target[key] then
						target[key] = {}
					end
					MergeRewardTable(target[key], value)
				else
					-- 如果是数字，且target中已存在相同key的数字，则相加
					if target[key] and type(target[key]) == "number" and type(value) == "number" then
						target[key] = target[key] + value
					else
						-- 否则直接赋值（覆盖或新增）
						target[key] = value
					end
				end
			end
		end
		
		local MergedRewards = {}
		if Rewards then
			MergeRewardTable(MergedRewards, Rewards)
		end
		if DungeonRewards then
			MergeRewardTable(MergedRewards, DungeonRewards)
		end
		
		-- 获取门票信息
		local ResId, ConsumeTicketCount, CurrentTicketCount = GuildWarUtils.GetDungeonTicketInfo(CurrentDungeonId)
		
		local Params =
		{
			LevelScore = math.floor(CurScore),
			IsWin = IsWin,
			Text_Title = "FeinaEvent_DungeonFinish_Title",
			Text_GetReward = "FeinaEvent_DungeonFinish_Reward",
			ActivityId = EventId,
			IsNewRecord = CurScore > MaxScore,
			DungeonId = CurrentDungeonId,
			TimeRemain = math.floor(RawTimeRemain or 0),
			RewardsInfo = MergedRewards,
			IsShowReturnText = IsShowReturnText,
		}
		
		-- 如果有门票信息，设置CostParams
		if ResId > 0 and ConsumeTicketCount > 0 then
			Params.CostParams = {
				ResourceId = ResId,
				Numerator = CurrentTicketCount,
				Denominator = ConsumeTicketCount,
				bShowDenominator = true,
				Owner = nil, -- 会在UI中设置
			}
		end
		
		Params.ContinueCallback = function()
			return GuildWarUtils.EnterEventDungeon(CurrentDungeonId, EventId)
		end
		ActivityUtils.OpenActivitySettlement(EventId, CurrentDungeonId, Params)
	elseif CurDungeonType and CurDungeonType == "Temple" then
		local CurScore = 0
		local MaxScore = 0
		local CurStar = 0
		if self.CombatData and self.CombatData.Score then
			CurScore = self.CombatData.Score
		end
		if self.CombatData and self.CombatData.Score then -- temp
			MaxScore = self.CombatData.Score
		end
		if self.CombatData and self.CombatData.StarLevel then
			CurStar = self.CombatData.StarLevel -- temp
		end
		local Params =
		{
			LevelScore = CurScore,
			IsWin = IsWin,
			Text_Title = "TempleSolo_DungeonFinish_Title",
			Text_GetReward = "TempleSolo_DungeonFinish_Reward",
			ActivityId = 108001,
			IsNewRecord = CurScore > MaxScore,
			DungeonId = CurrentDungeonId,
			Text_TotalScore = "TempleSolo_Total_Time",
		}
		Params.ScoreInfo = {}
		local TempleInfo = DataMgr.Temple[CurrentDungeonId]
		-- 根据CurStar设置isFinish状态，前CurStar个项目设为true，其余设为false
		for i = 1, #TempleInfo.RatingRange do
			local TextInfo = ""
			local Target = TempleInfo.RatingRange[i]
			local TextRule2 = ""
			
			-- 确定规则类型
			if TempleInfo.SucRule == "Time" or TempleInfo.SucRule == "CountDown" then
				TextRule2 = "SECONDS"
			elseif TempleInfo.SucRule == "Score" then
				TextRule2 = "SCORE"
			elseif TempleInfo.SucRule == "Collect" then
				TextRule2 = "COUNT"
			end
			
			-- 生成星级描述文本
			if Target == nil then
				TextInfo = ""
			elseif Target == 0 then
				TextInfo = GText("UI_TEMPLE_SUCRULE_ZERO")
			else
				if TempleInfo.SucRule == "CountDown" and TempleInfo.UIShowType and TempleInfo.UIShowType > 0 then
					TextInfo = string.format(GText("UI_TEMPLE_SUCRULE_COUNTDOWN_" .. TempleInfo.UIShowType), 100 - Target)
				elseif TextRule2 == "SCORE" or TextRule2 == "COUNT" then
					TextInfo = GText("UI_TEMPLE_SUCRULE_" .. string.upper(TempleInfo.SucRule)) .. Target
				else
					TextInfo = GText("UI_TEMPLE_SUCRULE_" .. string.upper(TempleInfo.SucRule)) .. Target .. GText("UI_TEMPLE_MEASURE_" .. TextRule2)
				end
			end

			table.insert(Params.ScoreInfo, {
				text = TextInfo,
				isFinish = i <= CurStar
			})
		end
		local IsHardMode = DataMgr.TempleEventLevel[CurrentDungeonId].IsHardMode
		if IsHardMode then
			Params.IconPath = '/Game/UI/Texture/Static/Atlas/Activity/Temple/Solo/T_Activity_Temple_Solo_Star_Challenge.T_Activity_Temple_Solo_Star_Challenge'
			Params.IconPath_2 = '/Game/UI/Texture/Static/Atlas/Activity/Temple/Solo/T_Activity_Temple_Solo_Star_Challenge_Empty.T_Activity_Temple_Solo_Star_Challenge_Empty'
		end
		Params.ContinueCallback = function()
			-- Avatar:EnterDungeon(CurrentDungeonId)
			Avatar:EnterEventDungeon(nil, CurrentDungeonId, nil,  108001)
		end
		ActivityUtils.OpenActivitySettlement(108001, CurrentDungeonId, Params)
	elseif CurDungeonType and CurDungeonType == "MonsterRush" then
		local WuyoushengEventLevelData = DataMgr.WuyoushengEventLevel[CurrentDungeonId]
		local FinishTime = math.floor(self.CombatData.FinishTime or 0)
		local Params =
		{
			LevelScore = string.format("%d:%02d", math.floor(FinishTime / 60), FinishTime % 60),
			IsWin = IsWin,
			Text_Title = "FeinaEvent_DungeonFinish_Title",
			ActivityId = WuyoushengEventLevelData.EventId,
			DungeonId = CurrentDungeonId,
			Text_TotalScore = "UI_Wuyousheng_FinishTime",
		}

		Params.ScoreInfo = {}
		for i = 1, 3 do
			local LevelGoalRequiredTime1 = WuyoushengEventLevelData.LevelGoalRequiredTime1[i]
			local GoalText = nil
			local IsFinish = false
			if LevelGoalRequiredTime1 == -1 then
				GoalText = GText("Wuyousheng_Target_FinishLevel")
				IsFinish = IsWin
			else
				GoalText = string.format(GText("Wuyousheng_Target_LevelLimitTime"), LevelGoalRequiredTime1)
				IsFinish = IsWin and FinishTime <= LevelGoalRequiredTime1
			end
			table.insert(Params.ScoreInfo, {
				text = GoalText,
				isFinish = IsFinish
			})
		end

		if DungeonRewards and next(DungeonRewards) ~= nil then
			Params.RewardsInfo = DungeonRewards
		end

		Params.ContinueCallback = function()
			Avatar:EnterEventDungeon(nil, CurrentDungeonId, nil, WuyoushengEventLevelData.EventId)
		end
		ActivityUtils.OpenActivitySettlement(WuyoushengEventLevelData.EventId, CurrentDungeonId, Params)
	elseif CurDungeonType and CurDungeonType == "AutoChess" then
		local GameMode = UE4.UGameplayStatics.GetGameMode(self)
		local MissionType = 1
		local MissionId = 1001
		local AutoChessMissionInfo = DataMgr.AutoChessMission
		if not AutoChessMissionInfo then
			return
		end
		for Index, Info in pairs(AutoChessMissionInfo) do
			if Info.DungeonId == CurrentDungeonId then
				MissionType = Info.MissionType
				MissionId = Info.MissionId
			end
		end
		local Params = {
			ActivityId = 103016, --活动id
			MissionId = MissionId, --自走棋关卡id
			IsWin = IsWin,--是否胜利
			Text_GetReward = "UI_AutoChess_WinReward",--通关奖励
			DungeonType = "AutoChess",--副本类型
			--Btn_Exit_Text = "UI_AutoChess_FightAgain",--再次挑战
			ContinueCallback = function() 
				Avatar:EnterDungeonAgain(function(Ret)
					if Ret and Ret == ErrorCode.RET_SUCCESS then
						DebugPrint("AutoChessContinueSuccess RetCode:", Ret)
					else
						DebugPrint("AutoChessContinueFail RetCode:", Ret)
						self.AutoChessMissionId = nil
						Avatar:ExitDungeonSettlement()
					end
				end, nil, {MissionId = MissionId}) 
			end,--再次挑战回调
			BattleInfo = self.CombatData.AutoChessBattleInfo,--战斗数据统计
			RewardsInfo = DungeonRewards,--通关奖励信息
			MissionType = MissionType,--通关类型
			BattleInfoTextName = "UI_BATTLE_DATA", --战斗数据统计名称
		}
		if MissionType == 2 then
			Params["PreRankLevel"] = self.PreRankLevel or 1
			Params["PreRankScore"] = self.PreRankScore or 0
			Params["RankLevel"] = Avatar.AutoChess.RankLevel
			Params["RankScore"] = Avatar.AutoChess.RankScore
			Params["Point"] = ClientRes.Point
		end
		if self.bAutoChessDeploying then
			local Avatar = GWorld:GetAvatar()
			if not Avatar then
				return
			end
			self.bAutoChessDeploying = nil
			self.AutoChessMissionId = MissionId
			self.IsWin = IsWin
			local ExitDungeonData = self:GetExitDungeonData()
			if ExitDungeonData then
				ExitDungeonData.Type = "AutoChess"
			else
				ExitDungeonData = { Type = "AutoChess" }
			end
			GWorld.GameInstance:SetExitDungeonData(ExitDungeonData)
			Avatar:ExitDungeonSettlement()
		else
			ActivityUtils.OpenActivitySettlement(103016, nil, Params)
		end
	else
		UIManager:LoadUINew("DungeonSettlement", LogicServerInfo, self.DungeonIdCache, self.CombatData)
	end
end

function BP_EMGameInstance_C:CheckMaintenanceInfo(RequestHotNum, Callback)
	-- 维护公告
	CdnTool:GetMaintenance(RequestHotNum,function(Maintenances) 
		self:GetMaintenanceCb(RequestHotNum, Maintenances, Callback) 
	end)
end
function BP_EMGameInstance_C:JumpToHomepage(RequestHotNum)
	CdnTool:GetMaintenanceInterceptUrl(RequestHotNum, function(InterceptUrl)
		local JumpURL = nil
		if InterceptUrl and InterceptUrl.mediumList then 
			local ChannelId = Utils.HeroUSDKSubsystem():GetChannelId()
			local ImgChannelId = Utils.HeroUSDKSubsystem():GetMirrorChannelId()
			for _, Data in ipairs(InterceptUrl.mediumList) do 
				if self:CheckMaintenancePakInfos(ChannelId, ImgChannelId, Data.pakInfos) then 
					JumpURL = Data.content and Data.content[1] and Data.content[1].url
					local SystemLanguage = EMCache:Get("SystemLanguage")
					for _, InfoContent in ipairs(Data.content) do 
						if InfoContent.language and InfoContent.language.code == SystemLanguage then 
							JumpURL = InfoContent.url
							break 
						end
					end
					break
				end
			end
		end
		if JumpURL then 
			UE4.UKismetSystemLibrary.LaunchURL(JumpURL)
		end
	end)
end

function BP_EMGameInstance_C:CheckMaintenancePakInfos(ChannelId, ImgChannelId, PakInfos)
	if not PakInfos then 
		return false
	end
	if ChannelId == -1 and ImgChannelId == -1 then 
		return true
	end
	for _, PakInfo in ipairs(PakInfos) do 
		local Code = type(PakInfo)=="table" and PakInfo.code or PakInfo
		local EInfo = Code and DataMgr.ExamineInfo[Code]
		if EInfo and EInfo.ChannelID == ChannelId and EInfo.MirrorChannelID == ImgChannelId then 
			return true
		end
	end
	return false
end

function BP_EMGameInstance_C:GetMaintenanceCb(RequestHotNum, Maintenances, Callback)
	local IsSuccess = true 
	local bHasContent = false
	if Maintenances then
		local ChannelId = Utils.HeroUSDKSubsystem():GetChannelId()
		local ImgChannelId = Utils.HeroUSDKSubsystem():GetMirrorChannelId()
		local Now = TimeUtils.NowTime()
		for _, Info in pairs(Maintenances) do 
			if Info.Content and #Info.Content > 0 then 
				if Now > Info.StartTimestamp and Now < Info.EndTimestamp and self:CheckMaintenancePakInfos(ChannelId, ImgChannelId, Info.pakInfos) then 
					local Content = nil
					local SystemLanguage = EMCache:Get("SystemLanguage")
					for _, InfoContent in ipairs(Info.Content) do 
						if InfoContent.language == SystemLanguage then 
							Content = InfoContent
							break 
						end
					end
					if Content then 
						IsSuccess = false 
						---@type Common_Dialog_Params
										
						local Params = {}
						Params.ShortText = Content.body
						Params.RightCallbackFunction = function()
							self:JumpToHomepage(RequestHotNum)
						end
						UIManager(self):ShowCommonPopupUI(100205, Params)
						bHasContent = true
						break 
					end
				end
			end
		end
	end


	if Callback then 
		Callback(IsSuccess, bHasContent)
		-- if GWorld.IsDev then 
		-- 	-- DebugPrint("Tianyi@ 开发模式不被拦截")
		-- 	Callback(true, true)	-- 编辑器模式默认返回true
		-- else 
		-- 	-- DebugPrint("Tianyi@ 正式环境，IsSuccess = " .. (IsSuccess))
		-- 	Callback(IsSuccess, bHasContent)
		-- end
	end
end
-- @SnowMoon 副本异常数据恢复相关
function BP_EMGameInstance_C:SetProgressData(DataTable, PlayerSlice)
	self.InterruptProgressData = DataTable
	self.PlayerSliceData = PlayerSlice
end

function BP_EMGameInstance_C:GetProgressData()
	return self.InterruptProgressData
end

function BP_EMGameInstance_C:GetPlayerSliceData()
	return self.PlayerSliceData
end

function BP_EMGameInstance_C:ClearProgressData()
	self.InterruptProgressData = nil
end

function BP_EMGameInstance_C:ClearPlayerSliceData()
	self.PlayerSliceData = nil
end

-- Dungeon AfterLoading 暂存数据相关
function BP_EMGameInstance_C:SetExitDungeonData(DataTable)
	self.ExitDungeonData = DataTable
end

function BP_EMGameInstance_C:GetExitDungeonData()
	return self.ExitDungeonData
end

function BP_EMGameInstance_C:ClearExitDungeonData()
	self.ExitDungeonData = nil
end

--------------- 序章 Logo UI 显示 -------------------
function BP_EMGameInstance_C:LoadLogoAtEndOfPrologue()
	local UIManager = GWorld.GameInstance:GetGameUIManager()
	local PrologueEndLogoUI = UIManager:LoadUI(UIConst.PROLOGUEENDLOGO, "PrologueEndLogo", UIConst.ZORDER_ABOVE_ALL)
	if (PrologueEndLogoUI ~= nil) then
		PrologueEndLogoUI:Show("Talk")
	end

	self.LogoLanguageMap = {
		["TextMapContent"] = "CN_In",
		["ContentEN"] = "EN_In",
		["ContentJP"] = "JP_In",
		["ContentKR"] = "KR_In",
		["ContentTC"] = "TC_In"
	}
end
function BP_EMGameInstance_C:UnLoadLogoAtEndOfPrologue()
	local UIManager = GWorld.GameInstance:GetGameUIManager()
    local PrologueEndLogoUI = UIManager:GetUIObj("PrologueEndLogo")
	PrologueEndLogoUI:Close()
end

function BP_EMGameInstance_C:ShowLogoAtEndOfPrologue()
	local UIManager = GWorld.GameInstance:GetGameUIManager()
    local PrologueEndLogoUI = UIManager:GetUIObj("PrologueEndLogo")
	
	local LogoIn = self.LogoLanguageMap[CommonConst.SystemLanguage] or self.LogoLanguageMap[CommonConst.SystemLanguages.Default]
	PrologueEndLogoUI:PlayAnimation(PrologueEndLogoUI[LogoIn])
end
function BP_EMGameInstance_C:ShowWhiteAtEndOfPrologue()
	local UIManager = GWorld.GameInstance:GetGameUIManager()
    local PrologueEndLogoUI = UIManager:GetUIObj("PrologueEndLogo")
	PrologueEndLogoUI:PlayAnimation(PrologueEndLogoUI.Static_Img_BottomMask_In)
end
function BP_EMGameInstance_C:ShowBlackAtEndOfPrologue()
	local UIManager = GWorld.GameInstance:GetGameUIManager()
    local PrologueEndLogoUI = UIManager:GetUIObj("PrologueEndLogo")
	PrologueEndLogoUI:PlayAnimation(PrologueEndLogoUI.Black_In)
end

function BP_EMGameInstance_C:HideLogoAtEndOfPrologue()
	local UIManager = GWorld.GameInstance:GetGameUIManager()
    local PrologueEndLogoUI = UIManager:GetUIObj("PrologueEndLogo")
	PrologueEndLogoUI:PlayAnimation(PrologueEndLogoUI.Logo_Out)
end
function BP_EMGameInstance_C:HideBlackAtEndOfPrologue()
	local UIManager = GWorld.GameInstance:GetGameUIManager()
    local PrologueEndLogoUI = UIManager:GetUIObj("PrologueEndLogo")
	PrologueEndLogoUI:PlayAnimation(PrologueEndLogoUI.Black_Out)
end

function BP_EMGameInstance_C:PrologueLogoSetFirstDialog()
	local UIManager = GWorld.GameInstance:GetGameUIManager()
    local PrologueEndLogoUI = UIManager:GetUIObj("PrologueEndLogo")

	PrologueEndLogoUI.Text_ChapterDesc:SetText(GText("UI_LOGO_DIALOGUE_10018201"))
	PrologueEndLogoUI.Text_WorldDesc:SetText(GText("UI_LOGO_DIALOGUE_10018201_WORLD"))
	PrologueEndLogoUI:PlayAnimation(PrologueEndLogoUI.Text_In)
end
function BP_EMGameInstance_C:PrologueLogoUnSetFirstDialog()
	local UIManager = GWorld.GameInstance:GetGameUIManager()
    local PrologueEndLogoUI = UIManager:GetUIObj("PrologueEndLogo")
	PrologueEndLogoUI:PlayAnimation(PrologueEndLogoUI.Text_Out)
end

function BP_EMGameInstance_C:PrologueLogoSetSecondDialog()
	local UIManager = GWorld.GameInstance:GetGameUIManager()
    local PrologueEndLogoUI = UIManager:GetUIObj("PrologueEndLogo")
	
	PrologueEndLogoUI.Text_ChapterDesc:SetText(GText("UI_LOGO_DIALOGUE_10018202"))
	PrologueEndLogoUI.Text_WorldDesc:SetText(GText("UI_LOGO_DIALOGUE_10018202_WORLD"))
	PrologueEndLogoUI:PlayAnimation(PrologueEndLogoUI.Text_In)
end
function BP_EMGameInstance_C:PrologueLogoUnSetSecondDialog()
	local UIManager = GWorld.GameInstance:GetGameUIManager()
    local PrologueEndLogoUI = UIManager:GetUIObj("PrologueEndLogo")
	PrologueEndLogoUI:PlayAnimation(PrologueEndLogoUI.Text_Out)
end
----------------------------------------------------

function BP_EMGameInstance_C:OnGlobalGameUITagChanged(OldTag, NewTag)
	DebugPrint("LHQ_OnGlobalGameUITagChanged: start")
	if NewTag == "" then
		self:TriggerAllNpcPauseAndHide("None")
	else
		self:TriggerAllNpcPauseAndHide(NewTag)
	end
	DebugPrint("LHQ_OnGlobalGameUITagChanged: end")
end

function BP_EMGameInstance_C:TriggerAllNpcPauseAndHide(NewTag)
	DebugPrint("LHQ_OnGlobalGameUITagChanged_HideNpc: start")
	local PlayHideActorEffect = function(Actor)
        if(Actor.FXComponent)then
            Actor:SetTickableWhenPaused(true)
        end
		if(Actor.FXComponent)then
			Actor.FXComponent:PlayEffectByIDParams(302, {bTickEvenWhenPaused = true,NotAttached = true})
		else
			local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
			local Location = Actor:K2_GetActorLocation()
			Player.FXComponent:PlayEffectByIDParams(302, {UseAbsoluteLocation = true,Location = {Location.X,Location.Y,Location.Z},bTickEvenWhenPaused = true})
		end
    end

		local CurGameMode = UE4.UGameplayStatics.GetGameMode(self)
		local CurGameInstance = UE4.UGameplayStatics.GetGameInstance(self)
		if not CurGameMode or not CurGameInstance then
			return
		end
		local GameState = UE4.UGameplayStatics.GetGameState(self)
		local NpcCharacterMap = GameState.NpcCharacterMap:ToTable()
		for _, Npc in pairs(NpcCharacterMap) do
			local NpcData = DataMgr.Npc[Npc.UnitId]
			if NpcData ~= nil then
				if NpcData.GlobalGameUITagList ~= nil then
					for _, value in pairs(NpcData.GlobalGameUITagList) do
						if value == NewTag then
							Npc:TriggerNpcGlobalTimeDilation(true)
							Npc:SetActorHideTag("GlobalTimeDilation", false, false, true)
							goto continue
						end
					end
				end
				if not Npc.HideTags or Npc.HideTags:Num() == 0 then
					if NewTag ~= "None" then
						Npc:TriggerNpcGlobalTimeDilation(true)
						PlayHideActorEffect(Npc)
					end
				end
				Npc:SetActorHideTag("GlobalTimeDilation", true, false, true)
				::continue::
				if NewTag == "None" then
					Npc:SetActorHideTag("GlobalTimeDilation", false, false, true)
				end
			end
			local NpcName = Npc:GetName()
			local IsHidden = Npc.bHidden
			if IsHidden then
				DebugPrint("LHQ_OnGlobalGameUITagChanged_HideNpc: ".. NewTag .. " Npc: " .. NpcName .. " IsHidden: " .. "true")
			else
				DebugPrint("LHQ_OnGlobalGameUITagChanged_HideNpc: ".. NewTag .. " Npc: " .. NpcName .. " IsHidden: " .. "false")
			end
		end

		local CustomNpcs = GameState.CustomNpcSet:ToTable()
		for _, CustomNpc in pairs(CustomNpcs) do
			if not CustomNpc.HideTags or CustomNpc.HideTags:Num() == 0 then
				if NewTag ~= "None" then
					PlayHideActorEffect(CustomNpc)
				end
			end
			CustomNpc:SetCustomNpcHideTag("GlobalTimeDilation", true)
			CustomNpc:SetCollisionDisableTag("GlobalTimeDilation", true)

			if NewTag == "None" then
				CustomNpc:SetCustomNpcHideTag("GlobalTimeDilation", false)
				CustomNpc:SetCollisionDisableTag("GlobalTimeDilation", false)
			end

			local NpcName = CustomNpc:GetName()
			local IsHidden = CustomNpc.bHidden
			if IsHidden then
				DebugPrint("LHQ_OnGlobalGameUITagChanged_HideNpc: ".. NewTag .. " Npc: " .. NpcName .. " IsHidden: " .. "true")
			else
				DebugPrint("LHQ_OnGlobalGameUITagChanged_HideNpc: ".. NewTag .. " Npc: " .. NpcName .. " IsHidden: " .. "false")
			end
		end
	DebugPrint("LHQ_OnGlobalGameUITagChanged_HideNpc: end")
end

function BP_EMGameInstance_C:OnGameInputMethodChanged(CurInputDeviceType, CurInputDeviceName)
	self.CurInputDeviceType = CurInputDeviceType
    self.CurInputDeviceName = CurInputDeviceName
end

function BP_EMGameInstance_C:BindGamepadEvent()
	if self.CurInputDeviceType ~= nil then return end
	local GameInputModeSubsystem = self:GetGameUIManager():GetGameInputModeSubsystem(self)
	if GameInputModeSubsystem then
		self.CurInputDeviceType = GameInputModeSubsystem:GetCurrentInputType()
		self.CurInputDeviceName = GameInputModeSubsystem:GetCurrentGamepadName()
		GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnGameInputMethodChanged)
		GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.SendInputDiviceChangeMessage)
	end
end

function BP_EMGameInstance_C:UnBindGamepadEvent()
	if self.CurInputDeviceType == nil then return end
	local GameInputModeSubsystem = self:GetGameUIManager():GetGameInputModeSubsystem(self)
	if GameInputModeSubsystem then
		GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnGameInputMethodChanged)
		GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.SendInputDiviceChangeMessage)
	end
	self.CurInputDeviceType = nil
	self.CurInputDeviceName = nil
end

function BP_EMGameInstance_C:LoadGMHyperLink()
	self.GMHyperLink = ""
	local Path = "/PakJumpUrl/PakJumpUrl.json"
	CdnTool:GetGMUrlLink(Path,function(UrlLinkTable)
		DebugPrint("ReceiveInit GetGMUrlLink enter callback")
		if UrlLinkTable then
			DebugPrint("ReceiveInit GetGMUrlLink enter callback UrlLinkTable valid")
			for _, Info in pairs(UrlLinkTable) do
				DebugPrint("ReceiveInit GetGMUrlLink enter callback print ChannelID: ", Info.ChannelId)
				DebugPrint("ReceiveInit GetGMUrlLink enter callback print MirrorChannelId: ", Info.ImgChannelId)
				if Info.ChannelId and Info.ChannelId == HeroUSDKSubsystem(self):GetChannelId() then
					DebugPrint("ReceiveInit GetGMUrlLink enter callback ChannelID matched: ", Info.ChannelId)
					local MirrorChannelID = Info.ImgChannelId
					if not MirrorChannelID then
						MirrorChannelID = 0
					end
					local SDKMirrorChannelID = HeroUSDKSubsystem(self):GetMirrorChannelId()
					if SDKMirrorChannelID <= 0 then
						SDKMirrorChannelID = 0
					end
					if MirrorChannelID == SDKMirrorChannelID then
						DebugPrint("ReceiveInit GetGMUrlLink enter callback MirrorChannelID matched: ", MirrorChannelID)
						self.GMHyperLink = Info.JumpUrl or ""
						DebugPrint("ReceiveInit GetGMUrlLink enter callback Info.JumpUrl: ", Info.JumpUrl)
						break
					end
				end
			end
		end
	end)
end

function BP_EMGameInstance_C:ReceiveInit()
	GWorld.GameInstance = self
	if IsDedicatedServer(self) then
		return
	end
	
	ReddotManager._Init()
	-- if UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
	-- 	---PIE模式下使锁帧生效 --调低帧率，验证一些移动端问题
	-- 	---@type UEngine
	-- 	local Engine = UEngine:GetDefaultObject()
	-- 	if Engine.bUseFixedFrameRate then
	-- 		UKismetSystemLibrary.ExecuteConsoleCommand(self, "t.MaxFPS "..Engine.FixedFrameRate, nil)
	-- 	end
	-- end

	---游戏进程切后台和切前台
	self.OnApplicationWillEnterBackground = function(self)
		EventManager:FireEvent(EventID.ApplicationWillEnterBackground)
		---游戏切后台需要保存本地缓存
		EMCache:SaveAll(false)
	end
	self.ApplicationWillEnterBackgroundDelegate:Add(self, self.OnApplicationWillEnterBackground)
	self.OnApplicationHasEnteredForeground = function(self)
		EventManager:FireEvent(EventID.ApplicationHasEnteredForeground)
	end
	self.ApplicationHasEnteredForegroundDelegate:Add(self, self.OnApplicationHasEnteredForeground)

	---游戏进程停用和启用
	self.OnApplicationWillDeactivate = function(self)
		EventManager:FireEvent(EventID.ApplicationWillDeactivate)
		---游戏停用需要保存本地缓存
		EMCache:SaveAll(false)
	end
	self.ApplicationWillDeactivateDelegate:Add(self, self.OnApplicationWillDeactivate)
	self.OnApplicationHasReactivated = function(self)
		EventManager:FireEvent(EventID.ApplicationHasReactivated)
	end
	self.ApplicationHasReactivatedDelegate:Add(self, self.OnApplicationHasReactivated)

	---游戏进程终止，常见于游戏崩溃或者杀进程，虽然不是所有平台都能保证调用，但还是尽可能做一下保底
	--self.ApplicationWillTerminateDelegate:Add(self, self.OnApplicationWillTerminate)

	local TeammateEffects = EMCache:Get("TeammateEffects")
	if TeammateEffects then
		UEMGameInstance.SetFriendFXQuality(TeammateEffects)
	else
		local NowContentPerformance = self.GetGameplayScalabilityLevel()
		UEMGameInstance.SetFriendFXQuality(NowContentPerformance <= 1 and 0 or 1)
	end

	self.CacheShowRewardUIParams = {}
	-- self.ScriptDetectionCheckRecordNum = 0 迁移至C++实现 2025.12
	EventManager:AddEvent(EventID.TalkHiddenGameUI, self, self.OnTalkHiddenGameUIChange)
	EventManager:AddEvent(EventID.ConditionComplete, self, self.OnConditionComplete)

	-- self:LoadGMHyperLink()
end

--游戏进程终止需要保存本地缓存
function BP_EMGameInstance_C:OnApplicationWillTerminate()
	--立即清空委托绑定，防止连续崩溃的递归调用
	self.ApplicationWillTerminateDelegate:Clear()
	EMCache:SaveAll(false)
end

---游戏退出前会走一遍这个函数
function BP_EMGameInstance_C:ReceiveShutdown()
	if IsDedicatedServer(self) then
		return
	end
	UE.UAnnounceHttpServerSubsystem.GetInstance(self):StopAnnouncementServer()
	local ShundownCount = EMCache:Get("ShundownCount") or 0
	EMCache:Set("ShundownCount", ShundownCount + 1)
	ShundownCount = EMCache:Get("ShundownCount") or 0

	ReddotManager._Close()
	---临退出前保存一下本地缓存数据
	EMCache:SaveAll(true)

	if not URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
		UEMGameInstance.ForceQuitGame()
	end

	-- 这里偶现会崩，然后Unlua内部会帮我们移除已经注册的委托，所以这里没必要写了
	-- local GameInputModeSubsystem = self:GetGameUIManager():GetGameInputModeSubsystem(self)
	-- if GameInputModeSubsystem then
	-- 	GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnGameInputMethodChanged)
	-- end
	-- self.ApplicationHasEnteredForegroundDelegate:Remove(self, self.OnApplicationHasEnteredForeground)
	-- self.ApplicationWillEnterBackgroundDelegate:Remove(self, self.OnApplicationWillEnterBackground)
	-- self.ApplicationWillDeactivateDelegate:Remove(self, self.OnApplicationWillDeactivate)
	-- self.ApplicationHasReactivatedDelegate:Remove(self, self.OnApplicationHasReactivated)
	-- self.ApplicationWillTerminateDelegate:Clear()
end

--初始化游戏设置
function BP_EMGameInstance_C:InitGameSetting()
	SettingUtils.InitPerformanceSetting()
	self:InitGameSystemLanguage()
	self:InitGameSystemVoice()
	self:InitGameInterfaceMode()
	self:InitGameMuteBackstage()
	self:InitHideBackWeapons()
	self:InitVoiceGuide()
	self:InitAutoFashionSwitch()
end

function BP_EMGameInstance_C:InitVoiceGuide()
	local OptionConfig = DataMgr.Option["VoiceGuide"]
	if not OptionConfig then
		return
	end
	local Value = EMCache:Get("VoiceGuide")
	if Value == nil then
		if CommonUtils.GetRuntimePlatform(self) == "Mobile" and OptionConfig.DefaultValueM then
			Value = OptionConfig.DefaultValueM == "True"
		else
			Value = OptionConfig.DefaultValue == "True"
		end
	end
	AudioManager(self):SetTalkVoiceTurnOff(not Value)
end

function BP_EMGameInstance_C:InitAutoFashionSwitch()
	local OptionConfig = DataMgr.Option["AutoFashion"]
	if not OptionConfig then
		self.IsAutoFashionSwitch = false
		return
	end
	local Value = EMCache:Get(OptionConfig.EMCacheName)
	if Value == nil then
		if CommonUtils.GetRuntimePlatform(self) == "Mobile" and OptionConfig.DefaultValueM then
			Value = OptionConfig.DefaultValueM == "True"
		else
			Value = OptionConfig.DefaultValue == "True"
		end
	end
	self.IsAutoFashionSwitch = Value
end

function BP_EMGameInstance_C:InitGameSystemLanguage()
	local SystemLanguage = EMCache:Get("SystemLanguage")
    if SystemLanguage ~= nil then
        CommonConst.SystemLanguage = CommonConst.SystemLanguages[SystemLanguage]
		-- self.SystemLanguage = CommonConst.SystemLanguages[SystemLanguage]
		self.SystemLanguage = Language2ESystemLanguage[CommonConst.SystemLanguage]
    else
		local IsGlobalPak = UE.AHotUpdateGameMode.IsGlobalPak()
		if IsGlobalPak then
			local LanguageMapping = {
				zh = "CN",
				en = "EN",
				ko = "KR",
				ja = "JP",
				-- de = "DE",
				fr = "FR",
				-- es = "ES",
			}
			local ChineseLanguageMapping = {
				cn = "CN",
				hk = "TC",
				tw = "TC",
				mo = "TC",
			}
			local VoiceMapping = {
				CN = "CN",
				TC = "CN",
				EN = "EN",
				KR = "KR",
				JP = "JP",
			}
			local WindowsLanguage = UE4.UKismetSystemLibrary.GetDefaultLanguage()
			local NationWindowsLanguage = string.sub(WindowsLanguage,1,2)
			NationWindowsLanguage = string.lower(NationWindowsLanguage)
			local LangMapping = LanguageMapping[NationWindowsLanguage] or "EN"
			if LangMapping == "CN" then
				local RegionWindowsLanguage = string.lower(WindowsLanguage)
				for key,value in pairs(ChineseLanguageMapping) do
					if string.find(RegionWindowsLanguage,key) then
						LangMapping = value
						break
					end
				end
			end
			CommonConst.SystemLanguage = CommonConst.SystemLanguages[LangMapping]
			-- self.SystemLanguage = CommonConst.SystemLanguages[LangMapping]
			self.SystemLanguage = Language2ESystemLanguage[CommonConst.SystemLanguage]
			local Voice = VoiceMapping[LangMapping] or "EN"
			CommonConst.SystemVoice = Voice
			EMCache:Set("SystemVoice",Voice)
			EMCache:Set("SystemLanguage",LangMapping)
		else
			--国服包默认中文
			CommonConst.SystemLanguage = CommonConst.SystemLanguages.CN
			EMCache:Set("SystemLanguage","CN")
			CommonConst.SystemVoice = CommonConst.SystemVoices.CN
			EMCache:Set("SystemVoice","CN")
		end
		self:OnSystemLanguageChanged()
    end
	local IsPIE = UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self)
	if not IsPIE then
		self:SetCurrentLanguage()
	end
	self:SetUsdkLanguage()
end

--设置活跃文化语言
function BP_EMGameInstance_C:SetCurrentLanguage()
	local Cultures = {
		CN = "en",
		EN = "en",
		KR = "ko",
		JP = "ja",
		FR = "fr",
		DE = "de",
		ES = "es",
		TC = "zh-Hant-tw"
	}
	local SystemLanguage = EMCache:Get("SystemLanguage")
	local Culture = Cultures[SystemLanguage] or "en"
    UE4.UKismetInternationalizationLibrary.SetCurrentLanguage(Culture,true)
end

function BP_EMGameInstance_C:SetUsdkLanguage()
	local UsdkLanguageMapping = {
		CN = "HeroLanguageZhHans",
		TC = "HeroLanguageZhHant",
		EN = "HeroLanguageEn",
		JP = "HeroLanguageJa",
		KR = "HeroLanguageKo",
		FR = "HeroLanguageFrench",
	}
	local SystemLanguage = EMCache:Get("SystemLanguage")
	local UsdkLanguage = UsdkLanguageMapping[SystemLanguage]
	self:InitUsdkLanguage(EHeroUsdkLanguageFlag[UsdkLanguage])
end

function BP_EMGameInstance_C:InitGameSystemVoice()
	if IsDedicatedServer(self) then
		return
	end
	local SystemVoice = EMCache:Get("SystemVoice")
    if SystemVoice ~= nil then
        CommonConst.SystemVoice = SystemVoice
    end
    self:AddDelayFrameFunc(
	function()
			AudioManager(self):RecoverSavedData()
	end, 1)
	self:OnSystemVoiceLanguageChanged()
    -- AudioManager(self):SetVoiceLanguage(CommonConst.SystemVoice)
end

--初始化显示模式 包体首次登陆时设置成无边框窗口化
function BP_EMGameInstance_C:InitGameInterfaceMode()
	local IsPIE = UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self)
	if IsPIE then
		return
	end
	if UE4.UUCloudGameInstanceSubsystem and UE4.UUCloudGameInstanceSubsystem.IsCloudGame(self) then
		return
	end
	local OptionName = "InterfaceMode"
	local OptionCacheName = "InterfaceModeCacheName"--换个Key让以前的缓存失效，全部设置成无边框窗口化
	local GameInterfaceMode = EMCache:Get(OptionCacheName)
	if GameInterfaceMode == nil then
		local SceneManager = self:GetSceneManager()
		if SceneManager == nil then
			return
		end
		local InterfaceModeList = {
			[1] = EWindowMode.Fullscreen,
			[2] = EWindowMode.Windowed,
			[3] = EWindowMode.WindowedFullscreen,
		}
		local OptionInfo = DataMgr.Option[OptionName]
		local DefaultMode = EWindowMode.WindowedFullscreen
		if OptionInfo then
			DefaultMode = InterfaceModeList[tonumber(OptionInfo.DefaultValue)]
			if CommonUtils.GetRuntimePlatform(self) == "Mobile" and OptionInfo.DefaultValueM then
				DefaultMode = InterfaceModeList[tonumber(OptionInfo.DefaultValueM)]
			end
		end
		SceneManager:ResizeWindow(DefaultMode)
		EMCache:Set(OptionCacheName,DefaultMode)
		DebugPrint("初始化显示模式 包体首次登陆时设置成无边框窗口化 InitGameInterfaceMode DefaultMode:"..DefaultMode)
	end
end

--初始化后台静音
function BP_EMGameInstance_C:InitGameMuteBackstage()
	local OptionName = "MuteBackstage"
	local GameMuteBackstage = EMCache:Get(OptionName)
	if GameMuteBackstage == nil then
		local OptionInfo = DataMgr.Option[OptionName]
		if OptionInfo.DefaultValue == "True" then
			GameMuteBackstage = true
		else
			GameMuteBackstage = false
		end
		EMCache:Set(OptionName,GameMuteBackstage)
	end
	if GameMuteBackstage then
		AudioManager(self):BindLogicToWindowActivatedDeactivated()
	else
		AudioManager(self):UnBindLogicToWindowActivatedDeactivated()
	end
end

--初始化隐藏背后武器
function BP_EMGameInstance_C:InitHideBackWeapons()
	local CacheName = "HideBackWeapons"
	local bHideBackWeapon = EMCache:Get(CacheName)
	if bHideBackWeapon == nil then
		local OptionInfo = DataMgr.Option[CacheName]
		if OptionInfo.DefaultValue == "True" then
			bHideBackWeapon = true
		else
			bHideBackWeapon = false
		end
		EMCache:Set(CacheName,bHideBackWeapon)
	end
	if not AWeaponBase or not AWeaponBase.SetWeaponBackTimerEnabled then
        return
    end
	AWeaponBase.SetWeaponBackTimerEnabled(self,bHideBackWeapon)
end

function BP_EMGameInstance_C:UploadLuaCallError(ErrorMsg)
	if not (GWorld and GWorld:GetAvatar()) then
		return ""
	end

	local Avatar = GWorld:GetAvatar()
	local PlayerCharacter = UGameplayStatics.GetPlayerCharacter(self, 0)

	local function GetPlayerSceneName()
		local GameState = UE4.UGameplayStatics.GetGameState(self)
		local GameMode = UE4.UGameplayStatics.GetGameMode(self)
		if not (PlayerCharacter and GameState and GameMode) then
			return ""
		end

		local WCSubsystem = GameMode:GetWCSubSystem()
		if WCSubsystem then
			if GameState:IsInDungeon() then
				return WCSubsystem:GetLocationLevelName(PlayerCharacter:K2_GetActorLocation())
			elseif Avatar:IsInBigWorld() then
				return WCSubsystem:GetLocationLevelName(PlayerCharacter:K2_GetActorLocation())
			end
			return ""
		else
			if not GameState:IsInDungeon() then
				return ""
			end
			local LevelShortName = UE4.URuntimeCommonFunctionLibrary.GetLevelLoadJsonName(PlayerCharacter)
			local JsonLoads = function(ShortName)
				local ProPath = UE4.UKismetSystemLibrary.GetProjectContentDirectory()
				local Path= ProPath .. 'Script/Datas/Houdini_data/'..ShortName .. '.json'
				local Info = UE4.URuntimeCommonFunctionLibrary.LoadFile(Path)
				local Json= require("rapidjson")
				local Res = Json.decode(Info)
				return Res
			end
			local LevelIds = PlayerCharacter.CurrentLevelId
			if not LevelIds then
				return ""
			end
			local LevelInfo = string.format("当前玩家进的拼接关卡: %s", LevelShortName)
			local LevelData = JsonLoads(LevelShortName)
			for _, point in pairs(LevelData.points) do
				for i=1,LevelIds:Length() do
					local cur_id = LevelIds:Get(i)
					if tostring(point.id) == cur_id then
						local cur_artLevel = point.art_path
						if cur_artLevel == '' then
							cur_artLevel = string.gsub(point.struct, "Data_Design", "Data_Art", 1)
						end
						LevelInfo = LevelInfo .. string.format("，所在的美术关卡是: %s， 关卡id是： %s", cur_artLevel, cur_id)
					end
				end
			end
			return LevelInfo
		end
	end

	local SceneName = "Error"
	pcall(function() SceneName = GetPlayerSceneName() end)
	local SceneId = ""
	if WorldTravelSubsystem and WorldTravelSubsystem() then 
		SceneId = tostring(WorldTravelSubsystem():GetCurrentSceneId())
	end
	local PlayerLocation =  (PlayerCharacter and tostring(PlayerCharacter:K2_GetActorLocation()) or " ")
	local WrapErrorMsg = "Uid:" .. tostring(Avatar.Uid) .. "\n" .. 
		"SceneId:" .. SceneId .. "\n" ..
		"SceneName:" .. tostring(SceneName) .. "\n" ..
		"PlayerLocation:" .. PlayerLocation .. "\n" .. 
		ErrorMsg

	Avatar:ReportClientTrace(WrapErrorMsg)
	local EMSentrySubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UEMSentrySubsystem)
    if EMSentrySubsystem then
        EMSentrySubsystem:ReportLuaTrace(ErrorMsg, {
			SceneId = SceneId, SceneName = tostring(SceneName), Location = PlayerLocation
		})
    end
end

function BP_EMGameInstance_C:GetDeviceTypeByPlatformName()
	return CommonUtils:GetDeviceTypeByPlatformName()
end

function BP_EMGameInstance_C:GetPlayerMVPDataByIndex(PlayerIndex)
	local DungeonId = self:GetCurrentDungeonId()
	local DungeonInfo = DataMgr.Dungeon[DungeonId]

	if DungeonInfo and DungeonInfo.DungeonType and DungeonInfo.DungeonType == "Party" then
        for i = 1, 4 do
            self["Data0"..i]:SetVisibility(ESlateVisibility.Collapsed)
        end
        local ScenePlayers = self.ScenePlayers
        if ScenePlayers and #ScenePlayers <= 1 then return end
        for CurPlayerIndex, Player in ipairs(ScenePlayers) do
            if self["TempleData0"..CurPlayerIndex] then
                self["TempleData0"..CurPlayerIndex]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                self["TempleData0"..CurPlayerIndex].Text_Index:SetText(CurPlayerIndex)
                if Player.IsMainPlayer then
                    self["TempleData0"..CurPlayerIndex]:PlayAnimation(self["TempleData0"..CurPlayerIndex].Player)
                else
                    self["TempleData0"..CurPlayerIndex]:PlayAnimation(self["TempleData0"..CurPlayerIndex].Other)
                end

                if self.CombatData.PartyPlayerCompleteTime[CurPlayerIndex] then
                    -- 有通关时间数据
                    self["TempleData0"..CurPlayerIndex]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                    self["TempleData0"..CurPlayerIndex].Text_Time:SetText(self:GetTimeStr(self.CombatData.PartyPlayerCompleteTime[CurPlayerIndex]))
                else
                    -- 无通关时间数据，未完成
                    self["TempleData0"..CurPlayerIndex].SizeBox_77:SetVisibility(ESlateVisibility.Collapsed)
                    self["TempleData0"..CurPlayerIndex].Text_Time:SetText(GText("UI_PARTY_PARKOUR_UNFINISH"))
                end
                if CurPlayerIndex == 1 then
                    -- 第一名和其他名次字体和pos不一样
                    local Slot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self["TempleData0"..CurPlayerIndex].Text_Index)
                    local Pos = Slot:GetPosition()
                    Slot:SetPosition(FVector2D(Pos.X, self["TempleData0"..CurPlayerIndex].TextPosY_No1))
                    local Font = self["TempleData0"..CurPlayerIndex].Text_Index.Font
                    Font.Size = self["TempleData0"..CurPlayerIndex].TextSize_No1
                    self["TempleData0"..CurPlayerIndex].Text_Index:SetFont(Font)
                else
                    local Slot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self["TempleData0"..CurPlayerIndex].Text_Index)
                    local Pos = Slot:GetPosition()
                    Slot:SetPosition(FVector2D(Pos.X, self["TempleData0"..CurPlayerIndex].TextPosY_Other))
                    local Font = self["TempleData0"..CurPlayerIndex].Text_Index.Font
                    Font.Size = self["TempleData0"..CurPlayerIndex].TextSize_Other
                    self["TempleData0"..CurPlayerIndex].Text_Index:SetFont(Font)
                end
            end
        end
        return
    end

    local Players = self:CalcPlayersMVPData()

	if Players and Players[PlayerIndex] then
		local NumText = Players[PlayerIndex][1].Value
		if NumText < 1000000000 then
			NumText = Utils.FormatNumber(NumText, false)
			if Players[PlayerIndex][1].DataName == "Damage" or Players[PlayerIndex][1].DataName == "Damaged" then
				NumText = string.format("%s", NumText).."%"
			end
		else
			NumText = Utils.FormatNumber(NumText, true)
		end
		DebugPrint("MvpData", PlayerIndex, Players[PlayerIndex][1].DataName, NumText)
		return {["Textmap"] = self.SwitchBattleDataTypeToText[Players[PlayerIndex][1].DataName], ["Value"] = NumText, ["IsPercent"] = (Players[PlayerIndex][1].DataName == "Damage" or Players[PlayerIndex][1].DataName == "Damaged")}
	end
end

function BP_EMGameInstance_C:CalcPlayersMVPData()
    if not self.LevelDataPriority then
        local LevelEnterData = DataMgr.LevelEnterData
        self.LevelDataPriority = {}
        for key, value in pairs(LevelEnterData) do
            local LevelData = {}
            LevelData.Name = key
            LevelData.Priority = value.Priority
            table.insert(self.LevelDataPriority, LevelData)
        end
    end

    table.sort(self.LevelDataPriority, function(a, b)
        return a.Priority < b.Priority
    end)

    local Players = {
        [1] = {},
        [2] = {},
        [3] = {},
        [4] = {},
    }

    local AllPlayerBattleData = {}
    for index, value in ipairs(self.LevelDataPriority) do
        table.insert(AllPlayerBattleData, {[value.Name] = {}})
    end
    -- local AllPlayerBattleData = {
    --     [1] = {Damage = {}},--伤害排名
    --     [2] = {Kill = {}},--击杀排名
    --     [3] = {Damaged = {}},--承受伤害排名
    --     [4] = {Heal = {}},--治疗排名
    --     [5] = {DamageSingle = {}},--单次最高伤害排名
    --     [6] = {Destroy = {}},--击破可破碎物排名
    --     [7] = {HitCount = {}},--最高连击数排名
    -- }

    local BattleNameByIndex = {}
    for index, value in ipairs(self.LevelDataPriority) do
        BattleNameByIndex[index] = value.Name
    end
    -- local BattleNameByIndex = {
    --     [1] = "Damage",--伤害
    --     [2] = "Kill",--击杀
    --     [3] = "Damaged",--承受伤害
    --     [4] = "Heal",--治疗
    --     [5] = "DamageSingle",--单次最高伤害
    --     [6] = "Destroy",--击破可破碎物
    --     [7] = "HitCount",--最高连击数
    -- }
    local TeamTotalDamage = 0 --总伤害
    local TeamTotalTakedDamage = 0 
    --目前结算界面中角色的摆放顺序 ScenePlayers的第一位一定是玩家，摆放在2号位，然后其他按下面顺序摆放(废弃，蓝图已按照玩家顺序排列)
    local PlayerOrder = {
        1,2,3,4
    }

    local ScenePlayers = self.ScenePlayers
    local PhantomsData = self.CombatData.PhantomAttrInfos
    local TeammateData = self.CombatData.TeammateDamageInfos or {}
    local TeammateNum = self.CombatData.TeammateNum or 0

    local CurTeammateNum = 0
    local DamageOffset = 0
    TeamTotalDamage = self.CombatData.TotalDamage
    TeamTotalTakedDamage = self.CombatData.TakedDamage

    --自己的魅影
    if PhantomsData then
        for _, PhantomData in pairs(PhantomsData) do
            if PhantomData then
                TeamTotalDamage = TeamTotalDamage + PhantomData.FinalDamage
                TeamTotalTakedDamage = TeamTotalTakedDamage + PhantomData.TakedDamage
            end
        end
    end

    --队友和他的魅影
    if TeammateData then
        for _, Teammate in pairs(TeammateData) do
            if Teammate then
                TeamTotalDamage = TeamTotalDamage + Teammate.FinalDamage -- 队友伤害
                TeamTotalTakedDamage = TeamTotalTakedDamage + Teammate.TakedDamage -- 队友承伤
                -- 队友魅影伤害和承伤
                if Teammate.PhantomAttrInfo then
                    if Teammate.PhantomAttrInfo.FinalDamage > 0 then
                        TeamTotalDamage = TeamTotalDamage + Teammate.PhantomAttrInfo.FinalDamage
                    end
                    if Teammate.PhantomAttrInfo.TakedDamage > 0 then
                        TeamTotalTakedDamage = TeamTotalTakedDamage + Teammate.PhantomAttrInfo.TakedDamage
                    end
                end
            end
        end
    end

    --检测下有几个真人玩家
    local RealPlayerNun = 0
    for CurPlayerIndex, Player in ipairs(ScenePlayers) do
        if Player.IsMainPlayer or (not Player.IsPhantom) then
            RealPlayerNun = RealPlayerNun + 1
        end
    end

    if RealPlayerNun > 1 then
        self.CombatData.IsInOnlineDungeon = true
    else
        self.CombatData.IsInOnlineDungeon = false
    end
    
    if not self.CombatData.IsInOnlineDungeon then 
        --单机
        for CurPlayerIndex, Player in ipairs(ScenePlayers) do
            local PlayerIndex = PlayerOrder[CurPlayerIndex]
            if not Player.IsNPCPhantom then
                --1是玩家
                if Player.IsMainPlayer then
                    AllPlayerBattleData[1].Damage[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = (TeamTotalDamage ~= 0 and math.floor((self.CombatData.TotalDamage/TeamTotalDamage)*100 + 0.5)) or 0}
                    AllPlayerBattleData[2].Kill[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = self.CombatData.TotalKill}
                    AllPlayerBattleData[3].Damaged[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = (TeamTotalTakedDamage ~= 0 and math.floor((self.CombatData.TakedDamage/TeamTotalTakedDamage)*100 + 0.5)) or 0}
                    AllPlayerBattleData[4].Heal[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = self.CombatData.GiveHealing}
                    AllPlayerBattleData[5].DamageSingle[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = self.CombatData.MaxDamage}
                    AllPlayerBattleData[6].Destroy[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = self.CombatData.BreakableItemCount}
                    AllPlayerBattleData[7].HitCount[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = self.CombatData.MaxComboCount}
                elseif PhantomsData and #PhantomsData > 0 then
                    local PhantomData = self:GetPhantomInfo(Player.RoleId, PhantomsData, Player.IsMainPlayerPhantom)
                    if PhantomData then
                        AllPlayerBattleData[1].Damage[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = (TeamTotalDamage ~= 0 and math.floor(PhantomData.FinalDamage/TeamTotalDamage*100 + 0.5)) or 0}
                        AllPlayerBattleData[2].Kill[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = PhantomData.TotalKillCount}
                        AllPlayerBattleData[3].Damaged[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = (TeamTotalTakedDamage ~= 0 and math.floor(PhantomData.TakedDamage/TeamTotalTakedDamage*100 + 0.5)) or 0}
                        AllPlayerBattleData[4].Heal[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = PhantomData.GiveHealing}
                        AllPlayerBattleData[5].DamageSingle[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = PhantomData.MaxDamage}
                    end
                end
            end
        end
    else
        --联机
        for CurPlayerIndex, Player in ipairs(ScenePlayers) do
            local PlayerIndex = PlayerOrder[CurPlayerIndex]
            if not Player.IsNPCPhantom then
                if Player.IsMainPlayer then
                    AllPlayerBattleData[1].Damage[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = (TeamTotalDamage ~= 0 and math.floor((self.CombatData.TotalDamage/TeamTotalDamage)*100 + 0.5)) or 0}
                    AllPlayerBattleData[2].Kill[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = self.CombatData.TotalKill}
                    AllPlayerBattleData[3].Damaged[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = (TeamTotalTakedDamage ~= 0 and math.floor((self.CombatData.TakedDamage/TeamTotalTakedDamage)*100 + 0.5)) or 0}
                    AllPlayerBattleData[4].Heal[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = self.CombatData.GiveHealing}
                    AllPlayerBattleData[5].DamageSingle[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = self.CombatData.MaxDamage}
                    AllPlayerBattleData[6].Destroy[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = self.CombatData.BreakableItemCount}
                    AllPlayerBattleData[7].HitCount[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = self.CombatData.MaxComboCount}
                else
                    if not Player.IsPhantom then
                        CurTeammateNum = CurTeammateNum + 1
                        local Teammate = TeammateData[CurTeammateNum]
                        if Teammate then
                            AllPlayerBattleData[1].Damage[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = (TeamTotalDamage ~= 0 and math.floor((Teammate.FinalDamage/TeamTotalDamage)*100 + 0.5))or 0}
                            AllPlayerBattleData[2].Kill[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = Teammate.TotalKillCount}
                            AllPlayerBattleData[3].Damaged[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = (TeamTotalTakedDamage ~= 0 and math.floor((Teammate.TakedDamage /TeamTotalTakedDamage)*100 + 0.5)) or 0}
                            AllPlayerBattleData[4].Heal[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = Teammate.GiveHealing}
                            AllPlayerBattleData[5].DamageSingle[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = Teammate.MaxDamage}
                            AllPlayerBattleData[6].Destroy[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = Teammate.BreakableItemCount}
                            AllPlayerBattleData[7].HitCount[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = Teammate.MaxComboCount}
                        end
                    else
                        --找自己身上的魅影数据
                        local Phantom = self:GetPhantomInfo(Player.RoleId, PhantomsData, Player.IsMainPlayerPhantom)
                        if Phantom then
                            AllPlayerBattleData[1].Damage[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = (TeamTotalDamage ~= 0 and math.floor(Phantom.FinalDamage/TeamTotalDamage*100 + 0.5)) or 0}
                            AllPlayerBattleData[2].Kill[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = Phantom.TotalKillCount}
                            AllPlayerBattleData[3].Damaged[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = (TeamTotalTakedDamage ~= 0 and math.floor(Phantom.TakedDamage/TeamTotalTakedDamage*100 + 0.5)) or 0}
                            AllPlayerBattleData[4].Heal[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = Phantom.GiveHealing}
                            AllPlayerBattleData[5].DamageSingle[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = Phantom.MaxDamage}
                        else --自己身上没魅影说明是队友的魅影
                            --目前队友要有魅影只能是2人联机，所以队友只会有一个
                            local TeammatePhantomData = TeammateData[1] and TeammateData[1].PhantomAttrInfo
                            if TeammatePhantomData then
                                AllPlayerBattleData[1].Damage[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = (TeamTotalDamage ~= 0 and math.floor(TeammatePhantomData.FinalDamage/TeamTotalDamage*100 + 0.5)) or 0}
                                AllPlayerBattleData[2].Kill[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = TeammatePhantomData.TotalKillCount}
                                AllPlayerBattleData[3].Damaged[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = (TeamTotalTakedDamage ~= 0 and math.floor(TeammatePhantomData.TakedDamage / TeamTotalTakedDamage*100 + 0.5)) or 0}
                                AllPlayerBattleData[4].Heal[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = TeammatePhantomData.GiveHealing}
                                AllPlayerBattleData[5].DamageSingle[CurPlayerIndex] = {PlayerIndex = PlayerIndex,Value = TeammatePhantomData.MaxDamage}
                            end
                        end
                    end
                end
            end
            
        end
    end

    for Index, Data in ipairs(AllPlayerBattleData) do
        -- 提取当前需要排序的数组和排序依据的字段名
        local key = BattleNameByIndex[Index]
        local targetArray = Data[key]
        -- 确保数组存在再进行排序
        if targetArray and #targetArray > 1 then
            table.sort(targetArray, function(a, b)
                -- 直接比较元素的 Value 字段（降序）
                if not a then
                    return false
                end
                if not b then
                    return true
                end
                return a.Value > b.Value
            end)
        end
    end

    --处理一下伤害百分比偏差
    for index, value in ipairs(AllPlayerBattleData[1].Damage) do
        DamageOffset = DamageOffset + value.Value
    end
    if DamageOffset > 0 then
        DamageOffset = 100 - DamageOffset
        AllPlayerBattleData[1].Damage[1].Value = AllPlayerBattleData[1].Damage[1].Value + DamageOffset
    end

    local AlreadyRankedType = {
        ["Damage"] = false,--伤害
        ["Kill"] = false,--击杀
        ["Damaged"] = false,--承受伤害
        ["Heal"] = false,--治疗
        ["DamageSingle"] = false,--单次最高伤害
        ["Destroy"] = false,--击破可破碎物
        ["HitCount"] = false,--最高连击数
    }

    for i = 1, #ScenePlayers do
        for Index, BattleData in ipairs(AllPlayerBattleData) do
            local DataType = BattleNameByIndex[Index]
            local PlayerData = BattleData[DataType][i]
            if not AlreadyRankedType[DataType] and PlayerData and PlayerData.Value ~= 0 then
                --table.insert(Players[PlayerData.PlayerIndex], {DataName = BattleNameByIndex[Index], Value = PlayerData.Value})
                Players[PlayerData.PlayerIndex][#Players[PlayerData.PlayerIndex] + 1] = {DataName = BattleNameByIndex[Index], Value = PlayerData.Value}
                AlreadyRankedType[DataType] = true
                DebugPrint("thy   PlayersCompensateTip", PlayerData.PlayerIndex, BattleNameByIndex[Index], PlayerData.Value)
            end
        end
    end

    --检查玩家表是否有数据，没有数据直接加入一个伤害的标签
    for i = 1, #ScenePlayers do
        if Players[PlayerOrder[i]] and #Players[PlayerOrder[i]] == 0 then
            table.insert(Players[PlayerOrder[i]], {DataName = "Damage", Value = self:GetDamageData(PlayerOrder[i], AllPlayerBattleData[1].Damage)})
        end
    end

	--获取玩家姓名和Uid
    for i = 1, #ScenePlayers do
        if Players[PlayerOrder[i]] and (not ScenePlayers[i].IsPhantom) then
			Players[PlayerOrder[i]][1].PlayerName = ScenePlayers[i].ScenePlayerName
			Players[PlayerOrder[i]][1].Uid = ScenePlayers[i].Uid
        end
    end

    local LevelEnterData = DataMgr.LevelEnterData
    self.SwitchBattleDataTypeToText = {
        ["Damage"] = LevelEnterData["Damage"].HighLightName,--伤害
        ["Kill"] = LevelEnterData["Kill"].HighLightName,--击杀
        ["Damaged"] = LevelEnterData["Damaged"].HighLightName,--承受伤害
        ["Heal"] = LevelEnterData["Heal"].HighLightName,--治疗
        ["DamageSingle"] = LevelEnterData["DamageSingle"].HighLightName,--单次最高伤害
        ["Destroy"] = LevelEnterData["Destroy"].HighLightName,--击破可破碎物
        ["HitCount"] = LevelEnterData["HitCount"].HighLightName,--最高连击数
    }

    return Players
end

function BP_EMGameInstance_C:GetPhantomInfo(PlayerRoleId, PhantomsData, IsMainPlayerPhantom)
    if IsMainPlayerPhantom then
        for _, value in pairs(PhantomsData) do
            if PlayerRoleId == value.PhantomRoleId then
                return value
            end
        end
    end
    return nil
end

function BP_EMGameInstance_C:GetDamageData(PlayerIndex, PlayerDamageData)
    for Index, value in ipairs(PlayerDamageData) do
        if PlayerIndex == value.PlayerIndex then
            return value.Value
        end
    end
    return 0
end

function BP_EMGameInstance_C:SimulateMovementDebugPlatform()
	if Const.SimulateMovementDebugPlatform == "Android" 
	or Const.SimulateMovementDebugPlatform == "Windows" 
	or Const.SimulateMovementDebugPlatform == "IOS" 
	or Const.SimulateMovementDebugPlatform == "Mac"then
		-- DebugPrint("========================Const.SimulateMovementDebugPlatform=====",Const.SimulateMovementDebugPlatform)
		return Const.SimulateMovementDebugPlatform
	end
	local Plat = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
	-- DebugPrint("========================SimulateMovementDebugPlatform==RealPlatform===",Plat)
	return Plat
end

function BP_EMGameInstance_C:DisableLuaMemoryMonitorFromCPP()
	LuaMemoryManager:DisableLuaMemoryMonitor()
end

function BP_EMGameInstance_C:RequestShowPopup(PopupId, Params, ParentWidget)
	if not self.RequestPopupQueue then 
		self.RequestPopupQueue = {}
	end 

	table.insert(self.RequestPopupQueue, {
		PopupId = PopupId, 
		Params = Params, 
		ParentWidget = ParentWidget 
	})

	local TryShowPopup = function()
		DebugPrint("Tianyi@ Try to show popup")
		if not self.RequestPopupQueue then 
			self:RemoveTimer(self.RequestShowPopupTimer)
		end

        if self:CheckCanShowPopup() then 
            DebugPrint("Tianyi@ TryShowPopup")
            self:RemoveTimer(self.RequestShowPopupTimer)
			local UIManager = GWorld.GameInstance:GetGameUIManager()
			for _, PopupRequest in ipairs(self.RequestPopupQueue) do 
				UIManager:ShowCommonPopupUI(PopupRequest.PopupId, PopupRequest.Params, PopupRequest.ParentWidget)
			end
			self.RequestPopupQueue = nil
        end
    end

	if not self.RequestShowPopupTimer then 
        self.RequestShowPopupTimer = self:AddTimer(0.2, TryShowPopup, true)
    end
end

-- 加载界面展示时，延时显示通用弹窗
function BP_EMGameInstance_C:CheckCanShowPopup()
	local LoadingUI = self:GetLoadingUI()
	if LoadingUI then return false end 
	return true
end

function BP_EMGameInstance_C:OnTalkHiddenGameUIChange()
	local Avatar = GWorld:GetAvatar()
	if not Avatar or not Avatar:IsInBigWorld() then
		return
	end

	UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self,function()
		local TalkContext = self:GetTalkContext()
		if not IsValid(TalkContext) or (TalkContext:HasHiddenGameUI()) then return end
		for _, Param in pairs(self.CacheShowRewardUIParams) do
			UIUtils.ShowDungeonRewardUI(table.unpack(Param))
		end
		self.CacheShowRewardUIParams = {}
	end},0.01,false,0)
end

function BP_EMGameInstance_C:OnConditionComplete(ConditionId)
	if DataMgr.ConditionId2ModArchiveId and DataMgr.ConditionId2ModArchiveId[ConditionId] then
		-- 完成了解锁或揭晓图鉴组的条件，更新Mod手册红点
		for _, ModArchiveId in pairs(DataMgr.ConditionId2ModArchiveId[ConditionId]) do
			if ModArchiveId then
				local ModArchiveInfo = DataMgr.ModGuideBookArchive[ModArchiveId]
				if ModArchiveInfo then
					local NewNum = #ModArchiveInfo.ModList
					local ReddotNode = DataMgr.ModGuideBookArchiveTab[ModArchiveInfo.TabId].ReddotNode
					if not ReddotManager.GetTreeNode("ModArchive") then
						ReddotManager.AddNodeEx("ModArchive")
					end
					local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotNode)
					if not CacheDetail then
						CacheDetail = {}
					end
					if not CacheDetail.NewNum then
						CacheDetail.NewNum = 0
					end
					if not CacheDetail.States then
						CacheDetail.States = {}
					end
					for i = 1, #ModArchiveInfo.ModList do
						local ModId = ModArchiveInfo.ModList[i]
						if not CacheDetail.States[ModId] then
							-- 可能在解锁后还没查看，就又达到了揭晓条件，这种情况下不应该重复增加
							CacheDetail.States[ModId] = true
						else
							NewNum = NewNum - 1
						end
					end
					CacheDetail.NewNum = CacheDetail.NewNum + NewNum
					ReddotManager.IncreaseLeafNodeCount(ReddotNode, NewNum, CacheDetail)
				end
			end
		end
	end
end

function BP_EMGameInstance_C:CloseLoadingUI()
	UKismetSystemLibrary.ExecuteConsoleCommand(self,'r.Shadow.ForceCacheUpdate 1',nil)--更新阴影缓存
	UEMGameInstance.SaveDiskBinaryCache()
	self.Overridden.CloseLoadingUI(self)
end

function BP_EMGameInstance_C:HeadUIReady(ObjIdStr, Eid, Location)
	local RegionSyncSubsys = UE4.URegionSyncSubsystem.GetInstance(self)
    if not RegionSyncSubsys then
        print(_G.LogTag, "RegionPlayerInitInfo RegionSyncSubsys is nil")
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        print(_G.LogTag, "RegionPlayerInitInfo Avatar is nil")
        return
    end
    if not Avatar.OtherRoleInfo then
        print(_G.LogTag, "RegionPlayerInitInfo Avatar.TempRoleInfo is nil")
        return
    end
    if not CommonUtils.IsObjIdStr(ObjIdStr) then
        print(_G.LogTag, "RegionPlayerInitInfo ObjId is  not a Legal ObjIdStr")
        return
    end
    local LuaObjId = CommonUtils.Str2ObjId(ObjIdStr)
    local RoleInfo = Avatar.OtherRoleInfo[LuaObjId]
    if not RoleInfo then
        print(_G.LogTag, "RegionPlayerInitInfo RoleInfo is nil")
        return
    end
	RoleInfo.BornState = Const.Bonred
	RoleInfo.CharEid = Eid
	EventManager:FireEvent(EventID.AddRegionIndicatorInfo, Eid, RoleInfo.Uid, Location, LuaObjId)
	EventManager:FireEvent(EventID.OnlineAddOtherPlayer, Eid, RoleInfo.Uid, nil, LuaObjId)
end
function BP_EMGameInstance_C:CreatePlayerCharacterWhileOnlyShowUI(Eid,Transform)
	local Avatar = GWorld:GetAvatar()
	if Eid <= 0 or not Avatar then
		return
	end
	local RoleInfo ={}
	local Info = {}
	local ObjId = nil
	for Id,_Info in pairs(Avatar.OtherRoleInfo or {}) do
		if _Info.CharEid == Eid then
			ObjId = Id
			RoleInfo = _Info
			break
		end
	end

	if not ObjId then
		return
	end

	local Path = '/Game/BluePrints/Char/BP_PlayerCharacter.BP_PlayerCharacter_C'
	local CurrentCharacter = self:GetWorld():SpawnActor(LoadClass(Path), Transform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
	if not CurrentCharacter then return end
	CurrentCharacter.FromOtherWorld = true
	local RegionSyncSubsys = UE4.URegionSyncSubsystem.GetInstance(self)
	if RegionSyncSubsys then
		RegionSyncSubsys:RegisterBornCharWhileOnlyCreateHeadUI(CommonUtils.ObjId2Str(ObjId),CurrentCharacter)
	end
    local Avatar = GWorld:GetAvatar()
    if not Avatar or not Avatar.OtherRoleInfo then
        return
    end
    local RoleInfo = Avatar.OtherRoleInfo[ObjId]
    if not RoleInfo then
        print(_G.LogTag, "RegionPlayerInitInfo RoleInfo is nil")
        return
    end
    CurrentCharacter.CacheInfo = RoleInfo
    if(RoleInfo.AppearanceSuit) then 
        CurrentCharacter.CurrentSkinId = RoleInfo.AppearanceSuit.SkinId
    else 
        CurrentCharacter.CurrentSkinId = RoleInfo.SkinId
    end
    CurrentCharacter.ShadowModelId = RoleInfo.ShadowModelId or 0
	RoleInfo.Eid = Eid
    CurrentCharacter:PreInitInfo(RoleInfo)
    --Should  Already Preload In Other Process
    CurrentCharacter:RegionPlayerPendingInit()
    CurrentCharacter:AddInteractiveComponent()
    RoleInfo.CharEid = CurrentCharacter.Eid
    if(CurrentCharacter.RegionInterComp) then
        CurrentCharacter.RegionInterComp:InitRegionInfo(CurrentCharacter.Eid, ObjId)
    end
    if(CurrentCharacter.RegionInterAddFriendComp) then
        CurrentCharacter.RegionInterAddFriendComp:InitRegionInfo(CurrentCharacter.Eid, ObjId)
    end
    if(CurrentCharacter.RegionInterInviteTeamComp) then
        CurrentCharacter.RegionInterInviteTeamComp:InitRegionInfo(CurrentCharacter.Eid, ObjId)
    end
    if(CurrentCharacter.RegionInterPersonInfoComp) then
        CurrentCharacter.RegionInterPersonInfoComp:InitRegionInfo(CurrentCharacter.Eid, ObjId)
    end
    -- EventManager:FireEvent(EventID.OnlineAddOtherPlayer, CurrentCharacter.Eid, RoleInfo.Uid, CurrentCharacter, LuaObjId)
    EventManager:FireEvent(EventID.AddRegionIndicatorInfo, CurrentCharacter.Eid, RoleInfo.Uid, CurrentCharacter:K2_GetActorLocation(), ObjId)
    CurrentCharacter:RegisterOtherWorldPlayerCharacterToSubSystem()
    if(RoleInfo.IsCrouching) then
        CurrentCharacter:SetCrouch(true)
    else
        CurrentCharacter:SetCrouch(false)
    end

end


function BP_EMGameInstance_C:TeleportToCloestTeleportPoint()
	DebugPrint("============TeleportToCloestTeleportPoint==============",self.TriggerBoxID)
	CommonUtils:TeleportToCloestTeleportPoint(self.TriggerBoxID)
	self.TriggerBoxID = nil
	EventManager:RemoveEvent(EventID.CloseLoading, GWorld.GameInstance)
	EventManager:RemoveEvent(EventID.OnLevelDeliverBlackCurtainEnd, GWorld.GameInstance)
end

function BP_EMGameInstance_C:GetIsOpenCrashSight()
	return  EMCache:Get("IsOpenCrashSight")
end

-- 是否在阵容副本且以预设进入
function BP_EMGameInstance_C:IsInSquadDungeon()
	local DungeonId = self:GetCurrentDungeonId()
	local DungeonData = DataMgr.Dungeon[DungeonId]

	if DungeonData then
		local Avatar = GWorld:GetAvatar()
		local DungeonInfo = Avatar.Dungeons[DungeonId]

		if DungeonInfo then
			DebugPrint("gmy@BP_EMGameInstance_C BP_EMGameInstance_C:IsInSquadDungeon", DungeonData.Squad, DungeonInfo.Squad)
			return DungeonData.Squad and DungeonInfo.Squad ~= 0
		end
	end
	return false
end
---运营埋点需求，全局监听输入设备变化，发送消息
function BP_EMGameInstance_C:SendInputDiviceChangeMessage(CurInputDeviceType, CurInputDeviceName)
    DebugPrint("yklua___@BP_EMGameInstance_C BP_EMGameInstance_C:SendInputDiviceChangeMessage", CurInputDeviceType, CurInputDeviceName)
    
    -- 创建设备类型映射表
    local DeviceTypeMap = {
        [ECommonInputType.MouseAndKeyboard] = "MouseAndKeyboard",
        [ECommonInputType.Gamepad] = "Gamepad",
        [ECommonInputType.Touch] = "Touch",
		[ECommonInputType.Count] = "Count"
    }

    local NewTrack = {
        device_type = DeviceTypeMap[CurInputDeviceType] or "未知设备类型"
    }

    if not DeviceTypeMap[CurInputDeviceType] then
        DebugPrint("yklua 切换设备时无法识别输入设备类型")
    end

    HeroUSDKSubsystem(self):UploadTrackLog_Lua("input_device_change", NewTrack)
end

function BP_EMGameInstance_C:VerifyArraySendTrace(CRC, NewCRC)
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end
	if not self.MemChangeWarning then
		self.MemChangeWarning = true
		local CheatLog = "CRC memory modification"
		Avatar:CallServerMethod("ReportSentimentSDKCheat", CheatLog, 1, 1, {})
		return
	end
end

function BP_EMGameInstance_C:InitFloatVerifyArray()
	local Avatar = GWorld:GetAvatar()
	local AvatarInfo = AvatarUtils:GetDefaultBattleInfo(Avatar)
	if AvatarInfo and AvatarInfo.RoleInfo and AvatarInfo.RoleInfo.ReplaceAttrs and AvatarInfo.RoleInfo.ReplaceAttrs.TotalValues then
		local TotalValues = AvatarInfo.RoleInfo.ReplaceAttrs.TotalValues
		self.FloatVerifyArray:Add(TotalValues.DEF)
		self.FloatVerifyArray:Add(TotalValues.MaxHp)
		self.FloatVerifyArray:Add(TotalValues.SPD)
		self.FloatVerifyArray:Add(TotalValues.MaxES)
		self.FloatVerifyArray:Add(TotalValues.MaxSp)
		self.FloatVerifyArray:Add(TotalValues.SkillEfficiency)
		self.FloatVerifyArray:Add(TotalValues.SkillIntensity)
		self.FloatVerifyArray:Add(TotalValues.SkillSustain)
		self.FloatVerifyArray:Add(TotalValues.SkillRange)
		-- DebugPrint("TotalValues", TotalValues.DEF, TotalValues.MaxHp, TotalValues.SPD, TotalValues.MaxES, TotalValues.MaxSp, TotalValues.SkillEfficiency, TotalValues.SkillIntensity, TotalValues.SkillSustain, TotalValues.SkillRange)
	end
	-- DebugPrintTable(AvatarInfo.RoleInfo, 5)
end

function BP_EMGameInstance_C:UpdatePostProcessMaterial()
	if IsDedicatedServer(self) then
		return
	end
	local WorldSettings = URuntimeCommonFunctionLibrary.GetWorldSettsings(self)
	local NeedClose = WorldSettings and WorldSettings.bClosePostProcessMaterial
	if NeedClose then
		local PlatformName = UGameplayStatics.GetPlatformName()
		local IsPhone = self:GetUseMapPhoneInPC() or (PlatformName == "IOS") or (PlatformName == "Android")
		local IsLowScalabilityLevel = self:GetGameplayScalabilityLevel() <= 1
		local IsLowMemoryDevice = self:IsLowMemoryDevice()
		if IsPhone and (IsLowScalabilityLevel or IsLowMemoryDevice) then
			UKismetSystemLibrary.ExecuteConsoleCommand(self, "r.Mobile.PostProcessMaterial 0")
		else
			UKismetSystemLibrary.ExecuteConsoleCommand(self, "r.Mobile.PostProcessMaterial 1")
		end
	else
		UKismetSystemLibrary.ExecuteConsoleCommand(self, "r.Mobile.PostProcessMaterial 1")
	end
end

function BP_EMGameInstance_C:SetDynamicResolution(Tag, bEnable)
	if not Const.bUseDynamicResolution then
		return
	end
	local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
	if PlatformName == "PC" then
		return
	end
	if UEMGameInstance.IsLowMemoryDevice() then
		return		
	end
	if not rawget(self, "DynamicResolution") then
		if PlatformName == "Android" then
			rawset(self, "DynamicResolution", 
			{
				[1] = { 100, 80, 720 },
				[2] = { 110, 90, 750 },
				[3] = { 150, 100, 810 },
				[4] = { 150, 100, 900 },
				[5] = { 150, 100, 1260 }
			})
		elseif PlatformName == "IOS" then
			rawset(self, "DynamicResolution", 
			{
				[1] = { 75, 75, 0 },
				[2] = { 80, 80, 0 },
				[3] = { 85, 85, 0 },
				[4] = { 90, 90, 0 },
				[5] = { 105, 105, 0 },
			})
		else
			return
		end
	end
	if not rawget(self, "DynamicResolutionTags") then
		rawset(self, "DynamicResolutionTags", {})
	end
	self.DynamicResolutionTags[Tag] = bEnable and true or nil
	if CommonUtils.TableLength(self.DynamicResolutionTags) ~= 0 then
		local CacheName = "MobileResolution"
		local OptionIndex = EMCache:Get(CacheName)
		if OptionIndex == nil then
			local OptionInfo = DataMgr.Option[CacheName]
			OptionIndex = tonumber(OptionInfo.DefaultValue)
		end
		local ResolutionInfo = self.DynamicResolution[OptionIndex]
		if not ResolutionInfo then
			OptionIndex = 5
		end
		ResolutionInfo = self.DynamicResolution[OptionIndex]
		GWorld.GameInstance.SetScreenPercentageLevel(ResolutionInfo[1], ResolutionInfo[2], ResolutionInfo[3])
	else
		SettingUtils.ResetMobileResolution()
	end
end

function BP_EMGameInstance_C:CheckInAutoChessDungeon()
	local CurrentDungeonId = self:GetCurrentDungeonId()
	local DungeonInfo = DataMgr.Dungeon[CurrentDungeonId]
    if DungeonInfo and DungeonInfo.DungeonType == CommonConst.DungeonType.AutoChess then
        return true
    end
	return false
end

function BP_EMGameInstance_C:SetTicketId(TicketId)
       self.TicketId = TicketId
end

function BP_EMGameInstance_C:GetTicketId()
	 if self.TicketId then return self.TicketId end
	 return -1
end

return BP_EMGameInstance_C
