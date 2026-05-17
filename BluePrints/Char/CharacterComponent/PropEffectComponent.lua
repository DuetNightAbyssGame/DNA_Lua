local Component = {}

function Component:SwitchOnCannonProp()
    EventManager:FireEvent(EventID.OnSwitchOnCannonProp)
end

function Component:SwitchOffCannonProp()
    EventManager:FireEvent(EventID.OnSwitchOffCannonProp)
end

function Component:OpenSWSCannonHUD()
    UIManager(self):LoadUINew("SWSCannonHUD")
end

function Component:OnSWSCannonFired(Index)
    EventManager:FireEvent(EventID.OnSWSCannonFired, Index)
end

function Component:OnSWSCannonInCD()
    EventManager:FireEvent(EventID.OnSWSCannonInCD)
end

function Component:CloseSWSCannonHUD()
    local SWSCannonHUD = UIManager(self):GetUIObj("SWSCannonHUD")
    if SWSCannonHUD then
        SWSCannonHUD:Close()
    end
end

return Component