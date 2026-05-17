--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Angling_TextItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:OnListItemObjectSet(Content)
    self.IconPath = Content.IconPath
    self.Text = Content.Text
    self.IsMorn = Content.IsMorn
    self.IsNoon = Content.IsNoon
    self.IsNight = Content.IsNight
    self.IsTime = Content.IsTime
    print(_G.LogTag,"LXZ OnListItemObjectSet", Content.IsTime, self.Text, self.IsMorn, self.IsNoon, self.IsNight)
    self.Img_Icon:SetBrushResourceObject(LoadObject(self.IconPath))
    if self.IsTime then
        print(_G.LogTag,"LXZ OnListItemObjectSet")
        self.WS_State:SetActiveWidgetIndex(1)
        if self.IsMorn then
            self.Morn:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Morn.WS_DayAndNight:SetActiveWidgetIndex(0)
        end
        if self.IsNoon then
            self.Noon:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Noon.WS_DayAndNight:SetActiveWidgetIndex(1)
        end
        if self.IsNight then
            self.Night:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Night.WS_DayAndNight:SetActiveWidgetIndex(2)
        end
    else 
        self.WS_State:SetActiveWidgetIndex(0)
        self.Text_Describe:SetText(GText(self.Text))
    end
end

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
