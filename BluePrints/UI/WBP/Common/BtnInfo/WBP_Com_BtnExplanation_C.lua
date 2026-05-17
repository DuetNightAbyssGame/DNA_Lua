--
-- DESCRIPTION
-- 通用概率说明按钮按钮
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
    self.IsActive = false
    -- self.SoundFunc = self.PlayClickSound
    -- self.SoundFuncReceiver = self
end

function M:Destruct()
    self:UnBindButtonPerformances()
end

-- ConfigData({
--     ClickCallback = function,   按钮的回调    
--     OwnerWidget = Widget,       所属的对象
--     SoundFunc = function,       列表点击音效
--     SoundFuncReceiver = Obj,    列表点击音效接收对象
--     Desc = String，             显示的textmap
-- })
---@param ConfigData table<string, any> 配置信息
function M:Init(ConfigData)
    -- 初始化详情按钮的信息
    self.ConfigData = ConfigData

    -- 所属的对象
    self.OwnerWidget = ConfigData.OwnerWidget

    self.Com_BtnQa:Init(ConfigData)
    self.Tex_Explanation:SetText(GText(ConfigData.Desc))

    self:BindButtonPerformances()
    if (UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad) then
        self.WidgetSwitcher_0:SetActiveWidgetIndex(1)
    else
        self.WidgetSwitcher_0:SetActiveWidgetIndex(0)
    end
end

function M:BindButtonPerformances()
    self.Btn_Area.OnClicked:Add(self, self.OnBtnClick)
    self.Btn_Area.OnPressed:Add(self, self.OnPressed)
    self.Btn_Area.OnHovered:Add(self, self.OnHovered)
    self.Btn_Area.OnUnhovered:Add(self, self.OnUnhovered)
end

function M:UnBindButtonPerformances()
    self.Btn_Area.OnClicked:Clear()
    self.Btn_Area.OnPressed:Clear()
    self.Btn_Area.OnHovered:Clear()
    self.Btn_Area.OnUnhovered:Clear()
end

function M:OnBtnClick()
    self:PlayAnimation(self.Click)
    self.Com_BtnQa:OnViewInfoClick()
end

function M:OnPressed()
    self:PlayAnimation(self.Press)
end

function M:OnHovered()
    if self.bBtnClickHovered then
        return
    end
    self.bBtnClickHovered = true
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
end

function M:OnUnhovered()
    if not self.bBtnClickHovered then
        return
    end
    self.bBtnClickHovered = false
    self:StopAllAnimations()
    self:BindToAnimationFinished(self.UnHover, {self, function()
            self:UnbindAllFromAnimationFinished(self.UnHover)
            self:StopAllAnimations()
            self:PlayAnimation(self.Normal)
        end})
    self:PlayAnimation(self.UnHover)
end

--- =============================== 输入模式切换相关 =============================================
function M:UpdateUIStyleInPlatform(IsUseGamePad)
    if IsUseGamePad then
        self.WidgetSwitcher_0:SetActiveWidgetIndex(1)
    else
        self.WidgetSwitcher_0:SetActiveWidgetIndex(0)
    end
end
return M
