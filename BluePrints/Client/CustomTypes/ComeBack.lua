local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties

local ComeBack = Class("ComeBack", CustomTypes.CustomAttr)
ComeBack.__Props__ = {
        -- 活动id
        EventId = prop.prop("Int", "client save"),
        -- 方案id
        EventSchemeId = prop.prop("Int", "client save"),
        -- 签到天数
        LoginDay = prop.prop("Int", "client save", 0),
        -- 上次登录刷新时间
        LastLoginRefresh = prop.prop("Int", "client save", 0),
        -- 回归奖励领取状态
        BackRewardGot = prop.prop("Int", "client save", 0),
	    -- 任务进度奖励领取{[Idx] = 1}
	    ProgressRewardGot = prop.prop("Int2IntDict", "client save"),
        -- 签到奖励领取{[ld] = 1}
	    LoginRewardGot = prop.prop("Int2IntDict", "client save"),
        -- 当前任务进度
        QuestProgress = prop.prop("Int", "client save", 0),
    }

    function ComeBack:Init(EventId, EventSchemeId)
        self.EventId = EventId
        self.EventSchemeId = EventSchemeId
    end

    function ComeBack:HasLoginRefreshToday()
        return TimeUtils.GetIntervalDay(self.LastLoginRefresh, TimeUtils.NowTime()) < 1
    end

    function ComeBack:LoginAdd()
        self.LoginDay = self.LoginDay + 1
        self.LastLoginRefresh = TimeUtils.NowTime()
    end

    function ComeBack:HasGotLoginReward(LoginDay)
        return self.LoginRewardGot[LoginDay] == 1
    end

    function ComeBack:SetLoginRewardGot(LoginDay)
        self.LoginRewardGot[LoginDay] = 1
    end

    function ComeBack:HasGotBackReward()
        return self.BackRewardGot == 1
    end

    function ComeBack:SetBackRewardGot()
        self.BackRewardGot = 1
    end

    function ComeBack:HasGotProgressReward(RewardIdx)
        return self.ProgressRewardGot[RewardIdx] == 1
    end

    function ComeBack:SetProgressRewardGot(RewardIdx)
        self.ProgressRewardGot[RewardIdx] = 1
    end

    function ComeBack:AddQuestProgress(ProgressAdd)
        self.QuestProgress = self.QuestProgress + ProgressAdd
        return self.QuestProgress
    end

    FormatProperties(ComeBack)

local ComeBackDict = Class("ComeBackDict", CustomTypes.CustomDict)
    ComeBackDict.KeyType = BaseTypes.Int
    ComeBackDict.ValueType = ComeBack

    function ComeBackDict:GetComeBack(EventId)
        return self[EventId]
    end

    function ComeBackDict:NewComeBack(EventId, EventSchemeId)
        return ComeBack(EventId, EventSchemeId)
    end

    function ComeBackDict:GetNewComeBack(EventId, EventSchemeId)
        if not self[EventId] then
            self[EventId] = self:NewComeBack(EventId, EventSchemeId)
        end

        return self[EventId]
    end

return {
    ComeBack = ComeBack,
    ComeBackDict = ComeBackDict,
}