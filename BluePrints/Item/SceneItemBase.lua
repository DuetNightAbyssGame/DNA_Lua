require "UnLua"

local SceneItemBase = Class({
    "BluePrints.Common.TimerMgr",
    "BluePrints.Combat.Components.EffectSourceInterface"--为了避免多重继承的问题，只能放基类了
})

SceneItemBase._components = {
    "BluePrints.Combat.Components.ActorTypeComponent",
    "BluePrints.Char.CharacterComponent.AddGuideComponent",
}

function SceneItemBase:ReceiveBeginPlay()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    -- @SnowMoon 监听battle并尝试初始化，如果已经有battle则会成功初始化，否则会等待battle触发场景Actor集体初始化
    EventManager:AddEvent(EventID.OnBattleReady, self, self.OnBattleReady_TryInitCharacterInfo)
    self.Overridden.ReceiveBeginPlay(self)
    if self.BpBorn and IsAuthority(self) then
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        GameMode.BPBornActor:AddUnique(self)
        if self.ManualItemId ~= -1 then
            GameMode.BPBornRegionActor:Add(self.ManualItemId, self)
        end

		if GameMode:IsInRegion() then
			self:RegionInitBpActor()
            self:SetCachedMaxDrawDistance(10000)
		else
            local Context = AEventMgr.CreateUnitContext()
            Context.UnitType = self.UnitType
            Context.UnitId = self.UnitId
            -- Context.VectorParams:Add("BornLoc", BornLoc)
            self:RegisterInfoNew(Context)
		end
	end
    self.IsDestroied = false
end

function SceneItemBase:OnBattleReady_TryInitCharacterInfo(_Battle)
    if Battle(self) == _Battle then
        self:TryInitActorInfo("Battle")
    end
end

-- function SceneItemBase:IsAOITriggerBox()
--     local RealUnitType = self:GetUnitRealType()
--     return RealUnitType == "AOITriggerBox" or RealUnitType == "AOITriggerSphere" or RealUnitType == "AOITriggerSpecialQuest"
-- 	or RealUnitType == "AOITriggerCapsule"
-- end

function SceneItemBase:RegionInitBpActor()
	local BpBornRegionActorID = self.ManualItemId
	local SubSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, URegionDataMgrSubsystem:StaticClass())
	local ManualItemData = SubSystem:GetManualItemData(BpBornRegionActorID)
	if not ManualItemData then
        local Context = AEventMgr.CreateUnitContext()
        Context.UnitType = self.UnitType
        Context.UnitId = self.UnitId
        Context.IntParams:Add("RegionDataType", self.RegionDataType)
        Context.IntParams:Add("QuestChainId", self.QuestChainId)
        Context.BoolParams:Add("IsFullRegionStore", self.IsFullRegionStore)
        Context.VectorParams:Add("BornLoc", self:K2_GetActorLocation())
        Context.ExtraRegionInfo = {
            SpecialQuestId = self.ExtraRegionInfo.SpecialQuestId,
            DynQuestId = self.ExtraRegionInfo.DynQuestId
        }
        self:RegisterInfoNew(Context)
	end
end
--LoadRegionInfo内有QuestChainId，RegionDataType和RarelyId在SetActorRegionInfo_SceneItemBase_New处理，避免初始化的时候读取lua
-- function SceneItemBase:OnClaimRegionData_Lua(LuaTableIndex)
-- 	local SubSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, URegionDataMgrSubsystem:StaticClass())
-- 	if SubSystem then
-- 		self.RegionDataType = SubSystem.DataPool.RegionData[LuaTableIndex].RegionDataType
-- 		self.QuestChainId = SubSystem.DataPool.RegionData[LuaTableIndex].QuestChainId
-- 		self.RarelyId = SubSystem.DataPool.RegionData[LuaTableIndex].RarelyId
-- 	end
-- end

function SceneItemBase:RegisterInfo(Info)
    if Info then
        self.InfoForInit = Info
    end

    self:TryInitActorInfo("InitInfo")
end

function SceneItemBase:OnRep_ServerInitSuccess()
    if self.ServerInitSuccess then
        self.InfoForInitNew.UnitId = self.UnitId
        self.InfoForInitNew.UnitType = self.UnitType
        self:TryInitActorInfo("InitInfo")
    else
        self.InitSuccess=false
    end
end

function SceneItemBase:BeginInitInfo()
    if self.InitSuccess then
        return
    end
    self:InitActorInfo_New()
end

function SceneItemBase:OnEMActorDestroy(DestroyReason)
    self.Overridden.OnEMActorDestroy(self,DestroyReason)
end

function SceneItemBase:WCOnEMActorDestroy(DestroyReason, GameMode)
    local WCSubSystem = GameMode:GetWCSubSystem()
    if not IsValid(WCSubSystem) then 
        return 
    end

    -- if GameMode:IsInRegion() then 
    	if self.BpBorn and (not self:CheckManuItemRegionStorage() or DestroyReason == EDestroyReason.RecoverSubRegionDataCacheButBpBornHasAlreadyDead) then
    		return
    	end
        -- NewRegionEnable
    	if self.WorldRegionEid == "" then
    		if self.Data then
    			GWorld.logger.errorlog("Error : Actor在Destroy时没有赋值WorldRegionEid", self.UnitId, self.UnitType, self.Eid)
    		end
    	else
    		GameMode:GetRegionDataMgrSubSystem():DeadRegionActorData(self, DestroyReason)
    	end
    -- end
    
    WCSubSystem:UnregisterEntryToWorldComposition(self)
end

--通用Actor初始化，子类不应继承,根据需求继承PreInitInfo、AuthorityInitInfo、CommonInitInfo、ClientInitInfo
function SceneItemBase:InitActorInfo(Info)
    -- if Const.UseNewCreateUnit then
    --     return
    -- end
	-- local GameState = UE4.UGameplayStatics.GetGameState(self)
	-- if GameState:IsInRegion() then
	-- 	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	-- 	local BpBornRegionActorID = self.ManualItemId
	-- 	local ManualItemData = GameMode:GetRegionDataMgrSubSystem():GetManualItemData(BpBornRegionActorID)
	-- 	if self.BpBorn then
	-- 		if self:CheckUnitNeedStorage() and self.ManualItemId  == -1 then
	-- 			GWorld.logger.error("BpBorn Actor : " .. self:GetName() .. " 的数据类型需要上传服务器 但ManualItemId == -1")
	-- 			return
	-- 		end
	-- 		if not ManualItemData then
	-- 			self:AllocateBpBornActorData()
	-- 		else
	-- 			self:AllocateRecoveredBpBornActorData(ManualItemData.WorldRegionEid)
	-- 		end
	-- 	end
	-- end
    -- self.InitCheck = true--初始化流程检查标志，如果初始化中把自己销毁则设为false，并中断后续流程
    -- if Info == nil then
    --     Info = self.InfoForInit
    -- end
    -- self:PreInitInfo(Info)
    -- if IsAuthority(self) then
    --     self:AuthorityInitInfo(Info)
    --     if not self.InitCheck then
    --         return
    --     end
    --     self:SnapShotInitInfo(Info.LevelName, Info.Eid)
    -- end
    -- self:CommonInitInfo(Info)
    -- if IsStandAlone(self) or not IsAuthority(self) then
    --     self:ClientInitInfo(Info)
    -- end
    -- if not self:UpdateLevelInfo(Info.UnitId, Info.UnitType, Info.LevelName, Info.EventName, Info.Eid,
    --                             Info.Loc, Info.Creator, Info.MonsterSpawn,
    --                             self, self.IsFromSnapShot,
    --                             self:CheckNeedSnapShot(Const.ECreateSuccess)) then
    --     if Info.LoadFinishCallback then
    --         Info.LoadFinishCallback(self)
    --     end
    --     return
    -- end
    -- self:SetServerInitSuccess(true)
    -- self.InitSuccess = true
    -- if Info.PreReadyCallback then
    --     Info.PreReadyCallback(self)
    -- end
    -- self:OnActorReady(Info)
    -- if Info.LoadFinishCallback then
    --     Info.LoadFinishCallback(self)
    -- end
end

function SceneItemBase:CreateMechanismData_Lua(UnitType, UnitId)
    self.Data = DataMgr[UnitType][UnitId]
    if self.Data then
        return true
    else
        return false
    end
end

function SceneItemBase:PreInitInfo(Info)
    -- if Const.UseNewCreateUnit then
    --     return
    -- end
    -- self:PreInitInfo_Cpp(Info.UnitId,Info.UnitType,Info.SourceEid or 0,Info.IsFullRegionStore)
    -- self.Data = DataMgr[Info.UnitType][Info.UnitId]
    -- if not self.Data then
    --     assert(self.Data, "SceneItemBase Can't find in Table, UnitId: "..Info.UnitId.." UnitType: "..Info.UnitType)
    --     return
    -- end
    -- self:InitGamePlayTags()
end

function SceneItemBase:InitGamePlayTags()
    self.GameplayTagsInitSuccess = true
end

function SceneItemBase:OnActorReady(Info)
    -- if Const.UseNewCreateUnit then
    --     return
    -- end
    -- if IsAuthority(self) then
    --    self:InitGuideInfo()
    --    self:PostStaticCreatorEvent(Info)
    -- end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode and GameMode:GetWCSubSystem() then
        self:CreateRegionData()
    end
end

-- function SceneItemBase:PostStaticCreatorEvent(Info)
--     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--     GameMode:STLPostStaticCreatorEvent(self, Info)
--     local EventName = Info.StrParams:Find("EventName")
--     if EventName then
--         GameMode:PostStaticCreatorEvent(EventName, self.Eid, self.UnitId, self.UnitType)
--     end
--     if IsValid(Info.Creator) and Info.Creator.OnStaticCreatorChildReadyDelegate:IsBound() then
--         Info.Creator.OnStaticCreatorChildReadyDelegate:Broadcast(self)
--     end
-- end

function SceneItemBase:CommonInitInfo(Info)
    -- if Const.UseNewCreateUnit then
    --     return
    -- end
    -- self:CommonInitInfo_Cpp()
end

function SceneItemBase:AuthorityInitInfo(Info)
    -- if Const.UseNewCreateUnit then
    --     return
    -- end
    -- local GameMode = UE4.UGameplayStatics.GetGameMode(self) -- or (self.BpBorn and self:Cast(ABreakableItem))
    -- self:AuthorityInitInfo_Cpp(Info.Eid,Info.WorldRegionEid)
    -- -- NewRegionEnable
    -- GameMode:GetRegionDataMgrSubSystem():SetActorRegionInfo_SceneItemBase(self, Info)
    -- GameMode:GetRegionDataMgrSubSystem():SetActorRegionCommonInfo_SceneItemBase(self, Info)

    -- -- PickUp triggerbox有重写，如若修改，请一起有重写，如若修改，请一起
    -- -- SaveGame默认为true，特殊需求的在创建物体时传入
    -- if Info.SaveGame ~= nil and Info.Value == false then 
    --     self:SetSaveGameValue(false)
    -- end
    -- if not self.BpBorn  then GameMode:RegionTrytWCRegisterInfo(Info, self) end
    -- if not self.InitCheck then
    --     return
    -- end
	-- self:InitCreatorInfo(Info)
    -- self:UpdateCurrentLevelId()
end

function SceneItemBase:ClientInitInfo()
    -- if Const.UseNewCreateUnit then
    --     return
    -- end
end

--------------------------- 指引 Begin----------------------------------
-- function SceneItemBase:InitGuideInfo()
--     local GameState = UE4.UGameplayStatics.GetGameState(self)
-- 	if GameState:CheckNeedGuide(self.UnitId, self.UnitType, self) and not self.HasGuideClose then
-- 		GameState:AddGuideEid(self.Eid)
-- 	end
-- end

-- function SceneItemBase:CheckInitGuideType()
--     self.GuideType = self.Data.GuideType
--     if not self.GuideType or self.GuideType == 0 then
--         --没填或为0则不自带显示，后续显示时机为手动添加
--         return false
--     end
--     return true
-- end

function SceneItemBase:GetShowGuideDis(InitGuideInfo)
    self.ShowGuideDistance = InitGuideInfo
    return true
end

function SceneItemBase:CreateGuideHandle(bInit)
    if not IsAuthority(self) then
        return
    end
    if self.FixTryToAddGuideHandle or (bInit and self.HasGuideClose) then
        return
    end
    if not self.Data.GuideInfo then
        self.FixTryToAddGuideHandle = self:AddTimer(1, self.TryToAddGuide, true, 0, nil, false)
        return
    end
    self.ShowGuideMinDistance = self.Data.GuideInfo[1]
    self.ShowGuideMaxDistance = self.Data.GuideInfo[2]
    if self.ShowGuideMinDistance * self.ShowGuideMaxDistance < 0 then
        print(_G.LogTag,"LXZ  Error: CombatItemBase Guide Distance Error")
        return
    end
    if self.ShowGuideMaxDistance > 0 then
        self.FixTryToAddGuideHandle = self:AddTimer(1, self.TryToAddRangeGuide, true, 0, nil, false, "in")
    end
    if self.ShowGuideMinDistance < 0 then
        local tmp = self.ShowGuideMaxDistance
        self.ShowGuideMaxDistance = -self.ShowGuideMinDistance
        self.ShowGuideMinDistance = -tmp
        self.FixTryToAddGuideHandle = self:AddTimer(1, self.TryToAddRangeGuide, true, 0, nil, false, "out")
    end
end

function SceneItemBase:StopTryToAddGuideTimer()
    if not IsValid(self) then 
        self:StopAddGuideTimer()
        return true
    end
    return false
end
--------------------------- 指引 End-----------------------------------

--关闭所有同类型机关指引，涉及关闭被序列化的机关的指引，需要gamemode完成, 传了PlayerEid表示只控制某客户端的指引
-- function SceneItemBase:DeactiveAllGuide(IgnoreList, PlayerEid)
--     if IgnoreList == nil then
--         IgnoreList = TArray(0)
--     end
--     local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--     local RealPlayerEid = PlayerEid or -1
--     GameMode:DeactiveAllItemGuide(self:GetUnitRealType(), IgnoreList, RealPlayerEid)
-- end

-- function SceneItemBase:ActiveAllGuide(IgnoreList, PlayerEid) 
--     if IgnoreList == nil then
--         IgnoreList = TArray(0)
--     end
--      local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--     local RealPlayerEid = PlayerEid or -1
--     GameMode:ActiveAllItemGuide(self:GetUnitRealType(), IgnoreList, RealPlayerEid)
-- end

-- function SceneItemBase:ActiveGuide(OpType, PlayerEid)
--     if not IsAuthority(self) then
--         return
--     end
--     -- 激活指引
--     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--     local ResourceMgr = GameInstance:GetSceneManager()
--     local PropInfo = DataMgr.Mechanism[self.UnitId]
--     local RealPlayerEid = PlayerEid or -1
--     local SceneManager = GameInstance:GetSceneManager()
--     if (ResourceMgr ~= nil and (PropInfo.GuideIconBPPath or PropInfo.GuideIconAni)) then
--         local GameState = UE4.UGameplayStatics.GetGameState(self)
--         GameState:AddGuideEid(self.Eid, RealPlayerEid)
--         self.HasGuideClose = false
--     end
--     -- ResourceMgr:UpdateAllSceneGuideIcon()
--     if RealPlayerEid == nil or RealPlayerEid < 0 then
--         SceneManager:UpdateOneSceneGuideIcon(self.Eid, true, false)
--     else
--         SceneManager:UpdateOneSceneGuideIcon(self.Eid, true, true)
--     end
-- end

-- function SceneItemBase:DeactiveGuide(PlayerEid)
--     if not IsAuthority(self) then
--         return
--     end
--     -- 关闭指引
--     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--     local ResourceMgr = GameInstance:GetSceneManager()
--     local PropInfo = DataMgr.Mechanism[self.UnitId]
--     self:RemoveTimer(self.FixTryToAddGuideHandle)
--     self.FixTryToAddGuideHandle = nil
--     local GameState = UE4.UGameplayStatics.GetGameState(self)
--     local RealPlayerEid = PlayerEid or -1
--     GameState:RemoveGuideEid(self.Eid, RealPlayerEid)
--     if PlayerEid == nil or PlayerEid < 0 then
--         ResourceMgr:UpdateOneSceneGuideIcon(self.Eid, false, false)
--     else
--         ResourceMgr:UpdateOneSceneGuideIcon(self.Eid, false, true)
--     end
--     self.HasGuideClose = true
-- end

------------- ENDS -----------------
function SceneItemBase:InitCreatorInfo(Info)
    -- local AddRegionDataType = CommonConst.AddRegionDataType.Normal
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    -- local RegionDataResult, Avatar, _ = GameMode:GetRegionDataMgrSubSystem():IsCanTriggerRegionDataHandle()
	-- if IsValid(Info.Creator) then--部分数据由SetActorRegionCommonInfo初始化
    --     self.SourceEid = Info.Creator.SourceEid
    --     self.PrivateEnable = Info.Creator.PrivateEnable
    --     Info.Creator:SetCreatorInfo(self)
    --     AddRegionDataType = CommonConst.AddRegionDataType.Static
    --     if self.RandomCreatorId ~= 0 then
    --         AddRegionDataType = CommonConst.AddRegionDataType.Random
    --     end
    --     if RegionDataResult then
    --         self:LoadRegionInfo(Info.Creator:DumpRegionInfo())
    --     end
    -- else
    --     if not self:CheckManuItemRegionStorage() then 
	-- 		return 
	-- 	end
    -- end
    if not GameMode:GetWCSubSystem() then
        local DungeonState = Info:GetLuaTable("DungeonState")
        if DungeonState then self:RecoverSavedData(DungeonState) end
    else
        local State = Info:GetLuaTable("State")
        if State then self:RecoverSavedData(State) end
        -- GameMode:GetRegionDataMgrSubSystem():AddRegionDataByActor(self, Info, AddRegionDataType)
        -- self:CreateRegionData()
    end
end

function SceneItemBase:GetUnitRealType()
    return ""
end

--用于bpborn为true的物体的区域信息初始化
function SceneItemBase:SetRegionState()
end


------------- start ------------
--- BPBorn检测
-- function SceneItemBase:CheckManuItemRegionStorage()
--     if not self.BpBorn then  ----------- 给非BP_born的判断接口
--         return true
--     elseif self.ManualItemId > 0 then  ----------- 给BP_born的存储的判断接口
--         local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--         if not GameMode then return false end
--         local BPBornActor = GameMode.BPBornRegionActor:FindRef(self.ManualItemId)
--         return IsValid(BPBornActor)
--     end
--     return false
-- end

function SceneItemBase:GetManualItemId()
    return self.ManualItemId or -1
end

function SceneItemBase:CheckUnitNeedStorage()
    if self.RegionDataType and CommonUtils.HasValue(Const.RegionDataStorageType, self.RegionDataType) then 
        return true
    end
    return false
end

function SceneItemBase:IsBpbornRegionStorage()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then return false end
    local BPBornActor = GameMode.BPBornRegionActor:FindRef(self.ManualItemId)
    return (self.BpBorn and IsValid(BPBornActor))
end

------------- end ------------
function SceneItemBase:CreateRegionData()
    --创建区域中要被服务器记录的数据集合，各个子类不同，根据需求重写
end

function SceneItemBase:UpdateRegionData(DataName, DataValue)
    self[DataName] = DataValue

	if self.BpBorn and not self:CheckManuItemRegionStorage() then
		return
	end

    if not self.RegionData or self.RegionData[DataName] == nil then return end
    self.RegionData[DataName] = DataValue
    local GameMode = UGameplayStatics.GetGameMode(self)
    -- NewRegionEnable
    if GameMode then
		-- if URuntimeCommonFunctionLibrary.UseCppRegionData(self) then
		-- 	GameMode:GetRegionDataMgrSubSystem():UpdateStateInfo(self.RegionDataTableIndex, DataName, DataValue)
		-- end
        GameMode:GetRegionDataMgrSubSystem():UpdateRegionActorData(self, self.RegionData, false)
    end
end

function SceneItemBase:UpdateRegionDataByTable(DataTable)
    for DataName, DataValue in pairs(DataTable) do
        self[DataName] = DataValue
    end
    if self.BpBorn and not self:CheckManuItemRegionStorage() then
		return
	end
    if not self.RegionData then return end
    for DataName, DataValue in pairs(DataTable) do
        self.RegionData[DataName] = DataValue
    end
    local GameMode = UGameplayStatics.GetGameMode(self)
    if GameMode then
        GameMode:GetRegionDataMgrSubSystem():UpdateRegionActorData(self, self.RegionData, false)
    end
end

function SceneItemBase:OnRegionDataAllocated_Lua(LuaTableIndex, LevelName, RegionDataType, SubRegionId, UnitType, UnitId, Location)
	local GameMode = UGameplayStatics.GetGameMode(self)
    if GameMode then
        local Context = AEventMgr.CreateUnitContext()
        Context.StrParams:Add("LevelName", LevelName)
        Context.IntParams:Add("RegionDataType", RegionDataType)
        Context.IntParams:Add("SubRegionId", SubRegionId)
        Context.UnitType = UnitType
        Context.UnitId = UnitId
        Context.Loc = Location
        Context.IntParams:Add("ManualItemId", self.ManualItemId)
        Context.IntParams:Add("QuestChainId", self.QuestChainId)
        Context.BoolParams:Add("IsFullRegionStore", self.IsFullRegionStore)
        GameMode:GetRegionDataMgrSubSystem():InitRegionDataTable(LuaTableIndex, Context)
    end
end

function SceneItemBase:RecoverSavedData(DataTable)
    if not DataTable then return end
    for i,v in pairs(DataTable) do
        if self[i] ~= nil then
            self[i] = v
        end
    end
end

--无限本异常恢复数据
function SceneItemBase:GetDungeonSaveData()
    return {}
end

function SceneItemBase:OnRep_CurrentLevelId()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local SceneMgr
    if GameInstance and GameInstance.GetSceneManager then
        SceneMgr = GameInstance:GetSceneManager()
    end
	if (SceneMgr ~= nil) and SceneMgr:GetLevelLoader().LevelPathfinding then
		SceneMgr:GetLevelLoader().LevelPathfinding:UpdatePathfindingByEid(self.Eid,self.CurrentLevelId,false)
	end
end

function SceneItemBase:RecoverBpBornData()
    -- local StorgeStateId = 0
    -- self:ChangeState("Recover", 0, StorgeStateId)
    print(_G.LogTag, "LXZ RecoverBpBornData", self:GetName())
    -- self:ChangeState("Recover", 0, 0)
end


function SceneItemBase:ReceiveEndPlay()
    EventManager:RemoveEvent(EventID.OnBattleReady, self)
    EventManager:RemoveEvent(EventID.OnInitReady, self)
	if self.CleanTimer then
		self:CleanTimer()
	end
    self.IsDestroied = true
end

AssembleComponents(SceneItemBase)
return SceneItemBase
