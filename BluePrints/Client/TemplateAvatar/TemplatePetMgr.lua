local Component = {}

function Component:GMAddPet(PetId)
    local Pet = self.Pets:NewPet(PetId, 1)
    self.PetUniqueID = self.PetUniqueID + 1
    return Pet
end

function Component:GMCopyPet(Pet)
    self.Pets[Pet.UniqueId] = Pet ---todo copy
    return self.Pets[Pet.UniqueId]
end

return Component