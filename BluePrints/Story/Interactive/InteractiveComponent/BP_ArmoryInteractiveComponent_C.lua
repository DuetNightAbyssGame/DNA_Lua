--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_ArmoryInteractiveComponent_C = Class()

--function BP_ArmoryInteractiveComponent_C:Initialize(Initializer)
--end

--function BP_ArmoryInteractiveComponent_C:ReceiveBeginPlay()
--end

--function BP_ArmoryInteractiveComponent_C:ReceiveEndPlay()
--end

-- function BP_ArmoryInteractiveComponent_C:ReceiveTick(DeltaSeconds)
-- end

function BP_ArmoryInteractiveComponent_C:LoadUI()
    self.Overridden.LoadUI(self)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManger = GameInstance:GetGameUIManager()
    if (UIManger ~= nil) then
        UIManger:CloseResidentUI()
    end
end

return BP_ArmoryInteractiveComponent_C
