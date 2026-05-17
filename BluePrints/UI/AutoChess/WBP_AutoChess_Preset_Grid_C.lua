require "UnLua"
local UIUtils = require "Utils.UIUtils"
local M = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
})


function M:OnListItemObjectSet(Content)
    self.CombatChessId = Content.CombatChessId
    if Content.IsEmpty then
        self.Icon_Head_Straight:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Icon_Head_Straight:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self:InitImage(self.CombatChessId)
    end
    if Content.ChessIndex == 0 or Content.ChessIndex ==23 then
        self.WS_BG:SetActiveWidgetIndex(1)
        if Content.ChessIndex == 23 then
            self.WS_Color_Rounded:SetRenderScale(FVector2D(-1, -1))
        end
        if Content.IsEmpty then
            self.Icon_Head_Rounded:SetVisibility(ESlateVisibility.Collapsed)
        else
            self.Icon_Head_Rounded:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
    end
    if Content.ChessIndex %2==0 then
        if Content.ChessIndex //6 %2==0 then
             self.WS_Color_Straight:SetActiveWidgetIndex(0) 
        else
             self.WS_Color_Straight:SetActiveWidgetIndex(1) 
        end
    else
        if Content.ChessIndex //6 %2==0 then
             self.WS_Color_Straight:SetActiveWidgetIndex(1) 
        else
             self.WS_Color_Straight:SetActiveWidgetIndex(0) 
        end
    end
end


function M:InitImage(CombatChessId)
    if DataMgr.CombatChessInfo[CombatChessId] then
        local IconPath = DataMgr.CombatChessInfo[CombatChessId].MonsterIcon
        if IconPath then
            local IconImage = LoadObject(IconPath)
            self.Icon_Head_Straight:SetBrushResourceObject(IconImage)
            self.Icon_Head_Rounded:SetBrushResourceObject(IconImage)
        end
    end
end
return M