local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties
local TimeUtils
if GWorld:IsSkynetServer() then
	TimeUtils = require "src.utils.TimeUtils"
else
	TimeUtils = require "Utils.TimeUtils"
end


local Buff = Class("Buff", CustomTypes.CustomAttr)
    Buff.__Props__ = {
        BuffId = prop.prop("Int", "client save cross"),
        --Buff开始时间
        StartTime = prop.prop("Int", "client save cross"),
        --Buff持续时间,-1表示无限期
        Duration = prop.prop("Int", "client save cross"),
        --Buff等级
        Level = prop.prop("Int", "client save cross"),
        --是否是历练等级buff，历练等级buff唯一
        IsPlayerLevelBuff = prop.prop("Bool", "save",false)
    }
    function Buff:Init(BuffId)
        self.BuffId = BuffId
        self:RefreshBuffStartTime()
    end

    function Buff:RefreshBuffStartTime(Time)
        self.StartTime = Time or TimeUtils.NowTime()
    end

    function Buff:SetBuffDuration(Duration)
        if Duration == CommonConst.AvatarBuffPermanent or Duration > 0 then
            self.Duration = Duration
        end
    end

    function Buff:GetBuffRemainingTime()
        return math.max((self.StartTime + self.Duration) -  TimeUtils.NowTime(),0)
    end

    function Buff:CheckBuffIsDue()
        if self.Duration == CommonConst.AvatarBuffPermanent then
            return false
        end
        return (self.StartTime + self.Duration) < TimeUtils.NowTime()
    end

    function Buff:CheckBuffIsPermanent()
        if self.Duration == CommonConst.AvatarBuffPermanent then
            return true
        end
        return false
    end

    function Buff:SetBuffLevel(Level)
        if Level and Level >= 0 then
            self.Level = Level
        end
    end

    function Buff:GetBuffLevel()
        return self.Level or 1
    end

    function Buff:SetIsPlayerLevelBuff(bPlayerLevel)
        self.IsPlayerLevelBuff = bPlayerLevel
    end

    function Buff:CheckIsPlayerLevelBuff()
        return self.IsPlayerLevelBuff
    end

    FormatProperties(Buff)

local BuffDict = Class("BuffDict", CustomTypes.CustomDict)
    BuffDict.KeyType = BaseTypes.Int
    BuffDict.ValueType = Buff
    function BuffDict:NewBuff(BuffId)
        return Buff(BuffId)
    end
    function BuffDict:GetBuff(BuffId)
        if not self[BuffId] then
            return self:NewBuff(BuffId)
        end
        return self[BuffId]
    end

local Effect = Class("Effect", CustomTypes.CustomAttr)
    Effect.__Props__ = {
        EffectId = prop.prop("Int", "client save cross"),
    }
    function Effect:Init(EffectId)
        self.EffectId = EffectId
    end

    FormatProperties(Effect)

local EffectDict = Class("EffectDict", CustomTypes.CustomDict)
    EffectDict.KeyType = BaseTypes.Int
    EffectDict.ValueType = Effect
    function EffectDict:NewEffect(EffectId)
        return Effect(EffectId)
    end
    function EffectDict:GetEffect(EffectId)
        if not self[EffectId] then
            return self:NewEffect(EffectId)
        end
        return self[EffectId]
    end

return {
    Buff = Buff,
    BuffDict = BuffDict,
    Effect = Effect,
    EffectDict = EffectDict
}