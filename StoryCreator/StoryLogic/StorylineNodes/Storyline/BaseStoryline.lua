---@class BaseStoryline
local BaseStoryline = Class('StoryCreator.StoryLogic.StorylineNodes.NodeObject')

-- ---@param Payload table<string, any>
function BaseStoryline:Init(...)
	self.Nodes = {}
end

-- 维护开始结束节点

function BaseStoryline:GetStartNode()
	return self._StartNode
end

function BaseStoryline:SetStartNode(Node)
	self._StartNode = Node
end

function BaseStoryline:GetEndNode()
	return self._EndNode
end

function BaseStoryline:SetEndNode(Node)
	self._EndNode = Node
end

function BaseStoryline:GetSuccessNode()
	return self._SuccessNode
end

function BaseStoryline:SetSuccessNode(Node)
	self._SuccessNode = Node
end

function BaseStoryline:GetFailNode()
	return self._FailNode
end

function BaseStoryline:SetFailNode(Node)
	self._FailNode = Node
end
-- 维护开始结束节点

-- 维护所有子Node的引用
function BaseStoryline:AddNode(Key, Value)
	self.Nodes[Key] = Value
end

function BaseStoryline:RemoveNode(Key)
	self.Nodes[Key] = nil
end

function BaseStoryline:GetNode(Key)
	-- PrintTable({GetNode=1,Key=Key, Nodes = self.Nodes},2)
	return self.Nodes[Key]
end

function BaseStoryline:GetNodes()
	return self.Nodes
end
-- 维护所有子Node的引用


-- 维护子Node的邻接表
function BaseStoryline:RemoveUnreachableNode()
	local OpenList = {}
	local CanReachNodes = {}

	local StartNode = self:GetStartNode()
	CanReachNodes[StartNode.NodeId] = 1
	table.insert(OpenList, StartNode)

	-- PrintTable({S=#OpenList})
	while #OpenList > 0 do
		local Node = table.remove(OpenList)
		local PortNameToNodeInfoList = self:GetNextNodeInfoList(Node)
		if PortNameToNodeInfoList then
			for _, NextNodeInfoList in pairs(PortNameToNodeInfoList) do
				for _, NextNodeInfo in ipairs(NextNodeInfoList) do
					local NextNode = NextNodeInfo.Node
					if not CanReachNodes[NextNode.NodeId] then
						CanReachNodes[NextNode.NodeId] = 1
						table.insert(OpenList, NextNode)
					end
				end
			end
		end
	end

	local CanNotReachNodes = {}
	for NodeId, _ in pairs(self:GetNodes()) do
		if not CanReachNodes[NodeId] then
			CanNotReachNodes[NodeId] = 1
		end
	end

	-- PrintTable({CanNotReachNodes=CanNotReachNodes,CanReachNodes=CanReachNodes},3,"CanNotReachNodes")
	for NodeId, _ in pairs(CanNotReachNodes) do
		self:RemoveNode(NodeId)
	end
end

function BaseStoryline:BuildAdjacencyMap(ALlLineData, StartNodeName, EndNodeName)
	-- PrintTable({ALlLineData=ALlLineData},4,"ALlLineData")
	self.AdjacencyMap = {}

	for _, LineData in pairs(ALlLineData) do
		local StartNodeKey = LineData[StartNodeName]
		local StartNode = self:GetNode(StartNodeKey)
		local StartPortName = LineData.startPort
		local EndNodeKey = LineData[EndNodeName]
		local EndNode = self:GetNode(EndNodeKey)
		local EndPortName = LineData.endPort
		-- PrintTable({StartNodeKey, StartPortName, EndNodeKey, EndPortName})
		self:ConnectNode(StartNode, StartPortName, EndNode, EndPortName)
	end

	self:RemoveUnreachableNode()
end

function BaseStoryline:ConnectNode(StartNode, StartPortName, EndNode, EndPortName)
	self.AdjacencyMap[StartNode] = self.AdjacencyMap[StartNode] or {}
	if not self.AdjacencyMap[StartNode][StartPortName] then
		self.AdjacencyMap[StartNode][StartPortName] = {}
	end
	table.insert(self.AdjacencyMap[StartNode][StartPortName], {Node = EndNode, InPortName = EndPortName})
end

function BaseStoryline:GetNextNodeInfoList(Node)
	-- PrintTable({SSS=1,Node=Node,OutPortName=OutPortName})
	-- PrintTable({SSS=1,R1=self.AdjacencyMap},3)
	-- PrintTable({SSS=1,R2=self.AdjacencyMap[Node]},3)
	-- PrintTable({SSS=1,R3=self.AdjacencyMap[Node][OutPortName]},3)
	return self.AdjacencyMap and self.AdjacencyMap[Node]
end

--获取任意一个输入节点，使用场景目前仅在上下线进印象对话，因此实时查询
function BaseStoryline:GetLastNodeInfo(QuestNode)
	local AllLineData = self:GetAllLineData()
	for _, LineData in pairs(AllLineData) do
		local EndNodeKey = LineData["endQuest"]
		local EndNode = self:GetNode(EndNodeKey)
		if EndNode == QuestNode then
			local StartNodeKey = LineData["startQuest"]
			local StartNode = self:GetNode(StartNodeKey)
			local StartPortName = LineData.startPort
			return {Node = StartNode, OutPortName = StartPortName}
		end
	end
	return
end


function BaseStoryline:GetNextNodeInfoListByPortName(QuestNode, OutPortName)
	-- PrintTable({SSS=1,QuestNode=QuestNode,OutPortName=OutPortName})
	-- PrintTable({SSS=1,R1=self.AdjacencyMap},3)
	-- PrintTable({SSS=1,R2=self.AdjacencyMap[QuestNode]},3)
	-- PrintTable({SSS=1,R3=self.AdjacencyMap[QuestNode][OutPortName]},3)
	return self.AdjacencyMap and self.AdjacencyMap[QuestNode] and self.AdjacencyMap[QuestNode][OutPortName]
end
-- 维护子Node的邻接表

function BaseStoryline:GetRunningNodeTableByType(NodeType, OutRunningNodeTable)
	for _, Node in pairs(self.RunningNodeList) do
		Node:GetRunningNodeTableByType(NodeType, OutRunningNodeTable)
	end
end

function BaseStoryline:GetAllLineData()
	return {}
end

return BaseStoryline
