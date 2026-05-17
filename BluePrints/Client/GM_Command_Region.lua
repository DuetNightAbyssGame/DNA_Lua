require "UnLua"
require "Const"
local GM_Command_Region = {}

function GM_Command_Region:Initialize(Initializer)
    if self.Commands == nil then
        return
    end
    self:Init_Region_Command()
    for k,v in pairs(self.RegionCommands) do
        if self.Commands[string.upper(k)] == nil then
            self.Commands[string.upper(k)] = v
        else
            GWorld.logger.error("Region GM 重复:" .. tostring(k) .. "   " .. tostring(v))
        end
    end
end

function GM_Command_Region:Init_Region_Command()
    ---- 区域
    self.RegionCommands = {
        ---- 客户端打印
        PRD = "PrintAllRegionData",

        arcrd = "AddRandomCreatorRegionDatas",

        PrintAllRegionData = "PrintAllRegionData", -- 打印当前区域的所有客户端数据，包含SSData和ClientCache

        PrintEntityLog = "PrintEntityLog", -- 打印指定WorldRegionEid对象的所有操作堆栈
        PrintRegionClientCache = "PrintRegionClientCache", -- 打印当前区域客户端缓存的数据库数据，可选择是否比较服务器数据
        PrintRegionServerData = "PrintRegionServerData", -- 打印当前区域服务器数据库数据
        PrintRegionSSData = "PrintRegionSSData", -- 打印客户端SSData
        PrintCurrentRegionId = "PrintCurrentRegionId", -- 打印当前的区域ID
        PrintQuestChainData = "PrintQuestChainData",
        ubwi = "UseBattleWheelItem", --gm ubwi 41015
        orui = "OnRequestUseOwnerRegionOnlineItem", -- gm orui 请求使用主机机关 
        rlro = "RequestLevelRegionOnlineItem", -- gm 请求离开机关


        PrintQuestTracking = "PrintQuestTracking",
        PQCI = "PrintQuestChainInfo",
        PQD = "PrintQuestData",  ----- 打印当前的任务数据
        PCRA = "PrintCurrentRegionActor", ------- 打印当前子区域存储的Actor
		PrintSimpleRegionData = "PrintSimpleRegionData", -- 打印指定WorldRegionEid的数据
		PrintFullRegionData = "PrintFullRegionData", -- 打印指定WorldRegionEid的数据
        TestRegionBaseData = "TestRegionBaseData",

        ---- 区域操作
        SkipRegion = "SkipRegion",
        ResetingExplore = "ResetingExplore",
        RegionChangeOpenState = "RegionChangeOpenState",
        RegionDataDead = "RegionDataDead",
        RegionDataDeadByUnitLabel = "RegionDataDeadByUnitLabel",
        SetStoryModeState = "SetStoryModeState", 
        ResetStoryModeState = "ResetStoryModeState",
        ActiveExplore = "ActiveExplore",
        CompleteExplore = "CompleteExplore",
        GetAchvReward = "GetAchvReward",
        GAARBT = "GetAllAchvRewardByType",

        RAOE = "ReActiveOneExplore",
        RAAE = "ReActiveAllExplore",
        AADE = "AddAllDeliverMechanism",

        StartBoss = "StartBossBattle",
        EndBoss = "EndBossBattle",

        -- AddPet = "AddPet",

        InActiveStaticCreator = "InActiveStaticCreator",
        HQCD = "HandleQuestChainDoing",

        ---- CharAccessory
        PrintCharAccessoryDecoration = "PrintCharAccessoryDecoration",  
        SetCharShowPartMesh = "SetCharShowPartMesh",

        ---- 临时
        BTRBD = "BuildTestRegionBaseData",

        AddTeleportPoint = "AddTeleportPoint",
        AddAllTeleportPoint = "AddAllTeleportPoint",

        PISI = "PurchaseImpressionShopItem",

        TCA = "CharAppearance",

        TDS = "DispatchSystem",
        PDS = "PrintDispatchSystem",
        PIR = "PrintImpressionRandom",
        GDR = "GetDispatchReward",
        GADR = "GetAllDispatchReward",
        TIS = "TestImpressionSystem",
        AIPN = "AddImpressionPreNode",

        CreateRegionPet = "CreateRegionPet",

        TSS = "TestSojournsSystem",
        SetViewTargetWithWC = "SetViewTargetWithWC"
    }
end

-- 打印指定WorldRegionEid对象的所有操作堆栈
function GM_Command_Region:PrintEntityLog(Id)
	local SubSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, URegionDataMgrSubsystem:StaticClass())
	if SubSystem then
		SubSystem:PrintRegionLog(Id)
	end
end

-- 打印当前区域客户端缓存的数据库数据，可选择是否比较服务器数据
-- [RegionType][LevelName][WorldRegionEid] = RegionData
function GM_Command_Region:PrintRegionClientCache(bCompare)
    if tonumber(bCompare) == 1 then
        GM_Command_Region:_PrintRegionClientCacheInner()
        -- 比较服务器
        GM_Command_Region:PrintRegionServerData()
        local SubSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, URegionDataMgrSubsystem:StaticClass())
        SubSystem.TestGMRegionDataType = Const.TestGMRegionType.CompareServer
    else
        GM_Command_Region:_PrintRegionClientCacheInner()
    end
end

function GM_Command_Region:_PrintRegionClientCacheInner()
    local SubSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, URegionDataMgrSubsystem:StaticClass())
    GWorld.logger.errorlog("======================打印区域ClientCache数据======================")

    local function _PrintData(Type, TypeData)
        GWorld.logger.errorlog("======================"..Const.RegionDataTypeDebugText[tonumber(Type) + 1].. "======================")
        for SubRegionId, TempData in pairs(TypeData) do
            GWorld.logger.errorlog("======================区域Id: "..SubRegionId.. "======================")
            PrintTable(TempData, 10)
        end
    end

    for Type, TypeData in pairs(SubSystem.DataLibrary.RegionCacheDatas) do
        _PrintData(Type, TypeData)
    end

    GWorld.logger.errorlog("======================打印区域ClientCache数据 End======================")
end

function GM_Command_Region:PrintRegionSSData()
    local SubSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, URegionDataMgrSubsystem:StaticClass())
    GWorld.logger.errorlog("======================打印区域SSData数据======================")

    local function _PrintData(LevelName, LevelData)
        GWorld.logger.errorlog("======================"..LevelName.. "======================")
        for WorldRegionEid, TempData in pairs(LevelData) do
            PrintTable(TempData, 10)
        end
    end

    for LevelName, LevelData in pairs(SubSystem.DataLibrary.RegionSSDatas) do
        _PrintData(LevelName, LevelData)
    end

    GWorld.logger.errorlog("======================打印区域SSData数据 End======================")
end

-- 打印当前区域服务器数据库数据
-- [RegionType][LevelName][WorldRegionEid] = RegionData
function GM_Command_Region:PrintRegionServerData()
    local Avatar = GWorld:GetAvatar()
    local SubSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, URegionDataMgrSubsystem:StaticClass())
    if Avatar and SubSystem then
        SubSystem.TestGMRegionDataType = Const.TestGMRegionType.OnlyServer
        Avatar:GMC2S_RequestSynchronizedDataFromServer(CommonConst.GMRegionTargetType.AllData, 
                {Avatar:GetSubRegionId2RegionId(Avatar.CurrentRegionId)})
    end
end

function GM_Command_Region:PrintAllRegionData()
    self:PrintRegionSSData()
    self:PrintRegionClientCache(0)
end


function GM_Command_Region:PrintCurrentRegionId()
    local Avatar = GWorld:GetAvatar()
    local GameInstance = self:GetGameInstance()
    local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)
    local LevelLoader = GameMode:GetLevelLoader()
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter( GameInstance, 0)
    if LevelLoader and LevelLoader.IsWorldLoader then
        print(_G.LogTag,"ZJT_ PlayerCharacterLocation Calc RegionId ", Avatar.SyncReason, LevelLoader:GetRegionIdByLocation(PlayerCharacter:K2_GetActorLocation()), LevelLoader:GetLevelIdByLocation(PlayerCharacter:K2_GetActorLocation()) )
    end
    if Avatar then
        print(_G.LogTag,"ZJT_ CurrentRegionId And  IsOpenPlayerPositionSync ", Avatar.CurrentRegionId, Avatar.IsOpenPlayerPositionSync)
    end
end

function GM_Command_Region:PrintQuestChainData()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:GMC2S_RequestSynchronizedDataFromServer(CommonConst.GMRegionTargetType.AllQuestData)
    end
end

function GM_Command_Region:PrintCurrentRegionActor(SubRegionId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    if SubRegionId then ---- 打印当前区域的数据
        SubRegionId = tonumber(SubRegionId)
        if Avatar.WorldRegionEid2Actor[SubRegionId] then
            for LevelName, LevelDatas in pairs(Avatar.WorldRegionEid2Actor[SubRegionId]) do
                for WorldRegionEid, TargetActor in pairs(LevelDatas) do
                    if IsValid(TargetActor) then
                        DebugPrint("ZJT_ 打印在区域中统计的Actor ", WorldRegionEid,  TargetActor.RegionDataType, TargetActor:GetName(),
                        TargetActor.SubRegionId, TargetActor:K2_GetActorLocation(), TargetActor.LevelName)
                    else
                        DebugPrint("ZJT_ 打印的Actor已经被销毁 ", WorldRegionEid)
                    end
                end
               
            end
        end
    else ---- 打印全部数据 
        for SubRegionId, WorldRegionEids in pairs(Avatar.WorldRegionEid2Actor) do
            for LevelName, LevelDatas in pairs(Avatar.WorldRegionEid2Actor[SubRegionId]) do
                DebugPrint("ZJT_ PrintCurrentRegionActor SubRegionId ", SubRegionId, LevelName)
                for WorldRegionEid, TargetActor in pairs(LevelDatas) do
                    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
                    if IsValid(TargetActor) then
                        DebugPrint("ZJT_ 打印在区域中统计的Actor ", TargetActor.CreatorId, WorldRegionEid, 
                        TargetActor.RegionDataType, TargetActor:GetName(),
                        TargetActor.SubRegionId, TargetActor.LevelName, GameMode:GetActorLevelName(TargetActor), TargetActor:K2_GetActorLocation())
                    else
                        DebugPrint("ZJT_ 打印的Actor已经被销毁 ", WorldRegionEid)
                    end
                end
            end
        end
    end
    DebugPrint("ZJT_ 打印当前的非存储数据 Start !!!!! ")
    for SubRegionId, RegionDatas in pairs(Avatar.MistakeRegionBaseData) do
        for LevelName, RegionLevelDatas in pairs(RegionDatas) do
            for WorldRegionEid, RegionBaseData in pairs(RegionLevelDatas) do
                DebugPrint("ZJT_ MistakeRegionBaseData 存在  RegionBaseData", RegionBaseData.Eid,  RegionBaseData.LevelName, RegionBaseData.Id, RegionBaseData.CreatorId)
            end
        end
    end
    DebugPrint("ZJT_ 打印当前的非存储数据 End !!!!! ")
    DebugPrint("ZJT_ 打印当前的未激活的静态刷新点 Start ")
    for SubRegionId, StaticCreatorId in pairs(Avatar.SerializeStaticCretor) do
        for CreatorId, Count in pairs(StaticCreatorId) do
            DebugPrint("ZJT_ 未激活的静态刷新点 SubRegionId StaticCreatorId Count ", SubRegionId, CreatorId, Count)   
        end
    end
    DebugPrint("ZJT_ 打印当前的未激活的静态刷新点 End ")
end


function GM_Command_Region:PrintQuestChainInfo()
    local Avatar = GWorld:GetAvatar()
    DebugPrint("----------------- PrintQuestChainInfo -----------------")
    if Avatar then
        for _, QuestChainId in ipairs(Avatar.QuestChains:Keys()) do
            local QuestChain = Avatar.QuestChains[QuestChainId] 
            DebugPrint("ZJT_ PrintQuestChainInfo ", QuestChainId, QuestChain.State)
            DebugPrint(string.format("PrintQuestChainInfo QuestChainId = %d, DoingQuestId = %d , State = %d, Type = %s", QuestChainId, QuestChain.DoingQuestId, QuestChain.State, QuestChain.QuestChainType))
            PrintTable({CompleteQuestId = QuestChain.CompleteQuestId}, 10)
        end
    end
    DebugPrint("----------------- PrintQuestChainInfo -----------------")
end


function GM_Command_Region:PrintQuestData()
    local Avatar = GWorld:GetAvatar()
    local QuestDatas = Avatar.QuestDatas
    for QuestId, QuestData in pairs(QuestDatas) do
        print(_G.LogTag,"ZJT_ 打印当前待提交数据缓存 PrintQuestData QuestId ", QuestId)
        for WorldRegionEid, RegionBaseData in pairs(QuestData) do
            print(_G.LogTag,"ZJT_ PrintQuestData QuestData eid ", WorldRegionEid, RegionBaseData.Eid, RegionBaseData.QuestId, RegionBaseData.Id, 
            RegionBaseData.SubRegionId, RegionBaseData.LevelName, RegionBaseData.CreatorId)
        end
    end

    for QuestId, QuestData in pairs(Avatar.QuestUpdateDatas) do
        print(_G.LogTag,"ZJT_ 打印之前待提交任务数据缓存 PrintQuestData QuestId ", QuestId)
        for WorldRegionEid, RegionBaseData in pairs(QuestData) do
            print(_G.LogTag,"ZJT_ PrintQuestData QuestData eid ", WorldRegionEid, RegionBaseData.Eid, RegionBaseData.QuestId, RegionBaseData.Id, 
            RegionBaseData.SubRegionId, RegionBaseData.LevelName, RegionBaseData.CreatorId)
        end
    end
end


function GM_Command_Region:PrintQuestTracking()
    local Avatar = GWorld:GetAvatar()
    DebugPrint("ZJT_ 11111111111111 PrintQuestTracking ",Avatar.TrackingQuestChainId )
end


function GM_Command_Region:HandleQuestChainDoing(QuestChainId)
    QuestChainId = tonumber(QuestChainId)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:HandleQuestChainDoing(QuestChainId)
    end
end

function GM_Command_Region:InActiveStaticCreator(CreatorId)
	local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
	CreatorId = CreatorId or 1580052
	if not GameState then
		return
	end
	local StaticCreator = GameState.StaticCreatorMap:FindRef(CreatorId)
	if not IsValid(StaticCreator) then
		return
	end
	StaticCreator:DestoryOneStaticActor_Lua(EDeathReason.StaticGM)
end


function GM_Command_Region:BuildTestRegionBaseData(RegionDataType, SubRegionId, LevelName, CreatorId, WorldRegionEid)
    local Avatar = GWorld:GetAvatar()
    CreatorId = 1008602
    RegionDataType = 1 
    SubRegionId = 100101
    if Avatar then
        local RegionBaseData = {
            RegionDataType = tonumber(RegionDataType),
            SubRegionId = tonumber(SubRegionId),
            LevelName = "LevelName",
            CreatorId = tonumber(CreatorId),
            WorldRegionEid = URuntimeCommonFunctionLibrary.GenerateGUID(),
            RarelyId = 7000029,
            UnitId = "怪物ID",
            UnitType = "Monster",
        }
        DebugPrint("ZJT_ 11111111 BuildTestRegionBaseData ", RegionBaseData.WorldRegionEid)
        local function Callback(Ret)
            DebugPrint(string.format("ZJT_ 测试数据返回的测试码: %d", Ret))
        end
        Avatar:CallServer("AddRegionActorData", Callback, RegionBaseData.RegionDataType, RegionBaseData)
    end
end

function GM_Command_Region:SetCharShowPartMesh()
    local Avatar = GWorld:GetAvatar()
    Avatar:SetCharShowPartMesh(nil, 2, true)
end

function GM_Command_Region:PrintCharAccessoryDecoration()
    local Avatar = GWorld:GetAvatar()
    PrintTable({CharAccess = Avatar.CharAccessorys:all_dump(Avatar.CharAccessorys)})
    local Char = Avatar.Chars[Avatar.CurrentChar]
    PrintTable({EquipCharAccess = Char.CharAccessorySuits:all_dump(Char.CharAccessorySuits)})
end


function GM_Command_Region:SetCharShowPartMesh()
    local Avatar = GWorld:GetAvatar()
    Avatar:SetCharShowPartMesh(nil, 2, true)
end



function GM_Command_Region:StartBossBattle(BossDungeonId, DifficultyId)
    BossDungeonId = tonumber(BossDungeonId)
    DifficultyId = tonumber(DifficultyId)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:EnterHardBoss(BossDungeonId, DifficultyId)
    else
        local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)
        GameMode:InitHardBoss(BossDungeonId, DifficultyId)
    end
end

function GM_Command_Region:EndBossBattle()
    local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)
    GameMode:EndHardBoss(true)
end



function GM_Command_Region:ActiveExplore(ExploreId)
    ExploreId = tonumber(ExploreId)
    local Avatar = GWorld:GetAvatar()
    local GameState = GameMode.EMGameState
    local ExploreGroup = GameState.ExploreGroupMap:FindRef(ExploreId)
    if Avatar and ExploreGroup then
        Avatar:ExploreIdActive(ExploreId, GameMode:GetRegionIdByLocation(ExploreGroup:K2_GetActorLocation()))
    end
end

function GM_Command_Region:CompleteExplore(ExploreId)
    ExploreId = tonumber(ExploreId)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:ExploreIdComplete(ExploreId)
    end
end


function GM_Command_Region:GetAllAchvRewardByType(AchvTypeId)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:GetAllAchvRewardByType(tonumber(AchvTypeId))
    end
end


function GM_Command_Region:GetAchvReward(AchvId)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:GetAchvReward(tonumber(AchvId))
    end
end

function GM_Command_Region:SkipRegion(ModType, SubRegionId, StartIndex)
    local GameMode = UE.UGameplayStatics.GetGameMode(self.Player)
    GameMode:HandleLevelDeliver(ModType, SubRegionId, StartIndex)
end

function GM_Command_Region:ResetingExplore(RarelyId, SubRegionId)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        DebugPrint("ZJT_ ResetingExplore GM ")
        Avatar:ResetingExplore(tonumber(RarelyId), tonumber(SubRegionId))
    end
end



function GM_Command_Region:RegionChangeOpenState(CreatorId)
    local Avatar = GWorld:GetAvatar()
    Avatar:UpdateRegionDataStateByCreatorId(tonumber(CreatorId), { OpenState = true})
end

function GM_Command_Region:RegionDataDead(CreatorId)
    local Avatar = GWorld:GetAvatar()
    Avatar:RegionActorDataDeadByCreatorId(tonumber(CreatorId))
end

function GM_Command_Region:RegionDataDeadByUnitLabel(UnitId, UnitType)
    local Avatar = GWorld:GetAvatar()
    Avatar:RegionActorDataDeadByUnitLabel(tonumber(UnitId),UnitType)
end

function GM_Command_Region:SetStoryModeState()
    local Avatar = GWorld:GetAvatar()
    DebugPrint("ZJT_ 111111111 ", Avatar.RegTime)
    -- local PlayerController =  UE4.UGameplayStatics.GetPlayerController(self.Player, 0)
    -- PlayerController:SetStoryModeState(true)
end

function GM_Command_Region:AddPet(UnitId)
    UnitId = tonumber(UnitId)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    GameMode.EMGameState.EventMgr:GMCreatePet(UnitId, 1, 1, "StaticCreator")
end


function GM_Command_Region:TestRegionBaseData()

    local Avatar = GWorld:GetAvatar()
    local TargetRegionBaseDatas = 
    {   
        {
            Level = 1,
            IsUnlimited = false,
            RegionDataType = 3,
            Type = 1,
            UnitType = "Mechanism",
            WorldRegionEid = "C9633CEC4A6554C6B01239A645D703C2",
            UnitId = 70799,
            RarelyId = 7010092,
            QuestChainId = 0,
            CreatorId = 1191167,
            SubRegionId = 101101,
            LevelName = "Haiboliya_L\0<DF><C6>>fu<83><F8>yื<E6><FB><D1> FZ<89>\17/B<D7>g"
        },
        {
            Level = 1,
            IsUnlimited = false,
            RegionDataType = 3,
            Type = 1,
            UnitType = "Mechanism",
            WorldRegionEid = "EDBF2E8E4AAABED8CFC8058FF31CDB0A",
            UnitId = 70200,
            RarelyId = 7017006,
            QuestChainId = 0,
            SubRegionId = 101101,
            CreatorId = 1240495,
            LevelName = "Chapter01_Icelake_Art_0403Big\14\22<85><EF>"
        },
        {
            Level = 1,
            IsUnlimited = false,
            RegionDataType = 3,
            Type = 1,
            UnitType = "Mechanism",
            WorldRegionEid = "4E2249094302553C32F700BD19C1E9E6",
            UnitId = 70799,
            RarelyId = 7010094,
            SubRegionId = 101101,
            QuestChainId = 0,
            CreatorId = 1191169,
            LevelName = "Chapter01_IcelakeCity_Art_0102BigObjs"
        },
    }
    -- local function Callback(Ret, SuccTable)
    --     PrintTable({Ret = Ret, SuccTable = SuccTable}, 10)
    -- end
	Avatar:AddAutoRegionActorDatas(TargetRegionBaseDatas)
end

function GM_Command_Region:ResetStoryModeState()
    local PlayerController =  UE4.UGameplayStatics.GetPlayerController(self.Player, 0)
    PlayerController:SetStoryModeState(false)
end

function GM_Command_Region:CheckAddTeleportPoint(Id, TeleportPointInfo, CommonRegionData)
    if not TeleportPointInfo then
        DebugPrint("ZJT_ 又不配表 ", Id)
        return false, false, {}
    end
    if not TeleportPointInfo.TeleportPointSubRegion or not DataMgr.SubRegion[TeleportPointInfo.TeleportPointSubRegion] then
        DebugPrint("ZJT_ SubRegion表 不存在该子区域ID : ", TeleportPointInfo.TeleportPointSubRegion )
        return false, false, {}
    end
    if not TeleportPointInfo.LevelName then
        DebugPrint("ZJT_ 不存在配表LevelName : ", TeleportPointInfo.TeleportPointSubRegion )
        return false, false, {}
    end
    if not TeleportPointInfo.StaticId then
        DebugPrint("ZJT_ 不存在配表CreatorId : ", TeleportPointInfo.CreatorId )
        return false, false, {}
    end
    for WorldRegionEid, RegionBaseData in pairs(CommonRegionData) do
        if RegionBaseData.CreatorId == TeleportPointInfo.StaticId then
            return true, true, RegionBaseData 
        end
    end
    return true, false, {}
end

function GM_Command_Region:AddTeleportPoint(Id)
    Id = tonumber(Id)
    local Avatar = GWorld:GetAvatar()
    local TeleportPointInfo = DataMgr.TeleportPoint[Id]
    local GameMode = UGameplayStatics.GetGameMode(GWorld.GameInstance)
	local RegionDataSubsys = GameMode:GetRegionDataMgrSubSystem()
    local CommonRegionData = RegionDataSubsys.DataLibrary:GetFullRegionStoreDatas() or {}
    local CheckResult, IsUpdate, TargetRegionData = self:CheckAddTeleportPoint(Id, TeleportPointInfo,CommonRegionData)
    if CheckResult then
        TargetRegionData.State = {
            StateId = 901001,
            CanOpen = false,
            IsActive = false,
            OpenState = true,
        }
        if IsUpdate then
            local function callback(Ret)
                DebugPrint("ZJT_ AddAllTeleportPoint 原有传送点数据存在只对State数据进行替换 ", TargetRegionData.WorldRegionEid, TargetRegionData.CreatorId)
            end
            self:CallServer("UpdateRegionActorData", callback, TargetRegionData.WorldRegionEid, TargetRegionData.SubRegionId, 1, TargetRegionData.State, TargetRegionData.LevelName)
        else
            TargetRegionData.WorldRegionEid = URuntimeCommonFunctionLibrary.GenerateGUID()
            TargetRegionData.UnitId = 90100
            TargetRegionData.UnitType = "Mechanism" 
            TargetRegionData.SubRegionId = TeleportPointInfo.TeleportPointSubRegion
            TargetRegionData.CreatorId = TeleportPointInfo.StaticId
            TargetRegionData.LevelName = TeleportPointInfo.LevelName
            TargetRegionData.RegionDataType = 1
            TargetRegionData.IsUnlimited = true
            Avatar:AvatarC2SAddRegionActorData(TargetRegionData)
        end
    end
end

function GM_Command_Region:AddAllTeleportPoint()
    local Avatar = GWorld:GetAvatar()
    local GameMode = UGameplayStatics.GetGameMode(GWorld.GameInstance)
    local RegionDataSubsys = GameMode:GetRegionDataMgrSubSystem()
    local CommonRegionData = RegionDataSubsys.DataLibrary:GetFullRegionStoreDatas() or {}
    for Id, TeleportPointInfo in pairs(DataMgr.TeleportPoint) do
        local CheckResult, IsUpdate, TargetRegionData = self:CheckAddTeleportPoint(Id, TeleportPointInfo,CommonRegionData)
        if CheckResult then
            TargetRegionData.State = {
                StateId = 901001,
                CanOpen = false,
                IsActive = false,
                OpenState = true,
            }
            if IsUpdate then
                local function callback(Ret)
                    Avatar.logger.info("ZJT_ AddAllTeleportPoint 原有传送点数据存在只对State数据进行替换 ",TargetRegionData.WorldRegionEid, TargetRegionData.CreatorId)
                end
                Avatar:CallServer("UpdateRegionActorData", callback, TargetRegionData.WorldRegionEid, TargetRegionData.SubRegionId, 1, TargetRegionData.State, TargetRegionData.LevelName)
            else
                TargetRegionData.WorldRegionEid = URuntimeCommonFunctionLibrary.GenerateGUID()
                TargetRegionData.UnitId = 90100
                TargetRegionData.UnitType = "Mechanism" 
                TargetRegionData.SubRegionId = TeleportPointInfo.TeleportPointSubRegion
                TargetRegionData.CreatorId = TeleportPointInfo.StaticId
                TargetRegionData.LevelName = TeleportPointInfo.LevelName
                TargetRegionData.RegionDataType = 1
                TargetRegionData.IsUnlimited = true
                Avatar:AvatarC2SAddRegionActorData(TargetRegionData)
            end
        end
    end 
end

function GM_Command_Region:AddAllDeliverMechanism()
    local Avatar = GWorld:GetAvatar()
    local function Callback(ClientAllRegionBaseDataCache)
        local GameMode = UGameplayStatics.GetGameMode(GWorld.GameInstance)
        local RegionDataSubsys = GameMode:GetRegionDataMgrSubSystem()
        local CommonRegionData = ClientAllRegionBaseDataCache or {}
        local function CheckAddDeliverMechanism(Id, DeliverMechanismInfo, CommonRegionData)
            if not DeliverMechanismInfo then
                DebugPrint("ZJT_ 又不配表 ", Id)
                return false, false, {}
            end
            if not DeliverMechanismInfo.SubRegionId or not DataMgr.SubRegion[DeliverMechanismInfo.SubRegionId] then
                DebugPrint("ZJT_ SubRegion表 不存在该子区域ID : ", DeliverMechanismInfo.SubRegionId )
                return false, false, {}
            end
            if not DeliverMechanismInfo.LevelName then
                DebugPrint("ZJT_ 不存在配表LevelName : ", DeliverMechanismInfo.TeleportPointSubRegion )
                return false, false, {}
            end
            if not DeliverMechanismInfo.Id then
                DebugPrint("ZJT_ 不存在配表CreatorId : ", DeliverMechanismInfo.Id )
                return false, false, {}
            end
            for WorldRegionEid, RegionBaseData in pairs(CommonRegionData) do
                if RegionBaseData.ManualItemId == DeliverMechanismInfo.Id then
                    return true, true, RegionBaseData 
                end
            end
            return true, false, {}
        end
    
        local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
        local Struct = GameState.MechanismMap:FindRef("Delivery")
        local TargetDelvierMap = {}
        for i, v in pairs(Struct.Array:ToTable()) do
            if IsValid(v) then
                DebugPrint("ZJT_ 111111111111 GameState ", v.ManualItemId)
                TargetDelvierMap[v.ManualItemId] = v
            end
        end
        for ManualItemId, DeliverMechanismInfo in pairs(DataMgr.DeliverMechanism) do
            local SubRegionId = DeliverMechanismInfo.SubRegionId
            local LevelName = DeliverMechanismInfo.LevelName
            local CheckResult, IsUpdate, TargetRegionData = CheckAddDeliverMechanism(ManualItemId, DeliverMechanismInfo, CommonRegionData)
            if CheckResult then
                TargetRegionData.State = {
                    StateId = 26,
                    CanOpen = true,
                    IsActive = true,
                    OpenState = false,
                }
                if TargetDelvierMap[ManualItemId] then
                    DebugPrint("ZJT_ 1111111111 ", ManualItemId, IsValid(TargetDelvierMap[ManualItemId]))
                    if IsValid(TargetDelvierMap[ManualItemId]) then
                        TargetDelvierMap[ManualItemId]:GMUnlock()
                    end
                end
                if IsUpdate then
                    local function callback(Ret)
                        Avatar.logger.info("ZJT_ AddAllTeleportPoint 原有传送点数据存在只对State数据进行替换 ",Ret, TargetRegionData.WorldRegionEid, TargetRegionData.CreatorId)
                    end
                    Avatar:CallServer("UpdateRegionActorData", callback, TargetRegionData.WorldRegionEid, TargetRegionData.SubRegionId, 1, TargetRegionData.State, TargetRegionData.LevelName)
                else
                    TargetRegionData.WorldRegionEid = URuntimeCommonFunctionLibrary.GenerateGUID()
                    TargetRegionData.UnitId = 18
                    TargetRegionData.UnitType = "Mechanism" 
                    TargetRegionData.SubRegionId = SubRegionId
                    TargetRegionData.ManualItemId = ManualItemId
                    TargetRegionData.LevelName = LevelName
                    TargetRegionData.RegionDataType = 1
                    Avatar:AvatarC2SAddRegionActorData(TargetRegionData)
                end
            end
        end
    end
    Avatar:GMHandleSyncAllRegionDataToClient(Callback)
end


function GM_Command_Region:PurchaseImpressionShopItem(ImpressionShopId, DiceNum)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:PurchaseImpressionShopItem(ImpressionShopId, DiceNum)
    end
end

function GM_Command_Region:PrintSimpleRegionData(WorldRegionEid)
	local SubSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, URegionDataMgrSubsystem:StaticClass())
	SubSystem:PrintSimpleRegionData(WorldRegionEid)
end

function GM_Command_Region:PrintFullRegionData(WorldRegionEid)
	local SubSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, URegionDataMgrSubsystem:StaticClass())
	if SubSystem then
		local Index = SubSystem:GetLuaDataIndex(WorldRegionEid)
		if Index then
			local Data = SubSystem.DataPool:GetRegionEntityData(Index)
			PrintTable(Data, 10)
			return
		end
	end
	DebugPrint("NODATATATATA")
end

function GM_Command_Region:AddRandomCreatorRegionDatas()
    local Avatar = GWorld:GetAvatar()
    local RandomCreatorDatas = {}
    RandomCreatorDatas.RegionDataType = 5
    RandomCreatorDatas.RandomRuleId = 7000002
    RandomCreatorDatas.RegionDatas = {}
    for i = 1, 10 do
        local TargetRegionData = {}
        TargetRegionData.WorldRegionEid = URuntimeCommonFunctionLibrary.GenerateGUID()
        TargetRegionData.LevelName = "TeleportPoint_LevelName"
        TargetRegionData.SubRegionId = Avatar:GetCurrentRegionId()
        TargetRegionData.RandomIdxInRule = math.random(1 ,100)
        TargetRegionData.RandomTableId = math.random(1 ,100)
        TargetRegionData.Location = {
            X = math.random(1 ,100000),
            Y = math.random(1 ,100000),
            Z = math.random(1 ,100000)
        } 
        table.insert( RandomCreatorDatas.RegionDatas, TargetRegionData )
    end
    PrintTable({RandomCreatorDatas = RandomCreatorDatas}, 10)
    Avatar:AddRandomCreatorRegionDatas(RandomCreatorDatas)
    Avatar:AddRandomCreatorRegionDatas(RandomCreatorDatas)
end

function GM_Command_Region:ReActiveOneExplore(RarelyId)
    if not RarelyId then return end
    RarelyId = tonumber(RarelyId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    local GameState = GameMode.EMGameState
    local ExploreGroup = GameState.ExploreGroupMap:FindRef(RarelyId)
    local SubRegionId
    if ExploreGroup then
        SubRegionId = GameMode:GetRegionIdByLocation(ExploreGroup:K2_GetActorLocation())
        ExploreGroup:GMReceiveOnExploreGroupResetUI()
        ExploreGroup:TryDeactive()
        DebugPrint("ZJT_ 客户端探索组重置成功 删除对应数据 ", RarelyId)
    end
    if Avatar.Explores[RarelyId] then
        local function Callback(Ret)
            if Avatar:CheckRegionErrorCode(Ret) then
                DebugPrint("ZJT_ 服务端重置探索组到Doing 成功：  ",RarelyId,  Ret)
                EventManager:FireEvent(EventID.OnExploreGroupDeactive, RarelyId)
                EventManager:FireEvent(EventID.OnExploreGroupReset, RarelyId)
                EventManager:FireEvent(EventID.OnExploreGroupActive, RarelyId)
            else
                DebugPrint("ZJT_ 服务端重置探索组到Doing 失败：  ",RarelyId,  Ret)
            end
        end
        Avatar:CallServer("GMResetingExplore2Doing", Callback, RarelyId)
    else
        if not SubRegionId then
            ScreenPrint("不能激活不在该区域的探索组，请移动到该探索组所在区域在激活 ")
            return
        end
        Avatar:ExploreIdActive(RarelyId, SubRegionId)        
    end
end
function GM_Command_Region:ReActiveAllExplore()
    local Avatar = GWorld:GetAvatar()
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    local GameState = GameMode.EMGameState
    if not Avatar then return end
    local RarelyIdTable = {}
    for RarelyId, Explore in pairs(Avatar.Explores) do
        if Explore:IsDoing() or Explore:IsComplete() then
            local ExploreGroup = GameState.ExploreGroupMap:FindRef(RarelyId)
            if ExploreGroup then
                ExploreGroup:GMReceiveOnExploreGroupResetUI()
                ExploreGroup:TryDeactive()
            end
            table.insert(RarelyIdTable, RarelyId)
        end
    end
    local function Callback(Ret, SuccTable)
        if not Avatar:CheckRegionErrorCode(Ret) then
            DebugPrint("ZJT_ 重置探索组失败 GM指令 错误码 ： ",Ret )
            return
        end
        if not SuccTable or #SuccTable <= 0 then
            DebugPrint("ZJT_ 重置探索组失败 GM指令 没有探索组重置成功 ： ",Ret )
            return
        end
        for _, RarelyId in ipairs(SuccTable) do
            DebugPrint("ZJT_ 服务端重置探索组到Doing 成功：  ",RarelyId,  Ret)
            EventManager:FireEvent(EventID.OnExploreGroupDeactive, RarelyId)
            EventManager:FireEvent(EventID.OnExploreGroupActive, RarelyId)
        end
    end
    PrintTable({RarelyIdTable = RarelyIdTable}, 10)
    if next( RarelyIdTable) ~= nil then
        Avatar:CallServer("RestingExploreIds", Callback, RarelyIdTable)
    end
    local ActiveIds = {}
    for RarelyId, ExploreGroup in pairs(GameState.ExploreGroupMap:ToTable()) do
        DebugPrint("ZJT_ 激活未激活探索组 ", RarelyId, ExploreGroup:GetStatus())
        if ExploreGroup:GetStatus() == EExploreGroupStatus.EGS_Deactive then
            DebugPrint("ZJT_ 11111111111 EExploreGroupStatus ",  RarelyId, ExploreGroup:GetStatus(), EExploreGroupStatus.EGS_Deactive)
            local ExploreGroup = GameState.ExploreGroupMap:FindRef(RarelyId)
            if ExploreGroup then
                ExploreGroup:GMReceiveOnExploreGroupResetUI()
                ExploreGroup:TryDeactive()
                local SubRegionId = GameMode:GetRegionIdByLocation(ExploreGroup:K2_GetActorLocation())
                ActiveIds[RarelyId] = SubRegionId
            end
        end
    end
    PrintTable({ActiveIds = ActiveIds}, 10)
    if next( ActiveIds) ~= nil then
        Avatar:ExploreIdsActive(ActiveIds)
    end
end

function GM_Command_Region:CharAppearance()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local CharUuid = Avatar.CurrentChar
    Avatar:SwitchCurrentCharAppearance(CharUuid, 1)
    Avatar:SwitchCurrentCharAppearance(CharUuid, 2)
    Avatar:SwitchCurrentCharAppearance(CharUuid, 3)
    Avatar:SwitchCurrentCharAppearance(CharUuid, 4)
    Avatar:AddNewCharAppearance()
    Avatar:SwitchCurrentCharAppearance(CharUuid, 4)
    Avatar:SetCharAppearanceAccessory(CharUuid, 1, 10002)
    Avatar:SetCharAppearanceAccessory(CharUuid, 4, 10002)
    Avatar:RemoveCharAppearanceAccessory(CharUuid, 1, 10002)
    Avatar:RemoveCharAppearanceAccessory(CharUuid, 4, 10002)
    Avatar:SetCharShowPart(CharUuid, 1, false)
    Avatar:SetCharShowPart(CharUuid, 1, true)
    Avatar:SetCharShowPart(CharUuid, 2, true)
    Avatar:SetCharShowPart(CharUuid, 3, false)
end

function GM_Command_Region:DispatchSystem(DispatchId)
    DispatchId = tonumber(DispatchId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local CharUuid = Avatar.CurrentChar
    local DispatchCharsList = {}
    table.insert(DispatchCharsList, CharUuid)
    -- Avatar:StartDispatch(DispatchId, false, DispatchCharsList)
    Avatar:CancelDispatch(DispatchId)
    -- Avatar:CompleteDispatch(DispatchId)
end

function GM_Command_Region:GetDispatchReward(DispatchId)
    DispatchId = tonumber(DispatchId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    Avatar:CompleteDispatch(DispatchId)
end

function GM_Command_Region:GetAllDispatchReward(DispatchId1, DispatchId2)
    local Avatar = GWorld:GetAvatar()
    DispatchId1 = tonumber(DispatchId1)
    DispatchId2 = tonumber(DispatchId2)
    local DispatchReward = {}
    table.insert(DispatchReward, DispatchId1)
    table.insert(DispatchReward, DispatchId2)
    if not Avatar then return end
    Avatar:GetAllDispatchReward({})
    Avatar:GetAllDispatchReward(DispatchReward)
end

function GM_Command_Region:PrintDispatchSystem()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        PrintTable({CurrentList = Avatar.CurrentDispatchList:all_dump(Avatar.CurrentDispatchList)}, 10)
        PrintTable({Dispatches = Avatar.Dispatches:all_dump(Avatar.Dispatches)}, 10)
    end
end

function GM_Command_Region:PrintImpressionRandom(Count)
    if not Count then return end
    Count = tonumber(Count)
    if Count <= 0 then return end
    for i = 1 , Count do
        local  function Normal_Random()
            local u1 = math.random()
            local u2 = math.random()
            local z0 = math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2)
            return DataMgr.GlobalConstant.ImpressionAvgNum.ConstantValue + DataMgr.GlobalConstant.ImpressionStdNum.ConstantValue * z0
        end
        local LoopCount = 10
        local Res
        repeat
            Res = Normal_Random()
            LoopCount = LoopCount - 1
        until ( Res >= 0 and Res < 100 ) or LoopCount <= 0
        if Res >= 100 then
            DebugPrint("ZJT_ PrintImpressionRandom Index Res1 tens units ", i, Res, 9,9)
        elseif Res >= 0 and Res < 100 then
            local tens = math.floor(Res / 10) % 10 -- 除以 10 取整后取余数
            local units = math.floor(Res) % 10 
            DebugPrint("ZJT_ PrintImpressionRandom Index Res1 tens units ", i, Res, units, tens)
        else
            DebugPrint("ZJT_ PrintImpressionRandom Index Res1 tens units ", i, Res, 0, 0)
        end
    end
end

---@Deprecated
function GM_Command_Region:TestImpressionSystem(PreDialogueId, CurrentDialogueId, TalkTriggerId)
    -- TalkTriggerId = tonumber(TalkTriggerId)
    -- PreDialogueId = tonumber(PreDialogueId)
    -- CurrentDialogueId = tonumber(CurrentDialogueId)
    -- local Avatar = GWorld:GetAvatar()
    -- if Avatar then
    --     Avatar:ImpressionCheckByEnumId_New(PreDialogueId, CurrentDialogueId, 10, false)        
    --     Avatar:ImpressionCheckByEnumId_New(PreDialogueId, CurrentDialogueId, 10, true)  
    --     Avatar:ImpressionCheckByEnumId_New(PreDialogueId, CurrentDialogueId, 10, false)  
    --     Avatar:ImpressionAddByEnumId_New(PreDialogueId, CurrentDialogueId)
    --     Avatar:SetTalkTriggerComplete_New(TalkTriggerId)
    -- end
end

function GM_Command_Region:TestSojournsSystem(PartyId, Level)
    PartyId = tonumber(PartyId)
    Level = tonumber(Level)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:StartSojourns(PartyId, Level)
        -- Avatar:ExitSojourns(PartyId, Level)
    end
end

function GM_Command_Region:UseBattleWheelItem(ResourceId)
    if not ResourceId then
        ScreenPrint("UseBattleWheelItem Id没传：")
        return
    end
    ResourceId = tonumber(ResourceId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        ScreenPrint("UseBattleWheelItem 没有连接服务器 Id没传："..ResourceId)
        return
    end
    Avatar:UseWheelItemInBattle(ResourceId)
end

function GM_Command_Region:OnRequestUseOwnerRegionOnlineItem(RequestResNum)
    local Avatar = GWorld:GetAvatar()
    local RequestRes = false
    RequestResNum = tonumber(RequestResNum)
    if RequestResNum > 0 then
        RequestRes = true
    end
    if not Avatar then return end
    Avatar:OnRequestUseOwnerRegionOnlineItem(Avatar.CurrentOnlineType,  Avatar.RequestEid, RequestRes)
end

function GM_Command_Region:RequestLevelRegionOnlineItem(ExpressionId, UniqueId)
    local Avatar = GWorld:GetAvatar()
    ExpressionId = tonumber(ExpressionId)
    UniqueId= tonumber(UniqueId)
    if not Avatar then return end
    Avatar:RequestLevelRegionOnlineItem(Avatar.CurrentOnlineType, ExpressionId, Avatar.OwnerEid, UniqueId)
end



function GM_Command_Region:AddImpressionPreNode(PreDialogueId)
    PreDialogueId = tonumber(PreDialogueId)
    local ErrorCode = ""
    local printError = function()
        DebugPrint("GM_Command:AddImpressionPreNode@", ErrorCode)
        local UIManager = GWorld.GameInstance:GetGameUIManager()
        UIManager:ShowUITip(UIConst.Tip_CommonToast, ErrorCode, 3)
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        ErrorCode = "Avatar不存在"
        printError()
        return
    end
    if Avatar:IsImpressionCheckSuccess(PreDialogueId) then
        ErrorCode = "对应的选项已被记录，无法重复选择"
        printError()
        return
    end
    Avatar:GMAddImpressionPreNode(PreDialogueId)
end

function GM_Command_Region:SetViewTargetWithWC(X, Y, Z)
    local Location = FVector(tonumber(X), tonumber(Y), tonumber(Z))
    local Transform = UE4.FTransform(FRotator(), Location)
    local Actor = self.Player:GetWorld():SpawnActor(ACameraActor.StaticClass(), Transform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self.Player)
	local WCSubsystem = GameMode:GetWCSubSystem()
	WCSubsystem:SetViewTargetWithWC(Actor, {self,function()
        DebugPrint('LogWC SetViewTargetWithWC Finish')
        self.Player:AddTimer(10,function()
            UGameplayStatics.GetPlayerController(self.Player, 0):SetViewTargetWithBlend(self.Player)
        end)
    end})
end

function GM_Command_Region:CreateRegionPet(UnitId)
    UnitId = tonumber(UnitId)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self.Player)
    local WCSubsystem = GameMode:GetWCSubSystem()
    local LevelName = WCSubsystem:GetLocationLevelName(self.Player:K2_GetActorLocation())
    local GameInstance = self:GetGameInstance()
    local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
    GMFunctionLibrary.ExecConsoleCommand(GameInstance, "sgm crp " .. UnitId.." "..LevelName)
end

return GM_Command_Region