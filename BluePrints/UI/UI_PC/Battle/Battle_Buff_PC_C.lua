--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type Battle_Buff_PC_C
local M = Class("BluePrints.UI.BP_UIState_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    self:OnMainCharacterInitReady()
    self:AddDispatcher(EventID.OnMainCharacterInitReady,self,self.OnMainCharacterInitReady)
end

function M:OnMainCharacterInitReady()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if not IsValid(Player) then
        return
    end
    self:UnRegisterOnBuffsChangedDelegate()
	self:K2_SetBuffsOwner(Player)
    self:RegisterOnBuffsChangedDelegate()
end

-- function M:OnBuffsChanged()
--     if(not self.Owner.BuffManager)then
--         return
--     end
--     local BuffManager = self.Owner.BuffManager
--     local BillboardBuffs = BuffManager.BuffsForShow
--     self:RefreshBuffs(self.HB_Buff_Char, BillboardBuffs)
-- end

-- function M:GetOwnerInternal()
--     return self.Owner
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

return M
