
local MechanismInfo = require "BluePrints.DungeonObject.DungeonComponent.MechanismInfo"

local MechanismDungeonLogic = DungeonClass.Class()

MechanismDungeonLogic.__Component__ = {
}

function MechanismDungeonLogic:BeginPlay()
	self.MechanismMap = {}
end

function MechanismDungeonLogic:EndPlay()
	self.MechanismMap = {}
end

function MechanismDungeonLogic:CreateMechanism(UnitId)
	local _MechanismInfo = MechanismInfo()
	_MechanismInfo.UnitId = UnitId
	_MechanismInfo.UniqueId = self:GenUniqueId()
	self.MechanismMap[_MechanismInfo.UniqueId] = _MechanismInfo
	if self["OnCreateMechanism"] then
		self:OnCreateMechanism(_MechanismInfo.UniqueId)
	end
	return _MechanismInfo
end

function MechanismDungeonLogic:DestroyMechanism(UniqueId)
	self.MechanismMap[UniqueId] = nil
end

function MechanismDungeonLogic:GetMechanism(UniqueId)
	return self.MechanismMap[UniqueId]
end

function MechanismDungeonLogic:OnNotifyServerDungeonEvent_MechanismStateChange(EventInfo)
	print("LXZ DungeonLogic OnNotifyServerDungeonEvent_MechanismStateChange")
	local _MechanismInfo = self:GetMechanism(EventInfo.UniqueId)
	--在这里校验是否允许切换状态，具体设计先看需求
	self:NotifyGameModeDungeonEvent("MechanismStateChange", EventInfo)
end

function MechanismDungeonLogic:NotifyGameModeMechanismState(EventInfo)
	print("LXZ DungeonLogic NotifyGameModeMechanismState")
	self:NotifyGameModeDungeonEvent("MechanismStateChange", EventInfo)
end

function MechanismDungeonLogic:OnNotifyServerDungeonEvent_MechanismGiveReward(EventInfo)
	-- 处理奖励相关
	self:DungeonRewardEvent(EventInfo)
	self:NotifyGameModeDungeonEvent("MechanismGiveReward", EventInfo)
	return bGiveRewardSuccess
end

DungeonClass.AssembleComponents(MechanismDungeonLogic)
return MechanismDungeonLogic