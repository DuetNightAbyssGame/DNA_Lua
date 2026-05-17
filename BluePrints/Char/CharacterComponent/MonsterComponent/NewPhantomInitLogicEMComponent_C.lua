require "UnLua"
local EffectResults = require "BluePrints.Combat.BattleLogic.EffectResults"

local M = Class({
    "BluePrints.Common.TimerMgr",
})


function M:NewPhantomInitComponent_OnCharacterReady_AuthorityInit(Owner, Context)
    local RoleId = Context.IntParams:Find("RoleId") or - 1
    local PlayerHp = Context.IntParams:Find("PlayerHp")
    local PlayerSp = Context.IntParams:Find("PlayerSp")
    local DeathInfo = Context:GetLuaTable("DeathInfo")
    local ModPassives = Context:GetLuaTable("ModPassives")
    local MeleeWeapon = Context:GetLuaTable("MeleeWeapon")
    local RangedWeapon = Context:GetLuaTable("RangedWeapon")
    local UltraWeapons = Context:GetLuaTable("UltraWeapons") 
    local ReplaceAttrs = Context:GetLuaTable("ReplaceAttrs")
    -- self:NewPhantomInitComponent_SetPhantomInfo(Owner, PlayerHp, PlayerSp)
    Owner:SetDeathInfo(DeathInfo)
    Owner:ServerSetRoleMod(RoleId, ModPassives, false)
    Owner:ServerSetUpWeapons(MeleeWeapon, RangedWeapon, UltraWeapons)
    Owner:InitAllWeaponModifier(ReplaceAttrs)
    Owner:InitAvatarBuffs()
end

function M:NewPhantomInitComponent_CallBlueprintCharacterReadyAndBeginPlay(Owner)
    Owner.Overridden.OnCharacterReady(Owner)
    Owner.Overridden.ReceiveBeginPlay(Owner)
end

function M:NewPhantomInitComponent_GetDataInfo(Owner)
    Owner.BattleCharInfo = nil
    local RoleId = Owner.CurrentRoleId
    if not RoleId or RoleId == 0 then
        return
    end
    Owner.BattleCharInfo = DataMgr.BattleChar[RoleId]
end

function M:NewPhantomInitComponent_SetPhantomInfo(Owner, PlayerHp, PlayerSp)
    if PlayerHp then
        Owner:SetAttr("Hp", math.min(PlayerHp, Owner:GetAttr("MaxHp")))
    end
    if PlayerSp then
       Owner:SetAttr("Sp", math.min(PlayerSp, Owner:GetAttr("MaxSp")))
    end
end

function M:NewPhantomInitComponent_TryPlayLevelEnterMontage_Lua(Owner, LevelEnterMontagePath)
    local MontageTime = Owner:PlayMontageByPath(LevelEnterMontagePath)
    Owner:AddDelayFrameFunc(function()
        Owner:SetMeshVisibilityBasedAnimTickOption(EVisibilityBasedAnimTickOption.AlwaysTickPose)
    end, 5)
    return MontageTime
end

return M