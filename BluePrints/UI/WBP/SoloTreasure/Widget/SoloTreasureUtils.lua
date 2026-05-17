--
-- DESCRIPTION
--
-- @COMPANY ** 搜打撤Utils
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local InventoryController = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryController")

---@type SoloTreasureUtils
local M = {}

function M:InitBagUI(BagWidget, ShapeType)
    if not BagWidget or not ShapeType then
        return
    end
    BagWidget.Switch_BagType:SetActiveWidgetIndex(ShapeType)
end

function M:TickTriggerScrollSizeBox(TriggerParams)
    if not InventoryController or not InventoryController.bInit or not InventoryController.bDraging then
        if TriggerParams.TriggerScrollUp then
            TriggerParams.TriggerScrollUp:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        if TriggerParams.TriggerScrollDown then
            TriggerParams.TriggerScrollDown:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        return
    end
    self:TickShowTriggerScrollArrow(TriggerParams)
    if not TriggerParams.TriggerScrollUp:IsVisible() and not TriggerParams.TriggerScrollDown:IsVisible() then
        return
    end

    local DeltaTime = TriggerParams.DeltaTime
    local ScrollBox = TriggerParams.ScrollBox
    local TriggerScrollUp = TriggerParams.TriggerScrollUp
    local TriggerScrollDown = TriggerParams.TriggerScrollDown
    local ScrollOffset = TriggerParams.ScrollOffset or 100 -- 每次触发滚动偏移量
    local CurTouchPos = TriggerParams.CurTouchPos or nil -- 移动端

    if not ScrollBox then return end
    local TriggerFrequency = 30 -- 触发频率，20次/秒
    if not self.ScrollBoxThrottleTimes then
        self.ScrollBoxThrottleTimes = {}
    end
    local Elapsed = (self.ScrollBoxThrottleTimes[ScrollBox] or 0) + (DeltaTime or 0)
    if Elapsed < 1 / TriggerFrequency then
        self.ScrollBoxThrottleTimes[ScrollBox] = Elapsed
        return
    end
    self.ScrollBoxThrottleTimes[ScrollBox] = Elapsed - 1 / TriggerFrequency

    local MouseDownPos = nil
    if UIUtils and UIUtils.IsMobileInput() then
        MouseDownPos = CurTouchPos
    else
        MouseDownPos = UE4.UWidgetLayoutLibrary.GetMousePositionOnPlatform()
    end
    if not MouseDownPos then return end
    local ScrollGeometry = ScrollBox:GetCachedGeometry()
    local IsUnderScroll = USlateBlueprintLibrary.IsUnderLocation(ScrollGeometry, MouseDownPos)
    if not IsUnderScroll then
        return
    end

    --计算是否需要滚动偏移
    local ScrollUpCachedGeometry = TriggerScrollUp and TriggerScrollUp:GetCachedGeometry()
    local IsUnderInScrollUp = ScrollUpCachedGeometry and USlateBlueprintLibrary.IsUnderLocation(ScrollUpCachedGeometry, MouseDownPos)
    if IsUnderInScrollUp then
        self:AutoSetScrollBoxOffSet(ScrollBox, -ScrollOffset)
    end
    local ScrollDownCachedGeometry = TriggerScrollDown and TriggerScrollDown:GetCachedGeometry()
    local IsUnderInScrollDown = ScrollDownCachedGeometry and USlateBlueprintLibrary.IsUnderLocation(ScrollDownCachedGeometry, MouseDownPos)
    if IsUnderInScrollDown then
        self:AutoSetScrollBoxOffSet(ScrollBox, ScrollOffset)
    end
end

function M:AutoSetScrollBoxOffSet(ScrollBox, ScrollOffset)
    if not ScrollBox then
        return
    end
    --获取当前的滚动偏移
    local CurScrollOffset = ScrollBox:GetScrollOffset()
    local TargetScrollOffset = CurScrollOffset + ScrollOffset
    local IsUp = ScrollOffset < 0
    CurScrollOffset = CurScrollOffset + ScrollOffset / 5
    if IsUp then
        CurScrollOffset = math.max(CurScrollOffset, 0)
    else
        CurScrollOffset = math.min(CurScrollOffset, TargetScrollOffset)
    end
    ScrollBox:SetScrollOffset(CurScrollOffset)
end

function M:TickShowTriggerScrollArrow(TriggerParams)
    local ShowPocketsScrollUpArrow = TriggerParams.ShowPocketsScrollUpArrow
    local ShowPocketsScrollDownArrow = TriggerParams.ShowPocketsScrollDownArrow
    local TriggerScrollUp = TriggerParams.TriggerScrollUp
    local TriggerScrollDown = TriggerParams.TriggerScrollDown
    if not ShowPocketsScrollUpArrow and not ShowPocketsScrollDownArrow then
        return
    end
    local CurPos = nil
    if UIUtils and UIUtils.IsMobileInput() then
        CurPos = TriggerParams.CurTouchPos
    else
        CurPos = UE4.UWidgetLayoutLibrary.GetMousePositionOnPlatform()
    end
    if not CurPos then
        return
    end
    local StateKey = tostring(TriggerScrollUp) .. "|" .. tostring(TriggerScrollDown)
    self._ScrollArrowState = self._ScrollArrowState or {}
    local GroupState = self._ScrollArrowState[StateKey]
    if not GroupState then
        GroupState = {}
        self._ScrollArrowState[StateKey] = GroupState
    end
    if ShowPocketsScrollUpArrow and TriggerScrollUp then
        local UpGeometry = ShowPocketsScrollUpArrow:GetCachedGeometry()
        local IsUnderUp = UpGeometry and USlateBlueprintLibrary.IsUnderLocation(UpGeometry, CurPos)
        if GroupState.Up ~= IsUnderUp then
            GroupState.Up = IsUnderUp
            if IsUnderUp and TriggerScrollUp.In then
                TriggerScrollUp:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
                TriggerScrollUp:StopAllAnimations()
                TriggerScrollUp:PlayAnimation(TriggerScrollUp.In)
            elseif not IsUnderUp and TriggerScrollUp.Out then
                TriggerScrollUp:SetVisibility(UE4.ESlateVisibility.Collapsed)
                -- TriggerScrollUp:StopAllAnimations()
                -- TriggerScrollUp:PlayAnimation(TriggerScrollUp.Out)
            end
        end
    end
    if ShowPocketsScrollDownArrow and TriggerScrollDown then
        local DownGeometry = ShowPocketsScrollDownArrow:GetCachedGeometry()
        local IsUnderDown = DownGeometry and USlateBlueprintLibrary.IsUnderLocation(DownGeometry, CurPos)
        if GroupState.Down ~= IsUnderDown then
            GroupState.Down = IsUnderDown
            if IsUnderDown and TriggerScrollDown.In then
                TriggerScrollDown:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
                TriggerScrollDown:StopAllAnimations()
                TriggerScrollDown:PlayAnimation(TriggerScrollDown.In)
            elseif not IsUnderDown and TriggerScrollDown.Out then
                TriggerScrollDown:SetVisibility(UE4.ESlateVisibility.Collapsed)
            --     TriggerScrollDown:StopAllAnimations()
            --     TriggerScrollDown:PlayAnimation(TriggerScrollDown.Out)
            end
        end
    end
end

-- 获取指定口袋内所有物资的价值信息
-- @param PocketName string 口袋名
-- @return table {
--     TotalValue = number,             -- 口袋内物资总价值
--     Items = {                        -- 各物资明细
--         [UUid] = {
--             UUid      = number,
--             TreasureId = number,
--             Value      = number,     -- 单件价值（已含Buff倍率）
--         },
--         ...
--     }
-- }
function M:GetPocketTreasureValueInfo(PocketName)
    local Result = {
        TotalValue = 0,
        Items = {},
    }
    if not PocketName then return Result end
    local TreasureItemDatas = InventoryController.InventoryModel.TreasureItems[PocketName]
    if not TreasureItemDatas then return Result end
    for UUid, TreasureItemData in pairs(TreasureItemDatas) do
        local TreasureInfo = DataMgr.ExtractionTreasure[TreasureItemData.TreasureId]
        if TreasureInfo then
            local Value = TreasureInfo.TreasureValue * (tonumber(TreasureItemData.BuffLabelInfo and TreasureItemData.BuffLabelInfo.Num) or 1)
            Result.Items[UUid] = {
                UUid = UUid,
                TreasureId = TreasureItemData.TreasureId,
                Value = Value,
            }
            Result.TotalValue = Result.TotalValue + Value
        end
    end
    return Result
end

return M
