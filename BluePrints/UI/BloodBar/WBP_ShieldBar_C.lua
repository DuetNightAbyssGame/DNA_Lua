--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_ShieldBar_C
local WBP_ShieldBar_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_ShieldBar_C:Initialize(Initializer)
    self.Super.Initialize(self)
    -- self.ShieldBarLength = 0
    -- self.ShieldBarHeight = 0
    -- self.CurPercent = 1.0
    -- self.LastPercent = 1.0   
    -- self.DeductStartPercent = 1.0 -- 延迟扣血的进度条 只表示开始平滑下降时的最右端数值(也可以叫做平滑的起点)，不代表目前进度
    -- self.CurDeductPercent = 1.0
    -- self.DeductEffectHeight = 0.0
    -- self.CanvaSlotOfSheildDeduct = nil -- 蓝图里的ShieldDeduct不是progress而是Image，所以需要这个东西来控制宽度
    -- self.DeductImageSize = FVector2D()
    -- self.FuncWhileRecovery = nil
    -- self.Params = nil
end

-- function WBP_ShieldBar_C:Init(MinDesiredWidth,HeightOverride)

--     -- self.ProgressBar = self.Bar_Shield
--     -- self.DeductBar = self.Shield_Deduct
--     -- self.InvincibilityBar = self.Bar_Shield_Invincibility
--     -- self.DeductEffectSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.DeductShield)
--     -- self.DeductEffectImage = self.DeductShield
--     -- self.AnimTotalTime = Const.BloodBarAnimTime
--     -- self.AnimDelayTime = Const.BloodBarDelayTime
--     -- self.ShieldDeductImageSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Shield_Deduct)
--     -- self.OwnerWidget = ParentWidget

--     -- if self.DeductEffectSlot then
--     --     self.DeductImageHeight = self.DeductEffectSlot:GetSize().Y
--     -- end
--     -- self.Length = MinDesiredWidth
--     -- self.Height = HeightOverride

--     -- self:Init_CPP()
--     -- if FuncWhileRecovery then
--     --     self.ShieldRecoverDelegate:Bind(self.OwnerWidget,FuncWhileRecovery)
--     -- end
--     -- self.Bar_Shield:SetPercent(1.0)
--     -- self:SetShieldCurDeductPercent(1.0)
--     -- self.DeductShield:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     -- -- self.bg_shield:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     -- self.Shield_Deduct:SetVisibility(UE4.ESlateVisibility.Collapsed)

--     -- self.FuncWhileRecovery = FuncWhileRecovery
--     -- self.Params = {...}
-- end

-- function WBP_ShieldBar_C:ReInit()
--     self.CurPercent = 1.0
--     self.LastPercent = 1.0   
--     self.DeductStartPercent = 1.0
--     self.CurDeductPercent = 1.0
--     self.Bar_Shield:SetPercent(1.0)
--     self:SetShieldCurDeductPercent(1.0)
--     self.DeductShield:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     self.Shield_Deduct:SetVisibility(UE4.ESlateVisibility.Collapsed)
-- end

-- function WBP_ShieldBar_C:PlayShieldDeductEffect(LastPercent,NowPercent,RenderOpacity,Height)
--     if not RenderOpacity then
--         RenderOpacity = 0
--     else
--         RenderOpacity = math.clamp(RenderOpacity, 0, 1)
--     end
--     local Lenght = (LastPercent-NowPercent)*self.ShieldBarLength
--     local Position = self.DeductEffectSlot:GetPosition()
--     Position.X = NowPercent*self.ShieldBarLength
--     self.DeductEffectSlot:SetPosition(Position)
--     self.DeductEffectSlot:SetSize(FVector2D(Lenght,Height))
--     self.DeductShield:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--     self.DeductShield:SetRenderOpacity(RenderOpacity)
--     -- self:PlayAnimation(self.Deduct_Shield)
-- end

-- function WBP_ShieldBar_C:PlayReductShield(IsAttacking,DelayTime,IsShowDeductBar)
--     if self.LastPercent < self.CurPercent then
--         return
--     end
--     DelayTime = IsAttacking and Const.BloodBarDelayTime or 0
--     IsShowDeductBar = IsShowDeductBar == nil and true or false
--     local AnimTime = Const.BloodBarAnimTime --0.05
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

--     local StartReductTime = UE4.UGameplayStatics.GetTimeSeconds(self)
--     if IsShowDeductBar then
--         self.Shield_Deduct:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--     end
--     if self:IsExistTimer("RealReduceShield") then
--         if not IsAttacking then
--             self:RemoveTimer("RealReduceShield")
--         end
--         self.DeductStartPercent = self.CurDeductPercent -- 上一次的平滑还没完成的同时又受到攻击，此时更新平滑的起点
--     end
--     if self:IsExistTimer("RealRecoveryShield") then
--         self:RemoveTimer("RealRecoveryShield")
--     end
--     self:PlayShieldDeductEffect(self.DeductStartPercent, self.CurPercent, StartOpacity,DeductEffectHeight)
--     local RealReduceShield = function()
--         local NowTime = UE4.UGameplayStatics.GetTimeSeconds(self)
--         local PassTime = NowTime - StartReductTime 
--         PassTime = math.max(PassTime,DelayTime)
--         if PassTime > AnimTime + DelayTime then
--             self:SetShieldCurDeductPercent(self.CurPercent)
--             self.DeductStartPercent = self.CurPercent
--             self:RemoveTimer("RealReduceShield")
--             self.DeductShield:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         else
--             local DelayShield = self.DeductStartPercent - self.CurPercent
--             local TimeEffect =  (AnimTime + DelayTime - PassTime) /AnimTime
--             local ThisTimePercent = self.CurPercent + DelayShield * TimeEffect
--             NowOpacity = StartOpacity * TimeEffect
--             ThisTimePercent = math.clamp(ThisTimePercent,0,1)
--             self:SetShieldCurDeductPercent(ThisTimePercent)
--             self:PlayShieldDeductEffect(ThisTimePercent, self.CurPercent,NowOpacity,DeductEffectHeight)
--             --print(_G.LogTag,"WPS_ SHieldBar Deduct",ThisTimePercent,StartOpacity,TimeEffect)
--         end
--     end
--     self:AddTimer(TickTime,RealReduceShield,true,DelayTime,"RealReduceShield")
-- end

-- function WBP_ShieldBar_C:PlayRecoveryShield(bNeedLerp)
--     if self.LastPercent > self.CurPercent then
--         return
--     end
--     local AnimTime = 1.0
--     local TickTime = 0.033
--     local StartRecoverTime = UE4.UGameplayStatics.GetTimeSeconds(self)
--     self.Shield_Deduct:SetVisibility(UE4.ESlateVisibility.Collapsed)

--     if bNeedLerp == false then
--         self.Bar_Shield:SetPercent(self.CurPercent)
--         self:SetShieldCurDeductPercent(self.CurPercent)
--         if self.FuncWhileRecovery then
--             self.FuncWhileRecovery(table.unpack(self.Params),self.CurPercent)
--         end
--         return
--     end

--     local RealRecoveryShield = function ()
--         local NowTime = UE4.UGameplayStatics.GetTimeSeconds(self)
--         local PassTime = NowTime - StartRecoverTime
--         if PassTime > AnimTime then
--             self.Bar_Shield:SetPercent(self.CurPercent)
--             self:SetShieldCurDeductPercent(self.CurPercent)
--             self:RemoveTimer("RealRecoveryShield")
--             if self.FuncWhileRecovery then
--                 self.FuncWhileRecovery(table.unpack(self.Params),self.CurPercent)
--             end
--         else
--             local DelayShield = self.CurPercent - self.LastPercent
--             local ThisTimePercent = self.LastPercent + DelayShield*(PassTime/AnimTime)
--             ThisTimePercent = math.clamp(ThisTimePercent,0,1)
--             self.Bar_Shield:SetPercent(ThisTimePercent)
--             self:SetShieldCurDeductPercent(ThisTimePercent)
--             if self.FuncWhileRecovery then
--                 self.FuncWhileRecovery(table.unpack(self.Params),ThisTimePercent)
--             end
--         end
--     end
--     self:AddTimer(TickTime,RealRecoveryShield,true,0,"RealRecoveryShield")
-- end

-- function WBP_ShieldBar_C:SetShieldBarPercent(Percent,IsSetImmediately)
--     Percent = math.clamp(Percent,0,1)
--     if IsSetImmediately == nil then
--         IsSetImmediately = true
--     end
--     self.LastPercent = self.CurPercent
--     self.CurPercent  = Percent
--     self.DeductStartPercent = math.max(self.CurDeductPercent,self.LastPercent)
--     self:SetShieldCurDeductPercent(self.DeductStartPercent)
--     if IsSetImmediately then
--         self.Bar_Shield:SetPercent(Percent)
--         self.Bar_Shield_Invincibility:SetPercent(Percent)
--     end
-- end

-- function WBP_ShieldBar_C:SetShieldCurDeductPercent(Percent)
--     self.CurDeductPercent = Percent
--     -- print(_G.LogTag,"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa ",Percent)
--     if self.CanvaSlotOfSheildDeduct then
--         self.DeductImageSize.X = Percent * self.ShieldBarLength
--         self.DeductImageSize.Y =  self.CanvaSlotOfSheildDeduct:GetSize().Y
--         self.CanvaSlotOfSheildDeduct:SetSize(self.DeductImageSize)
--     end
-- end

-- function WBP_ShieldBar_C:GetShieldDeductPercent()
--     if not self.CurDeductPercent then
--         self.CurDeductPercent = 1.0
--     end
--     return self.CurDeductPercent
-- end

-- function WBP_ShieldBar_C:SetColor(IsEnemy)
--     -- if IsEnemy then
--     --     local Color = FSlateColor()
--     --     local LinearColor = UE4.UUIFunctionLibrary.StringToLinearColor("FF2A2AFF")
--     --     -- Color.SpecifiedColor.R = 0.904661
--     --     -- Color.SpecifiedColor.G = 0.371238
--     --     -- Color.SpecifiedColor.B = 0.042311
--     --     Color.SpecifiedColor = LinearColor
--     --     self.Shield_Deduct:SetBrushTintColor(Color)
--     --     self.Shield_Deduct:SetColorAndOpacity(FLinearColor(1.0,1.0, 1.0, 1.0))
--     -- end
-- end

-- function WBP_ShieldBar_C:PlayInvincibility(IsInvincibility)
--     if IsInvincibility then
--         -- self:StopAnimation(self.Bar_ShieldNormal)
--         -- self:PlayAnimation(self.Bar_ShieldInvincibility)
--         self.Bar_Shield_Invincibility:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--         self.Bar_Shield:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         self.Shield_Deduct:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         self.Bar_Shield_Invincibility:SetPercent(self.CurPercent)
--     else
--         -- self:StopAnimation(self.Bar_ShieldInvincibility)
--         -- self:PlayAnimation(self.Bar_ShieldNormal)
--         self.Bar_Shield_Invincibility:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         self.Bar_Shield:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--         -- self.Shield_Deduct:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--     end
-- end

-- function WBP_ShieldBar_C:ClearTimer()
--     if self:IsExistTimer("RealReduceShield") then
--         self:RemoveTimer("RealReduceShield")
--     end

--     if self:IsExistTimer("RealRecoveryShield") then
--         self:RemoveTimer("RealRecoveryShield")
--     end
-- end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

return WBP_ShieldBar_C
