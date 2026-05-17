--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type Common_Scheme_Switching_Item_PC_C|TimerMgr
local M = Class({"BluePrints.Common.TimerMgr","BluePrints.UI.BP_EMUserWidget_C"})
local Unhandled = UE4.UWidgetBlueprintLibrary.Unhandled()

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

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
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
    return Unhandled
end

function M:DeSelect()
    self.Obj.IsSelected = false
    self:PlayAnimation(self.Normal)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent) 
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
    return Unhandled
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
    if self.Selected then return end
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
end

function M:OnMouseLeave(MouseEvent)
    if self.Selected then return end
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
end

return M
