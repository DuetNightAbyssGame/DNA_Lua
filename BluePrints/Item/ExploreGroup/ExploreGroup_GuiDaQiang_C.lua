--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type Explore_GuiDaQiang_C
local M = Class("BluePrints.Item.ExploreGroup.ExploreStaticCreator_C")

function M:GetPreTransform(StaticCreatorComp)
    if StaticCreatorComp.ChildEids:Length() == 0 then
        return
    end
    local ForbidBox = Battle(self):GetEntity(StaticCreatorComp.ChildEids[1])
    if not ForbidBox or not ForbidBox.OnPreTransformPlayer then
        return
    end
    return ForbidBox:OnPreTransformPlayer()
end

function M:SetNewTransform(StaticCreatorComp, Transform)
    if StaticCreatorComp.ChildEids:Length() == 0 then
        return
    end
    local ForbidBox = Battle(self):GetEntity(StaticCreatorComp.ChildEids[1])
    if not ForbidBox or not ForbidBox.SetNewTransform then
        return
    end
    ForbidBox:SetNewTransform(Transform)
end

return M
