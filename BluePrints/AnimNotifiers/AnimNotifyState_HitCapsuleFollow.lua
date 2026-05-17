--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type UAnimNotifyState_HitCapsuleFollow
local M = Class()

function M:Received_NotifyBegin(MeshComp, Animation, TotalDuration)
    DebugPrint("@gulinan UAnimNotifyState_HitCapsuleFollow Received_NotifyBegin")
    if MeshComp then
        local Owner = MeshComp:GetOwner()
        if Owner then
            Owner:SetHitCapsuleBeginplayState(true)
        end
    end
    return false
end

function M:Received_NotifyEnd(MeshComp, Animation)
    DebugPrint("@gulinan UAnimNotifyState_HitCapsuleFollow Received_NotifyEnd")
    if MeshComp then
        local Owner = MeshComp:GetOwner()
        if Owner then
            DebugPrint("@gulinan UAnimNotifyState_HitCapsuleFollow Owner.bHitCapsuleBeginplay ~= true: "..tostring(Owner.bHitCapsuleBeginplay ~= true))
            if not Owner.bHitCapsuleBeginplay then
                Battle(Owner):ShowError_Monster_Inner_Lua("Call HitCapsuleFollow NotifyEnd without NotifyBegin, v1.100")
            end
            local Res = not Owner.bHitCapsuleBeginplay
            Owner:SetHitCapsuleBeginplayState(false)
            return Res
        end
    end
    return true
end

return M