require "UnLua"
---@type WBP_Story_ImgRecall
local M = Class({"BluePrints.Common.TimerMgr","BluePrints.UI.BP_EMUserWidget_C"})

local RecallSFX = "event:/sfx/common/story/01/flashing"

function M:Construct()
    self.Bg_Black:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Img_Recall:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.bInAnim = false
    self.bPlaySound = false
    self.bShownImg = false
    self.CurrentGraphPath = nil
end

function M:Destruct()
	self:Clear()
end

function M:InitGraph(GraphPath, bNotRecall, bSkip)
    self.Bg_Black:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Img_Recall:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

    local DialogueImage = UStoryFunctionLibrary.LoadResourceWithGender(self, GraphPath, self)
    if not DialogueImage then
        local Message = "回忆图片资源缺失".."\n路径:"..GraphPath
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Talk, "图片资源缺失", Message)
        return
    end
    DebugPrint("WBP_Story_ImgRecall@InitGraph", GraphPath, bNotRecall, bSkip)

    if not bNotRecall then
        local MatPath = "MaterialInstanceConstant'/Game/UI/WBP/Common/VX/Story/MI_FadeIn.MI_FadeIn'"
        local Mat = LoadObject(MatPath)
        if Mat then
            local MaterialInstance = UE4.UKismetMaterialLibrary.CreateDynamicMaterialInstance(self, Mat, "None")
            if MaterialInstance then
                MaterialInstance:SetTextureParameterValue("MainTex", DialogueImage)
                self.Img_Recall:SetBrushFromMaterial(MaterialInstance)
            end
        else
            local Message = "材质资源缺失"..
            "\n路径:"..MatPath
            UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Talk, "材质资源缺失", Message)
        end
    else
        self.Img_Recall:SetBrushResourceObject(DialogueImage)
    end

    self.bPlaySound = not bNotRecall and not bSkip
    self.bUpdateImg = GraphPath ~= self.CurrentGraphPath
    self.CurrentGraphPath = GraphPath
    if self.bUpdateImg then
        --将In动效定格在第一帧
        self:PlayAnimation(self.Recall_In)
        self:StopAnimation(self.Recall_In)
    end
end

function M:PlayRecallAnim(bInAnim)
    self.bInAnim = bInAnim
	if self.RecallTimer then
        return
    end 
    self.RecallTimer = self:AddTimer(0.01, function()
        if self.bInAnim then
            self:StopAnimation(self.Recall_Out)
            local bPlayInAnim = not self.bShownImg or self.bUpdateImg
            if bPlayInAnim then
                self:PlayAnimation(self.Recall_In)
            end
            if self.bPlaySound then
                AudioManager(self):PlayNormalSound(nil, nil, RecallSFX, "RecallGraph", true)
            end
        else
            self.Bg_Black:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self:StopAnimation(self.Recall_In)
            self:PlayAnimation(self.Recall_Out)
        end
        self.bShownImg = self.bInAnim
        DebugPrint("WBP_Story_ImgRecall@PlayRecallAnim", self.bInAnim)
        self.RecallTimer = nil
    end, nil, nil, nil, true)
end

function M:OnCollapsingGraph()
    self.CurrentGraphPath = nil
end

function M:Clear()
	if self.RecallTimer then
        self:RemoveTimer(self.RecallTimer)
        self.RecallTimer = nil
    end
end

function M:Close()
    DebugPrint("WBP_Story_ImgRecall:Close")
    self:RemoveFromParent()
    self.Bg_Black:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Img_Recall:SetVisibility(UE4.ESlateVisibility.Collapsed)
	self:Clear()
end

return M