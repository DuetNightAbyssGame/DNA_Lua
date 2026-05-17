local PlayerSwitchWalkRunNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode')

function PlayerSwitchWalkRunNode:Init()
    self.Rate = 0.25
    self.Mode = "EWT_Normal"
end

function PlayerSwitchWalkRunNode:Execute()
	DebugPrint("------------ PlayerSwitchWalkRunNode Start------------------")
    ---@type BP_CharacterBase_C
    self.ListenTarget = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if not self.ListenTarget then 
        return
    end
    local WalkType = UE4.EWalkType[self.Mode]
	local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
    local SwitchWalk = UE4.ESkillName.SwitchWalk
    self.EnumSkillNameArray = TArray(0)

    local AnimInstance = self.ListenTarget.PlayerAnimInstance
    self.DefaultWalkState = AnimInstance.IsWalking
    self.DefaultWalkType = AnimInstance.WalkType
    self.SpeedRate = self.ListenTarget.SpeedRate
    if WalkType ~= -1 then
        self.ListenTarget:SetPlayerMaxMovingSpeed(self.Rate)
        AnimInstance.IsWalking = true
        self.ListenTarget:SetWalkType(WalkType)
        if WalkType == UE4.EWalkType.EWT_Normal then
            self.ListenTarget:SetEmoIdleEnabled(true)
        else
            self.ListenTarget:SetEmoIdleEnabled(false, true)
        end
        if PlayerController and not PlayerController:CheckSkillInActive(SwitchWalk) then
            self.EnumSkillNameArray:Add(SwitchWalk)
            PlayerController:InActiveSkills(self.EnumSkillNameArray, "Lock")
        end
    elseif self.Mode == "ToRun" then
        self.ListenTarget:RecoverPlayerMovingSpeed()
        AnimInstance.IsWalking = false
        self.ListenTarget:SetWalkType(UE4.EWalkType["EWT_Normal"])
        self.ListenTarget:SetEmoIdleEnabled(true)
        if(AnimInstance.RootMotionMode ~= ERootMotionMode.RootMotionFromMontagesOnly) then
            AnimInstance:SetRootMotionMode(ERootMotionMode.RootMotionFromMontagesOnly)
        end
        if PlayerController and PlayerController:CheckSkillInActive(SwitchWalk) then
            self.EnumSkillNameArray:Add(SwitchWalk)
            PlayerController:ActiveSkills(self.EnumSkillNameArray, "UnLock")
        end
    else
        error("PlayerSwitchWalkRunNode:Invalid mode")
    end
end

function PlayerSwitchWalkRunNode:OnQuestlineFail()
    if self.EnumSkillNameArray and (self.EnumSkillNameArray:Length() > 0) then
        local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
        if PlayerController then
            local WalkType = UE4.EWalkType[self.Mode]
            if WalkType ~= -1 then
                PlayerController:ActiveSkills(self.EnumSkillNameArray, "UnLock")
            elseif self.Mode == "ToRun" then
                PlayerController:InActiveSkills(self.EnumSkillNameArray, "Lock")
            end
        end
    end

    if not self.ListenTarget then 
        return 
    end
    local AnimInstance = self.ListenTarget.PlayerAnimInstance

    if not AnimInstance then
        return
    end
    local IsWalking = AnimInstance.IsWalking
    if self.DefaultWalkState ~= IsWalking then
        if self.DefaultWalkState then
            AnimInstance.IsWalking = true
        else
            AnimInstance.IsWalking = false
            if(AnimInstance.RootMotionMode ~= ERootMotionMode.RootMotionFromMontagesOnly) then
                AnimInstance:SetRootMotionMode(ERootMotionMode.RootMotionFromMontagesOnly)
            end
        end
    else
        if self.DefaultWalkState and self.DefaultWalkType ~= UE4.EWalkType[self.Mode] then
            self.ListenTarget:SetWalkType(self.DefaultWalkType)
        end
    end
    if (self.DefaultWalkState and self.DefaultWalkType == UE4.EWalkType.EWT_Normal) or (not self.DefaultWalkState) then
        self.ListenTarget:SetEmoIdleEnabled(true)
    else
        self.ListenTarget:SetEmoIdleEnabled(false, true)
    end
    self.ListenTarget:SetPlayerMaxMovingSpeed(self.SpeedRate)
end

return PlayerSwitchWalkRunNode
