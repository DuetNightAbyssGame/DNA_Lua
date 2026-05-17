--
-- DESCRIPTION
--
-- @COMPANY ** 搜打撤回收站
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local InventoryController = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryController")
local InventoryModel = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryModel")
local InventoryCommonConst = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryCommonConst")
local EMCache = require "EMCache.EMCache"
local SoloTreasureUtils = require("BluePrints.UI.WBP.SoloTreasure.Widget.SoloTreasureUtils")


local PocketWidgetPath = "WidgetBlueprint'/Game/UI/WBP/SoloTreasure/Widget/WBP_SoloTreasure_BagItem02.WBP_SoloTreasure_BagItem02'"
-- 分帧加载：每帧最多初始化的 Pocket 数量，可根据实际表现调整
local RECYCLE_LOAD_PER_FRAME = 1
local SortType = {
    RarityDesc = 1,
    RarityAsc = 2,
    ValueDesc = 3,
    ValueAsc = 4,
    PutInRecycleTimeDesc = 5,
    PutInRecycleTimeAsc = 6,
}
---@type WBP_SoloTreasure_BagSearch_C
local M = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.Common.TimerMgr",
    "BluePrints.Common.DelayFrameComponent",
    "BluePrints.UI.BP_EMUserWidgetUtils_C",
})

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

-- function M:Destruct()

-- end

function M:Init(InitParams)
    self.Parent = InitParams.Parent
    if not self.Parent or not self.Parent.InventoryController or not self.Parent.InventoryController.bInit then return end
    self.Text_Recycle:SetText(GText("UI_Extraction_RecyclingStation"))
    self.Text_TitleRecycle:SetText(GText("UI_Extraction_RecyclingStation"))
    self.Btn_Recycle.OnClicked:Add(self, self.OnClickBtnRecycle)
    self.Btn_Recycle.OnPressed:Add(self, self.OnPressBtnRecycle)
    self.Btn_Recycle.OnHovered:Add(self, self.OnHoverBtnRecycle)
    self.Btn_Recycle.OnUnHovered:Add(self, self.OnUnHoverBtnRecycle)

    self:InitEvents()
    self:ChangeRecycleBtnState(InventoryCommonConst.RecycleBtnState.Normal)

    self.Key_Recycle:CreateCommonKey({
        KeyInfoList = {{
            Type = "Img",
            ImgShortPath = "LB",
        }}
    })
    if UIUtils.IsMobileInput() then
        self.Key_Recycle:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.bFirstOpen = true
    self:InitSort()
end

function M:InitSort()
    local Params = {
        OnGetBackReply = function(_, MyGeometry, InKeyEvent)
            local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
            local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
            if(Const.GamepadFaceButtonRight == InKeyName)then
                self:EnterSortDetail(false)
                return UE4.UWidgetBlueprintLibrary.Handled()
            end
            return UE4.UWidgetBlueprintLibrary.Unhandled()
        end,
    }
    self.Sort:Init(self.Parent, {
        GText("UI_Extraction_TM_4"), GText("UI_Extraction_TM_5"), GText("UI_Extraction_TM_6")
    }, CommonConst.DESC, Params)
    self.Sort:BindEventOnSelectionsChanged(self, function()
        local SortByIdx, SortType = self.Sort:GetSortInfos()
        self:OnChangeSortType(SortByIdx * 2 - (SortType - 1))
    end)
    self.Sort:BindEventOnSortTypeChanged(self, function()
        local SortByIdx, SortType = self.Sort:GetSortInfos()
        self:OnChangeSortType(SortByIdx * 2 - (SortType - 1))
    end)
    self:OnChangeSortType(SortType.RarityDesc)
    self.Sort:SetGamepadKey("Up")
end

function M:EnterSortDetail(bEnter)
    if bEnter and not InventoryController.bDraging then
        self.bOpenSortDetail = true
        if UIUtils.IsGamepadInput() then
            self.Sort:SetFocus()
            InventoryController.bOpenRecycleSortDetail = true
            InventoryController.MainWidget.BagSelect_Controller:SetVisibility(ESlateVisibility.Collapsed)
            if not self.GameInputModeSubsystem then
                self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
            end
            if self.GameInputModeSubsystem then
                self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
            end
        end
        if self.Parent and self.Parent.UpdateComTab then
            self.Parent:UpdateComTab("RecycleSort")
        end
    else
        self.bOpenSortDetail = false
        InventoryController.bOpenRecycleSortDetail = false
        if UIUtils.IsGamepadInput() then
            InventoryController.MainWidget.BagSelect_Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
        if self.GameInputModeSubsystem then
            self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
        end
        if self.Parent and self.Parent.UpdateComTab then
            self.Parent:UpdateComTab("Normal")
        end
    end
end

function M:InitEvents()
    if UIUtils.IsKeyboardInput() or UIUtils.IsGamepadInput() then
        self.Scroll_Recycle:DisableDrag(true)
    end
    self.Scroll_Recycle.OnUserScrolled:Add(self, function()
        InventoryController.bDetectDrag = false
    end)
    self:AddDispatcher(EventID.OnTreasureItemDragDetected, self, function(_, DragGridData)
        self.Scroll_Recycle:SetVisibility(ESlateVisibility.HitTestInvisible)
        self.Btn_Recycle:SetVisibility(ESlateVisibility.HitTestInvisible)
        if DragGridData.bRecycle then
            return 
        end
        self:ChangeRecycleBtnState(InventoryCommonConst.RecycleBtnState.Draging)
    end)
    self:AddDispatcher(EventID.OnTreasureItemDrop, self, function(_, MoveInfo)
        self.Scroll_Recycle:SetVisibility(ESlateVisibility.Visible)
        self.Btn_Recycle:SetVisibility(ESlateVisibility.Visible)
        InventoryController:UpdateRecyclePocketDatas()
        self:ChangeRecycleBtnState(InventoryCommonConst.RecycleBtnState.Normal)
        local StartInfo = MoveInfo.StartInfo
        local EndInfo = MoveInfo.EndInfo
        if EndInfo and EndInfo.Type == "RecycleGrid" then
            self:PlayAnimation(self.RecycleBtn_Light)
        end
        if self.bOpenRecycle then
            if (StartInfo and StartInfo.Type == "RecycleGrid") or (EndInfo and EndInfo.Type == "RecycleGrid") then 
                self:UpdateView()
            end
        end
        
    end)
    self:AddDispatcher(EventID.OnTreasureItemDragCancelled, self, function(_)
        self.Scroll_Recycle:SetVisibility(ESlateVisibility.Visible)
        self.Btn_Recycle:SetVisibility(ESlateVisibility.Visible)
        self:ChangeRecycleBtnState(InventoryCommonConst.RecycleBtnState.Normal)
    end)
end

function M:RemoveEvents()
    self:RemoveDispatcher(EventID.OnTreasureItemDragDetected, self)
    self:RemoveDispatcher(EventID.OnTreasureItemDrop, self)
    self:RemoveDispatcher(EventID.OnTreasureItemDragCancelled, self)
end

function M:OnClickBtnRecycle()
    if InventoryController.bDraging then return end
    if self.bOpenRecycle then
        self:OnCloseRecycle()
    else
        self:OnOpenRecycle()
    end
    self:StopAnimation(self.Press)
    self:PlayAnimation(self.Click)
    self.bOpenRecycle = not self.bOpenRecycle
    self:BindToAnimationFinished(self.Click, {self, function()
        if self.bHover then
            self:OnHoverBtnRecycle()
        end
        self:UnbindAllFromAnimationFinished(self.Click)
    end})
end

function M:OnPressBtnRecycle()
    if UIUtils.IsGamepadInput() then
        self:OnClickBtnRecycle()
        return
    else
        self:PlayAnimation(self.Press)
    end
end

function M:OnHoverBtnRecycle()
    if UIUtils.IsMobileInput() then
        return
    end
    self.bHover = true
    self:StopAnimation(self.UnHover)
    self:PlayAnimation(self.Hover)
end

function M:OnUnHoverBtnRecycle()
    if UIUtils.IsMobileInput() then
        return
    end
    self.bHover = false
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.UnHover)
end

function M:CloseSelf()
    if self.bOpenRecycle then
        self:OnClickBtnRecycle()
    end
    -- 真正关闭背包时才释放缓存池，背包开启期间多次开关回收站可共享
    self:UnbindAllFromAnimationFinished(self.Recycle_In)
    self.Scroll_Recycle:ClearChildren()
    self._RecyclePocketWidgetPool = nil
    self._RecycleCurrentOrder = nil
    self._RecycleLoadBatch = nil
    self._RecyclePendingDatas = nil
    self._RecycleLoadedCount = nil
    self._RecyclePendingAdsorption = nil
    self:RemoveEvents()
    if not self.Out then return end
    self:PlayAnimation(self.Out)
end

function M:OnOpenRecycle()
    self:StopAnimation(self.Recycle_Out)
    self:PlayAnimation(self.Recycle_In)
    -- 动画结束时若分帧尚未完成，强制同帧完成剩余项
    self:UnbindAllFromAnimationFinished(self.Recycle_In)
    self:BindToAnimationFinished(self.Recycle_In, {self, function()
        self:_ForceCompleteRecycleLoad()
        self:UnbindAllFromAnimationFinished(self.Recycle_In)
        -- 动画结束后物品位置已稳定，此时再触发吸附才能拿到正确的 geometry
        if UIUtils.IsGamepadInput() and self._RecyclePendingAdsorption then
            local PocketDatas = self._RecyclePendingDatas or {}
            local SortedNames = {}
            for _, data in ipairs(PocketDatas) do
                table.insert(SortedNames, data.Name)
            end
            local FirstWidget = InventoryController:_FindFirstTreasureInPocketsByNames(SortedNames)
            if FirstWidget then
                InventoryController:RequestAdsorption(FirstWidget, InventoryCommonConst.AdsorptionPriority.FORCE)
            end
            self._RecyclePendingAdsorption = false
        end
    end})
    self:UpdateView(true)
end

function M:OnChangeSortType(SortType)
    self.SortType = tonumber(SortType)
    if self.bOpenRecycle then
        self:UpdateView()
    end
end

function M:UpdateView(bRequestAdsorptionToFirst)
    self.Scroll_Recycle:ScrollToStart()
    local AllRecyclePocketDatas = {}
    for _, PocketData in pairs(InventoryModel.Pockets) do
        if PocketData.bRecycle then
            table.insert(AllRecyclePocketDatas, PocketData)
        end
    end

    local bDesc = self.SortType % 2 == 1
    local bRaritySort = self.SortType > 0 and self.SortType <= 2
    local bValueSort = self.SortType > 2 and self.SortType <= 4
    local bPutInTimeSort = self.SortType > 4 and self.SortType <= 6
    local SortCache = {}
    local function GetSortData(pocket)
        local Cached = SortCache[pocket]
        if Cached then return Cached end
        local TreasureItems = InventoryModel.TreasureItems[pocket.Name]
        local Uid = TreasureItems and next(TreasureItems)
        local TreasureData = Uid and TreasureItems[Uid] or nil
        local Info = DataMgr.ExtractionTreasure[TreasureData and TreasureData.TreasureId]
        local HasInfo = Info and 1 or 0
        local Primary = 0
        if Info then
            if bRaritySort then
                Primary = DataMgr.ExtractionTreasureRarity[Info.TreasureRarity or 1].ShowRarity or 2
            elseif bValueSort then
                Primary = Info.TreasureValue or 0
            elseif bPutInTimeSort then
                Primary = TreasureData and TreasureData.PutInRecycleTime or 0
            end
        end
        Cached = {
            HasInfo = HasInfo,
            Primary = Primary,
            RecycleIndex = pocket.RecycleIndex or 0,
            Name = pocket.Name or "",
        }
        SortCache[pocket] = Cached
        return Cached
    end
    table.sort(AllRecyclePocketDatas, function(a, b)
        local A = GetSortData(a)
        local B = GetSortData(b)
        if A.HasInfo ~= B.HasInfo then return A.HasInfo > B.HasInfo end
        if A.Primary ~= B.Primary then
            if bDesc then return A.Primary > B.Primary end
            return A.Primary < B.Primary
        end
        if A.RecycleIndex ~= B.RecycleIndex then return A.RecycleIndex < B.RecycleIndex end
        return A.Name < B.Name
    end)

    -- 检查排序后顺序是否与当前 ScrollBox 一致
    local CurrentOrder = self._RecycleCurrentOrder or {}
    local bOrderChanged = (#CurrentOrder ~= #AllRecyclePocketDatas)
    if not bOrderChanged then
        for i, PocketData in ipairs(AllRecyclePocketDatas) do
            if CurrentOrder[i] ~= PocketData.Name then
                bOrderChanged = true
                break
            end
        end
    end

    -- Widget 缓存池：PocketData.Name → widget，跨 UpdateView 复用，避免重复 CreateWidget
    self._RecyclePocketWidgetPool = self._RecyclePocketWidgetPool or {}
    local Pool = self._RecyclePocketWidgetPool

    if bOrderChanged then
        -- 收集本次活跃的 pocket 名，清理已不在回收站的 widget 引用
        local ActiveNames = {}
        for _, PocketData in ipairs(AllRecyclePocketDatas) do
            ActiveNames[PocketData.Name] = true
        end
        for name in pairs(Pool) do
            if not ActiveNames[name] then
                Pool[name] = nil
            end
        end

        -- 顺序变化：重建 ScrollBox 子项顺序（AddChild 同步执行，widget 保持在 widget tree 中，GC 安全）
        self.Scroll_Recycle:ClearChildren()
        local NewOrder = {}
        for _, PocketData in ipairs(AllRecyclePocketDatas) do
            local widget = Pool[PocketData.Name]
            if not widget then
                widget = UIManager(self):CreateWidget(PocketWidgetPath, nil, nil, nil, true)
                Pool[PocketData.Name] = widget
            end
            if widget then
                self.Scroll_Recycle:AddChild(widget)
                NewOrder[#NewOrder + 1] = PocketData.Name
            end
        end
        self._RecycleCurrentOrder = NewOrder
    end

    -- 分帧加载：每帧 Init RECYCLE_LOAD_PER_FRAME 个 Pocket（AddChild 已同步完成）
    self:_StartRecycleFrameLoad(AllRecyclePocketDatas, bRequestAdsorptionToFirst)
end

-- 启动分帧加载，每帧最多 Init RECYCLE_LOAD_PER_FRAME 个 pocket（AddChild 已同步完成）
function M:_StartRecycleFrameLoad(PocketDatas, bRequestAdsorptionToFirst)
    local LoadBatch = (self._RecycleLoadBatch or 0) + 1
    self._RecycleLoadBatch = LoadBatch
    self._RecyclePendingDatas = PocketDatas
    self._RecyclePendingAdsorption = bRequestAdsorptionToFirst
    self._RecycleLoadedCount = 0

    local Pool = self._RecyclePocketWidgetPool
    local Total = #PocketDatas
    if Total == 0 then return end

    local PerFrame = RECYCLE_LOAD_PER_FRAME
    local FrameCount = math.ceil(Total / PerFrame)
    for frameIdx = 0, FrameCount - 1 do
        local startIdx = frameIdx * PerFrame + 1
        local endIdx = math.min(startIdx + PerFrame - 1, Total)
        local capturedBatch = LoadBatch
        self:AddDelayFrameFunc(function()
            if not self or self._RecycleLoadBatch ~= capturedBatch then return end
            local adsorption = self._RecyclePendingAdsorption
            for i = startIdx, endIdx do
                local data = PocketDatas[i]
                local widget = Pool and Pool[data.Name]
                if widget then
                    local Params = {
                        PocketData = data,
                        bRecycle = true,
                        Parent = self,
                        Size = FVector2D(1, 1),
                        RecycleIndex = data.RecycleIndex,
                        Name = data.Name,
                        Inventory = InventoryCommonConst.PocketType.Recycle,
                    }
                    widget:Init(Params)
                end
            end
            self._RecycleLoadedCount = endIdx
        end, frameIdx + 1, "RecycleLoad_" .. frameIdx)
    end
end

-- 动画结束时强制同帧完成剩余未 Init 的 pocket
function M:_ForceCompleteRecycleLoad()
    local PocketDatas = self._RecyclePendingDatas
    if not PocketDatas or #PocketDatas == 0 then return end
    local LoadedCount = self._RecycleLoadedCount or 0
    if LoadedCount >= #PocketDatas then return end  -- 已全部完成

    -- 作废剩余分帧任务
    self._RecycleLoadBatch = (self._RecycleLoadBatch or 0) + 1

    local Pool = self._RecyclePocketWidgetPool
    local adsorption = self._RecyclePendingAdsorption
    for i = LoadedCount + 1, #PocketDatas do
        local data = PocketDatas[i]
        local widget = Pool and Pool[data.Name]
        if widget then
            local Params = {
                PocketData = data,
                bRecycle = true,
                Parent = self,
                Size = FVector2D(1, 1),
                RecycleIndex = data.RecycleIndex,
                Name = data.Name,
                Inventory = InventoryCommonConst.PocketType.Recycle,
            }
            widget:Init(Params)
        end
    end
    self._RecycleLoadedCount = #PocketDatas
end

function M:OnCloseRecycle()
    self:StopAnimation(self.Recycle_In)
    -- 取消进行中的分帧任务和动画完成强制加载绑定
    self:UnbindAllFromAnimationFinished(self.Recycle_In)
    if self._RecycleLoadBatch then
        self._RecycleLoadBatch = self._RecycleLoadBatch + 1
    end
    -- 手柄：若当前吸附目标是回收站物品，立即清除
    -- ClearChildren 移除 widget 时 Slate 不保证触发 OnUnHovered，HIGH 级吸附可能残留并永久阻塞后续 LOW 请求
    if UIUtils.IsGamepadInput() then
        local ads = InventoryController._Adsorption
        if ads and ads.Widget and IsValid(ads.Widget) and ads.Widget.bInRecycleGrid then
            InventoryController:ReleaseForceAdsorption()
            InventoryController._Adsorption = nil
        end
    end
    self:UnbindAllFromAnimationFinished(self.Recycle_Out)
    self:BindToAnimationFinished(self.Recycle_Out, {self, function()
        self:UnbindAllFromAnimationFinished(self.Recycle_Out)
        -- 回收站收起后重新定位到第一个可用物品（容器 > 献祭 > 背包）
        if UIUtils.IsGamepadInput() then
            InventoryController:RequestAdsorptionToFirstTreasure()
        end
    end})
    self:PlayAnimation(self.Recycle_Out)
end

function M:ChangeRecycleBtnState(State)
    if self.CurState == State then return end
    if not self.CurState and State == InventoryCommonConst.RecycleBtnState.Normal then
        self:PlayAnimation(self.Recycle_PutNormal)
    elseif self.CurState == InventoryCommonConst.RecycleBtnState.DragingOver and State == InventoryCommonConst.RecycleBtnState.Normal then
        self:StopAnimation(self.RecycleBtn_PutIn)
        self:StopAnimation(self.Recycle_PutIn)
        -- self:PlayAnimation(self.RecycleBtn_PutIn, 0, 1, EUMGSequencePlayMode.Reverse)
        -- self:PlayAnimation(self.Recycle_PutIn, 0, 1, EUMGSequencePlayMode.Reverse)
        self:PlayAnimation(self.Recycle_PutNormal)
    elseif self.CurState == InventoryCommonConst.RecycleBtnState.Draging and State == InventoryCommonConst.RecycleBtnState.Normal then
        self:StopAnimation(self.RecycleBtn_PutOut)
        self:StopAnimation(self.Recycle_PutOut)
        -- self:PlayAnimation(self.RecycleBtn_PutOut, 0, 1, EUMGSequencePlayMode.Reverse)
        -- self:PlayAnimation(self.Recycle_PutOut, 0, 1, EUMGSequencePlayMode.Reverse)
        self:PlayAnimation(self.Recycle_PutNormal)
    elseif State == InventoryCommonConst.RecycleBtnState.DragingOver then
        self:StopAnimation(self.RecycleBtn_PutOut)
        self:StopAnimation(self.Recycle_PutOut)
        self:PlayAnimation(self.RecycleBtn_PutIn)
        self:PlayAnimation(self.Recycle_PutIn)
    elseif State == InventoryCommonConst.RecycleBtnState.Draging then
        self:StopAnimation(self.RecycleBtn_PutIn)
        self:StopAnimation(self.Recycle_PutIn)
        self:PlayAnimation(self.RecycleBtn_PutOut)
        self:PlayAnimation(self.Recycle_PutOut)
    end
    self.CurState = State
end

function M:OnMouseEnter()
    if not InventoryController.bDraging then return end
    if InventoryController.StartDragGridData and InventoryController.StartDragGridData.bRecycle then return end
    self:ChangeRecycleBtnState(InventoryCommonConst.RecycleBtnState.DragingOver)
end

function M:OnMouseLeave()
    if not InventoryController.bDraging then return end
    if InventoryController.StartDragGridData and InventoryController.StartDragGridData.bRecycle then return end
    self:ChangeRecycleBtnState(InventoryCommonConst.RecycleBtnState.Draging)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
    local MouseButton = UE4.UKismetInputLibrary.PointerEvent_GetEffectingButton(MouseEvent)
    local IsHandled = false
    if MouseButton.KeyName == "LeftMouseButton" then
        if InventoryController.DragWidget and InventoryController.bDraging then
            if self.CurState == InventoryCommonConst.RecycleBtnState.DragingOver then
                local RecycleDropGridData = InventoryController:GetValidRecycleDropGridData()
                if RecycleDropGridData then
                    InventoryController:CustomOnDrop(RecycleDropGridData)
                    IsHandled = true
                end
            end
        end
    end
    return IsHandled and UE4.UWidgetBlueprintLibrary.Handled() or UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnTouchEnded(MyGeometry, TouchEvent)
    return self:OnMouseButtonUp(MyGeometry, TouchEvent)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
   if CurInputDevice == ECommonInputType.MouseAndKeyboard then
        self.Key_Recycle:SetVisibility(ESlateVisibility.Collapsed)
        self:EnterSortDetail(false)
    elseif CurInputDevice == ECommonInputType.Gamepad then
        self.Key_Recycle:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

function M:OnDPadUpKey()
    if self.bOpenRecycle then
        self:EnterSortDetail(true)
    end
end

return M
