
local MonsterInfo = require "BluePrints.DungeonObject.DungeonComponent.MonsterInfo"

local MonsterDungeonLogic = DungeonClass.Class()

MonsterDungeonLogic.__Component__ = {
}

function MonsterDungeonLogic:BeginPlay()
	self.MonsterMap = {}
end

function MonsterDungeonLogic:EndPlay()
	self.MonsterMap = {}
end

function MonsterDungeonLogic:CreateMonster(UnitId, CreatorType, CreatorId)
	local _MonsterInfo = MonsterInfo()
	_MonsterInfo.UnitId = UnitId
	_MonsterInfo.UniqueId = self:GenUniqueId()
	_MonsterInfo.CreatorType = CreatorType
	_MonsterInfo.CreatorId = CreatorId
	self.MonsterMap[_MonsterInfo.UniqueId] = _MonsterInfo
	return _MonsterInfo
end

function MonsterDungeonLogic:DestroyMonster(UniqueId)
	local Monster = self:GetMonster(UniqueId)
	if not Monster then
		return
	end

	-- 触发计数和奖励
	self.MonsterMap[UniqueId] = nil
end

function MonsterDungeonLogic:GetMonster(UniqueId)
	return self.MonsterMap[UniqueId]
end


function MonsterDungeonLogic:OnNotifyServerDungeonEvent_MonsterDead(MonsterInfo)
	-- todo 增加死亡参数
	if not MonsterInfo.UnitId or not MonsterInfo.UniqueId then
		return
	end

	local _MonsterInfo = self.MonsterMap[MonsterInfo.UniqueId]
	if not _MonsterInfo then
		return
	end

	if _MonsterInfo.UnitId ~= MonsterInfo.UnitId then
		return
	end
	-- 处理逻辑相关
	self:DungeonMonsterDead(MonsterInfo)
	-- 处理奖励相关
	self:DungeonRewardEvent(MonsterInfo)
	self:DestroyMonster(MonsterInfo.UniqueId)
	MonsterInfo.Res = true
	self:NotifyGameModeDungeonEvent("MonsterDead", MonsterInfo)
end



DungeonClass.AssembleComponents(MonsterDungeonLogic)
return MonsterDungeonLogic