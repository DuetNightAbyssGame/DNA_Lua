
require "UnLua"

local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})


function M:Construct()
    self.Bg_List:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Text_Extra:SetVisibility(UIConst.VisibilityOp.Collapsed)

    self.Text_Level_Now:SetText(GText("Moling_Level"))
    self.Text_Level_Now:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:OnListItemObjectSet(Content)
    self.Num_Level:SetText(Content.Level)
    self.Text_PetInfolDesc:SetText(GText(Content.Des))
    if(Content.IsCurLevel)then
        self.Text_Level_Now:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        self.Text_Level_Now:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

return M
