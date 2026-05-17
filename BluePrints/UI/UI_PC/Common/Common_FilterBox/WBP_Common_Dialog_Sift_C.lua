--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_Dialog_Sift_C
-- local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

function M:Construct()
    M.Super.Construct(self)
    --筛选维度条目框
    self.ItemUIPathName = "/Game/UI/WBP/Common/FilterSort/WBP_Com_SiftDialogItem.WBP_Com_SiftDialogItem"
    --  WBox_Selection筛选标签项复选框
    self.SelectionItemUIPathName = "/Game/UI/WBP/Common/FilterSort/WBP_Com_SiftSelection.WBP_Com_SiftSelection"
    self.SelectedItems = {}
    self.IsQuitBtnForbidden = true
end

function M:InitContent(Params, PopupData, Owner)
    M.Super.InitContent(self, Params, PopupData, Owner)
    self.Owner = Owner
    self.Params = Params
    self.ParentWidget = Params.ParentWidget
    -- self:SetFocus()
    self.List_Selection:ScrollToStart()
    self.Owner:GetButtonBar().Btn_Yes:BindEventOnReleased(self, self.OnBtnYes)
    self.Owner:GetButtonBar().Btn_Quit:BindEventOnReleased(self, self.OnBtnNo)

    for _, ItemData in ipairs(Params.ItemDatas) do
        local ItemUI = self:AddItem(ItemData)
        -- 将对应 SelectionDatas 传给 ItemUI
        if ItemData.SelectionDatas then
            ItemUI:InitSelectionItems(ItemData.SelectionDatas, ItemData.SelectionText, ItemData.IconPaths)
        end
    end
    if self.Params.ReselectionCallback then
        self.Params.ReselectionCallback(self)
    end
    self.CurInputDevice = nil
    self:RefreshBaseInfo()
    self:InitListenEvent()
    self:InitGamePadTarget()
    self:InitHintGamepadBtn()
end

-- 添加选择标签项
function M:AddSelectionItem(ItemData, SelectionData)
    local UIManager = UIManager(GWorld.GameInstance)
    local ItemUI = UIManager:CreateWidget(self.SelectionItemUIPathName)
    self.WBox_Selection:AddChild(ItemUI)
    ItemUI:Init(self, SelectionData, ItemData)
end
-- 添加筛选维度条目
function M:AddItem(ItemData)
    local UIManager = UIManager(GWorld.GameInstance)
    local ItemUI = UIManager:CreateWidget(self.ItemUIPathName)
    self.List_Selection:AddChild(ItemUI)
    ItemUI:Init(self, ItemData)
    self.List_Selection:ScrollWidgetIntoView(ItemUI, true)
    return ItemUI
end

function M:AddSelection(itemUI, index, name)
    local itemIndex = self.List_Selection:GetChildIndex(itemUI) + 1
    if not self.SelectedItems[itemIndex] then
        self.SelectedItems[itemIndex] = {}
    end
    table.insert(self.SelectedItems[itemIndex], index)
    -- 当表中有元素时，启用 btn_quit
    self.Owner:GetButtonBar().Btn_Quit:ForbidBtn(false)
    self.IsQuitBtnForbidden = false
end

function M:RemoveSelection(itemUI, index)
    local itemIndex = self.List_Selection:GetChildIndex(itemUI) + 1
    if self.SelectedItems and self.SelectedItems[itemIndex] then
        -- 找到并移除索引为 index 的项
        local indices = self.SelectedItems[itemIndex]
        for i, selectedIndex in ipairs(indices) do
            if selectedIndex == index then
                table.remove(indices, i)
                break
            end
        end
        -- 如果该筛选维度没有选择项，移除该维度
        if next(indices) == nil then
            self.SelectedItems[itemIndex] = nil
        end
    end
    -- 当所有筛选项都被移除时，禁用 btn_quit
    if next(self.SelectedItems) == nil then
        self.Owner:GetButtonBar().Btn_Quit:ForbidBtn(true)
        self.IsQuitBtnForbidden = true
    end
end

function M:TableContains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

function M:OnBtnYes()
    -- DebugPrintTable(self.SelectedItems, 2)
    if self.Params.OnConfirmCallback then
        self.Params.OnConfirmCallback(self,self.Owner,self.SelectedItems,self.Params.ItemDatas)
        self:Close()
    end
end

function M:OnBtnNo()
    if not IsValid(self) then
        return
    end
    -- 清空已选择的项
    self.SelectedItems = {}
    self.Owner:GetButtonBar().Btn_Quit:ForbidBtn(true)
    self.IsQuitBtnForbidden = true
    -- 取消所有勾选
    local dimensionCount = self.List_Selection:GetChildrenCount() - 1
    for i = 0, dimensionCount do
        local dimensionItem = self.List_Selection:GetChildAt(i)
        local tagItems = dimensionItem.WBox_Selection:GetAllChildren()
        local tagCount = tagItems:Num()
        for j = 1, tagCount do
            local tagItem = tagItems:Get(j)
            if tagItem and tagItem.CheckBox_Selection then
                -- 只在需要时触发状态变化
                if tagItem.CheckBox_Selection:IsChecked() then
                    tagItem.CheckBox_Selection:SetIsChecked(false)
                    tagItem:OnItemSelectionChanged()
                end
            end
        end
    end
    self.Owner.DontCloseWhenLeftBtnClicked = true
end

function M:OnClearSelection()
    self:OnBtnNo()
    self:Close()
end

function M:Reselection(SelectedItems)
    if SelectedItems then
        for dimensionIndex, selectedIndices in pairs(SelectedItems) do
            local dimensionItem = self.List_Selection:GetChildAt(dimensionIndex - 1)
            if dimensionItem then
                for _, selectionIndex in ipairs(selectedIndices) do
                    local selectionItem = dimensionItem.WBox_Selection:GetChildAt(selectionIndex - 1)
                    if selectionItem and selectionItem.CheckBox_Selection then
                        selectionItem.CheckBox_Selection:SetIsChecked(true)
                        selectionItem:OnItemSelectionChanged()
                    end
                end
                -- 检查该项的筛选项是否全部被选中
                local totalSelections = dimensionItem.WBox_Selection:GetChildrenCount()
                if #selectedIndices == totalSelections then
                    dimensionItem.isSelectedAll = true
                else
                    dimensionItem.isSelectedAll = false
                end
            end
        end
    end
end

function M:Close()
    if IsValid(self) then
        M.Super.Close(self)
        if IsValid(self.Owner) then
            self.Owner:Close()
        end
    end
end

function M:Destruct()
    M.Super.Destruct(self)
end
--region 手柄相关
function M:OnFocusReceived(MyGeometry, InFocusEvent)
    -- self.Owner:ShowGamepadScrollBtn(true)
    return M.Super.OnFocusReceived(self,MyGeometry, InFocusEvent)
end

function M:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function M:RefreshBaseInfo()
    -- 刷新一些基础信息
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
    self.CurGamepadName = CurGamepadName
    --- 输入设备切换通知
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    local ActiveWidgetIndex = IsUseKeyAndMouse and 0 or 1
    if (IsUseKeyAndMouse) then
    else
        self:InitGamePadTarget()
        -- self.List_Selection:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    end
    self.CurInputDevice = CurInputDevice
end

function M: InitGamePadTarget()
    self.CurInputDevice = self.GameInputModeSubsystem:GetCurrentInputType()
    if self.CurInputDevice == ECommonInputType.Gamepad then
        local firstSiftItem = self.List_Selection:GetChildAt(0)
        self.GameInputModeSubsystem:SetTargetUIFocusWidget(firstSiftItem)
        if firstSiftItem then
            local firstCheckBox = firstSiftItem.WBox_Selection:GetChildAt(0)
            self.GameInputModeSubsystem:SetTargetUIFocusWidget(firstCheckBox)
            if firstCheckBox and firstCheckBox.CheckBox_Selection then
                self.GameInputModeSubsystem:SetTargetUIFocusWidget(firstCheckBox.CheckBox_Selection)
                self.List_Selection:SetScrollOffset(0)
            end
        end
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == UIConst.GamePadKey.FaceButtonLeft ) then
            self:OnBtnYes()
        elseif (InKeyName == UIConst.GamePadKey.FaceButtonTop) then
            if self.IsQuitBtnForbidden then
                self.Owner:OnForbiddenLeftBtnClicked()
            end
            self:OnBtnNo()
        elseif InKeyName == Const.GamepadFaceButtonRight then
            self.Owner:OnCloseBtnClicked()
        end
    else
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

function M:InitHintGamepadBtn()
    self.Owner.Gamepad_Shortcut01:CreateCommonKey({
        KeyInfoList = {
        {
            Type = "Img",
            ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("A", self.CurGamepadName)
        }},
        Desc = GText("UI_RougeLike_BlessingConfirm").."/"..GText("UI_PATCH_CANCEL")
    })
    self.Owner.Gamepad_Shortcut01:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Owner.Gamepad_Shortcut02:CreateCommonKey({        
        KeyInfoList = {
        {
            Type = "Img",
            ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("B", self.CurGamepadName)
        }},
        Desc = GText("UI_Controller_Close")
    })
    self.Owner.Gamepad_Shortcut02:SetVisibility(UIConst.VisibilityOp.Visible)
end

--endregion
return M