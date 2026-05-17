require "UnLua"
require "DataMgr"

local WBP_NPC_Bubble_Emoji_C = Class("BluePrints.UI.BP_EMUserWidget_C")

function WBP_NPC_Bubble_Emoji_C:Initialize(Initializer)
    self.ParentHeadWidget = nil
    self.bIsEnabled_Bubble = false
end

function WBP_NPC_Bubble_Emoji_C:Init(ParentHeadWidget)
    self:SetVisibility(ESlateVisibility.Collapsed)
    self.ParentHeadWidget = ParentHeadWidget
    self.bIsEnabled_Bubble = false
end

function WBP_NPC_Bubble_Emoji_C:OnEnabled(EmojiId)
    if not self.ParentHeadWidget then return end
    if self.bIsEnabled_Bubble then return end
    --DebugPrint("WBP_NPC_Bubble_Emoji_C:OnEnabled", Content, Style, Time, self.Panle_Main:GetRenderOpacity(),"vis:", self:GetVisibility())

    self.bIsEnabled_Bubble = true
    self.EmojiId = EmojiId
    PrintTable(EmojiId)
    UResourceLibrary.LoadObjectAsync(self, EmojiId.Icon, {
        self, 
        function(obj, Image)
            if not IsValid(obj) then 
                return 
            end
            if not self.bIsEnabled_Bubble then 
                return 
            end
            if self.EmojiId ~= EmojiId then 
                return 
            end
            self.WS_Emoji:SetActiveWidgetIndex(0)
            self.Image_EmojiBig:SetBrushFromTexture(Image)
            self:StopAllAnimations()
            --self.Panle_Main:SetRenderOpacity(0)
            self:PlayAnimation(self.In)
            self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    })
end

function WBP_NPC_Bubble_Emoji_C:OnDisabled()
    if not self.bIsEnabled_Bubble then
        return
    end
    self.bIsEnabled_Bubble = false
    self:StopAllAnimations()
    self:PlayAnimation(self.Out)
    self.Image_EmojiBig:SetBrushFromTexture(nil)
end

function WBP_NPC_Bubble_Emoji_C:OnInAnimationFinished()
    self:PlayAnimation(self.Loop, 0, 0)
end

function WBP_NPC_Bubble_Emoji_C:OnAnimationFinished(InAnimation)
    if InAnimation == self.In then
        self:OnInAnimationFinished()
    elseif InAnimation == self.Out then
        self:OnOutAnimationFinished()
    end
end

function WBP_NPC_Bubble_Emoji_C:OnOutAnimationFinished()
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

return WBP_NPC_Bubble_Emoji_C
