--
-- DESCRIPTION
-- 技能面板PC版
-- @COMPANY **
-- @AUTHOR ** hongyang
-- @DATE ${date} ${time}
--

require "UnLua"

local IconLoadingType = {
    SupportSkill = 1,
    BulletIcon = 2,
    WeaponIcon = 3
}

local WBP_Player_SkillPanel_PC_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_Player_SkillPanel_PC_C:Initialize(Initializer)
    self.Super.Initialize(self)
    self.OwnerPlayer = nil
    self.CurState = "Normal"
    self.PlayerMainRoleId = nil
    self.SupportSkillState = "UnLock"
    self.SupportSkillForCRTimeStamp = nil
    self.SkillButtons = {}
    self.PlayerSpHelpInfo = {}
    self.IsLackMagazine = false
    self.IsRefreshWeapon = true
    self.LoadingIconMap = {}
    self.InfinitySymbol = GText("INFINITY_SYMBOL")
    self.MyFVector2D = FVector2D(0, 0)
end

 function WBP_Player_SkillPanel_PC_C:Construct()
     self.Super.Construct(self)
     self:InitListenEvent()
     self.Energy_Skill:SetExplicitChildLayer(true)
 end

function WBP_Player_SkillPanel_PC_C:InitSkillAfterCharInitReady()
    -- 角色初始化成功事件回调处理
    self:GetOwnerPlayer()
    if (not IsValid(self.OwnerPlayer)) then
        return
    end
    self:InitSupportSkill()
    self:InitVariable(self:GetOwnerPlayer())
    self:GetSkillActiveInfo()
    if (self.IsInit) then
        if (not self:IsExistTimer("UpdateSkillPanelInfoInTimer")) then
            self:AddTimer(0.1, self.UpdateSkillPanelInfoInTimer, true, 0, "UpdateSkillPanelInfoInTimer", false)
        end
        return
    end
    self:OnLoaded()
    self:ClearRemainAnim()
    self.OwnerPlayer:SetSkillPanelTimer()
end

function WBP_Player_SkillPanel_PC_C:Destruct()
    self.Super.Destruct(self)
    self:StopAllAnimations()
    self:FlushAnimations()
    local Avatar = GWorld:GetAvatar()
    if Avatar == nil then return end
    if self.SupportUnlockKey then
        Avatar:UnBindOnUIFirstTimeUnlock(self.SupportUIUnlockRuleId, self.SupportUnlockKey)
    end
    if self.SwitchUnlockKey then
        Avatar:UnBindOnUIFirstTimeUnlock(self.SwitchUIUnlockRuleId, self.SwitchUnlockKey)
    end
end

function WBP_Player_SkillPanel_PC_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self.IsInit = true
    self:PlayAnim("In")
    self:OnBattlePetInitReady()
    self.Main:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function WBP_Player_SkillPanel_PC_C:CloseWithOutAnim()
    self:BindToAnimationFinished(self.Out, {self, self.Close})
    self:PlayAnim("Out")
end

function WBP_Player_SkillPanel_PC_C:InitListenEvent()
    self:AddDispatcher(EventID.OnBattlePetInitReady, self, self.OnBattlePetInitReady)
    self:AddDispatcher(EventID.OnSwitchRole, self, self.OnSwitchRole)
    self:AddDispatcher(EventID.ChangeRole, self, self.OnSwitchRole)
    self:AddDispatcher(EventID.OnSwitchPet, self, self.OnSwitchPet)
    --self:AddDispatcher(EventID.SupportSkillForChangeRole, self, self.OnSupportSkillForChangeRole)
    self:AddDispatcher(EventID.UpdateMainPlayerSp,self,self.OnUpdateCharSp)
    self:AddDispatcher(EventID.UpdateMainPlayerMaxSp, self, self.OnUpdateMaxSp)
    self:AddDispatcher(EventID.OutOfBullet, self, self.OnWeaponBulletNotEnough)
    self:AddDispatcher(EventID.OnSelectWeapon, self, self.RefreshWeaponIcon)
    self:AddDispatcher(EventID.OnSwitchWeapon, self, self.RefreshWeaponIcon)
    self:AddDispatcher(EventID.OnChangeKeyBoardSet, self, self.RefreshKeyName)
    self:AddDispatcher(EventID.OnSwitchGamepadSet, self, self.SetGamepadIcons)
    self:AddDispatcher(EventID.TriggerAddSpAnim, self, self.PlayAddSpAnim)
    self:AddDispatcher(EventID.ShowSkillAnim, self, self.PlayGuideRemind)
    self:AddDispatcher(EventID.HideSkillAnim, self, self.StopGuideRemind)
    self:AddDispatcher(EventID.UpdateSkillEfficiency, self, self.OnUpdateSkillEfficiency)
    self:AddDispatcher(EventID.OnBuffSpModify, self, self.OnUpdateBuffSpModify)
    self:AddDispatcher(EventID.OnPropEffectReplaceSkill, self, self.OnPropEffectReplaceSkill)
    self:AddDispatcher(EventID.OnPropEffectEndReplaceSkill, self, self.OnPropEffectEndReplaceSkill)
    self:AddDispatcher(EventID.OnGamepadUseSkillForceReleased, self, self.OnGamepadUseSkillRelease)
    self:AddDispatcher(EventID.OnEnableBattleMount, self, self.OnEnableBattleMount)
    self:AddDispatcher(EventID.OnDisableBattleMount, self, self.OnDisableBattleMount)
    self:AddDispatcher(EventID.OnStartMountFly, self, self.OnStartMountFly)
    self:AddDispatcher(EventID.OnStopMountFly, self, self.OnStopMountFly)
    self:AddDispatcher(EventID.OnSkillInfosRep, self, self.OnSkillInfosRep)
    self:AddDispatcher(EventID.OnSkill1InAirChanged, self, self.OnSkill1InAirChanged)
    self:AddDispatcher(EventID.OnSkill2InAirChanged, self, self.OnSkill2InAirChanged)
end

function WBP_Player_SkillPanel_PC_C:InitVariable(OwnerPlayer)
    -- 初始化一些变量设置
    self.OwnerPlayer = OwnerPlayer
    local Avatar = GWorld:GetAvatar()
    local KeySkill1Name, KeySkill2Name, KeySkill3Name, KeyFireName, KeyDownName, KeyMountFlyName = "", "", "", "", "", "", ""
    if (Avatar and Avatar.ActionMapping ~= nil) then
        KeySkill1Name = Avatar.ActionMapping["Skill1"] or DataMgr.KeyBoardMap["Skill1"].Key
        KeySkill2Name = Avatar.ActionMapping["Skill2"] or DataMgr.KeyBoardMap["Skill2"].Key
        KeySkill3Name = Avatar.ActionMapping["Skill3"] or DataMgr.KeyBoardMap["Skill3"].Key
        KeyFireName = Avatar.ActionMapping["Fire"] or DataMgr.KeyBoardMap["Fire"].Key
        KeyDownName = Avatar.ActionMapping["Slide"] or DataMgr.KeyBoardMap["Slide"].Key
        KeyMountFlyName = Avatar.ActionMapping["Jump"] or DataMgr.KeyBoardMap["Jump"].Key
    else
        KeySkill1Name = DataMgr.KeyBoardMap["Skill1"].Key
        KeySkill2Name = DataMgr.KeyBoardMap["Skill2"].Key
        KeySkill3Name = DataMgr.KeyBoardMap["Skill3"].Key
        KeyFireName = DataMgr.KeyBoardMap["Fire"].Key
        KeyDownName = DataMgr.KeyBoardMap["Slide"].Key
        KeyMountFlyName = DataMgr.KeyBoardMap["Jump"].Key
    end
    self.Battle_Skill_1.OwnerPanel = self
    self.Battle_Skill_1.Common_Key_PC:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Text",
                Text = KeySkill1Name,
            }
        },
        bBattleKey = true
    })
    self.Battle_Skill_2.OwnerPanel = self
    self.Battle_Skill_2.Common_Key_PC:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Text",
                Text = KeySkill2Name,
            }
        },
        bBattleKey = true
    })
    -- 援护技能
    self.Common_Key_PC:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Text",
                Text = KeySkill3Name,
            }
        },
        bBattleKey = true
    })
    
    -- 轮盘武器
    self.Key_Organ:CreateCommonKey({
        KeyInfoList = {{
            Type = "Text",
            Text = KeyFireName,
        }},
        bBattleKey = true
    })
    -- 坐骑飞行上升
    self.WBP_Key_Mounts01_PC:CreateCommonKey({
        KeyInfoList = {
            {
               Type = "Text",
               Text = KeyMountFlyName,
            }
        },
        Desc = GText("UI_Keyboard_Mount_FlyUp"),
        bBattleKey = true
    })
    -- 坐骑飞行下降
    self.WBP_Key_Mounts02_PC:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Text",
                Text = KeyDownName,
            }
        },
        Desc = GText("UI_Keyboard_Mount_FlyDown"),
        bBattleKey = true
    })
    -- 坐骑长按飞行
    self.WBP_Key_Longpress_PC:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Text",
                Text = KeyMountFlyName,
            }
        },
        Desc = GText("UI_Keyboard_Mount_Fly"),
        bLongPress = true,
        bBattleKey = true
    })
    self.Text_Organ:SetText(GText("UI_Prop_ExploreItem"))
    self.PlayerSpHelpInfo["StartPos"] = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Bar_Shield):GetPosition()
    self.PlayerSpHelpInfo["TotalSize"] = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Image_Energy_Bg):GetSize()
    self.PlayerSpBarWidth = self.PlayerSpHelpInfo["TotalSize"].X
    self.PlayerSpBarHeight = self.PlayerSpHelpInfo["TotalSize"].Y
    
    self.RideFlyHoldTime = DataMgr.PlayerRotationRates["RideFlyHoldTime"] and DataMgr.PlayerRotationRates["RideFlyHoldTime"]["ParamentValue"][1] or 0.5
    self:InitDodgeButtonVariables()
    self:InitMountButtonVariables()
    self:RefreshSkillConfig()
    self:UnEmptyFireSkill()
    self:InitBulletUI()
    if self.OwnerPlayer then
        self.MaxSp = self.OwnerPlayer:GetAttr("MaxSp")
    end
    self:OnUpdateCharSp(nil, nil, OwnerPlayer)
    if not next(self.SkillButtons) then
        self:InitSkillButtons()
    end
    self:InitGamepadButtons()
    self:UpdateSkillPanelInfoInTimer()
    self:AddTimer(0.1, self.UpdateSkillPanelInfoInTimer, true, 0, "UpdateSkillPanelInfoInTimer", false)
end

function WBP_Player_SkillPanel_PC_C:InitSkillButtons()
    self.SkillButtons[ESkillName.Fire] = self.Weapon_Panel
    self.SkillButtons[ESkillName.Skill1] = self.Battle_Skill_1
    self.SkillButtons[ESkillName.Skill2] = self.Battle_Skill_2
    self.SkillButtons[ESkillName.Skill3] = self.Assist_Skill
    self.SkillButtons[ESkillName.Avoid] = self.Dodge_Skill
end

function WBP_Player_SkillPanel_PC_C:InitDodgeButtonVariables()
    self:ListenForInputAction("Avoid", UE4.EInputEvent.IE_Pressed, false, {self, self.OnDodgeActionInput})
    self:DodgeNormalAnim()
    self.DodgeCD = self.OwnerPlayer:GetAttr("AvoidChargeCd") or 0
    self.DodgeChargeTimeRemain = 0
    print(_G.LogTag, "DodgeCount changed:InitDodgeButtonVariables", self.DodgeCD)
    local DodgeCount = self.OwnerPlayer.DodgeCount
    self.MaxAvoidTimes = self.OwnerPlayer:GetAttr("MaxAvoidExecuteTimes")
    self.AvoidRemainTimes = self.MaxAvoidTimes - DodgeCount
    self.Charge_Num:SetText(self.AvoidRemainTimes)
end

function WBP_Player_SkillPanel_PC_C:InitMountButtonVariables()
    self.WS_Operation_PC:SetActiveWidgetIndex(1)
    self.WS_Operation_GamePad:SetActiveWidgetIndex(1)
    self:ListenForInputAction("Jump", UE4.EInputEvent.IE_Pressed, false, {self, self.OnMountFlyPressed})
    self:ListenForInputAction("Jump", UE4.EInputEvent.IE_Released, false, {self, self.OnMountFlyReleased})
    if not self.OwnerPlayer or not self.OwnerPlayer.CurMount then
        if self.Overlay_Mounts:GetVisibility() ~= ESlateVisibility.Collapsed then
            self.Overlay_Mounts:SetVisibility(ESlateVisibility.Collapsed)
        end
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Mounts_Out)
    end
end

function WBP_Player_SkillPanel_PC_C:OnMountFlyPressed()
    if not self.OwnerPlayer.CurMount then
        return
    end
    if self.OwnerPlayer:IsFlying() then
        return
    end
    self.WBP_Key_Longpress_PC:OnButtonPressed(nil, true, 0, self.RideFlyHoldTime - Const.ShortPressThreshold)
    self.WBP_Key_Longpress_GamePad:OnButtonPressed(nil, true, 0, self.RideFlyHoldTime - Const.ShortPressThreshold)
end

function WBP_Player_SkillPanel_PC_C:OnMountFlyReleased()
    if not self.OwnerPlayer.CurMount then
        return
    end
    if self.OwnerPlayer:IsFlying() then
        return
    end
    self.WBP_Key_Longpress_PC:OnButtonReleased()
    self.WBP_Key_Longpress_GamePad:OnButtonReleased()
end

function WBP_Player_SkillPanel_PC_C:InitBulletUI()
    self.Bullet_Num_Zero:SetText(0)
    self.Bullet_Num_Bow_Zero:SetText(0)
end

function WBP_Player_SkillPanel_PC_C:InitGamepadButtons()
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self:ListenForInputAction("GamepadUseSkill", UE4.EInputEvent.IE_Pressed, false, {self, self.OnGamepadUseSkillPressed})
    self:ListenForInputAction("GamepadUseSkill", UE4.EInputEvent.IE_Released, false, {self, self.OnGamepadUseSkillRelease})
    self:SetGamepadIcons()
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:InitGamepadView()
    else
        self:InitKeyboardView()
    end
end

function WBP_Player_SkillPanel_PC_C:SetGamepadIcons()
    local ShootingIcon = UIUtils.GetIconListByActionName("Fire")[1]
    local DodgeIcon = UIUtils.GetIconListByActionName("Avoid")[1]
    local GPUseSkill = UIUtils.GetIconListByActionName("GamepadUseSkill")[1]
    local Skill3Icon = UIUtils.GetIconListByActionName("Skill3")[2]
    local DownIcon = UIUtils.GetIconListByActionName("Slide")[1]
    local MountFlyIcon = UIUtils.GetIconListByActionName("Jump")[1]
    
    self.Key_Weapon:CreateCommonKey({ KeyInfoList = {{Type = "Img", ImgShortPath = ShootingIcon}} })
    self.Key_Organ02:CreateCommonKey({ KeyInfoList = {{Type = "Img", ImgShortPath = ShootingIcon}} })
    self.Key_Dodge:CreateCommonKey({ KeyInfoList = {{Type = "Img", ImgShortPath = DodgeIcon}} })
    self.Key_Skill:CreateCommonKey({ KeyInfoList = {{Type = "Img", ImgShortPath = GPUseSkill}} })
    self.Key_Assist_GamePad:CreateCommonKey({ KeyInfoList = {{Type = "Img", ImgShortPath = Skill3Icon}} })
    self.WBP_Key_Mounts01_Gamepad:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = MountFlyIcon,
            }
        },
        Desc = GText("UI_Keyboard_Mount_FlyUp"),
    })
    self.WBP_Key_Mounts02_Gamepad:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = DownIcon,
            }
        },
        Desc = GText("UI_Keyboard_Mount_FlyDown"),
    })
    self.WBP_Key_Longpress_GamePad:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = MountFlyIcon,
            }
        },
        Desc = GText("UI_Keyboard_Mount_Fly"),
        bLongPress = true,
    })
    self.Battle_Skill_1:SetGamepadIcons()
    self.Battle_Skill_2:SetGamepadIcons()
end

--------------------手柄端部分--------------------------
function WBP_Player_SkillPanel_PC_C:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
    if CurInputType == ECommonInputType.Gamepad then
        self:InitGamepadView()
    else
        self:InitKeyboardView()
    end
end

function WBP_Player_SkillPanel_PC_C:InitGamepadView()
    self.Key_Weapon:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Key_Dodge:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Key_Skill:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WidgetSwitcher_Key:SetActiveWidgetIndex(1)
    self.WidgetSwitcher_Organ:SetActiveWidgetIndex(1)
    self.Switcher_Mount:SetActiveWidgetIndex(1)
    self.Battle_Skill_1.WidgetSwitcher_0:SetActiveWidgetIndex(1)
    self.Battle_Skill_2.WidgetSwitcher_0:SetActiveWidgetIndex(1)
    
end

function WBP_Player_SkillPanel_PC_C:InitKeyboardView()
    self.Key_Weapon:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Key_Dodge:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Key_Skill:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WidgetSwitcher_Key:SetActiveWidgetIndex(0)
    self.WidgetSwitcher_Organ:SetActiveWidgetIndex(0)
    self.Switcher_Mount:SetActiveWidgetIndex(0)
    self.Battle_Skill_1.WidgetSwitcher_0:SetActiveWidgetIndex(0)
    self.Battle_Skill_2.WidgetSwitcher_0:SetActiveWidgetIndex(0)
end

function WBP_Player_SkillPanel_PC_C:OnGamepadUseSkillPressed()
    if EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.GamePad_LB_Out) then
        EMUIAnimationSubsystem:EMStopAnimation(self, self.GamePad_LB_Out)
    end
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.GamePad_LB_In)
    EMUIAnimationSubsystem:EMPlayAnimation(self.Battle_Skill_1, self.Battle_Skill_1.GamePad_LB_In)
    EMUIAnimationSubsystem:EMPlayAnimation(self.Battle_Skill_2, self.Battle_Skill_2.GamePad_LB_In)
end

function WBP_Player_SkillPanel_PC_C:OnGamepadUseSkillRelease()
    if EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.GamePad_LB_In) then
        EMUIAnimationSubsystem:EMStopAnimation(self, self.GamePad_LB_In)
    end
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.GamePad_LB_Out)
    EMUIAnimationSubsystem:EMPlayAnimation(self.Battle_Skill_1, self.Battle_Skill_1.GamePad_LB_Out)
    EMUIAnimationSubsystem:EMPlayAnimation(self.Battle_Skill_2, self.Battle_Skill_2.GamePad_LB_Out)
end
-------------------------------------------------------

function WBP_Player_SkillPanel_PC_C:OnBattlePetInitReady()
    -- 刷新一下援护技能按钮信息
    local BattlePet = self.OwnerPlayer:GetBattlePet()
    if not BattlePet or BattlePet.BattlePetId == 0 then
        self:EmptySkill3()
        DebugPrint("BattlePet为空!!!")
        return
    end
    
    self:RefreshSupportSkillIcon()
    if not self.OwnerPlayer:CheckSkillInActive(ESkillName.Skill3) then
        self:UnEmptySkill3()
    end
end

function WBP_Player_SkillPanel_PC_C:RefreshSupportSkillIcon()
    local BattlePet = self.OwnerPlayer:GetBattlePet()
    if not BattlePet or BattlePet.BattlePetId == 0 then
        self:EmptySkill3()
        DebugPrint("BattlePet为空!!!")
        return
    end
    local SupportSKillId = DataMgr.BattlePet[BattlePet.BattlePetId].SupportSkillId
    --local SupportSKillId = RoleChar:GetSkillByType(UE.ESkillType.Support)
    self.SupportSkillId = SupportSKillId
    if not SupportSKillId then
        DebugPrint("SupportSKillId为空", SupportSKillId)
        return
    end
    local SupportSKillBaseConfig = DataMgr.Skill[SupportSKillId][1][0]
    if SupportSKillBaseConfig.SkillBtnIcon then
        local Path = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Skill/T_"..SupportSKillBaseConfig.SkillBtnIcon
        self.LoadingIconMap[SupportSKillBaseConfig.SkillBtnIcon] = IconLoadingType.SupportSkill
        self.SupportPath = Path
        if self.OwnerPlayer.ActivePropEffectId == -1 then
            UE.UResourceLibrary.LoadObjectAsync(self,Path,{self,WBP_Player_SkillPanel_PC_C.OnIconLoadFinish})
        end
    end
    if (SupportSKillBaseConfig.SkillBtnDesc ~= nil) then
        self.Assist_Skill_Text:SetText(GText(SupportSKillBaseConfig.SkillBtnDesc))
    end
    self:ListenForInputAction("Skill3", UE4.EInputEvent.IE_Released, false, {self, self.OnSupportSkillActionInput})

end

function WBP_Player_SkillPanel_PC_C:GetSkillActiveInfo()
    -- 获取当前技能激活信息
    local PlayerController = nil
    if self.OwnerPlayer and self.OwnerPlayer.GetController then
        PlayerController = self.OwnerPlayer:GetController()
    end
    if PlayerController then
        local len = PlayerController.CurrentInActiveSkills:Length()
        local TempButtons = self.SkillButtons
        for i=1,len do
            self:ChangeSkillButtonState(PlayerController.CurrentInActiveSkills[i], "Lock")
            TempButtons[PlayerController.CurrentInActiveSkills[i]] = nil
        end
        for Id,_ in pairs(TempButtons) do
            self:ChangeSkillButtonState(Id, "UnLock")
        end
    end
end

function WBP_Player_SkillPanel_PC_C:ChangeSkillButtonState(SkillEnumId, StateName)
    if not self.SkillButtons then
        print(_G.LogTag, "can not get skill buttons array")
        return
    end
    if not next(self.SkillButtons) then
        self:InitSkillButtons()
    end
    if not self.SkillButtons[SkillEnumId] then
        print(_G.LogTag, "widget dont have this button")
        return
    end
    if (type(self.SkillButtons[SkillEnumId].SetButtonStyleByState) == "function") then
        self.SkillButtons[SkillEnumId]:SetButtonStyleByState(SkillEnumId, StateName)
    else
        if (SkillEnumId == ESkillName.Skill3) then
            -- 援护技能
            if (StateName == "Empty") then
                self.SupportSkillState = "Lock"
                self:EmptySkill3()
            elseif (StateName == "UnEmpty") then
                self.SupportSkillState = "UnLock"
                self:UnEmptySkill3()
            end
            if self.bSupportSkillUnlock == false then
                return
            end
            if (StateName == "Lock") then
                self.SupportSkillState = "Lock"
                if (not self:IsAnimationPlaying(self.Lock_In)) then
                    self:PlayAnimationForward(self.Lock_In)
                end
            elseif (StateName == "Ban" and self.bSupportSkillUnlock == true) then
                self.SupportSkillState = "Lock"
                EMUIAnimationSubsystem:EMPlayAnimation(self, self.Assist_Ban)
            elseif (StateName == "UnBan" and self.bSupportSkillUnlock == true) then
                self.SupportSkillState = "UnLock"
                EMUIAnimationSubsystem:EMPlayAnimation(self,self.Assist_Normal)
            elseif (StateName == "UnLock" and self.bSupportSkillUnlock == true) then
                self.SupportSkillState = "UnLock"
                if (not self:IsAnimationPlaying(self.UnLock)) then
                    self:PlayAnimationForward(self.UnLock)
                end
            elseif (StateName == "Hooking" or StateName == "RegionBan") then
                self.SupportSkillState = "TempBan"
                self.Assist_Skill:SetRenderOpacity(0.6)
            elseif (StateName == "EndHooking" or StateName == "RegionUnBan") then
                self.SupportSkillState = "UnLock"
                self.Assist_Skill:SetRenderOpacity(1)
            end
        else
            if (StateName == "Lock") then
                self.SkillButtons[SkillEnumId]:SetVisibility(UE4.ESlateVisibility.Collapsed)
            elseif (StateName == "UnLock") then
                self.SkillButtons[SkillEnumId]:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            elseif (StateName == "Ban") then
                if (SkillEnumId == ESkillName.Avoid) then
                    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Dodge_Ban)
                elseif (SkillEnumId == ESkillName.Fire) then
                    self:PlayAnimationForward(self.Weapon_Ban)
                end
            elseif (StateName == "UnBan") then
                if (SkillEnumId == ESkillName.Avoid) then
                    self:DodgeNormalAnim()
                elseif (SkillEnumId == ESkillName.Fire) then
                    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Weapon_Normal)
                end
            elseif (StateName == "Empty" and SkillEnumId == ESkillName.Fire) then
                self:EmptyFireSkill()
            elseif (StateName == "UnEmpty" and SkillEnumId == ESkillName.Fire) then
                self:UnEmptyFireSkill()
            elseif (StateName == "Hooking" or StateName == "RegionBan") then
                if self.SkillButtons[SkillEnumId] then
                    self.SkillButtons[SkillEnumId]:SetRenderOpacity(0.6)
                end
            elseif (StateName == "EndHooking" or StateName == "RegionUnBan") then
                if self.SkillButtons[SkillEnumId] then
                    self.SkillButtons[SkillEnumId]:SetRenderOpacity(1)
                end
            end
        end
    end
end

function WBP_Player_SkillPanel_PC_C:ChangeState(State)
    -- 切换技能面板状态
    if (self.CurState ~= State) then
        self.CurState = State
        self:RefreshUIStyleByState(false)
    end
end

function WBP_Player_SkillPanel_PC_C:EmptySkill3()
    self.Switcher_Skill03:SetActiveWidgetIndex(1)
    self.Image_2:SetBrushTintColor(UE4.UUIFunctionLibrary.GetSlateColorByRGBA(0,0,0,0.2))
end

function WBP_Player_SkillPanel_PC_C:UnEmptySkill3()
    self.Assist_Skill:SetRenderOpacity(1)
    self.Switcher_Skill03:SetActiveWidgetIndex(0)
    self.Image_2:SetBrushTintColor(UE4.UUIFunctionLibrary.GetSlateColorByRGBA(0,0,0,0.55))
end

function WBP_Player_SkillPanel_PC_C:EmptyFireSkill()
    self.Switcher_Weapon_Skill:SetActiveWidgetIndex(1)
    self.Bg01:SetBrushTintColor(UE4.UUIFunctionLibrary.GetSlateColorByRGBA(0,0,0,0.2))
end

function WBP_Player_SkillPanel_PC_C:UnEmptyFireSkill()
    self.Switcher_Weapon_Skill:SetActiveWidgetIndex(0)
    self.Bg01:SetBrushTintColor(UE4.UUIFunctionLibrary.GetSlateColorByRGBA(0,0,0,0.55))
end

function WBP_Player_SkillPanel_PC_C:RefreshSkillConfig()
    -- 刷新技能配置相关信息
    self:ListenForInputAction("Fire", UE4.EInputEvent.IE_Pressed, false, {self, self.OnFireActionInputPressed})
    local RangedWeapon = self.OwnerPlayer.RangedWeapon
    if (IsValid(RangedWeapon)) then
        self:RefreshWeaponIcon()
    end
    self:RefreshRoleSkillButton()
    self.PlayerMainRoleId = self:GetPlayerRoleId()
    self:RefreshUIStyleByState(true)
end

function WBP_Player_SkillPanel_PC_C:RefreshWeaponIcon()
    local RangedWeapon
    local WeaponId
    -- 判断是否在用远程的显赫武器
    if (self.OwnerPlayer.BuffManager.UseSummonWeapon ~= -1) then
        WeaponId = self.OwnerPlayer.UltraWeapon.WeaponId
        local WeaponTags = DataMgr.BattleWeapon[WeaponId].WeaponTag
        if (CommonUtils.HasValue(WeaponTags, "Ranged")) then
            RangedWeapon = self.OwnerPlayer.UltraWeapon
        else
            RangedWeapon = self.OwnerPlayer.RangedWeapon
        end
    else
        RangedWeapon = self.OwnerPlayer.RangedWeapon
    end
    if (not IsValid(RangedWeapon)) then
        return
    end
    self.RangedWeapon = RangedWeapon
    self.WeaponId = RangedWeapon.WeaponId
    self.MagazineUIType = DataMgr.BattleWeapon[self.WeaponId].MagazineUIType
    if self.MagazineUIType == "NoMagazine" then
        self.Bullet_Bow:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Group_AmmunitionNum:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.Bullet_Bow:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Group_AmmunitionNum:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    self.IsRefreshWeapon = true
    local BulletIcon = DataMgr.BattleWeapon[self.WeaponId].BulletIcon
    local BulletIconObj
    local BulletIconPath
    if BulletIcon then
        BulletIconPath = "/Game/UI/Texture/Dynamic/Atlas/Battle/T_"..BulletIcon
        self.LoadingIconMap[BulletIcon] = IconLoadingType.BulletIcon
        -- self.Bullet:SetBrushResourceObject(BulletIconObj)
    else
        BulletIconPath = "/Game/UI/Texture/Dynamic/Atlas/Battle/T_Battle_Bullet"
        self.LoadingIconMap["T_Battle_Bullet"] = IconLoadingType.BulletIcon
        -- self.Bullet:SetBrushResourceObject(BulletIconObj)
    end

    UE.UResourceLibrary.LoadObjectAsync(self,BulletIconPath,{self,WBP_Player_SkillPanel_PC_C.OnIconLoadFinish})

    self:UpdatePlayerWeaponInfo()
    local BattleWeaponConfig = DataMgr.BattleWeapon[self.WeaponId]

    local WeaponHUDIcon = nil
    if (BattleWeaponConfig ~= nil and BattleWeaponConfig.WeaponHUDIcon ~= nil) then
        WeaponHUDIcon = "/Game/UI/Texture/Dynamic/Atlas/Battle/Weapon/T_"..BattleWeaponConfig.WeaponHUDIcon
        self.LoadingIconMap[BattleWeaponConfig.WeaponHUDIcon] = IconLoadingType.WeaponIcon
    else
        WeaponHUDIcon = "/Game/UI/Texture/Dynamic/Atlas/Battle/Weapon/T_Crossbow_Chixing.T_Crossbow_Chixing"
        self.LoadingIconMap["Skill_Crossbow_Chixing"] = IconLoadingType.WeaponIcon
    end
    self.LoadWeaponIconID = nil
    local Handle = UE.UResourceLibrary.LoadObjectAsyncWithId(self,WeaponHUDIcon,{self,WBP_Player_SkillPanel_PC_C.OnIconLoadFinishWithId})
    if Handle then
        self.LoadWeaponIconID = Handle.ResourceID
    end
    
    -- 刷新信息也需要刷新武器Icon的透明度
    if (not self:IsWeaponBulletNotEnough(RangedWeapon)) then
        self.Weapon_Icon:SetRenderOpacity(1.0)
    else
        self.Weapon_Icon:SetRenderOpacity(0.5)
    end
end

function WBP_Player_SkillPanel_PC_C:RefreshRoleSkillButton()
    -- 设置角色技能相关信息
    if (not IsValid(self.OwnerPlayer)) then
        self.OwnerPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    end
    local SkillId1 = self.OwnerPlayer:GetSkillByType(UE.ESkillType.Skill1)
    DebugPrint("gmy@WBP_Player_SkillPanel_PC_C WBP_Player_SkillPanel_PC_C:RefreshRoleSkillButton", UE.ESkillType.Skill1, SkillId1)
    local Skill1 = self.OwnerPlayer:GetSkill(SkillId1)
    self.Battle_Skill_1:RefreshButtonStyle("Skill1", Skill1, ESkillName.Skill1, self.OwnerPlayer)

    local SkillId2 = self.OwnerPlayer:GetSkillByType(UE.ESkillType.Skill2)
    local Skill2 = self.OwnerPlayer:GetSkill(SkillId2)
    self.Battle_Skill_2:RefreshButtonStyle("Skill2", Skill2, ESkillName.Skill2, self.OwnerPlayer)
end

function WBP_Player_SkillPanel_PC_C:RefreshRoleTargetSkill(SkillName, Skill)
    if (SkillName == "Skill1") then
        local SkillId1 = self.OwnerPlayer:GetSkillByType(UE.ESkillType.Skill1)
        local Skill1 = self.OwnerPlayer:GetSkill(SkillId1)
        self.Battle_Skill_1:RefreshButtonStyle("Skill1", Skill1, ESkillName.Skill1, self.OwnerPlayer)
    elseif (SkillName == "Skill2") then
        local SkillId2 = self.OwnerPlayer:GetSkillByType(UE.ESkillType.Skill2)
        local Skill2 = self.OwnerPlayer:GetSkill(SkillId2)
        self.Battle_Skill_2:RefreshButtonStyle("Skill2", Skill2, ESkillName.Skill2, self.OwnerPlayer)
    end
end

function WBP_Player_SkillPanel_PC_C:RefreshKeyName()
    local KeyName1 = CommonUtils:GetActionMappingKeyName("Skill1")
    local KeyName2 = CommonUtils:GetActionMappingKeyName("Skill2")
    local KeyName3 = CommonUtils:GetActionMappingKeyName("Skill3")
    self.Battle_Skill_1.Common_Key_PC:SetImage("Text", KeyName1)
    self.Battle_Skill_2.Common_Key_PC:SetImage("Text", KeyName2)
    self.Common_Key_PC:SetImage("Text", KeyName3)
end

-- 现在主城里也显示全部的技能,暂时没区分CurState
function WBP_Player_SkillPanel_PC_C:RefreshUIStyleByState(IsNeedRefreshState)
    -- 根据当前技能面板状态刷新样式
    if (IsNeedRefreshState) then
        self.CurState = "Battle"
    end
    if (self.CurState ~= "Battle" and self.CurState ~= "Normal") then
        self.Assist_Skill:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function WBP_Player_SkillPanel_PC_C:GetOwnerPlayer()
    if (not IsValid(self.OwnerPlayer)) then
        self.OwnerPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    end
    return self.OwnerPlayer
end

-----------------技能面板刷新相关-------------------
function WBP_Player_SkillPanel_PC_C:UpdateSkillPanelInfoInTimer()
    if (not IsValid(self.OwnerPlayer)) then
        self.OwnerPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    end
    if not self.OwnerPlayer then
        return
    end
    -- 检查是否在这一帧已经update过了，没更新过才执行逻辑
    if not self.OwnerPlayer.IsUpdatedUIInThisTick then
        self:UpdatePlayerExclusiveSkill()
        self:UpdatePlayerSupportSkill()
        self:UpdatePlayerDodgeSkill()
        self.IsCharacterInFalling = self.OwnerPlayer:CharacterInTag("Falling")
        self.OwnerPlayer.IsUpdatedUIInThisTick = true
    end
end

function WBP_Player_SkillPanel_PC_C:UpdatePlayerWeaponInfo()
    self:UpdateBulletInfo(self.RangedWeapon)
end

function WBP_Player_SkillPanel_PC_C:UpdateBulletInfo(RangedWeapon)
    --local MagazineUIType = DataMgr.BattleWeapon[RangedWeapon.WeaponId].MagazineUIType
    local MagazineBulletNum = RangedWeapon:GetAttr("MagazineBulletNum")
    local BulletNum = RangedWeapon:GetAttr("BulletNum")
    local TotalBulletNum = MagazineBulletNum + BulletNum
    if MagazineBulletNum == -1 then
        MagazineBulletNum = self.InfinitySymbol
    end
    if BulletNum == -1 then
        BulletNum = self.InfinitySymbol
    end
    if TotalBulletNum == -2 then
        TotalBulletNum = self.InfinitySymbol
    end

    if self.MagazineUIType == "NoMagazine" then -- 无弹匣武器逻辑
        self.Bullet_Num_Bow:SetText(tostring(TotalBulletNum))
        if (type(TotalBulletNum) == "number" and TotalBulletNum <= 0) then
            if self.IsRefreshWeapon or not self.IsLackMagazine then
                self.Bullet_Num_Bow:SetVisibility(UE4.ESlateVisibility.Collapsed)
                self.Bullet_Num_Bow_Zero:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                self.IsLackMagazine = true
                self.IsRefreshWeapon = false
            end
            if not self.IsLackBullets then
                self.Weapon_Icon:SetRenderOpacity(0.5)
                EMUIAnimationSubsystem:EMPlayAnimation(self, self.Bullets_Lack)
                self.IsLackBullets = true
            end
        else
            if self.IsRefreshWeapon or self.IsLackMagazine then
                self.Bullet_Num_Bow:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                self.Bullet_Num_Bow_Zero:SetVisibility(UE4.ESlateVisibility.Collapsed)
                self.IsLackMagazine = false
                self.IsRefreshWeapon = false
            end
            if self.IsLackBullets then
                self.Weapon_Icon:SetRenderOpacity(1.0)
                EMUIAnimationSubsystem:EMPlayAnimation(self, self.Bullets_Lack, 1)
                self.IsLackBullets = false
            end
        end
    else -- 有弹匣武器逻辑
        self.Bullet_Num:SetText(tostring(MagazineBulletNum))
        self.Clipsize:SetText(tostring(BulletNum))
        if (type(MagazineBulletNum) == "number" and MagazineBulletNum <= 0) then
            if self.IsRefreshWeapon or not self.IsLackMagazine then
                self.Bullet_Num:SetVisibility(UE4.ESlateVisibility.Collapsed)
                self.Bullet_Num_Zero:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                self.IsLackMagazine = true
                self.IsRefreshWeapon = false
            end
        else
            if self.IsRefreshWeapon or self.IsLackMagazine then
                self.Bullet_Num:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                self.Bullet_Num_Zero:SetVisibility(UE4.ESlateVisibility.Collapsed)
                self.IsRefreshWeapon = false
                self.IsLackMagazine = false
            end
        end
        if (type(MagazineBulletNum) == "number" and type(BulletNum) == "number" and
                MagazineBulletNum <= 0 and BulletNum <= 0) then
            if not self.IsLackBullets then
                self.Weapon_Icon:SetRenderOpacity(0.5)
                EMUIAnimationSubsystem:EMPlayAnimation(self, self.Bullets_Lack)
                self.IsLackBullets = true
            end
        else
            if self.IsLackBullets then
                self.Weapon_Icon:SetRenderOpacity(1.0)
                EMUIAnimationSubsystem:EMPlayAnimation(self, self.Bullets_Lack, 1)
                self.IsLackBullets = false
            end
        end
    end
end

function WBP_Player_SkillPanel_PC_C:UpdatePlayerExclusiveSkill()
    -- 刷新角色的专属技能
    -- 技能1
    self.Battle_Skill_1:RefreshSkillStyleInTimer("Skill1")
    -- 技能2
    self.Battle_Skill_2:RefreshSkillStyleInTimer("Skill2")
end

function WBP_Player_SkillPanel_PC_C:UpdatePlayerSupportSkill()
    if (not IsValid(self.OwnerPlayer) or self.SupportSkillState == "Lock" or self.bSupportSkillUnlock == false) then
        return
    end
    if self.OwnerPlayer.ActivePropEffectId ~= -1 then
        return -- 使用道具期间停止更新
    end
    -- 刷新援护技能CD状态相关
    local Skill3CdTime, Skill3CdPercent = self.OwnerPlayer:GetSkillCdTimeAndPercent(self.SupportSkillId)
    if (Skill3CdTime > 0) then
        self.SupportSkillState = "InCDTime"
        self.Assist_Text_CD:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Assist_Text_CD:SetText(self:GetPreciseDecimal(Skill3CdTime, 1))
        self.Assist_Bar_Skill_CD:SetPercent(1 - Skill3CdPercent)
    else
        if (self.SupportSkillState == "InCDTime") then
            self.SupportSkillState = "UnLock"
        end
    end
    if self.SupportSkillState == "TempBan" then
        return
    end
    self:HandleSupportButtonState()
end

function WBP_Player_SkillPanel_PC_C:HandleSupportButtonState()
    if (self.LastSupportSkillState ~= self.SupportSkillState) then
        if (self.SupportSkillState == "InCDTime") then
            self.Assist_Skill_Icon:SetRenderOpacity(0.5)
            self.Assist_Text_CD:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else
            if (self.SupportSkillState == "UnLock") then
                -- CD转好了，而且可以释放技能      
                if (not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Skill_Complete)) then
                    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Skill_Complete)
                end
            end
            self.Assist_Skill_Icon:SetRenderOpacity(1.0)
            self.Assist_Bar_Skill_CD:SetPercent(0.0)
            self.Assist_Text_CD:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
    self.LastSupportSkillState = self.SupportSkillState
end

function WBP_Player_SkillPanel_PC_C:UpdatePlayerDodgeSkill()
    if (self.Dodge_Skill:GetVisibility() == ESlateVisibility.Collapsed or not IsValid(self.OwnerPlayer)) then
        return
    end
    self.MaxAvoidTimes = self.OwnerPlayer:GetAttr("MaxAvoidExecuteTimes")
    self.DodgeCD = self.OwnerPlayer:GetAttr("AvoidChargeCd") or 0
    local DodgeCount = self.OwnerPlayer.DodgeCount
    local AvoidRemainTimes = math.max(0, self.MaxAvoidTimes - DodgeCount)
    local Now = UE4.UGameplayStatics.GetTimeSeconds(self)
    if (AvoidRemainTimes ~= self.MaxAvoidTimes) then
        self.DodgeChargeTimeRemain = self.OwnerPlayer:GetDodgeChargeRemainTime()
        local Percent = (self.DodgeChargeTimeRemain) / self.DodgeCD
        -- print(_G.LogTag, "DodgeCount changed, Charges:", AvoidRemainTimes, Now, self.DodgeChargeTimeRemain)
        self.Dodge_Bar_Skill_CD:SetPercent(Percent)
    else
        self.DodgeChargeTimeRemain = 0
        self.Dodge_Bar_Skill_CD:SetPercent(0)
    end
    -- 次数发生变化才SetText，播放动效
    if (self.AvoidRemainTimes ~= AvoidRemainTimes) then
        print(_G.LogTag, "DodgeCount changed, AvoidRemainTimes:", AvoidRemainTimes, Now,self.DodgeChargeTimeRemain)
        self.Charge_Num:SetText(AvoidRemainTimes)
        if (AvoidRemainTimes == 0) then
            self:DodgeForbidAnim()
        else
            self:DodgeNormalAnim()
        end
    end
    if (self.AvoidRemainTimes < AvoidRemainTimes) then
        self:PlayAnimation(self.Dodge_Complete)
    end
    self.AvoidRemainTimes = AvoidRemainTimes
end

function WBP_Player_SkillPanel_PC_C:OnSupportSkillActionInput()
    if (self.SupportSkillState == "Lock") then
        return
    end
    if (self.SupportSkillState == "InCDTime") then
        -- 援护技能CD中
        if (not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Skills_Disable)) then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Skills_Disable)
        end
    elseif (self.SupportSkillState == "UnLock") then
        -- 正常使用
        if (not EMUIAnimationSubsystem:EMAnimationIsPlaying(self,self.Click)) then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
        end
    end
end

function WBP_Player_SkillPanel_PC_C:OnDodgeActionInput()
    if self.AvoidRemainTimes > 0 then
        if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Dodge_Click) then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Dodge_Click)
        end
    else
        if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Dodge_Disable) then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Dodge_Disable)
        end
    end
end

function WBP_Player_SkillPanel_PC_C:OnUpdateMaxSp(NewMaxSp)
    if not NewMaxSp then return end
    DebugPrint("@zyh 最新MaxSp更新为", NewMaxSp)
    self.MaxSp = NewMaxSp
    local SpPercent = math.min(math.max(self.NowSp / self.MaxSp,0), 1)
    self.MyFVector2D.X = self.PlayerSpBarWidth * SpPercent
    self.MyFVector2D.Y = self.PlayerSpBarHeight
    local BarSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Bar_Shield)
    BarSlot:SetSize(self.MyFVector2D)
end

function WBP_Player_SkillPanel_PC_C:OnUpdateCharSp(NowSp, OldSp, Owner)
    -- 更新角色能量值
    if (not IsValid(self.OwnerPlayer)) then
        return
    end
    if not Owner or Owner ~= self.OwnerPlayer then
        -- 部分UpdateMainPlayerSp事件是由服务端通知客户端的，因此联机下需要区分是否是自己的客户端
        return
    end
    local ChangeSp
    if not self.MaxSp then
        self.MaxSp = self.OwnerPlayer:GetAttr("MaxSp")
    end
    if not NowSp then
        NowSp = self.OwnerPlayer:GetAttr("Sp")
    else
        ChangeSp = NowSp - OldSp -- 传NowSp就一定会传OldSp
    end
    self.NowSp = NowSp
    self.Battle_Skill_1:UpdateCharSpInfo("Skill1", NowSp)
    self.Battle_Skill_2:UpdateCharSpInfo("Skill2", NowSp)

    self.Energy_Num:SetText(math.floor(NowSp))
    -- self.Num_Energy_Upperlimit:SetText('/'..math.floor(MaxSp))
    local SpPercent = math.min(math.max(NowSp / self.MaxSp,0), 1)
    self.MyFVector2D.X = self.PlayerSpBarWidth * SpPercent
    self.MyFVector2D.Y = self.PlayerSpBarHeight
    local BarSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Bar_Shield)
    BarSlot:SetSize(self.MyFVector2D)
    if (ChangeSp ~= nil and ChangeSp ~= 0) then
        local ReduceSpPercent = math.min(ChangeSp / self.MaxSp, 1.0)
        self.MyFVector2D.X = ReduceSpPercent
        self.MyFVector2D.Y = 1.0
        self.Panel_Deduct:SetRenderScale(self.MyFVector2D)
        
        self.MyFVector2D.X = self.PlayerSpBarWidth * (SpPercent - ReduceSpPercent)
        self.MyFVector2D.Y = 0
        self.Panel_Deduct:SetRenderTranslation(self.MyFVector2D)
        
        if (ReduceSpPercent < 0) then
            self.Deduct:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToLinearColor("FF46467F"))
        else
            self.Deduct:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToLinearColor("FFE08066"))
        end
        if (not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Deduct_MP)) then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Deduct_MP)
        end
        self.Deduct:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
end

function WBP_Player_SkillPanel_PC_C:OnUpdateSkillEfficiency(Owner)
    if (not IsValid(self.OwnerPlayer)) then
        return
    end
    if not Owner or Owner ~= self.OwnerPlayer then
        -- 部分UpdateSkillEfficiency事件是由服务端通知客户端的，因此联机下需要区分是否是自己的客户端
        return
    end
    DebugPrint("@zyh 刷新技能的显示蓝耗")
    local NowSp = self.OwnerPlayer:GetAttr("Sp")
    self.Battle_Skill_1:UpdateSkillEfficiency("Skill1", NowSp)
    self.Battle_Skill_2:UpdateSkillEfficiency("Skill2", NowSp)
end

function WBP_Player_SkillPanel_PC_C:OnUpdateBuffSpModify()
    if (not IsValid(self.OwnerPlayer)) then
        return
    end
    local NowSp = self.OwnerPlayer:GetAttr("Sp")
    self.Battle_Skill_1:UpdateBuffSpModify("Skill1", NowSp)
    self.Battle_Skill_2:UpdateBuffSpModify("Skill2", NowSp)
    
end

function WBP_Player_SkillPanel_PC_C:PlayAddSpAnim(TargetEid)
    local Target = Battle(self):GetEntity(TargetEid)
    if Target ~= self.OwnerPlayer then
        return
    end
    if EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Energy_Return) then
        return
    end
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Energy_Return)
end

function WBP_Player_SkillPanel_PC_C:OnWeaponBulletNotEnough()
    local RangedWeapon
    -- 判断是否在用远程的显赫武器
    if (self.OwnerPlayer.BuffManager.UseSummonWeapon ~= -1) then
        local WeaponId = self.OwnerPlayer.UltraWeapon.WeaponId
        local WeaponTags = DataMgr.BattleWeapon[WeaponId].WeaponTag
        if (CommonUtils.HasValue(WeaponTags, "Ranged")) then
            RangedWeapon = self.OwnerPlayer.UltraWeapon
        else
            RangedWeapon = self.OwnerPlayer.RangedWeapon
        end
    else
        RangedWeapon = self.OwnerPlayer.RangedWeapon
    end
    if (not IsValid(RangedWeapon)) then
        return
    end
    local MagazineBulletNum = RangedWeapon:GetAttr("MagazineBulletNum")
    local BulletNum = RangedWeapon:GetAttr("BulletNum")
    self.Bullet_Num:SetText(tostring(MagazineBulletNum))
    self.Clipsize:SetText(tostring(BulletNum))
    if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.No_BulletsBackup) then
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.No_BulletsBackup)
    end
    if (self:IsWeaponBulletNotEnough(RangedWeapon)) then
        -- 真的缺弹了（总弹药不够）
        if (self.Bullet_Num_Zero:IsVisible() and not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.No_Bullets)) then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.No_Bullets)
        end
        self.Weapon_Icon:SetRenderOpacity(0.5)
    end
end

function WBP_Player_SkillPanel_PC_C:OnChargeWeaponBullet()
    self:UpdatePlayerWeaponInfo()
end

function WBP_Player_SkillPanel_PC_C:IsWeaponBulletNotEnough(RangedWeapon)
    local Skill = nil
    if (IsValid(self.OwnerPlayer)) then
        local SkillId = self.OwnerPlayer:GetSkillByType(UE.ESkillType.Shooting)
        Skill = self.OwnerPlayer:GetSkill(SkillId)
    end
    if not RangedWeapon then
        RangedWeapon = self.OwnerPlayer.RangedWeapon
    end
    if (IsValid(RangedWeapon)) then
        if (Skill ~= nil) then
            local SkillNodeId = Skill.BeginNodeId
            local SkillNodeConfig = DataMgr.SkillNode[SkillNodeId]
            if not SkillNodeConfig then
                return false
            end
            return not RangedWeapon:IsAllBulletEnough(SkillNodeConfig.CostBullet or 0)
        end
        return not RangedWeapon:IsAllBulletEnough(0)
    end
    return false
end
-----------------监听按键输入相关----------------------
function WBP_Player_SkillPanel_PC_C:OnFireActionInputPressed()
    -- 按下射击时如果正在换弹，播放动画
    if self.OwnerPlayer.CurrentSkillId == self.OwnerPlayer:GetSkillByType(UE.ESkillType.Reload) and not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.No_Bullets) then
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.No_Bullets)
    end
end

function WBP_Player_SkillPanel_PC_C:GetPlayerRoleId()
    if (not IsValid(self.OwnerPlayer)) then
        self.OwnerPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    end
    if (self.OwnerPlayer ~= nil) then
        if (self.OwnerPlayer.CurrentRoleId ~= nil) then
            return self.OwnerPlayer.CurrentRoleId
        elseif (self.OwnerPlayer.PreRoleId ~= nil and self.OwnerPlayer.PreRoleId ~= 0) then
            return self.OwnerPlayer.PreRoleId
        else
            local Controller = self.OwnerPlayer:GetController()
            return Controller:GetRoleId()
        end
    end
end

function WBP_Player_SkillPanel_PC_C:OnSwitchRole()
    self.PlayerMainRoleId = self:GetPlayerRoleId()
    if(self.PlayerMainRoleId)then
        self:RefreshSkillConfig()
        self:OnUpdateCharSp(nil, nil, self:GetOwnerPlayer())
        self:ClearRemainAnim()
    end
end

function WBP_Player_SkillPanel_PC_C:OnSwitchPet()
    self:RefreshSupportSkillIcon()
end

function WBP_Player_SkillPanel_PC_C:OnSkillInfosRep(Character)
    if not self.OwnerPlayer or self.OwnerPlayer ~= Character then
        return
    end
    self:RefreshSkillConfig()
end

function WBP_Player_SkillPanel_PC_C:OnSkill1InAirChanged(IsInAir)
    self.Battle_Skill_1:ChangeIsInAir(IsInAir)
end

function WBP_Player_SkillPanel_PC_C:OnSkill2InAirChanged(IsInAir)
    self.Battle_Skill_2:ChangeIsInAir(IsInAir)
end

-- 使用UIUnlockRule表决定的禁用，优先级高于InActiveSkill
function WBP_Player_SkillPanel_PC_C:InitSupportSkill()
    self.bSupportSkillUnlock = false
    local Avatar = GWorld:GetAvatar()
    local UIUnlockRule = DataMgr.UIUnlockRule
    self.SupportUIUnlockRuleId = UIUnlockRule.PetSkill.UIUnlockRuleId
    if Avatar then
        self.bSupportSkillUnlock = Avatar:CheckUIUnlocked(self.SupportUIUnlockRuleId)
        if not self.bSupportSkillUnlock then
            if (not self:IsAnimationPlaying(self.Lock_In)) then
                self:PlayAnimationForward(self.Lock_In)
            end
            self.SupportUnlockKey = Avatar:BindOnUIFirstTimeUnlock(self.SupportUIUnlockRuleId, function()
                self.bSupportSkillUnlock = true
                self:ChangeSkillButtonState(ESkillName.Skill3, "UnLock")
            end)
        else
            self:EmptySkill3()
        end
    end
end

function WBP_Player_SkillPanel_PC_C:PlayGuideRemind(SkillName)
    local BattleSkill
    if SkillName == "Skill1" then
        BattleSkill = self.Battle_Skill_1
    elseif SkillName == "Skill2" then
        BattleSkill = self.Battle_Skill_2
    end
    if BattleSkill then
        if EMUIAnimationSubsystem:EMAnimationIsPlaying(BattleSkill, BattleSkill.Guide_Remind) then
            EMUIAnimationSubsystem:EMStopAnimation(BattleSkill, BattleSkill.Guide_Remind)
        end
        EMUIAnimationSubsystem:EMPlayAnimation(BattleSkill, BattleSkill.Guide_Remind)
    end
end

function WBP_Player_SkillPanel_PC_C:StopGuideRemind(SkillName)
    local BattleSkill
    if SkillName == "Skill1" then
        BattleSkill = self.Battle_Skill_1
    elseif SkillName == "Skill2" then
        BattleSkill = self.Battle_Skill_2
    end
    if BattleSkill then
        if EMUIAnimationSubsystem:EMAnimationIsPlaying(BattleSkill, BattleSkill.Guide_Remind) then
            EMUIAnimationSubsystem:EMStopAnimation(BattleSkill, BattleSkill.Guide_Remind)
        end
        EMUIAnimationSubsystem:EMPlayAnimation(BattleSkill, BattleSkill.Guide_Remind, 1)
    end
end

function WBP_Player_SkillPanel_PC_C:ClearRemainAnim()
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Deduct_MP)
    if self.VX_RotLine:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
        if (not self:IsAnimationPlaying(self.UnLock)) then
            self:PlayAnimationForward(self.UnLock)
        end
    end
    if self.VX_CompleteGlow:GetVisibility() == ESlateVisibility.HitTestInvisible then
        if (not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Skill_Complete)) then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Skill_Complete)
        end
    end
    if self.Image_BanWeaponSkill:GetVisibility() ~= ESlateVisibility.Collapsed then
        if self.OwnerPlayer and self.OwnerPlayer.ActivePropEffectId == -1 then
            self:OnPropEffectEndReplaceSkill(ESkillName.Fire)
        end
    end
    if self.Overlay_Mounts:GetVisibility() == ESlateVisibility.SelfHitTestInvisible and self.OwnerPlayer
        and not self.OwnerPlayer.CurMount then
        self.Overlay_Mounts:SetVisibility(ESlateVisibility.Collapsed)
        
    end
end

function WBP_Player_SkillPanel_PC_C:OnPropEffectReplaceSkill(SkillName, PropEffectId)
    if SkillName == ESkillName.Fire then
        self.Overlay_Organ:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        EMUIAnimationSubsystem:EMStopAnimation(self, self.Weapon_Normal)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Weapon_Ban)
    elseif SkillName == ESkillName.Skill3 then
        self.Assist_Text_CD:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Assist_Bar_Skill_CD:SetPercent(0)
        self.Assist_Skill_Icon:SetRenderOpacity(1.0)
        local ReplaceIconPath = DataMgr.PropEffect[PropEffectId].ReplaceSupportIconPath
        UE.UResourceLibrary.LoadObjectAsync(self,ReplaceIconPath,{self,WBP_Player_SkillPanel_PC_C.OnSupportIconLoadFinish})
    end
end

function WBP_Player_SkillPanel_PC_C:OnPropEffectEndReplaceSkill(SkillName)
    if SkillName == ESkillName.Fire then
        self.Overlay_Organ:SetVisibility(ESlateVisibility.Collapsed)
        EMUIAnimationSubsystem:EMStopAnimation(self, self.Weapon_Ban)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Weapon_Normal)
    elseif SkillName == ESkillName.Skill3 then
        self.LastSupportSkillState = nil
        self:HandleSupportButtonState() 
        UE.UResourceLibrary.LoadObjectAsync(self, self.SupportPath,{self,WBP_Player_SkillPanel_PC_C.OnSupportIconLoadFinish})
    end
end

function WBP_Player_SkillPanel_PC_C:OnIconLoadFinish(Object)
    if not Object or not IsValid(self) then return end
    local AssetName = Object:GetName()
    AssetName = AssetName:gsub("T_", "")
    local LoadingType = self.LoadingIconMap[AssetName]
    self.LoadingIconMap[AssetName] = nil
    if not LoadingType then return end
    if LoadingType == IconLoadingType.SupportSkill then
        self.Assist_Skill_Icon:SetBrushResourceObject(Object)
        local VXSupportSkillMat = self.VX_skillIcon:GetDynamicMaterial()
        VXSupportSkillMat:SetTextureParameterValue("Mask", Object)
    elseif LoadingType == IconLoadingType.BulletIcon then
        self.Bullet:SetBrushResourceObject(Object)
    end
end

function WBP_Player_SkillPanel_PC_C:OnIconLoadFinishWithId(Object, ResourceID)
    if not Object or not IsValid(self) or ResourceID ~= self.LoadWeaponIconID then return end
    local AssetName = Object:GetName()
    AssetName = AssetName:gsub("T_", "")
    local LoadingType = self.LoadingIconMap[AssetName]
    self.LoadingIconMap[AssetName] = nil
    if LoadingType == IconLoadingType.WeaponIcon then
        self.Weapon_Icon:SetBrushResourceObject(Object)
    end
end

function WBP_Player_SkillPanel_PC_C:OnSupportIconLoadFinish(Object)
    if not Object or not IsValid(self) then return end
    self.Assist_Skill_Icon:SetBrushResourceObject(Object)
    local VXSupportSkillMat = self.VX_skillIcon:GetDynamicMaterial()
    VXSupportSkillMat:SetTextureParameterValue("Mask", Object)
end

-- 原先用动效控制这些蓝图节点，现在用代码，干的事情是一样的
function WBP_Player_SkillPanel_PC_C:DodgeNormalAnim()
    self.Dodge_Icon:SetRenderOpacity(1)
    self.Bg01_1:SetRenderOpacity(1)
    self.Charge_Num:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("FEFFD2FF"))
    self.Image_BanDodgeSkill:SetVisibility(ESlateVisibility.Collapsed)
end

-- 原先用动效控制这些蓝图节点，现在用代码，干的事情是一样的
function WBP_Player_SkillPanel_PC_C:DodgeForbidAnim()
    self.Dodge_Icon:SetRenderOpacity(0.3)
    self.Bg01_1:SetRenderOpacity(1)
    self.Charge_Num:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("DD1C45FF"))
end

------------------ 坐骑UI ----------------------
function WBP_Player_SkillPanel_PC_C:OnEnableBattleMount(Character)
    if not Character:IsMainPlayer() then
        return
    end
    if self.Overlay_Mounts:GetVisibility() ~= ESlateVisibility.SelfHitTestInvisible then
        self.Overlay_Mounts:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Mounts_In)
    end
    self.WS_Operation_PC:SetActiveWidgetIndex(1)
    self.WS_Operation_GamePad:SetActiveWidgetIndex(1)
    self.Battle_Skill_1:RemoveAllListenInput()
    self.Battle_Skill_2:RemoveAllListenInput()
end

function WBP_Player_SkillPanel_PC_C:OnDisableBattleMount(Character)
    if not Character:IsMainPlayer() then
        return
    end
    if self.Overlay_Mounts:GetVisibility() ~= ESlateVisibility.Collapsed then
        self.Overlay_Mounts:SetVisibility(ESlateVisibility.Collapsed)
    end
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Mounts_Out)
    self.Battle_Skill_1:AddSkillListeningInput()
    self.Battle_Skill_2:AddSkillListeningInput()
    self:StopListeningForInputAction("Avoid", EInputEvent.IE_Pressed)
    self:ListenForInputAction("Avoid", UE4.EInputEvent.IE_Pressed, false, {self, self.OnDodgeActionInput})
end

function WBP_Player_SkillPanel_PC_C:OnStartMountFly()
    DebugPrint("@zyh StartMountFly")
    self.WS_Operation_PC:SetActiveWidgetIndex(0)
    self.WS_Operation_GamePad:SetActiveWidgetIndex(0)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.MountFly_In)
    self:StopListeningForInputAction("Avoid", EInputEvent.IE_Pressed)
end

function WBP_Player_SkillPanel_PC_C:OnStopMountFly()
    self.WS_Operation_PC:SetActiveWidgetIndex(1)
    self.WS_Operation_GamePad:SetActiveWidgetIndex(1)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.MountFly_Out)
    self:ListenForInputAction("Avoid", UE4.EInputEvent.IE_Pressed, false, {self, self.OnDodgeActionInput})
end

return WBP_Player_SkillPanel_PC_C
