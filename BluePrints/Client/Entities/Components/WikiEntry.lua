local WikiController = require "BluePrints.UI.WBP.Wiki.WikiController"
local WikiCommon = require "BluePrints.UI.WBP.Wiki.WikiCommon"
local EMCache = require "EMCache.EMCache"

local Component = {}
local WikiEntryReddotName = DataMgr.ReddotNode.WikiEntrance.Name
local WikiItemReddotName = DataMgr.ReddotNode.WikiItems.Name
local WikiRewardReddotName = DataMgr.ReddotNode.WikiReward.Name

function Component:WikiEntryGetAllRewards(InCallBack)
	local function Cb(ErrCode,ret) -- ErrCode:错误码  ret:领取成功的进度
		self.logger.debug("WikiEntryGetAllRewards", ErrorCode:Name(ErrCode),ret)
        DebugPrint("WikiEntryGetAllRewardsErr:Code,ret", ErrCode,ret)
        local rewardId = self:GetWikiRewardIdByProgress(10)
        local AllCount = self:GetCurrentRewardCount()
        if ErrCode == 0 then
            for Progress, RewardInfo in pairs(self.RewardGotList) do
                if self:CheckWikiRewardCanGet(Progress) then
                    self:GetWikiReward(Progress)
                end
            end
            self:SaveWikiRewardList()
            self:UpdateWikiRewardReddot() -- 更新红点状态
        end
        if InCallBack then
            InCallBack(ErrCode, ret, rewardId,AllCount)
        end
	end
	self:CallServer("WikiEntryGetAllRewards", Cb)
end

function Component:WikiEntryGetReward(Num,InCallBack)
	local function Cb(ErrCode)
		DebugPrint("WikiEntryGetReward", ErrorCode:Name(ErrCode))
        DebugPrint("WikiEntryGetRewardErr:Code", ErrCode,Num)
        local rewardId = self:GetWikiRewardIdByProgress(Num)
        if InCallBack then
            InCallBack(Num,rewardId)
        end
	end
	self:CallServer("WikiEntryGetReward", Cb,Num)
end

function Component:WikiEntryTextReaded(WikiEntryId,TextId)
	local function Cb(ErrCode)
		self.logger.debug("WikiEntryTextReaded", ErrorCode:Name(ErrCode))
		self:SubWikiEntryReddotCount(WikiEntryId)  -- 阅读后减少红点数量
	end
	self:CallServer("WikiEntryTextReaded", Cb,WikiEntryId,TextId)
end

--region wiki词条解锁
function Component:NotifyWikiEntryUnlock(WikiEntryId,TextId)
	DebugPrint("NotifyWikiEntryUnlock",WikiEntryId,TextId)
	self:InitWikiEntryReddotNode()
    self:InitWikiRewardList()
    WikiController:GetModel():MarkTextAsNew(TextId, WikiEntryId)
	local WikiNoteId = WikiCommon.WikiTipsGuideNoteId --这里复用教学系统的tips,10100101作为wiki的tips，对应self.GuideNoteTab = 6
    self:ShowWikiTips(WikiNoteId)
    EventManager:FireEvent(EventID.OnEntryTextUnlocked, WikiEntryId, TextId)
end

function Component:ShowWikiTips(WikiNoteId)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    if not UIManager then
        return
    end
    if UIManager:GetUI("BattleMain") then -- 如果处于BattleMain界面才弹出
        UIManager:LoadUINew("GuideBook_Tips", WikiNoteId)
    end
end
--endregion

--region 红点相关
function Component:Init()
    self.RewardStateChangeCallbacks = {}
end

function Component:EnterWorld()
	WikiController:Init()
    self:InitWikiEntryReddotNode()
    self:LoadWikiRewardList()
    self:InitWikiRewardReddotNode()--初始化WikiReward红点节点
end

function Component:LeaveWorld()
    self:SaveWikiRewardList()
	WikiController:Destory()
end

function Component:InitWikiEntryReddotNode()
    ReddotManager.AddNode(WikiItemReddotName)
    ReddotManager.GetTreeNode(WikiItemReddotName).Count = 0
    for Id, Content in pairs(self.WikiEntries) do
        self:AddWikiEntryReddotCount(Id, Content)
    end
end

function Component:AddWikiEntryReddotCount(WikiEntryId, WikiEntryData)
    if ReddotManager.GetTreeNode(WikiItemReddotName) then
        ReddotManager.IncreaseLeafNodeCount(WikiItemReddotName)
    end
end

function Component:SubWikiEntryReddotCount(WikiEntryId)
    if ReddotManager.GetTreeNode(WikiItemReddotName) and ReddotManager.GetTreeNode(WikiItemReddotName).Count > 0 then
        ReddotManager.DecreaseLeafNodeCount(WikiItemReddotName)
    end
end

function Component:ClearWikiEntryReddotCount()
    --重置数量到1再减一是为了能够触发红点事件
    local NewWikiEntryNode = ReddotManager.GetTreeNode(WikiItemReddotName)
    if not NewWikiEntryNode then return end
    NewWikiEntryNode.Count = 1
    ReddotManager.DecreaseLeafNodeCount(WikiItemReddotName)
end

--endregion

--region 奖励弹窗
-- 初始化奖励领取状态
function Component:InitWikiRewardList()
    local UnlockedCount = 0
    for _, Content in pairs(self.WikiEntries) do
        UnlockedCount = UnlockedCount + 1
    end

    if not self.RewardGotList then
        self.RewardGotList = {}
    end
    local rewardItems = WikiController:GetModel():GetWikiRewardList()
    for _, RewardData in pairs(rewardItems) do
        if RewardData.RewardProgress <= UnlockedCount then
            if not self.RewardGotList[RewardData.RewardProgress] then
                self.RewardGotList[RewardData.RewardProgress] = {RewardData.RewardId, 0}
            end
        end
    end
    self:SaveWikiRewardList()
    self:UpdateWikiRewardReddot() -- 更新红点状态

end

function Component:LoadWikiRewardList()
    if not self.WikiGotRewards then return end
    self:InitWikiRewardList()
    
    if self.RewardGotList then
        for progress, gotStatus in pairs(self.WikiGotRewards) do
            if self.RewardGotList[progress] then
                -- 服务端数据：1表示已领取，0表示未领取
                self.RewardGotList[progress][2] = gotStatus
            end
        end
        -- 保存同步后的状态到本地缓存
        self:SaveWikiRewardList()
    end
end

-- 保存奖励列表到缓存
function Component:SaveWikiRewardList()
    if self.RewardGotList and next(self.RewardGotList) then
        EMCache:Set("WikiRewardGotList", self.RewardGotList,true)
    end
end

-- 检查奖励是否已领取
function Component:CheckWikiRewardIsGot(Progress)
    if not self.RewardGotList then return false end
    if self.RewardGotList[Progress] then
        return self.RewardGotList[Progress][2] == 1
    end
    return false
end

-- 检查奖励是否可领取
function Component:CheckWikiRewardCanGet(Progress)
    if not self.RewardGotList or not self.RewardGotList[Progress] then return false end
    if self.RewardGotList[Progress][2] == 1 then return false end
    return self.RewardGotList[Progress][2] == 0
end

-- 领取奖励
function Component:GetWikiReward(Progress)
    if self.RewardGotList[Progress] then
        self.RewardGotList[Progress][2] = 1
        self:SaveWikiRewardList()
    end
    self:UpdateWikiRewardReddot() -- 更新红点状态
end

-- 检查是否有可领取的奖励
function Component:CheckHaveWikiRewardToGet()
    if not self.RewardGotList then return false end
    
    for Progress, _ in pairs(self.RewardGotList) do
        if self:CheckWikiRewardCanGet(Progress) then
            return true
        end
    end
    return false
end

function Component:GetWikiRewardIdByProgress(Progress)
    if not self.RewardGotList then return end
    if self.RewardGotList[Progress] then
        return self.RewardGotList[Progress][1]
    end
    return nil
end

function Component:GetCurrentRewardCount()
    local count = 0
    for Progress, Content in pairs(self.RewardGotList) do
        if Content[2] == 0 then
            local RewardInfo = DataMgr.Reward[Content[1]]
            local Count = RewardUtils:GetCount(RewardInfo.Count[1])
            count = count + Count
        end
    end
    return count
end

--endregion

function Component:EchoWikiEntries()
    PrintTable(self.WikiEntries:all_dump(self.WikiEntries),10,"WikiEntries")
end

--region 红点树
-- 初始化WikiReward红点节点
function Component:InitWikiRewardReddotNode()
    ReddotManager.AddNode(WikiRewardReddotName)
    ReddotManager.GetTreeNode(WikiRewardReddotName).Count = self:GetCurrentRewardCount()
    self:UpdateWikiRewardReddot()
end

-- 更新WikiReward红点状态
function Component:UpdateWikiRewardReddot()
    -- 先清空红点
    self:ClearWikiRewardReddotCount()
    
    -- 检查是否有可领取的奖励，有则增加红点
    if self:CheckHaveWikiRewardToGet() then
        self:AddWikiRewardReddotCount()
    end
end

-- 增加WikiReward红点数量
function Component:AddWikiRewardReddotCount()
    if ReddotManager.GetTreeNode(WikiRewardReddotName) then
        ReddotManager.IncreaseLeafNodeCount(WikiRewardReddotName)
    end
end

-- 减少WikiReward红点数量
function Component:SubWikiRewardReddotCount()
    if ReddotManager.GetTreeNode(WikiRewardReddotName) and ReddotManager.GetTreeNode(WikiRewardReddotName).Count > 0 then
        ReddotManager.DecreaseLeafNodeCount(WikiRewardReddotName)
    end
end

-- 清空WikiReward红点数量
function Component:ClearWikiRewardReddotCount()
    --重置数量到1再减一是为了能够触发红点事件
    local WikiRewardNode = ReddotManager.GetTreeNode(WikiRewardReddotName)
    if not WikiRewardNode then return end
    WikiRewardNode.Count = 1
    ReddotManager.DecreaseLeafNodeCount(WikiRewardReddotName)
end

--endregion



return Component