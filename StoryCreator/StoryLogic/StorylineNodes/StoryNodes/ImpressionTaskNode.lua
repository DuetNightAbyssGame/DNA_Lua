local Questline = require 'StoryCreator.StoryLogic.StorylineNodes.Questline.Questline'

local FImpressionTaskNode = Class('StoryCreator.StoryLogic.StorylineNodes.Storyline.StoryNode')

function FImpressionTaskNode:Start(Context, NodeId)
	self.Questline = Questline(self.Data, Context, self)

	-- local SaveNode = self:GetSaveNode(Context)
	-- if (SaveNode) then
	-- 	SaveNode.bSpecifyExecution = true
	-- 	NodeId = SaveNode.Key
	-- 	local LastNodeInfo = self.Questline:GetLastNodeInfo(SaveNode)
    --     while(LastNodeInfo)do
    --         if LastNodeInfo.Node.Type == "TalkNode" then
    --             if LastNodeInfo.Node.IsNpcNode then
    --                 SaveNode.IsNpcNode = true
    --                 SaveNode.NpcId = LastNodeInfo.Node.NpcId
    --                 break
    --             else
    --                 LastNodeInfo = self.Questline:GetLastNodeInfo(LastNodeInfo.Node)
    --             end
    --         else
    --             break
    --         end
    --     end
	-- end

	self.Questline:StartQuest(NodeId)
end

function FImpressionTaskNode:GetRunningNodeTableByType(NodeType, OutRunningNodeTable)
	if (self.Type == NodeType) then
		table.insert(OutRunningNodeTable, self)
	end

	if (self.Questline) then
		self.Questline:GetRunningNodeTableByType(NodeType, OutRunningNodeTable)
	end
end

return FImpressionTaskNode
