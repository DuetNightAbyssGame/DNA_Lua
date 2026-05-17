--
-- DESCRIPTION
-- 通用时间（时区） （PC、移动端公用）
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local TimeUtils = require "Utils.TimeUtils"

local M = Class("BluePrints.UI.BP_EMUserWidget_C")

---@param Timestamp number 时间戳
---@param StyleType string 样式格式
---@param Joiner1 string 年月日连接符号
---@param Joiner2 string 时分秒连接符号
---@param bUserServerTimezone boolean 是否用服务器时区(可选参数 - 默认用设备的区时)
---@param bShowTimeIcon boolean 是否显示时间的Icon(可选参数 - 默认不显示)
---@param bHideTimeZone boolean 是否隐藏时区文本前缀(可选参数 - 默认显示)
function M:SetTimeText(Timestamp, StyleType, Joiner1, Joiner2, bUserServerTimezone, bShowTimeIcon, bHideTimeZone)
    -- 根据样式设置时间
    if (StyleType == UIConst.EnumTimeStyleType.YMDAndHMS) then
        local TimeYMDStr = TimeUtils.TimeToYMDStr(Timestamp, bUserServerTimezone, Joiner1)
        self.Text_Time:SetText(TimeYMDStr)
        self.Text_Time:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        local TimeHMSStr = TimeUtils.TimeToHMSStr(Timestamp, bUserServerTimezone, Joiner2)
        self.Text_ActualTime:SetText(TimeHMSStr) 
        self.Text_ActualTime:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    elseif (StyleType == UIConst.EnumTimeStyleType.YMD) then
        local TimeYMDStr = TimeUtils.TimeToYMDStr(Timestamp, bUserServerTimezone, Joiner1)
        self.Text_Time:SetText(TimeYMDStr)
        self.Text_Time:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Text_ActualTime:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    elseif (StyleType == UIConst.EnumTimeStyleType.HMS) then
        local TimeHMSStr = TimeUtils.TimeToHMSStr(Timestamp, bUserServerTimezone, Joiner2)
        self.Text_ActualTime:SetText(TimeHMSStr) 
        self.Text_ActualTime:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Text_Time:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    -- 前面的Icon
    if (bShowTimeIcon) then
        self.Image_ClockIcon:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    end
    -- 前面的时区文本
    if (bHideTimeZone) then
        self.Text_TimeZone:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        -- 获取时间的字符串
        local IsChina = UE.AHotUpdateGameMode.IsGlobalPak() == false
        if (not IsChina) then
            -- UTC时间转换
            local TimeZoneOffset = bUserServerTimezone and TimeUtils:GetServerTimeZone() or math.tointeger(TimeUtils:GetCurrentTimeZone())
            self.Text_TimeZone:SetText(string.format("(UTC+%d)", TimeZoneOffset))
            self.Text_TimeZone:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        else
            self.Text_TimeZone:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
    end
end

return M
