--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_DongGuoDarkCloud_Child_C
local M = Class({"BluePrints/Item/ExploreGroup/BP_DongGuoBreakableItem_C","BluePrints.Common.TimerMgr"})

function M:ReceiveBeginPlay()
    M.Super.ReceiveBeginPlay(self)
end

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self,Info)
    self:HideMechanism(false, "Condition")
    self:StartMove()
end

-- 碰撞，小气团融入大气团
function M:StartIntegration(Actor)
    if Actor.IsDongGuoDarkCloud and Actor.IsCanDestroy then
        self.IsIntegrated = true
        Actor:StartIntegration()
        self:K2_DestroyActor()
    end
end

function M:MoveToTarget()
    self:ShowMechanism("Condition")
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local StaticCreator = GameState:GetStaticCreatorInfo(self.CreatorId)
    if IsValid(StaticCreator) then
        local TargetLoc = StaticCreator:K2_GetActorLocation()
        self:SetMovementTarget(1, true, TargetLoc)
    end
end

function M:MoveTargetEnd()
    -- self:ShowMechanism("Condition")
    -- DebugPrint("BP_DongGuoDarkCloud_Child_C:MoveTargetEnd")
    -- self.Overridden.MoveTargetEnd(self)
end

function M:StartMove()
    self.bCanMove = true
    self.IsMoving = true
end

function M:UpdateMovementTarget(SourceId)
    if not self.bCanMove then return end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if not Player then return end
    local NewLoc = Player:K2_GetActorLocation()
    self:SetMovementTarget(2, true, NewLoc)
end

function M:IntergrationOver()
    self.IsMoving = false
    self.bCanMove = false
end

return M
