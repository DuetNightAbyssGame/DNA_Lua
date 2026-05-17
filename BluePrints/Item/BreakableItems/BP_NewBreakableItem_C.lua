require "UnLua"
require "DataMgr"
local CommonConst = require "CommonConst"
local MiscUtils = require "Utils.MiscUtils"

local BP_NewBreakableItem_C = Class({
    "BluePrints.Combat.Components.EffectSourceInterface",
    "BluePrints.Common.TimerMgr",
})
BP_NewBreakableItem_C._components = {
    "BluePrints.Combat.Components.SkillLevelInterface",
    "BluePrints.Common.DelayFrameComponent",
    "BluePrints.Combat.Components.ActorTypeComponent",
}

function BP_NewBreakableItem_C:ReceiveBeginPlay() -- 
    DebugPrint('BP_NewBreakableItem_C',self:GetName(),self:K2_GetActorLocation())
    self.Overridden.ReceiveBeginPlay(self)
    EventManager:AddEvent(EventID.OnBattleReady, self, self.OnBattleReady_TryInitCharacterInfo)
    if self.BpBorn and IsAuthority(self) then
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        if not GameMode:GetAlreadyInit() then
            GameMode.BPBornActor:AddUnique(self)
        end
        self:RegisterInfo({
            UnitId = self.UnitId,
            UnitType = self.UnitType
        })
    end
end

function BP_NewBreakableItem_C:OnBattleReady_TryInitCharacterInfo(_Battle)
    if Battle(self) == _Battle then
        self:TryInitActorInfo("Battle")
    end
end

----------------- 首先分为三种 一种是副本  二是区域  三是WC区域
----------------- 对于副本来说 也是拼接关  不受区域生成控制 那么在初始化的时候 判断Oninit有没有完成 完成即自己
----------------- ReceiveBeginPlay 进行初始化 
----------------- 对于普通区域适合副本一样的处理逻辑 因此 一二相同处理
----------------- 对于WC来说，生成和初始化不在由美术关卡控制 那么就不能让其在BeginPlay里面初始化
----------------- 


function BP_NewBreakableItem_C:RealReceiveBeginPlay()
    self.InitSuccess = true
    self.Overridden.OnActorReady(self)
end

function BP_NewBreakableItem_C:BeginInitInfo()
    if self.InitSuccess then
        return
    end
    self:InitActorInfo()
end

function BP_NewBreakableItem_C:RegisterInfo(Info)
    if Info then
        self.InfoForInit = Info
    end

    self:TryInitActorInfo("InitInfo")
end

function BP_NewBreakableItem_C:OnRep_ServerInitSuccess()
    self.InfoForInit =  {UnitId = self.UnitId, UnitType = self.UnitType}
    self:TryInitActorInfo("InitInfo")
end

function BP_NewBreakableItem_C:InitActorInfo(Info)
    if Info == nil then
        Info = self.InfoForInit
    end
    self:PreInitInfo(Info)
    if IsAuthority(self) then
        self:AuthorityInitInfo(Info)
    end
    self:CommonInitInfo(Info)
    if IsStandAlone(self) or not IsAuthority(self) then
        self:ClientInitInfo(Info)
    end
    self.ServerInitSuccess = true
    self.InitSuccess = true
    self:OnActorReady(Info)
end
function BP_NewBreakableItem_C:ClientInitInfo(Info)
   
    self:InitItemClientInfo()
end
function BP_NewBreakableItem_C:OnActorReady(Info)
    self:RealReceiveBeginPlay()
end

function BP_NewBreakableItem_C:AuthorityInitInfo(Info)
    self:SetCamp(self.Camp)
    self:SetTableAttr()
    self.ModelId = self.ModelId or self.BPModelId
    self:InitCreatorInfo(Info)
    self:InitCombatPropInfo()
end


function BP_NewBreakableItem_C:InitCreatorInfo(Info)
    -- if URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self) then
    --     local AddRegionDataType = CommonConst.AddRegionDataType.Normal
    --     RegionUtils.SetActorRegionMark(self, Info)
    --     RegionUtils.AddRegionDataByActor(self, Info.Creator, AddRegionDataType, Info.ActorPath)
    -- end
end


function BP_NewBreakableItem_C:CommonInitInfo()
    Battle(self):AddEntity(self.Eid, self)
    self:InitComponent()
    -- MiscUtils.AddTickLodActor(ESignificanceTag.None, self, ETickObjectFlag.FLAG_ALL)
end

function BP_NewBreakableItem_C:InitComponent(Info)
    if self.bNeedNavModifier then
        self:AddNavModifier()
    end
end


function BP_NewBreakableItem_C:PreInitInfo(Info)
    self.Data = DataMgr.Mechanism[self.UnitId]
    if not self.Data then return end
    self.BattleCharInfo = DataMgr.BattleMonster[self.Data.BattleRoleId]
    if Info.Eid ~= nil then
        self.Eid = Info.Eid
    elseif IsAuthority(self) then
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        self.Eid = GameMode:GetBattleEid()
    end
end

function BP_NewBreakableItem_C:InitCombatPropInfo()
    -- local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    -- if GameMode and self.RewardId then
    --     GameMode:InitDropRule(self.UnitId, self.RewardId)
    -- end
end


function BP_NewBreakableItem_C:InitItemClientInfo()
    self:ItemMeshChildComponentInit()
end


function BP_NewBreakableItem_C:OnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
    if not self.EnbaleHollow then self:SetHollowAttribute()  end
    -- if URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self) then
    --     RegionUtils.DeadRegionActorData(self, true, self.LevelName)
    -- end
    self:ShowDeath()

    --统计可破坏物破坏情况，暂定由BreakCountDown造成的死亡都算
    local Player = Battle(self):GetEntity(KillMineRoleEid)
    if IsValid(Player) and Player.IsPlayer and Player:IsPlayer() then
        Player:AddBreakableItemCount()
    end

    local ExtraInfo = {UniqueSign = self.Eid, SourceEid = KillMineRoleEid}
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
        GameMode:TriggerRewardEvent(self.UnitId, CommonConst.RewardReason.BreakableItem, self:GetTransform(), ExtraInfo)
    end
end


function BP_NewBreakableItem_C:HandleShowDeath()
    self:SetActorEnableCollision(false)
    if not IsDedicatedServer(self) then
        self:PlayBreakFx()
        self:ArtShowDeath()
        self:PlayBreakSound()
    end
    self:AddTimer(self.DelayDestoryTime, function() self:EMActorDestroy(EDestroyReason.Breakable) end)
end


function BP_NewBreakableItem_C:ShowDeath(DissolveDuration)
    if self.SourceEid then
        self:TriggerSource()
    end
    if self.EMNavModifierComponent then
        self.EMNavModifierComponent:K2_DestroyComponent(self.EMNavModifierComponent)
    end
    self:HandleShowDeath()
    -- if IsDedicatedServer(self) then
    --     self:ClientHandleShowDeath()
    --     self:AddTimer(self.DelayDestoryTime, function() self:EMActorDestroy(EDestroyReason.Breakable) end)
    -- end
end

function BP_NewBreakableItem_C:PlayBreakFx()
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
function BP_NewBreakableItem_C:PlayBreakSound()
    -- local SelfName = UKismetSystemLibrary.GetDisplayName(self)
    -- local eventName = BreakSoundEvents[self.SoundType]
    if self.SoundEvent then
        AudioManager(self):PlayFMODSound(self, nil, self.SoundEvent)
    else
        print(_G.LogTag, "破碎物" .. self:GetName() .."无对应播放的音效")
    end
end

function BP_NewBreakableItem_C:SetHollowAttribute()
    self.EnbaleHollow = true
end

function BP_NewBreakableItem_C:GetFXMesh()
    local Meshs = TArray(UStaticMeshComponent)
    self.Mesh:GetChildrenComponents(true,Meshs)
    if Meshs:Length() < 1 then
        return self.Mesh
    end
    local Index = math.random(Meshs:Length())
    return Meshs[Index]
end

function BP_NewBreakableItem_C:CheckUnitNeedStorage()
    return false
end

function BP_NewBreakableItem_C:IsInDefeat()
    return false
end
---BP_ArtBreakableItem_Group_Ref_C_0_130_1705989290
function BP_NewBreakableItem_C:OnEMActorDestroy(DestroyReason)
    -- if not NormalDeath and URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self) then
    --     DebugPrint("ZJT_ 111111111111 OnEMActorDestroy ", NormalDeath, self.LevelName)
    --     RegionUtils.DeadRegionActorData(self, false, self.LevelName)
    -- end
    if not rawget(self, "bRemoveTickLod") then
        MiscUtils.RemoveTickLodActor(ESignificanceTag.None, self, ETickObjectFlag.FLAG_ALL)
        rawset(self, "bRemoveTickLod", true)
    end
end

function BP_NewBreakableItem_C:ReceiveEndPlay(reason)
    EventManager:RemoveEvent(EventID.OnBattleReady, self)
    -- if not rawget(self, "bRemoveTickLod") then
    --     MiscUtils.RemoveTickLodActor(ESignificanceTag.None, self, ETickObjectFlag.FLAG_ALL)
    --     rawset(self, "bRemoveTickLod", true)
    -- end
    self.Overridden.ReceiveEndPlay(self,reason)
    -- local Battle=Battle(self)
    -- if Battle then
    --     Battle:RemoveEntity(self.Eid)--remove一下eid，美术场景的卸载又加载后eid会变
    -- end
end


AssembleComponents(BP_NewBreakableItem_C)
return BP_NewBreakableItem_C