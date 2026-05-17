local EDialogueNodeType = require "BluePrints.Story.Talk.View.TalkUtils".EDialogueNodeType
local EDialogueIterType = require "BluePrints.Story.Talk.View.TalkUtils".EDialogueIterType
local FStoryIterationGraph = require "BluePrints.Story.StoryIteration.StoryIterationGraph"
local ReviewUtils = require"BluePrints.UI.WBP.StoryReview.StoryReviewUtils"

---@class FDialogueIterationComponent
---@field Dialogues table<string, any>
---@field InitialDialogueId integer
---@field TextDialogueData table<string, any>
---@field OptionDialogueData table<string, any>
---@field SelectedOptionIds table<string, boolean>
local FDialogueIterationComponent = {}

---@param Dialogues table<string, any>
---@param InitialDialogueId integer
---@return FDialogueIterationComponent
function FDialogueIterationComponent:New(Dialogues, InitialDialogueId, TalkTask)
	local DialogueIterationComponent = setmetatable({}, {
		__index = FDialogueIterationComponent
	})

	DialogueIterationComponent.TalkTask = TalkTask
	DialogueIterationComponent.TalkTaskData = TalkTask.TalkTaskData
	DialogueIterationComponent.DialogueRecordComponent = TalkTask.DialogueRecordComponent
	DialogueIterationComponent.FlowCompoent = TalkTask.DialogueFlowGraphComponent
	DialogueIterationComponent.bUseFlow = IsValid(TalkTask.TalkTaskData.FlowAsset)
	DialogueIterationComponent.bShowInStoryReview = TalkTask.TalkTaskData.bShowInStoryReview

	DialogueIterationComponent:Initialize(Dialogues, InitialDialogueId)
	return DialogueIterationComponent
end

---@param NewInitialDialogueId integer
function FDialogueIterationComponent:Initialize(Dialogues, InitialDialogueId)
	if (Dialogues == nil) then
		DebugPrint("Error: Dialogues is nil")
		return
	end

	self.Dialogues = Dialogues
	self.InitialDialogueId = InitialDialogueId
	self.StoryIterGraph = FStoryIterationGraph:New(Dialogues, InitialDialogueId, self.TalkTask)
end

function FDialogueIterationComponent:Start()
	if self.bUseFlow then
		self.FlowCompoent:Execute()
		return
	end
	if self:IsStart() and self.StoryIterGraph:GetRestartTag() then
		--若Graph中有RestartTag(当有印象检定失败时，用于直接定位到检定选项之前)，则快进到Tag指定的位置
		self:SkipToRestartTag()
	else
		--否则，正常开始对话
		local CurrentNode = self.StoryIterGraph:GetCurrentNode()
		if CurrentNode then
			CurrentNode:Execute()
		else
			DebugPrint("lhr@FDialogueIterationComponent:Start(),CurrentNode is nil")
		end
	end
end

function FDialogueIterationComponent:Pause()
	--TODO
	if self.bUseFlow then
		self.FlowCompoent:Pause()
		return
	end
	local CurrentNode = self.StoryIterGraph:GetCurrentNode()
	if CurrentNode then
		CurrentNode:Pause()
	else
		DebugPrint("lhr@FDialogueIterationComponent:Pause(),CurrentNode is nil")
	end
end

function FDialogueIterationComponent:Resume()
	if self.bUseFlow then
		self.FlowCompoent:Resume()
		return
	end
	local CurrentNode = self.StoryIterGraph:GetCurrentNode()
	if CurrentNode then
		CurrentNode:Resume()
	else
		DebugPrint("lhr@FDialogueIterationComponent:Start(),CurrentNode is nil")
	end
end

function FDialogueIterationComponent:Iterate(...)
	if self.bUseFlow then
		self.FlowCompoent:Iterate(...)
		return
	end
	self.StoryIterGraph:Iterate(...)
end

--- 看代码这个外面不会调用，先不实现FlowCompoent
function FDialogueIterationComponent:Skip()
	return self.StoryIterGraph:Skip()
end

-- function FDialogueIterationComponent:RecordOption(OptionData, bTalkOption)
-- 	DebugPrint("lhr@RecordOption", DataMgr.Dialogue[OptionData.SelectedOption].Content)
-- 	if OptionData then
-- 		self.StoryIterGraph:RecordOption(OptionData, bTalkOption)
-- 	end
-- end

-- function FDialogueIterationComponent:RecordCheckResult(CheckRes, CheckValue)
-- 	self.StoryIterGraph:RecordCheckResult(CheckRes, CheckValue)
-- end

---@return table<string, any>
function FDialogueIterationComponent:GetDialogue()
	if self.bUseFlow then
		return self.FlowCompoent:GetDialogue()
	end
	if (self:IsInText() == false) then
		return nil
	end
	return self.StoryIterGraph:GetCurrentNode().Dialogue
end

---@return table<integer, integer>
function FDialogueIterationComponent:GetSavedOptions()
	if self.bUseFlow then
		return self.FlowCompoent:GetSavedOptions()
	end
	if (self:IsInOption() == false) then
		return nil
	end

	local Node = self.StoryIterGraph:GetCurrentNode()
	if Node then
		return Node.LastSelectedId
	end
	return nil
end


---@return table<integer, integer>
function FDialogueIterationComponent:GetOptions()
	if self.bUseFlow then
		return self.FlowCompoent:GetOptions()
	end
	if (self:IsInOption() == false) then
		return nil
	end

	local Node = self.StoryIterGraph:GetCurrentNode()
	if Node then
		return Node:GetOptions()
	end
	return nil
end

--- 只有Cine在用，先不管Flow
function FDialogueIterationComponent:SkipToFinalOrOption()
	if (self:IsEnd()) then
		self:Initialize(self.Dialogues, self.InitialDialogueId)
		-- 跳过Start节点，进入第一个Dialogue节点
		self:Skip()
	end

	--while self.TextDialogueData and (self.TextDialogueData.NextDialogueId or self.TextDialogueData.FinalDialogueId) do
	while self:IsInText() and (self.StoryIterGraph:GetCurrentNode().NextDialogueId or self.StoryIterGraph:GetCurrentNode().FinalDialogue) do
		self:Skip()
	end
end

function FDialogueIterationComponent:SkipToEndOrOption()
	DebugPrint("lhr@SkipToEndOrOption")
	if self.bUseFlow then
		return self.FlowCompoent:SkipToEndOrOption()
	end
	--跳过到对话结束或选项
	local LastDialogue = nil
	while self:IsInText() do
		self:Skip()
	end
	self.TalkTask.UI:ToPageEnd()
	self:Start()
end

function FDialogueIterationComponent:SkipToEnd()
	DebugPrint("lhr@SkipToEnd")
	--跳过到对话结束，或首次进入印象选项
	if self.bUseFlow then
		return self.FlowCompoent:SkipToEnd()
	end
	while not self:IsEnd() do
		if not self:Skip() then
			break
		end
	end
	self.TalkTask.UI:ToPageEnd()
	self:Start()
end

function FDialogueIterationComponent:SkipToRestartTag()
	local RestartTag = self.StoryIterGraph:GetRestartTag()
	local CurrentDialogue = nil
	--跳过到RestartTag指向的Dialogue
	while not self:IsEnd() do
		CurrentDialogue = self:GetDialogue()
		if CurrentDialogue and CurrentDialogue.DialogueId == RestartTag then
			break
		end
		if not self:Skip() then
			break
		end
	end
	self.TalkTask.UI:ToPageEnd()
	self:Start()
end

function FDialogueIterationComponent:IsInImpression()
	local CurrentNode = self.StoryIterGraph:GetCurrentNode()
	return CurrentNode and CurrentNode.IsImpression
end

function FDialogueIterationComponent:IsInText()
	local CurrentNode = self.StoryIterGraph:GetCurrentNode()
	return CurrentNode and CurrentNode:GetType() == EDialogueNodeType.Dialogue
end

function FDialogueIterationComponent:IsInOption()
	local CurrentNode = self.StoryIterGraph:GetCurrentNode()
	return CurrentNode and CurrentNode:GetType() == EDialogueNodeType.Option
end

function FDialogueIterationComponent:IsStart()
	local CurrentNode = self.StoryIterGraph:GetCurrentNode()
	return CurrentNode and CurrentNode:GetType() == EDialogueNodeType.Start
end

function FDialogueIterationComponent:IsLastText()
	if not self:IsInText() then
		return false
	end
	local CurrentNode = self.StoryIterGraph:GetCurrentNode()
	local NextNode = CurrentNode:GetOutPort(EDialogueIterType.Out)
	if not NextNode then
		return false
	end
	return NextNode:GetType() == EDialogueNodeType.End
end

function FDialogueIterationComponent:IsLastAndOnlyOption()
	if not self:IsInOption() then
		return false
	end
	local Options = self:GetOptions()
	if not Options or #self:GetOptions() ~= 1 then
		return false
	end
	local CurrentNode = self.StoryIterGraph:GetCurrentNode()
	local NextNode = CurrentNode:GetOutPort(EDialogueIterType.Option..1)
	if not NextNode then
		return false
	end
	return NextNode:GetType() == EDialogueNodeType.End
end

function FDialogueIterationComponent:IsEnd()
	local CurrentNode = self.StoryIterGraph:GetCurrentNode()
	return CurrentNode and CurrentNode:GetType() == EDialogueNodeType.End
end

function FDialogueIterationComponent:IsOptionSelected(OptionId)
	if self.bUseFlow then
		return self.FlowCompoent:IsOptionSelected(OptionId)
	end
	local CurrentNode = self.StoryIterGraph:GetCurrentNode()
	if not CurrentNode or CurrentNode:GetType() ~= EDialogueNodeType.Option then
		return false
	end

	return CurrentNode:GetIsOptionSelected(OptionId)
end

function FDialogueIterationComponent:HasFinalDialogue()
	if self.bUseFlow then
		return self.FlowCompoent:HasFinalDialogue()
	end
	local CurrentNode = self.StoryIterGraph:GetCurrentNode()
	if not CurrentNode or CurrentNode:GetType() ~= EDialogueNodeType.Option then
		return false
	end
	return CurrentNode:HasFinalDialogue()
end

function FDialogueIterationComponent:GetCurrentNodeType()
	if self.bUseFlow then
		return self.FlowCompoent:GetCurrentNodeType()
	end
	return self.StoryIterGraph:GetCurrentNode().NodeType
end

-- function FDialogueIterationComponent:GetChain()
-- 	return self.StoryIterGraph.DialogueNodeChain
-- end

function FDialogueIterationComponent:ForceToDialogueEnd(bSkip)
	if self.bUseFlow then
		return self.FlowCompoent:ForceToDialogueEnd(bSkip)
	end
	-- body
end

return FDialogueIterationComponent
