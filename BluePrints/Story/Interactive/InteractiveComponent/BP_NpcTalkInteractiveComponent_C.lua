require "UnLua"
require "DataMgr"

local LuaConst = require("EMLuaConst")
local BP_NpcTalkInteractiveComponent_C = Class("BluePrints.Story.Interactive.InteractiveComponent.BP_InteractiveBaseComponent_C")
local TalkUtils = require "BluePrints.Story.Talk.View.TalkUtils"
local DailyTalkController = require "BluePrints.UI.WBP.DailyTalk.DailyTalkController"
local StoryInteractiveController = require ("BluePrints.UI.WBP.StoryInteractive.StoryInteractiveController")
local StoryInterActiveModel = require ("BluePrints.UI.WBP.StoryInteractive.StoryInteractiveModel")

--function BP_TalkInteractiveComponent_C:Initialize(Initializer)
--end

local ETalkInteractiveState = {
    None = "None",
    InteractiveTalk = "InteractiveTalk",
    BubbleTalk = "BubbleTalk",
}

function BP_NpcTalkInteractiveComponent_C:ReceiveBeginPlay()
    self.InteractiveTag = "Interactive"
    self.Super.ReceiveBeginPlay(self)
    self.Owner = self:GetOwner()
    -- self.Bubble = "Bubble"
    -- self.BubbleTalk = "BubbleTalk"
    self.EmptyUI = nil
    self.PlayerActor = nil
    self.TalkTriggerId = nil
    self.BubbleTalkTriggerId = 0
    
    -- 因为 Npc 初始化是自定义的，所以需要等待自定义函数初始化，调用该组件的初始化，才能执行组件逻辑。
    self.bIsInit = false

    self.bIsEnd = false
    
    -- 3DUI、命名、气泡的是否显示标记值。
    self.bIsHeadWidgetDisplayed = false
    self.bIsNameDisplayed = false
    self.bIsBubbleDisplayed = false
    self.bIsInvitateBubbleDisplayed = false
    self.bAllowShowName = true
    self.bCannotActive = false
    self.bNeedCheckNpcMap = true
    -- self:SetIsMainQuest(false)
    self.TalkState = ETalkInteractiveState.None
    
    self.NPCLookAtDistance = 200  --距离
    self.NPCLookAtAngle = 45  -- 角度
    self.NPCLookAtTarget = nil
    if self.Owner.bIsEmptyNpc then
        self:DisableNameDisplay()
    end
end

function BP_NpcTalkInteractiveComponent_C:InitDailyTalk()
    DailyTalkController:RegisterDailyTalkNpc(self.Owner.NpcId, self)
end

function BP_NpcTalkInteractiveComponent_C:DeInitDailyTalk()
    DailyTalkController:RegisterDailyTalkNpc(self.Owner.NpcId, nil)
end

function BP_NpcTalkInteractiveComponent_C:ReceiveEndPlay()
    DebugPrint("BP_NpcTalkInteractiveComponent_C:ReceiveEndPlay", self.Owner and self.Owner:GetName())
    self.bIsEnd = true
    if self:IsInInteractive() then
        self:TryExitInterativeTalkState()
    end
    self:DeInitDailyTalk()
end

-- function BP_NpcTalkInteractiveComponent_C:ReceiveTick(DeltaSeconds)
-- end

function BP_NpcTalkInteractiveComponent_C:DisableNameDisplay()
    self.bAllowShowName = false
end

function BP_NpcTalkInteractiveComponent_C:Init()
    self.bIsInit = true
    if DailyTalkController:GetModel():
        CheckHasDailyTalkReward(self.Owner and self.Owner.NpcId) then
        self:InitDailyTalk()
    end
end

function BP_NpcTalkInteractiveComponent_C:GetDisplayName()
    return StoryInterActiveModel:GetInteractiveName(self.Owner.NpcId)
end

function BP_NpcTalkInteractiveComponent_C:RefreshInteractiveName()
    local InteractiveName = self:GetDisplayName()
    if self.InteractiveName == InteractiveName then return end
    self:SetInteractiveName(InteractiveName)
end

function BP_NpcTalkInteractiveComponent_C:TriggerEnter(PlayerActor)
    if not self:CheckSelfCanInteractive() then
        return
    end
    if self.bIsInit == false or self.bCannotActive then
        return
    end
    self.Overridden.TriggerEnter(self, PlayerActor)
end

function BP_NpcTalkInteractiveComponent_C:CheckSelfCanInteractive()
    local GameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
    if not GameState then
        return false
    end
    local NpcCharacterMap = GameState.NpcCharacterMap
    local Npc = NpcCharacterMap:FindRef(self.Owner.NpcId)
    if not IsValid(Npc) then
        return false
    end
    return true
end

function BP_NpcTalkInteractiveComponent_C:TriggerTick(PlayerActor)
    if not self:CheckSelfCanInteractive() then
        self.Overridden.TriggerTick(self, PlayerActor)
        return
    end
    if self.bIsInit == false or self.bCannotActive then
        self.Overridden.TriggerTick(self, PlayerActor)
        return
    end
    local GameInstance = GWorld.GameInstance
    ---@type BP_TalkContext_C
    local TalkContext = GameInstance:GetTalkContext()
    local NpcData = self:GetNpcCharData(self.Owner.UnitType, self.Owner.UnitId)
    
--     local OldTalkTriggerId = self.TalkTriggerId
--     self.TalkTriggerId = TalkContext:GetValidTalkTriggerId(self.Owner.NpcData.RelatedTalks)
--     if self.TalkTriggerId ~= OldTalkTriggerId then self:RefreshInteractiveName() end
--     self:SetIsMainQuest(self:IsMainQuest(self.TalkTriggerId))
    -- local OldTalkTriggerId = self.TalkTriggerId
    -- self.TalkTriggerId = TalkContext:GetValidTalkTriggerId(self.Owner.NpcData.RelatedTalks)
    self:RefreshInteractiveName()
    -- self:SetIsMainQuest(self:IsMainQuest(self.TalkTriggerId))
    if NpcData and NpcData.RelatedBubble then
        self.BubbleTalkTriggerId = TalkContext:GetValidTalkTriggerId(NpcData.RelatedBubble)
    else
        self.BubbleTalkTriggerId = nil
    end

    self.Overridden.TriggerTick(self, PlayerActor)
    if self.Owner then
        local bDisplayNameRes = self:IsCanDisplayName(PlayerActor)
        self:UpdateDisplayName(PlayerActor, bDisplayNameRes)
        self:UpdateState(PlayerActor)

        if self.Owner.bNPCDefaultLookAt then
            local IsInLookAtRange = self.DistanceCheck(self.Owner, PlayerActor, self.NPCLookAtDistance)
                    and self.AngleCheck(self.Owner, PlayerActor, self.NPCLookAtAngle)
            self:EnableLookAt(PlayerActor, IsInLookAtRange)            
        end
    end
    -- local bCanDisplayHeadWidget = PlayerActor:CheckCanInteractiveTrigger() 
    --self:UpdateDisplayHeadWidget(PlayerActor, bCanDisplayHeadWidget)

    if (self:IsCanInteractTrigger(PlayerActor)) then
        self:BeginInteractTrigger()
    else
        self:EndInteractTrigger()
    end
end

function BP_NpcTalkInteractiveComponent_C:GetNpcCharData(InType, InUnitId)
    return DataMgr[InType][InUnitId]
end

function BP_NpcTalkInteractiveComponent_C:EnableLookAt(PlayerActor, EnableLookAtState)
    if not self.Owner or not self.Owner.NpcAnimInstance then
        return 
    end
    
    if self.NPCLookAtTarget and EnableLookAtState == false then
        self.Owner.NpcAnimInstance:ResetNormalLookAt()
        self.NPCLookAtTarget = nil
    elseif self.NPCLookAtTarget == nil and EnableLookAtState == true then
        self.Owner.NpcAnimInstance:SetLookAtActor(PlayerActor, "head")
        self.NPCLookAtTarget = PlayerActor
    end
end     

function BP_NpcTalkInteractiveComponent_C:TriggerExit(PlayerActor)
    if self.bIsInit == false then
        return
    end
    self.Overridden.TriggerExit(self, PlayerActor)
    --if self.HeadWidgetComp == nil or self.HeadWidgetComp:GetWidget() == nil then
      --  return
    --end
    self:NotDisplayName(PlayerActor)
    if self.TalkState ~= ETalkInteractiveState.InteractiveTalk then
        self:ExitCurrentState(PlayerActor)
    end
    if not PlayerActor:CheckCanInteractiveTrigger() then
        self:NotDisplayHeadWidget(PlayerActor)
    end

    self:EndInteractTrigger()
end

function BP_NpcTalkInteractiveComponent_C:BtnPressed(PlayerActor)
    --- 如果Clicked触发会有各种问题，比如对话和esc一起按下导致卡住、对话按住跑到很远的地方直接触发对话表现很怪
    --- 所有这里自行再判断一次IsForbidden
    if self:IsForbidden() then return end 
    -- self:StartInteractive(PlayerActor)
    self:SwitchState(ETalkInteractiveState.InteractiveTalk, PlayerActor)
end

function BP_NpcTalkInteractiveComponent_C:IsCanInteractive(PlayerActor)
    local Owner = self.Owner
    local NPCAnimInstance = Owner.NPCAnimInstance
    local bIsRotating = NPCAnimInstance and NPCAnimInstance.IsRotating
    if LuaConst.OpenComputeInteractive then
        return self.bIsInit
            and not PlayerActor:IsSeating()
            and self.NpcState ~= "Hide"
        --    and self.DistanceCheck(self.Owner, PlayerActor, self.InteractiveDistance)
            and self:GetDistanceCheckResult()
            and self.BFaceToACheck(self.Owner, PlayerActor, self.InteractiveFaceAngle)
            and StoryInterActiveModel:HasAnyInteractive(self.Owner.NpcId)
            and not self.Owner.bHidden
            and not bIsRotating
    else
        return self.bIsInit
            and not PlayerActor:IsSeating()
            and self.NpcState ~= "Hide"
            and self.DistanceCheck(self.Owner, PlayerActor, self.InteractiveDistance)
            and self.BFaceToACheck(self.Owner, PlayerActor, self.InteractiveFaceAngle)
            and StoryInterActiveModel:HasAnyInteractive(self.Owner.NpcId)
            and not self.Owner.bHidden
            and not bIsRotating
    end
end

function BP_NpcTalkInteractiveComponent_C:CheckForbiddenBySpecialQuest()
    -- 与Npc对话节点不受影响
    -- if GWorld.StoryMgr:ExistedNPCInteractiveTalk(self.Owner.NpcId) then
    --     return false
    -- end

    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar.InSpecialQuest 
        and StoryInterActiveModel:IsForbidBySpecialQuest(self.Owner.NpcId) then
        return true
    end

    return false
end

-- function BP_NpcTalkInteractiveComponent_C:IsMainQuest(TalkTriggerId)
--     if TalkTriggerId and DataMgr.TalkTrigger[TalkTriggerId] then
--         return DataMgr.TalkTrigger[TalkTriggerId].Type == nil
--     else
--         return self.bIsMainQuest 
--     end
-- end

-- function BP_NpcTalkInteractiveComponent_C:SetIsMainQuest(bSet)
--     self.bIsMainQuest = bSet
-- end

function BP_NpcTalkInteractiveComponent_C:IsForbidden()
    if (self.bCannotActive) then
        return true
    end

    if self:CheckForbiddenBySpecialQuest() then
        self:SetOverridenFailMsg("QUEST_INSPECIALQUEST_MSG")
        return true
    else
        self:SetOverridenFailMsg()
    end

    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if IsValid(PlayerCharacter) then
        return not self:CheckInteractiveSucc(PlayerCharacter.Eid)
    else
        return true
    end
end

function BP_NpcTalkInteractiveComponent_C:OnClicked_Forbidden()
    self:InteractiveFailed()
end

function BP_NpcTalkInteractiveComponent_C:SetNpcTalkActive(bActive)
    self.bCannotActive = not bActive
end

function BP_NpcTalkInteractiveComponent_C:RefreshTalkTriggerId()
    local TalkContext = GWorld.GameInstance:GetTalkContext()
    local NpcData = self:GetNpcCharData(self.Owner.UnitType, self.Owner.UnitId)
    if NpcData and NpcData.RelatedTalks then
        self.TalkTriggerId = TalkContext:GetValidTalkTriggerId(NpcData.RelatedTalks)
    else
        self.TalkTriggerId = nil
    end
end

function BP_NpcTalkInteractiveComponent_C:GetQuestID()
    return StoryInterActiveModel:GetNowInteractiveQuestChainId(self.Owner.NpcId)
end

function BP_NpcTalkInteractiveComponent_C:GetSpecialQuestID()
    return StoryInterActiveModel:GetNowInteractiveSpecialQuestId(self.Owner.NpcId)
end

function BP_NpcTalkInteractiveComponent_C:StartInteractive(PlayerActor)
    DebugPrint("BP_NpcTalkInteractiveComponent_C:StartInteractive")

    PlayerActor:AddForbidTag("TalkInteractive")
    PlayerActor:SetCharacterTag("Idle")
    PlayerActor:StopSlide()
    PlayerActor:SetCharacterTag(self.InteractiveTag)

    PlayerActor:SetCanInteractiveTrigger(false, "TalkInteractive")

    self.bIsInInteractive = true
    self.PlayerActor = PlayerActor
    local GameInstance = GWorld.GameInstance
    ---@type BP_TalkContext_C
    local TalkContext = GameInstance:GetTalkContext()
    TalkContext:RegisterInteractiveActor(self.Owner)
    -- if GWorld.StoryMgr:ExistedNPCInteractiveTalk(self.Owner.NpcId) then
    --     GWorld.StoryMgr:TryExecNPCInteractiveTalk(self.Owner.NpcId, self.Owner, )
    -- else
    --     local TS = TalkSubsystem()
    --     TalkContext:StartTalk(self.TalkTriggerId, nil, nil, PlayerActor, self:GetOwner(), {Func=self.TryExitInterativeTalkState,Obj=self},
    --         (TS and TS:GetNpcPlayDialogueCallback(self.Owner.NpcId)) or nil)
    -- end
    StoryInteractiveController:TryStartInteractive(self.Owner.NpcId, self.Owner, PlayerActor, 
        {Obj = self, Func = self.TryExitInterativeTalkState})
end

function BP_NpcTalkInteractiveComponent_C:EndInteractive()
    DebugPrint("BP_NpcTalkInteractiveComponent_C:EndInteractive", self:IsInInteractive())
    TalkUtils:RemovePlayerInvincible()
    if not self:IsInInteractive() then
        return
    end

    self.PlayerActor:MinusForbidTag("TalkInteractive")
    self.PlayerActor:SetCharacterTag("Idle")

    self.PlayerActor:SetCanInteractiveTrigger(true, "TalkInteractive")

    self.bIsInInteractive = false
    self.PlayerActor = nil

    local TalkContext = GWorld.GameInstance:GetTalkContext()
    TalkContext:UnregisterInteractiveActor()
end

function BP_NpcTalkInteractiveComponent_C:IsInInteractive()
    return self.bIsInInteractive
end

function BP_NpcTalkInteractiveComponent_C:CheckInteractiveSucc(PlayerEid)
    local ConditionCheck = self.Super.CheckInteractiveSucc(self, PlayerEid)

    local Player = Battle(self):GetEntity(PlayerEid)
    local TagCheck = self:CheckPlayerTag(Player)
    return ConditionCheck and TagCheck
end

function BP_NpcTalkInteractiveComponent_C:UpdateDisplayHeadWidget(PlayerActor, bDisplayHeadWidgetRes)
    if bDisplayHeadWidgetRes then
        self:DisplayHeadWidget(PlayerActor)
    else
        self:NotDisplayHeadWidget(PlayerActor)
    end
end

function BP_NpcTalkInteractiveComponent_C:DisplayHeadWidget(PlayerActor)
    local HeadUISubsystem = UNpcHeadUISubsystem.GetHeadUISubsystem(self)
    if HeadUISubsystem then
        --HeadUISubsystem:HideHeadUI(true, "Interactive")
    end
end

function BP_NpcTalkInteractiveComponent_C:RefreshHeadWidget(PlayerActor)
end

function BP_NpcTalkInteractiveComponent_C:NotDisplayHeadWidget(PlayerActor)
    local HeadUISubsystem = UNpcHeadUISubsystem.GetHeadUISubsystem(self)
    if HeadUISubsystem and false then
        --HeadUISubsystem:HideHeadUI(false, "Interactive")
    end
end

function BP_NpcTalkInteractiveComponent_C:IsCanDisplayName(PlayerActor)
    return self.bAllowShowName and self.bIsInit
           and self.DistanceCheck(self.Owner, PlayerActor, self.NameDisplayDistance) 
           and not self.Owner.bHidden
end

function BP_NpcTalkInteractiveComponent_C:UpdateDisplayName(PlayerActor, bDisplayName)
    if bDisplayName and self.bIsNameDisplayed == false then
        self:DisplayName(PlayerActor)
    -- elseif bDisplayName and self.bIsNameDisplayed then
    --     self:RefreshName(PlayerActor)
    elseif bDisplayName == false and self.bIsNameDisplayed then
        self:NotDisplayName(PlayerActor)
    end
end

function BP_NpcTalkInteractiveComponent_C:DisplayName(PlayerActor)
    if self.DisplayInteractiveName == "" or self.bIsNameDisplayed then return end
    self.bIsNameDisplayed = true
    self.Owner:EnableNameWidget(true)
    -- print(_G.LogTag, "TTT DisplayName")
end

-- function BP_NpcTalkInteractiveComponent_C:RefreshName(PlayerActor)
-- end

function BP_NpcTalkInteractiveComponent_C:NotDisplayName(PlayerActor)
    if self.bIsNameDisplayed == false then
        return
    end
    self.bIsNameDisplayed = false
    self.Owner:EnableNameWidget(false)
    -- print(_G.LogTag, "TTT NotDisplayName")
end

function BP_NpcTalkInteractiveComponent_C:IsCanDisplayBubble(PlayerActor)
    return self.bIsInit and not self.bIsEnd
           and self.BubbleTalkTriggerId ~= nil
           and self.DistanceCheck(self.Owner, PlayerActor, self.BubbleDisplayDistance)
           and not self.Owner.bHidden
end

-- function BP_NpcTalkInteractiveComponent_C:UpdateDisplayBubble(PlayerActor, DisplayBubbleRes)
--     if DisplayBubbleRes == true and self.bIsBubbleDisplayed == false then
--         self:DisplayBubble(PlayerActor)
--     -- elseif DisplayBubbleRes == true and self.bIsBubbleDisplayed == true then
--     --     self:RefreshBubble(PlayerActor)
--     elseif DisplayBubbleRes == false and self.bIsBubbleDisplayed == true then
--         self:NotDisplayBubble(PlayerActor)
--     end
-- end

function BP_NpcTalkInteractiveComponent_C:DisplayBubble(PlayerActor)
    if self.bIsBubbleDisplayed then return end
    self.bIsBubbleDisplayed = true

    --print(_G.LogTag, "TTT DisplayBubble")

    local GameInstance = GWorld.GameInstance
    ---@type BP_TalkContext_C
    local TalkContext = GameInstance:GetTalkContext()
    self.BubbleTalkKey = TalkContext:StartTalk(self.BubbleTalkTriggerId,nil,nil, PlayerActor, self:GetOwner(), {
        Func = self.NotDisplayBubble, --- 原本行为：进入范围后只触发一次冒泡，除非进入了其他状态再返回，因此此处不退出状态，只结束冒泡对话
        Obj = self
    })
end

-- function BP_NpcTalkInteractiveComponent_C:RefreshBubble(PlayerActor)
-- end

function BP_NpcTalkInteractiveComponent_C:NotDisplayBubble(PlayerActor)
    if self.bIsBubbleDisplayed == false then return end
    if self:IsCanDisplayBubble(PlayerActor) then return end
    self.bIsBubbleDisplayed = false
    --local TalkContext = GWorld.GameInstance:GetTalkContext()
    --TalkContext:StopTalk(self.BubbleTalkKey)
    local TS = TalkSubsystem()
    if (TS) then
        TS:ForceInterruptTalkTaskData(function(TalkTaskData)
            return TalkTaskData.FilePath == self.BubbleTalkKey
        end)
    end
    self.BubbleTalkKey = nil
    -- print(_G.LogTag, "TTT NotDisplayBubble")
end

function BP_NpcTalkInteractiveComponent_C:IsCanInteractTrigger(PlayerActor)
    if ((not self.bIsInit) or self.bCannotActive or self.Owner.bHidden) then
        return false
    end

    local NpcData = self:GetNpcCharData(self.Owner.UnitType, self.Owner.UnitId)
    if (not NpcData) then
        return false
    end

    local InteractTriggerData = DataMgr.InteractTrigger[NpcData.InteractTriggerId]
    if (not InteractTriggerData) then
        return false
    end

    return self.DistanceCheck(self.Owner, PlayerActor, InteractTriggerData.DetectionCM)
end

function BP_NpcTalkInteractiveComponent_C:BeginInteractTrigger()
    if (self.bIsInteractTrigger) then
        return
    end

    self.bIsInteractTrigger = true

    local NpcData = self:GetNpcCharData(self.Owner.UnitType, self.Owner.UnitId)
    if (not NpcData) then
        return
    end

    local InteractTriggerData = DataMgr.InteractTrigger[NpcData.InteractTriggerId]
    if (not InteractTriggerData) then
        return
    end

    GWorld.StoryMgr:RunStory(InteractTriggerData.StorylineFilePath, nil, nil, function()
        local Avatar = GWorld:GetAvatar()
        if (not Avatar:CheckInteractTriggerRewardIsGot(InteractTriggerData.InteractTriggerId)) then
            Avatar:GetInteractTriggerReward(InteractTriggerData.InteractTriggerId)
        end
    end)
end

function BP_NpcTalkInteractiveComponent_C:EndInteractTrigger()
    if (not self.bIsInteractTrigger) then
        return
    end

    if (self.TalkState == ETalkInteractiveState.InteractiveTalk) then
        return
    end

    self.bIsInteractTrigger = false

    local NpcData = self:GetNpcCharData(self.Owner.UnitType, self.Owner.UnitId)
    if (not NpcData) then
        return
    end

    local InteractTriggerData = DataMgr.InteractTrigger[NpcData.InteractTriggerId]
    if (not InteractTriggerData) then
        return
    end

    GWorld.StoryMgr:StopStoryline(InteractTriggerData.StorylineFilePath)
end

function BP_NpcTalkInteractiveComponent_C:TryExitInterativeTalkState()
    if self.TalkState ~= ETalkInteractiveState.InteractiveTalk then return end
    self:ExitCurrentState()
end

-- function BP_NpcTalkInteractiveComponent_C:GetInteractiveName()
-- 	return self.DisplayInteractiveName
-- end

function BP_NpcTalkInteractiveComponent_C:ExitCurrentState(PlayerActor)
    local TalkState = self.TalkState
    self.TalkState = ETalkInteractiveState.None --- 先置空，避免重入导致递归
    if TalkState == ETalkInteractiveState.BubbleTalk then
        self:NotDisplayBubble(PlayerActor)
    elseif TalkState == ETalkInteractiveState.InteractiveTalk then
        self:EndInteractive()
    end
end

function BP_NpcTalkInteractiveComponent_C:EnterState(State, PlayerActor)
    if self.TalkState == State then
        return
    end
    self.TalkState = State
    if State == ETalkInteractiveState.BubbleTalk then
        self:DisplayBubble(self.PlayerActor)
    elseif State == ETalkInteractiveState.InteractiveTalk then
        self:StartInteractive(PlayerActor)
    end
end

function BP_NpcTalkInteractiveComponent_C:SwitchState(State, PlayerActor)
    self:ExitCurrentState(PlayerActor)
    self:EnterState(State, PlayerActor)
end

function BP_NpcTalkInteractiveComponent_C:CanEnterState(State)
    if State == self.TalkState then
        return false
    end
    local bCanExit = true
    if self.TalkState == ETalkInteractiveState.InteractiveTalk then
        bCanExit = false
    elseif State == ETalkInteractiveState.InteractiveTalk then
        bCanExit = true
    elseif self.TalkState == ETalkInteractiveState.BubbleTalk then
        if self.bIsBubbleDisplayed then
            bCanExit = false
        else
            bCanExit = true
        end
    end
    return bCanExit
end

function BP_NpcTalkInteractiveComponent_C:UpdateState(PlayerActor)
    if self.TalkState == ETalkInteractiveState.BubbleTalk and not self:IsCanDisplayBubble(PlayerActor) then
        self:ExitCurrentState(PlayerActor)
    end
    if self:CanEnterState(ETalkInteractiveState.BubbleTalk) and self:IsCanDisplayBubble(PlayerActor) then
        self:SwitchState(ETalkInteractiveState.BubbleTalk, PlayerActor)
    end
end

return BP_NpcTalkInteractiveComponent_C
