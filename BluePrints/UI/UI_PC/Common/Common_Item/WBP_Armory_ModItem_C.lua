--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_Itme_L_Mod_C
local M = Class({"BluePrints.UI.UI_PC.Common.Common_Item.WBP_Armory_Item_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:OnListItemObjectSet(Content)
    Content.SelfWidget = self
    self:RemoveAllEvent()
    self:InitData(Content)
    self.bAllUseAsyncLoadWidget = false
    self.bAsyncLoadIcon = true
    self.bDontRemoveSubWidget = true
    self:InitCompView()

    if self.AfterInitCallback then 
        self.AfterInitCallback(self)
    end
    self:SetVisibility(UIConst.VisibilityOp.Visible)
end

function M:UpdateModItem(Content)
    local ModId = Content.UnitId
    if not ModId then return end
    local ModDataInfo = DataMgr.Mod[ModId]
    if not ModDataInfo then
        if Content.ModId ~= 0 then
            DebugPrint(ErrorTag , LXYTag, "换个号吧，有些ModId被策划删了...", ModId)
        end
        return
    end
    local ModCost,Mod = nil, nil
    if Content.Uuid then
        local ModUuid = Content.Uuid
        Mod = ModController:GetModel():GetMod(ModUuid)
        if not Mod then
            local Avatar = GWorld:GetAvatar()
            Mod = Avatar.Mods[ModUuid]
        end
        ModId = Mod.ModId
        ModCost = Mod.Cost
    else
        ModId = Content.UnitId
        ModDataInfo = DataMgr.Mod[ModId]
        ModCost = ModDataInfo.Cost
    end
    
    self:SetRarity(Content.Rarity)
    self:SetIcon(ModDataInfo.Icon)
    self.ItemDetails_MenuAnchor:SetAllowHover(true)
    if Mod then
        if Mod:IsLock() then
            self:SetLock(1)
        end
        if Mod.ConflictUuids:Length()>0 and not Content.bEnhance then
            self:ShowContentWarning(GText("UI_Armory_Conflict"))
        else
            self:ShowContentWarning(nil)
        end
        if Mod.Level and Mod.Level ~= 0 then
            self:SetItemStartLevel(Mod.Level)
        end
        self:SetAura(Content.bAura)
        self:ShowModStar(Mod)
        --重新挂接极性层确保层级是对的
        if self.PolarityWidget then
            self.PolarityWidget:RemoveFromParent()
            self.WidgetMap[self.PolarityWidget] = nil
            self.PolarityWidget = nil
        end
        self:SetItemPolarity(Mod.Polarity, Mod.Cost)
    end
    if Content.IsNew then
        self:SetRedDot(UIConst.RedDotType.NewRedDot)
    else
        self:DisableReddot()
    end
    self:SetItemSelect(Content.IsChosen)
end


function M:BP_OnEntryReleased()
    M.Super.BP_OnEntryReleased(self)
    if self.Content then
        self.Content.UI = nil
    end
end

function M:InitCompView()
    local Level = self.Level
    self.Level = nil
    M.Super.InitCompView(self)
    self.Level = Level
    self:SetLevel(nil)
    local Content = self.Content
    self.ParentWidget = Content.Parent
    self.Parent = self.ParentWidget
    Content.UI = self
    self._OnMouseEnter = Content.OnMouseEnter
    self._OnMouseLeave = Content.OnMouseLeave
    self._OnRemovedFromFocusPathEvent = Content.OnRemovedFromFocusPathEvent
    self._MouseButtonUpEvent = Content.MouseButtonUpEvent

    self.ItemDetails_MenuAnchor = self.Item.ItemDetails_MenuAnchor
    self.ItemDetails_MenuAnchor:InitializeSetUp(self, Content)
    self.ItemDetails_MenuAnchor:CloseItemDetailsWidget()
    self.ItemDetails_MenuAnchor:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Item.ItemDetails_MenuAnchor:SetNavigatePosOffsetPercent(FVector2D(0.5, 0.2))
    self.Item.ItemDetails_MenuAnchor:SetNavigatePosAngle(0)
    self.Item.ItemDetails_MenuAnchor:SetNavigatePosOffsetAlignment(FVector2D(0.5, 1.0))
    self:UpdateModItem(Content)
    self:SetIsChosen(Content.IsChosen)
    self:SetName(GText(Content.UnitName))
end

function M:ShowName(Name)
    self:SetName(Name)
end

function M:OnRemovedFromFocusPath(InFocusEvent)
    if(self._OnRemovedFromFocusPathEvent)then
        self._OnRemovedFromFocusPathEvent(self.ParentWidget, self)
    end
    if ModController:IsGamepad() then
        self.ItemDetails_MenuAnchor:CloseItemDetailsWidget()
    end
end

function M:SetIsChosen(bChosen)
    self:SetItemSelect(bChosen)
end

function M:OnMenuOpenChanged(bIsOpen)
    UIManager(self):SetIsMenuAnchorOpen(bIsOpen)
    if(self.ItemDetails_MenuAnchor.bAllowHover) then return end
    M.Super.OnMenuOpenChanged(self, bIsOpen)
end

function M:OnMouseEnter(MyGeometry,MouseEvent)
    M.Super.OnMouseEnter(self, MyGeometry, MouseEvent)
    if(self._OnMouseEnter) then
        self._OnMouseEnter(self.ParentWidget,self, self.Content)
    end
end

function M:OnMouseLeave(MyGeometry,MouseEvent)
    M.Super.OnMouseLeave(self, MyGeometry, MouseEvent)
    if(self._OnMouseLeave) then
        self._OnMouseLeave(self.ParentWidget,self, self.Content)
    end
end
function M:SetIsSelected(bSelect)
    self:SetSelected(bSelect)
end

function M:SetMinusBtn(bShow, Obj, Func)
    self:SetItemMinus(bShow)
    if IsValid(self.MinusWidget) then
        if bShow then
            self.MinusWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            self.MinusWidget.Btn_Minus:UnBindEventOnClickedByObj(self)
            self.MinusWidget.Btn_Minus:BindEventOnClicked(self,function()
                AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_minus", nil, nil)
                Func(Obj,self.Content)
            end)
        else
            self.MinusWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
end

function M:ShowAddIcon(IsShow)
    self.Content.bShowAdd = IsShow
    self:SetAdd(IsShow)
    if IsValid(self.AddWidget) then
        if(IsShow)then
            self.AddWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        else
            self.AddWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
    local IsShowDetails = self.IsShowDetails
    self.IsShowDetails = false
    local Handler = M.Super.OnMouseButtonUp(self,MyGeometry, MouseEvent)
    self.IsShowDetails = IsShowDetails
    if(self._MouseButtonUpEvent)then
        self._MouseButtonUpEvent(self.ParentWidget,self.Content,MouseEvent)
        self:SetSelected(self.Content.IsSelected)
    end
    if ModController:IsMobile() then
        self:DisableReddot()
    end
    self.ItemDetails_MenuAnchor:OpenItemDetailsWidget(false)
    return Handler
end

function M:DisableReddot()
    if IsValid(self.ComItemNewReddot) then
        self.ComItemNewReddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:ShowContentWarning(WarningText)
    local Callback = function(CoroutineObj)
        if not IsValid(self.ConflictWidget) then
            self.ConflictWidget = self:CreateWidgetAsync("ComItemConflict",CoroutineObj)
            self.Node_Widget:AddChild(self.ConflictWidget) 
            local WidgetSlot = UWidgetLayoutLibrary.SlotAsOverlaySlot(self.ConflictWidget)
            WidgetSlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
            WidgetSlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
        end
        if WarningText then
            self.ConflictWidget:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
            self.ConflictWidget.Text_SoldOut:SetText(WarningText)
        elseif IsValid(self.ConflictWidget) then
            self.ConflictWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
    self:AsyncLoadWidgetCommon("ConflictWidget", "ShowContentWarningTask", Callback)
end

function M:ShowModStar(Mod)
    if not Mod or not Mod:HasCardLevel() then
        if IsValid(self.ModStarWidget) then
            self.ModStarWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    else
        if not IsValid(self.ModStarWidget) then
            local Widget = UIManager(self):CreateWidget('/Game/UI/WBP/Common/Item/Widget/WBP_Com_Item_ModStar.WBP_Com_Item_ModStar')
            local WidgetSlot = self.Node_Widget:AddChild(Widget)
            WidgetSlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
            WidgetSlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
            self.ModStarWidget = Widget
        end
        self.ModStarWidget:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.ModStarWidget.List_ModStar:ClearListItems()
        for i=1, (Mod.ModCardLevelMax) do
            local StarContent = NewObject(UIUtils.GetCommonItemContentClass())
            StarContent.Idx = i
            StarContent.bActivate = i<= Mod.CurrentModCardLevel
            StarContent.bGolden = false
            self.ModStarWidget.List_ModStar:AddItem(StarContent)
        end
    end
end

function M:OnSetBottomBlackHeight(Height)
    if not IsValid(self.ModStarWidget) then return end
    if not self.ModStarWidget:IsVisible() then return end
    local BrushSize = self.ModStarWidget.Base.Brush.ImageSize
    if Height == self.Item.BottomBlack_L then
        BrushSize.Y = self.ModStarWidget.Bottom_Normal
    elseif Height == self.Item.BottomBlack_Max then
        BrushSize.Y = self.ModStarWidget.Bottom_Max
    end
    self.ModStarWidget.Base:SetBrushSize(BrushSize)
end

function M:SetAura(bAura)
    if bAura then
        if not IsValid(self.AruaWidget) then
            local Widget = UIManager(self):CreateWidget('/Game/UI/WBP/Common/Item/Widget/WBP_Com_Item_Aura.WBP_Com_Item_Aura')
            local WidgetSlot =self.Node_Widget:AddChild(Widget) 
            WidgetSlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
            WidgetSlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
            self.AruaWidget= Widget
        end
        self.AruaWidget:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        if IsValid(self.AruaWidget) then
            self.AruaWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
end

return M
