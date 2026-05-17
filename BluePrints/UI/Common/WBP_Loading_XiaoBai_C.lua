--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_Loading_XiaoBai_C
local WBP_Com_Loading_XiaoBai_C = Class({ "BluePrints.UI.BP_UIState_C" })
WBP_Com_Loading_XiaoBai_C._components = {
    "BluePrints.UI.WidgetComponent.ChangeTextToKeyInfoComponent",
}
--function M:Initialize(Initializer)
--end

function WBP_Com_Loading_XiaoBai_C:Construct()
    self:AddInputMethodChangedListen()
    self:Init()
    self.Button_461.OnClicked:Clear()
    self.Button_461.OnClicked:Add(self, self.SetXiaoBaiRandomTips)
    self:SetFocus()
    self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self.CurrentInputDevice = {"GamepadKey"}
    else
        self.CurrentInputDevice = {"KeyboardKey","MouseButton"}
    end
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then return end

    self:UpdateUIStyleInPlatform(UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad)
end

function WBP_Com_Loading_XiaoBai_C:Destruct()
    self:CleanTimer()
    AudioManager(self):ReplayBGMAfterLoading()
end

function WBP_Com_Loading_XiaoBai_C:Tick(MyGeometry, InDeltaTime)
    if not self.IsWaiting then return end

    -- 增加等待时间
    self.ElapsedWaitTime = self.ElapsedWaitTime + InDeltaTime
    if self.ElapsedWaitTime >= self.WaitDuration then
        self.IsWaiting = false -- 结束等待状态

        -- 根据当前动画模式切换播放方向
        if self.CurrentAnimationMode == "Forward" then
            self:PlayXiaoBaiChangeAnimationReverse()
        else
            self:PlayXiaoBaiChangeAnimationForward()
        end
    end
    if not self.bUseFakeProgress or not self.IsProgressing then return end
    -- 更新进度条进度
    self.Progress = self.Progress + self.ProgressSpeed * InDeltaTime
    if self.Progress >= 99.0 then
        self.Progress = 99.0
        self.IsProgressing = false     -- 停止进度更新
    end

    -- 更新进度条和文字显示
    self:UpdateProgress()
end

function WBP_Com_Loading_XiaoBai_C:UpdateProgress()
    -- 更新进度条和文字显示
    self.ProgressBar:SetPercent(self.Progress / 100)
    self.Text_Progress:SetText(string.format("%.0f", self.Progress))
    self.Text_Progress_Back:SetText(string.format("%.0f", self.Progress))
end

function WBP_Com_Loading_XiaoBai_C:Init()
    self.CurrentInputDevice = { "KeyboardKey", "MouseButton" }
    self.IsPlaying = true
    self.IsWaiting = false
    self.CurrentAnimationMode = "Forward"
    self.WaitDuration = self.ChangeTime -- 等待时长
    self.ElapsedWaitTime = 0.0          -- 已经过的等待时间
    -- 初始化假进度条相关变量
    self.Progress = 0.0
    self.ProgressSpeed = 100.0
    self.bUseFakeProgress = false -- 默认不启用假进度条
    self.IsProgressing = true
    self:PlayAnimation(self.In)
    self:SetXiaoBaiRandomTips()
    --self:PlayXiaoBaiChangeAnimationForward()
    self:UpdateProgress()
end

-- 正向播放动画
function WBP_Com_Loading_XiaoBai_C:PlayXiaoBaiChangeAnimationForward()
    if not self.IsPlaying then return end
    self:PlayAnimation(self.Change, 0, 1, EUMGSequencePlayMode.Forward, 1.0)
    self.CurrentAnimationMode = "Forward"
    DebugPrint("正向播放动画")
end

-- 倒放动画
function WBP_Com_Loading_XiaoBai_C:PlayXiaoBaiChangeAnimationReverse()
    if not self.IsPlaying then return end
    self:PlayAnimation(self.Change, 0, 1, EUMGSequencePlayMode.Reverse, 1.0)
    self.CurrentAnimationMode = "Reverse"
    DebugPrint("倒放动画")
end

-- 动画完成后的回调
function WBP_Com_Loading_XiaoBai_C:OnAnimationFinished(InAnimation)
    -- if InAnimation == self.Out then
    --     UIManager(self):UnLoadUINew("BlackScreenXiaobai")
    -- end
    -- if InAnimation ~= self.Change then
    --     return
    -- end
    if not self.IsPlaying then return end
    DebugPrint("动画完成: " .. self.CurrentAnimationMode)

    -- 动画完成后进入等待状态
    self.IsWaiting = true
    self.ElapsedWaitTime = 0.0
end

function WBP_Com_Loading_XiaoBai_C:SetXiaoBaiRandomTips()
    --self.ShowTipsInterval = Const.LoadingTipsInterval
    local RandomTips = self:GetRandomLoadingTips()
    self.Text_Title:SetText(RandomTips.Title)
    -- local Messages = self:AnalyzeText(RandomTips.Message)
    -- local Content = ""
    -- for _, Message in ipairs(Messages) do
    --     if string.find(Message, "&") then
    --         local ActionName = string.sub(Message, 2, -2)
    --         -- print(_G.LogTag, ActionName)
    --         local Key, KeyType = self:GetKeyName(ActionName)
    --         Content = Content .. Key
    --     else
    --         Content = Content .. Message
    --     end
    -- end
    local Messages = self:GetFinalContentText(RandomTips.Message,self.CurrentInputDevice)
    self.Text_Message:SetText(Messages)
end

function WBP_Com_Loading_XiaoBai_C:GetRandomLoadingTips()
    if not self.TipsPoolByPlatform then
        self.TipsPoolByPlatform = {
            PC = {},
            Mobile = {},
            Gamepad = {}
        }

        local TipsTable = DataMgr.Message

        for _, v in pairs(TipsTable) do
            if v.MessageType == "LoadingText" then
                -- PC Tips
                if v.MessageContentPC then
                    table.insert(self.TipsPoolByPlatform.PC, {
                        Title = GText(v.MessageTitlePC or ""),
                        Message = GText(v.MessageContentPC)
                    })
                end

                -- Mobile Tips
                if v.MessageContentPhone then
                    table.insert(self.TipsPoolByPlatform.Mobile, {
                        Title = GText(v.MessageTitlePC or ""),
                        Message = GText(v.MessageContentPhone)
                    })
                end

                -- Gamepad Tips
                --Gamepad：优先使用 GamePad 字段，否则使用 PC 字段
                local gamepadMsg = v.MessageContentGamePad or v.MessageContentPC
                if gamepadMsg then
                    table.insert(self.TipsPoolByPlatform.Gamepad, {
                        Title =  GText(v.MessageTitlePC or ""),
                        Message = GText(gamepadMsg)
                    })
                end
            end
        end
    end

    -- 根据当前平台取对应 Tip 列表
    local TipsList = nil

    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        TipsList = self.TipsPoolByPlatform.Gamepad
    elseif CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        TipsList = self.TipsPoolByPlatform.PC
    elseif CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        TipsList = self.TipsPoolByPlatform.Mobile
    end

    -- 防止空
    if not TipsList or #TipsList == 0 then
        return { Title = "", Message = "" }
    end

    local RandomIndex = math.random(1, #TipsList)
    return TipsList[RandomIndex]
end



function WBP_Com_Loading_XiaoBai_C:CloseUI()
    self.Progress = 100.0
    self:UpdateProgress()
    self:AddTimer(0.5, function()
        UIManager(self):UnLoadUINew("BlackScreenXiaobai")
    end, false, 0, nil, true)
end

-- function WBP_Com_Loading_XiaoBai_C:OnKeyDown(MyGeometry, InKeyEvent)
--     local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
--     local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
--     local IsEventHandled = false
--     if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
--         IsEventHandled = self:OnGamePadDown(InKeyName)
--     end
--     if (IsEventHandled) then
--         return UWidgetBlueprintLibrary.Handled()
--     else
--         return UWidgetBlueprintLibrary.UnHandled()
--     end
-- end

-- function WBP_Com_Loading_XiaoBai_C:OnGamePadDown(InKeyName)
--     DebugPrint("SL OnGamePadDown is DeputeEliteDropItem InKeyName", InKeyName)
--     local IsEventHandled = false
--     if InKeyName == Const.GamepadFaceButtonDown then
--         IsEventHandled = true
--     end
--     return IsEventHandled
-- end

function WBP_Com_Loading_XiaoBai_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 输入设备切换通知
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    self:SetXiaoBaiRandomTips()

end

function WBP_Com_Loading_XiaoBai_C:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    if IsUseKeyAndMouse then
        self.Com_KeyTitle:SetVisibility(ESlateVisibility.Collapsed)
        self.CurrentInputDevice = {"KeyboardKey","MouseButton"}
    else
        self.CurrentInputDevice = {"GamepadKey"}
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
    end

end
AssembleComponents(WBP_Com_Loading_XiaoBai_C)
return WBP_Com_Loading_XiaoBai_C
