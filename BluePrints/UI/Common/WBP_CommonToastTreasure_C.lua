--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_ToastTreasure_P_C
local M = Class("BluePrints.UI.BP_UIState_C")

function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    local ShowMessage, Duration = ...
    self.Panel_Main:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Text_Toast:SetText(GText("UI_Explore_Treasure_Complete"))
    self.Text_Title:SetText(ShowMessage)
    -- self:PlayAnimation(self.Auto_In)
    if(Duration > 0) then self:AddTimer(Duration, self.Close,false,0,'TreasureToast',true) end
end

-- function M:PlayOutAnim()
--     if self:IsAnimationPlaying(self.Auto_Out) then
--         return
--     end
--     self:StopAllAnimations(self.Auto_In)
--     self:UnbindAllFromAnimationFinished(self.Auto_Out)
--     self:BindToAnimationFinished(self.Auto_Out,{self,self.Close})
--     self:PlayAnimation(self.Auto_Out)
-- end
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
