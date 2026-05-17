local ConditionTree = {}

---@param Params table<string, function>
function ConditionTree:New(Docker)
    local CT = {}
    setmetatable(CT, {
		__index = ConditionTree
	})
    CT.Docker = Docker
    return CT
end

---@param Params any
function ConditionTree:Check(Condition)
    if not Condition then 
        return true
    end
    if Condition.And then 
        return self:And(Condition.And)
    end
    if Condition.Or then 
        return self:Or(Condition.Or)
    end
    if Condition.Not then 
        return self:Not(Condition.Not)
    end
    for Func,Param in pairs(Condition) do 
        if self.Docker[Func] then 
            return self.Docker[Func](self.Docker, Param)
        end
    end
    return true
end

---@param Conditions table<string, any>
function ConditionTree:And(Condition)
    for _,Cond in ipairs(Condition) do 
        if not self:Check(Cond) then 
            return false
        end
    end
    return true
end

---@param Conditions table<string, any>
function ConditionTree:Or(Condition)
    for _,Cond in ipairs(Condition) do 
        if self:Check(Cond) then 
            return true
        end
    end
    return false
end

---@param Conditions table<string, any>
function ConditionTree:Not(Condition)
    return not self:Check(Condition)
end

local LoadingCondition = {}

---@param Params table<string, any>
function LoadingCondition:QuestStart(Params)
    local QuestId = Params.QuestId
    local Avatar = GWorld:GetAvatar()
    if (Avatar == nil) then
        return false
    end
    local RtnRes = Avatar:IsQuestDoing(QuestId)
    return RtnRes
end

---@param Params table<string, any>
function LoadingCondition:QuestUnstart(Params)
    local QuestId = Params.QuestId
    local Avatar = GWorld:GetAvatar()
    if (Avatar == nil) then
        return false
    end
    local RtnRes = (not Avatar:IsQuestDoing(QuestId)) and (not Avatar:IsQuestFinished(QuestId))
    return RtnRes
end

---@param Params table<string, any>
function LoadingCondition:QuestFinish(Params)
    local QuestId = Params.QuestId
    local Avatar = GWorld:GetAvatar()
    if (Avatar == nil) then
        return false
    end
    local RtnRes = Avatar:IsQuestFinished(QuestId)
    return RtnRes
end

local SpecialLoadingRule = {}

function SpecialLoadingRule:CheckRegionCondition(Region, LastRegion, Rule, bIsCrossRegion)
    if not Rule then 
        return false
    end
    if Rule.From and (not LastRegion or Rule.From ~= LastRegion.RegionType) then 
        return false
    end
    if Rule.To and Rule.To ~= Region.RegionType then 
        return false
    end
    -- 仅判断跨地图传送是否满足条件
    if not Rule.SubId and not Rule.SpawnPoint then 
        return bIsCrossRegion
    end
    -- 支持同地图不同传送点或区域
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then 
        return false
    end
    if Rule.SubId and GameMode.TargetSubRegion ~= Rule.SubId then 
        return false
    end
    if Rule.SpawnPoint and GameMode.TargetSpawnPoint ~= Rule.SpawnPoint then 
        return false
    end
    return true
end

function SpecialLoadingRule:GetLoadingBpPath(bIsCrossRegion)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode and GWorld.GameInstance.QuestDeliverId and GWorld.GameInstance.QuestDeliverLoadingId and GWorld.GameInstance.QuestDeliverId == GameMode.TargetSubRegion then
        local LoadingData = DataMgr.RegionLoading[GWorld.GameInstance.QuestDeliverLoadingId]
        GWorld.GameInstance.QuestDeliverId = nil
        GWorld.GameInstance.QuestDeliverLoadingId = nil
        if LoadingData then
            return LoadingData, LoadingData.WBPPath
        end
    end
    local SceneId = WorldTravelSubsystem():GetCurrentSceneId()
    local LastSceneId = WorldTravelSubsystem():GetLastSceneId()
    if not DataMgr.Region or not DataMgr.SpecialLoading then 
        return
    end
    local Region = DataMgr.Region[SceneId]
    local LastRegion = DataMgr.Region[LastSceneId]
    if not Region then
        return
    end
    for _,Rule in pairs(DataMgr.SpecialLoading) do 
        if self:CheckRegionCondition(Region, LastRegion, Rule.Region, bIsCrossRegion) then 
            local CT = ConditionTree:New(LoadingCondition)
            if CT:Check(Rule.TriggerCondition) then 
                local LoadingData = DataMgr.RegionLoading[Rule.LoadingId]
                if not LoadingData then 
                    return
                end
                return LoadingData, LoadingData.WBPPath
            end
        end
    end
end

return SpecialLoadingRule