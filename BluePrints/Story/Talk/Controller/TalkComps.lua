local ETalkCompType = require "BluePrints.Story.Talk.Controller.TalkCompType"

---@class TalkCompBase_C
local TalkCompBase_C = {}
function TalkCompBase_C:GetType()
    error("Talk property must implement GetType func!")
end
function TalkCompBase_C:Execute()
    error("Talk property must implement execute func!")
end
function TalkCompBase_C:Resume()
    error("Talk property must implement resume func!")
end

local function CreateTalkComp()
    local Class = setmetatable({}, {
        __index = TalkCompBase_C
    })
    return Class
end

---@class TalkComp_HideGameUI_C:TalkCompBase_C
local TalkComp_HideGameUI_C = CreateTalkComp()
TalkComp_HideGameUI_C.New = function(TalkContext)
    ---@type TalkComp_HideGameUI_C
    local Obj = setmetatable({}, {
        __index = TalkComp_HideGameUI_C
    })
    ---@type BP_TalkContext_C
    Obj.TalkContext = TalkContext
    return Obj
end

function TalkComp_HideGameUI_C:GetType()
    return ETalkCompType.HideGameUI
end

function TalkComp_HideGameUI_C:Execute()
    self:SetGameUIHiddenExceptStory(true)
    self.TalkContext.TalkStateManager:SetTalkStateByTag(Const.TalkState_HiddenGameUI,true,self)
end

function TalkComp_HideGameUI_C:Resume()
    self:SetGameUIHiddenExceptStory(false)
    self.TalkContext.TalkStateManager:SetTalkStateByTag(Const.TalkState_HiddenGameUI,false,self)
end

function TalkComp_HideGameUI_C:SetGameUIHiddenExceptStory(bHidden)
    ---@type BP_EMGameInstance_C 
    local UIManager = UIManager(GWorld.GameInstance)
    local ExceptUINames = TSet(FName)
    local UINames = UIManager:GetShowInStoryUINames()
    for _,Name in pairs(UINames) do
        ExceptUINames:Add(Name)
    end
    UIManager:HideAllUI_EX(ExceptUINames, bHidden, Const.TalkHideTag)
end

---@class TalkComp_DisableInput_C:TalkCompBase_C
local TalkComp_DisableInput_C = CreateTalkComp()
---@param Player ACharacter
---@param PlayerController APlayerController
TalkComp_DisableInput_C.New = function(Player, PlayerController, TalkTaskData)
    local Obj = setmetatable({}, {
        __index = TalkComp_DisableInput_C
    })
    Obj.Player = Player
    Obj.PlayerController = PlayerController
    Obj.TalkTaskData = TalkTaskData
    return Obj
end

function TalkComp_DisableInput_C:GetType()
    return ETalkCompType.DisableInput
end

function TalkComp_DisableInput_C:Execute()
    self:SetGameInputDisable(self.Player, self.PlayerController, true)
end

function TalkComp_DisableInput_C:Resume()
    self:SetGameInputDisable(self.Player, self.PlayerController, false)
end

function TalkComp_DisableInput_C:SetGameInputDisable(Player, PlayerController, bDisable)
    local PreMode =  UE4.URuntimeCommonFunctionLibrary.GetInputMode(Player:GetWorld())
    if (bDisable) then
        DebugPrint("Disable Input By TalkComp")
        if IsValid(Player) and Player:GetController() and Player:GetController():IsA(APlayerController) then
            Player:AddDisableInputTag("Talk")
        end
    else
        DebugPrint("Enable Input By TalkComp")
        if IsValid(Player) and Player:GetController() and Player:GetController():IsA(APlayerController) then
            Player:RemoveDisableInputTag("Talk")
        end
    end
    local CurMode =  UE4.URuntimeCommonFunctionLibrary.GetInputMode(Player:GetWorld())
    -- if(PreMode ~= CurMode) then
        DebugPrint("MouseCaptureMode => PreMode:" .. PreMode .. "," .. "CurMode:" .. CurMode)
        EventManager:FireEvent(EventID.SetInputMode, bDisable)
    -- end
    EventManager:FireEvent(EventID.TalkComp, bDisable)
end

--Todo 废弃
---@class TalkComp_PopMouse_C:TalkCompBase_C
local TalkComp_PopMouse_C = CreateTalkComp()
---@param PlayerController APlayerController
TalkComp_PopMouse_C.New = function(PlayerController, TalkTaskData)
    local Obj = setmetatable({}, {
        __index = TalkComp_PopMouse_C
    })
    Obj.PlayerController = PlayerController
    Obj.TalkTaskData = TalkTaskData
    return Obj
end
function TalkComp_PopMouse_C:GetType()
    return ETalkCompType.PopMouse
end
function TalkComp_PopMouse_C:Execute()
    self:PopMouse(self.PlayerController, true)
end
function TalkComp_PopMouse_C:Resume()
    self:PopMouse(self.PlayerController, false)
end
function TalkComp_PopMouse_C:PopMouse(PlayerController, bPop)
    if (bPop) then
        DebugPrint("PopMouse")
        if CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance) ~= 'Mobile' then
            PlayerController.bShowMouseCursor = true
        end
    else
        DebugPrint("FocusMouse")
        PlayerController.bShowMouseCursor = false
    end
end

---@class TalkComp_StopPlayerAction_C:TalkCompBase_C
local TalkComp_StopPlayerAction_C = CreateTalkComp()
---@param Player BP_CharacterBase_C
TalkComp_StopPlayerAction_C.New = function(Player, TalkContext)
    local Obj = setmetatable({}, {
        __index = TalkComp_StopPlayerAction_C
    })
    Obj.InteractiveTag = "Interactive"
    Obj.Player = Player
    Obj.TalkContext = TalkContext
    return Obj
end
function TalkComp_StopPlayerAction_C:GetType()
    return ETalkCompType.StopPlayerAction
end
function TalkComp_StopPlayerAction_C:Execute()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self.TalkContext)
    DebugPrint("StopPlayerAction Execute", GameMode)
    if GameMode and GameMode.SetPlayerCharacterForceIdle then
        if not self.Player:IsDead() then
            GameMode:SetPlayerCharacterForceIdle(self.Player)
            self.Player:SetCharacterTag(self.InteractiveTag)
        end
    end
end
function TalkComp_StopPlayerAction_C:Resume()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self.TalkContext)
    DebugPrint("StopPlayerAction Resume", GameMode)
    if GameMode and GameMode.SetPlayerCharacterForceIdle then
        if not self.Player:IsDead() then
            GameMode:SetPlayerCharacterForceIdle(self.Player)
        end
    end
end

---@class TalkComp_PauseGame_C:TalkCompBase_C
local TalkComp_PauseGame_C= CreateTalkComp()
---@param TalkContext BP_TalkContext_C
TalkComp_PauseGame_C.New = function(TalkContext,bDisableMonsterAI,bDisableNPCAI)
    ---@type TalkComp_PauseGame_C
    local Obj = setmetatable({}, {
        __index = TalkComp_PauseGame_C
    })
    ---@type BP_TalkContext_C
    Obj.TalkContext = TalkContext
    Obj.bDisableMonsterAI = bDisableMonsterAI 
    Obj.bDisableNPCAI = bDisableNPCAI
    return Obj
end
function TalkComp_PauseGame_C:GetType()
    return ETalkCompType.PauseGame
end
function TalkComp_PauseGame_C:Execute()
    self.ImmunePauseObjects = {}
	EventManager:FireEvent(EventID.TalkPauseGame)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self.TalkContext)
    if GameMode == nil then
        DebugPrint("Get GameMode failed...") -- use another assert?
        return
    end
    --GameMode:SetGamePaused(Const.Tag_GamePausedByTalk, true)
    local PC = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance,0)
    if IsValid(PC) then
        PC.bShouldPerformFullTickWhenPaused = true
        self.OriFullTick = PC.bShouldPerformFullTickWhenPaused
    end
    self.TalkContext.TalkStateManager:SetTalkStateByTag(Const.TalkState_DisableMonsterSpawn,true,self)
end
function TalkComp_PauseGame_C:Resume()
	EventManager:FireEvent(EventID.TalkResumeGame)
    self.TalkContext.TalkStateManager:SetTalkStateByTag(Const.TalkState_DisableMonsterSpawn,false,self)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self.TalkContext)
    if GameMode == nil then
        DebugPrint("Get GameMode failed...") -- use another assert?
        return
    end
    --GameMode:SetGamePaused(Const.Tag_GamePausedByTalk, false)
    local PC = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance,0)
    if IsValid(PC) then
        PC.bShouldPerformFullTickWhenPaused = self.OriFullTick or false
    end
end

---@class TalkComp_HideAllBattleEntity_C:TalkCompBase_C
local TalkComp_HideAllBattleEntity_C = CreateTalkComp()
---@param TalkContext BP_TalkContext_C
TalkComp_HideAllBattleEntity_C.New = function(TalkContext)
    local Obj = setmetatable({}, {
        __index = TalkComp_HideAllBattleEntity_C
    })
    ---@type BP_TalkContext_C
    Obj.TalkContext = TalkContext
    return Obj
end
function TalkComp_HideAllBattleEntity_C:GetType()
    return ETalkCompType.HideAllBattleEntity
end
function TalkComp_HideAllBattleEntity_C:Execute()
    self.TalkContext:SetAllBattleEntityHidden(true)
end
function TalkComp_HideAllBattleEntity_C:Resume()
    self.TalkContext:SetAllBattleEntityHidden(false)
end

---@class TalkComp_DisableInteractiveTrigger_C:TalkCompBase_C
local TalkComp_DisableInteractiveTrigger_C = CreateTalkComp()
---@param Player ACharacter
TalkComp_DisableInteractiveTrigger_C.New = function(Player)
    local Obj = setmetatable({}, {
        __index = TalkComp_DisableInteractiveTrigger_C
    })
    Obj.Player = Player
    return Obj
end
function TalkComp_DisableInteractiveTrigger_C:GetType()
    return ETalkCompType.DisableInteractiveTrigger
end
function TalkComp_DisableInteractiveTrigger_C:Execute()
    self.Player:SetCanInteractiveTrigger(false, "Talk")
end
function TalkComp_DisableInteractiveTrigger_C:Resume()
    self.Player:SetCanInteractiveTrigger(true, "Talk")
end

---@class TalkComp_HideElseCharacter_C:TalkCompBase_C
local TalkComp_HideElseCharacter_C = CreateTalkComp()
---@param Player ACharacter
TalkComp_HideElseCharacter_C.New = function(TalkContext, TalkActors)
    local Obj = setmetatable({}, {
        __index = TalkComp_HideElseCharacter_C 
    })
    Obj.TalkContext = TalkContext
    Obj.TalkActorIds = {}
    for _,ActorInfo in pairs(TalkActors or{})do
        local Id = ActorInfo.TalkActorId
        local Type = ActorInfo.TalkActorType
        if Type == "Npc" then
            Obj.TalkActorIds[Id] = Id
        end
    end
    Obj.bManualCall = true
    return Obj
end
function TalkComp_HideElseCharacter_C:GetType()
    return ETalkCompType.HideElseCharacter
end
function TalkComp_HideElseCharacter_C:Execute()
end
function TalkComp_HideElseCharacter_C:Resume()
end

---@class TalkComp_HideElseCharacter_C:TalkCompBase_C
local TalkComp_SoundEffect_C = CreateTalkComp()
---@param Player ACharacter
TalkComp_SoundEffect_C.New = function(TalkContext)
    local Obj = setmetatable({}, {
        __index = TalkComp_SoundEffect_C 
    })
    Obj.TalkContext = TalkContext
    return Obj
end

function TalkComp_SoundEffect_C:GetType()
    return ETalkCompType.SoundEffect
end

function TalkComp_SoundEffect_C:Execute()
    AudioManager(self.TalkContext):PlayUISound(nil, "event:/snapshot/ui/filter_talk_stage", "Talk_Stage_Snapshot", nil)
end

function TalkComp_SoundEffect_C:Resume()
    AudioManager(self.TalkContext):SetEventSoundParam(nil, "Talk_Stage_Snapshot", {ToEnd = 1})
end

local TalkComp_HideNpcHeadUI_C = CreateTalkComp()
TalkComp_HideNpcHeadUI_C.New = function(TalkContext)
    local Obj = setmetatable({}, {
        __index = TalkComp_HideNpcHeadUI_C
    })
    return Obj
end

function TalkComp_HideNpcHeadUI_C:GetType()
    return ETalkCompType.HideNpcHeadUI
end

function TalkComp_HideNpcHeadUI_C:Execute()
    local HeadUISubsystem = UNpcHeadUISubsystem.GetHeadUISubsystem(GWorld.GameInstance)
    if HeadUISubsystem then
        HeadUISubsystem:HideAllNpcHeadUI(true, "TalkComp")
    end
end

function TalkComp_HideNpcHeadUI_C:Resume()
    local HeadUISubsystem = UNpcHeadUISubsystem.GetHeadUISubsystem(GWorld.GameInstance)
    if HeadUISubsystem then
        HeadUISubsystem:HideAllNpcHeadUI(false, "TalkComp")
    end
end

return {
    ETalkCompType = ETalkCompType,
    TalkComp_HideGameUI_C = TalkComp_HideGameUI_C,
    TalkComp_DisableInput_C = TalkComp_DisableInput_C,
    TalkComp_PopMouse_C = TalkComp_PopMouse_C,
    TalkComp_StopPlayerAction_C = TalkComp_StopPlayerAction_C,
    TalkComp_PauseGame_C = TalkComp_PauseGame_C,
    TalkComp_HideAllBattleEntity_C = TalkComp_HideAllBattleEntity_C,
    TalkComp_DisableInteractiveTrigger_C = TalkComp_DisableInteractiveTrigger_C,
    TalkComp_HideElseCharacter_C = TalkComp_HideElseCharacter_C,
    TalkComp_SoundEffect_C = TalkComp_SoundEffect_C,
    TalkComp_HideNpcHeadUI_C = TalkComp_HideNpcHeadUI_C,
}
