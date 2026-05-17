local TeamModel = TeamController:GetModel()

---战斗界面跟组队相关的逻辑
---@type WBP_Battle_P_C
local Component = {}

function Component:InitTeam()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    DebugPrint(DebugTag, LXYTag, "TeamSyncDebug 组队流程时序，WBP_Battle_C::OnLoaded, WBP_Battle_C_TeamComp::InitTeam")
    if self.Platform == "PC" then
        self.TeamInputAction = DataMgr.KeyboardMap.ShowTeamInfo
        self:ListenForInputAction(self.TeamInputAction.ActionName, EInputEvent.IE_Pressed, false, {self, self.OpenTeamInfo})
        UIManager(self):GetGameInputModeSubsystem().OnInputMethodChanged:Add(self, self.OnInputDeviceChange_Team)
    end
    
    self.HUD_MainBar.Icon_Agree:SetVisibility(UIConst.VisibilityOp.Collapsed)
    ---@param self WBP_Battle_P_C
    TeamController:RegisterEvent(self, function(self, EventId, ...)
        if EventId == TeamCommon.EventId.TeamOnInit then
            self:_ShowTeamPart(true)
        elseif EventId == TeamCommon.EventId.TeamLeave then
            if GWorld:IsStandAlone() then
                self:_ShowTeamPart(false)
            end
        elseif EventId == TeamCommon.EventId.TeamOnVoteAgreed then
            local Uid = ...
            if Uid == TeamModel:GetAvatar().Uid then
                self.HUD_MainBar.Icon_Agree:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
                self.HUD_MainBar:PlayAnimation(self.HUD_MainBar.Agree)
            end
        elseif EventId == TeamCommon.EventId.TeamOnChangeLeader then
            local NewLeader = ...
            if self.Platform == "Mobile" then return end
            if TeamModel:IsYourself(NewLeader.Uid) and GWorld:IsStandAlone() then
                if self.Platform == "PC" then
                    self.WBP_Team_Tag:Init(true, NewLeader.Index, NewLeader.Uid)
                else
                    self.HUD_MainBar.T_Tag:Init(true, NewLeader.Index, NewLeader.Uid)
                end
            end
        elseif EventId == TeamCommon.EventId.TeamOnVoteRefused then
            self.HUD_MainBar.Icon_Agree:SetVisibility(UIConst.VisibilityOp.Collapsed)
        elseif EventId == TeamCommon.EventId.TeamOnVoteInvalid then
            self.HUD_MainBar.Icon_Agree:SetVisibility(UIConst.VisibilityOp.Collapsed)
        elseif EventId == TeamCommon.EventId.TeamOnVoteEntering then
            self.HUD_MainBar.Icon_Agree:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            self.HUD_MainBar:PlayAnimation(self.HUD_MainBar.Agree)
        elseif EventId == TeamCommon.EventId.OnEnterMultiGame then
            self:RefreshTeamWhenEnterGame(true)
        elseif EventId == TeamCommon.EventId.OnEnterSingelGame then
            self:RefreshTeamWhenEnterGame(false)
        end
    end)
    self:AddDispatcher(EventID.OnRepEidPlayerState, self, function(self,Eid)
        DebugPrint("TeamSyncDebug OnRepEidPlayerState同步队友", Eid)
        if (Eid~=0) then
            self:AddTeammateUI(Eid, true)
        end
    end)
    self:AddDispatcher(EventID.OnDelPlayerState, self, self.RemoveBattleTeamBloodBar)
    self:AddDispatcher(EventID.OnRepOwnerEidPhantomState, self, function(self,Eid, OwnerEid)
        DebugPrint("TeamSyncDebug OnRepEidPlayerState同步魅影", Eid,  "OwnerEid:", OwnerEid)
        if (Eid~=0) and OwnerEid~=0 then
            self:AddTeammateUI(Eid, false)
        end
    end)
    self:AddDispatcher(EventID.OnDelPhantomState, self, self.RemoveBattleTeamBloodBar)
end

function Component:OnInputDeviceChange_Team()
    if not TeamModel:GetTeam() then return end
    if TeamController:IsGamepad() then
        self.WidgetSwitcher_MP:SetActiveWidgetIndex(1)
        local KeyIcons = UIUtils.GetIconListByActionName("ShowTeamInfo")
        self.Key_Team_GamePad:CreateCommonKey({
            KeyInfoList = {{
                Type="Img",
                ImgShortPath = KeyIcons[1],
            }},
        })
        DebugPrint("OnInputDeviceChange_Team Key_Gamepad Visibility",self.Key_Team_GamePad:IsVisible())
    elseif not TeamController:IsMobile() then
        self.WidgetSwitcher_MP:SetActiveWidgetIndex(0)
        self.Key_Team:CreateCommonKey({
            KeyInfoList = {{
                Type="Text",
                Text = self.TeamInputAction.Key
            }},
        })
    end
end

function Component:RefreshTeamWhenEnterGame(bMultiGame)
    self:ResetTeamAbout()
    -- 派对模式下隐藏组队面板
    if GameState(self).GameModeType == "Party" then
        return
    end
    if not IsStandAlone(self) then
        self.TeamBloodBars,self.TeamBloodBarCount = {},0
    end

    if bMultiGame then
        if #TeamModel:GetTeam().Members<=1 then 
            self:_ShowTeamPart(false) 
            local Player = GWorld:GetMainPlayer(0)
            for _, PhantomState in pairs(GameState(self).PhantomArray) do
                if PhantomState.OwnerEid == Player.Eid then
                    self:AddTeammateUI(PhantomState.Eid, false)
                end
            end
        else
            self:_ShowTeamPart(true)
            for i,Member in ipairs(TeamModel:GetTeam().Members) do
                --local Player = Battle(self):GetEntity(Member.Uid)
                DebugPrint(LXYTag, "TeamSyncDebug WBP_Battle_C::RefreshTeam.......PlayerArray Exist， Eid:", Member.Uid)
                local bSelfCharacter = false
                if TeamModel:IsYourself(Member.Uid) and self.Platform == "PC" then
                    if self.Platform == "PC" then
                        self.WBP_Team_Tag:Init(false, Member.Index, Member.Uid)
                    else
                        self.HUD_MainBar.T_Tag:Init(false, Member.Index, Member.Uid)
                    end
                    bSelfCharacter = true
                else
                    self:AddTeammateUI(Member.Uid, true)
                end
                for _, PhantomState in pairs(GameState(self).PhantomArray) do
                    if PhantomState.OwnerEid == Member.Uid then
                        self:AddTeammateUI(PhantomState.Eid, false)
                    end
                end
            end
        end
    else
        if TeamModel:GetTeam() then
            self:_ShowTeamPart(true)
        else
            self:_ShowTeamPart(false)
        end
    end 
end

function Component:ResetTeamAbout()
    if not TeamModel:GetAvatar() then return end
    DebugPrint(LXYTag, "TeamSyncDebug 重置战斗界面上跟组队相关的东西" )
    self:_ShowTeamPart(false)
    self.VB_PlayerBar:ClearChildren()
    self.Team:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Team:SetRenderOpacity(1)
    self:CloseTeamInfo()
    if not self.TeamHeadUI then
        self.TeamHeadUI = TeamController:GetHeadUI(self.Pos_Player)
    end
    if self.TeamHeadUI then
        self.TeamHeadUI:Close()
        self.TeamHeadUI = nil
        self.Pos_Player:ClearChildren()
        self.Pos_Player:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function Component:OpenTeamInfo()
    if not TeamModel:GetTeam() or #TeamModel:GetTeam().Members <=1 then return end
    if not GWorld:IsStandAlone() then
        if not self.TeamBloodBars or not next(self.TeamBloodBars) then
            return
        end
    else
        if not self.TeamHeadUI then 
            return
        end
    end
    DebugPrint(DebugTag, LXYTag, "OpenTeamInfo")
    self:PlayAnimation(self.Team_Out)
    --self.ChatFocusArea:SetVisibility(UIConst.VisibilityOp.Visible)
    RunAsyncTask(self, "OpenTeamInfoAsync",function(CoObj)
        local TeamInfoUI = UIManager(self):GetUIObjAsync(TeamCommon.InfoUIName, CoObj)
        if IsValid(TeamInfoUI) then
            TeamInfoUI:UnbindAllFromAnimationFinished(TeamInfoUI.Auto_Out)
            TeamInfoUI:StopAnimation(TeamInfoUI.Auto_Out)
            TeamInfoUI:InitUIInfo(TeamCommon.InfoUIName, false,nil)
            DebugPrint(DebugTag, LXYTag, "复用TeamInfoUI")
        else
            TeamInfoUI = UIManager(self):LoadUIAsync(TeamCommon.InfoUIName, CoObj)
            DebugPrint(DebugTag, LXYTag, "创建TeamInfoUI")
        end
    end)
end

function Component:CloseTeamInfo()
    RunAsyncTask(self, "CloseTeamInfoAsync",function(CoObj)
        local TeamInfoUI = UIManager(self):GetUIObjAsync(TeamCommon.InfoUIName, CoObj)
        if IsValid(TeamInfoUI) then
            TeamInfoUI:Close()
        end
    end)
end

function Component:AddBattleTeamBloodBar(Eid, bIsPlayer,Entity)
    local Avatar = GWorld:GetAvatar()
    -- 派对模式下隐藏组队面板
    if GameState(self).GameModeType == "Party" then
        return false
    end
    --联机区域或者单机就别生成队友血条了
    if GWorld:IsStandAlone() or (Avatar and Avatar.IsInRegionOnline) then
        return false
    end
    ---首次拿不到Entity时，应该要将Entity尝试将填充到Battle中了
    if not Battle(self):GetEntity(Eid) then
        Battle(self):AddEntity(Eid,Entity)
    end
    if not self.TeamBloodBars or not self.TeamBloodBarCount then
        DebugPrint("TeamSyncDebug  等Loading结束，ds对象同步完成之后再创建血条")
        --跳过单机血条创建流程，之后组队初始化流程再创建血条
        return true
    end
    if not Entity then
        Entity = Battle(self):GetEntity(Eid)
    end
    -- Utils.Traceback(LXYTag, "TeamSyncDebug 组队流程时序， EventID::ShowTeammateBloodUI, WBP_Battle_C::AddTeammateUI,  WBP_Battle_C_TeamComp::AddBattleTeamBloodBar")
    ---查询Eid归属，
    DebugPrint(DebugTag, LXYTag, "TeamSyncDebug 队 WBP_Battle_C::AddBattleTeamBloodBar, Eid, PlayerCount, bIsPlayer", Eid, GameState(self).PlayerArray:Num(),bIsPlayer)
    local PlayerEid, PhantomEid = Eid,Eid
    if not bIsPlayer then
        PlayerEid, PhantomEid = TeamModel:GetOwnerEidOfUnknowEid(self, Eid)
        if not PlayerEid then
            DebugPrint(LXYTag, ErrorTag, "TeamSyncDebug组队查询魅影归属失败，魅影Eid",Eid)
            return false
        end
        local PlayerEntity = Battle(self):GetEntity(PlayerEid)
        if not IsValid(PlayerEntity) then
            DebugPrint(LXYTag, "TeamSyncDebug 魅影的Owner玩家角色无效，该魅影的角色应该也是无效的",Eid)
            Entity = nil
        end
        local PhantomState = GameState(self):GetPhantomState(PhantomEid)
        if not PhantomState then
            DebugPrint(WarningTag, LXYTag, "TeamSyncDebug PhantomState尚未准备就绪，等回调触发，Eid",PhantomEid)
            return false
        end
        local PhantomCharConf = DataMgr.Phantom[PhantomState.CharId]
        if PhantomCharConf and PhantomCharConf.IsHostage then
            DebugPrint(LXYTag, WarningTag, "TeamSyncDebug人质特殊处理，不应该被当作魅影")
            return false
        end
    end
    if TeamModel:IsYourself(PlayerEid) then
        DebugPrint(LXYTag, "TeamSyncDebug队 自己的Eid不显示血条 true")
        return false
    end
    if bIsPlayer then
        TeamController:AddTeamMemberWithDs(self, Eid)
        self.VB_PlayerBar:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if not self.VB_PlayerBar:IsVisible() then 
        DebugPrint(LXYTag, "TeamSyncDebug队 血条挂接点不可见 false")
        return false 
    end
    if not next(self.TeamBloodBars) and self.TeamBloodBarCount ==0 then
        self:_ShowTeamPart(true)
    end
    local PlayerState = GameState(self):GetPlayerState(PlayerEid)
    if not PlayerState then
        DebugPrint(WarningTag, LXYTag, "TeamSyncDebug PlayerState尚未准备就绪，等回调触发，Eid",PlayerEid)
        return false
    end
    ---@type WBP_Team_PlayerBar_P_C
    local BloodBar = self.TeamBloodBars[PlayerEid]
    if not BloodBar then
        local MaxTeammate = TeamCommon.MaxTeamMembers-1
        if self.VB_PlayerBar:GetChildrenCount() <MaxTeammate then
            DebugPrint(LXYTag,"TeamSyncDebug创建新的队友血条")
            BloodBar = self:CreateWidgetNew(DataMgr.WidgetUI.TeamBattleBloodBar.UIName)
            self.VB_PlayerBar:AddChild(BloodBar)
        else
            DebugPrint(LXYTag,"TeamSyncDebug复用已经创建的队友血条")
            for _, InActiveUI in pairs(self.VB_PlayerBar:GetAllChildren()) do
                if not InActiveUI:IsVisible() then
                    BloodBar = InActiveUI
                    break
                end
            end
            BloodBar:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end
        DebugPrint(LXYTag,"TeamSyncDebug队友血条记录")
        self.TeamBloodBars[PlayerEid] = BloodBar
        self.TeamBloodBarCount = self.TeamBloodBarCount + 1

        if bIsPlayer and IsValid(Entity) then
            for _, PhantomEntity in pairs(Entity:GetPhantomTeammates(false, false)) do
                PhantomEntity.PhantomOwner = Entity
                self:AddTeammateUI(PhantomEntity.Eid,false, PhantomEntity)
            end
        end
    end
    BloodBar:SetOwner(self)
    if IsValid(Entity) then
        BloodBar:AddEid(PlayerEid, PhantomEid, self.TeamBloodBarCount)
    else 
        BloodBar:AddEidWithOutCharacter(PlayerEid, PhantomEid,self.TeamBloodBarCount)
    end
    return true
end

function Component:RemoveBattleTeamBloodBar(Eid)
    DebugPrint(DebugTag, LXYTag, "TeamSyncDebug组队流程时序， EventID::CloseTeammateBloodUI, WBP_Battle_C::RemoveTeammateUI,  WBP_Battle_C_TeamComp::RemoveBattleTeamBloodBar")
    if not self.TeamBloodBars then return false end
    if not self.VB_PlayerBar:IsVisible() then return false end
    local RealClose = function(BloodBar, PlayerEid, PhantomEid)
        if not BloodBar then return false end
        local bClose = BloodBar:RemoveEid(PlayerEid, PhantomEid)
        if bClose then
            self.TeamBloodBars[PlayerEid] = nil
            self.TeamBloodBarCount = self.TeamBloodBarCount - 1
            --self:CloseTeamInfo()
        end
        if not next(self.TeamBloodBars) and self.TeamBloodBarCount ==0 then
            self:_ShowTeamPart(false)
        end
        TeamController:DelTeamMemberWithDs(Eid)
        return true
    end

    local BloodBar = self.TeamBloodBars[Eid]
    if RealClose(BloodBar, Eid, Eid) then return true end

    for PlayerEid, BloodBar in pairs(self.TeamBloodBars) do
        if BloodBar.Phantoms and BloodBar.Phantoms[Eid] then
            if RealClose(BloodBar, PlayerEid, Eid) then return true end
        end
    end
    if not next(self.TeamBloodBars) then
        self.VB_PlayerBar:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    
    return false
end

function Component:_ShowTeamPart(bShow)
    if self._bShowTeamPart == bShow then return end
    self._bShowTeamPart = bShow
    if not bShow then
        self:Show1PTagBar(false)
        --region 处理队序标签
        if self.Platform == "PC" then
            self.VB_Tag:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
        else
            self.HUD_MainBar.T_Tag:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        
        self.Pos_Player:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.VB_PlayerBar:SetVisibility(UIConst.VisibilityOp.Collapsed)
        local TeamInfoUI = TeamController:GetView(self, TeamCommon.InfoUIName)
        if IsValid(TeamInfoUI) and not TeamInfoUI.IsBeginToClose then
            TeamInfoUI:Close()
        end
        self.HUD_MainBar.Icon_Agree:SetVisibility(UIConst.VisibilityOp.Collapsed)
        return
    end
    self.Pos_Player:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    --region 显示队序标签
    if self.Platform == "PC" then
        self.VB_Tag:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Key:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self:OnInputDeviceChange_Team()
    elseif self.Platform == "Mobile" then
        self.Spacer_Tag:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.HUD_MainBar.T_Tag:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
    --endregion
    if TeamModel:GetAvatar() then
        local PlayerChar = GWorld:GetMainPlayer()
        local IsLeader = TeamModel:IsTeamLeader(TeamModel:GetAvatar().Uid)
        local bShowBar = PlayerChar:GetPhantomTeammates():Num() >1
        self:Show1PTagBar(bShowBar)
        if not GWorld:IsStandAlone() then
            IsLeader = false
            self.Pos_Player:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.VB_PlayerBar:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            if self.Platform == "Mobile" then
                -- 手机端特有控件，只在副本内显示
                self.Spacer_Tag:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            end
            local YourselfMember = TeamModel:GetTeamMember(PlayerChar.Eid)
            if self.Platform == "PC" then
                self.WBP_Team_Tag:Init(false, YourselfMember.Index, YourselfMember.Uid)
            else
                self.HUD_MainBar.T_Tag:Init(false, YourselfMember.Index, YourselfMember.Uid)
            end
            return
        end
        local TeamData = TeamModel:GetTeam()
        if not TeamData then return end
        local YourselfMember = TeamModel:GetTeamMember(TeamModel:GetAvatar().Uid)
        if self.Platform == "PC" then
            self.WBP_Team_Tag:Init(IsLeader, YourselfMember.Index, YourselfMember.Uid)
        else
            self.HUD_MainBar.T_Tag:Init(IsLeader, YourselfMember.Index, YourselfMember.Uid)
        end
        if #TeamData.Members>0 and self.Pos_Player:IsVisible() then
            if self.TeamHeadUI then
                self.TeamHeadUI:Close()
                self.TeamHeadUI = nil
            end
            self.TeamHeadUI = TeamController:OpenHeadUI(self.Pos_Player, true)
        elseif self.TeamHeadUI then
            self.TeamHeadUI:Close(true)
            self.TeamHeadUI = nil
        end
    end
end

function Component:Show1PTagBar(bShow)
    local Func = self["Show1PTagBar".. self.Platform]
    if Func then
        Func(self, bShow)
    end
end

function Component:Show1PTagBarPC(bShowBar)
    if not self.VB_Tag:IsVisible() then return end
    if bShowBar then
        self:PlayAnimation(self.Shadow_Add)
        self.Img_Down:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Img_Up:SetVisibility(UIConst.VisibilityOp.Visible)
    else 
        self:PlayAnimationReverse(self.Shadow_Add)
        self.Img_Down:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Img_Up:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function Component:Show1PTagBarMobile(bShowBar)
    if bShowBar then
        self:PlayAnimation(self.Shadow_Add)
    else 
        self:PlayAnimationReverse(self.Shadow_Add)
    end
end

function Component:EndTeam()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    if self.Platform == "PC" then
        UIManager(self):GetGameInputModeSubsystem().OnInputMethodChanged:Remove(self, self.OnInputDeviceChange_Team)
        self:StopListeningForInputAction(self.TeamInputAction.ActionName, EInputEvent.IE_Pressed)
    end
    if self.TeamHeadUI then
        self.TeamHeadUI:Close()
        self.TeamHeadUI = nil
    end
    TeamController:UnRegisterEvent(self)
end

return Component