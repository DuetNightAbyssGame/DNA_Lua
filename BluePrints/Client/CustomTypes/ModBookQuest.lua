local Class = _G.TypeClass
local BaseTypes = require "BluePrints.Client.CustomTypes.BaseTypes"
local CustomTypes = require "BluePrints.Client.CustomTypes.CustomTypes"
local prop = require "NetworkEngine.Common.Prop"
local FormatProperties = require "NetworkEngine.Common.Assemble".FormatProperties
-- CommonConst = require "CommonConst"

---@class ModBookQuest
local ModBookQuest = Class("ModBookQuest", CustomTypes.CustomAttr)
	---@type ModBookQuest 方便智能提示
	ModBookQuest.__Props__ = {
		--唯一ID
		UniqueID = prop.prop("Int", "client save"),
		-- 状态
		Status = prop.prop("Int", "client save", 0), -- 0:未解锁 1:已解锁

		-- 已完成目标
		FinishedTargets = prop.prop("Int2IntDict", "client save"),
		-- 目标完成的总次数
		Progress = prop.prop("Int", "client save", 0),
		-- 目标完成的时间
		FinishTime = prop.prop("Int", "client save"),
		
		--奖励领取状态
		RewardsGot = prop.prop("Bool", "client save", false),

		-- 不重复字段记录
		UniqueRecords = prop.prop("Str2IntDict", "client save"),


		-- 目标编号
		TargetIds = prop.getter("Data", "TargetId"),
		-- 目标需要完成次数
		TargetNeedCount = prop.getter("Data", "Target"),
		-- 目标完成的奖励
		TaskReward = prop.getter("Data", "TaskReward"),
		-- 解锁条件
		ConditionId = prop.getter("Data", "ConditionId"),
		-- 不重复字段
		NoRepeatField = prop.getter("Data", "NoRepeatField"),
		-- 目标不累加完成值
		CompletionValue = prop.getter("Data", "CompletionValue"),
		-- 所属阶段
		QuestPhaseId = prop.getter("Data", "QuestPhaseId"),
	}
	
	function ModBookQuest:Init(UniqueID)
        self.UniqueID = UniqueID
	end

	function ModBookQuest:Data()
		return DataMgr.ModGuideBookTask[self.UniqueID]
	end

	function ModBookQuest:IsLock()
		return self.Status == 0
	end

	function ModBookQuest:IsUnlock()
		return self.Status == 1
	end

	function ModBookQuest:Unlock()
		if not self:IsUnlock() then
			self.Status = 1
		end
	end

	function ModBookQuest:Reset()
		self.FinishedTargets = {}
		self.Progress = 0
		self.FinishTime = 0
		self.RewardsGot = false
		self.UniqueRecords = {}
	end

	function ModBookQuest:GetUniqueID()
		return self.UniqueID
	end

	function ModBookQuest:IsComplete()
		return self.Progress >= self.TargetNeedCount
	end

	-- 不累加规则
	function ModBookQuest:IndividualRule(TargetId, Count)
		-- 复杂规则字段 
		-- PS：单次伤害大于                  		2000
		--     Target.IndividualRule        	   CompletionValue
		local Target = DataMgr.Target[TargetId]
		local rule = Target.IndividualRule
		if rule and self.CompletionValue then
			if rule == "greater" and Count >= self.CompletionValue then
				return true
			elseif rule == "less" and Count <= self.CompletionValue then
				return true
			end
		end
		return false
	end

	function ModBookQuest:TargetRefreshProgress(TargetId, UniqueAttr, Count)
		if self:IsComplete() then
			return
		end
		if not CommonUtils.HasValue(self.TargetIds, TargetId) then
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
			if self.UniqueRecords[UniqueAttr] then
				return
			end
			self.UniqueRecords[UniqueAttr] = TimeUtils.NowTime()
		end

		for _, Tid in ipairs(self.TargetIds) do
			if Tid == TargetId then
				self.FinishedTargets:SetDefault(Tid, 0)
				self.FinishedTargets[Tid] = self.FinishedTargets[Tid] + Count
				break
			end
		end
		self.Progress = self.Progress + Count
		if self:IsComplete() then
			self.FinishTime = TimeUtils.NowTime()
		end
	end

	function ModBookQuest:CanRecvReward()
		return not self.RewardsGot
	end

	function ModBookQuest:HasRecvReward()
		return self.RewardsGot
	end

	function ModBookQuest:RecvReward()
		self.RewardsGot = true
	end

	function ModBookQuest:GetCurrentCount(ConditionId)
		return self.Progress
	end

	FormatProperties(ModBookQuest)

---@class ModBookQuestDict
local ModBookQuestDict = Class("ModBookQuestDict", CustomTypes.CustomDict)
	ModBookQuestDict.KeyType = BaseTypes.Int
	ModBookQuestDict.ValueType = ModBookQuest

	function ModBookQuestDict:NewModBookQuest(UniqueID)
		self[UniqueID] = ModBookQuest(UniqueID)
		return self[UniqueID]
	end

	function ModBookQuestDict:GetModBookQuest(UniqueID)
		if not self[UniqueID] then
			self[UniqueID] = ModBookQuest(UniqueID)
		end
		return self[UniqueID]
	end

return {
    ModBookQuest = ModBookQuest,
    ModBookQuestDict = ModBookQuestDict,
}
