local TalkUtils = require "BluePrints.Story.Talk.View.TalkUtils"
local DefaultAllowClickTime = 1

---@class DialogueDataBase_C
---@field public Scripts string
---@field public DialogueId integer
---@field public TalkActorData TalkActorData_C
---@field public TalkActorName string
---@field public Content string
---@field public bHasTalkActionData boolean
---@field public AudioGUID string
---@field public VoiceName string
---@field public DisableMouth int
---@field public Duration number
---@field public LookAtType string
---@field public DialoguePanelType string
local DialogueDataBase_C = {}

---@param DialogueId integer
---@param DialogueData table
---@param TalkContext BP_TalkContext_C
DialogueDataBase_C.New = function(TalkTask, DialogueId, DialogueData, TalkContext)
    ---@type DialogueDataBase_C
    TalkContext = GWorld.GameInstance:GetTalkContext()
    local Obj = {}
    Obj.Scripts = DialogueData.Scripts
    Obj.FinalCameraInfo = DialogueData.FinalCamera
    Obj.CameraBlendCurve = DialogueData.CameraBlendCurve
    Obj.DialogueId = DialogueId
    Obj.TalkActorData = TalkContext:GetTalkActorData(TalkTask, DialogueData.SpeakNpcId)
    Obj.TalkActorName = GText(DialogueData.SpeakNpcName)
    Obj.TalkActorId = DialogueData.SpeakNpcId
    Obj.Content = TalkUtils:DialogueIdToContent(DialogueId) or " "
    Obj.AudioGUID = DialogueData.GUID
    Obj.VoiceName = DialogueData.VoiceName
    Obj.DisableMouth = DialogueData.DisableMouth
    Obj.Duration = DialogueData.Duration or 1
    Obj.LookAtType = DialogueData.DefaultLookAt
    Obj.DialoguePanelType = DialogueData.DialoguePanelType
    Obj.ShowStoryContent = TalkUtils:TryResolveStoryPanel(DialogueData.DialoguePanelType)
    Obj.HeadIconType = DialogueData.HeadIconType
    Obj.GuideFacialId = DialogueData.GuideFacialId
    Obj.ExStoryInfo = DialogueData.ExStoryInfo
    return Obj
end

---@class SimpleDialogueData_C : DialogueDataBase_C
---@field public CameraInfo string
---@field public FinalCameraInfo string
---@field public CameraTransform string
---@field public CameraBlendTime number
---@field public DialogueGraphPath string
---@field public AnimPath string
---@field public GuidemanConfigId number
---@field public GuidemanExpressionId string
---@field public GuidemanActionId string
local SimpleDialogueData_C = {}

---@param DialogueId number
---@param TalkContext BP_TalkContext_C
SimpleDialogueData_C.New = function(TalkTask, DialogueId, TalkContext)
    local DialogueData = DataMgr.Dialogue[DialogueId]
    if not DialogueData then
        local Message = "DialogueId在Dialogue表中不存在"..
        "\nDialogueId:"..tostring(DialogueId)
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Talk, "SimpleDialogueData创建失败：DialogueId不存在", Message)
        return 
    end
    ---@type SimpleDialogueData_C
    local Obj = DialogueDataBase_C.New(TalkTask, DialogueId, DialogueData, TalkContext)
    Obj.CameraInfo = DialogueData.Camera
    Obj.FinalCameraInfo = DialogueData.FinalCamera
    Obj.ToFinalCameraBlendTime = DialogueData.ToFinalCameraBlendTime or 0 
    Obj.CameraTransform = DialogueData.CameraTransform
    Obj.CameraBlendTime = DialogueData.BlendTime or 0
    Obj.DialogueGraphPath = DialogueData.GraphPath
    Obj.AnimPath = DialogueData.AnimPath
    Obj.GuidemanConfigId = DialogueData.GuidemanConfigId
    Obj.GuidemanExpressionId = DialogueData.GuidemanFacialId
    Obj.GuidemanActionId = DialogueData.GuidemanActionId
    Obj.bIsBlack = DialogueData.IsBlack == 1 and true or false
    Obj.AllowClickTime = DefaultAllowClickTime
    if DialogueData.bNotRecall ~= nil then
        Obj.bNotRecall = DialogueData.bNotRecall == 1
    end
    if TalkTask.DialogueFlowGraphComponent then
        TalkTask.DialogueFlowGraphComponent:InitSimpleDialogueData(Obj)
    end
    return Obj
end

---@class CinematicDialogueData_C : DialogueDataBase_C
---@field public Subtitle string
local CinematicDialogueData_C = {}

---@param DialogueId number
---@param TalkContext BP_TalkContext_C
CinematicDialogueData_C.New = function(TalkTask, DialogueId, TalkContext)
    local DialogueData = DataMgr.Dialogue[DialogueId]
    assert(DialogueData, "Can't find dialogue data from dialogue id: " .. DialogueId)

    ---@type CinematicDialogueData_C
    local Obj = DialogueDataBase_C.New(TalkTask, DialogueId, DialogueData, TalkContext)

    local WildcardSubsystem = UWildcardGameInstanceSubsystem.GetSubsystem(GWorld.GameInstance)
    if (not WildcardSubsystem) then
        DebugPrint("Error: Can't find WildcardSubsystem, create CinematicDialogueData_C failed.")
        return Obj
    end

    Obj.Subtitle = WildcardSubsystem:ReplaceWildcard(DialogueData.Subtitle)
    return Obj
end

return {
    DialogueDataBase_C = DialogueDataBase_C,
    SimpleDialogueData_C = SimpleDialogueData_C,
    CinematicDialogueData_C = CinematicDialogueData_C,
}
