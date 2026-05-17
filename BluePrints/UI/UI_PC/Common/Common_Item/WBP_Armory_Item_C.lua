--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_Item_Universal_L_C
local M = Class({"BluePrints.UI.UI_PC.Common.Common_Item.WBP_Com_item_Universal_L_C"})

function M:InitData(Content)
    M.Super.InitData(self, Content)
    self.bHovered = false                                   -- 记录是否在悬浮
    self.bPressed = false                                   -- 记录是否在按压
    -- self.Type = Content.Type                             -- 父类赋值过了 改名为ItemType
    -- self.StuffType = Content.StuffType                   -- 不确定要不要
    -- self.ParentWidget = Content.ParentWidget             -- Parent 改为： ParentWidget 父类赋值过了
    -- self.NotInteractive = Content.NotInteractive         -- bInteractive 改为NotInteractive 父类赋值过了
    self.bEnableDrag = Content.bEnableDrag                  -- 是否可拖拽
    -- self.IsSelected = Content.IsSelected                    -- 记录是否被选中 用父类IsSelect
    -- self.IsShowDetails = Content.IsShowDetails           -- 是否启用Tips 父类赋值过了
    self.UnitId = Content.UnitId
    -- self.HandleMouseDown = Content.HandleMouseDown       -- 父类 HandleMouseDown
    self.DragPivot = Content.DragPivot
    self.DragOffset = Content.DragOffset
    self.AudioType = Content.AudioType or self.ItemType     -- 播放声音的Type
    -- self.bSyncLoadIcon = Content.bSyncLoadIcon           -- 父类赋值过了 替换为bAsyncLoadIcon
    -- self.UIName = Content.UIName                         -- 看着没地方用

    self._OnUnLoadUI = Content.OnUnLoadUI
    self._OnDragCancelled = Content.OnDragCancelled
    self._OnDragEnter = Content.OnDragEnter
    self._OnDragLeave = Content.OnDragLeave
    self._CreateDragWidget = Content.CreateDragWidget
    self._OnMouseButtonDownEarly = Content.OnMouseButtonDownEarly
    -- self._OnBtnAddClickedFin = Content.OnBtnAddClickedFin                    -- 还没移植到
    -- self._OnBtnAddClicked = Content.OnBtnAddClicked                          -- 还没移植到
    -- self.Event_OnMenuOpenChanged = Content.MenuOpenChangedEvent         -- 有疑问，与Base实现方式不同 要不要与base合并在一起
    self.bAllUseAsyncLoadWidget = false
end

function M:Construct()
    M.Super.Construct(self)

    self:BindToAnimationFinished(self.Item.UnHover, {self, self.OnUnHoverAnimFinished})
    -- self:BindToAnimationFinished(self.Item.Selected_Loop, {self, self.OnSelectedLoopAnimFinished})   -- 无动画

    EventManager:AddEvent(EventID.UnLoadUI, self, function(self, UIName)
        if(self._OnUnLoadUI) then
            self._OnUnLoadUI(self, self.Content, UIName)
        end
    end)
    self.CurAnim = self.Item.Normal
end

function M:Destruct()
    M.Super.Destruct(self)
    self:UnbindFromAnimationFinished(self.Item.UnHover, {self,self.OnUnHoverAnimFinished})
    -- self:UnbindFromAnimationFinished(self.Item.Selected_Loop,{self,self.OnSelectedLoopAnimFinished}) -- 无动画
    EventManager:RemoveEvent(EventID.UnLoadUI, self)
end

function M:InitCompView()
    M.Super.InitCompView(self)
end

function M:TryPlayAnimation(Animation, ...)
    if(self.CurAnim == Animation)then
        return
    end
    self.PlayAnimParams = table.pack(...)
    local AnimToStop = self.CurAnim
    self.CurAnim = Animation
    if(self.Item:IsAnimationPlaying(AnimToStop))then
        self.Item:StopAnimation(AnimToStop)
        self.Item:PlayAnimation(Animation, ...)
    elseif(not self.Item:IsAnimationPlaying(Animation))then
        self.Item:PlayAnimation(Animation, ...)
    end
end

function M:SetInteractivity(bInteractive)
    self.NotInteractive = not bInteractive
end

--#endregion 动效相关开始
function M:OnHoveredChanged(bHovered)
    --DebugPrint("M::OnHoveredChanged::hover",bHovered)
    self.bHovered = bHovered
    if(self.Content.IsSelect)then
        return
    end
    if(bHovered)then
        if(self.CurAnim == self.Item.Hover)then return end
        self:TryPlayAnimation(self.Item.Hover)
    else
        self:TryPlayAnimation(self.Item.UnHover)
    end
end

function M:OnPressedChanged(bPressed)
    --DebugPrint("M::OnPressedChanged",bPressed)
    self.bPressed = bPressed
    if(self.Content.IsSelect)then
        return
    end
    if(bPressed)then
        self:TryPlayAnimation(self.Item.Press)
    else
        if(self:IsHovered() and CommonUtils.GetDeviceTypeByPlatformName(self) == "PC")then
            self:TryPlayAnimation(self.Item.Hover)
        else
            self:TryPlayAnimation(self.Item.Normal)
        end
    end
end

function M:OnUnHoverAnimFinished()
    self:CheckAndPlayCurrentAnim()
end

function M:CheckAndPlayCurrentAnim()
    if(self.bPressed)then
        self:TryPlayAnimation(self.Press)
    elseif(self:IsHovered())then
        self:TryPlayAnimation(self.hover)
    else
        self:TryPlayAnimation(self.Normal)
    end
end
--#endregion 动效相关结束

--#region 指针交互相关开始
function M:OnMouseEnter(MyGeometry,MouseEvent)
    if not self.bEnableDrag then return end
    M.Super.OnMouseEnter(self, MyGeometry, MouseEvent)
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
    if not self.bEnableDrag then return end
    M.Super.OnMouseLeave(self, MyGeometry, MouseEvent)
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
    if(self._OnMouseButtonDownEarly) then
        local Reply = self._OnMouseButtonDownEarly(self, self.Content, MouseEvent)
        if Reply then return Reply end
    end
    if UKismetInputLibrary.PointerEvent_IsMouseButtonDown(MouseEvent, EKeys.RightMouseButton) then
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    self.MouseDownPos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(MouseEvent)
    self:OnPressedChanged(true)
    return M.Super.OnMouseButtonDown(self, MyGeometry, MouseEvent)
end

function M:OnMouseCaptureLost()
    self:OnPressedChanged(false)
    self:OnHoveredChanged(false)
end

function M:OnMouseButtonUp(MyGeometry,MouseEvent)
    CommonUtils:CloseGuideTouchIfExist(self)-- todo 教学引导临时处理
    self.MouseDownPos = nil
    self:OnPressedChanged(false)
    return M.Super.OnMouseButtonUp(self, MyGeometry, MouseEvent)
end

function M:OnMouseMove(MyGeometry, MouseEvent)
    if(self.bEnableDrag and self:HasMouseCapture())then
        if(self.MouseDownPos and UUIFunctionLibrary.HasTraveledFarEnoughToTriggerDrag(MouseEvent, self.MouseDownPos))then
            self.Item.ItemDetails_MenuAnchor:SetAllowRetain(false)
            self:SetSelected(false)
            self.MouseDownPos = nil
            return UWidgetBlueprintLibrary.DetectDragIfPressed(MouseEvent, self, UE4.EKeys.LeftMouseButton)
        end
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
    if(self.bEnableDrag)then
        self.Item.ItemDetails_MenuAnchor:SetAllowRetain(false)
        self:SetSelected(false)
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

------拖拽相关开始
---创建拖拽控件：
---@field self.CreateDragWidget function 返回值为 UserWidget
---@field self.ParentWidget table CreateDragWidget 执行时的接收对象
---@field self.DragTag string 说明参照 UDragDropOperation
---@field self.DragPivot EDragPivot 说明参照 UDragDropOperation
---@field self.DragOffset FVector2D 说明参照 UDragDropOperation
function M:OnDragDetected(MyGeometry, PointerEvent)
    DebugPrint("WYX ", "WBP_Com_Item_Universal_L_C::OnDragDetected")
    self:OnPressedChanged(false)
    if(not self.bEnableDrag)then
        if(not self._OnDragLeave) then
            return
        end
    end
    local DragDropOperation = NewObject(UIUtils.GetCommonDragDropOperationClass())
    DragDropOperation.Payload = self.Content
    if(self._CreateDragWidget)then
        DragDropOperation.DefaultDragVisual = self._CreateDragWidget(self.ParentWidget, self.Content)
    end
    if(not DragDropOperation.DefaultDragVisual)then
        return nil
    end
    DragDropOperation.Tag = "WBP_Com_Item_Universal_L_C"
    DragDropOperation.Pivot = self.DragPivot or UE4.EDragPivot.CenterCenter
    DragDropOperation.Offset = self.DragOffset or DragDropOperation.Offset
    if self.IsShowDetails then
        self.Item.ItemDetails_MenuAnchor:CloseItemDetailsWidget()
    end
    return DragDropOperation
end

function M:OnDragEnter(MyGeometry, PointerEvent, Operation)
    DebugPrint("WYX ", "WBP_Com_Item_Universal_L_C::OnDragEnter")
    if Operation.Tag ~= "WBP_Com_Item_Universal_L_C" then return end
    if(self._OnDragEnter)then
        self._OnDragEnter(self.ParentWidget, self.Content)
    end
    if(Operation.DefaultDragVisual)then
        self:OnDragEnter_Lua(Operation.DefaultDragVisual)
    end
end

function M:OnDragEnter_Lua(CreateDragUI)
    CreateDragUI.IsDraging = true
end

function M:OnDragLeave(PointerEvent, Operation)
    DebugPrint("WYX ", "WBP_Armory_Item_C::OnDragLeave")
    if Operation.Tag ~= "WBP_Com_Item_Universal_L_C" then return end
    if(self._OnDragLeave)then
        self._OnDragLeave(self.ParentWidget, self.Content, PointerEvent, Operation.DefaultDragVisual)
    end
end

function M:OnDragCancelled(PointerEvent, Operation)
    DebugPrint("WYX ", "WBP_Armory_Item_C::OnDragCancelled")
    if Operation.Tag ~= "WBP_Com_Item_Universal_L_C" then return end
    self:OnHoveredChanged(false)
    self:SetSelected(false)
    if(self._OnDragCancelled)then
        self._OnDragCancelled(self.ParentWidget, self.Content,Operation, PointerEvent)
    end
    if(Operation.DefaultDragVisual)then
        self:OnDragCancel_Lua(Operation.DefaultDragVisual)
    end
end

function M:OnMenuOpenChanged(IsOpened)
    UIManager(self):SetIsMenuAnchorOpen(IsOpened)
    self:SetSelected(IsOpened)

    M.Super.OnMenuOpenChanged(self, IsOpened)
end

function M:OnDragCancel_Lua(CreateDragUI)
    if not CreateDragUI.Content or CreateDragUI.IsCancel then return end
    CreateDragUI.IsDraging = false
end

function M:SetEnableDrag(IsEnableDrag)
    self.bEnableDrag = IsEnableDrag
end
--#region 指针交互相关结束

function M:IsMenuOpen()
    return self.IsShowDetails and self.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:IsOpen()
end

function M:OnCloseMenuAnchor(IsNeedMenuChangedCallback)
    -- 关闭菜单锚
    if self:IsMenuOpen() then
        self.Item.ItemDetails_MenuAnchor:CloseItemDetailsWidget()
        if (IsNeedMenuChangedCallback) then          
            self.Item.ItemDetails_MenuAnchor:InitMenuOpenChangedListen()
        end
        self.Item.ItemDetails_MenuAnchor:CloseItemDetailsWidget()
    end
end

---播放魅影图标动画
function M:PlayPhantomJitterAnim()
    if(self.WidgetMap[self.PhantomWidget])then
        self.PhantomWidget:PlayAnimation(self.PhantomWidget.Jitter)
    end
end

return M
