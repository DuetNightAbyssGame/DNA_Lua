
require "UnLua"

local CommonConst = require "CommonConst"
local ItemUtils = require "Utils.ItemUtils"
local CommonUtils = require "Utils.CommonUtils"
local msgpack = require "msgpack_core"
local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
local MiscUtils = require "Utils.MiscUtils"

local BP_EMGameMode_C = Class({
	"BluePrints.Common.TimerMgr",
    "BluePrints.GameMode.Components.AIBattleMgr",
    "BluePrints.GameMode.Components.HardBossComponent",
	"BluePrints.GameMode.Components.AbyssComponent",
    "BluePrints.GameMode.Components.ProgressSnapShotComponent",
    "BluePrints.GameMode.Components.GameModeLogin",
    "BluePrints.GameMode.Components.RewardComponent",
    "BluePrints.GameMode.Components.GameModeEventComponent",
    "BluePrints.GameMode.Components.DungeonObjectComponent",
    "BluePrints.GameMode.Components.RougeLikeComponent",
	"BluePrints.GameMode.Components.GameModeRegionMgr",
	"BluePrints.GameMode.Components.GameModeQuestMgr",
	"BluePrints.GameMode.Components.WalnutComponent",
	"BluePrints.GameMode.Components.TicketComponent",
	"BluePrints.GameMode.Components.RewardGenComponent",
	"BluePrints.GameMode.Components.DungeonDeliveryComponent"
})

BP_EMGameMode_C._components = {

}

-- function BP_EMGameMode_C:GetBattleEid()
-- 	self.LevelGameMode.LastEid = self.LevelGameMode.LastEid + 1;
-- 	return self.LevelGameMode.LastEid;
-- end

function BP_EMGameMode_C:InitGameModeInfo(DungeonId)
	self.PreInitInfo = GWorld.GameInstance:ConsumeGameModePreInitInfo()
	self:SetGameModeBaseInfo(DungeonId)
	self.EMGameState:InitGameStateInfo()
	self.MonsterCacheNum = 10
	self.CacheAvatarToItems = {}
	self.GMMonsterBuff = {}
	self.MiniGameFailedTime = {}
	self.DropRule = {} ---- 用于控制掉落物 那些该生成出来那些
	self:InitFixedCreator()  -- 暂时的一种测试性结构
	self:InitAIBattleMgr()
	self:InitRewardParams()
	self.bEnableMonsterCollisionPush = true	-- 是否开启重叠检查和推怪
	self.NeedToWaitForOthers = false -- 进入这个GameMode是否需要等待其他玩家

	local DSEntity = GWorld:GetDSEntity()
	if DSEntity and DSEntity.bBlock then
		self:BlockEntrance()
	else
		self.bBlock = false -- 招募权限
	end
	self.BattleAvatars = {}
end

--设置
function BP_EMGameMode_C:SetGameModeBaseInfo(DungeonId)
	local Avatar = GWorld:GetAvatar()
	if Avatar and self:IsInRegion() then
		print(_G.LogTag, "Init Region")
		self.DungeonId = -1
		self.RegionId = Avatar:GetSubRegionId2RegionId(Avatar.CurrentRegionId)
		self:UpdateRegionGameModeLevel()
		self.EMGameState:SetGameModeType("Region")
		-- self.RegionSpecialQuest = nil
		self:UpdateQuestArtLevel()
		self.EMGameState.CurDungeonUIParamID = 0
		self:SetGameStatePetRandomDailyCount()
		--注册通过到STL的Actor相关事件
		self:InitSTLMonsterEvent()
	elseif self:IsInDungeon() then
		print(_G.LogTag, "Init Dungeon")
		local DungeonInfo = DataMgr.Dungeon[DungeonId]
		if not DungeonInfo then
			return
		end
		self.DungeonId = DungeonId
		local Level = DungeonInfo.DungeonLevel or 1
		local PreInitGameLevel = self.PreInitInfo and self.PreInitInfo.GameLevel
		if PreInitGameLevel then
			Level = PreInitGameLevel
		end
		self.BattleProgressLevel = DungeonInfo.DungeonFixLevel or 0
		self:SetGameModeLevel(Level)
		self.CommonAlertDisable = DungeonInfo.AlertDisable or self.CommonAlertDisable
		self.EMGameState:SetGameModeType("Blank")
		if DungeonInfo.DungeonType and DungeonInfo.DungeonType ~= "" then
			self.EMGameState:SetGameModeType(DungeonInfo.DungeonType)
			self:InitDungeonObject(DungeonId)
		end
		-- 提前缓存DungeonComponent
		self:InitDungeonComponent()
		if(DungeonInfo.EnableTacmap) then
			self:InitTacMapManager() -- 优先级高
		end
		-- 初始化副本
		self:InitGameModeTypeInfo()
		-- 初始化副本随机事件（宠物、彩蛋怪）
		self:InitEmergencyMonster()
		-- 初始化策划配表赋值蓝图变量
		self:InitBPVars(DungeonInfo)

		if not IsDedicatedServer(self) then
			self:InitDungeonRandomEvent()
		end
	else
		DebugPrint("BP_EMGameMode_C: Warning!!! DungeonId 为", DungeonId)
	end
end

function BP_EMGameMode_C:InitGameModeTypeInfo()
	if not self:CheckGameModeEnable() then
		return
	end
	if self.EMGameState.GameModeType == "Blank" then
		return
	end
	if not self:GetDungeonComponent() then
		return
	end
	local FunName = 'Init'..self.EMGameState.GameModeType..'Component'
	if self:GetDungeonComponent() ~= nil and self:GetDungeonComponent()[FunName] ~= nil then
		self:GetDungeonComponent()[FunName](self:GetDungeonComponent())
	end
end

function BP_EMGameMode_C:InitTacMapManager()
	self.TacMapManager = nil
	if not self:GetLevelLoader() then
		return
	end
	local TacMapManagerClass=LoadClass('/Game/BluePrints/Common/Level/BP_TacmapManagerNew.BP_TacmapManagerNew_C')
	self.TacMapManager=NewObject(TacMapManagerClass, self)
	self.TacMapManager:Init(self.levelLoader)
end

function BP_EMGameMode_C:TryRegisterPlayerToTacmap()
	local DungeonInfo = DataMgr.Dungeon[self.DungeonId]
	if not DungeonInfo or not DungeonInfo.EnableTacmap or not self.TacMapManager then
		return
	end
	for  i = 0, self:GetPlayerNum() -1 do
		local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, i)
		self.TacMapManager:RegisterPlayer(PlayerCharacter, i + 1)
	end
end

function BP_EMGameMode_C:InitSTLMonsterEvent()
	-- 注册静态怪死亡到STL的通知事件，正常无需注册，性能优化减少转发
	self.EMGameState:RegisterGameModeEvent("OnDeadStaticUnit", self, self.OnStaticUnitDeadEvent)
end

function BP_EMGameMode_C:GMInitGameModeInfo(Id)
	self:InitGameModeInfo(Id)
end

function BP_EMGameMode_C:ResetRemainTriggerAlertCD()
	self.RemainTriggerAlertCD = DataMgr.GlobalConstant.GameModeAlertCD.ConstantValue or 30
end

function BP_EMGameMode_C:ReceiveBeginPlay()
	-- self.Overridden.ReceiveBeginPlay(self)
	-- 由于一部分初始化在C++内，所以lua初始化移到InitGameModeInfo，请慎重考虑时序问题后在此添加
	self.LevelGameMode = UE4.UGameplayStatics.GetGameMode(self)
	if self:IsSubGameMode() then
		return
	end
	self:SetActorTickInterval(1.0)
	self:AIBattleMgrReceiveBeginPlay()
	self:BindTalkSubsystem()

	self.GameModeIndex = GWorld:AddGameMode(self)
end

function BP_EMGameMode_C:NewAuthorityGameMode_BeginPlay_Lua()
	self:SetActorTickInterval(1.0)
	self:AIBattleMgrReceiveBeginPlay()
	self:BindTalkSubsystem()

	self.GameModeIndex = GWorld:AddGameMode(self)
end

function BP_EMGameMode_C:ReceiveEndPlay(EndPlayReason)
	if self:IsSubGameMode() then
		return
	end
	-- self:AddDungeonEvent("OnDestroy")
	self.Overridden.ReceiveEndPlay(self, EndPlayReason)
	self.OnDestroyDelegates:Broadcast()
	self:UnbindTalkSubsystem()
	self.EMGameState:RemoveGameModeEvent("OnDeadStaticUnit", self, self.OnStaticUnitDeadEvent)

	GWorld:RemoveGameMode(self.GameModeIndex)
end

function BP_EMGameMode_C:BindTalkSubsystem()
	local TalkSubsystem = USubsystemBlueprintLibrary.GetWorldSubsystem(self, UTalkSubsystem)
	if (not IsValid(TalkSubsystem)) then
		return
	end

	if self.OnGamePauseChanged then
		self.OnGamePauseChanged:Add(TalkSubsystem, TalkSubsystem.OnGamePauseChanged)
	end
end

function BP_EMGameMode_C:UnbindTalkSubsystem()
	local TalkSubsystem = USubsystemBlueprintLibrary.GetWorldSubsystem(self, UTalkSubsystem)
	if (not IsValid(TalkSubsystem)) then
		return
	end

	if self.OnGamePauseChanged then
		self.OnGamePauseChanged:Remove(TalkSubsystem, TalkSubsystem.OnGamePauseChanged)
	end
end

function BP_EMGameMode_C:GetPlayerLevel()
	return GWorld:GetAvatar() and GWorld:GetAvatar().Level or 0;
end

-- function BP_EMGameMode_C:UpdateRegionGameModeLevel()
-- 	if self:IsInRegion() then
-- 		if not GWorld:GetAvatar() then
-- 			self:SetGameModeLevel(1)
-- 			return
-- 		end
-- 		local RegionLevelInfo = DataMgr.RegionLevel[GWorld:GetAvatar().Level]
-- 		if not RegionLevelInfo then
-- 			self:SetGameModeLevel(1)
-- 			DebugPrint("RegionLevel 缺少当前玩家等级对应得RegionLevel  Now Avatar Level:", GWorld:GetAvatar().Level)
-- 			return
-- 		end
-- 		local Level = DataMgr.RegionLevel[GWorld:GetAvatar().Level].RegionLevel or 1
-- 		self:SetGameModeLevel(Level)
-- 	end
-- end

-- GameMode中实际生成的PlayerCharacter数量
-- function BP_EMGameMode_C:GetPlayerNum()
-- 	return self.LevelGameMode.PlayerNumber
-- end

-- function BP_EMGameMode_C:GetOneRandomPlayer()
-- 	local AllPlayers, AlivePlayers = {}, {}
-- 	for _, Player in pairs(self:GetAllPlayer()) do
-- 		table.insert(AllPlayers, Player)
-- 		if Player:IsDead() == false then
-- 			table.insert(AlivePlayers, Player)
-- 		end
-- 	end
-- 	if #AlivePlayers > 0 then
-- 		return AlivePlayers[math.random(1, #AlivePlayers)]
-- 	end
-- 	return AllPlayers[math.random(1, #AllPlayers)]
-- end

-- GameMode中注册的Avatar有多少
function BP_EMGameMode_C:GetTargetPlayerNum()
	return CommonUtils.Size(self.AvatarInfos)
end

function BP_EMGameMode_C:ReceiveTick(DeltaSeconds)
	self:TickAIBattleMgr(DeltaSeconds)
	self:TickGenReward(DeltaSeconds)
end


function BP_EMGameMode_C:GetAlreadyInit()
	return self.AlreadyInit
end


-------------------- 区域特殊任务的类型指定 ------------------------
-- 可能由子GameMode调用
-- RegionSpecialQuest 应只存在于主GameMode上
function BP_EMGameMode_C:SetRegionSpecialQuest(Value, UIParamID)
	assert(self:IsInRegion(), "SetRegionSpecialQuest 只能在区域内调用")

	self.EMGameState.CurDungeonUIParamID = UIParamID

	local TypeName = ERegionSpecialQuestType:GetNameByValue(Value)
	self:InitRegionDungeonComponent(TypeName)
	self.LevelGameMode:InitRegionSpecialQuestGameModeComponent()

	self.EMGameState:SetDungeonUIState(Const.EDungeonUIState.None)
	self.EMGameState:LoadDungeonUI(TypeName)
	DebugPrint("SetRegionSpecialQuest 特殊任务GameModeComponent初始化 特殊任务:", TypeName)
end

function BP_EMGameMode_C:ResetRegionSpecialQuest()
	DebugPrint("ResetRegionSpecialQuest 特殊任务GameModeComponent重置 特殊任务:", self.LevelGameMode.RegionSpecialQuest)
	self.EMGameState:UnloadDungeonUI(self.LevelGameMode.RegionSpecialQuest)
	self.LevelGameMode:ClearRegionSpecialQuestGameModeComponent()
	self:ClearRegionDungeonComponent()

	self.EMGameState.CurDungeonUIParamID = 0
end

function BP_EMGameMode_C:InitRegionSpecialQuestGameModeComponent()
	if self.RegionSpecialQuest == nil then
		return
	end
	local FunName = 'Init'..self.RegionSpecialQuest..'Component'
	self:TriggerDungeonComponentFun(FunName)
end

function BP_EMGameMode_C:ClearRegionSpecialQuestGameModeComponent()
	if self.RegionSpecialQuest == nil then
		return
	end
	local FunName = 'Clear'..self.RegionSpecialQuest..'Component'
	self:TriggerDungeonComponentFun(FunName)
end

function BP_EMGameMode_C:ShowTrialTask(TaskIndex)
	self:TriggerDungeonComponentFun("ShowTrialTask", TaskIndex)
end
--------------------------------------------------------------------

-------------------- GameMode 流程&事件相关 ------------------------
function BP_EMGameMode_C:OnInit()
	if not self:CheckGameModeEnable() then
		return
	end
	if self:IsSubGameMode() then 
		return 
	end
	self:RegionOnInit()
	DebugPrint("GameMode进行激活 OnInit")
	GWorld:DSBLog("Info", "GameMode:OnInit", "GameMode")
	self:AddDungeonEvent("OnInit")
	self.AlreadyInit = true -- 标记GameMode已经开始副本流程，后续进入的玩家都走中途加入的逻辑
	if IsDedicatedServer(self) then
		-- 本地服额外设置
		GWorld.GameInstance:SetFixedFrameRate(20)
	end
	-- 注册Tacmap
	self:TryRegisterPlayerToTacmap()
	self.CharExpGetInBattle = 0
	if (self:IsInDungeon() and self:NeedProgressRecover()) then
		-- 初始化蓝图拖进去的Actor
		self:InitBPBornActor()

		self:TriggerProgressRecover()
	else
		-- 蓝图初始化
		self:InitDungeonBaseInfo()
		local Avatar = GWorld:GetAvatar()
		if Avatar then
			local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"
			TaskUtils:UpdatePlayerSubRegionIdInfo(Avatar.CurrentRegionId)
			Avatar:CombineAddRegionData(true)
			self:AddTimer(0.1,function()--保底做关闭
				local Avatar1 = GWorld:GetAvatar()
				if Avatar1 and Avatar1.CombineAdd and self:IsInRegion() then
					Avatar1:CombineAddRegionData(false)
				end
			end)
		end

		-- 初始化蓝图拖进去的Actor
		self:InitBPBornActor()
		-- 初始化定制的Actor, 捕获撤离点，群落点
		self:InitCustomActor()
		-- 初始化AutoActive的静态点
		self:InitAutoActiveStaticCreator()
		if Avatar and self:IsInRegion() then
			Avatar:CombineAddRegionData(false)
		end
		self.Overridden.OnInit(self)
	end
	if self:IsInDungeon() and self.DungeonId and self.DungeonId > 0 then
		self:SetDungeonBGMState(0)
		self:NotifyServerOnInit()
	end
	self.OnInitDelegates:Broadcast()
	ClientEventUtils:ClearCurrentDoingDynamicEvent(true,true)
    if self.EMGameState then
        self.EMGameState:CheckPreloadRecordData_Lua()
    end
	-- if self:GetRegionDataMgrSubSystem() then
	-- 	self:GetRegionDataMgrSubSystem():PostInit()
	-- end
end

function BP_EMGameMode_C:InitDungeonBaseInfo()
	-- 初始化各个副本开始后的定制化的数据
	if self:IsSubGameMode() or self:IsInRegion() then
		return
	end
	if self.EMGameState.GameModeType == "Blank" then
		return
	end
	if not self:GetDungeonComponent() then		-- 不希望结算的临时场景初始化走玩法相关逻辑。（可以试试用OptionsString判断，有空看看
		return
	end
	local FunName = 'Init'..self.EMGameState.GameModeType..'BaseInfo'
    if self:GetDungeonComponent() ~= nil and self:GetDungeonComponent()[FunName] ~= nil then
        self:GetDungeonComponent()[FunName](self:GetDungeonComponent())
   	end
end


function BP_EMGameMode_C:RegionOnInit()
	if self:IsInRegion() then 
		-- 区域尝试恢复BpBorn + 生成的Actor
		local Avatar = GWorld:GetAvatar()
		if Avatar then
			Avatar:HandleTryInitRegionInfo()
		end
		if not self.EMGameState:RegionNeedPreCreateUnit() then
			self:GetRegionDataMgrSubSystem():OnInitRecoverRegionData(false)
		end
	end
end

-- function BP_EMGameMode_C:CreateUnit(Info)
-- 	self.EMGameState.EventMgr:CreateUnit(Info)
-- end

function BP_EMGameMode_C:OnQuestComplete(QuestChainId, QuestId)
	self.Overridden.OnQuestComplete(self, QuestChainId, QuestId)
	local Components = self:K2_GetComponentsByClass(UAfterQuestFinishEventComponent.StaticClass())
	for _, Component in pairs(Components:ToTable()) do
		if Component.QuestId == QuestId then
			Component.AfterQuestFinish:Broadcast()
		end
	end
end

function BP_EMGameMode_C:TriggerOnQuestCompleteComponent()
	local Components = self:K2_GetComponentsByClass(UAfterQuestFinishEventComponent.StaticClass())
	local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
	for _, Component in pairs(Components:ToTable()) do
		if Avatar:IsQuestFinished(Component.QuestId) or Avatar:IsQuestAssumeFinished(Component.QuestId) then
			Component.AfterQuestFinish:Broadcast()
		end
	end
end

function BP_EMGameMode_C:OnBigWorldActive()
	-- 子GameMode调用
	self.Overridden.OnBigWorldActive(self)
	self:TriggerOnQuestCompleteComponent()
end

function BP_EMGameMode_C:MainGameModeOnBigWorldActive()
	-- 主GameMode调用
	if self:IsSubGameMode() then return end
	local Avatar = GWorld:GetAvatar()
	local ActiveExploreInfo = {}
	for _, ExploreGroup in pairs( self.EMGameState.ExploreGroupMap:ToTable()) do
		repeat
			if ExploreGroup.AutoActive then
				local SubRegionId = self:GetRegionIdByLocation(ExploreGroup:K2_GetActorLocation())
				local ExploreId = ExploreGroup:GetExploreGroupId()
				if not DataMgr.SubRegion[SubRegionId] then
					GWorld.logger.error("ZJT_ 哦我的上帝，这里有一个探索组" ..ExploreId.."被丢弃在区域外"..SubRegionId.."找不到它所在的区域")
					break
				end
				if ActiveExploreInfo[ExploreGroup:GetExploreGroupId()] then 
					GWorld.logger.error("ZJT_ 哦我的上帝，这里有一个探索组居然重复掉了" ..ExploreId..":SubRegionId:"..SubRegionId.."所在的区域")
					break
				end
				local Explore = Avatar.Explores[ExploreId] 
				if Explore then
					if Explore:IsDoing() then
						if Explore.RegionId ~= SubRegionId then 
							GWorld.logger.error("ZJT_ 哦我的上帝，这里有一个探索组居然重复掉了 不同区域: " ..ExploreId..": 本次激活 SubRegionId:"..SubRegionId.."所在的区域".."上次激活："..Explore.RegionId.." 所在区域！")
						end
					elseif Explore:IsInActive() then
						ActiveExploreInfo[ExploreId] = SubRegionId
					end
				else
					ActiveExploreInfo[ExploreId] = SubRegionId
				end
				ExploreGroup:InitSetExploreGroupStatus_Active()
			end
		until true
	end
	if Avatar then
		Avatar:ExploreIdsActive(ActiveExploreInfo)
	end
	self:TriggerOnQuestCompleteComponent()
end

function BP_EMGameMode_C:OnBattle()
	if not self:IsSubGameMode() then
		self.OnBattleDelegates:Broadcast()
		self:TriggerDungeonComponentFun("OnBattle")
		-- self:AddDungeonEvent("OnBattle")
	end
	self.Overridden.OnBattle(self)
end

function BP_EMGameMode_C:OnPlayerEnter(Eid)
	if not self:IsSubGameMode() then
		if Eid > 0 then
			self:TriggerDungeonComponentFun("OnPlayerEnter", Eid)
		end
	end
	self.Overridden.OnPlayerEnter(self, Eid)
end

function BP_EMGameMode_C:OnPause()
	if not self:IsSubGameMode() then
		self.OnPauseDelegates:Broadcast()
		-- self:AddDungeonEvent("OnPause")
	end
	self.Overridden.OnPause(self)
end

function BP_EMGameMode_C:OnAlert()
	if not self:IsSubGameMode() then
		self.OnAlertDelegates:Broadcast()
		-- self:AddDungeonEvent("OnAlert")
	end
	self.Overridden.OnAlert(self)
end

function BP_EMGameMode_C:OnEnterCommonAlert()
	if not self:IsSubGameMode() then
		self.OnEnterCommonAlertDelegates:Broadcast()
		-- self:AddDungeonEvent("OnEnterCommonAlert")
	end
	self.Overridden.OnEnterCommonAlert(self)
end

function BP_EMGameMode_C:OnExitCommonAlert()
	if not self:IsSubGameMode() then
		self.OnExitCommonAlertDelegates:Broadcast()
		-- self:AddDungeonEvent("OnExitCommonAlert")
	end
	self.Overridden.OnExitCommonAlert(self)
end

function BP_EMGameMode_C:OnResumeBattleEntities()
	if not self:IsSubGameMode() then
		self.OnResumeBattleEntitiesDelegates:Broadcast()
	end
	self.Overridden.OnResumeBattleEntities(self)
end

function BP_EMGameMode_C:OnPauseBattleEntities(Reason)
	if not self:IsSubGameMode() then
		self.OnPauseBattleEntitiesDelegates:Broadcast()
	end
	self.Overridden.OnPauseBattleEntities(self, Reason)
end

function BP_EMGameMode_C:OnBossDead(Monster)
	self.Overridden.OnBossDead(self, Monster)
	self:TriggerBPGameModeEvent("OnBossDead", Monster)
end

function BP_EMGameMode_C:OnEnd(Result)
	if not self:IsSubGameMode() then
		self.OnEndDelegates:Broadcast(Result)
		self.EMGameState:ClearGuideEid()
		-- self:AddDungeonEvent("OnEnd")
		local FunName = 'Trigger'..self.EMGameState.GameModeType..'OnEnd'
    	self:TriggerDungeonComponentFun(FunName)

		self:RemoveDungeonEvent("OnInit")

		-- 原OnDungeonEnd迁移至此
		self.CharExpGetInBattle = 0
		for _, PlayerCharacter in pairs(self:GetAllPlayer()) do
			-- PlayerCharacter:RawRemoveAllBuff()
			local NextRecoveryState = PlayerCharacter:IsDead() and UE4.ETeamRecoveryState.RealDead or UE4.ETeamRecoveryState.Alive
			PlayerCharacter:HandleRemoveModPassives()
			PlayerCharacter:TryLeaveDying(NextRecoveryState)  -- TODO: Tianyi@ 游戏结束时停止自救，临时加一下后面看看怎么写更合适
		end
	end 
	self.Overridden.OnEnd(self, Result)
    if self.EMGameState then
        self.EMGameState:CheckPreloadRecordData_Lua()
    end
end

function BP_EMGameMode_C:OnStaticCreatorEvent(EventName, Eid, UnitId, UnitType, CreatorId)
	if not self:IsSubGameMode() then
		self:TriggerDungeonComponentFun("OnStaticCreatorEvent", EventName, Eid, UnitId, UnitType, CreatorId)
	end
	self.Overridden.OnStaticCreatorEvent(self, EventName, Eid, UnitId, UnitType, CreatorId)
end

function BP_EMGameMode_C:OnMechanismStateChange(Mechanism, StateId, LeaveStateId)
	if not self:IsSubGameMode() then
		self:TriggerDungeonComponentFun("OnMechanismStateChange", Mechanism, StateId, LeaveStateId)
	end
	self.Overridden.OnMechanismStateChange(self, Mechanism, StateId, LeaveStateId)
end

-- 怪物死亡通用逻辑，包含静态怪和动态怪
function BP_EMGameMode_C:OnUnitDeadEvent(MonsterC, KillMineRoleEid, KillMineSkillId, DeathReason)
	if not self:IsSubGameMode() then
		self:TriggerDungeonComponentFun("OnUnitDeadEvent", MonsterC, KillMineRoleEid, KillMineSkillId, DeathReason)
		self:TriggerDungeonAchieve("OnMonsterDeadAchieve", MonsterC, -1)
	end
end

-- 静态怪物死亡逻辑 目前仅通知STL
function BP_EMGameMode_C:OnStaticUnitDeadEvent(MonsterC, KillMineRoleEid, KillMineSkillId, DeathReason)
	if self:IsSubGameMode() then
		return
	end

	if MonsterC then
		self:TriggerSTLEvent("OnSTLMonsterdDeath", MonsterC, KillMineRoleEid, KillMineSkillId, DeathReason)
	else
		DebugPrint("BP_EMGameMode_C:OnUnitDestoryEvent 传入的Monster为空！")
	end
end

-- 怪物销毁通用逻辑，包含静态怪和动态怪
function BP_EMGameMode_C:OnUnitDestoryEvent(MonsterC, CombatItemBase, DestroyReason)
	if not self:IsSubGameMode() then
		self:TriggerDungeonComponentFun("OnUnitDestoryEvent", MonsterC, CombatItemBase)
	end

	if MonsterC then
		self:TriggerSTLEvent("OnSTLActorDestroyed", MonsterC, DestroyReason)
	elseif CombatItemBase then
		self:TriggerSTLEvent("OnSTLActorDestroyed", CombatItemBase, DestroyReason)
	else
		DebugPrint("BP_EMGameMode_C:OnUnitDestoryEvent 传入的Monster和CombatItemBase均为空！")
	end
end

function BP_EMGameMode_C:OnCombatPropDeadEvent(CombatProp)
	if not self:IsSubGameMode() then
		self:TriggerDungeonComponentFun("OnCombatPropDeadEvent", CombatProp)
	end
end

function BP_EMGameMode_C:STLPostStaticCreatorEvent(Actor, Info)
	if self:IsInDungeon() then
		return
	end
	if Info.Creator and Actor.RandomCreatorId == 0 and Actor.CreatorId ~= 0 then
		self:TriggerSTLEvent("STLPostStaticCreatorEvent", Actor)
	end
end

function BP_EMGameMode_C:ClearDelayMonster()
	if self:IsInRegion() then
		return
	end
	local EventMgr = self.EMGameState.EventMgr

	EventMgr.FramingCreateUintQueue["Monster"] = {}
	EventMgr.LoadingClassMonsterQueue = {}
end

------- 支持STL 多个KillMonster节点同时监听 -----------------------------------
function BP_EMGameMode_C:STLRegisterKillMonsterNode(KillMonsterNode)
	if not self.KillMonsterNodeMap then
		self.KillMonsterNodeMap = {}
	end

	if _G.next(self.KillMonsterNodeMap) == nil then
		self.EMGameState:RegisterGameModeEvent("OnDead", self, self.STLOnMonsterKilled)
		DebugPrint("KillMonsterNode: 注册OnDead事件")
	end
	self.KillMonsterNodeMap[KillMonsterNode.Key] = KillMonsterNode
	DebugPrint("KillMonsterNode: 注册到GameMode. Key", KillMonsterNode.Key)
end

function BP_EMGameMode_C:STLUnRegisterKillMonsterNode(KillMonsterNodeKey)
	if not self.KillMonsterNodeMap then
		return
	end

	self.KillMonsterNodeMap[KillMonsterNodeKey] = nil
	DebugPrint("KillMonsterNode: 从GameMode移除. Key", KillMonsterNodeKey)
	if _G.next(self.KillMonsterNodeMap) == nil then
		self.EMGameState:RemoveGameModeEvent("OnDead", self, self.STLOnMonsterKilled)
		DebugPrint("KillMonsterNode: 注销OnDead事件")
	end
end

function BP_EMGameMode_C:STLOnMonsterKilled(Monster, KillMineRoleEid, KillMineSkillId, DeathReason)
	if not self.KillMonsterNodeMap then
		return
	end

	local DeepCopy_KillMonsterNodeMap = self:STLTableDeepCopy(self.KillMonsterNodeMap)
	for Key, KillMonsterNode in pairs(DeepCopy_KillMonsterNodeMap) do
		DebugPrint("KillMonsterNode: 怪物被击杀，Node Key", Key)
		KillMonsterNode:OnMonsterKilledByNums(Monster)
	end
end

-- 上面是节点完成方式为数量
-- 下面是节点完成方式为静态点Id
-- Todo: 几乎一样的逻辑，以后可考虑整理合并
function BP_EMGameMode_C:STLRegisterKillMonsterNode_Creator(KillMonsterNode)
	if not self.KillMonsterNodeMap_Creator then
		self.KillMonsterNodeMap_Creator = {}
	end

	if _G.next(self.KillMonsterNodeMap_Creator) == nil then
		self.EMGameState:RegisterGameModeEvent("OnDeadStaticUnit", self, self.STLOnMonsterKilled_Creator)
		DebugPrint("KillMonsterNode_Creator: 注册OnDead事件")
	end
	self.KillMonsterNodeMap_Creator[KillMonsterNode.Key] = KillMonsterNode
	DebugPrint("KillMonsterNode_Creator: 注册到GameMode. Key", KillMonsterNode.Key)
end

function BP_EMGameMode_C:STLUnRegisterKillMonsterNode_Creator(KillMonsterNodeKey)
	if not self.KillMonsterNodeMap_Creator then
		return
	end

	self.KillMonsterNodeMap_Creator[KillMonsterNodeKey] = nil
	DebugPrint("KillMonsterNode_Creator: 从GameMode移除. Key", KillMonsterNodeKey)
	if _G.next(self.KillMonsterNodeMap_Creator) == nil then
		self.EMGameState:RemoveGameModeEvent("OnDeadStaticUnit", self, self.STLOnMonsterKilled_Creator)
		DebugPrint("KillMonsterNode_Creator: 注销OnDead事件")
	end
end

function BP_EMGameMode_C:STLOnMonsterKilled_Creator(Monster, KillMineRoleEid, KillMineSkillId, DeathReason)
	if not self.KillMonsterNodeMap_Creator then
		return
	end

	local DeepCopy_KillMonsterNodeMap_Creator = self:STLTableDeepCopy(self.KillMonsterNodeMap_Creator)
	for Key, KillMonsterNode in pairs(DeepCopy_KillMonsterNodeMap_Creator) do
		DebugPrint("KillMonsterNode_Creator: 怪物被击杀，Node Key", Key)
		KillMonsterNode:OnMonsterKilledByCreatorId(Monster)
	end
end

function BP_EMGameMode_C:STLTableDeepCopy(table)
	local res = {}
	for k, v in pairs(table) do
		res[k] = v
	end
	return res
end
----------------------------------------------------------------------------

function BP_EMGameMode_C:OnCustomEvent(EventName, Channel)
	if not self:IsSubGameMode() then
		self.OnCustomEventDelegates:Broadcast(EventName, Channel)
	end
	self.Overridden.OnCustomEvent(self, EventName, Channel)
	self:TriggerBPGameModeEvent("OnCustomEvent", EventName)
end

function BP_EMGameMode_C:OnTriggerAOIBase(TriggerEventId, TriggerBase, EMActorEid, TriggerType)
	if not self:IsSubGameMode() then
		self:TriggerSTLEvent("OnTriggerAOIBase", TriggerEventId, TriggerBase, EMActorEid, TriggerType)
		-- if TriggerType == "BeginOverlap" then
		-- 	EventManager:FireEvent(EventID.OnEnterTriggerBox, TriggerEventId, TriggerBase, EMActorEid)
		-- elseif TriggerType == "EndOverlap" then
		-- 	EventManager:FireEvent(EventID.OnLeaveTriggerBox, TriggerEventId, TriggerBase, EMActorEid)
		-- end
	end
	self.Overridden.OnTriggerAOIBase(self, TriggerEventId, TriggerBase, EMActorEid, TriggerType)
	self:TriggerBPGameModeEvent("OnTriggerAOIBase", TriggerEventId, TriggerBase, EMActorEid, TriggerType)
end

function BP_EMGameMode_C:ChangeAOITriggerCollision(CreatorIds, IsEnabled)
	for i,v in pairs(CreatorIds) do
		local Creator = self.EMGameState.StaticCreatorMap:Find(v)
		if Creator and Creator.ChildEids:Length() > 0 then
			local Mechanism = Battle(self):GetEntity(Creator.ChildEids[1])
			if Mechanism and Mechanism.CollisionComponent then
				local CollisionType = IsEnabled and ECollisionEnabled.QueryOnly or ECollisionEnabled.NoCollision
				Mechanism.CollisionComponent:SetCollisionEnabled(CollisionType)
			end
		end
	end
end

-------- 上面是委托绑定再广播，针对一些公用事件
-------- 下面是直接广播
function BP_EMGameMode_C:BpAddTimer(TimerHandleName, Time, IsRealTime, Channel)
	DebugPrint("BpTimerDebug: BpAddTimer", TimerHandleName, Time, IsRealTime, Channel)
	self:AddTimer(Time, self.BpOnTimerEnd, false, 0, TimerHandleName, IsRealTime, TimerHandleName)
	-- 移到外面来了，有时ds端有需求获得当前timer经过了多长时间
	self:AddClientTimerStruct(self, TimerHandleName, Time, IsRealTime)
	if Channel == Const.GameModeEventServerClient then
		self:AddDungeonEvent(TimerHandleName)
	end
end

function BP_EMGameMode_C:BpDelTimer(TimerHandleName, IsRealTime, Channel)
	DebugPrint("BpTimerDebug: BpDelTimer", TimerHandleName, IsRealTime, Channel)
	self:RemoveTimer(TimerHandleName, IsRealTime)

	local FuncName = "BpOnTimerDel_"..TimerHandleName
	if self[FuncName] then
		self[FuncName](self)
	end
	self.LevelGameMode:TriggerDungeonComponentFun(FuncName)

	if (TimerHandleName == Const.BattleProgressTimerHandle) and self.BP_BattleProgressComponent then
		self.BP_BattleProgressComponent:OnTimerDel()
	end

	self:RemoveClientTimerStruct(TimerHandleName)
	if Channel == Const.GameModeEventServerClient then
		self:RemoveDungeonEvent(TimerHandleName)
	end
end

-- 重置timer时间，但不触发Add和RemoveDungeonEvent
function BP_EMGameMode_C:BpResetTimer(TimerHandleName, NewTime, IsRealTime, Channel)
	DebugPrint("BpTimerDebug: BpResetTimer", TimerHandleName, NewTime, IsRealTime, Channel)
	self:RemoveTimer(TimerHandleName, IsRealTime)
	self:AddTimer(NewTime, self.BpOnTimerEnd, false, 0, TimerHandleName, IsRealTime, TimerHandleName)
	self:RemoveClientTimerStruct(TimerHandleName)
	if Channel == Const.GameModeEventServerClient then
		self:AddClientTimerStruct(self, TimerHandleName, NewTime, IsRealTime)
	end
end

function BP_EMGameMode_C:BpOnTimerEnd(TimerHandleName)
	DebugPrint("BpTimerDebug: BpOnTimerEnd", TimerHandleName)
	-- 存在一些冗余，待完善
	self.Overridden.BpOnTimerEnd(self, TimerHandleName)
	self:TriggerBPGameModeEvent("BpOnTimerEnd", TimerHandleName)

	local FuncName = "BpOnTimerEnd_"..TimerHandleName
	if self[FuncName] then
		self[FuncName](self)
	end
	self.LevelGameMode:TriggerDungeonComponentFun(FuncName)

	if (TimerHandleName == Const.BattleProgressTimerHandle) and self.BP_BattleProgressComponent then
		self.BP_BattleProgressComponent:OnTimerEnd()
	end

	self:RemoveClientTimerStruct(TimerHandleName)
	self:RemoveDungeonEvent(TimerHandleName)
end

function BP_EMGameMode_C:BpGetRemainTime(TimerHandleName)
    local RawRemainTime = CommonUtils.GetClientTimerStructRemainTime(TimerHandleName)
    if not RawRemainTime then
        return 0
    end
    return RawRemainTime
end

-- function BP_EMGameMode_C:NotifyClientShowDungeonTask(WidgetPath, TexturePath, TextTitle, TextMap, bPlayAnimation)
-- 	self.EMGameState.DungeonUIInfo.WidgetPath = WidgetPath
-- 	self.EMGameState.DungeonUIInfo.TexturePath = TexturePath
-- 	self.EMGameState.DungeonUIInfo.TextTitle = TextTitle
-- 	self.EMGameState.DungeonUIInfo.TextMap = TextMap
-- 	self.EMGameState:MarkDungeonUIInfoAsDirtyData()
-- 	self:AddDungeonEvent("ShowDungeonTask")
-- end

function BP_EMGameMode_C:SetClientDungeonUIState(DungeonUIState)
	local OldState = self.EMGameState.DungeonUIState
	self.EMGameState.DungeonUIState = DungeonUIState
	self.EMGameState:MarkDungeonUIStateAsDirtyData()
	if IsStandAlone(self) and OldState ~= DungeonUIState then
		self.EMGameState:OnRep_DungeonUIState()
	end
end

-- 短暂UI，使用广播
function BP_EMGameMode_C:NotifyClientShowSurvivalProBuffInfo(PathIconList, TextMapList, Duration)
	-- self.EMGameState:MuticastClientShowBuffInfo(PathIconList, TextMapList, Duration)
	self.EMGameState.SurvivalProBuffInfo.PathIconList = PathIconList
	self.EMGameState.SurvivalProBuffInfo.TextMapList = TextMapList
	self.EMGameState.SurvivalProBuffInfo.Duration = Duration
	self.EMGameState:MarkSurvivalProBuffInfoAsDirtyData()
	self:AddDungeonEvent("UpdateSurvivalProBuffInfo")
end

-- 短暂UI，使用广播
function BP_EMGameMode_C:NotifyClientShowDungeonToast(TextMapIndex, Duration, ToastType,ColorEnum)
	self.EMGameState:MulticastClientShowDungeonToast(TextMapIndex, Duration, ToastType,ColorEnum)
	return  TextMapIndex
end

----------------------------------------------------------------
function BP_EMGameMode_C:InitBPBornActor()
	if self.BPBornActor:Num() == 0 then
		return
	end
	for i, v in pairs(self.BPBornActor:ToTable()) do
		if IsValid(v) then
			if UE4.UGameplayStatics.GetGameState(v) and not v.ServerInitSuccess then
				if not v.TryInitActorInfo then 
					DebugPrint("ERROR TryInitActorInfo:", v:GetName())
				else
					v:TryInitActorInfo("OnInit")
				end
			elseif not UE4.UGameplayStatics.GetGameState(v) then
				local Avatar = GWorld:GetAvatar()
				if Avatar then
					local ct = {
						"报错文本:\n\t",
						"机关名称：",v:GetName(),"\n"
					}
					local FinalMsg = table.concat(ct)
					Avatar:SendToFeiShuForRegionMgr(FinalMsg, "BPBorn初始化报错 | 未获取到GameState")
				else
					DebugPrint("Error: InitBPBornActor, NoGameState From This :", v:GetName())
				end
			end
		end
	end

end

function BP_EMGameMode_C:InitCustomActor()
    -- 初始化群落静态点
	for i, ClanManager in pairs(self.EMGameState.ClanManagerMap) do
		ClanManager:InitClan()
	end
end

function BP_EMGameMode_C:InitAutoActiveStaticCreator()
	if self:CheckServerDungeonEnable() then
		return
	end
	self:TriggerActiveStaticCreator(self.EMGameState.AutoActiveStaticIds)
	self:TriggerActiveAutoPrivateStaticCreator()
	self:TriggerFlexibleActiveStaticCreator()
end

function BP_EMGameMode_C:GetIsOpenWroldRegion()
	return GWorld:GetWorldRegionState()
end

-- function BP_EMGameMode_C:IsCanTriggerStaticCreator(StaticCreatorId, QuestChainId)
--     if not GWorld:GetWorldRegionState() then
--         return true
--     end

--     local Avatar = GWorld:GetAvatar()
-- 	if not Avatar then
-- 		return true
-- 	end

-- 	-- 任务链完成了，永远不激活
--     if QuestChainId and QuestChainId > 0 then
--         if Avatar:IsQuestChainFinished(QuestChainId) then
--             DebugPrint("刷新点【" .. tostring(StaticCreatorId) .. "】所属的任务链【" .. tostring(QuestChainId) .. "】已经完成了")
--             return false
--         end
--     end
-- 	--单机模式
--     if IsStandAlone(self) then
--         local RegionDataMgrSubSystem = self:GetRegionDataMgrSubSystem()
-- 		if RegionDataMgrSubSystem and RegionDataMgrSubSystem:IsCretorIdControlByCacheNew(StaticCreatorId) then
-- 			return false
-- 		end
--     end

--     return true
-- end


function BP_EMGameMode_C:IsCanTriggerRandomStaticCreator(RuleId, Id)
	if not GWorld:GetWorldRegionState() then
		return true
	end
	if IsStandAlone(self) then
		local Avatar = GWorld:GetAvatar()
		if Avatar then
			--NewRegionEnable
			if self:GetRegionDataMgrSubSystem():IsRandomIdControlByCacheNew(RuleId, Id) then
				return false
			end
		end
	end
	return true
end

-- 副本中有玩家退出时调用
function BP_EMGameMode_C:OnPlayersDungeonEnd(AvatarEids)
	local function func(AvatarEid)
		local PlayerController = UE4.URuntimeCommonFunctionLibrary.GetPlayerControllerByAvatarEid(GWorld.GameInstance, AvatarEid)
		if PlayerController then 
			local Player = PlayerController:GetMyPawn()
			if Player then
				DebugPrint("Tianyi@ On Player Leave Dungeon")
				Player:RawRemoveAllBuff(true)
				Player:HandleRemoveModPassives()
				Player:ClearSummons(false)
				if self:IsInDungeon() then
					UE4.UPhantomFunctionLibrary.CancelAllPhantomFromOwner(Player, EDestroyReason.PhantomExitDungeon)
					local WCSubSytem = self:GetWCSubSystem()
					if WCSubSytem then
						UBattleFunctionLibrary.AddBuffToTarget(Player, Player, 308, -1, nil, nil, 1)
					end
				end
				local NextRecoveryState = Player:IsDead() and UE4.ETeamRecoveryState.RealDead or UE4.ETeamRecoveryState.Alive
				Player:TryLeaveDying(NextRecoveryState) 
				if not Player:IsDead() then
					Player:ResetIdle() 
				end
				local FunName = 'Trigger'..self.EMGameState.GameModeType..'PlayerDungeonEnd'
        		self:TriggerDungeonComponentFun(FunName, Player)
			end
		end
	end
	
	if AvatarEids and #AvatarEids ~= 0 then
		for _, AvatarEid in ipairs(AvatarEids) do
			func(AvatarEid)
		end
	else 
		for AvatarEid, _ in pairs(self.LevelGameMode.AvatarInfos) do
			func(AvatarEid)
		end
	end
end

-- 已移到OnEnd事件中
-- function BP_EMGameMode_C:OnDungeonEnd(isWin)
-- 	self.CharExpGetInBattle=0
-- 	local entities=self.EMGameState.MonsterMap:ToTable()
-- 	for _,entity in pairs(entities) do
-- 		if entity~=nil and entity.IsMonster and entity:IsMonster() and entity:GetController() then
-- 			entity:GetController():StopBehaviorTree()
-- 		end
-- 	end
-- 	for  i = 0, self:GetPlayerNum() -1 do
-- 		local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, i)
-- 		-- PlayerCharacter:RawRemoveAllBuff()
-- 		PlayerCharacter:HandleRemoveModPassives()
-- 		PlayerCharacter:TryLeaveDying()  -- TODO: Tianyi@ 游戏结束时停止自救，临时加一下后面看看怎么写更合适
-- 	end
-- end

-- function BP_EMGameMode_C:UpdateMonsterSpawnInfo(MonsterSpawnId, UnitId)
-- 	--local MonsterSpawnTable = self.MonsterSpawnMap:ToTable()
-- 	if MonsterSpawnId ~= 0 and UnitId ~= 0 then
-- 		local MonsterSpawn = self.MonsterSpawnMap:FindRef(MonsterSpawnId)
-- 		if (MonsterSpawn and MonsterSpawn.InitSuccess) then
-- 			MonsterSpawn:UpdateMonsterSpawnInfoByUnitId(UnitId)
-- 		end 
-- 	else
-- 		for Id, MonsterSpawn in pairs(self.MonsterSpawnMap) do
-- 			if (MonsterSpawn and MonsterSpawn.InitSuccess) then
-- 				MonsterSpawn:UpdateMonsterSpawnInfo()
-- 			end
-- 		end
-- 	end
-- end

-- function BP_EMGameMode_C:SetPlayerSafeLoction(Eid)
-- 	local Player = Battle(self):GetEntity(Eid)
-- 	if not IsValid(Player) then
-- 		DebugPrint("当前玩家不存在")
-- 		return
-- 	end

-- 	local LevelLoader = self:GetLevelLoader()
-- 	if not LevelLoader then
-- 		DebugPrint("当前 LevelLoader 不存在")
-- 		return
-- 	end
-- 	local MinDis = 99999999999
-- 	local ResFallTrigger = nil
-- 	-- 逻辑向，继续使用GetLevelIdByLocation
-- 	local PlayerLevelId = LevelLoader:GetLevelId(Player)
-- 	for _, FallTrigger in pairs(self.EMGameState.FallTriggersArray) do
-- 		local PlayerFalltriggerDis = Player:GetDistanceTo(FallTrigger)
-- 		local FallTriggerLevelId = LevelLoader:GetLevelIdByLocation(FallTrigger:K2_GetActorLocation())
-- 		if PlayerLevelId == FallTriggerLevelId and PlayerFalltriggerDis < MinDis then
-- 			ResFallTrigger = FallTrigger
-- 			MinDis = PlayerFalltriggerDis
-- 		end
-- 	end

-- 	if ResFallTrigger == nil then
-- 		DebugPrint("当前关卡内找不到合适的 FallTrigger")
-- 		return
-- 	end
-- 	local transformTemp = ResFallTrigger.DefaultTransform:K2_GetComponentToWorld()
-- 	self:TriggerFallingCallable(Player, transformTemp, 0, true)
-- end

function BP_EMGameMode_C:TriggerFallingCallable(OtherActor, DefaultTransform, MaxDis, DefaultEnable, FallTrigger, TriggerFallingScreenColor)
	if not IsValid(OtherActor) then
		return
	end
	--OtherActorType:
	--玩家(PlayerCharacter_C)
	--魅影(PhantomCharacter_C)
	--召唤物(MonsterCharacter_C)
	--捕获怪(MonsterCharacter_C)
	--AI控制(MonsterCharacter_C)
	--掉落道具1(CombatItemBase_C)
	--掉落道具2(PickupBase_C)
	if OtherActor.TriggerFallingCallable then
		--TriggerFallingScreenColor控制屏幕颜色的淡入和淡出，不传参数默认是黑色。目前白屏效果仅PlayerCharacter_C有需求，白屏效果是写死的，持续时间1s，详见1210961
		OtherActor:TriggerFallingCallable(self, DefaultTransform, MaxDis, DefaultEnable, FallTrigger, TriggerFallingScreenColor)
	else
		ScreenPrint(string.format("This OtherActor has not function called TriggerFallingCallable.  ActorName:  %s,  UnitId:  %d,  Eid:  %d,  CreatorId:  %d", OtherActor:GetName() or "nil", OtherActor.UnitId or -1, OtherActor.Eid or -1, OtherActor.CreatorId or -1))
	end
end

function BP_EMGameMode_C:TriggerWaterFallingCallable(OtherActor, DefaultTransform, MaxDis, DefaultEnable)
	if not IsValid(OtherActor) then
		return
	end
	--水面掉落处理类型:
	--玩家(PlayerCharacter_C)
	--魅影(PhantomCharacter_C)
	--怪物(MonsterCharacter_C)
	--捕获怪(MonsterCharacter_C)
	--掉落道具(PickupBase_C)
	--其余不处理
	if OtherActor.TriggerWaterFallingCallable then
		OtherActor:TriggerWaterFallingCallable(self, DefaultTransform, MaxDis, DefaultEnable)
	else
		ScreenPrint(string.format("This OtherActor has not function called TriggerWaterFallingCallable.  ActorName:  %s,  UnitId:  %d,  Eid:  %d,  CreatorId:  %d", OtherActor:GetName() or "nil", OtherActor.UnitId or -1, OtherActor.Eid or -1, OtherActor.CreatorId or -1))
	end
end

-- function BP_EMGameMode_C:TryGetSafeLocation(Player, MaxDis)
-- 	if MaxDis <= 0 then
-- 		return FVector(0,0,0)
-- 	end
-- 	local SafeLocation = Player:GetSafeLocation()
-- 	while SafeLocation ~= FVector(0,0,0) do
-- 		if (Player:K2_GetActorLocation() - SafeLocation):Size() <= MaxDis then
-- 			return SafeLocation
-- 		else 
-- 			SafeLocation = Player:GetSafeLocation()
-- 		end
-- 	end
-- 	return FVector(0,0,0)
-- end

function BP_EMGameMode_C:SpawnDefaultPawnAtTransform(NewPlayer, SpawnTransform)
	DebugPrint("BP_EMGameMode_C:SpawnDefaultPawnAtTransform", SpawnTransform)
	local PawnClass = self:GetDefaultPawnClassForController(NewPlayer)
	local Instigator = self:GetInstigator()
	local DefaultPawn = UE4.URuntimeCommonFunctionLibrary.SpawnDefaultPawn(NewPlayer, PawnClass, SpawnTransform, Instigator)
	return DefaultPawn
end


function BP_EMGameMode_C:GetCurrentQuestId()
	-- local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
	local Avatar = GWorld:GetAvatar()
	local QuestIdArr = UE4.TArray(0)
	if not Avatar  then
		return QuestIdArr
	end
	local Table = Avatar:GetQuestDoing()
	for _,value in pairs(Table) do
		QuestIdArr:Add(value)
	end
	return QuestIdArr
end

function BP_EMGameMode_C:SwitchToQuestRole(QuestRoleID, bPlayFX)
	local Avatar = GWorld:GetAvatar()
	if (Avatar == nil) then
		return
	end

	local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
	PlayerCharacter:RecoverBanSkills()
	local PlayerController = PlayerCharacter:GetController()
	local PlayChangeRoleEffect = function()
		--播放切换角色特效
		PlayerCharacter:ChangeRoleEffect()
	    local BodyType = PlayerCharacter:GetBattleCharBodyType()
	    PlayerCharacter.FXComponent:PlayEffectByIDParams(401, {
	        NotAttached = true,
	        scale = Const.BattleCharTagVXScaleTable[BodyType],
	    })
	end
	if (QuestRoleID == 0) then
		-- 如果传入的是0，表示切换回原来的角色

		local CharacterUuid = Avatar.CurrentChar
		local CharacterID = Avatar.Chars[CharacterUuid].CharId

	    local AvatarInfo = AvatarUtils:GetDefaultBattleInfo(Avatar)

		PlayerCharacter:ChangeRole(CharacterID, AvatarInfo)
		if bPlayFX then
			PlayChangeRoleEffect()
		end
	    if PlayerCharacter.RangedWeapon and PlayerCharacter.RangedWeapon:GetAttr("MagazineBulletNum") == 0 then
	        PlayerCharacter.RangedWeapon:SetWeaponState("NoBullet", true)
	    end
		EventManager:FireEvent(EventID.OnSwitchRole, CharacterUuid)
		return
	end

	local RoleInfo = DataMgr.QuestRoleInfo[QuestRoleID]
	if not RoleInfo then
		local Message = "QuestRoleId不存在"..
        "\n\t在调用SwitchToQuestRole的时候，传入的参数QuestRoleId 【"..tostring(QuestRoleID).."】 在QuestRoleInfo表中不存在，请查阅QuestRoleInfo表格"
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "QuestRoleId不存在", Message)
        return
	end

	local AvatarInfo = AvatarUtils:GetBattleInfoByQuestRoleId(QuestRoleID, Avatar)
	if AvatarInfo.RoleInfo then
		AvatarInfo.RoleInfo.AvatarQuestRoleID = QuestRoleID
	end

	PlayerCharacter:ChangeRole(nil, AvatarInfo)
	if bPlayFX then
		PlayChangeRoleEffect()
	end
    if PlayerCharacter.RangedWeapon and PlayerCharacter.RangedWeapon:GetAttr("MagazineBulletNum") == 0 then
        PlayerCharacter.RangedWeapon:SetWeaponState("NoBullet", true)
    end
	-- PlayerCharacter:RecoverBanSkills()
    -- PlayerCharacter:SetCharacterTag('Interactive')
    -- PlayerCharacter:SetCanInteractiveTrigger(false)
	EventManager:FireEvent(EventID.OnSwitchRole)
end

function BP_EMGameMode_C:SetNpcPatrol(NpcId, PatrolId)
	local NpcPlayerCharacter = self.EMGameState.NpcCharacterMap:Find(NpcId)

	if not IsValid(NpcPlayerCharacter) then
		print(_G.LogTag, "NpcMap no-exist this Npc",NpcId )
		return
	end
	NpcPlayerCharacter.PatrolId = PatrolId

	-- --临时处理多个相同NPC的情况
	-- local NpcCharacterMap = self.EMGameState.NpcCharacterMap:ToTable()
	-- for _, Npc in pairs(NpcCharacterMap) do
	-- 	if IsValid(Npc) and tonumber(NpcId) == tonumber(Npc.UnitId) then
	-- 		Npc.PatrolId = PatrolId
	-- 	end
	-- end
end

function BP_EMGameMode_C:TriggerMechanism(StaticCreatorId, StateId, PrivateEnable, QuestId)
	if PrivateEnable == true and not self:IsSubGameMode() then
		self.EMGameState:ShowDungeonError("TriggerMechanism PrivateEnable is true but IsSubGameMode:"..self:GetName(), Const.DungeonErrorType.GameMode, Const.DungeonErrorTitle.Other)
		return
	end
	local StaticCreator = self.EMGameState:GetStaticCreatorInfo(StaticCreatorId, PrivateEnable, self.LevelName);
	if not IsValid(StaticCreator) then
		return
	end
	local NeedUpdateRegionData = true
	if StaticCreator.ChildEids:Length() >= 2 then
		DebugPrint("Warning: 这个StaticCreator刷新了多个机关", StaticCreator.ChildEids:Length())
	end
	local bCanChange = false
	if StaticCreator.ChildEids:Length() > 0 then
		for i = 1, StaticCreator.ChildEids:Length() do
			local Info = Battle(self):GetEntity(StaticCreator.ChildEids:GetRef(i))
			if IsValid(Info) then
				print(_G.LogTag,"LXZ TriggerMechanism444", Info:GetName())
				if Info:IsCombatItemBase() then
					bCanChange = true
					Info:ChangeState("Manual", 0, StateId)
					if Info.RegionDataType == ERegionDataType.RDT_CommonQuestData then
						Info.QuestId = QuestId
					end
				end
			else		
				local NowStateId = self.EMGameState.MechanismStateIdMap:Find(StaticCreatorId)
				local MechanismStateData = DataMgr.MechanismState[NowStateId]
				if MechanismStateData and MechanismStateData.StateEvent then
					for i, v in pairs(MechanismStateData.StateEvent) do
						if v.NextStateId == StateId and v.TypeNextState.Type == "Manual" then
							bCanChange = true
							break
						end
					end
				end
			end
		end
	elseif StaticCreator.CreatedWorldRegionEid ~= "" then
		local LuaTableIndex, HasData = self:GetRegionDataMgrSubSystem():TryGetLuaDataIndex(StaticCreator.CreatedWorldRegionEid)
		if HasData then
			local NowStateId = self:GetRegionDataMgrSubSystem():GetStateIdByWorldRegionEid(LuaTableIndex)
			if NowStateId == -1 then
				NowStateId = DataMgr.Mechanism[StaticCreator.UnitId].FirstStateId
			end
			local MechanismStateData = DataMgr.MechanismState[NowStateId]
			if MechanismStateData then
				if not MechanismStateData.StateEvent then
					GWorld.logger.error("GameMode切换机关状态，表里未配置切换方式,UnitId:"..StaticCreator.UnitId..",StateId:"..NowStateId)
				end
				for i, v in pairs(MechanismStateData.StateEvent) do
					if v.NextStateId == StateId and v.TypeNextState.Type == "Manual" then
						bCanChange = true
					end
				end
			end
		end
	end
	if StaticCreator.CreatedWorldRegionEid ~= "" and bCanChange then
		self:GetRegionDataMgrSubSystem():ChangeState(StaticCreator.CreatedWorldRegionEid, StateId)
	end
end

function BP_EMGameMode_C:TriggerMechanismArray(StaticCreatorIds, StateId, PrivateEnable, QuestId)
	for i, v in pairs(StaticCreatorIds) do
		self:TriggerMechanism(v, StateId, PrivateEnable, QuestId)
	end
end

function BP_EMGameMode_C:TriggerPetStateChange(StaticCreatorId, TargetState, PrivateEnable)
	if PrivateEnable == true and not self:IsSubGameMode() then
		self.EMGameState:ShowDungeonError("TriggerPetStateChange PrivateEnable is true but IsSubGameMode: " .. self:GetName(), Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.Config)
		return
	end
	local StaticCreator = self.EMGameState:GetStaticCreatorInfo(StaticCreatorId, PrivateEnable, self.LevelName);
	if not IsValid(StaticCreator) then
		self.EMGameState:ShowDungeonError("TriggerPetStateChange Can Not Find StaticCreator: "..StaticCreatorId.." PrivateEnable: ".. PrivateEnable, Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.FindObject)
		return
	end

	for i = 1, StaticCreator.ChildEids:Length() do
		local Info = Battle(self):GetEntity(StaticCreator.ChildEids:GetRef(i))
		if IsValid(Info) and Info:IsPetNpc() then
			Info:SetInteractiveState(TargetState)
		end
	end
end

function BP_EMGameMode_C:PetPlayFailureMontage(StaticCreatorId, PrivateEnable)
	-- local StaticCreator = self.EMGameState:GetStaticCreatorInfo(StaticCreatorId, PrivateEnable, self.LevelName);
	-- if not IsValid(StaticCreator) then
	-- 	print(_G.LogTag,"Error PetPlayFailureMontage Can Not Find StaticCreator:  "..StaticCreatorId, self:GetName())
	-- 	return
	-- end
	-- for i = 1, StaticCreator.ChildEids:Length() do
	-- 	local Info = Battle(self):GetEntity(StaticCreator.ChildEids:GetRef(i))
	-- 	if IsValid(Info) and Info:IsPetNpc() then
	-- 		Info:PlayFailureMontageThenDestroy()
	-- 	end
	-- end
	self.LevelGameMode:AddDungeonEvent("PetPlayFailureMontage")
end

function BP_EMGameMode_C:TriggerPetMechanismState(StateId, PrivateEnable, QuestId)
	if self:IsSubGameMode() then
		self.EMGameState:ShowDungeonError("在子GameMode使用了TriggerPetMechanismState: " .. self:GetName(), Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.Config)
		return
	end
	if not IsValid(self.RandomPetCreator) then
		self.EMGameState:ShowDungeonError("TriggerPetMechanismState RandomPetCreator无效: " .. self:GetName(), Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.Config)
	end
	self:TriggerMechanism(self.RandomPetCreator.StaticCreatorId, StateId, PrivateEnable, QuestId)
end

function BP_EMGameMode_C:TriggerPetStateChangeMain(TargetState, PrivateEnable)
	if self:IsSubGameMode() then
		self.EMGameState:ShowDungeonError("在子GameMode使用了TriggerPetStateChangeMain: " .. self:GetName(), Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.Config)
		return
	end
	if not IsValid(self.RandomPetCreator) then
		self.EMGameState:ShowDungeonError("TriggerPetStateChangeMain RandomPetCreator无效: " .. self:GetName(), Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.Config)
	end
	for i = 1, self.RandomPetCreator.ChildEids:Length() do
		local Info = Battle(self):GetEntity(self.RandomPetCreator.ChildEids:GetRef(i))
		if IsValid(Info) and Info:IsPetNpc() then
			Info:SetInteractiveState(TargetState)
		end
	end
end

function BP_EMGameMode_C:PetPlayFailureMontageMain(PrivateEnable)
	self.LevelGameMode:AddDungeonEvent("PetPlayFailureMontage")
end

function BP_EMGameMode_C:OnTriggerMechanismManualItem(ManualCombatId, ComponentStateId, StateId, QuestId)
	--print(_G.LogTag,"LXZ OnTriggerMechanismManualItem000", ManualCombatId[1], ComponentStateId, QuestId, self:GetName())
	if self:IsSubGameMode() and not self:IsInRegion() then
		return
	end
	for i = 1, ManualCombatId:Length() do
		local CombatItem = self.EMGameState.ManualActiveCombat:Find(ManualCombatId[i])
		if not IsValid(CombatItem) then
			GWorld.logger.error("哦我的上帝，这里有一个ManualItemId"..ManualCombatId[i].."找不到它亲爱的机关实体，亲爱的策划能改一下gamemode配置吗")
		end
		if IsValid(CombatItem) then
			if CombatItem.ChangeToState then
				CombatItem:ChangeToState(StateId)
			end
			if ComponentStateId~=0 then
				CombatItem:ChangeState("Manual", 0, ComponentStateId)
			end
			if CombatItem.RegionDataType == ERegionDataType.RDT_QuestCommonData then
				CombatItem.QuestId = QuestId
			end
		end
	end
end

function BP_EMGameMode_C:OnTriggerMechanismMonsterNest(ManualId, MonsterNum, MonsterSpawnInterval, MonsterUnitIdArr, MonsterUnitType, MonsterPresetTarget, MonsterPresetTargetId)
	if self:IsSubGameMode() then
		return
	end
	for key, value in pairs(ManualId) do
		local CombatItem = self.EMGameState.ManualActiveCombat:Find(value)
		if not IsValid(CombatItem) then
			GWorld.logger.error("哦我的上帝，这里有一个ManualItemId"..ManualId.."找不到它亲爱的机关实体，亲爱的策划能改一下gamemode配置吗")
		end
		CombatItem.MonsterNum = MonsterNum
		CombatItem.MonsterSpawnInterval = MonsterSpawnInterval
		CombatItem.MonsterUnitId = MonsterUnitIdArr
		CombatItem.MonsterUnitType = MonsterUnitType
		CombatItem.MonsterPresetTarget = MonsterPresetTarget
		CombatItem.MonsterPresetTargetId = MonsterPresetTargetId
		DebugPrint("thy      OnTriggerMechanismMonsterNest")
	end
	
end

function BP_EMGameMode_C:GetHLODDistance(ScalabilityLevel)
	if not Const.bOverrideHLODDistance then
		return -1
	end
	local Distance = 5000
	local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
	if PlatformName == "Android" then
		Distance = Const.HLODDistanceAndroid[ScalabilityLevel] or Distance
	else
		Distance = Const.HLODDistanceDefault[ScalabilityLevel] or Distance
	end
	DebugPrint("BP_EMGameMode_C:GetHLODDistance PlatformName: ", PlatformName, "Distance: ", Distance)
	return Distance
end

function BP_EMGameMode_C:OnTriggerDestroyMonsterInMonsterNest(ManualCombatId)
	if self:IsSubGameMode() then
		return
	end
	for i = 1, ManualCombatId:Length() do
		local MonsterNest = self.EMGameState.ManualActiveCombat:Find(ManualCombatId[i])
		if not IsValid(MonsterNest) or not MonsterNest:IsCombatItemBase("MonsterNest") then
			GWorld.logger.error("哦我的上帝，这里有一个ManualItemId"..ManualCombatId[i].."找不到它亲爱的MonsterNest，亲爱的策划能改一下gamemode配置吗")
		end
		if IsValid(MonsterNest) then
			MonsterNest:DestroyAllMonster()
		end
	end
end

function BP_EMGameMode_C:InitBPVars(DungeonInfo)
	if GWorld.GameInstance:IsInTempScene() then
		DebugPrint("BP_EMGameMode_C 结算场景 不初始化策划配表赋值蓝图变量")
		return
	end

	local BPOverrideVars = DungeonInfo.BPOverrideVars
	if not BPOverrideVars then
		return
	end

	for VarName, VarValue in pairs(BPOverrideVars) do
		if self[VarName] ~= nil then
			self[VarName] = VarValue
			DebugPrint("BP_EMGameMode_C 初始化策划配表赋值蓝图变量: ", VarName, VarValue)
		else
			ScreenPrint("BP_EMGameMode_C 初始化策划配表赋值蓝图变量: 不存在的变量 "..VarName)
		end
	end
end

function BP_EMGameMode_C:InitEmergencyMonster()
	self.NeedTreasureMonster = false
	self.TreasureMonsterCreated = false

	self.NeedButcherMonster = false
	self.ButcherMonsterCreated = false

	self.NeedPetMonster = false
	self.PetMonsterCreated = false

	self.TreasureMonsterSpawnInterval = 3
	self.ButcherMonsterSpawnInterval = 5

	self.EmergencyMonsterSpawnLoc = {
		RandomTime = 5,
		MaxDistance = 1000,
		MaxZDistance = 500,
	} 
end

function BP_EMGameMode_C:GetCreateEmergencyMonsterInterval(MonsterType)
	return self[MonsterType.."MonsterSpawnInterval"]
end

function BP_EMGameMode_C:GetNeedCreateEmergencyMonster(MonsterType)
	return self["Need"..MonsterType.."Monster"] == true and self[MonsterType.."MonsterCreated"] == false
end

function BP_EMGameMode_C:InitCreateEmergencyMonsterProb(MonsterType, Component, DungeonInfo)
	if Component == nil then
		DebugPrint("InitCreateEmergencyMonsterProb: GameMode Componet 不存在！")
		return
	end
	if DungeonInfo == nil then
		DebugPrint("InitCreateEmergencyMonsterProb: DungeonInfo 不存在！")
		return
	end
	local ProbabilityInfo = DungeonInfo[MonsterType.."MonsterSpawnProbability"]
	if ProbabilityInfo == nil then
		DebugPrint("InitCreateEmergencyMonsterProb: "..MonsterType.."怪信息不存在！")
		return
	end
	Component["Current"..MonsterType.."MonsterProb"] = ProbabilityInfo[1]
end

function BP_EMGameMode_C:CreateEmergencyMonsterEachWave(MonsterType, Component, DungeonInfo)
	if Component == nil then
		return
	end
	if DungeonInfo == nil then
		return
	end
	local ProbabilityInfo = DungeonInfo[MonsterType.."MonsterSpawnProbability"]
	if ProbabilityInfo == nil then
		return
	end
	local MonsterSpawnMinWave = DungeonInfo[MonsterType.."MonsterSpawnMinWave"]
	if MonsterSpawnMinWave == nil then
		return
	end
	if self:GetNeedCreateEmergencyMonster(MonsterType) == false then
		return
	end
	local WaveIndex = Component:GetWaveIndex()
	if WaveIndex and WaveIndex < MonsterSpawnMinWave then
		return
	end
	local ProbName = "Current"..MonsterType.."MonsterProb"
	if Component[ProbName] == nil then
		return
	end
	if math.random() > Component[ProbName] then
		Component[ProbName] = Component[ProbName] + ProbabilityInfo[2]
		return
	end
	self:TryCreateEmergencyMonster(MonsterType)
end

function BP_EMGameMode_C:TryCreateEmergencyMonster(MonsterType)
	local GameModeData = DataMgr[self.EMGameState.GameModeType]
	if GameModeData == nil then
		return
	end
	local DungeonData = GameModeData[self.DungeonId]
	if DungeonData == nil then
		return
	end
	local SpecialMonsterId = DungeonData[MonsterType.."MonsterId"]
	if SpecialMonsterId == nil then
		return
	end
	local LevelLoader = self.LevelGameMode:GetLevelLoader()
	if LevelLoader == nil then
		return
	end

	local OneRandomPlayer = self:GetOneRandomPlayer()
	if not IsValid(OneRandomPlayer) then
		DebugPrint("TryCreateEmergencyMonster, 玩家不存在, 本次不创建！")
		return
	end
	local PlayerLocation = self:GetOneRandomPlayer().CurrentLocation
	local TargetLocation = UKismetMathLibrary.Vector_Zero()
	local LocationValid = false
	
	for i = 1, self.EmergencyMonsterSpawnLoc.RandomTime do
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
		TargetLocation = self:GetMonsterCustomLoc(nil)
	end
	
	if UKismetMathLibrary.EqualEqual_VectorVector(TargetLocation, UKismetMathLibrary.Vector_Zero(), 0.001) == false then
		local Context = AEventMgr.CreateUnitContext()
		Context.UnitType = "Monster"
		Context.UnitId = SpecialMonsterId
		Context.Loc = TargetLocation
		Context.IntParams:Add("Level", self:GetFixedGamemodeLevel())
		Context.MonsterSpawn = self.LevelGameMode.FixedMonsterSpawn
		self.EMGameState.EventMgr:CreateUnitNew(Context, false)

		self[MonsterType.."MonsterCreated"] = true
	end
end

function BP_EMGameMode_C:OnRandomCreateSpawn( RandomCreateId, StateId)
end

function BP_EMGameMode_C:ShowMessage(MessageId, LastTime)
	local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManger = GameInstance:GetGameUIManager()
    if (UIManger == nil) then
        return
    end

	if (MessageId ~= nil and LastTime ~= nil) then
		local GuideTextPanel = UIManger:GetUIObj("GuideTextFloat")
		-- if (GuideTextPanel == nil) then
		-- 	UIManger:LoadUI(UIConst.GUIDETEXTFLOAT, "GuideTextFloat", UIConst.ZORDER_FOR_COMMON_TIP, MessageId, LastTime)
		-- else
		-- 	GuideTextPanel:AddGuideMessage(MessageId, LastTime)
		-- end
		if (GuideTextPanel == nil) then
			GuideTextPanel = UIManger:LoadUI(UIConst.GUIDETEXTFLOAT, "GuideTextFloat", UIConst.ZORDER_FOR_COMMON_TIP)
		end
		GuideTextPanel:AddGuideMessage(MessageId, LastTime)
	end
end

function BP_EMGameMode_C:HideMessage(MessageId)
	local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManger = GameInstance:GetGameUIManager()
    local GuideTextPanel = UIManger:GetUIObj("GuideTextFloat")
    if (UIManger == nil or GuideTextPanel == nil) then
        return
    end
    GuideTextPanel:DeleteGuideMessage(MessageId)
end

function BP_EMGameMode_C:GetItemType(UnitId)
	if not DataMgr.Mechanism[UnitId] then
		return ""
	end
	local Type = DataMgr.Mechanism[UnitId].UnitRealType
	return Type
end

function BP_EMGameMode_C:UpdateDungeonProgress()
	-- 会放到OnEnd之后做 这个不能要了
	-- if not self.EMGameState:CheckGameModeStateEnable() then
	-- 	DebugPrint("副本状态不正确 触发了UpdateDungeonProgress")
	-- 	return
	-- end

	self.EMGameState:SetDungeonProgress(self.EMGameState.DungeonProgress + 1)
  	DebugPrint ("DungeonProgress 副本轮次 +1，当前轮次:", self.EMGameState.DungeonProgress)
	local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	if  PlayerCharacter and PlayerCharacter.BattleAchievement then
	   PlayerCharacter.BattleAchievement:UpdateTopProcessedValue()
	end
	self:TriggerUploadDungeonAchievement()--无尽中当前轮次结束立马进行一次成就结算
	if IsDedicatedServer(self) then
		if GWorld.bDebugServer then
			return
		end
		-- 联机
		local DSEntity = GWorld:GetDSEntity()
		if DSEntity then
			DSEntity:UpdateDungeonProgress()
		end
	else
		-- 单机
		local ResTable, _Data
		if self:CheckProgressSnapShotEnable() then
			ResTable, _Data = self:GenerateProgressData("OnVoteBegin")
		end

		local Avatar = GWorld:GetAvatar()
		if Avatar then
			Avatar:UpdateDungeonProgress(ResTable)
		end
	end
end

function BP_EMGameMode_C:ExecuteLogicBetweenRounds()
	if self:IsWalnutDungeon() then
		-- 开核桃副本，先弹核桃奖励，再弹投票
		self:TriggerShowWalnutReward()
	else
		-- 其他副本，直接投票
		self:ExecuteLogicStartDungeonVote()
	end
end

-- 封装以下逻辑：
-- DungeonProgress++ 上报skynet
-- 开启投票
function BP_EMGameMode_C:ExecuteLogicStartDungeonVote()
	self:UpdateDungeonProgress()
	if self:CheckDungeonProgressIsMaxRound() then
		return
	end
	self:TriggerDungeonComponentFun("TriggerDungeonVoteBegin")
	self:SetGamePaused("GameModeState", true)
end

function BP_EMGameMode_C:ExecuteNextStepOfDungeonVote()
	if self:IsTicketDungeon() then
		self:TriggerShowTicket()
	else
		self:ExecuteNextStepOfTicket()
	end
	
end

function BP_EMGameMode_C:ExecuteNextStepOfTicket()
	self.EMGameState.IsInSelectTicket = false
	self.EMGameState.NextTicketPlayer:Clear()
	UE.UMapSyncHelper.SyncMap(self.EMGameState, "NextTicketPlayer")
	if self:IsWalnutDungeon() then
		-- 开核桃副本，进入选择核桃流程
		self:TriggerShowNextWalnut()
	else
		-- 其他副本，直接进入Battle
		self:TriggerActiveGameModeState(Const.StateBattleProgress)
	end
end

function BP_EMGameMode_C:BpOnTimerEnd_OnDungeonVoteBegin()
	self.EMGameState:DealDungeonVoteResult()
end

function BP_EMGameMode_C:BpOnTimerEnd_SelectTicket()
	self.EMGameState:DealDungeonTicketResult()
end

function BP_EMGameMode_C:IsEndlessDungeon()
	if self.IsDungeonTypeEndless == nil then
		local DungeonInfo = DataMgr.Dungeon[self.DungeonId]
		if DungeonInfo then
			self.IsDungeonTypeEndless = DungeonInfo.DungeonWinMode == CommonConst.DungeonWinMode.Endless
		end
	end
	return self.IsDungeonTypeEndless
end

-- function BP_EMGameMode_C:FixBattleProgressLevel()
-- 	-- 轮次修正等级
-- 	if not self:IsInDungeon() or not self.BattleProgressLevel then
-- 		return
-- 	end
-- 	self:SetGameModeLevel(self:GetGameModeLevel() + self.BattleProgressLevel)
-- end

------------------------------------------------
-- 原本5个封装好的接口已暂时无法满足需求，因此针对特定系统再向外封装一层
function BP_EMGameMode_C:DungeonFinish_OnPlayerRealDead(AvatarEids)
	local Avatar = GWorld:GetAvatar()
	if Avatar and Avatar:IsInRougeLike() then
		DebugPrint("EMGameMode:DungeonFinish_OnPlayerRealDead RougeLike")
		self:FinishRougeLike(false, AvatarEids)
	elseif self:IsAbyssDungeon() then
		local IsReEntering = self:TriggerDungeonComponentFun("IsReEnteringAbyss")
		DebugPrint("EMGameMode:DungeonFinish_OnPlayerRealDead Abyss IsReEntering", IsReEntering)
		if IsReEntering then 
			return 
		end
		self:TriggerPlayerFailed(AvatarEids)
	elseif self.EMGameState.GameModeType == "SoloTreasure" then
		DebugPrint("EMGameMode:DungeonFinish_OnPlayerRealDead SoloTreasure")
		self:TriggerDungeonComponentFun("FinishSolotreasure", false, "PlayerRealDead")
	else
		DebugPrint("EMGameMode:DungeonFinish_OnPlayerRealDead Default")
		self:TriggerPlayerFailed(AvatarEids)
	end
	
end
------------------------------------------------
function BP_EMGameMode_C:IsDungeonInSettlement()
	if not self.EMGameState:CheckGameModeStateEnable() then
		DebugPrint("BP_EMGameMode_C:副本状态不正确 多次触发副本结算")
		return true
	end

	local Avatar = GWorld:GetAvatar()
	if Avatar and Avatar:IsInHardBoss() then
		if self.LevelGameMode.IsInHardBossSettlement then
			DebugPrint("BP_EMGameMode_C:正处于mycs 多次触发副本结算")
			return true
		end
	end

	return false
end

-- 根据策划需求结算副本的接口，会额外处理玩法相关需求（轮次）  指正常完成任务进行结算
function BP_EMGameMode_C:TriggerDungeonWin()
	DebugPrint("BP_EMGameMode_C:TriggerDungeonWin 副本胜利")
	if self:IsDungeonInSettlement() then
		return
	end

	self.LevelGameMode:TriggerDungeFinish(true)
end

-- 根据策划需求结算副本的接口，会额外处理玩法相关需求（轮次）
function BP_EMGameMode_C:TriggerDungeonFailed()
	DebugPrint("BP_EMGameMode_C:TriggerDungeonFailed 副本失败")
	if self:IsDungeonInSettlement() then
		return
	end

	self.LevelGameMode:TriggerDungeFinish(false)
end

-- 玩家主动退出副本的接口(区域HardBoss)
function BP_EMGameMode_C:TriggerExitDungeon(IsWin)
	DebugPrint("BP_EMGameMode_C:TriggerExitDungeon: Exit Battle + HardBoss", IsWin)
	if self:IsDungeonInSettlement() then
		return
	end

	self.LevelGameMode:TriggerDungeFinish(IsWin)
end

------------------------------------------------
-- 触发玩家退出副本的接口(撤离点 + 死亡 + ds的要求)
function BP_EMGameMode_C:TriggerPlayerWin(AvatarEids, PlayerEids)
	DebugPrint("BP_EMGameMode_C:TriggerPlayerWin 玩家成功 撤离")
	if self:IsDungeonInSettlement() then
		return
	end

	-- 此接口增加参数PlayerEids 用于副本成就处理
	if IsStandAlone(self) then
		self:TriggerBattleAchievementUploadOnDungeonEnd(true)
		self:TriggerDungeonOnEnd(true)
	end
	self:TriggerUploadDungeonAchievement(PlayerEids)
	self.LevelGameMode:TriggerPlayerFinish(true, AvatarEids)
end

-- 触发玩家退出副本的接口
function BP_EMGameMode_C:TriggerPlayerFailed(AvatarEids)
	DebugPrint("BP_EMGameMode_C:TriggerPlayerFailed 玩家失败 撤离")
	if self:IsDungeonInSettlement() then
		return
	end
	
	if IsStandAlone(self) then
		self:TriggerBattleAchievementUploadOnDungeonEnd(false)
		self:TriggerDungeonOnEnd(false)
	end
	self.LevelGameMode:TriggerPlayerFinish(false, AvatarEids)
end

-- 特殊情况下，强制以失败结算玩家
-- 慎用，建议在ds环境调用
-- 考虑到可能在结算流程中调用，该方式结算不会判断副本是否End
function BP_EMGameMode_C:ForceFinishPlayerByFailed(AvatarEids, PlayerEndReason)
	DebugPrint("BP_EMGameMode_C:ForceFinishPlayerByFailed 强制玩家以失败结算")
	self.LevelGameMode:TriggerPlayerFinish(false, AvatarEids, PlayerEndReason)
end

-- todo: @SnowMoon 强制结算传IsWin的参数用于后续可能的新功能拓展，目前强制结算均以失败的方式结算
function BP_EMGameMode_C:ForceFinishPlayer(IsWin, AvatarEid, PlayerEndReason)
	self:ForceFinishPlayerByFailed({AvatarEid}, PlayerEndReason)
end
------------------------------------------------
------------------------------------------------
-- 底层逻辑，禁止直接调用
function BP_EMGameMode_C:TriggerDungeFinish(IsWin)
	GWorld:DSBLog("Info", "TriggerDungeFinish IsWin:"..tostring(IsWin), "GameMode")

	self:TriggerDungeonOnEnd(IsWin)

	if IsWin and self:IsWalnutDungeon() and (not self:IsEndlessDungeon()) then
		-- 通常，非无尽玩法走TriggerDungeonWin结算，无尽玩法走TriggerPlayerWin结算
		self:ExecuteWalutLogicOnEnd()
	else
		self:TriggerRealDungeFinish(IsWin)
	end
end

function BP_EMGameMode_C:TriggerRealDungeFinish(IsWin)
	local DungeonInfo = DataMgr.Dungeon[self.DungeonId]
	if IsWin then
		if DungeonInfo and DungeonInfo.DungeonWinMode == CommonConst.DungeonWinMode.Single then
			self:UpdateDungeonProgress()
		end
		if DungeonInfo and DungeonInfo.DungeonWinMode == CommonConst.DungeonWinMode.Disable then
			local RewardLevel = self:GetDungeonComponent().RewardLevel
			if RewardLevel then
				for i = 1, RewardLevel do
					self:UpdateDungeonProgress()
				end
			end
		end
		self:TriggerUploadDungeonAchievement()
	end
	self:TriggerBattleAchievementUploadOnDungeonEnd(IsWin)
	self:TriggerPlayerFinish(IsWin)
end
---------------------------------------------------------
-- 玩家退出副本的真正实现，底层逻辑，禁止直接调用,需求请调用上面5个封装的接口
-- 玩家结束，不改变副本状态
function BP_EMGameMode_C:TriggerPlayerFinish(IsWin, AvatarEids, PlayerEndReason)
	GWorld:DSBLog("Info", "TriggerPlayerFinish IsWin:"..tostring(IsWin), "GameMode")
	DebugPrint("TriggerPlayerFinish 玩家结算，结算状态：",IsWin)
	if IsStandAlone(self) or MiscUtils.IsListenServer(self) then
		--触发玩家退出副本事件
		
		local Avatar = GWorld:GetAvatar()
		if Avatar then
			print(_G.LogTag, "CollectAlertBaseInfo Server TriggerPlayerFinish", IsWin, self.DungeonId)
			self:TriggerPlayerFinishDungeon(IsWin)
			Avatar:BattleFinish(IsWin)

			--local AvatarArr = TArray("")
			--AvatarArr:Add(CommonUtils.ObjId2Str(Avatar.Eid))
			--self.OnExitDelegates:Broadcast(AvatarArr)
		end

		self:NotifyClientGameEnd(IsWin, AvatarEids, PlayerEndReason)
		self:OnPlayersDungeonEnd(AvatarEids)
	elseif IsDedicatedServer(self) then
		-- DS触发副本
		print(_G.LogTag, "Server TriggerPlayerFinish", IsWin)

		if GWorld.bDebugServer then
			return
		end

		local DSEntity = GWorld:GetDSEntity()
		if DSEntity then
			DSEntity:BattleFinish(IsWin, AvatarEids, PlayerEndReason)
		end
	end
end
function BP_EMGameMode_C:SendTimeDistCheatalert(PlayerChar, DungeonSpendTime, DungeonMoveDistance, MonitorType, SubId, DisThresh, TimeThresh)
    local AlertString = "检测到非法信息:  "
	local BaseAlertInfo = self:CollectAlertBaseInfo(PlayerChar)
	if(BaseAlertInfo.DungeonId) then
		AlertString = AlertString.."副本ID: "..BaseAlertInfo.DungeonId.."  "
	end
	if(BaseAlertInfo.DungeonLevel) then
		AlertString = AlertString.."副本等级: "..BaseAlertInfo.DungeonLevel.."  "
	end
	if(BaseAlertInfo.CharLevel) then
		AlertString = AlertString.."角色等级: "..BaseAlertInfo.CharLevel.."  "
	end
	if(MonitorType) then
		AlertString = AlertString.."MonitorType: "..MonitorType.."  "
	end
	
	if(SubId) then
		AlertString = AlertString.."SubID: "..SubId.."  "
	end

	if(DungeonSpendTime) then
	AlertString = AlertString.."副本耗时: "..DungeonSpendTime.."  "
	end
	if(TimeThresh) then
		AlertString = AlertString.."时间阈值: "..TimeThresh.."  "
	end

	if(DungeonMoveDistance) then
		AlertString = AlertString.."主控角色移动距离: "..DungeonMoveDistance.."  "
	end
	if(DisThresh) then
		AlertString = AlertString.."距离阈值: "..DisThresh.."  "	
	end
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end
	print(_G.LogTag, "SendTimeDistCheatalert", AlertString)
	Avatar:SendToFeishuForCombatMonitor(AlertString)
end
function BP_EMGameMode_C:CollectAlertBaseInfo(PlayerChar)
	local AlertInfo = {}
	if(not self.LevelGameMode) then
		print(_G.LogTag, "CollectAlertBaseInfo LevelGameMode is nil")
		return AlertInfo
	end
	AlertInfo.DungeonId = self.LevelGameMode.DungeonId
	local DungeonInfo = DataMgr.Dungeon[AlertInfo.DungeonId]
	if not DungeonInfo then
		print(_G.LogTag, "CollectAlertBaseInfo DungeonInfo is nil",AlertInfo.DungeonId , self.DungeonId)
		return AlertInfo
	end
	AlertInfo.DungeonLevel = DungeonInfo.DungeonLevel or 1
	AlertInfo.CharLevel = PlayerChar:GetAttr("Level") or 0
	print(_G.LogTag, "CollectAlertBaseInfo", AlertInfo.DungeonId, AlertInfo.DungeonLevel, AlertInfo.CharLevel,PlayerChar:GetAttr("Level"))
	return AlertInfo
end


function BP_EMGameMode_C:NotifyClientFightAttributeData(PlayerCharacter)
	if not IsDedicatedServer(self) then
		return
	end
	local FightAttributeSet = PlayerCharacter and PlayerCharacter:GetFightAttributeSet()
	if not FightAttributeSet then
		return
	end
	for i = 1, self:GetPlayerNum() do
		local ControllerIndex = i - 1
		local Controller = UE4.UGameplayStatics.GetPlayerController(self, ControllerIndex)
		local Teammate = Controller:GetMyPawn()
		if Teammate and Teammate.Eid ~= PlayerCharacter.Eid then
			local TeammateInfo = FTeammateAttrInfo()
			TeammateInfo.TeammateEid = Teammate.Eid
			TeammateInfo.FinalDamage = Teammate:GetFinalDamage()
			TeammateInfo.TotalKillCount = Teammate:GetTotalKillCount()
			TeammateInfo.TakedDamage = Teammate:GetTakedDamage()
			TeammateInfo.GiveHealing = Teammate:GetGiveHealing()
			TeammateInfo.MaxDamage = Teammate:GetMaxDamage()
			TeammateInfo.BreakableItemCount = Teammate:GetBreakableItemCount()
			TeammateInfo.MaxComboCount = Teammate:GetMaxComboCount()
			local PhantomAttrInfos = Teammate:GetPhantomAttrInfos()
			if PhantomAttrInfos:Num() > 0 then
				TeammateInfo.PhantomAttrInfo = PhantomAttrInfos[1]
			end
			FightAttributeSet:AddTeammateDamageInfos(TeammateInfo)
		end
	end
	FightAttributeSet:RefreshFightAttributeData()
end

-- 通知客户端游戏开始结算，客户端自行判断是否需要切换场景
function BP_EMGameMode_C:NotifyClientGameEnd(IsWin, AvatarEids, PlayerEndReason)
	if not AvatarEids or #AvatarEids == 0 then
		-- 单机和联机所有人都成功结束，则直接广播，统一接口都走RPC
		for i = 1, self:GetPlayerNum() do
			local ControllerIndex = i - 1
			local Controller = UE4.UGameplayStatics.GetPlayerController(self, ControllerIndex)
			if not Controller then
				error("Controller is Not Exist") -- 不应该出现这种情况
			end
			
			local Avatar = GWorld:GetAvatar()
			if IsWin and (not Avatar or not Avatar:IsInHardBoss()) then--失败原地结算，不需要计算位置
				self:UpdatePlayerCharacterEndPointInfo(ControllerIndex, Controller)
				DebugPrint("StartAndEndPoint AllSuccess UpdatePlayerCharacterEndPointInfo")
			end

			local MyPawn = Controller:GetMyPawn()
			if IsStandAlone(self) then
				-- 单机RPC发不了
				DebugPrint("StartAndEndPoint AllSuccess NotifyClientGameEnd_Lua")
				Controller:NotifyClientGameEnd_Lua(IsWin, self:GetScenePlayersInfo(MyPawn), PlayerEndReason)
			else
				DebugPrint("StartAndEndPoint AllSuccess NotifyClientGameEnd")
				self:NotifyClientFightAttributeData(MyPawn)
				Controller:NotifyClientGameEnd(IsWin, self:GetScenePlayersInfo(MyPawn), PlayerEndReason)
			end
		end
	else
		-- 联机部分人成功，则走RPC
		local function EndAvatar(AvatarEid)
			local Controller = UE4.URuntimeCommonFunctionLibrary.GetPlayerControllerByAvatarEid(self, AvatarEid)
			if not Controller then
				DebugPrint("Controller is Not Exist")
				return
			end

			if IsWin then--失败原地结算，不需要计算位置
				local ControllerIndex = UE4.URuntimeCommonFunctionLibrary.GetPlayerControllerIndex(self, Controller)
				self:UpdatePlayerCharacterEndPointInfo(ControllerIndex, Controller)
				DebugPrint("StartAndEndPoint PartSuccess UpdatePlayerCharacterEndPointInfo")
			end

			DebugPrint("StartAndEndPoint PartSuccess NotifyClientGameEnd")
			local MyPawn = Controller:GetMyPawn()
			self:NotifyClientFightAttributeData(MyPawn)
			Controller:NotifyClientGameEnd(IsWin, self:GetScenePlayersInfo(MyPawn), PlayerEndReason)
		end

		for _, AvatarEid in ipairs(AvatarEids) do
			EndAvatar(AvatarEid)
		end
	end
end

function BP_EMGameMode_C:SimplifyInfoForInit(InfoForInit)
	if InfoForInit == nil then
		DebugPrint("Error SimplifyInfoForInit InfoForInit is nil")
		return InfoForInit
	end
	InfoForInit.FromOtherWorld = true
	return InfoForInit
end

-- @SnowMoon 获取场景里所有Player和Phantom的信息，用于结算界面摆Pose
function BP_EMGameMode_C:GetScenePlayersInfo(MainPlayer)
	local PlayersInfo = {}
	if self.EMGameState.GameModeType == "Party" then
        -- 派对联机根据排名
        local Ordinal = self.EMGameState.PartyPlayerOrdinal
        for i = 1, Ordinal:Length() do
            local TargetEid = Ordinal[i]
            local TargetCharacter = Battle(self):GetEntity(TargetEid)
			if TargetCharacter then
				local bIsPhantom = TargetCharacter:IsPhantom()
				PlayersInfo[#PlayersInfo + 1] = self:SimplifyInfoForInit(TargetCharacter.InfoForInit)
				PlayersInfo[#PlayersInfo].IsDungeonEnd = true
				PlayersInfo[#PlayersInfo].IsPhantom = bIsPhantom
				if bIsPhantom then
					PlayersInfo[#PlayersInfo].IsMainPlayerPhantom = TargetCharacter.PhantomOwner == MainPlayer
				end
				local PlayerWeapon = TargetCharacter:GetCurrentWeapon()
				if PlayerWeapon then
					PlayersInfo[#PlayersInfo].CurrentWeaponType = PlayerWeapon:GetWeaponType()
					PlayersInfo[#PlayersInfo].CurrentWeaponMeleeOrRanged = PlayerWeapon:GetWeaponMeleeOrRanged()
				end
				if MainPlayer.Eid == TargetEid then
					PlayersInfo[#PlayersInfo].IsMainPlayer = true
				else
					PlayersInfo[#PlayersInfo].IsMainPlayer = false
					PlayersInfo[#PlayersInfo].IsSettlementOtherRole = true
				end
				local PlayerRoleId = nil
				if PlayersInfo[#PlayersInfo].RoleId then
					PlayerRoleId = PlayersInfo[#PlayersInfo].RoleId
				elseif PlayersInfo[#PlayersInfo].RoleInfo and PlayersInfo[#PlayersInfo].RoleInfo.RoleId then
					PlayerRoleId = PlayersInfo[#PlayersInfo].RoleInfo.RoleId
				end
				PlayersInfo[#PlayersInfo].ScenePlayerName = self:GetScenePlayerName(TargetCharacter.Eid, bIsPhantom, PlayerRoleId)
				PlayersInfo[#PlayersInfo].MVPId = TargetCharacter.CharacterFashion.AccessoryType2Id:Find(CommonConst.CharAccessoryTypes.MVP)
			end
        end
    else
		-- 主玩家是第一个
		PlayersInfo[1] = self:SimplifyInfoForInit(MainPlayer.InfoForInit)
		PlayersInfo[1].IsDungeonEnd = true
		PlayersInfo[1].IsMainPlayer = true
		PlayersInfo[1].IsDead = MainPlayer:IsDead()
		local MainPlayerWeapon = MainPlayer:GetCurrentWeapon()
		if MainPlayerWeapon then
			PlayersInfo[1].CurrentWeaponType = MainPlayerWeapon:GetWeaponType()
			PlayersInfo[1].CurrentWeaponMeleeOrRanged = MainPlayerWeapon:GetWeaponMeleeOrRanged()
		end
		PlayersInfo[1].ScenePlayerName = self:GetScenePlayerName(MainPlayer.Eid, false, PlayersInfo[1].RoleId)
		PlayersInfo[1].MVPId = MainPlayer.CharacterFashion.AccessoryType2Id:Find(CommonConst.CharAccessoryTypes.MVP)
		-- 剩下的随意排序
		print(_G.LogTag, "GetScenePlayersInfo", MainPlayer:GetAllTeammates():Length())
		for _, v in pairs(MainPlayer:GetAllTeammates()) do
			if v ~= MainPlayer then
				local InitInfo = v.InfoForInit
				if InitInfo == nil then
					local Context = v.CreateUnitContextCopy
					InitInfo = Context:GetLuaTable("AvatarInfo")
				end
				PlayersInfo[#PlayersInfo + 1] = self:SimplifyInfoForInit(InitInfo)
				PlayersInfo[#PlayersInfo].IsDungeonEnd = true
				local bIsPhantom = v:IsPhantom()
				PlayersInfo[#PlayersInfo].IsPhantom = bIsPhantom
				if bIsPhantom then
					local PhantomCharacter = v:Cast(APhantomCharacter)
					if PhantomCharacter then
						PlayersInfo[#PlayersInfo].IsNPCPhantom = PhantomCharacter.IsNPCPhantom
					end
					PlayersInfo[#PlayersInfo].IsMainPlayerPhantom = v.PhantomOwner == MainPlayer
				else
					PlayersInfo[#PlayersInfo].Uid = self:GetPlayerUidByEid(v.Eid)
				end
				PlayersInfo[#PlayersInfo].IsMainPlayer = false
				PlayersInfo[#PlayersInfo].IsSettlementOtherRole = true
				PlayersInfo[#PlayersInfo].IsDead = v:IsDead()
				local CurrentPlayerWeapon = v:GetCurrentWeapon()
				if CurrentPlayerWeapon then
					PlayersInfo[#PlayersInfo].CurrentWeaponType = CurrentPlayerWeapon:GetWeaponType()
					PlayersInfo[#PlayersInfo].CurrentWeaponMeleeOrRanged = CurrentPlayerWeapon:GetWeaponMeleeOrRanged()
				end
				local PlayerRoleId = nil
				if PlayersInfo[#PlayersInfo].RoleId then
					PlayerRoleId = PlayersInfo[#PlayersInfo].RoleId
				elseif PlayersInfo[#PlayersInfo].RoleInfo and PlayersInfo[#PlayersInfo].RoleInfo.RoleId then
					PlayerRoleId = PlayersInfo[#PlayersInfo].RoleInfo.RoleId
				end
				PlayersInfo[#PlayersInfo].ScenePlayerName = self:GetScenePlayerName(v.Eid, bIsPhantom, PlayerRoleId)
				PlayersInfo[#PlayersInfo].MVPId = v.CharacterFashion.AccessoryType2Id:Find(CommonConst.CharAccessoryTypes.MVP)
			end
		end
	end

	local MsgStr = msgpack.pack(PlayersInfo)
	local RewardsMessage = FMessage()
	RewardsMessage:SetBytes(MsgStr, #MsgStr)
	return RewardsMessage
end

--通过其他玩家Eid获取其他玩家的Uid
function BP_EMGameMode_C:GetPlayerUidByEid(Eid)
	local Players = self.EMGameState:GetPlayerState(Eid)
	DebugPrint("BP_EMGameMode_C:GetPlayerUidByEid", Eid, Players, Players and Players.Uid or nil)
	return Players and Players.Uid or nil
end

function BP_EMGameMode_C:GetScenePlayerName(Eid, IsPhantom, RoleId)
	local PlayerState = nil
	if IsPhantom then
		PlayerState = GameState(self):GetPhantomState(Eid)
	else
		PlayerState = GameState(self):GetPlayerState(Eid)
	end
    local CharacterName = ""
    if PlayerState then
        if not IsPhantom then
            CharacterName = PlayerState.PlayerName
        else
            local NameKey = DataMgr.BattleChar[RoleId].CharName
            if string.find(DataMgr.TextMap_ContentEN[NameKey].ContentEN, "{nickname") and not IsStandAlone(self) then
                local PhantomOwnerEid = PlayerState.OwnerEid
                if PhantomOwnerEid then
                    local OwnerState = GameState(self):GetPlayerState(PhantomOwnerEid)
                    if OwnerState and OwnerState.PlayerName then
                        CharacterName = OwnerState.PlayerName
                    else
                        CharacterName = GText(NameKey)
                        DebugPrint("BP_EMGameMode_C:GetScenePlayerName  主角魅影找不到它的OwnerPlayerName")
                    end
                else
                    DebugPrint("BP_EMGameMode_C:GetScenePlayerName  主角魅影找不到它的Owner， 无法赋予名称")
                end
            else
                CharacterName = GText(NameKey)
            end
        end
    end
	return CharacterName
end

-- 玩家进入时，若副本已结束/该玩家已结算，的保底处理
function BP_EMGameMode_C:TriggerEnterEndPlayer(AvatarEidStr)
	local PlayerController = UE4.URuntimeCommonFunctionLibrary.GetPlayerControllerByAvatarEid(self, AvatarEidStr)
	-- 分两种情况讨论：玩家已结算or副本已结束但玩家未结算
	if PlayerController and PlayerController:IsPlayEnd() then
		DebugPrint("TriggerEnterEndPlayer 玩家已结算：", AvatarEidStr)
		-- 玩家已结算：仅场景服通知客户端结算，这时无需通知逻辑服结算玩家
		local DSEntity = GWorld:GetDSEntity()
		assert(DSEntity)
		local LeaveResult = rawget(DSEntity.HasLeaveAvatars, AvatarEidStr)
		self:NotifyClientGameEnd(LeaveResult, {AvatarEidStr})
	else
		DebugPrint("TriggerEnterEndPlayer 副本已结束但玩家未结算：", AvatarEidStr)
		-- 副本已结束但玩家未结算：走正常结算流程（即场景服结算、且通知逻辑服结算）
		self:ForceFinishPlayerByFailed({AvatarEidStr})
	end
end

function BP_EMGameMode_C:OnMiniGameSuccess(MiniGameType, CreatorId)
	self.Overridden.OnMiniGameSuccess(self,MiniGameType, CreatorId)
	self:TriggerDungeonComponentFun("OnMiniGameSuccess", MiniGameType, CreatorId)
end

function BP_EMGameMode_C:OnDefenceCoreActive(DefenceCore)
	self.Overridden.OnDefenceCoreActive(self, DefenceCore)
	self:TriggerDungeonComponentFun("OnDefenceCoreActive", DefenceCore)
end

function BP_EMGameMode_C:OnMiniGameFail(MiniGameType, CreatorId)
	if not self:IsSubGameMode() then
		if not self.MiniGameFailedTime[MiniGameType] then
			self.MiniGameFailedTime[MiniGameType] = 0
		end
		self.MiniGameFailedTime[MiniGameType] = self.MiniGameFailedTime[MiniGameType] + 1
	end
	self.Overridden.OnMiniGameFail(self,MiniGameType, CreatorId)
end

function BP_EMGameMode_C:OnDefenceCoreDead(Eid)
	-- self.EMGameState:SetDungeonEndReason(Const.DungeonEnd_DefenceCoreDead)
	self.Overridden.OnDefenceCoreDead(self,Eid)
end

function BP_EMGameMode_C:ChangeFallTriggersActive(FallTriggerIds, Active)
	for i, FallTriggerId in pairs(FallTriggerIds) do
		for j, FallTrigger in pairs(self.EMGameState.FallTriggersArray) do
			if FallTrigger.FallTriggerId == FallTriggerId then
				FallTrigger.Active = Active
			end
		end
	end
end

function BP_EMGameMode_C:OnMonsterSpawnDestroy(MonsterSpawnId)
	if not self:IsSubGameMode() then
		self:TriggerDungeonComponentFun("OnMonsterSpawnDestroy", MonsterSpawnId)
	end
	self.Overridden.OnMonsterSpawnDestroy(self, MonsterSpawnId)
end

------------------序章新增功能-----------------------------

-- function BP_EMGameMode_C:AsyncFunctionOnEnd(LoadLevelTest, UnitId, NewTargetPointName, IsCloseBlackUI)
-- 	local function SyncLoadLevelCallBack()
-- 		LoadLevelTest:AsyncLoadLevel()
-- 	end
--     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--     local LevelLoader = GameMode:GetLevelLoader()
--     if not LevelLoader or NewTargetPointName == "" or not NewTargetPointName or URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self) then --如果不存在LevelLoad 直接调用广播，进行设置位置
-- 		self:AddTimer(0.1,SyncLoadLevelCallBack)
-- 		return
--     end
-- 	local EMGameState = UE4.UGameplayStatics.GetGameState(self)
-- 	local NewTargetPoint = EMGameState:GetTargetPoint(NewTargetPointName)
-- 	local PlayerCharacter
-- 	if UnitId == 0 then
-- 		PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
-- 	else
-- 		PlayerCharacter = EMGameState.NpcCharacterMap:FindRef(UnitId)
-- 	end
-- 	if not IsValid(PlayerCharacter) or not IsValid( NewTargetPoint ) then
-- 		self:AddTimer(0.1,SyncLoadLevelCallBack)
-- 		return
-- 	end
-- 	--计算LevelId
-- 	local TargetLevelId = GameMode:GetLevelLoader():GetLevelIdByLocation(NewTargetPoint:K2_GetActorLocation())
-- 	local CurrentLevelId = GameMode:GetLevelLoader():GetLevelIdByLocation(PlayerCharacter:K2_GetActorLocation())
-- 	if TargetLevelId == CurrentLevelId then
-- 		self:AddTimer(0.1, SyncLoadLevelCallBack)
-- 		return
-- 	end
-- 	print(_G.LogTag,"ZJT_  TargetLevelId CurrentLevelId ", NewTargetPointName, NewTargetPoint:K2_GetActorLocation(), TargetLevelId, CurrentLevelId, IsCloseBlackUI)
-- 	--存在LevelLoad的话就将其绑定到完成函数上
-- 	local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
-- 	local UIManager = GameInstance:GetGameUIManager()
-- 	local UI = UIManager:LoadUINew("BlackScreenSubtitleUI")
-- 	--if not IsCloseBlackUI then
-- 	--	UI:PlayAnimation(UI.FadeInAnimation)
-- 	--end
-- 	local SceneMgrComponent = GameInstance:GetSceneManager()
-- 	SceneMgrComponent:ShowOrHideAllSceneGuideIcon(false)
-- 	local TaskIndicator = UIManager:GetUIObj("MainTaskIndicator")
-- 	if IsValid(TaskIndicator) then
-- 		TaskIndicator:SetVisibility(UE4.ESlateVisibility.Collapsed)
-- 	end
-- 	PlayerCharacter:DisableInput(UE4.UGameplayStatics.GetPlayerController(self,0))
-- 	local function LoadLevelCallBack()
-- 		LevelLoader = GameMode:GetLevelLoader()
-- 		LoadLevelTest:AsyncLoadLevel()
-- 		DebugPrint("EMGameModeTTTTTTTTTTTTTTTTTTTTTTTTTTTT")
-- 		local UI = UIManager:LoadUINew("BlackScreenSubtitleUI")
	
-- 		local function UnLoadingUI()
-- 			UIManager:UnLoadUINew("BlackScreenSubtitleUI")
-- 			TaskIndicator = UIManager:GetUIObj("MainTaskIndicator")
-- 			if IsValid(TaskIndicator) then
-- 				TaskIndicator:SetVisibility(UE4.ESlateVisibility.Visible)
-- 			end
-- 			SceneMgrComponent = GameInstance:GetSceneManager()
-- 			SceneMgrComponent:ShowOrHideAllSceneGuideIcon(true)
-- 			PlayerCharacter:EnableInput(UE4.UGameplayStatics.GetPlayerController(self,0))
-- 		end
-- 		self:AddTimer(0.5,UnLoadingUI)
-- 		if LevelLoader then
-- 			LevelLoader:RemoveArtLevelLoadedCompleteCallback(TargetLevelId)
-- 		end
-- 	end
-- 	LevelLoader:BindArtLevelLoadedCompleteCallback(TargetLevelId, LoadLevelCallBack)
-- 	LevelLoader:LoadArtLevel(TargetLevelId)
-- end

function BP_EMGameMode_C:AsyncLoadTargetLevel(LoadLevel, NewTargetPointName)
	local function Callback()
		LoadLevel:AsyncPrintHello()
	end
	local NewTargetPoint = self.EMGameState:GetTargetPoint(NewTargetPointName)
	if not IsValid( NewTargetPoint )then
		self:AddTimer(0.1, Callback)
		return
	end
	local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
	if not self:GetLevelLoader() then
		self:AddTimer(0.1, Callback)
		return
	end
	local TargetLevelId = self:GetLevelLoader():GetLevelIdByLocation(NewTargetPoint:K2_GetActorLocation())
	local CurrentLevelId = self:GetLevelLoader():GetLevelIdByLocation(PlayerCharacter:K2_GetActorLocation())
	if not TargetLevelId or not CurrentLevelId or TargetLevelId == CurrentLevelId then
		self:AddTimer(0.1, Callback)
		return
	end
	local LevelLoader = self:GetLevelLoader()
	local function LoadLevelCallBack()
		local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
		GameInstance:CloseLoadingUI()
		LoadLevel:AsyncPrintHello()
		if LevelLoader then
			LevelLoader:RemoveArtLevelLoadedCompleteCallback(TargetLevelId)
		end
	end
	LevelLoader:BindArtLevelLoadedCompleteCallback(TargetLevelId, LoadLevelCallBack)
	LevelLoader:LoadArtLevel(TargetLevelId)
end

function BP_EMGameMode_C:SetActorLocationAndRotationByTransform(UnitId, Transform, bIsForceIdle, --[[是否修正TargetPoint位置--]]bDoCorrect)
	bDoCorrect = bDoCorrect or false
	local PlayerCharacter
	local FinalLocation

	if UnitId == 0 then
		PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
	else
	    PlayerCharacter = self.EMGameState.NpcCharacterMap:FindRef(UnitId)
	end
	if not IsValid(PlayerCharacter) then
		print(_G.LogTag," ZJT_PlayerCharacter Or NewTargetPoint Is NUll !")
		return false
	end

	local TargetPointLoc = Transform.Translation
	local TargetPointRot = Transform.Rotation:ToRotator()

	FinalLocation =  TargetPointLoc
	-- 修正TargetPoint位置
	if bDoCorrect then
		local CapsuleHalfHeight = PlayerCharacter.CapsuleComponent:GetScaledCapsuleHalfHeight()
		local CapsuleRadius = PlayerCharacter.CapsuleComponent:GetScaledCapsuleRadius()
		local HitResult = FHitResult()
		local LineHitResult = FHitResult()
		local StartPos = TargetPointLoc + FVector(0, 0, CapsuleHalfHeight)
		local EndPos = TargetPointLoc + FVector(0, 0, -2 * CapsuleHalfHeight)
		--local LinebHit = UE4.UKismetSystemLibrary.LineTraceSingle(self,TargetPointLoc, EndPos, ETraceTypeQuery.TraceScene, false, nil, 0, LineHitResult, true)
		local bHit = UE4.UKismetSystemLibrary.CapsuleTraceSingle(self, StartPos, EndPos, CapsuleRadius, CapsuleHalfHeight, ETraceTypeQuery.TraceScene, false, nil, 0, HitResult, true)
		if bHit then
			--local tmp = FVector(HitResult.Location.X, HitResult.Location.Y, HitResult.Location.Z)
			local tmp = FVector(HitResult.Location.X, HitResult.Location.Y, HitResult.ImpactPoint.Z + CapsuleHalfHeight + 2)
			FinalLocation = tmp
		end
	end

	if bIsForceIdle and not PlayerCharacter:IsDead() then
		self:SetPlayerCharacterForceIdle(PlayerCharacter)
	end
	-- 分别计算两个LevelId  一个是当前所在的LevelId 一个是传送点的目标LevelId ,
	-- 如果两个LevelId相同就不调用卸载指令，
	-- 否者先将玩家设置到目标关卡，在卸载当前关卡
	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	if GameMode:GetLevelLoader() then
		local TargetLevelId = GameMode:GetLevelLoader():GetLevelIdByLocation(TargetPointLoc)
		local CurrentLevelId = GameMode:GetLevelLoader():GetLevelIdByLocation(PlayerCharacter:K2_GetActorLocation())
		PlayerCharacter:K2_SetActorLocationAndRotation(FinalLocation, TargetPointRot,false,nil,false)
		if TargetLevelId and CurrentLevelId then
			if CurrentLevelId ~= TargetLevelId then
				GameMode:GetLevelLoader():UnloadArtLevel(CurrentLevelId)
			end
		end
	else
		PlayerCharacter:K2_SetActorLocationAndRotation(FinalLocation, TargetPointRot,false,nil,false)
	end
	return true
end

function BP_EMGameMode_C:EMSetActorLocationAndRotation(UnitId, NewTargetPointName, bIsForceIdle, --[[是否修正TargetPoint位置--]]bDoCorrect)
	bDoCorrect = bDoCorrect or false
	local PlayerCharacter
	local NewTargetPoint
	local FinalLocation
	print(_G.LogTag," ZJT_ EMSetActorLocationAndRotation ", UnitId, NewTargetPointName, bIsForceIdle)
	if NewTargetPointName == "" then
		return false
	end
	NewTargetPoint = self.EMGameState:GetTargetPoint(NewTargetPointName)
	if not NewTargetPoint then
		return false
	end
	if UnitId == 0 then
		PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
	else
	    PlayerCharacter = self.EMGameState.NpcCharacterMap:FindRef(UnitId)
	end
	if not IsValid(PlayerCharacter) or not IsValid( NewTargetPoint ) then
		print(_G.LogTag," ZJT_PlayerCharacter Or NewTargetPoint Is NUll !")
		return false
	end

	local TargetPointLoc = NewTargetPoint:K2_GetActorLocation()
	FinalLocation =  TargetPointLoc
	-- 修正TargetPoint位置
	if bDoCorrect then
		local CapsuleHalfHeight = PlayerCharacter.CapsuleComponent:GetScaledCapsuleHalfHeight()
		local CapsuleRadius = PlayerCharacter.CapsuleComponent:GetScaledCapsuleRadius()
		local HitResult = FHitResult()
		local LineHitResult = FHitResult()
		local StartPos = TargetPointLoc + FVector(0, 0, CapsuleHalfHeight)
		local EndPos = TargetPointLoc + FVector(0, 0, -2 * CapsuleHalfHeight)
		--local LinebHit = UE4.UKismetSystemLibrary.LineTraceSingle(self,TargetPointLoc, EndPos, ETraceTypeQuery.TraceScene, false, nil, 0, LineHitResult, true)
		local bHit = UE4.UKismetSystemLibrary.CapsuleTraceSingle(self, StartPos, EndPos, CapsuleRadius, CapsuleHalfHeight, ETraceTypeQuery.TraceScene, false, nil, 0, HitResult, true)
		if bHit then
			--local tmp = FVector(HitResult.Location.X, HitResult.Location.Y, HitResult.Location.Z)
			local tmp = FVector(HitResult.Location.X, HitResult.Location.Y, HitResult.ImpactPoint.Z + CapsuleHalfHeight + 2)
			FinalLocation = tmp
		end
	end

	if bIsForceIdle and not PlayerCharacter:IsDead() then
		self:SetPlayerCharacterForceIdle(PlayerCharacter)
	end
	-- 分别计算两个LevelId  一个是当前所在的LevelId 一个是传送点的目标LevelId ,
	-- 如果两个LevelId相同就不调用卸载指令，
	-- 否者先将玩家设置到目标关卡，在卸载当前关卡
	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	if GameMode:GetLevelLoader() then
		local TargetLevelId = GameMode:GetLevelLoader():GetLevelIdByLocation(NewTargetPoint:K2_GetActorLocation())
		local CurrentLevelId = GameMode:GetLevelLoader():GetLevelIdByLocation(PlayerCharacter:K2_GetActorLocation())
		PlayerCharacter:K2_SetActorLocationAndRotation(FinalLocation, NewTargetPoint:K2_GetActorRotation(),false,nil,false)
		if TargetLevelId and CurrentLevelId then
			if CurrentLevelId ~= TargetLevelId then
				GameMode:GetLevelLoader():UnloadArtLevel(CurrentLevelId)
			end
		end
	else
		PlayerCharacter:K2_SetActorLocationAndRotation(FinalLocation, NewTargetPoint:K2_GetActorRotation(),false,nil,false)
	end
	return true
end

function BP_EMGameMode_C:SetPlayerCharacterForceIdle(PlayerCharacter)
	PlayerCharacter:ResetIdle()
	PlayerCharacter:ServerResourceDisableBattleMount(true)
	PlayerCharacter:DisableInput(UE4.UGameplayStatics.GetPlayerController(self,0))
	local function EnablePlayerInput()
		PlayerCharacter:EnableInput(UE4.UGameplayStatics.GetPlayerController(self,0))
	end
	self:AddTimer(0.2,EnablePlayerInput)
end

function BP_EMGameMode_C:GetRespawnRuleName(Target)
	DebugPrint("Tianyi@ GetRespawnRuleName begin")
	local RespawnRuleName = "Default"
	local CurrentDungeonId = self.DunegeonId 
	if not CurrentDungeonId then  
		DebugPrint("Tianyi@ GetRespawnRuleName: CurrentDungeonId is nil, Try to get it from gameinstance")
		local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
		CurrentDungeonId = GameInstance:GetCurrentDungeonId()
	end
	-- 现在默认联机模式下，走副本规则
	if IsDedicatedServer(self) then
		local DungeonData = DataMgr.Dungeon[CurrentDungeonId]
		if DungeonData and DungeonData.RespawnRule then
			RespawnRuleName = DungeonData.RespawnRule
		end
		return RespawnRuleName
	end

	local Avatar = GWorld:GetAvatar()
	if not Avatar then 
		DebugPrint("Tianyi@ GetRespawnRuleName: Avatar is nil")
		return RespawnRuleName 
	end

	if Target and Target.IsHostage then 
		RespawnRuleName = "Hostage"
		return RespawnRuleName
	end

	if Avatar:IsInDungeon2() then -- 拼接关、训练场
		if not CurrentDungeonId then 
			DebugPrint("GetRespawnRuleName: Tianyi@ DungeonId is nil")
			return RespawnRuleName
		end
		-- DebugPrint("Tianyi@ GetRespawnRuleName: Player in dungeon, DungeonId = " .. self.DungeonId)
		local DungeonData = DataMgr.Dungeon[CurrentDungeonId]
		if DungeonData and DungeonData.RespawnRule then
			RespawnRuleName = DungeonData.RespawnRule
		end

	elseif Avatar:IsInBigWorld() then -- 目前默认区域通用
		DebugPrint("Tianyi@ GetRespawnRuleName: Player in bigworld")
		if Avatar:IsInHardBoss() then 
			RespawnRuleName = "HardBoss"
		else 
			RespawnRuleName = "CommonRegion"
		end
	end

	DebugPrint("Tianyi@ GetRespawnRuleName: RespawnRuleName = " .. RespawnRuleName)
	return RespawnRuleName
end


function BP_EMGameMode_C:GetRespawnRule(Target, TargetRespawnRule)
	local RespawnRule = nil
	if TargetRespawnRule then	
		RespawnRule = DataMgr.RespawnRule[TargetRespawnRule]
		return RespawnRule or DataMgr.RespawnRule["CommonSolo"]
	end

	return DataMgr.RespawnRule[self:GetRespawnRuleName(Target)]
end

function BP_EMGameMode_C:InitEntityRecoveryData(Entity)
	Entity:ClearSkillRecoverTargets()
	Entity:SetAttr("AdditionalRecoverTime", 0)
	if Entity:IsPlayer() then 
		self:InitPlayerReocveryData(Entity) 
	elseif Entity:IsPhantom() then 
		self:InitPhantomRecoveryData(Entity)
	end
end


-- function BP_EMGameMode_C:InitPlayerReocveryData(Player)
-- 	-- 初始化副本规则
-- 	if self:IsInDungeon() then 
-- 		local DungeonData = DataMgr.Dungeon[self.DungeonId]
-- 		if DungeonData and DungeonData.RecoveryMaxCount then
-- 			-- 设置玩家可复活次数
-- 			DebugPrint("Tianyi@ GameMode SetRecoveryMaxCount")
-- 			Player:SetRecoveryMaxCount(DungeonData.RecoveryMaxCount)
-- 		else
-- 			Player:SetRecoveryMaxCount(-1)
-- 		end
-- 		if DungeonData and DungeonData.PhantomRecoveryMaxCount then 
-- 			-- 设置玩家可复活魅影的次数
-- 			Player:SetPhantomRecoveryMaxCount(DungeonData.PhantomRecoveryMaxCount)
-- 		else
-- 			Player:SetPhantomRecoveryMaxCount(-1)
-- 		end
-- 	else
-- 		Player:SetRecoveryMaxCount(-1)
-- 	end
-- end

-- function BP_EMGameMode_C:InitPhantomRecoveryData(Phantom)
-- 	if Phantom.IsHostage then 
-- 		Phantom:SetRecoveryMaxCount(-1)
-- 		return
-- 	end
	
-- 	local PhantomOwner = Phantom.PhantomOwner
-- 	if PhantomOwner then 
-- 		local PhantomRecoveryMaxCount = PhantomOwner:GetPhantomRecoveryMaxCount()
-- 		Phantom:SetRecoveryMaxCount(PhantomRecoveryMaxCount)
-- 	end
-- end

function BP_EMGameMode_C:CheckEntityCanRecover(Entity)
	if Entity:IsPlayer() then 
		return self:CheckPlayerCanRecover(Entity)
	elseif Entity:IsPhantom() then 
		return self:CheckPhantomCanRecover(Entity)
	elseif Entity:IsMonster() then 
		return self:CheckMonsterCanRecover(Entity)
	else 
		return true 
	end
end

function BP_EMGameMode_C:CheckPlayerCanRecover(Player)
	-- local GameState = UE4.UGameplayStatics.GetGameState(self)
	-- if GameState.GameModeType == "Training" then -- 训练场模式
	-- 	return true 
	-- end

	local RecoveryCount = Player:GetRecoveryCount()
	local RecoveryMaxCount = Player:GetRecoveryMaxCount()
    return RecoveryMaxCount < 0 or RecoveryCount < RecoveryMaxCount
end

function BP_EMGameMode_C:CheckPhantomCanRecover(Phantom)
	local Avatar = GWorld:GetAvatar()
	-- 魅影在区域中死亡后直接销毁
	if Avatar and Avatar:IsRealInBigWorld() and not Avatar:IsInHardBoss() then 
		return false  
	end

	local RecoveryCount = Phantom:GetRecoveryCount()
	local RecoveryMaxCount = Phantom:GetRecoveryMaxCount()
	return RecoveryMaxCount < 0 or RecoveryCount < RecoveryMaxCount
end

-- 如果怪物有复活功能，默认可以复活
function BP_EMGameMode_C:CheckMonsterCanRecover(Monster) 
	return true
end

-- function BP_EMGameMode_C:CheckCanGuide(UnitId,UnitType)
-- 	if not DataMgr[UnitType][UnitId] then
-- 		return false
-- 	end
-- 	if not DataMgr[UnitType][UnitId].GuideIconBPPath and not DataMgr[UnitType][UnitId].GuideIconAni then
-- 		return false
-- 	end
-- 	return true
-- end

function BP_EMGameMode_C:TriggerGenerateReward(RewardId, Reason, Transform, ExtraInfo)
	if (RewardId.ToTable) then
		RewardId = RewardId:ToTable()
	end
	self.EMGameState.EventMgr:TriggerGenerateReward(RewardId, Reason, Transform, ExtraInfo)
end

-- function BP_EMGameMode_C:HandleExpInBattle()
-- 	for BattleEid, Exps in pairs(self.LevelGameMode.EMGameState.EventMgr.ExpMap) do
-- 		local PlayerCharacter = Battle(self):GetEntity(BattleEid)
		
-- 		local CharExp = Exps.CharExp
-- 		local MeleeWeaponExp = Exps.MeleeWeaponExp
-- 		local RangedWeaponExp = Exps.RangedWeaponExp

-- 		self.CharExpGetInBattle = (self.CharExpGetInBattle or 0) + CharExp
-- 		if PlayerCharacter:AddExp(CharExp) then
-- 			PlayerCharacter:UpdateAttrByLevel(PlayerCharacter:GetAttr("Level"))
-- 		end
-- 		if PlayerCharacter.MeleeWeapon and
-- 				PlayerCharacter.MeleeWeapon:AddExp(MeleeWeaponExp) then
-- 			PlayerCharacter.MeleeWeapon:UpdateAttrByLevel(PlayerCharacter.MeleeWeapon:GetAttr("Level"))
-- 		end
-- 		if PlayerCharacter.RangedWeapon and 
-- 				PlayerCharacter.RangedWeapon:AddExp(RangedWeaponExp) then
-- 			PlayerCharacter.RangedWeapon:UpdateAttrByLevel(PlayerCharacter.RangedWeapon:GetAttr("Level"))
-- 		end
-- 	end
-- end

function BP_EMGameMode_C:ActiveMonsterBuff(BuffList, BuffNum)
	if not self.MonsterAddBuffRule then
		self.MonsterAddBuffRule = {}
	end
	table.insert(self.MonsterAddBuffRule, {BuffList = BuffList, BuffNum = BuffNum})
end

function BP_EMGameMode_C:DestroyMonsterBuff()
	self.MonsterAddBuffRule = nil
end

-- --获取物体所在的关卡ID 默认为0
-- function BP_EMGameMode_C:GetItemLevelId(ItemLocation)
-- 	-- to lxz zjt
-- 	if self.GetLevelLoader and  self:GetLevelLoader() then
-- 		return self:GetLevelLoader():GetLevelIdByLocation(ItemLocation)
-- 	end
-- 	return 0
-- end

function BP_EMGameMode_C:TriggerMechanismFieldCreature(TrapArrayId, Grade, TrapState, TrapType, Scale)
	for i = 1, TrapArrayId:Length() do
		repeat
			local ManualItemId = TrapArrayId:GetRef(i)
			local FieldCreatureMechan = self.EMGameState.FeildCreatureMap:FindRef(ManualItemId)
			if not FieldCreatureMechan then
				print(_G.LogTag, "ZJT_ TriggerMechanismFieldCreature ", ManualItemId, Grade, TrapState, TrapType, Scale)
				break
			end
			FieldCreatureMechan:SetFieldCreateMechanismInfo(TrapState, TrapType, Scale, Grade)
		until true
	end
	
end

function BP_EMGameMode_C:HideUIInScreen(UIPath, IsHide, HideUIInScreenSuitRecover)
	if not self.EMGameState then
		return
	end
	self.EMGameState:HideUIInScreen(UIPath, IsHide, HideUIInScreenSuitRecover)
end

function BP_EMGameMode_C:SetContinuedPCGuideVisibility(ActionName, IsHide)
	if not self.EMGameState then
		return
	end
	self.EMGameState:RealSetContinuedPCGuideVisibility(ActionName, IsHide)
end

function BP_EMGameMode_C:UpdatePlayerCharacterEndPointInfo(PlayerControllerIndex, PlayerController)
	if not PlayerController then
		PlayerController = UE4.UGameplayStatics.GetPlayerController(PlayerControllerIndex)
	end
	
	local PlayerCharacter = PlayerController:GetMyPawn()

	local EndPointActor = self.EMGameState.EndPointActor
	if not IsValid(EndPointActor) then
		DebugPrint("StartAndEndPoint No End EndPoint")
		PlayerCharacter:SetEndPointInfo(true, nil, nil)
		return
	end

	---@type FTransform
	-- local EndPointTransform = EndPointActor:GetTransformWithBattleCharTag(PlayerControllerIndex, PlayerCharacter:GetBattleCharBodyType())
	local EndPointTransform = EndPointActor:GetTransform(PlayerControllerIndex)
	local EndPointLocation = EndPointTransform.Translation
	local EndPointRotation = FRotator(EndPointTransform.Rotation)

	local Dis = (PlayerCharacter:K2_GetActorLocation() - EndPointLocation):Size()
	if Dis <= 1000 then
		PlayerCharacter:SetEndPointInfo(true, EndPointLocation, EndPointRotation)
	else
		PlayerCharacter:SetEndPointInfo(false, EndPointLocation, EndPointRotation)
	end
end

function BP_EMGameMode_C:AddPickUpSuccessCallback(ItemId, CallbackKey, Callback)
	if not self.PickUpSuccessCallback then
		self.PickUpSuccessCallback = {}
	end
	if not self.PickUpSuccessCallback[ItemId] then
		self.PickUpSuccessCallback[ItemId] = {}
	end
	self.PickUpSuccessCallback[ItemId][CallbackKey] = Callback
end

function BP_EMGameMode_C:RemovePickUpSuccessCallback(ItemId, CallbackKey)
	if self.PickUpSuccessCallback and self.PickUpSuccessCallback[ItemId] then
		self.PickUpSuccessCallback[ItemId][CallbackKey] = nil
	end
end

function BP_EMGameMode_C:AddMiniGameSuccessCallback(DisplayName, Callback)
	if not self.MiniGameSuccessCallback then
		self.MiniGameSuccessCallback = {}
	end
	self.MiniGameSuccessCallback[DisplayName] = Callback
end

function BP_EMGameMode_C:RemoveMiniGameSuccessCallback(DisplayName, Callback)
	if self.MiniGameSuccessCallback then
		self.MiniGameSuccessCallback[DisplayName] = nil
	end
end

function BP_EMGameMode_C:RunStory(StoryPath, QuestId, EndCallback, StopCallback)
	DebugPrint('StoryPathStoryPathStoryPathStoryPath', StoryPath)
	GWorld.StoryMgr:RunStory(StoryPath, QuestId, nil, EndCallback, StopCallback)
end

function BP_EMGameMode_C:PickUpForAllPlayers(FunctionName, PickUpCount, UseParam, UnitId, Transform, AvatarEid, bExtra)
	for i=0, self:GetPlayerNum()-1 do
		local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, i)
		local PlayerCharacter = PlayerController:GetMyPawn()
		PlayerCharacter[FunctionName](PlayerCharacter, PickUpCount, UseParam, UnitId, Transform, AvatarEid, bExtra)
	end
end

-- GameMode定时器 -- 
function BP_EMGameMode_C:CollectGameModeTimerHandle(Handle)
	if not self.GameModeTimerSet then
        self.GameModeTimerSet = UE4.TSet(UE4.FTimerHandle())
    end
    self.GameModeTimerSet:Add(Handle)
end

function BP_EMGameMode_C:PauseGameModeTimer()
    self.CurPauseGameModeTimerMap = {}
    if self.GameModeTimerSet and self.GameModeTimerSet:Num()>0 then
        local DelArray = {}
        local TmpArray = self.GameModeTimerSet:ToArray()
        for i=1, TmpArray:Num() do
            local Handle = TmpArray[i]
            if not UE4.UKismetSystemLibrary.K2_TimerExistsHandle(self, Handle) then
                table.insert(DelArray, Handle)
            else
                self.CurPauseGameModeTimerMap[Handle] = true
                UE4.UKismetSystemLibrary.K2_PauseTimerHandle(self, Handle)
                UE4.UKismetSystemLibrary.K2_TimerExistsHandle(self, Handle)
            end
        end
        for i=1, #DelArray do
            self.GameModeTimerSet:Remove(DelArray[i])
        end
    end
end

function BP_EMGameMode_C:UnPauseGameModeTimer()
    if self.CurPauseGameModeTimerMap == nil or IsEmptyTable(self.CurPauseGameModeTimerMap) then
        return
    end
    
    for Handle, _ in pairs(self.CurPauseGameModeTimerMap) do
        if UE4.UKismetSystemLibrary.K2_TimerExistsHandle(self, Handle) then
            UE4.UKismetSystemLibrary.K2_UnPauseTimerHandle(self, Handle)
        end
    end

    self.CurPauseGameModeTimerMap = {}
end
-- GameMode定时器 -- 

function BP_EMGameMode_C:GetActor2ManualId(ManualItemId)
	local ManualItemActor = self.LevelGameMode.BPBornRegionActor:FindRef(ManualItemId)
	return ManualItemActor
end

function BP_EMGameMode_C:TriggerMechanismWindCreator(ManualArrayId, Grade, IsActive)
	-- DebugPrint("ZJT_ 设置 风场陷阱 ", Grade, IsAvtive)
	for i = 1, ManualArrayId:Length() do
		local ManualItemId = ManualArrayId:GetRef(i)
		local WindCreatorMechanism = self.LevelGameMode.BPBornRegionActor:FindRef(ManualItemId)
		if WindCreatorMechanism then
			WindCreatorMechanism:SetWindCreator(Grade, IsActive)
		else
			print(_G.LogTag, "ZJT_ TriggerMechanismWindCreator ", Grade, IsActive)
		end
	end
end

------------------SnapShot----------------------------
-- function BP_EMGameMode_C:CreateUnitSuccess(Info, RealActor)
--     if not self:CheckLevelLoadedByActor(RealActor, true) then
--     	DebugPrint ("SnapShot: Actor 生成时关卡不存在，该数据返回到SnapShotData  Eid: "..RealActor.Eid.."  UnitId:"..RealActor.UnitId.." UnitType:"..RealActor.UnitType.." Loc", RealActor:k2_GetActorLocation())
--         self:StopAndReturnToSnapShot(Info, RealActor)
-- 		if Info.LoadFinishCallback then
-- 			Info.LoadFinishCallback(RealActor)
-- 		end
--         return false
--     else
-- 		DebugPrint ("CreateUnitSuccess  Eid: "..RealActor.Eid.."  UnitId:"..RealActor.UnitId.." UnitType:"..RealActor.UnitType.." Loc", RealActor:k2_GetActorLocation())
--         self:TryRemoveAllSnapShot(Info, RealActor)
--     end
--     return true
-- end

-- function BP_EMGameMode_C:TryRemoveAllSnapShot(Info, RealActor)
--     if not RealActor.IsFromSnapShot then return end
--     self:RemoveSnapShot(Info.LevelName, Info.Eid)
-- end

-- function BP_EMGameMode_C:StopAndReturnToSnapShot(Info, RealActor)
--     if RealActor.IsFromSnapShot then
--         self:RemoveRecoveringSnapShot(Info.LevelName, Info.Eid)
--     else
--         -- 新增的一个处理，数据第一次生成，生成前检测地图还在，结果生成的时候地图被卸载了，要添加到序列化数据内
--         if RealActor:CheckNeedSnapShot(Const.ECreateSuccess) then
--         	local LevalName = self:GetActorLevelName(RealActor)
-- 			DebugPrint("WorldComposition,新增检测, 数据第一次生成,生成前检测地图还在,结果生成的时候地图被卸载了 :",RealActor.Eid, Info.Creator, LevalName, Info.UnitId, Info.UnitType, Info.Loc)
--             self:AddSnapShotByInit(LevalName, RealActor, Info.Creator, Info.EventName)
--         end
--     end

--     RealActor:EMActorDestroy(EDestroyReason.LevelNotExsit)

--     if Info.MonsterSpawn then 
--     	self:UpdateMonsterSpawnInfo(Info.MonsterSpawn.UnitSpawnId, Info.UnitId)
--     end
-- end

function BP_EMGameMode_C:EMActorDestroy_Lua(Actor, DestroyReason)
	Actor:EMActorDestroy(DestroyReason)
end

function BP_EMGameMode_C:GetMonsterCustomLoc(Monster)
    if self:IsInRegion() then
    	DebugPrint("Error!!! 区域出现Boss被卸载瞬移！请检查！ ViewLocation : ", URuntimeCommonFunctionLibrary.GetViewPortLocation(Monster))
        return FVector(0,0,0)
    end
    local PlayerTarget = nil
    if IsValid(Monster) and IsValid(Monster.BBTarget) then
    	PlayerTarget = Monster.BBTarget
    else
    	-- 改为随机玩家的接口
		-- ds可能存在没有player的情况，GetOneRandomPlayer会拿到空，cbt3排查后暂不需要处理，调用来源仅有三处：
		-- 刷Emergency怪，已提前判断过；肉鸽刷随机怪，仅单机无需处理；关卡卸载移动boss位置，ds关卡不卸载、单机无需处理
    	PlayerTarget = self:GetOneRandomPlayer()
    end
    if self.TacMapManager then
    	local PresetTargetsInfo = {}
    	PresetTargetsInfo[PlayerTarget] = 1
    	local ResLocs = self.TacMapManager:GetSpawnPoints({
    		PresetTargets = PresetTargetsInfo,
			Mode = "Player",
			UnitSpawnRadiusMin = 1000, 
			UnitSpawnRadiusMax = 5000,
			RandomSpawn = true,
			FilterReachable = true,})
		-- lua table
		if ResLocs[PlayerTarget].Num == 0 then
			return FVector(0,0,0)
		end
    	return ResLocs[PlayerTarget][1]
    else
    	local CheckInfo = FPointCheckInfo()
    	CheckInfo:SetCheckInfo(1000, 5000, true, true, true)
    	local ResLoc = self.FixedMonsterSpawn:GetSpawnPointLocations(PlayerTarget, CheckInfo)
		-- TArray
		if ResLoc:Num() == 0 then
			return FVector(0,0,0)
		end
    	return ResLoc[1]
    end
end

function BP_EMGameMode_C:UploadTargetValues(TargetValues, AvatarEid)
    local Avatar = GWorld:GetAvatar()
    -- 单机
	if Avatar then
		Avatar:TriggerTarget(TargetValues)
		return
	end

	local DSEntity = GWorld:GetDSEntity()
	if DSEntity then
		DSEntity:TriggerTarget(TargetValues, AvatarEid)
	end
end


function BP_EMGameMode_C:GetAvatarInfo(Eid)
	if IsStandAlone(self) or MiscUtils.IsListenServer(self) then
		return GWorld:GetAvatar()
	elseif IsDedicatedServer(self) then
		if Eid then
			return self.AvatarInfos[Eid].PlayerInfo
		end
		for AvatarEid, AvatarBattleInfo in pairs(self.AvatarInfos) do
			if AvatarBattleInfo then
				return AvatarBattleInfo.PlayerInfo
			end
		end
	end
end

function BP_EMGameMode_C:TriggerSpawnPet()
	if self.EMGameState.PetDefenceFail == true then
		self.EMGameState:ShowDungeonError("TriggerSpawnPet 宠物防御已经失败，不再创建", Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.Process)
		return
	end
	if not self.RandomPetCreator or not IsValid(self.RandomPetCreator) then
		local PetCreatorInfos = self:GetPetStaticCreatorInfo()
		if PetCreatorInfos:Num() == 0 then
			self.EMGameState:ShowDungeonError("TriggerSpawnPet 当前拼接副本内找不到宠物静态点，请检查配置！", Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.Config)
			return
		end
		self.RandomPetCreator = self:GetPetCreatorNearestToFirstPlayer(PetCreatorInfos)
		if not IsValid(self.RandomPetCreator) then
			self.EMGameState:ShowDungeonError("TriggerSpawnPet 选择宠物静态点失败！", Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.FindObject)
			return
		end
	end

	local SubLevelName = self:GetActorLevelName(self.RandomPetCreator)
	local SubGameMode = self.SubGameModeInfo:FindRef(SubLevelName)
	if not IsValid(SubGameMode) then
		self.EMGameState:ShowDungeonError("TriggerSpawnPet 创建宠物静态点找不到SubGameMode StaticCreatorId: "..self.RandomPetCreator.StaticCreatorId.."SubLevelName: "..tostring(SubLevelName), Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.FindObject)
		return
	end
	SubGameMode.PetActiveLevel = true
	SubGameMode.RandomPetDefenceCoreId = self.DungeonRandomEventDefenceCoreId
	SubGameMode.RandomPetId = self.DungeonRandomEventPetId
	self.RandomPetCreator.UnitId = self.DungeonRandomEventPetId
	self.RandomPetCreator.UnitType = "Pet"
	DebugPrint("BP_EMGameMode_C:TriggerSpawnPet 创建宠物 StaticCreatorId", self.RandomPetCreator.StaticCreatorId, "UnitId", self.RandomPetCreator.UnitId)
	self:TriggerActiveCustomStaticCreator(self.RandomPetCreator.StaticCreatorId, "DungeonPetSpawn", true, SubLevelName)

	self.RandomPetCreator.UnitId = self.DungeonRandomEventDefenceCoreId
	self.RandomPetCreator.UnitType = "Mechanism"
	DebugPrint("BP_EMGameMode_C:TriggerSpawnPet 创建宠物防御核心 StaticCreatorId", self.RandomPetCreator.StaticCreatorId, "UnitId", self.RandomPetCreator.UnitId)
	self:TriggerActiveCustomStaticCreator(self.RandomPetCreator.StaticCreatorId, "DungeonPetDefSpawn", true, SubLevelName)

	self.PetMonsterCreated = true
end

function BP_EMGameMode_C:GetPetCreatorNearestToExit(PetCreatorInfos)
	local LevelLoader = self:GetLevelLoader()
	if not LevelLoader then
		self.EMGameState:ShowDungeonError("TriggerSpawnPet 拿不到LevelLoader", Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.FindObject)
		return nil
	end

	local ExitLevelLoc = LevelLoader:GetExitLevelLocation()
	local MinSquaredDis = math.huge
	local NearestCreator = nil
	for i = 1, PetCreatorInfos:Num() do
		local Creator = PetCreatorInfos[i]
		if Creator then
			local CreatorLoc = Creator:K2_GetActorLocation()
			local SquaredDis = UE4.UKismetMathLibrary.Vector_DistanceSquared(ExitLevelLoc, CreatorLoc)
			if SquaredDis < MinSquaredDis then
				MinSquaredDis = SquaredDis
				NearestCreator = Creator
			end
		end
	end
	return NearestCreator
end

function BP_EMGameMode_C:GetPetCreatorNearestToFirstPlayer(PetCreatorInfos)
	local LevelLoader = self:GetLevelLoader()
	if not LevelLoader then
		self.EMGameState:ShowDungeonError("TriggerSpawnPet 拿不到LevelLoader", Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.FindObject)
		return nil
	end

	local Players = self:GetAllPlayer()
	if not Players or Players:Length() <= 0 then
		self.EMGameState:ShowDungeonError("TriggerSpawnPet 获取不到Players", Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.FindObject)
		return nil
	end
	local Player = Players:GetRef(1)
	local PlayerLoc = Player:K2_GetActorLocation()
	local MinSquaredDis = math.huge
	local NearestCreator = nil
	for i = 1, PetCreatorInfos:Num() do
		local Creator = PetCreatorInfos[i]
		if Creator then
			local CreatorLoc = Creator:K2_GetActorLocation()
			local SquaredDis = UE4.UKismetMathLibrary.Vector_DistanceSquared(PlayerLoc, CreatorLoc)
			if SquaredDis < MinSquaredDis then
				MinSquaredDis = SquaredDis
				NearestCreator = Creator
			end
		end
	end
	return NearestCreator
end

function BP_EMGameMode_C:ShowPetDefenseDynamicEvent(EventName, EventDescribe, EventSuccess, EventFail)
	self.EMGameState:SetPetEventName(EventName)
	self.EMGameState:SetPetEventDescribe(EventDescribe)
	self.EMGameState:SetPetEventSuccess(EventSuccess)
	self.EMGameState:SetPetEventFail(EventFail)
	self.LevelGameMode:AddDungeonEvent("ShowPetDefenseDynamicEvent")
end

function BP_EMGameMode_C:ShowPetDefenseProgress(EventName, EventDescribe, EventSuccess, EventFail)
	self.EMGameState:SetPetEventName(EventName)
	self.EMGameState:SetPetEventDescribe(EventDescribe)
	if self:IsSubGameMode() then
		self.EMGameState:SetPetDefenceCoreId(self.RandomPetDefenceCoreId)
		self.EMGameState:SetPetId(self.RandomPetId)
	else
		self.EMGameState:SetPetDefenceCoreId(self.DungeonRandomEventDefenceCoreId)
		self.EMGameState:SetPetId(self.DungeonRandomEventPetId)
	end
	self.EMGameState:SetPetEventSuccess(EventSuccess)
	self.EMGameState:SetPetEventFail(EventFail)
	self.LevelGameMode:AddDungeonEvent("ShowPetDefenseProgress")
end

function BP_EMGameMode_C:HidePetDefenseProgress(Success)
	self.EMGameState:SetPetSuccess(Success)
	self.EMGameState:SetPetDefenceFail(not Success)
	self.LevelGameMode:RemoveDungeonEvent("ShowPetDefenseDynamicEvent")
	self.LevelGameMode:RemoveDungeonEvent("ShowPetDefenseProgress")
	self.LevelGameMode:RemoveDungeonEvent("PetPlayFailureMontage")
	if Success then
		self.EMGameState:PetAddGuideAllPlayer()
	end
end

function BP_EMGameMode_C:UpdatePetDefenseProgress()
	if IsStandAlone(self) then
		self.EMGameState:OnRep_PetDefenceKilled()
	end
end

function BP_EMGameMode_C:HandleJoinMidwayDungeonRandomEvent(AvatarBattleInfos)
	DebugPrint("[BP_EMGameMode_C:HandleJoinMidwayDungeonRandomEvent] Start")
	local DSEntity = GWorld:GetDSEntity()
	if not DSEntity then
		DebugPrint("[BP_EMGameMode_C:HandleJoinMidwayDungeonRandomEvent] not find DSEntity")
		return
	end

	-- 如果是宠物事件
	if self.DungeonRandomEventPetId then
		DebugPrint("HandleJoinMidwayDungeonRandomEvent Pet ",self.DungeonRandomEventPetId)
		for AvatarEid, Info in pairs(AvatarBattleInfos or {}) do
			DebugPrint("CallServerMethod DungeonEventRealHappendPet ",CommonUtils.ObjId2Str(AvatarEid))
            DSEntity:SendAvatar(AvatarEid, "DungeonEventRealHappendPet", self.DungeonRandomEventPetId)
		end
	end
	
	DebugPrint("[BP_EMGameMode_C:HandleJoinMidwayDungeonRandomEvent] End")
	return
end

function BP_EMGameMode_C:InitDungeonRandomEvent(AvatarBattleInfos)
	if self.HasInitDungeonEvent then
		self:HandleJoinMidwayDungeonRandomEvent(AvatarBattleInfos)
		return
	end
	self.HasInitDungeonEvent = true
	DebugPrint("[BP_EMGameMode_C:InitDungeonEvent] Start")
	local Avatar = self:GetAvatarInfo()
	if not Avatar then
		DebugPrint("[BP_EMGameMode_C:InitDungeonEvent] not find avatar")
		return
	end

	local EventId = Avatar.DungeonRandomEvent.CurrentEventId
	if EventId == 0 then
		DebugPrint("[BP_EMGameMode_C:InitDungeonEvent] not happen event")
		return
	end
	
	local RandomEventExcel = DataMgr.DungeonRandomEvent[EventId]
	if not RandomEventExcel then
		DebugPrint("[BP_EMGameMode_C:InitDungeonEvent] not find event excel <EventId>",EventId)
		return
	end

	local EventType = RandomEventExcel.EventType
	DebugPrint("[BP_EMGameMode_C:InitDungeonEvent] <EventId,EventType>",EventId,EventType)
	if self["InitDungeonRandomEvent" .. EventType] then
		self["InitDungeonRandomEvent" .. EventType](self,Avatar.DungeonRandomEvent[EventType])
	else
		DebugPrint("[BP_EMGameMode_C:InitDungeonEvent] not find event type")
	end
	self:OnDungeonRandomEventInit(EventId)
	local DSEntity = GWorld:GetDSEntity()
	if DSEntity then
		DSEntity:ServerMulticast("DungeonEventRealHappend",EventId,Avatar.Uid)
	else
		Avatar:CallServerMethod("DungeonEventRealHappend",EventId,Avatar.Uid)
	end
end

function BP_EMGameMode_C:InitDungeonRandomEventPet(Detail)
	DebugPrint("[BP_EMGameMode_C:InitDungeonRandomEventPet] Start <PetId>",Detail.PetId)
	local DSEntity = GWorld:GetDSEntity()
	if DSEntity then
		DSEntity:ServerMulticast("DungeonEventRealHappendPet",Detail.PetId)
	end
	if Detail.PetId == 0 then
		DebugPrint("[BP_EMGameMode_C:InitDungeonRandomEventPet] PetId为0")
		return
	end
	self.NeedPetMonster = true
	self.DungeonRandomEventPetId = Detail.PetId
	if not DataMgr.Pet[Detail.PetId] then
		ScreenPrint("[BP_EMGameMode_C:InitDungeonRandomEventPet] 传入的PetId不存在于Pet表中", Detail.PetId)
		return
	end
	self.DungeonRandomEventDefenceCoreId = DataMgr.Pet[Detail.PetId].DefenceCoreID
end

function BP_EMGameMode_C:InitDungeonRandomEventTreasure(Detail)
	DebugPrint("[BP_EMGameMode_C:InitDungeonRandomEventTreasure] Start")
	self.NeedTreasureMonster = true
end

function BP_EMGameMode_C:InitDungeonRandomEventButcher(Detail)
	DebugPrint("[BP_EMGameMode_C:InitDungeonRandomEventButcher] Start")
	self.NeedButcherMonster = true
end

function BP_EMGameMode_C:JudgeEscapeMechanismArray(mechanisms)
	if mechanisms:Num() <= 0 then
		DebugPrint("Error: 找不到撤离机关。")
	elseif mechanisms:Num() > 1 then
		DebugPrint("Warning: 找到了多于一个撤离机关。")
	end
end

function BP_EMGameMode_C:GetEscapeMechanismLocation()
	local Mechanisms = self.EMGameState.MechanismMap:FindRef('ExitTrigger')
	if Mechanisms ~= nil then
		Mechanisms = Mechanisms.Array
		self:JudgeEscapeMechanismArray(Mechanisms)
		for _, Mechanism in pairs(Mechanisms:ToTable()) do
			return Mechanism:K2_GetActorLocation()
		end
	else
		Mechanisms = TArray(FSnapShotInfo())
		local levelLoader = self:GetLevelLoader()
		if levelLoader ~= nil then
			local Results = TArray(FSnapShotInfo())
			self:GetCustomDungeonSnapShotData(Results, levelLoader.exitLevelID)
			for _, Result in pairs(Results) do
				if Result.UnitType == "Mechanism"
					and DataMgr.Mechanism[Result.UnitId] ~= nil
					and DataMgr.Mechanism[Result.UnitId].UnitRealType == 'ExitTrigger' then
					Mechanisms:Add(Result)
				end
			end
		end
		self:JudgeEscapeMechanismArray(Mechanisms)
		for _, Mechanism in pairs(Mechanisms:ToTable()) do
			return Mechanism.Loc
		end
	end
	return nil
end

function BP_EMGameMode_C:GetEscapeMechanismActor()
	local Mechanisms = self.EMGameState.MechanismMap:FindRef('ExitTrigger')
	if Mechanisms == nil then
		DebugPrint("Error: 找不到撤离机关。")
		return nil
	end
	Mechanisms = Mechanisms.Array
	self:JudgeEscapeMechanismArray(Mechanisms)
	for _, Mechanism in pairs(Mechanisms:ToTable()) do
		return Mechanism
	end
	return nil
end

function BP_EMGameMode_C:GetPickupUnitPreloadTable()
	if self.EMGameState.GameModeType == "Blank" then
		return nil
	end
   	local ComponentName = 'BP_'..self.EMGameState.GameModeType..'Component'
    if self:GetDungeonComponent() ~= nil and self:GetDungeonComponent().GetPickupUnitPreloadTable ~= nil then
        return self:GetDungeonComponent():GetPickupUnitPreloadTable()
   	end
	return nil
end

function BP_EMGameMode_C:GetAvatarBuffs(AvatarEid)
	for AvatarEid, AvatarInfo in pairs(self.AvatarInfos) do 
		DebugPrint("Tianyi@ AvatarEid = " .. AvatarEid)
		local AvatarBuffs = AvatarInfo.Buffs 
		for _, BuffInfo in pairs(AvatarBuffs) do 
			DebugPrint("Tianyi@ BuffInfo: " .. BuffInfo.BuffId .. " StartTime: " .. BuffInfo.StartTime .. " Duration: " .. BuffInfo.Duration)
		end
	end
end

function BP_EMGameMode_C:TriggerBattleAchievementUploadOnDungeonEnd(IsWin)
	if IsStandAlone(self) then
		-- 单机战斗成就上报
		local Avatar = GWorld:GetAvatar()
		if Avatar then
			local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
			local EndTag = "Dungeon"
			local EndId = self.LevelGameMode.DungeonId
			if Avatar:IsInHardBoss() then
				EndTag = "HardBoss"
				EndId = self.LevelGameMode.EMGameState.HardBossInfo["DifficultyId"]
			end
			PlayerCharacter.BattleAchievement:OnDungeonEnd(PlayerCharacter, EndTag, EndId, IsWin)
		end
	end

end

function BP_EMGameMode_C:NotifyGameModePlayerDead(Player)
	self:TriggerDungeonComponentFun("OnPlayerDead")
	self:PlayerOnDead(Player)
end

function BP_EMGameMode_C:DestroyActorsByUnitLabels_Lua(UnitLabels)
	local Avatar = GWorld:GetAvatar()
	if Avatar then
		for _,UnitLabel in pairs(UnitLabels:ToTable()) do
			Avatar:RegionActorDataDeadByUnitLabel(UnitLabel.UnitId, UnitLabel.UnitType)
		end
	end
end

function BP_EMGameMode_C:GetRegionIdByLocation(...)
	local LevelLoader = self:GetLevelLoader()
	if not LevelLoader then return end
	return LevelLoader:GetRegionIdByLocation(...)
end

function BP_EMGameMode_C:ActivateDynamicQuestEvent()
	local Avatar = GWorld:GetAvatar()
	if Avatar then
		if Avatar.DynamicQuests and #Avatar.DynamicQuests then
			--ClientEventUtils:ClearAllActiveDynamicEvent()
			local NumDynquest=0
			for _, DynamicQuest in pairs(Avatar.DynamicQuests) do
				NumDynquest=NumDynquest+1
			end
			local NumPerFrame = NumDynquest//5 + 1
			local Coroutine = CreateCoroutine(function (NumPerFrame)
				DebugPrint("@@@ActivateDynamicQuestEvent StartDynamicEvent Start")
				local TaskProcessedNum=0
				for _, DynamicQuest in pairs(Avatar.DynamicQuests) do
					if  DynamicQuest:IsActive() then
						if not ClientEventUtils:CheckDynamicEventStarted(DynamicQuest.DynamicQuestId) then
							ClientEventUtils:StartDynamicEvent(DynamicQuest.DynamicQuestId)
						else
							local CurrentEvent=ClientEventUtils:GetCurrentActiveDynamicEvent(DynamicQuest.DynamicQuestId)
							if CurrentEvent then
								CurrentEvent:ActivateTrigger()
							end
						end
						--ClientEventUtils:StartDynamicEvent(DynamicQuest.DynamicQuestId)
					end
					TaskProcessedNum=TaskProcessedNum+1
					if TaskProcessedNum>=NumPerFrame then
						DebugPrint("@@@ActivateDynamicQuestEvent StartDynamicEvent Yield")
						TaskProcessedNum = 0
						coroutine.yield(false)
					end
				end
				--coroutine.close(Coroutine)
				return true
			end)
			if coroutine.status(Coroutine) == "suspended" then
				DebugPrint("@@@ActivateDynamicQuestEvent StartDynamicEvent First Start")
				local Success, Reason = coroutine.resume(Coroutine, NumPerFrame)
				if not Success then
					DebugPrint("@@@ActivateDynamicQuestEvent StartDynamicEvent Error,Reason: " .. tostring(Reason))
				end
			end
			if coroutine.status(Coroutine) == "suspended" then
				self:AddTimer(0.01, function()
					if coroutine.status(Coroutine) == "suspended" then
						DebugPrint("@@@ActivateDynamicQuestEvent StartDynamicEvent Resume")
						local Success, Reason = coroutine.resume(Coroutine, NumPerFrame)
						if not Success then
							DebugPrint("@@@ActivateDynamicQuestEvent StartDynamicEvent Error,Reason: " .. tostring(Reason))
						end
					elseif coroutine.status(Coroutine) == "dead" then
						DebugPrint("@@@ActivateDynamicQuestEvent StartDynamicEvent Finished")
						self:RemoveTimer("ActivateDynamicQuestEventTimer")	 
					end
				end, true,0,"ActivateDynamicQuestEventTimer")
			end
		end
	end
end

-- function BP_EMGameMode_C:ActivateDynamicQuestEvent()
-- 	local Avatar = GWorld:GetAvatar()
-- 	if Avatar then
-- 		if Avatar.DynamicQuests and #Avatar.DynamicQuests then
-- 			--ClientEventUtils:ClearAllActiveDynamicEvent()
-- 			for _, DynamicQuest in pairs(Avatar.DynamicQuests) do
-- 				RunAsyncTask(self, "CreateDynQuestEvent"..tostring(DynamicQuest.DynamicQuestId), function(CoroutineObj)
-- 					if  DynamicQuest:IsActive() then
-- 						if not ClientEventUtils:CheckDynamicEventStarted(DynamicQuest.DynamicQuestId) then
-- 							ClientEventUtils:StartDynamicEvent(DynamicQuest.DynamicQuestId)
-- 						else
-- 							local CurrentEvent=ClientEventUtils:GetCurrentActiveDynamicEvent(DynamicQuest.DynamicQuestId)
-- 							if CurrentEvent then
-- 								CurrentEvent:ActivateTrigger()
-- 							end
-- 						end
-- 				--ClientEventUtils:StartDynamicEvent(DynamicQuest.DynamicQuestId)
-- 					end
-- 				end)
-- 			end 
-- 		end
-- 	end
-- end

function BP_EMGameMode_C:IsRegionAllReady()
	local RegionDataMgrSubSystem = self:GetRegionDataMgrSubSystem()
    if not RegionDataMgrSubSystem then return false end
    return RegionDataMgrSubSystem:IsRegionAllReady()
end

function BP_EMGameMode_C:TriggerTarget(TargetId, UniqueAttr, PlayerEid)
	local Avatar = GWorld:GetAvatar()
	if Avatar then
		Avatar:ServerTargetFinish(TargetId, UniqueAttr, 1)
	end

	local DSEntity = GWorld:GetDSEntity()
	if DSEntity then
		if PlayerEid == -1 then
			DSEntity:ServerMulticast("ServerTargetFinish", TargetId, UniqueAttr, 1, {})
		else
			local AvatarEid = Battle(self):GetEntity(PlayerEid):GetOwner().AvatarId
			DSEntity:SendAvatar(AvatarEid, "ServerTargetFinish", TargetId, UniqueAttr, 1, {})
		end
	end
end

function BP_EMGameMode_C:ActiveNewTargetPointAOITrigger_Region(Type)
	if Type ~= Const.Hijack then
		GWorld.logger.error("ActiveNewTargetPointAOITrigger_Region 接口当前只支持 Hijack Type")
		return
	end

	if self.EMGameState == nil or self.EMGameState.HijackPathInfo == nil then
		return
	end
	if not self.NewTargetPointAOITriggerList then
		self.NewTargetPointAOITriggerList = {}
	end
	self.NewTargetPointAOITriggerList[Type] = {}
	for _, Path in pairs(self.EMGameState.HijackPathInfo) do
		for _, Point in pairs(Path) do
			if IsAuthority(self) and Point.SpawnTriggerBoxId ~= -1 and Point.SpawnBoxType == ENTPSpawnBoxType.GamemodeEvent then
				Point:SpawnTriggerBox()
				table.insert(self.NewTargetPointAOITriggerList[Type], Point)
			end
		end
	end
end

function BP_EMGameMode_C:DisactiveNewTargetPointAOITrigger_Region(Type)
	if not self.NewTargetPointAOITriggerList or not self.NewTargetPointAOITriggerList[Type] then
		return
	end

	for _, Point in pairs(self.NewTargetPointAOITriggerList[Type]) do
        -- 销毁原因先写死
		Point:DestroyTriggerBox(EDestroyReason.SpecialQuestClear)
	end
end

function BP_EMGameMode_C:OnAllPlayersVoted()
	self:TriggerDungeonComponentFun("OnAllPlayersVoted")
end

function BP_EMGameMode_C:InitMonsterFramingNodeSetting(Setting)
	Setting.Type = EFramingType.ByReplicateNum
	Setting.DistanceToCull = 4500
	Setting.DistanceToCull_FastShare = 15000
	Setting.PreFrameReplicateNum = 30
	Setting.PreFrameReplicateMovementNum = 15
	Setting.SkipFullReplicationFactor = 0.5
	Setting.SkipMovementReplicationFactor = 1.0
end

function BP_EMGameMode_C:GetPlayerEidByAvatarEidStr(AvatarEidStr)
	local PlayerState = UE4.URuntimeCommonFunctionLibrary.GetPlayerStateByAvatarEid(GWorld.GameInstance, AvatarEidStr)
	if PlayerState then
		return PlayerState.Eid
	else
		DebugPrint("BP_EMGameMode_C: AvatarEidStr", AvatarEidStr, "拿不到对应的PlayerState!")
	end
end

function BP_EMGameMode_C:SetGameStatePetRandomDailyCount()
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end

	local CurPetCount = 0
	local AvatarTryPetDict = Avatar.Region2TryPetCount
	for _, Count in pairs(AvatarTryPetDict) do
		CurPetCount = CurPetCount + Count
	end

	self.EMGameState.RegionRandomPetLimitedDailyCount =  DataMgr.GlobalConstant.PetRareDailyLimit.ConstantValue - CurPetCount
end

function BP_EMGameMode_C:GetRegionCharAvgLevel()
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return 99
	end
	if not Avatar.Chars then
		return 99
	end

	local MyHeap = {}
	local HeapMaxSize = 3
	local TryPushHeap = function(value)
		if #MyHeap < HeapMaxSize then
			table.insert(MyHeap, value)
		else
			-- todo: 再优化下
			local MinValue = math.min(table.unpack(MyHeap))
			if value > MinValue then
				for i, v in ipairs(MyHeap) do
					if v == MinValue then
						MyHeap[i] = value
						break
					end
				end
			end
		end
	end

	for _, Char in pairs(Avatar.Chars) do
		if Char and Char.Level then
			TryPushHeap(Char.Level)
		end
	end

	local Sum = 0
	for _, Level in pairs(MyHeap) do
		Sum = Sum + Level
	end
	local Res = math.floor(Sum / #MyHeap)
	DebugPrint("BP_EMGameMode_C:GetRegionCharAvgLevel", Res)
	return Res
end

function BP_EMGameMode_C:UpdateServerTimeOfDay(TimeOfDay)
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end
	Avatar:SetTimeOfDay(TimeOfDay)
end

function BP_EMGameMode_C:GetServerTimeOfDay()
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return 12
	end
	return Avatar.TimeOfDay
end

function BP_EMGameMode_C:SetPlayerInvincible(Player, IsInvincible)
    if not IsValid(Player) then
        return
    end

    DebugPrint("BP_EMGameMode_C: SetPlayerInvincible", IsInvincible, "PlayerEid:", Player.Eid)
    if IsInvincible then
        Battle(self):AddBuffToTarget(Player, Player, Const.InvincibleBuffId, -1)
    else
        Battle(self):RemoveBuffFromTarget(Player, Player, Const.InvincibleBuffId, false, -1)
    end
end

function BP_EMGameMode_C:PausePhantomBTByPlayer(Player, IsPause, Reason)
	if not IsValid(Player) then
        return
    end
	if not Reason then
		Reason = "GameModePauseBT"
	end

	DebugPrint("BP_EMGameMode_C: StopPhantomBTByPlayer", IsPause, "PlayerEid:", Player.Eid)
	local PhantomTeammates = Player:GetPhantomTeammates(false, true)
	for _, Phantom in pairs(PhantomTeammates) do
		if IsValid(Phantom) then
			if IsPause then
				Phantom:PauseBT(Reason)
			else
				Phantom:ResumeBT(Reason)
			end
		end
	end
end

function BP_EMGameMode_C:KeepAliveSpecialLevel(GroupLevelId)
	local LevelLoader = self:GetLevelLoader()
	if not LevelLoader then return end

	LevelLoader:SwitchLoadingGroupId(GroupLevelId)
end

function BP_EMGameMode_C:UnloadingAliveSpecialLevel()
	local LevelLoader = self:GetLevelLoader()
	if not LevelLoader then return end

	LevelLoader:SwitchLoadingGroupId(-1)
end

function BP_EMGameMode_C:GetNextSynthesis2Loc(Hostage)
	return self:TriggerDungeonComponentFun("GetNextHostageLoc")
end

------------------------------------------------------
AssembleComponents(BP_EMGameMode_C)
return BP_EMGameMode_C

