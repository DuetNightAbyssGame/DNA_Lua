--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

local Component = {}

function Component:Initialize()
	--{FirstSeenTag, {MechanismRef}
	self.MechanismNeedCheck = {}
	-- self.NextMonsterPanel = {}
	self.MechanismFirstSeenEnabled = true
end

function Component:TryRegisterFirstSeeMehcanism(UnitId, Eid)
    if not DataMgr.Mechanism[UnitId] then
		return
	end
	local FirstSeenTag = DataMgr.Mechanism[UnitId]["FirstSeenTag"]
	if FirstSeenTag == nil then
		return
	end

	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end
	local IsFirstMechanism = Avatar:CheckFirstMechanism(UnitId, false)
	if not IsFirstMechanism and not self.MechanismNeedCheck[FirstSeenTag] then
		return
	end

	local Mechanism = Battle(self):GetEntity(Eid)
	if not Mechanism.FirstSeen then
		print(_G.LogTag,"Error: 机关没有用于初次遇到功能的碰撞体", Mechanism:GetName(), Mechanism.UnitId)
		return
	end
	if self.MechanismNeedCheck[FirstSeenTag] then
		self.MechanismNeedCheck[FirstSeenTag][Mechanism] = 1
	else
		self.MechanismNeedCheck[FirstSeenTag] = {}
		self.MechanismNeedCheck[FirstSeenTag][Mechanism] = 1
	end
	if not self:IsExistTimer("CheckMechanismFirstSeen") then
		self:AddTimer(0.2, self.CheckFirstSeeMehcanism, true, 0, "CheckMechanismFirstSeen")
	end
end

function Component:CheckFirstSeeMehcanism()
	if not self.MechanismFirstSeenEnabled then
		return
	end
	for Tag, MechanismRef in pairs(self.MechanismNeedCheck) do
		for Mechanism, RefNum in pairs(MechanismRef) do
			local NeedBreak = self:RealCheckFirstSeeMehcanism(Tag, MechanismRef, Mechanism, RefNum)
			if NeedBreak then
				break
			end
		end
	end
end

function Component:RealCheckFirstSeeMehcanism(FirstSeenTag, MechanismRef, Mechanism, RefNum)
	if not IsValid(Mechanism) then
		MechanismRef[Mechanism] = nil
		return false
	end

	local bShouldShow = URuntimeCommonFunctionLibrary.WasComponentRecentlyRenderedOnScreen(Mechanism.FirstSeen, 0.2)
	if not bShouldShow then
		MechanismRef[Mechanism]  = 1
		return false
	end
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
	local Distance = Mechanism:GetActorDistance(Player, Mechanism)
	local NeedDis = DataMgr.GlobalConstant.MechanismFirstSeenDistance.ConstantValue
	-- local NeedDis = 1000
	if Distance > NeedDis then
		MechanismRef[Mechanism]  = 1
		return false
	end
	MechanismRef[Mechanism] = MechanismRef[Mechanism] + 1
	if MechanismRef[Mechanism] > 2 then
		self.MechanismNeedCheck[FirstSeenTag] = nil
		self:OnMechanismFirstSeen(FirstSeenTag)
		self:TryRemoveTimer()
	end
	return true
end

function Component:OnMechanismFirstSeen(FirstSeenTag)
	local Avatar = GWorld:GetAvatar()
	local IsFirstSeen = Avatar:CheckFirstMechanism(FirstSeenTag, true)
	if IsFirstSeen then
		EventManager:FireEvent(EventID.FirstSeenTag, FirstSeenTag)
	end
end

function Component:TryRemoveTimer()
	for _, _ in pairs(self.MechanismNeedCheck) do
		return
	end
	self:RemoveTimer("CheckMechanismFirstSeen")
end

return Component