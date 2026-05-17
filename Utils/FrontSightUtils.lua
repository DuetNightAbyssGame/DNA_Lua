require "UnLua"

local M = {}
M.SightUI2WeaponStyleNode = {
    Bow01 = "Bow",
    Bow02 = "Bow",
    Bow03 = "Bow",
    Bow04 = "Archer",
    Bow05 = "TrackingBow",
    Shotgun02 = "Bow"
}
M.SightUI2AmmoBarStyle = {
    Shotgun02 = "Bar"
}
M.MaxSingleMagazine = 8

function M:GetFrontSightUIPath(StyleNode)
    if not StyleNode then
        return
    end
    local Info = DataMgr.WidgetUI["BattleAim"..StyleNode]
    if Info then
        local PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self)
        if (PlatformName == CommonConst.CLIENT_DEVICE_TYPE.PC) then
            return Info.BPPath
        elseif (PlatformName == CommonConst.CLIENT_DEVICE_TYPE.MOBILE) then
            return Info.MobileBPPath or Info.BPPath
        else
            return Info.BPPath
        end
    end
end

function M:GetAmmoBarUIPath(AmmoBarStyle)
    if not AmmoBarStyle then
        return
    end
    local Info = DataMgr.WidgetUI["BattleAmmo"..AmmoBarStyle]
    if Info then
        local PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self)
        if (PlatformName == CommonConst.CLIENT_DEVICE_TYPE.PC) then
            return Info.BPPath
        elseif (PlatformName == CommonConst.CLIENT_DEVICE_TYPE.MOBILE) then
            return Info.MobileBPPath or Info.BPPath
        else
            return Info.BPPath
        end
    end
end

function M:GetWeaponSightUI(Weapon, ModelId)
    if (not IsValid(Weapon)) then
        return nil
    end
    local BattleWeaponConfigData = DataMgr.BattleWeapon[Weapon.WeaponId]
    local SightUI = nil
    if BattleWeaponConfigData.SightUIMapping then
        SightUI = BattleWeaponConfigData.SightUIMapping[ModelId]
    end
    if not SightUI and BattleWeaponConfigData.FrontSight and BattleWeaponConfigData.FrontSight.SightUI then
        SightUI = BattleWeaponConfigData.FrontSight.SightUI
    end
    return SightUI
end

function M:GetWeaponStyleNode(SightUI)
    if not SightUI then
        return "Melee"
    end
    local WeaponStyleNode = SightUI
    if SightUI and self.SightUI2WeaponStyleNode[SightUI] then
        WeaponStyleNode = self.SightUI2WeaponStyleNode[SightUI]
    end
    return WeaponStyleNode
end

function M:GetAmmoBarStyle(Weapon, WeaponStyleNode, MagazineCapacity, SightUI)
    if (not IsValid(Weapon)) then
        return nil
    end
    local BattleWeaponConfigData = DataMgr.BattleWeapon[Weapon.WeaponId]
    if BattleWeaponConfigData.FrontSight and BattleWeaponConfigData.FrontSight.HideMagazineBar then
        return nil
    end
    if SightUI and self.SightUI2AmmoBarStyle[SightUI] then
        return self.SightUI2AmmoBarStyle[SightUI]
    elseif(WeaponStyleNode == "Melee" or WeaponStyleNode == "Bow" or WeaponStyleNode == "Archer" or WeaponStyleNode == "TrackingBow" or WeaponStyleNode == "AimStarButterfly" or string.startswith(WeaponStyleNode, "Suyi"))then
        return nil
    elseif(WeaponStyleNode == "Funnel")then
        return "BarFunnel"
    elseif(WeaponStyleNode == "Cannon")then
        if MagazineCapacity and self.MaxSingleMagazine and MagazineCapacity > self.MaxSingleMagazine then
            return "UnlimitedSingle"
        else
            return "Single"
        end
    else
        return "Bar"
    end
end

function M:GetWeaponStyle(WeaponStyleNode)
    if WeaponStyleNode == nil then
        return "NoWeapon"
    elseif WeaponStyleNode == "Melee" then
        return "Melee"
    else
        return "Ranged"
    end
end

return M