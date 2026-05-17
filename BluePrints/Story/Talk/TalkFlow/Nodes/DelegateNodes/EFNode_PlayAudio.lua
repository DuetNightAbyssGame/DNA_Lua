local M = {}

function M:CreateNode(Flow, Params)
	local VoiceName = Params.VoiceName
	
	local PlayAudioNode = Flow:CreateNode(UEFNode_Delegate)
	PlayAudioNode.DebugLog = string.format("PlayAudioNode VoiceName: %s, ", VoiceName)

	PlayAudioNode.OnStart:Add(PlayAudioNode, function(Node)
		Node:Finish({Node.FinishPin})
	end)


	PlayAudioNode.OnSkip:Add(PlayAudioNode, function(Node)
		Node:Finish({Node.FinishPin})
	end)

	return PlayAudioNode
end

return M
