local M = {}

function M:Construct()
end

function M:SetPreInstallSlot(SlotIdx,Content)
    local SlotWidget = self:GetSlotWidget(SlotIdx)
    if(SlotWidget)then
        if(Content)then
            self:UpdateSlotItemWidget(SlotIdx,Content)
            SlotWidget:PlayOpacityLoopAnim()
            if(self["Prop_Icon"..SlotIdx])then
                self["Prop_Icon"..SlotIdx]:SetVisibility(UIConst.VisibilityOp["Visible"])
            end
        else
            self:SetSlotItem(SlotIdx,self.SlotContents[SlotIdx])
            if(not self.SlotContents[SlotIdx])then
                if(self["Prop_Icon"..SlotIdx])then
                    self["Prop_Icon"..SlotIdx]:SetVisibility(UIConst.VisibilityOp["Collapsed"])
                end
            end
            SlotWidget:StopOpacityLoopAnim()
        end
    end
end

function M:CalcGamepadPointerDiff(Diff)
    Diff.X = self.AnalogValue.X
    Diff.Y = self.AnalogValue.Y
end

function M:HandleRemovedFromFocusPath(FocusEvent)
    --self:Tick()
end

return M