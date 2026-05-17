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
--     ClickCallback = function,   按钮点击时的回调
--     ConfirmCallback = funtion,  弹窗确认之后的回调
--     OwnerWidget = Widget,       所属的对象
--     PopupId = 100101,           弹窗ID
--     MenuPlacement = EMenuPlacement(枚举类型)  除非有特殊需求，不然默认按照屏幕位置自适应,
--     SoundFunc = function,       列表点击音效
--     SoundFuncReceiver = Obj,    列表点击音效接收对象
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

    self.PopupId = ConfigData.PopupId
    -- -- 刷新设备相关信息
    -- local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    -- self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    -- if (IsValid(self.GameInputModeSubsystem)) then
    --     self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    -- end

    -- 所属的对象
    self.OwnerWidget = ConfigData.OwnerWidget
    -- 添加需要监听的事件
    self:InitListenEvent()
end

function M:InitListenEvent()
    self.Btn_Click.OnClicked:Add(self, self.OnViewInfoClick)
end

function M:ClearListenEvent()
    self.Btn_Click.OnClicked:Clear()
end

function M:OnViewInfoClick()
    if (self.PopupId ~= nil) then
        -- 点击Info按钮
        local Params = {
            RightCallbackFunction = function()
                if (type(self.ConfirmCallback) == "function") then
                    self.ConfirmCallback(self.OwnerWidget, "Confirm")
                end
            end
        }
        UIManager(self):ShowCommonPopupUI(self.PopupId, Params)
    end
    -- 播放音效
    if (type(self.SoundFunc) == "function") then
        self.SoundFunc(self.SoundFuncReceiver)
    end
    -- 详情按钮
    if (type(self.ClickCallback) == "function") then
        self.ClickCallback(self.OwnerWidget)
    end
end

function M:PlayClickSound()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_01", nil, nil)
end

return M