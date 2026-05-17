local TalkUtils = require "BluePrints.Story.Talk.View.TalkUtils"
local M = Class({"BluePrints.Common.TimerMgr"})
local TimeUtil = require "Utils.TimeUtils"
local TalkAudioComp_C = require "BluePrints.Story.Talk.Controller.TalkAudioComp"

local LightBubbleTalkTask = {}

LightBubbleTalkTask.New = function(Character, TalkSetting, FinishCallback, Context)
    local NewTable = setmetatable({}, {__index = LightBubbleTalkTask})
    NewTable.TalkActor = Character
    NewTable.NowDialogueId = TalkSetting.BubbleDialogueId
    NewTable.BubbleType = TalkSetting.BubbleType
    NewTable.BubbleDialogueId = TalkSetting.BubbleDialogueId
    NewTable.DelayTime = TalkSetting.DelayTime
    NewTable.BubbleStartDelay = TalkSetting.BubbleStartDelay
    NewTable.FinishCallback = FinishCallback
    NewTable.Context = Context
    NewTable.TalkAudioComp = TalkAudioComp_C.New()
    return NewTable
end

function LightBubbleTalkTask:StartTalk()
    if self.BubbleStartDelay and self.BubbleStartDelay > 0 then
        self.StartTimer = self.Context:AddTimer(self.BubbleStartDelay, function()
            self:PlayDialogue()
        end)
    else
        self:PlayDialogue()
    end
end

function LightBubbleTalkTask:PlayDialogue()
    local DialogueData = DataMgr.Dialogue[self.NowDialogueId]
    if not DialogueData then
        self:OnDialogueFinish()
        return
    end
    local Content = TalkUtils:DialogueIdToContent(self.NowDialogueId)
    if not IsValid(self.TalkActor) then 
        self:ClearTalkTask()
        return 
    end
    self.TalkActor:EnableBubbleWidget(true, Content)
    local bTimerFinish = false
    local bAudioFInish = false
    self.Timer = self.Context:AddTimer(DialogueData.Duration or 1, function()
        bTimerFinish = true
        if bTimerFinish and bAudioFInish then
            self:OnDialogueEnd()
        end
    end)
    self.TalkAudioComp:PlayAudio(DialogueData.VoiceName, self.TalkActor, function()
        bAudioFInish = true
        if bTimerFinish and bAudioFInish then
            self:OnDialogueEnd()
        end
    end, DialogueData, true, "LightBubble")
end

function LightBubbleTalkTask:OnDialogueEnd()
    local DialogueData = DataMgr.Dialogue[self.NowDialogueId]
    self.TalkAudioComp:Clear()
    if (not DialogueData) or (not DialogueData.NextDialogue) then
        if self.BubbleType == UE4.ELightBubbleType.StayOnLast then
            return
        end
        if IsValid(self.TalkActor) then
            self.TalkActor:EnableBubbleWidget(false)
        end
        self:OnDialogueFinish()
        return
    end
    if IsValid(self.TalkActor) then
        self.TalkActor:EnableBubbleWidget(false)
    end
    self.NowDialogueId = DialogueData.NextDialogue
    self:PlayDialogue()
end

function LightBubbleTalkTask:OnDialogueFinish()
    if self.BubbleType == UE4.ELightBubbleType.DelayLoop then
        self.DelayTimer = self.Context:AddTimer(self.DelayTime, function()
            self.DelayTimer = nil
            self.NowDialogueId = self.BubbleDialogueId
            self:PlayDialogue()
        end)
        return
    end
    self:ClearTalkTask()
    if self.FinishCallback then
        local FinishCallback = self.FinishCallback
        self.FinishCallback = nil
        FinishCallback()
    end
end

function LightBubbleTalkTask:ClearTalkTask()
    if IsValid(self.TalkActor) then
        self.TalkActor:EnableBubbleWidget(false)
    end
    if self.Timer then
        self.Context:RemoveTimer(self.Timer)
        self.Timer = nil
    end
    if self.DelayTimer then
        self.Context:RemoveTimer(self.DelayTimer)
        self.DelayTimer = nil
    end
    if self.StartTimer then
        self.Context:RemoveTimer(self.StartTimer)
        self.StartTimer = nil
    end
    self.TalkAudioComp:Clear()
end

function M:InitTalkMgr()
    self.RunningTalkTask = {}
    self.TriggerTime = {}
    self.HideTag = {}
    self.bHide = false
    EventManager:AddEvent(EventID.OnHideAllComponentUI, self, self.OnHideAllComponentUI)
end

function M:OnHideAllComponentUI(bIsHide, Tag)
    Tag = Tag or "DefaultTag"
    if bIsHide then
        self.HideTag[Tag] = true
    else
        self.HideTag[Tag] = nil
    end
    local NewHide = next(self.HideTag) ~= nil
    if NewHide ~= self.bHide then
        self:RealHide(NewHide)
    end
end

function M:RealHide(bHide)
    self.bHide = bHide 
    if bHide then
        local ToStop = {}
        for Char, Task in pairs(self.RunningTalkTask) do
            ToStop[Char] = true
        end
        for Char, _ in pairs(ToStop) do
            self:StopTalkTask(Char)
        end
    end
end

function M:DeInitTalkMgr()
    self.RunningTalkTask = nil
    self.TriggerTime = nil
    EventManager:RemoveEvent(EventID.OnHideAllComponentUI, self)
end

function M:CheckBubbleCD(Character, TalkSetting)
    local NowTime = TimeUtils.NowTime()
    if self.TriggerTime[Character] then
        if (NowTime - self.TriggerTime[Character]) >= TalkSetting.BubbleCD then
            return true
        end
    else
        return true
    end
    return false
end

function M:StartTalkTask(Character, TalkSetting)
    DebugPrint("TalkSetting", TalkSetting.BubbleDialogueId, TalkSetting.DelayTime)
    local TalkTask = LightBubbleTalkTask.New(Character, TalkSetting, function()
        self:StopTalkTask(Character)
    end, self)
    TalkTask:StartTalk()
    self.RunningTalkTask[Character] = TalkTask
    self.TriggerTime[Character] = TimeUtils.NowTime()
    self:OnTalkTaskStart(Character)
end

function M:StopTalkTask(Character)
    local TalkTask = self.RunningTalkTask[Character]
    if not TalkTask then
        return
    end
    TalkTask:ClearTalkTask()
    self.RunningTalkTask[Character] = nil
    self.TriggerTime[Character] = TimeUtils.NowTime()
    self:OnTalkTaskEnd(Character)
end

function M:DisplayName(Character, TalkSetting)
    if not Character then
        return
    end
    Character:EnableNameWidget(true, TalkSetting.TextMapName)
end

function M:CollapsedName(Character)
    if not Character then
        return
    end
    Character:EnableNameWidget(false)
end

return M