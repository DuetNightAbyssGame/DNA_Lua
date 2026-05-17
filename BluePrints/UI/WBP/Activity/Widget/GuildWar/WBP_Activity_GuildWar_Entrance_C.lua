require "UnLua"
local EastSeasonQuestUtils = require "BluePrints.UI.WBP.Activity.Widget.EastSeason.EastSeasonQuestUtils"
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"
local GuildWarUtils = require "BluePrints.UI.WBP.Activity.Widget.GuildWar.GuildWarUtils"

local M = Class("BluePrints.UI.BP_EMUserWidget_C")


function M:Construct()
    EventManager:AddEvent(EventID.OnRaidRankInfoTopN, self, self.InitOnGetTopN)  -- 正式赛排行榜
    EventManager:AddEvent(EventID.OnRaidRankInfo, self, self.InitOnRankInfoSelf)  -- 正式赛排名
    EventManager:AddEvent(EventID.OnRaidRankStart, self, self.ShowRankingButton)  -- 正式赛开启
    EventManager:AddEvent(EventID.OnResourcesChanged,self, self.RefreshShopCoinQuantity)  -- 货币数量变化

    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    -- 输入变化监听
    self:AddInputMethodChangedListen()

    -- 红点监听
    if not ReddotManager.GetTreeNode(GuildWarUtils.ReddotNodeKey) then
        ReddotManager.AddNodeEx(GuildWarUtils.ReddotNodeKey)
    end
    if not self.AddListenerFinish then
        self.AddListenerFinish = true
        ReddotManager.AddListener(GuildWarUtils.ReddotNodeKey, self, self.RefreshEntranceReddot)
        ReddotManager.AddListener(GuildWarUtils.ReddotRewardKey, self, self.RefreshQuestReddot)
    end
end

function M:Destruct()
    EventManager:RemoveEvent(EventID.OnRaidRankInfoTopN, self)  -- 正式赛排行榜
    EventManager:RemoveEvent(EventID.OnRaidRankInfo, self)  -- 正式赛排名
    EventManager:RemoveEvent(EventID.OnRaidRankStart, self)

    self:RemoveInputMethodChangedListen()
    ReddotManager.RemoveListener(GuildWarUtils.ReddotNodeKey, self)
    ReddotManager.RemoveListener(GuildWarUtils.ReddotRewardKey, self)
end

function M:Init(ActivityConfigData, PageConfigData, PlayerAvatar)
    self.Avatar = PlayerAvatar
    self.RootWidget = self.ParentWidget and self.ParentWidget.ParentWidget
    local RaidSeasons = self.Avatar.RaidSeasons[self.Avatar.CurrentRaidSeasonId]
    if not RaidSeasons then
        return
    end
    -- 三个按钮初始化
    self.Entrance_Shop:Init(self, self.GoToShopClick, "RaidDungeon_Shop_Name", "X")
    self.Entrance_Quest:Init(self, self.OnQuestBtnClicked, "RaidDungeon_Rank_Task", "Y")

    -- 显示排行榜
    self:ShowRankingButton()

    -- 商店时间
    self.EventId = RaidSeasons.EventId
    local CurEventData = DataMgr.EventMain[self.EventId]
    if CurEventData then
        self.Entrance_Shop:SetTimeText(CurEventData.EventEndTime)
    end
    -- 商店硬币
    self.CoinId = GuildWarUtils.GetCoinId(RaidSeasons.Shop)  -- 220
    self:RefreshShopCoinQuantity()
    -- 商店图标
    self.Entrance_Shop:SetCoinIconByShop(self.CoinId)
    -- 关闭通用商店
    self.ParentWidget.Group_BtnBuy:SetVisibility(UIConst.VisibilityOp["Collapsed"])

    -- 输入设备监听
    self:RefreshOpInfoByInputDevice(
        self.GameInputModeSubsystem:GetCurrentInputType(),
        self.GameInputModeSubsystem:GetCurrentGamepadName()
    )

    -- 前往按钮的红点显示由自己控制
    if self.ParentWidget and self.ParentWidget.NotNeedShowButtonActivityId then
        self.ParentWidget.NotNeedShowButtonActivityId[self.EventId] = true
    end

    self:RefreshEntranceReddot()  -- “前往”入口红点
    self:RefreshShopReddot()  -- “活动商店”红点
end

function M:ShowRankingButton()
    ---[[ 只在正式赛开始后显示排行榜
    if not GuildWarUtils.IsPreRaidTime() then
        self.Entrance_Ranking:Init(self, self.OnRankBtnClicked, "RaidDungeon_Rank", "RS")
        self.Entrance_Ranking:SetVisibility(UIConst.VisibilityOp.Visible)
        local RaidSeasons = self.Avatar.RaidSeasons[self.Avatar.CurrentRaidSeasonId]
        if RaidSeasons and RaidSeasons.PreRaidGroupId < 1 then  -- 如果预选赛没有分组，按钮置灰态
            self.ForbidRank = true
            self.Entrance_Ranking:SetForbiddenState(true)
        end
    else
        self.Entrance_Ranking:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end--]]
    --[[ 显示排行榜的测试代码
    self.Entrance_Ranking:Init(self, self.OnRankBtnClicked, "RaidDungeon_Rank", "RS")
    self.Entrance_Ranking:SetVisibility(UIConst.VisibilityOp.Visible)
    --]]
end

-- 刷新商店红点
function M:RefreshShopReddot()
    local ShowReddot = GuildWarUtils.HasShopReddot()
    if ShowReddot then
        self.Entrance_Shop:SetReddotVisibility("SelfHitTestInvisible")
    else
        self.Entrance_Shop:SetReddotVisibility("Collapsed")
    end
end

-- 刷新任务奖励红点
function M:RefreshQuestReddot(Count, RdType,Name)
    if Count > 0 then
        self.Entrance_Quest:SetReddotVisibility("SelfHitTestInvisible")
    else
        self.Entrance_Quest:SetReddotVisibility("Collapsed")
    end
end

-- 刷新入口红点
function M:RefreshEntranceReddot()
    if not GuildWarUtils.IsRaidTime() then  -- 赛事期间
        return
    end

    local Btn_Confirm = self.ParentWidget.Btn_Confirm
    if not Btn_Confirm then
        return
    end

    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(GuildWarUtils.ReddotNodeKey)
    if not CacheDetail or not CacheDetail[self.EventId] then
        Btn_Confirm:SetReddotVisibility(UIConst.VisibilityOp.Collapsed)
        return
    end

     -- 显示 & 隐藏
    if CacheDetail[self.EventId][GuildWarUtils.EntranceCacheKey] then
        Btn_Confirm:SetReddotVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        Btn_Confirm:SetReddotVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

-- 刷新商店金币数
function M:RefreshShopCoinQuantity(ResourceId)
    if ResourceId and ResourceId ~= self.CoinId then
        return
    end
    local Quantity = self.Avatar:GetResourceNum(self.CoinId)
    self.Entrance_Shop:SetCoinQuantity(Quantity)
    self:RefreshShopReddot()  -- 刷新商店红点
end

-- 尝试打开排行榜（数据准备好）
function M:TryOpenRankTopN()
    if self.RankInfo and self.TopNInfo and self.OpenRankTag  then
        self.OpenRankTag = nil
        UIManager():LoadUINew("GuildWarRank", self.RankInfo, self.TopNInfo)
    end
end

-- TOPN RPC回调
function M:InitOnGetTopN(TopNInfo)
    self.TopNInfo = TopNInfo or {}
    if self.OpenRankTag then
        self:TryOpenRankTopN()
    end
end

-- 个人排名RPC通知回调
function M:InitOnRankInfoSelf(RankInfo)
    self.RankInfo = RankInfo or {}
    if self.OpenRankTag then
        self:TryOpenRankTopN()
    end
end

-- 排行榜回调
function M:OnRankBtnClicked()
    if self.ForbidRank then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast,GText("RaidDungeon_PreRaid_Abandon_Toast"))
        return
    end

    if (not self.RootWidget) or (not self.RootWidget.BlockAllUIInput) then
        return
    end

    self.OpenRankTag = true

    self.RootWidget:BlockAllUIInput(true, "RaidSeasonGetRaidRankInfo")
    self.Avatar:RaidSeasonGetRaidRankInfo(function(ErrCode)
        self.RootWidget:BlockAllUIInput(false, "RaidSeasonGetRaidRankInfo")
        if (not ErrorCode:Check(ErrCode)) and self then
            self.RankInfo = {}
            self:TryOpenRankTopN()
        end
    end)

    self.RootWidget:BlockAllUIInput(true, "RaidSeasonGetRaidRankTopN")
    self.Avatar:RaidSeasonGetRaidRankTopN(function(ErrCode)
        self.RootWidget:BlockAllUIInput(false, "RaidSeasonGetRaidRankTopN")
        if (not ErrorCode:Check(ErrCode)) and self then
            self.TopNInfo = {}
            self:TryOpenRankTopN()
        end
    end)
end

-- 商店回调
function M:GoToShopClick()
    local PageConfigData = DataMgr.EventPortal[self.EventId]
    if (not PageConfigData.EventShop) then
        return
    end
    PageJumpUtils:JumpToTargetPageByJumpId(PageConfigData.EventShop)
end

-- 活动任务弹窗关闭回调
function M:OnQuestDialogClose()
    GuildWarUtils.RefreshQuestReddot()
end

-- 活动任务回调
function M:OnQuestBtnClicked()
    GuildWarUtils.RefreshQuestReddot(true)
    local Avatar = GWorld:GetAvatar()
    if Avatar.CommonQuestActivity[self.EventId] then
        local Params =  self:MakeRaidRewardData(self.EventId)
        Params.Title=GText("RaidDungeon_Rank_Task")
        Params.CloseBtnCallbackFunction = self.OnQuestDialogClose
        UIManager(GWorld.GameInstance):ShowCommonPopupUI(100173,Params,GWorld.GameInstance)
        --UIManager(self):LoadUINew("RougeArchiveReward",nil,self.DataModel)
    else
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast,GText("无法获取任务数据"))
    end
end

--- 商店奖励 ---
function M:MakeRaidRewardData(EventId)
    local Avatar = GWorld:GetAvatar()
    local Params={}
    Params.ConfigData={}
    Params.ConfigData.TabInfo={}
    Params.ConfigData.Items={}
    Params.ConfigData.HasTab=true
    Params.ConfigData.Datas={}
    local SortedRaidInfo = {}
    for QuestPhaseId, PhaseConfig in pairs(DataMgr.CommonQuestPhase) do
        if PhaseConfig.EventId == EventId then
            table.insert(SortedRaidInfo, PhaseConfig)
        end
    end
    table.sort(SortedRaidInfo, function(a,b)
        return a.Index < b.Index
    end)
    for _, PhaseConfig in pairs(SortedRaidInfo) do
        local QuestPhaseId= PhaseConfig.QuestPhaseId
        local TabIndex= 1
        if PhaseConfig.EventId == EventId then
            local TabItem={}
            TabItem.Index = TabIndex
            TabIndex = TabIndex + 1
            TabItem.Type = QuestPhaseId
            TabItem.Title = PhaseConfig.QuestPhaseName
            TabItem.ReddotName="RaidReward"
            TabItem.IconPath=PhaseConfig.SplineBP
            TabItem.IsShowIcon=true
            --self.Type2Index[ArchiveInfo.RLArchiveType] = Index
            table.insert(Params.ConfigData.TabInfo,TabItem)
            local RewardData={}
            RewardData.ShowIcon=false
            RewardData.NowNum,RewardData.NumMax = EastSeasonQuestUtils:GetQuestPhaseInfo(EventId,QuestPhaseId)
            RewardData.ReceiveAllCallBack=self.GetAllRaidRewards
            RewardData.ReceiveAllParam={}
            RewardData.ReceiveAllParam.EventId=EventId
            RewardData.ReceiveAllParam.QuestPhaseId=QuestPhaseId
            RewardData.Type=QuestPhaseId
            RewardData.Text_Total=string.format(GText("Abyss_RewardList_Title"))
            RewardData.ReceiveButtonText=GText("UI_Archive_CollectionClaimAll")
            local CommonQuestActivity = Avatar.CommonQuestActivity[EventId]
            if not CommonQuestActivity then 
                DebugPrint("Avatar.CommonQuestActivity is nil, EvantId: ", EventId)
                return
            end
            local Items={}
            for QuestId, Config in pairs(DataMgr.CommonQuestDetail) do
                if Config.QuestPhaseId == QuestPhaseId then
                    local Item={}
                    Item.ItemId=QuestId
                    Item.CanReceive=CommonQuestActivity[QuestId].Progress >= CommonQuestActivity[QuestId].Target and CommonQuestActivity[QuestId].RewardsGot == false
                    Item.Type=QuestPhaseId
                    Item.RewardsGot=CommonQuestActivity[QuestId].RewardsGot
                    Item.NotreachText=GText("UI_Archive_CollectionInProgress")
                    Item.Hint=GText(Config.StarterQuestDes)
                    Item.ReddotName="RaidReward"
                    Item.ReceiveButtonText=GText("UI_Archive_CollectionClaim")
                    Item.Num=Config.Target
                    Item.ReceiveCallBack=self.GetRaidReward
                    Item.ReceiveParm={}
                    Item.ReceiveParm.QuestId=QuestId
                    Item.ReceiveParm.EventId=EventId
                    local Rewards={}
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
                                    Rarity = Rarity,
                                }
                                table.insert(Rewards, RewardContent)
                            end
                        end
                    end
                    Item.Rewards=Rewards
                    table.insert(Items,Item)
                end
            end
            table.sort(Items, function(a,b)
                return a.Num < b.Num
            end)
            RewardData.Items=Items
            Params.ConfigData.Datas[QuestPhaseId]=RewardData
        end
    end
    Params.ConfigData.Type=Params.ConfigData.TabInfo[1].Type
    Params.ConfigData.ReddotName="RaidReward"
    return Params     
end

function M:GetAllRaidRewards(ReceiveAllParm)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local function CallBack(Ret,Reward)
            DebugPrint("@@@Raid GetAllRewards CallBack")
            local HaveReWardToGet=false
            local CommonQuestActivity = Avatar.CommonQuestActivity[ReceiveAllParm.EventId]
            for i = 0,ReceiveAllParm.SelfWidget.List_Item:GetNumItems() - 1 do
                local Item = ReceiveAllParm.SelfWidget.List_Item:GetItemAt(i)
                if Item then
                    local CanReceive= CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].Progress >= CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].Target and CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].RewardsGot == false
                    local IsGot=CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].RewardsGot
                    if CanReceive and not IsGot then
                        HaveReWardToGet=true
                    end
                    DebugPrint("@@@Raid GetAllRewards ,Type,ItemId,CanReceive,IsGot",Item.ConfigData.Type, Item.ConfigData.ItemId,CanReceive,IsGot)
                    Item.ConfigData.CanReceive=CanReceive
                    Item.ConfigData.RewardsGot=IsGot
                    if Item.SelfWidget then
                        Item.SelfWidget:RefreshBtn(IsGot,CanReceive)
                    end
                end
            end
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Reward, false, function ()
                ReceiveAllParm.SelfWidget:SetFocus()
            end, ReceiveAllParm.SelfWidget)
            ReceiveAllParm.SelfWidget:RefreshButton(HaveReWardToGet)
            DebugPrint("@@@hRaid GetAllRewards HaveReWardToGet",HaveReWardToGet)
            ReceiveAllParm.SelfWidget:RefreshReddotInfo()
        end
        Avatar:CommonQuestActivityGetPhaseReward(CallBack, ReceiveAllParm.EventId, ReceiveAllParm.QuestPhaseId)
    end
end

function M:GetRaidReward(Content)
      local Avatar = GWorld:GetAvatar()
    if Avatar then
        local Callback = function (ErrCode,Rewards)
            if not ErrorCode:Check(ErrCode) then
                return
            end
            DebugPrint("@@@Raid GetReward CallBack")
            local HaveReWardToGet=false
            local CommonQuestActivity = Avatar.CommonQuestActivity[Content.ConfigData.ReceiveParm.EventId]
            for i = 0, Content.Owner.List_Item:GetNumItems() - 1 do
                local Item = Content.Owner.List_Item:GetItemAt(i)
                if Item then
                    local CanReceive= CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].Progress >= CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].Target and CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].RewardsGot == false
                    local IsGot=CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].RewardsGot
                    if CanReceive and not IsGot then
                        HaveReWardToGet=true
                    end
                    DebugPrint("@@@Raid GetReward ,Type,ItemId,CanReceive,IsGot",Item.ConfigData.Type, Item.ConfigData.ItemId,CanReceive,IsGot)
                    Item.ConfigData.CanReceive=CanReceive
                    Item.ConfigData.RewardsGot=IsGot
                    if Item.SelfWidget then
                        Item.SelfWidget:RefreshBtn(IsGot,CanReceive)
                    end
                end
            end
            Content.SelfWidget:RefreshReddotInfo()
            Content.Owner:RefreshButton(HaveReWardToGet)
            DebugPrint("@@@Raid GetReward HaveReWardToGet",HaveReWardToGet)
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function ()
                Content.SelfWidget:SetFocus()
            end, Content.SelfWidget)
        end
        Avatar:CommonQuestActivityGetReward(Callback,Content.ConfigData.ReceiveParm.EventId,Content.ConfigData.ReceiveParm.QuestId)
    end
end

--- 输入处理 ---
function M:AddInputMethodChangedListen()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice) 
    end
end

function M:RemoveInputMethodChangedListen()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice) 
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        self:SetGamepadView(false)
    elseif CurInputDevice == ECommonInputType.Gamepad then
        self:SetGamepadView(true)
    end
end

function M:SetGamepadView(IsGamepad)
    local VisiblityKey = IsGamepad and "SelfHitTestInvisible" or "Collapsed"
    self.Entrance_Ranking:SetGamepadVisibility(VisiblityKey)
    self.Entrance_Shop:SetGamepadVisibility(VisiblityKey)
    self.Entrance_Quest:SetGamepadVisibility(VisiblityKey)
end

function M:HandleKeyDownOnGamePad(InKeyName)
    local IsEventHandled=false
    if InKeyName== UIConst.GamePadKey.RightThumb then
        if not GuildWarUtils.IsPreRaidTime() then
            IsEventHandled=true
            self:OnRankBtnClicked()  -- 排行榜
        end
    elseif InKeyName== UIConst.GamePadKey.FaceButtonTop then
        IsEventHandled=true
        self:OnQuestBtnClicked()  -- 活动任务
    end
    -- 商店在 WBP_Activity_JumpPage_P_C 的 Handle_KeyDownOnGamePad
    return IsEventHandled
end

return M