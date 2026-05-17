local M = Class()

local DefaultBlendTime = 0.5
local DefaultBlendFunc = UE4.EViewTargetBlendFunction.VTBlend_Linear

----------------------------------------------------------外部调用接口-----------------------------------------------------------------

-- 初始化曲线
---@param Player APlayerCharacter 要沿路径移动的玩家
---@param WalkType Enum 玩家行走模式
---@param MoveSpeedRate float 玩家行走速率
---@param bCanMoveReverse bool 玩家在路径上是否能向后移动
---@param bCanExit bool 玩家是否能向后退出路径
---@param IsTriggerable bool 是否启用起点碰撞盒
---@param StopAtEndPoint bool 抵达路径终点后，玩家是否能自由移动
function M:SplineInit(Player, WalkType, MoveSpeedRate, bCanMoveReverse, bCanExit, IsTriggerable, StopAtEndPoint)
	--初始化C++成员
	self.Player = Player
	self.WalkType = WalkType or 0
    self.MoveSpeedRate = MoveSpeedRate or 1.0
    self.bCanExit = bCanExit or false
    self.IsTriggerable = IsTriggerable or false
    if not IsValid(Player) then
		GWorld.logger.error("CinemaMoveSpline:Init, Player is Invalid!")
		return false
	end
    self.PlayerMoveComp = self.Player.CharacterMovement and self.Player.CharacterMovement:Cast(UPlayerCharMoveComp)
    if not IsValid(self.PlayerMoveComp) then
		GWorld.logger.error("CinemaMoveSpline:Init, MoveComp of Player is Invalid!")
        return false
    end
    self.Controller = self.Player.Controller and self.Player.Controller:Cast(ASinglePlayerController)
    if not IsValid(self.Controller) then
		GWorld.logger.error("CinemaMoveSpline:Init, PlayerController is Invalid!")
        return false
    end
    --初始化lua成员
    self.bCanMoveReverse = bCanMoveReverse or false
    self.bStopAtEndPoint = StopAtEndPoint
    self.bEnableCameraSeq = IsValid(self.CameraSequence)
	--状态标记
    self.bStartBoxOverlap = false
    self.BlendCameraInitialized = false
    return true
end

-- 启动曲线
function M:SplineStart()
	if not IsValid(self.Player) then return end
    self.EndPointOverlapBox.OnComponentBeginOverlap:Add(self, self.OnEndBoxOverlap)
    -- 启用起点碰撞盒时，在与起点碰撞盒重叠时进入过渡移动模式
	if self.IsTriggerable then
        if self.StartPointOverlapBox:IsOverlappingComponent(self.Player.CapsuleComponent) then
            self:OnStartBoxOverlap(true)
        end
        self.StartPointOverlapBox.OnComponentBeginOverlap:Add(self, function(Obj, Comp, OtherActor, OtherComp)
        	if not IsValid(self.Player) then return end
            if OtherComp == self.Player.CapsuleComponent then
                self:OnStartBoxOverlap(true)
            end
        end)
        self.StartPointOverlapBox.OnComponentEndOverlap:Add(self, function(Obj, Comp, OtherActor, OtherComp)
        	if not IsValid(self.Player) then return end
            if OtherComp == self.Player.CapsuleComponent then
                self:OnStartBoxOverlap(false)
            end
        end)
    else
    -- 未启用起点碰撞盒时，直接进入Spline移动模式
        self:ExecEnterLogic()
        if (self.bEnableCameraSeq) then
            self:SetActorTickEnabled(true)
        end
    end
end

-- 关闭曲线
---@param EndBlendTime float 摄像机从Sequence混出到玩家镜头的混出时间
function M:SplineEnd(EndBlendTime)
	self.StartPointOverlapBox.OnComponentBeginOverlap:Clear()
    self.StartPointOverlapBox.OnComponentEndOverlap:Clear()
    self.EndPointOverlapBox.OnComponentBeginOverlap:Clear()
    self:SetActorTickEnabled(false)
    
    -- 停止Sequence
    if (self.bEnableCameraSeq) then
        self:SequenceBlendOut(EndBlendTime)
    end

    -- 玩家退出逻辑
    self:ExecQuitLogic()

    -- 清除变量
    self:Clear()
end
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------起点碰撞盒-----------------------------------------------------------------

-- 起点触发盒交互逻辑
function M:OnStartBoxOverlap(bBegin)
    if not IsValid(self.PlayerMoveComp) then return end
    -- 已经在Spline上移动时，无需后续操作
    if (self.PlayerMoveComp.ReachedSplineTarget) then return end
    -- 进入Start碰撞盒时，开始向Spline起点过渡移动（相关逻辑见ACinemaMoveSpline:Tick()
    if self.bStartBoxOverlap == bBegin then return end
    self.bStartBoxOverlap = bBegin
    if bBegin then
    	-- 玩家进入逻辑
        self:ExecEnterLogic()
    else
    	-- 玩家退出逻辑
        self:ExecQuitLogic()
    end
    self:SetActorTickEnabled(bBegin)
end
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------终点碰撞盒-----------------------------------------------------------------

-- 终点触发盒交互逻辑
function M:OnEndBoxOverlap(Comp, OtherActor, OtherComp)
	if not IsValid(self.Player) then return end
	if OtherComp ~= self.Player.CapsuleComponent then return end
	-- 若配置StopAtEndPoint为true，则到达终点后无法后退
	if (self.bStopAtEndPoint) then
		self.Player.bCinemaMoveCanReverse = false
	end
	if self.EndPointOverlapEvent then
		self.EndPointOverlapEvent()
	end
end

-- 绑定终点触发盒回调
function M:BindEventOnEndBoxOverlap(Event)
	if type(Event) ~= "function" then
		return
	end
	if IsValid(self.Player) and self.EndPointOverlapBox:IsOverlappingComponent(self.Player.CapsuleComponent) then
		Event()
	end
	self.EndPointOverlapEvent = Event
end

-- 清除终点触发盒回调
function M:ClearEventOnEndBoxOverlap()
	self.EndPointOverlapEvent = nil
end
-------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------玩家逻辑------------------------------------------------------------------

-- 进入曲线逻辑
function M:ExecEnterLogic()
    if not IsValid(self.Player) then
        return
    end
    if self.Player.PlayerAnimInstance then
        self.OriginalWalkType = self.Player.PlayerAnimInstance.WalkType
        self.OriginalWalkSpeedRate = self.Player.SpeedRate <= 0 and 1 or self.Player.SpeedRate
        self.Player:SetWalkType(self.WalkType)
        self.Player:SetPlayerMaxMovingSpeed(self.MoveSpeedRate)
    end
    local TargetPoint
    if IsValid(self.SplineComponent) then
        TargetPoint = self.SplineComponent:GetLocationAtSplinePoint(0, ESplineCoordinateSpace.World)
    end
    self.Player:StartMoveAlongSpline(self.SplineComponent, TargetPoint, self.bCanMoveReverse, self.IsTriggerable)
    self.Player:MoveAlongSplineBanSkills()
    self.Player:ForbidActionWhileMoveAlongSpline(true)
    if (self.bEnableCameraSeq) then
        self:LockPlayerCamera(true)
    end
    if (self.IsTriggerable) then
        self:StartCameraGuidance()
    end
end

-- 离开曲线逻辑
function M:ExecQuitLogic()
    if not IsValid(self.Player) then
        return
    end
    self.Player:EndMoveAlongSpline()
    self.Player:MoveAlongSplineUnBanSkills()
    self.Player:ForbidActionWhileMoveAlongSpline(false)
    if self.OriginalWalkType then
        self.Player:SetWalkType(self.OriginalWalkType)
        self.Player:SetPlayerMaxMovingSpeed(self.OriginalWalkSpeedRate)
    end
    if (self.bEnableCameraSeq) then
        self:LockPlayerCamera(false)
    end
    if (self.IsTriggerable) then
        self:StopCameraGuidance()
    end
end
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------镜头逻辑-------------------------------------------------------------------

-- 锁定/解锁玩家镜头
function M:LockPlayerCamera(bLock)
    if not IsValid(self.Controller) then
        return
    end
    self.CameraLocked = bLock
	if (bLock) then
    	self.Controller:AddDisableRotationInputTag("CinemaMoveSpline")
    else
    	self.Controller:RemoveDisableRotationInputTag("CinemaMoveSpline")
    end
end

-- 将镜头引导向路径起点
function M:StartCameraGuidance()
	local CurrentPitch = 0
    if (IsValid(self.Controller)) then
    	local CurrentRotation = self.Controller:GetControlRotation()
    	CurrentPitch = CurrentRotation.Pitch
    end
    local DestRotation = FRotator(CurrentPitch, 0, 0)
    self.Player.CameraRotationComponent:SetControlRotationAbsolute_Lerp(DestRotation, 1, 5, false, function()
    end)
    if (self.bEnableCameraBlend) then
        self:InitBlendCamera()
    end
end

-- 结束镜头引导
function M:StopCameraGuidance()
    self.Player.CameraRotationComponent:StopControlRotationLerp()
    if (self.BlendCameraInitialized) then
        USequenceFunctionLibrary.SetViewTargetWithBlend(self.Controller, self.Player, DefaultBlendTime, DefaultBlendFunc)
    end
    self.BlendCameraInitialized = false;
end

-- 初始化过渡镜头(用于将玩家镜头过渡到Sequence镜头)
function M:InitBlendCamera()
    if (not self.CameraLocked) then return end
    if (not IsValid(self.BlendCamera)) then
        return
    end
    local BlendCamera = self.BlendCamera
    local CameraComp = self.Player:GetCameraComponent();
    local CineCamComponent = BlendCamera:GetCineCameraComponent();
    CineCamComponent:SetFieldOfView(CameraComp.FieldOfView);
    CineCamComponent.bConstrainAspectRatio = CameraComp.bConstrainAspectRatio;
    BlendCamera:K2_SetActorLocationAndRotation(CameraComp:K2_GetComponentLocation(), CameraComp:K2_GetComponentRotation(),false,nil,false)
    self:UpdateBlendCameraLoc(self.Player:K2_GetActorLocation())
    USequenceFunctionLibrary.SetViewTargetWithBlend(self.Controller, BlendCamera, DefaultBlendTime, DefaultBlendFunc)
    self.BlendCameraInitialized = true;
end

-- Sequence镜头过渡至玩家镜头
function M:SequenceBlendOut(EndBlendTime)
    if (IsValid(self.Controller)) then
        local ViewTarget = self.Controller:GetViewTarget()
        local ViewLocation, ViewRotation = ViewTarget:GetActorEyesViewPoint()
        local BlendCamera = self.BlendCamera
        if (IsValid(BlendCamera)) then
            BlendCamera:K2_SetActorLocationAndRotation(ViewLocation, ViewRotation,false,nil,false)
        end
    end
    if (IsValid(self.SequenceActor)) then
        local SequencePlayer = self.SequenceActor:GetSequencePlayer()
        if (IsValid(SequencePlayer)) then
            SequencePlayer:StopAtCurrentTime()
        end
    end
    USequenceFunctionLibrary.SetViewTargetWithBlend(self.Controller, self.Player, EndBlendTime, DefaultBlendFunc)
end
-------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------清理------------------------------------------------------------------
function M:Clear()
    -- 清除状态变量
    self.BlendCameraInitialized = false
    self.bStartBoxOverlap = false
    self.CameraLocked = false

    -- 清除引用
    self.PlayerMoveComp = nil
    self.Player = nil
end

function M:ReceiveEndPlay()

end
-------------------------------------------------------------------------------------------------------------------------------------
return M
