--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_MiniGame_Mima_P_C
local WBP_MiniGame_Mima_P_C = Class({"BluePrints.UI.BP_UIState_C", "BluePrints.Common.TimerMgr"})

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

--执行时机比OnLoaded早
function WBP_MiniGame_Mima_P_C:InitUIInfo(Name, IsInUIMode, EventList, ...)
    self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)

    --再次启动游戏时能显示出正确的UI
    self.Panel_L:SetRenderOpacity(1)
    self.Circle:SetRenderOpacity(1)
    self.MiniGame_Time.Text_Time:SetRenderOpacity(1)
    self.MiniGame_Text:SetVisibility(ESlateVisibility.Collapsed)

    --设备切换监听
    self:InitDeviceInfo()
    self:InitListenEvent()
end

function WBP_MiniGame_Mima_P_C:OnLoaded(...)
    DebugPrint("thy      WBP_MiniGame_Mima_P_C:InitUIInfo")
    self.GameDifficulty, self.GameTotalTime, self.RougueLikeComponent, self.RougueLikeCallback = ...
    if self.RougueLikeComponent then --后续可能会在肉鸽中限制一键破解功能，暂时留着
        self.IsInRougeLike = true 
    end
    self.IsWin = false
    self.IsClosing = false
    --密码线索
    self.PasswordMap = {
        [1] = {0,1,1,1,1},
        [2] = {0,0,1,1,1},
        [3] = {0,0,0,1,1},
        [4] = {0,0,0,0,1},
        [5] = {0,0,0,0,0},
        [6] = {1,0,0,0,0},
        [7] = {1,1,0,0,0},
        [8] = {1,1,1,0,0},
        [9] = {1,1,1,1,0},
        [0] = {1,1,1,1,1},
    }

    if self.IsInRougeLike then
        self:InitAfterBeginPlay()
    end
end

--执行时机比OnLoaded晚一些
function WBP_MiniGame_Mima_P_C:InitAfterBeginPlay()
    --非肉鸽副本则通过机关传递参数
    if not self.GameDifficulty then self.GameDifficulty = self.Difficulty end
    if not self.GameTotalTime then self.GameTotalTime = self.GameTime end

    DebugPrint("thy      self.GameDifficulty", self.GameDifficulty)
    self.GameDifficulty = self.GameDifficulty or 1
    self.GameTotalTime = self.GameTotalTime or 60

    --初始化游戏需要用的数据
    self:InitDataInfo()
    --初始化倒计时
    self:InitTime()
    --初始化UI
    self:InitUIContent()
    --初始化破解
    self:InitCrack()

    --动画事件绑定
    self:BindToAnimationFinished(self.Succeed_Out, {self, self.Close})
    self:BindToAnimationFinished(self.Fail_Out, {self, self.Close})
    self:BindToAnimationFinished(self.Out, {self, self.Close})

    --播放进入动画
    self:PlayAnimation(self.In)
    --播放音效
    AudioManager(self):PlayUISound(self, "event:/ui/minigame/morse_start", "MorseGameStart", nil)

end

--初始化解锁和重置
function WBP_MiniGame_Mima_P_C:InitCrack()
    if not self.bCanCrack then
        self.MiniGame_Crack:SetVisibility(ESlateVisibility.Collapsed)
        return
    end
    local Param = {
        RootPage = self,
        SuccCallBack = self.CrackGame,
        ResetCallBack = self.Reset,
        NeedCrack = self.bCanCrack or false, 
        NeedReset = false, -- 不需要重置
    }
    self.MiniGame_Crack:SetVisibility(ESlateVisibility.Visibility)
    self.MiniGame_Crack:Init(Param)
end

--初始化时间
function WBP_MiniGame_Mima_P_C:InitTime()
    -- self.Panel_Time:SetRenderOpacity(1)
    self.MiniGame_Time.Text_Time:SetText("00:"..tostring(self.GameTotalTime))
    self:AddTimer(1, self.CountDown, true, 0.1, "MorseGameTimer", true)
end

--初始化倒计时
function WBP_MiniGame_Mima_P_C:CountDown()
    self.GameTotalTime = self.GameTotalTime - 1
    if self.GameTotalTime < 0 then
        if self.IsClosing then
            return
        end
        self:TimeOut()
        self.IsClosing = true
        return
    end
    if self.GameTotalTime < 10 then
        self:PlayAnimation(self.Warning)
        AudioManager(self):PlayUISound(self, "event:/ui/minigame/morse_countdown_warning", "CountDownNormal", nil)
        self.MiniGame_Time.Text_Time:SetText("00:0"..tostring(self.GameTotalTime))
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/minigame/tiaopin_countdown", "CountDownNormal", nil)
    self.MiniGame_Time.Text_Time:SetText("00:"..tostring(self.GameTotalTime))
end

--初始化UI信息
function WBP_MiniGame_Mima_P_C:InitUIContent()
    --隐藏一些与密码位数相关的控件，后面根据密码位数显示对应的个数
    self:HideSomeWidgetAboutPasswordLen()
    --初始化文本
    self:InitText()
    --初始化上方密码输入框
    self:InitInputPassword()
    --初始化下方按钮
    self:InitPasswordBtn()
    --初始化左下密码
    self:InitPasswordIcon()
    --初始化左上密码线索
    self:InitPasswordInfo()
    --初始化下方提示按钮
    self:InitBtnTipsUI()
    --更新当前的密码提示和输入框光标
    self:UpdateCurTipAndInputPos()
    --初始化主界面部分按钮
    self:InitButtonInMainUI()
end

--初始化主界面部分按钮
function WBP_MiniGame_Mima_P_C:InitButtonInMainUI()
    if self.Button_Close then
        self.Button_Close:Init("Close", self, self.NormalExit)
    end
end

--初始化下方提示按钮
function WBP_MiniGame_Mima_P_C:InitBtnTipsUI()
    if (not self.CurInputDeviceType) or self.CurInputDeviceType == ECommonInputType.Touch then
        DebugPrint("thy    InitBtnTipsUI", self.CurInputDeviceType)
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
        if self.Key_Move then
            self.Key_Move:SetVisibility(ESlateVisibility.Collapsed)
        end

        self.KeyInfo1 = {
            KeyInfoList={
                {
                    ClickCallback = self.NormalExit,
                    Owner = self,
                    Type = "Text",
                    Text = "Esc",
                },
            },
            Desc = GText("UI_BACK"),
        }
        if self.Key_Close then
            self.Key_Close:CreateCommonKey(self.KeyInfo1)
        end
    else
        if self.Key_Move then
            self.Key_Move:SetVisibility(ESlateVisibility.Visibility)
        end
        self.KeyInfo1 = {
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "B",
                },
            },
            Desc = GText("UI_BACK"),
        }

        self.KeyInfo2 = {
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "A",
                },
            },
            Desc = GText("UI_Input_Input"),
        }
        if self.Key_Close and self.Key_Switch and self.Key_Move then
            self.Key_Close:CreateCommonKey(self.KeyInfo1)
            self.Key_Move:CreateCommonKey(self.KeyInfo2)
        end
    end
end

--更新轮次信息
function WBP_MiniGame_Mima_P_C:UpdateTurnInfo()
    if self.CurTurn + 1 > self.TotalTurn then
        --完成游戏
        self:CompleteGame()
    else
        self.CurTurn = self.CurTurn + 1
        self:BindToAnimationFinished(self.CompletePrompt, {self, self.UpdatePasswordInfo})
        AudioManager(self):PlayUISound(self, "event:/ui/minigame/morse_next_round", "NextRound", nil)
        self:PlayAnimation(self.CompletePrompt)
    end
end

--更新下一组的密码信息
function WBP_MiniGame_Mima_P_C:UpdatePasswordInfo()
    --播放下一组密码的刷新动效
    self:PlayAnimation(self.BoutRefresh)
    --更新文本
    self:InitText()
    --初始化当前输入框密码格子的索引
    self.CurInputPasswordIndex = 1
    -- 隐藏与密码位数相关的控件
    self:HideSomeWidgetAboutPasswordLen()
    --初始化左上角密码信息
    self:InitPasswordInfo()
    --初始化上方密码输入框
    self:InitInputPassword()
    --更新当前的密码提示和输入框光标
    self:UpdateCurTipAndInputPos()
    --解锁按键过快的锁定
    self.IsLock = false
end

--隐藏一些与密码位数相关的控件，后面根据密码位数显示对应的个数
function WBP_MiniGame_Mima_P_C:HideSomeWidgetAboutPasswordLen()
    for i = 1, 4 do
        self["Tips0"..i]:SetVisibility(ESlateVisibility.Collapsed)
        self["Num_Enter0"..i]:SetVisibility(ESlateVisibility.Collapsed)
    end
end

--初始化左上角密码信息(每轮次调用)
function WBP_MiniGame_Mima_P_C:InitPasswordInfo()
    local _, Password = self:GetCurPassword()
    for i = 1, self.PasswordLen[self.CurTurn] do
        self["Tips0"..i]:SetVisibility(ESlateVisibility.Visibility)
        self["Tips0"..i]:InitIcon(Password[i])
    end
end

--初始化左下角的密码线索
function WBP_MiniGame_Mima_P_C:InitPasswordIcon()
    for i = 1, 10 do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Password = i == 10 and self.PasswordMap[0] or self.PasswordMap[i]
        Content.Index = i == 10 and 0 or i
        self.TileView_Clue:AddItem(Content)
    end
end

--初始化上方密码输入框
function WBP_MiniGame_Mima_P_C:InitInputPassword()
    for i = 1, self.PasswordLen[self.CurTurn] do
        self["Num_Enter0"..i]:SetVisibility(ESlateVisibility.Visibility)
        self["Num_Enter0"..i]:InitInfo(self, i)
        self.InputPasswordItemList[i] = self["Num_Enter0"..i]
    end
    --输入格直接回到第一格然后切换到输入状态
    --self.InputPasswordItemList[1]:StartInputState()
    self.CurInputPasswordIndex = 1
end

--更新密码提示光标位置和输入框当前位置
function WBP_MiniGame_Mima_P_C:UpdateCurTipAndInputPos()
    for i = 1, self.PasswordLen[self.CurTurn] do
        self["Tips0"..i]:PlayAnimation(self["Tips0"..i].Normal)
        self["Num_Enter0"..i]:StopAllAnimations()
        self["Num_Enter0"..i]:PlayAnimation(self["Num_Enter0"..i].Normal)
    end
    self["Tips0"..self.CurInputPasswordIndex]:PlayAnimation(self["Tips0"..self.CurInputPasswordIndex].Click)
    self["Num_Enter0"..math.max(1, self.CurInputPasswordIndex - 1)]:StopAllAnimations()
    self["Num_Enter0"..math.max(1, self.CurInputPasswordIndex - 1)]:PlayAnimation(self["Num_Enter0"..math.max(1, self.CurInputPasswordIndex - 1)].Normal)
    self["Num_Enter0"..self.CurInputPasswordIndex]:PlayAnimation(self["Num_Enter0"..self.CurInputPasswordIndex].Click)
end

--密码输入框输入下方按钮或者键盘按键值
function WBP_MiniGame_Mima_P_C:InputPassword(Password)
    --防止按键过快出现意外错误
    if self.IsLock then return end
    self.IsLock = true

    local InputPasswordItem = self.InputPasswordItemList[self.CurInputPasswordIndex]
    InputPasswordItem:SetNum(Password)
    if self:CheckPasswordCorrect(Password) then
        AudioManager(self):PlayUISound(self, "event:/ui/minigame/morse_btn_click_correct", "InputCorrect", nil)
        --检查本轮次密码破译是否结束
        if self.CurInputPasswordIndex < self.PasswordLen[self.CurTurn] then
            --InputPasswordItem:CloseInputState()
            self.CurInputPasswordIndex = self.CurInputPasswordIndex + 1
            --self.InputPasswordItemList[self.CurInputPasswordIndex]:StartInputState()
            --更新当前的密码提示和输入框光标
            self:UpdateCurTipAndInputPos()
            self.IsLock = false
        else
            --轮次结束，更新轮次
            self:UpdateTurnInfo()
        end
    else
        AudioManager(self):PlayUISound(self, "event:/ui/minigame/morse_btn_click_wrong", "InputWrong", nil)
        --输入错误, 播放动效
        InputPasswordItem:PlayErrorInputAnimation()
    end
end

function WBP_MiniGame_Mima_P_C:UnLock()
    self.IsLock = false
end

--检查输入密码的正确性
function WBP_MiniGame_Mima_P_C:CheckPasswordCorrect(Password)
    local _, PasswordArr = self:GetCurPassword()
    for key, value in pairs(PasswordArr) do
        DebugPrint("thy    PasswordArr  key", key)
        DebugPrint("thy    PasswordArr  value", value)
    end
    local CorrectPassword = PasswordArr[self.CurInputPasswordIndex]
    DebugPrint("thy    CorrectPassword", CorrectPassword)
    DebugPrint("thy    Password", Password)
    return CorrectPassword == Password
end

--初始化下方按钮
function WBP_MiniGame_Mima_P_C:InitPasswordBtn()
    for i = 1, 10 do
        if i == 10 then
            self.Btn_List.Btn0:InitBtnInfo(self, 0)
        else
            self.Btn_List["Btn"..i]:InitBtnInfo(self, i)
        end
    end
end

--防止移动太快，按钮动画未播放完 出现动效错误
function WBP_MiniGame_Mima_P_C:PasswordBtnNormal(Index)
    Index = Index == 0 and 10 or Index
    for i = 1, 10 do
        if i == Index then
            goto Continue
        end
        if i == 10 then
            self.Btn_List.Btn0:PlayAnimation(self.Btn_List.Btn0.Normal)
        else
            self.Btn_List["Btn"..i]:PlayAnimation(self.Btn_List["Btn"..i].Normal)
        end
        ::Continue::
    end
end

--初始化/更新文本
function WBP_MiniGame_Mima_P_C:InitText()
    --操作标题
    self.Text_Float:SetText(GText("UI_MiniGame_Morse_Intro"))
    --破译波次文本
    self.Text_Tips:SetText(string.format(GText("UI_MiniGame_Morse_Turn"),self.CurTurn, self.TotalTurn))
    --需要破译的密码
    self.Text_Top:SetText(GText("UI_MiniGame_Morse_Password")) 
    --密码线索
    self.Text_Down:SetText(GText("UI_MiniGame_Morse_Password_Clue"))
end

--初始化游戏需要用的数据
function WBP_MiniGame_Mima_P_C:InitDataInfo()
    self.GameDataList = DataMgr["MiniGameMorse"..self.GameDifficulty]
    if self.GameDataList and #self.GameDataList > 0 then
        self.GameDataInfo = self.GameDataList[math.random(1,#self.GameDataList)]
    end
    --总轮次
    self.TotalTurn = self.GameDataInfo.Turn
    --当前轮次
    self.CurTurn = 1
    --每个轮次的密码长度（List）
    self.PasswordLen = self.GameDataInfo.PasswordLen
    --每个轮次的密码 格式self.PasswordList = {{529, 5, 2, 9}, {123, 1 ,2 ,3}}
    self.PasswordList = {}
    --输入框密码格子列表
    self.InputPasswordItemList = {}
    --当前输入框密码格子的索引
    self.CurInputPasswordIndex = 1
    --防止按键输入过快出现意外错误
    self.IsLock = false
    --生成所有轮次的密码
    for i = 1, self.TotalTurn do
        self.PasswordList[i] = self:InitPassword(i)
    end
end

--初始化密码
function WBP_MiniGame_Mima_P_C:InitPassword(CurTurn)
    local CurPasswordArr = {}
    local CurPasswordList = {}
    local ArrLen = 0
    local IsNeedContinue = true
    local CurPassword = 0
    --保证生成得随机数密码中的每个数字都不一样
    while IsNeedContinue do
        local num = math.random(0, 9)
        if not CurPasswordArr[num] then
            CurPasswordArr[num] = num
            ArrLen = ArrLen + 1
        end
        if ArrLen == self.PasswordLen[CurTurn] then
            IsNeedContinue = false
        end
    end
    --获取密码数字
    for key, value in pairs(CurPasswordArr) do
        CurPassword = CurPassword * 10 + value
    end
    --保证得到的随机数密码每个轮次都不一样
    if self:CheckIsRepeat(CurPassword) then
        self:InitPassword()
        return
    end
    --第一个值是整体密码值，后面是密码的每一位数
    table.insert(CurPasswordList, CurPassword)
    --把密码整理到新的表中
    for key, value in pairs(CurPasswordArr) do
        table.insert(CurPasswordList, value)
    end

    return CurPasswordList
end

--检查密码是否重复
function WBP_MiniGame_Mima_P_C:CheckIsRepeat(CurPassword)
    for _, Password in pairs(self.PasswordList) do
        if CurPassword == Password[1] then
            return true
        end
    end
    return false
end

--获取当前轮次的密码数字 和 密码列表（每个数字分开）
function WBP_MiniGame_Mima_P_C:GetCurPassword()
    local PasswordArr = {}
    DebugPrint("thy    CurTurn", self.CurTurn)
    local PasswordList = self.PasswordList[self.CurTurn]
    table.move(PasswordList, 2, #PasswordList, 1, PasswordArr)
    return self.PasswordList[self.CurTurn][1], PasswordArr
end

--完成游戏（玩家手动完成）
function WBP_MiniGame_Mima_P_C:CompleteGame()
    self.IsWin = true
    self.MiniGame_Text:SetVisibility(ESlateVisibility.Visible)
    self.MiniGame_Text.Text_Success:SetText(GText("UI_MiniGame_Success"))
    AudioManager(self):PlayUISound(self, "event:/ui/minigame/morse_sucess", "MorseGameSuccess", nil)
    self:PlayAnimation(self.Succeed_Out)
    self.MiniGame_Text.Switcher_Tip:SetActiveWidgetIndex(0)
    --移除计时器
    self:RemoveTimer("MorseGameTimer")
end

--完成游戏（破解）
function WBP_MiniGame_Mima_P_C:CrackGame()
    self.IsWin = true
    self.MiniGame_Text:SetVisibility(ESlateVisibility.Visible)
    -- 修改文本为破解成功
    self.MiniGame_Text.Text_Success:SetText(GText("UI_MiniGame_Decode_Success"))
    self:PlayAnimation(self.Succeed_Out)
    self.MiniGame_Text.Switcher_Tip:SetActiveWidgetIndex(0)
    --移除计时器
    self:RemoveTimer("MorseGameTimer")
end

--重置游戏
function WBP_MiniGame_Mima_P_C:Reset()
    --重置游戏只需要重置输入框即可
    self:InitInputPassword()
    --更新当前的密码提示和输入框光标
    self:UpdateCurTipAndInputPos()
end

--时间到
function WBP_MiniGame_Mima_P_C:TimeOut()
    self.MiniGame_Text:SetVisibility(ESlateVisibility.Visible)
    self.MiniGame_Text.Text_Fail:SetText(GText("UI_MiniGame_Fail"))
    self.MiniGame_Text.Switcher_Tip:SetActiveWidgetIndex(1)
    AudioManager(self):PlayUISound(self, "event:/ui/minigame/morse_fail", "MorseGameFail", nil)
    self:PlayAnimation(self.Fail_Out)
    --移除计时器
    self:RemoveTimer("MorseGameTimer")
end

--正常退出
function WBP_MiniGame_Mima_P_C:NormalExit()
    self.MiniGame_Text:SetVisibility(ESlateVisibility.Visible)
    self.MiniGame_Text.Text_Fail:SetText(GText("UI_MiniGame_Fail"))
    self.MiniGame_Text.Switcher_Tip:SetActiveWidgetIndex(1)
    AudioManager(self):PlayUISound(self, "event:/ui/minigame/morse_fail", "MorseGameFail", nil)
    self:PlayAnimation(self.Fail_Out)
    --移除计时器
    self:RemoveTimer("MorseGameTimer")
end

--退出游戏
function WBP_MiniGame_Mima_P_C:Close()
    DebugPrint("thy     CloseGame")
    --如果在肉鸽中调用一下回调
    if self.RougueLikeCallback then
        self.RougueLikeCallback(self.RougueLikeComponent, self.IsWin)
    end
    --移除计时器(音效问题，移至各种游戏结束的情况下清除)，但防止意外问题，仍保留实际退出时的计时器清除
    self:RemoveTimer("MorseGameTimer")
    --结束交互
    if self.UseActor then
        self.UseActor:SetVariableBool("IsGameSuccess", self.IsWin, UE4.UGameplayStatics.GetPlayerPawn(self, 0).Eid)
        self.UseActor.ChestInteractiveComponent:EndInteractive(UE4.UGameplayStatics.GetPlayerPawn(self, 0))
    end
    self.Super.Close(self)
end


--------------------------------------------------------------- 手柄相关---------------------------------------------------------------

function WBP_MiniGame_Mima_P_C:InitDeviceInfo()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function WBP_MiniGame_Mima_P_C:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function WBP_MiniGame_Mima_P_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    DebugPrint("thy     CurGamepadName", CurGamepadName)
    DebugPrint("thy     CurInputDevice", CurInputDevice)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        DebugPrint("thy    已经显示的是该输入模式，不需要进行刷新")
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName
    --更新UI
    self:InitMainUI()
end

function WBP_MiniGame_Mima_P_C:InitMainUI()
    self:InitBtnTipsUI()
    self.Btn_List["Btn5"]:SetFocus()
end

--PC监听
function WBP_MiniGame_Mima_P_C:Handle_OnPCDown(InKeyName)
    DebugPrint("thy   Handle_OnPCDown", InKeyName)
    if InKeyName == "Escape" then
        self:NormalExit()
        return true
    end
    if InKeyName == "One" or InKeyName == "NumPadOne" then
        self:InputPassword(1)
        return true
    end
    if InKeyName == "Two" or InKeyName == "NumPadTwo" then
        self:InputPassword(2)
        return true
    end
    if InKeyName == "Three" or InKeyName == "NumPadThree" then
        self:InputPassword(3)
        return true
    end
    if InKeyName == "Four" or InKeyName == "NumPadFour" then
        self:InputPassword(4)
        return true
    end
    if InKeyName == "Five" or InKeyName == "NumPadFive" then
        self:InputPassword(5)
        return true
    end
    if InKeyName == "Six" or InKeyName == "NumPadSix" then
        self:InputPassword(6)
        return true
    end
    if InKeyName == "Seven" or InKeyName == "NumPadSeven" then
        self:InputPassword(7)
        return true
    end
    if InKeyName == "Eight" or InKeyName == "NumPadEight" then
        self:InputPassword(8)
        return true
    end
    if InKeyName == "Nine" or InKeyName == "NumPadNine" then
        self:InputPassword(9)
        return true
    end
    if InKeyName == "Zero" or InKeyName == "NumPadZero" then
        self:InputPassword(0)
        return true
    end
    if InKeyName == "F" and self.bCanCrack then
        self:CrackGame()
        return true
    end
    return false
end

--手柄监听
function WBP_MiniGame_Mima_P_C:Handle_OnGamePadDown(InKeyName)
    DebugPrint("thy    Handle_OnGamePadDown", InKeyName)
    if (InKeyName == "Gamepad_FaceButton_Top") then--一键破解  
        if self.bCanCrack then
            self:CrackGame()
        end
        return true
    elseif (InKeyName == "Gamepad_FaceButton_Right") then --返回
        self:NormalExit()
        return true
    end
    return false
end

--监听PC/手柄按键
function WBP_MiniGame_Mima_P_C:OnKeyDown(MyGeometry, InKeyEvent)
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

return WBP_MiniGame_Mima_P_C
