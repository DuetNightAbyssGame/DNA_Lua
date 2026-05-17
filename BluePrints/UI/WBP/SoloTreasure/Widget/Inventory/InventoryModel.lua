
--- @class InventoryModel :Model
local InventoryModel = Class()


function InventoryModel:Init(Params)
    self.SlotState = {}
    self.bInit = true
    if not Params then
        return
    end
    self:InitDatas(Params)
end

function InventoryModel:InitDatas(Params)
    -- 通过self.Grids[PocketName][X][Y]拿到GridData
    -- GridData结构：{
    --     Position = FVector2D(X, Y),
    --     PocketData = PocketData,
    --     TreasureItem = TreasureItemData,
    --     Grid = UserWidget,
    --     bRecycle = bool,
    -- }
    self.Grids = (Params.Grids or self.Grids) or {} 


    -- 通过self.Pockets[PocketName]拿到PocketData
    -- PocketData结构：{
    --     PocketName = String,
    --     Inventory = InventoryCommonConst.PocketType,
    --     Pocket = UserWidget,
    --     bRecycle = bool,
    -- }
    self.Pockets = (Params.Pockets or self.Pockets) or {} 


    -- 通过self.TreasureItems[PocketName][UUid]拿到TreasureItemData
    -- TreasureItemData结构：{
    --     UUid = Num,
    --     TreasureId = Num,
    --     Treasure = UserWidget,
    --     bInRecycleGrid = bool,
    --     Size = FVector2D(X, Y),
    --     Direction = InventoryCommonConst.Direction,
    -- }
    self.TreasureItems = (Params.TreasureItems or self.TreasureItems) or {} 

    self.BagId = (Params.BagId or self.BagId) or 0
end

function InventoryModel:DestroyDatas()
    self.Grids = {}
    self.Pockets = {}
    self.TreasureItems = {}
    self.BagId = 0
end

function InventoryModel:Destory()
    self.bInit = false
    self:DestroyDatas()
end

return InventoryModel
