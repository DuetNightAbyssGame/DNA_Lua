local Component = {}

local HeadState = {
    Normal = 1,
    Agree = 2,
    Disconnent = 3,
    WaitLoop = 4
}

function Component:InitComp(...)
    local PlayerState, Index, IsFirstInit, bMainPlayer, RootPage = ...
    self.RootPage = RootPage
    self:SetHeadState()
    self:SetHeadInfo(PlayerState, Index, bMainPlayer)
    if IsFirstInit then
        self:PlayAnimation(self.In)
        self:BindAnimation()
    end
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    --悬浮显示名称和等级
    self.Head_Team:BindOnMouseHover(function(bHovered)
        if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
            return
        end
        if bHovered then
            self.Head_Anchor:Open(true)
        else
            self.Head_Anchor:Close()
        end
    end)

    --点击显示气泡
    self.Head_Team:BindOnClickEvent(function()
        -- self:PlayAnimation(self.Bubble_In)
        self.RootPage:ChangeSelectedHead(self)
        self.Head_Anchor:Open(true)
    end)

    self.Head_Team:SetHoldUp(true)

    --点空白处触发菜单锚关闭逻辑，顺便把头像的选中态清除
    self.Head_Anchor.OnMenuOpenChanged:Add(self, self.OnMenuOpenChanged)
end

function Component:OnMenuOpenChanged(IsOpen)
    --目前只处理头像处于选中态，菜单锚关闭时的情况
    if not IsOpen and self.Head_Team.bSelected then
        self:PlayAnimation(self.Normal)
        self.Head_Team:PlayNormal()
    end
end

function Component:BindAnimation()
    self:BindToAnimationFinished(self.In, {self, 
        function() 
            self:PlayAnimation(self.WaitLoop, 0, 0) 
        end})
    self:BindToAnimationFinished(self.Left_In, {self, 
        function() 
            self:PlayAnimation(self.Normal) 
        end})
    self:BindToAnimationFinished(self.Right_In, {self, 
        function() 
            self:PlayAnimation(self.Normal) 
        end})
end

function Component:SetHeadInfo(...)
    local PlayerState, Index, bMainPlayer = ...
    if not PlayerState then
        return
    end
    self.PlayerState = PlayerState
    self.PlayerState.OnRepbIsEMInactiveDelegate:Add(self, self.OnPlayerInactive)
    self.bMainPlayer = bMainPlayer
    self:SetHeadIconByRoleId(PlayerState)
    self.PlayerLevel = PlayerState.PlayerLevel
    self.PlayerName = PlayerState.PlayerName
    self.Index = Index
    local Uid = PlayerState.Eid
    --这里用组队模块的提供的索引，投票的Tag要与队伍面板上的保持一致
    local DsMember = TeamController:GetModel():GetTeamMember(Uid)
    if DsMember then
        self.Index = DsMember.Index
        Uid = DsMember.Uid
    end
    self.Tag_Team:Init(false, self.Index, Uid)
    if bMainPlayer then
        self.Icon_Self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

function Component:SetHeadState()
    self.WidgetSwitcher_State:SetActiveWidgetIndex(2)
    self.WidgetSwitcher_State:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function Component:SetHeadIconByRoleId(PlayerState)
    -- local IconName = DataMgr.BattleChar[RoleId].GuideIconImg
    -- local MiniIconPath = "/Game/UI/Texture/Dynamic/Image/Head/Mini/"
    -- local NormalIconName = "T_Normal_"..IconName
    -- local HeadIcon = LoadObject(MiniIconPath..NormalIconName.."."..NormalIconName)
    -- if not IsValid(HeadIcon) then 
    --     return 
    -- end
    self.Head_Team:SetHeadIconById(PlayerState.HeadIconId, true)
    self.Head_Team:SetHeadFrame(PlayerState.HeadFrameId)
end

function Component:OnPlayerVoteContinue()
    self.bVoteContinue = true
    -- self.WidgetSwitcher_State:SetVisibility(ESlateVisibility.Collapsed)
    self:StopAnimation(self.WaitLoop)
    self:StopAnimation(self.Left_In)
    self:PlayAnimation(self.Right_In) 
    self.Head_Team:PlayAnimation(self.Head_Team.NormalYellow)
end

function Component:OnPlayerVoteLeave()
    self.bVoteContinue = false
    -- self.WidgetSwitcher_State:SetVisibility(ESlateVisibility.Collapsed)
    self:StopAnimation(self.WaitLoop)
    self:StopAnimation(self.Right_In)
    self:PlayAnimation(self.Left_In) 
    self.Head_Team:PlayAnimation(self.Head_Team.NormalGreen)
end

function Component:OnPlayerInactive()
    self:StopAllAnimations()
    if self.PlayerState.bIsEMInactive then
        self:PlayAnimation(self.Disconnect)
    else
        if self.bVoteContinue ~= nil then
            self:StopAnimation(self.WaitLoop)
            self:PlayAnimation(self.Normal)
        else
            self:PlayAnimation(self.WaitLoop, 0, 0) 
        end
    end
end

function Component:OnReleaseSelected(bNeedBubbleOut)
    -- if bNeedBubbleOut then
    --     self:PlayAnimation(self.Bubble_Out)
    -- else
    --     self.Panel_Info:SetRenderOpacity(0)
    -- end
    self.Head_Team:PlayNormal()
end

---------------------------------------------------------------
function Component:OnGetMenuContentComp(Anchor)
    return self:OpenPlayerBubble()
end

function Component:OpenPlayerBubble()
    local PlayerBubbleWidget = UIManager(self):_CreateWidgetNew("VotePlayerBubble")
    PlayerBubbleWidget:Init(self.PlayerLevel, self.PlayerName, self.bVoteContinue)
    return PlayerBubbleWidget
end

return Component