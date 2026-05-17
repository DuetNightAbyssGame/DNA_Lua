local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

local Component = {}

local WuyoushengLevelReddotName = "WuyoushengLevel"
local WuyoushengId = {110001}


function Component:EnterWorld()
    EventManager:AddEvent(EventID.OnLoginSuccess, self, self.RefreshWuyoushengReddot)
    EventManager:AddEvent(EventID.RefreshWuyoushengLevelReddot, self, self.RefreshWuyoushengReddot)
end

function Component:LeaveWorld()
    EventManager:RemoveEvent(EventID.OnLoginSuccess, self)
    EventManager:RemoveEvent(EventID.RefreshWuyoushengLevelReddot, self)
end

function Component:RefreshWuyoushengReddot()
    self:RefreshWuyoushengNewLevelReddot()
    self:RefreshWuyoushengRewardReddot()
end

function Component:WuyoushengGetReward(EventId, RewardKeyId, CallBack)
	self.logger.info("WuyoushengGetReward", EventId, RewardKeyId)
    local function Cb(ErrCode, Ret)
        if CallBack then
            CallBack(ErrCode, Ret)
        end
        DebugPrint("WuyoushengGetReward",ErrorCode:Name(ErrCode))
    end
	self:CallServer("WuyoushengGetReward", Cb, EventId, RewardKeyId) 
end

function Component:WuyoushengGetAllReward(EventId, CallBack)
	self.logger.info("WuyoushengGetAllReward", EventId)
    local function Cb(ErrCode, Ret)
        if CallBack then
            CallBack(ErrCode, Ret)
        end
        DebugPrint("WuyoushengGetAllReward",ErrorCode:Name(ErrCode))
    end
	self:CallServer("WuyoushengGetAllReward", Cb, EventId) 
end

function Component:WuyoushengSetSquad(EventId, DungeonId, Squad, CallBack)
	self.logger.info("WuyoushengSetSquad", EventId, DungeonId, Squad)
    local function Cb(ErrCode, Ret)
        if CallBack then
            CallBack(ErrCode, Ret)
        end
        DebugPrint("WuyoushengSetSquad",ErrorCode:Name(ErrCode))
    end
	self:CallServer("WuyoushengSetSquad", Cb, EventId, DungeonId, Squad) 
end

function Component:RefreshWuyoushengNewLevelReddot()
    local ReddotNode = ReddotManager.GetTreeNode(WuyoushengLevelReddotName)
    if not ReddotNode then
        ReddotNode = ReddotManager.AddNodeEx(WuyoushengLevelReddotName)
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(WuyoushengLevelReddotName)
    if not CacheDetail then
        return
    end
    
    -- 清除所有已存在的红点记录
    for DungeonId, _ in pairs(DataMgr.WuyoushengEventLevel or {}) do
        if CacheDetail[DungeonId] == true then
            CacheDetail[DungeonId] = nil
        end
    end
    ReddotManager.ClearLeafNodeCount(WuyoushengLevelReddotName)
    
    -- 重新计算并添加红点
    for _, EventId in ipairs(WuyoushengId) do
        self:_TryAddWuyoushengNewLevelReddot(EventId)
    end
end

function Component:_TryAddWuyoushengNewLevelReddot(EventId)
    local ReddotNode = ReddotManager.GetTreeNode(WuyoushengLevelReddotName)
    if not ReddotNode then
        ReddotNode = ReddotManager.AddNodeEx(WuyoushengLevelReddotName)
    end
    
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(WuyoushengLevelReddotName)
    if not CacheDetail then
        return
    end
    
    -- 检查EventId是否变化，如果变化则清除所有红点
    if CacheDetail.EventId ~= EventId then
        ReddotManager.ClearLeafNodeCount(WuyoushengLevelReddotName, true)
        CacheDetail = ReddotManager.GetLeafNodeCacheDetail(WuyoushengLevelReddotName)
    end
    
    CacheDetail.EventId = EventId
    
    local WuyoushengEventLevelData = DataMgr.WuyoushengEventLevel
    if not WuyoushengEventLevelData then
        return
    end

    -- 判断一下活动是否未解锁
    local PageConfigData = DataMgr.EventPortal[EventId]
    if PageConfigData and ActivityUtils.CheckIsActivityLock(PageConfigData) then
        return
    end

    if not ActivityUtils.CheckEventIsOpen(EventId, nil, false, nil) then
        ReddotManager.ClearLeafNodeCount(WuyoushengLevelReddotName, true)
        return
    end

    local CurrentTime = TimeUtils.NowTime()
    local IncreaseNum = 0
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    
    local WuyoushengData = Avatar.WuyoushengActivity and Avatar.WuyoushengActivity[EventId]
    
    for DungeonId, LevelCfg in pairs(WuyoushengEventLevelData) do
        -- 如果已经有记录（已点击过），跳过
        if CacheDetail[DungeonId] == false then
            goto continue
        end
        
        -- 检查解锁时间
        local UnlockDate = LevelCfg.UnlockDate
        UnlockDate = UnlockDate:GetTime()
        if UnlockDate and CurrentTime < UnlockDate then
            -- 未到解锁时间，跳过
            goto continue
        end
        
        -- 检查前置关卡
        local PerviousDungeon = LevelCfg.PerviousDungeon
        if PerviousDungeon then
            -- 有前置关卡，检查前置关卡是否完成
            local FinishStars = 0
            if WuyoushengData then
                FinishStars = WuyoushengData:GetFinishStars(PerviousDungeon) or 0
            end
            
            if FinishStars == 0 then
                -- 前置关卡未完成，跳过
                goto continue
            end
        end
        
        -- 关卡已解锁，且未点击过，添加红点
        if CacheDetail[DungeonId] == nil then
            CacheDetail[DungeonId] = true
            IncreaseNum = IncreaseNum + 1
        end
        
        ::continue::
    end
    
    if IncreaseNum > 0 then
        ReddotManager.IncreaseLeafNodeCount(WuyoushengLevelReddotName, IncreaseNum)
    end
end

function Component:RefreshWuyoushengRewardReddot()
    local ReddotNode = ReddotManager.GetTreeNode("WuyoushengReward")
    if not ReddotNode then
        ReddotNode = ReddotManager.AddNodeEx("WuyoushengReward")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("WuyoushengReward")
    if not CacheDetail then
        return
    end
    
    -- 清除所有已存在的红点记录
    local WuyoushengTaskData = DataMgr["WuyoushengEventReward"]
    if WuyoushengTaskData then
        for RewardKeyId, _ in pairs(WuyoushengTaskData) do
            if CacheDetail[RewardKeyId] == true then
                CacheDetail[RewardKeyId] = nil
            end
        end
    end
    ReddotManager.ClearLeafNodeCount("WuyoushengReward")
    
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    if not ActivityUtils.CheckEventIsOpen(WuyoushengId[1], nil, false, nil) then
        return
    end
    
    -- 遍历所有无由生活动ID，检查奖励
    for _, EventId in ipairs(WuyoushengId) do
        self:_TryAddWuyoushengRewardReddot(EventId)
    end
end

function Component:_TryAddWuyoushengRewardReddot(EventId)
    local ReddotNode = ReddotManager.GetTreeNode("WuyoushengReward")
    if not ReddotNode then
        ReddotNode = ReddotManager.AddNodeEx("WuyoushengReward")
    end
    
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("WuyoushengReward")
    if not CacheDetail then
        return
    end
    
    -- 如果是永久活动，清除该 EventId 相关的红点
    if ActivityUtils.CheckIsPermanentEvent(EventId) then
        local WuyoushengTaskData = DataMgr["WuyoushengEventReward"]
        if WuyoushengTaskData then
            local DecreaseCount = 0
            for RewardKeyId, TaskInfo in pairs(WuyoushengTaskData) do
                if TaskInfo.EventId == EventId and CacheDetail[RewardKeyId] == true then
                    CacheDetail[RewardKeyId] = false
                    DecreaseCount = DecreaseCount + 1
                end
            end
            if DecreaseCount > 0 then
                ReddotManager.DecreaseLeafNodeCount("WuyoushengReward", DecreaseCount)
            end
        end
        return
    end
    
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    
    local WuyoushengData = Avatar.WuyoushengActivity and Avatar.WuyoushengActivity[EventId]
    if not WuyoushengData then
        return
    end
    
    local WuyoushengTaskData = DataMgr["WuyoushengEventReward"]
    if not WuyoushengTaskData then
        return
    end
    
    local IncreaseNum = 0
    
    -- 遍历任务数据，检查是否有可以领取的奖励
    for RewardKeyId, TaskInfo in pairs(WuyoushengTaskData) do
        if TaskInfo.EventId == EventId then
            local CanReceive = WuyoushengData:IsCompleted(RewardKeyId, TaskInfo.RequiredStar) and not WuyoushengData:IsRewarded(RewardKeyId)
            if CanReceive then
                CacheDetail[RewardKeyId] = true
                IncreaseNum = IncreaseNum + 1
            else
                CacheDetail[RewardKeyId] = false
            end
        end
    end
    
    if IncreaseNum > 0 then
        ReddotManager.IncreaseLeafNodeCount("WuyoushengReward", IncreaseNum)
    end
end

return Component