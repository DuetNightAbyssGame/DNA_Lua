local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties

---@class Achv
local Achv = Class("Achv", CustomTypes.CustomAttr)
	Achv.__Props__ = {
		-- 成就id
		AchvId = prop.prop("Int", "client save"),
		-- 已完成目标
		FinishedTargets = prop.prop("Int2IntDict", "client save"),
		-- 是否已领取奖励
		IsBonus = prop.prop("Bool", "client save", false),
		-- 成就达成时间
		Time = prop.prop("Int", "client save"),
		-- 不重复字段记录
		UniqueRecords = prop.prop("StrList", "client save"),
		-- 显示进度索引
		ProgressIndex = prop.prop("Int", "client save", 0 ),

		-- 目标编号
		TargetId = prop.getter("Data", "TargetId"),
		-- 不重复字段
		NoRepeatField = prop.getter("Data", "NoRepeatField"),
		-- 目标需要完成次数
		TargetNeedCount = prop.getter("Data", "TargetProgress"),
		-- 奖励
		AchvRewardId = prop.getter("Data", "AchievementReward"),
		-- 前置成就
		BeforeAchvs = prop.getter("Data", "AchievementRequire"),
		AchievementName = prop.getter("Data", "AchievementName"),
		AchievementDescribe = prop.getter("Data", "AchievementDescribe"),
		TargetProgressRenew = prop.getter("Data", "TargetProgressRenew"),

		-- 当前不累加值
		CurrentValue = prop.prop("Int", "client save"),
		-- 目标不累加完成值
		CompletionValue = prop.getter("Data", "CompletionValue"),
	}

	function Achv:Init(AchvId)
		if not AchvId then
			return
		end
		self.AchvId = AchvId
	end

	function Achv:Data()
		return DataMgr.Achievement[self.AchvId]
	end

	function Achv:GetCount()
		local result = 0
		for _, Tid in ipairs(self.TargetId) do
			result = result + (self.FinishedTargets[Tid] or 0)
		end
		return result
	end

	function Achv:IsIndividual()
		local individualRule=false
		for _,Tid in ipairs(self.TargetId) do
			if DataMgr.Target[Tid] and DataMgr.Target[Tid].IndividualRule then
				individualRule=true
				break
			end
		end
		return self.CompletionValue and individualRule
	end

	function Achv:GetProgressIndex()
		local OldIndex = self.ProgressIndex
		local Count = self:GetCount()
		if self:IsFinished() then
			local index = 0
			if self.TargetProgressRenew then
				index = #self.TargetProgressRenew
			end
			if self.ProgressIndex ~= index + 1 then
				self.ProgressIndex = index + 1
			end
			return OldIndex, self.ProgressIndex, self.TargetNeedCount
		end
		local CurrentCount = 0
		if not self.TargetProgressRenew then
			return OldIndex, OldIndex, CurrentCount
		end
		for index, value in ipairs(self.TargetProgressRenew) do
			if Count >= value and self.ProgressIndex < index then
				self.ProgressIndex = index
				CurrentCount = value
			end
		end
		return OldIndex, self.ProgressIndex, CurrentCount
	end

	function Achv:IsFinished()
		return self:GetCount() >= self.TargetNeedCount or not self:CanRecvReward()
	end

	function Achv:OnTargetFinish(Target, UniqueAttr, FinishedCount)
		local TargetId = Target.TargetId
		local rule = Target.IndividualRule
		if self.CompletionValue and rule then
			if rule == "greater" and self.CurrentValue >= self.CompletionValue then
				self.FinishedTargets[TargetId] = 1
			elseif rule == "less" and self.CurrentValue <= self.CompletionValue then
				self.FinishedTargets[TargetId] = 1
			end
			self.FinishedTargets = self.FinishedTargets
			if self:IsFinished() then
				self.Time = math.ceil(TimeUtils.NowTime())
				return true
			end
			return false
		end
		if self.NoRepeatField then
			if not UniqueAttr then
				return false
			end
			UniqueAttr = tostring(UniqueAttr)
			if self.UniqueRecords:HasValue(UniqueAttr) then
				return false
			end
			-- if CommonUtils.HasValue(self.UniqueRecords, UniqueAttr) then
			-- 	return false
			-- end
			FinishedCount = 1
			-- table.insert(self.UniqueRecords, UniqueAttr)
			self.UniqueRecords:Append(UniqueAttr)
			self.UniqueRecords = self.UniqueRecords
		end
		for _, Tid in ipairs(self.TargetId) do
			if Tid == TargetId then
				self.FinishedTargets:SetDefault(Tid, 0)
				self.FinishedTargets[Tid] = self.FinishedTargets[Tid] + FinishedCount
				self.FinishedTargets = self.FinishedTargets
				if self:IsFinished() then
					self.Time = math.ceil(TimeUtils.NowTime())
					return true
				end
				return false
			end
		end
		return false
	end

	function Achv:UpdateCurrentValue(value)
		if type(value) ~= 'number' or value <= 0 then
			return
		end
		self.CurrentValue = value
	end

	function Achv:CanRecvReward()
		return not self.IsBonus
	end

	function Achv:Reset()
		self.FinishedTargets = {}
		self.IsBonus = false
		self.Time = 0
		self.UniqueRecords:Clear()
		self.ProgressIndex = 0
		self.CurrentValue = 0
	end

	FormatProperties(Achv)

---@class AchvDict
local AchvDict = Class("AchvDict", CustomTypes.CustomDict)
	AchvDict.KeyType = BaseTypes.Int
	AchvDict.ValueType = Achv

	---@return Achv
	function AchvDict:NewAchv(AchvId)
		local achv = Achv(AchvId)
		return achv
	end

	---@return Achv
	function AchvDict:GetAchv(AchvId)
		local achv = self[AchvId]
		if not achv then
			achv = self:NewAchv(AchvId)
			-- self:AddValue(AchvId , achv)
			self[AchvId] = achv
		end
		return achv
	end

	function AchvDict:IsAchvLocked(AchvId)
		local achv= self:GetAchv(AchvId)
		if not achv.BeforeAchvs then
			return false
		end
		for _,preId in pairs(achv.BeforeAchvs) do 
			local achievePre= self:GetAchv(preId)
			if achievePre and not achievePre:IsFinished() or self:IsAchvLocked(preId) then
				return true
            end
		end
		return false
	end

	function AchvDict:IsAchvCanGetReward(AchvId)
		local Achv = self[AchvId]
		if Achv then
			return Achv:IsFinished() and Achv:CanRecvReward() and not self:IsAchvLocked(AchvId)
		end
		return false
	end

---@class AchvTarget
local AchvTarget = Class("AchvTarget", CustomTypes.CustomAttr)
	AchvTarget.__Props__ = {
		-- 目标id
		TargetId = prop.prop("Int", "client save cross"),
		-- 进度
		Count = prop.prop("Int", "client save"),
		-- 当前不累加值
		CurrentValue = prop.prop("Int", "client save cross", -1),
		-- 不累加规则
		IndividualRule = prop.getter("Data", "IndividualRule")
	}

	function AchvTarget:Init(TargetId)
		if not TargetId then
			return
		end
		self.TargetId = TargetId
	end

	function AchvTarget:Data()
		return DataMgr.Target[self.TargetId]
	end

	function AchvTarget:AddCount(count)
		if type(count) ~= "number" or count <= 0 then
			return false
		end

		if self.IndividualRule then
			if self.CurrentValue == -1 then
				self.CurrentValue = count
				return
			end
			if self.IndividualRule == "greater" and count > self.CurrentValue then
				self.CurrentValue = count
			elseif self.IndividualRule == "less" and count < self.CurrentValue then
				self.CurrentValue = count
			end
		else
			self.Count = self.Count + count
		end
		return true
	end

	FormatProperties(AchvTarget)


---@class AchvTargetDict
local AchvTargetDict = Class("AchvTargetDict", CustomTypes.CustomDict)
	AchvTargetDict.KeyType = BaseTypes.Int
	AchvTargetDict.ValueType = AchvTarget

	function AchvTargetDict:NewAchvTarget(TargetId)
		return AchvTarget(TargetId)
	end

	function AchvTargetDict:GetAchvTarget(TargetId)
		local target = self[TargetId]
		if not target then
			target = self:NewAchvTarget(TargetId)
			self[TargetId] = target
		end
		return target
	end


return {
	Achv = Achv,
	AchvDict = AchvDict,
	AchvTarget = AchvTarget,
	AchvTargetDict = AchvTargetDict,
}