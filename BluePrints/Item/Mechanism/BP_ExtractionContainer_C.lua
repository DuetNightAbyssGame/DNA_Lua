require "UnLua"

local BP_ExtractionContainer_C = Class("BluePrints.Item.Chest.BP_MechanismBase_C")

------------------------------------------- 交互条件检查 -----------------------------------------------
function BP_ExtractionContainer_C:GetCanOpen(PlayerEid)
    DebugPrint("gmy@BP_ExtractionContainer_C BP_ExtractionContainer_C:GetCanOpen", PlayerEid)
    -- TODO: 实现交互条件检查逻辑
    
    if self.OpenState then
        self.CanOpen = false
        return
    end
    
    self.CanOpen = true
end

------------------------------------------- 交互行为 -----------------------------------------------
function BP_ExtractionContainer_C:OpenMechanism(PlayerId)
    DebugPrint("gmy@BP_ExtractionContainer_C BP_ExtractionContainer_C:OpenMechanism", PlayerId)
end

function BP_ExtractionContainer_C:CloseMechanism(PlayerId, IsSuccess)
    DebugPrint("gmy@BP_ExtractionContainer_C BP_ExtractionContainer_C:CloseMechanism", PlayerId, IsSuccess)
    -- 调用父类的关闭逻辑
    self:BroadcastCloseMechanism(PlayerId)
end


return BP_ExtractionContainer_C

