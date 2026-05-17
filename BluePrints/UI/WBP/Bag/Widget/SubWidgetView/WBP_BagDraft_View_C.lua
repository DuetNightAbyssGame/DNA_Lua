--
-- DESCRIPTION
-- 背包铸造图纸详情界面
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Bag_Tips_Draft_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.UI.BP_EMUserWidgetUtils_C"})

function M:InitItemInfo(ItemType, ItemId, UnitId)
    local DraftInfo = DataMgr.Draft[ItemId]
    local PlayerAvatar = GWorld:GetAvatar()

    self.Text_Result:SetText(GText("UI_FORGING_RESULT"))
    if (type(ItemId) =="string") then
        ItemId = math.tointeger(ItemId)
    end
    local DraftServerData = PlayerAvatar.Drafts[ItemId]
    local ProductType = DraftInfo.ProductType
    local ProductId = DraftInfo.ProductId
    local ProductData = DataMgr[ProductType][ProductId]
    local Icon = LoadObject(ProductData.Icon)
    self.Img_Result:SetBrushResourceObject(Icon)
    self.Text_Name:SetText(GText(ProductData.Name or ProductData[ProductType.."Name"]))

    local FontMaterial = self.Text_Name:GetDynamicFontMaterial()
    if DraftInfo.Rarity == 5 then
        FontMaterial:SetTextureParameterValue("IconTex", self.ParentWidget.Img_Text_5)
    elseif DraftInfo.Rarity == 4 then
        FontMaterial:SetTextureParameterValue("IconTex", self.ParentWidget.Img_Text_4)
    elseif DraftInfo.Rarity == 3 then
        FontMaterial:SetTextureParameterValue("IconTex", self.ParentWidget.Img_Text_3)
    elseif DraftInfo.Rarity == 2 then
        FontMaterial:SetTextureParameterValue("IconTex", self.ParentWidget.Img_Text_2)
    elseif DraftInfo.Rarity == 1 then
        FontMaterial:SetTextureParameterValue("IconTex", self.ParentWidget.Img_Text_1)
    else
        FontMaterial:SetTextureParameterValue("IconTex", self.ParentWidget.Img_Text_0)
    end

    local ItemInfoWidget
    if ProductType == "Mod" then
        ItemInfoWidget = self:CreateWidgetNew("ModItemDetails")
    elseif ProductType == "Weapon" then
        ItemInfoWidget = self:CreateWidgetNew("WeaponItemDetails")
    elseif ProductType == "Resource" then
        ItemInfoWidget = self:CreateWidgetNew("ResourceItemDetails")
    end
    if ItemInfoWidget then
        ItemInfoWidget.ParentWidget = self.ParentWidget
        ItemInfoWidget:InitItemInfoInBag(ProductType, ProductId, nil)
        self.Details:AddChild(ItemInfoWidget)
    end
    local Count = 0
    if DraftServerData then
        if DraftInfo.IsInfinity then
            -- Count = '<Img id="Infinity" height="36" width="28"/>'
            Count = 0
        else
            Count = DraftServerData.Count
        end
    end
    -- 持有数量
    self.ParentWidget.Text_Hold02:SetText(Count)
    local ItemName = ItemUtils:GetDraftName(ItemId)
    -- self.ParentWidget.Text_ItemName:SetText(GText("UI_FORGING_BLUEPRINT")..GText(ProductData[ProductType.."Name"] or ProductData["Name"]))
    self.ParentWidget.Text_ItemName:SetText(ItemName)

    -- 所需材料信息
    --self:UpdateDraftInfo(DraftInfo.Resource)
end

return M