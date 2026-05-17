local Component = {}

function Component:OnAddBuff(BuffId,Duration,BuffLevel)
    local Battle = Battle(GWorld.GameInstance)
    if not Battle then return end 
    BuffLevel = BuffLevel or 1
    -- 副本中不实时添加
    if self:IsInDungeon() or self:IsInHardBoss() then 
        return 
    end

    self.logger.debug("OnAddBuff", BuffId,Duration,BuffLevel)
    local PlayerController = UE.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
    if PlayerController then 
        local PlayerCharacter = PlayerController:GetMyPawn()
        if IsAuthority(PlayerCharacter) then 
            Battle:AddAvatarBuffToTarget(PlayerCharacter, PlayerCharacter, BuffId, -1, 0, BuffLevel)

            -- 处理所有魅影
            local AllPhantomTeammates = PlayerCharacter:GetPhantomTeammates(false)
            if AllPhantomTeammates then
                for i = 1, AllPhantomTeammates:Length() do
                    local Phantom = AllPhantomTeammates:GetRef(i)
                    if Phantom and IsValid(Phantom) then
                        Battle:AddAvatarBuffToTarget(Phantom, Phantom, BuffId, -1, 0, BuffLevel)
                    end
                end
            end

            -- 处理所有已有召唤物
            local AllSummon = PlayerCharacter:GetAllDirectorSummon()
            AllSummon = AllSummon:ToTable()
            for _, SummonEid in pairs(AllSummon) do
                local Summon = Battle:GetEntity(SummonEid)
                if not Summon or not Summon:IsMonster() then
                    goto continue
                end
                if not UBlueprintGameplayTagLibrary.HasTag(Summon.GameplayTags, URuntimeCommonFunctionLibrary.BPRequestGameplayTag("Player.RealSummon", false), false) then
                    goto continue
                end
                local MonsterConfig = DataMgr.Monster[Summon.UnitId]
                if not MonsterConfig or MonsterConfig.IgnoreBuff then
                    goto continue
                end
                Battle:AddAvatarBuffToTarget(Summon, Summon, BuffId, -1, 0, BuffLevel)
                ::continue::
            end
        end
    end
end

function Component:OnRemoveBuff(BuffId)
    local Battle = Battle(GWorld.GameInstance)
    if not Battle then return end 

    -- 副本中不实时添加
    if self:IsInDungeon() or self:IsInHardBoss() then 
        return 
    end

    self.logger.debug("OnRemoveBuff", BuffId)
    local PlayerController = UE.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
    if PlayerController then 
        local PlayerCharacter = PlayerController:GetMyPawn()
        if IsAuthority(PlayerCharacter) then 
            Battle:RemoveAvatarBuffFromTarget(PlayerCharacter, PlayerCharacter, BuffId, false, -1)

            -- 处理所有魅影
            local AllPhantomTeammates = PlayerCharacter:GetPhantomTeammates()
            if AllPhantomTeammates then
                for i = 1, AllPhantomTeammates:Length() do
                    local Phantom = AllPhantomTeammates:GetRef(i)
                    if Phantom and IsValid(Phantom) then
                        Battle:RemoveAvatarBuffFromTarget(Phantom, Phantom, BuffId, false, -1)
                    end
                end
            end
            -- 处理所有已有召唤物
            local AllSummon = PlayerCharacter:GetAllDirectorSummon()
            AllSummon = AllSummon:ToTable()
            for _, SummonEid in pairs(AllSummon) do
                local Summon = Battle:GetEntity(SummonEid)
                if not Summon or not Summon:IsMonster() then
                    goto continue
                end
                if not UBlueprintGameplayTagLibrary.HasTag(Summon.GameplayTags, URuntimeCommonFunctionLibrary.BPRequestGameplayTag("Player.RealSummon", false), false) then
                    goto continue
                end
                local MonsterConfig = DataMgr.Monster[Summon.UnitId]
                if not MonsterConfig or MonsterConfig.IgnoreBuff then
                    goto continue
                end
                Battle:RemoveAvatarBuffFromTarget(Summon, Summon, BuffId, false, -1)
                ::continue::
            end
        end
    end
end

function Component:OnBuffFinished(BuffId)
    self.logger.debug("OnBuffFinished", BuffId)
    local Battle = Battle(GWorld.GameInstance)
    if not Battle then return end 

    -- 副本中不实时添加
    if self:IsInDungeon() or self:IsInHardBoss() then 
        return 
    end

    local PlayerController = UE.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
    if PlayerController then 
        local PlayerCharacter = PlayerController:GetMyPawn()
        if IsAuthority(PlayerCharacter) then 
            Battle:RemoveAvatarBuffFromTarget(PlayerCharacter, PlayerCharacter, BuffId, false, -1)

            -- 处理所有魅影
            local AllPhantomTeammates = PlayerCharacter:GetPhantomTeammates()
            if AllPhantomTeammates then
                for i = 1, AllPhantomTeammates:Length() do
                    local Phantom = AllPhantomTeammates:GetRef(i)
                    if Phantom and IsValid(Phantom) then
                        Battle:RemoveAvatarBuffFromTarget(Phantom, Phantom, BuffId, false, -1)
                    end
                end
            end

            -- 处理所有已有召唤物
            local AllSummon = PlayerCharacter:GetAllDirectorSummon()
            AllSummon = AllSummon:ToTable()
            for _, SummonEid in pairs(AllSummon) do
                local Summon = Battle:GetEntity(SummonEid)
                if not Summon or not Summon:IsMonster() then
                    goto continue
                end
                if not UBlueprintGameplayTagLibrary.HasTag(Summon.GameplayTags, URuntimeCommonFunctionLibrary.BPRequestGameplayTag("Player.RealSummon", false), false) then
                    goto continue
                end
                local MonsterConfig = DataMgr.Monster[Summon.UnitId]
                if not MonsterConfig or MonsterConfig.IgnoreBuff then
                    goto continue
                end
                Battle:RemoveAvatarBuffFromTarget(Summon, Summon, BuffId, false, -1)
                ::continue::
            end
        end
    end

end

return Component