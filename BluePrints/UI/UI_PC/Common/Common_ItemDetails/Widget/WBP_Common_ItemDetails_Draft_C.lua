--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local ForgeModel = require "Blueprints.UI.Forge.ForgeDataModel"
---@type Common_ItemDetails_Draft_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

function M:Construct()
    self.Super.Construct(self)
end

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
    if DraftInfo and DraftInfo.FunctionDes then
        self.Text_Describe:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Panel_Describe:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Text_Describe:SetText(GText(DraftInfo.FunctionDes))
    else
        self.Text_Describe:SetVisibility(ESlateVisibility.Collapsed)
        self.Panel_Describe:SetVisibility(ESlateVisibility.Collapsed)
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
        ItemInfoWidget:InitItemInfo(ProductType, ProductId, nil)
        self.Details:AddChild(ItemInfoWidget)
    end
    local Count = 0
    if DraftServerData then
        if DraftInfo.IsInfinity then
            Count = '<Img id="Infinity" height="36" width="28"/>'
        else
            Count = DraftServerData.Count
        end
    end
    -- 持有数量
    self.ParentWidget.Text_Hold02:SetText(Count)
    local ItemName = ItemUtils:GetDraftName(ItemId)
    -- self.ParentWidget.Text_ItemName:SetText(GText("UI_FORGING_BLUEPRINT")..GText(ProductData[ProductType.."Name"] or ProductData["Name"]))
    self.ParentWidget.Text_ItemName:SetText(ItemName)
    -- 描述
    --self.Text_Describe:SetText(GText(Description))

    -- 所需材料信息
    --self:UpdateDraftInfo(DraftInfo.Resource)

    -- 所需货币数量
    self.ParentWidget.Line.Switch_Bg:SetActiveWidgetIndex(0)
    self.ParentWidget.Line.Switch_Text:SetActiveWidgetIndex(1)
    for FoundryId, CostNum in pairs(DraftInfo.FoundryCost) do 
        local FoundryData = DataMgr.Resource[FoundryId]
        if FoundryData then
            self.ParentWidget.Line.Cost_Resource:InitContent({
                ResourceId = FoundryId,
                Icon = FoundryData.Icon,
                Numerator = CostNum, 
                CostText = GText("UI_Armory_Trace_Cost"),
                IsGamePadIconVisible = false,
                NotInteractive = true,
                IsShowDetails = false,
            })
            break
        end
    end

    -- 所需时间
    self.ParentWidget.Line.Text_RequiredTime:SetText(string.format(GText("UI_SHOP_REMAINTIME_MINUTE"), DraftInfo.Time))
end

-- function M:UpdateDraftInfo(Resource)
--     for _, Value in pairs(Resource) do
--         local MaterailInfoItem = self:CreateWidgetNew("CommonItemDetailsMaterial")
--         local PlayerAvatar = GWorld:GetAvatar()
--         local ResourceServerData = PlayerAvatar.Resources[Value.Id]
--         -- 材料名称
--         MaterailInfoItem.Text_Name:SetText(GText(DataMgr.Resource[Value.Id].ResourceName))
--         -- 材料Icon
--         MaterailInfoItem.Img_Material:SetBrushResourceObject(LoadObject((DataMgr.Resource[Value.Id].Icon)))
--         local HasNum, NeedNum = ResourceServerData.Count, Value.Num
--         -- 持有数量
--         MaterailInfoItem.Text_Hold:SetText(HasNum)
--         -- 所需数量
--         MaterailInfoItem.Text_Need:SetText(NeedNum)

--         local RaritySlateColor
--         if HasNum < NeedNum then
--             RaritySlateColor = UUIFunctionLibrary.StringToSlateColor("DD1C45")
--         else
--             RaritySlateColor = UUIFunctionLibrary.StringToSlateColor("34a981")
--         end
--         MaterailInfoItem.Text_Hold:SetColorAndOpacity(RaritySlateColor)

--         self.MaterialInfo:AddChild(MaterailInfoItem)
--     end
-- end

return M