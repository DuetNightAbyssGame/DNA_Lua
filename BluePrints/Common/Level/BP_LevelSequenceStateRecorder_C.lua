--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
---@type GamePlay_StateRecorder_C
local M = Class("BluePrints.Common.TimerMgr")

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

function M:ReceiveBeginPlay()
    self.Overridden.ReceiveBeginPlay(self)
    self.PlayEndSequence = {}
    local GameMode = UGameplayStatics.GetGameMode(self)
    if GameMode then
        GameMode.LevelSequenceStateRecorders:Add(self.SubRegionId,self)
    end
    self:ClearBinding()
end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

function M:Active()
    self:ClearBinding()
    local Avatar = GWorld:GetAvatar()
    for UniqueId,Recorder in pairs(Avatar.LevelSequenceStateRecorder) do
        if Recorder.RegionId == self.SubRegionId then
            if Recorder.PlayState == ELevelSequenceRuntimeState.ERunning then
                DebugPrint('LevelStateRecorder','Recover,ERunning:',self.SubRegionId,Recorder.RecorderId,Recorder.SequenceState)
                self:PlaySequence_CPP(Recorder.RecorderId, Recorder.SequenceState, false, false, true)
            elseif Recorder.PlayState == ELevelSequenceRuntimeState.EComplete then
                DebugPrint('LevelStateRecorder','Recover,EComplete:',self.SubRegionId,Recorder.RecorderId,Recorder.SequenceState)
                self:PlaySequence_CPP(Recorder.RecorderId, Recorder.SequenceState, true, false, true)
                self.PlayEndSequence[Recorder.RecorderId] = Recorder.SequenceState
            end
        end
    end
end

function M:PlaySequence_Lua(Id, State, LevelSequenceActor, PlayToEnd, ForceFromStart)
    self.PlayEndSequence[Id] = nil
    local LableFrom, LableTo = nil
    if State.IsRevrse then
        LableFrom = State.MarkLableTo
        LableTo = State.MarkLableFrom
    else
        LableFrom = State.MarkLableFrom
        LableTo = State.MarkLableTo
    end
    if PlayToEnd then
        local PlaybackParams = FMovieSceneSequencePlaybackParams()
        PlaybackParams.MarkedFrame = LableTo
        PlaybackParams.UpdateMethod = EUpdatePositionMethod.Jump
        PlaybackParams.PositionType = EMovieScenePositionType.MarkedFrame
        LevelSequenceActor:GetSequencePlayer():SetPlaybackPosition(PlaybackParams)
    else
        self:ReportLevelSequenceState(Id, State.StateId, ELevelSequenceRuntimeState.ERunning)
        local PlaybackParams = FMovieSceneSequencePlaybackParams()
        PlaybackParams.PositionType = EMovieScenePositionType.MarkedFrame
        if ForceFromStart or State.RuntimeState ~= ELevelSequenceRuntimeState.ERunning then
            PlaybackParams.MarkedFrame = LableFrom
            PlaybackParams.UpdateMethod = EUpdatePositionMethod.Jump
            LevelSequenceActor:GetSequencePlayer():SetPlaybackPosition(PlaybackParams)
        end
        PlaybackParams.MarkedFrame = LableTo
        PlaybackParams.UpdateMethod = EUpdatePositionMethod.Play
        LevelSequenceActor:GetSequencePlayer():PlayTo(PlaybackParams)
        State.RuntimeState = ELevelSequenceRuntimeState.ERunning

        local UIManger = GWorld.GameInstance:GetGameUIManager()
        if State.HideUI then
            if UIManger then
                UIManger:HideAllUI_EX({}, true, Const.LevelSequenceStateRecorderTag)
            end
        end
        if State.DisableInput then
            local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
            PlayerCharacter:AddDisableInputTag(Const.LevelSequenceStateRecorderTag)
            -- if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
            --     local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
            --     local Params = FGameInputModeParams()
            --     Params.MouseLockMode = EMouseLockMode.LockAlways
            --     GameInputModeSubsystem:EnableInputMode(Const.LevelSequenceStateRecorderTag, EGameInputMode.UI, Params)
            -- else
            UIManger:SetUIInputEnable(false, Const.LevelSequenceStateRecorderTag)
            local BattleMain = UIManger:GetUI("BattleMain")
            if BattleMain then
                BattleMain:BlockAllUIInput_CPP(true, Const.LevelSequenceStateRecorderTag)
            end
            UGameplayStatics.GetGameMode(self):SetPlayerCharacterForceIdle(PlayerCharacter)
            -- end
        end
    end
end

function M:OnMarkedFrameEnd(Id, State, LevelSequenceActor, Action)
    if self.PauseTag then 
        return
    end
    local UIManger = GWorld.GameInstance:GetGameUIManager()
    if State.HideUI then
        if UIManger then
            UIManger:HideAllUI_EX({}, false, Const.LevelSequenceStateRecorderTag)
        end
    end
    if State.DisableInput then
        local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
        PlayerCharacter:RemoveDisableInputTag(Const.LevelSequenceStateRecorderTag)
        -- if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        --     local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
        --     GameInputModeSubsystem:DisableInputMode(Const.LevelSequenceStateRecorderTag)
        -- else
        UIManger:SetUIInputEnable(true, Const.LevelSequenceStateRecorderTag)
            local BattleMain = UIManger:GetUI("BattleMain")
            if BattleMain then
                BattleMain:BlockAllUIInput_CPP(false, Const.LevelSequenceStateRecorderTag)
            end
        -- end
    end
    DebugPrint('LevelStateRecorder','MarkedFrameEnd',self.SubRegionId,Id,State.StateId,State.IsLoop,State.AutoChangeState)
    if State.IsLoop then
        self:PlaySequence_Lua(Id, State, LevelSequenceActor, false, true)
    elseif State.AutoChangeState then
        State.RuntimeState = ELevelSequenceRuntimeState.EComplete
        self:ReportLevelSequenceState(Id, State.StateId, ELevelSequenceRuntimeState.EComplete)
    end
    if not State.IsLoop then
        self.PlayEndSequence[Id] = State.StateId
        if IsValid(Action) and Action.OnSequencePlayEnd then
            Action.OnSequencePlayEnd:Broadcast()
        end
    end
end

function M:ReportLevelSequenceState(RecroderId, StateId, State)
    local Avatar = GWorld:GetAvatar()
    for UniqueId,Recorder in pairs(Avatar.LevelSequenceStateRecorder) do
        if Recorder.RegionId == self.SubRegionId then
            if Recorder.RecorderId == RecroderId then
                if Recorder.SequenceState == StateId and Recorder.PlayState == State then
                    return
                else
                    break
                end
            end
        end
    end
    DebugPrint('LevelStateRecorder','Report',self.SubRegionId,RecroderId, StateId, State)
    Avatar:ReportLevelSequenceState(self.SubRegionId, RecroderId, StateId, State)
end

function M:AddBinding(LevelSequenceActor, LevelSequenceBindingParams, Id, StateId)
    local GameState = UGameplayStatics.GetGameState(self)
    for _,Param in pairs(LevelSequenceBindingParams:ToTable()) do
        local Creator = GameState.StaticCreatorMap:Find(Param.CreatorId)
        if Creator then
            local ChildEids = Creator:GetActorToChildEids():ToTable()
            if #ChildEids ~= 0 then
                local Entity = Battle(self):GetEntity(ChildEids[1])
                if IsValid(Entity) then
                    LevelSequenceActor:AddBindingByTag(Param.Tag, Entity, false)
                end
            end
            table.insert(self.BindingCreator, Creator)
            Creator.OnStaticCreatorChildReadyDelegate:Add(self,function(self,NewEntity)
                if IsValid(NewEntity) then
                    LevelSequenceActor:AddBindingByTag(Param.Tag, NewEntity, false)
                    if self.PlayEndSequence[Id] == StateId then--已经播放完毕则重新播最后一帧重置绑定的Actor的位置
                        self:PlaySequence_CPP(Id, StateId, true, false, true)
                    end
                end
            end)
        else
            GWorld.logger.error('LevelSequence AddBinding Error, Creator Not Found!!! Tag:', Param.Tag, "CreatorId:", Param.CreatorId)
        end
    end
end

function M:ClearBinding()
    if self.BindingCreator then
        for _, Creator in pairs(self.BindingCreator) do
            Creator.OnStaticCreatorChildReadyDelegate:Clear()
        end
    end
    self.BindingCreator = {}
end

return M
