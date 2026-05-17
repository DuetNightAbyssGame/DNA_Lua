--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@type BP_ChestInteractiveComponent_C
local BP_ChestInteractiveComponent_C = Class({
    "BluePrints.Story.Interactive.InteractiveComponent.BP_InteractiveBaseComponent_C",
    "BluePrints.Common.TimerMgr",})

local BP_InteractiveBaseComponent_C = require "BluePrints.Story.Interactive.InteractiveComponent.BP_InteractiveBaseComponent_C"

-- region BP_InteractiveBaseComponent_C
function BP_ChestInteractiveComponent_C:TriggerEnter(PlayerActor)
    self.Overridden.TriggerEnter(self, PlayerActor)
    self.OnInteractiveTriggerEnter:Broadcast(PlayerActor)
end
function BP_ChestInteractiveComponent_C:TriggerTick(PlayerActor)
	-- self:UpdateDisplayInteractiveBtn(PlayerActor)
	self.Overridden.TriggerTick(self, PlayerActor)
    self.OnInteractiveTriggerTick:Broadcast(PlayerActor)
end
function BP_ChestInteractiveComponent_C:TriggerExit(PlayerActor)
	self.Overridden.TriggerExit(self, PlayerActor)
    self.OnInteractiveTriggerExit:Broadcast(PlayerActor)
end
function BP_ChestInteractiveComponent_C:NotDisplayInteractiveBtn(PlayerActor)
	BP_InteractiveBaseComponent_C.NotDisplayInteractiveBtn(self, PlayerActor)
    if PlayerActor and PlayerActor:CheckMechanismEid(self:GetOwner().Eid) and not self:IsCanInteractive(PlayerActor) then
        self:EndPressInteractive(PlayerActor,false)
    end
end
-- endregion

function BP_ChestInteractiveComponent_C:InitInteractiveComponent(InteractiveId)
    if InteractiveId == nil then
        return
    end
    self.bHasId = true
    --表示组件是否可用
    self.bCanUsed = true
    --表示长按交互是否进行中
    self.bPressed = false
    self:InitCommonUIConfirmID(InteractiveId)
    print(_G.LogTag,"LXZ InitInteractiveComponent", InteractiveId, self:GetOwner():GetName())
    self.InteractiveParam = DataMgr.CommonUIConfirm[InteractiveId]
    self.MontageName = self.InteractiveParam.TriggerInterAnim
    self.AutoRotate = self.InteractiveParam.AutoRotate
    if self.MontageName then
        self.InteractiveTag = self.InteractiveParam.InteractiveTag or "Interactive"
    else
        self.InteractiveTag = nil
    end
    self.InteractiveName = self:GetInteractiveName()
end

-- function BP_ChestInteractiveComponent_C:IsCanInteractive(PlayerActor)
--     -- print(_G.LogTag,"LXZ IsCanInteractive", self.bCanUsed)
--     if not IsValid(PlayerActor) or not self.bCanUsed then
--         return false
--     end
--     local Owner = self:GetOwner()
--     local GameState = UE4.UGameplayStatics.GetGameState(self)
--     if not GameState:GetMechanismInteractiveInSpecialQuest(Owner) then
--         return false
--     end
--     Owner:GetCanOpen(PlayerActor.Eid)
--     -- print(_G.LogTag,"LXZ IsCanInteractive", self:GetInteractiveName(), self.DistanceCheckComponent(self, PlayerActor, self.InteractiveDistance, false))
--     -- print(_G.LogTag,"LXZ IsCanInteractive2", self.CFaceToACheckComponent(self, PlayerActor, self.InteractiveFaceAngle, false),self.AFaceToCCheckComponent(PlayerActor, self, self.InteractiveAngle, false))
--     -- print(_G.LogTag,"LXZ IsCanInteractive3", Owner.CombatStateChangeComponent.EventCallbackNum)
--     if self:GetInteractiveName() ~= "" and
--         self.DistanceCheckComponent(self, PlayerActor, self.InteractiveDistance, false) and
--         self.CFaceToACheckComponent(self, PlayerActor, self.InteractiveFaceAngle, false) and
--         self.AFaceToCCheckComponent(PlayerActor, self, self.InteractiveAngle, false) and
--         (not Owner.CombatStateChangeComponent or Owner.CombatStateChangeComponent.EventCallbackNum <= 0) and
--         Owner.CanOpen and not Owner.OpenState then
--         -- print(_G.LogTag,Owner.CanOpen,    Owner.OpenState)
--         return true
--     end
--     return false
-- end

-- function BP_ChestInteractiveComponent_C:IsLocked()
-- 	local Owner = self:GetOwner()
--     if IsValid(Owner) and Owner.IsLocked then
--         return Owner:IsLocked()
--     end
-- end

function BP_ChestInteractiveComponent_C:IsForbidden(PlayerActor)
    if not IsValid(PlayerActor) then
        return false
    end
    local Owner = self:GetOwner()
    if Owner and Owner.IsForbidden then
        local Res = Owner:IsForbidden(PlayerActor)
        if Res then
            return true
        end
    end
    return not self:CheckInteractiveSucc(PlayerActor.Eid)
end

function BP_ChestInteractiveComponent_C:IsForbidden_CPP(PlayerActor)
    if not IsValid(PlayerActor) then
        return false
    end
    return not self:CheckInteractiveSucc(PlayerActor.Eid)
end

function BP_ChestInteractiveComponent_C:IsCanPlayMontage(PlayerActor)
    if self.MontageName then
        return not PlayerActor.WaitCallBack
    end
    return true
end

function BP_ChestInteractiveComponent_C:OnClicked_Forbidden()
    self:InteractiveFailed()
end

function BP_ChestInteractiveComponent_C:CheckInteractiveSucc(PlayerEid)
	local ConditionCheck = BP_ChestInteractiveComponent_C.Super.CheckInteractiveSucc(self, PlayerEid)

    local Player = Battle(self):GetEntity(PlayerEid)
    local TagCheck = self:CheckPlayerTag(Player)
    return ConditionCheck and TagCheck
end

function BP_ChestInteractiveComponent_C:CheckPlayerTag(PlayerActor)
	local Res = BP_ChestInteractiveComponent_C.Super.CheckPlayerTag(self, PlayerActor)
    if self.InteractiveParam.IfSkipAnim then
        local Owner = self:GetOwner()
        Res = Res and (PlayerActor:CanEnterInteractive() or (Owner.AutoSyncProp ~= nil and Owner.AutoSyncProp.CharacterTag == "Defeated"))
    end
    return Res
end

function BP_ChestInteractiveComponent_C:StartInteractive(PlayerActor)
    if not self.bEnter then
        return
    end
    self.CanEnd = true
    --WaitCallBack:当有交互动画时，必须等回调完成才能重新发起交互
    print(_G.LogTag,"LXZ StartInteractive", self:IsCanInteractive(PlayerActor), self:IsCanPlayMontage(PlayerActor),  not self:IsForbidden(PlayerActor))
    if self:IsCanInteractive(PlayerActor) and self:IsCanPlayMontage(PlayerActor) and not self:IsForbidden(PlayerActor) and not self:IsLocked() then
        local Avatar = GWorld:GetAvatar()
        local Owner = self:GetOwner()
        if Owner.NeedCallBackInteractive and Avatar and Avatar.IsInRegionOnline then
            --区域联机 需要等待服务器确认后才发起交互
            Owner:SendServerStartInteractive(PlayerActor.Eid)
        else
            PlayerActor:InteractiveMechanism(Owner.Eid, PlayerActor.Eid, self.NextStateId, self.CommonUIConfirmID, true)
            if Owner.InteractiveType == Const.PressInteractive then
                self.bPressed = true
            end
        end
    end
end

function BP_ChestInteractiveComponent_C:BtnPressed(PlayerActor)
    self:StartInteractive(PlayerActor)
end


function BP_ChestInteractiveComponent_C:BtnReleased(PlayerActor, InPressTimeSeconds)
    local Owner = self:GetOwner()
    if Owner and Owner.InteractiveType == Const.PressInteractive and self.bPressed then
        self:EndPressInteractive(PlayerActor, false)
    elseif Owner.InteractiveType == Const.ClickInteractive then
        self:EndInteractive(PlayerActor)
    end
end

function BP_ChestInteractiveComponent_C:EndInteractive(PlayerActor, ReasonId)
    local Owner = self:GetOwner()
    local Avatar = GWorld:GetAvatar()
    if Owner and Owner.InteractiveType ~= Const.PressInteractive and PlayerActor:CheckMechanismEid(self:GetOwner().Eid) then
        if Owner.NeedCallBackInteractive and Avatar and Avatar.IsInRegionOnline then
            --区域联机 轮盘座椅需要等待UI确认后才发起交互
            Owner:SendServerEndInteractive(PlayerActor.Eid)
        else
            PlayerActor:DeInteractiveMechanism(Owner.Eid, PlayerActor.Eid, ReasonId, true, nil, true)
        end
        
    end
end

function BP_ChestInteractiveComponent_C:BtnClicked( PlayerActor, InPressTimeSeconds)
    if self:CanPickUpWithOneClick() then
        self:StartInteractive(PlayerActor)
    end
end

function BP_ChestInteractiveComponent_C:EndPressInteractive(PlayerActor, IsSuccess, ReasonId)
    local Owner = self:GetOwner()
    if IsSuccess then
        self.CanEnd = false
    end
    if Owner and Owner.InteractiveType == Const.PressInteractive then
        if self.bPressed then
            --药剂台联机下处于交互中，其他玩家狂按会在其客户端上关闭UI显示，临时处理
            if Owner.SetInteractiveCanUsed then
                Owner:SetInteractiveCanUsed(false)
            else
                self.bCanUsed = false
            end
        end
        self.bPressed = false
        PlayerActor:DeInteractiveMechanism(Owner.Eid, PlayerActor.Eid, ReasonId, IsSuccess,0, true)
        self:RemoveTimer(self.Handle)
        self.Handle = nil
    elseif Owner and Owner.InteractiveType == Const.EndByTargetInteractive then
        PlayerActor:DeInteractiveMechanism(Owner.Eid, PlayerActor.Eid, ReasonId, IsSuccess,0, true)
        self:RemoveTimer(self.Handle)
        self.Handle = nil
    end
end

--ReasonId用于强制中断交互，0或不填为非强制中断，其他Id类型待扩展
function BP_ChestInteractiveComponent_C:ForceEndInteractive(PlayerActor, IsSuccess, ReasonId)
    local Owner = self:GetOwner()
    if Owner.InteractiveType == Const.ClickInteractive then
        self:EndInteractive(PlayerActor, ReasonId)
    else
        self:EndPressInteractive(PlayerActor, IsSuccess, ReasonId)
    end
end

function BP_ChestInteractiveComponent_C:DisplayInteractiveBtn(PlayerActor)
    local UIManager = UGameplayStatics.GetGameInstance(self):GetGameUIManager()
    local InteractiveUI = UIManager:LoadUINew(UIConst.InteractiveUIName)
    if not InteractiveUI then
        return
    end
    InteractiveUI:AddInteractiveItem(self)
    self:SetBtnDisplayed(PlayerActor, true)
end

function BP_ChestInteractiveComponent_C:NotDisplayInteractiveBtn(PlayerActor)
    if not PlayerActor then
        return
    end
	self:SetBtnDisplayed(PlayerActor, false)
	local UIManager = UGameplayStatics.GetGameInstance(self):GetGameUIManager()
    local InteractiveUI = UIManager:GetUIObj(UIConst.InteractiveUIName)
    if not InteractiveUI then
        return
    end
    InteractiveUI:RemoveInteractiveItem(self)
end

function BP_ChestInteractiveComponent_C:IsLastingInteract()
    if self.InteractiveTime > 0 then
        return true
    end
    local Owner = self:GetOwner()
    if Owner and Owner.InteractiveType == Const.PressInteractive then
        return true
    end
    return false
end

function BP_ChestInteractiveComponent_C:GetNeedLongPressTime()
    local Owner = self:GetOwner()
    if Owner and Owner.GetNeedLongPressTime then
        return Owner:GetNeedLongPressTime()
    end
    return 0
end

function BP_ChestInteractiveComponent_C:GetLongPressedPercent()
    local Owner = self:GetOwner()
    if Owner and Owner.GetLongPressedPercent then
        return Owner:GetLongPressedPercent()
    end
    return 0
end

function BP_ChestInteractiveComponent_C:GetReduceTime()
    local Owner = self:GetOwner()
    if Owner and Owner.GetReduceTime then
        return Owner:GetReduceTime()
    end
    return 0.1
end

function BP_ChestInteractiveComponent_C:GetLongPressingText()
    local Owner = self:GetOwner()
    if Owner and Owner.GetLongPressingText then
        return Owner:GetLongPressingText()
    end
    return ""
end

-- function BP_ChestInteractiveComponent_C:GetUUID()
--     local Owner = self:GetOwner()
--     if Owner and Owner.UniqueId then
--         return Owner.UniqueId
--     end
--     return nil
-- end

function BP_ChestInteractiveComponent_C:GetInteractiveIcon(PlayerActor)
    if self.OverriddenIcon then
        return self.OverriddenIcon
    end
	if self:IsLocked() then
		return "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Interactive/T_Interactive_Lock.T_Interactive_Lock'"
	end
    local Owner = self:GetOwner()
    if not Owner then
        return nil
    end
	if not Owner.UsePlayerId and self:IsForbidden(PlayerActor) then
		return "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Interactive/T_Interactive_Forbidden.T_Interactive_Forbidden'"
	end
	local Data = DataMgr.CommonUIConfirm[self.CommonUIConfirmID]
	if not Data or not Data.Icon then
		return nil
	end
	return Data.Icon
end

function BP_ChestInteractiveComponent_C:GetInteractiveName()
    local Owner = self:GetOwner()
    if not Owner then
        return nil
    end
    local PlayerActor = UGameplayStatics.GetPlayerCharacter(self, 0)
    if not PlayerActor then
        return GText(self.InteractiveName)
    end
    if Owner.GetInteractiveName then
        return Owner:GetInteractiveName(PlayerActor)
    end
    --临时处理，轮盘交互道具需要在禁用时换文本，在自己的IsForbidden里改InteractiveName。同时进入副本时self:IsForbidden为true，所以不判断Owner.IsForbidden会导致InteractiveName为空
    if not Owner.UsePlayerId and self:IsForbidden(PlayerActor) and Owner.IsForbidden then
        return GText(self.InteractiveName)
    end
    local Name = BP_ChestInteractiveComponent_C.Super.GetInteractiveName(self)
    return Name
end

function BP_ChestInteractiveComponent_C:OverrideInteractiveIcon(OverrideIcon)
    rawset(self, "OverriddenIcon", OverrideIcon)
end

-- 是否可以被一键拾取
function BP_ChestInteractiveComponent_C:CanPickUpWithOneClick()
	if not self:GetOwner().UnitId then
		return false
	end
	local UnitId = self:GetOwner().UnitId
	if not DataMgr.Mechanism[UnitId] then
		return false
	end

    if DataMgr.Mechanism[UnitId].UnitRealType == "Collection" then
        return true
    end
    return false
end

function BP_ChestInteractiveComponent_C:GetQuestID()
    local Owner = self:GetOwner()
	return Owner.QuestChainId
end

function BP_ChestInteractiveComponent_C:GetSpecialQuestID()
    local Owner = self:GetOwner()
    if Owner then
        return Owner.ExtraRegionInfo.SpecialQuestId
    end
	return nil
end

function BP_ChestInteractiveComponent_C:GetCostItemInfo()
    local Owner = self:GetOwner()
    if Owner and Owner.GetCostItemInfo then
        return Owner:GetCostItemInfo()
    end
    return nil
end

return BP_ChestInteractiveComponent_C
