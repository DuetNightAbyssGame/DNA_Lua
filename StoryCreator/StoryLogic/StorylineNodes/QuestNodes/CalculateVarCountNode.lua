local CalculateVarCountNode = Class('StoryCreator.StoryLogic.StorylineNodes.Questline.QuestNode')
local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"

function CalculateVarCountNode:Init()
	self.VarName = nil
    self.VarValue = 0
    self.CurVarValue = 0
end

function CalculateVarCountNode:Start(Context)
	self.Context = Context
	local Avatar = GWorld:GetAvatar()
	if Avatar then
		if Avatar.InSpecialQuest and ClientEventUtils:GetCurrentEvent() and ClientEventUtils:GetCurrentEvent().PreQuestChainId then
        	self.CurQuestChainId = ClientEventUtils:GetCurrentEvent().PreQuestChainId
		else
			self.CurQuestChainId = self.Context.QuestChainId
		end
		if Avatar.QuestChains[self.CurQuestChainId] then
			self.CurDoingQuestId = Avatar.QuestChains[self.CurQuestChainId].DoingQuestId
		else
			self.CurDoingQuestId = self.QuestId
		end
	end

	local StorySubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UStorySubsystem:StaticClass())
	self.CurVarValue = StorySubsystem:GetInt(self.VarName)
	EventManager:AddEvent(EventID.OnCalcVarChange, self, self.CalculateVar)
	self:CalculateVar(self.VarName, self.CurVarValue, self.CurVarValue)
end

function CalculateVarCountNode:CalculateVar(InKey, InOldValue, InNewValue)
	if InKey ~= self.VarName then
		return
	end
	self.CurVarValue = InNewValue
	local Avatar = GWorld:GetAvatar()
	if not Avatar then return end
	if self.IsOpen then
		Avatar:DoRefreshTaskItemUIInfo("Modify", nil, {self.CurVarValue, self.VarValue, self.CurQuestChainId, self.CurDoingQuestId, self})
	else
		local TaskInfo = {TaskChainId = self.CurQuestChainId, TaskId = self.CurDoingQuestId}
		Avatar:DoRefreshTaskItemUIInfo("Modify", TaskInfo, nil)
	end

	if self.CurVarValue == self.VarValue then
		self:FinishAction()
	end
end

function CalculateVarCountNode:OnChooseTrack()
	local Avatar = GWorld:GetAvatar()
	if not Avatar then return end
	if  self.IsOpen then
		Avatar:DoRefreshTaskItemUIInfo("Modify", nil, {self.CurVarValue, self.VarValue, self.CurQuestChainId, self.CurDoingQuestId, self})
	else
		local TaskInfo = {TaskChainId = self.CurQuestChainId, TaskId = self.CurDoingQuestId}
		Avatar:DoRefreshTaskItemUIInfo("Modify", TaskInfo, nil)
	end
end

function CalculateVarCountNode:OnCancelTrack()
end

function CalculateVarCountNode:FinishAction()
	self:Finish()
end

function CalculateVarCountNode:Clear()
	EventManager:RemoveEvent(EventID.OnCalcVarChange, self)
	local TaskUIObj = TaskUtils:GetTaskBarWidget()
    if TaskUIObj then
        TaskUIObj:ClearCurTaskBarExtraInfo()
    end
	TaskUtils:ClearQuestExtraInfo(self.CurQuestChainId, self.CurDoingQuestId, self.Key)
end

function CalculateVarCountNode:OnQuestlineFinish()
end

function CalculateVarCountNode:OnQuestlineSuccess()
end

function CalculateVarCountNode:OnQuestlineFail()
	local TaskUIObj = TaskUtils:GetTaskBarWidget()
    if TaskUIObj then
        TaskUIObj:ClearCurTaskBarExtraInfo()
    end
	TaskUtils:ClearQuestExtraInfo(self.CurQuestChainId, self.CurDoingQuestId, self.Key)
end

return CalculateVarCountNode