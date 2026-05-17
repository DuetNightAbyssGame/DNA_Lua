--
-- DESCRIPTION
-- 称号样式Item
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_PersonalInfo_TitleSetting_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
-- function M:Initialize(Initializer)
-- end
function M:OnListItemObjectSet(Content)
  
    if Content.IsNew then
        self.New:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

    if not Content or not Content.FrameId then
        self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.WS_Item:SetActiveWidgetIndex(1)
        return
    else
        self.WS_Item:SetActiveWidgetIndex(0)
    end

    -- self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Content = Content
    Content.UI = self
    self.Btn_Area.OnClicked:Clear()
    self.Btn_Area.OnClicked:Add(Content.Father, function()
        Content.Father:OnItemClicked(Content)
    end)
    self:InitSelect()
    self:SetIsEquipped(Content.bEquipped)
    self.Title:ClearChildren()
    local Widget = UIManager(self):LoadTitleFrameWidget(Content.FrameId)
    if Widget then
        Widget.Text_Title:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Title:AddChildToOverlay(Widget)
        if Content.bOwned == false then
            --置灰时不希望播放Normal动画，因为会和HaveNot动画冲突，同时HaveNot有取消选中的动画轨道
            self.Btn_Area.NormalAnimName = "HaveNot"
            self:PlayAnimation(self.HaveNot)
        else
            self.Btn_Area.NormalAnimName = "Normal"
        end
    end
end
-- function M:OnAnimationStarted(InAnimation)
--     local AnimationName = InAnimation:GetName()
--     ScreenPrint(" OnAnimationStarted "..AnimationName)
-- end

function M:OnAddedToFocusPath()
    self.Content.FocusEvent(self.Content.FocusEventObj,self.Content,self)
end

function M:InitSelect()
    if self.Content and self.Content.bSelect then
        self.Btn_Area:SetChecked(true)
        self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        self.Btn_Area:SetChecked(false)
        self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
end
function M:SetIsEquipped(bIsEquipped)
    if bIsEquipped then
        self:PlayAnimation(self.Select)
    else
        if self.Content.bEquipped then
            self:PlayAnimationReverse(self.Select)
        end
    end
    self.Content.bEquipped = bIsEquipped
end

function M:SetIsSelected(bIsSelect)
    self.Content.bSelect = bIsSelect
    if bIsSelect then
        if not self.Btn_Area:IsChecked() then
           -- self.Btn_Area:SetCheckedNoNotify(true)
        end
        if self.Content.IsNew then
            self.Content.IsNew=false
            UIUtils.TrySubReddotCacheDetailNumber(self.Content.FrameId,"TitleFrame")
            self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        self.Btn_Area:SetCheckedNoNotify(false)
        self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
end
-- function M:Construct()
-- end

-- function M:Tick(MyGeometry, InDeltaTime)
-- end

-- function M:Destruct()
-- end

return M
