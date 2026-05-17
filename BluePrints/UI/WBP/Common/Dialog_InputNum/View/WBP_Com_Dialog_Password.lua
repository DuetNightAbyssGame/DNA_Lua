require "UnLua"

--- WBP_Com_Dialog_Password
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Construct()
    self.bIsMasked = true
    if self.Btn_Visible then
        self.Btn_Visible:BindEventOnClicked(self, self.OnEyeClick)
        self.Btn_Visible.DesiredFocusWidget = self.Btn_Visible.Button_Area
    end
    self:UpdateEyeIcon()
end

function M:OnListItemObjectSet(Item)
    if not Item then return end
    
    self.ItemData = Item.ItemData
    
    if self.ItemData then
        if self.ItemData.ParentPanel then
            self.ItemData.ParentPanel:RegisterRowWidget(self.ItemData.RowIndex, self)
        end

        if self.Text_Desc then
            self.Text_Desc:SetText(self.ItemData.DescText)
        end

        if self.Password then
            self.Password:BindBtnClickEvent(self, self.OnItemClick)

            if self.Password.SetContext then
                self.Password:SetContext(self.ItemData)
            end
        end

        local InitText = self.ItemData.Text or ""
        local InitFocused = self.ItemData.bIsFocused or false
        
        self:SetupNavigation()
        self:RefreshState(InitText, InitFocused)
    end
end

--region 外部调用接口

---刷新本行状态
function M:RefreshState(Text, bIsFocused)
    self.CachedText = Text or ""

    if self.Password then
        self.Password:RefreshState(self.CachedText, bIsFocused)
        self.Password:UpdateGrid(self.CachedText, self.bIsMasked)
    end
end

--endregion

--region 内部交互

---子控件被点击时触发
function M:OnItemClick()
    if self.ItemData and self.ItemData.ClickObj and self.ItemData.ClickFunc then
        self.ItemData.ClickFunc(self.ItemData.ClickObj, self.ItemData.RowIndex)
    end
end

---点击眼睛按钮
function M:OnEyeClick()
    self.bIsMasked = not self.bIsMasked
    self:UpdateEyeIcon()
    if self.Password then
        self.Password:UpdateGrid(self.CachedText, self.bIsMasked)
    end
end

---更新眼睛图标视觉
function M:UpdateEyeIcon()
    if self.WS_Visible then
        self.WS_Visible:SetActiveWidgetIndex(self.bIsMasked and 1 or 0)
    end
end

--endregion

--region 手柄部分

function M:SetupNavigation()
    local InputBtn = (self.Password and self.Password.Btn_Click)
    local EyeBtn = self.Btn_Visible
    
    if not InputBtn then return end

    if EyeBtn then
        InputBtn:SetNavigationRuleExplicit(EUINavigation.Right, EyeBtn)
        EyeBtn:SetNavigationRuleExplicit(EUINavigation.Left, InputBtn)

        InputBtn:SetNavigationRuleCustom(EUINavigation.Up, function()
            if self.ItemData and self.ItemData.ParentPanel then
                return self.ItemData.ParentPanel:OnNavigateUpFromRow(self.ItemData.RowIndex, false)
            end
            return nil
        end)
        InputBtn:SetNavigationRuleCustom(EUINavigation.Down, function()
            if self.ItemData and self.ItemData.ParentPanel then
                return self.ItemData.ParentPanel:OnNavigateDownFromRow(self.ItemData.RowIndex, false)
            end
            return nil
        end)
        EyeBtn:SetNavigationRuleCustom(EUINavigation.Up, function()
            if self.ItemData and self.ItemData.ParentPanel then
                return self.ItemData.ParentPanel:OnNavigateUpFromRow(self.ItemData.RowIndex, true)
            end
            return nil
        end)
        EyeBtn:SetNavigationRuleCustom(EUINavigation.Down, function()
            if self.ItemData and self.ItemData.ParentPanel then
                return self.ItemData.ParentPanel:OnNavigateDownFromRow(self.ItemData.RowIndex, true)
            end
            return nil
        end)
    end
end

--endregion

return M