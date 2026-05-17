
local InventoryController = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryController")
local InventoryCommonConst = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryCommonConst")

---@type WBP_SoloTreasure_BagItem02
local M = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.Common.TimerMgr",
    "BluePrints.Common.DelayFrameComponent",
    "BluePrints.UI.BP_EMUserWidgetUtils_C",
})

function M:Construct()
    
end

function M:Destruct()
    
end

function M:Init(Params)
    self.bClosing = false
    self.bPocket = true
    self.Name = Params and Params.Name or nil
    self.PocketData = InventoryController.InventoryModel.Pockets[self.Name]
    if not self.PocketData then return end
    self.PocketData.Pocket = self
    self.Size = Params.Size or FVector2D(1, 1)
    self.Parent = Params.Parent or nil
    self.Inventory = Params.Inventory or nil
    self.bRecycle = self.Inventory == InventoryCommonConst.PocketType.Recycle
    self.bBag = self.Inventory == InventoryCommonConst.PocketType.Bag
    self.bMechanism = self.Inventory == InventoryCommonConst.PocketType.Mechanism
    if self.bRecycle then
        self.RecycleIndex = Params.RecycleIndex or 0
    elseif self.bBag then
        self.SubBagIndex = Params.SubBagIndex or 0
    elseif self.bMechanism then
        self.MechanismUid = Params.MechanismUid or 0
    end

    self:CreateBagItem()
    
    local AllGrids = self.WrapBoxBag:GetAllChildren():ToTable()
    for _, Grid in ipairs(AllGrids) do
        if Grid and IsValid(Grid) then
            Grid:Init({
                PocketData = self.PocketData,
            })
        end
    end

    self._SearchQueue = {}
    InventoryController:ClearPocketView(self.Name)
    local TreasureDatas = InventoryController.InventoryModel.TreasureItems[self.Name]
    if not TreasureDatas then return end
    local SearchTreasureDatas = {}
    for TreasureUId, TreasureData in pairs(TreasureDatas) do
        table.insert(SearchTreasureDatas, TreasureData)
    end
    table.sort(SearchTreasureDatas, function(a, b)
        local aX = a.Position.X or 100
        local bX = b.Position.X or 100
        local aY = a.Position.Y or 100
        local bY = b.Position.Y or 100
        if aY < bY then
            return true
        elseif aY == bY then
            if aX < bX then
                return true
            end
        end
        return false
    end)
    for _, TreasureData in pairs(SearchTreasureDatas) do
        local TreasureWidget = nil
        if TreasureData then
            TreasureWidget = self:CreateIconItem(TreasureData.Size, TreasureData.Texture, TreasureData.Position)
            if TreasureWidget then
                TreasureWidget:Init(TreasureData)
                if TreasureData.bNotSearched then
                    table.insert(self._SearchQueue, TreasureWidget)
                end
                TreasureData.Treasure = TreasureWidget
            end
        end
        if Params.bRequestAdsorptionToFirst then
            -- 回收站打开时的首次定位：使用 FORCE 确保立即执行且不被玩家输入取消
            -- geometry 零尺寸保护已在 TickTryAdsorptionWidget 中处理，无需延迟
            InventoryController:RequestAdsorption(TreasureWidget, InventoryCommonConst.AdsorptionPriority.FORCE)
            Params.bRequestAdsorptionToFirst = false
        end
    end
    if self.bMechanism and next(self._SearchQueue) then
        self:NotifyBeginSearch()
    end
end

function M:IsNeedInitBagView()
    if self.bInitSize then
        return false
    end
    local name = self.Name or self:GetName()
    local typeStr = string.match(name or "", "Type(%d%d)")
    local typeNum = tonumber(typeStr)
    local bagId = tonumber(InventoryController and InventoryController.InventoryModel and InventoryController.InventoryModel.BagId)
    local BagInfo = DataMgr.ExtractionTreasureBag[bagId]
    local ShapeType = tonumber((BagInfo and BagInfo.ShapeType) and BagInfo.ShapeType + 1 or nil)
    if typeNum and bagId and typeNum == ShapeType then
        self.bInitSize = true
        return true
    elseif name == "WBP_Search_Bag" then
        self.bInitSize = true
        return true
    elseif string.match(name or "", InventoryCommonConst.RecyclePocketNamePrefix.."(%d+)") then
        self.bInitSize = true
        return true
    end
    return false
end

function M:NotifyBeginSearch()
    if not self._SearchQueue or #self._SearchQueue == 0 then return end
    self.bSearchingActive = true
    self._SearchIndex = 1
    self:_ProcessNextSearchItem()
    self.Parent.Text_Search:SetText(GText("UI_Extraction_Identifing"))
end

function M:_ProcessNextSearchItem()
    if not self.bSearchingActive then return end
    while self._SearchIndex <= (#self._SearchQueue or 0) and not self.bClosing do
        local Item = self._SearchQueue[self._SearchIndex]
        self._SearchIndex = self._SearchIndex + 1
        if Item and IsValid(Item) and (not Item.bSearched) then
            self._CurrentSearching = Item
            Item:NotifyBeginSearch(function()
                if not self or not self.bSearchingActive or self.bClosing then return end
                if Item and IsValid(Item) then
                    Item.bSearched = true
                    Item.TreasureData.bNotSearched = false
                end
                self._CurrentSearching = nil
                self:AddDelayFrameFunc(function() if self then self:_ProcessNextSearchItem() end end, 1, "NextSearchItem")
            end)
            return
        end
    end
    self.bSearchingActive = false
    self.Parent.Text_Search:SetText(GText(self.Parent.ContainerTextMapId))
end

function M:Close()
    self.bClosing = true
    if self and IsValid(self) then
        self._SearchQueue = nil
        self.bSearchingActive = false
        if self._CurrentSearching and IsValid(self._CurrentSearching) and self._CurrentSearching.CancelSearch then
            self._CurrentSearching:CancelSearch()
        end
    end
end

return M
