--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"

---@type WBP_Activity_Fool_Archive_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Super.Construct(self)

    self.Btn_Detail.OnHovered:Add(self, self.OnDetailHovered)
    self.Btn_Detail.OnUnhovered:Add(self, self.OnDetailUnhovered)
    self.Btn_Detail.OnPressed:Add(self, self.OnDetailPressed)
    self.Btn_Detail.OnReleased:Add(self, self.OnDetailReleased)
    self.Btn_Detail.OnClicked:Add(self, self.OnDetailClicked)
    self.Btn_Find:BindEventOnClicked(self,self.TryOpenArmoryDetailBattleWheel)
    self.Btn_Find:TryOverrideSoundFunc(function()
        AudioManager(self):PlayUISound(self, "event:/ui/activity/fools_day_btn_confirm",nil,nil)
    end)
    self:InitMenuOpenChangedListen()

    self.List_Item:SetScrollBarVisibility(ESlateVisibility.Hidden)
    self.List_Item:SetControlScrollbarInside(true)
    self.Tips_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self,function(self, bOpen)
        UIManager(self):SetIsMenuAnchorOpen(bOpen)
    end)
    self.Tips_MenuAnchor:SetLastFocusWidget(self)

    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
    self:InitListenEvent()
    self:InitWidgetInfoInGamePad()
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    self:ClearListenEvent()
    self:ClearMenuOpenChangedListen()
    self.Tips_MenuAnchor:ClearSetup()
    self.Tips_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Clear()
    AudioManager(self):StopSound(self, "FoolArchiveOpenSound")
    self.Super.Destruct(self)
end

function M:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function M:ClearListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    end
end

function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self:InitNormalInfo()
	self:InitItemList()
	self:InitTab()
    self:InitHudBubble()
	self:RefreshBtn()
    self:PlayInAnimation()
    -- local Content = NewObject(UIUtils.GetCommonItemContentClass())
    -- Content.ItemType = DataMgr.Resource[self.ResourceId].Type
    -- Content.ItemId = DataMgr.Resource[self.ResourceId].ResourceId
    -- Content.IsShowDetails = true
    -- self.Tips_MenuAnchor:InitializeSetUp(self,Content, true)
end

function M:InitNormalInfo()
    self.EventId = DataMgr.EventConstant.AFDayEvent2026ID.ConstantValue
    self.ResourceId = DataMgr.EventConstant.TransformResourceID.ConstantValue
    self.Btn_Find:SetText(GText("AFDayEvent_JumpArmory"))
    self.Com_Hint.Text_Hint_Normal:SetText(GText("AFDayEvent_TransformItem_Equipped"))
    self.Text_Title:SetText(GText("AFDayEvent_TransformItem_Found"))
    self.Text_Empty:SetText(GText("AFDayEvent_UseTransformItem_Tips02"))
    self.Text_HintDesc:SetText(GText("AFDayEvent_UseTransformItem_Tips"))
    if self.ResourceId and DataMgr.Resource[self.ResourceId] then
        if DataMgr.Resource[self.ResourceId].ResourceName then
            self.Text_ItemName:SetText(GText(DataMgr.Resource[self.ResourceId].ResourceName))
        end
        if DataMgr.Resource[self.ResourceId].Rarity then
            --设置品质色
        end
        local IconPath = DataMgr.Resource[self.ResourceId].Icon
        if IconPath then
            local Img =LoadObject(IconPath)
            if Img then
                self.Image_DetailIcon:SetBrushResourceObject(Img)
            end
        end
    end
end

function M:InitTab()
    if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Touch then
        self.WS_ComTab:SetActiveWidgetIndex(1)
        self.Com_Tab = self.Com_Tab_M
    else
        self.WS_ComTab:SetActiveWidgetIndex(0)
        self.Com_Tab = self.Com_Tab_P
    end
    self.TabConfigData = {
        TitleName= GText("RESOURCE_NAME_6000002"),
        DynamicNode={"Back", "BottomKey"},
        StyleName="Text", OwnerPanel=self, BackCallback=self.OnClickBack,
        BottomKeyInfo = { { KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.OnClickBack, Owner=self,}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}},
    }
    if self.Com_Tab then
        self.Com_Tab:Init(self.TabConfigData)
    end
end

function M:RefreshBtn()
    if self:CheckItemEquipped() then
        self.WS_Btn:SetActiveWidgetIndex(1)
        self.Com_HudBubble:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Com_HudBubble:PlayOutAnimation()
    else
        self.WS_Btn:SetActiveWidgetIndex(0)
        self.Com_HudBubble:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Com_HudBubble:PlayInAndLoopAnimation()
    end
end

function M:PlayInAnimation()
    self:PlayAnimation(self.In)
    self.WBP_Activity_Fool_BG:PlayAnimation(self.WBP_Activity_Fool_BG.In)
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "FoolArchiveOpenSound", nil)
end

function M:InitItemList()
    local Avatar = GWorld:GetAvatar()
    local CurNum = 0
    local SumNum = 0
    if self:CheckUnlockedFoolsDayTransformsIsNotEmpty() then
        self.WS_List:SetActiveWidgetIndex(0)
        local TransformInfos = {}
        local TransformAFDayEvent = DataMgr.TransformAFDayEvent
        for _,Info in pairs(TransformAFDayEvent) do
            SumNum = SumNum + 1
            local TransformInfo = {}
            if Avatar.UnlockedFoolsDayTransforms[Info.TransformID] then
                CurNum = CurNum + 1
                TransformInfo.Islock = false
            else
                TransformInfo.Islock = true
            end
            TransformInfo.TransformID = Info.TransformID
            TransformInfo.Icon = Info.Icon
            table.insert(TransformInfos, TransformInfo)
        end
        table.sort(TransformInfos, function (a,b)
            if a.Islock then
                if b.Islock then
                    return a.TransformID < b.TransformID
                else
                    return false
                end
            else
                if b.Islock then
                    return true
                else
                    return a.TransformID < b.TransformID
                end
            end
        end)
        local ClassPath = '/Game/UI/UI_PC/Common/Common_Item_subsize_PC_Content.Common_Item_subsize_PC_Content_C'
        self.List_Item:ClearListItems()
        for Index,Info in ipairs(TransformInfos) do
            local Content = NewObject(UE4.LoadClass(ClassPath))
            Content.Islock = Info.Islock
            Content.IconPath = Info.Icon
            Content.NotInteractive = true
            self.List_Item:AddItem(Content)
        end
        self.List_Item:RequestPlayEntriesAnim()
    else
        self.WS_List:SetActiveWidgetIndex(1)
        local TransformAFDayEvent = DataMgr.TransformAFDayEvent
        for _,Info in pairs(TransformAFDayEvent) do
            SumNum = SumNum + 1
        end
    end
    self.Text_Num01:SetText(CurNum)
    self.Text_Num02:SetText(SumNum)
    self:AddTimer(0.1, function()
        if UIUtils.GetMaxScrollOffsetOfListView(self.List_Item) > 0 then
            self:InitNormalTab(true)
        else
            self:InitNormalTab(false)
        end
    end)
end

function M:OnReturnKeyDown()
    UIUtils.PlayCommonBtnSe(self)
    self:OnClickBack()
end

function M:OnClickBack()
    if self:IsAnimationPlaying(self.In) then
        return
    end
    self:PlayOutAnimation()
end

function M:PlayOutAnimation()
    if self:IsAnimationPlaying(self.Out) then
        return
    end
    self:BindToAnimationFinished(self.Out, {self, self.Close})
    self:PlayAnimation(self.Out)
    AudioManager(self):SetEventSoundParam(self, "FoolArchiveOpenSound", {ToEnd=1})
end

function M:Close()
    self.Super.Close(self)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == UIConst.GamePadKey.FaceButtonRight) then
            IsEventHandled = true
            self:OnReturnKeyDown()
        elseif (InKeyName == UIConst.GamePadKey.SpecialLeft) then
            IsEventHandled = true
            self:OnDetailClicked()
        -- elseif (InKeyName == UIConst.GamePadKey.FaceButtonLeft) then
        --     IsEventHandled = true
        --     self.Btn_Start:OnBtnClicked()
        elseif (InKeyName == UIConst.GamePadKey.FaceButtonBottom) then
            if self.WS_Btn:GetActiveWidgetIndex() == 0 then
                IsEventHandled = true
                self:TryOpenArmoryDetailBattleWheel()
            end
		end
        if not IsEventHandled and self.Com_Tab then
            IsEventHandled = self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName)
        end
    else
        if (InKeyName == "Escape") then
            IsEventHandled = true
            self:OnReturnKeyDown()
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:TryOpenArmoryDetailBattleWheel()
    if self:CheckBattleWheelUnlock() then
        UIManager(self):LoadUINew("ArmoryDetail",{
            MainTabName = ArmoryUtils.ArmoryMainTabNames.BattleWheel
        })
    else
        local UIUnlockRule = DataMgr.UIUnlockRule["BattleWheel"]
        if UIUnlockRule and UIUnlockRule.UIUnlockDesc then
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(UIUnlockRule.UIUnlockDesc))
        end
    end
end

function M:CheckItemEquipped()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local Wheels = Avatar.Wheels
    for WheelIndex, WheelInfo in pairs(Wheels) do
        for SlotIndex, SlotInfo in pairs(WheelInfo) do
            if SlotInfo.ResourceId == self.ResourceId then
                return true
            end
        end
    end
    return false
end

function M:CheckBattleWheelUnlock()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    return Avatar:CheckUIUnlocked('BattleWheel')
end

function M:ReceiveEnterState(StackAction)
    M.Super.ReceiveEnterState(self,StackAction)
    self:RefreshBtn()
end

function M:InitHudBubble()
	local ConfigData = {
		Text = GText("AFDayEvent_TransformItem_Instruction"),
		ColorType = 0,
		Arrow = 7,
	}
	self.Com_HudBubble:Init(ConfigData)
end

-- function M:OnBtnHovered()
-- 	self.Com_HudBubble:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
-- end

-- function M:OnBtnUnhovered()
--     self.Com_HudBubble:SetVisibility(UIConst.VisibilityOp.Collapsed)
-- end

function M:OnRemovedFromFocusPath(InFocusEvent)
    if ModController:IsGamepad() then
        self.Tips_MenuAnchor:CloseItemDetailsWidget()
    end
end

function M:OnDetailClicked()
    self:StopAllDetailBtnAnimations()
	self:PlayAnimation(self.DetailBtn_Click)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    -- Content.ItemType = DataMgr.Resource[self.ResourceId].Type
    Content.ItemType = "Resource"
    Content.ItemId = DataMgr.Resource[self.ResourceId].ResourceId
    Content.IsShowDetails = true
    self.Tips_MenuAnchor:OpenItemDetailsWidget(false, Content)
end

function M:BP_GetDesiredFocusTarget()
    return self
end

function M:InitWidgetInfoInGamePad()
    if self.ImageDetail_Controller then
        self.ImageDetail_Controller:CreateCommonKey(
            {
                KeyInfoList = {{Type = "Img",ImgShortPath = "View"}},
            }
        )
    end
    if self.Btn_Find then
        self.Btn_Find:SetGamePadImg("A")
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        return
    end
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
end

function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    if IsUseKeyAndMouse then
		self:InitKeyboardView()
	else
		self:InitGamepadView()
	end
end

function M:InitGamepadView()
    self.WS_DetailImg:SetActiveWidgetIndex(1)
    self:SetFocus()
end

function M:InitKeyboardView()
    self.WS_DetailImg:SetActiveWidgetIndex(0)
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == UIConst.GamePadKey.RightAnalogY) then
        if self.WS_List:GetActiveWidgetIndex() == 0 then
            local DeltaOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
            local CurrentOffset = self.List_Item:GetScrollOffset()
            local NextOffset = math.clamp(CurrentOffset - DeltaOffset,0, UIUtils.GetMaxScrollOffsetOfListView(self.List_Item))
            self.List_Item:SetScrollOffset(NextOffset)
            return UIUtils.Handled
        end
    end
    return UIUtils.Unhandled
end

function M:InitNormalTab(ShowScrollBtn)
    local BottomKeyInfo = {
        {
            KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.OnClickBack, Owner=self}},
            GamePadInfoList = {{Type="Img", ImgShortPath="B"}},
            Desc = GText("UI_BACK"),
            bLongPress = false
        }
    }
    if ShowScrollBtn then
        table.insert(BottomKeyInfo,1,{
            GamePadInfoList = {{Type="Img", ImgShortPath="RV"}},
            Desc = GText("UI_Controller_Slide"),
            bLongPress = false
        })
    end
    if self.Com_Tab.UpdateBottomKeyInfo then
        self.Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo, false)
    end
end

function M:InitMenuOpenTab()
    local BottomKeyInfo = {
        {
            KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.OnClickBack, Owner=self}},
            Desc = GText("UI_BACK"),
            bLongPress = false
        }
    }
    if self.Com_Tab.UpdateBottomKeyInfo then
        self.Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo, false)
    end
end

function M:CheckUnlockedFoolsDayTransformsIsNotEmpty()
    local Avatar = GWorld:GetAvatar()
    if not Avatar or not Avatar.UnlockedFoolsDayTransforms then
        return false
    end
    local TransformAFDayEvent = DataMgr.TransformAFDayEvent
    for _,Info in pairs(TransformAFDayEvent) do
        if Avatar.UnlockedFoolsDayTransforms[Info.TransformID] then
            return true
        end
    end
    return false
end

function M:OnDetailHovered()
	self.IsHovering = true
	if self.IsPressing then
        return
    end
	self:StopAllDetailBtnAnimations()
    self:PlayAnimation(self.DetailBtn_Hover)
end

function M:OnDetailUnhovered()
	self.IsHovering = false
	if not self.IsPressing then
		self:StopAllDetailBtnAnimations()
		self:PlayAnimation(self.DetailBtn_UnHover)
	end
end

function M:OnDetailPressed()
	self.IsPressing = true
	self:StopAllDetailBtnAnimations()
    self:PlayAnimation(self.DetailBtn_Press)
end

function M:OnDetailReleased()
    self.IsPressing = false
    if not self.IsHovering then
        self:StopAllDetailBtnAnimations()
        self:PlayAnimation(self.DetailBtn_Normal)
    else
        self:StopAllDetailBtnAnimations()
        self:PlayAnimation(self.DetailBtn_Hover)
    end
end

function M:StopAllDetailBtnAnimations()
    if self:IsAnimationPlaying(self.DetailBtn_Normal) then
        self:StopAnimation(self.DetailBtn_Normal)
    end
    if self:IsAnimationPlaying(self.DetailBtn_Hover) then
        self:StopAnimation(self.DetailBtn_Hover)
    end
    if self:IsAnimationPlaying(self.DetailBtn_UnHover) then
        self:StopAnimation(self.DetailBtn_UnHover)
    end
    if self:IsAnimationPlaying(self.DetailBtn_Press) then
        self:StopAnimation(self.DetailBtn_Press)
    end
    if self:IsAnimationPlaying(self.DetailBtn_Click) then
        self:StopAnimation(self.DetailBtn_Click)
    end
end

function M:InitMenuOpenChangedListen()
    self.Tips_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self,self.OnMenuOpenChanged)
end

function M:ClearMenuOpenChangedListen()
    self.Tips_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Remove(self, self.OnMenuOpenChanged)
end

function M:OnMenuOpenChanged(bIsOpen)
    if(not bIsOpen) then
        self:StopAllDetailBtnAnimations()
        self:PlayAnimation(self.DetailBtn_Normal)
        self.Btn_Detail:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Btn_Detail:SetChecked(false)
        if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
            self.Btn_Find:SetGamePadVisibility(UIConst.VisibilityOp.HitTestInvisible)
        end
        if UIUtils.GetMaxScrollOffsetOfListView(self.List_Item) > 0 then
            self:InitNormalTab(true)
        else
            self:InitNormalTab(false)
        end
    else
        if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
            self.Btn_Find:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
            self:InitMenuOpenTab()
        end
    end
end

return M
