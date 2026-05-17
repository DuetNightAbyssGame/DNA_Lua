require "UnLua"
require "DataMgr"

local WBP_NPC_Bubble_C = Class("BluePrints.UI.BP_EMUserWidget_C")

function WBP_NPC_Bubble_C:Initialize(Initializer)
    self.ParentHeadWidget = nil
    self.bIsEnabled_Bubble = false
end

function WBP_NPC_Bubble_C:Init(ParentHeadWidget)
    self:SetVisibility(ESlateVisibility.Collapsed)
    self.ParentHeadWidget = ParentHeadWidget
    self.bIsEnabled_Bubble = false
end

function WBP_NPC_Bubble_C:OnEnabled(Content, Style)
    if not self.ParentHeadWidget then return end
    if self.bIsEnabled_Bubble then return end
    --DebugPrint("WBP_NPC_Bubble_C:OnEnabled", Content, Style, Time, self.Panle_Main:GetRenderOpacity(),"vis:", self:GetVisibility())

    self.bIsEnabled_Bubble = true
    -- self:StopAllAnimations()
    self.BubbleContent = Content
    self.Main_Text:SetText(Content)
    self:SwitchStyle(Style)
    self.Panle_Main:SetRenderOpacity(0)
    -- self:PlayAnimation(self.In)
    EMUIAnimationSubsystem:EMStopAnimation(self, self.Out)
    EMUIAnimationSubsystem:EMStopAnimation(self, self.Loop)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.In)
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function WBP_NPC_Bubble_C:SwitchStyle(style)
    --DebugPrint("WBP_Npc_Bubble_C:SwitchStyle",style or "nil")
    self:SwitchEnableEmoBubble(false)
    --DebugPrint("WBP_Npc_Bubble_C:SwitchStyle",style)

    if (style) and (string.lower(style) == 'excitedbubble') then
        self:SwitchEnableEmoBubble(true)
    end
end

function WBP_NPC_Bubble_C:SwitchEnableEmoBubble(bEnable)
    --DebugPrint("WBP_NPC_Bubble_C:SwitchEnableEmoBubble", bEnable)
    if bEnable then
        self.Group_Emo:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Image_Normal:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Group_Emo:SetVisibility(ESlateVisibility.Collapsed)
        self.Image_Normal:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

function WBP_NPC_Bubble_C:OnDisabled()
    if not self.bIsEnabled_Bubble then
        return
    end
    self.bIsEnabled_Bubble = false
    EMUIAnimationSubsystem:EMStopAnimation(self, self.In)
    EMUIAnimationSubsystem:EMStopAnimation(self, self.Loop)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Out)
    -- self:PlayAnimation(self.Out)
end

function WBP_NPC_Bubble_C:OnInAnimationFinished()
    -- self:PlayAnimation(self.Loop, 0, 0)
    -- EMUIAnimationSubsystem:EMStopAnimation(self, self.In)
    -- EMUIAnimationSubsystem:EMStopAnimation(self, self.Out)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Loop)
end

function WBP_NPC_Bubble_C:OnAnimationFinished(InAnimation)
    if InAnimation == self.In then
        self:OnInAnimationFinished()
    elseif InAnimation == self.Out then
        self:OnOutAnimationFinished()
    end
end

function WBP_NPC_Bubble_C:OnOutAnimationFinished()
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

return WBP_NPC_Bubble_C
