local BP_SoloTreasureContainer = Class("BluePrints.Item.Chest.BP_MechanismBase_C")

function BP_SoloTreasureContainer:GetCanOpen(PlayerEid)
    -- 动态设置 CanOpen，使交互按钮可以显示
    self.CanOpen = true
end

function BP_SoloTreasureContainer:OpenMechanism(PlayerId)
    DebugPrint("gmy@BP_SoloTreasureContainer BP_SoloTreasureContainer:OpenMechanism", PlayerId, "ServerUniqueId", self.ServerUniqueId)
    
    local ServerEntity = GWorld:GetServerEntity()
    if ServerEntity then
        local DungeonObject = ServerEntity:GetDungeonObject()
        if DungeonObject then
            local MechanismEntity = DungeonObject:GetCachedMechanismInfo(self.ServerUniqueId)
            if MechanismEntity then
                -- 检查是否为初次打开 (OpenTimeStamp == -1 表示未打开过)
                DebugPrint("gmy@BP_SoloTreasureContainer BP_SoloTreasureContainer:OpenMechanism", MechanismEntity.OpenTimeStamp)
                if MechanismEntity.OpenTimeStamp and MechanismEntity.OpenTimeStamp == -1 then
                    self:OnFirstTimeOpen(PlayerId, MechanismEntity)
                end
            end
        end
    end
    
    -- local ServerEntity = GWorld:GetServerEntity()
    -- if not ServerEntity then return end
    -- local Dungeonobject = ServerEntity:GetDungeonObject()
    -- if not Dungeonobject then return end
    -- local MechanismEntity = self.Dungeonobject:GetCachedMechanismInfo(self.ServerUniqueId)
    -- if not MechanismEntity then return end
    -- if not MechanismEntity.IsUnlock then
    --     local MechanismInfo = DataMgr.ExtractionTreasureMechanism[MechanismEntity.UnitId]
    --     or DataMgr.ExtractionTreasureTribute[MechanismEntity.UnitId]
    --     or DataMgr.ExtractionTreasureRewardRoom[MechanismEntity.UnitId]
    --     or DataMgr.ExtractionTreasureGuard[MechanismEntity.UnitId]
    --     or DataMgr.ExtractionTreasureTicket[MechanismEntity.UnitId]
    --     if not MechanismInfo then return end
    --     local UnlockPoint = MechanismInfo.UnlockPoint
    --     if not UnlockPoint then return end
    --     if Dungeonobject.KillMonsterScore < UnlockPoint then
    --         UIManager(self):(UIConst.Tip_CommonToast, "战斗积分不足，无法开启(未配Textmap)")
    --         return
    --     end
    -- end
    
    self:RealOpenMechanism()
end

function BP_SoloTreasureContainer:RealOpenMechanism()
    -- 冷却1s 
    local NowMs = os.clock() * 1000
    if self.OpenMechanismCooldownEndMs and NowMs < self.OpenMechanismCooldownEndMs then
        return
    end
    self.OpenMechanismCooldownEndMs = NowMs + 1000

    if not self.ServerUniqueId then return end
    if not self.GameMode then
        self.GameMode = UE4.UGameplayStatics.GetGameMode(self)
    end
    if not self.GameMode then return end
    self.GameMode:NotifyServerDungeonEvent("OpenSoloTreasureMechanism", self.ServerUniqueId)
    -- todo: 补全打开逻辑
    UIManager(self):LoadUINew("SoloTreasureBag", self.ServerUniqueId, function()
        DebugPrint("lgc@ SoloTreasureBag AsyncLoaded self.ServerUniqueId =", self.ServerUniqueId)
    end, "Async")
end

return BP_SoloTreasureContainer
