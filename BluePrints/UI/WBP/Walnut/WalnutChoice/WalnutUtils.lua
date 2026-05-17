require "UnLua"
local EMCache = require "EMCache.EMCache"

---@type WalnutUtils
local M = {}

function M:GetWalnutCacheIdByDungeonId(DungeonId)
    if not DungeonId then
        return nil
    end
    
    -- 遍历 DataMgr.WalnutSelectDungeon，查找匹配的 DungeonId
    local WalnutType = nil
    for _, WalnutSelectDungeonData in pairs(DataMgr.WalnutSelectDungeon) do
        if WalnutSelectDungeonData and WalnutSelectDungeonData.DungeonId then
            -- 检查 DungeonId 数组中是否包含传入的 DungeonId
            for _, Id in pairs(WalnutSelectDungeonData.DungeonId) do
                if Id == DungeonId then
                    WalnutType = WalnutSelectDungeonData.WalnutType
                    break
                end
            end
            if WalnutType then
                break
            end
        end
    end
    
    if not WalnutType then
        return nil
    end
    
    -- 根据 WalnutType 从 EMCache 中获取对应的 Cache
    local CacheKey = "WalnutIDType" .. WalnutType
    local WalnutCacheId = EMCache:Get(CacheKey, true, true)
    return WalnutCacheId, WalnutType
end

function M:SetWalnutCacheId(WalnutId, WalnutType)
    if not WalnutId then return end
    if not WalnutType then return end

    local CacheKey = "WalnutIDType" .. WalnutType
    EMCache:Set(CacheKey, WalnutId, true)
end

function M:CheckWalnutCanPurchase(WalnutId)
    if not WalnutId or WalnutId <= 0 then
        return false, nil
    end
    
    local WalnutData = DataMgr["Walnut"][WalnutId]
    if not WalnutData or not WalnutData.AccessKey then
        return false, nil
    end
    
    -- 查找是否有 Shop 类型的 AccessKey
    for _, AccessKey in pairs(WalnutData.AccessKey) do
        local AccessData = DataMgr.Access[AccessKey]
        if AccessData then
            local ShopType
            local ActualAccessKey = AccessKey
            if string.sub(AccessKey, 1, 5) == "Shop_" and AccessKey ~= "Shop_Pack" then
                ShopType = AccessData.AccessParam
                ActualAccessKey = "Shop"
            elseif AccessKey == "Shop" then
                ShopType = AccessData.AccessParam or "Shop"
                ActualAccessKey = "Shop"
            end
            
            if ActualAccessKey == "Shop" then
                -- 检查是否可以购买
                if DataMgr.ShopItem2ShopSubId["Walnut"] and DataMgr.ShopItem2ShopSubId["Walnut"][ShopType] and DataMgr.ShopItem2ShopSubId["Walnut"][ShopType][WalnutId] then
                    local ShopDatas = DataMgr.ShopItem2ShopSubId["Walnut"][ShopType][WalnutId]
                    for _, ShopData in ipairs(ShopDatas) do
                        if ShopUtils:GetShopItemCanShow(ShopData.ShopItemId) and ShopUtils:GetShopItemPurchaseLimit(ShopData.ShopItemId) ~= 0 then
                            return true, ShopType
                        end
                    end
                end
            end
        end
    end
    
    return false, nil
end

return M