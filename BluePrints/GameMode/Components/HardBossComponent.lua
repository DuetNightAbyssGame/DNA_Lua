
require "UnLua"
require "Const"

local HardBossComponent = {}

------------------BossBattle--------------------------
function HardBossComponent:InitHardBoss(BossBattleId, DifficultyId)
    -- 根据BossBattleId读表，获取Gamemode路径，和等级
    local BossInfo = DataMgr.HardBossMain[BossBattleId]
    if BossInfo == nil then
        DebugPrint("梦魇残声BossId以及难度Id填写错误")
        return
    end
    self.LevelGameMode.BossBattleInfo = {}
    self.LevelGameMode.EMGameState.HardBossInfo = {}

    local DifficultyLevel = DataMgr.HardBossDifficulty[DifficultyId].DifficultyLevel
    if DifficultyLevel == nil then
        DebugPrint("梦魇残声DifficultyLevel填写错误")
        return
    end

    for Index, StaticCreatorId in pairs (BossInfo.MonsterStaticId or {}) do
        local BossStaticCreator = self.LevelGameMode.EMGameState.StaticCreatorMap:Find(StaticCreatorId)
        if BossStaticCreator and BossInfo.MonsterId and BossInfo.MonsterId[Index] then
            BossStaticCreator.UnitType = "Monster"
            BossStaticCreator.UnitId = BossInfo.MonsterId[Index]
            BossStaticCreator.Level = DifficultyLevel - self.LevelGameMode:GetGameModeLevel()
        else
            DebugPrint("梦魇残声静态点配置错误，静态点id", StaticCreatorId)
        end
    end

    self.LevelGameMode.EMGameState.HardBossInfo["BossBattleId"] = BossBattleId
    self.LevelGameMode.EMGameState.HardBossInfo["DifficultyId"] = DifficultyId
    -- 构建table
    self.LevelGameMode.BossBattleInfo["BossStaticCreatorId"] = BossInfo.MonsterStaticId
    self.LevelGameMode.BossBattleInfo["AirWallStaticId"] = BossInfo.AirWallStaticId
    self.LevelGameMode.BossBattleInfo["GameModePath"] = BossInfo.GameModePath
    self.LevelGameMode.BossBattleInfo["StorylinePath"] = BossInfo.StorylinePath
    self.LevelGameMode.BossBattleInfo["MonsterId"] = BossInfo.MonsterId
    -- 处理由于初始化自动开启行为树带来的问题
    -- 用于 开局Seq 和 结算 停止Boss行为树，false停止，true代表可以开启行为树
    self.LevelGameMode.BossBattleInfo["HardBossBTRunning"] = false

    -- 停止全部任务
    GWorld.StoryMgr:Clear()
    -- 删除Monsterspawn
    self.LevelGameMode:DestroyAllMonsterSpawn()

    -- 切换角色(UI未更新)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local Controller = UE4.UGameplayStatics.GetPlayerController(self,0)

    local Avatar = GWorld:GetAvatar()
    local AvatarInfo = AvatarUtils:GetDefaultBattleInfo(Avatar)
    Player:ChangeRole(nil, AvatarInfo)
    -- Player:InitCharacterInfo(Player.InfoForInit)

    local PlayerPoint = self.LevelGameMode.EMGameState:GetTargetPoint(BossInfo.PosDisplayName)
    if BossInfo.PosDisplayName and PlayerPoint then
        Player:K2_SetActorLocation(PlayerPoint:k2_GetActorLocation(), false, nil, false)
        Player:K2_SetActorRotation(PlayerPoint:K2_GetActorRotation(), false)
        Controller:SetControlRotation(FRotator(0,PlayerPoint:K2_GetActorRotation().Yaw,0))
    end
    -- 清空Battle Entities ,并 设置魅影的位置
    self:HardBossClearBattleEntities(true)
    -- 停止魅影AI
    self:HardBossSetPhantomBTEnable(false)
    -- 刷新技能面板UI
    EventManager:FireEvent(EventID.OnSwitchWeapon)
    --隐藏右上角UI
    local UIManager =UIManager(self)
    local HomeBaseMain = UIManager:GetUI('HomeBaseMain') or UIManager:GetUI('BattleMain')
    HomeBaseMain.ListView:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if HomeBaseMain.Battle_Map then
        HomeBaseMain.Battle_Map:ShowHardBoss(false)
    end
    local BattleMainUI = UIManager:GetUIObj("BattleMain")
    if BattleMainUI then
        local TaskBarWidget = BattleMainUI.Pos_TaskBar:GetChildAt(0)
        if TaskBarWidget then
            TaskBarWidget:StopAllAnimations()
            TaskBarWidget:PlayAnimation(TaskBarWidget.Out)
        end
        if BattleMainUI.Btn_Task then
            BattleMainUI.Btn_Task:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end

    self.LevelGameMode.IsInHardBossSettlement = false

    -- 隐藏任务指引点
    MissionIndicatorManager:TriggerAllIndicatorVisible(false)

    -- 重置 在结算临时场景的标识
    self.EMGameState.IsInSettlementScene = nil

    -- 开刷
    self:SpawnHardBossInfo()
    -- 播放sequence
    if self.LevelGameMode.BossBattleInfo["StorylinePath"] then
        local STLCallback = function()
            self:InitBossBattleInfoCallBack()
        end
        self:RunStory(BossInfo.StorylinePath, 10100, STLCallback, STLCallback)
        return
    else
        self:InitBossBattleInfoCallBack()
    end
end

function HardBossComponent:SpawnHardBossInfo()
    -- 刷boss  刷空气墙
    local BossStaticInfo = TArray(0)
    BossStaticInfo:Add(self.LevelGameMode.BossBattleInfo["AirWallStaticId"])
    for _, CreatorId in pairs(self.LevelGameMode.BossBattleInfo["BossStaticCreatorId"] or {}) do
        BossStaticInfo:Add(CreatorId)
    end 
    self.LevelGameMode:TriggerActiveStaticCreator(BossStaticInfo)
    self.LevelGameMode:InitBossBattleSubGameMode(self.LevelGameMode.BossBattleInfo["GameModePath"])
end

function HardBossComponent:InitBossBattleInfoCallBack()
    -- boss开启行为树，并且显示, 此处为nil或者true都可
    self.LevelGameMode.BossBattleInfo["HardBossBTRunning"] = true
    for i, Boss in pairs(self.EMGameState.BossMap) do
        if IsValid(Boss) and Boss:IsRealMonster() then
            Boss:SetActorHideTag("HardBoss", false)
            Boss:StartBT()
        end
    end

    -- 开启魅影的行为树
    self:HardBossSetPhantomBTEnable(true)

    self:SetHardBossStartTime()

    local MonsterId = TArray(0)
    local AirWallCreatorIds = TArray(0)
    for _, Id in pairs(self.LevelGameMode.BossBattleInfo["MonsterId"] or {}) do
        MonsterId:Add(Id)
    end
    AirWallCreatorIds:Add(self.LevelGameMode.BossBattleInfo["AirWallStaticId"])
    self:TriggerActiveBossBattle(MonsterId, AirWallCreatorIds)
end

function HardBossComponent:EndHardBoss(IsWin)
    -- 通知服务器boss战结束
    self:TriggerExitDungeon(IsWin)
end

function HardBossComponent:EndHardBossCallBack(IsWin)
    self.LevelGameMode.IsInHardBossSettlement = false
    -- 删除battle 删除空气墙
    self:PostCustomEvent("EndHardBossCallBack")
    -- 删除全部弹幕
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    Battle(Player):ClearAllDanmaku()
    self.LevelGameMode.BossBattleInfo["HardBossBTRunning"] = true
    self:HardBossClearBattleEntities(false)
    self:HardBossSetPhantomBTEnable(true)
    -- if Player:IsDead() then
    --  Battle(self):QuickRecovery(Player.Eid)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local AvatarInfo = AvatarUtils:GetDefaultBattleInfo(Avatar)
        local PlayerController = Player:GetController()
        PlayerController:SetAvatarInfo(CommonUtils.ObjId2Str(Avatar.Eid), AvatarInfo)
    end

    local Avatar = GWorld:GetAvatar()
    local AvatarInfo = AvatarUtils:GetDefaultBattleInfo(Avatar)
    Player:ChangeRole(nil, AvatarInfo)
    -- end
    --显示右上角UI
    local UIManager = UIManager(self)
    local HomeBaseMain = UIManager:GetUI('HomeBaseMain') or UIManager:GetUI('BattleMain')
    HomeBaseMain.ListView:SetVisibility(UE4.ESlateVisibility.Visible)
    if HomeBaseMain.Battle_Map then
        HomeBaseMain.Battle_Map:ShowHardBoss(true)
    end
    local BattleMainUI = UIManager:GetUIObj("BattleMain")
    if BattleMainUI then
        local TaskBarWidget = BattleMainUI.Pos_TaskBar:GetChildAt(0)
        if TaskBarWidget then
            TaskBarWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
        if BattleMainUI.Btn_Task then
            BattleMainUI.Btn_Task:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    end
    -- 恢复GameMode + 场景内Actor
    self.LevelGameMode:RecoverBossBattleSubGameMode()
    --self:TriggerLoadedEvent()
	self.LevelGameMode:AllowAllFutureCreate()
    local Avatar = GWorld:GetAvatar()
    Avatar:TriggerQuestChain()

    -- 恢复显示任务指引点
    MissionIndicatorManager:TriggerAllIndicatorVisible(true)

    -- 重置 在结算临时场景的标识
    self.EMGameState.IsInSettlementScene = nil
end

-- 一定会跑，时机很早
function HardBossComponent:QuitHardBoss()
    -- 清除
    self.LevelGameMode.BossBattleInfo["HardBossBTRunning"] = false
    self:HardBossClearBattleEntities(false)
    -- 停魅影AI
    self:HardBossSetPhantomBTEnable(false)
    -- 蓝图结束事件
    self:PostCustomEvent("OnHardBossEnd")
end

function HardBossComponent:HardBossClearBattleEntities(IsBegin)
    DebugPrint("GameMode_HardBossComponent: HardBossClearBattleEntities", IsBegin)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local ForwardLocationComponent = Player:GetForwardLocationComponent()
    local Length = 0
    local AllLocations = nil
    if ForwardLocationComponent then
        AllLocations = ForwardLocationComponent:GetAllLocations(true)
        Length = AllLocations:Length()
    end
    if not IsBegin then
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        if GameInstance then
            -- 结算隐藏魅影用
            local Avatar = GWorld:GetAvatar()
            if Avatar:IsInHardBoss() then
                GameInstance:CalculatePhantom()
                GameInstance:AddOnPhantomInitReadyEvent()
            end
        end
    end

    if not IsValid(self.EMGameState.Battle) then
        ScreenPrint("************* GameMode_HardBossComponent:HardBossClearBattleEntities Battle不存在!!!!!! *************")
        Battle(self):ShowBattleError("梦魇残声清除Actor时, Battle不存在！")
        return
    end

    local Index = 0
    local Counter = 0   -- 计数，删除了多少Actor

    local EidKeys = Battle(self):GetAllEntities():Keys()
    for _, Eid in pairs(EidKeys) do
        local Ent = Battle(self):GetEntity(Eid)
        if Ent then
            if not Ent.BpBorn and Ent.EMActorDestroy and (not Ent.IsPlayer or not Ent:IsPlayer()) then
                if Ent.IsPhantom and Ent:IsPhantom() and not Ent:IsDead() then
                    local ContextCopy = Ent.CreateUnitContextCopy
                    ContextCopy.BoolParams:Add("SkipInitWaitCheck", true)
                    self.EMGameState.EventMgr:RegisterCreateData(Ent.Eid, ContextCopy)
                    Ent.ReInitSkipLevelEnter = true
                    Ent:TryInitCharacterInfo("InitInfo")
                    Index = Index + 1
                    if Index <= Length then
                        local Location = AllLocations:GetRef(Index)
                        local HalfHeight = Ent.CapsuleComponent:GetScaledCapsuleHalfHeight()
                        Location.Z = Location.Z + HalfHeight
                        Ent:K2_SetActorLocation(Location, false, nil, false)
                    end
                else
                    Ent:EMActorDestroy(EDestroyReason.HardBossClear)
                    Counter = Counter + 1
                end
            end
        end
    end
    DebugPrint("GameMode_HardBossComponent: 是否进入:", IsBegin, "删除总数:", Counter)
end

function HardBossComponent:HardBossSetPhantomBTEnable(RunEnable)
    -- 开启/关闭魅影的行为树
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    for _, Phantom in pairs(Player:GetPhantomTeammates()) do
        if Phantom ~= Player then
            if RunEnable then
                Phantom:StartBT()
            else
                Phantom:StopBT("HardBoss")
            end
        end
    end
end

-- 在c++重新实现
-- function HardBossComponent:IsInHardBoss()
--     local Avatar = GWorld:GetAvatar()
--     return Avatar and Avatar:IsInHardBoss()
-- end
------------------------------------------------------

return HardBossComponent