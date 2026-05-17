local M = Class({ "BluePrints.UI.BP_EMUserWidget_C" })

function M:Construct()
    self.NameText = self.Text_Designation
    self.CustomTag = self.LimitedPrizePool_Tag
    self.RoundText = self.Text_Type
    self.TimeText = self.Text_Time
end

function M:Destruct()
end

function M:OnListItemObjectSet(Content)
    local PoolData = DataMgr.LimitedPrizePool[Content.PoolId]
    if (not PoolData) then
        return
    end

    local RoundId = PoolData.LimitedPrizePoolId[Content.RoundNumber]
    local RoundData = DataMgr.LimitedPrizeItem[RoundId]
    if (not RoundData) then
        return
    end

    local bGrandPrize = Content.PrizeIndex == 1
    local bCustomSelected = Content.SelectedIndex ~= nil
    local Ids = RoundData.Id[Content.PrizeIndex]
    local Id = nil
    if (bCustomSelected) then
        Id = Ids[Content.SelectedIndex]
    else
        Id = Ids[1]
    end
    local TypeIndex = RoundData.Type[Content.PrizeIndex]
    local Type = ItemUtils.GetItemType(TypeIndex)
    local Name = ItemUtils.GetItemName(Id, Type)

    self:SetPrizeStyle(bGrandPrize, bCustomSelected)
    self.NameText:SetText(GText(Name))
    self.RoundText:SetText(string.format(GText("UI_LimitedPrizePool_RoundNum"), Content.RoundNumber))
    self.TimeText:SetText(TimeUtils.TimeToYMDStr(Content.Time, nil, '/') .. " " .. TimeUtils.TimeToHMSStr(Content.Time, nil, ':'))
end

function M:SetPrizeStyle(bGrandPrize, bCustomSelected)
    local ColorString = nil
    if (bGrandPrize) then
        ColorString = "DDB058FF"
    else
        ColorString = "FFFFFFCC"
    end

    local Color = UE4.UUIFunctionLibrary.StringToSlateColor(ColorString)
    self.NameText:SetDefaultColorAndOpacity(Color)
    self.RoundText:SetDefaultColorAndOpacity(Color)
    self.TimeText:SetDefaultColorAndOpacity(Color)

    if (bCustomSelected) then
        self.CustomTag:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        if (bGrandPrize) then
            self.CustomTag.WS_Type:SetActiveWidget(self.CustomTag.Text_BigReward)
            self.CustomTag.Text_BigReward:SetText(GText("UI_LimitedPrizePool_ChooseTag"))
            self.CustomTag.Text_BigReward:SetColorAndOpacity(Color)
        else
            self.CustomTag.WS_Type:SetActiveWidget(self.CustomTag.Text_SmallReward)
            self.CustomTag.Text_SmallReward:SetText(GText("UI_LimitedPrizePool_ChooseTag"))
            self.CustomTag.Text_SmallReward:SetColorAndOpacity(Color)
        end
    else
        self.CustomTag:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

return M
