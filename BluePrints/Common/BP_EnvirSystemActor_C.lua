--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_EnvirSystemActor_C
local BP_EnvirSystemActor = Class()

function BP_EnvirSystemActor:SequenceUpdateLight()
    -- print("SequenceUpdateLight")
    self.Overridden.SequenceUpdateLight(self)
end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

return BP_EnvirSystemActor
