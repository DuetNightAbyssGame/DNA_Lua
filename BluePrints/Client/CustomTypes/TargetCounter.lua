local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties

-- local logger = skynet.error or DebugPrint

---@class TargetCounter
local TargetCounter = Class("TargetCounter", CustomTypes.CustomAttr)
	---@type TargetCounter 方便智能提示
	TargetCounter.__Props__ = {
		--唯一ID
		UniqueID = prop.prop("Int", "client save"),

		-- 目标ids，完成任意目标都会累加进度，导表数据
		TargetIds = prop.prop("Int2IntDict", "client save", {}),
		-- 目标需要完成次数，导表数据
		Target = prop.prop("Int", "client save",0),
		-- 目标完成的次数
		Progress = prop.prop("Int", "client save",0),
		-- 目标完成的时间
		FinishTime = prop.prop("Int", "client save"),
		
		--奖励领取状态
		RewardsGot = prop.prop("Bool", "client save",false),

		-- 目标不累加完成值，导表数据
		CompletionValue = prop.prop("Int", "client save"),

		-- 不重复字段，导表数据
		NoRepeatField = prop.prop("Str", "save"),
		-- 不重复字段记录
		TargetRecords = prop.prop("Str2IntDict", "client save"),
	}
	function TargetCounter:Reset()
		self.Progress = 0
		self.RewardsGot = false
		self.TargetRecords = {}
		self:FixByAvatarData()
	end
	function TargetCounter:Init(UniqueID,ExcelConf)
        self.UniqueID = UniqueID
		for _,TargetId in pairs(ExcelConf.TargetId) do
			self.TargetIds[TargetId] = 0
		end
		self.Target = ExcelConf.Target
		self.CompletionValue = ExcelConf.CompletionValue
		self.NoRepeatField = ExcelConf.NoRepeatField

		self:FixByAvatarData()
	end

	function TargetCounter:GetUniqueID()
		return self.UniqueID
	end

	function TargetCounter:IsComplete()
		return self.Progress >= self.Target
	end

	--不累加规则
	function TargetCounter:IndividualRule(TargetId, Count)
		-- 复杂规则字段 
		-- PS：单次伤害大于                  		2000
		--     Target.IndividualRule        	CompletionValue
		local Target = DataMgr.Target[TargetId]
		if not Target then
			DebugPrint("TargetCounter:IndividualRule TargetId not exist", TargetId)
			return false
		end
		
		local rule = Target.IndividualRule
		if rule == "greater" and Count >= self.CompletionValue then
			return true
		elseif rule == "less" and Count <= self.CompletionValue then
			return true
		end
		return false
	end
	function TargetCounter:TargetRefreshProgress(TargetId, UniqueAttr, Count)
		if self:IsComplete() then
			return
		end
		if not self.TargetIds[TargetId] then
			return
		end

		if self.CompletionValue and self:IndividualRule(TargetId, Count) then
			Count = 1
		end

		if self.NoRepeatField and self.NoRepeatField ~= "" then
			UniqueAttr = tostring(UniqueAttr)
			if not UniqueAttr then
				return
			end
			if self.TargetRecords[UniqueAttr] then
				return
			end
			self.TargetRecords[UniqueAttr] = TimeUtils.NowTime()
		end
		self.Progress = math.min(self.Progress + Count, self.Target)
	end

	function TargetCounter:CanRecvReward()
		return not self.RewardsGot
	end
	function TargetCounter:GetCurrentCount(ConditionId)
		return self.Progress
	end

	-- 举例：每日登录这种Target，触发之后才初始化的Target，已经错过了触发。需要进行修正
	-- 		Avatar等级这种Target，登录时根据当前等级进行修正
	function TargetCounter:FixByAvatarData()
		local Avatar = GWorld:GetAvatar()
		if not Avatar then
			DebugPrint("TargetCounter:FixByAvatarData Avatar not exist")
			return
		end
		for TargetId,_ in pairs(self.TargetIds) do
			local TargetExcel = DataMgr.Target[TargetId]
			if TargetExcel and TargetExcel.TargetType == CommonConst.TargetTypeAvatarLevel then
				if Avatar.Level >= tonumber(TargetExcel.TargetParam[1][1]) then
					DebugPrint("TargetTypeAvatarLevel Auto Complete Success <TargetId>",TargetId)
					self:TargetRefreshProgress(TargetId, nil, 1)
					break
				end
			end
			if TargetExcel and TargetExcel.TargetType == CommonConst.TargetTypeLoginDay then
				local obj = TimeUtils.TimestampToDataObj(TimeUtils.TimestampLastClock(5)) -- 5点为一天的分界点
				local Date = string.format("%d%d%d",obj.year,obj.month,obj.day)
				self.NoRepeatField = "Date" -- 必然是按日期不重复
				DebugPrint("TargetTypeLoginDay Auto Complete Success <TargetId>",TargetId,Date)
				self:TargetRefreshProgress(TargetId, Date, 1)
				break
			end
		end
	end
	FormatProperties(TargetCounter)

---@class TargetCounterDict
local TargetCounterDict = Class("TargetCounterDict", CustomTypes.CustomDict)
	TargetCounterDict.KeyType = BaseTypes.Int
	TargetCounterDict.ValueType = TargetCounter

	function TargetCounterDict:NewTargetCounter(UniqueID,ExcelConf)
		self[UniqueID] = TargetCounter(UniqueID,ExcelConf)
		return self[UniqueID]
	end

return {
    TargetCounter = TargetCounter,
    TargetCounterDict = TargetCounterDict,
}
