require "UnLua"
require "DataMgr"
local MiscUtils = require "Utils.MiscUtils"
local CommonConst = require "CommonConst"

local BP_BreakableItem_C = Class("BluePrints/Item/CombatProp/BP_CombatPropBase_C")

function BP_BreakableItem_C:AuthorityInitInfo(Info)
    if not self.Data then  return end
    BP_BreakableItem_C.Super.AuthorityInitInfo(self,Info)
    self.RewardId = self.Data.RewardId
    self.ModelId = self.ModelId or self.BPModelId
    self.ActiveType = ""
end
function BP_BreakableItem_C:ReceiveBeginPlay()
    self.Overridden.ReceiveBeginPlay(self)

    if self.UnitId <= 0 or self.UnitType == "" then
        return
    end
    if self.BpBorn and IsAuthority(self) then
        self:InitActorInfo({
            UnitId = self.UnitId,
            UnitType = self.UnitType,
        })
    end
end

function BP_BreakableItem_C:InitCombatPropInfo()
    -- local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    -- if GameMode and self.RewardID then
    --     GameMode:InitDropRule(self.UnitId, self.RewardID)
    -- end
end
-- function BP_BreakableItem_C:CommonInitInfo(Info)
--     BP_BreakableItem_C.Super.CommonInitInfo(self, Info)
--     MiscUtils.AddTickLodActor(ESignificanceTag.None, self, ETickObjectFlag.FLAG_ALL)
-- end

function BP_BreakableItem_C:ClientInitInfo(Info)
    -- BP_BreakableItem_C.Super.ClientInitInfo(self,Info)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
	if GameState then
		GameState:TryRegisterFirstSeeMehcanism(self.UnitId, self.Eid)
	end
    if IsValid(self.BillboardComponent) then
        self.BillboardComponent:SetTickMode(ETickMode.Disabled)
    end
    self:InitItemClientInfo()
end

function BP_BreakableItem_C:OnBreakCountDown(SourceEid)
    BP_BreakableItem_C.Super.OnBreakCountDown(self, SourceEid)
    self.Overridden.OnBreakCountDown(self, SourceEid)
end

function BP_BreakableItem_C:InitItemClientInfo()
    self:ItemMeshChildComponentInit()
end


function BP_BreakableItem_C:OnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
    if not self.EnbaleHollow then 
        self:SetHollowAttribute()
    end

    self.Super.OnDead(self, KillMineRoleEid, KillMineSkillId, DeathReason)

    if self.EMNavModifierComponent then
        self.EMNavModifierComponent:K2_DestroyComponent(self.EMNavModifierComponent)
    end

    -- local ExtraInfo = {UniqueSign = self.Eid}
    -- local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    -- if GameMode then
    --     GameMode:TriggerGenerateReward(GameMode:GetDropRule(self.UnitId), CommonConst.RewardReason.BreakableItem, self:GetTransform(), ExtraInfo)
    -- end
end

-- function BP_BreakableItem_C:HandleRemoveBuff()
--     local Buffs = self.BuffManager.Buffs
--     -- 先找到需要移除的 Buff，防止在移除 Buff，产生结算时增删 Buff
--     local RemoveBuffUniqueId = {}
--     for i = 1, Buffs:Num() do
--         local Buff = Buffs:Get(i)
--         local DeadNotRemove = Buff.DeadNotRemove or false
--         if not DeadNotRemove then
--             table.insert(RemoveBuffUniqueId, Buff.UniqueId)
--         end
--     end
--     -- 移除 Buff
--     for _, UniqueId in pairs(RemoveBuffUniqueId) do
--         Battle(self):RemoveUniqueBuffFromTarget(self, UniqueId)
--     end
-- end

function BP_BreakableItem_C:HandleShowDeath()
    self:SetActorEnableCollision(false)
    self:PlayBreakFx()
    self:ArtShowDeath()
    self:PlayBreakSound()
    -- local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    -- if GameMode then
    --     self:RegionOnEMActorDestroy(EDestroyReason.Breakable, GameMode)
    -- end
    --客户端自己也走删除方法，防止因为网络卡顿，导致死亡特效播放重复
    self:AddTimer(self.DelayDestoryTime, function() self:EMActorDestroy(EDestroyReason.Breakable) end)
end 

function BP_BreakableItem_C:ShowDeath(DissolveDuration)
    self:HandleShowDeath()
    if IsDedicatedServer(self) then
        self:ClientHandleShowDeath()
        self:AddTimer(self.DelayDestoryTime, function() self:EMActorDestroy(EDestroyReason.Breakable) end)
    end	
end


function BP_BreakableItem_C:PlayBreakFx()
    -- local FXPath = {
    --     [1] = '/Game/Asset/FX/Environment/Broken/Particle/NS_Environment_Itembroken.NS_Environment_Itembroken',
    --     [2] = '/Game/Asset/FX/Environment/Broken/Particle/NS_Environment_Itembroken02.NS_Environment_Itembroken02'
    -- }
    -- local RandomNum = math.random(1,2)
    -- if FXPath[RandomNum] == nil then
    --     return
    -- end
    -- local FXAsset = LoadObject(FXPath[RandomNum])
    local Meshs = TArray(UStaticMeshComponent)
    self.Mesh:GetChildrenComponents(true, Meshs)
    for i = 1, Meshs:Length() do
        local Mesh = Meshs:GetRef(i)
        if Mesh:Cast(UStaticMeshComponent) then
            -- self.FXComponent:SpawnFXAttached_Level(FXPath[RandomNum], "BreakableItem", Mesh)
            -- local FxObject = UE4.UNiagaraFunctionLibrary.SpawnSystemAttached(FXAsset, Mesh, "", UE4.FVector(0, 0, 0), UE4.FRotator(0, 0, 0), 0)
            Mesh:SetCastShadow(false)
        end
    end
end

local BreakSoundEvents = { -- 指定对应BP的音效event
    ["Pot"] = "event:/sfx/common/scene/break/single/Ceramic", -- 陶瓷类破碎物
    -- ["Glass"] = "event:/sfx/common/scene/break/single/Glass",
    -- ["Metal"] = "event:/sfx/common/scene/break/single/Metal",
    -- ["Mix"] = "event:/sfx/common/scene/break/single/Mix",
    -- ["Stone"] = "event:/sfx/common/scene/break/single/Stone",
    ["StoneFracture"] = "event:/sfx/common/scene/break/single/StoneFracture",
    -- ["Tree"] = "event:/sfx/common/scene/break/single/Tree",
    ["Wood"] = "event:/sfx/common/scene/break/single/Wood", -- 木质破碎物
    ["PotInWood"] = "event:/sfx/common/scene/break/single/PotInWood" -- 陶瓷和木质混合物
}
function BP_BreakableItem_C:PlayBreakSound()
    -- local SelfName = UKismetSystemLibrary.GetDisplayName(self)
    -- local eventName = BreakSoundEvents[self.SoundType]
    if self.SoundEvent then
        -- UEPrint(SelfName .. " " .. eventName)
        AudioManager(self):PlayFMODSound(self, nil, self.SoundEvent)
    else
        print(_G.LogTag, "破碎物" .. self:GetName() .."无对应播放的音效")
    end
end

function BP_BreakableItem_C:SetHollowAttribute()
    self.EnbaleHollow = true
end

function BP_BreakableItem_C:GetFXMesh()
    local Meshs = TArray(UStaticMeshComponent)
    self.Mesh:GetChildrenComponents(true,Meshs)
    if Meshs:Length() < 1 then
        return self.Mesh
    end
    local Index = math.random(Meshs:Length())
    return Meshs[Index]
end

function BP_BreakableItem_C:CheckUnitNeedStorage()
    return false
end

-- function BP_BreakableItem_C:EMActorDestroy(DestroyReason)
--     MiscUtils.RemoveTickLodActor(ESignificanceTag.None, self, ETickObjectFlag.FLAG_ALL)
--     BP_BreakableItem_C.Super.EMActorDestroy(self, DestroyReason)
-- end

-- function BP_BreakableItem_C:OnEMActorDestroy(DestroyReason)
--     BP_BreakableItem_C.Super.OnEMActorDestroy(self, DestroyReason)
--     MiscUtils.RemoveTickLodActor(ESignificanceTag.None, self, ETickObjectFlag.FLAG_ALL)
-- end

return BP_BreakableItem_C
