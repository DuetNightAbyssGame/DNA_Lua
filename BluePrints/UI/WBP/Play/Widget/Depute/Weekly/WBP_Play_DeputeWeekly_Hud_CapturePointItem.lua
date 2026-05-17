--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Play_DeputeWeekly_Hud_CapturePointItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Init(OccupateProgress)
    self.Progress = OccupateProgress
    self.TargetProgress = 0
    self.LerpAlpha = 0
    self.Text_Percent:SetText(OccupateProgress)
    self.Image_Bar:GetDynamicMaterial():SetScalarParameterValue("Percent", OccupateProgress)
    self.Root:SetRenderOpacity(0)
    -- self:PlayAnimation(self.In)
end

function M:OnProgressChange(NewProgress)
    -- if(self.ProgressChangeHandle and IsValid(self.ProgressChangeHandle))then
    --     ULTweenBPLibrary.KillIfIsTweening(self,self.ProgressChangeHandle,true)
    -- end
    -- self.ProgressChangeHandle = UE4.ULTweenBPLibrary.FloatTo(self,{self,function(_,value)
    --     self.Text_Percent:SetText(math.floor(value))
    --     self.Image_Bar:GetDynamicMaterial():SetScalarParameterValue("Percent", value/100)
    --     if value >= 100 and not self:IsAnimationPlaying(self.Out) then
    --         self:PlayAnimation(self.Out)
    --     end
    -- end},self.Progress,NewProgress,1,0,0)
    -- self.ProgressChangeHandle:OnComplete({self,function()
    --     self.Progress = NewProgress
    -- end})
    self.Text_Percent:SetText(math.floor(NewProgress))
    self.Image_Bar:GetDynamicMaterial():SetScalarParameterValue("Percent", NewProgress/100)
    if NewProgress >= 100 and not self:IsAnimationPlaying(self.Out) then
        self:PlayAnimation(self.Out)
    end
    self.Progress = NewProgress
end

function M:OnPlayerOut()
    self:StopAllAnimations()
    self:PlayAnimation(self.Out)
end

function M:OnPlayerIn()
    self:StopAllAnimations()
    self:PlayAnimation(self.In)
end

function M:OnOccupationPause()
    self:Set_Color(true)
end

function M:OnOccupationContinue()
    self:Set_Color(false)
end

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

-- function M:Tick(MyGeometry, InDeltaTime)
--     self.LerpAlpha = self.LerpAlpha + InDeltaTime
--     UE4.UKismetMathLibrary.Lerp(self.Progress,NewProgress,self.LerpAlpha)
--     self.Text_Percent:SetText(self.Progress)
--     self.Image_Bar:GetDynamicMaterial():SetScalarParameterValue("Percent", self.Progress/100)
-- end

--function M:Destruct()
--end


return M
