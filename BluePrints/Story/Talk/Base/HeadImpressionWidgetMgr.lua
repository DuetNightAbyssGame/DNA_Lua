require "UnLua"

local HeadImpressionWidgetMgr = Class("BluePrints.Common.TimerMgr")

local EImpressionState = {
    Undefined = 0, --未定义
    Unopened = 1, --有未开启的印象对话
    Working = 2, --未完成
    Completed = 3, --已全部完成
}

function  HeadImpressionWidgetMgr:OnInitialize(...)
    EventManager:AddEvent(EventID.OnImprTalkTriggerComplete, self, self.OnTalkTriggerComplete)
end

function HeadImpressionWidgetMgr:OnDeinitialize(...)
    EventManager:RemoveEvent(EventID.OnImprTalkTriggerComplete, self)
end

function HeadImpressionWidgetMgr:OnTalkTriggerComplete(TalkTriggerId, RegionId)
    self:ForceRefreshState()
end

function HeadImpressionWidgetMgr:GetNpcImpressionState(Npc)
    if not Npc then
        return EImpressionState.Undefined
    end

    local NpcId = Npc.NpcId
    if not NpcId or NpcId == 0 then 
        return EImpressionState.Undefined
    end

    local NpcData = DataMgr.Npc[NpcId]
    if not NpcData then
        return EImpressionState.Undefined
    end

    local RelatedTalks = NpcData.RelatedTalks
    if (not RelatedTalks) then 
        return EImpressionState.Undefined
    end

    local TalkTriggers = DataMgr.TalkTrigger
    local TalkContext = GWorld.GameInstance:GetTalkContext()
    local State = EImpressionState.Completed
    local Avatar = GWorld:GetAvatar()
    for _,TalkTriggerId in pairs(RelatedTalks) do
        local TalkTriggerData = TalkTriggers[TalkTriggerId]
        if TalkTriggerData then
        -- 是否有印象对话
            if TalkContext.TalkTriggerComponent:IsImpression(TalkTriggerData) then
                local bCompleted = Avatar and Avatar:IsStorylineComplete(TalkTriggerId)
                if not bCompleted then
                    local bConditionMet = TalkContext.TalkTriggerComponent:CheckCondition(TalkTriggerId)
                    if bConditionMet then
                        State = EImpressionState.Working
                        break
                    else
                        State = EImpressionState.Unopened
                    end
                end
            end
        end
    end

    return State
end


--[[
HeadImpressionWidgetMgr.New = function(HeadWidgetComponent, OwnerNpc)
    local Obj = setmetatable({}, {
        __index = HeadImpressionWidgetMgr
    })
    ---@type AActorWidgetCompoent 所关联的HeadWidgetComponent
    Obj.HeadWidgetComponent = HeadWidgetComponent

    ---@type AActor 所属NPC
    Obj.Owner = OwnerNpc

    ---@type bool 印象对话进度
    Obj.State = EImpressionState.None
    Obj.LastState = EImpressionState.None

    ---@type bool 是否在显示印象提示Widget
    Obj.bInShowing = false

    ---@type float 刷新状态频率, 单位second
    Obj.UpdateImpressionStateInterval = 1 

    ---@type float 显示Widget的距离检测阈值,
    Obj.ShowImpressionDistanceSquare = 4000 * 4000

    Obj:InitImpressionData()

    return Obj
end

function HeadImpressionWidgetMgr:InitImpressionData()
    self:CheckAndSetState()
end

function HeadImpressionWidgetMgr:OnStateChanged(bForceRefresh)
    if self.State == self.LastState and not bForceRefresh then
        return
    end

    -- 删除旧的定时器
    self.Owner:RemoveTimer("RefreshWidget", false)
    self.Owner:RemoveTimer("RefreshState", false)
    if self.State == EImpressionState.None then
    elseif self.State == EImpressionState.Working then
        -- 添加Widget刷新定时器
        self.Owner:AddTimer(self.UpdateImpressionStateInterval, self.RefreshWidget, true, 0, "RefreshWidget", false, self.HeadWidgetComponent, self)
    elseif self.State == EImpressionState.Unopened then
        -- 添加状态检测定时器
        self.Owner:AddTimer(self.UpdateImpressionStateInterval, self.RefreshState, true, 0, "RefreshState", false, self.HeadWidgetComponent, self)
    end
end

-- 外部接口
function HeadImpressionWidgetMgr:RefreshImpressionWidget()
    self:OnStateChanged(true)
end

-- 注意：仅用于定时器使用，请不要用self，而是用HeadImpressionWidgetMgr
function HeadImpressionWidgetMgr:RefreshState(HeadWidgetComponent, HeadImpressionWidgetMgr)
    HeadImpressionWidgetMgr:CheckAndSetState()
end

-- 注意：仅用于定时器使用，请不要用self，而是用HeadImpressionWidgetMgr
function HeadImpressionWidgetMgr:RefreshWidget(HeadWidgetComponent, HeadImpressionWidgetMgr)
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(HeadWidgetComponent, 0)
    if not Player then 
        return 
    end
    local P0 = Player:K2_GetActorLocation()
    local P1 = HeadImpressionWidgetMgr.Owner:K2_GetActorLocation()
    local DisSquare = UE4.UKismetMathLibrary.Vector_DistanceSquared(P0 ,P1)

    if DisSquare <= HeadImpressionWidgetMgr.ShowImpressionDistanceSquare then
        HeadImpressionWidgetMgr.bInShowing = true
        HeadWidgetComponent:EnableWidget("Impression")
    else
        HeadImpressionWidgetMgr.bInShowing = false
        HeadWidgetComponent:DisableWidget("Impression")
    end
end

function HeadImpressionWidgetMgr:OnReceivedImpressionComplete()
    self:CheckAndSetState()

    -- 检测是否完成的是正在显示的对话
    if self.bInShowing then
        if self.State ~= EImpressionState.Working then
            self.bInShowing = false
            self.HeadWidgetComponent:DisableWidget("Impression")
        end
    end
end

function HeadImpressionWidgetMgr:CheckAndSetState()
    local State = EImpressionState.None
    local NpcId =  self.Owner.NpcId
    if not NpcId or NpcId == 0 then 
        self.LastState = self.State
        self.State = State
        self:OnStateChanged()
        return 
    end

    local RelatedTalks = DataMgr[self.Owner.UnitType][NpcId].RelatedTalks
    local Avatar = GWorld:GetAvatar()
    local TalkTriggers = DataMgr.TalkTrigger
    local TalkContext = GWorld.GameInstance:GetTalkContext()
    if not Avatar or not RelatedTalks then 
        self.LastState = self.State
        self.State = State
        self:OnStateChanged()
        return 
    end
    for _,TalkTriggerId in pairs(RelatedTalks) do
        local TalkTriggerData = TalkTriggers[TalkTriggerId]
        -- 是否有印象对话
        if TalkContext.TalkTriggerComponent:IsImpression(TalkTriggerData) then
            local bMetCondition = TalkContext.TalkTriggerComponent:CanTrigger(TalkTriggerData)
            -- 已开启且未完成
            if bMetCondition then
                State = EImpressionState.Working
                break
            -- 未开启
            else
                State = EImpressionState.Unopened
            end
        end
    end

    self.LastState = self.State
    self.State = State

    self:OnStateChanged()
end
--]]

return HeadImpressionWidgetMgr