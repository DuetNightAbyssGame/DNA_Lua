local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties

local BackpackPuzzle = Class("BackpackPuzzle", CustomTypes.CustomAttr)
BackpackPuzzle.__Props__ = {
        -- 活动Id
        EventId = prop.prop("Int", "client save"),
        -- 关卡Id
        BackpackLevelId = prop.prop("Int", "client save"),
        -- 关卡完成分数
        FinishScore = prop.prop("Int", "client save", 0),
        -- 分数领奖信息{[奖励KeyId] = number, 1表示可领取，2表示已领取}
        ScoreRewardsGot = prop.prop("Int2IntDict", "client save"),
    }

    function BackpackPuzzle:Init(EventId)
        self.EventId = EventId
    end

    function BackpackPuzzle:SetScoreRewardGot(RewardKeyId)
        self.ScoreRewardsGot[RewardKeyId] = 2
    end

    function BackpackPuzzle:SetScoreCompleted(RewardKeyId)
        self.ScoreRewardsGot[RewardKeyId] = 1
    end

    function BackpackPuzzle:IsScoreRewardGot(RewardKeyId)
        return self.ScoreRewardsGot[RewardKeyId] == 2
    end

    function BackpackPuzzle:IsScoreCompleted(RewardKeyId)
        return self.ScoreRewardsGot[RewardKeyId] == 1
    end

    FormatProperties(BackpackPuzzle)


local BackpackPuzzleDict = Class("BackpackPuzzleDict", CustomTypes.CustomDict)
    BackpackPuzzleDict.KeyType = BaseTypes.Int
    BackpackPuzzleDict.ValueType = BackpackPuzzle

    function BackpackPuzzleDict:GetNewBackpackPuzzle(EventId)
        if not self[EventId] then
            self[EventId] = self:NewBackpackPuzzle(EventId)
        end
        return self[EventId]
    end

    function BackpackPuzzleDict:GetBackpackPuzzle(EventId)
        return self[EventId]
    end

    function BackpackPuzzleDict:NewBackpackPuzzle(EventId)
        return BackpackPuzzle(EventId)
    end

return {
    BackpackPuzzle = BackpackPuzzle,
    BackpackPuzzleDict = BackpackPuzzleDict,
}