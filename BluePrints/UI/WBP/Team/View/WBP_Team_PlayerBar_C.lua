--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
local BloodBarUtils = require "BluePrints.UI.BloodBar.BloodBarUtils"
require "UnLua"
local TeamModel = TeamController:GetModel()

---@type WBP_Team_PlayerBar_P_C 
---@type WBP_Team_PlayerBar_M_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})


function M:Construct()
    self.Img_Down:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Img_Up:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.VB_Teammate_Phantom:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Tag_Player:SetVisibility(UIConst.VisibilityOp.Visible)
    local SelfSlot = UWidgetLayoutLibrary.SlotAsWrapBoxSlot(self)
    if SelfSlot then
        SelfSlot.VerticalAlignment = EVerticalAlignment.VAlign_Fill
        SelfSlot.HorizontalAlignment = EHorizontalAlignment.HAlign_Fill
    end
    ---@param self WBP_Team_PlayerBar_P_C
    ---@param self WBP_Team_PlayerBar_M_C
    EventManager:AddEvent(EventID.OnTeamRecoveryStateChange, self, function(self, Eid, Type, PrevType)
        if (Eid == self.Eid) then
            if (Type == UE4.ETeamRecoveryState.Dying) then
                self.Tag_Player:SetDeadState(true)
            elseif (Type == UE4.ETeamRecoveryState.Alive) then
                self.Tag_Player:SetDeadState(false)
            end 
        end
    end)
    EventManager:AddEvent(EventID.CharRecover,self,function(self, Eid)
        if Eid == self.Eid then
            self.Tag_Player:SetDeadState(false)
        end
    end)
end

function M:SetOwner(Owner)
    ---@type WBP_Battle_P_C
    self.Owner = Owner
end

function M:AddEid(PlayerEid, PhantomEid, PosIndex)
    if not self.Phantoms then 
        self.Phantoms = {}
    end
    DebugPrint(DebugTag, LXYTag, "WBP_Team_PlayerBar_P_C::AddEid", PlayerEid, PhantomEid, PosIndex)
    if PlayerEid == PhantomEid then 
        local MemberData = TeamModel:GetTeamMember(PlayerEid)
        self.Tag_Player:Init(false, MemberData.Index, MemberData.Uid)
        
        local Player = Battle(self):GetEntity(PlayerEid)
        if TeamModel:IsYourself(PlayerEid) then
            Player = GWorld:GetMainPlayer()
        end
        self.Eid = PlayerEid
        if not self.PlayerState then
            ---@type BP_EMPlayerState_C
            self.PlayerState = GameState(self):GetPlayerState(PlayerEid)
            self.PlayerState.OnRepbIsEMInactiveDelegate:Add(self, self.PlayOfflineAnim)
            self.PlayerState.OnReceiveActorStateChangeDelegate:Add(self, self.SetBloodBarState)
        end
        DebugPrint(LXYTag,"传给血条的玩家对象名称"..Player.PlayerState.PlayerName)
        if not IsValid(self.PlayerBar.Owner) then 
            self.PlayerBar:InitConfig(Player)
        end
        if(Player:IsDead()) then
            self.PlayerBar:OnDead()
            self.Tag_Player:SetDeadState(true)
        end
        self.PlayerBar.Text_Name:SetText(MemberData.Nickname)
        Player.TeammateUI = self.PlayerBar
        Player:SetTeammateUI(self.PlayerBar)
        self:PlayOfflineAnim(false)
        --DebugPrint(LXYTag, "队友血条成功添加了Eid",self.Eid)
    else
        if not self.Phantoms[PhantomEid] or (not IsValid(self.Teammate.Owner)) then
            self:StopAllAnimations()
            self.Phantoms[PhantomEid] = true
            self.VB_Teammate_Phantom:SetVisibility(UIConst.VisibilityOp.Visible)
            local Phantom = Battle(self):GetEntity(PhantomEid)
            self.Teammate:StopAllAnimations()
            if not IsValid(self.Teammate.Owner) then
                self.Teammate:InitConfig(Phantom)
            end
            if(Phantom:IsDead()) then
                self.Teammate:OnDead()
            end
            Phantom.TeammateUI = self.Teammate
            Phantom:SetTeammateUI(self.Teammate)
            self.Img_Down:SetVisibility(UIConst.VisibilityOp.Visible)
            self.Img_Up:SetVisibility(UIConst.VisibilityOp.Visible)
            self:PlayAnimation(self.Shadow_Add)
        end
    end
end

function M:PlayOfflineAnim(bToast)
    if bToast == nil then bToast = true end
    if self.PlayerState.bIsEMInactive then
        self.PlayerBar:StopAnimation(self.PlayerBar.Normal)
        self.PlayerBar:PlayAnimation(self.PlayerBar.Disconnect)
        if self.VB_Teammate_Phantom:IsVisible() then
            self.Teammate:StopAnimation(self.Teammate.Normal)
            self.Teammate:PlayAnimation(self.Teammate.Disconnect)
        end
        if bToast then
            TeamController:ShowToast(string.format(GText("UI_Team_PlayerOffline"), self.PlayerState.PlayerName))
        end
    else
        self.PlayerBar:StopAnimation(self.PlayerBar.Disconnect)
        self.PlayerBar:PlayAnimation(self.PlayerBar.Normal)
        if self.VB_Teammate_Phantom:IsVisible() then
            self.Teammate:StopAnimation(self.Teammate.Disconnect)
            self.Teammate:PlayAnimation(self.Teammate.Normal)
        end
        if bToast then
            local Msg = string.format(GText("UI_Team_PlayerReOnline"), self.PlayerState.PlayerName)
            --TeamController:ShowToast(Msg)
            ChatController:RecvSystemInfoToTeam(Msg)
        end
    end
end

function M:RemoveEid(PlayerEid, PhantomEid)
    local bClose = false
    if PlayerEid == PhantomEid then
        self:Close()
        bClose = true
    elseif self.Phantoms[PhantomEid] and self.Teammate.Eid == PhantomEid then
        self.VB_Teammate_Phantom:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Img_Down:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Img_Up:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Teammate.Eid = 0
        self.Teammate.Owner = nil
        self.Phantoms[PhantomEid] = nil
        for Eid,_ in pairs(self.Phantoms) do
            local PhantomChar = Battle(self):GetEntity(Eid)
            if IsValid(PhantomChar) then
                self:AddEid(PlayerEid, Eid, nil)
            else
                self:AddEidWithOutCharacter(PlayerEid, Eid, nil)
            end
            break
        end
        return bClose
    end
    if self.PlayerState then
        self.PlayerState.OnRepbIsEMInactiveDelegate:Remove(self, self.PlayOfflineAnim)
        self.PlayerState.OnReceiveActorStateChangeDelegate:Remove(self, self.SetBloodBarState)
    end
    self.PlayerState = nil
    return bClose
end

function M:AddEidWithOutCharacter(PlayerEid, PhantomEid, PosIndex)
    if not self.Phantoms then 
        self.Phantoms = {}
    end
    if PlayerEid == PhantomEid then
        local MemberData = TeamModel:GetTeamMember(PlayerEid)
        self.Tag_Player:Init(false, MemberData.Index, MemberData.Uid)
        self.Eid = PlayerEid
        if not self.PlayerState then
            self.PlayerState = GameState(self):GetPlayerState(PlayerEid)
            self.PlayerState.OnRepbIsEMInactiveDelegate:Add(self, self.PlayOfflineAnim)
            self.PlayerState.OnReceiveActorStateChangeDelegate:Add(self, self.SetBloodBarState)
        end
        if self.PlayerBar.Eid == 0 then 
            self.PlayerBar:InitWithOutCharacter( self.PlayerState)  
        end
        if(self.PlayerState.TeamRecoveryState ~= ETeamRecoveryState.Alive) then
            self.PlayerBar:OnDead()
            self.Tag_Player:SetDeadState(true)
        end
        self.PlayerBar.Text_Name:SetText(MemberData.Nickname)
        self:PlayOfflineAnim(false)
    else
        if not self.Phantoms[PhantomEid] then
            self.Phantoms[PhantomEid] = true
            self.VB_Teammate_Phantom:SetVisibility(UIConst.VisibilityOp.Visible)
            local PhantomState = GameState(self):GetPhantomState(PhantomEid)
            if self.Teammate.Eid == 0 then
                self.Teammate:InitWithOutCharacter(PhantomState)
                self.Teammate:AddBloodState(PhantomEid, BloodBarUtils.AllBloodState.OverReach)
            end
            if(PhantomState.TeamRecoveryState ~= ETeamRecoveryState.Alive) then
                self.Teammate:OnDead()
            end
            self.Img_Down:SetVisibility(UIConst.VisibilityOp.Visible)
            self.Img_Up:SetVisibility(UIConst.VisibilityOp.Visible)
            self:PlayAnimation(self.Shadow_Add)
        end
    end
end

---@param Eid number Entity的id，暂时还没用到
---@param State string 血条状态，目前（正常、死亡、距离过远）
---@param bIsWithPhantom boolean 是否应用到魅影身上
---@param bIsRemove boolean 是否移除
function M:SetBloodBarState(Eid, State, bIsWithPhantom, bIsRemove)
    if (bIsRemove) then
        if (bIsWithPhantom) then
            self.PlayerBar:RemoveBloodState(Eid, State)
            if self.Phantoms[self.Teammate.Eid] then
                self.Teammate:RemoveBloodState(self.Teammate.Eid, State)
            end
        else
            self.PlayerBar:RemoveBloodState(Eid, State)
        end
    else
        if (bIsWithPhantom) then
            self.PlayerBar:AddBloodState(Eid, State)
            if self.Phantoms[self.Teammate.Eid] then
                self.Teammate:AddBloodState(self.Teammate.Eid, State)
            end
        else
            self.PlayerBar:AddBloodState(Eid, State)
        end
    end
end

function M:Close()
    self.PlayerBar:ClearBloodAllState(self.Eid)
    for Eid,_ in pairs(self.Phantoms) do
        self.Teammate:ClearBloodAllState(Eid)
    end
    self:RealClose()
end

function M:RealClose()
    self:RemoveFromParent()
    self:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Owner.VB_PlayerBar:AddChild(self)
    if self.PlayerState then
        self.PlayerState.OnRepbIsEMInactiveDelegate:Remove(self, self.PlayOfflineAnim)
        self.PlayerState.OnReceiveActorStateChangeDelegate:Remove(self, self.SetBloodBarState)
    end
    self.PlayerState = nil
    self.Phantoms = {}
end

function M:Destruct()
    EventManager:RemoveEvent(EventID.OnTeamRecoveryStateChange, self)
    EventManager:RemoveEvent(EventID.CharRecover,self)
end

return M
