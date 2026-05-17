
local msgpack = require "msgpack_core"
local Component = {}
local GM_Command = require "BluePrints.Client.GM_Command"
local MiscUtils = require "Utils.MiscUtils"
function Component:DoBattleCommand(EffectStruct, bPrintToClient, EidFrom)
    local bDistribution = UE4.URuntimeCommonFunctionLibrary.IsDistribution()
    if bDistribution then
        return
    end
    if bPrintToClient then
        if not IsDedicatedServer(self) then
            bPrintToClient = false
        end
    end
    local ct = {}
    local OldPrint = print
    if bPrintToClient then
        _G.print = function(logTag, ... )
            OldPrint(logTag, ...)
            local FirstFlag = 1
            for k,v in pairs({...}) do
                -- OldPrint(k,v)
                if FirstFlag == 0 then
                    table.insert(ct, "\t")
                end
                table.insert(ct, tostring(v))
                FirstFlag = 0
            end
            table.insert(ct, "\n")
        end
    end
    -- 兼容代码
    if not self.CompatibleDS then
        self.Commands = Component
        self.NewCommands = {}
        for k,v in pairs(self.Commands) do
            local Key = k
            if string.sub(k, 1, 3) == "GM_"  then
                Key = string.sub(k, 4)
            end
            self.NewCommands[string.upper(Key)] = k
            self.NewCommands[Key] = k
        end

        self.Commands = self.NewCommands
        self.CompatibleDS = true
    end
    -- 兼容代码

    local Str = EffectStruct:GetResult()
    if not Str then
        return
    end
    local Result = msgpack.unpack(Str)
    for _, Args in pairs(Result) do
        for Func, Content in pairs(Args) do
            GM_Command.ClientGM(self, self, Func, Content)

            -- local f = self["GM_"..Func]
            -- f(self, table.unpack(Content))
        end
    end

    _G.print = OldPrint
    if bPrintToClient then
        local Player = self:GetEntity(EidFrom)
        if Player then
            local ret = table.concat(ct)
            Player:CallClientPrint(ret)
        end
    end
end

function Component:ShowEidError(Eid)
    return "找不到Eid:["..tostring(Eid).."]对应的角色"
end

function Component:GM_GetOrSetPlayerAttr(Eid, Name, Value)
    PrintTable({Eid=Eid,Name=Name, Value=Value}, 2)
    local Target = self:GetEntity(Eid)
    assert(Target, self:ShowEidError(Eid))
    if Value == nil then
        Value = Target:GetAttr(Name)
        if type(Value) == "table" then
            ScreenPrint(string.format("当前玩家的 %s 的值为:" , Name))
            PrintTable(Value,10)
        else
            ScreenPrint(string.format("当前玩家的 %s 的值为 %s" , Name, Value))
        end
        return
    end
    local OldValue = Target:GetAttr(Name)
    if OldValue == Value then 
        return
    end
    if tonumber(Value) then
        Value = tonumber(Value)
    end
    Target:SetAttr(Name, Value)
    if Name == "Level" then
        Target:UpdateAttrByLevel(Value)
    end
    Target:CalcATK()
end

function Component:GM_GetOrSetPlayerWeaponAttr(Eid, WeaponId, Name, Value)
    PrintTable({Eid=Eid, WeaponId=WeaponId,Name=Name, Value=Value}, 2)
    local Player = self:GetEntity(Eid)
    assert(Player, self:ShowEidError(Eid))
    WeaponId = tonumber(WeaponId)
    local Target = Player:GetWeapon(WeaponId)
    if not Target then
        ScreenPrint(string.format("Id 为 %s 的武器不存在，或尝试以客户端运行。", WeaponId))
        return
    end
    if Value == nil then
        Value = Target:GetAttr(Name)
        if type(Value) == "table" then
            ScreenPrint(string.format("当前武器的 %s 的值为:" , Name))
            PrintTable(Value,10)
        else
            ScreenPrint(string.format("当前武器的 %s 的值为 %s" , Name, Value))
        end
        return
    end
    local OldValue = Target:GetAttr(Name)
    if OldValue == Value then
        return
    end
    if tonumber(Value) then
        Value = tonumber(Value)
    end
    Target:SetAttr(Name, Value)
    if Name == "Level" then
        Target:UpdateAttrByLevel(Value) 
    end
end

function Component:GM_CreateMonster(Eid, UnitId, Num, Level, CreatorType, ForceLOD)
    Num = Num or 1
    PrintTable({CreateMonster = {UnitId = UnitId, Num = Num}}, 2)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    GameMode.EMGameState.EventMgr:GMCreateMonster(Eid, UnitId, Num, Level, CreatorType, ForceLOD)
end

function Component:GM_CutToughnessValue(Eid, Value)
    self:SetGMCuttoughnessValue(Value)
end

function Component:GM_CreateNpc(UnitId, Num, Level, CreatorType)
    Num = Num or 1
    PrintTable({CreateNpc = {UnitId = UnitId, Num = Num}}, 2)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    GameMode.EMGameState.EventMgr:GMCreateNpc(UnitId, Num, Level, CreatorType)
end

function Component:GM_CreatePet(UnitId, Num, Level, CreatorType)
    Num = Num or 1
    PrintTable({CreatePet = {UnitId = UnitId, Num = Num}}, 2)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    GameMode.EMGameState.EventMgr:GMCreatePet(UnitId, Num, Level, CreatorType)
end

function Component:GM_CreateTestMonster(Eid, UnitId, Num)
    Num = Num or 1
    PrintTable({CreateTestMonster = {UnitId = UnitId, Num = Num}}, 2)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    GameMode.EMGameState.EventMgr:GMCreateTestMonster(Eid, UnitId, Num)
end

function Component:GM_CreatePhantom(Eid, RoleId, Num, BTIndex,Level, SkipInitWaitCheck, ForceSync, WeaponId)
    Num = tonumber(Num or 1)
    BTIndex = tonumber(BTIndex or 1)
    RoleId = tonumber(RoleId)
    WeaponId = tonumber(WeaponId)
    local MeleeWeapon, RangedWeapon = {}, {}
    local GetWeaponType = function(WeaponId)
        if not WeaponId or not DataMgr.BattleWeapon[WeaponId] then return nil end
        local WeaponTags = DataMgr.BattleWeapon[WeaponId].WeaponTag
        if not WeaponTags then return nil end
        for _, tag in ipairs(WeaponTags) do
            if tag == "Melee" then 
                return "Melee"
            elseif tag == "Ranged" then  
                return "Ranged" 
            end
        end
        return nil
    end
    local WeaponType = GetWeaponType(WeaponId)
    if WeaponType == "Melee" then
        MeleeWeapon = { WeaponId = WeaponId }
    elseif WeaponType == "Ranged" then
        RangedWeapon = { WeaponId = WeaponId }
    end

    PrintTable({CreatePhantom = {RoleId = RoleId, Num = Num, BTIndex = BTIndex, Level = Level, WeaponId = WeaponId}}, 2)

    local Player = self:GetEntity(Eid)
    assert(Player, self:ShowEidError(Eid))
    for i=1, Num do
        Player:CreatePhantom(RoleId, BTIndex, nil, {IsSpawnByGM=true, SkipInitWaitCheck = SkipInitWaitCheck, ForceSync = ForceSync, MeleeWeapon = MeleeWeapon, RangedWeapon = RangedWeapon}, Level)
    end
end

function Component:GM_ClearPhantoms(Eid)
    local Player = self:GetEntity(Eid)
    assert(Player, self:ShowEidError(Eid))
    UE4.UPhantomFunctionLibrary.CancelAllPhantom(Player, EDestroyReason.GM)
end

function Component:GM_CreateMechanismSummon(Eid, UnitId, Num)
    Num = Num or 1
    PrintTable({CreateMechanismSummon = {UnitId = UnitId, Num = Num}}, 2)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    GameMode.EMGameState.EventMgr:GMCreateMechanismSummon(Eid, UnitId, Num)
end

function Component:GM_KillMonster(UseCommandEid, Eid)
    if Eid then
        if tonumber(Eid) then
            self:BattleOnDead(tonumber(Eid), UseCommandEid, 0,EDeathReason.GMKill)
        elseif Eid == "self" then
            self:BattleOnDead(UseCommandEid, UseCommandEid, 0,EDeathReason.GMKill)
        end
    else
        local Entities = self:GetAllEntities()
        local Source = self:GetEntity(UseCommandEid)
        for EntityID, Entity in pairs(Entities) do
            if Entity and Entity.IsMonster and Entity:IsMonster() and Source:IsEnemy(Entity) then
                self:BattleOnDead(EntityID, UseCommandEid, 0,EDeathReason.GMKill)
            end
        end
    end
end

function Component:GM_KillAllPhantoms()
    local Entities = self:GetAllEntities()
    for EntityID, Entity in pairs(Entities) do
        if Entity and Entity.IsPhantom and Entity:IsPhantom() then
            self:BattleOnDead(EntityID, EntityID, 0, EDeathReason.GMKill)
        end
    end
end

function Component:GM_SetMonsterCrouch(Eid, IsCrouching)
    local Entities = self:GetAllEntities()
    for EntityID, Entity in pairs(Entities) do
        if Entity.Eid == Eid and Entity.EMAnimInstance then
            -- Entity.PlayerAnimInstance.IsCrouching = IsCrouching
            Entity:SetCrouch(IsCrouching)
        end
    end
end

function Component:GM_RecoverySelf(UseCommandEid)
    self:Recovery(UseCommandEid)
end

function Component:GM_TeleportRecoverySelf(TargetEid, LocX, LocY, DelayTime)

    local Location = FVector(LocX, LocY, 0)
    local Rotation = FRotator(0, 0, 0)
    self:TeleportRecovery(TargetEid, Location, Rotation, DelayTime)
end

function Component:GM_MaxBullet(Eid)
    local Target = self:GetEntity(Eid)
    assert(Target, self:ShowEidError(Eid))
    local Change = 1000000
    if Target.RangedWeapon then
        Target.RangedWeapon:SetAttr("BulletMax", Change)
        Target:AddBullet(Change, EGetBulletReason.GMBullet)
    end
end

function Component:GM_MaxMagazineBullet(Eid)
    local Target = self:GetEntity(Eid)
    assert(Target, self:ShowEidError(Eid))

    local Change = 1000000
    Target.RangedWeapon:SetAttr("MagazineCapacity", Change)
    Target.RangedWeapon:AddMagazineBullet(Change)
end

function Component:GM_MaxAttack(Eid)
    local Target = self:GetEntity(Eid)
    assert(Target, self:ShowEidError(Eid))

    local Attribute = Target:GetAttr("Attribute")
    local AttrName = "ATK_" .. Attribute
    local Change = 10000000 - Target:GetAttr("ATK")
    
    Target:SetAddAttr(AttrName, "GM", Change)
    Target:CalcATK()
end

function Component:GM_MaxDefence(Eid)
    local Target = self:GetEntity(Eid)
    assert(Target, self:ShowEidError(Eid))

    Target:SetAddAttr("DEF", "GM", nil)
    local Change = 1000000 - Target:GetAttr("DEF")
    Target:SetAddAttr("DEF", "GM", Change)
end

function Component:GM_MaxSp(Eid)
    local Target = self:GetEntity(Eid)
    assert(Target, self:ShowEidError(Eid))

    local Sp = 1000000
    Target:SetAttr("MaxSp", Sp)
    Battle(Target):AddSpToTarget(Target, Target, Sp, EChangedSpReason.GMMaximumSp)
end

function Component:GM_AddSp(Eid, Value)
    local Target = self:GetEntity(Eid)
    assert(Target, self:ShowEidError(Eid))

    Battle(Target):AddSpToTarget(Target, Target, Value, EChangedSpReason.GMAddSp)
end

function Component:GM_MaxES(Eid)
    local Target = self:GetEntity(Eid)
    assert(Target, self:ShowEidError(Eid))

    Target:SetAddAttr("MaxES", "GM", nil)
    local Change = 10000000 - Target:GetAttr("MaxES")
    Target:SetAddAttr("MaxES", "GM", Change)
    Battle(self):AddEnergyShield(Target, Target, Target:GetAttr("MaxES"), false, false, nil)
end

function Component:GM_AddES(Eid, Value)
    local Target = self:GetEntity(Eid)
    assert(Target, self:ShowEidError(Eid))

    Battle(Target):AddEnergyShield(Target, Target, Value, false, false, "")
end

function Component:GM_MaxHp(Eid)
    local Target = self:GetEntity(Eid)
    assert(Target, self:ShowEidError(Eid))

    Target:SetAddAttr("MaxHp", "GM", nil)
    local Change = 10000000 - Target:GetAttr("MaxHp")
    Target:SetAddAttr("MaxHp", "GM", Change)
    Target:AddHp(Target:GetAttr("MaxHp"))
end

function Component:GM_AddHp(Eid, Value)
    local Target = self:GetEntity(Eid)
    assert(Target, self:ShowEidError(Eid))

    Target:AddHp(Value)
end

function Component:GM_NoCDForSkill(Eid)
    local Target = self:GetEntity(Eid)
    assert(Target, self:ShowEidError(Eid))

    for SkillId, Skill in pairs(Target.Skills) do
        Skill:ResetSkillCd()
        Skill.SkillCd = nil
    end
end

function Component:GM_UpdateMonSkillCd()
    local Entities = self:GetAllEntities()

    for Eid, Ent in pairs(Entities) do
        if Ent and Ent:IsMonster() and not Ent:IsDead() and Ent.Skills then
            for SkillId, Skill in pairs(Ent.Skills) do
                if Skill.SkillCd then
                    Skill.SkillCd = nil
                else
                    Skill.SkillCd = Skill.Data.CD
                end
                Skill:ResetSkillCd()
            end
        end
    end
end

function Component:GM_MonsterMaxHp()
    local Entities = self:GetAllEntities()
    for Eid, Entity in pairs(Entities) do
        if Entity and Entity:IsMonster() then
            self:GM_MaxHp(Eid)
        end
    end
end

function Component:GM_AddBuff(Eid, BuffId, LastTime, Value)
    local Target = self:GetEntity(tonumber(Eid))
    assert(Target, self:ShowEidError(Eid))
    
    if not Value then
        Value = self:CalcUserProperty(Target, Target, 'ATK', nil)
    end
    self:AddBuffToTarget(Target, Target, BuffId, LastTime, Value, nil)
end

function Component:GM_RemoveBuff(Eid, BuffId)
    local Target = self:GetEntity(tonumber(Eid))
    assert(Target, self:ShowEidError(Eid))
    
    local Success = self:RemoveBuffFromTarget(Target, Target, BuffId, false, -1)
    if Success then
        ScreenPrint("移除Buff:" .. tostring(BuffId) .. "成功!")
    else
        ScreenPrint("移除Buff:" .. tostring(BuffId) .. "失败!")
    end
end

function Component:GM_AddMonsterBuff(BuffId, LastTime, Value)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    GameMode.GMMonsterBuff[BuffId] = BuffId
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    for Eid, Target in pairs(GameState.MonsterMap) do
        assert(Target, self:ShowEidError(Eid))
        if Target:GetCamp() == ECampName.Monster then
            if not Value then
                Value = self:CalcUserProperty(Target, Target, 'ATK', nil)
            end
            if not self:FindBuffById(Target, BuffId, 0, false) then
                self:AddBuffToTarget(Target, Target, BuffId, LastTime, Value, nil)
            end
        end
    end
end

function Component:GM_RemoveMonsterBuff(BuffId)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    GameMode.GMMonsterBuff[BuffId] = nil
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    for Eid, Target in pairs(GameState.MonsterMap) do
        assert(Target, self:ShowEidError(Eid))
        if Target:GetCamp() == ECampName.Monster then
            local Success = self:RemoveBuffFromTarget(Target, Target, BuffId, false, -1)
            if not Success then
                ScreenPrint("Eid为: ".. Target.eid.."移除Buff:" .. tostring(BuffId) .. "失败!")
            end
        end
    end
end

function Component:GM_ChangeCreatureSpeed(Speed)
    Const.SkillCreatureSpeed = Speed
    require("EMLuaConst").SkillCreatureSpeed = Const.SkillCreatureSpeed
end

function Component:GM_ReuseSkill(UnitId, SkillIndex)
    local Entities = self:GetAllEntities()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    for eid, ent in pairs(Entities) do
        if ent and ent.IsMonster and ent:IsMonster() and ent.UnitId == tonumber(UnitId) then
            ent:StopBT("GM")
            ent:BBSetTarget(self:GetCharacter(Player.Eid))
            ent:ReuseSkill(tonumber(SkillIndex))
        end
    end
end

function Component:GM_FireDanmaku(Eid, DanmakuTemplateId, Duration)
    local Target = self:GetEntity(tonumber(Eid))
    assert(Target, self:ShowEidError(Eid))
    Target:FireDanmaku(DanmakuTemplateId, Duration, "", 0, false, FTransform())
end

function Component:GM_TestBattle(Eid)
    -- if SSS and not SSS.ServerInitSuccess then
    --     PrintTable({GM_TestBattle=1,SSS=SSS})
    --     SSS.ServerInitSuccess = true
    -- end
    -- local Target = self:GetEntity(tonumber(Eid))
    -- assert(Target, self:ShowEidError(Eid))

    -- -- -- local Target = self:GetEntity(tonumber(Eid))
    -- -- local HitResults = TArray(FHitResult)
    -- -- local HitResult = FHitResult()
    -- -- local Start = Target:K2_GetActorLocation()
    -- -- Start = Target:GetActorForwardVector() * -500 + Start
    -- -- local End = Target:GetActorForwardVector() * 1000 + Start
    -- -- UE4.UKismetSystemLibrary.LineTraceSingle(self, Start, End, ETraceTypeQuery.TraceEnemyVision, false, nil, 2, HitResult, true, Color, Color, 99999.0)
    -- -- PrintTable({Actor=HitResult.Actor})
    -- -- UE4.UKismetSystemLibrary.LineTraceMulti(self, Start, End, ETraceTypeQuery.TraceSkillCreatureBlock, false, nil, 2, HitResults, true, Color, Color, 99999.0)
    -- -- for k,v in pairs(HitResults) do
    -- --     PrintTable({Ac=v.Actor,k=k})
    -- -- end

    -- local A = TArray(0)
    -- for i=1,100 do
    --     A:Add((i * 7)%100)
    -- end
    -- MiscUtils.PrintArray(A, "Before")
    -- local B = Target:Test11(A)
    -- MiscUtils.PrintArray(B, "After")
    local Target = self:GetEntity(tonumber(Eid))
    assert(Target, self:ShowEidError(Eid))
    PrintTable({Target=Target})
    Target:SetAttr("MaxES", 0)
    Target:SetAttr("ES", 0)
    Target:SetAttr("MaxHp", 500)
    Target:SetAttr("Hp", 500)
    self:AddBuffToTarget(Target, Target, 903, -1, 0, nil)


end

function Component:GM_RecoverPlayer(PlayerEid, TargetEid, IsBegin, OverrideSpeed)
    PlayerEid = tonumber(PlayerEid)
    TargetEid = tonumber(TargetEid)
    IsBegin = string.lower(IsBegin) == "true"
    if OverrideSpeed then 
        OverrideSpeed = tonumber(OverrideSpeed)
    end
    self:RecoverOther(PlayerEid, TargetEid, IsBegin, {Speed = OverrideSpeed})
end


function Component:GM_AddMod(ModId, Eid, ModLevel, TargetType)
    local Player = self:GetEntity(tonumber(Eid))
    assert(Player, self:ShowEidError(Eid))
    local Target
    if TargetType then -- 1是角色 2是近战武器 3是远程武器 4是显赫
        if TargetType == 1 then
            Target = Player
        elseif TargetType == 2 then
            Target = Player.MeleeWeapon
        elseif TargetType == 3 then
            Target = Player.RangedWeapon
        elseif TargetType == 4 then
            Target = Player.UltraWeapon
        end
    end
    assert(Target, "无法获取到AddMod的对象")
    Target:SetAttrByMod(tonumber(ModId), ModLevel)
    local ModData = DataMgr.Mod[ModId]
    local PassiveEffects = ModData.PassiveEffects
    if PassiveEffects then
        for _, PassiveEffectId in pairs(PassiveEffects) do
            if TargetType == 1 then
                Player:AddPassiveEffectByRole(Player.CurrentRoleId, PassiveEffectId, 1)
            elseif TargetType == 2 then
                Player:AddPassiveEffectByWeapon(Player.MeleeWeapon, PassiveEffectId, 1)
            elseif TargetType == 3 then
                Player:AddPassiveEffectByWeapon(Player.RangedWeapon, PassiveEffectId, 1)
            elseif TargetType == 4 then
                Player:AddPassiveEffectByWeapon(Player.UltraWeapon, PassiveEffectId, 1)
            end
        end
    end
end

function Component:GM_AddPet(PetId)
    PetId = PetId or Const.DefaultBattlePet
    PetId = tonumber(PetId)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    Player:ServerSetBattlePetByBattlePetId(PetId, 1, false, true)
end

function Component:GM_AddPetAffix(AffixId)
    AffixId = tonumber(AffixId)
    if not DataMgr.PetEntry[AffixId] then
        return
    end
    local BattlePetId = DataMgr.PetEntry[AffixId].BattlePetID
    if not DataMgr.BattlePet[BattlePetId].PetType or DataMgr.BattlePet[BattlePetId].PetType ~= "Affix" then
        return
    end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    Player:ServerAddBattlePetAffix(AffixId, false)
end

function Component:GM_RemovePetAffix(AffixId)
    AffixId = tonumber(AffixId)
    if not DataMgr.PetEntry[AffixId] then
        return
    end
    local BattlePetId = DataMgr.PetEntry[AffixId].BattlePetID
    if not DataMgr.BattlePet[BattlePetId].PetType or DataMgr.BattlePet[BattlePetId].PetType ~= "Affix" then
        return
    end
    AffixId = tonumber(AffixId)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    Player:ServerRemoveAddBattlePetAffix(AffixId, false)
end

function Component:GM_RemovePet()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local BattlePet = Player.BattlePet
    if not BattlePet then
        return
    end
    Player:ServerRemoveBattlePet()
end

function Component:GM_ForbidDamage(_ForbidDamage)
    require("EMLuaConst").bForbidDamage = _ForbidDamage
end

function Component:GM_ForbidPlay(_ForbidPlay)
    require("EMLuaConst").bForbidPlay = _ForbidPlay
end

function Component:GM_DSShowDetails()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    if GameInstance.DSShowDetails then
        GameInstance.DSShowDetails = false
    else
        GameInstance.DSShowDetails = true
    end
end

function Component:GM_EnableSkillPrediction(bEnableSkillPrediction)
    DebugPrint("gmy@BattleGMLogic Component:GM_EnableSkillPrediction", bEnableSkillPrediction)
    self.bEnableSkillPrediction = bEnableSkillPrediction
end

function Component:GM_ForceSimPredictionFailed(bSimPredictionFailed)
    DebugPrint("gmy@BattleGMLogic Component:GM_ForceSimPredictionFailed", bSimPredictionFailed)
    self.bSimPredictionFailed = bSimPredictionFailed
end

function Component:GM_Hotfix(...)
    local HotfixData = require "Datas.HotfixData"
    assert(HotfixData.index, "需要填写HotfixData.index")
    assert(HotfixData.script, "需要填写HotfixData.script")
    local UnLuaHotReload = require "UnLuaHotReload"
    require("HotFix").ExecHotFix(HotfixData.index, HotfixData.script)
    GWorld.HotfixDataIndex = HotfixData.index
end

function Component:GM_ReuseSkill(UnitId, SkillIndex, Eid)
    local Entities = self:GetAllEntities()
    for eid, ent in pairs(Entities) do
        if ent and ent.IsMonster and ent:IsMonster() and ent.UnitId == tonumber(UnitId) then
            ent:StopBT("GM")
            ent:BBSetTarget(self:GetCharacter(Eid))
            ent:ReuseSkill(tonumber(SkillIndex))
        end
    end
end


function Component:GM_ChangeDSMonsterFramingNodeConfig(PlatformType,PlatformQualityLevel,MonQualityLevel,Key,Value)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    if not GameInstance or not GameInstance.ClientActiveMonsterNumConfig then 
        return
    end
    local TMap1 = GameInstance.ClientActiveMonsterNumConfig:FindRef(PlatformType)
    if not TMap1 then return end
    local TMap2 = TMap1.ConfigMap:FindRef(PlatformQualityLevel)
    if not TMap2 then return end
    local RealConfig = TMap2.QualityLevelToConfig:FindRef(MonQualityLevel)
    if not RealConfig or not RealConfig[Key] then return end
    RealConfig[Key] = Value
end
return Component
