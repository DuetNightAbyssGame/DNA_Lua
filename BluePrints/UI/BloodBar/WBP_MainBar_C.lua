--
-- DESCRIPTION
--
-- @COMPANY **`
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local GMVariable = require "BluePrints.UI.GMInterface.GMVariable"
local MonsterUtils = require "Utils.MonsterUtils"
local CommonUtils = require "Utils.CommonUtils"
local EMCache = require "EMCache.EMCache"
local BloodBarUtils = require "BluePrints.UI.BloodBar.BloodBarUtils"
local Const = require "Const"
---@type WBP_Battle_MainBar_C
local WBP_MainBar_C = Class("BluePrints.UI.BP_UIState_C")

UE4.UMainBar.SetIsShowMonsterName(EMCache:Get("ShowMonsterName") or false)
UE4.UMainBar.SetIsForbidenShowBloodUI(false)

function WBP_MainBar_C:Initialize(Initializer)

    self.Super.Initialize(self)
    -- self.Owner = nil
    -- self.OwnerEid = nil
    -- self.OwnerType = nil
    -- self.StyleNodeName = nil
    -- self.SpecialTag = {}

    -- 动态加载的蓝图
    -- self.BloodBar = nil
    -- self.ShieldBar = nil
    -- self.WeaknessIconBar = nil
    -- self.BuffIconBar = nil
    -- self.InvincibleIconBar = nil
    -- self.PlayerBloodReturn = nil

    -- self.ComboAttackTime = Const.BloodBarDelayTime    -- 连续攻击时间间隔
    -- self.TickTime = 0.033

    -- self.IsShowLevel = true        -- 是否需要显示具体等级
    -- self.IsShowNum = false         -- 是否需要显示具体血盾数值
    -- self.IsEnemy = false           -- 是否与玩家是敌对阵营，用于控制血条颜色
    -- self.IsPlayDeduct = true       -- 血盾在被扣除时是否需要显示平滑下降的进度条
    -- self.IsShowBillBoard = true    -- 是否显示血条 目前只有机关表里的配置会影响
    -- self.IsUpdateBuff = false      -- 是否需要更新Buff
    -- self.IsShowName =   false
    -- self.IsLowHealth = false
    -- self.IsOverShield = false
    ---- 血量、护盾、超载护盾的数值
    -- self.MaxHp = 0
    -- self.CurHp = 0
    -- self.LastHp = 0
    -- self.MaxShield = 0
    -- self.CurShield = 0
    -- self.LastShield = 0
    -- self.MaxOverShield = 0
    -- self.CurOverShield = 0
    -- self.LastOverShield = 0

    ---- 尺寸
    -- self.BarLength = 0
    -- self.ShieldBarHeight = 0
    -- self.BloodBarHeight = 0
end

-- function WBP_MainBar_C:InitConfig(Owner,OwnerType,StyleNodeName)
--     if not IsValid(Owner) then return end
--     self.Owner = Owner
--     self.OwnerEid = Owner.Eid
--     self.OwnerType = OwnerType
--     self.StyleNodeName =StyleNodeName
--     self.RoleId = Owner.CurrentRoleId
--     if Owner.IsFromCache then
--         self:ReInit()
--         return
--     end
--     self:SetFontSize()
--     -- self:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     self.Num_Blood:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     self.Num_Shield:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     self.Lv:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     self.Num_Lv_elite:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     if Owner.IsMainPlayer and Owner:IsMainPlayer() then
--         self:AddDispatcher(EventID.ShowMainPlayerBlood,self, self.UpdateBar)
--         self:AddDispatcher(EventID.CharDie,self,self.CharDie)
--         self:AddDispatcher(EventID.CharRecover,self,self.CharRecovery)
--         self:AddDispatcher(EventID.OnCharLevelUpInBattle,self,self.OnUpdateCharLevelAndExp)
--         self:AddDispatcher(EventID.OnUpdateCharExp,self,self.OnUpdateCharLevelAndExp)
--         self:AddDispatcher(EventID.OnShowMainPlayerHealEvent,self,self.OnShowMainPlayerHealEvent)
--         return
--     end

--     self:RealInit(Owner,OwnerType,StyleNodeName)

-- end

-- function WBP_MainBar_C:RealInit(Owner,OwnerType,StyleNodeName)
--     self.Owner = Owner
--     self.SizeBox_HPRoot:ClearChildren()
--     self.SizeBox_ShieldRoot:ClearChildren()
--     self.HB_Buff_EliteRoot:ClearChildren()
--     self.Group_EliteRoot:ClearChildren()
--     self.Group_BloodReturn:ClearChildren()
--     self.Group_BuffRoot:ClearChildren()
--     self:CheckCanTick()
--     self:InitValue()              -- 初始化血量、护盾等数值 -- done
--     self:InitBooleanValue()
--     self:InitAnimationInAndOut()
--     self:SetSize()
--     self:SetName() -- lua
--     self:LoadBloodBar()
--     self:CheckAndLoadShieldBar()
--     self:CheckAndLoadWeaknessIconsBar()
--     self:CheckAndLoadBuffSubWidegt()
--     self:CheckAndLoadPlayerBloodReturnSubWidget()
--     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
--     self.SceneMgrComponent = GameInstance:GetSceneManager()
--     self:SetLevelText(self.Owner:GetAttr("Level"))
--     self:UpdateCharBuffUI()
--     self:RefreshInvincibleState()
--     self:RefreshWeaknessIcons()
--     if not self.Owner:IsPlayer() then
--         self:RegisterEventsNormal()
--     end
--     self:SetBloodNum_Player()
--     self:SetShieldNum_Player()
--     self:CheckAndPlayLowHealth()
--     local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.SizeBox_Main)
--     CanvasSlot:SetPosition(FVector2D(0, 0))
--     if not self.Owner:IsPlayer() then
--         self.Panel_Zoom:SetRenderOpacity(0.0)
--     end

--     if self.Owner:IsMainPlayer() and (CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile")  then
--         self.BG_PlayerPhone:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--         self.Static_BarBG:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     else
--         self.BG_PlayerPhone:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         self.Static_BarBG:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--     end

-- end

function WBP_MainBar_C:InitConfig_Lua(IsMainPlayer,ActorOwner)
    rawset(self, "Owner", ActorOwner)
    self.IsDestroied = nil
    if IsMainPlayer then
        -- self:AddDispatcher(EventID.ShowMainPlayerBlood,self, self.UpdateBar)
        self:AddDispatcher(EventID.OnCharGradeLevelUp,self,self.OnCharGradeLevelUp)
        self:AddDispatcher(EventID.CharDie,self,self.CharDie)
        self:AddDispatcher(EventID.CharRecover,self,self.CharRecovery)
        self:AddDispatcher(EventID.RefreshMainPlayerBlood,self,self.Reinitialize)
        self:AddDispatcher(EventID.OnCharLevelUpInBattle,self,self.OnUpdateCharLevelAndExp)
        self:AddDispatcher(EventID.OnUpdateCharExp,self,self.OnUpdateCharLevelAndExp)
        self:AddDispatcher(EventID.OnShowMainPlayerHealEvent,self,self.OnShowMainPlayerHealEvent) --OnSwitchRole
        self:AddDispatcher(EventID.ChangeRole,self,self.CheckChangeRole)
        self:AddTimer(1.0, self.CheckMaxHpAndShieldChange, true, 0, "CheckMaxHpAndShieldChange")
        self:AddTimer(1.0,function ()
            self:AddDispatcher(EventID.OnMainCharacterInitReady,self,self.CharRecovery)
        end,false,0,"DelayDispatcherMainCharacterInitReady")
        self.IsPlayingReturning = false
    else
        self:RegisterEventsNormal()
    end
    self:UpdateCharBuffUI()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    self.SceneMgrComponent = GameInstance:GetSceneManager()
    self:SetName()
end

function WBP_MainBar_C:Reinit_Lua(ActorOwner)
    rawset(self, "Owner", ActorOwner)
    self:RegisterEventsNormal()
end

function WBP_MainBar_C:Construct()
    WBP_MainBar_C.Super.Construct(self)
    if self.Icon_Agree then
        self.Icon_Agree:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

    self:AddDispatcher(EventID.OnRepOwnerEidPhantomState, self, self._SyncPhantomName)
    self:AddDispatcher(EventID.OnRepPlayerName, self, self._SyncPhantomName)
    self:AddDispatcher(EventID.OnCloseLoading, self, self._SyncPhantomName)
end

function WBP_MainBar_C:SetInTeam()
    self.Group_FrontSpace:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Icon_Agree:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Panel_Lv:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Panel_BG:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

-- function WBP_MainBar_C:InitValue()
--     local Owner = self.Owner
--     self.MaxHp = Owner:GetAttr("MaxHp")
--     self.CurHp = Owner:GetAttr("Hp")
--     self.LastHp = self.CurHp
--     self.MaxShield = Owner:GetAttr("MaxES") or 0
--     self.CurShield = Owner:GetAttr("ES") or 0
--     self.LastShield = self.CurShield
--     self.MaxOverShield = Owner:GetAttr("MaxOverShield") or 0
--     self.CurOverShield = Owner:GetAttr("OverShield") or 0
--     self.LastOverShield = self.CurOverShield

--     self.IsEnemy = self:CheckIsEnemyToPlayer()
-- end

-- function WBP_MainBar_C:ReInit()
--     self:InitValue()
--     if self.HpBar then
--         self.HpBar:ReInit()
--     end

--     if self.ShieldBar then
--         self.ShieldBar:ReInit()
--     end
--     self:SetLevelText(self.Owner:GetAttr("Level"))
--     if not self.Owner:IsPlayer() then
--         self.Panel_Zoom:SetRenderOpacity(0.0)
--     end

--     self:UpdateCharBuffUI()
--     self:RefreshInvincibleState()
-- end

-- 动态加载血量条 蓝图为 BP_HPBar
-- function WBP_MainBar_C:LoadBloodBar()
--     self.HpBar = BloodBarUtils.LoadSubWidget(self,self.SizeBox_HPRoot,"HPBar",self.IsEnemy,self.BarLength)
-- end

-- 检查是否需要加载护盾条，如果需要则加载，蓝图为BP_ShieldBar
-- function WBP_MainBar_C:CheckAndLoadShieldBar()
--     if self.ShieldBar then
--         self.ShieldBar:ClearTimer()
--     end
--     if self.MaxShield and self.MaxShield > 0 then
--         local MinDesiredWidth = self.BarLength
--         local HeightOverride = self.ShieldBarHeight
--         if self.Owner:IsPlayer() then
--             self.ShieldBar = self:LoadSubWidget(self.SizeBox_ShieldRoot,"ShieldBar",MinDesiredWidth,HeightOverride) --TODO
--         else
--             self.ShieldBar = self:LoadSubWidget(self.SizeBox_ShieldRoot,"ShieldBar",MinDesiredWidth,HeightOverride)
--         end
--         self.Spacer_Mid:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--         self.SizeBox_ShieldRoot:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--     else
--         self.ShieldBar = nil
--         self.Spacer_Mid:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         self.SizeBox_ShieldRoot:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     end
-- end

-- 加载弱点图标子蓝图
-- function WBP_MainBar_C:CheckAndLoadWeaknessIconsBar()
--     if self.Owner:IsPlayer() or not self.Owner.BuffManager then
--         self.Group_BuffRoot:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         self.HB_Buff:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         return
--     end
--     self.WeaknessIconBar = self:LoadSubWidget(self.Group_BuffRoot,"BuffBar",false)
--     self.Group_BuffRoot:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--     local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.WeaknessIconBar)
--     if CanvasSlot then
--         CanvasSlot:SetAlignment(FVector2D(0,0.5))
--         local Anchors = FAnchors()
--         Anchors.Minimum = FVector2D(0,0.5)
--         Anchors.Maximum = FVector2D(0,0.5)
--         CanvasSlot:SetAnchors(Anchors)
--         CanvasSlot:SetAutoSize(true)
--     end
-- end

-- 加载buff和无敌图标相关的子蓝图
-- function WBP_MainBar_C:CheckAndLoadBuffSubWidegt(StyleNodeName)

--     if self.Owner:IsPlayer() then
--         self.InvincibleIconBar = self:LoadSubWidget(self.Group_EliteRoot,"PlayerInvincibility")
--         return
--     end
--     self.InvincibleIconBar = self:LoadSubWidget(self.Group_EliteRoot,"EliteBar")
--     self.BuffIconBar = self:LoadSubWidget(self.HB_Buff_EliteRoot,"BuffIcon")
-- end

-- 加载用于播放玩家回血动效的蓝图
-- function WBP_MainBar_C:CheckAndLoadPlayerBloodReturnSubWidget()
--     if not self.Owner:IsPlayer() then
--         return
--     end
--     self.PlayerBloodReturn = self:LoadSubWidget(self.Group_BloodReturn,"PlayerBloodReturn")
--     self.Group_BloodReturn:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
-- end

-- 加载子蓝图到对应的容器，并返回子蓝图对象
-- function WBP_MainBar_C:LoadSubWidget(Container,WidgetName,...)
--     if not Container then return end
--     local SubWidget = self:CreateWidgetNew(WidgetName)
--     Container:AddChild(SubWidget)
--     SubWidget:Init(...)
--     return Container:GetChildAt(0)
-- end

-- 根据血条拥有者的类型，初始化一些控制显示内容的布尔值
-- function WBP_MainBar_C:InitBooleanValue()
--     if self.Owner:IsPlayer() then
--         self.IsShowNum = true
--         self.IsShowLevel = true
--         self.IsShowBillBoard = true
--         self.IsPlayDeduct = false
--         self.IsUpdateBuff = false
--         self.IsShowName = false
--         self.LowPercent = 0.3
--     elseif self.Owner:IsMonster() then
--         self.IsShowNum = false
--         self.IsShowLevel = true
--         self.IsShowBillBoard = true
--         self.IsPlayDeduct = true
--         self.IsUpdateBuff = true
--         self.IsShowName = true
--     elseif self.Owner:IsCombatItemBase() or self.Owner:IsMechanismSummon() then
--         self.IsShowNum = false
--         self.IsShowLevel = true
--         self.IsPlayDeduct = true
--         local Data = self.Owner.Data
--         self.IsShowBillBoard = Data.BloodUIParmas~=nil and Data.BloodUIParmas.ActiveCommonUI == 1
--         self.IsUpdateBuff = true
--         self.IsShowName = true
--         self.LowPercent = 0.5
--     elseif self.Owner:IsPhantom() then
--         self.IsShowNum = false
--         self.IsShowLevel = false
--         self.IsShowBillBoard = true 
--         self.IsPlayDeduct = true
--         self.IsUpdateBuff = false
--         self.IsShowName = false
--     end

--     if self.Owner:IsMonster() and (self.StyleNodeName == "Elite_Monster" or self.OwnerType == "EliteMonster") then
--         self.IsEliteMonster = true
--     end
-- end

-- function WBP_MainBar_C:RefreshInvisibleState(bIsInvisible)
--     if not self.Owner.BuffManager then
--         return
--     end

--     if bIsInvisible == nil then
--         local buff_manager = self.Owner.BuffManager
--         local bIsInvincible = buff_manager.SpecialEffects["Invisible"]
--         self.SpecialTag["Invisible"] = bIsInvincible
--     end

--     if self.LastIsInvisible ~= nil and bIsInvisible~=self.LastIsInvisible then
--         return
--     end

--     if (bIsInvisible) then
--         self:DisappearBillboard()
--     else
--         self:AppearBillboard()
--     end
--     self:CheckIsNeedHideGuide()
-- end

-- function WBP_MainBar_C:RefreshInvincibleState()
--     if self.Owner:IsPlayer() or self.Owner:IsPhantom() then
--         return
--     end
--     local IsGodLike = self.Owner.bIsInvincible or self.Owner:IsInvincible()
--     self.SpecialTag["Invincible"] = IsGodLike
--     self:SetInvincible(IsGodLike)
-- end

-- function WBP_MainBar_C:SetInvincible(bIsInvincible)
--     if not self.InvincibleIconBar then
--         return
--     end
--     bIsInvincible = bIsInvincible or false
--     bIsPlayer = self.Owner:IsPlayer()
--     local State = bIsInvincible and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed
--     if bIsPlayer then
--         self.VX_Player_InvincibilLight:SetVisibility(State)
--     else
--         self.VX_Monster_InvincibilLight:SetVisibility(State)
--     end

--     if bIsInvincible ~= self.bIsInvincible then
--         self.bIsInvincible = bIsInvincible
--         self.InvincibleIconBar:SetInvincible(bIsInvincible)
--         if self.HpBar then
--             self.HpBar:PlayInvincibility(bIsInvincible)
--         end
--         if self.ShieldBar then
--             self.ShieldBar:PlayInvincibility(bIsInvincible)
--         end
--     end
-- end

-- function WBP_MainBar_C:DisappearBillboard()
--     self.SizeBox_Main:SetRenderOpacity(0.0)
-- end

-- function WBP_MainBar_C:AppearBillboard()
--     self.SizeBox_Main:SetRenderOpacity(1.0)
-- end

-- function WBP_MainBar_C:CheckIsNeedHideGuide()
--     local IsShowGuideIcon = true
--     if (self.OwnerType == "NormalMonster" or self.OwnerType == "EliteMonster" or self.OwnerType == "BreakableItems" or self.OwnerType == "Npc") then
--         IsShowGuideIcon = not self.SpecialTag["Invisible"]
--     end
--     if (IsValid(self.SceneMgrComponent)) then
--         self.SceneMgrComponent:ShowOrHideGuideIconByGuideName(tostring(self.Owner.Eid), IsShowGuideIcon)
--     end
-- end

-- function WBP_MainBar_C:RefreshWeaknessIcons() 
--     if not self.WeaknessIconBar or not self.Owner.BuffManager then
--         return
--     end

--     local WeaknessTypes = self.Owner.BuffManager:GetWeaknessBuffs()
--     self.WeaknessIconBar:RefreshWeaknessIcons(WeaknessTypes)
-- end

-- function WBP_MainBar_C:CheckIsShowByType()
--     return self.Panel_Zoom:GetRenderOpacity() >= 1.0 and self.SizeBox_Main:IsVisible()
-- end


-- function WBP_MainBar_C:UpdateCharBuffUI()
--     if not self.Owner or not self.Owner.BuffManager or not self.bIsUpdateBuff then
--         return
--     end

--     -- 刷新身上的Buff显示
--     local buff_manager = self.Owner.BuffManager
--     local AllBuffs = buff_manager:GetBillboardBuffs()
--     self:RefreshBuffs(self.HB_Buff_EliteRoot, AllBuffs) -- BUFF UI 等别人优化

--     -- self:RefreshInvisibleState()  -- 跟下面那行合并，同改成值刷新时才调用
--     -- self:CheckIsNeedHideGuide()

--     -- self:RefreshWeaknessIcons() -- 有变化时才调用
-- end

-- function WBP_MainBar_C:SetLevelText(Level) --todo 处理下 只设置玩家名字
--     self.Lv:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     self.Num_Lv_elite:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     if Level == nil or not self.IsShowLevel then
--         return
--     end
--     if self.IsEnemy then
--         Level = tonumber(Level)
--         local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
--         local PlayerLevel = Player:GetAttr("Level")
--         local ColorStr = "ffffffff"

--         if Level <= PlayerLevel - MonsterUtils.DANGER_GAP_LEVEL then
--             ColorStr = "ffffffff"
--         elseif Level >= PlayerLevel + MonsterUtils.DANGER_GAP_LEVEL then
--             ColorStr = "ff3e3eff"
--         else
--             ColorStr = "ffffffff"
--         end

--         local SlateColor = UE4.UUIFunctionLibrary.StringToSlateColor(ColorStr)
--         self.Num_Lv_elite:SetColorAndOpacity(SlateColor)
--         -- self.Lv:SetColorAndOpacity(SlateColor)
--     end
--     if self.Owner:IsPlayer() then -- TODO
--         self.Lv:SetText(GText('BATTLE_UI_BLOOD_LV'))
--         self.Lv:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--     end
--     self.Num_Lv_elite:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--     self.Num_Lv_elite:SetText(tostring(Level))
-- end

-- function WBP_MainBar_C:SetLevelText_Lua()
--     self.Lv:SetText(GText('BATTLE_UI_BLOOD_LV'))
--     self.Lv:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
-- end

-- function WBP_MainBar_C:RefreshLevelInfo(NewLevel)
--     if not self.IsShowLevel or not NewLevel then
--         return
--     end

--     self.Num_Lv_elite:SetText(tostring(NewLevel))
-- end

-- function WBP_MainBar_C:InitAnimationInAndOut()
--     if self.Owner:IsPlayer() then
--         if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
--             self.InAnimation = self.Player_In_Phone
--             self.OutAnimation = self.Player_Out_Phone
--             self.HitAnimation = self.Player_Hit_Phone
--             self.HealthLowAnimation = self.Player_HealthLow_Phone
--             self.ShieldOverLoadAnimation = self.Player_ShieldOverLoad_Phone
--             self.ShieldOverLoadRemindAnimation =self.Player_ShieldOverLoad_Remind_Phone
--         else
--             self.InAnimation  = self.Player_In
--             self.OutAnimation = self.Player_Out
--             self.HitAnimation = self.Player_Hit
--             self.HealthLowAnimation = self.Player_HealthLow
--             self.ShieldOverLoadAnimation = self.Player_ShieldOverLoad
--             self.ShieldOverLoadRemindAnimation =self.Player_ShieldOverLoad_Remind
--             self.BarLength = 240
--             self.BloodBarHeight = 10
--             self.ShieldBarHeight = 6
--         end
--     else
--         self.InAnimation  = (self.Owner:IsCombatItemBase() or self.Owner:IsMechanismSummon()) and self.Machine_In  or self.Monster_In
--         self.OutAnimation = (self.Owner:IsCombatItemBase() or self.Owner:IsMechanismSummon()) and self.Machine_Out  or self.Monster_Out
--         self.BarLength = 120
--         self.BloodBarHeight = 6
--         self.ShieldBarHeight = 3
--     end

--     self:BindToAnimationFinished(self.InAnimation,{self,function ()
--         self.PlayedInAnimation = true
--         self.BarLength = self.SizeBox_HPRoot.MinDesiredWidth
--         self.BloodBarHeight = self.SizeBox_HPRoot.HeightOverride
--         self.ShieldBarHeight = self.SizeBox_ShieldRoot.HeightOverride

--         if self.HpBar then
--             self.HpBar:SetLength(self.BarLength)
--         end

--         if self.ShieldBar then
--             self.ShieldBar:SetLength(self.BarLength) --TODO
--             self.ShieldBar:SetHeight(self.ShieldBarHeight)
--         end

--         self:UnbindAllFromAnimationFinished(self.InAnimation)
--     end})
    
--     if not self.Owner:IsPlayer() then
--     else
--         self:PlayAnimation(self.InAnimation)
--     end

--     if  not self.Owner:IsPlayer() then
--         self.Panel_Zoom:SetRenderOpacity(0.0)
--     end
--     if self.IsEliteMonster then
--         self.MonsterName:SetRenderOpacity(1.0)
--         self.Static_Image_Sign:SetRenderOpacity(1.0)
--         self.Static_ImageBG:SetRenderOpacity(1.0)
--     end

-- end

-- function WBP_MainBar_C:CharOnDead()
--     local function PlayAnimFinished()
--         self:ShowOrHideBillboard(false) --TODO
--     end
--     self:StopAllAnimations()
--     if (IsValid(self.SceneMgrComponent) and self.SceneMgrComponent.SpecialMonsterInfo[self.OwnerEid]) then -- TODO这个不要放血条里比较好
--         self.SceneMgrComponent.SpecialMonsterInfo[self.OwnerEid] = nil
--     end
--     self:PlayAnimation(self.OutAnimation)
--     self:BindToAnimationFinished(self.OutAnimation, {self, PlayAnimFinished})
--     self:OnDead()
-- end

-- function WBP_MainBar_C:UpdateBar(IsNeedShowBillboard)
--     if not IsValid(self.Owner) then
--         return
--     end
--     self.LastHp = self.CurHp
--     self.LastShield = self.CurShield
--     self.LastOverShield = self.CurOverShield
--     self.CurHp = self.Owner:GetAttr("Hp") or 0
--     self.CurShield = self.Owner:GetAttr("ES") or 0
--     self.CurOverShield = self.Owner:GetAttr("OverShield") or 0

--     local IsAttacking = self:IsAttacking()
--     local IsRealReduceBlood = self.LastHp > self.CurHp
--     local IsRealReduceShield = self.LastShield > self.CurShield


--     ----------------------------------------护盾相关更新-----------------------------------------------
--     if self.MaxShield > 0 and self.ShieldBar then
--         self.ShieldBar:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--         local LastPercent = math.clamp(self.LastShield/self.MaxShield,0,1)
--         local CurPercent = math.clamp(self.CurShield/self.MaxShield,0,1)
--         if IsRealReduceShield then
--             self.ShieldBar:SetBarPercent(CurPercent)
--             local DelayTime = IsAttacking and self.ComboAttackTime or 0
--             self.ShieldBar:PlayDeduct(IsAttacking,self.IsPlayDeduct)
--             self:SetShieldNum_Player()
--         elseif self.LastShield < self.CurShield then
--             self.ShieldBar:SetBarPercent(CurPercent,false)
--             self.ShieldBar:PlayRecoveryShield(self.CurShield - self.LastShield > 1)
--         elseif self.CurOverShield > 0 then
--             if self.IsShowNum then
--                 self:SetShieldNum_Player()
--             else
--                 self:CheckAndPlayOvershield()
--             end
--         end
--         if self.CurShield <= 0 then
--             self:SheildDeductToZero()
--         end
--     end
--     ---------------------------------------------------------------------------------------------------


--     ----------------------------------------血量相关更新 ----------------------------------------------
--     if self.HpBar then
--         local LastPercent = math.clamp(self.LastHp/self.MaxHp,0,1)
--         local CurPercent = math.clamp(self.CurHp/self.MaxHp,0,1)
--         self.HpBar:SetBarPercent(CurPercent)
--         if IsRealReduceBlood then
--             self.HpBar:PlayDeduct(IsAttacking,self.IsPlayDeduct)
--         end
--         self:SetBloodNum_Player()
--         self:CheckAndPlayLowHealth()
--     end
--     ---------------------------------------------------------------------------------------------------

--     ----------------------------------------玩家血条额外逻辑(目前只有Hit动效) ----------------------------
--     if self.Owner:IsPlayer() and (IsRealReduceBlood or IsRealReduceShield) then
--         self:PlayAnimation(self.HitAnimation)
--     end
--     ---------------------------------------------------------------------------------------------------

--     ----------------------------------------隐身怪受到攻击 ---------------------------------------------- --TODO 考虑单独封装成一个函数，C++里调回来
--     if (self.SpecialTag["Invisible"] and (IsRealReduceShield or IsRealReduceBlood)) then
--         if (IsValid(self.SceneMgrComponent)) then
--             self.SceneMgrComponent.SpecialMonsterInfo[self.OwnerEid] = {LastAttackedTime=UE4.UGameplayStatics.GetTimeSeconds(self)}
--         end
--     end
--     ---------------------------------------------------------------------------------------------------

--     self.SizeBox_Main:SetRenderOpacity(1.0)
--     if IsRealReduceBlood or IsRealReduceShield then
--         IsNeedShowBillboard = true
--     end
--     if (not GMVariable.EnableShowBillboard and not self.Owner:IsPlayer()) then
--         self.Panel_Zoom:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     elseif (IsNeedShowBillboard and self.IsShowBillBoard) then
--         if not self.PlayedInAnimation then
--             self:PlayAnimation(self.InAnimation)
--         else
--             self.Panel_Zoom:SetRenderOpacity(1.0)
--             self.Panel_Zoom:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--         end

--         if self.IsShowName and  EMCache:Get("ShowMonsterName") and self.MonsterName:GetRenderOpacity() < 1.0 then
--             self.MonsterName:SetRenderOpacity(1.0)
--         end

--     end
-- end

function WBP_MainBar_C:WhileInvisibleMonsterBeAttack(Eid,NowTimeSeconds)
    if (IsValid(self.SceneMgrComponent)) then
        self.SceneMgrComponent.SpecialMonsterInfo[Eid] = {NowTimeSeconds}
    end
end

-- function WBP_MainBar_C:SheildDeductToZero()
--     if self.Owner:IsPlayer() then
--         if self.LastShield > 0 then
--             self.ShieldBar:PlayAnimation(self.ShieldBar.Sheild_Broken)
--         end
--     -- else
--     --     self.ShieldBar:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     end
-- end


---------------怪物/可破坏物/NPC血条事件相关-------------------------------------------------------

function WBP_MainBar_C:RegisterEventsNormal()
    if self.Owner:IsMonster() or self.Owner:IsCombatItemBase() or self.Owner:IsNPC() or self.Owner:IsMechanismSummon() then
        -- self:AddDispatcher(EventID.OnUpdateMonsterDamages, self, self.OnDamaged)
        if self.bIsDangerEnemy then self:AddDispatcher(EventID.MainPlayerLevelUp,self,self.OnMainPlayerLevelUp) end
    end
end

function WBP_MainBar_C:OnMainPlayerLevelUp(MainPlayerNowLevel)
    if not IsValid(self.Owner) then return end
    if self.bIsDangerEnemy then 
        local NowLevel = self.Owner:GetAttr("Level")
        if (NowLevel - MainPlayerNowLevel < 10) then
            self:SetLevelText(NowLevel)
            self:RemoveDispatcher(EventID.MainPlayerLevelUp)
        end
    end
end

-- function WBP_MainBar_C:OnDamaged(ActionName, DamageEvent)
--     local DamageValues = DamageEvent.DamageValues
    
--     -- 缓存打击技能是否为攻击
--     self:CheckIsReduceDelay(DamageEvent)
    
--     -- 弱点打击特效
--     if ActionName == "Attack" then
--         for DamageType, _ in pairs(DamageValues or {}) do
--             self:PlayWeaknessEffect(DamageType)
--         end
--     end
-- end

function WBP_MainBar_C:CheckIsReduceDelay(DamageEvent)
    local NowTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
    if DamageEvent.SkillId then
        local SkillInfo = DataMgr.Skill[DamageEvent.SkillId]
        if SkillInfo and SkillInfo[1] then
            -- 技能的伤害类型一般不改，直接拿默认等级就可以
            local SkillGradeInfo = SkillInfo[1][0]
            if SkillGradeInfo then
                local SkillType = SkillGradeInfo.SkillType
                if SkillType == 'Attack' then
                    self.LastAttackTime = NowTime
                end
            end
        end
    end
end

-- function WBP_MainBar_C:IsAttacking()
--     if self.LastAttackTime then
--         return UE4.UGameplayStatics.GetRealTimeSeconds(self) - self.LastAttackTime < Const.BloodBarDelayTime
--     else
--         return false
--     end
-- end

-- function WBP_MainBar_C:PlayWeaknessEffect(DamageType)
--     if not self.WeaknessIconBar then
--         return
--     end
--     self.WeaknessIconBar:PlayWeaknessEffect(DamageType)
-- end
-----------------------------------------------------------------


-------------------------角色事件相关-----------------------
function WBP_MainBar_C:Reinitialize()
    self:InitValue(self.Owner)
    self:OnUpdateCharLevelAndExp()
    self.HpBar:ReInit()
    if self.ShieldBar then
        self.ShieldBar:ReInit()
    elseif self.MaxShield > 0 then
        self:CheckAndLoadShieldBar()
    end

    if self.MaxShield > 0 and self.ShieldBar then
        local CurOverShiledPercent = self.CurOverShield / self.MaxShield
        self.ShieldBar:SetOverShieldPercent(CurOverShiledPercent)
        self:CheckAndPlayOvershield()
        self:SetOverShieldNum_Player()
    end

    local CurBloodPercent = math.clamp(self.CurHp/self.MaxHp, 0, 1)
    local CurShieldPercent = self.MaxShield == 0 and 0 or math.clamp(self.CurShield/self.MaxShield, 0, 1)
    self.HpBar:SetBarPercent(CurBloodPercent)
    if self.ShieldBar then
        self.ShieldBar:SetBarPercent(CurShieldPercent)
        if (self.MaxShield <= 0) then
            self.ShieldBar:SetVisibility(UE4.ESlateVisibility.Collapsed)
        else
            self.ShieldBar:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    end
    self:SetBloodNum_Player()
    self:SetShieldNum_Player()
    local function SetColor()
        self:CheckAndPlayLowHealth()
        self.HpBar:SetBarColor(false)
    end
    SetColor()
    self:InitLastingEffect()
    -- self:AddTimer(0.15,SetColor)
end


function WBP_MainBar_C:CharRecovery(Eid)
    local GameInstance = self:GetGameInstance()
    local UIManager = GameInstance:GetGameUIManager()
    if UIManager and UIManager:GetArmoryUIObj() then
        return
    end
    self:Reinitialize()
    self:PlayAnimation(self.InAnimation)
end

function WBP_MainBar_C:OnUpdateCharLevelAndExp()
    -- if (CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile") then
    --     return
    -- end
    if not IsValid(self.Owner) then
        return
    end
    local NowLevel = self.Owner:GetAttr("Level")
    -- self.Lv:SetText(GText('BATTLE_UI_BLOOD_LV'))
    self.Num_Lv_elite:SetText(NowLevel)

    if self.OldLevel and self.OldLevel < NowLevel and self.Owner:IsMainPlayer() then
        EventManager:FireEvent(EventID.MainPlayerLevelUp,NowLevel)
    end
    self.OldLevel = NowLevel
end

function WBP_MainBar_C:OnMainCharacterInitReady()
    if not IsValid(self.Owner) then
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
        self.Owner = Player
    end
    self:RealInit(self.Owner, self.OwnerType or "", self.StyleNodeName or "")
    --self:InitHUDScale()
    self:AddTimer(1.0, self.CheckMaxHpAndShieldChange, true, 0, "CheckMaxHpAndShieldChange")
end

function WBP_MainBar_C:CheckMaxHpAndShieldChange()
    if self:IsVisible() == false or not IsValid(self.Owner) then
        return
    end
    local NowMaxHp=self.Owner:GetAttr("MaxHp")
    local NowMaxShield=self.Owner:GetAttr("MaxES")
    if self.MaxHp ~=NowMaxHp or self.MaxShield ~= NowMaxShield then
        self:Reinitialize()
    end
end

function WBP_MainBar_C:OnShowMainPlayerHealEvent(HealEvent)
    -- if self.CurHp == self.MaxHp and self.IsPlayingReturning then
    --     self:StopReturning()
    --     return
    -- end
    if self.IsCharInHotUI then
        self:UpdateCharHotUIState(true)
        return
    end
    local IsHaveHot = false
    if HealEvent.DamageTag then
        for key,value in pairs(HealEvent.DamageTag) do
            if value == "Hot" then
                IsHaveHot = true
            end
        end
    end
    if not IsHaveHot then
        EMUIAnimationSubsystem:EMPlayAnimation(self.PlayerBloodReturn,self.PlayerBloodReturn.Player_BloodReturn)
    end
end

function WBP_MainBar_C:UpdateCharHotUIState(HotUI)
    self.IsCharInHotUI = HotUI
    -- if self.CurHp == self.MaxHp and self.IsPlayingReturning then
    --     self:StopReturning()
    --     return
    -- end
    if HotUI then
        self:StartReturing()
    elseif self.IsPlayingReturning then
        self:StopReturning()
    end
end

function WBP_MainBar_C:StartReturing()
    if not self.PlayerBloodReturn or self.IsPlayingReturning then
        return
    end
    EMUIAnimationSubsystem:EMStopAnimation(self.PlayerBloodReturn,self.PlayerBloodReturn.Player_BloodReturnEnd)
    EMUIAnimationSubsystem:EMPlayAnimation(self.PlayerBloodReturn,self.PlayerBloodReturn.Player_BloodReturning)
    -- self.PlayerBloodReturn:StopAnimation(self.PlayerBloodReturn.Player_BloodReturnEnd)
    -- self.PlayerBloodReturn:PlayAnimation(self.PlayerBloodReturn.Player_BloodReturning)
    self.IsPlayingReturning = true
end

function WBP_MainBar_C:StopReturning()
    if not self.PlayerBloodReturn or not self.IsPlayingReturning then
        return
    end
    EMUIAnimationSubsystem:EMStopAnimation(self.PlayerBloodReturn,self.PlayerBloodReturn.Player_BloodReturning)
    EMUIAnimationSubsystem:EMPlayAnimation(self.PlayerBloodReturn,self.PlayerBloodReturn.Player_BloodReturnEnd)
    -- self.PlayerBloodReturn:StopAnimation(self.PlayerBloodReturn.Player_BloodReturning)
    -- self.PlayerBloodReturn:PlayAnimation(self.PlayerBloodReturn.Player_BloodReturnEnd)
    self.IsPlayingReturning = false
end



-- function WBP_MainBar_C:SetBloodNum_Player()
--     if not self.IsShowNum or not self.HpBar then
--         return
--     end
--     self.Num_Blood:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--     local Blood  = self.CurHp
--     self.Num_Blood:SetText(tostring(Blood))
-- end

-- function WBP_MainBar_C:SetShieldNum_Player(DelayPercent)
--     if not self.IsShowNum or not self.ShieldBar or not self.Owner:IsPlayer() or self.MaxShield <= 0 then
--         self.Num_Shield:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         return
--     end
--     self.Num_Shield:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--     local Shield = self.CurShield
--     if DelayPercent then
--         Shield = self.MaxShield * DelayPercent
--     end
--     Shield = math.floor(Shield + self.CurOverShield)
--     self.Num_Shield:SetText(tostring(Shield))
--     self:CheckAndPlayOvershield()
-- end

-- function WBP_MainBar_C:CheckAndPlayLowHealth()
--     if self.IsEnemy then
--         return
--     end
--     local IsLowHealth = self.HpBar:CheckIsLowPercent(self.LowPercent or 0)
--     if IsLowHealth then
--         if self.IsLowHealth == false then
--             self:PlayAnimation(self.HealthLowAnimation)
--         end
--     else
--         if self.IsLowHealth then
--             self:StopAnimation(self.HealthLowAnimation)
--            -- self:PlayAnimationReverse(self.HealthLowAnimation)
--             if self.IsShowNum then
--                 local LinearColor = FLinearColor(0.258183,0.590619,0.318547)
--                 local SlateColor = FSlateColor()
--                 SlateColor.SpecifiedColor = LinearColor
--                 self.Num_Blood:SetColorAndOpacity(SlateColor)
--             end
--         end
--     end
--     self.IsLowHealth = IsLowHealth
--     self.HpBar:CheckAndPlayLowHealth(IsLowHealth)
-- end

-- function WBP_MainBar_C:CheckAndPlayOvershield()
--     if self.CurOverShield > 0 then
--         if self.LastOverShield < self.CurOverShield then
--             self.IsOverShield = true
--             self:UnbindAllFromAnimationFinished(self.ShieldOverLoadAnimation)
--             local function PlayAnimFinished()
--                 self:PlayAnimation(self.ShieldOverLoadRemindAnimation)
--                 self.ShieldBar:PlayAnimation(self.ShieldBar.Player_ShieldOverload_Remind)
--             end
--             self:PlayAnimation(self.ShieldOverLoadAnimation)
--             self.ShieldBar:PlayAnimation(self.ShieldBar.Player_ShieldOverload)
--             self:BindToAnimationFinished(self.ShieldOverLoadAnimation, {self, PlayAnimFinished})
--         end
--     else
--         if self.IsOverShield then
--             self:UnbindAllFromAnimationFinished(self.ShieldOverLoadAnimation)
--             self:StopAnimation(self.ShieldOverLoadAnimation)
--             self:PlayAnimationReverse(self.ShieldOverLoadAnimation)
--             self.ShieldBar:PlayAnimationReverse(self.ShieldBar.ShieldOverLoadAnimation)
--         end
--         self.IsOverShield = false
--     end
-- end

function WBP_MainBar_C:CheckChangeRole()
    if not self.Owner:IsPlayer() then
        return
    end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if not IsValid(Player) then
        return
    end
    local NewRoleId = Player.CurrentRoleId
    if self.RoleId~=NewRoleId and NewRoleId ~=0 then
        self.Owner  = Player
        self.OwnerEid = Player.Eid
        self.RoleId = Player.CurrentRoleId
        self:Reinitialize()
        self:PlayAnimation(self.InAnimation)
    end
end
-----------------------------------------------------------

-- function WBP_MainBar_C:CheckCanTick()
--     if not self.Owner:IsPlayer() then
--         self:DisableTick()
--     end
-- end

-- function WBP_MainBar_C:SetSize()
--     if not self.Owner:IsPlayer() then
--         self.SizeBox_HPRoot:SetHeightOverride(6.0)
--         self.SizeBox_HPRoot:SetMinDesiredWidth(120.0)
--         self.SizeBox_ShieldRoot:SetHeightOverride(3.0)
--         self.SizeBox_Main:SetHeightOverride(20.0)
--         self.SizeBox_Main:SetMinDesiredWidth(190.0)
--     end
-- end

function WBP_MainBar_C:CheckIsEnemyToPlayer(Owner)
    if Owner then
        rawset(self, "Owner", Owner)
    end
    local OwnerCamp = self.Owner:GetCamp()
    if OwnerCamp == ECampName.None or not OwnerCamp then
        if self.Owner:IsPlayer() then
            return false
        end
        if DataMgr[self.Owner.UnitType] then
            OwnerCamp = DataMgr[self.Owner.UnitType][self.Owner.UnitId].Camp
        else
            return true
        end
    end
    return DataMgr.CampRule[OwnerCamp]["Player"] == Const.Enemy
end

-- function WBP_MainBar_C:ShowOrHideName(IsShow)
--     if not self.bIsShowName then
--         return
--     end
--     if IsShow then
--         if not self:IsAnimationPlaying(self.Monster_NameIn) and self.MonsterName:GetRenderOpacity() < 1.0 then
--             self:StopAnimation(self.Monster_NameOut)
--             self:PlayAnimation(self.Monster_NameIn)
--         end
--     elseif not self.IsEliteMonster then
--         if not self:IsAnimationPlaying(self.Monster_NameOut) and self.MonsterName:GetRenderOpacity() > 0.0 then
--             self:StopAnimation(self.Monster_NameIn)
--             self:PlayAnimation(self.Monster_NameOut)
--         end
--     end
-- end

function WBP_MainBar_C:_SyncPhantomName()
    if self.bPendingPhantomSetName then
        DebugPrint(DebugTag, "WBP_MainBar_C:SetPhantomName _SyncPhantomName")
        self:SetName()
        self.bPendingPhantomSetName = false
    end
end

-- 与function WBP_Teammate_PC_C:SetName()作用相同
function WBP_MainBar_C:SetPhantomName()
    local NameKey = DataMgr.BattleChar[self.RoleId].CharName
    DebugPrint(DebugTag, "WBP_MainBar_C:SetPhantomName NameKey ", NameKey)
    DebugPrint(DebugTag, "WBP_MainBar_C:SetPhantomName ContentEN ", DataMgr.TextMap_ContentEN[NameKey].ContentEN)
    DebugPrint(DebugTag, "WBP_MainBar_C:SetPhantomName IsStandAlone(self) ", IsStandAlone(self))

    local ShowName = ""
    -- 若为false，代表下一帧需要继续拿名字
    local bHasCorrectShowName = false

    -- 主角魅影
    if string.find(DataMgr.TextMap_ContentEN[NameKey].ContentEN, "{nickname") and not IsStandAlone(self) then
        local PhantomState = GameState(self):GetPhantomState(self.Owner.Eid)
        if not PhantomState then
            local PhantomOwner = self.Owner.PhantomOwner
            if PhantomOwner then
                local OwnerState = GameState(self):GetPlayerState(PhantomOwner.Eid)
                if OwnerState and OwnerState.PlayerName then
                    ShowName = OwnerState.PlayerName
                end
            end
            DebugPrint(DebugTag, "WBP_MainBar_C:SetPhantomName not PhantomState")
            self.bPendingPhantomSetName = true
        else
            local PhantomOwnerEid = PhantomState.OwnerEid
            if PhantomOwnerEid then
                local OwnerState = GameState(self):GetPlayerState(PhantomOwnerEid)
                if OwnerState and OwnerState.PlayerName then
                    ShowName = OwnerState.PlayerName
                    bHasCorrectShowName = true
                else
                    ShowName = GText(NameKey)
                    self.bPendingPhantomSetName = true
                    DebugPrint(ErrorTag, "WBP_MainBar_C:SetPhantomName  主角魅影找不到它的OwnerPlayerName")
                end
            else
                DebugPrint(ErrorTag, "WBP_MainBar_C:SetPhantomName  主角魅影找不到它的Owner， 无法赋予名称")
                ShowName = "<ERROR>"
            end
        end
    -- 普通魅影
    else
        ShowName = GText(NameKey)
        bHasCorrectShowName = true
    end
    
    self.MonsterName:SetText(ShowName)
    self.MonsterName:SetVisibility(ESlateVisibility.SelfHitTestInvisible)

    DebugPrint(DebugTag, "WBP_MainBar_C:SetPhantomName GetText ", self.MonsterName:GetText())
    DebugPrint(DebugTag, "WBP_MainBar_C:SetPhantomName bHasCorrectShowName ", bHasCorrectShowName)

    if not bHasCorrectShowName then
        self:AddTimer(0.2, self.SetName, false, 0, "WBP_MainBar_C:SetPhantomName", true)
    end
end

function WBP_MainBar_C:SetName()
    DebugPrint("WBP_MainBar_C:SetName 1",self.MonsterName,self.bIsShowName,self.Owner:GetName())
    if not self.MonsterName then return end
    self.MonsterName:SetVisibility(ESlateVisibility.Collapsed)
    if not self.bIsShowName then
        return
    end
    local Data = self.Owner.Data
    if not Data or not Data.UnitName then
        self.bIsShowName = false
        DebugPrint("WBP_MainBar_C:SetName return because not Data or Data.UnitName",Data)
        return
    end
    local Name
    if self.Owner:IsPhantom() then
        -- Name = DataMgr.BattleChar[self.RoleId].CharName
        -- 需要考虑一种特殊情况：联机时候队友携带的魅影是主角魅影，此时主角魅影的名字应该显示为队友的名字，而不是我的名字
        self:SetPhantomName()
        return
    else
        Name = Data.UnitName
    end
    if not Name then
        DebugPrint("WBP_MainBar_C:SetName return because not Name",self.Owner:GetName())
        self.bIsShowName = false
        return
    end
    -- self.SizeBox_Name:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- self.MonsterName:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    DebugPrint("WBP_MainBar_C:SetName",Name,GText(Name))
    self.MonsterName:SetText(GText(Name))
    self.MonsterName:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function WBP_MainBar_C:GetLastingEffectColorMap()
    return self.LastingEffectColorMap
end

-- function WBP_MainBar_C:SetFontSize()
--     local FontSize
--     if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
--         FontSize = 12
--     else
--         FontSize = 15
--     end
--     local ChangeList = {self.Lv,self.Num_Lv_elite,self.Num_Blood,self.Num_Shield}
--     for _,v in pairs(ChangeList) do
--         local Font = v.Font
--         Font.Size = FontSize
--         v:SetFont(Font)
--     end
-- end

-- function WBP_MainBar_C:BuffSpecialEffect_InvincibleUI(IsShow)
--     self:SetInvincible(IsShow)
-- end

function WBP_MainBar_C:Destruct()
    WBP_MainBar_C.Super.Destruct(self)
    self.IsDestroied = true

    self:RemoveDispatcher(EventID.OnRepOwnerEidPhantomState)
    self:RemoveDispatcher(EventID.OnRepPlayerName)
    self:RemoveDispatcher(EventID.OnCloseLoading)
end

return WBP_MainBar_C