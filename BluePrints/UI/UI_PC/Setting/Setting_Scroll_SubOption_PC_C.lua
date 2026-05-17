--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local SettingUtils = require "Utils.SettingUtils"
---@type WBP_Set_SubOptionScroll_C
local M = Class("BluePrints.UI.UI_PC.Setting.Setting_Scroll_Option_PC_C")

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:InitSubOption(Parent, CacheName, CacheInfo, UpOption)
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    rawset(self, "Parent", Parent.Content and Parent.Content.ParentWidget.Parent or Parent)
    rawset(self, "CacheName", CacheName)
    rawset(self, "CacheInfo", CacheInfo)
    rawset(self, "SlideMinValue", CacheInfo.ScrollNum[1])
    rawset(self, "SlideMaxValue", CacheInfo.ScrollNum[2])
    rawset(self, "ScrollMappingScale", CacheInfo.ScrollMappingScale)
    local SubOptionDefaultValueTemp = self:GetSubOptionDefaultValue()
    rawset(self, "SlideDefaultValue", SubOptionDefaultValueTemp[UpOption:GetOptionValue()] or 0)
    rawset(self, "NowValue", 1)
    rawset(self, "OldValue", 1)
    rawset(self, "LastValue", 1)
    rawset(self, "UpOption", UpOption)
    rawset(self, "UpOptionValue", UpOption:GetOptionValue())
    self.Text_Option:SetText(GText(self.CacheInfo.CacheText))
    self:SetHoverVisibility()
    self:SetOldValue()
    self.NowValue = self.OldValue
    self.LastValue = self.NowValue
    self:InitSliderConfig()
    self:UpdateSlide(self.NowValue)
    self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType(), UIUtils.UtilsGetCurrentGamepadName())
    self:UpdateUIStyleInPlatform(false)
    self:RefreshSubOptionState()
end

function M:GetSubOptionDefaultValue()
    if not self.CacheInfo.MobileSubOptionDefaultValue then
        return self.CacheInfo.SubOptionDefaultValue
    end
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return self.CacheInfo.MobileSubOptionDefaultValue
    else
        return self.CacheInfo.SubOptionDefaultValue
    end
end

function M:RefreshSubOptionList(UpOptionValue)
    self.UpOptionValue = UpOptionValue
    local SubOptionDefaultValueTemp = self:GetSubOptionDefaultValue()
    self.SlideDefaultValue = SubOptionDefaultValueTemp[UpOptionValue]
    self:RestoreDefaultOptionSet()
    self:RefreshSubOptionState()
end

--- 设置滑块控件状态
function M:SetSliderState(enabled)
    self.Com_Slider:SetEnabled(enabled)
    self.Com_Slider:ForbidMinOperation(not enabled)
    self.Com_Slider:ForbidAddOperation(not enabled)
    self.Com_Slider.Btn_Min.Button_Area:SetVisibility(not enabled and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.Visible)
    self.Com_Slider.Btn_Add.Button_Area:SetVisibility(not enabled and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.Visible)
end

function M:RefreshSubOptionState()
    if self.SlideDefaultValue == 0 then
        if self.IsForbidden then
            return
        end
        self.IsForbidden = true
        self:PlayAnimation(self.Forbidden)
        self.Text_Num:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Bg_Set.Bg_Hover:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Bg_Set.Bg_Outline:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self:SetSliderState(false)
    else
        self.IsForbidden = false
        self:PlayAnimationReverse(self.Forbidden)
        self.Text_Num:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Bg_Set.Bg_Hover:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Bg_Set.Bg_Outline:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self:SetSliderState(true)
    end
end

-----------------------采样方式 Sharpen-------------------------
function M:SetSharpenOldValue()
    local UpscalingMethod = self.UpOption.UpscalingMethod
    if UpscalingMethod == ESuperResolutionType.DLSS then
        self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.SlideDefaultValue / self.ScrollMappingScale) * self.ScrollMappingScale
    elseif UpscalingMethod == ESuperResolutionType.FSR then
        self.OldValue = SettingUtils.GetEMCache(self.EMCacheName, self.EMCacheKey, self.SlideDefaultValue / self.ScrollMappingScale) * self.ScrollMappingScale
    else
        self.OldValue = 0
    end
end

function M:SaveSharpenOptionSetting()
    if self.UpOption.UpscalingMethod == ESuperResolutionType.DLSS then
        USRMBlueprintLibrary.SetSharpnessForSRType(ESuperResolutionType.DLSS, self.NowValue / self.ScrollMappingScale)
        SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue / self.ScrollMappingScale)
    elseif self.UpOption.UpscalingMethod == ESuperResolutionType.FSR then
        USRMBlueprintLibrary.SetSharpnessForSRType(ESuperResolutionType.FSR, self.NowValue / self.ScrollMappingScale)
        SettingUtils.SaveEMCache(self.EMCacheName, self.EMCacheKey, self.NowValue / self.ScrollMappingScale)
    end
end


return M
