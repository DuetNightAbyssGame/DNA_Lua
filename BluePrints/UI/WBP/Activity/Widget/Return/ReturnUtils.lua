require "UnLua"
local ActivityReddotHelper = require "BluePrints.UI.WBP.Activity.ActivityReddotHelper"
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
local ReturnUtils = {}

ReturnUtils.ReddotTaskNewKey = "ComeBackTaskNew"
ReturnUtils.ReddotTaskQuestKey = "ComeBackTaskQuest"
ReturnUtils.ReddotTaskRewardKey = "ComeBackTaskReward"

--判断是否可以参与邀请活动
function ReturnUtils.CanParticipateInvite()
    local CurrentEventSchemeId = DataMgr.ComeBackEventConstant.CurrentEventSchemeId.ConstantValue
    local InviteEventSchemeId = DataMgr.ComeBackEvent[CurrentEventSchemeId].InviteEventSchemeId
    if not InviteEventSchemeId then return false end
    local ServerArea = GWorld and GWorld.ChooseServerArea or nil
    local InviteEventSchemeData = DataMgr.InviteEventScheme and DataMgr.InviteEventScheme[InviteEventSchemeId] or nil
    local bCanParticipateInvite = false
    if InviteEventSchemeData and ServerArea and InviteEventSchemeData[ServerArea] then
        if InviteEventSchemeData[ServerArea].PCJumpLink and UIUtils.IsPCInput() then
            bCanParticipateInvite = true
        elseif InviteEventSchemeData[ServerArea].PhoneJumpLink and UIUtils.IsMobileInput() then
            bCanParticipateInvite = true
        end
    end
    return bCanParticipateInvite
end

function ReturnUtils.GetSevenDayRewardRealLoginData()
	local CurrentEventSchemeId = DataMgr.ComeBackEventConstant.CurrentEventSchemeId.ConstantValue
    local CurrentEventSchemeData = DataMgr.ComeBackEvent[CurrentEventSchemeId]
    local EventLoginId = CurrentEventSchemeData.EventLoginId
    if not EventLoginId then return end
    local LoginData = DataMgr.ComeBackLogin[EventLoginId]
    if not LoginData then return end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local CurrentEventId = DataMgr.ComeBackEventConstant.CurrentEventId.ConstantValue
    local PageServerData = Avatar.ComeBacks[CurrentEventId] and Avatar.ComeBacks[CurrentEventId].LoginRewardGot or nil
    if not PageServerData then return end
    local ServerLoginDay = Avatar.ComeBacks[CurrentEventId] and Avatar.ComeBacks[CurrentEventId].LoginDay or 0
    local AllSignDay = LoginData.LoginDuration
    local RealLoginData = {}
    for i = 1, AllSignDay, 1 do
        if PageServerData[i] and PageServerData[i] == 1 then
            RealLoginData[i] = 3
        end
        if i <= ServerLoginDay and not PageServerData[i] then
            RealLoginData[i] = ActivityUtils.EnumPlayerSignRewardState.SignedNotRecv
        elseif i > ServerLoginDay and not PageServerData[i] then
            RealLoginData[i] = ActivityUtils.EnumPlayerSignRewardState.NotSign
        end
    end
    return RealLoginData
end

function ReturnUtils.GetSevenDayRewardValidIndex()
	local RealLoginData = ReturnUtils.GetSevenDayRewardRealLoginData()
    local AllValidIndex = {}
    for i = 1, #RealLoginData, 1 do
        if RealLoginData[i] == ActivityUtils.EnumPlayerSignRewardState.SignedNotRecv then
            table.insert(AllValidIndex, i)
        end
    end
    return AllValidIndex
end

function ReturnUtils.ShowReturnActiGetItemPage(AllValidIndex, TargetWidget)
	local CurrentEventSchemeId = DataMgr.ComeBackEventConstant.CurrentEventSchemeId.ConstantValue
    assert(CurrentEventSchemeId, "lgc@CurrentEventSchemeId is nil, 需要策划检查下ComeBackEventConstant表中的CurrentEventSchemeId")
    local CurrentEventSchemeData = DataMgr.ComeBackEvent[CurrentEventSchemeId]
    if not CurrentEventSchemeData then return end
    local EventLoginId = CurrentEventSchemeData.EventLoginId
    if not EventLoginId then return end
    local LoginData = DataMgr.ComeBackLogin[EventLoginId]
    if not LoginData then return end
    local LoginReward = LoginData.LoginReward
	if not LoginReward then return end
    if not AllValidIndex or #AllValidIndex == 0 then return end
    local ValidRewardIds = {}
    for _, Index in ipairs(AllValidIndex) do
        table.insert(ValidRewardIds, LoginReward[Index])
    end
    local AllRewards = RewardUtils:GetRewards(ValidRewardIds, nil)
	UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, AllRewards, false, nil, TargetWidget, false)
end

function ReturnUtils.ReturnAddReddotListener(TargetUI, ReddotNodeName,func)
    if TargetUI["Listened"..ReddotNodeName] then
        local RootNode = ReddotManager.GetTreeNode(ReddotNodeName)
        func(TargetUI,RootNode.Count)
        return
    end
    ReturnUtils.ReturnRemoveReddotListener(TargetUI, ReddotNodeName)
    ReddotManager.AddListenerEx(ReddotNodeName,TargetUI, func)
    TargetUI["Listened"..ReddotNodeName] = true
end

function ReturnUtils.ReturnRemoveReddotListener(TargetUI, ReddotNodeName)
    if(TargetUI["Listened"..ReddotNodeName]) then
        ReddotManager.RemoveListener(ReddotNodeName,TargetUI)
        TargetUI["Listened"..ReddotNodeName] = false
    end
end

function ReturnUtils.RefreshItemReddot(TargetUI, Index, ReddotCount)
    if not TargetUI or not IsValid(TargetUI) then return end
    local TargetItem = TargetUI["Tab_"..Index] or TargetUI["EntryItem_"..Index]
    if not TargetItem and Index == 4 then
        TargetItem = TargetUI.Return_Reward
    end
    if not TargetItem then return end
    local TargetReddot = TargetItem.Reddot
    if ReddotCount > 0 then
        TargetReddot:SetVisibility(UIConst.VisibilityOp["VisibilityOp"])
    else
        TargetReddot:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

function ReturnUtils.GetCurrentComeBackQuestInfo(CurrentEventId)
    local EventId = CurrentEventId or DataMgr.ComeBackEventConstant.CurrentEventId.ConstantValue
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local ComeBackData = Avatar:GetCurrentComeBackData(EventId)
    if not ComeBackData then
        return
    end
    local ComeBackEventConf = DataMgr.ComeBackEvent[ComeBackData.EventSchemeId]
    if not ComeBackEventConf then
        GWorld.logger.error("ReturnUtils: ComeBackEventConf is nil, CurrentEventId:"..EventId)
        return
    end
    local EventQuestId = ComeBackEventConf.EventQuestId
    if not EventQuestId then
        GWorld.logger.error("ReturnUtils: EventQuestId is nil, CurrentEventId:"..EventId)
        return
    end
    local ComeBackQuestConf = DataMgr.ComeBackQuest[EventQuestId]
    if not ComeBackQuestConf then
        GWorld.logger.error("ReturnUtils: ComeBackQuestConf is nil, EventQuestId:"..EventId)
        return
    end
    return setmetatable({}, {__index = ComeBackQuestConf})
end

function ReturnUtils.RefreshComeBackTaskNewReddot(ClearCache)
    local EventID = DataMgr.ComeBackEventConstant.CurrentEventId.ConstantValue
    if not EventID then
        if ReddotManager.GetTreeNode(ReturnUtils.ReddotTaskNewKey) then
            ReddotManager.ClearLeafNodeCount(ReturnUtils.ReddotTaskNewKey, true)
            return
        end
    end
    if not ActivityUtils.CheckComeBackEventIsOpen(EventID) then
        if ReddotManager.GetTreeNode(ReturnUtils.ReddotTaskNewKey) then
            ReddotManager.ClearLeafNodeCount(ReturnUtils.ReddotTaskNewKey, true)
            return
        end
    end
    if not ReddotManager.GetTreeNode(ReturnUtils.ReddotTaskNewKey) then
        ReddotManager.AddNodeEx("ComeBackTask")
    end
    if ClearCache then
        ReddotManager.ClearLeafNodeCount(ReturnUtils.ReddotTaskNewKey, true)
    end
    local ComeBackQuestConf = ReturnUtils.GetCurrentComeBackQuestInfo(EventID)
    if not ComeBackQuestConf or not ComeBackQuestConf.QuestPhase then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local Num = 0
    local PhaseNum = #ComeBackQuestConf.QuestPhase
    local UnlockInterval = ComeBackQuestConf.PhaseUnlockInterval
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReturnUtils.ReddotTaskNewKey)
    for i = 1, PhaseNum, 1 do
        if Avatar:IsComeBackPhaseUnlocked(EventID, i, UnlockInterval) and CacheDetail[i] == nil then
            CacheDetail[i] = false
            Num = Num + 1
        end
    end
    if Num > 0 then
        -- DebugPrint("lhr1@RefreshComeBackTaskNewReddot", Num, ReddotManager.GetTreeNode(ReturnUtils.ReddotTaskNewKey).Count)
        ReddotManager.IncreaseLeafNodeCount(ReturnUtils.ReddotTaskNewKey, Num)
        ActivityReddotHelper.RefreshReddotNode(EventID)
        -- DebugPrint("lhr1@RefreshComeBackTaskNewReddot", Num, ReddotManager.GetTreeNode(ReturnUtils.ReddotTaskNewKey).Count)
    end
end

function ReturnUtils.RefreshComeBackTaskRewardReddot()
    local EventID = DataMgr.ComeBackEventConstant.CurrentEventId.ConstantValue
    if not EventID then
        if ReddotManager.GetTreeNode(ReturnUtils.ReddotTaskRewardKey) then
            ReddotManager.ClearLeafNodeCount(ReturnUtils.ReddotTaskRewardKey, true)
            return
        end
    end
    if not ActivityUtils.CheckComeBackEventIsOpen(EventID) then
        if ReddotManager.GetTreeNode(ReturnUtils.ReddotTaskRewardKey) then
            ReddotManager.ClearLeafNodeCount(ReturnUtils.ReddotTaskRewardKey, true)
            return
        end
    end
    if not ReddotManager.GetTreeNode(ReturnUtils.ReddotTaskRewardKey) then
        ReddotManager.AddNodeEx("ComeBackTask")
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local ComeBackQuestConf = ReturnUtils.GetCurrentComeBackQuestInfo(EventID)
    if not ComeBackQuestConf or not ComeBackQuestConf.QuestRewardProgress then
        return
    end
    local Num = 0
    local ComeBackData = Avatar.ComeBacks[EventID]
    local RewardProgressConfig = ComeBackQuestConf.QuestRewardProgress
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReturnUtils.ReddotTaskRewardKey)
    local CurProgress = ComeBackData.QuestProgress
    for Idx, Progress in ipairs(RewardProgressConfig) do
        if CurProgress >= Progress and not ComeBackData:HasGotProgressReward(Idx) then
            if not CacheDetail[Idx] then
                CacheDetail[Idx] = 1
                Num = Num + 1
            end
        end
    end
    if Num > 0 then
        ReddotManager.IncreaseLeafNodeCount(ReturnUtils.ReddotTaskRewardKey, Num)
        local Node = ReddotManager.GetTreeNode("ComeBackTask")
        Node:TryFireOnCountChange(Node.Count, true)
        ActivityReddotHelper.RefreshReddotNode(EventID)
    end
end

function ReturnUtils.RefreshComeBackTaskQuestReddot()
    local EventID = DataMgr.ComeBackEventConstant.CurrentEventId.ConstantValue
    if not EventID then
        if ReddotManager.GetTreeNode(ReturnUtils.ReddotTaskQuestKey) then
            ReddotManager.ClearLeafNodeCount(ReturnUtils.ReddotTaskQuestKey, true)
            return
        end
    end
    if not ActivityUtils.CheckComeBackEventIsOpen(EventID) then
        if ReddotManager.GetTreeNode(ReturnUtils.ReddotTaskQuestKey) then
            ReddotManager.ClearLeafNodeCount(ReturnUtils.ReddotTaskQuestKey, true)
            return
        end
    end
    if not ReddotManager.GetTreeNode(ReturnUtils.ReddotTaskQuestKey) then
        ReddotManager.AddNodeEx("ComeBackTask")
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local CommonQuestActivity = Avatar.CommonQuestActivity[EventID]
    if not CommonQuestActivity then
        return
    end
    local ComeBackQuestConf = ReturnUtils.GetCurrentComeBackQuestInfo(EventID)
    if not ComeBackQuestConf or not ComeBackQuestConf.QuestPhase then
        return
    end
    local QuestLists = {}
    local PhaseIdList = {}
    for idx, PhaseId in ipairs(ComeBackQuestConf.QuestPhase) do
        local QuestIds = DataMgr.QuestPhaseId2QuestId[PhaseId]
        if QuestIds then
            local temp_table = {}
            for _, QuestId in ipairs(QuestIds) do
                table.insert(temp_table, QuestId)
            end
            table.insert(QuestLists, temp_table)
            table.insert(PhaseIdList, PhaseId)
        end
    end
    local Num = 0
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReturnUtils.ReddotTaskQuestKey)
    for Idx, QuestList in pairs(QuestLists) do
        if Avatar:IsComeBackPhaseUnlocked(EventID, Idx, ComeBackQuestConf.PhaseUnlockInterval) then
            local PhaseId = PhaseIdList[Idx]
            for _, QuestId in pairs(QuestList) do
                if CommonQuestActivity[QuestId] then
                    local Quest = CommonQuestActivity[QuestId]
                    local Progress = Quest.Progress
                    local Target = Quest.Target
                    local RewardsGot = Quest.RewardsGot
                    if Progress >= Target and not RewardsGot then
                        if not CacheDetail[PhaseId] then
                            CacheDetail[PhaseId] = {}
                        end
                        -- DebugPrint("lhr1@", Idx, QuestId,CacheDetail[PhaseId][QuestId])
                        if not CacheDetail[PhaseId][QuestId] then
                            CacheDetail[PhaseId][QuestId] = 1
                            Num = Num + 1
                        end
                    end
                end
            end
        end
    end
    if Num > 0 then
        ReddotManager.IncreaseLeafNodeCount(ReturnUtils.ReddotTaskQuestKey, Num)
        local Node = ReddotManager.GetTreeNode("ComeBackTask")
        Node:TryFireOnCountChange(Node.Count, true)
        ActivityReddotHelper.RefreshReddotNode(EventID)
    end
end

return ReturnUtils