
local Component = {}
-- @zyh 已移到C++,稳定后删除
--function Component:FilterTargetNotDead(Targets)
--    local NewTargets = TArray(AActor)
--    local DeadTargets = TArray(AActor)
--    for _, Target in pairs(Targets) do
--        -- 弹幕认为是活着的
--        if self:IsDanmakuTarget(Target) then
--            NewTargets:Add(Target)
--        elseif Target and (not Target:IsCharacter() or not Target:IsInDefeat()) then
--            if not Target:IsDead() then
--                NewTargets:Add(Target)
--            else
--                DeadTargets:Add(Target)
--            end
--        end
--    end
--    return NewTargets, DeadTargets
--end

-- function Component:FilterTargetInitSuccess(Targets)
--     local NewTargets = TArray(AActor)
--     for _, Target in pairs(Targets) do
--         if Target and IsValid(Target) then
--             if Target.InitSuccess then
--                 NewTargets:Add(Target)
--             end
--         end
--     end
--     return NewTargets
-- end

function Component:FilterTargetIgnoreSeekEnemy(Targets)
    local NewTargets = TArray(AActor)
    for _, Target in pairs(Targets) do
        if Target and IsValid(Target) then
            if not Target.IgnoreSeekEnemy then
                NewTargets:Add(Target)
            end
        end
    end
    return NewTargets
end

return Component
