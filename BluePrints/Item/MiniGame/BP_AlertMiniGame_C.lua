--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "Unlua"
---@type BP_AlertMiniGame_C
local M = Class("BluePrints.Item.MiniGame.BP_MiniGame_C")

function M:GetMonsterAnimTrans()
    return self.MonsterPosition:K2_GetComponentToWorld()
end

function M:TriggerFunctionOnSelf()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if self.IsGameSuccess or self.AlwaysSuccess then
        if GameMode:IsInDungeon() and GameMode:DungeonCheckCanExitAlert() then
            GameMode:TriggerActiveGameModeState(Const.ExitStateAlert)
            --回到初始状态，等待下次报警
            self:ChangeState("Manual", 0, self.Data.FirstStateId)
            self.OpenState = false
            return
        end
        if GameMode:IsInRegion() and GameMode:RegionCheckCanExitAlert(self.ClanId) then
            local ClanMgr = GameMode:GetClan(self.ClanId)
            if not ClanMgr then 
                return
            end
            --通知群落管理器退出警报状态
            ClanMgr:ExitAlert()
        end
    end
end

-- function M:CloseMechanism()
-- end

function M:GetCanOpen()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameState:IsInDungeon() then
        if GameState:GetGameModeState() == EGameModeState.ERunning then
            self.CanOpen = false
        else
            self.CanOpen = GameState:GetInCommonAlert()
        end
        return
    end
    if GameState:IsInRegion() then
        self.CanOpen = UE4.UGameplayStatics.GetGameMode(self):RegionCheckCanExitAlert(self.ClanId)
        return
    end
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
