local EMCache = require "EMCache.EMCache"
local ForgeModel = require "Blueprints.UI.Forge.ForgeDataModel"
local TalkUtils = require "BluePrints.Story.Talk.View.TalkUtils"

local PlayDialogueTag = {
	Dialogue = "Dialogue",
	Forge = "Forge",
}

local GuideLogType = UE.EStoryLogType.Guide

local MaxTipUINum = 3
local TipUIShowTime = 3

local M = Class({ "BluePrints.UI.BP_UIState_C" })

function M:Construct()
	self.GuideManInfos = {}
	self.GuideManIdx = 0
	self.LastGuideManConfigId = nil
	self.bForgeVisible = false
	self:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
	if self:GetParent() then
		self:GetParent():SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
	end

	self.LastFacialIdx = nil
	self:SwitchShowImage(false)
end

function M:Destruct()
	M.Super.Destruct(self)
end

function M:SwitchStyle(TaskData)
	self.GuideTalkStyle = TaskData.GuideTalkStyle

	if self.GuideTalkStyle == 'Communicator' then
		self.StyleInAnimation = self.In_Radio
		self.StyleOutAnimation = self.Out_Radio
	else
		self.StyleInAnimation = self.In_Normal
		self.StyleOutAnimation = self.Out_Normal
	end
end

function M:BindAnimations()
	self:BindToAnimationFinished(self.In_Radio, { self, self.OnInRadioAnimationFinished })
end

function M:OnInRadioAnimationFinished()
	self:PlayAnimation(self.Loop_Radio, 0, 0)
end

function M:PlayDialogue(TalkTask, DialogueData, TaskData, LambdaCallback)
	self:SwitchStyle(TaskData)
	self:BindAnimations()
	self:TryPlayFadeInAnimationWithAudio(DialogueData, TaskData)
	self:SetUIVisibilityWhenPlayDialogue()
	self:SetNameText(DialogueData)
	self:SetDialogueText(DialogueData)

	local FacialIdx = self:GetGuideFacialId(DialogueData)
	self:SwitchGuideHeadInternal(FacialIdx, DialogueData)

	local TalkContext = GWorld.GameInstance:GetTalkContext()
	local WaitQueue = TalkContext.WaitQueueManager:CreateWaitQueue(self, {
		{ Tag = PlayDialogueTag.Dialogue },
		{ Tag = PlayDialogueTag.Forge },
	}, self, LambdaCallback)

	self.DialogueDurationTimer = self:AddTimer(DialogueData.Duration, function()
		WaitQueue:CompleteWaitItem(PlayDialogueTag.Dialogue)
	end)

	if (self.bForgeVisible) then
		local CanProduceDraftIds = self:GetCanProduceDraftIds()
		self:ProcessPlayForgingWaitTag(CanProduceDraftIds, 1, function()
			WaitQueue:CompleteWaitItem(PlayDialogueTag.Forge)
		end)
	else
		WaitQueue:CompleteWaitItem(PlayDialogueTag.Forge)
	end
end

function M:GetGuideFacialId(DialogueData)
	if (DialogueData.GuideFacialId) then
		if (DialogueData.HeadIconType == "Special") then
			return DialogueData.GuideFacialId
		elseif (DialogueData.HeadIconType == "Npc") then
			return self:GetNpcFacialId(DialogueData.DialogueId, DialogueData.TalkActorId, DialogueData.GuideFacialId)
		end
	end

	if (not DialogueData.TalkActorId) then
		return nil
	end

	local NpcId = URuntimeCommonFunctionLibrary.GetNPCIdByGender(self, DialogueData.TalkActorId)
	return self:GetNpcHeadId(DialogueData.DialogueId, NpcId)
end

function M:GetNpcHeadId(DialogueId, NpcId)
	local NpcData = DataMgr.Npc[NpcId]
	if (not NpcData) then
		local Message = string.format("获取引导头像失败，Npc数据无效，台本编号：%s，Npc编号：%s", DialogueId, NpcId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, GuideLogType, "获取引导头像Id失败", Message)
		return
	end

	return NpcData.GuideHeadId
end

function M:GetNpcFacialId(DialogueId, NpcId, FacialId)
	if (not NpcId) then
		return nil
	end

	NpcId = URuntimeCommonFunctionLibrary.GetNPCIdByGender(self, NpcId)
	if (not NpcId) then
		local Message = string.format("获取Npc表情Id失败，NpcId无效，反馈策划检查配置，台本编号：%s，NpcId：%s", DialogueId, NpcId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, GuideLogType, "获取Npc表情Id失败: NpcId无效", Message)
		return
	end

	if (not FacialId) then
		local Message = string.format("获取Npc表情Id失败，表情Id无效，反馈策划检查配置，台本编号：%s，表情Id：%s", DialogueId, FacialId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, GuideLogType, "获取Npc表情Id失败: FacialId无效", Message)
		return
	end

	local NpcData = DataMgr.Npc[NpcId]
	if (not NpcData) then
		local Message = string.format("获取Npc表情Id失败，Npc数据无效，反馈策划检查配置，台本编号：%s，Npc编号：%s", DialogueId, NpcId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, GuideLogType, "获取Npc表情Id失败: NpcData无效", Message)
		return
	end

	local ModelId = NpcData.ModelId
	if (not ModelId) then
		local Message = string.format("获取Npc表情Id失败，模型Id无效，反馈策划检查配置，台本编号：%s，Npc编号：%s", DialogueId, NpcId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, GuideLogType, "获取Npc表情Id失败: ModelId无效", Message)
		return
	end

	local ModelData = DataMgr.Model[ModelId]
	if (not ModelData) then
		local Message = string.format("获取Npc表情Id失败，模型数据无效，反馈策划检查配置，台本编号：%s，Npc编号：%s，模型Id：%s", DialogueId, NpcId, ModelId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, GuideLogType, "获取Npc表情Id失败: ModelData无效", Message)
		return
	end

	if (not ModelData.AvatarExpressionPrefix) then
		local Message = string.format("获取Npc表情Id失败，模型数据中没有AvatarExpressionPrefix，反馈策划检查配置，台本编号：%s，Npc编号：%s，模型Id：%s", DialogueId, NpcId, ModelId)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, GuideLogType, "获取Npc表情Id失败: 未找到AvatarExpressionPrefix", Message)
		return
	end

	return string.format("%s%s", ModelData.AvatarExpressionPrefix, FacialId)
end

function M:OnFinished(LambdaCallback)
	AudioManager(self):PlayFMODSound(self, nil, "event:/ui/common/guider_hide", "GuideManTalk")
	self:BindToAnimationFinished(self.StyleOutAnimation, { self, function()
		LambdaCallback()
	end })
	self:StopAllAnimations()
	self:PlayAnimation(self.StyleOutAnimation)
end

function M:IsSameGuideMan(FacialA, FacialB)
	DebugPrint("WBP_GuideManTalkUI_C:IsSameGuideMan", FacialA, FacialB)
	if (not FacialA) or (not FacialB) then
		return false
	end
	if FacialA == FacialB then
		return true
	end
	local PosA = string.find(FacialA, '_', 1, false)
	local PosB = string.find(FacialB, '_', 1, false)
	if PosA ~= PosB then
		return false
	end

	for i = 1, PosA do
		if FacialA[i] ~= FacialB[i] then
			return false
		end
	end

	return true
end

function M:TryPlayFadeInAnimationWithAudio(DialogueData, TaskData)
	local GuideFacialId = self:GetGuideFacialId(DialogueData)
	local bIsSameGuideMan = self:IsSameGuideMan(GuideFacialId, self.LastFacialIdx)
	if not bIsSameGuideMan then
		self:PlayAnimation(self.StyleInAnimation)
		if (TaskData.IsPlayStartSound == true) then
			AudioManager(self):PlayFMODSound(self, nil, "event:/ui/common/guider_show", "GuideManTalk")
		end
	else
		DebugPrint("WBP_GuideManTalkUI_C Different GuideMan")
	end
end

function M:SetUIVisibilityWhenPlayDialogue()
	self:SetTextBorderHidden(false)
end

function M:SetTextBorderHidden(bHidden)
	if (bHidden) then
		self.DialogueText:SetVisibility(ESlateVisibility.Collapsed)
		self.NpcNameText:SetVisibility(ESlateVisibility.Collapsed)
	else
		self.DialogueText:SetVisibility(ESlateVisibility.Visible)
		self.NpcNameText:SetVisibility(ESlateVisibility.Visible)
	end
end

function M:SetNameText(DialogueData)
	local Name = self:GetDialogueSpeakerName(DialogueData)
	self.NpcNameText:SetText(Name)
end

function M:SetDialogueText(DialogueData)
	self.DialogueText:SetText(DialogueData.Content)
end

function M:SwitchShowImage(bShow)
	local ImageWidget = self.Image_GuideMan
	if bShow then
		ImageWidget:SetVisibility(ESlateVisibility.Visible)
	else
		ImageWidget:SetVisibility(ESlateVisibility.Collapsed)
	end
end

function M:GetDialogueSpeakerName(DialogueData)
	local Name = nil
	if (DialogueData.TalkActorName) then
		Name = DialogueData.TalkActorName
	else
		local TalkActorData = DialogueData.TalkActorData
		if (not TalkActorData) then
			Name = TalkUtils:GetTalkActorName("Npc", DialogueData.TalkActorId)
		else
			Name = TalkUtils:GetTalkActorName(TalkActorData.TalkActorType, TalkActorData.TalkActorId)
		end
	end
	return GText(Name)
end

function M:SwitchGuideHeadInternal(FacialIdx, DialogueData)
	if (self.LastFacialIdx == FacialIdx) then
		return
	end

	self.LastFacialIdx = FacialIdx

	if (not self.LastFacialIdx) then
		self:SwitchShowImage(false)
		return
	end

	local Path, X, Y = self:GetGuideHead(FacialIdx)
	if (not UResourceLibrary.CheckResourceExistOnDisk(Path)) then
		local Message = string.format("引导员头像路径无效，反馈策划检查配置，台本编号：%s，头像Id：%s", DialogueData.DialogueId, FacialIdx)
		UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, GuideLogType, "获取Npc表情Id失败: 头像路径无效", Message)
		self:SwitchShowImage(false)
		return
	end

	UResourceLibrary.LoadObjectAsync(self, Path, { self, function(_, Asset)
		if (self.LastFacialIdx ~= FacialIdx) then
			return
		end

		local Material = self.Image_GuideMan:GetDynamicMaterial()
		if (not IsValid(Material)) then
			return
		end

		Material:SetTextureParameterValue("HeadTex", Asset)
		Material:SetScalarParameterValue("XNum", X)
		Material:SetScalarParameterValue("YNum", Y)
		self:SwitchShowImage(true)
	end })
end

function M:OnInterrupted()
	self:Clear()
end

function M:OnPaused()
	self:ClearTimer()
	self:StopAllAnimations()
	self:ResetLastFacial()
	self:Hide("Paused")
end

function M:OnPauseResumed()
	self:StopAllAnimations()
	self:Show("Paused")
end

function M:ResetLastFacial()
	self.LastFacialIdx = nil
end

function M:Clear()
	self:RemoveTimer(self.DialogueDurationTimer)
	self:ClearTipUI()
end

function M:ClearTimer()
	self:RemoveTimer(self.DialogueDurationTimer)
	self:RemoveTimer(self.ShowForgeTimer)
end

function M:SetForgeVisibility(bForgeVisible)
	if (self.bForgeVisible == bForgeVisible) then
		return
	end

	self.bForgeVisible = bForgeVisible

	if (self.bForgeVisible) then
		self.ForgingTips:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
		self.Text_Workable:SetText(GText("UI_FORGING_READY"))
	else
		self.ForgingTips:SetVisibility(ESlateVisibility.Collapsed)
	end
end

function M:GetCanProduceDraftIds()
	local CanProduceDraftIds = {}
	local TargetDraftIds = EMCache:Get("TargetDraftIds", true)
	if TargetDraftIds then
		for DraftId, _ in pairs(TargetDraftIds) do
			local DraftInfo = ForgeModel:ConstructDraftInfoByDraftId(DraftId)
			if DraftInfo and ForgeModel:CanProduce(DraftInfo) > 0 then
				table.insert(CanProduceDraftIds, DraftId)
			end
		end
	end

	table.sort(CanProduceDraftIds, function(Id_1, Id_2)
		return Id_1 < Id_2
	end)

	return CanProduceDraftIds
end

function M:ProcessPlayForgingWaitTag(CanProduceDraftIds, Idx, Callback)
	local Num = #CanProduceDraftIds
	if Idx > Num then
		if (Callback) then
			Callback()
		end
		return
	end

	self:HideAllTipsUI()
	for i = Idx, Idx + MaxTipUINum - 1 do
		local Id = CanProduceDraftIds[i]
		if not Id then
			break
		end
		self:GetOrAddTipUI(i % MaxTipUINum, Id)
	end
	self.ShowForgeTimer = self:AddTimer(TipUIShowTime, self.ProcessPlayForgingWaitTag,
			false, 0, nil, false, CanProduceDraftIds, Idx + MaxTipUINum, Callback)
end

function M:HideAllTipsUI()
	self.TipUIContents = self.TipUIContents or {}
	for _, Content in pairs(self.TipUIContents) do
		if Content and IsValid(Content.Widget) then
			Content.Widget:HideDraftItem()
		end
	end
end

function M:GetOrAddTipUI(Idx, DraftId)
	self.TipUIContents = self.TipUIContents or {}

	local Content = self.TipUIContents[Idx]
	if not Content then
		Content = NewObject(UIUtils.GetCommonItemContentClass())
		Content.DraftId = DraftId
		self.List_Tips:AddItem(Content)
	end

	self.TipUIContents[Idx] = Content

	return Content.Widget
end

function M:ClearTipUI()
	self.List_Tips:ClearListItems()
	self.TipUIContents = {}
end

return M
