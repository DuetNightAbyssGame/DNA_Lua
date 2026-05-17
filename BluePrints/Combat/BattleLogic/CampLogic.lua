
local Component = {}

--function Component:FilterTargetsByCamp(Source, Targets, Filter)
--    local NewTargets = TArray(AActor)
--    if not Source or not Targets or not Filter then
--        return NewTargets
--    end
--    
--    for _, Target in pairs(Targets) do
--        if Target then
--            if Filter == ECampFilter.Friend then
--                if Source:IsFriend(Target) then
--                    NewTargets:Add(Target)
--                end
--            elseif Filter == ECampFilter.OtherFriend then
--                if Source:IsOtherFriend(Target) then
--                    NewTargets:Add(Target)
--                end
--            elseif Filter == ECampFilter.Enemy then
--                if Source:IsEnemy(Target) and self:CanBeDetected(Target) then
--                    NewTargets:Add(Target)
--                end
--            elseif Filter == ECampFilter.EnemyOrNeutral then
--                if Source:IsEnemyOrNeutral(Target) then
--                    NewTargets:Add(Target)
--                end
--            elseif Filter == ECampFilter.Neutral then
--                if Source:IsNeutral(Target) then
--                    NewTargets:Add(Target)
--                end
--            elseif Filter == ECampFilter.AllCamp then
--                NewTargets:Add(Target)
--            end
--        end
--    end
--    return NewTargets
--end
--
--function Component:CanBeDetected(Target)
--    if not Target.GetCharacterTag then 
--        return true
--    end
--    if Target:GetCharacterTag() == "Avoid" then
--        return false
--    end
--    return true
--end

return Component
