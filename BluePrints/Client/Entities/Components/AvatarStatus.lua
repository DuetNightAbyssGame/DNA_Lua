
local Component = {}

function Component:OnAvatarStatusUpdate(AvatarStatus)
	local OldStatus = self.AvatarStatus or {}
	self.AvatarStatus = AvatarStatus
	print(_G.LogTag, "AvatarStatus Update")
	PrintTable(AvatarStatus, 1,LXYTag.."新的AvatarStatus")
	PrintTable(OldStatus, 1,LXYTag.."旧的AvatarStatus")
	EventManager:FireEvent(EventID.OnAvatarStatusUpdate, OldStatus, AvatarStatus)
	self:PrintAvatarStatus()
end

function Component:PrintAvatarStatus()
	local PrintStr = "CurrentAvatarStatus: "
	for StatusId, Status in pairs(self.AvatarStatus) do
		if Status then
			PrintStr = PrintStr .. DataMgr.AvatarStatus[StatusId].StatusName..","
		end
	end
	print(_G.LogTag, PrintStr)
end

function Component:GetCurrentMaxPriority(InputAvatarStatus)
	if not InputAvatarStatus then
		InputAvatarStatus = self.AvatarStatus
	end

	local MaxPriority = 0
	for StatusId, Status in pairs(InputAvatarStatus) do
		if Status then
			MaxPriority = math.max(MaxPriority, DataMgr.AvatarStatus[StatusId].Priority)
		end
	end

	return MaxPriority
end

function Component:CheckCanSetStatus(InputAvatarStatus, status)
	if not InputAvatarStatus then
		InputAvatarStatus = self.AvatarStatus
	end

	local MaxPriority = self:GetCurrentMaxPriority(InputAvatarStatus)
	for StatusId, Status in pairs(InputAvatarStatus) do
		if Status then
			if DataMgr.AvatarStatus[StatusId].Priority == MaxPriority and not DataMgr.AvatarStatusMachine.TurningMap[StatusId][status] then
				DebugPrint(LXYTag, WarningTag, "无法转换到预定状态，因为 "..DataMgr.AvatarStatus[StatusId].StatusName.." 的turningMap中没有 "..DataMgr.AvatarStatus[status].StatusName)
				return false
			end
		end
	end

	return true
end

-- 这个接口仅用于通知服务器，客户端**期望**状态发生某个改变，但不能保证能改变成功，以服务端逻辑处理为准
-- e.g. 客户端切换场景从进入XXX的状态切换到处于XX中的状态
function Component:NotifyServerStatusModify(AvatarStatus)
	print(_G.LogTag, "ClientSetStatus", DataMgr.AvatarStatus[AvatarStatus].StatusName)
	self:CallServerMethod("ClientSetStatus", AvatarStatus)
end

function Component:AvatarStatusEnterSuccess()
	self:CallServerMethod("AvatarStatusEnterSuccess")
end

function Component:InStatus(InputStatus, status)
	InputStatus = InputStatus or self.AvatarStatus
	return InputStatus[status]
end

-- 是否在副本中（广义副本，指单机副本，联机副本，以及肉鸽玩法）
function Component:IsInDungeon(InPutStatus)
	return self:IsInSingleDungeon(InPutStatus) or self:IsInMultiDungeon(InPutStatus) or self:IsInRougeLike(InPutStatus)
end

-- 是否在狭义副本中（单机/联机 拼接本）
function Component:IsInNarrowDungeon(InPutStatus)
	return self:IsInSingleDungeon(InPutStatus) or self:IsInMultiDungeon(InPutStatus)
end

-- 是否在副本中或即将进入副本
function Component:IsInDungeon2(InPutStatus)
	return self:IsInDungeon(InPutStatus) or self:IsInEnterDungeon(InPutStatus)
end

function Component:IsInSingleDungeon(InPutStatus)
	return self:InStatus(InPutStatus, CommonConst.AvatarStatus.InSingleDungeon)
end

function Component:IsInMultiDungeon(InPutStatus)
	return self:InStatus(InPutStatus, CommonConst.AvatarStatus.InMultiDungeon)
end

function Component:IsInEnterSingleDungeon(InPutStatus)
	return self:InStatus(InPutStatus, CommonConst.AvatarStatus.EnterSingleDungeon)
end

function Component:IsInEnterMultiDungeon(InPutStatus)
	return self:InStatus(InPutStatus, CommonConst.AvatarStatus.EnterMultiDungeon)
end

function Component:InExploreChanllenge(InPutStatus)
	return self:InStatus(InPutStatus, CommonConst.AvatarStatus.InExploreChanllenge)
end


-- 是否正在进入广义副本
function Component:IsInEnterDungeon(InPutStatus)
	return self:IsInEnterSingleDungeon(InPutStatus) or self:IsInEnterMultiDungeon(InPutStatus) or self:IsInEnterRougeLike(InPutStatus)
end

function Component:IsInEnterBigWorld(InPutStatus)
	return self:InStatus(InPutStatus, CommonConst.AvatarStatus.EnterBigWorld)
end

-- 服务器在Loading结束后才会进入这个状态，在这个状态之前不要往服务器发数据
function Component:IsRealInBigWorld(InPutStatus)
	return self:InStatus(InPutStatus, CommonConst.AvatarStatus.InBigWorld)
end

-- 服务器在区域准备阶段，或者已经准备结束进入区域。客户端可用于是否在区域的判断
function Component:IsInBigWorld(InPutStatus)
	return self:IsInEnterBigWorld(InPutStatus) or (not self:IsInEnterDungeon(InPutStatus) and self:IsRealInBigWorld(InPutStatus))
end

function Component:IsInHardBoss(InPutStatus)
	if self:InStatus(InPutStatus, CommonConst.AvatarStatus.InHardBoss) then
		return true
	end

	if self:IsInMultiDungeon(InPutStatus) then
		local DungeonType = WorldTravelSubsystem():GetCurrentDungeonType()
		if DungeonType == CommonConst.DungeonType.HardBossDg then
			return true
		end
	end

	return false
end

function Component:IsInEnterRougeLike(InPutStatus)
	return self:InStatus(InPutStatus, CommonConst.AvatarStatus.EnterRougeLike)
end

function Component:IsInRougeLike(InPutStatus)
	return self:InStatus(InPutStatus, CommonConst.AvatarStatus.InRougeLike)
end

function Component:IsInDynamicEvent(InPutStatus)
	return self:InStatus(InPutStatus, CommonConst.AvatarStatus.DynamicEvent)
end

function Component:IsInTeam(InPutStatus)
	return self:InStatus(InPutStatus, CommonConst.AvatarStatus.InTeam)
end

function Component:IsInSpecialQuest(InPutStatus)
	return self:InStatus(InPutStatus, CommonConst.AvatarStatus.InSpecialQuest)
end

return Component
