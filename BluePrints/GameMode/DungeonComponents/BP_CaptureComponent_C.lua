require "UnLua"

local BP_CaptureComponent_C = Class({
	"BluePrints.Common.TimerMgr",
})
--------------------GameMode 流程&事件相关------------------------
function BP_CaptureComponent_C:InitCaptureComponent()
	self.GameMode = self:GetOwner()
	local CaptureData = DataMgr.Capture[self.GameMode.DungeonId]
	if not CaptureData then
		GameState(self):ShowDungeonError("CaptureComponent:当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id："..self.GameMode.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
		return
	end
	self.CaptureMonsterId = self:GetCaptureMonsterId(CaptureData)
	if not self.CaptureMonsterId then
		GameState(self):ShowDungeonError("CaptureComponent:获取捕获怪Id失败!", Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
		return
	end
	self.CaptureMonsterLoc, self.CaptureLevelId, self.CapturePathLevelArray = self.GameMode.TacMapManager:GenerateCapturePath(CaptureData.Dis)

    self.CaptureCreator = self:GetWorld():SpawnActor(self.GameMode.StaticCreatorPath, UE4.FTransform(FVector(0,0,0), self.CaptureMonsterLoc + FVector(0,0,100)) , UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
    self.CaptureCreator.StaticCreatorId = CaptureData.CaptureCreatorId
    self.CaptureCreator.UnitType = "Monster"
    self.CaptureCreator.Level = CaptureData.FixLevel or 0
    self.CaptureCreator.UnitId = self.CaptureMonsterId
    self.GameMode.EMGameState.StaticCreatorMap:Add(self.CaptureCreator.StaticCreatorId, self.CaptureCreator)
    self.PostEventCaptureTargetSpawnEnable = true

	self.GameMode.EMGameState:SetIsMonsterWaitForCapture(false)
	self.CaptureMonsterEid = 0
	self.CaptureMonsterData = {}

	self.IsFirstSeen = false
end

function BP_CaptureComponent_C:InitCaptureBaseInfo()
	if not self.CaptureMonsterId or not self.GameMode.TacMapManager or not self.CaptureLevelId then return end
	-- 开启 玩法激活时间计时
	self.GameMode.EMGameState:StartGameTime()
	self.EscapeLoc = nil

	local CaptureExitCreatorInfos = TMap(0, UObject)
	self.GameMode.EMGameState:GetSubStaticCreatorInfo(self.CaptureLevelId, CaptureExitCreatorInfos)
	
	if CaptureExitCreatorInfos:Length() <= 0 then
		GameState(self):ShowDungeonError("CaptureComponent:怪物逃脱关卡内不存在逃脱点，请检查配置，LevelName："..self.CaptureLevelId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
	end
	for Id, Creator in pairs(CaptureExitCreatorInfos) do
		if IsValid(Creator) and Creator.CaptureMonsterExit then
			self.EscapeLoc = Creator:K2_GetActorLocation()
			self.GameMode:TriggerActiveCustomStaticCreator(Id, "", true, self.CaptureLevelId)
			DebugPrint("捕获玩法，刷新怪物逃脱点  CaptureLevelName:", self.CaptureLevelId, "CreatorId:", Creator.StaticCreatorId)
			self:ActiveCaptureMonster()
			return
		end
	end
    self:ActiveCaptureMonster()
	GameState(self):ShowDungeonError("CaptureComponent:获玩法刷新逃脱点失败! 请检查蓝图配置    LevelId:   "..self.CaptureLevelId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
end

function BP_CaptureComponent_C:ActiveCaptureMonster()
	local CpatureArray = TArray(0)
	CpatureArray:Add(self.CaptureCreator.StaticCreatorId)
	self.GameMode:TriggerActiveStaticCreator(CpatureArray, "CaptureMonster")
end

function BP_CaptureComponent_C:OnStaticCreatorEvent(EventName, Eid, UnitId, UnitType, CreatorId)
	if EventName == "CaptureMonster" then
		self.CaptureMonsterEid = Eid
		DebugPrint("CaptureComponent: 捕获怪已激活，Eid", Eid, "UnitId", UnitId, self.CaptureMonsterId, CreatorId)
	end
end

function BP_CaptureComponent_C:GetCaptureMonsterId(CaptureData)
	local TotalWeight = 0
	for i, Data in pairs(CaptureData.Capture) do
		TotalWeight = TotalWeight + Data.Weight
	end
	local RandomValue = math.random(0, TotalWeight-1)
	local RandomCount = 0
	for i, Data in pairs(CaptureData.Capture) do
		RandomCount = RandomCount + Data.Weight
		if RandomValue < RandomCount then 
			return Data.CaptureMonsterId
		end
	end
	return CaptureData.Capture[1].CaptureMonsterId
end

function BP_CaptureComponent_C:OnCaptureSuccess()
	if self.GameMode:GetNeedCreateEmergencyMonster("Treasure") == true then
		self.GameMode:TryCreateEmergencyMonster("Treasure")
	end
	if self.GameMode:GetNeedCreateEmergencyMonster("Pet") == true then
		self.GameMode:TriggerSpawnPet()
	end
end

function BP_CaptureComponent_C:InitTreasureMonsterEecapeLoc(TreasureMonster)
	local mechanimArray = self.GameMode.EMGameState.MechanismMap:FindRef('AOITriggerBox')
	if mechanimArray then
		local targetLoc=self.GameMode:GetEscapeMechanismLocation()
		if targetLoc then
			TreasureMonster:SetTreasureMonsterTarget(targetLoc)
		end
	end
end

---------------------- 捕获怪起身倒计时相关 -------------------------
function BP_CaptureComponent_C:OnMonsterWaitForCapture(CaptureMonster)
	DebugPrint("CaptureComponent: OnMonsterWaitForCapture  UnitId: "..self.CaptureMonsterId.."Eid: "..self.CaptureMonsterEid)
	local CaptureParam = CaptureMonster.Data.CaptureParam
	if not CaptureParam or not CaptureParam.RecoverTime then
		GameState(self):ShowDungeonError("CaptureComponent:捕获怪没有CaptureParam！ UnitId:"..self.CaptureMonsterId.."Eid: "..self.CaptureMonsterEid.."=="..CaptureMonster.Eid, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
		return
	end

	self:SetCaptureRecoveryTime(CaptureParam.RecoverTime)		-- 初始化倒计时长度
	self.GameMode:AddDungeonEvent("CaptureMonsterRecovery")		-- 显示ui

    self:AddTimer(0.1, self.UpdateCaptureRecoveryTimer, true, 0, "CaptureRecovery")
	self.GameMode.EMGameState:SetIsMonsterWaitForCapture(true)
	self.CaptureMonsterData = CaptureMonster.Data
end

function BP_CaptureComponent_C:UpdateCaptureRecoveryTimer()
	self:AddCaptureRecoveryTime(-0.1)
	if self:GetCaptureRecoveryTime() <= 0 then
		self:RemoveCaptureRecoveryTimer()
		self:OnCaptureRecoveryTimerEnd()
	end
end

function BP_CaptureComponent_C:OnCaptureRecoveryTimerEnd()
	self.GameMode.EMGameState:SetIsMonsterWaitForCapture(false)
	local CaptureMonster = Battle(self):GetEntity(self.CaptureMonsterEid)
	if IsValid(CaptureMonster) then
		-- 捕获怪当前在场
		DebugPrint("CaptureComponent: OnCaptureRecoveryTimerEnd 捕获怪在场")
		CaptureMonster:SetMonWaitForCaught(false)
		CaptureMonster:SetCharacterTag("Idle")
		CaptureMonster:StopMontage()
		Battle(self):CaptureMonsterStandUp(CaptureMonster.Eid)
		self.GameMode:TriggerGameModeEvent("OnCaptureTargetRecover", CaptureMonster)
		if CaptureMonster.CapturePlayer then
			CaptureMonster.InteractiveComponent:EndPressInteractive(CaptureMonster.CapturePlayer, false)
		end
	else
		-- 捕获怪不在场（视为已序列化）
		DebugPrint("CaptureComponent: OnCaptureRecoveryTimerEnd 捕获怪不在场")
		self.GameMode:TriggerGameModeEvent("OnCaptureTargetRecover", nil)
	end

	--self.GameMode:SetClientDungeonUIState(Const.EDungeonUIState.AfterTarget)
	self.GameMode:RemoveDungeonEvent("CaptureMonsterRecovery")
end

function BP_CaptureComponent_C:SetCaptureRecoveryTime(Value)
	self.GameMode.EMGameState:SetCaptureRecoveryTime(Value)
	if IsStandAlone(self) then
		self.GameMode.EMGameState:OnRep_CaptureRecoveryTime()
	end
end

function BP_CaptureComponent_C:AddCaptureRecoveryTime(Value)
	self.GameMode.EMGameState:SetCaptureRecoveryTime(self.GameMode.EMGameState.CaptureRecoveryTime + Value)
	if IsStandAlone(self) then
		self.GameMode.EMGameState:OnRep_CaptureRecoveryTime()
	end
end

function BP_CaptureComponent_C:GetCaptureRecoveryTime()
	return self.GameMode.EMGameState.CaptureRecoveryTime
end

function BP_CaptureComponent_C:RemoveCaptureRecoveryTimer()
	DebugPrint("CaptureComponent: CaptureRecoveryTimer已移除")
	self:RemoveTimer("CaptureRecovery")
end

function BP_CaptureComponent_C:PauseCaptureRecoveryTimer()
	DebugPrint("CaptureComponent: CaptureRecoveryTimer已暂停")
	self:PauseTimer("CaptureRecovery")
end

function BP_CaptureComponent_C:UnPauseCaptureRecoveryTimer()
	DebugPrint("CaptureComponent: CaptureRecoveryTimer恢复暂停")
	self:UnPauseTimer("CaptureRecovery")
end

-----------------------------------------------------------------

return BP_CaptureComponent_C

