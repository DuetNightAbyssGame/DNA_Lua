--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_FallingPlatform_C

local BP_FallingPlatform_C = Class({
    "BluePrints.Common.TimerMgr",
})

function BP_FallingPlatform_C:OnPlayerIn(Player)
    if self.OnBreak then
        return
    end
    if not self.IsInside then
        self:OnPlatformBreak()
        self.OnPlayerInHandle = self:AddTimer(self.WarningTime, self.FallDown)
    end
    self.IsInside = true
end

function BP_FallingPlatform_C:OnPlayerOut(Player)
    self.IsInside = false
end

function BP_FallingPlatform_C:FallDown()
    self.IsInside = false
    self.Cube:SetVisibility(false,true)
    self:AddTimer(self.ReplaceTime, self.FallUp)
    self.Cube:SetCollisionEnabled(0)
end

function BP_FallingPlatform_C:FallUp()
    self:OnPlatformReplace()
    self.Cube:SetVisibility(true,true)
end

function BP_FallingPlatform_C:ResetCollision()
    self.Cube:SetCollisionEnabled(3)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if Player and Player.CapsuleComponent and self.Box:IsOverlappingComponent(Player.CapsuleComponent) then
        local Loc = Player:K2_GetActorLocation()
        Loc.Z = self.Box:K2_GetComponentLocation().Z + self.Box:GetScaledBoxExtent().Z / 2 + Player.CapsuleComponent:GetScaledCapsuleHalfHeight()
        Player:K2_SetActorLocation(Loc, false, nil, false)
        Player:Landed()
        self:AddTimer(1, function()
            -- 如果这时候玩家还站在平台上，就再次触发碎裂
            if Player and self.Box:IsOverlappingComponent(Player.CapsuleComponent) then
                self.IsInside = false
                self:OnPlayerIn(Player)
            end
        end)
    end
end

function BP_FallingPlatform_C:MoveDown()
    local Loc = self:K2_GetActorLocation()
    Loc.Z = Loc.Z-1000
    self:K2_SetActorLocation(Loc,false,nil,false)
end

return BP_FallingPlatform_C
