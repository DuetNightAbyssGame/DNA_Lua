--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
-- todo @fanyuxiao 所有的WorldCompositionEnabled判断需要干掉, 不要再维护两个逻辑了
local JsonDecode = require("rapidjson")
---@type BP_WorldLoader_C
local M = Class({'BluePrints/Common/EMLevelLoader', "BluePrints.Common.TimerMgr"})
local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"

function M:Initialize(Initializer)
	self.Super.Initialize(self, Initializer)
    self.ID2ArtStreamingLevel={}
	self.DesignId2ArtId={}
    self.ID2LayoutStreamingLevel={}
    self.ID2NavMeshStreamingLevel={}
    self.ID2SoundStreamingLevel={}
    self.ArtLevelUnLoadEvent = {}
    self.ArtLevelLoadEvent = {}
    -- self.artLevelLoaded={}
    self.homeLevel2ID={}
    self.LevelID2RegionID={}
    self.RegionID2LevelID = {}
    self.id2NeedLoad={}
    self.GetLevels=false
    self.enterLevelID=nil
    self.enterLoc = nil
    self.enterRot = nil
    self.levelName2Id = {}
    -- self.levelLoadComplete=false
    self.EnterRegionType = ""
    self.loadProgress = 0
    self.LastLevelLoadingMessage = nil -- 用于缓存上次显示的关卡加载信息，只在变化时更新
end

-- function M:UserConstructionScript()
-- end

function M:ReceiveBeginPlay()
    self.IsWorldLoader=true
    self:BeginPlay()
    self.EnvironmentManager.bFixLightDirection = false
    self.WorldCompositionSubSystem = USubsystemBlueprintLibrary.GetWorldSubsystem(self, UWorldCompositionSubSystem:StaticClass())
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        self:HandleEnterRegionType(Avatar, Avatar.EnterRegionType)
        DebugPrint("ZJT_ Print PlayerCharacter Recover Info ", Avatar:InitRecoverCheck(), Avatar.StartIndex, Avatar.CurrentRegionId, self.enterLevelID, Avatar:GetLastRegionId())
        PrintTable({Location = Avatar.LastRegionData:GetLocation()}, 2)
        -- PrintTable({Rotation = Avatar.LastRegionData:GetRotation()}, 2)
	else
        self:AddTimer(1,function()
            self:LevelLoaderReady()
            self:ReleaseInitialBuildingLock()
        end)
        -- if not IsDedicatedServer(self) then
		    -- self:DestroySelf()
        -- end
        if URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
            self.WorldCompositionSubSystem:ForceAddLoadedLevel()
        end
		return
    end
    self.shortname = WorldTravelSubsystem(self).LevelLoadJsonName
	local ShortString = string.find(self.shortname,'Houdini_data/')
	if self.shortname and ShortString then
		self.shortname = string.sub(self.shortname,string.find(self.shortname,'Houdini_data/')+13)
		local levelTable=DataMgr.GetLevelLoaderJsonData(self.shortname)
		self.points=levelTable.points
		print(_G.LogTag, '222222222222222222222222', self.shortname)
	end
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
	
    -- self.LoadingUI = GameInstance:ShowLoadingUI(UIConst.COMMONCHANGESCENE)
    self:InitLevelID()
    self.LevelPathfinding.LevelLoaderComplete = true
    
    if GameInstance then
        GameInstance:UpdatePostProcessMaterial()
    end
end

function M:ReceiveTick(DeltaSeconds)
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		-- self.GetLevels = true
		return
	end
    if self.GetLevels then
        return
    end
    local temp=self.StreamLevels:ToTable()
    if #temp == 0 then
		self:GetStreamingLevels()
        return
    end
	self:InitWorldLoad(temp)
end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

function M:InitLevelID()
	if self.points then
		for i=1,#self.points do 
			local json=self.points[i]
			local levelName=string.sub(json.struct,#json.struct-string.reverse(json.struct):find('/')+2)
			self.LevelIDInt2String:Add(json.id,levelName)
			self.LevelIDString2Int:Add(levelName,json.id)
		end
	end
	self:InitLevelInfo()
end

function M:InitLevelInfo(StreamLevels)
	if self.LevelInfoInited then
		return
	end
	self.LevelInfoInited = true
	self:GetStreamingLevels()
	StreamLevels = self.StreamLevels:ToTable()
	local isPIE=UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self)
    local WorldCompositionSubSystem = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(self, UE4.UWorldCompositionSubSystem)
    local IsInDungeon = WorldCompositionSubSystem and WorldCompositionSubSystem:WCIsInDungeon()
	for _,streamLevel in pairs(StreamLevels) do
        --self.LuaStreamLevels[streamLevel.PackageNameToLoad]=streamLevel
        local packageName=streamLevel.PackageNameToLoad
        if packageName=='None' then
            packageName=streamLevel:GetWorldAssetPackageFName()
        end
        local temp,_= UNameStringFunctionLibrary.LongPathNameToName(packageName)
		local bIsGameplayLevel = URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self) and UKismetStringLibrary.EndsWith(packageName,'_Gameplay',ESearchCase.CaseSensitive)
		local bIsHomeLevel = UKismetStringLibrary.StartsWith(packageName,'/Game/Maps/Levels',ESearchCase.CaseSensitive) and not URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self)
        local DungeonDesignIndex = -1
        if UKismetStringLibrary.EndsWith(temp,'_Art',ESearchCase.CaseSensitive) then
            local LevelID = string.gsub(temp,'_Art','')
            self.levelName2Id[LevelID] = LevelID
            self.ID2ArtStreamingLevel[LevelID]=streamLevel
            self.artStreamingLevel2ID[streamLevel]=LevelID
            self.id2NeedLoad = {}
            streamLevel.OnLevelLoaded:Add(self,self.OnArtLevelLoaded)
        elseif UKismetStringLibrary.EndsWith(temp,'_Layout',ESearchCase.CaseSensitive) and isPIE then
            self.ID2LayoutStreamingLevel[string.gsub(temp,'_Layout','')]=streamLevel
        elseif UKismetStringLibrary.EndsWith(temp,'_Sound',ESearchCase.CaseSensitive) then
            self.ID2SoundStreamingLevel[string.gsub(temp,'_Sound','')]=streamLevel          
        elseif UKismetStringLibrary.EndsWith(temp,'_Design',ESearchCase.CaseSensitive) then
            if not IsInDungeon then
                self.ID2DesignStreamingLevel[string.gsub(temp,'_Design','')]=streamLevel
            end
            -- if string.find(temp,'East') then
          	-- 	self:InithomeLevel2IDInfo(streamLevel, temp, '_Design')
            -- end
        elseif UE4.UKismetStringLibrary.Contains(temp, "_DungeonDesign") then
            if IsInDungeon then
                -- StringIndex从0开始
                local StringIndex = UE4.UKismetStringLibrary.FindSubstring(temp, "_DungeonDesign") 
                self.ID2DesignStreamingLevel[string.sub(temp, 1, StringIndex)] = streamLevel
                if not self.DungeonLevels then
                    self.DungeonLevels = {}
                end
                table.insert(self.DungeonLevels, streamLevel)
            end
        elseif UKismetStringLibrary.EndsWith(temp,'_NavMesh',ESearchCase.CaseSensitive) then
			local levelName=string.gsub(temp,'_NavMesh','')
			self.ID2NavMeshStreamingLevel[levelName]=streamLevel
			local json= self:GetLevelJsonByLevelName(levelName)
			if not URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self) then
				self.LevelName2Center:Add(packageName,FVector2D(json.level_center[1],json.level_center[3]))
				self.StreamLevel2ID:Add(streamLevel,json.id)
				self.LevelID2Yaw:Add(json.id,json.rot)
				self.id2LevelNameAndTransform[json.id]={string.gsub(json.struct,"/Game/Maps/Datas/Data_Design/",""),FVector(json.P[1],json.P[3],json.P[2]),json.rot}
			end
            -- coroutine.resume(coroutine.create(self.LoadNavMesh), self, temp)
        elseif bIsGameplayLevel or bIsHomeLevel then
        	self:InithomeLevel2IDInfo(streamLevel, temp, '_Gameplay')
        end
    end
    if CommonUtils.IsEmpty(self.homeLevel2ID) then
        for LevelName, StreamingLevel in pairs(self.ID2DesignStreamingLevel) do
            self:InithomeLevel2IDInfo(StreamingLevel, LevelName, '')
        end
    end
	for ArtLevelID, _ in pairs(self.ID2ArtStreamingLevel) do
		for DesignLevelID, _ in pairs(self.ID2DesignStreamingLevel) do
			if string.find(ArtLevelID, DesignLevelID) then
				self.DesignId2ArtId[DesignLevelID] = ArtLevelID
			end
		end
	end
	self.startPoint=self:GetStartPointByManager(self.enterLevelID,self.StartIndex)
    -- if not self.startPoint then
    --     self:GetRandStartPoint()
    -- end

	-- for regionID, subRegion in pairs(DataMgr.SubRegion) do
    --     if self.ID2ArtStreamingLevel[subRegion.SubRegionLevel] then
    --         self.LevelID2RegionID[subRegion.SubRegionLevel] = regionID
    --         self.RegionID2LevelID[regionID] = subRegion.SubRegionLevel
    --     end
    -- end

	for regionID, subRegion in pairs(DataMgr.SubRegion) do
        if self.ID2DesignStreamingLevel[subRegion.SubRegionLevel] then
			-- for SubArtLevelId, _ in pairs(self.ID2ArtStreamingLevel) do
				-- if string.find(SubArtLevelId, subRegion.SubRegionLevel) and not self.ID2DesignStreamingLevel[SubArtLevelId] then
					-- self.LevelID2RegionID[SubArtLevelId] = regionID
					self.LevelID2RegionID[subRegion.SubRegionLevel] = regionID
					self.RegionID2LevelID[regionID] = subRegion.SubRegionLevel
				-- end
			-- end
        end
    end
end


function M:InithomeLevel2IDInfo(streamLevel, temp, SubStr)
    if WorldTravelSubsystem(self):IsDungeonWorld() then
        return
    end
	self.homeLevel2ID[streamLevel:GetLoadedLevel()]=string.gsub(temp, SubStr,'')
    if not self.enterLevelID then
        self.enterLevelID=temp
    end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode ~= nil then
        GameMode:AddSubGameModeInfo(string.gsub(temp, SubStr,''), streamLevel:GetLoadedLevel())
    end
end

function M:InitWorldLoad(StreamLevels)
	self:InitLevelInfo(StreamLevels)
	if self.TempLevelDoor then
		for _,door in pairs(self.TempLevelDoor) do
			self:RealSetLevelDoor(door)
		end
	end
    self:GetAllLevelVolume()
    for Index = 1,self.volumeArray:Length() do
        local volume = self.volumeArray:GetRef(Index)
        local level=UE4.URuntimeCommonFunctionLibrary.GetLevel(volume)
        volume.loadName=self.homeLevel2ID[level]
        volume.WorldLoader=self
    end
    self.GetLevels=true
    self:SetActorTickEnabled(false)
	-- if not URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self) then
	-- 	if self.TempGridframe and #self.TempGridframe>0 then
	-- 	    for _,gridframe in pairs(self.TempGridframe) do
	-- 	        self.Super.AddGridFrame(self,gridframe)
	-- 	    end
	-- 	end
	-- end

	local IsInDungeon = WorldTravelSubsystem(self):IsDungeonWorld()
    if self.enterLevelID and not IsInDungeon then
		self:SetPlayerTrans()
        self:LoadArtLevel(self.enterLevelID)

        --目前只有矿坑走这里，因为区域数据迭代问题，直接load所有关卡
        -- if not URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self) then
        --     for id,_ in pairs(self.ID2ArtStreamingLevel) do
        --         if id ~= self.enterLevelID then
        --             self:LoadArtLevel(id)
        --         end
        --     end
        -- end
    elseif IsInDungeon and not IsDedicatedServer(self) then
        self:DungeonSetPlayerTrans()
    end
    self:SetForceGCAfterLevelStreamedOut(false)
end

function M:AddGridFrame(GridFrame)
	if URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self) then
		self:InitLevelInfo()
		self.Super.AddGridFrame(self,GridFrame)
		return
	end
    if self.GetLevels then
        return
    end
    if not self.TempGridframe then
        self.TempGridframe={}
    end
    self.TempGridframe[#self.TempGridframe+1]=GridFrame
end

function M:GetLevelJsonByLevelName(LevelName)
	if not self.points then
		return
	end
    for i=1,#self.points do
        if string.find(self.points[i].struct,LevelName) then
            return self.points[i]
        end
    end
end

function M:GetLevelId(Actor)
	if self.WorldCompositionSubSystem then
		return self.WorldCompositionSubSystem:GetObjectLevelId(Actor)
	end
	return self.Super.GetLevelId(self, Actor)
end

function M:GetLevelIdByRegionId(RegionId)
    return self.RegionID2LevelID[RegionId]
end

function M:LoadArtLevel(LevelName)
	if URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self) then
		self:InitLevelInfo()
		DebugPrint("WorldComposition, LoadArtLevel", LevelName)
		LevelName = string.gsub(LevelName,'_Gameplay','')
		if self.id2NeedLoad[LevelName] then
			return
		end
		self.id2NeedLoad[LevelName] = true
		self:AddTimer(0.7, self.CheckWorldCompositionLevelLoaded, true, 0, "CheckWorldCompositionLevelLoaded", nil, LevelName)
		return
	end 
    coroutine.resume(coroutine.create(self.Load), self, LevelName)
end

function M:CheckWorldCompositionLevelLoaded(id)
	-- DebugPrint("WorldComposition, CheckWorldCompositionLevelLoaded", id)
    self:SetLoadProgress(self.WorldCompositionSubSystem:GetLoadedLevelPercent() * 100)
    DebugPrint("JLy CheckWorldCompositionLevelLoaded", self.WorldCompositionSubSystem:GetLoadedLevelPercent() * 100)
	
	-- 显示关卡加载状态信息
	if self.WorldCompositionSubSystem and _G.EnableShowLevelLoadingInfo then
		local Message = ""
		
		-- 获取所有关卡的详细状态
        local LevelInfos = self.WorldCompositionSubSystem:GetAllLevelLoadingInfo()
        if LevelInfos and LevelInfos:Num() > 0 then
            -- 按状态分组显示
            local NotLoadedList = {}
            local LoadingList = {}
            local LoadedList = {}
            
            local LevelCount = LevelInfos:Num()
            for i = 1, LevelCount do
                local LevelInfo = LevelInfos[i]
                if LevelInfo then
                    if LevelInfo.Status == 0 then -- NotLoaded
                        table.insert(NotLoadedList, LevelInfo.LevelName)
                    elseif LevelInfo.Status == 1 then -- Loading
                        table.insert(LoadingList, LevelInfo.LevelName)
                    elseif LevelInfo.Status == 2 then -- Loaded
                        table.insert(LoadedList, LevelInfo.LevelName)
                    end
                end
            end
            
            -- 每行显示4个关卡名字
            local ItemsPerLine = 4
            
            -- 显示正在加载的关卡（最重要）
            if #LoadingList > 0 then
                Message = Message .. "\n[正在加载] (" .. #LoadingList .. ")\n"
                for i, LevelName in ipairs(LoadingList) do
                    Message = Message .. string.format("%d. %s  ", i, LevelName)
                    -- 每4个换行
                    if i % ItemsPerLine == 0 and i < #LoadingList then
                        Message = Message .. "\n"
                    end
                end
                Message = Message .. "\n"
            end
            
            -- 显示已加载的关卡
            if #LoadedList > 0 then
                Message = Message .. "\n[已加载] (" .. #LoadedList .. ")\n"
                for i, LevelName in ipairs(LoadedList) do
                    Message = Message .. string.format("%d. %s  ", i, LevelName)
                    -- 每4个换行
                    if i % ItemsPerLine == 0 and i < #LoadedList then
                        Message = Message .. "\n"
                    end
                end
                Message = Message .. "\n"
            end
            
            -- 显示未加载的关卡
            if #NotLoadedList > 0 then
                Message = Message .. "\n[未加载] (" .. #NotLoadedList .. ")\n"
                for i, LevelName in ipairs(NotLoadedList) do
                    Message = Message .. string.format("%d. %s  ", i, LevelName)
                    -- 每4个换行
                    if i % ItemsPerLine == 0 and i < #NotLoadedList then
                        Message = Message .. "\n"
                    end
                end
                Message = Message .. "\n"
            end
        end
        
        -- 只在内容变化时才更新显示，避免频繁闪烁
        if not self.LastLevelLoadingMessage or self.LastLevelLoadingMessage ~= Message then
            self.LastLevelLoadingMessage = Message
            -- 调小字号，从1.2改为0.7，让文字更小更紧凑
            -- 显示时间改为5秒，让信息持续显示
            URuntimeCommonFunctionLibrary.AddOnScreenDebugMessage(29, 5.0, FColor(255, 255, 255), Message, false, FVector2D(0.7, 0.7))
        end
	end
	
	if not self.WorldCompositionSubSystem then
		-- DebugPrint("WorldComposition, CheckWorldCompositionLevelLoaded No SubSystem")
		return
	end
	if not self.WorldCompositionSubSystem:IsWorldCompositionIdle(self) then
		-- DebugPrint("WorldComposition, CheckWorldCompositionLevelLoaded Not Idle")
		return
	end

	for id, _ in pairs(self.id2NeedLoad) do
		self:OnArtLevelLoadedCallback(id)
		self.id2NeedLoad[id] = nil
		self:OnLevelLoaderReady()
	end
	for _, _ in pairs(self.id2NeedLoad) do
		return
	end
    local GameState = UGameplayStatics.GetGameState(self)
    if GameState and GameState:IsInDungeon() then
        self:OnLevelLoaderReady()
    end
	self:RemoveTimer("CheckWorldCompositionLevelLoaded")
end

function M:LoadNavMesh(LevelName)
    UGameplayStatics.LoadStreamLevel(self,LevelName,true,true)
end

function M:Load(LevelName)
    if UAsyncFunctionLibrary.CheckStreamLevelBeLoadState(self,LevelName..'_Art',true) then 
        print(_G.LogTag,'CheckStreamLevelBeLoadState Failed:'..LevelName)
        return
    end
    self.id2NeedLoad[LevelName] = true
    if self.ID2ArtStreamingLevel[LevelName] then
        UGameplayStatics.LoadStreamLevel(self,LevelName..'_Art',true,true)
    end
    if self.ID2LayoutStreamingLevel[LevelName] then
        UGameplayStatics.LoadStreamLevel(self,LevelName..'_Layout',true,true)
    end
    if self.ID2SoundStreamingLevel[LevelName] then
        UGameplayStatics.LoadStreamLevel(self,LevelName..'_Sound',true,true)
    end
    -- if self.ID2NavMeshStreamingLevel[LevelName] then
    --     UGameplayStatics.LoadStreamLevel(self,LevelName..'_NavMesh',true,false)
    -- end
end

function M:UnloadArtLevel(LevelName)
	if URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self) then
		self:BeforeLevelUnloadedCallback(LevelName)
		self:OnArtLevelUnloadedCallback(LevelName)
        return
    end
    local artLevelName=LevelName
    if self.ID2ArtStreamingLevel[artLevelName]:GetLoadedLevel() ==nil then
        return
    end
    if not self:GetLevelLoaded(artLevelName) then
        return
    end
    self.ArtLevelLoaded:Add(artLevelName,false)
    -- 在大世界关卡卸载的时候进行存储更新信息
    self:BeforeLevelUnloadedCallback(LevelName)

    coroutine.resume(coroutine.create(self.Unload), self, LevelName)
    self:OnArtLevelUnloadedCallback(LevelName)
end

function M:Unload(LevelName)
    if self.ID2ArtStreamingLevel[LevelName] then
        UGameplayStatics.UnloadStreamLevel(self,LevelName..'_Art',true)
    end
    if self.ID2LayoutStreamingLevel[LevelName] then
        UGameplayStatics.UnloadStreamLevel(self,LevelName..'_Layout',true)
    end
    if self.ID2SoundStreamingLevel[LevelName] then
        UGameplayStatics.UnloadStreamLevel(self,LevelName..'_Sound',true)
    end
    -- if self.ID2NavMeshStreamingLevel[LevelName] then
    --     UGameplayStatics.UnloadStreamLevel(self,LevelName..'_NavMesh',false)
    -- end
end


function M:OnArtLevelLoaded()
	-- todo @fanyuxiao 这里直接返回会不会有问题？ 是不是所有的关卡加载都是主动由LoadArtLevel发起的？
	if URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self) then
		return
	end
    for id,streamLevel in pairs(self.ID2ArtStreamingLevel) do
        if streamLevel:GetLoadedLevel()~=nil and not self:GetLevelLoaded(id) and self.id2NeedLoad[id] then
            self.ArtLevelLoaded:Add(id,true)
            self.id2NeedLoad[id] = nil
            coroutine.resume(coroutine.create(self.WorldLoaderCheckArtLevelLoaded), self, streamLevel:GetLoadedLevel(),id)
            break;
        end
    end
end

function M:WorldLoaderCheckArtLevelLoaded(level, id)
    while true do
        if not UE4.UKismetSystemLibrary.IsValid(level) then
            return
        end
        if UE.UAsyncFunctionLibrary.CheckLevelActorsInitialized(level) then
            break
        end
        UE.UKismetSystemLibrary.Delay(self, 0.1)
    end
    self:OnArtLevelLoadedCallback(id)
	self:OnLevelLoaderReady()
end

function M:OnLevelLoaderReady()
	if not self.levelLoadComplete then
        self.levelLoadComplete=true
        self:LevelLoaderReady()
        self:ReleaseInitialBuildingLock()
		-- if URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self) then
        --     local GameMode = UGameplayStatics.GetGameMode(self)
        --     GameMode:SetEnterLevelStateReady()
        -- end
    end
end

--和拼接关不同，wc里需要先设置位置再LevelLoaderReady，所以两处调用此方法：
--1.客户端及单机进入关卡时调用
--2.ds在AEMGameMode::RealInit内调用SetPlayerTrans
--最终设置位置：
--单机走RequestAsyncTravel
--DS走BP_StartAndEndPoint_C:InitSetPlayerTrans 
--客户端需要单独用个相机SetViewTargetWithWC先加载场景，再在player设置过来后把镜头设置回去
function M:DungeonSetPlayerTrans()
    if IsDedicatedServer(self) or WorldTravelSubsystem(self):IsDungeonWorld() then
        if not self.startPoint then
            self:GetRandStartPoint()
        end
        if not self.startPoint then
            DebugPrint('DungeonSetPlayerTrans Delay...')
            self:AddTimer(0.1,self.DungeonSetPlayerTrans)
            return
        end
        if IsStandAlone(self) then
            local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
            local Transform = self.startPoint:GetTransform(0)
            self.WorldCompositionSubSystem:RequestAsyncTravel(Player, Transform, {self, function()
                -- self:OnLevelLoaderReady()--LevelLoaderReady之后才能传送结束，EMGameState->CheckGameModeStateEnable()所以下面再开个Timer去ready
            end}, true, false, false)
            self:AddTimer(0.7, self.CheckWorldCompositionLevelLoaded, true, 0, "CheckWorldCompositionLevelLoaded", nil, nil)
        elseif IsDedicatedServer(self) then
            self.startPoint:InitSetPlayerTrans()
        elseif IsClient(self) then
            local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
            local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
            local TargetLoc = nil
            if PlayerController.PlayerState and PlayerController.PlayerState.bIsEMInactive then--断线重连
                TargetLoc = Player:K2_GetActorLocation()
            elseif not UKismetMathLibrary.EqualEqual_VectorVector(PlayerController.TargetBornLocation,FVector(0,0,0),0.001) then--中途加入
                TargetLoc = PlayerController.TargetBornLocation
            end
            local Transform = nil
            if TargetLoc then
                Transform = FTransform()
                Transform.Translation = TargetLoc
            else
                Transform = self.startPoint:GetTransform(0)
            end
            if not self.InitCameraActor then
                self.InitCameraActor = self:GetWorld():SpawnActor(ACameraActor:StaticClass(), Transform)
            end
            self.WorldCompositionSubSystem:SetViewTargetWithWC(self.InitCameraActor,function()
            end, true, false)
            self:AddTimer(0.7, self.CheckWorldCompositionLevelLoaded, true, 0, "CheckWorldCompositionLevelLoaded", nil, nil)
        end
    end
end

function M:SetEnteredPlayerTrans(PlayerController)
    if not self.startPoint then
        self:GetRandStartPoint()
    end
    if self.startPoint then
        self.startPoint:SetEnteredPlayerTrans(PlayerController)
    end
end

function M:RealSetNewEnteredPlayerTrans(AvatarEidStr)
    if(self.startPoint==nil) then
        self:GetRandStartPoint()
    end
    self.startPoint:RealSetNewEnteredPlayerTrans(AvatarEidStr)
end

function M:SetPlayerTrans()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local Avatar = GWorld:GetAvatar()
    if not Avatar and not IsDedicatedServer(self) then return end
    if IsDedicatedServer(self) or (GameMode and GameMode:IsInDungeon()) then
        self:DungeonSetPlayerTrans()
        return
    end
    if self:HandleQuestChainInitLocation(Avatar, self.EnterRegionType) then
        GWorld.logger.error("ZJT_ 本次位置恢复 被任务接管 由任务设置玩家所在位置 ")
    end
    DebugPrint("ZJT_ Set Current PlayerLocation ", Avatar.CurrentRegionId, self.enterLoc,self.StartIndex)
    if self.enterLoc and self.enterLoc ~= FVector(0, 0, 0) then
        self:InitSetPlayerTrans()
    else
		if not self.startPoint then
			self.startPoint=self:GetStartPointByManager(self.enterLevelID,self.StartIndex)
			-- if not self.startPoint then
			-- 	self:GetRandStartPoint()
			-- end
		end
		if not self.startPoint then
            self:AddTimer(0.5,self.SetPlayerTrans)--保底，可能会出现StartPoint还未加载的情况
			return
		end
        self.startPoint:SetPlayerTrans()
		local Player =  UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
		local MovementComponent = Player:GetMovementComponent()
        MovementComponent.bIsAsyncTraveling = false
    end
end

function M:InitSetPlayerTrans()
	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then return end
	if self.WorldCompositionSubSystem then
		local Transform = FTransform()
		local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
		local NewTranslation = self.enterLoc --+ FVector(0, 0, Player.CapsuleComponent:GetUnscaledCapsuleHalfHeight())
		Transform.Translation = NewTranslation
		-- Transform.Rotation = self.enterRot
		self.WorldCompositionSubSystem:RequestAsyncTravel(Player, Transform, {self, self.OpenPlayerPositionSync}, true, true)
		local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
		Player:K2_SetActorRotation(self.enterRot, false)
		local Controller=UE4.UGameplayStatics.GetPlayerController(self, 0)
		Controller:SetControlRotation(self.enterRot)
		return
	end
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
	local NewTranslation = self.enterLoc + FVector(0, 0, Player.CapsuleComponent:GetUnscaledCapsuleHalfHeight())
	Player:K2_SetActorLocation(NewTranslation, false, nil, true)
	Player:K2_SetActorRotation(self.enterRot, false)
	local Controller=UE4.UGameplayStatics.GetPlayerController(self, 0)
	Controller:SetControlRotation(self.enterRot)
    self:OpenPlayerPositionSync()
end

function M:GetRegionIdByLocation(location)
    local id = self:GetLevelIdByLocation(location)
    if self.LevelID2RegionID[id] then
        return self.LevelID2RegionID[id]
    end
    return -1
end

-- function M:GetRegionIdBySubLevelId(SubLevelName, Loc)
-- 	if self.WorldCompositionSubSystem and self.WorldCompositionSubSystem.EMWorldSetting and self.WorldCompositionSubSystem.EMWorldSetting.bNewWc then
-- 		return self:GetRegionIdByLocation(location)
-- 	end
-- 	local LevelName = self.WorldCompositionSubSystem:GetParentLevelId(SubLevelName, Loc)
-- 	return self:GetRegionIdByLevelId(LevelName)
-- end

function M:GetStartPointByManager(LevelID,StartIndex)
    DebugPrint('GetStartPointByManager', LevelID, StartIndex)
	if not LevelID then
		return nil
	end
    local RealLevelId = self:GetRegionIdByLevelId(LevelID)
    if RealLevelId == -1 then
        return
    end
    RealLevelId = self:GetLevelIdByRegionId(RealLevelId)
    local targetLevel=nil
    -- if string.find(RealLevelId,'East') then--临时处理
    --     if self.ID2DesignStreamingLevel[RealLevelId] then
    --         targetLevel = self.ID2DesignStreamingLevel[RealLevelId]:GetLoadedLevel()
    --     end
    -- else
        for level, id in pairs(self.homeLevel2ID) do
            if id==RealLevelId then
                targetLevel=level
            end
        end
    -- end
 
    if self.StartPointManagers==nil or #self.StartPointManagers==0 then
        self.StartPointManagers=UGameplayStatics.GetAllActorsOfClass(self,LoadClass('/Game/BluePrints/Common/Level/BP_StartPointManager.BP_StartPointManager_C')):ToTable()
    end
    for _, manager in pairs(self.StartPointManagers) do
        if URuntimeCommonFunctionLibrary.GetLevel(manager) == targetLevel then
            if not StartIndex or StartIndex > manager.StartPoints:Length() then
                StartIndex = 1
            end
            local Res = manager.StartPoints:GetRef(StartIndex)
            return Res
        end
    end
    return nil
end

function M:BeforeLevelUnloadedCallback(LevelName)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if IsValid(GameMode) and not IsValid(GameMode:GetWCSubSystem()) then
        GameMode:SetSnapShot(LevelName)
    end
    if not self.ArtLevelUnLoadEvent[LevelName] then return end
    for _, func in pairs(self.ArtLevelUnLoadEvent[LevelName]) do
        func(self, LevelName)
    end
end

function M:AfterLevelLoadeCallback(LevelName)
    if not self.ArtLevelLoadEvent[LevelName] then return end
    for _, func in pairs(self.ArtLevelLoadEvent[LevelName]) do
        func(self, LevelName)
    end
end

function M:OpenPlayerPositionSync()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    if Avatar:CheckCurrentSubRegion() and Avatar:CheckSubRegionType(nil,CommonConst.SubRegionType.Field) and not Avatar.IsOpenPlayerPositionSync then
        Avatar:PlayerEnterBigWorld()
    end
    if not self.levelLoadComplete then return end
    Avatar:ExeRegionSkipCallbck(Avatar.CurrentRegionId, "Enter")
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if Player and GameMode and not GameMode:GetDungeonComponent() then
        Player:CreatePhantomOnLevelTransition()
    end
end

function M:OpenRegionDataRecover()
end

function M:GetRegionIdByLevelId(LevelName)
    if self.LevelID2RegionID[LevelName] then
        return self.LevelID2RegionID[LevelName]
    end
    return -1
end

-- 拼接区域目前全加载
function M:OnArtLevelLoadRecoverRegionData(TargetLevelId)
end

-- 拼接区域目前全加载
function M:OnArtLevelUnLoadSaveRegionData(TargetLevelId)
    -- local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    -- local TargetRegionId = self.LevelID2RegionID[TargetLevelId]
    -- local Avatar = GWorld:GetAvatar()
    -- if GameMode and Avatar and Avatar:CheckCurrentSubRegion(TargetRegionId) then
    --     GameMode:ClearLocalCache(TargetRegionId, TargetLevelId, TargetLevelId)
    -- end
end

---- 这些绑定的方法是必要的，也就是加载和卸载必须要处理的，对于临时的可以绑定在BindArt
------------- 加载 卸载 ------------
function M:ArtLevelBindEvent(IsRecover)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not IsValid(GameMode) then return end
    for LevelName, SubRegionId in pairs(self.LevelID2RegionID) do
        local LevelName, LevelGameMode = GameMode:GetLevelGamemModeAndLevelName(SubRegionId)
        if LevelGameMode.IsActive then
            self:OnArtLevelLoadRecoverRegionData(LevelName)
        end
        if not IsRecover then 
            if not self.ArtLevelLoadEvent[LevelName] then
                self.ArtLevelLoadEvent[LevelName] = {}
            end
            table.insert(self.ArtLevelLoadEvent[LevelName], self.OnArtLevelLoadRecoverRegionData)
            if not self.ArtLevelUnLoadEvent[LevelName] then
                self.ArtLevelUnLoadEvent[LevelName] = {}
            end
            table.insert(self.ArtLevelUnLoadEvent[LevelName], self.OnArtLevelUnLoadSaveRegionData)
        end
    end
end

function M:OpenInitSuit()
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local Avatar = GWorld:GetAvatar()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if PlayerCharacter.InitSuccess and PlayerCharacter:IsMainPlayer() and Avatar and (Avatar:IsRealInBigWorld() or Avatar:IsInEnterBigWorld())then
        GameMode:InitRegionSuit(Avatar, Avatar:GetSubRegionId2RegionId())
    else
        EventManager:AddEvent(EventID.OnCharacterInitSuitRecover, PlayerCharacter, PlayerCharacter.OnCharacterInitSuitRecover)
    end
end

function M:RecoverArtLevelBreakable()
    -- local RootPath = UBlueprintPathsLibrary.ProjectContentDir()..Const.BreakableJsonPath ----- TODO
    -- for ArtName, ArtId in pairs(self.levelName2Id) do
    --     local ArtFilePath = RootPath..ArtName..".json"
    --     if UBlueprintPathsLibrary.FileExists(ArtFilePath) then
    --         local FileInfo = UE4.URuntimeCommonFunctionLibrary.LoadFile(ArtFilePath)
    --         local ArtLevelJson = JsonDecode.decode(FileInfo)
    --         local OffsetTransform = self.ID2ArtStreamingLevel[ArtId].LevelTransform
    --         for _, BreakableInfo in pairs(ArtLevelJson) do
    --             local BreakableTransform = BreakableInfo.Transform
    --             local BreakableClass = BreakableInfo.ClassReferencePath
    --             local Location = BreakableTransform.Location
    --             local Rotation = BreakableTransform.Rotation
    --             local Size = BreakableTransform.Size
    --             local SelfLocation = FVector(Location.X, Location.Y, Location.Z)
    --             local SelfRotation = FRotator(Rotation.Pitch, Rotation.Yaw, Rotation.Roll)
    --             local SelfSize = FVector(Size.X, Size.Y, Size.Z)
    --             local NewVector = UKismetMathLibrary.GreaterGreater_VectorRotator(SelfLocation, OffsetTransform.Rotation:ToRotator())
    --             local Transform = UE4.UKismetMathLibrary.MakeTransform(NewVector + OffsetTransform.Translation , SelfRotation + OffsetTransform.Rotation:ToRotator(), SelfSize)
    --             local DecalActor = self:GetWorld():SpawnActor(LoadClass(BreakableClass), Transform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn, nil, nil, nil)
    --         end
    --     else
    --         -- DebugPrint("ZJT_ 当前不存在文件 ", ArtFilePath)
    --     end
        
    -- end
end

function M:ReAddSubGameModeInfo()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode == nil then
        return
    end
    for Level, LevelName in pairs(self.homeLevel2ID) do
        GameMode:AddSubGameModeInfo(LevelName, Level)
        if self:GetLevelLoaded(LevelName) then 
            GameMode:TriggerActiveSubGameModeInfo(LevelName)
        end
    end
end

function M:HandleEnterRegionType(Avatar, EnterRegionType)
    DebugPrint("ZJT_ HandleEnterRegionType ", EnterRegionType)
    if not CommonConst.EnterRegionType[EnterRegionType] then return end
    self.EnterRegionType = EnterRegionType
    local EnterRegionTypeFunc = "Handle"..CommonConst.EnterRegionType[EnterRegionType]
    self[EnterRegionTypeFunc](self, Avatar, EnterRegionType)
end

function M:HandleGM(Avatar, EnterRegionType)
    self.enterLevelID = DataMgr.SubRegion[Avatar.CurrentRegionId].SubRegionLevel
    self.StartIndex = Avatar.StartIndex
end

function M:HandleQuestChainInitLocation(Avatar, EnterRegionType)
    if EnterRegionType ~= CommonConst.EnterRegionType.Recover then return false end
    local QuestChain = Avatar.QuestChains[Avatar.TrackingQuestChainId]
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    DebugPrint("ZJT_ HandleQuestChainInitLocation ", Avatar.TrackingQuestChainId)
    if QuestChain and QuestChain:IsDoing() then
        local STLExportInfo = DataMgr.STLExportQuestChain[QuestChain.QuestChainId]
        DebugPrint("ZJT_ HandleQuestChainInitLocation ",  STLExportInfo, QuestChain.DoingQuestId)
        if STLExportInfo and STLExportInfo.Quests[QuestChain.DoingQuestId] then
            local QuestExportInfo = STLExportInfo.Quests[QuestChain.DoingQuestId]
            DebugPrint("ZJT_ HandleQuestChainInitLocation 1111111 ",  QuestExportInfo.SubRegionId, QuestExportInfo.SubRegionId == Avatar:GetCurrentRegionId())
            if QuestExportInfo.SubRegionId and DataMgr.SubRegion[QuestExportInfo.SubRegionId] and QuestExportInfo.SubRegionId == Avatar:GetCurrentRegionId() then
                if QuestChain.LoginPlayerTransform then
                    local NewTargetPointName = QuestChain.LoginPlayerTransform[QuestChain.DoingQuestId]
                    if NewTargetPointName then
                        local NewTargetPoint = GameMode.EMGameState:GetTargetPoint(NewTargetPointName)
                        if NewTargetPoint and NewTargetPoint:IsValid() then
                            self.enterLoc = NewTargetPoint:K2_GetActorLocation()
                            self.enterRot = NewTargetPoint:K2_GetActorRotation()
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

function M:HandleRecover(Avatar, EnterRegionType)
    
    if Avatar:InitRecoverCheck() then
        self.enterLevelID = DataMgr.SubRegion[Avatar:GetLastRegionId()].SubRegionLevel
        local loc = Avatar.LastRegionData:GetLocation()
        local rot = Avatar.LastRegionData:GetRotation()
        self.enterLoc = FVector(loc.X, loc.Y, loc.Z)
        self.enterRot = FRotator(0, rot.Yaw, 0)
        DebugPrint("ZJT_ HandleRecover 成功 ", self.enterLoc, Avatar.LastRegionData.RegionId)
    else
        self.enterLevelID = DataMgr.SubRegion[Avatar.CurrentRegionId].SubRegionLevel
        self.StartIndex = Avatar.StartIndex or 1
        DebugPrint("ZJT_ HandleRecover 失败 ", self.StartIndex, self.enterLevelID,Avatar:InitRecoverCheck())
    end
end

function M:HandleSojourns(Avatar, EnterRegionType)
    self.enterLevelID = DataMgr.SubRegion[Avatar.CurrentRegionId].SubRegionLevel
    self.StartIndex = Avatar.StartIndex
end

function M:HandleSelectMap(Avatar, EnterRegionType)
    self.enterLevelID = DataMgr.SubRegion[Avatar.CurrentRegionId].SubRegionLevel
    self.StartIndex = Avatar.StartIndex
end

function M:HandleDeliver(Avatar, EnterRegionType)
    self.enterLevelID = DataMgr.SubRegion[Avatar.CurrentRegionId].SubRegionLevel
    self.StartIndex = Avatar.StartIndex
end

function M:HandleFirstRegion(Avatar, EnterRegionType)
    self.enterLevelID = DataMgr.SubRegion[Avatar.CurrentRegionId].SubRegionLevel
    self.StartIndex = Avatar.StartIndex
end

function M:SetLevelDoor(door)
    if not self.TempLevelDoor then
        self.TempLevelDoor={}
    end
    table.insert(self.TempLevelDoor,door)
end

function M:RealSetLevelDoor(door)
	if URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self) then
		return
	end
    local level=UE4.URuntimeCommonFunctionLibrary.GetLevel(door)
    for id,streamLevel in pairs(self.ID2DesignStreamingLevel) do
        if streamLevel and streamLevel:GetLoadedLevel() == level then
           local datas=self:GetLevelJsonByLevelName(id).door
           if datas ~=nil then
               for j = 1, #datas do
                   if datas[j].door_name==door.DisplayName then
                        door.if_door=datas[j].if_door==1
                        door.door_state=datas[j].door_state==1
                        door.LevelPathfinding=self.LevelPathfinding
                        door.LevelId=id
                        door.OtherLevelId=self.LevelIDInt2String:Find(datas[j].next_id)
                        self.LevelPathfinding.Name2BpArrowPos:Add(door.LevelId..datas[j].door_name,door)
                        if datas[j].next_id and datas[j].next_id~=-1  then
                            self.LevelPathfinding:AddLevelDoor(id,self.LevelIDInt2String:Find(datas[j].next_id),door.DisplayName)
                        end
                        return
                   end
               end
           end
        end
    end
end

function M:SetLoadProgress(Num)
    if not Num or Num <= 0 or Num >= 100 then
        return
    end
    self.loadProgress= Num
    if self.LoadingUI then
        DebugPrint("SetLoadProgress CloseLoading", self.loadProgress * 0.5)
        -- self.LoadingUI:AddQuene(self.loadProgress * 0.5)
        self.LoadingUI:AddQuene(self.loadProgress * 0.5)
    else
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        self.LoadingUI = GameInstance:GetLoadingUI()
    end
end

function M:ReactiveDungeonDesign()
    if self.DungeonLevels then
        for _, StreamLevel in pairs(self.DungeonLevels) do
            if StreamLevel:ShouldBeLoaded() then
                for Name, _ in pairs(self.ID2DesignStreamingLevel) do
                    self.ID2DesignStreamingLevel[Name] = StreamLevel
                end
                break
             end
        end
    end
end

return M
