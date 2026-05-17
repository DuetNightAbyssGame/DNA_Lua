--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_Sort_C
local M = Class("BluePrints.UI.BP_UIState_C")

---@param Parent  UUIState 父控件（需要传整个界面，因为需要获取界面的ZOrder)
---@param SortBy_List  array 排序依据数组
---@param SortType int 排序方式
---@param Params table 前面的参数不好改，之后新增的参数都放这里面
function M:Init(Parent, SortBy_List, SortType, Params)
    Params = Params or {}
    rawset(self,"Parent",Parent)
    rawset(self,"CurSortBy",Params.SortBy or 1 ) --默认选中的排序依据索引
    rawset(self,"_OnAddedToFocusPath",Params.OnAddedToFocusPath)
    rawset(self,"_OnRemovedFromFocusPath",Params.OnRemovedFromFocusPath)
    rawset(self,"_OnListOpened",Params.OnListOpened)
    rawset(self,"_OnListClosed",Params.OnListClosed)
    rawset(self,"OnGetBackFocusWidget",Params.OnGetBackFocusWidget)--指定返回按键聚焦的控件
    rawset(self,"OnGetBackReply",Params.OnGetBackReply) --funciton 返回按键的事件回复
    rawset(self,"SortBy_List",SortBy_List or {})
    rawset(self,"IsListViewOpened",false)
    self.Text_Filterlist:SetText("")
    if(SortBy_List and #SortBy_List > 0)then
        self.Btn_Filter_List:SetVisibility(UIConst.VisibilityOp["Visible"])
    else
        self.Btn_Filter_List:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    self:SetSortInfos(self.CurSortBy or 1,SortType or CommonConst.DESC)
    if(IsValid(self.ListWidget))then
        self.ListWidget:Init(self,self.SortBy_List,self.CurSortType)
    end
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType())
end

--- 绑定排序选项变更事件
function M:BindEventOnSelectionsChanged(Obj,Event)
    rawset(self,"Obj_OnSelectionsChanged",Obj)
    rawset(self,"Event_OnSelectionsChanged",Event)
end

--- 绑定排序类型变更事件
function M:BindEventOnSortTypeChanged(Obj,Event)
    rawset(self,"Obj_OnSortTypeChanged",Obj)
    rawset(self,"Event_OnSortTypeChanged",Event)
end

---@return number, number 排序依据的索引、排序方式
function M:GetSortInfos()
    return self.CurSortBy,self.CurSortType
end

function M:SetGamepadKey(FocusKeyName)
    rawset(self,"FocusKeyName",FocusKeyName)
    local FocusKeyImgPath = UIUtils.UtilsGetKeyIconPathInGamepad(self.FocusKeyName)
    self.Img_Key:SetBrushFromTexture(LoadObject(FocusKeyImgPath))
    self:UpdateGamepadKeyState()
end

-------------

function M:SetSortInfos(SortByIdx,SortType)
    rawset(self,"CurSortBy",SortByIdx)
    rawset(self,"CurSortType",SortType)
    self.Text_Filterlist:SetText(GText(self.SortBy_List[self.CurSortBy]))
    if(self.CurSortType == CommonConst.ASC)then
        self:PlayAnimationReverse(self.Btn_Switch)
    else
        self:PlayAnimationForward(self.Btn_Switch)
    end
end

function M:Construct()
    M.Super.Construct(self)
    rawset(self,"IsInFocusPath",false)
    self:AddInputMethodChangedListen()
    rawset(self,"FocusKeyName","LS")
    rawset(self,"CurInputDeviceType",UIUtils.UtilsGetCurrentInputType())
    self:PlayAnimation(self.SortList_Normal)
    self:PlayAnimation(self.Btn_Normal)
    self.bIsFocusable = true
end

-- region 排序依据按钮

function M:OnBtn_Filter_List_Pressed()
    self:StopAnimation(self.SortList_Hover)
    self:StopAnimation(self.SortList_Click)
    self:PlayAnimation(self.SortList_Press)
end

function M:OnBtn_Filter_List_Released()
    if(not rawget(self,"IsTouch"))then
        return
    end
    self:StopAnimation(self.SortList_Hover)
    self:StopAnimation(self.SortList_Click)
    self:StopAnimation(self.SortList_Press)
    self:PlayAnimation(self.SortList_UnHover)
end

function M:OnBtn_Filter_List_Hovered(bImdly)
    if(rawget(self,"IsTouch"))then
        return
    end
    if(rawget(self,"IsFilterListBtnHovered"))then
        self:PlayAnimation(self.SortList_Hover, 0, 1, 0, 100, false);
        return
    end
    rawset(self,"IsFilterListBtnHovered",true)
    self:StopAnimation(self.SortList_UnHover)
    if(bImdly)then
        self:PlayAnimation(self.SortList_Hover, 0, 1, 0, 100, false)
    else
        self:PlayAnimation(self.SortList_Hover)
    end
end

function M:OnBtn_Filter_List_Unhovered()
    if(rawget(self,"IsTouch"))then
        return
    end
    self:StopAnimation(self.SortList_Hover)
    self:StopAnimation(self.SortList_Click)
    self:StopAnimation(self.SortList_Press)
    self:PlayAnimation(self.SortList_UnHover)
end

function M:ListOpenBtnClicked()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_02", nil, nil)
    if(#self.SortBy_List > 0)then
        if(IsValid(self.ListWidget))then
            UIManager(self):UnLoadUI("ComSortFullScreen")
        end
        rawset(self,"ListWidgetOpening",true)
        local BpClassPath = self.FullScreenBpPath
        self.ListWidget = UIManager(self):LoadUI(BpClassPath,"ComSortFullScreen" , self.Parent:GetZOrder(),self,self.SortBy_List,self.CurSortType)
        self.Parent.SortListWidget = self.ListWidget
        rawset(self,"ListWidgetOpening",false)
    end
end

function M:OnListClosed()
    rawset(self,"IsListViewOpened",false)
    self:SetFocus()
    if self._OnListClosed then
        self._OnListClosed(self.Parent, self)
    end
end

function M:OnListOpened()
    rawset(self,"IsListViewOpened",true)
    if self._OnListOpened then
        self._OnListOpened(self.Parent, self)
    end
end

-- endregion 排序依据按钮

-- region 排序类型按钮

function M:OnBtn_SortType_Pressed()
    self:StopAnimation(self.Btn_Hover)
    self:StopAnimation(self.Btn_Click)
    self:PlayAnimation(self.Btn_Press)
end

function M:OnBtn_SortType_Released()
    if(not rawget(self,"IsTouch"))then
        return
    end
    self:StopAnimation(self.Btn_Hover)
    self:StopAnimation(self.Btn_Click)
    self:StopAnimation(self.Btn_Press)
    self:PlayAnimation(self.Btn_UnHover)
end

function M:OnBtn_SortType_Hovered(bImdly)
    if(rawget(self,"IsTouch"))then
        return
    end
    if(rawget(self,"IsSortTypeBtnHovered"))then
        self:PlayAnimation(self.Btn_Hover, 0, 1, 0, 100, false)
        return
    end
    rawset(self,"IsSortTypeBtnHovered",true)
    self:StopAnimation(self.Btn_UnHover)
    if(bImdly)then
        self:PlayAnimation(self.Btn_Hover, 0, 1, 0, 100, false)
    else
        self:PlayAnimation(self.Btn_Hover)
    end
end

function M:OnBtn_SortType_Unhovered()
    if(rawget(self,"IsTouch"))then
        return
    end
    self:StopAnimation(self.Btn_Hover)
    self:StopAnimation(self.Btn_Click)
    self:StopAnimation(self.Btn_Press)
    self:PlayAnimation(self.Btn_UnHover)
end

function M:PlayBtnSortTypeClickAnim()
end

function M:OnSortTypeButtonClicked()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    self:OnSortTypeChanged()
end

function M:OnSortTypeChanged()
    if(self.CurSortType == CommonConst.ASC)then
        self.CurSortType = CommonConst.DESC
        self:PlayAnimationForward(self.Btn_Switch)
    else
        self.CurSortType = CommonConst.ASC
        self:PlayAnimationReverse(self.Btn_Switch)
    end
    if(IsValid(self.ListWidget))then
        self.ListWidget:SetSortType(self.CurSortType)
    end
    if(self.Event_OnSortTypeChanged)then
        self.Event_OnSortTypeChanged(self.Obj_OnSortTypeChanged, self.CurSortType, self.CurSortBy)
    end
end

function M:OnSelectionsChanged()
    if(self.Event_OnSelectionsChanged)then
        self.Event_OnSelectionsChanged(self.Obj_OnSelectionsChanged,self.CurSortBy, self.CurSortType)
    end
end

-- endregion 排序类型按钮

function M:UpdateGamepadKeyState()
    if(self.CurInputDeviceType == ECommonInputType.Gamepad)then
        if(self.IsInFocusPath or (IsValid(self.ListWidget) and self.ListWidget.IsInFocusPath) or self.ListWidgetOpening or self.IsControllerKeyHidden)then
            self.Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
        else
            self.Controller:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end
    else
        self.Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:SetControllerKeyHidden(bHidden)
    rawset(self,"IsControllerKeyHidden",bHidden)
    if bHidden then
        self.Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self.Controller:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
end

function M:ChangeKeyByInputDevice(CurInputDevice, CurGamepadName)
    self:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    rawset(self,"CurInputDeviceType",CurInputDevice)
    rawset(self,"IsTouch",CurInputDevice == ECommonInputType.Touch)
    self:UpdateGamepadKeyState()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if(Const.GamepadFaceButtonRight == InKeyName)then
        if(self.OnGetBackReply)then
            local Reply = self.OnGetBackReply(self.Parent,MyGeometry, InKeyEvent)
            if(Reply)then
                return Reply
            end
        end
        if(self.OnGetBackFocusWidget)then
            local Widget = self.OnGetBackFocusWidget(self.Parent,MyGeometry, InKeyEvent)
            if(IsValid(Widget))then
                return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),Widget)
            end
        end
        if (self.Parent.SetFocus_Lua) then
            self.Parent:SetFocus_Lua()
            return UE4.UWidgetBlueprintLibrary.Handled()
        else
            return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self.Parent)
        end
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    M.Super.OnFocusReceived(self,MyGeometry, InFocusEvent)
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self.Btn_Filter_List)
end

function M:SetLeftWidgetForNavigation(Widget)
    if(Widget)then
        self.Btn_Filter_List:SetNavigationRuleExplicit(EUINavigation.Left,Widget)
    else
        self.Btn_Filter_List:SetNavigationRuleBase(EUINavigation.Left,EUINavigationRule.Stop)
    end
end

function M:SetRightWidgetForNavigation(Widget)
    if(Widget)then
        self.Btn_SortType:SetNavigationRuleExplicit(EUINavigation.Right,Widget)
    else
        self.Btn_SortType:SetNavigationRuleBase(EUINavigation.Right,EUINavigationRule.Stop)
    end
end

function M:OnAddedToFocusPath(InFocusEvent)
    rawset(self,"IsInFocusPath",true)
    self:UpdateGamepadKeyState()
    if(self._OnAddedToFocusPath)then
        self._OnAddedToFocusPath(self.Parent,self)
    end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
    rawset(self,"IsInFocusPath",false)
    self:UpdateGamepadKeyState()
    if(self._OnRemovedFromFocusPath)then
        self._OnRemovedFromFocusPath(self.Parent,self)
    end
end

--用于手柄快捷打开控件
function M:Activate()
    self:ListOpenBtnClicked() 
end

return M
