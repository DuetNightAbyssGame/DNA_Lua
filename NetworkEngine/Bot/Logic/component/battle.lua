local battle = {}

--  进入区域流程
--  EntityMessage:EnterRegion                   ==>
--                                              <==             EntityMessage:PrepareToBattleRegion
--  EntityMessage:AvatarStatusEnterSuccess      ==>
function battle:EnterRegion(TargetRegionId, StartIndex, EnterRegionType, ForLogin)
    local callback = function ()
        self:log("EnterRegion callback")
    end
	self:EntityRpcWithCb("EnterRegion", callback, TargetRegionId, StartIndex, EnterRegionType, ForLogin)
end

function battle:PrepareToBattleRegion()
	self:EntityRpc("AvatarStatusEnterSuccess")
end
-- 90201
function battle:SingleGame(DungeonId)
    self:EnterDungeon(DungeonId,1,false)
end

function battle:EnterDungeon(DungeonId, DungeonNetMode, bCreateNewMatch)
    local callback = function ()
        self:log("EnterDungeon callback")
    end
    
    self:EntityRpcWithCb("EnterDungeon", callback, DungeonId, DungeonNetMode, bCreateNewMatch)
end

function battle:PrepareToBattle()
	self:EntityRpc("AvatarStatusEnterSuccess")
end

return battle