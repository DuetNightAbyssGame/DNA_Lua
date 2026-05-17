local WikiModel = require "BluePrints.UI.WBP.Wiki.WikiModel"
local WikiCommon = require "BluePrints.UI.WBP.Wiki.WikiCommon"

---@class WikiController:Controller
---@field private _View WBP_Encyclopedia_Main_P_C
local M = Class("BluePrints.Common.MVC.Controller")

--region Override
function M:Init()
    M.Super.Init(self)
    self.isProcessingCallback = false
end

function M:Destory()
    
    M.Super.Destory(self)
end

function M:GetEventName()
    return EventID.WikiControllerEvent
end

function M:GetModel()
    return WikiModel
end
--endregion

--region 界面
function M:HandleButtonClick(buttonType, entranceWidget)
    -- 根据不同按钮类型处理不同逻辑
    if buttonType == WikiCommon.CategoryType.Faction then
        self:OpenWikiMain("Faction", entranceWidget)
    elseif buttonType == WikiCommon.CategoryType.Character then
        self:OpenWikiMain("Character", entranceWidget)
    elseif buttonType == WikiCommon.CategoryType.Customs then
        self:OpenWikiMain("Customs", entranceWidget)
    elseif buttonType == WikiCommon.CategoryType.Civilization then
        self:OpenWikiMain("Civilization", entranceWidget)
    end
end

-- 根据分类获取对应的TabId
function M:GetTabIdByCategory(category)
    return WikiCommon.CategoryType[category] or WikiCommon.CategoryType.All
end

function M:OpenWikiMain(category, entranceWidget)
    local View = self:GetView(nil, WikiCommon.MainUIName)
    -- 打开Wiki主界面
    local params = {
        Category = category,
        -- MainType = self:GetTabIdByCategory(category) - 1,
        TabId = self:GetTabIdByCategory(category),
        EntranceWidget = entranceWidget,
    }
    self:GetUIMgr(View):LoadUINew(WikiCommon.MainUIName, params)
    if entranceWidget then
        entranceWidget:HideSelf()
    end
end

function M:GetView(WorldContex, UIName)
    return M.Super.GetView(self, WorldContex, UIName)
end
--endregion

--region 剧情词条查阅
--传单个或多个id 101001；{101001, 101002}  entranceWidget仅在wiki入口页打开需要传,正常剧情不需要
function M:OpenDialogueWiki(entryIds, entranceWidget, CloseCb)
    if not entryIds or next(entryIds) == nil then return false end
    if not self:CheckEntriesUnlocked(entryIds) then return false end
    DebugPrint(TXTTag,"OpenDialogueWiki entryIds:", entryIds)
    local ids = type(entryIds) == "table" and entryIds or {entryIds}
    local params = {
        bShowDialogueWiki = true,
        DialogueEntryIds = ids,
        CloseCallback = CloseCb,
    }
    local UIObj = self:GetUIMgr():LoadUINew(WikiCommon.MainUIName, params)
    if not UIObj then return false end
    if entranceWidget then
        entranceWidget:CloseSelf()
    end
    return true
end

function M:GetDialogueEntries(entryIds)
    return self:GetModel():GetReadableDialogueEntries(entryIds)
end

function M:HandleDialogueEntries(entryIds, callback)
    local readableEntries = self:GetDialogueEntries(entryIds)
    if callback then
        callback(readableEntries)
    end
end

function M:CheckEntriesUnlocked(entryIds)
    local unlockedEntries = self:GetDialogueEntries(entryIds)
    if not unlockedEntries then return false end
    local ids = type(entryIds) == "table" and entryIds or {entryIds}
    
    local allLocked = true
    for _, entryId in ipairs(ids) do
        if unlockedEntries[entryId] then
            allLocked = false
            break
        end
    end
    
    return not allLocked
end
--endregion

--region 奖励弹窗
function M:OpenAwardPopup(Owner)
    local NowNum, AllNum = WikiController:GetModel():GetTextNum(1)
    local params = {
        ConfigData = {
            Items = {},
            ShowIcon = false,
            IconPath = "",
            Text_Total = "Wiki_RewardProgress",
            ReceiveAllCallBack = self.GetAllWikiRewards,
            ReceiveAllParam = {},
            SortType = 1,
            NowNum = NowNum,
            NumMax = AllNum,
            ReceiveButtonText = "UI_Achievement_GetAllReward"
        }
    }
    -- 构建奖励项
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local rewardItems = self:GetModel():GetWikiRewardList()
        for Id, rewardData in pairs(rewardItems) do
            --@todo 根据奖励进度设置显影
            local IsCanReceive = Avatar:CheckWikiRewardCanGet(rewardData.RewardProgress)
            local IsGot = Avatar:CheckWikiRewardIsGot(rewardData.RewardProgress)
            local Item = {
                Text = GText("UI_Wiki_Reward_Text"),
                ItemId = Id,
                CanReceive = Avatar:CheckWikiRewardCanGet(rewardData.RewardProgress),
                RewardsGot = Avatar:CheckWikiRewardIsGot(rewardData.RewardProgress),
                InProgress = true,
                Rewards = self:BuildRewardContent(rewardData.RewardId),
                Nums = 1,
                NotreachText = "UI_GameEvent_ToBeFinished",
                Hint = "Wiki_RewardList_Content",
                ShowIcon = false,
                
                ReceiveCallBack = self.GetWikiReward,
                LeftAligned = false,
                SourceNum = rewardData.RewardProgress,
                ReceiveButtonText = "UI_Achievement_GetReward",
                ReceiveParm = {
                    RewardId = rewardData.RewardId
                }
            }
            if AllNum >= rewardData.RewardProgress then
                table.insert(params.ConfigData.Items, Item)
            end
            DebugPrint(TXTTag,"CanReceive", Avatar:CheckWikiRewardCanGet(rewardData.RewardProgress))
            DebugPrint(TXTTag,"RewardsGot", Avatar:CheckWikiRewardIsGot(rewardData.RewardProgress))
        end
        params.ConfigData.NumMax = tostring(params.ConfigData.NumMax)
    end
    params.Title = GText("UI_Wiki_Reward_Title")
    UIManager(self):ShowCommonPopupUI(WikiCommon.AwardUIName, params, Owner)
end

function M:BuildRewardContent(RewardId)
    local Rewards = {}
    local RewardInfo = DataMgr.Reward[RewardId]
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
    return Rewards
end

function M:GetAllWikiRewards(ReceiveAllParm)
    if self.isProcessingCallback then return end
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local function CallBack(ErrCode, RewardReturn, rewardId,AllCount)
            self.isProcessingCallback = false
            self:BlockAllUIInput(false)
            local HaveRewardToGet = false
            -- 遍历所有奖励项更新状态
            for i = 0, ReceiveAllParm.SelfWidget.List_Item:GetNumItems() - 1 do
                local Item = ReceiveAllParm.SelfWidget.List_Item:GetItemAt(i)
                local CanReceive = Avatar:CheckWikiRewardCanGet(Item.ConfigData.SourceNum)
                local IsGot = Avatar:CheckWikiRewardIsGot(Item.ConfigData.SourceNum)
                if CanReceive then
                    HaveRewardToGet = true
                end
                Item.ConfigData.CanReceive = CanReceive
                Item.ConfigData.RewardsGot = IsGot
                if Item.SelfWidget then
                    Item.SelfWidget:RefreshBtn(IsGot)
                end
            end
            -- 刷新一键领取按钮
            ReceiveAllParm.SelfWidget:RefreshButton(HaveRewardToGet)
            local rewardData = DataMgr.Reward[rewardId]
            if rewardData then
                UIManager(GWorld.GameInstance):LoadUI(UIConst.LoadInConfig, "GetItemPage", nil, rewardData.Type[1],rewardData.Id[1],AllCount)
            end
        end
        self.isProcessingCallback = true
        self:BlockAllUIInput(true)
        Avatar:WikiEntryGetAllRewards(CallBack)
    end
end 

function M:GetWikiReward(ReceiveParm)
    if self.isProcessingCallback then return end

    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local function CallBack(Num,rewardId)
            self.isProcessingCallback = false
            self:BlockAllUIInput(false)
            Avatar:GetWikiReward(ReceiveParm.ConfigData.SourceNum)
            -- 更新领取状态
            local CanReceive = Avatar:CheckWikiRewardCanGet(ReceiveParm.ConfigData.SourceNum)
            local IsGot = Avatar:CheckWikiRewardIsGot(ReceiveParm.ConfigData.SourceNum)
            ReceiveParm.ConfigData.CanReceive = CanReceive
            ReceiveParm.ConfigData.RewardsGot = IsGot
            -- 刷新按钮状态
            ReceiveParm.SelfWidget:RefreshBtn(IsGot)
            -- 刷新一键领取按钮状态
            local HaveRewardToGet = Avatar:CheckHaveWikiRewardToGet()
            DebugPrint(TXTTag,"CheckHaveWikiRewardToGet", HaveRewardToGet)
            ReceiveParm.Owner:RefreshButton(HaveRewardToGet)
            if DataMgr.Reward[rewardId] then
                local rewardData=DataMgr.Reward[rewardId]
                UIManager(GWorld.GameInstance):LoadUI(UIConst.LoadInConfig, "GetItemPage", nil, rewardData.Type[1], rewardData.Id[1], rewardData.Count[1][1])
            end
        end
        self.isProcessingCallback = true
        self:BlockAllUIInput(true)
        Avatar:WikiEntryGetReward(ReceiveParm.ConfigData.SourceNum, CallBack)
    end
end
--endregion

_G.WikiController = M
return M