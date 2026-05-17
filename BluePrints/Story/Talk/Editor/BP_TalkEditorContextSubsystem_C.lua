local M = Class()

function M:InitNpcCharacter(NpcCharacter)
    if not IsValid(NpcCharacter) then
        return
    end

    NpcCharacter:PreEnterStory({}, false, true)
end


function M:GetNpcWithGender(NpcId)
    if not NpcId then return end
    if IsValid(self.EditorBindingNpc:Find(NpcId)) then
        return self.EditorBindingNpc:Find(NpcId)
    end
    local NpcData = DataMgr.Npc[NpcId]
    if NpcData and NpcData.Gender and NpcData.RelateNpcId then
        return self.EditorBindingNpc:Find(NpcData.RelateNpcId)
    end
end

return M