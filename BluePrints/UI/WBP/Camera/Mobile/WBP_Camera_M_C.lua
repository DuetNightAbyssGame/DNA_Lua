--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Camera_M_C
local M = Class("BluePrints.UI.WBP.Camera.WBP_CameraBase_C")

local Handle = UE4.UWidgetBlueprintLibrary.Handled()
local Unhandle = UE4.UWidgetBlueprintLibrary.Unhandled()

function M:Construct()
    self.TouchInfo = {}
    self.Btn_Close.OnClicked:Clear()
    self.Btn_Close.OnClicked:Add(self,self.OnBackBtnClicked)
    self.TabConfig = {
        Tabs = {
            {Text = GText("UI_CameraSystem_CameraModeDefault"),CameraIndex = 0},
            {Text = GText("UI_CameraSystem_CameraModeSelfie"),CameraIndex = 1},
            {Text = GText("UI_CameraSystem_CameraModePhotography"),CameraIndex = 2},
        },
        SoundFunc = function()
        end
    }
    self.Btn_HideRole:BindEventOnClicked(self,self.OnHideCharacterBtnClicked,self.Btn_HideRole)
    self.Btn_HideUI:BindEventOnClicked(self,self.OnHideUIBtnClicked,self.Btn_HideUI)
    self.Btn_Restore:BindEventOnClicked(self,self.OnResetCameraBtnClicked,self.Btn_Restore)
    self.Btn_Tab:BindEventOnClicked(self,self.OnShowTabBtnClicked,self.Btn_Tab)
    self.Btn_Incline:BindEventOnClicked(self,self.OnShowRollScrollBarBtnClicked,self.Btn_Incline)
    self.WBP_Camera_Tab_Item_M:Init(self.TabConfig)
    self.WBP_Camera_Tab_Item_M:BindEventOnTabSelected(self,self.OnTabSelected)
    self.WBP_Camera_Tab_Item_M:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WBP_Camera_Scale:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WBP_Camera_Roll_M:BindEvnetOnJoyStick(self,{
        OnMoved = self.OnJoyStickMove,
        OnPointerDown = self.OnJoyStickPointerDown,
        OnPointerUp = self.OnJoyStickPointerUp
    })
    self.WBP_Camera_Shoot_M:BindEventOnClicked(self,self.OnCheeseBtnClicked)
    self.WBP_Camera_Bar:_SetExtraText(GText("UI_CameraSystem_CameraFocalLength"))
    self.FocalLengthSlider = self.WBP_Camera_Bar
    self.RollScrollBar = self.WBP_Camera_Scale
    self.RollScrollBar:DisableHover(true)
    self:FlushAnimations()
    self:PlayAnimation(self.BtnHideRole_Normal)

    self.Text_Hide_All:SetText(GText("UI_CameraSystem_HideModelAll"))
    self.Btn_AISetting:SetChecked(false, false)
    self.Btn_AISetting:AddEventOnCheckStateChanged(self, self.OnCheckBoxClicked)
    self.Hide_Role:BindEventOnClicked(self,self.OnHideRoleBtnClicked)
    self.Hide_Player:BindEventOnClicked(self,self.OnHidePlayerBtnClicked)
    self.Hide_NPC:BindEventOnClicked(self,self.OnHideNPCBtnClicked)
    self.Hide_Monster:BindEventOnClicked(self,self.OnHideMonsterBtnClicked)
    self.Hide_Pet:BindEventOnClicked(self,self.OnHidePetBtnClicked)
    self.bHasAnyCharacterHidden = false

    M.Super.Construct(self)

    self:UpdateCheckBox()
    self:UpdateHideCharacterBtn()
end

function M:HideMenu(FromBtn)
    if(self.IsRollScrollBarShowed and (not FromBtn or FromBtn ~= self.Btn_Incline))then
        self:ToggleShowRollScrollBar(self.Btn_Incline)
    end
    if(self.IsTabShowed and  (not FromBtn or FromBtn ~= self.Btn_Tab))then
        self:ToggleShowTab(self.Btn_Tab)
    end
    if(self.IsHideCharacterWidgetShowed and  (not FromBtn or FromBtn ~= self.Btn_HideRole))then
        self:ToggleShowHideCharacterWidget(self.Btn_HideRole)
    end
    self.Btn_HideUI:Unclicked()
end

function M:OnShowRollScrollBarBtnClicked(FromBtn)
    UIUtils.PlayCommonBtnSe(self)
    self:HideMenu(FromBtn)
    self:ToggleShowRollScrollBar(FromBtn)
end

function M:ToggleShowRollScrollBar(FromBtn)
    self.IsRollScrollBarShowed = not self.IsRollScrollBarShowed
    if(self.IsRollScrollBarShowed)then
        self.RollScrollBar:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self:StopAnimation(self.ScaleRuler_Out)
        self:PlayAnimation(self.ScaleRuler_In)
    else
        self.RollScrollBar:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self:StopAnimation(self.ScaleRuler_In)
        self:PlayAnimation(self.ScaleRuler_Out)
        if(FromBtn)then
            FromBtn:Unclicked()
        end
    end
end

function M:OnShowTabBtnClicked(FromBtn)
    UIUtils.PlayCommonBtnSe(self)
    self:HideMenu(FromBtn)
    self:ToggleShowTab(FromBtn)
end

function M:ToggleShowTab(FromBtn)
    self.IsTabShowed = not self.IsTabShowed
    if(self.IsTabShowed)then
        self.WBP_Camera_Tab_Item_M:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self:StopAnimation(self.CameraTab_Out)
        self:PlayAnimation(self.CameraTab_In)
    else
        self.WBP_Camera_Tab_Item_M:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self:StopAnimation(self.CameraTab_In)
        self:PlayAnimation(self.CameraTab_Out)
        if(FromBtn)then
            FromBtn:Unclicked()
        end
    end
end


function M:OnTabSelected(TabWidget,Tab)
    self:ChangeCamera(Tab.CameraIndex)
    self.Text_Tab:SetText(Tab.Text)
end

function M:OnTouchStarted(MyGeometry, InTouchEvent)
    local PointerIndex= UE4.UKismetInputLibrary.PointerEvent_GetPointerIndex(InTouchEvent)
    self.TouchInfo[PointerIndex] = UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InTouchEvent)
    if(self.TouchInfo[0] and self.TouchInfo[1])then
        self.DualTouchDistance = (self.TouchInfo[0] - self.TouchInfo[1]):Size()
    end
    if(self.bScreenshotWidgetShow)then
        return Unhandle
    end
    return UWidgetBlueprintLibrary.CaptureMouse(Handle,self)
end

function M:OnTouchEnded(MyGeometry, InTouchEvent)
    local PointerIndex= UE4.UKismetInputLibrary.PointerEvent_GetPointerIndex(InTouchEvent)
    self.TouchInfo[PointerIndex] = nil
    if(not self.TouchInfo[0] or not self.TouchInfo[1])then
        self.DualTouchDistance = 0
    end
    if(not self.HasTouchMove)then
        if(self.bSelfHidden)then
            self:ToggleHideSelf()
        end
    end
    if(not self.HasTouchMove)then
        self:HideMenu()
    end
    self.HasTouchMove = false
    return UWidgetBlueprintLibrary.ReleaseMouseCapture(Handle)
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
    if(self.bScreenshotWidgetShow)then
        return Unhandle
    end
    local RealMove = false
    local PointerIndex= UE4.UKismetInputLibrary.PointerEvent_GetPointerIndex(InTouchEvent)
    self.TouchInfo[PointerIndex] = UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InTouchEvent)
    if(self.TouchInfo[0])then
        if(self.TouchInfo[1])then
            --双指
            local NewDistance = (self.TouchInfo[0] - self.TouchInfo[1]):Size()
            self:MoveCamera((NewDistance - self.DualTouchDistance) / 5,0,0)
            self.DualTouchDistance = NewDistance
        else
            --单指
            local CursorDelta = UE4.UKismetInputLibrary.PointerEvent_GetCursorDelta(InTouchEvent)
            RealMove = CursorDelta.Y ~= 0 or CursorDelta.X ~= 0
            self:RotateCamera(0,-CursorDelta.Y,CursorDelta.X)
        end
    end
    self.HasTouchMove = self.HasTouchMove or RealMove
    return Unhandle
end

function M:OnMouseCaptureLost()
    self.HasTouchMove = false
end

function M:OnJoyStickMove(Dir,Percent)
    self.bCameraMovedByJoyStick = not self.bLockCameraPos
    self:MoveCamera(0,Dir.X * Percent, Dir.Y * Percent)
end

function M:OnJoyStickPointerDown()
    if (self.bLockCameraPos) then
        self.WBP_Camera_Roll_M:PlayAnimation(self.WBP_Camera_Roll_M.Warning)
    end
end

function M:OnJoyStickPointerUp()
    self.bCameraMovedByJoyStick = false
end

function M:OnRollScrollBarPercentChanged(Percent)
    self.bRollScrollBarPointerDown = true
    self:SetRollPercent(Percent)
end

function M:OnRollScrollBarInertialScrollingEnd()
    M.Super.OnRollScrollBarInertialScrollingEnd(self)
    self.bRollScrollBarPointerDown = false
end

function M:OnHideUIBtnClicked()
    self:HideMenu()
    self:ToggleHideSelf()
end

function M:OnHideCharacterBtnClicked(FromBtn)
    UIUtils.PlayCommonBtnSe(self)
    self:HideMenu(FromBtn)
    self:ToggleShowHideCharacterWidget(FromBtn)
end

function M:ToggleShowHideCharacterWidget(FromBtn)
    self.IsHideCharacterWidgetShowed = not self.IsHideCharacterWidgetShowed
    if(self.IsHideCharacterWidgetShowed)then
        self:StopAnimation(self.Menu_Out)
        self:PlayAnimation(self.Menu_In)
        self.CanvasPanel_HideRole:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self:StopAnimation(self.Menu_In)
        self:PlayAnimation(self.Menu_Out)
        self.CanvasPanel_HideRole:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        if(FromBtn)then
            FromBtn:Unclicked()
        end
    end
end

function M:OnHideBtnClickedImp(HiddenButtonType, CharacterType)
    M.Super.OnHideBtnClickedImp(self, HiddenButtonType, CharacterType)

    if (not self[HiddenButtonType].bLocked) then
        self:UpdateHideCharacterBtn()
    end
end

function M:UpdateCheckBox()
    local Checked = self.CharType.All == self.CurCharHiddenState
    local CheckedBefore = not not self.Btn_AISetting:GetChecked()
    if(CheckedBefore ~= Checked)then
        self.Btn_AISetting:SetChecked(Checked, false)
    end
end

function M:UpdateHideCharacterBtn()
    local HasAnyCharacterHidden = self.CurCharHiddenState ~= 0
    if(self.bHasAnyCharacterHidden ~= HasAnyCharacterHidden)then
        self.bHasAnyCharacterHidden = HasAnyCharacterHidden
        if(HasAnyCharacterHidden)then
            self:StopAnimation(self.BtnHideRole_Normal)
            self:PlayAnimation(self.BtnHideRole_Click)
        else
            self:StopAnimation(self.BtnHideRole_Click)
            self:PlayAnimation(self.BtnHideRole_Normal)
        end
    end
end

function M:OnCheckBoxClicked()
    if(self.CurCharHiddenState ~= self.CharType.All)then
        self:SetCharHiddengState(self.CharType.All)
    else
        self:SetCharHiddengState(0)
    end
    self:UpdateHideCharacterBtn()
    self.Hide_Role:SetHiddenState(self.CharType.Char & self.CurCharHiddenState ~= 0)
    self.Hide_Player:SetHiddenState(self.CharType.Player & self.CurCharHiddenState ~= 0)
    self.Hide_NPC:SetHiddenState(self.CharType.NPC & self.CurCharHiddenState ~= 0)
    self.Hide_Monster:SetHiddenState(self.CharType.Monster & self.CurCharHiddenState ~= 0)
    self.Hide_Pet:SetHiddenState(self.CharType.Pet & self.CurCharHiddenState ~= 0)
end

function M:OnResetCameraBtnClicked()
    self:HideMenu()
    self:ResetCamera()
    self.Btn_Restore:Unclicked()
end

function M:OnAddFocalLengthBtnClicked()
    self.FocalLengthSlider:AddValue()
end

function M:OnSubFocalLengthBtnClicked()
    self.FocalLengthSlider:SubValue()
end

function M:OnFocalLengthSliderValueChanged(Value)
    self:SetFocalLength(Value)
end

function M:OnBackBtnClicked()
    self:CheckHasAnyOperationOrClose()
    self:HideMenu()
end

function M:OnCheeseBtnClicked()
    self:Screenshot()
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
    M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
    -- self.WBP_Camera_Tab_Item_M:SelectTab(1)
end

function M:Tick(MyGeometry, InDeltaTime)
    if(self.HasTouchMove
    or self.bCameraMovedByJoyStick
    --or self.bRollScrollBarPointerDown
    )then
        self.SoundFlags["Camera_Motor"] = true
    else
        self.SoundFlags["Camera_Motor"] = false
    end
    self.HasTouchMove = false
    M.Super.Tick(self,MyGeometry, InDeltaTime)
end

function M:TickFindTargets()
    M.Super.TickFindTargets(self)

    -- 愚人节活动不播放按钮特效
    if (self.InitParams and self.InitParams.IsAprilFoolsDayActivity) then
        self.WBP_Camera_Shoot_M:StopLoopRemind()
        return
    end
    if (self.bScreenshotWidgetShow or self.IsShotTargetSucceeded) then
        self.WBP_Camera_Shoot_M:StopLoopRemind()
        return
    end

    if (self.bFindTarget) then
        self.WBP_Camera_Shoot_M:PlayLoopRemind()
    else
        self.WBP_Camera_Shoot_M:StopLoopRemind()
    end
end

function M:SetLockGamePause(bNewLock)
    M.Super.SetLockGamePause(self, bNewLock)

    self.Icon_Lock_Pause:SetVisibility(bNewLock and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:SetLockHiddenButton(HiddenButton, bNewLock)
    M.Super.SetLockHiddenButton(self, HiddenButton, bNewLock)

    -- 任一隐藏按钮被 Lock 则隐藏所有按钮 Lock
    if (bNewLock) then
        self.Icon_Lock:SetOpacity(1)
        -- self.Btn_AISetting:SetIsEnabled(false)
        self:SetLockHiddenAllButton(bNewLock)
    end
end

function M:SetLockAllHiddenButton(bNewLock)
    M.Super.SetLockAllHiddenButton(self, bNewLock)
    
    self.Icon_Lock:SetOpacity(bNewLock and 1 or 0)
    -- self.Btn_AISetting:SetIsEnabled(not bNewLock)
    self:SetLockHiddenAllButton(bNewLock)
end

function M:SetLockCameraPos(bNewLock)
    M.Super.SetLockCameraPos(self, bNewLock)

    if bNewLock then
        self.WBP_Camera_Roll_M:PlayAnimation(self.WBP_Camera_Roll_M.Roll_Lock)
    else
        self.WBP_Camera_Roll_M:PlayAnimation(self.WBP_Camera_Roll_M.Roll_Normal)
    end
    self.WBP_Camera_Roll_M:SetJoyStickLocked(bNewLock)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    if(self.bScreenshotWidgetShow)then
        self.ScreenshotWidget:OnKeyDown(MyGeometry, InKeyEvent)
        return UIUtils.Handled
    end
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == "Escape" or InKeyName == "Android_Back")then
        self:CheckHasAnyOperationOrClose()
    end
    return UIUtils.Handled
end

return M
