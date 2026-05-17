--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type AutoChess_Formation_C
local BP_AutoChess_Formation_C = Class("BluePrints.Common.TimerMgr")

function BP_AutoChess_Formation_C:ReceiveBeginPlay()
    EventManager:AddEvent(EventID.OnAutoChessCreateMonster,self,self.CreateChessMonster)
    EventManager:AddEvent(EventID.OnAutoChessRemoveMonster,self,self.RemoveChessMonster)
    self.Index2Cube = {}
    self.Index2CubeInfo = {}
    self.Index2EnemyCube = {}
    self.Index2EnemyCubeInfo = {}
    self.CurrentHoverCubeIndex = nil
    self.CurrentSelectCubeIndex = nil
    self.MonsterCreatingCount = 0

    for i = 0, 47 do
        local CubeActor = nil
        if self["Cube"..i] then
            local ActorClass = UE4.UClass.Load("/Game/AssetDesign/GameMode/AutoChess/AutoChess_Cube.AutoChess_Cube")
            local Location = self["Cube"..i]:K2_GetComponentLocation()
            local Rotation = self["Cube"..i]:K2_GetComponentRotation():ToQuat()
            local SpawnTransform = UE4.FTransform(Rotation, Location)
            CubeActor = GWorld.GameInstance:GetWorld():SpawnActor(
            ActorClass,
            SpawnTransform,
            UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn,
            nil,
            self,
            nil
        )
        else
            DebugPrint("ayff test missing Cube actor:", i)
            goto continue
        end

        if self["Cube"..i]:GetAttachParent() == self.Scene1 then
            CubeActor.Index = i - 24
            CubeActor.Enemy = true
        elseif self["Cube"..i]:GetAttachParent() == self.Scene then
            CubeActor.Index = i
            CubeActor.Enemy = false
        end

        if CubeActor then
            CubeActor.Owner = self
            if CubeActor.Enemy then
                self.Index2EnemyCube[CubeActor.Index] = CubeActor
            else
                self.Index2Cube[CubeActor.Index] = CubeActor
            end
        end
        ::continue::
    end
end

function BP_AutoChess_Formation_C:ReceiveEndPlay()
    EventManager:RemoveEvent(EventID.OnAutoChessCreateMonster,self)
    EventManager:RemoveEvent(EventID.OnAutoChessRemoveMonster,self)
end

function BP_AutoChess_Formation_C:CreateChessMonster(CombatChessId, CubeIndex, IsEnemy, EquipList)
    AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_cell_click_replace", nil, nil)

    local CubeIndex = tonumber(CubeIndex)
    local CubeActorList = IsEnemy and self.Index2EnemyCube or self.Index2Cube
    local CubeInfoList = IsEnemy and self.Index2EnemyCubeInfo or self.Index2CubeInfo
    -- local Actor = self["AutoChess_Cube"..CubeIndex]
    local Actor = CubeActorList[CubeIndex]
    if not Actor then
        DebugPrint("ayff test invalid CubeIndex:",CubeIndex)
        return
    end
    if CubeInfoList[CubeIndex] then
        DebugPrint("ayff test cube index already has monster:",CubeIndex)
        return
    end
    local TargetLocation = Actor:K2_GetActorLocation()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local UnitId = IsEnemy and DataMgr.CombatChessInfo[tonumber(CombatChessId)].EnemyMonsterUnitId or  DataMgr.CombatChessInfo[tonumber(CombatChessId)].FriendMonsterUnitId

    local function LoadFinishCallback(_,Unit)
        if CubeInfoList[CubeIndex] == nil then
            CubeInfoList[CubeIndex] = {}
        end
        CubeInfoList[CubeIndex] = {Eid = Unit.Eid, UnitId = UnitId, CombatChessId = CombatChessId, EquipList = EquipList}
        if Actor then
            Actor.MonsterEid = Unit.Eid
            Actor.MonsterUnitId = UnitId
            Actor.CombatChessId = CombatChessId
            Actor.EquipList = EquipList
            Actor.LocZ = Battle(self):GetEntity(Unit.Eid):K2_GetActorLocation().Z
        end
        DebugPrint("ayff test create monster at CubeIndex:",CubeIndex," UnitId:",UnitId," Eid:",Unit.Eid)
        self.MonsterCreatingCount = self.MonsterCreatingCount - 1
        self:OnCubeMonsterSelected(CubeIndex, false)
    end
    local Context = AEventMgr.CreateUnitContext()
	Context.UnitType = "Monster"
	Context.UnitId = UnitId
	Context.Loc = TargetLocation
    Context.Rotation = IsEnemy and FRotator(0,0,0) or FRotator(0,180,0)
	Context.MonsterSpawn = GameMode.LevelGameMode.FixedMonsterSpawn
	Context.IntParams:Add("Level", GameMode:GetFixedGamemodeLevel())
    Context.OnUnitInitCreateReadyDynamic:Add(self, LoadFinishCallback)
	GameMode.EMGameState.EventMgr:CreateUnitNew(Context, false)
    self.MonsterCreatingCount = self.MonsterCreatingCount + 1

    CubeInfoList[CubeIndex] = {}
end

function BP_AutoChess_Formation_C:RemoveChessMonster(CubeIndex, IsEnemy)
    local CubeIndex = tonumber(CubeIndex)
    local CubeInfoList = IsEnemy and self.Index2EnemyCubeInfo or self.Index2CubeInfo
    local CubeActorList = IsEnemy and self.Index2EnemyCube or self.Index2Cube
    if CubeInfoList[CubeIndex] then
        local Monster = Battle(self):GetEntity(CubeInfoList[CubeIndex].Eid)
        if IsValid(Monster) then
            Monster:EMActorDestroy(EDestroyReason.AutoChess)
        end
        CubeInfoList[CubeIndex] = nil
        local CubeActor = CubeActorList[CubeIndex]
        if CubeActor then
            CubeActor.MonsterEid = nil
            CubeActor.MonsterUnitId = nil
            CubeActor.CombatChessId = nil
            CubeActor.EquipList = nil
        end
        DebugPrint("ayff test remove monster at CubeIndex:",CubeIndex)
    else
        DebugPrint("ayff test no monster to remove at CubeIndex:",CubeIndex)
    end
end

function BP_AutoChess_Formation_C:GetCurrentChessMonsterInfo(IsEnemy)
    if IsEnemy then
        return self.Index2EnemyCubeInfo
    else
        return self.Index2CubeInfo
    end
end

function BP_AutoChess_Formation_C:BindCubeEvent(EventName, Obj, Func)
    self._CubeEventListeners = self._CubeEventListeners or {}
    self._CubeEventListeners[EventName] = self._CubeEventListeners[EventName] or {}
    table.insert(self._CubeEventListeners[EventName], { Obj = Obj, Func = Func })
end

function BP_AutoChess_Formation_C:BroadcastCubeEvent(EventName, CubeIndex, IsEnemy, CubeActor, ButtonOrNil)
    local Map = self._CubeEventListeners
    local List = Map and Map[EventName]
    if not List then return end

    for _, L in ipairs(List) do
        local f = L.Func
        if type(f) == "function" then
            f(L.Obj, CubeIndex, IsEnemy, CubeActor, ButtonOrNil)
        elseif type(f) == "string" and L.Obj and L.Obj[f] then
            L.Obj[f](L.Obj, CubeIndex, IsEnemy, CubeActor, ButtonOrNil)
        end
    end
end

function BP_AutoChess_Formation_C:OnCubeClicked(CubeIndex, IsEnemy, CubeActor, ButtonPressed)
    self:BroadcastCubeEvent("Click", CubeIndex, IsEnemy, CubeActor, ButtonPressed)
end

function BP_AutoChess_Formation_C:OnCubeReleased(CubeIndex, IsEnemy, CubeActor, ButtonReleased)
    self:BroadcastCubeEvent("Release", CubeIndex, IsEnemy, CubeActor, ButtonReleased)
end

function BP_AutoChess_Formation_C:OnCubeHovered(CubeIndex, IsEnemy, CubeActor)
    self:BroadcastCubeEvent("Hover", CubeIndex, IsEnemy, CubeActor, nil)
end

function BP_AutoChess_Formation_C:OnCubeUnhovered(CubeIndex, IsEnemy, CubeActor)
    self:BroadcastCubeEvent("Unhover", CubeIndex, IsEnemy, CubeActor, nil)
end

function BP_AutoChess_Formation_C:OnCubeMonsterSelected(CubeIndex, bPick)
    if self.Index2Cube[CubeIndex] then
        self.Index2Cube[CubeIndex]:SetMonsterState(bPick)
    end
end

function BP_AutoChess_Formation_C:SwitchMonsterPosition(Index1, Index2)
    AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_cell_click_replace", nil, nil)
    
    local Info1 = self.Index2CubeInfo[Index1]
    local Info2 = self.Index2CubeInfo[Index2]

    self.Index2CubeInfo[Index1] = Info2
    self.Index2CubeInfo[Index2] = Info1

    local CubeActor1 = self.Index2Cube[Index1]
    local CubeActor2 = self.Index2Cube[Index2]

    if CubeActor1 then
        if Info2 then
            CubeActor1.MonsterEid = Info2.Eid
            CubeActor1.MonsterUnitId = Info2.UnitId
            CubeActor1.CombatChessId = Info2.CombatChessId
            CubeActor1.EquipList = Info2.EquipList
            CubeActor1.LocZ = Battle(self):GetEntity(Info2.Eid):K2_GetActorLocation().Z
        else
            CubeActor1.MonsterEid = nil
            CubeActor1.MonsterUnitId = nil
            CubeActor1.CombatChessId = nil
            CubeActor1.EquipList = nil
            CubeActor1.LocZ = nil
        end
    end

    if CubeActor2 then
        if Info1 then
            CubeActor2.MonsterEid = Info1.Eid
            CubeActor2.MonsterUnitId = Info1.UnitId
            CubeActor2.CombatChessId = Info1.CombatChessId
            CubeActor2.EquipList = Info1.EquipList
            CubeActor2.LocZ = Battle(self):GetEntity(Info1.Eid):K2_GetActorLocation().Z - 50
        else
            CubeActor2.MonsterEid = nil
            CubeActor2.MonsterUnitId = nil
            CubeActor2.CombatChessId = nil
            CubeActor2.EquipList = nil
            CubeActor2.LocZ = nil
        end
    end

    if Info1 and Info1.Eid then
        local Monster1 = Battle(self):GetEntity(Info1.Eid)
        if IsValid(Monster1) and CubeActor2 then
            local Loc2 = CubeActor2:K2_GetActorLocation()
            local PreLoc = Monster1:K2_GetActorLocation()
            local NewLoc = FVector(Loc2.X, Loc2.Y, PreLoc.Z)
            Monster1:K2_SetActorLocation(NewLoc, false, nil, true)
        end
    end

    if Info2 and Info2.Eid then
        local Monster2 = Battle(self):GetEntity(Info2.Eid)
        if IsValid(Monster2) and CubeActor1 then
            local Loc1 = CubeActor1:K2_GetActorLocation()
            local PreLoc = Monster2:K2_GetActorLocation()
            local NewLoc = Monster2.IsFlyMonster and FVector(Loc1.X, Loc1.Y, PreLoc.Z + 50) or FVector(Loc1.X, Loc1.Y, PreLoc.Z)
            Monster2:K2_SetActorLocation(NewLoc, false, nil, true)
        end
    end

    self:OnCubeMonsterSelected(Index1, false)
    self:OnCubeMonsterSelected(Index2, false)
end

function BP_AutoChess_Formation_C:IsMonsterCreating()
    return self.MonsterCreatingCount > 0
end

-- function BP_AutoChess_Formation_C:GetCubeHovered()
--     return self.CurrentHoverCubeIndex
-- end

-- function BP_AutoChess_Formation_C:ReceiveTick(DeltaSeconds)
-- end

-- function BP_AutoChess_Formation_C:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function BP_AutoChess_Formation_C:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function BP_AutoChess_Formation_C:ReceiveActorEndOverlap(OtherActor)
-- end

return BP_AutoChess_Formation_C