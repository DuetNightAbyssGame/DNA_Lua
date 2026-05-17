--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_PosInfoItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Bg_List:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end

function M:OnListItemObjectSet(Content)
    self.Text_PosName:SetText(Content.Name)
    self.Text_PosDesc:SetText(Content.Des)
    if(Content.Icon)then
        self.Tag_Pos:SetIcon(LoadObject(Content.Icon))
    end
    if(Content.CharIcon)then
        self.Icon_Avatar:SetBrushResourceObject(LoadObject(Content.CharIcon))
        self.Icon_Avatar:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Icon_Avatar:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
