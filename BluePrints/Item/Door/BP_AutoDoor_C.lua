--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_AutoDoor_C = Class("BluePrints.Item.Mechanism.BP_PrologueDoor")

function BP_AutoDoor_C:RegisterComponent(CompArray)
    BP_AutoDoor_C.Super.RegisterComponent(self, CompArray)
    self:AddTimer(1,self.Init)
end

function BP_AutoDoor_C:ReceiveBeginPlay()
    self.Overridden.ReceiveBeginPlay(self)
    self.IsDoorOpen = false
    self.UpdateOffsetTime = UKismetMathLibrary.RandomFloatInRange(0, 2.0)
end

function BP_AutoDoor_C:StartWait(Character)
    if self.CloseHandle then
        self:RemoveTimer(self.CloseHandle)
        self.CloseHandle = nil
    end
    if self.bNeedGuide then
        self:DeactiveGuide()
    end
    if self.DoorOpenState then
        print(_G.LogTag,"the Door ",self:GetName()," Has Open")
        return
    end
    if self.door_state then
        self:OpenMechanism(Character.Eid)
        self:PlayDoorSound(true)
    end
end

function BP_AutoDoor_C:EndWait(Character)
    self.CurrentTriggerPlayerNum = math.max(self.CurrentTriggerPlayerNum,0)
    if not self.DoorOpenState then
        return
    end
    if self.bNeedGuide then
        self:ActiveGuide("Add")
    end
    if self.door_state then
        self.CloseHandle = self:AddTimer(2,self.DelayCloseDoor,false,0,nil,nil,Character)
    end
end

function BP_AutoDoor_C:OpenMechanism(CharacterEid)
    print(_G.LogTag,"LXZ OpenMechanism")
    self:UpdateRegionData("DoorOpenState", true)

    local NeedRepair = false
    --组件指针做key，有可能被GC，开关门之前先修复一下数组
    for i, v in pairs(self.ComponentLoc) do
        if not IsValid(i) then
            NeedRepair = true
            break
        end
    end
    if NeedRepair then
        local Components = self:GetMeshComponents()
        local Index = 1
        for i, v in pairs(self.ComponentLoc) do
            if Index <= Components:Length() then
                i = Components:GetRef(Index)
                Index = Index + 1
            end
        end
    end
    self:OpenDoor(CharacterEid, self.Eid)
end

function BP_AutoDoor_C:CloseMechanism(CharacterEid)
    print(_G.LogTag,"LXZ CloseMechanism")
    self:UpdateRegionData("DoorOpenState", false)
    local NeedRepair = false
    --组件指针做key，有可能被GC，开关门之前先修复一下数组
    for i, v in pairs(self.ComponentLoc) do
        if not IsValid(i) then
            NeedRepair = true
            break
        end
    end
    if NeedRepair then
        local Components = self:GetMeshComponents()
        local Index = 1
        for i, v in pairs(self.ComponentLoc) do
            if Index <= Components:Length() then
                i = Components:GetRef(Index)
                Index = Index + 1
            end
        end
    end
    self:CloseDoor(CharacterEid, self.Eid)
end

function BP_AutoDoor_C:DelayCloseDoor(Character)
    self:CloseMechanism()
    self:PlayDoorSound(false)
end

function BP_AutoDoor_C:Init()
    if self.if_door then
        self.RunnerMaterial_Mid = UE4.UKismetMaterialLibrary.CreateDynamicMaterialInstance(self,self.RunnerMaterial)
        -- if not self.door_state then
        --     self.Box:K2_DestroyComponent(self)
        -- end
    else
        self:K2_DestroyActor()
    end
    for i,v in pairs(self.ComponentLoc) do
        i:K2_SetRelativeLocation(UE4.FVector(0,0,0),false,nil,false)
    end
    self.Box:SetCollisionEnabled(1)
    self.InitSuccess = true

    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode and GameMode.EMGameState.GameModeType == "Abyss" then
        self.bNeedGuide = true
        local Eid = GameMode:GetBattleEid()
        self.Eid = Eid
        Battle(self):AddEntity(Eid, self)
        self:LockDoor()
    end
end

function BP_AutoDoor_C:OnRep_DoorOpenState()
    if self.InitSuccess then
        if self.DoorOpenState then
            self:OpenDoor()
        else
            self:CloseDoor()
        end
    else
        local function Callback()
            if self.InitSuccess then
                if self.DoorOpenState then
                    self:OpenDoor()
                else
                    self:CloseDoor()
                end
                self:RemoveTimer("OnRep_DoorOpenState")
            end
        end
        self:AddTimer(0.5, Callback, true, 0, "OnRep_DoorOpenState", false)
    end
end

--大秘境用，暂时不考虑联机
function BP_AutoDoor_C:UnLockDoor()
    if self.bNeedGuide then
        self:ActiveGuide("Add")
    end
    self.Box:SetCollisionEnabled(1)
    self.door_state = true
    self:IndicatorColor()
    self:OnUnLockDoor()
end

function BP_AutoDoor_C:LockDoor()
    self.DoorOpenState = false
    if self.CloseHandle then
        self:RemoveTimer(self.CloseHandle)
        self.CloseHandle = nil
    end
    if self.bNeedGuide then
        self:DeactiveGuide()
    end
    self.Box:SetCollisionEnabled(0)
    -- for i,v in pairs(self.ComponentLoc) do
    --     i:K2_SetRelativeLocation(UE4.FVector(0,0,0),false,nil,false)
    -- end
    self:DelayCloseDoor()
    self.door_state = false
    self:IndicatorColor()
    self:OnLockDoor()
end
--大秘境用，暂时不考虑联机 end

function BP_AutoDoor_C:OnCharacterChangeLevel(Character)
    --大秘境专用
    if not IsAuthority(self) or not Character:IsPlayer() then
        return
    end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode.EMGameState.GameModeType ~= "Abyss" then
        return
    end
    if not self.door_state then
        return
    end
    self:OnLockDoor()
    print(_G.LogTag,"LXZ OnCharacterChangeLevel", self.BPArrow:GetName(), self.BPArrow.LevelId, self.BPArrow.OtherLevelId)
    --GameMode:TriggerStartNextRoom(self.BPArrow.LevelId, self.BPArrow.OtherLevelId)
end

return BP_AutoDoor_C
