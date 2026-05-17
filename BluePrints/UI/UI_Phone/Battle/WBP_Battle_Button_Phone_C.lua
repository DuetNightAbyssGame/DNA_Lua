--
-- DESCRIPTION
-- 手机端技能按键总蓝图的脚本
-- 按钮各自的逻辑写在各自的脚本里
-- 普攻、切换蹲下这两个按钮比较简单，没有脚本，逻辑都在各自蓝图里
-- @AUTHOR zhuyuhao

require "Unlua"
local EMCache = require "EMCache.EMCache"

local BattleHUDCommonConst = require "BluePrints.UI.UI_Phone.Battle.BattleHUDCommonConst"

local WBP_Battle_Button_Phone = Class("BluePrints.UI.BP_UIState_C")

WBP_Battle_Button_Phone._components = {
        "BluePrints.UI.UIComponent.TouchComponent",
        "BluePrints.UI.UI_Phone.Battle.Component.HUDWidgetDesignComponent",
}

--进行初始化
function WBP_Battle_Button_Phone:Initialize(Initializer)
    self.Super.Initialize(self)
    self.OwnerPlayer = nil
end

function WBP_Battle_Button_Phone:Construct()
    self.Super.Construct(self)
    self.NoCancelBulletJumpActions = {
        "Skill3", "Jump", "Avoid", "BulletJump"
    }
end

-- 保证在角色初始化之后执行OnLoad
function WBP_Battle_Button_Phone:ForceInit()
    self:OnLoaded()
    self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
    self:InitUnlockInfo()
    self:PlayAnim("In")
    self:InitTouchLayer(self.OwnerPlayer, 0, 0)
    self:InitVariable()
    self:GetSkillActiveInfo()
    
    self.AtkRanged:UpdateWeaponIcon()
    -- 需要UI控件实际渲染出来之后才可以，不然有可能拿到的实际坐标为(0，0)
    self.DelayAddTouchLayerTimer = self:AddTimer(0.1, self.DelayAddTouchLayer, true)
    self:InitHUDLayout()
    self:InitMountHUD()
    self.OwnerPlayer:SetSkillPanelTimer()
end

-- UI被加载的时候需要执行的逻辑
function WBP_Battle_Button_Phone:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    
end

-- 注册监听事件
function WBP_Battle_Button_Phone:InitListenEvent()
    self:AddDispatcher(EventID.UpdateMainPlayerSp,self,self.OnUpdateCharSp)
    self:AddDispatcher(EventID.UpdateMainPlayerMaxSp, self, self.OnUpdateMaxSp)
    self:AddDispatcher(EventID.UpdateSkillEfficiency, self, self.OnUpdateSkillEfficiency)
    self:AddDispatcher(EventID.OnSwitchRole, self, self.OnSwitchRole)
    self:AddDispatcher(EventID.OnSwitchPet, self, self.OnSwitchPet)
    self:AddDispatcher(EventID.OnBattlePetInitReady, self, self.OnBattlePetInitReady)
    self:AddDispatcher(EventID.ReloadStart, self, self.TryToEnterReloadState)
    self:AddDispatcher(EventID.OnSelectWeapon,self, self.RefreshWeaponInfo) -- 用于序章选武器
    self:AddDispatcher(EventID.OnSwitchWeapon, self, self.RefreshWeaponInfo) -- 用于军械库换武器或切显赫武器
    self:AddDispatcher(EventID.OnMainCharacterInitReady, self, self.RefreshWeaponInfo)
    self:AddDispatcher(EventID.OnRefreshBattleWheelEnableState, self, self.ChangeBattleWheelState)
    self:AddDispatcher(EventID.OnBuffSpModify, self, self.OnUpdateBuffSpModify)
    self:AddDispatcher(EventID.OnPropEffectReplaceSkill, self, self.OnPropEffectReplaceSkill)
    self:AddDispatcher(EventID.OnPropEffectEndReplaceSkill, self, self.OnPropEffectEndReplaceSkill)
    self:AddDispatcher(EventID.OnSwitchMobileHUDLayout, self, self.OnSwitchMobileHUDLayout)
    self:AddDispatcher(EventID.OnMobileHudPlanChanged, self, self.UpdateLayoutInfoByServerData)
    self:AddDispatcher(EventID.OnSwitchLeftShoot, self, self.InitLeftShoot)
    self:AddDispatcher(EventID.OnSwitchLeftBulletJump, self, self.InitLeftBulletJump)
    self:AddDispatcher(EventID.OnSwitchBulletJumpCancel, self, self.InitBulletJumpCancel)
    self:AddDispatcher(EventID.OnSwitchExtraSlide, self, self.InitExtraSlide)
    self:AddDispatcher(EventID.OnSwitchExtraSlideAttack, self, self.InitExtraSlideAttack)
    self:AddDispatcher(EventID.OnEnableBattleMount, self, self.OnEnableBattleMount)
    self:AddDispatcher(EventID.OnDisableBattleMount, self, self.OnDisableBattleMount)
    self:AddDispatcher(EventID.OnStartMountFly, self, self.OnStartMountFly)
    self:AddDispatcher(EventID.OnStopMountFly, self, self.OnStopMountFly)
    self:AddDispatcher(EventID.OnSkillInfosRep, self, self.OnSkillInfosRep)
    self:AddDispatcher(EventID.OnMobileHookShow, self, self.OnMobileHookShow)
    self:AddDispatcher(EventID.OnSkill1InAirChanged, self, self.OnSkill1InAirChanged)
    self:AddDispatcher(EventID.OnSkill2InAirChanged, self, self.OnSkill2InAirChanged)
    self:AddDispatcher(EventID.OnLockOnButtonShowChanged, self, self.OnLockOnButtonShowChanged)
    self:AddDispatcher(EventID.OnCameraLockOnChanged, self, self.OnCameraLockOnChanged)
    -- 添加触控需要监听的事件
    self:InitTouchListenEvent()
end

-- 管理自定义面板中的额外功能(左侧子弹跳、左侧射击、单独滑铲、单独滑砍等等)
function WBP_Battle_Button_Phone:InitExtraButtons(WidgetPlanData)
    self:InitLeftShoot()
    self:InitLeftBulletJump()
    self:InitBulletJumpCancel()
    self:InitExtraSlide(WidgetPlanData)
    self:InitExtraSlideAttack(WidgetPlanData)
end

function WBP_Battle_Button_Phone:InitLeftShoot()
    self.HasLeftShoot = EMCache:Get("HasLeftShoot")
    if self.HasLeftShoot == nil then
        local DefaultValue = DataMgr.Option["LeftShootShow"].DefaultValueM
        local ToBool = DefaultValue == "True" and true or false
        EMCache:Set("HasLeftShoot", ToBool)
    end
    if self.HasLeftShoot then
        self.AtkRangedPosLeft:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.AtkRanged:ChangeLeftShootState()
    else
        self.AtkRangedPosLeft:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_Battle_Button_Phone:InitLeftBulletJump()
    self.HasLeftBulletJump = EMCache:Get("HasLeftBulletJump")
    if self.HasLeftBulletJump == nil then
        local DefaultValue = DataMgr.Option["LeftBulletJumpShow"].DefaultValueM
        local ToBool = DefaultValue == "True" and true or false
        EMCache:Set("HasLeftBulletJump", ToBool)
        self.HasLeftBulletJump = ToBool
    end

    if self.HasLeftBulletJump then
        self.BulletJumpPosLeft:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.BulletJumpPosLeft:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_Battle_Button_Phone:InitBulletJumpCancel()
    self.HasBulletJumpCancel = EMCache:Get("BulletJumpCamRotate")
    if self.HasBulletJumpCancel == nil then
        local DefaultValue = DataMgr.Option["BulletJumpCamAdjust"].DefaultValueM
        local ToBool = DefaultValue == "True" and true or false
        EMCache:Set("HasLeftBulletJump", ToBool)
    end
    if self.HasBulletJumpCancel then
        self.BattleCancelLeftPos:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.BattleCancelRightPos:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.BattleCancelPos_Left_2:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.BattleCancelPos_Right_2:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.BattleCancelLeftPos:SetVisibility(ESlateVisibility.Collapsed)
        self.BattleCancelRightPos:SetVisibility(ESlateVisibility.Collapsed)
        self.BattleCancelPos_Left_2:SetVisibility(ESlateVisibility.Collapsed)
        self.BattleCancelPos_Right_2:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_Battle_Button_Phone:CheckHasExtraSlide(WidgetPlanData)
    --没传入时主动获取
    local PlanData = WidgetPlanData
    if not PlanData then
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            local Layout = Avatar:GetCurrentMobileHudPlanIndex()
            if Layout then
                PlanData = Avatar:GetMobileHudPlan(Layout) or {} 
            end
        end
    end
    if not PlanData then
        return false
    end
    if PlanData.SlideTacklePos and PlanData.SlideTacklePos.bHasAddInHUDSetting then
        return true
    end
    return false
end

function WBP_Battle_Button_Phone:InitExtraSlide(WidgetPlanData)
   self.HasExtraSlide = self:CheckHasExtraSlide(WidgetPlanData)
    if self.HasExtraSlide == nil then
        self.HasExtraSlide = false
    end
    if self.HasExtraSlide then
        self.Jump:OnSkillInActive(ESkillName.Slide)
        self.Slide:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Jump:OnSkillActive(ESkillName.Slide)
        self.Slide:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function WBP_Battle_Button_Phone:CheckHasExtraSlideAttack(WidgetPlanData)
   --没传入时主动获取
    local PlanData = WidgetPlanData
    if not PlanData then
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            local Layout = Avatar:GetCurrentMobileHudPlanIndex()
            if Layout then
                PlanData = Avatar:GetMobileHudPlan(Layout) or {} 
            end
        end
    end
    if not PlanData then
        return false
    end
    if PlanData.SlidingSlashPos and PlanData.SlidingSlashPos.bHasAddInHUDSetting then
        return true
    end
    return false

end

function WBP_Battle_Button_Phone:InitExtraSlideAttack(WidgetPlanData)
    self.HasExtraSlideAttack = self:CheckHasExtraSlideAttack(WidgetPlanData)
    if self.HasExtraSlideAttack == nil then
        self.HasExtraSlideAttack = false
    end
    if self.HasExtraSlideAttack then
        self.Jump:OnSkillInActive(ESkillName.Attack)
        self.SlideAttack:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Jump:OnSkillActive(ESkillName.Attack)
        self.SlideAttack:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function WBP_Battle_Button_Phone:InitHUDLayout()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self.CurrentLayout = Avatar:GetCurrentMobileHudPlanIndex() or 2
    self:OnSwitchMobileHUDLayout(self.CurrentLayout)

end

function WBP_Battle_Button_Phone:UpdateLayoutInfoByServerData(OpType, Layout, LayoutData)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if (OpType == "Update") then
        local WidgetPlanData = Avatar:GetMobileHudPlan(Layout) or {}
        if (IsEmptyTable(WidgetPlanData)) then
            self:SetBtnDefaultPosition(Layout - 1)
            self:InitExtraButtons(WidgetPlanData)
        else
            local IsFirstPlan = self.EditPlanIndex % 2 ~= 0
            self.EditPlanIndex = Layout
            for ParentName, WidgetConfig in pairs(BattleHUDCommonConst.DesignBaseConfigInHUD) do
                local PositionInHUD = WidgetPlanData[ParentName]
                DebugPrint("WBP_Battle_Button_Phone:UpdateLayoutInfoByServerData", ParentName, PositionInHUD)
                if (PositionInHUD) then
                    local ParentNode = self[ParentName]
                    self:_UpdateWidgetToTargetPos(ParentNode, FVector2D(PositionInHUD.PosX, PositionInHUD.PosY), false, true)
                    self:_UpdateWidgetToTargetScale(ParentNode, FVector2D(PositionInHUD.ScaleX, PositionInHUD.ScaleY), true)
                end
                if ParentName == "JumpPos" and PositionInHUD then
                    self.Jump.InnerButtonDis = self.Jump.DefaultButtonDis * PositionInHUD.ScaleX
                end
            end
            self:SetBtnDefaultPosition(Layout - 1, self.IsFirstPlan)
            self:InitExtraButtons(WidgetPlanData)
        end
    end
end

function WBP_Battle_Button_Phone:OnSwitchMobileHUDLayout(Layout)
    self.CurrentLayOut = Layout
    self.EditPlanIndex = Layout
    self:SetRootLayoutNode(self.Panel_Skill)
    self:UpdateLayoutInfoByServerData("Update", Layout)
    self.Jump:ChangeByLayout(Layout)
end

function WBP_Battle_Button_Phone:CheckHasBulletJumpButton()
    return self.CurrentLayout == 2
end

-- 不使用提供的Auto_Close，暂时没用
function WBP_Battle_Button_Phone:CloseWithoutAnim()
    self:BindToAnimationFinished(self.Out, {self, self.Close})
    self:PlayAnim("Out")
end

-- 角色初始化成功事件的回调，用来强制加载按钮
function WBP_Battle_Button_Phone:InitSkillAfterCharInitReady()
    if (not IsValid(self) or IsDedicatedServer(self)) then
        return
    end
    self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
    if (not IsValid(self.OwnerPlayer)) then
        return
    end
    self:ForceInit()
    self.SupportSkill:InitSupportSkill()
    self:OnBattlePetInitReady()
    self:InitListenEvent()
end 

--初始化一些变量(有需要就加)
function WBP_Battle_Button_Phone:InitVariable()
    self.Skill.OwnerPanel = self
    self.Skill.CharSkill_1.OwnerPanel = self
    self.Skill.CharSkill_2.OwnerPanel = self
    self.SkillItems = {self.Skill.CharSkill_1, self.Skill.CharSkill_2}
    self.SupportSkill.OwnerPanel = self
    self.Bullet.OwnerPanel = self
    self.Jump.OwnerPanel = self
    self.AtkRanged.OwnerPanel = self
    self.AtkRangedLeft.OwnerPanel = self
    self.Dodge.OwnerPanel = self
    self.AtkMelee.OwnerPanel = self
    self.Squat.OwnerPanel = self
    self.Squat.OwnerPlayer = self.OwnerPlayer
    self.Walk.OwnerPanel = self
    self.Walk.OwnerPlayer = self.OwnerPlayer
    self.Battle_Menu.OwnerPanel = self
    self.Dodge.OwnerPanel = self
    self.AimLocked.OwnerPanel = self
    
    self.BulletJump.OwnerPanel = self
    self.BulletJumpLeft.OwnerPanel = self
    self.BulletJumpCancelRight.OwnerPanel = self
    self.BulletJumpCancelLeft.OwnerPanel = self
    self.BulletJumpCancelRight_2.OwnerPanel = self
    self.BulletJumpCancelLeft_2.OwnerPanel = self
    
    self.Slide.OwnerPanel = self
    self.SlideAttack.OwnerPanel = self
    
    self.SkillButtons = {}
    self.SkillButtons[ESkillName.Attack] = self.AtkMelee
    self.SkillButtons[ESkillName.Jump] = self.Jump
    self.SkillButtons[ESkillName.Slide] = self.Squat
    self.SkillButtons[ESkillName.Skill1] = self.Skill.CharSkill_1
    self.SkillButtons[ESkillName.Skill2] = self.Skill.CharSkill_2
    self.SkillButtons[ESkillName.Skill3] = self.SupportSkill
    self.SkillButtons[ESkillName.Fire] = self.AtkRanged
    self.SkillButtons[ESkillName.ChargeBullet] = self.Bullet
    self.SkillButtons[ESkillName.Avoid] = self.Dodge
    -- 每0.1秒执行一次刷新面板
    self:AddTimer(0.1, self.UpdateSkillInfoInTimer, true, 0, "UpdateSkillInfoInTimer", false)
    self:AddTimer(0.1, self.UpdateOtherInfoInTimer, true, 0.05, "UpdateOtherInfoInTimer", false)
end

function WBP_Battle_Button_Phone:OnBattlePetInitReady()
    local BattlePet = self.OwnerPlayer:GetBattlePet()
    if not BattlePet or BattlePet.BattlePetId == 0 then
        self:ChangeSkillButtonState(ESkillName.Skill3, "Empty")
        return
    end
    
    self.SupportSkill:RefreshSupportSkillIcon()
    if not self.OwnerPlayer:CheckSkillInActive(ESkillName.Skill3) then
        self:ChangeSkillButtonState(ESkillName.Skill3, "UnEmpty")
    end
end

function WBP_Battle_Button_Phone:InitMountHUD()
    if not self.OwnerPlayer.CurMount then
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Mounts_Out)
    end
end

--------------处理触控输入专区--------------
--调用TouchComponent的接口，主要实现跳跃组合键和远程开火键
function WBP_Battle_Button_Phone:DelayAddTouchLayer()
    if self.Jump.Image_Hotspot and not self.IsInitJumpTouch then
        self.IsInitJumpTouch = true
        self:AddStaticSubTouchItem("Jump", self.Jump.Image_Hotspot, {Down=self.Jump.ButtonJumpDown, Move=self.Jump.ButtonJumpMove, Up=self.Jump.ButtonJumpUp}, self.JumpPos)
    end
    if self.AtkRanged.Joystick and not self.IsInitAtkTouch then
        self.IsInitAtkTouch = true
        self:AddMovedSubTouchItem("RangedAttack", self.AtkRanged.Joystick, self.AtkRangedPos, {Down=self.AtkRanged.ButtonFireDown, Move=self.AtkRanged.ButtonFireMove, Up=self.AtkRanged.ButtonFireUp},
                {Type="Circle", Param={Radius=self.AtkRanged.CircleLimitArea, NeedReset=false}, TouchTimes=-1, NeedResetPos=true})
    end
    if self.BulletJump and self.BulletJumpLeft and not self.IsInitBulletJumpTouch then
        self.IsInitBulletJumpTouch = true
        self:AddStaticSubTouchItem("BulletJump", self.BulletJump.Image_Hotspot, {
            Down=self.BulletJumpDown,
            Move=self.BulletJumpMove,
            Up=self.BulletJumpUp
        }, self.BulletJumpPos)
        self:AddStaticSubTouchItem("BulletJumpLeft", self.BulletJumpLeft.Image_Hotspot, {
            Down=self.LeftBulletJumpDown,
            Move=self.LeftBulletJumpMove, 
            Up=self.LeftBulletJumpUp
        }, self.BulletJumpPosLeft)
        self:SetBulletJumpCancelInfo()
        self.BulletJump.CancelBtn = self.BulletJumpCancelRight
        self.BulletJumpLeft.CancelBtn = self.BulletJumpCancelLeft_2
    end
    local BattleMenu = self.Battle_Menu
    if BattleMenu.Bg and not self.IsInitMenuTouch then
        self.IsInitMenuTouch = true
        self:AddStaticSubTouchItem("BattleMenu", BattleMenu.Bg, {
            Down = BattleMenu.BattleMenuDown,
            Move = BattleMenu.BattleMenuMove,
            Up = BattleMenu.BattleMenuUp
        }, self.BattleMenuPos)
    end
    if self.IsInitAtkTouch and self.IsInitJumpTouch and self.IsInitMenuTouch then
        self:RemoveTimer(self.DelayAddTouchLayerTimer)
    end
end


---------------------------- 子弹跳旋转镜头相关 ----------------------------
-- 初始化4个子弹跳取消按钮
function WBP_Battle_Button_Phone:SetBulletJumpCancelInfo()
    self.BulletJumpCancelRight:InitSlideText()
    self.BulletJumpCancelLeft:InitNormalText()
    self.BulletJumpCancelLeft_2:InitSlideText()
    self.BulletJumpCancelRight_2:InitNormalText()
end

function WBP_Battle_Button_Phone:BulletJumpDown(Index, StartPos)
    self.BulletJump:ButtonBulletJumpDown(Index, StartPos)
    if not EMCache:Get("AutoBulletJump") then
        -- 延迟 0.5s 显示取消按钮，避免误触瞬时弹出
        if self.BulletJumpCancelShowTimer then
            self:RemoveTimer(self.BulletJumpCancelShowTimer)
            self.BulletJumpCancelShowTimer = nil
        end
        self.BulletJumpCancelShowTimer = self:AddTimer(0.5, function()
            if IsValid(self) then
                self.BulletJumpCancelLeft:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                self.BulletJumpCancelRight:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            end
            self.BulletJumpCancelShowTimer = nil
        end, false)
    end
end

function WBP_Battle_Button_Phone:BulletJumpMove(TouchFingerCount, Index, LastPos, TotalDeltaDis, LastDeltaDis, TouchLocalPos, ScreenSpacePos)
    self.BulletJump:ButtonBulletJumpMove(TouchFingerCount, Index, LastPos, TotalDeltaDis, LastDeltaDis, TouchLocalPos, ScreenSpacePos)
end

function WBP_Battle_Button_Phone:BulletJumpUp(Index, WidgetLocalPos, LastWidgetTouchPos, EndTouchPos, TotalDeltaDis, ScreenSpacePos)
    self.BulletJump:ButtonBulletJumpUp(Index, WidgetLocalPos, LastWidgetTouchPos, EndTouchPos, TotalDeltaDis, ScreenSpacePos)
    if not EMCache:Get("AutoBulletJump") then
        -- 立即隐藏取消按钮并取消任何等待显示的定时器
        if self.BulletJumpCancelShowTimer then
            self:RemoveTimer(self.BulletJumpCancelShowTimer)
            self.BulletJumpCancelShowTimer = nil
        end
        self.BulletJumpCancelLeft:SetVisibility(ESlateVisibility.Collapsed)
        self.BulletJumpCancelRight:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_Battle_Button_Phone:LeftBulletJumpDown(Index, StartPos)
    self.BulletJumpLeft:ButtonBulletJumpDown(Index, StartPos)
    --自动触发子弹跳时不显示取消按钮
    if not EMCache:Get("AutoBulletJump") then
        -- 延迟 0.35s 显示左侧取消按钮
        if self.BulletJumpCancelLeft2ShowTimer then
            self:RemoveTimer(self.BulletJumpCancelLeft2ShowTimer)
            self.BulletJumpCancelLeft2ShowTimer = nil
        end
        self.BulletJumpCancelLeft2ShowTimer = self:AddTimer(0.35, function()
            if IsValid(self) then
                self.BulletJumpCancelLeft_2:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                self.BulletJumpCancelRight_2:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            end
            self.BulletJumpCancelLeft2ShowTimer = nil
        end, false)
    end
end

function WBP_Battle_Button_Phone:LeftBulletJumpMove(TouchFingerCount, Index, LastPos, TotalDeltaDis, LastDeltaDis, TouchLocalPos, ScreenSpacePos)
    self.BulletJumpLeft:ButtonBulletJumpMove(TouchFingerCount, Index, LastPos, TotalDeltaDis, LastDeltaDis, TouchLocalPos, ScreenSpacePos)
end

function WBP_Battle_Button_Phone:LeftBulletJumpUp(Index, WidgetLocalPos, LastWidgetTouchPos, EndTouchPos, TotalDeltaDis, ScreenSpacePos)
    self.BulletJumpLeft:ButtonBulletJumpUp(Index, WidgetLocalPos, LastWidgetTouchPos, EndTouchPos, TotalDeltaDis, ScreenSpacePos)
    --自动触发子弹跳时不显示取消按钮
    if not EMCache:Get("AutoBulletJump") then
        -- 立即隐藏左侧取消按钮并取消任何等待显示的定时器
        if self.BulletJumpCancelLeft2ShowTimer then
            self:RemoveTimer(self.BulletJumpCancelLeft2ShowTimer)
            self.BulletJumpCancelLeft2ShowTimer = nil
        end
        self.BulletJumpCancelLeft_2:SetVisibility(ESlateVisibility.Collapsed)
        self.BulletJumpCancelRight_2:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_Battle_Button_Phone:SetBulletJumpOccupied(IsOccupied, Item)
    if not self.HasLeftBulletJump then
        return
    end
    local OtherItem = Item == self.BulletJump and self.BulletJumpLeft or self.BulletJump
    OtherItem.IsOccupied = IsOccupied
    if IsOccupied then
        OtherItem:InActiveBulletJump("IsOccupied")
    else
        OtherItem:ActiveBulletJump("IsOccupied")
    end
end

function WBP_Battle_Button_Phone:OtherActionCancelBulletJump(InAction)
    if CommonUtils.HasValue(self.NoCancelBulletJumpActions, InAction) then
        return
    end
    self:CancelBulletJump()
end

function WBP_Battle_Button_Phone:CancelBulletJump()
    if self.BulletJump.IsOccupied then
        self:LeftBulletJumpUp()
    elseif self.BulletJumpLeft.IsOccupied then
        self:BulletJumpUp()
    end
end

------------------------------------------

-- 用这俩TryToPlay 和 TryToStop 来触发动作逻辑--
function WBP_Battle_Button_Phone:TryToPlayTargetCommand(KeyName, IsAddInputCache)
    if (not IsValid(self.OwnerPlayer)) then
        return
    end
    if(self.OwnerPlayer:CheckForbidTags(KeyName))then
        return 
    end
    if (IsAddInputCache) then
        self.OwnerPlayer:SetInputCache(KeyName)
    end
    if not self.OwnerPlayer.InitSuccess then 
        return 
    end
    self:OtherActionCancelBulletJump(KeyName)
    if(KeyName == "Skill1") then
        self.OwnerPlayer:ActionCallback("Skill1", EInputEvent.IE_Pressed)
    elseif (KeyName == "Skill2") then
        self.OwnerPlayer:ActionCallback("Skill2", EInputEvent.IE_Pressed)
    elseif (KeyName == "Skill3") then
        self.OwnerPlayer:ActionCallback("Skill3", EInputEvent.IE_Pressed)
    elseif (KeyName == "Reload") then
        self.OwnerPlayer:ActionCallback("ChargeBullet", EInputEvent.IE_Pressed)
    elseif (KeyName == "Avoid") then
        self.OwnerPlayer:ActionCallback("Avoid", EInputEvent.IE_Pressed)
    elseif (KeyName == "Slide") then
        self.OwnerPlayer:ActionCallback("Slide", EInputEvent.IE_Pressed)
    elseif (KeyName == "Attack") then
        self.OwnerPlayer:ActionCallback("Attack", EInputEvent.IE_Pressed)
    elseif (KeyName == "Fire") then
        self.OwnerPlayer:ActionCallback("Fire", EInputEvent.IE_Pressed)
    elseif (KeyName == "Jump") then
        self.OwnerPlayer:ActionCallback("Jump", EInputEvent.IE_Pressed)
    elseif (KeyName == "BulletJump") then
        self.OwnerPlayer:ActionCallback("BulletJump", EInputEvent.IE_Pressed)
    elseif (KeyName == "SwitchCrouch") then
        self.OwnerPlayer:ActionCallback("SwitchCrouch", EInputEvent.IE_Pressed)
    elseif (KeyName == "SwitchWalk") then
        self.OwnerPlayer:ActionCallback("SwitchWalk", EInputEvent.IE_Pressed)
    end
    -- if MiscUtils.IsAutonomousProxy(self.OwnerPlayer) then 
    --     self:GetMovementComponent().ForceClientSendMove = true
    -- end
end

function WBP_Battle_Button_Phone:TryToStopTargetCommand(KeyName, IsClearInputCache)
    if (not IsValid(self.OwnerPlayer)) then
        return
    end
    IsClearInputCache = IsClearInputCache
    if (IsClearInputCache) then
        self.OwnerPlayer:RemoveInputCache(KeyName)
    end
    if(self.OwnerPlayer:CheckForbidTags(KeyName))then
        self.OwnerPlayer:ResetAttackProperty(KeyName)
        return 
    end
    if not self.OwnerPlayer.InitSuccess then 
        return 
    end
    if(KeyName == "Skill1") then
        self.OwnerPlayer:ActionCallback("Skill1", EInputEvent.IE_Released)
    elseif (KeyName == "Skill2") then
        self.OwnerPlayer:ActionCallback("Skill2", EInputEvent.IE_Released)
    elseif (KeyName == "Skill3") then
        self.OwnerPlayer:ActionCallback("Skill3", EInputEvent.IE_Released)
    elseif (KeyName == "Slide") then
        self.OwnerPlayer:ActionCallback("Slide", EInputEvent.IE_Released)
    elseif (KeyName == "Attack") then
        self.OwnerPlayer:ActionCallback("Attack", EInputEvent.IE_Released)
    elseif (KeyName == "Fire") then
        self.OwnerPlayer:ActionCallback("Fire", EInputEvent.IE_Released)
    elseif (KeyName == "Jump") then
        self.OwnerPlayer:ActionCallback("Jump", EInputEvent.IE_Released)
    elseif (KeyName == "BulletJump") then
        self.OwnerPlayer:ActionCallback("BulletJump", EInputEvent.IE_Released)
    elseif (KeyName == "SwitchCrouch") then
        self.OwnerPlayer:ActionCallback("SwitchCrouch", EInputEvent.IE_Released)
    elseif (KeyName == "SwitchWalk") then
        self.OwnerPlayer:ActionCallback("SwitchWalk", EInputEvent.IE_Released)
    end
    -- if MiscUtils.IsAutonomousProxy(self.OwnerPlayer) then 
    --     self:GetMovementComponent().ForceClientSendMove = true
    -- end
end

--------------调用函数刷新信息相关---------------
---------调用了到这些函数才进行刷新，不用进Timer---------

-- 初始化时根据解锁状态去刷新
function WBP_Battle_Button_Phone:GetSkillActiveInfo()
    local PlayerController = nil
    if self.OwnerPlayer and self.OwnerPlayer.GetController then
        PlayerController = self.OwnerPlayer:GetController()
    end
    if PlayerController then
        local len = PlayerController.CurrentInActiveSkills:Length()
        local TempButtons = self.SkillButtons
        for i=1,len do
            self:ChangeSkillButtonState(PlayerController.CurrentInActiveSkills[i], "Lock")
            TempButtons[PlayerController.CurrentInActiveSkills[i]] = nil
        end
        for Id,_ in pairs(TempButtons) do
            self:ChangeSkillButtonState(Id, "UnLock")
        end
        -- 轮盘是否处于禁用状态
        self:ChangeBattleWheelState(PlayerController.bEnableBattleWheel, PlayerController.bShowBattleWheel)
    end
end

function WBP_Battle_Button_Phone:ChangeBattleWheelState(bEnable, bShow)
    DebugPrint("gmy@WBP_Battle_Button_Phone:ChangeBattleWheelState", bEnable)
    self.Battle_Menu.IsBan = not bEnable
    if not bEnable then
        self.Battle_Menu:StopAnimation(self.Battle_Menu.Normal)
        self.Battle_Menu:PlayAnimationForward(self.Battle_Menu.Ban)
	else
        self.Battle_Menu:StopAnimation(self.Battle_Menu.Ban)
		self.Battle_Menu:PlayAnimationForward(self.Battle_Menu.Normal)
    end
    
    -- TODO : 检测如果处于特殊任务状态，隐藏轮盘
    if self.BattleMenuUnlocked and bShow then
        self.Battle_Menu:SetVisibility(UE4.ESlateVisibility.Visible)
    else
        self.Battle_Menu:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end


-- 根据当前技能是否激活来改变 是否锁定态（主要用于序章）
function WBP_Battle_Button_Phone:ChangeSkillButtonState(SkillName, StateName)
    if (StateName == "Empty") then
        if(SkillName == ESkillName.Skill1) then
            self.SkillItems[1].CurButtonState = "Empty"
            self.SkillItems[1].Switcher:SetActiveWidgetIndex(1)
            self.SkillItems[1].Bg_Skill:SetBrushTintColor(UE4.UUIFunctionLibrary.GetSlateColorByRGBA(1,1,1,0.3))
        elseif(SkillName == ESkillName.Skill2) then
            self.SkillItems[2].CurButtonState = "Empty"
            self.SkillItems[2].Switcher:SetActiveWidgetIndex(1)
            self.SkillItems[2].Bg_Skill:SetBrushTintColor(UE4.UUIFunctionLibrary.GetSlateColorByRGBA(1,1,1,0.3))
        elseif(SkillName == ESkillName.Skill3) then
            self.SupportSkill.CurButtonState = "Empty"
            self.SupportSkill.Switcher:SetActiveWidgetIndex(1)
            self.SupportSkill.Bg:SetBrushTintColor(UE4.UUIFunctionLibrary.GetSlateColorByRGBA(1,1,1,0.3))
        elseif(SkillName == ESkillName.Fire) then
            self.AtkRanged.CurButtonState = "Empty"
            self.Bullet.CurButtonState = "Empty"
            --self.AtkRanged.Switcher:SetActiveWidgetIndex(1)
            self.AtkRanged:UpdateRangeWeaponButton()
            self.Bullet:SetVisibility(ESlateVisibility.Collapsed)
            --self.AtkRanged.Bg:SetBrushTintColor(UE4.UUIFunctionLibrary.GetSlateColorByRGBA(1,1,1,0.3))
        elseif(SkillName == ESkillName.SwitchWalk) then
            self.Walk:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    elseif (StateName == "UnEmpty") then
        if(SkillName == ESkillName.Skill1) then
            self.SkillItems[1].CurButtonState = "Normal"
            self.SkillItems[1].Switcher:SetActiveWidgetIndex(0)
            self.SkillItems[1].Bg_Skill:SetBrushTintColor(UE4.UUIFunctionLibrary.GetSlateColorByRGBA(1,1,1,1))
        elseif(SkillName == ESkillName.Skill2) then
            self.SkillItems[2].CurButtonState = "Normal"
            self.SkillItems[2].Switcher:SetActiveWidgetIndex(0)
            self.SkillItems[2].Bg_Skill:SetBrushTintColor(UE4.UUIFunctionLibrary.GetSlateColorByRGBA(1,1,1,1))
        elseif(SkillName == ESkillName.Skill3) then
            self.SupportSkill.CurButtonState = "Normal"
            self.SupportSkill.Switcher:SetActiveWidgetIndex(0)
            self.SupportSkill.Bg:SetBrushTintColor(UE4.UUIFunctionLibrary.GetSlateColorByRGBA(1,1,1,1))
        elseif(SkillName == ESkillName.Fire) then
            self.AtkRanged.CurButtonState = "Normal"
            self.Bullet.CurButtonState = "Normal"
            --self.AtkRanged.Switcher:SetActiveWidgetIndex(0)
            self.AtkRanged:UpdateRangeWeaponButton()
            
            self.Bullet:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            --self.AtkRanged.Bg:SetBrushTintColor(UE4.UUIFunctionLibrary.GetSlateColorByRGBA(1,1,1,1))
        elseif(SkillName == ESkillName.SwitchWalk) then
            self.Walk:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    end
    if (StateName == "UnLock") then
        if(SkillName == ESkillName.Attack) then
            self.AtkMelee:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            if self:CheckHasExtraSlideAttack() then
                self.SlideAttack:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            else
                self.SlideAttack:SetVisibility(UE4.ESlateVisibility.Collapsed)
                self.Jump:OnSkillActive(SkillName)
            end
        elseif(SkillName == ESkillName.Jump) then
            self.Jump:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.Jump.CurButtonState = "Active"
        elseif(SkillName == ESkillName.Slide) then
            self.Squat:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            if self:CheckHasExtraSlide() then
                self.Slide:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            else
                self.Slide:SetVisibility(UE4.ESlateVisibility.Collapsed)
                self.Jump:OnSkillActive(SkillName)
            end
        elseif(SkillName == ESkillName.Skill1) then
            self.Skill:PlayAnimationForward(self.Skill.In)
            if self.SkillItems[1].CurButtonState == "Lock_In" then
                self.SkillItems[1].SkillInfo.NeedUnlock = true
            end
        elseif(SkillName == ESkillName.Skill2) then
            if self.SkillItems[2].CurButtonState == "Lock_In" then
                self.SkillItems[2].SkillInfo.NeedUnlock = true
            end
        elseif(SkillName == ESkillName.Skill3) then
            self.SupportSkill:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.SupportSkill:PlayAnimationForward(self.SupportSkill.In)
        elseif(SkillName == ESkillName.Fire) then
            self.AtkRanged:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.AtkRangedLeft:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.Bullet:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        elseif(SkillName == ESkillName.Avoid) then
            self.Dodge:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        elseif(SkillName == ESkillName.BulletJump) then
            self.BulletJump:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.BulletJumpLeft:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.Jump:OnSkillActive(SkillName)
        elseif(SkillName == ESkillName.SwitchWalk) then
            self.Walk:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    elseif (StateName == "Lock") then
        if(SkillName == ESkillName.Attack) then
            self.AtkMelee:SetVisibility(UE4.ESlateVisibility.Collapsed)
            if self:CheckHasExtraSlideAttack() then
                self.SlideAttack:SetVisibility(UE4.ESlateVisibility.Collapsed)
            else
                self.Jump:OnSkillInActive(SkillName)
            end
        elseif(SkillName == ESkillName.Jump) then
            self.Jump:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Jump.CurButtonState = "InActive"
        elseif(SkillName == ESkillName.Slide) then
            self.Squat:SetVisibility(UE4.ESlateVisibility.Collapsed)
            if self:CheckHasExtraSlide() then
                self.Slide:SetVisibility(UE4.ESlateVisibility.Collapsed)
            else
                self.Jump:OnSkillInActive(SkillName)
            end
        elseif(SkillName == ESkillName.Skill1) then
            self.SkillItems[1].CurButtonState = "Lock_In"
            self.SkillItems[1]:PlayButtonStateAnimation()
        elseif(SkillName == ESkillName.Skill2) then
            self.SkillItems[2].CurButtonState = "Lock_In"
            self.SkillItems[2]:PlayButtonStateAnimation()
        elseif(SkillName == ESkillName.Skill3) then
            self.SupportSkill:SetVisibility(UE4.ESlateVisibility.Collapsed)
        elseif(SkillName == ESkillName.Fire) then
            self.AtkRanged:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.AtkRangedLeft:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Bullet:SetVisibility(UE4.ESlateVisibility.Collapsed)
        elseif(SkillName == ESkillName.Avoid) then
            self.Dodge:SetVisibility(UE4.ESlateVisibility.Collapsed)
        elseif(SkillName == ESkillName.BulletJump) then
            self.BulletJump:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.BulletJumpLeft:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Jump:OnSkillInActive(SkillName)
        elseif(SkillName == ESkillName.SwitchWalk) then
            self.Walk:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    elseif (StateName == "Ban") then
        if(SkillName == ESkillName.Attack) then
            self.AtkMelee.IsBan = true
            self.AtkMelee:PlayAnimationForward(self.AtkMelee.Ban)
        elseif(SkillName == ESkillName.Jump) then
            self.Jump:PlayAnimationForward(self.Jump.Ban)
            self.Jump.CurButtonState = "InActive"
        elseif(SkillName == ESkillName.Slide) then
            self.Squat:PlayAnimationForward(self.Squat.Ban)
        elseif(SkillName == ESkillName.Skill1) then
            self.SkillItems[1].CurButtonState = "Ban"
            self.SkillItems[1]:PlayButtonStateAnimation()
        elseif(SkillName == ESkillName.Skill2) then
            self.SkillItems[2].CurButtonState = "Ban"
            self.SkillItems[2]:PlayButtonStateAnimation()
        elseif(SkillName == ESkillName.Skill3) then
            self.SupportSkill.CurButtonState = "Ban"
            self.SupportSkill:PlayAnimationForward(self.SupportSkill.Ban)
        elseif(SkillName == ESkillName.Fire) then
            self.AtkRanged.CurButtonState = "Ban"
            EMUIAnimationSubsystem:EMPlayAnimation(self.AtkRanged, self.AtkRanged.Ban)
            EMUIAnimationSubsystem:EMPlayAnimation(self.AtkRangedLeft, self.AtkRangedLeft.Ban)
            self.Bullet.CurButtonState = "Ban"
            self.Bullet:PlayButtonStateAnimation()
        elseif(SkillName == ESkillName.Avoid) then
            self.Dodge:PlayAnimationForward(self.Dodge.Ban)
            if self:CheckHasBulletJumpButton() then
                self.BulletJump:InActiveBulletJump()
            end
            if self.HasLeftBulletJump then
                self.BulletJumpLeft:InActiveBulletJump()
            end
        end
    elseif (StateName == "UnBan") then
        if(SkillName == ESkillName.Attack) then
            self.AtkMelee.IsBan = false
            self.AtkMelee:PlayAnimationForward(self.AtkMelee.Normal)
        elseif(SkillName == ESkillName.Jump) then
            self.Jump:PlayAnimationForward(self.Jump.Normal)
            self.Jump.CurButtonState = "Active"
        elseif(SkillName == ESkillName.Slide) then
            self.Squat:PlayAnimationForward(self.Squat.Normal)
        elseif(SkillName == ESkillName.Skill1) then
            self.SkillItems[1].CurButtonState = "Normal"
        elseif(SkillName == ESkillName.Skill2) then
            self.SkillItems[2].CurButtonState = "Normal"
        elseif(SkillName == ESkillName.Skill3) then
            self.SupportSkill.CurButtonState = "Normal"
            self.SupportSkill:PlayAnimationForward(self.SupportSkill.Normal)
        elseif(SkillName == ESkillName.Fire) then
            self.AtkRanged.CurButtonState = nil
            self.AtkRanged:PlayAnimationForward(self.AtkRanged.Normal)
            self.AtkRangedLeft.CurButtonState = nil
            EMUIAnimationSubsystem:EMPlayAnimation(self.AtkRangedLeft, self.AtkRangedLeft.Normal)
            self.Bullet:PlayAnimationForward(self.Bullet.Normal)
        elseif(SkillName == ESkillName.Avoid) then
            self.Dodge:PlayAnimationForward(self.Dodge.Normal)
            if self:CheckHasBulletJumpButton() then
                self.BulletJump:ActiveBulletJump()
            end
            if self.HasLeftBulletJump then
                self.BulletJumpLeft:ActiveBulletJump()
            end
        end
    elseif (StateName == "Hooking" or StateName == "RegionBan") then
        if self.SkillButtons[SkillName] then
            self.SkillButtons[SkillName]:SetRenderOpacity(0.5)
        end
    elseif (StateName == "EndHooking" or StateName == "RegionUnBan") then
        if self.SkillButtons[SkillName] then
            self.SkillButtons[SkillName]:SetRenderOpacity(1)
        end
    end
end 

-- 刷新武器相关的信息
function WBP_Battle_Button_Phone:RefreshWeaponInfo()
    self.Bullet:UpdateBulletType()
    self.Bullet:UpdatePlayerWeaponInfo()
    self.AtkRanged:UpdateWeaponIcon()
end 

--刷新指定的技能（在PlayerCharacter里调用）
function WBP_Battle_Button_Phone:RefreshRoleTargetSkill(SkillName)
    if(SkillName == "Skill1") then
        self.SkillItems[1]:RefreshButtonStyle()
    elseif(SkillName == "Skill2") then
        self.SkillItems[2]:RefreshButtonStyle()
    elseif(SkillName == "Support") then
        self.SupportSkill:RefreshButtonStyle()
    end
end

-- 作为主接口 刷新两个常规技能和援护技能 
function WBP_Battle_Button_Phone:RefreshRoleSkillButton()
    self.SkillItems[1]:RefreshButtonStyle()
    
    self.SkillItems[2]:RefreshButtonStyle()
    
    self.SupportSkill:RefreshButtonStyle()
end

function WBP_Battle_Button_Phone:OnSkillInfosRep(Character)
    if not self.OwnerPlayer or self.OwnerPlayer ~= Character then
        return
    end
    self:RefreshRoleSkillButton()
end
-------------------------------------------------

-------------Timer内实时Update的信息---------------

--Timer内刷新技能面板 在这个脚本内留个接口，具体实现还是放技能各自的脚本里
function WBP_Battle_Button_Phone:UpdateSkillInfoInTimer()
    --检查是否在这一帧已经update过了，没更新过才执行逻辑
    if IsValid(self.OwnerPlayer) and not self.OwnerPlayer.IsUpdatedUIInThisTick then
        self.Skill:UpdateSkillInTimer()
        self.Squat:UpdateButtonInTimer()
        self.Walk:UpdateButtonInTimer()
        self.Dodge:UpdateButtonInTimer()
        --self.AimLocked:UpdateButtonInTimer()
        self.IsCharacterInFalling = self.OwnerPlayer:CharacterInTag("Falling")
        self.OwnerPlayer.IsUpdatedUIInThisTick = true
    end
end

-- 出于性能考虑，上面的Timer内刷新分为两部分，错开不在同一帧执行
function WBP_Battle_Button_Phone:UpdateOtherInfoInTimer()
    --检查是否在这一帧已经update过了，没更新过才执行逻辑
    if IsValid(self.OwnerPlayer) and not self.OwnerPlayer.IsUpdatedOtherUIInThisTick then
        self.SupportSkill:UpdateSkillInTimer()
        self.Bullet:UpdateButtonInTimer()
        self.AtkRanged:UpdateButtonInTimer()
         if self:CheckHasBulletJumpButton() then
            self.BulletJump:UpdateButtonInTimer()
         end
         if self.HasLeftBulletJump then
            self.BulletJumpLeft:UpdateButtonInTimer()
         end
        self.OwnerPlayer.IsUpdatedOtherUIInThisTick = true
    end
end

-----------------监听事件相关----------------------

-- 监听能量值变化  后续写在技能自己的脚本里
function WBP_Battle_Button_Phone:OnUpdateCharSp(NowSp, OldSp, Owner)
    self.Skill:OnUpdateCharSp(NowSp, OldSp, Owner)
end

function WBP_Battle_Button_Phone:OnUpdateMaxSp(NewMaxSp)
    self.Skill:OnUpdateMaxSp(NewMaxSp)
end

-- 监听技能效率变化 技能效率也会影响蓝耗值
function WBP_Battle_Button_Phone:OnUpdateSkillEfficiency(Owner)
    for i = 1, 2 do
        self.SkillItems[i]:OnRefreshSkillSpCost(Owner)
    end
end

-- 监听buff改变技能蓝耗行为
function WBP_Battle_Button_Phone:OnUpdateBuffSpModify()
    for i = 1, 2 do
        self.SkillItems[i]:OnUpdateBuffSpModify()
    end
end

--监听切换角色事件 接到通知后刷新一些东西
function WBP_Battle_Button_Phone:OnSwitchRole()
    if (self.OwnerPlayer) then
        self:OnUpdateCharSp(nil, nil, self.OwnerPlayer)
        self:RefreshRoleSkillButton()
        self:RefreshWeaponInfo()
    end
end

--监听切换宠物事件
function WBP_Battle_Button_Phone:OnSwitchPet()
    self.SupportSkill:RefreshSupportSkillIcon()
end

-- 监听换弹开始事件
function WBP_Battle_Button_Phone:TryToEnterReloadState()
    self.Bullet:TryToEnterReloadState()
end

function WBP_Battle_Button_Phone:OnSkill1InAirChanged(IsInAir)
    self.Skill.CharSkill_1:ChangeIsInAir(IsInAir)
end

function WBP_Battle_Button_Phone:OnSkill2InAirChanged(IsInAir)
    self.Skill.CharSkill_2:ChangeIsInAir(IsInAir)
end

function WBP_Battle_Button_Phone:OnLockOnButtonShowChanged(IsLooking, IsShow)
    self.AimLocked:OnLockOnButtonShowChanged(IsLooking, IsShow)
end

function WBP_Battle_Button_Phone:OnCameraLockOnChanged(IsLooking)
    self.AimLocked:OnCameraLockOnChanged(IsLooking)
end

-------------一些关于技能的通用函数---------------------
function WBP_Battle_Button_Phone:ExecuteCheckIsSkillInUsing(Skill)
    -- 判断技能是否处于使用状态
    if (Skill.CombatConditionID) then
          local TraceInfo="From WBP_Battle_Button_Phone:ExecuteCheckIsSkillInUsing"
        return Battle(self):CheckConditionNew(Skill.CombatConditionID, self.OwnerPlayer, nil,TraceInfo)
    end
    return false
end

function WBP_Battle_Button_Phone:InitUnlockInfo()
    local UIUnlockRule = DataMgr.UIUnlockRule
    self:InitButtonUnlockState(UIUnlockRule.BattleWheel.UIUnlockRuleId, function()
        self.BattleMenuUnlocked = true
        self.Battle_Menu:SetVisibility(UE4.ESlateVisibility.Visible)
    end, function()
        self.BattleMenuUnlocked = false
        self.Battle_Menu:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end, function()
        self.BattleMenuUnlocked = true
        self.Battle_Menu:SetVisibility(UE4.ESlateVisibility.Visible)
    end)
    self.Execute:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- 其他解锁的按钮可以在这里补充
end

-- UnlockingCallback: 判断出是解锁状态的处理回调
-- LockingCallback: 判断出是锁定状态的处理回调
-- FirstTimeUnlockCallback: 第一次解锁的处理回调
function WBP_Battle_Button_Phone:InitButtonUnlockState(UIUnlockRuleId, UnlockingCallback, LockingCallback, FirstTimeUnlockCallback)
    local Avatar = GWorld:GetAvatar()
    if Avatar == nil then return end
    
    if FirstTimeUnlockCallback then
        self.UnlockEvents = self.UnlockEvents or {}
        self.UnlockEvents[UIUnlockRuleId] = Avatar:BindOnUIFirstTimeUnlock(UIUnlockRuleId, FirstTimeUnlockCallback)
    end
    
    local bUnlocked = Avatar:CheckUIUnlocked(UIUnlockRuleId)
    DebugPrint("gmy@InitButtonUnlockState Unlocked", bUnlocked)
    if bUnlocked then
        if UnlockingCallback then
            UnlockingCallback()
        end
    else
        if LockingCallback then
            LockingCallback()
        end
    end
end

----------------- 轮盘道具相关 ---------------------
function WBP_Battle_Button_Phone:OnPropEffectReplaceSkill(SkillName, PropEffectId)
    if SkillName == ESkillName.Attack or SkillName == ESkillName.HeavyAttack then
        self.AtkMelee:OnPropEffectReplaceAttack(PropEffectId)
    elseif SkillName == ESkillName.Fire or SkillName == ESkillName.HeavyShooting then
        self.AtkRanged:OnPropEffectReplaceFire(PropEffectId)
    --elseif SkillName == ESkillName.Skill3 then
        self.SupportSkill:OnPropEffectReplaceSupport(PropEffectId)
    end
end

function WBP_Battle_Button_Phone:OnPropEffectEndReplaceSkill(SkillName)
    if SkillName == ESkillName.Attack or SkillName == ESkillName.HeavyAttack then
        self.AtkMelee:OnPropEffectEndReplaceAttack()
    elseif SkillName == ESkillName.Fire or SkillName == ESkillName.HeavyShooting then
        self.AtkRanged:OnPropEffectEndReplaceFire()
    --elseif SkillName == ESkillName.Skill3 then
        self.SupportSkill:OnPropEffectEndReplaceSupport()
    end
end

----------------- 坐骑相关 ---------------------
function WBP_Battle_Button_Phone:OnEnableBattleMount(Character)
    if not Character:IsMainPlayer() then
        return
    end
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Mounts_In)
    self.Jump:OnEnableBattleMount()
end

function WBP_Battle_Button_Phone:OnDisableBattleMount(Character)
    if not Character:IsMainPlayer() then
        return
    end
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Mounts_Out)
    self.Jump:OnDisableBattleMount()
end

function WBP_Battle_Button_Phone:OnStartMountFly()
    self.Dodge:OnStartMountFly()
    self.Jump:OnStartMountFly()
end

function WBP_Battle_Button_Phone:OnStopMountFly()
    self.Dodge:OnStopMountFly()
    self.Jump:OnStopMountFly()
end

----------------------------------------------

function WBP_Battle_Button_Phone:Destruct()
    self.Super.Destruct(self)
    local Avatar = GWorld:GetAvatar()
    if Avatar == nil then return end

    if self.UnlockEvents then
        for UIUnlockRuleId, UnlockEventKey in pairs(self.UnlockEvents) do
            Avatar:UnBindOnUIFirstTimeUnlock(UIUnlockRuleId, UnlockEventKey)
        end
    end
    -- 移除触控监听的事件
    self:RemoveTouchListenEvent()
end

function WBP_Battle_Button_Phone:ShowAtkMeleeForbidTips()
    UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_MELEE_FORBIDDEN"))
end

function WBP_Battle_Button_Phone:OnMobileHookShow(Hook)
    local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
    if BattleMainUI.Char_Skill.Execute.IsShow then
        BattleMainUI.Char_Skill.Switch_Type:SetActiveWidgetIndex(0)
        return
    end
    BattleMainUI.Char_Skill.Switch_Type:SetActiveWidgetIndex(1)
    Hook.InteractiveUI = BattleMainUI.Char_Skill.HookLock
    Hook.InteractiveUI:Init(Hook)
end

AssembleComponents(WBP_Battle_Button_Phone)
return WBP_Battle_Button_Phone