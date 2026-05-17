local Component = {}
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

function Component:EnterWorld()
	self:RefreshTheaterEventRewardReddot()
end

-- 领取任务奖励
function Component:TheaterGetTaskReward(TaskId, InCallBack)
	self.logger.info("TheaterGetTaskReward", TaskId)
    local function Cb(ErrCode,Ret)
        DebugPrint("TheaterGetTaskReward",ErrorCode:Name(ErrCode))
        if InCallBack then
            InCallBack(ErrCode,Ret)
        end
    end
	self:CallServer("TheaterGetTaskReward", Cb, TaskId) 
end

-- 一键领取任务奖励
function Component:TheaterGetAllTaskReward(IsDaily, InCallBack)
	self.logger.info("TheaterGetAllTaskReward", IsDaily)
    local function Cb(ErrCode,Ret)
        DebugPrint("TheaterGetAllTaskReward",ErrorCode:Name(ErrCode))
        if InCallBack then
            InCallBack(ErrCode,Ret)
        end
    end
	self:CallServer("TheaterGetAllTaskReward", Cb, IsDaily) 
end

-- 剧院交付材料
function Component:TheaterDonate(StepId, DonateList, InCallBack)
	self.logger.info("TheaterDonate", StepId, DonateList)
    local function Cb(ErrCode,Ret)
        DebugPrint("TheaterDonate",ErrorCode:Name(ErrCode))
        if InCallBack then
            InCallBack(ErrCode,Ret)
        end
    end
	self:CallServer("TheaterDonate", Cb, StepId, DonateList) 
end

-- 剧院接取小游戏任务
function Component:TheaterJoinPerformGame(InCallBack)
	self.logger.info("TheaterJoinPerformGame")
    local function Cb(ErrCode,Ret)
        DebugPrint("TheaterJoinPerformGame",ErrorCode:Name(ErrCode))
        if InCallBack then
            InCallBack(ErrCode,Ret)
        end
    end
	self:CallServer("TheaterJoinPerformGame", Cb) 
end

-- 剧院小游戏表演
function Component:TheaterPerform(PerformId, PerformIdx, InCallBack)
	self.logger.info("TheaterPerform", PerformId, PerformIdx)
    local function Cb(ErrCode,Ret)
        DebugPrint("TheaterPerform",ErrorCode:Name(ErrCode))
        if InCallBack then
            InCallBack(ErrCode,Ret)
        end
    end
	self:CallServer("TheaterPerform", Cb, math.tointeger(PerformId), PerformIdx) 
end

-- 剧院小游戏表演开始
function Component:TheaterPerformGameStart(EventId, PerformList)
    self.logger.info("TheaterPerformGameStart", EventId, PerformList)
    EventManager:FireEvent(EventID.OnTheaterPerformGameStart, EventId, PerformList)
end

-- 剧院小游戏表演通知即将开始
function Component:TheaterPerformGameNotice(EventId)
    self.logger.info("TheaterPerformGameNotice", EventId)
    EventManager:FireEvent(EventID.OnTheaterPerformGameNotice, EventId)
end

-- 剧院小游戏表演结束
function Component:TheaterPerformGameEnd(EventId)
    self.logger.info("TheaterPerformGameEnd", EventId)
    -- EventManager:FireEvent(EventID.OnTheaterPerformGameEnd)
end

function Component:TheaterPerformStateGet(InCallBack)
	self.logger.info("TheaterPerformStateGet")
    local function Cb(ErrCode,Ret)
        DebugPrint("TheaterPerformStateGet",ErrorCode:Name(ErrCode))
        if InCallBack then
            InCallBack(ErrCode,Ret)
        end
    end
	self:CallServer("TheaterPerformStateGet", Cb) 
end

-- 交付进度刷新
function Component:TheaterDonationGet(InCallBack)
	self.logger.info("TheaterDonationGet")
    local function Cb(ErrCode,Ret)
        DebugPrint("TheaterDonationGet",ErrorCode:Name(ErrCode))
        if InCallBack then
            InCallBack(ErrCode,Ret)
        end
    end
	self:CallServer("TheaterDonationGet", Cb) 
end

function Component:_OnPropChangeTheaterActivity(key)
    self:RefreshTheaterEventRewardReddot()
end

function Component:RefreshTheaterEventRewardReddot()
    local TabInfo = {false,false}
    local TheaterTaskData = DataMgr.TheaterTask
    local EventId = DataMgr.TheaterConstant.EventId.ConstantValue
    local TheaterData = self.TheaterActivity and self.TheaterActivity[EventId] or nil
    if not TheaterData then
        return
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("TheaterEventReward")
    if not CacheDetail then
        CacheDetail = {}
    end
    local IsEmpty = true
    local Node = ReddotManager.GetTreeNode("TheaterEventReward")
    for TaskId, TaskInfo in pairs(TheaterData.Tasks) do
        if TaskInfo.Progress >= TaskInfo.Target and not TaskInfo.RewardsGot then
            IsEmpty = false
            if not Node then
                ReddotManager.AddNode("TheaterEventReward")
            end
            local isDaily = TheaterTaskData[TaskId].IsDaily
            local index = isDaily and 1 or 2
            local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("TheaterEventReward")
            CacheDetail[index] = true
            TabInfo[index] = true
        end
    end
    for i = 1, #TabInfo do
        CacheDetail[i] = TabInfo[i]
    end
    if not IsEmpty then
        ActivityReddotHelper.TryAddReddotCount(ActivityUtils,EventId,"Red")
    else
        ActivityReddotHelper.TrySubReddotCount(ActivityUtils,EventId,"Red")
    end
    if Node then
        ReddotManager.IncreaseLeafNodeCount("TheaterEventReward", 1)
    end
end

-- 剧院游戏发放奖励
function Component:TheaterPerformGameReward(TotalRewardsBox)
    self.logger.info("TheaterPerformGameReward")
    local RewardList = {}
    local AllRewardType = DataMgr.RewardType
    for Type, _ in pairs(AllRewardType) do
        local CurRewards = TotalRewardsBox[Type.."s"]
        if not IsEmptyTable(CurRewards) then
            for Id, Count in pairs(CurRewards) do
                local ItemId = Id
                local ItemCount = Count["1"]
                local ItemRarity = ItemUtils.GetItemRarity(ItemId, Type)
                local ItemType = Type
                local RewardContent = {
                    ItemType = ItemType,
                    ItemId = ItemId,
                    Count = ItemCount,
                    Rarity = ItemRarity,
                }
                table.insert(RewardList, RewardContent)
            end
        end
    end
    
	UIUtils.ShowHudReward(GText("UI_COMMON_REWARD"), RewardList)
end

return Component