--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Team_PhantomItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Text_LevelName:SetText(GText("BATTLE_UI_BLOOD_LV"))
end


function M:Destruct()
end

function M:Init(PhantomState)
    local level = PhantomState.CharLevel
    self.Text_Level:SetText(level)

    local HeadPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Mini/"
    local HeadImg = DataMgr.BattleChar[PhantomState.CharId].GuideIconImg
    HeadImg = TeamCommon.Normal..HeadImg
    UE.UResourceLibrary.LoadObjectAsync(self,HeadPath..HeadImg.."."..HeadImg.."'",{self,M.OnIconLoadFinish})
    local WeaponId, WeaponLevel,Tag = nil,nil,nil
    if PhantomState.MeleeWeaponId ~=0 then
        WeaponId = PhantomState.MeleeWeaponId
        WeaponLevel = PhantomState.MeleeWeaponLevel
        Tag = CommonConst.WeaponType.MeleeWeapon
    elseif PhantomState.RangedWeaponId~=0 then
        WeaponId = PhantomState.RangedWeaponId
        WeaponLevel = PhantomState.RangedWeaponLevel
        Tag = CommonConst.WeaponType.RangedWeapon
    else
        DebugPrint(ErrorTag, LXYTag, "WBP_Team_PhantomItem_C::Init ,魅影的PhantonState上找不到武器")
        return
    end
    self.WBP_Team_PlayerInfo:Init(WeaponId,  WeaponLevel, Tag)
end

function M:OnIconLoadFinish(Object)
    if IsValid(self) and self.Img_Phaontom then
        self.Img_Phaontom:SetBrushResourceObject(Object)
    end 
end

return M
