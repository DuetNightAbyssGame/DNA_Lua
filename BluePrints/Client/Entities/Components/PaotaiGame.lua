local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

local Component = {}

function Component:EnterWorld()
    EventManager:AddEvent(EventID.OnLoginSuccess, self, self.OnLoginSuccess)
    EventManager:AddEvent(EventID.OnActivityTimeOpen, self, self.TryRefreshPaotaiGameNewLevelOnActivityTimeOpen)
end

function Component:LeaveWorld()
    EventManager:RemoveEvent(EventID.OnLoginSuccess, self)
    EventManager:RemoveEvent(EventID.OnActivityTimeOpen, self)
end

function Component:PaotaiGetScoreReward(PaotaiId, ScoreIdx, Callback)
	self.logger.info("PaotaiGetScoreReward", PaotaiId, ScoreIdx)
    local function Cb(ErrCode,RewardReturn)
        DebugPrint("PaotaiGetScoreReward",ErrorCode:Name(ErrCode))
        if ErrorCode:Check(ErrCode) then
            Callback(ErrCode,RewardReturn)
        end
    end
	self:CallServer("PaotaiGetScoreReward", Cb, PaotaiId, ScoreIdx) 
end

function Component:PaotaiGetAllScoreReward(PaotaiId, Callback)
	self.logger.info("PaotaiGetAllScoreReward", PaotaiId)
    local function Cb(ErrCode,RewardReturn)
        DebugPrint("PaotaiGetAllScoreReward",ErrorCode:Name(ErrCode))
        if ErrorCode:Check(ErrCode) then
            Callback(ErrCode,RewardReturn)
        end
    end
	self:CallServer("PaotaiGetAllScoreReward", Cb, PaotaiId) 
end

function Component:PaotaiUpdateBuffs(Buffs, Callback)
	self.logger.info("PaotaiUpdateBuffs", Buffs)
    local function Cb(ErrCode)
        DebugPrint("PaotaiUpdateBuffs",ErrorCode:Name(ErrCode))
        if ErrorCode:Check(ErrCode) then
            Callback()
        end
    end
	self:CallServer("PaotaiUpdateBuffs", Cb, Buffs)
end

function Component:_OnPropChangePaotaiGame(key)
    local EventId = key[1]
    self:_TryAddPaotaiGameRewardReddot(EventId)
    self:_TryAddPaotaiGameNewLevelReddot(EventId)
    self:_TryAddPaotaiGameNewBuffReddot(EventId)
end

function Component:RefreshPaotaiEventRewardReddot()
    if not ReddotManager.GetTreeNode("PaotaiEventReward") then
        ReddotManager.AddNode("PaotaiEventReward")
    end
	ReddotManager.ClearLeafNodeCount("PaotaiEventReward", true)
    local EventId = DataMgr.PaotaiEventConstant.PaotaiGameEventId.ConstantValue
    self:_TryAddPaotaiGameRewardReddot(EventId)
end

function Component:_TryAddPaotaiGameRewardReddot(EventId)
    local ReddotNode = ReddotManager.GetTreeNode("PaotaiEventReward")
    if not ReddotNode then
        ReddotNode = ReddotManager.AddNode("PaotaiEventReward")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("PaotaiEventReward")
    if CacheDetail.EventId ~= EventId then
        ReddotManager.ClearLeafNodeCount("PaotaiEventReward", true)
    end
    if not EventId or not ActivityUtils.CheckEventIsOpen(EventId) then
        return
    end
    CacheDetail = ReddotManager.GetLeafNodeCacheDetail("PaotaiEventReward")
    CacheDetail.EventId = EventId
    local TargetNum = 0
    local CurrentNum = ReddotNode.Count
    local PaotaiMiniGame = DataMgr.PaotaiMiniGame
    for DungeonId,Info in pairs(PaotaiMiniGame) do
        if Info.EventId == EventId then
            if self.PaotaiGame[EventId] and self.PaotaiGame[EventId][DungeonId] then
                local RewardsGot = self.PaotaiGame[EventId][DungeonId].RewardsGot
                local MaxScore = self.PaotaiGame[EventId][DungeonId].MaxScore
                for Index,Score in pairs(Info.Level) do
                    if MaxScore >= Score and not RewardsGot[Score] then
                        if not CacheDetail[DungeonId] then
                            CacheDetail[DungeonId] = {}
                        end
                        CacheDetail[DungeonId][Score] = 1
                        TargetNum = TargetNum + 1
                    else
                        if CacheDetail[DungeonId] then
                            CacheDetail[DungeonId][Score] = nil
                            if next(CacheDetail[DungeonId]) == nil then
                                CacheDetail[DungeonId] = nil
                            end
                        end
                    end
                end
            else
                CacheDetail[DungeonId] = nil
            end
        else
            CacheDetail[DungeonId] = nil
        end
    end
    if CurrentNum < TargetNum then
        ReddotManager.IncreaseLeafNodeCount("PaotaiEventReward", TargetNum - CurrentNum)
    elseif CurrentNum > TargetNum then
        ReddotManager.DecreaseLeafNodeCount("PaotaiEventReward", CurrentNum - TargetNum)
    end
end

function Component:RefreshPaotaiEventNewLevelReddot()
    if not ReddotManager.GetTreeNode("PaotaiEventNewLevel") then
        ReddotManager.AddNodeEx("PaotaiEventNewLevel")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("PaotaiEventNewLevel")
    for DungeonId,_ in pairs(DataMgr.PaotaiMiniGame) do
        if CacheDetail[DungeonId] == 1 then
            CacheDetail[DungeonId] = nil
        end
    end
	ReddotManager.ClearLeafNodeCount("PaotaiEventNewLevel")
    local EventId = DataMgr.PaotaiEventConstant.PaotaiGameEventId.ConstantValue
    self:_TryAddPaotaiGameNewLevelReddot(EventId)
end

function Component:_TryAddPaotaiGameNewLevelReddot(EventId)
    local ReddotNode = ReddotManager.GetTreeNode("PaotaiEventNewLevel")
    if not ReddotNode then
        ReddotNode = ReddotManager.AddNodeEx("PaotaiEventNewLevel")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("PaotaiEventNewLevel")
    if CacheDetail.EventId ~= EventId then
        ReddotManager.ClearLeafNodeCount("PaotaiEventNewLevel", true)
    end
    if not EventId or not ActivityUtils.CheckEventIsOpen(EventId) then
        return
    end
    CacheDetail = ReddotManager.GetLeafNodeCacheDetail("PaotaiEventNewLevel")
    CacheDetail.EventId = EventId
    local PaotaiMiniGame = DataMgr.PaotaiMiniGame
    local CurrentTime = TimeUtils.NowTime()
    local IncreaseNum = 0
    for DungeonId,Info in pairs(PaotaiMiniGame) do
        if Info.EventId == EventId then
            if not CacheDetail[DungeonId] and CurrentTime >= Info.StartTime then
                local IsPass = false
                if self.PaotaiGame[EventId] and self.PaotaiGame[EventId][DungeonId] then
                    local MaxScore = self.PaotaiGame[EventId][DungeonId].MaxScore or 0
                    local TargetScore = 0
                    local PaotaiMiniGameInfo = PaotaiMiniGame[DungeonId]
                    if PaotaiMiniGameInfo then
                        local PreDungeonRequiredStar = DataMgr.PaotaiEventConstant.PreDungeonRequiredStar.ConstantValue
                        TargetScore = PaotaiMiniGameInfo.Level and PaotaiMiniGameInfo.Level[PreDungeonRequiredStar] or 0
                    end
                    if MaxScore >= TargetScore then
                        IsPass = true
                    end
                end
                if not IsPass then
                    if not Info.PreDungeon then
                        CacheDetail[DungeonId] = 1
                        IncreaseNum = IncreaseNum + 1
                    else
                        if self.PaotaiGame[EventId] and self.PaotaiGame[EventId][Info.PreDungeon] then
                            local MaxScore = self.PaotaiGame[EventId][Info.PreDungeon].MaxScore or 0
                            local TargetScore = 0
                            local PreInfo = PaotaiMiniGame[Info.PreDungeon]
                            if PreInfo then
                                local PreDungeonRequiredStar = DataMgr.PaotaiEventConstant.PreDungeonRequiredStar.ConstantValue
                                TargetScore = PreInfo.Level and PreInfo.Level[PreDungeonRequiredStar] or 0
                            end
                            if MaxScore >= TargetScore then
                                CacheDetail[DungeonId] = 1
                                IncreaseNum = IncreaseNum + 1
                            end
                        end
                    end
                end
            end
        end
    end
    if IncreaseNum > 0 then
        ReddotManager.IncreaseLeafNodeCount("PaotaiEventNewLevel", IncreaseNum)
    end
end

function Component:OnDailyRefreshPaotaiGameNewLevel()
    if TimeUtils.ServerTimeZone == nil then
        return
    end
    local EventId = DataMgr.PaotaiEventConstant.PaotaiGameEventId.ConstantValue
    self:_TryAddPaotaiGameNewLevelReddot(EventId)
end

function Component:TryRefreshPaotaiGameNewLevelOnActivityTimeOpen(ActivityId)
    local EventId = DataMgr.PaotaiEventConstant.PaotaiGameEventId.ConstantValue
    if EventId == ActivityId then
        self:_TryAddPaotaiGameNewLevelReddot(EventId)
    end
end

function Component:RefreshPaotaiEventNewBuffReddot()
    if not ReddotManager.GetTreeNode("PaotaiEventNewBuff") then
        ReddotManager.AddNodeEx("PaotaiEventNewBuff")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("PaotaiEventNewBuff")
    local PaotaiBuff = {
        DataMgr.PaotaiGameProp,
        DataMgr.PaotaiGameWeapon,
    }
    for _,Buffs in pairs(PaotaiBuff) do
        for _,BuffInfo in pairs(Buffs) do
            if CacheDetail[BuffInfo.BuffId] == 1 then
                CacheDetail[BuffInfo.BuffId] = nil
            end
        end
    end
	ReddotManager.ClearLeafNodeCount("PaotaiEventNewBuff")
    local EventId = DataMgr.PaotaiEventConstant.PaotaiGameEventId.ConstantValue
    self:_TryAddPaotaiGameNewBuffReddot(EventId)
end

function Component:_TryAddPaotaiGameNewBuffReddot(EventId)
    local ReddotNode = ReddotManager.GetTreeNode("PaotaiEventNewBuff")
    if not ReddotNode then
        ReddotNode = ReddotManager.AddNodeEx("PaotaiEventNewBuff")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("PaotaiEventNewBuff")
    if CacheDetail.EventId ~= EventId then
        ReddotManager.ClearLeafNodeCount("PaotaiEventNewBuff", true)
    end
    if not EventId or not ActivityUtils.CheckEventIsOpen(EventId) then
        return
    end
    CacheDetail = ReddotManager.GetLeafNodeCacheDetail("PaotaiEventNewBuff")
    CacheDetail.EventId = EventId
    local PaotaiBuff = {
        DataMgr.PaotaiGameProp,
        DataMgr.PaotaiGameWeapon,
    }
    local IncreaseNum = 0
    for _,Buffs in pairs(PaotaiBuff) do
        for _,BuffInfo in pairs(Buffs) do
            if not CacheDetail[BuffInfo.BuffId] then
                if not BuffInfo.DungeonId then
                    CacheDetail[BuffInfo.BuffId] = 1
                    IncreaseNum = IncreaseNum + 1
                else
                    if self.PaotaiGame[EventId] and self.PaotaiGame[EventId][BuffInfo.DungeonId] then
                        local MaxScore = self.PaotaiGame[EventId][BuffInfo.DungeonId].MaxScore or 0
                        local TargetScore = 0
                        local PreInfo = DataMgr.PaotaiMiniGame[BuffInfo.DungeonId]
                        if PreInfo then
                            local PreDungeonRequiredStar = DataMgr.PaotaiEventConstant.PreDungeonRequiredStar.ConstantValue
                            TargetScore = PreInfo.Level and PreInfo.Level[PreDungeonRequiredStar] or 0
                        end
                        if MaxScore >= TargetScore then
                            CacheDetail[BuffInfo.BuffId] = 1
                            IncreaseNum = IncreaseNum + 1
                        end
                    end
                end
            end
        end
    end
    if IncreaseNum > 0 then
        ReddotManager.IncreaseLeafNodeCount("PaotaiEventNewBuff", IncreaseNum)
    end
end

function Component:OnLoginSuccess()
    self:RefreshPaotaiEventNewLevelReddot()
	self:RefreshPaotaiEventNewBuffReddot()
	self:RefreshPaotaiEventRewardReddot()
end

return Component
