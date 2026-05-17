
local InventoryController = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryController")
local InventoryCommonConst = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryCommonConst")

---@type WBP_SoloTreasure_BagItem00_C
local M = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.Common.TimerMgr",
    "BluePrints.Common.DelayFrameComponent"
})

function M:Construct()
    local Slot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self)
    if Slot and IsValid(Slot) then
        Slot:SetAutoSize(true)
    end
end

-- function M:Destruct()

-- end

function M:Init(TreasureData)
    self.TreasureData = TreasureData
    self.TreasureData.Treasure = self
    self.TreasureId = self.TreasureData.TreasureId or self.TreasureId
    if not self.TreasureId then return end
    self.UUid = self.TreasureData.UUid or self.UUid
    local TreasureInfo = DataMgr.ExtractionTreasure[self.TreasureId]
    local Size = FVector2D(1, 1)
    local Shape = TreasureInfo.Shape
    for i, Pos in ipairs(Shape) do
        if i == 1 then
            Size.X = Pos
        elseif i == 2 then
            Size.Y = Pos
        end
    end
    self.Size = Size
    if not self.Size or not self.Size.X or not self.Size.Y then return end
    self.Texture = TreasureInfo.Icon and LoadObject(TreasureInfo.Icon)
    self.TreasureRarity = TreasureInfo.TreasureRarity or self.TreasureRarity
    self.ShowRarity = self.TreasureRarity and DataMgr.ExtractionTreasureRarity[self.TreasureRarity].ShowRarity or false
    self.Direction = TreasureData.Direction or InventoryCommonConst.Direction.Horizontal

    --self.PocketName = self.TreasureData.PocketName or self.PocketName
    --self.Position = self.TreasureData.Position or self.Position
    self.bSearched = not self.TreasureData.bNotSearched
    self.bInRecycleGrid = self.TreasureData.bInRecycleGrid or self.bInRecycleGrid
    self.HoverGrids = {}

    if self.ShowRarity then
        self:SetShowRarity(self.ShowRarity)
    end
    self.bSelected = false
    self:SetSelected(false)

    if self.Texture and IsValid(self.Image_Icon) then
        self.Image_Icon:SetBrushFromTexture(self.Texture, true)
    end

    if self.bInRecycleGrid then
        self.Root:SetWidthOverride(96)
        self.Root:SetHeightOverride(96)
        self.ItemSizeTip:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        self.ItemSizeTip:SetShowSize(self.Size)
    else
        self.Root:SetWidthOverride(self.Size.X * 96)
        self.Root:SetHeightOverride(self.Size.Y * 96)
        self.ItemSizeTip:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    if self.bSearched then
        if self.OverlaySearch then
            self.OverlaySearch:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        self:PlayAnimation(self.Unlock)
    else
        if self.OverlaySearch then
            self.OverlaySearch:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.IdentifyTime = DataMgr.ExtractionTreasureRarity[self.TreasureRarity].IdentifyTime or 1
        end
        self:PlayAnimation(self.Lock)
    end
    local Pivot = FVector2D(0.5 / (self.Size.X / self.Size.Y), 0.5)
    self:SetRenderTransformPivot(Pivot)
    self.ItemDetails_MenuAnchor:SetRenderTransformPivot(Pivot)
    self.ItemDetails_MenuAnchorHoverTip:SetRenderTransformPivot(Pivot)
    if self.TreasureData then
        InventoryController:RequestUpdateView(self.TreasureData)
    end

    self.ItemDetails_MenuAnchor.ParentWidget = self
    self.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self, self.OnItemDetailsMenuOpenChanged)
    self:SetShowBuffLabel(self.TreasureData and self.TreasureData.BuffLabelInfo)
end

function M:SetShowBuffLabel(BuffLabelInfo)
    if BuffLabelInfo and IsValid(self.BuffLable) then
        self.BuffLabelInfo = BuffLabelInfo
        self.BuffLable:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        self.BuffLable.Text_LableNum:SetText(string.format(GText("UI_Extraction_TM_44"), tostring(BuffLabelInfo.Num)))
        self.BuffLable:SetLableType(BuffLabelInfo.Quality - 1)
        -- local Rarity = {
        --     [3] = "Gold",
        --     [2] = "Purple",
        --     [1] = "Blue",
        -- }
        -- self.BuffLable.BG_Lable:SetBrushFromTexture(self.BuffLable["Lable_"..Rarity[BuffLabelInfo.Rarity]])
        -- self.BuffLable.Text_LableNum:SetFont(self.BuffLable["Font_"..Rarity[BuffLabelInfo.Rarity]])
    elseif not BuffLabelInfo and IsValid(self.BuffLable) then
        self.BuffLabelInfo = nil
        self.BuffLable:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:SetShowRarity(Rarity)
    local TextureTable = self.Color_Texture:ToTable()
    local TextureMap = {
        [6] = 7,
        [5] = 5,
        [4] = 3,
        [2] = 1,
    }
    local TargetBgTexture = TextureTable[TextureMap[Rarity]]
    if TargetBgTexture then
        self.Image_Bg:SetBrushFromTexture(TargetBgTexture)
    end
    local TargetSelTexture = TextureTable[TextureMap[Rarity] + 1]
    if TargetSelTexture then
        self.Image_Sel:SetBrushFromTexture(TargetSelTexture)
    end
end

function M:SetSelected(bSelected)
    if bSelected then
        self.Image_Sel:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.bSelected = true
    elseif not bSelected then
        self.Image_Sel:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.bSelected = false
    end
end

function M:UpdateView(UpdateParams)
    -- 回收站物品不更新位置
    if UpdateParams.NewPocketName or UpdateParams.NewPosition then
        self:_UpdateViewPosition(UpdateParams)
    end
    if UpdateParams.bDrag == true then
        self:_UpdateViewOnDrag(UpdateParams)
    elseif UpdateParams.bDrag == false then
        self:_UpdateViewOnDragEnd(UpdateParams)
    end
    
    if UpdateParams.bInRecycleGrid == false and self.bInRecycleGrid then
        self.Root:SetWidthOverride(self.Size.X * 96)
        self.Root:SetHeightOverride(self.Size.Y * 96)
        self.bInRecycleGrid = false
        self.ItemSizeTip:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if UpdateParams.NewDirection then
        self:_UpdateViewDirection(UpdateParams)
    end
    self:SetShowBuffLabel(self.TreasureData and self.TreasureData.BuffLabelInfo)
end

function M:_UpdateViewPosition(UpdateParams)
    local NewPocketName = UpdateParams.NewPocketName
    local NewPosition = UpdateParams.NewPosition
    -- 位置未变时跳过 RemoveFromParent/AddChild，避免触发昂贵的 Slate 布局失效
    if NewPocketName == self.PocketName and NewPosition and self.Position
        and NewPosition.X == self.Position.X and NewPosition.Y == self.Position.Y then
        return
    end
    self.HoverGrids = {}
    local TargetPocketWidget = NewPocketName and InventoryController:GetPocketWidget(NewPocketName)
    local TargetPanel = TargetPocketWidget and TargetPocketWidget.Panel_Item
    self:RemoveFromParent()
    if not TargetPanel or not IsValid(TargetPanel) then
        return
    end
    local PocketData = InventoryController.InventoryModel.Pockets[NewPocketName]
    TargetPanel:AddChild(self)
    self:PlayAnimation(self.Unhover)
    InventoryController:RequestAbandonAdsorption(self)
    local Slot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self)
    local NewAbsPosition = NewPosition * 96.0 + 6
    if UpdateParams.bInRecycleGrid and Slot then
        NewAbsPosition.Y = NewAbsPosition.Y + 6
    end
    
    if Slot then
        Slot:SetPosition(FVector2D(NewAbsPosition.X, NewAbsPosition.Y))
    end
    
    self.PocketName = NewPocketName
    self.Position = NewPosition
    self.NewPocketName = nil
    self.NewPosition = nil
end

function M:_UpdateViewDirection(UpdateParams)
    if not UpdateParams.NewDirection then return end
    if UpdateParams.NewDirection then
        self.Direction = UpdateParams.NewDirection
        UpdateParams.NewDirection = nil
    end
    local Size = self.bInRecycleGrid and FVector2D(1, 1) or self.Size
    if Size.X == Size.Y then
        return
    end
    local Angle = self:GetRenderTransformAngle()
    if self.Direction == InventoryCommonConst.Direction.Vertical and Angle ~= 90 then
        self:SetRenderTransformAngle(90)
        self.ItemDetails_MenuAnchor:SetRenderTransformAngle(-90)
        self.ItemDetails_MenuAnchorHoverTip:SetRenderTransformAngle(-90)
        local Transform = self.BuffLable.RenderTransform
        Transform.Translation.X = Transform.Translation.X - (96 * Size.X - 30)
        Transform.Angle = -90
        self.BuffLable:SetRenderTransform(Transform)
    elseif self.Direction == InventoryCommonConst.Direction.Horizontal and Angle ~= 0 then
        self:SetRenderTransformAngle(0)
        self.ItemDetails_MenuAnchor:SetRenderTransformAngle(0)
        self.ItemDetails_MenuAnchorHoverTip:SetRenderTransformAngle(0)
        local Transform = self.BuffLable.RenderTransform
        Transform.Translation.X = Transform.Translation.X + (96 * Size.X - 30)
        Transform.Angle = 0
        self.BuffLable:SetRenderTransform(Transform)
    end
end

function M:_UpdateViewOnDrag(UpdateParams)
    if self.bDraging then return end
    self.bDraging = true
    -- 设置Image_Icon的透明度为0.3
    self.Image_Icon:SetRenderOpacity(0.3)
    self.Image_Bg:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:_UpdateViewOnDragEnd(UpdateParams)
    self:PlayAnimation(self.Normal)
    if not self.bDraging then return end
    self.bDraging = false
    -- 设置Image_Icon的透明度为1
    self.Image_Icon:SetRenderOpacity(1)
    self.Image_Bg:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end


function M:CreateDragWidget(TreasureData)
    local DragWidget = UIManager(self):CreateWidget(InventoryCommonConst.DefaultDragWidgetPath, false)
    if not DragWidget then return end
    if self.Texture and IsValid(DragWidget.Prop_Icon) then
        DragWidget.Prop_Icon:SetBrushFromTexture(self.Texture, true)
    end
    self.TreasureData.DefaultDragVisual = DragWidget
    self.DefaultDragVisual = DragWidget
    return DragWidget
end

function M:OnItemDetailsMenuOpenChanged(bOpen)
    if bOpen then
        InventoryController.bOpenItemDetails = true
        self.bOpenItemDetails = true
        if UIUtils.IsGamepadInput() and InventoryController.MainWidget and InventoryController.MainWidget.BagSelect_Controller then
            InventoryController.MainWidget.BagSelect_Controller:SetVisibility(ESlateVisibility.Collapsed)
        end
        if InventoryController.MainWidget and InventoryController.MainWidget.UpdateComTab then
            InventoryController.MainWidget.Com_KeyTips:SetVisibility(ESlateVisibility.Collapsed)
            InventoryController.MainWidget:EnterTreasureDetailState(true)
        end
        InventoryController:RequestSelected(self)
        self:RequestShowHoverTip(false)
    else
        InventoryController.bOpenItemDetails = false
        self.bOpenItemDetails = false
        if UIUtils.IsGamepadInput() and InventoryController.MainWidget and InventoryController.MainWidget.BagSelect_Controller then
            InventoryController.MainWidget.BagSelect_Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
        if InventoryController.MainWidget and InventoryController.MainWidget.UpdateComTab then
            InventoryController.MainWidget.Com_KeyTips:SetVisibility(ESlateVisibility.Visible)
            InventoryController.MainWidget:UpdateComTab("Normal")
            InventoryController.MainWidget:EnterTreasureDetailState(false)
        end
        InventoryController:RequestUnSelected(self)
    end
end

function M:OnClicked()
    if not UIUtils.IsGamepadInput() then
        self:PlayAnimation(self.Click)
        self:OpenItemDetailsWidget()
    end
end

function M:OnHovered(Grid)
    if UIUtils.IsGamepadInput() and (not self.HoverGrids or not next(self.HoverGrids)) then
        InventoryController:RequestAdsorption(self, InventoryCommonConst.AdsorptionPriority.HIGH)
        InventoryController:RequestSelected(self)
        if InventoryController.MainWidget and IsValid(InventoryController.MainWidget) then
            if InventoryController.MainWidget.UpdateComTab then
                InventoryController.MainWidget:UpdateComTab("Normal")
            end
        end
    end
    if self.bInRecycleGrid then 
        self:StopAnimation(self.Unhover)
        self:PlayAnimation(self.Hover)
        self:RequestShowHoverTip(true)
        local PocketWidget = InventoryController:GetPocketWidget(Grid.PocketData.Name)
        if PocketWidget.bRecycle then
            if UIUtils.IsGamepadInput() and InventoryController.MainWidget and InventoryController.MainWidget.BagSelect_Controller then
                InventoryController.MainWidget.Btn_Recycle.Scroll_Recycle:ScrollWidgetIntoView(PocketWidget, true, UE4.EDescendantScrollDestination.Center)
                InventoryController.MainWidget.GamepadCursorTargetPosition = InventoryController.MainWidget.BagSelect_Controller.RenderTransform.Translation + 0.1
                InventoryController:RequestForceAdsorption(self)
            end
            self:AddTimer(0.2, function()
                InventoryController:ReleaseForceAdsorption()
            end, false, 0, "ReleaseAdsorption")
        end
        return
    end
    if not next(self.HoverGrids) then
        self:StopAnimation(self.Unhover)
        self:PlayAnimation(self.Hover)
        self:RequestShowHoverTip(true)
    end
    self.HoverGrids[Grid] = true
end

function M:IsHovered()
    local bHovered = false
    if self.HoverGrids and next(self.HoverGrids) then
        bHovered = true
    end
    return bHovered
end

function M:OnUnHovered(Grid)
    if self.bInRecycleGrid then 
        self:StopAnimation(self.Hover)
        self:RequestShowHoverTip(false) --RequestShowHoverTip会自动取消hover态？？？
        self:PlayAnimation(self.Unhover)
        if UIUtils.IsGamepadInput() then
            --self:PlayAnimation(self.Unhover)
            InventoryController:RequestAbandonAdsorption(self, InventoryCommonConst.AdsorptionPriority.HIGH)
            InventoryController:RequestUnSelected(self)
            if InventoryController.MainWidget and IsValid(InventoryController.MainWidget) then
                if InventoryController.MainWidget.UpdateComTab then
                    InventoryController.MainWidget:UpdateComTab("Normal")
                end
            end
        end
        return
    end
    self:AddDelayFrameFunc(function() --因为grid触发，所以OnUnHovered要在OnHovered之后执行
        if not next(self.HoverGrids) then return end
        if Grid and self.HoverGrids[Grid] == true then
            self.HoverGrids[Grid] = nil
        end
        for HoverGrid, bHovered in pairs(self.HoverGrids) do
            if not IsValid(HoverGrid) then
                self.HoverGrids[HoverGrid] = nil
                goto continue
            end
            local GridData = InventoryController:GetGridData(HoverGrid.PocketData.Name, HoverGrid.Position)
            local TreasureItem = (GridData and GridData.TreasureData) and GridData.TreasureData.Treasure or nil
            if bHovered == true and TreasureItem == self then
                return
            else
                self.HoverGrids[HoverGrid] = nil
            end
            ::continue::
        end
        self:StopAnimation(self.Hover)
        self:RequestShowHoverTip(false)
        self:PlayAnimation(self.Unhover)
        if UIUtils.IsGamepadInput() then
            --self:PlayAnimation(self.Unhover)
            InventoryController:RequestAbandonAdsorption(self, InventoryCommonConst.AdsorptionPriority.HIGH)
            InventoryController:RequestUnSelected(self)
            if InventoryController.MainWidget and IsValid(InventoryController.MainWidget) then
                if InventoryController.MainWidget.UpdateComTab and not InventoryController.bDraging then
                    InventoryController.MainWidget:UpdateComTab("Normal")
                end
            end
        end
    end, 2)
end

function M:OnPressed()
    --self:PlayAnimation(self.Press)
    self:CloseItemDetailsWidget()
end

function M:NotifyBeginSearch(SearchEndCallback)
    if UIUtils.IsGamepadInput() then
        -- 开始搜索时强制定位到该物品，搜索是玩家主动触发的明确意图，不允许被误触取消
        InventoryController:RequestAdsorption(self, InventoryCommonConst.AdsorptionPriority.FORCE)
    end
    if self.bSearched or self.bSearching then return end
    self.bSearching = true
    self.bAllowShowHoverTip = false
    self._OnSearchEnd = SearchEndCallback
    if self.OverlaySearch then
        self.OverlaySearch:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    if self.Searching_In then
        self:PlayAnimation(self.Searching_In)
    end
    self:BindToAnimationFinished(self.Searching_In, {self, function()
        self:UnbindAllFromAnimationFinished(self.Searching_In)
        self:PlayAnimation(self.Searching_Loop, 0, 0)
    end})
    self:AddTimer(self.IdentifyTime or 1, function(self)
        if not self or not self.bSearching then return end
        self:StopAnimation(self.Searching_Loop)
        self.bSearching = false
        self.bSearched = true
        local UnlockAnim = {
            [6] = "Unlock_Red",
            [5] = "Unlock_Gold",
            [4] = "Unlock_Purple",
            [2] = "Unlock_Green",
        }
        self:PlayAnimation(self[UnlockAnim[self.ShowRarity]])
        self:BindToAnimationFinished(self[UnlockAnim[self.ShowRarity]], {self, function()
            self:UnbindAllFromAnimationFinished(self[UnlockAnim[self.ShowRarity]])
            if not self.bSearched then return end
            self.bAllowShowHoverTip = true
            -- 若搜索完成时物品仍处于 hover 状态，立即触发显示
            if self:IsHovered() then
                self:RequestShowHoverTip(true)
            end
        end})
        if self._OnSearchEnd then
            self._OnSearchEnd(self)
        end
    end, false, 0, "SearchEnd")
end

function M:CancelSearch()
    if not self.bSearching then return end
    self.bSearching = false
    self:RemoveTimer("SearchStartLoop")
    self:RemoveTimer("SearchEnd")
    if self.Searching_Loop then
        self:StopAnimation(self.Searching_Loop)
    end
    if self.OverlaySearch then
        self.OverlaySearch:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:OpenItemDetailsWidget()
    if self.bSearching or not self.bSearched then return end
    if not self.Content then
        self.Content = {ItemType = "ExtractionTreasure", ItemId = self.TreasureId}
    end
    self.ItemDetails_MenuAnchor.ParentWidget = self
    self.ItemDetails_MenuAnchor:OpenItemDetailsWidget(false, self.Content)
end

function M:CloseItemDetailsWidget()
    self.ItemDetails_MenuAnchor:CloseItemDetailsWidget()
end

function M:RequestShowHoverTip(bShow)
    if bShow then
        if UIUtils.IsMobileInput() or UIUtils.IsGamepadInput() then return end
        if self.bSearching or not self.bSearched or self.bOpenItemDetails then return end
        if not InventoryController or InventoryController.bDraging then return end
        if self.bAllowShowHoverTip == false then return end
        if InventoryController.bOpenItemDetails then return end
        self.bPendingOpenItemDetails = true
        self:AddTimer(0.3, function(_)
            if not IsValid(self) or not self.bPendingOpenItemDetails then return end
            self.ItemDetails_MenuAnchorHoverTip.ParentWidget = self
            if not self.Content then
                self.Content = {ItemType = "ExtractionTreasure", ItemId = self.TreasureId}
            end
            self.ItemDetails_MenuAnchorHoverTip:OpenItemDetailsWidget(false, self.Content)
            self.bRealOpenItemDetails = true
        end, false, 0, "ShowHoverTip")
    else
        self.bPendingOpenItemDetails = false
        if self.bRealOpenItemDetails then
            self.ItemDetails_MenuAnchorHoverTip:CloseItemDetailsWidget()
            self.bRealOpenItemDetails = false
        end
    end
end

return M
