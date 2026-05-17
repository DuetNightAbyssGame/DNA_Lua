--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local GMVariable = require "BluePrints.UI.GMInterface.GMVariable"
local EMCache = require "EMCache.EMCache"
local BP_CharBillboard_C = Class({
    "BluePrints.Common.TimerMgr",
})

function BP_CharBillboard_C:Initialize(Initializer)
    self.Owner = nil
    -- self.TypeStr = ""
    -- self.StyleNodeName = ""
    -- self.ShootStateLastTime = 0.3
    -- self.HitStateLastTime = 3
    -- self.LastAttackTimeStamp = -1.0  -- 上次受击/治疗的时间戳
    -- self.bUpdateHP = true
    -- self.bUpdateES = true
    -- self.bUpdateTN = false
    -- self.TickBloodReduceTime = 0.03  -- Tick血量减少的时间间隔
end

-- TalkGameInput是否是可游戏输入对话
function BP_CharBillboard_C:ShowBillboard(Message)
    if(not Message.bDisableGameInput) then return end
    self:SetVisibility(true)
end
function BP_CharBillboard_C:HideBillboard(Message)
    if(not Message.bDisableGameInput) then return end
    self:SetVisibility(false)
end

function BP_CharBillboard_C:GetCurrentWidget()
    if not self.CurrentWidget then
        self.CurrentWidget = self:GetUserWidgetObject()
    end
    return self.CurrentWidget
end

-- function BP_CharBillboard_C:OnBuffsChanged()
--     -- if self.Owner:IsMainPlayer() then
--     --     local BattleMain =  UIManager(self):GetUIObj("BattleMain")
--     --     if BattleMain then
--     --         BattleMain.PlayerBloodBar:UpdateCharBuffUI()
--     --     end
--     --     return
--     -- end
--     local CurrentWidget = self:GetUserWidgetObject()
--     if (CurrentWidget ~= nil and CurrentWidget.UpdateCharBuffUI) then
--         CurrentWidget:UpdateCharBuffUI()
--     end

--     if self.Owner.TeammateUI then -- 可以不用跑
--         self.Owner.TeammateUI:UpdateCharBuffUI()
--     end
-- end

-- function BP_CharBillboard_C:ReceiveTick(DeltaSeconds)
--     -- local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
--     -- if (not IsValid(PlayerCharacter) or IsDedicatedServer(self)) then
--     --     return
--     -- end
--     -- local OwnerType = self:GetOwnerType()
--     -- local CurrentWidget = self:GetUserWidgetObject()
--     -- if (CurrentWidget ~= nil) then
--     --     CurrentWidget:SetRenderScale(self:GetCurScaleSize())
--     -- end
--     -- local TargetLocation = self:GetCharLocation()
--     -- local PlayerLocation = PlayerCharacter:K2_GetActorLocation()
--     -- self.lastDistance = UE4.UKismetMathLibrary.Vector_Distance(PlayerLocation, TargetLocation) / 100.0
--     -- if (OwnerType == "Monster") then
        
--     -- elseif (OwnerType == "BreakableItems") then
        
--     -- end
-- end

-- function BP_CharBillboard_C:AutoFitShieldAndBloodSize(IsNeedShowBillboard)
--     if (not IsValid(self.Owner)) then
--         return
--     end
--     local CurrentWidget = self:GetUserWidgetObject()
--     if CurrentWidget and CurrentWidget.UpdateBar then
--         CurrentWidget:UpdateBar(IsNeedShowBillboard)
--     end

-- end

-- 已迁移到C++
-- function BP_CharBillboard_C:RefreshDiffInfoByAction_Lua()
    
--     -- if not self:CheckCanUpdate(UpdateType) then
--     --     return
--     -- end

--     -- if (self.TypeStr == "Monster" or self.TypeStr == "Npc") then
--     --     self:RefreshMonsterInfoByAction()
--     -- elseif (self.TypeStr == "BreakableItems") then
--     --     self:RefreshItemsInfoByAction()

--     if not self.Owner then self.Owner = self:GetOwner() end

--     if self.TypeStr == "BossPlace" then
--         self:RefreshBossPlaceBlood()
--     elseif self.Owner and (self.bNeedUpdateBossUI or self.Owner:IsBossMonster()) then
--         local BossBillboard = self.Owner.BossBloodUI
--         if BossBillboard and BossBillboard.UpdateBossBlood then
--             BossBillboard:UpdateBossBlood("Attack")
--         end
--     end

--     -- if self.Owner and self.Owner.BlockTickLod_MoveComp then
--     --     self.Owner:BlockTickLod_MoveComp(true, Const.BlockTickLodTag.CharBillboard)
--     -- end
-- end

-- 已迁移到C++
-- function BP_CharBillboard_C:RefreshBossPlaceBlood(ActionName)
--     local CurrentWidget = self:GetUserWidgetObject()
--     if (CurrentWidget == nil) then
--         return
--     end
--     CurrentWidget:UpdateBossPlaceBlood()
-- end

function BP_CharBillboard_C:RefreshPlayerBillBoard(PlayerActor)
    --DebugPrint("----jzn---RefreshPlayerBillBoard---")
    local CurrentWidget = self:GetUserWidgetObject()
    if (CurrentWidget == nil) then
        return
    end

    -- if CurrentWidget.UpdateRecoverIndicator then 
    --     CurrentWidget:UpdateRecoverIndicator(PlayerActor)
    -- end
end

-- function BP_CharBillboard_C:RefreshLevelInfo(NewLevel)
--     local CurrentWidget = self:GetUserWidgetObject()
--     if (CurrentWidget ~= nil and CurrentWidget.RefreshLevelInfo) then
--         CurrentWidget:RefreshLevelInfo(NewLevel)
--     end
-- end

function BP_CharBillboard_C:ReceiveBeginPlay()
    EventManager:AddEvent(EventID.StartTalk, self, self.HideBillboard)
    EventManager:AddEvent(EventID.EndTalk, self, self.ShowBillboard)
    self.IsDestroied = nil
end

function BP_CharBillboard_C:ReceiveEndPlay()
    EventManager:RemoveEvent(EventID.StartTalk, self)
    EventManager:RemoveEvent(EventID.EndTalk, self)
    self.IsDestroied = true
    if (IsValid(self.Owner)) then
        UIManager(self):RemoveWidgetComponentToList(self.Owner.Eid, "Billboard") 
    end
end

-- function BP_CharBillboard_C:InitMonsterBillBoard(Owner, TypeStr, StyleNodeName, IsSync)
--     -- 初始化怪物的Billboard
--     if (not IsValid(Owner) or (Owner.IsSummonMonster and Owner:IsSummonMonster() and not Owner:IsSummonByMonster())) then
--         return
--     end
--     self.LastAttackTimeStamp = -1.0
--     if(self.Owner)then
--         self.Owner:UnregisterListenerOnBuffsChanged(self)
--     end
--     self.Owner = Owner
--     self.Owner:RegisterListenerOnBuffsChanged(self,self.OnBuffsChanged)
--     self.TypeStr = TypeStr
--     self.StyleNodeName = self:GetOwnerStyleNodeName() or "Blood_Shield"

--     if (not IsValid(self.Owner)) then
--         return
--     end

--     local OwnerType = "NormalMonster"
--     local Path = self:GetPathByStyleNodeName(self.StyleNodeName)

--     local AfterLoad = function ()

--         if not IsSync then
--             if self:GetUserWidgetObject()~=nil and not self.Owner.IsFromCache and self.Owner:IsRealMonster() then
--                 return
--             end
--             local WorldContext = GWorld.GameInstance
--             self:SetWidgetAfterAsyncLoad(WorldContext,Path)
--         end

--         CurrentWidget = self:GetUserWidgetObject()
--         if CurrentWidget==nil then
--             return
--         end
--         -- self:SetWidgetSpace(0)
    
--         self.IsInit = true
--         local Height = self.Owner.CapsuleComponent:GetUnscaledCapsuleHalfHeight() * 1.15
--         local Scale = self.Owner.RootComponent:K2_GetComponentScale().Z
--         local HeightOffset = 0
--         if self.Owner.Data.BloodUIParmas then HeightOffset = self.Owner.Data.BloodUIParmas.HeightOffset or 0 end
--         Height = (Height + HeightOffset)/Scale
--         self:K2_SetRelativeLocation(UE4.FVector(0, 0, Height), false, nil, false)
--         CurrentWidget:InitConfig(self.Owner, OwnerType, StyleNodeName)
--         self:AutoFitShieldAndBloodSize(false)
--         self:AddTimer(1.0, self.UpdateCharBillboardInfo, true, 0, "UpdateCharBillboardInfo")
--         if (IsValid(self.Owner)) then
--             UIManager(self):AddWidgetComponentToList(self.Owner.Eid, "Billboard", self) 
--         end
--     end

--     if IsSync then
--         self:SetWidgetClassByBpPath(Path)
--         AfterLoad()
--     else
--         local WorldContext = GWorld.GameInstance
--         self:SetWidgetClassByPathAsync(WorldContext,Path,{self,AfterLoad})
--     end

-- end

function BP_CharBillboard_C:InitMonsterBillBoard_Lua(Owner)
    self.Owner = Owner
end

function BP_CharBillboard_C:AICharacter_AfterWidgetLoad_Lua()
    -- self.IsInit = true
    if self.Owner==nil then
        self.Owner=self:GetOwner()
    end
    if (IsValid(self.Owner)) then
        UIManager(self):AddWidgetComponentToList(self.Owner.Eid, "Billboard", self) 
    end
    self:SetBuffPanelVisibilityByConfig()
end

function BP_CharBillboard_C:RefreshMonsterInfoByAction_Lua()
    -- -- 刷新怪物(召唤物)血条
    -- local CurrentWidget = self:GetUserWidgetObject()
    -- if (CurrentWidget == nil or not IsValid(self.Owner)) then
    --     return
    -- end
    -- self.LastAttackTimeStamp = UE4.UGameplayStatics.GetTimeSeconds(self)
    -- self:ResetForceShowState()
    -- self:AutoFitShieldAndBloodSize(true)
    -- if (not self:IsExistTimer("UpdateCharBillboardInfo")) then
    --     self:AddTimer(1.0, self.UpdateCharBillboardInfo, true, 0, "UpdateCharBillboardInfo") 
    -- end
    if self.Owner:IsPhantom() and self.Owner.TeammateUI then
        self.Owner.TeammateUI:UpdateBar()
    end
end

function BP_CharBillboard_C:InitPlayerBillBoard(Owner, TypeStr)
    -- 初始化玩家的Billboard
    -- if(self.Owner)then
    --     self:UnregisterListenerOnBuffsChanged()
    -- end
    self.Owner = Owner
    -- self.Owner:RegisterListenerOnBuffsChanged(self,self.OnBuffsChanged)
    self.TypeStr = TypeStr
    
    -- 初始化角色的待复活面板
    EventManager:RemoveEvent(EventID.StartTalk, self)
    EventManager:RemoveEvent(EventID.EndTalk, self)

    -- local Path = "WidgetBlueprint'/Game/UI/UI_PC/Battle/Resurrection/Widget/Battle_Resurrection_Indicator_PC.Battle_Resurrection_Indicator_PC_C'"
    -- local  AfterLoad = function ()

    --     local WorldContext = GWorld.GameInstance
    --     self:SetWidgetAfterAsyncLoad(WorldContext,Path)

    --     local CurrentWidget = self:GetUserWidgetObject()
    --     if (CurrentWidget == nil) then
    --         return
    --     end
    --     self.IsInit = true
    --     --local Location = self.Owner.BoxComponent:GetRelativeTransform().Translation
    --     --self:K2_SetRelativeLocation(Location, false, nil, false)
    --     CurrentWidget:InitRecoverIndicator(self.Owner)
    --     if (IsValid(self.Owner)) then
    --         UIManager(self):AddWidgetComponentToList(self.Owner.Eid, "Billboard", self) 
    --     end
    -- end

    -- local WorldContext = GWorld.GameInstance
    -- self:SetWidgetClassByPathAsync(WorldContext,Path,{self,AfterLoad})

end

function BP_CharBillboard_C:InitItemsBillBoard(Owner, TypeStr, StyleNodeName,IsSync)
    -- 初始化道具的Billboard
    self:UnregisterListenerOnBuffsChanged()
    self.Owner = Owner
    if self.Owner.Data == nil then
        return
    end
    self:K2_SetBuffsOwner(Owner)
    self:RegisterListenerOnBuffsChanged()
    self.TypeStr = TypeStr
    self.StyleNodeName = self:GetOwnerStyleNodeName() or "Blood_Shield"
    local Path = self:GetPathByStyleNodeName(self.StyleNodeName)

    local AfterLoad = function()

        if not IsSync then
            if self:GetUserWidgetObject()~=nil then
                return
            end
            local WorldContext = GWorld.GameInstance
            self:SetWidgetAfterAsyncLoad(WorldContext,Path)
        end

        local CurrentWidget = self:GetUserWidgetObject()
        local BloodUIParmas = self.Owner.Data.BloodUIParmas
        if (not IsValid(self.Owner) or CurrentWidget == nil) then
            return
        end
        self.IsInit = true
        -- local Height = self.Owner.Data.BillboardHeightOffset or 150
        local Height = 150
        if (self.Owner.Box) then
            Height = self.Owner.Box:GetScaledBoxExtent().Z * 1.15
        end
        if (self.Owner.CapsuleComponent) then
            Height = self.Owner.CapsuleComponent:GetUnscaledCapsuleHalfHeight() * 1.15
        end
        if (self.Owner.HitedCollision and self.Owner.HitedCollision.GetUnscaledCapsuleHalfHeight) then
            Height = self.Owner.HitedCollision:GetUnscaledCapsuleHalfHeight()
        end
        -- local Scale = self.Owner.RootComponent:K2_GetComponentScale().Z
        -- local HeightOffset = 0
        -- local XOffset = 0
        -- local YOffset = 0
        
        -- if BloodUIParmas then HeightOffset = BloodUIParmas.HeightOffset or 0 end
        -- local SizeboxScale = FVector2D()
        -- if BloodUIParmas then
        --     SizeboxScale.X = BloodUIParmas.ScaleRateX or 1.0
        --     SizeboxScale.Y = BloodUIParmas.ScaleRateY or 1.0
        --     local Offset = BloodUIParmas.Offset
        --     if Offset then
        --         HeightOffset = Offset.Z or 0
        --         XOffset = Offset.X or 0
        --         YOffset = Offset.Y or 0
        --     end
        --     self.bNotShowWhileOccluded = BloodUIParmas.HiddenWhileOccluded == true
        -- end

        -- Height = (Height+HeightOffset)/Scale
        -- XOffset = XOffset/Scale
        -- YOffset = YOffset/Scale

        -- print(_G.LogTag,"InitItemsBillBoard",Height*Scale,Scale,self.Owner:GetName())
        -- self:K2_SetRelativeLocation(UE4.FVector(XOffset, YOffset, Height), false, nil, false)
        -- CurrentWidget:InitConfig(self.Owner, self.Owner:GetAttr("Level"), "BreakableItems", self.StyleNodeName)
        CurrentWidget:InitConfig(self.Owner, "BreakableItems", self.StyleNodeName)
        self:SetItemBillboardLocation(Height,self.Owner.Data.UnitId or 0)
        -- if CurrentWidget.SetSizeboxScale then
        --     CurrentWidget:SetSizeboxScale(SizeboxScale)
        -- else
        --     self.DefaultScaleX = SizeboxScale.X
        --     self.DefaultScaleY = SizeboxScale.Y
        -- end
        if BloodUIParmas and BloodUIParmas.ShowLevel == false and CurrentWidget.bIsShowLevel and CurrentWidget.SetLevelText then
            CurrentWidget.bIsShowLevel = false
            CurrentWidget:SetLevelText(0)
        end

        self:AutoFitShieldAndBloodSize(false)
        if (IsValid(self.Owner)) then
            UIManager(self):AddWidgetComponentToList(self.Owner.Eid, "Billboard", self) 
        end
    end
    if IsSync then
        self:SetWidgetClassByBpPath(Path)
        AfterLoad()
    else
        local WorldContext = GWorld.GameInstance
        self:SetWidgetClassByPathAsync(WorldContext,Path,{self,AfterLoad})
    end
end

function BP_CharBillboard_C:RefreshItemsInfoByAction(ActionName)
    if (not IsValid(self.Owner)) then
        return
    end
    -- 刷新Items血条
    local CurrentWidget = self:GetUserWidgetObject()
    if (CurrentWidget == nil) then
        return
    end
    self.LastAttackTimeStamp = UE4.UGameplayStatics.GetTimeSeconds(self)
    self:ResetForceShowState()
    self:AutoFitShieldAndBloodSize()
    if (not self:IsExistTimer("UpdateCharBillboardInfo")) then
        self:AddTimer(1.0, self.UpdateCharBillboardInfo, true, 0, "UpdateCharBillboardInfo") 
    end
end

function BP_CharBillboard_C:InitBossPlaceBillBoard(Owner, TypeStr,IsSync)
    -- 初始化Boss的部位Billboard
    self.Owner = Owner
    self.TypeStr = TypeStr
    local Path = "WidgetBlueprint'/Game/UI/WBP/Battle/Widget/HUD_Bar/WBP_Battle_BossPlaceBar.WBP_Battle_BossPlaceBar_C'"

    local AfterLoad = function()

        if not IsSync then
            if self:GetUserWidgetObject() ~= nil then
                return
            end
            local WorldContext = GWorld.GameInstance
            self:SetWidgetAfterAsyncLoad(WorldContext,Path)
        end

        local CurrentWidget = self:GetUserWidgetObject()
        if (CurrentWidget == nil) then
            return
        end
        self.IsInit = true
        local Location = self.Owner.JumpWordLocSocket:GetRelativeTransform().Translation
        self:K2_SetRelativeLocation(Location, false, nil, false)
        CurrentWidget:InitBossPlaceBlood(self.Owner)
        --self:AutoFitShieldAndBloodSize(false)
        --self:AddTimer(1.0, self.UpdateCharBillboardInfo, true, 0, "UpdateCharBillboardInfo")
        if (IsValid(self.Owner)) then
            UIManager(self):AddWidgetComponentToList(self.Owner.Eid, "Billboard", self) 
        end
    end

    if IsSync then
        self:SetWidgetClassByBpPath(Path)
        AfterLoad()
    else
        local WorldContext = GWorld.GameInstance
        self:SetWidgetClassByPathAsync(WorldContext,Path,{self,AfterLoad})
    end

end

-- function BP_CharBillboard_C:InitNpcBillBoard(Owner, TypeStr, StyleNodeName,IsSync)
--     if (not IsValid(Owner) or (Owner.IsSummonMonster and Owner:IsSummonMonster() and not Owner:IsSummonByMonster())) then
--         return
--     end
--     StyleNodeName = StyleNodeName or "Blood"
--     -- 初始化Npc的Billboard (目前用在友方召唤物上面)
--     if(self.Owner)then
--         self.Owner:UnregisterListenerOnBuffsChanged(self)
--     end
--     self.Owner = Owner
--     self.Owner:RegisterListenerOnBuffsChanged(self,self.OnBuffsChanged)
--     self.TypeStr = TypeStr
--     self.StyleNodeName = self:GetOwnerStyleNodeName() or  StyleNodeName
--     local Path = self:GetPathByStyleNodeName(self.StyleNodeName)

--     local AfterLoad = function()

--         if not IsSync then
--             if self:GetUserWidgetObject() ~= nil and not self.Owner.IsFromCache then
--                 return
--             end
--             local WorldContext = GWorld.GameInstance
--             self:SetWidgetAfterAsyncLoad(WorldContext,Path)
--         end

--         local CurrentWidget = self:GetUserWidgetObject()
--         if (CurrentWidget == nil) then
--             return
--         end
--         self.IsInit = true
--         local Height = self.Owner.Data.BillboardHeightOffset or 170
--         local Scale = self.Owner.RootComponent:K2_GetComponentScale().Z
--         if (self.Owner.CapsuleComponent) then
--             Height = self.Owner.CapsuleComponent:GetUnscaledCapsuleHalfHeight()
--         end
--         local HeightOffset = 0
--         if self.Owner.Data.BloodUIParmas then HeightOffset = self.Owner.Data.BloodUIParmas.HeightOffset or 0 end
--         Height = (Height+HeightOffset)/Scale
--         self:K2_SetRelativeLocation(UE4.FVector(0, 0, Height), false, nil, false)
--         --CurrentWidget:InitConfig(self.Owner, self.Owner:GetAttr("Level"), "Npc", StyleNodeName)
--         CurrentWidget:InitConfig(self.Owner,"Npc", StyleNodeName)
--         self:AddTimer(1.0, self.UpdateCharBillboardInfo, true, 0, "UpdateCharBillboardInfo")
--         if (IsValid(self.Owner)) then
--             UIManager(self):AddWidgetComponentToList(self.Owner.Eid, "Billboard", self) 
--         end
--     end

--     if IsSync then
--         self:SetWidgetClassByBpPath(Path)
--         AfterLoad()
--     else
--         local WorldContext = GWorld.GameInstance
--         self:SetWidgetClassByPathAsync(WorldContext,Path,{self, AfterLoad})
--     end
-- end

-- function BP_CharBillboard_C:GetCurScaleSize()
--     if (not self.IsOpenAutoAdapt) then
--         return 1.0
--     end
--     -- print(_G.LogTag, "BP_CharBillboard_C=GetCurScaleSize=", math.min(1, self.ScaleCoefficient.X / (self.lastDistance + 1) + self.ScaleCoefficient.Y))
--     local ScaleNum = math.min(1, self.ScaleCoefficient.X / (self.lastDistance + 1) + self.ScaleCoefficient.Y)
--     return FVector2D(ScaleNum, ScaleNum)
-- end

function BP_CharBillboard_C:CharOnRecovery()
    if self:IsPhantom() then 

    end
end

-- function BP_CharBillboard_C:CharOnDead()
--     if self.Owner and self.Owner:IsPhantom() then
--         if self.Owner.TeammateUI then
--             self.Owner.TeammateUI:OnDead()
--         end
--         self:RealCharOnDead()
--         return
--     end

--     if (not self:IsExistTimer("OnRealCharOnDead")) then
--         self:AddTimer(0.25, self.RealCharOnDead, false, 0, "OnRealCharOnDead") 
--     end
-- end

-- function BP_CharBillboard_C:RealCharOnDead()
--     local CurrentWidget = self:GetUserWidgetObject()
--     if (CurrentWidget == nil) then
--         return
--     end

--     -- 如果是魅影， 更换Billboard组件
--     -- if self.Owner:IsPhantom() then 
--     --     self:InitPhantomDeadBillBoard()
--     --     return
--     -- end

--     CurrentWidget:CharOnDead()
-- end

function BP_CharBillboard_C:PhantomOnDead()
    if self.Owner and self.Owner:IsPhantom() then
        if self.Owner.TeammateUI then
            self.Owner.TeammateUI:OnDead()
        end
        self:RealCharOnDead()
    end
end

function BP_CharBillboard_C:GetCharOwner()
    return self.Owner
end

-- function BP_CharBillboard_C:UpdateCharBillboardInfo()
--     local CurrentWidget = self:GetUserWidgetObject()
--     if (CurrentWidget == nil or not IsValid(self.Owner)) then
--         return
--     end

--     if (self.Owner.IsDead and self.Owner:IsDead()) then
--         if CurrentWidget.CheckIsShowByType and CurrentWidget:CheckIsShowByType(self.StyleNodeName) then
--             self.IsNotForceShow = true
--             self:RealHideByOutAnim(CurrentWidget)
--         end
--         return
--     end

--     local bIsAimed = self:IsExistTimer("ResetForceShowState")
--     if bIsAimed then
--         return
--     end

--     -- 检测血条是否需要隐藏
--     local NowTime = UE4.UGameplayStatics.GetTimeSeconds(self)
--     local IsShowNow = CurrentWidget:CheckIsShowByType()
--     if IsShowNow and self.LastAttackTimeStamp < 0 then
--         self.LastAttackTimeStamp = NowTime + self.HitStateLastTime
--     end
--     if ((self.TypeStr == "Monster" or self.TypeStr == "Npc" or self.TypeStr == "BreakableItems" ) and 
--     self.LastAttackTimeStamp > 0 and NowTime - self.LastAttackTimeStamp >= self.HitStateLastTime and IsShowNow) then
--         self.IsNotForceShow = true
--         self:RealHideByOutAnim(CurrentWidget)
--     else
--         self.IsNotForceShow = false
--     end
-- end

function BP_CharBillboard_C:IsBillboardShow() -- 没人在用
    local CurrentWidget = self:GetUserWidgetObject()
    if (CurrentWidget == nil or self.StyleNodeName == nil) then
        return false
    end
    return CurrentWidget:CheckIsShowByType(self.StyleNodeName)
end

-- function BP_CharBillboard_C:GetCharLocation()
--     if (self.Owner == nil) then
--         return UE4.FVector(0, 0, 0)
--     end
--     return self.Owner:K2_GetActorLocation()
-- end

function BP_CharBillboard_C:TryToShowOrHideBillBoardByShoot_Lua(IsShow)
    -- 是否显示Billboard，用于瞄准显示
    local CurrentWidget = self:GetUserWidgetObject()
    if (CurrentWidget == nil or not IsValid(self.Owner) or self.StyleNodeName == nil  or self.TypeStr == "BossPlace") then
        return
    end
    if (self.Owner.IsDead and self.Owner:IsDead() or not GMVariable.EnableShowBillboard) then
        return
    end
    self.IsNotForceShow = not IsShow
    if (IsShow) then
        local Animation = CurrentWidget.ShowProgressBar or CurrentWidget.InAnimation
        if (not CurrentWidget:CheckIsShowByType(self.StyleNodeName) and not CurrentWidget:IsAnimationPlaying(Animation)) then
            -- print(_G.LogTag, "TryToShowOrHideBillBoard", CurrentWidget.MonsterInfo:GetRenderOpacity(), CurrentWidget:GetRenderOpacity(), CurrentWidget.RootWidget:GetRenderOpacity())
            CurrentWidget:PlayAnimationForward(Animation)
            CurrentWidget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            -- self:AutoFitShieldAndBloodSize(false)
        end
        if (self.IsExistTimer("ResetForceShowState")) then
            self:RemoveTimer("ResetForceShowState")
        end
        if self.Owner.BlockTickLod_MoveComp then
            self.Owner:BlockTickLod_MoveComp(true, Const.BlockTickLodTag.CharBillboard)
        end
        self:AddTimer(0.3, self.ResetForceShowState, false, 0, "ResetForceShowState")

        -- if CurrentWidget.ShowOrHideName then
        --     CurrentWidget:ShowOrHideName(true)
        --     if self:IsExistTimer("WaitToHideName") then
        --        self:RemoveTimer("WaitToHideName")
        --     end
        --     if not EMCache:Get("ShowMonsterName") then
        --         self:AddTimer(0.1,function ()
        --             CurrentWidget:ShowOrHideName(false)
        --             end
        --             ,false,0,"WaitToHideName")
        --     end
        -- end

    else
        local Animation = CurrentWidget.out or CurrentWidget.OutAnimation
        if (CurrentWidget:CheckIsShowByType(self.StyleNodeName) and not CurrentWidget:IsAnimationPlaying(Animation)) then
            CurrentWidget:PlayAnimationForward(Animation)
        end
    end
end

-- function BP_CharBillboard_C:ResetForceShowState()
--     local CurrentWidget = self:GetUserWidgetObject()
--     if (CurrentWidget == nil) then
--         return
--     end
--     -- if not CurrentWidget:CheckIsShowByType(self.StyleNodeName) then
--     --     return
--     -- end
--     local NowTime = UE4.UGameplayStatics.GetTimeSeconds(self)
--     if (NowTime - self.LastAttackTimeStamp >= self.HitStateLastTime) then
--         self.IsNotForceShow = true
--         self:RealHideByOutAnim(CurrentWidget)
--     else
--         self.IsNotForceShow = false
--     end
--     -- local PointDistance = UE4.UKismetMathLibrary.Vector_Distance(self.Owner:K2_GetActorLocation(), self.LastShootPosition) / 100.0
--     -- if (PointDistance > 5) then
--     --     self.IsNotForceShow = true
--     --     -- self.LastShootPosition = self.Owner:K2_GetActorLocation()
--     -- end
-- end

-- function BP_CharBillboard_C:RealHideByOutAnim(WidgetIns)
--     local Animation =  WidgetIns.OutAnimation or self:GetAnimationInfoByName("out")
--     if (not WidgetIns:IsAnimationPlaying(Animation)) then
--         local function PlayAnimFinished()
--             self.LastAttackTimeStamp = -1.0
--         end
--         WidgetIns:BindToAnimationFinished(Animation, {self, PlayAnimFinished})
--         WidgetIns:PlayAnimationForward(Animation)
--         if ((IsValid(self.Owner)) and self.Owner.BlockTickLod_MoveComp) then
--             self.Owner:BlockTickLod_MoveComp(false, Const.BlockTickLodTag.CharBillboard) 
--         end
--     end
-- end

function BP_CharBillboard_C:GetOwnerType()
    return self.TypeStr
end

function BP_CharBillboard_C:RefreshInvincibleState(Invincible)
    --DebugPrint("gmy@RefreshInvincibleState", self.bIsInvincible)
    if not IsValid(self.Owner) then
        return
    end
    local CurrentWidget = self:GetCurrentWidget()
    if (CurrentWidget ~= nil and CurrentWidget.RefreshInvincibleState) then
        CurrentWidget:RefreshInvincibleState()
    end
end

-- function BP_CharBillboard_C:OnDamaged(ActionName,DamageEvnt)
--     local CurrentWidget = self:GetUserWidgetObject()
--     if (CurrentWidget ~= nil and CurrentWidget.OnDamage) then
--         CurrentWidget:OnDamage(ActionName,DamageEvnt)
--     end
-- end

function BP_CharBillboard_C:SetBuffPanelVisibilityByConfig()
    local CurrentWidget = self:GetUserWidgetObject()
    if not CurrentWidget then return end
    local Config_ShowBuffEnemy = EMCache:Get("ShowBuffEnemy")
    local Config_ShowBuffFriend = EMCache:Get("ShowBuffFriend")
    if Config_ShowBuffEnemy == nil then Config_ShowBuffEnemy = true end
    if Config_ShowBuffFriend == nil then Config_ShowBuffFriend = true end
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if not (self.Owner and PlayerCharacter) then return end
    local IsEnemy = self.Owner:IsEnemy(PlayerCharacter)
    local IsFriend = self.Owner:IsFriend(PlayerCharacter)

    if ((not Config_ShowBuffEnemy) and IsEnemy) or ((not Config_ShowBuffFriend) and IsFriend) then
        CurrentWidget:SetCharBuffUIVisibility(false)
    else
        CurrentWidget:SetCharBuffUIVisibility(true)
    end
end

---------------------------------- buff SpecialEffect -------------------------------------------

function BP_CharBillboard_C:BuffChange_SpecialEffect(HotUI,Invisible,InvincibleUI)
    if not IsValid(self.Owner) then
        return
    end
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if self.Owner:IsMainPlayer() then
        if UIManager then
            local BattleMainUI = UIManager:GetUI("BattleMain")
            if BattleMainUI and BattleMainUI.PlayerBloodBar then
                BattleMainUI.PlayerBloodBar:UpdateCharHotUIState(HotUI)
                BattleMainUI.PlayerBloodBar:BuffSpecialEffect_InvincibleUI(InvincibleUI)
            end
        end
    end

    if self.Owner.IsHostage and UIManager:GetUIObj("DungeonRescueFloat") then
        UIManager:GetUIObj("DungeonRescueFloat"):SetInvincibility(InvincibleUI)
    end

    local CurrentWidget = self:GetCurrentWidget()
    if not CurrentWidget then return end

    if CurrentWidget.RefreshInvisibleState then
        CurrentWidget:RefreshInvisibleState(Invisible)
    end
    if CurrentWidget.BuffSpecialEffect_InvincibleUI then
        CurrentWidget:BuffSpecialEffect_InvincibleUI(InvincibleUI)
    end

    if self.Owner.TeammateUI then
        self.Owner.TeammateUI:BuffSpecialEffect_InvincibleUI(CurrentWidget.bIsInvincibleNow)
        self.Owner.TeammateUI:UpdateCharHotUIState(HotUI)
    end

end

-- 角色和魅影的无敌UI由BuffSpecialEffect的InvincibleUI控制
function BP_CharBillboard_C:BuffSpecialEffect_InvincibleUI(IsShow)

    if not IsValid(self.Owner) then
        return
    end

    if not self.Owner:IsPhantom() and not self.Owner:IsPlayer() then
        return
    end

    local UIManager = UIManager(self)
    if not UIManager then
        return
    end

    local CurrentWidget = self:GetUserWidgetObject()
    if CurrentWidget and CurrentWidget.BuffSpecialEffect_InvincibleUI then
        CurrentWidget:BuffSpecialEffect_InvincibleUI(IsShow)
    end

    if self.Owner:IsMainPlayer() then
        local BattleMain = UIManager:GetUIObj("BattleMain")
        if BattleMain and BattleMain.PlayerBloodBar then
            BattleMain.PlayerBloodBar:BuffSpecialEffect_InvincibleUI(IsShow)
        end
    end

    if self.Owner.TeammateUI then
        self.Owner.TeammateUI:BuffSpecialEffect_InvincibleUI(IsShow)
    end

end

---------------------------------- buff SpecialEffect -------------------------------------------

function BP_CharBillboard_C:OnBuffChange_Weakness()
    local CurrentWidget = self:GetCurrentWidget()
    if CurrentWidget and CurrentWidget.RefreshWeaknessIcons then
        CurrentWidget:RefreshWeaknessIcons()
    end
end

function BP_CharBillboard_C:OnBuffChange_LockHp(bIsLock,Value,Percent)
    if not self.Owner then
        return
    end

    local UIManager = UIManager(self)
    if not UIManager then
        return
    end

    if self.Owner:IsBossMonster() then
        local BossBloodUI = self.Owner.BossBloodUI
        if BossBloodUI then
            BossBloodUI:SetBossLockHpState(bIsLock,Value,Percent)
        end
        return
    end

    local CurrentWidget = self:GetCurrentWidget()
    if self.Owner:IsMainPlayer() then
       CurrentWidget = UIManager:GetUIObj("BattleMain").PlayerBloodBar
    end
    if not CurrentWidget then return end

    if CurrentWidget.SetLockHpBuff then
        CurrentWidget:SetLockHpBuff(bIsLock,Value,Percent)
    end

    if self.Owner.TeammateUI then
        self.Owner.TeammateUI:SetInvincible(CurrentWidget.bIsInvincibleNow)
    end

end

-- function BP_CharBillboard_C:GetPathByStyleNodeName(StyleNodeName)
--     if StyleNodeName == "TN" then
--         self.bUpdateES = false
--         self.bUpdateHP = false
--         self.bUpdateTN = true
--         return "WidgetBlueprint'/Game/UI/WBP/Battle/Widget/HUD_Bar/WBP_HUD_ToughnessBar.WBP_HUD_ToughnessBar_C'"
--     else
--         return "WidgetBlueprint'/Game/UI/UI_PC/Battle/HUD_Bar/HUD_MonsterBar.HUD_MonsterBar_C'"
--     end
-- end

function BP_CharBillboard_C:GetOwnerStyleNodeName()
    if not IsValid(self.Owner) then
        return
    end
    if self.Owner.Data and self.Owner.Data.BloodUIParmas and self.Owner.Data.BloodUIParmas.UIStyleNodeName then
        return self.Owner.Data.BloodUIParmas.UIStyleNodeName
    end
end

-- function BP_CharBillboard_C:CheckCanUpdate(UpdateType)
--     return ( UpdateType == EBillboardUpdateType.UpdateHP and self.bUpdateHP ) or 
--             (UpdateType == EBillboardUpdateType.UpdateES and self.bUpdateES)  or
--             (UpdateType == EBillboardUpdateType.UpdateTN and self.bUpdateTN)
-- end

return BP_CharBillboard_C
