--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local M = Class( "BluePrints.Item.BP_CombatItemBase_C")

function M:AuthorityInitInfo(Info)
    M.Super.AuthorityInitInfo(self,Info)
    if self.GroupId ~= 0 then
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        GameMode:GetDungeonComponent():AddStepPlatForm(self.GroupId, self.Eid)
    end
end

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self,Info)
    self.CanMove = self.Speed ~= 0
    self.CanHide = self.ShowTime ~= 0
    self.CanChangeColor = self.GroupId ~= 0

    self.bShow = true
    self.bMoving = false
    self.NextMoveEndIdx = 1
    --记录当前运动是正向还是反向
    self.PositiveMove = 1
    self.NextMoveEnd = self:K2_GetActorLocation()
    self.LastStartLoc = FVector(0,0,0)
    self.InitLoc = self:K2_GetActorLocation()
    self.RemainHideTime = 0
    self.RemainShowTime = 0
    self.RemainColorBackTime = 0

    self.bHasMoveActive = false
    self.OriginalColorType = self.NowColorType
    self.OriginalPatternType = self.NowPatternType
    if self.bAutoActive then
        self:ActiveCombat(false)
    end
    self:SetColor(false, true)
    self:SetPattern(false, true)
end

function M:ResetInfo()
    self.Overridden.ResetInfo(self)

    self.CanMove = self.Speed ~= 0
    self.CanHide = self.ShowTime ~= 0
    self.CanChangeColor = self.GroupId ~= 0

    self.bShow = true
    self.bMoving = false
    self.NextMoveEndIdx = 1
    --记录当前运动是正向还是反向
    self.PositiveMove = 1
    self.NextMoveEnd = self.InitLoc
    self.LastStartLoc = FVector(0,0,0)
    self.RemainHideTime = 0
    self.RemainShowTime = 0
    self.RemainColorBackTime = 0
    self.bHasMoveActive = false
    self.IsActive = false

    if self.CanMove then
        self:K2_SetActorLocation(self.InitLoc, false, nil, false)
    end
    if self.CanHide then
        self:RemoveTimer("ExecuteShow")
        self:RemoveTimer("ExecuteHide")
        self:ReShow()
    end
    if self.CanChangeColor then
        self:RemoveTimer("ColorBackHandle")
    end
    if self.bAutoActive then
        self:ActiveCombat(false)
    end

    self.NowColorType = self.OriginalColorType
    self:SetColor(true)
    self.NowPatternType = self.OriginalPatternType
    self:SetPattern(true)

    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    GameMode:GetDungeonComponent():SetIsStepPlatformMoveEnd(self.ManualItemId, false)

    self:BluePrintReset()
end

function M:ReceiveBeginPlay()
    self.Super.ReceiveBeginPlay(self)
    if self.bShowPath then
        self.Center = self.LineCenter:K2_GetComponentLocation()
        local DrawLineStart = self.Center
        local Points = {}
        table.insert(Points, DrawLineStart)
        for i = 1, self.TargetLocArray:Length() do
            local DrawLineEnd = DrawLineStart + self.TargetLocArray[i]
            URuntimeCommonFunctionLibrary.DrawPathLine(self, true, DrawLineStart, DrawLineEnd, self.LineColor, self.Thickness / 2)
            table.insert(Points, DrawLineEnd)
            DrawLineStart = DrawLineEnd
        end
        if self.MoveType == 1 then
            URuntimeCommonFunctionLibrary.DrawPathLine(self, true, DrawLineStart, self.Center, self.LineColor, self.Thickness / 2)
        end

        if self.PointSizeRatio > 0 then
            -- 线段端点生成小方块
            local HalfLength = self.Thickness * self.PointSizeRatio / 2
            for _, Pos in pairs(Points) do
                URuntimeCommonFunctionLibrary.DrawPathBox(self, Pos, self.LineColor, self.Thickness, HalfLength)
            end
        end
    end
end

-- function M:ReceiveEndPlay()
-- end

function M:ReceiveTick(DeltaSeconds)
    self.Overridden.ReceiveTick(self, DeltaSeconds)
    if self.bMoving then
        self:MoveLocation(DeltaSeconds)
        self:CheckCurrentMoveEnd()
    end
end

function M:CalMoveParam(BackToInit, bPausedRecover)
    if bPausedRecover then
        return
    end
    self.LastStartLoc = self.NextMoveEnd
    
    if BackToInit then
        self.NextMoveEnd = self.InitLoc
        --设成0，方便下一次运动+1
        self.NextMoveEndIdx = 0
    else
        if self.MoveType == 0 and self.NextMoveEndIdx > self.TargetLocArray:Length() then
            return
        end
        self.NextMoveEnd = self:K2_GetActorLocation() + self.TargetLocArray[self.NextMoveEndIdx] * self.PositiveMove
    end

    local Direction = self.NextMoveEnd - self:K2_GetActorLocation()
    Direction:Normalize()
    local NextSpeed = Direction * self.Speed
    self:SetMovementParam(NextSpeed, FVector(0,0,0))
    if self.OnBluePrintStartMove and NextSpeed:Size() > 0 then
        self:OnBluePrintStartMove()
    end
end

--不绑定机关就只触发自己的踩踏逻辑
function M:TriggerSelfLogic(IsOverLap)
    if IsOverLap then
        self:TriggerEnterLogic()
    else
        self:TriggerLeaveLogic()
    end
end

function M:TriggerEnterLogic()
    self:ActiveCombat(false)
end

function M:TriggerLeaveLogic()
end

function M:OnPlayerOverLap()
    if self.bPlayerActive and not self.IsActive then
        self:ActiveCombat(false)
    elseif self.IsActive and self.CanChangeColor then
        self:StartChangeColor()
    end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
        GameMode:GetDungeonComponent():OnPlayerOverlap(self.ManualItemId)
    end
end

function M:OnPlayerEndOverLap()
    --暂时用不到，先随便放一个
    self:TriggerSelfLogic(false)
end

function M:ActiveCombat(bFromGameMode)
    self.IsActive = true
    if self.CanMove and not self.bMoving and self.bAutoMove then
        self:StartMove()
        self.bHasMoveActive = true
    end
    if self.CanHide then
        self:StartHidePlatForm()
    end
    if self.CanChangeColor and not bFromGameMode then
        self:StartChangeColor()
    end
end

function M:InactiveCombat(bFromGameMode)
    self.IsActive = false
    self.bMoving = false
    self:RemoveTimer("ExecuteHide")
    self:RemoveTimer("ExecuteShow")
    self:RemoveTimer("ColorBackHandle")
end

------------------------------不同类型的独特逻辑-----------------------------
function M:StartMove()
    if self.bMoving then
        return
    end
    self.bMoving = true
    if not self.bAutoMove then
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        GameMode:GetDungeonComponent():SetIsStepPlatformMoveEnd(self.ManualItemId, false)
    end
    if self.MoveType == 1 and (self.NextMoveEndIdx > self.TargetLocArray:Length() or self.NextMoveEndIdx < 1) then
        self:CalMoveParam(true, self.bHasMoveActive)
    else
        self:CalMoveParam(false, self.bHasMoveActive)
    end
end

function M:EndMove()
    self.bMoving = false
end

function M:CheckCurrentMoveEnd()
    local CurrentLoc = self:K2_GetActorLocation()
    -- print(_G.LogTag,"LXZ CheckCurrentMoveEnd", (CurrentLoc - self.LastStartLoc):Size(), (self.NextMoveEnd - self.LastStartLoc):Size())
    if (CurrentLoc - self.LastStartLoc):Size() >= (self.NextMoveEnd - self.LastStartLoc):Size() and self.NextMoveEnd then
        local bShouldEnd = true  -- 是否应该判定为直接结束，结束就直接通知GameMode，否则(例如Type3到终点后要等0.05秒的消失间隔后才应该判定为结束)后续再通知
        self:K2_SetActorLocation(self.NextMoveEnd, false, nil, false)
        if not self.bAutoMove then
            self.bMoving = false
        end
        self.NextMoveEndIdx = self.NextMoveEndIdx + 1 * self.PositiveMove
        if self.NextMoveEndIdx > self.TargetLocArray:Length() or self.NextMoveEndIdx < 1 then
            if self.MoveType == 0 then
                self.bMoving = false
            elseif self.MoveType == 1 then
                if self.bAutoMove then
                    self:CalMoveParam(true)
                end
            elseif self.MoveType == 2 then
                self.NextMoveEndIdx = self.NextMoveEndIdx - 1 * self.PositiveMove
                self.PositiveMove = -1 * self.PositiveMove
                if self.bAutoMove then
                    self:CalMoveParam(false)
                end
            else
                bShouldEnd = false
                self:OnType3End()
            end
        elseif self.bAutoMove then
            self:CalMoveParam(false)
        end
        if not self.bAutoMove and bShouldEnd then
            local GameMode = UE4.UGameplayStatics.GetGameMode(self)
            GameMode:GetDungeonComponent():SetIsStepPlatformMoveEnd(self.ManualItemId, true)
            GameMode:GetDungeonComponent():StepPlatformMoveEndEvent(self.ManualItemId)
            if self.OnBluePrintEndMove then
                self:OnBluePrintEndMove()
            end
        end
    end
end

function M:OnType3End()
    self:SetActorHiddenInGame(true)
    -- local Meshs = TArray(UStaticMeshComponent)
    -- self.Default:GetChildrenComponents(true, Meshs)
    -- if self.Meshes then
    --     for _, Mesh in pairs(self.Meshes) do
    --         Mesh:SetCollisionEnabled(ECollisionEnabled.NoCollision)
    --     end
    -- else
    --     self.Meshes = {}
    --     for i = 1, Meshs:Length() do
    --         local Mesh = Meshs:GetRef(i)
    --         if Mesh:Cast(UStaticMeshComponent) then
    --             table.insert(self.Meshes, Mesh)
    --             Mesh:SetCollisionEnabled(ECollisionEnabled.NoCollision)
    --         end
    --     end
    -- end
    self:SetActorEnableCollision(false)
    self.bMoving = false
    self:AddTimer(0.05, self.SetPlatformVisible, false, 0)
end

function M:SetPlatformVisible()
    self:K2_SetActorLocation(self.InitLoc, false, nil, false)
    self:SetActorHiddenInGame(false)
    -- if self.Meshes then
    --     for _, Mesh in pairs(self.Meshes) do
    --         Mesh:SetCollisionEnabled(ECollisionEnabled.QueryAndPhysics)
    --     end
    -- end
    self:SetActorEnableCollision(true)
    self.NextMoveEnd = self.InitLoc
    self.NextMoveEndIdx = 1
    if self.bAutoMove then
        self.bMoving = true
        self:CalMoveParam(false)
    end
    if not self.bAutoMove then
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        GameMode:GetDungeonComponent():SetIsStepPlatformMoveEnd(self.ManualItemId, true)
        GameMode:GetDungeonComponent():StepPlatformMoveEndEvent(self.ManualItemId)
        if self.OnBluePrintEndMove then
            self:OnBluePrintEndMove()
        end
    end
end

function M:StartHidePlatForm()
    if self.ShowTime == 0 then
        return
    end
    if (self.RemainShowTime <=0 and self.RemainHideTime <= 0) or self.RemainShowTime > 0 then
        if self.RemainShowTime <=0 then
            self.RemainShowTime = self.ShowTime
        end
        self:AddTimer(0.8, self.ExecuteHide, true, 0, "ExecuteHide")
    elseif self.RemainHideTime > 0 then
        self:AddTimer(0.8, self.ExecuteShow, true, 0, "ExecuteShow")
    end
end

function M:ExecuteHide()
    self.RemainShowTime = self.RemainShowTime - 0.8
    if self.RemainShowTime > 0 then
        self:WaitToHide(self.RemainShowTime, self.ShowTime)
        return
    end
    self:RemoveTimer("ExecuteHide")
    self.bShow = false
    -- self:HideMechanism(false, "PlatFormLogic", false)
    self:OnHide()
    if self.HideTime == 0 then
        return
    end
    if self.RemainShowTime <=0 then
        self.RemainHideTime = self.HideTime
    end
    self:AddTimer(0.8, self.ExecuteShow, true, 0, "ExecuteShow")
end

function M:ExecuteShow()
    self.RemainHideTime = self.RemainHideTime - 0.8
    if self.RemainHideTime > 0 then
        self:WaitToShow(self.RemainHideTime, self.HideTime)
        return
    end
    self:RemoveTimer("ExecuteShow")
    self.bShow = true
    -- self:ShowMechanism("PlatFormLogic")
    self:OnShow()
    if self.RemainHideTime <=0 then
        self.RemainShowTime = self.ShowTime
    end
    self:AddTimer(0.8, self.ExecuteHide, true, 0, "ExecuteHide")
end

function M:StartChangeColor()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode:GetDungeonComponent().CurrentStepPlayformEid == self.Eid then
        return
    end
    if self.GroupId == 0 or self.NowColorType == 0 then
        return
    end
    if self.RemainColorBackTime <= 0 then
        if self.ColorBackTime ~= 0 then
            self.RemainColorBackTime = self.ColorBackTime
            self:RemoveTimer("ColorBackHandle")
            self:AddTimer(0.5, self.ColorBack, true, 0, "ColorBackHandle")
        end
        GameMode:GetDungeonComponent():ActiveStepPlatform(self.Eid)
        self.NowColorType = self.NowColorType % 3 + 1
        self:SetColor(false)
        GameMode:GetDungeonComponent():OnPlatformChangedColor(self.GroupId, self.ManualItemId, self.NowColorType)
    elseif not self:IsExistTimer("ColorBackHandle") then
        self:AddTimer(0.5, self.ColorBack, true, 0, "ColorBackHandle")
    end
end

function M:SetColor(IsFromReset, NotTriggerEvent)
    self:ChangeColor(self.NowColorType, IsFromReset)
    if NotTriggerEvent then return end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if self.NowColorType == 3 then
        GameMode:GetDungeonComponent():OnStepPlatformChangeGreen(self.GroupId, self.Eid)
    else
        GameMode:GetDungeonComponent():OnStepPlatformLeaveGreen(self.GroupId, self.Eid)
    end
end

function M:ColorBack()
    self.RemainColorBackTime = self.RemainColorBackTime - 0.5
    if self.RemainColorBackTime >= 0 then
        return
    end
    self:RemoveTimer("ColorBackHandle")
    self.NowColorType = math.max(self.NowColorType - 1, 1)
    self:ChangeColor(self.NowColorType)
end

function M:SetPattern(IsFromReset)
    self:OnPatternChanged(self.NowPatternType, IsFromReset)
end
----------------------------不同类型的独特逻辑End----------------------------

return M
