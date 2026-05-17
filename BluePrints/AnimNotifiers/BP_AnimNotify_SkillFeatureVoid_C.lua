--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_AnimNotify_SkillFeatureVoid_C
local M = Class()

---@param MeshComp USkeletalMeshComponent
---@param Animation UAnimSequenceBase
---@return boolean
function M:Received_Notify(MeshComp, Animation) 
    local PlayerCharacter = MeshComp:GetOwner()
    if not PlayerCharacter then
        return false
    end
    PlayerCharacter.SkillFeature = true
    if PlayerCharacter.AddTimer then
        PlayerCharacter:AddTimer(self:GetSequenceDuration(PlayerCharacter), 
        function(InPlayer)
            InPlayer.SkillFeature = false
        end, false, 0, "SkillFeature")
    end
    if IsStandAlone(self) or IsClient(self)  then
        self:DoFeature(MeshComp)
     end
    return true
end


return M