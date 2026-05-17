--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Gacha_PoolItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    
    self.Btn_Click.OnClicked:Add(self, self.OnItemClick)
    self.Btn_Click.OnHovered:Add(self, self.OnItemHovered)
    self.Btn_Click.OnUnhovered:Add(self, self.OnItemUnhovered)
    self.Btn_Click.OnPressed:Add(self, self.OnItemOnPressed)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.Content.SelfWidget = self
    self.Parent = Content.Parent
    self.TabId = Content.TabId
    self.bShowNew = Content.bShowNew
    self.Text_PoolTitle:SetText(GText(Content.TabName))
    local IconDynaMaterial = self.Image_Pool:GetDynamicMaterial()
    if IconDynaMaterial then
        local Icon = LoadObject(Content.Icon)
        IconDynaMaterial:SetTextureParameterValue("IconMap", Icon)
    end

    self:_UpdateIndicatorVisibility()
    self:BindClickEvent(Content.ClickEvent)
    if Content.bSelected then
        self:OnItemClick(true, true)
    end
end





-- function M:_UpdateIndicatorVisibility()
--     -- 红点 > New > 无
--     if self.bShowReddot then
--         self.Reddot:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
--         self.New:SetVisibility(ESlateVisibility.Collapsed)
--     elseif self.bShowNew then
--         self.Reddot:SetVisibility(ESlateVisibility.Collapsed)
--         self.New:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
--     else
--         self.Reddot:SetVisibility(ESlateVisibility.Collapsed)
--         self.New:SetVisibility(ESlateVisibility.Collapsed)
--     end
-- end

-- function M:SetReddot(bShow)
--     if self.bShowReddot == bShow then
--         return
--     end
--     self.bShowReddot = bShow
--     self:_UpdateIndicatorVisibility()
-- end

-- function M:SetNew(bShow)
--     if self.bShowNew == bShow then
--         return
--     end
--     self.bShowNew = bShow
--     self:_UpdateIndicatorVisibility()
-- end

function M:BindClickEvent(ClickEvent)
    self.ClickObj = ClickEvent.Obj
    self.ClickCallback = ClickEvent.Callback
end

function M:OnItemClick(bNotPlayMusic, bIsAutoSelect)
    if self.bSelected then
        return
    end
    if not self.ClickCallback then
        return
    end
    self.bSelected = true
    self:PlayAnimation(self.Click)
    self.ClickCallback(self.ClickObj, self.TabId, self.Content, not bNotPlayMusic, bIsAutoSelect)
end

-- function M:OnItemHovered()
--     if self.bSelected then
--         return
--     end
--     self:PlayAnimation(self.Hover)
-- end

-- function M:OnItemUnhovered()
--     if self.bSelected then
--         return
--     end
--     self:PlayAnimation(self.Unhover)
-- end

-- function M:OnItemOnPressed()
--     if self.bSelected then
--         return
--     end
--     self:PlayAnimation(self.Press)
-- end

-- function M:UnSelect()
--     self.bSelected = false
--     self:PlayAnimation(self.Normal)
-- end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName == UIConst.GamePadKey.DPadLeft then
            self.Parent:OnGamePadDown(InKeyName)
        end
    else

    end
end
return M
