--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_ZhiLiuDoor_C
local M = Class({
    "BluePrints.Item.Chest.BP_MechanismBase_C",
})

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self,Info)
    -- self.InteractiveNum = self.UnitParams["InteractiveNum"]
    -- self.InteractiveTime = self.UnitParams["InteractiveTime"]
    -- self.DownTime = self.UnitParams["DownTime"]
end

function M:OnActorReady(Info)
    M.Super.OnActorReady(self, Info)

    -- local OverlappingActors = UE4.TArray(UE4.AActor)
    -- self.Box:GetOverlappingActors(OverlappingActors, nil)
    -- for i = 1, OverlappingActors:Length() do
    --     local Actor = OverlappingActors:Get(i)
    --     if Actor and Actor:IsPlayer() then
    --         self:OnEnterQTE(Actor)
    --         break
    --     end
    -- end
end

function M:OnEnterQTE(Player)
    self.Player = Player
    self.IsInQTE = true
    if self.CurStage == 1 then
        self.QTEUI = UIManager(self):LoadUINew("ZhiLiuDoorQTE", self, self.InteractiveNum, self.InteractiveTime, self.DownTime)
        -- 隐藏除QTE外的UI
        -- UIManager(self):HideAllUI_EX({"ZhiLiuDoorQTE", "MenuLevel", "MenuBattle"}, true, "ZhiLiuDoorQTE")
        UIManager(self):HideAllUI_EX({"ZhiLiuDoorQTE"}, true, "ZhiLiuDoorQTE")

        self:DisableOpenMenu()
    end
end

function M:OnLeaveQTE(Player)
    -- 离开触发盒
    if Player then
        Player:RemoveDisableInputTag("ZhiLIUQTE")
    end
    self.Player = nil
    -- UIManager(self):UnLoadUINew("ZhiLiuDoorQTE")
    self.IsInQTE = false
    if self.QTEUI then
        self.QTEUI:OnOut()
        -- self.QTEUI:PlayAnimationReverse(self.QTEUI.Remind)
    end
    UIManager(self):HideAllUI_EX({"ZhiLiuDoorQTE"}, false, "ZhiLiuDoorQTE")
    self:RestoreOpenMenu()
end

function M:OnQTEEnd()
    -- QTE完成
    self.IsInQTE = false
    if self.Player then
        self.Player:RemoveDisableInputTag("ZhiLIUQTE")
        local RealSubFile = "MechInteractive"
		self.Player:SetEnterInteractive(false, self.InteractiveMontageName, nil, RealSubFile)
    end
    self.QTEUI:OnEnd()
    -- self.QTEUI:PlayAnimationReverse(self.QTEUI.Remind)
    -- UIManager(self):UnLoadUINew("ZhiLiuDoorQTE")
    UIManager(self):HideAllUI_EX({"ZhiLiuDoorQTE"}, false, "ZhiLiuDoorQTE")
    self:RestoreOpenMenu()
end

function M:OnEnterInteractive()
    if not self.Player then return end
    -- self.ChestInteractiveComponent:OnStartInteractive(self.Player, self.ChestInteractiveComponent.MontageName, self.Eid)
    self.Player:AddDisableInputTag("ZhiLIUQTE")
    local RealSubFile = "MechInteractive"
    self.Player:SetEnterInteractive(true, self.InteractiveMontageName, nil, RealSubFile)
    self:OnFirstPress()
end

function M:OnPressInteractive()
    -- if self.CurStage == 1 then
    --     self.CurInteractiveNum = self.CurInteractiveNum + 1
    -- elseif self.CurStage == 2 then
    --     self.CurInteractivePercent = self.CurInteractivePercent + 0.1
    --     if self.CurInteractivePercent > 1.0 then
    --         self.CurInteractivePercent = 1.0
    --     end
    -- end
end

function M:DisableOpenMenu()
    self.InputSetting = UE4.UInputSettings.GetInputSettings()

    -- 获取并保存特定的 Action Mapping
    self.SavedActionMappings = UE4.TArray(UE4.FInputActionKeyMapping)
    self.InputSetting:GetActionMappingByName("OpenMenu", self.SavedActionMappings)

    -- 移除
    for i = 1, self.SavedActionMappings:Length() do
        self.InputSetting:RemoveActionMapping(self.SavedActionMappings:Get(i))
    end
end

function M:RestoreOpenMenu()
    self.InputSetting = UE4.UInputSettings.GetInputSettings()
    if self.SavedActionMappings then
        for i = 1, self.SavedActionMappings:Length() do
            self.InputSetting:AddActionMapping(self.SavedActionMappings:Get(i))
        end
        self.SavedActionMappings = nil
    end
end

function M:FirstStageComplete()
    self:ChangeState("Manual", 0, self.SecondStageState)
end

function M:SecondStageComplete()
    self:ChangeState("Manual", 0, self.CompleteStage)
    self:OnQTEEnd()
end

function M:DisablePlayerInput()
    if self.QTEUI then
        self.QTEUI.CanInteract = false
    end
end

function M:EnablePlayerInput()
    if self.QTEUI then
        self.QTEUI.CanInteract = true
    end
end

function M:StartTeleport()
	local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local CurLocation = PlayerCharacter:K2_GetActorLocation()
    DebugPrint("zwk StartTeleport CurLocation: ", CurLocation)
	PlayerCharacter:K2_TeleportTo(self.TargetLocation, self.TargetRotation, false, nil, false)
    PlayerCharacter:ResetIdle()
    PlayerCharacter:GetController():SetControlRotation(self.TargetRotation)
    local NewLocation = PlayerCharacter:K2_GetActorLocation()
    DebugPrint("zwk StartTeleport NewLocation: ", NewLocation)
end

return M
