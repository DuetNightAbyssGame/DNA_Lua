--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Battle_Resurrection_C
local WBP_Battle_Resurgence_C = Class({"BluePrints.UI.BP_UIState_C","BluePrints.Common.TimerMgr"})

function WBP_Battle_Resurgence_C:Construct()
    self.Super.Construct(self)
    self.Owner=nil
    self.NowTime=nil
    self.RecoveryTickTime = 0.03      --复活进度条tick时间
    self.CanRecovery = false          --能否复活
    self.HideUITag = "Resurgence"     --隐藏UI的Tag
    self:InitEvent()

    local CloseUi = function()
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Out)
        -- self:PlayAnimation(self.Out)
    end
    self:BindToAnimationFinished(self.success, {self, CloseUi})
    self:BindToAnimationFinished(self.Out, {self, self.ShowBattleMainUI})

    self:RefreshOpInfoByInputDevice()
end

function WBP_Battle_Resurgence_C:InitEvent()
    self:AddDispatcher(EventID.CharRecover,self,self.ResurgenceAccomplish)
    self:AddDispatcher(EventID.OnExitDungeon,self,self.OnExitDungeon)
    self:AddDispatcher(EventID.OnMainCharacterInitReady,self,self.OnMainCharacterInitReady)
end 

function WBP_Battle_Resurgence_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    self.CurGamepadName = UIUtils.UtilsGetCurrentGamepadName()
    if self.CurInputDeviceType == UE4.ECommonInputType.Gamepad then 
        self.WidgetSwitcher_MP:SetActiveWidgetIndex(1)
    else
        self.WidgetSwitcher_MP:SetActiveWidgetIndex(0)
    end
end

function WBP_Battle_Resurgence_C:OnMainCharacterInitReady()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if not IsValid(Player) then
        return
    end
    self.Owner = Player
end

function WBP_Battle_Resurgence_C:InitResurgenceUI(TargetEid)
    self.IsStart = false -- 是否已开始复活
    self.Teammate = Battle(self):GetEntity(TargetEid)
    if not IsValid(self.Owner) or self.Owner.Eid ~= TargetEid then
        return
    end
    self:HideBattleMainUI()
    self.Owner:OnDeathDissolve()
    local RemainTimes = self.Owner:GetRemainRecoveryTimes()
    if RemainTimes < 0 then
        self.RemainTimes:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.RemainTimes:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Text_RemainTimes:SetText(RemainTimes)

        if RemainTimes == 0 then 
            self.Text_RemainTimes:SetColorAndOpacity(self.Color_RemainTimes_Red)
        else
            self.Text_RemainTimes:SetColorAndOpacity(self.Color_RemainTimes_Normal)
        end
    end
    if(self:IsExistTimer("ListenRecoverValue")) then
        self:RemoveTimer("ListenRecoverValue")
    end
    if(self:IsExistTimer("ResurgenceAccomplish")) then
        self:RemoveTimer("ResurgenceAccomplish")
    end
    self:AddTimer(self.RecoveryTickTime, self.ListenRecoverValue,true,0,"ListenRecoverValue")
    self.Battle_Resurgence_New:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

    self:ShowLongPressHint(self.Owner:CheckCanRecovery())

    -- PC端长按提示
    self.Text01:SetText('')
    self.Text02:SetText(GText('BATTLE_RECOVERY_LONGPRESSRECOVERY'))

    -- 手机端长按提示
    self.Button_Revive:SetText(GText('BATTLE_RECOVERY_LONGPRESSRECOVERY'))
    self.Button_Revive:BindEventOnClicked(self, function()  self:SetBarPercentByX(self.Owner) end)

    self.Key_Single:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Text",
                -- Text = CommonUtils:GetKeyText(CommonUtils:GetActionMappingKeyName("Recovery"))
                Text = CommonUtils:GetActionMappingKeyName("Recovery")
            }
        }
    })

    -- 手柄端按键提示

    self.Key_GamePad:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Y",
            },
        },
        -- Desc = GText("UI_Tips_Close"),
    })

    self:ResetBar()
    self:StopAllAnimations()
    self:PlayAnimation(self.In)
    if self.IsRecoverKeyPressed then 
        self:SetBarPercentByX(self.Owner)
    end

    -- 处理濒死计时
    if self.Owner:HaveDyingCountDown() then 
        self.Text_CountDown:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Text_CountDown:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then 
        self:InitMobile()
    else
        self:InitPC()
    end

end

function WBP_Battle_Resurgence_C:InitPC()

end

function WBP_Battle_Resurgence_C:InitMobile()

end

function WBP_Battle_Resurgence_C:ShowLongPressHint(IsShow)
    -- DebugPrint("Tianyi@ ShowLongPressHint: " .. tostring(IsShow))
    local bIsMobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
    if IsShow then 
        if bIsMobile then 
            self.Panel_Revive_Phone:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible) 
            self.LongpressHint:SetVisibility(UE4.ESlateVisibility.Collapsed) 
        else 
            self.LongpressHint:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible) 
            self.Panel_Revive_Phone:SetVisibility(UE4.ESlateVisibility.Collapsed) 
        end
    else 
        self.Panel_Revive_Phone:SetVisibility(UE4.ESlateVisibility.Collapsed) 
        self.LongpressHint:SetVisibility(UE4.ESlateVisibility.Collapsed) 
    end
end

function WBP_Battle_Resurgence_C:ListenRecoverValue()
    -- 如果无复活次数了，不需要tick进度
    -- if self.Owner:IsRealDead() then 
    --     return 
    -- end

    local DyingLeftTime = self.Owner:GetDyingLeftTime()
    if DyingLeftTime then 
        self.Text_CountDown:SetText(math.max(math.floor(DyingLeftTime), 0))
    end

    -- if not self.Owner:IsInRecovering() then 
    --     return 
    -- end

    local NowRecoverValue = self.Owner:GetRecoveryPercent()
    -- if NowRecoverValue > 0 then
    --     if not self.IsStart then
    --         AudioManager(self):PlayUISound(self, "event:/ui/common/revive", "Recovery", nil)
    --     end
    --     self.IsStart = true
    -- else
    --     if self.IsStart then
    --         AudioManager(self):StopSound(self, "Recovery")
    --     end
    --     self.IsStart = false
    -- end
    local Percent =  math.min(math.max(NowRecoverValue/Const.MaxRecoverValue,0), 1)
    self.Progress:SetPercent(Percent)
    local VXProgress = self.VX_GlowLine:GetDynamicMaterial()
    local VXPercent = -0.95 + (0.075 + 0.95) * Percent
    VXProgress:SetScalarParameterValue("Main_V_Offset", VXPercent)
    self.Text_RescueByOther:SetText(GText('BATTLE_RECOVERY_BEHELPING'))
    if self.Owner:IsRecoveringByOther() then
        if not (self:IsExistTimer("PlayLoopAnimation")) then
            local AnimTime = self.Loop:GetEndTime()
            local PlayLoopAnimation = function()
                self:PlayAnimation(self.Loop)
            end
            self:AddTimer(AnimTime,PlayLoopAnimation,true,0,"PlayLoopAnimation")
        end
        self.Text_RescueByOther:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        if (self:IsExistTimer("PlayLoopAnimation")) then
            self:RemoveTimer("PlayLoopAnimation")
            self:StopAnimation(self.Loop)
        end
        self.Text_RescueByOther:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function WBP_Battle_Resurgence_C:OnExitDungeon()
    AudioManager(self):SetEventSoundParam(self, "Recovery", {ToEnd = 1})
end

function WBP_Battle_Resurgence_C:ResurgenceAccomplish(Eid)
    if not IsValid(self.Owner) or self.Owner.Eid ~= Eid then
        return
    end
    if(self:IsExistTimer("ListenRecoverValue")) then
        self:RemoveTimer("ListenRecoverValue")
    end
    self.Progress:SetPercent(1.0)
    local VXProgress = self.VX_GlowLine:GetDynamicMaterial()
    VXProgress:SetScalarParameterValue("Main_V_Offset", 0.075)
    
    self:AddTimer(0.033, function()
        AudioManager(self):SetEventSoundParam(self, "Recovery", {ToEnd = 1})
    end)
    
    local UIBattleMain = UIManager(self.Owner):GetUI("BattleMain")
    if UIBattleMain then 
        UIBattleMain:PlayDeathMaskOut()
    end
    self:PlayAnimation(self.success)
end

function WBP_Battle_Resurgence_C:SetBarPercentByX(Character)
    if not Character:IsDead() or not Character:CheckCanRecovery() or Character:IsInRecovering() or Character.IsTeleportRecovery then
        return
    end

    local bIsMobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
    if bIsMobile then 
        self:PlayAnimation(self.Phone_BtnOut) 
    else   
        self:PlayAnimation(self.Press)
    end

    local CurRemainRecoveryTimes = self.Owner:GetRemainRecoveryTimes()
    local AfterRemainReocveryTimes = CurRemainRecoveryTimes - 1

    -- 播放消耗复活币动画
    self:PlayAnimation(self.UseCoin)
    if AfterRemainReocveryTimes <= 0 then 
        self.Text_RemainTimes:SetColorAndOpacity(self.Color_RemainTimes_Red)
    end

    -- 隐藏倒计时
    self.Text_CountDown:SetVisibility(UE4.ESlateVisibility.Collapsed)
    
    self.Text_RemainTimes:SetText(self.Owner:GetRemainRecoveryTimes() - 1)
    self.Owner:ServerBeginRecoverOther(self.Owner.Eid, UE4.ERecoverReason.RecoverReason_SelfRecover)
    AudioManager(self):PlayUISound(self, "event:/ui/common/revive", "Recovery", nil)
end

function WBP_Battle_Resurgence_C:ResetBar()
    -- self.Owner:ServerStopRecoverOther(self.Owner.Eid)
end

function WBP_Battle_Resurgence_C:HideBattleMainUI()
    ---@type Battle_PC_C
    local UIBattleMain = UIManager(self.Owner):GetUI("BattleMain")
    if UIBattleMain then 
        UIBattleMain:ShowPlayerDeadUI()
    end 

    if self.Owner then 
        local RespawnRule = self.Owner:GetCurRespawnRuleName()
        if RespawnRule == "CommonRegion" then 
            self:HideAllUIWithOutSelf(true, "RegionResurgence")
        end
    end

    AudioManager(self):PlayUISound(self, "event:/ui/common/revive_filter", "DeadResurgence", nil)
end

function WBP_Battle_Resurgence_C:ShowBattleMainUI()
    --@type Battle_PC_C
    local UIBattleMain = UIManager(self.Owner):GetUI("BattleMain")
    if UIBattleMain then 
        UIBattleMain:HidePlayerDeadUI()
    end

    if self.Owner then 
        local RespawnRule = self.Owner:GetCurRespawnRuleName()
        if RespawnRule == "CommonRegion" then 
            self:HideAllUIWithOutSelf(false, "RegionResurgence")
        end
    end

    AudioManager(self):SetEventSoundParam(self, "DeadResurgence", {ToEnd = 1})
end

--function WBP_Battle_Resurgence_C:SetCharBattleUIVisibilityTag(PlayerChar, HideTag, Invisible)
--    --if not PlayerChar.GetCharSpecialUI then
--    --    return
--    --end
--    ---@type BP_UIState_C
--    local UIBattleMain = UIManager(self):GetUI("BattleMain")
--    if not UIBattleMain then
--        return
--    end
--    UIBattleMain:SetUIVisibilityTag(HideTag, Invisible)
--end

--function WBP_Battle_Resurgence_C:Destruct()
--    self.Super.Destruct(self)
--    EventManager:RemoveEvent(EventID.CharRecover,self)
--end

return WBP_Battle_Resurgence_C