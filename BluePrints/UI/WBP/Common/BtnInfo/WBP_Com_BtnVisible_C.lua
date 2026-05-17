--
-- DESCRIPTION
-- 通用详情按钮（样式三）
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
    self.IsActive = false
    self.SoundFunc = self.PlayClickSound
    self.SoundFuncReceiver = self
end

function M:Destruct()
    self:ClearListenEvent()
end

-- ConfigData({
--     ClickCallback = function,   按钮的回调
--     TargetWidget = Widget,      操作的Widget对象
--     IsActive = false,            默认状态（不传的话默认不显示状态）        
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

    self.IsActive = ConfigData.IsActive
    -- 操作的Widget对象
    self.TargetWidget = ConfigData.TargetWidget
    -- 所属的对象
    self.OwnerWidget = ConfigData.OwnerWidget
    
    -- 添加需要监听的事件
    self:InitListenEvent()
    -- 刷新样式
    self:UpdateView()
end

function M:UpdateView()
    if (self.IsActive) then
        self:PlayAnimationForward(self.ON)
        self.TargetWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self:PlayAnimationForward(self.OFF)
        self.TargetWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:OnBtnClick(IsChecked)
    -- 播放音效
    if (type(self.SoundFunc) == "function") then
        self.SoundFunc(self.SoundFuncReceiver)
    end
    if (IsValid(self.TargetWidget)) then
        -- 判断是否是开着
        self.IsActive = IsChecked
        self:UpdateView()
    end
    -- 执行回调
    if (type(self.ClickCallback) == "function") then
        self.ClickCallback(self.OwnerWidget, IsChecked)
    end
end

function M:InitListenEvent()
    -- self.Btn_Click.OnCheckStateChanged:Add(self, self.OnBtnClick)
    self.Btn_Click.OnClicked:Add(self, self.OnBtnClick)
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
