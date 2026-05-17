--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
local MiscUtils = require "Utils.MiscUtils"

---@type BP_NewLevelLoader_C
local M = Class("BluePrints.Common.BP_LevelLoader_C")

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

-- function M:ReceiveBeginPlay()
-- end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
--     self:CheckLevelCount()
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

function M:LoadLevelByBPArrow(PlayerCharacter,BPArrow)
    if MiscUtils.IsSimulatedProxy(PlayerCharacter) then
        return
    end
    if self.DungeonMinimumLevel then
        self:StartMinimumLoad(PlayerCharacter,BPArrow)
        return
    end
    local controllerID= UGameplayStatics.GetPlayerControllerID(PlayerCharacter:GetController())
    -- if (not Utils.IsAuthority(PlayerCharacter)) and (not MiscUtils.IsAutonomousProxy(PlayerCharacter)) then
    --     return
    -- end
    local levelId=PlayerCharacter.CurrentLevelId:GetRef(1)
    if BPArrow.LevelId~= levelId and BPArrow.OtherLevelId~= levelId then
        print(_G.LogTag,'WARNING: character level id ERROR from BPArrow:'..BPArrow.DisplayName..'  LevelId:'..BPArrow.LevelID..'  Character level ID:'..levelId)
        return--character身上的levelID有问题，无法判断处于门两侧哪个关卡
    end
    local targetLevelId=levelId
    local otherLevelId=levelId
    if levelId==BPArrow.LevelId then
        targetLevelId=BPArrow.OtherLevelId
    else
        targetLevelId=BPArrow.LevelId 
    end
    if not self.ConnectedLevel or not self.ConnectedLevel[targetLevelId] then
        self:GetConnectedLevel(targetLevelId)
    end
    local PlayerLevels=self:GetPlayerLevels(controllerID)
    if self.ConnectedLevel[targetLevelId] then
        for _,id in pairs(self.ConnectedLevel[targetLevelId]) do
            if id~=otherLevelId and not self:IsCapturePathLevel(id) then
                self:QueueLoadArtLevel(id)
                PlayerLevels[id]=true
            end
        end
    end
end

function M:UnloadLevelByBPArrow(PlayerCharacter,BPArrow)
    if MiscUtils.IsSimulatedProxy(PlayerCharacter) then
        return
    end
    if self.DungeonMinimumLevel then
        self:EndMinimumLoad(PlayerCharacter,BPArrow)
        return
    end
    local controllerID= UGameplayStatics.GetPlayerControllerID(PlayerCharacter:GetController())
    local levelId=PlayerCharacter.CurrentLevelId:GetRef(1)
    if BPArrow.LevelId~= levelId and BPArrow.OtherLevelId~= levelId then
        print(_G.LogTag,'WARNING: character level id ERROR from BPArrow:'..BPArrow.DisplayName..'  LevelId:'..BPArrow.LevelID..'  Character level ID:'..levelId)
        return--character身上的levelID有问题，无法判断处于门两侧哪个关卡
    end
    local targetLevelId=levelId
    local otherLevelId=levelId
    if levelId==BPArrow.LevelId then
        targetLevelId=BPArrow.OtherLevelId
    else
        targetLevelId=BPArrow.LevelId 
    end
    if not self.ConnectedLevel or not self.ConnectedLevel[targetLevelId] then
        self:GetConnectedLevel(targetLevelId)
    end
    if not self.ConnectedLevel[targetLevelId] then
        print(_G.LogTag,'WARNING: cant find level by levelid:'..targetLevelId)
        return
    end

    local PlayerLevels=self:GetPlayerLevels(controllerID)
    if IsDedicatedServer(self) then--服务器需要考虑其他客户端的加载关卡
        local unloadLevels={}
        for _,id in pairs(self.ConnectedLevel[targetLevelId]) do
            table.insert(unloadLevels,id)
        end
        for cid,levels in pairs(self.PlayerLevels) do
            if cid~=controllerID then
                local index=1
                for i=1,#unloadLevels do
                    if unloadLevels[index] and levels[unloadLevels[index]] then
                        table.remove(unloadLevels,index)
                        index=index-1
                    end
                    index=index+1
                end
            else
                for _,id in pairs(self.ConnectedLevel[targetLevelId]) do
                    if id~=otherLevelId and not self:IsCapturePathLevel(id) then
                        levels[id]=false
                    end
                end
            end
        end
        for _,id in pairs(unloadLevels) do
            if id~=otherLevelId and not self:IsCapturePathLevel(id) then
                M.Super.UnloadArtLevel(self,id)
            end
        end
    else
        for _,id in pairs(self.ConnectedLevel[targetLevelId]) do
            if id~=otherLevelId and not self:IsCapturePathLevel(id) then
                M.Super.UnloadArtLevel(self,id)
            end
        end
    end
end

function M:LoadArtLevel(ID,bMakeVisibleAfterLoad,bShouldBlockOnLoad)
end

function M:UnloadArtLevel(ID)
end

function M:QueueLoadArtLevel(ID)
    if self.showAllLevel then
        M.Super.LoadArtLevel(self,ID)
        return
    end
    if not ID or self:GetLevelLoaded(ID) then
        return
    end
    table.insert(self.LevelLoadQueue,ID)
    DebugPrint('NewLevelLoader','LevelLoadQueue In',ID)
    if #self.LevelLoadQueue > 1 then
        return
    elseif #self.LevelLoadQueue == 1 then
        M.Super.LoadArtLevel(self,self.LevelLoadQueue[1])
    end
end

function M:RemoveQueueArtLevel(IDTable)
    if not IDTable then 
        return
    end
    local NewQueue={}
    for Index,QueueId in pairs(self.LevelLoadQueue) do 
        if not IDTable[QueueId] or Index == 1 then--1是当前加载中关卡，由unload去remove
            table.insert(NewQueue,QueueId)
        else
            DebugPrint('NewLevelLoader','LevelLoadQueue RemoveQueueArtLevel',QueueId)
        end
    end
    self.LevelLoadQueue=NewQueue
end

function M:SetLevelDoor(door)
    M.Super.SetLevelDoor(self,door)
    door.LoadLevelByBPArrow=true
end

function M:GetConnectedLevel(LevelId)
    if not self.ConnectedLevel then
        self.ConnectedLevel={}
    end
    local temp=self.LevelPathfinding:GetConnectedLevelID(LevelId):ToTable()
    self.ConnectedLevel[LevelId]=temp
end

function M:OnPreloadComplete()
    M.Super.OnPreloadComplete(self)
    M.Super.LoadArtLevel(self,self.enterLevelID)
    if not self.ConnectedLevel or not self.ConnectedLevel[self.enterLevelID] then
        self:GetConnectedLevel(self.enterLevelID)
    end
    
    self.StartLevels={}
    table.insert(self.StartLevels,self.enterLevelID)
    if self.ConnectedLevel[self.enterLevelID] then
        for _,id in pairs(self.ConnectedLevel[self.enterLevelID]) do
            M.Super.LoadArtLevel(self,id)
            if IsDedicatedServer(self) then
                table.insert(self.StartLevels,id)
            end
        end
    end

    if self.enterNextLevelID then--中途加入或者断线重连在门的范围内时将门两侧全部按规则加载
        if not self.ConnectedLevel or not self.ConnectedLevel[self.enterNextLevelID] then
            self:GetConnectedLevel(self.enterNextLevelID)
        end
        if self.ConnectedLevel[self.enterNextLevelID] then
            for _,id in pairs(self.ConnectedLevel[self.enterNextLevelID]) do
                if id ~=self.enterLevelID then
                    M.Super.LoadArtLevel(self,id)
                    if IsDedicatedServer(self) then
                         table.insert(self.StartLevels,id)
                    end
                end
            end
        end
    end

    if self.CapturePathLevel then--捕获路径加载
        for _,levelId in pairs(self.CapturePathLevel) do 
            M.Super.LoadArtLevel(self,levelId)
        end
    end

    if IsDedicatedServer(self) then
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        if GameMode then
            for  i = 0, GameMode:GetPlayerNum() -1 do
                self:GetPlayerLevels(i)
            end
        end
    end
end

function M:CheckLevelCount()
    local count=0
    for _,loaded in pairs(self.ArtLevelLoaded:ToTable()) do
        if loaded then
            count=count+1
        end
    end
end

function M:GetPlayerLevels(PlayerControllerID)--只有服务器需要维护，客户端和单机无视
    if not self.PlayerLevels then
        self.PlayerLevels={}
    end
    if not self.PlayerLevels[PlayerControllerID] then--初始化角色需要加载的关卡
        local temp={}
        if self.StartLevels then
            for _,id in pairs(self.StartLevels) do
                temp[id]=true
            end
        end
        self.PlayerLevels[PlayerControllerID]=temp
    end
    return self.PlayerLevels[PlayerControllerID]
end

function M:StartMinimumLoad(PlayerCharacter,BPArrow)
    local controllerID= UGameplayStatics.GetPlayerControllerID(PlayerCharacter:GetController())
    local PlayerLevels=self:GetPlayerLevels(controllerID)
    if not self.ConnectedLevel or not self.ConnectedLevel[BPArrow.LevelId] then
        self:GetConnectedLevel(BPArrow.LevelId)
    end
    if not self.ConnectedLevel or not self.ConnectedLevel[BPArrow.OtherLevelId] then
        self:GetConnectedLevel(BPArrow.OtherLevelId)
    end
    local level1=self.ConnectedLevel[BPArrow.LevelId]
    local level2=self.ConnectedLevel[BPArrow.OtherLevelId]
    local levelArray1=TArray('')
    local levelArray2=TArray('')
    for _,levelId in pairs(level1) do
        if BPArrow.OtherLevelId~=levelId then
            levelArray1:Add(levelId)
        end
    end
    for _,levelId in pairs(level2) do
        if levelId~=BPArrow.LevelId then
            levelArray2:Add(levelId)
        end
    end
    self.LevelPathfinding:GetDoorSortedLevels(levelArray1,BPArrow.LevelId,levelArray2,BPArrow.OtherLevelId,BPArrow.DisplayName,self.MinimumLoadLevelPool)
    local UnloadLevelTable={}
    local index=0
    for _,levleId in pairs(levelArray1:ToTable()) do
        if levleId~=BPArrow.LevelId and levleId~=BPArrow.OtherLevelId then
            index=index+1
            if index<=self.MinimumLoadMaxLevelNum-2 then
                self:QueueLoadArtLevel(levleId)
                DebugPrint('NewLevelLoader','StartMinimumLoad:'..levleId..' By:'..BPArrow.LevelId..".."..BPArrow.OtherLevelId..".."..BPArrow.DisplayName)
                PlayerLevels[levleId]=true
            else
                if IsDedicatedServer(self) then
                    -- local unloadCheck=true
                    -- for cid,levels in pairs(self.PlayerLevels) do
                    --     if cid~=controllerID then
                    --         if levels[levleId] then
                    --             unloadCheck=false
                    --         end
                    --     else
                    --         levels[levleId]=false
                    --     end
                    -- end
                    -- if unloadCheck then
                    --     M.Super.UnloadArtLevel(self,levleId)
                    -- end
                else
                    UnloadLevelTable[levleId]=true
                end
            end
        end
    end
    self:RemoveQueueArtLevel(UnloadLevelTable)
    for UnloadId,_ in pairs(UnloadLevelTable) do
        if not self.KeepAliveLevel or not self.KeepAliveLevel[UnloadId] then
            M.Super.UnloadArtLevel(self,UnloadId)
            self.MinimumLoadLevelPool:Remove(UnloadId)
            DebugPrint('NewLevelLoader','StartMinimumUnload:'..UnloadId..' By:'..BPArrow.LevelId..".."..BPArrow.OtherLevelId..".."..BPArrow.DisplayName)
        end
    end
end

function M:EndMinimumLoad(PlayerCharacter,BPArrow)
    local controllerID= UGameplayStatics.GetPlayerControllerID(PlayerCharacter:GetController())
    local PlayerLevels=self:GetPlayerLevels(controllerID)
    local levelId=PlayerCharacter.CurrentLevelId:GetRef(1)
    if not self:CheckLocationInGridframeByLevelId(levelId,PlayerCharacter.CurrentLocation) then
        levelId = self:GetLevelIdByLocation(PlayerCharacter.CurrentLocation)
    end
    if BPArrow.LevelId~= levelId and BPArrow.OtherLevelId~= levelId then
        print(_G.LogTag,'WARNING: character level id ERROR from BPArrow:'..BPArrow.DisplayName..'  LevelId:'..BPArrow.LevelID..'  Character level ID:'..levelId)
        return--character身上的levelID有问题，无法判断处于门两侧哪个关卡
    end
    local otherId=BPArrow.OtherLevelId
    if levelId==otherId then
        otherId=BPArrow.LevelId
    end
    if not self.ConnectedLevel or not self.ConnectedLevel[levelId] then
        self:GetConnectedLevel(levelId)
    end
    local loadLevel=self.ConnectedLevel[levelId] 
    local RestNum = self.MinimumLoadLevelPool:Num()
    if self.MinimumLoadLevelPool:Find(levelId) then
        RestNum=RestNum-1
    end
    local UnloadNum=0--#loadLevel + RestNum - (self.MinimumLoadMaxLevelNum - 1)
    local LoadedLevel={}
    for i=1,#loadLevel do
        if not self.MinimumLoadLevelPool:Find(loadLevel[i]) then
            UnloadNum=UnloadNum+1
        else
            LoadedLevel[loadLevel[i]]=true
        end
    end
    UnloadNum = UnloadNum + RestNum - (self.MinimumLoadMaxLevelNum - 1)
    local UnloadLevelTable={}
    if UnloadNum > 0 and not IsDedicatedServer(self) then--需要卸载
        local KeyTable=self.MinimumLoadLevelPool:Keys()
        for i=KeyTable:Num(),1,-1 do 
            local tempId=KeyTable:Get(i)
            if tempId ~= levelId and not LoadedLevel[tempId] then
                UnloadLevelTable[tempId]=true
                self.MinimumLoadLevelPool:Remove(tempId)
                UnloadNum=UnloadNum-1
                if UnloadNum == 0 then
                    break
                end
            end
        end
    end
    for _,id in pairs(loadLevel) do
        local DoorName,HasDoor = self.LevelPathfinding:GetLevelDoor(levelId,id)
        if HasDoor then
            self:QueueLoadArtLevel(id)
            self.MinimumLoadLevelPool:Add(id,self.LevelPathfinding.Name2BpArrowPos:FindRef(DoorName))
            PlayerLevels[id]=true
            DebugPrint('NewLevelLoader','EndMinimumLoad:'..id..' By:'..BPArrow.LevelId..".."..BPArrow.OtherLevelId..".."..BPArrow.DisplayName)
        else
            error('EndMinimumLoad Find No Door !!!!! LevelId:',levelId,id)
        end
    end
    -- if not self.ConnectedLevel[otherId] then
    --     self:GetConnectedLevel(otherId)
    -- end
    -- local UnloadLevelTable={}
    -- for _,id in pairs(self.ConnectedLevel[otherId]) do
    --     if id~=levelId then
    --         if IsDedicatedServer(self) then
    --             -- local unloadCheck=true
    --             -- for cid,levels in pairs(self.PlayerLevels) do
    --             --     if cid~=controllerID then
    --             --         if levels[id] then
    --             --             unloadCheck=false
    --             --         end
    --             --     else
    --             --         levels[id]=false
    --             --     end
    --             -- end
    --             -- if unloadCheck then
    --             --     M.Super.UnloadArtLevel(self,id)
    --             -- end
    --         else
    --             UnloadLevelTable[id]=true
    --         end
    --     end
    -- end
    self:RemoveQueueArtLevel(UnloadLevelTable)
    for UnloadId,_ in pairs(UnloadLevelTable) do
        if not self.KeepAliveLevel or not self.KeepAliveLevel[UnloadId] then
            M.Super.UnloadArtLevel(self,UnloadId)
            DebugPrint('NewLevelLoader','EndMinimumUnload:'..UnloadId..' By:'..BPArrow.LevelId..".."..BPArrow.OtherLevelId..".."..BPArrow.DisplayName)
        end
    end
end

function M:LoadNextArtLevel()
    PrintTable(self.LevelLoadQueue)
    if #self.LevelLoadQueue>0 then
        table.remove(self.LevelLoadQueue,1)
        if #self.LevelLoadQueue>0 then
            if self:GetLevelLoaded(self.LevelLoadQueue[1]) then
                self:LoadNextArtLevel()
            else
                DebugPrint('NewLevelLoader','LoadNextArtLevel',self.LevelLoadQueue[1],'CurrentQueueNum',#self.LevelLoadQueue)
                M.Super.LoadArtLevel(self,self.LevelLoadQueue[1])
            end
        end
    end
end

function M:LoadLevelByServerBPArrow(CurrentLevelId, OtherLevelId, IsLoad, PlayerCharacter)
    if MiscUtils.IsSimulatedProxy(PlayerCharacter) then
        return
    end
    if not self.LevelId2Doors[CurrentLevelId] then
        GWorld.logger.error("LoadLevelByServerBPArrow But CurrentLevelId Error! ", CurrentLevelId)
        return
    end
    local BPArrow = nil
    for _, Door in pairs(self.LevelId2Doors[CurrentLevelId]) do
        if Door.LevelId == CurrentLevelId and Door.OtherLevelId == OtherLevelId then
            BPArrow = Door 
            break
        end
    end
    if not BPArrow then
        GWorld.logger.error("LoadLevelByServerBPArrow But Can't Find BPArrow! ", CurrentLevelId, OtherLevelId)
        return
    end
    if IsLoad then
        self:StartMinimumLoad(PlayerCharacter, BPArrow)
    else
        self:EndMinimumLoad(PlayerCharacter, BPArrow)
    end
end

function M:TeleportInDedicatedServer(PlayerCharacter, TargetPosition, TargetRotation, TeleportTag)
    if IsDedicatedServer(self) then
        local TargetLevelId = self:GetLevelIdByLocation(TargetPosition)
        if not self.ConnectedLevel[TargetLevelId] then
            self:GetConnectedLevel(TargetLevelId)
        end
        self:QueueLoadArtLevel(TargetLevelId)
        for _,Level in pairs(self.ConnectedLevel[TargetLevelId]) do
            self:QueueLoadArtLevel(Level)
        end
        URuntimeCommonFunctionLibrary.ResetCharacterBaseLocation(PlayerCharacter, TargetPosition, true)
        -- PlayerCharacter:K2_TeleportTo(TargetPosition, TargetRotation, false, nil, false)
        PlayerCharacter:MulticastSetPlayerRotation(TargetRotation)
        if(PlayerCharacter:GetMovementComponent()) then 
            PlayerCharacter:GetMovementComponent():ForceClientUpdate()
        end
        PlayerCharacter.RPCComponent:TeleportInDedicatedServer(TargetPosition, TargetRotation, TeleportTag)
        
        PlayerCharacter:UpdateCurrentLevelId()
        PlayerCharacter:GetEMPlayerState():SetIsDedicatedServerTeleporting(true)
        DebugPrint('NewLevelLoader','SetIsDedicatedServerTeleporting true')
    elseif IsClient(self) or IsStandAlone(self) then
        if IsStandAlone(self) then
            PlayerCharacter:GetEMPlayerState():SetIsDedicatedServerTeleporting(true)
            PlayerCharacter:GetMovementComponent():SetMovementMode(UE4.EMovementMode.Move_None)
        end
        local TargetLevelId = self:GetLevelIdByLocation(TargetPosition)
        if not self.ConnectedLevel[TargetLevelId] then
            self:GetConnectedLevel(TargetLevelId)
        end
        local LoadedLevels = self.ArtLevelLoaded:ToTable()
        for Id, IsLoaded in pairs(LoadedLevels) do
            if IsLoaded and not CommonUtils.HasValue(self.ConnectedLevel[TargetLevelId], Id) and Id ~= TargetLevelId then
                if not self.KeepAliveLevel or not self.KeepAliveLevel[Id] then
                    M.Super.UnloadArtLevel(self,Id)
                    DebugPrint('NewLevelLoader', 'Unload By TeleportInDedicatedServer', Id, TargetLevelId)
                end
            end
        end
        if not LoadedLevels[TargetLevelId] then
            self:QueueLoadArtLevel(TargetLevelId)
            DebugPrint('NewLevelLoader', 'Load By TeleportInDedicatedServer', TargetLevelId)
        end
        for _, LoadId in pairs(self.ConnectedLevel[TargetLevelId]) do
            if not LoadedLevels[LoadId] then
                self:QueueLoadArtLevel(LoadId)
                DebugPrint('NewLevelLoader', 'Load By TeleportInDedicatedServer', LoadId, TargetLevelId)
            end
        end
        self.LoadingUI = GWorld.GameInstance:ShowLoadingUI(UIConst.COMMONCHANGESCENE)
        local SaveLocation = FVector()
        SaveLocation:Set(TargetPosition.X,TargetPosition.Y,TargetPosition.Z)
        local SaveRotation = FRotator()
        SaveRotation:Set(TargetRotation.Pitch,TargetRotation.Yaw,TargetRotation.Roll)
        self:AddTimer(0.1,function()
            local LoadedTable = self.ArtLevelLoaded:ToTable()
            local TotalNum = #self.ConnectedLevel[TargetLevelId] + 1
            local LoadNum = 0
            if not LoadedTable[TargetLevelId] then
                DebugPrint('NewLevelLoader','Not Loaded:', TargetLevelId)
            else
                LoadNum = LoadNum + 1
            end
            for _, LoadId in pairs(self.ConnectedLevel[TargetLevelId]) do
                if not LoadedTable[LoadId] then
                    DebugPrint('NewLevelLoader','Not Loaded:', LoadId)
                else
                    LoadNum = LoadNum + 1
                end
            end
            DebugPrint('NewLevelLoader', 'SetLoadProgress', LoadNum, TotalNum, LoadNum / TotalNum * 2)
            self:SetLoadProgress(LoadNum / TotalNum * 2)
            if LoadNum ~= TotalNum then
                return
            end
            DebugPrint('NewLevelLoader', 'TeleportInDedicatedServer End!!!!!!!!!!!', TeleportTag)
            if(IsValid(PlayerCharacter)) then
                if IsStandAlone(self) then
                    URuntimeCommonFunctionLibrary.ResetCharacterBaseLocation(PlayerCharacter, SaveLocation, true)
                    -- PlayerCharacter:K2_TeleportTo(SaveLocation, SaveRotation, false, nil, false)
                    PlayerCharacter:MulticastSetPlayerRotation(SaveRotation)
                    PlayerCharacter:UpdateCurrentLevelId()
                    local MovementComponent = PlayerCharacter:GetMovementComponent()
                    MovementComponent:SetMovementMode(MovementComponent.DefaultLandMovementMode)
                end
                PlayerCharacter.RPCComponent:TeleportInDedicatedServerEnd(TeleportTag)
            end
            local GameState = UE4.UGameplayStatics.GetGameState(self)
            if GameState.ShouldStopHookInDungeonDelivery then
                GameState.ShouldStopHookInDungeonDelivery = false
            end
            EventManager:FireEvent(EventID.ForceUpdatePlayerCurrentLevelId)
            self:RemoveTimer('TeleportInDedicatedServerHandle')
        end, true, 0, 'TeleportInDedicatedServerHandle')
    end
end

function M:SwitchLoadingGroupId(Id)
    if not IsStandAlone(self) then
        return
    end
    if self.KeepAliveLevel then
        local PlayerCharacter = UGameplayStatics.GetPlayerCharacter(self, 0)
        local CurrentLevels = self.ConnectedLevel[PlayerCharacter.CurrentLevelId:GetRef(1)]
        local LoadedLevels = self.ArtLevelLoaded:ToTable()
        for LevelId, _ in pairs(self.KeepAliveLevel) do
            if LoadedLevels[LevelId] and not CommonUtils.HasValue(CurrentLevels, LevelId) then
                M.Super.UnloadArtLevel(self, LevelId)
                DebugPrint('NewLevelLoader','SwitchLoadingGroupId UnloadLevel:', LevelId)
            end
        end
    end
    self.KeepAliveLevel = {}
    if self.LoadingGroupId and self.LoadingGroupId[Id] then
        self.KeepAliveLevel = self.LoadingGroupId[Id]
        DebugPrint('NewLevelLoader','SwitchLoadingGroupId KeepAliveLevel:',Id)
        PrintTable(self.LoadingGroupId[Id], 2)
    end
end

return M
