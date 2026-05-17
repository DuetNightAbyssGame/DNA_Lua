local FlowDialogueData = require "BluePrints.Story.FlowGraph.FlowNode.TalkFlowNode.Dialogue.FlowDialogueData"
local FFlowDialogue = FlowDialogueData.FFlowDialogue

local FlowLogType = UE.EStoryLogType.TalkFlow

---@class DialogueLine_Sequence
---@field Driver DialogueDriver_Sequence
---@field Node any
---@field DialogueData table
---@field DialogueSetting table|nil
---@field DialogueId number|nil
---@field Next DialogueLine_Sequence|nil
---@field IterSection table|nil
---@field bPlayed boolean
---@field bFinish boolean
local DialogueLine_Sequence = {}
DialogueLine_Sequence.__index = DialogueLine_Sequence

---@param Driver DialogueDriver_Sequence
---@param DialogueData table
---@param DialogueSetting table|nil
---@return DialogueLine_Sequence
function DialogueLine_Sequence.New(Driver, DialogueData, DialogueSetting)
    local Obj = setmetatable({}, DialogueLine_Sequence)
    Obj.Driver = Driver
    Obj.Node = Driver.Node
    Obj.DialogueData = DialogueData
    Obj.DialogueSetting = DialogueSetting
    Obj.DialogueId = DialogueData and DialogueData.DialogueId
    Obj.Next = nil
    Obj.IterSection = nil
    Obj.bPlayed = false
    Obj.bFinish = false
    return Obj
end

---@return boolean
function DialogueLine_Sequence:BindDelegates()
    local Node = self.Node
    local RuntimeProxy = Node.RuntimeProxy
    local SequencePlayer = Node.SequencePlayer
    if not IsValid(RuntimeProxy) or not IsValid(SequencePlayer) then
        DebugPrint("WXT__DialogueLine_Sequence:BindDelegates", "Invalid", self.DialogueId)
        return false
    end
    if not self._OnSpecialDialoguePlay then
        self._OnSpecialDialoguePlay = function(_, Section)
            return self:OnSpecialDialoguePlay(Section)
        end
    end
    if not self._OnSpecialDialogueEnd then
        self._OnSpecialDialogueEnd = function(_, Section)
            return self:OnSpecialDialogueEnd(Section)
        end
    end
    if not self._OnSequencePause then
        self._OnSequencePause = function(_)
            return self:OnSequencePause()
        end
    end

    RuntimeProxy.OnSpecialDialoguePlay:Add(Node, self._OnSpecialDialoguePlay)
    RuntimeProxy.OnSpecialDialogueEnd:Add(Node, self._OnSpecialDialogueEnd)
    SequencePlayer.PauseAtFrameEvent:Add(Node, self._OnSequencePause)
    return true
end

function DialogueLine_Sequence:UnbindDelegates()
    local Node = self.Node
    local RuntimeProxy = Node.RuntimeProxy
    local SequencePlayer = Node.SequencePlayer
    if IsValid(RuntimeProxy) then
        if self._OnSpecialDialoguePlay then
            RuntimeProxy.OnSpecialDialoguePlay:Remove(Node, self._OnSpecialDialoguePlay)
        end
        if self._OnSpecialDialogueEnd then
            RuntimeProxy.OnSpecialDialogueEnd:Remove(Node, self._OnSpecialDialogueEnd)
        end
    end
    if IsValid(SequencePlayer) then
        if self._OnSequencePause then
            SequencePlayer.PauseAtFrameEvent:Remove(Node, self._OnSequencePause)
        end
    end
end

---@param NextLine DialogueLine_Sequence|nil
function DialogueLine_Sequence:CleanupForTransition(NextLine)
    local NextDialogueId = NextLine and NextLine.DialogueId
    self:UnbindDelegates()
end

---@param PrevDialogueId number|nil
---@return boolean
function DialogueLine_Sequence:Enter(PrevDialogueId)
    self.IterSection = nil
    self.bPlayed = false
    local Node = self.Node
    if not IsValid(Node.SequencePlayer) then
        DebugPrint("WXT__DialogueLine_Sequence:Enter", "SequencePlayer invalid", self.DialogueId)
        return false
    end
    if PrevDialogueId then
        DebugPrint("WXT__DialogueLine_Sequence:Enter", self.DialogueId, "Prev", PrevDialogueId)
        local DialogueFlowGraphComponent = self.Node:TryGetFlowGraphComponent()
        DialogueFlowGraphComponent:ForceCompleteDialogue(PrevDialogueId)
        Node.SequencePlayer:TryStopDialogueId(PrevDialogueId)
    end
    return Node.SequencePlayer:TryPlayToDialogueId(self.DialogueId) == true
end

---@param Section table|nil
function DialogueLine_Sequence:Play(Section)
    local Node = self.Node
    local DialogueFlowGraphComponent = Node:TryGetFlowGraphComponent()
    local DialogueRecordComponent = Node:TryGetRecordComponent()

    local FlowDialogue = FFlowDialogue.New(self.DialogueData, self.DialogueSetting, Section)
    FlowDialogue:BindOnForceCompleteDialogue(function(Id)
        self:OnDialogueForceToEnd(Id)
    end)
    FlowDialogue:BindOnDialogueFinish(function(Id)
        self:OnDialogueFinish(Id)
    end)
    if Section and Section.bAutoPlay then
        FlowDialogue:SetAutoToNext()
    end
    FlowDialogue:SetForbiddenDSL(true)
    FlowDialogue:SetWaitAsyncTag(true)
    FlowDialogue:SetOverrideDuration()

    DialogueFlowGraphComponent:PlayDialogue(FlowDialogue)
    DialogueRecordComponent:OnDialogueRecord(self.DialogueId, DataMgr.Dialogue[self.DialogueId])
    Node:TriggerNormalOutput(self.DialogueId)
    self.bPlayed = true
end

---@param Section table|nil
function DialogueLine_Sequence:OnSpecialDialoguePlay(Section)
    if not Section then
        return
    end
    if Section.DialogueId ~= self.DialogueId then
        DebugPrint("WXT__DialogueLine_Sequence:OnSpecialDialoguePlay", "Mismatch", self.DialogueId, Section.DialogueId)
        local Message = string.format("当前Dialogue节点，Sequence 回调 DialogueId %d 与当前句 %d 不同", Section.DialogueId or 0, self.DialogueId or 0)
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, FlowLogType, "Flow对话节点出错:SequenceIterForward", Message)
        return
    end
    if self.IterSection then
        local Message = string.format("当前Dialogue节点，Sequence 上句台本尚未结束 %d，就要播放下一句台本 %d",
            self.IterSection.DialogueId, Section.DialogueId)
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, FlowLogType, "Flow对话节点出错:SequenceIterForward", Message)
    end
    self.IterSection = Section
    self:Play(Section)
end

---@param DialogueId number
function DialogueLine_Sequence:OnSpecialDialogueEnd(Section)
    local DialogueId = Section.DialogueId
    if DialogueId ~= self.DialogueId then
        return
    end
    self.IterSection = nil
    local DialogueFlowGraphComponent = self.Node:TryGetFlowGraphComponent()
    DialogueFlowGraphComponent:ForceCompleteDialogue(DialogueId)
end

function DialogueLine_Sequence:OnSequencePause()
    self.bPlayed = false
    self.bFinish = true
    local DialogueFlowGraphComponent = self.Node:TryGetFlowGraphComponent()
    DialogueFlowGraphComponent:CompleteWaitSequence()
end

---@param DialogueId number
function DialogueLine_Sequence:OnDialogueFinish(DialogueId)
    if DialogueId ~= self.DialogueId then
        DebugPrint("WXT__DialogueLine_Sequence:OnDialogueFinish", "Mismatch", self.DialogueId, DialogueId)
        local Message = string.format("当前Dialogue节点OnDialogueFinish时 DialogueId %d 与回调 %d不同，请检查", self.DialogueId or 0, DialogueId or 0)
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, FlowLogType, "Flow对话节点出错:OnDialogueFinish", Message)
        return
    end
    self.Driver:OnLineFinished(self, "finish")
end

---@param DialogueId number
function DialogueLine_Sequence:OnDialogueForceToEnd(DialogueId)
    if DialogueId ~= self.DialogueId then
        DebugPrint("WXT__DialogueLine_Sequence:OnDialogueForceToEnd", "Mismatch", self.DialogueId, DialogueId)
        local Message = string.format("当前Dialogue节点OnDialogueForceToEnd时 DialogueId %d 与回调 %d不同，请检查", self.DialogueId or 0, DialogueId or 0)
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, FlowLogType, "Flow对话节点出错:OnDialogueForceToEnd", Message)
        return
    end
    if IsValid(self.Node.SequencePlayer) and not self.bFinish then
        self.Node.RuntimeProxy:EnterSkip()
        self.Node.SequencePlayer:SkipToDialogueEnd(DialogueId)
        self.Node.RuntimeProxy:ExitSkip()  -- 嵌套调用，正常退出（计数减一）
        self:OnSequencePause()
    end
    -- self.Driver:OnLineFinished(self, "force_end")
end

function DialogueLine_Sequence:SkipCurrent()
    if IsValid(self.Node.SequencePlayer) then
        self.Node.SequencePlayer:TrySkipToDialogueId(self.DialogueId)
    end
    local DialogueFlowGraphComponent = self.Node:TryGetFlowGraphComponent()
    DialogueFlowGraphComponent:SkipDialogue()
    self.Driver:OnLineFinished(self, "skip")
end

---@return boolean
function DialogueLine_Sequence:CanSkip()
    return true
end

function DialogueLine_Sequence:Pause()
    local DialogueFlowGraphComponent = self.Node:TryGetFlowGraphComponent()
    DialogueFlowGraphComponent:PauseDialogue()
    if IsValid(self.Node.SequencePlayer) then
        self.Node.SequencePlayer:Pause()
    end
end

function DialogueLine_Sequence:Resume()
    local DialogueFlowGraphComponent = self.Node:TryGetFlowGraphComponent()
    DialogueFlowGraphComponent:ResumeDialogue()
    if IsValid(self.Node.SequencePlayer) then
        self.Node.SequencePlayer:TryPlayToDialogueId(self.DialogueId)
    end
end

function DialogueLine_Sequence:Cleanup()
    self:UnbindDelegates()
end

return DialogueLine_Sequence
