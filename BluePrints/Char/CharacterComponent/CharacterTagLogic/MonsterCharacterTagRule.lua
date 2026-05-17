---@class BaseTagRule
local TagRules = Class('BluePrints.Char.CharacterComponent.CharacterTagLogic.BaseCharacterTagRule')

function TagRules:GetStateMachineInfo(TagName)
    return DataMgr.MonsterStateMachine[TagName]
end

function TagRules:GetStateLimitInfo(TagName)
    return DataMgr.MonsterStateLimit[TagName]
end

function TagRules:OnTagChanged(OldTag, NewTag)

end

local IdleInfo = TagRules:GetTagInfo("Idle")
---@param Owner BP_CharacterBase_C
function IdleInfo.OnEnterTag(Owner)
    -- Owner:TestEnterTag("MonsterCharacter Enter Idle")
end

function IdleInfo.OnLeaveTag(Owner)
    -- Owner:TestLeaveTag("MonsterCharacter Enter Idle")
end

function IdleInfo.CanLeaveTag(Owner)
    -- DebugPrint("TianyI@ Test Monster IdleInfo can leave tag")
    return true
end

return TagRules 