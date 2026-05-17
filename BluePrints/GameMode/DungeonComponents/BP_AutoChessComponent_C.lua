--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local M = Class({
	"BluePrints.Common.TimerMgr",
})

M._components = {
	"BluePrints.GameMode.AutoChessComponents.AutoChessBuffManager",
}


function M:InitAutoChessComponent()
    self.GameMode = self:GetOwner()
    if self.GameMode and self.GameMode.PreInitInfo then
        self.MissionId = self.GameMode.PreInitInfo.MissionId
    end
    DebugPrint("AutoChessComponent:Init!", self.GameMode.DungeonId)
    EventManager:AddEvent(EventID.OnAutoChessBattleStart, self, self.OnAutoChessBattleStart)
    EventManager:AddEvent(EventID.OnAutoChessMotivateStart, self, self.OnAutoChessMotivateStart)
    EventManager:AddEvent(EventID.OnCheckIsGameOver, self, self.OnCheckIsGameOver)
    self.AutoChessBattleInfo = {
        --["Ally"] = { --同玩家阵营
        --    [26] = { --Eid
        --        UnitId = xxx, --怪物id
        --        Damage = 100, --造成伤害
        --        Damaged = 90, --被伤害
        --        Heal = 0, --给予治疗
        --    }
        --},
        --["Enemy"] = { --敌对阵营
        --
        --},
    }
    self:RecordPass(self.MissionId)
    self:BindAutoChessEvent()

    -- 关闭风场
    self.PrevWindSetting = UE4.UKismetSystemLibrary.GetConsoleVariableIntValue("foliage.WindEnable")
    GWorld.GameInstance:SetGameScalabilityLevelByName("foliage.WindEnable", 0)
end

function M:RecordPass(MissionId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local DungeonId = DataMgr.AutoChessMission[MissionId].DungeonId
    if Avatar.Dungeons[DungeonId] then
        if Avatar.Dungeons[DungeonId].IsPass then
            GWorld.GameInstance.IsDungeonPass = true
        else
            GWorld.GameInstance.IsDungeonPass = false
        end    
    end
end

function M:GetAutoChessBattleInfo()
    return self.AutoChessBattleInfo
end

function M:ReceiveEndPlay(EndPlayReason)
    self:UnBindAutoChessEvent()
    if self.PrevWindSetting then
        GWorld.GameInstance:SetGameScalabilityLevelByName("foliage.WindEnable", self.PrevWindSetting)
    end
    self.Overridden.ReceiveEndPlay(self, EndPlayReason)
end

function M:UnBindAutoChessEvent()
    EventManager:RemoveEvent(EventID.OnCheckIsGameOver, self)
    EventManager:RemoveEvent(EventID.OnBattleChessFight, self)
end

function M:BindAutoChessEvent()
    EventManager:AddEvent(EventID.OnCheckIsGameOver, self, self.OnCheckIsGameOver)
    EventManager:AddEvent(EventID.OnBattleChessFight, self, self.OnBattleChessFight)
end

function M:RefreshBattleRoleInfo(Camp, Eid, UnitId)
    if not self.AutoChessBattleInfo[Camp] then
        self.AutoChessBattleInfo[Camp] = {}
    end
    if not self.AutoChessBattleInfo[Camp][Eid] then
        self.AutoChessBattleInfo[Camp][Eid] = {UnitId = UnitId}
    end
    if not self.AutoChessBattleInfo[Camp][Eid]["Damage"] then
        self.AutoChessBattleInfo[Camp][Eid]["Damage"] = 0
    end
    if not self.AutoChessBattleInfo[Camp][Eid]["Damaged"] then
        self.AutoChessBattleInfo[Camp][Eid]["Damaged"] = 0
    end
    if not self.AutoChessBattleInfo[Camp][Eid]["Heal"] then
        self.AutoChessBattleInfo[Camp][Eid]["Heal"] = 0
    end
end

function M:InitRoleBattleInfo()
    self.AutoChessBattleInfo = {}
    local RoleInfo = self:GetCurrentChessMonsterInfo(true)
    for _, Info in pairs(RoleInfo) do
        self:RefreshBattleRoleInfo("Enemy", Info.Eid, Info.UnitId)
    end
    RoleInfo = self:GetCurrentChessMonsterInfo(false)
    for _, Info in pairs(RoleInfo) do
        self:RefreshBattleRoleInfo("Ally", Info.Eid, Info.UnitId)
    end
    EventManager:FireEvent(EventID.OnInitRoleBattleInfo, self.AutoChessBattleInfo)
end

function M:OnBattleChessFight(SourceEid, Value, FightType)
    if not self.Player then
        return
    end
    local Source = Battle(self):GetEntity(SourceEid)
    Source = Source:GetRootSource()
    if not Source then
        return
    end
    SourceEid = Source.Eid
    local Camp
    if self.Player:IsEnemy(Source) then
        Camp = "Enemy"
    else
        Camp = "Ally"
    end
    if not self.AutoChessBattleInfo[Camp] then
        self.AutoChessBattleInfo[Camp] = {}
    end
    if not self.AutoChessBattleInfo[Camp][SourceEid] then
        self.AutoChessBattleInfo[Camp][SourceEid] = {UnitId = Source.UnitId}
    end
    if not self.AutoChessBattleInfo[Camp][SourceEid][FightType] then
        self.AutoChessBattleInfo[Camp][SourceEid][FightType] = 0
    end
    self.AutoChessBattleInfo[Camp][SourceEid][FightType] = self.AutoChessBattleInfo[Camp][SourceEid][FightType] + Value
    if FightType == "Damage" then
        EventManager:FireEvent(EventID.OnBattleChessFightDamage, SourceEid, Value)
    end
end

-- 初始化局内UI
function M:InitInGameUI()
    self.UIManager = UIManager(self)
    if not self.UIManager then
        DebugPrint("UIManager无效")
    end
    -- 战斗HUD在 BP_PlayerCharacter_C:InitSceneStartUI() 内隐藏
    -- WBP_AutoChessBattlePage
    self.InGameUI = self.UIManager:LoadUINew("AutoChessBattlePage")
    if not self.InGameUI then
        DebugPrint("AutoChess 布阵UI创建失败")
    end
end

function M:InitAutoChessBaseInfo()
    self.Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if not self.Player then
        DebugPrint("@zyh 当前还没有PlayerCharacter")
        return
    end
    local Rotation = FRotator(0, 0, 0):ToQuat()
    local Location = self.Player:K2_GetActorLocation()
    local SpawnTransform = FTransform(Rotation, Location)
    self.CameraPawn = self:GetWorld():SpawnActor(
            LoadClass('/Game/BluePrints/Char/BP_PlayerCameraPawn.BP_PlayerCameraPawn_C'),
            SpawnTransform,
            UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn
    )
    self.PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)

    -- 动态创建棋盘
    local FormationClass = UE4.UClass.Load("/Game/AssetDesign/GameMode/AutoChess/AutoChess_Formation.AutoChess_Formation")
    local Transform = self.GameMode:GetLevelLoader():GetLevelTransformById("0")
    local FormationLocation = FVector(-60512.0, 5537.0, -4076.0)
    local NewLoc = UKismetMathLibrary.TransformLocation(Transform, FormationLocation)
    local FormationRotation = FRotator(0.0, -23.0, 0.0):ToQuat()
    local SpawnTransform = UE4.FTransform(FormationRotation, NewLoc)
    local AutoChessFormation = GWorld.GameInstance:GetWorld():SpawnActor(
        FormationClass,
        SpawnTransform,
        UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn,
        nil,
        self,
        nil
    )
    
    self:SwitchToCameraPawn()

    self:InitInGameUI()
    -- UI配置
    self:GetAutoChessFormation()
    self.InGameUI.AutoChessFormation = self.AutoChessFormation
    self.AutoChessFormation:BindCubeEvent("Click", self.InGameUI, self.InGameUI.ClickChess) -- 绑定棋盘格点击事件到UI
    self.InGameUI.Index2CubeInfo = self:GetCurrentChessMonsterInfo(false)
    self.InGameUI.Index2EnemyCubeInfo = self:GetCurrentChessMonsterInfo(true)
    self.InGameUI.CameraPawn = self.CameraPawn
    self.CameraPawn:SwitchInputState(false)

    -- 部署敌方
    self:DeployEnemyMonster()
end

function M:DeployEnemyMonster()
    if not self.MissionId then
		DebugPrint("DeployEnemyMonster: MissionId is nil!")
        return
	end

    self.ACFormationId = DataMgr.AutoChessMission[self.MissionId] and DataMgr.AutoChessMission[self.MissionId].ACFormationId
    if not self.ACFormationId then
		DebugPrint("DeployEnemyMonster: ACFormationId is nil! self.MissionId: ", self.MissionId)
        return
	end

    local ACFormations = DataMgr.AutoChessFormat[self.ACFormationId]

    -- 形如"ACLocation1"，取出末尾的数字，且必须以"ACLocation"开头
    local function get_last_number(s)
        if type(s) ~= "string" then
            return nil
        end
        local num = s:match("^ACLocation(%d+)$")
        return num and tonumber(num) or nil
    end
    
    local EnemyChessEquips = {}

    for Location, Info in pairs(ACFormations) do
        local CubeIndex = get_last_number(Location)
        if CubeIndex then
            -- 相对于策划配的表要减一
            CubeIndex = CubeIndex - 1
            -- 一个格子只会有一个怪
            for CombatChessId, Equipments in pairs(Info) do
                EnemyChessEquips[CombatChessId] = Equipments
                EventManager:FireEvent(EventID.OnAutoChessCreateMonster, CombatChessId, CubeIndex, true, Equipments)
                break
            end
        end
    end

    self.InGameUI.EnemyChessEquips = EnemyChessEquips
end

function M:SwitchToCameraPawn()
    if not self.CameraPawn then
        DebugPrint("@zyh 当前还没有CameraPawn")
        return
    end
    self.PlayerController:SetLastPawn(self.Player)
    self.PlayerController:Possess(self.CameraPawn)
    local PCC = self.CameraPawn:GetComponentByClass(UPlayerCameraComponent)
    if PCC then
        self.PlayerController:SetAudioListenerOverride(PCC, Const.ZeroVector, Const.ZeroRotator)
    else
        DebugPrint("@zyh 自走棋关卡拿不到相机组件")    
    end
    self.CameraPawn.RealPlayer = self.Player
    self.CameraPawn:SetCameraPitch(-65, -15)
    self.CameraPawn:CleanTouchInput()
end

function M:SwitchToPlayer()
    self.PlayerController:Possess(self.Player)
    if self.Player.AudioListener then
        self.PlayerController:SetAudioListenerOverride(self.Player.AudioListener, Const.ZeroVector, Const.ZeroRotator)
    end
    local CameraControlComponent = self.Player.CameraControlComponent
    self.PlayerController.PlayerCameraManager.ViewPitchMin = CameraControlComponent.CameraPitchLimitMin
    self.PlayerController.PlayerCameraManager.ViewPitchMax = CameraControlComponent.CameraPitchLimitMax
end

function M:TriggerAutoChessOnEnd()
    self:SwitchToPlayer()
    self.InGameUI:SetInputModeCustom(false)
end

function M:GetAutoChessFormation()
    if self.AutoChessFormation and UE4.UKismetSystemLibrary.IsValid(self.AutoChessFormation) then
        return self.AutoChessFormation
    end
    local FormationClass = LoadClass("/Game/AssetDesign/GameMode/AutoChess/AutoChess_Formation.AutoChess_Formation")
    if not FormationClass then
        DebugPrint("AutoChessComponent: FormationClass nil")
        return nil
    end
    local Arr = TArray(AActor)
    UE4.UGameplayStatics.GetAllActorsOfClass(self, FormationClass, Arr)
    if Arr:Length() > 0 then
        self.AutoChessFormation = Arr[1]
    end
    return FormationClass
end

function M:GetCurrentChessMonsterInfo(IsEnemy)
    local Formation = self:GetAutoChessFormation()
    if not Formation then
        return nil
    end
    if Formation.GetCurrentChessMonsterInfo then
        return Formation:GetCurrentChessMonsterInfo(IsEnemy)
    end
    return nil
end

function M:GetCurrentChessMonsterEid()
    local MonsterEids = {}
    local Monsters = self:GetCurrentChessMonsterInfo(false)
    local EnemyMonsters = self:GetCurrentChessMonsterInfo(true)
    for Index, Info in pairs(Monsters) do
        table.insert(MonsterEids, Info.Eid)
    end
    for Index, Info in pairs(EnemyMonsters) do
        table.insert(MonsterEids, Info.Eid)
    end
    return MonsterEids
end

-- 战斗开始时
function M:OnAutoChessBattleStart()
    self:OnBattleStartInitEquipBuff()
    self:RecordPlayerCurRankInfo()
    self:InitRoleBattleInfo()
    self.GameMode:EventOnBattleStart()
end

-- 记录玩家当前段位信息
function M:RecordPlayerCurRankInfo()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    GWorld.GameInstance.PreRankLevel = Avatar.AutoChess.RankLevel
    GWorld.GameInstance.PreRankScore = Avatar.AutoChess.RankScore
end

-- 激励阶段开始时
function M:OnAutoChessMotivateStart()
    self:OnStartMotivateBuff()
end

-- @param Unit 死亡的怪物
function M:OnCheckIsGameOver(Unit)
    local Monsters = self:GetCurrentChessMonsterInfo(false)
    local EnemyMonsters = self:GetCurrentChessMonsterInfo(true)
    local FriendAliveMonsters = 0
    local EnemyAliveMonsters = 0
    for Index, Info in pairs(Monsters) do
        if Battle(self):GetEntity(Info.Eid) and Unit.Eid ~= Info.Eid then
            FriendAliveMonsters = FriendAliveMonsters + 1
        end
    end
    for Index, Info in pairs(EnemyMonsters) do
        if Battle(self):GetEntity(Info.Eid) and Unit.Eid ~= Info.Eid then
            EnemyAliveMonsters = EnemyAliveMonsters + 1
        end
    end

    if EnemyAliveMonsters * FriendAliveMonsters == 0 then
        --副本玩法结束，进入结算
        local IsWin = EnemyAliveMonsters <= FriendAliveMonsters
        self:TriggerRealGameEnd(IsWin)
    end
end

function M:TriggerRealGameEnd(IsWin)
    local Params = {}
    Params.BlackScreenHandle = "AutoChessEnd"
    Params.InAnimationPlayTime = 0.5
    Params.InAnimationObj = self
    Params.InAnimationCallback = function()
        if IsWin then
            self.GameMode:TriggerDungeonWin()
        else
            self.GameMode:TriggerDungeonFailed()
        end
    end
    UIManager(self):ShowCommonBlackScreen(Params)
end

function M:DisableCubeInteraction()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    PlayerController.bEnableMouseOverEvents = false
    PlayerController.bEnableClickEvents = false

    EventManager:FireEvent(EventID.OnAutoChessDisableCubeInteraction)
end

function M:IsMonsterCreating()
    if not self.AutoChessFormation then
        self:GetAutoChessFormation()
    end

    if self.AutoChessFormation.IsMonsterCreating then
        return self.AutoChessFormation:IsMonsterCreating()
    end
    return false
end

AssembleComponents(M)
return M
