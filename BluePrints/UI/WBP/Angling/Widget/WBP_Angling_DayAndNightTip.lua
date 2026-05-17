--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Angling_DayAndNightTip_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:GetEnvironmentManager()
    if self.EnvironmentManager and IsValid(self.EnvironmentManager) then
        return self.EnvironmentManager
    else
        self.EnvironmentManager=UE4.UGameplayStatics.GetActorOfClass(self,UE4.AEnvironmentManager:StaticClass()) 
        return self.EnvironmentManager
    end
end

function M:GetExactTimeOfDay()
    local EnvironmentManager = self:GetEnvironmentManager()
    local HalfHourSeconds = DataMgr["GlobalConstant"].TODUnitTime.ConstantValue / 2
    local RemainHalfHourTime = EnvironmentManager:GetRemainTODHalfHourTime()
    if HalfHourSeconds and RemainHalfHourTime then
        self.ExactHour = EnvironmentManager:GetTimeOfDay()
        local Text = self:GetTextFormHour(self.ExactHour)
        return Text, self.ExactHour
    else
        local Hour = EnvironmentManager:GetTimeOfDay()
        local Text = self:GetTextFormHour(Hour)
        return Text, Hour
    end
end

function M:GetTextFormHour(Hour)
    -- 将小时格式从11.5转换为"11:30"，0点显示为24点
    local hours = math.floor(Hour)
    local minutes = math.floor((Hour - hours) * 60)

    local formattedTime = string.format("%d:%02d", hours, minutes)
    return formattedTime, Hour
end

function M:GetEnableTimeElapse()
    local EnvironmentManager = self:GetEnvironmentManager()
    return EnvironmentManager:GetEnableTimeElapse()
end

function M:ChangeTag(Hour, bInit)
    local Type = 0
    if Hour >= 4 and Hour <= 12 then
        Type = 0
    elseif Hour > 12 and Hour <= 20 then
        Type = 1
    else
        Type = 2
    end
    if not self.HourType or Type ~= self.HourType then
        self.HourType = Type
        self.Tag_DayAndNight.TimeType = Type
        if not bInit then
            self.Tag_DayAndNight:PlayAnimation(self.Tag_DayAndNight.Change)
        else
            self.Tag_DayAndNight.WS_DayAndNight:SetActiveWidgetIndex(Type)
        end
    end
end

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Init()
    if not self:GetEnableTimeElapse() then
        self:SetVisibility(ESlateVisibility.Collapsed)
    end
    local Text, Hour = self:GetExactTimeOfDay()
    self:ChangeTag(Hour, true)
    self.Text_CurrentTime:SetText(GText("UI_SetTime_CurrentTime"))
end

function M:Tick(MyGeometry, InDeltaTime)
    local Text, Hour = self:GetExactTimeOfDay()
    self:ChangeTag(Hour)
    self.Text_Time:SetText(Text)
end

--function M:Destruct()
--end


return M
