--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Set_SubOptionClick_C
local M = Class("BluePrints.UI.UI_PC.Setting.Setting_Click_Option_PC_C")

function M:InitSubOption(Parent, CacheName, CacheInfo, UpOption)
    rawset(self, "Parent", Parent)
    rawset(self, "CacheName", CacheName)
    rawset(self, "CacheInfo", CacheInfo)
    rawset(self, "IsOther", false)
    rawset(self, "UpOptionValue", UpOption:GetOptionValue())
    -- rawset(self, "DefaultValue", UpOption and CacheInfo.SubOptionDefaultValue[UpOption:GetDefaultValue()])
    if self.CacheInfo then
        self.DefaultValue = self.CacheInfo.DefaultValue
        if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
            if self.CacheInfo.DefaultValueM then
                self.DefaultValue = self.CacheInfo.DefaultValueM
            end
        end
    end
    self.Button_Area:SetVisibility(UE4.ESlateVisibility.Visible)
    self.Text_Fixed:SetRenderOpacity(1.0)
    self.IsOther = true
    self:InitOtherKeyText()
    self:RefreshSubOptionList(self.UpOptionValue)
    self:SetHoverVisibility()
end

function M:RefreshSubOptionList(UpOptionValue)
    self.UpOptionValue = UpOptionValue
    self:OnUpOptionValueChanged()
    --self:RestoreDefaultOptionSet()
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


return M
