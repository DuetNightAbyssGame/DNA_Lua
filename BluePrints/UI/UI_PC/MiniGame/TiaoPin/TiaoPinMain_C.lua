--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_MiniGame_Tiaopin_P_C
local WBP_MiniGame_Tiaopin_P_C = Class({"BluePrints.UI.BP_UIState_C", "BluePrints.Common.TimerMgr"})

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function WBP_MiniGame_Tiaopin_P_C:OnLoaded(...)
    WBP_MiniGame_Tiaopin_P_C.Super.OnLoaded(self, ...)
    --显示鼠标  接入手柄后要改判断
    self.PlayerController = UGameplayStatics.GetPlayerController(self, 0)
    --获取游戏难度easy/normal/hard
    --self.Difficulty
    --游戏时间
    self.RemainTime = self.GameTime or 60
    self.TimeHandleName = "CountDown"
    self.IsInCD = false
    self.IsPressEsc = false
    self.IsWin = false
    self.IsClosing = false
end

--小游戏机关需要重写，时序上比OnLoaded晚一些
function WBP_MiniGame_Tiaopin_P_C:InitAfterBeginPlay()
    DebugPrint("thy    InitAfterBeginPlay", self.Difficulty)
    self:InitDataInfo()
    self:InitUI()
    self:InitCrack()
    self:InitDeviceInfo()
    self:InitListenEvent()
    self:PlayAnimation(self.In)
    AudioManager(self):PlayUISound(self, "event:/ui/minigame/tiaopin_start", "TiaoPinStart", nil)
    self:SetFocus()
end

function WBP_MiniGame_Tiaopin_P_C:InitDataInfo()
    self.GameDifficulty = self.Difficulty or 1
    self.GameDataInfo = DataMgr["MiniGameFreq"..self.GameDifficulty]
    if not self.GameDataInfo then
        DebugPrint("thy    GameDataInfo is nil")
    end
    --随机一个频率样式
    self.FreqType = math.random(#self.GameDataInfo)
    --获取对应样式的初始化信息
    self.FreqInfo = self.GameDataInfo[self.FreqType]
    --列数
    self.RowNum = self.FreqInfo.Num
    --调频条数
    self.TiaoPinListLen = self.RowNum
    --目标位置
    self.Destination = self.FreqInfo.Destination
    --白点位置
    self.OriginPointPosition = self.FreqInfo.Comb
    --绑定关系(x,y) x为绑定的列数，y为绑定列数之间的间隔
    self.BindingRealtion = self.FreqInfo.BindingRealtion
    --绑定数量
    self.BindingRowNum = self.BindingRealtion[1]
    --绑定间的间隔
    self.BindingRowInterval = self.BindingRealtion[2]
    --移动幅度
    self.MoveRange = self.FreqInfo.MoveRange or 1
    --点的可移动位置
    self.PointPosition = {
        -177,-140,-105,-70,-35,0,35,70,105,140,177
    }
    --绑定关系
    self.BindingIndex = {}
    DebugPrint("thy   GameConfigInfo: self.GameDifficulty "..self.GameDifficulty.." self.FreqType "..self.FreqType.." self.RowNum "..self.RowNum.." self.BindingRowNum "..self.BindingRowNum.." self.BindingRowInterval "..self.BindingRowInterval.." self.MoveRange "..self.MoveRange)
end

function WBP_MiniGame_Tiaopin_P_C:InitUI()
    --上方玩法介绍textmap
    self.Text_Float:SetText(GText("UI_MiniGame_Hint_TiaoPin"))
    self.MiniGame_Text.Text_Fail:SetText(GText("UI_MiniGame_Fail"))
    self.MiniGame_Text.Text_Success:SetText(GText("UI_MiniGame_Success"))
    --设置时间
    self:InitTime()
    --初始化调频界面
    self:InitFreqUI()
    --初始化按钮UI
    self:InitButtonUIAndEvent()
    --初始化底部快捷键提示  转移到设备监听调用
    --self:InitBtnTipsUI()
end

function WBP_MiniGame_Tiaopin_P_C:InitBtnTipsUI()
    DebugPrint("thy    InitBtnTipsUI", self.CurInputDeviceType)
    if not self.CurInputDeviceType or self.CurInputDeviceType == ECommonInputType.Touch then
        --self.Key_Switch:SetVisibility(ESlateVisibility.Collapsed)
        --self.Key_Move:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_Close:SetVisibility(ESlateVisibility.Collapsed)
        self.ClickCD = self.ClickCDInPC or 0.1
        return
    end
    -- KeyInfo = {
    --     KeyInfoList={
    --         {
    --             Type = "Text", 类型："Text"或" "Img"
    --             Text = "Esc"   按键文本
    --             ImgShortPath = "RightMouseButton", 按键短图片路径
    --             ImgLongPath = "Texture2D'/Game/UI/UI_PNG/Common/Key/Icon_Mouse_Button.Icon_Mouse_Button'", 按键全图片路径
    --         }, 如果有多个按键，按照顺序填写
             
    --     },
    --     Desc = GText("UI_BACK"),    按键功能描述，没有别填
    --     bLongPress = false     ,    是否长按，Button填，Show别填
    -- }
    if self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard then
        self.ClickCD = self.ClickCDInPC or 0.1
        self.KeyInfo1 = {
            Type = "Or",
            KeyInfoList={
                {
                    Type = "Text",
                    Text = "A",
                },
                {
                    Type = "Text",
                    Text = "D",
                },
            },
            Desc = GText("UI_Controller_Switch"),
        }
    
        self.KeyInfo2 = {
            Type = "Or",
            KeyInfoList={
                {
                    Type = "Text",
                    Text = "W",
                },
                {
                    Type = "Text",
                    Text = "S",
                },
            },
            Desc = GText("UI_CTL_Move"),
        }
    
        self.KeyInfo3 = {
            KeyInfoList={
                {
                    ClickCallback = self.TimeOut,
                    Owner = self,
                    Type = "Text",
                    Text = "Esc",
                },
            },
            Desc = GText("UI_BACK"),
        }
        if self.Key_Switch and self.Key_Move then
            self.Key_Switch:CreateSubKeyDesc(self.KeyInfo1)
            self.Key_Move:CreateSubKeyDesc(self.KeyInfo2)
            self.Key_Close:CreateCommonKey(self.KeyInfo3)
        end
    else
        self.ClickCD = self.ClickCDInGamepad or 0.2
        self.KeyInfo1 = {
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "LH",
                },
            },
            Desc = GText("UI_Controller_Switch"),
        }
    
        self.KeyInfo2 = {
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "LV",
                },
            },
            Desc = GText("UI_CTL_Move"),
        }
    
        self.KeyInfo3 = {
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "B",
                },
            },
            Desc = GText("UI_BACK"),
        }
        if self.Key_Switch and self.Key_Move then
            self.Key_Switch:CreateCommonKey(self.KeyInfo1)
            self.Key_Move:CreateCommonKey(self.KeyInfo2)
            self.Key_Close:CreateCommonKey(self.KeyInfo3)
        end
    end
end

--初始化解锁和重置
function WBP_MiniGame_Tiaopin_P_C:InitCrack()

    
    local Param = {
        RootPage = self,
        SuccCallBack = self.CompleteGame,
        ResetCallBack = self.Reset,
        NeedCrack = self.bCanCrack or false,
        NeedReset = true,
    }
    self.MiniGame_Crack:SetVisibility(ESlateVisibility.Visibility)
    self.MiniGame_Crack:Init(Param)
end

--重置回调
function WBP_MiniGame_Tiaopin_P_C:Reset()
    --位置
    for key, value in pairs(self.TiaoPinList) do
        value:ResetPointPosition()
    end
    --选中动画
    self:InitBindingRowAnimation()
end

--初始化按钮和事件
function WBP_MiniGame_Tiaopin_P_C:InitButtonUIAndEvent()
    if self.MoveRange > 1 then
        self.Switcher_D:SetActiveWidgetIndex(1)
        self.Switcher_T:SetActiveWidgetIndex(1)
    else
        self.Switcher_D:SetActiveWidgetIndex(0)
        self.Switcher_T:SetActiveWidgetIndex(0)
    end
    self.Btn_L.OnClicked:Add(self, self.OnBtnLClicked)
    self.Btn_R.OnClicked:Add(self, self.OnBtnRClicked)
    self.Btn_D.OnClicked:Add(self, self.OnBtnDClicked)
    self.Btn_T.OnClicked:Add(self, self.OnBtnTClicked)
    if self.Btn_Close then
        self.Btn_Close:Init("Close", self, self.ExitGameByMoble)
    end
end

--左
function WBP_MiniGame_Tiaopin_P_C:OnBtnLClicked()
    if self:CheckIsInCD() then return end
    local CurTiaoPinBaseIndex = self.BindingIndex[1]
    if self:CheckBindingRow(CurTiaoPinBaseIndex - 1) then
        self:UpdateBindingRowAnimation()
        AudioManager(self):PlayUISound(self, "event:/ui/minigame/tiaopin_bar_change", "TiaoPinChageBar", nil)
    else
        local TiaoPin = self.TiaoPinList[CurTiaoPinBaseIndex]
        TiaoPin:PlayAnimation(TiaoPin.Select_Warning)
        AudioManager(self):PlayUISound(self, "event:/ui/minigame/tiaopin_block_or_bar_err", "TiaoPinWarning", nil)
    end
end

--右
function WBP_MiniGame_Tiaopin_P_C:OnBtnRClicked()
    if self:CheckIsInCD() then return end
    local CurTiaoPinBaseIndex = self.BindingIndex[1]
    if self:CheckBindingRow(CurTiaoPinBaseIndex + 1) then
        self:UpdateBindingRowAnimation()
        AudioManager(self):PlayUISound(self, "event:/ui/minigame/tiaopin_bar_change", "TiaoPinChageBar", nil)
    else
        local TiaoPin = self.TiaoPinList[self.BindingIndex[#self.BindingIndex]]
        TiaoPin:PlayAnimation(TiaoPin.Select_Warning)
        AudioManager(self):PlayUISound(self, "event:/ui/minigame/tiaopin_block_or_bar_err", "TiaoPinWarning", nil)
    end
end

--下
function WBP_MiniGame_Tiaopin_P_C:OnBtnDClicked()
    if self:CheckIsInCD() then return end
    local CanMove = true
    for key, value in pairs(self.BindingIndex) do
        local TiaoPin = self.TiaoPinList[value]
        if not TiaoPin:CheckCanMovePointDown() then
            CanMove = false 
        end
    end

    if CanMove then
        local HeightMax = 0
        for key, value in pairs(self.BindingIndex) do
            self.TiaoPinList[value]:MovePointDown()
            HeightMax = math.max(HeightMax, self.TiaoPinList[value].CurrentPositionIndex)
        end
        AudioManager(self):PlayUISound(self, "event:/ui/minigame/tiaopin_block_move", "TiaoPinWhiteMove", {progress = (1 - HeightMax / #self.PointPosition)})
        self:CheckIsCompleteGame()
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/minigame/tiaopin_block_or_bar_err", "TiaoPinWarning", nil)
end

--上
function WBP_MiniGame_Tiaopin_P_C:OnBtnTClicked()
    if self:CheckIsInCD() then return end
    local CanMove = true
    for key, value in pairs(self.BindingIndex) do
        local TiaoPin = self.TiaoPinList[value]
        if not TiaoPin:CheckCanMovePointUp() then
            CanMove = false 
        end
    end

    if CanMove then
        local HeightMax = 0
        for key, value in pairs(self.BindingIndex) do
            self.TiaoPinList[value]:MovePointUp()
            HeightMax = math.max(HeightMax, self.TiaoPinList[value].CurrentPositionIndex)
        end
        AudioManager(self):PlayUISound(self, "event:/ui/minigame/tiaopin_block_move", "TiaoPinWhiteMove", {progress = (1 - HeightMax / #self.PointPosition)})
        self:CheckIsCompleteGame()
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/minigame/tiaopin_block_or_bar_err", "TiaoPinWarning", nil)
end

--给按钮设CD
function WBP_MiniGame_Tiaopin_P_C:CheckIsInCD()
    if self.IsInCD then
        DebugPrint("thy       self.IsInCD", self.IsInCD)
        return true
    else
        self.IsInCD = true
        self:AddTimer(self.ClickCD, self.CDIsOver, false, 0, "CD", true)
        return false
    end
end

function WBP_MiniGame_Tiaopin_P_C:CDIsOver()
    self.IsInCD = false
    self:RemoveTimer("CD")
end

--初始化时间
function WBP_MiniGame_Tiaopin_P_C:InitTime()
    self:RemoveTimer(self.TimeHandleName)
    -- self.Panel_Time:SetRenderOpacity(1)
    self.MiniGame_Time.Text_Time:SetText("00:"..tostring(self.RemainTime))
    self:AddTimer(1, self.CountDown, true, 0.1, self.TimeHandleName, true)
end

--初始化倒计时
function WBP_MiniGame_Tiaopin_P_C:CountDown()
    self.RemainTime = self.RemainTime - 1
    if self.RemainTime < 0 then
        if self.IsClosing then
            return
        end
        self:TimeOut()
        self.IsClosing = true
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/minigame/tiaopin_countdown", "TiaoPinCountDown", nil)
    if self.RemainTime < 10 then
        self:PlayAnimation(self.Warning)
        self.MiniGame_Time.Text_Time:SetText("00:0"..tostring(self.RemainTime))
        return
    end
    self.MiniGame_Time.Text_Time:SetText("00:"..tostring(self.RemainTime))
end

--初始化调频界面
function WBP_MiniGame_Tiaopin_P_C:InitFreqUI()
    self.TiaoPinList = {}
    self.ListView_255:ClearListItems()
    --加载所有列
    for i = 1, self.RowNum do
        local TiaoPin =  NewObject(UIUtils.GetCommonItemContentClass())
        TiaoPin.Owner = self
        TiaoPin.OriginPointPositionIndex = self.OriginPointPosition[i]
        TiaoPin.CurrentPositionIndex = self.OriginPointPosition[i]
        TiaoPin.TargetPointPositionIndex = self.Destination[i]
        TiaoPin.MoveRange = self.MoveRange
        TiaoPin.Index = i

        self.ListView_255:AddItem(TiaoPin)
    end
end

function WBP_MiniGame_Tiaopin_P_C:InitBindingRowAnimation()
    if self:CheckBindingRow(1) then
        self:UpdateBindingRowAnimation()
    end
end

function WBP_MiniGame_Tiaopin_P_C:AddItemInTiaoPinList(Index, TiaoPin)
    self.TiaoPinList[Index] = TiaoPin
    --初始化最开始的绑定关系
    if Index == self.TiaoPinListLen then
        self:InitBindingRowAnimation()
    end
end

--检查是否能继续存在绑定关系，永远以最左边的列为基准 
function WBP_MiniGame_Tiaopin_P_C:CheckBindingRow(MoveTargetRowIndex)
    if MoveTargetRowIndex < 1 or MoveTargetRowIndex > self.TiaoPinListLen then
        return false 
    end
    local PreBindingIndex = {MoveTargetRowIndex}
    for i = 1, self.BindingRowNum - 1 do
        MoveTargetRowIndex = MoveTargetRowIndex + self.BindingRowInterval + 1
        if MoveTargetRowIndex > self.RowNum then
            return false
        else
            table.insert(PreBindingIndex, MoveTargetRowIndex)
        end
    end
    self.BindingIndex = PreBindingIndex
    return true
end

--更新有绑定关系列的选中动画
function WBP_MiniGame_Tiaopin_P_C:UpdateBindingRowAnimation()
    if not self.BindingIndex or #self.BindingIndex == 0 then
        return
    end
    for index = 1, self.TiaoPinListLen do
        self.TiaoPinList[index]:CloseSelectState()
    end
    for _, value in pairs(self.BindingIndex) do
        self.TiaoPinList[value]:OpenSelectState()
    end
end

--检查是否完成游戏目标
function WBP_MiniGame_Tiaopin_P_C:CheckIsCompleteGame()
    for index = 1, self.TiaoPinListLen do
        if not self.TiaoPinList[index].IsComplete then return end
    end
    self:CompleteGame()
end

--完成游戏
function WBP_MiniGame_Tiaopin_P_C:CompleteGame()
    for key, value in pairs(self.TiaoPinList) do
        value:PlayAnimation(value.Success_Out)
        self:BlockAllUIInput(true,"SP_DisplayOnly")
    end
    self.IsWin = true
    self:BindToAnimationFinished(self.Success_Out, {self, self.ExitGame})
    self:RemoveTimer(self.TimeHandleName)
    self:AddTimer(0, self.PlaySuccessAnimation, false, 0.5, "Success_Out")
    AudioManager(self):PlayUISound(self, "event:/ui/minigame/tiaopin_success", "TiaoPinSuccess", nil)
end

function WBP_MiniGame_Tiaopin_P_C:PlaySuccessAnimation()
    self:PlayAnimation(self.Success_Out)
    self:BlockAllUIInput(true,"SP_DisplayOnly")
    self.MiniGame_Text.Switcher_Tip:SetActiveWidgetIndex(0)
    self:RemoveTimer("Success_Out")
end

--时间到
function WBP_MiniGame_Tiaopin_P_C:TimeOut()
    self.IsWin = false
    --连续按esc会导致一直播失败动画
    if self.IsPressEsc then return end
    self.IsPressEsc = true
    self:BindToAnimationFinished(self.Fail_Out, {self, self.ExitGame})
    self:RemoveTimer(self.TimeHandleName)
    self:PlayAnimation(self.Fail_Out)
    self:BlockAllUIInput(true,"SP_DisplayOnly")
    self.MiniGame_Text.Switcher_Tip:SetActiveWidgetIndex(1)
    AudioManager(self):PlayUISound(self, "event:/ui/minigame/tiaopin_fail", "TiaoPinFail", nil)
end

--手机普通退出游戏
function WBP_MiniGame_Tiaopin_P_C:ExitGameByMoble()
    -- AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_return", "TiaoPinClose", nil)
    -- self:ExitGame()
    self:TimeOut()
end

--退出游戏
function WBP_MiniGame_Tiaopin_P_C:ExitGame()
    if self.IsWin then
        AudioManager(self):PlayFMODSound(self.UseActor, nil, "event:/ui/minigame/tiaopin_gear_unlock", "TiaoPinGearClose")
    end
    self:RemoveTimer("Init")
    self:RemoveTimer("InitPoint")
    self:RemoveTimer("InitArrow")
    self:Close()
end

function WBP_MiniGame_Tiaopin_P_C:Close()
    --结束交互
    self.UseActor:SetVariableBool("IsGameSuccess", self.IsWin, UE4.UGameplayStatics.GetPlayerPawn(self, 0).Eid)
    self.UseActor.ChestInteractiveComponent:EndInteractive(UE4.UGameplayStatics.GetPlayerPawn(self, 0))
    self.Super.Close(self)
end
--------------------------------------------------------------- 手柄相关---------------------------------------------------------------

function WBP_MiniGame_Tiaopin_P_C:InitDeviceInfo()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function WBP_MiniGame_Tiaopin_P_C:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function WBP_MiniGame_Tiaopin_P_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    DebugPrint("thy     CurGamepadName", CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName
    --更新UI
    self:InitBtnTipsUI()
end

--PC监听
function WBP_MiniGame_Tiaopin_P_C:Handle_OnPCDown(InKeyName)
    if InKeyName == "Escape" then
        self:TimeOut()
        return true
    end
    if InKeyName == "Right" or InKeyName == "D" then
        self:OnBtnRClicked()
        return true
    end
    if InKeyName == "Left" or InKeyName == "A" then
        self:OnBtnLClicked()
        return true
    end
    if InKeyName == "Up" or InKeyName == "W" then
        self:OnBtnTClicked()
        return true
    end
    if InKeyName == "Down" or InKeyName == "S" then
        self:OnBtnDClicked()
        return true
    end
    if InKeyName == "F" and self.bCanCrack then
        self:CompleteGame()
        return true
    end
    return false
end

--手柄监听
function WBP_MiniGame_Tiaopin_P_C:Handle_OnGamePadDown(InKeyName)
    DebugPrint("thy    Handle_OnGamePadDown", InKeyName)
    if (InKeyName == "Gamepad_DPad_Up" or InKeyName == "Gamepad_LeftStick_Up") then
        self:OnBtnTClicked()
        return true
    elseif (InKeyName == "Gamepad_DPad_Down" or InKeyName == "Gamepad_LeftStick_Down") then
        self:OnBtnDClicked()
        return true
    elseif (InKeyName == "Gamepad_DPad_Left" or InKeyName == "Gamepad_LeftStick_Left") then
        self:OnBtnLClicked()
        return true
    elseif (InKeyName == "Gamepad_DPad_Right" or InKeyName == "Gamepad_LeftStick_Right") then 
        self:OnBtnRClicked()
        return true
    elseif (InKeyName == "Gamepad_FaceButton_Top") then--一键破解 
        if self.bCanCrack then
            self:CompleteGame()
        end
        return true
    elseif (InKeyName == "Gamepad_FaceButton_Left") then --重置
        self:Reset()
        return true
    elseif (InKeyName == "Gamepad_FaceButton_Right") then --返回
        self:TimeOut()
    end
    return false
end

--监听PC/手柄按键
function WBP_MiniGame_Tiaopin_P_C:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        DebugPrint("thy    Key_IsGamepadKey", InKeyName)
        IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
    else
        DebugPrint("thy    Key_IsPC", InKeyName)
        IsEventHandled = self:Handle_OnPCDown(InKeyName) 
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

--根据左摇杆的轴体偏移确定左摇杆的位置
function WBP_MiniGame_Tiaopin_P_C:CheckLeftStickKeyName()
    local InKeyName = nil
    if self.MoveDeltaX and self.MoveDeltaX ~= 0 then
        if self.MoveDeltaX > 0.5 then
            InKeyName = "Gamepad_LeftStick_Right"
        elseif self.MoveDeltaX < -0.5 then
            InKeyName = "Gamepad_LeftStick_Left"
        end
    end
    if not InKeyName and self.MoveDeltaY and self.MoveDeltaY ~= 0 then
        if self.MoveDeltaY > 0.5 then
            InKeyName = "Gamepad_LeftStick_Up"
        elseif self.MoveDeltaY < -0.5 then
            InKeyName = "Gamepad_LeftStick_Down"
        end
    end
    return InKeyName
end

--监听左摇杆的轴体偏移
function WBP_MiniGame_Tiaopin_P_C:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if(InKeyName == "Gamepad_LeftX")then
        self.MoveDeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    elseif(InKeyName == "Gamepad_LeftY")then
        self.MoveDeltaY = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    end
    self:Handle_OnGamePadDown(self:CheckLeftStickKeyName())
    return self.Unhandle
end
--------------------------------------------------------------- 手柄相关---------------------------------------------------------------


return WBP_MiniGame_Tiaopin_P_C
