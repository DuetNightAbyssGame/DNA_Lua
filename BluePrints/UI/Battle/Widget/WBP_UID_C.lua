--
-- DESCRIPTION
--
-- @COMPANY HERO GAMES @PAN.Studio
-- @AUTHOR Laixiaoyang
-- @DATE ${date} ${time}
--

---@type UID_C|WBP_Com_Tab_P_C
local UID_C = Class("BluePrints.UI.BP_EMUserWidget_C")

--function UID_C:Initialize(Initializer)
--end

--function UID_C:PreConstruct(IsDesignTime)
--end

function UID_C:Construct()
    self:SetUid()
end

function UID_C:SetUid(InUid)
    if InUid then
        self.Num_UID:SetText(tostring(InUid))
    else
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            self.Num_UID:SetText("")
            return
        end
        self.Num_UID:SetText(tostring(Avatar.Uid))
    end
end

function UID_C:HideUid()
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function UID_C:ShowUid()
    self:SetVisibility(UE4.ESlateVisibility.Visible)
end

--function UID_C:Tick(MyGeometry, InDeltaTime)
--end

return UID_C
