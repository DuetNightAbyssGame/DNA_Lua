local TalkOptionData_C = require"BluePrints.Story.Talk.Model.TalkOptionData".TalkOptionData_C

local function GetSequence(SequencePath)
    local Sequence = UE4.LoadObject(SequencePath)
    if (Sequence) then
        return Sequence
    end

    local Avatar = GWorld:GetAvatar()

    local Gender = "F"
    if (Avatar and Avatar.Sex == 0) then
        Gender = "M"
    end

    local GenderSequencePath = SequencePath .. "_" .. Gender
    local GenderSequence = UE4.LoadObject(GenderSequencePath)
    if (GenderSequence) then
        return GenderSequence
    end

    local EXGender = "EF"
    if (Avatar and Avatar.WeitaSex == 0) then
        EXGender = "EM"
    end

    local EXGenderSequencePath = SequencePath .. "_" .. EXGender
    local EXGenderSequence = UE4.LoadObject(EXGenderSequencePath)
    if (EXGenderSequence) then
        return EXGenderSequence
    end

    local CombGenderSequencePath = SequencePath .. "_" .. Gender .. EXGender
    local CombGenderSequence = UE4.LoadObject(CombGenderSequencePath)
    if (CombGenderSequence) then
        return CombGenderSequence
    end

    return nil
end

local function AddExternTalkactors(TalkNodeData, ExternTalkActors, bUseExternActors)
    local TalkActors = {}
    local NativeTalkActors = {}

    if bUseExternActors then
        for _, TalkActor in pairs(ExternTalkActors) do
            NativeTalkActors[TalkActor.TalkActorId] = true
            table.insert(TalkActors, TalkActor)
        end

        if TalkNodeData.TalkActors then
            for _, TalkActor in pairs(TalkNodeData.TalkActors) do
                if not NativeTalkActors[TalkActor.TalkActorId] then
                    table.insert(TalkActors, TalkActor)
                end
            end
        end
    else
        if TalkNodeData.TalkActors then
            for _, TalkActor in pairs(TalkNodeData.TalkActors) do
                NativeTalkActors[TalkActor.TalkActorId] = true
                table.insert(TalkActors, TalkActor)
            end
        end

        for _, TalkActor in pairs(ExternTalkActors) do
            if not NativeTalkActors[TalkActor.TalkActorId] then
                table.insert(TalkActors, TalkActor)
            end
        end
    end

    TalkNodeData.TalkActors = TalkActors
end

local function AddLevelSequenceTalkActors(TalkNodeData)
    local Tags = UE4.TArray(UE4.FName)
    UTalkSequenceFunctionLibrary.GetLevelSequenceTags(TalkNodeData.Sequence, Tags)

    local LevelSequenceActorDatas = {}
    Tags = Tags:ToTable()
    for _, Tag in pairs(Tags) do
        local Id = tonumber(Tag)
        if (Id) then
            local Type = "Npc"
            if (Id == 0) then
                Type = "Player"
            end

            table.insert(LevelSequenceActorDatas, {
                TalkActorId = Id,
                TalkActorType = Type,
                TalkActorVisible = true
            })
        end
    end

    local NewActorDatas = {}
    local NativeTalkActorIds = {}
    if (TalkNodeData.TalkActors) then
        for _, TalkActor in pairs(TalkNodeData.TalkActors) do
            NativeTalkActorIds[TalkActor.TalkActorId] = true
            table.insert(NewActorDatas, TalkActor)
        end
    end

    for _, ActorData in pairs(LevelSequenceActorDatas) do
        if (not NativeTalkActorIds[ActorData.TalkActorId]) then
            table.insert(NewActorDatas, ActorData)
        end
    end

    TalkNodeData.TalkActors = NewActorDatas
end

local CommonTalkTaskData_C = {}

CommonTalkTaskData_C.New = function(TalkNodeData)
    local Obj = setmetatable({}, {
        __index = TalkNodeData
    })

    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)

    local TalkTypeData = DataMgr.TalkType[TalkNodeData.TalkType]
    Obj.SetPlayerInvincible = TalkTypeData.SetPlayerInvincible
    Obj.bDisableGameInput = not TalkTypeData.GameInput
    Obj.bExitOnline = true
    Obj.bPopMouse = TalkTypeData.UICanInteractive
    Obj.bShowGameUI = TalkTypeData.ShowGameUI
    Obj.bShowInStoryReview = TalkTypeData.ShowInStoryReview
    Obj.UIName = TalkTypeData.UIName
    Obj.BasicTalkType = TalkTypeData.BasicType
    Obj.bTaskDefaultAutoPlay = not TalkTypeData.UICanInteractive
    Obj.CameraType = TalkTypeData.CameraType
    Obj.ExtraParams = TalkTypeData.ExtraParams or {}

    local GameInstance = GWorld.GameInstance
    Obj.TalkContext = GameInstance:GetTalkContext()
    Obj.bNeedStage = Obj.ExtraParams.bNeedStage
    if(Obj.bNeedStage) then
        Obj.TalkStage = Obj.TalkContext:GetStage(TalkNodeData.TalkStageName)
    end

    Obj.bHideNpcs = TalkNodeData.HideNpcs 
    Obj.bHideMonsters = TalkNodeData.HideMonsters 
    Obj.bDisableNpcOptimization = TalkNodeData.DisableNpcOptimization
    Obj.bForceAutoPlay = TalkNodeData.ForceAutoPlay
    Obj.bShowAutoPlayButton = TalkNodeData.ShowAutoPlayButton
    Obj.bShowSkipButton = TalkNodeData.ShowSkipButton
    Obj.bShowReviewButton = TalkNodeData.ShowReviewButton
    Obj.bShowWikiButton = TalkNodeData.ShowWikiButton
    Obj.bPauseGameGlobal= TalkNodeData.PauseGameGlobal
    Obj.bDisableMonsterAI = TalkNodeData.DisableMonsterAI 
    Obj.bDisableNPCAI= TalkNodeData.DisableNPCAI
    Obj.bHideAllBattleEntity = TalkNodeData.HideAllBattleEntity
    Obj.bFreezeWorldComposition = TalkNodeData.FreezeWorldComposition
    Obj.bTravelFullLoadWorldComposition = TalkNodeData.bTravelFullLoadWorldComposition
    Obj.SwitchToMasterType = TalkNodeData.SwitchToMaster
    Obj.bHideElseCharacter = TalkNodeData.HideElseCharacter

    Obj.BeginTargetPoint = GameState:GetTargetPoint(TalkNodeData.BeginNewTargetPointName)
    Obj.EndTargetPoint = GameState:GetTargetPoint(TalkNodeData.EndNewTargetPointName)

    if (TalkNodeData.CameraLookAtTartgetPoint) and (TalkNodeData.CameraLookAtTartgetPoint ~= "") then
        Obj.CameraLookAtTartgetPoint = TalkNodeData.CameraLookAtTartgetPoint
    end

    Obj.Player = UE4.UGameplayStatics.GetPlayerCharacter(Obj.TalkContext, 0)
    Obj.PlayerController = UE4.UGameplayStatics.GetPlayerController(Obj.TalkContext, 0)

    Obj.ChapterId = 1001 -- TalkNodeData.ChapterId
    Obj.bEnableRandomOption = TalkNodeData.EnableRandomOption
    Obj.OptionData = TalkOptionData_C.New(TalkNodeData.OptionType,TalkNodeData)
    Obj.bUseProceduralCamera = TalkNodeData.UseProceduralCamera
    Obj.CameraBlendEaseExp = TalkNodeData.CameraBlendEaseExp or 2
    Obj.bHideEffectCreature = TalkNodeData.HideEffectCreature
    Obj.bBlendDialogueCamera = Obj.ExtraParams.bBlendDialogueCamera
    Obj.bSkipToOption = TalkNodeData.SkipToOption
    Obj.bIsPlayerTurnToNPC = TalkNodeData.IsPlayerTurnToNPC
    Obj.bIsNPCTurnToPlayer = TalkNodeData.IsNPCTurnToPlayer
    Obj.bShowInteractiveActor = true
    Obj.GuideTalkStyle = TalkNodeData.GuideTalkStyle
    Obj.BubblePlayType = TalkNodeData.BubblePlayType
    Obj.BubbleDelayLoopSeconds = TalkNodeData.BubbleDelayLoopSeconds
    Obj.bBubblePlayCDEnable = TalkNodeData.bBubblePlayCDEnable
    Obj.BubblePlayCD = TalkNodeData.BubblePlayCD
    Obj.AudioAttachActor = TalkNodeData.AudioAttachActor
    Obj.PlayDialogueCallBack = TalkNodeData.PlayDialogueCallBack
    Obj.bPauseNpcBT = TalkNodeData.PauseNpcBT

    Obj.QuestChainId = TalkNodeData.QuestChainId
    Obj.PlayerSwitchEmoIdle = TalkNodeData.PlayerSwitchEmoIdle

    --Sequence数据
    Obj.SequencePath = TalkNodeData.ShowFilePath
    if Obj.SequencePath and Obj.SequencePath~="" then
        local World = Obj.TalkContext:GetWorld()
        local LevelSequenceActorClass = Obj.TalkContext.LevelSequenceActorClass or UE4.LoadClass(Const.Talk_LevelSequenceActorPath)
        local DefaultTrans = UE4.UKismetMathLibrary.MakeTransform(UE4.FVector(0, 0, 0), UE4.FRotator(0, 0, 0), UE4.FVector(1, 1, 1))
        local SequenceActor = World:SpawnActor(LevelSequenceActorClass, DefaultTrans, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)

        local Sequence = GetSequence(Obj.SequencePath)
        if not Sequence then
            local Message = "找不到Sequence资源"..
            "\nSequence路径:"..Obj.SequencePath..
            "\n对话节点:"..tostring(TalkNodeData.Name)
            UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE4.EStoryLogType.Talk, "Seqeuence资源缺失/配置错误", Message)
        else
            --- 使用平台时间，避免卡顿导致的音画不同步（默认创建为Tick，走的引擎Tick时间，但是音频是另外的线程，可以视作平台时间）
            --- 大部分seq都锁了最大帧率，会默认变为平台时间，但少部分没有，这里统一改成平台时间（Platform）
            UE4.UMovieSceneSequenceExtensions.SetClockSource(Sequence, UE4.EUpdateClockSource.Platform)
            SequenceActor:SetSequence(Sequence)
            Obj.Sequence = Sequence
        end
        Obj.SequenceActor = SequenceActor
        Obj.SequencePlayer = Obj.SequenceActor.SequencePlayer
    end

    if TalkNodeData.FlowAssetPath and TalkNodeData.FlowAssetPath~= "" then
        local TS = TalkSubsystem()
        local FlowAsset = UE4.LoadObject(TalkNodeData.FlowAssetPath)
        if UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(TS) then
            local FlowEditorSubSystem = UEditorSubsystemBlueprintLibrary.GetEditorSubsystem(UFlowEditorSubSystem)
            FlowEditorSubSystem:CheckFlowAsset(FlowAsset)
        end
        if not FlowAsset then
            local Message = "找不到DialogueAsset资源"..
                "\nSequence路径:"..TalkNodeData.FlowAssetPath..
                "\n对话节点:"..tostring(TalkNodeData.Name)
            UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE4.EStoryLogType.TalkFlow, "DialogueAsset资源缺失/配置错误", Message)
        else
            if TS then
                Obj.FlowAsset = TS:CreateFlowTalkTask(TalkNodeData.FlowAssetPath, UE4.LoadObject(TalkNodeData.FlowAssetPath))
                Obj.FirstDialogueId = Obj.FlowAsset:GetFirstDialogueId()
                local TalkActors = Obj.FlowAsset:GetTalkActorData()
                AddExternTalkactors(Obj, TalkActors, Obj.bUseFlowAssetActors)
            end
        end
    end

    if Obj.BasicTalkType == "Black" then
        Obj.BlendInType = "FadeIn"
        Obj.BlendOutType = "FadeOut"
    end

    if (Obj.TalkType == "Cinematic") then
        AddLevelSequenceTalkActors(Obj)
    end

    -- Fade效果相关属性
    -- ScreenEffectDurationSeconds 屏幕效果持续时间为1s是设计，保证 FadeIn 之后的黑屏至少有1s
    -- FinishFadeInTime 结束对话时的黑屏淡入时间为固定1s，策划暂不关心此时间，固延续之前使用的1s
    -- BeginFadeOutTime 开始对话时的黑屏淡出时间为固定0.5s，策划暂不关心此时间，固延续之前使用的0.5s
    -- 白屏对话 CBT3 瞬切
    if (TalkNodeData.TalkType == "White") then
        Obj.ScreenEffectDurationSeconds = 0
        Obj.FinishFadeInTime = 0
        Obj.BeginFadeOutTime = 0
    else
        Obj.ScreenEffectDurationSeconds = 1
        Obj.FinishFadeInTime = 1
        Obj.BeginFadeOutTime = 0.5
    end

    if TalkNodeData.ShowFadeDetail then -- 支持开放自定义
        Obj.BeginFadeOutTime = TalkNodeData.StartFadeOutTime
        Obj.ScreenEffectDurationSeconds = TalkNodeData.StartScreenEffectDuration
        Obj.FinishFadeInTime = TalkNodeData.FinishFadeInTime
    end

    return Obj
end

return CommonTalkTaskData_C
