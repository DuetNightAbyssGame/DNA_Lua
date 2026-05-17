--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local UIUtils = require "Utils.UIUtils"

---@class Common_Sift_PC:Common_Sift_PC_C,BP_UIState
---@field Button_FIiliter_List Common_Button_Image_PC
local M = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.UI.BP_EMUserWidgetUtils_C"})

local IconPathFiltered = '/Game/UI/UI_PNG_Static/Atlas/Common/Common_Filter02.Common_Filter02'
local IconPathUnFiltered = '/Game/UI/UI_PNG_Static/Atlas/Common/Common_Filter.Common_Filter'

function M:Init(Filters)
    self.Filters = Filters or {}
    self.IsSelected = false --Sift已经勾选过
    self.SelectedSiftItems = {} --Sift勾选的数据
    self.IsListViewOpened = false
    self.SelectedItems = {}
    self.Filter_List:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    self.Properties:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    self.Text_Properties:SetText("")
    self.List:ClearListItems()
    if(Filters and #Filters > 0)then
        self.Filters = Filters
        for i, value in ipairs(Filters) do
            local Obj = NewObject(UIUtils.GetCommonItemContentClass())
            Obj.Text = value
            Obj.Mode = "Multi"
            Obj.IsSelected = false
            Obj.Index = i
            Obj.Owner = self
            self.List:AddItem(Obj)
        end
        self.Button_FIiliter_List:SetVisibility(UIConst.VisibilityOp["Visible"])
    else
        self.Button_FIiliter_List:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    self:UpdateFilterInfos()
    self.Image_Filiter_1:SetBrushResourceObject(self.IconUnfiltered)
end

--- 绑定筛选选项变更事件
function M:BindEventOnSelectionsChanged(Obj,Event)
    self.Obj_OnSelectionsChanged = Obj
    self.Event_OnSelectionsChanged = Event
end

function M:BindEventOnAddedToFocusPath(Obj,Event)
    self.Obj_OnAddedToFocusPath = Obj
    self.Event_OnAddedToFocusPath = Event
end

function M:BindEventOnRemovedFromFocusPath(Obj,Event)
    self.Obj_OnRemovedFromFocusPath = Obj
    self.Event_OnRemovedFromFocusPath = Event
end

---@return array 选中的筛选器的索引数组
function M:GetFilterInfos()
    return self.FiltersRes
end

-------------



function M:UpdateFilterInfos()
    local FiltersHintText = ""
    local Indexes = {}
    local bHasItem = (next(self.SelectedItems) ~= nil)
    local Items = self.List:GetListItems()
    local Len = Items:Length()
    if(bHasItem)then
        for i = 1,Len do
            if(self.SelectedItems[Items[i].Text])then
                FiltersHintText = FiltersHintText .. GText(Items[i].Text) .. ", "
                table.insert(Indexes,Items[i].Index)
            end
        end
        FiltersHintText = string.sub(FiltersHintText,1,#FiltersHintText-2)
    else
        for i = 1,Len do
            table.insert(Indexes,Items[i].Index)
        end
    end
    -- if(bHasItem)then
    --     self.IconFiltered = self.IconFiltered or LoadObject("/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_Filter02.T_Armory_Filter02")
    --     self.Img_Sift:SetBrushResourceObject(self.IconFiltered)
    -- else
    --     self.IconUnFiltered = self.IconUnFiltered or LoadObject("/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_Filter.T_Armory_Filter")
    --     self.Img_Sift:SetBrushResourceObject(self.IconUnfiltered)
    -- end
    self.FiltersRes = Indexes
    return self.FiltersRes,FiltersHintText
end

function M:Construct()
    self:AddDispatcher(EventID.OnMenuClose,self,self.OnListClosed)
    self.Button_FIiliter_List:BindEventOnClicked(self, self.ListOpenBtnClicked)
    self.Button_FIiliter_List:BindEventOnHover(self, self.OnBtn_Filter_List_Hovered)
    self.Button_FIiliter_List:BindEventOnUnhover(self, self.OnBtn_Filter_List_Unhovered)
    --self.List.BP_OnItemClicked:Add(self, self.OnListItemClicked)
    --self.List.BP_OnItemIsHoveredChanged:Add(self, self.OnListItemHoveredChanged)
    self:BindToAnimationFinished(self.List_Out,{self,self.OnListOutFin})
    self.Text_Properties:SetText("")
    self.SiftModelId = nil
    self.SiftPreviewWidget = self.SiftPreview_Middle --Sift预览默认为mid
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.FocusKeyName = "LS"
    self:SetGamepadKey(self.FocusKeyName)
    self:InitNavigationRules()
    self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
end

function M:SetGetBackFocusWidget(OnGetBackFocusWidget)
    self.OnGetBackFocusWidget = OnGetBackFocusWidget
end

function M:OnListOutFin()
    self.Filter_List:SetVisibility(UIConst.VisibilityOp["Collapsed"])
end

function M:Destruct()
    self.Button_FIiliter_List:UnbindEventOnHover()
    self.Button_FIiliter_List:UnbindEventOnUnhover()
    self.Button_FIiliter_List:UnBindEventOnReleased(self, self.ListOpenBtnClicked)
    --self.List.BP_OnItemClicked:Remove(self, self.OnListItemClicked)
    --self.List.BP_OnItemIsHoveredChanged:Remove(self, self.OnListItemHoveredChanged)
    self:UnbindFromAnimationFinished(self.List_Out, {self, self.OnListOutFin})
    self:RemoveDispatcher(EventID.OnMenuClose)
    self.SiftBox = nil
    self.Event_OnSelectionsChanged = nil
    self.Obj_OnSelectionsChanged = nil
end

function M:OnBtn_Filter_List_Hovered()
    if(self.IsListViewOpened)then
        return
    end
    if(self.Text_Properties:GetText() ~= "")then
        self.Properties:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    end
end

function M:OnBtn_Filter_List_Unhovered()
    if(self.IsListViewOpened)then
        return
    end
    if(self.Text_Properties:GetText() ~= "")then
        self.Properties:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

function M:GetSiftModelData(SiftModelId)
    local SiftModelDataList = {}
    local SubIds = DataMgr.SiftModel[SiftModelId].SubId
    for _, SiftId in ipairs(SubIds) do
        local SiftData = DataMgr.SiftDimens[SiftId]
        table.insert(SiftModelDataList, SiftData)
    end
    if #SiftModelDataList == 0 then
        DebugPrint("错误：未找到对应的筛选模型数据，SiftModelId:", SiftModelId)
        return nil
    end
    return SiftModelDataList
end

function M:OnSiftBoxConfirmed(ItemUI, SelectedItems, ItemDatas)
    -- DebugPrintTable(SelectedItems, 2)
    --存储勾选项
    self.SelectedSiftItems = SelectedItems
    -- 处理 SelectedItems    
    if SelectedItems and next(SelectedItems) then
        self.SiftPreviewWidget:Init(self, ItemUI, SelectedItems, ItemDatas)
        self.Switch_Icon:SetActiveWidgetIndex(1)
        if(self.Event_OnSelectionsChanged)then
            self.Event_OnSelectionsChanged(self.Obj_OnSelectionsChanged, self.SelectedSiftItems, ItemDatas)
        end
    else
        self.SiftPreviewWidget:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self:PreViewDelete(true)
    end
    self:AddTimer(0.2,function()
        if self.CurInputDeviceType == ECommonInputType.Gamepad and not self.bNotAutoFocus then
           self.Button_FIiliter_List:SetFocus()
        end
    end)
end

function M:ClearSiftSelection()
    self.SiftPreviewWidget:ClearItemSelection()
end

function M:PreViewDelete(bResetFocus2Btn)
    self.SelectedSiftItems = {}
    self.Switch_Icon:SetActiveWidgetIndex(0)
    if(self.Event_OnSelectionsChanged)then
        self.Event_OnSelectionsChanged(self.Obj_OnSelectionsChanged, self.SelectedSiftItems)
    end
    if self.CurInputDeviceType == ECommonInputType.Gamepad and bResetFocus2Btn then
        self.Button_FIiliter_List:SetFocus()
    end
end

function M:AfterSiftBoxClosed()
    self:AddTimer(0.3,function()
        if self.CurInputDeviceType == ECommonInputType.Gamepad or true then
            self.Button_FIiliter_List:SetFocus()
        end
    end, false, 0, "Common_Sift_AutoFocusTimer",true)
end

function M:OpenSiftBox(SiftModelId)
    --如果已有已有勾选，获取勾选项重新生成界面
    local ModSiftDatas = self:GetSiftModelData(SiftModelId)
    -- DebugPrintTable(ModSiftDatas,2)
    local Params = {
        ParentWidget = self,
        ItemDatas = ModSiftDatas,
        DontCloseWhenLeftBtnClicked = true,
        -- ShowBKeyClose = true,
        RightGamepadKey = EKeys.X.KeyName,
        RightGamepadImg = EKeys.X.KeyName,
        LeftGamepadKey = EKeys.Y.KeyName,
        LeftGamepadImg = EKeys.Y.KeyName,
        CloseBtnCallbackFunction = function()
            if self.SelectedSiftItems and next(self.SelectedSiftItems) then
                self.IsSelected = true
            end
            self:AfterSiftBoxClosed()
            --目前close_btn关闭弹窗不需要影响已经筛选的结果
        end,
        OnConfirmCallback = function(ItemUI,DialogObj,SelectedItems,ItemDatas)      
            if next(SelectedItems) then
                self.IsSelected = true
            end
            self:OnSiftBoxConfirmed(ItemUI,SelectedItems,ItemDatas)
        end,
        ReselectionCallback = function(SiftBox)
            self.SiftBox = SiftBox
            if self.IsSelected then
                SiftBox:Reselection(self.SelectedSiftItems)
                self.IsSelected = false
            end
        end,
    }
    local Dialog = UIManager(self):ShowCommonPopupUI(100129, Params, self)
    -- Dialog:SetFocus()--会影响内部聚焦逻辑
end

function M:SetSiftModelId(SiftModelId)
    self.SiftModelId = SiftModelId
end

function M:SetSiftPreviewSideWidget(bSideWidget,bRight)
    if bSideWidget then
        if bRight then
            self.SiftPreviewWidget = self.SiftPreview_Side_R
        else
            self.SiftPreviewWidget = self.SiftPreview_Side
        end
    else
        self.SiftPreviewWidget = self.SiftPreview_Middle
    end
end

function M:ListOpenBtnClicked()
    -- UIUtils.PlayCommonBtnSe(self) --commondialog已有打开音效
    if not self.SiftModelId then
        print("Error: SiftModelId is not set.")
        return
    end
    self:OpenSiftBox(self.SiftModelId)
    if not (self.Filters) then
        self.Filter_List:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        return 
    end

    if not (self.IsListViewOpened)then
        EventManager:FireEvent(EventID.OnMenuClose)
        self.Properties:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self:PlayAnimation(self.List_In)
        self.Filter_List:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.IsListViewOpened = true
        for _,Item in pairs(self.SelectedItems) do
            if IsValid(Item.Entry) then
                Item.Entry:OnEntrySelectionChanged()
            end
        end
    else 
        self:OnListClosed()
    end
end

function M:OnListItemClicked(Content)
    if(self:IsAnimationPlaying(self.List_In))then
        return
    end
    Content.IsSelected = not Content.IsSelected
    Content.Entry:OnEntrySelectionChanged()
    if(Content.IsSelected)then
        self.SelectedItems[Content.Text] = Content
    else
        self.SelectedItems[Content.Text] = nil
    end
    local Filters,FiltersHintText = self:UpdateFilterInfos()
    self.Text_Properties:SetText(FiltersHintText)
    if(FiltersHintText ~= "")then
        self.Image_Filiter_1:SetBrushResourceObject(self.IconFiltered)
    else
        self.Image_Filiter_1:SetBrushResourceObject(self.IconUnfiltered)
    end
    if(self.Event_OnSelectionsChanged)then
        self.Event_OnSelectionsChanged(self.Obj_OnSelectionsChanged, Filters)
    end
end

-- function M:OnListItemHoveredChanged(Content,IsHover)
--     Content.Entry:OnEntryHoveredChanged(IsHover)
-- end

function M:OnListClosed()
    if(self.Filters)then
        if(self.IsListViewOpened)then
            self:PlayAnimation(self.List_Out)
            self.IsListViewOpened = false
        end
    else
        --self.Filter_List:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

function M:IsSifted()
    local hasSelectedItems = self.SelectedSiftItems and next(self.SelectedSiftItems) ~= nil
    local isSiftPreviewGenerated = self.SiftPreviewWidget and self.SiftPreviewWidget:GetVisibility() ~= UIConst.VisibilityOp["Collapsed"]
    if hasSelectedItems and isSiftPreviewGenerated then
        return true
    else
        return false
    end
end

--region 手柄相关
function M:UpdateGamepadKeyState()
    self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    DebugPrint("UpdateGamepadKeyState",  self.CurInputDeviceType)
    if(self.CurInputDeviceType == ECommonInputType.Gamepad)then
        if(self.IsInFocusPath or (IsValid(self.ListWidget) and self.ListWidget.IsInFocusPath) or self.ListWidgetOpening)then
            self.Controller_L:SetRenderOpacity(0)
        else
            self.Controller_L:SetRenderOpacity(1)
        end
        self.Controller_L:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Controller_L:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

-- function M:ChangeKeyByInputDevice(CurInputDevice, CurGamepadName)
--     self:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
-- end

function M:InitNavigationRules()
    self.Button_FIiliter_List:SetNavigationRuleExplicit(EUINavigation.Up,self.SiftPreviewWidget)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    --- 输入设备切换通知
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    local ActiveWidgetIndex = IsUseKeyAndMouse and 0 or 1
    if (IsUseKeyAndMouse) then
        
    else
        
    end
    self:UpdateGamepadKeyState()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == UIConst.GamePadKey.FaceButtonBottom) then
            -- self.SiftPreviewWidget.Key_Controller:SetVisibility(UIConst.VisibilityOp.Visible)
        end
    end
    if(UIConst.GamePadKey.FaceButtonRight == InKeyName)then
        if(self.OnGetBackFocusWidget)then
            local Widget = self.OnGetBackFocusWidget(MyGeometry, InKeyEvent)
            if(IsValid(Widget))then
                return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),Widget)
            end
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    self:SetFocus()
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnAddedToFocusPath(MyGeometry, InFocusEvent)
    if(self.Event_OnAddedToFocusPath)then
        self.Event_OnAddedToFocusPath(self.Obj_OnAddedToFocusPath,self)
    end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
    if(self.Event_OnRemovedFromFocusPath)then
        self.Event_OnRemovedFromFocusPath(self.Obj_OnRemovedFromFocusPath,self)
    end
end

function M:SetGamepadKeyVisibility(VisibilityOp)
    self.Img_Key_L:SetVisibility(VisibilityOp)
end

function M:SetGamepadKey(FocusKeyName)
    local FocusKeyImgPath = UIUtils.UtilsGetKeyIconPathInGamepad(self.FocusKeyName)
    self.Img_Key_L:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "LS"
            },
        },
    })
    self:UpdateGamepadKeyState()
end
--region

function M:Close()
    self.SiftPreviewWidget:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    -- self.Event_OnSelectionsChanged = nil
    -- self.Obj_OnSelectionsChanged = nil
    self:PreViewDelete(false)
    if IsValid(self.SiftBox) then
        self.SiftBox:Close()
    end
    self:ClearScriptRegister()
end

return M
