local Component = {}


function Component:SetNewGlow(bNewGlow)
    local Callback = function(NewGlowUI)
        self.NewGlow = UE.FWeakObjectPtr(NewGlowUI)
        self:AddWidgetToNode(nil, self.NewGlow)
        NewGlowUI:SetRarity(self.Rarity) 
    end
    if bNewGlow and self.Rarity then
        if not self.NewGlow or not self.NewGlow:IsValid() then
            self:CreateWidgetAsync("ComItemNewGlow", Callback)
            return
        else
            Callback()
        end
    elseif self.NewGlow then
        self:RemoveWidgetFromNode(nil,false,self.NewGlow)
    end
end

return Component