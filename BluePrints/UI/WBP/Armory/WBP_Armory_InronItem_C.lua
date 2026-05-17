--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_InronItem_C
local M = Class("BluePrints.UI.BP_UIState_C")

function M:Construct()
    self.Btn_Area.OnClicked:Add(self, self.SetClickState)
    self.Btn_Area.OnPressed:Add(self, self.SetPressState)
    self.Btn_Area.OnHovered:Add(self, self.SetHoverState)
    self.Btn_Area.OnUnhovered:Add(self, self.SetUnHoverState)
end

function M:Init(Parent,TraceId,IsLock)
    self.Parent = Parent
    self.TraceId = TraceId
    self.IsLock =  IsLock
    self.IsClick = false
    self.Attribute = self.Parent.Attribute
    self.PreAnimation = nil
    
    self:SetReddotState(false)

    -- 根据属性变颜色
    local DynamicMaterial = self.Num_Intron:GetDynamicFontMaterial()
    DynamicMaterial:SetVectorParameterValue("MainColor", self[self.Attribute])

    local AllChildren = self.VX:GetAllChildren():ToTable() or {}
    for index, value in ipairs(AllChildren) do
        if value.SetColorAndOpacity then
            value:SetColorAndOpacity(self[self.Attribute .. "_VX"])
        end
        value:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end

    local VXActChildren = self.VX_Act:GetAllChildren():ToTable() or {}
    for index, value in ipairs(VXActChildren) do
        if value.SetColorAndOpacity then
            value:SetColorAndOpacity(self[self.Attribute .. "_VX"])
        end
        value:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end

    local VX01Children = self.VX01:GetAllChildren():ToTable() or {}
    for index, value in ipairs(VX01Children) do
        if value.SetColorAndOpacity then
            value:SetColorAndOpacity(self[self.Attribute .. "_VX01"])
        end
        value:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
end

function M:SetNormalState()
    if self.IsClick then
        return
    end
    --self:StopAllAnimations()
    --DebugPrint("zwkkkk  SetNormalState ", self:GetName(), GWorld:GetCurrentTime())
    if self.IsLock then
        self:PlayAnimation(self.Locked_Normal)
    else
        self:PlayAnimation(self.UnLocked_Normal)
    end
    -- if self.IsAnimationPlaying(self.Activatable_Loop) and not self.HasReddot then
    --     self:StopAnimation(self.Activatable_Loop)
    --     self:PlayAnimation(self.Activatable_Normal)
    -- end
end

function M:SetClickState()
    if self.IsClick then
        return
    end
    self.IsClick = true
    --self:StopAllAnimations()
    --DebugPrint("zwkkkk  SetClickState ", self:GetName(), GWorld:GetCurrentTime())
    if self.IsLock then
        self:PlayAnimation(self.Locked_Click)
    else
        self:PlayAnimation(self.UnLocked_Click)
    end
    -- self:SetReddotState(false)
    if self.Parent then
        self.Parent:OnClickTraceItem(self.TraceId)
    end
end

function M:SetHoverState()
    if self.IsClick then
        return
    end
    --self:StopAllAnimations()
    --DebugPrint("zwkkkk  SetHoverState ", self:GetName(), GWorld:GetCurrentTime())
    if self.IsLock then
        self:PlayAnimation(self.Locked_Hover)
    else
        self:PlayAnimation(self.UnLocked_Hover)
    end
end

function M:SetUnHoverState()
    if self.IsClick then
        return
    end
    --self:StopAllAnimations()
    --DebugPrint("zwkkkk  SetUnHoverState ", self:GetName(), GWorld:GetCurrentTime())
    if self.IsLock then
        self:PlayAnimation(self.Locked_UnHover)
    else
        self:PlayAnimation(self.UnLocked_UnHover)
    end
end

function M:SetPressState()
    if self.IsClick then
        return
    end
    --self:StopAllAnimations()
    --DebugPrint("zwkkkk  SetPressState ", self:GetName(), GWorld:GetCurrentTime())
    if self.IsLock then
        self:PlayAnimation(self.Locked_Press)
    else
        self:PlayAnimation(self.UnLocked_Press)
    end
end

function M:SetActivatableState()
    if self.IsClick or self:IsAnimationPlaying(self.Activatable_Loop) then
        return
    end
    self:PlayAnimation(self.Activatable_Loop, 0, 0)
end

function M:PlayActivatableNormal()
    if not self.HasReddot then
        self:StopAnimation(self.Activatable_Loop)
        self:PlayAnimation(self.Activatable_Normal)
    end
end

function M:SetReddotState(IsShow)
    if IsShow then
        self.HasReddot = true
        self.Reddot:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self:SetActivatableState()
        -- 红点优先级高于New，有红点时隐藏New
        if self.New then
            self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    else
        self.HasReddot = false
        self.Reddot:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

--- 新增：设置New标记状态
function M:SetNewState(IsShow)
    if not self.New then return end
    -- 红点优先级高于New
    if self.HasReddot then
        self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end
    if IsShow then
        self.New:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:CollapseNiagara()
    self.NI_Par1:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:PlayUnLockAnim()
    self:PlayActivatableNormal()
    self:PlayAnimation(self.UnLock)
    self.IsLock =  false
    self.Parent:SetDetailsUnlockPlaying(true)
    self:UnbindAllFromAnimationFinished(self.UnLock)
    self:BindToAnimationFinished(self.UnLock, {self, self.PlayUnLockAnimFinished})
end

function M:PlayUnLockAnimFinished()
    self.Parent:ClickToNextTraceItem()
    self.Parent:SetDetailsUnlockPlaying(false)
    -- if self.Parent and self.Parent.SelectTraceId ~= self.TraceId then
    --     self:SetNormalState()
    -- end
end

function M:CollapseVX()
    self.VX_WenLuHover27:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.VX_Hover19:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if self.Parent and self.Parent.OnTraceItemFocused then
        self.Parent:OnTraceItemFocused(self.TraceId)
    end
    return M.Super.OnFocusReceived(self, MyGeometry, InFocusEvent)
end

return M
