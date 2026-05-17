
local InventoryModel = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryModel")
local InventoryCommonConst = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryCommonConst")
local TimeUtils = require "Utils.TimeUtils"
local SoloTreasureUtils = require "Utils.SoloTreasureUtils"
--- @class InventoryController :Controller
local InventoryController = Class()
InventoryController._components = {
    "BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.ItemMoveComponent",
    "BluePrints.UI.BP_EMUserWidgetUtils_C",
}

InventoryController.bUseClientCalMovePos = true -- 是否客户端计算移动位置
InventoryController.bOpenClientPredict = false  -- 移动物品是否开启客户端预测

-- ====== 拖拽状态（ItemMoveComponent 写入，此处声明默认值） ======
-- 当前是否处于拖拽中；为 true 时吸附系统全部暂停
InventoryController.bDraging = false

-- ====== 手柄吸附系统（每次 OnMainWidgetLoaded / OnMainWidgetClosed 全量重置） ======
-- 当前吸附请求，结构 { Widget, Priority, bApplied }；nil 表示无待执行吸附
InventoryController._Adsorption = nil
-- 摇杆锁定型强制吸附标记（由 RequestForceAdsorption/ReleaseForceAdsorption 管理）；为 true 时摇杆输入被拦截
InventoryController.ForceAdsorption = false
-- Drop 后短暂禁止 LOW 级吸附（0.2s 计时器控制，HIGH/FORCE 不受影响）
InventoryController.bForbidAdsorption = false
-- 光标连续静止的累计时间（秒）；HIGH/LOW 吸附等待达到 IdleTimeToTryAdsorption 后才执行
InventoryController._MouseIdleTime = 0
-- 玩家摇杆累计移动像素；超过 AdsorptionCancelThreshold 才认为是有意图移动，触发取消/重置吸附
InventoryController._AdsorptionMoveDist = 0
-- 目标 widget geometry 持续为零的累计时间（秒）；超过阈值则认为 widget 已离开 widget tree，强制放弃吸附
InventoryController._AdsorptionZeroSizeTime = 0
-- 物品详情弹窗已打开；为 true 时禁止 RequestAdsorption 和 Tick 中的吸附逻辑
InventoryController.bOpenItemDetails = false
-- 回收站排序面板已打开；为 true 时禁止 UpdateGamepadCursorPosition 重新获焦
InventoryController.bOpenRecycleSortDetail = false
-- 献祭弹窗/气泡已打开；为 true 时禁止 UpdateGamepadCursorPosition 重新获焦
InventoryController.bOpenSacrificePopup = false
-- 当前打开的献祭面板对应的 Pocket 名（由 BagSacrifice 的 OnSacrificeOverlayOpen 写入）
InventoryController._SacrificePocketName = nil
function InventoryController:Init(Params)
    DebugPrint("lgc@InventoryController Init  bInit =", self.bInit)
    if not Params or not Params.bServerInit then
        if self.bInit then
            return
        end
    else
        if self.bServerInit then
            return
        end
    end
    self.InventoryModel = InventoryModel
    self.InventoryModel:Init(Params)
    local ServerEntity = GWorld:GetServerEntity()
    if not ServerEntity then return end
    self.Dungeonobject = ServerEntity:GetDungeonObject()
    if not self.Dungeonobject then return end
    self.bInit = true
    if Params.bServerInit then
        self.bServerInit = true
    end
    self:InitRecycleAndBagPocketDatas()
    self:InitEvents()
end

function InventoryController:InitRecycleAndBagPocketDatas()
    --Bag
    local BagInfo = DataMgr.ExtractionTreasureBag[self.InventoryModel.BagId]
    if not self.CurBagPocketNames and BagInfo then
        local ShapeType = BagInfo.ShapeType and BagInfo.ShapeType + 1 or nil
        local Shape = BagInfo.Shape
        local TypeSuffix = ShapeType and string.format("%02d", ShapeType) or nil
        if TypeSuffix then
            local CurMap = {}
            local i = 1
            while Shape and Shape[i] do
                local BagSuffix = string.format("%02d", i)
                local PocketName = "WBP_Type" .. TypeSuffix .. "_Bag" .. BagSuffix
                CurMap[PocketName] ={ 
                    Shape = Shape and Shape[i] or nil, 
                    SubBagIndex = i,
                }
                i = i + 1
            end
            self.CurBagPocketNames = CurMap
        end
    end

    for PocketName, PocketShapeAndIndex in pairs(self.CurBagPocketNames) do
        local PocketData = nil
        if not self.InventoryModel.Pockets[PocketName] then
            PocketData = {
                Name = PocketName,
                Size = FVector2D(PocketShapeAndIndex.Shape[1], PocketShapeAndIndex.Shape[2]),
                Parent = nil,
                Inventory = InventoryCommonConst.PocketType.Bag,
                SubBagIndex = PocketShapeAndIndex.SubBagIndex,
            }
            self.InventoryModel.Pockets[PocketName] = PocketData
            self:InitGridsData(PocketData)
        end
    end

    self:UpdateRecyclePocketDatas()
end

function InventoryController:UpdateRecyclePocketDatas()
    --Recycle
    local TargetEmpty = InventoryCommonConst.RecycleListEmptyNum
    local EmptyRecycleNames = {}
    for PocketName, PocketData in pairs(self.InventoryModel.Pockets) do
        if PocketData.bRecycle then
            local IsEmpty = false
            if not self.InventoryModel.TreasureItems[PocketName] or not next(self.InventoryModel.TreasureItems[PocketName]) then
                IsEmpty = true
            end
            if IsEmpty then
                table.insert(EmptyRecycleNames, PocketName)
            end
        end
    end
    local CurEmpty = #EmptyRecycleNames
    if CurEmpty < TargetEmpty then
        for i = 1, (TargetEmpty - CurEmpty) do
            self:AddEmptyRecyclePocketData()
        end
    elseif CurEmpty > TargetEmpty then
        for i = 1, (CurEmpty - TargetEmpty) do
            self:RemoveEmptyRecyclePocketData()
        end
    end
end

function InventoryController:OnMainWidgetLoaded(Params)
    DebugPrint("lgc@InventoryController OnMainWidgetLoaded  bInit =", self.bInit)
    self.MainWidget = Params.MainWidget
    self.LastTargetGridDatas = {}
    -- 拖拽状态：极端情况（背包强制关闭时拖拽仍在进行）下 bDraging 可能残留 true，阻塞吸附
    self.bDraging = false
    -- 吸附系统全量重置
    self._Adsorption = nil
    self.ForceAdsorption = false
    self.bForbidAdsorption = false
    self._MouseIdleTime = 0
    self._AdsorptionMoveDist = 0
    self._AdsorptionZeroSizeTime = 0
    self.bOpenItemDetails = false
    self.bOpenRecycleSortDetail = false
    self.bOpenSacrificePopup = false
    self._SacrificePocketName = nil
    self.SelectedItemWidget = nil
    self.SelectedGridWidget = nil
    -- 第 0 帧立即隐藏光标，防止在位置初始化之前（PCSetFocus 延迟 10 帧）出现在左上角
    if self.MainWidget.BagSelect_Controller then
        self.MainWidget.BagSelect_Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self:InitBagPocketGridTreasureSection()
end

function InventoryController:InitBagPocketGridTreasureSection()
    if not self.MainWidget then return end
    if not self.InventoryModel.BagId then
        return
    end
    local BagInfo = DataMgr.ExtractionTreasureBag[self.InventoryModel.BagId]
    if self.CurBagPocketNames and BagInfo then
        local ShapeType = BagInfo.ShapeType
        if ShapeType then
            self.MainWidget.Switch_BagType:SetActiveWidgetIndex(ShapeType)
        end
    else
        return
    end
    self.MainWidget.DelayFrame = 5
    for PocketName, PocketShapeAndIndex in pairs(self.CurBagPocketNames) do
        if self.MainWidget[PocketName] and IsValid(self.MainWidget[PocketName]) then
            self.MainWidget:AddDelayFrameFunc(function() -- 分帧加载，优化卡顿
                local PocketData = nil
                if not self.InventoryModel.Pockets[PocketName] then
                    PocketData = {
                        Name = PocketName,
                        Size = FVector2D(PocketShapeAndIndex.Shape[1], PocketShapeAndIndex.Shape[2]),
                        Parent = self.MainWidget,
                        Inventory = InventoryCommonConst.PocketType.Bag,
                    }
                end
                self.MainWidget[PocketName]:Init({
                    Name = PocketName,
                    Size = FVector2D(PocketShapeAndIndex.Shape[1], PocketShapeAndIndex.Shape[2]),
                    Parent = self.MainWidget,
                    Inventory = InventoryCommonConst.PocketType.Bag,
                    PocketData = PocketData,
                    SubBagIndex = PocketShapeAndIndex.SubBagIndex,
                })
            end, self.MainWidget.DelayFrame, "InitPocket" .. PocketName)
            self.MainWidget.DelayFrame = self.MainWidget.DelayFrame + 1
        end
    end
end

function InventoryController:Destory()
    DebugPrint("lgc@InventoryController Destory  bInit =", self.bInit)
    if not self.bInit then return end
    self:RemoveEvents()
    InventoryModel:Destory()
    self.bInit = false
    self.bServerInit = false
    self._TreasureIconCache = nil
    self._SacrificePocketName = nil
end

function InventoryController:OnMainWidgetClosed()
    DebugPrint("lgc@InventoryController OnMainWidgetClosed  bInit =", self.bInit)
    self.MainWidget = nil
    self.LastTargetGridDatas = {}
    -- 拖拽状态：关闭时强制清除，防止残留阻塞下次打开的吸附逻辑
    self.bDraging = false
    -- 吸附系统全量重置
    self._Adsorption = nil
    self.ForceAdsorption = false
    self.bForbidAdsorption = false
    self._MouseIdleTime = 0
    self._AdsorptionMoveDist = 0
    self._AdsorptionZeroSizeTime = 0
    self.bOpenItemDetails = false
    self.bOpenRecycleSortDetail = false
    self.bOpenSacrificePopup = false
    self._SacrificePocketName = nil
    self.SelectedItemWidget = nil
    self.SelectedGridWidget = nil
    for CurBagPocketName, CurBagPocketShapeAndIndex in pairs(self.CurBagPocketNames) do
        self:ClearPocketView(CurBagPocketName)
    end
    if self.MainWidget then
        self.MainWidget:BlockAllUIInput(false)
    end
end

function InventoryController:GetPocketWidget(PocketName)
    local PocketData = self.InventoryModel.Pockets[PocketName]
    if not PocketName or not PocketData or not IsValid(PocketData.Pocket) then return end
    return PocketData.Pocket
end

function InventoryController:GetGridData(PocketName, Position)
    local Ret = nil
    if PocketName and Position and self.InventoryModel.Grids[PocketName] and self.InventoryModel.Grids[PocketName][Position.X] and self.InventoryModel.Grids[PocketName][Position.X][Position.Y] then
        Ret = self.InventoryModel.Grids[PocketName][Position.X][Position.Y]
    end
    return Ret
end

function InventoryController:InitEvents()
    self:AddDispatcher(EventID.OnSoloTreasureGetTicket, self, function(_, TicketId)
        self:UpdateTreasureDatasByTicketId(TicketId)
    end)
    self:AddDispatcher(EventID.OnTreasureItemDrop, self, function()
        self:UpdateTreasureDatasByTicketId(self.Dungeonobject and self.Dungeonobject.SoloTreasureTicketId)
    end)
end

function InventoryController:RemoveEvents()
    self:RemoveDispatcher(EventID.OnSoloTreasureGetTicket, self)
end

function InventoryController:Tick(Geometry, DeltaTime)
    self:TickDragWidgetPos(Geometry, DeltaTime)
    if UIUtils.IsGamepadInput() and not self.bDraging and not self.bOpenItemDetails then
        self:TickTryAdsorptionWidget(Geometry, DeltaTime)
    else
        self._MouseIdleTime = 0
    end
end

function InventoryController:TickDragWidgetPos(Geometry, DeltaTime)
    if self.DragWidget and IsValid(self.DragWidget) and self.bDraging then
        local MousePos
        local Image = self.DragWidget.Prop_Icon
        local Brush = Image and self.DragWidget.Prop_Icon.Brush
        MousePos = UE4.UWidgetLayoutLibrary.GetMousePositionOnViewport(self.MainWidget)
        local BrushOffset = Image.bUsing4KImageDesign and (Brush and Brush.ImageSize / 4 or FVector2D(0, 0)) or (Brush and Brush.ImageSize / 2 or FVector2D(0, 0))
        MousePos = FVector2D(MousePos.X - BrushOffset.X, MousePos.Y - BrushOffset.Y)
        self.DragWidget:SetRenderTranslation(MousePos)
    end
end

function InventoryController:TickTryAdsorptionWidget(Geometry, DeltaTime)
    if not self.MainWidget then return end
    if not UIUtils.IsGamepadInput() then return end
    -- 拖拽期间光标由拖拽逻辑接管，吸附不介入
    if self.bDraging then return end

    local Current = self.MainWidget.BagSelect_Controller.RenderTransform.Translation
    local Target  = self.MainWidget.GamepadCursorTargetPosition
    local bCursorMoving = (Current.X ~= Target.X or Current.Y ~= Target.Y)

    if bCursorMoving then
        self._MouseIdleTime = 0
    else
        self._MouseIdleTime = (self._MouseIdleTime or 0) + DeltaTime
    end

    -- 判断玩家是否有意图移动：累计拨杆位移超过阈值才取消/重置吸附，防止误触
    if self._Adsorption then
        local moveDist = self._AdsorptionMoveDist or 0
        local Threshold = InventoryCommonConst.AdsorptionCancelThreshold
        if moveDist > Threshold then
            local P = self._Adsorption.Priority
            local Const = InventoryCommonConst.AdsorptionPriority
            if P == Const.LOW then
                -- 玩家有意图移动：取消一次性定位
                self._Adsorption = nil
                DebugPrint("lgc@Adsorption 玩家有意图移动，取消 LOW 吸附")
            elseif P == Const.HIGH then
                -- HIGH（悬停跟随）：重置 bApplied，停下后重新 snap
                self._Adsorption.bApplied = false
            end
            -- FORCE：不受玩家移动影响
            self._AdsorptionMoveDist = 0  -- 重置累计量，下次需重新积累才能再次触发
        end
    end

    if not self._Adsorption or not IsValid(self._Adsorption.Widget) then
        self._Adsorption = nil
        return
    end

    local Priority    = self._Adsorption.Priority
    local Const       = InventoryCommonConst.AdsorptionPriority
    local bForce      = (Priority == Const.FORCE)
    local bTimeReached = (self._MouseIdleTime or 0) >= InventoryCommonConst.IdleTimeToTryAdsorption

    -- LOW/HIGH：等待静止阈值；FORCE：立即执行
    if not bForce and not bTimeReached then return end
    -- LOW/HIGH：已执行过且光标未移动，不重复计算（光标移动时 bApplied 已被重置）
    if self._Adsorption.bApplied then return end

    -- 计算并应用光标偏移
    -- 注意：Offset 叠加到 GamepadCursorTargetPosition（目标位置）上，
    -- 必须用 TargetPos 而非当前渲染位置，否则动画插值期间会产生双重偏差
    local CursorParentGeo = self.MainWidget.BagSelect_Controller:GetParent():GetCachedGeometry()
    local AdsGeo  = self._Adsorption.Widget:GetCachedGeometry()
    local AdsAbs  = UE4.UUIFunctionLibrary.GetGeometryAbsolutePosition(AdsGeo)
    local AdsSize = UE4.USlateBlueprintLibrary.GetAbsoluteSize(AdsGeo)
    -- widget geometry 为零：可能是首帧尚未布局，也可能是 widget 已离开 widget tree（面板关闭但未 GC）
    -- 累计等待时间，超过阈值则强制放弃此次吸附，避免高优先级残留永久阻塞低优先级请求
    if AdsSize.X == 0 and AdsSize.Y == 0 then
        self._AdsorptionZeroSizeTime = (self._AdsorptionZeroSizeTime or 0) + DeltaTime
        if self._AdsorptionZeroSizeTime > 0.3 then
            self._Adsorption = nil
            self._AdsorptionZeroSizeTime = 0
        end
        return
    end
    self._AdsorptionZeroSizeTime = 0

    local AdsCenter = FVector2D(AdsAbs.X + AdsSize.X / 2, AdsAbs.Y + AdsSize.Y / 2)
    local AdsCenterLocal = UE4.USlateBlueprintLibrary.AbsoluteToLocal(CursorParentGeo, AdsCenter)

    -- AddGamepadCursorOffset 的语义：X += Offset.X，Y -= Offset.Y
    -- TargetPos 是光标的渲染原点（左上角），需要减去光标半尺寸才能让光标中心对齐物品中心
    if not self._halfW or not self._halfH or self._halfW == 0 or self._halfH == 0 then
        local CursorGeo = self.MainWidget.BagSelect_Controller:GetCachedGeometry()
        local CursorLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(CursorGeo)
        self._halfW = CursorLocalSize.X / 2
        self._halfH = CursorLocalSize.Y / 2
    end
    local TargetPos = self.MainWidget.GamepadCursorTargetPosition
    local Offset = FVector2D(
        AdsCenterLocal.X - TargetPos.X - (self._halfW == 0 and 29 or self._halfW),
        TargetPos.Y + (self._halfH == 0 and 29 or self._halfH) - AdsCenterLocal.Y
    )
    self.MainWidget:AddGamepadCursorOffset(Offset)

    if Priority == Const.LOW then
        self._Adsorption = nil  -- 单次定位完成后清除
    elseif Priority == Const.FORCE and not self.ForceAdsorption then
        self._Adsorption = nil  -- 一次性 FORCE（搜索开始/回收站打开）：snap 后立即清除，不阻塞后续吸附请求
    else
        self._Adsorption.bApplied = true  -- 已 snap，等下次光标移动再重置
    end
end

-- 请求吸附到指定 Widget。
-- Priority: LOW=一次性定位(受bForbidAdsorption限制), HIGH=持续跟随, FORCE=强制(含摇杆锁定)
-- HIGH/FORCE 无视 bForbidAdsorption；高优先级不会被低优先级覆盖
function InventoryController:RequestAdsorption(TargetWidget, Priority)
    if not UIUtils.IsGamepadInput() then return end
    if self.bDraging or self.bOpenItemDetails then return end
    local P = Priority or InventoryCommonConst.AdsorptionPriority.LOW
    if P == InventoryCommonConst.AdsorptionPriority.LOW and self.bForbidAdsorption then return end
    -- 已有吸附且优先级更高，不覆盖
    if self._Adsorption and self._Adsorption.Priority > P then return end
    -- 同 Widget 同优先级，不重复设置
    if self._Adsorption
        and self._Adsorption.Widget == TargetWidget
        and self._Adsorption.Priority == P then
        return
    end
    self._Adsorption = { Widget = TargetWidget, Priority = P, bApplied = false }
    self._AdsorptionMoveDist = 0       -- 新吸附建立时重置移动累计，防止旧移动量立即触发取消
    self._AdsorptionZeroSizeTime = 0   -- 新吸附建立时重置零尺寸计时器
end

-- 放弃吸附请求。CancelMaxPriority 仅取消 <= 该优先级的请求（默认取消全部）
function InventoryController:RequestAbandonAdsorption(TargetWidget, CancelMaxPriority)
    if not self._Adsorption then return end
    if self._Adsorption.Widget ~= TargetWidget then return end
    local MaxP = CancelMaxPriority or InventoryCommonConst.AdsorptionPriority.FORCE
    if self._Adsorption.Priority <= MaxP then
        self._Adsorption = nil
    end
end

-- 强制吸附（如拖入回收站），同时锁定摇杆输入
function InventoryController:RequestForceAdsorption(TargetWidget)
    self.ForceAdsorption = true
    self:RequestAdsorption(TargetWidget, InventoryCommonConst.AdsorptionPriority.FORCE)
end

function InventoryController:ReleaseForceAdsorption()
    self.ForceAdsorption = false
    if self._Adsorption and self._Adsorption.Priority == InventoryCommonConst.AdsorptionPriority.FORCE then
        self._Adsorption = nil
    end
end

-- 在给定口袋名列表（array）中查找第一个有效的 Treasure Widget
-- 按行优先顺序（Y 升序 → X 升序）遍历，保证返回最左上角的物品
function InventoryController:_FindFirstTreasureInPocketsByNames(SortedPocketNames)
    for _, PocketName in ipairs(SortedPocketNames) do
        local GridDatas = self.InventoryModel.Grids[PocketName]
        if GridDatas then
            -- pairs() 不保证整数 key 的遍历顺序，必须手动排序
            -- 收集所有 (X, Y) → GridData 映射，再按 Y 升序、X 升序排序
            local Cells = {}
            for X, Col in pairs(GridDatas) do
                for Y, GridData in pairs(Col) do
                    Cells[#Cells + 1] = { X = X, Y = Y, Data = GridData }
                end
            end
            table.sort(Cells, function(a, b)
                if a.Y ~= b.Y then return a.Y < b.Y end
                return a.X < b.X
            end)
            for _, Cell in ipairs(Cells) do
                local GridData = Cell.Data
                if GridData and GridData.TreasureData and IsValid(GridData.TreasureData.Treasure) then
                    -- 必须校验 geometry 非零：widget 有效但不在 widget tree 时（如已关闭的容器面板）
                    -- GetCachedGeometry size 为 0，此时不能吸附，否则会卡死在不可见目标上
                    local Geo = GridData.TreasureData.Treasure:GetCachedGeometry()
                    local AbsSize = UE4.USlateBlueprintLibrary.GetAbsoluteSize(Geo)
                    if AbsSize.X > 0 or AbsSize.Y > 0 then
                        return GridData.TreasureData.Treasure
                    end
                end
            end
        end
    end
    return nil
end

-- 吸附优先级：搜索容器 > 献祭面板 > 背包 > 屏幕中心
-- 用于手柄模式初始化或热切换时自动定位光标
function InventoryController:RequestAdsorptionToFirstTreasure()
    local Const = InventoryCommonConst
    local SacrificePocketName = self._SacrificePocketName
    local Prefix = Const.SearchPocketNamePrefix

    -- 1. 搜索容器口袋（非献祭）
    for PocketName in pairs(self.InventoryModel.Grids) do
        if string.sub(PocketName, 1, #Prefix) == Prefix and PocketName ~= SacrificePocketName then
            local W = self:_FindFirstTreasureInPocketsByNames({PocketName})
            if W then
                self:RequestAdsorption(W, Const.AdsorptionPriority.LOW)
                return
            end
        end
    end

    -- 2. 献祭面板（仅当面板已打开且有物品）
    if self.bOpenSacrificePopup and SacrificePocketName then
        local SacWidget = self:_FindFirstTreasureInPocketsByNames({SacrificePocketName})
        if SacWidget then
            self:RequestAdsorption(SacWidget, Const.AdsorptionPriority.LOW)
            return
        end
    end

    -- 3. 背包口袋（按 _Bag<N> 数字升序）
    local SortedBagNames = {}
    for PocketName in pairs(self.CurBagPocketNames or {}) do
        table.insert(SortedBagNames, PocketName)
    end
    table.sort(SortedBagNames, function(a, b)
        local aSuffix = tonumber(string.match(a, "_Bag(%d+)"))
        local bSuffix = tonumber(string.match(b, "_Bag(%d+)"))
        if aSuffix and bSuffix then return aSuffix < bSuffix end
        if aSuffix then return true end
        if bSuffix then return false end
        return a < b
    end)
    local BagWidget = self:_FindFirstTreasureInPocketsByNames(SortedBagNames)
    if BagWidget then
        self:RequestAdsorption(BagWidget, Const.AdsorptionPriority.LOW)
        return
    end

    -- 4. 兜底：重置到屏幕中心
    if self.MainWidget and self.MainWidget.ResetCursorToCenter then
        self.MainWidget:ResetCursorToCenter()
    end
end

function InventoryController:RequestSelected(TargetWidget)
    if self.SelectedItemWidget and self.SelectedItemWidget == TargetWidget then
        return
    end
    if self.SelectedItemWidget then
        self.SelectedItemWidget:SetSelected(false)
    end
    self.SelectedItemWidget = TargetWidget
    self.SelectedItemWidget:SetSelected(true)
end

function InventoryController:RequestUnSelected(TargetWidget)
    if self.SelectedItemWidget and self.SelectedItemWidget == TargetWidget then
        self.SelectedItemWidget:SetSelected(false)
        self.SelectedItemWidget = nil
    end
end

function InventoryController:RequestSelectedGrid(TargetGrid)
    if self.SelectedGridWidget and self.SelectedGridWidget == TargetGrid then
        return
    end
    self.SelectedGridWidget = TargetGrid
end

function InventoryController:RequestUnSelectedGrid(TargetGrid)
    if self.SelectedGridWidget and self.SelectedGridWidget == TargetGrid then
        self.SelectedGridWidget = nil
    end
end

function InventoryController:RequestUpdateView(PendingUpdateData)
    if not PendingUpdateData then return end
    if PendingUpdateData.TreasureId then
        if PendingUpdateData.bInRecycleGrid and not PendingUpdateData.PutInRecycleTime then
            PendingUpdateData.PutInRecycleTime = TimeUtils.NowTimeMs()
        elseif not PendingUpdateData.bInRecycleGrid then
            PendingUpdateData.PutInRecycleTime = nil
        end
    end
    if IsValid(PendingUpdateData.Treasure) then
        PendingUpdateData.Treasure:UpdateView({
            NewPocketName = PendingUpdateData.PocketName,
            NewPosition = PendingUpdateData.Position,
            NewDirection = PendingUpdateData.Direction,
            bDrag = PendingUpdateData.bDrag,
            bInRecycleGrid = PendingUpdateData.bInRecycleGrid,
        })
    --elseif IsValid(PendingUpdateData.Pocket) then
    elseif IsValid(PendingUpdateData.Grid) then
        PendingUpdateData.Grid:UpdateView({
            bCanMove = PendingUpdateData.bCanMove,
            bReset = PendingUpdateData.bReset,
        })
    end
end


function InventoryController:CustomOnDragDetected(DragGridData, Operation)
    if not self.bDraging and self.MainWidget and self.MainWidget.CanvasDrag then
        self.DragWidget = Operation.DefaultDragVisual
        self.DragWidget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.MainWidget.CanvasDrag:AddChild(self.DragWidget)
        self.bDraging = true
        self.Operation = Operation
        self.StartDragGridData = DragGridData
        self.DragDetectedRequestID = self.DragDetectedRequestID or 0
        self.DragDetectedRequestID = self.DragDetectedRequestID + 1
        if self.DragDetectedRequestID >= math.maxinteger then
            self.DragDetectedRequestID = 0
        end
        EventManager:FireEvent(EventID.OnTreasureItemDragDetected, DragGridData)
        self:NotifyDragUp(DragGridData)
    end
end

function InventoryController:CustomOnDragCancelled(bDropSuccess)
    local StartDragGridData = self.StartDragGridData
    -- 再去Notify更新视图层
    self:NotifyDragOverGrids(StartDragGridData, nil)
    self:ClearDragState()
    if not bDropSuccess then
        UIManager(self):ShowUITip("CommonToastMain", GText("UI_Extraction_SpaceCannotUse"), 2)
    end
    EventManager:FireEvent(EventID.OnTreasureItemDragCancelled, StartDragGridData)
end

function InventoryController:CustomOnDragEnter(DragEnterGridData, MyGeometry, PointerEvent)
    local StartDragGridData = self.StartDragGridData
    if not StartDragGridData or not DragEnterGridData then return end
    if DragEnterGridData.bRecycle and StartDragGridData.bRecycle then
        return
    end
    self.CurDragEnterGridData = DragEnterGridData
    self:NotifyDragOverGrids(StartDragGridData, DragEnterGridData)
end

function InventoryController:CustomOnDragLeave(DragLeaveGridData, PointerEvent)
    local StartDragGridData = self.StartDragGridData
    if not StartDragGridData or not DragLeaveGridData then return end
    self:NotifyDragOverGrids(StartDragGridData, nil)
end

function InventoryController:CustomOnDrop(DropGridData)
    local StartDragGridData = self.StartDragGridData
    if not StartDragGridData or not DropGridData then return end
    local bDropSuccess = self:TryDropAndSwitchItem(StartDragGridData, DropGridData)
    if not bDropSuccess then
        EventManager:FireEvent(EventID.OnTreasureItemDragCancelled)
        UIManager(self):ShowUITip("CommonToastMain", GText("UI_Extraction_SpaceCannotUse"), 2)
    end
    return bDropSuccess
end

function InventoryController:QuickTransferFromGrid(DragGridData, QuickTransferType)
    if not DragGridData or not QuickTransferType then return false end
    local TreasureData = DragGridData and DragGridData.TreasureData or nil
    if not TreasureData then return false end
    local bSuccess = false
    local MoveInfo = nil
    MoveInfo = self:GetItemMoveData(DragGridData, nil, QuickTransferType)
    if MoveInfo and MoveInfo.bCanMove then
        self.StartDragGridData = DragGridData
        bSuccess = self:TryDropAndSwitchItem(DragGridData, nil, MoveInfo)
    end
    
    if not bSuccess then
        local BagGridOccupancyData = self:GetBagGridOccupancyData()
        local TreasureSize = TreasureData.Size and TreasureData.Size.X * TreasureData.Size.Y or 0
        if BagGridOccupancyData and BagGridOccupancyData.OccupancyGridNum and BagGridOccupancyData.AllGridNum 
            and BagGridOccupancyData.OccupancyGridNum + TreasureSize > BagGridOccupancyData.AllGridNum then
            UIManager(self):ShowUITip("CommonToastMain", GText("UI_Extraction_InsufficientSpace"), 2)
        else
            UIManager(self):ShowUITip("CommonToastMain", GText("UI_Extraction_SpaceCannotUse"), 2)
        end
    end
    return bSuccess
end

function InventoryController:NotifyDragUp(DragGridData) -- 视图层更新
    if not DragGridData then return end
    local Treasure = (DragGridData and DragGridData.TreasureData) and DragGridData.TreasureData.Treasure or nil
    if not Treasure then return end
    local UpdateParams = {
        bDrag = true,
        Treasure = Treasure,
        bInRecycleGrid = Treasure.bInRecycleGrid,
    }
    self:RequestUpdateView(UpdateParams)
    self:NotifyDragOverGrids(DragGridData, DragGridData)
end

function InventoryController:NotifyDragOverGrids(DragGridData, OverDropGridData) -- 视图层更新
    if UIUtils.IsGamepadInput() then
        self.CurNotifyOverDragGridData = DragGridData
        self.CurNotifyOverDropGridData = OverDropGridData
    end
    -- 相同的拖拽源和目标格子结果不变，跳过重算（方向切换前由 GamepadChangeDragWidgetDirection 主动清除）
    local Cache = self._NotifyDragOverGridsCache
    if Cache and Cache.DragGridData == DragGridData and Cache.OverDropGridData == OverDropGridData then
        return
    end
    self._NotifyDragOverGridsCache = { DragGridData = DragGridData, OverDropGridData = OverDropGridData }

    local MoveInfo = self:GetItemMoveData(DragGridData, OverDropGridData)
    self.NewTargetGridDatas = {}
    local TargetDirection = nil
    if MoveInfo.EndInfo.Type == "Grid" then
        if MoveInfo.EndInfo.TopLeft and MoveInfo.EndInfo.ValidTopLeftList[1] then
            local TopLeft = MoveInfo.EndInfo.TopLeft
            local Width, Height = self:GetWHByDir(MoveInfo.StartInfo.DragGridData.TreasureData.Size, MoveInfo.EndInfo.Direction)
            self.NewTargetGridDatas = self:GetTargetGridDatas(MoveInfo.EndInfo.PocketData.Name, TopLeft, Width, Height)
            TargetDirection = MoveInfo.EndInfo.Direction
        elseif MoveInfo.EndInfo.AllInvalidResults[1] then
            local MaxTargetGridDatas = {}
            for _, InvalidTopLeftInfo in ipairs(MoveInfo.EndInfo.AllInvalidResults) do
                local Width, Height = self:GetWHByDir(MoveInfo.StartInfo.DragGridData.TreasureData.Size, InvalidTopLeftInfo[1])
                local TargetGridDatas = self:GetTargetGridDatas(MoveInfo.EndInfo.PocketData.Name, InvalidTopLeftInfo[2], Width, Height)
                if #TargetGridDatas > #MaxTargetGridDatas then
                    MaxTargetGridDatas = TargetGridDatas
                    TargetDirection = InvalidTopLeftInfo[1]
                end
            end
            for _, GridData in ipairs(MaxTargetGridDatas) do
                table.insert(self.NewTargetGridDatas, GridData)
            end
        end
    end
    if TargetDirection then
        local DefaultDragVisual = (MoveInfo.StartInfo.DragGridData.TreasureData and MoveInfo.StartInfo.DragGridData.TreasureData.Treasure) and MoveInfo.StartInfo.DragGridData.TreasureData.Treasure.DefaultDragVisual
        local bSquare = MoveInfo.StartInfo.DragGridData.TreasureData and MoveInfo.StartInfo.DragGridData.TreasureData.Size.X == MoveInfo.StartInfo.DragGridData.TreasureData.Size.Y
        if DefaultDragVisual and not bSquare then
            if TargetDirection == InventoryCommonConst.Direction.Vertical then
                DefaultDragVisual.Prop_Icon:SetRenderTransformAngle(90)
            elseif TargetDirection == InventoryCommonConst.Direction.Horizontal then
                DefaultDragVisual.Prop_Icon:SetRenderTransformAngle(0)
            end
        end
    end
    local UpdateParams = {
        bCanMove = MoveInfo.bCanMove,
        bReset = false,
    }
    for _, GridData in ipairs(self.NewTargetGridDatas) do
        if IsValid(GridData.Grid) then
            UpdateParams.Grid = GridData.Grid
            self:RequestUpdateView(UpdateParams)
            GridData.Grid.bUpdated = true
        end
    end
    UpdateParams = {
        bCanMove = nil,
        bReset = true,
    }
    for _, GridData in ipairs(self.LastTargetGridDatas) do
        if IsValid(GridData.Grid) and not GridData.Grid.bUpdated then
            UpdateParams.Grid = GridData.Grid
            self:RequestUpdateView(UpdateParams)
        end
    end
    for _, GridData in ipairs(self.NewTargetGridDatas) do
        if IsValid(GridData.Grid) then
            GridData.Grid.bUpdated = false
        end
    end
    self.LastTargetGridDatas = self.NewTargetGridDatas
end

function InventoryController:TryDropAndSwitchItem(DragGridData, DropGridData, QuickMoveInfo) --控制器层,条件检测
    self:NotifyDragOverGrids(DragGridData, nil)
    self:ClearDragState()
    if self.PendingApplyMoveInfo then
        return false
    end
    local PendingApplyMoveInfo = nil
    if not QuickMoveInfo then
        PendingApplyMoveInfo = self:GetItemMoveData(DragGridData, DropGridData)
        if PendingApplyMoveInfo and not PendingApplyMoveInfo.bCanMove then 
            return false 
        end
    end
    self.PendingApplyMoveInfo = QuickMoveInfo or PendingApplyMoveInfo

    if not self.PendingApplyMoveInfo.EndInfo.EffectedTreasureItemList or not self.bUseClientCalMovePos then
        local StartInfo = self.PendingApplyMoveInfo.StartInfo
        local StartGridData = StartInfo and StartInfo.DragGridData or nil
        local StartPocketData = StartInfo and StartInfo.PocketData or nil
        local EndInfo = self.PendingApplyMoveInfo.EndInfo
        local EndGridData = EndInfo and EndInfo.DropGridData or nil
        local EndPocketData = EndInfo and EndInfo.PocketData or nil

        local TargetTreasureUid = nil
        if StartInfo and StartInfo.DragGridData and StartInfo.DragGridData.TreasureData and StartInfo.DragGridData.TreasureData.UUid then
            TargetTreasureUid = StartInfo.DragGridData.TreasureData.UUid
        end
        local IsRotate = false
        if StartInfo and EndInfo and StartInfo.Direction and EndInfo.Direction and StartInfo.Direction ~= EndInfo.Direction then
            IsRotate = true
        end
        local TargetPosition = nil
        if EndGridData and EndInfo.TopLeft then
            if EndPocketData and EndPocketData.Size then
                TargetPosition = self:ClientPosition2ServerPos(EndInfo.TopLeft, EndPocketData.Size)
            end
        end
        local TargetBagIndex = nil
        local TargetSubBagIndex = nil
        -- 移动到容器
        if not TargetBagIndex and EndPocketData.Inventory == InventoryCommonConst.PocketType.Mechanism then
            TargetBagIndex = EndPocketData.MechanismUid
            TargetSubBagIndex = 0
        end
        -- 移动到回收站
        if not TargetBagIndex and EndPocketData.Inventory == InventoryCommonConst.PocketType.Recycle then
            TargetBagIndex = -1
            TargetSubBagIndex = EndPocketData.RecycleIndex
        end
        -- 移动到玩家背包
        if not TargetBagIndex and EndPocketData.Inventory == InventoryCommonConst.PocketType.Bag then
            TargetBagIndex = 0
            TargetSubBagIndex = EndPocketData.SubBagIndex
        end
        if not self.Dungeonobject then 
            GWorld.logger.error("Dungeonobject == nil")
            return false 
        end
        self.Dungeonobject:NotifyServerDungeonEvent("MoveTreasureItem", TargetTreasureUid, TargetBagIndex, TargetSubBagIndex, TargetPosition, IsRotate)
    elseif self.PendingApplyMoveInfo.EndInfo.EffectedTreasureItemList and self.bUseClientCalMovePos then
        local ServerEffectedTreasureItemList = {}
        for _, EffectedTreasureItem in ipairs(self.PendingApplyMoveInfo.EndInfo.EffectedTreasureItemList) do
            local BagIndex = -1
            local SubBagIndex = 0
            local NewPocketData = self.InventoryModel.Pockets[EffectedTreasureItem.NewPocketName]
            if string.startswith(EffectedTreasureItem.NewPocketName, InventoryCommonConst.RecyclePocketNamePrefix) then
                BagIndex = -1
                SubBagIndex = NewPocketData.RecycleIndex
            elseif string.startswith(EffectedTreasureItem.NewPocketName, InventoryCommonConst.SearchPocketNamePrefix) then
                BagIndex = NewPocketData.MechanismUid
            elseif string.startswith(EffectedTreasureItem.NewPocketName, "WBP_Type") then
                BagIndex = 0
                SubBagIndex = NewPocketData.SubBagIndex
            end
            local Rotate = EffectedTreasureItem.NewDir == InventoryCommonConst.Direction.Vertical
            local Pos = self:ClientPosition2ServerPos(EffectedTreasureItem.NewTopLeft, NewPocketData and NewPocketData.Size)
            local ServerTreasureItem = {
                Id = EffectedTreasureItem.TreasureData.TreasureId,
                UniqueId = EffectedTreasureItem.TreasureData.UUid,
                BagIndex = BagIndex,
                SubBagIndex = SubBagIndex,
                Rotate = Rotate,
                Pos = Pos,
            }
            table.insert(ServerEffectedTreasureItemList, ServerTreasureItem)
        end
        -- TODO[上线前删除] 调试日志：上线包体去掉此块，避免循环开销
        local _si = self.PendingApplyMoveInfo.StartInfo
        local _st = _si and _si.TreasureData
        local _dragUuid = _st and _st.UUid
        for i, item in ipairs(ServerEffectedTreasureItemList) do
            local ef = self.PendingApplyMoveInfo.EndInfo.EffectedTreasureItemList[i]
            if item.UniqueId == _dragUuid then
                -- 主被拖拽物品：拆两行，from/to 分开打印
                DebugPrint("lgc@InventoryController UpdateTreasureItemList [main]"
                    .." id="..tostring(item.Id).." uuid="..tostring(item.UniqueId)
                    .." | from pocket="..tostring(_si.PocketData and _si.PocketData.Name)
                    .." pos=("..tostring(_si.TopLeft and _si.TopLeft.X)..","..tostring(_si.TopLeft and _si.TopLeft.Y)..")"
                    .." dir="..tostring(_si.Direction))
                DebugPrint("lgc@InventoryController UpdateTreasureItemList [main]"
                    .." -> pocket="..tostring(ef and ef.NewPocketName)
                    .." bagIdx="..tostring(item.BagIndex).." subIdx="..tostring(item.SubBagIndex)
                    .." serverPos="..tostring(item.Pos).." rotate="..tostring(item.Rotate))
            else
                -- 被置换/位移的其他物品：从简
                DebugPrint("lgc@InventoryController UpdateTreasureItemList [displaced]"
                    .." id="..tostring(item.Id).." uuid="..tostring(item.UniqueId)
                    .." -> pocket="..tostring(ef and ef.NewPocketName).." serverPos="..tostring(item.Pos))
            end
        end
        -- TODO[上线前删除] end
        self.Dungeonobject:NotifyServerDungeonEvent("UpdateTreasureItemList", ServerEffectedTreasureItemList)
    end
    if self.MainWidget then
        self.MainWidget:BlockAllUIInput(true)
        self.MainWidget:AddTimer(5, function()
            if self.MainWidget:IsAllUIInputBlocked() then
                self.MainWidget:BlockAllUIInput(false)
                self.PendingApplyMoveInfo = nil
                DebugPrint("lgc@InventoryController TimeOut UnblockAllUIInput")
            end
        end, false, 0, "UnblockAllUIInput")
    end
    local Success = false
    if self.MainWidget and self.bOpenClientPredict then
        if self.PendingApplyMoveInfo then
            Success = self:RealDropAndSwitchItem(self.PendingApplyMoveInfo)
        else
            GWorld.logger.error("RealDropAndSwitchItem 没有待处理的移动请求")
            Success = false
        end
    else
        Success = true
    end
    return Success
end

function InventoryController:RealDropAndSwitchItem(ApplyMoveInfo) --控制器层,条件检测
    DebugPrint("lgc@InventoryController RealDropAndSwitchItem")
    local bSuccess = self:ApplyItemMoveData(ApplyMoveInfo)
    return bSuccess
end

function InventoryController:ClearDragState()
    if self.MainWidget and IsValid(self.MainWidget) and self.StartDragGridData then
        local TreasureData = self.StartDragGridData.TreasureData
        local UpdateParams = {
            bDrag = false,
            Treasure = TreasureData and TreasureData.Treasure,
            bInRecycleGrid = (TreasureData and TreasureData.Treasure) and TreasureData.Treasure.bInRecycleGrid,
        }
        self:RequestUpdateView(UpdateParams)
    end
    if self.DragWidget and IsValid(self.DragWidget) then
        --self.DragWidget:RemoveFromParent()
        self.DragWidget:SetVisibility(ESlateVisibility.Collapsed)
        self.DragWidget = nil
    end
    self.bDraging = false
    self.Operation = nil
    self.StartDragGridData = nil
    self._NotifyDragOverGridsCache = nil  -- 拖拽结束，释放缓存引用
end

function InventoryController:GamepadChangeDragWidgetDirection()
    if not self.bDraging or not self.DragWidget or not self.MainWidget then return end
    if self.MainWidget.GamepadChangeDragItemDirectionTable[self.DragDetectedRequestID] == InventoryCommonConst.Direction.Vertical then
        self.MainWidget.GamepadChangeDragItemDirectionTable[self.DragDetectedRequestID] = InventoryCommonConst.Direction.Horizontal
    elseif self.MainWidget.GamepadChangeDragItemDirectionTable[self.DragDetectedRequestID] == InventoryCommonConst.Direction.Horizontal then
        self.MainWidget.GamepadChangeDragItemDirectionTable[self.DragDetectedRequestID] = InventoryCommonConst.Direction.Vertical
    elseif not self.MainWidget.GamepadChangeDragItemDirectionTable[self.DragDetectedRequestID] then
        local StartDragGridData = self.StartDragGridData
        local TreasureData = StartDragGridData and StartDragGridData.TreasureData or nil
        if TreasureData then
            self.MainWidget.GamepadChangeDragItemDirectionTable[self.DragDetectedRequestID] = TreasureData.Direction == InventoryCommonConst.Direction.Vertical and InventoryCommonConst.Direction.Horizontal or InventoryCommonConst.Direction.Vertical
        end
    end
    self._NotifyDragOverGridsCache = nil  -- 方向已变，同一格子需要重新计算
    self:NotifyDragOverGrids(self.CurNotifyOverDragGridData, self.CurNotifyOverDropGridData)
end

function InventoryController:GetBagTreasureValue()
    local CurBagPocketNames = self.CurBagPocketNames or {}
    local BagTreasureValue = 0
    for PocketName, _ in pairs(CurBagPocketNames) do
        local TreasureItemDatas = self.InventoryModel.TreasureItems[PocketName]
        if TreasureItemDatas then
            for UUid, TreasureItemData in pairs(TreasureItemDatas) do
                local TreasureInfo = DataMgr.ExtractionTreasure[TreasureItemData.TreasureId]
                if TreasureInfo then
                    BagTreasureValue = BagTreasureValue + TreasureInfo.TreasureValue * (tonumber(TreasureItemData.BuffLabelInfo and TreasureItemData.BuffLabelInfo.Num) or 1)
                end
            end
        end
    end
    return BagTreasureValue
end

function InventoryController:GetBagGridOccupancyData()
    local AllGridNum = 0
    local OccupancyGridNum = 0
    local CurBagPocketNames = self.CurBagPocketNames or {}
    for PocketName, _ in pairs(CurBagPocketNames) do
        local PocketGrids = self.InventoryModel.Grids[PocketName]
        if PocketGrids then
            for X, ColGrids in pairs(PocketGrids) do
                for Y, GridData in pairs(ColGrids) do
                    AllGridNum = AllGridNum + 1
                    if GridData.TreasureData then
                        OccupancyGridNum = OccupancyGridNum + 1
                    end
                end
            end
        end
    end
    return {
        AllGridNum = AllGridNum,
        OccupancyGridNum = OccupancyGridNum,
    }
end

function InventoryController:GetValidRecycleDropGridData()
    local i = 1
    local RecyclePocketName = InventoryCommonConst.RecyclePocketNamePrefix..i
    local RecyclePocketData = self.InventoryModel.Pockets[RecyclePocketName]
    local GridData = nil
    if RecyclePocketData then
        if self.InventoryModel.Grids[RecyclePocketName] then
            GridData = self.InventoryModel.Grids[RecyclePocketName][0][0]
        end
    end
    while true do
        if GridData and not GridData.TreasureData then
            break
        end
        i = i + 1
        if i > 500 then
            DebugPrint("lgc@GetValidRecycleDropGridData: Warning i > 500")
            return
        end
        RecyclePocketName = InventoryCommonConst.RecyclePocketNamePrefix..i
        RecyclePocketData = self.InventoryModel.Pockets[RecyclePocketName]
        GridData = nil
        if RecyclePocketData then
            if self.InventoryModel.Grids[RecyclePocketName] then
                GridData = self.InventoryModel.Grids[RecyclePocketName][0][0]
            else
                GridData = {
                    Position = FVector2D(0, 0),
                    PocketData = RecyclePocketData,
                    Grid = nil,
                    bRecycle = true,
                    TreasureData = nil,
                    Inventory = InventoryCommonConst.PocketType.Recycle,
                }
            end
        end
    end
    return GridData
end

function InventoryController:AddEmptyRecyclePocketData()
    local i = 1
    while true do
        local RecyclePocketName = InventoryCommonConst.RecyclePocketNamePrefix..i
        local RecyclePocketData = self.InventoryModel.Pockets[RecyclePocketName]
        if not RecyclePocketData then
            break
        end
        i = i + 1
        if i > 500 then
            DebugPrint("lgc@AddEmptyRecyclePocketData: Warning i > 500")
            return
        end
    end
    local RecyclePocketName = InventoryCommonConst.RecyclePocketNamePrefix..i
    local RecyclePocketData = {
        Inventory = InventoryCommonConst.PocketType.Recycle,
        Pocket = nil,
        Name = RecyclePocketName,
        bRecycle = true,
        RecycleIndex = i,
        Size = FVector2D(1, 1),
    }
    self.InventoryModel.Pockets[RecyclePocketName] = RecyclePocketData
    self:InitGridsData(RecyclePocketData)
end

function InventoryController:RemoveEmptyRecyclePocketData()
    local i = 1
    while true do
        local RecyclePocketName = InventoryCommonConst.RecyclePocketNamePrefix..i
        local RecyclePocketData = self.InventoryModel.Pockets[RecyclePocketName]
        if RecyclePocketData then
            local GridData = self.InventoryModel.Grids[RecyclePocketName][0][0]
            if not GridData.TreasureData then
                self:ClearPocketView(RecyclePocketName)
                break
            end
        end
        i = i + 1
        if i > 500 then
            DebugPrint("lgc@RemoveEmptyRecyclePocketData: Warning i > 500")
            return
        end
    end
end

function InventoryController:InitGridsData(TargetPocketData)
    if not TargetPocketData then return end
    for X = 0, TargetPocketData.Size.X - 1 do
        for Y = 0, TargetPocketData.Size.Y - 1 do
            local Pos = FVector2D(X, Y)
            if not self.InventoryModel.Grids[TargetPocketData.Name] then
                self.InventoryModel.Grids[TargetPocketData.Name] = {}
            end
            if not self.InventoryModel.Grids[TargetPocketData.Name][X] then
                self.InventoryModel.Grids[TargetPocketData.Name][X] = {}
            end
            local GridData = {
                Grid = nil,
                Position = Pos,
                PocketData = TargetPocketData,
                Inventory = TargetPocketData.Inventory,
                TreasureData = nil,
                bRecycle = TargetPocketData.bRecycle,
            }
            self.InventoryModel.Grids[TargetPocketData.Name][X][Y] = GridData
        end
    end
end

-- 根据TreasureId获取所有类型为TreasureId的TreasureData
-- @return table TreasureData: 所有目标为TreasureId的TreasureData
-- @TreasureItemData table：{
--     UUid = Num,
--     TreasureId = Num,
--     Treasure = UserWidget,
--     bInRecycleGrid = bool,
--     Size = FVector2D(X, Y),
--     Direction = InventoryCommonConst.Direction,
-- }
function InventoryController:GetTreasureDatasById(TreasureId)
    if not TreasureId then return {} end
    local TreasureDatas = {}
    for _, PocketData in pairs(self.InventoryModel.Pockets) do
        if PocketData.Inventory == InventoryCommonConst.PocketType.Bag then
            local TreasureItems = self.InventoryModel.TreasureItems[PocketData.Name]
            if TreasureItems and next(TreasureItems) then
                for _, TreasureItemData in pairs(TreasureItems) do
                    if TreasureItemData.TreasureId == TreasureId then
                        table.insert(TreasureDatas, TreasureItemData)
                    end
                end
            end
        end
    end
    return TreasureDatas
end

function InventoryController:UpdateTreasureDatasByTicketId(TicketId)
    if not self.Dungeonobject then return end
    local EffectTreasureList = SoloTreasureUtils:GetTicketEffectTreasureList(self.Dungeonobject.AllItemList, TicketId)
    local TicketQuality = TicketId and DataMgr.ExtractionLottery[TicketId].Quality or 1
    for Uid, ItemData in pairs(self.Dungeonobject.AllItemList) do
        local TreasureData = self:GetCurTreasureData(Uid)
        if EffectTreasureList[Uid] and TreasureData then
            self.Dungeonobject.AllItemList[Uid].BuffLabelInfo = {Quality = TicketQuality, Num = EffectTreasureList[Uid]}
            TreasureData.BuffLabelInfo = {Quality = TicketQuality, Num = EffectTreasureList[Uid]}
            if IsValid(TreasureData.Treasure) then
                TreasureData.Treasure:SetShowBuffLabel(TreasureData.BuffLabelInfo)
            end
        elseif TreasureData and TreasureData.BuffLabelInfo then
            self.Dungeonobject.AllItemList[Uid].BuffLabelInfo = nil
            TreasureData.BuffLabelInfo = nil
            if IsValid(TreasureData.Treasure) then
                TreasureData.Treasure:SetShowBuffLabel(nil)
            end 
        end
    end
end

-----------------------处理服务器通知-----------------

-- 服务器数据转为客户端数据
function InventoryController:UpdateTreasureItemDataServerNew(ItemData)
    local BagIndex = ItemData.BagIndex
    local SubBagIndex = ItemData.SubBagIndex
    local PocketName = nil
    local Inventory = nil
    local bNotSearched = false
    local PocketSize = nil
    if BagIndex == -1 then
        PocketName = InventoryCommonConst.RecyclePocketNamePrefix..SubBagIndex
        Inventory = InventoryCommonConst.PocketType.Recycle
        PocketSize = FVector2D(1, 1)
    elseif BagIndex == 0 then
        for CurBagPocketName, CurBagPocketShapeAndIndex in pairs(self.CurBagPocketNames or {}) do
            if CurBagPocketShapeAndIndex.SubBagIndex == SubBagIndex then
                PocketName = CurBagPocketName
            end
        end
        Inventory = InventoryCommonConst.PocketType.Bag
        local BagInfo = DataMgr.ExtractionTreasureBag[self.InventoryModel.BagId]
        PocketSize = FVector2D(BagInfo.Shape[SubBagIndex][1], BagInfo.Shape[SubBagIndex][2])
    else
        PocketName = InventoryCommonConst.SearchPocketNamePrefix..BagIndex
        Inventory = InventoryCommonConst.PocketType.Mechanism
        bNotSearched = true

        local Shape = nil
        local MechanismEntity = self.Dungeonobject:GetCachedMechanismInfo(BagIndex)
        if not MechanismEntity then return end
        local MechanismInfo = DataMgr.ExtractionTreasureMechanism[MechanismEntity.UnitId]
        if not MechanismInfo then
            MechanismInfo = DataMgr.ExtractionTreasureGuard[MechanismEntity.UnitId]
            if MechanismInfo then
                MechanismInfo = DataMgr.ExtractionTreasureMechanism[MechanismInfo.MechanismItemBox]
            end
        end
        if not MechanismInfo then return end
        PocketSize = FVector2D(MechanismInfo.Shape[1], MechanismInfo.Shape[2])
    end
    local PocketData = self.InventoryModel.Pockets[PocketName] or {
        Inventory = Inventory,
        Name = PocketName,
        Size = PocketSize,
        SubBagIndex = BagIndex == 0 and SubBagIndex or nil,
        MechanismUid = (BagIndex and BagIndex ~= -1 and BagIndex ~= 0) and BagIndex or nil,
        bRecycle = BagIndex == -1,
        RecycleIndex = BagIndex == -1 and SubBagIndex or nil,
    }
    local Position = self:ServerPos2ClientPosition(ItemData.Pos, PocketSize)
    local TreasureShape = DataMgr.ExtractionTreasure[tonumber(ItemData.Id)].Shape
    local TreasureSize = FVector2D(TreasureShape[1], TreasureShape[2])
    local TreasureData = {
        TreasureId = tonumber(ItemData.Id),
        Position = Position,
        Direction = ItemData.Rotate and InventoryCommonConst.Direction.Vertical or InventoryCommonConst.Direction.Horizontal,
        UUid = ItemData.UniqueId,
        bNotSearched = bNotSearched,
        Size = TreasureSize,
    }
    self:CreateTreasureDataToPocket(PocketData, TreasureData)
end

function InventoryController:UpdateTreasureItemDataServer(bServerSuccess)
    if self.MainWidget then
        self.MainWidget:BlockAllUIInput(false)
    end
    if not bServerSuccess then
        if self.MainWidget and self.bOpenClientPredict then   --客户端预测失败回滚
            if self.PendingApplyMoveInfo then
                local RevertDropGridData = CommonUtils.DeepCopy(self.PendingApplyMoveInfo.StartInfo.DragGridData)
                local RevertDragGridData = CommonUtils.DeepCopy(self.PendingApplyMoveInfo.EndInfo.DropGridData)
                local RevertMoveInfo = self:GetItemMoveData(RevertDragGridData, RevertDropGridData)
                self:RealDropAndSwitchItem(RevertMoveInfo)
                DebugPrint("lgc@UpdateTreasureItemData: Client Predict Failed!! RevertRealDropAndSwitchItem")
            end
        else    --移动失败
            self:ClearDragState()
            self.PendingApplyMoveInfo = nil
        end
        EventManager:FireEvent(EventID.OnTreasureItemDragCancelled)
        return false
    end
    if not self.MainWidget then return end
    local bSuccess = false
    if self.PendingApplyMoveInfo then
        bSuccess = true
    end
    if self.MainWidget and self.bOpenClientPredict then
        if bSuccess then    --客户端预测成功
            EventManager:FireEvent(EventID.OnTreasureItemDrop, self.PendingApplyMoveInfo)
        end
    else
        bSuccess = self:RealDropAndSwitchItem(self.PendingApplyMoveInfo)
        if bSuccess then    --移动成功
            EventManager:FireEvent(EventID.OnTreasureItemDrop, self.PendingApplyMoveInfo)
        end
    end
    self.PendingApplyMoveInfo = nil
end

--服务器通知删除物品
function InventoryController:DeleteTreasureItemDataServer(ItemData)
    if not ItemData or not ItemData.UniqueId then return end
    local CurTreasureData = self:GetCurTreasureData(ItemData.UniqueId)
    if CurTreasureData then
        if self.MainWidget and IsValid(self.MainWidget) then 
            local UpdateParams = {
                Treasure = CurTreasureData.Treasure,
            }
            self:RequestUpdateView(UpdateParams)
        end
        self.InventoryModel.TreasureItems[CurTreasureData.PocketName][CurTreasureData.UUid] = nil
        local Width, Height = self:GetWHByDir(CurTreasureData.Size, CurTreasureData.Direction)
        local GridDatas = self:GetTargetGridDatas(CurTreasureData.PocketName, CurTreasureData.Position, Width, Height)
        for _, GridData in pairs(GridDatas or {}) do
            GridData.TreasureData = nil
        end
    else
        DebugPrint("lgc@DeleteTreasureItemDataServer: Warning CurTreasureData is nil")
    end
end

function InventoryController:GetCurTreasureData(TreasureUid)
    if not TreasureUid then return nil end
    local OldTreasureData = nil
    local ItemData = self.Dungeonobject.AllItemList[TreasureUid]
    local PocketName = nil
    if ItemData.BagIndex == -1 then
        PocketName = InventoryCommonConst.RecyclePocketNamePrefix..tostring(ItemData.SubBagIndex)
    elseif ItemData.BagIndex == 0 then
        for CurBagPocketName, CurBagPocketShapeAndIndex in pairs(self.CurBagPocketNames or {}) do
            if CurBagPocketShapeAndIndex.SubBagIndex == ItemData.SubBagIndex then
                PocketName = CurBagPocketName
            end
        end
    else
        PocketName = InventoryCommonConst.SearchPocketNamePrefix..tostring(ItemData.BagIndex)
    end
    local TreasureData = InventoryModel.TreasureItems[PocketName][TreasureUid]
    if TreasureData then
        OldTreasureData = TreasureData
    end
    return OldTreasureData
end

function InventoryController:ServerPos2ClientPosition(Pos, PocketSize)
    if not Pos or not PocketSize then return nil end
    local X = (Pos - 1) % PocketSize.X
    local Y = math.floor((Pos - 1) / PocketSize.X)
    local EndPosition = FVector2D(X, Y)
    return EndPosition
end

function InventoryController:ClientPosition2ServerPos(Position, PocketSize)
    if not Position or not PocketSize then return nil end
    local Pos = Position.X + 1 + Position.Y * PocketSize.X
    return Pos
end

function InventoryController:OnSoloTreasureTribute()
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_Extraction_TM_17"), 2)
end

AssembleComponents(InventoryController)
return InventoryController

