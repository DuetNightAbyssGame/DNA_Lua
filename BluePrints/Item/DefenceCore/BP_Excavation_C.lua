--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_Excavation_C = Class({
    "BluePrints/Item/DefenceCore/BP_DefenceBase_C",
    "BluePrints.Common.TimerMgr"
})

function BP_Excavation_C:AuthorityInitInfo(Info)
    BP_Excavation_C.Super.AuthorityInitInfo(self,Info)
    --耗能速度
    self.DepleteRate = 1
    self.AttractRange = self.UnitParams["AttractRange"]
    self.MaxEnergy = 100
    self.NowEnergy = self.UnitParams["NowEnergy"]
    -- self.Efficiency = self.UnitParams["Efficiency"]
    --当前进度
    self.Progress = 0
    --上一次关键节点的进度
    self.PreProgress = 0
    self.BatteryEnergy = DataMgr.GlobalConstant["BatteryEnergy"]["ConstantValue"]
    self.BatteryNum = self.NowEnergy/self.BatteryEnergy

    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    self.CompleteRewardNum = DataMgr.Excavation[GameMode.DungeonId].CompleteRewardNum
    --吸满电池时候的耗能速度倍率
    self.MultiDepleteRate = DataMgr.Excavation[GameMode.DungeonId]["MultiDepleteRate"] or 1
    self.CreateRewardNum = 0

    local RandomCreator = Info:FindObjectParams("RandomCreator")
    self.CreatorId = RandomCreator.StaticCreatorId
    self.RandomCreatorId = Info.IntParams:Find("RandomCreatorId")
    RandomCreator:AddUserEid(self)
    -- self.IsActive = true
    -- self:ActiveOnServer(Info)

	self.GuideOrderIndex = GameMode:TriggerDungeonComponentFun("RegisterGuideOrder", self.Eid)  -- GuideOrderIndex 从1开始计数
end

function BP_Excavation_C:CommonInitInfo(Info)
    self.StartDigStateId = self.UnitParams["StartDigStateId"]
    self.StopDigStateId = self.UnitParams["StopDigStateId"]
    BP_Excavation_C.Super.CommonInitInfo(self, Info)
    self.Efficiency = self.UnitParams["Efficiency"]
end

function BP_Excavation_C:InitExcavationMonsterSpawn(Info)
    local MonsterSpawnId
    MonsterSpawnId = Info.IntParams:Find("MonsterSpawnId")
    if not MonsterSpawnId then return end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local Ids = TArray(0)
    Ids:Add(MonsterSpawnId)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    GameState.ExcavationMechanismInfos:Add(self.Eid, MonsterSpawnId)
    GameMode:TriggerCreateMonsterSpawn(Ids)
end

function BP_Excavation_C:StartDig()
    if IsAuthority(self) then
        self:RemoveTimer("ExcavationCreateReward")
        self:AddTimer(1, BP_Excavation_C.CreateReward, true, 0, "ExcavationCreateReward")
    end
    if not IsAuthority(self) or IsStandAlone(self) then
        self:OnStartDig()
        self.Mesh:PlayAnimation(self.DigAnim,true)
    end
end

function BP_Excavation_C:StopDig()
    if not IsAuthority(self) or IsStandAlone(self) then
        self:OnStopDig()
        self.Mesh:PlayAnimation(self.IdleAnim,true)
    end
    if IsAuthority(self) then
        self:RemoveTimer("ExcavationCreateReward")
    end
end

function BP_Excavation_C:ActiveOnServer()
    if self.IsActive == true then
        self:ActiveDefence()
        if IsAuthority(self) then
            self.BatteryHandle = self:AddTimer(0.5, self.AttractBattery,true)
        end
    end
end

--客户端激活表现，IsActive变化说明要播放激活或停止激活时对应的特效
function BP_Excavation_C:OnActiveStateChange()
    self.Super.OnActiveStateChange(self)
    if self.IsActive then
        AudioManager(self):PlayFMODSound(self, nil, "event:/sfx/common/scene/gear/excavation_create", "ExcavationCreate")
    end
end

--吸电池
function BP_Excavation_C:AttractBattery()
    -- 吸电池的结构在 player.BatteryEids，里面有几个电池就全吸完，然后把电池销毁
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
	for _, Player in pairs(GameMode:GetAllPlayer()) do
        local Distance = (Player:K2_GetActorLocation()-self:K2_GetActorLocation()):Size()
        if Distance<=self.AttractRange then
            if not self:IsExistTimer("ExcavationCreateReward") and self.NowEnergy > 0 then
                self:ChangeState("Manual", Player.Eid, self.StartDigStateId)
            end
            if self.BatteryNum >= self.MaxEnergy/self.BatteryEnergy then
                self.DepleteRate = self.DepleteRate * self.MultiDepleteRate
                self:RemoveTimer(self.BatteryHandle)
                return
            end
            local NowBatteryNum = math.floor(math.min(self.BatteryNum + Player.BatteryNum, self.MaxEnergy/self.BatteryEnergy) - self.BatteryNum)
            if NowBatteryNum > 0 then
                self:OnCharge(Player.Eid)
            end
            self.BatteryNum = self.BatteryNum + NowBatteryNum
            self.PreEnergy = self.NowEnergy
            self.NowEnergy = math.min(self.NowEnergy + NowBatteryNum * self.BatteryEnergy,self.MaxEnergy)
            GameState.BatteryToTalNum = GameState.BatteryToTalNum - Player.BatteryNum
            Player.BatteryNum = Player.BatteryNum - NowBatteryNum
            if NowBatteryNum > 0 then
                Battle(self):ReduceBuffLayerFromTarget(Player, Player, Const.BarriyBuffId, NowBatteryNum, false)
            end
            if self.PreEnergy ~= self.NowEnergy then
                self:OnAttractBattery(self.Eid, self.NowEnergy-self.PreEnergy)
            end
        end
    end
end

function BP_Excavation_C:CreateReward()
    self.NowEnergy = math.max(self.NowEnergy - self.DepleteRate, 0)
    self.Progress = self.Progress + self.DepleteRate
    --10点进度为一层，距离上次关键节点又过了多少层
    local RealProgress = (self.Progress - self.PreProgress) // 10
    if self.PreProgress < 50 and self.Progress >= 50 then
        self:CreateNextExcavation()
    end
    if RealProgress >= 1 then
        for i = 1, RealProgress do
            self:RealCreateReward(self.Progress//10)
            self.PreProgress = self.PreProgress + 10
        end
    end
    if self.Progress >= 100 then
        --进度达到100时，额外产出
        for i = 0, self.CompleteRewardNum - 1 do
            self:RealCreateReward(11 + i)
        end
        self:MissionComplete()
        self:CreateNextExcavation()
    end
    if self.NowEnergy <= 0 then
        if self.Progress < 100 then
            self:TriggerGameModeEvent("OnEnergyZero")
        end
        self:ChangeState("Manual", 0, self.StopDigStateId)
    end
end

--创建新的挖掘机
function BP_Excavation_C:CreateNextExcavation()
    --print(_G.LogTag,"CreateNextExcavation")
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    GameMode:TriggerDungeonComponentFun("TriggerPrepareActiveExcavation")
end

--产生奖励物
function BP_Excavation_C:RealCreateReward(CreateNum)
    -- 要产生的item id  在 gamestate.ExcavationItemId
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    for i = 1, self.Efficiency do
        self.CreateRewardNum = self.CreateRewardNum + 1
        local ExtraInfo = {UniqueSign = self.Eid.."_"..self.CreateRewardNum}
        GameMode:TriggerRewardEvent(self.UnitId, CommonConst.RewardReason.Repeated, self.RewardPosition:K2_GetComponentToWorld(), ExtraInfo)
    end
    self:TriggerBluePrintEvent("OnCreateReward")
    -- self:OnCreateReward()
end

--任务完成
function BP_Excavation_C:MissionComplete()
    --print(_G.LogTag,"MissionComplete")
    self:RemoveTimer(self.BatteryHandle)

    if not self.bTriggerGameMode then
        self.bTriggerGameMode = true
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        GameMode:TriggerDungeonComponentFun("UpdateNowExcavNum", -1)
        GameMode:TriggerDungeonComponentFun("UpdateFinishedExcavNum", 1)
        
        self:TriggerGameModeEvent("OnExcavationProgressEnough")
        self:ChangeState("Manual", 0, self.StopDigStateId)
        self:TriggerBluePrintEvent("OnMissionComplete")

        local GameState = UE4.UGameplayStatics.GetGameState(self)
        GameState.DefBaseMap:Remove(self.Eid)
        GameState.HatredCombatProp:Remove(self.Eid)

       
        GameMode:TriggerDungeonComponentFun("JudgeNextTurn")
    end
    self:EMActorDestroy(EDestroyReason.MechanismDead)
end

function BP_Excavation_C:ShowDeath()
    BP_Excavation_C.Super.ShowDeath(self)
    print(_G.LogTag,"LXZ ShowDeath", self:GetName())
    EventManager:FireEvent(EventID.OnExcavationItemChange, "Remove", self.Eid)
end

function BP_Excavation_C:OnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
    print(_G.LogTag,"LXZ OnDead Excavation", self:GetName())
    BP_Excavation_C.Super.OnDead(self, KillMineRoleEid, KillMineSkillId, DeathReason)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if IsAuthority(self) and not self.bTriggerDeadGameMode then
        self.bTriggerDeadGameMode = true
        GameMode:TriggerDungeonComponentFun("UpdateNowExcavNum", -1)
        GameMode:TriggerDungeonComponentFun("UpdateTurnDeadExcavNum", 1)
        self:CreateNextExcavation()
        GameMode:TriggerGameModeEvent("OnExcavationDestroyed")
        GameMode:TriggerDungeonComponentFun("JudgeNextTurn")
    end
    self:ChangeState("Manual", 0, self.StopDigStateId)
    if IsStandAlone(self) or IsClient(self) then
        self:OnExcavationDestroyed()
    end
    self:RemoveTimer(self.BatteryHandle)  
    local function DelayDestroy()
        self:EMActorDestroy(EDestroyReason.MechanismDead)
    end  
    self:AddTimer(0.1, DelayDestroy)
end

-- function BP_Excavation_C:RegisterToGameState()
--     if not IsAuthority(self) then
--         print(_G.LogTag,"not IsAuthority")
--         return
--     end
--     local GameState = UE4.UGameplayStatics.GetGameState(self)
--     if GameState == nil then
--         print(_G.LogTag,"GameState is nil")
--         return
--     end
--     GameState:RegisterMechanism(self,self:GetUnitRealType())
-- end

function BP_Excavation_C:OnActorReady(Info)
    BP_Excavation_C.Super.OnActorReady(self, Info)
    if IsAuthority(self) then
        self:InitExcavationMonsterSpawn(Info)
    end
end

function BP_Excavation_C:ClientInitInfo(Info)
    BP_Excavation_C.Super.ClientInitInfo(self,Info)

    --EventManager:FireEvent(EventID.OnExcavationItemChange, "Add", self.Eid)
    local ExcavationUI = Utils.UIManager(self):GetUIObj("DungenonExcavation")
    if ExcavationUI then
        ExcavationUI:OnExcavationItemChange("Add", self.Eid)
    else
        -- 联机时后加入的玩家可能出现：挖掘机先同步到客户端、但这时挖掘关卡ui还没加载，导致客户端ui进度条不显示的情况
        -- 若以后有办法能保证客户端关卡ui加载顺序在挖掘机同步之前，可以把这个Timer删了
        DebugPrint("BP_Excavation_C找不到ExcavationUI", self.Eid)
        self:AddTimer(5, function()
            ExcavationUI = Utils.UIManager(self):GetUIObj("DungenonExcavation")
            if ExcavationUI then
                ExcavationUI:OnExcavationItemChange("Add", self.Eid)
                self:RemoveTimer("ExcavationUIAddItem")
            end
        end, true, 0, "ExcavationUIAddItem")
    end

    -- 联机时可能出现客户端更新指引时，TargetActor并没有同步下来的情况。挖掘机客户端初始化完成后再更新一次指引
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local SceneManager = GameInstance:GetSceneManager()
    if SceneManager then
        SceneManager:UpdateOneSceneGuideIcon(self.Eid, true, false)
    end
end

function BP_Excavation_C:OnCharge(Eid)
    self.Overridden.OnCharge(self)
end

function BP_Excavation_C:OnMissionComplete()
    self:OnExcavationProgressEnough()
    EventManager:FireEvent(EventID.OnExcavationFinish, self.Eid)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    GameState.DefBaseMap:Remove(self.Eid)
    GameState.HatredCombatProp:Remove(self.Eid)
end

function BP_Excavation_C:OnEnterState(NowStateId)
    self.Overridden.OnEnterState(self, NowStateId)
    if NowStateId == self.StartDigStateId then
        self:StartDig()
    elseif NowStateId == self.StopDigStateId then
        self:StopDig()
    end
end

function BP_Excavation_C:OnAttractBattery_Lua(ExcavationEid, BatteryEnergy)
    if not IsAuthority(self) or IsStandAlone(self) then 
        EventManager:FireEvent(EventID.OnAttractBattery, ExcavationEid, BatteryEnergy)
    end
end

return BP_Excavation_C
