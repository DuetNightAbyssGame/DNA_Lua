require "UnLua"
local InventoryCommonConst = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryCommonConst")
-- 这整个组件全部是数据层的操作，数据层更新完在控制器中更新视图层
local Component = {}

-------------------------------通用流程------------------------------
function Component:GetItemMoveData(DragGridData, DropGridData, QuickTransferType)
    local StartInfo = self:GenerateStartInfo(DragGridData)
    local EndInfo = self:GenerateEndInfo(DragGridData, DropGridData, StartInfo, QuickTransferType)
    local MoveInfo = { bCanMove = false, StartInfo = StartInfo, EndInfo = EndInfo }
    if EndInfo and EndInfo.bCanPlace == true then
        MoveInfo.bCanMove = true
        return MoveInfo
    end
    return MoveInfo
end

function Component:GenerateStartInfo(DragGridData)
    local StartInfo = {
        Type = "Error",
        DragGridData = DragGridData,
        TreasureData = DragGridData.TreasureData,
    }
    if not DragGridData or not DragGridData.TreasureData then return StartInfo end
    if DragGridData.Inventory ~= InventoryCommonConst.PocketType.Recycle then
        StartInfo = {
            Type = "Grid",
            DragGridData = DragGridData,
            TreasureData = DragGridData.TreasureData,
            PocketData = DragGridData.PocketData,
            TopLeft = DragGridData.TreasureData.Position,
            Direction = DragGridData.TreasureData.Direction,
        }
    elseif DragGridData.Inventory == InventoryCommonConst.PocketType.Recycle then
        StartInfo = {
            Type = "RecycleGrid",
            DragGridData = DragGridData,
            TreasureData = DragGridData.TreasureData,
            PocketData = DragGridData.PocketData,
            TopLeft = DragGridData.TreasureData.Position,
            Direction = DragGridData.TreasureData.Direction,
        }
    end
    return StartInfo
end

function Component:GenerateEndInfo(DragGridData, DropGridData, StartInfo, QuickTransferType)
    if not DropGridData and QuickTransferType then
        return self:GenerateEndInfoAutoQuickTransfer(DragGridData, StartInfo, QuickTransferType)
    end
    if not DragGridData or not DropGridData then return { Type = "Error", bCanPlace = false } end
    if DropGridData.Inventory ~= InventoryCommonConst.PocketType.Recycle then
        return self:GenerateEndInfoFromGrid(DragGridData, DropGridData, StartInfo)
    elseif DropGridData.Inventory == InventoryCommonConst.PocketType.Recycle then
        return self:GenerateEndInfoRecycle(DragGridData, DropGridData, StartInfo)
    end
    return { Type = "Error", bCanPlace = false }
end

function Component:GenerateEndInfoFromGrid(DragGridData, DropGridData, StartInfo)
    local EndInfo = {
        Type = "Grid",
        DropGridData = DropGridData,
        PocketData = DropGridData.PocketData,
    }
    if not DropGridData or not DragGridData.TreasureData then return EndInfo end
    -- 拖拽源物品不可处于搜索中或未搜索状态（防御性校验，正常由 OnDragDetected 的 bSearched 保证）
    local DragTD = DragGridData.TreasureData
    if DragTD.bNotSearched then return EndInfo end
    if IsValid(DragTD.Treasure) and DragTD.Treasure.bSearching then return EndInfo end
    local Dir = self.MainWidget.GamepadChangeDragItemDirectionTable and self.MainWidget.GamepadChangeDragItemDirectionTable[self.DragDetectedRequestID] or DragGridData.TreasureData.Direction
    local AltDir = nil
    if not self.MainWidget.GamepadChangeDragItemDirectionTable or not self.MainWidget.GamepadChangeDragItemDirectionTable[self.DragDetectedRequestID] then
        AltDir = Dir == InventoryCommonConst.Direction.Horizontal and InventoryCommonConst.Direction.Vertical or InventoryCommonConst.Direction.Horizontal
    end
    local AllValid = {}
    local TopLeftList = {}
    local AltTopLeftList = {}
    local Width, Height = self:GetWHByDir(DragGridData.TreasureData.Size, Dir)
    local Center = DropGridData.Position
    TopLeftList = self:ComputeTopLeftFromCenter(DragGridData.TreasureData, DropGridData.PocketData.Name, Center, Width, Height)
    for _, TL in ipairs(TopLeftList.ValidResults) do
        table.insert(AllValid, { TopLeft = TL, Direction = Dir, W = Width, H = Height })
    end
    if AltDir and Width ~= Height then
        local AltWidth, AltHeight = self:GetWHByDir(DragGridData.TreasureData.Size, AltDir)
        AltTopLeftList = self:ComputeTopLeftFromCenter(DragGridData.TreasureData, DropGridData.PocketData.Name, Center, AltWidth, AltHeight)
        for _, ATL in ipairs(AltTopLeftList.ValidResults) do
            table.insert(AllValid, { TopLeft = ATL, Direction = AltDir, W = AltWidth, H = AltHeight })
        end
    end
    if #AllValid > 0 then
        local PocketGrids = self.InventoryModel.Grids[DropGridData.PocketData.Name]
        local function IsEmptyAt(x, y)
            local col = PocketGrids and PocketGrids[x]
            local GridData = col and col[y]
            return GridData ~= nil and (GridData.TreasureData == nil or GridData.TreasureData == DragGridData.TreasureData)
        end
        local SX = DropGridData.Position.X
        local SY = DropGridData.Position.Y
        local PreferredDir = nil
        if IsEmptyAt(SX, SY) then
            local Quadrant = DropGridData.Quadrant
            local northSize = Quadrant and (Quadrant == 1 or Quadrant == 2) and math.ceil(Height / 2) or math.floor(Height / 2)
            local northEmpty = IsEmptyAt(SX, SY - northSize)
            local southSize = Quadrant and (Quadrant == 3 or Quadrant == 4) and math.ceil(Height / 2) or math.floor(Height / 2)
            local southEmpty = IsEmptyAt(SX, SY + southSize)
            local westSize = Quadrant and (Quadrant == 2 or Quadrant == 3) and math.ceil(Width / 2) or math.floor(Width / 2)
            local westEmpty = IsEmptyAt(SX - westSize, SY)
            local eastSize = Quadrant and (Quadrant == 1 or Quadrant == 4) and math.ceil(Width / 2) or math.floor(Width / 2)
            local eastEmpty = IsEmptyAt(SX + eastSize, SY)
            local edgeHorizontal = (not northEmpty) or (not southEmpty)
            local edgeVertical = (not westEmpty) or (not eastEmpty)
            if edgeHorizontal and edgeVertical then
                if (not northEmpty) and (not westEmpty) then
                    if Quadrant == 3 then
                        PreferredDir = InventoryCommonConst.Direction.Vertical
                    elseif Quadrant == 1 then
                        PreferredDir = InventoryCommonConst.Direction.Horizontal
                    else
                        PreferredDir = Dir
                    end
                elseif (not northEmpty) and (not eastEmpty) then
                    if Quadrant == 2 then
                        PreferredDir = InventoryCommonConst.Direction.Horizontal
                    elseif Quadrant == 4 then
                        PreferredDir = InventoryCommonConst.Direction.Vertical
                    else
                        PreferredDir = Dir
                    end
                elseif (not southEmpty) and (not westEmpty) then
                    if Quadrant == 2 then
                        PreferredDir = InventoryCommonConst.Direction.Vertical
                    elseif Quadrant == 4 then
                        PreferredDir = InventoryCommonConst.Direction.Horizontal
                    else
                        PreferredDir = Dir
                    end
                elseif (not southEmpty) and (not eastEmpty) then
                    if Quadrant == 1 then
                        PreferredDir = InventoryCommonConst.Direction.Vertical
                    elseif Quadrant == 3 then
                        PreferredDir = InventoryCommonConst.Direction.Horizontal
                    else
                        PreferredDir = Dir
                    end
                else
                    PreferredDir = Dir
                end
            elseif edgeHorizontal then
                if (not southEmpty or not northEmpty) and Height > Width then
                    PreferredDir = InventoryCommonConst.Direction.Vertical
                else
                    PreferredDir = InventoryCommonConst.Direction.Horizontal
                end
            elseif edgeVertical then
                if (not westEmpty or not eastEmpty) and Width > Height then
                    PreferredDir = InventoryCommonConst.Direction.Horizontal
                else
                    PreferredDir = InventoryCommonConst.Direction.Vertical
                end
            end
        end
        local Best = nil
        if PreferredDir then
            for _, C in ipairs(AllValid) do
                if C.Direction == PreferredDir then
                    Best = C
                    break
                end
            end
        end
        if not Best then
            for _, C in ipairs(AllValid) do
                if C.Direction == Dir then
                    Best = C
                    break
                end
            end
        end
        if not Best then
            Best = AllValid[1]
        end
        EndInfo.ValidTopLeftList = {}
        for _, C in ipairs(AllValid) do
            table.insert(EndInfo.ValidTopLeftList, C.TopLeft)
        end
        EndInfo.InvalidTopLeftList = {}
        for _, InvalidResult in ipairs(TopLeftList.InvalidResults and TopLeftList.InvalidResults or {}) do table.insert(EndInfo.InvalidTopLeftList, InvalidResult) end
        for _, AltInvalidResult in ipairs(AltTopLeftList.InvalidResults and AltTopLeftList.InvalidResults or {}) do table.insert(EndInfo.InvalidTopLeftList, AltInvalidResult) end
        EndInfo.TopLeft = Best.TopLeft
        EndInfo.Direction = Best.Direction
        EndInfo.bCanPlace = true
    else
        local AllInvalidResults = {}
        for _, InvalidTopLeft in ipairs(TopLeftList.InvalidResults and TopLeftList.InvalidResults or {}) do
            table.insert(AllInvalidResults, {Dir, InvalidTopLeft})
        end
        for _, AltInvalidTopLeft in ipairs(AltTopLeftList.InvalidResults and AltTopLeftList.InvalidResults or {}) do
            table.insert(AllInvalidResults, {AltDir, AltInvalidTopLeft})
        end
        EndInfo.ValidTopLeftList = {}
        EndInfo.AllInvalidResults = AllInvalidResults
        EndInfo.InvalidTopLeft = AllInvalidResults[1]
        EndInfo.TopLeft = nil
        EndInfo.bCanPlace = false
    end

    if EndInfo.bCanPlace and EndInfo.TopLeft then -- 客户端预计算本次移动所有受影响的Item的最终数据，发给服务器
        local EndPocketData = EndInfo.PocketData
        if not EndPocketData or not EndInfo.TopLeft or not EndInfo.Direction then return false end
        local Width, Height = self:GetWHByDir(DragGridData.TreasureData.Size, EndInfo.Direction)
        local StartItemWidth, StartItemHeight = self:GetWHByDir(StartInfo.TreasureData.Size, StartInfo.Direction)
        local StartMaxX = StartInfo.TopLeft.X + StartItemWidth - 1
        local StartMaxY = StartInfo.TopLeft.Y + StartItemHeight - 1
        local StartMinX = StartInfo.TopLeft.X
        local StartMinY = StartInfo.TopLeft.Y
        local bSamePocket = StartInfo.PocketData.Name == EndPocketData.Name
        local EndWidth, EndHeight = self:GetWHByDir(DragGridData.TreasureData.Size, EndInfo.Direction)
        local EndMaxX = bSamePocket and EndInfo.TopLeft.X + Width - 1 or -1
        local EndMaxY = bSamePocket and EndInfo.TopLeft.Y + Height - 1 or -1
        local EndMinX = bSamePocket and EndInfo.TopLeft.X or -1
        local EndMinY = bSamePocket and EndInfo.TopLeft.Y or -1
        local OverlappedTreasureDatas = {}
        local OverlappedSet = {}
        local GridDatas = self:GetTargetGridDatas(EndPocketData.Name, EndInfo.TopLeft, Width, Height)
        for _, GridData in ipairs(GridDatas) do
            local TreasureData = GridData and GridData.TreasureData
            if TreasureData and not OverlappedSet[TreasureData] and TreasureData ~= DragGridData.TreasureData then
                OverlappedSet[TreasureData] = true
                table.insert(OverlappedTreasureDatas, TreasureData)
            end
        end
        EndInfo.OverlappedTreasureDatas = OverlappedTreasureDatas
        -- 被替换的物品不可处于搜索中或未搜索状态，否则禁止此次替换
        for _, TD in ipairs(OverlappedTreasureDatas) do
            if TD.bNotSearched then
                EndInfo.bCanPlace = false
                return EndInfo
            end
            if IsValid(TD.Treasure) and TD.Treasure.bSearching then
                EndInfo.bCanPlace = false
                return EndInfo
            end
        end
        local EffectedTreasureItemList = {}
        table.insert(EffectedTreasureItemList, {
            TreasureData = DragGridData.TreasureData,
            NewTopLeft = EndInfo.TopLeft,
            NewDir = EndInfo.Direction,
            NewPocketName = EndPocketData.Name,
        })
        local RecordGrids = {}
        local IsValidPos = function(px, py, PocketName)
            if px >= StartMinX and px <= StartMaxX and py >= StartMinY and py <= StartMaxY then
                if not (px >= EndMinX and px <= EndMaxX and py >= EndMinY and py <= EndMaxY) then
                    if not (RecordGrids[PocketName] and RecordGrids[PocketName][px .." ".. py]) then
                        return true
                    end
                end
            end
            return false
        end
        if EndInfo.OverlappedTreasureDatas then
            local StartPocketData = StartInfo.PocketData
            local Delta = FVector2D(EndInfo.TopLeft.X - StartInfo.TopLeft.X, EndInfo.TopLeft.Y - StartInfo.TopLeft.Y)
            local bSwitchDirection = EndInfo.Direction and StartInfo.Direction and EndInfo.Direction ~= StartInfo.Direction
            local SecondTryPutDownItems = {}
            for _, TreasureData in ipairs(EndInfo.OverlappedTreasureDatas) do
                local NewDir = TreasureData.Direction
                local NewPosition = TreasureData.Position
                if bSwitchDirection then
                    if TreasureData.Direction == InventoryCommonConst.Direction.Horizontal then
                        NewDir = InventoryCommonConst.Direction.Vertical
                    else
                        NewDir = InventoryCommonConst.Direction.Horizontal
                    end
                    local RotationPositionX = TreasureData.Position.Y - EndInfo.TopLeft.Y + EndInfo.TopLeft.X
                    local RotationPositionY = TreasureData.Position.X - EndInfo.TopLeft.X + EndInfo.TopLeft.Y
                    NewPosition = FVector2D(RotationPositionX, RotationPositionY)
                end
                local Size = TreasureData.Size
                local IWidth, IHeight = self:GetWHByDir(Size, NewDir)
                local NewPocketName = StartPocketData.Name
                local NewPocketData = self.InventoryModel.Pockets[NewPocketName]
                local NewTopLeft = FVector2D(NewPosition.X - Delta.X, NewPosition.Y - Delta.Y)
                local Valid = true
                local OverlappedTreasureMaxX = NewTopLeft.X + IWidth - 1
                local OverlappedTreasureMaxY = NewTopLeft.Y + IHeight - 1
                local OverlappedTreasureMinX = NewTopLeft.X
                local OverlappedTreasureMinY = NewTopLeft.Y
                for X = OverlappedTreasureMinX, OverlappedTreasureMaxX do
                    for Y = OverlappedTreasureMinY, OverlappedTreasureMaxY do
                        if not IsValidPos(X, Y, NewPocketName) then
                            Valid = false
                            break
                        end
                    end
                    if not Valid then
                        break
                    end
                end
                if Valid then
                    for X = OverlappedTreasureMinX, OverlappedTreasureMaxX do
                        for Y = OverlappedTreasureMinY, OverlappedTreasureMaxY do
                            if not RecordGrids[NewPocketName] then
                                RecordGrids[NewPocketName] = {}
                            end
                            RecordGrids[NewPocketName][X .." ".. Y] = true
                        end
                    end
                    table.insert(EffectedTreasureItemList, {
                        TreasureData = TreasureData,
                        NewTopLeft = NewTopLeft,
                        NewDir = NewDir,
                        NewPocketName = NewPocketName,
                    })
                else
                    table.insert(SecondTryPutDownItems, TreasureData)
                end
            end
            for _, TreasureData in ipairs(SecondTryPutDownItems) do
                local NewPocketName = StartPocketData.Name
                local ValidInfo = nil
                -- 方向和尺寸与搜索位置无关，提到循环外只计算一次
                local NewDir = TreasureData.Direction
                if bSwitchDirection then
                    if TreasureData.Direction == InventoryCommonConst.Direction.Horizontal then
                        NewDir = InventoryCommonConst.Direction.Vertical
                    else
                        NewDir = InventoryCommonConst.Direction.Horizontal
                    end
                end
                local IWidth, IHeight = self:GetWHByDir(TreasureData.Size, NewDir)
                for X = StartMinX, StartMaxX do
                    for Y = StartMinY, StartMaxY do
                        local MaxX = X + IWidth - 1
                        local MaxY = Y + IHeight - 1
                        local Valid = true
                        for X2 = X, MaxX do
                            for Y2 = Y, MaxY do
                                if not IsValidPos(X2, Y2, NewPocketName) then
                                    Valid = false
                                    break
                                end
                            end
                            if not Valid then break end
                        end
                        if Valid then
                            for X2 = X, MaxX do
                                for Y2 = Y, MaxY do
                                    if not RecordGrids[NewPocketName] then
                                        RecordGrids[NewPocketName] = {}
                                    end
                                    RecordGrids[NewPocketName][X2 .." ".. Y2] = true
                                end
                            end
                            ValidInfo = {
                                TopLeft = FVector2D(X, Y),
                                Direction = NewDir,
                            }
                            break  -- 找到最近的合法位置即停止
                        end
                    end
                    if ValidInfo then break end
                end
                if ValidInfo then
                    table.insert(EffectedTreasureItemList, {
                        TreasureData = TreasureData,
                        NewTopLeft = ValidInfo.TopLeft,
                        NewDir = ValidInfo.Direction,
                        NewPocketName = NewPocketName,
                    })
                else
                    EndInfo.bCanPlace = false
                    DebugPrint("lgc@PutDownEndInfoItemsToStart: GetValidTopLeftInRectByTreasureData failed")
                end
            end
            EndInfo.EffectedTreasureItemList = EffectedTreasureItemList
        end
    end
    return EndInfo
end

function Component:GenerateEndInfoRecycle(DragGridData, DropGridData, StartInfo)
    local EffectedTreasureItemList = {}
    table.insert(EffectedTreasureItemList, {
        TreasureData = StartInfo.TreasureData,
        NewTopLeft = FVector2D(0, 0),
        NewDir = InventoryCommonConst.Direction.Horizontal,
        NewPocketName = DropGridData.PocketData.Name,
    })
    local EndInfo = {
        Type = "RecycleGrid",
        DropGridData = DropGridData,
        PocketData = DropGridData.PocketData,
        TopLeft = FVector2D(0, 0),
        Direction = InventoryCommonConst.Direction.Horizontal,
        bCanPlace = true,
        EffectedTreasureItemList = EffectedTreasureItemList,
    }
    return EndInfo
end

function Component:GetTargetTypePocketDatas(TargetType)
    local Ret = {}
    for PocketName, PocketData in pairs(self.InventoryModel.Pockets or {}) do
        local Pocket = PocketData and PocketData.Pocket
        if Pocket and IsValid(Pocket) then
            local Type = Pocket.Inventory
            if Type == TargetType then
                table.insert(Ret, PocketData)
            end
        end
    end
    if TargetType == InventoryCommonConst.PocketType.Bag then
        table.sort(Ret, function(a, b)
            local sa = tonumber(a.SubBagIndex) or 0
            local sb = tonumber(b.SubBagIndex) or 0
            return sa < sb
        end)
    end
    return Ret
end

function Component:GenerateEndInfoAutoQuickTransfer(DragGridData, StartInfo, QuickTransferType)
    if not DragGridData or not StartInfo or not StartInfo.PocketData then
        return { Type = "Error", bCanPlace = false }
    end
    local SourceType = DragGridData.Inventory
    local TargetType = nil
    if QuickTransferType == InventoryCommonConst.QuickTransferType.RightClick then
        if SourceType == InventoryCommonConst.PocketType.Mechanism then
            TargetType = InventoryCommonConst.PocketType.Bag
        elseif SourceType == InventoryCommonConst.PocketType.Bag then
            TargetType = InventoryCommonConst.PocketType.Mechanism
        elseif SourceType == InventoryCommonConst.PocketType.Recycle then
            TargetType = InventoryCommonConst.PocketType.Bag
        end
        local Candidates = self:GetTargetTypePocketDatas(TargetType)
        for _, PocketData in ipairs(Candidates) do
            local StartItemWidth, StartItemHeight = self:GetWHByDir(StartInfo.TreasureData.Size, StartInfo.Direction)
            local ValidInfo = self:GetValidTopLeftByTreasureId(PocketData.Name, DragGridData.TreasureData.TreasureId, StartInfo.Direction)
            if ValidInfo and ValidInfo.TopLeft then
                local DropGridData = self.InventoryModel.Grids[PocketData.Name][ValidInfo.TopLeft.X][ValidInfo.TopLeft.Y]
                local EffectedTreasureItemList = {}
                table.insert(EffectedTreasureItemList, {
                    TreasureData = StartInfo.TreasureData,
                    NewTopLeft = ValidInfo.TopLeft,
                    NewDir = ValidInfo.Direction,
                    NewPocketName = PocketData.Name,
                })
                return {
                    Type = "Grid",
                    PocketData = PocketData,
                    TopLeft = ValidInfo.TopLeft,
                    Direction = ValidInfo.Direction,
                    bCanPlace = true,
                    DropGridData = DropGridData,
                    EffectedTreasureItemList = EffectedTreasureItemList,
                }
            end
        end

    elseif QuickTransferType == InventoryCommonConst.QuickTransferType.AltAndLeftClick then
        if not StartInfo.PocketData.bRecycle then
            TargetType = InventoryCommonConst.PocketType.Recycle
            local DropGridData = self:GetValidRecycleDropGridData()
            return self:GenerateEndInfoRecycle(DragGridData, DropGridData, StartInfo)
        end
    end
    
    return { Type = "Grid", bCanPlace = false, CandidatePockets = Candidates}
end

function Component:ApplyItemMoveData(MoveData)
    if not MoveData or MoveData.bCanMove == false then return false end
    if not self:PutUpStartInfoItem(MoveData) then
        DebugPrint("lgc@ItemMoveComponent ApplyItemMoveData PutUpStartInfoItem failed")
        return false
    end
    if not self:PutUpEndInfoItems(MoveData) then
        DebugPrint("lgc@ItemMoveComponent ApplyItemMoveData PutUpEndInfoItems failed")
        return false
    end
    if not self:PutDownStartInfoItemToEnd(MoveData) then
        DebugPrint("lgc@ItemMoveComponent ApplyItemMoveData PutDownStartInfoItemToEnd failed")
        return false
    end
    if not self:PutDownEndInfoItemsToStart(MoveData) then
        DebugPrint("lgc@ItemMoveComponent ApplyItemMoveData PutDownEndInfoItemsToStart failed")
        return false
    end
    DebugPrint("lgc@ItemMoveComponent ApplyItemMoveData success")
    return true
end

function Component:PutUpStartInfoItem(MoveData)
    if not MoveData or not MoveData.StartInfo then return false end
    local StartInfo = MoveData.StartInfo
    local TreasureData = StartInfo.TreasureData
    if StartInfo.Type == "Grid" or StartInfo.Type == "RecycleGrid" then
        local StartPocketData = StartInfo.PocketData
        if not TreasureData or not StartPocketData then return false end
        local Dir = StartInfo.Direction
        local Size = TreasureData.Size
        TreasureData.bInRecycleGrid = nil
        local Width, Height = self:GetWHByDir(Size, Dir)
        local TopLeft = StartInfo.TopLeft
        local GridDatas = self:GetTargetGridDatas(StartPocketData.Name, TopLeft, Width, Height)
        if TreasureData and self.InventoryModel.TreasureItems[TreasureData.PocketName] and self.InventoryModel.TreasureItems[TreasureData.PocketName][TreasureData.UUid] then
            self.InventoryModel.TreasureItems[TreasureData.PocketName][TreasureData.UUid] = nil
        end
        for _, GridData in ipairs(GridDatas) do
            GridData.TreasureData = nil
        end
        return true
    elseif StartInfo.Type == "SystemGenerate" then
        return true
    end
    return false
end

function Component:PutUpEndInfoItems(MoveData)
    if not MoveData or not MoveData.EndInfo then return false end
    local EndInfo = MoveData.EndInfo
    if EndInfo.Type == "Grid" then
        local EndPocketData = EndInfo.PocketData
        local TopLeft = EndInfo.TopLeft
        local Dir = EndInfo.Direction
        local Size = (MoveData.StartInfo and MoveData.StartInfo.TreasureData) and MoveData.StartInfo.TreasureData.Size or nil
        if not EndPocketData or not TopLeft or not Dir or not Size then return false end
        local Width, Height = self:GetWHByDir(Size, Dir)
        local GridDatas = self:GetTargetGridDatas(EndPocketData.Name, TopLeft, Width, Height)
        for _, GridData in ipairs(GridDatas) do
            local TreasureData = GridData and GridData.TreasureData
            if TreasureData and self.InventoryModel.TreasureItems[GridData.PocketData.Name] and self.InventoryModel.TreasureItems[GridData.PocketData.Name][TreasureData.UUid] then
                self.InventoryModel.TreasureItems[GridData.PocketData.Name][TreasureData.UUid] = nil
            end
            GridData.TreasureData = nil
        end
        return true
    elseif EndInfo.Type == "RecycleGrid" then
        return true
    end
    return false
end

function Component:PutDownStartInfoItemToEnd(MoveData)
    if not MoveData or not MoveData.StartInfo or not MoveData.EndInfo then return false end
    local StartInfo = MoveData.StartInfo
    local EndInfo = MoveData.EndInfo
    if EndInfo.Type == "Grid" or EndInfo.Type == "RecycleGrid" then
        local TreasureData = StartInfo.TreasureData
        local EndPocketData = EndInfo.PocketData
        local TopLeft = EndInfo.TopLeft
        local Dir = EndInfo.Direction
        if not TreasureData or not EndPocketData or not TopLeft or not Dir then return false end
        local Size = TreasureData.Size
        if EndInfo.Type == "RecycleGrid" then
            Size = FVector2D(1, 1)
            TreasureData.bInRecycleGrid = true
        else
            TreasureData.bInRecycleGrid = false
        end
        local Width, Height = self:GetWHByDir(Size, Dir)
        local NewPocketName = EndPocketData.Name
        local GridDatas = self:GetTargetGridDatas(NewPocketName, TopLeft, Width, Height)
        for _, GridData in ipairs(GridDatas) do
            GridData.TreasureData = TreasureData
        end
        TreasureData.Position = TopLeft
        TreasureData.Direction = Dir
        TreasureData.PocketName = NewPocketName
        TreasureData.bDrag = false
        if not self.InventoryModel.TreasureItems[NewPocketName] then
            self.InventoryModel.TreasureItems[NewPocketName] = {}
        end
        self.InventoryModel.TreasureItems[NewPocketName][TreasureData.UUid] = TreasureData
        self:RequestUpdateView(TreasureData)
        return true
    end
    return false
end

function Component:PutDownEndInfoItemsToStart(MoveData)
    if not MoveData or not MoveData.EndInfo then return false end
    local EndInfo = MoveData.EndInfo
    local StartInfo = MoveData.StartInfo
    if EndInfo.Type == "Grid" and StartInfo and StartInfo.Type == "Grid" and next(EndInfo.EffectedTreasureItemList) then
        for _, EffectedTreasureItem in ipairs(EndInfo.EffectedTreasureItemList) do
            local TreasureData = EffectedTreasureItem.TreasureData
            if TreasureData == StartInfo.TreasureData then
                goto continue
            end
            local Width, Height = self:GetWHByDir(TreasureData.Size, EffectedTreasureItem.NewDir)
            local GridDatas = self:GetTargetGridDatas(EffectedTreasureItem.NewPocketName, EffectedTreasureItem.NewTopLeft, Width, Height)
            for _, GridData in ipairs(GridDatas) do
                GridData.TreasureData = TreasureData
            end
            TreasureData.Position = EffectedTreasureItem.NewTopLeft
            TreasureData.Direction = EffectedTreasureItem.NewDir
            TreasureData.PocketName = EffectedTreasureItem.NewPocketName
            if not self.InventoryModel.TreasureItems[EffectedTreasureItem.NewPocketName] then
                self.InventoryModel.TreasureItems[EffectedTreasureItem.NewPocketName] = {}
            end
            self.InventoryModel.TreasureItems[EffectedTreasureItem.NewPocketName][TreasureData.UUid] = TreasureData
            self:RequestUpdateView(TreasureData)
            ::continue::
        end
        return true
    elseif StartInfo.Type == "SystemGenerate" then
        return true
    elseif EndInfo.Type == "RecycleGrid" then
        return true
    elseif EndInfo.Type == "Grid" and StartInfo and StartInfo.Type == "RecycleGrid" and EndInfo.OverlappedTreasureDatas then
        for _, TreasureData in ipairs(EndInfo.OverlappedTreasureDatas) do
            local NewDir = InventoryCommonConst.Direction.Horizontal
            local Size = FVector2D(1, 1)
            TreasureData.bInRecycleGrid = true
            local IWidth, IHeight = self:GetWHByDir(Size, NewDir)
            local NewTopLeft = FVector2D(0, 0)
            local ValidRecycleDropGridData = self:GetValidRecycleDropGridData()
            local NewPocketName = ValidRecycleDropGridData.PocketData.Name
            ValidRecycleDropGridData.TreasureData = TreasureData
            TreasureData.Position = NewTopLeft
            TreasureData.Direction = NewDir
            TreasureData.PocketName = NewPocketName
            if not self.InventoryModel.TreasureItems[NewPocketName] then
                self.InventoryModel.TreasureItems[NewPocketName] = {}
            end
            self.InventoryModel.TreasureItems[NewPocketName][TreasureData.UUid] = TreasureData
            self:RequestUpdateView(TreasureData)
        end
        return true
    end
    return true
end

function Component:GetValidTopLeftInRectByTreasureData(TreasureData, TargetPocketName, StartTopLeft, Width, Height, bCheckOverlap)
    if not TreasureData or not TargetPocketName or not StartTopLeft or not Width or not Height then return nil end
    local Dir = self.MainWidget.GamepadChangeDragItemDirectionTable and self.MainWidget.GamepadChangeDragItemDirectionTable[self.DragDetectedRequestID] or TreasureData.Direction
    local TW, TH = self:GetWHByDir(TreasureData.Size, Dir)
    for Y = StartTopLeft.Y, StartTopLeft.Y + Height - 1 do
        for X = StartTopLeft.X, StartTopLeft.X + Width - 1 do
            local TopLeft = FVector2D(X, Y)
            local Valid = self:RectValidFunc(TreasureData, TargetPocketName, TopLeft, TW, TH, bCheckOverlap) or false
            if Valid then
                return { TopLeft = TopLeft, Direction = Dir, bSwitchDirection = false }
            end
        end
    end
    if self.MainWidget.GamepadChangeDragItemDirectionTable and self.MainWidget.GamepadChangeDragItemDirectionTable[self.DragDetectedRequestID] then
        return
    end
    local AltDir = Dir == InventoryCommonConst.Direction.Horizontal and InventoryCommonConst.Direction.Vertical or InventoryCommonConst.Direction.Horizontal
    local AW, AH = self:GetWHByDir(TreasureData.Size, AltDir)
    for Y = StartTopLeft.Y, StartTopLeft.Y + Height - 1 do
        for X = StartTopLeft.X, StartTopLeft.X + Width - 1 do
            local TopLeft = FVector2D(X, Y)
            local Valid = self:RectValidFunc(TreasureData, TargetPocketName, TopLeft, AW, AH, bCheckOverlap) or false
            if Valid then
                return { TopLeft = TopLeft, Direction = AltDir, bSwitchDirection = true }
            end
        end
    end
    return nil
end

function Component:GetNewUUid()
    if not self.NewUUid then
        self.NewUUid = 0
    elseif self.NewUUid >= math.maxinteger then
        self.NewUUid = 0
    else
        self.NewUUid = self.NewUUid + 1
    end
    return self.NewUUid
end

function Component:CreateTreasureDataToPocket(TargetPocketData, TargetTreasureData)
    if not TargetPocketData or not TargetTreasureData then return false end
    local TargetPocketName = TargetPocketData.Name
    local TreasureId = TargetTreasureData.TreasureId
    local Position = TargetTreasureData.Position
    local UUid = TargetTreasureData.UUid
    local Direction = TargetTreasureData.Direction
    local TreasureInfo = DataMgr.ExtractionTreasure[TreasureId]
    if not TreasureInfo then return false end
    local Size = FVector2D(1, 1)
    local Shape = TreasureInfo.Shape
    for i, Pos in ipairs(Shape) do
        if i == 1 then
            Size.X = Pos
        elseif i == 2 then
            Size.Y = Pos
        end
    end
    local Dir = Direction or InventoryCommonConst.Direction.Horizontal
    local Width, Height = self:GetWHByDir(Size, Dir)
    if TargetPocketData.bRecycle then
        Width, Height = 1, 1
    end
    if not self._TreasureIconCache then self._TreasureIconCache = {} end
    if not self._TreasureIconCache[TreasureId] then
        self._TreasureIconCache[TreasureId] = TreasureInfo.Icon and LoadObject(TreasureInfo.Icon) or LoadObject("/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_Coin_Other_Mod.T_Coin_Other_Mod")
    end
    local Texture = self._TreasureIconCache[TreasureId]
    local TreasureData = {
        TreasureId = TreasureId,
        UUid = UUid or self:GetNewUUid(),
        PocketName = TargetPocketName,
        Position = Position,
        bNotSearched = TargetTreasureData.bNotSearched,
        Texture = Texture,
        Size = Size,
        Direction = Dir,
        bInRecycleGrid = TargetPocketData.bRecycle,
    }
    if not self.InventoryModel.Pockets[TargetPocketName] then
        self.InventoryModel.Pockets[TargetPocketName] = TargetPocketData
        self:InitGridsData(TargetPocketData)
    end
    local MoveData = {
        bCreateTreasureDataToPocket = true,
        bCanMove = true,
        StartInfo = {
            Type = "SystemGenerate",
            DragGridData = nil,
            TreasureData = TreasureData,
            TopLeft = nil,
            Direction = Dir,
        },
        EndInfo = {
            Type = TargetPocketData.bRecycle and "RecycleGrid" or "Grid",
            PocketData = TargetPocketData,
            TopLeft = Position,
            Direction = Dir,
            bCanPlace = true,
        },
    }
    if self:ApplyItemMoveData(MoveData) then
        if self.MainWidget and IsValid(self.MainWidget) and IsValid(TargetPocketData.Pocket) then
            local TreasureWidget = TargetPocketData.Pocket:CreateIconItem(TreasureData.Size, TreasureData.Texture, TreasureData.Position)
            if TreasureWidget then
                TreasureWidget:Init(TreasureData)
            end
        end
        EventManager:FireEvent(EventID.OnTreasureItemDrop, MoveData)
        return true
    end
    return false
end
-------------------------------Grids相关------------------------------
function Component:GetWHByDir(Size, Dir)
    if Dir == InventoryCommonConst.Direction.Horizontal then
        return Size.X, Size.Y
    elseif Dir == InventoryCommonConst.Direction.Vertical then
        return Size.Y, Size.X
    else
        return Size.X, Size.Y
    end
end

function Component:ComputeTopLeftFromCenter(TreasureData, PocketName, Center, Width, Height)
    local TopLeftX = Center.X - (Width - 1) / 2
    local TopLeftY = Center.Y - (Height - 1) / 2
    local TopLeftXList = {TopLeftX}
    local TopLeftYList = {TopLeftY}
    if Width % 2 == 0 then
        table.insert(TopLeftXList, TopLeftX + 1)
    end
    if Height % 2 == 0 then
        table.insert(TopLeftYList, TopLeftY + 1)
    end

    local Result = {
        ValidResults = {},
        InvalidResults = {},
    }
    for _, x in ipairs(TopLeftXList) do
        for _, y in ipairs(TopLeftYList) do
            if x % 1 == 0.5 then
                x = x - 0.5
            end
            if y % 1 == 0.5 then
                y = y - 0.5
            end
            local bRectValid = self:RectValidFunc(TreasureData, PocketName, FVector2D(x, y), Width, Height, true) or false
            if bRectValid then
                table.insert(Result.ValidResults, FVector2D(x, y))
            else
                table.insert(Result.InvalidResults, FVector2D(x, y))
            end
        end
    end
    return Result
end

function Component:RectValidFunc(TreasureData, PocketName, TopLeft, Width, Height, bCheckOverlap, IgnoreTreasureDatas)
    if not TopLeft or not PocketName then return false end
    local PocketGridDatas = self.InventoryModel.Grids[PocketName]
    if not PocketGridDatas then return false end
    local MinX = TopLeft.X
    local MinY = TopLeft.Y
    local MaxX = TopLeft.X + Width - 1
    local MaxY = TopLeft.Y + Height - 1
    for X = MinX, MaxX do
        local Col = PocketGridDatas[X]
        if not Col then
            DebugPrint("lgc@RectValidFunc Col == nil  PocketName: ", PocketName , TopLeft, Width, Height)
            return false 
        end
        for Y = MinY, MaxY do
            local GridData = Col[Y]
            if not GridData then 
                DebugPrint("lgc@RectValidFunc GridData == nil  PocketName: ", PocketName , TopLeft, Width, Height)
                return false 
            end
        end
    end
    local OverlappedSet = {}
    local GridDatas = self:GetTargetGridDatas(PocketName, TopLeft, Width, Height)
    for _, GridData in ipairs(GridDatas) do
        if bCheckOverlap then
            local TargetTreasureData = GridData and GridData.TreasureData
            if TargetTreasureData and not OverlappedSet[TargetTreasureData] and TreasureData ~= TargetTreasureData and (not IgnoreTreasureDatas or not IgnoreTreasureDatas[TargetTreasureData]) then
                OverlappedSet[TargetTreasureData] = true
                local IWidth, IHeight = self:GetWHByDir(TargetTreasureData.Size, TargetTreasureData.Direction)
                local ITopLeft = TargetTreasureData.Position
                local IMinX = ITopLeft.X
                local IMinY = ITopLeft.Y
                local IMaxX = ITopLeft.X + IWidth - 1
                local IMaxY = ITopLeft.Y + IHeight - 1
                if not (IMinX >= MinX and IMinY >= MinY and IMaxX <= MaxX and IMaxY <= MaxY) then
                    return false
                end
            end
        else
            if GridData.TreasureData and (not IgnoreTreasureDatas or not IgnoreTreasureDatas[GridData.TreasureData]) then
                return false
            end
        end
    end
    return true
end

function Component:GetTargetGridDatas(PocketName, TopLeft, Width, Height)
    if TopLeft == nil then
        DebugPrint("TopLeft is nil")
        return {}
    end
    local GridDatas = {}
    for X = TopLeft.X, TopLeft.X + Width - 1 do
        for Y = TopLeft.Y, TopLeft.Y + Height - 1 do
            local GridData = nil
            if self.InventoryModel.Grids[PocketName] and self.InventoryModel.Grids[PocketName][X] and self.InventoryModel.Grids[PocketName][X][Y] then
                GridData = self.InventoryModel.Grids[PocketName][X][Y]
            end
            if GridData then
                table.insert(GridDatas, GridData)
            end
        end
    end
    return GridDatas
end

function Component:GetValidTopLeftByTreasureId(TargetPocketName, TreasureId, PreferredDirection)
    if not TargetPocketName or not TreasureId then return nil end
    if not self.InventoryModel.Grids[TargetPocketName] then return end
    local GridDatas = self.InventoryModel.Grids[TargetPocketName]
    if not GridDatas then return end
    local MinX, MaxX, MinY, MaxY = math.huge, -math.huge, math.huge, -math.huge
    for X, Col in pairs(GridDatas) do
        if type(X) == "number" then
            if X < MinX then MinX = X end
            if X > MaxX then MaxX = X end
            for Y, GridData in pairs(Col) do
                if type(Y) == "number" then
                    if Y < MinY then MinY = Y end
                    if Y > MaxY then MaxY = Y end
                end
            end
        end
    end
    if MinX == math.huge then return end
    local StartTopLeft = FVector2D(MinX, MinY)
    local RegionWidth = MaxX - MinX + 1
    local RegionHeight = MaxY - MinY + 1
    
    local TreasureInfo = DataMgr and DataMgr.ExtractionTreasure and DataMgr.ExtractionTreasure[TreasureId]
    if not TreasureInfo or not TreasureInfo.Shape then return nil end
    local Size = FVector2D(1, 1)
    for i, Pos in ipairs(TreasureInfo.Shape) do
        if i == 1 then
            Size.X = Pos
        elseif i == 2 then
            Size.Y = Pos
        end
    end
    local Dir = PreferredDirection or InventoryCommonConst.Direction.Horizontal
    local TempTreasureItem = {
        Size = Size,
        Direction = Dir,
    }
    local ValidInfo = self:GetValidTopLeftInRectByTreasureData(TempTreasureItem, TargetPocketName, StartTopLeft, RegionWidth, RegionHeight, false)
    return ValidInfo
end

function Component:ClearPocketView(PocketName)
    if not PocketName then return false end
    local PocketWidget = self:GetPocketWidget(PocketName)
    if not PocketWidget or not IsValid(PocketWidget) then return false end
    local Panel = PocketWidget.Panel_Item
    if Panel and IsValid(Panel) then
        if Panel.ClearChildren then
            Panel:ClearChildren()
        end
    end
    return true
end

return Component

