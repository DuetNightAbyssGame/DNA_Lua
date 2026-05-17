--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_HiddenTrollyWall_C
local BP_HiddenTrollyWall_C = Class({
    "BluePrints/Item/AirWall/BP_TrollyWall_C",
})

--障碍物死亡，更新当前路径点为Replace
function BP_HiddenTrollyWall_C:OnNormalDead()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    GameState.RaplacePathMap:Add(self.CurrentPathIndex, self.ReplacePathIndex)
end

--障碍物未死亡，更新当前路径点
function BP_HiddenTrollyWall_C:OnNormalDamage()
    --隐藏墙没撞掉就啥也不干
end


-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

function BP_HiddenTrollyWall_C:ReceiveBeginPlay()
    --这是蓝图实现的函数
    self:CreateRealWall()
end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

return BP_HiddenTrollyWall_C
