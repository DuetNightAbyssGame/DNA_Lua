local TimeUtils = require "Utils.TimeUtils"
local BattlePassUtils = require "BluePrints.UI.WBP.BattlePass.BattlePassUtils"
local ControllerFSM = require("Blueprints.UI.ControllerFSM")
local FSMStates = {
    Default = 0,
    FocusItemCantGet = 1,           -- 聚焦不可获得的Reward
    FocusItemCanGet = 2,            -- 聚焦可获得的Reward
}

local BATTLE_PASS_LEVEL_PURCHASE_POPUP = 100183
local BATTLE_PASS_LACK_COIN1_POPUP = 100136
local BATTLE_PASS_ALL_LACK_COIN_POPUP = 100137

local BattlePassController = require "BluePrints.UI.WBP.BattlePass.Controller.BattlePassController"

local WBP_BattlePass_Book_C = Class({"BluePrints.UI.BP_UIState_C"})

--function M:Initialize(Initializer)
--end

function WBP_BattlePass_Book_C:Construct()
    self.Overridden.Construct(self)
    self.Avatar = GWorld:GetAvatar()

    BattlePassController:Init()
    BattlePassController:SetModelData("BattlePassId", self.Avatar.BattlePassVersion)
    BattlePassController:SetModelData("BattlePassInfo", DataMgr.BattlePassMain[BattlePassController:GetModelData("BattlePassId")])

    self.Text_Check:SetText(GText("UI_BattlePass_PreviewPortal"))
    local EmptyFunction = function()
    end
    self.Btn_GetAll:TryOverrideSoundFunc(EmptyFunction)
    self.Btn_GetAll:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Btn_GetAll:SetGamePadImg("Y")
    self.Btn_GetAll:SetGamePadIconVisible(true)
    self.Btn_GetAll:SetText(GText("UI_BattlePass_ClaimAll"))
    self.Btn_GetAll:BindEventOnClicked(self,self.GetAllReward)
    self.Btn_Unlock:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Btn_BuyLv:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Reward_Sp.Content = nil
    self.Reward_Sp:SetSp()
    self.List_Reward.BP_OnEntryGenerated:Add(self,self.OnEntryGenerated)
    self.List_Reward.BP_OnEntryReleased:Add(self,self.OnEntryReleased)
    self.Text_Title:SetText(GText(BattlePassController:GetModelData("BattlePassInfo").BattlePassTitle))
    self.RewardTab_Normal:Init(self)
    self.RewardTab_Sp:Init(self, self.OpenPurchase)
    self.Key_Swtich_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:InitPetIconInfo()
    self:InitLevelInfo()
    self:InitTime()
    self:InitBtn()
    --self:InitRewardInfo()
    self:InitMissionInfo()
    self.Type2Index = {
        Daily = 1,
        Weekly = 2,
        Version = 3,
    }
    self.Index2Type = {
        [1] = "Daily",
        [2] = "Weekly",
        [3] = "Version",
    }
    self.List_Mission.OnCreateEmptyContent:Bind(self, function(self)
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.IsEmpty = true
        Content.Parent = self
        return Content
    end)
    -- self.LongPressTimerInterval = 0.1
    -- self.LongPressDuration = 1
    self:InitWhenSwitch()
    self.CurSelectedTab = nil
    self.CurSelectedTabIndex = nil
    self.PlayLevelUp = false
    self.PlayUnlock = false
    self.NeedShowAutoGetPopupUI = false
    self.ShowingPopupUI = false
    self.HaveGetAllTip = nil
    self.IsTipMode = false
    self.OpenTipsWidget = nil
    self.IsLoop = false
    self.ExpandedMaxLevel = nil
    self.LastLevelForLevelUp = nil
    self.WaitingTimerFinish = false
    self.SumTime = 1
    self.Speed = 1/self.SumTime
    self:BindToAnimationFinished(self.ProgressPrompt, {self,function()
        self:SetLevelBar(0, 1)
        self.TargetPercent = self.CurExp/BattlePassController:GetModelData("BattlePassInfo").LevelExp
        self:AddLevelBarTimer()
    end
    })

	EventManager:AddEvent(EventID.BattlePassTaskProgressChange, self, self.OnBattlePassTaskProgressChange)
	EventManager:AddEvent(EventID.BattlePassLevelChange, self, self.OnBattlePassLevelChange)
	EventManager:AddEvent(EventID.BattlePassRank2Unlock, self, self.OnBattlePassRank2Unlock)
	EventManager:AddEvent(EventID.BattlePassPetCanClaim, self, self.OnBattlePassPetCanClaim)
    EventManager:AddEvent(EventID.BattlePassAutoGetTaskReward, self, self.OnBattlePassAutoGetTaskReward)
    --ReddotManager.AddListener("BattlePassReward", self, self.OnBattlePassRewardReddotChange)
    ReddotManager.AddListener("BattlePassMission", self, self.OnBattlePassMissionReddotChange)

    self.List_Mission:SetNavigationRuleCustom(EUINavigation.Left,{self,self.OnUINavigation})

    self.Key_L_GamePad:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "LT",
            },
        },
    })
    self.Key_R_GamePad:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "RT",
            },
        },
    })

    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
    self:InitListenEvent()
	self:InitWidgetInfoInGamePad()
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function WBP_BattlePass_Book_C:Destruct()
    self:InitWhenSwitch()
    self.CurSelectedTab = nil
    self.CurSelectedTabIndex = nil

    self.PetIconList:Clear()
    self.List_Reward:ClearListItems()
    self:ClearBindEventAndTimer()
    self:RemoveTimer("ShowAutoGetPopupUITimer")
    self:RemoveTimer("CancelBlockInputTimer")
    self:RemoveTimer("RefreshLastLevelForLevelUpTimer")

	EventManager:RemoveEvent(EventID.BattlePassTaskProgressChange, self)
	EventManager:RemoveEvent(EventID.BattlePassLevelChange, self)
	EventManager:RemoveEvent(EventID.BattlePassRank2Unlock, self)
	EventManager:RemoveEvent(EventID.BattlePassPetCanClaim, self)
    EventManager:RemoveEvent(EventID.BattlePassAutoGetTaskReward, self)
    ReddotManager.RemoveListener("BattlePassReward",self)
    ReddotManager.RemoveListener("BattlePassMission",self)

    self:ClearListenEvent()

    BattlePassController:Destory()

    self.Overridden.Construct(self)
end

function WBP_BattlePass_Book_C:Init(Parent)
    self.Parent = Parent
    self.Btn_Check:BindEventOnClicked(self,self.JumpToDetail)
    self:InitBottomKeyInfo()
end

function WBP_BattlePass_Book_C:JumpToDetail()
    if self.Parent then
        self.Parent:JumpToDetail()
    end
end

function WBP_BattlePass_Book_C:InitSkinOrAccessoryInfo()
    local Name = nil
    local Rarity = nil
    if BattlePassController:GetModelData("BPRewardTyppe") == "Skin" then
        local Id = BattlePassController:GetModelData("TargetSkinId")
        Name = GText(DataMgr.Skin[Id].SkinName)
        Rarity = DataMgr.Skin[Id].Rarity
    elseif BattlePassController:GetModelData("BPRewardTyppe") == "Accessory" then
        local Id = BattlePassController:GetModelData("AccessoryId")
        Name = GText(DataMgr.CharAccessory[Id].Name)
        Rarity = DataMgr.CharAccessory[Id].Rarity
    end
    if Name then
        self.Text_ShowTitle:SetText(Name)
    end
    if Rarity then
        self:UpdateShowTitleFontByRarity(Rarity)
        self.Tag_Quality:Init(Rarity)
    end
end

function WBP_BattlePass_Book_C:UpdateShowTitleFontByRarity(Rarity)
    local ShowTitleFontMap  = {
        [6] = self.Font_Red,
        [5] = self.Font_Gold,
        [4] = self.Font_Purple,
        [3] = self.Font_Blue,
    }

    local FontToSet = ShowTitleFontMap[Rarity]
    if FontToSet then
        self.Text_ShowTitle:SetFont(FontToSet)
    end
end

function WBP_BattlePass_Book_C:InitPetIconInfo()
    if not ShopUtils:IsCanOpenPay(false) then
        self.Text_Desc:SetText(GText("UI_BattlePass_Oversea_PurchaseLocked"))
    else
        self.Text_Desc:SetText(GText("UI_BattlePass_PetClaimDetail"))
    end
    BattlePassController:SetModelData("PetList", DataMgr.BattlePassMain[BattlePassController:GetModelData("BattlePassId")].PetId)
    self.PetIconList:Clear()
    self.PetIconLengt = 0
    for Index,PetId in ipairs(BattlePassController:GetModelData("PetList")) do
        local PetIconPath = DataMgr.Pet[PetId].Icon
        if PetIconPath then
            local PetIcon = LoadObject(PetIconPath)
            self.PetIconList:Add(PetIcon)
        end
    end
    self.PetIconLengt = self.PetIconList:Length()
end

function WBP_BattlePass_Book_C:InitLevelInfo()
    self.Text_Exp:SetText(GText("UI_BattlePass_BPExp"))
    self.Text_WeekExp:SetText(GText("UI_BattlePass_BPWeeklyMaxExp"))
    self:RefreshLevelInfo()
    self:SetLevelBarForce()
end

function WBP_BattlePass_Book_C:RefreshLevelInfo()
    if not self.WaitingTimerFinish then
        self.LastLevelForLevelUp = self.CurLevel
        self.WaitingTimerFinish = true
        self:AddTimer(0.1, function()
            self.WaitingTimerFinish = false
        end,false,0,"RefreshLastLevelForLevelUpTimer",true)
    end
    self.LastLevel = self.CurLevel
    self.CurLevel = self.Avatar.BattlePassLevel
    self.LastExp = self.CurExp
    self.CurExp = self.Avatar.BattlePassExp
    self.BattlePass_Level.Text_Level:SetText(self.CurLevel)
    self.Num_Exp_Now:SetText(self.Avatar.BattlePassExp)
    self.Num_Exp_Total:SetText(BattlePassController:GetModelData("BattlePassInfo").LevelExp)
    self.Num_WeekExp_Now:SetText(self.Avatar.BattlePassWeeklyExp)
    self.Num_WeekExp_Total:SetText(BattlePassController:GetModelData("BattlePassInfo").WeeklyMaxExp)
end

function WBP_BattlePass_Book_C:RefreshLevelBar()
    if self.PlayLevelUp then
        return
    end
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local BattlePassLevelUp = UIManager:GetUIObj("BattlePassLevelUp")
    if BattlePassLevelUp then
        return
    end
    if not self.LastLevel and not self.LastExp then
        self:SetLevelBar(self.Avatar.BattlePassExp, BattlePassController:GetModelData("BattlePassInfo").LevelExp)
    else
        if self.CurLevel < self.LastLevel then
            self:SetLevelBar(self.Avatar.BattlePassExp, BattlePassController:GetModelData("BattlePassInfo").LevelExp)
        elseif self.CurLevel == self.LastLevel then
            if self.CurExp <= self.LastExp then
                self:SetLevelBar(self.Avatar.BattlePassExp, BattlePassController:GetModelData("BattlePassInfo").LevelExp)
            else
                self.TargetPercent = self.CurExp/BattlePassController:GetModelData("BattlePassInfo").LevelExp
                self:AddLevelBarTimer()
            end
        else
            self:SetLevelBar(BattlePassController:GetModelData("BattlePassInfo").LevelExp, BattlePassController:GetModelData("BattlePassInfo").LevelExp)
        end
    end
end

function WBP_BattlePass_Book_C:SetLevelBar(CurrentExp, MaxExp)
    self:RemoveLevelBarTimer()
    -- local CanvasSlot_ExpBar = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Exp_Bar)
    -- local CanvasSlot_PanelExpBar = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Panel_ExpBar)
    -- local CanvasSlot_Main = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Main)
    -- local Offset_ExpBar = CanvasSlot_ExpBar:GetOffsets()
    -- local Offset_PanelExpBar = CanvasSlot_PanelExpBar:GetOffsets()
    -- local Offset_Main = CanvasSlot_Main:GetOffsets()
    -- local ViewportSize = UWidgetLayoutLibrary.GetViewportSize(self)
    -- local ViewportScale = UWidgetLayoutLibrary.GetViewportScale(self)
    -- local OffsetRight = (ViewportSize.X - (Offset_Main.Left + Offset_Main.Right)*ViewportScale - (Offset_PanelExpBar.Left + Offset_PanelExpBar.Right)*ViewportScale)/ViewportScale
    -- Offset_ExpBar.Right = OffsetRight
    -- CanvasSlot_ExpBar:SetOffsets(Offset_ExpBar)
    self.Exp_Bar:SetPercent(CurrentExp/MaxExp)
end

function WBP_BattlePass_Book_C:SetLevelBarForce()
    self:SetLevelBar(self.Avatar.BattlePassExp, BattlePassController:GetModelData("BattlePassInfo").LevelExp)
end

function WBP_BattlePass_Book_C:SetLevelBarLerp(DeltaTime)
    if self.TargetPercent then
        local CurPercent = self.Exp_Bar.Percent
        local Percent = CurPercent+DeltaTime*self.Speed
        if Percent >= self.TargetPercent then
            self.Exp_Bar:SetPercent(self.TargetPercent)
            self:RemoveLevelBarTimer()
        else
            self.Exp_Bar:SetPercent(Percent)
        end
    else
        self:RemoveLevelBarTimer()
    end
end

function WBP_BattlePass_Book_C:InitTime()
    BattlePassController:SetModelData("BattlePassEndTime", DataMgr.BattlePassMain[BattlePassController:GetModelData("BattlePassId")].BattlePassEndTime)
    self.NextDayEndTime = math.floor(TimeUtils.NextDailyRefreshTime())
    self.NextWeekEndTime = math.floor(TimeUtils.NextWeeklyRefreshTime())
    self.Time_Left.Text_TimeTitle:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:RefreshTime(self.NextDayEndTime, self.NextWeekEndTime, BattlePassController:GetModelData("BattlePassEndTime"))
    self:AddTimer(1, self.RefreshTime, true, 0, "RefreshBattlePassTime", true, self.NextDayEndTime, self.NextWeekEndTime, BattlePassController:GetModelData("BattlePassEndTime"))
end

function WBP_BattlePass_Book_C:RefreshTime(DayEndTime, WeekEndTime, VersionEndTime)
    local RemainTimeDictDaily = UIUtils.GetLeftTimeStrStyle2(DayEndTime)
    local RemainTimeDictWeekly = UIUtils.GetLeftTimeStrStyle2(WeekEndTime)
    local RemainTimeDictVersion = UIUtils.GetLeftTimeStrStyle2(VersionEndTime)
    self.Time_Left:SetTimeText(GText("UI_BattlePass_RemainTime"), RemainTimeDictVersion)
    self.WBP_BattlePass_MissionTab_Daily:SetTimeText(GText("UI_BattlePass_RemainTime"),RemainTimeDictDaily)
    self.WBP_BattlePass_MissionTab_Weekly:SetTimeText(GText("UI_BattlePass_RemainTime"),RemainTimeDictWeekly)
    self.WBP_BattlePass_MissionTab_Version:SetTimeText(GText("UI_BattlePass_RemainTime"),RemainTimeDictVersion)
    if self.CurSelectedTab and self.CurSelectedTab.Type == "Version" then
        local AllDisplayWidget = self.List_Mission:GetDisplayedEntryWidgets()
        for _, Widget in pairs(AllDisplayWidget) do
            Widget:TryRefreshTime()
        end
    end
end

function WBP_BattlePass_Book_C:InitBtn()
    self.Button_Area.OnClicked:Add(self,self.PageTurnerToNext)
    self.Btn_Pet.OnClicked:Add(self,self.PageTurnerToNextNew)

    self:RefreshBtnBuy()

    self:RefreshBtnUnlock()
end

function WBP_BattlePass_Book_C:RefreshBtnBuy()
    -- 购买等级
    local bIsLevelMax = BattlePassUtils:IsMaxLevel()
    DebugPrint("gmy@WBP_BattlePass_Book_C WBP_BattlePass_Book_C:InitBtn", GText('UI_BattlePass_MaxLevel'))
    if bIsLevelMax then
        self.Btn_BuyLv:SetDefaultGamePadImg("RS")
        self.Btn_BuyLv:SetText(GText("UI_BattlePass_MaxLevel"))
        self.Btn_BuyLv:ForbidBtn(true)
        self.Btn_BuyLv:UnBindEventOnClicked()
    else
        self.Btn_BuyLv:SetDefaultGamePadImg("RS")
        self.Btn_BuyLv:SetText(GText("UI_BattlePass_BuyLevel"))
        self.Btn_BuyLv:ForbidBtn(false)
        self.Btn_BuyLv:UnBindEventOnClicked()
        self.Btn_BuyLv:BindEventOnClicked(self,function()
            self:OpenPurchaseDialog()
        end)
    end
end

function WBP_BattlePass_Book_C:RefreshBtnUnlock()
    -- 解锁高级战令
    if not ShopUtils:IsCanOpenPay(false) then
        self.Btn_Unlock:InitBtnInfo("Forbidden", GText("UI_BattlePass_UnlockGoldRank"), function()
            self:ShowUITip()
        end, nil, nil, "X", false)
        self.RewardTab_Sp:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        if self.Avatar.BattlePassUnlockRank2 then
            self.Btn_Unlock:InitBtnInfo("Normal", GText("UI_BattlePass_CheckRank"), function()
                self:OpenPurchase()
            end, nil, nil, "X", false)
        else
            self.Btn_Unlock:InitBtnInfo("Normal", GText("UI_BattlePass_UnlockGoldRank"), function()
                self:OpenPurchase()
            end, nil, nil, "X", false)
        end
        if self.Avatar.BattlePassUnlockRank2 and self.Avatar.BattlePassUnlockRank3 then
            self.RewardTab_Sp:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        else
            self.RewardTab_Sp:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end
    end
end

function WBP_BattlePass_Book_C:ScrollToNext()
    local FirstCanGetReward = nil
    local FirstCantGetReward = nil
    local Contents = self.List_Reward:GetListItems()
    local Length = Contents:Length()
    for _, Content in pairs(Contents) do
        if self:CheckHaveAnyRewardCanGet_Item(Content) then
            if not FirstCanGetReward or FirstCanGetReward.BattlePassLevel > Content.BattlePassLevel then
                FirstCanGetReward = Content
            end
        elseif self:CheckHaveAnyRewardCantGet_Item(Content) then
            if not FirstCantGetReward or FirstCantGetReward.BattlePassLevel > Content.BattlePassLevel then
                FirstCantGetReward = Content
            end
        end
    end
    if FirstCanGetReward then
        self:ScrollToTarget(FirstCanGetReward)
    elseif FirstCantGetReward then
        self:ScrollToTarget(FirstCantGetReward)
    else
        local Content = self.List_Reward:GetItemAt(Length-1)
        if Content then
            self:ScrollToTarget(Content)
        end
    end
    self:AddTimer(0.001,self.RefreshRewardSpAfterScroll,false,0,nil,true)
end

function WBP_BattlePass_Book_C:CheckHaveAnyRewardCanGet_Item(Content)
    if Content.IsGotState_Rank1 == 1 or (Content.IsUnlocked and Content.IsGotState_Rank2 == 1) then
        return true
    else
        return false
    end
end

function WBP_BattlePass_Book_C:CheckHaveAnyRewardCantGet_Item(Content)
    if Content.IsGotState_Rank1 == 0 or (Content.IsUnlocked and Content.IsGotState_Rank2 == 0) then
        return true
    else
        return false
    end
end

function WBP_BattlePass_Book_C:ScrollToTarget(Content)
    --self.List_Reward:BP_ScrollItemIntoView(Content)
    self.List_Reward:BP_NavigateToItem(Content)
end

function WBP_BattlePass_Book_C:InitRewardInfo()
    self.List_Reward:ClearListItems()
    local BattlePassId = BattlePassController:GetModelData("BattlePassId")
    local BattlePassRewardData = BattlePassUtils:GetBattlePassReward(BattlePassId)
    for Level, RewardInfo in ipairs(BattlePassRewardData or {}) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        self:ChangeContentWithUnlockInfo(Content)
        self:ChangeContentWithGotInfo(Content, RewardInfo.BattlePassLevel)
        Content.BattlePassLevel = RewardInfo.BattlePassLevel
        Content.Rank1Reward = RewardInfo.Rank1Reward
        Content.Rank2Reward = RewardInfo.Rank2Reward
        Content.IsLoop = false
        Content.IsLoopEmpty = false
        Content.Root = self
        self.List_Reward:AddItem(Content)
    end
    local LoopRewardPeriod = DataMgr.BattlePassMain[BattlePassId].LoopRewardPeriod
    if LoopRewardPeriod then
        self.IsLoop = true
        local MaxLevel = self:GetMaxLevel()
        local LevelLimit = DataMgr.BattlePassMain[BattlePassId].LevelLimit
        local LoopTime = 1
        if self.CurLevel > MaxLevel then
            local TargetNum = math.ceil((self.CurLevel-MaxLevel)/LoopRewardPeriod)*LoopRewardPeriod+LoopRewardPeriod
            if TargetNum > LevelLimit - MaxLevel then
                TargetNum = LevelLimit - MaxLevel
            end
            LoopTime = math.ceil(TargetNum/LoopRewardPeriod)
        end
        local LoopFreeRewardId = DataMgr.BattlePassMain[BattlePassId].LoopFreeRewardId
        local LoopPaidRewardId = DataMgr.BattlePassMain[BattlePassId].LoopPaidRewardId
        local TempIndex = MaxLevel
        for i=1,LoopTime do
            for Index=1,LoopRewardPeriod do
                local Level = MaxLevel+(i-1)*LoopRewardPeriod+Index
                if Level <= LevelLimit then
                    TempIndex = Level
                    local Content = NewObject(UIUtils.GetCommonItemContentClass())
                    self:ChangeContentWithUnlockInfo(Content)
                    self:ChangeContentWithGotInfo(Content, Level)
                    Content.BattlePassLevel = Level
                    Content.Rank1Reward = LoopFreeRewardId[Index]
                    Content.Rank2Reward = LoopPaidRewardId[Index]
                    Content.IsLoop = true
                    Content.IsLoopEmpty = false
                    Content.Root = self
                    self.List_Reward:AddItem(Content)
                end
            end
        end
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Index = TempIndex + 1
        Content.LevelLimit = LevelLimit
        Content.IsLoop = true
        Content.IsLoopEmpty = true
        Content.Root = self
        self.List_Reward:AddItem(Content)
    end
end

function WBP_BattlePass_Book_C:ChangeContentWithUnlockInfo(Content)
    Content.IsUnlocked = self.Avatar.BattlePassUnlockRank2
end

function WBP_BattlePass_Book_C:ChangeContentWithGotInfo(Content, BattlePassLevel)
    if Content.IsLoopEmpty then
        return
    end
    local Rank1GotInfo = self.Avatar.BattlePassRank1LevelRewardsGot
    local Rank2GotInfo = self.Avatar.BattlePassRank2LevelRewardsGot
    if Rank1GotInfo[BattlePassLevel] then
        Content.IsGotState_Rank1 = 2
    elseif BattlePassLevel > self.Avatar.BattlePassLevel then
        Content.IsGotState_Rank1 = 0
    else
        Content.IsGotState_Rank1 = 1
    end
    if self.Avatar.BattlePassUnlockRank2 then
        if Rank2GotInfo[BattlePassLevel] then
            Content.IsGotState_Rank2 = 2
        elseif BattlePassLevel > self.Avatar.BattlePassLevel then
            Content.IsGotState_Rank2 = 0
        else
            Content.IsGotState_Rank2 = 1
        end
    else
        Content.IsGotState_Rank2 = 0
    end
end

function WBP_BattlePass_Book_C:CheckHaveAnyRewardCanGet()
    local Rank1GotInfo = self.Avatar.BattlePassRank1LevelRewardsGot
    local Rank2GotInfo = self.Avatar.BattlePassRank2LevelRewardsGot
    local BattlePassRewardData = BattlePassUtils:GetBattlePassReward(BattlePassController:GetModelData("BattlePassId"))
    for Level, RewardInfo in ipairs(BattlePassRewardData or {}) do
        if RewardInfo.BattlePassLevel <= self.Avatar.BattlePassLevel then
            if not Rank1GotInfo[RewardInfo.BattlePassLevel] then
                return true
            end
            if self.Avatar.BattlePassUnlockRank2 then
                if not Rank2GotInfo[RewardInfo.BattlePassLevel] then
                    return true
                end
            end
        end
    end
    local MaxLevel = self:GetMaxLevel()
    if self.CurLevel and MaxLevel and self.CurLevel > MaxLevel then
        for Level = MaxLevel,self.CurLevel do
            if not Rank1GotInfo[Level] then
                return true
            end
            if self.Avatar.BattlePassUnlockRank2 then
                if not Rank2GotInfo[Level] then
                    return true
                end
            end
        end
    end
    return false
end

function WBP_BattlePass_Book_C:GetReward(Level, IsRank2)
    local Callback = function(Rewards)
        self:UpdateItems()
        self:RefreshRewardSp()
        self:RefreshGetAllRewardBtn(BattlePassController:GetModelData("CurTabId"))
        --self:ScrollToNext()
        if IsRank2 then
            self:RefreshBattlePassRewardReddotInfo(Level,"Rank2")
        else
            self:RefreshBattlePassRewardReddotInfo(Level,"Rank1")
        end
        local UIManager = GWorld.GameInstance:GetGameUIManager()
        
        -- 海外仍然使用旧的通用弹窗
        if not ShopUtils:IsCanOpenPay(false) or self.Avatar.BattlePassUnlockRank2 then
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, nil, self)
        else
            UIManager:LoadUINew("BattlePassGetItemPage", nil, nil, nil, Rewards, nil, nil, self, BattlePassController:GetModelData("ActorController"))
        end
    end
    self.Avatar:RpcBattlePassGetLevelReward(Level, IsRank2, Callback)
end

function WBP_BattlePass_Book_C:GetAllBattlePassReward()
    if self:CheckHaveAnyRewardCanGet() then
        AudioManager(self):PlayUISound(self, "event:/ui/common/battle_pass_btn_click_normal", nil, nil)
        local Callback = function(Rewards)
            self:UpdateItems()
            self:RefreshRewardSp()
            self:RefreshGetAllRewardBtn(BattlePassController:GetModelData("CurTabId"))
            --self:ScrollToNext()
            self:RefreshBattlePassRewardReddotInfo()
            local UIManager = GWorld.GameInstance:GetGameUIManager()

            -- 海外仍然使用旧的通用弹窗
            if not ShopUtils:IsCanOpenPay(false) or self.Avatar.BattlePassUnlockRank2 then
                UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, nil, self)
            else
                UIManager:LoadUINew("BattlePassGetItemPage", nil, nil, nil, Rewards, nil, nil, self, BattlePassController:GetModelData("ActorController"))
            end
        end
        self.Avatar:RpcBattlePassGetAllLevelReward(Callback)
    end
end

function WBP_BattlePass_Book_C:UpdateItems()
    local MaxLevel = BattlePassUtils:GetMaxLevel()
    if self.IsLoop and self.CurLevel > MaxLevel then
        local Index = self.List_Reward:GetNumItems()
        local CurNum = Index - 1
        local BattlePassId = BattlePassController:GetModelData("BattlePassId")
        local LoopRewardPeriod = DataMgr.BattlePassMain[BattlePassId].LoopRewardPeriod
        local LevelLimit = DataMgr.BattlePassMain[BattlePassId].LevelLimit
        local LoopTime = 0
        local TargetNum = math.ceil((self.CurLevel-MaxLevel)/LoopRewardPeriod)*LoopRewardPeriod+LoopRewardPeriod
        if TargetNum > LevelLimit - MaxLevel then
            TargetNum = LevelLimit - MaxLevel
        end
        LoopTime = math.ceil((TargetNum-(CurNum-MaxLevel))/LoopRewardPeriod)
        if LoopTime > 0 then
            local EmptyContent = self.List_Reward:GetItemAt(Index-1)
            self.List_Reward:RemoveItem(EmptyContent)
            local LoopFreeRewardId = DataMgr.BattlePassMain[BattlePassId].LoopFreeRewardId
            local LoopPaidRewardId = DataMgr.BattlePassMain[BattlePassId].LoopPaidRewardId
            local TempIndex = CurNum
            for i=1,LoopTime do
                for Index=1,LoopRewardPeriod do
                    local Level = CurNum+(i-1)*LoopRewardPeriod+Index
                    if Level <= LevelLimit then
                        TempIndex = Level
                        local Content = NewObject(UIUtils.GetCommonItemContentClass())
                        self:ChangeContentWithUnlockInfo(Content)
                        self:ChangeContentWithGotInfo(Content, Level)
                        Content.BattlePassLevel = Level
                        Content.Rank1Reward = LoopFreeRewardId[Index]
                        Content.Rank2Reward = LoopPaidRewardId[Index]
                        Content.IsLoop = true
                        Content.IsLoopEmpty = false
                        Content.Root = self
                        self.List_Reward:AddItem(Content)
                    end
                end
            end
            local Content = NewObject(UIUtils.GetCommonItemContentClass())
            Content.Index = TempIndex + 1
            Content.LevelLimit = LevelLimit
            Content.IsLoop = true
            Content.IsLoopEmpty = true
            Content.Root = self
            self.List_Reward:AddItem(Content)
        end
    end

    local Contents = self.List_Reward:GetListItems()
    local BattlePassRewardData = BattlePassUtils:GetBattlePassReward(BattlePassController:GetModelData("BattlePassId"))
    if BattlePassRewardData then
        for _, Content in pairs(Contents) do
            self:ChangeContentWithUnlockInfo(Content)
            self:ChangeContentWithGotInfo(Content, Content.BattlePassLevel)
        end
    end
    local AllDisplayWidget = self.List_Reward:GetDisplayedEntryWidgets()
    for _, Widget in pairs(AllDisplayWidget) do
        Widget:Refresh()
    end
end

function WBP_BattlePass_Book_C:OnEntryGenerated(Entry)
    if Entry.Content.IsLoopEmpty then
        return
    end
    local Content = self:GetCurSpecialRewardContent(Entry.Content.BattlePassLevel)
    if not self.Reward_Sp.Content or (Content and Content.BattlePassLevel and Content.BattlePassLevel > self.Reward_Sp.Content.BattlePassLevel) then
        self.Reward_Sp:Init(Content)
    end
end

function WBP_BattlePass_Book_C:OnEntryReleased(Entry)
    if Entry.Content.IsLoopEmpty then
        return
    end
    local ReleasedTargetLevel = self:GetTargetLevel(Entry.Content.BattlePassLevel)
    if ReleasedTargetLevel >= self.Reward_Sp.Content.BattlePassLevel then
        local TargetLevel = self:GetTargetLevel(Entry.Content.BattlePassLevel-1)
        if TargetLevel < ReleasedTargetLevel then
            local Content = self:GetContent(TargetLevel)
            if Content then
                self.Reward_Sp:Init(Content)
            end
        end
    end
end

function WBP_BattlePass_Book_C:RefreshRewardSpAfterScroll()
    local AllDisplayWidget = self.List_Reward:GetDisplayedEntryWidgets()
    local TargetContent = nil
    for _, Widget in pairs(AllDisplayWidget) do
        if not Widget.Content.IsLoopEmpty then
            local Content = self:GetCurSpecialRewardContent(Widget.Content.BattlePassLevel)
            if not TargetContent or TargetContent.BattlePassLevel < Content.BattlePassLevel then
                TargetContent = Content
            end
        end
    end
    if TargetContent and self.Reward_Sp.Content and TargetContent.BattlePassLevel~=self.Reward_Sp.Content.BattlePassLevel then
        self.Reward_Sp:Init(TargetContent)
    end
end

function WBP_BattlePass_Book_C:RefreshRewardSp()
    local AllDisplayWidget = self.List_Reward:GetDisplayedEntryWidgets()
    local TargetContent = nil
    for _, Widget in pairs(AllDisplayWidget) do
        if Widget.Content.BattlePassLevel then
            local Content = self:GetCurSpecialRewardContent(Widget.Content.BattlePassLevel)
            if not TargetContent or TargetContent.BattlePassLevel < Content.BattlePassLevel then
                TargetContent = Content
            end
        end
    end
    if TargetContent then
        self.Reward_Sp:Init(TargetContent)
    end
end

function WBP_BattlePass_Book_C:GetCurSpecialRewardContent(Level)
    local TargetLevel = self:GetTargetLevel(Level)
    return self:GetContent(TargetLevel)
end

function WBP_BattlePass_Book_C:GetTargetLevel(Level)
    if not Level then
        return nil
    end
    return (math.floor((Level-1)/BattlePassController:GetModelData("BattlePassInfo").MilestoneInterval)+1)*BattlePassController:GetModelData("BattlePassInfo").MilestoneInterval
end

function WBP_BattlePass_Book_C:GetContent(Level)
    local Contents = self.List_Reward:GetListItems()
    for _, Content in pairs(Contents) do
        if Content.BattlePassLevel == Level then
            return Content
        end
    end
end

function WBP_BattlePass_Book_C:InitMissionInfo()
    self:InitDailyMission()
    self:InitWeeklyMission()
    self:InitVersionMission()
end

function WBP_BattlePass_Book_C:InitDailyMission()
    self.WBP_BattlePass_MissionTab_Daily:Init("Daily", self)
end

function WBP_BattlePass_Book_C:InitWeeklyMission()
    self.WBP_BattlePass_MissionTab_Weekly:Init("Weekly", self)
end

function WBP_BattlePass_Book_C:InitVersionMission()
    self.WBP_BattlePass_MissionTab_Version:Init("Version", self)
end

function WBP_BattlePass_Book_C:OpenMissionList(Tab, IsForce)
    if self.CurSelectedTab then
        if self.CurSelectedTab.Type == Tab.Type then
            if not IsForce then
                return
            end
        else
            self.CurSelectedTab:UnSelected()
        end
    end
    self.CurSelectedTab = Tab
    self.CurSelectedTab:Selected()
    self:PlaySwitchAnim()
    self.CurSelectedTabIndex = self.Type2Index[self.CurSelectedTab.Type]
    self.List_Mission:ClearListItems()
    self:FillListWithMissionInfo(self.CurSelectedTab.Type)
    self.List_Mission:ScrollToTop()
    self:AddTimer(0.01, function()
        self.List_Mission:RequestFillEmptyContent()
        self.List_Mission:RequestPlayEntriesAnim()
    end,false,0,nil,true)
    -- self:AddDelayFrameFunc(function()
    --     local ItemUIs = self.List_Mission:GetDisplayedEntryWidgets()
    --     local Widget = ItemUIs:GetRef(1)
    --     if Widget then
    --         Widget:SetFocus()
    --     end
    -- end, 2)
end

function WBP_BattlePass_Book_C:GetSortedMissionTable(MissionInfo)
    local BattlePassTask = DataMgr.BattlePassTask
    local SortedMissionTable = {}
    for BattlePassTaskId, TargetCounter in pairs(MissionInfo) do
        table.insert(SortedMissionTable,BattlePassTaskId)
    end
    table.sort(SortedMissionTable,function (a,b)
        if MissionInfo[a].RewardsGot then
            if MissionInfo[b].RewardsGot then
                return a < b
            else
                if MissionInfo[b]:IsComplete() then
                    return false
                else
                    return false
                end
            end
        else
            if MissionInfo[b].RewardsGot then
                return true
            else
                if MissionInfo[a]:IsComplete() then
                    if MissionInfo[b]:IsComplete() then
                        return a < b
                    else
                        return true
                    end
                else
                    if MissionInfo[b]:IsComplete() then
                        return false
                    else
                        if BattlePassTask[a].JumpUIId then
                            if BattlePassTask[b].JumpUIId then
                                return a < b
                            else
                                return true
                            end
                        else
                            if BattlePassTask[b].JumpUIId then
                                return false
                            else
                                return a < b
                            end
                        end
                    end
                end
            end
        end
    end)
    return SortedMissionTable
end

function WBP_BattlePass_Book_C:FillListWithMissionInfo(Type)
    local MissionInfo = nil
    if Type == "Daily" then
        MissionInfo = self.Avatar.BattlePassTaskDaily
    elseif Type == "Weekly" then
        MissionInfo = self.Avatar.BattlePassTaskWeekly
    elseif Type == "Version" then
        MissionInfo = self.Avatar.BattlePassTaskVersion
    end
    if MissionInfo then
        local BattlePassTask = DataMgr.BattlePassTask
        local SortedMissionTable = self:GetSortedMissionTable(MissionInfo)
        for _, BattlePassTaskId in ipairs(SortedMissionTable) do
            local TargetCounter = MissionInfo[BattlePassTaskId]
            local Content = NewObject(UIUtils.GetCommonItemContentClass())
            Content.ID = TargetCounter.UniqueID
            Content.Type = BattlePassTask[Content.ID].BattlePassType
            Content.Progress = TargetCounter.Progress
            Content.Target = TargetCounter.Target
            Content.RewardsGot = TargetCounter.RewardsGot
            Content.BattlePassId = BattlePassController:GetModelData("BattlePassId")
            Content.Parent = self
            if (Content.Type == "Version") then
                Content.TaskEndTime = BattlePassTask[Content.ID].TaskEndTime
            end
            self.List_Mission:AddItem(Content)
        end
    end
end

function WBP_BattlePass_Book_C:CheckHaveAnyMissionRewardCanGet()
    local MissionInfos = {
        self.Avatar.BattlePassTaskDaily,
        self.Avatar.BattlePassTaskWeekly,
        self.Avatar.BattlePassTaskVersion
    }
    for _,MissionInfo in ipairs(MissionInfos) do
        if self:CheckHaveMissionRewardCanGet(MissionInfo) then
            return true
        end
    end
    return false
end

function WBP_BattlePass_Book_C:CheckHaveMissionRewardCanGet(MissionInfo)
    for BattlePassTaskId, TargetCounter in pairs(MissionInfo) do
        if not TargetCounter.RewardsGot and TargetCounter:IsComplete() then
            return true
        end
    end
    return false
end

function WBP_BattlePass_Book_C:GetMissionReward(BattlePassType,BattlePassTaskId)
    local Callback = function (Reward)
        self:RefreshMissionList(self.CurSelectedTab.Type)
        self:RefreshGetAllRewardBtn(BattlePassController:GetModelData("CurTabId"))
        self:RefreshLevelInfo()
        self:RefreshLevelBar()
        --self:RefreshBattlePassMissionReddotInfo(BattlePassType,BattlePassTaskId)
        -- local UIManager = GWorld.GameInstance:GetGameUIManager()
        -- UIManager:LoadUINew("GetItemPage", nil, nil, nil, Reward)
        -- self:TryPlayLevelUpAnimation()
    end
    self.Avatar:RpcBattlePassGetTaskReward(Callback,BattlePassType,BattlePassTaskId)
end

function WBP_BattlePass_Book_C:GetAllMissionReward()
    AudioManager(self):PlayUISound(self, "event:/ui/common/battle_pass_btn_click_normal", nil, nil)
    local Callback = function (Reward)
        self:RefreshMissionList(self.CurSelectedTab.Type)
        self:RefreshGetAllRewardBtn(BattlePassController:GetModelData("CurTabId"))
        self:RefreshLevelInfo()
        self:RefreshLevelBar()
        --self:RefreshBattlePassMissionReddotInfo()
        -- local UIManager = GWorld.GameInstance:GetGameUIManager()
        -- UIManager:LoadUINew("GetItemPage", nil, nil, nil, Reward)
        -- self:TryPlayLevelUpAnimation()
    end
    self.Avatar:RpcBattlePassGetAllTaskReward(Callback)
end

function WBP_BattlePass_Book_C:RefreshMissionList(Type)
    local MissionInfo = nil
    if Type == "Daily" then
        MissionInfo = self.Avatar.BattlePassTaskDaily
    elseif Type == "Weekly" then
        MissionInfo = self.Avatar.BattlePassTaskWeekly
    elseif Type == "Version" then
        MissionInfo = self.Avatar.BattlePassTaskVersion
    end
    if MissionInfo then
        local BattlePassTask = DataMgr.BattlePassTask
        local SortedMissionTable = self:GetSortedMissionTable(MissionInfo)
        for Index, BattlePassTaskId in ipairs(SortedMissionTable) do
            local TargetCounter = MissionInfo[BattlePassTaskId]
            local Content = self.List_Mission:GetItemAt(Index-1)
            local IfAdd = false
            if not Content then
                IfAdd = true
                Content = NewObject(UIUtils.GetCommonItemContentClass())
            end
            Content.ID = TargetCounter.UniqueID
            Content.Type = BattlePassTask[Content.ID].BattlePassType
            Content.Progress = TargetCounter.Progress
            Content.Target = TargetCounter.Target
            Content.RewardsGot = TargetCounter.RewardsGot
            Content.BattlePassId = BattlePassController:GetModelData("BattlePassId")
            Content.Parent = self
            if (Content.Type == "Version") then
                Content.TaskEndTime = BattlePassTask[Content.ID].TaskEndTime
            end
            if IfAdd then
                self.List_Mission:AddItem(Content)
            end
        end
        local Num = self.List_Mission:GetNumItems()
        if Num > #SortedMissionTable then
            for i=#SortedMissionTable+1,Num do
                local Content = self.List_Mission:GetItemAt(i-1)
                self.List_Mission:RemoveItem(Content)
            end
        end
        local AllDisplayWidget = self.List_Mission:GetDisplayedEntryWidgets()
        for _, Widget in pairs(AllDisplayWidget) do
            Widget:Refresh()
        end
    end
end

-- function WBP_BattlePass_Book_C:RefreshOneMissionInfo(Type, TaskId)
--     local MissionInfo = nil
--     if Type == "Daily" then
--         MissionInfo = self.Avatar.BattlePassTaskDaily
--     elseif Type == "Weekly" then
--         MissionInfo = self.Avatar.BattlePassTaskWeekly
--     elseif Type == "Version" then
--         MissionInfo = self.Avatar.BattlePassTaskVersion
--     end
--     if MissionInfo then
--         local BattlePassTask = DataMgr.BattlePassTask
--         for BattlePassTaskId, BattlePassTaskInfo in ipairs(BattlePassTask) do
--             if
--             local TargetCounter = MissionInfo[BattlePassTaskId]
--             local Content = self.List_Mission:GetItemAt(Index-1)
--             local IfAdd = false
--             Content.ID = TargetCounter.UniqueID
--             Content.Type = BattlePassTask[Content.ID].BattlePassType
--             Content.Progress = TargetCounter.Progress
--             Content.Target = TargetCounter.Target
--             Content.RewardsGot = TargetCounter.RewardsGot
--             Content.BattlePassId = BattlePassController:GetModelData("BattlePassId")
--             Content.Parent = self
--         end
--         local AllDisplayWidget = self.List_Mission:GetDisplayedEntryWidgets()
--         for _, Widget in pairs(AllDisplayWidget) do
--             Widget:Refresh()
--         end
--     end
-- end

function WBP_BattlePass_Book_C:OnBattlePassTaskProgressChange(TaskType, TaskId)
    self:RefreshLevelInfo()
    if self.CurSelectedTab and self.CurSelectedTab.Type == TaskType then
        self:RefreshMissionList(TaskType)
        self:RefreshGetAllRewardBtn(BattlePassController:GetModelData("CurTabId"))
    end
    self:RefreshLevelBar()
end

function WBP_BattlePass_Book_C:OnBattlePassLevelChange()
    self:RefreshLevelInfo()
    if BattlePassController:GetModelData("CurTabId") == "BattlePassReward" then
        self:UpdateItems()
        self:RefreshRewardSp()
        self:RefreshGetAllRewardBtn(BattlePassController:GetModelData("CurTabId"))
    end
    self:RefreshBtnBuy()
    self:TryPlayLevelUpAnimation()
    self:RefreshLevelBar()
end

function WBP_BattlePass_Book_C:OnBattlePassRank2Unlock()
    if BattlePassController:GetModelData("CurTabId") == "BattlePassReward" then
        self:UpdateItems()
        self:RefreshRewardSp()
        self:RefreshGetAllRewardBtn(BattlePassController:GetModelData("CurTabId"))
    end
    self:RefreshBtnUnlock()
    if UIUtils.HasAnyFocus(self) and BattlePassController:GetModelData("CurTabId") == "BattlePassReward" then
        self:PlayUnlockAnimation()
    else
        self.PlayUnlock = true
    end
end

function WBP_BattlePass_Book_C:TryPlayLevelUpAnimation()
    local ExpandedMaxLevel = nil
    local CurTargetNum = self:GetTargetNum(self.CurLevel)
    local LastTargetNum = self:GetTargetNum(self.LastLevelForLevelUp)
    if CurTargetNum and LastTargetNum and CurTargetNum > LastTargetNum then
        ExpandedMaxLevel = CurTargetNum
    end
    if UIUtils.HasAnyFocus(self) then
        self:PlayLevelUpAnimation(ExpandedMaxLevel)
    else
        if self.CurLevel > 1 then
            local UIManager = GWorld.GameInstance:GetGameUIManager()
            local BattlePassLevelUp = UIManager:GetUIObj("BattlePassLevelUp")
            if BattlePassLevelUp then
                BattlePassLevelUp:Refresh(self.CurLevel, ExpandedMaxLevel)
                self.ExpandedMaxLevel = nil
                self.PlayLevelUp = false
            else
                self.ExpandedMaxLevel = ExpandedMaxLevel
                self.PlayLevelUp = true
            end
        end
    end
end

function WBP_BattlePass_Book_C:GetTargetNum(Level)
    if not self.IsLoop then
        return
    end
    if not Level then
        return
    end
    local MaxLevel = BattlePassUtils:GetMaxLevel()
    local BattlePassId = BattlePassController:GetModelData("BattlePassId")
    local LoopRewardPeriod = DataMgr.BattlePassMain[BattlePassId].LoopRewardPeriod
    local LevelLimit = DataMgr.BattlePassMain[BattlePassId].LevelLimit
    if Level < MaxLevel then
        return MaxLevel + LoopRewardPeriod
    end
    local TargetNum = math.ceil((Level-MaxLevel)/LoopRewardPeriod)*LoopRewardPeriod+LoopRewardPeriod
    if TargetNum > LevelLimit - MaxLevel then
        TargetNum = LevelLimit - MaxLevel
    end
    return TargetNum + MaxLevel
end

function WBP_BattlePass_Book_C:PlayLevelUpAnimation(ExpandedMaxLevel)
    if self.CurLevel > 1 then
        local UIManager = GWorld.GameInstance:GetGameUIManager()
        local BattlePassLevelUp = UIManager:GetUIObj("BattlePassLevelUp")
        if BattlePassLevelUp then
            BattlePassLevelUp:Refresh(self.CurLevel, ExpandedMaxLevel)
        else
            UIManager:LoadUINew("BattlePassLevelUp", self.CurLevel, ExpandedMaxLevel)
        end
        self:SetLevelBar(1,1)
        AudioManager(self):PlayUISound(self, "event:/ui/common/battle_pass_exp_bar_update", nil, nil)
        self:PlayAnimation(self.ProgressPrompt)
        self.PlayLevelUp = false
    end
end

function WBP_BattlePass_Book_C:TryCloseLevelUpUI()
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local BattlePassLevelUp = UIManager:GetUIObj("BattlePassLevelUp")
    if BattlePassLevelUp then
        BattlePassLevelUp:Close()
        self.PlayLevelUp = false
    end
end

function WBP_BattlePass_Book_C:PlayUnlockAnimation()
    self.RewardTab_Sp:PlayUnlockAnimation()
    self.PlayUnlock = false
end

function WBP_BattlePass_Book_C:JumptoOtherUI(JumpUIId)
    PageJumpUtils:JumpToTargetPageByJumpId(JumpUIId)
end

function WBP_BattlePass_Book_C:JumpToPetDetail()
    --self.Parent:SwitchTab("BattlePassPetSelection")
    local PetList = BattlePassController:GetModelData("PetList")
    UIManager(self):LoadUINew('ArmoryDetail',{PreviewPetIds = PetList,SelectedTargetId = PetList[self.CurrentPetIndex],
    EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon})
end

function WBP_BattlePass_Book_C:RefreshGetAllRewardBtn(TabId)
    local CurInputDevice = self.GameInputModeSubsystem:GetCurrentInputType()
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if TabId == "BattlePassReward" then
        if self:CheckHaveAnyRewardCanGet() then
            if IsUseKeyAndMouse then
                self.Btn_GetAll:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            else
                if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
                    self.Btn_GetAll:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
                else
                    self.Btn_GetAll:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
                end
            end
            self:RefreshTab(true)
        else
            self.Btn_GetAll:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self:RefreshTab(false)
        end
    elseif TabId == "BattlePassMission" then
        if self:CheckHaveAnyMissionRewardCanGet() then
            if IsUseKeyAndMouse then
                self.Btn_GetAll:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            else
                if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
                    self.Btn_GetAll:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
                else
                    self.Btn_GetAll:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
                end
            end
            self:RefreshTab(true)
        else
            self.Btn_GetAll:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self:RefreshTab(false)
        end
    end
end

-- function WBP_BattlePass_Book_C:OnBattlePassRewardReddotChange()
--     if not ReddotManager.GetTreeNode("BattlePassReward")  then
--         ReddotManager.AddNode("BattlePassReward")
--     end
--     local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("BattlePassReward")
--     if CacheDetail.Rank1 then
--         self.RewardTab_Normal:SetReddotVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
--     else
--         self.RewardTab_Normal:SetReddotVisibility(UIConst.VisibilityOp.Collapsed)
--     end
--     if CacheDetail.Rank2 then
--         self.RewardTab_Sp:SetReddotVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
--     else
--         self.RewardTab_Sp:SetReddotVisibility(UIConst.VisibilityOp.Collapsed)
--     end
-- end

function WBP_BattlePass_Book_C:OnBattlePassMissionReddotChange()
    if not ReddotManager.GetTreeNode("BattlePassMission")  then
        ReddotManager.AddNode("BattlePassMission")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("BattlePassMission")
    if CacheDetail.Daily then
        self.WBP_BattlePass_MissionTab_Daily:SetReddotVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.WBP_BattlePass_MissionTab_Daily:SetReddotVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if CacheDetail.Weekly then
        self.WBP_BattlePass_MissionTab_Weekly:SetReddotVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.WBP_BattlePass_MissionTab_Weekly:SetReddotVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if CacheDetail.Version then
        self.WBP_BattlePass_MissionTab_Version:SetReddotVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.WBP_BattlePass_MissionTab_Version:SetReddotVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function WBP_BattlePass_Book_C:OnBattlePassPetCanClaim()
    local CommonDialogParams = {}
    CommonDialogParams.RightCallbackFunction = function()
        self.Parent:SwitchTab("BattlePassPetSelection")
    end
    self.BattlePassPetCanClaimPopupUI = UIManager(self):ShowCommonPopupUI(100184, CommonDialogParams, self)
end

function WBP_BattlePass_Book_C:RefreshBattlePassRewardReddotInfo(Level,RankType)
    -- if not ReddotManager.GetTreeNode("BattlePassReward")  then
    --     ReddotManager.AddNode("BattlePassReward")
    -- end
    -- local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("BattlePassReward")
    -- if Level and RankType then
    --     if CacheDetail[RankType] then
    --         CacheDetail[RankType][Level] = nil
    --         if next(CacheDetail[RankType]) == nil then
    --             CacheDetail[RankType] = nil
    --         end
	-- 		ReddotManager.DecreaseLeafNodeCount("BattlePassReward", 1)
    --     end
    -- else
    --     CacheDetail.Rank1 = nil
    --     CacheDetail.Rank2 = nil
    --     ReddotManager.ClearLeafNodeCount("BattlePassReward",true)
    -- end
end

-- function WBP_BattlePass_Book_C:RefreshBattlePassMissionReddotInfo(BattlePassType,BattlePassTaskId)
--     if not ReddotManager.GetTreeNode("BattlePassMission")  then
--         ReddotManager.AddNode("BattlePassMission")
--     end
--     local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("BattlePassMission")
--     if BattlePassType and BattlePassTaskId then
--         if CacheDetail[BattlePassType] then
--             CacheDetail[BattlePassType][BattlePassTaskId] = nil
--             if next(CacheDetail[BattlePassType]) == nil then
--                 CacheDetail[BattlePassType] = nil
--             end
-- 			ReddotManager.DecreaseLeafNodeCount("BattlePassMission", 1)
--         end
--     else
--         CacheDetail.Daily = nil
--         CacheDetail.Weekly = nil
--         CacheDetail.Version = nil
--         ReddotManager.ClearLeafNodeCount("BattlePassMission",true)
--     end
-- end

function WBP_BattlePass_Book_C:OnSpaceBarDown()
    if self.Btn_GetAll:GetVisibility() ~= UIConst.VisibilityOp.Collapsed then
        self:GetAllReward()
        return true
    else
        return false
    end
end

function WBP_BattlePass_Book_C:InitBottomKeyInfo()
    self.BottomKeyInfo = {}
    table.insert(self.BottomKeyInfo, {
        GamePadInfoList = {{Type="Img", ImgShortPath="RS"}},
        Desc = GText("UI_CTL_SwichPet"),
        bLongPress = false
    })
    table.insert(self.BottomKeyInfo, {
        GamePadInfoList = {{Type="Img", ImgShortPath="RH"}},
        Desc = GText("UI_CTL_RotatePreview"),
        bLongPress = false
    })
    table.insert(self.BottomKeyInfo, {
        KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Parent.OnClickBack, Owner=self.Parent}},
        GamePadInfoList = {{Type="Img", ImgShortPath="B"}},
        Desc = GText("UI_BACK"),
        bLongPress = false
    })
end

function WBP_BattlePass_Book_C:RefreshTab(HaveGetAllTip)
    if HaveGetAllTip and not self.HaveGetAllTip then
        table.insert(self.BottomKeyInfo, 1, {
            KeyInfoList = {{Type="Text", Text="Space", ClickCallback=self.OnSpaceBarDown, Owner=self}},
            --GamePadInfoList = {{Type="Img", ImgShortPath="X"}},
            Desc = GText("UI_BattlePass_ClaimAll"),
            bLongPress = false
        })
    elseif self.HaveGetAllTip and not HaveGetAllTip then
        table.remove(self.BottomKeyInfo, 1)
    end
    self.HaveGetAllTip = HaveGetAllTip
    self.Parent:UpdateBottomKeyInfo(self.BottomKeyInfo)
end

function WBP_BattlePass_Book_C:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if(InKeyName == "Gamepad_RightX")then
        IsEventHandled = true
        if(BattlePassController:GetModelData("ActorController"))then
            local DeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
            BattlePassController:GetModelData("ActorController"):OnDragViewActor({X=DeltaX})
        end
    end
    return IsEventHandled
end

function WBP_BattlePass_Book_C:HandleKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == UIConst.GamePadKey.FaceButtonBottom) then
            IsEventHandled = true
            self:ClickMissionList()
        elseif (InKeyName == UIConst.GamePadKey.FaceButtonTop) then
            if self.Btn_GetAll:GetVisibility() ~= UIConst.VisibilityOp.Collapsed then
                IsEventHandled = true
                self:GetAllReward()
            end
        elseif (InKeyName == UIConst.GamePadKey.SpecialRight) then
            IsEventHandled = true
            self:OpenPurchaseDialog()
        elseif (InKeyName == UIConst.GamePadKey.SpecialLeft) then
            IsEventHandled = true
            self:JumpToDetail()
        elseif (InKeyName == UIConst.GamePadKey.FaceButtonRight) then
            if self.IsTipMode then
                IsEventHandled = true
                self:TryCloseTips()
            else
                IsEventHandled = self:TryLeaveSpecialMode()
            end
        elseif (InKeyName == UIConst.GamePadKey.FaceButtonLeft) then
            IsEventHandled = true
            if not ShopUtils:IsCanOpenPay(false) then
                self:ShowUITip()
            else
                self:OpenPurchase()
            end
        elseif (InKeyName == UIConst.GamePadKey.RightThumb) then
            IsEventHandled = true
            self:PageTurnerToNextNew()
        elseif (InKeyName == UIConst.GamePadKey.LeftThumb) then
            if BattlePassController:GetModelData("CurTabId") == "BattlePassReward" then
                IsEventHandled = self:TryEnterSpecialMode()
            end
        end
    else
        if (InKeyName == "SpaceBar") then
            IsEventHandled = self:OnSpaceBarDown()
        end
    end
    return IsEventHandled
end

-- function WBP_BattlePass_Book_C:HandleKeyUp(MyGeometry, InKeyEvent)
--     local IsEventHandled = false
--     local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
--     local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
--     if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
--         if (InKeyName == UIConst.GamePadKey.FaceButtonTop) then
--             IsEventHandled = true
--             self:OnFaceButtonTopReleased()
--         end
--     else

--     end
--     return IsEventHandled
-- end

-- function WBP_BattlePass_Book_C:OnFaceButtonTopReleased()
--     if(self.UpdateTimer) then
--         URuntimeCommonFunctionLibrary.K2_ClearAndInvalidateTimerHandle(self, self.UpdateTimer)
--     end
--     if not self.bHasTriggerLongPress then
--         self:OpenPurchase()
--     end
--     self.FaceButtonTopPressTimer = 0
--     self.FaceButtonTopPressing = false
--     self.bHasTriggerLongPress = false
--     self.bHasTriggerLongRelease = false
-- end

-- function WBP_BattlePass_Book_C:OnFaceButtonTopPress()
--     if not self.FaceButtonTopPressing then
--         self.FaceButtonTopPressTimer = 0
--         self.FaceButtonTopPressing = true
--         self.bHasTriggerLongPress = false
--         self.bHasTriggerLongRelease = false
--         self.UpdateTimer = URuntimeCommonFunctionLibrary.K2_SetTimerDelegate({self, self._Update}, self.LongPressTimerInterval, true, 0)
--     end
-- end

-- function WBP_BattlePass_Book_C:_Update()
--     self.FaceButtonTopPressTimer = self.FaceButtonTopPressTimer + self.LongPressTimerInterval
--     if (self.FaceButtonTopPressTimer >= Const.ShortPressThreshold) then
--         self.bHasTriggerLongPress = true
--     end
--     if (self.FaceButtonTopPressTimer >= self.LongPressDuration) then
--         self.bHasTriggerLongRelease = true
--         URuntimeCommonFunctionLibrary.K2_ClearAndInvalidateTimerHandle(self, self.UpdateTimer)
--         self:OpenPurchaseDialog()
--     end
-- end

function WBP_BattlePass_Book_C:TryChangeSelectedTab(NavigationDirection)
    if(NavigationDirection == EUINavigation.Up)then
        return self:OnNavigationToIndex(self.CurSelectedTabIndex-1)
    elseif(NavigationDirection == EUINavigation.Down) then
        return self:OnNavigationToIndex(self.CurSelectedTabIndex+1)
    end
end

function WBP_BattlePass_Book_C:OnNavigationToIndex(Index)
    if Index <= 0 or Index > 3 then
        return self.CurSelectedTab
    end
    if Index == 1 then
        self.WBP_BattlePass_MissionTab_Daily:OnCellClicked()
    elseif Index == 2 then
        self.WBP_BattlePass_MissionTab_Weekly:OnCellClicked()
    elseif Index == 3 then
        self.WBP_BattlePass_MissionTab_Version:OnCellClicked()
    end
    return self.CurSelectedTab
end

function WBP_BattlePass_Book_C:TryEnterSpecialMode()
    if self.InSpecialMode then
        return false
    end
    self.InSpecialMode = true
    self.Key_Check_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Reward_Sp:SetFocus()
    return true
end

function WBP_BattlePass_Book_C:TryLeaveSpecialMode()
    if not self.InSpecialMode then
        return false
    end
    self.InSpecialMode = false
    self.Key_Check_GamePad:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    if self.CurFocusedItem then
        self.List_Reward:BP_NavigateToItem(self.CurFocusedItem.Content)
    else
        self:NavigateToFirstDisplayedItem(self.List_Reward)
    end
    return true
end

function WBP_BattlePass_Book_C:TryEnterSelectMode(Entry)
    if self.InSelectMode then
        return false
    end
    self.InSelectMode = true
    Entry:EnterSelectMode()
    return true
end

function WBP_BattlePass_Book_C:TryLeaveSelectMode(Entry)
    if not self.InSelectMode then
        return false
    end
    self.InSelectMode = false
    Entry:LeaveSelectMode()
    return true
end

function WBP_BattlePass_Book_C:ClickMissionList()
    if self.CurFocusedMissionList then
        self.CurFocusedMissionList:ClickMissionList()
    end
end

function WBP_BattlePass_Book_C:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function WBP_BattlePass_Book_C:ClearListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    end
end

function WBP_BattlePass_Book_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        return
    end
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
end

function WBP_BattlePass_Book_C:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    self.InSelectMode = false
    self.InSpecialMode = false
    if IsUseKeyAndMouse then
		self:InitKeyboardView()
	else
		self:InitGamepadView()
	end
end

function WBP_BattlePass_Book_C:InitGamepadView()
    if UIManager(self):GetUI("CommonDialog") then
        return
    end
    
    if UIUtils.HasAnyFocus(self) then
        if BattlePassController:GetModelData("CurTabId") == "BattlePassReward" then
            if self.CurFocusedRewardItem then
                --self.CurFocusedRewardItem:SetFocus()
                self.List_Reward:BP_NavigateToItem(self.CurFocusedRewardItem.Content)
            else
                self:NavigateToFirstDisplayedItem(self.List_Reward)
            end
        elseif BattlePassController:GetModelData("CurTabId") == "BattlePassMission" then
            if self.CurSelectedTab then
                self.CurSelectedTab:SetFocus()
            else
                self.WBP_BattlePass_MissionTab_Daily:SetFocus()
            end
        end
    end
    --self.Key_Swtich_GamePad:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Key_Check_GamePad:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Button_Area:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.PageTurner:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Key_BuyLv:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.WS_Check:SetActiveWidgetIndex(1)
    if self.Btn_GetAll:GetVisibility() == UIConst.VisibilityOp.SelfHitTestInvisible then
        self.Btn_GetAll:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
    self.WidgetSwitcher_L:SetActiveWidgetIndex(1)
    self.WidgetSwitcher_R:SetActiveWidgetIndex(1)
end

function WBP_BattlePass_Book_C:InitKeyboardView()
    if self.CurFocusedMissionList then
        self.CurFocusedMissionList:StopHover(true)
        self.CurFocusedMissionList = nil
    end
    --self.Key_Swtich_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Key_Check_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Button_Area:SetVisibility(UIConst.VisibilityOp.Visible)
    self.PageTurner:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Key_BuyLv:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WS_Check:SetActiveWidgetIndex(0)
    if self.Btn_GetAll:GetVisibility() == UIConst.VisibilityOp.HitTestInvisible then
        self.Btn_GetAll:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    self.WidgetSwitcher_L:SetActiveWidgetIndex(0)
    self.WidgetSwitcher_R:SetActiveWidgetIndex(0)
end

function WBP_BattlePass_Book_C:InitWidgetInfoInGamePad()
	-- self.Key_Swtich_GamePad:CreateCommonKey({
    --     KeyInfoList = {
    --         {
    --             ImgShortPath = "Vertical",
    --             Type = "Img",
    --         }
    --     },
    --     Desc = GText("UI_Controller_Switch")
    -- })
    self.Key_Check_GamePad:CreateCommonKey({
        KeyInfoList = {
            {
                ImgShortPath = "LS",
                Type = "Img",
            }
        },
        Desc = GText("UI_Controller_Check")
    })
    self.Key_BuyLv:CreateGamepadKey("Menu")
    self.Key_Check:CreateGamepadKey("View")

    -- 初始化手柄状态机
    self.ControllerFSM = ControllerFSM.New(self, {
        [FSMStates.Default] = {
            OnEnter = self.EnterState_Default,
        },
        [FSMStates.FocusItemCantGet] = {
            OnEnter = self.EnterState_FocusItemCantGet,
        },
        [FSMStates.FocusItemCanGet] = {
            OnEnter = self.EnterState_FocusItemCanGet,
        },
    })
end

function WBP_BattlePass_Book_C:BP_GetDesiredFocusTarget()
    local CurInputDevice = self.GameInputModeSubsystem:GetCurrentInputType()
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if not IsUseKeyAndMouse then
        if BattlePassController:GetModelData("CurTabId") == "BattlePassReward" then
            if self.CurFocusedItem then
                return self.CurFocusedItem
            else
                return self
                --return self:NavigateToFirstDisplayedItem(self.List_Reward)
            end
        elseif BattlePassController:GetModelData("CurTabId") == "BattlePassMission" then
            if self.CurFocusedMissionList then
                -- self.CurFocusedMissionList:StopHover()
                -- self.CurFocusedMissionList = nil
                return self.CurFocusedMissionList
            end
            if self.CurSelectedTab then
                return self.CurSelectedTab
            else
                return self.WBP_BattlePass_MissionTab_Daily
            end
        end
    else
        return self
    end
end

function WBP_BattlePass_Book_C:OnUINavigation(NavigationDirection)
    if(NavigationDirection == EUINavigation.Left) then
        if self.CurFocusedMissionList then
            self.CurFocusedMissionList:StopHover()
            self.CurFocusedMissionList = nil
        end
        return self.CurSelectedTab
    end
end

function WBP_BattlePass_Book_C:FocusToFirstMission()
    return self:NavigateToFirstDisplayedItem(self.List_Mission)
end

function WBP_BattlePass_Book_C:GetCurFocusedRewardIndex()
    return self.CurFocusedRewardIndex
end

function WBP_BattlePass_Book_C:SetCurFocusedRewardIndex(RewardItem,Index)
    if self.CurFocusedItem then
        self.CurFocusedItem:HideIcon()
    end
    self.CurFocusedItem = RewardItem
    if not RewardItem.Content.IsLoopEmpty then
        self.CurFocusedRewardItem = RewardItem
    end
    self.CurFocusedRewardIndex = Index
    self.CurFocusedItem:ShowIcon()
end

function WBP_BattlePass_Book_C:TryChangeCurFocusedMissionList(MissionItem)
    if self.CurFocusedMissionList then
        self.CurFocusedMissionList:StopHover()
    end
    self.CurFocusedMissionList = MissionItem
    self.CurFocusedMissionList:BeginHover()
end

function WBP_BattlePass_Book_C:NavigateToFirstDisplayedItem(List)
    local ItemUIs = List:GetDisplayedEntryWidgets()
    if ItemUIs:Length() > 0 then
        local Widget = ItemUIs:GetRef(1)
        if Widget then
            List:BP_NavigateToItem(Widget.Content)
            return Widget
        end
    end
    return List
end

function WBP_BattlePass_Book_C:InitWhenSwitch()
    BattlePassController:SetModelData("CurTabId", nil)
    if self.CurFocusedMissionList then
        self.CurFocusedMissionList:StopHover()
        self.CurFocusedMissionList = nil
    end
    self.CurFocusedRewardItem = nil
    self.CurFocusedRewardIndex = nil
    self.InSelectMode = false
    self.InSpecialMode = false
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self.Key_Check_GamePad:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        self.Key_Check_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function WBP_BattlePass_Book_C:SwitchState(...)
    if BattlePassController:GetModelData("CurTabId") == "BattlePassReward" then
        self:OnLeaveRewardTab()
    end
    self:InitWhenSwitch()
    local TabId = ...
    if TabId == "BattlePassReward" then
        self:SwitchToBattlePassReward(TabId)
    elseif TabId == "BattlePassMission" then
        self:SwitchToBattlePassMission(TabId)
    end
    self:RefreshGetAllRewardBtn(TabId)
    self:PlaySwitchStateAnim(TabId)
end

function WBP_BattlePass_Book_C:SwitchIn(...)
    self:InitWhenSwitch()
    local TabId = ...
    if TabId == "BattlePassReward" then
        self:SwitchToBattlePassReward(TabId)
    elseif TabId == "BattlePassMission" then
        self:SwitchToBattlePassMission(TabId)
    end
    self:RefreshGetAllRewardBtn(TabId)
    self:SetBindEvent()
    self:PlayInAnim()
end

function WBP_BattlePass_Book_C:SwitchToBattlePassReward(TabId)
    self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
    BattlePassController:SetModelData("CurTabId", TabId)
    self:InitRewardInfo()
    --self.List_Reward:ScrollToTop()
    self:ScrollToNext()
end

function WBP_BattlePass_Book_C:SwitchToBattlePassMission(TabId)
    self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
    BattlePassController:SetModelData("CurTabId", TabId)
    if self.CurSelectedTab then
        self.CurSelectedTab:OnCellClicked(true)
    else
        self.WBP_BattlePass_MissionTab_Daily:OnCellClicked(true)
    end
end

function WBP_BattlePass_Book_C:SwitchOut(...)
    if BattlePassController:GetModelData("CurTabId") == "BattlePassReward" then
        self:OnLeaveRewardTab()
    end
    self:InitWhenSwitch()
    self:ClearBindEventAndTimer()
    self:PlayOutAnim()
end

function WBP_BattlePass_Book_C:SetBindEvent()
    self:BindToAnimationFinished(self.Img_Show_Out,{self,self.PageTurnerToNext})
    self:BindToAnimationFinished(self.Img_Show_In,{self,function()
        self:AddTimer(1.5,function()
            self:PlayAnimation(self.Img_Show_Out)
        end,true,0,"RefreshPetIconTimer",true)
    end
    })
    self.PageTurner:InitPageTurner(self.PetIconLengt, self, self.UpdateGuideInfo)
    self.Arrow_L:BindEventOnClicked(self,self.PageTurnerToPrevious,true)
    self.Arrow_R:BindEventOnClicked(self,self.PageTurnerToNext,true)
end

function WBP_BattlePass_Book_C:PageTurnerToNextNew()
    if self.Parent then
        self.Parent:PageTurnerToNext()
    end
end

function WBP_BattlePass_Book_C:PageTurnerToNext(StopAtEdge)
    local NewPetIndex = nil
    if not StopAtEdge then
        NewPetIndex = self.CurrentPetIndex%(self.PetIconLengt)+1
    else
        NewPetIndex = self.CurrentPetIndex + 1
        if NewPetIndex > self.PetIconLengt then
            return
        end
    end
    self:RemoveTimer("RefreshPetIconTimer")
    self.PageTurner:SwtichPagePointAnimation(NewPetIndex)
    self:UpdateGuideInfo(NewPetIndex)
end

function WBP_BattlePass_Book_C:PageTurnerToPrevious(StopAtEdge)
    local NewPetIndex = nil
    if not StopAtEdge then
        NewPetIndex = (self.CurrentPetIndex-1)%(self.PetIconLengt)
        if NewPetIndex == 0 then
            NewPetIndex = self.PetIconLengt
        end
    else
        NewPetIndex = self.CurrentPetIndex - 1
        if NewPetIndex <= 0 then
            return
        end
    end
    self:RemoveTimer("RefreshPetIconTimer")
    self.PageTurner:SwtichPagePointAnimation(NewPetIndex)
    self:UpdateGuideInfo(NewPetIndex)
end

function WBP_BattlePass_Book_C:UpdateGuideInfo(NewIndex)
    if self.CurrentPetIndex == NewIndex then
        return
    end
    self.CurrentPetIndex = NewIndex
    if self.CurrentPetIndex <= self.PetIconLengt then
        local ImgMat = self.Img_Show:GetDynamicMaterial()
        ImgMat:SetTextureParameterValue("IconTex", self.PetIconList:Get(self.CurrentPetIndex))
        -- self.Img_Show:SetBrushResourceObject(self.PetIconList[self.CurrentPetIndex])
        -- self.Img_Show_Shadow:SetBrushResourceObject(self.PetIconList[self.CurrentPetIndex])
    end
    self:PlayAnimation(self.Img_Show_In)
end

function WBP_BattlePass_Book_C:ClearBindEventAndTimer()
    self:UnbindAllFromAnimationFinished(self.Img_Show_In)
    self:UnbindAllFromAnimationFinished(self.Img_Show_Out)
    self:UnbindAllFromAnimationFinished(self.ProgressPrompt)
    self:RemoveTimer("RefreshPetIconTimer")
    self:RemoveLevelBarTimer()
end

function WBP_BattlePass_Book_C:PlayInAnim()
    if self:IsAnimationPlaying(self.Out) then
        self:StopAnimation(self.Out)
    end
    if self:IsAnimationPlaying(self.In) then
        self:StopAnimation(self.In)
    end
    self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    AudioManager(self):PlayUISound(self, "event:/ui/common/battle_pass_page_daily_in", nil, nil)
    self:PlayAnimation(self.In)
    self.CurrentPetIndex = 1
    local ImgMat = self.Img_Show:GetDynamicMaterial()
    ImgMat:SetTextureParameterValue("IconTex", self.PetIconList:Get(self.CurrentPetIndex))
    -- self.Img_Show:SetBrushResourceObject(self.PetIconList[self.CurrentPetIndex])
    -- self.Img_Show_Shadow:SetBrushResourceObject(self.PetIconList[self.CurrentPetIndex])
    self:PlayAnimation(self.Img_Show_In)
    self:PlayAnimation(self.ShowDesc_In)
end

function WBP_BattlePass_Book_C:PlayOutAnim()
    if not self.BindOutAnimation then
        self:BindToAnimationFinished(self.Out, {self,function()
            self:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        })
        self.BindOutAnimation = true
    end
    if self:IsAnimationPlaying(self.In) then
        self:StopAnimation(self.In)
    end
    self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self:PlayAnimation(self.Out)
end

function WBP_BattlePass_Book_C:PlaySwitchStateAnim(TabId)
    if TabId == "BattlePassReward" then
        if self:IsAnimationPlaying(self.SwitchTab_In) then
            self:StopAnimation(self.SwitchTab_In)
        end
        self:PlayAnimation(self.SwitchTab_Back)
    elseif TabId == "BattlePassMission" then
        if self:IsAnimationPlaying(self.SwitchTab_Back) then
            self:StopAnimation(self.SwitchTab_Back)
        end
        self:PlayAnimation(self.SwitchTab_In)
    end
end

function WBP_BattlePass_Book_C:PlaySwitchAnim()
    if self:IsAnimationPlaying(self.SwitchTab) then
        self:StopAnimation(self.SwitchTab)
    end
    self:PlayAnimation(self.SwitchTab)
end

function WBP_BattlePass_Book_C:ShowUITip()
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_BattlePass_Oversea_PurchaseLocked"))
end

-- 实际执行购买/查看战令面板（内部方法）
function WBP_BattlePass_Book_C:DoOpenPurchase()
    AudioManager(self):PlayUISound(self, "event:/ui/common/battle_pass_btn_click_special", nil, nil)

    local PurchasePanel = UIManager(self):GetUIObj("BattlePassPurchase")

        if PurchasePanel then
            UIManager(self):UnLoadUI("BattlePassPurchase")
            PurchasePanel = nil
        end

        if nil == PurchasePanel then
            PurchasePanel = UIManager(self):LoadUINew("BattlePassPurchase", BattlePassController:GetModelData("ActorController"), 666)
            DebugPrint("gmy@WBP_BattlePass_Book_C WBP_BattlePass_Book_C:OpenPurchase")
            if BattlePassController:GetModelData("ActorController") then
                BattlePassController:GetModelData("ActorController"):SetMontageAndCamera(CommonConst.ArmoryType.Char, "Skin", CommonConst.ArmoryTag.Appearance, "Purchase")
            end
        end
end

-- 入口：打开购买/查看战令面板
function WBP_BattlePass_Book_C:OpenPurchase()
    self:DoOpenPurchase()
end

-- 实际展示购买等级弹窗（内部方法）
function WBP_BattlePass_Book_C:DoOpenPurchaseDialog()
    AudioManager(self):PlayUISound(self, "event:/ui/common/battle_pass_btn_click_normal", nil, nil)
    local CurLoopMaxLevel = BattlePassUtils:GetCurLoopMaxLevel()
    local Params =
    {
        RightCallbackObj = self,
        RightCallbackFunction = self.StartBuyLevel,
        ShortText = string.format(GText("UI_BattlePass_BuyLevel")),

        -- 自定义参数
        MinLevel = 1,
        MaxLevel = CurLoopMaxLevel - self.CurLevel,

        Funds =
        {
            {
                FundId = DataMgr.GlobalConstant.BattlePassBuyLvMoney.ConstantValue,
                FundNeed = DataMgr.GlobalConstant.BattlePassBuyLvPrice.ConstantValue,
            }
        },
        SupportLSFocus = true,

        CurrencyGamepadKey = "LS"
    }
    self.PurchaseDialog = UIManager(self):ShowCommonPopupUI(BATTLE_PASS_LEVEL_PURCHASE_POPUP, Params)
end

-- 入口：购买等级（带临期提醒）
function WBP_BattlePass_Book_C:OpenPurchaseDialog()
    BattlePassUtils:TryOpenWithEndTimeReminder(self, function()
        self:DoOpenPurchaseDialog()
    end)
end

function WBP_BattlePass_Book_C:StartBuyLevel(Res)
    DebugPrint("gmy@WBP_BattlePass_Book_C M:StartBuyLevel", Res and Res.BattlePass and Res.BattlePass.Level)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local FundId = DataMgr.GlobalConstant.BattlePassBuyLvMoney.ConstantValue
        local Resource = Avatar.Resources[FundId] or {Count = 0}
        local AvatarCount = Resource.Count
        local NeedLevel = (Res and Res.BattlePass and Res.BattlePass.Level) or 1
        local NeedCount = DataMgr.GlobalConstant.BattlePassBuyLvPrice.ConstantValue * NeedLevel
        local NeedTransformCount = NeedCount - AvatarCount
        if AvatarCount < NeedCount then
            -- 检查Coin4是否足够
            local Coin4 = Avatar.Resources[CommonConst.Coins.Coin4]
            local Coin4Count = Coin4 and Coin4.Count or 0
            if Coin4Count < NeedTransformCount then
                -- 都不足, 跳转到商城界面
                local CostType = CommonConst.Coins.Coin4
                local CostNum = NeedTransformCount
                UIManager(self):LoadUINew("ShopTargetPay", {
                    CostNum = CostNum,
                    CostType = CostType,
                    RightCallbackObj = self,
                    CallbackInfo = {
                        Func = function(GoodsId, ShopItems, OrderId)
                            if not self or not IsValid(self) then return end
                            self:StartBuyLevel(Res)
                        end,
                        Obj = self,
                    }
                })
            else
                -- Coin4足，则跳转到兑换弹窗
                local ItemList = {}
                table.insert(ItemList,{ItemId = CommonConst.Coins.Coin4,
                                       ItemType = CommonConst.ItemType.Resource,
                                       ItemNum = Coin4Count,
                                       ItemNeed = NeedTransformCount})
                local PopUpId =  BATTLE_PASS_LACK_COIN1_POPUP
                local ResourceData = DataMgr.Resource[FundId]
                local PopoverText = GText(DataMgr.CommonPopupUIContext[PopUpId].PopoverText)
                
                -- TODO@GMY: 应该改为string.format字符串, 但我没时间改
                if string.find(PopoverText,'&ResourceName&') then
                    PopoverText = string.gsub(PopoverText,'&ResourceName&',GText(ResourceData.ResourceName))
                end
                if string.find(PopoverText,'&ResourceName1&') then
                    PopoverText = string.gsub(PopoverText,'&ResourceName1&',GText(DataMgr.Resource[CommonConst.Coins.Coin4].ResourceName))
                end
                if string.find(PopoverText,'&ResourceName2&') then
                    PopoverText = string.gsub(PopoverText,'&ResourceName2&',GText(ResourceData.ResourceName))
                end
                if string.find(PopoverText,'&Num1&') then
                    PopoverText = string.gsub(PopoverText,'&Num1&',NeedTransformCount)
                end
                if string.find(PopoverText,'&Num2&') then
                    PopoverText = string.gsub(PopoverText,'&Num2&',NeedTransformCount)
                end
                local Params = {
                    RightCallbackFunction = function()
                        Avatar:TransformCoin4ToCoin1(NeedTransformCount, function(Count)
                            DebugPrint("gmy@WBP_BattlePass_Book_C WBP_BattlePass_Book_C:StartBuyLevel Callback", Count)
                            self:OpenPurchaseDialog()
                            self:AddTimer(0.2, function()
                                UIUtils.ShowGetItemPageAndOpenBagIfNeeded("Resource", FundId, Count, nil, false, nil, self, false)
                            end,false,0,"ShowGetItemPageTimer",true)
                        end)
                    end,
                    ItemList = ItemList,
                    ShortText = PopoverText
                }
                self.PopupUI = UIManager(self):ShowCommonPopupUI(PopUpId,Params)
            end
        else
            if Res and Res.BattlePass and Res.BattlePass.Level then
                local Level = Res.BattlePass.Level
                Avatar:BattlePassBuyLevel(Level, function()
                    -- TODO@gyy 在这里刷新战令等级等状态
                    DebugPrint("gmy@WBP_BattlePass_Book_C WBP_BattlePass_Book_C:StartBuyLevel Callback")
                end)
            end
        end
    end
end

function WBP_BattlePass_Book_C:GetMaxLevel()
    return BattlePassUtils:GetMaxLevel()
end

function WBP_BattlePass_Book_C:OnAddedToFocusPath(InFocusEvent)
    if self.PlayLevelUp then
        self:PlayLevelUpAnimation(self.ExpandedMaxLevel)
        self.ExpandedMaxLevel = nil
    end
    if self.NeedShowAutoGetPopupUI then
        self:ShowAutoGetPopupUI()
    end
    if self.PlayUnlock and BattlePassController:GetModelData("CurTabId") == "BattlePassReward" then
        self:PlayUnlockAnimation()
    end
end

function WBP_BattlePass_Book_C:OnBattlePassAutoGetTaskReward()
    self:TryShowAutoGetPopupUI()
end

function WBP_BattlePass_Book_C:CheckBattlePassAutoGetTaskReward()
    if self.Avatar.BattlePassAutoGetTaskReward then
        self:TryShowAutoGetPopupUI()
    end
end

function WBP_BattlePass_Book_C:TryShowAutoGetPopupUI()
    if not self.ShowingPopupUI then
        if UIUtils.HasAnyFocus(self) then
            self:ShowAutoGetPopupUI()
        else
            self.NeedShowAutoGetPopupUI = true
        end
    end
end

function WBP_BattlePass_Book_C:ShowAutoGetPopupUI()
    self:BlockAllUIInput(true,"SP_DisplayOnly")
    local bBlockInput = true
    if not self:IsExistTimer("ShowAutoGetPopupUITimer") then
        self:AddTimer(0.5,function ()
            self.Avatar:CallServer("BattlePassAutoGetTaskRewardDetail",function (ErrCode,Rewards)
                DebugPrint("BattlePassAutoGetTaskRewardDetail Callback", ErrCode, Rewards)
                self:BlockAllUIInput(false)
                bBlockInput = false
                self.NeedShowAutoGetPopupUI = false
                if ErrorCode:Check(ErrCode) then
                    self.ShowingPopupUI = true
                    self:ShowGetItemPage(Rewards, false, function ()
                        self.ShowingPopupUI = false
                        self:SetFocus()
                    end, self)
                end
            end)
        end,false,0,"ShowAutoGetPopupUITimer",true)
        self:AddTimer(5,function ()
            if bBlockInput then
                self:BlockAllUIInput(false)
                bBlockInput = false
                self.NeedShowAutoGetPopupUI = false
            end
        end,false,0,"CancelBlockInputTimer",true)
    end
end

function WBP_BattlePass_Book_C:TryClosePopupUI()
    if IsValid(self.BattlePassPetCanClaimPopupUI) then
        self.BattlePassPetCanClaimPopupUI:Close()
    end
    if IsValid(self.PurchaseDialog) then
        self.PurchaseDialog:Close()
    end
    if IsValid(self.JumpToShopPopupUI) then
        self.JumpToShopPopupUI:Close()
    end
    if IsValid(self.PopupUI) then
        self.PopupUI:Close()
    end
end

function WBP_BattlePass_Book_C:AddLevelBarTimer()
    if not self.LevelBarTimer then
        AudioManager(self):PlayUISound(self, "event:/ui/common/battle_pass_exp_bar_grow", "LevelBarUpSound", nil)
        self.LevelBarTimer = self:AddTimer(0.01,self.SetLevelBarLerp,true,0,"LevelBarTimer",true,0.01)
    end
end

function WBP_BattlePass_Book_C:RemoveLevelBarTimer()
    if self.LevelBarTimer then
        AudioManager(self):SetEventSoundParam(self, "LevelBarUpSound", {ToEnd=1})
        AudioManager(self):StopSound(self, "LevelBarUpSound")
        self:RemoveTimer(self.LevelBarTimer)
        self.LevelBarTimer = nil
    end
end

function WBP_BattlePass_Book_C:GetAllReward()
    if BattlePassController:GetModelData("CurTabId") == "BattlePassReward" then
        self:GetAllBattlePassReward()
    elseif BattlePassController:GetModelData("CurTabId") == "BattlePassMission" then
        self:GetAllMissionReward()
    end
end

function WBP_BattlePass_Book_C:EnterState_Default()
    local Index = 1
    if self.HaveGetAllTip then
        Index = 2
    end
    if self.LastState then
        table.remove(self.BottomKeyInfo, Index)
    end
    self.Parent:UpdateBottomKeyInfo(self.BottomKeyInfo)
end

function WBP_BattlePass_Book_C:EnterState_FocusItemCantGet()
    local Index = 1
    if self.HaveGetAllTip then
        Index = 2
    end
    if self.LastState and self.LastState ~= FSMStates.Default then
        table.remove(self.BottomKeyInfo, Index)
    end
    table.insert(self.BottomKeyInfo, Index, {
        GamePadInfoList = {{Type="Img", ImgShortPath="A"}},
        Desc = GText("UI_Controller_CheckDetails"),
        bLongPress = false
    })
    self.Parent:UpdateBottomKeyInfo(self.BottomKeyInfo)
end

function WBP_BattlePass_Book_C:EnterState_FocusItemCanGet()
    local Index = 1
    if self.HaveGetAllTip then
        Index = 2
    end
    if self.LastState and self.LastState ~= FSMStates.Default then
        table.remove(self.BottomKeyInfo, Index)
    end
    table.insert(self.BottomKeyInfo, Index, {
        GamePadInfoList = {{Type="Img", ImgShortPath="A"}},
        Desc = GText("UI_BattlePass_QuestRewardClaim"),
        bLongPress = false
    })
    self.Parent:UpdateBottomKeyInfo(self.BottomKeyInfo)
end

function WBP_BattlePass_Book_C:OnFocusItemChanged(bCanGet, IsLoopEmpty)
    self.LastState = self.ControllerFSM:Current()
    if IsLoopEmpty then
        self.ControllerFSM:Enter(FSMStates.Default)
    elseif bCanGet then
        self.ControllerFSM:Enter(FSMStates.FocusItemCanGet)
    else
        self.ControllerFSM:Enter(FSMStates.FocusItemCantGet)
    end
end

function WBP_BattlePass_Book_C:OnLeaveRewardTab()
    self.LastState = self.ControllerFSM:Current()
    self.ControllerFSM:Enter(FSMStates.Default)
end

function WBP_BattlePass_Book_C:OpenTips(Widget)
    self.IsTipMode = true
    self.OpenTipsWidget = Widget
    Widget:OpenTips()
end

function WBP_BattlePass_Book_C:TryCloseTips()
    if self.OpenTipsWidget then
        self.OpenTipsWidget:CloseTips()
        if self.CurFocusedItem then
            self.List_Reward:BP_NavigateToItem(self.CurFocusedItem.Content)
        else
            self:NavigateToFirstDisplayedItem(self.List_Reward)
        end
    end
    self.IsTipMode = false
    self.OpenTipsWidget = nil
end

function WBP_BattlePass_Book_C:ShowGetItemPage(PurchaseRewards, func, ParentWidget)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    UIManager:LoadUINew("BattlePassAutoGetItemPage", PurchaseRewards, func, ParentWidget)
end

return WBP_BattlePass_Book_C
