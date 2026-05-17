--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type Guide_TextFloatList_PC_C
local WBP_GuideTextFloatList_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_GuideTextFloatList_C:close()
    if(self.List_Float:GetChildrenCount() == 0) then
        UE4.UUIStateAsyncActionBase.ResetGuideTextFloatIndex()
        UIManager(self):UnLoadUI(UE4.UUIStateAsyncActionBase.GetGuideTextFloatListKey())
    else
        self:SetTitle(self.List_Float:GetChildAt(self.List_Float:GetChildrenCount() - 1).Text_Title:GetText())
    end
end

function WBP_GuideTextFloatList_C:SetTitle(title)
    self.Text_Title:SetText(title)
end

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

return WBP_GuideTextFloatList_C
