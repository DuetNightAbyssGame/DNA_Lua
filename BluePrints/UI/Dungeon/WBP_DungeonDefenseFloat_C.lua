require "UnLua"

local WBP_DungeonDefenseFloat_C = Class("BluePrints.UI.Dungeon.WBP_DungeonUIBase_C")

function WBP_DungeonDefenseFloat_C:Initialize(Initializer)
    self.Super.Initialize(self)
    self.IsPause = false
    self.LastShield = nil
    self.LastHp = nil
    self.UpdateTickTime = 0.5       -- 更新信息的Tick时间
    -- self.AnimTime = 0.5             -- 扣血动画的播放时长
    -- self.AnimDelayTime = 0.5        -- 在此时间内没受到伤害再开始播扣血动画
    -- self.HinTextTime = 3.0          -- 提示文字显示时间
    self.LowHpPercent = 0.5
    -- self.CurTaskPath = nil
    self.WavesRemained = nil      -- Magic Number for now I guess
    self.CurTargetActor = nil   -- 对应的Actor，可能是防御核心也可能是人质
	self.ToastShowTime = 1
    self.DefenseCoreNameSet = false
    rawset(self, "NormalColor", FLinearColor(0.274677,0.637597,0.341915,1.0))
    rawset(self, "CriticalColor", FLinearColor(0.63,0,0,1.0))
    local PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self)
    if PlatformName ~= "PC" then
        self.UpdateTickTime = 1.0
    end
end

function WBP_DungeonDefenseFloat_C:InitListenEvent()
	self.Super.InitListenEvent(self)
    -- self:AddDispatcher(EventID.OnDefenseWaveStart, self, self.OnDefenseWaveStart)
    self:AddDispatcher(EventID.CloseDungeonUI, self, self.CloseDungeonUI)
    self:AddDispatcher(EventID.OnSetTempleLimit, self, self.OnSetTempleLimit)
    self:AddDispatcher(EventID.OnTempleTimeChanged, self, self.OnTempleTimeChanged)
    self:AddDispatcher(EventID.OnTempleScoreCollectChanged, self, self.OnTempleScoreCollectChanged)
	self:AddDispatcher(EventID.OnDefenseWaveStart, self, self.OnDefenseWaveStart)
	self:AddDispatcher(EventID.OnWaveStart, self, self.OnWaveStart)
	self:AddDispatcher(EventID.OnWaveEnd, self, self.OnWaveEnd)
	self:AddDispatcher(EventID.OnDefenceWaveEnd, self, self.OnDefenceWaveEnd)
    --self:AddDispatcher(EventID.OnDefenceWaveEnd, self, self.OnDefenceWaveEnd)
    --self:AddDispatcher(EventID.OnDefenceVoteBegin, self, self.OnDefenceVoteBegin)
    --self:AddDispatcher(EventID.OnRepDungeonProgress, self, self.UpdateDungeonProgressDisplay)
end

function WBP_DungeonDefenseFloat_C:UIStateChange_OnTarget()
    if self.TempleMode then
        return
    end
    if self.IsSynthesisIIMode then
        self.CurTargetActor = nil
        self.IsActive = false
    end
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if not GameState then return end
    self.IsRescueMode = GameState.GameModeType == "Rescue"

    if self.IsRescueMode then
        self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.BattlePanel:SetVisibility(UE4.ESlateVisibility.Visible)
        self:AddTimer(self.UpdateTickTime, self.UpdateTargetInfo, true, 0, "UpdateMechanism", false)
        self.DefenseCoreName:SetText(GText("UI_DUNGEON_HOSTAGE"))
        self.LowHpPercent = 0.01
        self:HideUselessWidget()
        self.IsClient = IsClient(self)
        self:AddDispatcher(EventID.NotifyClientChangeHostageInvincible, self, self.SetInvincibility)
    else
        --self:OnDefenceCoreActive()
        self:TryOnDefenceCoreActive()
        self:UpdateWaveCount()
        self:AddTimer(self.UpdateTickTime, self.UpdateTargetInfo, true, 0, "UpdateMechanism", false)
    end

    if self.IsSynthesisMode then
        self:HideUselessWidget()
    elseif self.IsSynthesisIIMode then
        self:HideSynthesisIIUselessWidget()
        self.DefenseCoreName:SetText(GText("DUNGEON_SYNTHESIS2_112"))
    end

	self.BattlePanel:SetVisibility(UE4.ESlateVisibility.Visible)
end

function WBP_DungeonDefenseFloat_C:UIStateChange_None()
    if self.IsSynthesisIIMode then
        self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function WBP_DungeonDefenseFloat_C:CloseDungeonUI()
    if self.TempleMode then
        return
    end
    if self.IsSynthesisMode then
        -- 按理说别的玩法也该回收LowHealthUI 不知道别的玩法怎么做的或者是漏了 先这样吧
        local LowHealthUI = UIManager(self):GetUIObj("DefenseLowHealth")
        if LowHealthUI then
            UIManager(self):UnLoadUINew("DefenseLowHealth")
        end
    end
    self:RemoveFromParent()
end
function WBP_DungeonDefenseFloat_C:PauseCountDown()
    self.IsPause = true
end

function WBP_DungeonDefenseFloat_C:ResumeCountDown()
    self.IsPause = false
end

function WBP_DungeonDefenseFloat_C:OnEnd()
    -- 结束
   print(_G.LogTag,"WBP_DungeonDefenseFloat_C:OnEnd()")
end

function WBP_DungeonDefenseFloat_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.BattlePanel:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.IsActive = nil
    self:CheckDungeonMode()

    self:OnDungeonUIStateUpdated()
    self:InitWidgetInfo()
    self:InitListenEvent()
    if self.TempleMode then
        self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.BattlePanel:SetVisibility(UE4.ESlateVisibility.Visible)
        return
    end
    self.IsRescueMode = ...
    self.LastHpPercent = 1.0

    self.SizeBox_HP:ClearChildren()
    self.SizeBox_Shield:ClearChildren()
    --self:HideUselessWidget()
    self:LoadHpBar()
    self:LoadShieldBar()


    -- if self.IsRescueMode then
    --     self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    --     self.BattlePanel:SetVisibility(UE4.ESlateVisibility.Visible)
    --     self:AddTimer(self.UpdateTickTime, self.UpdateTargetInfo, true, 0, "UpdateMechanism", false)
    --     self.DefenseCoreName:SetText(GText("UI_DUNGEON_HOSTAGE"))
    --     self.LowHpPercent = 0.01
    -- else
    --     self.LowHpPercent = 0.5
    --     self.TextBlock_1:SetText(GText("UI_Defense_Done")) -- 已防御
    --     self.TextBlock_2:SetText(GText("UI_Defense_Remain")) -- 剩余防御波次
    -- end
end

function WBP_DungeonDefenseFloat_C:ReActiveCurGuideAnim()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if (UIManager == nil or not UE4.UKismetSystemLibrary.IsValid(UIManager)) then
        return
    end
    local Result = TArray("")
    for k, v in pairs(UIConst.DUNGEONINDICATOR) do
        local ret = UIManager:GetAllUINameByBPClass(UE4.UClass.Load(v))
        if (ret:Length() > 0) then
            for i = 1, ret:Length(), 1 do
                Result:Add(ret:GetRef(i)) 
            end
        end
    end
    for i = 1, Result:Length() do
        local UIName = Result:GetRef(i)
        local GuideIcon = UIManager:GetUIObj(UIName)
        if (GuideIcon ~= nil) then
            GuideIcon:RePlayAppearAnim()
        end
    end
end

function WBP_DungeonDefenseFloat_C:UpdateTargetInfo()
    local CurTargetActor = self:GetTargetActor()
    if not CurTargetActor and not self.IsClient then
        return
    end

    if not self:IsAnimationPlaying(self.Shield_Glow) then
        self.Shield_glowLine:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if not self:IsAnimationPlaying(self.HP_Glow) then
        self.HP_glowLine:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if not self.DefenseCoreNameSet and not self.IsRescueMode and CurTargetActor and DataMgr.Mechanism[CurTargetActor.UnitId].UnitName then
        self.DefenseCoreName:SetText(GText(DataMgr.Mechanism[CurTargetActor.UnitId].UnitName))
        self.DefenseCoreNameSet = true
    end
    local NewShield = self:GetAttrFromTarget(CurTargetActor, "ES")
    local MaxShield = self:GetAttrFromTarget(CurTargetActor, "MaxES")
    local NewHp = self:GetAttrFromTarget(CurTargetActor, "Hp")
    local MaxHp = self:GetAttrFromTarget(CurTargetActor, "MaxHp")
    local OverShield = self:GetAttrFromTarget(CurTargetActor, "OverShield")
    if not self.LastHp then self.LastHp = NewHp end
    if not self.LastShield then self.LastShield = NewShield end
    if not self.LastOverShield then self.LastOverShield = OverShield end

    --护盾值变化
    local NewShieldPercent = (NewShield + OverShield) / MaxShield
    local ShieldBar = self.ShieldBar
    local HpBar = self.HpBar
    local LastShield = self.LastShield
    local LastHp = self.LastHp
    if(LastShield > NewShield)then
        ShieldBar:SetBarPercent(NewShieldPercent)
        if(NewShield < LastShield)then
            ShieldBar:PlayDeduct(true)
        end
    elseif (LastShield < NewShield) then
        ShieldBar:SetBarPercent(NewShieldPercent,false)
        ShieldBar:PlayRecoveryShield()
    else
        ShieldBar:DirectSetBarPercent(NewShieldPercent,0.0)
    end

    if self.IsRescueMode then
        local NewOverShieldPercent = MaxShield > 0 and OverShield/MaxShield or 0
        if self.LastOverShield > OverShield or NewOverShieldPercent < 0.001 then
            ShieldBar:SetOverShieldPercent(NewOverShieldPercent)
            ShieldBar:PlayOverShieldDeduct(true)
            if (NewOverShieldPercent < 0.001) then
                ShieldBar:ShowOrHideOverShieldGroup(false)
            end
        elseif self.LastOverShield < OverShield  then
            ShieldBar:SetOverShieldPercent(NewOverShieldPercent)
            if (self.LastOverShield < 0.001) then
                ShieldBar:ShowOrHideOverShieldGroup(true)
            end
            ShieldBar:PlayOverShieldRecover()
        end
    end

    --血量变化
    local NewHpPercent = NewHp / MaxHp
    HpBar:SetBarPercent(NewHpPercent)
    if(LastHp > NewHp)then
        if(NewHp < LastHp)then
            HpBar:PlayDeduct(true)
        end
    end

    -- 播一些防御核心才有的动效
    if not self.IsRescueMode then
        if not CurTargetActor or not CurTargetActor.ForbideLowHealthUI then
            self:LoadLowHealthUI(NewHpPercent)
        end

        if LastHp > NewHp then
            if NewHpPercent < self.LastHpPercent then
                self:PlayGlowAnim(NewHp / MaxHp, self.HP_glowLine, self.Warning_Glow)
            else
                self:PlayGlowAnim(NewHp / MaxHp, self.HP_glowLine, self.HP_Glow)
            end
        end

        if LastShield > NewShield then
            self:PlayGlowAnim(NewShield / MaxShield, self.Shield_glowLine, self.Shield_Glow)
        end

    end

	if NewHpPercent < (self.LowHpPercent or 0.5) then
		-- if not self:IsAnimationPlaying(self.HP_Warning) and not self:IsAnimationPlaying(self.Warning_Glow) then
		-- 	self:PlayAnimation(self.HP_Warning)
		-- end
        HpBar:SetProgressBarColorInner(self.CriticalColor)
	else
        HpBar:SetProgressBarColorInner(self.NormalColor)
	end

    self.LastShield = NewShield
    self.LastHp = NewHp
    self.LastHpPercent = NewHpPercent
    self:SetBloodAndShieldNum(NewHp,NewShield,NewHpPercent)
end

function WBP_DungeonDefenseFloat_C:PlayGlowAnim(NewPercent,Glow,GlowAnim)
    if self.IsRescueMode then
        return
    end
    local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.SizeBox_HP)
    local SlotSize = CanvasSlot:GetSize()
    local ProgressBarLength = SlotSize.X * self.SizeBox_HP.RenderTransform.Scale.X
    local Glow_Pos = FVector2D(0.0,0.0)
    Glow_Pos.X = ProgressBarLength * NewPercent
    local GlowSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(Glow)
    Glow_Pos.Y = GlowSlot:GetPosition().Y
    GlowSlot:SetPosition(Glow_Pos)
    Glow:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    EMUIAnimationSubsystem:EMPlayAnimation(self,GlowAnim)
end

function WBP_DungeonDefenseFloat_C:SetInvincibility(bIsInvincibility)
    if bIsInvincibility == nil then
        bIsInvincibility = true
    end

    if self.HpBar then
        self.HpBar:PlayInvincibility(bIsInvincibility)
    end

    if self.ShieldBar then
        self.ShieldBar:PlayInvincibility(bIsInvincibility)
    end
end

function WBP_DungeonDefenseFloat_C:SetBloodAndShieldNum(NewHp,NewShield,HpPercent)
    self.Num_Shield:SetText(math.floor(NewShield))
    self.Num_Blood:SetText(math.floor(NewHp))
    local Color = FSlateColor()
    local bIsLowPercent = HpPercent< self.LowHpPercent
    if bIsLowPercent then
        Color.SpecifiedColor.R = 1.0
        Color.SpecifiedColor.G = 0.048
        Color.SpecifiedColor.B = 0.048
        self.Num_Blood:SetColorAndOpacity(Color)
    else
        Color.SpecifiedColor.R = 0.258183
        Color.SpecifiedColor.G = 0.590619
        Color.SpecifiedColor.B = 0.318547
        self.Num_Blood:SetColorAndOpacity(Color)
    end

    if self.IsRescueMode then
        if bIsLowPercent then
            self.DefenseCoreName:SetColorAndOpacity(Color)
        else
            Color.SpecifiedColor.R = 1.0
            Color.SpecifiedColor.G = 1.0
            Color.SpecifiedColor.B = 1.0
            self.DefenseCoreName:SetColorAndOpacity(Color)
        end
    end

end

function WBP_DungeonDefenseFloat_C:UpdateDungeonProgressDisplay(DungeonProgress)
    self.Num_Wave_Now:SetText(DungeonProgress)
end

------------------------------- 防御核心相关方法 --------------------------------------------
-- 客户端同步顺序不可靠，如果OnTarget时防御核心未在客户端生成，OnDefenceCoreActive拿不到防御核心
-- 如果防御核心先在客户端生成，再LoadUI，就会收不到OnDefenceCoreActive（旧的写法）
-- 干脆加个timer查询好了（其实改成防御核心在客户端生成时广播事件更好，先这样吧
function WBP_DungeonDefenseFloat_C:TryOnDefenceCoreActive()
    if self:OnDefenceCoreActive() then
        return
    else
        self:AddTimer(0.1, function()
            if self:OnDefenceCoreActive() then
                self:RemoveTimer("TryOnDefenceCoreActive")
            end
        end, true, 0, "TryOnDefenceCoreActive")
    end
end

function WBP_DungeonDefenseFloat_C:OnDefenceCoreActive()
    if self.TempleMode then return end
    local DefenseCore = self:GetDefenseCore()
    -- DebugPrint("WBP_DungeonDefenseFloat_C:OnDefenceCoreActive",DefenseCore,self.IsActive)
    if not DefenseCore or self.IsActive then 
        return false
    end
    self.IsActive = true
    self.LowHpPercent = 0.5
    self.TextBlock_1:SetText(GText("UI_Defense_Done")) -- 已防御
    self.TextBlock_2:SetText(GText("UI_Defense_Remain")) -- 剩余防御波次
    self.Num_Shield:SetText(math.floor(DefenseCore:GetAttr("MaxES")))
    self.Num_Blood:SetText(math.floor(DefenseCore:GetAttr("MaxHp")))
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.BattlePanel:SetVisibility(UE4.ESlateVisibility.Visible)

    if self.IsNewDefenceMode then
        self.Defensivewave:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.LeftWave:SetVisibility(UE4.ESlateVisibility.Collapsed)
        -- 交互迭代 不要这个了 直接折叠吧
        -- if self.IsEndlessMode then
        --     self.Panel_Wave_Now:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        -- end
        self.Panel_Wave:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

        -- self.Text_Wave_Now:SetText(GText("TARGET_DUNGEON_ROUND"))
        -- self:UpdateDungeonProgressDisplay(GameState(self).DungeonProgress)
        self.Text_Wave:SetText(GText("TARGET_DUNGEON_DEFENCE_WAVE"))
    end

    return true
end



function WBP_DungeonDefenseFloat_C:OnDefenceCoreDead(Callback)
    if self.TempleMode then return end
    self.HpBar:SetBarPercent(0)
    self.Hp_glowLine:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self:SetBloodAndShieldNum(0,0,0)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local LowHealthUI = UIManager:GetUIObj("DefenseLowHealth")
    if LowHealthUI then
        LowHealthUI:OnDefenceCoreDead(Callback)
    elseif Callback then
        Callback()
    end
end

-- function WBP_DungeonDefenseFloat_C:OnDefenseWaveStart()
--     local GameState = UE4.UGameplayStatics.GetGameState(self)
--     if not GameState then
--         return
--     end
--     if not self.WavesRemained then self.WavesRemained = GameState.DefenceWavesPerStage end
--     self.DefendedWaveCount:SetText(GameState.DefenceWave - 1)
--     self.RemainingWaveCount:SetText(self.WavesRemained)
--     self.WavesRemained = self.WavesRemained - 1
--     if self.WavesRemained <= 0 then
--         self.WavesRemained = GameState.DefenceWavesPerStage
--     end
--     self:AddTimer(self.UpdateTickTime, self.UpdateTargetInfo, true, 0, "UpdateMechanism", false)
-- end

function WBP_DungeonDefenseFloat_C:LoadLowHealthUI(CurrentPercent)
    if not CurrentPercent then
        return
    end

    if self.IsSynthesisIIMode and self:GetVisibility() == UE4.ESlateVisibility.Collapsed then
        return
    end

    local UIManager = GWorld.GameInstance:GetGameUIManager()
    if CurrentPercent <= 0.3 then
        if self.LastHpPercent > 0.3 then
            local WarningLastTime = 1.5
            local WarningText = GText("UI_Tosat_Defense_LowHealth")
            if self.IsSynthesisMode then
                WarningText = GText("DUNGEON_SYNTHESIS_106")
            end
            UIManager:ShowUITip(UIConst.Tip_CommonWarning, WarningText, WarningLastTime)
            self:AddTimer(WarningLastTime + 0.2,function()
                UIManager:LoadUINew("DefenseLowHealth")
            end,false,0,nil,false)
		end
        local LowHealthUI = UIManager:GetUIObj("DefenseLowHealth")
        if LowHealthUI then
           LowHealthUI.Text_Health:SetText(tostring(math.floor(CurrentPercent * 100)))
        end
    else
        local LowHealthUI = UIManager:GetUIObj("DefenseLowHealth")
        if LowHealthUI then
            UIManager:UnLoadUINew("DefenseLowHealth")
        end
    end


end

------------------------------- 防御核心相关方法END  ----------------------------------------

------------------------------- 加载血条和护盾条 --------------------------------------------

function WBP_DungeonDefenseFloat_C:LoadSubWidget(Container,WidgetName,...)
    if not Container then return end
    local SubWidget = self:CreateWidgetNew(WidgetName)
    Container:AddChild(SubWidget)
    SubWidget:Init(...)
    return Container:GetChildAt(0)
end

function WBP_DungeonDefenseFloat_C:LoadHpBar()
    local BarLength = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.SizeBox_HP):GetSize().X
    self.HpBar = self:LoadSubWidget(self.SizeBox_HP, "HPBar", false,BarLength)
end

function WBP_DungeonDefenseFloat_C:LoadShieldBar()
    local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.SizeBox_Shield)
    local Size = CanvasSlot:GetSize()
    self.ShieldBar = self:LoadSubWidget(self.SizeBox_Shield,"ShieldBar",Size.X,Size.Y)
end

------------------------------- 加载血条和护盾条END --------------------------------------------

function WBP_DungeonDefenseFloat_C:HideUselessWidget()
    local SafeHide = function (Target,Level)
        if Target and Level then
            Target:SetVisibility(Level)
        end
    end
    SafeHide(self.HorizontalBox_HP,UE4.ESlateVisibility.Collapsed)
    SafeHide(self.Deduct_Blood,UE4.ESlateVisibility.Collapsed)
    SafeHide(self.Deduct_Shield,UE4.ESlateVisibility.Collapsed)
    if self.IsRescueMode then
        SafeHide(self.Defensivewave,UE4.ESlateVisibility.Collapsed)
        SafeHide(self.LeftWave,UE4.ESlateVisibility.Collapsed)
    end
    if self.IsSynthesisMode then
        SafeHide(self.Defensivewave,UE4.ESlateVisibility.Collapsed)
        SafeHide(self.LeftWave,UE4.ESlateVisibility.Collapsed)
    end
end

function WBP_DungeonDefenseFloat_C:HideSynthesisIIUselessWidget()
    local SafeHide = function (Target,Level)
        if Target and Level then
            Target:SetVisibility(Level)
        end
    end
    SafeHide(self.Panel_Wave,UE4.ESlateVisibility.Collapsed)
    SafeHide(self.Deduct_Blood,UE4.ESlateVisibility.Collapsed)
    SafeHide(self.Panel_Wave_Now,UE4.ESlateVisibility.Collapsed)
    SafeHide(self.Defensivewave,UE4.ESlateVisibility.Collapsed)
    SafeHide(self.LeftWave,UE4.ESlateVisibility.Collapsed)
end

---------------------------------- 获取目标 ----------------------------------------

function WBP_DungeonDefenseFloat_C:GetTargetActor()
    local Target
    if self.IsRescueMode then
        Target = self:GetRescueActor()
    else
        Target = self:GetDefenseCore()
    end
    -- TODO 后续迭代成存EID
    if IsValid(Target) then
        return Target
    end
end

function WBP_DungeonDefenseFloat_C:GetDefenseCore()

    if IsValid(self.CurTargetActor) then
        return self.CurTargetActor
    end

    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if not GameState then
        return
    end

    local Keys = GameState.DefBaseMap:Keys()
    if Keys:Length() <= 0 then
        return
    end

    local MechanismEid = Keys:GetRef(1)
    local CurTargetActor = Battle(self):GetEntity(MechanismEid)
    if not CurTargetActor then
        return
    end
    self.CurTargetActor = CurTargetActor
	return self.CurTargetActor
end

function WBP_DungeonDefenseFloat_C:GetRescueActor()
    
    if IsValid(self.CurTargetActor) then
        return self.CurTargetActor
    end

    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if not GameState then
        return
    end

    for _,AI in pairs(GameState.MonsterMap) do
        if IsValid(AI) and AI.IsHostage then
            self.CurTargetActor = AI
            break
        end
    end
    return self.CurTargetActor
end
---------------------------------- 获取目标END ----------------------------------------

---------------------------------- 神庙相关 -------------------------------------------

function WBP_DungeonDefenseFloat_C:CheckDungeonMode()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    if not GameInstance then
        return
    end
    self.DungeonId = GameInstance:GetCurrentDungeonId()
    self.DungeonInfo = DataMgr.Dungeon[self.DungeonId]
    if not self.DungeonInfo then
        return
    end
    if self.DungeonInfo.DungeonWinMode == CommonConst.DungeonWinMode.Endless then
        self.IsEndlessMode = true
    end
    if self.DungeonInfo.DungeonType == "Defence" or self.DungeonInfo.DungeonType == "DefenceMove" then
        self.IsNewDefenceMode = true
    end
    if self.DungeonInfo.DungeonType == "Temple" then
        self.TempleMode = true
        self.TempleInfo = DataMgr.Temple[self.DungeonId]
        self:InitTemple()
    end
    if self.DungeonInfo.DungeonType == "Synthesis" then
        self.IsSynthesisMode = true
    end
    if self.DungeonInfo.DungeonType == "SynthesisII" then
        self.IsSynthesisIIMode = true
    end
end

function WBP_DungeonDefenseFloat_C:InitTemple()
    -- 神庙左侧UI
    self.BattlePanel:SetVisibility(UE4.ESlateVisibility.Visible)
    self.Bar_Blood:SetVisibility(ESlateVisibility.Collapsed)
    self.Num_Shield:SetVisibility(ESlateVisibility.Collapsed)
    self.Num_Blood:SetVisibility(ESlateVisibility.Collapsed)
    self.DefendedWaveCount:SetVisibility(ESlateVisibility.Collapsed)
    self.RemainingWaveCount:SetVisibility(ESlateVisibility.Collapsed)
    self.DefenseCoreName:SetVisibility(ESlateVisibility.Hidden)
    self.Spacer_Temple:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    local CurrentColor = self.TextBlock_1.ColorAndOpacity
    CurrentColor.SpecifiedColor.A = 1.0
    self.TextBlock_1:SetColorAndOpacity(CurrentColor)
    self.BattlePanel:SetVisibility(ESlateVisibility.Hidden)
    self.IsCountDown = false
    if self.TempleInfo.SucRule == "CountDown" then
        self.IsCountDown = true
    else
        self:InitTargetInfo()
    end
end

function WBP_DungeonDefenseFloat_C:OnTempleTimeChanged(CurrentTime, ThresholdTime)
    if self.TempleInfo.SucRule == "Time" then
        local Time = self:GetTimeStr(CurrentTime)
        self.TextBlock_2:SetText(GText("UI_TEMPLE_TOTAL_TIME") .. ": " .. Time)
    end
    if self.Limit == "TIME" then
        local Time = ThresholdTime - CurrentTime
        if Time >= 0 then
            self.DefenseCoreName:SetText(GText("UI_TEMPLE_LIMIT_" .. self.Limit) .. self:GetTimeStr(Time))
        end
    end
end

function WBP_DungeonDefenseFloat_C:OnSetTempleLimit(Limit, Value)
    self.Limit = Limit
    self.DefenseCoreName:SetVisibility(ESlateVisibility.Visible)
    if Limit == "TIME" then
        self.TimeThreshold = Value
        local Time = self:GetTimeStr(Value)
        self.DefenseCoreName:SetText(GText("UI_TEMPLE_LIMIT_" .. self.Limit) .. Time)
    else
        self.DefenseCoreName:SetText(GText("UI_TEMPLE_LIMIT_" .. self.Limit) .. Value)
    end
    if self.IsCountDown then
        self:InitTargetInfo()
    end
end

function WBP_DungeonDefenseFloat_C:OnTempleScoreCollectChanged(Value)
    self.TextBlock_2:SetText(GText("UI_TEMPLE_TOTAL_" .. string.upper(self.TempleInfo.SucRule)) .. ": " .. Value)
end

function WBP_DungeonDefenseFloat_C:OnTempleDeathFallChanged(Value)
    if Value >= 0 then
        self.DefenseCoreName:SetText(GText("UI_TEMPLE_LIMIT_" .. self.Limit) .. Value)
    end
end

function WBP_DungeonDefenseFloat_C:InitTargetInfo()
    -- self.TextBlock_1:SetText(GText(self.DungeonInfo.DungeonName) .. "\n\n" .. GText("UI_TEMPLE_" .. self.DungeonId) .. "\n")
    --self.TextBlock_1:SetText(GText(self.DungeonInfo.DungeonName) .. "\n\n" .. GText("UI_TEMPLE_" .. self.DungeonId) .. "\n" .. "神庙神庙神庙神庙神庙" .. "\n" .."神庙神庙神庙".."\n".."神庙神庙神庙神庙神庙神庙神庙".."\n")
    local TextRule2 = ""
    if self.TempleInfo.SucRule == "Time" then
        TextRule2 = "SECONDS"
        self.TextBlock_2:SetText(GText("UI_TEMPLE_TOTAL_" .. string.upper(self.TempleInfo.SucRule)) .. ": 00:00")
    elseif self.TempleInfo.SucRule == "CountDown" then
        TextRule2 = "SECONDS"
        self.TextBlock_2:SetVisibility(ESlateVisibility.Collapsed)
    elseif self.TempleInfo.SucRule == "Score" then
        TextRule2 = "SCORE"
        self.TextBlock_2:SetText(GText("UI_TEMPLE_TOTAL_" .. string.upper(self.TempleInfo.SucRule)) .. ": 0")
    elseif self.TempleInfo.SucRule == "Collect" then
        TextRule2 = "COUNT"
        self.TextBlock_2:SetText(GText("UI_TEMPLE_TOTAL_" .. string.upper(self.TempleInfo.SucRule)) .. ": 0")
    end

    local Text = GText("UI_TEMPLE_" .. self.DungeonId)
    if #self.TempleInfo.RewardId > 1 and #self.TempleInfo.RatingRange > 1 then
        for i = 3, 1, -1 do
            local TextInfo = ""
            local Target = self.TempleInfo.RatingRange[i]
            if Target == 0 then
                TextInfo = GText("UI_TEMPLE_SUCRULE_ZERO")
            else
                if self.TempleInfo.SucRule == "CountDown" and self.TempleInfo.UIShowType and self.TempleInfo.UIShowType > 0 and self.TimeThreshold and self.TimeThreshold > 0 then
                    TextInfo = string.format(GText("UI_TEMPLE_SUCRULE_COUNTDOWN_" .. self.TempleInfo.UIShowType), self.TimeThreshold - Target)
                elseif TextRule2 == "SCORE" then
                    TextInfo = GText("UI_TEMPLE_SUCRULE_" .. string.upper(self.TempleInfo.SucRule)) .. Target
                else
                    TextInfo = GText("UI_TEMPLE_SUCRULE_" .. string.upper(self.TempleInfo.SucRule)) .. Target .. GText("UI_TEMPLE_MEASURE_" .. TextRule2)
                end
            end
            Text = Text .. "\n" .. GText("UI_TEMPLE_BLANK") .. GText("UI_TEMPLE_STAR_" .. i) .. TextInfo
        end
    end
    self.TextBlock_1:SetText(Text)

    self.BattlePanel:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

---------------------------------- 神庙相关END ----------------------------------------

function WBP_DungeonDefenseFloat_C:GetWaveStartBP()
	local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)

    local UIManager = GameInstance:GetGameUIManager()
    if UIManager == nil then
		return
	end
	local UIManager = GameInstance:GetGameUIManager()
    local WaveStartBP = UIManager:GetUIObj("WaveStartBP")
    if not WaveStartBP then
        WaveStartBP = UIManager:LoadUINew("WaveStartBP")
    end

	WaveStartBP:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)

	return WaveStartBP 
end

function WBP_DungeonDefenseFloat_C:OnDefenseWaveStart()
	local GameState = UE4.UGameplayStatics.GetGameState(self)
	if not GameState then
		return
	end
	self.HintTime = GameState.DefenceWaveInterval

    local WaveStartBP = self:GetWaveStartBP()
	if WaveStartBP then
		--WaveStartBP:SetVisibility(ESlateVisibility.Collapsed)
        WaveStartBP:Hide("OnDefenseWaveStart")      -- 不用SetVisibility，否则别处（例如隐藏/显示所有ui时）调用Show会把他也错误地显示出来。下面改show同理
		WaveStartBP.Text_WaveStart:SetText(GText("DUNGEON_DEFENCE_101"))
		self:AddTimer(self.HintTime, function()
			--WaveStartBP:SetVisibility(ESlateVisibility.HitTestInvisible)
            WaveStartBP:Show("OnDefenseWaveStart")
            WaveStartBP:PlayInAnimation()
            AudioManager(self):PlayUISound(nil, "event:/ui/common/battle_warning", nil, nil)
			-- WaveStartBP:PlayAnimation(WaveStartBP.In)
		end)

		self:AddTimer(self.HintTime + self.ToastShowTime, function()
            WaveStartBP:PlayOutAnimation()
			-- WaveStartBP:PlayAnimation(WaveStartBP.Out)
		end)
	end
	self:ShowCountDown()
    self:UpdateWaveCount()
    self:AddTimer(self.UpdateTickTime, self.UpdateTargetInfo, true, 0, "UpdateMechanism", false)

end

function WBP_DungeonDefenseFloat_C:OnWaveStart()
	local GameState = UE4.UGameplayStatics.GetGameState(self)
    if not GameState then
        return
    end
	self.HintTime = GameState.DefenceWaveInterval

	local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if UIManager == nil then
		return
	end
	local UIManager = GameInstance:GetGameUIManager()
    local GuideTextFloat = UIManager:GetUIObj("GuideTextFloat")
    if not GuideTextFloat then
        GuideTextFloat = UIManager:LoadUI(UIConst.GUIDETEXTFLOAT, "GuideTextFloat", UIConst.ZORDER_FOR_SECONDARY_POPUP)
    end
	if GuideTextFloat then
		GuideTextFloat:ShowDungeonGuide("DUNGEON_TRAINING_101", self.ToastShowTime)
	end
	self:AddTimer(self.ToastShowTime, self.ShowCountDown)
end

function WBP_DungeonDefenseFloat_C:OnDefenceWaveEnd()
	local WaveStartBP =self:GetWaveStartBP()
	if WaveStartBP then
		WaveStartBP.Text_WaveStart:SetText(GText("DUNGEON_DEFENCE_102"))
        EMUIAnimationSubsystem:EMPlayAnimation(WaveStartBP,WaveStartBP.In)
		-- WaveStartBP:PlayAnimation(WaveStartBP.In)

		self:AddTimer(self.ToastShowTime, function()
            EMUIAnimationSubsystem:EMPlayAnimation(WaveStartBP,WaveStartBP.Out)
			-- WaveStartBP:PlayAnimation(WaveStartBP.Out)
		end)
	end
end

function WBP_DungeonDefenseFloat_C:OnWaveEnd()
	local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if UIManager == nil then
		return
	end
	local UIManager = GameInstance:GetGameUIManager()
    local GuideTextFloat = UIManager:GetUIObj("GuideTextFloat")
    if not GuideTextFloat then
        GuideTextFloat = UIManager:LoadUI(UIConst.GUIDETEXTFLOAT, "GuideTextFloat", UIConst.ZORDER_FOR_SECONDARY_POPUP)
    end
	if GuideTextFloat then
		GuideTextFloat:ShowDungeonGuide("DUNGEON_TRAINING_102", self.ToastShowTime)
	end
	self:AddTimer(self.ToastShowTime, self.ShowCountDown)
end

function WBP_DungeonDefenseFloat_C:ShowCountDown()
	local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if UIManager == nil then
		return
	end
	local UIManager = GameInstance:GetGameUIManager()
    local GuideCountDownFloat = UIManager:GetUIObj("GuideCountDown")
    if not GuideCountDownFloat then
        GuideCountDownFloat = UIManager:LoadUINew("GuideCountDown")
    end
	GuideCountDownFloat:InitializeData(self.HintTime)
end

function WBP_DungeonDefenseFloat_C:InitWidgetInfo()
    -- 在使用过当前UI后，再加载时不会重置，比如在神庙里隐藏了部分面板，但是防御关初始化UI时没有对这部分隐藏的面板设置可见性，那再进防御关时它就会继续隐藏导致显示错误，在这里初始化显示信息，希望后面各个副本不再共用UI
    self.Bar_Blood:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Num_Shield:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Num_Blood:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.DefendedWaveCount:SetVisibility(ESlateVisibility.Visible)
    self.RemainingWaveCount:SetVisibility(ESlateVisibility.Visible)
    self.DefenseCoreName:SetVisibility(ESlateVisibility.Visible)
    self.Spacer_Temple:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.TextBlock_1:SetVisibility(ESlateVisibility.Visible)
    local CurrentColor = self.TextBlock_1.ColorAndOpacity
    CurrentColor.SpecifiedColor.A = 0.8
    self.TextBlock_1:SetColorAndOpacity(CurrentColor)
    self.TextBlock_2:SetVisibility(ESlateVisibility.Visible)
    self.DefenseCoreName:SetText(GText("UI_DUNGEON_HOSTAGE"))
end

function WBP_DungeonDefenseFloat_C:UpdateWaveCount()
    if (not GameState) then return end 
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local WavesFinished = (GameState.DefenceWave - 1) % 3
    self.WavesRemained = GameState.DefenceWavesPerStage - WavesFinished
    
    if self.IsNewDefenceMode then
        self.Num_DefensedWave:SetText(WavesFinished)
        self.Num_TotalWave:SetText(GameState.DefenceWavesPerStage)
    else
        self.DefendedWaveCount:SetText(GameState.DefenceWave - 1)
        self.RemainingWaveCount:SetText(self.WavesRemained)
    end
end

function WBP_DungeonDefenseFloat_C:GetAttrFromTarget(CurTargetActor,AttrName)
    if CurTargetActor then
       return CurTargetActor:GetAttr(AttrName) 
    end

    if self.IsClient then
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        if not GameState then return end
        return GameState.HostageState["Hostage"..AttrName] or 0
    end
end
return WBP_DungeonDefenseFloat_C