local FlowLogType = UE.EStoryLogType.TalkFlow
local DialogueLine_Pure = require "BluePrints.Story.FlowGraph.FlowNode.TalkFlowNode.Dialogue.DialogueLine_Pure"

---@alias DialogueLineFinishReason "finish"|"force_end"|"skip"|"enter_fail"

---@class DialogueDriver_Pure
---@field Node any
---@field DialogueTables table[]|nil
---@field DialogueSettingsTable table|nil
---@field Lines DialogueLine_Pure[]|nil
---@field FirstLine DialogueLine_Pure|nil
---@field ActiveLine DialogueLine_Pure|nil
local PureDriver = {}
PureDriver.__index = PureDriver

---@param Node any
---@return DialogueDriver_Pure
function PureDriver.New(Node)
    local Obj = setmetatable({}, PureDriver)
    Obj.Node = Node
    Obj.DialogueTables = nil
    Obj.DialogueSettingsTable = nil
    Obj.Lines = nil
    Obj.FirstLine = nil
    Obj.ActiveLine = nil
    return Obj
end

function PureDriver:BuildLines()
    local Node = self.Node
    self.DialogueSettingsTable = Node.DialogueSetting:ToTable()
    self.DialogueTables = Node.DialogueData:ToTable()

    local Lines = {}
    for _, DialogueData in ipairs(self.DialogueTables) do
        local DialogueId = DialogueData and DialogueData.DialogueId
        local Setting = DialogueId and self.DialogueSettingsTable[DialogueId] or nil
        table.insert(Lines, DialogueLine_Pure.New(self, DialogueData, Setting))
    end

    for i = 1, #Lines do
        Lines[i].Next = Lines[i + 1]
    end

    self.Lines = Lines
    self.FirstLine = Lines[1]
end

function PureDriver:Start()
    self:BuildLines()
    DebugPrint("WXT__DialogueDriver_Pure:Start", "LineCount", self.Lines and #self.Lines or -1, "First", self.FirstLine and self.FirstLine.DialogueId)
    self:ActivateLine(self.FirstLine)
end

---@param Line DialogueLine_Pure|nil
function PureDriver:ActivateLine(Line)
    self.ActiveLine = Line
    if not Line then
        DebugPrint("WXT__DialogueDriver_Pure:ActivateLine", "Finish")
        self.Node:FinishDialogue()
        return
    end
    return Line:Enter()
end

---@param CurrentLine DialogueLine_Pure|nil
---@param Reason DialogueLineFinishReason
---@return DialogueLine_Pure|nil
function PureDriver:ScheduleNextLine(CurrentLine, Reason)
    return CurrentLine and CurrentLine.Next or nil
end

---@param CurrentLine DialogueLine_Pure
---@param Reason DialogueLineFinishReason
function PureDriver:OnLineFinished(CurrentLine, Reason)
    local NextLine = self:ScheduleNextLine(CurrentLine, Reason)
    DebugPrint("WXT__DialogueDriver_Pure:OnLineFinished", CurrentLine and CurrentLine.DialogueId, Reason, "Next", NextLine and NextLine.DialogueId)
    return self:ActivateLine(NextLine)
end

function PureDriver:Skip()
    local Node = self.Node
    local FlowAsset = Node:GetFlowAsset()
    FlowAsset:CloseTalkActorsOptimization()

    local StopDialogueId
    if FlowAsset and FlowAsset.bIsInRestartDialogueSkip then
        StopDialogueId = FlowAsset.RestartDialogueId
    end

    local Line = self.ActiveLine
    DebugPrint("WXT__DialogueDriver_Pure:Skip", "Start", Line and Line.DialogueId, "Stop", StopDialogueId)
    while Line do
        if StopDialogueId and Line.DialogueId == StopDialogueId then
            break
        end
        Line:SkipCurrent()
        Line = self.ActiveLine
    end
    DebugPrint("WXT__DialogueDriver_Pure:Skip", "End", self.ActiveLine and self.ActiveLine.DialogueId)
end

---@return boolean
function PureDriver:CanSkip()
    if self.ActiveLine and self.ActiveLine.CanSkip then
        return self.ActiveLine:CanSkip()
    end
    return true
end

function PureDriver:Pause()
    if self.ActiveLine and self.ActiveLine.Pause then
        return self.ActiveLine:Pause()
    end
end

function PureDriver:Resume()
    if self.ActiveLine and self.ActiveLine.Resume then
        return self.ActiveLine:Resume()
    end
end

function PureDriver:Cleanup()
    if self.ActiveLine and self.ActiveLine.Cleanup then
        self.ActiveLine:Cleanup()
    end
    self.ActiveLine = nil
end

return PureDriver
