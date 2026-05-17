local Component = {}

local TalkUtils = require "BluePrints.Story.Talk.View.TalkUtils"
local TimerMgr = require "BluePrints.Common.TimerMgr"

local LocalTimeOut = 10

function Component:ImpressionCheckByEnumId_New(DialogueChain, CurrentDialogueId, TalkTriggerId, ImpressionAreaId, ClientDelegate, CheckInfo, UsingGM, bTalkOptions)
    local DialogueChain = DialogueChain or {}
    DialogueChain = CommonUtils.CopyTable(DialogueChain)
    table.insert(DialogueChain, CurrentDialogueId)
    local Params = {
        CurrentDialogueId = CurrentDialogueId,
        TalkTriggerId = TalkTriggerId,
        Type = 'Check',
        CheckInfo = CheckInfo,
    }
    local ret = self:CanImpressionCheck(ImpressionAreaId)
    local DiceNum = ret.ResourceCount
    local function Callback(Ret, IsCheckSuccess, rand1, rand2, Rewards)
        self.logger.info("ZJT_ 11111111111111111111 ImpressionCheckByEnumId_New ", Ret, IsCheckSuccess, rand1, rand2, Rewards, CurrentDialogueId)
        if ClientDelegate and ClientDelegate[1] then
            --移除超时计时器
            TimerMgr.RemoveTimer(ClientDelegate[1], "ImpressionCheck", true)
        end
        Params.Rewards = Rewards
        if ClientDelegate and ClientDelegate[1] and ClientDelegate[2] then
            ClientDelegate[2](ClientDelegate[1], Ret, IsCheckSuccess, rand1, rand2, Params, DialogueChain)
        end
        EventManager:FireEvent(EventID.SetNpcFlexibShowOrHideDynamic, 'Impression', TalkTriggerId)
        EventManager:FireEvent(EventID.SetCustomNpcFlexibShowOrHideDynamic, 'Impression', TalkTriggerId)
        EventManager:FireEvent(EventID.TriggerFlexibleActive)
    end
    if UsingGM then
        Callback(0, true, 9, 9)
        return
    end
    self:CallServer("ImpressionCheckByEnumId_New", Callback, DialogueChain, DiceNum)
    if ClientDelegate and ClientDelegate[1] and ClientDelegate[3] then
        --超时检测
        TimerMgr.AddTimer(ClientDelegate[1], LocalTimeOut, ClientDelegate[3], false, 0, "ImpressionCheck", true, DialogueChain)
    end
end

function Component:ImpressionAddByEnumId_New(DialogueChain, CurrentDialogueId, ClientDelegate, UsingGM)
    local DialogueChain = DialogueChain and CommonUtils.CopyTable(DialogueChain) or {}
    table.insert(DialogueChain, CurrentDialogueId)
    local function Callback(Ret)
        self.logger.info("ZJT_ 11111111111111111111 ImpressionAddByEnumId_New ", Ret, CurrentDialogueId)
        if ClientDelegate and ClientDelegate[1] then
            --移除超时计时器
            TimerMgr.RemoveTimer(ClientDelegate[1], "ImpressionPlus", true)
        end
        if ClientDelegate and ClientDelegate[1] and ClientDelegate[2] then
            ClientDelegate[2](ClientDelegate[1], Ret, DialogueChain)
        end
    end
    if UsingGM then
        Callback(0)
        return
    end
    self:CallServer("ImpressionAddByEnumId_New", Callback,  DialogueChain)
    if ClientDelegate and ClientDelegate[1] and ClientDelegate[3] then
        --超时检测
        TimerMgr.AddTimer(ClientDelegate[1], LocalTimeOut, ClientDelegate[3], false, 0, "ImpressionPlus", true, DialogueChain)
    end
end
function Component:SetTalkTriggerComplete_New(TalkTriggerId, ClientDelegate)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    Player:SetCanInteractiveTrigger(false)
    Player:DisablePlayerInputInDeliver(true)

    local function Callback(Ret, Rewards)
        self.logger.info("ZJT_ 11111111111111111111 SetTalkTriggerComplete_New ", Ret, TalkTriggerId)
        EventManager:FireEvent(EventID.SetNpcFlexibShowOrHideDynamic, 'Impression', TalkTriggerId)
        EventManager:FireEvent(EventID.SetCustomNpcFlexibShowOrHideDynamic, 'Impression', TalkTriggerId)
        EventManager:FireEvent(EventID.TriggerFlexibleActive)

        if ErrorCode:Check(Ret) then
            EventManager:FireEvent(EventID.OnImprTalkTriggerComplete, TalkTriggerId)
            local TalkTriggerInfo = DataMgr.TalkTrigger[TalkTriggerId]
            local RewardId = TalkTriggerInfo.RewardId
            local rewardData=DataMgr.Reward[RewardId]
            local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
            if rewardData then
                local func = function()
                    Player:SetCanInteractiveTrigger(true)
                    Player:DisablePlayerInputInDeliver(false)
                    local GameInstance = GWorld.GameInstance
                   ---@type BP_UIManagerComponent_C
                    local UIManager = GameInstance:GetGameUIManager()
                    local UI = UIManager:GetUI("GetItemPage")
                    if UI then
                        UI:BindActionOnClosed()
                    end
                end
                UIUtils.ShowGetItemPageAndOpenBagIfNeeded(rewardData.Type[1], rewardData.Id[1], rewardData.Count[1][1], Rewards, false, func, self, false)
                -- UI:BindActionOnClosed(function()
                --     Player:SetCanInteractiveTrigger(true)
                --     UI:BindActionOnClosed()
                -- end)
            else
                Player:SetCanInteractiveTrigger(true)
                Player:DisablePlayerInputInDeliver(false)
            end
        else
            Player:SetCanInteractiveTrigger(true)
            Player:DisablePlayerInputInDeliver(false)
        end
        Player:RemoveTimer("ImpressionMgrResumeInteractive", true)

        if ClientDelegate and ClientDelegate[1] and ClientDelegate[2] then
            ClientDelegate[2](ClientDelegate[1])
        end
    end
    self:CallServer("SetTalkTriggerComplete_New", Callback, TalkTriggerId)
end

function Component:GMAddImpressionPreNode(PreDialogueId)
    local function Callback(Ret)
        self.logger.info("ZJT_ 11111111111111111111 AddImpressionPreNode ", Ret, PreDialogueId)
    end
    self:CallServer("GMAddImpressionPreNode", Callback, PreDialogueId)
end

--------------------------------------获取故事链状态 --------------------------------------

function Component:IsStorylineComplete(TalkTriggerId)
    return self:IsStorylineSuccess(TalkTriggerId) or self:IsStorylineFailure(TalkTriggerId)
end

function Component:IsStorylineUnComplete(TalkTriggerId)
    return not self:IsStorylineComplete(TalkTriggerId)
end

function Component:IsStorylineSuccess(TalkTriggerId)
    return self.ImpressionTalkTriggers[TalkTriggerId] == CommonConst.ImpressionCheckType.Success
end

function Component:IsStorylineFailure(TalkTriggerId)
    return self.ImpressionTalkTriggers[TalkTriggerId] == CommonConst.ImpressionCheckType.Failed
end

function Component:IsImpressionCheckSuccess(DialogueId)
    return self.ImpressionDialogues[DialogueId] == CommonConst.ImpressionCheckType.Success
end

function Component:IsImpressionCheckFailure(DialogueId)
    return self.ImpressionDialogues[DialogueId] == CommonConst.ImpressionCheckType.Failed
end

-------------纯客户端开发函数--------------
--Todo 命名不准确，实际为骰子数量是否足够
function Component:CanImpressionCheck(ImpressionAreaId)
    -- 骰子数量检测
    local Ret = {
        ResourceCount = 0,
        Cost = 0,
        bCanCheck = false,
    }
    local ImpressionResourceInfo = DataMgr.ImpressionResource[ImpressionAreaId]
    Ret.ResourceCount = self:GetResourceNum(ImpressionResourceInfo.ResourceId)
    Ret.Cost = ImpressionResourceInfo.Count
    Ret.bCanCheck = Ret.ResourceCount >= Ret.Cost

    return Ret
end

function Component:GetSuccRate(PlayerValue, CheckValue)
    local SuccRate = 100 - CheckValue + PlayerValue
    if SuccRate > 100 then
        SuccRate = 100
    elseif SuccRate < 0 then
        SuccRate = 0
    end
    return SuccRate
end

function Component:GetDifficultyInfo(SuccRate)
    SuccRate = SuccRate / 100
    local ImpressionDifficulty = DataMgr.ImpressionDifficulty
    local Easy = ImpressionDifficulty.Easy
    local Middle = ImpressionDifficulty.Middle
    local Hard = ImpressionDifficulty.Hard
    local Impossible = ImpressionDifficulty.Impossible

    local DifficultyInfo = Easy
    if SuccRate < Hard.DifficultyMinValue then
        DifficultyInfo = Impossible
    elseif SuccRate < Middle.DifficultyMinValue then
        DifficultyInfo = Hard
    elseif SuccRate < Easy.DifficultyMinValue then
        DifficultyInfo = Middle
    end
    return DifficultyInfo
end

function Component:GetImpressionCheckInfo(CheckId)
    local CheckInfo = {}
    local ImpressionCheck = DataMgr.ImpressionCheck[CheckId]
    CheckInfo.CheckRegionId = ImpressionCheck.RegionId
    for _,Type in pairs(CommonConst.ImpressionType) do
        if ImpressionCheck[Type +'Check'] > 0 then
            CheckInfo.CheckType = Type
        end
    end
    return CheckInfo
end

function Component:ShowCommonImpressionReward(Code, Res, CheckData, Rewards, Callback)
    --DebugPrint("@@@ ShowCommonImpressionReward",Code, Res, CheckData, Rewards, Callback)
    if  (not ErrorCode:Check(Code)) or 
        (not Res) or
        (not Rewards) or
        (not CheckData) or
        (not CheckData.RewardId) then

        Callback()
        return
    end

    local RewardData = DataMgr.Reward[CheckData.RewardId]
    local ItemPageUI = UIManager(GWorld.GameInstance):LoadUINew("GetItemPage", RewardData.Type[1], RewardData.Id[1], RewardData.Count[1][1], Rewards)
    if ItemPageUI and ItemPageUI.BindActionOnClosed then
        ItemPageUI:BindActionOnClosed(function() Callback() end, self)
    else
        Callback()
    end
end

function Component:ShowImpressionPlusUI(ImprPlusId, Callback)
    DebugPrint("ShowImpressionPlusUI")
    Callback = Callback or function()end
    local PlusInfo = TalkUtils:GetImpressionPlusInfo(ImprPlusId)
    if PlusInfo then
        local ImpressionAreaId = PlusInfo.ImpressionAreaId
        local PlusType = PlusInfo.PlusType
        local PlusValue = PlusInfo.PlusValue
        DebugPrint("ImpressionAreaId,PlusType,PlusValue:,", ImpressionAreaId, PlusType, PlusValue)
        local ImpressionDimensionResultUI = UIManager(GWorld.GameInstance):LoadUINew("ImpressionDimensionResult")
        ImpressionDimensionResultUI:Init(true, ImpressionAreaId, PlusType, PlusValue)
        ImpressionDimensionResultUI:SetOnCloseDelegate({self, function() 
            UIManager(GWorld.GameInstance):UnLoadUINew("ImpressionDimensionResult")
            Callback()
        end})
        ImpressionDimensionResultUI:FadeIn()  
    else
        Utils.ScreenPrint("显示印象加值UI时，ID "..ImprPlusId.."在ImpressionPlus表中不存在，请检查")
        Callback()
    end
end
    
function Component:GetImpressionAreaIdFromRegionId(TargetRegionId)
    TargetRegionId = TargetRegionId or self:GetSubRegionId2RegionId()
    local ImpressionRegions = DataMgr.ImpressionRegion
    for ImpressionRegionId,RegionInfo in pairs(ImpressionRegions) do
        local Regions = RegionInfo.RegionId
        for _,RegionId in pairs(Regions) do
            if TargetRegionId == RegionId then
                return ImpressionRegionId
            end
        end
    end

    Utils.ScreenPrint("未找到印象区域ID，请检查RegionId是否在ImpressionRegion表中,SubRegionId:"..TargetRegionId)
    return TargetRegionId
end

---@return Impression
function Component:GetRegionImpression(ImpressionAreaId)
    return self.Impressions:GetImpression(ImpressionAreaId)
end
-------------纯客户端开发函数--------------

return Component