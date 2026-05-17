local Component = {}
local BattleUtils = require "Utils.BattleUtils"
local MiscUtils = require "Utils.MiscUtils"

---@type BP_StaticCreateActor_C
function Component:ReceiveBeginPlay()
	self.Overridden.ReceiveBeginPlay(self)
	self:InitParam()
	self:AddStaticCreatorInfo()
end
function Component:InitParam()
	self.ChildWorldEids = {}
end

-- 移到c++了
-- function Component:SetCreatorInfo(Unit)
-- 	self:AddActorToChildEids(Unit)
-- 	self:SetUpParameters(Unit)
-- 	self:RemoveChildSerializedWorldRegionEid(Unit)
-- end

function Component:SetCreatorQuestId_Lua(QuestId)
	self.QuestId = QuestId
end

function Component:AddStaticCreatorInfo()
	-- 不区分CS，都构造MAP
	if self.StaticCreatorId == 0 then return end
	---@type BP_EMGameState_C
	local GameState = UE4.UGameplayStatics.GetGameState(self)
	if not GameState then
		return
	end
	-- 已迁移到C++，直接调用C++实现
	self:RealAddAddStaticCreatorInfo(GameState)
	if self.FlexibleActiveInactive:Length() ~= 0 then
		EventManager:AddEvent(EventID.TriggerFlexibleActive, self, self.TriggerFlexibleActiveStaticCreator)
		EventManager:AddEvent(EventID.ConditionComplete, self, self.TriggerFlexibleActiveStaticCreator)
		EventManager:AddEvent(EventID.OnDailyRefresh, self, self.TriggerFlexibleActiveStaticCreator)
	end
end

-- function Component:RealAddAddStaticCreatorInfo(GameState)
-- 	if self.PrivateEnable then 
-- 		local GameMode = UE4.UGameplayStatics.GetGameMode(self)
-- 		if GameMode and GameMode:IsInDungeon() and GameMode:GetLevelLoader() then
-- 			local LevelName = GameMode:GetActorLevelName(self)
-- 			GameState:SetPrivateEnableStaticCreatorInfo(LevelName, self)
-- 			return
-- 		end
-- 	end

-- 	local FlexibleRet, IsActive = self:TryGetFlexibleActiveResult()
-- 	GameState.StaticCreatorMap:Add(self.StaticCreatorId, self)
-- 	GameState.StaticCreatorStringNameMap:Add(self.DisplayName, self)
	
-- 	if FlexibleRet == false and self.AutoActive then
-- 		GameState.AutoActiveStaticIds:AddUnique(self.StaticCreatorId)
-- 	end
-- end

function Component:TryGetFlexibleActiveResult()
	if self.UnitType ~= "Npc" and self.RegionDataType ~= ERegionDataType.RDT_None then
		return false, nil
	end
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return false, nil
	end
	
	local TempFlexibleMap = {}
	-- local function MakeTempFlexibleMap() --构建倒序的Map
	-- 	local NewFlexibleMap = {}
	-- 	local FNpcArrayNum = self.FlexibleActiveInactive:Num()
	-- 	for FNpcActiveArray, IsActive in pairs(self.FlexibleActiveInactive) do
	-- 		local NewFlexibleMapElement = {}
	-- 		NewFlexibleMapElement.NpcActiveArray = FNpcActiveArray
	-- 		NewFlexibleMapElement.IsActive = IsActive
	-- 		NewFlexibleMap[FNpcArrayNum] = NewFlexibleMapElement
	-- 		FNpcArrayNum = FNpcArrayNum - 1
	-- 	end
	-- 	return NewFlexibleMap
	-- end
	local FNpcArrayNum = self.FlexibleActiveInactive:Num()
	for FNpcActiveArray, IsActive in pairs(self.FlexibleActiveInactive) do
		local NewFlexibleMapElement = {}
		NewFlexibleMapElement.NpcActiveArray = FNpcActiveArray
		NewFlexibleMapElement.IsActive = IsActive
		TempFlexibleMap[FNpcArrayNum] = NewFlexibleMapElement
		FNpcArrayNum = FNpcArrayNum - 1
	end
	if IsEmptyTable(TempFlexibleMap) then
		return false, nil
	end

	for i = 1, self.FlexibleActiveInactive:Num(), 1 do
		local IsActive = TempFlexibleMap[i].IsActive
		local TargetQuestId = TempFlexibleMap[i].NpcActiveArray.Quest.QuestId
		local TargetQuestState = TempFlexibleMap[i].NpcActiveArray.Quest.MyQuestState
		local TargetTalkTriggerId = TempFlexibleMap[i].NpcActiveArray.ImpressionTalk.TalkTriggerId
		local TalkState = TempFlexibleMap[i].NpcActiveArray.ImpressionTalk.TalkQuestState
		local FlexibleQuestChainId = TempFlexibleMap[i].NpcActiveArray.QuestChain.QuestChainId
		local FlexibleQuestChainState = TempFlexibleMap[i].NpcActiveArray.QuestChain.QuestChainState
		if TempFlexibleMap[i].NpcActiveArray.EditableStructType == 0 then --0任务类型
			local QuestChainId = tonumber(string.sub(TargetQuestId, 1, 6))--从子任务id里筛选六个字符的ChainId
			local QuestStateType = {
				Doing = 1,
				Success = 2,
			}
			if not Avatar.QuestChains[QuestChainId] then
				goto continue
			end
			local QuestChains = Avatar.QuestChains[QuestChainId]

			if TargetQuestState == QuestStateType.Doing and QuestChains.DoingQuestId == TargetQuestId then --任务在进行中
				return true, IsActive
			elseif TargetQuestState == QuestStateType.Success and QuestChains:CheckQuestIdComplete(TargetQuestId)then --任务已完成
				return true, IsActive
			else
				--其他类型暂不处理
			end
		elseif TempFlexibleMap[i].NpcActiveArray.EditableStructType == 1 then --1印象对话类型
			local TalkStateType = {
				Compelete = 0,
				UnCompelete = 1,
				CheckSuccess = 2,
				CheckFail = 3,
			}
			if TalkState == TalkStateType.Compelete then
				if Avatar:IsStorylineComplete(TargetTalkTriggerId)  then
					return true, IsActive
				end
			elseif TalkState == TalkStateType.UnCompelete then
				if Avatar:IsStorylineUnComplete(TargetTalkTriggerId) then
					return true, IsActive
				end
			elseif TalkState == TalkStateType.CheckSuccess then
				if Avatar:IsStorylineSuccess(TargetTalkTriggerId) then
					return true, IsActive
				end
			elseif TalkState == TalkStateType.CheckFail then
				if Avatar:IsStorylineFailure(TargetTalkTriggerId) then
					return true, IsActive
				end
			else
				--对话其他情况暂不处理
			end
		elseif TempFlexibleMap[i].NpcActiveArray.EditableStructType == 2 then --2任务链类型
			local QuestChainStateType = {
				Doing = 1,
				Success = 2,
			}
			if not Avatar.QuestChains[FlexibleQuestChainId] then
				goto continue
			end
			local TargetQuestChain = Avatar.QuestChains[FlexibleQuestChainId]

			if FlexibleQuestChainState == QuestChainStateType.Doing and Avatar:IsQuestChainDoing(FlexibleQuestChainId) then --任务在进行中
				return true, IsActive
			elseif FlexibleQuestChainState == QuestChainStateType.Success and Avatar:IsQuestChainFinished(FlexibleQuestChainId) then --任务已完成
				return true, IsActive
			else
				--其他类型暂不处理
			end
		elseif TempFlexibleMap[i].NpcActiveArray.EditableStructType == 3 then --3条件类型
			local ConditionUtils = require "BluePrints.Common.ConditionUtils"
			local TargetConditionId = TempFlexibleMap[i].NpcActiveArray.Condition.ConditionId
			local bShouldComplete = TempFlexibleMap[i].NpcActiveArray.Condition.bIsComplete
			
			local bConditionComplete = ConditionUtils.CheckCondition(Avatar, TargetConditionId)
			
			if bShouldComplete == bConditionComplete then
				return true, IsActive
			end
		end
		::continue::
	end

	return false, nil
end

function Component:OnRegionDataAllocated_Lua(LuaTableIndex)
	local GameMode = UGameplayStatics.GetGameMode(self)
    -- NewRegionEnable
	local RegionDataSubsys = GameMode:GetRegionDataMgrSubSystem()
	local Context = AEventMgr.CreateUnitContext()
	Context.Creator = self
	RegionDataSubsys:InitRegionDataTable(LuaTableIndex, Context)
end

-- 禁止lua调用
function Component:ActiveStaticCreator_Lua(EventName)
	if EventName ~= nil and EventName ~= "" then
		self:RealActiveStaticCreator({EventName = EventName})
	else
		self:RealActiveStaticCreator({})
	end
end

function Component:RealActiveStaticCreator(ExtraInfo, bForceSync)
	-- Lua调用统一接口
	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	local Avatar = GWorld:GetAvatar()
	if not IsValid(GameMode) then return end
	local Context = AEventMgr.CreateUnitContext()
	Context.UnitType = self.UnitType
	Context.UnitId = self.UnitId
	Context.Loc = self:K2_GetActorLocation()
	Context.Rotation = self:K2_GetActorRotation()
	Context.Creator =  self
	Context.BoolParams:Add("IsFullRegionStore", self.IsFullRegionStore)
	Context.NameParams:Add("WorldRegionEid", self.LastWorldRegionEid)
	if ExtraInfo ~= nil then
		if ExtraInfo.EventName then
			Context.StrParams:Add("EventName", ExtraInfo.EventName)
		end
		if ExtraInfo.DungeonState then
			Context:AddLuaTable("DungeonState", ExtraInfo.DungeonState)
		end
		Context:AddLuaTable("ExtraInfo", ExtraInfo)
	end
	if not self.IsFullRegionStore and self:IsActorNeedFullRegionStore(self.UnitType, self.UnitId) then
		GWorld.logger.error("需要勾选全区域存储的Actor没有勾选 " .."UnitType = ".. Context.UnitType .. "; UnitId = " .. Context.UnitId .. 
		"; StaticCreatorId = " .. self.StaticCreatorId .. "; Map = " .. self:GetWorld():GetName())
	end
	self:FillCreateUnitContext(Context, ExtraInfo)
	DebugPrint("RealActiveStaticCreator UnitType", self.UnitType, "UnitId", self.UnitId, "CreatorId", self.StaticCreatorId)
	if self.bSyncCreateMonsterOnActive and Context.UnitType == "Monster" then
		GameMode.EMGameState.EventMgr:CreateUnitNew(Context, true)
	elseif Context.UnitType == "Mechanism" then
		local Data = DataMgr.Mechanism[self.UnitId]
		if Data and (Data.UnitRealType == "AOITriggerBox" or Data.UnitRealType == "AOITriggerSphere") then
			GameMode.EMGameState.EventMgr:CreateUnitNew(Context, false)
		else
			GameMode.EMGameState.EventMgr:CreateUnitNew(Context, bForceSync)
		end
	else
		GameMode.EMGameState.EventMgr:CreateUnitNew(Context, bForceSync)
	end

end

function Component:FillCreateUnitContext(Context, ExtraInfo)
	Context.IntParams:Add("Level", self:GetUnitLevel())
	Context:AddObjectParams("BTObject", self.BornChangeBT)

	if self.UnitType == "Phantom" then
		-- 目前依赖ExtraInfo是否为空来区分 stl激活魅影+区域恢复魅影 或 副本玩法激活魅影
		-- 有点微妙，但也合理————stl激活魅影就不应该传ExtraInfo，否则将会面临stl激活和区域恢复两头改代码的问题
		-- 本来想整合一下把BattleUtils.GetExtraCreateInfo都统一放在这里做（考虑通过传Source来区分，但暂时没啥必要，先不改了
		if ExtraInfo then
			if ExtraInfo.Camp then
				Context.NameParams:Add("Camp", ExtraInfo.Camp)
			end
			if ExtraInfo.PhantomOwnerEid then
				Context.IntParams:Add("PhantomOwnerEid", ExtraInfo.PhantomOwnerEid)
			end
			if ExtraInfo.FixLocation then
				Context.BoolParams:Add("FixLocation", ExtraInfo.FixLocation)
			end
			if ExtraInfo.FixLocationZ then
				Context.IntParams:Add("FixLocationZ", ExtraInfo.FixLocationZ)
			end
		else
			local RoleId = self.UnitId
			if self.QuestRoleId ~= -1 then
				local AvatarInfo, PhantomId = BattleUtils.GetQuestRoleCreateInfo("Phantom", self.QuestRoleId)
				Context:AddLuaTable("AvatarInfo", AvatarInfo)
				Context.UnitId = PhantomId or RoleId
				RoleId = PhantomId or RoleId
			end
			ExtraInfo = BattleUtils.GetExtraCreateInfo("Phantom", self.UnitId, RoleId)
			local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
			Context.NameParams:Add("Camp", "Player")
			Context.IntParams:Add("PhantomOwnerEid", Player.Eid)
			Context.BoolParams:Add("FixLocation", true)
			Context.IntParams:Add("FixLocationZ", 0)
		end
		Context.IntParams:Add("AvatarQuestRoleID", -1)
		if ExtraInfo.IsHostage then
			Context.BoolParams:Add("IsHostage", ExtraInfo.IsHostage)
		end
		if ExtraInfo.BTIndex then
			Context.IntParams:Add("BTIndex", ExtraInfo.BTIndex - 1)	
		end
	end
end

function Component:IsActorNeedFullRegionStore(UnitType, UnitId)
	if DataMgr[UnitType] and DataMgr[UnitType][UnitId] then
		local UnitRealType = DataMgr[UnitType][UnitId].UnitRealType
		return UnitRealType == "TeleportMechanism"
	end
end

function Component:DestoryOneStaticActor(DeathReason, DestroyReason)
	return self:DestoryOneStaticActor_Lua(DeathReason, DestroyReason)
end

function Component:DestoryOneStaticActor_Lua(DeathReason, DestroyReason)
	local Avatar = GWorld:GetAvatar()
	DeathReason = DeathReason or EDeathReason.Disable

	local NeedUpdateRegionData = false
	local Eids = self.ChildEids:ToTable()
	for _, Eid in pairs(Eids) do
		local Info = Battle(self):GetEntity(Eid)
		if IsValid(Info) then
			DebugPrint("DestoryOneStaticActor ", Info:GetName(), Info.Eid, Info.UnitType, EDestroyReason:GetNameByValue(DestroyReason), EDeathReason:GetNameByValue(DeathReason))
			if Info.IsAIControlled and Info:IsAIControlled() then
				if DeathReason ~= EDeathReason.Disable then
					Battle(self):BattleOnDead(Info.Eid, Info.Eid, 0, DeathReason)
				else
					Info:EMActorDestroy(DestroyReason)
				end
			else
				Info:EMActorDestroy(DestroyReason)
			end
			return
		else
			NeedUpdateRegionData = true
		end
	end
	-- if not URuntimeCommonFunctionLibrary.UseCppRegionData(self) then
	-- 	local WorldRegionEids = self.ChildSerializedWorldRegionEids:ToTable()
	-- 	for _, WorldRegionEid in ipairs(WorldRegionEids) do
	-- 		local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	-- 		-- todo @fanyuxiao 目前只考虑STL会走到这里, 根据之后的策划需求, 可能需要调整ClientCache和Server
	-- 		GameMode:GetRegionDataMgrSubSystem().DataLibrary:RemoveRegionSSDataByWorldRegionEid(WorldRegionEid)
	-- 	end
	-- 	self.ChildSerializedWorldRegionEids:Clear()
	
	-- 	if NeedUpdateRegionData then
	-- 		local Avatar = GWorld:GetAvatar()
	-- 		if Avatar then
	-- 			Avatar:RegionActorDataDeadByCreatorId(self.StaticCreatorId)
	-- 		end
	-- 	end
	-- else
		-- local Avatar = GWorld:GetAvatar()
		-- if Avatar then
		-- 	Avatar:RegionActorDataDeadByCreatorId(self.StaticCreatorId)
		-- end
		-- self:DestroyRegionDataByCreator()
	if (NeedUpdateRegionData or (#Eids == 0 and self.CreatedWorldRegionEid)) and URuntimeCommonFunctionLibrary.UseCppRegionData(self) then
		local RegionDataMgr = UE4.UGameplayStatics.GetGameMode(self):GetRegionDataMgrSubSystem()
		-- RegionDataMgr:DestroyRegionSSData(self.CreatedWorldRegionEid, DestroyReason)--只有任务会需要SSData，但是任务不能直接改切片数据，所以先不管
		RegionDataMgr:DestroyRegionEntity(self.CreatedWorldRegionEid, DestroyReason)
	end
end

function Component:DestoryOneStaticActorAll(DeathReason, DestroyReason)
	return self:DestoryOneStaticActor_Lua(DeathReason, DestroyReason)
end

-- 销毁由该静态点刷新的所有Actor（上面那个接口之后销毁其中一个）
-- 目前策划暂没有区域数据相关的需求
function Component:DestoryOneStaticActorAll_Lua(DeathReason, DestroyReason)
	local Avatar = GWorld:GetAvatar()
	DeathReason = DeathReason or EDeathReason.Disable

	local Eids = self.ChildEids:ToTable()
	for _, Eid in pairs(Eids) do
		local Info = Battle(self):GetEntity(Eid)
		if IsValid(Info) then
			DebugPrint("DestoryOneStaticActorAll ", Info:GetName(), Info.Eid, Info.UnitType, EDestroyReason:GetNameByValue(DestroyReason), EDeathReason:GetNameByValue(DeathReason))
			if Info.IsAIControlled and Info:IsAIControlled() then
				if DeathReason ~= EDeathReason.Disable then
					Battle(self):BattleOnDead(Info.Eid, Info.Eid, 0, DeathReason)
				else
					Info:EMActorDestroy(DestroyReason)
				end
			else
				Info:EMActorDestroy(DestroyReason)
			end
		end
	end
end

-- 销毁由该静态点刷新的所有Actor或序列化数据
-- 仅允许副本 且子GameMode使用
function Component:DestoryOneStaticActorWithData_Lua(LevelName, DeathReason, DestroyReason)
	DeathReason = DeathReason or EDeathReason.Disable

	local Eids = self.ChildEids:ToTable()
	for _, Eid in pairs(Eids) do
		local Info = Battle(self):GetEntity(Eid)
		if IsValid(Info) then
			DebugPrint("DestoryOneStaticActorWithData  CreatorId", self.StaticCreatorId, " By Actor", Info:GetName(), Info.Eid, Info.UnitType, EDestroyReason:GetNameByValue(DestroyReason), EDeathReason:GetNameByValue(DeathReason))
			if DeathReason ~= EDeathReason.Disable then
				Battle(self):BattleOnDead(Info.Eid, Info.Eid, 0, DeathReason)
			else
				Info:EMActorDestroy(DestroyReason)
			end
		else
			DebugPrint("DestoryOneStaticActorWithData  CreatorId", self.StaticCreatorId, " By SnapShotData", LevelName, Eid)
			MiscUtils.GameMode(self):RemoveSnapShot(LevelName, Eid)
		end
	end
end


-- 删除所有由这个Creator创建的数据 包括Actor, 序列化数据, 本地服务器数据缓存 -- 注意探索组数据由服务器直接进行管理, 这里不需要操作
function Component:RegionDestroyAllExploreGroupData(bNormalDead, DeathReason, DestroyReason, DeleteClientRegionData)
	local Eids = self.ChildEids:ToTable()
	for _, Eid in pairs(Eids) do
		local Info = Battle(self):GetEntity(Eid)
		if IsValid(Info) then
			if Info.IsAIControlled and Info:IsAIControlled() then
				if bNormalDead then
					Battle(self):BattleOnDead(Info.Eid, Info.Eid, 0, DeathReason)
				else
					Info:EMActorDestroy(DestroyReason)
				end
			else
				Info:EMActorDestroy(DestroyReason)
			end
		end
	end

	if DeleteClientRegionData then
		self:ResetRarelyStaticCreatorClient()
	end

	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	GameMode:GetRegionDataMgrSubSystem():DestroyRegionEntity(self.CreatedWorldRegionEid, DestroyReason)
	GameMode:GetRegionDataMgrSubSystem():RemoveCretorIdContollerByCacheNew(self.StaticCreatorId)
	GameMode.EMGameState.EventMgr:RemoveUnitInQueue(self.CreatedWorldRegionEid, DestroyReason)
end

function Component:IsAOITriggerBox()
	if not DataMgr[self.UnitType] or not DataMgr[self.UnitType][self.UnitId] then
		return false
	end
	local RealUnitType = DataMgr[self.UnitType][self.UnitId].UnitRealType
	return RealUnitType == "AOITriggerBox" or RealUnitType == "AOITriggerSphere" or RealUnitType == "AOITriggerSpecialQuest"
	or RealUnitType == "AOITriggerCapsule"
end

function Component:GetUnitLevel()
	return self:GetUnitLevel_Lua()
end

function Component:GetUnitLevel_Lua()
	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	if self.LevelAdaptDisable and GameMode:IsInRegion() then
		return math.max(1, self.Level)
	else
		local MonsterCurLevel = self.Level + GameMode:GetFixedGamemodeLevel()
		if GameMode:IsEndlessDungeon()then
			local MonsterMaxLevel = DataMgr.GlobalConstant.MonsterLevelUpperLimit.ConstantValue
			return math.min(MonsterMaxLevel, MonsterCurLevel)
		elseif GameMode.EMGameState.GameModeType == "Abyss" then
			local MonsterMaxLevel = DataMgr.GlobalConstant.AbyssMonsterLevelLimit.ConstantValue
			return math.min(MonsterMaxLevel, MonsterCurLevel)
		else
			return MonsterCurLevel
		end
	end
end

function Component:SetNpcShowHide(QuestId)
	return self:SetNpcShowHide_Lua(QuestId)
end

function Component:SetNpcShowHideByFlexible_Lua(Unit)
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end
	local TempFlexibleMap = {}
	-- local function MakeTempFlexibleMap() --构建倒序的Map
	-- 	local NewFlexibleMap = {}
	-- 	local FNpcArrayNum = self.FlexibleShowHide:Num()
	-- 	for FNpcArray, IsHide in pairs(self.FlexibleShowHide) do
	-- 		local NewFlexibleMapElement = {
	-- 			NpcArray = {
	-- 				Quest = nil,
	-- 				ImpressionTalk = nil
	-- 			},
	-- 			IsHide = false
	-- 		}
	-- 		NewFlexibleMapElement.NpcArray = FNpcArray
	-- 		NewFlexibleMapElement.IsHide = IsHide
	-- 		NewFlexibleMap[FNpcArrayNum] = NewFlexibleMapElement
	-- 		FNpcArrayNum = FNpcArrayNum - 1
	-- 	end
	-- 	return NewFlexibleMap
	-- end
	-- TempFlexibleMap = MakeTempFlexibleMap()
	local FNpcArrayNum = self.FlexibleShowHide:Num()
	for FNpcArray, IsHide in pairs(self.FlexibleShowHide) do
		local NewFlexibleMapElement = {
			NpcArray = {
				Quest = nil,
				ImpressionTalk = nil
			},
			IsHide = false
		}
		NewFlexibleMapElement.NpcArray = FNpcArray
		NewFlexibleMapElement.IsHide = IsHide
		TempFlexibleMap[FNpcArrayNum] = NewFlexibleMapElement
		FNpcArrayNum = FNpcArrayNum - 1
	end

	local function SetNpcShowOrHide(IsShow)
		if IsShow then
			Unit:SetActorHideTag("Flexible", false)
			Unit:SetCollisionDisableTag("Flexible", false)
			-- Unit:SetTickEnabled(ETickCtrlType.DontNeedTick, ETickObjectFlag.FLAG_ACTOR, false)
		else
			Unit:SetActorHideTag("Flexible", true)
			Unit:SetCollisionDisableTag("Flexible", true)
			-- Unit:RemoveTickEnabledSet(ETickCtrlType.DontNeedTick, ETickObjectFlag.FLAG_ACTOR)
		end
	end

	for i = 1, self.FlexibleShowHide:Num(), 1 do
		local TargetQuestId = TempFlexibleMap[i].NpcArray.Quest.QuestId
		local TargetQuestState = TempFlexibleMap[i].NpcArray.Quest.MyQuestState
		local TargetTalkTriggerId = TempFlexibleMap[i].NpcArray.ImpressionTalk.TalkTriggerId
		local TalkState = TempFlexibleMap[i].NpcArray.ImpressionTalk.TalkQuestState
		local FlexibleQuestChainId = TempFlexibleMap[i].NpcArray.QuestChain.QuestChainId
		local FlexibleQuestChainState = TempFlexibleMap[i].NpcArray.QuestChain.QuestChainState
		if TempFlexibleMap[i].NpcArray.EditableStructType == 0 then --0任务类型
			local QuestChainId = tonumber(string.sub(TargetQuestId, 1, 6))--从子任务id里筛选六个字符的ChainId
			local QuestStateType = {
				Doing = 1,
				Success = 2,
			}
			if not Avatar.QuestChains[QuestChainId] then
				goto continue
			end
			local QuestChains = Avatar.QuestChains[QuestChainId]

			if TargetQuestState == QuestStateType.Doing and QuestChains.DoingQuestId == TargetQuestId then --任务在进行中
				SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
				return
			elseif TargetQuestState == QuestStateType.Success then --任务已完成
				if QuestChains:CheckQuestIdComplete(TargetQuestId) then
					SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
					return
				end
			else
				--其他类型暂不处理
			end
		elseif TempFlexibleMap[i].NpcArray.EditableStructType == 1 then --1印象对话类型

			local TalkStateType = {
				Compelete = 0,
				UnCompelete = 1,
				CheckSuccess = 2,
				CheckFail = 3,
			}
			if TalkState == TalkStateType.Compelete then
				if Avatar:IsStorylineComplete(TargetTalkTriggerId)  then
				SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
				return
				end
			elseif TalkState == TalkStateType.UnCompelete then
				if Avatar:IsStorylineUnComplete(TargetTalkTriggerId) then
				SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
				return
				end
			elseif TalkState == TalkStateType.CheckSuccess then
				if Avatar:IsStorylineSuccess(TargetTalkTriggerId) then
				SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
				return
				end
			elseif TalkState == TalkStateType.CheckFail then
				if Avatar:IsStorylineFailure(TargetTalkTriggerId) then
				SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
				return
				end
			else
				--对话其他情况暂不处理
			end
		elseif TempFlexibleMap[i].NpcArray.EditableStructType == 2 then --2任务链类型
			local QuestChainStateType = {
				Doing = 1,
				Success = 2,
			}
			if not Avatar.QuestChains[FlexibleQuestChainId] then
				goto continue
			end
			local TargetQuestChain = Avatar.QuestChains[FlexibleQuestChainId]

			if FlexibleQuestChainState == QuestChainStateType.Doing and TargetQuestChain:IsDoing() then --任务在进行中
				SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
				return
			elseif FlexibleQuestChainState == QuestChainStateType.Success and TargetQuestChain:IsFinish() then --任务已完成
				SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
				return
			else
				--其他类型暂不处理
			end
		end
		::continue::
	end

end
---@param FlexibType string @灵活显隐类型
---@param TargetId 
function Component:SetNpcFlexibShowOrHideDynamic_Lua(FlexibType, TargetId)
	if self.UnitType ~= "Npc" then
		return
	end
	local function SetNpcShowOrHide(IsShow)
		for i = 1, self.ChildEids:Length() do
			local Unit = Battle(self):GetEntity(self.ChildEids:GetRef(i))
			if Unit then
				if IsShow then
					Unit:SetActorHideTag("Flexible", false)
					Unit:SetCollisionDisableTag("Flexible", false)
					-- Unit:SetTickEnabled(ETickCtrlType.DontNeedTick, ETickObjectFlag.FLAG_ACTOR, false)
				else
					Unit:SetActorHideTag("Flexible", true)
					Unit:SetCollisionDisableTag("Flexible", true)
					-- Unit:RemoveTickEnabledSet(ETickCtrlType.DontNeedTick, ETickObjectFlag.FLAG_ACTOR)
				end
			end
		end
		
	end

	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end

	local TempFlexibleMap = {}
	local FNpcArrayNum = self.FlexibleShowHide:Num()
	for FNpcArray, IsHide in pairs(self.FlexibleShowHide) do
		local NewFlexibleMapElement = {
			NpcArray = {
				Quest = nil,
				ImpressionTalk = nil
			},
			IsHide = false
		}
		NewFlexibleMapElement.NpcArray = FNpcArray
		NewFlexibleMapElement.IsHide = IsHide
		TempFlexibleMap[FNpcArrayNum] = NewFlexibleMapElement
		FNpcArrayNum = FNpcArrayNum - 1
	end

	for i = 1, self.FlexibleShowHide:Num(), 1 do
		local TargetQuestId = TempFlexibleMap[i].NpcArray.Quest.QuestId
		local TargetQuestState = TempFlexibleMap[i].NpcArray.Quest.MyQuestState
		local TargetTalkTriggerId = TempFlexibleMap[i].NpcArray.ImpressionTalk.TalkTriggerId
		local TalkState = TempFlexibleMap[i].NpcArray.ImpressionTalk.TalkQuestState
		local FlexibleQuestChainId = TempFlexibleMap[i].NpcArray.QuestChain.QuestChainId
		local FlexibleQuestChainState = TempFlexibleMap[i].NpcArray.QuestChain.QuestChainState
		if TempFlexibleMap[i].NpcArray.EditableStructType == 0 then --0任务类型
			local QuestChainId = tonumber(string.sub(TargetQuestId, 1, 6))--从子任务id里筛选六个字符的ChainId
			local QuestStateType = {
				Doing = 1,
				Success = 2,
			}
			if not Avatar.QuestChains[QuestChainId] then
				goto continue
			end
			local QuestChains = Avatar.QuestChains[QuestChainId]

			if TargetQuestState == QuestStateType.Doing and QuestChains.DoingQuestId == TargetQuestId then --任务在进行中
				SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
				return
			elseif TargetQuestState == QuestStateType.Success then --任务已完成
				if QuestChains:CheckQuestIdComplete(TargetQuestId) then
					SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
					return
				end
			else
				--其他类型暂不处理
			end
		elseif TempFlexibleMap[i].NpcArray.EditableStructType == 1 then --1印象对话类型

			local TalkStateType = {
				Compelete = 0,
				UnCompelete = 1,
				CheckSuccess = 2,
				CheckFail = 3,
			}
			if TalkState == TalkStateType.Compelete then
				if Avatar:IsStorylineComplete(TargetTalkTriggerId)  then
				SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
				return
				end
			elseif TalkState == TalkStateType.UnCompelete then
				if Avatar:IsStorylineUnComplete(TargetTalkTriggerId) then
				SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
				return
				end
			elseif TalkState == TalkStateType.CheckSuccess then
				if Avatar:IsStorylineSuccess(TargetTalkTriggerId) then
				SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
				return
				end
			elseif TalkState == TalkStateType.CheckFail then
				if Avatar:IsStorylineFailure(TargetTalkTriggerId) then
				SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
				return
				end
			else
				--对话其他情况暂不处理
			end
		elseif TempFlexibleMap[i].NpcArray.EditableStructType == 2 then --2任务链类型
			local QuestChainStateType = {
				Doing = 1,
				Success = 2,
			}
			if not Avatar.QuestChains[FlexibleQuestChainId] then
				goto continue
			end
			local TargetQuestChain = Avatar.QuestChains[FlexibleQuestChainId]

			if FlexibleQuestChainState == QuestChainStateType.Doing and TargetQuestChain:IsDoing() then --任务在进行中
				SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
				return
			elseif FlexibleQuestChainState == QuestChainStateType.Success and TargetQuestChain:IsFinish() then --任务已完成
				SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
				return
			else
				--其他类型暂不处理
			end
		end
		::continue::
	end

end

function Component:SetNpcShowHide_Lua(QuestId)
	if self.UnitType ~= "Npc" then
		return
	end
	local QuestId =QuestId
	local ExistQuest=false
	local OldState = nil
    local Avatar = GWorld:GetAvatar()
	local Quest =Avatar:GetQuestById(QuestId)
	local IsDoing = Quest:IsDoing()
	for key,value in pairs(self.FlexibleShowHide) do
		if key.QuestId==QuestId and key.MyQuestState==1 and IsDoing then
			ExistQuest=true
			local state=value
			for i = 1, self.ChildEids:Length() do
				local Info = Battle(self):GetEntity(self.ChildEids:GetRef(i))
				if IsValid(Info) then
					if state == true then
						Info:K2_GetRootComponent():SetVisibility(true,true)
						Info.NpcTalkInteractiveComponent:GetNpcFlexibleShowHide("Show")
						return
					else
						Info:K2_GetRootComponent():SetVisibility(false,true)
						Info.NpcTalkInteractiveComponent:GetNpcFlexibleShowHide("Hide")
						return
					end
				end
			end
		end
	end
	if ExistQuest==false then
		for key,value in pairs(self.FlexibleShowHide) do
			local Quest =Avatar:GetQuestById(key.QuestId)
			local IsSuccess = Quest:IsSuccess()
			if key.MyQuestState==2 and IsSuccess then
				OldState = value
			end
		end
		if OldState ==nil then
			OldState = self.DefaultShowEnable
		else
			for i = 1, self.ChildEids:Length() do
				local Info = Battle(self):GetEntity(self.ChildEids:GetRef(i))
				if IsValid(Info) then
					if OldState then
						Info:K2_GetRootComponent():SetVisibility(true,true)
						Info.NpcTalkInteractiveComponent:GetNpcFlexibleShowHide("Show")
						return
					else
						Info:K2_GetRootComponent():SetVisibility(false,true)
						Info.NpcTalkInteractiveComponent:GetNpcFlexibleShowHide("Hide")
						return
					end
				end
			end
		end
	end
end

function Component:TriggerFlexibleActiveStaticCreator()
	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	if not GameMode then
		return
	end
	if not GameMode:IsInRegion() then
		return
	end
	local FlexibleRet, IsActive = self:TryGetFlexibleActiveResult()
	local GameState = UE4.UGameplayStatics.GetGameState(self)
   	-- if IsActive and GameState.NpcCharacterMap:FindRef(self.UnitId) ~= nil then
	-- 	return
	-- end

	if GameState and FlexibleRet == true then
		if GameState.FlexibleActiveStaticIds:Find(self.StaticCreatorId) and IsActive then
			return
		end

		if GameState.FlexibleActiveStaticIds:Find(self.StaticCreatorId) then
			GameState.FlexibleActiveStaticIds:Remove(self.StaticCreatorId)
			GameState.FlexibleActiveStaticIds:Add(self.StaticCreatorId, IsActive)
		else
			GameState.FlexibleActiveStaticIds:Add(self.StaticCreatorId, IsActive)
		end
	end


	if FlexibleRet and IsActive then
		local TempArray = TArray(0)
		TempArray:Add(self.StaticCreatorId)
		GameMode:TriggerActiveStaticCreator(TempArray, "FlexibleActiveInactive")
	elseif FlexibleRet and not IsActive then
		for _, NpcChar in pairs(GameState.NpcMap) do
			if NpcChar.UnitId == self.UnitId and NpcChar.CreatorId and NpcChar.CreatorId == self.StaticCreatorId then
				NpcChar:EMActorDestroy(EDestroyReason.Flexible)
			end
		end
	end
end

function Component:SetStaticActorsLoc(Loc, bSweep, SweepHitResult, bTeleport)
	return self:SetStaticActorsLoc_Lua(Loc, bSweep, SweepHitResult, bTeleport)
end

function Component:SetStaticActorsLoc_Lua(Loc, bSweep, SweepHitResult, bTeleport)
	for i = 1, self.ChildEids:Length() do
		local Info = Battle(self):GetEntity(self.ChildEids:GetRef(i))
		if IsValid(Info) then
			Info:K2_SetActorLocation(Loc, bSweep, SweepHitResult, bTeleport)
		end
	end
end

-- function Component:AddActorToChildEids(Unit)
-- 	self.ChildEids:AddUnique(Unit.Eid)
-- end

-- function Component:RemoveChildSerializedWorldRegionEid(Unit)
-- 	if Unit.WorldRegionEid then
-- 		self.ChildSerializedWorldRegionEids:Remove(Unit.WorldRegionEid)
-- 	end
-- end

function  Component:GetActorToChildEids()
	return self.ChildEids
end

function Component:AddSerializedEid(Eid)
	self:AddSerializedEid_Lua(Eid)
end

function Component:AddSerializedEid_Lua(Eid)
	self.ChildEids:AddUnique(Eid)
end

function Component:RemoveActorToChildEids(Eid)
	return self:RemoveActorToChildEids_Lua(Eid)
end	

function Component:RemoveActorToChildEids_Lua(Eid)
    self.ChildEids:RemoveItem(Eid)
end

function Component:SetUpParameters(Unit)
	if self.FlexibleShowHide:Length() ~= 0 then
		EventManager:AddEvent(EventID.SetNpcShowHide,self,self.SetNpcShowHide)
		EventManager:AddEvent(EventID.SetNpcFlexibShowOrHideDynamic, self, self.SetNpcFlexibShowOrHideDynamic_Lua)
	end

	if Const.IsOpenNpcInitOpt == false then
		if self.DefaultShowEnable == false and IsValid(Unit) then
			Unit:SetActorHideTag("Flexible", true)
			Unit:SetCollisionDisableTag("Flexible", true)
			-- Unit:SetTickEnabled(ETickCtrlType.DontNeedTick, ETickObjectFlag.FLAG_ACTOR, false)
		end
	end
	self:SetNpcShowHideByFlexible_Lua(Unit)
end

function Component:ReceiveEndPlay()
	EventManager:RemoveEvent(EventID.SetNpcShowHide,self)
	EventManager:RemoveEvent(EventID.SetNpcFlexibShowOrHideDynamic, self)
	EventManager:RemoveEvent(EventID.TriggerFlexibleActive, self)
	EventManager:RemoveEvent(EventID.ConditionComplete, self)
	EventManager:RemoveEvent(EventID.OnDailyRefresh, self)
	self:RemoveStaticCreatorInfo()
end

function Component:RemoveStaticCreatorInfo()
	if self.StaticCreatorId == 0 then return end

	local GameState = UE4.UGameplayStatics.GetGameState(self)
	if self.PrivateEnable then
		local GameMode = UE4.UGameplayStatics.GetGameMode(self)
		if GameMode:IsInDungeon() and GameMode:GetLevelLoader() then
			local LevelName = GameMode:GetActorLevelName(self)
			GameState:RemovePrivateEnableStaticCreatorInfo(LevelName, self)
			return
		end
	end
	GameState.StaticCreatorMap:Remove(self.StaticCreatorId)
	GameState.StaticCreatorStringNameMap:Remove(self.DisplayName)

	if self.AutoActive then
		GameState.AutoActiveStaticIds:Remove(self.StaticCreatorId)
	end
end

function Component:ResetRarelyStaticCreator(PrivateEnable, EventName)
	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	GameMode:GetRegionDataMgrSubSystem():ResetRarelyStaticCreator(self.StaticCreatorId, PrivateEnable, EventName)
end

function Component:ResetRarelyStaticCreatorClient()
	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	GameMode:GetRegionDataMgrSubSystem():ResetRarelyStaticCreatorClient(self.CreatedWorldRegionEid)
end

-- function Component:GetChildEids()
--     return self.ChildEids
-- end

function Component:PrintActorDebugInfo_Lua()
	local Eids = self.ChildEids:ToTable()
	local Battle = Battle(self)
	local GameMode =  UE4.UGameplayStatics.GetGameMode(self)
	if not Battle or not GameMode then
		return
	end
	GWorld.logger.debug("------ Print Creator Active Actor Debug Info --------")
	local WorldRegionEids = self.ChildSerializedWorldRegionEids:ToTable()
	for _, WorldRegionEid in ipairs(WorldRegionEids) do
		local SSData = GameMode:GetRegionDataMgrSubSystem().DataLibrary.WorldRegionEid2SSData[WorldRegionEid]

		-- if Entity then
		-- 	GWorld.logger.debug("Eid = " .. Eid .. " Find Entity! UnitType = " .. Entity.UnitType .. " UnitId = " .. Entity.UnitId 
		-- 	.. " Loc = " .. UKismetStringLibrary.Conv_VectorToString(Entity:K2_GetActorLocation()) .. " Name = " .. Entity:GetName() )
		-- end

		if SSData then
			-- GWorld.logger.debug("Eid = " .. Eid .. " Find In SSData! ")
			PrintTable(SSData)
		end
	end
	GWorld.logger.debug("------ Print Creator Active Actor Debug Info END--------")
end

function Component:GetDropNameByUnitType()
	if self.UnitType ~= "Drop" then
		error("UnitType is not Drop")
	end
	local Drop = DataMgr.Drop[self.UnitId]
	return GText(Drop.DropName)
end

function Component:CheckUnitIsDeadInRegion()
	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	if not GameMode:IsInRegion() then
		return false
	end
	if self.CreatedWorldRegionEid == "None" and self.ChildSerializedWorldRegionEids:Num() == 0 then
		return false
	end
	local WorldRegionEid = self.CreatedWorldRegionEid == "None" and self.ChildSerializedWorldRegionEids:Get(1) or self.CreatedWorldRegionEid
	if not WorldRegionEid or WorldRegionEid == "None" then
		return false
	end
	return GameMode:GetRegionDataMgrSubSystem():CheckUnitIsDeadByWorldRegionEid(WorldRegionEid)
end

return Component