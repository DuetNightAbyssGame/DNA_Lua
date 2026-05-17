local M = Class({ "BluePrints.UI.BP_EMUserWidget_C" })

function M:Construct()
    self.TipText = self.Text_Tips
    self.RewardRoundText = self.Text_Reward
    self.CurrentRoundText = self.Text_Now
    self.NextRoundText = self.Text_After
    self.MaxRoundText = self.Text_Total

    self.FadeInAnimation = self.In
    self.FadeOutAnimation = self.Out

    self.TipText:SetText(GText("UI_LimitedPrizePool_AlreadyAll"))
    self.RewardRoundText:SetText(GText("UI_LimitedPrizePool_Round"))

    self:BindToAnimationFinished(self.FadeInAnimation, { self, self.HandleFadeInAnimationFinished })
    self:BindToAnimationFinished(self.FadeOutAnimation, { self, self.HandleFadeOutAnimationFinished })

    self.OnClosed = nil
end

function M:Destruct()
end

function M:Init(CurrentRoundNumber, MaxRoundNumber, OnClosed)
    self.CurrentRoundText:SetText(tostring(CurrentRoundNumber - 1))
    self.NextRoundText:SetText(tostring(CurrentRoundNumber))
    self.MaxRoundText:SetText(tostring(MaxRoundNumber))
    self.OnClosed = OnClosed

    self:PlayAnimation(self.FadeInAnimation)
end

function M:HandleFadeInAnimationFinished()
    self:PlayAnimation(self.FadeOutAnimation)
end

function M:HandleFadeOutAnimationFinished()
    self:RemoveFromParent()
    if (self.OnClosed and self.OnClosed[1] and self.OnClosed[2]) then
        self.OnClosed[2](self.OnClosed[1])
    end
end

return M
