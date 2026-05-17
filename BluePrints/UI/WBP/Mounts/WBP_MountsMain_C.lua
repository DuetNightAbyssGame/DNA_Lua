--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local ActorController = require "BluePrints.UI.WBP.Armory.ActorController.Armory_ActorController"

---@type WBP_MountsMain_P_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

M._components = {
    "BluePrints.UI.WBP.Armory.MainComponent.Armory_PointerInputComponent",
}

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self:AddDispatcher(EventID.OnGetLicense, self, self.OnGetLicense)
    self:AddDispatcher(EventID.MountsItemOnClick , self, self.MountsItemOnClick)
    if not self.IsBind then
        self.IsBind = true
        self.Image_Click.OnMouseButtonDownEvent:Bind(self, self.On_Image_Click_MouseButtonDown)
    end
    self.Mounts_License.Btn_Area.OnClicked:Add(self, self.OnLicenseBtn_OnClicked)
    
    local PCState = {
        Enter = function()
            self:EnterPCState()
        end,
        Leave = function()
            self:LeavePCState()
        end
    }
    local MainState = {
        Enter = function()
            self:EnterMainState()
        end,
        Leave = function()
            self:LeaveMainState()
        end
    }
    local SortState = {
        Enter = function()
            self:EnterSortState()
        end,
        Leave = function()
            self:LeaveSortState()
        end
    }
    local ItemState = {
        Enter = function()
            self:EnterItemState()
        end,
        Leave = function()
            self:LeaveItemState()
        end,
        CanReach = function() 
            return self:CanReachItemState()
        end
    }
    self.States = {
        ["PC"] = PCState,
        ["Main"] = MainState,
        ["Sort"] = SortState,
        ["Item"] = ItemState,
    }
end

function M:EnterPCState()
    self.WBP_MountsMain_Item02.Key_Method:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Mounts_License.Key_License:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:InitMountBottomTab()
end

function M:LeavePCState()
    
end

function M:EnterMainState()
    self.ListView_Items:SetFocus()
    self:InitMountBottomTab()
    if UIUtils.IsGamepadInput() then
        self.Mounts_License.Key_License:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        if not self.AllMethodSubWidgetList or #self.AllMethodSubWidgetList <= 0 then
            self.WBP_MountsMain_Item02.Key_Method:SetVisibility(UIConst.VisibilityOp.Collapsed)
        else
            self.WBP_MountsMain_Item02.Key_Method:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end
    end
end

function M:LeaveMainState()
    self.Mounts_License.Key_License:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:EnterSortState()
    self.Common_Sort_List:SetFocus()
end

function M:LeaveSortState()
    
end

function M:EnterItemState()
    self.AllMethodSubWidgetList[1]:SetFocus()
    self.Common_Sort_List:SetControllerKeyHidden(true)
    if UIUtils.IsGamepadInput() then
        self.WBP_MountsMain_Item02.Key_Method:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self:InitItemDetailAccessTab()
    end
end

function M:LeaveItemState()
    self.Common_Sort_List:SetControllerKeyHidden(false)
end

function M:CanReachItemState()
    if not self.AllMethodSubWidgetList or #self.AllMethodSubWidgetList <= 0 then
        return false
    end
    return true
end

function M:UpdateCurState(StateType)
    if not self.States[StateType] then
        return
    end
    if self.StateType == StateType then
        return
    end
    local NextState = self.States[StateType]
    local Res = true
    if NextState.CanReach then
        Res = NextState:CanReach()
    end
    if not Res then
        return
    end
    if self.StateType and self.States[self.StateType] then
        self.States[self.StateType]:Leave()
    end
    self.StateType = StateType
    NextState:Enter()
end

function M:OnUpdateUIStyleByInputTypeChange()
    if UIUtils.IsGamepadInput() then
        self:UpdateCurState("Main")
    else
        self:UpdateCurState("PC")
    end
end

function M:OnGetLicense()
    self:InitLicenseRedDot()
end

function M:OnLicenseBtn_OnClicked()
    UIManager(self):LoadUINew("MountLicense")
end

function M:MountsItemOnClick(SelectMountId)
    if self.DisplayMountId == SelectMountId then
        return
    end
    self.DisplayMountId = SelectMountId
    self:RefreshMountModel()
    self:InitMountInfoUI()
end

function M:GetDisplayMountId()
    return self.DisplayMountId
end

function M:ReceiveEnterState(StackAction)
    self:StopAnimation(self.Out)
    self:PlayAnimation(self.In)
    self.Super.ReceiveEnterState(self, StackAction)
end

function M:ReceiveExitState(StackAction)
    if StackAction == 0 then
        self:StopAnimation(self.In)
        self:PlayAnimation(self.Out)
    end
    self.Super.ReceiveExitState(self, StackAction)
end

function M:OnLoaded(SelectMountId)
    self.bSelfHidden = false
    self.IsRiderMount = true
    if self.WBP_MountsMainBtn then
        self.WBP_MountsMainBtn.Btn_Riding:ChangeMountIcon(not self.IsRiderMount)
    end
    self.IsPlayOut = false
    self.DisplayMountId = SelectMountId
    self:InitCommonTab()
    self:InitMountsList()
    self:CreateMount()
    self:InitMountInfoUI()
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "MountsMain", nil)
    if self.WBP_MountsMainBtn then
        self.WBP_MountsMainBtn.Btn_Hide:BindEvents(self, {OnClicked = self.HideMountUI})
        self.WBP_MountsMainBtn.Btn_Riding:BindEvents(self, {OnClicked = self.RiderMount})
    end
    if UIUtils.IsGamepadInput() then
        self:UpdateCurState("Main")
    else
        self:UpdateCurState("PC")
    end
    self:OnUpdateUIStyleByInputTypeChange()
end

function M:InitCommonTab()
    self.Com_Tab:Init(
    {
        DynamicNode = {"Back", "BottomKey"},
        BottomKeyInfo = {},
        TitleName = GText("UI_Mount"),
        StyleName = "Text", OwnerPanel = self, BackCallback = self.CloseSelf,
    })
    self.WBP_MountsMain_Item02.Key_Method:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "Menu",
            },
        },
    })
    self.WBP_MountsMain_Item02.Key_MountsDeco:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "Right",
            },
        },
    })
    self.Mounts_License.Key_License:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "Y",
            },
        },
    })
end

function M:InitItemDetailAccessTab()
    self.Com_Tab:UpdateBottomKeyInfo({
        {
            GamePadInfoList =  {{Type = "Img", ImgShortPath = "A", Owner = self}},
            Desc = GText("UI_Tips_Ensure"),
            bLongPress = false,
        },
        {
            GamePadInfoList = {{Type = "Img", ImgShortPath = "B"}},
            Desc = GText("UI_BACK"), bLongPress = false
        }
    })
end

function M:InitMountBottomTab()
    if self.Com_Tab.UpdateBottomKeyInfo then
        self.Com_Tab:UpdateBottomKeyInfo({
            {
                KeyInfoList = {{Type = "Text", ImgShortPath = "R", ClickCallback = self.RiderMount, Owner = self}},
                GamePadInfoList = {{Type = "Img", ImgShortPath = "RS"}},
                Desc = GText("UI_CTL_Ride")
            },
            {
                KeyInfoList = {{Type = "Text", Text = CommonUtils:GetKeyText("U"), ClickCallback = self.HideMountUI, Owner = self}},
                GamePadInfoList = {{Type = "Img", ImgShortPath = "X"}},
                Desc = GText("UI_Dye_HideUI")
            },
            {
                KeyInfoList = {{Type = "Text", Text = CommonUtils:GetKeyText("Mouse_Button"), Owner = self}},
                GamePadInfoList = {
                    {
                        Type = "Or",
                        ImgShortPath = "RT",
                        Owner = self
                    },
                    GamePadSubKeyInfoList =
                    {{
                         Type = "Img",
                         ImgShortPath = "LT",
                         Owner = self
                     },
                     {
                         Type = "Img",
                         ImgShortPath = "RT",
                         Owner = self
                     }}
                },
                Desc = GText("UI_Dye_Zoom")
            },
            {
                GamePadInfoList = {{Type = "Img", ImgShortPath = "RH"}},
                Desc = GText("UI_CTL_RotatePreview")
            },
            {
                KeyInfoList = {{Type = "Text", Text = "Esc", ClickCallback = self.CloseSelf, Owner = self}},
                GamePadInfoList = {{Type = "Img", ImgShortPath = "B"}},
                Desc = GText("UI_BACK")
            },
        })
    end
end

function M:RiderMount()
    self.IsRiderMount = not self.IsRiderMount
    self.ActorController:HidePlayerOnMount(not self.IsRiderMount)
    if self.WBP_MountsMainBtn then
        self.WBP_MountsMainBtn.Btn_Riding:ChangeMountIcon(not self.IsRiderMount)
    end
end

function M:HideMountUI()
    self.bSelfHidden = not self.bSelfHidden
    if self.bSelfHidden then
        self.Image_Click.Slot:SetZOrder(10)
        self.Image_Click:SetFocus()
        self:SetRenderOpacity(0)
    else
        self.Image_Click.Slot:SetZOrder(-1)
        self:SetRenderOpacity(1)
        if self.StateType == "Main" then
            self.ListView_Items:SetFocus()
        elseif self.StateType == "Sort" then
            self.Common_Sort_List:SetFocus()
        end
    end
end

function M:OnCameraScrollBackwardKeyDown()
    self:ScrollCamera(1)
end

function M:OnCameraScrollForwardKeyDown()
    self:ScrollCamera(-1)
end

function M:ScrollCamera(DeltaMove)
    if self.ActorController then
        self.ActorController:OnScrolling(DeltaMove)
    end
end

function M:SortMountListForNormal(SortType)
    if not self.MountContents then
        return
    end
    SortType = SortType or CommonConst.DESC
    if SortType == CommonConst.DESC then
        table.sort(self.MountContents, function(MountA, MountB)
            if MountA.HasMount == MountB.HasMount then
                return MountA.SortPriority > MountB.SortPriority
            end
            return MountA.HasMount
        end)
    else
        table.sort(self.MountContents, function(MountA, MountB)
            if MountA.HasMount == MountB.HasMount then
                return MountA.SortPriority < MountB.SortPriority
            end
            return not MountA.HasMount
        end)
    end
end

function M:SortMountListForRarity(SortType)
    if not self.MountContents then
        return
    end
    SortType = SortType or CommonConst.DESC
    if SortType == CommonConst.DESC then
        table.sort(self.MountContents, function(MountA, MountB)
            if MountA.HasMount == MountB.HasMount then
                if MountA.MountRarity ~= MountB.MountRarity then
                    return MountA.MountRarity > MountB.MountRarity
                end
                return MountA.SortPriority > MountB.SortPriority
            end
            return MountA.HasMount
        end)
    else
        table.sort(self.MountContents, function(MountA, MountB)
            if MountA.HasMount == MountB.HasMount then
                if MountA.MountRarity ~= MountB.MountRarity then
                    return MountA.MountRarity < MountB.MountRarity
                end
                return MountA.SortPriority < MountB.SortPriority
            end
            return not MountA.HasMount
        end)
    end
end

function M:InitMountsList()
    self.ListView_Items:ClearListItems()
    self.MountContents = nil
    
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    
    local MountConfigData = DataMgr.Mount or {}
    
    local MountContents = {}
    for _, MountData in pairs(MountConfigData) do
        local MountContent = NewObject(UIUtils.GetCommonItemContentClass())
        MountContent.MountId = MountData.MountId
        MountContent.HasMount = Avatar:HasMountById(MountData.MountId)
        MountContent.MountId = MountData.MountId
        MountContent.SortPriority = MountData.SortPriority
        MountContent.MountRarity = MountData.MountRarity
        table.insert(MountContents, MountContent)
    end
    
    if #MountContents == 0 then
        return
    end
    
    self.MountContents = MountContents
    self:SortMountListForNormal()
    self.DisplayMountId = self.DisplayMountId or MountContents[1].MountId
    self:RefreshMountList()
    
    self.SortByFunction = {[1] = self.SortMountListForNormal, [2] = self.SortMountListForRarity}
    self.Common_Sort_List:Init(self, {GText("UI_Select_Default"), GText("UI_Select_Unique")}, CommonConst.DESC, {
        OnGetBackFocusWidget = function()
            self:UpdateCurState("Main")
        end
    })
    self.Common_Sort_List:BindEventOnSelectionsChanged(self, self.MountsMainOnSelectionsChanged)
    self.Common_Sort_List:BindEventOnSortTypeChanged(self, self.MountsMainOnSortTypeChanged)
end

function M:RefreshMountList()
    self.ListView_Items:ClearListItems()
    
    local MountSelectIndex
    for Index, MountContent in ipairs(self.MountContents) do
        MountContent.ItemIndex = Index
        MountContent.MountsMain = self
        self.ListView_Items:AddItem(MountContent)
        if MountContent.MountId == self.DisplayMountId and not MountSelectIndex then
            MountSelectIndex = Index
        end
    end
    if MountSelectIndex then
        self.ListView_Items:NavigateToIndex(MountSelectIndex - 1)
    end

    self.ListView_Items.OnCreateEmptyContent:Bind(self, function(self)
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        Obj.IsEmpty = true
        return Obj
    end)
    self.ListView_Items:RequestFillEmptyContent()
end

function M:MountsMainOnSelectionsChanged(SortBy, SortType)
    self.SortByFunction[SortBy](self, SortType)
    self:RefreshMountList()
end

function M:MountsMainOnSortTypeChanged(SortType, SortBy)
    self.SortByFunction[SortBy](self, SortType)
    self:RefreshMountList()
end

function M:CreateMount()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if self.ActorController then
        return
    end
    self.ActorController = ActorController:New({
        ViewUI = self,
        EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
        Char = Avatar.Chars[Avatar.CurrentChar],
        bEnableReflection = false,
    })
    self.ActorController:OnOpened()
    self.ActorController:SetArmoryCameraTag(CommonConst.ArmoryType.Char)
    self.ActorController:HidePlayerOnMount(not self.IsRiderMount)
    self.ActorController:CreateMount(self.DisplayMountId)
    self.ArmoryRotation = self.ActorController:GetArmoryPlayerRotation()
end

function M:RefreshMountModel()
    if not self.ActorController then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self.ActorController:SetArmoryPlayerRotation(self.ArmoryRotation)
    self.ActorController:HidePlayerOnMount(not self.IsRiderMount)
    self.ActorController:DestroyMount()
    self.ActorController:CreateMount(self.DisplayMountId)
end

function M:InitMountInfoUI()
    if not self.DisplayMountId then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local HasMount = Avatar:HasMountById(self.DisplayMountId)
    local MountConfig = DataMgr.Mount[self.DisplayMountId]
    self.Tag_Quality:Init(MountConfig.MountRarity)
    self.Text_SkinName:SetText(GText(MountConfig.MountName))
    local SkinNameFont = { nil, nil, "Font_Blue", "Font_Purple", "Font_Gold", "Font_Red"} --分别对应稀有度1，2，3，4，5，6
    if MountConfig.MountRarity and SkinNameFont[MountConfig.MountRarity] and self[SkinNameFont[MountConfig.MountRarity]] then
        self.Text_SkinName:SetFont(self[SkinNameFont[MountConfig.MountRarity]])
    end
    self.Text_Info:SetText(GText(MountConfig.MountDes))
    self.WBP_MountsMain_Item02.HB_Method:SetVisibility((not MountConfig.AccessKey or HasMount) and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WBP_MountsMain_Item02.Method:SetVisibility((not MountConfig.AccessKey or HasMount) and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WBP_MountsMain_Item02.Panel_Message:SetVisibility(not MountConfig.UseLimitDes and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WBP_MountsMain_Item02.Text_Message:SetVisibility(not MountConfig.UseLimitDes and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WBP_MountsMain_Item02.Text_Message:SetText(GText(MountConfig.UseLimitDes))
    self.WBP_MountsMain_Item02.Text_Method:SetText(GText("UI_Tips_Obtining"))
    self.WBP_MountsMain_Item02.Method:ClearChildren()
    if MountConfig.AccessKey then
        for _, Access in pairs(MountConfig.AccessKey) do
            PageJumpUtils:GetItemAccess(self.WBP_MountsMain_Item02, self.DisplayMountId, "Mount", Access, "MountsMain")
        end
    end
    PageJumpUtils:SortAccessItem(self.WBP_MountsMain_Item02.Method)
    local Method = self.WBP_MountsMain_Item02.Method
    local ChildrenCount = Method:GetChildrenCount()
    local IsHideMethod = ChildrenCount == 0 or not MountConfig.AccessKey
    self.WBP_MountsMain_Item02.Text_Method:SetVisibility(IsHideMethod and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.SelfHitTestInvisible)
    self.AllMethodSubWidgetList = {}
    for i = 1, ChildrenCount do
        local TestWidget = Method:GetChildAt(i - 1)
        if TestWidget and not TestWidget.IsText then
            TestWidget:SetNavigationRuleCustom(EUINavigation.Left, {self, function()
                return TestWidget
            end})
            TestWidget:SetNavigationRuleCustom(EUINavigation.Right, {self, function()
                return TestWidget
            end})
            table.insert(self.AllMethodSubWidgetList, TestWidget)
        end
    end
    self.Mounts_License.Text_License:SetText(GText("UI_Mount_FlyLicense"))
    self.Mounts_License.Text_Area:SetText(GText("UI_Mount_FlyLicense_Activated"))
    self.Mounts_License.Num_Now:SetText(CommonUtils.TableLength(Avatar.MountFlyLicenses))
    local Count = 0
    for i, v in pairs(DataMgr.FlyLicense) do
        Count = Count + 1
    end
    self.Mounts_License.Num_Total:SetText(Count)
    self.WBP_MountsMain_Item02.Btn_Dye:SetText(not HasMount and GText("UI_CharPreview_Cannot_Dye") or GText("UI_Skin_Gotodye"))
    self.WBP_MountsMain_Item02.Text_MountsDeco:SetText(GText("UI_SHOP_MAINTAB_SKIN"))
    if not HasMount then
        self.WBP_MountsMain_Item02.Btn_Dye:PlayButtonForbidAnim()
    end
    self.WBP_MountsMain_Item02.Btn_Dye:ForbidBtn(not HasMount)
    self.WBP_MountsMain_Item02.Btn_Dye:SetGamePadImg("X")
    -- 设置当前选中的MountId到子组件
    self.WBP_MountsMain_Item02.MountId = self.DisplayMountId
    self.WBP_MountsMain_Item02.MountsMain = self
    self.WBP_MountsMain_Item02.MountsDeco:OnListItemObjectSet({
        IconPath = '/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_MountHead.T_Tab_Fashion_MountHead',
        IsNoneIcon = true,
    })
    self.WBP_MountsMain_Item02.MountsDeco_1:OnListItemObjectSet({
        IconPath = '/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_MountTail.T_Tab_Fashion_MountTail',
        IsNoneIcon = true,
    })
    self:InitLicenseRedDot()
    if UIUtils.IsGamepadInput() and self.StateType == "Main" then
        if self.AllMethodSubWidgetList and #self.AllMethodSubWidgetList > 0 then
            self.WBP_MountsMain_Item02.Key_Method:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        else
            self.WBP_MountsMain_Item02.Key_Method:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
end

function M:InitLicenseRedDot()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local Count = 0
    for i, v in pairs(DataMgr.FlyLicense) do
        Count = Count + 1
    end
    self.Mounts_License.Num_Now:SetText(CommonUtils.TableLength(Avatar.MountFlyLicenses))
    self.Mounts_License.Num_Total:SetText(Count)
    local RedDot = ReddotManager.GetTreeNode("MountLicense_Item")
    self.Mounts_License.Reddot:SetVisibility(RedDot and RedDot.Count > 0 and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:Destruct()
    self.DisplayMountId = nil
    if self.ActorController then
        self.ActorController:DestroyMount()
        self.ActorController:OnDestruct()
        self.ActorController = nil
    end
    self.Super.Destruct(self)
end

function M:HandleGamepadInput(InKeyName, InAnalogInputEvent)
    if self.StateType == "Item" then
        if InKeyName == "Gamepad_FaceButton_Right" then
            self:UpdateCurState("Main")
        end
        return
    end
    if InKeyName == "Gamepad_FaceButton_Left" then
        self:HideMountUI()
    elseif InKeyName == "Gamepad_LeftThumbstick" then
        self:UpdateCurState("Sort")
    elseif InKeyName == "Gamepad_FaceButton_Top" then
        self:OnLicenseBtn_OnClicked()
    elseif InKeyName == "Gamepad_FaceButton_Right" then
        if self.StateType == "Main" then
            self:CloseSelf()
        else
            self:UpdateCurState("Main")
        end
    elseif InKeyName == "Gamepad_RightThumbstick" then
        self:RiderMount()
    elseif InKeyName == "Gamepad_Special_Right" then
        self:UpdateCurState("Item")
    elseif InKeyName == UIConst.GamePadKey.LeftTriggerThreshold then
        self:OnCameraScrollBackwardKeyDown()
        return true
    elseif InKeyName == UIConst.GamePadKey.RightTriggerThreshold then
        self:OnCameraScrollForwardKeyDown()
        return true
    elseif InKeyName == "Gamepad_RightX" then
        if self.ActorController then
            local DeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
            self.ActorController:OnDragViewActor({ X = DeltaX})
        end
        return true
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == "Escape" then
        self:CloseSelf()
    elseif InKeyName == "R" then
        self:RiderMount()
    elseif InKeyName == "U" then
        self:HideMountUI()
    else
        self:HandleGamepadInput(InKeyName)
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnRepeatKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    local Res = self:HandleGamepadInput(InKeyName)
    if Res then
        IsEventHandled = true
    end
    return IsEventHandled
end

function M:OnAnimationFinished(Animation)
    if Animation == self.Out and self.IsPlayOut then
        self:Close()
        self.IsPlayOut = false
    end
end

function M:Close()
    AudioManager(self):SetEventSoundParam(self, "MountsMain", {ToEnd = 1})
    self.Super.Close(self)
end

function M:CloseSelf()
    if self.IsPlayOut then
        return
    end
    self.IsPlayOut = true
    self:PlayAnimation(self.Out)
end

function M:On_Image_Click_MouseButtonDown(MyGeometry, MouseEvent)
    return self:OnPointerDown(MyGeometry, MouseEvent)
end

function M:OnMouseWheel(MyGeometry, MouseEvent)
    return self:OnMouseWheelScroll(MyGeometry, MouseEvent)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
    return self:OnPointerUp(MyGeometry, MouseEvent)
end

function M:OnMouseMove(MyGeometry, MouseEvent)
    return self:OnPointerMove(MyGeometry, MouseEvent)
end

function M:OnTouchEnded(MyGeometry, InTouchEvent)
    return self:OnPointerUp(MyGeometry, InTouchEvent)
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
    return self:OnPointerMove(MyGeometry, InTouchEvent)
end

function M:OnMouseCaptureLost()
    self:OnPointerCaptureLost()
end

function M:OnBackgroundClicked()
    if self.bSelfHidden then
        self:HideMountUI()
    end
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local Res = self:HandleGamepadInput(InKeyName, InAnalogInputEvent)
    if Res then
        return UIUtils.Handled
    end
    return UIUtils.Unhandled
end

AssembleComponents(M)

return M
