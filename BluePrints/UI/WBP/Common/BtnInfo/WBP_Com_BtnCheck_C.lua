--
-- DESCRIPTION
-- 通用详情按钮（样式四）
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local M = Class("BluePrints.UI.BP_EMUserWidget_C")

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

    -- 所属的对象
    self.OwnerWidget = ConfigData.OwnerWidget
    -- 添加需要监听的事件
    self:InitListenEvent()
end

function M:OnViewInfoClick(IsChecked)
    -- 播放音效
    if (type(self.SoundFunc) == "function") then
        self.SoundFunc(self.SoundFuncReceiver)
    end
    -- 详情按钮
    if (type(self.ClickCallback) == "function") then
        self.ClickCallback(self.OwnerWidget, IsChecked)
    end
end

function M:InitListenEvent()
    -- self.Btn_Click.OnCheckStateChanged:Add(self, self.OnViewInfoClick)
    self.Btn_Click.OnClicked:Add(self, self.OnViewInfoClick)
end

function M:ClearListenEvent()
    -- self.Btn_Click.OnCheckStateChanged:Clear()
    self.Btn_Click.OnClicked:Clear()
end

-- function M:ResetStyle()
--     -- 重置样式
--     self.Btn_Click:SetChecked(false)
-- end

function M:PlayClickSound()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_01", nil, nil)
end

return M
