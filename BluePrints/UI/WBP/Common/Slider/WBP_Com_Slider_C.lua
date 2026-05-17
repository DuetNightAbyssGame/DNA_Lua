--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_Slider_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

local GamePadAddKey = {
    Vertical = UIConst.GamePadKey.RightStickUp,
    Horizontal = UIConst.GamePadKey.RightStickRight,
}

local GamePadMinKey = {
    Vertical = UIConst.GamePadKey.RightStickDown,
    Horizontal = UIConst.GamePadKey.RightStickLeft,
}

local LongPressInterval = 0.15

function M:Construct()
    -- 当前的输入数值
    self.CurrentCount = nil
    self.CurInputDeviceType = nil
    self.CurGamepadNameName = nil
    self.StepCount = 1

    self.AddTime = 0
    self.MinTime = 0

    self.SliderType = self.SliderType or "Horizontal"
end

function M:Destruct()
    self:ClearListenEvent()
    M.Super.Destruct(self)
end

---@param ConfigData table<string, any> 配置信息
function M:Init(ConfigData)
    -- 文档地址 https://herogames.feishu.cn/wiki/QNnLwF1vXicX0FkU1J1c7tS0nIf#share-W6Ladrus7o6QHQx88XDcmv5Fnht
    -- ConfigData({
    --     InitValue = Number, 初始个数，默认为1
    --     MinValue = Number, 最小个数，默认为1
    --     MaxValue = Number, 最大个数, 默认为999
    --     EnableMiniBtn = bool, 是否启用最小按钮, 默认为false
    --     EnableMaxBtn = bool, 是否启用最大按钮, 默认为false
    --     ClickInterval = Number, 每次点击增加/减少个数，默认为1
    --     MinusBtnCallback = function, 减少按钮的回调
    --     MinusBtnForbidCallback = function,   禁用态减少按钮回调
    --     AddBtnCallback = function, 增加按钮的回调
    --     AddBtnForbidCallback = function,     禁用态增加按钮回调
    --     MaxBtnCallback = function, 最大按钮的回调
    --     SliderChangeCallback = function, 增加滑条的回调
    ---    SoundResPath = {
    ---         Minus = "event:/ui/common/click_btn_minus"
    ---         Add = "event:/ui/common/click_btn_add"
    ---         Mini = "event:/ui/common/click_btn_minusMulti"
    ---         Max = "event:/ui/common/click_btn_addMulti"
    ---         Slider = "event:/ui/common/click"
    ---     }, 非特殊情况就用默认的音效
    ---     OwnerPanel = ParentWidget,  父对象
    ---     ForbidGamePadLTRTKey = bool, 是否禁止手柄 LT/RT 进行增减
    ---     ForbidGamePadRSKey = bool, 是否禁止手柄 RS 进行增减
    ---     GamePadRSRate = Number, 手柄RS滑动倍率 默认为1
    ---     PlatformName = "PC", 平台类型 (PC、Mobile、GamePad) 可选参数
    ---     bDisableAutoHandleInputDeviceChange = bool, 是否禁止自动处理输入设备变化 若为true 则需要手动调用 UpdateUIStyleInPlatform 来更新输入设备样式 默认为false
    ---     bForbidPressAccelerate = bool, 是否禁用长按加速（若有自己对滑条加速处理的话设为true） 默认为false
    ---     bEnableMinusSpecificBtn = bool, 是否启用减少特定数量按钮，默认为false 当为true时 EnableMiniBtn 不生效（策划要求与最小按钮互斥）
    ---     bEnableAddSpecificBtn = bool, 是否启用增加特定数量按钮，默认为false 当为true时 EnableMaxBtn 不生效（策划要求与最大按钮互斥）
    ---     SpecificChangeCount = Number, 增加/减少的特定数量
    ---     MinusSpecificBtnGamePadKey = UIConst.GamePadKey.XXX 的 XXX, 手柄减少特定数量 对应按键 默认为方向键左键
    ---     AddSpecificBtnGamePadKey = UIConst.GamePadKey.XXX 的 XXX, 手柄增加特定数量 对应按键 默认为方向键右键
    -- })
    -- 初始化设置选择器的信息
    self.ConfigData = ConfigData
    -- 配置信息
    self.CurrentCount = ConfigData.InitValue or 1
    -- 最小个数
    self.MinValue = ConfigData.MinValue or 1
    -- 最大个数
    self.MaxValue = ConfigData.MaxValue or 999
    -- 是否启用最小按钮
    self.EnableMiniBtn = ConfigData.EnableMiniBtn or false
    -- 是否启用最大按钮
    self.EnableMaxBtn = ConfigData.EnableMaxBtn or false
    -- 每次点击增加/减少个数
    self.ClickInterval = ConfigData.ClickInterval or 1
    -- 最小按钮对应的手柄按键 开启时默认为方向键左键 如 UIConst.GamePadKey.DPadLeft 只要 DPadLeft 就够
    rawset(self, "MiniBtnGamePadKey", self.EnableMiniBtn and (ConfigData.MiniBtnGamePadKey or "DPadLeft") or nil)
    -- 最大按钮对应的手柄按键 开启时默认为方向键右键 如 UIConst.GamePadKey.DPadRight 只要 DPadRight 就够
    rawset(self, "MaxBtnGamePadKey", self.EnableMaxBtn and (ConfigData.MaxBtnGamePadKey or "DPadRight") or nil)
    -- 减少按钮的回调
    self.MinusBtnCallback = ConfigData.MinusBtnCallback
    -- 增加按钮的回调
    self.AddBtnCallback = ConfigData.AddBtnCallback
    -- 最大按钮的回调
    self.MaxBtnCallback = ConfigData.MaxBtnCallback
    -- 增加滑条的回调
    self.SliderChangeCallback = ConfigData.SliderChangeCallback
    -- 所有音频资源路径
    self.SoundResPath = ConfigData.SoundResPath or {}
    -- 所属的对象
    self.OwnerPanel = ConfigData.OwnerPanel
    -- 是否禁止手柄 LT/RT 进行增减
    self.ForbidGamePadLTRTKey = ConfigData.ForbidGamePadLTRTKey or false
    -- 是否禁止手柄 RS 进行增减
    self.ForbidGamePadRSKey = ConfigData.ForbidGamePadRSKey or false
    -- 手柄RS滑动倍率 默认为1 每间隔LongPressInterval秒调用一次
    self.GamePadRSRate = ConfigData.GamePadRSRate or 1
    -- 是否禁止自动处理输入设备
    self.bDisableAutoHandleInputDeviceChange = ConfigData.bDisableAutoHandleInputDeviceChange or false
    -- 是否禁用长按加速
    self.bForbidPressAccelerate = ConfigData.bForbidPressAccelerate or false
    -- 是否使用默认按键初始化 LT RT
    self.bUseDefaultKeyInit = ConfigData.bUseDefaultKeyInit or true
    -- 是否启用减少特定数量按钮
    rawset(self, "bEnableMinusSpecificBtn", ConfigData.bEnableMinusSpecificBtn or false)
    -- 是否启用增加特定数量按钮
    rawset(self, "bEnableAddSpecificBtn", ConfigData.bEnableAddSpecificBtn or false)
    -- 点击增加/减少特定数量按钮时，增加/减少的数量
    rawset(self, "SpecificChangeCount", ConfigData.SpecificChangeCount or 1)
    -- 手柄减少特定数量 对应按键 开启时默认为方向键左键 如 UIConst.GamePadKey.DPadLeft 只要 DPadLeft 就够
    rawset(self, "MinusSpecificBtnGamePadKey", self.bEnableMinusSpecificBtn and (ConfigData.MinusSpecificBtnGamePadKey or "DPadLeft") or nil)
    -- 手柄增加特定数量 对应按键 开启时默认为方向键右键 如 UIConst.GamePadKey.DPadRight 只要 DPadRight 就够
    rawset(self, "AddSpecificBtnGamePadKey", self.bEnableAddSpecificBtn and (ConfigData.AddSpecificBtnGamePadKey or "DPadRight") or nil)

    -- 垂直滑条会设置为 Up 水平默认为 LT
    rawset(self, "GamePadMinKeyPath", self.GamePadMinKeyPath and self.GamePadMinKeyPath or "LT")
    -- 垂直滑条会设置为 Down 水平默认为 RT
    rawset(self, "GamePadAddKeyPath", self.GamePadAddKeyPath and self.GamePadAddKeyPath or "RT")
    -- 绑定输入操作
    self:AddTimer(0.01, function()
        self:BindAllClickAction()
        self:RefreshBaseInfo()
    end)
    self:InitListenEvent()
end

function M:RefreshBaseInfo()
    -- 刷新一些基础信息
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end

    self.StepCount = self.MaxValue - self.MinValue == 0 and 1 or (self.MaxValue - self.MinValue)
    self.Slider:SetStepSize(1 / self.StepCount)
    self.Slider_Controller:SetStepSize(1 / self.StepCount)
    self:UpdateSliderAndProgress()
    if self.MaxValue - self.MinValue <= 0 then
        self.Slider:SetLocked(true)
        self.Slider_Controller:SetLocked(true)
    else
        self.Slider:SetLocked(false)
        self.Slider_Controller:SetLocked(false)
    end

    if self.Key_Add and self.Key_Min then
        if not self.ForbidGamePadLTRTKey then
            self.Key_Add:SetVisibility(UE4.ESlateVisibility.Visible)
            self.Key_Min:SetVisibility(UE4.ESlateVisibility.Visible)
        else
            self.Key_Add:SetVisibility(UE4.ESlateVisibility.Hidden)
            self.Key_Min:SetVisibility(UE4.ESlateVisibility.Hidden)
        end
    end

    if self.Btn_NumLeft then
        if self.bEnableMinusSpecificBtn then
            self.Btn_NumLeft:SetVisibility(UE4.ESlateVisibility.Visible)

            local Config = {}
            Config.OwnerPanel = self
            Config.ClickedCallback = self.MinusSpecificBtnClicked
            Config.SpecificChangeCount = string.format("-%d", self.SpecificChangeCount)
            Config.GamePadKey = self.MinusSpecificBtnGamePadKey
            self.Btn_NumLeft:Init(Config)
        else
            self.Btn_NumLeft:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end

    if self.Btn_NumRight then
        if self.bEnableAddSpecificBtn then
            self.Btn_NumRight:SetVisibility(UE4.ESlateVisibility.Visible)

            local Config = {}
            Config.OwnerPanel = self
            Config.ClickedCallback = self.AddSpecificBtnClicked
            Config.SpecificChangeCount = string.format("+%d", self.SpecificChangeCount)
            Config.GamePadKey = self.AddSpecificBtnGamePadKey
            self.Btn_NumRight:Init(Config)
        else
            self.Btn_NumRight:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end

    self:ForbidAddOperation(self.CurrentCount + self.ClickInterval > self.MaxValue)
    self:ForbidMinOperation(self.CurrentCount - self.ClickInterval < self.MinValue)
    if self.ParentContainer then
        if self.MaxValue == 1 then
            self.ParentContainer:SetVisibility(ESlateVisibility.Collapsed)
        else
            self.ParentContainer:SetVisibility(ESlateVisibility.Visible)
        end
    end

    if self.Text_Mini then
        self.Text_Mini:SetText(GText("UI_SHOP_MIN"))
    end
    if self.Text_Max then
        self.Text_Max:SetText(GText("UI_SHOP_MAX"))
    end
end

function M:InitWidgetInfoInGamePad(IsUseGamePad)
    if not IsUseGamePad or self.GamePadKeyInited then
        return
    end
    -- 手柄LT是否按下
    self.MinusPressed = false
    -- 手柄RT是否按下
    self.AddPressed = false

    if self.Key_Min then
        self.Key_Min:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = self.GamePadMinKeyPath,
                },
            },
            bDisableResetWhenChangeDevice=true,
        })
    end

    if self.Key_Add then
        self.Key_Add:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = self.GamePadAddKeyPath,
                },
            },
            bDisableResetWhenChangeDevice=true,
        })
    end

    if self.Key_Mini then
        self.Key_Mini:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = UIConst.GamePadImgKey[self.MiniBtnGamePadKey],
                },
            },
            bDisableResetWhenChangeDevice=true,
        })
    end

    if self.Key_Max then
        self.Key_Max:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = UIConst.GamePadImgKey[self.MaxBtnGamePadKey],
                },
            },
            bDisableResetWhenChangeDevice=true,
        })
    end
    rawset(self, "GamePadKeyInited", true)
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

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (self.bDisableAutoHandleInputDeviceChange) then
        return
    end
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end

    --- 输入设备切换通知
    local IsUseGamePad = CurInputDevice == ECommonInputType.Gamepad
    self:UpdateUIStyleInPlatform(IsUseGamePad, CurGamepadName)

    self.CurInputDeviceType = CurInputDevice
end

function M:UpdateUIStyleInPlatform(IsUseGamePad, CurGamepadName)
    self:InitWidgetInfoInGamePad(IsUseGamePad)
    self:ButonUseGamePadStyle(IsUseGamePad)
    self:SliderUseGamePadStyle(IsUseGamePad)
    self:MiniMaxUseGamePadStyle(IsUseGamePad)
    if IsUseGamePad then
        self.InGamePadMode = true
        self:UpdateMouseGamePadImage(CurGamepadName)
    else
        self.InGamePadMode = false
    end
end

function M:MiniMaxUseGamePadStyle(UseGamePadStyle)
    if self.WS_Mini and UseGamePadStyle then
        if self.MiniBtnGamePadKey ~= nil and self.MiniBtnGamePadKey ~= self.MinusSpecificBtnGamePadKey then
            self.WS_Mini:SetVisibility(UE4.ESlateVisibility.Visible)
        else
            self.WS_Mini:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    else
        if self.EnableMiniBtn then
            self.WS_Mini:SetVisibility(UE4.ESlateVisibility.Visible)
        else
            self.WS_Mini:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end

    if self.WS_Max and UseGamePadStyle  then
        if self.MaxBtnGamePadKey ~= nil and self.MaxBtnGamePadKey ~= self.AddSpecificBtnGamePadKey then
            self.WS_Max:SetVisibility(UE4.ESlateVisibility.Visible)
        else
            self.WS_Max:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    else
        if self.EnableMaxBtn then
            self.WS_Max:SetVisibility(UE4.ESlateVisibility.Visible)
        else
            self.WS_Max:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end

    local ActiveWidgetIndex = UseGamePadStyle and 1 or 0
    -- 0 PC  1 手柄
    self.WS_Mini:SetActiveWidgetIndex(ActiveWidgetIndex)
    self.WS_Max:SetActiveWidgetIndex(ActiveWidgetIndex)
    self.Btn_NumLeft:ChangeUIStyleForCurPlatform(not UseGamePadStyle)
    self.Btn_NumRight:ChangeUIStyleForCurPlatform(not UseGamePadStyle)
end

function M:ButonUseGamePadStyle(UseGamePadStyle)
    if UseGamePadStyle then
        self.ButtonInGamePadStyle = true
    else
        self.ButtonInGamePadStyle = false
    end
    local ActiveWidgetIndex = UseGamePadStyle and 1 or 0
    -- 0 PC  1 手柄
    self.WS_Min:SetActiveWidgetIndex(ActiveWidgetIndex)
    self.WS_Add:SetActiveWidgetIndex(ActiveWidgetIndex)
end

function M:SliderUseGamePadStyle(UseGamePadStyle)
    if self.ForbidGamePadRSKey then
        UseGamePadStyle = false
    end
    if UseGamePadStyle then
        self.SliderInGamePadStyle = true
    else
        self.SliderInGamePadStyle = false
    end
    local ActiveWidgetIndex = UseGamePadStyle and 1 or 0
    -- 0 PC  1 手柄
    self.WS_Slider:SetActiveWidgetIndex(ActiveWidgetIndex)
end

function M:BindAllClickAction()
    -- self.Btn_Min:BindEventOnClicked(self, self.OnClickToMinus)
    self.Btn_Min:BindEventOnPressed(self, self.OnMinusKeyDown)
    self.Btn_Min:BindEventOnReleased(self,self.OnMinusKeyUp)

    -- self.Btn_Add:BindEventOnClicked(self, self.OnClickToAdd)
    self.Btn_Add:BindEventOnPressed(self, self.OnAddKeyDown)
    self.Btn_Add:BindEventOnReleased(self,self.OnAddKeyUp)
    self.Slider.OnValueChanged:Add(self, self.OnSliderValueChanged)
    self.Slider.OnMouseCaptureBegin:Add(self, self.OnSelectedSlider)
    self.Slider.OnMouseCaptureEnd:Add(self, self.OnUnSelectedSlider)

    if self.Btn_Mini then
        self.Btn_Mini:BindEventOnPressed(self, self.OnMiniKeyDown)

        self.Btn_Mini.SoundFunc = function(Btn)
        end
    end
    if self.Btn_Max then
        self.Btn_Max:BindEventOnPressed(self, self.OnMaxKeyDown)

        self.Btn_Max.SoundFunc = function(Btn)
        end
    end

    -- 一些按钮音效相关
    self.Btn_Min.SoundFunc = function(Btn)
    end
    self.Btn_Add.SoundFunc = function(Btn)
    end
end

function M:GetChangeCount()
    local PressTime  = self.AddTime ~= 0 and self.AddTime or self.MinTime
    local Multiple = 1
    if not self.bForbidPressAccelerate and self.LongPressCurve then
        Multiple = self.LongPressCurve:GetFloatValue(PressTime)
    end
    local StepCount = self.ClickInterval * Multiple
    StepCount = math.floor(StepCount + 0.5)
    -- local FinalCount = math.floor(math.max(self.MinValue, math.min(StepCount, self.MaxValue)))
    local FinalCount = math.floor(math.max(1, math.min(StepCount, self.MaxValue)))
    return FinalCount
end

function M:MinusSpecificBtnClicked()
    local FinalCount = self.SpecificChangeCount
    if (self.CurrentCount - self.MinValue < FinalCount)  then
        FinalCount = self.CurrentCount - self.MinValue
    end
    if FinalCount <= 0 then
        return
    end
    if (self.CurrentCount - FinalCount < self.MinValue) then
        if (not self.ForbidMin) then
            self:ForbidMinOperation(true)
        end
        return
    end
    local OldNumberValue = self.CurrentCount
    self.CurrentCount = self.CurrentCount - FinalCount
    self:UpdateSliderAndProgress()
    if (self.ForbidAdd) then
        self:ForbidAddOperation(false)
    end

    self:ForbidMinOperation(self.CurrentCount - self.ClickInterval < self.MinValue)
    if (type(self.MinusBtnCallback) == "function") then
        self.MinusBtnCallback(self.OwnerPanel, self.CurrentCount, OldNumberValue)
    end
    local EventSoundPath = self.SoundResPath["Minus"] or "event:/ui/common/click_btn_minus"
    AudioManager(self):PlayUISound(self.Btn_Min, EventSoundPath, nil, nil)
end

function M:AddSpecificBtnClicked()
    local FinalCount = self.SpecificChangeCount
    if (self.MaxValue - self.CurrentCount < FinalCount)  then
        FinalCount = self.MaxValue - self.CurrentCount
    end
    if FinalCount <= 0 then
        return
    end
    if (self.CurrentCount + FinalCount > self.MaxValue) then
        if (not self.ForbidAdd) then
            self:ForbidAddOperation(true)
        end
        -- self.Btn_Max:ForbidBtn(true)
        return
    end
    local OldNumberValue = self.CurrentCount
    self.CurrentCount = self.CurrentCount + FinalCount
    self:UpdateSliderAndProgress()
    if (self.ForbidMin) then
        self:ForbidMinOperation(false)
    end
    self:ForbidAddOperation(self.CurrentCount + self.ClickInterval > self.MaxValue)
    -- self.Btn_Max:ForbidBtn(self.CurInputNumber + self.ClickInterval > self.MaxValue)
    if (type(self.AddBtnCallback) == "function") then
        self.AddBtnCallback(self.OwnerPanel, self.CurrentCount, OldNumberValue)
    end
    local EventSoundPath = self.SoundResPath["Add"] or "event:/ui/common/click_btn_add"
    AudioManager(self):PlayUISound(self.Btn_Add, EventSoundPath, nil, nil)
end

function M:OnClickToMinus()
    self.MinTime = self.MinTime + LongPressInterval
    local FinalCount = self:GetChangeCount()
    if (self.CurrentCount - self.MinValue < FinalCount)  then
        FinalCount = self.CurrentCount - self.MinValue
        self:RemoveTimer("PreMinusLoop",true)
    end
    if FinalCount <= 0 then
        return
    end
    if (self.CurrentCount - FinalCount < self.MinValue) then
        if (not self.ForbidMin) then
            self:ForbidMinOperation(true)
        end
        return
    end
    local OldNumberValue = self.CurrentCount
    self.CurrentCount = self.CurrentCount - FinalCount
    self:UpdateSliderAndProgress()
    if (self.ForbidAdd) then
        self:ForbidAddOperation(false)
    end

    self:ForbidMinOperation(self.CurrentCount - self.ClickInterval < self.MinValue)
    if (type(self.MinusBtnCallback) == "function") then
        self.MinusBtnCallback(self.OwnerPanel, self.CurrentCount, OldNumberValue)
    end
    local EventSoundPath = self.SoundResPath["Minus"] or "event:/ui/common/click_btn_minus"
    AudioManager(self):PlayUISound(self.Btn_Min, EventSoundPath, nil, nil)
end

function M:OnClickToAdd()
    self.AddTime = self.AddTime + LongPressInterval
    local FinalCount = self:GetChangeCount()
    if (self.MaxValue - self.CurrentCount < FinalCount)  then
        FinalCount = self.MaxValue - self.CurrentCount
        self:RemoveTimer("PreAddLoop",true)
    end
    if FinalCount <= 0 then
        return
    end
    if (self.CurrentCount + FinalCount > self.MaxValue) then
        if (not self.ForbidAdd) then
            self:ForbidAddOperation(true)
        end
        -- self.Btn_Max:ForbidBtn(true)
        return
    end
    local OldNumberValue = self.CurrentCount
    self.CurrentCount = self.CurrentCount + FinalCount
    self:UpdateSliderAndProgress()
    if (self.ForbidMin) then
        self:ForbidMinOperation(false)
    end
    self:ForbidAddOperation(self.CurrentCount + self.ClickInterval > self.MaxValue)
    -- self.Btn_Max:ForbidBtn(self.CurInputNumber + self.ClickInterval > self.MaxValue)
    if (type(self.AddBtnCallback) == "function") then
        self.AddBtnCallback(self.OwnerPanel, self.CurrentCount, OldNumberValue)
    end
    local EventSoundPath = self.SoundResPath["Add"] or "event:/ui/common/click_btn_add"
    AudioManager(self):PlayUISound(self.Btn_Add, EventSoundPath, nil, nil)
end

function M:OnMinusKeyDown()
    self:AddTimer(LongPressInterval ,self.OnClickToMinus, true, 0, "PreMinusLoop", true)
    local AddTimerKey = self:_GetTimerInfo("PreAddLoop")
    if AddTimerKey then
        self.AddTime = 0
        self:PauseTimer("PreAddLoop")
        self:PauseTimer("PreMinusLoop")
    else
        self:OnClickToMinus()
    end
end

function M:OnMinusKeyUp()
    self.MinTime = 0
    self:RemoveTimer("PreMinusLoop",true)
    local AddTimerKey = self:_GetTimerInfo("PreAddLoop")
    if AddTimerKey then
        self:UnPauseTimer("PreAddLoop")
    end
end

function M:OnAddKeyDown()
    self:AddTimer(LongPressInterval ,self.OnClickToAdd, true, 0, "PreAddLoop", true)
    local AddTimerKey = self:_GetTimerInfo("PreMinusLoop")
    if AddTimerKey then
        self.MinTime = 0
        self:PauseTimer("PreMinusLoop")
        self:PauseTimer("PreAddLoop")
    else
        self:OnClickToAdd()
    end
end

function M:OnAddKeyUp()
    self.AddTime = 0
    self:RemoveTimer("PreAddLoop",true)
    local AddTimerKey = self:_GetTimerInfo("PreMinusLoop")
    if AddTimerKey then
        self:UnPauseTimer("PreMinusLoop")
    end
end

function M:TriggerKeyUpEvent()
    self:OnMinusKeyUp()
    self.MinusPressed = false
    self:OnAddKeyUp()
    self.AddPressed = false
end

function M:ForbidMinOperation(Forbidden)
    if not Forbidden and self.CurrentCount - self.ClickInterval < self.MinValue then
        Forbidden = true
    end
    self.ForbidMin = Forbidden
    self.Btn_Min:ForbidBtn(Forbidden)
    self.Key_Min:SetForbidKey(Forbidden)
    self.Btn_Mini:ForbidBtn(Forbidden)
    self.Key_Mini:SetForbidKey(Forbidden)
    self.Text_Mini:SetOpacity(Forbidden and 0.6 or 1)
    if self.Btn_NumLeft then
        self.Btn_NumLeft:SetForbid(Forbidden)
    end
end

function M:ForbidAddOperation(Forbidden)
    if not Forbidden and self.CurrentCount + self.ClickInterval > self.MaxValue then
        Forbidden = true
    end
    self.ForbidAdd = Forbidden
    self.Btn_Add:ForbidBtn(Forbidden)
    self.Key_Add:SetForbidKey(Forbidden)
    self.Btn_Max:ForbidBtn(Forbidden)
    self.Key_Max:SetForbidKey(Forbidden)
    self.Text_Max:SetOpacity(Forbidden and 0.6 or 1)
    if self.Btn_NumRight then
        self.Btn_NumRight:SetForbid(Forbidden)
    end
end

function M:UpdateSliderValue()
    local Value = (self.CurrentCount - self.MinValue) / self.StepCount
    if self.MaxValue ~= 0 and self.CurrentCount == self.MaxValue then
        Value = 1
    end
    self.Slider:SetValue(Value)
    self.Slider_Controller:SetValue(Value)
end

function M:OnMiniKeyDown()
    if self.ForbidMin then
        return
    end
    self:ChangeSliderValueByInputNumber(self.MinValue)
    local EventSoundPath = self.SoundResPath["Mini"] or "event:/ui/common/click_btn_minusMulti"
    AudioManager(self):PlayUISound(self.Btn_Mini, EventSoundPath, nil, nil)
end

function M:OnMaxKeyDown()
    if self.ForbidAdd then
        return
    end
    local OldNumberValue = self.CurrentCount
    self.CurrentCount = self.MaxValue
    self:ChangeSliderValueByInputNumber(self.MaxValue)

    if (type(self.MaxBtnCallback) == "function") then
        self.MaxBtnCallback(self.OwnerPanel, self.CurrentCount, OldNumberValue)
    end
    local EventSoundPath = self.SoundResPath["Max"] or "event:/ui/common/click_btn_addMulti"
    AudioManager(self):PlayUISound(self.Btn_Max, EventSoundPath, nil, nil)
end

function M:OnSliderValueChanged(Value)
    local SlideValue = Value * (self.StepCount) + self.MinValue
    -- 四舍五入一下
    SlideValue = math.floor(SlideValue + 0.5)
    local NewCount = math.floor(math.max(self.MinValue, math.min(SlideValue, self.MaxValue)))
    self:UpdateSliderValue()
    if NewCount ~= self.CurrentCount then
        self.CurrentCount = NewCount
        -- 刷新面板信息
        self:ForbidAddOperation(self.CurrentCount + self.ClickInterval > self.MaxValue)
        self:ForbidMinOperation(self.CurrentCount - self.ClickInterval < self.MinValue)
        self:UpdateSliderAndProgress(true)
        if self.SelectedSlider then
            local EventSoundPath = self.SoundResPath["Slider"] or "event:/ui/common/click"
            AudioManager(self):PlayUISound(self.WS_Slider, EventSoundPath, nil, nil)
        end
    end
end

function M:OnSelectedSlider()
    self.SelectedSlider = true
end

function M:OnUnSelectedSlider()
    self.SelectedSlider = false
end

function M:ChangeSliderValueByInputNumber(Value, NoNeedCallback)
    if Value < self.MinValue then
        Value = self.MinValue
    end

    if Value > self.MaxValue then
        Value = self.MaxValue
    end

    self.CurrentCount = Value
    -- 刷新面板信息
    self:ForbidAddOperation(self.CurrentCount + self.ClickInterval > self.MaxValue)
    self:ForbidMinOperation(self.CurrentCount - self.ClickInterval < self.MinValue)
    self:UpdateSliderAndProgress(not NoNeedCallback)
end

function M:SetValue(Value)
    self.CurrentCount = Value
end

function M:SetMinValue(MinValue)
    self.MinValue = MinValue
end

function M:SetMaxValue(MaxValue)
    self.MaxValue = MaxValue
end

-- 重写值限制, 并刷新面板信息
function M:OverrideValueLimit(InitValue, MaxValue, MinValue, bRefresh)
    self.CurrentCount = InitValue or 1
    self.MaxValue = MaxValue or 999
    self.MinValue = MinValue or 1
    if (bRefresh) then
        -- 刷新面板信息
        self:RefreshBaseInfo()
    else
        self:ForbidAddOperation(self.CurrentCount + self.ClickInterval > self.MaxValue)
        self:ForbidMinOperation(self.CurrentCount - self.ClickInterval < self.MinValue)
    end
end

function M:SetEnabled(IsEnabled)
    if IsEnabled then 
        self.Slider:SetIsEnabled(true)
        self.Slider:SetRenderOpacity(1)
        self.Slider_Controller:SetIsEnabled(true)
        self.Slider_Controller:SetRenderOpacity(1)
        self.ProgressBar_Slider:SetRenderOpacity(1)
    else 
        self.Slider:SetIsEnabled(false)
        self.Slider:SetRenderOpacity(0.6)
        self.Slider_Controller:SetIsEnabled(false)
        self.Slider_Controller:SetRenderOpacity(0.6)
        self.ProgressBar_Slider:SetRenderOpacity(0.6)
    end
end

function M:UpdateSliderAndProgress(NeedCallback)
    self:UpdateSliderValue()
    self.ProgressBar_Slider:SetPercent(self.Slider:GetValue())
    if (NeedCallback and type(self.SliderChangeCallback) == "function") then
        self.SliderChangeCallback(self.OwnerPanel, self.CurrentCount)
    end
end

function M:RefreshCurInputNumber(NewNumber)
    self.CurrentCount = NewNumber or 1
    self:UpdateSliderAndProgress()
    self:RefreshBtnState()
end

function M:RefreshBtnState()
    self:ForbidAddOperation(self.CurrentCount + self.ClickInterval > self.MaxValue)
    self:ForbidMinOperation(self.CurrentCount - self.ClickInterval < self.MinValue)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

-------------------------------输入设备相关--------------------------
function M:UpdateMouseGamePadImage(CurGamepadName)
    if (self.CurGamepadNameName == CurGamepadName) then
        return
    end
    -- 手柄资源选择按键图片
    local ResourceIconPath = UIUtils.UtilsGetKeyIconPathInGamepad("RH", CurGamepadName)
    local Img = LoadObject(ResourceIconPath)
    if not IsValid(Img) then
        return
    end
    self.Slider_Controller.WidgetStyle.NormalThumbImage.ResourceObject = Img
    self.Slider_Controller.WidgetStyle.DisabledThumbImage.ResourceObject = Img
end

function M:Handle_KeyDownEventOnGamePad(InKeyName)
    -- UEPrint("WYX DownKey InKeyName = ", InKeyName)
    -- 处理手柄相关的交互事件
    local IsEventHandled = true
    if (not self.ForbidGamePadLTRTKey) and (InKeyName == UIConst.GamePadKey.RightTriggerThreshold) then
        if not self.AddPressed then
            self.AddPressed = true;
            self:OnAddKeyDown()
        end
    elseif (not self.ForbidGamePadLTRTKey) and (InKeyName == UIConst.GamePadKey.LeftTriggerThreshold) then
        if not self.MinusPressed then
            self.MinusPressed = true;
            self:OnMinusKeyDown()
        end
    elseif (not self.ForbidGamePadRSKey) and (InKeyName == GamePadAddKey[self.SliderType]) then
        if not self.AddPressed then
            self.AddPressed = true;
            self:OnAddKeyDown()
        end
    elseif (not self.ForbidGamePadRSKey) and (InKeyName == GamePadMinKey[self.SliderType]) then
        if not self.MinusPressed then
            self:OnMinusKeyDown()
            self.MinusPressed = true;
        end
    elseif self.bEnableMinusSpecificBtn and self.InGamePadMode and (InKeyName == UIConst.GamePadKey[self.MinusSpecificBtnGamePadKey]) then
        self:MinusSpecificBtnClicked()
    elseif self.bEnableAddSpecificBtn and self.InGamePadMode and (InKeyName == UIConst.GamePadKey[self.AddSpecificBtnGamePadKey]) then
        self:AddSpecificBtnClicked()
    elseif self.EnableMiniBtn and self.InGamePadMode and (InKeyName == UIConst.GamePadKey[self.MiniBtnGamePadKey]) then
        self:OnMiniKeyDown()
    elseif self.EnableMaxBtn and self.InGamePadMode and (InKeyName == UIConst.GamePadKey[self.MaxBtnGamePadKey]) then
        self:OnMaxKeyDown()
    else
        IsEventHandled = false
    end
    return IsEventHandled
end

function M:Handle_KeyUpEventOnGamePad(InKeyName)
    -- UEPrint("WYX UpKey InKeyName = ", InKeyName)
    -- 处理手柄相关的交互事件
    local IsEventHandled = true
    if (not self.ForbidGamePadLTRTKey) and (InKeyName == UIConst.GamePadKey.RightTriggerThreshold) then
        self:OnAddKeyUp()
        self.AddPressed = false;
    elseif (not self.ForbidGamePadLTRTKey) and (InKeyName == UIConst.GamePadKey.LeftTriggerThreshold) then
        self:OnMinusKeyUp()
        self.MinusPressed = false;
    elseif (not self.ForbidGamePadRSKey) and (InKeyName == UIConst.GamePadKey.RightStickRight) then
        self:OnAddKeyUp()
        self.AddPressed = false;
    elseif (not self.ForbidGamePadRSKey) and (InKeyName == UIConst.GamePadKey.RightStickLeft) then
        self:OnMinusKeyUp()
        self.MinusPressed = false;
    else
        IsEventHandled = false
    end
    return IsEventHandled
end

return M
