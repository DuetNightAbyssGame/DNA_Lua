--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local RewardBox = require "BluePrints.Client.CustomTypes.SimpleRewardBox"
local BP_ChestBase_C = Class("BluePrints.Item.Chest.BP_MechanismBase_C")

function BP_ChestBase_C:ReceiveBeginPlay()
    BP_ChestBase_C.Super.ReceiveBeginPlay(self)
    self:SetMaterial()
end

function BP_ChestBase_C:AuthorityInitInfo(Info)
    BP_ChestBase_C.Super.AuthorityInitInfo(self,Info)
    self:SetRewardID()
end

function BP_ChestBase_C:ClientInitInfo(Info)
    BP_ChestBase_C.Super.ClientInitInfo(self,Info)
    if self.InitAnim then
        self:InitAnim()
        self.Mesh:SetComponentTickEnabled(false)
    end
end

function BP_ChestBase_C:OnActorReady(Info)
    BP_ChestBase_C.Super.OnActorReady(self,Info)
    if self.OpenState and self.NeedDestroy then
        self:EMActorDestroy(EDestroyReason.MechanismDead)
    end
end


function BP_ChestBase_C:OpenMechanism(PlayerId)
    self.Mesh:SetComponentTickEnabled(true)
    self:TriggerSource(0)

    --多波的动画和奖励生成一起播
    if self.RewardTime == 0 or self.RewardWave <= 1 then
        self:ClientPlayAnim(PlayerId, 0, self.Eid)
    end

    self:AddTimer(1, function() 
        self.Mesh:SetComponentTickEnabled(false)
    end, false, 0, "CloseChestTick")

    if self.OpenState == false then
        self:DropReward(PlayerId)
    end
    -- 等价于self.OpenState = true
    self:UpdateRegionData("OpenState", true)
    self:DeactiveGuide()

    if self.ChestInteractiveComponent then
        local Player = Battle(self):GetEntity(PlayerId)
        if Player then
            --记录玩家打开宝箱的次数
            Player:AddChestOpenedCount()
            self.ChestInteractiveComponent:EndInteractive(Player)
        end
    end
    
    -- local OpenSound = (self.OpenSound and self.OpenSound ~= "") and self.OpenSound or "event:/sfx/common/scene/magic_box"
    -- AudioManager(self):PlayFMODSound(self, nil, OpenSound)

    if self.NeedDestroy then
        self:AddTimer(3, self.PlayDestroyEffect, false, 0)
    end

    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local SceneMgrComponent = GameInstance:GetSceneManager()
    if (IsValid(SceneMgrComponent)) then
        if self.Eid == SceneMgrComponent.NearestBreakableItemGuideEid then
            SceneMgrComponent:CloseOneGuideIconByTargetEid(self.Eid)
            SceneMgrComponent.NearestBreakableItemGuideEid = 0
        end
    end
end

function BP_ChestBase_C:PlayDestroyEffect()
    self:OnChestDestroy()
end

function BP_ChestBase_C:OnChestDestroy()
    self:RemoveTimer("CloseChestTick")
    self.BodyCollision:SetCollisionEnabled(0)
    self.Overridden.OnChestDestroy(self)
end

function BP_ChestBase_C:BuildRewardInfo(PlayerId)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then return end
    local RewardIds = GameMode:GetDropRule(self.UnitId)
    local ExtraInfo = {
        UniqueSign = self.Eid,
        SourceEid = PlayerId,
        ParentEid = self.Eid,
        MultiWave = true,
    }
    if self.RewardTime == 0 or self.RewardWave <= 1 then
        ExtraInfo.MultiWave = false
    end
    if GameMode:IsInRegion() then
        ExtraInfo.WorldRegionEid = self.WorldRegionEid
        ExtraInfo.RegionDataType = self.RegionDataType
        local RewardPosition = self:GetTransform()
        if self.RewardPosition then
            RewardPosition = self.RewardPosition:K2_GetComponentToWorld()
        end
       
    end
    -- ExtraInfo.
    return RewardIds, ExtraInfo
end

function BP_ChestBase_C:MultiWaveCreateDrop(Drops, CreateDropFunc, AvatarEidStr)
    if not self.CurrentWaveList then
        self.CurrentWaveList = {}
    end
    self.CurrentWaveList[AvatarEidStr] = CreateDropFunc
    if not self.CurrentWave then
        self.CurrentWave = {}
    end
    self.CurrentWave[AvatarEidStr] = 1
    local DropsTable = {}
    for DropId, DropCountTable in pairs(Drops) do
        DropId = tonumber(DropId)
        DropsTable[DropId] = {}
        local ExtraCount = RewardBox:FindCountByTag(DropCountTable, "Extra")
        local OtherCount = RewardBox:FindCountByTag(DropCountTable, "Normal")
        DropsTable[DropId].Count = OtherCount + ExtraCount
    end
    local RealWave = self:GetWaveCount(DropsTable)
    local Time = self.RewardTime / RealWave
    local Key = "ChestCreateDrop"..AvatarEidStr
    self:AddTimer(Time, self.RealCreateDrop, true, -Time, Key, nil, RealWave, DropsTable, AvatarEidStr, Key)
    self:ClientPlayAnim(self.CombatStateChangeComponent.PlayerEid, 0, self.Eid)
end

function BP_ChestBase_C:RealCreateDrop(RealWave, DropsTable, AvatarEidStr, TimerKey)
    if not self.CurrentWave or not self.CurrentWave[AvatarEidStr] then
        return
    end
    if not self.CurrentWaveList or not self.CurrentWaveList[AvatarEidStr] then
        return
    end
    for DropId, Table in pairs(DropsTable) do
        if self.CurrentWave[AvatarEidStr] < RealWave then
            if Table.Count > 0 and Table.WaveCount > 0 and (self.CurrentWave[AvatarEidStr] % Table.WaitWave == 0) then
                self.CurrentWaveList[AvatarEidStr](DropId, Table.WaveCount, false, 0)
            end
        elseif self.CurrentWave[AvatarEidStr] == RealWave then
            if Table.Count > 0 and Table.RemainCount > 0 then
                self.CurrentWaveList[AvatarEidStr](DropId, Table.RemainCount, false, 0)
            end
        end
    end
    self.CurrentWave[AvatarEidStr] = self.CurrentWave[AvatarEidStr] + 1
    if self.CurrentWave[AvatarEidStr] > RealWave then
        self:RemoveTimer(TimerKey)
    end
end

function BP_ChestBase_C:GetWaveCount(DropsTable)
    local RealWave = self.RewardWave
    local Res = true
    local MaxCount = 0
    for DropId, Table in pairs(DropsTable) do
        if MaxCount < Table.Count then
            MaxCount = Table.Count
        end
        local Rate = RealWave / Table.Count
        if Rate < 1 then
            Res = false
        end
    end
    if Res then
        RealWave = MaxCount
    end
    for DropId, Table in pairs(DropsTable) do
        local Rate = RealWave / Table.Count
        if Rate <= 1 then
            Table.WaveCount = math.floor(Table.Count/RealWave)
            Table.WaitWave = 1
            Table.RemainCount = Table.Count - (RealWave - 1) * Table.WaveCount
        else
            Table.WaveCount = 1
            Table.WaitWave = math.ceil(RealWave/Table.Count)
            if RealWave % Table.WaitWave == 0 then
                local tmp = RealWave//Table.WaitWave
                Table.RemainCount = Table.Count - (tmp - 1) * Table.WaveCount
            else
                local tmp = RealWave//Table.WaitWave
                Table.RemainCount = Table.Count - tmp * Table.WaveCount
            end
        end
    end
    return RealWave
end

return BP_ChestBase_C
