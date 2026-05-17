local OpenChapterUINode = Class("StoryCreator.StoryLogic.StorylineNodes.Questline.QuestNode")
OpenChapterUINode._components = {
    "StoryCreator.StoryLogic.StorylineNodes.QuestNodes.GuideNodeComp"
}


function OpenChapterUINode:Init()
end

function OpenChapterUINode:Start(Context)
    EventManager:AddEvent(EventID.UnLoadUI, self, self.FinishAction)
    local Info = DataMgr.QuestUI[self.ChapterUIId]
    self.UIName = Info.UIName
    local GameInstance = GWorld.GameInstance
    UIManager(GameInstance):LoadUINew(self.UIName,self.ChapterUIId, self.UIType)
end

function OpenChapterUINode:FinishAction(UIName)
    if UIName == self.UIName then
        EventManager:RemoveEvent(EventID.UnLoadUI, self)
	    self:Finish()
    end
end

function OpenChapterUINode:Clear()
    EventManager:RemoveEvent(EventID.UnLoadUI, self)
end

AssembleComponents(OpenChapterUINode)
return OpenChapterUINode