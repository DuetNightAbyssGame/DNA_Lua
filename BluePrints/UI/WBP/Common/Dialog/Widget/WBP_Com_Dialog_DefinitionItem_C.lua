--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_DefinitionItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Bg_List:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end

function M:OnListItemObjectSet(Content)
    self.Widget = Content.Widget
    self.Text_Name:SetText(Content.Name)
    self.Text_Definition:SetText(Content.Des)
end

function M:SetHighLight(IsHighLight)
    if(IsHighLight)then
        self:PlayAnimation(self.Scanline)
    else
        self:PlayAnimation(self.Normal)
    end
end

function M:Destruct()
end

return M
