require "UnLua"
local TimeUtils = require "Utils.TimeUtils"

local GuildWarUtils = {}

GuildWarUtils.ReddotNodeKey = "Acti_SoloRaidSub"
GuildWarUtils.ReddotRewardKey = "RaidReward"

GuildWarUtils.ShopCacheKey = "RaidShopCache"
GuildWarUtils.EntranceCacheKey  = "RaidEntranceCache"
GuildWarUtils.RewardGotCacheKey = "RaidRewardCache"

-- 是否是事件期间
function GuildWarUtils.IsEventTime()
    local SeasonData, EventData = GuildWarUtils.GetSeasonAndEventData()
    if not SeasonData or not EventData then
        return false
    end

    local StartTime = EventData.EventStartTime -- 事件开始时间 = 预选赛开始时间
    local EndTime = EventData.EventEndTime  -- 事件结束时间

    local CurTime = TimeUtils.NowTime()
    return (CurTime >= StartTime) and (CurTime <= EndTime)
end

-- 是否是赛事期间：预选赛 or 正式赛
function GuildWarUtils.IsRaidTime()
    local SeasonData, EventData = GuildWarUtils.GetSeasonAndEventData()
    if not SeasonData or not EventData then
        return false
    end

    local StartTime = EventData.EventStartTime -- 预选赛开始时间
    local EndTime = StartTime + SeasonData.PreRaidTime * 3600 + SeasonData.RaidTime * 3600 -- 正式赛结束时间

    local CurTime = TimeUtils.NowTime()
    return (CurTime >= StartTime) and (CurTime <= EndTime)
end

-- 是否是 预选赛期间
function GuildWarUtils.IsPreRaidTime()
    local SeasonData, EventData = GuildWarUtils.GetSeasonAndEventData()
    if not SeasonData or not EventData then
        return false
    end

    local StartTime = EventData.EventStartTime -- 预选赛开始时间
    local EndTime = StartTime + SeasonData.PreRaidTime * 3600 -- 预选赛结束时间

    local CurTime = TimeUtils.NowTime()
    return (CurTime >= StartTime) and (CurTime <= EndTime)
end

-- 是否是 正式赛期间
function GuildWarUtils.IsOfficalRaidTime()
    local SeasonData, EventData = GuildWarUtils.GetSeasonAndEventData()
    if not SeasonData or not EventData then
        return false
    end

    local StartTime = EventData.EventStartTime  + SeasonData.PreRaidTime * 3600  -- 正式赛开始时间
    local EndTime = StartTime + SeasonData.RaidTime * 3600 -- 正式赛结束时间

    local CurTime = TimeUtils.NowTime()
    return (CurTime >= StartTime) and (CurTime <= EndTime)
end

-- 获取当前赛季的 赛季数据 和 事件数据
function GuildWarUtils.GetSeasonAndEventData()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    -- 当前赛季数据
    local SeasonData = DataMgr.RaidSeason[Avatar.CurrentRaidSeasonId]
    if not SeasonData then
        return
    end

    -- 事件数据
    local EventData = DataMgr.EventMain[SeasonData.EventId]
    if not EventData then
        return
    end
    return SeasonData, EventData
end

-- 获取副本需要的门票信息
-- @param DungeonId 副本ID
-- @return ResId 资源ID（如果不需要门票则返回0）
-- @return ConsumeTicketCount 需要的门票数量（如果不需要门票则返回0）
-- @return CurrentTicketCount Avatar当前拥有的门票数量（如果不需要门票则返回0）
function GuildWarUtils.GetDungeonTicketInfo(DungeonId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return 0, 0, 0
    end
    
    local RaidDungeonConfig = DataMgr.RaidDungeon[DungeonId]
    if not RaidDungeonConfig then
        return 0, 0, 0
    end
    
    -- 预选赛不需要门票
    local isPreRaid = RaidDungeonConfig.RaidDungeonType == 1
    if isPreRaid then
        return 0, 0, 0
    end
    
    -- 从配置中获取门票信息
    local TicketNumData = RaidDungeonConfig.TicketNum
    if not TicketNumData then
        return 0, 0, 0
    end
    
    local ResId = 0
    local ConsumeTicketCount = 0
    for key, value in pairs(TicketNumData) do
        ResId = key
        ConsumeTicketCount = value
        break -- TicketNum 通常只有一个键值对
    end
    
    if ResId > 0 then
        local CurrentTicketCount = Avatar.Resources[ResId] and Avatar.Resources[ResId].Count or 0
        return ResId, ConsumeTicketCount, CurrentTicketCount
    end
    
    return 0, 0, 0
end

-- 判断当前是否能进入副本
-- @param DungeonId 副本ID
-- @param EventId 事件ID
function GuildWarUtils.EnterEventDungeon(DungeonId, EventId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    -- 先判断是正式赛还是预选赛
    local RaidDungeonConfig = DataMgr.RaidDungeon[DungeonId]
    if not RaidDungeonConfig then
        return false
    end
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local isPreRaid = RaidDungeonConfig.RaidDungeonType == 1
    if isPreRaid then
        if not GuildWarUtils.IsPreRaidTime() then
            UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("RaidDungeon_PreRaid_End"))
            return false
        end
    else
        if not GuildWarUtils.IsOfficalRaidTime() then
            UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("RaidDungeon_PreRaid_End"))
            return false
        end
    end
    -- 正式赛检查门票
    if not isPreRaid then
        local ResId, ConsumeTicketCount, CurrentTicketCount = GuildWarUtils.GetDungeonTicketInfo(DungeonId)
        if ResId > 0 and CurrentTicketCount < ConsumeTicketCount then
            local Resource = DataMgr.Resource[ResId]
            if Resource then
                UIManager:ShowUITip(UIConst.Tip_CommonToast, string.format(GText("RaidDungeon_NoTicket_Toast"), GText(Resource.ResourceName)))
            else
                UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("RaidDungeon_NoTicket_Toast"))
            end
            return false
        end
    end
    Avatar:EnterDungeonAgain()
    return true
end

-- 空表判断
function GuildWarUtils.IsEmptyTable(tbl)
    if type(tbl) ~= "table" then
        return true
    end

    for _ in pairs(tbl) do
        return false
    end
    return true
end

-- 工会战对应的商店SubTabId
function GuildWarUtils.GetShopSubTabId(ShopKey)
    local SubTabId
    for _, ShopData in pairs(DataMgr.ShopItem2ShopSubId.Resource[ShopKey] or {}) do
        local ShopIDData = ShopData[1]
        if ShopIDData then
            SubTabId = ShopIDData.SubTabId  -- 100041
        end
        break
    end
    return SubTabId
end

-- 工会战所需货币的Id
function GuildWarUtils.GetCoinId(ShopKey)
    local SubTabId = GuildWarUtils.GetShopSubTabId(ShopKey)
    if not SubTabId then
        return
    end
    local CoinId = DataMgr.ShopTabSub[SubTabId].TabCoin[1]  -- 218
    return CoinId
end

-- 刷新商店红点
function GuildWarUtils.HasShopReddot()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local RaidSeasons = Avatar.RaidSeasons[Avatar.CurrentRaidSeasonId]
    if not RaidSeasons then
        return
    end

    local SeasonEventId = RaidSeasons.EventId
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(GuildWarUtils.ReddotNodeKey)
    if not CacheDetail[SeasonEventId] then
        return
    end

    local ShowReddot = false
    pcall(function()
        local CoinId = GuildWarUtils.GetCoinId(RaidSeasons.Shop)
        -- 拿到货币数量
        local CoinNum = Avatar:GetResourceNum(CoinId) or 0
        CoinNum = tonumber(CoinNum) or 0
        -- 拿到积分
        local MaxRaidScore = (GuildWarUtils.IsPreRaidTime()) and RaidSeasons.MaxPreRaidScore or RaidSeasons.MaxRaidScore
        MaxRaidScore = tonumber(MaxRaidScore) or 0
        -- 获取SubTabId用于遍历商品
        local SubTabId = GuildWarUtils.GetShopSubTabId(RaidSeasons.Shop)
        -- 遍历一下，看是否有玩家可以买的工会战商品
        for ShopItemId, ShopData in pairs(DataMgr.ShopItem) do
            -- 是否属于当前Tab & 可显示
            if (ShopData.SubTabId == SubTabId and ShopUtils:GetShopItemCanShow(ShopItemId)) then
                -- 是否超出购买限制
                local PurchaseLimit = ShopUtils:GetShopItemPurchaseLimit(ShopData.ItemId)
                if (PurchaseLimit ~= 0 and not Avatar:CheckShopItemUnique(ShopData.ItemId)) then
                    -- 玩家是否满足 商品的价格 和 购买积分
                    local UnLockRaidPoint = tonumber(ShopData.UnlockRaidPoint) or 0
                    local Price = tonumber(ShopData.Price) or 0
                    if (CoinNum >= Price) and (MaxRaidScore >= UnLockRaidPoint) then
                        ShowReddot = true
                        break
                    end
                end
            end
        end
    end)

    return ShowReddot
end

-- 刷新工会战活动任务红点
function GuildWarUtils.RefreshQuestReddot(ClearCache)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local RaidSeasons = Avatar.RaidSeasons[Avatar.CurrentRaidSeasonId]
    if not RaidSeasons then
        return
    end

    local SeasonEventId = RaidSeasons.EventId
    local CommonQuestActivity = Avatar.CommonQuestActivity[SeasonEventId]
    if not CommonQuestActivity then
        return
    end

    pcall(function()
        local Node = ReddotManager.GetTreeNode(GuildWarUtils.ReddotRewardKey)
        if not Node then
            ReddotManager.AddNodeEx(GuildWarUtils.ReddotRewardKey)
        end
        if ClearCache then
            ReddotManager.ClearLeafNodeCount(GuildWarUtils.ReddotRewardKey)    
            local NodeCache = ReddotManager._GetLeafNodeCache(GuildWarUtils.ReddotRewardKey)
            NodeCache.Detail = {}
        end
        local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(GuildWarUtils.ReddotRewardKey)
        for QuestPhaseId, PhaseConfig in pairs(DataMgr.CommonQuestPhase) do
            if PhaseConfig.EventId == SeasonEventId then
                for QuestId, Config in pairs(DataMgr.CommonQuestDetail) do
                    if Config.QuestPhaseId == QuestPhaseId then  -- 增加红点计数
                        local QuestData = CommonQuestActivity[QuestId]
                        if (not QuestData) 
                        or (not QuestData.Progress) 
                        or (not QuestData.Target)then
                            goto continue
                        end
                        local CanReceive = (QuestData.Progress >= QuestData.Target)
                        if (CanReceive and not QuestData.RewardsGot) then
                            if not CacheDetail[QuestPhaseId] then
                                CacheDetail[QuestPhaseId] = {}
                            end
                            if not CacheDetail[QuestPhaseId][QuestId] then
                                ReddotManager.IncreaseLeafNodeCount(GuildWarUtils.ReddotRewardKey)
                                CacheDetail[QuestPhaseId][QuestId] = 1
                            end
                        -- elseif QuestData.RewardsGot and ClearCache then  -- 减少红点计数
                        --     if CacheDetail[QuestPhaseId]
                        --     and CacheDetail[QuestPhaseId][RewardId] then
                        --         CacheDetail[QuestPhaseId][RewardId] = nil
                        --      end
                        end
                    end
                    ::continue::
                end
            end
        end
    end)
end

-- 工会战入口红点
function GuildWarUtils.RefreshEntranceReddot()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local RaidSeasons = Avatar.RaidSeasons[Avatar.CurrentRaidSeasonId]
    if not RaidSeasons then
        return
    end

    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(GuildWarUtils.ReddotNodeKey)
    if not CacheDetail then
        return
    end
    pcall(function()
        local ShowReddot = false
        if GuildWarUtils.IsPreRaidTime() then  -- 预选赛阶段：积分为0 & 预选赛未封禁
            ShowReddot = (RaidSeasons.MaxPreRaidScore == 0) and (RaidSeasons.BanState ~= 1)
        elseif GuildWarUtils.IsOfficalRaidTime() then  -- 正式赛阶段：积分为0 & 两个都未被封禁
            ShowReddot = (RaidSeasons.MaxRaidScore == 0) and (RaidSeasons.BanState == 0)
        end

        local SeasonEventId = RaidSeasons.EventId
        if ShowReddot then
            if(CacheDetail[SeasonEventId][GuildWarUtils.EntranceCacheKey] == nil)then
                CacheDetail[SeasonEventId][GuildWarUtils.EntranceCacheKey] = 1
                ReddotManager.IncreaseLeafNodeCount(GuildWarUtils.ReddotNodeKey)
            end
        elseif CacheDetail[SeasonEventId][GuildWarUtils.EntranceCacheKey] then
            ReddotManager.DecreaseLeafNodeCount(GuildWarUtils.ReddotNodeKey)
            CacheDetail[SeasonEventId][GuildWarUtils.EntranceCacheKey] = nil
        end
    end)
end

-- 公会战正式赛领奖红点
function GuildWarUtils.RefreshRewardGotReddot()
    -- 预选赛阶段不需要判断
    if GuildWarUtils.IsPreRaidTime() then
        return
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local RaidSeasons = Avatar.RaidSeasons[Avatar.CurrentRaidSeasonId]
    if not RaidSeasons then
        return
    end

    local SeasonEventId = RaidSeasons.EventId
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(GuildWarUtils.ReddotNodeKey)
    if not CacheDetail[SeasonEventId] then
        return
    end

    pcall(function()
        -- 参加了预选赛 & 预选赛奖励没领取
        local ShowReddot = (RaidSeasons.PreRaidGroupId > 0)  and (not RaidSeasons:IsPreRaidRewardGot())

        if ShowReddot then
            if(CacheDetail[SeasonEventId][GuildWarUtils.RewardGotCacheKey] == nil)then
                CacheDetail[SeasonEventId][GuildWarUtils.RewardGotCacheKey] = 1
                ReddotManager.IncreaseLeafNodeCount(GuildWarUtils.ReddotNodeKey)
            end
        elseif CacheDetail[SeasonEventId][GuildWarUtils.RewardGotCacheKey] then
            ReddotManager.DecreaseLeafNodeCount(GuildWarUtils.ReddotNodeKey)
            CacheDetail[SeasonEventId][GuildWarUtils.RewardGotCacheKey] = nil
        end
    end)
end

return GuildWarUtils