---@class FSwitchToMasterComponent
local FSwitchToMasterComponent = {}
local ClassPath = '/Game/BluePrints/Common/EMNiagaraFunctionLibrary'

---@return FSwitchToMasterComponent
function FSwitchToMasterComponent:New(MasterType, TalkTaskData)
    DebugPrint("FSwitchToMasterComponent@ New")
	local SwitchToMasterComponent = setmetatable({}, {
        __index = FSwitchToMasterComponent
    })
    SwitchToMasterComponent.TalkTaskData = TalkTaskData
    SwitchToMasterComponent.MasterType = MasterType
    return SwitchToMasterComponent
end

function FSwitchToMasterComponent:Execute()
    DebugPrint("FSwitchToMasterComponent@ 切换为主角")
    local Player = UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if not IsValid(Player) then
        local Message = "FSwitchToMasterComponent:Execute(), 对话节点切换主角时，玩家PlayerCharacter无效\n"
        local Title = "PlayerCharacter无效"
        UStoryLogUtils.PrintToFeiShu(self, UE.EStoryLogType.Talk, Title, Message)
        DebugPrint("lhr@玩家PlayerCharacter无效\n")
        return
    end
    if Player.ChangeRoleTimer then
        Player:RemoveTimer(Player.ChangeRoleTimer)
        Player.ChangeRoleTimer = nil
    end
    --无缝转入则不执行
    if self.TalkTaskData.BlendInTime == -1 then
        return
    end
    if self.MasterType == 'None' then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then  
        GWorld.logger.error("FSwitchToMasterComponent@没有正常登录")
        Avatar = {
            Sex = 0,
            WeitaSex = 1
        }
    end
    local RealMasterType, MasterGender, MasterRoleId
    if self.MasterType == "Player" then
        MasterGender = Avatar.Sex
        RealMasterType = "PlayerLight"
    else
        MasterGender = Avatar.WeitaSex
    end
    RealMasterType = RealMasterType or self.MasterType
    local MasterInfo = DataMgr.Player2RoleId[RealMasterType]
    if not MasterInfo then
        GWorld.logger.error("FSwitchToMasterComponent@没有找到对应的主角信息，请检查导表"..RealMasterType)
        return 
    end
    local GenderInfo = MasterInfo[MasterGender]
    if not GenderInfo then 
        GWorld.logger.error("FSwitchToMasterComponent@对应性别没有角色，请检查导表")
        return 
    end
    MasterRoleId = GenderInfo
    print(_G.LogTag, "FSwitchToMasterComponent@ChangeToMaster", MasterRoleId, MasterGender)

    -- 临时存储角色当前状态
    Player.HeroTempInfo = {
        RoleInfo = {
            PlayerHp = Player:GetAttr("Hp"),
            PlayerSp = Player:GetAttr("Sp"),
            PlayerES = Player:GetAttr("ES"),
        },
        RangedWeapon = {
            BulletNum = Player.RangedWeapon and Player.RangedWeapon:GetAttr("BulletNum") or 0,
            MagazineBulletNum = Player.RangedWeapon and Player.RangedWeapon:GetAttr("MagazineBulletNum") or 0,
        },
    }
    Avatar.HeroTempInfo = Player.HeroTempInfo

    if Player:GetController():GetClass():GetName() == "TalkAIController" then
        self.TalkAIController = Player:GetController()
        self.PlayerController = UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
        self.TalkPawn = self.PlayerController.Pawn
        self.TalkAIController:UnPossess(Player)
        self.PlayerController:Possess(Player)
    end
    Player:EnableRimLightModel(false)
    local bUseSkin = EMCache:Get("AutoFashion") or false
    local DefaultAppearanceSuit = {AccessorySuit = Player.CharacterFashion:GetDefaultAccessorySuit()}
    local AvatarInfo = {
        AppearanceSuit = bUseSkin and self:GetServerAppearanceSuitByCharId(MasterRoleId) or DefaultAppearanceSuit,
    }
    Player:ChangeRole(MasterRoleId, AvatarInfo)
    Player:RealChangeUsingWeapon(nil)
    Player:BanSkills()
    --播放切换角色特效
    Player:ChangeRoleEffect()
    local BodyType = Player:GetBattleCharBodyType()
    Player.FXComponent:PlayEffectByIDParams(401, {
        NotAttached = true,
        scale = Const.BattleCharTagVXScaleTable[BodyType],
    })
    if self.TalkAIController then
        self.PlayerController:Possess(self.TalkPawn)
        self.TalkAIController:Possess(Player)
        self.TalkAIController, self.PlayerController, self.TalkPawn = nil, nil, nil
    end
end

function FSwitchToMasterComponent:GetServerAppearanceSuitByCharId(CharId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return nil end
    for key,Char in pairs(Avatar.Chars) do
        if Char.CharId == CharId then
            local AppearanceSuit = Char:DumpAppearanceSuit(Avatar)
            return AppearanceSuit
        end
    end
    return nil
end

function FSwitchToMasterComponent:Resume()
    DebugPrint("FSwitchToMasterComponent@FSwitchToMasterComponent 解除切换主角")
    --无缝转出则不执行
    if self.TalkTaskData.BlendOutTime == -1 then
        return
    end
    local Player = UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if not Player.HeroTempInfo then
        return
    end
    if not IsValid(Player) then
        local Message = "FSwitchToMasterComponent:Resume(), 对话节点切换主角时，玩家PlayerCharacter无效\n"
        local Title = "PlayerCharacter无效"
        UStoryLogUtils.PrintToFeiShu(self, UE.EStoryLogType.Talk, Title, Message)
        DebugPrint("FSwitchToMasterComponent:Resume(), 玩家PlayerCharacter无效\n")
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then  
        DebugPrint("FSwitchToMasterComponent:Resume(), Avatar无效\n")
        return
    end
    
    if Player:GetController():GetClass():GetName() == "TalkAIController" then
        if not self.SeamlessBlendOut then
            self.TalkAIController = Player:GetController()
            self.PlayerController = UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
            self.TalkPawn = self.PlayerController.Pawn
            self.TalkAIController:UnPossess(Player)
            self.PlayerController:Possess(Player)
        end
    end
    Player:UnBanSkills()
    Player:RecoverHeroInfo()
    Player:ChangeRole(nil, AvatarUtils:GetDefaultBattleInfo(GWorld:GetAvatar()))
    if Player.RangedWeapon and Player.RangedWeapon:GetAttr("MagazineBulletNum") == 0 then
        Player.RangedWeapon:SetWeaponState("NoBullet", true)
    end
    --播放切换角色特效
    Player.ChangeRoleTimer = Player:AddTimer(0.1, function()
        Player:ChangeRoleEffect()
        local BodyType = Player:GetBattleCharBodyType()
        Player.FXComponent:PlayEffectByIDParams(401, {
            NotAttached = true,
            scale = Const.BattleCharTagVXScaleTable[BodyType],
        })
        Player.ChangeRoleTimer = nil
    end)
    if self.TalkAIController then
        self.PlayerController:Possess(self.TalkPawn)
        self.TalkAIController:Possess(Player)
        self.TalkAIController, self.PlayerController, self.TalkPawn = nil, nil, nil
    end
end

return FSwitchToMasterComponent