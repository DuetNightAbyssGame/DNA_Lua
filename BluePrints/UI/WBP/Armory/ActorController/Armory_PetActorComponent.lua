---@type Armory_ActorController
local M = {}

function M:Init()
    EventManager:AddEvent(EventID.OnArmoryShowPet,self,self.OnArmoryShowPet)
    EventManager:AddEvent(EventID.OnPetEffectCreatureCreated,self,self.OnPetEffectCreatureCreated)
end
---切换宠物模型
function M:ChangePetModel(Info,PlayCharacter,Params)
    self.CurrentPetInfo = Info
    self.RealChangePetModel = function()
        PlayCharacter = PlayCharacter or self.ArmoryPlayer
        PlayCharacter:ServerRemoveBattlePet()
        local AudioManager = AudioManager(self.ViewUI)
        if(Info and Info.PetId)then
            if Info.Type == "BattlePass" then
                self:CreatePetEffectCreature(Info.PetId,Params,true)
            else
                self.WaitForServerSetBattlePet = true
                PlayCharacter:ServerSetBattlePet(Info.PetId, Info.BattlePetLevel or 1, false, TArray(0))
            end
            if(not AudioManager:IsSoundPlaying(self.ViewUI, "PetIdle"))then
                AudioManager:PlayUISound(self.ViewUI, "event:/ui/armory/open_pet_idle", "PetIdle", nil)
            end
            self:PlayPetVoice("vo_hello")
            self:HidePetActor("ActorController_ChangeViewTarget",false)
        else
            --停止播放宠物待机音效
            AudioManager:SetEventSoundParam(self.ViewUI, "PetIdle", {ToEnd = 1})
        end
    end
    if(self.bWaitForNotifyToChangePet)then
        return
    else
        self.RealChangePetModel()
    end
end

---播放宠物音频
function M:PlayPetVoice(VoiceStr)
    local PetId = self.CurrentPetInfo and self.CurrentPetInfo.PetId
    local PetData = DataMgr.Pet[PetId]
    if(PetData)then
        --AudioManager(self.ViewUI):StopSound(self.ArmoryPlayer, "ArmoryPetVoice")
        AudioManager(self.ArmoryPlayer):PlayPetVoice(self.ArmoryPlayer, PetData.PetNameTag, VoiceStr, "ArmoryPetVoice")
    end
end

---显示宠物回调
function M:OnArmoryShowPet()
    if(self.bWaitForNotifyToChangePet)then
        self.bWaitForNotifyToChangePet = false
        self.bShouldSetPetFresnel = true
        self.RealChangePetModel()
    end
end

---宠物创建完成回调
function M:OnPetEffectCreatureCreated(BattlePet,Owner)
    if(not self.WaitForServerSetBattlePet or not self.ViewUI or not IsValid(self.ArmoryPlayer) or Owner ~= self.ArmoryPlayer)then
        return
    end
    if(self.ArmoryPlayer:GetBattlePet() ~= BattlePet)then
        self:HidePetActor(self.UIName,true)
        return
    end
    self.WaitForServerSetBattlePet = false
    --TODO：如果通知不按顺序依然有概率不显示，后面改成传Callback
    local BattlePet = self.ArmoryPlayer:GetBattlePet()
    if(BattlePet and BattlePet.EffectCreature)then
        BattlePet.EffectCreature:SetActorHiddenInGame(false)
    end
    if(self.bShouldSetPetFresnel)then
        self.bShouldSetPetFresnel = false
        self:SetPetFresnel(self.ArmoryPlayer)
    end
end

---获取宠物Actor
function M:GetPetActor()
    if(IsValid(self.ArmoryPlayer))then
        local BattlePet = self.ArmoryPlayer:GetBattlePet()
        return BattlePet and BattlePet.EffectCreature
    end
end

---隐藏宠物
function M:HidePetActor(Tag,IsHidden)
    if(IsValid(self.ArmoryPlayer))then
        local BattlePet = self.ArmoryPlayer:GetBattlePet()
        if(BattlePet)then
            BattlePet:HideBattlePet(Tag,IsHidden)
        end
    end
    if(IsValid(self.EffectCreature))then
        self.EffectCreature:SetActorHiddenInGame(IsHidden)
    end
end

---播放宠物进场特效
function M:SetPetFresnel(Player)
    local BattlePet = Player:GetBattlePet()
    local EffectCreature = BattlePet and BattlePet.EffectCreature
    if(EffectCreature and EffectCreature.FashionComponent)then
        local FresnelColor = FLinearColor(1,0.1,0)
        local FresnelColorRange = 1
        local FresnelColorStrength = 50
        local FresnelPriority = 999
        local Duration = 1
        local FresnelColorCurve = LoadObject("CurveLinearColor'/Game/Asset/Effect/Curve/PostCurve/FX_PostCurve_10.FX_PostCurve_10'")
        local bImmediately = false
        EffectCreature.FashionComponent:SetFresnel(EffectCreature,FresnelColor,FresnelColorRange,FresnelColorStrength,FresnelPriority,Duration,FresnelColorCurve,bImmediately)
        CommonUtils:SetActorTickableWhenPaused(EffectCreature,true)
        self.ArmoryHelper:AddTimer(Duration,function()
            self:RemovePetFresnel(Player)
        end,false,0,"DelayRemoveFresnel",true)
        if(self.OnPlayPetFresnel)then
            self.OnPlayPetFresnel(self.EventObj)
        end
    end
end

---停止宠物进场特效
function M:RemovePetFresnel(Player)
    local BattlePet = Player:GetBattlePet()
    local EffectCreature = BattlePet and BattlePet.EffectCreature
    if(EffectCreature and EffectCreature.FashionComponent)then
        EffectCreature.FashionComponent:RemoveFresnel(EffectCreature)
    end
end

function M:CreatePetEffectCreature(PetId,Params,bForceCreate)
    Params = Params or {}
    local PetData = DataMgr.Pet[PetId]
    if self.EffectCreatureId and self.EffectCreatureId == PetData.EffectCreatureId and not bForceCreate then
        return
    elseif self.EffectCreatureId and (self.EffectCreatureId ~= PetData.EffectCreatureId or bForceCreate) then
        if self.EffectCreature then
            self.EffectCreature:SetActorHiddenInGame(true)
            self._Player:RemoveEffectCreature(self.EffectCreatureId)
        end
    end
    self.EffectCreatureId = PetData.EffectCreatureId
    self._Player = UGameplayStatics.GetPlayerCharacter(self.ViewUI, 0)
    self.EffectCreature = self._Player:CreateEffectCreature(self.EffectCreatureId, FTransform(), true, "Root")   --ArmoryPetOffset:  FVector(0,30,105)
    self.EffectCreature:SetOwner(self.ArmoryPlayer)
    self.EffectCreature.OwnerPlayer = self.ArmoryPlayer
    self.EffectCreature:UpdateTickableWhenPaused()
    if not self.ActorTransform then
        self.ActorTransform = self.ArmoryPlayer:GetTransform()
        self.EffectCreature:K2_SetActorTransform(FTransform(self.ActorTransform.Rotation, self.ActorTransform.Translation ,self.ActorTransform.Scale3D), false, nil, false)
    end
    
    --偏移到UI需要的位置  /  FVector(0,63,25)
    local Location = self.ActorTransform.Translation
    Location = UE4.UKismetMathLibrary.TransformLocation(self.ActorTransform, Params.Location or FVector(0,-40,25))
    local Scale = Params.Scale or self.ActorTransform.Scale3D
    local Rotation = self.ActorTransform.Rotation
    if(Params.Rotation)then
        Rotation = UE4.UKismetMathLibrary.TransformRotation(self.ActorTransform, Params.Rotation):ToQuat()
    end

    self.EffectCreature:K2_SetActorTransform(FTransform(Rotation,Location,Scale), false, nil, false)

    self.EffectCreature:SetActorHiddenInGame(false)
    self.EffectCreature.SkeletalMesh:SetTickableWhenPaused(true)
end

function M:DestroyPetEffectCreature()
    if self.EffectCreature then
        self.EffectCreature:SetActorHiddenInGame(true)
        self._Player:RemoveEffectCreature(self.EffectCreatureId)
        self.EffectCreatureId = nil
        self.EffectCreature = nil
    end
end

function M:PetLvUpOrBreakUp()
    local ArmoryPet = self:GetPetActor()
    if(not ArmoryPet)then
        return
    end
    local MeshLocation = ArmoryPet.SkeletalMesh:K2_GetComponentLocation()
    if(ArmoryPet)then
        ArmoryPet.FXComponent:PlayEffectByIDParams(305, {
            bTickEvenWhenPaused = true, 
            UseAbsoluteLocation = true, 
            Location = {MeshLocation.X, MeshLocation.Y, MeshLocation.Z}
        })
    end
end

function M:Component_OnClosed()
    self:HidePetActor(self.UIName,true)
end

function M:Component_OnDestruct()
    EventManager:RemoveEvent(EventID.OnArmoryShowPet,self)
	EventManager:RemoveEvent(EventID.OnPetEffectCreatureCreated,self)
end

function M:Component_DestroyActors()
    self.CurrentPetInfo = nil
    self:DestroyPetEffectCreature()
end


return M