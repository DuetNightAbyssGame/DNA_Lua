--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_HollowComponent = Class()


-- function BP_HollowComponent:UpdateHollowRadius()
--     local Owner = self:GetOwner()
--     if IsValid(Owner) and Owner.AutoSyncProp.CharacterTag then
--         if Owner.IsPlayer and Owner:IsPlayer() then
--             local PlayerStateLimitTable = DataMgr.PlayerStateLimit[Owner.AutoSyncProp.CharacterTag]
--             if not PlayerStateLimitTable then
--                 return
--             end
--             local PlayerStateLimit = PlayerStateLimitTable.BreakableItem
--             self:SetHollowCheck(PlayerStateLimit)
--         elseif Owner.IsMonster and Owner:IsMonster() then
--             local MonsterStateLimitTable = DataMgr.PlayerStateLimit[Owner.AutoSyncProp.CharacterTag]
--             if not MonsterStateLimitTable then
--                 return
--             end
--             local MonsterStateLimit = MonsterStateLimitTable.BreakableItem
--             self:SetHollowCheck(MonsterStateLimit)
--         end
--     end
-- end

-- function BP_HollowComponent:DisableHollowCheck()
--     self:K2_DetachFromComponent(EDetachmentRule.KeepRelative, EDetachmentRule.KeepRelative,  EDetachmentRule.KeepRelative, true)
--     self:SetCollisionEnabled(ECollisionEnabled.NoCollision)
-- end

-- function BP_HollowComponent:EnableHollowCheck()
--     local Owner = self:GetOwner()
--     self:K2_AttachTo(Owner:K2_GetRootComponent(), "None", EAttachLocation.SnapToTargetIncludingScale, false)
--     self:SetCollisionEnabled(ECollisionEnabled.QueryOnly)
-- end

-- function BP_HollowComponent:SetHollowCheck(StateLimit)
--     if not StateLimit then
--         self:DisableHollowCheck()
--         return
--     end
--     if not StateLimit.Breakable then
--         self:DisableHollowCheck()
--         return
--     end
--     local Radius
--     if not StateLimit.Radius or StateLimit.Radius <= 0 then
--         Radius = self.DefaultHollowSphereRadius
--     else
--         Radius = tonumber(StateLimit.Radius)
--     end
--     if StateLimit.Breakable then
--         self:EnableHollowCheck()
--         self:SetSphereRadius(Radius,true)
--         return
--     end
-- end

-- function BP_HollowComponent:ReceiveBeginPlay()
--     self.Overridden.ReceiveBeginPlay(self)
--     self:DisableHollowCheck()
-- end

function BP_HollowComponent:HandleOnBeginOverlap(OtherActor)
    if URuntimeCommonFunctionLibrary.ObjIsChildOf(OtherActor, ABreakableItem) then
        if not OtherActor.EnbaleHollow and OtherActor.InitSuccess then
            OtherActor:OnDead()
            OtherActor:SetHollowAttribute()
        end
    end
end

return BP_HollowComponent
