local M = Class()

local RecallSFX = "event:/sfx/common/story/01/flashing"

function M:OnInitializeEvent()
end

function M:UpdateImageWidget(ImagePath, Section, Input)
    DebugPrint("ImageSequenceInstance:UpdateImageWidget", ImagePath)
    if not IsValid(Section) then
        return
    end

    if not IsValid(self.ImageWidget) then
        self.ImageWidget = UIManager(self):_CreateWidgetNew("StoryImgSequence")
        self.ImageWidget:AddToViewport(-1)
    end

    local DialogueImage = UStoryFunctionLibrary.LoadResourceWithGender(self, ImagePath, self)
    if not DialogueImage then
        local Message = "Sequence图片资源缺失".."\n路径:"..ImagePath
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Sequence, "图片资源缺失", Message)
        return
    end
    self.ImageWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.ImageWidget:SetImage(DialogueImage)
    if Section.bShowMaterial then
        local MatPath = "MaterialInstanceConstant'/Game/UI/WBP/Common/VX/Story/MI_FadeIn.MI_FadeIn'"
        local Mat = LoadObject(MatPath)
        if Mat then
            local MaterialInstance = UE4.UKismetMaterialLibrary.CreateDynamicMaterialInstance(self, Mat, "None")
            if MaterialInstance then
                MaterialInstance:SetTextureParameterValue("MainTex", DialogueImage)
                self.ImageWidget:SetImageMaterial(MaterialInstance)
            end
        end
        self.ImageWidget:PlayAnimation(self.ImageWidget.Recall)
    else
        self.ImageWidget:SetImage(DialogueImage)
    end

    local TalkSequenceObject = UTrackInstanceFunctionLibrary.GetTalkSequenceObject(self, Input)
    if not TalkSequenceObject or not TalkSequenceObject:IsInSkip() then
        if Section.bPlayAudio then
            AudioManager(self):PlayNormalSound(nil, nil, RecallSFX, "RecallGraph", true)
        end
    end
end

function M:HideImageWidget()
    DebugPrint("ImageSequenceInstance:HideImageWidget")
    if not IsValid(self.ImageWidget) then return end
    self.ImageWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    AudioManager(self):StopSound(nil, "RecallGraph")
end

function M:UpdateIconWidget(ImagePath, ImageSection, NewIconInput)
    DebugPrint("ImageSequenceInstance:UpdateIconWidget", ImagePath)
    if not IsValid(self.IconWidget) then
        self.IconWidget = UIManager(self):_CreateWidgetNew("StoryImgItem")
        self.IconWidget:AddToViewport(0)
    end

    local DialogueImage = UStoryFunctionLibrary.LoadResourceWithGender(self, ImagePath, self)
    if not DialogueImage then
        local Message = "Sequence Icon资源缺失".."\n路径:"..ImagePath
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Sequence, "图片资源缺失", Message)
        return
    end
    self.IconWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.IconWidget:DireceShowPicture(DialogueImage)
end

function M:HideIconWidget()
    DebugPrint("ImageSequenceInstance:HideIconWidget")
    if not IsValid(self.IconWidget) then return end
    self.IconWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:OnDestroyedEvent()
    if IsValid(self.IconWidget) then
        self.IconWidget:RemoveFromParent()
        self.IconWidget = nil
    end
    if IsValid(self.ImageWidget) then
        AudioManager(self):StopSound(nil, "RecallGraph")
        self.ImageWidget:RemoveFromParent()
        self.ImageWidget = nil
    end
end

return M