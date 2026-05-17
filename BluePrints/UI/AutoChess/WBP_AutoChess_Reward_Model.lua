---@class AutoChessRewardModel
local AutoChessRewardModel = {}
local EastSeasonQuestUtils = require "BluePrints.UI.WBP.Activity.Widget.EastSeason.EastSeasonQuestUtils"

AutoChessRewardModel.ReddotRewardKey = "AutoChessReward"
function AutoChessRewardModel:OpenReward()
    self:RefreshReddotInfo(true)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local Params = self:MakeRewardData(CommonConst.AutoChessEventId)
    UIManager:LoadUINew("AutoChessReward", Params)
end

function AutoChessRewardModel:MakeRewardData(EventId)
    local Avatar = GWorld:GetAvatar()
    local Params = {}
    Params.ConfigData = {}
    Params.ConfigData.TabInfo = {}
    Params.ConfigData.Items = {}
    Params.ConfigData.HasTab = true
    Params.ConfigData.Datas = {}
    Params.ConfigData.InSoundPath="event:/ui/armory/open"
    Params.ConfigData.OutSoundPath="event:/ui/armory/open"
    Params.ConfigData.TabSoundPath="event:/ui/activity/auto_chess_mid_btn_click"
    Params.ConfigData.RefreshPanleCallBack = function(Widget)
        if Widget then
            self:RefreshConfigData(CommonConst.AutoChessEventId,Widget)
            Widget:RefreshItems()
        end
    end  
    local SortedInfo = {}
    for QuestPhaseId, PhaseConfig in pairs(DataMgr.CommonQuestPhase) do
        if PhaseConfig.EventId == EventId then
            table.insert(SortedInfo, PhaseConfig)
        end
    end
    table.sort(
        SortedInfo,
        function(a, b)
            return a.Index < b.Index
        end
    )
    local EndTime = nil
    if DataMgr.EventMain[CommonConst.AutoChessEventId] then
        EndTime = DataMgr.EventMain[CommonConst.AutoChessEventId].EventEndTime
    end
    local RemainTimeDict,Count = UIUtils.GetLeftTimeStrStyle2(EndTime)
    Params.ConfigData.RemainTimeDict=RemainTimeDict
    Params.ConfigData.IsExpired = Count == 0
    for _, PhaseConfig in pairs(SortedInfo) do
        local QuestPhaseId = PhaseConfig.QuestPhaseId
        local TabIndex = 1
        if PhaseConfig.EventId == EventId then
            local TabItem = {}
            TabItem.Index = TabIndex
            TabIndex = TabIndex + 1
            TabItem.Type = QuestPhaseId
            TabItem.Title = PhaseConfig.QuestPhaseName
            TabItem.ReddotName = "AutoChessReward"
            TabItem.IconPath = PhaseConfig.SplineBP
            TabItem.IsShowIcon = true
            --self.Type2Index[ArchiveInfo.RLArchiveType] = Index
            table.insert(Params.ConfigData.TabInfo, TabItem)
            local RewardData = {}
            RewardData.ShowIcon = false
            RewardData.NowNum, RewardData.NumMax = EastSeasonQuestUtils:GetQuestPhaseInfo(EventId, QuestPhaseId)
            RewardData.ReceiveAllCallBack = self.GetAllRewards
            RewardData.ReceiveAllParam = {}
            RewardData.ReceiveAllParam.EventId = EventId
            RewardData.ReceiveAllParam.QuestPhaseId = QuestPhaseId
            RewardData.Type = QuestPhaseId
            RewardData.SortType = 1
            RewardData.Text_Total = string.format(GText("Abyss_RewardList_Title"))
            RewardData.ReceiveButtonText = GText("UI_Archive_CollectionClaimAll")
            local CommonQuestActivity = Avatar.CommonQuestActivity[EventId]
            if not CommonQuestActivity then
                DebugPrint("Avatar.CommonQuestActivity is nil, EvantId: ", EventId)
                return
            end
            local Items = {}
            local HasDailyQuest = false
            for QuestId, Config in pairs(DataMgr.CommonQuestDetail) do
                if Config.QuestPhaseId == QuestPhaseId then
                    local Item = {}
                    Item.ItemId = QuestId
                    if  CommonQuestActivity[QuestId] then
                        Item.CanReceive =
                        CommonQuestActivity[QuestId].Progress >= CommonQuestActivity[QuestId].Target and
                        CommonQuestActivity[QuestId].RewardsGot == false
                    end
                    Item.Type = QuestPhaseId
                    if CommonQuestActivity[QuestId] then
                        Item.RewardsGot = CommonQuestActivity[QuestId].RewardsGot
                    end
                    Item.NotreachText = GText("UI_Archive_CollectionInProgress")
                    Item.Hint = GText(Config.StarterQuestDes)
                    Item.ReddotName = "AutoChessReward"
                    Item.ReceiveButtonText = GText("UI_Archive_CollectionClaim")
                    Item.Num = Config.Target
                    if CommonQuestActivity[QuestId] then
                        Item.TextProgress="("..tostring(CommonQuestActivity[QuestId].Progress).."/"..tostring(CommonQuestActivity[QuestId].Target)..")"
                    end
                    Item.HideProgressAfterGot =true
                    Item.ReceiveCallBack = self.GetReward
                    Item.ReceiveParm = {}
                    Item.ReceiveParm.QuestId = QuestId
                    Item.ReceiveParm.EventId = EventId
                    if Config.QuestType == 2 then
                        HasDailyQuest = true
                    end
                    local Rewards = {}
                    for _, RewardItemId in ipairs(Config.QuestReward) do
                        local RewardInfo = DataMgr.Reward[RewardItemId]
                        if RewardInfo then
                            local Ids = RewardInfo.Id or {}
                            local RewardCount = RewardInfo.Count or {}
                            local TableName = RewardInfo.Type or {}
                            for i = 1, #Ids do
                                local ItemId = Ids[i]
                                local Count = RewardUtils:GetCount(RewardCount[i])
                                local Rarity = ItemUtils.GetItemRarity(ItemId, TableName[i])
                                local ItemType = TableName[i]
                                local RewardContent = {
                                    ItemType = ItemType,
                                    ItemId = ItemId,
                                    Count = Count,
                                    Rarity = Rarity
                                }
                                table.insert(Rewards, RewardContent)
                            end
                        end
                    end
                    Item.Rewards = Rewards
                    Item.LeftAligned = true
                    table.insert(Items, Item)
                end
            end
            table.sort(
                Items,
                function(a, b)
                    return a.Num < b.Num
                end
            )
            RewardData.Items = Items
            Params.ConfigData.Datas[QuestPhaseId] = RewardData
            Params.ConfigData.Datas[QuestPhaseId].HasDailyQuest = true
            if HasDailyQuest then
                Params.ConfigData.DailyRefreshFunc = function(Widget,RefreshParam)
                    if Widget then
                        self:RefreshConfigData(EventId,Widget)
                        self:RefreshReddotInfo(true)
                        Widget:RefreshDaily()
                    end
                end  
                Params.ConfigData.Datas[QuestPhaseId].NeedDailyRefresh = true
            end
        end
    end
    Params.ConfigData.Type = Params.ConfigData.TabInfo[1].Type
    Params.ConfigData.ReddotName = "AutoChessReward"
    return Params
end

function AutoChessRewardModel:GetAllRewards(ReceiveAllParm)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local function CallBack(Ret, Reward)
            DebugPrint("@@@Raid GetAllRewards CallBack")
            local HaveReWardToGet = false
            local CommonQuestActivity = Avatar.CommonQuestActivity[ReceiveAllParm.EventId]
            for i = 0, ReceiveAllParm.SelfWidget.List_Item:GetNumItems() - 1 do
                local Item = ReceiveAllParm.SelfWidget.List_Item:GetItemAt(i)
                if Item and not Item.IsEmpty and CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId] then
                    local CanReceive =
                        CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].Progress >=
                        CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].Target and
                        CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].RewardsGot == false
                    local IsGot = CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].RewardsGot
                    if CanReceive and not IsGot then
                        HaveReWardToGet = true
                    end
                    DebugPrint(
                        "@@@Raid GetAllRewards ,Type,ItemId,CanReceive,IsGot",
                        Item.ConfigData.Type,
                        Item.ConfigData.ItemId,
                        CanReceive,
                        IsGot
                    )
                    Item.ConfigData.CanReceive = CanReceive
                    Item.ConfigData.RewardsGot = IsGot
                    if Item.ConfigData.Rewards then
                        for _,Reward in pairs(Item.ConfigData.Rewards) do
                            Reward.bHasGot = Item.ConfigData.RewardsGot
                        end
                    end
                    if Item.SelfWidget then
                        Item.SelfWidget:RefreshBtn(IsGot)
                    end
                end
            end
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(
                nil,
                nil,
                nil,
                Reward,
                false,
                function()
                    ReceiveAllParm.SelfWidget:ScrollToSelectTab()
                end,
                ReceiveAllParm.SelfWidget
            )
            ReceiveAllParm.SelfWidget:RefreshButton(HaveReWardToGet)
            DebugPrint("@@@hRaid GetAllRewards HaveReWardToGet", HaveReWardToGet)
            ReceiveAllParm.SelfWidget:RefreshReddotInfo()
            ReceiveAllParm.SelfWidget:RefreshItems()
        end
        Avatar:CommonQuestActivityGetPhaseReward(CallBack, ReceiveAllParm.EventId, ReceiveAllParm.QuestPhaseId)
    end
end

function AutoChessRewardModel:GetReward(Content)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local Callback = function(ErrCode, Rewards)
            if not ErrorCode:Check(ErrCode) then
                return
            end
            DebugPrint("@@@Raid GetReward CallBack")
            local HaveReWardToGet = false
            local CommonQuestActivity = Avatar.CommonQuestActivity[Content.ConfigData.ReceiveParm.EventId]
            for i = 0, Content.Owner.List_Item:GetNumItems() - 1 do
                local Item = Content.Owner.List_Item:GetItemAt(i)
                if Item and not Item.IsEmpty and CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId] then
                    local CanReceive =
                        CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].Progress >=
                        CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].Target and
                        CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].RewardsGot == false
                    local IsGot = CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].RewardsGot
                    if CanReceive and not IsGot then
                        HaveReWardToGet = true
                    end
                    DebugPrint(
                        "@@@Raid GetReward ,Type,ItemId,CanReceive,IsGot",
                        Item.ConfigData.Type,
                        Item.ConfigData.ItemId,
                        CanReceive,
                        IsGot
                    )
                    Item.ConfigData.CanReceive = CanReceive
                    Item.ConfigData.RewardsGot = IsGot
                    if Item.SelfWidget then
                        Item.SelfWidget:RefreshBtn(IsGot)
                    end
                    if Item.ConfigData.Rewards then
                        for _,Reward in pairs(Item.ConfigData.Rewards) do
                            Reward.bHasGot = Item.ConfigData.RewardsGot
                        end
                    end
                end
            end
            Content.SelfWidget:RefreshReddotInfo()
            Content.Owner:RefreshButton(HaveReWardToGet)
            Content.SelfWidget:RefreshItems()
            DebugPrint("@@@Raid GetReward HaveReWardToGet",HaveReWardToGet)
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function ()
                Content.Owner.List_Item:SetFocus()
            end, Content.SelfWidget)
        end
        Avatar:CommonQuestActivityGetReward(
            Callback,
            Content.ConfigData.ReceiveParm.EventId,
            Content.ConfigData.ReceiveParm.QuestId
        )
    end
end

function AutoChessRewardModel:RefreshReddotInfo(ClearCache)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local AutoChessEventId = CommonConst.AutoChessEventId
    local CommonQuestActivity = Avatar.CommonQuestActivity[AutoChessEventId]
    if not CommonQuestActivity then
        return
    end

    pcall(
        function()
            local Node = ReddotManager.GetTreeNode(self.ReddotRewardKey)
            if not Node then
                ReddotManager.AddNodeEx(self.ReddotRewardKey)
            end
            if ClearCache then
                ReddotManager.ClearLeafNodeCount(self.ReddotRewardKey)
                local NodeCache = ReddotManager._GetLeafNodeCache(self.ReddotRewardKey)
                NodeCache.Detail = {}
            end
            local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(self.ReddotRewardKey)
            for QuestPhaseId, PhaseConfig in pairs(DataMgr.CommonQuestPhase) do
                if PhaseConfig.EventId == AutoChessEventId then
                    for QuestId, Config in pairs(DataMgr.CommonQuestDetail) do
                        if Config.QuestPhaseId == QuestPhaseId then -- 增加红点计数
                            local QuestData = CommonQuestActivity[QuestId]
                            if (not QuestData) or (not QuestData.Progress) or (not QuestData.Target) then
                                goto continue
                            end
                            local CanReceive = (QuestData.Progress >= QuestData.Target)
                            if (CanReceive and not QuestData.RewardsGot) then
                                if not CacheDetail[QuestPhaseId] then
                                    CacheDetail[QuestPhaseId] = {}
                                end
                                if not CacheDetail[QuestPhaseId][QuestId] then
                                    ReddotManager.IncreaseLeafNodeCount(self.ReddotRewardKey)
                                    CacheDetail[QuestPhaseId][QuestId] = 1
                                end
                            -- elseif QuestData.RewardsGot and ClearCache then  -- 减少红点计数
                            --     if CacheDetail[QuestPhaseId]
                            --     and CacheDetail[QuestPhaseId][RewardId] then
                            --         CacheDetail[QuestPhaseId][RewardId] = nil
                            --      end
                            end
                        end
                        ::continue::
                    end
                end
            end
        end
    )
end

function AutoChessRewardModel:RefreshConfigData(EventId, Widget)
    if Widget.ConfigData.Datas then
        for _, Data in pairs(Widget.ConfigData.Datas) do
            local Avatar = GWorld:GetAvatar()
            if not Avatar then
                return
            end
            local CommonQuestActivity = Avatar.CommonQuestActivity[EventId]
            if not CommonQuestActivity then
                DebugPrint("Avatar.CommonQuestActivity is nil, EvantId: ", EventId)
                return
            end
            for _, Item in pairs(Data.Items) do
                local QuestId = Item.ItemId
                if  QuestId and CommonQuestActivity[QuestId] then
                    Item.CanReceive =
                        CommonQuestActivity[QuestId].Progress >= CommonQuestActivity[QuestId].Target and
                        CommonQuestActivity[QuestId].RewardsGot == false
                    Item.RewardsGot = CommonQuestActivity[QuestId].RewardsGot
                    Item.TextProgress="("..tostring(CommonQuestActivity[QuestId].Progress).."/"..tostring(CommonQuestActivity[QuestId].Target)..")"

                end
            end
            Data.NowNum, Data.NumMax = EastSeasonQuestUtils:GetQuestPhaseInfo(EventId, Data.ReceiveAllParam.QuestPhaseId)
        end
        
    end
end

return AutoChessRewardModel