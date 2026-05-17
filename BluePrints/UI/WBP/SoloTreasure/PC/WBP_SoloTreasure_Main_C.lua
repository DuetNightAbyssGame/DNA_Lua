--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_SoloTreasure_Hud_P_C
local WBP_SoloTreasure_Hud_P_C = Class({"BluePrints.UI.BP_UIState_C", "BluePrints.Common.TimerMgr"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function WBP_SoloTreasure_Hud_P_C:Destruct()
    self:ClearListenEvent()
    EventManager:RemoveEvent(EventID.UpdateGamePoints, self)
end

function WBP_SoloTreasure_Hud_P_C:InitUIInfo(Name, IsInUIMode, EventList, ...)
    self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
    self.DungeonId = ...
    --数据初始化
    self:InitData(self.DungeonId)
    --文本初始化
    self:InitText()
    --倒计时初始化
    self:InitCountDown()
    --按钮初始化
    self:InitBtn()
    --打开弹窗提示
    self:OpenTips("TaskStart")


    --设备监听初始化
    self:InitListenEvent()
    --注册更新积分事件
    EventManager:AddEvent(EventID.UpdateGamePoints, self, self.UpdateGamePoints)
    self:PlayAnimation(self.In)
end

--初始化副本配置数据
function WBP_SoloTreasure_Hud_P_C:InitData(DungeonId)
    self.GamePoints = 0
end

--设置文本
function WBP_SoloTreasure_Hud_P_C:InitText()
    self.Text_AllNum:SetText("0")
end

--设置积分数量（是否需要与服务器同步积分）
function WBP_SoloTreasure_Hud_P_C:SetDungeonPoints(Points)
    if Points and type(Points) == "number" then
        self.GamePoints = self.GamePoints + Points
        --数字滚动逻辑

    end
end

--更新游戏积分事件回调
function WBP_SoloTreasure_Hud_P_C:UpdateGamePoints(Points)
    self:SetDungeonPoints(Points)
end

--------------------------------------------------------------------------------------------

--创建开始UI
function WBP_SoloTreasure_Hud_P_C:OpenTips(TipType)
    --先隐藏倒计时
    self.Overlay_Time:SetVisibility(ESlateVisibility.Collapsed)
    self.OverlayTips:ClearChildren()
    --弹窗提示(需要在动画完成后有回调把倒计时UI显示出来)
    self.Tips = self:CreateWidgetNew("SoloTreasureRemainTimeTip")
    self.OverlayTips:AddChild(self.Tips)
    --弹窗提示结束后再显示倒计时
    local Parmas = {}
    Parmas.TipType = TipType
    Parmas.Owner = self
    Parmas.TimerHandleName = self.CurTimerHandle
    Parmas.Callback = function()
        self.Overlay_Time:SetVisibility(ESlateVisibility.Visible)
        self:PlayAnimation(self.In)
    end
    self.Tips:InitWidget(Parmas)
end

--设置倒计时
function WBP_SoloTreasure_Hud_P_C:InitCountDown(TimerHandleName)
    self.Switch_TimeType:SetActiveWidgetIndex(0)
    self.CurTimerHandle = TimerHandleName
    self.IsRed = false
    self:AddTimer(0.1, self.UpdateCountDownUI, true, 0, "CountDown", true)
end

function WBP_SoloTreasure_Hud_P_C:UpdateCountDownUI()
    --local DisplayRemainTime = CommonUtils.GetClientTimerStructRemainTime(self.CurTimerHandle)
    local DisplayRemainTime = 300
    if DisplayRemainTime < 0 then
        DisplayRemainTime = 0
    elseif DisplayRemainTime < 60 then
        if not self.IsRed then
            self.Switch_TimeType:SetActiveWidgetIndex(1)
            self:OpenTips("TimeWarning")
            self.IsRed = true
        end
    elseif DisplayRemainTime < 10 then
        self:PlayAnimation(self.Time_Warning)
    end
    self.Text_TimeTop:SetText(self:GetTimeStr_Cpp(DisplayRemainTime))
end

--------------------------------------------------------------------------------------------

--初始化按钮
function WBP_SoloTreasure_Hud_P_C:InitBtn()
    --副本内为退出按钮
    self.Btn_Esc:LoadImage(11)
end

--初始化设备监听
function WBP_SoloTreasure_Hud_P_C:InitListenEvent()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

--清除设备监听
function WBP_SoloTreasure_Hud_P_C:ClearListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    end
end

--根据输入设备刷新UI
function WBP_SoloTreasure_Hud_P_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end
    self.CurInputDeviceType = CurInputDevice
    local IsUseGamePad = CurInputDevice == ECommonInputType.Gamepad
    self:UpdateUIByDevice()
end

--切换设备更新UI
function WBP_SoloTreasure_Hud_P_C:UpdateUIByDevice()
    -- body
end

return WBP_SoloTreasure_Hud_P_C
