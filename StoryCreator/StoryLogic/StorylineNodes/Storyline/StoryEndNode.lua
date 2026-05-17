




-------------------------End Event Node-----------------------------
local  StoryEndNode = Class('StoryCreator.StoryLogic.StorylineNodes.Node')
StoryEndNode.IsEndNode = true

function StoryEndNode:Start(Context)
	-- storyline 结束
	-- local QuestChainId = tonumber(Context.QuestChainId)
	-- local Avatar = GWorld:GetAvatar()
	-- local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	-- if QuestChainId > 0 and Avatar and GameMode then
	-- 	GWorld.UploadQuestChainData = true
	-- 	Avatar:QuestChainFinish(QuestChainId)
	-- 	-- NewRegionEnable
	-- 	GameMode:HandleQuestChainFinish(QuestChainId)
	-- 	GWorld.UploadQuestChainData = false
	-- end
	self:Finish()
end

return StoryEndNode