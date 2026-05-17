require 'UnLua'
local TimeUtils = require "Utils.TimeUtils"

local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:OnListItemObjectSet(Content)
    self.Text_Name:SetText(GText(Content.GoodsName))
    self.Text_Num:SetText(Content.Score)
    self:SetBg(Content.Id)
end

function M:SetBg(Index)
    local num1,num2 = math.modf(Index/2)
    if(num2 == 0)then
        self.Image_ItemBG:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Image_ItemBG:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

return M