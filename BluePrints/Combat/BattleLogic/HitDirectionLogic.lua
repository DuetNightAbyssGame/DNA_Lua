-- local Component = {}
-- -- 计算角色受击方向, HitSource可能是创生物或者角色
-- function Component:CalcHitDirection(HitSource, HitTarget, Params)
--     -- 如果HitSource为空， 返回受击者朝向的反方向
--     if not HitSource then 
--         local Direction =  self:GetActorAxisDirection(HitTarget:K2_GetActorRotation(), "X")
--         Direction:Normalize()
--         Direction.Z = 0
--         return Direction
--     end

--     local UseSourceAxis = Params and Params.UseResourceDirection or nil
--     local Direction = nil
--     local IsBulletCreature = (HitSource:IsSkillCreature() and HitSource:GetTags():Find("ExplodeBullet") == 0)

--     -- 如果给了参数，则强制按照施法者轴方向
--     if UseSourceAxis then
--         local Source = HitSource:IsSkillCreature() and HitSource:GetDirectSource() or HitSource
--         Direction = self:GetActorAxisDirection(Source:K2_GetActorRotation(), UseSourceAxis)
--         -- DebugPrint("Tianyi@ 受击方向: 使用施法者轴方向 " .. UseSourceAxis)

--     -- 技能创生物默认按飞行速度方向计算受击方向
--     elseif HitSource:IsSkillCreature() then 
--         if IsBulletCreature and HitSource.CurrentVelocity:Size() > 10 then 
--             Direction = FVector(HitSource.CurrentVelocity.X, HitSource.CurrentVelocity.Y, HitSource.CurrentVelocity.Z)
--             -- DebugPrint("Tianyi@ 受击方向: 使用创生物速度方向")
--         else
--             Direction = HitTarget:K2_GetActorLocation() - HitSource:K2_GetActorLocation()
--             -- DebugPrint("Tianyi@ 受击方向: 使用创生物连线方向")
--         end
--     end

--     -- 近战普攻，兜底
--     if not Direction then 
--         local Source = HitSource:IsSkillCreature() and HitSource:GetDirectSource() or HitSource
--         local Loc = Source:K2_GetActorLocation()
--         Direction = HitTarget:K2_GetActorLocation() - Source:K2_GetActorLocation()
--         -- DebugPrint("Tianyi@ 受击方向: 使用角色连线方向")
--     end


--     Direction:Normalize()
--     Direction = -Direction
--     Direction.Z = 0

--     local ForwardVector = HitTarget:GetActorForwardVector()

--     -- 一般不会走到这里，保险起见
--     if Direction:SizeSquared2D() <= 0 then 
--         Direction = ForwardVector
--         Direction.Z = 0
--     end

--     DebugPrint("Tianyi@ Rotate ForwardX = " .. ForwardVector.X .. ' Y = ' .. ForwardVector.Y .. ' ' .. "Direction.X = " .. Direction.X .. " Direction.Y = " .. Direction.Y .. " value = " .. ForwardVector.X * Direction.X + ForwardVector.Y * Direction.Y)

--     -- 0.866约等于cos(30 * PI / 180)， 即30度以内不旋转
--     local ShouldRotate = ForwardVector.X * Direction.X + ForwardVector.Y * Direction.Y < 0.866


--     return Direction, ShouldRotate
-- end

-- function Component:GetActorAxisDirection(ActorRotation, UseAxis) 
--     if not ActorRotation then 
--         return nil 
--     end

--     local IsRev = false
--     local Direction = nil
--     if string.len(UseAxis) >= 2 and string.sub(UseAxis, 1, 1) == '-' then 
--         IsRev = true
--         UseAxis = string.sub(UseAxis, 2, 2)
--     end

--     if string.upper(UseAxis) == "X" then
--         Direction = UE4.UKismetMathLibrary.GetForwardVector(ActorRotation)
--     elseif string.upper(UseAxis) == "Y" then 
--         Direction = UE4.UKismetMathLibrary.GetRightVector(ActorRotation)
--     elseif string.upper(UseAxis) == "Z" then 
--         Direction = UE4.UKismetMathLibrary.GetUpVector(ActorRotation)
--     else
--         return nil
--     end
    
--     return IsRev and -Direction or Direction
-- end

-- return Component