--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_Settlement_ScoreItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})


function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.Content.Widget = self

    self:InitUI()
end

function M:Update(Content)
    self.Content = Content
    self.Content.Widget = self

    self:InitUI()
end

function M:InitUI()
    self.Text_ScoreInfo:SetText(self.Content.Text)
    if self.Content.IsFinish then
        if self.VX_Finish then
            self.VX_Finish:SetVisibility(UIConst.VisibilityOp.Visible)
        end
        if self.WS_Type then
            self.WS_Type:SetActiveWidgetIndex(1)
        end
        if self.Text_ScoreInfo then
            self.Text_ScoreInfo:SetRenderOpacity(1)
        end
    else
        if self.VX_Finish then
            self.VX_Finish:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        if self.WS_Type then
            self.WS_Type:SetActiveWidgetIndex(0)
        end
        if self.Text_ScoreInfo then
            self.Text_ScoreInfo:SetRenderOpacity(0.6)
        end
    end
    local FontInfo = self.Text_ScoreInfo.Font
    if self.Content.IsMobile then
        FontInfo.Size = self.FontSize_M
    else
        FontInfo.Size = self.FontSize_P
    end
    if FontInfo.Size == 0 then
        FontInfo.Size = 16
    end
    self.Text_ScoreInfo:SetFont(FontInfo)
    if self.Content.ParentWidget.Params.IconPath then
        local Img = LoadObject(self.Content.ParentWidget.Params.IconPath)
        local Img_2 = LoadObject(self.Content.ParentWidget.Params.IconPath_2)
        self.Image_Star:SetBrushFromTexture(Img)
        self.Image_Empty:SetBrushFromTexture(Img_2)
    end
end

return M
