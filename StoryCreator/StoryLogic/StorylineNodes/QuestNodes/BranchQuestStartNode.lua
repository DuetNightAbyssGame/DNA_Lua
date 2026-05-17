local BranchQuestStartNode = Class('StoryCreator.StoryLogic.StorylineNodes.Questline.QuestNode')
local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"

function BranchQuestStartNode:Init()
    self.AllQuestOptions = nil
    self.AllDiffGuideOptions = nil
    self.IsSetCountInfo = false
    self.CurQuestChainId = 0
    self.CurDoingQuestId = 0
    self.IsDifftation = false
end

function BranchQuestStartNode:Start(Context)
    self.Context = Context
    local NeedFinishCount = 0
    if self.AllQuestOptions then
        for _, Option in pairs(self.AllQuestOptions) do
            if Option and Option.IsNeedFinish then
                NeedFinishCount = NeedFinishCount + 1
            end
        end
    end

    TaskUtils:SetQuestExtraInfo(self.QuestChainId, self.QuestData.QuestId, 
    {
        NodeKey = self.Key,
        Node = self,
        BranchQuestOptions = self.AllQuestOptions,
        DiffGuideList = self.AllDiffGuideOptions,
        IsUpdateCountInfo = self.IsSetCountInfo,
        NeedFinishCount = NeedFinishCount,
        IsUseDifftation = self.IsDifftation,
    })

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self.CurQuestChainId = self.QuestChainId
    if Avatar.InSpecialQuest and ClientEventUtils:GetCurrentEvent() and ClientEventUtils:GetCurrentEvent().PreQuestChainId then
        self.CurQuestChainId = ClientEventUtils:GetCurrentEvent().PreQuestChainId
    end
    if Avatar.QuestChains[self.CurQuestChainId] then
        self.CurDoingQuestId = Avatar.QuestChains[self.CurQuestChainId].DoingQuestId
    end
    -- local TaskUIObj = TaskUtils:GetTaskBarWidget()

    if Avatar.TrackingQuestChainId == self.CurQuestChainId then
        self:ExecuteBranchQuestNode()
        self:SetTaskBarByBranchStartNode()
    else
        -- TaskUIObj.VBox_SubTasks:SetVisibility(UE4.ESlateVisibility.Collapsed)
        if not self.HasFinished then
            self:FinishAction()
        end
    end
end

function BranchQuestStartNode:OnCancelTrack()
    local TaskUIObj = TaskUtils:GetTaskBarWidget()
    if not TaskUIObj then
        -- TaskUIObj.VBox_SubTasks:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end

    if not IsEmptyTable(TaskUIObj.SubTaskWidgetsTable) then
        for Name, Widget in pairs(TaskUIObj.SubTaskWidgetsTable) do
            if IsValid(Widget) and TaskUIObj.VBox_SubTasks:HasChild(Widget) then
                TaskUIObj.VBox_SubTasks:RemoveChild(Widget)
                TaskUIObj.SubTaskWidgetsTable[Name] = nil
            end
        end
        TaskUIObj.SubTaskWidgetsTable = {}
    end
    TaskUIObj.VBox_SubTasks:ClearChildren()
end

function BranchQuestStartNode:OnChooseTrack()
    local TaskUIObj = TaskUtils:GetTaskBarWidget()
    if not TaskUIObj then
        -- TaskUIObj.VBox_SubTasks:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        -- if TaskUIObj.VBox_SubTasks:GetChildrenCount() ~= 0 thenj
        --     TaskUIObj.Tips:SetVisibility(UE4.ESlateVisibility.Collapsed)
        -- end
        return
    end
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    if self.AllQuestOptions and TaskUIObj.VBox_SubTasks:GetChildrenCount() == 0 then
        local SubTaskIndex = 1
        TaskUIObj.SubTaskWidgetsTable = TaskUIObj.SubTaskWidgetsTabl or {}
        for _, BranchQuestInfo in pairs(self.AllQuestOptions) do
            if BranchQuestInfo.BranchQuestName ~= "" then
                local ChildQuestWidget = UIManager:CreateWidget('/Game/UI/WBP/Battle/Widget/TaskBar/WBP_Battle_TaskBar_SubTask.WBP_Battle_TaskBar_SubTask')
                ChildQuestWidget.Text_Describe:SetText(GText(BranchQuestInfo["BranchQuestName"]))
                TaskUIObj.VBox_SubTasks:AddChildToVerticalBox(ChildQuestWidget)
                TaskUIObj.SubTaskWidgetsTable["Branch_"..tostring(SubTaskIndex)] = ChildQuestWidget
                TaskUIObj.VBox_SubTasks:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                -- if self.IsDifftation then
                --     ChildQuestWidget.WS_Type:SetActiveWidgetIndex(1)
                --     ChildQuestWidget:SetABCImg(SubTaskIndex)
                --     ChildQuestWidget.DiffGuideInfos = self.AllDiffGuideOptions[SubTaskIndex]
                -- end
                ChildQuestWidget.SubTaskIndex = SubTaskIndex
                ChildQuestWidget:SetBranchInfo(BranchQuestInfo.TargetBranchQuestKey, GText(BranchQuestInfo["BranchQuestName"]))
            end
            SubTaskIndex = SubTaskIndex + 1
        end
    end

    local Indicators = MissionIndicatorManager:GetIndicatorUIObjByQuestChainId(self.CurQuestChainId)
    if not IsEmptyTable(Indicators) then
        for _, Indicator in pairs(Indicators) do
            Indicator:TrySetDiffGuideIcon(self.CurQuestChainId, Indicator.GuideInfoCache.QuestNode.Key)
        end
    end

    if TaskUIObj and TaskUIObj.VBox_SubTasks:GetChildrenCount() ~= 0 then
        TaskUIObj:TriggerQuestTrackPanelTips(false)
    end
end

function BranchQuestStartNode:SetTaskBarByBranchStartNode()
    if not self.IsSetCountInfo then
        return
    end

    local TaskUIObj = TaskUtils:GetTaskBarWidget()
    if not TaskUIObj then
        return
    end
    TaskUIObj:ChangeMainTaskBarCountInfoByBranchQuestNode(self.QuestChainId, self.QuestData.QuestId)
end

function BranchQuestStartNode:ExecuteBranchQuestNode()
    local TaskUIObj = TaskUtils:GetTaskBarWidget()
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    TaskUIObj.SubTaskWidgetsTable = TaskUIObj.SubTaskWidgetsTable or {}
    if TaskUIObj.Panel_Lock:GetVisibility() == ESlateVisibility.Visible then
        TaskUIObj.Title:SetVisibility(ESlateVisibility.Collapsed)
    end
    if self.AllQuestOptions and TaskUIObj.VBox_SubTasks:GetChildrenCount() == 0 then
        local SubTaskIndex = 1
        for _, BranchQuestInfo in pairs(self.AllQuestOptions) do
            if BranchQuestInfo.BranchQuestName ~= "" then
                local ChildQuestWidget = UIManager:CreateWidget('/Game/UI/WBP/Battle/Widget/TaskBar/WBP_Battle_TaskBar_SubTask.WBP_Battle_TaskBar_SubTask')
                ChildQuestWidget.Text_Describe:SetText(GText(BranchQuestInfo["BranchQuestName"]))
                TaskUIObj.VBox_SubTasks:AddChildToVerticalBox(ChildQuestWidget)
                TaskUIObj.SubTaskWidgetsTable["Branch_"..tostring(SubTaskIndex)] = ChildQuestWidget
                TaskUIObj.VBox_SubTasks:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                -- if self.IsDifftation then
                --     ChildQuestWidget.WS_Type:SetActiveWidgetIndex(1)
                --     ChildQuestWidget:SetABCImg(SubTaskIndex)
                --     ChildQuestWidget.DiffGuideInfos = self.AllDiffGuideOptions[SubTaskIndex]
                -- end
                ChildQuestWidget:PlayAnimation(ChildQuestWidget.In)
                ChildQuestWidget.SubTaskIndex = SubTaskIndex
                ChildQuestWidget:SetBranchInfo(BranchQuestInfo.TargetBranchQuestKey, GText(BranchQuestInfo["BranchQuestName"]))
            end
            SubTaskIndex = SubTaskIndex + 1
        end
    elseif self.AllQuestOptions and TaskUIObj.VBox_SubTasks:GetChildrenCount() ~= 0 then --当上一个子任务节点还在播完成动效就开始了新的子任务节点的情况
        local FirstChildWidget = TaskUIObj.VBox_SubTasks:GetChildAt(0)
        if IsValid(FirstChildWidget) and FirstChildWidget:IsPlayingAnimation(FirstChildWidget.CompletionTask) then
            FirstChildWidget:BindToAnimationFinished(FirstChildWidget.CompletionTask, {FirstChildWidget, 
            function()
                FirstChildWidget:UnbindAllFromAnimationFinished(FirstChildWidget.CompletionTask)
                local Avatar = GWorld:GetAvatar()
                if not Avatar then
                    return
                end
                local ChainId = self.QuestChainId
                if Avatar.InSpecialQuest and ClientEventUtils:GetCurrentEvent() and ClientEventUtils:GetCurrentEvent().PreQuestChainId then
                    ChainId = ClientEventUtils:GetCurrentEvent().PreQuestChainId
                end
            
                if Avatar.TrackingQuestChainId == ChainId then
                    local SubTaskIndex = 1
                    for _, BranchQuestInfo in pairs(self.AllQuestOptions) do
                        if BranchQuestInfo.BranchQuestName ~= "" then
                            local ChildQuestWidget = UIManager:CreateWidget('/Game/UI/WBP/Battle/Widget/TaskBar/WBP_Battle_TaskBar_SubTask.WBP_Battle_TaskBar_SubTask')
                            ChildQuestWidget.Text_Describe:SetText(GText(BranchQuestInfo["BranchQuestName"]))
                            TaskUIObj.VBox_SubTasks:AddChildToVerticalBox(ChildQuestWidget)
                            TaskUIObj.SubTaskWidgetsTable["Branch_"..tostring(SubTaskIndex)] = ChildQuestWidget
                            TaskUIObj.VBox_SubTasks:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                            -- if self.IsDifftation then
                            --     ChildQuestWidget.WS_Type:SetActiveWidgetIndex(SubTaskIndex)
                            --     ChildQuestWidget:SetABCImg(SubTaskIndex)
                            --     ChildQuestWidget.DiffGuideInfos = self.AllDiffGuideOptions[SubTaskIndex]
                            -- end
                            ChildQuestWidget:PlayAnimation(ChildQuestWidget.In)
                            ChildQuestWidget.SubTaskIndex = SubTaskIndex
                            ChildQuestWidget:SetBranchInfo(BranchQuestInfo.TargetBranchQuestKey, GText(BranchQuestInfo["BranchQuestName"]))
                        end
                        SubTaskIndex = SubTaskIndex + 1
                    end
                end
            end})
        else
            TaskUIObj.VBox_SubTasks:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

            local Index = 0
            if not IsEmptyTable(self.AllQuestOptions) then
                for _, BranchQuestInfo in pairs(self.AllQuestOptions) do
                    if BranchQuestInfo.BranchQuestName ~= "" then
                        local ChildWidget = TaskUIObj.VBox_SubTasks:GetChildAt(Index)
                        if IsValid(ChildWidget) then
                            ChildWidget:PlayAnimation(ChildWidget.In)
                            Index = Index + 1
                            ChildWidget.SubTaskIndex = Index
                            ChildWidget:SetBranchInfo(BranchQuestInfo.TargetBranchQuestKey, GText(BranchQuestInfo["BranchQuestName"]))
                        end
                    end
                end
            end
        end
    end
    if TaskUIObj and TaskUIObj.VBox_SubTasks:GetChildrenCount() ~= 0 then
        TaskUIObj:TriggerQuestTrackPanelTips(false)
    end
    if not self.HasFinished then
        self:FinishAction()
    end
end

function BranchQuestStartNode:FinishAction()
    self:Finish()
end

function BranchQuestStartNode:ClearWhenQuestSuccess()
	TaskUtils:ClearQuestExtraInfo(self.CurQuestChainId, self.CurDoingQuestId, self.Key)
end

 function BranchQuestStartNode:ClearWhenQuestFail()
	TaskUtils:ClearQuestExtraInfo(self.CurQuestChainId, self.CurDoingQuestId, self.Key)
    local TaskUIObj = TaskUtils:GetTaskBarWidget()
    if not IsEmptyTable(TaskUIObj.SubTaskWidgetsTable) then
        for Name, Widget in pairs(TaskUIObj.SubTaskWidgetsTable) do
            if IsValid(Widget) and TaskUIObj.VBox_SubTasks:HasChild(Widget) then
                TaskUIObj.VBox_SubTasks:RemoveChild(Widget)
                TaskUIObj.SubTaskWidgetsTable[Name] = nil
            end
        end
        TaskUIObj.SubTaskWidgetsTable = {}
    end
end

function BranchQuestStartNode:Clear()
end

return BranchQuestStartNode