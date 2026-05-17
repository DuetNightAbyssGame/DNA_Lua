--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local M = Class("BluePrints.Item.Chest.BP_MechanismBase_C")

function M:AuthorityInitInfo(Info)
    M.Super.AuthorityInitInfo(self,Info)
    self.CanOpen = true
    self:SetRewardID()
end

function M:OpenMechanism(PlayerId)
    if not self.OpenState then
        self:CreateReward(PlayerId)
    end
    self:UpdateRegionData("OpenState", true)
    if self.ChestInteractiveComponent then
        local Player = Battle(self):GetEntity(PlayerId)
        if Player then
            self.ChestInteractiveComponent:EndInteractive(Player)
        end
    end
end

function M:SetRewardID()
    -- local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    -- self.RewardID = self.Data["RewardId"]
    -- if self.RewardID then
    --     GameMode:InitDropRule(self.UnitId, self.RewardID)
    -- end
    -- return self.RewardID
end

function M:AdjustLocation()
    if not self.Data["NeedLocationAdjustment"] then 
        return
    end
    M.Super.AdjustLocation(self)
end

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

-- function M:ReceiveBeginPlay()
-- end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

return M
