require "UnLua"

local ActorStateObject = Class()

-- function ActorStateObject:OnRep_bIsInvincible()
--     local Owner = self.OwnerActor
--     local IsInvincible = Owner:IsInvincible()

--     -- DebugPrint("Tianyi@ ActorStateObject:bIsInvincible " .. tostring(Owner:IsInvincible()))
    
--     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--     local UIManager = GameInstance:GetGameUIManager()
--     if UIManager then
--         local BossBloodUI = Owner.BossBloodUI
--         if BossBloodUI and Owner == BossBloodUI.Owner then
--             BossBloodUI:UpdateBossInvincibleState(IsInvincible)
--         end
--     end
--     if Owner.CharacterInTag and Owner:CharacterInTag("Avoid") and  Owner.InvincibleReason then 
--         return 
--     elseif Owner.InvincibleReason then 
--         Owner.InvincibleReason = false
--     end

--     if Owner.BillBoardComponent then
--         Owner.BillBoardComponent:RefreshInvincibleState()
--     end

-- end

return ActorStateObject