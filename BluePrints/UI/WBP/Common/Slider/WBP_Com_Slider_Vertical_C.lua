--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_Slider_C
local M = Class({"BluePrints.UI.WBP.Common.Slider.WBP_Com_Slider_C"})

function M:Construct()
    self.SliderType = "Vertical"
    M.Super.Construct(self)
end

function M:Init(ConfigData)
    rawset(self, "GamePadMinKeyPath", "Down")
    rawset(self, "GamePadAddKeyPath", "Up")
    M.Super.Init(self, ConfigData)
end

function M:MiniMaxUseGamePadStyle(UseGamePadStyle)
end

-- function M:ButonUseGamePadStyle(UseGamePadStyle)
--     self.WS_Min:SetVisibility(UseGamePadStyle and UE4.ESlateVisibility.Hidden or UE4.ESlateVisibility.Visible)
--     self.WS_Add:SetVisibility(UseGamePadStyle and UE4.ESlateVisibility.Hidden or UE4.ESlateVisibility.Visible)
--     -- local ActiveWidgetIndex = UseGamePadStyle and 1 or 0
--     -- -- 0 PC  1 手柄
--     -- self.WS_Min:SetActiveWidgetIndex(ActiveWidgetIndex)
--     -- self.WS_Add:SetActiveWidgetIndex(ActiveWidgetIndex)
-- end

function M:ForbidMinOperation(Forbidden)
    self.ForbidMin = Forbidden
    self.Btn_Min:ForbidBtn(Forbidden)
    self.Key_Min:SetForbidKey(Forbidden)
end

function M:ForbidAddOperation(Forbidden)
    self.ForbidAdd = Forbidden
    self.Btn_Add:ForbidBtn(Forbidden)
    self.Key_Add:SetForbidKey(Forbidden)
end

-------------------------------输入设备相关--------------------------
function M:UpdateMouseGamePadImage(CurGamepadName)
    if (self.CurGamepadNameName == CurGamepadName) then
        return
    end
    -- 手柄资源选择按键图片
    local ResourceIconPath = UIUtils.UtilsGetKeyIconPathInGamepad("RVH", CurGamepadName)
    local Img = LoadObject(ResourceIconPath)
    if not IsValid(Img) then
        return
    end
    self.Slider_Controller.WidgetStyle.NormalThumbImage.ResourceObject = Img
end

return M
