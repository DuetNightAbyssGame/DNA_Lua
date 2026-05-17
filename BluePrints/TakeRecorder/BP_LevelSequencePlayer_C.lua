--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_LevelSequencePlayer_C
local M = Class('BluePrints.Common.TimerMgr')

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

-- function M:ReceiveBeginPlay()
-- end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

-- function M:OnCharacterSpawned_Lua(Character)
--     if Character.CharacterFashion then
--         Character.CharacterFashion:CreateAllDynamicMaterial(Character.Mesh)
--     end
--     Character:SetActorHiddenInGame(false)
--     Character.HideTags = nil
-- end

---@param Object AActor
function M:OnObjectSpawned_Lua(Object)
    if Object.ForceClearActorHideTag then
        Object:ForceClearActorHideTag()
    end

    local WidgetComponents = Object:K2_GetComponentsByClass(UWidgetComponent)
    for i = 1, WidgetComponents:Length() do
        local WidgetComponent = WidgetComponents:Get(i)
        local Widget = WidgetComponent:GetWidget()
        if Widget then
            Widget:SetVisibility(ESlateVisibility.Collapsed)
        end
    end

    if Object:Cast(ADistructableBodyActor) then
        coroutine.resume(coroutine.create(self.DelayInitDistructableBodyActor),self,Object)
    end

    if Object:Cast(ACharacterBase) then
        Object:HandleModelFashion()
        Object.Overridden.ReceiveBeginPlay(Object)
        self:AddTimer(0.01,function()
            if Object.ModelId and DataMgr.Model[Object.ModelId] and DataMgr.Model[Object.ModelId].PartModelsId then
                local Array = TArray(0)
                for _,Id in pairs(DataMgr.Model[Object.ModelId].PartModelsId) do
                    Array:Add(Id)
                end
                Object:InitPartMeshComp(Array)
            end
        end)
    end
end

function M:DelayInitDistructableBodyActor(Actor)
    while Actor:GetAttachParentActor() == nil do
        UKismetSystemLibrary.Delay(self, 0.001)
    end
    local boss=Actor:GetAttachParentActor()
    if not boss.DestructParts then
        boss:GetBossDestructableComponent()
    end
    boss:RegisterAttachment(Actor.AttachmentName,Actor)
end

return M
