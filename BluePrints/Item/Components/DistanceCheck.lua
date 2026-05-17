--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

local Component = {}

function Component:InitComponent()
    
end

-- function Component:AddDistanceActiveTimer(TargetDis)
--     if not IsAuthority(self) then
--         return
--     end
--     self:AddTimer(0.2, self.CheckDistanceActive, true, 0, "DistanceActiveTimer", nil, TargetDis)
-- end

-- function Component:AddDistanceDeActiveTimer(TargetDis)
--     if not IsAuthority(self) then
--         return
--     end
--     self:AddTimer(0.2, self.CheckDistanceDeActive, true, 0, "DistanceDeActiveTimer", nil, TargetDis)
-- end

-- function Component:CheckDistanceActive(TargetDis)
--     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
-- 	local AllPlayer = GameMode:GetAllPlayer()
-- 	for _, Player in pairs(AllPlayer) do
--         local Res, Eid = self:CheckDistance(Player, TargetDis, false)
--         if Res then
--             self:RemoveTimer("DistanceActiveTimer")
--             -- self:UpdateRegionData("IsActive", true)
--             self:ChangeState("DistanceActive", Eid)
--             return
--         end
--     end
-- end

-- function Component:CheckDistanceDeActive(TargetDis)
--     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--     local Num = 0
-- 	for _, Player in pairs(GameMode:GetAllPlayer()) do
--         local Res, Eid = self:CheckDistance(Player, TargetDis, true)
--         if Res then
--             Num = Num + 1 
--         end
--     end
--     if Num == GameMode:GetPlayerNum() then
--         self:RemoveTimer("DistanceDeActiveTimer")
--         -- self:UpdateRegionData("IsActive", false)
--         -- self.IsStart = false
--         self:ChangeState("DistanceDeActive", Eid)
--     end
-- end

-- function Component:CheckDistance(Player, TargetDis, bGreaterThanTarget)
--     local Dis = (Player:K2_GetActorLocation() - self:K2_GetActorLocation()):Size()
--     if (Dis > TargetDis) == bGreaterThanTarget then
--         return true, Player.Eid
--     end
--     return false, 0
-- end


return Component