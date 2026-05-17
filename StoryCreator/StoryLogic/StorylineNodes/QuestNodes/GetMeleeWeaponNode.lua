local GetMeleeWeaponNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')

function GetMeleeWeaponNode:Execute(Callback)
    if self.Context.CurrentRole then
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "GetMeleeWeaponNode配置错误", "该节点依赖角色是军械库角色")
    end

    local GameInstance = GWorld.GameInstance
    self.ListenTarget = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    if self.ListenTarget and self.ListenTarget.MeleeWeapon then
        Callback()
        return
    else
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            return
        end
        local RefreshWeapon = function(Ret)
            if Ret ~= 0 then
                return
            end
            local InfoForInit = AvatarUtils:GetDefaultBattleInfo(Avatar)
            self.ListenTarget:InitCharacterInfo(InfoForInit)
            Callback()
        end
        Avatar:AddDefaultMeleeWeapon(RefreshWeapon)
    end
end

return GetMeleeWeaponNode