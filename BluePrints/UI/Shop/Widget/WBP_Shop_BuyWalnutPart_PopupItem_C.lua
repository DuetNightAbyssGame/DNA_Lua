--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Shop_BuyWalnutPart_PopupItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
end

function M:InitModItem(ModId, Level, Count, bMaxLevel)
    local ModData = DataMgr.Mod[ModId]
    assert(ModData, "未找到对应的Mod数据："..ModId)

    local Material = self.Image_Qua:GetDynamicMaterial()
    local Rarity = ModData.Rarity
    local Path = "Texture2D'/Game/UI/Texture/Static/Image/Common/Item/T_Item_Hover_"..Rarity..".T_Item_Hover_"..Rarity.."'"
    local RarityMaterial = LoadObject(Path)
    assert(RarityMaterial, "稀有度未找到对应材质:"..Path)
    if Material then
        Material:SetTextureParameterValue("MainTex", RarityMaterial)
    end
    local Icon = LoadObject(ModData.Icon)
    assert(Icon, "未找到对应的ModIcon"..ModId)
    self.Image_ModIcon:SetBrushFromTexture(Icon)

    self.Text_Level01:SetText("+"..Level)
    self.Text_Level02:SetText("+"..Level)
    if bMaxLevel then
        self.WS_Level:SetActiveWidgetIndex(1)
    else
        self.WS_Level:SetActiveWidgetIndex(0)
    end
    self.Text_PriceMoneyNum:SetText("×"..Count)
end

--function M:Destruct()
--end


return M
