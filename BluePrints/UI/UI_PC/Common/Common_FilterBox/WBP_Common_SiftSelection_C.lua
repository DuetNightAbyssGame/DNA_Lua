--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_SiftSelection_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Init(OwnerItemUI, index, name, iconPath)
    self.OwnerItemUI = OwnerItemUI
    self.Index = index  -- 保存索引
    self.Name = name    -- 保存名称
    self.Text_Selection:SetText(GText(name))
    self:SetImage(iconPath)
    self:RefreshBaseInfo()
    self:InitListenEvent()
end

function M:Construct()
    self.ITEMS_PER_ROW = 3 -- 每行固定显示4个CheckBox
    self.CheckBox_Selection.Btn_Click.OnClicked:Add(self, self.OnItemSelectionChanged)
end
function M:Destruct()
    self.CheckBox_Selection.Btn_Click.OnClicked:Remove(self, self.OnItemSelectionChanged)
end

function M:OnItemSelectionChanged()
    local CheckState = self.CheckBox_Selection:IsChecked()
    self.OwnerItemUI:OnSelectionItemChanged(CheckState, self)
    if CheckState then
        self:PlayAnimation(self.Click)
    else
        self:PlayAnimation(self.Normal)
    end
    return CheckState
end

function M:SetImage(iconPath)
    if not iconPath then return end
    self.Icon:SetVisibility(UIConst.VisibilityOp.Visible)
    local IconObject = LoadObject(iconPath)
    self.Icon:SetBrushResourceObject(IconObject)
end

--region 手柄相关
function M:OnFocusReceived(MyGeometry, InFocusEvent)
    -- self.CheckBox_Selection.Btn_Click:SetNavigateMovingDurationTime(0.5)
    self.CheckBox_Selection.Btn_Click:SetFocus()
    self.CheckBox_Selection:PlayAnimation(self.CheckBox_Selection.Normal)
    -- DebugPrint(TXTTag, "OnFocusReceived",self:HasFocusedDescendants())
    -- if self:HasFocusedDescendants() then
    --     self.OwnerItemUI.Key_Controller:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    -- end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

-- function M:OnFocusLost()
--     self.OwnerItemUI.Key_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
-- end

function M:OnAddedToFocusPath(InFocusEvent)
    if self.CurrentInputDevice == ECommonInputType.Gamepad then
        self.OwnerItemUI.Owner.List_Selection:ScrollWidgetIntoView(self, true, UE4.EDescendantScrollDestination.IntoView)
    end
end

-- function M:OnRemovedFromFocusPath(InFocusEvent)
--     self.OwnerItemUI.Key_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
-- end

function M:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice) 
    end
end

function M:RefreshBaseInfo()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        return
    end
    --- 切换手柄端相关图标显隐
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
    else
        -- self.CheckBox_Selection.Btn_Click:SetNavigateMovingDurationTime(0.5)
        -- self.CheckBox_Selection.Btn_Click:SetFocus()
        -- self.CheckBox_Selection:PlayAnimation(self.CheckBox_Selection.Normal)
        self.CheckBox_Selection.Group_BG:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self:InitNavigationRules()
    end
    self.CurrentInputDevice = CurInputDevice
end

function M:InitNavigationRules()
    self:SetNavigationRuleCustom(EUINavigation.Down, {self, self.SetWBoxDownTarget})
    self:SetNavigationRuleCustom(EUINavigation.Up, {self, self.SetWBoxUpTarget})
end
-- 向下导航
function M:SetWBoxDownTarget()
    local parentWBox = self:GetParent()
    if not parentWBox then return nil end
    
    local totalChildren = parentWBox:GetChildrenCount()
    local nextRowIndex = self.Index-1 + self.ITEMS_PER_ROW
    
    -- 如果下一行索引在有效范围内，直接返回
    if nextRowIndex < totalChildren then
        local nextItem = parentWBox:GetChildAt(nextRowIndex)
        return nextItem
    end
    
    -- 处理当前WrapBox最后一排不满的情况
    -- 计算当前在第几列和当前行
    local currentCol = (self.Index-1) % self.ITEMS_PER_ROW
    local currentRow = math.floor((self.Index-1) / self.ITEMS_PER_ROW)
    
    -- 检查是否有最后一排（即是否是倒数第二排导航到最后一排）
    local lastRowStartIndex = currentRow * self.ITEMS_PER_ROW + self.ITEMS_PER_ROW
    if lastRowStartIndex < totalChildren then
        -- 有最后一排，尝试找到最后一排对应的列或前面的元素
        local targetIndex = math.min(lastRowStartIndex + currentCol, totalChildren - 1)
        
        -- 如果目标索引超出范围或对应列不存在，向前查找最近的元素
        while targetIndex >= lastRowStartIndex and currentCol > 0 and targetIndex >= totalChildren do
            currentCol = currentCol - 1
            targetIndex = lastRowStartIndex + currentCol
        end
        
        -- 确保索引有效
        if targetIndex >= 0 and targetIndex < totalChildren then
            return parentWBox:GetChildAt(targetIndex)
        end
    end
    
    -- 如果已经是最后一行或无法在当前WrapBox找到合适目标，尝试跳转到下一个WrapBox
    local nextWBox = self.OwnerItemUI:GetNextWrapBox()
    if nextWBox then
        if nextWBox:GetChildrenCount() > 0 then
            -- 尝试找到下一个WrapBox的第一行相同列位置
            local currentCol = (self.Index-1) % self.ITEMS_PER_ROW
            local targetIndex = currentCol
            if targetIndex < nextWBox:GetChildrenCount() then
                local nextItem = nextWBox:GetChildAt(targetIndex)
                return nextItem
            else
                -- 如果对应列不存在，取第一个元素
                local nextItem = nextWBox:GetChildAt(0)
                return nextItem
            end
        end
        return nextWBox
    end
    
    return nil
end

-- 向上导航
function M:SetWBoxUpTarget()
    local parentWBox = self:GetParent()
    if not parentWBox then return nil end
    
    local prevRowIndex = self.Index-1 - self.ITEMS_PER_ROW
    if prevRowIndex >= 0 then
        -- return parentWBox:GetChildAt(prevRowIndex)
        local prevItem = parentWBox:GetChildAt(prevRowIndex)
        -- 确保上一个元素在可视区域内
        -- self:EnsureItemVisible(prevItem)
        return prevItem
    end

    local prevWBox = self.OwnerItemUI:GetPrevWrapBox()
    if prevWBox then
        local prevWBoxChildCount = prevWBox:GetChildrenCount()
        if prevWBoxChildCount > 0 then
            -- 计算当前在第几列
            local currentCol = (self.Index-1) % self.ITEMS_PER_ROW
            
            -- 计算上一个WrapBox的最后一行对应列的索引
            local lastRowStartIndex = prevWBoxChildCount - (prevWBoxChildCount % self.ITEMS_PER_ROW)
            if lastRowStartIndex == prevWBoxChildCount then
                lastRowStartIndex = prevWBoxChildCount - self.ITEMS_PER_ROW
            end
            -- 对应列位置
            local targetIndex = lastRowStartIndex + currentCol
            -- 如果对应列不存在，则向前查找最近的元素
            while targetIndex >= lastRowStartIndex and targetIndex >= prevWBoxChildCount do
                targetIndex = targetIndex - 1
            end
            -- 确保索引有效
            if targetIndex >= 0 and targetIndex < prevWBoxChildCount then
                -- return prevWBox:GetChildAt(targetIndex)
                local prevItem = prevWBox:GetChildAt(targetIndex)
                -- self:EnsureItemVisible(prevItem)
                return prevItem
            end
        end        
        -- 如果没有找到合适的目标，返回WrapBox本身
        return prevWBox
    end
    return nil
end

--endregion

return M
