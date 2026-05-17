

---@class EntityFactory
local EntityFactory = {}

EntityFactory.entity_classes = {}

function EntityFactory:RegisterEntity(entity_type, entity_class)
    self.entity_classes[entity_type] = entity_class
end

function EntityFactory:GetEntityClass(entity_type)
    local entity_class = nil
    if type(entity_type) == "string" then
        entity_class = self.entity_classes[entity_type]
    end
    return entity_class
end

---@return AvatarEntity
function EntityFactory:CreateEntity(entity_type, entity_id)
    local EntityClass = self:GetEntityClass(entity_type)
    if EntityClass == nil then
        return
    end
    return EntityClass(entity_id)
end



return EntityFactory
