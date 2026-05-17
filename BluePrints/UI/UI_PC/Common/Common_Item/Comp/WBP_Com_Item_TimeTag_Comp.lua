local Component = {}

---@param TagValList list  e.g:{1,2}
function Component:SetTimeTag(TimeTagList)
    local Callback = function(TimeTagUI)
        self.TimeTag = UE.FWeakObjectPtr(TimeTagUI)
        self:AddWidgetToNode(nil, self.TimeTag)
        TimeTagUI:SetUpTimeTag(TimeTagList)
    end
    if not table.isempty(TimeTagList) then
        if not self.TimeTag or not self.TimeTag:IsValid() then
            self:CreateWidgetAsync("ComItemTimeTag",Callback)
            return
        else
            Callback(self.TimeTag:Get())
        end
    elseif self.TimeTag then
        self:RemoveWidgetFromNode(nil, false ,self.TimeTag)
    end
end

return Component