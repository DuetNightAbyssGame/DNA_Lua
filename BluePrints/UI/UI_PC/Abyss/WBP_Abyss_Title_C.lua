--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Abyss_Title01_C
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

function M:SetInfo(Info)
    self.Text_Title:SetText(GText(Info.MainTitle))
    if Info.SubTitle then
        self.Text_SubTitle:SetText(GText(Info.SubTitle))
        self.Panel_SubTitle:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Panel_SubTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

return M
