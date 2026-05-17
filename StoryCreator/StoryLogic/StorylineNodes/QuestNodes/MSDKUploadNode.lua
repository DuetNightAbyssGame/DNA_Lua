

local MSDKUploadNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode')

function MSDKUploadNode:Execute()
	if not DataMgr.MSDKUploadInfo[self.EventName] then
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "MSDKUploadNode, EventName:[" .. tostring(self.EventName) .. "]填写出错，不在MSDKUploadInfo表里")
		return
	end
    local EMHeroUSDKSubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UEMHeroUSDKSubsystem:StaticClass())
	EMHeroUSDKSubsystem:MSDKUploadCommonEventByEventName(self.EventName)
end

return MSDKUploadNode