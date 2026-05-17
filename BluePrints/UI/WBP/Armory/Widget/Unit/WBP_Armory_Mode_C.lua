--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_Mode_C
local M = Class({"BluePrints.Common.TimerMgr","BluePrints.UI.BP_EMUserWidget_C"})
local Unhandled = UE4.UWidgetBlueprintLibrary.Unhandled()


function M:Construct()
    --self.Button_Area.OnClicked:Clear()
    self.Button_Area.OnHovered:Clear()
    self.Button_Area.OnUnhovered:Clear()
    self.Button_Area.OnPressed:Clear()
    self.Button_Area.OnReleased:Clear()

    --self.Button_Area.OnClicked:Add(self, self.OnBtnClicked)
    self.Button_Area.OnHovered:Add(self, self.OnBtnHovered)
    self.Button_Area.OnUnhovered:Add(self, self.OnBtnUnhovered)
    self.Button_Area.OnPressed:Add(self, self.OnBtnPressed)
    self.Button_Area.OnReleased:Add(self, self.OnBtnReleased)
end

function M:BindEventOnMouseButtonDown(Obj,Event,Param)
    self.Obj = Obj
    self.Event = Event
    self.Param = Param
    self.Selected = false
end

function M:On(IsOn)
    self.Overridden.On(self,IsOn)
    self.Selected = IsOn
end

function M:OnBtnPressed()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_03", nil, nil)
    if self.Selected then return Unhandled end
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
    --鼠标按住0.2秒以上变为press
    local _,TimerKey = self:AddTimer(0.2,function() 
        self:StopAllAnimations()
        self:PlayAnimation(self.Press)
        self.PressTimerKey = nil
    end,false, 0, nil, true)
    self.PressTimerKey = TimerKey
end

function M:DeSelect()
    self.Obj.IsSelected = false
    self:PlayAnimation(self.Normal)
end

function M:OnBtnReleased() 
    self:StopAllAnimations()
    if(self.PressTimerKey) then --鼠标按住0.2秒内松开表示成功点击
        self:RemoveTimer(self.PressTimerKey,true)
        self.PressTimerKey = nil
        if(self.Event and self.Obj)then
            self.Event(self.Obj,self.Param)
            self.Selected = true
        end
    elseif (not self.Selected) then --鼠标按住超过0.2秒，松开回到Normal
        self:PlayAnimation(self.Normal)
    end
end

function M:OnBtnHovered(MyGeometry, MouseEvent)
    if self.Selected then return end
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
end

function M:OnBtnUnhovered(MouseEvent)
    if self.Selected then return end
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
end

return M
