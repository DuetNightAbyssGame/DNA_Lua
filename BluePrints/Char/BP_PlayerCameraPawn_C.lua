--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_PlayerCameraPawn_C
local M = Class()

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

function M:ReceiveBeginPlay()
    GWorld.PlayerCameraPawn = self
    self.PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.bUseControllerRotationYaw = true;
    self.bUseControllerRotationPitch = true;
    self.CharSpringArmComponent.bDoCollisionTest = false;
end

function M:ShowCursor_Press()
    DebugPrint("ShowCursor_Press", UE4.UKismetSystemLibrary.GetFrameCount())
    local GameInputSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if not IsValid(GameInputSubsystem) then
        return
    end
    GameInputSubsystem:HandleShowCursorPressOrRelease(true)
    local BattlePage = UIManager(self):GetUIObj("AutoChessBattlePage")
    if BattlePage then
        BattlePage:SetUserFocus(self.PlayerController)
    end
end

function M:ShowCursor_Release()
    DebugPrint("ShowCursor_Release",UE4.UKismetSystemLibrary.GetFrameCount())
    local GameInputSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if not IsValid(GameInputSubsystem) then
        return
    end
    GameInputSubsystem:HandleShowCursorPressOrRelease(false)
end

function M:OnPressQ()
    local UIObj = UIManager(self):GetUIObj("AutoChessBattlePage")
    if not UIObj or not UIObj.BattleStatisticsTips then
        return
    end
    UIObj.BattleStatisticsTips:AllyFight_OnClicked()
end

function M:OnPressE()
    local UIObj = UIManager(self):GetUIObj("AutoChessBattlePage")
    if not UIObj or not UIObj.BattleStatisticsTips then
        return
    end
    UIObj.BattleStatisticsTips:EnemyFight_OnClicked()
end

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
