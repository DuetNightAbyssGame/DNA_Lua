--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_SeatPointComponent_C = Class()

--function BP_SeatPointComponent_C:Initialize(Initializer)
--end

function BP_SeatPointComponent_C:ReceiveBeginPlay()
    self.Overridden.ReceiveBeginPlay(self)
    self.EnterPointArray = self:GetChildrenComponents(true)
end

function BP_SeatPointComponent_C:FindEnterPoint(PlayerEid)
    local Result = nil
    local ResDis = 99999
    for i = 1,self.EnterPointArray:Length() do 
        -- print(_G.LogTag,self.PointArray[i]:GetName(), ResDis)
        local CompLoc = self.EnterPointArray[i]:K2_GetComponentLocation()
        local PlayerLoc = Battle(self):GetEntity(PlayerEid):K2_GetActorLocation()
        local Dis = (CompLoc-PlayerLoc):Size()
        if Result == nil or Dis < ResDis or (Dis == ResDis and math.random()>=0.5) then
            Result = self.EnterPointArray[i]
            ResDis = Dis                    
        end
    end
    self.EnterType = Result.Type
    return Result
    -- print(_G.LogTag,"FindPoint", Tmp:Length())
end

function BP_SeatPointComponent_C:NpcFindEnterPoint(Npc)
    local Result = nil
    --坐下点和玩家的距离
    local ResDis = 99999
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    for i = 1,self.EnterPointArray:Length() do 
        if self.EnterPointArray[i] == "F" then
            self.EnterType = self.EnterPointArray[i].Type
            return self.EnterPointArray[i]
        end
        local Owner = self:GetOwner()
        local Dis = Owner:SeatGetPlayerPointDis(Npc, self)
        if Result == nil or Dis < ResDis or (Dis == ResDis and math.random()>=0.5) then
            Result = self.EnterPointArray[i]
            ResDis = Dis                    
        end
    end
    self.EnterType = Result.Type
    return Result
end

function BP_SeatPointComponent_C:FindLeavingPoint(Type)
    for i = 1, self.EnterPointArray:Length() do
        if self.EnterPointArray[i].Type == Type then
            return self.EnterPointArray[i]
        end
    end
    return self.EnterPointArray[1]
    -- print(_G.LogTag,"FindPoint", Tmp:Length())
end

function BP_SeatPointComponent_C:NpcFindLeavingPoint(Npc)
    local Result = nil
    --坐下点和玩家的距离
    local ResDis = 99999
    --不明原因，在Npc的EndPlay里起身时，组件可能已经被释放，此时会crash
    if not IsValid(self) then
        return Result
    end
    for i = 1, self.EnterPointArray:Length() do
        if self.EnterPointArray[i].Type == "F" then
            return self.EnterPointArray[i]
        end
        if IsValid(self.EnterPointArray[i]) then
            local CompLoc = self.EnterPointArray[i]:K2_GetComponentLocation()
            local NpcLoc = Npc:K2_GetActorLocation()
            local Dis = (CompLoc-NpcLoc):Size()
            if Result == nil or Dis < ResDis or (Dis == ResDis and math.random()>=0.5) then
                Result = self.EnterPointArray[i]
                ResDis = Dis
            end
        end
    end
    return Result
end

--function BP_SeatPointComponent_C:ReceiveEndPlay()
--end

-- function BP_SeatPointComponent_C:ReceiveTick(DeltaSeconds)
-- end

return BP_SeatPointComponent_C
