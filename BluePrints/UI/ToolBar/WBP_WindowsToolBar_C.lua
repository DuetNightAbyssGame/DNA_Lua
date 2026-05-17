--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_WindowsToolBar_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.Common.TimerMgr"})
-- 顶栏工具条的运行时状态。TipsEnabled 控制悬浮提示显示；IsPinned 表示是否置顶；
-- IsMaximized 仅用于初始化，不参与动画前缀判断（前缀改为随用随查原生窗口状态）。
M.TipsEnabled = false
M.IsPinned = false
M.IsMaximized = false
-- 顶部吐司的简单状态机及等待句柄
M.ToastState = "Idle"
M.ToastWaitHandle = nil
M.PendingToastText = nil
-- Hover/Unhover 成对播放的会话标记：
-- HoverPinnedState 记录进入 Hover 时的形态；若 Unhover 发现形态已变更则回到 Normal 并清理轨道
M.HoverPinnedState = nil
M.HoverSessionActive = false
-- 最大化/还原在切换后的状态对齐定时器句柄
-- 已移除，使用窗口动作委托事件直接对齐

function M:GetPinAnim(Base)
    -- 根据当前是否置顶，选择 Pin 或 Pin_Up 前缀的动画对象
    local name = (self.IsPinned and "Pin_Up_" or "Pin_") .. Base
    return self[name]
end

function M:StopPinAnimations()
    -- 统一停止 Pin/Pin_Up 的 Click/Press/Hover/UnHover 轨道，避免跨形态残留和轨道竞争
    local function stop(a) if a then self:StopAnimation(a) end end
    stop(self.Pin_Click); stop(self.Pin_Press); stop(self.Pin_Hover); stop(self.Pin_UnHover)
    stop(self.Pin_Up_Click); stop(self.Pin_Up_Press); stop(self.Pin_Up_Hover); stop(self.Pin_Up_UnHover)
end

function M:PlayPinAnim(Base)
    -- 播放前先清轨，保证同一时间只有一个置顶动画在跑
    local anim = self:GetPinAnim(Base)
    if not anim then
        return
    end
    self:StopPinAnimations()
    self:PlayAnimation(anim)
end

function M:OnPinHovered()
    if not self.TipsEnabled then
        self:EnableTips()
    end
    self.HoverPinnedState = self.IsPinned
    self.HoverSessionActive = true
    self:PlayPinAnim("Hover")
end

function M:OnPinUnhovered()
    if not self.HoverSessionActive then
        self.HoverPinnedState = nil
        return
    end
    -- 若 Hover/Unhover 中形态发生切换（例如点击置顶），Unhover 不播放原来的 UnHover，
    -- 而是清轨并回到当前形态的 Normal
    if self.HoverPinnedState ~= nil and self.HoverPinnedState ~= self.IsPinned then
        self.HoverPinnedState = nil
        self.HoverSessionActive = false
        self:StopPinAnimations()
        self:PlayPinAnim("Normal")
        return
    end
    self.HoverPinnedState = nil
    self.HoverSessionActive = false
    if self:GetPinAnim("UnHover") then
        self:PlayPinAnim("UnHover")
    else
        self:PlayPinAnim("Normal")
    end
end

function M:OnPinPressed()
    self:PlayPinAnim("Press")
end

function M:OnPinReleased()
    self:PlayPinAnim("Normal")
end

function M:SetToolTips()
    -- ToolTip 文案不依赖本地状态，随用随查原生窗口是否最大化，保证快速交互时文案准确
    if self.Btn_PinBtn then
        local key = self.IsPinned and "UI_Windows_Unpin" or "UI_Windows_PinToTop"
        UE.UWindowTitleBarFunctionLibrary.SetAntiScaledToolTip(self.Btn_PinBtn, GText(key))
    end
    if self.Btn_MinBtn then
        UE.UWindowTitleBarFunctionLibrary.SetAntiScaledToolTip(self.Btn_MinBtn, GText("UI_Windows_Minimize"))
    end
    if self.Btn_FullBtn then
        local showRestore = UE.UWindowTitleBarFunctionLibrary.ShouldShowRestoreIcon()
        local key = showRestore and "UI_Windows_RestoreDownward" or "UI_Windows_Maximize"
        UE.UWindowTitleBarFunctionLibrary.SetAntiScaledToolTip(self.Btn_FullBtn, GText(key))
    end
    if self.Btn_Close then
        UE.UWindowTitleBarFunctionLibrary.SetAntiScaledToolTip(self.Btn_Close, GText("UI_Windows_Close"))
    end
end

function M:EnableTips()
    self:SetToolTips()
    self.TipsEnabled = true
end

function M:DisableTips()
    if self.Btn_PinBtn then
        UE.UWindowTitleBarFunctionLibrary.SetAntiScaledToolTip(self.Btn_PinBtn, GText())
    end
    if self.Btn_MinBtn then
        UE.UWindowTitleBarFunctionLibrary.SetAntiScaledToolTip(self.Btn_MinBtn, GText())
    end
    if self.Btn_FullBtn then
        UE.UWindowTitleBarFunctionLibrary.SetAntiScaledToolTip(self.Btn_FullBtn, GText())
    end
    if self.Btn_Close then
        UE.UWindowTitleBarFunctionLibrary.SetAntiScaledToolTip(self.Btn_Close, GText())
    end
    self.TipsEnabled = false
end

function M:Construct()
    -- 构建时清理并重新绑定所有按钮事件，避免重复绑定导致多次回调；
    -- 并根据原生窗口状态播放 Full 的 Normal
    if self.Text_GameTitle then
        self.Text_GameTitle:SetText(GText("UI_Windows_GameName"))
    end
    if self.Btn_PinBtn and self.Btn_PinBtn.OnClicked then
        self.Btn_PinBtn.OnClicked:Clear()
        self.Btn_PinBtn.OnHovered:Clear()
        self.Btn_PinBtn.OnUnhovered:Clear()
        self.Btn_PinBtn.OnPressed:Clear()
        self.Btn_PinBtn.OnReleased:Clear()
        self.Btn_PinBtn.OnClicked:Add(self, self.OnPinClicked)
        if self.Btn_PinBtn.OnHovered then
            self.Btn_PinBtn.OnHovered:Add(self, self.OnPinHovered)
        end
        if self.Btn_PinBtn.OnUnhovered then
            self.Btn_PinBtn.OnUnhovered:Add(self, self.OnPinUnhovered)
        end
        if self.Btn_PinBtn.OnPressed then
            self.Btn_PinBtn.OnPressed:Add(self, self.OnPinPressed)
        end
        if self.Btn_PinBtn.OnReleased then
            self.Btn_PinBtn.OnReleased:Add(self, self.OnPinReleased)
        end
    end
    if self.Btn_MinBtn then
        self.Btn_MinBtn.OnClicked:Add(self, self.OnMinimizeClicked)
    end
    if self.Btn_FullBtn and self.Btn_FullBtn.OnClicked then
        self.Btn_FullBtn.OnClicked:Clear()
        self.Btn_FullBtn.OnHovered:Clear()
        self.Btn_FullBtn.OnUnhovered:Clear()
        self.Btn_FullBtn.OnPressed:Clear()
        self.Btn_FullBtn.OnReleased:Clear()
        self.Btn_FullBtn.OnClicked:Add(self, self.OnMaximizeClicked)
        if self.Btn_FullBtn.OnHovered then
            self.Btn_FullBtn.OnHovered:Add(self, self.OnFullHovered)
        end
        if self.Btn_FullBtn.OnUnhovered then
            self.Btn_FullBtn.OnUnhovered:Add(self, self.OnFullUnhovered)
        end
        if self.Btn_FullBtn.OnPressed then
            self.Btn_FullBtn.OnPressed:Add(self, self.OnFullPressed)
        end
        if self.Btn_FullBtn.OnReleased then
            self.Btn_FullBtn.OnReleased:Add(self, self.OnFullReleased)
        end
    end
    if self.Btn_Close then
        self.Btn_Close.OnClicked:Add(self, self.OnCloseClicked)
    end
    local isMax = UE.UWindowTitleBarFunctionLibrary.IsGameWindowMaximized()
    self.IsMaximized = isMax and true or false
    self.IsPinned = self.IsPinned and true or false
    if self.WidgetSwitcher_Max then
        self.WidgetSwitcher_Max:SetActiveWidgetIndex(self.IsMaximized and 1 or 0)
    end
    self:EnableTips()
    if self.Tips_In then
        self:BindToAnimationFinished(self.Tips_In, {self, self.OnTipsInFinished})
    end
    if self.Tips_Out then
        self:BindToAnimationFinished(self.Tips_Out, {self, self.OnTipsOutFinished})
    end
    local Root = UE.UWindowTitleBarFunctionLibrary.GetWindowTitleBarRootWidget()
    if Root and Root.OnWindowMaximizeStateChanged then
        Root.OnWindowMaximizeStateChanged:Add(self, self.OnWindowMaximizeStateChanged)
    end
end

function M:OnPinClicked()
    -- 置顶/取消置顶：先清轨再播放 Click/Reverse，并切换系统置顶；随后刷新 Tips 与 Toast
    self.HoverSessionActive = false
    self.HoverPinnedState = nil
    local willPin = not self.IsPinned
    self.IsPinned = willPin

    -- 播放音效
    if willPin then
        AudioManager(self):PlayUISound(self, "event:/ui/common/pin", nil, nil)
    else
        AudioManager(self):PlayUISound(self, "event:/ui/common/pin_cancel", nil, nil)
    end

    if self.Pin_Click then
        self:StopPinAnimations()
        if willPin then
            self:PlayAnimation(self.Pin_Click)
        else
            self:PlayAnimationReverse(self.Pin_Click)
        end
    end
    UE.UWindowTitleBarFunctionLibrary.ToggleAlwaysOnTopGameWindow()
    if self.TipsEnabled then
        self:SetToolTips()
    end
    local key = self.IsPinned and "UI_Windows_Toast_PinToTop" or "UI_Windows_Toast_Unpin"
    self:ShowTopToast(key)
end

function M:OnMinimizeClicked()
    if self.TipsEnabled then
        self:DisableTips()
    end
    UE.UWindowTitleBarFunctionLibrary.MinimizeGameWindow()
end

function M:OnMaximizeClicked()
    if not self.TipsEnabled then
        self:EnableTips()
    end
    UE.UWindowTitleBarFunctionLibrary.ToggleMaximizeRestoreGameWindow()
end

function M:OnWindowMaximizeStateChanged(bMaximized)
    self.IsMaximized = bMaximized and true or false
    if self.WidgetSwitcher_Max then
        self.WidgetSwitcher_Max:SetActiveWidgetIndex(self.IsMaximized and 1 or 0)
    end
    if self.TipsEnabled then
        self:SetToolTips()
    end
end

function M:OnCloseClicked()
    if self.TipsEnabled then
        self:DisableTips()
    end
    UE.UWindowTitleBarFunctionLibrary.CloseGameWindow()
end

function M:ShowTopToast(Key)
    -- 顶部吐司：简单的“进/等待/出”状态机，支持堆叠切换文本；避免动画中替换造成卡顿
    if not self.Text_TopTips or not self.Tips_In or not self.Tips_Out then
        return
    end
    local Text = GText(Key)
    if self.ToastState == "Idle" then
        self.Text_TopTips:SetText(Text)
        self:PlayAnimation(self.Tips_In)
        self.ToastState = "In"
        return
    end
    if self.ToastState == "In" or self.ToastState == "Wait" then
        self:RemoveTimer("TopToastAutoOut", true)
        self.PendingToastText = Text
        self:PlayAnimation(self.Tips_Out)
        self.ToastState = "Out"
        return
    end
    if self.ToastState == "Out" then
        self.PendingToastText = Text
        return
    end
end

function M:OnTipsInFinished()
    self.ToastState = "Wait"
    self:AddTimer(2.0, function(self)
        if self.ToastState == "Wait" then
            self:PlayAnimation(self.Tips_Out)
            self.ToastState = "Out"
        end
    end, false, 0, "TopToastAutoOut", true)
end

function M:OnTipsOutFinished()
    -- Out 完成后若有待显示文本则继续 In，否则回 Idle
    if self.PendingToastText then
        self.Text_TopTips:SetText(self.PendingToastText)
        self.PendingToastText = nil
        self:PlayAnimation(self.Tips_In)
        self.ToastState = "In"
    else
        self.ToastState = "Idle"
    end
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
    return UE.UWidgetBlueprintLibrary.Unhandled()
end

function M:GetFullAnim(Base)
    -- 动画前缀按原生窗口状态即时选择：
    -- 非窗口化或已最大化时展示“还原”样式（Full_Window_），窗口化且未最大化时展示“最大化”样式（Full_Max_）
    local showRestore = UE.UWindowTitleBarFunctionLibrary.ShouldShowRestoreIcon()
    local prefix = (showRestore and "Full_Window_" or "Full_Max_")
    return self[prefix .. Base]
end

function M:StopFullAnimations()
    -- 停止 Full_Max/Full_Window 两套五态轨道，避免残留与竞争
    local function stop(a) if a then self:StopAnimation(a) end end
    stop(self.Full_Max_Click); stop(self.Full_Max_Press); stop(self.Full_Max_Hover); stop(self.Full_Max_UnHover)
    stop(self.Full_Window_Click); stop(self.Full_Window_Press); stop(self.Full_Window_Hover); stop(self.Full_Window_UnHover)
end

function M:PlayFullAnim(Base)
    -- 播放前先统一清轨，保证状态切换后的动画一致性
    local anim = self:GetFullAnim(Base)
    if not anim then return end
    self:StopFullAnimations()
    self:PlayAnimation(anim)
end

function M:OnFullHovered()
    -- 悬停时刷新 ToolTip，确保提示文案与原生状态同步
    if self.TipsEnabled then
        self:SetToolTips()
    end
    self:PlayFullAnim("Hover")
end

function M:OnFullUnhovered()
    -- 优先播放对应 UnHover；若未配置则回到 Normal
    local anim = self:GetFullAnim("UnHover")
    if anim then
        self:PlayFullAnim("UnHover")
    else
        self:PlayFullAnim("Normal")
    end
end

function M:OnFullPressed()
    self:PlayFullAnim("Press")
end

function M:OnFullReleased()
    self:PlayFullAnim("Normal")
end

-- 原先的切换后一次性对齐逻辑已移除，改为由窗口动作委托驱动索引与提示同步

-- function M:OnAnimationStarted(InAnim)
--     ScreenPrint("OnAnimationStarted: " .. InAnim:GetName())
-- end
return M
