local Component = {}

-- function Component:ExecuteFireDanmaku(Source, DanmakuId, Duration, BoneName)
--     assert(IsValid(Source), 'ExecuteFireDanmaku传入的Source不是有效的')

--     --if BoneName == "None" then
--     --    BoneName = nil
--     --end
--     Source:FireDanmaku(DanmakuId, Duration, BoneName, 0, false, FTransform())
-- end

-- function Component:GetDanmakuCreatureByName(DanmakuTemplate, CollisionCompName)
--     return DanmakuTemplate:GetDanmakuCreatureByName(CollisionCompName)
-- end

-- function Component:IsDanmakuCreatureEid(Eid)
--     return self.DanmakuCreatureMap and self.DanmakuCreatureMap[Eid] ~= nil
-- end

-- function Component:HideAllDanmaku(bHide)
--     local AllDanmakus = self.DanmakuTemplates
--     if AllDanmakus then
--         for DanmakuTemplate, _ in pairs(AllDanmakus) do
--             if IsValid(DanmakuTemplate) then
--                 DanmakuTemplate:SetActorHiddenInGame(bHide)
--             end
--         end
--     end
-- end

--function Component:ClearAllDanmaku()
--    DebugPrint("gmy@ClearAllDanmaku")
--    if self.DanmakuTemplates then
--        for DanmakuTemplate, _ in pairs(self.DanmakuTemplates) do
--			if IsValid(DanmakuTemplate) then
--				DanmakuTemplate:Destroy()
--			end
--        end
--        self.DanmakuCreatureMap = {}
--    end
--end

--function Component:RegisterDanmakuTemplate(Template)
--    self.DanmakuTemplates = self.DanmakuTemplates or {}
--    self.DanmakuTemplates[Template] = true
--end

--function Component:UnregisterDanmakuTemplate(Template)
--    if self.DanmakuTemplates then
--        self.DanmakuTemplates[Template] = nil
--    end
--end

return Component