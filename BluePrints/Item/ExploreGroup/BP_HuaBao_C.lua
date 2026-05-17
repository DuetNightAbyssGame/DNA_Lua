--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
---@type BP_HuaBao_C
local M = Class({
    "BluePrints/Item/ExploreGroup/BP_DongGuoBreakableItem_C",
})

function M:OnPlayerIn(Player)
    if not self.IsActive then return end
    local WCSubsystem = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(self, UE4.UWorldCompositionSubSystem)
    if WCSubsystem and WCSubsystem:IsAsyncTraveling() then
        return
    end
    -- if self.StayPlayers:Contains(Player) then
    --     return
    -- end
    -- self.StayPlayers:Add(Player)
    self:OnPlayerStay(Player.Eid, nil, Player:GetCharacterTag())
    -- Player.CharFSMComp.OnAfterTagChanged:Add(self, self.OnPlayerStay)
    -- self.IsPlayerInside = true
end

-- function M:OnPlayerOut(Player)
--     self.StayPlayers:Remove(Player)
--     Player.CharFSMComp.OnAfterTagChanged:Remove(self, self.OnPlayerStay)
--     if self.StayPlayers:Num() == 0 then
--         self.IsPlayerInside = false
--     end
-- end

function M:OnPlayerStay(PlayerEid, OldTag, NewTag)
    local Player = Battle(self):GetEntity(PlayerEid)
    if IsValid(Player) == false then
        return
    end
    local IsTagVaild = self.CorrectTag:Contains(NewTag)
    local Player = Battle(self):GetEntity(PlayerEid)
    if IsTagVaild == true then
        self:LaunchPlayer(Player)
        -- Player.CharFSMComp.OnAfterTagChanged:Remove(self, self.OnPlayerStay)
    end
end

function M:OnSpecialBulletHitted(SourceEid)
    self:ChangeState("Hit", SourceEid)
end

function M:ActiveCombat()
    self.Super.ActiveCombat(self)
    self:OnActiveEffect()
end

function M:DeActiveCombat()
    self.Super.DeActiveCombat(self)
    self:OnDeactiveEffect()
end

function M:LaunchPlayer(Player)
    if not self.IsCdOver then
        return
    end
    local Velocity = self.Arrow:GetForwardVector() * self.LaunchVelocity
    Player:LaunchCharacter(Velocity, true, true)
    if math.abs(self.Arrow.RelativeRotation.Pitch - 90) > 10  then
        Player:SetIsJumpPadLaunched(true)
        local PlayerRotator = Player:K2_GetActorRotation()
        local ArrowRotator = URuntimeCommonFunctionLibrary.VectorToRotator(Velocity)
        Player:K2_SetActorRotation(FRotator(PlayerRotator.Pitch, ArrowRotator.Yaw, ArrowRotator.Roll), false, nil, false)
    end
    self:OnLaunchCharacter(Player)
    if self.IsJumppadLaunch then
        Player:AddTimer_Combat(self.JumpPadLaunchedTime, Player.SetIsJumpPadLaunched, false, 1, nil, false, false)
    else
        Player:SetIsJumpPadLaunched(false)
    end
    self:AddTimer(self.LaunchCD, self.OnCdRecover, false, 0, nil, false)

    local GameMode = UGameplayStatics.GetGameMode(self)
    if GameMode then 
        GameMode:TriggerDungeonAchieve("PlayerUsePad", Player.Eid)
    end
end

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

return M
