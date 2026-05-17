--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_WaterMark_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
    
-- end

function M:OnLoaded(...)
    M.Super.OnLoaded(self, ...)
    self:SetVisibility(ESlateVisibility.HitTestInvisible)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        DebugPrint("WBP_Com_WaterMark_C:OnLoaded no Avatar")
        return
    end
    local Text = ...
    if not Text then
        Text = GText("UI_Testing_Watermark")
    end
    if self.WBP_Com_WaterMark_Item then
        self.WBP_Com_WaterMark_Item.Num_UID:SetText(tostring(Avatar.Uid))
        self.WBP_Com_WaterMark_Item.Text_Test:SetText(Text)
    end
    for i = 1, 50 do
        local WaterMark = self["WBP_Com_WaterMark_Item_" .. tostring(i)]
        if WaterMark then
            WaterMark.Num_UID:SetText(tostring(Avatar.Uid))
            WaterMark.Text_Test:SetText(Text)
        end
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
