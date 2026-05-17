--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_DongGuoTest_C
local M = Class({
    "BluePrints/Item/CombatProp/BP_CombatPropBase_C",
    "BluePrints.Common.TimerMgr"
})

function M:ReceiveBeginPlay()
    M.Super.ReceiveBeginPlay(self)
end

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self,Info)
    self.IsDongGuoDarkCloud = true
    self.CanOpen = true
    self:PrewarmChildClouds()
end

-- 机关交互，气团分裂
function M:OpenMechanism(PlayerId)
    DebugPrint("ayff test BP_DongGuoDarkCloud_C OpenMechanism PlayerId:",PlayerId)
    for _, ChildCloud in pairs(self.ChildClouds or {}) do
        if IsValid(ChildCloud) then
            ChildCloud:MoveToTarget()
        end
    end
    self:AddTimer(1,function()
        self.IsCanDestroy = true
    end, false)
end

function M:PrewarmChildClouds()
    self.ChildClouds = {}
    if not self.RarelyId then 
        return
    end
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local ExploreGroup = GameState.ExploreGroupMap:FindRef(self.RarelyId)
    if not ExploreGroup then
        return
    end
    -- 分裂气团
    local StaticIds = TArray(0)
    if ExploreGroup.ChildCloudStaticIds then
        for _, Id in pairs(ExploreGroup.ChildCloudStaticIds) do
            StaticIds:Add(Id)
        end
    end
    self.ChildCloudNum = StaticIds:Length()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    GameMode:TriggerActiveStaticCreator(StaticIds)

    local Loc = self:K2_GetActorLocation()
    self:AddTimer(1, function()
        self:TryBindChildClouds(ExploreGroup, GameMode, Loc)
    end, false)
end

function M:TryBindChildClouds(ExploreGroup, GameMode, Loc)
    if not IsValid(self) or not ExploreGroup or not GameMode then
        return
    end

    local TempChildClouds = {}
    for i, Id in pairs(ExploreGroup.ChildCloudStaticIds or {}) do
        local Creator = GameMode.EMGameState:GetStaticCreatorInfo(Id)
        if IsValid(Creator) then
            local ChildEids = Creator:GetChildEids()
            for _, ChildEid in pairs(ChildEids) do
                local ChildCloud = Battle(self):GetEntity(ChildEid)
                if IsValid(ChildCloud) then
                    -- ChildCloud:SetMovementTarget(3, true, Loc[i])
                    ChildCloud:SetMovementTarget(0.5, true, Loc)
                    ChildCloud.Parent = self
                    table.insert(TempChildClouds, ChildCloud)
                end
            end
        end
    end

    if #TempChildClouds >= self.ChildCloudNum then
        self.ChildClouds = TempChildClouds
        DebugPrint("ayff test BP_DongGuoDarkCloud_C TryBindChildClouds ChildClouds Count:", #TempChildClouds)
        return
    end
    DebugPrint("ayff test BP_DongGuoDarkCloud_C TryBindChildClouds ChildClouds Count:", #TempChildClouds)
    self:AddTimer(1, function()
        self:TryBindChildClouds(ExploreGroup, GameMode, Loc)
    end, false)
end

-- 到达设置的终点时，禁止移动
function M:MoveTargetEnd()
    if not self.bCanMove then
        return
    end
    self.Overridden.MoveTargetEnd(self)
    self.bCanMove = false
end

-- 碰撞，小气团融入大气团
function M:StartIntegration()
    if not self.IntergratedNum then
        self.IntergratedNum = 0
    end
    self.IntergratedNum = self.IntergratedNum + 1
    if self.IntergratedNum == self.ChildCloudNum then
        self.IntergrationComplete = true
        self:ChangeState("Manual", 0, self.UnitParams.FiniStateId or 711002)
    end
end

function M:GetHit()
    if self.IntergrationComplete == true then
        self:ChangeState("Manual", 0, self.UnitParams.HitedStateId or 711003)
    end
end

function M:ReceiveTick(DeltaSeconds)
end

return M
