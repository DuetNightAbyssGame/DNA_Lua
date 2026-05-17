--
-- DESCRIPTION
-- 通用详情按钮（样式一）
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local M = Class({"BluePrints.Common.TimerMgr","BluePrints.UI.BP_EMUserWidget_C"})

function M:Construct()
    self.SoundFunc = self.PlayClickSound
    self.SoundFuncReceiver = self
end

function M:Destruct()
    self:ClearListenEvent()
end

-- ConfigData({
--     ClickCallback = function,   按钮的回调
--     OwnerWidget = Widget,       所属的对象
--     TextContent = "",           文本内容
--     MenuPlacement = EMenuPlacement(枚举类型)  除非有特殊需求，不然默认按照屏幕位置自适应,
--     SoundFunc = function,       列表点击音效
--     SoundFuncReceiver = Obj,    列表点击音效接收对象
--     OnMenuOpenChangedCallBack=fucntion, 菜单锚打开的回调
-- })
---@param ConfigData table<string, any> 配置信息
function M:Init(ConfigData)
    -- 初始化详情按钮的信息
    self.ConfigData = ConfigData
    -- 点击按钮的回调
    self.ClickCallback = ConfigData.ClickCallback

    -- 初始化音效播放函数
    self.SoundFunc = ConfigData.SoundFunc or self.PlayClickSound
    self.SoundFuncReceiver = ConfigData.SoundFuncReceiver or self

    self.TextContent = ConfigData.TextContent
    self.OnMenuOpenChangedCallBack=ConfigData.OnMenuOpenChangedCallBack
    -- -- 刷新设备相关信息
    -- local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    -- self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    -- if (IsValid(self.GameInputModeSubsystem)) then
    --     self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    -- end

    if (ConfigData.MenuPlacement) then
        self.Tips_MenuAnchor:SetPlacement(ConfigData.MenuPlacement)
    else
        self:AddTimer(0.033, self.RefreshPlacementInViewport, false, 0, "RefreshPlacementInViewport", true)
    end

    -- 所属的对象
    self.OwnerWidget = ConfigData.OwnerWidget
    -- 添加需要监听的事件
    self:InitListenEvent()
end

function M:RefreshPlacementInViewport()
    local ViewportPos = FVector2D(0, 0)
    UE4.USlateBlueprintLibrary.LocalToViewport(self, self.Btn_Click:GetCachedGeometry(), FVector2D(0,0), nil, ViewportPos)
    local ViewPortSize = UWidgetLayoutLibrary.GetViewportSize(self)
    local ViewPortScale = UWidgetLayoutLibrary.GetViewportScale(self)
    local CenterPosition = ViewPortSize / ViewPortScale * 0.5
    if (ViewportPos.X < CenterPosition.X) then
        self.Tips_MenuAnchor:SetPlacement(EMenuPlacement.MenuPlacement_MenuRight)
    else
        self.Tips_MenuAnchor:SetPlacement(EMenuPlacement.MenuPlacement_MenuLeft)
    end
end

function M:InitListenEvent()
    self.Btn_Click.OnCheckStateChanged:Add(self, self.OnViewInfoClick)
    self.Btn_Click.OnHovered:Add(self, self.OnViewInfoHover)
    self.Btn_Click.OnUnHovered:Add(self, self.OnViewInfoUnHover)
    self.Btn_Click.OnClicked:Add(self, self.OnViewInfoClicked)
    self:InitMenuOpenChangedListen()
    -- if (IsValid(self.GameInputModeSubsystem)) then
    --     self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice) 
    -- end
end

function M:ClearListenEvent()
    self.Btn_Click.OnCheckStateChanged:Clear()
    self.Btn_Click.OnHovered:Clear()
    self.Btn_Click.OnUnHovered:Clear()
    self.Btn_Click.OnClicked:Clear()
    self:ClearMenuOpenChangedListen()
    -- if (IsValid(self.GameInputModeSubsystem)) then
    --     self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    -- end
end

function M:OnViewInfoHover()
    self:OpenMenuAnchor()
end

function M:OnViewInfoUnHover()
    self:CloseMenuAnchor()
end

function M:OnViewInfoClicked()
    -- 播放音效
    if (type(self.SoundFunc) == "function") then
        self.SoundFunc(self.SoundFuncReceiver)
    end
end

-- function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
--     if (self.CurInputDeviceType == CurInputDevice) then
--         -- 已经显示的是该输入模式，不需要进行刷新
--         return
--     end
--     self.CurInputDeviceType = CurInputDevice
--     self:UpdateStyle(CurGamepadName)
-- end

-- function M:UpdateStyle()
--     -- 刷新样式
-- end

function M:SetChecked(bChecked)
    self.Btn_Click:SetChecked(bChecked)
end

function M:IsChecked()
    return self.Btn_Click:IsChecked()
end

function M:ResetStyle()
    -- 重置样式
    self.Btn_Click:SetChecked(false)
end

function M:OnViewInfoClick(IsChecked)
    if (IsChecked) then
        -- 详情按钮
        if (type(self.ClickCallback) == "function") then
            self.ClickCallback(self.OwnerWidget, IsChecked)
        end
    end
    if (IsChecked) then
        self:OpenMenuAnchor()
    else
        self:CloseMenuAnchor()
    end
end

function M:PlayClickSound()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_01", nil, nil)
end

--region 菜单锚相关逻辑
function M:OnMenuClose()
    self:ResetStyle()
end

function M:OpenMenuAnchor()
    if (self.Tips_MenuAnchor:IsOpen()) then
        return
    end
    self.Tips_MenuAnchor:Open(true)
    if (self.TipsDetail) then
        self.TipsDetail:InitMessage(self.TextContent)
    end
end

function M:IsMenuAnchorOpen()
    return self.Tips_MenuAnchor:IsOpen()
end

function M:CloseMenuAnchor()
    if not (self.Tips_MenuAnchor:IsOpen()) then return end
    self.Tips_MenuAnchor:Close()
end

function M:InitMenuOpenChangedListen()
    self.Tips_MenuAnchor.OnMenuOpenChanged:Clear()
    self.Tips_MenuAnchor.OnMenuOpenChanged:Add(self,self.OnMenuOpenChanged)
end

function M:ClearMenuOpenChangedListen()
    self.Tips_MenuAnchor.OnMenuOpenChanged:Remove(self, self.OnMenuOpenChanged)
end

function M:OnMenuOpenChanged(bIsOpen)
    UIManager(self):SetIsMenuAnchorOpen(bIsOpen)
    if(not bIsOpen) then
        self:OnMenuClose()
    end
    if (not self.OnMenuOpenChangedCallBack) then return end
    self.OnMenuOpenChangedCallBack(self.OwnerWidget,bIsOpen)
end

--endregion

return M