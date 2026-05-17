local M = {}

local ETalkNodeFinishType = require 'StoryCreator.StoryLogic.StorylineUtils'.ETalkNodeFinishType

local Int2Str = {
	[1] = "Out",
	[2] = "Option",
	[3] = "Fail"
}

function M:CreateNode(Flow, TalkTask, Params)
	local FinishType = Params.FinishType
	local OptionIdx = Params.OptionIdx
	local OutportName

	local SetOutportNode = Flow:CreateNode(UEFNode_Delegate)
	SetOutportNode.DebugLog = string.format("SetOutport PortName: %s", OutportName)

	SetOutportNode.OnStart:Add(SetOutportNode, function(Node)
		if not FinishType then
			DebugPrint("Error: TalkDSL SetOutport Func FinishType is Empty!")
			Node:Finish({ Node.FinishPin })
			return
		end
		if FinishType == "Out" or Int2Str[FinishType] == "Out" then
			OutportName = ETalkNodeFinishType.Out
		elseif FinishType == "Fail" or Int2Str[FinishType] == "Fail" then
			OutportName = ETalkNodeFinishType.Fail
		elseif FinishType == "Option" or Int2Str[FinishType] == "Option" then
			OutportName = ETalkNodeFinishType.Option
			if not OptionIdx then
				DebugPrint("Error: TalkDSL SetOutport 重载出口类型为选项，但未填写OptionIdx")
				Node:Finish({ Node.FinishPin })
				return
			end
		end
		if not OutportName then
			DebugPrint("Error: TalkDSL SetOutport Func OutportName is Empty!")
			Node:Finish({ Node.FinishPin })
			return
		end
		TalkTask:SetOutport(OutportName, OptionIdx)
		Node:Finish({ Node.FinishPin })
	end)

	return SetOutportNode
end

return M
