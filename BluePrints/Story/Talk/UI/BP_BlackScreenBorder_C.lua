--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
---@type BP_BlackScreenBorder_C
local M = Class({"BluePrints.Common.TimerMgr","BluePrints.UI.BP_EMUserWidget_C"})

-- function M:Initialize(Initializer)
-- end

-- function M:PreConstruct(IsDesignTime)
-- end

-- function M:Construct()
-- end

-- function M:Tick(MyGeometry, InDeltaTime)
-- end

function M:Construct()
    ---@type boolean
    self.bPaused = false
    self.FadeInCallback=nil
    self.FadeOutCallback =nil

    ---@type boolean
    self.bFadeIn = false
    ---@type boolean
    self.bFadeOut = false
    ---@type number
    self.FadeTime = 0
    ---@type number
    self.PausePosition = nil

    self:SetToTransparent()
end


---@param FadeTime number
---@param Callback table
function M:FadeIn(FadeTime,Callback)
    DebugPrint("BP_BlackScreenBorder_C:StartFadeIn", "BlendInTime:", FadeTime, "FrameCount:", UKismetSystemLibrary.GetFrameCount(), self)
    self.bPaused = false
    self.FadeTime = FadeTime
    self.FadeInCallback = Callback

    if FadeTime <= 0 then
        -- FadeTime小于等于0时，代表瞬切
        self:SetToBlack()
        self:OnFadeInFinished()
    else
        -- 其余情况，正常FadeIn
        self.bFadeIn = true
        local AnimationTime = self.AlphaChange:GetEndTime()
        self:BindToAnimationFinished(self.AlphaChange, {self, function()
            self.bFadeIn = false
            self:UnbindAllFromAnimationFinished(self.AlphaChange)
            self:OnFadeInFinished()
        end})
        self:DestroyAllAnmations()
        self:PlayAnimation(self.AlphaChange, 0, 1, EUMGSequencePlayMode.Forward, AnimationTime/FadeTime)
    end

    -- 开始播放屏蔽用音效
    AudioManager(self):PlayUISound(self, "event:/snapshot/ui/filter_fade_ui", "BlackScreenBorder", nil)
end

---@param FadeTime number
---@param Callback table
function M:FadeOut(FadeTime,Callback)
    DebugPrint("BP_BlackScreenBorder_C:StartFadeOut, BlendOutTime:", FadeTime, "FrameCount:", UKismetSystemLibrary.GetFrameCount(), self)
    self.bPaused = false
    self.FadeTime = FadeTime
    self.FadeOutCallback = Callback

    if FadeTime <= 0 then
        -- FadeTime小于等于0时，代表瞬切
        self:SetToTransparent()
        self:OnFadeOutFinished()
    else
        -- 其余情况，正常FadeOut
        self.bFadeOut = true
        local AnimationTime = self.AlphaChange:GetEndTime()
        self:BindToAnimationFinished(self.AlphaChange, {self, function()
            self:UnbindAllFromAnimationFinished(self.AlphaChange)
            self:OnFadeOutFinished()
            self.bFadeOut = false
        end})
        self:DestroyAllAnmations()
        self:PlayAnimation(self.AlphaChange, 0, 1, EUMGSequencePlayMode.Reverse, AnimationTime/FadeTime)
    end

    -- 停止播放屏蔽用音效
    AudioManager(self):StopSound(self, "BlackScreenBorder")
end

function M:SetToBlack()
    DebugPrint("BP_BlackScreenBorder_C:SetToBlack", "FrameCount:", UKismetSystemLibrary.GetFrameCount(), self)
    self:DestroyAllAnmations()
    self:PlayAnimation(self.Black)
end

function M:SetToTransparent()
    DebugPrint("BP_BlackScreenBorder_C:SetToTransparent", "FrameCount:", UKismetSystemLibrary.GetFrameCount(), self)
    self:DestroyAllAnmations()
    self:PlayAnimation(self.Transparent)
end

function M:OnFadeInFinished()
    DebugPrint("BP_BlackScreenBorder_C:FadeInFinished", "FrameCount:", UKismetSystemLibrary.GetFrameCount(), self)
    if(self.FadeInCallback) then
        local Func = self.FadeInCallback.Func
        local Obj = self.FadeInCallback.Obj
        local Params = self.FadeInCallback.Params
        self.FadeInCallback=nil
        Func(Obj,table.unpack(Params))
    end
end

function M:OnFadeOutFinished()
    DebugPrint("BP_BlackScreenBorder_C:FadeOutFinished", "FrameCount:", UKismetSystemLibrary.GetFrameCount(), self)
    if(self.FadeOutCallback) then
        local Func = self.FadeOutCallback.Func
        local Obj = self.FadeOutCallback.Obj
        local Params = self.FadeOutCallback.Params
		self.FadeOutCallback = nil
        Func(Obj,table.unpack(Params))
    end
end

function M:Pause(bPaused)
    DebugPrint("BP_BlackScreenBorder_C:Pause, bPause:", bPaused, "self.bPaused:", self.bPaused, "FrameCount:", UKismetSystemLibrary.GetFrameCount(), self)
    if bPaused == true and self.bPaused == false then
        if self:IsAnimationPlaying(self.AlphaChange) then
            self.PausePosition = self:PauseAnimation(self.AlphaChange)
        end
    elseif bPaused == false and self.bPaused == true then
        if self.PausePosition then
            local PlayMode
            local PausePosition = self.PausePosition
            local AnimationTime = self.AlphaChange:GetEndTime()
            if self.bFadeIn == true then
                PlayMode = EUMGSequencePlayMode.Forward
            elseif self.bFadeOut == true then
                PlayMode = EUMGSequencePlayMode.Reverse
                PausePosition = AnimationTime - PausePosition
            end
            if PlayMode ~= nil then
                self:PlayAnimation(self.AlphaChange, PausePosition, 1, PlayMode, AnimationTime/self.FadeTime)
            end
        end
    end
    self.bPaused = bPaused
end

return M
