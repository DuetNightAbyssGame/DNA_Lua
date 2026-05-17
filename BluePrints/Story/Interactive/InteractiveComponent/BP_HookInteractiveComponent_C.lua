--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type BP_HookInteractiveComponent_C
local M = Class({
    "BluePrints.Story.Interactive.InteractiveComponent.BP_InteractiveBaseComponent_C",
    "BluePrints.Common.TimerMgr",})

-- function M:BtnPressed(PlayerActor)
--     self:StartInteractive(PlayerActor)
-- end

function M:StartInteractive(PlayerActor)
    if not PlayerActor then
        return
    end
    local GameState = UGameplayStatics.GetGameState(self)
    if GameState.ShouldStopHookInDungeonDelivery then
        DebugPrint("ayff test DungeonDelivery中禁止钩锁交互")
        return
    end
    local Avatar = GWorld:GetAvatar()
    local MainPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local IsMainPlayer = MainPlayer.Eid == PlayerActor.Eid
    local Owner = self:GetOwner()
    PlayerActor.RPCComponent:InteractiveHook(PlayerActor.Eid, Owner.Eid)
    if IsMainPlayer and Avatar and Avatar.IsInRegionOnline then
        PlayerActor:ForceReSyncLocation()
        Avatar:UseGouSuoMessage(Avatar.CurrentOnlineType, Owner.CreatorId)
    end
    -- Owner:OpenMechanismMulti(PlayerActor.Eid)
end

function M:EndInteractive(PlayerActor)
    local Owner = self:GetOwner()
    if Owner.PlayerEids:Length() == 0 then
        return
    end
    if not PlayerActor then
        local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
        Player.RPCComponent:DeInteractiveHook(self.PlayerEid, Owner.Eid)
    else
        PlayerActor.RPCComponent:DeInteractiveHook(PlayerActor.Eid, Owner.Eid)
        PlayerActor:ForceReSyncLocation()
    end
    -- Owner:CloseMechanismMulti(PlayerActor.Eid, true)
end

function M:ForceEndInteractive(PlayerActor)
    local Owner = self:GetOwner()
    if not PlayerActor then
        local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
        Player.RPCComponent:DeInteractiveHook(Player.Eid, Owner.Eid)
    else
        PlayerActor.RPCComponent:DeInteractiveHookForce(PlayerActor.Eid, Owner.Eid)
    end
    -- Owner:ForceCloseMechanism(PlayerActor.Eid, true)
end
-- function M:Initialize(Initializer)
-- end

function M:IsCanInteractive(PlayerActor)
    return false
    -- if not self.HookGameModeComp then
    --     return false
    -- end
    -- local Owner = self:GetOwner()
    -- local bHit = self.HookGameModeComp:GetHookHitScene(PlayerActor, Owner.FXLoc)
    -- local bOutScreen = self.HookGameModeComp:GetHookOutScreen(Owner.FXLoc)
    -- --钩锁的距离判断是小于InteractiveDistance不能交互
    -- local DisCheck = self.DistanceCheckComponent(self, PlayerActor, self.InteractiveDistance, false)
    -- -- print(_G.LogTag,"LXZ IsCanInteractive", self.InteractiveDistance, DisCheck)
    -- return Owner:GetCanOpen() and not bHit and not bOutScreen and not DisCheck
end

function M:ReceiveBeginPlay()
    self.MontageName = "Interactive_02_Montage"
end

-- function M:DisplayInteractiveBtn(PlayerActor)
-- 	local Owner = self:GetOwner()
--     if not self.HookGameModeComp then
--         print(_G.LogTag,"Error: GameMode缺少钩锁组件")
--         return
--     end
--     self.HookGameModeComp:AddInteractiveHook(Owner)
--     self:SetBtnDisplayed(PlayerActor, true)
-- end

-- function M:RefreshInteractiveBtn(PlayerActor)
--     local Owner = self:GetOwner()
--     if not self.HookGameModeComp then
--         print(_G.LogTag,"Error: GameMode缺少钩锁组件")
--         return
--     end
--     local ValidHook = self.HookGameModeComp:GetValidHook(PlayerActor, Owner.TargetLoc)
--     if ValidHook ~= Owner then
--         return
--     end
--     self.InteractiveUI = UIManager(self):GetUIObj("HookInteractive")
--     if not self.InteractiveUI then
--         self.InteractiveUI = UIManager(self):LoadUINew("HookInteractive")
--         self.InteractiveUI:Init()
--     end
--     if self.InteractiveUI.Hook and self.InteractiveUI.Hook ~= ValidHook then
--         self.InteractiveUI.Hook:CloseUI()
--         ValidHook:ShowUI()
--         self.InteractiveUI:UpdateOwner(Owner, self, PlayerActor)
--     elseif self.InteractiveUI.Hook == nil then
--         ValidHook:ShowUI()
--         self.InteractiveUI:UpdateOwner(Owner, self, PlayerActor)
--     end
--     Owner:RefreshUI(PlayerActor)
-- end

-- function M:NotDisplayInteractiveBtn(PlayerActor)
--     local Owner = self:GetOwner()
--     if not self.HookGameModeComp then
--         print(_G.LogTag,"Error: GameMode缺少钩锁组件")
--         return
--     end
--     if not self.InteractiveUI then
--         return
--     end
--     self.InteractiveUI:Close()
--     self.InteractiveUI = nil
--     Owner:CloseUI()
--     self.HookGameModeComp:RemoveInteractiveHook(Owner)
--     self:SetBtnDisplayed(PlayerActor, false)
-- end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

return M
