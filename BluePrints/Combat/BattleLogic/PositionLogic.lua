
local Component = {}

-- 检查某个目标是否在角度内
--function Component:CheckInAngle(CenterPos, Forward, Target, Radius, Angle)
--    local TargetLocation = Target:K2_GetComponentLocation()
--    TargetLocation = FVector(TargetLocation.X, TargetLocation.Y, 0)
--    Forward = FVector(Forward.X, Forward.Y, 0)
--    CenterPos = FVector(CenterPos.X, CenterPos.Y, 0)
--    local bInSector = true
--    if Angle and Angle > 0 then
--        bInSector = UFormulaFunctionLibrary.IsInsideSector(TargetLocation, CenterPos, Forward, Angle)
--    end
--    
--    Target = Target:GetOwner()
--    if MiscUtils.GetGameCofingSettings("bUseFlatPolygon") then
--        local CenterPos2D = UE4.UKismetMathLibrary.Conv_VectorToVector2D(CenterPos)
--        local Forward2D = UE4.UKismetMathLibrary.Conv_VectorToVector2D(Forward)
--        local TargetLoc2D = UE4.UKismetMathLibrary.Conv_VectorToVector2D(TargetLocation)
--        bInSector = self:CheckFlatCircleSector(Target, CenterPos2D, Forward2D, TargetLoc2D, Radius, Angle)
--    end
--    return bInSector
--end

-- 对目标列表进行过滤，过滤条件是在角度内
--function Component:FilterInAngle(TempTargets, CenterPos, Forward, Radius, Angle)
--    local Targets = TArray(AActor)
--    local CollisionCompMap = {}
--    for _, TargetComp in pairs(TempTargets) do
--        if self:CheckInAngle(CenterPos, Forward, TargetComp, Radius, Angle) then
--            local TargetActor = TargetComp:GetOwner()
--            Targets:AddUnique(TargetActor)
--            
--            self:AddCollisionCompToMap(CollisionCompMap, TargetActor, TargetComp)
--        end
--    end
--
--    return Targets, CollisionCompMap
--end

--function Component:CheckCylinderHit(Source, CenterPos, ObjectTypes, Radius, Height, Angle, Debug)
--    local ActorsToIgnore = TArray(AActor)
--    -- 圆柱是胶囊体和长方体的交
--    local TempTargets1 = TArray(UPrimitiveComponent)
--    local bHit1 = UE4.UKismetSystemLibrary.CapsuleOverlapComponents(Source, CenterPos, Radius, (Height/2.0 + Radius), ObjectTypes, UPrimitiveComponent, ActorsToIgnore, TempTargets1)
--
--    local TempTargets2 = TArray(UPrimitiveComponent)
--    local BoxExtent = FVector(Radius, Radius, Height/2)
--    local bHit2 = UE4.UKismetSystemLibrary.BoxOverlapComponents(Source, CenterPos, BoxExtent, ObjectTypes, UPrimitiveComponent, ActorsToIgnore, TempTargets2)
--    if  _G.DrawDebugTest or Debug then
--        local Start = FVector(CenterPos.X, CenterPos.Y, CenterPos.Z + Height/2.0)
--        local End = FVector(CenterPos.X, CenterPos.Y, CenterPos.Z - Height/2.0)
--        local Color = UE4.FLinearColor(math.random(0,1), math.random(0,1), math.random(0,1), 1)
--        UE4.UKismetSystemLibrary.DrawDebugCylinder(Source, Start, End, Radius, 12, Color, 2, 3)
--
--        -- local SourceRotation = Source:K2_GetActorRotation()
--        -- local Color = UE4.FLinearColor(math.random(0,1), math.random(0,1), math.random(0,1), 1)
--        -- UE4.UKismetSystemLibrary.DrawDebugBox(Source, CenterPos, BoxExtent, Color, SourceRotation, 2, 3)
--    end
--    if not bHit1 and not bHit2 then
--        return TArray(AActor)
--    end
--
--    local TempTargets = CommonUtils.Intersection_Table(TempTargets1, TempTargets2)
--    -- PrintTable(TempTargets,2, "TempTargets")
--    local Targets, CollisionComps = self:FilterInAngle(TempTargets, CenterPos, Source:GetActorForwardVector(), Radius, Angle)
--    -- MiscUtils.PrintArray(Targets,"Targets")
--    return Targets, CollisionComps
--end
--
--function Component:CheckSphereHit(Source, CenterPos, ObjectTypes, Radius, Angle, Debug)
--    local ActorsToIgnore = TArray(AActor)
--    local TempTargets = TArray(UPrimitiveComponent)
--    local bHit = UE4.UKismetSystemLibrary.SphereOverlapComponents(Source, CenterPos, Radius, ObjectTypes, UPrimitiveComponent, ActorsToIgnore, TempTargets)
--    if _G.DrawDebugTest or Debug then
--        local Color = UE4.FLinearColor(math.random(0,1), math.random(0,1), math.random(0,1), 1)
--        UE4.UKismetSystemLibrary.DrawDebugSphere(Source, CenterPos, Radius, 12, Color, 2, 3)
--    end
--
--    if not bHit then
--        return
--    end
--
--    local Targets, CollisionComps = self:FilterInAngle(TempTargets, CenterPos, Source:GetActorForwardVector(), Radius, Angle)
--    return Targets, CollisionComps
--end

--function Component:PositionInCone(Position, ConeOrigin, Direction, Height, Angle)
--    local MathFunctionLibrary = UE.UClass.Load("/Game/BluePrints/Common/BP_MathFunctionLibrary.BP_MathFunctionLibrary_C")
--    return MathFunctionLibrary.PositionInCone(Position, ConeOrigin, Direction, Height, Angle)
--end

function Component:PosCheckSphereHit(Source, SourceLoc, ObjectTypes, ActorsToIgnore, Radius, Angle, FilterCamp)
    -- Source: 施法者
    -- ObjectTypes: TArray(EObjectTypeQuery)
    -- ActorsToIgnore: TArray(AActor)
    -- Radius: 半径
    -- Angle: 角度
    -- FilterCamp: ECampFilter.Enemy
    local ResTargets = TArray(AActor)
    local RealSourceLoc = SourceLoc or Source:K2_GetActorLocation()
    local bHit = UE4.UKismetSystemLibrary.SphereOverlapActors(self, RealSourceLoc, Radius, ObjectTypes, AActor, ActorsToIgnore, ResTargets)
    if _G.DrawDebugTest then
        UE4.UKismetSystemLibrary.DrawDebugSphere(Source, RealSourceLoc, Radius, 12 ,FLinearColor(255,0,0), 0.5, 1)
    end
    if not bHit then
        return ResTargets
    end
    ResTargets = self:FilterTargetInitSuccess(ResTargets)
    if FilterCamp then
        self:FilterTargetsByCamp(Source, ResTargets, FilterCamp)
    end
    if Angle and Angle >= 0 then 
        ResTargets = self:PosCheckTargetInSector(Source, Radius, Angle, ResTargets)
    end
    return ResTargets
end

function Component:PosCheckTargetInSector(Source, Radius, Angle, Targets)
    local NewTargets = {}
    for _, Target in pairs(Targets) do
        local bInSector = UFormulaFunctionLibrary.IsInsideSector(Target:K2_GetActorLocation(), Source:K2_GetActorLocation(), Source:GetActorForwardVector(), Angle)
        if bInSector then
            table.insert(NewTargets, Target)
        end
    end
    return NewTargets
end

function Component:PosCheckSourceInSector(Source, Radius, Angle, Targets)
    local NewTargets = TArray(AActor)
    for i = 1, Targets:Length() do 
        local Target = Targets:GetRef(i)
        local bInSector = UFormulaFunctionLibrary.IsInsideSector(Source:K2_GetActorLocation(), Target:K2_GetActorLocation(), Target:GetActorForwardVector(), Angle)
        if bInSector then
            NewTargets:Add(Target)
        end
    end
    return NewTargets
end

return Component
