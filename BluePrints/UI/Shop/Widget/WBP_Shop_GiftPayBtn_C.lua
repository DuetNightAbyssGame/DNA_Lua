require "UnLua"

local WBP_Shop_GiftPayBtn_C = Class("BluePrints.UI.UI_PC.Common.Common_Button.Common_Button_PC")

function WBP_Shop_GiftPayBtn_C:Construct()
    self.Super.Construct(self, self.Button_Area)
    -- 绑定输入设备切换的委托
    self:BindInputMethodChangedDelegate()
    -- 获取当前InputType
    self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    -- 获取当前GamepadName
    self.CurGamepadName = UIUtils.UtilsGetCurrentGamepadName()
    -- -- 根据蓝图参数设置GamePad Img
    -- self:SetGamePadImg(self.GamePadImgName)
    -- 根据输入设备更新图标显示
    self:RefreshIconAndGamePadVisibility()
    -- 默认隐藏
    self:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
    self.IsGamePadIconVisible = false
    self.IsDisabled = false
end

-------------------------------------------------------------------- 文字部分 -------------------------------------------------------------------
-- 给 Reward_Button 设置显示文字
-- function WBP_Shop_GiftPayBtn_C:SetText(Text)
--     self.Text_Button:SetText(Text)
-- end
-------------------------------------------------------------------- 文字部分 -------------------------------------------------------------------

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
-- function WBP_Shop_GiftPayBtn_C:SetGamePadImg(ImgShortPath, ImgLongPath)
--     local ImgPath, Img = nil, nil
--     if ImgShortPath and ImgShortPath~="None" then
--         ImgPath = UIUtils.UtilsGetKeyIconPathInGamepad(ImgShortPath, self.CurGamepadName)
--         Img = LoadObject(ImgPath)
--     elseif ImgLongPath then
--         Img = LoadObject(ImgLongPath)
--     end
--     if (not IsValid(Img)) then
--         DebugPrint("缺少图片资源: ImgPath = ", ImgPath, ImgShortPath, ImgLongPath)
--         return
--     end
--     self.Img_GamePad:SetBrushResourceObject(Img)
-- end

-- 外部设置手柄对应图标通用接口
-- function WBP_Shop_GiftPayBtn_C:SetDefaultGamePadImg(ImgShortPath)
--     self.GamePadImgName = ImgShortPath
--     self:SetGamePadImg(self.GamePadImgName)
-- end

-- 设置手柄图标显示
function WBP_Shop_GiftPayBtn_C:SetGamePadVisibility(Op)
    self.Img_GamePad:SetVisibility(Op)
end

function WBP_Shop_GiftPayBtn_C:SetGamePadIconVisible(IsVisible)
    self.IsGamePadIconVisible = IsVisible
    self:RefreshIconAndGamePadVisibility()
end

function WBP_Shop_GiftPayBtn_C:PlayButtonDisableAnim()
    self:StopAllAnimations()
    self:DestroyAllAnmations()
    self:PlayAnimation(self.Disable)
end

function WBP_Shop_GiftPayBtn_C:PlayButtonEnableAnim()
    if self.IsHovering then
        self:PlayButtonHoverAnim()
    else
        self:SwitchNormalAnimation()
    end
end

function WBP_Shop_GiftPayBtn_C:IsBtnDisabled()
    return self.IsDisabled
end

function WBP_Shop_GiftPayBtn_C:DisableBtn(IsDisable)
    if IsDisable == self.IsDisabled then return end
    self:UnbindAllFromAnimationFinished(self.UnHover)
    if self.IsDisabled == false and IsDisable == true then
        self.IsDisabled = true
        self.IsForbidden = true
        self:PlayButtonDisableAnim()
    elseif self.IsDisabled == true and IsDisable == false then
        self.IsDisabled = false
        self.IsForbidden = false
        self:PlayButtonEnableAnim()
    end
end

return WBP_Shop_GiftPayBtn_C