--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local StoryPlayableUtils = require "BluePrints.Story.StoryPlayableUtils"

local BP_EmptyNPC_C = Class("BluePrints.Char.BP_NPC_C")

-- function BP_EmptyNPC_C:InitCharacterInfo(Info)
--     DebugPrint("BP_EmptyNPC_C:InitCharacterInfo")
--     self.UnitType = "Npc"
--     self.NpcData = DataMgr.Npc[Info.UnitId]
--     self.NpcId = Info.UnitId
--     self.UnitId = Info.UnitId
--     self.NpcTalkInteractiveComponent:Init()
--     self.NpcTalkInteractiveComponent:DisableNameDisplay()
--     self:AddNpc()

--     self.ServerInitSuccess = true
--     self.InitSuccess = true

--     if Info.LoadFinishCallback then
--     	Info.LoadFinishCallback(self)
--     end
-- end

-- Npc 初始化
function BP_EmptyNPC_C:InitInfo(Info)
    DebugPrint("BP_EmptyNPC_C:InitInfo")
    self.Super.InitInfo(self,Info)
    self.UnitType = "Npc"
    self.NpcTalkInteractiveComponent:DisableNameDisplay()

    self:AddNpc()
    self.ServerInitSuccess = true
     self.InitSuccess = true

    if Info.LoadFinishCallback then
    	Info.LoadFinishCallback(self)
    end
end

--function BP_EmptyNPC_C:Initialize(Initializer)
--end

--function BP_EmptyNPC_C:UserConstructionScript()
--end

function BP_EmptyNPC_C:ReceiveBeginPlay()
    --self:InitCharacterInfo()
    self.DelayFuncs = {} --todo self.InitSuccess = true导致
    self.IsDestroied = false
    self.bIsEmptyNpc = true
    if IsValid(self.NpcTalkInteractiveComponent) then
        self.NpcTalkInteractiveComponent:DisableNameDisplay()
    end
end

function BP_EmptyNPC_C:ReceiveEndPlay()
	local GameState = UE4.UGameplayStatics.GetGameState(self)
    GameState:RecordNpcEntity(self, false)
    self:UnRegisterHeadUI()
    self.IsDestroied = true
end

-- function BP_EmptyNPC_C:GetObjType()
--     return EObjType.NpcCharacter
-- end

function BP_EmptyNPC_C:LoadCurrentModel()
    DebugPrint("EmptyNPC do not need to LoadCurrentModel: Name=>" .. self:GetName() .. "NpcId:" .. self.NpcId .. "Eid:" .. self.Eid)
end

--  --todo self.InitSuccess = true导致，考虑NPC和怪物继承分离
-- function BP_EmptyNPC_C:TickMonsterBattleComponent(DeltaSeconds)
-- end

--function BP_EmptyNPC_C:ReceiveEndPlay()
--end

-- function BP_EmptyNPC_C:ReceiveTick(DeltaSeconds)
-- end

--function BP_EmptyNPC_C:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
--end

--function BP_EmptyNPC_C:ReceiveActorBeginOverlap(OtherActor)
--end

--function BP_EmptyNPC_C:ReceiveActorEndOverlap(OtherActor)
--end

--region UStoryPlayableInterface
function BP_EmptyNPC_C:GetFreeCameraOffset()
    return FVector(0)
end

---@param RotationAngle number
---@param OnStoryActionFinished FOnStoryActionFinished
function BP_EmptyNPC_C:RotateOffset(RotationAngle, OnFinished, MontageName)
    StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
end

---@param ActionId FName
---@param OnFinished FOnStoryActionFinished
function BP_EmptyNPC_C:PlayTalkAction(ActionId, OnFinished, CallbackObj, CallbackFuncName, IsSync)
    if (IsValid(CallbackObj) and CallbackFuncName) then
        CallbackObj[CallbackFuncName](CallbackObj)
    else
        StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
    end
    return 0
end
--endregion UStoryPlayableInterface

return BP_EmptyNPC_C
