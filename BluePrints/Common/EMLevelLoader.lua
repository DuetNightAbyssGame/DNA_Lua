local EMLevelLoader = Class()--GameMode相关的逻辑和一些公用的方法放这里
local EMCache = require "EMCache.EMCache"
local EMDungeonPreloadData = require("DungeonPreloadData")
local EMRegionPreloadData = require("RegionPreloadData")
local EMAbyssPreloadData = require("AbyssPreloadData")
local EMDataNames = require("Datas.DataNames")

function EMLevelLoader:Initialize(Initializer)
    self.artLevelLoadedCompleteCallback = {}
    self.volumeArray = nil
    self.startPoint = nil
    self.ID2DesignStreamingLevel={}
    self.StartPoints={}
    self.StartPointManagers={}
    self.id2LevelNameAndTransform={}
    self.id2LevelLocationAndRotation = {}
    self.artStreamingLevel2ID={}
    self.PreviewLevelRefCount={}
end

function EMLevelLoader:BeginPlay()
    self:InitEnvironment()
    self:InitSettings()
    self:InitGameScreenFilter()
    self:InitGameGraphicsSettings()
end

function EMLevelLoader:InitEnvironment()
	if not self.EnvironmentManager then
        local EnvironmentManager = UE4.UGameplayStatics.GetActorOfClass(self,UE4.AEnvironmentManager:StaticClass())
        if EnvironmentManager then
            self.EnvironmentManager = EnvironmentManager
        else
        	self.EnvironmentManager = self:GetWorld():SpawnActor(LoadClass('/Game/Asset/Scene/common/EnvirSystem/EnvirCreat.EnvirCreat_C'),self:GetTransform())
        end
	end
end

function EMLevelLoader:InitSettings()
    DebugPrint("LevelLoaderInitSettings")
    local WorldContext = GWorld.GameInstance
    URuntimeCommonFunctionLibrary.SetConsoleVariableIntValue("r.Mobile.EnableReadSurface", 1, 1)
end

--初始化游戏画面滤镜
function EMLevelLoader:InitGameScreenFilter()
	local OptionName = "ScreenFilter"
	local GameCache = EMCache:Get(OptionName)
	if GameCache then
		self.EnvironmentManager:SetPosLUT(GameCache)
	else
		local ScreenFilterList = {
			[1] = 1,
			[2] = 2,
			[3] = 0,
		}
		local OptionInfo = DataMgr.Option[OptionName]
		local DefaultScreenFilter = 1
		if OptionInfo and OptionInfo.DefaultValue then
            DefaultScreenFilter = ScreenFilterList[tonumber(OptionInfo.DefaultValue)]
            if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" and OptionInfo.DefaultValueM ~= nil then
                DefaultScreenFilter = ScreenFilterList[tonumber(OptionInfo.DefaultValueM)]
            end
		end
		self.EnvironmentManager:SetPosLUT(DefaultScreenFilter)
        EMCache:Set(OptionName,DefaultScreenFilter)
	end
end

--初始化图形设置
function EMLevelLoader:InitGameGraphicsSettings()
    if IsDedicatedServer(self) then
        DebugPrint("Skip InitGameGraphicsSettings")
        return
    end
    DebugPrint("InitGameGraphicsSettings")

    local IsMobilePlatform = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
    if UUCloudGameInstanceSubsystem and UUCloudGameInstanceSubsystem.IsCloudGame() then
		IsMobilePlatform = false
	end

    -- 1.抗锯齿设置(Off: 0, TAA: 2, SMAA: 4)
    local AAValue = nil
    if not IsMobilePlatform then -- pc
        local AAOptionName = "AntiAliasing"
        AAValue = EMCache:Get(AAOptionName)
        if AAValue == nil then
            AAValue = 2 -- Default AA on pc is TAA  
        end
        UE4.UKismetSystemLibrary.ExecuteConsoleCommand(self, "r.DefaultFeature.AntiAliasing "..AAValue)
        EMCache:Set(AAOptionName, AAValue)
    else -- mobile
        local AAMOptionName = "AntiAliasingMobile"
        local AAMSwitch = EMCache:Get(AAMOptionName)
        AAValue = 4
        if AAMSwitch == nil then
            AAMSwitch = true
        end
        if AAMSwitch then
            AAValue = 2 -- On: TAA
        else
            AAValue = 4 -- Off: SMAA
        end
        -- 移动端SMAA效果欠佳，禁用SMAA，仅使用TAA
        AAValue = 2
        UE4.UKismetSystemLibrary.ExecuteConsoleCommand(self, "r.DefaultFeature.AntiAliasing "..AAValue)
        EMCache:Set(AAMOptionName, AAMSwitch)
    end
    
    -- 2. PC渲染倍率
    local ScreenPercentage = 100
    if not IsMobilePlatform then
        local RenderingValue = EMCache:Get("RenderingValue")
        if RenderingValue ~= nil then
            ScreenPercentage = RenderingValue
            UKismetSystemLibrary.ExecuteConsoleCommand(self, 'r.ScreenPercentage '..ScreenPercentage)
        end
    end

    -- 3.超分设置(如果不为TAA跳过设置) 
    if AAValue == 2 and USRMBlueprintLibrary ~= nil and ScreenPercentage == 100 then
        --
        local UMOptionName = "UpscalingMethodValue"
        local QMOptionName = "QualityModeValue"
        local UpscalingMethod = EMCache:Get(UMOptionName) 
        local QualityMode = EMCache:Get(QMOptionName)     
        if UpscalingMethod == nil or QualityMode == nil then
            if IsMobilePlatform then
                -- 使用默认TAA
                UpscalingMethod = ESuperResolutionType.Default
                QualityMode = 0
            else
                if USRMBlueprintLibrary.IsSRTypeAvailable(ESuperResolutionType.DLSS) then
                    UpscalingMethod = ESuperResolutionType.DLSS
                    local DefaultQualityMode = URuntimeCommonFunctionLibrary.GetDefaultDLSSQualityMode()
                    if DefaultQualityMode ~= 0 then
                        QualityMode = DefaultQualityMode
                    else
                        QualityMode = 4 -- quality
                    end
                else
                    UpscalingMethod = ESuperResolutionType.Default
                    QualityMode = 0
                end
            end
        end
        if ESuperResolutionType.Default <= UpscalingMethod and UpscalingMethod <= ESuperResolutionType.GSR then
            USRMBlueprintLibrary.SetSRTypeAndQuality(UpscalingMethod, QualityMode)
            EMCache:Set(UMOptionName,UpscalingMethod)
            EMCache:Set(QMOptionName,QualityMode)
        end
    end

    -- if AAValue == 2 then
    --     if URuntimeCommonFunctionLibrary.IsDLSSSupported() then
    --         local OptionName = "DLSS"
    --         local GameDLSS = URuntimeCommonFunctionLibrary.GetDefaultDLSSQualityMode()
    --         if GameDLSS == 0 then
    --             GameDLSS = EMCache:Get(OptionName)
    --         end
    --         if GameDLSS == nil then
    --             --首次默认设置ultraquality
    --             GameDLSS = UDLSSMode.Quality
    --             EMCache:Set(OptionName,GameDLSS)
    --         end
    --         if GameDLSS == 3 then
    --             GameDLSS = 1
    --         elseif GameDLSS == 7 then
    --             GameDLSS = 6
    --         end
    --         UDLSSLibrary.SetDLSSMode(GameDLSS)
    --     else
    --         local OptionName = "FSR"
    --         local GameFSR = EMCache:Get(OptionName)
    --         if GameFSR == nil then
    --             --首次默认设置 关
    --             GameFSR = false
    --             EMCache:Set(OptionName,false)
    --         end
    --         URuntimeCommonFunctionLibrary.SetFSREnabled(GameFSR)
    --     end
    -- end
    
    -- 4. DLSS帧生成
    if not IsMobilePlatform and UStreamlineLibraryDLSSG and UStreamlineLibraryDLSSG.IsDLSSGSupported() then
        local DLSSFGMode = EMCache:Get("DLSSFG")
        if DLSSFGMode ~= nil then
            UStreamlineLibraryDLSSG.SetDLSSGMode(DLSSFGMode)     
        end
    end

    -- 5. 水体质量
    if not IsMobilePlatform then
        local WQOptionName = "WaterQuality"
        local WaterQuality = EMCache:Get(WQOptionName)
        if WaterQuality == nil then
            WaterQuality = 3
        end
        URuntimeCommonFunctionLibrary.SetWaterQuality(math.tointeger(WaterQuality-1))
    end
end

function EMLevelLoader:OnArtLevelLoadedCallback(LevelId)
    -- 激活GameMode OnInit , 激活子GameMode并且恢复序列化数据
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode == nil then
        EventManager:FireEvent(EventID.OnArtLevelLoaded, LevelId)
        return
    end
    if IsStandAlone(self) then
        EventManager:FireEvent(EventID.OnArtLevelLoaded, LevelId)
    end
    DebugPrint("EMLevelLoader Loaded Level:", LevelId)
    GameMode:TriggerActiveSubGameModeInfo(LevelId)
    GameMode:DungeonRecoverSnapShot(LevelId)
    if self.artLevelLoadedCompleteCallback[LevelId] then
        for _, func in pairs(self.artLevelLoadedCompleteCallback[LevelId]) do
            func()
        end
    end
    if self.AfterLevelLoadeCallback then
        self:AfterLevelLoadeCallback(LevelId)
    end
end

function EMLevelLoader:OnArtLevelUnloadedCallback(LevelId)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode == nil then
        return
    end
    GameMode:TriggerDeActiveSubGameModeInfo(LevelId)
end

function EMLevelLoader:BeforeLevelUnloadedCallback(LevelName)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode ~= nil then
        DebugPrint("EMLevelLoader Unloaded Level:", LevelName)
        GameMode:SetSnapShot(LevelName)
        GameMode:UpdateMonsterSpawnInfo()
    end
end

function EMLevelLoader:GetAllLevelVolume()
    self.volumeArray=UGameplayStatics.GetAllActorsOfClass(self,LoadClass('/Game/BluePrints/Common/Level/BP_LevelVolume.BP_LevelVolume_C'))
    PrintTable(self.volumeArray)
end

function EMLevelLoader:GetAllLevelBounds()
	self.LevelBoundsArray = UGameplayStatics.GetAllActorsOfClass(self, ALevelBounds.StaticClass())
end

function EMLevelLoader:GetDungeonData()
    local DungeonId =  GWorld.GameInstance:GetCurrentDungeonId()
    local DungeonData = DataMgr.Dungeon[DungeonId]
    return DungeonData
end

function EMLevelLoader:GetRandStartPoint()
    local idx = 1
    if #self.StartPoints > 0 then
        local DungeonData = self:GetDungeonData()
        if DungeonData and DungeonData.bSpawnOnRandStartPoint then
            math.randomseed(tostring(os.time()):reverse():sub(1, 7))
            idx = math.random(#self.StartPoints)
        end
        self.startPoint=self.StartPoints[idx]
        return
    end
    local temp=UGameplayStatics.GetAllActorsOfClass(self,LoadClass('/Game/BluePrints/Common/Level/BP_StartPoint.BP_StartPoint_C'))
    if temp:Length() > 0 then
        local DungeonData = self:GetDungeonData()
        if DungeonData and DungeonData.bSpawnOnRandStartPoint then
            math.randomseed(tostring(os.time()):reverse():sub(1, 7))
            idx = math.random(temp:Length())
        end
        self.startPoint=temp:GetRef(idx)
    end
end

function EMLevelLoader:LevelLoaderReady()
    local GameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
    GameState.LevelLoaderReady = true
    GameState:TryEndLoading("LevelLoaderReady")
    AudioManager(self):PlayDungeonBGM()
    self:TriggerLevelInitMonsterPool(Const.DungeonPreloadMonster)
    self:TriggerLevelInitIndicatorPool(true)
    self:InitGameStatePickupUnitPool()
    self:InitGameStateBloodbarSubWidgetPool()
    self:InitGameStatePickupIconComponentPool()
    self:WaitNavigationLoading()
    if IsAuthority(self) then
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
		if GameMode.RandomActorManager and not GameMode:IsInRegion() then
			GameMode.RandomActorManager:RegisterAllData()
		end
        GameMode:RegisterBPArrow()
        GameMode:TryTriggerOnPrepare("LevelActorInit")
    end
    self:PreloadHostageUnitByStaticCreatorInfo(Const.IsOpenEscortNPCPhantomOpt)
end

function EMLevelLoader:TriggerLevelInitIndicatorPool(IsOpen)
    if IsOpen then
        self:InitGameStateIndicatorPool()
    end
end

function EMLevelLoader:InitGameStateIndicatorPool()
    local DungeonId =  GWorld.GameInstance:GetCurrentDungeonId()
    local DungeonData = DataMgr.Dungeon[DungeonId]
    if DungeonData == nil then
        return
    end
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    if not UIManager then
        return
    end
    local GameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)

    local function AddMonsterIndicatorToPool(Index)
        local Annihilate_S = "/Game/UI/WBP/GuidePoint/WBP_GuidePoint_Annihilate.WBP_GuidePoint_Annihilate"
        local PoolClass = UIManager:LoadUI(Annihilate_S, "PoolClass_Monster_"..Index, UIConst.ZORDER_FOR_INDICATORS)
        PoolClass.GuideType = "Monster"
        PoolClass.IsFromPool = true
        PoolClass.IsActiveInPoor = false
        GameState:AddIndicatorToPool("Monster", PoolClass)
    end

    for i = 0, 7 do --目前刷8只怪的怪物指引
        AddMonsterIndicatorToPool(i)
    end
end

function EMLevelLoader:InitGameStatePickupUnitPool()
    local Avatar = GWorld:GetAvatar()
    if self.IsWorldLoader and Avatar and Avatar:GetIsInHome() then
        return
    end
    local CommonUnitBPPath=nil
    if IsClient(self) then--后面考虑加表
        CommonUnitBPPath={{'/Game/AssetDesign/Item/Pickups/AutoPick/ResourceNew.ResourceNew',20},
        {'/Game/AssetDesign/Item/Pickups/AutoPick/AmmoNew.AmmoNew',10},
        {'/Game/AssetDesign/Item/Pickups/AutoPick/ModNew.ModNew',10},
        {'/Game/AssetDesign/Item/Pickups/AutoPick/HpBall.HpBall',10},
        {'/Game/AssetDesign/Item/Pickups/AutoPick/MpBall.MpBall',10}}
    elseif IsDedicatedServer(self) then
        CommonUnitBPPath={
        }
    else
        CommonUnitBPPath={{'/Game/AssetDesign/Item/Pickups/AutoPick/ResourceNew.ResourceNew',20},
        {'/Game/AssetDesign/Item/Pickups/AutoPick/AmmoNew.AmmoNew',10},
        {'/Game/AssetDesign/Item/Pickups/AutoPick/ModNew.ModNew',10},
        {'/Game/AssetDesign/Item/Pickups/AutoPick/HpBall.HpBall',10},
        {'/Game/AssetDesign/Item/Pickups/AutoPick/MpBall.MpBall',10}}
    end
    local GameModeUnitBPPath={}
    local GameMode=UGameplayStatics.GetGameMode(self)
    if GameMode and GameMode.GetPickupUnitPreloadTable then
        GameModeUnitBPPath=GameMode:GetPickupUnitPreloadTable() or {}
    end

    for _,BPPath in pairs(CommonUnitBPPath) do
        self:AddPickupUnitToPool(BPPath)
    end
    for _,BPPath in pairs(GameModeUnitBPPath) do
        self:AddPickupUnitToPool(BPPath)
    end
end

function EMLevelLoader:AddPickupUnitToPool(BPPath)
    local GameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
    local function LoadClassFinished(self, UnitBlueprint)
        local Rotation = FRotator(0, 0, 0)
        local Transform = UE4.FTransform(Rotation:ToQuat(), FVector(100000,100000,100000))
        local Unit = self:GetWorld():SpawnActor(UnitBlueprint, Transform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
        if Unit.GuideIconComponent then
            Unit.GuideIconComponent:SetHiddenInGame(true)
        end
        Unit:ResetForCache()
        Unit:TryInitActorInfo("OnInit")--对象池对象创建时机不定，手动把InitTag过一下
        GameState:DoPickUpUnitToCache(BPPath[1],Unit)
    end
    for i=1,BPPath[2]+1 do
        UResourceLibrary.LoadClassAsync(self, BPPath[1],{self, LoadClassFinished})
    end
end

function EMLevelLoader:GetSkeletalMeshAccessoryBPPath()
    return Const.CharResourcePaths.AccessoryBP
end

function EMLevelLoader:GetStaticMeshAccessoryBPPath()
    return Const.CharResourcePaths.StaticAccessoryBP
end

function EMLevelLoader:InitGameStateBloodbarSubWidgetPool()

    local UIManager = GWorld.GameInstance:GetGameUIManager()
    if not UIManager then
        return
    end

    local GameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
    if not GameState then
        return
    end
    local PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self)
    local WidgetNum = 30
    if (PlatformName == "PC") then
        WidgetNum = 50
    end
    local WidgetNeedCache = {
        {"HPBar",WidgetNum},
        {"ShieldBar",WidgetNum},
        {"BuffBar",WidgetNum},
        {"EliteBar",WidgetNum},
        {"BuffIcon",WidgetNum}
    }
    for _,Element in pairs(WidgetNeedCache) do
        local WidgetName = Element[1]
        local Num = Element[2]
        for i = 1, Num do
            local SubWidget = UIManager:_CreateWidgetNew(WidgetName)
            GameState:DoBloodbarSubWidgetCache(WidgetName,SubWidget)
        end
    end
end

function EMLevelLoader:AddStartPoint(StartPoint)
    self.StartPoints[#self.StartPoints+1]=StartPoint
end

function EMLevelLoader:AddStartPointManager(StartPointManager)
    self.StartPointManagers[#self.StartPointManagers+1]=StartPointManager
end

function EMLevelLoader:SetPlayerTrans()
    -- 子类Override
end

function EMLevelLoader:SetNewEnteredPlayerTrans(AvatarEidStr)
    -- 子类Override
end

function EMLevelLoader:RealSetNewEnteredPlayerTrans(AvatarEidStr)
    -- 子类Override
end

--提供外部绑定事件，在美术关卡加载完成之后会进行调用 
function EMLevelLoader:BindArtLevelLoadedCompleteCallback(LevelId, FunctionCallBack)
    print(_G.LogTag,"ZJT_ BindArtLevelLoadedCompleteCallback ", LevelId, self.artLevelLoadedCompleteCallback[LevelId])
    -- print(_G.LogTag,"ZJT_ OnArtLevelLoadedCallback LevelLoadedCompleteCallback ",LevelId, FunctionCallBack)
    if self.artLevelLoadedCompleteCallback[LevelId] then
        -- print(_G.LogTag,"ZJT_ OnArtLevelLoadedCallback LevelLoadedCompleteCallback nill ",LevelId, FunctionCallBack)
        self.artLevelLoadedCompleteCallback[LevelId][#self.artLevelLoadedCompleteCallback[LevelId] + 1] = FunctionCallBack
    else
        -- print(_G.LogTag,"ZJT_ OnArtLevelLoadedCallback LevelLoadedCompleteCallback not nill ",LevelId, FunctionCallBack)
        self.artLevelLoadedCompleteCallback[LevelId] = {}
        self.artLevelLoadedCompleteCallback[LevelId][#self.artLevelLoadedCompleteCallback[LevelId] + 1] = FunctionCallBack
    end
end

function EMLevelLoader:RemoveArtLevelLoadedCompleteCallback(LevelId)
    if self.artLevelLoadedCompleteCallback[LevelId] then
        self.artLevelLoadedCompleteCallback[LevelId] = nil
    end
end

-- function EMLevelLoader:CheckLocationInGridframeByLevelId(id,location)
--     local gridframe= rawget(self.LevelID2GridFrame, id)
--     return self:CheckLocationInGridframeByLevelId_Cpp(gridframe, location)
--     -- if not gridframe then
--     --     return false
--     -- end
--     -- return UE4.UKismetMathLibrary.IsPointInBoxWithTransform(location,gridframe:GetTransform(),FVector(50,50,50))
-- end

-- function EMLevelLoader:GetLevelIdByLocation(location)
--     if not self.LevelID2GridFrame then
--         return nil
--     end
--     for id,_ in pairs(self.LevelID2GridFrame) do
--         if self:CheckLocationInGridframeByLevelId(id,location) then
--             return id
--         end
--     end
--     return nil
-- end

-- function EMLevelLoader:GetAllLevelIdByLocation(location)
--     local Array=TArray('')
--     if not self.LevelID2GridFrame then
--         return Array
--     end
--     for id,_ in pairs(self.LevelID2GridFrame) do
--         if self:CheckLocationInGridframeByLevelId(id,location) then
--             Array:Add(id)
--         end
--     end
--     return Array
-- end

-- function EMLevelLoader:GetLevelId(Actor)
--     if not Actor.CurrentLevelId or Actor.CurrentLevelId:Num()==0 or Actor:IsSummonMonster() or Actor:IsMechanismSummon() then
--         return self:GetLevelIdByLocation(Actor:K2_GetActorLocation())
--     end
--     if Actor.CurrentLevelId:Num() == 1 then
--         return Actor.CurrentLevelId:Get(1)
--     end
--     local location=Actor:K2_GetActorLocation()
--     for _,levelId in pairs(Actor.CurrentLevelId:ToTable()) do
--         if self:CheckLocationInGridframeByLevelId(levelId,location) then
--             return levelId
--         end
--     end
--     return nil
-- end

function EMLevelLoader:CheckActorInGridframeByLevelId(LevelId,Actor)
    if not Actor then
        return false
    end
    return self:CheckLocationInGridframeByLevelId(LevelId, Actor:K2_GetActorLocation())
end

function EMLevelLoader:GetActorInLevelTransform(InActor)
    print("EnvirSystemActor GetActorInLevelTransform")
	if not self.artStreamingLevel2ID then
		return FTransform()
	end
    local level=UE4.URuntimeCommonFunctionLibrary.GetLevel(InActor)
    for streamLevel,_ in pairs(self.artStreamingLevel2ID) do
        if streamLevel:GetLoadedLevel()== level then
            return streamLevel.LevelTransform
        end
    end
	return FTransform()
end

function EMLevelLoader:GetDesignActorLevelName(Actor)
    local level=UE4.URuntimeCommonFunctionLibrary.GetLevel(Actor)
    for id,streamLevel in pairs(self.ID2DesignStreamingLevel) do
        if streamLevel:GetLoadedLevel() == level then
            return id
        end
    end
    return nil
end

function EMLevelLoader:GetLevelTransformByLevelName(LevelName)
    local Level = self.ID2DesignStreamingLevel[LevelName]
    return Level.LevelTransform
end

function EMLevelLoader:AddGridFrame(GridFrame)
    local level=UE4.URuntimeCommonFunctionLibrary.GetLevel(GridFrame)
	PrintTable(self.ID2DesignStreamingLevel)
    for id,streamLevel in pairs(self.ID2DesignStreamingLevel) do
        if streamLevel:GetLoadedLevel() == level then
           self.LevelID2GridFrame:Add(id,GridFrame)
           if self.LevelPathfinding and GridFrame.Elevator and GridFrame.ElevatorTopBPArrow and GridFrame.ElevatorBottomBPArrow then
               self.LevelPathfinding.ID2Elevator:Add(id,GridFrame.Elevator)
               self.LevelPathfinding.ID2ElevatorTopDoor:Add(id,GridFrame.ElevatorTopBPArrow)
               self.LevelPathfinding.ID2ElevatorBottomDoor:Add(id,GridFrame.ElevatorBottomBPArrow)
           end
           local battleMap=nil
           local UIManager= GWorld.GameInstance:GetGameUIManager()
           if UIManager then
                local battleMain=UIManager:GetUI('BattleMain')
                if battleMain then
                    battleMap=battleMain.Battle_Map or battleMain.Battle_Map_PC
                end
            end
           if self.id2LevelNameAndTransform[id] then
                self.id2LevelNameAndTransform[id][4]=GridFrame.Floor
                if battleMap then
                    battleMap:CreateSingleBattleMap(id,self.id2LevelNameAndTransform[id])
                end
           else
            for id1,data in pairs(self.id2LevelNameAndTransform) do
                if string.find(data[1],id) then
                    data[4]=GridFrame.Floor
                    -- self.id2LevelNameAndTransform[id][4]=GridFrame.Floor
                    if battleMap then
                        battleMap:CreateSingleBattleMap(id,data)
                    end
                    break
                end
            end
            end
        end
    end
end

function EMLevelLoader:SetDesignLevelHidden(bHidden)
    for _,DesignStreamingLevel in pairs(self.ID2DesignStreamingLevel) do
        DebugPrint("SetDesignLevelHidden",DesignStreamingLevel:GetName())
        DesignStreamingLevel:SetShouldBeVisible(not bHidden)
    end
end

function EMLevelLoader:CheckIsRougeLike()
    return false
end

function EMLevelLoader:GetConstStandAloneMonsterCanCache()
    return Const.StandAloneMonsterCanCache
end

function EMLevelLoader:GetConstOnlineMonsterCanCache()
    return Const.OnlineMonsterCanCache
end

function EMLevelLoader:LoadPreviewLevel(Name,Path,Callback,Position,Rotation,IsHide)
    local Success
    if not self[Name] then
        Success, self[Name] = UAsyncFunctionLibrary.LoadLevelInstance(self,Path,Position or FVector(0,0,0),Rotation or FRotator(0,0,0),Success,Name)
        self.PreviewLevelRefCount[Name] = 1
    else
        self.PreviewLevelRefCount[Name] = self.PreviewLevelRefCount[Name] or 0
        self.PreviewLevelRefCount[Name] = self.PreviewLevelRefCount[Name] + 1
    end
    if self[Name] then
        local WCSubsystem = UGameplayStatics.GetGameMode(self):GetWCSubSystem()
        if WCSubsystem then
            WCSubsystem:FreezeWorldComposition()
            WCSubsystem:FreezeDistanceBasedRegion()
        end
        self[Name].OnLevelShown:Clear()
        self[Name].OnLevelShown:Add(self,Callback)
        coroutine.resume(coroutine.create(self.LatentPrevewLevelAction), self, true,Name,IsHide)
        Success = true
    end
    return Success
end

function EMLevelLoader:UnloadPreviewLevel(Name)
    if self[Name] then
        self.PreviewLevelRefCount[Name] = self.PreviewLevelRefCount[Name] - 1
        if self.PreviewLevelRefCount[Name] <= 0 then
            self.PreviewLevelRefCount[Name] = nil
        end
        if(next(self.PreviewLevelRefCount) == nil)then
            local WCSubsystem = USubsystemBlueprintLibrary.GetWorldSubsystem(self, UWorldCompositionSubSystem.StaticClass())
            if WCSubsystem then
                WCSubsystem:UnFreezeWorldComposition()
                WCSubsystem:UnFreezeDistanceBasedRegion()
            end
        end
        coroutine.resume(coroutine.create(self.LatentPrevewLevelAction), self, false,Name)
    end
end

function EMLevelLoader:LatentPrevewLevelAction(IsLoad,LevelName,IsHide)
    if IsLoad then
        UGameplayStatics.LoadStreamLevel(self,LevelName,true and not IsHide, true)

    else
        UGameplayStatics.UnloadStreamLevel(self,LevelName,true)
    end
end

function EMLevelLoader:SetLevelVisible(LevelName)
    if self[LevelName] then  
    self[LevelName]:SetShouldBeVisible(true)
    end
end

function EMLevelLoader:GetDungeonPreloadData(DungeonId)
    local Ret = FDungeonPreloadData()
    local InvalidDungeonId = 
    {
        --[90108] = true,
        --[90604] = true,
        --[90804] = true,
        --[91009] = true,
        --[91124] = true,
        --[91125] = true,
        --[91144] = true,
        --[91145] = true,
        --[91146] = true,
        --[91147] = true,
        --[91185] = true,
        --[91186] = true,
        --[91181] = true,
        --[91182] = true,
        --[91183] = true,
        --[91184] = true,
    }

    if IsDedicatedServer(self) and InvalidDungeonId[DungeonId] == true then
        return Ret
    end

    if EMDungeonPreloadData[DungeonId] == nil then
        return Ret
    end
    
    local Data = EMDungeonPreloadData[DungeonId]
    Ret.OnlineCoefficient = Data.OnlineCoefficient
    for key, value in pairs(Data.MonsterSpawn) do
        Ret.MonsterSpawn:Add(key, value)
    end 

    local EMGameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
    
    local Exist = false
    for _, DataName in pairs(EMDataNames) do
        if DataName == EMGameState.GameModeType then
            Exist = true
            break
        end
    end

    if Exist then
        local GameModeData = EMGameState.GameModeType and DataMgr[EMGameState.GameModeType] or nil
        local DungeonData = GameModeData and GameModeData[DungeonId] or nil
        if DungeonData then
            local DungeonTreasureMonsterId = DungeonData["Treasure".."MonsterId"]
            if DungeonTreasureMonsterId then
                Ret.FixedMonsterSpawn:Add(DungeonTreasureMonsterId, 1)
            end

            local DungeonButcherMonsterId = DungeonData["Butcher".."MonsterId"]
            if DungeonButcherMonsterId then
                Ret.FixedMonsterSpawn:Add(DungeonButcherMonsterId, 1)
            end
        end
    end
    
    if Data.FixedMonster then
        for key, value in pairs(Data.FixedMonster) do
            Ret.FixedMonsterSpawn:Add(key, value)
        end
    end    
    return Ret;
end     

function EMLevelLoader:GetStoryRegionPreloadData(RegionId)
    local Ret = FDungeonPreloadData()
    local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
    if PlatformName == "IOS" then
        return Ret
    end
    local StorySubSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UStorySubsystem:StaticClass())
    if StorySubSystem == nil then
        return Ret
    end
    if RegionId ~= 1001 then
        return Ret  
    end
    
    local RegionName = "Prologue_optimization"
    local Tag = StorySubSystem:GetOptimizeTag(RegionName)
    local Data = nil
    if Tag == EStoryOptimizeTag.None or Tag == EStoryOptimizeTag.On then
        Data = EMRegionPreloadData[RegionName]
    end

    if Data ~= nil then
        Ret.OnlineCoefficient = 1.0
        for key, value in pairs(Data.MonsterSpawn) do
            Ret.MonsterSpawn:Add(key, value)
        end
    end
    
    return Ret
end

function EMLevelLoader:GetRegionPreloadData(RegionId)
    local Ret = FDungeonPreloadData()
    local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
    if PlatformName == "IOS" then
        return Ret
    end
    local SceneIdToRegionName = 
    {
        [1041] = "Dongguo"
    }
    
    local RegionName = SceneIdToRegionName[RegionId]
    if RegionName == nil or EMRegionPreloadData[RegionName] == nil then
        return Ret
    end

    local Data = EMRegionPreloadData[RegionName]
    Ret.OnlineCoefficient = 1.0
    for key, value in pairs(Data.MonsterSpawn) do
        Ret.MonsterSpawn:Add(key, value)
    end
    return Ret;   
end

function EMLevelLoader:GetAbyssPreloadData(AbyssId)
    local Ret = FDungeonPreloadData()
    if EMAbyssPreloadData[AbyssId] == nil then
        return Ret
    end

    local Data = EMAbyssPreloadData[AbyssId]
    Ret.OnlineCoefficient = 1.0
    for key, value in pairs(Data.MonsterSpawn) do
        Ret.MonsterSpawn:Add(key, value)
    end
    return Ret
end

return EMLevelLoader