require "UnLua"
local EffectResults = require "BluePrints.Combat.BattleLogic.EffectResults"

local M = Class({
    "BluePrints.Common.TimerMgr",
})

function M:NewNpcInitComponent_TriggerSTLPostStaticCreatorEvent(Mode, Actor)
    Mode:TriggerSTLEvent("STLPostStaticCreatorEvent", Actor)
end

function M:NewNpcInitComponent_PreInit_Lua(Owner, UnitType, UnitId)
	Owner.Data = DataMgr[UnitType][UnitId]

	if not Owner.BornInfo then
       Owner.BornInfo = EffectResults.Result()
    end
end

function M:NewNpcInitComponent_CacheBornInfo(Owner)
    if not Owner.BornInfo then
        Owner.BornInfo = EffectResults.Result()
    end
end

function M:NewNpcInitComponent_GetData(Owner, UnitType, UnitId)
    Owner.Data = DataMgr[UnitType][UnitId]
end

 function M:NewNpcInitComponent_GetDataInfo(Owner)
     Owner.BattleCharInfo = nil
     local RoleId = Owner.CurrentRoleId
     if not RoleId or RoleId == 0 then
         return
     end
     Owner.BattleCharInfo = DataMgr.BattleMonster[RoleId]
 end

function M:NewNpcInitComponent_PrepareWaitInitTags_Lua(Owner)
    if Owner:IsNeedHideInTalk() then
        EventManager:AddEvent(EventID.TalkEnableMonsterSpawn, self, self.OnTalkEnableMonsterSpawn)
		Owner:NewInitComponentBase_SetWaitInitTag(true, Const.CharWaitInitTag.HideInTalk)
    end
	if Owner.bIsTalkNpc and Owner.LoadingAssetState <= ENpcLoadingAssetState.EBodyMesh then
		Owner:NewInitComponentBase_SetWaitInitTag(true, "NpcMeshLoading")
	end
end

function M:NewNpcInitComponent_SyncServerBornInfo(Owner)
    Owner.ServerBornInfo = Owner.BornInfo:ToEffectStruct()
end

function M:NewNpcInitComponent_CallBPReceiveBeginAndCharacterReady(Owner)
    -- 调用顺序 Monster.lua -> CharacterBase.lua -> Monster.BP
    Owner.Overridden.ReceiveBeginPlay(Owner)
    -- 调用顺序 Monster.cpp -> CharacterBase.cpp
    Owner.Overridden.OnCharacterReady(Owner)  
end

function M:NewNpcInitComponent_OnPostInitSucc(Owner)
    if Owner.OnPostInitSucc then
        Owner:OnPostInitSucc()
    end   
end

function M:NewNpcInitComponent_ClientInteractiveStateRecover(Owner)
    if Owner.ClientInteractiveStateRecover then
        Owner:ClientInteractiveStateRecover()
    end   
end

function M:NewNpcInitComponent_InitInteractiveState(Owner, WorldRegionEid)
    if Owner.InitInteractiveState then
        Owner:InitInteractiveState(WorldRegionEid)
    end   
end

-- function M:InitAttributeFromTable()
--     if not MiscUtils.GetGameCofingSettings("bUseBlueprintMeshAndABP") then
--         self.Owner:InitAttributeFromTable()
--     end  
-- end

-- function M:LoadCurrentModel()
--     self.Owner:LoadCurrentModel()
-- end

function M:NewNpcInitComponent_CheckIsActiveFlexibleDestory(Object)
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return false
	end
	
	local TempFlexibleMap = {}
	-- local function MakeTempFlexibleMap() --构建倒序的Map
	-- 	local NewFlexibleMap = {}
	-- 	local FNpcArrayNum = Object.FlexibleActiveInactive:Num()
	-- 	for FNpcActiveArray, IsActive in pairs(Object.FlexibleActiveInactive) do
	-- 		local NewFlexibleMapElement = {}
	-- 		NewFlexibleMapElement.NpcActiveArray = FNpcActiveArray
	-- 		NewFlexibleMapElement.IsActive = IsActive
	-- 		NewFlexibleMap[FNpcArrayNum] = NewFlexibleMapElement
	-- 		FNpcArrayNum = FNpcArrayNum - 1
	-- 	end
	-- 	return NewFlexibleMap
	-- end
	-- TempFlexibleMap = MakeTempFlexibleMap()
	local FNpcArrayNum = Object.FlexibleActiveInactive:Num()
	for FNpcActiveArray, IsActive in pairs(Object.FlexibleActiveInactive) do
		local NewFlexibleMapElement = {}
		NewFlexibleMapElement.NpcActiveArray = FNpcActiveArray
		NewFlexibleMapElement.IsActive = IsActive
		TempFlexibleMap[FNpcArrayNum] = NewFlexibleMapElement
		FNpcArrayNum = FNpcArrayNum - 1
	end

	if IsEmptyTable(TempFlexibleMap) then
		return false
	end

	for i = 1, Object.FlexibleActiveInactive:Num(), 1 do
		local IsActive = TempFlexibleMap[i].IsActive
		if IsActive then
			goto continue
		end
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
				DebugPrint("QuestChain is unexist:", QuestChainId)
				goto continue
			end
			local QuestChains = Avatar.QuestChains[QuestChainId]

			if TargetQuestState == QuestStateType.Doing and QuestChains.DoingQuestId == TargetQuestId then --任务在进行中
				return true
			elseif TargetQuestState == QuestStateType.Success and QuestChains:CheckQuestIdComplete(TargetQuestId)then --任务已完成
				return true
			else
				--其他类型暂不处理
				DebugPrint("QuestChain state is error:", QuestChainId)
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
					return true
				end
			elseif TalkState == TalkStateType.UnCompelete then
				if Avatar:IsStorylineUnComplete(TargetTalkTriggerId) then
					return true
				end
			elseif TalkState == TalkStateType.CheckSuccess then
				if Avatar:IsStorylineSuccess(TargetTalkTriggerId) then
					return true
				end
			elseif TalkState == TalkStateType.CheckFail then
				if Avatar:IsStorylineFailure(TargetTalkTriggerId) then
					return true
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
				DebugPrint("QuestChain is unexist:", FlexibleQuestChainId)
				goto continue
			end

			if FlexibleQuestChainState == QuestChainStateType.Doing and Avatar:IsQuestChainDoing(FlexibleQuestChainId) then --任务在进行中
				return true
			elseif FlexibleQuestChainState == QuestChainStateType.Success and Avatar:IsQuestChainFinished(FlexibleQuestChainId) then --任务已完成
				return true
			else
				--其他类型暂不处理
				DebugPrint("QuestChain state is error:", FlexibleQuestChainId)
			end
		end
		::continue::
	end

	return false
end

function M:NewNpcInitComponent_TrySetRandomPetShowOrHideState(Owner, RandomCreatorId, WorldRegionEid)
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return false
	end

	local GameState = UE4.UGameplayStatics.GetGameState(Owner)
	local OwnerUnitId = Owner.UnitId
	local IsCarryRarity = false
	if DataMgr.Pet[OwnerUnitId] and DataMgr.Pet[OwnerUnitId].Rarity >= DataMgr.GlobalConstant.PetRareLevel.ConstantValue then
		IsCarryRarity = true
	end

	local AvatarTryMaxPetRegionId = Avatar.TryMaxPetRegionId
	local CurrentRegionId = Avatar:GetSubRegionId2RegionId()
	if Avatar.TryMaxPetRegionId == 0 then
		if GameState.RegionRandomPetLimitedDailyCount <= 0 and IsCarryRarity then
			Owner:SetActorHideTag("RandomDailyLimit", true)
			Owner:SetCollisionDisableTag("RandomDailyLimit", true)
		else
			Owner:SetActorHideTag("RandomDailyLimit", false)
			Owner:SetCollisionDisableTag("RandomDailyLimit", false)
		end
	elseif CurrentRegionId == AvatarTryMaxPetRegionId then
		Owner:SetActorHideTag("RandomDailyLimit", false)
		Owner:SetCollisionDisableTag("RandomDailyLimit", false)
	end
end

return M