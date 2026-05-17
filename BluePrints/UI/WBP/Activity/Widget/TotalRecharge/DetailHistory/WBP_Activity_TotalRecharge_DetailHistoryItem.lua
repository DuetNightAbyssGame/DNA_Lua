require 'UnLua'
local TimeUtils = require "Utils.TimeUtils"

local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:OnListItemObjectSet(Content)
    -- local PayGoodData = DataMgr.PayGoods[Content.GoodsId]
    -- local ShopItemData = DataMgr.ShopItem[PayGoodData.ItemId]

    -- local ItemName = ItemUtils:GetDropName(ShopItemData.TypeId, ShopItemData.ItemType)
    -- self.ItemName = ItemUtils.GetItemName(ItemId, ItemType)
    -- assert(DataMgr[ItemType][ItemId], "未找到商品信息", ItemType, ItemId)
    -- self.Text_StoneName:SetText(GText(self.ItemName))
    self.Text_Designation:SetText(GText(Content.GoodsName))
    self.Text_Type:SetText(Content.Score)
    self.Text_Time:SetText(TimeUtils.TimeToYMDStr(Content.ScoreTime,nil,'/').." "..TimeUtils.TimeToHMSStr(Content.ScoreTime,nil,':'))
    self:SetBg(Content.Id)
end

-- function M:SetRarityColor(Rarity)
--     if Rarity == 5 then
--         self.Text_Designation:SetDefaultColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("DDB058FF"))
--         self.Text_Quality:SetDefaultColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("DDB058FF"))
--         self.Text_Type:SetDefaultColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("DDB058FF"))
--         self.Text_Time:SetDefaultColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("DDB058FF"))
--     elseif Rarity == 4 then
--         self.Text_Designation:SetDefaultColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("B77CFFFF"))
--         self.Text_Quality:SetDefaultColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("B77CFFFF"))
--         self.Text_Type:SetDefaultColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("B77CFFFF"))
--         self.Text_Time:SetDefaultColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("B77CFFFF"))
--     else
--         self.Text_Designation:SetDefaultColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("FFFFFFCC"))
--         self.Text_Quality:SetDefaultColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("FFFFFFCC"))
--         self.Text_Type:SetDefaultColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("FFFFFFCC"))
--         self.Text_Time:SetDefaultColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("FFFFFFCC"))
--     end
-- end

function M:SetBg(Index)
    local num1,num2 = math.modf(Index/2)
    if(num2 == 0)then
        self.Image_ItemBG:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Image_ItemBG:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

return M