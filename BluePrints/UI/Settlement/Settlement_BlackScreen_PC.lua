require "UnLua"

---@type Settlement_BlackScreen_PC_C
local Settlement_BlackScreen_PC_C = Class("BluePrints.UI.BP_UIState_C")

-- function Settlement_BlackScreen_PC_C:Initialize(Initializer)
-- end

-- function Settlement_BlackScreen_PC_C:PreConstruct(IsDesignTime)
-- end

-- function Settlement_BlackScreen_PC_C:Construct()
-- end

-- function Settlement_BlackScreen_PC_C:Tick(MyGeometry, InDeltaTime)
-- end

function Settlement_BlackScreen_PC_C:OnLoaded(...)
    self.bIsFocusable = true
    self.OnInAnimFinished = nil
    self.OnOutAnimFinished = nil
    local bShowFade, Callback, bIsWin = ...

    self:BindToAnimationFinished(self.In, function()
        if self.OnInAnimFinished then
            self.OnInAnimFinished()
        end
    end)

    self:BindToAnimationFinished(self.Out, function()
        local UIManager = GWorld.GameInstance:GetGameUIManager()
        UIManager:HideAllUI(false, Const.BlackScreenHideTag)
        if self.OnOutAnimFinished then
            self.OnOutAnimFinished()
        end
        self:Close()
    end)

    if bShowFade then
        self:FadeIn(Callback, bIsWin)
    end
end

function Settlement_BlackScreen_PC_C:FadeIn(OnInAnimFinished, bIsWin)
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.OnInAnimFinished = OnInAnimFinished

    AudioManager(self):PlayUISound(self, "event:/snapshot/ui/filter_fade_ui", "SettlementBlackScreen", nil)

    if bIsWin then
        AudioManager(self):PlayUISound(self, "event:/ui/common/level_end_success", nil, nil)
    else
        AudioManager(self):PlayUISound(self, "event:/ui/common/level_end_fail", nil, nil)
    end

    local Avatar = GWorld:GetAvatar()
    if Avatar:IsInHardBoss() then
        self:PlayAnimation(self.In, self.In:GetEndTime())  -- boss战不需要黑屏淡入
    else
        self:PlayAnimation(self.In)
    end
end

function Settlement_BlackScreen_PC_C:FadeOut(OnOutAnimFinished, bSkipOutAnim)
    AudioManager(self):StopSound(self, "SettlementBlackScreen")

    if bSkipOutAnim then
        OnOutAnimFinished()
    else
        self.OnOutAnimFinished = OnOutAnimFinished
        -- 应该是和改过关黑屏前置时机有关，这时调用HideAllUI, WBP_Battle_C还没加载
        -- 先按照延迟改吧
        self:AddTimer(0.1, function()
            local UIManager = GWorld.GameInstance:GetGameUIManager()
            UIManager:HideAllUI(true, Const.BlackScreenHideTag)
            self:Show(Const.BlackScreenHideTag)
        end)
        self:PlayAnimation(self.Out)
    end
end

return Settlement_BlackScreen_PC_C
