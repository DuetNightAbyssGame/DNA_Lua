local M = Class('StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode')
local QuestLogType = UE.EStoryLogType.Quest

function M:Init()
	self.TagName = nil
	self.TagValue = 0
end

function M:Execute()
	if (not self.TagName or self.TagName == "") then
		local Message = string.format("SetStoryOptimizeTagNode节点出错, 没有填写TagName, TagValue, FileName: %s, NodeKey: %s, 请策划排查.", self.Context.FileName, self.Key)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, QuestLogType, "SetStoryOptimizeTagNode节点出错", Message)
		return
	end

	local VarData = DataMgr.StoryVariable[self.TagName]
	if (not VarData) then
		local Message = string.format("标记名:[%s]需要在 StoryVariable.xlsx 中声明, FileName: %s, NodeKey: %s, 请策划排查.", self.TagName, self.Context.FileName, self.Key)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, QuestLogType, "SetStoryOptimizeTagNode节点出错", Message)
		return
	end

	if (not VarData.IsGlobal) then
		local Message = string.format("变量:[%s]必须是全局变量, FileName: %s, NodeKey: %s, 请策划排查.", self.TagName, self.Context.FileName, self.Key)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, QuestLogType, "SetStoryOptimizeTagNode节点出错", Message)
		return
	end

	local StorySubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UStorySubsystem:StaticClass())
	StorySubsystem:SetOptimizeTag(self.TagName, self.TagValue)
end

return M
