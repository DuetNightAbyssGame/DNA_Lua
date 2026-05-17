--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--控件名：WBP_Play_DeputeEliteInfo02
require "UnLua"

---@type WBP_Play_DeputeEliteInfo_S_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


function M:OnListItemObjectSet(Content)
    self.Content = Content
    self:InitItemContent()
end

function M:BP_OnEntryReleased()
    self.Switch_Type:SetActiveWidgetIndex(0)
    if (self.Content) then
        self.Content.UI = nil
    end
end

function M:InitItemContent()
    if self.Content.IsEmpty then
        self.Switch_Type:SetActiveWidgetIndex(1)
        return
    end
    local IconObj = LoadObject(string.format("Texture2D'%s'", self.Content.Icon))
    self.Img_Event:SetBrushFromTexture(IconObj)
    self.Text_Event:SetText(GText(self.Content.Des))
end

return M
