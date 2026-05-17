local M = {}

function M:New()
	local Obj = setmetatable({}, {
		__index = M
	})

	Obj.HiddenNiagaraComponents = {}

	return Obj
end

function M:Execute()
	local GameInstance = GWorld.GameInstance
	if (not IsValid(GameInstance)) then
		return
	end

	local World = GameInstance:GetWorld()
	if (not IsValid(World)) then
		return
	end

	local WorldSettings = World:K2_GetWorldSettings()
	if (not IsValid(WorldSettings)) then
		return
	end

	local NiagaraComponents = WorldSettings:K2_GetComponentsByClass(UE4.UNiagaraComponent)
	for i = 1, NiagaraComponents:Length() do
		local NiagaraComponent = NiagaraComponents:GetRef(i)
		if (IsValid(NiagaraComponent) and NiagaraComponent:IsActive()) then
			local AttachParent = NiagaraComponent:GetAttachParent()
			if (not IsValid(AttachParent)) then
				table.insert(self.HiddenNiagaraComponents, NiagaraComponent)
				NiagaraComponent:SetHiddenInGame(true)
			end
		end
	end
end

function M:Resume()
	for _, NiagaraComponent in ipairs(self.HiddenNiagaraComponents) do
		if (IsValid(NiagaraComponent)) then
			NiagaraComponent:SetHiddenInGame(false)
		end
	end

	self.HiddenNiagaraComponents = {}
end

return M
