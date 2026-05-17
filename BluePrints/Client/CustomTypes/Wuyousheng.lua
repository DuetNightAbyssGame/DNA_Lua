local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties

local Wuyousheng = Class("Wuyousheng", CustomTypes.CustomAttr)
    Wuyousheng.__Props__ = {
        -- 无由生活动Id
        WuyoushengEventId = prop.prop("Int", "client save"),
        -- 关卡完成星数
        FinishStars = prop.prop("Int2IntDict", "client save"),
        -- 进度领奖信息{[奖励KeyId] = number, 1表示已领取}
        ProgressRewardsGot = prop.prop("Int2IntDict", "client save"),
        -- 阵容预设,一个副本id对应一个
        SquadInfoMap = prop.prop("Int2StrDict", "client save", {})
    }

    function Wuyousheng:Init(WuyoushengEventId)
        self.WuyoushengEventId = WuyoushengEventId
    end

    function Wuyousheng:IsRewarded(RewardKey)
        return self.ProgressRewardsGot[RewardKey] == 1
    end

    function Wuyousheng:IsCompleted(RewardKey, RequiredNum)
        local CurNum = self:GetTotalStars()
        return CurNum >= RequiredNum
    end

    function Wuyousheng:GetFinishStars(DungeonId)
        return self.FinishStars[DungeonId] or 0
    end

    function Wuyousheng:SetFinishStars(DungeonId, Stars)
        self.FinishStars[DungeonId] = Stars
    end

    function Wuyousheng:GetTotalStars()
        local TotalStars = 0
        for _, s in pairs(self.FinishStars) do
            TotalStars = TotalStars + s
        end
        return TotalStars
    end

    function Wuyousheng:SetRewardGot(RewardKey)
        self.ProgressRewardsGot[RewardKey] = 1
    end

    function Wuyousheng:GetSquadInfo(DungeonId)
        local SquadInfoStr = self.SquadInfoMap[DungeonId]
        if not SquadInfoStr then
            return
        end
        return SerializeUtils:UnSerialize(SquadInfoStr)
    end

    function Wuyousheng:SetSquadInfo(DungeonId, Squad)
        local SquadInfoStr = SerializeUtils:Serialize(Squad)
        self.SquadInfoMap[DungeonId] = SquadInfoStr
    end

    FormatProperties(Wuyousheng)


local WuyoushengDict = Class("WuyoushengDict", CustomTypes.CustomDict)
    WuyoushengDict.KeyType = BaseTypes.Int
    WuyoushengDict.ValueType = Wuyousheng

    function WuyoushengDict:GetNewWuyousheng(WuyoushengEventId)
        if not self[WuyoushengEventId] then
            self[WuyoushengEventId] = self:NewWuyousheng(WuyoushengEventId)
        end
        return self[WuyoushengEventId]
    end

    function WuyoushengDict:GetWuyousheng(WuyoushengEventId)
        return self[WuyoushengEventId]
    end

    function WuyoushengDict:SetWuyousheng(WuyoushengEventId, Wuyousheng)
        self[WuyoushengEventId] = Wuyousheng
    end

    function WuyoushengDict:NewWuyousheng(WuyoushengEventId)
        return Wuyousheng(WuyoushengEventId)
    end

return {
    Wuyousheng = Wuyousheng,
    WuyoushengDict = WuyoushengDict,
}