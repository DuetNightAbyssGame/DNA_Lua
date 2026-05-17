--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Dungeon_SurvivalLowSerum_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:ShowOrHideByAnim(bShow)
    if bShow ~= self.bShow then
        if bShow then
            self.Root:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self:StopAllAnimations()
            self:PlayAnimation(self.In)
        else
            self:StopAllAnimations()
            self:UnbindAllFromAnimationFinished(self.Out)
            self:BindToAnimationFinished(self.Out,{self,function ()
                self.Root:SetVisibility(ESlateVisibility.Collapsed)
            end})
            self:PlayAnimation(self.Out)
        end
    end
    self.bShow = bShow
end

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

-- function M:OnLoaded(...)
--     M.Super.OnLoaded(self, ...)
--     self.SkipTick = true
--     self.NiagaraFadeIn = nil -- 当前状态是淡入还是淡出
--     self.SpendTime = 0
-- end

-- function M:Tick(MyGeometry, InDeltaTime)
--     if self.SkipTick or self.NiagaraFadeIn == nil then
--         return
--     end
--     self.SpendTime = self.SpendTime + InDeltaTime
--     local Rate = self.SpendTime / 0.2
--     local NewOpacity = self.NiagaraFadeIn and Rate or 1.0 - Rate
--     UUIFunctionLibrary.SetNiagaraWidgetMaterialOpacity(self.VX_Par01,NewOpacity)
--     UUIFunctionLibrary.SetNiagaraWidgetMaterialOpacity(self.VX_Par02,NewOpacity)
--     -- self.VX_Par01:ActivateSystem(true)
--     -- self.VX_Par02:ActivateSystem(true)
--     local PrintOpacity = function(NiagarWidget)
--         local Mats = NiagarWidget.MaterialRemapList:ToTable()
--         for k,v in pairs(Mats) do
--             DebugPrint("WPS__ PrintMatOpacity ",NiagarWidget:GetName(),v:K2_GetScalarParameterValue("Opacity"))
--         end
--     end
--     PrintOpacity(self.VX_Par01)
--     PrintOpacity(self.VX_Par02)
--     if self.SpendTime > 0.2 then
--         self.SkipTick = true
--         self.SpendTime = 0
--         if not self.NiagaraFadeIn then
--             self.Root:SetVisibility(ESlateVisibility.Collapsed)
--         end
--     end
-- end

-- function M:SetNiagaraFadeInOrOut(FadeIn)
--     if FadeIn == nil or FadeIn == self.NiagaraFadeIn then
--         return
--     end
--     self.NiagaraFadeIn = FadeIn
--     self.SkipTick = false
--     self.SpendTime = 0
-- end
--function M:Destruct()
--end

return M
