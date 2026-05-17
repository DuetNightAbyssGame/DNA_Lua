local ETalkNodeFinishType = require 'StoryCreator.StoryLogic.StorylineUtils'.ETalkNodeFinishType
local EDialogueNodeType = require "BluePrints.Story.Talk.View.TalkUtils".EDialogueNodeType
local EDialogueIterType = require "BluePrints.Story.Talk.View.TalkUtils".EDialogueIterType

local FOptionNode = Class({"BluePrints.Story.StoryIteration.StoryIterationNode"})

FOptionNode.NodeType = EDialogueNodeType.Option

function FOptionNode:CreateNodeData(DialogueId)
	local Dialogue = self.Dialogues[DialogueId]
	local Avatar = GWorld:GetAvatar()

	self.IsImpression = false
	self.OptionType = nil

	local Options = {}
	local OptionId2Index = {}
	local LastSelectedId = {}
	local NextDialogueMap = {}
	local FailDialogueMap = {}
	local NextOptions = Dialogue.NextOptions
	for Index, OptionId in ipairs(NextOptions) do
		local OptionDialogue = self.Dialogues[OptionId]
		if (OptionDialogue == nil) then
			local Message = "OptionDialogue不存在, DialogueId为 "..OptionId
		    local Title = "OptionDialogue不存在"
		    UStoryLogUtils.PrintToFeiShu(self, UE.EStoryLogType.Talk, Title, Message)
			goto continue
		end
		OptionId2Index[OptionId] = Index
		if not self.IsImpression then
			if (OptionDialogue.ImprPlusId or OptionDialogue.ImprCheckId) then
				self.IsImpression = true
				if OptionDialogue.ImprPlusId then
					self.OptionType = "Plus"
				elseif OptionDialogue.ImprCheckId then
					self.OptionType = "Check"
				end
			end
		end
		if self.IsImpression then
			--若上次印象成功了，记录上次选择的选项
			if Avatar and Avatar:IsImpressionCheckSuccess(OptionId) then
				table.insert(LastSelectedId, OptionId)
			end
		end
		table.insert(Options, OptionId)
		NextDialogueMap[OptionId] = OptionDialogue.NextDialogue
		FailDialogueMap[OptionId] = OptionDialogue.FailDialogue
		::continue::
	end

	--若上次印象失败了，记录RestartTag指向的Dialogue
	if self.IsImpression then
		if not next(LastSelectedId) and Dialogue.RestartTag then
	    	for _, OptionId in pairs(Options) do
				if Avatar and Avatar:IsImpressionCheckFailure(OptionId) then
					self.IterGraph:SetRestartTag(Dialogue.RestartTag)
					break
		        end
		    end
		end
	else
	--若某个普通选项后有记录过的印象选项，则只显示该普通选项
		local Option2ImprData = DataMgr.DialogueOptionNode2ImprNode[DialogueId]
		if Option2ImprData then
			for ImpressionDialogueId, AvailableOptions in pairs(Option2ImprData) do
				if not self:IsImpressionSuccess(ImpressionDialogueId) then
					goto continue1
				end
				if AvailableOptions.Count == #Options then
					break
				end
				for OptionId, _ in pairs(AvailableOptions) do
					if OptionId ~= "Count" then
						table.insert(LastSelectedId, OptionId)
					end
				end
				::continue1::
			end
		end
	end

	self.Options = Options
	self.NextOptions = NextOptions
	self.OptionId2Index = OptionId2Index
	self.LastSelectedId = LastSelectedId
	self.NextDialogueMap = NextDialogueMap
	self.FailDialogueMap = FailDialogueMap
	self.FinalDialogue = Dialogue.FinalDialogueId
	self.bForbidSkip = Dialogue.bForbidSkipOptions
	if(Dialogue.RandomOptionNum and Dialogue.RandomOptionNum > 0) then
		self.RandomOptionNum = Dialogue.RandomOptionNum
	end

	self.VisitedOptions = {}

	--将自身记录在Graph中，防止递归
	self.IterGraph.OptionNodeMap[DialogueId] = self
end

function FOptionNode:GenerateNextNodes()
	for Index, OptionId in ipairs(self.Options) do
		-- 建立每个选项对应的台本节点并连接
		if self.NextDialogueMap[OptionId] then
			local NextNode = self.IterGraph:GetOrCreateNode("Dialogue", self.NextDialogueMap[OptionId])
			self:SetOutPort(EDialogueIterType.Option..Index, NextNode)
		else
			--如果选项的 NextDialogue 为空，则直接连接至End节点，结束对话
			local NextNode = self.IterGraph:GetOrCreateNode("End")
			self:SetOutPort(EDialogueIterType.Option..Index, NextNode)
		end
		
		-- （印象系统）建立每个选项失败后的台本节点并连接
		if self.FailDialogueMap[OptionId] then
			local NextNode = self.IterGraph:GetOrCreateNode("Dialogue", self.FailDialogueMap[OptionId])
			self:SetOutPort(EDialogueIterType.Fail..Index, NextNode)
		else
			local NextNode = self.IterGraph:GetOrCreateNode("End")
			self:SetOutPort(EDialogueIterType.Fail..Index, NextNode)
		end

		-- 建立所有选项遍历完后才会显示的FinalDialogue对应的节点
		if self.FinalDialogue then
			local NextNode = self.IterGraph:GetOrCreateNode("Dialogue", self.FinalDialogue)
			self:SetOutPort(EDialogueIterType.Final, NextNode)
		end
	end
end

function FOptionNode:Execute(bSkip)
	-- DebugPrint("lhr@Execute: OptionNode")
	if bSkip then
		return
	end
	local Options = self:GetOptions()
    self.TalkTask:ShowDialogueOptions(Options)
end

function FOptionNode:GetOptions()
	local ValidOptions = {}
	for _, OptionId in pairs(self.Options) do
		if self.IterGraph.TalkTriggerComponent:CheckDialogueCondition(OptionId) then
			table.insert(ValidOptions, OptionId)
		end
	end
	if(self.RandomOptionNum) then
		--随机选项模式下不记录已选择选项
		self.VisitedOptions = {}
		local RandomOptions = {}
        local FinialOptionNum = math.min(#ValidOptions,self.RandomOptionNum)
        for i=1,FinialOptionNum do
            local RandomIndex = math.random(1,#ValidOptions)
            local RandOption = ValidOptions[RandomIndex]
            table.insert(RandomOptions, RandOption)
            table.remove(ValidOptions, RandomIndex)
        end
        ValidOptions = RandomOptions
   	end
   	--配置了FinalDialogue时，阅读过的选项置底
	if self.FinalDialogue then
		local FinalOptions = {}
		local ReadOptions = {}
		for _, OptionId in ipairs(ValidOptions) do
			if not self.VisitedOptions[OptionId] then
				table.insert(FinalOptions, OptionId)
			else
				table.insert(ReadOptions, OptionId)
			end
		end
		if #ReadOptions > 0 then
			for _, OptionId in ipairs(ReadOptions) do
				table.insert(FinalOptions, OptionId)
			end
		end
		ValidOptions = FinalOptions
	end
	return ValidOptions
end

function FOptionNode:IsImpressionSuccess(DialogueId)
	local Avatar = GWorld:GetAvatar()
	if not Avatar then 
		return false 
	end
	local DialogueData = DataMgr.Dialogue[DialogueId]
	if not DialogueData then 
		return false 
	end
	local OptionData = DialogueData.NextOptions or DialogueData.TalkOptions
	if not OptionData then 
		return false 
	end
	for _, OptionId in ipairs(OptionData) do
		if Avatar:IsImpressionCheckSuccess(OptionId) then
			return true
        end
	end
	return false
end

function FOptionNode:GetIsOptionSelected(OptionId)
	return self.VisitedOptions[OptionId]
end

function FOptionNode:HasFinalDialogue()
	return self.FinalDialogue ~= nil
end

function FOptionNode:RealSkip()
	DebugPrint("FOptionNode@RealSkip", self.LastSelectedId, self.bForbidSkip, self.IterGraph:GetRestartTag())
	if self.bForbidSkip and not self.IterGraph:GetRestartTag() then
		return EDialogueIterType.Out, true
	end
	local OutPortName = EDialogueIterType.Out
	local SelectedId = nil
	local bSkipFail = false
	--若已有存储过的选项，默认选择上次选择的选项
	if next(self.LastSelectedId) ~= nil then
		SelectedId = self.LastSelectedId[1]
    else
		if self.IsImpression then
	        --若是第一次进入印象选项，则停止跳过
			bSkipFail = true
		else
			--若是普通选项，默认选择第一项
			local Options = self:GetOptions()
			for _, OptionId in pairs(Options) do
				if not self.VisitedOptions[OptionId] then
					SelectedId = OptionId
					break
				end
			end
		end
	end
	if SelectedId then
		self:Record(SelectedId, true)
		self:SelectOption(SelectedId)
		OutPortName = self:CalcOutPortName(SelectedId)
		self.TalkTask:SkipOption(SelectedId)
	end
	return OutPortName, bSkipFail
end

function FOptionNode:Skip()
	local OutPortName, bSkipFail = self:RealSkip()
	local NextNode = self:GetOutPort(OutPortName)
	if NextNode then
		NextNode:Enter(true)
	end
	return bSkipFail
end

function FOptionNode:Iterate(...)
	local Index, FinishType = ...
	self:Record(Index)
	self:SelectOption(Index)
	local OutPortName = self:CalcOutPortName(Index, FinishType)
	FOptionNode.Super.Iterate(self, OutPortName)
end

function FOptionNode:SelectOption(Index)
	Index = self.OptionId2Index[Index] or Index
	--DebugPrint("lhr@VisitedOption", self.Options[Index])
	self.VisitedOptions[self.Options[Index]] = true

	--如果还未显示FinalDialogue
	if self.FinalDialogue and not self.OverriddenNode then
		local AllVisited = true
		for _, OptionId in pairs(self.Options) do
			if not self.VisitedOptions[OptionId] then
				AllVisited = false
				break
			end
		end
		--当所有选项都阅读完时，显示FinalDialogue
		if AllVisited then
			self.OverriddenNode = self.NextNodeMap[EDialogueIterType.Final]
		end
	end
end

function FOptionNode:CalcOutPortName(Index, FinishType)
	Index = self.OptionId2Index[Index] or Index
	if FinishType == ETalkNodeFinishType.Fail then
		return EDialogueIterType.Fail..Index
	else
		return EDialogueIterType.Option..Index
	end
end

function FOptionNode:GetDesiredNode()
	return self.OverriddenNode or self
end

function FOptionNode:GetOptionType()
	if self.IsImpression then
		return self.OptionType
	end
	return false
end

function FOptionNode:Record(OptionId)
	FOptionNode.Super.Record(self, OptionId)
	-- if not self.IterGraph.bShowInStoryReview then
	-- 	return
	-- end
	--防止传入的是选项序号而不是Id
	OptionId = self.Options[OptionId] or OptionId
	if self.VisitedOptions[OptionId] then
		return
	end
	local OptionData = {
		bImpression = self.IsImpression,
		OptionType = self:GetOptionType(),
		Options = self:GetOptions(),
		VisitedOptions = self:HasFinalDialogue() and self.VisitedOptions or {},
		SelectedOption = OptionId,
	}
	self.DialogueRecordComponent:OnOptionRecord(OptionId, OptionData)
end

return FOptionNode