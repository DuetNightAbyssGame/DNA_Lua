local PlatformJudgmentNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode')

function PlatformJudgmentNode:Init()
	self.MobileName = "Mobile"
	self.PCName = "PC"
end

function PlatformJudgmentNode:Execute()
	local OutName = nil
	local PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self)
	if PlatformName == self.MobileName then
		OutName = self.MobileName
	elseif PlatformName == "PC" then
		OutName = self.PCName
	else
		assert(false, "PlatformName is not Mobile or PC")
	end
	return OutName
end

return PlatformJudgmentNode
