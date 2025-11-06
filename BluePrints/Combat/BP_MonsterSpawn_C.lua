require("UnLua")
local BP_MonsterSpawn_C = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.Combat.Components.MonsterSpawnComponent",
  "BluePrints.Common.DelayFrameComponent"
})

function BP_MonsterSpawn_C:RealCreateUnits(UnitId, UnitNum, PresetTarget, SourceType, Level)
  DebugPrint("RealCreateUnits CreateUnitNew UnitId:", UnitId, "UnitNum:", UnitNum)
  local FrameCount = UE4.UKismetSystemLibrary.GetFrameCount()
  if self.PreFreameCount ~= FrameCount then
    self.DelayFrameStartCount = 1
    self.PreFreameCount = FrameCount
  end
  for i = 1, UnitNum do
    self:AddDelayFrameFunc(function()
      if "Main" == SourceType and not self:DetectMonsterSpawnTotalNum() then
        DebugPrint("BP_MonsterSpawn_C 刷怪过程中数量已达上限, 直接返回  MonsterSpawnId:", self.UnitSpawnId)
        return
      end
      local Location = self.Locations[self.LocationIndex % self.Locations:Num() + 1]
      self.LocationIndex = self.LocationIndex + 1
      local Context = AEventMgr.CreateUnitContext()
      Context.UnitType = "Monster"
      Context.UnitId = UnitId
      Context.Loc = Location
      Context.MonsterSpawn = self
      Context.BoolParams:Add("RelationSpawn", "Relation" == SourceType)
      Context.IntParams:Add("Level", Level)
      Context:AddObjectParams("PresetTarget", PresetTarget)
      self:DebugPrintMonsterSpawn("RealCreateUnits CreateUnitNew UnitId: " .. UnitId .. " Level: " .. Level)
      self.GameState.EventMgr:CreateUnitNew(Context, false)
      if "Main" == SourceType then
        self:UpdateMonsterSpawnTotalNum(-1)
        self.UnitSpawningNum = self.UnitSpawningNum + 1
      else
        self.RelationSpawningNum = self.RelationSpawningNum + 1
      end
    end, self.DelayFrameStartCount)
    self.DelayFrameStartCount = self.DelayFrameStartCount + 1
  end
end

function BP_MonsterSpawn_C:CheckDungeonReachable(LevelLoader, PresetTarget, SpawnPointInfo)
  local LevelId = LevelLoader:GetLevelIdByLocation(PresetTarget:K2_GetActorLocation())
  local LevelReachable = false
  for DoorIndex, BPArrow in pairs(LevelLoader.LevelId2Doors[LevelId]) do
    local IsHasPath = UE4.UNavigationFunctionLibrary.CheckTwoPosHasPath(SpawnPointInfo.Loc, BPArrow:K2_GetActorLocation(), self.GameMode)
    if IsHasPath == UE4.EPathConnectType.HasPath then
      LevelReachable = true
      break
    end
  end
  return LevelReachable
end

function BP_MonsterSpawn_C:GetAroundDivisionInfos(Loc)
  return self.GameMode:GetAroundDivisionInfos(Loc)
end

function BP_MonsterSpawn_C:AddHostageInfo(Res)
  local HostageEid = self.GameMode:TriggerDungeonComponentFun("GetHostageEid")
  if nil == HostageEid then
    DebugPrint("BP_MonsterSpawn_C  当前预设目标为人质，但不应该在非捕获玩法使用  MonsterSpawnId:", self.UnitSpawnId)
    self:AddPlayerInfo(Res)
    return
  end
  local Hostage = Battle(self):Getentity(HostageEid)
  if not IsValid(Hostage) then
    DebugPrint("BP_MonsterSpawn_C  当前预设目标为人质，人质不存在  MonsterSpawnId:", self.UnitSpawnId)
    self:AddPlayerInfo(Res)
    return
  end
  DebugPrint("BP_MonsterSpawn_C  当前预设目标为人质  MonsterSpawnId:", self.UnitSpawnId, "人质Eid:", HostageEid)
  Res:Add(Hostage)
end

function BP_MonsterSpawn_C:DebugPrintMonsterSpawn(Info)
  if self.GameMode.DebugPrintMonsterSpawn then
    DebugPrint("WARNING:  " .. Info)
  end
end

return BP_MonsterSpawn_C
