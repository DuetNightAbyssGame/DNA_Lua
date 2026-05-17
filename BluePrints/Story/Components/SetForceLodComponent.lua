---@class FSetForceLodComponent
local FSetForceLodComponent = {}

---@return FSetForceLodComponent
function FSetForceLodComponent:New(TalkTask, TalkContext)
	local SetForceLodComponent = setmetatable({}, {
		__index = FSetForceLodComponent
	})
	SetForceLodComponent.TalkTask = TalkTask
	SetForceLodComponent.TalkContext = TalkContext
	return SetForceLodComponent 
end

function FSetForceLodComponent:Execute()
	self.SavedLodActor = {}
    local TalkTask = self.TalkTask
    local TalkContext = self.TalkContext
	local bMobile = CommonUtils.GetRuntimePlatform(self.TalkContext) == "Mobile"

	if bMobile then
		return
	end

    for _, NpcData in pairs(TalkTask.TalkTaskData.TalkActors) do
        local UnitId = NpcData.TalkActorId
        local TalkActorData = TalkContext:GetTalkActorData(TalkTask, UnitId)
        local TalkActor = TalkActorData and TalkActorData.TalkActor
        if TalkActor and IsValid(TalkActor.Mesh) then
			self.SavedLodActor[TalkActor] = TalkActor.Mesh:GetForcedLOD()
			TalkActor.Mesh:SetForcedLOD(1)
        end
    end
end

function FSetForceLodComponent:Resume()
	DebugPrint("FSetForceLodComponent:Resume")
	if self.SavedLodActor then
        for TalkActor, Lod in pairs(self.SavedLodActor) do
            if IsValid(TalkActor) then
                TalkActor.Mesh:SetForcedLOD(Lod)
            end
        end
        self.SavedLodActor = nil
    end
end

return FSetForceLodComponent