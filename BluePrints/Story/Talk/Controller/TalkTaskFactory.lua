---@class TalkTaskFactory
local TalkTaskFactory = {}

---@param TalkNodeData TalkNodeData
---@return TalkTaskBase_C
---@return TalkTaskDataBase_C
function TalkTaskFactory:CreateTalkTask(TalkNodeData)
    local TalkTypeData = DataMgr.TalkType[TalkNodeData.TalkType]
    local BasicTalkType = TalkTypeData.BasicType

    if  BasicTalkType== "Cinematic" or 
        BasicTalkType== "FreeSimple" or 
        BasicTalkType== "FixSimple" or
        BasicTalkType== "Impression" or
        BasicTalkType== "Black" then
        return self:CreateCommonTalkTask(TalkNodeData)
    elseif  BasicTalkType == "Guide" or
            BasicTalkType == "Audio" or
            BasicTalkType == "Boss" or
            BasicTalkType == "Bubble" then
        return self:CreateLightTalkTask(TalkNodeData)
    end

    DebugPrint("@@@ 创建TalkTask ", TalkNodeData.TalkType, BasicTalkType)

    local TalkTask_C = require ("BluePrints.Story.Talk.Controller."..BasicTalkType.. "TalkTask")
    local TalkTaskData_C = require ("BluePrints.Story.Talk.Model."..BasicTalkType.."TalkTaskData")

    local TalkTaskData = TalkTaskData_C.New(TalkNodeData)
    local TalkTask = TalkTask_C:New(TalkTaskData, TalkNodeData.TalkType)

    self:AttachCompsToTask(TalkTask, TalkTaskData, BasicTalkType)
    -- Bubble对话取消BlendFadeIn效果
    if TalkNodeData.TalkType == "Bubble" or 
       TalkNodeData.TalkType == "Guide" then
        TalkTaskData.BlendInType = nil
        TalkTaskData.BlendOutType = nil
    end

    -- 记录NodeName
    TalkTaskData.TalkNodeName = TalkNodeData.Name

    return TalkTask, TalkTaskData
end

function TalkTaskFactory:CreateCommonTalkTask(TalkNodeData)
    local TalkTypeData = DataMgr.TalkType[TalkNodeData.TalkType]
    local BasicTalkType = TalkTypeData.BasicType
    DebugPrint("@@@ 创建TalkTask ", TalkNodeData.TalkType, BasicTalkType)

    local TalkTask_C = nil
    local TalkTaskData_C = require ("BluePrints.Story.Talk.Model.CommonTalkTaskData")

    if BasicTalkType == "Cinematic" then
        TalkTask_C = require ("BluePrints.Story.Talk.Controller.NewCinematicTalkTask")
    else
        TalkTask_C = require ("BluePrints.Story.Talk.Controller.CommonTalkTask")
    end

    local TalkTaskData = TalkTaskData_C.New(TalkNodeData)
    local TalkTask = TalkTask_C:New(TalkTaskData, TalkNodeData.TalkType)
    TalkTaskData.TalkNodeName = TalkNodeData.Name

    return TalkTask, TalkTaskData
end

function TalkTaskFactory:CreateLightTalkTask(TalkNodeData)
    local TalkTypeData = DataMgr.TalkType[TalkNodeData.TalkType]
    local BasicTalkType = TalkTypeData.BasicType
    DebugPrint("@@@ 创建TalkTask ", TalkNodeData.TalkType, BasicTalkType)

    local TalkTask_C = nil
    local TalkTaskData_C = require ("BluePrints.Story.Talk.Model.CommonTalkTaskData")

    if BasicTalkType == "Bubble" then
        TalkTask_C = require ("BluePrints.Story.Talk.Controller.NewBubbleTalkTask")
    elseif BasicTalkType == "Audio" then
        TalkTask_C = require ("BluePrints.Story.Talk.Controller.NewAudioTalkTask")
    elseif BasicTalkType == "Boss" then
        TalkTask_C = require ("BluePrints.Story.Talk.Controller.NewBossTalkTask")
    else
        TalkTask_C = require ("BluePrints.Story.Talk.Controller.LightTalkTask")
    end

    local TalkTaskData = TalkTaskData_C.New(TalkNodeData)
    local TalkTask = TalkTask_C:New(TalkTaskData, TalkNodeData.TalkType)
    TalkTaskData.TalkNodeName = TalkNodeData.Name

    return TalkTask, TalkTaskData
end

---@param TalkTask TalkTaskBase_C
---@param TalkTaskData TalkTaskDataBase_C 
function TalkTaskFactory:AttachCompsToTask(TalkTask, TalkTaskData, TalkType)
    local TalkComps = require"BluePrints.Story.Talk.Controller.TalkComps"
    if (not TalkTaskData.bShowGameUI) then
        ---@type TalkComp_HideGameUI_C
        local TalkComp_HideGameUI_C = require"BluePrints.Story.Talk.Controller.TalkComps".TalkComp_HideGameUI_C
        local TalkComp_HideGame = TalkComp_HideGameUI_C.New(TalkTaskData.TalkContext)
        self:AttachCompToTask(TalkTask, TalkComp_HideGame)
    end
    if (TalkTaskData.bDisableGameInput) then
        ---@type TalkComp_DisableInput_C
        local TalkComp_DisableInput_C = require"BluePrints.Story.Talk.Controller.TalkComps".TalkComp_DisableInput_C
        local TalkComp_DisableInput = TalkComp_DisableInput_C.New(TalkTaskData.Player, TalkTaskData.PlayerController, TalkTaskData)
        self:AttachCompToTask(TalkTask, TalkComp_DisableInput)
    end
    if (TalkTaskData.bPopMouse) then
        ---@type TalkComp_PopMouse_C
        local TalkComp_PopMouse_C = require"BluePrints.Story.Talk.Controller.TalkComps".TalkComp_PopMouse_C
        local TalkComp_PopMouse = TalkComp_PopMouse_C.New(TalkTaskData.PlayerController, TalkTaskData)
        self:AttachCompToTask(TalkTask, TalkComp_PopMouse)
    end
    if (TalkTaskData.bDisableGameInput) and (TalkTaskData.bPlayerMove) then
        ---@type TalkComp_StopPlayerAction_C
        local TalkComp_StopPlayerAction_C =
            require"BluePrints.Story.Talk.Controller.TalkComps".TalkComp_StopPlayerAction_C
        local TalkComp_StopPlayerAction = TalkComp_StopPlayerAction_C.New(TalkTaskData.Player, TalkTaskData.TalkContext)
        self:AttachCompToTask(TalkTask, TalkComp_StopPlayerAction)
    end
    if (TalkTaskData.bPauseGameGlobal) then
        ---@type TalkComp_PauseGame_C
        local TalkComp_PauseGame_C = require"BluePrints.Story.Talk.Controller.TalkComps".TalkComp_PauseGame_C
        local TalkComp_PauseGame = TalkComp_PauseGame_C.New(TalkTaskData.TalkContext, TalkTaskData.bDisableMonsterAI,
            TalkTaskData.bDisableNPCAI)
        self:AttachCompToTask(TalkTask, TalkComp_PauseGame)
    end
    if (TalkTaskData.bDisableGameInput) then
        ---@type TalkComp_DisableInteractiveTrigger_C
        local TalkComp_DisableInteractiveTrigger_C =
            require"BluePrints.Story.Talk.Controller.TalkComps".TalkComp_DisableInteractiveTrigger_C
        local TalkComp_DisableInteractiveTrigger = TalkComp_DisableInteractiveTrigger_C.New(TalkTaskData.TalkContext.Player)
        self:AttachCompToTask(TalkTask, TalkComp_DisableInteractiveTrigger)
    end
    if(TalkTaskData.bHideAllBattleEntity) then
        ---@type TalkComp_HideAllBattleEntity_C
        local TalkComp_HideAllBattleEntity_C = 
            require "BluePrints.Story.Talk.Controller.TalkComps".TalkComp_HideAllBattleEntity_C
        local TalkComp_HideAllBattleEntity = TalkComp_HideAllBattleEntity_C.New(TalkTaskData.TalkContext)
        self:AttachCompToTask(TalkTask, TalkComp_HideAllBattleEntity)
    end
    if(TalkTaskData.bHideElseCharacter) then
        ---@type TalkComp_HideElseCharacter_C
        local TalkComp_HideElseCharacter_C = 
            require "BluePrints.Story.Talk.Controller.TalkComps".TalkComp_HideElseCharacter_C
        local TalkComp_HideElseCharacter = TalkComp_HideElseCharacter_C.New(TalkTaskData.TalkContext, TalkTaskData.TalkActors)
        self:AttachCompToTask(TalkTask, TalkComp_HideElseCharacter)
    end

    if (TalkTaskData.bDisableGameInput) then
        local SoundEffect = TalkComps.TalkComp_SoundEffect_C.New(TalkTaskData.TalkContext)
        self:AttachCompToTask(TalkTask, SoundEffect)
    end
    if (TalkTaskData.bHideNpcHeadUI) then
        local HideNpcHeadUI = TalkComps.TalkComp_HideNpcHeadUI_C.New(TalkTaskData.TalkContext)
        self:AttachCompToTask(TalkTask, HideNpcHeadUI)
    end

end

function TalkTaskFactory:AttachCompToTask(TalkTask, TalkComp)
    DebugPrint("Attach prop to task", TalkTask, TalkComp)
    local TalkCompType = TalkComp:GetType()
    TalkTask.TalkComps[TalkCompType] = TalkComp
end

return TalkTaskFactory
