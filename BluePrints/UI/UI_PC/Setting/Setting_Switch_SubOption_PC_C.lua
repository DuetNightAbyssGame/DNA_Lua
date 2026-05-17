--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local SettingUtils = require "Utils.SettingUtils"

---@type WBP_Set_SubOptionSwitch_C
local M = Class("BluePrints.UI.UI_PC.Setting.Setting_Switch_OptionBase_PC_C")

function M:InitSubOption(Parent, CacheName, CacheInfo, UpOption)
    rawset(self, "Parent", Parent)
    rawset(self, "CacheName", CacheName)
    rawset(self, "CacheInfo", CacheInfo)
    rawset(self, "HasBeenForbidden", false)
    rawset(self, "UpOptionValue", UpOption:GetDefaultValue())
    rawset(self, "DefaultValue", self:GetValue() == 2)
    rawset(self, "SubListOffset", 15)--下拉列表偏移
    rawset(self, "NowValue", true)
    rawset(self, "OldValue", true)
    rawset(self, "UpOption", UpOption)
    rawset(self, "UpOptionValue", UpOption:GetOptionValue())
    self.Text_Option:SetText(GText(self.CacheInfo.CacheText))
    self:SetOldValue()
    self:SetHoverVisibility()
    self:PlaySwitchAnimation(self.OldValue)
    self:RefreshSubOptionState()
    self.NowValue = self.OldValue
    self.Text_Close:SetText(GText(self.CacheInfo.SwitchText[1]))
    self.Text_Open:SetText(GText(self.CacheInfo.SwitchText[2]))
end

function M:IsCloseOption()
    return self:GetValue() == 0
end

function M:RefreshSubOptionState()
    if self:GetValue() == 0 then
        if not self.HasBeenForbidden then
            self:PlayAnimation(self.Forbidden)
            self.Button_Area:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Bg_Set.Bg_Hover:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Bg_Set.Bg_Outline:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.HasBeenForbidden = true
        end
    elseif self.HasBeenForbidden then
        self:PlayAnimationReverse(self.Forbidden)
        self.Button_Area:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Bg_Set.Bg_Hover:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Bg_Set.Bg_Outline:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.HasBeenForbidden = false
    end
end

function M:GetValue()
    local SubOptionDefaultValueTemp = self:GetSubOptionDefaultValue()
    local Value = SubOptionDefaultValueTemp[SettingUtils.GetUpValueByValueType(self.UpOptionValue)]
    return Value
end

function M:RestoreDefaultOptionValue()
    local Value = self:GetValue()
    self.NowValue = Value == 2
    self.OldValue = self.NowValue
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
    self:RestoreDefaultOptionSet()
    self:RefreshSubOptionState()
end

-----------------------光线追踪相关 RayTracingReflect-------------------------
function M:SetRayTracingReflectOldValue()
    if not SettingUtils.IsOpenRayTracing() then
        return
    end
    if self:IsCloseOption() then
        self.OldValue = false
    else
        self.OldValue = UE4.URuntimeCommonFunctionLibrary.GetRayTracingReflectionsEnabled()
    end
end

function M:RestoreDefaultRayTracingReflectOptionSet()
    self:SaveRayTracingReflectOptionSetting()
end

function M:SaveRayTracingReflectOptionSetting()
    if not SettingUtils.IsOpenRayTracing() then
        return
    end
    UE4.URuntimeCommonFunctionLibrary.SetRayTracingReflectionsEnabled(self.NowValue)
end

-----------------------光线追踪相关 RayTracingGlobalLight-------------------------
function M:SetRayTracingGlobalLightOldValue()
    if not SettingUtils.IsOpenRayTracing() then
        return
    end
    if self:IsCloseOption() then
        self.OldValue = false
    else
        self.OldValue = UE4.URuntimeCommonFunctionLibrary.GetRayTracingGIEnabled()
    end
end

function M:RestoreDefaultRayTracingGlobalLightOptionSet()
    self:SaveRayTracingGlobalLightOptionSetting()
end

function M:SaveRayTracingGlobalLightOptionSetting()
    if not SettingUtils.IsOpenRayTracing() then
        return
    end
    UE4.URuntimeCommonFunctionLibrary.SetRayTracingGIEnabled(self.NowValue)
end

-----------------------光线追踪相关 RayTracingShadow-------------------------
function M:SetRayTracingShadowOldValue()
    if not SettingUtils.IsOpenRayTracing() then
        return
    end
    if self:IsCloseOption() then
        self.OldValue = false
    else
        self.OldValue = UE4.URuntimeCommonFunctionLibrary.GetRayTracingShadowsEnabled()
    end
end

function M:RestoreDefaultRayTracingShadowOptionSet()
    self:SaveRayTracingShadowOptionSetting()
end

function M:SaveRayTracingShadowOptionSetting()
    if not SettingUtils.IsOpenRayTracing() then
        return
    end
    UE4.URuntimeCommonFunctionLibrary.SetRayTracingShadowsEnabled(self.NowValue)
end

return M
