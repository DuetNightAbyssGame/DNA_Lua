require "UnLua"
local EMCache = require "EMCache.EMCache"
local SoloTreasureDataModel = {}
-- ========= 读表函数 =========
-- 活动剧情关卡数据
function SoloTreasureDataModel:GetStoryLevelDataByEventId(EventId)
    if not EventId then
        DebugPrint(ErrorTag, "------------[GetStoryLevelDataByEventId]EventId is nil------------")
        return
    end
    local EventTbl = DataMgr.TreasureHuntEvent
    local Result = {}
    if EventTbl then
        local EventStoryDungeonIdList = EventTbl[EventId].EventStoryDungeon
        if EventStoryDungeonIdList then
            for _, EventStoryDungeonId in ipairs(EventStoryDungeonIdList) do
                local EventStoryData = DataMgr.TreasureHuntStoryDungeon[EventStoryDungeonId]
                if EventStoryData then
                    table.insert(Result, EventStoryData)
                end
            end
        else
            DebugPrint("----------- [SoloTreasureDataModel] EventStoryDungeonIdList table is nil-----------")
        end
    else
        DebugPrint("----------- [SoloTreasureDataModel] TreasureHuntEvent table is nil-----------")
    end
    return Result
end

-- 复刷关卡数据
function SoloTreasureDataModel:GetRepeatLevelDataByEventId(EventId)
    if not EventId then
        DebugPrint(ErrorTag, "------------ [SoloTreasureDataModel] EventId is nil ------------")
        return
    end
    local EventTbl = DataMgr.TreasureHuntEvent
    local Result = {}
    if EventTbl then
        local EventRepeatDungeonIdList = EventTbl[EventId].EventRepeatDungeon
        if EventRepeatDungeonIdList then
            for _, EventRepeatDungeonId in ipairs(EventRepeatDungeonIdList) do
                local EventRepeatData = DataMgr.TreasureHuntRepeatDungeon[EventRepeatDungeonId]
                if EventRepeatData then
                    table.insert(Result, EventRepeatData)
                end
            end
        else
            DebugPrint("----------- [SoloTreasureDataModel] EventRepeatDungeonIdList table is nil -----------")
        end
    else
        DebugPrint("----------- [SoloTreasureDataModel] TreasureHuntEvent table is nil -----------")
    end
    return Result
end

-- 获取进度数据表数据
function SoloTreasureDataModel:GetTreasureHuntProgressData(EventId)
    if not EventId then
        DebugPrint(ErrorTag, "------------ [SoloTreasureDataModel] EventId is nil ------------")
        return
    end
    local EventTbl = DataMgr.TreasureHuntEvent
    local Result = {}
    if EventTbl then
        local EventProgressIdList = EventTbl[EventId].EventProgress
        if EventProgressIdList then
            for _, EventProgressId in ipairs(EventProgressIdList) do
                local EventProgressData = DataMgr.TreasureHuntProgress[EventProgressId]
                if EventProgressData then
                    table.insert(Result, EventProgressData)
                end
            end
        else
            DebugPrint(ErrorTag, "----------- [SoloTreasureDataModel] EventProgressIdList table is nil -----------")
        end
    else
        DebugPrint(ErrorTag, "----------- [SoloTreasureDataModel] TreasureHuntEvent table is nil -----------")
    end
    return Result
end

-- 获取撤离时间
function SoloTreasureDataModel:GetDungeonGameTotalTime(DungeonId)
    local SoloTreasureTbl = DataMgr.SoloTreasure
    if not SoloTreasureTbl or not DungeonId then
        return nil
    end

    local row = SoloTreasureTbl[DungeonId]
    if row then
        return row.GameTotalTime
    end

    DebugPrint(ErrorTag, "----------- [SoloTreasureDataModel] 未找到 DungeonId = " .. DungeonId .. " 对应行 -----------")
    return nil
end

-- 获取搜打撤活动Id
function SoloTreasureDataModel:GetEventId()
    local EventId = 103014 -- TODO: 是不是写死？CommonConst里面拿？
    return EventId
end

-- 获取玩家当前分数
function SoloTreasureDataModel:GetUserCurrentScore(EventId)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        self.Avatar = Avatar
    end
    local TreasureHunt = Avatar.TreasureHunts[EventId]
    local Score = 0
    if TreasureHunt then
        local Score = TreasureHunt:GetScore()
        return Score
    else
        DebugPrint(ErrorTag, "---------- [SoloTreasureDataModel]  请求TreasureHunt数据失败 -----------")
        return 0
    end
end

-- 获得转常驻时间
function SoloTreasureDataModel:GetPermanentEventTime(EventId)
    local PermanenEventTime = nil
    if EventId and DataMgr.EventMain[EventId] and DataMgr.EventMain[EventId].PermanenEventTime then
        PermanenEventTime = DataMgr.EventMain[EventId].PermanenEventTime:GetTime()
    end
    if PermanenEventTime then
        return PermanenEventTime
    end
    DebugPrint(ErrorTag, "---------- [SoloTreasureDataModel] 获取PermanenEventTime数据失败 -----------")
    return nil
end

-- 判断时间是否到了转常驻
function SoloTreasureDataModel:IsEventPermanent(EventId)
    local PermanenEventTime = self:GetPermanentEventTime(EventId)
    if not PermanenEventTime then
        return false
    end

    local Now = TimeUtils.NowTime()
    return Now >= PermanenEventTime
end

-- 获得活动结束时间
function SoloTreasureDataModel:GetEventEndTime(EventId)
    local EventEndTime = nil
    if EventId and DataMgr.EventMain[EventId] and DataMgr.EventMain[EventId].EventEndTime then
        EventEndTime = DataMgr.EventMain[EventId].EventEndTime:GetTime()
    end
    if EventEndTime then
        return EventEndTime
    end
    DebugPrint(ErrorTag, "---------- [SoloTreasureDataModel] 获取EventEndTime数据失败 -----------")
    return nil
end

-- 判断活动是否已经上线
-- function SoloTreasureDataModel:ActivityIsOpen(EventId)
--     local EventCfg = EventId and DataMgr.EventMain and DataMgr.EventMain[EventId]
--     if not EventCfg then
--         return false
--     end

--     -- 1. 时间判断
--     local EventStartTime = EventCfg.EventStartTime and EventCfg.EventStartTime.GetTime()
--     if EventStartTime and TimeUtils.NowTime() < EventStartTime then
--         return false
--     end

--     -- 2. 条件判断（nil 默认通过）
--     local EventUnlockCondition = EventCfg.EventUnlockCondition
--     if EventUnlockCondition and ConditionUtils and ConditionUtils.CheckCondition then
--         if not ConditionUtils.CheckCondition(self.Avatar, EventUnlockCondition) then
--             return false
--         end
--     end

--     return true
-- end

-- 判断活动是否已经解锁
function SoloTreasureDataModel:ActivityIsUnlock(EventId)
    local EventCfg = EventId and DataMgr.EventPortal and DataMgr.EventPortal[EventId]
    if not EventCfg then
        return false
    end

    local JumpUnlockCondition = EventCfg.JumpUnlockCondition
    if JumpUnlockCondition and ConditionUtils and ConditionUtils.CheckCondition then
        if not ConditionUtils.CheckCondition(self.Avatar, JumpUnlockCondition) then
            return false
        end
    end

    return true
end

-- 获取当前货币数量
function SoloTreasureDataModel:GetCurCoinAmount(CoinId)
    local CoinNum =
        (self.Avatar and self.Avatar.Resources and self.Avatar.Resources[CoinId] and self.Avatar.Resources[CoinId].Count) or
        0
    return CoinNum
end

-- 获取玩家所处阶段
function SoloTreasureDataModel:GetUserCurrentProgress(UserCurScore, TreasureHuntProgressData)
    local Result = {
        CurStageIndex = 1,
        TotalStageCount = 0,
        CurRow = nil,
        UserCurProgressId = nil,
        BoardState = 1,
        -- 数值信息（UI展示用）
        NextNeedScore = 0,
        CurScore = tonumber(UserCurScore) or 0,
        -- 条件信息（UI展示/Debug用）
        ProgressCondition = 0,
        IsConditionPassed = false
    }

    if not UserCurScore or not TreasureHuntProgressData or #TreasureHuntProgressData == 0 then
        return
    end

    Result.TotalStageCount = #TreasureHuntProgressData

    -- ========= 1) 先用“积分门槛”定位“理论可到达的阶段” =========
    -- 规则：找到第一个 UserCurScore < NextProgressScore 的阶段；否则落在最后阶段
    local ScoreStageIndex = Result.TotalStageCount
    for Index, Row in ipairs(TreasureHuntProgressData) do
        local NextScore = tonumber(Row.NextProgressScore) or 0
        if Result.CurScore < NextScore then
            ScoreStageIndex = Index
            break
        end
    end

    -- ========= 2) 再用“条件”约束真实阶段（从1开始，连续通过才推进） =========
    -- 规则：阶段i要成立，必须 CheckCondition(row.ProgressCondition) 为 true
    -- 一旦某段条件不通过，就停在前一段（至少为1）
    local CondStageIndex = 1
    for Index, Row in ipairs(TreasureHuntProgressData) do
        local CondId = tonumber(Row.ProgressCondition) or 0

        -- CondId=0/空：按“未配置条件”处理（不推进）
        if CondId == 0 or not ConditionUtils.CheckCondition(self.Avatar, CondId) then
            break
        end
        CondStageIndex = Index
    end

    -- ========= 3) 真实阶段 = min(积分可达阶段, 条件可达阶段+1?) =========
    -- 积分只是“进入下一阶段的门槛提示”，真正进入靠条件完成。
    -- “当前阶段”以条件为锚：玩家处于 CondStageIndex 阶段。
    -- 为了避免“条件推进 > 积分阶段”的怪情况，取 min。
    local CurStageIndex = CondStageIndex
    if CurStageIndex > ScoreStageIndex then
        CurStageIndex = ScoreStageIndex
    end

    Result.CurStageIndex = CurStageIndex
    Result.CurRow = TreasureHuntProgressData[CurStageIndex]
    Result.UserCurProgressId = Result.CurRow and Result.CurRow.EventProgressId or nil

    -- 当前阶段“进入下一阶段所需积分”
    Result.NextNeedScore = tonumber(Result.CurRow and Result.CurRow.NextProgressScore) or 0

    -- 当前阶段条件信息
    Result.ProgressCondition = tonumber(Result.CurRow and Result.CurRow.ProgressCondition) or 0
    Result.IsConditionPassed =
        (Result.ProgressCondition ~= 0) and
        (ConditionUtils and ConditionUtils.CheckCondition and
            ConditionUtils.CheckCondition(self.Avatar, Result.ProgressCondition) or
            false) or
        false

    -- ========= 4) 计算 BoardState =========
    -- 1 = 积分未达标（还在刷分）
    -- 2 = 积分已达标，但进入条件未完成（等剧情/NPC）
    -- 3 = 已进入最终赛程（最后阶段进行中）
    -- 4 = 全部赛程完成（活动结束）
    local IsLastStage = (Result.CurStageIndex >= Result.TotalStageCount)

    if IsLastStage then
        local FinishCondId = DataMgr.GlobalConstant["SoloTreasureAllFinish"].ConstantValue
        local IsAllFinished =
            ConditionUtils and ConditionUtils.CheckCondition and
            ConditionUtils.CheckCondition(self.Avatar, FinishCondId) or
            false

        Result.BoardState = IsAllFinished and 4 or 3
    else
        -- 是否达到“进入下一阶段”的积分门槛
        local ScoreEnoughForNext = (Result.CurScore >= Result.NextNeedScore)

        if not ScoreEnoughForNext then
            Result.BoardState = 1
        else
            -- 分够了，但是否能进下一阶段取决于“下一阶段的条件”是否达成
            local NextRow = TreasureHuntProgressData[Result.CurStageIndex + 1]
            local NextCondId = tonumber(NextRow and NextRow.ProgressCondition) or 0
            local NextCondPass =
                (NextCondId ~= 0) and
                (ConditionUtils and ConditionUtils.CheckCondition and
                    ConditionUtils.CheckCondition(self.Avatar, NextCondId) or
                    false) or
                false
            Result.BoardState = NextCondPass and 1 or 2
        end
    end
    return Result
end

-- 判断某个复刷关卡是否解锁
function SoloTreasureDataModel:IsRepeatLevelUnlocked(Row)
    if not Row then
        return false
    end

    -- 1) 时间锁
    if Row.UnlockDate and TimeUtils.NowTime() < Row.UnlockDate then
        return false
    end

    -- 2) 条件锁
    if Row.UnlockCondition then
        local Ok =
            (ConditionUtils and ConditionUtils.CheckCondition) and
            ConditionUtils.CheckCondition(self.Avatar, Row.UnlockCondition) or
            false

        if not Ok then
            return false
        end
    end

    return true
end

-- =============================
-- =========== 红点 ============
-- =============================

-- SoloTreasure_LevelListView 的 Cache.Detail
-- Detail = {
--   [EventId] = {
--     [LevelIndex] = true/false,   -- true 表示已读（New 消除）
--   }
-- }

function SoloTreasureDataModel:Init()
    local EventId = self:GetEventId()
    if not EventId then
        return
    end
    self:BindLevelUnlockReddotRefresh()
    -- 活动是否开启
    local bIsOpen = SoloTreasureDataModel:ActivityIsUnlock(EventId)
    if not bIsOpen then
        return
    end
    self:InitReddotTree()

    self:RefreshAllSoloTreasureNewReddot(EventId) -- TODO: 是不是要移到活动打开的时候 而不是登录的时候？
end

function SoloTreasureDataModel:InitReddotTree()
    if self.bReddotTreeInited then
        return
    end
    self.bReddotTreeInited = true

    -- 初始化红点树结构
    ReddotManager.AddNodeEx("Acti_SoloTreasureTab")
end

function SoloTreasureDataModel:GetLevelListDetail(EventId)
    local Detail = ReddotManager.GetLeafNodeCacheDetail("SoloTreasure_LevelListView")

    if not Detail then
        return nil
    end

    if not Detail[EventId] then
        Detail[EventId] = {}
    end

    return Detail[EventId]
end

-- 初始化每个子节点detail数据结构
function SoloTreasureDataModel:InitLevelEntryDetailIfNeeded(EventId, LevelCount)
    local EDetail = self:GetLevelListDetail(EventId)
    if not EDetail then
        return
    end

    for i = 1, LevelCount do
        if EDetail[i] == nil then
            -- nil 表示从未写过：默认未读（New 显示）
            EDetail[i] = false
        end
    end
end

-- =============================
-- ========== 刷新红点 ==========
-- =============================

function SoloTreasureDataModel:RefreshAllSoloTreasureNewReddot(EventId)
    self:RefreshShopNewReddot(EventId)
    self:RefreshLimitRewardNewReddot(EventId)
    self:RefreshPermanentRewardNewReddot(EventId)
    self:RefreshLevelListNewReddot(EventId)
end

function SoloTreasureDataModel:RefreshShopNewReddot(EventId)
    local Node = "SoloTreasure_Shop_New"

    local bUnlocked = true
    local bRead = self:IsShopEntryRead(EventId)

    ReddotManager.ClearLeafNodeCount(Node)
    if bUnlocked and (not bRead) then
        ReddotManager.IncreaseLeafNodeCount(Node, 1)
    end
end

function SoloTreasureDataModel:RefreshLimitRewardNewReddot(EventId)
    local Node = "SoloTreasure_LimitReward_New"
    local bUnlocked = not self:IsEventPermanent(EventId) -- 是否转了常驻
    local bRead = self:IsLimitRewardEntryRead(EventId)

    ReddotManager.ClearLeafNodeCount(Node) -- 不带 true
    if bUnlocked and (not bRead) then
        ReddotManager.IncreaseLeafNodeCount(Node, 1)
    end
end

function SoloTreasureDataModel:RefreshPermanentRewardNewReddot(EventId)
    local Node = "SoloTreasure_PermanentReward_New"
    local bUnlocked = true -- TODO: “活动未结束/常驻阶段”
    local bRead = self:IsPermanentRewardEntryRead(EventId)

    ReddotManager.ClearLeafNodeCount(Node)
    if bUnlocked and (not bRead) then
        ReddotManager.IncreaseLeafNodeCount(Node, 1)
    end
end

function SoloTreasureDataModel:RefreshLevelListNewReddot(EventId)
    local Levels = self:GetRepeatLevelDataByEventId(EventId) or {}
    local LevelCount = #Levels
    if LevelCount <= 0 then
        ReddotManager.ClearLeafNodeCount("SoloTreasure_LevelListView")
        return
    end

    self:InitLevelEntryDetailIfNeeded(EventId, LevelCount)

    local UnreadCount = 0
    for Idx = 1, LevelCount do
        -- 先不管解锁逻辑：默认都算 unlocked
        local Row = Levels[Idx]
        local bUnlocked = self:IsRepeatLevelUnlocked(Row) -- 判断是否解锁

        if bUnlocked then
            local bRead = self:IsLevelEntryRead(EventId, Idx) -- 判断是否已经读过
            if not bRead then
                UnreadCount = UnreadCount + 1
            end
        end
    end

    ReddotManager.ClearLeafNodeCount("SoloTreasure_LevelListView")
    ReddotManager.ClearLeafNodeCount("Acti_SolotreasureConfirmBtn") -- 同步按钮红点
    if UnreadCount > 0 then
        ReddotManager.IncreaseLeafNodeCount("SoloTreasure_LevelListView", UnreadCount)
        ReddotManager.IncreaseLeafNodeCount("Acti_SolotreasureConfirmBtn", UnreadCount)
    end
end

-- =============================
-- ===== 判断+设置 New 已读 =====
-- =============================

-- ===== 1) 判断+设置 商店 New 已读 =====
function SoloTreasureDataModel:IsShopEntryRead(EventId)
    local Detail = ReddotManager.GetLeafNodeCacheDetail("SoloTreasure_Shop_New")
    if not Detail then
        return false
    end
    return Detail[EventId] == true
end

function SoloTreasureDataModel:SetShopEntryRead(EventId, bRead)
    local Detail = ReddotManager.GetLeafNodeCacheDetail("SoloTreasure_Shop_New")
    if not Detail then
        return
    end
    Detail[EventId] = (bRead == true)
end

-- ===== 2) 判断+设置 限时 New 已读 =====
function SoloTreasureDataModel:IsLimitRewardEntryRead(EventId)
    local Detail = ReddotManager.GetLeafNodeCacheDetail("SoloTreasure_LimitReward_New")
    if not Detail then
        return false
    end
    return Detail[EventId] == true
end

function SoloTreasureDataModel:SetLimitRewardEntryRead(EventId, bRead)
    local Detail = ReddotManager.GetLeafNodeCacheDetail("SoloTreasure_LimitReward_New")
    if not Detail then
        return
    end
    Detail[EventId] = (bRead == true)
end

-- ===== 3) 判断+设置 常驻 New 已读 =====
function SoloTreasureDataModel:IsPermanentRewardEntryRead(EventId)
    local Detail = ReddotManager.GetLeafNodeCacheDetail("SoloTreasure_PermanentReward_New")
    if not Detail then
        return false
    end
    return Detail[EventId] == true
end

function SoloTreasureDataModel:SetPermanentRewardEntryRead(EventId, bRead)
    local Detail = ReddotManager.GetLeafNodeCacheDetail("SoloTreasure_PermanentReward_New")
    if not Detail then
        return
    end
    Detail[EventId] = (bRead == true)
end

-- ===== 4) 判断+设置 LevelEntry New 已读 =====
function SoloTreasureDataModel:IsLevelEntryRead(EventId, LevelIndex)
    local EDetail = self:GetLevelListDetail(EventId) -- EDetail = Detail[EventId]
    if not EDetail then
        return false
    end
    return EDetail[LevelIndex] == true -- Detail[EventId][LevelIndex]
end

function SoloTreasureDataModel:SetLevelEntryRead(EventId, LevelIndex, bRead)
    local EDetail = self:GetLevelListDetail(EventId)
    if not EDetail then
        return
    end
    EDetail[LevelIndex] = (bRead == true)
end

-- =============================
-- === 标记已读 + 清New-Count ===
-- =============================
-- 商店
function SoloTreasureDataModel:MarkShopEntryRead()
    local EventId = self:GetEventId()
    if not EventId then
        return
    end

    self:SetShopEntryRead(EventId, true)
    ReddotManager.ClearLeafNodeCount("SoloTreasure_Shop_New")
end

-- 限时奖励
function SoloTreasureDataModel:MarkLimitRewardEntryRead()
    local EventId = self:GetEventId()
    if not EventId then
        return
    end

    self:SetLimitRewardEntryRead(EventId, true)
    ReddotManager.ClearLeafNodeCount("SoloTreasure_LimitReward_New") -- 不要传 true
end

-- 常驻奖励
function SoloTreasureDataModel:MarkPermanentRewardEntryRead()
    local EventId = self:GetEventId()
    if not EventId then
        return
    end

    self:SetPermanentRewardEntryRead(EventId, true)
    ReddotManager.ClearLeafNodeCount("SoloTreasure_PermanentReward_New")
end

-- LevelItem
function SoloTreasureDataModel:MarkLevelEntryRead(LevelIndex)
    local EventId = self:GetEventId()
    if not EventId then
        return
    end

    self:SetLevelEntryRead(EventId, LevelIndex, true)
    self:RefreshLevelListNewReddot(EventId) -- 重算 Count，触发事件，UI 自动刷新
end

-- =============================
-- === LevelItem 红点条件监听 ===
-- =============================

-- 判断某个 ConditionId 是否属于当前活动的复刷关卡解锁条件
function SoloTreasureDataModel:IsRepeatLevelUnlockCondition(EventId, ConditionId)
    if not EventId or not ConditionId then
        return false
    end

    local Levels = self:GetRepeatLevelDataByEventId(EventId) or {}
    for _, Row in ipairs(Levels) do
        local UnlockCondition = tonumber(Row.UnlockCondition)
        if UnlockCondition and UnlockCondition > 0 and UnlockCondition == tonumber(ConditionId) then
            return true
        end
    end

    return false
end

-- 绑定“关卡解锁后刷新红点”的监听l
function SoloTreasureDataModel:BindLevelUnlockReddotRefresh()
    if self.bLevelUnlockReddotRefreshBinded then
        return
    end
    self.bLevelUnlockReddotRefreshBinded = true
    EventManager:AddEvent(EventID.ConditionComplete, self, self.RefreshLevelReddotWithConditionUnlock)
end

function SoloTreasureDataModel:RefreshLevelReddotWithConditionUnlock(ConditionId)
    local EventId = self:GetEventId()
    if not EventId then
        return
    end

    local bIsOpen = SoloTreasureDataModel:ActivityIsUnlock(EventId)
    if not bIsOpen then
        return
    end

    self:RefreshAllSoloTreasureNewReddot(EventId)
end

-- 解绑
function SoloTreasureDataModel:UnBindLevelUnlockReddotRefresh()
    if not self.bLevelUnlockReddotRefreshBinded then
        return
    end
    self.bLevelUnlockReddotRefreshBinded = false

    EventManager:RemoveEvent(EventID.ConditionComplete, self)
end

-- =============================
-- ========= Debug测试 =========
-- =============================
function SoloTreasureDataModel:SoloTreasureDataModelDebugReset(EventId)
    self:DebugResetLevelEntryRead(EventId)
    self:DebugResetUnlockAnimPlayed(EventId)
    self:DebugResetLastForbidden(EventId)
end

-- Debug：重置复刷关卡 New（把已读全部清回未读）
function SoloTreasureDataModel:DebugResetLevelEntryRead(EventId)
    EventId = EventId or self:GetEventId()
    if not EventId then
        return
    end

    local Detail = ReddotManager.GetLeafNodeCacheDetail("SoloTreasure_LevelListView")
    if not Detail then
        return
    end

    -- 直接清掉该活动的 detail（最干净）
    Detail[EventId] = {}

    -- 重算 Count，触发 UI 刷新
    self:RefreshLevelListNewReddot(EventId)
end

-- Debug：重置解锁动效已播放标记（EMCache）
function SoloTreasureDataModel:DebugResetUnlockAnimPlayed(EventId)
    EventId = EventId or self:GetEventId()
    if not EventId then
        return
    end

    local Levels = self:GetRepeatLevelDataByEventId(EventId) or {}
    for _, Row in ipairs(Levels) do
        local EventDungeonId = Row.EventDugeonId or Row.EventDungeonId
        if EventDungeonId then
            local Key = self:_GetUnlockAnimKey(EventId, EventDungeonId)
            EMCache:Remove(Key, true) -- 用户缓存
        end
    end

    DebugPrint("------ 已重置所有解锁动效播放标记 ------")
end

-- Debug：清除“上次锁定状态（LastForbidden）”记录（EMCache）
function SoloTreasureDataModel:DebugResetLastForbidden(EventId)
    EventId = EventId or self:GetEventId()
    if not EventId then
        return
    end

    local Levels = self:GetRepeatLevelDataByEventId(EventId) or {}
    for _, Row in ipairs(Levels) do
        local EventDungeonId = Row.EventDugeonId or Row.EventDungeonId
        if EventDungeonId then
            local Key = self:_GetLastForbiddenKey(EventId, EventDungeonId)
            EMCache:Remove(Key, true) -- true：用户缓存
        end
    end
    DebugPrint("------ 已清除 LastForbidden（Repeat Levels）------")
end

-- =============================
-- === 解锁动效记录 存本地缓存 ===
-- =============================

-- 机关鸟用的阶段快照（独立于进度板）
function SoloTreasureDataModel:_GetLastStageBirdKey(EventId)
    return string.format("SoloTreasure_LastStageBird_%s", tostring(EventId))
end

function SoloTreasureDataModel:SetLastStageBird(EventId, StageIndex)
    EMCache:Set(self:_GetLastStageBirdKey(EventId), tonumber(StageIndex) or 1, true)
end

function SoloTreasureDataModel:GetLastStageBirdEx(EventId)
    local V = EMCache:Get(self:_GetLastStageBirdKey(EventId), true)
    if V == nil then
        return 1, false
    end
    return tonumber(V) or 1, true
end

function SoloTreasureDataModel:_GetUnlockAnimKey(EventId, EventDungeonId)
    return string.format("SoloTreasure_UnlockAnimPlayed_%s_%s", tostring(EventId), tostring(EventDungeonId))
end

function SoloTreasureDataModel:IsUnlockAnimPlayed(EventId, EventDungeonId)
    local Key = self:_GetUnlockAnimKey(EventId, EventDungeonId)
    return EMCache:Get(Key, true) == true
end

function SoloTreasureDataModel:MarkUnlockAnimPlayed(EventId, EventDungeonId)
    local Key = self:_GetUnlockAnimKey(EventId, EventDungeonId)
    EMCache:Set(Key, true, true) -- 第三个参数true：用户缓存
end

-- === 解锁状态快照（上一次是否锁定）===
function SoloTreasureDataModel:_GetLastForbiddenKey(EventId, EventDungeonId)
    return string.format("SoloTreasure_LastForbidden_%s_%s", tostring(EventId), tostring(EventDungeonId))
end

-- 返回：WasForbidden, bHasHistory
function SoloTreasureDataModel:GetLastForbiddenEx(EventId, EventDungeonId)
    local Key = self:_GetLastForbiddenKey(EventId, EventDungeonId)
    local V = EMCache:Get(Key, true)
    if V == nil then
        return true, false -- 默认值随便给，关键是 bHasHistory=false 用来避免首次误播
    end
    return V == true, true
end

function SoloTreasureDataModel:SetLastForbidden(EventId, EventDungeonId, bForbidden)
    local Key = self:_GetLastForbiddenKey(EventId, EventDungeonId)
    EMCache:Set(Key, bForbidden == true, true)
end

-- =============================
-- === 积分 / 进度快照（用于进度board动效）===
-- =============================
function SoloTreasureDataModel:_GetLastScoreKey(EventId)
    return string.format("SoloTreasure_LastScore_%s", tostring(EventId))
end
function SoloTreasureDataModel:_GetLastStageKey(EventId)
    return string.format("SoloTreasure_LastStage_%s", tostring(EventId))
end

-- 积分
function SoloTreasureDataModel:GetLastScoreEx(EventId)
    local V = EMCache:Get(self:_GetLastScoreKey(EventId), true)
    if V == nil then
        return 0, false
    end
    return tonumber(V) or 0, true
end
function SoloTreasureDataModel:SetLastScore(EventId, Score)
    EMCache:Set(self:_GetLastScoreKey(EventId), tonumber(Score) or 0, true)
end

-- 阶段
function SoloTreasureDataModel:GetLastStageEx(EventId)
    local V = EMCache:Get(self:_GetLastStageKey(EventId), true)
    if V == nil then
        return 1, false
    end
    return tonumber(V) or 1, true
end
function SoloTreasureDataModel:SetLastStage(EventId, StageIndex)
    EMCache:Set(self:_GetLastStageKey(EventId), tonumber(StageIndex) or 1, true)
end

-- 进入界面时调用：生成 OldResult/NewResult + 动效判断
function SoloTreasureDataModel:GetBoardOldNewAndAnim(EventId, NewScore, TreasureHuntProgressData)
    local LastScore, bHasScore = self:GetLastScoreEx(EventId)

    -- Board旧阶段
    local LastStageBoard, bHasStageBoard = self:GetLastStageEx(EventId)
    -- Bird旧阶段
    local LastStageBird, bHasStageBird = self:GetLastStageBirdEx(EventId)

    local NewResult = self:GetUserCurrentProgress(NewScore, TreasureHuntProgressData)

    -- OldResult 仍然用 LastScore 推（给进度板“旧状态”用）
    local OldResult = self:GetUserCurrentProgress(LastScore, TreasureHuntProgressData)

    local bHasHistoryBoard = bHasScore and bHasStageBoard
    local bHasHistoryBird = bHasStageBird

    local ScoreDelta = (tonumber(NewScore) or 0) - (tonumber(LastScore) or 0)
    local bPlayScore = bHasHistoryBoard and (ScoreDelta > 0)

    local NewStage = tonumber(NewResult and NewResult.CurStageIndex) or 1
    local bPlayStageBoard = bHasHistoryBoard and (NewStage > (tonumber(LastStageBoard) or 1))
    local bPlayStageBird = bHasHistoryBird and (NewStage > (tonumber(LastStageBird) or 1))

    return OldResult, NewResult, {
        bPlayScore = bPlayScore,
        bPlayStageBoard = bPlayStageBoard,
        bPlayStageBird = bPlayStageBird,
        ScoreDelta = ScoreDelta,
        LastScore = LastScore,
        NewScore = tonumber(NewScore) or 0,
        LastStageBoard = tonumber(LastStageBoard) or 1,
        LastStageBird = tonumber(LastStageBird) or 1,
        NewStage = NewStage
    }
end

-- 提交快照
function SoloTreasureDataModel:CommitBoardSnapshotByResult(EventId, Result)
    if not Result then
        return
    end
    self:SetLastScore(EventId, tonumber(Result.CurScore) or 0)
    self:SetLastStage(EventId, tonumber(Result.CurStageIndex) or 1)
end

function SoloTreasureDataModel:CommitBirdSnapshotByResult(EventId, Result)
    if not Result then
        return
    end
    self:SetLastStageBird(EventId, tonumber(Result.CurStageIndex) or 1)
end

-- 登录/进游戏时存快照
function SoloTreasureDataModel:InitBoardSnapshotOnLogin()
    local EventId = self:GetEventId()
    local CurScore = self:GetUserCurrentScore(EventId)
    if CurScore == nil then
        return false
    end

    local _, bHasScore = self:GetLastScoreEx(EventId)
    local _, bHasStage = self:GetLastStageEx(EventId)
    local _, bHasBirdStage = self:GetLastStageBirdEx(EventId)

    -- 已经有历史，就不要覆盖（避免把“旧值”覆盖成新值）
    -- 确保 Bird 快照存在
    if bHasScore and bHasStage then
        if not bHasBirdStage then
            local ProgressData = self:GetTreasureHuntProgressData(EventId) or {}
            local Result = self:GetUserCurrentProgress(CurScore, ProgressData)
            local CurStage = tonumber(Result and Result.CurStageIndex) or 1
            self:SetLastStageBird(EventId, CurStage)
        end
        return true
    end

    -- Board 快照
    local ProgressData = self:GetTreasureHuntProgressData(EventId) or {}
    local Result = self:GetUserCurrentProgress(CurScore, ProgressData)
    local CurStage = tonumber(Result and Result.CurStageIndex) or 1

    self:SetLastScore(EventId, tonumber(CurScore) or 0)
    self:SetLastStage(EventId, CurStage)

    if not bHasBirdStage then
        self:SetLastStageBird(EventId, CurStage)
    end

    return true
end

return SoloTreasureDataModel
