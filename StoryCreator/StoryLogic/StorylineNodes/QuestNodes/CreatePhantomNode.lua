


local EActorEventType = require 'StoryCreator.StoryLogic.StorylineUtils'.EActorEventType
local BattleUtils = require "Utils.BattleUtils"

local CreatePhantomNode = Class('StoryCreator.StoryLogic.StorylineNodes.Questline.QuestNode')

function CreatePhantomNode:Init()
    self.IsCreate = true
    self.IsClearOtherPhantom = false
    self.StaticCreatorIdList = {}
    self.IsSync = false
end

function CreatePhantomNode:Start(Context)
	self.Context = Context
    self.TotalCeatorNumCounter = 0

    if self.IsCreate then
        self:STLClearOtherPhantom()
        self:STLCreatePhantom()
    else
        self:STLDestroyPhantom()
    end
end

function CreatePhantomNode:STLCreatePhantom()
    -- 如果需要等待魅影创建完成的回调，绑定事件
    if self.IsSync then
        for _, StaticCreatorId in pairs(self.StaticCreatorIdList) do
            self.TotalCeatorNumCounter = self.TotalCeatorNumCounter + 1
            GWorld.StoryMgr:BindStaticCreatorActorEvent(StaticCreatorId, EActorEventType.OnCreated, self, self.LoadFinishCallback)
        end
        DebugPrint("CreatePhantomNode: 绑定回调，需等待回调总数: ", self.TotalCeatorNumCounter)
    end

    -- 激活静态点
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    for _, CreatorId in pairs(self.StaticCreatorIdList) do
        self:ActivePhantomStaticCreator(GameMode, Player, CreatorId)
    end

    -- 如果不需要等待魅影创建完成的回调，直接结束
    if not self.IsSync then
        self:FinishAction()
    end
end

function CreatePhantomNode:LoadFinishCallback(InfoTable)
    if not self.IsSync then
        ScreenPrint("CreatePhantomNode: 仅在开启同步时才需要触发回调！请联系ljl检查！")
        return
    end

    self.TotalCeatorNumCounter = self.TotalCeatorNumCounter - 1
    DebugPrint('CreatePhantomNode LoadFinishCallback CreatorId:', InfoTable.Actor.CreatorId, " WaitingCallbackNum: ", self.TotalCeatorNumCounter)
    if self.TotalCeatorNumCounter == 0 then
        self:FinishAction()
    end
end

function CreatePhantomNode:ActivePhantomStaticCreator(GameMode, Player, CreatorId)
    local Creator = GameMode.EMGameState:GetStaticCreatorInfo(CreatorId)

    if self:IsPhantomExist(Creator) then
        DebugPrint("CreatePhantomNode: 尝试生成的魅影已存在，静态点Id:", CreatorId)
        return
    end
    if not IsValid(Creator) then
        ScreenPrint("CreatePhantomNode: 静态点不合法, 找不到静态点！静态点Id:"..CreatorId)
        return
    end
    if not GameMode:CheckLevelLoadedByActor(Creator) then
        ScreenPrint("CreatePhantomNode: 静态点不合法, 静态点所在关卡未加载！静态点Id:"..CreatorId)
        return
    end

    local SpecialQuestId = nil
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        SpecialQuestId = Avatar.SpecialQuestId
    end
    GameMode:STLSetPhantomCreatorRegionInfo(Creator, self.QuestChainId, SpecialQuestId)

    -- local STLPhantomExtraInfo = BattleUtils.GetExtraCreateInfo(Creator.UnitType, Creator.UnitId, Creator.UnitId)
    -- STLPhantomExtraInfo.Camp = "Player"
    -- STLPhantomExtraInfo.PhantomOwnerEid = Player.Eid
    -- STLPhantomExtraInfo.FixLocation = true 
    -- STLPhantomExtraInfo.FixLocationZ = 0
    Creator:RealActiveStaticCreator()

    DebugPrint("CreatePhantomNode: 生成魅影，静态点Id:", Creator.StaticCreatorId)
end

function CreatePhantomNode:IsPhantomExist(Creator)
    if not IsValid(Creator) then
        return false
    end
    local Eids = Creator.ChildEids:ToTable()
    for _, Eid in pairs(Eids) do
        local PhantomChar = Battle(GWorld.GameInstance):GetEntity(Eid)
        if IsValid(PhantomChar) then
            return true
        end
    end
    return false
end

function CreatePhantomNode:STLClearOtherPhantom()
    if self.IsClearOtherPhantom then
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
        UE4.UPhantomFunctionLibrary.CancelAllPhantomFromOwner(Player, EDestroyReason.StoryLine)
    end
end

function CreatePhantomNode:STLDestroyPhantom()
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    local StaticCreatorArray = TArray(0)
    for _, CreatorId in pairs(self.StaticCreatorIdList) do
        StaticCreatorArray:Add(CreatorId)
        DebugPrint("CreatePhantomNode: 销毁魅影，静态点Id:", CreatorId)
    end
    GameMode:TriggerInactiveStaticCreator(StaticCreatorArray, false, EDestroyReason.StoryLine)

    self:FinishAction()
end

function CreatePhantomNode:FinishAction()
    self:Finish()
end

function CreatePhantomNode:Clear()
    if self.IsSync then
        for _, StaticCreatorId in pairs(self.StaticCreatorIdList) do
            GWorld.StoryMgr:UnbindStaticCreatorActorEventByType(StaticCreatorId, EActorEventType.OnCreated)
        end
        self.TotalCeatorNumCounter = 0
    end
end

return CreatePhantomNode