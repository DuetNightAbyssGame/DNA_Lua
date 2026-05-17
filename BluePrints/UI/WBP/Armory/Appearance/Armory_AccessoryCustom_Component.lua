local FocusAreas = {CustomList = "CustomList",HiddenSelf = "HiddenSelf",}

local M = {}

local ELocationAxis = {X = "X",Y = "Y",Z = "Z"}
local ERotationAxis = {Pitch = "Pitch",Yaw = "Yaw",Roll = "Roll"}

function M:Construct()
    rawset(self,"AccessoryCustomTabConfig",{
        TitleName = GText("UI_Accessory_Custom_Name"),
        StyleName = self.TabStyleName,
        DynamicNode={
            "Back",
            "BottomKey",
        },
        BottomKeyInfo = {},
        BackCallback = self.OnBackKeyDown,
        OwnerPanel = self,
    })
end

---打开
function M:TryOpenAccessoryCustom()
    if(self.IsPreviewMode or self.IsCharacterTrialMode)then
        return UIUtils.Handled,true
    end
    if(self.ComparedContent and self.ComparedContent.bAllowCustom)then
        self:OpenAccessoryCustom(self.ComparedContent)
    end
    return UIUtils.Handled,true
end

function M:TryCloseAccessoryCustom()
    if(not self.IsTargetUnowned and not self.ComparedContent.LockType and self.CustomList:IsValueChanged())then
        UIManager(self):ShowCommonPopupUI(100307,{
            LeftCallbackFunction = function()
                self:RecoverAccessoryCustom()
                self:CloseAccessoryCustom()
            end,
            RightCallbackFunction = function()
                rawset(self,"bCloseAccessoryCustomWhenSave",true)
                self:OnSaveCustomBtnClicked()
            end
        },self)
    else
        if(self.ComparedContent.LockType or self.IsTargetUnowned)then
            self:RecoverAccessoryCustom()
        end
        return self:CloseAccessoryCustom()
    end
end

---关闭
function M:CloseAccessoryCustom()
    rawset(self,"bAccessoryCustomOpened",false)
    AudioManager(self):SetEventSoundParam(self,"AccessoryCustomOpened",{ToEnd=1})
    self:SetIsDealWithVirtualAccept(false)
    self.Tab_Skin:Init(self.TabConfig)
    self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
    self:UpdateAccessoryDetails(self.ComparedContent)
    self:PlayAccessoryCustomInAnim()
    self:ClearAccessoryCustomVariable()
    if(self.FSM)then
        if(self.FSM:Peak().Name == FocusAreas.CustomList)then
            self.FSM:Pop()
        end
        return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self:GetDesiredFocusTarget()),true
    end
end

function M:ClearAccessoryCustomVariable()
    rawset(self,"ComparedAccessoryPostionOffset",nil)
    rawset(self,"ComparedAccessoryRotationOffset",nil)
    rawset(self,"ComparedAccessoryScaleOffset",nil)
    rawset(self,"AccessoryPostionOffset",nil)
    rawset(self,"AccessoryRotationOffset",nil)
    rawset(self,"AccessoryScaleOffset",nil)
end


---保存成功回调
function M:OnCharAccessoryCustomChanged()
    if(not rawget(self,"bAccessoryCustomOpened"))then
        return
    end
    self:SaveCharAccessoryOffsetCache(self.AppearanceSuitIndex, self.ComparedContent.AccessoryId)
    self:UpdateAccessoryCustomBtnState()
    if(rawget(self,"bCloseAccessoryCustomWhenSave"))then
        self:CloseAccessoryCustom()
        return
    end
end

function M:UpdateAccessoryCustomBtnState()
    if(not self.IsTargetUnowned and self.ComparedContent and not self.ComparedContent.LockType and self.CustomList:IsValueChanged())then
        self.Btn_Function:ForbidBtn(false)
    else
        self.Btn_Function:ForbidBtn(true)
    end
end

---保存按钮点击、发RPC
function M:OnSaveCustomBtnClicked()
    if(self.IsPreviewMode or self.IsCharacterTrialMode or self.IsTargetUnowned)then
        return
    end
    if(not self.bAccessoryCustomOpened or not self.Btn_Function:IsVisible() or self.Btn_Function:IsBtnForbidden())then
        return
    end
    if(self.ComparedContent == self.CurrentContent)then
        local CustomParams = self:CreateCustomParamsByComparedOffset()
        self:BlockAllUIInput(true)
        local Avatar = GWorld:GetAvatar()
        Avatar:SetCharAppearanceAccessory(self.Target.Uuid, self.AppearanceSuitIndex, self.ComparedContent.AccessoryId,CustomParams)
    else
        self:SaveCharAccessoryOffsetCache(self.AppearanceSuitIndex, self.ComparedContent.AccessoryId)
        if(rawget(self,"bCloseAccessoryCustomWhenSave"))then
            self:CloseAccessoryCustom()
        end
    end
end

--全部重置按钮点击
function M:OnResetCustomBtnClicked()
    self:CreateDefaultAccessoryCustomOffset()
    self.CustomList:Init(self:CreateCustomListInitParams(self.ComparedContent))
    self:UpdateCharAccessoryOffset()
end

local CreateAccessoryCustomOffset = function(self,CustomParams)
    CustomParams = CustomParams or {}
    local Position = FVector(0,0,0)
    if(CustomParams.Position)then
        Position.X = CustomParams.Position.X or 0
        Position.Y = CustomParams.Position.Y or 0
        Position.Z = CustomParams.Position.Z or 0
    end

    local Rotation = FRotator(0,0,0)
    if(CustomParams.Rotation)then
        Rotation.Pitch = CustomParams.Rotation.Pitch or 0
        Rotation.Yaw = CustomParams.Rotation.Yaw or 0
        Rotation.Roll = CustomParams.Rotation.Roll or 0
    end

    local Scale = CustomParams.Scale or 1
    Scale = FVector(Scale,Scale,Scale)
    return Position,Rotation,Scale
end

---根据本地缓存创建偏移变量
function M:CreateComparedAccessoryCustomOffset(Content)
    local CustomParams
    if(Content == self.CurrentContent)then
        --已装备的配饰不适用缓存
        local Avatar = GWorld:GetAvatar()
        CustomParams = Avatar:GetCharAccessoryCustomParams(self.Target.Uuid,self.AppearanceSuitIndex,Content.AccessoryId) or {}
    elseif(Content.LockType)then
        --未拥有配饰不读缓存
    else
        CustomParams = self:GetCachedCharAccessoryCustomParams(self.AppearanceSuitIndex,Content.AccessoryId)
    end
    
    local Position,Rotation,Scale = CreateAccessoryCustomOffset(self,CustomParams)
    rawset(self,"ComparedAccessoryPostionOffset",Position)
    rawset(self,"ComparedAccessoryRotationOffset",Rotation)
    rawset(self,"ComparedAccessoryScaleOffset",Scale)
end

---根据实际值创建偏移变量
function M:CreateCurrentAccessoryCustomOffset(Content)
    local CustomParams
    --已装备的配饰以服务器数据为基准，未装备的以本地缓存为基准
    if(Content == self.CurrentContent)then
        local Avatar = GWorld:GetAvatar()
        CustomParams = Avatar:GetCharAccessoryCustomParams(self.Target.Uuid,self.AppearanceSuitIndex,Content.AccessoryId) or {}
    else
        CustomParams = self:GetCachedCharAccessoryCustomParams(self.AppearanceSuitIndex,Content.AccessoryId)
    end
    local Position,Rotation,Scale = CreateAccessoryCustomOffset(self,CustomParams)
    rawset(self,"AccessoryPostionOffset",Position)
    rawset(self,"AccessoryRotationOffset",Rotation)
    rawset(self,"AccessoryScaleOffset",Scale)
end

---创建未调整过的偏移变量
function M:CreateDefaultAccessoryCustomOffset()
    local Position,Rotation,Scale = CreateAccessoryCustomOffset(self)
    rawset(self,"ComparedAccessoryPostionOffset",Position)
    rawset(self,"ComparedAccessoryRotationOffset",Rotation)
    rawset(self,"ComparedAccessoryScaleOffset",Scale)
end

function M:GetCurrentAccessoryTransformOffset(AppearanceSuitIndex,AccessoryId)
    local AppearanceSuit = self.Target:GetAppearance(AppearanceSuitIndex)
    local AccessoryCustomParams = AppearanceSuit and AppearanceSuit.AccessoryCustomParams or {}
    local Transform = CommonUtils.UnSerializeAccessoryCustomParams(AccessoryCustomParams[AccessoryId])
    return Transform
end

local GetSuitAccessoryCustomCache = function(self,AppearanceSuitIndex)
    self.CharAccessoryOffsetCache = EMCache:Get("CharAccessoryOffset",true) or {}
    self.CharAccessoryOffsetCache[self.Target.CharId] = self.CharAccessoryOffsetCache[self.Target.CharId] or {}
    local CharCache = self.CharAccessoryOffsetCache[self.Target.CharId]
    CharCache[AppearanceSuitIndex] = CharCache[AppearanceSuitIndex] or {}
    return CharCache[AppearanceSuitIndex]
end

function M:GetCachedAccessoryTransformOffset(AppearanceSuitIndex,AccessoryId)
    local AppearanceCache = GetSuitAccessoryCustomCache(self,AppearanceSuitIndex)
    AppearanceCache[AccessoryId] = AppearanceCache[AccessoryId] or ""
    local Transform = CommonUtils.UnSerializeAccessoryCustomParams(AppearanceCache[AccessoryId])
    return Transform
end

function M:GetAccessoryTransformOffset(Content)
    if(Content.LockType)then
        return
    end
    if(Content == self.CurrentContent)then
        return self:GetCurrentAccessoryTransformOffset(self.AppearanceSuitIndex,Content.AccessoryId)
    end
    return self:GetCachedAccessoryTransformOffset(self.AppearanceSuitIndex,Content.AccessoryId)
end

function M:GetCachedCharAccessoryCustomParams(AppearanceSuitIndex,AccessoryId)
    local AppearanceCache = GetSuitAccessoryCustomCache(self,AppearanceSuitIndex)
    AppearanceCache[AccessoryId] = AppearanceCache[AccessoryId] or ""
    return SerializeUtils:UnSerialize(AppearanceCache[AccessoryId])
end

---保存角色配饰偏移到本地缓存
function M:SaveCharAccessoryOffsetCache(AppearanceSuitIndex,AccessoryId)
    if(not AccessoryId)then
        return
    end
    local AppearanceCache = GetSuitAccessoryCustomCache(self,AppearanceSuitIndex)
    local CustomParams = self:CreateCustomParamsByComparedOffset()
    local SerializedParams = SerializeUtils:Serialize(CustomParams)
    AppearanceCache[AccessoryId] = SerializedParams
    EMCache:Set("CharAccessoryOffset",self.CharAccessoryOffsetCache, true)

    self:CreateCurrentAccessoryCustomOffset(self.ComparedContent)
    self.CustomList:Init(self:CreateCustomListInitParams(self.ComparedContent))
    self:UpdateAccessoryCustomBtnState()
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_PersonInfo_Saved"))
end

function M:CreateCustomParamsByComparedOffset()
    if(not self.ComparedAccessoryScaleOffset)then
        return {}
    end
    local CustomParams = {
        Scale = self.ComparedAccessoryScaleOffset.X,
        Position = {X = self.ComparedAccessoryPostionOffset.X,Y = self.ComparedAccessoryPostionOffset.Y,Z = self.ComparedAccessoryPostionOffset.Z},
        Rotation = {Pitch = self.ComparedAccessoryRotationOffset.Pitch,Yaw = self.ComparedAccessoryRotationOffset.Yaw,Roll = self.ComparedAccessoryRotationOffset.Roll},
    }
    return CustomParams
end

function M:PlayAccessoryCustomInAnim()
    self:BlockAllUIInput(true,"SP_DisplayOnly")
    self:StopAnimation(self.Out)
    self:PlayAnimation(self.In)
end

function M:OpenAccessoryCustom(Content)
    rawset(self,"bAccessoryCustomOpened",true)
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "AccessoryCustomOpened", nil)
    self:SetIsDealWithVirtualAccept(true)
    self:CreateComparedAccessoryCustomOffset(Content)
    self:CreateCurrentAccessoryCustomOffset(Content)
    self.Tab_Skin:Init(self.AccessoryCustomTabConfig)
    self.WidgetSwitcher_State:SetActiveWidgetIndex(3)
    self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(0)
    self.WS_Btn:SetActiveWidgetIndex(1)
    self.Panel_Buy:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Function:UnBindEventOnClickedByObj(self)
    if(Content.LockType)then
        self.Btn_Function:SetText(GText("UI_Aaccessory_Locked"))
    else
        self.Btn_Function:SetText(GText("UI_CustomLayout_Save"))
        self.Btn_Function:BindEventOnClicked(self,self.OnSaveCustomBtnClicked)
    end
    self.Btn_Custom:UnBindEventOnClickedByObj(self)
    self.Btn_Custom:BindEventOnClicked(self,self.OnResetCustomBtnClicked)
    self.WS_Icon:SetActiveWidgetIndex(1)
    local Panel = self.WidgetSwitcher_State:GetActiveWidget()
    local CustomList = Panel:GetChildAt(1)
    if(not CustomList)then
        CustomList = UIManager(self.GameInstance):CreateWidget("WidgetBlueprint'/Game/UI/WBP/Armory/Widget/Appearance/WBP_Armory_CustomList.WBP_Armory_CustomList'")
    end
    rawset(self,"CustomList",CustomList)
    if(not rawget(self,"CustomList"))then
        return
    end

    if(self.FSM)then
        CustomList.BP_OnAddedToFocusPath:Clear()
        CustomList.BP_OnAddedToFocusPath:Add(self,self.OnCustomListAddedToFocusPath)
    end

    local Anchors = CustomList.Slot:GetAnchors()
    Anchors.Minimum = FVector2D(0.0, 0.0)
    Anchors.Maximum = FVector2D(1.0, 1.0)
    CustomList.Slot:SetAnchors(Anchors)    
    CustomList:Init(self:CreateCustomListInitParams(Content))
    self:UpdateAccessoryCustomBtnState()
    self:PlayAccessoryCustomInAnim()
    CustomList:SetFocus()
end

function M:CreateCustomListInitParams(Content)
    if(not Content or not Content.bAllowCustom)then
        return
    end
    local CustomOffsetData = DataMgr.CustomOffset[Content.AccessoryType]
    if(not CustomOffsetData)then
        return
    end
    local ScaleMax = CustomOffsetData.ScaleLimit[2] or 2
    local ScaleMin = CustomOffsetData.ScaleLimit[1] or 0
    local ScaleStep = CustomOffsetData.ScaleUnit or 0.1
    local LocMax = CustomOffsetData.LocationLimit[2] or 10
    local LocMin = CustomOffsetData.LocationLimit[1] or -10
    local LocStep = CustomOffsetData.LocationUnit or 0.1
    local RotMax = CustomOffsetData.RotationLimit[2] or 180
    local RotMin = CustomOffsetData.RotationLimit[1] or -180
    local RotStep = CustomOffsetData.RotationUnit or 1
    return
    {
        Owner = self,
        Groups = {
            {
                Title = GText("UI_Accessory_Custom_Scale"),
                bShowResetBtn = true,           --是否显示重置按钮
                GamepadResetKey = "LeftThumb", -- 手柄重置键,UIConst.GamePadImgKey的key
                Items = {
                    {
                        Text = GText("UI_Accessory_Scale"),      --条目名称
                        MaxValue = ScaleMax,  --最大值，默认1
                        MinValue = ScaleMin,  --最小值，默认0
                        DefaultValue = self.AccessoryScaleOffset.X,  --默认值，点击重置会设置到这个值,不传则用MinValue
                        CurrentValue = self.ComparedAccessoryScaleOffset.X,  --当前值，不传则用DefaultValue
                        StepSize = ScaleStep, --滑动条步长
                        bShowResetBtn = false,       --是否显示重置按钮
                        OnValueChanged = self.OnScaleValueChanged, --滑条数值改变回调
                        GamepadResetKey = "LeftThumb" -- 手柄重置键,UIConst.GamePadImgKey的key
                    }
                },
            },
            {
                Title = GText("UI_Accessory_Custom_Location"),
                bShowResetBtn = true,
                GamepadResetKey = "LeftThumb", -- 手柄重置键,UIConst.GamePadImgKey的key
                Items = {
                    {
                        LocationAxis = ELocationAxis.X,
                        Text = GText("UI_Accessory_Rotation_Left"),
                        MaxValue = LocMax,
                        MinValue = LocMin,
                        DefaultValue = self.AccessoryPostionOffset[ELocationAxis.X],
                        CurrentValue = self.ComparedAccessoryPostionOffset[ELocationAxis.X],
                        StepSize = LocStep,
                        OnValueChanged = self.OnPositionValueChanged,
                    },
                    {
                        LocationAxis = ELocationAxis.Z,
                        Text = GText("UI_Accessory_Location_Up"),
                        MaxValue = LocMax,
                        MinValue = LocMin,
                        DefaultValue = self.AccessoryPostionOffset[ELocationAxis.Z],
                        CurrentValue = self.ComparedAccessoryPostionOffset[ELocationAxis.Z],
                        StepSize = LocStep,
                        OnValueChanged = self.OnPositionValueChanged,
                    },
                    {
                        LocationAxis = ELocationAxis.Y,
                        Text = GText("UI_Accessory_Rotation_Front"),
                        MaxValue = LocMax,
                        MinValue = LocMin,
                        DefaultValue = self.AccessoryPostionOffset[ELocationAxis.Y],
                        CurrentValue = self.ComparedAccessoryPostionOffset[ELocationAxis.Y],
                        StepSize = LocStep,
                        OnValueChanged = self.OnPositionValueChanged,
                    }
                },
            },
            {
                Title = GText("UI_Accessory_Custom_Rotation"),
                Items = {
                    {
                        RotationAxis = ERotationAxis.Yaw,
                        Text = GText("UI_Accessory_Rotation_Yaw"),
                        MaxValue = RotMax,
                        MinValue = RotMin,
                        bShowResetBtn = true,
                        DefaultValue = self.AccessoryRotationOffset[ERotationAxis.Yaw],
                        CurrentValue = self.ComparedAccessoryRotationOffset[ERotationAxis.Yaw],
                        StepSize = RotStep,
                        OnValueChanged = self.OnRotationValueChanged,
                    },
                    {
                        RotationAxis = ERotationAxis.Roll,
                        Text = GText("UI_Accessory_Rotation_Pitch"),
                        MaxValue = RotMax,
                        MinValue = RotMin,
                        bShowResetBtn = true,
                        DefaultValue = self.AccessoryRotationOffset[ERotationAxis.Roll],
                        CurrentValue = self.ComparedAccessoryRotationOffset[ERotationAxis.Roll],
                        StepSize = RotStep,
                        OnValueChanged = self.OnRotationValueChanged,
                    },
                    {
                        RotationAxis = ERotationAxis.Pitch,
                        Text = GText("UI_Accessory_Rotation_Roll"),
                        MaxValue = RotMax,
                        MinValue = RotMin,
                        bShowResetBtn = true,
                        DefaultValue = self.AccessoryRotationOffset[ERotationAxis.Pitch],
                        CurrentValue = self.ComparedAccessoryRotationOffset[ERotationAxis.Pitch],
                        StepSize = RotStep,
                        OnValueChanged = self.OnRotationValueChanged,
                    }
                },
            }
        },
    }
end

function M:OnScaleValueChanged(Value,Item)
    self.ComparedAccessoryScaleOffset.X = Value
    self.ComparedAccessoryScaleOffset.Y = Value
    self.ComparedAccessoryScaleOffset.Z = Value
    self:UpdateCharAccessoryOffset()
end

function M:OnPositionValueChanged(Value,Item)
    self.ComparedAccessoryPostionOffset[Item.LocationAxis] = Value
    self:UpdateCharAccessoryOffset()
end

function M:OnRotationValueChanged(Value,Item)
    self.ComparedAccessoryRotationOffset[Item.RotationAxis] = Value
    self:UpdateCharAccessoryOffset()
end

--根据缓存值更新模型偏移
function M:UpdateCharAccessoryOffset()
    self.ActorController:SetCharAccessoryOffset(self.ComparedContent.AccessoryId,self.ComparedContent.AccessoryType,
                                                self.ComparedAccessoryScaleOffset,self.ComparedAccessoryPostionOffset,self.ComparedAccessoryRotationOffset)
    self:UpdateAccessoryCustomBtnState()
end

---恢复模型到实际偏移
function M:RecoverAccessoryCustom()
    self.ActorController:SetCharAccessoryOffset(self.ComparedContent.AccessoryId,self.ComparedContent.AccessoryType,
                                                self.AccessoryScaleOffset,self.AccessoryPostionOffset,self.AccessoryRotationOffset)
end

function M:IsFocusStateValid_AccessoryCustom(State)
    local StateName = State.Name
    if(StateName == FocusAreas.CustomList)then
        return rawget(self,"bAccessoryCustomOpened")
    elseif(StateName == FocusAreas.HiddenSelf)then
        return self.bSelfHidden
    end
end

function M:GetDesiredFocusTarget_AccessoryCustom()
    if(self.bSelfHidden)then
        return self
    else
        return self.CustomList:GetDesiredFocusTarget()
    end
end

--region 按键输入相关

function M:OnCustomListAddedToFocusPath(Widget)
    self.FSM:Push{Name = FocusAreas.CustomList,Widget = self.CustomList}
end

local  AccessoryCustomCameraScrollKeyInfoList = {
    GamePadInfoList =  {
        {Type="Img", ImgShortPath="RV",}
    },
    Desc = GText("UI_Dye_Zoom"),
    bLongPress = false
}

function M:UpdateKeySetting_AccessoryCustom()
    self:ClearAllKeyEvents()
    self.BottomKeyInfo = {}
    self.RepeatKeyDownEvents = {}
    if(self.IsGamepadInput)then
        local StateName = self.FSM:Peak().Name
        if(StateName == FocusAreas.CustomList)then
            self:AddKeyDownEvent(Const.GamepadFaceButtonRight,self.OnBackKeyDown)
            self:AddKeyDownEvent(UIConst.GamePadKey.FaceButtonLeft,self.OnHideUIKeyDown)
            self:AddKeyDownEvent(UIConst.GamePadKey.FaceButtonTop,self.OnGamePadResetAccessoryCustomKeyDown)
            self:AddKeyDownEvent(UIConst.GamePadKey.FaceButtonBottom,self.OnGamePadConfirKeyDown_AccessoryCustom)
            table.insert(self.BottomKeyInfo,self.HideUI_KeyInfoList)
            table.insert(self.BottomKeyInfo,AccessoryCustomCameraScrollKeyInfoList)
            table.insert(self.BottomKeyInfo,self.RightThumbstickAnalogBottomKeyInfoList)
            table.insert(self.BottomKeyInfo,self.ESCKeyInfoList)
        end
    else
        --键鼠
        self:AddKeyDownEvent(self.EscapeKey,self.OnBackKeyDown)
        self:AddKeyDownEvent(EKeys.U.KeyName,self.OnHideUIKeyDown)
        table.insert(self.BottomKeyInfo,self.HideUI_KeyInfoList)
        table.insert(self.BottomKeyInfo,self.ZoomKeyInfoList)
        table.insert(self.BottomKeyInfo,self.ESCKeyInfoList)
    end
    self.Tab_Skin:UpdateBottomKeyInfo(self.BottomKeyInfo)
end

function M:OnGamePadResetAccessoryCustomKeyDown()
    self:OnResetCustomBtnClicked()
    return UIUtils.Handled,true
end

function M:OnGamePadConfirKeyDown_AccessoryCustom()
    self:OnSaveCustomBtnClicked()
    return UIUtils.Handled,true
end

--endregion

return M