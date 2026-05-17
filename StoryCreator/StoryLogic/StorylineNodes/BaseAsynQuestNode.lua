
-- 文档
-- https://herogames.feishu.cn/wiki/NlbBwXiQ0iWBUVkVn1IclFY4nff

local BaseAsynQuestNode = Class('StoryCreator.StoryLogic.StorylineNodes.Questline.QuestNode')

function BaseAsynQuestNode:Start(Context, InPortName)
	self.InPortName = InPortName

	self:Execute(function(ReturnValue)
		self:Finish(ReturnValue ~= nil and tostring(ReturnValue) or nil)
	end)
end

-----------------节点函数-----------------
function BaseAsynQuestNode:Init()
end

function BaseAsynQuestNode:Execute(Callback)
end

function BaseAsynQuestNode:Stop()
	self:Clear()
end

function BaseAsynQuestNode:Clear()
end

function BaseAsynQuestNode:OnQuestlineFinish()
end

function BaseAsynQuestNode:OnQuestlineSuccess()
end

function BaseAsynQuestNode:OnQuestlineFail()
end
-----------------节点函数-----------------

return BaseAsynQuestNode