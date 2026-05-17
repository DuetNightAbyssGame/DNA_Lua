local BagGameModel = require "BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameModel"

local ReddotTreeNode_BagGame = Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")

--region 初始化
function ReddotTreeNode_BagGame:OnInitNodeCache(NodeCache)
    self.bImplemented = true
    self.bInvokeEveryTime = true
    NodeCache.Count = 0
    NodeCache.Detail = NodeCache.Detail or {}
    local Avatar = GWorld:GetAvatar()
    if not Avatar or not Avatar:CheckUIUnlocked("GameEvent") then
        NodeCache.Detail = {}
        return
    end

    if self.Name == "BagGameAward" then
        self:_InitAwardCache(NodeCache)
        -- 此时 self.Count 尚未被 InitNodeCache 更新，用 NodeCache.Count 设置聚合键
        NodeCache.Detail["Red"] = NodeCache.Count > 0 and 1 or 0
    elseif self.Name == "BagGameNew" then
        self:_InitNewCache(NodeCache)
        NodeCache.Detail["New"] = NodeCache.Count > 0 and 1 or 0
    end

    self:_JudgeReddotType(NodeCache.Detail)
end

--- Award: 遍历全部关卡，检查有可领取奖励的关卡
--- 直接设置 Detail 和 Count，不调用 IncreaseLeafNodeCount（避免 OnIncreaseJudge 误判 + InitNodeCache 翻倍）
function ReddotTreeNode_BagGame:_InitAwardCache(NodeCache)
    local LevelsInfo = DataMgr.BackpackPuzzleLevel
    if not LevelsInfo then return end
    -- Award 缓存完全由服务端数据驱动，每次初始化重建
    NodeCache.Detail = {}
    for LevelId, _ in pairs(LevelsInfo) do
        if BagGameModel:HasRewardToGet(LevelId) then
            NodeCache.Detail[LevelId] = true
            NodeCache.Count = NodeCache.Count + 1
        end
    end
end

--- New: 从 UserCache 恢复残留的 New 标记（不自动产生新 New）
--- 直接设置 Count，不调用 IncreaseLeafNodeCount（避免 OnIncreaseJudge 误判 + InitNodeCache 翻倍）
function ReddotTreeNode_BagGame:_InitNewCache(NodeCache)
    for k, v in pairs(NodeCache.Detail) do
        if type(k) == "number" and v == true then
            NodeCache.Count = NodeCache.Count + 1
        end
    end
end
--endregion

--region 聚合键管理
--- 根据当前 Count 更新 "New"/"Red" 聚合键
function ReddotTreeNode_BagGame:_UpdateAggregateKey()
    local CacheDetail = self.Cache.Detail
    if self.Name == "BagGameAward" then
        CacheDetail["Red"] = self.Count > 0 and 1 or 0
    elseif self.Name == "BagGameNew" then
        CacheDetail["New"] = self.Count > 0 and 1 or 0
    end
end
--endregion


--- BagGame 的红点刷新由业务层驱动（BagGameNew 由选关页面列表刷新驱动，BagGameAward 由属性变更驱动）
-- function ReddotTreeNode_BagGame:OnRefreshNodeData(EventId)
-- end


--region 重写 Increase/Decrease（per-LevelId 粒度）
function ReddotTreeNode_BagGame:OnIncreaseJudge(AddValue, Params)
    if not Params then return true end
    local LevelId = Params.LevelId
    if not LevelId then return false end
    if self.Name == "BagGameNew" then
        -- BagGameNew: nil=从未评估(允许), false=已查看(拒绝), true=当前New(拒绝)
        return self.Cache.Detail[LevelId] == nil
    end
    -- BagGameAward: nil或false都允许增加(奖励可反复出现)
    return not self.Cache.Detail[LevelId]
end

function ReddotTreeNode_BagGame:OnDecreaseJudge(SubValue, Params)
    if not Params then return true end
    local LevelId = Params.LevelId
    if not LevelId then return true end
    return self.Cache.Detail[LevelId] == true
end

function ReddotTreeNode_BagGame:OnIncreaseCount(AddValue, Params)
    if not Params then return end
    local LevelId = Params.LevelId
    if LevelId then
        self.Cache.Detail[LevelId] = true
    end
    self:_UpdateAggregateKey()
    self:JudgeReddotType(self.Cache.Detail)
end

function ReddotTreeNode_BagGame:OnDecreaseCount(SubValue, Params, OldCount)
    if not Params then return end
    local LevelId = Params.LevelId
    if LevelId then
        if self.Name == "BagGameNew" then
            -- 标记为已查看，防止列表刷新时重新标记 New
            self.Cache.Detail[LevelId] = false
        else
            self.Cache.Detail[LevelId] = nil
        end
    end
    self:_UpdateAggregateKey()
    self:JudgeReddotType(self.Cache.Detail)
end
--endregion

--region _Judge
function ReddotTreeNode_BagGame:_Judge(EventId)
    if self.Name == "BagGameAward" then
        local LevelsInfo = DataMgr.BackpackPuzzleLevel
        if not LevelsInfo then return false end
        for LevelId, _ in pairs(LevelsInfo) do
            if BagGameModel:HasRewardToGet(LevelId) then
                return true
            end
        end
    end
    return false
end
--endregion

return ReddotTreeNode_BagGame
