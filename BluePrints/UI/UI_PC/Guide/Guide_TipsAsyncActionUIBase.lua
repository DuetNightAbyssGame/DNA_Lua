require "UnLua"

local Guide_TipsAsyncActionUIBase = Class({
    "BluePrints.UI.BP_UIState_C",
})

    -- TODO: 1. 同类Tip插进来时的逻辑处理
    --       2. OnTipBegin返回False导致后续C++注册的回调不能触发，看看怎么改
    -- @Tianyi
function Guide_TipsAsyncActionUIBase:OnTipBegin(Duration, Callback, InAnim, OutAnim) 
    if (Duration ~= nil and Duration <= 0) then return false end

    -- 一个Tip在显示的过程中，不允许同类Tip插进来
    if (self.IsShowing) then return false end
    self.IsShowing = true;
    self.IsTipEnd = false

    if(Duration ~= nil) then self:AddTimer(Duration, self.OnTipEnd) end
    self.Callback = Callback
    self.InAnim = InAnim
    self.OutAnim = OutAnim


    self:Show()
    if self.InAnim ~= nil then
        self:PlayAnimation(self.InAnim)
    end

    return true
end

function Guide_TipsAsyncActionUIBase:OnTipEnd()
    -- DebugPrint("---------------------------------------OnTipEnd------------------------------------------")
    if self.IsTipEnd then return end
    self.IsTipEnd = true
    if self.OutAnim then 
        self:BindToAnimationFinished(self.Out, {self, self.OnTipRealEnd})  
        self:PlayAnimation(self.Out)
    else 
        self:OnTipRealEnd()
    end
end

function Guide_TipsAsyncActionUIBase:OnTipRealEnd()
    -- DebugPrint("--------------------OnTipRealEnd----------------------")
    self:UnbindAllFromAnimationFinished(self.OutAnim)

    self:Hide()
    self.IsShowing = false

    -- 触发Lua侧回调
    if (self.Callback) then
        self:Callback()
    end

    -- 触发C++侧回调
    if self.OnGuideEnd:IsBound() then
        self.OnGuideEnd:Broadcast()
    end
end

return Guide_TipsAsyncActionUIBase