require "UnLua"

--- WBP_Com_Dialog_InputPassword
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Construct()
    -- 缓存格子引用，方便循环
    self.Slots = { self.Num_01, self.Num_02, self.Num_03, self.Num_04, self.Num_05, self.Num_06 }

    self.Btn_Click.OnPressed:Add(self, self.OnItemPressed)
    self.Btn_Click.OnReleased:Add(self, self.OnItemReleased)
    self.Btn_Click.OnClicked:Add(self, self.OnItemClick)
    self.Btn_Click.OnHovered:Add(self, self.OnItemHovered)
    self.Btn_Click.OnUnhovered:Add(self, self.OnItemUnhovered)

    self.bIsSelected = false
    self.bIsHovered = false
    self.bIsPressed = false
    self:UpdateVisualState()
end

function M:UpdateVisualState()
    if self.bIsSelected then
        if self.CurrentAnimState ~= "Selected" then
            self:StopAllAnimations()
            self:PlayAnimation(self.Click)
            self.CurrentAnimState = "Selected"
        end
        return
    end

    if self.bIsPressed then
        if self.CurrentAnimState ~= "Pressed" then
            self:StopAllAnimations()
            self:PlayAnimation(self.Press)
            self.CurrentAnimState = "Pressed"
        end
        return
    end

    if self.bIsHovered and not UIUtils.IsMobileInput() then
        if self.CurrentAnimState ~= "Hovered" then
            self:StopAllAnimations()
            self:PlayAnimation(self.Hover)
            self.CurrentAnimState = "Hovered"
        end
        return
    end

    if self.CurrentAnimState == "Hovered" then
        self:StopAllAnimations()
        self:PlayAnimation(self.Unhover)
        self.CurrentAnimState = "Normal" 
    elseif self.CurrentAnimState ~= "Normal" then
        self:StopAllAnimations()
        self:PlayAnimation(self.Normal)
        self.CurrentAnimState = "Normal"
    end
end

--region 外部接口

--- 绑定点击事件
function M:BindBtnClickEvent(Obj, Func)
    self.ClickObj = Obj
    self.ClickFunc = Func
end

function M:RefreshState(Text, bIsFocused)
    local bOldSelected = self.bIsSelected
    self.bIsSelected = bIsFocused
    
    if bOldSelected and not bIsFocused then
        self.bIsPressed = false
    end

    self:UpdateVisualState()
    
    self:UpdateGrid(Text, self.bIsMasked)
end

---更新格子显示内容
function M:UpdateGrid(Str, bMasked)
    self.bIsMasked = bMasked
    local Len = string.len(Str or "")
    
    for i, SlotWidget in ipairs(self.Slots) do
        if SlotWidget and SlotWidget.SetState then
            if i <= Len then
                if bMasked then
                    SlotWidget:SetState("Masked")
                else
                    local Char = string.sub(Str, i, i)
                    SlotWidget:SetState("Visible", Char)
                end
            else
                SlotWidget:SetState("Empty")
            end
        end
    end
end

--endregion

--region 内部交互事件

function M:OnItemClick()
    if self.ClickObj and self.ClickFunc then
        self.ClickFunc(self.ClickObj)
    end
end

function M:OnItemPressed()
    if self.bIsSelected or UIUtils.IsMobileInput() then return end
    self.bIsPressed = true
    self:UpdateVisualState()
end

function M:OnItemReleased()
    self.bIsPressed = false
    self:UpdateVisualState()
end

function M:OnItemHovered()
    self.bIsHovered = true
    self:UpdateVisualState()
end

function M:OnItemUnhovered()
    self.bIsHovered = false
    self:UpdateVisualState()
end

--endregion

--region 手柄部分

function M:SetContext(ItemData)
    self.ItemData = ItemData
end

--endregion

return M