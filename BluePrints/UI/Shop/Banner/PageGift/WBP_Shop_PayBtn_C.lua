require "UnLua"

local WBP_Shop_GiftPayBtn_C = Class("BluePrints.UI.UI_PC.Common.Common_Button.Common_Button_PC")

function WBP_Shop_GiftPayBtn_C:Construct()
    self.Super.Construct(self, self.Btn_Buy)
    -- 绑定输入设备切换的委托
    self:BindInputMethodChangedDelegate()
    -- 获取当前InputType
    self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    -- 获取当前GamepadName
    self.CurGamepadName = UIUtils.UtilsGetCurrentGamepadName()
    -- 根据输入设备更新图标显示
    self:RefreshIconAndGamePadVisibility()
    -- 默认隐藏
    self:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
    self:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    self.IsGamePadIconVisible = false
end

function WBP_Shop_GiftPayBtn_C:SwitchNormalAnimation()
    self:PlayAnimation(self.UnHover)
    self:PlayAnimation(self.Normal)
end

function WBP_Shop_GiftPayBtn_C:Destruct()
    self:UnBindInputMethodChangedDelegate()
    self.Super.Destruct(self)
end

-- 绑定输入设备切换的委托
function WBP_Shop_GiftPayBtn_C:BindInputMethodChangedDelegate()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(GameInputModeSubsystem)) then
        GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChanged)
    end
end

function WBP_Shop_GiftPayBtn_C:UnBindInputMethodChangedDelegate()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(GameInputModeSubsystem)) then
        GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChanged) 
    end
end

-- 输入设备切换触发的委托
function WBP_Shop_GiftPayBtn_C:OnInputMethodChanged(NewGameInputType, NewGamepadName)
    self.CurInputDeviceType = NewGameInputType
    self.CurGamepadName = NewGamepadName
    --self:SetFocus() -- 重新聚焦游戏场景(注释这行后，使用gm呼唤出引导窗口时游戏窗口的聚焦会丢失，需要选中游戏窗口后才能重新聚焦)
    self:RefreshIconAndGamePadVisibility()
end

-------------------------------------------------------------------- 输入设备切换 & Icon GamePad 显隐 -------------------------------------------------------------------------
-- 根据当前输入设备刷新Icon和GamePad的显示
function WBP_Shop_GiftPayBtn_C:RefreshIconAndGamePadVisibility()
    if not self.IsGamePadIconVisible then
        self:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
        return
    end
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

-------------------------------------------------------------------- 手柄图标部分 -------------------------------------------------------------------------
-- 设置手柄Icon样式
function WBP_Shop_GiftPayBtn_C:SetGamePadImg(ImgShortPath, ImgLongPath)
    -- local ImgPath, Img = nil, nil
    -- if ImgShortPath and ImgShortPath~="None" then
    --     ImgPath = UIUtils.UtilsGetKeyIconPathInGamepad(ImgShortPath, self.CurGamepadName)
    --     Img = LoadObject(ImgPath)
    -- elseif ImgLongPath then
    --     Img = LoadObject(ImgLongPath)
    -- end
    -- if (not IsValid(Img)) then
    --     DebugPrint("缺少图片资源: ImgPath = ", ImgPath, ImgShortPath, ImgLongPath)
    --     return
    -- end
    --self.Key_ControllerBuy:SetBrushResourceObject(Img)
    self.Key_ControllerBuy:SetImage("Img", ImgShortPath)
end

-- 外部设置手柄对应图标通用接口
function WBP_Shop_GiftPayBtn_C:SetDefaultGamePadImg(ImgShortPath)
    self.GamePadImgName = ImgShortPath
    self:SetGamePadImg(self.GamePadImgName)
end

-- 设置手柄图标显示
function WBP_Shop_GiftPayBtn_C:SetGamePadVisibility(Op)
    self.Key_ControllerBuy:SetVisibility(Op)
end

function WBP_Shop_GiftPayBtn_C:SetGamePadIconVisible(IsVisible)
    self.IsGamePadIconVisible = IsVisible
    self:RefreshIconAndGamePadVisibility()
end

return WBP_Shop_GiftPayBtn_C