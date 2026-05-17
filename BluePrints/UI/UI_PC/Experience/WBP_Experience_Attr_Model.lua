local SkillUtils = require "Utils.SkillUtils"
---@class ExperienceAttrModel
local ExperienceAttrModel = {}

function ExperienceAttrModel:GetAttrName2Info(BuffId, BuffLevel)
    local AddAttrs = {}
    if BuffId then
        local BuffInfo = DataMgr.Buff[BuffId]
        AddAttrs = BuffInfo.AddAttrs
    end

    local AttrName2Info = {}
    for _,AddAttr in ipairs(AddAttrs) do
        local AttrConfig = DataMgr.AttrConfig[AddAttr.AttrName]
        if not AttrConfig then goto continue end
        local Value, ValueStr = self:GenBuffAttrData(AddAttr, BuffLevel, AttrConfig, BuffId)
        -- local AttrText = GText(AttrConfig.Name)..ValueStr
        local AttrName = AddAttr.AttrName
        AttrName2Info[AttrName] = ValueStr
        ::continue::
    end

    return AttrName2Info
end

function ExperienceAttrModel:GenBuffAttrData(BuffAttrConf, BuffLevel, AttrConf, BuffId)
    local IsRate = BuffAttrConf.Rate~=nil
    local Value = self:CalcBuffAttrByLevel(BuffAttrConf, BuffLevel, nil, BuffId)
    local ValueStr = CommonUtils.AttrValueToString(AttrConf, Value, IsRate)
    --ValueStr = (Value>0 and "+" or "")..ValueStr
    return Value,ValueStr
end

function ExperienceAttrModel:CalcBuffAttrByLevel(BuffAttrConf, BuffLevel, ValueType, BuffId)
    local IsRate = (BuffAttrConf.Rate~=nil)
    local Base = IsRate and BuffAttrConf.Rate or BuffAttrConf.Value
    if (ValueType) then
		if string.lower(ValueType) == "rate" then
			Base = BuffAttrConf.Rate
            IsRate = true
		elseif string.lower(ValueType) == "value" then
			Base = BuffAttrConf.Value
            IsRate = false
		end
	end
	if type(Base) ~= "number" then
		local AttrData = SkillUtils.GrowProxy("Buff", BuffId, {
            GetSkillLevelInfo=function(self)
                return {SkillLevel = BuffLevel}
            end
        }, BuffAttrConf)
        local Value = tonumber(IsRate and AttrData.Rate or AttrData.Value)
        if not Value then
            DebugPrint(ErrorTag,string.format("BuffId: %s 的SkillGrow配置有问题，缺少等级%s的成长数值，请检查SkillGrow表",BuffId,BuffLevel))
            return 0
        end
        return Value
	end
    return Base + (BuffAttrConf.LevelGrow or 0) * BuffLevel
end

return ExperienceAttrModel