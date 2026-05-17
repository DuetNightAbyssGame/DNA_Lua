--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Pet_Capture_DetailItem_C
local WBP_Pet_Capture_DetailItem_C = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function WBP_Pet_Capture_DetailItem_C:OnListItemObjectSet(Content)
    self.Content = Content
    self:InitializeView()
end

function WBP_Pet_Capture_DetailItem_C:InitializeView()
    local Color = self.Content.Color
    self.Img_Color:SetColorAndOpacity(FLinearColor(Color[1], Color[2], Color[3], 1.0))
    self.Text_Probability:SetText(self.Content.Percent)
end

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return WBP_Pet_Capture_DetailItem_C
