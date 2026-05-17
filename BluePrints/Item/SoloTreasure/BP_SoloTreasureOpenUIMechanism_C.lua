--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@type BP_HardBossOpenMechanism_C
local M = Class( "BluePrints/Item/MiniGame/BP_OpenUIMechanism_C")

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self,Info)

    local Data = DataMgr.ExtractionTreasureTicket[self.UnitId]
    if Data then
        self.UnlockPoint = Data.UnlockPoint
    else
        self.UnlockPoint = 0
    end
    local ServerEntity = GWorld:GetServerEntity()
    self.DungeonObject = ServerEntity:GetDungeonObject()
    self.ChestInteractiveComponent:InitInteractiveComponent(self.Data.InteractiveId)
end

function M:OpenUI(PlayerId, NextStateId)
	if not self.DungeonObject then
        DebugPrint("error: No DungeonObject in BP_SoloTreasureOpenUIMechanism_C")
        return
    else
        self.MechanismInfo = self.DungeonObject.MechanismInfoMap[self.ServerUniqueId]
        if self.MechanismInfo and self.MechanismInfo.IsUnlock == false then
            -- 解锁机关
            local GameMode = UE4.UGameplayStatics.GetGameMode(self)
            GameMode:NotifyServerDungeonEvent("UnlockMechanism", self.ServerUniqueId)
            self.IsUnlocked = true
        end
        if (self.MechanismInfo.IsUsed == false) and (self.MechanismInfo.KillMonsterScore and self.MechanismInfo.KillMonsterScore < self.UnlockPoint) then
            DebugPrint("error: Cannot open UI in BP_SoloTreasureOpenUIMechanism_C")
            return
        end
	end

    M.Super.OpenUI(self, PlayerId, NextStateId)
end

function M:CloseMechanism(PlayerId, IsSuccess)
    M.Super.CloseMechanism(self, PlayerId)
    DebugPrint("ayff test BP_SoloTreasureOpenUIMechanism_C CloseMechanism PlayerId:",PlayerId," IsSuccess:",tostring(IsSuccess))
end

function M:GetCanOpen(PlayerEid)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        self.CanOpen = true
        return true
    end
    local Battle = Battle(self)
    if not Battle then
        return true
    end
    local Player = Battle:GetEntity(PlayerEid)
    if Player and Player:IsDead() then
        self.CanOpen = false
        return self.CanOpen
    end
    self.CanOpen = true
    return self.CanOpen
end

function M:StartInteractive(PlayerActor)
    if not self.bEnter then
        return
    end
    self.CanEnd = true
    --WaitCallBack:当有交互动画时，必须等回调完成才能重新发起交互
    print(_G.LogTag,"LXZ StartInteractive", self:IsCanInteractive(PlayerActor), self:IsCanPlayMontage(PlayerActor),  not self:IsForbidden(PlayerActor))
end

function M:ReceiveEndPlay(EndReason)
    M.Super.ReceiveEndPlay(self, EndReason)
end

function M:GetCostItemInfo()
    if self.MechanismInfo and self.MechanismInfo.IsUnlock == true then
        return nil
    end
    if self.CostItemInfo then
        return self.CostItemInfo
    end
    return nil
end

function M:IsForbidden()
 	if not self.DungeonObject then
        return false
    else
        self.MechanismInfo = self.DungeonObject.MechanismInfoMap[self.ServerUniqueId]
        if self.MechanismInfo.IsUsed == true then
            self.IsUsed = true
            return false
        elseif self.MechanismInfo.IsUnlock == false then
            self.CostItemInfo = {
                IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_26.T_Activity_SoloTreasure_26'",
                CostNum = self.UnlockPoint,
                PossessNum = self.DungeonObject.KillMonsterScore or 0,
                ConsumeTextKey = "UI_Armory_Trace_Cost",
            }
        elseif self.MechanismInfo.IsUnlock == true then
            self.CostItemInfo = nil
            return false
        end
	end
    return self:IsCostItemEnough()
end

function M:IsCostItemEnough()
    if not self.DungeonObject then
        return true
    end
    local CostItemNum = self.DungeonObject.KillMonsterScore or 0
    if not CostItemNum then
        return true
    end

    if CostItemNum < self.UnlockPoint then
        self.ChestInteractiveComponent:SetOverridenFailMsg(GText("UI_Extraction_TM_8"))
        return true
    else
        self.ChestInteractiveComponent:SetOverridenFailMsg(nil)
        return false
    end
end

function M:GetInteractiveName(Player)
    local Data = DataMgr.CommonUIConfirm[self.ChestInteractiveComponent.CommonUIConfirmID]
    -- 重设交互图标
    self.ChestInteractiveComponent:OverrideInteractiveIcon(Data.Icon)

    if self.IsUnlocked or (self.MechanismInfo and self.MechanismInfo.IsUnlock == true) then
        return GText("UI_Extraction_ChooseLottery")
    end
    return GText(Data.ConfirmText)
end

function M:ResetPauseState(UIName)
end

function M:HideMechanism(NeedCallBack, Reason, AlwaysShow)
end

function M:ShowMechanismWithCondition(ShowConditionId)
end

function M:OnActorReady(Info)
end

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

-- function M:ReceiveBeginPlay()
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

return M
