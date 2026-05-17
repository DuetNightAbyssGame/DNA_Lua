--
-- DESCRIPTION
--
-- @COMPANY HERO GAMES @PAN.Studio
-- @AUTHOR ZhuYuhao
-- @DATE ${date} ${time}
--

---@type Jump_Phone_C
local Jump_Phone_C = Class("BluePrints.UI.BP_UIState_C")

local OpacityName = {
    Bullet_Jump = "OpacityJump",
    Slide_Attack = "OpacitySideAtack",
    Slide = "OpacitySide"
}

Jump_Phone_C.SkillInfos = {
    [ESkillName.Slide] = {SkillActive = true, AnimName =  "UnLock_Slide"},
    [ESkillName.Attack] = {SkillActive = true, AnimName =  "UnLock_SlideAttack"},
    [ESkillName.BulletJump] = {SkillActive = true, AnimName =  "UnLock_BulletJump"}
}


Jump_Phone_C._components = {
    "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent",
}

function Jump_Phone_C:Initialize(Initializer)
    -- 触控相关参数放在这里初始化 
    self.CurButtonState = "Normal"
    self.LastButtonState = "Normal"
    self.DefaultButtonDis = 50
    self.StartSlide = false
    self.BulletJumpAngle_Max = 125
    self.BulletJumpAngle_Min = 0
    self.AttackAngle_Max = 215
    self.AttackAngle_Min = 125
    self.SlideAngle_Min = 215
    self.SlideAngle_Max = 360
    self.SlideAngle_Min_2in1 = 135
    self.SlideAngle_Max_2in1 = 315
    self.CurrentLayout = 2
    self.InnerButtonDis = self.DefaultButtonDis
end

--function Jump_Phone_C:PreConstruct(IsDesignTime)
--end

function Jump_Phone_C:Construct()
    self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
    self.IconMaterial = self.Image_PanelIcon:GetDynamicMaterial()
    self.PanelMaterial = self.Image_Panel_State:GetDynamicMaterial()
    self.PanelMaterialGuide = self.Image_Panel_State_Guide:GetDynamicMaterial()
    for _, Opacity in pairs(OpacityName) do
        self.PanelMaterial:SetScalarParameterValue(Opacity, 0)
        self.PanelMaterialGuide:SetScalarParameterValue(Opacity, 0)
    end
    self:ChangeByLayout(self.CurrentLayout)
    local IconMat = self.Image_Main:GetDynamicMaterial()
    IconMat:SetTextureParameterValue("Icon_Ranged", self.Icon_Jump)
end

function Jump_Phone_C:ChangeByLayout(Layout)
    if Layout == 2 then
        self.IconMaterial:SetScalarParameterValue("S_BulletJumpSplit", 1)
        self.PanelMaterial:SetScalarParameterValue("S_BulletJumpSplit", 1)
        self.PanelMaterialGuide:SetScalarParameterValue("S_BulletJumpSplit", 1)
        
    elseif Layout == 1 then
        self.IconMaterial:SetScalarParameterValue("S_BulletJumpSplit", 0)
        self.PanelMaterial:SetScalarParameterValue("S_BulletJumpSplit", 0)
        self.PanelMaterialGuide:SetScalarParameterValue("S_BulletJumpSplit", 0)
    end
    self.CurrentLayout = Layout
end

--function Jump_Phone_C:Tick(MyGeometry, InDeltaTime)
--end

function Jump_Phone_C.ButtonJumpDown(Battle_Button_Phone, Index, StartPos)
    local Jump_M = Battle_Button_Phone.Jump -- 由于在Battle_Button_Phone挂的回调，因此self是Battle_Button_Phone，需要再取Jump_Phone
    -- 逻辑层
    if Jump_M.OwnerPlayer:CheckSkillInActive(ESkillName.Jump) then
        return
    end
    Jump_M.CurButtonState = "Press"
    if Jump_M.OwnerPlayer:IsFlying() or Jump_M.OwnerPlayer.CurMount then -- 角色处于飞行时特殊处理（如赛琪开大）
        Jump_M.OwnerPanel:TryToPlayTargetCommand("Jump", true)
    end
    -- 表现层
    Jump_M:PlayStateAnimation()
end

function Jump_Phone_C.ButtonJumpMove(Battle_Button_Phone, TouchFingerCount, Index, LastPos, TotalDeltaDis, LastDeltaDis)
    local Jump_M = Battle_Button_Phone.Jump
    -- 逻辑层
    if Jump_M.OwnerPlayer.CurMount then -- 坐骑状态下不处理挪动Button
        return 
    end
    if Jump_M.OwnerPlayer:CheckSkillInActive(ESkillName.Jump) then
        return
    end
    local function DoStopSlide()
        Jump_M.OwnerPanel:TryToStopTargetCommand("Slide", true)
        if Jump_M.OwnerPlayer:IsFlying() then -- 角色处于飞行时特殊处理（如赛琪开大）
            Jump_M.OwnerPanel:TryToPlayTargetCommand("Jump", true)
        end
        Jump_M.CurButtonState = "Press"
        Jump_M.StartSlide = false
    end
    local FromCenterDis = UE4.UKismetMathLibrary.Distance2D(TotalDeltaDis, FVector2D(0, 0))
    if (FromCenterDis >= Jump_M.InnerButtonDis) then
        local Angle = Jump_M:GetVectorRegionAngle(TotalDeltaDis)
        Jump_M:ChangeCurButtonStateByAngle(Angle)
        local CurRegionIsExtra = Jump_M:IsRegionExtraByAngle(Angle)
        -- 如果独立了Slide或者SlideAttack,当到对向区域时直接停止Slide，和进入内圈时表现一致
        if Jump_M.StartSlide and CurRegionIsExtra then
            DoStopSlide()
        end
        if not Jump_M.StartSlide and not CurRegionIsExtra then
            Jump_M.OwnerPanel:TryToPlayTargetCommand("Slide", true)
            if Jump_M.OwnerPlayer:IsFlying() then -- 角色处于飞行时特殊处理（如赛琪开大）
                Jump_M.OwnerPanel:TryToStopTargetCommand("Jump", true)
            end
            Jump_M.StartSlide = true
        end
    elseif (FromCenterDis < Jump_M.InnerButtonDis and Jump_M.StartSlide) then
        DoStopSlide()
    end
    -- 表现层
    Jump_M:PlayStateAnimation()
end

function Jump_Phone_C.ButtonJumpUp(Battle_Button_Phone, Index, WidgetLocalPos, LastWidgetTouchPos, EndTouchPos, TotalDeltaDis)
    local Jump_M = Battle_Button_Phone.Jump
    -- 逻辑层
    if Jump_M.OwnerPlayer:CheckSkillInActive(ESkillName.Jump) then
        return
    end
    local FromCenterDis = UE4.UKismetMathLibrary.Distance2D(TotalDeltaDis, FVector2D(0, 0))
    -- 根据角度判断当前区域对应的按键是否已独立显示
    local CurRegionHasExtra = false
    if FromCenterDis >= Jump_M.InnerButtonDis then
        local Angle = Jump_M:GetVectorRegionAngle(TotalDeltaDis)
        CurRegionHasExtra = Jump_M:IsRegionExtraByAngle(Angle)
    end
    if (FromCenterDis >= Jump_M.InnerButtonDis) and not Jump_M.OwnerPlayer.CurMount and not CurRegionHasExtra then
        Jump_M:HandleStateWhenUp()
    else
        if Jump_M.OwnerPlayer:IsFlying() or Jump_M.OwnerPlayer.CurMount then -- 角色处于飞行时特殊处理（如赛琪开大）
            Jump_M.OwnerPanel:TryToStopTargetCommand("Jump", true)
        else
            Jump_M.OwnerPanel:TryToPlayTargetCommand("Jump", true)
        end
    end
    Jump_M.CurButtonState = "Normal"
    -- 表现层
    Jump_M:PlayStateAnimation()
end

function Jump_Phone_C:GetVectorRegionAngle(Vector2D)
    -- 计算向量与X轴正方向夹角
    local Angle = math.atan(-Vector2D.Y / Vector2D.X) * (180 / math.pi)
    if Vector2D.X < 0 then
        Angle = Angle + 180
    elseif -Vector2D.Y < 0 then
        Angle = Angle + 360
    end
    return Angle
end

function Jump_Phone_C:ChangeCurButtonStateByAngle(Angle)
    if self.CurrentLayout == 1 then
        if (Angle >= self.BulletJumpAngle_Min and Angle <= self.BulletJumpAngle_Max) then
            self.CurButtonState = "Jump"
        elseif(Angle > self.AttackAngle_Min and Angle <= self.AttackAngle_Max) then
            self.CurButtonState = "Attack"
        elseif(Angle > self.SlideAngle_Min and Angle <= self.SlideAngle_Max) then
            self.CurButtonState = "Slide"
        end
    else
        if Angle >= self.SlideAngle_Min_2in1 and Angle <= self.SlideAngle_Max_2in1 then
            if not self.OwnerPanel.HasExtraSlide then
                self.CurButtonState = "Slide"
            end
        else
            if not self.OwnerPanel.HasExtraSlideAttack then
                self.CurButtonState = "Attack"
            end
        end
    end
end

-- 判断指定角度所在区域的按键是否已被独立显示（仅 Layout 2 有效）
function Jump_Phone_C:IsRegionExtraByAngle(Angle)
    if self.CurrentLayout ~= 2 then
        return false
    end
    local IsSlideSide = Angle >= self.SlideAngle_Min_2in1 and Angle <= self.SlideAngle_Max_2in1
    return (IsSlideSide and self.OwnerPanel.HasExtraSlide)
        or (not IsSlideSide and self.OwnerPanel.HasExtraSlideAttack)
end

function Jump_Phone_C:HandleStateWhenUp()
    if self.CurButtonState == "Jump" then
        if self.OwnerPlayer:IsFlying() then -- 角色处于飞行时特殊处理（如赛琪开大）
            self.OwnerPanel:TryToStopTargetCommand("Jump", true)
        else
            self.OwnerPanel:TryToPlayTargetCommand("Jump", true)
        end
        self.StartSlide = false
    elseif self.CurButtonState == "Attack" then
        self.OwnerPanel:TryToPlayTargetCommand("Attack", false)
        self:AddTimer(0.03, function()
            self.OwnerPanel:TryToStopTargetCommand("Attack", false)
        end, false)
        self.StartSlide = false
    elseif self.CurButtonState == "Slide" then
        self.StartSlide = false
    end
    self:AddTimer(0.05, function()
        self.OwnerPanel:TryToStopTargetCommand("Slide", true)
    end, false)
end

function Jump_Phone_C:PlayAndSetVisibility(SkillName)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self["VX_"..SkillName])
    self.PanelMaterial:SetScalarParameterValue(OpacityName[SkillName], 0)
end

function Jump_Phone_C:PlayStateAnimation()
    if(self.LastButtonState ~= self.CurButtonState) then
        if self.CurButtonState == "Jump" then
            if self.SkillInfos[ESkillName.BulletJump].SkillActive then
                if (not EMUIAnimationSubsystem:EMPlayAnimation(self, self.VX_Bullet_Jump) or not EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click) or not EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)) then
                    if self.LastAnime then
                        EMUIAnimationSubsystem:EMPlayAnimation(self, self.LastAnime, EUMGSequencePlayMode.Reverse)
                    end
                    self.LastAnime = self.VX_Bullet_Jump
                    self:PlayAndSetVisibility("Bullet_Jump")
                end
            end
        elseif self.CurButtonState == "Attack" then
            if self.SkillInfos[ESkillName.Attack].SkillActive then
                if (not EMUIAnimationSubsystem:EMPlayAnimation(self, self.VX_Slide_Attack) or not EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click) or not EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)) then
                    if self.LastAnime then
                        EMUIAnimationSubsystem:EMPlayAnimation(self, self.LastAnime, EUMGSequencePlayMode.Reverse)
                    end
                    self.LastAnime = self.VX_Slide_Attack
                    self:PlayAndSetVisibility("Slide_Attack")
                end
            end
        elseif self.CurButtonState == "Slide" then
            if self.SkillInfos[ESkillName.Slide].SkillActive then
                if (not EMUIAnimationSubsystem:EMPlayAnimation(self, self.VX_Slide) or not EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click) or not EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)) then
                    if self.LastAnime then
                        EMUIAnimationSubsystem:EMPlayAnimation(self, self.LastAnime, EUMGSequencePlayMode.Reverse)
                    end
                    self.LastAnime = self.VX_Slide
                    self:PlayAndSetVisibility("Slide")
                end
            end
        elseif self.CurButtonState == "Normal" then
            --self:StopAllAnimations()
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
            self:EndBtnAnimation()
        elseif self.CurButtonState == "Press" then
            if self.LastAnime then
                EMUIAnimationSubsystem:EMPlayAnimation(self, self.LastAnime, EUMGSequencePlayMode.Reverse)
                self.LastAnime = nil
            end
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
        end
    end
    self.LastButtonState = self.CurButtonState
end

--结束动作后将小图标变回默认状态
function Jump_Phone_C:EndBtnAnimation()
    if self.LastAnime then
        local anime = self.LastAnime
        self.LastAnime = nil
        self:AddTimer(0.1, function()
            if anime then
                EMUIAnimationSubsystem:EMPlayAnimation(self, anime, EUMGSequencePlayMode.Reverse)
                self:AddTimer(anime:GetEndTime(), function()
                    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
                end)
            else
                EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
            end
        end)
    end
end

function Jump_Phone_C:OnSkillActive(SkillName)
    if not self.SkillInfos[SkillName] then
        return
    end
    self.SkillInfos[SkillName].SkillActive = true
    local AnimName = self.SkillInfos[SkillName].AnimName
    EMUIAnimationSubsystem:EMPlayAnimation(self, self[AnimName])
end

function Jump_Phone_C:OnSkillInActive(SkillName)
    if not self.SkillInfos[SkillName] then
        return
    end
    self.SkillInfos[SkillName].SkillActive = false
    local AnimName = self.SkillInfos[SkillName].AnimName
    EMUIAnimationSubsystem:EMPlayAnimation(self, self[AnimName], EUMGSequencePlayMode.Reverse)
end

function Jump_Phone_C:OnGuideStart(SkillName)
    self.GuidingSkill = self.GuidingSkill or {}
    local CurEvent
    if SkillName == "SlideAttack" then
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Guide_Slide_Attack)
        CurEvent = EventID.OnSlideAttackPressed
        self.GuidingSkill["Slide_Attack"] = CurEvent
    elseif SkillName == ESkillName.Slide or SkillName == "Slide" then
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Guide_Slide)
        CurEvent = EventID.OnSlidePressed
        self.GuidingSkill["Slide"] = CurEvent
    elseif SkillName == ESkillName.BulletJump or SkillName == "BulletJump" then
        if self.CurrentLayout == 2 then
            return
        end
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Guide_Bullet_Jump)
        CurEvent = EventID.OnBulletJumpStarted
        self.GuidingSkill["Bullet_Jump"] = CurEvent
    else
        return
    end

    self.Panel_State_Guide:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.ListenEvent = self.ListenEvent or {}
    self:AddDispatcher(CurEvent, self, function() self:OnUseGuidingSkill(SkillName) end)
end

function Jump_Phone_C:OnUseGuidingSkill(SkillName)
    if not self.GuidingSkill[SkillName] then
        return
    end
    EMUIAnimationSubsystem:EMPlayAnimation(self, self["Guide_"..SkillName], EUMGSequencePlayMode.Reverse)
    self:RemoveDispatcher(self.GuidingSkill[SkillName])
    self.GuidingSkill[SkillName] = nil
end

function Jump_Phone_C:OnGuideEnd()
    self.GuidingSkill = self.GuidingSkill or {}
    for SkillName, _ in pairs(self.GuidingSkill) do
        EMUIAnimationSubsystem:EMPlayAnimation(self, self["Guide_"..SkillName], EUMGSequencePlayMode.Reverse)
    end
    self.Panel_State_Guide:SetVisibility(ESlateVisibility.Collapsed)
    self.GuidingSkill = {}
end

function Jump_Phone_C:OnStartMountFly()
    local IconMat = self.Image_Main:GetDynamicMaterial()
    IconMat:SetTextureParameterValue("Icon_Ranged", self.Icon_MountUp)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Flash)
end

function Jump_Phone_C:OnStopMountFly()
    local IconMat = self.Image_Main:GetDynamicMaterial()
    IconMat:SetTextureParameterValue("Icon_Ranged", self.Icon_Jump)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Flash)
end

function Jump_Phone_C:OnEnableBattleMount()
    self:OnSkillInActive(ESkillName.Slide)
    self:OnSkillInActive(ESkillName.Attack)
    self:OnSkillInActive(ESkillName.BulletJump)
end

function Jump_Phone_C:OnDisableBattleMount()
    self:OnSkillActive(ESkillName.Slide)
    self:OnSkillActive(ESkillName.Attack)
    self:OnSkillActive(ESkillName.BulletJump)
end


AssembleComponents(Jump_Phone_C)

return Jump_Phone_C
