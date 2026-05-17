local Component = {}
--手搓的平滑滚动组件
-- 角度规范化函数
local ScreenPrint=function ()
    return DebugPrint
end
function Component:normalizeAngle(angle)
    angle = angle % 360
    if angle < 0 then angle = angle + 360 end
    return angle
end

-- 计算最短路径
function Component:shortestPath(from, to)
    from = self:normalizeAngle(from)
    to = self:normalizeAngle(to)
    
    local diff = to - from
    if math.abs(diff) > 180 then
        if diff > 0 then
            diff = diff - 360
        else
            diff = diff + 360
        end
    end
    return from + diff
end

-- ====================== 平滑滚动核心封装 ======================
function Component:luaSmoothAngle(currentAngle, targetAngle, deltaTime, speed,bIsDay)
    --ScreenPrint((bIsDay and "Day" or "Hour").."   "..  "luaSmoothAngleTaskStart: "..currentAngle.."→"..targetAngle)
    
    -- 使用最短路径计算目标角度
    local effectiveTarget = self:shortestPath(currentAngle, targetAngle)
    
    local newAngle = self:luaInterpTo(currentAngle, effectiveTarget, deltaTime, speed)
    local isStillSmoothing = not self:luaIsNearlyEqual(newAngle, effectiveTarget, 0.1)

    -- 规范化角度到0-360范围
    newAngle = self:normalizeAngle(newAngle)

    if isStillSmoothing or math.abs(newAngle - currentAngle) > 0.01 then
        if bIsDay then
            self:SetDayAngle(newAngle)
        else
            -- 应用小时限制
            --newAngle = self:ClampHourAngle(newAngle)
            self:SetHourAngle(newAngle)
        end
    end

    if not isStillSmoothing then
        newAngle = self:normalizeAngle(targetAngle) -- 确保最终角度正确
    end
    ScreenPrint("luaSmoothAngle: "..newAngle.."→"..targetAngle)
    return newAngle, isStillSmoothing
end

function Component:luaInterpTo(Current, Target, DeltaTime, Speed)
    local effectiveTarget = self:shortestPath(Current, Target)
    
    if math.abs(Current - effectiveTarget) < 0.01 then
        return self:normalizeAngle(Target)
    end
    local InterpFactor = 1 - math.exp(-Speed * DeltaTime)
    return Current + (effectiveTarget - Current) * InterpFactor
end

function Component:luaIsNearlyEqual(A, B, Epsilon)
    Epsilon = Epsilon or 0.1
    return math.abs(A - B) < Epsilon
end

function Component:luaClamp(Value, Min, Max)
    return math.max(Min, math.min(Value, Max))
end
-- ====================== 平滑滚动核心封装 end ======================

-- ====================== 统一平滑更新函数 ======================
function Component:SmoothUpdate(bIsDayList, targetAngle)
    if bIsDayList then
        self.TargetDayAngle = targetAngle
        self.bIsSmoothingDay = true
    else
        -- 应用小时限制
        --targetAngle = self:ClampHourAngle(targetAngle)
        self.TargetHourAngle = targetAngle
        self.bIsSmoothingHour = true
    end
end
-- ====================== 统一平滑更新函数 end ======================

-- Tick：处理平滑逻辑
function Component:Tick(MyGeometry, InDeltaTime)
    -- 1. 天列表平滑
    if self.bIsSmoothingDay then
        self.CurrentDayAngle, self.bIsSmoothingDay = self:luaSmoothAngle(
            self.CurrentDayAngle,
            self.TargetDayAngle,
            InDeltaTime,
            self.SmoothBaseSpeed,
            true
        )
    end

    -- 2. 小时列表平滑
    if self.bIsSmoothingHour then
        self.CurrentHourAngle, self.bIsSmoothingHour = self:luaSmoothAngle(
            self.CurrentHourAngle,
            self.TargetHourAngle,
            InDeltaTime,
            self.SmoothBaseSpeed,
            false
        )
    end

    if self.bEnableTimeFlow then
        self:TimeFlowTick(InDeltaTime)
    end
end

--代码模拟时间流动，从原来的时间到指定时间
function Component:TimeFlowTick(DeltaTime)
    -- 更新当前时间向目标时间流动
    if self.TimeFlowCurrentHour and self.TimeFlowTargetHour then
        -- 计算时间差值
        local diff = self.TimeFlowTargetHour - self.TimeFlowCurrentHour
        
        -- 如果已经接近目标时间，则停止流动
        if math.abs(diff) < 0.001 then
            self.bEnableTimeFlow = false
            self.TimeFlowCurrentHour = self.TimeFlowTargetHour
        else
            -- 根据DeltaTime调整时间变化速度
            local delta = diff * DeltaTime * self.TimeFlowSpeed
            self.TimeFlowCurrentHour = self.TimeFlowCurrentHour + delta
            
            -- 确保不会超过目标时间
            if (diff > 0 and self.TimeFlowCurrentHour > self.TimeFlowTargetHour) or
               (diff < 0 and self.TimeFlowCurrentHour < self.TimeFlowTargetHour) then
                self.TimeFlowCurrentHour = self.TimeFlowTargetHour
            end
        end
        
        -- 更新Text_TimeBlack显示
        if self.Text_TimeBlack then
            local hours = math.floor(self.TimeFlowCurrentHour)
            local minutes = math.floor((self.TimeFlowCurrentHour - hours) * 60)
            -- 0点显示为24点
            if hours == 0 then
                hours = 24
            end
            local formattedTime = string.format("%d:%02d", hours, minutes)
            self.Text_TimeBlack:SetText(formattedTime)
        end
    end
end

function Component:StartTimeFlow(CurrentHour, TargetHour, DeltaTime)
    -- 初始化时间流动参数
    self.TimeFlowCurrentHour = CurrentHour
    self.TimeFlowTargetHour = TargetHour
    self.TimeFlowSpeed = 1.0 / DeltaTime  -- 调整速度以在指定时间内完成
    self.bEnableTimeFlow = true
    
    -- 确保Text_TimeBlack存在
    if not self.Text_TimeBlack then
        -- 尝试从拥有该组件的视图中获取Text_TimeBlack
        -- 这需要在组件被添加到视图后才能正确工作
        print("Warning: Text_TimeBlack not found")
    end
end

return Component