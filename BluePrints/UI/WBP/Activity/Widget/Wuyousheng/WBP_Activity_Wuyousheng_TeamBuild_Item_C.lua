--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local ReddotManager = require "BluePrints.UI.Reddot.ReddotManager"

---@type WBP_Activity_Wuyousheng_TeamBuild_Item_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:OnListItemObjectSet(ItemObject)
    -- 检查ItemObject是否为nil（空内容情况）
    if not ItemObject then
        return
    end
    ItemObject.UI = self
    self.ItemObject = ItemObject
    self.Com_Item:OnListItemObjectSet(ItemObject)
    self.Item_Conflict.Text_Conflict:SetText(GText("UI_Wuyousheng_CharConflict"))
    if ItemObject.IsEmpty then
        self.WS_Item:SetActiveWidgetIndex(1)
    else
        self.WS_Item:SetActiveWidgetIndex(0)
        if ItemObject.Level then
            self.Item_TryOut.Com_Item_Level.Text_Lv:SetText(ItemObject.Level)
        else
            self.Item_TryOut.Com_Item_Level:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        if ItemObject.IsTryout and ItemObject.Tag ~= "Pet" then
            self.Item_TryOut.Text_TryOut:SetText(GText("UI_Wuyousheng_ArmoryTrial"))
            self.Item_TryOut.Text_TryOut:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            self.Item_TryOut.SizeBox_TryOut:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)

        else
            self.Item_TryOut.Text_TryOut:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.Item_TryOut.SizeBox_TryOut:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        -- 检查红点状态
        self:UpdateTryoutReddot()
        
        self:SetConflict(false)
    end
end

function M:SetItemSelect(IsSelected)
    self.bSelectTag = IsSelected
    self.Com_Item.bSelectTag = IsSelected
    self.Com_Item:SetItemSelect(IsSelected)
end

function M:SetConflict()
    if self.ItemObject.IsConflict then
        self.Item_Conflict:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Item_Conflict:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:BP_OnEntryReleased()
    -- 调用父类的BP_OnEntryReleased，确保Com_Item也正确清理
    if self.Com_Item and self.Com_Item.BP_OnEntryReleased then
        self.Com_Item:BP_OnEntryReleased()
    end
end

function M:OnItemClick()
    local ItemObject = self.ItemObject
    if ItemObject then
        -- 如果是试用物品，点击后隐藏红点并记录
        if ItemObject.IsTryout then
            self:MarkTryoutReddotRead()
        end
    end
end

-- 更新试用物品红点状态
function M:UpdateTryoutReddot()
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
    local ItemObject = self.ItemObject
    if not ItemObject or not ItemObject.IsTryout then
        return
    end
    
    local Type = ItemObject.Type or ItemObject.Tag or ""
    local Id = ItemObject.UnitId or ItemObject.Uuid
    if not Id then
        return
    end
    
    -- 使用 Type_Id 作为 CacheKey，防止不同 type 之间会有一样的 Id
    local CacheKey = Type .. "_" .. tostring(Id)
    
    local NodeName = "WuyoushengTryoutItem"
    
    -- 确保节点已初始化
    if not ReddotManager.GetTreeNode(NodeName) then
        ReddotManager.AddNodeEx(NodeName)
    end
    
    -- 获取缓存对象（不是 Detail），确保缓存结构存在
    local LeafNode = ReddotManager.LeafNodes[NodeName]
    if not LeafNode then
        return
    end
    
    -- 获取缓存对象
    local Cache = nil
    if LeafNode.CacheType == Const.ReddotCacheType.NoneCache then
        Cache = LeafNode.Cache
    else
        local CacheType = LeafNode.CacheType
        local CacheContainer = ReddotManager._GetCache(CacheType)
        if CacheContainer then
            if not CacheContainer[NodeName] then
                CacheContainer[NodeName] = {Count = 0, Detail = {}}
            end
            Cache = CacheContainer[NodeName]
        end
    end
    
    if not Cache or not Cache.Detail then
        return
    end
    
    local CacheDetail = Cache.Detail
    
    -- 如果CacheDetail[CacheKey] == 1，表示未点击过，显示红点
    if CacheDetail[CacheKey] == nil or CacheDetail[CacheKey] == 1 then
        DebugPrint("JLy 显示红点")
        CacheDetail[CacheKey] = 0
        self.New:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        DebugPrint("JLy 隐藏红点")
        self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

-- 标记试用物品红点为已读
function M:MarkTryoutReddotRead()
    local ItemObject = self.ItemObject
    if not ItemObject or not ItemObject.IsTryout then
        return
    end
    
    local Type = ItemObject.Type or ItemObject.Tag or ""
    local Id = ItemObject.UnitId or ItemObject.Uuid
    if not Id then
        return
    end
    
    -- 使用 Type_Id 作为 CacheKey，防止不同 type 之间会有一样的 Id
    local CacheKey = Type .. "_" .. tostring(Id)
    
    local NodeName = "WuyoushengTryoutItem"
    
    -- 确保节点已初始化
    if not ReddotManager.GetTreeNode(NodeName) then
        ReddotManager.AddNodeEx(NodeName)
    end
    
    -- 获取缓存对象（不是 Detail），确保缓存结构存在
    local LeafNode = ReddotManager.LeafNodes[NodeName]
    if not LeafNode then
        return
    end
    
    -- 获取缓存对象
    local Cache = nil
    if LeafNode.CacheType == Const.ReddotCacheType.NoneCache then
        Cache = LeafNode.Cache
    else
        local CacheType = LeafNode.CacheType
        local CacheContainer = ReddotManager._GetCache(CacheType)
        if CacheContainer then
            if not CacheContainer[NodeName] then
                CacheContainer[NodeName] = {Count = 0, Detail = {}}
            end
            Cache = CacheContainer[NodeName]
        end
    end
    
    if not Cache or not Cache.Detail then
        return
    end
    
    local CacheDetail = Cache.Detail
    
    -- 如果CacheDetail[CacheKey] == 1，表示未点击过，需要标记为已读
    if CacheDetail[CacheKey] == 1 or CacheDetail[CacheKey] == 0 then
        CacheDetail[CacheKey] = 0
        DebugPrint("JLy 隐藏红点")
        self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

return M
