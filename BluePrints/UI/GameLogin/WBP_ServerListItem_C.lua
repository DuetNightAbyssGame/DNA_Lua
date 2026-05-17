--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local WBP_ServerListItem_C = Class("BluePrints.UI.BP_EMUserWidget_C")

function WBP_ServerListItem_C:SetItem(HostId,Area,Name,IP,Port)
    self.Text_ID:SetText(HostId)
    self.Text_Name:SetText(Name)
    --self.Text_Port:SetText(Port)
end

--function WBP_ServerListItem_C:Initialize(Initializer)
--end

-- function WBP_ServerListItem_C:Construct()
-- end

--function WBP_ServerListItem_C:Tick(MyGeometry, InDeltaTime)
--end

function WBP_ServerListItem_C:OnMouseButtonDown(MyGeometry, InKeyEvent)
    if UE4.UKismetInputLibrary.PointerEvent_IsMouseButtonDown(InKeyEvent, UE4.EKeys.LeftMouseButton) or
       UE4.UKismetInputLibrary.PointerEvent_IsMouseButtonDown(InKeyEvent, UE4.EKeys.RightMouseButton) then
        -- UIUtils.PlayCommonBtnSe(self)
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

return WBP_ServerListItem_C
