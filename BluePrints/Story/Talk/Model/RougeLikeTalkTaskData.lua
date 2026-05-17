local FTalkTaskDataBase = require "BluePrints.Story.Talk.Model.TalkTaskDataBase"

---@class FRougeLikeTalkTaskData : TalkTaskDataBase_C
---@field public bBlendDialogueCamera boolean
---@field public bSkipToOption boolean
local FRougeLikeTalkTaskData = {}

---@param TalkNodeData TalkNodeData
FRougeLikeTalkTaskData.New = function(TalkNodeData)
	local TalkTypeData = DataMgr.TalkType[TalkNodeData.TalkType]
	local ExtraParams = TalkTypeData.ExtraParams or {}

	DebugPrintTable(TalkNodeData)
	local Obj = FTalkTaskDataBase.New(TalkNodeData)
	Obj.bBlendDialogueCamera = ExtraParams.bBlendDialogueCamera
	Obj.bSkipToOption = TalkNodeData.SkipToOption
	return Obj
end

return FRougeLikeTalkTaskData
