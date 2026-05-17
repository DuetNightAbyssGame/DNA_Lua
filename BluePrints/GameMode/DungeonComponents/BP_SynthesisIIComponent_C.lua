--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_SynthesisIIComponent_C = Class({
	"BluePrints.Common.TimerMgr",
})

--------------------GameMode 流程&事件相关------------------------
function BP_SynthesisIIComponent_C:InitSynthesisIIComponent()
    self.GameMode = self:GetOwner()
    self.IconPathYellow = "MainMission"
    self.IconPathRed = "DefeatMission"
    self.IconPathSpecialEnemy = "SpecialEnemy"
    self.TextTitle = "DUNGEON_SYNTHESIS2_100"
    self.TextWave1 = string.format(GText("DUNGEON_SYNTHESIS2_101"), 1, 3)
    self.TextWave2 = string.format(GText("DUNGEON_SYNTHESIS2_101"), 2, 3)
    self.TextWave3 = string.format(GText("DUNGEON_SYNTHESIS2_101"), 3, 3)

	local SynthesisIIInfo = DataMgr.SynthesisII[self.GameMode.DungeonId]
	if not SynthesisIIInfo then
		GameState(self):ShowDungeonError("SynthesisIIComponent:当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id："..self.GameMode.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
		return
	end

    self.CurMission = ""

    -- Charge
    self.ChargeTime = SynthesisIIInfo.ChargeTime
    self.ChargeCreatorIds = SynthesisIIInfo.ChargeCreatorId
    self.ChargeMonsterSpawnIds = SynthesisIIInfo.ChargeMonsterSpawnId
    -- FortDefence
    self.FortDefenceTargetNums = SynthesisIIInfo.FortDefenceTargetNum
    self.MiniGameCreatorIds = SynthesisIIInfo.MiniGameCreatorId
    self.CannonCreatorIds = SynthesisIIInfo.CannonCreatorId
    -- Escort
    self.HostageCreatorId = SynthesisIIInfo.HostageCreatorId
    self.EliteCreatorIds = SynthesisIIInfo.EliteCreatorId

    DebugPrint("SynthesisIIComponent: InitSynthesisIIComponent")
    GWorld:DSBLog("Info", "SynthesisIIComponent: InitSynthesisIIComponent", "GameMode")
end

function BP_SynthesisIIComponent_C:InitResetPointInfo()
    -- Reset Point info
    self.VisitedPointCountMap = {}
    self.CacheResetPointToAnimPointDistMap = {}
    local ResetPoints = self.GameMode.EMGameState.HostageResetPoints:ToTable()
    local AnimPoints = self.GameMode.EMGameState.HostageAimPoints:Values():ToTable()
    for _, value in ipairs(ResetPoints) do
        self.VisitedPointCountMap[value] = 0
        self.CacheResetPointToAnimPointDistMap[value] = {}
        for _, AnimPoint in ipairs(AnimPoints) do
            if IsValid(AnimPoint) and IsValid(value) then
                local Len = UE4.UNavigationFunctionLibrary.FindTwoPosLength(self, value:K2_GetActorLocation(), AnimPoint:K2_GetActorLocation())
                self.CacheResetPointToAnimPointDistMap[value][AnimPoint] = Len
            end
        end
    end
    self.EidToTimerHandle = nil
    self.CheckResetInterval = 0.05
end

function BP_SynthesisIIComponent_C:InitSynthesisIIBaseInfo()
    self:ConvertJsonInfoToLuaTable()
end

function BP_SynthesisIIComponent_C:ConvertJsonInfoToLuaTable()
    self.CreatorIdToLevelName = {}
    self.HostageRoute = {}

    local LevelLoader = self.GameMode:GetLevelLoader()
    local DungeonJsonAttr = LevelLoader.attr
    for _, Info in pairs(DungeonJsonAttr) do
        for k, _ in pairs(Info) do
            if k == "custom_setting_id" then
                for LevelName in string.gmatch(Info["custom_setting_id"], "([^,]+)") do
                    table.insert(self.HostageRoute, LevelName)
                end
            else
                local CreatorIdStr = string.split(k, "_")[1]
                self.CreatorIdToLevelName[tonumber(CreatorIdStr)] = tostring(Info[CreatorIdStr.."_id"])
                break
            end
        end
    end
end

function BP_SynthesisIIComponent_C:TriggerSynthesisOnEnd()
    
end

--region 事件统一入口
-- 后用字符串拼接的方式调用到对应任务的事件
function BP_SynthesisIIComponent_C:OnUnitDeadEvent(MonsterC, KillMineRoleEid, KillMineSkillId, DeathReason)
    local OnDeadfuncName = "OnUnitDeadEvent_" .. self.CurMission
    if self[OnDeadfuncName] then
        self[OnDeadfuncName](self, MonsterC, KillMineRoleEid, KillMineSkillId, DeathReason)
    end
end

-- function BP_SynthesisIIComponent_C:OnCombatPropDeadEvent(CombatProp)
--     local OnSpawnfuncName = "OnCombatPropDeadEvent_" .. self.CurMission
--     if self[OnSpawnfuncName] then
--         self[OnSpawnfuncName](self, CombatProp)
--     end
-- end

function BP_SynthesisIIComponent_C:OnStaticCreatorEvent(EventName, Eid, UnitId, UnitType, CreatorId)
	local OnStaticCreatorfuncName = "OnStaticCreatorEvent_" .. self.CurMission
    if self[OnStaticCreatorfuncName] then
        self[OnStaticCreatorfuncName](self, EventName, Eid, UnitId, UnitType, CreatorId)
    end
end

-- function BP_SynthesisIIComponent_C:OnMonsterGuideAdded(Eid)
-- 	local OnGuidefuncName = "OnMonsterGuideAdded_" .. self.CurMission
--     if self[OnGuidefuncName] then
--         self[OnGuidefuncName](self, Eid)
--     end
-- end

function BP_SynthesisIIComponent_C:OnDefenceCoreActive(DefenceCore)
    local OnDefenceCoreActivefuncName = "OnDefenceCoreActive_" .. self.CurMission
    if self[OnDefenceCoreActivefuncName] then
        self[OnDefenceCoreActivefuncName](self, DefenceCore)
    end
end
--endregion

function BP_SynthesisIIComponent_C:SetMission(NewMission)
    if self.CurMission == NewMission then
        return
    end

    local InitfuncName = "Init" .. NewMission .. "Mission"
    if not self[InitfuncName] then
        GameState(self):ShowDungeonError("SynthesisIIComponent:SetMission 传入不存在的任务名！请检查 "..self.GameMode.DungeonId.." 传入任务名: "..NewMission, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
        return
    end

    DebugPrint("SynthesisIIComponent: SetMission", NewMission)
    GWorld:DSBLog("Info", "SynthesisIIComponent: SetMission  "..NewMission, "GameMode")

    self.CurMission = NewMission
    self[InitfuncName](self)

    self.GameMode:TriggerGameModeEvent("Event_OnMissionBegin", NewMission)
end

--region Charge
function BP_SynthesisIIComponent_C:InitChargeMission()
    self.IsChargeFinishEventTriggered = false
    self.ChargeCreatorIdToEid = {}

    self.ChargeCreatorIdToMonsterSpawnId = {}
    for Index, CreatorId in pairs(self.ChargeCreatorIds) do
        self.ChargeCreatorIdToMonsterSpawnId[CreatorId] = self.ChargeMonsterSpawnIds[Index]
    end

    -- yn要求 倒计时重置 但不重置充能机关进度/机关是否完成
    self.FinishedChargeCount = 0
    self.FinishedChargeCreatorIds = {}    --@ key: CreatorIds  value: true

    -- 充能机关 ABC 顺序：按 CreatorId 从小到大排序
    self.ChargeCreatorIdToGuideOrder = {}
    local ChargeIdsForOrder = {}
    for _, CreatorId in pairs(self.ChargeCreatorIds) do
        table.insert(ChargeIdsForOrder, CreatorId)
    end
    table.sort(ChargeIdsForOrder, function(a, b)
        return a < b
    end)
    for Index, CreatorId in ipairs(ChargeIdsForOrder) do
        self.ChargeCreatorIdToGuideOrder[CreatorId] = Index
    end

    for _, CreatorId in pairs(self.ChargeCreatorIds) do
        self:ActiveSubGameModeStaticCreator(CreatorId, "ChargeMechanism")
    end

    self.GameMode:NotifyClientShowDungeonTaskNew(self.IconPathYellow, self.TextTitle, "DUNGEON_SYNTHESIS2_102", self.TextWave1)
end

function BP_SynthesisIIComponent_C:OnStaticCreatorEvent_Charge(EventName, Eid, UnitId, UnitType, CreatorId)
    if EventName == "ChargeMechanism" then
        self.ChargeCreatorIdToEid[CreatorId] = Eid
    end
end

-- 这个交给策划在蓝图里调
function BP_SynthesisIIComponent_C:StartChargeGame()
    if self.CurMission ~= "Charge" then
        return
    end
    if self.IsChargeGameRunning then
        return
    end

    DebugPrint("SynthesisIIComponent: StartChargeGame ChargeTime:", self.ChargeTime)
    GWorld:DSBLog("Info", "SynthesisIIComponent: StartChargeGame  ChargeTime: "..tostring(self.ChargeTime), "GameMode")

    self.IsChargeGameRunning = true

    self.GameMode:BpAddTimer("ChargeGame", self.ChargeTime, false, Const.GameModeEventServerClient)
    self.GameMode:NotifyClientShowDungeonTaskNew(self.IconPathRed, self.TextTitle, "DUNGEON_SYNTHESIS2_103", self.TextWave1)
    EventManager:FireEvent(EventID.OnStartChargeGame, self.GameMode.DungeonId)
    self:ShowChargeProgressUI()

    -- 记录每个充能机关对应的 ABC 顺序（按 CreatorId 顺序），给指引 UI 在实体被序列化时使用
    local EMGameState = self.GameMode.EMGameState
    local bCanWriteGuideOrder = EMGameState and IsAuthority(EMGameState)

    for CreatorId, Eid in pairs(self.ChargeCreatorIdToEid) do
        if bCanWriteGuideOrder and self.ChargeCreatorIdToGuideOrder then
            local OrderIndex = self.ChargeCreatorIdToGuideOrder[CreatorId]
            if OrderIndex then
                -- 通过 Multicast 在所有端同步 GuideOrderMap
                EMGameState:MulticastSetGuideOrder(Eid, OrderIndex)
            end
        end
        if not self.FinishedChargeCreatorIds[CreatorId] then
            self.GameMode.EMGameState:AddGuideEid(Eid)
        end
        if self:CheckStartChargeGameSpawnMonster(Eid) then
            self:ChangeChargeMonsterSpawnByCreatorId(CreatorId, true)
        end
    end
end

function BP_SynthesisIIComponent_C:ShowChargeProgressUI()
    self.GameMode:AddDungeonEvent("ShowSynthesisIIChargeProgressUI")
end

function BP_SynthesisIIComponent_C:HideChargeProgressUI()
    self.GameMode:RemoveDungeonEvent("ShowSynthesisIIChargeProgressUI")
end

function BP_SynthesisIIComponent_C:CheckStartChargeGameSpawnMonster(Eid)
    local ChargeMechanism = Battle(self):GetEntity(Eid)
    if not IsValid(ChargeMechanism) then                -- 联机一定能拿到，单机如果拿不到说明被序列化，说明没有玩家在充能装置附近
        return false
    end

    if not ChargeMechanism.IsActiveAndHasPlayer then
        return false
    end

    return ChargeMechanism:IsActiveAndHasPlayer()
end

function BP_SynthesisIIComponent_C:OnOneChargeFinished(CreatorId)
    DebugPrint("SynthesisIIComponent: OnOneChargeFinished CreatorId:", CreatorId)
    GWorld:DSBLog("Info", "SynthesisIIComponent: OnOneChargeFinished  CreatorId: "..tostring(CreatorId), "GameMode")
    if self.FinishedChargeCreatorIds[CreatorId] then
        return
    end
    self.FinishedChargeCreatorIds[CreatorId] = true
    self.FinishedChargeCount = self.FinishedChargeCount + 1

    local Eid = self.ChargeCreatorIdToEid[CreatorId]
    self.GameMode.EMGameState:RemoveGuideEid(Eid)

    self:ChangeChargeMonsterSpawnByCreatorId(CreatorId, false)

    self.GameMode:TriggerGameModeEvent("Event_OnOneChargeFinished", CreatorId)

    if (not self.IsChargeFinishEventTriggered) and (self.FinishedChargeCount >= #self.ChargeCreatorIds) then
        DebugPrint("SynthesisIIComponent: OnOneChargeFinished All Charge Finished")
        GWorld:DSBLog("Info", "SynthesisIIComponent: OnOneChargeFinished  All Charge Finished", "GameMode")
        self.IsChargeFinishEventTriggered = true
        self.IsChargeGameRunning = false
        self.GameMode:BpDelTimer("ChargeGame", false, Const.GameModeEventServerClient)
        self.GameMode:NotifyClientShowDungeonTaskNew(self.IconPathYellow, self.TextTitle, "DUNGEON_SYNTHESIS2_104", self.TextWave2)
        EventManager:FireEvent(EventID.OnEndChargeGame)
        self:HideChargeProgressUI()
        self.GameMode:NotifyClientShowDungeonToast("DUNGEON_SYNTHESIS2_110", 2, EToastType.Success)
        self.GameMode:TriggerGameModeEvent("Event_OnAllChargeFinished")
    end
end

function BP_SynthesisIIComponent_C:BpOnTimerEnd_ChargeGame()
    if self.CurMission ~= "Charge" then
        return
    end
    self.IsChargeGameRunning = false

    for CreatorId, Eid in pairs(self.ChargeCreatorIdToEid) do
        if not self.FinishedChargeCreatorIds[CreatorId] then
            self.GameMode.EMGameState:RemoveGuideEid(Eid)
        end
    end

    -- 充能倒计时结束，任务栏恢复为充能阶段描述
    self.GameMode:NotifyClientShowDungeonTaskNew(self.IconPathYellow, self.TextTitle, "DUNGEON_SYNTHESIS2_102", self.TextWave1)

    DebugPrint("SynthesisIIComponent: Charge Time Up")
    GWorld:DSBLog("Info", "SynthesisIIComponent: Charge Time Up", "GameMode")
    EventManager:FireEvent(EventID.OnChargeTimeUp)
    self.GameMode:TriggerGameModeEvent("Event_OnChargeTimeUp")
end

function BP_SynthesisIIComponent_C:OnPlayerEnterChargeMechanism(CreatorId)
    if not CreatorId then
        return
    end
    if not self.IsChargeGameRunning then
        return
    end

    self:ChangeChargeMonsterSpawnByCreatorId(CreatorId, true)
end

---@param CreatorId number @对应的充能机关CreatorId
---@param IsCreate boolean @true: 创建  false: 销毁
function BP_SynthesisIIComponent_C:ChangeChargeMonsterSpawnByCreatorId(CreatorId, IsCreate)
    local MonsterSpawnId = self.ChargeCreatorIdToMonsterSpawnId[CreatorId]
    if not MonsterSpawnId then
        return
    end

    local SpawnIdArray = TArray(0)
    SpawnIdArray:Add(MonsterSpawnId)
    if IsCreate then
        self.GameMode:TriggerCreateMonsterSpawn(SpawnIdArray)
    else
        self.GameMode:TriggerDestoryMonsterSpawn(SpawnIdArray)
    end
end

--endregion


--region FortDefence
function BP_SynthesisIIComponent_C:InitFortDefenceMission()
    self.CannonCreatorIdToEid = {}
    self.CannonCreatorIdToIndex = {}
    self.FortDefenceState = {}   --@ key: CreatorId  value: 0: 未开始 1: 进行中 2: 已完成
    self.IsFortDefenceFinishEventTriggered = false
    self:SetFortDefenceGameIndex(0)                                           ---@ 当前进行到第几轮杀怪
    self.FortDefenceGameTotalCount = #self.FortDefenceTargetNums            ---@ 总共几轮杀怪

    -- yn要求 开始时仅激活一个小游戏机关，之后每完成一轮炮台守卫，再激活下一个小游戏机关
    -- for _, CreatorId in pairs(self.MiniGameCreatorIds) do
    --     self:ActiveSubGameModeStaticCreator(CreatorId)
    -- end
    local MiniGameCreatorId = self.MiniGameCreatorIds[1]
    if MiniGameCreatorId then
        self:ActiveSubGameModeStaticCreator(MiniGameCreatorId)
    end

    for Index, CreatorId in pairs(self.CannonCreatorIds) do
        self.CannonCreatorIdToIndex[CreatorId] = Index
        self.FortDefenceState[CreatorId] = 0
        self:ActiveSubGameModeStaticCreator(CreatorId, "FortDefenceCannon")
    end

    -- 激活阶段：找到并启动固定载具（第1轮/x轮），wave 用 TextWave2
    local FortDefenceTaskText = string.format(GText("DUNGEON_SYNTHESIS2_104"), 0, self.FortDefenceGameTotalCount)
    self.GameMode:NotifyClientShowDungeonTaskNew(self.IconPathYellow, self.TextTitle, FortDefenceTaskText, self.TextWave2)
end

function BP_SynthesisIIComponent_C:OnStaticCreatorEvent_FortDefence(EventName, Eid, UnitId, UnitType, CreatorId)
    if EventName == "FortDefenceCannon" then
        local Index = self.CannonCreatorIdToIndex[CreatorId]
        self.CannonCreatorIdToEid[CreatorId] = Eid

        if Index == 1 then
            self.GameMode.EMGameState:AddGuideEid(Eid)
        end
    end
end

function BP_SynthesisIIComponent_C:OnDefenceCoreActive_FortDefence(DefenceCore)
    if not IsValid(DefenceCore) then
        return
    end
    self:ShowFortDefenceHpUI()
    self:OnOneFortDefenceBegin(DefenceCore.CreatorId)
end

function BP_SynthesisIIComponent_C:ShowFortDefenceHpUI()
    self.GameMode.EMGameState:SetDungeonUIState(Const.EDungeonUIState.OnTarget)
end

function BP_SynthesisIIComponent_C:HideFortDefenceHpUI()
    self.GameMode.EMGameState:SetDungeonUIState(Const.EDungeonUIState.None)
end

function BP_SynthesisIIComponent_C:OnOneFortDefenceBegin(CreatorId)
    if not self.FortDefenceState[CreatorId] then
        return
    end
    if self.FortDefenceState[CreatorId] ~= 0 then
        return
    end

    DebugPrint("SynthesisIIComponent:OnOneFortDefenceBegin CreatorId", CreatorId)
    GWorld:DSBLog("Info", "SynthesisIIComponent: OnOneFortDefenceBegin CreatorId:  "..CreatorId, "GameMode")
    self.FortDefenceState[CreatorId] = 1
    self:SetFortDefenceGameIndex(self:GetFortDefenceGameIndex() + 1)
    self:SetFortDefenceKilledNum(0)                                                       ---@ 当前轮已杀怪数量
    self.FortDefenceTargetNum = self.FortDefenceTargetNums[self:GetFortDefenceGameIndex()]   ---@ 当前轮目标杀怪数量
    -- 保护阶段：保护固定载具，淘汰其他参赛选手（当前轮/总轮），wave 用 TextWave2
    local FortDefenceTaskText = string.format(GText("DUNGEON_SYNTHESIS2_105"), self:GetFortDefenceGameIndex(), self.FortDefenceGameTotalCount)
    self.GameMode:NotifyClientShowDungeonTaskNew(self.IconPathYellow, self.TextTitle, FortDefenceTaskText, self.TextWave2)
    self.GameMode:TriggerGameModeEvent("Event_OnOneFortDefenceBegin")
    self:ShowFortDefenceProgressUI(self.FortDefenceTargetNum)
end

function BP_SynthesisIIComponent_C:ShowFortDefenceProgressUI(FortDefenceTargetNum)
    self.GameMode:AddDungeonEvent("ShowSynthesisIIFortDefenceProgressUI")
end

function BP_SynthesisIIComponent_C:HideFortDefenceProgressUI()
    self.GameMode:RemoveDungeonEvent("ShowSynthesisIIFortDefenceProgressUI")
end

function BP_SynthesisIIComponent_C:OnUnitDeadEvent_FortDefence(MonsterC, KillMineRoleEid, KillMineSkillId, DeathReason)
    if not IsValid(MonsterC) then
		return
	end
	if not MonsterC:IsRealMonster() then
		return
	end

    local CurGameIndex = self:GetFortDefenceGameIndex()
    if (CurGameIndex <= 0) or (CurGameIndex > self.FortDefenceGameTotalCount) then
        return
    end

    self:SetFortDefenceKilledNum(self:GetFortDefenceKilledNum() + 1)
    if self:GetFortDefenceKilledNum() >= self.FortDefenceTargetNum then
        local CurrentCreatorId = self.CannonCreatorIds[CurGameIndex]
        self:OnOneFortDefenceFinished(CurrentCreatorId)
    end
end

function BP_SynthesisIIComponent_C:OnOneFortDefenceFinished(CreatorId)
    if not self.FortDefenceState[CreatorId] then
        return
    end
    if self.FortDefenceState[CreatorId] ~= 1 then
        return
    end
    DebugPrint("SynthesisIIComponent: OnOneFortDefenceFinished ", CreatorId)
    GWorld:DSBLog("Info", "SynthesisIIComponent: OnOneFortDefenceFinished CreatorId:  "..CreatorId, "GameMode")

    self.FortDefenceState[CreatorId] = 2
    self.GameMode:TriggerGameModeEvent("Event_OnOneFortDefenceFinished")

    if self.IsFortDefenceFinishEventTriggered then
        return
    end

    self:HideFortDefenceProgressUI()
    self:HideFortDefenceHpUI()
    local CurGameIndex = self:GetFortDefenceGameIndex()
    if CurGameIndex >= self.FortDefenceGameTotalCount then
        DebugPrint("SynthesisIIComponent: AllFortDefence Finished")
        GWorld:DSBLog("Info", "SynthesisIIComponent: AllFortDefence Finished", "GameMode")
        self.IsFortDefenceFinishEventTriggered = true

        -- 若还有，激活剩余所有的小游戏机关
        for Index = CurGameIndex + 1, #self.MiniGameCreatorIds do
            local MiniGameCreatorId = self.MiniGameCreatorIds[Index]
            if MiniGameCreatorId then
                self:ActiveSubGameModeStaticCreator(MiniGameCreatorId)
            end
        end

        self.GameMode:NotifyClientShowDungeonTaskNew(self.IconPathYellow, self.TextTitle, "DUNGEON_SYNTHESIS2_106", self.TextWave3)
        self.GameMode:NotifyClientShowDungeonToast("DUNGEON_SYNTHESIS2_110", 2, EToastType.Success)
        self.GameMode:TriggerGameModeEvent("Event_OnAllFortDefenceFinished")
    else
        local NextIndex = CurGameIndex + 1
        local NextCreatorId = self.CannonCreatorIds[NextIndex]
        local NextCannonEid = self.CannonCreatorIdToEid[NextCreatorId]
        self.GameMode.EMGameState:AddGuideEid(NextCannonEid)

        -- 激活下一个炮台防御对应的小游戏机关
        local NextMiniGameCreatorId = self.MiniGameCreatorIds[NextIndex]
        if NextMiniGameCreatorId then
            self:ActiveSubGameModeStaticCreator(NextMiniGameCreatorId)
        end
        -- 下一轮激活阶段：找到并启动固定载具（下一轮/总轮），wave 用 TextWave2
        local FortDefenceTaskText = string.format(GText("DUNGEON_SYNTHESIS2_104"), NextIndex - 1, self.FortDefenceGameTotalCount)
        self.GameMode:NotifyClientShowDungeonTaskNew(self.IconPathYellow, self.TextTitle, FortDefenceTaskText, self.TextWave2)
    end
end

function BP_SynthesisIIComponent_C:GetFortDefenceGameIndex()
    return self.GameMode.EMGameState.FortDefenceGameIndex
end

function BP_SynthesisIIComponent_C:SetFortDefenceGameIndex(Index)
    self.GameMode.EMGameState:SetFortDefenceGameIndex(Index)
end

function BP_SynthesisIIComponent_C:GetFortDefenceKilledNum()
    return self.GameMode.EMGameState.FortDefenceKilledNum
end

function BP_SynthesisIIComponent_C:SetFortDefenceKilledNum(Num)
    self.GameMode.EMGameState:SetFortDefenceKilledNum(Num)
end

--endregion


--region Escort
function BP_SynthesisIIComponent_C:InitEscortMission()
    self.NextRouteIndex = 1
    self.CurHostageIndex = 0
    self.TriggerdRouteLevelNames = {}       --@ key: LevelName  value: true

    self:ActiveSubGameModeStaticCreator(self.HostageCreatorId, "EscortHostage")

    for _, EliteCreatorId in pairs(self.EliteCreatorIds) do
        self:ActiveSubGameModeStaticCreator(EliteCreatorId, "EscortElite")
    end

    self.GameMode:NotifyClientShowDungeonTaskNew(self.IconPathYellow, self.TextTitle, "DUNGEON_SYNTHESIS2_106", self.TextWave3)
end

function BP_SynthesisIIComponent_C:OnStaticCreatorEvent_Escort(EventName, Eid, UnitId, UnitType, CreatorId)
    if EventName == "EscortHostage" then
        self.HostageEid = Eid

        -- 开始检测人质是否卡死并需要传送到重置点
        if self.EidToTimerHandle then
            self:RemoveTimer(self.EidToTimerHandle)
            self.EidToTimerHandle = nil
        end
        self.CheckResetTimeCount = 0
        self.EidToTimerHandle = self:AddTimer(self.CheckResetInterval, function()
            self:CheckHostageNeedToResetPoint()
        end, true, 0, "StartResetCheck", false)
    end
end

function BP_SynthesisIIComponent_C:OnUnitDeadEvent_Escort(MonsterC, KillMineRoleEid, KillMineSkillId, DeathReason)
    if MonsterC.Eid == self.HostageEid then
        DebugPrint("SynthesisIIComponent: OnUnitDeadEvent_Escort Hostage Dead")
        GWorld:DSBLog("Info", "SynthesisIIComponent: OnUnitDeadEvent_Escort Hostage Dead", "GameMode")
        self:HideHostageHealthBarUI()
        self.GameMode:TriggerGameModeEvent("Event_OnHostageDead")

        if self.EidToTimerHandle then
            self:RemoveTimer(self.EidToTimerHandle)
        end
    end
end

function BP_SynthesisIIComponent_C:GetHostageRouteNum()
    if not self.HostageRoute then
        return 0
    end

    return #self.HostageRoute
end

function BP_SynthesisIIComponent_C:GetNextHostageLoc()
    local ResLoc = FVector(0)
    if not self.HostageRoute then
        return ResLoc
    end
    if not self.NextRouteIndex then 
        return ResLoc
    end
    if self.NextRouteIndex > #self.HostageRoute then
        return ResLoc
    end

    local LevelName = self.HostageRoute[self.NextRouteIndex]
    local NextAimPoint = self.GameMode.EMGameState.HostageAimPoints:Find(LevelName)
    if IsValid(NextAimPoint) then
        ResLoc = NextAimPoint:K2_GetActorLocation()
    end

    DebugPrint("SynthesisIIComponent: GetNextHostageLoc LevelName:", LevelName, "ResLoc:", ResLoc)
    return ResLoc
end

function BP_SynthesisIIComponent_C:GetNextHostageAnimPoint()
    if not self.HostageRoute then
        return
    end
    if not self.NextRouteIndex then 
        return
    end
    if self.NextRouteIndex > #self.HostageRoute then
        return
    end

    local LevelName = self.HostageRoute[self.NextRouteIndex]
    local NextAimPoint = self.GameMode.EMGameState.HostageAimPoints:Find(LevelName)
    if not IsValid(NextAimPoint) then
        return
    end

    DebugPrint("SynthesisIIComponent: GetNextHostageLoc LevelName:", LevelName, "NextAnimPoint:", NextAimPoint:GetName())
    return NextAimPoint
end

function BP_SynthesisIIComponent_C:OnHostageEnterPoint(PointLevelName)
    if not self.CurHostageIndex then
        return
    end
    if self.TriggerdRouteLevelNames[PointLevelName] then
        return
    end
    self.TriggerdRouteLevelNames[PointLevelName] = true

    -- 人质进目标点会触发，每个点只进一次
    self.CurHostageIndex = self.CurHostageIndex + 1

    DebugPrint("SynthesisIIComponent: OnHostageEnterPoint PointLevelName:", PointLevelName, "TriggerdCount:", self.CurHostageIndex)
    GWorld:DSBLog("Info", "SynthesisIIComponent: OnHostageEnterPoint PointLevelName: "..tostring(PointLevelName).."   TriggerdCount:  "..self.CurHostageIndex, "GameMode")
    local bIsFinalPoint = self.CurHostageIndex == self:GetHostageRouteNum()
    self.GameMode:TriggerGameModeEvent("Event_OnHostageReachedMainpoint", bIsFinalPoint)
    if bIsFinalPoint then
        self:HideHostageHealthBarUI()
        self.GameMode:AddDungeonEvent("FinishSynthesisII")
        self.GameMode:NotifyClientShowDungeonToast("DUNGEON_SYNTHESIS2_117", 2, EToastType.Success)
        self.GameMode:NotifyClientShowDungeonTaskNew(self.IconPathYellow, self.TextTitle, "DUNGEON_SYNTHESIS2_108", self.TextWave3)
    end

    self.NextRouteIndex = self.NextRouteIndex + 1
end

function BP_SynthesisIIComponent_C:GetHostageRouteFinalLoc()
    local ResLoc = FVector(0)
    if not self.HostageRoute then
        return ResLoc
    end
    local FinalIndex = #self.HostageRoute
    if FinalIndex <= 0 then
        return ResLoc
    end

    local LevelName = self.HostageRoute[FinalIndex]
    local FinalAimPoint = self.GameMode.EMGameState.HostageAimPoints:Find(LevelName)
    if IsValid(FinalAimPoint) then
        ResLoc = FinalAimPoint:K2_GetActorLocation()
    end

    DebugPrint("SynthesisIIComponent: GetHostageRouteFinalLoc LevelName:", LevelName, "ResLoc:", ResLoc)
    return ResLoc
end

--endregion

function BP_SynthesisIIComponent_C:ActiveSubGameModeStaticCreator(CreatorId, EventName)
    local LevelName = self.CreatorIdToLevelName[CreatorId]
    local SubGameMode = self.GameMode.SubGameModeInfo:FindRef(LevelName)
    if IsValid(SubGameMode) then
        local CreatorIdArray = TArray(0)
        CreatorIdArray:Add(CreatorId)
        SubGameMode:TriggerActiveStaticCreator(CreatorIdArray, EventName, true)
    else
        GameState(self):ShowDungeonError("SynthesisIIComponent:激活静态点，请检查配置  CreatorId: "..tostring(CreatorId).."LevelName: "..tostring(LevelName), Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
    end
end

function BP_SynthesisIIComponent_C:CheckHostageNeedToResetPoint()
    self.CheckResetTimeCount = self.CheckResetTimeCount + self.CheckResetInterval
    local Hostage = Battle(self):GetEntity(self.HostageEid)
    if Hostage then
        if not self.CheckStartLoc then
            self.CheckStartLoc = Hostage:K2_GetActorLocation()
        end

        local BlackBoard = Hostage:GetOwnBlackBoardComponent()
        local bNearByMon = BlackBoard:GetValueAsBool("HaveNearbyMon")
        local bNearByPlayer = BlackBoard:GetValueAsBool("HaveNearbyPlayer")
        -- 检查周围是否有玩家且无怪
        if bNearByPlayer and not bNearByMon then
            if self.CheckResetTimeCount >= Const.SynthesisCheckResetPointTime then
                -- 检查距离
                local Dist = UE4.UKismetMathLibrary.Vector_Distance(self.CheckStartLoc, Hostage:K2_GetActorLocation())
                if Dist < 20 then
                    -- 需要传送重置点
                    DebugPrint("SynthesisIIComponent: CheckHostageNeedToResetPoint Need Reset Point Dist:", Dist, "bNearByMon:", bNearByMon, "bNearByPlayer:", bNearByPlayer)
                    GWorld:DSBLog("Info", "SynthesisIIComponent: CheckHostageNeedToResetPoint Need Reset Point  Dist: "..tostring(Dist).."  bNearByMon: "..tostring(bNearByMon).."  bNearByPlayer: "..tostring(bNearByPlayer))
                    self:ResetHostageToResetPoint()
                end

                self.CheckResetTimeCount = 0
                self.CheckStartLoc = Hostage:K2_GetActorLocation()
            end
        else
            self.CheckResetTimeCount = 0
            self.CheckStartLoc = Hostage:K2_GetActorLocation()
        end
    else
        if self.VisitedPointCountMap then
            for _, value in ipairs(self.VisitedPointCountMap) do
                value = 0
            end
        end

        self.CheckResetTimeCount = 0
    end
end

function BP_SynthesisIIComponent_C:ResetHostageToResetPoint()
    local Hostage = Battle(self):GetEntity(self.HostageEid)
    if not IsValid(Hostage) then
        return
    end

    local NextAnimPoint = self:GetNextHostageAnimPoint()
    if not IsValid(NextAnimPoint) then
        return
    end

    local HostageLoc =  Hostage:K2_GetActorLocation()
    local HostageToNextAnimPointDist = UE4.UNavigationFunctionLibrary.FindTwoPosLength(self, HostageLoc, NextAnimPoint:K2_GetActorLocation())
    local NearestResetPoint = nil
    local MinToHostageDist = math.huge
    for ResetPoint, VisitedCount in pairs(self.VisitedPointCountMap) do
        if IsValid(ResetPoint) then
            local Dist = self.CacheResetPointToAnimPointDistMap[ResetPoint][NextAnimPoint]
            local ToHostageDist = UE4.UKismetMathLibrary.Vector_Distance(HostageLoc, ResetPoint:K2_GetActorLocation())
            if Dist and ToHostageDist < MinToHostageDist and Dist < HostageToNextAnimPointDist then
                MinToHostageDist = ToHostageDist
                NearestResetPoint = ResetPoint
            end
        end
    end

    if NearestResetPoint then
        local ResetLoc = NearestResetPoint:K2_GetActorLocation()
        Hostage:K2_SetActorLocation(ResetLoc, false, nil, false)

        self.VisitedPointCountMap[NearestResetPoint] = self.VisitedPointCountMap[NearestResetPoint] + 1

        DebugPrint("SynthesisIIComponent: ResetHostageToResetPoint to ", ResetLoc)
        GWorld:DSBLog("Info", "SynthesisIIComponent: ResetHostageToResetPoint to  "..tostring(ResetLoc))
    else
        local ResetLoc = NextAnimPoint:K2_GetActorLocation()
        Hostage:K2_SetActorLocation(ResetLoc, false, nil, false)
        
        DebugPrint("SynthesisIIComponent: ResetHostage to NextAnimPoint ", ResetLoc)
        GWorld:DSBLog("Info", "SynthesisIIComponent: ResetHostage to NextAnimPoint "..tostring(ResetLoc))
    end
end

-- function M:Initialize(Initializer)
-- end

-- function M:ReceiveBeginPlay()
-- end

function BP_SynthesisIIComponent_C:ReceiveEndPlay()
    if self.EidToTimerHandle then
        self:RemoveTimer(self.EidToTimerHandle)
    end
end

function BP_SynthesisIIComponent_C:HostageStartMove()
    self.GameMode:NotifyClientShowDungeonTaskNew(self.IconPathYellow, self.TextTitle, "DUNGEON_SYNTHESIS2_107", self.TextWave3)
    self:ShowHostageHealthBarUI()
end

function BP_SynthesisIIComponent_C:ShowHostageHealthBarUI()
    self.GameMode:AddDungeonEvent("ShowSynthesisIIHostageHealthBarUI")
end

function BP_SynthesisIIComponent_C:HideHostageHealthBarUI()
    self.GameMode:RemoveDungeonEvent("ShowSynthesisIIHostageHealthBarUI")
end

return BP_SynthesisIIComponent_C
