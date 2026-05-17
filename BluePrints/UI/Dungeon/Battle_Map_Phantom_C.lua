--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type Battle_Map_Phantom_C
local M = Class()

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

-- function M:Tick(MyGeometry, InDeltaTime)
--     if self.Icon and IsValid(self.Icon.PhantomActor) then
--         -- self.Icon:UpdatePhantomGuide()
--         self.Icon.Panel_Bg:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         local Count = self.Icon:GetCanRecoveryCount()
--         local IsRealDead = self.Icon.PhantomActor:IsRealDead()
--         if Count <= 0 and IsRealDead then
--             self:SetVisibility(UE4.ESlateVisibility.Collapsed)
--             return
--         end
--     end
-- end

function M:InitPhantom()
    self.IsPhantomIcon = true
    self.PhantomActor = self.Icon.PhantomActor
    -- self.Icon.Panel_Bg:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

return M
