--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
require "DataMgr"

local BP_FileModify_C = Class()

function BP_FileModify_C:ModifyAnimRootmotion()
    for _,v in pairs(DataMgr.AnimRootMotion) do
        local data=DataMgr.AnimRootMotion[v.MainID]
        self.Overridden.ModifyAnimRootmotion(self,data.ResourcePath,data.FilePath,data.bEnableRootmotion)
    end
end
--function BP_FileModify_C:Initialize(Initializer)
--end

--function BP_FileModify_C:UserConstructionScript()
--end

--function BP_FileModify_C:ReceiveBeginPlay()
--
--end

--function BP_FileModify_C:ReceiveEndPlay()
--end

-- function BP_FileModify_C:ReceiveTick(DeltaSeconds)
-- end

--function BP_FileModify_C:ReceiveActorBeginOverlap(OtherActor)
--end

--function BP_FileModify_C:ReceiveActorEndOverlap(OtherActor)
--end

return BP_FileModify_C
