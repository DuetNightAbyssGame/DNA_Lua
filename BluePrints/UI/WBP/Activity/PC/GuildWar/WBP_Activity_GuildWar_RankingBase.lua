require "UnLua"

local M = Class{"BluePrints.UI.BP_UIState_C"}
M._components = {
    "BluePrints.UI.WBP.Activity.PC.GuildWar.WBP_Activity_GuildWar_RankingPageView",
    "BluePrints.UI.WBP.Armory.MainComponent.Armory_PointerInputComponent",
}

function M:Construct()
    M.Super.Construct(self)
    self:PlayAnimation(self.In)
end

function M:Destruct()
    if self.ActorController then
        self.ActorController:OnDestruct()
    end
    M.Super.Destruct(self)
end

function M:CloseSelf()
    if self:IsAnimationPlaying(self.In) then
        return
    end
    self:PlayAnimation(self.Out)
    self:BlockAllUIInput(true,"SP_DisplayOnly")
    self:AddTimer(0.2, function() self:Close() end)
end

function M:On_Image_Click_MouseButtonDown(MyGeometry, MouseEvent)
    return self:OnPointerDown(MyGeometry, MouseEvent)
end

function M:OnMouseWheel(MyGeometry, MouseEvent)
    return self:OnMouseWheelScroll(MyGeometry, MouseEvent)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
    return self:OnPointerUp(MyGeometry, MouseEvent)
end

function M:OnMouseMove(MyGeometry, MouseEvent)
    return self:OnPointerMove(MyGeometry, MouseEvent)
end

function M:OnTouchEnded(MyGeometry, InTouchEvent)
    return self:OnPointerUp(MyGeometry, InTouchEvent)
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
    return self:OnPointerMove(MyGeometry, InTouchEvent)
end

function M:OnMouseCaptureLost()
    self:OnPointerCaptureLost()
end

AssembleComponents(M)

return M