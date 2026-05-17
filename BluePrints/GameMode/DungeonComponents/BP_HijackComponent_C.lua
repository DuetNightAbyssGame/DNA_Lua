require "UnLua"

local BP_HijackComponent_C = Class()
--------------------GameMode 流程&事件相关------------------------
function BP_HijackComponent_C:InitHijackComponent()
	-- 初始化基础信息 + 路径信息
	self.GameMode = self:GetOwner()
	self.GameMode.EMGameState.NowPathId = 1
	self.GameMode.EMGameState.NextPathId = 1

	self.HijackInfo = DataMgr.Hijack[self.GameMode.DungeonId]
	if not self.HijackInfo then
		GameState(self):ShowDungeonError("HijackComponent:当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id："..self.GameMode.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
		return
	end

	self.Checkpoint = 0
	self.CurCheckpointMonNum = -1
	self.CurCheckpointEliteMonNum = -1
end

function BP_HijackComponent_C:InitHijackBaseInfo()
end

function BP_HijackComponent_C:GetNextPathInfos(NowPathId)
	local EMGameState = self.GameMode.EMGameState
	if EMGameState.NowPathId ~= NowPathId then 
		return nil
	end
	if not EMGameState.HijackPathInfo then 
		return nil
	end
	if not EMGameState.HijackPathInfo[NowPathId] then 
		return nil
	end
	local NewNowPathId = EMGameState.RaplacePathMap:Find(EMGameState.NextPathId) or EMGameState.NextPathId
	if NewNowPathId and NewNowPathId ~= 0 and EMGameState.HijackPathInfo[NewNowPathId] then
		local NewPathInfos = EMGameState.HijackPathInfo[NewNowPathId]
		local NewNextPathId = nil
		if NewPathInfos[#NewPathInfos] then
			NewNextPathId = NewPathInfos[#NewPathInfos].NextPathId
		end
		EMGameState.NowPathId = NewNowPathId
		EMGameState.NextPathId = NewNextPathId
		return EMGameState.HijackPathInfo[NewNowPathId]
	end
	return nil
end

function BP_HijackComponent_C:SetCheckpoint(Checkpoint)
	self.Checkpoint = Checkpoint
	self.CurCheckpointMonNum = self.HijackInfo.CheckpointMonsterNum[self.Checkpoint]
	self.CurCheckpointEliteMonNum = self.HijackInfo.CheckpointEilteMonsterNum[self.Checkpoint]
end

function BP_HijackComponent_C:CheckPointMonsterDead(Monster)
	if self.Checkpoint == 0 then
		return 0
	end

	if Monster:GetCamp() == ECampName.Monster then
		if self.CurCheckpointMonNum ~= -1 then
			self.CurCheckpointMonNum = self.CurCheckpointMonNum - 1
			if self.CurCheckpointMonNum == 0 then
				local Ret = self.Checkpoint
				self.Checkpoint = 0
				return Ret
			end
		end

		if self.CurCheckpointEliteMonNum ~= -1 and Monster:IsEliteMonster() then
			self.CurCheckpointEliteMonNum = self.CurCheckpointEliteMonNum - 1
			if self.CurCheckpointEliteMonNum == 0 then
				local Ret = self.Checkpoint
				self.Checkpoint = 0
				return Ret
			end
		end
	end
	return 0
end

function BP_HijackComponent_C:RemoveHijackTriggerBox(PathId, PathPointIndex)
	local EMGameState = self.GameMode.EMGameState
	if EMGameState.HijackPathInfo[PathId] == nil then
		GameState(self):ShowDungeonError("HijackComponent:在删除路径上触发盒数据错误，PathId不存在 PathId: " .. PathId .."   PathPointIndex: " .. PathPointIndex, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
		return
	end

	if EMGameState.HijackPathInfo[PathId][PathPointIndex] == nil then
		GameState(self):ShowDungeonError("HijackComponent:在删除路径上触发盒数据错误，PathPointIndex不存在 PathId: " .. PathId .."   PathPointIndex: " .. PathPointIndex, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
		return
	end

	local TargetPoint = EMGameState.HijackPathInfo[PathId][PathPointIndex]
	TargetPoint:DestroyTriggerBox(EDestroyReason.UnitLabel)
end
-----------------------------------------------------------------

return BP_HijackComponent_C