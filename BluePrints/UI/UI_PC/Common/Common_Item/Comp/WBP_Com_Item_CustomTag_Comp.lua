local Component = {}


function Component:SetCustomTag(bAllowCustom)
    self:AsyncLoadWidgetCommon("CustomTagUI" , "SetCustomTagTack", function(CoroutineObj)
        if bAllowCustom then
            self.CustomTagUI = self:GetOrCreateGroupWidget("ComItemCustomTag",CoroutineObj)
        else
            self:RemoveGroupWidget("ComItemCustomTag")
        end
    end)
end

return Component