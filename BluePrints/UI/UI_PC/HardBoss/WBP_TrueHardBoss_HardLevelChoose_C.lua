--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local EMCache = require "EMCache.EMCache"

local WBP_TrueHardBoss_HardLevelChoose_C = Class("BluePrints.UI.BP_UIState_C")
local SelectedIndex = {}

function WBP_TrueHardBoss_HardLevelChoose_C:Construct()
    self.Super.Construct(self)

    self:AddDispatcher(EventID.TeamMatchTimingStart, self, self.TeamMatchTimingStart)
    self:AddDispatcher(EventID.TeamMatchTimingEnd, self, self.TeamMatchTimingEnd)

    self.List_BossLevels.BP_OnItemSelectionChanged:Add(self, self.OnSelectItemChanged)

    --self.List_BossLevels:SetNavigationRuleCustom(EUINavigation.Right,{self,self.OnUINavigation})

    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
    self:InitListenEvent()
    self:InitWidgetInfoInGamePad()
end

function WBP_TrueHardBoss_HardLevelChoose_C:Destruct()
    print(_G.LogTag,"gyy HardLevelChoose Destruct")
    self.Super.Destruct(self)
end

function WBP_TrueHardBoss_HardLevelChoose_C:Initialize(Initializer)
    self.Super.Initialize(self)
    self.HardBossId = nil
    self.LastIsLocked = nil
    self.IsLocked = nil
    self.Flag = nil
    self.SelectFirstTimeFinish = false
end

function WBP_TrueHardBoss_HardLevelChoose_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    local ExtraInfo = ...
    local HardBossId = ExtraInfo.HardBossId
    self.HardBossId = HardBossId
    self.Common_Button_Close_PC:BindEventOnClicked(self, self.OnClickClose)
    self.Common_Button_Close_PC.SoundFunc = self.CloseSound
    self.Common_Button_Text_PC.SoundFunc = self.ChallengeSound
    self.Btn_Coop.SoundFunc = self.ChallengeSound
    self:PlayInAnim()

    local AttachWidget = self:GetAttachWidget()
    if not self.TeamHeadUI then
        self.TeamHeadUI = TeamController:OpenHeadUI2(AttachWidget)
        self.TeamHeadUI.OnTeamMainFocusChanged = function(bFocused)
            local Visibility = bFocused and "Collapsed" or "SelfHitTestInvisible"
            local KeyWidgets = {
                self.Btn_Coop.Key_GamePad,
                self.Common_Button_Text_PC.Key_GamePad,
                self.Key_BossRewards,
            }
            for _, KeyWidget in ipairs(KeyWidgets) do
                KeyWidget:SetVisibility(UIConst.VisibilityOp[Visibility])
            end
        end
    end
end

function WBP_TrueHardBoss_HardLevelChoose_C:GetAttachWidget()
    local AttachWidget = self.Group_Team
    AttachWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    return AttachWidget
end

function WBP_TrueHardBoss_HardLevelChoose_C:PlayInAnim()
    if (self:IsAnimationPlaying(self.Out)) then
        self:UnbindAllFromAnimationFinished(self.Out)
    end
    self:RefreshOtherInfo()
    self:InitBossIcon()
    self:InitRewardTimesInfo()
    self:InitListBossInfo()
    self:BindToAnimationFinished(self.In, {self, function ()
        self:UnbindAllFromAnimationFinished(self.In)
        self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self:SetFocus()
        self:FocusOnFirstItem()
    end})
    self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self:PlayAnimationForward(self.In)
end

function WBP_TrueHardBoss_HardLevelChoose_C:RefreshOtherInfo()
    --self.Common_Button_Text_PC:SetIconPanelVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Common_Button_Text_PC:BindEventOnClicked(self, self.OnClickChallenge)
    self.Common_Button_Text_PC:BindForbidStateExecuteEvent(self, self.OnClickChallengeForbid)
    --self.Common_Button_Text_PC:OverrideGamePadVisibility(UIConst.VisibilityOp.Collapsed)
    self.Common_Button_Text_PC:SetText(GText("UI_HardBoss_Start"))

    --self.Btn_Coop:SetIconPanelVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Coop:BindEventOnClicked(self, self.OnClickChallenge_Multi)
    self.Btn_Coop:BindForbidStateExecuteEvent(self, self.OnClickChallengeForbid)
    self.Btn_Coop:SetText(GText("DUNGEONMATCH_START"))
    self.Text_BossRewards:SetText(GText("UI_HardBoss_Preview"))
    self.Text_DetailTips:SetText(GText("UI_HardBoss_FirstTime"))
end

function WBP_TrueHardBoss_HardLevelChoose_C:InitRewardTimesInfo()
    local Text = GText("UI_HardBoss_ChancesRemain")
    local RemainTimes = 0
    local TotalTimes = DataMgr.GlobalConstant.BossRewardRefresh.ConstantValue
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        RemainTimes = Avatar.HardBoss.HardBossRewardTimesLeft
    end
    if(RemainTimes <= 0) then
        Text = Text.."<Warning>"..RemainTimes.."/"..math.floor(TotalTimes).."</>"
    else
        Text = Text..RemainTimes.."/"..math.floor(TotalTimes)
    end
    self.Text_RewardTips:SetText(Text)
end

function WBP_TrueHardBoss_HardLevelChoose_C:InitListBossInfo()
    local BtnInfo = DataMgr.HardBossMain
    self.Text_BossName:SetText(GText(BtnInfo[self.HardBossId].HardBossName))
    local DifficultyIdTab = BtnInfo[self.HardBossId].DifficultyId
    local ClassPath = '/Game/UI/UI_PC/Common/Common_Item_subsize_PC_Content.Common_Item_subsize_PC_Content_C'
    if SelectedIndex[self.HardBossId] then
        self.Flag = false
    else
        self.Flag = true
    end
    local Index = 1
    for i,DifficultyId in ipairs(DifficultyIdTab) do
        local LevelChooseObj = NewObject(UE4.LoadClass(ClassPath))
        LevelChooseObj.Id = DifficultyId
        LevelChooseObj.Index = Index
        LevelChooseObj.Parent = self
        LevelChooseObj.SelectedIndex = SelectedIndex
        LevelChooseObj.NumberOfChoices = #DifficultyIdTab
        Index = Index + 1
        self.List_BossLevels:AddItem(LevelChooseObj)
    end
end

function WBP_TrueHardBoss_HardLevelChoose_C:SelectFirstTime()
    if not self.SelectFirstTimeFinish then
        self.SelectFirstTimeFinish = true
        local CurSelectLevelContent = self.List_BossLevels:GetItemAt(math.max(SelectedIndex[self.HardBossId] - 1, 0))
        CurSelectLevelContent.Entry:OnCellClickedWithoutSound()
    end
end

function WBP_TrueHardBoss_HardLevelChoose_C:RefreshListBossInfo(Index)
    self:LeaveSelectMode()
    self:PlayAnimation(self.ClickRefresh)
    if(self.CurDifficultyId and SelectedIndex[self.HardBossId] ~= nil) then
        local CurSelectBossContent = self.List_BossLevels:GetItemAt(math.max(SelectedIndex[self.HardBossId] - 1, 0))
        local Entry = CurSelectBossContent.Entry
        CurSelectBossContent.IsSelect = false
        Entry:StopAllAnimations()
        if Entry.Content.IsLocked then
            Entry:PlayAnimation(Entry.Lock_Normal)
        else
            Entry:PlayAnimation(Entry.Normal)
        end
    end
    SelectedIndex[self.HardBossId] = Index
    local CurSelectLevelContent = self.List_BossLevels:GetItemAt(math.max(SelectedIndex[self.HardBossId] - 1, 0))
    self.List_BossLevels:BP_NavigateToItem(CurSelectLevelContent)
    local AllDifficultyInfo = DataMgr.HardBossDifficulty
    local DifficultyInfo = AllDifficultyInfo[CurSelectLevelContent.Id]
    self.CurDifficultyId = DifficultyInfo.DifficultyID
    self.CurSelectDifficultyLevel = DifficultyInfo.DifficultyLevel
    self.CurUnlockCondition = DifficultyInfo.UnlockCondition
    self.LastIsLocked = self.IsLocked
    self.IsLocked = CurSelectLevelContent.IsLocked
    self.Text_BossLevel:SetText(GText(DifficultyInfo.DifficultyDesOpen))
    self.Text_BossLv:SetText(GText("BATTLE_UI_BLOOD_LV")..self.CurSelectDifficultyLevel)
    self.Text_BossDetail:SetText(GText(DifficultyInfo.DifficultyDes))
    self.Text_LockTips:SetText(string.format(GText("UI_HardBoss_Unlocklevel"), self.CurSelectDifficultyLevel))
    local ImagePath = DifficultyInfo.ImgPath
    if ImagePath ~= nil then
        local ImageObject = LoadObject(ImagePath)
        local ImgMat = self.Image_LinShiImage:GetDynamicMaterial()
        ImgMat:SetTextureParameterValue("IconMap", ImageObject)
    end
    if self.IsLocked then
        self.Group_LockTips:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Group_DetailTips:SetVisibility(UE4.ESlateVisibility.Collapsed)
        -- self.Btn_Coop:ForbidBtn(true)
        -- self.Common_Button_Text_PC:ForbidBtn(true)
        -- self.Common_Button_Text_PC.IsForbidden = true
        -- self.Btn_Coop.IsForbidden = true
        -- if self.LastIsLocked ~= self.IsLocked then
        --     self.Common_Button_Text_PC:PlayButtonForbidAnim()
        --     self.Btn_Coop:PlayButtonForbidAnim()
        -- end
    else
	    local Avatar = GWorld:GetAvatar()
	    if Avatar and Avatar.HardBoss:GetPassCount(self.CurDifficultyId) == 0 then
	        self.Group_DetailTips:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
	    else
	        self.Group_DetailTips:SetVisibility(UE4.ESlateVisibility.Collapsed)
	    end

        self.Group_LockTips:SetVisibility(UE4.ESlateVisibility.Collapsed)
        -- self.Btn_Coop:ForbidBtn(false)
        -- self.Common_Button_Text_PC:ForbidBtn(false)
        -- self.Common_Button_Text_PC.IsForbidden = false
        -- self.Btn_Coop.IsForbidden = false
        -- if self.LastIsLocked ~= self.IsLocked then
        --     self.Common_Button_Text_PC:PlayButtonUnForbidAnim()
        --     self.Btn_Coop:PlayButtonUnForbidAnim()
        -- end
    end
    self:RefreshBtnState()
    self:RefreshRewardsList(DifficultyInfo)
end

function WBP_TrueHardBoss_HardLevelChoose_C:RefreshRewardsList(DifficultyInfo)
    self.ListView_Rewards:ClearListItems()

    local RewardViewId = nil
    local DynamicRewardInfo = UIUtils.GetDynamicRewardInfo(DifficultyInfo.DifficultyReward)
    if DynamicRewardInfo then
        RewardViewId = DynamicRewardInfo.RewardView
    end

    if RewardViewId then
        self.Group_Title_Rewards:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.ListView_Rewards:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        local RewardInfo = DataMgr.RewardView[RewardViewId]
        local Ids = RewardInfo.Id or {}
        local RewardCount = RewardInfo.Quantity or {}
        local TableName = RewardInfo.Type or {}
        for i = 1, #Ids do
            local Content = NewObject(UIUtils.GetCommonItemContentClass())
            local ItemId = Ids[i]
            Content.UIName = "HardBossLevelChoose"
            Content.IsShowDetails = true
            Content.Id = ItemId
            if RewardCount[i] then
                if #RewardCount[i] > 1 then
                    Content.MaxCount = RewardCount[i][2]
                end
                Content.Count = RewardCount[i][1]
            end
            Content.Icon = ItemUtils.GetItemIconPath(ItemId, TableName[i])
            Content.Rarity = ItemUtils.GetItemRarity(ItemId, TableName[i])
            Content.ItemType = TableName[i]
            self.ListView_Rewards:AddItem(Content)
        end
    else
        self.Group_Title_Rewards:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.ListView_Rewards:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function WBP_TrueHardBoss_HardLevelChoose_C:ChallengeSound()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
end

function WBP_TrueHardBoss_HardLevelChoose_C:OnClickChallenge()
    local Avatar = GWorld:GetAvatar()
    local RemainTimes = Avatar.HardBoss.HardBossRewardTimesLeft or 0
    local IsNoMorePrompts = EMCache:Get("IsBossBattlePopupNoMorePrompts", true) or false
    if RemainTimes > 0 or IsNoMorePrompts or (Avatar and Avatar.HardBoss:GetPassCount(self.CurDifficultyId) == 0) then
        self:BeginBossBattle()
    else
        self:ShowConfirmWindow()
    end
end

function WBP_TrueHardBoss_HardLevelChoose_C:OnClickChallengeForbid()
    local Avatar = GWorld:GetAvatar()
    ConditionUtils.CheckCondition(Avatar, self.CurUnlockCondition, true)
end

function WBP_TrueHardBoss_HardLevelChoose_C:BeginBossBattle()
    local Avatar = GWorld:GetAvatar()
    local bIsInTeam = Avatar:IsInTeam()
    if bIsInTeam then
        TeamController:GetModel().bPressedSolo = true
        local DungeonId = self:GetCurDungeonId()
        if not DungeonId then
            return
        end
        self:TryEnterDungeon(Avatar, DungeonId, CommonConst.DungeonNetMode.Standalone,
            function(RetCode, ...)
                local bCanEnter = self.HandleEnterDungeonRetCode(RetCode, ...)

                if bCanEnter then
                    UIManager(self):LoadUINew("DungeonMatchTimingBar",
                    DungeonId, Const.DUNGEON_MATCH_BAR_STATE.SPONSOR_WAITING_CONFIRM, false)
                end
            end)
        self:RefreshBtnState()
    else
        self:EnterHardBoss_Solo()
    end
end

function WBP_TrueHardBoss_HardLevelChoose_C:TryEnterDungeon(Avatar, DungeonId, DungeonNetMode, OtherCallback, TicketId)
    if self:DoCheckCanEnterDungeon(Avatar, DungeonId) then
        DebugPrint("TryEnterDungeon ", Avatar, DungeonId, DungeonNetMode, OtherCallback, TicketId)
        Avatar:EnterDungeon(DungeonId, DungeonNetMode, OtherCallback, TicketId)
    else
        TeamController:GetModel().bPressedSolo = false
        TeamController:GetModel().bPressedMulti = false
    end
end

function WBP_TrueHardBoss_HardLevelChoose_C:DoCheckCanEnterDungeon(Avatar, DungeonId)
    if not TeamController:DoCheckCanEnterDungeon(DungeonId) then
        DebugPrint("DoCheckCanEnterDungeon bTeammateNotReady")
        return false
    end

    return true
end

function WBP_TrueHardBoss_HardLevelChoose_C:EnterHardBoss_Solo()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        if not self.IsLocked then
            local function Callback (Ret)
                if ErrorCode:Check(Ret) then
                    print(_G.LogTag,"gyy BeginBossBattle Succ")
                    self:Close(false)
                else
                    print(_G.LogTag,"gyy BeginBossBattle Fail")
                    self:Close(true)
                end
            end
            print(_G.LogTag,"gyy BeginBossBattle")
            self:BlockAllUIInput(true)
            Avatar:EnterHardBoss(self.HardBossId, self.CurDifficultyId, Callback)
        end
    end
end

function WBP_TrueHardBoss_HardLevelChoose_C:RefreshBtnState(bInIsMatching)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end

    local UIUnlockRuleId = DataMgr.UIUnlockRule.Match.UIUnlockRuleId
    local bIsUnlock      = Avatar:CheckUIUnlocked(UIUnlockRuleId) or false

    local IsMatching = bInIsMatching
    if IsMatching == nil then
        IsMatching = self:IsMatching()
    end

    if IsMatching then
        self.Btn_Coop:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Common_Button_Text_PC:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Btn_Coop:ForbidBtn(true)
        self.Common_Button_Text_PC:ForbidBtn(true)
        self.List_BossLevels:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        self.Btn_Coop:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Common_Button_Text_PC:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.List_BossLevels:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        if self.IsLocked then
            self.Btn_Coop:ForbidBtn(true)
            self.Common_Button_Text_PC:ForbidBtn(true)
        else
            self.Btn_Coop:ForbidBtn(false)
            self.Common_Button_Text_PC:ForbidBtn(false)
        end
    end
    -- Dungeon表新增 bDisableMatch ,表示是否屏蔽匹配按钮
    local CurSelectedDungeonId = self:GetCurDungeonId()
    if CurSelectedDungeonId then
        local CurSelectedDungeonData = DataMgr.Dungeon[CurSelectedDungeonId]
        if CurSelectedDungeonData and CurSelectedDungeonData.bDisableMatch then
            self.Btn_Coop:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
end

function WBP_TrueHardBoss_HardLevelChoose_C:IsMatching()
    return TeamController:GetModel():IsMatching()
end

function WBP_TrueHardBoss_HardLevelChoose_C.HandleEnterDungeonRetCode(RetCode, ...)
    DebugPrint("WBP_TrueHardBoss_HardLevelChoose_C.EnterDungeonCallback RetCode", RetCode)

    --ErrorCode:Check(RetCode)
    if RetCode == ErrorCode.RET_SUCCESS then
        return true
    else
        TeamController:DoWhenEnterDungeonCheckFailed(RetCode, ...)
        EventManager:FireEvent(EventID.TeamMatchTimingEnd)
        return false
    end
end

function WBP_TrueHardBoss_HardLevelChoose_C:OnClickChallenge_Multi()
    local Avatar = GWorld:GetAvatar()
    assert(Avatar, "NO AVATAR")

    if not Avatar:CheckUIUnlocked("Match") then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(DataMgr.UIUnlockRule.Match.UIUnlockDesc))
        return
    end
    local DungeonId = self:GetCurDungeonId()
    if not DungeonId then
        return
    end
    if not PageJumpUtils:CheckDungeonCondition(DataMgr.Dungeon[DungeonId].Condition) then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Tosat_Level_Locked"))
        return
    end
    if self:IsAnimationPlaying(self.Out_Loading) then
        return
    end
    self:TryEnterMultiDungeon(DungeonId)
end

function WBP_TrueHardBoss_HardLevelChoose_C:TryEnterMultiDungeon(DungeonId)
    -- 请求进入副本
    TeamController:GetModel().bPressedMulti = true
    local Avatar = GWorld:GetAvatar()
    assert(Avatar, "NO AVATAR")
    self:TryEnterDungeon(Avatar, DungeonId, CommonConst.DungeonNetMode.DedicatedServer,
        function(RetCode, ...)
            local bCanEnter = self.HandleEnterDungeonRetCode(RetCode, ...)
            DebugPrint("@WBP_TrueHardBoss_HardLevelChoose_C M:OnClickMulti", bCanEnter)

            if bCanEnter then
                local bIsInTeam = Avatar:IsInTeam()

                if bIsInTeam then
                    UIManager(self):LoadUINew("DungeonMatchTimingBar",
                    DungeonId, Const.DUNGEON_MATCH_BAR_STATE.SPONSOR_WAITING_CONFIRM, true)
                else
                    UIManager(self):LoadUINew("DungeonMatchTimingBar",
                    DungeonId, Const.DUNGEON_MATCH_BAR_STATE.WAITING_MATCHING_WITH_CANCEL, true)
                end
            end
        end,self.TicketId)
    self:RefreshBtnState()
end

function WBP_TrueHardBoss_HardLevelChoose_C:ShowConfirmWindow()
    local CommonDialogParams = {}
    CommonDialogParams.RightCallbackFunction = function(_, Data, PopupUI)
        PopupUI.DontPlayOutAnimation = true
        self:BeginBossBattle()
        self:UpdateSelectedInfo(Data)
    end
    CommonDialogParams.LeftCallbackFunction = function(_, Data, PopupUI)
        PopupUI.DontPlayOutAnimation = false
        self:UpdateSelectedInfo(Data)
    end

    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    UIManager:ShowCommonPopupUI(Const.Popup_SecondConfirm, CommonDialogParams, self)
end

function WBP_TrueHardBoss_HardLevelChoose_C:UpdateSelectedInfo(Data)
    local IsSelected = Data.SelectHint.IsSelected
    EMCache:Set("IsBossBattlePopupNoMorePrompts", IsSelected, true)
end

function WBP_TrueHardBoss_HardLevelChoose_C:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName == UIConst.GamePadKey.SpecialRight then
            if self.TeamHeadUI then
                self.TeamHeadUI:DoGamepadBtnPress()
                IsEventHandled = true
            end
        elseif (InKeyName == UIConst.GamePadKey.FaceButtonTop) then
            if not self.IsInSelectState then
                IsEventHandled = true
                if self.Common_Button_Text_PC.IsForbidden then
                    self:OnClickChallengeForbid()
                else
                    self:OnClickChallenge()
                end
            end
        elseif (InKeyName == UIConst.GamePadKey.FaceButtonLeft) then
            if not self.IsInSelectState then
                IsEventHandled = true
                if self.Btn_Coop.IsForbidden then
                    self:OnClickChallengeForbid()
                else
                    self:OnClickChallenge_Multi()
                end
            end
        elseif (InKeyName == UIConst.GamePadKey.RightThumb) then
            if self.ListView_Rewards:GetVisibility() ~= UIConst.VisibilityOp.Collapsed then
                IsEventHandled = true
                self:EnterSelectMode()
            end
        elseif (InKeyName == UIConst.GamePadKey.FaceButtonRight) then
            if self.TeamHeadUI and self.TeamHeadUI.bIsFocusable then
                self:FocusOnFirstItem()
            elseif self.IsInSelectState then
                IsEventHandled = true
                self:LeaveSelectMode()
            else
                IsEventHandled = true
                self:OnReturnKeyDown()
            end
		end
    else
        if (InKeyName == "Escape") then
            IsEventHandled = true
            self:OnReturnKeyDown()
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function WBP_TrueHardBoss_HardLevelChoose_C:OnKeyUp(MyGeometry, InKeyEvent)
    local ParentHandled = WBP_TrueHardBoss_HardLevelChoose_C.Super.OnKeyUp(self, MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == UIConst.GamePadKey.SpecialRight then
        if self.TeamHeadUI then
            self.TeamHeadUI:DoGamepadBtnRelease()
        end
    end
    return ParentHandled
end

function WBP_TrueHardBoss_HardLevelChoose_C:OnReturnKeyDown()
    self:Close(true, true)
end

function WBP_TrueHardBoss_HardLevelChoose_C:CloseSound()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_return", nil, nil)
end

function WBP_TrueHardBoss_HardLevelChoose_C:OnClickClose()
    self:Close(true)
end

function WBP_TrueHardBoss_HardLevelChoose_C:Close(Flag,IsEsc)
    print(_G.LogTag,"gyy HardLevelChoose Close, PlayOutAnimation:", Flag)
    if (Flag and self:IsPlayingAnimation()) then
        print(_G.LogTag,"gyy HardLevelChoose CloseFail IsPlayingAnimation")
        return
    end
    if IsEsc then
        AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "HardBossLevelChoose", nil)
    end
    self:BlockAllUIInput(true,"SP_DisplayOnly")
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
    local Player = PlayerController:GetMyPawn()
    local Eid = Player.MechanismEid
    local Mechanism = Battle(self):GetEntity(Eid)
    if Mechanism then
        print(_G.LogTag,"LXZ Close", Flag)
        Mechanism:EndInteractive(Player, true)
    end
    local AttachWidget = self:GetAttachWidget()
    if TeamController:GetHeadUI(AttachWidget) and self.TeamHeadUI then
        TeamController:GetHeadUI(AttachWidget):Close()
        AttachWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.TeamHeadUI = nil
    end
    if Flag then
        self:BindToAnimationFinished(self.Out, {self, self.CloseDirectly})
        self:PlayAnimationForward(self.Out)
    else
        self:CloseDirectly()
    end
end

function WBP_TrueHardBoss_HardLevelChoose_C:CloseDirectly()
    print(_G.LogTag,"gyy HardLevelChoose RealClose")
    self.List_BossLevels:ClearListItems()
    self.Super.Close(self)
end

function WBP_TrueHardBoss_HardLevelChoose_C:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function WBP_TrueHardBoss_HardLevelChoose_C:ClearListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    end
end

function WBP_TrueHardBoss_HardLevelChoose_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        return
    end
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
end

function WBP_TrueHardBoss_HardLevelChoose_C:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    if IsUseKeyAndMouse then
		self:InitKeyboardView()
	else
		self:InitGamepadView()
	end
end

function WBP_TrueHardBoss_HardLevelChoose_C:InitGamepadView()
    self.Common_Button_Text_PC:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Common_Button_Text_PC:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Btn_Coop:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Btn_Coop:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Key_BossRewards:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:SetFocus()
end

function WBP_TrueHardBoss_HardLevelChoose_C:InitKeyboardView()
    self:LeaveSelectMode()
    self.Common_Button_Text_PC:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Common_Button_Text_PC:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Coop:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Btn_Coop:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
    self.Key_BossRewards:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function WBP_TrueHardBoss_HardLevelChoose_C:InitWidgetInfoInGamePad()
    self.Key_BossRewards:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "RS"
            }
        }
    })
    self.Common_Button_Text_PC:SetGamePadImg("Y")
    self.Btn_Coop:SetGamePadImg("X")
end

function WBP_TrueHardBoss_HardLevelChoose_C:OnSelectItemChanged(SelectItem)
    if (not SelectItem) then
        return
    end
    if (self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad) then
        self:ClickListItemWhenSelectItemChanged(SelectItem)
    end
end

function WBP_TrueHardBoss_HardLevelChoose_C:ClickListItemWhenSelectItemChanged(Content)
    if Content.Entry then
        local Ans = Content.Entry:OnCellClicked()
        if not Ans then
            self:FocusOnFirstItem()
        end
    end
end

function WBP_TrueHardBoss_HardLevelChoose_C:BP_GetDesiredFocusTarget()
    if self.HardBossId and SelectedIndex[self.HardBossId] then
        local CurSelectLevelContent = self.List_BossLevels:GetItemAt(math.max(SelectedIndex[self.HardBossId] - 1, 0))
        return CurSelectLevelContent.Entry
    else
        return self.List_BossLevels
    end
end

function WBP_TrueHardBoss_HardLevelChoose_C:EnterSelectMode()
    if (self.IsInSelectState) then
        return
    end
    self.Key_BossRewards:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Common_Button_Text_PC:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Coop:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
    if self.TeamHeadUI and self.TeamHeadUI.Key_GamePad then
        self.TeamHeadUI.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self:SetectFirstItem(self.ListView_Rewards)
    self.IsInSelectState = true
end

function WBP_TrueHardBoss_HardLevelChoose_C:LeaveSelectMode()
    if not self.IsInSelectState then
        return
    end
    self.Key_BossRewards:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Common_Button_Text_PC:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Btn_Coop:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    if self.TeamHeadUI and self.TeamHeadUI.Key_GamePad then
        if (self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad) then
            self.TeamHeadUI.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else
            self.TeamHeadUI.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
    self:FocusOnFirstItem()
    self.IsInSelectState = false
end

function WBP_TrueHardBoss_HardLevelChoose_C:SetectFirstItem(List)
    -- List:SetFocus()
    if List then
        if List:GetNumItems() > 0 then
            List:NavigateToIndex(0)
        else
            List:SetFocus()
        end
    end
end

function WBP_TrueHardBoss_HardLevelChoose_C:FocusOnFirstItem()
    if self.HardBossId and SelectedIndex[self.HardBossId] then
        local CurSelectLevelContent = self.List_BossLevels:GetItemAt(math.max(SelectedIndex[self.HardBossId] - 1, 0))
        self.List_BossLevels:BP_NavigateToItem(CurSelectLevelContent)
        self:AddTimer(0.01, function()
            self.List_BossLevels:BP_NavigateToItem(CurSelectLevelContent)
        end, false, 0, "NavigateToItem")
    else
        self.List_BossLevels:SetFocus()
    end
end

-- function WBP_TrueHardBoss_HardLevelChoose_C:OnUINavigation(NavigationDirection)
--     self:EnterSelectMode()
--     return nil
-- end

function WBP_TrueHardBoss_HardLevelChoose_C:TeamMatchTimingStart(arg)
    TeamController:GetModel().bPressedSolo = true
    TeamController:GetModel().bPressedMulti = true
    self:RefreshBtnState(arg)
end

function WBP_TrueHardBoss_HardLevelChoose_C:TeamMatchTimingEnd(arg)
    TeamController:GetModel().bPressedSolo = false
    TeamController:GetModel().bPressedMulti = false
    self:RefreshBtnState(arg)
end

function WBP_TrueHardBoss_HardLevelChoose_C:InitBossIcon()
    if self.HardBossId then
        local BossIconPath = DataMgr.HardbossMain[self.HardBossId].BossIcon
        if BossIconPath then
            local BossBackGround = LoadObject(BossIconPath)
            self.Image_BossListSign:SetBrushResourceObject(BossBackGround)
        end
    end
end

function WBP_TrueHardBoss_HardLevelChoose_C:GetCurDungeonId()
    if self.CurDifficultyId then
        if not self.DifficultyId2DungeonId then
            self.DifficultyId2DungeonId = {}
            for _,HardBossDgData in pairs(DataMgr.HardBossDg) do
                if HardBossDgData.DifficultyId then
                    self.DifficultyId2DungeonId[HardBossDgData.DifficultyId] = HardBossDgData.DungeonId
                end
            end
        end
        return self.DifficultyId2DungeonId[self.CurDifficultyId]
    end
end

return WBP_TrueHardBoss_HardLevelChoose_C

