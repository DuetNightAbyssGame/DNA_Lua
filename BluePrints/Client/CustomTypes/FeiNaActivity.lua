local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties

local FeiNa = Class("FeiNa", CustomTypes.CustomAttr)
    FeiNa.__Props__ = {
        -- Id(菲娜活动ID)
        FeiNaId = prop.prop("Int", "client save"),
        -- 当前进度值
        CurrentProgress = prop.prop("Int", "client save"),
        -- 本关最高积分
        MaxProgress = prop.prop("Int", "client save"),
        -- 领奖信息{[score] = 1,表示已领取}
        RewardsGot = prop.prop("Int2IntDict", "client save"), --- 0 代表未完成  1 代表 完成 2 代表已经取
        StartTime = prop.getter("Data", "StartTime"),
        Reward = prop.getter("Data", "Reward"),
        Level = prop.getter("Data", "Level"),
    }

    function FeiNa:Init(FeiNaId)
		self.FeiNaId = FeiNaId
        self:InitRewardsGot()
	end

    function FeiNa:InitRewardsGot()
        for Index, _ in ipairs( self.Level ) do
            if not self.RewardsGot[Index] then
                self.RewardsGot[Index] = CommonConst.FeiNaState.Doing
            end
        end
    end

    function FeiNa:SetProgrssRewardsGot(Index, NewState)
        self.RewardsGot[Index] = NewState
    end

    function FeiNa:SetRewardStateByProgress(NewProgress)
        for Index, Progress in ipairs( self.Level ) do
            if Progress <= NewProgress then
                if self:IsDoing(Index) then
                    self:SetProgrssRewardsGot(Index, CommonConst.FeiNaState.Complete)
                end
            end
        end
    end

    function FeiNa:SetCurrentProgress(NewProgress)
        if NewProgress <= 0 then return end
        self.CurrentProgress = NewProgress
        self:SetRewardStateByProgress(NewProgress)
        self:SetMaxProgress(NewProgress)
    end

    function FeiNa:IsComplete(Index)
        if self.RewardsGot[Index] == nil then return false end
        return CommonConst.FeiNaState.Complete == self.RewardsGot[Index]
    end
    function FeiNa:IsDoing(Index)
        if self.RewardsGot[Index] == nil then return false end
        return CommonConst.FeiNaState.Doing == self.RewardsGot[Index]
    end

    function FeiNa:GetCurrentProgress()
        return self.CurrentProgress
    end

    function FeiNa:Data()
		return DataMgr.FeinaEventDungeon[self.FeiNaId]
	end

    function FeiNa:GetMaxProgress()
        return self.MaxProgress
    end

    function FeiNa:GetCurrentProgressReward(Index)
        if self.RewardsGot[Index] == nil then return false end
        return self.RewardsGot[Index]
    end

    function FeiNa:SetMaxProgress(MaxProgress)
        if MaxProgress > self.MaxProgress then
            self.MaxProgress = MaxProgress
        end
    end

	FormatProperties(FeiNa)

local FeiNaDict = Class("FeiNaDict", CustomTypes.CustomDict)
    FeiNaDict.KeyType = BaseTypes.Int
    FeiNaDict.ValueType = FeiNa

    function FeiNaDict:GetFeiNa(FeiNaId)
        return self[FeiNaId]
    end

    function FeiNaDict:NewFeiNa(FeiNaId)
        return FeiNa(FeiNaId)
    end

    function FeiNaDict:GetNewFeiNa(FeiNaId)
        if not self:GetFeiNa(FeiNaId) then
            self[FeiNaId] = self:NewFeiNa(FeiNaId)
        end
        return self[FeiNaId]
    end

return {
    FeiNa = FeiNa,
    FeiNaDict = FeiNaDict,
}