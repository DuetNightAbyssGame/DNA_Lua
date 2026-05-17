require "UnLua"

---@type AExploreStaticCreator
local M = Class("BluePrints.Common.TimerMgr")
local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
local TaskUtils = require("BluePrints.UI.TaskPanel.TaskUtils")
-- ---@param InStatus EExploreGroupStatus
-- function M:CheckCanChangeStatus(InStatus)
--     local bRet = self.Overridden.CheckCanChangeStatus(self, InStatus)
--     if not bRet then
--         return false
--     end
--     return true
-- end

function M:ReceiveEndPlay(Respon)
    self.Overridden.ReceiveEndPlay(self, Respon)
    self:CleanTimer()
end

function M:IsInBigWorld()
    local Avatar = GWorld:GetAvatar()
    if not Avatar or self.IsInWC then
        return false
    end
    return Avatar:IsRealInBigWorld()
end

function M:TryDeactive()
    for i, v in pairs(self.StaticCreatorMap) do
        v:RegionDestroyAllExploreGroupData(false, EDeathReason.NoReason, EDestroyReason.RegionExploreGroup, true)
    end
end

function M:TryActive()
    if self.ExploreGroupId == 7070035 then
        print(_G.LogTag,"LXZ TryActive", self.ExploreGroupId)
    end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local SubRegionId = GameMode:GetRegionIdByLocation(self:K2_GetActorLocation())
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        print(_G.LogTag,"LXZ TryActive???", self.ExploreGroupId)
        Avatar:ExploreIdActive(self.ExploreGroupId, SubRegionId)
    end
end

function M:TryCompleteLimit()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:ExploreIdCompleteLimit(self.ExploreGroupId)
    end
end

function M:TryComplete()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:ExploreIdComplete(self.ExploreGroupId, true)
    end
end

function M:TrySpecialActive()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:SetExploreSpecialActiveState(self.ExploreGroupId)
    end
end

function M:AddRemainLimitTime(AddTime, MobileAddTime)
    local RealAddTime = AddTime
    if CommonUtils.GetRuntimePlatform(self) == "Mobile" then
        RealAddTime = MobileAddTime
    end
    if RealAddTime == 0 then
        return
    end
    self.RemainLimitTime = self.RemainLimitTime + RealAddTime
    local TimeItem = UIManager(self):GetUIObj("DungeonCaptureFloat")
    if TimeItem then
        TimeItem:AddRemainingTime(RealAddTime)
    end
end

function M:ReceiveOnExploreGroupReset()
    local Components = self:K2_GetComponentsByClass(UExploreSplineComponent:StaticClass())
    if Components then
        for _, SplineComponent in pairs(Components) do
            SplineComponent:ResetSpline()
        end
    end
    self.Overridden.ReceiveOnExploreGroupReset(self)
end

function M:ReceiveOnExploreGroupResetUI(bShowToast)
    print(_G.LogTag,"LXZ ReceiveOnExploreGroupResetUI", bShowToast)
    Traceback()
    EventManager:RemoveEvent(EventID.CharDie, self)
    local TimeItem = UIManager(self):GetUIObj("DungeonCaptureFloat")
    if TimeItem and TimeItem.SelfActor and TimeItem.AnotherActor then
        TimeItem:RemainingDistance(TimeItem.SelfActor, TimeItem.AnotherActor)
    else
        if bShowToast then
            UIManager(self):UnLoadUI("DungeonCaptureFloat")
        end
    end
    
    if CommonUtils.GetRuntimePlatform(self) == "PC" then
        local BattleMain = UIManager(self):GetUIObj("BattleMain")
        if BattleMain then
            local DynamicEventUI = BattleMain:GetOrAddDynamicEventWidget()
            DynamicEventUI:StopListeningForInputAction("QuitChallenge", EInputEvent.IE_Pressed)
        end
    end

    local DynamicEventIndicator = UIManager(self):GetUIObj("DynamicEventIndicator")
    if DynamicEventIndicator ~= nil then
        DynamicEventIndicator.Main:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    if self.IsHideWorldTask then
        ---@type Battle_PC_C
        local BattleMain = UIManager(self):GetUIObj("BattleMain")
        if BattleMain then
            -- BattleMain.VB_View:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            local DynamicEventUI = BattleMain:GetOrAddDynamicEventWidget()
            local Avatar = GWorld:GetAvatar()
            if not Avatar then
                return
            end
            DynamicEventUI:PlayAnimation(DynamicEventUI.Challenge_Out)
            DynamicEventUI:AddTimer(1.0,function()
                DynamicEventUI:RemoveTimer("DelayTitleUnfold")
                if ClientEventUtils:GetCurrentDoingDynamicEvent() then
                    DynamicEventUI:PlayAnimation(DynamicEventUI.In)
                end
                if DynamicEventUI:IsListeningForInputAction("QuitChallenge") then
                    DynamicEventUI:StopListeningForInputAction("QuitChallenge", EInputEvent.IE_Pressed)
                end
                if DynamicEventUI.ExplorationChallenge:IsListeningForInputAction("ExploraChallengeQuitL") then
                    DynamicEventUI.ExplorationChallenge:StopListeningForInputAction("ExploraChallengeQuitL", EInputEvent.IE_Pressed)
                    DynamicEventUI.ExplorationChallenge:StopListeningForInputAction("ExploraChallengeQuitL", EInputEvent.IE_Released)
                end
                if DynamicEventUI.ExplorationChallenge:IsListeningForInputAction("ExploraChallengeQuitR") then
                    DynamicEventUI.ExplorationChallenge:StopListeningForInputAction("ExploraChallengeQuitR", EInputEvent.IE_Pressed)
                    DynamicEventUI.ExplorationChallenge:StopListeningForInputAction("ExploraChallengeQuitR", EInputEvent.IE_Released)
                end
                if BattleMain ~= nil and BattleMain.Pos_TaskBar ~= nil and BattleMain.Pos_TaskBar:GetChildrenCount() ~= 0 then
                    local TrackingQuestChain = Avatar.TrackingQuestChainId
                    local TaskBarWidget = BattleMain.Pos_TaskBar:GetChildAt(0)
                    if TaskBarWidget ~= nil then
                        if TrackingQuestChain ~= 0 then
                            --TaskBarWidget.Title:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                            if CommonUtils.GetRuntimePlatform(self) == "PC" then
                                TaskBarWidget.Tips:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                            else
                                TaskBarWidget.Tips:SetVisibility(ESlateVisibility.Collapsed)
                            end
                            if TaskBarWidget.VBox_SubTasks:GetChildrenCount() > 0 then
                                TaskBarWidget.VBox_SubTasks:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                            end
                        end
                        TaskBarWidget.IsInExplore = false
                        if CommonUtils.GetRuntimePlatform(self) == "PC" then
                            TaskBarWidget:PlayAnimation(TaskBarWidget.Tooltip_In)
                        end                   
                    end
                end
            end, false, 0, "DelayTitleUnfold", false)
            self.IsHideWorldTask = false
        end
    end
end

function M:GMReceiveOnExploreGroupResetUI()
    if self.LimitTime ~= nil and self.LimitTime > 0 then
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        GameState.ActiveLimitTimeExploreGroup = 0
    end
    local LoadingUI = GWorld.GameInstance:GetLoadingUI()
    if not LoadingUI then
        UIManager(self):LoadUINew("ExploreToastFail","UI_LIMITEXPLORE_FAIL")
    end
    self:ReceiveOnExploreGroupResetUI()
end

function M:ReceiveOnExploreGroupSuccess(bShowToast)
    self:UpdateExploreData("bGroupInLimit", false)
    self:CleanDelayActions()

    local UIObjs = MissionIndicatorManager:GetIndicatorUIObjBySTLType("Dynamic")
    if not IsEmptyTable(UIObjs) then
        for _, UI in pairs(UIObjs) do
            if UI then
                UI:Show("ExploreLimit")
            end
        end
    end

    if self.LimitTime ~= nil and self.LimitTime > 0 then
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        GameState.ActiveLimitTimeExploreGroup = 0
    end

    self.Overridden.ReceiveOnExploreGroupSuccess(self, bShowToast)
    --加载 挑战成功Toast
    local LoadingUI = GWorld.GameInstance:GetLoadingUI()
    if not LoadingUI and bShowToast then
        UIManager(self):LoadUINew("ExploreToastSuccess","UI_LIMITEXPLORE_SUCCESS")
    end
    self:ReceiveOnExploreGroupResetUI(bShowToast)

end

function M:ReceiveOnExploreGroupFailed()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:ResetingExplore(self.ExploreGroupId, self.RegionId)
    end
    self:CleanTimer()
    self:CleanDelayActions()

    local UIObjs = MissionIndicatorManager:GetIndicatorUIObjBySTLType("Dynamic")
    if not IsEmptyTable(UIObjs) then
        for _, UI in pairs(UIObjs) do
            if UI then
                UI:Show("ExploreLimit")
            end
        end
    end

    if self.LimitTime ~= nil and self.LimitTime > 0 then
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        GameState.ActiveLimitTimeExploreGroup = 0
    end
    self.Overridden.ReceiveOnExploreGroupFailed(self)

    --加载 挑战失败Toast
    local LoadingUI = GWorld.GameInstance:GetLoadingUI()
    if not LoadingUI then
        UIManager(self):LoadUINew("ExploreToastFail", "UI_LIMITEXPLORE_FAIL")
    end
    self:ReceiveOnExploreGroupResetUI(true)


end

function M:ReceiveOnExploreLimitStarted(Title, Des, TotalTargetNum)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameState.ActiveLimitTimeExploreGroup ~= 0 then
        --已有挑战类在进行时，理论上开启机关不能被交互，但防止以后有奇怪的入口，在这里额外隔离一次
        print(_G.LogTag,"LXZ TryActive LimitTimeExploreGroup", self.ExploreGroupId, "Failed,", GameState.ActiveLimitTimeExploreGroup, "Has Actived")
        return
    end
    GameState.ActiveLimitTimeExploreGroup = self.ExploreGroupId;
    self:UpdateExploreData("bGroupInLimit", true)
    -- 加载 挑战开始Toast
    UIManager(self):LoadUINew("ExploreToastTips", "UI_LIMITEXPLORE_START")

    -- 加载 倒计时(确保加载成功)
    local TimeItem = UIManager(self):GetUIObj("DungeonCaptureFloat")
    if TimeItem then
        TimeItem:OnLoaded(self.RemainLimitTime,DataMgr.GlobalConstant.ExploreCountdownPoint.ConstantValue, false, "Explore")
    else
        TimeItem = UIManager(self):LoadUINew("DungeonCaptureFloat",self.RemainLimitTime,DataMgr.GlobalConstant.ExploreCountdownPoint.ConstantValue, false, "Explore")
    end

    if TimeItem and TimeItem.SelfActor and TimeItem.AnotherActor then
        TimeItem:PauseRemainingDistance()
    end
    if TimeItem then
        TimeItem.TaskTitle:SetText(GText("UI_LIMITEXPLORE_TIME"))
        TimeItem:UIStateChange_OnTarget()
        -- 移动端放弃按钮已整合到左侧探索组挑战详情中
        -- if CommonUtils.GetRuntimePlatform(self) == "Mobile" then
        --     TimeItem.Group_BtnCancel:SetVisibility(ESlateVisibility.Visible)
        --     TimeItem.Btn_Cancel:BindEventOnClicked(self, self.OnPressQuitChallenge)
        -- end
    end

    -- 加载 开始任务提示
    self.IsHideWorldTask = false
    if Title ~= "" or Des ~= "" then
        self.IsHideWorldTask = true
        -- 隐藏主任务
        ---@type Battle_PC_C
        -- local BattleMain = UIManager(self):GetUIObj("BattleMain")
        -- if BattleMain then
        --     BattleMain.VB_View:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        --     -- BattleMain.Pos_TaskBar:GetChildAt(0):SetVisibility(ESlateVisibility.Collapsed)
        -- end

        local UIObjs = MissionIndicatorManager:GetIndicatorUIObjBySTLType("Dynamic")
        if not IsEmptyTable(UIObjs) then
            for _, UI in pairs(UIObjs) do
                if UI then
                    UI:Hide("ExploreLimit")
                end
            end
        end

        if not self:ShowExploreTaskPanel(Title, Des, TotalTargetNum) then
            self:AddTimer(0.1, self.ShowExploreTaskPanel, true, 0, "ShowExploreTaskPanelBindToTimer", false, Title, Des, TotalTargetNum)
        end
    end
    
    --玩家死亡探索组自动失败
    EventManager:AddEvent(EventID.CharDie, self, self.OnCharDie)

    self.Overridden.ReceiveOnExploreLimitStarted(self, Title, Des, TotalTargetNum)
end

function M:UpdateLimitUI(CurrentTargetNum)
    local BattleMain = UIManager(self):GetUIObj("BattleMain")
    local DynamicEventIndicator = UIManager(self):GetUIObj("DynamicEventIndicator")
    if DynamicEventIndicator ~= nil then
        DynamicEventIndicator.Main:SetVisibility(ESlateVisibility.Collapsed)
    end
    if BattleMain then
        local DynamicEventUI = BattleMain:GetOrAddDynamicEventWidget()
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            return false
        end
        DynamicEventUI.ExplorationChallenge.Text_Now:SetText(CurrentTargetNum)
    end
end

-- 加载探索任务提示(确保加载成功)
function M:ShowExploreTaskPanel(Title, Des, TotalTargetNum)
    local BattleMain = UIManager(self):GetUIObj("BattleMain")
    local DynamicEventIndicator = UIManager(self):GetUIObj("DynamicEventIndicator")
    if DynamicEventIndicator ~= nil then
        DynamicEventIndicator.Main:SetVisibility(ESlateVisibility.Collapsed)
    end
    if BattleMain then
        local DynamicEventUI = BattleMain:GetOrAddDynamicEventWidget()
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            return false
        end
        if  BattleMain ~= nil and BattleMain.Pos_TaskBar ~= nil and BattleMain.Pos_TaskBar:GetChildrenCount() ~= 0 then
            local TrackingQuestChain = Avatar.TrackingQuestChainId
            local TaskBarWidget = BattleMain.Pos_TaskBar:GetChildAt(0)
            if TaskBarWidget ~= nil then
                if TrackingQuestChain ~= 0 then
                    --TaskBarWidget.Title:SetVisibility(ESlateVisibility.Collapsed)
                    if CommonUtils.GetRuntimePlatform(self) == "PC" then

                    else
                        TaskBarWidget.Tips:SetVisibility(ESlateVisibility.Collapsed)
                    end
                    if TaskBarWidget.VBox_SubTasks:GetChildrenCount() > 0 then
                        TaskBarWidget.VBox_SubTasks:SetVisibility(ESlateVisibility.Collapsed)
                    end
                end
                TaskBarWidget.IsInExplore = true
                if CommonUtils.GetRuntimePlatform(self) == "PC" then
                    TaskBarWidget:PlayAnimation(TaskBarWidget.Tooltip_Out)
                end
                
            end
        end
        DynamicEventUI:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        DynamicEventUI.DynamicEvent:SetVisibility(ESlateVisibility.Collapsed)
        DynamicEventUI:PlayAnimation(DynamicEventUI.Challenge_In)
        if ClientEventUtils:GetCurrentDoingDynamicEvent() then
            DynamicEventUI:PlayAnimation(DynamicEventUI.Out)
        end
        DynamicEventUI.ExplorationChallenge.Text_Name:SetText(GText(Des))
        DynamicEventUI.ExplorationChallenge.Text_TaskName:SetText(GText(Title))
        DynamicEventUI.ExplorationChallenge:SetQuitButtonByInputDevice(UIUtils.UtilsGetCurrentInputType())
        DynamicEventUI.ExplorationChallenge.Text_Tips01:SetVisibility(ESlateVisibility.Collapsed)
        DynamicEventUI.ExplorationChallenge.Text_Tips02:SetText(GText("UI_Esc_Challenge"))
        if TotalTargetNum and TotalTargetNum > 0 then
            DynamicEventUI.ExplorationChallenge.Panel_Progress:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            DynamicEventUI.ExplorationChallenge.Text_Total:SetText(TotalTargetNum)
        else
            DynamicEventUI.ExplorationChallenge.Panel_Progress:SetVisibility(ESlateVisibility.Collapsed)
        end
        if CommonUtils.GetRuntimePlatform(self) == "PC" then
            DynamicEventUI:ListenForInputAction("QuitChallenge", EInputEvent.IE_Pressed, true, {self, self.OnPressQuitChallenge})
            DynamicEventUI.ExplorationChallenge:ListenForInputAction("ExploraChallengeQuitL", EInputEvent.IE_Pressed, true, {self, self.OnPadActiveGuidePress})
            DynamicEventUI.ExplorationChallenge:ListenForInputAction("ExploraChallengeQuitR", EInputEvent.IE_Pressed, true, {self, self.OnPadExploraChallengeQuitPress})
            DynamicEventUI.ExplorationChallenge:ListenForInputAction("ExploraChallengeQuitL", EInputEvent.IE_Released, true, {self, self.OnPadActiveGuideRelease})
            DynamicEventUI.ExplorationChallenge:ListenForInputAction("ExploraChallengeQuitR", EInputEvent.IE_Released, true, {self, self.OnPadExploraChallengeQuitRelease})
        end
        if CommonUtils.GetRuntimePlatform(self) == "Mobile" then
            DynamicEventUI.ExplorationChallenge.Panel_Tips:SetVisibility(ESlateVisibility.Collapsed)
            -- 显示移动端放弃按钮
            if DynamicEventUI.ExplorationChallenge.Panel_Tips2 and DynamicEventUI.ExplorationChallenge.WBP_Btn_Tips3 then
                DynamicEventUI.ExplorationChallenge.Panel_Tips2:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                DynamicEventUI.ExplorationChallenge.WBP_Btn_Tips3:BindEventOnClicked(self, self.OnPressQuitChallenge)
                DynamicEventUI.ExplorationChallenge.WBP_Btn_Tips3:SetText(GText("UI_Esc_Challenge"))
            end
        end
        self:RemoveTimer("ShowExploreTaskPanelBindToTimer")
        return true
    end

    return false
end

function M:OnPressQuitChallenge()
    local Params = {}
    Params.RightCallbackFunction = function(Data) 
        if CommonUtils.GetRuntimePlatform(self) == "PC" then
            local BattleMain = UIManager(self):GetUIObj("BattleMain")
            if BattleMain then
                local DynamicEventUI = BattleMain:GetOrAddDynamicEventWidget()
                DynamicEventUI:StopListeningForInputAction("QuitChallenge", EInputEvent.IE_Pressed)
            end
        end
        self:FailLimitExplore()
    end
    UIManager(self):ShowCommonPopupUI(100096, Params)
end

function M:OnPadActiveGuidePress()
    DebugPrint("LHQ@@@LS Press")
    self.IsLSPress = true
    if self.IsLSPress and self.IsRSPress then
        local Params = {}
        Params.RightCallbackFunction = function(Data) 
            if CommonUtils.GetRuntimePlatform(self) == "PC" then
                local BattleMain = UIManager(self):GetUIObj("BattleMain")
                if BattleMain then
                    local DynamicEventUI = BattleMain:GetOrAddDynamicEventWidget()
                    DynamicEventUI:StopListeningForInputAction("QuitChallenge", EInputEvent.IE_Pressed)
                end
            end
            self:FailLimitExplore()
        end
        UIManager(self):ShowCommonPopupUI(100096, Params)
    end
end

function M:OnPadExploraChallengeQuitPress()
    self.IsRSPress = true
    if self.IsLSPress and self.IsRSPress then
        local Params = {}
        Params.RightCallbackFunction = function(Data) 
            if CommonUtils.GetRuntimePlatform(self) == "PC" then
                local BattleMain = UIManager(self):GetUIObj("BattleMain")
                if BattleMain then
                    local DynamicEventUI = BattleMain:GetOrAddDynamicEventWidget()
                    DynamicEventUI:StopListeningForInputAction("QuitChallenge", EInputEvent.IE_Pressed)
                end
            end
            self:FailLimitExplore()
        end
        UIManager(self):ShowCommonPopupUI(100096, Params)
    end
end

function M:OnPadActiveGuideRelease()
    self.IsLSPress = false
end

function M:OnPadExploraChallengeQuitRelease()
    self.IsRSPress = false
end

function M:ActiveGuideIcon_Lua(Eid)
    local Entity = Battle(self):GetEntity(Eid)
    if Entity and Entity.ActiveGuide then
        Entity:ActiveGuide("Add")
    end
end

function M:DeactiveGuideIcon_Lua(Eid)
    local Entity = Battle(self):GetEntity(Eid)
    if Entity and Entity.ActiveGuide then
        Entity:DeactiveGuide()
    end
end

function M:UpdateExploreData(DataKey, DataValue)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    Avatar:UpdateExploreData(self.ExploreGroupId, DataKey, DataValue)
end

function M:SetChallengeState(ExitChallenge)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    if not ExitChallenge then
        Avatar:SetState2InExploreChanllenge(self.ExploreGroupId)
    else
        Avatar:ExitState2InExploreChanllenge(self.ExploreGroupId)
    end
end

function M:SetPlayerToTransform(Transform)
    if Transform.Translation.x == 0 and Transform.Translation.y == 0 and Transform.Translation.z == 0 then
        return
    end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    --移动角色
	Player:K2_SetActorTransform(Transform, false, nil, false)

	Player:EnableCheckOverlapPush({})

	Player:StartCameraFade()
    
	Player:GetController():SetControlRotation(Player:K2_GetActorRotation())
	Player:Landed()
end

function M:ResetCompletedExploreGroup()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameState.ActiveLimitTimeExploreGroup == self.ExploreGroupId then
        self:GMReceiveOnExploreGroupResetUI()
    end
    self:TryDeactive()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:ResetingExplore(self.ExploreGroupId, self.RegionId)
    end
end

function M:ShowRewardUI(TotalReward)
    if not TotalReward or not next(TotalReward) then
        return
    end
    local List = {}
    for Types, Table in pairs(TotalReward) do
        local Type = Types
        Type = string.match(Type, "^(.*)s$") or Type
        for Id, v in pairs(Table) do
            local Count = 0
            for SourceType, Num in pairs(v) do
                Count = Count + Num
            end
            table.insert(List, {
                ItemId = Id,
                ItemType = Type,
                Count = Count,
                Rarity = ItemUtils.GetItemRarity(Id, Type),
            })
        end
    end
    UIUtils.ShowHudReward(GText("UI_COMMON_REWARD"), List)
    -- local ResourceId = DataMgr.Fish[FishId].ResourceId
    -- UIUtils.ShowHudReward(GText("UI_Fishing_Reward"), {{
    --     ItemType = "Resource",
    --     ItemId = ResourceId,
    --     Count = 1,
    --     Rarity = ItemUtils.GetItemRarity(ResourceId, "Resource")
    -- }})
end

--踩石块探索组专用
function M:BPSetStoneCanTouch(CreatorId, bCanTouch)
    local Creator = self.StaticCreatorMap:Find(CreatorId)
    if not Creator or Creator.ChildEids:Length() == 0 then
        return
    end
    local Mechanism = Battle(self):GetEntity(Creator.ChildEids[1])
    if not Mechanism or Mechanism:GetUnitRealType() ~= "OrderedStone" then
        return
    end
    Mechanism.bCanTouch = bCanTouch
end

function M:BPSetStoneShowEndCallback(CreatorId)
    local Creator = self.StaticCreatorMap:Find(CreatorId)
    if not Creator or Creator.ChildEids:Length() == 0 then
        return
    end
    local Mechanism = Battle(self):GetEntity(Creator.ChildEids[1])
    if not Mechanism or Mechanism:GetUnitRealType() ~= "OrderedStone" then
        return
    end
    local Callback = function() 
        self:OnStoneShowEnd(CreatorId) 
    end
    Mechanism.ShowEndCallback = Callback
end

function M:TriggerTransferPlayer(TargetTransform, BlackScreenTime)
    local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
    Player:K2_SetActorLocation(TargetTransform.Translation, false, nil, false)
	Player:K2_SetActorRotation(TargetTransform.Rotation:ToRotator(), false)
    Player:GetMovementComponent():ForceClientUpdate()

	Player:EnableCheckOverlapPush({})
    Player:ShowBlackScreenFade_StandAlone("Black", BlackScreenTime)
    Player:GetController():SetControlRotation(Player:K2_GetActorRotation())
	Player:Landed()
end

function M:BindExploreSpline(StaticCreator, SplineComponent)
    if not SplineComponent then return end
    if not StaticCreator or StaticCreator.ChildEids:Length() == 0 then
        return
    end
    local Mechanism = Battle(self):GetEntity(StaticCreator.ChildEids[1])
    if not Mechanism or not Mechanism.SetExploreSpline then return end
    Mechanism:SetExploreSpline(SplineComponent)
end

return M
