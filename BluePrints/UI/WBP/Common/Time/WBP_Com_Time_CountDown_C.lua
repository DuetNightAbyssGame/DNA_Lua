--
-- DESCRIPTION
-- 通用时间（动态计时） （PC、移动端公用）
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local M = Class("BluePrints.UI.BP_EMUserWidget_C")

---@param TextDesc string 时长标题
---@param TimeDict table<string, number> TimeType：类型（Day,Hour,Min,Sec）TimeValue：具体的数值
---@param TimeIconPath string 图标的路径（可选参数 - 不传则用默认图标）
function M:SetTimeText(TextDesc, TimeDict, TimeIconPath)
    self.Text_TimeTitle:SetText(TextDesc)
    local FinalResult = ""
    if TimeDict then 
        for TimeCount, ThisTimeInfo in ipairs(TimeDict) do
            if (TimeCount > 2) then
                DebugPrint("WBP_Com_Time SetTimeText TimeCount too much, 2 need but get more")
                break
            end
            FinalResult = string.format("%s%02d%s", FinalResult, ThisTimeInfo.TimeValue, GText("UI_GameEvent_TimeRemain_"..ThisTimeInfo.TimeType))
        end
    else
        FinalResult = "-"
    end
    self.Text_TimeDesc:SetText(FinalResult)

    if (TimeIconPath ~= nil) then
        UE.UResourceLibrary.LoadObjectAsync(self, TimeIconPath, {self, M.OnIconLoadFinished})
    end
end

---@param TextDesc string 时长标题
---@param TimeStrList table<string> 类型 (Day,Hour,Min,Sec)
---@param TimeIconPath string 图标的路径（可选参数 - 不传则用默认图标）
function M:SetEmptyTimeText(TextDesc, TimeStrList, TimeIconPath)
    self.Text_TimeTitle:SetText(TextDesc)
    local FinalResult = ""

    for Index, TimeStr in ipairs(TimeStrList) do
        if (Index > 2) then
            DebugPrint("WBP_Com_Time SetTimeText TimeCount too much, 2 need but get more")
            break
        end
        FinalResult = string.format("%s%s%s", FinalResult, "-", GText("UI_GameEvent_TimeRemain_"..TimeStr))
    end
    self.Text_TimeDesc:SetText(FinalResult)

    if (TimeIconPath ~= nil) then
        UE.UResourceLibrary.LoadObjectAsync(self, TimeIconPath, {self, M.OnIconLoadFinished})
    end
end

---@param TextDesc string 时长标题
---@param TimeIconPath string 图标的路径（可选参数 - 不传则用默认图标）
function M:SetForeverTimeText(TextDesc, TimeIconPath)
    self.Text_TimeTitle:SetText(TextDesc)
    self.Text_TimeDesc:SetText(GText("UI_EventTime_Permanent"))
    if (TimeIconPath ~= nil) then
        UE.UResourceLibrary.LoadObjectAsync(self, TimeIconPath, {self, M.OnIconLoadFinished})
    end
end

function M:OnIconLoadFinished(Object)
	if IsValid(self) then
		self.Image_ClockIcon:SetBrushResourceObject(Object)
	end
end

return M