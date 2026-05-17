require "UnLua"

local BP_RegionHijackComponent_C = Class()

--------------------GameMode 流程&事件相关------------------------
function BP_RegionHijackComponent_C:InitRegionHijackComponent()
	DebugPrint("RegionHijackComponent: Init!")
	-- 初始化基础信息 + 路径信息
	self.GameMode = self:GetOwner()
	self.GameMode.EMGameState.NowPathId = 1
	self.GameMode.EMGameState.NextPathId = 1

	self.Checkpoint = 0
	--self.CheckpointMonsterNum = CommonUtils.Copy(DataMgr.Hijack[GWorld.GameInstance:GetCurrentDungeonId()].CheckpointMonsterNum)
	self.CheckpointMonsterNum = {10, 20}	-- 每个检查点需要击杀怪物的数量，先临时写死
end

function BP_RegionHijackComponent_C:ClearRegionHijackComponent()
	self.GameMode.EMGameState.StopTrollyBoxLocation:Clear()
end

function BP_RegionHijackComponent_C:GetNextPathInfos(NowPathId)
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

function BP_RegionHijackComponent_C:SetCheckpoint(Checkpoint)
	self.Checkpoint = Checkpoint
end

function BP_RegionHijackComponent_C:CheckPointMonsterDead(Monster)
	if Monster.CreatorId ~= 0
		and Monster.CreatorType == "MonsterSpawn"
		and Monster:GetCamp() == ECampName.Monster
		and self.Checkpoint ~= 0 then
		self.CheckpointMonsterNum[self.Checkpoint] = self.CheckpointMonsterNum[self.Checkpoint] - 1
		if self.CheckpointMonsterNum[self.Checkpoint] <= 0 then
			local Ret = self.Checkpoint
			self.Checkpoint = 0
			return Ret
		end
	end
	return 0
end
-----------------------------------------------------------------



return BP_RegionHijackComponent_C
