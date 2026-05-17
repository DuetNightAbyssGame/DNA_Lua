--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local BagGameModel = require "BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameModel"
local BagGameController = require "BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameController"
local ActivityUtils = require "BluePrints.UI.WBP.Activity.ActivityUtils"

---@type WBP_Activity_BagGame_Play_C
local M = Class({"BluePrints.UI.BP_UIState_C",})

M._components = {
    "BluePrints.UI.WBP.Activity.Widget.BagGame.WBP_Activity_BagGame_Play_C_GamepadComp",
}

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    M.Super.Construct(self)
    self.Tab.Panel_Top:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Tab.Panel_Bottom:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Overlay_Recycle:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Btn_Refresh.OnClicked:Add(self, self.OnBtnRefreshClicked)
    self.Btn_Finish.OnClicked:Add(self, self.OnBtnFinishClicked)
    self.Btn_Close.OnClicked:Add(self, self.CloseSelf)
    -- 当前未确认的放置物品（放置后还能旋转、删除、重新拉起，未点击确认键）
    self.CurrentUnconfirmedItem = nil
    
    -- 初始化完成按钮为禁用状态
    self:SetFinishButtonEnabled(false)
    self.TextTitle:SetText(GText("Event_Title_103015"))
    self.Text_Title_R:SetText(GText("UI_GameEvent_BagGame_Title_ItemToOrganize"))
    self.Text_Finish:SetText(GText("UI_GameEvent_BagGame_Button_OrganizeFinish"))
    self.Text_Recycle:SetText(GText("UI_GameEvent_BagGame_PutBackItem"))
    self.Text_Target:SetText(GText("UI_BackpackPuzzle_TargetScore"))
    self.Text_AllScore:SetText(GText("UI_GameEvent_BagGame_TotalScore"))

    self:InitListenEvent()
    self:RefreshBaseInfo()
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    -- 退出时清理所有放置状态，防止残留
    self:CleanupPlayState()
    self.Btn_Refresh.OnClicked:Remove(self, self.OnBtnRefreshClicked)
    self.Btn_Finish.OnClicked:Remove(self, self.OnBtnFinishClicked)
    -- 清理 TileView 事件监听
    if self.EMTileView1 and self._OnDisPlayItemSelected then
        self.EMTileView1.BP_OnItemSelectionChanged:Remove(self, self._OnDisPlayItemSelected)
    end
    M.Super.Destruct(self)
end

function M:InitUIInfo(Name, IsInUIMode, EventList, Params)
    self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, Params)
    self.Params = Params
    self.Owner = Params.Owner
    -- 进入关卡时清理残留放置状态（含 Pos_Item 兜底清理）
    self:CleanupPlayState()
    self:InitData(Params)
    self:InitView(Params)

    self:PlayAnimation(self.In)
    self:SetFocus()

    self:InitGamePadKey()
    self:_InitGamepadItemList()
end

function M:InitData(Params)
    self.Content = Params.Content
    -- 使用配表字段名
    self.Id = self.Content.Id
    self.LevelId = self.Content.LevelId
    self.LevelName = self.Content.LevelName
    self.LevelDes = self.Content.LevelDes
    self.TargetScore = self.Content.TargetScore
    self.TargetReward = self.Content.TargetReward
    self.LevelInitialItem = self.Content.LevelInitialItem
    self.GridDistribute = self.Content.GridDistribute
    self.PlayerScore = self.Content.PlayerScore or 0
    
    -- 初始化 Model 游戏状态
    BagGameController:StartGame(self.LevelId)
end

function M:InitView(Params)
    -- 计算最高目标分
    local MaxTargetScore = 0
    if self.TargetScore then
        for i, Score in ipairs(self.TargetScore) do
            self["ScoreItem0"..i].Text_ScoreInfo_Star:SetText(string.format(GText("UI_BackpackPuzzle_Target"..i), Score))
            self["ScoreItem0"..i].Text_ScoreInfo_Empty:SetText(string.format(GText("UI_BackpackPuzzle_Target"..i), Score))
            if Score > MaxTargetScore then
                MaxTargetScore = Score
            end
        end
    end
    -- self.Text_Score = MaxTargetScore
    
    self:UpdateStarCountByScore(self.PlayerScore or 0)
    
    -- 初始化物品（使用 LevelInitialItem）
    self:InitDisPlayItem(self.LevelInitialItem)
    -- 初始化格子（使用 GridDistribute）
    self:InitContainItem(self.GridDistribute)
    self:OnBtnRefreshClicked()
end

--- 根据分数计算并更新星数显示
---@param Score number 分数
---@return number StarCount 星数
function M:UpdateStarCountByScore(Score)
    local StarCount = 0
    if self.TargetScore then
        for _, TargetScore in ipairs(self.TargetScore) do
            if Score >= TargetScore then
                StarCount = StarCount + 1
            end
        end
    end
    self:Set_NumandStart(self.Id, StarCount)
    return StarCount
end
--region 展示区物品
--- 初始化展示区物品（TileView 数据驱动模式）
--- LevelInitialItem: 物品模板ID数组，如 {101, 201, 301}
--- 创建 UObject 数据对象 → AddItem 到 TileView → 存引用到 DisPlayItemDataById
function M:InitDisPlayItem(LevelInitialItem)
    if not LevelInitialItem then return end
    self.EMTileView1:ClearListItems()

    -- 数据对象引用（按唯一实例 ID 索引）
    self.DisPlayItemDataById = {}
    -- 有序列表（供 GamepadComp 使用）
    self.DisPlayItemDataList = {}
    -- 物品总数（用于 CheckAllItemsPlaced，已确认的物品会从 dict 中移除）
    self.TotalDisPlayItemCount = #LevelInitialItem

    -- 统计每个 TemplateId 出现次数，为重复物品生成唯一实例标识
    local InstanceCounter = {}

    for _, TemplateId in ipairs(LevelInitialItem) do
        local ItemData = BagGameModel:BuildItemContent(TemplateId)
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        for Key, Value in pairs(ItemData) do
            Content[Key] = Value
        end
        Content.ShapeOffsets = Content.ItemGrid
            and BagGameModel:ParseItemGrid(Content.ItemGrid)
            or {{0, 0}}
        Content.SwitchIndex = 0
        Content.PlayScreen = self

        -- 生成唯一实例 DisPlayItemId（处理同 TemplateId 的重复物品）
        InstanceCounter[TemplateId] = (InstanceCounter[TemplateId] or 0) + 1
        local InstanceNum = InstanceCounter[TemplateId]
        if InstanceNum == 1 then
            Content.DisPlayItemId = TemplateId
        else
            Content.DisPlayItemId = tostring(TemplateId) .. "#" .. InstanceNum
        end

        self.EMTileView1:AddItem(Content)
        self.DisPlayItemDataById[Content.DisPlayItemId] = Content
        table.insert(self.DisPlayItemDataList, Content)
    end

    self.EMTileView1:RequestFillEmptyContent()
end
--endregion
--- 设置 DisPlayItem 的 Switch_Type 索引（数据驱动：更新数据对象 + 刷新可见 Widget）
---@param DisPlayItemId any DisPlayItem 的 ID
---@param Index number Switch_Type 索引 (0=默认, 1=抓取中, 2=已放置)
function M:SetDisPlayItemSwitchIndex(DisPlayItemId, Index)
    local ContentData = self.DisPlayItemDataById and self.DisPlayItemDataById[DisPlayItemId]
    if not ContentData then return end
    ContentData.SwitchIndex = Index
    -- 尝试刷新可见 Entry Widget
    local DisplayedWidgets = self.EMTileView1:GetDisplayedEntryWidgets()
    if DisplayedWidgets then
        for i = 1, DisplayedWidgets:Length() do
            local Entry = DisplayedWidgets:GetRef(i)
            if Entry and Entry.Content == ContentData and Entry.Switch_Type then
                Entry.Switch_Type:SetActiveWidgetIndex(Index)
                break
            end
        end
    end
end

-- ==================== 未确认物品状态管理 ====================

--- 检查是否有未确认的放置物品（代理到 Model）
---@return boolean 是否有未确认物品
function M:HasUnconfirmedItem()
    return BagGameModel:HasUnconfirmedItem()
end

--- 获取当前未确认的放置物品（代理到 Model）
---@return table|nil 未确认的 PlacedItem Widget
function M:GetUnconfirmedItem()
    return BagGameModel:GetUnconfirmedItem()
end

--- 设置当前未确认的放置物品（同时更新 Model 和 View）
---@param PlacedItem table|nil PlacedItem Widget
function M:SetUnconfirmedItem(PlacedItem)
    BagGameModel:SetUnconfirmedItem(PlacedItem)
    self.CurrentUnconfirmedItem = PlacedItem
end

--- 确认当前放置的物品（点击确认按钮后调用）
---@param PlacedItem table 要确认的 PlacedItem Widget
---@return boolean 是否确认成功
function M:ConfirmPlacedItem(PlacedItem)
    if not PlacedItem then
        return false
    end

    -- 确认前校验：所有格子必须在边界内且处于可放置区（非 UNCLICKABLE/BLOCKED）
    -- CanPlaceShapeAt 允许越界和 UNCLICKABLE，由此处拦截
    local PlacedRecordForCheck = nil
    if self.PlacedItems then
        for _, Record in ipairs(self.PlacedItems) do
            if Record.Widget == PlacedItem then
                PlacedRecordForCheck = Record
                break
            end
        end
    end
    if PlacedRecordForCheck and PlacedRecordForCheck.Cells then
        local GridRows = BagGameModel.GRID_ROWS
        local GridCols = BagGameModel.GRID_COLS
        for _, Cell in ipairs(PlacedRecordForCheck.Cells) do
            local R, C = Cell.Row, Cell.Col
            if R < 1 or R > GridRows or C < 1 or C > GridCols then
                UIManager(self):ShowUITip(UIConst.Tip_CommonTop, "UI_GameEvent_BagGame_Toast_CannotPutDown")
                return false
            end
            local Value = BagGameModel:GetGridValue(R, C)
            if Value == BagGameModel.VALUE_UNCLICKABLE or Value == BagGameModel.VALUE_BLOCKED then
                UIManager(self):ShowUITip(UIConst.Tip_CommonTop, "UI_GameEvent_BagGame_Toast_CannotPutDown")
                return false
            end
        end
    end

    -- 调用 Controller 确认
    if not BagGameController:ConfirmPlacedItem(PlacedItem) then
        DebugPrint("ConfirmPlacedItem: 该物品不是当前未确认物品")
        return false
    end
    
    -- 同步 View 状态
    self.CurrentUnconfirmedItem = nil
    
    -- UI 更新：隐藏操作按钮（旋转、删除、确认）
    if PlacedItem.PlayAnimation and PlacedItem.Btn_Out then
        PlacedItem:PlayAnimation(PlacedItem.Btn_Out)
    end
    -- Btn_Out 动画仅改变外观（透明度/位置），不改变可见性。
    -- SelfHitTestInvisible 模式下子控件仍接收 hit-test，
    -- 必须显式 Collapse 操作按钮，否则它们会拦截 ContainItem 的 OnDragEnter，导致堆叠/装配检测失败。
    if PlacedItem.Btn_Stop then
        PlacedItem.Btn_Stop:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if PlacedItem.Btn_Rotation then
        PlacedItem.Btn_Rotation:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if PlacedItem.Btn_Check then
        PlacedItem.Btn_Check:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

    -- 设置为不可交互（确认后不能再长按拉起）
    -- 使用 SelfHitTestInvisible 而非 HitTestInvisible：物品本体不响应输入，但子控件（Btn_Recover）仍可点击
    PlacedItem.bIsConfirmed = true
    PlacedItem:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)

    -- 确认格子动效：播 Put_Flash；双倍条件下额外播 Double_Loop
    local PlacedRecord = nil
    if self.PlacedItems then
        for _, Record in ipairs(self.PlacedItems) do
            if Record.Widget == PlacedItem then
                PlacedRecord = Record
                break
            end
        end
    end
    if PlacedRecord and PlacedRecord.Cells then
        local bDouble = PlacedRecord.IsDoubleReward
        for _, Cell in ipairs(PlacedRecord.Cells) do
            local ContainItem = self:GetContainItemAt(Cell.Row, Cell.Col)
            if ContainItem then
                ContainItem:PlayPutFlash()
                if bDouble then
                    ContainItem:PlayDoubleLoop()
                end
            end
        end
    end

    -- 保存 ContentData 引用到 PlacedRecord，供 UnconfirmPlacedItem 恢复 TileView 时使用
    if PlacedRecord then
        PlacedRecord.ContentData = self.DisPlayItemDataById and self.DisPlayItemDataById[PlacedItem.DisPlayItemId]
        -- 兜底：堆叠/装配消耗流程可能已清除 DisPlayItemDataById，从 PlacedItem 自身重建 ContentData
        if not PlacedRecord.ContentData and PlacedItem.TemplateId then
            local SyncData = PlacedItem.GetDragSyncData and PlacedItem:GetDragSyncData()
            if SyncData then
                PlacedRecord.ContentData = {
                    TemplateId = SyncData.TemplateId or PlacedItem.TemplateId,
                    ItemId = PlacedItem.ItemId,
                    ItemType = SyncData.ItemType or PlacedItem.ItemType,
                    ItemName = PlacedItem.ItemName,
                    BasicPoint = PlacedItem.BasicPoint,
                    GUIPath = SyncData.GUIPath or PlacedItem.GUIPath,
                    MaxAmmo = SyncData.MaxAmmo or 0,
                    MaxStack = SyncData.MaxStack or 0,
                    CurrentAmmo = SyncData.CurrentAmmo or 0,
                    CurrentStack = SyncData.CurrentStack or 0,
                    ShapeOffsets = PlacedItem.OriginalShapeOffsets or PlacedItem.ShapeOffsets,
                    DisPlayItemId = PlacedItem.DisPlayItemId,
                    PlayScreen = self,
                    SwitchIndex = 2,
                }
            end
        end
    end

    -- 从物品列表中移除已确认的物品
    self:RemoveConfirmedItemFromList(PlacedItem.DisPlayItemId)

    -- 更新完成按钮状态（确认后可能可以结算了）
    self:UpdateFinishButtonState()

    -- 显示恢复按钮（PC 端恢复入口）
    if PlacedItem.ShowRecoverBtn then
        PlacedItem:ShowRecoverBtn()
    end

    -- 加入已确认物品列表（手柄 FOCUS 态使用）
    if not self._ConfirmedPlacedItems then
        self._ConfirmedPlacedItems = {}
    end
    if PlacedRecord then
        table.insert(self._ConfirmedPlacedItems, PlacedRecord)
    end

    DebugPrint("ConfirmPlacedItem: 确认成功，DisPlayItemId=" .. tostring(PlacedItem.DisPlayItemId))
    return true
end

--- 将已确认放置的物品恢复为未确认放置状态（ConfirmPlacedItem 的逆操作）
--- 物品保留在格子中，变回可旋转/移动状态；TileView 恢复该物品显示（SwitchIndex=1）
---@param PlacedItem table 要恢复的 DragUIItem Widget
---@return boolean 是否恢复成功
function M:UnconfirmPlacedItem(PlacedItem)
    if not PlacedItem then return false end

    -- 前置检查：已有未确认物品时不允许再恢复（同时只能操作一个物品）
    if self:HasUnconfirmedItem() then
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, "UI_GameEvent_BagGame_Toast_HasUnconfirmed")
        return false
    end

    -- 查找放置记录
    local PlacedRecord = nil
    if self.PlacedItems then
        for _, Record in ipairs(self.PlacedItems) do
            if Record.Widget == PlacedItem then
                PlacedRecord = Record
                break
            end
        end
    end
    if not PlacedRecord then
        DebugPrint("UnconfirmPlacedItem: 未找到放置记录")
        return false
    end

    -- 1. 恢复 bIsConfirmed 标记
    PlacedItem.bIsConfirmed = false

    -- 2. 恢复可见性（SelfHitTestInvisible：物品本体不响应鼠标，但子控件仍可交互）
    PlacedItem:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)

    -- 3. 恢复操作按钮：先恢复可见性（ConfirmPlacedItem 中设为 Collapsed），再播入场动画
    if PlacedItem.Btn_Stop then
        PlacedItem.Btn_Stop:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    if PlacedItem.Btn_Rotation then
        PlacedItem.Btn_Rotation:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    if PlacedItem.Btn_Check then
        PlacedItem.Btn_Check:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    if PlacedItem.Btn_In and PlacedItem.PlayAnimation then
        PlacedItem:PlayAnimation(PlacedItem.Btn_In)
    end

    -- 4. 隐藏恢复按钮（它仅在确认后显示）
    if PlacedItem.HideRecoverBtn then
        PlacedItem:HideRecoverBtn()
    end

    -- 5. 恢复格子动效：停 Put_Flash/Double_Loop → 播 Put_Normal 或 Put_GetPoint
    if PlacedRecord.Cells then
        local bDouble = PlacedRecord.IsDoubleReward
        for _, Cell in ipairs(PlacedRecord.Cells) do
            local ContainItem = self:GetContainItemAt(Cell.Row, Cell.Col)
            if ContainItem then
                ContainItem:StopAllHighlightAnimations()
                if bDouble then
                    ContainItem:PlayPutGetPoint()
                else
                    ContainItem:PlayPutNormal()
                end
            end
        end
    end

    -- 6. 恢复 TileView：以 SwitchIndex=1（抓取中）重新加入列表
    --    ContentData 在 ConfirmPlacedItem 时保存到 PlacedRecord.ContentData
    local ContentData = PlacedRecord.ContentData
    if ContentData then
        ContentData.SwitchIndex = 1
        local DisPlayItemId = PlacedItem.DisPlayItemId
        self.DisPlayItemDataById = self.DisPlayItemDataById or {}
        self.DisPlayItemDataById[DisPlayItemId] = ContentData
        self.DisPlayItemDataList = self.DisPlayItemDataList or {}
        table.insert(self.DisPlayItemDataList, ContentData)
        if self.EMTileView1 then
            self.EMTileView1:AddItem(ContentData)
        end
    end

    -- 7. 标记为当前未确认物品
    self:SetUnconfirmedItem(PlacedItem)

    -- 8. 从已确认列表中移除
    if self._ConfirmedPlacedItems then
        for i, Record in ipairs(self._ConfirmedPlacedItems) do
            if Record == PlacedRecord then
                table.remove(self._ConfirmedPlacedItems, i)
                break
            end
        end
    end

    -- 9. 更新完成按钮状态
    self:UpdateFinishButtonState()

    DebugPrint("UnconfirmPlacedItem: 恢复成功，DisPlayItemId=" .. tostring(PlacedItem.DisPlayItemId))
    return true
end

--- 从 TileView 物品列表中移除已确认放置的物品
---@param DisPlayItemId number 物品模板ID
function M:RemoveConfirmedItemFromList(DisPlayItemId)
    local ContentData = self.DisPlayItemDataById and self.DisPlayItemDataById[DisPlayItemId]
    if not ContentData then return end

    self.EMTileView1:RemoveItem(ContentData)
    self.DisPlayItemDataById[DisPlayItemId] = nil

    if self.DisPlayItemDataList then
        for i, Data in ipairs(self.DisPlayItemDataList) do
            if Data == ContentData then
                table.remove(self.DisPlayItemDataList, i)
                break
            end
        end
    end
end

--- 拖拽拉起已放置的物品（由 DragUIItem.OnDragDetected 调用）
--- 只清理放置状态和格子占用，不移除 Widget（由 OnDragDetected 在创建拖拽后移除）
---@param PlacedItem table 要拉起的 PlacedItem Widget
---@return boolean 是否拉起成功
function M:PickUpPlacedItem(PlacedItem)
    if not PlacedItem then
        return false
    end
    
    -- 查找放置记录
    local PlacedRecord = nil
    local RecordIndex = nil
    if self.PlacedItems then
        for i, Record in ipairs(self.PlacedItems) do
            if Record.Widget == PlacedItem then
                PlacedRecord = Record
                RecordIndex = i
                break
            end
        end
    end
    
    if not PlacedRecord then
        DebugPrint("PickUpPlacedItem: 未找到放置记录")
        return false
    end

    -- 保存放置态的实时数量，供再次拉起时同步到新拖拽体
    if PlacedItem then
        PlacedItem.DragSyncData = {
            ItemType = PlacedRecord.ItemType,
            GUIPath = PlacedItem.GUIPath,
            CurrentAmmo = PlacedRecord.CurrentAmmo or 0,
            MaxAmmo = PlacedRecord.MaxAmmo or 0,
            CurrentStack = PlacedRecord.CurrentStack or 0,
            MaxStack = PlacedRecord.MaxStack or 0,
        }
    end
    
    -- 清除占用的格子（数据 + UI）
    if PlacedRecord.Cells then
        for _, Cell in ipairs(PlacedRecord.Cells) do
            self:ClearCellOccupied(Cell.Row, Cell.Col)
        end
    end
    
    -- 同步移除 Model 中的放置记录（必须在移除 View 记录之前，用 Widget 查找 Model 索引）
    local _, ModelIndex = BagGameModel:FindPlacedItemByWidget(PlacedItem)
    if ModelIndex then
        BagGameModel:RemovePlacedItem(ModelIndex)
    end
    
    -- 从 View 列表中移除记录
    table.remove(self.PlacedItems, RecordIndex)

    -- 刷新剩余已放置物品的双倍积分状态
    self:RefreshPlacedItemDoubleState()
    
    -- 同步未确认状态
    if self:GetUnconfirmedItem() == PlacedItem then
        self:SetUnconfirmedItem(nil)
    end
    
    -- UI 更新：恢复源 DisPlayItem 的 Switch_Type 索引为 1（抓取中）
    self:SetDisPlayItemSwitchIndex(PlacedRecord.DisPlayItemId, 1)
    
    -- 更新分数显示（取消放置应扣除分数）
    self:UpdateScoreDisplay()
    
    -- 更新完成按钮状态
    self:UpdateFinishButtonState()
    
    -- 注意：不在此处 RemoveFromParent，由 OnDragDetected 在创建完拖拽后再移除
    
    DebugPrint("PickUpPlacedItem: 拉起成功，DisPlayItemId=" .. tostring(PlacedRecord.DisPlayItemId))
    return true
end

--- 刷新所有已放置物品的双倍积分显示状态
function M:RefreshPlacedItemDoubleState()
    if not self.PlacedItems then
        return
    end

    for _, PlacedRecord in ipairs(self.PlacedItems) do
        if PlacedRecord and PlacedRecord.Widget and PlacedRecord.Widget.SetDoubleRewardState then
            local bIsDoubleReward = BagGameModel:IsItemAllOnDoubleReward(PlacedRecord)
            PlacedRecord.IsDoubleReward = bIsDoubleReward
            PlacedRecord.Widget:SetDoubleRewardState(bIsDoubleReward)
        end
    end
end

--- 已放置物品旋转后重新挂载（由 DragUIItem:OnRotationBtnClicked 调用）
--- 清旧占用 → 算新锚点 → 边界钳制 → 重挂载 → 标新占用
---@param PlacedItem table 已放置的 DragUIItem Widget（旋转已在其内部完成）
function M:RotatePlacedItem(PlacedItem)
    if not PlacedItem or not self.PlacedItems then
        return
    end
    local GridRows = BagGameModel.GRID_ROWS or 0
    local GridCols = BagGameModel.GRID_COLS or 0
    if GridRows <= 0 or GridCols <= 0 then
        return
    end

    local PlacedRecord = nil
    for _, Record in ipairs(self.PlacedItems) do
        if Record.Widget == PlacedItem then
            PlacedRecord = Record
            break
        end
    end
    if not PlacedRecord or not PlacedRecord.Cells or #PlacedRecord.Cells == 0 then
        return
    end

    local NewRotCount = PlacedItem.RotationCount or 0
    local OldRotCount = (NewRotCount - 1 + 4) % 4

    local OldTopLeftRow = PlacedRecord.Cells[1].Row
    local OldTopLeftCol = PlacedRecord.Cells[1].Col
    for _, Cell in ipairs(PlacedRecord.Cells) do
        if Cell.Row < OldTopLeftRow then OldTopLeftRow = Cell.Row end
        if Cell.Col < OldTopLeftCol then OldTopLeftCol = Cell.Col end
    end

    local OldAlignRS, OldAlignCS = PlacedItem:GetAlignShift(OldRotCount)
    local FrameRow = OldTopLeftRow - OldAlignRS
    local FrameCol = OldTopLeftCol - OldAlignCS

    local NewAlignRS, NewAlignCS = PlacedItem:GetAlignShift(NewRotCount)
    local CurRows, CurCols
    if NewRotCount % 2 == 1 then
        CurRows = PlacedItem.OriginalCols or 1
        CurCols = PlacedItem.OriginalRows or 1
    else
        CurRows = PlacedItem.OriginalRows or 1
        CurCols = PlacedItem.OriginalCols or 1
    end

    local NewTopRow = math.max(1, math.min(FrameRow + NewAlignRS, GridRows - CurRows + 1))
    local NewTopCol = math.max(1, math.min(FrameCol + NewAlignCS, GridCols - CurCols + 1))

    local NewCells = {}
    for _, Off in ipairs(PlacedItem.ShapeOffsets) do
        table.insert(NewCells, {
            Row = NewTopRow + (Off[1] - NewAlignRS),
            Col = NewTopCol + (Off[2] - NewAlignCS),
        })
    end

    local OldCells = PlacedRecord.Cells
    for _, Cell in ipairs(OldCells) do
        self:ClearCellOccupied(Cell.Row, Cell.Col)
    end

    -- 复用 Model 的放置校验（边界 + 格子值 + 占用检测）
    local bCanPlace = BagGameModel:CanPlaceShapeAt(nil, nil, NewCells)

    if not bCanPlace then
        for _, Cell in ipairs(OldCells) do
            self:MarkCellOccupied(Cell.Row, Cell.Col, PlacedItem)
        end
        PlacedItem.RotationCount = OldRotCount
        PlacedItem.ShapeOffsets = PlacedItem:CalculateRotatedOffsets(OldRotCount)
        PlacedItem:UpdateVisualRotation()
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, "UI_GameEvent_BagGame_Toast_CannotRotate")
        return
    end

    PlacedItem:RemoveFromParent()

    local NewTopLeftCell = self:GetContainItemAt(NewTopRow, NewTopCol)
    if not NewTopLeftCell then
        for _, Cell in ipairs(OldCells) do
            self:MarkCellOccupied(Cell.Row, Cell.Col, PlacedItem)
        end
        PlacedItem.RotationCount = OldRotCount
        PlacedItem.ShapeOffsets = PlacedItem:CalculateRotatedOffsets(OldRotCount)
        PlacedItem:UpdateVisualRotation()
        return
    end

    -- 旋转重挂载：不播放入场动画
    self:MountItemToCell(PlacedItem, NewTopLeftCell, false)

    if PlacedItem.SetItemSize then
        PlacedItem:SetItemSize()
    end

    for _, Cell in ipairs(NewCells) do
        self:MarkCellOccupied(Cell.Row, Cell.Col, PlacedItem)
    end

    PlacedRecord.Cells = NewCells
    PlacedRecord.BaseRow = NewTopRow
    PlacedRecord.BaseCol = NewTopCol

    -- 清空旧格子动效
    for _, C in ipairs(OldCells) do
        local ContainItem = self:GetContainItemAt(C.Row, C.Col)
        if ContainItem and ContainItem.DeactivateHighlight then
            ContainItem:DeactivateHighlight()
        end
    end

    self:RefreshPlacedItemDoubleState()
    self:UpdateScoreDisplay()

    -- 播放新格子动效
    local bDouble = PlacedRecord.IsDoubleReward
    for _, C in ipairs(NewCells) do
        local ContainItem = self:GetContainItemAt(C.Row, C.Col)
        if ContainItem then
            if bDouble then
                ContainItem:PlayPutGetPoint()
            else
                ContainItem:PlayPutNormal()
            end
        end
    end

    DebugPrint(string.format("RotatePlacedItem: 旋转到 %d°, 新锚点(%d,%d)", NewRotCount * 90, NewTopRow, NewTopCol))
end

--- 显示无法抓取的提示（当有未确认物品时）
function M:ShowCannotDragToast()
    UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, "UI_GameEvent_BagGame_Toast_PutDownItem")
end

-- ==================== 抓取状态动画管理 ====================

--- 抓取状态变化回调（由 DisPlayItem 的拖拽回调调用）
---@param bIsDragging boolean true=进入抓取状态, false=退出抓取状态
function M:OnDragStateChanged(bIsDragging)
    if bIsDragging then
        -- 进入抓取状态：播放 recycle_in 动画
        if self.Recycle_In then
            self:StopAnimation(self.Recycle_Out)
            self:PlayAnimation(self.Recycle_In)
        end
        self.bIsDraggingItem = true
        -- 拖拽开始：禁用所有已确认物品的 Btn_Recover（避免阻挡 ContainItem 感知）
        self:SetAllConfirmedItemRecoverBtnHitTest(false)
        DebugPrint("抓取状态: 进入，播放 Recycle_In")
    else
        -- 退出抓取状态：播放 recycle_out 动画
        if self.Recycle_Out then
            self:StopAnimation(self.Recycle_In)
            self:PlayAnimation(self.Recycle_Out)
        end
        self.bIsDraggingItem = false
        -- 拖拽结束：恢复所有已确认物品的 Btn_Recover
        self:SetAllConfirmedItemRecoverBtnHitTest(true)
        DebugPrint("抓取状态: 退出，播放 Recycle_Out")
    end
end

--- 控制所有已确认放置物品的 Btn_Recover 的可交互性
--- 拖拽进行中禁用（避免阻挡 ContainItem），拖拽结束后恢复
---@param bEnabled boolean true=可点击, false=HitTestInvisible
function M:SetAllConfirmedItemRecoverBtnHitTest(bEnabled)
    if not self.PlacedItems then return end
    for _, Record in ipairs(self.PlacedItems) do
        local Widget = Record.Widget
        if Widget and Widget.bIsConfirmed and Widget.SetRecoverBtnHitTest then
            Widget:SetRecoverBtnHitTest(bEnabled)
        end
    end
end

-- 使用 Model 中的格子常量
local GRID_ROWS = BagGameModel.GRID_ROWS
local GRID_COLS = BagGameModel.GRID_COLS

--- 获取格子值（代理到 Model）
---@param Row number 行 (1-8)
---@param Col number 列 (1-10)
---@return number|nil 格子值，无效位置返回nil
function M:GetGridValue(Row, Col)
    return BagGameModel:GetGridValue(Row, Col)
end

--- 设置格子值（同时更新 Model 和 UI）
---@param Row number 行 (1-8)
---@param Col number 列 (1-10)
---@param Value number 格子值
function M:SetGridValue(Row, Col, Value)
    -- 更新 Model 数据
    BagGameModel:SetGridValue(Row, Col, Value)
    
    -- 同步更新对应的 ContainItem Widget
    local Index = (Row - 1) * GRID_COLS + Col
    local ContainItem = self.ContainItems and self.ContainItems[Index]
    if ContainItem then
        ContainItem:SetValue(Value)
    end
end

--- 初始化容器区域
--- GridDistribute: 格子分布字符串，格式为 "[0, 0, ...], [1, 1, ...], ..." 或 nil(全空)
function M:InitContainItem(GridDistribute)
    -- 使用 Model 解析格子分布
    self.GridMatrix = BagGameModel:ParseGridDistribute(GridDistribute)
    
    -- 存储所有ContainItem引用（支持索引和行列两种访问方式）
    self.ContainItems = {}           -- 按索引访问: ContainItems[1-80]
    self.ContainItemsByPos = {}      -- 按位置访问: ContainItemsByPos[Row][Col]
    
    -- 初始化位置索引表
    for Row = 1, GRID_ROWS do
        self.ContainItemsByPos[Row] = {}
    end
    
    -- 初始化每个格子Widget
    local TotalCells = GRID_ROWS * GRID_COLS  -- 8 * 10 = 80
    for i = 1, TotalCells do
        local ContainItem = self["PlayItem_" .. i]
        if ContainItem then
            -- 计算行列位置 (1-based)
            local Row = math.ceil(i / GRID_COLS)
            local Col = ((i - 1) % GRID_COLS) + 1
            local Value = self.GridMatrix[Row][Col]
            
            ContainItem:Init(Row, Col, Value)
            ContainItem:SetPlayScreen(self)  -- 设置 PlayScreen 引用
            
            self.ContainItems[i] = ContainItem
            self.ContainItemsByPos[Row][Col] = ContainItem
        end
    end
    
    -- 当前激活的格子列表
    self.ActiveHighlightCells = {}
end

-- ==================== 形状区域激活逻辑 ====================

--- 根据行列获取格子Widget
---@param Row number 行 (1-8)
---@param Col number 列 (1-10)
---@return table|nil ContainItem Widget
function M:GetContainItemAt(Row, Col)
    if Row < 1 or Row > GRID_ROWS or Col < 1 or Col > GRID_COLS then
        return nil
    end
    if self.ContainItemsByPos and self.ContainItemsByPos[Row] then
        return self.ContainItemsByPos[Row][Col]
    end
    return nil
end

---@param BaseRow number 基准行
---@param BaseCol number 基准列
---@param ShapeCells table 形状格子坐标数组
---@return boolean 是否可以放置
function M:CanPlaceShapeAt(BaseRow, BaseCol, ShapeCells)
    return BagGameModel:CanPlaceShapeAt(BaseRow, BaseCol, ShapeCells)
end

--- 激活形状区域高亮
---@param BaseRow number 光标所在的基准格子行
---@param BaseCol number 光标所在的基准格子列
---@param DragUI table DragUIItem 实例
function M:ActivateShapeArea(BaseRow, BaseCol, DragUI)
    -- 先取消之前的激活
    self:DeactivateShapeArea()

    -- 记录当前 hover 格子，用于 OnCellDragLeave 判断
    self.CurrentHoverRow = BaseRow
    self.CurrentHoverCol = BaseCol
    
    if not DragUI or not DragUI.GetShapeCells then
        return
    end
    
    -- 获取形状覆盖的所有格子
    local ShapeCells = DragUI:GetShapeCells(BaseRow, BaseCol)
    
    -- 检查物品类型
    local bIsAmmo = BagGameModel:IsAmmoItem(DragUI.TemplateId)
    local bIsOther = BagGameModel:IsOtherItem(DragUI.TemplateId)
    
    -- 重置装配/堆叠/冲突状态
    self.CurrentOverlappingGun = nil
    self.bCanLoadAmmo = false
    self.bIsAmmoMode = bIsAmmo
    self.CurrentOverlappingOther = nil
    self.bCanStack = false
    self.bIsStackMode = false
    self.bIsConflictMode = false
    self.ConflictOverlappingRecord = nil
    
    -- 子弹模式：检测是否与已放置的武器重叠
    if bIsAmmo then
        local GunRecord, bCanLoad = BagGameModel:FindOverlappingGun(ShapeCells)
        
        if GunRecord then
            -- 与武器重叠，显示装配高亮
            self.CurrentOverlappingGun = GunRecord
            self.bCanLoadAmmo = bCanLoad
            
            -- 高亮武器所占的格子
            for _, Cell in ipairs(GunRecord.Cells) do
                local ContainItem = self:GetContainItemAt(Cell.Row, Cell.Col)
                if ContainItem and ContainItem.ActivateLoadHighlight then
                    ContainItem:ActivateLoadHighlight(bCanLoad)
                    table.insert(self.ActiveHighlightCells, ContainItem)
                end
            end
            
            -- 保存状态
            self.CurrentDragUI = DragUI
            self.CurrentShapeCells = ShapeCells
            self.bCanPlaceCurrent = false  -- 子弹不直接放置
            return
        end
        -- 没有与武器重叠，走正常放置逻辑（子弹也可以单独放置）
    end
    
    -- Other 类型堆叠模式：检测是否与已放置的相同物品重叠
    if bIsOther then
        local OtherRecord, bCanStackItem = BagGameModel:FindOverlappingSameOther(DragUI.TemplateId, ShapeCells)
        
        if OtherRecord then
            -- 与相同物品重叠，显示堆叠高亮
            self.CurrentOverlappingOther = OtherRecord
            self.bCanStack = bCanStackItem
            self.bIsStackMode = true
            
            -- 高亮目标物品所占的格子
            for _, Cell in ipairs(OtherRecord.Cells) do
                local ContainItem = self:GetContainItemAt(Cell.Row, Cell.Col)
                if ContainItem and ContainItem.ActivateStackHighlight then
                    ContainItem:ActivateStackHighlight(bCanStackItem)
                    table.insert(self.ActiveHighlightCells, ContainItem)
                elseif ContainItem and ContainItem.ActivateLoadHighlight then
                    -- 备用：使用装配高亮
                    ContainItem:ActivateLoadHighlight(bCanStackItem)
                    table.insert(self.ActiveHighlightCells, ContainItem)
                end
            end
            
            -- 保存状态
            self.CurrentDragUI = DragUI
            self.CurrentShapeCells = ShapeCells
            self.bCanPlaceCurrent = false  -- 堆叠模式不直接放置
            return
        end
        -- 没有与相同物品重叠，走正常放置逻辑
    end

    -- 类型冲突检测：拖拽物品与已放置物品有格子重叠，但不满足装配/堆叠条件
    local ConflictRecord = BagGameModel:FindOverlappingPlacedItem(ShapeCells)
    if ConflictRecord then
        self.bIsConflictMode = true
        self.ConflictOverlappingRecord = ConflictRecord

        -- 高亮冲突物品的格子，显示 Disable
        for _, Cell in ipairs(ConflictRecord.Cells) do
            local ContainItem = self:GetContainItemAt(Cell.Row, Cell.Col)
            if ContainItem and ContainItem.ActivateHighlight then
                ContainItem:ActivateHighlight(false)
                table.insert(self.ActiveHighlightCells, ContainItem)
            end
        end

        self.CurrentDragUI = DragUI
        self.CurrentShapeCells = ShapeCells
        self.bCanPlaceCurrent = false
        return
    end

    -- 普通模式：检查是否可以放置
    local bCanPlace = self:CanPlaceShapeAt(BaseRow, BaseCol, ShapeCells)
    
    -- 激活所有形状格子
    for _, Cell in ipairs(ShapeCells) do
        local ContainItem = self:GetContainItemAt(Cell.Row, Cell.Col)
        if ContainItem and ContainItem.ActivateHighlight then
            ContainItem:ActivateHighlight(bCanPlace)
            table.insert(self.ActiveHighlightCells, ContainItem)
        end
    end
    
    -- 保存当前状态（用于放置时判断）
    self.CurrentDragUI = DragUI
    self.CurrentShapeCells = ShapeCells
    self.bCanPlaceCurrent = bCanPlace
end

--- 取消形状区域高亮
function M:DeactivateShapeArea()
    -- 取消所有激活的格子
    if self.ActiveHighlightCells then
        for _, ContainItem in ipairs(self.ActiveHighlightCells) do
            if ContainItem and ContainItem.DeactivateHighlight then
                ContainItem:DeactivateHighlight()
            end
        end
    end
    self.ActiveHighlightCells = {}
    self.CurrentDragUI = nil
    self.CurrentShapeCells = nil
    self.bCanPlaceCurrent = false
    -- 清除 hover 追踪
    self.CurrentHoverRow = nil
    self.CurrentHoverCol = nil
    -- 清除装配状态
    self.CurrentOverlappingGun = nil
    self.bCanLoadAmmo = false
    self.bIsAmmoMode = false
    -- 清除堆叠状态
    self.CurrentOverlappingOther = nil
    self.bCanStack = false
    self.bIsStackMode = false
    -- 清除冲突状态
    self.bIsConflictMode = false
    self.ConflictOverlappingRecord = nil
end

--- 检查当前是否可以放置
function M:CanPlaceCurrent()
    return self.bCanPlaceCurrent == true
end

--- 格子 DragLeave 回调（由 ContainItem 调用）
--- 仅当离开的格子仍是当前 hover 格子时才清除高亮，
--- 防止 OnDragEnter(新格子) 先于 OnDragLeave(旧格子) 时误清新高亮
---@param Row number 离开的格子行
---@param Col number 离开的格子列
function M:OnCellDragLeave(Row, Col)
    if self.CurrentHoverRow == Row and self.CurrentHoverCol == Col then
        self:DeactivateShapeArea()
    end
end

--- 获取当前形状覆盖的格子
function M:GetCurrentShapeCells()
    return self.CurrentShapeCells
end

-- ==================== 放置逻辑 ====================
--region 放置逻辑
--- 在指定格子放置 Item（自动吸附）
---@param BaseRow number 鼠标光标所在的格子行
---@param BaseCol number 鼠标光标所在的格子列
---@param DragUI table DragUIItem 实例
---@param Operation table 拖拽操作对象
---@return boolean 是否放置成功
function M:PlaceItemAtCell(BaseRow, BaseCol, DragUI, Operation)
    if not DragUI or not DragUI.GetShapeCells then
        return false
    end
    
    -- 获取形状覆盖的所有格子
    local ShapeCells = DragUI:GetShapeCells(BaseRow, BaseCol)
    if not ShapeCells or #ShapeCells == 0 then
        return false
    end
    
    -- 检查是否为子弹装配模式（优先使用 ActivateShapeArea 预设标志，若标志被 OnDragLeave 清除则实时重检测）
    local bIsAmmo = self.bIsAmmoMode or BagGameModel:IsAmmoItem(DragUI.TemplateId)
    if bIsAmmo then
        local GunRecord = self.CurrentOverlappingGun
        local bCanLoad = self.bCanLoadAmmo
        if not GunRecord then
            -- 标志位被 OnDragLeave 清除，实时重检测
            GunRecord, bCanLoad = BagGameModel:FindOverlappingGun(ShapeCells)
        end
        if GunRecord then
            self.CurrentOverlappingGun = GunRecord
            self.bCanLoadAmmo = bCanLoad
            return self:HandleAmmoLoad(DragUI, Operation)
        end
    end

    -- 检查是否为 Other 类型堆叠模式（同上，实时重检测兜底）
    local bIsOther = self.bIsStackMode or BagGameModel:IsOtherItem(DragUI.TemplateId)
    if bIsOther then
        local OtherRecord = self.CurrentOverlappingOther
        local bCanStack = self.bCanStack
        if not OtherRecord then
            -- 标志位被 OnDragLeave 清除，实时重检测
            OtherRecord, bCanStack = BagGameModel:FindOverlappingSameOther(DragUI.TemplateId, ShapeCells)
        end
        if OtherRecord then
            self.CurrentOverlappingOther = OtherRecord
            self.bCanStack = bCanStack
            return self:HandleOtherStack(DragUI, Operation)
        end
    end

    -- 类型冲突检测（同样实时重检测兜底）
    if self.bIsConflictMode or BagGameModel:FindOverlappingPlacedItem(ShapeCells) then
        DebugPrint("PlaceItemAtCell: 类型冲突，拒绝放置")
        self:DeactivateShapeArea()
        return false
    end

    -- 普通放置模式
    return self:PlaceItemNormal(BaseRow, BaseCol, DragUI, Operation, ShapeCells)
end

--- 处理子弹装配操作
---@param DragUI table DragUIItem 实例
---@param Operation table 拖拽操作对象
---@return boolean 是否装配成功
function M:HandleAmmoLoad(DragUI, Operation)
    local GunRecord = self.CurrentOverlappingGun
    local bCanLoad = self.bCanLoadAmmo
    
    if not GunRecord then
        DebugPrint("HandleAmmoLoad: 没有目标武器")
        self:DeactivateShapeArea()
        return false
    end
    
    if not bCanLoad then
        -- 武器弹药已满，显示提示
        UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, "UI_GameEvent_BagGame_Toast_AmmoFull")
        self:DeactivateShapeArea()
        return false
    end
    
    -- 计算装配结果
    local LoadAmount, Remaining, bSuccess = BagGameModel:CalculateLoadResult(GunRecord, DragUI.TemplateId)
    
    if not bSuccess then
        DebugPrint("HandleAmmoLoad: 装配失败")
        self:DeactivateShapeArea()
        return false
    end
    
    -- 执行装配
    BagGameModel:ExecuteLoadAmmo(GunRecord, LoadAmount)
    
    -- 更新武器 Widget 显示（如果需要）
    if GunRecord.Widget and GunRecord.Widget.UpdateAmmoDisplay then
        GunRecord.Widget:UpdateAmmoDisplay(GunRecord.CurrentAmmo)
    end
    
    -- 处理剩余子弹
    if Remaining > 0 then
        -- 有剩余子弹，更新左侧列表中的子弹数量并恢复可拖拽状态
        self:UpdateAmmoRemaining(DragUI.DisPlayItemId, Remaining)
        self:SetDisPlayItemSwitchIndex(DragUI.DisPlayItemId, 0)  -- 恢复默认状态
        DebugPrint("HandleAmmoLoad: 装配完成，装入=" .. LoadAmount .. "，剩余=" .. Remaining)
    else
        -- 子弹全部装入，设置为已使用状态
        self:SetDisPlayItemSwitchIndex(DragUI.DisPlayItemId, 2)  -- 已放置/已使用
        self:RemoveConfirmedItemFromList(DragUI.DisPlayItemId)
        DebugPrint("HandleAmmoLoad: 装配完成，子弹全部装入=" .. LoadAmount)
    end
    
    -- 清除高亮
    self:DeactivateShapeArea()
    
    -- 更新分数显示（装弹会影响枪械得分）
    self:UpdateScoreDisplay()
    
    -- 更新完成按钮状态
    self:UpdateFinishButtonState()
    
    -- 退出抓取状态，播放 recycle_out 动画
    self:OnDragStateChanged(false)
    
    return true
end

--- 更新左侧列表中子弹的剩余数量（数据驱动）
---@param DisPlayItemId number 子弹模板ID
---@param Remaining number 剩余数量
function M:UpdateAmmoRemaining(DisPlayItemId, Remaining)
    local ContentData = self.DisPlayItemDataById and self.DisPlayItemDataById[DisPlayItemId]
    if not ContentData then return end
    ContentData.CurrentStack = Remaining
    self:RefreshVisibleEntryWidget(DisPlayItemId)
end

--- 处理 Other 类型物品堆叠操作
---@param DragUI table DragUIItem 实例
---@param Operation table 拖拽操作对象
---@return boolean 是否堆叠成功
function M:HandleOtherStack(DragUI, Operation)
    local OtherRecord = self.CurrentOverlappingOther
    local bCanStack = self.bCanStack
    
    if not OtherRecord then
        DebugPrint("HandleOtherStack: 没有目标物品")
        self:DeactivateShapeArea()
        return false
    end
    
    if not bCanStack then
        -- 堆叠已满，显示提示
        UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, "UI_GameEvent_BagGame_Toast_StackFull")
        self:DeactivateShapeArea()
        return false
    end
    
    -- 计算堆叠结果
    local StackAmount, Remaining, bSuccess = BagGameModel:CalculateStackResult(OtherRecord, DragUI.TemplateId)
    
    if not bSuccess then
        DebugPrint("HandleOtherStack: 堆叠失败")
        self:DeactivateShapeArea()
        return false
    end
    
    -- 执行堆叠
    BagGameModel:ExecuteStack(OtherRecord, StackAmount)
    
    -- 更新已放置物品的数量角标显示
    self:UpdatePlacedItemStackDisplay(OtherRecord)
    
    -- 处理剩余物品
    if Remaining > 0 then
        -- 有剩余物品，更新左侧列表中的数量并恢复可拖拽状态
        self:UpdateOtherRemaining(DragUI.DisPlayItemId, Remaining)
        self:SetDisPlayItemSwitchIndex(DragUI.DisPlayItemId, 0)  -- 恢复默认状态
        DebugPrint("HandleOtherStack: 堆叠完成，堆入=" .. StackAmount .. "，剩余=" .. Remaining)
    else
        -- 物品全部堆入，设置为已使用状态
        self:SetDisPlayItemSwitchIndex(DragUI.DisPlayItemId, 2)  -- 已放置/已使用
        self:RemoveConfirmedItemFromList(DragUI.DisPlayItemId)
        DebugPrint("HandleOtherStack: 堆叠完成，物品全部堆入=" .. StackAmount)
    end
    
    -- 清除高亮
    self:DeactivateShapeArea()
    
    -- 更新分数显示（堆叠会影响物品得分）
    self:UpdateScoreDisplay()
    
    -- 更新完成按钮状态
    self:UpdateFinishButtonState()
    
    -- 退出抓取状态，播放 recycle_out 动画
    self:OnDragStateChanged(false)
    
    return true
end

--- 更新左侧列表中 Other 物品的剩余数量（数据驱动）
---@param DisPlayItemId number 物品模板ID
---@param Remaining number 剩余数量
function M:UpdateOtherRemaining(DisPlayItemId, Remaining)
    local ContentData = self.DisPlayItemDataById and self.DisPlayItemDataById[DisPlayItemId]
    if not ContentData then return end
    ContentData.CurrentStack = Remaining
    self:RefreshVisibleEntryWidget(DisPlayItemId)
end

--- 刷新指定 TemplateId 对应的可见 Entry Widget 的显示
---@param DisPlayItemId number 物品模板ID
function M:RefreshVisibleEntryWidget(DisPlayItemId)
    local ContentData = self.DisPlayItemDataById and self.DisPlayItemDataById[DisPlayItemId]
    if not ContentData then return end
    local DisplayedWidgets = self.EMTileView1:GetDisplayedEntryWidgets()
    if not DisplayedWidgets then return end
    for i = 1, DisplayedWidgets:Length() do
        local Entry = DisplayedWidgets:GetRef(i)
        if Entry and Entry.Content == ContentData and Entry.SyncDisplayFromContent then
            Entry:SyncDisplayFromContent()
            break
        end
    end
end

--- 更新已放置物品的堆叠数量显示
---@param PlacedRecord table 放置记录
function M:UpdatePlacedItemStackDisplay(PlacedRecord)
    if not PlacedRecord or not PlacedRecord.Widget then
        return
    end
    
    local Widget = PlacedRecord.Widget
    local CurrentStack = PlacedRecord.CurrentStack or 0
    local ItemContent = BagGameModel:GetPlacedItemContent(PlacedRecord)
    local MaxStack = ItemContent and ItemContent.MaxStack or 0
    
    -- 更新放置的 Widget 上的数量显示
    if Widget.UpdateStackDisplay then
        Widget:UpdateStackDisplay(CurrentStack, MaxStack)
    elseif Widget.SetAmmoNumber then
        Widget:SetAmmoNumber(CurrentStack, MaxStack)
    end
    
    DebugPrint("UpdatePlacedItemStackDisplay: 更新堆叠显示 " .. CurrentStack .. "/" .. MaxStack)
end

--region 物品放置
--- 普通物品放置（非子弹装配模式）
---@param BaseRow number 鼠标光标所在的格子行
---@param BaseCol number 鼠标光标所在的格子列
---@param DragUI table DragUIItem 实例
---@param Operation table 拖拽操作对象
---@param ShapeCells table 形状格子坐标数组
---@return boolean 是否放置成功
function M:PlaceItemNormal(BaseRow, BaseCol, DragUI, Operation, ShapeCells)
    -- 检查是否可以放置
    if not self:CanPlaceShapeAt(BaseRow, BaseCol, ShapeCells) then
        DebugPrint("PlaceItemNormal: 无法放置，位置不合法")
        self:DeactivateShapeArea()
        return false
    end
    
    -- 从 ShapeCells 中找到左上角（最小行、最小列）
    local TopLeftRow, TopLeftCol = ShapeCells[1].Row, ShapeCells[1].Col
    for _, Cell in ipairs(ShapeCells) do
        if Cell.Row < TopLeftRow then TopLeftRow = Cell.Row end
        if Cell.Col < TopLeftCol then TopLeftCol = Cell.Col end
    end
    
    -- 如果形状部分超出边界，用边界内最小行/列作为挂载锚点
    local MountRow = math.max(1, TopLeftRow)
    local MountCol = math.max(1, TopLeftCol)
    
    local TopLeftCell = self:GetContainItemAt(MountRow, MountCol)
    if not TopLeftCell then
        DebugPrint("PlaceItemNormal: 无法获取挂载格子(" .. MountRow .. "," .. MountCol .. ")")
        return false
    end
    
    -- 计算形状行列数（用于创建 PlacedItem）
    local ShapeRows = 1
    local ShapeCols = 1
    if DragUI and DragUI.ShapeOffsets and #DragUI.ShapeOffsets > 0 then
        local MinRow, MaxRow = DragUI.ShapeOffsets[1][1], DragUI.ShapeOffsets[1][1]
        local MinCol, MaxCol = DragUI.ShapeOffsets[1][2], DragUI.ShapeOffsets[1][2]
        for _, Offset in ipairs(DragUI.ShapeOffsets) do
            MinRow = math.min(MinRow, Offset[1] or 0)
            MaxRow = math.max(MaxRow, Offset[1] or 0)
            MinCol = math.min(MinCol, Offset[2] or 0)
            MaxCol = math.max(MaxCol, Offset[2] or 0)
        end
        ShapeRows = (MaxRow - MinRow + 1)
        ShapeCols = (MaxCol - MinCol + 1)
    end
    
    local PlacedItem = self:CreatePlacedItem(DragUI, Operation, ShapeRows, ShapeCols)
    if not PlacedItem then
        return false
    end
    
    -- 直接 attach 到 ShapeCells 的左上角格子，Pos_Item 本身就在格子左上角
    self:AttachPlacedItemToCell(PlacedItem, TopLeftCell)
    
    -- 标记格子为已占用
    for _, Cell in ipairs(ShapeCells) do
        self:MarkCellOccupied(Cell.Row, Cell.Col, PlacedItem)
    end
    
    -- 获取物品内容数据（用于记录分数等）
    local ItemContent = BagGameModel:BuildItemContent(DragUI.TemplateId)
    
    -- 保存放置记录
    if not self.PlacedItems then
        self.PlacedItems = {}
    end
    table.insert(self.PlacedItems, {
        Widget = PlacedItem,
        Cells = ShapeCells,
        BaseRow = BaseRow,
        BaseCol = BaseCol,
        TemplateId = DragUI.TemplateId,
        DisPlayItemId = DragUI.DisPlayItemId,
        ItemType = ItemContent and ItemContent.ItemType,
        BasicPoint = ItemContent and ItemContent.BasicPoint or 0,
        CurrentAmmo = ItemContent and ItemContent.CurrentAmmo or 0,  -- 武器当前弹药
        MaxAmmo = ItemContent and ItemContent.MaxAmmo or 0,          -- 武器弹药上限
        CurrentStack = ItemContent and ItemContent.CurrentStack or 1, -- 当前堆叠数（Other/Ammo类型）
        MaxStack = ItemContent and ItemContent.MaxStack or 0,         -- 堆叠上限
    })
    
    -- 同步到 Model 的放置记录
    BagGameModel:AddPlacedItem(self.PlacedItems[#self.PlacedItems])

    -- 刷新双倍积分特效：满足双倍播放 Double_in，离开双倍播放 Double_out
    self:RefreshPlacedItemDoubleState()

    -- 放置格子动效：双倍区播 Put_GetPoint，否则播 Put_Normal
    local NewRecord = self.PlacedItems[#self.PlacedItems]
    if NewRecord and NewRecord.Cells then
        local bDouble = NewRecord.IsDoubleReward
        for _, Cell in ipairs(NewRecord.Cells) do
            local ContainItem = self:GetContainItemAt(Cell.Row, Cell.Col)
            if ContainItem then
                if bDouble then
                    ContainItem:PlayPutGetPoint()
                else
                    ContainItem:PlayPutNormal()
                end
            end
        end
    end
    
    -- 更新分数显示
    self:UpdateScoreDisplay()
    
    -- 设置源 DisPlayItem 的 Switch_Type 索引为 2（已放置）
    self:SetDisPlayItemSwitchIndex(DragUI.DisPlayItemId, 2)
    
    -- 设置为当前未确认物品（可以旋转、删除、重新拉起）
    self:SetUnconfirmedItem(PlacedItem)
    PlacedItem.bIsConfirmed = false
    
    -- 更新完成按钮状态
    self:UpdateFinishButtonState()
    
    -- 退出抓取状态，播放 recycle_out 动画
    self:OnDragStateChanged(false)
    
    DebugPrint("PlaceItemNormal: 放置成功，左上角(" .. TopLeftRow .. "," .. TopLeftCol .. "), 大小(" .. ShapeRows .. "x" .. ShapeCols .. ")")
    return true
end
--endregion


--- 创建放置的 Item Widget
---@param DragUI table 原始的 DragUIItem
---@param Operation table 拖拽操作对象
---@param ShapeRows number 形状行数
---@param ShapeCols number 形状列数
---@return table|nil 创建的 Widget
function M:CreatePlacedItem(DragUI, Operation, ShapeRows, ShapeCols)
    local PlacedItem = UIManager(self):_CreateWidgetNew("BagGameDragUIItem")
    if not PlacedItem then
        return nil
    end

    -- 设置为 Visible 以便接收鼠标事件（拖拽拉起功能需要）
    PlacedItem:SetVisibility(UIConst.VisibilityOp.Visible)
    PlacedItem.DisPlayItemId = DragUI.DisPlayItemId
    PlacedItem.TemplateId = DragUI.TemplateId
    PlacedItem.PlayScreen = self  -- 设置 PlayScreen 引用，用于回收和拉起

    -- 先同步类型/数量/旋转元数据，确保 OriginalShapeOffsets 等在 SetShape 之前就位
    -- 这样 SetShape 的 guard（if not self.OriginalShapeOffsets）不会用旋转后的形状覆盖真实原始值
    if DragUI.GetDragSyncData and PlacedItem.ApplyDragSyncData then
        local SyncData = DragUI:GetDragSyncData()
        if SyncData then
            PlacedItem:ApplyDragSyncData(SyncData)
        end
    end

    -- 设置当前形状（已旋转的 ShapeOffsets）
    if DragUI.ShapeOffsets then
        PlacedItem:SetShape(DragUI.ShapeOffsets)
    end
    if PlacedItem.SetItemSize then
        PlacedItem:SetItemSize()
    end
    if DragUI.RotationCount then
        PlacedItem.RotationCount = DragUI.RotationCount
    end

    -- 标记为放置状态（可以被拖拽拉起）
    PlacedItem.bIsPlaced = true
    -- 标记为未确认状态（可以旋转、删除、拉起）
    PlacedItem.bIsConfirmed = false

    return PlacedItem
end

--- 将 PlacedItem 挂载到指定格子的 Pos_Item 容器（公共方法）
--- 设置 slot/anchor 为左上角对齐，提升 ZOrder
---@param PlacedItem table 放置的 Widget
---@param TopLeftCell table 目标格子 Widget
---@param bPlayAnim boolean 是否播放入场动画（首次放置=true, 旋转重挂=false）
function M:MountItemToCell(PlacedItem, TopLeftCell, bPlayAnim)
    local CellPanel = TopLeftCell.Pos_Item or TopLeftCell

    if CellPanel and CellPanel.AddChild then
        local PanelSlot = CellPanel:AddChild(PlacedItem)
        if PanelSlot then
            local Anchors = PanelSlot:GetAnchors()
            Anchors.Minimum = FVector2D(0.0, 0.0)
            Anchors.Maximum = FVector2D(0.0, 0.0)
            PanelSlot:SetAnchors(Anchors)
            PanelSlot:SetAlignment(FVector2D(0.0, 0.0))
            PanelSlot:SetPosition(FVector2D(0.0, 0.0))
            PanelSlot:SetAutoSize(true)
        end
        if PlacedItem.Main then
            local MainSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(PlacedItem.Main)
            if MainSlot then
                local MainAnchors = MainSlot:GetAnchors()
                MainAnchors.Minimum = FVector2D(0.0, 0.0)
                MainAnchors.Maximum = FVector2D(0.0, 0.0)
                MainSlot:SetAnchors(MainAnchors)
                MainSlot:SetAlignment(FVector2D(0.0, 0.0))
                MainSlot:SetPosition(FVector2D(0.0, 0.0))
            end
        end
        PlacedItem:SetRenderScale(FVector2D(1, 1))
        if bPlayAnim then
            PlacedItem:PlayAnimation(PlacedItem.Size_In)
            PlacedItem:PlayAnimation(PlacedItem.Btn_In)
        end
    end

    self:BringCellToFront(TopLeftCell)
end

--- 将 PlacedItem 附加到左上角格子（首次放置入口，播放入场动画）
---@param PlacedItem table 放置的 Widget
---@param TopLeftCell table ShapeCells 中左上角的格子 Widget
function M:AttachPlacedItemToCell(PlacedItem, TopLeftCell)
    self:MountItemToCell(PlacedItem, TopLeftCell, true)
    DebugPrint("AttachPlacedItemToCell: 放置到左上角格子(" .. TopLeftCell.Row .. "," .. TopLeftCell.Col .. ")")
end

--- 通过绝对位置附加 PlacedItem（备选方案）
---@param PlacedItem table 放置的 Widget
---@param TopLeftCell table 左上角格子 Widget
---@param ItemWidth number 宽度
---@param ItemHeight number 高度
function M:AttachPlacedItemByAbsolutePosition(PlacedItem, TopLeftCell, ItemWidth, ItemHeight)
    -- 获取格子的绝对位置
    local CellGeometry = TopLeftCell:GetCachedGeometry()
    if not CellGeometry then
        TopLeftCell:ForceLayoutPrepass()
        CellGeometry = TopLeftCell:GetCachedGeometry()
    end
    
    if not CellGeometry then
        DebugPrint("AttachPlacedItemByAbsolutePosition: 无法获取格子几何信息")
        return
    end
    
    local CellAbsPos = UIManager(self):GetWorldPosition(TopLeftCell)
    local PlacedContainer = TopLeftCell.Pos_Item
    if PlacedContainer and PlacedContainer.AddChild then
        PlacedContainer:AddChild(PlacedItem)
        --[[
            -- 设置绝对位置
            -- local CanvasSlot = UE.UWidgetLayoutLibrary.SlotAsCanvasSlot(PlacedItem)
            -- if CanvasSlot then
            --     -- 计算相对于容器的位置
            --     local ContainerGeometry = PlacedContainer:GetCachedGeometry()
            --     local ContainerAbsPos = ContainerGeometry and UIManager(self):GetWorldPosition(ContainerGeometry) or FVector2D(0, 0)
                
            --     local RelativePos = FVector2D(
            --         CellAbsPos.X - ContainerAbsPos.X,
            --         CellAbsPos.Y - ContainerAbsPos.Y
            --     )
                
            --     -- 考虑 DPI 缩放
            --     local Scale = UE.UWidgetLayoutLibrary.GetViewportScale(self)
            --     if Scale > 0 then
            --         RelativePos = FVector2D(RelativePos.X / Scale, RelativePos.Y / Scale)
            --     end
                
            --     local Anchors = FAnchors()
            --     Anchors.Minimum = FVector2D(0, 0)
            --     Anchors.Maximum = FVector2D(0, 0)
            --     CanvasSlot:SetAnchors(Anchors)
            --     CanvasSlot:SetAlignment(FVector2D(0, 0))
            --     CanvasSlot:SetPosition(RelativePos)
            --     CanvasSlot:SetSize(FVector2D(ItemWidth, ItemHeight))
            -- end
        --]]
    end
end

--- 获取单个格子的大小
---@param Cell table 格子 Widget
---@return FVector2D 格子大小
function M:GetCellSize(Cell)
    if not Cell then
        return FVector2D(50, 50)  -- 默认大小
    end
    
    local CellGeometry = Cell:GetCachedGeometry()
    if not CellGeometry then
        Cell:ForceLayoutPrepass()
        CellGeometry = Cell:GetCachedGeometry()
    end
    
    if CellGeometry then
        return UE4.USlateBlueprintLibrary.GetLocalSize(CellGeometry)
    end
    
    -- 尝试从 DesiredSize 获取
    local DesiredSize = Cell:GetDesiredSize()
    if DesiredSize and DesiredSize.X > 0 then
        return DesiredSize
    end
    
    return FVector2D(50, 50)  -- 默认大小
end

--- 标记格子为已占用
---@param Row number 行
---@param Col number 列
---@param PlacedItem table 占用该格子的 Widget
function M:MarkCellOccupied(Row, Col, PlacedItem)
    -- 更新 Model 数据
    BagGameModel:MarkCellOccupied(Row, Col, PlacedItem)
    
    -- 更新格子的视觉状态（UI 层）
    local Cell = self:GetContainItemAt(Row, Col)
    if Cell then
        Cell.bIsOccupied = true
        Cell.OccupiedBy = PlacedItem
    end
end

--- 检查格子是否被占用（代理到 Model）
---@param Row number 行
---@param Col number 列
---@return boolean 是否被占用
function M:IsCellOccupied(Row, Col)
    return BagGameModel:IsCellOccupied(Row, Col)
end

-- ==================== ZOrder 层级控制 ====================

--- 将格子提升到最高层级（在 80 个格子中显示在最上层）
---@param Cell table ContainItem Widget
function M:BringCellToFront(Cell)
    if not Cell then return end
    
    local Parent = Cell:GetParent()
    if not Parent then return end
    
    local CanvasSlot = UE.UWidgetLayoutLibrary.SlotAsCanvasSlot(Cell)
    if CanvasSlot then
        -- 设置较高的 ZOrder 值
        CanvasSlot:SetZOrder(100)
        DebugPrint("BringCellToFront: 使用 ZOrder 提升层级")
        return
    end
end

--- 重置格子的层级
---@param Cell table ContainItem Widget
function M:ResetCellZOrder(Cell)
    if not Cell then return end
    
    local CanvasSlot = UE.UWidgetLayoutLibrary.SlotAsCanvasSlot(Cell)
    if CanvasSlot then
        -- 根据格子的索引设置 ZOrder（恢复原始顺序）
        local Row, Col = Cell:GetPosition()
        local Index = (Row - 1) * GRID_COLS + Col
        CanvasSlot:SetZOrder(Index)
    end
end

--- 将 PlacedItem 提升到最高层级
---@param PlacedItem table 放置的 Widget
-- function M:BringPlacedItemToFront(PlacedItem)
--     if not PlacedItem then return end
    
--     local CanvasSlot = UE.UWidgetLayoutLibrary.SlotAsCanvasSlot(PlacedItem)
--     if CanvasSlot then
--         CanvasSlot:SetZOrder(200)
--         return
--     end
-- end
--endregion

-- ==================== 回收逻辑 ====================

--- 回收已放置的道具
---@param PlacedItem table 要回收的 PlacedItem Widget
function M:RecycleItem(PlacedItem)
    if not PlacedItem or not self.PlacedItems then
        return false
    end
    
    -- 查找对应的放置记录
    local RecordIndex = nil
    local PlacedRecord = nil
    for i, Record in ipairs(self.PlacedItems) do
        if Record.Widget == PlacedItem then
            RecordIndex = i
            PlacedRecord = Record
            break
        end
    end
    
    if not PlacedRecord then
        DebugPrint("RecycleItem: 未找到放置记录")
        return false
    end
    
    -- 清除占用的格子（数据 + UI）
    if PlacedRecord.Cells then
        for _, Cell in ipairs(PlacedRecord.Cells) do
            self:ClearCellOccupied(Cell.Row, Cell.Col)
        end
    end
    
    -- 同步移除 Model 中的放置记录（必须在移除 View 记录之前，用 Widget 查找 Model 索引）
    local _, ModelIndex = BagGameModel:FindPlacedItemByWidget(PlacedItem)
    if ModelIndex then
        BagGameModel:RemovePlacedItem(ModelIndex)
    end
    
    -- 从 View 列表中移除记录
    table.remove(self.PlacedItems, RecordIndex)
    
    -- UI 更新：移除 Widget
    PlacedItem:RemoveFromParent()
    
    -- 同步未确认状态
    if self.CurrentUnconfirmedItem == PlacedItem then
        self:SetUnconfirmedItem(nil)
    end
    
    -- UI 更新：恢复源 DisPlayItem 的 Switch_Type 索引为 0（默认）
    self:SetDisPlayItemSwitchIndex(PlacedRecord.DisPlayItemId, 0)
    
    -- 更新分数显示
    self:UpdateScoreDisplay()
    
    -- 更新完成按钮状态
    self:UpdateFinishButtonState()
    
    DebugPrint("RecycleItem: 回收成功，DisPlayItemId=" .. tostring(PlacedRecord.DisPlayItemId))
    return true
end

--- 清除格子的占用状态
---@param Row number 行
---@param Col number 列
function M:ClearCellOccupied(Row, Col)
    -- 清除 Model 数据
    BagGameModel:ClearCellOccupied(Row, Col)
    
    -- 清除格子的视觉状态（UI 层）
    local Cell = self:GetContainItemAt(Row, Col)
    if Cell then
        Cell.bIsOccupied = false
        Cell.OccupiedBy = nil
        self:ResetCellZOrder(Cell)
        -- 停止所有放置/高亮动画，回到初始态
        if Cell.DeactivateHighlight then
            Cell:DeactivateHighlight()
        end
    end
end

function M:OnBtnRefreshClicked()
    --@todo 弹窗
    DebugPrint("OnBtnRefreshClicked: 重置游戏界面")
    self:ResetPlayArea()
end

--- 重置游戏区域到初始状态
function M:ResetPlayArea()
    -- 1. 重置 Model 游戏状态
    BagGameController:ResetGame()
    
    -- 2. 清除未确认物品状态（同步 View）
    self:SetUnconfirmedItem(nil)
    
    -- 3. 移除所有已放置的物品（UI）
    self:ClearAllPlacedItems()
    
    -- 4. 重置所有格子状态（UI）
    self:ResetAllCells()
    
    -- 5. 取消高亮状态（UI）
    self:DeactivateShapeArea()
    
    -- 6. 重新初始化展示区的物品（恢复可拖拽状态）
    if self.LevelInitialItem then
        self:InitDisPlayItem(self.LevelInitialItem)
    end
    
    -- 7. 重置分数显示
    self:UpdateScoreDisplay()
    
    -- 8. 重置完成按钮状态（禁用）
    self:SetFinishButtonEnabled(false)
    
    DebugPrint("ResetPlayArea: 重置完成")
end

--- 清除所有已放置的物品
function M:ClearAllPlacedItems()
    if self.PlacedItems then
        for _, PlacedRecord in ipairs(self.PlacedItems) do
            if PlacedRecord.Widget then
                PlacedRecord.Widget:RemoveFromParent()
            end
        end
    end
    self.PlacedItems = {}

    -- 清理已确认物品列表（Reset/Destruct 时调用）
    self._ConfirmedPlacedItems = {}

    -- 若处于 FOCUS 态，强制退出到 SCROLL
    if self._GamepadState == "FOCUS" then
        self._GamepadState = "SCROLL"
        self._FocusIndex = 1
        if self.EMTileView1 then
            self.EMTileView1:SetFocus()
        end
    end
end

--- 重置所有格子状态（UI 层，数据在 Model 中由 Controller:ResetGame 重置）
function M:ResetAllCells()
    -- 重置每个格子 Widget 的状态
    if self.ContainItems then
        for i, ContainItem in ipairs(self.ContainItems) do
            if ContainItem then
                ContainItem.bIsOccupied = false
                ContainItem.OccupiedBy = nil
                if ContainItem.DeactivateHighlight then
                    ContainItem:DeactivateHighlight()
                end
                self:ResetCellZOrder(ContainItem)
            end
        end
    end
end

--region 结算逻辑
function M:OnBtnFinishClicked()
    -- 是否所有物品都已放置
    if not self:CheckAllItemsPlaced() then
        DebugPrint("OnBtnFinishClicked: 还有物品未放置，无法结算")
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, "UI_GameEvent_BagGame_Toast_HasnotFinsh")
        return
    end
    -- 是否有未确认的物品
    if self:HasUnconfirmedItem() then
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, "UI_GameEvent_BagGame_Toast_HasnotFinsh")
        DebugPrint("OnBtnFinishClicked: 有未确认的物品，请先确认")
        return
    end
    
    -- 计算最终分数
    local TotalScore = self:UpdateScoreDisplay()
    DebugPrint("最终得分: " .. TotalScore)
    
    -- 执行结算
    self:DoSettlement(TotalScore)
end

--- 执行结算
---@param TotalScore number 最终得分
function M:DoSettlement(TotalScore)
    -- 禁用按钮防止重复点击
    self:SetFinishButtonEnabled(false)
    
    BagGameController:FinishGame(function(bSuccess)
        if bSuccess then
            -- 结算成功，显示结算结果
            self:ShowSettlementResult(TotalScore)
        else
            -- 结算失败，恢复按钮状态
            self:SetFinishButtonEnabled(true)
            UIManager(self):ShowUITip(UIConst.Tip_CommonTop, "UI_GameEvent_BagGame_Toast_SettlementFailed")
        end
    end)
end

---@param TotalScore number 最终得分
function M:ShowSettlementResult(TotalScore)
    local StarCount = self:UpdateStarCountByScore(TotalScore)
    
    DebugPrint(string.format("结算完成: 得分=%d, 星数=%d", TotalScore, StarCount))
    
    -- 构建得分条件列表（对应 TargetScore 的每一档目标分）
    local ScoreInfo = {}
    if self.TargetScore then
        for i, Score in ipairs(self.TargetScore) do
            table.insert(ScoreInfo, {
                text = string.format(GText("UI_BackpackPuzzle_Target" .. i), Score),
                isFinish = TotalScore >= Score,
            })
        end
    end
    
    -- 是否为新纪录
    local IsNewRecord = TotalScore > (self.PlayerScore or 0)
    
    local Params = {
        LevelScore = TotalScore,
        IsWin = StarCount > 0,
        IsNewRecord = IsNewRecord,
        ActivityId = BagGameModel.CurEventId,
        ScoreInfo = ScoreInfo,
        RewardIds = self.TargetReward,
        Btn_Continue_Text = "UI_TEMPLE_RESTART",
        ExitCallback = function(SettlementWidget)
            -- 关闭 Play 界面（结算界面在最上层，Play 关闭不可见），回到 Main
            if self.SettlementPage and self.SettlementPage.RemoveFromParent then
                self.SettlementPage:RemoveFromParent()
            end
            self.SettlementPage = nil
            self:CleanupPlayState()
            if self.Owner and self.Owner.RefreshLevelListAfterPlay then
                self.Owner:RefreshLevelListAfterPlay(self.LevelId)
            end
            self:Close()
            DebugPrint("WBP_Activity_BagGame_Play_C: ExitCallback")
        end,
        ContinueCallback = function(SettlementWidget)
            -- 重新开始当前关卡
            if self.SettlementPage and self.SettlementPage.RemoveFromParent then
                self.SettlementPage:RemoveFromParent()
            end
            self.SettlementPage = nil
            self:ResetPlayArea()
            self:SetFocus()
        end,
    }
    
    -- 打开结算界面并获取引用，用于后续添加奖励预览
    self.SettlementPage = ActivityUtils.OpenActivitySettlement(BagGameModel.CurEventId, nil, Params)
    -- if self.SettlementPage then
    --     local RewardContents = BagGameModel:BuildSettlementRewardContents(TotalScore, self.TargetScore, self.TargetReward)
    --     if #RewardContents > 0 then
    --         local RewardWidget = self.SettlementPage.Settlement_RewardItem
    --         if RewardWidget then
    --             RewardWidget:SetVisibility(UE4.ESlateVisibility.Visible)
    --             if RewardWidget.List_Reward then
    --                 for _, Content in ipairs(RewardContents) do
    --                     RewardWidget.List_Reward:AddItem(Content)
    --                 end
    --             end
    --             if RewardWidget.Text_GetReward then
    --                 RewardWidget.Text_GetReward:SetText(GText("UI_COMMON_REWARD"))
    --             end
    --         end
    --     end
    -- end
end

-- ==================== 分数计算与显示 ====================

--- 更新分数显示
--- 调用 Model 计算分数并更新 UI
---@return number 当前总分
function M:UpdateScoreDisplay()
    local TotalScore, DoubleScore, NormalScore = BagGameModel:CalculateCurrentScore()
    if self.Text_Score then
        self.Text_Score:SetText(tostring(TotalScore))
    end
    
    -- 可选：显示详细分数分解
    if self.Text_ScoreDetail then
        local DetailText = string.format("双倍区: %d×2 + 普通区: %d = %d", 
            DoubleScore, NormalScore, TotalScore)
        self.Text_ScoreDetail:SetText(DetailText)
    end
    
    DebugPrint(string.format("分数更新: 总分=%d (双倍区=%d, 普通区=%d)", 
        TotalScore, DoubleScore, NormalScore))

    self:UpdateStarCountByScore(TotalScore) 
    return TotalScore
end

--- 获取当前分数
---@return number 当前总分
function M:GetCurrentScore()
    return BagGameModel.CurrentScore or 0
end

-- ==================== 完成按钮状态管理 ====================

--- 设置完成按钮的启用/禁用状态
---@param bEnabled boolean 是否启用
function M:SetFinishButtonEnabled(bEnabled)
    if not self.Btn_Finish then return end
    
    self.bFinishButtonEnabled = bEnabled
    
    if bEnabled then
        -- 启用状态：可点击
        self.Btn_Finish:SetForbidden(false)
        DebugPrint("完成按钮: 启用")
    else
        -- 禁用状态：不可点击
        self.Btn_Finish:SetForbidden(true)
        DebugPrint("完成按钮: 禁用")
    end
end

--- 检查是否所有物品都已放置（数据驱动：读数据对象的 SwitchIndex）
--- 规则：所有 DisPlayItem 的 SwitchIndex 都为 2（已放置）
---@return boolean 是否全部放置完成
function M:CheckAllItemsPlaced()
    -- 没有初始化过物品
    if not self.TotalDisPlayItemCount or self.TotalDisPlayItemCount == 0 then
        return false
    end

    -- 已确认的物品已从 dict 中移除，检查是否还有未放置的物品
    if self.DisPlayItemDataById then
        for _, ContentData in pairs(self.DisPlayItemDataById) do
            if ContentData.SwitchIndex ~= 2 then
                return false
            end
        end
    end

    local bAllPlaced = true
    DebugPrint(string.format("检查物品放置状态: 全部完成=%s", tostring(bAllPlaced)))

    return bAllPlaced
end

--- 更新完成按钮状态
--- 当所有物品都已放置、没有未确认物品、且全部在得分区域时，启用按钮
function M:UpdateFinishButtonState()
    local bAllPlaced = self:CheckAllItemsPlaced()
    local bHasUnconfirmed = self:HasUnconfirmedItem()
    local bAllScoring = BagGameModel:AreAllPlacedItemsScoring()
    
    local bShouldEnable = bAllPlaced and not bHasUnconfirmed and bAllScoring
    
    self:SetFinishButtonEnabled(bShouldEnable)
    
    DebugPrint(string.format("更新完成按钮: 全部放置=%s, 有未确认=%s, 全部得分=%s, 启用=%s",
        tostring(bAllPlaced), tostring(bHasUnconfirmed), tostring(bAllScoring), tostring(bShouldEnable)))
end

--- 清理关卡游戏状态（退出/销毁时调用）
--- 移除所有已放置物品、重置格子、清除高亮和 Model 状态
function M:CleanupPlayState()
    self:SetUnconfirmedItem(nil)
    self:ClearAllPlacedItems()
    self:ResetAllCells()
    self:DeactivateShapeArea()
    -- 清理格子 Pos_Item 容器中可能残留的动态子节点
    self:ClearAllCellPosItems()
end

--- 清理所有格子 Pos_Item 容器中的动态子节点
--- 作为安全兜底，防止 ClearAllPlacedItems 因引用丢失而无法清理
function M:ClearAllCellPosItems()
    local TotalCells = GRID_ROWS * GRID_COLS
    for i = 1, TotalCells do
        local ContainItem = self["PlayItem_" .. i]
        if ContainItem and ContainItem.Pos_Item and ContainItem.Pos_Item.ClearChildren then
            ContainItem.Pos_Item:ClearChildren()
        end
    end
end

function M:ExecuteExitLevel()
    -- 退出前清理所有放置状态，防止残留
    self:CleanupPlayState()
    self:BindToAnimationFinished(self.Out, { self, self.Close })
    self:PlayAnimation(self.Out)
end

function M:CloseSelf()
    if self:IsAnimationPlaying(self.In) then
        return
    end

    local CancelFunc = function()
        -- 取消关闭：保持当前关卡，不做处理
    end
    local ConfirmFunc = function()
        self:ExecuteExitLevel()
    end
    local CloseBtnFunc = function()
        -- 关闭弹窗：保持当前关卡，不做处理
    end
    
    UIManager():ShowCommonPopupUI(100330, {
        LeftCallbackFunction = CancelFunc,
        RightCallbackFunction = ConfirmFunc,
        CloseBtnCallbackFunction = CloseBtnFunc
    }, self)
end

--SCROLL 态：方向键放行给 TileView 原生导航，仅拦截功能键（A/B/LS/RS）
--MOVING 态：拦截全部手柄键，左摇杆方向由 OnAnalogValueChanged 处理
--FOCUS 态：拦截全部手柄键，左摇杆方向由 OnAnalogValueChanged 处理
function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end

    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if self._GamepadState == "MOVING" then
        -- MOVING 态：拦截全部手柄键
        -- 左摇杆方向仅拦截（由 OnAnalogValueChanged 处理），不路由到状态机
        if InKeyName == "Gamepad_LeftStick_Up" or InKeyName == "Gamepad_LeftStick_Down"
            or InKeyName == "Gamepad_LeftStick_Left" or InKeyName == "Gamepad_LeftStick_Right" then
            return UE4.UWidgetBlueprintLibrary.Handled()
        end
        self:HandleGamepadInput(InKeyName)
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    -- FOCUS 态：拦截全部手柄键，防止穿透到 TileView
    -- 左摇杆方向仅拦截（由 OnAnalogValueChanged 处理），不重复路由
    if self._GamepadState == "FOCUS" then
        if InKeyName == "Gamepad_LeftStick_Up" or InKeyName == "Gamepad_LeftStick_Down"
            or InKeyName == "Gamepad_LeftStick_Left" or InKeyName == "Gamepad_LeftStick_Right" then
            return UE4.UWidgetBlueprintLibrary.Handled()
        end
        self:HandleGamepadInput(InKeyName)
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    -- SCROLL 态：仅拦截功能键，方向键放行给 TileView 原生导航
    local Const = UIConst.GamePadKey
    if InKeyName == Const.FaceButtonBottom or InKeyName == Const.FaceButtonRight
        or InKeyName == Const.LeftThumb or InKeyName == Const.RightThumb then
        self:HandleGamepadInput(InKeyName)
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    local Const = UIConst.GamePadKey

    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:HandleGamepadInput(InKeyName)
        -- Y 键：重置关卡（仅 SCROLL 态到达此处；MOVING/FOCUS 态被 OnPreviewKeyDown 拦截）
        if not IsEventHandled and InKeyName == Const.FaceButtonTop then
            self:OnBtnRefreshClicked()
            IsEventHandled = true
        end
        -- X 键：完成整理/结算
        if not IsEventHandled and InKeyName == Const.FaceButtonLeft then
            self:OnBtnFinishClicked()
            IsEventHandled = true
        end
    else
        if (InKeyName == "Escape") then
            self:CloseSelf()
        end
    end

    return UE4.UWidgetBlueprintLibrary.Handled()
end

--- 手柄 MOVING 态：消耗已放置的 Other 物品（执行堆叠）
--- 调用者已清除该物品的格子占用；此方法负责移除 Widget + 放置记录 + 更新显示
---@param PlacedItem table 已放置的 Other 物品 Widget
---@param PlacedRecord table 对应的放置记录（来自 self.PlacedItems）
---@param TargetRecord table 目标堆叠物品的 PlacedRecord
---@param bCanStack boolean 确认目标可堆叠（调用方已检查）
---@return boolean 操作是否成功
function M:ConsumeGamepadStackItem(PlacedItem, PlacedRecord, TargetRecord, bCanStack)
    if not bCanStack then return false end

    local StackAmount, Remaining, bSuccess = BagGameModel:CalculateStackResult(TargetRecord, PlacedItem.TemplateId)
    if not bSuccess then return false end

    BagGameModel:ExecuteStack(TargetRecord, StackAmount)
    self:UpdatePlacedItemStackDisplay(TargetRecord)

    -- 移除源 PlacedItem（格子已由调用方清除，只需移除 Widget + 记录）
    PlacedItem:RemoveFromParent()
    local _, ModelIndex = BagGameModel:FindPlacedItemByWidget(PlacedItem)
    if ModelIndex then
        BagGameModel:RemovePlacedItem(ModelIndex)
    end
    for i, Record in ipairs(self.PlacedItems) do
        if Record == PlacedRecord then
            table.remove(self.PlacedItems, i)
            break
        end
    end
    if self.CurrentUnconfirmedItem == PlacedItem then
        self:SetUnconfirmedItem(nil)
    end

    -- 处理源 DisPlayItem（剩余→更新数量；归零→移除列表项）
    if Remaining > 0 then
        self:UpdateOtherRemaining(PlacedItem.DisPlayItemId, Remaining)
        self:SetDisPlayItemSwitchIndex(PlacedItem.DisPlayItemId, 0)
    else
        self:SetDisPlayItemSwitchIndex(PlacedItem.DisPlayItemId, 2)
        self:RemoveConfirmedItemFromList(PlacedItem.DisPlayItemId)
    end

    self:UpdateScoreDisplay()
    self:UpdateFinishButtonState()
    return true
end

--- 手柄 MOVING 态：消耗已放置的 Ammo 物品（执行装弹）
--- 调用者已清除该物品的格子占用；此方法负责移除 Widget + 放置记录 + 更新显示
---@param PlacedItem table 已放置的 Ammo Widget
---@param PlacedRecord table 对应的放置记录
---@param GunRecord table 目标枪械的 PlacedRecord
---@param bCanLoad boolean 确认枪械可装弹（调用方已检查）
---@return boolean 操作是否成功
function M:ConsumeGamepadAmmoItem(PlacedItem, PlacedRecord, GunRecord, bCanLoad)
    if not bCanLoad then return false end

    local LoadAmount, Remaining, bSuccess = BagGameModel:CalculateLoadResult(GunRecord, PlacedItem.TemplateId)
    if not bSuccess then return false end

    BagGameModel:ExecuteLoadAmmo(GunRecord, LoadAmount)
    if GunRecord.Widget and GunRecord.Widget.UpdateAmmoDisplay then
        GunRecord.Widget:UpdateAmmoDisplay(GunRecord.CurrentAmmo)
    end

    -- 移除源 PlacedItem（格子已由调用方清除，只需移除 Widget + 记录）
    PlacedItem:RemoveFromParent()
    local _, ModelIndex = BagGameModel:FindPlacedItemByWidget(PlacedItem)
    if ModelIndex then
        BagGameModel:RemovePlacedItem(ModelIndex)
    end
    for i, Record in ipairs(self.PlacedItems) do
        if Record == PlacedRecord then
            table.remove(self.PlacedItems, i)
            break
        end
    end
    if self.CurrentUnconfirmedItem == PlacedItem then
        self:SetUnconfirmedItem(nil)
    end

    -- 处理源 DisPlayItem（剩余→更新数量；归零→移除列表项）
    if Remaining > 0 then
        self:UpdateAmmoRemaining(PlacedItem.DisPlayItemId, Remaining)
        self:SetDisPlayItemSwitchIndex(PlacedItem.DisPlayItemId, 0)
    else
        self:SetDisPlayItemSwitchIndex(PlacedItem.DisPlayItemId, 2)
        self:RemoveConfirmedItemFromList(PlacedItem.DisPlayItemId)
    end

    self:UpdateScoreDisplay()
    self:UpdateFinishButtonState()
    return true
end

function M:BP_GetDesiredFocusTarget()
    if self._GamepadState == "MOVING" or self._GamepadState == "FOCUS" then
        return self
    end
    return self.EMTileView1
end

AssembleComponents(M)
return M
