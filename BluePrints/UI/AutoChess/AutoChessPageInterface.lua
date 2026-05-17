local AutoChessPageInterface = {}

function AutoChessPageInterface:InitView()
    -- do nothing
end

function AutoChessPageInterface:_OnPagePushed(ParentWidget)
    self.ParentWidget = ParentWidget
    self.ControllerFSM = ParentWidget:GetControllerFSM()
    if self.In then
        self:PlayAnimation(self.In)
    end

    self:OnPagePushed(ParentWidget)
end

function AutoChessPageInterface:OnPagePushed(ParentWidget)
    
end

function AutoChessPageInterface:_OnPagePoped()
    if self.Out then
        self:PlayAnimation(self.Out)
    else
        self:RemoveFromParent()
    end

    self:OnPagePoped()
end

function AutoChessPageInterface:OnPagePoped()
    
end

function AutoChessPageInterface:OnAnimationFinished(Animation)
    if Animation == self.Out then
        self:RemoveFromParent()
    end
end

function AutoChessPageInterface:SwitchControllerFSMState(NewStateName)
    if self.ControllerFSM then
        self.ControllerFSM:Enter(NewStateName) 
    end
end

function AutoChessPageInterface:GetControllerFSMState()
    if self.ControllerFSM then
        return self.ControllerFSM:Current()
    end
end

function AutoChessPageInterface:GetDefaultControllerFSMState()
    return nil
end

function AutoChessPageInterface:IsTopPage()
    return self.ParentWidget and self.ParentWidget:GetTopSubPage() == self
end


return AutoChessPageInterface