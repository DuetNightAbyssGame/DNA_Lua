require "UnLua"

---@type WBP_Battle_Combo_P_C
---@type WBP_Battle_Combo_M_C
local M = Class("BluePrints.UI.BP_UIState_C")
local REFRESH_TIME = 0.016

function M:Initialize(Initializer)
    self.Super.Initialize(self)
    self.CurLevel = 0
    self.IsShowingCombo = false
end

function M:OnLoaded()
    self.Text_Combo:SetText(GText("BATTLE_COMBO_NAME"))
    self:Hide("BattleCombo")
end

function M:Tick(MyGeometry, InDeltaTime)
    if not self.IsShowingCombo then 
        return 
    end

    if self.IsPendingHide and not self:IsAnyAnimationPlaying() then 
        self:HideCombo()
    end
end

function M:OnBattleCountChanged(BeforeCount, BeforeLevel, CurCount, CurLevel, Reason)
    CurCount = CurCount or 0
    BeforeCount = BeforeCount or 0 
    
    if CurCount > 0 then 
        self:ShowCombo(BeforeCount, BeforeLevel, CurCount, CurLevel)
    else
        self:PendingHide(Reason)
    end
end

function M:ShowCombo(BeforeCount, BeforeLevel, CurCount, CurLevel)    
    self.CurLevel = CurLevel

    self.Text_ComboNum:SetText(CurCount)
    
    if CurLevel > BeforeLevel or CurCount > BeforeCount then 
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Add)
    end

    -- 需要更新等级标志
    if BeforeCount == 0 or CurLevel > BeforeLevel then 
        local ComboLevelText = self:GetComboLevelText(CurLevel)
        self.Text_Appraise:SetText(ComboLevelText)
        self.VX_Text_Appraise:SetText(ComboLevelText)
        self.VX_Text_Appraise_01:SetText(ComboLevelText)

        -- 更新颜色
        local Platform = CommonUtils.GetDeviceTypeByPlatformName(self)
        if (type(self["SetComboColorIn"..Platform]) == "function") then
            self["SetComboColorIn"..Platform](self, self["ComboLevelColor_"..CurLevel], self["ComboLightColor_"..CurLevel], self["ComboLevelMat_"..CurLevel]) 
        end
        if CurLevel == 4 then 
            self.VX_Light:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToLinearColor("FFEC7FFF"))
        end

        -- self:PlayAnimation(self.Change)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Change)
    end

    local NextLevelData = DataMgr.ComboLevel[CurLevel + 1]
    if NextLevelData then 
        self.Text_NextGear:SetText(NextLevelData.ComboCount)
    else 
        self.Text_NextGear:SetText(DataMgr.ComboLevel[CurLevel].ComboCount)
    end
    
    if not self.IsShowingCombo then
        self:StopAllAnimations() 
        -- self:PlayAnimation(self.In)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.In)
        self.IsShowingCombo = true
        self:Show("BattleCombo")
    end
end

function M:PendingHide(Reason)
    if self.IsPendingHide then return end
    if not self.IsShowingCombo then return end
    self.IsPendingHide = true
    self.HideReason = Reason
end

function M:HideCombo()
    self.IsShowingCombo = false
    self.IsPendingHide = false
    
    self:StopAnimation(self.In)
    self:StopAnimation(self.Change)

    if self.HideReason == UE4.EClearComboReason.SkillEffect then 

        self:SetConsumeColor(self["ComboConsumeColor_"..self.CurLevel])
        if self.CurLevel == 4 then 
            self.VX_01Line_3:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToLinearColor("FFEC7FFF"))
        end

        -- self:PlayAnimation(self.Used)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Used)
    else
        -- self:PlayAnimation(self.Out)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Out)

    end
end

function M:RealHideCombo()
    self.IsPendingHide = false
    self:Hide("BattleCombo")
end

function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.Out and not self.IsShowingCombo  then
        self:RealHideCombo()
    end
end

function M:SetComboColorInPC(ComboLevelColor, ComboLightColor, ComboLevelMat)
    local Font = self.VX_Text_Appraise.Font
    Font.FontMaterial = ComboLevelMat
    self.VX_Text_Appraise:SetFont(Font)

    self.VX_Img_Bg_2:SetColorAndOpacity(ComboLevelColor)
    self.VX_Light:SetColorAndOpacity(ComboLevelColor)

    self.VX_BgGlow:SetColorAndOpacity(ComboLightColor)
end

function M:SetComboColorInMobile(ComboLevelColor, ComboLightColor, ComboLevelMat)
    --- 目前和PC一致
    local Font = self.VX_Text_Appraise.Font
    Font.FontMaterial = ComboLevelMat
    self.VX_Text_Appraise:SetFont(Font)

    self.VX_Img_Bg_2:SetColorAndOpacity(ComboLevelColor)
    self.VX_Light:SetColorAndOpacity(ComboLevelColor)
    self.VX_BgGlow:SetColorAndOpacity(ComboLightColor)
end

function M:SetConsumeColor(ComboConsumeColor)
    local SlateColor=FSlateColor()
    SlateColor.SpecifiedColor=ComboConsumeColor
    self.VX_Text_Appraise_01:SetColorAndOpacity(SlateColor)
    self.VX_01Line:SetColorAndOpacity(ComboConsumeColor)
    self.VX_01Line_3:SetColorAndOpacity(ComboConsumeColor)
    self.VX_01Line_4:SetColorAndOpacity(ComboConsumeColor)
end


function M:SetComboHoldTimeProgress(Progress)
    local FontMt = self.VX_Text_Appraise:GetDynamicFontMaterial()
    if FontMt then 
        FontMt:SetScalarParameterValue("percent", Progress)
    end
end



function M:GetComboLevelText(Level)
    local Data = DataMgr.ComboLevel[Level]
    if Data then 
        return GText(Data.ComboLevelText)
    else 
        return "?"
    end
end

return M

