local FTalkTriggerComponent = require "BluePrints.Story.Talk.Component.TalkTriggerComponent"

local M = Class("BluePrints.Story.FlowGraph.FlowNode.TalkFlowNode.FlowNode_TalkNodeBase")
local FlowLogType = UE.EStoryLogType.TalkFlow

-- function M:ReceiveEndPlay(...)
-- end

function M:K2_InitializeInstance()
    self.Options = self.OptionData:ToTable()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local FlowExportBranchImpr = DataMgr.FlowExportBranchImpr
    for _, OptionId in pairs(self.Options) do
        local bSelected = false
        if FlowExportBranchImpr[OptionId] then
            for _, ImprOptionId in pairs(FlowExportBranchImpr[OptionId]) do
                if Avatar:IsImpressionCheckFailure(OptionId) then
                    self.RestartTag = true
                    return
                end
            end
        end
    end
end

function M:GetConditionOptions()
    local Options = {}
    for _, OptionData in ipairs(self.Options) do
        if FTalkTriggerComponent:CheckDialogueCondition(OptionData.DialogueId) then
            table.insert(Options, OptionData.DialogueId)
        end
    end
    if(self.bRandomCount) then
		--随机选项模式下不记录已选择选项
		self.SelectOptions = {}
		local RandomOptions = {}
        local FinialOptionNum = math.min(#Options,self.RandomCount)
        for i=1,FinialOptionNum do
            local RandomIndex = math.random(1,#Options)
            local RandOption = Options[RandomIndex]
            table.insert(RandomOptions, RandOption)
            table.remove(Options, RandomIndex)
        end
        Options = RandomOptions
   	elseif self:IsFinalConnected() then
        local NewOptions = {}
        for _, OptionId in ipairs(Options) do
            if not self.SelectOptions[OptionId] then
                table.insert(NewOptions, OptionId)
            end
        end
        for _, OptionId in ipairs(Options) do
            if self.SelectOptions[OptionId] then
                table.insert(NewOptions, OptionId)
            end
        end
        Options = NewOptions
    end
    return Options
end

function M:GetRecordOptionData(OptionDialogueId)
    local OptionData = {
		bImpression = false,
		OptionType = nil,
		Options = self:GetConditionOptions(),
		VisitedOptions = self:IsFinalConnected() and self.SelectOptions or {},
		SelectedOption = OptionDialogueId,
	}
    return OptionData
end

function M:IterForward()
    local DialogueFlowGraphComponent = self:TryGetFlowGraphComponent()
    local DialogueRecordComponent = self:TryGetRecordComponent()
    local Options = self:GetConditionOptions()
    local AllVisit = true
    for _, OptionId in pairs(Options) do
        if not self.SelectOptions[OptionId] then
            AllVisit = false
            break
        end
    end
    if AllVisit and self:HasFinalDialogue() then
        self:FinishToFinal()
    elseif #Options > 0 then
        DialogueFlowGraphComponent:PlayOptions(Options, self.SelectOptions, function(OptionDialogueId, FinishType)
            DialogueRecordComponent:OnOptionRecord(OptionDialogueId, self:GetRecordOptionData(OptionDialogueId))
            self:SelectOption(OptionDialogueId, FinishType)
        end, self)

    else
        self:FinishToDefault()
    end
end

function M:Start()
    self.SelectOptions = self.SelectOptions or {}
    local DialogueFlowGraphComponent = self:TryGetFlowGraphComponent()
    if not DialogueFlowGraphComponent then
        local Message = string.format("当前Option节点，注册的Task不存在 DialogueFlowGraphComponent，请注册")
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, FlowLogType, "Flow选项节点出错：DialogueFlowGraphComponent无效", Message)
        return
    end
    local DialogueRecordComponent = self:TryGetRecordComponent()
    if not DialogueRecordComponent then
        local Message = string.format("当前Dialogue节点，注册的Task不存在 DialogueRecordComponent，请注册")
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, FlowLogType, "Flow选项节点出错：DialogueRecordComponent无效", Message)
        return
    end
    self:IterForward()
end

function M:Skip()
    -- local TalkTask = self:TryGetTalkTask();
    -- TalkTask:SkipDialogue()
    --- FinishToDefault的情况下，会直接跳过当前节点
    local DialogueFlowGraphComponent = self:TryGetFlowGraphComponent()
    local DialogueRecordComponent = self:TryGetRecordComponent()
    for _, OptionId in ipairs(self:GetConditionOptions()) do
        if not self.SelectOptions[OptionId] then
            DialogueFlowGraphComponent:SelectOption(OptionId)
            -- DialogueRecordComponent:OnOptionRecord(OptionId, self:GetRecordOptionData(OptionId))
            return
        end
    end
    if not self:HasFinalDialogue() then
        local Message = string.format("当前Option节点，跳过时不存在Final 出口，无法正常跳过，请检查，或者不要重复连接到该节点")
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, FlowLogType, "Flow选项节点出错：Skip", Message)
    end
end

function M:CanSkip()
    local FlowAsset = self:GetFlowAsset()
    if FlowAsset and FlowAsset.bIsInRestartDialogueSkip then
        if self.RestartTag then
            return false
        else
            return true
        end
    end
    return not self.bForbidSkip
end

function M:Pause()
    --self.TalkComponent:OnPauseDialogue(self)
end

function M:Resume()
    --self.TalkComponent:OnResumeDialogue(self)
    -- self.TalkTask:PlayDialogue(true)
end

function M:SelectOption(OptionId, FinishType) 
    self.SelectOptions[OptionId] = true
    self:FinishSelectOption(OptionId)
end

function M:GetSavedOptions()
    local Avatar = GWorld:GetAvatar()
    local Res = {}
    if not Avatar then
        return Res
    end
    local FlowExportBranchImpr = DataMgr.FlowExportBranchImpr
    for _, OptionId in pairs(self.Options) do
        local bSelected = false
        if FlowExportBranchImpr[OptionId] then
            for _, ImprOptionId in pairs(FlowExportBranchImpr[OptionId]) do
                if Avatar:IsImpressionCheckSuccess(OptionId) then
                    bSelected = true
                    break
                end
            end
        end
        if bSelected then
            table.insert(Res, OptionId)
        end
    end
    return Res
end



return M