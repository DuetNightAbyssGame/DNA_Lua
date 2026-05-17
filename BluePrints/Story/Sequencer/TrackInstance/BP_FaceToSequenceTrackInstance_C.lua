local M = Class()

-- 使用新接口设置控制参数
function M:SetControlParamWithNewInterface(EyePitch, EyeYaw, HeadPitch, HeadYaw)
    local NpcCharacter = self:GetAnimatedObject()
    if not NpcCharacter or not NpcCharacter.NpcAnimInstance then
        return
    end

    local AnimInstance = NpcCharacter.NpcAnimInstance

    AnimInstance.OpenAnimationEyeControl = true
    AnimInstance.HeadControlPitch = HeadPitch
    AnimInstance.HeadControlYaw = HeadYaw
    AnimInstance.EyeControlPitch = EyePitch
    AnimInstance.EyeControlYaw = EyeYaw
end

-- 关闭新接口控制
function M:CloseNewInterfaceControl()
    local NpcCharacter = self:GetAnimatedObject()
    if not NpcCharacter then
        return
    end

    local AnimInstance = NpcCharacter.NpcAnimInstance

    if AnimInstance then
        AnimInstance.OpenAnimationEyeControl = false
        AnimInstance.HeadControlPitch = 0
        AnimInstance.HeadControlYaw = 0
        AnimInstance.EyeControlPitch = 0
        AnimInstance.EyeControlYaw = 0
    end
end

return M
