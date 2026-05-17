local M = Class("BluePrints.UI.BP_UIState_C")

local PhotoWallModel = require "BluePrints.UI.WBP.Activity.PC.Fool.Model.PhotoWallModel"

function M:Construct()
    self:InitListenEvent()
	self:SetTabDetailWidgets()
	self.Text_Empty:SetText(GText("AFDayEvent_PhotoWall_Mywork_Empty"))
	self.Text_EmptyDesc:SetText(GText("AFDayEvent_PhotoWall_Mywork_Empty02"))
end

function M:Destruct()
	self:UnBindEvents()
	self:BlockAllUIInput(false)
end

function M:OnLoaded(...)
    M.Super.OnLoaded(self, ...)
    local TabId = ...
    self:RefreshBaseInfo()
    self:StopAllAnimations()
	self:PlayAnimation(self.In)
	PhotoWallModel:Init()
	self:InitTable(TabId)
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "FoolsDayMain", nil)
end

function M:CloseSelf()
    self:StopAllAnimations()
    if (self.IsAddInDeque) then
        self:PlayAnimationForward(self.Out, UIConst.AnimOutSpeedWithPageJump.NormalFastSpeed)
    else
        self:PlayAnimation(self.Out)
    end
    AudioManager(self):SetEventSoundParam(self, "FoolsDayMain", {ToEnd=1})
	PhotoWallModel:Destory()
end

function M:OnOutAnimationFinished()
    self:Close()
end

function M:SetTabDetailWidgets()
	if self:IsMobile() then
		self.TabDetailWidgets = {
			[1] = self.WBP_Activity_Fool_OtherDetail_M,
			[2] = self.WBP_Activity_Fool_MyDetail_M,
		}
	else
		self.TabDetailWidgets = {
			[1] = self.WBP_Activity_Fool_OtherDetail_P,
			[2] = self.WBP_Activity_Fool_MyDetail_P,
		}
	end
	for _, DetailWidget in ipairs(self.TabDetailWidgets) do
		DetailWidget.Parent = self
	end
end

function M:OnTabDetailInited(bListEmpty)
	if bListEmpty then
		self.Com_Empty:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
		self:SetFocus()
	else
		self.Com_Empty:SetVisibility(ESlateVisibility.Collapsed)
	end
end

function M:InitTable(TabId)
	self.Com_Tab:Init({
		Tabs = {
			{ Text = GText("AFDayEvent_PhotoWall_List"), TabId = 1, IconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_FoolOther.T_Tab_FoolOther",},
			{ Text = GText("AFDayEvent_PhotoWall_Mywork"), TabId = 2, IconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_FoolMine.T_Tab_FoolMine", },
		},
        DynamicNode={"Back", "BottomKey",}, 
        BottomKeyInfo = {
            {
                GamePadInfoList = {{Type="Img", ImgShortPath="A", Owner=self}}, Desc=GText("UI_Controller_CheckDetails")
            },
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}},
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseSelf, Owner=self}}, Desc=GText("UI_BACK")
            }
        },
        StyleName = "TextImage",
        TitleName = GText("AFDayEvent_PhotoWall_Name"),
        OwnerPanel=self,
        BackCallback=self.CloseSelf,
    })
    self.Com_Tab:BindEventOnTabSelected(self, function(_,TabWidget)
        if self.CurrTabIdx == TabWidget.Idx then return end
        self.CurrTabIdx = TabWidget.Idx
        for Idx, DetailWidget in pairs(self.TabDetailWidgets) do
	        if IsValid(DetailWidget) then
	        	if self.CurrTabIdx ~= Idx then
		        	DetailWidget:LeavePage()
		        end
	        end
       	end
       	local CurDetailWidget = self.TabDetailWidgets[self.CurrTabIdx]
        if IsValid(CurDetailWidget) then
        	CurDetailWidget:EnterPage()
        end
        self:RefreshBaseInfo()
    end)
    self.Com_Tab:SelectTab(TabId or 1)
end

function M:OnPhotoDeletedOnServer(UniqueId)
    if not UniqueId then return end
    if not self.CurrTabIdx then return end
    local CurDetailWidget = self.TabDetailWidgets[self.CurrTabIdx]
    if IsValid(CurDetailWidget) then
        CurDetailWidget:OnPhotoDeleted(UniqueId)
    end
end

function M:UpdateBottomKeyInfo(bEdit, bHide)
    if self:IsMobile() then
        return
    end
	if bHide then
		self.Com_Tab:UpdateBottomKeyInfo({
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}},
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseSelf, Owner=self}}, Desc=GText("UI_BACK")
            }
        })
		return
	end
    if bEdit then
        self.Com_Tab:UpdateBottomKeyInfo({
            {
                GamePadInfoList = {{Type="Img", ImgShortPath="A", Owner=self}}, Desc=GText("UI_CTL_Select/Cancel")
            },
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}},
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseSelf, Owner=self}}, Desc=GText("UI_BACK")
            }
        })
    else 
       self.Com_Tab:UpdateBottomKeyInfo({
            {
                GamePadInfoList = {{Type="Img", ImgShortPath="A", Owner=self}}, Desc=GText("UI_Controller_CheckDetails")
            },
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}},
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseSelf, Owner=self}}, Desc=GText("UI_BACK")
            }
        })
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName) 
    else
        if InKeyName == "Escape" then
            if not UIManager(self):GetUIObj("CommonDialog") then
                IsEventHandled = true
                self:CloseSelf()
            end
        else
            IsEventHandled = self.Com_Tab:Handle_KeyEventOnPC(InKeyName)
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

function M:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    if InKeyName == "Gamepad_FaceButton_Right"  then
    	IsEventHandled = true
    else
    	IsEventHandled = self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName)
    end
    return IsEventHandled
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if InKeyName == "Gamepad_FaceButton_Right"  then
    	if not UIManager(self):GetUIObj("CommonDialog") then
            IsEventHandled = true
            self:CloseSelf()
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

function M:IsMobile()
    return CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance) == CommonConst.CLIENT_DEVICE_TYPE.MOBILE
end

function M:InitListenEvent()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice) 
    end
end

function M:RefreshBaseInfo()
    -- 刷新一些基础信息
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
        --照相界面跳转过来时，光标透明度为0，需手动显示
        self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
    end
end

function M:UnBindEvents()
     if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self,self.RefreshOpInfoByInputDevice) 
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    --- 切换手柄端相关图标显隐
    if (self:IsMobile()) then
        -- 触控模式即默认样式，不需要刷新
        return
    end

    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        self.UsingGamepad = false
    else
        self.UsingGamepad = true
    end
    local CurDetailWidget = self.TabDetailWidgets[self.CurrTabIdx]
    if IsValid(CurDetailWidget) then
    	CurDetailWidget:SwitchUIType(self.UsingGamepad)
    end
    self:SetFocusTarget()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    self:SetFocusTarget()
    return UIUtils.Handled
end

function M:SetFocusTarget()
    if not self:HasFocusedDescendants() and not self:HasAnyUserFocus() then
        return
    end
    if not self.CurrTabIdx then return end
    local CurDetailWidget = self.TabDetailWidgets[self.CurrTabIdx]
    if (IsValid(CurDetailWidget) and CurDetailWidget:IsVisible()) then
        CurDetailWidget:SetFocusTarget()
    end
end

return M