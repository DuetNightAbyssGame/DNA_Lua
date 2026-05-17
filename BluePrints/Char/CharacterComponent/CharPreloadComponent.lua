require "UnLua"
local M = Class()

local WeaponMontageTagsConfig = {
    "Bow",
    "Cannon",
    "Claymore",
    "Crossbow",
    "Funnel",
    "Katana",
    "Machinegun",
    "Polearm",
    "Shotgun",
    "Sword",
    "Swordwhip"
}

-- ======================================= Monster =======================================
function M:PreloadEnable()
    if (self.Owner:IsPlayer()) then
        return Const.EnablePlayerPreload
    end
    return true
end

-- function M:PreloadMonAccessory()
--     -- Accessory Mesh
--     local Paths = {}
--     if self.Owner.Data.AccessoryIds and self.Owner.Data.AccessoryIds.Normal then
--         for i = 1, #self.Owner.Data.AccessoryIds.Normal do
--             local Path = DataMgr.BodyAccessory[self.Owner.Data.AccessoryIds.Normal[i]].ModelPath
--             table.insert(Paths, Path)
--         end
--     end
        
--     if self.Owner.Data.AccessoryIds and self.Owner.Data.AccessoryIds.Random then
--         for i = 1, #self.Owner.Data.AccessoryIds.Random do
--             local Path = DataMgr.BodyAccessory[self.Owner.Data.AccessoryIds.Random[i]].ModelPath
--             table.insert(Paths, Path)
--         end
--     end

--     return Paths
-- end

function M:NeedPreloadAssets_Phantom()
    return Const.EnableDungeonPhantomPreload
end

-- function M:RegisterMonCustomConfig(UnitId)
--     -- 零散资源预加载
--     local Paths = {}
    
--     -- 死亡特效
--     if UnitId and UnitId > 0 then
--         local EffectId = DataMgr.Monster[UnitId].DeadEffectId
--         if EffectId and DataMgr.VisualEffect[EffectId].EffectPath then
--             table.insert(Paths, FEMLoadPath(DataMgr.VisualEffect[EffectId].EffectPath))
--         end
--     end

--     self:MultiAssetPreload(Paths, ERoleInitAssetType.CustomAssets)
-- end

function M:InitDistructableBody()
    self.Owner.DistructableBodyId = self:GetDistructableBodyId()
end

function M:GetDistructableBodyId()
    if not self.Owner:IsRealMonster() or self.Owner:IsPhantom() then
        return 
    end
    return DataMgr.Monster[self.Owner.UnitId].DistructableId
end

-- ======================================= Monster End =======================================


-- ======================================= Player =======================================
function M:GetPlayerWeaponMontageTags()
    if not self.Owner:IsPlayer() or not self.Owner.InitSuccess then
        GWorld.logger.errorlog("主角预加载武器蒙太奇资源, 获取数据失败", self.Owner.CurrentRoleId, self.Owner.InitSuccess)
        return {}
    end

    local TmpWeaponIds = {}
    for _, Weapon in pairs(self.Owner.Weapons) do
        table.insert(TmpWeaponIds, Weapon.WeaponId)
    end

    local OutWeaponMontageTags = {}
    for _, Id in pairs(TmpWeaponIds) do
        local WeaponData = DataMgr.BattleWeapon[Id]
        if WeaponData then
            for _, Tag in pairs(WeaponData.WeaponTag) do
                if (CommonUtils.HasValue(WeaponMontageTagsConfig, Tag)) then
                    table.insert(OutWeaponMontageTags, Tag)
                end
            end
        end
    end
    
    return OutWeaponMontageTags
end

-- ======================================= Player End =======================================


-- ======================================= Phantom =======================================

function M:GetPhantomWeaponIds()
    -- if not self.Owner:IsPhantom() or not self.Owner.AvatarInfo then
    --     GWorld.logger.errorlog("魅影预加载武器蒙太奇资源, 获取数据失败:", self.Owner.UnitId)
    --     return {}
    -- end
    local TmpWeaponIds = {}
    local Info = self.Owner.AvatarInfo
    if Info and  Info.MeleeWeapon then
        table.insert(TmpWeaponIds, Info.MeleeWeapon.WeaponId)
    else
        table.insert(TmpWeaponIds, self.Owner:GetMeleeWeaponId())
    end

    if Info and Info.RangedWeapon then
        table.insert(TmpWeaponIds, Info.RangedWeapon.WeaponId)
    -- else
        -- table.insert(TmpWeaponIds, self.Owner:GetRangedWeaponId())
    end

    if Info and Info.UltraWeapon then
        table.insert(TmpWeaponIds, Info.UltraWeapon.WeaponId)
    else
        table.insert(TmpWeaponIds, self.Owner:GetUltraWeaponId())
    end

    table.insert(TmpWeaponIds, self.Owner:GetCondemnWeaponId())
    return TmpWeaponIds
    -- local OutWeaponMontageTags = {}
    -- for _, Id in pairs(TmpWeaponIds) do
    --     local WeaponData = DataMgr.BattleWeapon[Id]
    --     if WeaponData then
    --         for _, Tag in pairs(WeaponData.WeaponTag) do
    --             if (CommonUtils.HasValue(WeaponMontageTagsConfig, Tag)) then
    --                 table.insert(OutWeaponMontageTags, Tag)
    --             end
    --         end
    --     end
    -- end
    
    -- return OutWeaponMontageTags
end


-- ======================================= Phantom End =======================================

--- ====================================== Npc Begin =========================================
-- function M:RegisterNpcCustomConfig(UnitId)
--     local Path = {}
--     local NpcData = DataMgr.Npc[UnitId]
--     if NpcData and NpcData.DefaultAction then
--         local ModelData = NpcData.ModelId and DataMgr.Model[NpcData.ModelId]
--         if ModelData then
--             local MontageFolder = ModelData.MontageFolder
--             local Prefix = ModelData.MontagePrefix
--             local SequenceFolder = string.gsub(MontageFolder,"Montage","Sequence")
--             table.insert(Path,FEMLoadPath(SequenceFolder.."Interactive/"..Prefix..NpcData.DefaultAction))
--         end
--     end

--     self:MultiAssetPreload(Path,ERoleInitAssetType.CustomAssets)
-- end
--- ====================================== Npc End   =========================================

return M
