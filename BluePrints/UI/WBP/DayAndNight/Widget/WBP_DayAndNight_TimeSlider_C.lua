--[[
Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
Date: 2025-09-08 16:14:15
LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
LastEditTime: 2025-09-22 14:22:44
FilePath: \EM\Content\Script\BluePrints\UI\WBP\DayAndNight\Widget\WBP_DayAndNight_TimeSlider_C.lua
Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
--]]
--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_DayAndNight_TimeSlider_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
local ScreenPrint=function ()--
    return DebugPrint
end
local Unhandled=UE4.UWidgetBlueprintLibrary.Handled()
---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Slider_Time.OnValueChanged:Add(self,self.OnValueChanged)
    self.Slider_Time.OnMouseCaptureBegin:Add(self,self.OnMouseCaptureBegin)
    self.Slider_Time.OnMouseCaptureEnd:Add(self,self.OnMouseCaptureEnd)
    self.CurrentValue=0
    self.PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self)
    self.IsMobile = self.PlatformName == "Mobile"
    self.IsPC = self.PlatformName == "PC"
    --self.IsEditor = URuntimeCommonFunctionLibrary.IsPlayInEditor(self)
end
--绑定鼠标滚动事件
function M:BindScroolEvent(obj,callback,speed)
    self.ScroolEventObj=obj
    self.ScroolEvent=callback
    self.ScroolSpeed=speed or 1
end

--绑定拖动事件
function M:BindDragEvent(obj,callback,speed)
    self.DragEventObj=obj
    self.DragEvent=callback
    self.DragSpeed=speed or 1
end

function M:BindDragEndEvent(obj,callback,bIsDay)
    self.DragEndEventObj=obj
    self.DragEndEvent=callback
    self.bIsDay=bIsDay or false
end

function M:Tick(MyGeometry, InDeltaTime)
    ScreenPrint("DayAndNight_TimeSlider_C:Tick")
end

--交互相关
function M:OnMouseWheel(MyGeometry, MouseEvent)
    local WheelDelta = UE4.UKismetInputLibrary.PointerEvent_GetWheelDelta(MouseEvent)*-1
    ScreenPrint("DayAndNight_TimeSlider_C:OnMouseWheelScroll"..WheelDelta)
    if self.ScroolEvent then
        self.ScroolEvent(self.ScroolEventObj,WheelDelta*self.ScroolSpeed)
    end
    return Unhandled
end

function M:OnValueChanged(Value)
    if self.IsMobile then
        --在编辑器中移动端模式有问题，硬编码处理一些
        if self.DragStart then
            self.DragEvent(self.ScroolEventObj, (Value - self.CurrentValue) * self.DragSpeed)
            self.CurrentValue = Value
        end 
    else
        if self.DragStart then
            self.CurrentValue = Value
            self.DragStart = false
        else
            self.DragEvent(self.ScroolEventObj, (Value - self.CurrentValue) * self.DragSpeed)
            self.CurrentValue = Value
        end
    end
end

function M:OnMouseCaptureBegin()
    DebugPrint("DayAndNight_TimeSlider_C:OnMouseCaptureBegin")
    if self.DragStart==false then
        self.CurrentValue=self.Slider_Time:GetValue()
        self.DragStart=true
    end
end

function M:OnMouseCaptureEnd()
    DebugPrint("DayAndNight_TimeSlider_C:OnMouseCaptureEnd")
    if self.DragEndEvent then
        self.DragEndEvent(self.DragEndEventObj,self.bIsDay)
    end
    self.DragStart=false
end
--function M:Destruct()
--end


return M
