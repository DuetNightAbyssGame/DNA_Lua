--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local Platform = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance)

---@type WBP_Build_Default_C
local WBP_SquadListItem_C = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.Common.TimerMgr","BluePrints.Common.DelayFrameComponent"})

WBP_SquadListItem_C._components = {
    "BluePrints.UI.WBP.Abyss.MainComponent.Abyss_CharMainComponent",
}

local Handled = UE.UWidgetBlueprintLibrary.Handled()
local UnHandled = UE.UWidgetBlueprintLibrary.UnHandled()
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function WBP_SquadListItem_C:Init()
    self:SwitchItemType()
    self:InitBtn()
    --不是新增按钮的情况下保持原来的按钮设置
    if not self.IsAddSquad then
        self:InitItem()
        self.Btn_Add:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Btn_Add:SetVisibility(ESlateVisibility.Visible)
    end
    self:HideAllArrow()
    self:CheckSortIcon()

    self:UnbindAllFromAnimationFinished(self.Click)
    self:BindToAnimationFinished(self.Click, {self, function()
        self.ClickCallback(self.Owner, self.Index)
    end})

    --重置item的动画状态情况
    if self.Owner.IsDraging and self.Owner.CurSelectSquadIndex == self.Index then
        self.Owner:HideOrShowItemInDraging(self.Owner.CurSelectSquadIndex)
    end
    if not self.Owner.IsDraging then
        if self.IsSelect then
            --self.IsSelect = true
            self:PlayAnimation(self.Select)
            self.Melee:PlayAnimation(self.Melee.Click)
            self.Ranged:PlayAnimation(self.Ranged.Click)
        else
            self:PlayAnimation(self.Normal)
            self.Melee:PlayAnimation(self.Melee.Normal)
            self.Ranged:PlayAnimation(self.Ranged.Normal)
        end
    end
end

function WBP_SquadListItem_C:OnListItemObjectSet(Content)
    self.Content = Content
    self.Content.SelfWidget = self
    self.SquadInfo = Content.SquadInfo
    self.IsNeedSort = Content.IsNeedSort
    self.ClickCallback = Content.ClickCallback
    self.Owner = Content.Owner
    self.IsAddSquad = Content.IsAddSquad
    self.Index = self.IsAddSquad and self.Owner.SquadMax or Content.Index
    self.IsSelect = self.Owner.CurSelectSquadIndex == self.Index
    self.FakeIndex = self.Index --排序时的视觉上Index，不一定与在listview中的Index一致
    self:Init()
    self:PlayAnimation(self.ResetPos)
end

function WBP_SquadListItem_C:SetIndex(Index)
    self.FakeIndex = Index
end

--展示item的类型
function WBP_SquadListItem_C:SwitchItemType()
    if self.IsAddSquad then
        self.Panel_Normal:SetVisibility(ESlateVisibility.Collapsed)
        self.Panel_Add:SetVisibility(ESlateVisibility.Visible)
        self.Frame_Black:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Panel_Add:SetVisibility(ESlateVisibility.Collapsed)
        self.Panel_Normal:SetVisibility(ESlateVisibility.Visible)
    end
end

--初始化item
function WBP_SquadListItem_C:InitItem()
    --设置预设阵容名字
    local SquadName = ""
    if self.SquadInfo.Name and self.SquadInfo.Name ~= "" then
        SquadName = self.SquadInfo.Name
    else
        SquadName = GText("Squad_DefaultName1")
    end
    self.Text_Name:SetText(SquadName)

    -- 设置头像
    local CharId = self.SquadInfo.CharId
    local IconDynaMaterial = self.Icon_Avatar:GetDynamicMaterial()
    if IconDynaMaterial and CharId then
        IconDynaMaterial:SetTextureParameterValue("MainTex",LoadObject(DataMgr.Char[CharId].Icon))
    end

    --设置两个武器的图标
    self.Melee:InitInfo(self.SquadInfo.MeleeWeaponId)
    self.Ranged:InitInfo(self.SquadInfo.RangedWeaponId)
end

function WBP_SquadListItem_C:HideOrShowItemUIInfo(bShow)
    if bShow then
        self.Pattern:SetVisibility(ESlateVisibility.Visible)
        self.BG:SetVisibility(ESlateVisibility.Visible)
        self.Frame_Black:SetVisibility(ESlateVisibility.Visible)
        self.Panel_Normal:SetVisibility(ESlateVisibility.Visible)
        self.Avatar:SetVisibility(ESlateVisibility.Visible)
        if self.Owner then
            local AllWidgets = self.Panel_Normal:GetAllChildren():ToTable() -- 拿不到儿子的儿子
            for key, value in pairs(AllWidgets) do
                if value:GetName() == "Arrow_Up" or value:GetName() == "Arrow_Down" or value:GetName() == "Icon_Warning" or value:GetName() == "Panel_Selected" then

                else
                    value:SetVisibility(ESlateVisibility.Visible)
                end
            end
        end
    else
        self.Pattern:SetVisibility(ESlateVisibility.Collapsed)
        self.BG:SetVisibility(ESlateVisibility.Collapsed)
        self.Frame_Black:SetVisibility(ESlateVisibility.Collapsed)
        self.Panel_Normal:SetVisibility(ESlateVisibility.Collapsed)
    end
    self:PlayAnimation(self.Normal)
end

function WBP_SquadListItem_C:CheckSortIcon()
    self.IsNeedSort = (self.Index == self.Owner.CurSelectSquadIndex and self.Owner.SquadListLen > 1)
    if self.IsNeedSort then
        self.Icon_Sort:SetRenderOpacity(1)
        self.Icon_Sort:SetVisibility(ESlateVisibility.Visible)
    else
        self.Icon_Sort:SetRenderOpacity(0)
        self.Icon_Sort:SetVisibility(ESlateVisibility.Collapsed)
    end
end

--循环播放上箭头动画
function WBP_SquadListItem_C:PlayUpArrowAnimation()
    self.Arrow_Up:SetVisibility(ESlateVisibility.Visible)
    --self:PlayAnimation(self.UpArrow_InOut)
end

--循环播放下箭头动画
function WBP_SquadListItem_C:PlayDownArrowAnimation()
    self.Arrow_Down:SetVisibility(ESlateVisibility.Visible)
    --self:PlayAnimation(self.DownArrow_InOut)
end

--只显示上箭头
function WBP_SquadListItem_C:OnlyShowUpArrow()
    self.Arrow_Up:SetVisibility(ESlateVisibility.Visible)
    self.Arrow_Down:SetVisibility(ESlateVisibility.Collapsed)
end

--只显示下箭头
function WBP_SquadListItem_C:OnlyShowDownArrow()
    self.Arrow_Up:SetVisibility(ESlateVisibility.Collapsed)
    self.Arrow_Down:SetVisibility(ESlateVisibility.Visible)
end

--显示上下箭头
function WBP_SquadListItem_C:ShowAllArrow()
    self.Arrow_Down:SetVisibility(ESlateVisibility.Visible)
    self.Arrow_Up:SetVisibility(ESlateVisibility.Visible)
end

--不显示箭头
function WBP_SquadListItem_C:HideAllArrow()
    self.Arrow_Down:SetVisibility(ESlateVisibility.Collapsed)
    self.Arrow_Up:SetVisibility(ESlateVisibility.Collapsed)
end

--region 按钮点击相关
function WBP_SquadListItem_C:InitBtn()
    if self.IsAddSquad then
        self.Btn_Add.OnClicked:Clear()
        self.Btn_Add.OnPressed:Clear()
        self.Btn_Add.OnHovered:Clear()
        self.Btn_Add.OnUnhovered:Clear()

        self.Btn_Add.OnClicked:Add(self, self.OnBtnAddClicked)
        self.Btn_Add.OnPressed:Add(self, self.OnBtnAddPressed)
        self.Btn_Add.OnHovered:Add(self, self.OnBtnAddHovered)
        self.Btn_Add.OnUnhovered:Add(self, self.OnBtnAddUnhovered)
        self:PlayAnimation(self.Add_Normal)
    else
        -- self.Btn_Click.OnClicked:Add(self, function() self:OnBtnClickClicked() end)
        -- self.Btn_Click.OnPressed:Add(self, function() self:OnBtnClickPressed() end)
        -- self.Btn_Click.OnHovered:Add(self, function() self:OnBtnClickHovered() end)
        -- self.Btn_Click.OnUnhovered:Add(self, function() self:OnBtnClickUnhovered() end)
        -- self:PlayAnimation(self.Normal)
    end
end



--向上移动item的位置
function WBP_SquadListItem_C:MoveUp()
    local NowIndex = self.Index - self.FakeIndex
    if NowIndex >= 0 then
        self:PlayAnimation(self["Offset_Up_"..NowIndex])
        DebugPrint("MoveUp: Offset_Up_   ", NowIndex, self.FakeIndex, self.Index, self.SquadInfo.CharId)
    else
        NowIndex = math.abs(NowIndex) - 1
        self:PlayAnimation(self["Offset_Down_"..NowIndex], 0, 1, EUMGSequencePlayMode.Reverse)
        DebugPrint("MoveUp:   Offset_Down_    ", NowIndex, self.FakeIndex, self.Index, self.SquadInfo.CharId)
    end
end

--向下移动item的位置
function WBP_SquadListItem_C:MoveDown()
    local NowIndex = self.Index - self.FakeIndex
    if NowIndex <= 0 then
        NowIndex = math.abs(NowIndex)
        self:PlayAnimation(self["Offset_Down_"..NowIndex])
        DebugPrint("MoveDown: Offset_Down_", NowIndex, self.FakeIndex, self.Index, self.SquadInfo.CharId)
    else
        NowIndex = NowIndex - 1
        self:PlayAnimation(self["Offset_Up_"..NowIndex], 0, 1, EUMGSequencePlayMode.Reverse)
        DebugPrint("MoveDown: Offset_Up_   ", NowIndex, self.FakeIndex, self.Index, self.SquadInfo.CharId)
    end
end

-------------------------增加按钮事件Start-------------------------------------
function WBP_SquadListItem_C:OnBtnAddClicked()
    self:PlayAnimation(self.Add_Click)
    if self.ClickCallback then
        AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_large", nil, nil)
        self.ClickCallback(self.Owner)
    end
end
function WBP_SquadListItem_C:OnBtnAddPressed()
    self:PlayAnimation(self.Add_Press)
end
function WBP_SquadListItem_C:OnBtnAddHovered()
    self:PlayAnimation(self.Add_Hover)
end
function WBP_SquadListItem_C:OnBtnAddUnhovered()
    self:PlayAnimation(self.Add_UnHover)
end
--------------------------增加按钮事件End------------------------------------


----------------------------点击按钮事件Start（暂时不用）-------------------------------------
-- function WBP_SquadListItem_C:OnBtnClickClicked()
--     -- self:PlayAnimation(self.Click)
--     -- if self.ClickCallback then
--     --     self.ClickCallback(self.Owner, self.Index)
--     -- end
-- end
-- function WBP_SquadListItem_C:OnBtnClickPressed()
--     --self:PlayAnimation(self.Press)
-- end
-- function WBP_SquadListItem_C:OnBtnClickHovered()
--     --self:PlayAnimation(self.Hover)
-- end
-- function WBP_SquadListItem_C:OnBtnClickUnhovered()
--     --self:PlayAnimation(self.UnHover)
-- end
------------------------------点击按钮事件End---------------------------------------
--endregion

--------------------------------鼠标点击相关start----------------------------------------

--region 由于要做拖拽功能，点击交互的逻辑需要自己写..电脑
function WBP_SquadListItem_C:OnMouseButtonDown(MyGeometry, MouseEvent)
    if self.Owner.CurInputDeviceType == ECommonInputType.Touch then
        return Handled
    end
    self.bClickBegin = true
    if not self.IsAddSquad then
        AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_large", nil, nil)
    end

    if self.Owner.CurSelectSquadIndex ~= self.Index then
        self:PlayAnimation(self.Press)
    end

    --只有需要排序和选中队伍时才会有拖拽功能
    if self.IsNeedSort and self.Owner.CurSelectSquadIndex == self.Index then
        self.IsPressingItem = true
        self.StartDrag = false
        self.StartDragCountDown = self.StartDragTime
        self:AddTimer(0.1, function()
            if not self.IsPressingItem then
                DebugPrint("OnDragDetected fail")
                self:RemoveTimer("DragDelay")
                return UnHandled
            end
            self.StartDragCountDown = math.max(self.StartDragCountDown - 0.1, 0)
            if self.StartDragCountDown <= 0 then
                self.StartDrag = true
                self:CheckArrowState()--箭头显示提示玩家可以移动
                self:RemoveTimer("DragDelay")
            end
        end, true, 0, "DragDelay", true)
    end

    local LocalHandle = UE.UWidgetBlueprintLibrary.DetectDragIfPressed(MouseEvent, self, UE.EKeys.LeftMouseButton)
    return UE4.UWidgetBlueprintLibrary.CaptureMouse(LocalHandle,self) 
end

function WBP_SquadListItem_C:OnMouseButtonUp(MyGeometry, MouseEvent)
    if self.Owner.CurInputDeviceType == ECommonInputType.Touch then
        return Handled
    end
    self.Owner:GetSquadWidgetInSquadList(self.Owner.CurSelectSquadIndex):HideAllArrow()
    --self.bClickBegin 为false表示之前点击下去时不在这个item上
    if not self.bClickBegin then return Handled end
    --表示改item点击结束
    self.bClickBegin = false
    if self.Owner.CurSelectSquadIndex ~= self.Index then
        self.Owner:SelectCurSquadInSquadList(self.Index)
    end
    self.Owner.IsNeedPlayRefresh = true
    self.IsPressingItem = false

    return Handled
end

function WBP_SquadListItem_C:OnMouseMove(MyGeometry, MouseEvent)
    if self.Owner.IsDraging then
        --self:SetCursor(EMouseCursor.GrabHandClosed)
    end
    if self.Owner.CurInputDeviceType == ECommonInputType.Touch then
        if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
            return Handled
        else
            return UnHandled
        end
    end
    local Reply = UE4.UWidgetBlueprintLibrary.DetectDragIfPressed(MouseEvent, self, EKeys.LeftMouseButton)
    return UE4.UWidgetBlueprintLibrary.ReleaseMouseCapture(Reply)
end

function WBP_SquadListItem_C:OnMouseEnter(MyGeometry, InKeyEvent)
    if self.Owner.IsDraging then
        return
    end
    if self.Owner.CurInputDeviceType == ECommonInputType.Touch then
        return Handled
    end
    if not self.IsSelect and Platform == "PC" then
        self:PlayAnimation(self.Hover)
    end
end

function WBP_SquadListItem_C:OnMouseLeave(MyGeometry, InKeyEvent)
    if self.Owner.IsDraging then
        --self:SetCursor(EMouseCursor.GrabHandClosed)
    end
    if self.Owner.CurInputDeviceType == ECommonInputType.Touch then
        return Handled
    end

    self.IsPressingItem = false
    if not self.IsSelect and Platform == "PC" then
        self:PlayAnimation(self.UnHover)
    else
        self:PlayAnimation(self.Select)
    end
end
--endregion

--region 由于要做拖拽功能，点击交互的逻辑需要自己写..手机触摸
function WBP_SquadListItem_C:OnTouchStarted(MyGeometry, InTouchEvent)
    DebugPrint("WBP_SquadListItem_C:OnTouchStarted")
    local LocalHandle = UE.UWidgetBlueprintLibrary.DetectDragIfPressed(InTouchEvent, self, UE.FKey("Touch"))
    self.bClickBegin = true
    if self.Owner.CurSelectSquadIndex ~= self.Index then
        --self:PlayAnimation(self.Press)
    end

    --只有需要排序和选中队伍时才会有拖拽功能
    if self.IsNeedSort and self.Owner.CurSelectSquadIndex == self.Index then
        self.IsPressingItem = true
        self.StartDrag = false
        self.StartDragCountDown = self.StartDragTime
        self:AddTimer(0.1, function()
            if not self.IsPressingItem then
                DebugPrint("OnDragDetected fail")
                self:RemoveTimer("DragDelay")
                return
            end
            DebugPrint("self.StartDragCountDown ", self.StartDragCountDown)
            self.StartDragCountDown = math.max(self.StartDragCountDown - 0.1, 0)
            if self.StartDragCountDown <= 0 then
                if self.Owner.IsTouchMoving then
                    self:RemoveTimer("DragDelay")
                    return
                end
                self.StartDrag = true
                DebugPrint("self.StartDragCountDown 0")
                self:CheckArrowState()--箭头显示提示玩家可以移动
                self:RemoveTimer("DragDelay")
            end
        end, true, 0, "DragDelay", true)
    end

    return LocalHandle
end



function WBP_SquadListItem_C:OnTouchMoved(MyGeometry, InTouchEvent)
    local MousePos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(PointerEvent)
    if not self.Owner.PreMousPos then
        self.Owner.PreMousPos = MousePos
    end
    local Distance = UKismetMathLibrary.Vector_Distance2D(FVector(self.Owner.PreMousPos.X, self.Owner.PreMousPos.Y, 0), FVector(MousePos.X, MousePos.Y, 0))
    if Distance > 10 then
        self.Owner.IsTouchMoving = true
    else
        self.Owner.IsTouchMoving = false
    end
    self.Owner.PreMousPos = MousePos
    return UnHandled
end

function WBP_SquadListItem_C:OnTouchEnded(MyGeometry, InTouchEvent)
    DebugPrint("OnTouchEnded")
    self.Owner.IsTouchMoving = false
    self.Owner:GetSquadWidgetInSquadList(self.Owner.CurSelectSquadIndex):HideAllArrow()
    --self.Owner:AllSlotPlayAnimation("Normal", self.Owner.CurSelectSquadIndex)
    --self.bClickBegin 为false表示之前点击下去时不在这个item上
    if not self.bClickBegin then return Handled end
    --表示改item点击结束
    self.bClickBegin = false
    if self.Owner.CurSelectSquadIndex ~= self.Index then
        self.Owner:SelectCurSquadInSquadList(self.Index)
    end
    self.IsPressingItem = false

    return Handled
end
--endregion

--region 拖拽相关
function WBP_SquadListItem_C:InitAsDragUI(Owner)
    self.LinkWidgets = {}
    self.ActiveLinkWidgets = {}

    self.Panel_Add:SetVisibility(ESlateVisibility.Collapsed)
    local AllWidgets = Owner.Panel_Normal:GetAllChildren():ToTable() -- 拿不到儿子的儿子
    for key, value in pairs(AllWidgets) do
        value:GetName()
        value:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.SquadInfo = Owner.SquadInfo
    self:InitItem()
    --拖拽时需要显示的假图标
    self:HideOrShowItemUIInfo(true)
    self:PlayAnimation(self.Select)
    self.Melee:PlayAnimation(self.Melee.Click)
    self.Ranged:PlayAnimation(self.Ranged.Click)
    local CharId = Owner.SquadInfo.CharId
    local IconDynaMaterial = self.Icon_Avatar:GetDynamicMaterial()
    if IconDynaMaterial then
        IconDynaMaterial:SetTextureParameterValue("IconMap",LoadObject(DataMgr.Char[CharId].Icon))
    end

    --设置预设阵容名字
    local SquadName = Owner.SquadInfo.Name or GText("Squad_DefaultName1")
    self.Text_Name:SetText(SquadName)

    self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self:SetRenderScale(FVector2D(1, 1))
end

function WBP_SquadListItem_C:CreateDragUI()
    local DragUI = UIManager(self):_CreateWidgetNew("SquadListItem")
    DragUI:InitAsDragUI(self)
    return DragUI
end

function WBP_SquadListItem_C:OnDragDetected(MyGeometry, PointerEvent)
    self.Owner:GetSquadWidgetInSquadList(self.Owner.CurSelectSquadIndex):HideAllArrow()
    if (self.Owner.CurSelectSquadIndex ~= self.Index) or (not self.StartDrag) then
        return
    end
    
    self.bClickBegin = false
    self.Owner.IsDraging = true
    ---@type CommonDragDropOperation_C
    local DragDropOperation = NewObject(UIUtils.GetCommonDragDropOperationClass())
    local DragUI = self:CreateDragUI()
    DragDropOperation.DefaultDragVisual = DragUI
    DragDropOperation.Pivot = UE.EDragPivot.CenterCenter
    DragDropOperation.Index = self.Index
    DragDropOperation.FakeIndex = self.FakeIndex --视觉上Index，不一定与在listview中的Index一致
    DragDropOperation.Tag = "SquadListItem"
    DragDropOperation.Payload = self.Content
    DragDropOperation.Owner = self.Owner

    self:HideOrShowItemUIInfo(false)
    self.Owner:SwitchAddSquadItemVisibility(false)
    return DragDropOperation
end

--拖拽进入
function WBP_SquadListItem_C:OnDragEnter(MyGeometry, PointerEvent, Operation)
    if self.Owner.IsDraging then
        --self:SetCursor(EMouseCursor.GrabHandClosed)
    end
    if not self.IsSelect and Platform == "PC" then
        --self:PlayAnimation(self.Hover)
    end

    --处理箭头显示问题
    if Operation.FakeIndex == 1 then
        Operation.DefaultDragVisual:OnlyShowDownArrow()
        Operation.DefaultDragVisual:PlayDownArrowAnimation()
    elseif Operation.FakeIndex < self.Owner.SquadListLen then
        Operation.DefaultDragVisual:ShowAllArrow()
        Operation.DefaultDragVisual:PlayUpArrowAnimation()
        Operation.DefaultDragVisual:PlayDownArrowAnimation()
    else
        Operation.DefaultDragVisual:OnlyShowUpArrow()
        Operation.DefaultDragVisual:PlayUpArrowAnimation()
    end
    return true
end

--拖拽离开
function WBP_SquadListItem_C:OnDragLeave(PointerEvent, Operation)
    if self.Owner.IsDraging then
        --self:SetCursor(EMouseCursor.GrabHandClosed)
    end
    if not self.IsSelect and Platform == "PC" then
        --self:PlayAnimation(self.UnHover)
    end

    local SquadMainUI = UIManager(self):GetUIObj("SquadMainUINew")
    local ListViewGeo = SquadMainUI.List_Default:GetTickSpaceGeometry()
    local MousePos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(PointerEvent)
    if self.Offset then
        MousePos.X = MousePos.X + self.Offset
    end
    if (not UE4.USlateBlueprintLibrary.IsUnderLocation(ListViewGeo,MousePos)) then
        Operation.DefaultDragVisual:SetVisibility(ESlateVisibility.Collapsed)
        self.Owner.IsDraging = false
        self.StartDrag = false
        self.Owner.IsInSortState = false
        self.Owner.IsOutBound = true
        self:UpdateListView()
        self.Owner:HideOrShowItemInDraging()
        --self:OnDragCancelled(PointerEvent, Operation)
    end
    return true
end

--拖拽取消
function WBP_SquadListItem_C:OnDragCancelled(PointerEvent, Operation)
    self.Owner.IsDraging = false
    self.StartDrag = false
    --放下item 隐藏移到的箭头
    Operation.DefaultDragVisual:HideAllArrow()
    if not self.Owner.IsOutBound then
        self:UpdateListView()
        self.Owner:HideOrShowItemInDraging()
    end
    self.Owner.IsOutBound = false
    self.Owner:SwitchAddSquadItemVisibility(true)
    return true
end

--拖拽投入
function WBP_SquadListItem_C:OnDrop(MyGeometry, PointerEvent, Operation)
    self.Owner.IsDraging = false
    self.StartDrag = false
    --放下item 隐藏移到的箭头
    Operation.DefaultDragVisual:HideAllArrow()
    --self:SetCursor(EMouseCursor.Default)
    self.Owner:HideOrShowItemInDraging()
    self.Owner:SwitchAddSquadItemVisibility(true)
    self:UpdateListView()
    return true
end

--拖拽重合
function WBP_SquadListItem_C:OnDragOver(MyGeometry, PointerEvent, Operation)
    if not self.Owner.IsDraging then
        return true
    end

    local ListView = self.Owner.List_Default
    local MouseDownPos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(PointerEvent)
    local LocalPos = USlateBlueprintLibrary.AbsoluteToLocal(ListView:GetCachedGeometry(), MouseDownPos)

    --计算是否需要滚动偏移
    local ScrollUpCachedGeometry = self.Owner.TriggerScrollUp:GetCachedGeometry()
    local ScrollDownCachedGeometry = self.Owner.TriggerScrollDown:GetCachedGeometry()
    local IsUnderInScrollUp = USlateBlueprintLibrary.IsUnderLocation(ScrollUpCachedGeometry, MouseDownPos)
    local IsUnderInScrollDown = USlateBlueprintLibrary.IsUnderLocation(ScrollDownCachedGeometry, MouseDownPos)
    if IsUnderInScrollUp then
        DebugPrint("thyScroll IsUnderInScrollUp")
        self.Owner:AutoSetScrollBoxOffSet(self.Owner.ScrollBox_0, -120)  
    elseif IsUnderInScrollDown then
        DebugPrint("thyScroll IsUnderInScrollDown")
        self.Owner:AutoSetScrollBoxOffSet(self.Owner.ScrollBox_0, 120)
    end

    --计算滚动偏移
    local ScrollOffset = ListView:GetScrollOffset()
    local YPos = LocalPos.Y + ScrollOffset

    --获取listview的高度
    local ListViewHeight, ItemHeight = self:GetListViewSize(ListView)

    --计算插入索引
    --local OffsetIndex = math.clamp(math.floor(YPos/ItemHeight), 0, self.Owner.SquadListLen - 1) + 1
    local OffsetIndex = math.clamp(math.floor(YPos/ItemHeight), 0, self.Owner.SquadListLen) + 1
    local NewIndex = OffsetIndex
    local DragIndex = Operation.FakeIndex




    --特殊处理（拖拽到第六个位置时，实际位置会比逻辑多1，怀疑是和Scrollbox的滚动item机制有关）
    if NewIndex > 5 then
        NewIndex = NewIndex - 1
    end

    if math.abs(DragIndex - NewIndex) == 1 then
        self:ChangeTwoItemInListView(ListView, DragIndex, NewIndex, Operation)
    end

    --处理拖拽UI的箭头显示问题
    if Operation.FakeIndex == 1 then
        Operation.DefaultDragVisual:OnlyShowDownArrow()
        Operation.DefaultDragVisual:PlayDownArrowAnimation()
    elseif Operation.FakeIndex < Operation.Owner.SquadListLen then
        Operation.DefaultDragVisual:ShowAllArrow()
        Operation.DefaultDragVisual:PlayUpArrowAnimation()
        Operation.DefaultDragVisual:PlayDownArrowAnimation()
    else
        Operation.DefaultDragVisual:OnlyShowUpArrow()
        Operation.DefaultDragVisual:PlayUpArrowAnimation()
    end
    return true
end

--两个listview里item交换位置
function WBP_SquadListItem_C:ChangeTwoItemInListView(ListView, DragIndex, NewIndex, Operation)
    local ListViewItems = ListView:GetListItems()
    NewIndex = math.min(NewIndex, self.Owner.SquadMax)
    --新增按钮不参加排序
    if ListViewItems[NewIndex].IsAddSquad then
        return
    end

    local DragItem = self.Owner:GetSquadContent(DragIndex)
    local NewItem = self.Owner:GetSquadContent(NewIndex)

    if DragItem and NewItem then
        DebugPrint("DragItem", DragItem.FakeIndex, DragItem.SquadInfo.CharId)
        DebugPrint("NewItem", NewItem.FakeIndex, NewItem.SquadInfo.CharId)
        --表现交换位置 不刷新列表
        if DragIndex < NewIndex then
            DragItem:MoveDown()
            NewItem:MoveUp()
        else
            DragItem:MoveUp()
            NewItem:MoveDown()
        end
        DragItem:SetIndex(NewIndex)
        NewItem:SetIndex(DragIndex)
    else
        DebugPrint("DragItem or NewItem is nil", DragItem, NewItem)
    end

    --手柄端不需要拖拽
    if Operation then
        Operation.FakeIndex = NewIndex
    end

    self.Owner.CurSelectSquadIndex = NewIndex

    local Avatar = GWorld:GetAvatar()
    Avatar:SwitchSquad(nil, self, DragIndex, NewIndex)

end

function WBP_SquadListItem_C:UpdateListView()
        self.Owner:PlayAnimation(self.Owner.UpdateList)
        self:AddDelayFrameFunc(
            function()
                --self.Owner.CurSelectSquadIndex = self.FakeIndex
                self.Owner:SwitchToSquadList(false)
            end, 8, "DelayUpdateListView")
end

--获取ListView和其item的高度
function WBP_SquadListItem_C:GetListViewSize(TileView)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local ListSize = UIManager:GetWidgetRenderSize(TileView)
    local Parent = TileView:GetParent()
    if Parent:Cast(UScrollBox) then
        ListSize = UIManager:GetWidgetRenderSize(Parent)
    end
    local ListSizeX,ItemSizeX = ListSize.X,UIManager:GetWidgetRenderSize(self.BG).X
    local ListSizeY,ItemSizeY = ListSize.Y,UIManager:GetWidgetRenderSize(self.BG).Y

    --拖拽限制 计算偏移量
    self.Offset = (ListSizeX - ItemSizeX) / 2
    return ListSizeY, ItemSizeY
end

function WBP_SquadListItem_C:GetItemRenderSizeXY(Item)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    return UIManager:GetWidgetRenderSize(Item).X, UIManager:GetWidgetRenderSize(Item).Y
end
--endregion

-----------------------------------拖拽相关End----------------------------------------

--手柄排序显示箭头用
function WBP_SquadListItem_C:CheckArrowState()
    --处理箭头显示问题
    if self.FakeIndex == 1 then
        self:OnlyShowDownArrow()
        self:PlayDownArrowAnimation()
    elseif self.FakeIndex < self.Owner.SquadListLen then
        self:ShowAllArrow()
        self:PlayUpArrowAnimation()
        self:PlayDownArrowAnimation()
    else
        self:OnlyShowUpArrow()
        self:PlayUpArrowAnimation()
    end
end

function WBP_SquadListItem_C:OnFocusReceived(MyGeometry, InFocusEvent)
    if self.Owner.CurInputDeviceType and self.Owner.CurInputDeviceType == ECommonInputType.Gamepad then
        if self.Owner.IsInSortState then
            self.Owner:FocusOnSquadListInSortState()
            return UnHandled
        else
            self.Owner.IsOnlyPlayAnimation = false
            self.Owner:SelectCurSquad(self.Index)
            if self.IsAddSquad then
                self.Owner.IsAddSquadDefault = true
                self.Owner:InitBottomTab(false, 2)
                self.Owner.FocusInAddSquad = true
                return UnHandled
            else
                self.Owner.FocusInAddSquad = false
                local PreIndex = self.Owner.CurSelectSquadIndex
                self.Owner.CurSelectSquadIndex = self.Index
                self.Owner:GetSquadWidgetInSquadList(PreIndex):CheckSortIcon()
                if self.Owner.IsAddSquadDefault then
                    self.Owner.IsAddSquadDefault = false
                    self.Owner:InitBottomTab(true, 2)
                end
                self:CheckSortIcon()
                return Handled
            end
        end
    end
    return UnHandled
end

return WBP_SquadListItem_C
