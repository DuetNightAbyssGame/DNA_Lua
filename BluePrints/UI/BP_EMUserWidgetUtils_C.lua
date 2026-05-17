-- @note BP_EMUserWidget_C 的工具类，将原本UIState中的工具方法迁移到此
-- @note 非系统级的UI控件应该继承EMUserWidget并使用该组件
local M = Class({"BluePrints.Common.StageTimerMgr",})

--region 构造
function M:Initialize(Initializer)
    rawset(self, "ListenEvent",{})              -- 监听的事件
end

--region 事件管理
-- 添加监听
function M:AddDispatcher(EventName, Obj, Func)
    if (type(Func) ~= "function") then
        return
    end
    if (EventID[EventName] == nil) then
        return
    end
    -- 确保有ListenEvent表
    if not self.ListenEvent then
        self.ListenEvent = {}
    end
    EventManager:AddEvent(EventName, Obj, Func)
    self.ListenEvent[EventName] = Obj
end

-- 移除监听
function M:RemoveDispatcher(EventName)
    if not self.ListenEvent or (self.ListenEvent[EventName] == nil) then
        return
    end
    EventManager:RemoveEvent(EventName, self.ListenEvent[EventName])
    -- 既然移除监听了，对Obj的引用应该也需要断开
    self.ListenEvent[EventName] = nil
end

-- 移除所有监听
function M:RemoveAllDispatcher()
    if rawget(self, "ListenEvent") then
        for k,v in pairs(self.ListenEvent) do
            EventManager:RemoveEvent(k, v)
        end 
    end
    
    -- 清理输入方法变更监听（如果存在的话）
    if self.RemoveInputMethodChangedListen and type(self.RemoveInputMethodChangedListen) == "function" then
        self:RemoveInputMethodChangedListen()
    end
    self.ListenEvent = {}
end
--endregion

--region 输入设备管理

--输入设备变更通知，子类可以重写该方法
---@param CurInputDevice number 枚举ECommonInputType
---@param CurGamepadName string 手柄的名称
function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Gamepad) then
        -- 切换手柄输入模式的一些通用逻辑可以写在这
        if (self.CheckNeedAutoFocusWithInputType and self:CheckNeedAutoFocusWithInputType())then
            DebugPrint("BP_EMUserWidgetUtils_C RefreshOpInfoByInputDevice, Change to Gamepad Input And Auto Focus, UIName is", self.WidgetName or self:GetName())
            if (type(self.SetFocus_Lua) == "function") then
                self:SetFocus_Lua()
            else
                self:SetFocus()
            end
        end
    elseif (CurInputDevice == ECommonInputType.Touch) then
        -- TODO 切换触控输入模式的一些通用逻辑可以写在这
    end
    self:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
end

-- 根据当前输入方式更新界面的样式
function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    -- 根据当前输入方式更新界面的样式，子类重写该方法
end

-- 添加输入方式变更监听
function M:AddInputMethodChangedListen()
    if (IsValid(self) and self.GameInputModeSubsystem ~= nil) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice) 
    end
end

-- 移除输入方式变更监听
function M:RemoveInputMethodChangedListen()
    if (IsValid(self) and self.GameInputModeSubsystem ~= nil) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice) 
    end
end

function M:CheckNeedAutoFocusWithInputType()
    local TopUIWidget = UIManager(self):GetWidgetObjInTopStack()
    local LastestCreateWidget = UIManager(self):GetLastestAndFocusableUIWidgetObj()
    if (self == TopUIWidget and self == LastestCreateWidget) then
        return true
    else
        return false
    end
end
--endregion

--region 定时器

--- 绝大多数情况下,系统面板的UI的定时器默认是不受时间膨胀影响的，所以UI默认IsRealTime为true
-- function M:AddTimer(Interval, Func, IsLoop, Delay, Key, IsRealTime, ...)
--     if IsRealTime == nil then IsRealTime = true end
--     -- 调用父类的StageTimerMgr的AddTimer方法
--     if self.Super and self.Super.AddTimer then
--         return self.Super.AddTimer(self, Interval, Func, IsLoop, Delay, Key, IsRealTime, UE4.ETickingGroup.TG_EndPhysics, ...)
--     else
--         -- 没有继承StageTimerMgr
--         DebugPrint("Error: AddTimer requires StageTimerMgr component. Please inherit from StageTimerMgr.")
--         return nil
--     end
-- end
function M:AddTimer(Interval, Func, IsLoop, Delay, Key, IsRealTime, ...)
    if (type(Func) ~= "function") then 
        DebugPrint(ErrorTag, "::Error::  EMUserWidget=AddTimer 异常，回调函数传入非法, UIName is", self.WidgetName or self:GetName())
        return 
    end
    if IsRealTime == nil then IsRealTime = true end
    return M.Super.AddTimer(self, Interval, Func, IsLoop, Delay, Key, IsRealTime, UE4.ETickingGroup.TG_EndPhysics, ...)
end

-- 清理定时器
-- function M:CleanTimer()
--     -- 调用父类的StageTimerMgr的CleanTimer方法
--     if self.Super and self.Super.CleanTimer then
--         -- self.Super.CleanTimer(self)
--     else
--         -- 没有继承StageTimerMgr
--         DebugPrint("Error: CleanTimer requires StageTimerMgr component.")
--     end
-- end
--endregion

--region Widget工具

-- 获取相对坐标
function M:GetPosition(Widget)
    -- 获取Widget的相对坐标
    local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(Widget)
    if (CanvasSlot ~= nil) then
        return CanvasSlot:GetPosition()
    end
end

-- 设置相对坐标
function M:SetPosition(Widget, Pos)
    -- 设置Widget的相对坐标
    local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(Widget)
    if (CanvasSlot ~= nil) then
        return CanvasSlot:SetPosition(Pos)
    end
end

--endregion

--region 通用工具

-- 获取精确的小数
function M:GetPreciseDecimal(nNum, n)
    if type(nNum) ~= "number" then
        return nNum
    end
    n = n or 0
    n = math.floor(n)
    if n < 0 then
        n = 0
    end
    local nDecimal = 10 ^ n
    local nTemp = math.floor(nNum * nDecimal)
    local nRet = nTemp / nDecimal
    return nRet
end

-- 获取时间字符串
function M:GetTimeStr(DeltaTime)
    local TimeStr = ""
    local h = math.modf(DeltaTime / 3600)
    local m = math.modf((DeltaTime - h * 3600) / 60)
    local s = math.modf(DeltaTime - h * 3600 - m * 60)
    if (h == 0) then
        TimeStr = ""
    elseif (h < 10) then
        TimeStr = TimeStr.."0"..tostring(h)..":"
    else
        TimeStr = TimeStr..tostring(h)..":"
    end
    if (m < 10) then
        TimeStr = TimeStr.."0"..tostring(m)
    else
        TimeStr = TimeStr..tostring(m)
    end
    TimeStr = TimeStr..":"
    if (s < 10) then
        TimeStr = TimeStr.."0"..tostring(s)
    else
        TimeStr = TimeStr..tostring(s)
    end
    return TimeStr
end

-- 更新ListView滚动倍率
function M:UpdateListViewScrollMultiplier(ListViewObj, NewWheelScrollMultiplier)
    if (ListViewObj == nil) then
        return 
    end
    ListViewObj:SetWheelScrollMultiplier(NewWheelScrollMultiplier)
end
--endregion

--主要是接入一下自动清理timer
function M:ClearScriptRegister()
    self:CleanTimer()---应该考虑清理定时器，否则有些匿名定时器可能还在跑，会有意想不到的trace
    self:RemoveAllDispatcher()
     ---红点监听保底清空
     if self.ReddotNodeIns and ReddotManager then
        ReddotManager.RemoveListener(self.ReddotNodeIns.Name, self)
    end
end

function M:Destruct()
    DebugPrint("BP_EMUserWidgetUtils_C Destruct, 父类Destruct逻辑已经迁移, 子类可以不需要再调用Super方法 UIName is", self.WidgetName or self:GetName())
end

function M:CreateWidgetNew(UIName, ...)
    return UIManager(self):_CreateWidgetNew(UIName)
end

---异步加载子蓝图
---@param UIName string 子蓝图名称
---@param CoroutineOrCBFunc function|thread 协程或者回调函数
---@return UUserWidget 注意，如果参数传的回调函数，返回值始终是nil，UI要在回调函数的参数里取
function M:CreateWidgetAsync(UIName,CoroutineOrCBFunc, ... )
    return UIManager(self):CreateWidgetAsync(UIName,CoroutineOrCBFunc, ...)
end

-- 加载UI
function M:LoadUINew(UIName, ...)
    return UIManager(self):LoadUINew(UIName, ...)
end

return M