local TalkOptionData_C = require"BluePrints.Story.Talk.Model.TalkOptionData".TalkOptionData_C
---@class TalkTaskDataBase_C
---@field public ExtraParams table
---@field public TalkContext BP_TalkContext_C
---@field public TalkId integer
---@field public FirstDialogueId integer
---@field public TalkType string
---@field public bNeedStage boolean
---@field public TalkStage ATalkStage
---@field public SequencePath string
---@field public BlendInTime number
---@field public BlendOutTime number
---@field public BlendInType string
---@field public BlendOutType string
---@field public bShowAutoPlayButton boolean
---@field public bShowSkipButton boolean
---@field public bPauseGameGlobal boolean
---@field public bDisableMonsterAI boolean
---@field public bDisableNPCAI boolean
---@field public bHideAllBattleEntity boolean
---@field public BeginTargetPoint ANewTargetPoint
---@field public EndTargetPoint ANewTargetPoint
---@field public CameraLookAtTartgetPoint string
---@field public RestoreStand boolean
---@field public Options table<number,string>
---@field public Player ACharacter
---@field public PlayerController APlayerController
---@field public bDisableGameInput boolean
---@field public bPopMouse boolean
---@field public bShowGameUI boolean
---@field public BasicTalkType string
---@field public bTaskDefaultAutoPlay boolean
---@field public CameraType string
---@field public UI BP_TalkBaseUINew_C
---@field public GuideMeshIndexList table<integer, integer>
---@field public ChapterId integer
---@field public bEnableRandomOption boolean
---@field public RandomOptionNum integer
---@field public SaveToServer boolean
---@field public OptionData TalkOptionData_C
---@field public bUseProceduralCamera boolean
---@field public ProceduralCameraId number
local TalkTaskDataBase_C = {}

-- Use Const.Talk_LevelSequenceActorPath instead
--local LevelSequenceActorClassName = "/Game/BluePrints/Story/Talk/Base/BP_TalkSequenceActor.BP_TalkSequenceActor_C"

---@param TalkNodeData TalkNodeData
TalkTaskDataBase_C.New = function(TalkNodeData)
    local TalkTypeData = DataMgr.TalkType[TalkNodeData.TalkType]
    local GameInstance = GWorld.GameInstance
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)

    ---@type TalkTaskDataBase_C
    local Obj = {}
    Obj.ExtraParams = TalkTypeData.ExtraParams or {}
    Obj.TalkContext = GameInstance:GetTalkContext()
    Obj.FilePath = TalkNodeData.FilePath
    Obj.TalkNodeId = TalkNodeData.TalkNodeId
    Obj.TalkId = TalkNodeData.TalkId
    Obj.FirstDialogueId = TalkNodeData.FirstDialogueId
    Obj.TalkType = TalkNodeData.TalkType
    Obj.bNeedStage = Obj.ExtraParams.bNeedStage
    if(Obj.bNeedStage) then
        Obj.TalkStage = Obj.TalkContext:GetStage(TalkNodeData.TalkStageName)
    end

    Obj.bHideNpcs = TalkNodeData.HideNpcs 
    Obj.bHideMonsters = TalkNodeData.HideMonsters 
    Obj.bDisableNpcOptimization = TalkNodeData.DisableNpcOptimization
    Obj.DoNotReceiveCharacterShadow = TalkNodeData.DoNotReceiveCharacterShadow
    Obj.SequencePath = TalkNodeData.ShowFilePath
    Obj.BlendInTime = TalkNodeData.BlendInTime
    Obj.BlendOutTime = TalkNodeData.BlendOutTime
    Obj.BlendInType = TalkNodeData.BlendInType
    Obj.BlendOutType = TalkNodeData.BlendOutType
    Obj.bShowAutoPlayButton = TalkNodeData.ShowAutoPlayButton
    Obj.bShowSkipButton = TalkNodeData.ShowSkipButton
    Obj.bShowReviewButton = TalkNodeData.ShowReviewButton
    Obj.bPauseGameGlobal= TalkNodeData.PauseGameGlobal
    Obj.bDisableMonsterAI = TalkNodeData.DisableMonsterAI 
    Obj.bDisableNPCAI= TalkNodeData.DisableNPCAI
    Obj.bHideAllBattleEntity = TalkNodeData.HideAllBattleEntity
    Obj.bDisableMonsterAIForSimpleTalk = TalkNodeData.DisableMonsterAIForSimpleTalk
    Obj.bHideElseCharacter = TalkNodeData.HideElseCharacter

    Obj.BeginTargetPoint = GameState:GetTargetPoint(TalkNodeData.BeginNewTargetPointName)
    Obj.EndTargetPoint = GameState:GetTargetPoint(TalkNodeData.EndNewTargetPointName)

    Obj.CameraLookAtTartgetPoint = TalkNodeData.CameraLookAtTartgetPoint
    if(TalkNodeData.CameraLookAtTartgetPoint == "") then
        Obj.CameraLookAtTartgetPoint = nil
    end
    Obj.RestoreStand = TalkNodeData.RestoreStand
    Obj.TalkActors = TalkNodeData.TalkActors
    Obj.Options = TalkNodeData.Options
    Obj.Player = UE.UGameplayStatics.GetPlayerCharacter(Obj.TalkContext, 0)
    Obj.PlayerController = UE.UGameplayStatics.GetPlayerController(Obj.TalkContext, 0)
    Obj.bDisableGameInput = not TalkTypeData.GameInput
    Obj.bPopMouse = TalkTypeData.UICanInteractive
    Obj.bShowGameUI = TalkTypeData.ShowGameUI
    Obj.bShowInStoryReview = TalkTypeData.ShowInStoryReview
    Obj.UIName = TalkTypeData.UIName
    Obj.BasicTalkType = TalkTypeData.BasicType
    Obj.bTaskDefaultAutoPlay = not TalkTypeData.UICanInteractive
    Obj.CameraType = TalkTypeData.CameraType
    Obj.UI = nil
    Obj.GuideMeshIndexList = TalkNodeData.GuideMeshIndexList
    Obj.ChapterId = 1001 -- TalkNodeData.ChapterId
    Obj.bEnableRandomOption = TalkNodeData.EnableRandomOption
    Obj.RandomOptionNum = TalkNodeData.RandomOptionNum
    Obj.SaveToServer = TalkNodeData.SaveToServer
    Obj.OptionData = TalkOptionData_C.New(TalkNodeData.OptionType,TalkNodeData)
    Obj.bUseProceduralCamera = TalkNodeData.UseProceduralCamera
    Obj.ProceduralCameraId = TalkNodeData.ProceduralCameraId
    Obj.IsPlayStartSound = TalkNodeData.IsPlayStartSound
    Obj.CameraBlendEaseExp = TalkNodeData.CameraBlendEaseExp or 2
    Obj.bHideEffectCreature = TalkNodeData.HideEffectCreature
    Obj.bOverrideFailBlend = TalkNodeData.bOverrideFailBlend
    Obj.FailOutType = TalkNodeData.FailOutType
    Obj.FailOutTime = TalkNodeData.FailOutTime
    Obj.bPauseNpcBT = TalkNodeData.PauseNpcBT

    -- Fade效果相关属性
    -- 结束对话时的黑屏淡入时间为固定1s，策划暂不关心此时间，固延续之前使用的1s
    Obj.FinishFadeInTime = 1
    -- 开始对话时的黑屏淡出时间为固定0.5s，策划暂不关心此时间，固延续之前使用的0.5s
    Obj.BeginFadeOutTime = 0.5

    return Obj
end

return TalkTaskDataBase_C

