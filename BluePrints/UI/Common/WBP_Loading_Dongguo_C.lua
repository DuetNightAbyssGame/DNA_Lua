--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local EMCache = require "EMCache.EMCache"

---@type WBP_Loading_Dongguo_C
local WBP_Loading_Dongguo_C = Class({ "BluePrints.UI.BP_UIState_C" })
WBP_Loading_Dongguo_C._components = {
    "BluePrints.UI.WidgetComponent.ChangeTextToKeyInfoComponent",
}
function WBP_Loading_Dongguo_C:Construct()
    self:AddInputMethodChangedListen()
end

function WBP_Loading_Dongguo_C:Destruct()
    self:UnBindInLoading()
end

function WBP_Loading_Dongguo_C:InitLoadingData(LoadingData, ParentUI)
    self.CurrentInputDevice = { "KeyboardKey", "MouseButton" }
    self.IsPlaying = true
    self.IsWaiting = false
    self.CurrentAnimationMode = "Forward"
    self.WaitDuration = self.ChangeTime -- 等待时长
    -- 初始化假进度条相关变量
    self.Progress = 0.0
    self.ProgressSpeed = 100.0
    self.IsProgressing = true
    self.ParentUI = ParentUI
    local bEnableTick = not ParentUI
    self.bEnableTick = bEnableTick
    self.bUseFakeProgress = bEnableTick
    self.bBindInLoading = false
    self.MessageGroupId = LoadingData.MessageGroup
    self:PlayAnimation(self.In)
    self:UpdateProgress()
    self:InitMessageGroup()
    self:InitTitle(LoadingData.TitleBp, LoadingData.TitleTrans)
    self:InitBg(LoadingData.BackGroundBp)
    self:InitUIEvent()

    if not ParentUI then 
        local GameInputSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
        if IsValid(GameInputSubsystem) then
            local Params = FGameInputModeParams()
            Params.bShowMouseCursor = false
            Params.MouseLockMode = EMouseLockMode.DoNotLock
            GameInputSubsystem:EnableInputMode("CommonChangeScene", EGameInputMode.UI, Params)
        end

        self:SetMouseCursorVisable(false)
        self.bBindInLoading = true
        EventManager:AddEvent(EventID.InLoading, self, self.OnInLoading)
    end
end

function WBP_Loading_Dongguo_C:UnBindInLoading()
    if self.bBindInLoading then 
        EventManager:RemoveEvent(EventID.InLoading, self)
        self.bBindInLoading = nil
    end
end

function WBP_Loading_Dongguo_C:OnInLoading()
    self:CloseUI()
end

function WBP_Loading_Dongguo_C:InitUIEvent()
    self.Button_461.OnClicked:Clear()
    self.Button_461.OnClicked:Add(self, self.InitMessageGroup)
    self:SetFocus()
    self:UpdateUIStyleInPlatform(UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad)
end
function WBP_Loading_Dongguo_C:SetRandomTips()
    self:InitMessageGroup()
end
function WBP_Loading_Dongguo_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 输入设备切换通知
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    self:InitMessageGroup()
end

function WBP_Loading_Dongguo_C:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    self.CurrentInputDevice = IsUseKeyAndMouse and {"KeyboardKey","MouseButton"} or {"GamepadKey"}
    if not IsUseKeyAndMouse and self.RandomMessageIndex then
        self.Button_461:SetFocus()
        self.Com_KeyTitle:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Com_KeyTitle:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Img",
                    ImgShortPath = "A",
                },
            },
            bLongPress = false,
            Desc = GText('UI_CTL_Loading_Next'),
        })
    else
        self.Com_KeyTitle:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_Loading_Dongguo_C:InitBg(BgBp)
    if not BgBp then 
        return
    end
    self.Panel_Bg:ClearChildren()
    local BPWidget = UIManager(self):CreateWidget(BgBp)
    if BPWidget then 
        self.Panel_Bg:SetContent(BPWidget)
        BPWidget:PlayAnimation(BPWidget.In_Loading)
    end
end

local function StringReplaceUtil(PathString, Number)
    local Length = PathString:len()
    if string.byte(PathString, Length - 1) ==  Number + 48 then 
        return PathString
    end
    local ReplaceChar = tostring(Number)
    local DotPos = PathString:find('.', 1, true)
    if DotPos and DotPos > 1 then
        local PreDotPart = PathString:sub(1, DotPos - 2)
        local PostDotPart = PathString:sub(DotPos + 1, Length - 2)
        local ReplacedString = PreDotPart .. ReplaceChar .. "." .. PostDotPart .. ReplaceChar .. "'"
        return ReplacedString
    end
    return PathString
end

function WBP_Loading_Dongguo_C:InitTitle(TitleBp, TitleTrans)
    if not TitleBp then 
        return
    end
    local SystemLanguageSurfix = { CN = 1, Other = 2}
    local SystemLanguage = EMCache:Get("SystemLanguage")
    TitleBp = StringReplaceUtil(TitleBp, SystemLanguageSurfix[SystemLanguage] or 2)
    self.Group_Title:ClearChildren()
    local TitleWidget = UIManager(self):CreateWidget(TitleBp)
    self.Group_Title:AddChildToOverlay(TitleWidget)
    TitleWidget:PlayAnimation(TitleWidget.In)
    if TitleTrans and TitleWidget.Text_ENSubTitle then 
        TitleWidget.Text_ENSubTitle:SetText(GText(TitleTrans))
    end
end

function WBP_Loading_Dongguo_C:InitMessageGroup()
    local MessageGroupId = self.MessageGroupId
    local MessageGroup = MessageGroupId and DataMgr.MessageGroup[MessageGroupId]
    if not MessageGroup or not MessageGroup.MessageList then 
        return
    end
    local ListLength = #MessageGroup.MessageList
    if ListLength > 1 then 
        local RandomIndex = math.random(1, ListLength)
        if self.RandomMessageIndex == RandomIndex then 
            RandomIndex = RandomIndex + 1
            if RandomIndex > ListLength then 
                RandomIndex = 1
            end
        end
        self.RandomMessageIndex = RandomIndex
        self.ShowTipsInterval = Const.LoadingTipsInterval
        if self.ParentUI and self.ParentUI.ShowTipsInterval then 
            self.ParentUI.ShowTipsInterval = Const.LoadingTipsInterval
        end
    end
    local MessageId = MessageGroup.MessageList[self.RandomMessageIndex or 1]
    local RandomTips = DataMgr.Message[MessageId]
    local Title =  GText(RandomTips.MessageTitlePC or "")
    self.Text_Title:SetText(Title)
    local RandomMessage = nil
    local PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        RandomMessage = GText(RandomTips.MessageContentGamePad or RandomTips.MessageContentPC)
    elseif PlatformName == "PC" then 
        RandomMessage = GText(RandomTips.MessageContentPC)
    elseif PlatformName == "Mobile" then 
        RandomMessage = GText(RandomTips.MessageContentPhone)
    end

    local Messages = self:GetFinalContentText(RandomMessage, self.CurrentInputDevice)
    self.Text_Message:SetText(Messages)
end

function WBP_Loading_Dongguo_C:Tick(MyGeometry, InDeltaTime)
    if not self.IsWaiting then return end
    if not self.bUseFakeProgress or not self.IsProgressing then return end
    -- 更新进度条进度
    self.Progress = self.Progress + self.ProgressSpeed * InDeltaTime
    if self.Progress >= 99.0 then
        self.Progress = 99.0
        self.IsProgressing = false     -- 停止进度更新
    end

    if self.ShowTipsInterval then
        self.ShowTipsInterval = self.ShowTipsInterval - InDeltaTime
        if self.ShowTipsInterval <= 0 then
            self:SetRandomTips()
        end
    end
    -- 更新进度条和文字显示
    self:UpdateProgress()
end

-- 动画完成后的回调
function WBP_Loading_Dongguo_C:OnAnimationFinished(InAnimation)
    if InAnimation ~= self.In then
        return
    end
    if not self.IsPlaying then return end
    DebugPrint("动画完成: " .. self.CurrentAnimationMode)

    -- 动画完成后进入等待状态
    self.IsWaiting = true
end

function WBP_Loading_Dongguo_C:UpdateProgressBar(Progress)
    self.Progress = Progress
    self:UpdateProgress()
end
function WBP_Loading_Dongguo_C:UpdateProgress()
    -- 更新进度条和文字显示
    self.ProgressBar:SetPercent(self.Progress / 100)
    self.Progress_Text_Bar:SetText(string.format("%.0f", self.Progress))
end


function WBP_Loading_Dongguo_C:CloseUI(UnLoadingCallback)
    self.Progress = 100.0
    self:UpdateProgress()
    self:AddTimer(0.5, function()
        self:RemoveFromParent()
        if not self.ParentUI then 
            self:SetMouseCursorVisable(true)
            local GameInputSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(GWorld.GameInstance)
            if IsValid(GameInputSubsystem) then
                GameInputSubsystem:DisableInputMode("CommonChangeScene")
            end
            self:UnBindInLoading()
        end
        self.ParentUI = nil
        if UnLoadingCallback then 
            UnLoadingCallback()
        end
    end, false, 0, nil, true)
end

AssembleComponents(WBP_Loading_Dongguo_C)
return WBP_Loading_Dongguo_C
