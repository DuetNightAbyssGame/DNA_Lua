---@class BaseQuestNode: FQuestNode
-- 文档
-- https://herogames.feishu.cn/wiki/NlbBwXiQ0iWBUVkVn1IclFY4nff

local BaseQuestNode = Class('StoryCreator.StoryLogic.StorylineNodes.Questline.QuestNode')

function BaseQuestNode:Start()
	local ReturnValue = self:Execute()
    self:Finish(ReturnValue ~= nil and tostring(ReturnValue) or nil)
end

-----------------节点函数-----------------
function BaseQuestNode:Init()
end

function BaseQuestNode:Execute(Callback)
end

function BaseQuestNode:Clear()
end

function BaseQuestNode:OnQuestlineFinish()
end

function BaseQuestNode:OnQuestlineSuccess()
end

function BaseQuestNode:OnQuestlineFail()
end
-----------------节点函数-----------------

return BaseQuestNode