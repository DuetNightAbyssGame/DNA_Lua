--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Chat_DontDisturbContent_Item_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
-- 外部函数 SetClickCallback SetEnableHover
---仅初始化lua变量时使用，千万不要有控件操作！！
function M:Initialize()
    self.ChannelId = 1 -- 对应频道，影响点击回调
    self.EnableNotDisturb = false -- 是否开启免打扰
    self.EnableNormalHoverAnimation = true
end
---
function M:Construct()
    -- 清除按钮的各种事件绑定
    self.Btn_Click.OnClicked:Clear()
    self.Btn_Click.OnHovered:Clear()
    self.Btn_Click.OnUnhovered:Clear()
    self.Btn_Disturb.Button_Area.OnClicked:Clear()
    self.Btn_DontDisturb.Button_Area.OnClicked:Clear()

    -- 添加新的事件绑定
    self.Btn_Click.OnClicked:Add(self, self.OnDisturbItemClicked)
    self.Btn_Click.OnHovered:Add(self, self.OnHovered)
    self.Btn_Click.OnUnhovered:Add(self, self.OnUnhovered)
    self.Btn_Disturb.Button_Area.OnClicked:Add(self, self.OnDisturbClicked)
    self.Btn_DontDisturb.Button_Area.OnClicked:Add(self, self.OnDisturbClicked)

end

--- 当列表项对象被设置时调用此函数，用于更新列表项的显示内容
--- @param Content table 包含更新列表项所需的内容，格式为 {Enable , ChannelName, ChannelIcon, ChannelId,ClickCallback, CallbackObj}
function M:OnListItemObjectSet(Content)
    self.Text_ChatChannelName:SetText(Content.ChannelName)
    self.Image_ChatChannel:SetBrushFromTexture(Content.ChannelIcon)
    self.EnableNotDisturb = Content.Enable
    if self.EnableNotDisturb then
        self.WS_Btn:SetActiveWidgetIndex(1)
    else
        self.WS_Btn:SetActiveWidgetIndex(0)
    end
    self.ChannelId = Content.ChannelId
    if Content.ClickCallback then
        self:SetClickCallback(Content.ClickCallback, Content.ClickCallbackObj)
    end
    Content.UI = self

    if  self.ChannelId==nil then
        self.WS_Item:SetActiveWidgetIndex(1)
    end

end
--- 设置点击回调
--- @param Callback function 点击回调函数
--- @param CallbackObj table 回调函数所属的对象
function M:SetClickCallback(Callback, CallbackObj)
    self.OnDisturbClickedCallBack = Callback
    self.OnDisturbClickedCallBackObj = CallbackObj
end
-- 免打扰按钮周围热区被点击
function M:OnDisturbItemClicked()
    self:PlayDisturbClicked()
    UIUtils.PlayCommonBtnSe(self)
    self:OnDisturbClicked()
end
function M:PlayDisturbClicked()
    if self.EnableNotDisturb then
        self.Btn_Disturb:PlayAnimation(self.Btn_Disturb.Click)
    else
        self.Btn_DontDisturb:PlayAnimation(self.Btn_DontDisturb.Click)
        -- end
    end
end
--- 当免打扰按钮被点击时调用此函数，用于切换免打扰状态
function M:OnDisturbClicked()

    self.EnableNotDisturb = not self.EnableNotDisturb
    if self.EnableNotDisturb then
        self.WS_Btn:SetActiveWidgetIndex(1)
    else
        self.WS_Btn:SetActiveWidgetIndex(0)
    end
    if self.OnDisturbClickedCallBack then
        self.OnDisturbClickedCallBack(self.OnDisturbClickedCallBackObj)
    end
end

---策划的需求是Pc不需要Hover动画，所以需要设置是否开启Hover动画，默认开启
-- bIsEnable=true时，开启正常Hover动画，手柄段使用，bIsEnable=false时，Hover时仅仅播放子按钮hover，键鼠端使用
function M:SetEnableHover(bIsEnable)
    self.EnableNormalHoverAnimation = bIsEnable
end

function M:OnHovered()
    if not self.EnableNormalHoverAnimation then-- 
        return
    end
    self:PlayAnimation(self.Hover)
end

function M:OnUnhovered()
    if not self.EnableNormalHoverAnimation then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.UnHover)
end

-- 当列表项对象被销毁时调用此函数，用于清理资源
-- function M:Destruct()
-- end

return M
