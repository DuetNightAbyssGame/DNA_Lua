
local ShowTaskFullfillPopupUINode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')

function ShowTaskFullfillPopupUINode:Execute(Callback)
    self.TaskFullfillPopup = nil
    if not self.QuestId then
		DebugPrint("ShowTaskFullfillPopupUINode:self.QuestId is nil")
        Callback()
    else
        local FakeQuestInfo = DataMgr.FakeQuest[self.QuestId]
        if not FakeQuestInfo then
		    DebugPrint("FakeQuestInfo is nil, QuestId:", self.QuestId)
            local Message = "FakeQuest表中没有QuestId对应的数据"..
		    "\nFileName:"..self.Context.FileName..
		    "\nNodeInfo:"..self:ToString()..
            "\nQuestId:"..self.QuestId
		    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "FakeQuest表中没有QuestId对应的数据", Message)
            Callback()
        else
            local ChoiceCallback = function (ConfirmFullfill)
                self.Context.ConfirmFullfill = ConfirmFullfill
                Callback()
            end
            self.TaskFullfillPopup = UIManager(self):LoadUINew("TaskFullfillPopup", FakeQuestInfo)
            self.TaskFullfillPopup:AddChoiceCallback(ChoiceCallback)
        end
    end
end

function ShowTaskFullfillPopupUINode:Clear()
    if IsValid(self.TaskFullfillPopup) then
        self.TaskFullfillPopup:RemoveChoiceCallback()
        self.TaskFullfillPopup:Close()
    end
    self.TaskFullfillPopup = nil
end

return ShowTaskFullfillPopupUINode