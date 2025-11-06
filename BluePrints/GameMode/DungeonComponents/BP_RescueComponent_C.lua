require("UnLua")
local BattleUtils = require("Utils.BattleUtils")
local BP_RescueComponent_C = Class({
  "BluePrints.Common.TimerMgr"
})

function BP_RescueComponent_C:InitRescueComponent()
  self.GameMode = self:GetOwner()
  self.HostageStaticId = 0
  self:SetHostageEid(0)
  self.RescueIsInCommonAlert = false
  self.RescueAlarmTarget = nil
  self.IsHostageRescued = false
  self.IsRescueCountDownTriggered = false
end

function BP_RescueComponent_C:GetHostageEid()
  return self.HostageEid
end

function BP_RescueComponent_C:SetHostageEid(Eid)
  self.HostageEid = Eid
end

function BP_RescueComponent_C:InitRescueBaseInfo()
  local StaticIds = {}
  for i = 1010000001, 1010000008 do
    if self.GameMode.EMGameState:GetStaticCreatorInfo(i) then
      table.insert(StaticIds, i)
    end
  end
  if #StaticIds < 1 then
    GameState(self):ShowDungeonError("RescueComponent:救援玩法内未找到人质刷新点,请检查蓝图配置，当前副本Id: " .. self.GameMode.DungeonId .. ", 当前Json: " .. UE4.URuntimeCommonFunctionLibrary.GetLevelLoadJsonName(self.GameMode))
    return
  end
  local Index = math.random(1, #StaticIds)
  self.HostageStaticId = StaticIds[Index]
  DebugPrint("RescueComponent: 救援玩法 当前人质静态点为： ", self.HostageStaticId)
end

function BP_RescueComponent_C:TriggerSpawnHostage(Player)
  self:StopRescueCountDown()
  self:RemoveHostageDoorIndicator()
  local Creator = self.GameMode.EMGameState:GetStaticCreatorInfo(self.HostageStaticId)
  local HostageExtraInfo = BattleUtils.GetExtraCreateInfo(Creator.UnitType, Creator.UnitId, Creator.UnitId)
  if Player then
    HostageExtraInfo.PhantomOwnerEid = Player.Eid
  end
  HostageExtraInfo.EventName = "RescueHostage"
  Creator:RealActiveStaticCreator(HostageExtraInfo)
  DebugPrint("RescueComponent: 救援玩法 TriggerSpawnHostage")
end

function BP_RescueComponent_C:OnStaticCreatorEvent(EventName, Eid, UnitId, UnitType)
  if "RescueHostage" == EventName then
    self:SetHostageEid(Eid)
    DebugPrint("RescueComponent: 救援玩法 生成人质，当前人质Eid为： ", self:GetHostageEid())
    local Hostage = Battle(self):Getentity(self:GetHostageEid())
    if IsValid(Hostage) then
      Hostage:StopBT("RescueDoor")
      Hostage:ActiveHostageGuide("Add", Eid)
      self.GameMode:TriggerGameModeEvent("OnSpawnHostage")
      self.GameMode:TriggerDungeonAchieve("OnHostageRescued", -1)
      if self.GameMode:GetNeedCreateEmergencyMonster("Pet") then
        self.GameMode:TriggerSpawnPet()
      end
      GameState(self):SyncHostageState(Hostage)
      self.IsHostageRescued = true
    end
  end
end

function BP_RescueComponent_C:TriggerStartHostageBT()
  local Hostage = Battle(self):Getentity(self:GetHostageEid())
  if IsValid(Hostage) then
    Hostage:RestartBT()
    DebugPrint("RescueComponent: 开启人质行为树，Eid:", self:GetHostageEid())
  end
end

function BP_RescueComponent_C:TriggerRescueExitMechanismOverlap(Player)
  DebugPrint("RescueComponent: 救援玩法有玩家到达撤离点, Player Eid =", Player.Eid)
  local Hostage = Battle(self):Getentity(self:GetHostageEid())
  if nil == Hostage then
    DebugPrint("RescueComponent Error: 人质未刷出，无法移动到撤离机关")
  end
  local ExitMachanism = self.GameMode:GetEscapeMechanismActor()
  if nil == ExitMachanism then
    DebugPrint("RescueComponent Error: 撤离机关不存在，人质移动无目标")
  end
  UE4.UNavigationFunctionLibrary.ActorToActorTeleport(Hostage, ExitMachanism)
  Hostage:StopBT("RescueHostageSucceed")
end

function BP_RescueComponent_C:TriggerRescuePlayerDungeonEnd(Player)
  if self.GameMode.EMGameState:CheckGameModeStateNotEnd() then
    Player:ChangeHostageOwner()
  end
end

function BP_RescueComponent_C:TriggerRescueOnEnd()
  local Hostage = Battle(self):Getentity(self:GetHostageEid())
  if Hostage then
    Hostage:EMActorDestroy(EDestroyReason.HostageRescueEnd)
  end
end

function BP_RescueComponent_C:AddHostageDoorIndicator()
  if not self.RescueGuideShowEnable then
    self.RescueGuideShowEnable = true
    local IgnoreList = TArray(0)
    IgnoreList:Add(self.HostageDoor.Eid)
    self.HostageDoor:DeactiveAllGuide(IgnoreList)
  end
end

function BP_RescueComponent_C:RemoveHostageDoorIndicator()
  if self.RescueGuideShowEnable then
    self.RescueGuideShowEnable = false
  end
end

function BP_RescueComponent_C:TriggerRescueTimerLowEvent()
  if not self.RescueLowTimeTriggered then
    self.RescueLowTimeTriggered = true
    self.GameMode:TriggerGameModeEvent("OnRescueCountDownLow")
  end
end

function BP_RescueComponent_C:OnHostageDie(Hostage)
  if Hostage.Eid == self:GetHostageEid() then
    DebugPrint("RescueComponent: 人质死亡！")
    self.GameMode:TriggerGameModeEvent("OnHostageDieBP")
    self.GameMode:TriggerDungeonFailed()
  end
end

function BP_RescueComponent_C:OnHostageDying(Hostage)
  if Hostage.Eid == self:GetHostageEid() then
    DebugPrint("RescueComponent: 人质倒地！")
    self.GameMode:TriggerGameModeEvent("OnHostageDyingBP")
    local NowTime = URuntimeCommonFunctionLibrary.GetNowTimeStamp()
    self.GameMode:AddDungeonEvent("HostageDyingCountDown")
  end
end

function BP_RescueComponent_C:SetRescueHostageDoor(Door)
  self.HostageDoor = Door
end

function BP_RescueComponent_C:StartRescueCountDown()
  if self.IsRescueCountDownTriggered then
    DebugPrint("RescueComponent: 倒计时已触发，不重复添加")
    return
  end
  if self.IsHostageRescued then
    DebugPrint("RescueComponent: 人质已解救，不触发倒计时")
    return
  end
  local DungenData = DataMgr.Rescue[self.GameMode.DungeonId]
  if nil == DungenData then
    DebugPrint("RescueComponent Error: 副本表数据不存在, DungeonId =", self.GameMode.DungeonId)
  end
  self.GameMode.EMGameState:SetRescueCountDownTime(DungenData.HostageRescueTime or 0)
  self.RescueLowTimeThreshold = DungenData.RescueLowTimeThreshold or 0
  self.RescueLowTimeTriggered = false
  self.IsRescueCountDownTriggered = true
  self:AddTimer(1, self.RescueCountDown, true, 0, "RescueCountDownTimer")
  self.GameMode:AddDungeonEvent("RescueCountDownUI")
  self.GameMode:TriggerGameModeEvent("OnRescueCountDownStart")
  DebugPrint("RescueComponent: 处决倒计时开始！时间", DungenData.HostageRescueTime)
end

function BP_RescueComponent_C:RescueCountDown()
  self:AddToRescueCountDownTime(-1)
  DebugPrint("RescueComponent: RescueCountDownTime =", self:GetRescueCountDownTime())
  if self:GetRescueCountDownTime() <= self.RescueLowTimeThreshold then
    self:TriggerRescueTimerLowEvent()
    self:AddHostageDoorIndicator()
  end
  if self:GetRescueCountDownTime() <= 0 then
    self:RemoveHostageDoorIndicator()
    self:StopRescueCountDown()
    self.GameMode:TriggerGameModeEvent("OnHostageDieBP")
    self.GameMode:TriggerDungeonFailed()
  end
end

function BP_RescueComponent_C:StopRescueCountDown()
  if not self.IsRescueCountDownTriggered then
    return
  end
  self:RemoveTimer("RescueCountDownTimer")
  self.GameMode:RemoveDungeonEvent("RescueCountDownUI")
  DebugPrint("RescueComponent: 处决倒计时关闭！")
end

function BP_RescueComponent_C:AddToRescueCountDownTime(Value)
  self.GameMode.EMGameState:SetRescueCountDownTime(math.max(0, self.GameMode.EMGameState.RescueCountDownTime + Value))
  if IsStandAlone(self) then
    self.GameMode.EMGameState:OnRep_RescueCountDownTime()
  end
end

function BP_RescueComponent_C:GetRescueCountDownTime()
  return self.GameMode.EMGameState.RescueCountDownTime
end

function BP_RescueComponent_C:TriggerRescueAlert(Monster)
  self:StartRescueCountDown()
  if Monster.MonAlertComponent then
    Monster.MonAlertComponent:AlertStateChange(Const.FightState, true)
    Monster.MonAlertComponent:RequestRescueAlertSuccess()
  end
  DebugPrint("RescueComponent: 救援玩法触发监狱长警戒, RescueCountDownTime =", self:GetRescueCountDownTime())
end

function BP_RescueComponent_C:TrySetRescueAlertingInfo(LastTargetAlertedNum, Monster)
  if not IsValid(Monster) then
    return false
  end
  if 0 ~= self.GameMode:GetRescueAlertingEid() then
    return false
  end
  if not Monster:IsJailerMonster() then
    return false
  end
  if self.RescueIsInCommonAlert then
    return false
  end
  if self.IsRescueCountDownTriggered then
    return false
  end
  if Monster.TargetAlerted:Num() > 0 then
    self.GameMode:SetRescueAlertingEid(Monster.Eid)
    self.RescueAlarmTarget = Battle(self):GetEntity(Monster.TargetAlerted[1])
    local MonAlertComponent = Monster.MonAlertComponent
    if MonAlertComponent then
      MonAlertComponent:SetAlertValue(math.floor(MonAlertComponent.MaxAlertValue - 1), false)
    end
    Monster:BBSetAlarmTarget(self.RescueAlarmTarget)
    Monster:GetOwnBlackBoardComponent():SetValueAsBool("AlarmTrigger", true)
    DebugPrint("RescueComponent: 救援玩法典狱长抢占报警位成功，开始报警动画---Eid:" .. Monster.Eid .. " UnitId:" .. Monster.UnitId .. " Loc:" .. tostring(Monster:K2_GetActorLocation()) .. " AlarmTargetLoc:" .. tostring(self.RescueAlarmTarget:K2_GetActorLocation()))
    return true
  end
  return false
end

function BP_RescueComponent_C:IsRescueAlertingMonster(Monster)
  if not Monster:IsJailerMonster() then
    return false
  end
  return Monster.Eid == self.GameMode:GetRescueAlertingEid()
end

function BP_RescueComponent_C:TryResetRescueAlertingInfo(Monster)
  if Monster.Eid == self.GameMode:GetRescueAlertingEid() then
    DebugPrint("RescueComponent: 救援玩法典狱长重置报警位成功", Monster.Eid)
    self.GameMode:SetRescueAlertingEid(0)
    Monster:GetOwnBlackBoardComponent():SetValueAsBool("AlarmTrigger", false)
  end
end

function BP_RescueComponent_C:RequestRescueAlarmTargetInfo(Monster)
  if self.RescueAlarmTarget ~= nil then
    return self.RescueAlarmTarget
  end
  local MinDistance, ResPlayer
  for _, Player in pairs(self:GetAllPlayer()) do
    local PlayerDistance = UE4.UKismetMathLibrary.Vector_Distance(Player:K2_GetActorLocation(), Monster:K2_GetActorLocation())
    if nil == MinDistance or MinDistance > PlayerDistance then
      MinDistance, ResPlayer = PlayerDistance, Player
    end
  end
  return ResPlayer
end

return BP_RescueComponent_C
