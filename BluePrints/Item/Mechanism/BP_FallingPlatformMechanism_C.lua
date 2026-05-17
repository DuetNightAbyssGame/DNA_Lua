--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_FallingPlatformMechanism_C
local BP_FallingPlatformMechanism_C = Class({
    "BluePrints.Item.BP_CombatItemBase_C",
})

function BP_FallingPlatformMechanism_C:OnPlayerIn(Player)
    if self.OnBreak then
        return
    end
    if not self.IsInside then
        self:ChangeState("Manual", 0, self.BrokenStateId)
    end
    self.IsInside = true
end

function BP_FallingPlatformMechanism_C:OnPlayerOut(Player)
    self.IsInside = false
end

function BP_FallingPlatformMechanism_C:FallDown()
    self.IsInside = false
    self.Cube:SetVisibility(false,true)
    self:AddTimer(self.ReplaceTime, self.FallUp)
    self.Cube:SetCollisionEnabled(0)
end

function BP_FallingPlatformMechanism_C:FallUp()
    self:ChangeState("Manual", 0, self.RecoverStateId)
end

function BP_FallingPlatformMechanism_C:ResetCollision()
    self.Cube:SetCollisionEnabled(3)
end

function BP_FallingPlatformMechanism_C:MoveDown()
    local Loc = self:K2_GetActorLocation()
    Loc.Z = Loc.Z-1000
    self:K2_SetActorLocation(Loc,false,nil,false)
end

--- 在平台恢复时，将平台范围内的玩家推到平台上方，避免卡入碰撞
function BP_FallingPlatformMechanism_C:AdjustPlayersAbovePlatform()
    if not self.CollisionMesh then
        return
    end
    local UKismetSystemLibrary = UE.UKismetSystemLibrary

    -- 获取 CollisionMesh 的世界位置和包围盒
    local MeshLoc = self.CollisionMesh:K2_GetComponentLocation()
    local Origin, BoxExtent = self.CollisionMesh:GetLocalBounds()

    -- 考虑缩放，得到世界空间下的包围盒半尺寸
    local WorldScale = self.CollisionMesh:K2_GetComponentScale()
    local ScaledExtent = UE.FVector(
        BoxExtent.X * WorldScale.X,
        BoxExtent.Y * WorldScale.Y,
        BoxExtent.Z * WorldScale.Z
    )

    -- 平台顶部 Z
    local PlatformTopZ = MeshLoc.Z + ScaledExtent.Z

    -- 使用 BoxOverlapActors 在平台区域做范围检测
    -- ObjectTypes: 3 = Pawn
    local ObjectTypes = UE.TArray(UE.EObjectTypeQuery)
    ObjectTypes:Add(UE.EObjectTypeQuery.Pawn)

    local ActorsToIgnore = UE.TArray(UE.AActor)
    ActorsToIgnore:Add(self)

    local OutActors = UE.TArray(UE.AActor)
    local bHit = UKismetSystemLibrary.BoxOverlapActors(
        self,
        MeshLoc,           -- 检测中心
        ScaledExtent,      -- 检测半尺寸
        ObjectTypes,       -- 检测对象类型 (Pawn)
        nil,               -- ActorClassFilter (nil = 所有)
        ActorsToIgnore,    -- 忽略自身
        OutActors          -- 输出结果
    )

    if bHit then
        for i = 1, OutActors:Length() do
            local Actor = OutActors:Get(i)
            local CapsuleComp = Actor.CapsuleComponent or Actor.CollisionComponent
            if CapsuleComp then
                local CapsuleHalfHeight = CapsuleComp:GetScaledCapsuleHalfHeight()
                local PlayerLoc = Actor:K2_GetActorLocation()

                local PlayerFootZ = PlayerLoc.Z - CapsuleHalfHeight
                if PlayerFootZ < PlatformTopZ then
                    -- 将玩家放到平台顶部 + 胶囊体半高 + 安全偏移
                    PlayerLoc.Z = PlatformTopZ + CapsuleHalfHeight + 5.0
                    Actor:K2_SetActorLocation(PlayerLoc, false, nil, true)
                end
            end
        end
    end
end

function BP_FallingPlatformMechanism_C:OnEnterState(NowStateId)
    self.Overridden.OnEnterState(self, NowStateId)

    if NowStateId == self.BrokenStateId and not self.OnBreak then
        if self.OnPlatformBreak then
            self:OnPlatformBreak()
            self.OnPlayerInHandle = self:AddTimer(self.WarningTime, self.FallDown)
        end
    elseif NowStateId == self.RecoverStateId then
        if self.OnPlatformReplace then
            self:OnPlatformReplace()
        end
        self.Cube:SetVisibility(true,true)
    elseif NowStateId == self.NormalStateId then
        self:AdjustPlayersAbovePlatform()
    end
end

return BP_FallingPlatformMechanism_C
