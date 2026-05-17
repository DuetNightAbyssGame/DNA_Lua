--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type BP_AnimNotify_SkillFeature_C
local M = Class()

---@param MeshComp USkeletalMeshComponent
---@param Animation UAnimSequenceBase
---@return boolean
function M:Received_Notify(MeshComp, Animation) 
    if IsStandAlone(self) then
        if self:NotifyServer(MeshComp, Animation) then
            return self:NotifyClient(MeshComp, Animation)
        end
    elseif IsClient(self) then
        return self:NotifyClient(MeshComp, Animation)
    elseif IsDedicatedServer(self) then
        return self:NotifyServer(MeshComp, Animation)
    end
    return false
end


---@param MeshComp USkeletalMeshComponent
---@param Animation UAnimSequenceBase
function M:NotifyServer(MeshComp, Animation) 
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
    return true
end

---@param MeshComp USkeletalMeshComponent
---@param Animation UAnimSequenceBase
function M:NotifyClient(MeshComp, Animation) 
    local PlayerCharacter = MeshComp:GetOwner()
    if not PlayerCharacter then
        return false
    end
    if not PlayerCharacter.IsMainPlayer or not PlayerCharacter:IsMainPlayer() then
        return false
    end

    PlayerCharacter.SkillFeature = true
    if PlayerCharacter.AddTimer then
        PlayerCharacter:AddTimer(self:GetSequenceDuration(PlayerCharacter), 
        function(InPlayer)
            InPlayer.SkillFeature = false
        end, false, 0, "SkillFeature")
    end

    return self.Overridden.NotifyClient(self, MeshComp, Animation)
end

return M