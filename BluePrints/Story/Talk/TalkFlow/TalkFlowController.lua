
---@class FTalkFlowController
local M = {}

function M:RegisterFlow(TalkFlow)
	if self.TalkFlow then
		self.TalkFlow:End()
	end
	self.TalkFlow = TalkFlow
end

function M:Start()
	local Flow = self.TalkFlow
	if not Flow then
		DebugPrint("FTalkFlowController:Start: Flow不存在")
		return
	end
	if Flow:IsStart() and Flow:GetRestartTag() then
		--若Graph中有RestartTag(当有印象检定失败时，用于直接定位到检定选项之前)，则快进到Tag指定的位置
		self:SkipToRestartTag()
	else
		--否则，正常开始对话
		Flow:Start()
	end
end

function M:Pause()
	local Flow = self.TalkFlow
	if not Flow then
		DebugPrint("FTalkFlowController:Pause: Flow不存在")
		return
	end
	Flow:Pause()
end

function M:Resume()
	local Flow = self.TalkFlow
	if not Flow then
		DebugPrint("FTalkFlowController:Resume: Flow不存在")
		return
	end
	Flow:Resume()
end

function M:Skip()
	local Flow = self.TalkFlow
	if not Flow then
		DebugPrint("FTalkFlowController:Skip: Flow不存在")
		return
	end
	return Flow:Skip()
end

--- 只有Cine在用，先不管Flow
function M:SkipToFinalOrOption()
	local Flow = self.TalkFlow
	if not Flow then
		DebugPrint("FTalkFlowController:SkipToFinalOrOption: Flow不存在")
		return
	end
	if (Flow:IsEnd()) then
		self:Initialize(Flow)
		-- 跳过Start节点，进入第一个Dialogue节点
		Flow:Skip()
	end

	--while self.TextDialogueData and (self.TextDialogueData.NextDialogueId or self.TextDialogueData.FinalDialogueId) do
	while Flow:IsInText() and (Flow:GetCurrentNode().NextDialogueId or Flow:GetCurrentNode().FinalDialogue) do
		Flow:Skip()
	end
end

function M:SkipToEndOrOption()
	--跳过到对话结束或选项
	local Flow = self.TalkFlow
	if not Flow then
		DebugPrint("FTalkFlowController:SkipToEndOrOption: Flow不存在")
		return
	end
	local LastDialogue = nil
	while Flow:IsInText() do
		Flow:Skip()
	end
	self.TalkTask.UI:ToPageEnd()
	Flow:Start()
end

function M:SkipToEnd()
	local Flow = self.TalkFlow
	if not Flow then
		DebugPrint("FTalkFlowController:SkipToEnd: Flow不存在")
		return
	end
	while not Flow:IsEnd() do
		if not Flow:Skip() then
			break
		end
	end
	self.TalkTask.UI:ToPageEnd()
	Flow:Start()
end

function M:SkipToRestartTag()
	local Flow = self.TalkFlow
	if not Flow then
		DebugPrint("FTalkFlowController:SkipToRestartTag: Flow不存在")
		return
	end
	local RestartTag = Flow:GetRestartTag()
	local CurrentDialogue = nil
	--跳过到RestartTag指向的Dialogue
	while not Flow:IsEnd() do
		CurrentDialogue = Flow:GetDialogue()
		if CurrentDialogue and CurrentDialogue.DialogueId == RestartTag then
			break
		end
		if not Flow:Skip() then
			break
		end
	end
	self.TalkTask.UI:ToPageEnd()
	Flow:Start()
end

function M:ForceToDialogueEnd(bSkip)
end

return M
