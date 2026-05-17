require "UnLua"

---@alias WBP_Com_BtnText_C WBP_Com_BtnText_C|Common_Button_PC|Common_Button_Text_PC_C|WBP_Com_BtnText03_C
---@type WBP_Com_BtnText_C|WBP_Com_BtnText01_C|Common_Button_PC
local Common_Button_Text_PC = Class("BluePrints.UI.UI_PC.Common.Common_Button.Common_Button_PC")

function Common_Button_Text_PC:Construct()
    -- 设置 Text Panel 显示
    self.Text:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- 绑定输入设备切换的委托
    self:BindInputMethodChangedDelegate()
    -- 获取当前InputType
    self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    -- 获取当前GamepadName
    self.CurGamepadName = UIUtils.UtilsGetCurrentGamepadName()
    -- 根据蓝图参数设置GamePad Img
    self:SetGamePadImg(self.GamePadImgName)
    self.bAutoButtonChange = true --是否启用按键自动随平台变化
    -- 根据输入设备更新图标显示
    self:RefreshIconAndGamePadVisibility()
    -- 设置 红点 隐藏
    self.Reddot:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Super.Construct(self, self.Button_Area)
    self.bGamepadIconVisible = true
    self:PlayButtonUnForbidAnim()
    self:SetKey_PCVisibility(UIConst.VisibilityOp["Collapsed"])
end

function Common_Button_Text_PC:Destruct()
    self:UnBindInputMethodChangedDelegate()
    self.Super.Destruct(self)
end
-------------------------------------------------------------------- 输入设备切换 & Icon GamePad 显隐 -------------------------------------------------------------------------
-- 根据当前输入设备刷新Icon和GamePad的显示
function Common_Button_Text_PC:RefreshIconAndGamePadVisibility()
    if not self.bAutoButtonChange then
        return
    end
    -- GamePad
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        if self.WS_Key then
            self.WS_Key:SetActiveWidgetIndex(0)
        end
        if self.bGamepadIconVisible or self.bGamepadIconVisible == nil then
            self:SetGamePadVisibility(self.OverrideGamePadVisibilityOp or UIConst.VisibilityOp["SelfHitTestInvisible"])
            self:SetIconPanelVisibility(UIConst.VisibilityOp["Collapsed"])
        else
            self:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
            self:SetIconPanelVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
    else
        if self.WS_Key then
            self.WS_Key:SetActiveWidgetIndex(1)
        end
        self:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
        self:SetIconPanelVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    end
end

-- 绑定输入设备切换的委托
function Common_Button_Text_PC:BindInputMethodChangedDelegate()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(GameInputModeSubsystem)) then
        GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChanged)
    end
end

function Common_Button_Text_PC:UnBindInputMethodChangedDelegate()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(GameInputModeSubsystem)) then
        GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChanged) 
    end
end

-- 输入设备切换触发的委托
function Common_Button_Text_PC:OnInputMethodChanged(NewGameInputType, NewGamepadName)
    self.CurInputDeviceType = NewGameInputType
    self.CurGamepadName = NewGamepadName
    --self:SetFocus() -- 重新聚焦游戏场景(注释这行后，使用gm呼唤出引导窗口时游戏窗口的聚焦会丢失，需要选中游戏窗口后才能重新聚焦)
    self:RefreshIconAndGamePadVisibility()
end
-------------------------------------------------------------------- 输入设备切换 & Icon GamePad 显隐 -------------------------------------------------------------------------

-------------------------------------------------------------------- 文字部分 -------------------------------------------------------------------
-- 获取按钮的显示内容, 获取 Text_Button 和 Text_Key 的内容
function Common_Button_Text_PC:GetText()
    local button_text = self.Text_Button:GetText()
    return button_text
end

-- 给 Text_Button 设置显示文字
function Common_Button_Text_PC:SetText(Text)
    self.Text_Button:SetText(Text)
end
-------------------------------------------------------------------- 文字部分 -------------------------------------------------------------------

-------------------------------------------------------------------- Icon部分 -------------------------------------------------------------------
-- 设置 Icon 显示样式, 传入图片路径
function Common_Button_Text_PC:SetNewIcon(ImgPath)
    self:SetIconPanelVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    UE4.UResourceLibrary.LoadObjectAsync(self, ImgPath,
    {self, function(_, Image)
        local ImageWidget = self.Img_Slot:GetChildAt(0)
        if ImageWidget then
            ImageWidget:SetBrushResourceObject(Image)
        end
     end})
end

-- 设置 Img_Slot Panel 显隐
function Common_Button_Text_PC:SetIconPanelVisibility(Op)
    self.Img_Slot:SetVisibility(Op)
    -- 非隐藏状态
    if Op~=UIConst.VisibilityOp["Collapsed"] and Op~=UIConst.VisibilityOp["Hidden"] then
        self:UpdateSpacerVisibility()
    -- Icon在隐藏的时候不论Img_Slot是否有内容,都要折叠Spacer_L Spacer_R
    else
        self.Spacer_L:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Spacer_R:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

-- 设置文本着色
function Common_Button_Text_PC:SetTextColor(InColorAndOpacity)
    self.Text_Button:SetColorAndOpacity(InColorAndOpacity)
end

-- 设置Icon着色
function Common_Button_Text_PC:SetIconColor(HexColorString)
    if not HexColorString then return end
     ---@type UImage
     local ImageWidget = self.Img_Slot:GetChildAt(0)
     if ImageWidget then 
        ImageWidget:SetBrushTintColor(UE4.UUIFunctionLibrary.StringToSlateColor(HexColorString))
     end
end

--更新 Spacer_L Spacer_R 的显示
function Common_Button_Text_PC:UpdateSpacerVisibility()
    if self.Img_Slot:GetVisibility()~=UIConst.VisibilityOp.Collapsed and  self.Img_Slot:HasAnyChildren() then
        self.Spacer_L:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Spacer_R:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.Spacer_L:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Spacer_R:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end
-------------------------------------------------------------------- Icon部分 -------------------------------------------------------------------

-------------------------------------------------------------------- 红点部分 -------------------------------------------------------------------
-- 设置红点是否显示
function Common_Button_Text_PC:SetReddotVisibility(Op)
    self.Reddot:SetVisibility(Op)
end

-- 设置红点的样式, 传入图片路径
function Common_Button_Text_PC:SetReddotStyle(ImgPath)
    self:SetReddotVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    UE4.UResourceLibrary.LoadObjectAsync(self, ImgPath,
    {self, function(_, Image)
        self.Reddot.Img_Light:SetBrushResourceObject(Image)
        self.Reddot.WS_Icon:SetActiveWidgetIndex(0)
     end})
end

---设置红点图标
function Common_Button_Text_PC:SetReddot(IsNew,Upgradeable,OhterReddot)
    if(IsNew)then
        self.New:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        return
    end
    self.New:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    if(OhterReddot)then
        self.Reddot:SetReddotStyle(1)
        self.Reddot:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    elseif(Upgradeable)then
        self.Reddot:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.Reddot:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end
-------------------------------------------------------------------- 红点部分 -------------------------------------------------------------------

function Common_Button_Text_PC:SwitchNormalAnimation()
    DebugPrint(LXYTag, "覆盖掉蓝图的SwitchNormalAnimation")
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
end

-------------------------------------------------------------------- 手柄图标部分 -------------------------------------------------------------------------
-- 设置手柄Icon样式
function Common_Button_Text_PC:SetGamePadImg(ImgShortPath, ImgLongPath)
    self.Key_GamePad:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = ImgShortPath,
                ImgLongPath = ImgLongPath,
            }
        },
        bLongPress = self:GetIsLongPressButton(),
        bButton = self:GetIsLongPressButton(),
    })
end

-- 外部设置手柄对应图标通用接口
function Common_Button_Text_PC:SetDefaultGamePadImg(ImgShortPath)
    self.GamePadImgName = ImgShortPath
    self:SetGamePadImg(self.GamePadImgName)
end

-- 设置手柄图标显示
function Common_Button_Text_PC:SetGamePadVisibility(Op)
    self.Key_GamePad:SetVisibility(Op)
end

-- 覆盖手柄图标显示
function Common_Button_Text_PC:OverrideGamePadVisibility(Op)
    self.OverrideGamePadVisibilityOp = Op
end

function Common_Button_Text_PC:SetPCVisibility(IsShow)
    if IsShow then
        self:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
        self:SetIconPanelVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self:SetGamePadVisibility(self.OverrideGamePadVisibilityOp or UIConst.VisibilityOp["SelfHitTestInvisible"])
        self:SetIconPanelVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

function Common_Button_Text_PC:SetGamepadIconVisibility(bShow)
    self.bGamepadIconVisible = bShow
    self:RefreshIconAndGamePadVisibility()
end

-------------------------------------------------------------------- 手柄图标部分 -------------------------------------------------------------------------

--------------------------------------------------------------------- PC图标部分 --------------------------------------------------------------------------
-- 设置PC Icon样式
function Common_Button_Text_PC:SetPCImg(ImgShortPath, ImgLongPath)
    if not self.Key_PC or CommonUtils.GetDeviceTypeByPlatformName(self)~="PC" then
        return
    end
    self.Key_PC:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Text",
                ImgShortPath = ImgShortPath,
                ImgLongPath = ImgLongPath,
            }
        },
        bLongPress = self:GetIsLongPressButton(),
        bButton = self:GetIsLongPressButton(),
    })
    self:SetKey_PCVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
end

-- 设置键鼠图标显示
function Common_Button_Text_PC:SetKey_PCVisibility(Op)
    if self.Key_PC then
        self.Key_PC:SetVisibility(Op)
    end
end
--------------------------------------------------------------------- PC图标部分 --------------------------------------------------------------------------

-- 长按动画
function Common_Button_Text_PC:PlayLongPressAnimation()
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self.Key_GamePad:OnButtonPressed(false, true, 0, self.LongPressDuration)
    else
        local Speed = self.LongPress:GetEndTime() / self.LongPressDuration
        self:PlayAnimation(self.LongPress,0,1,EUMGSequencePlayMode.Forward, Speed, false)
    end
end

function Common_Button_Text_PC:StopLongPressAnimation()
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self.Key_GamePad:OnButtonReleased()
        self.Key_GamePad:StopAllAnimations()
        self.Key_GamePad:PlayAnimation(self.Key_GamePad.Normal)
    else
        self:PlayAnimation(self.LongPress)
        self:StopAnimation(self.LongPress)
    end
end

function Common_Button_Text_PC:PlayButtonForbidAnim()
    self.Key_GamePad:DisableKey()
    self.Super.PlayButtonForbidAnim(self)
end

function Common_Button_Text_PC:PlayButtonUnForbidAnim()
    self.Key_GamePad:EnableKey()
    self.Super.PlayButtonUnForbidAnim(self)
end

return Common_Button_Text_PC