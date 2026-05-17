--
-- DESCRIPTION
-- 背包品质批量选择
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local M = Class("BluePrints.UI.BP_EMUserWidget_C")

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
    -- 颜色名称
    self.ColorName = ConfigData.ColorName
    -- 品质信息
    self.Rarity = ConfigData.Rarity
    -- 点击按钮的回调
    self.ClickCallback = ConfigData.ClickCallback
    -- 初始化音效播放函数
    self.SoundFunc = ConfigData.SoundFunc or self.PlayClickSound
    self.SoundFuncReceiver = ConfigData.SoundFuncReceiver or self

    -- 所属的对象
    self.OwnerWidget = ConfigData.OwnerWidget
end

function M:InitListenEvent()
    self.Button_Area.OnCheckStateChanged:Add(self, self.OnSelectClick)
end

function M:ClearListenEvent()
    self.Button_Area.OnCheckStateChanged:Clear()
end

function M:Start()
    -- 添加需要监听的事件
    self:InitListenEvent()
end

function M:Reset()
    -- 重置状态
    self:ClearListenEvent()
    self.Button_Area:SetChecked(false)
end

function M:OnSelectClick(IsChecked)
    -- 播放音效
    if (type(self.SoundFunc) == "function") then
        self.SoundFunc(self.SoundFuncReceiver)
    end
    -- 点击回调
    if (type(self.ClickCallback) == "function") then
        self.ClickCallback(self.OwnerWidget, IsChecked, self.Rarity)
    end
end

function M:PlayClickSound()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_01", nil, nil)
end

return M
