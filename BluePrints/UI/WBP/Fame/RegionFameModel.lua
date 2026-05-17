
local M = Class("BluePrints.Common.MVC.Model")

local RefreshTimeType = {
    HOUR = 1,
    DAY = 2,
    WEEK = 3,
}

function M:Init()
    M.Super.Init(self)
    self._Avatar = nil
    self:GetAvatar()
end

function M:Destory()
    M.Super.Destory(self)
end

-- 获取当前区域声望等级
function M:GetRegionFameLevel(RegionId)
    local Avatar = self:GetAvatar()
    if not Avatar then
        return
    end
    if not Avatar.RegionReputations[RegionId] then
        return
    end
    return Avatar.RegionReputations[RegionId].ReputationLevel
end

-- 获取当前区域声望值
function M:GetRegionFameValue(RegionId)
    local Avatar = self:GetAvatar()
    if not Avatar then
        return
    end
    if not Avatar.RegionReputations[RegionId] then
        return
    end
    return Avatar.RegionReputations[RegionId].ReputationExp
end

-- 获取当前区域本周获取的声望值
function M:GetRegionWeeklyFame(RegionId)
    local Avatar = self:GetAvatar()
    if not Avatar then
        return
    end
    if not Avatar.RegionReputations[RegionId] then
        return
    end
    return Avatar.RegionReputations[RegionId].ReputationScore
end

-- 获取当前区域声望状态 是否满级 是否本周声望值已达上限 用于显示对应遮罩
function M:GetRegionState(RegionId, bRecurringTaskTab)
    local Avatar = self:GetAvatar()
    if not Avatar then
        return
    end
    if not Avatar.RegionReputations[RegionId] then
        return
    end

    local RegionReputationData = DataMgr.ReputationLevel[RegionId]
    if not RegionReputationData then
        return
    end
    local MaxLevel = RegionReputationData[#RegionReputationData].ReputationLevel
    local CurrentLevel = Avatar.RegionReputations[RegionId].ReputationLevel
    if CurrentLevel >= MaxLevel then
        return CommonConst.RegionFameState.MaxLevel
    end

    RegionReputationData = DataMgr.RegionReputation[RegionId]
    if not RegionReputationData then
        return
    end
    local WeekLimit = RegionReputationData.WeekLimit
    local CurrentWeekFame = Avatar.RegionReputations[RegionId].ReputationScore
    if CurrentWeekFame >= WeekLimit then
        return CommonConst.RegionFameState.WeeklyFameLimit
    end

    local DoingTaskRegionId = Avatar:GetCurrentDoingRecurringQuestId()
    -- 副本任务标签下，要求没有其他去区域进行中的循环任务时，才能显示正常状态
    if bRecurringTaskTab and DoingTaskRegionId and DoingTaskRegionId ~= RegionId then
        return CommonConst.RegionFameState.DoingOtherRegionFameTask
    end

    return CommonConst.RegionFameState.Normal
end

---检查是否解锁
---@param Condition
function M:CheckTabCondition(Condition)
    local Avatar = self:GetAvatar()
    if not Avatar then
        return false
    end
    if not Condition then
        return true
    end
    if ConditionUtils.CheckCondition(Avatar, Condition) == false then
        return false
    end
    return true
end

--region 委托任务
-- 获取委托任务刷新时间
function M:GetEntrustTaskRefreshTime(RegionId)
    local Avatar = self:GetAvatar()
    if not Avatar then
        return
    end
    if not Avatar.RegionReputations[RegionId] then
        return
    end
    local TargetRegionRefreshTime = Avatar.RegionReputations[RegionId].LastRefreshTime2
    if not TargetRegionRefreshTime then
        return
    end
    local Cache = DataMgr.RegionReputation
    local RefreshTime = 0
    for DictType, DictValue in pairs(Cache[RegionId].RefreshTime2) do
        if RefreshTimeType[DictType] == RefreshTimeType["HOUR"] then
            RefreshTime = RefreshTime + DictValue * 60 * 60
        elseif RefreshTimeType[DictType] == RefreshTimeType["DAY"] then
            RefreshTime = RefreshTime + DictValue * 60 * 60 * 24
        elseif RefreshTimeType[DictType] == RefreshTimeType["WEEK"] then
            RefreshTime = RefreshTime + DictValue * 60 * 60 * 24 * 7
        end
    end
    TargetRegionRefreshTime = TargetRegionRefreshTime + RefreshTime
    return TargetRegionRefreshTime
end

--- 获取当前区域所有委托任务列表（已排序）
--- 返回的任务列表按以下规则排序：
--- 1. 优先显示状态为0（待提交）的任务
--- 2. 可提交的任务优先于不可提交的
--- 3. 同等条件下按任务ID升序
---@param RegionId number 区域ID
---@return table 排序后的委托任务列表，每项包含: {TaskID: number, CanSubmit: boolean, TaskState: number, TaskInfo: table}
function M:GetEntrustTasks(RegionId)
    local Avatar = self:GetAvatar()
    if not Avatar then
        return
    end
    local Quests = Avatar:GetReputationEntrustQuest(RegionId)
    if not Quests then
        return
    end

    local AllEntrustTask = {}
    local Cache = DataMgr.ReputationEntrust
    for TaskId, TaskState in pairs(Quests) do
        local TabData = Cache[TaskId]
        if not TabData then
            break
        end
        local TaskReward = {
            RewardResourceID = TabData.Resource,
            RewardCount = TabData.ExpCount,
        }

        local TaskSubmissions = {}
        -- 最大所需提交物数量
        for i = 1, #TabData.Type do
            local Rarity = nil
            local Type = TabData.Type[i]
            local Id = TabData.Id[i]
            if DataMgr[Type] and DataMgr[Type][Id] then
                Rarity = DataMgr[Type][Id].Rarity
            end
            table.insert(TaskSubmissions, {
                Type = Type,
                Id = Id,
                Count = TabData.Count[i],
                Rarity = Rarity,
            })
        end
        local TaskInfo = {
            TaskID = TaskId,
            TaskRegionID = TabData.ReputationID,
            TaskState = TaskState,   -- 0 未完成 1 完成
            TaskNPCIcon = TabData.Icon,
            TaskTitle = TabData.EntrustTitle,
            TaskContent = TabData.EntrustContent,
            TaskReward = TaskReward,
            TaskSubmissions = TaskSubmissions,
            NPCName = TabData.NPCName,
        }
        table.insert(AllEntrustTask, TaskInfo)
    end

    local function SortByRarity(Data)
        local TmpSortData = {}
        for key, TaskInfo in pairs(Data) do
            local TaskSubmissions = TaskInfo.TaskSubmissions
            local CanSubmit = true
            for _, TaskSubmission in ipairs(TaskSubmissions) do
                -- 对应物资当前玩家拥有的数量
                local OwnerCount = 0
                -- 统一资源数量统计的接口
                if TaskSubmission.Type == "Mod" then
                    if Avatar then
                        OwnerCount = self:GetOriginalModCount(TaskSubmission.Id)
                    end
                elseif TaskSubmission.Type == "Resource" then
                    if Avatar then
                        OwnerCount = Avatar:GetResourceNum(TaskSubmission.Id)
                    end
                else
                    OwnerCount = 0
                end
                CanSubmit = CanSubmit and (OwnerCount >= TaskSubmission.Count)
                -- 若有一个数量不足则直接break
                if not CanSubmit then
                    break
                end
            end

            local Info = {
                TaskID = TaskInfo.TaskID,
                CanSubmit = CanSubmit,
                TaskState =  TaskInfo.TaskState,
                TaskInfo = TaskInfo,
            }
            table.insert(TmpSortData, Info)
        end

        table.sort(TmpSortData, function(a, b)
            -- 规则1：状态0（待提交）优先于其他状态
            if a.TaskState ~= b.TaskState then
                -- a的状态是0，b的状态不是0，a在前
                if a.TaskState == 0 then
                    return true
                -- b的状态是0，a的状态不是0，b在前
                elseif b.TaskState == 0 then
                    return false
                -- 两者都不是0，但状态不同（理论上不会发生，除非有更多状态）
                else
                    return a.TaskState < b.TaskState  -- 按状态值升序
                end
            end

            -- 规则2：状态相同，可提交的优先
            if a.CanSubmit ~= b.CanSubmit then
                -- a可提交，b不可提交，a在前
                return a.CanSubmit
            end

            -- 规则3：状态和提交状态都相同，按ID升序
            -- 注意：必须使用 <，不能使用 <=
            return a.TaskID < b.TaskID
        end)

        -- 构建结果表
        local Result = {}
        for _, Task in ipairs(TmpSortData) do
            table.insert(Result, Task)
        end

        return Result
    end
    local SortRes = SortByRarity(AllEntrustTask)

    return SortRes
end

-- 获取当前刷新次数
-- function M:

-- 获取最大刷新次数

-- 释放掉所保存的初始Mod数据 在关闭声望任务界面时会清掉
function M:ClearOriginalModsData()
    self.OriginalMods = nil
end

-- 获取当前 初始Mod（未养成、未佩戴、未锁定）的数量
function M:GetOriginalModCount(ModId)
    if not rawget(self, "OriginalMods") then
        -- 每次打开声望任务界面时会重新缓存 初始Mod表 防止后期玩家mod数量多导致卡顿
        rawset(self, "OriginalMods", self:GetAllOriginalMods())
    end
    local OwnerOriginalModCount = self.OriginalMods[ModId]
    OwnerOriginalModCount = OwnerOriginalModCount and OwnerOriginalModCount or 0
    return OwnerOriginalModCount
end

-- 消耗指定数量的指定MOD 在提交成功的回调中调用
---@param ModId number MOD的ID标识符
---@param Count number 要消耗的数量
function M:ConsumeMod(ModId, Count)
    if not self.OriginalMods then
        return
    end
    if not self.OriginalMods[ModId] then
        return
    end

    local RemainingNum = self.OriginalMods[ModId] - Count
    RemainingNum = RemainingNum >= 0 and RemainingNum or 0
    self.OriginalMods[ModId] = RemainingNum
end

-- 获取当前玩家身上所有的初始mod
function M:GetAllOriginalMods()
    local Avatar = self:GetAvatar()
    if not Avatar then
        return
    end
    local ModStatistics = {}
	for _, Mod in pairs(Avatar.Mods) do
		if Mod.IsOriginal and not Mod:IsEquipped() then
			if not ModStatistics[Mod.ModId] then
				ModStatistics[Mod.ModId] = 0
			end
			ModStatistics[Mod.ModId] = ModStatistics[Mod.ModId] + Mod.Count
		end
	end
    return ModStatistics
end

function M:GetAlreadyRefreshEntrustTaskCount(RegionId)
    local Avatar = self:GetAvatar()
    if not Avatar then
        return
    end
    local RegionReputationData = DataMgr.RegionReputation[RegionId]
    if not RegionReputationData then
        return
    end
    if not Avatar.RegionReputations[RegionId] then
        return
    end
    local RemainingRefreshCount = Avatar.RegionReputations[RegionId].EntrustQuestRemainRefreshTimes
    local MaxRefreshCount = RegionReputationData.ManualRefreshNumber
    return math.max(0, MaxRefreshCount - RemainingRefreshCount)
end
--endregion

-----------------------------------------循环任务--------------------------------------
--region 循环任务 

-- 获取循环任务刷新时间
function M:GetRecurringTaskRefreshTime(RegionId)
    local Avatar = self:GetAvatar()
    if not Avatar then
        return
    end
    if not Avatar.RegionReputations[RegionId] then
        return
    end
    local TargetRegionRefreshTime = Avatar.RegionReputations[RegionId].LastRefreshTime1
    if not TargetRegionRefreshTime then
        return
    end
    local Cache = DataMgr.RegionReputation
    local RefreshTime = 0
    for DictType, DictValue in pairs(Cache[RegionId].RefreshTime1) do
        if RefreshTimeType[DictType] == RefreshTimeType["HOUR"] then
            RefreshTime = RefreshTime + DictValue * 60 * 60
        elseif RefreshTimeType[DictType] == RefreshTimeType["DAY"] then
            RefreshTime = RefreshTime + DictValue * 60 * 60 * 24
        elseif RefreshTimeType[DictType] == RefreshTimeType["WEEK"] then
            RefreshTime = RefreshTime + DictValue * 60 * 60 * 24 * 7
        end
    end
    TargetRegionRefreshTime = TargetRegionRefreshTime + RefreshTime
    return TargetRegionRefreshTime
end

---@note  获取循环任务等级
-- @return CurrentRarity CurrentDoingRecurringTask
function M:GetCurrentRecurringTaskLevel(RegionId)
    -- 计算下当前循环任务等级 青铜 白银 黄金
    local FinRarity = 1
    local CurrentDoingRecurringTask = nil
    local Quests = self:GetRecurringTasks(RegionId)
    local AllTaskData = DataMgr.RecurringTask
    for _, QuestInfo in ipairs(Quests) do
        local QuestId = QuestInfo.QuestId
        if not AllTaskData[QuestId] then
            DebugPrint(string.format("未获取到 RecurringTask 中 %d 相关数据，请检查", QuestId))
            return 1, nil
        end
        local State = self:GetTargetRecurringTaskStat(RegionId, QuestId)
        if State == CommonConst.RecurringTaskState.Doing then
            FinRarity = AllTaskData[QuestId].Rarity
            CurrentDoingRecurringTask = QuestId
        elseif State == CommonConst.RecurringTaskState.AlreadyClaimed then
            FinRarity = AllTaskData[QuestId].Rarity + 1
        end
    end
    return FinRarity, CurrentDoingRecurringTask
end

-- 获取对应区域所有已完成但未领奖的副本任务
function M:GetTargetRegionAllCanClaimRecurringTasks(RegionId)
    local Quests = self:GetRecurringTasks(RegionId)
    if not Quests then
        return
    end
    local CanClaimTasks = {}
    for Index, TaskInfo in pairs(Quests) do
        if TaskInfo.Info.State == CommonConst.RecurringTaskState.CanClaim then
            -- 已完成未领奖 添加到CanClaimTasks表中
            table.insert(CanClaimTasks, {
                TaskId = TaskInfo.QuestId,
                Level = math.floor((Index - 1) / 3) + 1,
            })
        end
    end
    return CanClaimTasks
end

--- 获取对应区域是否有可提交的委托任务
---@param RegionId number 区域ID
---@return boolean 是否有可提交的委托任务
function M:GetTargetRegionEntrustTaskCanSubmit(RegionId)
    local EntrustTasks = self:GetEntrustTasks(RegionId)
    if not EntrustTasks then
        return false
    end
    for _, TaskInfo in pairs(EntrustTasks) do
        if TaskInfo.CanSubmit and TaskInfo.TaskState == CommonConst.EntrustFameTaskState.ReadyClaim then
            return true
        end
    end
    return false
end

-- 获取目标循环任务的状态
function M:GetTargetRecurringTaskStat(RegionId, TaskId)
    local Avatar = self:GetAvatar()
    if not Avatar then
        return
    end

    local Quests = Avatar:GetReputationRecurringQuest(RegionId)
    local TaskInfo = Quests[TaskId]
    if not TaskInfo then
        return
    end

    -- local TaskData = DataMgr.RecurringTask[TaskId]
    -- if not TaskData then
    --     return
    -- end

    return TaskInfo.State

    -- if TaskInfo.State == CommonConst.RecurringTaskState.AlreadyClaimed then
    --     return CommonConst.RecurringTaskState.AlreadyClaimed
    -- elseif TaskInfo.State == CommonConst.RecurringTaskState.NotAccept then
    --     return CommonConst.RecurringTaskState.NotAccept
    -- elseif TaskInfo.State == CommonConst.RecurringTaskState.Doing then
    --     local CurrentTaskProgress = TaskInfo.Progress
    --     if CurrentTaskProgress >= TaskData.Target then
    --         return CommonConst.RecurringTaskState.CanClaim
    --     end
    --     -- 判定当前任务是否有倒计时
    --     if not TaskData.Countdown then
    --         -- 无倒计时 直接返回进行中状态
    --         return CommonConst.RecurringTaskState.Doing
    --     else
    --         -- 有倒计时 并且TaskInfo.StartTime为0 判定为超时 超时则为可领奖状态
    --         if not TaskInfo.StartTime or TaskInfo.StartTime == 0 then
    --             return CommonConst.RecurringTaskState.CanClaim
    --         end
    --     end
    --     return CommonConst.RecurringTaskState.Doing
    -- end
end

-- 任务目标循环任务是否已经领奖
function M:GetRecurringTaskHasAwardReceived(RegionId, TaskId)
    local Avatar = self:GetAvatar()
    if not Avatar then
        return
    end
    local Quests = Avatar:GetReputationRecurringQuest(RegionId)
    if not Quests[TaskId] then
        return
    end
    local bTaskHasAwardReceived = Quests[TaskId].State == CommonConst.RecurringTaskState.AlreadyClaimed
    return bTaskHasAwardReceived
end

-- 获取当前进行中的循环任务是否已经完成
function M:GetDoingRecurringTaskCompleted()
    local Avatar = self:GetAvatar()
    if not Avatar then
        return
    end
    local DoingRegionId, DoingTaskId = Avatar:GetCurrentDoingRecurringQuestId()
    if not DoingRegionId then
        return
    end
    local TaskData = DataMgr.RecurringTask[DoingTaskId]
    if not TaskData then
        return
    end
    local DoingTaskProgress = self:GetDoingRecurringTaskProgress()
    if DoingTaskProgress >= TaskData.Target then
        return true
    end
    return false
end

-- 获取目标循环任务的进度
function M:GetTargetRecurringTaskProgress(RegionId, TaskId)
    local Avatar = self:GetAvatar()
    if not Avatar then
        return
    end
    local AllTasks = Avatar:GetReputationRecurringQuest(RegionId)
    local TaskInfo = AllTasks[TaskId]
    if not TaskInfo then
        return
    end
    return TaskInfo.Progress
end

-- 获取当前正在进行的循环任务的进度
function M:GetDoingRecurringTaskProgress()
    local Avatar = self:GetAvatar()
    if not Avatar then
        return nil
    end
    local DoingRegionId, DoingTaskId = Avatar:GetCurrentDoingRecurringQuestId()
    if not DoingRegionId then
        return nil
    end
    return self:GetTargetRecurringTaskProgress(DoingRegionId, DoingTaskId)
end

-- 获取当前接取循环任务的时间戳
function M:GetCurrentRecurringTaskTimestamp()
    local Avatar = self:GetAvatar()
    if not Avatar then
        return nil
    end
    local DoingRegionId, DoingTaskId = Avatar:GetCurrentDoingRecurringQuestId()
    if not DoingRegionId then
        return nil
    end

    local TaskData = DataMgr.RecurringTask[DoingTaskId]
    if not TaskData then
        return nil
    end
    -- 判定进行中的循环任务是否有倒计时
    if TaskData.Countdown then
        local _, _, StartTimestamp = Avatar:GetCurrentDoingRecurringQuestId()
        -- 获取服务器上接取当前任务的时间戳
        -- local TestTimestamp = os.time({year=2025, month=12, day=31, hour=23, min=59, sec=59})
        if not StartTimestamp then
            return nil
        end
        StartTimestamp = StartTimestamp + TaskData.Countdown
        return StartTimestamp
    else
        return nil
    end
end

-- 获取此轮副本任务 按等级 ID 排序
function M:GetRecurringTasks(RegionId)
    local Avatar = self:GetAvatar()
    if not Avatar then
        return
    end
    local Quests = Avatar:GetReputationRecurringQuest(RegionId)
    if not Quests then
        return
    end

    local AllTaskData = DataMgr.RecurringTask

    local function SortByRarity(Data)
        local Keys = {}
        for key in pairs(Data) do
            table.insert(Keys, key)
        end

        table.sort(Keys, function(a, b)
            local TaskAData = AllTaskData[a]
            local TaskBData = AllTaskData[b]
            if not TaskAData or not TaskBData then
                -- QuestId升序
                return a < b
            end
            local A_Rarity = TaskAData.Rarity
            local B_Rarity = TaskBData.Rarity

            if A_Rarity == B_Rarity then
                return a < b  -- QuestId升序
            else
                return A_Rarity < B_Rarity  -- Rarity升序
            end
        end)

        -- 构建结果表
        local Result = {}
        for _, key in ipairs(Keys) do
            local Info = Data[key]
            table.insert(Result, {
                QuestId = key,
                Info = Info
            })
        end

        return Result
    end
    local SortRes = SortByRarity(Quests)

    return SortRes
end

-- 获取副本任务描述 的具体目标数或 进度/目标数
function M:GetTaskDesProgress(RegionId, TaskId)
    local Avatar = self:GetAvatar()
    if not Avatar then
        return
    end
    local RegionReputationData = DataMgr.RecurringTask[TaskId]
    if not RegionReputationData then
        return
    end
    if not Avatar.RegionReputations[RegionId] then
        return
    end
    local TaskCurrentState = self:GetTargetRecurringTaskStat(RegionId, TaskId)
    local TaskType = RegionReputationData.Type
    local TargetCount = RegionReputationData.Target
    if TaskType ~= 1 or TaskCurrentState == CommonConst.RecurringTaskState.NotAccept then
        return tostring(TargetCount)
    end
    local CurrentProgress = self:GetTargetRecurringTaskProgress(RegionId, TaskId)
    return string.format("%d/%d", CurrentProgress, TargetCount)
end
--endregion


--region 声望奖励
-- 获取目标区域 对应等级 当前的领奖情况
function M:GetTargetLevelRewardState(RegionId, TargetLevel)
    local CurRegionLevel = self:GetRegionFameLevel(RegionId)
    if not CurRegionLevel then
        return
    end
    local Avatar = self:GetAvatar()
    if not Avatar then
        return
    end
    local State = CommonConst.FameRewardState.NotClaimable
    if CurRegionLevel >= TargetLevel then
        -- 是否可以领取当前奖励 True 为 可领取 False 为 已领取
        local bReadyClaim = Avatar:CheckReputationLevelReward(RegionId, TargetLevel)
        State = bReadyClaim and CommonConst.FameRewardState.ReadyClaim or CommonConst.FameRewardState.AlreadyClaimed
    end
    return State
end
--endregion

return M