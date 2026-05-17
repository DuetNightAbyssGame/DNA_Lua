--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
---@type BP_Trolly_C
local BP_Trolly_C = Class({
    "BluePrints/Item/DefenceCore/BP_DefenceBase_C",
    "BluePrints.Common.TimerMgr",
})
local ToastTimerCD = DataMgr.GlobalConstant.HijackToastTime.ConstantValue

function BP_Trolly_C:AuthorityInitInfo(Info)
    BP_Trolly_C.Super.AuthorityInitInfo(self,Info)
    --加速阶段每次吸收的护盾值百分比
    self.ESAbsorbRatio = self.UnitParams["ESAbsorbRatio"] or 0.1
    --满速阶段每次吸收的护盾值
    -- self.ESAbsorbValue = self.UnitParams["ESAbsorbValue"] or 5
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode:IsInDungeon() then
        self.ESAbsorbValue = DataMgr.Hijack[GWorld.GameInstance:GetCurrentDungeonId()]["ESAbsorbValue"] or 5
    else
        self.ESAbsorbValue = 5  -- 区域推车，暂时写死
    end
    --吸护盾的范围
    self.AbsorbRange = self.UnitParams["AbsorbRange"] or 400
    self.SkillEffect = self.UnitParams["SkillEffect"] or 0
    self.Speed = self.MinSpeed

    self.NowPathId = 1
    self.NextPathId = 1
    self.Distance = 0
    self.CurrentAccelerationValue = 0
    self.bFirstActive = false

    self:CreateSpline()

    --OpenState，交互机关参数，负责车的停下和启动。ForceStop, 可交互，但是不可移动的状态
    self.bMove = false
    self.ForceStop = false
    if GameMode:GetDungeonComponent() then
        -- GameMode:GetDungeonComponent().Trolly = self
    else
        GameMode.Trolly = self
    end
    self:SetCollisionType("BodyCollision", "Item", ECollisionResponse.ECR_OverLap, false)
end

function BP_Trolly_C:CommonInitInfo(Info)
    BP_Trolly_C.Super.CommonInitInfo(self,Info)
    -- self.ChestInteractiveComponent:InitInteractiveComponent(self.Data.InteractiveId)
    self:AddTimer(0.5, self.AbsorbES, true)
    self:AddTimer(0.5, self.UpdateAnim, true)
    self.MinSpeed = self.UnitParams["MinSpeed"] or 0
    self.MaxSpeed = self.UnitParams["MaxSpeed"] or 0
    self.RunStateId = self.UnitParams["RunStateId"] or 0
    self.Distance = 0
end

function BP_Trolly_C:ClientInitInfo(Info)
    BP_Trolly_C.Super.ClientInitInfo(self,Info)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if UIManager then
        UIManager:LoadUINew("DungeonHijackFloat")
		self.UIPanel = UIManager:GetUIObj("DungeonHijackFloat")
		if self.UIPanel then
            self.UIPanel:OnDungeonUIStateUpdated()
            self:UpdateSpeed()
            self:AddTimer(0.1,self.RefreshHp,true,0,"RefreshTrollyTimer")
		end
	end
    self:CreateUISpline()
    -- self.ClientLerpTime = 0
    -- self.LerpTotalTime = 0.2
    self.ToastTimerCD = DataMgr.GlobalConstant.HijackToastTime.ConstantValue
end

function BP_Trolly_C:ReceiveTick(DeltaSeconds)
    self:Move(DeltaSeconds)
    self.Overridden.ReceiveTick(self,DeltaSeconds)
end
-------------------交互相关---------------------------
function BP_Trolly_C:OpenMechanism(PlayerId)
    if self.CurrentWall then
        --弹UI提示玩家破坏墙壁，先用log代替
        print(_G.LogTag,"Error: Attack Wall")
    elseif not self.ForceStop then
		local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        if GameMode and not self.bFirstActive then
			GameMode:SetClientDungeonUIState(Const.EDungeonUIState.OnTarget)
            GameMode:TriggerGameModeEvent("OnTrollyFirstActive", self)
        end
        self.IsActive = true
        self.bMove = true
        self.bFirstActive = true
    end
end

function BP_Trolly_C:GetCanOpen(PlayerId)
    self.CanOpen = (self.bMove == false) or not (self.bMove == true and not self.CurrentWall)
end

-------------------交互相关---------------------------

-------------------移动相关---------------------------
function BP_Trolly_C:CreateSpline()
    local SplinePath = UE4.UClass.Load('/Game/BluePrints/Item/DefenceCore/BP_TrollySpline.BP_TrollySpline')
    local Transform = FTransform()
    Transform.Translation = self:GetTransform().Translation
    self.Spline = self:GetWorld():SpawnActor(SplinePath, Transform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
    self.Spline.Spline:ClearSplinePoints(false)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    GameState.NowPathId = self.NowPathId
    GameState.NextPathId = self.NextPathId
    self:AddNewPath()
end

function BP_Trolly_C:CreateUISpline()
    DebugPrint("1111111111111111111111 CreateUISpline")
    self.AlreadyCreateUISpline = true
    local SplinePath = UE4.UClass.Load('/Game/BluePrints/Item/DefenceCore/BP_TrollySpline.BP_TrollySpline')
    local Transform = FTransform()
    Transform.Translation = self:GetTransform().Translation
    if not IsAuthority(self) then
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        GameState.NowPathId = 1
        GameState.NextPathId = 1
    end

	self.UISpline = self:GetWorld():SpawnActor(SplinePath, Transform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
    DebugPrint("1111111111111111111111 CreateUISpline",self.UISpline)
	self:UpdatePath(self.UISpline)
end

function BP_Trolly_C:AddNewPath()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode:GetDungeonComponent() then
        return
    end
    local PointList = GameMode:TriggerDungeonComponentFun("GetNextPathInfos", self.NowPathId)
    if not PointList then
        return
    end
    table.sort(PointList, function(a, b)
        return a.PathPointIndex < b.PathPointIndex
    end)
    for i, v in pairs(PointList) do
        print(_G.LogTag,"LXZ AddNewPath", v:GetName(),v:K2_GetActorLocation())
		self.Spline:AddPoint(v:K2_GetActorLocation(), i-1, v)
        self.PositionArray:Add(v:K2_GetActorLocation())
    end
    self.NowPathId = self.NextPathId
    self.NextPathId = PointList[#PointList].NextPathId
    self.SplineLength = self.Spline.Spline:GetSplineLength()
    self.Percent = self.Distance/self.SplineLength
    if self.NowPathId == 1 then
        local Transform = self.Spline:GetMoveTransform(self.Percent)
        Transform = FTransform(Transform.Rotation, Transform.Translation + FVector(0,0,154), self:GetActorScale3D())
        self:K2_SetActorTransform(Transform, false, nil, false)
    end
end

function BP_Trolly_C:Move(DeltaSeconds)
    if IsClient(self) then
        if self.AlreadyCreateUISpline and (not self.UIPanel or not self.UIPanel.UISpline) then
            self.UIPanel = UIManager(self):GetUIObj("DungeonHijackFloat")
            if self.UIPanel then
                self:UpdatePath(self.UISpline)
            end
            if not self:IsExistTimer("RefreshTrollyTimer") then
                self:AddTimer(0.1,self.RefreshHp,true,0,"RefreshTrollyTimer")
            end
        end
    end

    if self:CheckAndHandleStop(DeltaSeconds) then
        return
    end
    -- if not self.bMove or self.CurrentWall then
    --     if IsDedicatedServer(self) then
    --         self:SetServerTrollyPos(self:GetTransform())
    --     else
    --         -- self:K2_SetActorTransform(self.ServerPosInfo.Transform, false, nil, false)
    --         self:LerpToServer()
    --         self:UpdateSpeed()
    --     end
    --     return
    -- end

    -- print(_G.LogTag,"LXZ Move", self.bMove, self.Speed, self.ForceStop)
    -- local LastSpeed = self.Speed
    -- local MinSpeed = 0
    --强制停止状态下，小车用给定的加速度减速到停止，加速度外部传入;
    --非强制停止状态下，小车用策划指定的加速度前进,且最慢不会慢于策划指定的最低速度
    self:Move_Main(DeltaSeconds)
    -- if IsAuthority(self) and not self.ForceStop then
    --     MinSpeed = self.MinSpeed
    --     for i, v in pairs(self.Acceleration) do
    --         if self.AbsordedValue >= i then
    --             self.CurrentAccelerationValue = v
    --             break
    --         end
    --     end
    -- end

    -- --print(_G.LogTag,"LXZ Move", DeltaSeconds, self.CurrentAccelerationValue)
    -- local NextSpeed = (self.Speed + DeltaSeconds * self.CurrentAccelerationValue)
    -- NextSpeed = math.min(NextSpeed, self.MaxSpeed)
    -- NextSpeed = math.max(NextSpeed, MinSpeed)

    -- self.CurrentSpeed = self.Speed*self.SpeedRate
    -- print(_G.LogTag,"LXZ Move", self.SpeedRate)
    -- self.Distance = self.Distance + (NextSpeed - self.Speed) * self.SpeedRate * DeltaSeconds/2 + self.CurrentSpeed * DeltaSeconds
    -- if IsAuthority(self) then
    --     self.Percent = self.Distance/self.SplineLength
    --     if self.Percent >= 1 then
    --         self:AddNewPath()
    --     end
    --     local Transform = self.Spline:GetMoveTransform(self.Percent)
    --     Transform.Translation.Z = Transform.Translation.Z + 154
    --     Transform.Scale3D = self:GetActorScale3D()
    --     self:K2_SetActorTransform(Transform, false, nil, false)
    --     self:SetServerTrollyPos(Transform)
    -- end

    self:ClientMove(DeltaSeconds)
    -- if IsClient(self) then
    --     self:RemoveTimer("LerpWhiledStop")
    --     if self.ClientTargetTransform and self.ClientLerpTime < self.LerpTotalTime then
    --         self.ClientLerpTime = self.ClientLerpTime + DeltaSeconds
    --         local LerpResult = UE.UKismetMathLibrary.TLerp(self.StartTransForm,self.ClientTargetTransform,self.ClientLerpTime/self.LerpTotalTime)
    --         self:K2_SetActorTransform(LerpResult, false, nil, false)
    --         -- DebugPrint("CLIENT LERP ",LerpResult,self.ClientTargetTransform,self.ClientLerpTime,self.LerpTotalTime,self.ClientLerpTime/self.LerpTotalTime)
    --         -- DebugPrint("CurrentAcceleration = ",self.CurrentAcceleration)
    --         if self.ClientLerpTime >= self.LerpTotalTime then
    --             self.SplinePercent = self.ServerPosInfo.Percent
    --             self.Distance = self.ServerPosInfo.Distance
    --         end
    --     elseif self.SplineClient then
    --         self.SplineLength = self.SplineClient.Spline:GetSplineLength()
    --         self.SplinePercent = self.Distance/self.SplineLength
    --         if self.SplinePercent <= 1.0 then
    --             if self.Distance <= self.ServerPosInfo.Distance + 50 then
    --                 local Transform = self.SplineClient:GetMoveTransform(self.SplinePercent)
    --                 Transform.Translation.Z = Transform.Translation.Z + 154
    --                 Transform.Scale3D = self:GetActorScale3D()
    --                 --DebugPrint("CLIENT TEST------- ",self.SplineLength,self.SplinePercent,Transform)
    --                 self:K2_SetActorTransform(Transform, false, nil, false)
    --             else
    --                 self.Distance = (self.LastSplinePercent or 0) * self.SplineLength
    --                 self.SplinePercent = self.Distance/self.SplineLength
    --             end
    --         else
    --             self.Distance = self.SplineLength
    --             self.SplinePercent = 1.0
    --         end
    --         self.LastSplinePercent = self.SplinePercent
    --     end
    -- end

    --最大速度音效，只在进入和退出切换播放
    self:Move_Sound(DeltaSeconds)
    -- if LastSpeed == self.MaxSpeed and NextSpeed < self.MaxSpeed then
    --     self:PlayExitMaxSpeedSound()
    -- elseif LastSpeed < self.MaxSpeed and NextSpeed >= self.MaxSpeed then
    --     self:PlayMaxSpeedSound()
    -- end
    -- self.Speed = math.min(self.Speed + self.CurrentAccelerationValue * DeltaSeconds, self.MaxSpeed)
    -- self.Speed = math.max(self.Speed, MinSpeed)
    -- self.Speed = NextSpeed
    -- if self.ForceStop and self.Speed == 0 then
    --     self.CurrentAccelerationValue = 0
    --     self.bMove = false
    -- end

    self:UpdateUIStateAfterMove()
    -- if not IsAuthority(self) or IsStandAlone(self) then
    --     if self.Speed == self.MinSpeed and self.StateId == 240 then
    --         if not self:IsExistTimer("TrollyToastTimer") then
    --             self:AddTimer(ToastTimerCD,self.TryToShowToast,true,0,"TrollyToastTimer")
    --         end
    --     else
    --         self:RemoveTimer("TrollyToastTimer")
    --     end
    --     self:UpdateSpeed()
    --     self:UpdateUILength()
    -- end
end

function BP_Trolly_C:Stop(Wall)
    self.bMove = false
    self.Speed  = 0
    if Wall then
        self.CurrentWall = Wall
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        if GameMode then
            GameMode:TriggerGameModeEvent("OnWallCrashed", self)
        end
        -- self:ChangeState("Manual", 0, 241)
    end
    self:UpdateSpeed()
end

function BP_Trolly_C:GetSplineMoveTransform(Wall)
    return self.Spline:GetMoveTransform(self.Percent)
end

-------------------移动相关---------------------------

-------------------撞击相关---------------------------
function BP_Trolly_C:Crash(Wall)
    -- if Wall.CurrentPathIndex ~= self.NowPathId then
    --     return
    -- end 
    -- self.Overridden.Crash(self,Wall)
    Wall:OnCrashed(self)
end
-------------------撞击相关---------------------------

-------------------UI---------------------------
function BP_Trolly_C:RefreshHp()
    if not IsValid(self.UIPanel) then self.UIPanel = nil end
	if self.UIPanel then
		local NewHp = self:GetAttr("Hp")
		local MaxHp = self.MaxHp or self:GetAttr("MaxHp")
		self.UIPanel:OnCarDamage(NewHp, MaxHp)
	end
end

function BP_Trolly_C:UpdateSpeed()
    if not IsValid(self.UIPanel) then self.UIPanel = nil end
	if self.UIPanel then
        local CurrentSpeed = self.bMove and self.CurrentSpeed or 0
		self.UIPanel:UpdateSpeed(CurrentSpeed, self.CurrentAccelerationValue, self.MaxSpeed, self.MinSpeed,self.StateId,self)
	end
end

function BP_Trolly_C:UpdateUILength()
    if not IsValid(self.UIPanel) then self.UIPanel = nil end
	if self.UIPanel then
		self.UIPanel:UpdateUILength(self.Distance)
	end
end

function BP_Trolly_C:UpdatePath(SplineActor)
    if not IsValid(self.UIPanel) then self.UIPanel = nil end
	if self.UIPanel then
		self.UIPanel:UpdatePath(SplineActor)
	end
end

function BP_Trolly_C:TriggerBoxStop()
    if not IsValid(self.UIPanel) then self.UIPanel = nil end
	if self.UIPanel then
		self.UIPanel:TriggerBoxStop()
	end
end

function BP_Trolly_C:TryToShowToast()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()

    local Target = self.AbsorbTarget
    if not Target then
        Target = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    end
    local Text = (self:K2_GetActorLocation() - Target:K2_GetActorLocation()):Size() > DataMgr.TargetFilter["TrollyAbsorbES"].LuaFilterParaments.Radius and "DUNGEON_HIJACK_116" or "DUNGEON_HIJACK_115"
    if UIManager  then
        UIManager:ShowUITip(UIConst.Tip_CommonTop,GText(Text))
    end
end

-------------------UI---------------------------

------------------功能型函数---------------------------
function BP_Trolly_C:OnFirstActive()
    -- self.Overridden.OnFirstActive(self)
end

function BP_Trolly_C:PlayMoveSound()
    -- print(_G.LogTag,"LXZ PlayMoveSound")
    AudioManager(self):PlayFMODSound(self, nil, self.MoveSoundPath, "TrollyMove",nil,nil,true,false,nil,true)
    self:AddTimer(0.5, self.SetMoveSoundParam, true, 0, "TrollyMoveSound")
end

function BP_Trolly_C:SetMoveSoundParam()
    -- print(_G.LogTag,"LXZ SetMoveSoundParam")
    AudioManager(self):SetEventSoundParam(self, "TrollyMove", {Speed = self.Speed/self.MaxSpeed})
end

function BP_Trolly_C:StopMoveSound()
    -- print(_G.LogTag,"LXZ StopMoveSound")
    AudioManager(self):StopSound(self, "TrollyMove")
    self:RemoveTimer("TrollyMoveSound")
end

function BP_Trolly_C:PlayMaxSpeedSound()
    -- print(_G.LogTag,"LXZ PlayMaxSpeedSound")
    AudioManager(self):StopSound(self, "TrollyExitMaxSpeed")
    AudioManager(self):PlayFMODSound(self, nil, self.MaxSpeedSoundPath, "TrollyMaxSpeed",nil,nil,true,false,nil,true)
end

function BP_Trolly_C:PlayExitMaxSpeedSound()
    -- print(_G.LogTag,"LXZ PlayExitMaxSpeedSound")
    AudioManager(self):StopSound(self, "TrollyMaxSpeed")
    AudioManager(self):PlayFMODSound(self, nil, self.ExitMaxSpeedSoundPath, "TrollyExitMaxSpeed")
end

------------------功能型函数---------------------------

-- function M:Initialize(Initializer)
	-- end

	-- function M:UserConstructionScript()
		-- end
		
		-- function M:ReceiveBeginPlay()
-- end

-- function M:ReceiveEndPlay()
	-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
	-- end
	
	-- function M:ReceiveActorEndOverlap(OtherActor)
		-- end

function BP_Trolly_C:OnRep_PositionArray()
    if not self.SplineClient then
        local SplinePath = UE4.UClass.Load('/Game/BluePrints/Item/DefenceCore/BP_TrollySpline.BP_TrollySpline')
        local Transform = FTransform()
        Transform.Translation = self:GetTransform().Translation
        self.SplineClient = self:GetWorld():SpawnActor(SplinePath, Transform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
        self.SplineClient.Spline:ClearSplinePoints(false)
    end

    if not self.ClientPointArrayIndex then self.ClientPointArrayIndex = 1 end
    local Array = self.PositionArray:ToTable()
    DebugPrint("Client Test ClientAddSplinePoint  TryToAdd",self.ClientPointArrayIndex,#Array)
    local Num = 0
    for i = self.ClientPointArrayIndex,#Array do
        DebugPrint("Client Test ClientAddSplinePoint",Array[i],i,self.ClientPointArrayIndex)
        self.SplineClient:AddPoint(Array[i],i-1,nil)
        Num = Num + 1
    end
    self.ClientPointArrayIndex = self.ClientPointArrayIndex + Num
    self.SplineLength = self.SplineClient.Spline:GetSplineLength()
    self.SplinePercent = (self.Distance or 0)/self.SplineLength
    DebugPrint("TrollyClientDebug OnRep_PositionArray",self.SplinePercent,self.Distance)
    self:OnRep_ServerPosInfo()
end

-- function BP_Trolly_C:SetServerTrollyPos(Transform)
--     if not Transform or not self.ServerPosInfo then return end
--     self.ServerPosInfo.Transform = Transform
--     self.ServerPosInfo.Percent = self.Percent
--     self.ServerPosInfo.Distance = self.Distance
--     self.ServerPosInfo.SplinePointNum = self.PositionArray:Num()
-- end

-- function BP_Trolly_C:ClientAdjustPos()
--     local SplinePointNum = self.PositionArray:Num()
--     local Percent = self.SplinePercent
--     DebugPrint("ClientAdjustPos  ",self.ServerPosInfo.SplinePointNum,SplinePointNum,self.ServerPosInfo.Percent,Percent,
--     self.ServerPosInfo.Distance,self.Distance,self.ServerPosInfo.Transform)
--     if SplinePointNum ~= self.ServerPosInfo.SplinePointNum or Percent - 0.0001 > self.ServerPosInfo.Percent then
--         return
--     end
--     self.ClientLerpTime = 0
--     self.LerpTotalTime = 0.2
--     self.ClientTargetTransform = self.ServerPosInfo.Transform
--     self.StartTransForm = self:GetTransform()
-- end

-- function BP_Trolly_C:LerpToServer()
--     if self:IsExistTimer("LerpWhiledStop") or self.ServerPosInfo.Percent == 0 then return end
--     local StartTrans = self:GetTransform()
--     local TargetTrans = self.ServerPosInfo.Transform
--     local TotalTime = 0.5
--     local SpendTime = 0
--     self:AddTimer(0.05,function ()
--         SpendTime = SpendTime + 0.05
--         local Temp = UE.UKismetMathLibrary.TLerp(StartTrans,TargetTrans,SpendTime/TotalTime)
--         self:K2_SetActorTransform(Temp,false, nil, false)
--         if (SpendTime >= TotalTime) then self:RemoveTimer("LerpWhiledStop") end
--     end,true,nil,"LerpWhiledStop")
-- end

return BP_Trolly_C
