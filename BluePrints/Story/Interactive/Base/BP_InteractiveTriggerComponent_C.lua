--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_InteractiveTriggerComponent_C = Class()

-- function BP_InteractiveTriggerComponent_C:Initialize(Initializer)
-- end

-- function BP_InteractiveTriggerComponent_C:ReceiveBeginPlay()
--     self.Owner = self:GetOwner()
--     self.InteractiveMap = {}
--     self:SetCollisionEnabled(ECollisionEnabled.NoCollision)
--     self.OnComponentBeginOverlap:Add(self, self.OnBeginOverlap)
--     self.OnComponentEndOverlap:Add(self, self.OnEndOverlap)
--     self:SetCollisionEnabled(ECollisionEnabled.QueryOnly)
-- end

-- function BP_InteractiveTriggerComponent_C:InitOnPlayerPossessed()
--     self.bInited = true
--     self:SetIsCanTrigger(true)
-- end

-- function BP_InteractiveTriggerComponent_C:CheckCanTriggerComp(OtherActor, OtherComp)
--     if not (self.Owner.InitSuccess) then 
--         return false 
--     end

--     if self.Owner == OtherActor or URuntimeCommonFunctionLibrary.ObjIsChildOf(OtherComp, UInteractiveBaseComponent) == false then
--         return false 
--     end

--     ---@type TSet
--     if self.SpecInteractiveComps:Num() > 0 then 
--         local Cls = OtherComp:GetClass()
--         if not self.SpecInteractiveComps:Contains(Cls) then 
--             return false  
--         end
--     end

--     return true
-- end

--function BP_InteractiveTriggerComponent_C:ReceiveEndPlay()
--end

-- function BP_InteractiveTriggerComponent_C:ReceiveTick(DeltaSeconds)
--     if not self.bInited then return end
--     self.Overridden.ReceiveTick(self,DeltaSeconds)
--     local DeleteMap = {}
--     for Interactive, _ in pairs(self.InteractiveMap) do
--         if IsValid(Interactive) then
--             Interactive:TriggerTick(self.Owner)
--         else
--             DeleteMap[Interactive] = self.InteractiveMap[Interactive]
--         end
--     end
--     for Interactive,_ in pairs(DeleteMap) do
--         self.InteractiveMap[Interactive] = nil
--     end
-- end

function BP_InteractiveTriggerComponent_C:OnTalkLocked(bIsLocked)
    self:SetIsCanTrigger(not bIsLocked)
end

-- function BP_InteractiveTriggerComponent_C:SetIsCanTrigger(IsCanTrigger)
--     if IsCanTrigger == self:IsComponentTickEnabled() then return end
--     self:SetComponentTickEnabled(IsCanTrigger)
--     if IsCanTrigger then
--         self:SetCollisionEnabled(ECollisionEnabled.QueryOnly)
--     else
--         self:SetCollisionEnabled(ECollisionEnabled.NoCollision)
--         if self.InteractiveMap then
--             for Interactive, _ in pairs(self.InteractiveMap) do
--                 Interactive:TriggerExit(self.Owner)
--             end
--             self.InteractiveMap = {}
--         end
--     end
-- end

-- function BP_InteractiveTriggerComponent_C:OnBeginOverlap(OverlappedComponent, OtherActor, OtherComp,OtherBodyIndex)
--     if not self:CheckCanTriggerComp(OtherActor, OtherComp) then 
--         return 
--     end
--     if self.InteractiveMap[OtherComp] == nil then
--         OtherComp:TriggerEnter(self.Owner)
--         self.InteractiveMap[OtherComp] = true
--     end
-- end

-- function BP_InteractiveTriggerComponent_C:OnEndOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex)
--     if not self:CheckCanTriggerComp(OtherActor, OtherComp) then 
--         return 
--     end
--     if self.InteractiveMap[OtherComp] then
--         OtherComp:TriggerExit(self.Owner)
--         self.InteractiveMap[OtherComp] = nil
--     end
-- end

function BP_InteractiveTriggerComponent_C:SetInteractiveTriggerDistance(NewDistance)
    self:SetSphereRadius(NewDistance, true)
end

function BP_InteractiveTriggerComponent_C:GetInteractiveTriggerDistance()
    return self.SphereRadius
end

return BP_InteractiveTriggerComponent_C
