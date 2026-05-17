---@class SignBoardBubbleTalkController :Controller
local M = Class("BluePrints.Common.MVC.Controller")

local SignBoardBubbleTalkModel = require "BluePrints.UI.WBP.SignBoardBubble.SignBoardBubbleTalkModel"
local SignBoardBubbleTalkCommon = require "BluePrints.UI.WBP.SignBoardBubble.SignBoardBubbleTalkCommon"


function M:Init()
    M.Super.Init(self)
    -- EventManager:AddEvent(EventID.OnTalkTriggerComplete, self, self.OnTalkTriggerComplete)
    -- DebugPrint("Avatar:CheckSubRegionType(Avatar:GetCurrentRegionId(), CommonConst.SubRegionType.Home)", 
    --     Avatar:CheckSubRegionType(Avatar:GetCurrentRegionId(), CommonConst.SubRegionType.Home))
    EventManager:AddEvent(EventID.UpdateSignBoardNpc, self, self.OnUpdateSignBoardNpc)
    EventManager:AddEvent(EventID.CloseLoading, self, self.OnCloseLoading)
end

function M:Destory()
    -- EventManager:RemoveEvent(EventID.CloseLoading, self)
    M.Super.Destory(self)
    -- EventManager:RemoveEvent(EventID.OnTalkTriggerComplete, self)
    EventManager:RemoveEvent(EventID.UpdateSignBoardNpc, self)
    local BoardSystem = UBoardBubbleSubsystem.GetSubsystem(GWorld.GameInstance)
    if not BoardSystem then return end
    BoardSystem:RemoveTimer(self.Timer)
    self.Timer = nil
end

function M:OnCloseLoading()
    local Avatar = self:GetAvatar()
    local bIsInBigWorld = Avatar and Avatar:IsInBigWorld()
    local bIsInHomeBase = Avatar and Avatar:CheckSubRegionType(Avatar:GetCurrentRegionId(), CommonConst.SubRegionType.Home)
    if Avatar and bIsInBigWorld and bIsInHomeBase then 
        self:StartHomeBase()
    end
end

function M:StopTalkTrigger(RunningTriggerId)
    if RunningTriggerId ~= SignBoardBubbleTalkModel:GetRunningTalkTrigger() then return end
    local InvitateBubbleTalkKey = SignBoardBubbleTalkModel:GetRunningTalkTriggerBubbleKey()
    self.InvitateBubbleTalkKey = nil
    local TS = TalkSubsystem()
    SignBoardBubbleTalkModel:SetRunningTalkTrigger(nil, nil)
    if InvitateBubbleTalkKey then
        TS:ForceInterruptTalkTaskData(function(TalkTaskData)
            return TalkTaskData.FilePath == InvitateBubbleTalkKey
        end)
        SignBoardBubbleTalkModel:ResetTalkWaitTime(RunningTriggerId)
    end
end

function M:RecordBubbleDialogue(DialogueId)
    local Avatar = self:GetAvatar()
    if not Avatar then return end
    local DialogueData = DataMgr.Dialogue[DialogueId]
    if not DialogueData then return end
    -- if Avatar:CheckSignBoardNpcTalkIsRecord(DialogueData.SpeakNpcId, DialogueId) then return end
    if not Avatar:CheckSignBoardNpcTalkValid(DialogueData.SpeakNpcId, DialogueId) then return end
    Avatar:TriggerRecordSignBoardNpcTalk(DialogueData.SpeakNpcId, DialogueId)
end

function M:StartTalkTrigger(GossipTriggerId)
    local TalkTriggerId = SignBoardBubbleTalkModel:GetTalkTriggerId(GossipTriggerId)
    local Avatar = self:GetAvatar()
   -- DebugPrint("TalkTriggerId", TalkTriggerId)
    if not TalkTriggerId then return end
    if not Avatar then return end
    -- local TS = TalkSubsystem()
    SignBoardBubbleTalkModel:SetRunningTalkTrigger(GossipTriggerId)
    local OnTriggerFailedOrEnd = function()
        self:StopTalkTrigger(GossipTriggerId)
    end
    local OnTriggerSucces = function()
        local GameInstance = GWorld.GameInstance
        ---@type BP_TalkContext_C
        local TalkContext = GameInstance:GetTalkContext()
        local InvitateBubbleTalkKey = TalkContext:StartTalk(TalkTriggerId, 
            nil, nil, nil, nil, {
                Func = OnTriggerFailedOrEnd,
                Obj = self
            }, {
                Obj = self,
                Func = self.RecordBubbleDialogue
            }, SignBoardBubbleTalkModel:GetNpcCombination(GossipTriggerId))
        if GossipTriggerId == SignBoardBubbleTalkModel:GetRunningTalkTrigger() then
            SignBoardBubbleTalkModel:SetRunningTalkTrigger(GossipTriggerId, InvitateBubbleTalkKey)
        end
        --SignBoardBubbleTalkModel:ResetTalkWaitTime()
    end

    local NpcId = SignBoardBubbleTalkModel:GetServerCanTriggerNpc(GossipTriggerId)

    Avatar:TriggerAddSignBoardNpcDailyTalk(NpcId, function(bSuccess)
       -- DebugPrint("bSuccess", bSuccess)
        if bSuccess and GossipTriggerId == SignBoardBubbleTalkModel:GetRunningTalkTrigger() then 
            OnTriggerSucces()
        else
            OnTriggerFailedOrEnd()
        end
    end)
end

function M:TickCheck()
    local Avatar = self:GetAvatar()
    local BoardSystem = UBoardBubbleSubsystem.GetSubsystem(GWorld.GameInstance)
    if not BoardSystem then return end
    if not Avatar then 
        BoardSystem:RemoveTimer(self.Timer)
        self.Timer = nil
        return 
    end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if not IsValid(Player) then return end
    --DebugPrint("TickCheck")
    -- DebugPrint("TickCheck")
    local CanTriggers = BoardSystem:TickCheck()
    local TriggerMap = {}
    for _, TriggerId in pairs(CanTriggers) do
        TriggerMap[TriggerId] = true
        SignBoardBubbleTalkModel:AddStartWaitTrigger(TriggerId)
    end

    local TriggerQueue = SignBoardBubbleTalkModel:GetWaitTriggerQueue()
    local ToRemove = nil
    for WaitTriggerId, _ in pairs(TriggerQueue) do
        -- DebugPrint(WaitTriggerId, SignBoardBubbleTalkModel:CheckTriggerDistance(WaitTriggerId), 
        --     SignBoardBubbleTalkModel:CheckCanTrigger(WaitTriggerId))
        if not TriggerMap[WaitTriggerId] or not Player:CheckCanInteractiveTrigger() then
            ToRemove = ToRemove or {} --- 印象中源码循环中只删不增没问题，保险起见还是存到Table里删吧
            table.insert(ToRemove, WaitTriggerId)
        end
    end

    if ToRemove then
        for index, TriggerId in ipairs(ToRemove) do
            --Print("ToRemove", TriggerId)
            --DebugPrint("ToRemove", TriggerId, SignBoardBubbleTalkModel:CheckCanTrigger(TriggerId))
            SignBoardBubbleTalkModel:RemoveWaitTrigger(TriggerId)
        end
    end

    local RunningTriggerId = SignBoardBubbleTalkModel:GetRunningTalkTrigger()
    --DebugPrint("SignBoardBubbleTalkModel:CheckTriggerDistance(RunningTriggerId)", SignBoardBubbleTalkModel:CheckTriggerDistance(RunningTriggerId) or false)
    if not SignBoardBubbleTalkModel:CheckTriggerDistance(RunningTriggerId) then
        self:StopTalkTrigger(RunningTriggerId)
    end

    local NewTriggerId = SignBoardBubbleTalkModel:CheckWaitTriggerQueue()
    -- DebugPrint("NewTriggerId", NewTriggerId)
    if NewTriggerId then
        self:StartTalkTrigger(NewTriggerId)
    end
end


function M:StartHomeBase() 
    DebugPrint("SignBoardBubbleTalkController:StartHomeBase")
    local BoardSystem = UBoardBubbleSubsystem.GetSubsystem(GWorld.GameInstance)
    if not BoardSystem then return end
    BoardSystem:RemoveTimer(self.Timer)
    self.Timer = nil
    -- BoardSystem:AddTickCheckCharacter
    local Avatar = GWorld:GetAvatar()
    BoardSystem:ClearTickCheckCharacters()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if Avatar then
        for key ,value in pairs(Avatar.SignBoardNpc) do
            BoardSystem:AddTickCheckCharacter(value, key, SignBoardBubbleTalkCommon.NpcPoint[key])
        end
    end
    if IsValid(Player) and IsValid(Player.InteractiveTriggerComponent) then
        BoardSystem:SetDefaultDistanceSquared(Player.InteractiveTriggerComponent:GetInteractiveTriggerDistance())
    end
    self.Timer = BoardSystem:AddTimer(0.2, function()
        self:TickCheck()
    end, true, 0, nil, false, UE4.ETickingGroup.TG_EndPhysics)
end

function M:OnUpdateSignBoardNpc()
    self:StopTalkTrigger(SignBoardBubbleTalkModel:GetRunningTalkTrigger())
    SignBoardBubbleTalkModel:ResetTalkData()
    local Avatar = self:GetAvatar()
    if Avatar and Avatar:CheckSubRegionType(Avatar:GetCurrentRegionId(), CommonConst.SubRegionType.Home) then 
        self:StartHomeBase()
    end
end

function M:GetModel()
    return SignBoardBubbleTalkModel
end

function M:GetEventName()
    return "SignBoardBubbleTalkModel"  --- 还没用到，先临时给个字符串，用到再去声明
end

-- function M:GetEventName()
--     return EventID.DailyTalkControllerEvent
-- end

return M