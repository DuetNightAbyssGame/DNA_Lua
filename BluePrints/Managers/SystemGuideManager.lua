local GameFlowUtils = require "Utils.GameFlowUtils"

local SystemGuideManager={}

SystemGuideManager.GuideDic = {}
SystemGuideManager.GuideUnfinishedDic = {}
SystemGuideManager.GuideQueue = {}
SystemGuideManager.IsGuideStoryRunning = false
SystemGuideManager.RunningId = -1
SystemGuideManager.bOpenDebug = false
SystemGuideManager.GuideEventList = {}
SystemGuideManager.DispatchId = 2057


function SystemGuideManager:AddListenerSystemGuide()
    self:ClearSystemGuideData()
    self:InitSystemGuideData()
    self:RemoveSystemGuideEvents()
    self:AddSystemGuideEvents()
end

function SystemGuideManager:AddSystemGuideEvents()
    self:AddSystemGuideEvent(EventID.SystemGuideEnterRegion, self.EnterRegionEvent)
    self:AddSystemGuideEvent(EventID.SystemGuideExitRegion, self.ExitRegionEvent)
    self:AddSystemGuideEvent(EventID.SystemGuideEnterDungeon, self.EnterDungeonEvent)
    self:AddSystemGuideEvent(EventID.SystemGuideExitDungeon, self.ExitDungeonEvent)
    self:AddSystemGuideEvent(EventID.LoadUI, self.LoadUIEvent)--ShowUIEvent没用事件方式
    self:AddSystemGuideEvent(EventID.UnLoadUI,self.UnLoadUIEvent)--HideUIEvent没用事件方式
    self:AddSystemGuideEvent(EventID.QuestFinished, self.FinishQuestEvent)
    self:AddSystemGuideEvent(EventID.QuestChainFinished, self.FinishQuestChainEvent)
    self:AddSystemGuideEvent(EventID.OnSystemUnlockEnding, self.UIUnlockRuleIdsFinishedEvent)
    self:AddSystemGuideEvent(EventID.OnBecomeViewTarget, self.OnBecomeViewTarget)
    self:AddSystemGuideEvent(EventID.OnEndViewTarget, self.OnEndViewTarget)
    self:AddSystemGuideEvent(EventID.SetInputMode, self.SetInputModeEvent)--存在一帧触发多次
    -- self:AddSystemGuideEvent(EventID.PlayerInIdle, self.SetPlayerInIdleEvent)
    self:AddSystemGuideEvent(EventID.ImpressionTalk, self.ImpressionTalkEvent)
    self:AddSystemGuideEvent(EventID.TalkComp, self.TalkCompEvent)
    self:AddSystemGuideEvent(EventID.OnSystemUnlockWorkingStart, self.SystemUnlockWorkingStartEvent)
    self:AddSystemGuideEvent(EventID.OnSystemUnlockWorkingEnd, self.SystemUnlockWorkingEndEvent)
    self:AddSystemGuideEvent(EventID.FirstSeenTag, self.FirstSeenTagEvent)
    self:AddSystemGuideEvent(EventID.FirstDynQuest, self.FirstDynQuest)
    self:AddSystemGuideEvent(EventID.EndTalk, self.FirstPanFixTalk)
    self:AddSystemGuideEvent(EventID.ConditionComplete, self.ConditionCompleteEvent)
end

function SystemGuideManager:IsNeedAddListener(EventId)
    for key, value in pairs(self.GuideUnfinishedDic) do
        if((EventId == EventID.SystemGuideEnterRegion or EventId == EventID.SystemGuideExitRegion) and value.Data.IsInRegion ~= nil) then
            return true
        elseif((EventId == EventID.SystemGuideEnterDungeon or EventId == EventID.SystemGuideExitDungeon) and value.Data.EnterDungeon ~= nil) then
            return true
        elseif((EventId == EventID.LoadUI or EventId == EventID.UnLoadUI) and value.Data.OpenInterface ~= nil) then
            return true
        elseif(EventId == EventID.QuestFinished and value.Data.FinishQuest ~= nil) then
            return true
        elseif(EventId == EventID.QuestChainFinished and value.Data.FinishQuestChain ~= nil) then
            return true
        elseif(EventId == EventID.OnSystemUnlockEnding and value.Data.UIUnlockRule ~= nil) then
            return true
        -- elseif((EventId == EventID.SetInputMode or EventId == EventID.PlayerInIdle) and value.Data.PlayerInControl ~= nil) then
        --     return true
        elseif(EventId == EventID.SetInputMode and value.Data.PlayerInControl ~= nil) then
            return true
        elseif(EventId == EventID.ImpressionTalk and value.Data.SpecialCondition == "ImpressionTalk") then
            return true
        elseif(EventId == EventID.TalkComp and value.Data.SpecialCondition ~= "ImpressionTalk") then
            return true
        elseif(EventId == EventID.OnSystemUnlockWorkingStart or EventId == EventID.OnSystemUnlockWorkingEnd) then
            return true
        elseif(EventId == EventID.FirstSeenTag and value.Data.FirstSeenTag ~= nil) then
            return true
        elseif(EventId== EventID.FirstDynQuest and value.Data.SpecialCondition == "FirstDynQuest") then
            return true
        elseif(EventId== EventID.EndTalk and value.Data.SpecialCondition == "FirstPanFixTalk") then
            return true
        elseif(EventId== EventID.ConditionComplete and value.Data.ConditionCheck ~= nil) then
            return true
        elseif(EventId== EventID.OnEndViewTarget ) then
            return true
        elseif(EventId== EventID.OnBecomeViewTarget ) then
            return true
        end
    end
    return false
end

function SystemGuideManager:TryRemoveUnusedListener()
    if(#self.GuideEventList > 0) then
        for i=#self.GuideEventList, 1, -1 do
            local EventID = self.GuideEventList[i]
            if(self:IsNeedAddListener(EventID) == false) then
                table.remove(self.GuideEventList,i)
                EventManager:RemoveEvent(EventID, self)
                DebugPrint("SystemGuide EventManager:RemoveEvent:", EventID)
            end
        end
    end
end

function SystemGuideManager:AddSystemGuideEvent(EventID, EventFunc)
    --未完成的引导所需的事件才监听
    if(self:IsNeedAddListener(EventID)) then
        table.insert(self.GuideEventList,EventID)
        EventManager:AddEvent(EventID, self, EventFunc)
        DebugPrint("SystemGuide EventManager:AddEvent:", EventID)
    end
end

function SystemGuideManager:RemoveSystemGuideEvents()
    if(#self.GuideEventList > 0) then
        for i=1, #self.GuideEventList do
            EventManager:RemoveEvent(self.GuideEventList[i], self)
        end
    end
    self.GuideEventList = {}
    DebugPrint("SystemGuide EventManager:RemoveAllEvents")
end

function SystemGuideManager:ClearSystemGuideData()
    DebugPrint("SystemGuide ClearSystemGuideData")
    self.GuideDic = {}
    self.GuideUnfinishedDic = {}
    self.GuideQueue = {}
    self.IsGuideStoryRunning = false
    self.RunningId = -1
    local EMCache = require "EMCache.EMCache"
    EMCache:Remove("GuideSkip", true)
end

function SystemGuideManager:InitSystemGuideData()
    DebugPrint("SystemGuide InitSystemGuideData")
    self.Avatar = GWorld:GetAvatar()
    if not self.Avatar then
        return
    end
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Platform = "PC"
    else
        self.Platform = "Mobile"
    end
    for key, value in pairs(DataMgr.SystemGuide) do
        local Item = {}
        Item.Data = value
        Item.Finished = false
        Item.FinishedQuest = false
        Item.FinishedQuestChain = false
        Item.UIUnlockRule = false
        Item.FinishedOpenInterface = false
        Item.FinishedEnterDungeon = false
        Item.FinishedEnterRegion = false
        Item.FinishedPlayerInControl = true
        -- Item.FinishedPlayerInIdle = true
        Item.FinishedPreSysGuide = false
        Item.FinishedSpecialCondition = false
        Item.FinishedOutTalkComp = true
        Item.FinishedSystemUnlockWorking = true
        Item.FinishedFirstSeenTag = false
        Item.ConditionCheck = false
        Item.GuideStart = value.GuideStart
        if(value.PreSysGuideId == nil) then Item.FinishedPreSysGuide = true end
        if(value.FinishQuest == nil) then Item.FinishedQuest = true end
        if(value.FinishQuestChain == nil) then Item.FinishedQuestChain = true end
        if(value.UIUnlockRule == nil) then Item.UIUnlockRule = true end
        if(value.OpenInterface == nil) then Item.FinishedOpenInterface = true end
        if(value.EnterDungeon == nil) then Item.FinishedEnterDungeon = true end
        if(value.IsInRegion == nil) then Item.FinishedEnterRegion = true end
        if(value.ConditionCheck == nil) then Item.ConditionCheck = true end
        -- if(value.PlayerInControl == nil) then Item.FinishedPlayerInControl = true end
        if(value.SpecialCondition == nil) then Item.FinishedSpecialCondition = true end
        if(value.FirstSeenTag == nil) then Item.FinishedFirstSeenTag = true end
        if((value.FinishQuest ~=nil or value.FinishQuestChain ~=nil or value.UIUnlockRule ~=nil)
        and (value.EnterDungeon == nil and value.IsInRegion == nil)) then
            DebugPrint("Error: EnterDungeon and IsInRegion are all empty -> SysGuideId:" .. value.SysGuideId)
        end
        self.GuideDic[value.SysGuideId] = Item
        self.GuideUnfinishedDic[value.SysGuideId] = Item
    end

    self:InitSystemGuideState()

    for key, value in pairs(DataMgr.SystemGuide) do
        local Item = self.GuideDic[value.SysGuideId]
        local PreItem = self.GuideDic[value.PreSysGuideId]
        if(PreItem ~= nil and PreItem.Finished) then self.GuideDic[value.SysGuideId].FinishedPreSysGuide = true end
    end

end

--从服务端获取引导是否完成数据,是否任务或任务链条件已达成
function SystemGuideManager:InitSystemGuideState()
    for key, value in pairs(DataMgr.SystemGuide) do
        local Item = self.GuideDic[value.SysGuideId]
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            Item.Finished = Avatar.SystemGuides:GetSystemGuide(value.SysGuideId):IsFinished()
            if(Item.Finished) then
                self:RemoveFinishedItemById(value.SysGuideId)
                local NextGuideIds = self:GetItemByPreSysGuideId(value.SysGuideId)
                if(#NextGuideIds > 0 ) then
                    for i=1 , #NextGuideIds do
                    self.GuideDic[NextGuideIds[i]].FinishedPreSysGuide = true
                    end
                end
            end
            if(Item.Data.FinishQuest ~= nil and Avatar:IsQuestFinished(Item.Data.FinishQuest)) then
                Item.FinishedQuest = true
                -- if(Item.FinishedQuest and Item.Finished == false) then
                --     self:FinishQuestEvent(Item.Data.FinishQuest)
                -- end
            end
            if(Item.Data.FinishQuestChain ~= nil and Avatar:IsQuestChainFinished(Item.Data.FinishQuestChain)) then
                Item.FinishedQuestChain = true
                -- if(Item.FinishedQuestChain and Item.Finished == false) then
                --     self:FinishQuestChainEvent(Item.Data.FinishQuestChain)
                -- end
            end

            if(Item.Data.UIUnlockRule ~= nil) then
                local bUnlocked = Avatar:CheckUIUnlocked_Internal(Item.Data.UIUnlockRule)
                if(bUnlocked and Avatar:HasUIUnlockTask() == false) then
                    Item.UIUnlockRule = true
                end
                -- if(Item.UIUnlockRule and Item.Finished == false) then
                --     self:UIUnlockRuleIdFinishedEvent(Item.Data.UIUnlockRule)
                -- end
            end

            if(Item.Data.OpenInterface ~= nil) then
                local Interface = UIManager(GWorld.GameInstance):GetUIObj(Item.Data.OpenInterface)
                if(Interface ~= nil and Interface:IsHide() == false) then
                    Item.FinishedOpenInterface = true
                end
            end
            -- if(Item.Data.ConditionCheck ~= nil) then
            --     local Res =  ConditionUtils.CheckCondition(Avatar, Item.Data.ConditionCheck)
            --     Item.ConditionCheck = Res
            -- end
        end
    end
end

--InitSystemGuideState初始化在avtarstate之前 所以conditon在loginsuccess之后初始化
function SystemGuideManager:InitCondition()
     for key, value in pairs(DataMgr.SystemGuide) do
        local Item = self.GuideDic[value.SysGuideId]
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            self:CheckDispatch()
            Item.Finished = Avatar.SystemGuides:GetSystemGuide(value.SysGuideId):IsFinished()
            if Item.Finished == false then 
                if(Item.Data.ConditionCheck ~= nil) then
                    local Res =  ConditionUtils.CheckCondition(Avatar, Item.Data.ConditionCheck)
                    Item.ConditionCheck = Res
                end
                if(Item.Data.UIUnlockRule ~= nil and Item.UIUnlockRule == false) then
                    local bUnlocked = Avatar:CheckUIUnlocked_Internal(Item.Data.UIUnlockRule)
                    if(bUnlocked and Avatar:HasUIUnlockTask() == false) then
                        Item.UIUnlockRule = true
                    end
                end
            end
        end
    end
end

function SystemGuideManager:CheckDispatch()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        if Avatar.SystemGuides:GetSystemGuide(SystemGuideManager.DispatchId):IsFinished() then
            return
        end
        local Count = Avatar.AchvTargets:GetAchvTarget(519001).Count
        if Count > 0 then
            self:SendDataToServer(SystemGuideManager.DispatchId)
            return
        end
        for Id, Dispatch in pairs(Avatar.Dispatches) do
            if (Dispatch.State == CommonConst.DispatchState.Success or Dispatch.State == CommonConst.DispatchState.Perfect or Dispatch.State == CommonConst.DispatchState.Qualified
                or Dispatch.State == CommonConst.DispatchState.Disqualified) then
                self:SendDataToServer(SystemGuideManager.DispatchId)
                return
            end
        end
        for _, DispatchListProp in ipairs(Avatar.CurrentDispatchList) do
            local Id = DispatchListProp:GetDispatchId()
            if Id ~= -1 then
                if  DispatchListProp:GetDispatchState() == CommonConst.DispatchState.Doing then
                    self:SendDataToServer(SystemGuideManager.DispatchId)
                    return          
                end
            end   
        end
    end
end


function SystemGuideManager:SendDataToServer(GuideId)
    --完成某个引导后判断是否删除无用事件监听
    self:TryRemoveUnusedListener()
    --引导完成后向服务端发送数据
    local Avatar = GWorld:GetAvatar()
    if Avatar == nil then
        DebugPrint("ERROR:Avatar == nil SendDataToServer:" .. GuideId)
        return
    end
    Avatar:FinishSystemGuide(GuideId)
    print(_G.LogTag,GuideId,"SystemGuideFinished")
end

function SystemGuideManager:FinishSystemGuideCallback(Ret,RewardReturn)
	DebugPrint("SystemGuideFinished callback", Ret, RewardReturn)
    if RewardReturn == nil then
        return
    end
    UIManager(GWorld.GameInstance):LoadUI(UIConst.LoadInConfig, "GetItemPage", UIConst.ZORDER_ABOVE_SystemGuide, nil, nil, nil, RewardReturn)
end

function SystemGuideManager:GetItemByUIKey(UIKey)
    local GuideIds = {}
    if(UIKey == nil) then
        DebugPrint("SystemGuide GetItemByUIKey UIKey Is nil")
        return GuideIds
    end
    for key, value in pairs(self.GuideUnfinishedDic) do
        if(UIKey == value.Data.OpenInterface)then
            table.insert(GuideIds,value.Data.SysGuideId)
        end
    end
    return GuideIds
end

function SystemGuideManager:GetItemByDungeonId(DungeonId)
    local GuideIds = {}
    for key, value in pairs(self.GuideUnfinishedDic) do
        if(DungeonId == value.Data.EnterDungeon)then
            table.insert(GuideIds,value.Data.SysGuideId)
        end
    end
    return GuideIds
end

function SystemGuideManager:GetItemByRegion()
    local GuideIds = {}
    for key, value in pairs(self.GuideUnfinishedDic) do
        if(1 == value.Data.IsInRegion)then
            table.insert(GuideIds,value.Data.SysGuideId)
        end
    end
    return GuideIds
end

function SystemGuideManager:GetItemByPlayerInControl()
    local GuideIds = {}
    for key, value in pairs(self.GuideUnfinishedDic) do
        if(1 == value.Data.PlayerInControl)then
            table.insert(GuideIds,value.Data.SysGuideId)
        end
    end
    return GuideIds
end

function SystemGuideManager:GetItemByOutTalkComp()
    local GuideIds = {}
    for key, value in pairs(self.GuideUnfinishedDic) do
        if(value.Data.SpecialCondition ~= "ImpressionTalk")then
            table.insert(GuideIds,value.Data.SysGuideId)
        end
    end
    return GuideIds
end

function SystemGuideManager:GetItemBySystemUnlockWorking()
    local GuideIds = {}
    for key, value in pairs(self.GuideUnfinishedDic) do

        table.insert(GuideIds,value.Data.SysGuideId)
    end
    return GuideIds
end

function SystemGuideManager:GetItemBySpecialCondition(Condition)
    local GuideIds = {}
    for key, value in pairs(self.GuideUnfinishedDic) do
        if(Condition == value.Data.SpecialCondition)then
            table.insert(GuideIds,value.Data.SysGuideId)
        end
    end
    return GuideIds
end

function SystemGuideManager:GetItemByQuestId(QuestId)
    local GuideIds = {}
    for key, value in pairs(self.GuideUnfinishedDic) do
        if(QuestId == value.Data.FinishQuest)then
            table.insert(GuideIds,value.Data.SysGuideId)
        end
    end
    return GuideIds
end

function SystemGuideManager:GetItemByQuestChainId(QuestChainId)
    local GuideIds = {}
    for key, value in pairs(self.GuideUnfinishedDic) do
        if(QuestChainId == value.Data.FinishQuestChain)then
            table.insert(GuideIds,value.Data.SysGuideId)
        end
    end
    return GuideIds
end

function SystemGuideManager:GetItemByUIUnlockRuleId(UIUnlockRuleId)
    local GuideIds = {}
    for key, value in pairs(self.GuideUnfinishedDic) do
        if(UIUnlockRuleId == value.Data.UIUnlockRule)then
            table.insert(GuideIds,value.Data.SysGuideId)
        end
    end
    return GuideIds
end

function SystemGuideManager:GetItemByPreSysGuideId(GuideId)
    local GuideIds = {}
    for key, value in pairs(self.GuideUnfinishedDic) do
        if(GuideId == value.Data.PreSysGuideId)then
            table.insert(GuideIds,value.Data.SysGuideId)
        end
    end
    return GuideIds
end

function SystemGuideManager:GetItemByFirstSeenTag(FirstSeenTag)
    local GuideIds = {}
    for key, value in pairs(self.GuideUnfinishedDic) do
        if(FirstSeenTag == value.Data.FirstSeenTag)then
            table.insert(GuideIds,value.Data.SysGuideId)
        end
    end
    return GuideIds
end

function SystemGuideManager:GetItemByConditionCheck(ConditionId)
    local GuideIds = {}
    for key, value in pairs(self.GuideUnfinishedDic) do
        if(ConditionId == value.Data.ConditionCheck)then
            table.insert(GuideIds,value.Data.SysGuideId)
        end
    end
    return GuideIds
end

function SystemGuideManager:TryRunStoryByGuideId(Source, GuideId, IsDelay)
    if(GuideId == self.RunningId) then
        return
    end
    if not self.Avatar then
        return
    end
    if(self.GuideDic[GuideId].Finished == false 
    and self.GuideDic[GuideId].IsBroken ~= true 
    and self.GuideDic[GuideId].FinishedPreSysGuide 
    and self.GuideDic[GuideId].FinishedQuest 
    and self.GuideDic[GuideId].FinishedQuestChain 
    and self.GuideDic[GuideId].UIUnlockRule 
    and self.GuideDic[GuideId].FinishedOpenInterface
    and self.GuideDic[GuideId].FinishedEnterDungeon
    and self.GuideDic[GuideId].FinishedEnterRegion
    -- and self.GuideDic[GuideId].FinishedPlayerInIdle
    and self.GuideDic[GuideId].FinishedPlayerInControl
    and self.GuideDic[GuideId].FinishedSpecialCondition
    and self.GuideDic[GuideId].FinishedOutTalkComp
    and self.GuideDic[GuideId].FinishedFirstSeenTag
    and self.GuideDic[GuideId].ConditionCheck
    and self.GuideDic[GuideId].FinishedSystemUnlockWorking
    and self.GuideDic[GuideId].GuideStart == 0) then
        if(IsDelay ~= true) then 
            table.insert(self.GuideQueue,GuideId) --条件多次触发可能会插入重复数据
            --DebugPrint("SystemGuideQueueAdd:" .. GuideId .. ",Source:" .. (Source or ""))
        end
        if(self.IsGuideStoryRunning == false) then
             self:RunStory(self.GuideDic[GuideId].Data)
        end
    elseif IsDelay and self.RunningId ~= GuideId then
        --DebugPrint("SystemGuideIsDelay ", Source, GuideId)
        self:GuideQueueRemove(GuideId, "TryRunStoryByGuideIdDelay")
    else
        if self.Platform == "PC" and self.bOpenDebug then
            PrintTable(self.GuideDic[GuideId],3,"SystemGuide TryRunSourceFail")
        end
    end
end

function SystemGuideManager:PrintDataInfo(Data,Guide)
    --PrintTable(self.GuideDic[Guide],3,"SystemGuide TryRunSourceFail")
    -- DebugPrint("GuideDataInfo.Id",Guide)
    -- DebugPrint("GuideDataInfo.Finished",Data.Finished,Guide)
    -- DebugPrint("GuideDataInfo.IsBroken",Data.IsBroken,Guide)
    -- DebugPrint("GuideDataInfo.FinishedPreSysGuide",Data.FinishedPreSysGuide,Guide)
    -- DebugPrint("GuideDataInfo.FinishedQuest",Data.FinishedQuest,Guide)
    -- DebugPrint("GuideDataInfo.FinishedQuestChain",Data.FinishedQuestChain,Guide)
    -- DebugPrint("GuideDataInfo.UIUnlockRule",Data.UIUnlockRule,Guide)
    -- DebugPrint("GuideDataInfo.FinishedOpenInterface",Data.FinishedOpenInterface,Guide)
    -- DebugPrint("GuideDataInfo.FinishedEnterDungeon",Data.FinishedEnterDungeon,Guide)
    -- DebugPrint("GuideDataInfo.FinishedEnterRegion",Data.FinishedEnterRegion,Guide)
    -- DebugPrint("GuideDataInfo.FinishedPlayerInControl",Data.FinishedPlayerInControl,Guide)
    -- DebugPrint("GuideDataInfo.FinishedSpecialCondition",Data.FinishedSpecialCondition,Guide)
    -- DebugPrint("GuideDataInfo.FinishedOutTalkComp",Data.FinishedOutTalkComp,Guide)
    -- DebugPrint("GuideDataInfo.FinishedFirstSeenTag",Data.FinishedFirstSeenTag,Guide)
    -- DebugPrint("GuideDataInfo.ConditionCheck",Data.ConditionCheck,Guide)
    -- DebugPrint("GuideDataInfo.FinishedSystemUnlockWorking",Data.FinishedSystemUnlockWorking,Guide)
end

function SystemGuideManager:GuideQueueRemove(GuideId, Source)
    if(#self.GuideQueue > 0) then
        for j=1,#self.GuideQueue do
            if(self.GuideQueue[j] == GuideId and self.RunningId ~= GuideId) then
                table.remove(self.GuideQueue,j)
                DebugPrint("SystemGuideQueueRemove:" .. GuideId .. ",Source:" .. (Source or ""))
            end
        end
        -- table.remove(self.GuideQueue,1) --用上面的方式删除
        if(#self.GuideQueue > 0) then
            self:TryRunStoryByGuideId("GuideQueueNext,RemoveId:" .. GuideId, self.GuideQueue[1],true)
        else
            UIManager():FallbackAfterLoadingMgr()
        end
    end
end

function SystemGuideManager:LoadUIEvent(UIKey)
    DebugPrint("SystemGuide LoadUIEvent UIKey:", UIKey)
    self:ShowUIEvent(UIKey)
end

function SystemGuideManager:ShowUIEvent(UIKey)
    if self.Invalid then return end
    DebugPrint("SystemGuide ShowUIEvent UIKey:", UIKey)
    local GuideIds = self:GetItemByUIKey(UIKey)
    if UIKey == "BattleMain" then
        local Player=UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
        if Player and Player.CleanInputWhenEnterTalk then
            Player:CleanInputWhenEnterTalk(false)
        end
    end
    if(#GuideIds  > 0 ) then
        for i=1 , #GuideIds do
            self.GuideDic[GuideIds[i]].FinishedOpenInterface = true
            self:TryRunStoryByGuideId("LoadUIEvent:" .. UIKey, GuideIds[i])
        end
    end
end

function SystemGuideManager:UnLoadUIEvent(UIKey)
    DebugPrint("SystemGuide UnLoadUIEvent UIKey:", UIKey)
    self:HideUIEvent(UIKey)
end

function SystemGuideManager:HideUIEvent(UIKey)
    if self.Invalid then return end
    DebugPrint("SystemGuide HideUIEvent UIKey:", UIKey)
    local GuideIds = self:GetItemByUIKey(UIKey)
    if(#GuideIds  > 0 ) then
        for i=1 , #GuideIds do
            self.GuideDic[GuideIds[i]].FinishedOpenInterface = false
            if(#self.GuideQueue > 0) then
                for j=1,#self.GuideQueue do
                    if(self.GuideQueue[j] == GuideIds[i] and self.RunningId ~=  GuideIds[i]) then
                        table.remove(self.GuideQueue,j)
                        DebugPrint("SystemGuideQueueRemoveUnLoadUIEvent:" .. GuideIds[i])
                    end
                end
            end
        end
    end
end

function SystemGuideManager:EnterRegionEvent()
    if self.Invalid then return end
    DebugPrint("SystemGuide EnterRegionEvent")
    local GuideIds = self:GetItemByRegion()
    if(#GuideIds  > 0 ) then
        for i=1 , #GuideIds do
            self.GuideDic[GuideIds[i]].FinishedEnterRegion = true
            self:TryRunStoryByGuideId("EnterRegionEvent", GuideIds[i])
        end
    end
end

function SystemGuideManager:ExitRegionEvent()
    if self.Invalid then return end
    DebugPrint("SystemGuide ExitRegionEvent")
    local GuideIds = self:GetItemByRegion()
    if(#GuideIds  > 0 ) then
        for i=1 , #GuideIds do
            self.GuideDic[GuideIds[i]].FinishedEnterRegion = false
            if(#self.GuideQueue > 0) then
                for j=1,#self.GuideQueue do
                    if(self.GuideQueue[j] == GuideIds[i] and self.RunningId ~=  GuideIds[i]) then
                        table.remove(self.GuideQueue,j)
                        DebugPrint("SystemGuideQueueRemoveExitRegionEvent:" .. GuideIds[i])
                    end
                end
            end
        end
    end
end

function SystemGuideManager:EnterDungeonEvent(DungeonId)
    if self.Invalid then return end
    DebugPrint("SystemGuide EnterDungeonEvent DungeonId:", DungeonId)
    EventManager:FireEvent(EventID.SystemGuideExitRegion)
    local GuideIds = self:GetItemByDungeonId(DungeonId)
    if(#GuideIds  > 0 ) then
        for i=1 , #GuideIds do
            self.GuideDic[GuideIds[i]].FinishedEnterDungeon = true
            self:TryRunStoryByGuideId("EnterDungeonEvent,DungeonId:" .. DungeonId, GuideIds[i])
        end
    end
end

function SystemGuideManager:ExitDungeonEvent(DungeonId)
    if self.Invalid then return end
    DebugPrint("SystemGuide ExitDungeonEvent DungeonId:", DungeonId)
    local GuideIds = self:GetItemByDungeonId(DungeonId)
    if(#GuideIds  > 0 ) then
        for i=1 , #GuideIds do
            self.GuideDic[GuideIds[i]].FinishedEnterDungeon = false
            if(#self.GuideQueue > 0) then
                for j=1,#self.GuideQueue do
                    if(self.GuideQueue[j] == GuideIds[i] and self.RunningId ~=  GuideIds[i]) then
                        table.remove(self.GuideQueue,j)
                        DebugPrint("SystemGuideQueueRemoveExitDungeonEvent:" .. GuideIds[i])
                    end
                end
            end
        end
    end
end

function SystemGuideManager:SystemUnlockWorkingStartEvent()
    if self.Invalid then return end
    DebugPrint("SystemGuide SystemUnlockWorkingStartEvent")
    local GuideIds = self:GetItemBySystemUnlockWorking()
    if(#GuideIds  > 0 ) then
        for i=1 , #GuideIds do
            self.GuideDic[GuideIds[i]].FinishedSystemUnlockWorking = false
            if(#self.GuideQueue > 0) then
                for j=1,#self.GuideQueue do
                    if(self.GuideQueue[j] == GuideIds[i] and self.RunningId ~=  GuideIds[i]) then
                        table.remove(self.GuideQueue,j)
                        DebugPrint("SystemGuideQueueRemoveSystemUnlockWorkingStartEvent:" .. GuideIds[i])
                    end
                end
            end
        end
    end
end

function SystemGuideManager:SystemUnlockWorkingEndEvent()
    if self.Invalid then return end
    DebugPrint("SystemGuide SystemUnlockWorkingEndEvent")
    local GuideIds = self:GetItemBySystemUnlockWorking()
    if(#GuideIds  > 0 ) then
        for i=1 , #GuideIds do
            if self.GuideDic[GuideIds[i]].FinishedSystemUnlockWorking == false then
                self.GuideDic[GuideIds[i]].FinishedSystemUnlockWorking = true
                self:TryRunStoryByGuideId("SystemUnlockWorkingEndEvent:", GuideIds[i])
            end
        end
    end
end

function SystemGuideManager:FirstSeenTagEvent(FirstSeenTag)
    if self.Invalid then return end
    DebugPrint("SystemGuide FirstSeenTagEvent ",FirstSeenTag)
    local GuideIds = self:GetItemByFirstSeenTag(FirstSeenTag)
    if(#GuideIds  > 0 ) then
        for i=1 , #GuideIds do
            self.GuideDic[GuideIds[i]].FinishedFirstSeenTag = true
            self:TryRunStoryByGuideId("FirstSeenTagEvent:" .. FirstSeenTag, GuideIds[i])
        end
    end
end

function SystemGuideManager:FirstDynQuest()
    if self.Invalid then return end
    DebugPrint("Systemguide FirstDynQuest")
    local GuideIds = self:GetItemBySpecialCondition("FirstDynQuest")
    if(#GuideIds  > 0 ) then
        for i=1 , #GuideIds do
            self.GuideDic[GuideIds[i]].FinishedSpecialCondition = true
            self:TryRunStoryByGuideId("FirstDynQuest", GuideIds[i])
        end
    end
end

function SystemGuideManager:FirstPanFixTalk(Message)
    if self.Invalid then
        return
    end

	if (Message.TalkType ~= "PanFixSimple") then
		return
	end

    DebugPrint("Systemguide FirstPanFixTalk")
    local GuideIds = self:GetItemBySpecialCondition("FirstPanFixTalk")
    if (#GuideIds > 0) then
        for i = 1, #GuideIds do
            self.GuideDic[GuideIds[i]].FinishedSpecialCondition = true
            self:TryRunStoryByGuideId("FirstPanFixTalk", GuideIds[i])
        end
    end
end

function SystemGuideManager:ConditionCompleteEvent(ConditionId)
    if self.Invalid then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    DebugPrint("Systemguide ConditionCheck",ConditionId)
    local Res =  ConditionUtils.CheckCondition(Avatar, ConditionId)
    local GuideIds = self:GetItemByConditionCheck(ConditionId)
    if (#GuideIds > 0) then
        for i = 1, #GuideIds do
            self.GuideDic[GuideIds[i]].ConditionCheck = Res
            self:TryRunStoryByGuideId("ConditionCheck", GuideIds[i])
        end
    end
end



function SystemGuideManager:FinishSystemGuideEvent(GuideId)
    DebugPrint("SystemGuide FinishSystemGuideEvent GuideId:", GuideId)
    self.GuideDic[GuideId].Finished = true
    self:RemoveFinishedItemById(GuideId)
    self:SendDataToServer(GuideId)
    local NextGuideIds = self:GetItemByPreSysGuideId(GuideId)
    if(#NextGuideIds > 0 ) then
        for i=1 , #NextGuideIds do
            self.GuideDic[NextGuideIds[i]].FinishedPreSysGuide = true
        self:TryRunStoryByGuideId("FinishedPreSysGuide:" .. GuideId, NextGuideIds[i])
        end
    end
end

function SystemGuideManager:FinishQuestEvent(QuestId)
    if self.Invalid then return end
    DebugPrint("SystemGuide FinishQuestEvent Id:", QuestId)
    local GuideIds = self:GetItemByQuestId(QuestId)
    if(#GuideIds  > 0 ) then
        for i=1 , #GuideIds do
            self.GuideDic[GuideIds[i]].FinishedQuest = true
            self:TryRunStoryByGuideId("FinishQuestEvent", GuideIds[i])
        end
    end
end

function SystemGuideManager:FinishQuestChainEvent(QuestChainId)
    if self.Invalid then return end
    DebugPrint("SystemGuide FinishQuestChainEvent Id:", QuestChainId)
    local GuideIds = self:GetItemByQuestChainId(QuestChainId)
    if(#GuideIds  > 0 ) then
        for i=1 , #GuideIds do
            self.GuideDic[GuideIds[i]].FinishedQuestChain = true
            self:TryRunStoryByGuideId("FinishQuestChainEvent", GuideIds[i])
        end
    end
end

function SystemGuideManager:UIUnlockRuleIdsFinishedEvent(Ids)
    for _,Id in pairs(Ids:ToTable()) do
        self:UIUnlockRuleIdFinishedEvent(Id)
    end
end

function SystemGuideManager:UIUnlockRuleIdFinishedEvent(Id)
    if self.Invalid then return end
    DebugPrint("SystemGuide UIUnlockRuleIdFinishedEvent Id:", Id)
    local GuideIds = self:GetItemByUIUnlockRuleId(Id)
    if(#GuideIds  > 0 ) then
        for i=1 , #GuideIds do
            self.GuideDic[GuideIds[i]].UIUnlockRule = true
            self:TryRunStoryByGuideId("UIUnlockRuleIdFinishedEvent", GuideIds[i])
        end
    end
end

function SystemGuideManager:UIUnlockRuleIdUnFinishedEvent(Id)
    if self.Invalid then return end
    DebugPrint("SystemGuide UIUnlockRuleIdUnFinishedEvent Id:", Id)
    local GuideIds = self:GetItemByUIUnlockRuleId(Id)
    if(#GuideIds  > 0 ) then
        for i=1 , #GuideIds do
            self.GuideDic[GuideIds[i]].UIUnlockRule = false
            if(#self.GuideQueue > 0) then
                for j=1,#self.GuideQueue do
                    if(self.GuideQueue[j] == GuideIds[i] and self.RunningId ~=  GuideIds[i]) then
                        table.remove(self.GuideQueue,j)
                        DebugPrint("UIUnlockRuleIdUnFinishedEvent:" .. GuideIds[i])
                    end
                end
            end
        end
    end
end

function SystemGuideManager:OnBecomeViewTarget()
    self.OnBecomeView = true
    self:SetInputModeEvent(self.IsUIOnly)
end

function SystemGuideManager:OnEndViewTarget()
    self.OnBecomeView = false
    self:SetInputModeEvent(self.IsUIOnly)
end


function SystemGuideManager:SetInputModeEvent(IsUIOnly)
    -- DebugPrint(IsUIOnly,"SystemGuide SetInputModeEvent IsUIOnly")
    if self.Invalid then return end
    self.IsUIOnly = IsUIOnly
    DebugPrint("SystemGuide SetInputModeEvent IsUIOnly:", IsUIOnly)
    local GuideIds = self:GetItemByPlayerInControl()
    if(#GuideIds  > 0 ) then
        for i=1 , #GuideIds do
            if(not IsUIOnly and self.OnBecomeView) then
                self.GuideDic[GuideIds[i]].FinishedPlayerInControl = true
                self:TryRunStoryByGuideId("SetInputModeEvent:IsUIOnly==False", GuideIds[i])
            else
                self.GuideDic[GuideIds[i]].FinishedPlayerInControl = false
                if(#self.GuideQueue > 0) then
                    for j=1,#self.GuideQueue do
                        if(self.GuideQueue[j] == GuideIds[i] and self.RunningId ~=  GuideIds[i]) then
                            table.remove(self.GuideQueue,j)
                            DebugPrint("SystemGuideQueueRemoveSetInputModeEvent:" .. GuideIds[i])
                        end
                    end
                end
            end
        end
    end
end

function SystemGuideManager:TalkCompEvent(IsInTalkComp)
    DebugPrint("Systemguide TalkCompEvent IsInTalkComp:", IsInTalkComp)
    if self.Invalid then return end
    local GuideIds = self:GetItemByOutTalkComp()
    if(#GuideIds  > 0 ) then
        for i=1 , #GuideIds do
            if(IsInTalkComp == false) then
                self.GuideDic[GuideIds[i]].FinishedOutTalkComp = true
                self:TryRunStoryByGuideId("TalkCompEvent:IsInTalkComp==False", GuideIds[i])
            else
                self.GuideDic[GuideIds[i]].FinishedOutTalkComp = false
                if(#self.GuideQueue > 0) then
                    for j=1,#self.GuideQueue do
                        if(self.GuideQueue[j] == GuideIds[i] and self.RunningId ~=  GuideIds[i]) then
                            table.remove(self.GuideQueue,j)
                            DebugPrint("SystemGuideQueueRemoveTalkCompEvent:" .. GuideIds[i])
                        end
                    end
                end
            end
        end
    end
end

function SystemGuideManager:ImpressionTalkEvent()
    if self.Invalid then return end
    DebugPrint("Systemguide ImpressionTalkEvent")
    local GuideIds = self:GetItemBySpecialCondition("ImpressionTalk")
    if(#GuideIds  > 0 ) then
        for i=1 , #GuideIds do
            self.GuideDic[GuideIds[i]].FinishedSpecialCondition = true
            self:TryRunStoryByGuideId("ImpressionTalkEvent", GuideIds[i])
        end
    end
end

-- function SystemGuideManager:SetPlayerInIdleEvent(IsIdle)
--     if self.Invalid then return end
--     local GuideIds = self:GetItemByPlayerInControl()
--     if(#GuideIds  > 0 ) then
--         for i=1 , #GuideIds do
--             if(IsIdle == true) then
--                 self.GuideDic[GuideIds[i]].FinishedPlayerInIdle = true
--                 self:TryRunStoryByGuideId("SetPlayerInIdleEvent,IsIdle==true", GuideIds[i])
--             else
--                 self.GuideDic[GuideIds[i]].FinishedPlayerInIdle = false
--                 if(#self.GuideQueue > 0) then
--                     for j=1,#self.GuideQueue do
--                         if(self.GuideQueue[j] == GuideIds[i] and self.RunningId ~=  GuideIds[i]) then
--                             table.remove(self.GuideQueue,j)
--                             DebugPrint("SystemGuideQueueRemoveSetPlayerInIdleEvent:" .. GuideIds[i])
--                         end
--                     end
--                 end
--             end
--         end
--     end
-- end

function SystemGuideManager:RunStory(Data)
    local StoryLinePath = Data.GuideStoryline
    local FinishGuideType = Data.GuideEnd
    local GuideId = Data.SysGuideId
    DebugPrint("RunStory,GuideId:" .. GuideId)
    --处理未监听到的SetInputMode事件
    if(DataMgr.SystemGuide[GuideId].PlayerInControl == 1) then
        local CurMode =  UE4.URuntimeCommonFunctionLibrary.GetInputMode(GWorld.GameInstance:GetWorld())
        DebugPrint("GuideId:",GuideId,"CurMode:",CurMode,"PlayerInControl Systemguide RunStory")
        if(CurMode == "UIOnly") then -- or CurMode == "GameAndUI") then
            DebugPrint("GuideId:",GuideId,"CurMode:",CurMode,"PlayerInControl Systemguide RunStory Error ")
            self:SetInputModeEvent(true)
            self:GuideQueueRemove(GuideId, "PlayerInControlRunStoryError")
            return
        end
    end
    --系统引导初始化获时取到的UIUnlockRule是否完成不一定正确，这里重新判断
    local Quest = DataMgr.SystemGuide[GuideId].UIUnlockRule
    if(Quest ~= nil) then
        local Avatar = GWorld:GetAvatar()
         if(Avatar and Avatar:HasUIUnlockTask()) then
            DebugPrint("GuideId:",GuideId,"Quest:",Quest,"HasUIUnlockTask Systemguide RunStory Error ")
            self:UIUnlockRuleIdUnFinishedEvent(Quest)
            self:GuideQueueRemove(GuideId, "HasUIUnlockTaskRunStoryError")
            return
         end
    end

    DebugPrint("RunStory,SystemGuideId:" .. GuideId)

    local GuideChannel = DataMgr.SystemGuide[GuideId].GuideChannel
    if not GuideChannel then
        DebugPrint("引导缺少通道配置",GuideId)
        return
    end
    if GuideId == self.RunningId then
        DebugPrint("lkkk引导重复触发",GuideId)
        return
    end
    -- if self.Flow ~= nil then
    --     table.insert(self.GuideQueue, GuideId)
    --     DebugPrint("lkkk当前引导未结束",self.RunningId)
    --     return
    -- end
    local GameFlow = GameFlowUtils:AddFlow(GuideChannel, {
        GWorld.GameInstance, function(_, Flow)
            local Avatar = GWorld:GetAvatar()
            if not Avatar then
                return
            end
            if Avatar.SystemGuides:GetSystemGuide(GuideId):IsFinished() then
                self:RemoveFlow(Flow)
                return
            end
            EventManager:FireEvent(EventID.OnGuideStart, GuideId)
            self.RunningId = GuideId
            self.IsGuideStoryRunning = true
            if (FinishGuideType == 0) then
                self:FinishSystemGuideEvent(GuideId)
                local Callback = function ()
                    self:RemoveFlow(Flow)
                    self.RunningId = -1
                    self.IsGuideStoryRunning = false
                    self:GuideQueueRemove(GuideId, "FinishSystemGuideEvent,FinishGuideType == 0")
                    EventManager:FireEvent(EventID.OnGuideEnd, GuideId)
                    self:SetFocusOnGamepad()
                end
                GWorld.StoryMgr:RunStory(StoryLinePath,nil,nil,Callback,Callback)
                DebugPrint("SystemGuideManagerRunStory",StoryLinePath,GuideId,FinishGuideType)
            elseif (FinishGuideType == 1) then
                local EndCallback = function()
                    self:RemoveFlow(Flow)
                    self.RunningId = -1
                    self.IsGuideStoryRunning = false
                    self:GuideQueueRemove(GuideId, "FinishSystemGuideEvent,FinishGuideType == 1")
                    self:FinishSystemGuideEvent(GuideId)
                    EventManager:FireEvent(EventID.OnGuideEnd, GuideId)
                    self:SetFocusOnGamepad()
                end
                local StopCallback = function()
                    self:RemoveFlow(Flow)
                    self.RunningId = -1
                    self.IsGuideStoryRunning = false
                    self:FinishSystemGuideEvent(GuideId)
                    self:GuideQueueRemove(GuideId, "FinishSystemGuideEvent,FinishGuideType == 1")
                    EventManager:FireEvent(EventID.OnGuideEnd, GuideId)
                    self:SetFocusOnGamepad()
                end
                GWorld.StoryMgr:RunStory(StoryLinePath,nil,nil,EndCallback,StopCallback)
                DebugPrint("SystemGuideManagerRunStory",StoryLinePath,GuideId,FinishGuideType)
            end
        end
    })
end

function SystemGuideManager:SetFocusOnGamepad()
    local bIsGamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
    if not bIsGamepad then return end
    -- local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    -- local UIManger = GameInstance:GetGameUIManager()
    local TopUI = UIManager(GWorld.GameInstance):GetLastestAndFocusableUIWidgetObj()
    if(TopUI ~= nil) then
        TopUI:SetFocus()
    end


end

function SystemGuideManager:RemoveFlow(Flow)
    GameFlowUtils:RemoveFlow(Flow)
end

function SystemGuideManager:RemoveCurStl()
    local GuideId = self.RunningId
    if(GuideId ~= -1) then
        -- self.RunningId = -1
        -- self.IsGuideStoryRunning = false
        self.GuideDic[GuideId].IsBroken = true
        --self:GuideQueueRemove(GuideId, "ErrorExitRemoveCurStl")
    end
end

function SystemGuideManager:GMEnforceFinishAllSysGuide()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    for _, value in pairs(DataMgr.SystemGuide) do
        local Item = self.GuideDic[value.SysGuideId]
        if Item == nil then
            DebugPrint("ERROR:SystemGuideManager Item is nil, SysGuideId:" ,value.SysGuideId)
        else
            Item.Finished = Avatar.SystemGuides:GetSystemGuide(value.SysGuideId):IsFinished()
            if not Item.Finished then
                Item.Finished = true
                self:RemoveFinishedItemById(value.SysGuideId)
                self:SendDataToServer(value.SysGuideId)
            end
        end
    end

end

function SystemGuideManager:RemoveFinishedItemById(Id)
    for key, value in pairs(self.GuideUnfinishedDic) do
        if(value.Data.SysGuideId == Id) then
            self.GuideUnfinishedDic[key] = nil
            DebugPrint("SystemGuide RemoveFinishedItemById:", Id)
        end
    end
end


function SystemGuideManager:RunGuideById(GuideId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local Finish = Avatar.SystemGuides:GetSystemGuide(GuideId):IsFinished()
    if Finish then return end
    if self.GuideDic[GuideId] and self.GuideDic[GuideId].GuideStart then
        local GuideStart = self.GuideDic[GuideId].GuideStart
        if GuideStart == 0 then return end
        if(self.GuideDic[GuideId].Finished == false 
        and self.GuideDic[GuideId].IsBroken ~= true 
        and self.GuideDic[GuideId].FinishedPreSysGuide 
        and self.GuideDic[GuideId].FinishedQuest 
        and self.GuideDic[GuideId].FinishedQuestChain 
        and self.GuideDic[GuideId].UIUnlockRule 
        and self.GuideDic[GuideId].FinishedOpenInterface
        and self.GuideDic[GuideId].FinishedEnterDungeon
        and self.GuideDic[GuideId].FinishedEnterRegion
        -- and self.GuideDic[GuideId].FinishedPlayerInIdle
        and self.GuideDic[GuideId].FinishedPlayerInControl
        and self.GuideDic[GuideId].FinishedSpecialCondition
        and self.GuideDic[GuideId].FinishedOutTalkComp
        and self.GuideDic[GuideId].FinishedFirstSeenTag
        and self.GuideDic[GuideId].ConditionCheck
        and self.GuideDic[GuideId].FinishedSystemUnlockWorking) then
            self:RunStory(self.GuideDic[GuideId].Data)
        else
            if self.Platform == "PC" and self.bOpenDebug then
                PrintTable(self.GuideDic[GuideId],3,"SystemGuide TryRunSourceFail")
            end
        end
    end  
end

return SystemGuideManager