local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"
local ReturnUtils = require "Blueprints.UI.WBP.Activity.Widget.Return.ReturnUtils"

---@class ReturnTaskRewardModel
local ReturnTaskRewardModel = {}

function ReturnTaskRewardModel:GetReturnQuestContents(CurrentEventId, PhaseIndex, ParentWidget)
    local CurrentEventId = CurrentEventId or DataMgr.ComeBackEventConstant.CurrentEventId.ConstantValue
    if not PhaseIndex then
        GWorld.logger.error("ReturnTaskRewardModel: PhaseIndex is nil, EventId:"..CurrentEventId)
        return
    end
    local ComeBackQuestConf = ReturnUtils.GetCurrentComeBackQuestInfo(CurrentEventId)
    if not ComeBackQuestConf or not ComeBackQuestConf.QuestPhase then
        GWorld.logger.error("ReturnTaskRewardModel: ComeBackQuestConf.QuestPhase is nil, EventId:"..CurrentEventId)
        return
    end
    local QuestPhaseId = ComeBackQuestConf.QuestPhase[PhaseIndex]
    if not QuestPhaseId then
        GWorld.logger.error("ReturnTaskRewardModel: QuestPhaseId is nil, EventId:"..CurrentEventId..", PhaseIndex:"..PhaseIndex)
        return
    end
    local QuestInfos = {}
    local QuestIds = DataMgr.QuestPhaseId2QuestId[QuestPhaseId]
    if QuestIds then
        for _, QuestId in ipairs(QuestIds) do
            table.insert(QuestInfos, DataMgr.CommonQuestDetail[QuestId])
        end
        table.sort(QuestInfos, function(a,b)
            return a.QuestId < b.QuestId
        end)
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local CommonQuestActivity = Avatar.CommonQuestActivity[CurrentEventId]
    if not CommonQuestActivity then
        GWorld.logger.error("ReturnTaskRewardModel: CommonQuestActivity is nil, EventId:"..CurrentEventId)
        return
    end
    local Items = {}
    for Index, Info in ipairs(QuestInfos) do
        local Progress = 0
        local Target = 0
        local RewardsGot = false
        if CommonQuestActivity[Info.QuestId] then
            Progress = CommonQuestActivity[Info.QuestId].Progress
            Target = CommonQuestActivity[Info.QuestId].Target
            RewardsGot = CommonQuestActivity[Info.QuestId].RewardsGot
        end
        local Item = {}
        Item.SourceNum = Index
        Item.CanReceive = false
        Item.RewardsGot = false
        if Progress < Target then
            Item.InProgress = true
            if Info.JumpUIId then
                Item.JumpUIId = Info.JumpUIId
                Item.HasGoto = true
            end
        else
            Item.InProgress = false
            if RewardsGot then
                Item.CanReceive = false
                Item.RewardsGot = true
            else
                Item.CanReceive = true
                Item.RewardsGot = false
            end
        end
        Item.NotreachText = GText("UI_Archive_CollectionInProgress")
        Item.TextProgress = string.format(GText("UI_Archive_Progress"), Progress, Target)
        Item.Hint = GText(Info.StarterQuestDes)
        Item.ReceiveCallBack = function(Widget, ReceiveAllParm)
            self:GetQuestRewards(ParentWidget or Widget, ReceiveAllParm)
        end
        Item.ReceiveParm = {EventId = CurrentEventId, QuestPhaseId = QuestPhaseId, QuestId = Info.QuestId}
        Item.Rewards = {}
        for _, RewardId in pairs(Info.QuestReward) do
            local RewardInfo = DataMgr.Reward[RewardId]
            if RewardInfo then
                local Ids = RewardInfo.Id or {}
                local RewardCount = RewardInfo.Count or {}
                local TableName = RewardInfo.Type or {}
                for i = 1, #Ids do
                    local Content = NewObject(UIUtils.GetCommonItemContentClass())
                    local ItemId = Ids[i]
                    Content.IsShowDetails = true
                    Content.Id = ItemId
                    Content.ItemId = ItemId
                    Content.Count = RewardUtils:GetCount(RewardCount[i])
                    Content.Icon = ItemUtils.GetItemIconPath(ItemId, TableName[i])
                    Content.Rarity = ItemUtils.GetItemRarity(ItemId, TableName[i])
                    Content.ItemType = TableName[i]
                    Content.bHasGot = Item.RewardsGot
                    table.insert(Item.Rewards,Content)
                end
            end
        end
        table.insert(Items, Item)
    end
    return Items
end

function ReturnTaskRewardModel:CheckHaveRewardToGet(EventId, QuestPhaseId)
    return self:CheckHaveQuestRewardToGet(EventId, QuestPhaseId) or self:CheckHaveProgressRewardToGet()
end

function ReturnTaskRewardModel:CheckHaveProgressRewardToGet()
    local ComeBackQuestConf = ReturnUtils.GetCurrentComeBackQuestInfo()
    if not ComeBackQuestConf.QuestRewardProgress then
        return false
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return false end
    local ComeBackData = Avatar:GetCurrentComeBackData()
    local RewardProgressConfig = ComeBackQuestConf.QuestRewardProgress
    local CurProgress = ComeBackData.QuestProgress
    for Idx, Progress in ipairs(RewardProgressConfig) do
        if CurProgress >= Progress and not ComeBackData:HasGotProgressReward(Idx) then
            return true
        end
    end
    return false
end

function ReturnTaskRewardModel:CheckHaveQuestRewardToGet(EventId, QuestPhaseId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    return Avatar:CheckCommonQuestActivityHasRewardToGet(EventId, QuestPhaseId)
end

function ReturnTaskRewardModel:TryDecreaseQuestReddot(QuestPhaseId, QuestId, EventId)
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReturnUtils.ReddotTaskQuestKey)
    -- DebugPrint("lhr1@TryDecreaseQuestReddot", CacheDetail[QuestPhaseId], CacheDetail[QuestPhaseId] and CacheDetail[QuestPhaseId][QuestId], QuestPhaseId, QuestId)
    if CacheDetail[QuestPhaseId] and CacheDetail[QuestPhaseId][QuestId] then
        CacheDetail[QuestPhaseId][QuestId] = nil
        if next(CacheDetail[QuestPhaseId]) == nil then
            CacheDetail[QuestPhaseId] = nil
        end
        ReddotManager.DecreaseLeafNodeCount(ReturnUtils.ReddotTaskQuestKey, 1)
        local Node = ReddotManager.GetTreeNode("ComeBackTask")
        Node:TryFireOnCountChange(Node.Count, true)
        local EventId = EventId or DataMgr.ComeBackEventConstant.CurrentEventId.ConstantValue
        ActivityReddotHelper.RefreshReddotNode(EventId)
    end
end

function ReturnTaskRewardModel:TryDecreaseProgressRewardReddot(EventId)
    -- 因为进度奖励只能一次领取全部，故直接清空红点数
    local Node  = ReddotManager.GetTreeNode(ReturnUtils.ReddotTaskRewardKey)
    -- DebugPrint("lhr1@TryDecreaseQuestReddot", Node.Count)
    if Node.Count > 0 then
        ReddotManager.ClearLeafNodeCount(ReturnUtils.ReddotTaskRewardKey, true)
        local TaskNode = ReddotManager.GetTreeNode("ComeBackTask")
        TaskNode:TryFireOnCountChange(TaskNode.Count, true)
        local EventId = EventId or DataMgr.ComeBackEventConstant.CurrentEventId.ConstantValue
        ActivityReddotHelper.RefreshReddotNode(EventId)
    end
end

function ReturnTaskRewardModel:GetQuestRewards(RewardItem,Content)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local Callback = function (Ret,Rewards)
            local Progress = 0
            local Target = 0
            local RewardsGot = false
            local CommonQuestActivity = Avatar.CommonQuestActivity[Content.ConfigData.ReceiveParm.EventId]
            if CommonQuestActivity and CommonQuestActivity[Content.ConfigData.ReceiveParm.QuestId] then
                Progress = CommonQuestActivity[Content.ConfigData.ReceiveParm.QuestId].Progress
                Target = CommonQuestActivity[Content.ConfigData.ReceiveParm.QuestId].Target
                RewardsGot = CommonQuestActivity[Content.ConfigData.ReceiveParm.QuestId].RewardsGot
            end
            Content.ConfigData.CanReceive = false
            Content.ConfigData.RewardsGot = false
            if Progress < Target then
                Content.ConfigData.InProgress = true
            else
                Content.ConfigData.InProgress = false
                if RewardsGot then
                    Content.ConfigData.CanReceive = false
                    Content.ConfigData.RewardsGot = true
                else
                    Content.ConfigData.CanReceive = true
                    Content.ConfigData.RewardsGot = false
                end
            end
            if Content.OnGetReward then
                Content.OnGetReward(RewardsGot)
            end
            local RewardWidget = Content.SelfWidget
            if IsValid(RewardWidget) and RewardWidget.Content == Content then
                RewardWidget:RefreshBtn(Ret==0)
                if Ret==0 then
                    RewardWidget:PlayAnimation(RewardWidget.Received)
                end
            end
            Content.Owner:RefreshButton(self:CheckHaveRewardToGet(Content.ConfigData.ReceiveParm.EventId, Content.ConfigData.ReceiveParm.QuestPhaseId))
            self:TryDecreaseQuestReddot(Content.ConfigData.ReceiveParm.QuestPhaseId, Content.ConfigData.ReceiveParm.QuestId, Content.ConfigData.ReceiveParm.EventId)
            ReturnUtils.RefreshComeBackTaskRewardReddot()
            if not ErrorCode:Check(Ret) then
                return
            end
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function ()
                RewardItem:SetFocus()
            end, RewardItem)
        end
        Avatar:CommonQuestActivityGetReward(Callback, Content.ConfigData.ReceiveParm.EventId, Content.ConfigData.ReceiveParm.QuestId)
    end
end

function ReturnTaskRewardModel:GetAllRewards(Widget, ReceiveAllParm)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        if not self:CheckHaveQuestRewardToGet(ReceiveAllParm.EventId, ReceiveAllParm.QuestPhaseId) then
            local Callback = function(Ret,Rewards)
                --领取完成后刷新
                if ReceiveAllParm.Callback then
                    ReceiveAllParm.Callback()
                end
                if not ErrorCode:Check(Ret) then
                    Widget:RefreshButton(self:CheckHaveProgressRewardToGet())
                    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function ()
                        Widget:SetFocus()
                    end, Widget)
                    return
                end
                Widget:RefreshButton(false)
                self:TryDecreaseProgressRewardReddot(ReceiveAllParm.EventId)
                UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function ()
                    Widget:SetFocus()
                end, Widget)
            end
            Avatar:ComeBackGetQuestProgressReward(Callback)
            return
        end
        local Callback = function (Ret,Rewards)
            for i = 0,Widget.List_Item:GetNumItems() - 1 do
                local Content = Widget.List_Item:GetItemAt(i)
                local Progress = 0
                local Target = 0
                local RewardsGot = false
                local CommonQuestActivity = Avatar.CommonQuestActivity[Content.ConfigData.ReceiveParm.EventId]
                if CommonQuestActivity and CommonQuestActivity[Content.ConfigData.ReceiveParm.QuestId] then
                    Progress = CommonQuestActivity[Content.ConfigData.ReceiveParm.QuestId].Progress
                    Target = CommonQuestActivity[Content.ConfigData.ReceiveParm.QuestId].Target
                    RewardsGot = CommonQuestActivity[Content.ConfigData.ReceiveParm.QuestId].RewardsGot
                end
                Content.ConfigData.CanReceive = false
                Content.ConfigData.RewardsGot = false
                if Progress < Target then
                    Content.ConfigData.InProgress = true
                else
                    Content.ConfigData.InProgress = false
                    if RewardsGot then
                        Content.ConfigData.CanReceive = false
                        Content.ConfigData.RewardsGot = true
                    else
                        Content.ConfigData.CanReceive = true
                        Content.ConfigData.RewardsGot = false
                    end
                end
                if RewardsGot and ReceiveAllParm.OnGetReward then
                    ReceiveAllParm.OnGetReward(Content)
                end
                local RewardWidget = Content.SelfWidget
                if IsValid(RewardWidget) and RewardWidget.Content == Content then
                    RewardWidget:RefreshBtn(Content.ConfigData.RewardsGot)
                    if Content.ConfigData.RewardsGot then
                        RewardWidget:PlayAnimation(RewardWidget.Received)
                    end
                end
                self:TryDecreaseQuestReddot(ReceiveAllParm.QuestPhaseId, Content.ConfigData.ReceiveParm.QuestId, Content.ConfigData.ReceiveParm.EventId)
            end
            if not ErrorCode:Check(Ret) or not self:CheckHaveProgressRewardToGet() then
                Widget:RefreshButton(self:CheckHaveRewardToGet(ReceiveAllParm.EventId, ReceiveAllParm.QuestPhaseId))
                if ReceiveAllParm.Callback then
                    ReceiveAllParm.Callback()
                end
                UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function ()
                    Widget:SetFocus()
                end, Widget)
                return
            end
            local SecondCallback = function(SecondRet,SecondRewards)
                --领取完成后刷新
                if ReceiveAllParm.Callback then
                    ReceiveAllParm.Callback()
                end
                if not ErrorCode:Check(SecondRet) then
                    Widget:RefreshButton(self:CheckHaveProgressRewardToGet())
                    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function ()
                        Widget:SetFocus()
                    end, Widget)
                    return
                end
                Widget:RefreshButton(false)
                self:TryDecreaseProgressRewardReddot(ReceiveAllParm.EventId)
                UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, self:MergeRewards(Rewards,SecondRewards), false, function ()
                    Widget:SetFocus()
                end, Widget)
            end
            Avatar:ComeBackGetQuestProgressReward(SecondCallback)
        end
        Avatar:CommonQuestActivityGetPhaseReward(Callback, ReceiveAllParm.EventId, ReceiveAllParm.QuestPhaseId)
    end
end

function ReturnTaskRewardModel:MergeRewards(Rewards, NewRewards)
    if not Rewards and not NewRewards then
        return {}
    end
    if Rewards and not NewRewards then
        return Rewards
    end
    if NewRewards and not Rewards then
        return NewRewards
    end
    for TypeName, TypeTable in pairs(NewRewards) do
        if Rewards[TypeName] then
            for RewardId, RewardTable in pairs(TypeTable) do
                if Rewards[TypeName][RewardId] then
                    for Tag, Num in pairs(RewardTable) do
                        if Rewards[TypeName][RewardId][Tag] then
                            Rewards[TypeName][RewardId][Tag] = Rewards[TypeName][RewardId][Tag] + Num
                        else
                            Rewards[TypeName][RewardId][Tag] = Num
                        end
                    end
                else
                    Rewards[TypeName][RewardId] = RewardTable
                end
            end
        else
            Rewards[TypeName] = TypeTable
        end
    end
    return Rewards
end

function ReturnTaskRewardModel:GetProgressReward(Widget, ReceiveAllParm)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local Callback = function (Ret,Rewards)
            --领取完成后刷新
            Widget:RefreshButton(self:CheckHaveQuestRewardToGet(ReceiveAllParm.EventId, ReceiveAllParm.QuestPhaseId))
            if ReceiveAllParm.Callback then
                ReceiveAllParm.Callback()
            end
            if not ErrorCode:Check(Ret) then
                return
            end
            self:TryDecreaseProgressRewardReddot(ReceiveAllParm.EventId)
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function ()
                Widget:SetFocus()
            end, Widget)
        end
        Avatar:ComeBackGetQuestProgressReward(Callback)
    end
end

return ReturnTaskRewardModel