local M = {}
local ScriptLogType = UE.EStoryLogType.Script

function M:CreateNode(Flow, TalkTask, Params)
	local DialogueId = Flow.DialogueId
	local TalkTaskData = TalkTask.TalkTaskData
	local QuestChainId = TalkTaskData.QuestChainId
	local VarName = Params.Name
	local VarValue = Params.Value

	if not VarName or VarName == "" then
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType, "SetVar脚本出错: VarName为空", "没有填写VarName, DialogueId:" .. tostring(DialogueId) .. ",请策划排查.")
        return
    end
    
    local VarInfo = DataMgr.StoryVariable[VarName]
    if not VarInfo then
        local _Str = "变量:[" .. tostring(VarName) .. "]需要现在StoryVariable.xlsx中先声明"
        if QuestChainId and QuestChainId ~= 0 then
            _Str = _Str .. ",QuestChainId:[" .. tostring(QuestChainId) .. "]"
        end
        _Str = _Str .. ",DialogueId:" .. tostring(DialogueId) .. ",请策划排查."
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType, "SetVar脚本出错: StoryVariable表中未找到变量", _Str)
        return
    end

    if VarInfo.QuestChainId and VarInfo.QuestChainId ~= QuestChainId then
        local _Str = "变量:[" .. tostring(VarName) .. "]不能在QuestChain:[" .. tostring(QuestChainId) .. "]中使用！表里填里它只支持在QuestChain:[" .. tostring(VarInfo.QuestChainId) .. "]中使用！"
        _Str = _Str .. ",DialogueId:" .. tostring(DialogueId) .. ",请策划排查."
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, ScriptLogType, "SetVar脚本错误: 需在对应QuestChain中", _Str)
        return
    end

	local SetVarNode = Flow:CreateNode(UEFNode_Delegate)
	SetVarNode.DebugLog = string.format("SetVar Name: %s, Value: %s", VarName, VarValue)

	SetVarNode.OnStart:Add(SetVarNode, function(Node)
		local StorySubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UStorySubsystem:StaticClass())
	    StorySubsystem:SetInt(VarName, VarValue)
	    Node:Finish({ Node.FinishPin })
	end)

	SetVarNode.OnSkip:Add(SetVarNode, function(Node)
		Node:Finish({ Node.FinishPin })
	end)

	return SetVarNode
end

return M
