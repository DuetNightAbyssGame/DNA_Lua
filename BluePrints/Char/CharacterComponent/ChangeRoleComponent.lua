

local Component = {}

function Component:ChangeRole(RoleId, AvatarInfo)
    if not IsStandAlone(self) then
        PrintTable({Error='多人联机模式不能换人'})
        return
    end

    if not AvatarInfo then
        AvatarInfo = AvatarUtils:GetDefaultAvatarInfo()
    end
    
    self:RealChangeRole(RoleId, AvatarInfo)
    self:SetupCameraControlComponent()
end


function Component:RealChangeRole(RoleId, AvatarInfo)
    if self.ClearMaterialEffect then
        self:ClearMaterialEffect()
    end
    self:GetCharPreloadComp():ReleaseCacheAssets()   -- 清除预加载缓存的资源
    self:DestroyPlayerPreloadSummon()
    self:QuickRecovery(true)
    self:RealChangeRoleByAvatarInfo(RoleId, AvatarInfo)
end

function Component:RealChangeRoleByAvatarInfo(RoleId, AvatarInfo)
    self:GetCharPreloadComp():ReleaseCacheAssets()   -- 清除预加载缓存的资源
    
    self.BornInfo = nil
    local InfoForInit = {
        Camp = 'Player',
        RoleId = RoleId,
        ChangeRole = true,

        AvatarInfo = AvatarInfo,
    }
    self:InitCharacterInfo(InfoForInit)
end

return Component