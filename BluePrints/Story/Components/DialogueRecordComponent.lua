
local TalkUtils = require "BluePrints.Story.Talk.View.TalkUtils"
local ReviewUtils = require"BluePrints.UI.WBP.StoryReview.StoryReviewUtils"
local ImpressionTypes = require"BluePrints.UI.UI_PC.Impression.ImpressionConst".ImpressionTypes
local ETalkType = require"BluePrints.Story.Talk.Base.ETalkType"

local FDialogueRecordComponent = {}
function FDialogueRecordComponent:New(TalkTask, TalkTaskData)
    local DialogueRecordComponent = setmetatable({}, {
        __index = FDialogueRecordComponent
    })
    DialogueRecordComponent:Initialize(TalkTask, TalkTaskData)
    return DialogueRecordComponent
end
local DialogueNodeChain = {}
function FDialogueRecordComponent:Initialize(TalkTask, TalkTaskData)
    self.bShowInStoryReview = TalkTaskData.bShowInStoryReview
    self.DialogueNodeChain = DialogueNodeChain
    self.TalkTask = TalkTask
    self.TalkTaskData = TalkTaskData
    self.BasicTalkType = TalkTask:GetBasicTalkType()
    self.PlayDialogueCallBack = TalkTaskData.PlayDialogueCallBack --- @todo 想办法迭代掉
    if self.bShowInStoryReview then
		ReviewUtils.ClearAllReviewData(self.TalkTaskData.QuestChainId)
	end
end

function FDialogueRecordComponent:IsBlack()
    return self.BasicTalkType == ETalkType.Black
end

function FDialogueRecordComponent:RecordOption(OptionData)
    DebugPrint("lhr@RecordOption", DataMgr.Dialogue[OptionData.SelectedOption].Content)
	if not OptionData then
        return
		-- if self.PlayDialogueCallBack and self.PlayDialogueCallBack.Func then
		-- 	self.PlayDialogueCallBack.Func(self.PlayDialogueCallBack.Obj, OptionData.SelectedOption)
		-- end
	end
    local DialogueData = DataMgr.Dialogue[OptionData.SelectedOption]
    if OptionData.bImpression then
        local OptionType = OptionData.OptionType
        local ImpressionId = DialogueData["Impr"..OptionType.."Id"]
        local OptionInfo = DataMgr["Impression"..OptionType][ImpressionId]
        local ImpressionConfigId, OptionValue = "Common", 0
        for _, ImpressionType in pairs(ImpressionTypes) do
            OptionValue = OptionInfo[ImpressionType .. OptionType]
            if OptionValue > 0 then
                --获取五维属性名
                ImpressionConfigId = ImpressionType
                break
            end
        end
        --检定选项
		if OptionData.OptionType == "Check" then
			local AreaId = OptionInfo.RegionId
			local Avatar = GWorld:GetAvatar()
			if not Avatar then
				DebugPrint("FStoryIterationGraph@RecordOption时，Avatar不存在")
				return
			end
			local ImpressionInfo = Avatar:GetRegionImpression(AreaId)
			local PlayerValue = ImpressionInfo:GetImpressionValueByType(ImpressionConfigId)

			self.CheckHandle = ReviewUtils.AddOptionWithImpressionCheck(ImpressionConfigId, PlayerValue, OptionData.Options, OptionData.SelectedOption, OptionData.VisitedOptions)
		--加值选项
		elseif OptionData.OptionType == "Plus" then
			if ImpressionConfigId ~= "Common" then
				ReviewUtils.AddOptionWithImpressionValue(ImpressionConfigId, OptionValue, OptionData.Options, OptionData.SelectedOption, OptionData.VisitedOptions)
			else
				ReviewUtils.AddOptionWithNormal(OptionData.Options, OptionData.SelectedOption, OptionData.VisitedOptions)
			end
		end
        -- if bTalkOption then
        --     self:RecordChain(OptionData.SelectedOption)
        -- end
    else
        --普通选项
		ReviewUtils.AddOptionWithNormal(OptionData.Options, OptionData.SelectedOption, OptionData.VisitedOptions)
    end
end

function FDialogueRecordComponent:OnOptionRecord(OptionId, OptionData, NotRecordChain)
    if self.PlayDialogueCallBack and self.PlayDialogueCallBack.Func then
        self.PlayDialogueCallBack.Func(self.PlayDialogueCallBack.Obj, OptionId)
    end
    if OptionData.bImpression and not NotRecordChain then
        self:RecordChain(OptionId)
    end
    if not self.bShowInStoryReview then return end
    self:RecordOption(OptionData)
end


function FDialogueRecordComponent:OnDialogueRecord(DialogueId, DialogueData)
    if self.PlayDialogueCallBack and self.PlayDialogueCallBack.Func then
        self.PlayDialogueCallBack.Func(self.PlayDialogueCallBack.Obj, DialogueId)
    end
    if not self.bShowInStoryReview then return end
    if not DialogueData then return end
    local Content = TalkUtils:DialogueIdToContent(DialogueId)
    if not Content or Content == " " then return end
    DebugPrint("lhr@RecordDialogue", UWildcardGameInstanceSubsystem.GetSubsystem(GWorld.GameInstance):ReplaceWildcard(Content))
	if self:IsBlack() then
		ReviewUtils.AddDialogueDataWithBlackScreen(DialogueId)
	else
		local TalkContext = GWorld.GameInstance:GetTalkContext()
		local NpcId = DialogueData.SpeakNpcId
		local NpcName = DialogueData.SpeakNpcName
		if not NpcName and NpcId then
			local TalkActorData = TalkContext:GetTalkActorData(self.TalkTask, NpcId)
		    if TalkActorData then
		        NpcName = TalkUtils:GetTalkActorName(TalkActorData.TalkActorType, TalkActorData.TalkActorId)
		    else
                NpcName = TalkUtils:GetTalkActorName("Npc", NpcId)
		    end
		end
		if not NpcName or NpcName == "" then
			ReviewUtils.AddDialogueDataWithTalk(DialogueId)
		else
			NpcName = GText(NpcName)
			ReviewUtils.AddDialogueDataWithTalk(DialogueId, NpcName)
		end
	end
	if self.PlayDialogueCallBack and self.PlayDialogueCallBack.Func then
		self.PlayDialogueCallBack.Func(self.PlayDialogueCallBack.Obj, DialogueId)
	end
end

function FDialogueRecordComponent:OnTalkStart(FirstDialogueId)
    local DialogueId = FirstDialogueId
    if DataMgr.DialogueCurrentNode2PreNode[DialogueId] then
        DialogueNodeChain = {}
        self.DialogueNodeChain = DialogueNodeChain
        self:RecordChain(FirstDialogueId)
    end
end



function FDialogueRecordComponent:RecordCheckResult(CheckRes, CheckValue)
    if self.CheckHandle then
		self.CheckHandle:InsertCheckData(CheckRes, CheckValue)
	end
end

function FDialogueRecordComponent:RecordChain(DialogueId)
    table.insert(self.DialogueNodeChain, DialogueId)
end

function FDialogueRecordComponent:GetChain()
    return self.DialogueNodeChain
end



return FDialogueRecordComponent