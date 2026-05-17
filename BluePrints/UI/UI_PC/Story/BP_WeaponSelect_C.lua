local PickupUseComponent = require "BluePrints.Item.Pickups.PickupUseComponent"

---@type BP_WeaponSelect_C
local BP_WeaponSelect_C = Class("BluePrints.UI.BP_UIState_C")

function BP_WeaponSelect_C:Construct()
    self.WidgetSwitcher:SetActiveWidgetIndex(1)
    self.FindWeapon = false
    self.WeaponEffectBox = {}
    self.ControlEid = 0
    self.Common_BlackBtn01_PC:BindEventOnClicked(self, self.OnChooseWeapon)
    self.Common_BlackBtn01_PC.SoundFunc = self.PlaySoundOnClick
    self.Overridden.Construct(self)

    self.TextBlock:SetText(GText("PROLOGUE_SELECTGUN_TIP_3"))
    self.TextBlock_99:SetText(GText("PROLOGUE_SELECTGUN_TIP_2"))
    self.TextBlock_494:SetText(GText("PROLOGUE_SELECTGUN_TIP_1"))

    self.Common_BlackBtn01_PC:SetText(GText("PROLOGUE_SELECTGUN_TIP_4"))
    self:FindRangedWeaponActor()

    self:InitDeviceInfo()
    self:InitListenEvent()

    self.DeviceInPc = CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile"
    if (not self.DeviceInPc) or self.CurInputDeviceType == ECommonInputType.Gamepad then
        self.LeftMouse:SetVisibility(ESlateVisibility.Collapsed)
    end

end

function BP_WeaponSelect_C:Tick(MyGeometry, InDeltaTime)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
            self:TraceWeapon()
        end
        self:IsWeapon(self.SelectActor)
        if self.FindWeapon then
            self:SetWeaponEffectBox()
        end
        return
    end
end

function BP_WeaponSelect_C:InitDeviceInfo()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function BP_WeaponSelect_C:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    end
end

function BP_WeaponSelect_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        return
    end

    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName

    self:InitBtnTipsUI()
end

--切换手柄和非手柄UI
function BP_WeaponSelect_C:InitBtnTipsUI()
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self:SwitchGamepadIconShowOrHide(true)
        self.SelectActor = self.RightRangedWeapon
        self:SetWeaponEffectBox()
        self.SelectActor = self.LefttRangedWeapon
        self:SetWeaponEffectBox()
    else
        self:SwitchGamepadIconShowOrHide(false)
        if self.CurInputDeviceType ~= ECommonInputType.MouseAndKeyboard then
            self.LeftMouse:SetVisibility(ESlateVisibility.Collapsed)
        else
            self.LeftMouse:SetVisibility(ESlateVisibility.Visibility)
        end
    end

end

--切换手柄UI显隐
function BP_WeaponSelect_C:SwitchGamepadIconShowOrHide(IsShow)
    if IsShow then
        self.HB_Key:SetVisibility(ESlateVisibility.Visibility)
        self.Com_KeyTips:SetVisibility(ESlateVisibility.Visibility)
        self.TextBlock_99:SetVisibility(ESlateVisibility.Collapsed)
        self.LeftMouse:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.TextBlock_99:SetVisibility(ESlateVisibility.Visibility)
        self.HB_Key:SetVisibility(ESlateVisibility.Collapsed)
        self.Com_KeyTips:SetVisibility(ESlateVisibility.Collapsed)
        return
    end

    local KeyInfo1 = {
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "LB",
            },
        },
    }
    self.Key_Text_1:CreateCommonKey(KeyInfo1)

    local KeyInfo2 = {
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "RB",
            },
        },
    }
    self.Key_Text_2:CreateCommonKey(KeyInfo2)

    local KeyInfo3 = {
        {
            KeyInfoList = { { Type = "Img", ImgShortPath = "LB" } },
            Desc = GText("UI_CTL_SelectLeft"),
        },
        {
            KeyInfoList = { { Type = "Img", ImgShortPath = "RB" } },
            Desc = GText("UI_CTL_SelectRight"),
        },
    }
    self.Com_KeyTips:UpdateKeyInfo(KeyInfo3)
end

--监听PC/手柄按键
function BP_WeaponSelect_C:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        DebugPrint("thy    Key_IsGamepadKey", InKeyName)
        IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

--监听PC/手柄按键 抬起
function BP_WeaponSelect_C:OnKeyUp(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        DebugPrint("thy    Key_IsGamepadKey", InKeyName)
        IsEventHandled = self:Handle_OnGamePadUp(InKeyName)
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function BP_WeaponSelect_C:IsSubstringContained(parentStr, subStr)
    local startPos, endPos = string.find(parentStr, subStr)
    if startPos and endPos then
        return true
    end
    return false
end

function BP_WeaponSelect_C:GetWeapon(StaticCreatorId)
    local EMGameState = UE4.UGameplayStatics.GetGameState(self)
    local StaticCreator = EMGameState.StaticCreatorMap:Find(StaticCreatorId)
    local ChildEids = StaticCreator.ChildEids
    local Num = ChildEids:Length()
    local Actor = nil
    if ChildEids and Num > 0 then
        Actor = Battle(self):GetEntity(ChildEids[1])
    end
    return Actor
end

function BP_WeaponSelect_C:FindRangedWeaponActor()
    self.RightRangedWeapon = self:GetWeapon(1510010302)
    self.LefttRangedWeapon = self:GetWeapon(1510010303)
end

function BP_WeaponSelect_C:Handle_OnGamePadDown(InKeyName)
    if (InKeyName == "Gamepad_LeftShoulder") then
        if self.LeftShoulderIsPress or self.IsPressing then
            return true
        end
        self.IsPressing = true
        self.LeftShoulderIsPress = true
        self.SelectActor = self.RightRangedWeapon
        self.TryToSelectActor = self.LefttRangedWeapon
        self:TraceWeaponGamePad()
        self:OnSelectWeapon()
        return true
    elseif (InKeyName == "Gamepad_RightShoulder") then
        if self.RightShoulderIsPress or self.IsPressing then
            return true
        end
        self.IsPressing = true
        self.RightShoulderIsPress = true
        self.SelectActor = self.LefttRangedWeapon
        self.TryToSelectActor = self.RightRangedWeapon
        self:TraceWeaponGamePad()
        self:OnSelectWeapon()
        return true
    elseif (InKeyName == "Gamepad_FaceButton_Bottom") then
        if self.IsPressing then
            return
        end
        self.Common_BlackBtn01_PC:OnBtnPressed()
        self.IsPressing = true
        return true
    end
    return false
end

function BP_WeaponSelect_C:Handle_OnGamePadUp(InKeyName)
    DebugPrint("thy    Handle_OnGamePadDown", InKeyName)
    if (InKeyName == "Gamepad_FaceButton_Bottom") then
        self.IsPressing = false
        self.Common_BlackBtn01_PC:OnBtnClicked()
        return true
    elseif (InKeyName == "Gamepad_LeftShoulder") then
        if self.RightShoulderIsPress then
            return true
        end
        self.LeftShoulderIsPress = false
        self.IsPressing = false
        return true
    elseif (InKeyName == "Gamepad_RightShoulder") then
        if self.LeftShoulderIsPress then
            return true
        end
        self.RightShoulderIsPress = false
        self.IsPressing = false
        return true
    end
    return false
end

function BP_WeaponSelect_C:SetWeaponEffectBox()
    if self.WeaponEffectBox[self.SelectActor.Eid] then
        return
    end

    local EffectBoxs = self:FindEffectBox()
    if EffectBoxs:Length() == 0 then
        print(_G.LogTag, "Error:", self.SelectActor:GetName(), "Can't Find EffectBox")
        return
    elseif EffectBoxs:Length() > 1 then
        print(_G.LogTag, "Error:", self.SelectActor:GetName(), "Find more than 1 EffectBox")
        return
    else
        self.WeaponEffectBox[self.SelectActor.Eid] = EffectBoxs:GetRef(1)
    end
end

-- 云游戏pc也走得这里，因为TraceWeapon在蓝图里面做的逻辑，不太好改，就在lua里面写了云游戏pc的逻辑
function BP_WeaponSelect_C:TraceWeaponMobile(InKeyEvent)
    local IsCloudGamePC = UE4.UUCloudGameInstanceSubsystem.IsCloudGame(self) and CommonUtils.GetDeviceTypeByPlatformName(self) == "PC"
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" and not UE4.UUCloudGameInstanceSubsystem.IsCloudGame(self) then
        return
    end
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local ObjectTypes = TArray(EObjectTypeQuery)
    ObjectTypes:Add(EObjectTypeQuery.Item)

    local Results = UE4.TArray(UE4.FHitResult)
    if UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
        PlayerController:GetHitResultsUnderCursorForObjects(ObjectTypes, true, Results)
    elseif IsCloudGamePC then
        DebugPrint("jly    TraceWeaponMobile CloudGamePC")
        -- 云游戏PC需要换一套逻辑，考虑网页缩放
        local MousePosition = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InKeyEvent)
        DebugPrint("MousePosition before scale:", MousePosition)
        
        -- 获取视口缩放比例（考虑DPI和浏览器缩放）
        local ViewportScale = UE4.UWidgetLayoutLibrary.GetViewportScale(self)
        DebugPrint("ViewportScale:", ViewportScale)
        
        -- 调整鼠标位置以考虑缩放
        -- PointerEvent_GetScreenSpacePosition返回的是浏览器窗口坐标，需要转换为视口坐标
        if ViewportScale and ViewportScale ~= 1.0 then
            MousePosition.X = MousePosition.X * ViewportScale
            MousePosition.Y = MousePosition.Y * ViewportScale
            DebugPrint("MousePosition after scale:", MousePosition)
        end
        
        Results = PlayerController:GetHitResultsAtScreenPosition(MousePosition, ObjectTypes, true)
    else
        local MousePosition = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InKeyEvent)
        DebugPrint("MousePosition:", MousePosition)
        Results = PlayerController:GetHitResultsAtScreenPosition(MousePosition, ObjectTypes, true);
    end
    DebugPrint("Results:Length():", Results:Length())
    for i = 1, Results:Length() do
        local Actori = Results[i].Actor
        DebugPrint(Actori:GetName())
        if Actori:Cast(UE4.APickupBase) then
            self.bIsWeapon = true
            if self.SelectActor ~= Actori then
                self.SelectActor = Actori
                DebugPrint("self.SelectActor", Actori:GetName())
            end
        end
    end
    self:IsWeapon(self.SelectActor)
    if self.FindWeapon then
        self:SetWeaponEffectBox()
    end
end

function BP_WeaponSelect_C:OnMouseButtonDown(MyGeometry, InKeyEvent)
    DebugPrint("BP_WeaponSelect_C:OnMouseButtonDown")
    self:TraceWeaponMobile(InKeyEvent)
    self:OnSelectWeapon()
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function BP_WeaponSelect_C:OnTouchStarted(MyGeometry, InTouchEvent)
    DebugPrint("JLY    BP_WeaponSelect_C:OnMouseButtonDown")
    self:TraceWeaponMobile(InTouchEvent)
    self:OnSelectWeapon()
    return UE4.UWidgetBlueprintLibrary.Handled()
end

--鼠标点击武器
function BP_WeaponSelect_C:OnSelectWeapon()
    print(_G.LogTag, "OnSelectWeapon", self.SelectActor, self.ControlEid)
    if not self.SelectActor or not self.ControlEid or self.SelectActor.Eid == self.ControlEid then
        return
    end

    --第一次选武器的时候，ControlEid是0
    if self.ControlEid == 0 then
        self.ControlEid = self.SelectActor.Eid
    end

    --枪上能量灯装置特效
    Battle(self):GetEntity(self.ControlEid):SetWeaponLight(20)
    DebugPrint("thy   test", self.WeaponEffectBox, self.ControlEid, self.WeaponEffectBox[self.ControlEid])
    self.WeaponEffectBox[self.ControlEid]:PlayLeaveEffect()

    self.ControlEid = self.SelectActor.Eid
    self.SelectActor:SetWeaponLight(100)
    self.WeaponEffectBox[self.ControlEid]:PlaySelectEffect()
    self.WidgetSwitcher:SetActiveWidgetIndex(0)

    local WeaponId = PickupUseComponent.ClientGetWeaponId["GetWeaponId"](self.SelectActor.UnitId)
    local WeaponData = DataMgr.Weapon[WeaponId]
    local DropData = DataMgr.Drop[self.SelectActor.UnitId]

    self.TextBlock_1:SetText(GText(WeaponData.WeaponName))
    self.Interduction:SetText(GText(DropData.DropDescribe))

    AudioManager(self):PlayFMODSound(self, nil, "event:/ui/common/select_gun")
end

function BP_WeaponSelect_C:HasWeapon(WeaponId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    for i, Weapon in pairs(Avatar.Weapons) do
        if Weapon.WeaponId == WeaponId then
            return true
        end
    end
    return false
end

--鼠标点击确定
function BP_WeaponSelect_C:OnChooseWeapon()
    if self.ControlEid == 0 then
        return
    end

    local SelectWeapon = Battle(self):GetEntity(self.ControlEid)
    local WeaponId = PickupUseComponent.ClientGetWeaponId["GetWeaponId"](SelectWeapon.UnitId)
    local Index = 1
    for i, v in pairs(DataMgr.InitConfig[1]["AlternativeRangedWeapon"]) do
        if WeaponId == v then
            Index = i
            break
        end
    end

    local function SelectWeaponSuccess()
        self:RefreshWeapon(WeaponId)
        SelectWeapon:EMActorDestroy(EDestroyReason.Pickup)
        self.WeaponEffectBox[self.ControlEid]:PlayLeaveEffect()
        --停止监听，卸载UI
        UIManager(self):OpenResidentUI()
        self:StopListeningForInputAction("TalkClick", EInputEvent.IE_Pressed)
        UIManager(self):UnLoadUI("StoryWeaponSelect")
        EventManager:FireEvent(EventID.OnSelectWeapon)
    end

    if self:HasWeapon(WeaponId) then
        SelectWeaponSuccess()
        return
    end

    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:ChooseRangedWeapon(Index, function(Ret)
            if (not ErrorCode:Check(Ret)) then
                return
            end

            if (not IsValid(self)) then
                return
            end

            SelectWeaponSuccess()
        end)
    end
end

function BP_WeaponSelect_C:PlaySoundOnClick()
    AudioManager(self):PlayUISound(self, "event:/ui/common/select_gun_click", nil, nil)
end

function BP_WeaponSelect_C:RefreshWeapon(WeaponId)
    local Avatar = GWorld:GetAvatar()
    local InfoForInit = AvatarUtils:GetDefaultBattleInfo(Avatar)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    Player:InitCharacterInfo(InfoForInit)
end

return BP_WeaponSelect_C
