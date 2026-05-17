--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Battle_Aim_SuyiItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Construct()

end

function M:Init(Parent)
    self.Parent = Parent
    if self.In then
        self:PlayAnimation(self.In)
    end
    local InitSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self)
    if InitSlot then
        InitSlot:SetAnchors(UE4.FAnchors(0,0,0,0))
        InitSlot:SetAlignment(FVector2D(0.5, 0.5))
    end
    self.SmoothingAlpha = self.SmoothingAlpha or 0.8
    self.DebounceInterval = self.DebounceInterval or 0.01
    self.MinPixelDelta = self.MinPixelDelta or 0.5
    self.SnapDistance = self.SnapDistance or 30.0
    self._SmoothPos = nil
    self._TargetPos = nil
    self._LastSampleTime = 0
    self._SmoothScale = nil
end

function M:DeInit()
    self:StopAllAnimations()
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self._SmoothPos = nil
    self._TargetPos = nil
    self._LastSampleTime = 0
    self.TargetEid = nil
    self._SmoothScale = nil
end

function M:UpdateScreenPositionAndScale(TargetEid)
    self.TargetEid = TargetEid
    local Now = UE4.UGameplayStatics.GetTimeSeconds(self)
    local ShouldSample = (Now - self._LastSampleTime) >= (self.DebounceInterval or 0)
    if ShouldSample or (self._TargetPos == nil) then
        local SamplePos = self:GetScreenPosition()
        if SamplePos then
            if self._TargetPos then
                local dx = SamplePos.X - self._TargetPos.X
                local dy = SamplePos.Y - self._TargetPos.Y
                if (dx*dx + dy*dy) >= (self.MinPixelDelta or 0)^2 then
                    self._TargetPos = SamplePos
                end
            else
                self._TargetPos = SamplePos
            end
            self._LastSampleTime = Now
        else
            self._TargetPos = nil
        end
    end
    local Pos = nil
    if self._TargetPos then
        if not self._SmoothPos then
            self._SmoothPos = FVector2D(self._TargetPos.X, self._TargetPos.Y)
        else
            local dx = self._TargetPos.X - self._SmoothPos.X
            local dy = self._TargetPos.Y - self._SmoothPos.Y
            local dist2 = dx*dx + dy*dy
            local a = self.SmoothingAlpha or 0
            if self.SnapDistance and dist2 >= (self.SnapDistance*self.SnapDistance) then
                a = math.min(0.9, a + 0.25)
            end
            self._SmoothPos.X = self._SmoothPos.X + a * dx
            self._SmoothPos.Y = self._SmoothPos.Y + a * dy
        end
        Pos = self._SmoothPos
    end
    local Slot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self)
    if Pos and Slot then
        Slot:SetPosition(Pos)
        local Parent = self.Parent
        local OwnerPlayer = Parent and Parent.Root and Parent.Root.OwnerPlayer or nil
        local Controller = OwnerPlayer and OwnerPlayer:GetController() or nil
        local Pawn = Controller and Controller:K2_GetPawn() or nil
        local PlayerLocation = nil
        if Pawn then
            PlayerLocation = Pawn:K2_GetActorLocation()
        elseif OwnerPlayer then
            PlayerLocation = OwnerPlayer:K2_GetActorLocation()
        end
        local Scale = nil
        if PlayerLocation and self.TargetEid then
            local TargetActor = self:GetTargetEntityFromRef(self.TargetEid)
            if IsValid(TargetActor) then
                local TargetLocation = Parent.Root:GetMeshLocationByShootTarget(TargetActor)
                local Distance = UE4.UKismetMathLibrary.Vector_Distance(PlayerLocation, TargetLocation)
                local Rate = self.EnemyMarkWidgetScaleRate or 1.0
                local MinScale = self.MinEnemyMarkWidgetScale or 0.6
                local RefDist = 800.0
                local RawScale = 1.0 / (Rate * (Distance / RefDist))
                Scale = math.max(MinScale, RawScale)
            end
        end
        if Scale then
            self:SetRenderScale(FVector2D(Scale, Scale))
        end
        self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        return true
    else
        self:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return false
    end
end

function M:GetScreenPosition()
    local Parent = self.Parent
    if not Parent or not Parent.Root then return nil end
    local OwnerPlayer = Parent.Root.OwnerPlayer
    if not OwnerPlayer then return nil end
    local Controller = OwnerPlayer:GetController()
    if Controller == nil then return nil end
    local ViewportScale = UE4.UWidgetLayoutLibrary.GetViewportScale(Parent)
    local ViewportSize = UE4.UWidgetLayoutLibrary.GetViewportSize(Parent)
    if not self.TargetEid then return nil end
    local TargetActor = self:GetTargetEntityFromRef(self.TargetEid)
    if not IsValid(TargetActor) then return nil end
    local TargetLocation = Parent.Root:GetMeshLocationByShootTarget(TargetActor)
    local ScreenPosition = FVector2D(0, 0)
    local IsProjected = UE4.UGameplayStatics.ProjectWorldToScreen(Controller, TargetLocation, ScreenPosition)
    if not IsProjected then return nil end
    local ParentSize = USlateBlueprintLibrary.GetLocalSize(Parent:GetCachedGeometry())
    ScreenPosition.X = ScreenPosition.X / ViewportScale
    ScreenPosition.Y = ScreenPosition.Y / ViewportScale
    local LocalPosX = ScreenPosition.X - (ViewportSize.X / ViewportScale) * 0.5 + ParentSize.X * 0.5
    local LocalPosY = ScreenPosition.Y - (ViewportSize.Y / ViewportScale) * 0.5 + ParentSize.Y * 0.5
    return FVector2D(LocalPosX, LocalPosY)
end

function M:GetTargetEntityFromRef(TargetEid)
    if not TargetEid then return nil end
    local Eid = nil
    if type(TargetEid) == "number" then
        Eid = TargetEid
    end
    if Eid then
        local Battle = Battle(self)
        if Battle then
            return Battle:GetEntity(Eid)
        end
    end
    return nil
end

return M
