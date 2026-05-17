--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_CustomItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
M._components = {
    "BluePrints.UI.BP_EMUserWidgetUtils_C"
}

-- function M:Construct()
-- end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    rawset(self,"IsGamepadInput",CurInputDevice == ECommonInputType.Gamepad)
    if(self.bInFocusPath and not self:IsFocusStateValid())then
        local Widget = self:GetDesiredFocusTarget()
        if(Widget and not UIUtils.HasAnyFocus(Widget))then
            Widget:SetFocus()
        end
    end
    self:UpdateResetBtnVisibility()
end

function M:UpdateResetBtnVisibility()
    if(rawget(self,"bShowResetBtn"))then
        if(self:IsValueChanged())then
            self.Btn_Reset:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            if(self.IsGamepadInput and self.bInFocusPath)then
                self.Key_Reset:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            else
                self.Key_Reset:SetVisibility(UIConst.VisibilityOp.Collapsed)
            end
        else
            self.Btn_Reset:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.Key_Reset:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    else
        self.Btn_Reset:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Key_Reset:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:IsValueChanged()
    local AllChildren = self.VB_Custom:GetAllChildren():ToTable()
    for i = 1,#AllChildren,1 do
        if(AllChildren[i]:IsVisible() and AllChildren[i]:IsValueChanged())then
            return true
        end
    end
    return false
end

function M:OnListItemObjectSet(Params)
    self.Btn_Reset:UnBindEventOnClickedByObj(self)
    self.Btn_Reset:BindEventOnClicked(self,self.OnResetBtnClicked)
    rawset(self,"GamepadResetKeyName","")
    Params = Params or {
        -- Owner = Owner
        -- Title = string
        -- bShowResetBtn = false,       --是否显示重置按钮
        -- OnResetBtnClicked = function, --重置按钮回调
        -- GamepadResetKey = KeyName -- 手柄重置键,UIConst.GamePadImgKey的key
        -- Items = {
        --     {
        --         Owner = Owner       回调接受者，不填则用Params.Owner
        --         Text = string,      --条目名称
        --         MaxValue = number,  --最大值，默认1
        --         MinValue = number,  --最小值，默认0
        --         DefaultValue = number,  --默认值，点击重置会设置到这个值,不传则用MinValue
        --         CurrentValue = number,  --当前值，不传则用DefaultValue
        --         StepSize = numer, --滑动条步长
        --         bShowResetBtn = false,
        --         OnResetBtnClicked = function(Item), --重置按钮回调
        --         OnValueChanged = function(Value,Item), --滑条数值改变回调
        --         GamepedLeftKey = KeyName --向左手柄键,UIConst.GamePadImgKey的key
        --         GamepedRightKey = KeyName --向右手柄键,UIConst.GamePadImgKey的key
        --         GamepadResetKey = KeyName -- 手柄重置键,UIConst.GamePadImgKey的key
        --     }
        -- },
    }
    rawset(self,"Params",Params or {})
    rawset(self,"Owner",Params.Owner)
    rawset(self,"bShowResetBtn",Params.bShowResetBtn)
    self.Text_Title:SetText(Params.Title)
    rawset(self,"_OnResetBtnClicked",Params.OnResetBtnClicked)
    if(Params.GamepadResetKey)then
        rawset(self,"GamepadResetKeyName",UIConst.GamePadKey[Params.GamepadResetKey])
        self.Key_Reset:CreateGamepadKey(UIConst.GamePadImgKey[Params.GamepadResetKey])
    end
    local AllChildren = self.VB_Custom:GetAllChildren():ToTable()
    local ChildrenNum = #AllChildren
    local Items = Params.Items or {}
    local ItemNumber = #Items
    local WidgetClass = UGameplayStatics.GetObjectClass(AllChildren[1])
    local UIManager = UIManager(self)
    local ShouldKeepCount = ItemNumber > 1 and ItemNumber or 1
    if(ChildrenNum > ShouldKeepCount)then
        for i=ChildrenNum,ShouldKeepCount + 1,-1 do
            if(i > 1)then--要留一个Widget用于下次获取Class
                AllChildren[i]:RemoveFromParent()
            end
        end
    elseif(ChildrenNum < ShouldKeepCount)then
        for i=ChildrenNum,ShouldKeepCount,1 do
            self.VB_Custom:AddChild(UIManager:CreateWidget(WidgetClass, false))
        end
    end
    AllChildren = self.VB_Custom:GetAllChildren():ToTable()
    for i = 1,#AllChildren,1 do
        if(Items[i])then
            Items[i].Owner = Items[i].Owner or self.Owner
            AllChildren[i]:OnListItemObjectSet(Items[i])
            AllChildren[i]:SetVisibility(UIConst.VisibilityOp.Visible)
            AllChildren[i]:BindEventOnResetBtnVisibilityChanged(self,self.UpdateResetBtnVisibility)
        else
            AllChildren[i]:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
    self:InitNavigationRules()
    self:RemoveInputMethodChangedListen()
    self:AddInputMethodChangedListen()
    if(self.GameInputModeSubsystem)then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function M:InitNavigationRules()
    local AllChildren = self.VB_Custom:GetAllChildren():ToTable()
    for i = 1,#AllChildren,1 do
        if(AllChildren[i - 1] and AllChildren[i - 1]:IsVisible())then
            AllChildren[i]:SetNavigationRuleExplicit(EUINavigation.Up, AllChildren[i - 1])
        else
            AllChildren[i]:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Escape)
        end
        if(AllChildren[i + 1] and AllChildren[i + 1]:IsVisible())then
            AllChildren[i]:SetNavigationRuleExplicit(EUINavigation.Down, AllChildren[i + 1])
        else
            AllChildren[i]:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Escape)
        end
        AllChildren[i].BP_OnAddedToFocusPath:Clear()
        AllChildren[i].BP_OnAddedToFocusPath:Add(self,self.OnItemAddedToFocusPath)
    end

    if(self:GetParent():GetChildAt(0) == self)then
        --父项第一个条目向上导航为停止，防止导航到重置按钮
        if(AllChildren[1])then
            AllChildren[1]:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
        end
    end
end

function M:OnResetBtnClicked()
    local DontReset = false
    if(rawget(self,"_OnResetBtnClicked"))then
        DontReset = self._OnResetBtnClicked(self.Owner,self.Params)
    end
    if(not DontReset)then
        self:ResetValue()
    end
end

function M:ResetValue()
    local AllChildren = self.VB_Custom:GetAllChildren():ToTable()
    for i = 1,#AllChildren,1 do
        if(AllChildren[i]:IsVisible())then
            AllChildren[i]:ResetValue()
        end
    end
end

function M:IsFocusStateValid()
    local Widget = self.VB_Custom:GetChildAt(self.FocusedItemIndex or 0)
    if(Widget)then
        return true
    end
end

function M:GetItemWidget(ItemIndex)
    return self.VB_Custom:GetChildAt(ItemIndex + 1)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == self.GamepadResetKeyName and rawget(self,"bShowResetBtn") then
        self:ResetValue()
        return UIUtils.Handled
    end
    return UIUtils.Unhandled
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self:GetDesiredFocusTarget())
end
   
function M:OnItemAddedToFocusPath(Widget)
    rawset(self,"FocusedItemIndex",nil)
    local ItemIndex = self.VB_Custom:GetChildIndex(Widget)
    if(ItemIndex >= 0)then
        rawset(self,"FocusedItemIndex",ItemIndex)
    end
end 

function M:OnAddedToFocusPath(InFocusEvent)
    rawset(self,"bInFocusPath",true)
    self:UpdateResetBtnVisibility()
end

function M:OnRemovedFromFocusPath(InFocusEvent)
    rawset(self,"bInFocusPath",false)
    self:UpdateResetBtnVisibility()
end

function M:GetWidgetForNavDir(Dir)
    local AllChildren = self.VB_Custom:GetAllChildren():ToTable()
    local Start,End,Step = 1,#AllChildren,1
    if(Dir == EUINavigation.Up)then
        Start,End,Step = #AllChildren,1,-1
    elseif(Dir == EUINavigation.Down)then
        Start,End,Step = 1,#AllChildren,1
    end
    for i = Start,End,Step do
        if(AllChildren[i]:IsVisible())then
            return AllChildren[i]
        end
    end
end

function M:GetDesiredFocusTarget()
    local Widget
    if(rawget(self,"FocusedItemIndex"))then
        Widget = self.VB_Custom:GetChildAt(self.FocusedItemIndex)
    end
    if(not Widget)then
        Widget = self.VB_Custom:GetChildAt(0)
    end
    return Widget
end

AssembleComponents(M)

return M
