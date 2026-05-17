local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties


local RaidSeason = Class("RaidSeason", CustomTypes.CustomAttr)
    RaidSeason.__Props__ = {
        RaidSeasonId = prop.prop("Int", "client save"),

        MaxPreRaidScore = prop.prop("Int", "client save", 0), -- 预选赛历史最高积分
        MaxRaidScore = prop.prop("Int", "client save", 0), -- 正式赛预选最高积分

        PreRaidGroupId = prop.prop("Int", "client save", 0), -- 预选赛组，预选赛结束后确定
        RaidGroupId = prop.prop("Int", "client save", 0), -- 正式赛组，预选赛结束后确定

        PreRaidRewardGot = prop.prop("Int", "client save", 0), -- 预选赛奖励领取

        BanState = prop.prop("Int", "client save", 0), -- 封禁状态：0 未封禁 1 已封禁

        MaxSquad = prop.prop("Str", "client save"), -- 最大分数阵容

        FinalRank = prop.prop("Int", "client save", 0), -- 正式赛最终排名

        EventId = prop.getter("Data", "EventId"),

        PreRaidRank = prop.getter("Data", "PreRaidRank"),
        PreRaidTime = prop.getter("Data", "PreRaidTime"),
       
        RaidTime = prop.getter("Data", "RaidTime"),
        RaidRankCount = prop.getter("Data", "RaidRankCount"),
       
        Shop = prop.getter("Data", "Shop"),
        RaidPointToRewrad = prop.getter("Data", "RaidPointToRewrad"),
        RaidPointToRewradMaxTime = prop.getter("Data", "RaidPointToRewradMaxTime"),
	}



    function RaidSeason:Init(RaidSeasonId)
        self.RaidSeasonId = RaidSeasonId
    end

    function RaidSeason:Data()
        return DataMgr.RaidSeason[self.RaidSeasonId]
    end

    function RaidSeason:SetRaidGroupId(RaidGroupId)
        self.RaidGroupId = RaidGroupId
    end

    function RaidSeason:GetRaidGroupId()
        return self.RaidGroupId
    end

    function RaidSeason:IsPreRaidRewardGot()
        return self.PreRaidRewardGot == 1
    end

    function RaidSeason:GetEventData()
        return DataMgr.EventMain[self.EventId]
    end

    function RaidSeason:GetStartTime()
        if skynet then
            return TimeUtils.EastEightToLocalTimestamp(self:GetEventData().EventStartTime)
        end
        return self:GetEventData().EventStartTime
    end

    function RaidSeason:GetEndTime()
        if skynet then
            return TimeUtils.EastEightToLocalTimestamp(self:GetEventData().EventEndTime)
        end
        return self:GetEventData().EventEndTime
    end

    function RaidSeason:SaveSquadInfo(Info)
        self.MaxSquad = SerializeUtils:Serialize(Info)
    end

    function RaidSeason:UpdateCurrentScore(TargetScore, TargetTime)
        if self:GetEventData() then
            if self:CheckTarget_IsPreRaidTime(TargetTime) then
                self.MaxPreRaidScore = math.max(math.max(self.MaxPreRaidScore, TargetScore), 0)
            elseif self:CheckTarget_IsRaidTime(TargetTime) then
                self.MaxRaidScore = math.max(math.max(self.MaxRaidScore, TargetScore), 0)
            end
        end
    end

    function RaidSeason:GetMaxRaidScore_TargetTime(TargetTime)
        if self:GetEventData() then
            if self:CheckTarget_IsPreRaidTime(TargetTime) then
                return self.MaxPreRaidScore 
            elseif self:CheckTarget_IsRaidTime(TargetTime) then
                return self.MaxRaidScore
            end
        end
        return 0
    end

    function RaidSeason:GetMaxRaidScore()
        if self:GetEventData() then
            if self:IsPreRaidTime() then
                return self.MaxPreRaidScore 
            elseif self:IsRaidTime() then
                return self.MaxRaidScore
            end
        end
        return 0
    end

    -- 转化为秒
    function RaidSeason:GetPreRaidTime()
        return self.PreRaidTime * 60 * 60
    end

    function RaidSeason:CheckTarget_IsPreRaidTime(TargetTime)
        if TargetTime <= 0 then
            return false 
        end
        return TargetTime >= self:GetStartTime() and TargetTime < (self:GetStartTime() + self:GetPreRaidTime())
    end

    function RaidSeason:CheckTarget_IsRaidTime(TargetTime)
        if TargetTime <= 0 then
            return false 
        end
        return TargetTime >= (self:GetStartTime() + self:GetPreRaidTime()) and TargetTime < self:GetEndTime()
    end

    function RaidSeason:IsPreRaidTime()
        return TimeUtils.NowTime() >= self:GetStartTime() and TimeUtils.NowTime() < (self:GetStartTime() + self:GetPreRaidTime())
    end

    function RaidSeason:IsRaidTime()
        return TimeUtils.NowTime() >= (self:GetStartTime() + self:GetPreRaidTime()) and TimeUtils.NowTime() < self:GetEndTime()
    end

    function RaidSeason:IsBaned()
        return self.BanState >= 1
    end

    function RaidSeason:GetRaidGoupId()
        if self:IsPreRaidTime() then
            return self.PreRaidGroupId
        else
            return self.RaidGroupId
        end
    end

    function RaidSeason:GetRaidSeasonRewadCount(ResRaidScore, TargetTime)
        local TargetReward = {}
        if ResRaidScore <= 0 then return TargetReward end
        if self:CheckTarget_IsRaidTime(TargetTime) then
            for BaseScore, BaseRewardId in pairs( self.RaidPointToRewrad ) do
                local BaseRewardCount = math.max(  math.floor(ResRaidScore // BaseScore), 0)
                if BaseRewardCount > self.RaidPointToRewradMaxTime then
                    BaseRewardCount = self.RaidPointToRewradMaxTime
                end
                for Index = 1, BaseRewardCount do
                    table.insert(TargetReward, BaseRewardId)
                end
            end
        end
        return TargetReward
    end

    FormatProperties(RaidSeason)

local RaidSeasonDict = Class("RaidSeasonDict", CustomTypes.CustomDict)
    RaidSeasonDict.KeyType = BaseTypes.Int
    RaidSeasonDict.ValueType = RaidSeason

    function RaidSeasonDict:GetRaidSeason(RaidSeasonId)
        return self[RaidSeasonId]
    end

    function RaidSeasonDict:GetNewRaidSeason(RaidSeasonId)
        if not self[RaidSeasonId] then
            self[RaidSeasonId] = self:NewRaidSeason(RaidSeasonId)
        end
        return self[RaidSeasonId]
    end

    function RaidSeasonDict:NewRaidSeason(RaidSeasonId)
        return RaidSeason(RaidSeasonId)
    end
return {
    RaidSeasonDict = RaidSeasonDict,
    RaidSeason = RaidSeason
}

        