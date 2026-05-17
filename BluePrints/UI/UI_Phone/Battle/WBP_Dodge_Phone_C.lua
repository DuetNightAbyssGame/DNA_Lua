--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
---@type Dodge_Phone_C
local M = Class("BluePrints.UI.BP_UIState_C")

M._components = {
    "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent",
}

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

 function M:Construct()
     self.Button_Area.OnPressed:Add(self, self.OnPressed)
     self.Button_Area.OnReleased:Add(self, self.OnReleased)
     self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
     self.MaxAvoidTimes = self.OwnerPlayer:GetAttr("MaxAvoidExecuteTimes")
     self.DodgeCD = self.OwnerPlayer:GetAttr("AvoidChargeCd") or 0
     local DodgeCount = self.OwnerPlayer.DodgeCount
     local AvoidRemainTimes = math.max(0, self.MaxAvoidTimes - DodgeCount)
     self.AvoidRemainTimes = AvoidRemainTimes
    --  self.CD = self.OwnerPlayer:GetAttr("AvoidChargeCd") or 0
     self.CDMat = self.ProgressBar_CD:GetDynamicMaterial()
     self.Text_Times:SetText(self.AvoidRemainTimes)
     self.IsForbidden = false
    if self.OwnerPlayer:CheckSkillInActive(UE4.ESkillName.Avoid) then
        self.CurButtonState = "InActive"
    else
        self.CurButtonState = "Active"
    end
     local IconMat = self.Image_Main:GetDynamicMaterial()
     IconMat:SetTextureParameterValue("IconMap", self.Icon_Dodge)
     EMUIAnimationSubsystem:EMPlayAnimation(self,self.MountFly_Out)
 end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:OnPressed()
    -- 表现层
    self:OnPressed_Presentation()
    -- 逻辑层
    if self.OwnerPlayer.CurMount and self.OwnerPlayer:IsFlying() then
        self.OwnerPanel:TryToPlayTargetCommand("Slide", true)
    else
        self.OwnerPanel:TryToPlayTargetCommand("Avoid", true)
    end
end

function M:OnReleased()
    -- 表现层
    self:OnReleased_Presentation()
    -- 逻辑层
    if self.OwnerPlayer.CurMount and self.OwnerPlayer:IsFlying() then
        self.OwnerPanel:TryToStopTargetCommand("Slide", true)
    end
end

function M:OnPressed_Presentation()
    if self.OwnerPlayer.CurMount and self.OwnerPlayer:IsFlying() then
        EMUIAnimationSubsystem:EMPlayAnimation(self,self.Press)
        return
    end
    -- 如果没激活闪避 跳过
    if self.CurButtonState == "InActive" then
        return
    end
    if self.AvoidRemainTimes > 0 then
        if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self,self.Click) then
            EMUIAnimationSubsystem:EMPlayAnimation(self,self.Click)
        end
    else
        if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self,self.Disable) then
            EMUIAnimationSubsystem:EMPlayAnimation(self,self.Disable)
        end
    end
end

function M:OnReleased_Presentation()
    if self.OwnerPlayer.CurMount and self.OwnerPlayer:IsFlying() then
        EMUIAnimationSubsystem:EMPlayAnimation(self,self.Press, EUMGSequencePlayMode.Reverse)
    end
end

function M:UpdateButtonInTimer()
    -- 如果没激活闪避 跳过
    if self.CurButtonState == "InActive" then
        return
    end
    self.MaxAvoidTimes = self.OwnerPlayer:GetAttr("MaxAvoidExecuteTimes")
    self.DodgeCD = self.OwnerPlayer:GetAttr("AvoidChargeCd") or 0
    local DodgeCount = self.OwnerPlayer.DodgeCount
    local AvoidRemainTimes = self.MaxAvoidTimes - DodgeCount
    local Now = UE4.UGameplayStatics.GetTimeSeconds(self)
    if (AvoidRemainTimes ~= self.MaxAvoidTimes) then

        self.DodgeChargeTimeRemain = self.OwnerPlayer:GetDodgeChargeRemainTime()
        local Percent = (self.DodgeChargeTimeRemain) / self.DodgeCD
        -- if (Percent >= 1) then
        --     self.DodgeChargeTimeRemain = 0
        -- end
        self.CDMat:SetScalarParameterValue("Percent",1 - Percent)
    else
        self.DodgeChargeTimeRemain = 0
        self.CDMat:SetScalarParameterValue("Percent",0)
    end
    -- 次数发生变化才SetText
    if (self.AvoidRemainTimes ~= AvoidRemainTimes) then
        print(_G.LogTag, "DodgeCount changed, AvoidRemainTimes:", AvoidRemainTimes, Now)
        self.Text_Times:SetText(AvoidRemainTimes)
    end
    self.AvoidRemainTimes = AvoidRemainTimes
    if (self.AvoidRemainTimes == 0 and self.IsForbidden == false) then
        self.IsForbidden = true
        if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self,self.Forbidden) then
            EMUIAnimationSubsystem:EMPlayAnimation(self,self.Forbidden)
        end
    elseif (self.AvoidRemainTimes > 0 and self.IsForbidden == true) then
        self.IsForbidden = false
        if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self,self.Normal) then
            EMUIAnimationSubsystem:EMPlayAnimation(self,self.Normal)
        end
    end
end

function M:OnStartMountFly()
    EMUIAnimationSubsystem:EMPlayAnimation(self,self.MountFly_In)
    local IconMat = self.Image_Main:GetDynamicMaterial()
    IconMat:SetTextureParameterValue("IconMap", self.Icon_MountDown)
end

function M:OnStopMountFly()
    EMUIAnimationSubsystem:EMPlayAnimation(self,self.Press, EUMGSequencePlayMode.Reverse)
    EMUIAnimationSubsystem:EMPlayAnimation(self,self.MountFly_Out)
    local IconMat = self.Image_Main:GetDynamicMaterial()
    IconMat:SetTextureParameterValue("IconMap", self.Icon_Dodge)
end

AssembleComponents(M)

return M
