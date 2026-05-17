-- WBP_Com_Dialog_NumBtn.lua
require "UnLua"

local M = Class("BluePrints.UI.UI_PC.Common.Common_Button.Common_Button_PC")

function M:Construct()
    self.Super.Construct(self, self.Btn_Click)
    -- 绑定输入设备切换的委托
    self:BindInputMethodChangedDelegate()
    -- 获取当前InputType
    self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    -- 获取当前GamepadName
    self.CurGamepadName = UIUtils.UtilsGetCurrentGamepadName()
    -- 是否启用按键自动随平台变化
    self.bAutoButtonChange = true
    -- 根据输入设备更新图标显示
    self:RefreshIconAndGamePadVisibility()
    
    self.bGamepadIconVisible = true
end

function M:Destruct()
    self:UnBindInputMethodChangedDelegate()
    self.Super.Destruct(self)
end

function M:SwitchNormalAnimation()
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
end

-------------------------------------------------------------------- 输入设备切换 & Icon GamePad 显隐 -------------------------------------------------------------------------
-- 根据当前输入设备刷新Icon和GamePad的显示
function M:RefreshIconAndGamePadVisibility()
    if not self.bAutoButtonChange then
        return
    end
    -- GamePad
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        if self.bGamepadIconVisible or self.bGamepadIconVisible == nil then
            self:SetGamePadVisibility(self.OverrideGamePadVisibilityOp or UIConst.VisibilityOp["SelfHitTestInvisible"])
            -- self:SetIconPanelVisibility(UIConst.VisibilityOp["Collapsed"])
        else
            self:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
            -- self:SetIconPanelVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
    else
        self:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
        -- self:SetIconPanelVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    end
end

-- 绑定输入设备切换的委托
function M:BindInputMethodChangedDelegate()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(GameInputModeSubsystem)) then
        GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChanged)
    end
end

function M:UnBindInputMethodChangedDelegate()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(GameInputModeSubsystem)) then
        GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChanged) 
    end
end

-- 输入设备切换触发的委托
function M:OnInputMethodChanged(NewGameInputType, NewGamepadName)
    self.CurInputDeviceType = NewGameInputType
    self.CurGamepadName = NewGamepadName
    --self:SetFocus() -- 重新聚焦游戏场景(注释这行后，使用gm呼唤出引导窗口时游戏窗口的聚焦会丢失，需要选中游戏窗口后才能重新聚焦)
    self:RefreshIconAndGamePadVisibility()
end
-------------------------------------------------------------------- 输入设备切换 & Icon GamePad 显隐 -------------------------------------------------------------------------

-------------------------------------------------------------------- 手柄图标部分 -------------------------------------------------------------------------
-- 设置手柄Icon样式
function M:SetGamePadImg(ImgShortPath, ImgLongPath)
    self.Controller_Erase:CreateCommonKey({
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
function M:SetDefaultGamePadImg(ImgShortPath)
    self.GamePadImgName = ImgShortPath
    self:SetGamePadImg(self.GamePadImgName)
end

-- 设置手柄图标显示
function M:SetGamePadVisibility(Op)
    self.Controller_Erase:SetVisibility(Op)
end

-- 覆盖手柄图标显示
function M:OverrideGamePadVisibility(Op)
    self.OverrideGamePadVisibilityOp = Op
end

function M:SetPCVisibility(IsShow)
    if IsShow then
        self:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
        self:SetIconPanelVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self:SetGamePadVisibility(self.OverrideGamePadVisibilityOp or UIConst.VisibilityOp["SelfHitTestInvisible"])
        self:SetIconPanelVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

function M:SetGamepadIconVisibility(bShow)
    self.bGamepadIconVisible = bShow
    self:RefreshIconAndGamePadVisibility()
end

-------------------------------------------------------------------- 手柄图标部分 -------------------------------------------------------------------------

return M