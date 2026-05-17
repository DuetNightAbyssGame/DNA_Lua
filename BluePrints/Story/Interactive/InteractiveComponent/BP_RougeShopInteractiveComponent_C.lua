--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type BP_RougeShopInteract_C
local M = Class("BluePrints.Story.Interactive.InteractiveComponent.BP_HomeInteractiveComponent_C")
-- function M:Initialize(Initializer)
-- end

-- function M:ReceiveBeginPlay()
-- end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end
function M:LoadUI()
    -- self.Overridden.LoadUI(self)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    local RougeLikeManager = GWorld.RougeLikeManager
    if not RougeLikeManager then
        return
    end
    local GameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
    if not GameState then
        return false
    end
    local NpcCharacterMap = GameState.NpcCharacterMap
    local Npc = NpcCharacterMap:FindRef(self.Owner.NpcId)
    local CreatorId = Npc.CreatorId
    local ShopId = RougeLikeManager.StaticCreatorIdToShopId[CreatorId]
    UIManager:LoadUINew("RougeShop", ShopId, self.Type)
end

return M
