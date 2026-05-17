--
-- DESCRIPTION
--
-- @COMPANY ** 活动上方Tab
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_Tab_P_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Construct()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    local ResourceBarIcon = UIUtils.UtilsGetKeyIconPathInGamepad("RS", CurGamepadName)
    self.WBP_Com_Tab_ResourceBar:SetGamePadKeyImgByPath(ResourceBarIcon)
end

function M:Init(Info)
    self.Info = Info
    -- 返回按钮的回调
    self.BackCallback = Info.BackCallback
    -- 所属的对象
    self.ParentWidget = Info.OwnerPanel
    -- 设置文本
    self.Title_Tab:SetText(Info.TitleName)
    self.TabBack.Btn_Back.OnClicked:Clear()
    self.TabBack.Btn_Back.OnClicked:Add(self, self.OnReturnClick)
    if Info.OverridenTopResouces then
        self.WBP_Com_Tab_ResourceBar:SetVisibility(UIConst.VisibilityOp["Visible"])
        self.WBP_Com_Tab_ResourceBar:InitResourceBar(Info.OverridenTopResouces, false)
    else
        self.WBP_Com_Tab_ResourceBar:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

function M:OnReturnClick()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_return", nil, nil)
    -- 点击退出
    if (type(self.BackCallback) == "function") then
        self.BackCallback(self.ParentWidget)
    end
end

-----------------------------------------------输入事件相关------------------------------------------------
function M:Handle_KeyEventOnPC(InKeyName)
    local IsEventHandled = true
    -- 处理键盘相关的交互事件
    if (InKeyName == UE4.EKeys.Escape.KeyName) then
        self:OnReturnClick()
    else
        IsEventHandled = false
    end
    return IsEventHandled
end

function M:Handle_KeyEventOnGamePad(InKeyName)
    local IsEventHandled = false
    -- 处理手柄相关的交互事件
    if (InKeyName == "Gamepad_FaceButton_Right") then
        self:OnReturnClick()
        IsEventHandled = true
    end
    return IsEventHandled
end

return M
