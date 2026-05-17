require "UnLua"

---@type CharacterFSM
local CharacterFSM = require('BluePrints.Char.CharacterComponent.CharacterTagLogic.CharacterFSM')
local PlayerTagRule = require('BluePrints.Char.CharacterComponent.CharacterTagLogic.PlayerCharacterTagRule')
local MonsterTagRule = require('BluePrints.Char.CharacterComponent.CharacterTagLogic.MonsterCharacterTagRule')
local Component = {}

-- function Component:InitFSM()
--     if self.CharFSMComp then 
--         if self.BeforeTagChanged ~= nil then 
--             self.CharFSMComp.OnBeforeTagChanged:Add(self, self.BeforeTagChanged)
--         end
--         if self.AfterTagChanged ~= nil then 
--             self.CharFSMComp.OnAfterTagChanged:Add(self, self.AfterTagChanged)
--         end
--     end
-- end


-- 调用离开旧Tag的逻辑
-- 禁止在LeaveTag的逻辑中随意修改角色Tag哦，这会让Tag逻辑异常复杂，难以排查问题
function Component:ApplyLeaveCharacterTag(OldTag, NewTag)
    -- DebugPrint("Tianyi@ ApplyLeaveCharacterTag: " .. OldTag .. ' ' .. NewTag)
    local Leave = "Leave"
    local TagStr = "Tag"
    local FunctionName = Leave..OldTag..TagStr
    if self[FunctionName] ~= nil then
        self[FunctionName](self, NewTag)
        return true
    end
    return false
end

-- 调用进入新Tag的逻辑
function Component:ApplyEnterCharacterTag(NewTag)
    if self.EMAnimInstance ~= nil then
        self.EMAnimInstance.CharacterTag = NewTag
    end

    if self.NpcAnimInstance ~= nil then
        self.NpcAnimInstance.CharacterTag = NewTag
    end

    local Enter = "Enter"
    local TagStr = "Tag"
    local FunctionName = Enter..NewTag..TagStr
    if self[FunctionName] ~= nil then
        self[FunctionName](self)
        return true 
    end

    return false 
end

-- 判断能否离开Tag的逻辑
function Component:CanLeaveCharacterTag(Tag)
    return true
end

function Component:GetCharacterTag() 
    return self.AutoSyncProp.CharacterTag
end

function Component:CharacterInTag(Tag)
    return Tag == self.AutoSyncProp.CharacterTag
end

function Component:GetStateMachineInfo(Tag)
    if self:IsPlayer() then
        return DataMgr.PlayerStateMachine[Tag]
    else
        return DataMgr.MonsterStateMachine[Tag]
    end
end

function Component:GetStateLimitInfo(Tag)
    if self:IsPlayer() then
        return DataMgr.PlayerStateLimit[Tag]
    else
        return DataMgr.MonsterStateLimit[Tag]
    end
end

function Component:GetStateLimitTagTypeMap(StateLimitInfo)
    local TagTypeMap = {}
    if StateLimitInfo.TagType then
        for _, TagType in pairs(StateLimitInfo.TagType) do
            TagTypeMap[TagType] = true
        end
    end
    return TagTypeMap
end


return Component