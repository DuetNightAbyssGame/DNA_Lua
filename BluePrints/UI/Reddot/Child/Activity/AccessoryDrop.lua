local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

local ReddotTreeNode_AccessoryDrop = Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")

function ReddotTreeNode_AccessoryDrop:_Judge(EventId)
    local PlayerAvatar = GWorld:GetAvatar()
    local AccessoryDrop = PlayerAvatar.AccessoryDrops[EventId]
    if not AccessoryDrop then
        return
    end
    local TryOutServerData = PlayerAvatar.CharTrial[EventId]

    local AccessDropConfig = DataMgr.BoxDrop[EventId]
    local BoxCoin = GWorld:GetAvatar().Resources[AccessDropConfig.BoxCoinId]
    local OwnBoxCoinAmount = BoxCoin and BoxCoin.Count or 0
    local CoinPerBox = AccessDropConfig.CoinPerBox
    local BoxCount = OwnBoxCoinAmount > 0 and math.floor(OwnBoxCoinAmount / CoinPerBox) or 0
    local TodayCanOpenBoxCount = BoxCount > AccessoryDrop.CurDropBoxNum and AccessoryDrop.CurDropBoxNum or BoxCount
    if TodayCanOpenBoxCount > 0 then
        if self.Cache.Detail["Red"] == nil or self.Cache.Detail["Red"] == 0 then
            return true
        else
            return false
            -- ReddotManager.IncreaseLeafNodeCount(self.Name, 1, {CacheKey="Red", EventId=EventId})
        end
    else
        if self.Cache.Detail["Red"] ~= nil and self.Cache.Detail["Red"] == 1 then
            return false
        else
            return true
            -- ReddotManager.IncreaseLeafNodeCount(self.Name, 1, {CacheKey="Red", EventId=EventId})
        end
    end
end

-- function ReddotTreeNode_AccessoryDrop:OnDecreaseJudge(SubValue, CacheDetailChangedParams)
--     if not CacheDetailChangedParams then return true end
--     if (CacheDetailChangedParams.bClearAll) then
--         return true
--     end
--     local CacheDetail = self.Cache.Detail
--     local CacheKey = CacheDetailChangedParams.CacheKey
--     local EventId = CacheDetailChangedParams.EventId
--     if SubValue == 1 and CacheKey and EventId and CacheDetail[CacheKey]==1 then
--         if CacheKey == "New" then
--             return true
--         elseif CacheKey == "Red" then
--             return self:_Judge(EventId)
--         end
--     end
--     return false
-- end

function ReddotTreeNode_AccessoryDrop:OnRefreshNodeData(EventId)
    ReddotManager.IncreaseLeafNodeCount(self.Name, 1, {CacheKey="New", EventId=EventId})
    -- if self:_Judge(EventId) then
    --     ReddotManager.IncreaseLeafNodeCount(self.Name, 1, {CacheKey="Red", EventId=EventId})
    -- else
    --     ReddotManager.DecreaseLeafNodeCount(self.Name, 1, {CacheKey="Red", EventId=EventId})
    -- end
end

return ReddotTreeNode_AccessoryDrop
