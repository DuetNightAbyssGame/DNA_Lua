local Component = {}

-- function Component.TryToStartUIHitFeedback(DamageEvent, Target)
--     if(DamageEvent.DamageTag)then
--         local IsRanged = false
--         for _, value in pairs(DamageEvent.DamageTag) do
--             if(value == "Ranged")then
--                 IsRanged = true
--             elseif(value == "Dot")then
--                 --Dot伤害不需要命中反馈
--                 return
--             end
--         end
--         if(not IsRanged)then
--             --非远程伤害不需要命中反馈
--             return 
--         end
--     else
--         return
--     end
--     local DamageSource = Battle(Target):GetEntity(DamageEvent.SourceEid)
--     local DirectSource = DamageSource.GetDirectSource and DamageSource:GetDirectSource() or DamageSource

--     if DirectSource:GetCamp() == Target:GetCamp() then
--         return
--     end

--     if DirectSource:IsMainPlayer() and DirectSource.TakeAimIndicator then
--         if DamageEvent.KillTarget then
--             DirectSource.TakeAimIndicator:PlayKillingFeedbackAnim()
--         else
--             DirectSource.TakeAimIndicator:PlayHitFeedbackAnim(DamageEvent.DamageCritLevel)
--         end
--     elseif DirectSource:IsCombatItemBase() and DirectSource.PaoTaiBattleFront then
--         if DamageEvent.KillTarget then
--             DirectSource.PaoTaiBattleFront:PlayKillingFeedbackAnim()
--         end
--     end
-- end

return Component