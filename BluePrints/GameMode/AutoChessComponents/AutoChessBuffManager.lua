local AutoChessBuffManager = {}

-- 初始化所有单位的装备Buff
function AutoChessBuffManager:OnBattleStartInitEquipBuff()
    local PlayerChessInfos = self:GetCurrentChessMonsterInfo(false)
    local EnemyChessInfos = self:GetCurrentChessMonsterInfo(true)
    local MissionId = self.MissionId

    local function AddBuffToChess(Index, ChessInfo)
        local Entity = Battle(self):GetEntity(ChessInfo.Eid)
        if not IsValid(Entity) then
            DebugPrint("AutoChess@ 找不到Eid对应单位，Index = ", Index)
            return
        end
        local EquipInfos = ChessInfo.EquipList or {}
        for _, EquipId in pairs(EquipInfos) do
            local AutoChessEquipData = DataMgr.RobotEquip[EquipId]
            if AutoChessEquipData.AttrBuffId then
                UBattleFunctionLibrary.AddBuffToTarget(Entity, Entity, AutoChessEquipData.AttrBuffId, -1, nil, nil, 1)
            end

            if AutoChessEquipData.ExtraBuffId then
                UBattleFunctionLibrary.AddBuffToTarget(Entity, Entity, AutoChessEquipData.ExtraBuffId, -1, nil, nil, 1)
            end
        end

        -- 增加Buff
        local MissionData = DataMgr.AutoChessMission[MissionId]
        local BuffId = MissionData.SpecifyBuffId and MissionData.SpecifyBuffId[1]

        if BuffId then
            UBattleFunctionLibrary.AddBuffToTarget(Entity, Entity, BuffId, -1, nil, nil, 1)
            DebugPrint("增加Buff: " .. BuffId .. "   to:  Eid" .. ChessInfo.Eid)
        end
    end

    -- 遍历装备，初始化Buff
    for Index, ChessInfo in pairs(PlayerChessInfos) do
        AddBuffToChess(Index, ChessInfo)
    end

    for Index, ChessInfo in pairs(EnemyChessInfos) do
        AddBuffToChess(Index, ChessInfo)
    end
end

-- 激励阶段Buff
function AutoChessBuffManager:OnStartMotivateBuff()
    local PlayerChessInfos = self:GetCurrentChessMonsterInfo(false)
    local EnemyChessInfos = self:GetCurrentChessMonsterInfo(true)

    local function AddMotivateBuffToChess(Index, ChessInfo)
        local Entity = Battle(self):GetEntity(ChessInfo.Eid)
        if not IsValid(Entity) then
            DebugPrint("AutoChess@ 找不到Eid对应单位，Index = ", Index)
            return
        end

        local MissionData = DataMgr.AutoChessMission[self.MissionId]
        if MissionData and MissionData.RegularBuffId then
            UBattleFunctionLibrary.AddBuffToTarget(Entity, Entity, MissionData.RegularBuffId, -1, nil, nil, 1)
        end
    end

    -- 遍历装备，初始化Buff
    for Index, ChessInfo in pairs(PlayerChessInfos) do
        AddMotivateBuffToChess(Index, ChessInfo)
    end

    for Index, ChessInfo in pairs(EnemyChessInfos) do
        AddMotivateBuffToChess(Index, ChessInfo)
    end
end

return AutoChessBuffManager
