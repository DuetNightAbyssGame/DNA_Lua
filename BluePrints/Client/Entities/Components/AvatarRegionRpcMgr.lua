local pb = require "pb"
local LevelBaseDataAttrDict = require "BluePrints.Client.CustomTypes.Region".LevelBaseDataAttrDict
local utf8ok, utf8 = pcall(require, "utf8")
local Decorator = require "BluePrints.Client.Wrapper.Decorator"
local Component = {}
Decorator:ApplyDecorator(Component)

-- S2C：所在区域存储数据
function Component:ReceiveSynchronizedDataFromServer(RegionDatas)
	local RegionId = self:GetSubRegionId2RegionId()
	local RegionInfo = DataMgr.Region[RegionId]
	if not RegionInfo then  
		self.logger.error("ZJT_ ReceiveSynchronizedDataFromServer 数据错误 ", RegionId, self:GetCurrentRegionId())
		PrintTable({RegionDatas = RegionDatas}, 10)
		return
	end
	for RegionDataType, RegionDataTypeName in pairs(CommonConst.RegionDataType) do
		local RegionTypeData = RegionDatas[RegionDataType]
		if RegionTypeData then
			for _, SubRegionId in ipairs(RegionInfo.IsRandom) do
				local EncodeStr = RegionTypeData[tostring(SubRegionId)] 
				if EncodeStr then
					local DecodeStr = pb.decode(".LevelBaseDataAttrDict", EncodeStr)
					if DecodeStr then
						local DecodeProtoAttr = LevelBaseDataAttrDict:proto_load(DecodeStr)
						RegionTypeData[tostring(SubRegionId)] = DecodeProtoAttr:save_dump(DecodeProtoAttr)
					end
				end
			end
		end
	end
	PrintTable({DecodeRegionDatas = RegionDatas}, 10)
	local SubSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, URegionDataMgrSubsystem:StaticClass())
	SubSystem:SyncPartRegionDataFromServer(RegionDatas)
end

-- S2C：全区域存储数据，如传送点
function Component:ReceiveSyncAllRegionDataFromServer(AllRegionBaseDataCache)
	local SubSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, URegionDataMgrSubsystem:StaticClass())
	SubSystem:SyncFullRegionStoreDataFromServer(AllRegionBaseDataCache)
end

------------------- GM相关  -------------------

-- S2C
-- 服务器下发GM请求的数据
-- 枚举区分用途 CommonConst.GMRegionTargetType
function Component:GMReceiveSynchronizedDataFromServer(RequestType, RegionDatas)
	print(_G.LogTag, "GMReceiveSynchronizedDataFromServer")
	local SubSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, URegionDataMgrSubsystem:StaticClass())

	if RequestType == CommonConst.GMRegionTargetType.AllData then
		SubSystem:GMTest_PrintServerRegionData(RegionDatas)
	elseif RequestType == CommonConst.GMRegionTargetType.AllQuestData then
		SubSystem:GMTest_PrintServerQuestChainData(RegionDatas)
	end
end

-- C2S
-- 忽略服务器函数命名，这个接口专用于GM，找服务器请求各种数据库数据
-- 用枚举区分用途 CommonConst.GMRegionTargetType
function Component:GMC2S_RequestSynchronizedDataFromServer(RequestType, RequestParamTable)
	RequestParamTable = RequestParamTable or {}
	print(_G.LogTag, "GMC2S_RequestSynchronizedDataFromServer")
	self:CallServerMethod("GMHandleQuestDatasEnterRegion", RequestType, RequestParamTable)
end

function Component:GMHandleSyncAllRegionDataToClient(Callback)
	self:CallServer("GMHandleSyncAllRegionDataToClient", Callback)
end

------------------- GM相关  -------------------


--- C2S 区域事件通知
--- 首先进入区域的方式有三种
--- 一是：第一次进入区域时默认设置位置 走StartPoint
--- 二是：通过恢复的方式进入直接通过记录的位置进行恢复 不走StartPoint
--- 三是：通过传送的方式进入这里也是走StartPoint
function Component:EnterRegion(TargetRegionId, StartIndex, EnterRegionType, ForLogin, bIsInvitation)
	local CheckRes, BlackScreenHandle = self:PreHandleEnterRegion(TargetRegionId, StartIndex, EnterRegionType,  bIsInvitation)
	if not CheckRes then return end
	ForLogin = ForLogin or false
	local function callback(Ret, _RegionId)
		if not ErrorCode:Check(Ret) then return end
		self:RealHandleEnterRegion(TargetRegionId, bIsInvitation, BlackScreenHandle)
	end
	self:CallServer("EnterRegion", callback, TargetRegionId, StartIndex, EnterRegionType, ForLogin)
end

function Component:RealHandleEnterRegion( TargetRegionId, bIsInvitation, BlackScreenHandle)
	if(bIsInvitation) then
		UIManager(self):HideCommonBlackScreen(BlackScreenHandle)
		local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
		PlayerCharacter:RemoveDisableInputTag("CameraLookToTarget")
		local SojournsGameInstanceSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, USojournsGameInstanceSubsystem)
		if SojournsGameInstanceSubsystem then
			SojournsGameInstanceSubsystem:SetInvitationRegionId(TargetRegionId)
		end
	end
end

function Component:SetDisableInputTag(bIsInvitation, PlayerCharacter, BlackScreenHandle) 
	if(bIsInvitation) then
		UIManager(self):ShowCommonBlackScreen(BlackScreenHandle)
        PlayerCharacter:AddDisableInputTag("CameraLookToTarget")	
	end
end

function Component:SetTryActiveDefaultDeliver(EnterRegionType)
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if not GameMode then return end
	if EnterRegionType == CommonConst.EnterRegionType.FirstRegion then
		return
	end
	if EnterRegionType == CommonConst.EnterRegionType.Recover then
		return
	end
	GameMode:GetRegionDataMgrSubSystem().bTryActiveDefaultDeliver = true
end

function Component:CheckRepeatEnterRegion(TargetRegionId)
	if self:GetSubRegionId2RegionId(TargetRegionId) == self:GetSubRegionId2RegionId() and self:IsInBigWorld() then
		self.logger.error("ZJT_ 同区域传送请走关卡加卸载 ", TargetRegionId, self:GetCurrentRegionId())
		return false
	end
	return true
end

function Component:PreHandleEnterRegion(TargetRegionId, StartIndex, EnterRegionType, bIsInvitation)
	local BlackScreenHandle
	local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	local IsRepeatEnterRegion = self:CheckRepeatEnterRegion(TargetRegionId)
	if not IsRepeatEnterRegion then return false, BlackScreenHandle end
	BlackScreenHandle = {BlackScreenHandle = "Invitation", InAnimationObj = self,OutAnimationObj = self,}
	self:SetDisableInputTag(bIsInvitation, PlayerCharacter, BlackScreenHandle)
	if not self:CheckRegionId(TargetRegionId) then return false, BlackScreenHandle end
	GWorld:OpenWorldRegionState()
	self:SetTryActiveDefaultDeliver(EnterRegionType)
	self.StartIndex = tonumber(StartIndex) or 1
	return true, BlackScreenHandle
end



function Component:RecoverRegion_ExitDungeon()
	local CheckRes, BlackScreenHandle = self:PreHandleEnterRegion(self:GetCurrentRegionId(), self.StartIndex, CommonConst.EnterRegionType.Recover)
	if not CheckRes then return end
	local function Callback(Ret, TargetRegionId)
		if not ErrorCode:Check(Ret) then return end
		EventManager:FireEvent(EventID.OnExitDungeon)
		self:RealHandleEnterRegion(TargetRegionId, nil, BlackScreenHandle)
	end
	self:CallServer("RecoverRegion_ExitDungeon", Callback)
end

-- C2S 跳转区域
function Component:SkipRegion(TargetRegionId)
	local PreRegionId = self.CurrentRegionId
	local function Callback(Ret)
		if not self:CheckRegionErrorCode( Ret) then
			if not self:CheckRegionErrorCode( Ret, ErrorCode.RET_REGION_BASEDATA_WORLDREGIONEID_REPEAT) and not self:CheckRegionErrorCode( Ret, ErrorCode.RET_CURRENT_TARGET_REGIOINID_EQUAL) then
				GWorld.logger.debug("SkipRegion  ".."ErrorCode:"..Ret.."  TargetRegionId:"..TargetRegionId .. " CurrentRegionId:" .. self.CurrentRegionId .. ", 详细数据见Log")
			end
			return
		end
		self:RealHandleSkipRegion(PreRegionId, self:GetCurrentRegionId())
	end
	self:GetCurrentSafeAndSaveLocation()
	self:CallServer("SkipRegion", Callback, TargetRegionId, self.LastRegionData.RegionId, self.LastRegionData:GetLocation(), self.LastRegionData:GetRotation())
end

function Component:RealHandleSkipRegion(PreRegionId)
	self:ExeRegionSkipCallbck(PreRegionId)
	self:ExeRegionSkipCallbck(self:GetCurrentRegionId())
	EventManager:FireEvent(EventID.OnSkipRegion, self:GetCurrentRegionId())
	local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	if PlayerCharacter then
		PlayerCharacter:OnEnteredNewSubRegion()
	end
	local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"
	TaskUtils:UpdatePlayerSubRegionIdInfo(self.CurrentRegionId)
end

function Component:TrySpawnSpecialMonster(RuleId, Cb)
	local Cb = Cb or function (ErrCode)
		DebugPrint("TrySpawnSpecialMonster ", ErrorCode:Name(ErrCode))
	end

	local Rule = DataMgr.SpecialMonsterSpawn[RuleId]
	if not Rule then
		Cb(ErrorCode.RET_REGION_SPECIAL_MONSTER_RULE_NOT_EXIST)
		return
	end
	local SpawnCount = self.RegionSpecialMonsterCounter[RuleId] or 0
	if SpawnCount >= Rule.WeeklyLimit then
		Cb(ErrorCode.RET_REGION_SPECIAL_MONSTER_MAX_COUNT)
		return
	end
	if Rule.SpawnRegion and self.CurrentRegionId ~= Rule.SpawnRegion then
		DebugPrint("[TrySpawnSpecialMonster] RET_REGION_SPECIAL_MONSTER_NOT_IN_REGION ", self.CurrentRegionId,Rule.SpawnRegion)
		Cb(ErrorCode.RET_REGION_SPECIAL_MONSTER_NOT_IN_REGION)
		return
	end

	self:CallServer("TrySpawnSpecialMonster", Cb or function (ErrCode)
		DebugPrint("TrySpawnSpecialMonster ", ErrorCode:Name(ErrCode))
	end , RuleId)
end

Component:LimitCall(1)
function Component:SetTimeOfDay(NewTime)
	local function Callback(Ret)
		self.logger.debug("ZJT_ 111111 SetTimeOfDay ", NewTime)
	end
	self:CallServer("SetTimeOfDay", Callback, NewTime)
end

function Component:RegionActorUpdate(TargetActor, NewSubRegionId, NewLevelName, StateTable, CB)
	-- local WorldRegionEid = TargetActor.WorldRegionEid
	-- local RegionDataType = TargetActor.RegionDataType
	
	local NoStorageRegionDataType = {ERegionDataType.RDT_QuestData, ERegionDataType.RDT_None, ERegionDataType.RDT_HardBossData, ERegionDataType.RDT_QuestCommonData}

	if CommonUtils.HasValue(NoStorageRegionDataType, TargetActor.RegionDataType) then
		DebugPrint("RegionLog:  Actor更新属性,当前类型为："..TargetActor.RegionDataType.."  不做任何处理, WorldRegionEid:"..tostring(TargetActor.WorldRegionEid))
		return
	end
	
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	local Ret, UnitRegionData = self:AvatarUpdateUnitRegionData(TargetActor, NewSubRegionId, NewLevelName)
	if not self:CheckRegionErrorCode(Ret) then 
		DebugPrint("RegionLog:  Actor更新属性,当前类型为："..TargetActor.RegionDataType.."  WorldRegionEid:"..tostring(TargetActor.WorldRegionEid).."    更新数据失败，Ret："..Ret)
		return
	end
	--目前只有SceneItemBase更新state会调用，所以先关了Location
	-- GameMode:GetRegionDataMgrSubSystem().DataLibrary:SetLocation(UnitRegionData, TargetActor:k2_GetActorLocation())
	-- GameMode:GetRegionDataMgrSubSystem().DataLibrary:SetStateValue(UnitRegionData, StateTable)
	local function callback(Ret)
		if Ret~=ErrorCode.RET_SUCCESS and Ret~=ErrorCode.RET_REGION_BASEDATA_WORLDREGIONEID_REPEAT then
			GWorld.logger.error("UpdateRegionActorData ".."ErrorCode:"..Ret.." WorldRegionEid:"..TargetActor.WorldRegionEid.." NewSubRegionId:"..
			NewSubRegionId.." RegionDataType:"..TargetActor.RegionDataType.." NewLevelName:"..NewLevelName)
			 PrintTable(StateTable)
		end
		if CB then
			CB(Ret)
		end
	end
	if self.CombineAdd and self:TryUpdateCombineRegionData(TargetActor, StateTable) then
		return 
	end
	-- 注意：同时操作RegionCacheData和上传服务器的接口。按顺序，先改客户端数据，再传服务器。
	self:CallServer("UpdateRegionActorData", callback, TargetActor.WorldRegionEid, NewSubRegionId, TargetActor.RegionDataType, StateTable, NewLevelName)
end

function Component:CheckRegionErrorCode(SourceErrorCode, TargetErrorCode)
	TargetErrorCode = TargetErrorCode or ErrorCode.RET_SUCCESS
	return SourceErrorCode == TargetErrorCode
end

--- 
--- 仅对象正常死亡时发送，用于当对象正常死亡时向服务器标记对象死亡状态
--- 如静态刷新点刷新的怪死亡，记录状态用于新上线后不会重复刷
--- @wuzhijun, NewSubRegionId和NewLevelName现有需求是不需要传的 0733CA2F434ED1FA263289A06B0650ED
---
function Component:C2SReigonActorDead(TargetActor, NewSubRegionId, NewLevelName)
	-- self:Dead(UnitRegionData)
	local function callback(Ret)
		if Ret~=ErrorCode.RET_SUCCESS and Ret~=ErrorCode.RET_REGION_BASEDATA_WORLDREGIONEID_REPEAT then
			GWorld.logger.error("DeadRegionActorData".." ErrorCode"..Ret.." WorldRegionEid:"..TargetActor.WorldRegionEid.." NewSubRegionId:"..NewSubRegionId..
			 " RegionDataType:"..TargetActor.RegionDataType.." NewLevelName:"..NewLevelName)
		end
	end

	self:CallServer("DeadRegionActorData", callback, TargetActor.WorldRegionEid, NewSubRegionId, TargetActor.RegionDataType, NewLevelName)
end

function Component:RegionActorDead(TargetActor, DestoryReason, NewSubRegionId, NewLevelName, NoRPC)
	if DestoryReason == EDestroyReason.EngineDestroy then--先拦截掉看看情况多不多
		GWorld.logger.error('RegionActorDead DestroyReason EngineDestroy!', TargetActor and TargetActor:GetName() or 'nil', NewSubRegionId, NewLevelName)
		return
	end
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	local NoStorageRegionDataType = {ERegionDataType.RDT_QuestData, ERegionDataType.RDT_None, ERegionDataType.RDT_HardBossData, ERegionDataType.RDT_QuestCommonData}
	if DestoryReason == EDestroyReason.LevelUnloadedSaveGame or DestoryReason == EDestroyReason.LevelNotExsit then 
		DebugPrint("RegionLog:  WC导致Actor销毁,当前类型为："..TargetActor.RegionDataType.."  WorldRegionEid:"..TargetActor.WorldRegionEid)
		-- if URuntimeCommonFunctionLibrary.UseCppRegionData(TargetActor) then
			GameMode:GetRegionDataMgrSubSystem():AddSSData(TargetActor.WorldRegionEid)
		-- else
		-- 	local UnitRegionData = GameMode:GetRegionDataMgrSubSystem().DataLibrary:ConstructUnitRegionDataByUnit(TargetActor)
		-- 	GameMode:GetRegionDataMgrSubSystem().DataLibrary:AddRegionSSDatas(UnitRegionData)
		-- 	if not CommonUtils.HasValue(NoStorageRegionDataType, TargetActor.RegionDataType) then
		-- 		DebugPrint("RegionLog:  WC导致Actor销毁, Actor类型需要存储，进行数据检查,")
		-- 		local ClientData = GameMode:GetRegionDataMgrSubSystem():GetUnitRegionCacheDataByActor(TargetActor)
		-- 		-- if ClientData and not CommonUtils.IsEqual(ClientData, UnitRegionData) then
		-- 		-- 	DebugPrint("RegionLog:  WC导致Actor销毁, Actor类型需要存储，进行数据检查, 数据有误差，请检查--begin")
		-- 		-- 	-- PrintTable(ClientData,10)
		-- 		-- 	-- PrintTable(UnitRegionData,10)
		-- 		-- 	DebugPrint("RegionLog:  WC导致Actor销毁, Actor类型需要存储，进行数据检查, 数据有误差，请检查--end")
		-- 		-- end
		-- 	end
		-- end
		return
	end

	if DestoryReason == EDestroyReason.HardBossClear and TargetActor.RegionDataType ~= ERegionDataType.RDT_HardBossData then
		DebugPrint("RegionLog:  HardBossClear导致Actor销毁,当前类型为："..TargetActor.RegionDataType.."  WorldRegionEid:"..TargetActor.WorldRegionEid)
		if TargetActor.CheckHardBossNeedSnapShot and TargetActor:CheckHardBossNeedSnapShot() then
			-- if URuntimeCommonFunctionLibrary.UseCppRegionData(TargetActor) then
				GameMode:GetRegionDataMgrSubSystem():AddSSData(TargetActor.WorldRegionEid, true)
			-- else
			-- 	local UnitRegionData = GameMode:GetRegionDataMgrSubSystem().DataLibrary:ConstructUnitRegionDataByUnit(TargetActor)
			-- 	GameMode:GetRegionDataMgrSubSystem().DataLibrary:AddRegionSSDatas(UnitRegionData)
			-- end
		end
		return
	end

	if DestoryReason == EDestroyReason.SepcialQuestStart then
		DebugPrint("RegionLog:  SepcialQuestStart导致Actor销毁,当前类型为："..TargetActor.RegionDataType.."  WorldRegionEid:"..TargetActor.WorldRegionEid)
		-- local UnitRegionData = GameMode:GetRegionDataMgrSubSystem().DataLibrary:ConstructUnitRegionDataByUnit(TargetActor)
		-- if URuntimeCommonFunctionLibrary.UseCppRegionData(TargetActor) then
			GameMode:GetRegionDataMgrSubSystem():AddSSData(TargetActor.WorldRegionEid, true)
		-- else
		-- 	GameMode:GetRegionDataMgrSubSystem().DataLibrary:AddRegionSSDatas(UnitRegionData)
		-- end
		return
	end

	-- if URuntimeCommonFunctionLibrary.UseCppRegionData(TargetActor) then
		GameMode:GetRegionDataMgrSubSystem():OnActorDead(TargetActor)
	-- end
	
	if CommonUtils.HasValue(NoStorageRegionDataType, TargetActor.RegionDataType) then
		DebugPrint("RegionLog:  Actor销毁,当前类型为："..TargetActor.RegionDataType.."  不做任何处理, WorldRegionEid:"..tostring(TargetActor.WorldRegionEid))
		return
	end

	-- local Ret, UnitRegionData = self:AvatarUpdateUnitRegionData(TargetActor, NewSubRegionId, NewLevelName)
	-- if not self:CheckRegionErrorCode(Ret) then
	-- 	DebugPrint("RegionLog:  Actor销毁,当前类型为："..TargetActor.RegionDataType.."  WorldRegionEid:"..tostring(TargetActor.WorldRegionEid).."    更新数据失败，Ret："..Ret)
	-- 	return 
	-- end

	--UnitRegionData.IsDead = true
	if DestoryReason == EDestroyReason.RegionExploreGroup then
		return
	end
	
	if GameMode:GetRegionDataMgrSubSystem().DataLibrary:SetUnitIsDeadByWorldRegionEid(TargetActor.WorldRegionEid) and not NoRPC then
		self:C2SReigonActorDead(TargetActor, NewSubRegionId, NewLevelName)
		-- UnitRegionData.IsDead = true
		-- if TargetActor.CreatorId > 0 then
        --     GameMode:TriggerOnRegionUnitDead(TargetActor.CreatorId)
        -- end
	end
		
end

function Component:AvatarUpdateUnitRegionData(TargetActor)
	-- TargetActor.SubRegionId = tostring(NewSubRegionId)
	-- TargetActor.LevelName = NewLevelName
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	local UnitRegionData = GameMode:GetRegionDataMgrSubSystem():UpdateUnitRegionCacheDataByActor(TargetActor)
	if not UnitRegionData then
		return ErrorCode.RET_REGION_NOT_EXIST_CACHE_REGIONBASEDATA, nil
	end
	return ErrorCode.RET_SUCCESS, UnitRegionData
end

function Component:AvatarC2SAddRegionActorData(UnitRegionData)
	if UnitRegionData.RegionDataType == ERegionDataType.RDT_QuestCommonData then
		DebugPrint('AddRegionActorData Fail, RegionDataType:RDT_QuestCommonData, WorldRegionEid:',UnitRegionData.WorldRegionEid)
		return
	end 
	if self.CombineAdd then
		table.insert(self.CombineAddDatas, UnitRegionData)
		return
	end
	if not self:RegionDataValidCheck(UnitRegionData) then
		return
	end
	DebugPrint("ZJT_  RegionDataMgr: Client  RegionAddDataByUnit", UnitRegionData.ManualItemId, UnitRegionData.WorldRegionEid)
	local function Callback(Ret)
		if Ret~=ErrorCode.RET_SUCCESS and Ret~=ErrorCode.RET_REGION_BASEDATA_WORLDREGIONEID_REPEAT then
			GWorld.logger.error("AddRegionActorData ".."ErrorCode:"..Ret.." RegionDataType:"..UnitRegionData.RegionDataType..
			" WorldRegionEid:"..UnitRegionData.WorldRegionEid.." ManualItemId:"..tostring(UnitRegionData.ManualItemId or -1))
			PrintTable(UnitRegionData)
		end
        DebugPrint("zjt_ RegionDataMgr: CallServer  RegionAddDataByUnit", Ret, UnitRegionData.ManualItemId, UnitRegionData.WorldRegionEid)
    end
    self:CallServer("AddRegionActorData", Callback, UnitRegionData.RegionDataType, UnitRegionData)
end

function Component:AddAutoRegionActorDatas(TargetRegionBaseDatas)
	if next(TargetRegionBaseDatas) == nil then
		return 
	end
	for i = #TargetRegionBaseDatas, 1, -1 do
		if not self:RegionDataValidCheck(TargetRegionBaseDatas[i]) then
			table.remove(TargetRegionBaseDatas, i)
		end
	end
	local function Callback(Ret)
		if not self:CheckRegionErrorCode(Ret) then
			self.logger.error("ZJT_ AddAutoRegionActorDatas ServerCallClient Failed ", Ret)
		else
			self.logger.debug("ZJT_ AddAutoRegionActorDatas ServerCallClient Success ", Ret)
		end
	end
	self:CallServer("AddAutoRegionActorDatas", Callback, TargetRegionBaseDatas)
end


function Component:ResetRarelyStaticCreator(StaticCreatorId, CB, PrivateEnable, EventName)
	local function Callback(Ret)
		--print(_G.LogTag,"LXZ ResetRarelyStaticCreator Avatar,", Ret)
		if self:CheckRegionErrorCode(Ret) then
			---- 客户端逻辑
			CB(StaticCreatorId, PrivateEnable, EventName)
		else
			---- 客户端逻辑
		end
	end
	self:CallServer("ResetRarelyStaticCreator", Callback, StaticCreatorId)
end
function Component:AvatarC2SAddRandomRegionActorData(RandomCreatorDatas)
	if not RandomCreatorDatas or type(RandomCreatorDatas) ~= "table" then return end 
	local function Callback(Ret)
		if Ret~=ErrorCode.RET_SUCCESS and Ret~=ErrorCode.RET_REGION_BASEDATA_WORLDREGIONEID_REPEAT then
			GWorld.logger.error("AddRandomCreatorRegionDatas ".."ErrorCode:"..Ret)
			PrintTable(RandomCreatorDatas)
		end
	end
	self:CallServer("AddRandomCreatorRegionDatas", Callback, RandomCreatorDatas)
end

function Component:UpdateRegionDataStateByCreatorId(CreatorId, StateData, cb)
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if not GameMode.GetRegionDataMgrSubSystem or not GameMode:IsInRegion() then
		return
	end
	local RegionDatas = GameMode:GetRegionDataMgrSubSystem():UpdateRegionDataStateCacheByCreatorId(CreatorId, StateData)
	if not RegionDatas or #RegionDatas == 0 then
		return
	end
	local function callback(Ret)
		if Ret~=ErrorCode.RET_SUCCESS and Ret~=ErrorCode.RET_REGION_BASEDATA_WORLDREGIONEID_REPEAT then
			GWorld.logger.error("UpdateRegionActorData".." ErrorCode:"..Ret)
			for _,RegionData in pairs(RegionDatas) do
				GWorld.logger.error(" WorldRegionEid:"..RegionData.WorldRegionEid.." SubRegionId:"..RegionData.SubRegionId..
				" RegionDataType:"..RegionData.RegionDataType.." LevelName"..RegionData.LevelName)
			end
			PrintTable(StateData)
		end
		if Ret==ErrorCode.RET_SUCCESS then
			cb(Ret)
		end
	end
	for _,RegionData in pairs(RegionDatas) do
		self:CallServer("UpdateRegionActorData", callback, RegionData.WorldRegionEid, RegionData.SubRegionId, RegionData.RegionDataType, StateData, RegionData.LevelName)
	end
end

function Component:UpdatePhantomRegionActorData(RegionData, StateData)
	local function Callback(Ret)
		self.logger.debug("ZJT_ UpdatePhantomRegionActorData ", Ret)
	end
	self:CallServer("UpdatePhantomRegionActorData", Callback, RegionData.WorldRegionEid, RegionData.SubRegionId, RegionData.RegionDataType, RegionData.LevelName, StateData)
end

--smh 停用
function Component:RegionActorDataDeadByCreatorId(CreatorId)
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	local RegionDatas = GameMode:GetRegionDataMgrSubSystem():RegionActorCacheDataDeadByCreatorId(CreatorId)
	if not RegionDatas  or #RegionDatas == 0 then
		return
	end
	local function callback(Ret)
		if  Ret~=ErrorCode.RET_SUCCESS and Ret~=ErrorCode.RET_REGION_BASEDATA_WORLDREGIONEID_REPEAT then
			GWorld.logger.error("DeadRegionActorData".." ErrorCode:"..Ret)
			for _,RegionData in pairs(RegionDatas) do
				GWorld.logger.error(" WorldRegionEid:"..RegionData.WorldRegionEid.." SubRegionId"..RegionData.SubRegionId..
				" RegionDataType:"..RegionData.RegionDataType.." LevelName:"..RegionData.LevelName)
			end
		end
	end
	for _,RegionData in pairs(RegionDatas) do
		self:CallServer("DeadRegionActorData", callback, RegionData.WorldRegionEid, RegionData.SubRegionId, RegionData.RegionDataType, RegionData.LevelName)
	end
end

function Component:RegionDataDead(RegionData)
	local function callback(Ret)
		if  Ret~=ErrorCode.RET_SUCCESS and Ret~=ErrorCode.RET_REGION_BASEDATA_WORLDREGIONEID_REPEAT then
			GWorld.logger.error("DeadRegionActorData".." ErrorCode"..Ret.." WorldRegionEid:"..RegionData.WorldRegionEid.." SubRegionId:"..RegionData.SubRegionId..
			" RegionDataType:"..RegionData.RegionDataType.." LevelName:"..RegionData.LevelName)
		end
	end
	self:CallServer("DeadRegionActorData", callback, RegionData.WorldRegionEid, RegionData.SubRegionId, RegionData.RegionDataType, RegionData.LevelName)
end


function Component:RegionActorDataDeadByUnitLabel(UnitId, UnitType)
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	local RegionDatas = GameMode:GetRegionDataMgrSubSystem():RegionActorCacheDataDeadByUnitLabel(UnitId, UnitType)
	if not RegionDatas  or #RegionDatas == 0 or not GameMode:IsInRegion() then
		return
	end
	local function callback(Ret)
		if  Ret~=ErrorCode.RET_SUCCESS and Ret~=ErrorCode.RET_REGION_BASEDATA_WORLDREGIONEID_REPEAT then
			GWorld.logger.error("DeadRegionActorData".." ErrorCode:"..Ret)
			for _,RegionData in pairs(RegionDatas) do
				GWorld.logger.error(" WorldRegionEid:"..RegionData.WorldRegionEid.." SubRegionId:"..RegionData.SubRegionId..
				" RegionDataType:"..RegionData.RegionDataType.." LevelName:"..RegionData.LevelName)
			end
		end
	end
	for _,RegionData in pairs(RegionDatas) do
		self:CallServer("DeadRegionActorData", callback, RegionData.WorldRegionEid, RegionData.SubRegionId, RegionData.RegionDataType, RegionData.LevelName)
	end
end


function Component:S2CSwitchInRegionStateFailer()
	self.logger.debug("ZJT_ S2CSwitchInRegionStateFailer ")
end  


function Component:AddRandomCreatorRegionDatas(RandomCreatorDatas)
	if not RandomCreatorDatas or type(RandomCreatorDatas) ~= "table" then return end 
	local function Callback(Ret)
		DebugPrint("ZJT_ AddRandomCreatorRegionDatas ", Ret, RandomCreatorDatas)
	end

	self:CallServer("AddRandomCreatorRegionDatas", Callback, RandomCreatorDatas)
end


function Component:ActiveRandomCreator(RadnomRuleId, ParamsNum, cb)
	ParamsNum = ParamsNum or 0
	if not RadnomRuleId then return end 
	local function Callback(Ret, ClientRes)
		DebugPrint("ZJT_ ActiveRandomCreator ", Ret, RadnomRuleId, ParamsNum)
		PrintTable({ClientRes = ClientRes}, 10)
		cb(Ret, ClientRes)
	end
	self:CallServer("ActiveRandomCreator", Callback, RadnomRuleId, ParamsNum)
end

function Component:ActiveRandomCreators(RandomRuleInfos) 
	if not RandomRuleInfos or type(RandomRuleInfos) ~= "table" then return end 
	local function Callback(Ret, ClientRes)
		DebugPrint("ZJT_ ActiveRandomCreators ", Ret)
		PrintTable({ClientRes = ClientRes, RandomRuleInfos = RandomRuleInfos}, 10)
	end
	self:CallServer("ActiveRandomCreators", Callback, RandomRuleInfos)
end

function Component:TryCapturePetRegion(ResourceId, xValue, PetId, RegionDataType, WorldRegionEid,CaptureCallBack)
	local function Callback(Ret, UniqueId)
		DebugPrint("zjt_ TryCapturePetRegion Ret = ",Ret,WorldRegionEid, RegionDataType, PetId, ResourceId, xValue)
		if CaptureCallBack then
			CaptureCallBack(Ret, UniqueId)
		end
	end
	self:CallServer("TryCapturePetRegion", Callback, ResourceId, xValue, PetId, RegionDataType, WorldRegionEid)
end

function Component:CombineAddRegionData(IsCombineAdd)
	self.CombineAdd = IsCombineAdd
	if self.CombineAdd then
		self.CombineAddDatas = {}
	else
		DebugPrint('CombineAddRegionData:',#self.CombineAddDatas)
		self:AddAutoRegionActorDatas(self.CombineAddDatas)
		self.CombineAddDatas = {}
	end
end

function Component:TryUpdateCombineRegionData(TargetActor, StateTable)
	local TargetWorldRegionEid = TargetActor.WorldRegionEid
	for _, CombineData in pairs(self.CombineAddDatas) do
		if CombineData.WorldRegionEid == TargetWorldRegionEid then
			-- CombineData.State = CommonUtils.DeepCopy(StateTable)
			return true
		end
	end
	return false
end

function Component:ConvertCheck(string)
	return string:gsub("<(%x%x)>", function(hex)
		return string.char(tonumber(hex, 16))
	end)
end

function Component:RegionDataValidCheck(DataTable)
	local ErrorMsg = false
	if not DataTable then
		return false
	end
	if not DataTable.SubRegionId or not DataTable.LevelName or not DataTable.RegionDataType then
		GWorld.logger.error('RegionDataValidCheck Error!!!')
		ErrorMsg = true
	elseif utf8ok then
		local NewLevelName = DataTable.LevelName
		local CheckResoult = self:ConvertCheck(NewLevelName)
		local success, Index = utf8.len(CheckResoult)
		if not success then
			GWorld.logger.error("Error LevelName "..NewLevelName)
			ErrorMsg = true
		end
	end
	if ErrorMsg then
		local  ct = {"RegionData Error:\n"}
		table.insert(ct, "Traceback:\n\t")
		table.insert(ct, debug.traceback())
		table.insert(ct, '\n=====================\n')
		table.insert(ct, UBattleFunctionLibrary.GetTraceStack(50))
		table.insert(ct, '\n=====================\n')
		self:GetTableStr(ct, DataTable, 1, 3)

		local FinalMsg = table.concat(ct)
		self:RegionReportToSentry(FinalMsg)
		DebugPrint(FinalMsg)
	end
	return not ErrorMsg
end

function Component:ReportRemoveLocalDataOnce(Data)
	local  ct = {"RegionData RemoveLocalDataOnce:\n"}
	self:GetTableStr(ct, Data, 1, 3)

	local FinalMsg = table.concat(ct)
	self:RegionReportToSentry(FinalMsg)
	DebugPrint(FinalMsg)
end

function Component:GetTableStr(ct, t, step, deep, PrettyFormat)
	if type(t) ~= "table" then
		ct[#ct + 1] = tostring(t)
		return
	end

	local func = function(k, v) 
		--ct[#ct + 1] = string.rep("\t", step)
		for i = 1, step do
			ct[#ct + 1] = "\t"
		end

		local type_k = type(k)
		local type_v = type(v)
		local str_k = nil
		local str_v = nil
		
		if (type_v == "table") and v.IsValid and Utils.IsValid(v) then
			type_v = tostring(UKismetSystemLibrary.GetDisplayName(v))
		end

		if type_k == "string" and CommonUtils.IsObjId(k) then
			str_k = CommonUtils.ObjId2Str(k)
		else
			str_k = tostring(k)
		end
		if type_v == "string" and CommonUtils.IsObjId(v) then
			str_v = CommonUtils.ObjId2Str(v)
		else
			if type_v == "table" and PrettyFormat then
				str_v = ""
			else
				str_v = tostring(v)
			end
		end

		ct[#ct + 1] = str_k
		if not PrettyFormat then
			ct[#ct + 1] = " ("
			ct[#ct + 1] = type_k
			ct[#ct + 1] = "): "
		else 
			ct[#ct + 1] = ": "
		end
		ct[#ct + 1] = str_v
		if not PrettyFormat then
			ct[#ct + 1] = " ("
			ct[#ct + 1] = type_v
			ct[#ct + 1] = ")\n"
		else
			ct[#ct + 1] = "\n"
		end
		
		if type(v) == "table" and step < deep then
			self:GetTableStr(ct, v, step + 1, deep, PrettyFormat)
		end
	end

	if PrettyFormat then
		local keys = {}
		for k, v in pairs(t) do
			keys[#keys + 1] = k
		end
		table.sort(keys)
		for _, k in ipairs(keys) do
			func(k, t[k])
		end
	else
		for k, v in pairs(t) do
			func(k, v)
		end
	end
end

function Component:RegionReportToSentry(ErrorMsg)
	local EMSentrySubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UEMSentrySubsystem)
    if EMSentrySubsystem then
		local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
		local SceneName = "Error"
        local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
		local WCSubsystem = GameMode:GetWCSubSystem()
		if WCSubsystem and PlayerCharacter then
			SceneName = WCSubsystem:GetLocationLevelName(PlayerCharacter:K2_GetActorLocation())
		end
		local SceneId = tostring(WorldTravelSubsystem():GetCurrentSceneId())
		local PlayerLocation =  (PlayerCharacter and tostring(PlayerCharacter:K2_GetActorLocation()) or " ")
		local TagMap = UE.TMap("", "")
		TagMap:Add("em.scene_id", SceneId)
		TagMap:Add("em.scene_name", tostring(SceneName))
		TagMap:Add("em.player_location", PlayerLocation)
        local FingerprintArray = UE.TArray("")
        FingerprintArray:Add("RegionData Error")
        EMSentrySubsystem:ReportEventTrace(ErrorMsg, TagMap, FingerprintArray)
    end
end

function Component:GMCreateRegionPet(UnitId, RegionBaseData)
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	local Location = FVector(0,0,0)
	local Rotation = FRotator(0, 0, 0)
	PrintTable({RegionBaseData = RegionBaseData, UnitId = UnitId}, 10)
    if IsValid(Player) then
        Location = Player:K2_GetActorLocation() + Player:GetActorForwardVector() * 100
		Rotation = Player:K2_GetActorRotation()
    end
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	GameMode:GetRegionDataMgrSubSystem():InitSSDataFromServer_Raw(RegionBaseData.WorldRegionEid, RegionBaseData.LevelName, RegionBaseData.UnitType, RegionBaseData.UnitId, Location, Rotation , RegionBaseData.RegionDataType)
	self.logger.debug("ZJT_ 创建宠物成功 ", UnitId, RegionBaseData)
end

return Component


