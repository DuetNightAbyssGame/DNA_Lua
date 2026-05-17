---@class ForgePathNode
---@field DraftId number @资源对应的设计稿ID
---@field ResourceType string @资源Type,目前支持"Resource","Mod"
---@field ResourceId number @资源ID
---@field ResNeedNum number @所需数量
---@field Pos number @UI上的相对位置，根节点位置默认为3，子节点位置可以为1、2、4、5
---@field RowIndex number @节点位于的行号
---@field ColIndex number @节点在这一行的列号


---@class ForgePathModel 
---@field RowNumber number @总行数
---@field RowInfos ForgePathNode[] @每一行节点数据
---@field RowSelectedIndex number[] @每一行被选中的设计稿位置下标

---@type ForgePathModel
local ForgePathModel = {}

require "UnLua"

-- |1|2|3|4|5|

-- 预处理每个产物对应的设计稿，对于同一个产物对应多种设计稿的情况，优先选择设计稿ID小的
function ForgePathModel:PreInitData()
end

function ForgePathModel:GetModel(DraftId)
    local Model = {
        MaterialMap = DataMgr.Item2DraftIdMap,
        RowNumber = 1,
        RowInfos = {},
        RowSelectedIndex = {},
    }
    Model.RowInfos[1] = {self:ConstructNodeFromDraftId(DraftId, 1, 1)}
    setmetatable(Model, {__index = ForgePathModel})
    return Model
end

function ForgePathModel:ConstructNodeFromDraftId(DraftId, RowIndex, ColIndex)
    local DraftInfo = DataMgr.Draft[DraftId]
    
    ---@type ForgePathNode
    local Node = {RowIndex = RowIndex, ColIndex = ColIndex}
    Node.DraftId = DraftId 
    Node.ResourceId = DraftInfo.ProductId
    Node.ResourceType = DraftInfo.ProductType

    if RowIndex == 1 then 
        Node.Pos = 3
    else 
        Node.Pos = ColIndex >= 3 and ColIndex + 1 or ColIndex
    end
    
    return Node
end

function ForgePathModel:ConstructNodeFromResourceId(ResInfo, RowIndex, ColIndex)
    ---@type ForgePathNode
    local Node = {RowIndex = RowIndex, ColIndex = ColIndex}
    local DraftIds = self.MaterialMap[ResInfo.Type or "Resource"][ResInfo.Id].DraftIds
    Node.DraftId = DraftIds and DraftIds[1] or nil
    Node.ResourceId = ResInfo.Id 
    Node.ResourceType = ResInfo.Type or "Resource"
    Node.ResNeedNum = ResInfo.Num

    if RowIndex == 1 then 
        Node.Pos = 3
    else 
        Node.Pos = ColIndex >= 3 and ColIndex + 1 or ColIndex
    end

    return Node
end

function ForgePathModel:GetNode(RowIndex, ColIndex)
    if not self.RowInfos[RowIndex] then 
        return nil 
    end

    if not self.RowInfos[RowIndex][ColIndex] then 
        return nil 
    end

    return self.RowInfos[RowIndex][ColIndex]
end

function ForgePathModel:GetRowNum(RowIndex)
    if not self.RowInfos[RowIndex] then return 0 end 
    return #self.RowInfos[RowIndex]
end

function ForgePathModel:GetPathMaxLen(DraftId)
    local ProductId = DataMgr.Draft[DraftId].ProductId
    local ProductType = DataMgr.Draft[DraftId].ProductType
    return DataMgr.Item2DraftIdMap[ProductType][ProductId].MaxLen
end

return ForgePathModel