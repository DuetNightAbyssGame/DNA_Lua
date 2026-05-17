--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@class BP_BossSkillFeatureSequenceActor_C : BP_SkillFeatureLevelSequenceActorBase_C
local M = Class("BluePrints.Combat.BP_SkillFeatureLevelSequenceActorBase_C")

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

function M:IsCanPlay()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if not Player then return false end
    if self.SkillFeatureBuffId == 0 then return true end
	local HasBuff = Player.BuffManager:HasBuff(self.SkillFeatureBuffId)
    return HasBuff
end

function M:SetSequencerLocationOnClient()
    local Mesh = self.OwnerCharacter.Mesh
    if Mesh then
        self:K2_SetActorLocation(Mesh:GetSocketLocation("Root"), false, nil, false)

        local Rotation = Mesh:GetSocketRotation("Root")
        if self.BossSkillFeatureName == "Lianhuo_Skill07" then
            local Correction = FRotator(0, 90, 0)           -- 天知道为什么联机下客户端会旋转90度，修正一下
            Rotation = Rotation + Correction
        end
        self:K2_SetActorRotation(Rotation, false, nil, false)
    end
end

return M
