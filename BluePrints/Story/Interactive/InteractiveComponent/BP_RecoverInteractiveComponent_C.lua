--BluePrints.Story.Interactive.InteractiveComponent.BP_RecoverInteractiveComponent_C

local LuaConst = require("EMLuaConst")
require "UnLua"
local BP_RecoverInteractiveComponent_C = Class({
    "BluePrints.Story.Interactive.InteractiveComponent.BP_InteractiveBaseComponent_C",
    "BluePrints.Common.TimerMgr",})


-- Virtual Override Begin
function BP_RecoverInteractiveComponent_C:ReceiveBeginPlay()
    self.Super.ReceiveBeginPlay(self)
    self.InteractStartTimer = 0
    self.Priority = "Normal"
    self.IsBeginRecoverOther = false
    self:SetInteractiveDistance(200)
    local RecoveryData = DataMgr.PlayerRotationRates
    self.RecoverySpeed = RecoveryData["RecoverySpeed"].ParamentValue[1] or 0
    self.CommonUIConfirmID = 20001
    UE4.URuntimeCommonFunctionLibrary.SetSceneCompSkipUpdateOverlap(self)
end

function BP_RecoverInteractiveComponent_C:InitCharInfo()
    local Owner = self:GetOwner()
    if Owner:IsPhantom() then 
        local UnitId = Owner.UnitId
        local PhantomData = DataMgr.Phantom[UnitId]
        if PhantomData and PhantomData.RespawnUI then  
            self.CommonUIConfirmID = PhantomData.RespawnUI
        end
    end
end

function BP_RecoverInteractiveComponent_C:CheckPlayerTag(PlayerActor)
    local Owner = self:GetOwner()
    --暂定方案：角色必须无跳跃才能交互
    local Res = PlayerActor.PlayerAnimInstance.CurrentJumpState == Const.NormalState and PlayerActor:CheckCanEnterTag("Interactive")
    if Owner:IsCombatItemBase() and PlayerActor.IsSkillDown then
        Res = Res and not PlayerActor:IsSkillDown()
    end
    return Res
end

function BP_RecoverInteractiveComponent_C:IsCanInteractive(PlayerActor)
    if PlayerActor and not self.bPressing and PlayerActor.WaitCallBack then
        return false
    end
    local Owner = self:GetOwner()
    if not Owner:IsDead() or not Owner:IsWaitingForRecover() then 
        return false 
    end 

    if Owner.Eid == PlayerActor.Eid then
        return false
    end

    if Owner:IsMonster() and (not Owner:IsPhantom()) then 
        return false 
    end

    if Owner:IsPhantom() and not Owner.IsHostage and Owner.PhantomOwner.Eid ~= PlayerActor.Eid then 
        return false 
    end

    if LuaConst.OpenComputeInteractive then
        return self:GetDistanceCheckResult()
    else
        return self:DistanceCheckComponent(PlayerActor, self.InteractiveDistance)
    end
end

function BP_RecoverInteractiveComponent_C:DisplayInteractiveBtn(PlayerActor)
    local UIManager = UGameplayStatics.GetGameInstance(self):GetGameUIManager()
	local InteractiveUI = UIManager:LoadUINew(UIConst.InteractiveUIName)
    if not InteractiveUI then
        return
    end
	InteractiveUI:AddInteractiveItem(self)
    self:SetBtnDisplayed(PlayerActor, true)
end


function BP_RecoverInteractiveComponent_C:NotDisplayInteractiveBtn(PlayerActor)
    self:SetBtnDisplayed(PlayerActor, false)
    local UIManager = UGameplayStatics.GetGameInstance(self):GetGameUIManager()
	local InteractiveUI = UIManager:GetUIObj(UIConst.InteractiveUIName)
    if not InteractiveUI then
        return
    end
	InteractiveUI:RemoveInteractiveItem(self)
    if PlayerActor and not self:IsCanInteractive(PlayerActor) then
        self:EndPressInteractive(PlayerActor,false)
    end
end

function BP_RecoverInteractiveComponent_C:StartInteractive(PlayerActor)
    local Owner = self:GetOwner()
    if self:IsCanInteractive(PlayerActor) and not PlayerActor.WaitCallBack then
        self.IsBeginRecoverOther = true
        PlayerActor:SetCharacterTag('Interactive')
        PlayerActor:ServerBeginRecoverOther(Owner.Eid, UE4.ERecoverReason.RecoverReason_TeammateRecover)
        PlayerActor:ServerPlayAnimOnRecoverInteractive(Owner.Eid,0)
        self.CanEnd = true
    end
end

function BP_RecoverInteractiveComponent_C:BtnPressed(PlayerActor)
    self.bPressing = true
    if not self.bForbidden then 
        self:StartInteractive(PlayerActor)
    else 
        local Owner = self:GetOwner()
        if Owner:IsRealDead() then 
            UIManager(Owner):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, "TOAST_PHANTOM_ZERO")
        elseif Owner:IsRecoveringByOther(0) then 
            UIManager(self):ShowUITip(UIConst.Tip_CommonTop, string.format(GText("BATTLE_RECOVERY_TEAMMATEBEINGHELP"), UIUtils.GetCharName(Owner)))
        else 
            UIManager(Owner):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, "UI_INTERACTIVE_FAILMSG")
        end
    end
end


function BP_RecoverInteractiveComponent_C:EndPressInteractive(PlayerActor, IsSuccess, ReasonId)
    self.bPressing = false
    local Owner = self:GetOwner()
    self:CheckPlayerTag(PlayerActor)
    if self.IsBeginRecoverOther == true then
        PlayerActor:ServerStopRecoverOther(Owner.Eid)
        if (PlayerActor:CharacterInTag("Interactive")) then
            PlayerActor:SetCharacterTag('Idle')
        end
        PlayerActor:ServerPlayAnimOnRecoverInteractive(Owner.Eid,2)
    end
    self.IsBeginRecoverOther = false
end

function BP_RecoverInteractiveComponent_C:BtnReleased(PlayerActor)
    self:EndPressInteractive(PlayerActor, false)
end

function BP_RecoverInteractiveComponent_C:GetInteractiveName()
    local Owner = self:GetOwner()
    local CharName = GText(DataMgr.BattleChar[Owner.CurrentRoleId].CharName)
	return string.format(GText('BATTLE_RECOVERY_LONGPRESSHELP'), CharName)
end

function BP_RecoverInteractiveComponent_C:TriggerTick(PlayerActor)
	self:UpdateDisplayInteractiveBtn(PlayerActor)
end

function BP_RecoverInteractiveComponent_C:IsLastingInteract()
    return true
end

function BP_RecoverInteractiveComponent_C:IsForbidden(PlayerActor)
    -- DebugPrint("Tianyi@ CheckIsForbidden")
    local Owner = self:GetOwner()
    if Owner:IsRealDead() then 
        return true 
    end

    if not PlayerActor:CheckCanRecoverOther(Owner, UE4.ERecoverReason.RecoverReason_TeammateRecover) then 
        return true 
    end

    if PlayerActor and not PlayerActor:CanEnterInteractive() then 
        return true 
    end

    return false
end

function BP_RecoverInteractiveComponent_C:TriggerExit(PlayerActor)
	if self:IsBtnDisplayed(PlayerActor) then
		self:NotDisplayInteractiveBtn(PlayerActor)
	end
end

return BP_RecoverInteractiveComponent_C