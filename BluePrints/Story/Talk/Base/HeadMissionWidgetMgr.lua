require "UnLua"
local EMCache = require "EMCache.EMCache"

local HeadMissionWidgetMgr = Class("BluePrints.Common.TimerMgr")

--- 纯Lua，单纯控制任务提示UI的显隐规则
---  
---

HeadMissionWidgetMgr.New = function(HeadWidgetComponent, OwnerNpc)
    local Obj = setmetatable({}, {
        __index = HeadMissionWidgetMgr
    })
    ---@type AActorWidgetCompoent 所关联的HeadWidgetComponent
    Obj.HeadWidgetComponent = HeadWidgetComponent

    ---@type AActor 所属NPC
    Obj.Owner = OwnerNpc

    Obj:InitMissionData()

    return Obj
end

function HeadMissionWidgetMgr:InitMissionData()
    self:RefreshMissionWidget()
end

function HeadMissionWidgetMgr:OnQuestTrackingChanged()
    self:RefreshMissionWidget()
end

function HeadMissionWidgetMgr:RefreshMissionWidget()
    local Avatar = GWorld:GetAvatar()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)

    if not Avatar or not Player or not self.Owner then
        return
    end

    local Id = self:TryGetTrackedId()

    if Id == self.Owner.UnitId then
        self.HeadWidgetComponent:EnableWidget('Mission')
    else
        self.HeadWidgetComponent:DisableWidget('Mission')
    end
end

function HeadMissionWidgetMgr:TryGetTrackedId()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local QuestChainId = Avatar.TrackingQuestChainId
    local GameState = UE4.UGameplayStatics.GetGameState(self.HeadWidgetComponent)
    local GuideInfoCache = EMCache:Get("GuideInfoCache", true) or {}
    local Info = GuideInfoCache[QuestChainId]
    local TargetStaticCreator = nil
    if not Info then
        return
    end

    local TargetPointName = Info.PointName
    local CreatorMap = GameState.StaticCreatorMap:ToTable()
    for _, v in pairs(CreatorMap) do
        if (v:GetDisplayName() == TargetPointName) then
            TargetStaticCreator = v
            break 
        end
    end 

    if TargetStaticCreator then
        return TargetStaticCreator.UnitId
    end
end


return HeadMissionWidgetMgr