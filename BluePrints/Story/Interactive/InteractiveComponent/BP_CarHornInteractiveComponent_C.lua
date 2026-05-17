--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_CarHornInteractiveComponent_C
local BP_CarHornInteractiveComponent_C = Class("BluePrints.Story.Interactive.InteractiveComponent.BP_InteractiveBaseComponent_C")

function BP_CarHornInteractiveComponent_C:ReceiveBeginPlay()
    self.Super.ReceiveBeginPlay(self)
    self.Owner = self:GetOwner()
    self:InitCommonUIConfirmID(100016)
end

function BP_CarHornInteractiveComponent_C:IsCanInteractive(PlayerActor)
    self.Owner = self:GetOwner()
    if not self.Owner then return end

    local MainPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
    if self.Owner.PlayerAndSeat[MainPlayer.Eid] then
        return true
    end

    return false
end

function BP_CarHornInteractiveComponent_C:StartInteractive()
    if not self.Owner then
        self.Owner = self:GetOwner()
    end
    self.Owner:PlayHornSound()
end

function BP_CarHornInteractiveComponent_C:BtnPressed(PlayerActor)
	if self:IsLocked() then
		return
	end
	self:StartInteractive()
end

return BP_CarHornInteractiveComponent_C
