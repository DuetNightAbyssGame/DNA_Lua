---@class BaseTagRule
local TagRules = Class('BluePrints.Char.CharacterComponent.CharacterTagLogic.BaseCharacterTagRule')
TagRules = setmetatable(TagRules, {__index = TagRules.Super})

function TagRules:GetStateMachineInfo(TagName)
    return DataMgr.PlayerStateMachine[TagName]
end

function TagRules:GetStateLimitInfo(TagName)
    return DataMgr.PlayerStateLimit[TagName]
end

function TagRules:OnTagChanged(OldTag, NewTag)

end

local IdleInfo = TagRules:GetTagInfo("Idle")
---@param Owner BP_CharacterBase_C
function IdleInfo.OnEnterTag(Owner)
    -- Owner:TestEnterTag("PlayerCharacter Enter Idle")
end

function IdleInfo.OnLeaveTag(Owner)
    -- Owner:TestLeaveTag("PlayerCharacter Enter Idle")
end

function IdleInfo.CanLeaveTag(Owner)
    -- DebugPrint("TianyI@ Test Player IdleInfo can leave tag")
    return true
end

return TagRules 