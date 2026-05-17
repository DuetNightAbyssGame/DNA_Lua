require "UnLua"

local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
local MAX_LEVEL = 3

--[[
    Params = {
        Level = 1,
        IsLocked = true,
        IsShowReddot = false,
        Obj = self,
        ClickedCallback = self.ClickedCallback
    }
]]
function M:InitContent(Params)
    if not Params then
        return
    end

    self.Level = math.clamp(Params.Level, 1, MAX_LEVEL)
    self.IsLocked = Params.IsLocked
    self.IsShowReddot = Params.IsShowReddot
    self.Obj = Params.Obj
    self.ClickedCallback = Params.ClickedCallback

    self.Text_Level:SetText(self.Level)
    self:SetLockVisibility(self.IsLocked)
    self:SetReddotState(self.IsShowReddot)
    self:SetAnimationState(self.IsLocked)
    self:PlayNormalAnimation()
end

function M:Construct()
    self.Btn_Area.OnClicked:Add(self, self.OnButonClicked)
    self.Btn_Area.OnHovered:Add(self, self.OnButonHovered)
    self.Btn_Area.OnUnhovered:Add(self, self.OnButonUnhovered)
    self.Btn_Area.OnPressed:Add(self, self.OnButonPressed)
end

function M:Destruct()
    self.Btn_Area.OnClicked:Clear()
    self.Btn_Area.OnHovered:Clear()
    self.Btn_Area.OnUnhovered:Clear()
    self.Btn_Area.OnPressed:Clear()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    self:OnButonClicked()
    return UIUtils.Handled
end

-- 锁定可见性
function M:SetLockVisibility(IsLocked)
    if IsLocked then
        self.Lock:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

-- 解锁
function M:UnlockLevel()
    self.IsLocked = false
    self:SetLockVisibility(self.IsLocked)
    self:SetAnimationState(self.IsLocked)

    local OnUnlockFinished = function()
        self:PlaySelectedAnimation()
        self:UnbindAllFromAnimationFinished(self.Unlock)
        self:BlockAllUIInput(false)
    end

    self:BindToAnimationFinished(self.Unlock, {self, OnUnlockFinished})

    self:BlockAllUIInput(true)
    self:PlayAnimation(self.Unlock)
end

-- 红点
function M:SetReddotState(IsShow)
    if IsShow then
        self.Reddot:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.IsShowReddot = IsShow
end

-- 动画状态
function M:SetAnimationState(IsLocked)
    self.Ani_Normal = IsLocked and self.Lock_Normal or self.Normal
    self.Ani_Hover = IsLocked and self.Lock_Hover or self.Hover
    self.Ani_UnHover = IsLocked and self.Lock_UnHover or self.UnHover
    self.Ani_Press = IsLocked and self.Lock_Press or self.Press
    self.Ani_Click = IsLocked and self.Lock_Click or self.Click
end

-- Normal动画
function M:PlayNormalAnimation()
    self:StopAllAnimations()
    self:PlayAnimation(self.Ani_Normal)
end

-- 选中动画
function M:PlaySelectedAnimation()
    self:StopAllAnimations()
    self:PlayAnimation(self.Ani_Click)
end

function M:OnButonClicked()
    if not self:CanProcessEvent() then
        return
    end

    self:PlayAnimation(self.Ani_Click)

    if self.Obj and self.ClickedCallback
        and (type(self.ClickedCallback) == "function") then
        self.ClickedCallback(self.Obj, self.Level)
    end
end

function M:OnButonHovered()
    if not self:CanProcessEvent() then
        return
    end

    self:StopAnimation(self.Ani_UnHover)
    self:PlayAnimation(self.Ani_Hover)
end

function M:OnButonUnhovered()
    if not self:CanProcessEvent() then
        return
    end

    self:StopAnimation(self.Ani_Hover)
    self:PlayAnimation(self.Ani_UnHover)
end

function M:OnButonPressed()
    if not self:CanProcessEvent() then
        return
    end

    self:PlayAnimation(self.Ani_Press)
end

function M:CanProcessEvent()
    if (self.Obj) and (self.Obj.SelectedSkinLevel == self.Level) then
        return false
    end

    return true
end

function M:BlockAllUIInput(Value)
    if type(Value) ~= "boolean" then
        return
    end

    if self.Obj and self.Obj.BlockAllUIInput then
        self.Obj:BlockAllUIInput(Value, "SP_DisplayOnly")
    end
end

return M