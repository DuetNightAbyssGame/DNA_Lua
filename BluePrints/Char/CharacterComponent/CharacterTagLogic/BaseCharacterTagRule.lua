local BaseTagInfo = require('BluePrints.Char.CharacterComponent.CharacterTagLogic.BaseTagInfo')

---@class BaseTagRule @CharacterTag规则的基类
local TagRules = {}


-- TagRules.Checkers = {}
-- function TagRules.Checkers.BuffChecker(Owner, CurTagInfo, NewTagInfo)
--     if not Owner.BuffManager.NotEnterCharacterTagType then 
--         return true 
--     end

--     local ChangeInfo = CurTagInfo.StateLimitInfo
--     if not ChangeInfo then 
--         return true 
--     end

--     local TagTypeMap = {}
--     for _, TagType in pairs(CurTagInfo.StateLimitInfo.TagType) do 
--         TagTypeMap[TagType] = true
--     end
--     for _, TagType in pairs(Owner.BuffManager.NotEnterCharacterTagType) do 
--         if TagTypeMap[TagType] then 
--             return false 
--         end
--     end

--     return true 
-- end

---@param TagName string
function TagRules:GetTagInfo(TagName)
    if not TagName then return nil end 
    if not self[TagName] then 
        self[TagName] = setmetatable({}, BaseTagInfo)

        -- 初始化一些该Tag的信息
        self[TagName].Name = TagName
        self[TagName].ForbidTags = self:GetStateMachineInfo(TagName) or {}  
        self[TagName].StateLimitInfo = self:GetStateLimitInfo(TagName) or {}  
    end 

    return self[TagName]
end

function TagRules:GetStateMachineInfo(TagName)
    return nil
end

function TagRules:GetStateLimitInfo(TagName)
    return nil
end

function TagRules:OnTagChanged(OldTag, NewTag)
end

--- 判断是否能从当前Tag转换到新Tag
function TagRules:CheckCanEnterTag(Owner, CurTag, NewTag, CustomCheckers)
    if not CurTag then return true end

    ---@type BaseTagInfo
    local CurTagInfo = self:GetTagInfo(CurTag)
    local NewTagInfo = self:GetTagInfo(NewTag)

    if CurTagInfo.ForbidTags and CurTagInfo.ForbidTags[NewTag] == 1 then 
        return false 
    end

    if not Owner:CheckBuffCanEnterTag(NewTag) then  
        return false 
    end

    if not Owner:CheckSuperArmorEnterTag(NewTag) then 
        return false 
    end

    -- 额外检测
    if CustomCheckers then 
        for Name, Checker in pairs(CustomCheckers) do 
            if (not Checker(CurTagInfo, NewTagInfo)) then 
                DebugPrint("Tianyi@ Cannot enter tag " .. NewTag .. " because of " .. Name)
                return false 
            end
        end
    end

    -- 检测当前Tag能否退出
    if CurTagInfo and not CurTagInfo.CanLeaveTag(Owner) then 
        return false 
    end

    return true
end

-- 检测角色当前能进入的默认状态
function TagRules:GetDefaultTag(Owner)
    if Owner.BuffManager and Owner.BuffManager.CurrentSetCharacterTag then 
        return Owner.BuffManager.CurrentSetCharacterTag
    elseif Owner.EMAnimInstance and (Owner.IsInAir or Owner.EMAnimInstance.CurrentJumpState ~= Const.NormalState) then
        return "Falling"
    elseif not Owner:IsDead() then
        return "Idle"
    end
end


---------------------------------------------------------------------------
-- 具体Tag的进入、退出、能否退出规则

-- 注册Idle状态
local IdleInfo = TagRules:GetTagInfo("Idle")
---@param Owner BP_CharacterBase_C
function IdleInfo.OnEnterTag(Owner)
    Owner:SetHitFlyState("NotHitFly")
    -- if Owner.Mesh:IsSimulatingPhysics("pelvis") then
    --     Owner:SetHitFlyState("RagdollFalling")
    --     Owner:SetCharacterTag("HitFly")
    --     Owner:BeginRagdollUpdate(true, "pelvis", 0.5, Const.HitFlyHeightMinValue)
    --     return 
    -- end
end

---@param Owner BP_CharacterBase_C
function IdleInfo.OnLeaveTag(Owner)
end

-- 注册Falling状态
local FallingInfo = TagRules:GetTagInfo("Falling")
---@param Owner BP_CharacterBase_C
function FallingInfo.OnEnterTag(Owner)
end

---@param Owner BP_CharacterBase_C
function FallingInfo.OnLeaveTag(Owner)
end


-- 注册HitFly状态
local HitFlyInfo = TagRules:GetTagInfo('HitFly')
---@param Owner BP_CharacterBase_C
function HitFlyInfo.OnEnterTag(Owner)
    Owner:SetHitFlyState("HitFly")
    if Owner.EMAnimInstance then
        Owner:SetCurrentJumpState(Const.NormalState)
    end
end
---@param Owner BP_CharacterBase_C
function HitFlyInfo.OnLeaveTag(Owner)
end

-- 注册HeavyHit状态
local HeavyHitInfo = TagRules:GetTagInfo('HeavyHit')
---@param Owner BP_CharacterBase_C
function HeavyHitInfo.OnEnterTag(Owner)
end
---@param Owner BP_CharacterBase_C
function HeavyHitInfo.OnLeaveTag(Owner)
end


return TagRules
