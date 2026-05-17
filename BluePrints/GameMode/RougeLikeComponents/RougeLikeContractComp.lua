---@type BP_RougeLikeManager_C
local UIUtils = require "Utils.UIUtils"
local Component = {}


function Component:UpdateContractEffect()
    DebugPrint("Tianyi@ UpdateContractEffect!")
    for k, v in pairs(self.Contract) do 
        local ContractId = k 
        local ContractLevel = v 

        -- 初始化契约带来的全局被动效果
        local ContractData = DataMgr.RougelikeContract[ContractId]
        if ContractData then 
            if ContractData.GlobalPassiveId then 
                DebugPrint("Tianyi@ Add GlobalPassive, Id = " .. ContractData.GlobalPassiveId .. " Level = " .. ContractLevel)
                Battle(self):AddGlobalPassive(ContractData.GlobalPassiveId, nil, ContractLevel - 1)
            end
        end
    end
end

function Component:TriggerAllContractDungeonEffect()
    DebugPrint("HTY UpdateContractDungeonEffect")
    for k, v in pairs(self.Contract) do 
        self:TriggerContractDungeonEffect(k, v)
    end
end

function Component:TriggerContractDungeonEffect(ContractId, ContractLevel)
    -- 契约关卡效果
    DebugPrint("HTY TriggerContractDungeonEffect ContractId: ", ContractId, "ContractLevel: ", ContractLevel)
    local RoomType = DataMgr.RougeLikeRoom[self.RoomId].RoomType
    local ContractData = DataMgr.RougelikeContract[ContractId]
    local EffectRoomTypes = ContractData.RoomType
    if EffectRoomTypes == nil then
        DebugPrint("HTY 当前ContractId 没有要生效的关卡契约效果")
        return
    end
    for i = 1, #EffectRoomTypes do
        -- DebugPrint("RoomType: ", RoomType, "EffectRoomTypes[i]", EffectRoomTypes[i])
        if RoomType == EffectRoomTypes[i] then
            local GameMode = UE4.UGameplayStatics.GetGameMode(self)
            if GameMode == nil then
                DebugPrint("TriggerContractDungeonEffect GameMode == nil ContractId: ", ContractId)
                return
            end
            local UnitType = ContractData.UnitType
            local UnitIdArray = ContractData.UnitId
            local UnitNum = ContractData.UnitNum[ContractLevel]
            local GameState = UE.UGameplayStatics.GetGameState(self)
            local CheckStatic = {}
            local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
            local LevelId = GameMode:GetActorLevelName(Player)
            local Creators = TMap(0, UObject)
            GameState:GetSubStaticCreatorInfo(LevelId, Creators)
            for Id, StaticCreator in pairs(Creators) do
                if StaticCreator.NoteName == "ContractStaticCreator" and StaticCreator.UnitType == UnitType then
                    table.insert(CheckStatic, Id)
                end
            end
            if #CheckStatic == 0 then
                DebugPrint("Error: HTY 没有生成契约Unit的静态点 ContractId: ", ContractId, "ContractLevel: ", ContractLevel, "UnitType: ", UnitType)
                return
            end
            for Count = 1, UnitNum do
                local RandomIndex = math.random(1, #UnitIdArray)
                local RandomUnitId = UnitIdArray[RandomIndex]
                local CreatorId = CheckStatic[math.random(1, #CheckStatic)]
                local StaticCreator = Creators:FindRef(CreatorId)
                StaticCreator.UnitId = RandomUnitId
                -- StaticCreator.Level = GameMode:GetFixedGamemodeLevel()
                DebugPrint("HTY Create Contract Unit, UnitType: ", UnitType, "RandomUnitId: ", RandomUnitId, "CreatorId: ", CreatorId, "StaticCreator: ", StaticCreator.DisplayName)
                local SubGameMode = GameMode.SubGameModeInfo:Find(LevelId)
                if SubGameMode ~= nil then
                    SubGameMode:TriggerActiveStaticCreator({CreatorId}, "ContractSpawn", true)
                end
            end
            return
        end
    end
end

return Component