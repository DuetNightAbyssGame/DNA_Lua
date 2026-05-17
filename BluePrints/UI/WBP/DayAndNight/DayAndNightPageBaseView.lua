require "UnLua"

---@type WBP_DayAndNight_P_C
local M ={}
M._components = {"BluePrints.UI.WBP.DayAndNight.DayAndNightAnimationCompoment"}

local DayTextMap={
    [1]="UI_SetTime_Button_Today",      -- 第1天→310°
    [2]="UI_SetTime_Button_Tomorrow",   -- 第2天→330°
    [3]="UI_SetTime_Button_TheDayAfterTomorrow" -- 第3天→350°
}
-- 3个天项对应的目标角度（核心映射关系）
local DayTargetAngleMap = {310, 330, 350}
local ScreenPrint=function (str)
    return DebugPrint("yklua "..str)
end
---仅初始化lua变量时使用，千万不要有控件操作！！
function M:Initialize(Initializer)
    -- 当前世界时间
    self.CurrentHour=0
    self.IsWidgetInDay=true

    -- 选中时间
    self.SelectedDay=1  -- 默认选中第1天（对应310°）
    self.SelectedHour=1 -- 默认选中第1小时（对应0°）

    -- 交互灵敏度（调整滚轮/拖动的平滑速度）
    self.DayUIDragSpeed=100
    self.HourUIWheelSpeed=15
    self.HourUIDragSpeed=100
    self.DayUIWheelSpeed=20
    self.SmoothBaseSpeed=8.0    -- 基础平滑速度（拖动结束用）
    self.SmoothWheelSpeed=15.0  -- 滚轮平滑速度（更快，更灵敏）

    -- 昼夜时间区分（蓝图声明）
    -- self.DayStart=6
    -- self.DayEnd=18

    -- 初始角度（第1天310°）
    self.CurrentDayAngle=310
    self.CurrentHourAngle=0

    -- 平滑状态标记
    self.bIsSmoothingDay = false   
    self.bIsSmoothingHour = false  
    self.TargetDayAngle = 310       -- 天列表目标角度
    self.TargetHourAngle = 0        -- 小时列表目标角度

    --缓存的UI
    self.AllDayWidgets={}
    self.AllHourWidgets={}

    -- 当前时间对应的小时角度
    self.ReallyCurrentHourAngle = 0
end

function M:Construct()
    if not self.DayStart then self.DayStart = 6 end
    if not self.DayEnd then self.DayEnd = 18 end

    -- 按钮绑定
    self.Btn_Save.Button_Area.OnClicked:Add(self,self.OnClickChangeTime)
    self.Btn_Save:SetText(GText("UI_SetTime_Button_SetTime"))
    self.Text_TimeTitle:SetText(GText("UI_SetTime_CurrentTime"))

    -- 天列表交互（使用不同的回调函数）
    self.Slider_Day:BindScroolEvent(self,self.OnScrollDay, self.DayUIWheelSpeed)
    self.Slider_Day:BindDragEvent(self,self.OnDragDay, self.DayUIDragSpeed)
    self.Slider_Day:BindDragEndEvent(self,self.OnDragEndDay)  -- 使用专门的天列表回调

    -- 小时列表交互（使用不同的回调函数）
    self.Slider_Time:BindScroolEvent(self,self.OnScrollHour, self.HourUIWheelSpeed)
    self.Slider_Time:BindDragEvent(self,self.OnDragHour, self.HourUIDragSpeed)
    self.Slider_Time:BindDragEndEvent(self,self.OnDragEndHour) -- 使用专门的回调函数
end

function M:OnLoaded()
    self:InitBaseView()
    self:PlayInAnimation()
    AudioManager(self):PlayUISound(self, "event:/ui/common/time_panel_open", "DayAndNightPage", nil)
    local _ = ReddotManager.GetTreeNode("DayAndNight") or ReddotManager.AddNodeEx("DayAndNight")
    ReddotManager.ClearLeafNodeCount("DayAndNight")
end

-- 初始化UI项（天+小时)
function M:InitBaseView()
    -- 初始化天列表（3项）
    self.DynamicEntryBox_Day:Reset()
    for i=1,3 do
        local DayWidget=self.DynamicEntryBox_Day:BP_CreateEntry()
        self:InitDayWidget(DayWidget,i)
    end

    -- 初始化小时列表（24项）
    self.DynamicEntryBox_Time:Reset()
    for i=1,24 do
        local HourWidget=self.DynamicEntryBox_Time:BP_CreateEntry()
        self:InitHourWidget(HourWidget,i)
    end

    self:InitTime()
end
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
    return EnvironmentManager:GetTimeOfDay()
end

function M:InitTime() 
    local EnvironmentManager = self:GetEnvironmentManager()
    self.CurrentHour=EnvironmentManager.TimeOfDay 
    DebugPrint("yklua CurrentWorlfHour:"..self.CurrentHour) 

    local hours = math.floor(self.CurrentHour+0.50)
    local ExactTime=self:GetExactTimeOfDay()
    local formattedTime=self:GetTextFormHour(ExactTime)
    -- 计算当前时间对应的小时角度（内部仍用0-23表示）
    ScreenPrint("ExactTime:"..ExactTime)
    local NextHour=math.ceil(ExactTime)
    local NextHour = NextHour == 0 and 24 or NextHour
    self.ReallyCurrentHourAngle = self:GetAngleByHour(NextHour)
    ScreenPrint("ExactTime:"..NextHour)

    self:SetHourAngle(self.ReallyCurrentHourAngle)
    self:SetDayAngle(self.CurrentDayAngle)
    
    self.Text_TimeNow:SetText(formattedTime) 
    self.IsWidgetInDay=self:IsInDay()
    self:FreshSelectedDay()--刷新一下，清除上次代码的影响
end

function M:GetTextFormHour(Hour)
    -- 将小时格式从11.5转换为"11:30"，0点显示为24点
    local hours = math.floor(Hour)
    local minutes = math.floor((Hour - hours) * 60)
    
    -- 0点显示为24点
    if hours == 0 and Hour - hours==0 then
        hours = 24
    end
    
    local formattedTime = string.format("%d:%02d", hours, minutes)
    return formattedTime
end


-- 天项UI初始化
function M:InitDayWidget(DayWidget,Index)
    DayWidget.Index=Index
    local RealIndex=3-Index+1
    DayWidget.RealIndex=RealIndex
    local bInDay=self:IsInDay()
    DayWidget.Text_Select:SetText(GText(DayTextMap[RealIndex]))
    DayWidget.Text_Normal:SetText(GText(DayTextMap[RealIndex]))
    DayWidget.Night=not bInDay
    DayWidget:SetDayAndNight(bInDay)
    self.AllDayWidgets[RealIndex]=DayWidget
end

-- 小时项UI初始化
function M:InitHourWidget(HourWidget,Index)
    -- 25-Index：1->24, 2->23, ..., 24->1
    local Hour = 25 - Index+1
    if Hour > 24 then
        Hour=Hour-24
    end
    local bInDay=self:IsInDay()
    HourWidget.Index = Index
    HourWidget.Hour = Hour
    HourWidget:Init(Index, Hour, bInDay)
    HourWidget:SetDayAndNight(bInDay)
    self.AllHourWidgets[Hour] = HourWidget
end

-- ====================== 小时限制功能 ======================
-- 检查是否会发生跨天（不修改任何数据，仅用于判断）
function M:WillCrossDay(rawAngle)
    -- 检测是否会跨越0/360边界
    if rawAngle >= 352.5 and self.CurrentHourAngle < 352.5 and rawAngle - self.CurrentHourAngle < 180 then
        -- 从24:00+跨越到01:00，天数会加1
        return self.SelectedDay < 3
    elseif rawAngle <= 352.5 and self.CurrentHourAngle > 352.5 and self.CurrentHourAngle - rawAngle < 180 then
        -- 从01:00跨越到24:00，天数会减1
        return self.SelectedDay > 1
    end
    return false
end

-- 检查并限制小时角度
function M:ClampHourAngle(angle)
    -- 如果即将发生跨天，则不应用角度限制
    if self:WillCrossDay(angle) then
        return angle
    end
    
    if self.SelectedDay == 1 then -- 今天
        -- 不能选择今天当前时间之前的时间
        if angle < self.ReallyCurrentHourAngle  then
            ScreenPrint("Forbidden1, ClampHourAngle: "..self.ReallyCurrentHourAngle.."→"..352.5)
            return self.ReallyCurrentHourAngle
        end
    elseif  self.SelectedDay == 3 and not self.IsCrossing then -- 后天
        -- 不能选择后天24:00之后的时间（即360度之后）
        ScreenPrint("Forbidden3, self.CurrentHourAngle: "..self.CurrentHourAngle.."→angle"..angle)
        if angle > 350 and self.CurrentHourAngle<=350  then
            ScreenPrint("Forbidden2, ClampHourAngle: "..self.CurrentHourAngle.."Target: "..angle.." ".."→"..352.5)
            return 350
        end
    end
    
    return angle
end

-- 检测小时角度跨越并更新天数
function M:CheckHourCrossing(rawAngle)
    -- 检测是否跨越了0/360边界
    ScreenPrint("TryCheckHourCrossing: "..self.CurrentHourAngle .."→"..rawAngle)
    if (rawAngle >= 352.5 and self.CurrentHourAngle < 352.5 and rawAngle-self.CurrentHourAngle<180) or (self.CurrentHourAngle < 352.5 and self.CurrentHourAngle-rawAngle>180) then
        -- 从24:00+跨越到01:00，天数加1
        if self.SelectedDay < 3 then
            self:ChageSelectDay(self.SelectedDay + 1)
            self:SmoothUpdate(true, self:GetAngleByDayIndex(self.SelectedDay))
            ScreenPrint("前进---------------ReallkyCheckHourCrossing: "..self.CurrentHourAngle .."→"..rawAngle)
            self.IsCrossing = true
            self:AddTimer(0.1, function()
                ScreenPrint("Closssss")
                self.IsCrossing = false
            end, false, 0, "CrossingTimer")
            return true
        end
    elseif ((rawAngle <= 352.5 and self.CurrentHourAngle > 352.5) and self.CurrentHourAngle-rawAngle<180) or (rawAngle < 352.5 and rawAngle-self.CurrentHourAngle>180) then
        -- 从01:00跨越到24:00，天数减1
        if self.SelectedDay > 1 then
            self:ChageSelectDay(self.SelectedDay - 1)

            self:SmoothUpdate(true, self:GetAngleByDayIndex(self.SelectedDay))
            ScreenPrint("后退-------------------ReallkyCheckHourCrossing: "..self.CurrentHourAngle .."→"..rawAngle.."  "..self.CurrentHourAngle-rawAngle)
            self.IsCrossing = true
            self:AddTimer(0.1, function()
                ScreenPrint("Closssss")
                self.IsCrossing = false
            end, false, 0, "CrossingTimer")
            return true
        end
    end
    return false
end

-- 更新小时角度限制
function M:UpdateHourAngleLimit()
    ScreenPrint("UpdateHourAngleLimit: "..self.SelectedDay.."→"..self.ReallyCurrentHourAngle)
    if self.SelectedDay == 1 then -- 今天
        -- 如果当前小时角度小于今天的最小允许角度，则调整到最小允许角度
        if self.CurrentHourAngle < self.ReallyCurrentHourAngle then
            self:SmoothUpdate(false, self.ReallyCurrentHourAngle)
        end
    elseif self.SelectedDay == 3 then -- 后天
        -- 如果当前小时角度大于后天的最大允许角度，则调整到最大允许角度
        if self.CurrentHourAngle > 360 then
            self:SmoothUpdate(false, 360)
        end
    end
end
-- ====================== 小时限制功能 end ======================

-- ====================== 天列表交互 ======================
-- 天列表拖动事件（实时直接更新角度，无平滑）
function M:OnDragDay(Delta)
    local newAngle = self.CurrentDayAngle + Delta
    newAngle = self:luaClamp(newAngle, 310, 350)

    self:SetDayAngle(newAngle)

    self.bIsSmoothingDay = false
    ScreenPrint("OnDragDay: 实时角度→"..newAngle)
end

function M:SetDayAngle(Angle)
    self.CurrentDayAngle = Angle
    local FRadialBoxSetting = FRadialBoxSettings()
    FRadialBoxSetting.StartingAngle = Angle
    FRadialBoxSetting.SectorCentralAngle = 60
    self.DynamicEntryBox_Day:SetRadialSettings(FRadialBoxSetting)

    self:OnDayAngleChange(Angle)
end
function M:FreshSelectedDay()
    for i, v in pairs(self.AllDayWidgets) do
        local IsSelected = (i == self.SelectedDay)
        v.Switch_Text:SetActiveWidgetIndex(IsSelected and 1 or 0)
    end
end

function M:OnDayAngleChange(Angle)
    -- 可以在这里添加天角度变化时的处理逻辑
    if Angle == nil then
        Angle=self.CurrentDayAngle
    end
    local newSelectedDay = self:GetDayIndexByAngle(Angle)
    ScreenPrint("OnDayAngleChange: "..Angle .."Now  "..self.SelectedDay.."->>New  "..newSelectedDay)
    if newSelectedDay ~= self.SelectedDay and not self.IsCrossing then
        ScreenPrint("OnDayAngleChange:  ReallyChangeDay"..newSelectedDay)
        AudioManager(self):PlayUISound(self, "event:/ui/common/time_day_scroll", "DayAndNightPageDayChange", nil)
        self:ChageSelectDay(newSelectedDay)
    end
end
function M:ChageSelectDay(newSelectedDay)
    self.SelectedDay = newSelectedDay
    -- 更新UI显示
    self:FreshSelectedDay()
    -- 更新小时角度限制
    self:OnHourAngleChange() -- 天数变化，小时的状态也会变化，所以要重新更新
    self:UpdateHourAngleLimit()
end

-- 根据角度获取天索引
function M:GetDayIndexByAngle(Angle)
    -- 天列表只有3项，角度范围310°-350°，每项间隔20°
    local RelativeAngle = Angle - 310
    RelativeAngle = self:luaClamp(RelativeAngle, 0, 40)
    local targetIdx = math.floor((RelativeAngle + 10) / 20) + 1
    targetIdx = self:luaClamp(targetIdx, 1, 3)
    return targetIdx
end

-- 根据天索引获取角度
function M:GetAngleByDayIndex(Index)
    return DayTargetAngleMap[Index] or 310
end
    
-- 天列表滚轮事件（滚动时直接平滑，无需等待结束）
function M:OnScrollDay(Delta)
    -- 计算临时目标角度
    local tempTarget = self.CurrentDayAngle + Delta
    tempTarget = self:luaClamp(tempTarget, 310, 350)
    
    -- 确定应该指向哪个天项
    local targetIdx = self:GetDayIndexByAngle(tempTarget)
    
    -- 获取对应天项的精确角度
    local preciseAngle = self:GetAngleByDayIndex(targetIdx)
    
    -- 直接触发平滑到精确角度
    self:SmoothUpdate(true, preciseAngle)
    ScreenPrint(string.format("OnScrollDay: 平滑角度→%d°，第%d天", math.floor(self.CurrentDayAngle), targetIdx))
end

-- 天列表拖动结束事件
function M:OnDragEndDay()
    -- 天列表拖动结束后对齐最近项 
    local targetIdx = self:GetDayIndexByAngle(self.CurrentDayAngle)
    local targetAngle = self:GetAngleByDayIndex(targetIdx)
    
    self:SmoothUpdate(true, targetAngle)
    ScreenPrint(string.format("天列表拖动结束对齐：第%d天→%d°", targetIdx, targetAngle))
end
-- ====================== 天列表交互 end ======================

-- ====================== 小时列表交互 ======================
-- 小时列表拖动事件（实时平滑）
function M:OnDragHour(Delta)
    local rawAngle = self.CurrentHourAngle + Delta

    if not self.IsCrossing then
        rawAngle = self:ClampHourAngle(rawAngle)
    end
    -- 归一化角度 
    local newAngle = self:normalizeAngle(rawAngle)
    -- 如果没有跨越边界，应用小时限制
    DebugPrint("66",self.IsCrossing,self.CurrentHourAngle,rawAngle,newAngle)

    self:SetHourAngle(newAngle)
    self.bIsSmoothingHour = false
    ScreenPrint("OnDragHour: 实时角度→"..newAngle)
end

function M:SetHourAngle(Angle)
    local IsCross=self:CheckHourCrossing(Angle)
    self.CurrentHourAngle = Angle

    local FRadialBoxSetting = FRadialBoxSettings()
    FRadialBoxSetting.StartingAngle = Angle
    FRadialBoxSetting.SectorCentralAngle = 360
    self.DynamicEntryBox_Time:SetRadialSettings(FRadialBoxSetting)
    self:OnHourAngleChange(Angle)
end

function M:OnHourAngleChange(Angle)
    if Angle==nil then
        Angle=self.CurrentHourAngle
    end
    -- 可以在这里添加小时角度变化时的处理逻辑
    local NowHour = self:GetHourIndexByAngle(Angle)
    if NowHour ~= self.SelectedHour then
        AudioManager(self):PlayUISound(self, "event:/ui/common/time_hour_scroll", "DayAndNightPageHourChange", nil)
    end
    self.SelectedHour = NowHour
    
    -- 更新前后6个UI
    for i = -6, 6 do
        local ActiveWidgetIndex = 0
        local Hour = self.SelectedHour + i
        local bHide, blast
        if self.SelectedDay == 3 and Hour > 24 then
            bHide=true
        else
            bHide=false
        end
        if Hour < 1 then
            Hour = Hour + 24
            blast=true
        elseif Hour > 24  then
            Hour = Hour - 24
        end
        if self.CurrentHour==0 then
            self.CurrentHour=24
        end
        local HourWidget = self.AllHourWidgets[Hour]
        if bHide then
            HourWidget:SetVisibility(UIConst.VisibilityOp.Hidden)
        else
            HourWidget:SetVisibility(UIConst.VisibilityOp.Visible)
        end
        if (i < 0 and self.SelectedDay == 1 and (Hour<self.CurrentHour or  blast)) or (self.SelectedDay==2 and Hour<self.CurrentHour and i<0 and blast )    then
            --ScreenPrint("OnHourAngleChange: 隐藏"..Hour.." "..self.CurrentHour)
            ActiveWidgetIndex = 0
        elseif i == 0 then
            ActiveWidgetIndex = 1
        else
            ActiveWidgetIndex = 2
        end
        if HourWidget then
            HourWidget.Switch_Text:SetActiveWidgetIndex(ActiveWidgetIndex)
        else
            ScreenPrint("OnHourAngleChange: HourWidget is nil for Hour="..Hour)
        end
    end
end

-- 根据角度获取小时索引（返回1-24）
function M:GetHourIndexByAngle(Angle)
    local AnglePerHour = 15
    local NormalizedAngle = Angle % 360
    local targetIdx = math.floor((NormalizedAngle + AnglePerHour/2) / AnglePerHour) + 1
    if targetIdx > 24 then targetIdx = targetIdx - 24 end
    targetIdx = self:luaClamp(targetIdx, 1, 24)
    --ScreenPrint("GetHourIndexByAngle: "..Angle.."→"..targetIdx)
    return targetIdx
end

-- 根据小时索引获取角度（索引1-24对应0-345度）
function M:GetAngleByHour(Hour)
    -- Hour: 1-24 -> 0-345
    return (Hour - 1) * 15
end

-- 小时列表滚轮事件（滚动时直接平滑，无需等待结束）
function M:OnScrollHour(Delta)
    -- 计算临时目标角度
    local rawAngle = self.CurrentHourAngle + Delta

    -- -- 检测是否跨越了天数边界
    -- local crossed = self:CheckHourCrossing(rawAngle)
    rawAngle=self:ClampHourAngle(rawAngle)
    -- 归一化角度
    local tempTarget = self:normalizeAngle(rawAngle)

    -- 确定应该指向哪个小时
    local targetIdx = self:GetHourIndexByAngle(tempTarget)

    -- 获取对应小时的精确角度
    local preciseAngle = self:GetAngleByHour(targetIdx)

    -- 直接触发平滑到精确角度
    self:SmoothUpdate(false, preciseAngle)
    ScreenPrint(string.format("OnScrollHour: 平滑角度→%d°，第%d小时", math.floor(self.CurrentHourAngle), targetIdx))
end

-- 小时列表拖动结束事件
function M:OnDragEndHour()
    -- 小时列表拖动结束后对齐最近项
    local targetIdx = self:GetHourIndexByAngle(self.CurrentHourAngle)
    local targetAngle = self:GetAngleByHour(targetIdx)
    
    self:SmoothUpdate(false, targetAngle)
    ScreenPrint(string.format("小时列表拖动结束对齐：第%d小时→%d°", targetIdx, targetAngle))
end
-- ====================== 小时列表交互 end ======================

-- ====================== 其他原有逻辑 ======================
-- 判断是否处于白天
function M:IsInDay(Hour)
    Hour = Hour or self.CurrentHour
    -- 0点显示为24点
    if Hour == 0 then
        Hour = 24
    end
    return (Hour >= self.DayStart and Hour <= self.DayEnd)
end

--切换Day和HourUI的昼夜模式
function M:FreshDayNight()
    local OldIsInDay = self.IsWidgetInDay
    if OldIsInDay ~= self:IsInDay() then
        local NewIsInDay = self:IsInDay()
        for i,Widget in pairs(self.AllDayWidgets) do
            Widget:SetDayAndNight(NewIsInDay)    
        end
        for i,Widget in pairs(self.AllHourWidgets) do
            Widget:SetDayAndNight(NewIsInDay)
        end
        self.IsWidgetInDay = NewIsInDay
    end
end

-- 修改时间点击函数
function M:OnClickChangeTime()
    -- 将当前小时转换为1-24表示
    local currentHourDisplay = self.CurrentHour == 0 and 24 or math.floor(self.CurrentHour)
    AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_confirm", "DayAndNightPageBtnClick", nil)

    if self.SelectedDay == 1 and self.SelectedHour == currentHourDisplay then
        UIManager(self):ShowUITip("CommonToastMain", GText("UI_SetTime_Success"))
        return
    end

    -- 将1-24表示转换回0-23表示给引擎使用
    local hourToSet = self.SelectedHour == 24 and 0 or self.SelectedHour

    local EnvironmentManager = self:GetEnvironmentManager()
    EnvironmentManager:SetTimeOfDay(hourToSet, true, ESetTODReason.UISet)
    local CurrentText = self:GetTextFormHour(self.SelectedHour)
    -- 过渡动画相关

    local NowIsInDay = self.IsWidgetInDay
    local NewIsInDay = self:IsInDay(self.SelectedHour)

    local Animation
    local IsCrossDayNight = false
    if NowIsInDay and not NewIsInDay then
        Animation = self.DayToNight
        IsCrossDayNight = true
    elseif not NowIsInDay and NewIsInDay then
        Animation = self.NightToDay
        IsCrossDayNight = true
    elseif NowIsInDay and NewIsInDay then
        Animation = self.DayChange
    elseif not NowIsInDay and not NewIsInDay then
        Animation = self.NightChange
    end
    local FreshFunc = function()
        self.CurrentHour = hourToSet
        if IsCrossDayNight then
            self:FreshDayNight()
        end
        self.Text_TimeNow:SetText(CurrentText)
        self.ReallyCurrentHourAngle = self:GetAngleByHour(hourToSet == 0 and 24 or hourToSet)
        self:OnHourAngleChange()
        self:UpdateHourAngleLimit()
        local EndFunc = function()
            self:BlockAllUIInput(false)
        end
    end
    -- DebugPrint("self.IsWidgetInDay is"..self.IsWidgetInDay.." NowIsInDay:"..(NowIsInDay).." NewIsInDay:"..NewIsInDay  )
    self:AddTimer(0.1, FreshFunc)
    self.IsWidgetInDay = NewIsInDay
    DebugPrint("DatAndNight PlayingAnimation :" .. Animation:GetName() .. " FromHour:" .. self:GetExactTimeOfDay() ..
                   " ToHour:" .. self.SelectedHour)
    self:UnbindAllFromAnimationFinished(Animation)
    self:BindToAnimationFinished(Animation, {self, function()
        self:BlockAllUIInput(false)
    end})

    if self.SelectedDay > 1 then
        self:SmoothUpdate(true, self:GetAngleByDayIndex(1))
        self.IsCrossing = true
        self:AddTimer(0.5, function()
            self.IsCrossing = false
        end, false, 0, "CrossingTimer")
    end

    self.Text_TimeAfter:SetText(CurrentText)
    self:PlayAnimation(Animation)

    AudioManager(self):PlayUISound(nil, "event:/ui/common/time_panel_time_change", "DayAndNightPageTimeChange", nil)

    -- EMUIAnimationSubsystem:EMPlayAnimation(self, Animation)
    self:BlockAllUIInput(true,"SP_DisplayOnly")
    self:StartTimeFlow(self.CurrentHour, hourToSet, 1.0)
end


function M:PlayInAnimation()
    if self:IsInDay() then
        self:PlayAnimation(self.Day_In)
    else
        self:PlayAnimation(self.Night_In)
    end
end

function M:OnReturnKeyDown()
    if EMUIAnimationSubsystem:EMAnimationIsPlaying(self.Out) then
        return
    end 
    AudioManager(self):SetEventSoundParam(self, "DayAndNightPage", {
        ToEnd = 1
    })
    self:UnbindAllFromAnimationFinished(self.Out)
    self:BindToAnimationFinished(self.Out,{self,self.Close})
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Out)
end

-- function M:OnAnimationStarted(Animation)
--     ScreenPrint("正在播放动画"..Animation:GetName())
-- end

AssembleComponents(M)
return M
