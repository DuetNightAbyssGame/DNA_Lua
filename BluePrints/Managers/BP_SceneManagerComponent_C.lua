--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
require "DataMgr"

---@type BP_SceneManagerComponent_C
local BP_SceneManagerComponent_C = Class("BluePrints.Common.TimerMgr")
BP_SceneManagerComponent_C._components = {
    "BluePrints.Common.DelayFrameComponent",
}
local BattleUtils = require "Utils.BattleUtils"
local Json = require "rapidjson"

local SDC_MOUSE_CHECKCOUNT_PER_ROUND = 10    -- 鼠标检测每轮检测鼠标移动的次数
local SDC_MOUSE_REPORT_SERVER_THRESHOLD = 5  -- 鼠标检测上报服务器，本地触发次数阈值

----------------------------------------------------- 本组件通用接口 -----------------------------------------------------

function BP_SceneManagerComponent_C:DebugPrint(...)
    DebugPrint("SceneManagerComponent", ...)
end

function BP_SceneManagerComponent_C:GetExcavationABCIconPath(Index)
    return "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Digging_"..Index..".T_Gp_Digging_"..Index
end

function BP_SceneManagerComponent_C:GetSabotageABCIconPath(Index)
    return "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_DestroyTarget_"..Index..".T_Gp_DestroyTarget_"..Index
end

function BP_SceneManagerComponent_C:GetABCText(Map, Eid, Mod)
    if Map == nil then
        return ""
    end
    if Map.Index[Eid] == nil then
        Map.Index[Eid] = Map.Count
        Map.Count = (Map.Count + 1) % Mod
    end
    return string.char(string.byte('A') + Map.Index[Eid])
end

function BP_SceneManagerComponent_C:GetABCTextByMapName(Map, Eid, Mod) 
    return self:GetABCText(self[Map], Eid, Mod)
end

----------------------------------------------------- 初始化相关函数 -----------------------------------------------------

function BP_SceneManagerComponent_C:Initialize(Initializer)
    self.LoadJsonLevelData = nil
    self.LastAssetName = ""
    self.NeedLoadAssetName = ""
    -- self.Guide2LevelInfo = {}
    self.LoadedWorld = nil
    self.IsInLoading = false
    self.NowLoadResourceHandle = nil
    self.CurSceneGuideEids = {}
    self.IsSceneGuideShow = true
    self.LevelLoader = nil
    -- self.PathfindingEid = {}
    self.SpecialMonsterInfo = {}                                -- 场景里面的一些特殊怪物
    self.DungeonNetMode = CommonConst.DungeonNetMode.Standalone -- 默认以StandAlone切换场景
    local t = FSnapShotInfo()                                   -- 初始化的时候创建一下这个结构体，避免后面直接使用报错
    self.CacheGuideInfo = {}

    self.SabotageABCMap = {
        Count = 0,
        Index = {}  -- Eid -> Index
    }
    self.ExcavationABCMap = {
        Count = 0,
        Index = {}  -- Eid -> Index
    }
    self.RegionOnlineCharacterInfo = {}
    self.CurrentCheckCountInScene = 0                           -- 当前场景检测次数
end

function BP_SceneManagerComponent_C:AddRegionEvent(IsRegion)
    DebugPrint(" BP_SceneManagerComponent_C:AddRegionEvent IsRegion: ", IsRegion)
    if IsRegion then
        self:RegisterTeamEvent()
        EventManager:AddEvent(EventID.AddRegionIndicatorInfo, self, self.AddRegionOnlineCharacterInfo)
        EventManager:AddEvent(EventID.RemoveRegionIndicatorInfo, self, self.RemoveRegionOnlineCharacterInfo)
    end
end

function BP_SceneManagerComponent_C:RemoveRegionEvent()
    DebugPrint(" BP_SceneManagerComponent_C:RemoveRegionEvent")
    TeamController:UnRegisterEvent(self)
    EventManager:RemoveEvent(EventID.AddRegionIndicatorInfo, self)
    EventManager:RemoveEvent(EventID.RemoveRegionIndicatorInfo, self)
end

function BP_SceneManagerComponent_C:NotifyOnWindowResized()
    EventManager:FireEvent(EventID.OnWindowResized)
end

function BP_SceneManagerComponent_C:NotifyOnWindowMoved()
    EventManager:FireEvent(EventID.OnWindowMoved)
end

function BP_SceneManagerComponent_C:OnOtherPlayerEntityChange(Avatars)
    DebugPrint("LHQ_BP_SceneManagerComponent_C:OnOtherPlayerEntityChange")
    PrintTable(Avatars)
    if Avatars then

    end
end

function BP_SceneManagerComponent_C:GetCurSceneName()
    local World = self:GetWorld()
    return World:GetName()
end

function BP_SceneManagerComponent_C:GetTargetActorByName(ActorName)
    local AllActors= TArray(AActor)
    UE4.UGameplayStatics.GetAllActorsOfClass(self, AActor:StaticClass(), AllActors)
    local ActorTab=AllActors:ToTable()
    for i,v in pairs(ActorTab)  do
        local name=v:GetName()
        if(name:find(ActorName)) then
            return v
        end
    end
end

function BP_SceneManagerComponent_C:GetNpcActorInSceneByID(NpcId) -- 已废弃
    local NpcConfig = DataMgr.Npc[NpcId]
    if (not NpcConfig) then
        return
    end
    local NpcObjClass = UE4.UClass.Load(NpcConfig.UnitBPPath)
    local AllActors= TArray(AActor)
    UE4.UGameplayStatics.GetAllActorsOfClass(self, NpcObjClass, AllActors)
    local ActorTab=AllActors:ToTable()
    for _, v in pairs(ActorTab)  do
        if (NpcId == v.UnitId) then
            return v
        end
    end
end

function BP_SceneManagerComponent_C:GetTargetActorInSceneByBPPath(BPPath) -- 已废弃
    local ObjClass = UE4.UClass.Load(BPPath)
    local AllActors= TArray(AActor)
    UE4.UGameplayStatics.GetAllActorsOfClass(self, ObjClass, AllActors)
    return AllActors
end

function BP_SceneManagerComponent_C:UpdateSceneTargetDoorInfo(TargetEid, DoorName, NextLevelID)
    -- if (self.Guide2LevelInfo[TargetEid] == nil) then
    --     self.Guide2LevelInfo[TargetEid] = {LevelID=NextLevelID, InDoorName=DoorName}
    -- else
    --     self.Guide2LevelInfo[TargetEid].LevelID = NextLevelID
    --     self.Guide2LevelInfo[TargetEid].InDoorName = DoorName
    -- end

    if not self.Guide2NextLevelIdMaps:Find(TargetEid) then
        self.Guide2NextLevelIdMaps:Add(TargetEid, NextLevelID)
    end

    if not self.Guide2InDoorNameMaps:Find(TargetEid) then
        self.Guide2InDoorNameMaps:Add(TargetEid, DoorName)
    end

    if self.Guide2NextLevelIdMaps:Find(TargetEid) then
        self.Guide2NextLevelIdMaps:Remove(TargetEid)
        self.Guide2NextLevelIdMaps:Add(TargetEid, NextLevelID)
    end

    if self.Guide2InDoorNameMaps:Find(TargetEid) then
        self.Guide2InDoorNameMaps:Remove(TargetEid)
        self.Guide2InDoorNameMaps:Add(TargetEid, DoorName)
    end

    self:UpdateGuide2LevelDoorInfo(TargetEid, DoorName, NextLevelID, "Update")

end

function BP_SceneManagerComponent_C:IsDungeonScene()
    -- 判断是否是副本场景 拼接场景 副本类型
    local SceneName = self:GetCurSceneName()
    for _, ConfigData in pairs(DataMgr.Dungeon) do
        local PathConfigDataArray = Split(ConfigData.DungeonMapFile, "/")
        local PathConfigLength = #PathConfigDataArray
        local PathGameDataArray = Split(self:GetScenePathName(), "/")
        -- local PathGameLength = #PathGameDataArray
        local IsPathSame = true
        for i = 1, PathConfigLength - 1, 1 do
            if (PathGameDataArray[i] ~= PathConfigDataArray[i]) then
                IsPathSame = false
                break
            end
        end
        local RealNameArray = Split(PathConfigDataArray[PathConfigLength], ".")
        local NameLength = #RealNameArray
        if (SceneName == RealNameArray[NameLength] and IsPathSame and type(ConfigData.DungeonLevel) == "number") then
            return true, ConfigData.IsRandom, ConfigData.DungeonType
        end
    end
    return false, false, ""
end

function BP_SceneManagerComponent_C:GetSceneLoadProgress(SceneId)
    local MapLevelConfig = DataMgr.Dungeon[SceneId]
    if (MapLevelConfig == nil) then
        print(self:GetLogMask(), "GetSceneLoadProgress  MapLevelConfig is nil, SceneId is ", SceneId)
        return 100
    end
    local MapLevelName = MapLevelConfig.DungeonMapFile or "/Game/Maps/Levels/TestLevel/TestScene"
    local NowProgress = UE4.UResourceLibrary.GetLoadProgress(self, MapLevelName, self:GetCurrentLoadSceneResourceId())
    return NowProgress
end

function BP_SceneManagerComponent_C:CheckPlayerIsInDefaultMainCity()
    -- 判断Actor是否在主城场景
    local SceneName = self:GetCurSceneName()
    local PathConfigDataArray = Split(Const.DefaultMainCityFile, "/")
    local PathConfigLength = #PathConfigDataArray
    local PathGameDataArray = Split(self:GetScenePathName(), "/")
    local IsPathSame = true
    for i = 1, PathConfigLength - 1, 1 do
        if (PathGameDataArray[i] ~= PathConfigDataArray[i]) then
            IsPathSame = false
            break
        end
    end
    local RealNameArray = Split(PathConfigDataArray[PathConfigLength], ".")
    local NameLength = #RealNameArray
    if (SceneName == RealNameArray[NameLength] and IsPathSame) then
        return true
    end
    return false
end

function BP_SceneManagerComponent_C:CheckIsInLevelSceneByPath(LevelPath)
    local SceneName = self:GetCurSceneName()
    local PathConfigDataArray = Split(LevelPath, "/")
    local PathConfigLength = #PathConfigDataArray
    local PathGameDataArray = Split(self:GetScenePathName(), "/")
    local IsPathSame = true
    for i = 1, PathConfigLength - 1, 1 do
        if (PathGameDataArray[i] ~= PathConfigDataArray[i]) then
            IsPathSame = false
            break
        end
    end

    local RealNameArray = Split(PathConfigDataArray[PathConfigLength], ".")
    local NameLength = #RealNameArray
    if (SceneName == RealNameArray[NameLength] and IsPathSame) then
        return true
    end
    return false
end

function BP_SceneManagerComponent_C:CheckIsInLevelSceneBySceneId(SceneId)
    local LevelPath = DataMgr.Dungeon[SceneId].DungeonMapFile
    return self:CheckIsInLevelSceneByPath(LevelPath)
end

-------------------------------------------------------  场景指引相关  ---------------------------------------------------
function BP_SceneManagerComponent_C:ReplaceGuideIcon(TargetActorEid, TargetActor, StyleNode, ImgPath)
    -- 替换指引（目前用于捕获怪）
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local GuideName = tostring(TargetActorEid)
    -- RunAsyncTask(self, "ReplaceGuideIcon_GetUIObjAsync" .. GuideName, function(CoroutineObj)
        local GuideIcon = UIManager:GetUIObj(GuideName)
        if GuideIcon == nil then
            GuideIcon = self:GetGuideIconByEid(TargetActorEid)
        end
        if (GuideIcon ~= nil) then
            self:ProcessGuideIconBeforeClose(GuideIcon)
            GuideIcon:Close()
            self:UpdateSceneGuideIcon(TargetActorEid, TargetActor, nil, "Add", true,
                        {
                        GuideIconAni = UIConst.DUNGEONINDICATOR[StyleNode],
                        GuideIconBPPath = "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_MainMission.T_Gp_MainMission",
                        IsReplace=true
                        })
        end
        self.CaptureMonsterEid = TargetActorEid
    -- end)
end

function BP_SceneManagerComponent_C:RecoverGuideIcon()
    -- 恢复原来的指引
    local GuideName = tostring(self.CaptureMonsterEid).."Replace"
    RunAsyncTask(self, "RecoverGuideIcon_GetUIObjAsync" .. GuideName, function(CoroutineObj)
        local GameInstance = GWorld.GameInstance
        local UIManager = GameInstance:GetGameUIManager()
        if not UIManager then
            return
        end
        local GuideIcon = UIManager:GetUIObjAsync(GuideName, CoroutineObj)
        if (GuideIcon ~= nil) then
            self:ProcessGuideIconBeforeClose(GuideIcon)
            GuideIcon:Close()
            --self:UpdateSceneGuideIcon(TargetActorEid, TargetActor, nil, "Add", true, ConfigData)
            self.CurSceneGuideEids[self.CaptureMonsterEid] = nil
            self:UpdateOneSceneGuideIcon(self.CaptureMonsterEid, true, false)
        end
    end)
end

function BP_SceneManagerComponent_C:SetGuideActorInfo(GuideInfo)
    if (GuideInfo == nil) then
        return
    end
    
    local CheckEidIsValid = function(InEid)
        local GameInstance = GWorld.GameInstance
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
        local PlayerState = GameState:GetPlayerState(Player.Eid)
	    if PlayerState then
            local AllPlayerGuideEids = FIntArray()
            if (PlayerState.PlayerGuideEids ~= nil) then
                AllPlayerGuideEids = PlayerState.PlayerGuideEids
            end
            for Index = 1, AllPlayerGuideEids.Items:Num() do
                local TargetEid = AllPlayerGuideEids.Items:GetRef(Index).IntProperty
                if InEid == TargetEid then
                    return true
                end
            end
	    end

        local AllCommonGuideEids = FIntArray()
        if (GameState.GuideEids ~= nil) then
            AllCommonGuideEids = GameState.GuideEids
        end
        for Index = 1, AllCommonGuideEids.Items:Num() do
            local TargetEid = AllCommonGuideEids.Items:GetRef(Index).IntProperty
            if InEid == TargetEid then
                return true
            end
        end

        return false
    end

    if CheckEidIsValid(GuideInfo.SnapShotId) == false then
        DebugPrint("BP_SceneManagerComponent_C:SetGuideActorInfo 序列化数据的SnapShotId不合法 SnapShotId: ", GuideInfo.SnapShotId)
        return
    end

    local ConfigData = DataMgr[GuideInfo.UnitType][GuideInfo.UnitId]
    local GuideOp = (self.CurSceneGuideEids[GuideInfo.SnapShotId] == nil and "Add" or "Modify")
    local IsCommonEid = self:GetEidFromCommonOrPlayer(GuideInfo.SnapShotId)

    self:UpdateSceneGuideIcon(GuideInfo.SnapShotId, nil, GuideInfo.Loc, GuideOp, true, ConfigData, not IsCommonEid, true)
    DebugPrint("BP_SceneManagerComponent_C:SetGuideActorInfo GuideOp: ", GuideOp, "SnapShotId: ", GuideInfo.SnapShotId, "GuideInfo.Loc",GuideInfo.Loc)
    local SnapShotInfo = FSnapShotInfo()
    SnapShotInfo.Loc = GuideInfo.Loc
    SnapShotInfo.SnapShotId = GuideInfo.SnapShotId
    SnapShotInfo.UnitType = GuideInfo.UnitType
    SnapShotInfo.UnitId = GuideInfo.UnitId
    self.CurSceneGuideEids[GuideInfo.SnapShotId] = {Entity = SnapShotInfo, IsDataStruct = true, IsPlayerEid = not IsCommonEid, IsActive = true}
    -- if ((GuideInfo.UnitType=="Monster" or GuideInfo.UnitType=="Mechanism") and self:GetLevelLoader() and self:GetLevelLoader().StartPathfindingToActorByEid and not self.PathfindingEid[GuideInfo.SnapShotId]) then
    if ((GuideInfo.UnitType=="Monster" or GuideInfo.UnitType=="Mechanism") and self:GetLevelLoader() and self:GetLevelLoader().StartPathfindingToActorByEid and not self.PathfindingEid:FindRef(GuideInfo.SnapShotId)) then
        self:GetLevelLoader():StartPathfindingToActorByEid(GuideInfo.SnapShotId) 
        -- self.PathfindingEid[GuideInfo.SnapShotId]=true
        self.PathfindingEid:Add(GuideInfo.SnapShotId, true)
    end
end

-- Entity, IsDataStruct
function BP_SceneManagerComponent_C:GetCurSceneGuideEntityByEid(Eid)
    if (self.CurSceneGuideEids and self.CurSceneGuideEids[Eid]) then
        if self.CurSceneGuideEids[Eid].IsDataStruct then
            return self.CurSceneGuideEids[Eid].Entity, true
        else
            local TargetActor = nil
            local BattleInstance = Battle(self)
            if BattleInstance then
                TargetActor = BattleInstance:GetEntity(Eid)
            end
            return TargetActor, false
        end
    end
    return nil, false
end

function BP_SceneManagerComponent_C:GetCurSceneGuideEntityByData(CurSceneGuideData)
    if (CurSceneGuideData) then
        if CurSceneGuideData.IsDataStruct then
            return nil
        else
            local TargetActor = nil
            local BattleInstance = Battle(self)
            if BattleInstance then
                TargetActor = BattleInstance:GetEntity(CurSceneGuideData.Entity)
            end
            return TargetActor
        end
    end
    return nil
end

function BP_SceneManagerComponent_C:UpdateOneSceneGuideIcon(TargetEid, IsAdd, IsPlayerEid)
    DebugPrint("BP_SceneManagerComponent_C:UpdateOneSceneGuideIcon TargetEid: ", TargetEid, "IsAdd: ", IsAdd, "IsPlayerEid: ", IsPlayerEid)
    self.CurSceneGuideEids = self.CurSceneGuideEids or {}
    if IsAdd == true then
        
        local TargetActor = nil
        local BattleInstance = Battle(self)
        if BattleInstance then
            TargetActor = BattleInstance:GetEntity(TargetEid)
        end

        if IsValid(TargetActor) then
        -- if (IsValid(TargetActor) and (TargetActor.OpenState == nil or TargetActor.OpenState == false)) then
            -- 有这个Actor对象，并且这个对象不是已经打开过的状态
            local GuideOp = (self.CurSceneGuideEids[TargetEid] == nil and "Add" or "Modify")
            self:UpdateSceneGuideIcon(TargetEid, TargetActor, nil, GuideOp, true, nil, IsPlayerEid)
        else
            local GameInstance = GWorld.GameInstance
            local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
            PlayerCharacter.RPCComponent:RequestGuideInfo(TargetEid)
        end
    else
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        local GameInstance = GWorld.GameInstance
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
        local PlayerState = GameState:GetPlayerState(Player.Eid)
	    if PlayerState then
            if (PlayerState.PlayerGuideEids ~= nil) then
                for Index = 1, PlayerState.PlayerGuideEids.Items:Num() do
                    local Eid = PlayerState.PlayerGuideEids.Items:GetRef(Index).IntProperty
                    if (Eid == TargetEid) then
                        return
                    end
                end
            end
	    end

        local Entity, IsDataStruct = self:GetCurSceneGuideEntityByEid(TargetEid)

        DebugPrint("UpdateOneSceneGuideIcon GetCurSceneGuideEntityByEid: ", TargetEid, "IsAdd: ", IsAdd
            , "IsPlayerEid: ", IsPlayerEid, "IsDataStruct", IsDataStruct)
        if (not IsDataStruct) and (UKismetSystemLibrary.IsValid(Entity)) then
            self:UpdateSceneGuideIcon(TargetEid, Entity, nil, "Delete", true, nil, IsPlayerEid)
        else
            self:UpdateSceneGuideIcon(TargetEid, nil, nil, "Delete", true, nil, IsPlayerEid)
        end
    end
end

function BP_SceneManagerComponent_C:AddOneGuideIconWithSkillEffect(TargetEid, IsPlayerEid, GuideDuration, GuideCloseRange)
    local BattleInstance = Battle(self)
    if not BattleInstance then
        return
    end

    local TargetActor = BattleInstance:GetEntity(TargetEid)
    if IsValid(TargetActor) then
        -- 有这个Actor对象，并且这个对象不是已经打开过的状态
        local GuideOp = (self.CurSceneGuideEids[TargetEid] == nil and "Add" or "Modify")
        local ConfigData = DataMgr[TargetActor.UnitType][TargetActor.UnitId]
        local NewConfigData = {
            GuideIconAni = ConfigData.GuideIconAni,
            GuideIconBPPath = ConfigData.GuideIconBPPath,
            GuideIconBPPath2 = ConfigData.GuideIconBPPath2,
            GuideDuration = GuideDuration,
            GuideCloseRange = GuideCloseRange
        }
        self:UpdateSceneGuideIcon(TargetEid, TargetActor, nil, GuideOp, true, NewConfigData, IsPlayerEid)
    -- else
    --     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    --     local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    --     PlayerCharacter.RPCComponent:RequestGuideInfo(TargetEid)
    end
end

function BP_SceneManagerComponent_C:CloseOneGuideIconByTargetEid(TargetEid)
    self:UpdateSceneGuideIcon(TargetEid, nil, nil, "Delete", true, nil, nil)
end

-- function BP_SceneManagerComponent_C:UpdateAllSceneGuideIcon() --已弃用
--     local GameState = UE4.UGameplayStatics.GetGameState(self)
--     if (GameState == nil) then
--         return
--     end
--     self.CurSceneGuideEids = self.CurSceneGuideEids or {}
    
--     local AllGuideEids = FIntArray()
--     if (GameState.GuideEids ~= nil) then
--         AllGuideEids = GameState.GuideEids
--     end
--     local BattleInstance = Battle(self)
--     for Index = 1, AllGuideEids.Items:Num() do
--         local TargetEid = AllGuideEids.Items:GetRef(Index).IntProperty
--         local TargetActor = nil
--         if BattleInstance then
--             TargetActor = BattleInstance:GetEntity(TargetEid)
--         end

--         local IsCombatItemBase = nil
--         if IsValid(TargetActor) and TargetActor.IsCombatItemBase then
--             IsCombatItemBase = TargetActor:IsCombatItemBase()
--         end
--         -- if IsValid(TargetActor) and (TargetActor.OpenState == nil or TargetActor.OpenState == false) and IsCombatItemBase == true then
--         if IsValid(TargetActor) then
--             -- 有这个Actor对象，并且这个对象不是已经打开过的状态
--             local GuideOp = (self.CurSceneGuideEids[TargetEid] == nil and "Add" or "Modify")
--             self:UpdateSceneGuideIcon(TargetEid, TargetActor, nil, GuideOp, true)
--         else
--             local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--             local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
--             PlayerCharacter.RPCComponent:RequestGuideInfo(TargetEid)
--         end
--     end
-- end

function BP_SceneManagerComponent_C:UpdateAllCommonGuideIcon()
    DebugPrint("DebugGuideEid UpdateAllCommonGuideIcon")
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    if (GameState == nil) then
        return
    end
    self.CurSceneGuideEids = self.CurSceneGuideEids or {}
    local CommonGuideInfos = {}
    for k, v in pairs(self.CurSceneGuideEids) do
        DebugPrint("DebugGuideEid UpdateAllCommonGuideIcon self.CurSceneGuideEids Loop key", k, "v.IsPlayerEid", v.IsPlayerEid)
        -- if not v.IsPlayerEid then
        CommonGuideInfos[k] = v
        local GuideIcon = UIManager:GetUIObj(tostring(k))
        -- 此处是队友指引，跳过
        if GuideIcon and GuideIcon.PlayerIndex ~= nil and GuideIcon.PlayerIndex > 0 then
            goto continue
        end
        v.IsActive = false
        ::continue::
        -- end
    end
    local AllGuideEids = FIntArray()
    if (GameState.GuideEids ~= nil) then
        AllGuideEids = GameState.GuideEids
    end
    DebugPrint("BP_SceneManagerComponent_C:UpdateAllCommonGuideIcon AllGuideEids", AllGuideEids.Items:Num())
    local BattleInstance = Battle(self)
    local GameInstance = GWorld.GameInstance
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    for Index = 1, AllGuideEids.Items:Num() do
        local TargetEid = AllGuideEids.Items:GetRef(Index).IntProperty
        DebugPrint("DebugGuideEid UpdateAllCommonGuideIcon GuideEids Loop TargetEid", TargetEid)
        local TargetActor = nil
        if BattleInstance then
            TargetActor = BattleInstance:GetEntity(TargetEid)
        end
        -- 如果这个Eid在当前场景的Eids中，就改active属性
        if CommonGuideInfos[TargetEid] ~= nil then
            CommonGuideInfos[TargetEid].IsActive = true
        end
     
        if IsValid(TargetActor) then
        -- if IsValid(TargetActor) and (TargetActor.OpenState == nil or TargetActor.OpenState == false)then
            -- 有这个Actor对象，并且这个对象不是已经打开过的状态
            -- DebugPrint("DebugGuideEid UpdateAllCommonGuideIcon GuideEids TargetActor.OpenState", TargetActor.OpenState)
            local GuideOp = (CommonGuideInfos[TargetEid] == nil and "Add" or "Modify")
            self:UpdateSceneGuideIcon(TargetEid, TargetActor, nil, GuideOp, true)
        else
            PlayerCharacter.RPCComponent:RequestGuideInfo(TargetEid)
        end
    end

    for k, v in pairs(CommonGuideInfos) do
        if (v) then
            DebugPrint("DebugGuideEid UpdateAllCommonGuideIcon PlayerGuideInfos Loop key", k, "v.IsActive", v.IsActive)
        end
        if (v and not v.IsActive) then
            local Entity = self:GetCurSceneGuideEntityByData(v)
            if (UKismetSystemLibrary.IsValid(Entity)) then
                self:UpdateSceneGuideIcon(k, Entity, nil, "Delete", true)
            else
                self:UpdateSceneGuideIcon(k, nil, nil, "Delete", true)
            end
        end
    end
end

function BP_SceneManagerComponent_C:UpdateAllPlayerGuideIcon()
    DebugPrint("DebugGuideEid UpdateAllPlayerGuideIcon")
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local GameInstance = GWorld.GameInstance
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    local UIManager = GameInstance:GetGameUIManager()
    if GameState == nil or Player == nil then
        return
    end
    self.CurSceneGuideEids = self.CurSceneGuideEids or {}
    local PlayerGuideInfos = {}
    for k, v in pairs(self.CurSceneGuideEids) do
        DebugPrint("DebugGuideEid UpdateAllPlayerGuideIcon self.CurSceneGuideEids Loop key", k, "v.IsPlayerEid", v.IsPlayerEid)
        -- if v.IsPlayerEid then
        PlayerGuideInfos[k] = v
        local GuideIcon = UIManager:GetUIObj(tostring(k))
        -- 此处是队友指引，跳过
        if GuideIcon and GuideIcon.PlayerIndex ~= nil and GuideIcon.PlayerIndex > 0 then
            goto continue
        end
        v.IsActive = false
        ::continue::
        -- end
    end
    local AllGuideEids = FIntArray()
    local PlayerState = GameState:GetPlayerState(Player.Eid)
    if PlayerState ~= nil and PlayerState.PlayerGuideEids ~= nil then
        AllGuideEids = PlayerState.PlayerGuideEids
    end
    
    local BattleInstance = Battle(self)
    for Index = 1, AllGuideEids.Items:Num() do
        local TargetEid = AllGuideEids.Items:GetRef(Index).IntProperty
        DebugPrint("DebugGuideEid UpdateAllPlayerGuideIcon PlayerGuideEids Loop TargetEid", TargetEid)
        local TargetActor = nil
        if BattleInstance then
            TargetActor = BattleInstance:GetEntity(TargetEid)
        end
        -- 如果这个Eid在当前场景的Eids中，就改active属性
        if PlayerGuideInfos[TargetEid] ~= nil then
            PlayerGuideInfos[TargetEid].IsActive = true
        end

        if IsValid(TargetActor) then
        -- if IsValid(TargetActor) and (TargetActor.OpenState == nil or TargetActor.OpenState == false) then
            -- 有这个Actor对象，并且这个对象不是已经打开过的状态
            -- DebugPrint("DebugGuideEid UpdateAllPlayerGuideIcon PlayerGuideEids TargetActor.OpenState", TargetActor.OpenState)
            local GuideOp = (PlayerGuideInfos[TargetEid] == nil and "Add" or "Modify")
            self:UpdateSceneGuideIcon(TargetEid, TargetActor, nil, GuideOp, true, nil ,true)
        else
            local GameInstance = GWorld.GameInstance
            local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
            PlayerCharacter.RPCComponent:RequestGuideInfo(TargetEid)
        end
    end

    for k, v in pairs(PlayerGuideInfos) do
        if (v) then
            DebugPrint("DebugGuideEid UpdateAllPlayerGuideIcon PlayerGuideInfos Loop key", k, "v.IsActive", v.IsActive)
        end
        if (v and not v.IsActive) then
            local Entity = self:GetCurSceneGuideEntityByData(v)
            if (UKismetSystemLibrary.IsValid(Entity)) then
                self:UpdateSceneGuideIcon(k, Entity, nil, "Delete", true, nil, v.IsPlayerEid)
            else
                self:UpdateSceneGuideIcon(k, nil, nil, "Delete", true, nil, v.IsPlayerEid)
            end
        end
    end
end

-- function BP_SceneManagerComponent_C:AddGuideToPathFinding(TargetActor, TargetEid, RequireBlockTickLod)
--     if (TargetActor.UnitType == "Monster" or TargetActor.UnitType == "Mechanism")
--         and not self.PathfindingEid[TargetEid]
--         and self:GetLevelLoader()
--         and self:GetLevelLoader().StartPathfindingToActorByEid then

--         self:GetLevelLoader():StartPathfindingToActorByEid(TargetEid)
--         self.PathfindingEid[TargetEid] = true

--         if RequireBlockTickLod == true and TargetActor.UnitType == "Monster" and TargetActor.BlockTickLod_MoveComp then
--             TargetActor:BlockTickLod_MoveComp(true, Const.BlockTickLodTag.SceneGuide)
--         end
--     end
-- end

function BP_SceneManagerComponent_C:RemoveGuideFromPathFinding(TargetEid)
    if self:IsExistTimer("AddGuideToPathFinding"..TargetEid) then
        self:RemoveTimer("AddGuideToPathFinding"..TargetEid)
    end
    -- if self.PathfindingEid[TargetEid] and self:GetLevelLoader() then
    if self.PathfindingEid:FindRef(TargetEid) and self:GetLevelLoader() then
        -- self.PathfindingEid[TargetEid] = nil
        self.PathfindingEid:Add(TargetEid, nil)
        self:GetLevelLoader():StopPathfindingToActorByEid(TargetEid)
    end

    self.CurSceneGuideEids[TargetEid] = nil
    -- self.Guide2LevelInfo[TargetEid] = nil

    if self.Guide2NextLevelIdMaps:Find(TargetEid) then
        self.Guide2NextLevelIdMaps:Remove(TargetEid)
    end

    if self.Guide2InDoorNameMaps:Find(TargetEid) then
        self.Guide2InDoorNameMaps:Remove(TargetEid)
    end
end

function BP_SceneManagerComponent_C:GetGuideTypeByBPPath(GuideIconAni, GuideIconBPPath) --指引点类型
    local GuideType = UIConst.IndicatorCategoryTable[GuideIconAni]
    GuideType = GuideType or UIConst.IndicatorCategoryIconTable[GuideIconBPPath]
    if GuideType then
        return GuideType
    end
    return ""
end

function BP_SceneManagerComponent_C:GetGuideGuideAnimByBPPath(GuideIconAni, GuideIconBPPath) --指引点蓝图
    local GuideAnim = UIConst.IndicatorAnimTable[GuideIconAni]
    GuideAnim = GuideAnim or UIConst.IndicatorAnimIconTable[GuideIconBPPath]
    if GuideAnim then
        return GuideAnim
    end
    return ""
end

function BP_SceneManagerComponent_C:RegisterTeamEvent()
    TeamController:RegisterEvent(self, function(self, EventId, ...)
        -- DebugPrint("BP_SceneManagerComponent_C:RegisterTeamEvent", EventId)
        if EventId == TeamCommon.EventId.TeamOnAddPlayer then
            local Member = ...
            self:OnTeamAddRegionOtherPlayerGuide(Member)
        elseif EventId == TeamCommon.EventId.TeamOnDelPlayer then
            local Member = ...
            self:OnTeamRemoveRegionOtherPlayerGuide(Member)
            -- 更新其他成员Index
            local TeamData = TeamController:GetModel():GetTeam()
            for _, Member in pairs(TeamData.Members) do
                self:OnTeamAddRegionOtherPlayerGuide(Member)
            end
        elseif EventId == TeamCommon.EventId.TeamOnInit then
            local Team = ...
            for _, Member in ipairs(Team.Members) do
                self:OnTeamAddRegionOtherPlayerGuide(Member)
            end
        elseif EventId == TeamCommon.EventId.TeamLeave then
            local Team = ...
            for _, Member in ipairs(Team.Members) do
                self:OnTeamRemoveRegionOtherPlayerGuide(Member)
            end
        end
    end)
end

-- 有人进入区域联机
function BP_SceneManagerComponent_C:AddRegionOnlineCharacterInfo(Eid, Uid, StartLoc)
    DebugPrint("AddRegionOnlineCharacterInfo Eid", Eid, "Uid", Uid, "StartLoc", StartLoc)
    self.RegionOnlineCharacterInfo[Uid] = Eid
    local DsMember, MemberIndex = TeamController:GetModel():GetTeamMember(Uid)
    if not DsMember then
        return
    end
    self:AddRegionOtherPlayerGuide(Eid, StartLoc, MemberIndex)
end

-- 有人进入队伍
function BP_SceneManagerComponent_C:OnTeamAddRegionOtherPlayerGuide(MemberInfo)
    DebugPrint("OnTeamAddRegionOtherPlayerGuide MemberInfo.Uid", MemberInfo.Uid, "MemberInfo.Index", MemberInfo.Index)
    local MemberEid = self.RegionOnlineCharacterInfo[MemberInfo.Uid]
    -- 在联机区域中
    if MemberEid then
        local StartLoc = FVector(0, 0, 0)
        local Player = nil
        local BattleInstance = Battle(self)
        if BattleInstance then
            Player = BattleInstance:GetEntity(MemberEid)
        end
        if Player then
            StartLoc = Player:K2_GetActorLocation()
        end
        self:AddRegionOtherPlayerGuide(MemberEid, StartLoc, MemberInfo.Index)
    end
end

-- 增加区域指引点
function BP_SceneManagerComponent_C:AddRegionOtherPlayerGuide(Eid, StartLoc, MemberIndex)
    DebugPrint("AddRegionOtherPlayerGuide Eid: ", Eid, "StartLoc", StartLoc, "MemberIndex", MemberIndex)
    local GuideOp = (self.CurSceneGuideEids[Eid] == nil and "Add" or "Modify")
    local PlayerGuideIconBPPath = self:GetPlayerGuideIcon(MemberIndex, true)
    self:UpdateSceneGuideIcon(Eid, nil, StartLoc, GuideOp, true,
        {
        GuideIconAni = UIConst.DUNGEONINDICATOR.Phantom,
        GuideIconBPPath = PlayerGuideIconBPPath,
        PlayerIndex = MemberIndex,
        }, true)
end

-- 有人离开区域联机
function BP_SceneManagerComponent_C:RemoveRegionOnlineCharacterInfo(Uid)
    local CurrentEid = self.RegionOnlineCharacterInfo[Uid]
    DebugPrint("RemoveRegionOnlineCharacterInfo Uid", Uid, "CurrentEid", CurrentEid)
    if not CurrentEid then
        return
    end
    self.RegionOnlineCharacterInfo[Uid] = nil
    self:RemoveRegionOtherPlayerGuide(CurrentEid)
end

-- 有人离开队伍
function BP_SceneManagerComponent_C:OnTeamRemoveRegionOtherPlayerGuide(MemberInfo)
    local MemberEid = self.RegionOnlineCharacterInfo[MemberInfo.Uid]
    DebugPrint("RemoveRegionOnlineCharacterInfo MemberInfo", MemberInfo, "MemberEid", MemberEid)
    if not MemberEid then
        return
    end
    -- 在联机区域中
    if MemberEid then
        self:RemoveRegionOtherPlayerGuide(MemberEid)
    end
end

-- 删除区域指引点
function BP_SceneManagerComponent_C:RemoveRegionOtherPlayerGuide(Eid)
    DebugPrint("RemoveRegionOtherPlayerGuide Eid: ", Eid)
    local DeleteName = tostring(Eid)
    RunAsyncTask(self, "RemoveRegionOtherPlayerGuide_GetUIObjAsync" .. DeleteName, function(CoroutineObj)
        local GameInstance = GWorld.GameInstance
        local UIManager = GameInstance:GetGameUIManager()
        if not UIManager then
            return
        end
        local GuideIcon = UIManager:GetUIObjAsync(DeleteName, CoroutineObj)
        local TargetActor = nil
        local BattleInstance = Battle(self)
        if BattleInstance then
            TargetActor = BattleInstance:GetEntity(Eid)
        end
        if GuideIcon then
            if (IsValid(TargetActor)) then
                self:UpdateSceneGuideIcon(Eid, TargetActor, nil, "Delete", true)
            else
                self:UpdateSceneGuideIcon(Eid, nil, nil, "Delete", true)
            end
        end
    end)
end

function BP_SceneManagerComponent_C:UpdateSceneOtherPlayerGuide(Eid, OpType)
    DebugPrint("BP_SceneManagerComponent_C:UpdateSceneOtherPlayerGuide Eid: ", Eid, "OpType", OpType)
    if OpType == "Enter" then
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        local MapTable = self.OtherPlayerGuideEidMaps:ToTable()
        if MapTable then
            for Index, MapEid in pairs(MapTable) do
                -- local PlayerState = GameState:GetPlayerState(MapEid)
                local BirthsLoc = FVector(0, 0, 0)
                for _, v in pairs(GameState.PlayerArray) do
                    if v.Eid == MapEid then
                        BirthsLoc.X = v.PlayerLoc.X
                        BirthsLoc.Y = v.PlayerLoc.Y
                        BirthsLoc.Z = v.PlayerLoc.Z
                        break
                    end
                end
                -- DebugPrint("LUA UPDATE Index MapEid", Index, MapEid)
                local GuideOp = (self.CurSceneGuideEids[MapEid] == nil and "Add" or "Modify")
                local PlayerGuideIconBPPath = self:GetPlayerGuideIcon(Index, true)
                self:UpdateSceneGuideIcon(MapEid, nil, BirthsLoc, GuideOp, true, 
                    {
                    GuideIconAni = UIConst.DUNGEONINDICATOR.Phantom,
                    GuideIconBPPath = PlayerGuideIconBPPath,
                    PlayerIndex = Index,
                    }, true)

            end
        end
    elseif OpType == "Exit" then
        -- local DeleteIndex = 0
        -- local DeleteEid = 0
        -- for k, v in pairs(self.OtherPlayerGuideEidMaps) do
        --     if v == Eid then
        --         DeleteIndex = k
        --         DeleteEid = v
        --     end
        -- end

        -- if DeleteIndex > 0 and self.OtherPlayerGuideEidMaps:FindRef(DeleteIndex) ~= nil then
        --     self.OtherPlayerGuideEidMaps:Remove(DeleteIndex)
        --     local DeleteName = tostring(DeleteEid)
        --     RunAsyncTask(self, "UpdateSceneOtherPlayerGuide_GetUIObjAsync" .. DeleteName, function(CoroutineObj)
        --         local GuideIcon = UIManager:GetUIObjAsync(DeleteName, CoroutineObj)
        --         if GuideIcon and GuideIcon.PlayerIndex == DeleteIndex then
        --             if (IsValid(GuideIcon.TargetActor)) then
        --                 self:UpdateSceneGuideIcon(DeleteEid, GuideIcon.TargetActor, nil, "Delete", true)
        --             else
        --                 self:UpdateSceneGuideIcon(DeleteEid, nil, nil, "Delete", true)
        --             end
        --         end
        --     end)
        -- end
        local DeleteName = tostring(Eid)
        RunAsyncTask(self, "UpdateSceneOtherPlayerGuide_GetUIObjAsync" .. DeleteName, function(CoroutineObj)
            local GameInstance = GWorld.GameInstance
            local UIManager = GameInstance:GetGameUIManager()
            if not UIManager then
                return
            end
            local GuideIcon = UIManager:GetUIObjAsync(DeleteName, CoroutineObj)
            if GuideIcon then
                local TargetActor = nil
                local BattleInstance = Battle(self)
                if BattleInstance then
                    TargetActor = BattleInstance:GetEntity(Eid)
                end
                if (IsValid(TargetActor)) then
                    self:UpdateSceneGuideIcon(Eid, TargetActor, nil, "Delete", true)
                else
                    self:UpdateSceneGuideIcon(Eid, nil, nil, "Delete", true)
                end
            end
        end)
    end
    
end

function BP_SceneManagerComponent_C:GetPlayerGuideIcon(PlayerIndex, IsAlive)
    if IsAlive then
        return "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Player"..tostring(PlayerIndex).."A.T_Gp_Player"..tostring(PlayerIndex).."A"
    else
        return "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Player"..tostring(PlayerIndex).."B.T_Gp_Player"..tostring(PlayerIndex).."B"
    end

    return ""
end

function BP_SceneManagerComponent_C:UpdateAllGuideIconsByName(OpType, InEid, InName)
    local GuideIcons = self.GuideIcons
    if OpType == "Add" or OpType == "Modify" then
        if InName ~= nil then
            GuideIcons:Add(InEid, InName)
        --     if self.GuideIcons:FindRef(InEid) then
        --         self.GuideIcons:Remove(InEid)
        --         self.GuideIcons:Add(InEid, InName)
        --     else
        --         self.GuideIcons:Add(InEid, InName)
        --     end
        -- else
        --     if self.GuideIcons:FindRef(InEid) then
        --         local Name = self.GuideIcons:FindRef(InEid)
        --         self.GuideIcons:Remove(InEid)
        --         self.GuideIcons:Add(InEid, Name)
        --     end
        end
    elseif OpType == "Delete" then
        GuideIcons:Remove(InEid)
        -- if self.GuideIcons:FindRef(InEid) then
        --     self.GuideIcons:Remove(InEid)
        -- end
    end
end

function BP_SceneManagerComponent_C:IsExistInGuideEidArrays(TargetEid)
    local GameInstance = GWorld.GameInstance
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    -- 删指引的时候Character可能先销毁了，加个保护
    if Player then
        local PlayerState = GameState:GetPlayerState(Player.Eid)
        DebugPrint("BP_SceneManagerComponent_C:IsExistInGuideEidArrays TargetEid", TargetEid)
        if PlayerState then
            if (PlayerState.PlayerGuideEids ~= nil) then
                for Index = 1, PlayerState.PlayerGuideEids.Items:Num() do
                    local Eid = PlayerState.PlayerGuideEids.Items:GetRef(Index).IntProperty
                    DebugPrint("IsExistInGuideEidArrays PlayerState.PlayerGuideEids Eid", Eid)
                    if (Eid == TargetEid) then
                        return true
                    end
                end
            end
        end
    end
    local AllCommonGuideEids = FIntArray()
    if (GameState.GuideEids ~= nil) then
        AllCommonGuideEids = GameState.GuideEids
    end
    for Index = 1, AllCommonGuideEids.Items:Num() do
        local Eid = AllCommonGuideEids.Items:GetRef(Index).IntProperty
        DebugPrint("IsExistInGuideEidArrays GameState.GuideEids Eid", Eid)
        if Eid == TargetEid then
            return true
        end
    end
    return false
end

function BP_SceneManagerComponent_C:UpdateSceneGuideIcon(TargetEid, TargetActor, TargetLocation, OpType, IsUseRealDis, ConfigData, IsPlayerEid, IsDataStruct)

    -- 更新指引
    self.Overridden.UpdateSceneGuideIcon(self, TargetEid, TargetActor, TargetLocation, OpType, IsUseRealDis)

    local GameInstance = GWorld.GameInstance
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local UIManager = GameInstance:GetGameUIManager()
    local IsGuideFollowActor = true
    local IsNeedLookUpEntity = false
    local IsNeedArrow = true
    local GuideName = ""
    local GuideType, GuideUnitId = "", ""
    if IsPlayerEid == nil then
        IsPlayerEid = false
    end

    if OpType == "Add" or OpType == "Modify" then
        DebugPrint("LHQ_UpdateSceneGuideIcon Add or Modify Guide:", TargetEid, "IsPlayerEid:", IsPlayerEid, "IsDataStruct", IsDataStruct)
    elseif OpType == "Delete" then
        DebugPrint("LHQ_UpdateSceneGuideIcon Delete Guide:", TargetEid, "IsPlayerEid:", IsPlayerEid, "IsDataStruct", IsDataStruct)
        -- 如果删除，查看是不是在PlayerState.PlayerGuideEids或者在GameState.GuideEids中存在，联机状态下可能先后顺序不同
        if self:IsExistInGuideEidArrays(TargetEid) then
            return
        end
    end

    if UIManager ~= nil then
        if UKismetSystemLibrary.IsValid(TargetActor) then
            GuideUnitId = TargetActor.UnitId
            if ConfigData == nil and OpType ~= "Delete" then
                ConfigData = DataMgr[TargetActor.UnitType][GuideUnitId]
            end

            if ConfigData ~= nil and ConfigData.GuideIconAni then
                GuideType = self:GetGuideTypeByBPPath(ConfigData.GuideIconAni, ConfigData.GuideIconBPPath)
            end
            if GuideType == "Phantom" then
                local ExtraInfo = BattleUtils.GetExtraCreateInfo("Phantom", GuideUnitId, GuideUnitId)
                if ExtraInfo.IsHostage then
                    GuideType = "Hostage"
                end
            end
            GuideName = GuideName..tostring(TargetEid)

            if GuideType == "Monster" and TargetActor.BlockTickLod_MoveComp then
                if OpType == "Add" then
                    TargetActor:BlockTickLod_MoveComp(true, Const.BlockTickLodTag.SceneGuide)
                elseif OpType == "Delete" then
                    TargetActor:BlockTickLod_MoveComp(false, Const.BlockTickLodTag.SceneGuide)
                end
            end

        else
            if ConfigData ~= nil then
                GuideUnitId = ConfigData.UnitId
                GuideType = self:GetGuideTypeByBPPath(ConfigData.GuideIconAni, ConfigData.GuideIconBPPath)
            end
            IsNeedLookUpEntity = true
            GuideName = GuideName..tostring(TargetEid)
        end
        if GuideName == nil or GuideName == "" then
            print(_G.LogTag, "Warning ======= GuideName is nil !!!", GuideName, GuideType, TargetEid, TargetActor, TargetLocation, OpType)
            self.CurSceneGuideEids[TargetEid] = nil
            return
        end
        if (ConfigData ~= nil and not ConfigData.GuideIconAni and ConfigData.GuideIconBPPath ~= nil) then
            -- 场景空间的指引，会随着Actor创建而创建，这里不用管
            return
        end
        local TargetActorLocation = nil
        if (TargetLocation ~= nil) then
            TargetActorLocation = UE4.FVector(TargetLocation.X, TargetLocation.Y, TargetLocation.Z)
        end
        local NotDataStruct = not IsDataStruct
        if NotDataStruct and (OpType == "Add" or OpType == "Modify") then
            self.CurSceneGuideEids[TargetEid] = { Entity = TargetEid, IsDataStruct = false, IsPlayerEid = IsPlayerEid, IsActive = true }
        end
        DebugPrint("UpdateSceneGuideIcon START UpdateSceneGuideIcon_GetUIObjAsync" .. GuideName .. OpType)
        -- RunAsyncTask(self, "UpdateSceneGuideIcon_GetUIObjAsync" .. GuideName .. OpType, function(CoroutineObj)
        -- DebugPrint("UpdateSceneGuideIcon REAL START UpdateSceneGuideIcon_GetUIObjAsync" .. GuideName .. OpType)
        -- local GuideIcon = UIManager:GetUIObjAsync(GuideName, CoroutineObj) or UIManager:GetUIObjAsync(GuideName.."Replace", CoroutineObj)
        local GetUIObjAsyncCallback = function(GuideIcon)
            -- 使用了怪物指引缓存的情况，要通过Eid去找正确的Name对应的GuideIcon，此处不存在异步加载指引情况，所以无需异步获取
            if GuideIcon == nil and OpType == "Modify" then
                GuideIcon = self:GetGuideIconByEid(TargetEid)
            end

            -- 防止异步获取Icon结束时，TargetActor已经被销毁
            TargetActor = nil
            local BattleInstance = Battle(self)
            if BattleInstance then
                TargetActor = BattleInstance:GetEntity(TargetEid)
            end

            -- local TargetActorLocation = nil
            -- if (TargetLocation ~= nil) then
            --     TargetActorLocation = UE4.FVector(TargetLocation.X, TargetLocation.Y, TargetLocation.Z)
            -- end
            DebugPrint("UpdateSceneGuideIcon  GuideName is ", GuideName, GuideType, GuideUnitId,
                TargetEid, TargetActor, TargetActorLocation, OpType, IsUseRealDis, GuideIcon, IsNeedArrow)

            -- self:AddTimer(0.2, self.UpdateMiniMapGuideIcon, false, nil, "UpdateMiniMapGuideIcon"..GuideName..OpType, false, 
            --     GuideName, OpType, TargetEid, TargetActorLocation, ConfigData, IsNeedArrow, IsGuideFollowActor, IsNeedLookUpEntity)

            self:AddDelayFrameFunc(
            function()
                    self:UpdateMiniMapGuideIcon(GuideName, OpType, TargetEid, TargetActorLocation, ConfigData, IsNeedArrow, IsGuideFollowActor, IsNeedLookUpEntity)
            end, 2, "UpdateMiniMapGuideIcon"..GuideName..OpType)

            -- 如果指引点已经存在
            if GuideIcon ~= nil then
                
                -- 修改指引点
                if OpType == "Modify" or OpType == "Add" then

                    GuideIcon:Reset(TargetEid, TargetActor, TargetActorLocation, ConfigData, IsNeedArrow, IsGuideFollowActor, IsNeedLookUpEntity, false, IsUseRealDis)
                    -- GuideIcon:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                    if GuideIcon.IsFromPool then
                        GuideIcon.IsActiveInPoor = true
                    end
                    -- self:AddTimer(0.1, self.AddGuideToPathFindingTimerFunc, false, nil, "AddGuideToPathFinding"..TargetEid, false, 
                    --     TargetEid, false)
                    self:AddDelayFrameFunc(
                        function()
                                self:AddGuideToPathFindingTimerFunc(TargetEid, false)
                        end, 1, "AddGuideToPathFinding"..TargetEid)
                    self:UpdateAllGuideIconsByName(OpType, TargetEid, nil)

                -- 删除指引点
                elseif OpType == "Delete" then
                    self:ProcessGuideIconBeforeClose(GuideIcon)
                    GuideIcon:Disappear()
                    self:RemoveGuideFromPathFinding(TargetEid)
                    self:UpdateAllGuideIconsByName(OpType, TargetEid, nil)
                end

            -- 如果指引点还未存在
            else

                -- 添加指引点
                if OpType == "Add" then

                    local IsGuidePlayAnim = true
                    if ConfigData ~= nil and ConfigData.IsReplace then
                        GuideName = GuideName.."Replace"
                        IsGuidePlayAnim = false
                    end

                    
                    if GuideType == "Monster" and ConfigData.GuideIconAni == UIConst.DUNGEONINDICATOR.Annihilate_S then
                        local PoolClass = GameState:GetIndicatorBaseFromPool("Monster")
                        if PoolClass then
                            PoolClass.IsDungeonIndicator = true
                            if TargetActorLocation == nil then
                                TargetActorLocation = TargetActor:K2_GetActorLocation()
                            end
                            PoolClass:Reset(TargetEid, TargetActor, TargetActorLocation, ConfigData, IsNeedArrow,
                            IsGuideFollowActor, IsNeedLookUpEntity, false, IsUseRealDis, true)
                            PoolClass.IsActiveInPoor = true
                            self:ProcessGuideIconAfterLoad(PoolClass, ConfigData.GuideIconAni, TargetEid, GuideUnitId)
                            self:UpdateAllGuideIconsByName(OpType, TargetEid, PoolClass:GetName())
                            -- self:AddTimer(0.1, self.AddGuideToPathFindingTimerFunc, false, nil, "AddGuideToPathFinding"..TargetEid, false, 
                            --     TargetEid, true)
                            self:AddDelayFrameFunc(
                                function()
                                        self:AddGuideToPathFindingTimerFunc(TargetEid, true)
                                end, 1, "AddGuideToPathFinding"..TargetEid)
                        else
                            -- 加载指引点对象
                            -- UIManager:LoadUI(ConfigData.GuideIconAni, GuideName, UIConst.ZORDER_FOR_INDICATORS,
                            -- TargetEid, TargetActor, TargetActorLocation, ConfigData, IsNeedArrow,
                            -- IsGuideFollowActor, IsNeedLookUpEntity, false, IsUseRealDis)

                            -- self:UpdateAllGuideIconsByName(OpType, TargetEid, GuideName)

                            UIManager:LoadGuideIconAsync(ConfigData.GuideIconAni, GuideName, UIConst.ZORDER_FOR_INDICATORS,
                                                    function(NewGuideIcon)
                                                        self:ProcessGuideIconAfterLoad(NewGuideIcon, ConfigData.GuideIconAni, TargetEid, GuideUnitId)
                                                        self:UpdateAllGuideIconsByName(OpType, TargetEid, GuideName)
                                                        -- 防止异步加载结束时，TargetActor已经被销毁
                                                        -- TargetActor = nil
                                                        -- if BattleInstance then
                                                        --     TargetActor = BattleInstance:GetEntity(TargetEid)
                                                        -- end
                                                        -- self:AddTimer(0.1, self.AddGuideToPathFindingTimerFunc, false, nil, "AddGuideToPathFinding"..TargetEid, false, 
                                                        --     TargetEid, true)
                                                        self:AddDelayFrameFunc(
                                                            function()
                                                                    self:AddGuideToPathFindingTimerFunc(TargetEid, true)
                                                            end, 1, "AddGuideToPathFinding"..TargetEid)
                                                    end, 
                                                    TargetEid, TargetActor, TargetActorLocation, ConfigData, IsNeedArrow,
                                                    IsGuideFollowActor, IsNeedLookUpEntity, false, IsUseRealDis)
                        end
                    else
                        -- 加载指引点对象
                        -- UIManager:LoadUI(ConfigData.GuideIconAni, GuideName, UIConst.ZORDER_FOR_INDICATORS,
                        -- TargetEid, TargetActor, TargetActorLocation, ConfigData, IsNeedArrow,
                        -- IsGuideFollowActor, IsNeedLookUpEntity, false, IsUseRealDis)
                        UIManager:LoadGuideIconAsync(ConfigData.GuideIconAni, GuideName, UIConst.ZORDER_FOR_INDICATORS,
                                                function(NewGuideIcon)
                                                    self:ProcessGuideIconAfterLoad(NewGuideIcon, ConfigData.GuideIconAni, TargetEid, GuideUnitId)
                                                    self:UpdateAllGuideIconsByName(OpType, TargetEid, GuideName)
                                                    -- self:AddTimer(0.1, self.AddGuideToPathFindingTimerFunc, false, nil, "AddGuideToPathFinding"..TargetEid, false, 
                                                    --     TargetEid, true)
                                                    self:AddDelayFrameFunc(
                                                        function()
                                                                self:AddGuideToPathFindingTimerFunc(TargetEid, true)
                                                        end, 1, "AddGuideToPathFinding"..TargetEid)
                                                end, 
                                                TargetEid, TargetActor, TargetActorLocation, ConfigData, IsNeedArrow,
                                                IsGuideFollowActor, IsNeedLookUpEntity, false, IsUseRealDis)
                    end
        
                -- 删除指引点
                elseif OpType == "Delete" then
                    EventManager:FireEvent(EventID.RecycleClassToCachePool, TargetEid)
                    DebugPrint("UpdateSceneGuideIcon Real RecycleGuideIcon TargetEid:", TargetEid)
                    self:RemoveGuideFromPathFinding(TargetEid)
                    self:UpdateAllGuideIconsByName(OpType, TargetEid, nil) 
                end
            end
        end
        UIManager:GetUIObjAsync(GuideName, function(GuideIcon)
            if GuideIcon then
                GetUIObjAsyncCallback(GuideIcon)
            else
                UIManager:GetUIObjAsync(GuideName.."Replace", GetUIObjAsyncCallback)
            end

        end)
    end
end

function BP_SceneManagerComponent_C:UpdateMiniMapGuideIcon(GuideName, OpType, TargetEid, TargetActorLocation, ConfigData, IsNeedArrow, IsGuideFollowActor, IsNeedLookUpEntity)
    -- if OpType == "Delete" then
    --     if self:IsExistTimer("UpdateMiniMapGuideIcon"..GuideName.."Add") then
    --         self:RemoveTimer("UpdateMiniMapGuideIcon"..GuideName.."Add")
    --     end
    --     if self:IsExistTimer("UpdateMiniMapGuideIcon"..GuideName.."Modify") then
    --         self:RemoveTimer("UpdateMiniMapGuideIcon"..GuideName.."Modify")
    --     end
    -- end
    -- timer传进来会野，从Eid拿
    local TargetActor = nil
    local BattleInstance = Battle(self)
    if BattleInstance then
        TargetActor = BattleInstance:GetEntity(TargetEid)
    end
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local battleMain = UIManager:GetUI("BattleMain")
    if not battleMain then
        if OpType == "Delete" then
            self.CacheGuideInfo[GuideName] = nil
        else
            self.CacheGuideInfo[GuideName] = {
                TargetActor,
                TargetActorLocation,
                ConfigData,
                TargetEid,
                IsNeedArrow,
                IsGuideFollowActor,
                IsNeedLookUpEntity
            }
        end
    else
        local MiniMap = battleMain.Battle_Map
        if MiniMap then
            MiniMap:UpdateGuideIcon(self, GuideName, OpType, TargetEid, TargetActor, TargetActorLocation,
                ConfigData, IsNeedArrow, IsGuideFollowActor, IsNeedLookUpEntity)
        end
    end
end

function BP_SceneManagerComponent_C:AddGuideToPathFindingTimerFunc(TargetEid, RequireBlockTickLod)
    local TargetActor = nil
    local BattleInstance = Battle(self)
    if BattleInstance then
        TargetActor = BattleInstance:GetEntity(TargetEid)
    end
    self:AddGuideToPathFinding(TargetActor, TargetEid, RequireBlockTickLod)
end

function BP_SceneManagerComponent_C:ProcessGuideIconAfterLoad(NewGuideIcon, GuideIconAni, TargetEid, GuideUnitId)
    if NewGuideIcon == nil then
        local EMGameState = UE4.UGameplayStatics.GetGameState(self)
        if EMGameState then
            EMGameState:ShowDungeonError("ProcessGuideIconAfterLoad Icon加载失败 请检查配表数据 GuideIconAni: "
                ..tostring(GuideIconAni).." GuideUnitId: "..GuideUnitId.." TargetEid: "..TargetEid,
                Const.DungeonErrorType.DungeonIndicator, Const.DungeonErrorTitle.Config)
        end
        DebugPrint("Error ProcessGuideIconAfterLoad NewGuideIcon == nil GuideIconAni: ", GuideIconAni, "TargetEid: ", TargetEid)
        return
    end
    NewGuideIcon.IsDungeonIndicator = true
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    if not self.GuideIconMain then
        self.GuideIconMain = UIManager:LoadUINew("GuideIconMain")
    end
    self.GuideIconMain:AddChildToMain(NewGuideIcon)
    -- self.GuideIconMain:AddGuideIcon(NewGuideIcon)
    -- AddChild会走destruct，destruct会清掉event，所以add完再加event
    NewGuideIcon:AttachEventOnLoaded()
end

function BP_SceneManagerComponent_C:ProcessGuideIconBeforeClose(GuideIcon)
    if self.GuideIconMain then
        self.GuideIconMain:DeleteGuideIcon(GuideIcon.WidgetName)
    end
    GuideIcon:RemoveFromParent()
    -- RemoveFromParent和AddChild都会走Destruct，一般不会让UIState当Child，指引点有优化需求，先直接把IsInit设置成true
    GuideIcon.IsInit = true
end

function BP_SceneManagerComponent_C:ShowOrHideAllSceneGuideIcon(IsShow, OpTag)
    self.IsSceneGuideShow = IsShow

    for k, v in pairs(self.CurSceneGuideEids) do
        RunAsyncTask(self, "ShowOrHideAllSceneGuideIcon_GetUIObjAsync" .. k, function(CoroutineObj)
            local GameInstance = GWorld.GameInstance
            local UIManager = GameInstance:GetGameUIManager()
            if UIManager == nil then return end
            local GuideName = tostring(k)
            local GuideIcon = UIManager:GetUIObjAsync(GuideName, CoroutineObj) or UIManager:GetUIObjAsync(GuideName.."Replace", CoroutineObj)
            if GuideIcon == nil then
                local IconName = self.GuideIcons:FindRef(k)
                if IconName then
                    GuideIcon = UIManager:GetUIObj(IconName)
                end
            end
            if GuideIcon ~= nil then
                if (OpTag) then
                    if (IsShow) then
                        GuideIcon:Show(OpTag)
                    else
                        GuideIcon:Hide(OpTag)
                    end
                else
                    GuideIcon:SetVisibilityNotOnDoor(IsShow) 
                end
            end
        end)
    end
end

-- OpTag：显隐Tag，必须传入
function BP_SceneManagerComponent_C:ShowOrHideSceneGuideIcon(Eid, IsShow, OpTag)
    if not OpTag then
        DebugPrint("Error: OpTag == nil 本接口必须传入显隐Tag")
        return
    end
    RunAsyncTask(self, "ShowOrHideSceneGuideIcon_GetUIObjAsync" .. Eid, function(CoroutineObj)
        local GameInstance = GWorld.GameInstance
        local UIManager = GameInstance:GetGameUIManager()
        if UIManager == nil then return end
        local GuideName = tostring(Eid)
        local GuideIcon = UIManager:GetUIObjAsync(GuideName, CoroutineObj) or UIManager:GetUIObjAsync(GuideName.."Replace", CoroutineObj)
        if GuideIcon == nil then
            local IconName = self.GuideIcons:FindRef(Eid)
            if IconName then
                GuideIcon = UIManager:GetUIObj(IconName)
            end
        end
        if GuideIcon ~= nil then
            if (IsShow) then
                GuideIcon:Show(OpTag)
            else
                GuideIcon:Hide(OpTag)
            end
        end
    end)
end

-- function BP_SceneManagerComponent_C:ShowOrHideSceneGuideIcon(IsShow, Eids)
--     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--     local UIManager = GameInstance:GetGameUIManager()
--     if UIManager == nil then return end

--     for k1, v1 in pairs(self.CurSceneGuideEids) do
--         for k2, v2 in pairs(Eids) do
--             if v2 == k1 then
--                 RunAsyncTask(self, "ShowOrHideSceneGuideIcon_GetUIObjAsync" .. k1, function(CoroutineObj)
--                     local GuideIcon = UIManager:GetUIObjAsync(k1, CoroutineObj)
--                     if GuideIcon ~= nil then
--                         GuideIcon:SetVisibilityNotOnDoor(IsShow)
--                     end
--                 end)
--             end
--         end
--     end
-- end

function BP_SceneManagerComponent_C:ExistPathfindingEid(TargetEid)
    -- return self.PathfindingEid[TargetEid]
    return self.PathfindingEid:FindRef(TargetEid)
end

function BP_SceneManagerComponent_C:ShowOrHideGuideIconByGuideName(GuideName, IsShow)
    RunAsyncTask(self, "ShowOrHideGuideIconByGuideName_GetUIObjAsync" .. GuideName, function(CoroutineObj)
        local GameInstance = GWorld.GameInstance
        local UIManager = GameInstance:GetGameUIManager()
        if not UIManager then
            return
        end
        local GuideIcon = UIManager:GetUIObjAsync(GuideName, CoroutineObj)
        if (GuideIcon ~= nil) then
            GuideIcon:SetVisibilityNotOnDoor(IsShow)
        end
    end)
end

function BP_SceneManagerComponent_C:GetAllKindsOfGuide()
    local UINames = TArray("")
    for k, v in pairs(self.GuideIcons) do
        local Name = v
        if Name ~= nil then
            UINames:Add(Name)
        end
    end
    return UINames
end

-- 在TargerEid和TargetEid..Replace都没拿到的情况下使用，即从缓存池中拿的指引
function BP_SceneManagerComponent_C:GetGuideIconByEid(Eid)
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
        if self.GuideIcons:FindRef(Eid) then
            local Name = self.GuideIcons:FindRef(Eid)
            local GuideIcon = UIManager:GetUIObj(Name)
            if GuideIcon and GuideIcon.TargetEid == Eid then
                return GuideIcon
            end
        end
    return nil
end

function BP_SceneManagerComponent_C:RefreshAllGuideStyle()
    -- 防止同一帧跑多次
    local FrameCount = UE4.UKismetSystemLibrary.GetFrameCount()
	if FrameCount == self.PreFrameCount then
        return
	end
    self.PreFrameCount = FrameCount

    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()

    local UINames, GuideUIInfo = self:GetAllKindsOfGuide(), {}
    for i = 1, UINames:Length() do
        local UIName = UINames:GetRef(i)

        local TargetEid = math.tointeger(UIName)
        local GuideIcon = UIManager:GetUIObj(UIName)
        if GuideIcon == nil then
            DebugPrint("RefreshAllGuideStyle: GuideIcon为空 UIName: ", UIName)
            goto continue
        end
        if GuideIcon.TargetEid ~= nil then
            TargetEid = GuideIcon.TargetEid
        end

        local KeyWord = GuideIcon:GetIconPathName()
        local GuideDistance = GuideIcon:GetRealDistance()
        local IsOnDoor = GuideIcon:CaluCurGuideNeedShowPos(TargetEid)
        
        -- 根据KeyWord给指引点分类
        if KeyWord ~= "" and KeyWord ~= nil and TargetEid ~= nil and TargetEid ~= 0 then
            local NextDoorName = "NotInDoor"
            if IsOnDoor then --在门上
                -- 显示在门上面的，则堆叠指引
                if self.Guide2InDoorNameMaps:Find(TargetEid) ~= nil then
                    NextDoorName = self.Guide2InDoorNameMaps:Find(TargetEid)
                end
            end
            if GuideUIInfo[KeyWord] == nil then
                GuideUIInfo[KeyWord] = {{UIObj = GuideIcon, ShowDoorName = NextDoorName, Index = i, Name = UIName, GuideDis = GuideDistance}}
            else
                table.insert(GuideUIInfo[KeyWord], {UIObj = GuideIcon, ShowDoorName = NextDoorName, Index = i, Name = UIName, GuideDis = GuideDistance})
            end
        end
        ::continue::
    end
    
    -- 根据距离排序
    for _, v in pairs(GuideUIInfo) do
        table.sort(v,
            function(Data1, Data2)
                if (Data1["GuideDis"] ~= Data2["GuideDis"]) then
                    return Data1["GuideDis"] < Data2["GuideDis"]
                else
                    return Data1["Index"] < Data2["Index"] end
            end
        )
    end

    -- 遍历分好类的信息
    for k, v in pairs(GuideUIInfo) do
        local NeedShowMultiList = {}
        local GuideIconCount = #v
        -- 对于每一类指引点，再根据所属的门放入NeedShowMultiList
        for i = 1, GuideIconCount do
            if v[i].ShowDoorName ~= nil and v[i].ShowDoorName ~= "" then
                -- 插入 NeedShowMultiList 列表
                if NeedShowMultiList[v[i].ShowDoorName] ~= nil then
                    table.insert(NeedShowMultiList[v[i].ShowDoorName], i)
                else
                    NeedShowMultiList[v[i].ShowDoorName] = { i } 
                end
            end
        end
        
        for k1, v1 in pairs(NeedShowMultiList) do

            -- 对于不在门上的指引点，或在门上只有一个指引点
            if k1 == "NotInDoor" or #v1 <= 1 then
            
                -- 所有指引点设置为 Single 并显示
                for i = 1, #v1, 1 do
                    local UIObj = v[v1[i]].UIObj
                    UIObj:ChangeStyle(EIndicatorStyle.Single, 1)
                    UIObj:SetVisibilityOnDoor(true)
                end

            -- 对于在门上的指引点，并且门上有多个指引点
            else
                -- self.HideObjs = TArray(UE4.UUIState)

                -- 所有指引点设置为 Single 并隐藏
                for i = 1, #v1, 1 do
                    local UIObj = v[v1[i]].UIObj
                    UIObj:ChangeStyle(EIndicatorStyle.Single, 1)
                    UIObj:SetVisibilityOnDoor(false)
                    -- self.HideObjs:Add(UIObj)
                end
                
                local UIObj = v[v1[1]].UIObj

                -- -- 如果第一个指引点是 Destroy 或 Excavation
                -- if UIObj:GetBPName() == "Destroy" or UIObj:GetBPName() == "Excavation" then

                --     -- 寻找字母最小的设为 Multiple 并显示
                --     for i = 0, 25, 1 do
                --         local Found = false
                --         local Letter = string.char(i + string.byte('A'))
                        
                --         for j = 1, #v1, 1 do
                --             local UIObj = v[v1[j]].UIObj
                --             if UIObj:GetTextLetter() == Letter then
                                
                --                 UIObj:ChangeStyle(EIndicatorStyle.Multiple, #v1)
                --                 UIObj:SetVisibilityOnDoor(true, self.HideObjs)

                --                 Found = true
                --                 break
                --             end
                --         end
                --         if Found == true then
                --             break
                --         end
                --     end

                -- -- 如果第一个指引点其他类型
                -- else

                -- 将其设置为 Multiple 并显示
                UIObj:ChangeStyle(EIndicatorStyle.Multiple, #v1)
                UIObj:SetVisibilityOnDoor(true)
                -- end
            end
        end
    end
end

function BP_SceneManagerComponent_C:RealArrangeAllGuideIcons()
    self:RefreshAllGuideStyle()

    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()

    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    if Player == nil then
        DebugPrint("RealArrangeAllGuideIcons: Player 不存在")
        return
    end

    local UINames = self:GetAllKindsOfGuide()
    local TempTable = UINames:ToTable()
    local GuideUIInfo = {}
    for i = 1, UINames:Length() do
        local UIName = UINames:GetRef(i)

        local TargetEid = math.tointeger(UIName)
        local GuideIcon = UIManager:GetUIObj(UIName)
        if GuideIcon == nil then
            DebugPrint("RealArrangeAllGuideIcons: GuideIcon为空 UIName: ", UIName)
            goto continue
        end
        if GuideIcon.TargetEid ~= nil then
            TargetEid = GuideIcon.TargetEid
        end

        local IconAniKey = nil
        if GuideIcon.ConfigData ~= nil then
            IconAniKey = GuideIcon.ConfigData.GuideIconAni
        end

        if GuideIcon.Visibility ~= UE4.ESlateVisibility.Collapsed and self.Guide2InDoorNameMaps:Find(TargetEid) ~= nil and TargetEid ~= nil and TargetEid ~= 0 then
            local DoorName = self.Guide2InDoorNameMaps:Find(TargetEid)
            if DoorName ~= nil and DoorName ~= "" then
                if GuideUIInfo[DoorName] == nil then
                    local Sign = (FVector(Player:K2_GetActorLocation().X, Player:K2_GetActorLocation().Y, 0)
                                - FVector(GuideIcon.DoorPosition.X, GuideIcon.DoorPosition.Y, 0))
                                :Dot(FVector(GuideIcon.DoorDirection.X, GuideIcon.DoorDirection.Y, 0))
                    if Sign >= 0 then
                        Sign = 1
                    else
                        Sign = -1
                    end

                    GuideUIInfo[DoorName] = {{
                        UIObj = GuideIcon,
                        Index = i,
                        Category = IconAniKey,
                        Order = ((FVector(GuideIcon.TargetPointPos.X, GuideIcon.TargetPointPos.Y, 0)
                                - FVector(GuideIcon.DoorPosition.X, GuideIcon.DoorPosition.Y, 0))
                                :Cross(FVector(GuideIcon.DoorDirection.X, GuideIcon.DoorDirection.Y, 0))).Z * Sign}}
                else
                    local Sign = (FVector(Player:K2_GetActorLocation().X, Player:K2_GetActorLocation().Y, 0)
                                - FVector(GuideIcon.DoorPosition.X, GuideIcon.DoorPosition.Y, 0))
                                :Dot(FVector(GuideIcon.DoorDirection.X, GuideIcon.DoorDirection.Y, 0))
                    if Sign >= 0 then
                        Sign = 1
                    else 
                        Sign = -1
                    end

                    local IsExited = false
                    if GuideUIInfo[DoorName] ~= nil then
                        for _, v in pairs(GuideUIInfo[DoorName]) do
                            if v.UIObj.ConfigData.GuideIconAni == IconAniKey then
                                IsExited = true
                                break
                            end
                        end
                    end
                    
                    if IsExited and not GuideIcon.IsNeedMultipleShow then
                        table.insert(GuideUIInfo[DoorName], {
                            UIObj = GuideIcon,
                            Index = i,
                            Category = IconAniKey,
                            Order = ((FVector(GuideIcon.TargetPointPos.X, GuideIcon.TargetPointPos.Y, 0)
                                    - FVector(GuideIcon.DoorPosition.X, GuideIcon.DoorPosition.Y, 0))
                                    :Cross(FVector(GuideIcon.DoorDirection.X, GuideIcon.DoorDirection.Y, 0))).Z * Sign
                        })
                    elseif not IsExited then
                        table.insert(GuideUIInfo[DoorName], {
                            UIObj = GuideIcon,
                            Index = i,
                            Category = IconAniKey,
                            Order = ((FVector(GuideIcon.TargetPointPos.X, GuideIcon.TargetPointPos.Y, 0)
                                    - FVector(GuideIcon.DoorPosition.X, GuideIcon.DoorPosition.Y, 0))
                                    :Cross(FVector(GuideIcon.DoorDirection.X, GuideIcon.DoorDirection.Y, 0))).Z * Sign
                        })
                    end
                   
                end
            end
        end
        ::continue::
    end

    for _, v in pairs(GuideUIInfo) do
        table.sort(v,
        function(Data1, Data2)
            if (Data1["Order"] ~= Data2["Order"]) then
                return Data1["Order"] < Data2["Order"]
            else
                return Data1["Index"] < Data2["Index"]
            end
        end)
    end

    for _, GuideInfos in pairs(GuideUIInfo) do
        local TotalGuideCount = #GuideInfos
        local DoorName = nil
        local LevelId = nil
        if TotalGuideCount >= 1 and GuideInfos[1].UIObj:GetVisible()
        and self.Guide2InDoorNameMaps:Find(GuideInfos[1].UIObj.TargetEid) ~= nil
        and GuideInfos[1].UIObj.TargetEid ~= nil and GuideInfos[1].UIObj.TargetEid ~= 0 then
            DoorName = self.Guide2InDoorNameMaps:Find(GuideInfos[1].UIObj.TargetEid)
            LevelId = self.Guide2NextLevelIdMaps:Find(GuideInfos[1].UIObj.TargetEid)
        end

        local TempGuideObjsTable = {}
        local CategoryCount = 0
        for k, GuideInfo in pairs(GuideInfos) do
            local GuideIcon = GuideInfo.UIObj
            local IconAniKey = GuideIcon.ConfigData.GuideIconAni
            if TempGuideObjsTable[IconAniKey] == nil then
                TempGuideObjsTable[IconAniKey] = {GuideIcon}
            else
                table.insert(TempGuideObjsTable[IconAniKey], GuideIcon)
            end
        end

        for _, _ in pairs(TempGuideObjsTable) do
            CategoryCount = CategoryCount + 1
        end

        local DoorDummyDistance = 300
        local DeltaValue = DoorDummyDistance / (CategoryCount + 1)
        local Carry = DeltaValue

        for _, IconObjs in pairs(TempGuideObjsTable) do
            local Count = #IconObjs
            if Count == 1 then
                IconObjs[1].TargetOffsetOnDoor = -(DoorDummyDistance / 2)
                IconObjs[1].TargetOffsetOnDoor = IconObjs[1].TargetOffsetOnDoor + Carry
                Carry = Carry + DeltaValue
            else
                local ShortDoorDummyDistance = 150
                local ShortDeltaValue = ShortDoorDummyDistance / (Count + 1)
                local ShortCarry = ShortDeltaValue
                local IsMultiple = true
                for _, v in pairs(IconObjs) do
                    if v.IsNeedMultipleShow then
                        v.TargetOffsetOnDoor = -(DoorDummyDistance / 2)
                        v.TargetOffsetOnDoor = v.TargetOffsetOnDoor + Carry
                        Carry = Carry + DeltaValue
                    else
                        IsMultiple = false
                        v.TargetOffsetOnDoor = -(DoorDummyDistance / 2)
                        v.TargetOffsetOnDoor = v.TargetOffsetOnDoor + Carry
                        v.TargetOffsetOnDoor = v.TargetOffsetOnDoor - (ShortDoorDummyDistance / 2)
                        v.TargetOffsetOnDoor = v.TargetOffsetOnDoor + ShortCarry
                        ShortCarry = ShortDeltaValue + ShortCarry
                    end
                end
                if not IsMultiple then
                    Carry = Carry + DeltaValue
                end
            end
        end

        -- if GuideIcon.IsNeedMultipleShow then
        --     GuideIcon.TargetOffsetOnDoor = -(DoorDummyDistance / 2)
        --     GuideIcon.TargetOffsetOnDoor = GuideIcon.TargetOffsetOnDoor + Carry
        --     Carry = Carry + DeltaValue
        -- end
    end
end

function BP_SceneManagerComponent_C:ArrangeAllGuideIcons(TargetEid, DoorName, TargetDoorLocation)
    -- 在同一个子关卡里面
    if DoorName == "NotInDoor" then
        self.Guide2NextLevelIdMaps:Remove(TargetEid)
        self.Guide2InDoorNameMaps:Remove(TargetEid)
        self:UpdateGuide2LevelDoorInfo(TargetEid, nil, nil, "Delete")

        self:AddTimer(0.1, self.RefreshAllGuideStyle, false, 0, "RefreshAllGuideStyle")
    
    -- 在不同子关卡里面
    elseif not self:IsExistTimer("RealArrangeAllGuideIcons") then
        self:AddTimer(0.1, self.RealArrangeAllGuideIcons, false, 0, "RealArrangeAllGuideIcons")
    end

    local battleMain = UIManager(self):GetUI("BattleMain")
    if not battleMain then
        return
    end
    local MiniMap = battleMain.Battle_Map
    if MiniMap then
        MiniMap:ArrangeGuideIcons(TargetEid, TargetDoorLocation, DoorName=="NotInDoor")
    end
end

---#region 一些脚本检测相关的函数
--- 判断当前是否需要开启脚本检测
function BP_SceneManagerComponent_C:GetIsEnableScriptDetectionCheck()
    local CurrentPlatform = CommonUtils.GetDeviceTypeByPlatformName(self)
    local CurInputType =  UIUtils.UtilsGetCurrentInputType()
    local IsCloudGame = UE4.UUCloudGameInstanceSubsystem.IsCloudGame()
    -- 在非云游戏的PC版中，输入模式为键鼠输入，才开启脚本检测
    return CurrentPlatform == CommonConst.CLIENT_DEVICE_TYPE.PC and CurInputType == ECommonInputType.MouseAndKeyboard and not IsCloudGame 
end

-- 判断鼠标脚本检测开启条件是否满足
function BP_SceneManagerComponent_C:GetScriptDetectionConditionMet_OnMouse(DungeonType, DungeonId)
    DebugPrint("GetScriptDetectionConditionMet_OnMouse DungeonType:", DungeonType, " DungeonId:", DungeonId)
    -- 先暂时写死一些不检测的副本类型和副本ID，用于外放（后续会用表去控制）
    local BlockDungeonTypes = {"ExtermPro"}
    local BlockDungeonIds = {90108, 90604, 60702, 62702, 64702}
    local bIsMetCondition = true
    for _, CheckDungeonType in ipairs(BlockDungeonTypes) do
        if (DungeonType == CheckDungeonType) then
            bIsMetCondition = false
            break
        end
    end

    if (bIsMetCondition) then
        for _, CheckDungeonId in ipairs(BlockDungeonIds) do
            if (DungeonId == CheckDungeonId) then
                bIsMetCondition = false
                break
            end
        end
    end
    return bIsMetCondition
end

---开始脚本检测
---@param CheckType string 检测类型
function BP_SceneManagerComponent_C:StartScriptDetectionCheck(CheckType)
    local bIsInDungeon = false
    local EMGameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
    if (EMGameState and EMGameState:IsInDungeon()) then
        bIsInDungeon = true
    end
    
    if (CheckType == Const.ScriptDetectionCheckType.OnMouse) then
        local IsNeedOpenCheck = bIsInDungeon and self:GetScriptDetectionConditionMet_OnMouse(EMGameState.GameModeType, EMGameState.DungeonId)
        if (IsNeedOpenCheck) then
            -- 记录下当前的鼠标位置，并且开启检测Timer
            if (Const.bIsUseCppVersion) then
                -- C++版本实现
                self:StartScriptDetectionCheck_OnMouse(SDC_MOUSE_CHECKCOUNT_PER_ROUND, SDC_MOUSE_REPORT_SERVER_THRESHOLD)
            else
                -- Lua版本实现
                -- self.bNeedRecordThisTurn = false
                -- self.CurrentMouseLocation2D = UE4.UWidgetLayoutLibrary.GetMousePositionOnViewport(self)
                -- self:StartLuaScriptDetectionCheck_OnMouse()
            end
        end
    elseif CheckType == Const.ScriptDetectionCheckType.OnKeyboard then
        if bIsInDungeon and self:IsEnableSDC_Keyboard(EMGameState.DungeonId) then
            if (Const.bIsUseCppVersion) then
                -- C++版本实现
                self:StartScriptDetectionCheck_OnKeyboard()
            else
                self:StartScriptDetectionCheck_OnKeyboard_Lua()
            end
        end
    end
end

function BP_SceneManagerComponent_C:IsEnableSDC_Keyboard(DungeonId)
    return true
end

function BP_SceneManagerComponent_C:StartScriptDetectionCheck_OnKeyboard_Lua()
    
end

-- 开始鼠标类型脚本检测（Lua版本实现 迁移至C++实现, C++对应函数名：StartScriptDetectionCheck_OnMouse 2025.12）
-- function BP_SceneManagerComponent_C:StartLuaScriptDetectionCheck_OnMouse()
--     if not self.LuaScriptDetectionCheck_OnMouse_Timer then
--         self.LuaScriptDetectionCheck_OnMouse_Timer = self:AddTimer(1.0, function()
--             local IsMouseNotMoved, IsWindowsActive = true, self:IsGameWindowActivated()
--             local CurrentMouseLocation2D = UE4.UWidgetLayoutLibrary.GetMousePositionOnViewport(self)
--             if (self.CurrentMouseLocation2D ~= nil) then
--                 IsMouseNotMoved = UE4.UKismetMathLibrary.EqualEqual_Vector2DVector2D(self.CurrentMouseLocation2D, CurrentMouseLocation2D, 0.001)
--             end
--             -- 前10s进行检测，只要检测到鼠标移动并且窗口处于激活状态，就直接移除Timer
--             if (self.CurrentCheckCountInScene < 10) then
--                 if (not IsMouseNotMoved and IsWindowsActive) then
--                     DebugPrint("StartScriptDetectionCheck_OnMouse: 检测到鼠标移动，并且窗口处于激活状态，移除检测Timer")
--                     self:EndLuaScriptDetectionCheck_OnMouse(false)
--                 end
--             else
--                 -- 需要记录疑似使用脚本的情况，1、鼠标没有移动，2、鼠标移动了，但是窗口没有激活
--                 local IsNeedRecordThisTurn = IsMouseNotMoved or (not IsMouseNotMoved and not IsWindowsActive)
--                 self:EndLuaScriptDetectionCheck_OnMouse(IsNeedRecordThisTurn)
--             end
--             self.CurrentCheckCountInScene = self.CurrentCheckCountInScene + 1
--         end, true, nil, "LuaScriptDetectionCheck_OnMouse_Timer")
--     end
-- end

-- 结束鼠标检测（Lua版本实现 迁移至C++实现 2025.12）
---@param bNeedRecordThisTurn boolean 本次检测结果
-- function BP_SceneManagerComponent_C:EndLuaScriptDetectionCheck_OnMouse(bNeedRecordThisTurn)
--     if self.LuaScriptDetectionCheck_OnMouse_Timer then
--         self.bNeedRecordThisTurn = bNeedRecordThisTurn
--         self:RemoveTimer(self.LuaScriptDetectionCheck_OnMouse_Timer)
--         self.LuaScriptDetectionCheck_OnMouse_Timer = nil
--         self.CurrentCheckCountInScene = 0
--     end
-- end

-- ⚠️ 已迁移到 C++ (2025.01) - 保留注释供参考
--[[
function BP_SceneManagerComponent_C:StartScriptDetectionCheck_OnKeyboard()
    if self.SDCKeyboardOverTimeTimer then
        self:RemoveTimer(self.SDCKeyboardOverTimeTimer)
    end

    self.SDCKeyboardOverTimeTimer = self:AddTimer(SDC_KEY_OVERTIME, function()
        self:EndScriptDetectionCheck_OnKeyboard()
    end, false)
    
    self.bEnableKeyboardSDC = true
    self.KeyList = {}
end
--]]

-- ⚠️ 已迁移到 C++ (2025.01) - 保留注释供参考
--[[
function BP_SceneManagerComponent_C:EndScriptDetectionCheck_OnKeyboard()
    if self.SDCKeyboardOverTimeTimer then
        self:RemoveTimer(self.SDCKeyboardOverTimeTimer)
        self.SDCKeyboardOverTimeTimer = nil
    end

    if self.bEnableKeyboardSDC then
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        if GameInstance and self.KeyList and #self.KeyList >= SDC_MIN_KEYS_THRESHOLD then
            -- 获取KeyList的SHA1指纹
            local Fingerprint = self:GetKeyListFingerprints(self.KeyList)
            if Fingerprint then
                GameInstance.KeyListRecord[Fingerprint] = (GameInstance.KeyListRecord[Fingerprint] or 0) + 1
                
                if GameInstance.KeyListRecord[Fingerprint] >= SDC_KEY_REPEAT_ALERT_CNT then
                    self:ReportScriptDetection_Keyboard(Fingerprint)
                end
            end
        end

        self.bEnableKeyboardSDC = false
        self.KeyList = nil        
    end
end
--]]

-- ⚠️ 已迁移到 C++ (2025.01) - 保留注释供参考
--[[
function BP_SceneManagerComponent_C:ReceivedInputKey(Key, EventType)
    local KeyName = Key.KeyName
    -- 剔除掉鼠标按钮
    if UIConst.MouseButton[KeyName] then
        return
    end

    if self.bEnableKeyboardSDC then
        local TimeStamp = UE4.UGameplayStatics.GetTimeSeconds(self)

        local KeyList = self.KeyList or {}
        self.KeyList = KeyList

        KeyList[#KeyList + 1] = { KeyName, EventType, TimeStamp }
    end
end
--]]

-- ⚠️ 已迁移到 C++ (2025.01) - 保留注释供参考
--[[
function BP_SceneManagerComponent_C:ReportScriptDetection_Keyboard(Fingerprint)
    local PlayerAvatar = GWorld:GetAvatar()
    if PlayerAvatar then
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        local EMGameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
        
        if GameInstance and EMGameState then
            local DungeonId = EMGameState.DungeonId
            local DungeonInfo = DataMgr.Dungeon[DungeonId]
            if DungeonInfo then
                local DungeonType = DungeonInfo.DungeonType or 0
                local RoundNum = 0

                local GameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
                if IsValid(GameState) then
                    RoundNum = GameState.DungeonProgress
                end
                
                -- 使用指纹的计数值
                local RepeatCount = GameInstance.KeyListRecord[Fingerprint] or 0
                local AlertString = string.format(SDC_KEY_ALERT_STRING, DungeonId, DungeonType, RoundNum, RepeatCount)
                
                self:ReportCheatMsg(CommonConst.MonitorCheatType.Keyboard, AlertString)
            end
        end    
    end
end
--]]

-- 再次确认本次检测结果是否需要记录 (Lua版本实现 迁移至C++实现 2025.12)
-- function BP_SceneManagerComponent_C:UpdateIfRecordThisTurnValue()
--     if (self.CurrentMouseLocation2D == nil) then
--         -- 一开始就没有记录鼠标位置，直接返回(一般情况不会走这里)
--         self.bNeedRecordThisTurn = false
--         return
--     end

--     -- 当前结果不需要检测，直接返回（已经是移动过镜头了）
--     if (not self.bNeedRecordThisTurn) then
--         DebugPrint("ScriptDetection== UpdateIfRecordThisTurnValue: 当前结果不需要最后校验, 已经是移动过鼠标的状态了！")
--         return
--     end
--     -- 最后校验一下，再次获取当前鼠标位置，和一开始记录的位置对比
--     local CurrentMouseLocation2D = UE4.UWidgetLayoutLibrary.GetMousePositionOnViewport(self)
--     self.bNeedRecordThisTurn = UE4.UKismetMathLibrary.EqualEqual_Vector2DVector2D(self.CurrentMouseLocation2D, CurrentMouseLocation2D, 0.001)
-- end

-- 核对检查并且上报数据到服务器 (Lua版本实现 迁移至C++实现 2025.12)
-- function BP_SceneManagerComponent_C:CheckAndSendRecordToServer_OnMouse()
--     local PlayerAvatar = GWorld:GetAvatar()
--     if not PlayerAvatar then
--         -- 没有PlayerAvatar就不上报数据
--         return
--     end
--     -- 确认是否真的需要上报
--     if self.bNeedRecordThisTurn then
--         local EMGameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--         EMGameInstance.ScriptDetectionCheckRecordNum = EMGameInstance.ScriptDetectionCheckRecordNum + 1
--         DebugPrint("ScriptDetection== CheckAndSendRecordToServer_OnMouse: 未检测到鼠标移动，疑似使用脚本进行游戏操作，移除检测Timer，并且记录次数：", EMGameInstance.ScriptDetectionCheckRecordNum)
--         if (EMGameInstance.ScriptDetectionCheckRecordNum >= 5) then
--             DebugPrint("ScriptDetection== CheckAndSendRecordToServer_OnMouse: 脚本检测上报，当前累计次数超过5次")
--             local AlertString = "MonitorType: ScriptDetection "
--             local EMGameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
--             if (EMGameState) then
--                 local DungeonId = EMGameState.DungeonId
--                 if (DungeonId) then
--                     AlertString = AlertString.."DungeonID: "..DungeonId.."  "
--                     local DungeonInfo = DataMgr.Dungeon[DungeonId]
--                     if DungeonInfo then
--                         if DungeonInfo.DungeonType then
--                             AlertString = AlertString.."DungeonType: "..DungeonInfo.DungeonType.."  "
--                         end
--                         if DungeonInfo.DungeonLevel then
--                             AlertString = AlertString.."DungeonLevel: "..DungeonInfo.DungeonLevel.."  "
--                         end
--                     end
--                 end
--                 AlertString = AlertString.."Detection threshold for unoperated duration: 10s  "
--             end
--             self:ReportCheatMsg(CommonConst.MonitorCheatType.Mouse, AlertString)
--         end
--     else
--         DebugPrint("ScriptDetection== CheckAndSendRecordToServer_OnMouse: 检测到结束前鼠标有过移动, 判定未使用脚本进行游戏操作, 若有临时记录数据也不算次数")
--     end
-- end

-- 更新值并且校验是否需要上报到服务器（Lua版本实现 迁移至C++实现 2025.12）
-- function BP_SceneManagerComponent_C:UpdateValueAndLuaCheckIfNeedSendToServer_OnMouse()
--     self:UpdateIfRecordThisTurnValue()
--     self:CheckAndSendRecordToServer_OnMouse() 
-- end
---#endregion

-- 副本结束通知接口
---@param IsWin boolean 是否胜利
---@param BattleInfo table 战斗信息
---@param DungeonType string 副本类型
---@param DungeonId integer 副本ID
function BP_SceneManagerComponent_C:OnDungeonEnd_ToSceneManager(IsWin, BattleInfo, DungeonType, DungeonId)
    -- 非ExtermPro类型副本结束时候，验证脚本检测信息相关
    DebugPrint("OnDungeonEnd_ToSceneManager: 副本结束通知，当前副本类型：", DungeonType, DungeonId)
    if self:GetIsEnableScriptDetectionCheck() then
        -- 结束鼠标脚本检测
        if (self:GetScriptDetectionConditionMet_OnMouse(DungeonType, DungeonId)) then
            if (Const.bIsUseCppVersion) then
                -- C++版本实现
                local ResultAlertString = self:UpdateValueAndCheckIfNeedSendToServer_OnMouse()
                if (ResultAlertString and ResultAlertString ~= "") then
                    self:ReportCheatMsg(CommonConst.MonitorCheatType.Mouse, ResultAlertString)
                end
            else
                -- Lua版本实现
                -- self:UpdateValueAndLuaCheckIfNeedSendToServer_OnMouse()
            end
        end
        -- 结束按键脚本检测
        self:EndScriptDetectionCheck_OnKeyboard()
    end
end

function BP_SceneManagerComponent_C:GetLogMask()
    return _G.LogTag
end

-- function BP_SceneManagerComponent_C:GetLevelLoader()
--     if not IsValid(self.LevelLoader) then
--         self.LevelLoader = UE4.UGameplayStatics.GetActorOfClass(self,UE4.ALevelLoader:StaticClass())
--     end
--     return self.LevelLoader
-- end

function BP_SceneManagerComponent_C:CaluCurGuideNeedShowPos(TargetEid, TargetPosition, TargetDirection)
    if self:GetLevelLoader() == nil then
        return false, nil
    end

    -- local GuideLevelInfo = self.Guide2LevelInfo[TargetEid]
    local GuideLevelNextLevelId = self.Guide2NextLevelIdMaps:Find(TargetEid)
    local GuideLevelInDoorName = self.Guide2InDoorNameMaps:Find(TargetEid)
    
    if GuideLevelNextLevelId ~= nil and GuideLevelInDoorName ~= nil then
        return self.LevelLoader.LevelPathfinding:GetTargetActorGuideLocation(
            GuideLevelNextLevelId, GuideLevelInDoorName, TargetPosition, TargetDirection
        )
    end
    return false
end

function BP_SceneManagerComponent_C:AddFoorBox(FoorBox)
    if not self.FloorBoxArray then self.FloorBoxArray = {} end
    table.insert(self.FloorBoxArray, FoorBox)
end

function BP_SceneManagerComponent_C:AddMinimapDoor(Door)
    if not self.MinimapDoorArray then self.MinimapDoorArray = {} end
    table.insert(self.MinimapDoorArray, Door)
end


function BP_SceneManagerComponent_C:DelaySetFullScreen_Lua(Resolution, WindowMode)
    self:AddTimer(0.1, function()
        local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
        if GameUserSettings then
            DebugPrint("@zyh DelaySetFullScreen_Lua执行")
            GameUserSettings:SetFullscreenMode(WindowMode)
            GameUserSettings:ApplySettings(false)
        end
    end, false)
end

function BP_SceneManagerComponent_C:CleanSpecialMonsterInfo(Eid)
    if Eid then
        self.SpecialMonsterInfo[Eid] = nil
    end
end

-- ⚠️ 已迁移到 C++ (2025.01) - 保留注释供参考
--[[
function BP_SceneManagerComponent_C:GetKeyListFingerprints(KeyList)
    local SerializedStr = self:SerializeInputSequence(KeyList)
    local Fingerprint = Sha1.sha1(SerializedStr)

    return Fingerprint
end
--]]

-- ⚠️ 已迁移到 C++ (2025.01) - 保留注释供参考
--[[
function BP_SceneManagerComponent_C:SerializeInputSequence(KeyList)
    -- 将所有字段平铺到一个table，一次concat完成：KeyName|EventType|TimeStamp|KeyName|EventType|TimeStamp|...
    local t = {}
    local idx = 1
    for i, v in ipairs(KeyList) do
        -- v = {KeyName, EventType, TimeStamp}
        local TimeDiff = 0
        if i > 1 then
            -- 计算相对于上一个按键的时间差，并规整到 SDC_KEY_TIME_PRECISION 的整数倍
            local RawDiff = v[3] - KeyList[i-1][3]
            TimeDiff = math.floor(RawDiff / SDC_KEY_TIME_PRECISION + 0.5) * SDC_KEY_TIME_PRECISION
        end

        t[idx] = v[1]       -- KeyName
        t[idx+1] = v[2]     -- EventType
        t[idx+2] = TimeDiff -- 相对时间差
        idx = idx + 3
    end
    return table.concat(t, "|")
end
--]]

function BP_SceneManagerComponent_C:ReportCheatMsg(CheatType, AlertString)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    
    --DebugPrint("gmy@BP_SceneManagerComponent_C BP_SceneManagerComponent_C:ReportCheatMsg", CheatType, AlertString)
    local JsonTable = {
        CheatMsg = AlertString
    }
    local JsonMsg = Json.encode(JsonTable)
    
    Avatar:CallServerMethod("SendCheatMsgToServer", CheatType, JsonMsg)
end

AssembleComponents(BP_SceneManagerComponent_C)
return BP_SceneManagerComponent_C
