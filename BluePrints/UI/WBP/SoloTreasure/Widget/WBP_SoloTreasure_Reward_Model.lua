---@class SoloTreasure
local SoloTreasure = {}
local EastSeasonQuestUtils = require "BluePrints.UI.WBP.Activity.Widget.EastSeason.EastSeasonQuestUtils"

SoloTreasure.ReddotRewardKey = "SoloTreasureReward"
SoloTreasure.ReddotRewardLimitKey = "SoloTreasureRewardLimit"
function SoloTreasure:OpenReward(IsLimit)
    self:RefreshReddotInfo(true)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local Params = self:MakeRewardData(CommonConst.SoloTreasureEventId,IsLimit)
    UIManager:LoadUINew("ActivityRewardPacking", Params)
end

function SoloTreasure:MakeRewardData(EventId,IsLimit)
    local Avatar = GWorld:GetAvatar()
    local Params = {}
    local ReddotName = self.ReddotRewardKey
    if IsLimit then
        ReddotName = self.ReddotRewardLimitKey
    end
    Params.ConfigData = {}
    Params.ConfigData.TabInfo = {}
    Params.ConfigData.Items = {}
    Params.ConfigData.HasTab = true
    Params.ConfigData.Datas = {}
    Params.ConfigData.InSoundPath="event:/ui/armory/open"
    Params.ConfigData.OutSoundPath="event:/ui/armory/open"
    Params.ConfigData.TabSoundPath="event:/ui/activity/auto_chess_mid_btn_click"
    Params.ConfigData.IsPacking = true
    Params.ConfigData.RefreshPanleCallBack = function(Widget)
        if Widget then
            self:RefreshConfigData(CommonConst.SoloTreasureEventId,Widget)
            Widget:RefreshItems()
        end
    end
    local LimitTaskIdMap = {}
    if DataMgr.TreasureHuntEvent[EventId] and DataMgr.TreasureHuntEvent[EventId].LimitTaskId then
        for _, TaskId in pairs(DataMgr.TreasureHuntEvent[EventId].LimitTaskId) do
            LimitTaskIdMap[TaskId] = true
        end
    end
    Params.ConfigData.IsPacking = true
    if IsLimit then
        Params.ConfigData.TopText = GText("UI_SoloTreasure_LimitedReward")
       for _, Info in pairs(DataMgr.CommonQuestReward) do
            if Info.EventId == CommonConst.SoloTreasureEventId then
                Params.ConfigData.PackingInfo = {
                    IsShowGotoBtn = false,
                    BigItem = true,
                    RewardTitle = Info.Name,
                    RewardDesc = "",
                    BtnTips = string.format(GText("UI_SoloTreasure_LimitBigRewardDes"), tostring(DataMgr.CommonQuestReward[CommonConst.SoloTreasureEventId].SpecifiedCount)),
                    ReceveCallBack = self.GetFinishReward,
                    ReceveParam = {RewardModel = self, EventId = CommonConst.SoloTreasureEventId, FinishRewardId = Info.Id},
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
                                if RewardInfo and RewardInfo.Type and RewardInfo.Type[1] then
                                    if RewardInfo.Type[1] == "Pet" then
                                        local PetId = RewardInfo.Id[1]
                                        UIManager(self):LoadUINew('ArmoryDetail',{PreviewPetIds = {PetId}, EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon})
                                    end
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
    else
        Params.ConfigData.TopText = GText("UI_SoloTreasure_PermanentReward")
        local RewardViewId = DataMgr.TreasureHuntEvent[EventId].PermanentTaskRewardView
        local RewardInfo = DataMgr.RewardView[RewardViewId]
        Params.ConfigData.PackingInfo = {
            IsShowGotoBtn = false,
            SmallItem = true,
            RewardDesc = "",
            BtnDetailTips = GText(string.format("UI_SoloTreasure_PermanentBigRewardDes", tostring(DataMgr.TreasureHuntEvent[CommonConst.SoloTreasureEventId].RewardRequireFinishTasks))),
        } 
        if RewardInfo.Type[1] == "Resource" then
            local Id= RewardInfo.Id[1]
            local RewardContent = {}
            if RewardInfo then
                local Ids = RewardInfo.Id or {}
                local RewardCount = RewardInfo.Count or {}
                local TableName = RewardInfo.Type or {}
                local ItemId = Ids[1]
                local Count = RewardUtils:GetCount(RewardCount[1])
                local Icon = ItemUtils.GetItemIconPath(ItemId, TableName[1])
                local Rarity = ItemUtils.GetItemRarity(ItemId, TableName[1])
                local ItemType = TableName[1]
                RewardContent.Id = ItemId
                if Count ~= 0 then
                    RewardContent.Count = Count
                end
                RewardContent.Icon= Icon
                RewardContent.Rarity = Rarity
                RewardContent.ItemType = ItemType
                RewardContent.IsShowDetails = true
                RewardContent.MenuPlacement = EMenuPlacement.MenuPlacement_MenuLeft   
            end
            Params.ConfigData.PackingInfo.SmallItemInfo={
                  IsHeadIcon=false,
                  ComItemInfo=RewardContent,
                }
                if DataMgr.Resource[Id] then
                    Params.ConfigData.PackingInfo.RewardTitle = DataMgr.Resource[Id].ResourceName
                    Params.ConfigData.PackingInfo.RewardDesc = DataMgr.Resource[Id].DetailDes
                end
        elseif RewardInfo.Type[1] == "HeadFrame" then
            local Id= RewardInfo.Id[1]
            if DataMgr.HeadFrame[Id] then
                Params.ConfigData.PackingInfo.RewardTitle = DataMgr.HeadFrame[Id].Name
                Params.ConfigData.PackingInfo.RewardDesc = DataMgr.HeadFrame[Id].Des
            end
            Params.ConfigData.PackingInfo.SmallItemInfo={
                  IsHeadIcon=true,
                  --ComItemInfo=RewardContent,
                  HeadFrameId=Id,
                }
        elseif RewardInfo.Type[1] == "HeadSculpture" then
            local Id= RewardInfo.Id[1]
            if DataMgr.HeadSculpture[Id] then
                Params.ConfigData.PackingInfo.RewardTitle = DataMgr.HeadSculpture[Id].Name
                Params.ConfigData.PackingInfo.RewardDesc = DataMgr.HeadSculpture[Id].Des
            end
            Params.ConfigData.PackingInfo.SmallItemInfo={
                  IsHeadIcon=true,
                  --ComItemInfo=RewardContent,
                  HeadIconId=Id,
                }
        elseif RewardInfo.Type[1] == "CharAccessory" then
            local Id= RewardInfo.Id[1]
            if DataMgr.CharAccessory[Id] then
                Params.ConfigData.PackingInfo.RewardTitle = DataMgr.CharAccessory[Id].Name
                Params.ConfigData.PackingInfo.RewardDesc = DataMgr.CharAccessory[Id].Des
            end
            Params.ConfigData.PackingInfo.SmallItem = false
            Params.ConfigData.PackingInfo.BigItem = true
            Params.ConfigData.PackingInfo.BigItemInfo={
                  BGIconPath =  DataMgr.CharAccessory[Id].Icon
                }
            Params.ConfigData.PackingInfo.CheckDetailCallBack = function (Widget, CheckDetailParam)
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
                    end
             Params.ConfigData.PackingInfo.CheckDetailParam = {RewardId = Id}
        elseif RewardInfo.Type[1] == "Pet" then
            local Id= RewardInfo.Id[1]
            if DataMgr.Pet[Id] then
                Params.ConfigData.PackingInfo.RewardTitle = DataMgr.Pet[Id].Name
                Params.ConfigData.PackingInfo.RewardDesc = DataMgr.Pet[Id].IpDes
            end
            Params.ConfigData.PackingInfo.SmallItem = false
            Params.ConfigData.PackingInfo.BigItem = true
            Params.ConfigData.PackingInfo.BigItemInfo={
                  BGIconPath =  DataMgr.Pet[Id].Icon
                }
            Params.ConfigData.PackingInfo.CheckDetailCallBack = function (Widget, CheckDetailParam)
                        if CheckDetailParam and CheckDetailParam.RewardId then
                             UIManager(self):LoadUINew('ArmoryDetail',{PreviewPetIds = {CheckDetailParam.RewardId}, EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon})
                        end
                    end
             Params.ConfigData.PackingInfo.CheckDetailParam = {RewardId = Id}
        end
    end
    local SortedInfo = {}
    for QuestPhaseId, PhaseConfig in pairs(DataMgr.CommonQuestPhase) do
        if PhaseConfig.EventId == EventId then
            if IsLimit then
                if LimitTaskIdMap[PhaseConfig.QuestPhaseId] then
                    table.insert(SortedInfo, PhaseConfig)
                end
            else
                if not LimitTaskIdMap[PhaseConfig.QuestPhaseId] then
                    table.insert(SortedInfo, PhaseConfig)
                end
            end
        end
    end
    table.sort(
        SortedInfo,
        function(a, b)
            return a.Index < b.Index
        end
    )
    local EndTime = nil
    if DataMgr.EventMain[CommonConst.SoloTreasureEventId] then
        EndTime = DataMgr.EventMain[CommonConst.SoloTreasureEventId].PermanenEventTime
    end
    local RemainTimeDict,Count = UIUtils.GetLeftTimeStrStyle2(EndTime)
    Params.ConfigData.RemainTimeDict=RemainTimeDict
    Params.ConfigData.IsExpired = Count == 0
    if Params.ConfigData.IsPacking and IsLimit then
        if Avatar.CommonQuestBases and Avatar.CommonQuestBases[Params.ConfigData.PackingInfo.ReceveParam.EventId] and Avatar.CommonQuestBases[Params.ConfigData.PackingInfo.ReceveParam.EventId]:IsFinishRewardGot(Params.ConfigData.PackingInfo.ReceveParam.FinishRewardId) then
            Params.ConfigData.PackingInfo.IsGot = true
            Params.ConfigData.PackingInfo.CanReceive = false
            Params.ConfigData.PackingInfo.InProgress = false
        else
            if Avatar:CheckCommonQuestActivityHasFinishRewardToGet(Params.ConfigData.PackingInfo.ReceveParam.FinishRewardId) then
                Params.ConfigData.PackingInfo.IsGot = false
                Params.ConfigData.PackingInfo.CanReceive = true
                Params.ConfigData.PackingInfo.InProgress = false
            else
                Params.ConfigData.PackingInfo.IsGot = false
                Params.ConfigData.PackingInfo.CanReceive = false
                Params.ConfigData.PackingInfo.InProgress = true
            end
        end
    end
    for _, PhaseConfig in pairs(SortedInfo) do
        local QuestPhaseId = PhaseConfig.QuestPhaseId
        local TabIndex = 1
        if PhaseConfig.EventId == EventId then
            local TabItem = {}
            TabItem.Index = TabIndex
            TabIndex = TabIndex + 1
            TabItem.Type = QuestPhaseId
            TabItem.Title = PhaseConfig.QuestPhaseName
            TabItem.ReddotName = ReddotName
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
                    Item.ReddotName = ReddotName
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
    Params.ConfigData.ReddotName = ReddotName
    return Params
end

function SoloTreasure:GetFinishReward(Widget, ReceiveParm)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local Callback = function (Ret,Rewards)
            --领取完成后刷新
            Widget:RefreshPackingGetBtn(Avatar:CheckCommonQuestActivityHasRewardToGet(ReceiveParm.FinishRewardId),true)
            if not ErrorCode:Check(Ret) then
                return
            end
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function ()
                Widget:ScrollToSelectTab()
            end, Widget)
        end
        Avatar:CommonQuestActivityGetFinishReward(Callback, ReceiveParm.FinishRewardId)
    end
end

function SoloTreasure:GetAllRewards(ReceiveAllParm)
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
                    --ReceiveAllParm.SelfWidget:ScrollToSelectTab()
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

function SoloTreasure:GetReward(Content)
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

function SoloTreasure:RefreshReddotInfo(ClearCache)
    self:RefreshReddotInfoInternal(self.ReddotRewardKey, ClearCache)
     self:RefreshReddotInfoInternal(self.ReddotRewardLimitKey, ClearCache)
end
function SoloTreasure:RefreshReddotInfoInternal(ReddotKey, ClearCache)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local SoloTreasureEventId = CommonConst.SoloTreasureEventId
    local CommonQuestActivity = Avatar.CommonQuestActivity[SoloTreasureEventId]
    if not CommonQuestActivity then
        return
    end
    local LimitTaskIdMap = {}
    if DataMgr.TreasureHuntEvent[SoloTreasureEventId] and DataMgr.TreasureHuntEvent[SoloTreasureEventId].LimitTaskId then
        for _, TaskId in pairs(DataMgr.TreasureHuntEvent[SoloTreasureEventId].LimitTaskId) do
            LimitTaskIdMap[TaskId] = true
        end
    end
    pcall(
        function()
            local Node = ReddotManager.GetTreeNode(ReddotKey)
            if not Node then
                ReddotManager.AddNodeEx(ReddotKey)
            end
            if ClearCache then
                ReddotManager.ClearLeafNodeCount(ReddotKey)
                local NodeCache = ReddotManager._GetLeafNodeCache(ReddotKey)
                NodeCache.Detail = {}
            end
            local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotKey)
            for QuestPhaseId, PhaseConfig in pairs(DataMgr.CommonQuestPhase) do
                if PhaseConfig.EventId == SoloTreasureEventId then
                    for QuestId, Config in pairs(DataMgr.CommonQuestDetail) do
                        if Config.QuestPhaseId == QuestPhaseId then -- 增加红点计数
                            if ReddotKey == self.ReddotRewardLimitKey then
                                if not LimitTaskIdMap[PhaseConfig.QuestPhaseId] then
                                    goto continue
                                end
                            else
                                if LimitTaskIdMap[PhaseConfig.QuestPhaseId] then
                                    goto continue
                                end
                            end
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
                                    ReddotManager.IncreaseLeafNodeCount(ReddotKey)
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

function SoloTreasure:RefreshConfigData(EventId, Widget)
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

return SoloTreasure