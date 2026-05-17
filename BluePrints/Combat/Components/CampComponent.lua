

local Component = {}

function Component:SetCamp(CampValue)
    local CampValueType = type(CampValue)
    if CampValueType == "number" then
        self.Overridden.SetCamp(self, CampValue)
    elseif CampValueType == "string" then
        self.Overridden.SetCamp(self, Const.CampType[CampValue])
    end
end

return Component
