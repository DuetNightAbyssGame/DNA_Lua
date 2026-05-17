--- @class WBP_Story_Interactive_P : StoryInteractiveView 
--- @field Super StoryInteractiveView
local M = Class("Blueprints.UI.WBP.StoryInteractive.View.StoryInteractiveView")
local Common = require "BluePrints.UI.WBP.StoryInteractive.StoryInteractiveCommon"

function M:InitUIInfo(Name, IsInUIMode, EventList, NpcId, EndCallback)
    M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, NpcId, EndCallback)
    self:InitBaseView(NpcId, EndCallback)
end

-- function M:UpdateKeyImg(IsGamePad, GamepadName)
--     self.Super.UpdateKeyImg(self, IsGamePad, GamepadName)
--     if not IsGamePad then
--         self.Key_Close:CreateCommonKey({
--             KeyInfoList = {
--                 {
--                     Type = "Text",
--                     Text = GText(CommonUtils:GetKeyText(CommonUtils:GetActionMappingKeyName("StoryInteractiveClose"))),
--                 }
--             },
--             Desc = GText(Common.TextMap_Btn_Close)
--         })
--     else
--         self.Key_Close:CreateCommonKey({
--             KeyInfoList = {
--                 {
--                     ImgShortPath = CommonUtils:GetKeyText(CommonUtils:GetActionMappingKeyName("StoryInteractiveClose", true)),
--                     Type = "Img",
--                 }
--             },
--             Desc = GText(Common.TextMap_Btn_Close)
--         })
--     end
--     self.Img_Mouse:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
-- end

-- function M:BindCloseDelegate(bBind)
--     M.Super.BindCloseDelegate(self, bBind)
--     self:StopListeningForInputAction("StoryInteractiveClose", EInputEvent.IE_Pressed)
--     self:StopListeningForInputAction("StoryInteractiveClose", EInputEvent.IE_Released)
--     if bBind then
--         self.Key_Close:AddExecuteLogic(self, self.OnNormalExit)
--         self:ListenForInputAction("StoryInteractiveClose", EInputEvent.IE_Pressed, false,{self, self.OnTalkExitPressed})
--         self:ListenForInputAction("StoryInteractiveClose", EInputEvent.IE_Released, false,{self, self.OnTalkExitReleased})
--     else
--         self.Key_Close:RemoveExecuteLogic()
--     end
-- end

-- function M:OnTalkExitPressed()
--     self.TalkExitPress = true
-- end

-- function M:OnTalkExitReleased()
--     if self.TalkExitPress then
--         self:OnNormalExit()
--     end
--     self.TalkExitPress = false
-- end

-- function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
--     local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
--     local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
--     if(InKeyName == "Gamepad_LeftX")then
--         self.MoveDeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
--     elseif(InKeyName == "Gamepad_LeftY")then
--         self.MoveDeltaY = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
--     end
--     local InKeyName = nil
--     if self.MoveDeltaY and self.MoveDeltaY ~= 0 then
--         if self.MoveDeltaY > 0.5 then
--             WBP_Story_Interactive_M
--             InKeyName = "Gamepad_LeftStick_Up"
--         elseif self.MoveDeltaY < -0.5 then
--             InKeyName = "Gamepad_LeftStick_Down"
--         end
--     end
--     if InKeyName == "Gamepad_LeftStick_Up" then --左摇杆上方向键
--         self:UpSelectAction()
--     elseif InKeyName == "Gamepad_LeftStick_Down" then --左摇杆下方向键
--         self:DownSelectAction()
--     end
--     return UIUtils.Handled
-- end


return M
