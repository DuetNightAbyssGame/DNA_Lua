--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_PersonalInfo_Data_Sub03_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
function M:OnListItemObjectSet(ItemObject)
    if ItemObject.Des then
        self.Text_TitlePlayerData:SetText(GText(ItemObject.Des))
    end
    if ItemObject.Count then
        self.Text_PlayerDataNum:SetText(ItemObject.Count)
    end
    if ItemObject.Index==1 then
        self.WidgetSwitcher_Bg:SetActiveWidgetIndex(2)
    elseif ItemObject.Index%2==0 then
        self.WidgetSwitcher_Bg:SetActiveWidgetIndex(1)
    else
        self.WidgetSwitcher_Bg:SetActiveWidgetIndex(0)
    end
end

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
