local M = Class()

function M:OnEndUpdateInputsEvent()
    local LastInputs = self:GetInputs():ToTable()
    for _, Input in pairs(LastInputs) do
        if UTrackInstanceFunctionLibrary.IsPlayerJump(self, Input) then
            local NpcCharacter = self:GetBoundNpcCharacter()
            if IsValid(NpcCharacter) then
                NpcCharacter:ForceResetDynamics()
                break
            end
        end
    end
end

return M