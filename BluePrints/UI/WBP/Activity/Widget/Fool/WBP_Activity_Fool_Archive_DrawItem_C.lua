require "UnLua"

local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
M._components = {
    "BluePrints.UI.BP_EMUserWidgetUtils_C"
}

function M:Construct()
    self.Image_Icon:SetRenderOpacity(0)
    self:PlayAnimation(self.Normal)
    -- self:BindToAnimationFinished(self.Draw, {self, self.ShowIcon})
end

function M:Destruct()
    -- self:UnbindAllFromAnimationFinished(self.Draw)
end

function M:StartDrawAnimation(TransformID)
    self.TransformID = TransformID
    local TransformData = DataMgr.TransformAFDayEvent[TransformID]
    if not TransformData then
        return
    end

    local Texture = LoadObject(TransformData.Icon)
    self.Image_Icon:SetBrushFromTexture(Texture)

    self:PlayAnimation(self.Draw)
    self:AddTimer(0.5, self.ShowIcon)
end

function M:ShowIcon()
    self.Image_Icon:SetRenderOpacity(1)
end

AssembleComponents(M)

return M