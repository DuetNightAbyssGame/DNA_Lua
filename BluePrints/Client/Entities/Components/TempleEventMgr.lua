local Component = {}
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

local EventId = 108001

function Component:EnterWorld()
    EventManager:AddEvent(EventID.OnLoginSuccess, self, self.OnLoginSuccess)
end

function Component:LeaveWorld()
    EventManager:RemoveEvent(EventID.OnLoginSuccess, self)
end

function Component:OnLoginSuccess()
    if not ActivityUtils.CheckEventIsOpen(EventId) then
        return
    end
	self:RefreshTempleSoloNewLevelReddot()
    self:RefreshTempleSoloEventRewardReddot()
end

function Component:TempleGetReward(TempleRewardId, CallBack)
	self.logger.info("TempleGetReward", TempleRewardId)
    local function Cb(ErrCode, Ret)
        if CallBack then
            CallBack(ErrCode, Ret)
        end
        DebugPrint("TempleGetReward",ErrorCode:Name(ErrCode))
    end
	self:CallServer("TempleGetReward", Cb, TempleRewardId) 
end

function Component:TempleGetAllModeReward(EventId, IsHardMode, CallBack)
	self.logger.info("TempleGetAllModeReward", EventId, IsHardMode)
    local function Cb(ErrCode, Ret)
        if CallBack then
            CallBack(ErrCode, Ret)
        end
        DebugPrint("TempleGetAllModeReward",ErrorCode:Name(ErrCode))
    end
	self:CallServer("TempleGetAllModeReward", Cb, EventId, IsHardMode) 
end

function Component:RefreshTempleSoloNewLevelReddot()
    if not ReddotManager.GetTreeNode("TempleSoloNewLevel") then
        ReddotManager.AddNodeEx("TempleSoloNewLevel")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("TempleSoloNewLevel")
    for DungeonId,_ in pairs(DataMgr.TempleEventLevel) do
        if CacheDetail[DungeonId] == 1 then
            CacheDetail[DungeonId] = nil
        end
    end
	ReddotManager.ClearLeafNodeCount("TempleSoloNewLevel")
    self:_TryAddTempleSoloNewLevelReddot(EventId)
end

function Component:_TryAddTempleSoloNewLevelReddot(EventId)
    local ReddotNode = ReddotManager.GetTreeNode("TempleSoloNewLevel")
    if not ReddotNode then
        ReddotNode = ReddotManager.AddNodeEx("TempleSoloNewLevel")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("TempleSoloNewLevel")
    if CacheDetail.EventId ~= EventId then
        ReddotManager.ClearLeafNodeCount("TempleSoloNewLevel", true)
    end
    CacheDetail = ReddotManager.GetLeafNodeCacheDetail("TempleSoloNewLevel")
    CacheDetail.EventId = EventId
    local TempleSoloLevel = DataMgr.TempleEventLevel
    local CurrentTime = TimeUtils.NowTime()
    local IncreaseNum = 0
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    for DungeonId,Info in pairs(TempleSoloLevel) do
        if not CacheDetail[DungeonId] and ((not Info.UnlockDate) or CurrentTime >= Info.UnlockDate) then
            local IsPass = false
            if Avatar.Temple then 
                local CurStar = Avatar.Temple[EventId] and Avatar.Temple[EventId].FinishStars[DungeonId] or 0
                if CurStar >= CommonConst.TemplePassNeedStar then
                    IsPass = true
                end
            end
            if not IsPass then
                if not Info.PreDungeon then
                    CacheDetail[DungeonId] = 1
                    IncreaseNum = IncreaseNum + 1
                else
                    local MaxStar = 0
                    local TargetStar = CommonConst.TemplePassNeedStar
                    local PreInfo = TempleSoloLevel[Info.PreDungeon]
                    if PreInfo then
                        MaxStar = Avatar.Temple[EventId] and Avatar.Temple[EventId].FinishStars[PreInfo.DungeonId] or 0
                    end
                    if MaxStar >= TargetStar then
                        CacheDetail[DungeonId] = 1
                        IncreaseNum = IncreaseNum + 1
                    end
                end
            end
        end
    end
    if IncreaseNum > 0 then
        ReddotManager.IncreaseLeafNodeCount("TempleSoloNewLevel", IncreaseNum)
    end
end

function Component:RefreshTempleSoloEventRewardReddot()
    if not ReddotManager.GetTreeNode("TempleSoloEventReward") then
        ReddotManager.AddNodeEx("TempleSoloEventReward")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("TempleSoloEventReward")
    CacheDetail[1] = nil
    CacheDetail[2] = nil
	ReddotManager.ClearLeafNodeCount("TempleSoloEventReward")
    self:_TryAddTempleSoloEventRewardReddot(EventId)
end

function Component:_TryAddTempleSoloEventRewardReddot(EventId)
    local ReddotNode = ReddotManager.GetTreeNode("TempleSoloEventReward")
    if not ReddotNode then
        ReddotNode = ReddotManager.AddNodeEx("TempleSoloEventReward")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("TempleSoloEventReward")
    if CacheDetail.EventId ~= EventId then
        ReddotManager.ClearLeafNodeCount("TempleSoloEventReward", true)
    end
    CacheDetail = ReddotManager.GetLeafNodeCacheDetail("TempleSoloEventReward")
    CacheDetail.EventId = EventId
    local TempleEventReward = DataMgr.TempleEventReward
    local IncreaseNum = 0
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    for TempleRewardId,Info in pairs(TempleEventReward) do
        if not CacheDetail[TempleRewardId] then
            local CanGot = false
            if Avatar.Temple then 
                local TempleEventData = Avatar.Temple[EventId]
                local Item={}
                local RewardState = 0
                if TempleEventData and TempleEventData.ProgressRewardsGot and TempleEventData.ProgressRewardsGot[TempleRewardId] then
                    if TempleEventData.ProgressRewardsGot[TempleRewardId] == 1 then
                        RewardState = 1
                    elseif TempleEventData.ProgressRewardsGot[TempleRewardId] == 2 then
                        RewardState = 2
                    end
                end
                CanGot = RewardState == 1
            end
            if CanGot then
                -- CacheDetail[TempleRewardId] = 1
                IncreaseNum = IncreaseNum + 1
                if not Info.IsHardMode then
                    if not CacheDetail[1] then
                        CacheDetail[1] = {}
                    end
                    CacheDetail[1][TempleRewardId] = 1
                else
                    if not CacheDetail[2] then
                        CacheDetail[2] = {}
                    end
                    CacheDetail[2][TempleRewardId] = 1
                end
            end
        end
    end
    if IncreaseNum > 0 then
        ReddotManager.IncreaseLeafNodeCount("TempleSoloEventReward", IncreaseNum)
    end
end

return Component