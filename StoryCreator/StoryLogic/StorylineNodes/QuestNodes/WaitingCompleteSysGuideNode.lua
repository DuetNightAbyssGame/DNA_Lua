






local WaitingCompleteSysGuideNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode")


function WaitingCompleteSysGuideNode:Init()
    self.SystemGuideId = 0
    self.ListenInterval = 0.5
    self.CallBackFunc = nil
end

-- function WaitingCompleteSysGuideNode:Start(Context)
-- 	self.Context = Context
--     self.NodeKey = "WaitingCompleteSysGuideNode_"..tostring(self.Key)
--     self.ListenHandleName = "ListenSystemGuideComplete_"..tostring(self.Key)
-- 	print('-----------------------------------WaitingCompleteSysGuideNode node start-----------------------------------')
--     -- self.Context:AddCallback(self, self.ListenInterval, self.IsCompeleteSystemGuide, true, self.NodeKey, self.ListenHandleName)
--     self.ListenTimer = GWorld.GameInstance:AddTimer(self.ListenInterval, function()
--         self:IsCompeleteSystemGuide()
--     end, true)
-- end

function WaitingCompleteSysGuideNode:Execute(Callback)
    self.NodeKey = "WaitingCompleteSysGuideNode_"..tostring(self.Key)
    self.ListenHandleName = "ListenSystemGuideComplete_"..tostring(self.Key)
	print('-----------------------------------WaitingCompleteSysGuideNode node start-----------------------------------')
    self.CallBackFunc = Callback
    -- self.Context:AddCallback(self, self.ListenInterval, self.IsCompeleteSystemGuide, true, self.NodeKey, self.ListenHandleName)
    self.ListenTimer = GWorld.GameInstance:AddTimer(self.ListenInterval, function()
        self:IsCompeleteSystemGuide()
    end, true)
end

function WaitingCompleteSysGuideNode:IsCompeleteSystemGuide()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        -- self.Context:RemoveCallback(self.NodeKey, self.ListenHandleName)
        if self.ListenTimer then
            GWorld.GameInstance:RemoveTimer(self.ListenTimer)
            self.ListenTimer = nil
        end
        return
    end
    if Avatar.SystemGuides:GetSystemGuide(self.SystemGuideId):IsFinished() then
        if self.ListenTimer then
            GWorld.GameInstance:RemoveTimer(self.ListenTimer)
            self.ListenTimer = nil
        end
        if self.CallBackFunc then
			self.CallBackFunc("Out")
		end
    end

end

function WaitingCompleteSysGuideNode:Clear()
    -- self.Context:RemoveCallback(self.NodeKey, self.ListenHandleName)
    if self.ListenTimer then
        GWorld.GameInstance:RemoveTimer(self.ListenTimer)
        self.ListenTimer = nil
    end
end

-- function WaitingCompleteSysGuideNode:FinishAction()
--     -- self.Context:RemoveCallback(self.NodeKey, self.ListenHandleName)
--     if self.ListenTimer then
--         GWorld.GameInstance:RemoveTimer(self.ListenTimer)
--         self.ListenTimer = nil
--     end
-- 	self:Finish()
-- end

return WaitingCompleteSysGuideNode