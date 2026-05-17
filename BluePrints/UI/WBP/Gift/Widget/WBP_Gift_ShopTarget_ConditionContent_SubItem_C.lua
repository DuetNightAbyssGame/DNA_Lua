--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Gift_ShopTarget_ConditionContent_SubItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end
function M:OnListItemObjectSet(Content)
    self.Text_TitlePlayerData:SetText(GText(Content.Name))
    if Content.IsValid == false then
        if Content.Num1 and Content.Num2 then
            self.Text_PlayerDataNum:SetText("<W>" .. Content.Num1 .. "/" .. Content.Num2 .. "</>")
        end
    else
        if Content.Num1 and Content.Num2 then
            self.Text_PlayerDataNum:SetText( Content.Num1 .. "/" .. Content.Num2 )
        end
    end

    if self.WidgetSwitcher_Bg and Content.Index ~= nil then
        local idx = Content.Index
        local total = Content.Total
        local StyleIndex
        if total and total == 1 then
            StyleIndex = 3
        elseif idx == 1 then
            StyleIndex = 2
        elseif total and idx == total then
            if (total % 2 == 1) then
                StyleIndex = 3
            else
                StyleIndex = 4
            end
        else
            if (idx % 2 == 1) then
                StyleIndex = 0
            else
                StyleIndex = 1
            end
        end
        self.WidgetSwitcher_Bg:SetActiveWidgetIndex(StyleIndex)
    end

end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
