--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Announcement_Catalog_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Construct()
    self.Btn_Area.OnClicked:Add(self, self.OnClick)
end

function M:OnClick()
    if self.OnClickCallback then
        self.OnClickCallback(self.CallObj, self)
    end
    self.Btn_Area:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end

function M:SetSelected()
    self.Btn_Area:SetCheckedNoNotify(true)
    self.Btn_Area:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end

function M:RevertSelect()
    self.Btn_Area:SetCheckedNoNotify(false)
    self.Btn_Area:SetVisibility(UIConst.VisibilityOp.Visible)
end

function M:OnMouseButtonUp(MyGeo, InMouseEvent)
    if self.OnClickCallback then
        self.OnClickCallback(self.CallObj, self)
    end
    return UIUtils.Unhandled
end

function M:OnRemovedFromFocusPath(InFocusEvent)
    if self.OnRemoveFocusCallback then
        self.OnRemoveFocusCallback(self.CallObj, self)
    end
end

function M:SetCallback(Params)
    self.CallObj = Params.CallObj
    self.OnClickCallback = Params.OnClickCallback
    self.OnRemoveFocusCallback = Params.OnRemoveFocusCallback
end

function M:InitData(SubTitleInfo)
    self.SubTitleInfo = SubTitleInfo
end

return M

