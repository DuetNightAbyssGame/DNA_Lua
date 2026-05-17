require "UnLua"
local CommonUtils = require "Utils.CommonUtils"
-- Gamemode
local GameModeQuestMgr = Class()


-- function GameModeQuestMgr:MergeTable(SourceTable, TargetTable)
--     if not SourceTable or not TargetTable or type(SourceTable) ~= "table" or type(TargetTable) ~= "table" then
--         print(_G.LogTag,"ZJT_ MergeTable Failer ")
--         return
--     end
--     for key, value in pairs(TargetTable) do
--        SourceTable[key] = value
--     end
--     return SourceTable
-- end

-------------------- BigWorld Event ----------------------

-- function GameModeQuestMgr:ClearLocalCache(RegionId, LevelName)
--     if IsStandAlone(self) then
-- 		local Avatar = GWorld:GetAvatar()
-- 		if Avatar then
-- 			Avatar:ClearLocalCacheByRegionId(RegionId, LevelName, self:GetLevelLoader())
-- 		end
-- 	elseif IsDedicatedServer(self) then
-- 		print(_G.LogTag,"ZJT_ IsDedicatedServer Not Do")
-- 	end
-- end


-- function GameModeQuestMgr:TryActiveStaticCreatorSerialize(Avatar, LevelName)
--     local StaticCreatorIds = Avatar:GetSerializeStaticCretor(LevelName)
--     if not StaticCreatorIds then return end
--     for StaticCreatorId, TempEid in pairs(StaticCreatorIds) do
--         local Creator = self.EMGameState.StaticCreatorMap:Find(StaticCreatorId)
--         -- 创建静态刷新点的对象
--         Creator:RealActiveStaticCreator({Eid = TempEid})
--     end
--     Avatar:RemoveSerializeStaticCretor(LevelName)
-- end

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
----------------------------------------- RegionSuit ----------------------------------------------------

function GameModeQuestMgr:InitRegionSuit(Avatar, RegionId)
    -- todo，提前到初始化注册
    local SuitTypeFuncTable = {}
    SuitTypeFuncTable[CommonConst.SuitType.GameModeSuit] = self.GameModeSuitRecover
    SuitTypeFuncTable[CommonConst.SuitType.PlayerCharacterSuit] = self.PlayerCharacterSuitRecover
    for _, SuitType in pairs(CommonConst.SuitType) do
        local SuitTypeData = Avatar.Suits:GetSuitBase(SuitType)
        if SuitTypeFuncTable[SuitType] then
            SuitTypeFuncTable[SuitType](self, SuitType, SuitTypeData)
        end
    end
end

function GameModeQuestMgr:GameModeSuitRecover(SuitType, GameModeSuit)
    if not GameModeSuit then return end
    -- todo，提前到初始化注册
    local GameModeSuitTypeFuncTable = {}
    GameModeSuitTypeFuncTable[CommonConst.GameModeSuit.DropRule] = self.DropRuleSuitRecover
    for _, SuitSubType in pairs(CommonConst.GameModeSuit) do
        local SuitSubBase = GameModeSuit:GetSubSuitBase(SuitSubType)
        if GameModeSuitTypeFuncTable[SuitSubType] then
            GameModeSuitTypeFuncTable[SuitSubType](self, SuitSubType, SuitSubBase)
        end
    end
end

function GameModeQuestMgr:PlayerCharacterSuitRecover(SuitType, PlayerCharacterSuit)
    if not PlayerCharacterSuit then return end
    -- todo，提前到初始化注册
    local PlayerSuitTypeFuncTable = {}
    PlayerSuitTypeFuncTable[CommonConst.PlayerCharacterSuit.DisableSkill] = self.DisableSkillSuitRecover
    PlayerSuitTypeFuncTable[CommonConst.PlayerCharacterSuit.SwitchStoryMode] = self.SwitchStoryModeSuitRecover
    PlayerSuitTypeFuncTable[CommonConst.PlayerCharacterSuit.HideUIInScreen] = self.HideUIInScreenSuitRecover
    PlayerSuitTypeFuncTable[CommonConst.PlayerCharacterSuit.MonsterFirstSeenGuide] = self.MonsterFirstSeenGuideSuitRecover
    PlayerSuitTypeFuncTable[CommonConst.PlayerCharacterSuit.BGM] = self.BGMSuitRecover
    PlayerSuitTypeFuncTable[CommonConst.PlayerCharacterSuit.ContinuedGuide] = self.ContinuedGuideSuitRecover
    PlayerSuitTypeFuncTable[CommonConst.PlayerCharacterSuit.NpcHideShowTag] = self.NpcHideShowTagSuitRecover
	PlayerSuitTypeFuncTable[CommonConst.PlayerCharacterSuit.NpcExpression] = self.NpcExpressionSuitRecover
	PlayerSuitTypeFuncTable[CommonConst.PlayerCharacterSuit.BGMParams] = self.BGMParamsSuitRecover
    for _, SuitSubType in pairs(CommonConst.PlayerCharacterSuit) do
        local SuitSubBase = PlayerCharacterSuit:GetSubSuitBase(SuitSubType)
        if PlayerSuitTypeFuncTable[SuitSubType] then
            PlayerSuitTypeFuncTable[SuitSubType](self, SuitSubType, SuitSubBase)
        end
    end
end


function GameModeQuestMgr:BGMParamsSuitRecover(SuitType, SuitSubBase)
	if not SuitSubBase or SuitSubBase:IsEmpty() then
		-- DebugPrint("BGMParamsSuitRecover is Empty", SuitType)
		return
	end
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
	for _, SuitValue in pairs(SuitSubBase) do -- SuitValue ----> BGMParam ----> Str
		-- DebugPrint("BGMParamsSuitRecover", _, SuitValue)
		AudioManager(Player):SetCondition(SuitValue, true)
	end
end

function GameModeQuestMgr:NpcHideShowTagSuitRecover(SuitType, SuitSubBase)
    if not SuitSubBase or SuitSubBase:IsEmpty() then return end
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if not GameMode then return end
    for SuitKey, SuitValue in pairs(SuitSubBase) do
        GameMode.GameState:HideCustomNpcsByAtmosphereTag(SuitValue, SuitKey)
    end
end

function GameModeQuestMgr:NpcExpressionSuitRecover(SuitType, SuitSubBase)
    if not SuitSubBase or SuitSubBase:IsEmpty() then return end
	local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
	if not GameState then return end
    for SuitKey, SuitValue in pairs(SuitSubBase) do
        local TargetNpc = GameState.NpcCharacterMap:FindRef(SuitKey)
		if TargetNpc then
			if DataMgr.Npc[SuitKey] then
				local DefaultActionData = DataMgr.Npc[SuitKey].DefaultAction
				TargetNpc.StaticCreatorDefaultActionIndex = SuitValue.DefaultActionId
				if DefaultActionData and DefaultActionData[SuitValue.DefaultActionId] then
					TargetNpc:NewPlayAction(DefaultActionData[SuitValue.DefaultActionId])
				end
			end

			if DataMgr.Npc[SuitKey] then
				local DefaultFacialData = DataMgr.Npc[SuitKey].DefaultExpression
				TargetNpc.StaticCreatorDefaultFacialIndex = SuitValue.ExpressionId
				if DefaultFacialData and DefaultFacialData[SuitValue.ExpressionId] then
					TargetNpc:NewPlayFacial(DefaultFacialData[SuitValue.ExpressionId])
				end
			end

		end
    end
end

function GameModeQuestMgr:DropRuleSuitRecover(SuitType, SuitSubBase)
    if not SuitSubBase or SuitSubBase:IsEmpty() then return end
    for SuitKey, SuitValue in pairs(SuitSubBase) do
        self.LevelGameMode.DropRule[tonumber(SuitKey)] = SuitValue
    end
end

function GameModeQuestMgr:ContinuedGuideSuitRecover(SuitType, SuitSubBase)
    if not SuitSubBase or SuitSubBase:IsEmpty() then return end
    for SuitKey, SuitValue in pairs(SuitSubBase) do
        self:SetContinuedPCGuideVisibility(SuitKey, SuitValue)
    end
end

-- function GameModeQuestMgr:SwitchRoleSuitRecover(SuitType, RoleId)
--     if not RoleId then return end
--     if RoleId > 0 then
--         self:SwitchToQuestRole(RoleId)
--     end
-- end

function GameModeQuestMgr:DisableSkillSuitRecover(SuitType, SuitSubBase)
    if not SuitSubBase or SuitSubBase:IsEmpty() then return end
    local InActiveSkills = TArray(0)
    for SuitKey, SuitValue in pairs(SuitSubBase) do
        if SuitValue then
            local SkillId = UE4.ESkillName[SuitKey]
            InActiveSkills:Add(SkillId)
        end
    end
    local Controller = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local PlayerController = Controller:Cast(UE4.ASinglePlayerController)
    PlayerController:InActiveSkills(InActiveSkills, "Lock")
end


function GameModeQuestMgr:DisableWeaponSuitRecover(SuitType, SuitSubBase)
    if not SuitSubBase or SuitSubBase:IsEmpty() then return end
    for SuitKey, SuitValue in pairs(SuitSubBase) do
        -- DebugPrint("ZJT_ DisableWeaponRecover Print Suit Info ", SuitKey, SuitValue[1], SuitValue[2], SuitValue[3])
        local WeaponTags = {SuitKey}
        local Controller = UE4.UGameplayStatics.GetPlayerController(self, 0)
        Controller:SetAndForbidWeaponByWeaponTag(WeaponTags, SuitValue.bForbid, SuitValue.ForbidTag, SuitValue.bHideWhenForbid)
    end
end

function GameModeQuestMgr:SwitchStoryModeSuitRecover(SuitType, SuitSubBase)
    if not SuitSubBase or SuitSubBase:IsEmpty() then return end
    for SuitKey, SuitValue in pairs(SuitSubBase) do ---- 这里其实table只有一个数据集
        local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
        PlayerController:SetStoryModeState(SuitValue)
    end
end

function GameModeQuestMgr:HideUIInScreenSuitRecover(SuitType, SuitSubBase)
    if not SuitSubBase or SuitSubBase:IsEmpty() then return end
    for SuitKey, SuitValue in pairs(SuitSubBase) do
        self:HideUIInScreen(SuitKey, SuitValue, "HideUIInScreenSuitRecover")
    end
end

function GameModeQuestMgr:BGMSuitRecover(SuitType, SuitSubBase)
    if not SuitSubBase or SuitSubBase:IsEmpty() then return end
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    for SuitKey, SuitValue in pairs(SuitSubBase:all_dump(SuitSubBase)) do
        local Event = AudioManager(Player):GetFMODEventByPath_Sync(SuitValue.BgmPath)
        DebugPrint("BGMSuitRecover", SuitKey, SuitValue.BgmPath, SuitValue.BgmSubRegionId)
		PrintTable(SuitValue.BgmSubRegionId, 3)
        AudioManager(Player):PlayLevelSound(tonumber(SuitKey), Event, SuitValue.BgmSubRegionId, {}, SuitValue.BgmParam,
			SuitValue.BgmParamValue, false,  true)
    end
end

function GameModeQuestMgr:MonsterFirstSeenGuideSuitRecover(SuitType, Enable)
	if not Enable or Enable:IsEmpty() then return end
	local GameState = UE4.UGameplayStatics.GetGameState(self)
	if GameState then
		for SuitKey, SuitValue in pairs(Enable) do
			GameState.MonsterFirstSeenEnabled = SuitValue
		end
	end
end


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
----------------------------------------- 任务链 ----------------------------------------------------

function GameModeQuestMgr:RecoverDataByQuestChainId(QuestChainId, QuestId)
	-- 根据切片回退任务数据
	if not QuestChainId then
		return
	end
	local RegionDataMgr = self:GetRegionDataMgrSubSystem()
	if not RegionDataMgr then
		return
	end
	DebugPrint("RecoverDataByQuestChainId: 任务链:【" .. tostring(QuestChainId) .. "】失败，开始回退 ")
	local DelCount = 0
	local DelDataCount = 0
    local DelWorldRegionEid = {}
	-- 删除旧的
	-- local GameState = UE4.UGameplayStatics.GetGameState(GameMode)
	for _, Obj in pairs(self.EMGameState.MonsterMap) do
		if IsValid(Obj) and not Obj:IsDead() then
			if Obj.QuestChainId == QuestChainId then
				DelCount = DelCount + 1
                table.insert(DelWorldRegionEid, Obj.WorldRegionEid)
				if RegionDataMgr:ClientCacheExist(Obj.WorldRegionEid) then
					Obj:EMActorDestroy(EDestroyReason.LevelUnloadedSaveGame)
				else
					Obj:EMActorDestroy(EDestroyReason.QuestChainClear)
				end
			end
		end
	end

    for _, Obj in pairs(self.EMGameState.NpcMap) do
		if IsValid(Obj) and not Obj:IsDead() then
			if Obj.QuestChainId == QuestChainId then
				DelCount = DelCount + 1
                table.insert(DelWorldRegionEid, Obj.WorldRegionEid)
				if RegionDataMgr:ClientCacheExist(Obj.WorldRegionEid) then
					Obj:EMActorDestroy(EDestroyReason.LevelUnloadedSaveGame)
				else
					Obj:EMActorDestroy(EDestroyReason.QuestChainClear)
				end
			end
		end
	end

	for _, Obj in pairs(self.EMGameState.CombatItemMap) do
		if IsValid(Obj) then
			if Obj.QuestChainId == QuestChainId or (QuestId and Obj.QuestId == QuestId) then
				DelCount = DelCount + 1
				table.insert(DelWorldRegionEid, Obj.WorldRegionEid)
				if not Obj.BpBorn then
					if RegionDataMgr:ClientCacheExist(Obj.WorldRegionEid) then
						RegionDataMgr:RecoverRegionActorDataStateValue(Obj.WorldRegionEid)
						Obj:EMActorDestroy(EDestroyReason.LevelUnloadedSaveGame)
					else
						Obj:EMActorDestroy(EDestroyReason.QuestChainClear)
					end
				else
					RegionDataMgr:RecoverRegionActorDataStateValue(Obj.WorldRegionEid)
					Obj:RecoverBpBornData()
				end
			end
		end
	end

	RegionDataMgr:DeleteQuestChainDataNotInClientCache(QuestChainId)
	local TotalCount = DelDataCount + DelCount
	
	
    -- 开始恢复
    -- local QuestRegionDatas = RegionDataMgr.DataLibrary:GetRegionCacheDatasByIdType(ERegionDataType.RDT_QuestData)

    -- local RecoverWorldRegionEid = {}
	-- local RecoverCount = 0
    -- for SubRegionId, Datas_1 in pairs(QuestRegionDatas) do
    -- 	for LevelName, Datas_2 in pairs(Datas_1) do
    -- 		for WorldRegionEid, UnitRegionData in pairs(Datas_2) do
    -- 			if UnitRegionData.QuestChainId == QuestChainId then
    -- 				RecoverCount = RecoverCount + 1
    --                 table.insert(RecoverWorldRegionEid, UnitRegionData.WorldRegionEid)
    -- 				self.EMGameState.EventMgr:CreateUnit(self:GetRegionDataMgrSubSystem().DataPool:CompleteRegionData(UnitRegionData)) 
	-- 			end
    -- 		end
    -- 	end
    -- end
    -- DebugPrint("RecoverDataByQuestChainId: 任务链:【" .. tostring(QuestChainId) .. "】失败回退   一共恢复了"..RecoverCount.."个数据")

    -- -- 打印所有被删除和被恢复的worldRegionEid
    -- if self:GetRegionDataMgrSubSystem().DataLibrary.LogHelper:IsRegionLogEnabled() then
    --     print(_G.LogTag, "RecoverDataByQuestChainId  任务失败销毁数据   ")
    --     for _, WorldRegionEid in pairs(DelWorldRegionEid) do
    --         print(_G.LogTag, "RecoverDataByQuestChainId  Del   ", WorldRegionEid)
    --     end
    --     print(_G.LogTag, "RecoverDataByQuestChainId  任务失败恢复数据   ")
    --     for _, WorldRegionEid in pairs(RecoverWorldRegionEid) do
    --         print(_G.LogTag, "RecoverDataByQuestChainId  Recover   ", WorldRegionEid)
    --     end
    -- end
	
    --重发一遍wc的事件
    self:TriggerLoadedEvent(true)
end

function GameModeQuestMgr:RecoverDataAndStopBySpecialQuest(QuestChainId, SpecialQuestId)
	-- 根据切片回退任务数据
	if not QuestChainId then
		return
	end
	local RegionDataMgr = self:GetRegionDataMgrSubSystem()
	if not RegionDataMgr then
		return
	end
	DebugPrint("RecoverDataAndStopBySpecialQuest: 任务链:【" .. tostring(QuestChainId) .. "】特殊任务:【"..tostring(SpecialQuestId).."】中断其他任务清理数据 ")
	for _, Obj in pairs(self.EMGameState.MonsterMap) do
		if IsValid(Obj) and not Obj:IsDead() then
			if Obj.QuestChainId > 0 and Obj.QuestChainId ~= QuestChainId then
				if RegionDataMgr:ClientCacheExist(Obj.WorldRegionEid) then
					Obj:EMActorDestroy(EDestroyReason.SepcialQuestStart)
				else
					Obj:EMActorDestroy(EDestroyReason.QuestChainClear)
				end
			end
		end
	end

    for _, Obj in pairs(self.EMGameState.NpcMap) do
		if IsValid(Obj) and not Obj:IsDead() then
			if Obj.QuestChainId > 0 and Obj.QuestChainId ~= QuestChainId then
				if RegionDataMgr:ClientCacheExist(Obj.WorldRegionEid) then
					Obj:EMActorDestroy(EDestroyReason.SepcialQuestStart)
				else
					Obj:EMActorDestroy(EDestroyReason.QuestChainClear)
				end
			end
		end
	end

	for _, Obj in pairs(self.EMGameState.CombatItemMap) do
		if IsValid(Obj) then
			if Obj.QuestChainId > 0 and Obj.QuestChainId ~= QuestChainId then
				if not Obj.BpBorn then
					if RegionDataMgr:ClientCacheExist(Obj.WorldRegionEid) then
						RegionDataMgr:RecoverRegionActorDataStateValue(Obj.WorldRegionEid)
						Obj:EMActorDestroy(EDestroyReason.SepcialQuestStart)
					else
						Obj:EMActorDestroy(EDestroyReason.QuestChainClear)
					end
				else
					RegionDataMgr:RecoverRegionActorDataStateValue(Obj.WorldRegionEid)
					Obj:RecoverBpBornData()
				end
			end
		end
	end

	RegionDataMgr:DeleteExceptQuestChainDataNotInClientCache(QuestChainId)
end

function GameModeQuestMgr:UpdateQuestRegionDatas(QuestChainId, RegionUpdataData)
	DebugPrint("任务链:【"..tostring(QuestChainId).."】更新数据量:"..tostring(#RegionUpdataData))
	local QuestRegionDatas = self:GetRegionDataMgrSubSystem().DataLibrary:GetRegionCacheDatasByIdType(ERegionDataType.RDT_QuestData)
	for _, RegionData in pairs(QuestRegionDatas) do
		for _, LevelData in pairs(RegionData) do
			for _, WorldRegionEid in pairs(CommonUtils.Keys(LevelData)) do
				local UnitRegionData = LevelData[WorldRegionEid]
				if UnitRegionData.QuestChainId == QuestChainId then
					self:GetRegionDataMgrSubSystem().DataLibrary:RemoveUnitRegionCacheData(WorldRegionEid)
					DebugPrint("任务链:【"..tostring(QuestChainId).."】删除了:"..tostring(UnitRegionData.WorldRegionEid))
				end
			end
		end
	end

	for _, UnitRegionData in ipairs(RegionUpdataData) do
		self:GetRegionDataMgrSubSystem().DataLibrary:AddUnitRegionCacheData(UnitRegionData)
		DebugPrint("任务链:【"..tostring(QuestChainId).."】添加了:"..tostring(UnitRegionData.WorldRegionEid))
	end	
end

function GameModeQuestMgr:GetRegionQuestChainUpdateData(QuestChainId)
	if URuntimeCommonFunctionLibrary.UseCppRegionData(GWorld.GameInstance) then
		local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
		-- todo @fanyuxiao 看看QuestChainData需不需要DeepCopy--done by smh
		return GameMode:GetRegionDataMgrSubSystem():GetQuestChainData(QuestChainId)
	end
	if not QuestChainId then
		return {}
	end

	-- local Avatar = GWorld:GetAvatar()

	local RegionUpdataData = {}
	local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
	for _, Obj in pairs(GameState.MonsterMap) do
		if IsValid(Obj) and not Obj:IsDead() then
			if Obj.QuestChainId == QuestChainId then
				if Obj.RegionDataType ~= ERegionDataType.RDT_QuestData then
					ScreenPrint("任务成功：任务链【" .. tostring(QuestChainId) .. "】数据里包含非任务数据:Name：" .. Obj:GetName() .. "，WorldRegionEid:【" .. tostring(Obj.WorldRegionEid) .. "】,RegionDataType:【" .. tostring(Obj.RegionDataType) .. "】")
				end
				-- RegionUpdataData[Obj.WorldRegionEid] = GameMode:ConstructUnitRegionDataByUnit(Obj)
				table.insert(RegionUpdataData, self:GetRegionDataMgrSubSystem().DataLibrary:ConstructUnitRegionDataByUnit(Obj))
			end
		end
	end

    for _, Obj in pairs(GameState.NpcMap) do
		if IsValid(Obj) and not Obj:IsDead() then
			if Obj.QuestChainId == QuestChainId then
				if Obj.RegionDataType ~= ERegionDataType.RDT_QuestData then
					ScreenPrint("任务成功：任务链【" .. tostring(QuestChainId) .. "】数据里包含非任务数据:Name：" .. Obj:GetName() .. "，WorldRegionEid:【" .. tostring(Obj.WorldRegionEid) .. "】,RegionDataType:【" .. tostring(Obj.RegionDataType) .. "】")
				end
				-- RegionUpdataData[Obj.WorldRegionEid] = GameMode:ConstructUnitRegionDataByUnit(Obj)
				table.insert(RegionUpdataData, self:GetRegionDataMgrSubSystem().DataLibrary:ConstructUnitRegionDataByUnit(Obj))
			end
		end
	end

	for _, Obj in pairs(GameState.CombatItemMap) do
		if IsValid(Obj) then
			if Obj.QuestChainId == QuestChainId then
				-- RegionUpdataData[Obj.WorldRegionEid] = GameMode:ConstructUnitRegionDataByUnit(Obj)
				if Obj.RegionDataType ~= ERegionDataType.RDT_QuestData then
					ScreenPrint("任务成功：任务链【" .. tostring(QuestChainId) .. "】数据里包含非任务数据:Name：" .. Obj:GetName() .. "，WorldRegionEid:【" .. tostring(Obj.WorldRegionEid) .. "】,RegionDataType:【" .. tostring(Obj.RegionDataType) .. "】")
				end
				table.insert(RegionUpdataData, self:GetRegionDataMgrSubSystem().DataLibrary:ConstructUnitRegionDataByUnit(Obj))
			end
		end
	end

    local RegionSSDatas = self:GetRegionDataMgrSubSystem().DataLibrary:GetRegionSSDatas()

    if RegionSSDatas~=nil then
        for _, LevelData in pairs(RegionSSDatas) do
            for _, UnitRegionData in pairs(LevelData) do
                if UnitRegionData.QuestChainId == QuestChainId then
                    -- RegionUpdataData[UnitRegionData.WorldRegionEid] = UnitRegionData
                    if UnitRegionData.RegionDataType ~= ERegionDataType.RDT_QuestData then
                        ScreenPrint("任务成功：任务链【" .. tostring(QuestChainId) .. "】数据里包含非任务数据:WorldRegionEid:【" .. tostring(UnitRegionData.WorldRegionEid) .. "】,RegionDataType:【" .. tostring(UnitRegionData.RegionDataType) .. "】")
                    end
                    -- SSData里的，目前都要深拷贝出来
                    table.insert(RegionUpdataData, CommonUtils.DeepCopy(UnitRegionData))
                end
            end
        end
    end

	return RegionUpdataData
end

function GameModeQuestMgr:GetRegionQuestCommonUpdateData(QuestId)
	if not QuestId then
		return {}
	end

	-- local Avatar = GWorld:GetAvatar()

	local RegionUpdataData = {}
	local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
	for _, Obj in pairs(GameState.MonsterMap) do
		if IsValid(Obj) and not Obj:IsDead() then
			if Obj.QuestId == QuestId then
				if Obj.RegionDataType ~= ERegionDataType.RDT_QuestCommonData then
					ScreenPrint("任务成功：任务【" .. tostring(QuestId) .. "】数据里包含非任务数据:Name：" .. Obj:GetName() .. "，WorldRegionEid:【" .. tostring(Obj.WorldRegionEid) .. "】,RegionDataType:【" .. tostring(Obj.RegionDataType) .. "】")
				end
				-- RegionUpdataData[Obj.WorldRegionEid] = GameMode:ConstructUnitRegionDataByUnit(Obj)
				table.insert(RegionUpdataData, self:GetRegionDataMgrSubSystem().DataLibrary:ConstructUnitRegionDataByUnit(Obj))
			end
		end
	end

    for _, Obj in pairs(GameState.NpcMap) do
		if IsValid(Obj) and not Obj:IsDead() then
			if Obj.QuestId == QuestId then
				if Obj.RegionDataType ~= ERegionDataType.RDT_QuestCommonData then
					ScreenPrint("任务成功：任务【" .. tostring(QuestId) .. "】数据里包含非任务数据:Name：" .. Obj:GetName() .. "，WorldRegionEid:【" .. tostring(Obj.WorldRegionEid) .. "】,RegionDataType:【" .. tostring(Obj.RegionDataType) .. "】")
				end
				-- RegionUpdataData[Obj.WorldRegionEid] = GameMode:ConstructUnitRegionDataByUnit(Obj)
				table.insert(RegionUpdataData, self:GetRegionDataMgrSubSystem().DataLibrary:ConstructUnitRegionDataByUnit(Obj))
			end
		end
	end

	for _, Obj in pairs(GameState.CombatItemMap) do
		if IsValid(Obj) then
			if Obj.QuestId == QuestId then
				-- RegionUpdataData[Obj.WorldRegionEid] = GameMode:ConstructUnitRegionDataByUnit(Obj)
				if Obj.RegionDataType ~= ERegionDataType.RDT_QuestCommonData then
					ScreenPrint("任务成功：任务【" .. tostring(QuestId) .. "】数据里包含非任务数据:Name：" .. Obj:GetName() .. "，WorldRegionEid:【" .. tostring(Obj.WorldRegionEid) .. "】,RegionDataType:【" .. tostring(Obj.RegionDataType) .. "】")
				end
				table.insert(RegionUpdataData, self:GetRegionDataMgrSubSystem().DataLibrary:ConstructUnitRegionDataByUnit(Obj))
			end
		end
	end

    local RegionSSDatas = self:GetRegionDataMgrSubSystem().DataLibrary:GetRegionSSDatas()

    if RegionSSDatas~=nil then
        for _, LevelData in pairs(RegionSSDatas) do
            for _, UnitRegionData in pairs(LevelData) do
                if UnitRegionData.QuestId == QuestId then
                    -- RegionUpdataData[UnitRegionData.WorldRegionEid] = UnitRegionData
                    if UnitRegionData.RegionDataType ~= ERegionDataType.RDT_QuestCommonData then
                        ScreenPrint("任务成功：任务链【" .. tostring(QuestId) .. "】数据里包含非任务数据:WorldRegionEid:【" .. tostring(UnitRegionData.WorldRegionEid) .. "】,RegionDataType:【" .. tostring(UnitRegionData.RegionDataType) .. "】")
                    end
                    -- SSData里的，目前都要深拷贝出来
                    table.insert(RegionUpdataData, CommonUtils.DeepCopy(UnitRegionData))
                end
            end
        end
    end

	return RegionUpdataData
end


function GameModeQuestMgr:HandleQuestChainFinish(QuestChainId)
	if not QuestChainId then
		return
	end

	self:ClearRegionActorData("QuestChainId", QuestChainId, EDestroyReason.QuestChainClear, function(Target, Key, Value)
        return Target.QuestChainId == Value
    end)
	self:UpdateQuestRegionDatas(QuestChainId, {})

	local QuestRegionDatas = self:GetRegionDataMgrSubSystem().DataLibrary:GetRegionCacheDatasByIdType(ERegionDataType.RDT_QuestData)
	for _, RegionData in pairs(QuestRegionDatas) do
		for _, LevelData in pairs(RegionData) do
			for _, WorldRegionEid in pairs(CommonUtils.Keys(LevelData)) do
				local UnitRegionData = LevelData[WorldRegionEid]
				if UnitRegionData.QuestChainId == QuestChainId then
					-- RegionUtils.RegionDatas.RemoveUnitRegionData(WorldRegionEid)
					GWorld.logger.error("@wangpengshu 任务链:【"..tostring(QuestChainId).."】完成了，但是服务器数据中仍有该任务链的数据残留:"..tostring(UnitRegionData.WorldRegionEid))
				end
			end
		end
	end

	local RegionUpdateDatas = self:GetRegionQuestChainUpdateData(QuestChainId)
	if RegionUpdateDatas then
		for _, UnitRegionData in ipairs(RegionUpdateDatas) do
	        GWorld.logger.error("@wangpengshu 任务链:【"..tostring(QuestChainId).."】完成了，但是场景中仍有该任务链的数据残留:"..tostring(UnitRegionData.WorldRegionEid))
	    end
	end
end


-- 清除任务链相关Actor的数据，以及将他们Destory(目前只有怪物和机关)
function GameModeQuestMgr:ClearRegionActorData(Key, Value, DestroyReason, FilterFunction)
    GWorld.logger.info("ClearRegionActorData:【" .. tostring(Key) .. "】:【"..tostring(Value).."】,DestoryReanon = " .. tostring(DestroyReason))
    if not Key or not Value or not DestroyReason then
        return
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        GWorld.logger.error("ClearRegionActorData Avatar Is nil !!!!!!!!!!!")
        return
    end

    self:ClearRegionData_DestroyActor(Key, Value, DestroyReason, FilterFunction)
    -- SSData
    local RegionDataMgr = self:GetRegionDataMgrSubSystem()
    local RegionSSDatas = RegionDataMgr.DataLibrary:GetRegionSSDatas()

    for LevelName, LevelData in pairs(RegionSSDatas or {}) do
        for WorldRegionEid, UnitRegionData in pairs(LevelData) do
            if FilterFunction(UnitRegionData, Key, Value) then
                GWorld.logger.debug("ClearRegionActorData:【" .. tostring(Key) .. "】:【"..tostring(Value).."】销毁 SSData WorldRegionEid = " .. tostring(WorldRegionEid))
                RegionDataMgr.DataLibrary:RemoveRegionSSDatas(LevelName, WorldRegionEid)
            end
        end
    end

    -- DataPool
	if Key == "DynamicQuestId" then
		RegionDataMgr:RemoveDynamicQuestData(Value, DestroyReason)
	elseif Key == "SpecialQuestId" then
		RegionDataMgr:RemoveSpecialQuestData(Value, DestroyReason)
	else
    	RegionDataMgr:RemoveQuestChainData(Value, DestroyReason)
	end

    GWorld.logger.info("ClearRegionActorData:【" .. tostring(Key) .. "】:【"..tostring(Value).."】完成了ClearRegionActorData成功")
end

function GameModeQuestMgr:ClearRegionData_DestroyActor(Key, Value, DestroyReason, FilterFunction)
    if not Key or not Value or not DestroyReason then
        return
    end
    -- 怪物
    for _, Monster in pairs(self.GameState.MonsterMap) do
        if IsValid(Monster) and (not Monster:IsDead() or Monster:IsMonWaitForCaught()) and FilterFunction(Monster, Key, Value) then
            GWorld.logger.debug("ClearRegionActorData:【" .. tostring(Key) .. "】:【"..tostring(Value).."】销毁 Monster Eid = " .. tostring(Monster.Eid))
            Monster:EMActorDestroy(DestroyReason)
        end
    end

    -- Npc
    for _,Monster in pairs(self.GameState.NpcMap) do
        if IsValid(Monster) and not Monster:IsDead() and FilterFunction(Monster, Key, Value) then
            GWorld.logger.debug("ClearRegionActorData:【" .. tostring(Key) .. "】:【"..tostring(Value).."】销毁 Npc Eid = " .. tostring(Monster.Eid))
            Monster:EMActorDestroy(DestroyReason)
        end
    end

    -- 机关
    for _, CombatItem in pairs(self.GameState.CombatItemMap) do
        if IsValid(CombatItem) and FilterFunction(CombatItem, Key, Value) then
            GWorld.logger.debug("ClearRegionActorData:【" .. tostring(Key) .. "】:【"..tostring(Value).."】销毁 CombatItem Eid = " .. tostring(CombatItem.Eid))
            CombatItem:EMActorDestroy(DestroyReason)
        end
    end
end


--------------------------------------Quest 驱动Art关卡加卸载 Begin--------------------------------------------------
-- 任务通知触发Art更改
function GameModeQuestMgr:TriggerQuestArtLevelChange(Params)
	if Params == nil or next(Params) == nil then
		DebugPrint("GameModeQuestMgr:TriggerQuestArtLevelChange 触发参数Params为空")
		return
	end
    if self:IsInDungeon() then
    	DebugPrint("GameModeQuestMgr:TriggerQuestArtLevelChange 当前在副本无法触发")
    	return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
    	DebugPrint("GameModeQuestMgr:TriggerQuestArtLevelChange 当前无Avatar无法触发")
    	return
    end
    local SubRegionId = Avatar:GetCurrentRegionId()
	local SubRegionData = DataMgr.SubRegion[SubRegionId]
	if not SubRegionData then
		DebugPrint("GameModeQuestMgr:TriggerQuestArtLevelChange 当前处于错误子区域，无法触发。RegionId: ",SubRegionId) 
		return
	end
	local RegionId = SubRegionData.RegionId
    for VarName, Param in pairs(Params) do
    	if Param == nil or next(Param) == nil then
			local ct = {
				"报错文本:\n\t",
				"VarName:",VarName,"\n"
			}
			local FinalMsg = table.concat(ct)
			Avatar:SendToFeiShuForRegionMgr(FinalMsg, "任务触发Level加卸载 | 传递数据Value为空")
			return
		end
    	if Param.OldValue == Param.NewValue then
			local ct = {
				"报错文本:\n\t",
				"TriggerQuestArtLevelChange:任务触发VarName改变值相同!  请检查配置!   VarName::",VarName,"\n"
			}
			local FinalMsg = table.concat(ct)
			Avatar:SendToFeiShuForRegionMgr(FinalMsg, "任务触发Level加卸载 | 任务触发VarName改变值相同")
    	end
    	local BlackScreenEnable = (Param.NewValue == 1)
    	GWorld.logger.debug("TriggerQuestArtLevelChange: 任务触发Art加卸载 RegionId: "..RegionId.." VarName: "..VarName.." Param.NewValue:"..Param.NewValue)
    	self:RealQuestArtLevelChange(RegionId, VarName, BlackScreenEnable, Param.NewValue)
    end
	if self.bNeedRefreshNav then
		self:RefreshNavAfterChangingLevelLoadingState()
	end
end

-- 进去区域主动更新任务Art
function GameModeQuestMgr:UpdateQuestArtLevel()
	self.QuestArtLevelChangeLevelName = ""
	local Avatar = GWorld:GetAvatar()
    local SubRegionId = Avatar:GetCurrentRegionId()
	local SubRegionData = DataMgr.SubRegion[SubRegionId]
	if not SubRegionData or not SubRegionData.RegionId then 
		return
	end
	local RegionId = SubRegionData.RegionId
	local QuestVar = DataMgr.ArtLevelControl_RegionId2TaskVar[RegionId]
	if not QuestVar then 
		return
	end
	for i, VarName in pairs(QuestVar) do
		local VarValue = Avatar.StoryVariable[VarName]
		-- VarValue = 1
		if VarValue == 1 then
			GWorld.logger.debug("TriggerQuestArtLevelChange: 进去区域任务触发Art加卸载 RegionId: "..RegionId.." VarName: "..VarName.."  BlackScreen: false   Param.NewValue:"..VarValue)
			self:RealQuestArtLevelChange(RegionId, VarName, false, VarValue)
		end
	end
	if self.bNeedRefreshNav then
		self:RefreshNavAfterChangingLevelLoadingState()
	end
end

function GameModeQuestMgr:RealQuestArtLevelChange(RegionId, VarName, BlackScreenEnable, LoadEnable)
	if DataMgr.ArtLevelControl_TaskVar2Data[VarName] == nil then
		GWorld.logger.error("BP_EMGameMode_C:RealQuestArtLevelChange VarName Not In DataMgr. VarName:"..VarName)
		return
	end
	local Info = DataMgr.ArtLevelControl_TaskVar2Data[VarName][RegionId]
	if not Info then
		GWorld.logger.error("BP_EMGameMode_C:RealQuestArtLevelChange Player 当前不处于要改变的区域，RegionId: "..RegionId)
		return
	end
	if Info["LoadLevel"] == nil then
		GWorld.logger.error("BP_EMGameMode_C:RealQuestArtLevelChange 导表数据有问题，找不到LoadLevel, VarName: "..VarName.."   RegionId:  "..RegionId)
		return
	end
	local LoadArray = TArray(FString)
	local UnloadArray = TArray(FString)
	local NeedNotifyLevels = TSet(FString)

	-- for i,Value in pairs(Info["LoadLevel"]) do
	-- 	if LoadEnable == 1 then
	-- 		LoadArray:Add(Value)
	-- 	else
	-- 		UnloadArray:Add(Value)
	-- 	end
	-- end

	if LoadEnable == 1 then
		for i,Value in pairs(Info["LoadLevel"]) do
			LoadArray:Add(Value)
		end
		if Info["UnLoadLevel"] ~= nil then
			for i,Value in pairs(Info["UnLoadLevel"]) do
				UnloadArray:Add(Value)
			end
		end
		
	else
		for i,Value in pairs(Info["LoadLevel"]) do
			UnloadArray:Add(Value)
		end
		if Info["UnLoadLevel"] ~= nil then
			for i,Value in pairs(Info["UnLoadLevel"]) do
				LoadArray:Add(Value)
			end
		end
	end

	if Info["NeedNotifyLevels"] ~= nil then
		for i,Value in pairs(Info["NeedNotifyLevels"]) do
			NeedNotifyLevels:Add(Value)
		end
	end

    -- 只有NewValue == 1 且 导表内填了true 才触发黑屏
    if BlackScreenEnable and Info["BlackScreen"] == true then
    	if self.QuestArtLevelChangeLevelName ~= "" then
    		GWorld.logger.error("BP_EMGameMode_C:RealQuestArtLevelChange 单个任务同时触发了多个Var变量的Art显示: Name1-->"..self.QuestArtLevelChangeLevelName.."   Name2-->  "..Info["LoadLevel"][1])
    	end
    	self.QuestArtLevelChangeLevelName = Info["LoadLevel"][1]
    	self:AddTimer(6, self.QuestTimerEndCloseBlackScreen, false, 0, "QuestArtLevelChange", false)
		UIManager(self):ShowCommonBlackScreen({
			BlackScreenHandle = "QuestArtLevelChange",
	    	InAnimationPlayTime = Info.InTime,
	    	OutAnimationPlayTime = Info.OutTime,
		})
    end
    
    self:ChangeLevelLoadingState(LoadArray, UnloadArray, NeedNotifyLevels)
end

function GameModeQuestMgr:QuestArtLevelChangeCloseBlackScreen(LevelName)
	if UIManager(self) and string.match(self.QuestArtLevelChangeLevelName, LevelName) then
		UIManager(self):HideCommonBlackScreen("QuestArtLevelChange")
		self:RemoveTimer("QuestArtLevelChange")
		self.QuestArtLevelChangeLevelName = ""
	end
end

function GameModeQuestMgr:QuestTimerEndCloseBlackScreen(LevelName)
	GWorld.logger.error("ERROR!!! QuestTimerEndCloseBlackScreen 任务改变ART关卡触发了定时器保底黑屏，请联系程序检查！ LevelPath:::"..self.QuestArtLevelChangeLevelName)
	if UIManager(self) then
		UIManager(self):HideCommonBlackScreen("QuestArtLevelChange")
		self.QuestArtLevelChangeLevelName = ""
	end
end

--------------------------------------Quest 驱动Art关卡加卸载 End--------------------------------------------------

return GameModeQuestMgr

