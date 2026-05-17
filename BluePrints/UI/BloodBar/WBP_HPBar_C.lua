--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_HPBar_C
local WBP_HPBar_C = Class("BluePrints.UI.BP_UIState_C")


function WBP_HPBar_C:Initialize(Initializer)
    self.Super.Initialize(self)
    -- self.BloodBarLength = 0
    -- self.CurPercent = 1.0
    -- self.LastPercent = 1.0   
    -- self.DeductPercent = 1.0 -- 延迟扣血的进度条 只表示开始平滑下降时的最右端数值(也可以叫做平滑的起点)，不代表目前进度
    -- self.IsLowHealth = false

end

-- function WBP_HPBar_C:Init(IsEnemy,MinDesiredWidth)
    -- self.ProgressBar = self.Bar_Blood
    -- self.DeductBar = self.Bar_Blood_Deduct
    -- self.InvincibilityBar = self.Bar_Blood_Invincibility
    -- self.DeductEffectImage = self.DeductBlood
    -- self.AnimTotalTime = Const.BloodBarAnimTime
    -- self.AnimDelayTime = Const.BloodBarDelayTime
    -- self.DeductEffectSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.DeductBlood)
    -- MinDesiredWidth = math.floor(MinDesiredWidth)
    -- self.Length = MinDesiredWidth
    -- if self.DeductEffectSlot then
    --     self.DeductImageHeight = self.DeductEffectSlot:GetSize().Y  -- TODO
    -- end
    -- TODO Init_CPP
    -- self:Init_CPP(IsEnemy)
    -- self.Bar_Blood:SetPercent(1.0)
    -- self.Bar_Blood_Deduct:SetPercent(1.0)
    -- self.Bar_Blood_Deduct:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- self.DeductBlood:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- -- self.bg_blood:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- self:SetBarColor(IsEnemy)
-- end

-- function WBP_HPBar_C:ReInit()
--     -- self.BloodBarLength = 0
--     self.CurPercent = 1.0
--     self.LastPercent = 1.0
--     self.DeductPercent = 1.0
--     self.Bar_Blood:SetPercent(1.0)
--     self.Bar_Blood_Deduct:SetPercent(1.0)
--     self.Bar_Blood_Deduct:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     self.DeductBlood:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     self:CheckAndPlayLowHealth(false)
-- end

-- function WBP_HPBar_C:PlayBloodDeductEffect(LastPercent,NowPercent,RenderOpacity,Height)
--     local Lenght = (LastPercent-NowPercent)*self.BloodBarLength
--     local Position = self.DeductEffectSlot:GetPosition()
--     Position.X = NowPercent*self.BloodBarLength
--     self.DeductEffectSlot:SetPosition(Position)
--     self.DeductEffectSlot:SetSize(FVector2D(Lenght,Height))
--     self.DeductBlood:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--     self.DeductBlood:SetRenderOpacity(RenderOpacity)
--     -- self:PlayAnimation(self.Deduct_Blood,0,1)
-- end

-- function WBP_HPBar_C:SetBloodBarPercent(Percent)
--     Percent = math.clamp(Percent,0,1)
--     self.LastPercent = self.CurPercent
--     self.CurPercent = Percent
--     self.DeductPercent = math.max(self.DeductPercent,self.LastPercent)
--     self.Bar_Blood:SetPercent(Percent)
--     self.Bar_Blood_Invincibility:SetPercent(Percent)
-- end

-- function WBP_HPBar_C:PlayBloodDeduct(IsAttacking,DelayTime,IsShowDeductBar)
--     local AnimTime = Const.BloodBarAnimTime --0.05
--     DelayTime = IsAttacking and Const.BloodBarDelayTime or 0
--     local TickTime = 0.033
--     local DeductEffectHeight = self.DeductEffectHeight
--     local StartOpacity = 1.0
--     local DeductPercent = self.LastPercent - self.CurPercent
--     if DeductPercent < 0.1 and DeductPercent > 0.02 then
--         DeductEffectHeight = (((DeductPercent-0.02)/0.08)*0.5 + 0.5)*DeductEffectHeight
--         StartOpacity =  (((DeductPercent-0.02)/0.08)*0.5 + 0.5)
--     elseif DeductPercent < 0.02 then
--         DeductEffectHeight = DeductEffectHeight*0.5
--         StartOpacity = 0.5
--     end
--     StartOpacity = math.max(StartOpacity,0.5)
--     DeductEffectHeight = math.min(DeductEffectHeight,self.DeductEffectHeight)
--     -- self.DeductEffectHeight = DeductEffectHeight
--     local StartReductTime = UE4.UGameplayStatics.GetTimeSeconds(self)
--     if IsShowDeductBar == nil then
--         IsShowDeductBar = true
--     end
--     if IsShowDeductBar then
--         self.Bar_Blood_Deduct:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--     end
--     if self:IsExistTimer("RealReduceBlood") then
--         if not IsAttacking then
--             self:RemoveTimer("RealReduceBlood")
--         end
--         self.DeductPercent = self.Bar_Blood_Deduct.Percent -- 上一次的平滑还没完成的同时又受到攻击，此时更新平滑的起点
--     end
--     self:PlayBloodDeductEffect(self.DeductPercent, self.CurPercent, StartOpacity,DeductEffectHeight)
--     local RealReduceBlood = function()
--         local NowTime = UE4.UGameplayStatics.GetTimeSeconds(self)
--         local PassTime = NowTime - StartReductTime
--         PassTime = math.max(PassTime,DelayTime)
--         if PassTime > AnimTime + DelayTime then
--             self.Bar_Blood_Deduct:SetPercent(self.CurPercent)
--             self.DeductPercent = self.CurPercent
--             self:RemoveTimer("RealReduceBlood")
--             self.DeductBlood:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         else
--             local DelayBlood = self.DeductPercent - self.CurPercent
--             local TimeEffect =  (AnimTime + DelayTime - PassTime) /(AnimTime)
--             local Temp =  self.CurPercent + DelayBlood * TimeEffect
--             NowOpacity = StartOpacity * TimeEffect
--             self.Bar_Blood_Deduct:SetPercent(Temp)
--             self:PlayBloodDeductEffect(Temp,self.CurPercent, NowOpacity,DeductEffectHeight)
--             -- if Temp >= 1.0  then
--             --     print(_G.LogTag,"wps_         ",Temp,PassTime,DelayTime)
--             -- end
--         end
--     end
--     self:AddTimer(TickTime,RealReduceBlood,true,DelayTime,"RealReduceBlood")
-- end

-- function WBP_HPBar_C:SetBarColor(IsEnemy)
--     local Color
--     if IsEnemy  then
--         -- local LinearColor = UE4.UUIFunctionLibrary.StringToLinearColor("FF2A2AFF")
--         Color = FSlateColor()
--         Color.SpecifiedColor.R = 1.0
--         Color.SpecifiedColor.G = 0.048172
--         Color.SpecifiedColor.B = 0.048172
--         self.Bar_Blood.WidgetStyle.FillImage.TintColor = Color
--         self.Bar_Blood:SetFillColorAndOpacity(FLinearColor(0.930111,0.863157,0.775822,1.0))

--         -- Color.SpecifiedColor.R = 1.0
--         -- Color.SpecifiedColor.G = 0.439657
--         -- Color.SpecifiedColor.B = 0.05448
--         -- Color.SpecifiedColor = LinearColor
--         -- self.Bar_Blood_Deduct.WidgetStyle.FillImage.TintColor = Color
--         -- self.Bar_Blood_Deduct:SetFillColorAndOpacity(FLinearColor(1.0,1.0, 1.0, 1.0))
--     else
--         Color = FLinearColor(0.274677,0.637597,0.341915)
--         self.Bar_Blood:SetFillColorAndOpacity(Color)
--     end
-- end

-- function WBP_HPBar_C:CheckIsLowHealth(LowPercent)
--     return self.CurPercent <= LowPercent
-- end

-- function WBP_HPBar_C:CheckAndPlayLowHealth(IsLowHealth)
--     if IsLowHealth then
--         -- self.Bar_Blood_Deduct.WidgetStyle.FillImage.TintColor = self.LowDeductBloodBarTintColor
--         if self.IsLowHealth == false then
--             self:PlayAnimation(self.Player_HealthLow)
--             local AnimTime = self.Player_HealthWarning:GetEndTime()
--             local PlayWarningAnimation = function()
--                 self:PlayAnimation(self.Player_HealthWarning)
--             end
--             self:AddTimer(AnimTime, PlayWarningAnimation, true, 0, "PlayWarningAnimation")
--         end
--         self.IsLowHealth = true
--     else
--         -- self.Bar_Blood_Deduct.WidgetStyle.FillImage.TintColor = self.HighDeductBloodBarTintColor
--         if (self:IsExistTimer("PlayWarningAnimation")) then
--             self:RemoveTimer("PlayWarningAnimation")
--             self:StopAnimation(self.Player_HealthWarning)
--         end
--         if self.IsLowHealth then
--             self:StopAnimation(self.Player_HealthLow)
--             -- self:PlayAnimationReverse(self.Player_HealthLow) -- 偶现 不起作用，且可能覆盖其他地方的设置
--             self:SetBarColor(false)
--             self:AddTimer(0.1,function ()  -- 分支临时处理
--                 local Color = self.Bar_Blood.FillColorAndOpacity
--                 if  self.IsLowHealth == false and Color.R - 0.98 > 0 and Color.R - 1.0 <= 0.000001 then
--                     self:SetBarColor(false)
--                 end
--             end)
--         end
--         self.IsLowHealth = false
--     end
-- end

-- function WBP_HPBar_C:PlayInvincibility(IsInvincibility)
--     if IsInvincibility then
--         -- self:StopAnimation(self.Bar_BloodNormal)
--         -- self:PlayAnimation(self.Bar_BloodInvincibility)
--         self.Bar_Blood_Invincibility:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--         self.Bar_Blood:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         self.Bar_Blood_Deduct:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         self.Bar_Blood_Invincibility:SetPercent(self.CurPercent)
--     else
--         -- self:StopAnimation(self.Bar_BloodInvincibility)
--         -- self:PlayAnimation(self.Bar_BloodNormal)
--         self.Bar_Blood_Invincibility:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         self.Bar_Blood:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--     end
-- end

return WBP_HPBar_C