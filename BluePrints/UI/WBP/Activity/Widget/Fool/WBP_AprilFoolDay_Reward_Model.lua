
---@class AprilFoolDayRewardModel
local AprilFoolDayRewardModel = {}

function AprilFoolDayRewardModel:OpenReward()
    if self:SetRewardParams() then
        local UIManager = GWorld.GameInstance:GetGameUIManager()
        UIManager:LoadUINew("AprilFoolDayReward", self.Params)
    end
end

function AprilFoolDayRewardModel:SetRewardParams()
    local AFDayEvent2026ID = DataMgr.EventConstant.AFDayEvent2026ID.ConstantValue
    local EndTime = nil
    if AFDayEvent2026ID and DataMgr.EventMain[AFDayEvent2026ID] then
        EndTime = DataMgr.EventMain[AFDayEvent2026ID].EventEndTime
    end
    local RemainTimeDict,_ = UIUtils.GetLeftTimeStrStyle2(EndTime)
    self.Params={}
    local ConfigData={
        IsPacking = true,
        ReddotName = "AprilFoolDayReward",
        ReceiveButtonText = GText("UI_Archive_CollectionClaimAll"),
        ReceiveAllCallBack = self.GetAllRewards,
        ReceiveAllParam = {RewardModel = self, EventId = AFDayEvent2026ID},
        RemainTimeDict = RemainTimeDict,
        Items = {},
        Text_Total = GText("UI_AchievementToast_Progress"),
        SortType = 1,
        InSoundPath = "event:/ui/armory/open",
        ReceiveBtnSoundPath = "event:/ui/activity/fools_day_btn_common",
    }
    for _, Info in pairs(DataMgr.CommonQuestReward) do
        if Info.EventId == AFDayEvent2026ID then
            ConfigData.IsPacking = true
            ConfigData.PackingInfo = {
                IsShowGotoBtn = false,
                BigItem = true,
                RewardTitle = Info.Name,
                RewardDesc = "",
                BtnTips = GText("AFDayEvent_GrandReward_Tips"),
                ReceveCallBack = self.GetFinishReward,
                ReceveParam = {RewardModel = self, EventId = AFDayEvent2026ID, FinishRewardId = Info.Id},
                BigItemInfo = {
                    BGIconPath = Info.Icon
                },
                CheckDetailCallBack = function (Widget, CheckDetailParam)
                    if CheckDetailParam and CheckDetailParam.RewardId then
                        local RewardInfo = DataMgr.Reward[CheckDetailParam.RewardId]
                        if RewardInfo and RewardInfo.Type and RewardInfo.Type[1] then
                            if RewardInfo.Type[1] == "CharAccessory" then
                                local AccessoryId = RewardInfo.Id[1]
                                local UIManager = GWorld.GameInstance:GetGameUIManager()
                                UIManager:LoadUINew("ArmorySkin", {Type = "Char", AccessoryId = AccessoryId})
                            end
                        end
                    end
                end,
                CheckDetailParam = {RewardId = Info.Reward},
                ReceiveBtnSoundPath = "event:/ui/activity/fools_day_btn_common",
            }
            break
        end
    end
    local QuestInfos = {}
    local QuestPhaseId = nil
    for _, Info in pairs(DataMgr.CommonQuestDetail) do
        if Info.EventId and Info.EventId == AFDayEvent2026ID then
            table.insert(QuestInfos, Info)
            if not QuestPhaseId then
                QuestPhaseId = Info.QuestPhaseId
            elseif QuestPhaseId ~= Info.QuestPhaseId then
                DebugPrint("AprilFoolDayReward CommonQuestDetail Has Multiple QuestPhaseIds")
                return false
            end
        end
    end
    ConfigData.ReceiveAllParam.QuestPhaseId = QuestPhaseId
    table.sort(QuestInfos, function(a,b)
        return a.QuestId < b.QuestId
    end)
    local NowNum = 0
    local NumMax = 0
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    local CommonQuestActivity = Avatar.CommonQuestActivity[AFDayEvent2026ID]
    if not CommonQuestActivity then
        return
    end
    if ConfigData.IsPacking then
        if Avatar.CommonQuestBases and Avatar.CommonQuestBases[ConfigData.PackingInfo.ReceveParam.EventId] and Avatar.CommonQuestBases[ConfigData.PackingInfo.ReceveParam.EventId]:IsFinishRewardGot(ConfigData.PackingInfo.ReceveParam.FinishRewardId) then
            ConfigData.PackingInfo.IsGot = true
            ConfigData.PackingInfo.CanReceive = false
            ConfigData.PackingInfo.InProgress = false
        else
            if Avatar:CheckCommonQuestActivityHasFinishRewardToGet(ConfigData.PackingInfo.ReceveParam.FinishRewardId) then
                ConfigData.PackingInfo.IsGot = false
                ConfigData.PackingInfo.CanReceive = true
                ConfigData.PackingInfo.InProgress = false
            else
                ConfigData.PackingInfo.IsGot = false
                ConfigData.PackingInfo.CanReceive = false
                ConfigData.PackingInfo.InProgress = true
            end
        end
    end
    for Index,Info in ipairs(QuestInfos) do
        NumMax = NumMax + 1
        local Progress = 0
        local Target = 0
        local RewardsGot = false
        if CommonQuestActivity[Info.QuestId] then
            Progress = CommonQuestActivity[Info.QuestId].Progress
            Target = CommonQuestActivity[Info.QuestId].Target
            RewardsGot = CommonQuestActivity[Info.QuestId].RewardsGot
        end
        local Item = {}
        Item.ItemId = Index
        Item.CanReceive = false
        Item.RewardsGot = false
        if Progress < Target then
            Item.InProgress = true
        else
            NowNum = NowNum + 1
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
        Item.ReceiveCallBack = self.GetRewards
        Item.ReceiveParm = {RewardModel = self, EventId = AFDayEvent2026ID, QuestPhaseId = Info.QuestPhaseId, QuestId = Info.QuestId}
        Item.ReceiveBtnSoundPath = "event:/ui/activity/fools_day_btn_common"
        Item.Rewards = {}
        Item.HideProgressAfterGot = true
        if Info.QuestReward then
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
        end
        ConfigData.ShowSourceNum = true
        ConfigData.NowNum = NowNum
        ConfigData.NumMax = NumMax
        table.insert(ConfigData.Items, Item)
    end
    self.Params.ConfigData = ConfigData
    self.Params.Title = GText("UI_ArchiveCollectionReward")
    return true
end

function AprilFoolDayRewardModel.GetRewards(RewardItem,Content)
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
            if Content.ConfigData.Rewards then
                for _,Reward in pairs(Content.ConfigData.Rewards) do
                    Reward.bHasGot = Content.ConfigData.RewardsGot
                end
            end
            Content.SelfWidget:RefreshBtn(Ret==0)
            Content.Owner:RefreshButton(Content.ConfigData.ReceiveParm.RewardModel:CheckHaveRewardToGet(Content.ConfigData.ReceiveParm.EventId, Content.ConfigData.ReceiveParm.QuestPhaseId))
            Content.ConfigData.ReceiveParm.RewardModel:RefreshReddotInfo(Content.ConfigData.ReceiveParm.QuestId)
            Content.SelfWidget:RefreshItems()
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

function AprilFoolDayRewardModel:CheckHaveRewardToGet(EventId, QuestPhaseId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    return Avatar:CheckCommonQuestActivityHasRewardToGet(EventId, QuestPhaseId)
end

function AprilFoolDayRewardModel:RefreshReddotInfo(QuestId)
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("ArchiveReward")
    if CacheDetail[QuestId] then
        CacheDetail[QuestId] = nil
        ReddotManager.DecreaseLeafNodeCount("ArchiveReward")
    end
end

function AprilFoolDayRewardModel.GetAllRewards(Widget, ReceiveAllParm)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local Callback = function (Ret,Rewards)
            for i = 0,ReceiveAllParm.SelfWidget.List_Item:GetNumItems() - 1 do
                local Content = ReceiveAllParm.SelfWidget.List_Item:GetItemAt(i)
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
                if Content.ConfigData.Rewards then
                    for _,Reward in pairs(Content.ConfigData.Rewards) do
                        Reward.bHasGot = Content.ConfigData.RewardsGot
                    end
                end
                if Content.SelfWidget then
                    Content.SelfWidget:RefreshBtn(Content.ConfigData.RewardsGot)
                end
                Content.ConfigData.ReceiveParm.RewardModel:RefreshReddotInfo(Content.ConfigData.ReceiveParm.QuestId)
            end
            ReceiveAllParm.SelfWidget:RefreshButton(ReceiveAllParm.RewardModel:CheckHaveRewardToGet(ReceiveAllParm.EventId, ReceiveAllParm.QuestPhaseId))
            ReceiveAllParm.SelfWidget:RefreshItems()
            if not ErrorCode:Check(Ret) then
                return
            end
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function ()
                ReceiveAllParm.SelfWidget:SetFocus()
            end, ReceiveAllParm.SelfWidget)
        end
        Avatar:CommonQuestActivityGetPhaseReward(Callback, ReceiveAllParm.EventId, ReceiveAllParm.QuestPhaseId)
    end
end

function AprilFoolDayRewardModel.GetFinishReward(Widget, ReceiveParm)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local Callback = function (Ret,Rewards)
            --领取完成后刷新
            Widget:RefreshPackingGetBtn(Avatar:CheckCommonQuestActivityHasRewardToGet(ReceiveParm.FinishRewardId),true)
            if not ErrorCode:Check(Ret) then
                return
            end
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function ()
                Widget:SetFocus()
            end, Widget)
        end
        Avatar:CommonQuestActivityGetFinishReward(Callback, ReceiveParm.FinishRewardId)
    end
end

return AprilFoolDayRewardModel