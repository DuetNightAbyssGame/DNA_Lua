local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties

local DailyPack = Class("DailyPack", CustomTypes.CustomAttr)
DailyPack.__Props__ = {
        -- 礼包id
        DailyPackId = prop.prop("Int", "client save"),
        -- 累登天数
        LoginDays = prop.prop("Int", "client save", 0),
        -- 过期时间
        ExpiredTime = prop.prop("Int", "client save", 0),
        -- 礼包数量
        Count = prop.prop("Int", "client save", 0), 
        -- 是否激活状态：0未激活、1已激活
        State = prop.prop("Int", "client save", 0), 
        -- 奖励领取情况
        RewardGot = prop.prop("Int2IntDict", "client save"),
        -- 上次奖励领取时间
        LastRefreshTime = prop.prop("Int", "client save"),
        -- 奖励领取记录 {{累登天数，奖励id，领取时间}}
        RewardRecord = prop.prop("Int2IntListDict", "save", {}),

        RewardPeriod = prop.getter("Data", "RewardPeriod"),
        RewardMailId = prop.getter("Data", "RewardMailId"),
        Reward = prop.getter("Data", "Reward"),
        LoginRequire = prop.getter("Data", "LoginRequire"),
        BuyReward = prop.getter("Data", "BuyReward"),
	}

    function DailyPack:Init(DailyPackId)
        self.DailyPackId = DailyPackId
        self.LoginDays = 1
    end

    function DailyPack:Data()
        return DataMgr.DailyPack[self.DailyPackId]
    end

    function DailyPack:Active()
        local NowTime = TimeUtils.NowTime()
        if self.State == 1 and self.ExpiredTime > NowTime then
            self.ExpiredTime = self.ExpiredTime + self.RewardPeriod * CommonConst.DayTime
        else
            self.ExpiredTime = TimeUtils.NextDailyRefreshTime(NowTime) + (self.RewardPeriod - 1) * CommonConst.DayTime
            self:Reset()
        end
        self.State = 1
        self.Count = self.Count + 1
    end

    function DailyPack:Reset()
        self.RewardGot = {}
        self.Count = 0
        self.LoginDays = 1
    end

    function DailyPack:IsActive()
        return self.State == 1 and self.ExpiredTime > TimeUtils.NowTime()
    end

    function DailyPack:LoginAdd()
        self.LoginDays = self.LoginDays + 1
    end

    function DailyPack:SetRewardGot()
        self.RewardGot[self.LoginDays] = 1
        self.LastRefreshTime = TimeUtils.NowTime()
    end

    function DailyPack:GetRewardMailId()
        return self.RewardMailId
    end

    function DailyPack:SetRewardRecord(RewardId, NowTime)
        local Idx = CommonUtils.Size(self.RewardRecord) + 1
        self.RewardRecord[Idx] = {self.LoginDays, RewardId, NowTime}
    end

    function DailyPack:HasGetDailyReward()
        return TimeUtils.GetIntervalDay(self.LastRefreshTime, TimeUtils.NowTime()) < 1
    end

    function DailyPack:GetLoginRewardId()
        return self.Reward[1]
    end

    FormatProperties(DailyPack)

local DailyPackDict = Class("DailyPackDict", CustomTypes.CustomDict)
    DailyPackDict.KeyType = BaseTypes.Int
    DailyPackDict.ValueType = DailyPack

    function DailyPackDict:GetDailyPack(DailyPackId)
        return self[DailyPackId]
    end

    function DailyPackDict:GetNewDailyPack(DailyPackId)
        if not self[DailyPackId] then
            self[DailyPackId] = self:NewDailyPack(DailyPackId)
        end
        return self[DailyPackId]
    end

    function DailyPackDict:NewDailyPack(DailyPackId)
        return DailyPack(DailyPackId)
    end
return {
    DailyPackDict = DailyPackDict,
    DailyPack = DailyPack
}