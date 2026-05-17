
--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_LevelLoader_C = Class({'BluePrints/Common/EMLevelLoader',
                        "BluePrints.Common.TimerMgr"})
local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
local EMLuaConst = require "EMLuaConst"
function BP_LevelLoader_C:ReceiveBeginPlay()
    self.Overridden.ReceiveBeginPlay(self)

    if IsDedicatedServer(self) then
        self.IsPC = true
    else
        self.IsPC = CommonUtils.GetRuntimePlatform(self) == "PC"
    end

    if EMLuaConst and IsClient(self) then
        self.UseCCDOldValue = EMLuaConst.UseCCDInPC
        EMLuaConst.UseCCDInPC = false
    end

    self.MinimumLoadMaxLevelNum = 5 
    local ScalabilityLevel = GWorld.GameInstance.GetGameplayScalabilityLevel()
    if self.IsPC then
        self.MinimumLoadMaxLevelNum = Const.PCScalabilityLevelNum[ScalabilityLevel] or self.MinimumLoadMaxLevelNum
    else
        local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
        if Const.MobileScalabilityLevelNum[PlatformName] then
            self.MinimumLoadMaxLevelNum = Const.MobileScalabilityLevelNum[PlatformName][ScalabilityLevel] or self.MinimumLoadMaxLevelNum
        else
            self.MinimumLoadMaxLevelNum = self.MinimumLoadMaxLevelNum
        end
    end
    DebugPrint('NewLevelLoader','MinimumLoadMaxLevelNum:',self.MinimumLoadMaxLevelNum, ScalabilityLevel)

    self:BeginPlay()
    self.EnvironmentManager.bFixLightDirection = false
    self.showAllLevel=false
    self.DungeonShowAllLevel=false--目前只于挖掘的特殊处理
    self.DungeonMinimumLevel=_G.UseMinimumLoad
    if not self.IsLoaded then
        if not IsDedicatedServer(self) then
            local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
            self.LoadingUI = GameInstance:ShowLoadingUI(UIConst.COMMONCHANGESCENE)
        else
            self.showAllLevel=true
        end
    end
    --- 读json表 ---
    self.shortname  = UE4.URuntimeCommonFunctionLibrary.GetLevelLoadJsonName(self)
    local gameMode=UGameplayStatics.GetGameMode(self)
    if IsStandAlone(self) and gameMode and gameMode:NeedProgressRecover() then
        self.shortname=gameMode:GetProgressDataJsonName()
        URuntimeCommonFunctionLibrary.SetLevelLoadJsonName(self, self.shortname)
        local transoform=gameMode:GetProgressDataPlayerTransform()
        if transoform then
            self.ProgressLoc=transoform.Translation
            self.ProgressRot=transoform.Rotation:ToRotator()
        end
        local DungeonId = gameMode:GetProgressDataDungeonId()
        local DungeonInfo = DataMgr.Dungeon[DungeonId]
        if DungeonInfo and DungeonInfo.IsRandom then 
            if DungeonInfo.DungeonDoorBP then
                self.DoorClass=LoadClass(DungeonInfo.DungeonDoorBP)
            end
            self.showAllLevel = DungeonInfo.ShowAllLevel
            self.DungeonShowAllLevel = DungeonInfo.ShowAllLevel
        end
    end

    local DungeonId = GWorld.GameInstance:GetCurrentDungeonId()
    local DungeonInfo = DataMgr.Dungeon[DungeonId]
    if DungeonInfo and DungeonInfo.IsRandom then
        if DungeonInfo.DungeonDoorBP then
            self.DoorClass=LoadClass(DungeonInfo.DungeonDoorBP)
        end
        if not IsDedicatedServer(self) and IsStandAlone(self) and DungeonInfo.ShowAllLevel then
            self.showAllLevel=true
        end
        self.DungeonShowAllLevel=DungeonInfo.ShowAllLevel
    end
    --if IsDedicatedServer(self) then
    --    self.DungeonShowAllLevel = true
    --end
    if URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
        local GMVariable = require "BluePrints.UI.GMInterface.GMVariable"
        if GMVariable.LevelLoaderShortName then
            self.shortname = GMVariable.LevelLoaderShortName
            GMVariable.LevelLoaderShortName = nil
        end
    end
    DebugPrint('NewLevelLoader', "BP_LevelLoader_C:ReceiveBeginPlay LevelLoadJsonName:", self.shortname)
    --
    -- self.shortname='Prologue/Survival01/Survival01_10/prologue_survival01_105'
    -- shortname='NewTestRoom/1_3'
    --shortname='TestRoom/prologue_survival01_10'
    --  

    local levelTable=DataMgr.GetLevelLoaderJsonData(self.shortname)
    self.points=levelTable.points
    self.attr = levelTable.attr

    self.numOfLevels=#(self.points)

    --_,self.subDicPath=UE4.UNameStringFunctionLibrary.ShortNameToSubPath(shortname)
    --Print(self.subDicPath)
    --self.designPrePath= "/Game/Maps/Datas/Data_Design/"..self.subDicPath
    --self.artPrePath=    "/Game/Maps/Datas/Data_Art/"..self.subDicPath
    --self.homePrePath=   "/Game/Maps/Levels/"..self.subDicPath
    self:SetLoadProgress(0)
    self.levelLoadComplete=false
        self.homeStreamingLevel2ID={}
        self.ID2ArtStreamingLevel={}
        self.DesignStreamingLevel2ID={}
        self.homeLevel2ID={}
        self.homeLevelLoaded={}
        -- self.artLevelLoaded={}
        self.designStreamLevel2DoorData={}
        self.levelName2Id = {}
        self.artStreamingLevels={}
        self.soundStreamingLevels={}
        self.effectStreamingLevels={}
        self.homeStreamingLevels={}
        self.designStreamingLevels={}
        self.layoutStreamingLevels={}
        self.enterLevelID=-1
        self.exitLevelID=-1
        -- self.id2NeedLoad={}
        self.loadCompleteCallback={}
        self.Doors={}
        self.LevelId2Doors={}
        self.HasLayout=false
        self.ID2LayoutStreamingLevel={}
        self.CacheEids={}
        self.LevelLoadQueue={}
        self.CoroutineTable={}

        self.StreamLevelLoadFlag=false
        local platformName=UGameplayStatics.GetPlatformName()
        self.UseDungeonLevelBounds=_G.UseDungeonLevelBounds or platformName=='Android' or platformName=='IOS'
        coroutine.resume(coroutine.create(self.PreloadLevels),self)
    EventManager:AddEvent(EventID.ElevatorMechanismCompleteNotify,self,self.OnElevatorMechanismCompleteNotify)

    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    if GameInstance then
        GameInstance:UpdatePostProcessMaterial()
    end

    self:EnableSoftwareOcclusion() ---启用软件遮挡
end

function BP_LevelLoader_C:ReceiveEndPlay(reason)
    if EMLuaConst and self.UseCCDOldValue ~= nil then
        EMLuaConst.UseCCDInPC = self.UseCCDOldValue
    end
    self.Overridden.ReceiveEndPlay(self,reason)
    EventManager:RemoveEvent(EventID.ElevatorMechanismCompleteNotify,self)

    -- self:DisableSoftwareOcclusion()---禁用软件遮挡
end

function BP_LevelLoader_C:GetShortName()
    return self.shortname
end

function BP_LevelLoader_C:GetLevelIdByLevel(InLevel)
    local LuaTable = self.StreamLevel2ID:ToTable()
    for Level, Id in pairs(LuaTable) do
        if Level:GetLoadedLevel() == InLevel then
            return tostring(Id)
        end
    end
    for Id, Level in pairs(self.ID2DesignStreamingLevel) do
        if Level:GetLoadedLevel() == InLevel then
            return tostring(Id)
        end
    end
    return ""
end

---Level 加载有两种方式，1.直接全部加载，且不管卸载，2.HomeLevel和DesinLevel直接加载，ArtLevel设置加载信息-》完成后，随机选取一个StartPoint
---StartPoint所处的关卡标记为初始关卡-》加载初始关卡ArtLevel

---关卡如果加载不出来，可能的原因：
---1.startpoint没有放在homeLevel里，导致无法查到它对应的ArtLevel
---2.有模块缺少volume

---Volume加载和卸载
---玩家进入Volume时加载对应ArtLevel，同时卸载超出一定范围的ArtLevel（避免因为卸载导致的寻路数据更新）

---UnloadDistance:卸载距离


--- 预加载意味着，ArtLevel被延迟到玩家进入Volume时才会加载，但是HomeLevel和DesignLevel在一开始会被加载 ---
function BP_LevelLoader_C:PreloadLevels()
    self.PreLoadComplete = false
    local isPIE=UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self)
    local gridframeActor=TArray(AActor)
    for i=1,self.numOfLevels do--提前处理的数据，例如初始关卡id如果正常放加载里可能会比角色初始化晚
        if self.points[i].enterLevel and self.points[i].enterLevel == 1 then
            self.enterLevelID = tostring(self.points[i].id)
        end
    end
    for i=1,self.numOfLevels do
        --   取json 文件中单个拼接关卡level信息
        local level=self.points[i]
        ----- homePath 指的是拼接后的单个子关卡 由美术 设计 layout组成
        local homePath=string.gsub(level.struct,"Datas/Data_Design","Levels")--self.homePrePath.."/"..level.struct
        --- 获取设计关卡
        local designPath=level.struct.."_Design"--self.designPrePath.."/"..level.struct.."_Design"
        --- 获取美术关卡
        local artPath=level.art_path 
        if not artPath or artPath=='' then
            artPath=string.gsub(level.struct,"Data_Design","Data_Art").."_Art"--self.artPrePath.."/"..level.struct.."_Art"
        end
        
        local layoutPath=string.gsub(level.struct,"Data_Design","Data_Layout").."_Layout"
        local navPath=string.gsub(level.struct,"Data_Design","Data_NavMesh").."_NavMesh"
        local soundPath=string.gsub(level.struct,"Data_Design","Data_Sound").."_Sound"
        local effectPath=string.gsub(level.struct,"Data_Design","Data_Effect").."_Effect"

        local P=level.P
        local center=FVector(level.level_center[1],level.level_center[3],level.level_center[2])
        local pos=FVector(P[1],P[3],P[2])
        local rot=FRotator(0,level.rot,0)
        local id=tostring(level.id)
        self.LevelIDInt2String:Add(level.id,id)
        self.LevelIDString2Int:Add(id,level.id)
        local success=false
        local levelins=nil
        ------ 计算拼接关卡的偏移量
        local centerTransform=UE4.UKismetMathLibrary.MakeTransform(center,rot,UE4.UKismetMathLibrary.Vector_One())--GridFrame的transform
        local levelLocation= UE4.UKismetMathLibrary.TransformLocation(centerTransform,(UE4.UKismetMathLibrary.Vector_Zero()-center))--子level原点绕GridFrame旋转
        levelLocation=levelLocation-center+pos--将GridFrame置于子level中心，再加上配置里的偏移得到最终主关卡坐标系下的子level位置

        local temp=string.gsub(artPath,"/Game/Maps/Datas/Data_Art/","")
        self.id2LevelNameAndTransform[id]={string.sub(temp,1,string.len(temp)-4),pos,level.rot}
        self.id2LevelLocationAndRotation[id] = {artPath, levelLocation, rot}
		DebugPrint("PreloadLevels","LoadLevelInstance",self,tostring(homePath),levelLocation,rot,success,tostring(id))
        success, levelins = UE4.ULevelStreamingDynamic.LoadLevelInstance(self,tostring(homePath),levelLocation,rot,success,tostring(id))

        --- 
        self.homeStreamingLevels[#self.homeStreamingLevels+1]=levelins
        self.homeStreamingLevels[#self.homeStreamingLevels].OnLevelLoaded:Add(self,self.OnHomeLevelLoaded)
        self.homeStreamingLevel2ID[self.homeStreamingLevels[#self.homeStreamingLevels]]=id --- streaminglevel到ID的查询表 ---
        self.StreamLevelLoadFlag=true
        while self.StreamLevelLoadFlag do
            UE.UKismetSystemLibrary.Delay(self, 0.1)
        end

        success,levelins =UE4.ULevelStreamingDynamic.LoadLevelInstance(self,tostring(designPath),levelLocation,rot,success,id.."_Design")
        self.designStreamingLevels[#self.designStreamingLevels+1]=levelins
        self.designStreamingLevels[#self.designStreamingLevels].OnLevelShown:Add(self,self.OnDesignLevelLoaded)
        --[[if not self.showAllLevel or  (self.showAllLevel and self.enterLevelID == id) then
        self.designStreamingLevels[#self.designStreamingLevels]:SetShouldBeLoaded(false)
        end]]
        self.ID2DesignStreamingLevel[id]=self.designStreamingLevels[#self.designStreamingLevels]
        self.designStreamLevel2DoorData[self.designStreamingLevels[#self.designStreamingLevels]]=level
        self.DesignStreamingLevel2ID[self.designStreamingLevels[#self.designStreamingLevels]]=id
        self.StreamLevelLoadFlag=true
        while self.StreamLevelLoadFlag do
            UE.UKismetSystemLibrary.Delay(self, 0.1)
        end

        self.LevelName2Center:Add(navPath,FVector2D(center.X,center.Y))
        self.LevelID2Yaw:Add(id,level.rot)
        if IsAuthority(self) or URuntimeCommonFunctionLibrary.GetShouldAllowClientSideNavigation(self) then
        success,levelins =UE4.ULevelStreamingDynamic.LoadLevelInstance(self,tostring(navPath),levelLocation,rot,success,id.."_NavMesh")
        self.StreamLevel2ID:Add(levelins,level.id)
        if success then
            self.NavMeshLevelCount=self.NavMeshLevelCount+1
            self.StreamLevelLoadFlag=true
            while self.StreamLevelLoadFlag do
                UE.UKismetSystemLibrary.Delay(self, 0.1)
            end
        end
        end
        -- self.StreamLevelLoadFlag=true
        -- while self.StreamLevelLoadFlag do
        --     UE.UKismetSystemLibrary.Delay(self, 0.1)
        -- end

        local artPathNameArray = Split(artPath,"/")
        local artName = artPathNameArray[#artPathNameArray]
        self.levelName2Id[artName] = id
        -- local artLayoutPath=string.gsub(artPath,artName,'PartedLevel/'..artName..'_Layout')
        -- local artSmallObjsPath=string.gsub(artPath,artName,'PartedLevel/'..artName..'_SmallObjs')
        -- if self.UseDungeonLevelBounds and UResourceLibrary.CheckResourceExistOnDisk(artLayoutPath) and UResourceLibrary.CheckResourceExistOnDisk(artSmallObjsPath) then
            -- artPath=artLayoutPath
            -- success, levelins = UAsyncFunctionLibrary.LoadLevelInstance(self,tostring(artSmallObjsPath),levelLocation,rot,success,id.."_Art_SmallObjs")
            -- if success and self.showAllLevel then
            --     levelins:SetShouldBeLoaded(true)
            -- end
        -- end

        if self.IsPC then
            local PCDetailPath = artPath.."_PC"
            if UResourceLibrary.CheckResourceExistOnDisk(PCDetailPath) then
                local PCDetailLevel
                success, PCDetailLevel = UAsyncFunctionLibrary.LoadLevelInstance(self,tostring(PCDetailPath),levelLocation,rot,success,id.."_Art_PC")
                if success then
                    PCDetailLevel.OnLevelLoaded:Add(self,function()
                        self:OnClientOnlyLevelLoaded(PCDetailLevel:GetLoadedLevel())
                    end)
                end
                if success and self.showAllLevel then
                    PCDetailLevel:SetShouldBeLoaded(true)
                end
            end
        else
            local tempPath = string.gsub(artPath,"/Maps/","/Maps_Phone/")
            if UResourceLibrary.CheckResourceExistOnDisk(tempPath) then
                artPath = tempPath
            end
        end
        success, levelins = UAsyncFunctionLibrary.LoadLevelInstance(self,tostring(artPath),levelLocation,rot,success,id.."_Art")
        self.artStreamingLevels[#self.artStreamingLevels+1] = levelins
        --if IsAuthority(self) then
        --end
        if self.showAllLevel then
            --部分玩法美术关卡直接加载，需要提前设置RVT Volume
            if self.LevelID2GridFrame:Find(id) and not string.find(artPath,'GuideMan') then
                gridframeActor:Add(self.LevelID2GridFrame:FindRef(id))
                self:SetRVTVolume(gridframeActor)
            end

            -- self.id2NeedLoad[id]=true
            levelins.OnLevelLoaded:Add(self,function()
                self:OnArtLevelLoaded(id)
            end)
            levelins:SetShouldBeLoaded(true)
            self.StreamLevelLoadFlag=true
        else
            -- levelins.OnLevelUnloaded:Add(self,self.OnArtLevelUnloaded)
            -- self.artStreamingLevels[#self.artStreamingLevels]:SetShouldBeLoaded(false)
            self:OnArtLevelUnloaded()--不会卸载了，直接加进度
        end
        self.ID2ArtStreamingLevel[id]=self.artStreamingLevels[#self.artStreamingLevels]
        self.artStreamingLevel2ID[self.artStreamingLevels[#self.artStreamingLevels]]=id
        while self.StreamLevelLoadFlag do
            UE.UKismetSystemLibrary.Delay(self, 0.1)
        end

        if isPIE and (level.if_layout == 1 or not level.if_layout) then
            success, levelins = UE4.ULevelStreamingDynamic.LoadLevelInstance(self,tostring(layoutPath),levelLocation,rot,success,id.."_Layout")
            if success then
                self.HasLayout=true
                self.layoutStreamingLevels[id]=true
                self.ID2LayoutStreamingLevel[id]=levelins
                if not self.showAllLevel or  (self.showAllLevel and self.enterLevelID == id) then
                    levelins:SetShouldBeLoaded(false)
                end
            end
        end
        
        if not IsDedicatedServer(self) then
            local SoundLevel
            success, SoundLevel = UE4.ULevelStreamingDynamic.LoadLevelInstance(self,tostring(soundPath),levelLocation,rot,success,id.."_Sound")
            self.soundStreamingLevels[id] = success
            if success then
                SoundLevel.OnLevelLoaded:Add(self,function()
                    self:OnClientOnlyLevelLoaded(SoundLevel:GetLoadedLevel())
                end)
            end
            if not self.showAllLevel and success then
                SoundLevel:SetShouldBeLoaded(false)
            end
        end

        if not IsDedicatedServer(self) then
            local EffectLevel
            success, EffectLevel = UE4.ULevelStreamingDynamic.LoadLevelInstance(self,tostring(effectPath),levelLocation,rot,success,id.."_Effect")
            self.effectStreamingLevels[id] = success
            if success then
                EffectLevel.OnLevelLoaded:Add(self,function()
                    self:OnClientOnlyLevelLoaded(EffectLevel:GetLoadedLevel())
                end)
            end
            if not self.showAllLevel and success then
                EffectLevel:SetShouldBeLoaded(false)
            end
        end
            
        -- self.id2NeedLoad[id]=false

        if level.door then
            for i = 1, #level.door do
                local door=level.door[i]
                if door.next_id and door.next_id~=-1 then
                    self.LevelPathfinding:AddLevelDoor(id,door.next_id,door.door_name)
                end
            end
        end
        if level.exitLevel and level.exitLevel==1 then
            self.exitLevelID=id
        end

        if level.loading_group_id then
            if not self.LoadingGroupId then
                self.LoadingGroupId = {}
            end
            if not self.LoadingGroupId[level.loading_group_id] then
                self.LoadingGroupId[level.loading_group_id] = {}
            end
            self.LoadingGroupId[level.loading_group_id][id] = true
        end
    end

    if IsAuthority(self) then
        self:ReleaseInitialBuildingLock()
    end
    if IsClient(self) then
        self.WaitForPlayerStateTime = UGameplayStatics.GetRealTimeSeconds(self)
        while true do
            local playerController= UGameplayStatics.GetPlayerController(self,0)
            if playerController and playerController.PlayerState then
                break
            end
            if UGameplayStatics.GetRealTimeSeconds(self) - self.WaitForPlayerStateTime > 60 then
                DebugPrint('NewLevelLoader','Wait for PlayerState OverLimit!!!!')
                break
            end
            UKismetSystemLibrary.Delay(self,0.1)
            DebugPrint('NewLevelLoader','Wait for PlayerState')
        end
    end
    self.PreLoadComplete = true
    self:NextStep()
	DebugPrint("PreloadLevel Complete")
end


------------ 加载进度条 -----------------
--------------------------------------
function BP_LevelLoader_C:OnHomeLevelLoaded()
    if self.levelLoadComplete==true then
        return;
    end
    self:SetLoadProgress(self.loadProgress+(1/self.numOfLevels)*0.5*0.5)
    for i = 1, self.numOfLevels do
        if self.homeStreamingLevels[i] and self.homeStreamingLevels[i]:GetLoadedLevel()~=nil and self.homeLevelLoaded[i]==nil then
            self.homeLevelLoaded[i]=self.homeStreamingLevels[i]:GetLoadedLevel()
            self.homeLevel2ID[self.homeLevelLoaded[i]]=self.homeStreamingLevel2ID[self.homeStreamingLevels[i]]
            self:OnHomeLevelLoadedCallback(self.homeStreamingLevel2ID[self.homeStreamingLevels[i]])
        end
    end
    self:OnStreamingLevelLoaded()
    self.StreamLevelLoadFlag=false
end

function BP_LevelLoader_C:OnDesignLevelLoaded()
    if self.levelLoadComplete==true then
        return
    end
    self:SetLoadProgress(self.loadProgress + (1/self.numOfLevels/2.0) * 0.5)
    self:OnStreamingLevelLoaded()
    self.StreamLevelLoadFlag=false
end

function BP_LevelLoader_C:OnArtLevelUnloaded()
    if self.levelLoadComplete then
        return
    end
    self:SetLoadProgress(self.loadProgress+ (1/self.numOfLevels/2.0) * 0.5)
    self:OnStreamingLevelLoaded()
    self.StreamLevelLoadFlag=false
end

function BP_LevelLoader_C:OnPostAttachNavMeshDataChunk_Lua(InLevel)
    self.StreamLevelLoadFlag=false
end

function BP_LevelLoader_C:OnArtLevelLoaded(loadedID)
    DebugPrint("zzzzzz", "OnArtLevelLoaded")
    -- local loadedID=nil
    PrintTable(self.ArtLevelLoaded:ToTable())
    if self.ID2ArtStreamingLevel[loadedID]:GetLoadedLevel()~=nil and not self:GetLevelLoaded(loadedID)  then
        -- self.id2NeedLoad[loadedID]=false
        self:DisableLevelRVTVolume(self.ID2ArtStreamingLevel[loadedID])
        if not self.IsPC and IsClient(self) then
            self:OnClientOnlyLevelLoaded(self.ID2ArtStreamingLevel[loadedID]:GetLoadedLevel())
        end
        DebugPrint('NewLevelLoader', "Start Art Level Check. ID:"..loadedID)
        EventManager:FireEvent(EventID.OnArtLevelLoadedStateChange,loadedID,true)
        self.CoroutineTable[loadedID]=coroutine.create(self.LevelLoaderCheckArtLevelLoaded)
        coroutine.resume(self.CoroutineTable[loadedID], self, self.ID2ArtStreamingLevel[loadedID]:GetLoadedLevel(),loadedID)
    end
    if(self.levelLoadComplete==true or (loadedID~=self.enterLevelID and not self.showAllLevel)) then
        return;
    end
        --self.loadProgress= self.loadProgress+0.25/2--1.0
    self:OnStreamingLevelLoaded()

    --[[local startHomeLevel=UE4.URuntimeCommonFunctionLibrary.GetLevel(self.startPoint)
    local startLevelID=self.homeLevel2ID[startHomeLevel]
    local level= self.ID2ArtStreamingLevel[startLevelID]:GetLoadedLevel()
    self.ID2ArtStreamingLevel[startLevelID]:GetWorld():]]
end

function BP_LevelLoader_C:LevelLoaderCheckArtLevelLoaded(level, id)
    while true and not URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self) do
        if not UE4.UKismetSystemLibrary.IsValid(level) then
            return
        end
        if level.bIsVisible then
            break
        end
        UE.UKismetSystemLibrary.Delay(self, 0.1)
    end
    local designLevel
    while true do
        if not designLevel then
            designLevel=self.ID2DesignStreamingLevel[id]:GetLoadedLevel()
        end
        if designLevel and designLevel.bIsVisible then
            if not (self.HasLayout and self.layoutStreamingLevels[id]) then
                if self.showAllLevel then
                    self.StreamLevelLoadFlag=false
                else
                    DebugPrint('NewLevelLoader', "End Art Level Check1. ID:"..id)
                    self:OnArtLevelLoadedCallback(id)
                end
            end
            break
        end
        UE.UKismetSystemLibrary.Delay(self, 0.1)
    end
    if self.HasLayout and self.layoutStreamingLevels[id] then
    local layoutLevel
    while true do
        if not layoutLevel then
            layoutLevel=self.ID2LayoutStreamingLevel[id]:GetLoadedLevel()
        end
        if layoutLevel and layoutLevel.bIsVisible then
            if self.showAllLevel then
                self.StreamLevelLoadFlag=false
            else
                DebugPrint('NewLevelLoader', "End Art Level Check2. ID:"..id)
                self:OnArtLevelLoadedCallback(id)
            end
            break
        end
        UE.UKismetSystemLibrary.Delay(self, 0.1)
    end
    end
    self.ArtLevelLoaded:Add(id,true)
    self:ApplyInstancedFoliageActor(level)--植被拼接
    UKismetSystemLibrary.ExecuteConsoleCommand(self,'r.Shadow.ForceCacheUpdate 1',nil)--更新阴影缓存
    if id == self.enterLevelID and not self.levelLoadComplete then
        self:SetLoadProgress(self.loadProgress+0.25/2)
        self:OnStreamingLevelLoaded()
        if IsDedicatedServer(self) and self.PreLoadComplete then
            self.levelLoadComplete=true
            self:NextStep()
        end
    end

    if self.CapturePathLevel and not self.levelLoadComplete then
        for _,captureId in pairs(self.CapturePathLevel) do
            if id==captureId then
                self:SetLoadProgress(self.loadProgress+0.25/2/#self.CapturePathLevel)
                self:OnStreamingLevelLoaded()
            break
            end
        end
    end
    self:LoadNextArtLevel()
    self.CoroutineTable[id]=nil
end


------------完成回调-------------------
---UE 提供的OnlevelLoaded回调可能出现，触发这个回调的时候，相应Level中的Actor找不到，
---因此，我无法在这个回调里获得StartPoint，我只能通过Timer不断去询问StartPoint是否存在
--------------------------------------
function BP_LevelLoader_C:OnStreamingLevelLoaded()
    if self.showAllLevel then
        return
    end
    if not self.StreamingCount then
        self.StreamingCount = 0 
    end
    self.StreamingCount = self.StreamingCount + 1
    --if IsAuthority(self) then
    --- Preload完成 ---
    if(math.abs(self:GetLoadProgress() -0.75)<1e-5) then
        --self:NextStep()
    end
    --- 全部关卡加载完成 ---
    if(math.abs(self:GetLoadProgress()-1.0) <1e-5) then
        self.levelLoadComplete=true
        self:NextStep()
    end
    --else
    --    if(math.abs(self:GetLoadProgress()-0.5)<1e-5) then
    --        self:OnLevelLoadComplete()
    --    end
    --end
    self.Overridden.OnStreamingLevelLoaded(self)
end

function BP_LevelLoader_C:OnPreloadComplete()
    -- for streamingLevel,ID in pairs(self.homeStreamingLevel2ID) do
    --     local level =streamingLevel:GetLoadedLevel()
    --     if (level==nil) then
    --         error("Level doesn't exit")
    --         return;
    --     end
    --     self.homeLevel2ID[level]=ID
    -- end

    --- 设置Volume用于加载的信息 ---
	self.LevelBoundArray = UGameplayStatics.GetAllActorsOfClass(self, AAutoLevelBound.StaticClass())
	for Index = 1,self.LevelBoundArray:Length() do
        local volume = self.LevelBoundArray:GetRef(Index)
        local level=UE4.URuntimeCommonFunctionLibrary.GetLevel(volume)
        volume.loadName=self.homeLevel2ID[level]
        volume.levelLoader=self
        volume.ID=self.homeLevel2ID[level]
    end

    for Index = 1,self.volumeArray:Length() do
        local volume = self.volumeArray:GetRef(Index)
        local level=UE4.URuntimeCommonFunctionLibrary.GetLevel(volume)
        volume.loadName=self.homeLevel2ID[level]
        volume.levelLoader=self
        volume.ID=self.homeLevel2ID[level]
    end

    ---更新RVTVolume---
    if self.showAllLevel then--加载时已经扩大过了
        self:MarkRVTVolumeDirty()
    else
        local gridframeActor=TArray(AActor)
        for id,gridframe in pairs(self.LevelID2GridFrame) do 
            if not string.find(self.id2LevelLocationAndRotation[id][1],'GuideMan') then
                gridframeActor:Add(gridframe)
            end
        end
        self:SetRVTVolume(gridframeActor)
    end

    self.LevelPathfinding.LevelLoaderComplete = true

    --- 加载初始关卡 ---
    --local startHomeLevel=UE4.URuntimeCommonFunctionLibrary.GetLevel(self.startPoint)
    --Print("startHomeLevel",startHomeLevel)
    --local startLevelID=self.enterLevelID--self.homeLevel2ID[startHomeLevel]
    --[[for k,v in pairs(self.homeLevel2ID) do
        Print(k,v)
    end]]
    local gameMode=UGameplayStatics.GetGameMode(self)
    if IsClient(self) then
        local playerController= UGameplayStatics.GetPlayerController(self,0)
        local tempLoc=nil
        local playerCharacter=UGameplayStatics.GetPlayerCharacter(self, 0)
        self.LevelPathfinding:UpdateAllPathfinding(playerCharacter.CurrentLevelId)
        DebugPrint('NewLevelLoader playerController.PlayerState', playerController and playerController.PlayerState)
        if playerController and playerController.PlayerState and playerController.PlayerState.bIsEMInactive then--断线重连
            tempLoc=playerCharacter:K2_GetActorLocation()
            DebugPrint('NewLevelLoader', 'bIsEMInactive', tempLoc)
        else--正常加入或者中途加入
            if not UKismetMathLibrary.EqualEqual_VectorVector(playerController.TargetBornLocation,FVector(0,0,0),0.001) then
                tempLoc=playerController.TargetBornLocation
                DebugPrint('NewLevelLoader', 'TargetBornLocation', tempLoc)
            end
        end
        DebugPrint('NewLevelLoader', 'Client TempLoc', tempLoc)
        self:SetEnterLevelID(tempLoc)
    elseif IsStandAlone(self) and gameMode and gameMode:NeedProgressRecover() then--单机恢复
        self:SetEnterLevelID(self.ProgressLoc)
    end

    if not self.showAllLevel then
    for i = 1, self.numOfLevels do
        local id=self.artStreamingLevel2ID[self.artStreamingLevels[i]]
        self.artStreamingLevels[i].OnLevelLoaded:Add(self,function()
            self:OnArtLevelLoaded(id)
        end)
    end
    end
    --self.ID2DesignStreamingLevel[startLevelID].OnLevelLoaded:Add(self,self.OnDesignLevelLoaded)
    --self:LoadStreamLevel(startLevelID.."_Art",startLevelID)
    self:LoadArtLevel(self.enterLevelID)

    if self.CapturePathLevel then--捕获路径加载
        for _,levelId in pairs(self.CapturePathLevel) do 
            self:LoadArtLevel(levelId)
        end
    else
        self:SetLoadProgress(self.loadProgress+0.25/2)
        
    end

    --self:CreateNavLinkProxy()
    self:SetForceGCAfterLevelStreamedOut(false)
    if self.showAllLevel or URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self) then
        if IsDedicatedServer(self) then
            if self.ArtLevelLoaded:Find(self.enterLevelID) then
                self.levelLoadComplete=true
                self:NextStep()
            end
        else
            self.levelLoadComplete=true
            self:NextStep()
        end
    end

    if not IsDedicatedServer(self) then
        local BattleMain = UIManager(self):GetUI("BattleMain")
        if BattleMain and BattleMain.Battle_Map then
            BattleMain.Battle_Map.LastPlayerLevelNum = 0
        end
    end
end

function BP_LevelLoader_C:SetEnterLevelID(StartLoc)
    local id= self:GetLevelIdByLocation(StartLoc)
    if StartLoc and id ~= '' then
        self.enterLevelID=id
        for _,door in pairs(self.Doors) do
            if (door.LevelId == id or door.OtherLevelId==id) and door.if_door and door.door_state and door.OtherLevelId~='-1' then
                if UKismetMathLibrary.IsPointInBoxWithTransform(StartLoc,door.LevelUnloadBox:K2_GetComponentToWorld(),door.LevelUnloadBox:GetUnscaledBoxExtent()) then
                    self.enterNextLevelID=door.OtherLevelId
                    if door.OtherLevelId==id then
                        self.enterNextLevelID =door.LevelId
                    end
                    break
                end
            end
        end
    elseif StartLoc then-- 罕见情况，有可能处在关卡拼接处但是两个关卡之间，直接按门检查
        for _,door in pairs(self.Doors) do
            if door.if_door and door.door_state and door.OtherLevelId~='-1' then
                if UKismetMathLibrary.IsPointInBoxWithTransform(StartLoc,door.LevelUnloadBox:K2_GetComponentToWorld(),door.LevelUnloadBox:GetUnscaledBoxExtent()) then
                    self.enterLevelID=door.LevelId
                    self.enterNextLevelID=door.OtherLevelId
                    break
                end
            end
        end
    end
end

function BP_LevelLoader_C:OnLevelLoadComplete()
    for _,func in ipairs(self.loadCompleteCallback) do
        func()
    end
    self.Overridden.OnLevelLoadComplete(self)
    -- local UIManager = UE4.UGameplayStatics.GetGameInstance(self):GetGameUIManager()
    -- local mapUI= UIManager:GetUI("BattleMain")
    -- if mapUI then
    --     mapUI.Battle_Map:CreateBattleMap(self.id2LevelNameAndTransform)
    --     mapUI.Battle_Map:PlayAnim("Map_in")
    -- end
end

--- 提供给外部模块绑定回调 ---
function BP_LevelLoader_C:BindLoadCompleteCallback(func)
    self.loadCompleteCallback[#self.loadCompleteCallback+1]=func
end

function BP_LevelLoader_C:NextStep()
    if(self.startPoint==nil) then
        self:GetRandStartPoint()
    end
    if(self.volumeArray==nil or self.volumeArray:Length()<self.numOfLevels) then
        self:GetAllLevelVolume()
    end

    if(self.startPoint==nil or UE4.URuntimeCommonFunctionLibrary.IsActorInitialized(self.startPoint)==false
        or self.volumeArray==nil or self.volumeArray:Length()<self.numOfLevels) then
        UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self,BP_LevelLoader_C.NextStep},0.1,false)
        return;
    else
        if(self.levelLoadComplete) then
            --Print("11111111111111",self.levelLoadComplete,self.startPoint, UE4.URuntimeCommonFunctionLibrary.IsActorInitialized(self.startPoint))
            self:LevelLoaderReady()
            self:OnLevelLoadComplete()
        else
            self:OnPreloadComplete()
        end
    end

end

function BP_LevelLoader_C:SetPlayerTrans()
    local gameMode=UGameplayStatics.GetGameMode(self)
    if IsStandAlone(self) and gameMode and gameMode:NeedProgressRecover() then--单机恢复
        local Controller = UE4.UGameplayStatics.GetPlayerController(self, 0);
		local Player = Controller:GetMyPawn()
        Player:K2_SetActorLocation(self.ProgressLoc, false, nil, true)
		Player:K2_SetActorRotation(self.ProgressRot, false)
        Player:SetStartLevelId()
		Controller:SetControlRotation(self.ProgressRot)
    else
        if(self.startPoint==nil) then
            self:GetRandStartPoint()
        end
        self.startPoint:InitSetPlayerTrans()
    end
end

function BP_LevelLoader_C:SetEnteredPlayerTrans(PlayerController)
    if(self.startPoint==nil) then
        self:GetRandStartPoint()
    end
    self.startPoint:SetEnteredPlayerTrans(PlayerController)
end

function BP_LevelLoader_C:SetInitTrans(PlayerController)
    if(self.startPoint==nil) then
        self:GetRandStartPoint()
    end
    if self.startPoint then
        self.startPoint:SetInitTrans(PlayerController)
    end
end

function BP_LevelLoader_C:RealSetNewEnteredPlayerTrans(AvatarEidStr)
    if(self.startPoint==nil) then
        self:GetRandStartPoint()
    end
    self.startPoint:RealSetNewEnteredPlayerTrans(AvatarEidStr)
end

function BP_LevelLoader_C:GetRandStartPoint()
    if self.startPoint then
        return
    end
    local GetFunc = function()
            for _, StartPoint in pairs(self.StartPoints) do
                if self.enterLevelID and ((self:GetGamePlayActorLevelName(StartPoint) == self.enterLevelID) or (self:GetDesignActorLevelName(StartPoint) == self.enterLevelID)) then
                    self.startPoint = StartPoint
                    DebugPrint('NewLevelLoader', 'GetRandStartPoint EnterLevel', self.enterLevelID,self:GetGamePlayActorLevelName(StartPoint),self:GetDesignActorLevelName(StartPoint))
                    break
                end
            end
        end
    if #self.StartPoints == 0 then
        self.StartPoints = UGameplayStatics.GetAllActorsOfClass(self,LoadClass('/Game/BluePrints/Common/Level/BP_StartPoint.BP_StartPoint_C')):ToTable()
    end
    GetFunc()
    if not self.startPoint then
        self.StartPoints = UGameplayStatics.GetAllActorsOfClass(self,LoadClass('/Game/BluePrints/Common/Level/BP_StartPoint.BP_StartPoint_C')):ToTable()
    else
        return
    end
    GetFunc()
    if not self.startPoint and #self.StartPoints > 0 then
        self.startPoint = self.StartPoints[1]
        DebugPrint('NewLevelLoader', 'GetRandStartPoint Random')
    end
end

function BP_LevelLoader_C:GetGamePlayActorLevelName(Actor)
    local Level = UE4.URuntimeCommonFunctionLibrary.GetLevel(Actor)
    for StreamLevel,Id  in pairs(self.homeStreamingLevel2ID) do
        if StreamLevel:GetLoadedLevel() == Level then
            return Id
        end
    end
    return nil
end

------Volume加载和卸载关卡----------------
---------------------------------------

function BP_LevelLoader_C:GetLayoutStreamingLevels(LevelId)
    return self.layoutStreamingLevels[LevelId]
end

function BP_LevelLoader_C:SetNeedLoadLevelState(Id)
    DebugPrint("Level Check, Set Need Load Level State. ID:"..Id)
    -- self.id2NeedLoad[Id]=true
end

function BP_LevelLoader_C:LoadArtLevel(id,bMakeVisibleAfterLoad,bShouldBlockOnLoad)
    if bMakeVisibleAfterLoad == nil and bShouldBlockOnLoad == nil then
        bMakeVisibleAfterLoad = true
        bShouldBlockOnLoad = false
    end
	if URuntimeCommonFunctionLibrary.ShouldBlockOnAllStreamingLevel() then
		bShouldBlockOnLoad = true
	end
	if URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self) then
		self:OnArtLevelLoadedCallback(id)
		return
	end

    if self.showAllLevel then
        DebugPrint("Server Load",id)
        self:OnArtLevelLoadedCallback(id)
        return
    end
    local prefix=self:GetWorldStreamingLevelsPrefix()
    local needPrefix=IsClient(self) and URuntimeCommonFunctionLibrary.IsPlayInEditor(self) and prefix ==''
    if needPrefix then
        if UAsyncFunctionLibrary.CheckStreamLevelBeLoadState(self,"UEDPIE_0_"..id.."_Art",true) then 
            DebugPrint('CheckStreamLevelBeLoadState Failed:'..id)
            return
        end
    else
        if UAsyncFunctionLibrary.CheckStreamLevelBeLoadState(self,id.."_Art",true) then 
            DebugPrint('CheckStreamLevelBeLoadState Failed:'..id)
            return
        end
    end
    if needPrefix then
        self:LoadStreamLevelWithID("UEDPIE_0_"..id.."_Art",id+1,bMakeVisibleAfterLoad,bShouldBlockOnLoad)
        if self.IsPC then
            self:LoadStreamLevelWithID("UEDPIE_0_"..id.."_Art_PC",(id+1)*1000,bMakeVisibleAfterLoad,bShouldBlockOnLoad)
        end
    else
        self:LoadStreamLevelWithID(id.."_Art",id+1,bMakeVisibleAfterLoad,bShouldBlockOnLoad)
        if self.IsPC then
            self:LoadStreamLevelWithID(id.."_Art_PC",(id+1)*1000,bMakeVisibleAfterLoad,bShouldBlockOnLoad)
        end
    end
    if self.layoutStreamingLevels[id] then
        if needPrefix then
            self:LoadStreamLevelWithID("UEDPIE_0_"..id.."_Layout",(id+1)*1000+1,bMakeVisibleAfterLoad,bShouldBlockOnLoad)
        else
            self:LoadStreamLevelWithID(id.."_Layout",(id+1)*1000+1,bMakeVisibleAfterLoad,bShouldBlockOnLoad)
        end
    end
    if self.soundStreamingLevels[id] then
        if needPrefix then
            self:LoadStreamLevelWithID("UEDPIE_0_"..id.."_Sound",(id+1)*1000+2,bMakeVisibleAfterLoad,bShouldBlockOnLoad)
        else
            self:LoadStreamLevelWithID(id.."_Sound",(id+1)*1000+2,bMakeVisibleAfterLoad,bShouldBlockOnLoad)
        end
    end
    if self.effectStreamingLevels[id] then
        if needPrefix then
            self:LoadStreamLevelWithID("UEDPIE_0_"..id.."_Effect",(id+1)*1000+3,bMakeVisibleAfterLoad,bShouldBlockOnLoad)
        else
            self:LoadStreamLevelWithID(id.."_Effect",(id+1)*1000+3,bMakeVisibleAfterLoad,bShouldBlockOnLoad)
        end
    end
    DebugPrint('NewLevelLoader',"Load",id)
    -- self.id2NeedLoad[id]=true
    --[[if not self.levelLoadComplete then
        return;
    end
    local player=UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    for Index = 1,self.volumeArray:Length() do
        local volume = self.volumeArray:GetRef(Index)
        local dis=player:GetDistanceTo(volume)
        if(dis>volume.baseUnloadDistance*volume.unloadDistanceScale)then
            volume:UnloadLevel()
        end
    end]]
end
function BP_LevelLoader_C:UnloadArtLevel(id)
    if self.showAllLevel and not self.DungeonShowAllLevel or URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self) then
        DebugPrint("Server Unload",id)
        self:BeforeLevelUnloadedCallback(id)
        self:OnArtLevelUnloadedCallback(id)
        return
    end
    if self.DungeonShowAllLevel then
        return
    end
    -- if self.ID2ArtStreamingLevel[id]:GetLoadedLevel() ==nil then
    --     return
    -- end
    for i = 1, self.numOfLevels do
        if self.ID2ArtStreamingLevel[id] == self.artStreamingLevels[i] then
            if self.artStreamingLevels[i] ==false then
                return
            end
            self.ArtLevelLoaded:Add(id,false)
            DebugPrint("Level Check, artLevelLoaded state false:"..id)
            EventManager:FireEvent(EventID.OnArtLevelLoadedStateChange,id,false)
        end
    end

    -- 卸载关卡前进行序列化
    self:BeforeLevelUnloadedCallback(id)

    DebugPrint('NewLevelLoader',"Unload",id)
    if not self.showAllLevel then
    local prefix=self:GetWorldStreamingLevelsPrefix()
    local needPrefix=IsClient(self) and URuntimeCommonFunctionLibrary.IsPlayInEditor(self) and prefix ==''
    if needPrefix then
        self:UnloadStreamLevel("UEDPIE_0_"..id.."_Art",(id+1)*1000+10)
        if self.IsPC then
            self:UnloadStreamLevel("UEDPIE_0_"..id.."_Art_PC",(id+1)*1000+11)  
        end
    else
        self:UnloadStreamLevel(id.."_Art",(id+1)*1000+10)
        if self.IsPC then
            self:UnloadStreamLevel(id.."_Art_PC",(id+1)*1000+11)
        end
    end
    if self.layoutStreamingLevels[id] then
        if needPrefix then
            self:UnloadStreamLevel("UEDPIE_0_"..id.."_Layout",(id+1)*1000+12)
        else
            self:UnloadStreamLevel(id.."_Layout",(id+1)*1000+12)
        end
    end
    if self.soundStreamingLevels[id] then
        if needPrefix then
            self:UnloadStreamLevel("UEDPIE_0_"..id.."_Sound",(id+1)*1000+13)
        else
            self:UnloadStreamLevel(id.."_Sound",(id+1)*1000+13)
        end
    end
    if self.effectStreamingLevels[id] then
        if needPrefix then
            self:UnloadStreamLevel("UEDPIE_0_"..id.."_Effect",(id+1)*1000+14)
        else
            self:UnloadStreamLevel(id.."_Effect",(id+1)*1000+14)
        end
    end
    end
    self:OnArtLevelUnloadedCallback(id)
    -- self.id2NeedLoad[id]=false
    if self.CoroutineTable[id] then
        coroutine.close(self.CoroutineTable[id])
        self.CoroutineTable[id]=nil
    end
    if self.LevelLoadQueue[1] == id then
        self:LoadNextArtLevel()
    end
end

function BP_LevelLoader_C:OnHomeLevelLoadedCallback(LevelName)
    -- 第一次加载添加子GameMode
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode == nil then
        return
    end
    local StreamingLevelInfo = UE4.UGameplayStatics.GetStreamingLevel(self, LevelName)
    if StreamingLevelInfo == nil then
        return
    end
    local Level = StreamingLevelInfo:GetLoadedLevel()
    if Level == nil then
        return
    end
    GameMode:AddSubGameModeInfo(LevelName, Level)
end

function BP_LevelLoader_C:SetLevelDoor(door)
    self.Doors[#self.Doors+1]=door
    if self.DoorClass then
        door.DoorClass=self.DoorClass
    end
    local level=UE4.URuntimeCommonFunctionLibrary.GetLevel(door)
    for i=1,self.numOfLevels do
        if self.designStreamingLevels[i] and self.designStreamingLevels[i]:GetLoadedLevel() == level then
           local datas=self.designStreamLevel2DoorData[self.designStreamingLevels[i]].door
           if datas ~=nil then
               for j = 1, #datas do
                   if datas[j].door_name==door.DisplayName then
                        door.if_door=datas[j].if_door==1
                        door.door_state=datas[j].door_state==1
                        door.LevelPathfinding=self.LevelPathfinding
                        door.LevelId=tostring(self.designStreamLevel2DoorData[self.designStreamingLevels[i]].id)
                        door.OtherLevelId=tostring(datas[j].next_id)
                        self.LevelPathfinding.Name2BpArrowPos:Add(door.LevelId..datas[j].door_name,door)
                        DebugPrint('SetLevelDoor',door.LevelId,door.OtherLevelId,door.if_door,door.door_state)
                        if self.LevelId2Doors[door.LevelId] then
                            table.insert(self.LevelId2Doors[door.LevelId], door)
                        else
                            self.LevelId2Doors[door.LevelId] = {door}
                        end
                        -- return
                   end
               end
           end
        end
    end
    -- 创建门图标
    if door.if_door and not IsDedicatedServer(self) then
        local BattleMain = UIManager(self):GetUI("BattleMain")
        if BattleMain then
            local Minimap = BattleMain.Battle_Map
            Minimap:AddDoorToMinimap(door)
        else
            GWorld.GameInstance:GetSceneManager():AddMinimapDoor(door)
        end
    end
end

function BP_LevelLoader_C:StartPathfindingToActorByEid(eid)
    local thisBattle = Battle(self)
    if thisBattle == nil or not self.levelLoadComplete then
        local SceneMgr=UE4.UGameplayStatics.GetGameInstance(self):GetSceneManager()
        --Entity为SnapshotInfo时只有调用过来的时候会有值，之后会立刻被置nil，所以需要自己缓存下
        local SceneMgrEntity, _ = SceneMgr:GetCurSceneGuideEntityByEid(eid)
        self.CacheEids[eid] = SceneMgrEntity or nil
        if not self:IsExistTimer('BattleWaitHandle') then
            self:AddTimer(0.1,function()
                local temp = Battle(self)
                if temp and self.levelLoadComplete then
                    for Eid,Entity in pairs(self.CacheEids) do 
                        self:StartPathfindingToActorByEid(Eid)
                    end
                    self.CacheEids={}
                    self:RemoveTimer('BattleWaitHandle')
                end
            end,true,0,'BattleWaitHandle')
        end
        return
    end
    local targetActor=thisBattle:GetEntity(eid)
    local targetLocation
    if targetActor then
        if targetActor.CurrentLevelId and targetActor.CurrentLevelId:Num() ~=0 then
            return self.LevelPathfinding:UpdatePathfindingByEid(eid,targetActor.CurrentLevelId)
        else
            targetLocation=targetActor:K2_GetActorLocation()
        end
    else
        local SceneMgr=UE4.UGameplayStatics.GetGameInstance(self):GetSceneManager()
        local ClientGuideData = SceneMgr.CurSceneGuideEids[eid]
        local Entity = self.CacheEids[eid]
        if ClientGuideData then
            local SceneMgrEntity, _ = SceneMgr:GetCurSceneGuideEntityByEid(eid)
            Entity = Entity or SceneMgrEntity
        end
        if (Entity) then
            if Entity.UnitType=='Monster' and Entity.CurrentLevelId and Entity.CurrentLevelId:Length()>0 then
                return self.LevelPathfinding:UpdatePathfindingByEid(eid,Entity.CurrentLevelId)
            elseif Entity.Loc then
                targetLocation=Entity.Loc
            else
                targetLocation=Entity:K2_GetActorLocation()
            end
        else
            return false
        end
    end
    for _,id in pairs(self.homeLevel2ID) do
        if self:CheckLocationInGridframeByLevelId(id,targetLocation) then
            local array=TArray('')
            array:Add(id)
            return self.LevelPathfinding:UpdatePathfindingByEid(eid,array)
        end
    end
    return false
end

function BP_LevelLoader_C:StopPathfindingToActorByEid(eid)
    self.LevelPathfinding:StopPathfinding(eid)
end

function BP_LevelLoader_C:CheckIsTwoActorInSameLevelId(Actor1, Actor2)
    if (not UE4.UKismetSystemLibrary.IsValid(Actor1) or not UE4.UKismetSystemLibrary.IsValid(Actor2)) then
        return false
    end
    local TargetLocation1 = Actor1:K2_GetActorLocation()
    local TargetLocation2 = Actor2:K2_GetActorLocation()
    for _,id in pairs(self.homeLevel2ID) do
        if self:CheckLocationInGridframeByLevelId(id, TargetLocation1) and self:CheckLocationInGridframeByLevelId(id, TargetLocation2) then
            -- 处于同一个Level
            return true
        end
    end
    return false
end

function BP_LevelLoader_C:MultiLevelTrans(InActor,InTransform)
    local level=UE4.URuntimeCommonFunctionLibrary.GetLevel(InActor)
    for streamLevel,_ in pairs(self.artStreamingLevel2ID) do
        if streamLevel:GetLoadedLevel()== level then
            return InTransform*streamLevel.LevelTransform
        end
    end
end

-- function BP_LevelLoader_C:GetDoorLocationToTarget(StartVector,TargetVector,NeedLocation,outLocation,NeedExtent)
--     local sourceLevelId=TArray(0)
--     self.recastNavMesh:ProjectPointInDifferentLevel(StartVector,NeedExtent,sourceLevelId) 

--     local targetLevelId=TArray(0)
--     self.recastNavMesh:ProjectPointInDifferentLevel(TargetVector,NeedExtent,targetLevelId) 

--     local levelCheck=false
--     for _,id1 in pairs(sourceLevelId:ToTable()) do 
--         for _,id2 in pairs(targetLevelId:ToTable()) do
--             if id1==id2 then
--                 levelCheck=true
--             end
--         end
--     end

--     local LocationCheck=sourceLevelId:Num() ~=0 and targetLevelId:Num() ~= 0
--     if levelCheck or not LocationCheck then
--         return nil,false
--     end
--     if not NeedLocation then
--         return nil,true
--     end
--     local doorName,LevelFrom,LevelTo,hasDoor= self.LevelPathfinding:FindDoorByLevelId(sourceLevelId,targetLevelId)
--     outLocation=FVector()
--     if hasDoor then
--         local p0=self.LevelPathfinding.Name2BpArrowPos:FindRef(doorName):K2_GetActorLocation()
--         local pNormal=self.LevelPathfinding.Name2BpArrowPos:FindRef(doorName).RootComponent:GetForwardVector()
--         local l0=StartVector
--         local l=UKismetMathLibrary.Normal(TargetVector-l0,0.0001)
--         local d=UKismetMathLibrary.Dot_VectorVector(p0-l0,pNormal)/UKismetMathLibrary.Dot_VectorVector(l,pNormal)
--         local p=l0+UKismetMathLibrary.Multiply_VectorFloat(l,d)
--         local array=TArray(0)
--         p.Z=p0.Z
--         if self.recastNavMesh:ProjectPointInDifferentLevel(p,false,array) 
--         and array:Contains(LevelFrom) and array:Contains(LevelTo) then
--             outLocation=p
--         else
--             local trans=self.LevelPathfinding.Name2BpArrowPos:FindRef(doorName).RootComponent:K2_GetComponentToWorld()
--             local vectorL=UKismetMathLibrary.TransformLocation(trans,FVector(0,75,0))
--              local vectorR=UKismetMathLibrary.TransformLocation(trans,FVector(0,-75,0))
--             local vectorNear=vectorL
--             if UKismetMathLibrary.Vector_Distance(p,vectorL)>UKismetMathLibrary.Vector_Distance(p,vectorR) then
--                 vectorNear=vectorR
--             end
--             if self.recastNavMesh:ProjectPointInDifferentLevel(vectorNear,false,array) then
--                  outLocation=vectorNear
--             else
--                 outLocation=p0
--                 self.recastNavMesh:ProjectPointInDifferentLevel(outLocation,false,array)
--             end
--         end
--         if array:Num()>=2 and not sourceLevelId:Contains(array:GetRef(1)) then--下方的Poly不是当前关卡，加个距离取上方的
--             outLocation.Z=outLocation.Z+50
--         end
--     end
--     return outLocation,hasDoor
-- end

function BP_LevelLoader_C:CreateNavLinkProxy()
    for _,door in pairs(self.Doors) do      
        self:CreateNavLinkProxyCPP(FTransform(door:K2_GetActorRotation():ToQuat(),door:K2_GetActorLocation()),door.LevelId,door.OtherLevelId)
    end
end

function BP_LevelLoader_C:LoadCapturePathLevel(PathLevelArray)
    if self.CapturePathLevel or not Utils.IsAuthority(self) or self.levelLoadComplete then 
        return
    end
    self.CapturePathLevel={}
    for _,levelId in pairs(PathLevelArray) do
        if self.ID2ArtStreamingLevel[levelId] then
            --self:LoadArtLevel(levelId)
            self.CapturePathLevel[#self.CapturePathLevel+1]=levelId
        end
    end
end

function BP_LevelLoader_C:IsCapturePathLevel(LevelId)
    if not self.CapturePathLevel then
        return false
    end
    for _,levelId in pairs(self.CapturePathLevel) do
        if levelId==LevelId then
            return true
        end
    end
    return false
end


function BP_LevelLoader_C:RecoverArtLevelBreakable()
    local DirPath = UKismetSystemLibrary.GetProjectSavedDirectory() .. "Breakable/"
    for ArtName, ArtId in pairs(self.levelName2Id) do 
        local path = DirPath..ArtName..'.txt'
        local file = UE4.URuntimeCommonFunctionLibrary.LoadFile(path)
        local SplitArray = Split(file,'/n')
        local OffsetTransform = self.ID2ArtStreamingLevel[ArtId].LevelTransform
        -- print(_G.LogTag,"ZJT_ 关卡名称 关卡ID 关卡路径 ", ArtName, ArtId, path)
        for _, BreakableInfo in pairs(SplitArray) do
            repeat 
                if not BreakableInfo or string.len(BreakableInfo) == 0 then
                    DebugPrint("ZJT_ not BreakableInfo or string.len(BreakableInfo) == 0  ")
                    break
                end
                local BreakableString = Split(BreakableInfo, ":") 
                local BreakableName = BreakableString[1]
                local Breakable = Split(BreakableString[2], ";")
                local LocationString = Split(Breakable[1], ",")
                local RotationString = Split(Breakable[2], ",")
                local ScaleString = Split(Breakable[3], ",")
                local ReferencePath = Breakable[4]
                local Location = FVector(tonumber(LocationString[1]), tonumber(LocationString[2]), tonumber(LocationString[3]))
                local NewRotator = OffsetTransform.Rotation:ToRotator().Yaw
                local NewVector = UKismetMathLibrary.GreaterGreater_VectorRotator(Location, OffsetTransform.Rotation:ToRotator())
                -- print(_G.LogTag,"ZJT_ 破碎物远相对坐标 计算过后旋转 相对旋转  ", Location , NewVector )
                local Rotation = FRotator(tonumber(RotationString[1]), tonumber(RotationString[2]), tonumber(RotationString[3]))
                local Scale = FVector(tonumber(ScaleString[1]), tonumber(ScaleString[2]), tonumber(ScaleString[3]))
                -- print(_G.LogTag,"ZJT_ 关卡的Transform和当前计算后的物体Transform  ", OffsetTransform, Location, NewVector + OffsetTransform.Translation)
                local Transform =  UE4.UKismetMathLibrary.MakeTransform(NewVector + OffsetTransform.Translation , Rotation + OffsetTransform.Rotation:ToRotator(), UE4.FVector(1, 1, 1))
                local DecalActor = self:GetWorld():SpawnActor(LoadClass(ReferencePath), Transform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn, nil, nil, nil)
            until true
        end
    end 
end

function BP_LevelLoader_C:GetNextLevelIsLoaded(StartActor,TargetVector)
    local startLevelIdArray=StartActor.CurrentLevelId
    if not startLevelIdArray then
        startLevelIdArray=TArray('')
         local startLevelId=self:GetLevelIdByLocation(TargetVector)
         if not startLevelId then
            return FVector(0,0,0),false
         end
         startLevelIdArray:Add(startLevelId)
    end
    local targetLevelId=self:GetLevelIdByLocation(TargetVector)
    if not targetLevelId then 
        return FVector(0,0,0),false
    end
    local targetLevelIdArray=TArray('')
    targetLevelIdArray:Add(targetLevelId)
    local doorName,LevelFrom,LevelTo,hasDoor= self.LevelPathfinding:FindDoorByLevelId(startLevelIdArray,targetLevelIdArray)
    if not hasDoor then
         return FVector(0,0,0),false
    end
    local doorLoc=self.LevelPathfinding.Name2BpArrowPos:FindRef(doorName):K2_GetActorLocation()
    return doorLoc,self:GetLevelLoaded(LevelTo)
end

function BP_LevelLoader_C:SetLoadProgress(Num)
    if not Num or Num <= 0 then
        return
    end
    self.loadProgress= Num
    if self.LoadingUI then
        DebugPrint("SetLoadProgress CloseLoading", self.loadProgress * 0.5 * 100)
        self.LoadingUI:AddQuene(self.loadProgress * 0.5 * 100)
    end
end

function BP_LevelLoader_C:GetLoadProgress()
    return self.loadProgress
end

function BP_LevelLoader_C:GetFirstArrowByLevelId(LevelId)
    return self.LevelId2Doors[LevelId] and self.LevelId2Doors[LevelId][1] or nil 
end

function BP_LevelLoader_C:OnElevatorMechanismCompleteNotify()
    if IsDedicatedServer(self) then
        return
    end
    local playerCharacter=UGameplayStatics.GetPlayerCharacter(self, 0)
    self.LevelPathfinding:UpdateAllPathfinding(playerCharacter.CurrentLevelId)
end

function BP_LevelLoader_C:GetArtPathByLevelId(LevelId)
    for i=1, self.numOfLevels do
        local Level = self.points[i]
        if tostring(Level.id) == LevelId then
            local artPath = Level.art_path
            if not artPath or artPath == '' then
                artPath = string.gsub(Level.struct, "Data_Design", "Data_Art").."_Art"
            end
            return artPath
        end
    end
end

function BP_LevelLoader_C:K2_GetArtPathByLevelId(LevelId)
    for i=1, self.numOfLevels do
        local Level = self.points[i]
        if tostring(Level.id) == LevelId then
            local artPath = Level.art_path
            if not artPath or artPath == '' then
                artPath = string.gsub(Level.struct, "Data_Design", "Data_Art").."_Art"
            end
            local t = self.id2LevelLocationAndRotation[LevelId]
            PrintTable(self.id2LevelLocationAndRotation, 10)
            return artPath, t[2], t[3]
        end
    end
end

-- function BP_LevelLoader_C:LoadPartedLevel(id)
--     if not self.UseDungeonLevelBounds then
--          return
--     end
--     local prefix=self:GetWorldStreamingLevelsPrefix()
--     local needPrefix=IsClient(self) and URuntimeCommonFunctionLibrary.IsPlayInEditor(self) and prefix ==''
--     if needPrefix then
--         self:LoadStreamLevelWithID("UEDPIE_0_"..id.."_Art_SmallObjs",id+1,true,false)
--     else
--         self:LoadStreamLevelWithID(id.."_Art_SmallObjs",id+1,true,false)
--     end
-- end

-- function BP_LevelLoader_C:UnloadPartedLevel(id)
--     if not self.UseDungeonLevelBounds then
--         return
--    end
--     local prefix=self:GetWorldStreamingLevelsPrefix()
--     local needPrefix=IsClient(self) and URuntimeCommonFunctionLibrary.IsPlayInEditor(self) and prefix ==''
--     if needPrefix then
--         self:UnloadStreamLevel("UEDPIE_0_"..id.."_Art_SmallObjs",id+1)
--     else
--         self:UnloadStreamLevel(id.."_Art_SmallObjs",id+1)
--     end
-- end

function BP_LevelLoader_C:GetArtLevelByLevelId(LevelId)
    if self.ID2ArtStreamingLevel[LevelId] then
        return self.ID2ArtStreamingLevel[LevelId]:GetLoadedLevel()
    end
    return nil
end

function BP_LevelLoader_C:GetExitLevelLocation()
    if self.exitLevelID ~= -1 and self.id2LevelLocationAndRotation[self.exitLevelID] then
        return self.id2LevelLocationAndRotation[self.exitLevelID][2]
    end
    return nil
end

function BP_LevelLoader_C:GetLevelTransformById(Id)
    if self.id2LevelLocationAndRotation[Id] then
        return FTransform(self.id2LevelLocationAndRotation[Id][3], self.id2LevelLocationAndRotation[Id][2])
    end
    return nil 
end 

return BP_LevelLoader_C
