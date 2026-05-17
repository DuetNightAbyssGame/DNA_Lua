local EMCache = require "EMCache.EMCache"
local RewardBox = require "BluePrints.Client.CustomTypes.SimpleRewardBox"
local TimeUtils = require "Utils.TimeUtils"
local MiscUtils = require "Utils.MiscUtils"
local ActivityController = require "BluePrints.UI.WBP.Activity.ActivityController"

---@type WBP_DungeonSettlement_New_C
local M = Class("BluePrints.UI.BP_UIState_C")

M._components = {"BluePrints.UI.Settlement.DungeonSettlementComponent"}

-- function M:Initialize(Initializer)
-- end

-- function M:PreConstruct(IsDesignTime)
-- end

function M:Construct()
    self.GamePadPressingKeys = {}       -- 缓存当前手柄按下的键，通常OnKeyDown时设置为true，OnKeyUp时设置为false
    self.CurrentFocusType = ""          -- 记录当前聚焦的组件类型，便于 1.聚焦到某些组件时需要屏蔽其他输入 2.重新聚焦回该界面时恢复聚焦
end

-- function M:Tick(MyGeometry, InDeltaTime)
-- end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
    self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)

    --添加事件监听，当前体力更新
    self:AddDispatcher(EventID.OnChangeActionPoint, self, self.InitActionPointInfo)
    self:AddDispatcher(EventID.TeamMatchTimingStart, self, self.OnTeamMatchTimingStart)
    self:AddDispatcher(EventID.TeamMatchTimingEnd, self, self.OnTeamMatchTimingEnd)
    -- 如果有复活UI，隐藏
    local UIBattleMain = UIManager(self):GetUI("BattleMain")
    if UIBattleMain then
        UIBattleMain:HidePlayerDeadUI()
    end

    -- SpRewards 需要特殊显示的Reward，Rewards 不需要特殊显示
    -- PlayerTime 玩家体验时长, GameTime 玩法激活时间
    local LogicServerInfo, _DungeonId, _CombatData = ...
    self.IsWin, self.BattleInfo, self.Rewards, self.SpRewards, self.PlayerTime, self.GameTime = table.unpack(LogicServerInfo, 1, LogicServerInfo.n)
    self.DungeonId = _DungeonId
    self.CombatData = _CombatData
    self.IsWeeklyDungeon = self.DungeonId and DataMgr.Dungeon[self.DungeonId] and DataMgr.Dungeon[self.DungeonId].IsWeeklyDungeon
    self.IntervalTime = 1 / 15
    self.FirstDelayTime = 1 / 3 - self.IntervalTime

    self:CheckIsHardBossMode()
    self:CheckIsTempleMode()
    self:CheckIsPartyMode()
    self:CheckIsWalnutMode()
    self:CheckIsNoExpMode()
    self:CheckIsAutoNextRoundMode()
    self:CheckIsAutoBanMode()

    self.HideUITag = "DungeonSettlement"
    self.IsAllowPropInAnimation = true
    DebugPrint("DungeonSettlement: OnLoaded, IsWin", self.IsWin, "PlayerTime", self.PlayerTime, "GameTime", self.GameTime, "DungeonId", self.DungeonId)

    self.RoleItemInfos = {
        Char = {
            Widget = self.Settlement_Role
        },
        MeleeWeapon = {
            Widget = self.Settlement_Role_1
        },
        RangedWeapon = {
            Widget = self.Settlement_Role_2
        },
        Player = {
            Widget = self.Settlement_Account
        }
    }
    -- self.Settlement_Role_3.Switch_Type:SetActiveWidgetIndex(1)
    -- self.Settlement_Role_3:SetVisibility(ESlateVisibility.Visible)

    ---@type BP_PlayerCharacter_C
    self.PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    ---@type BP_SinglePlayerController_C
    self.PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    ---@type EMPlayerState
    self.PlayerState = self.PlayerController.PlayerState
    self.IsFirstFocus = true

    self:BlockAllUIInput(false)

    --self:SetFocus()

    self:InitContent()
    self:SetAllUIVisibility(true)

    if self.IsTemple then
        self:CalcTempleInfo()
    elseif self.IsParty then
        self:CalcPartyInfo()
    else
        self:CalcRoleAndRewardsInfo()
    end
    self:ShowSettlementInfo()

    AudioManager(self):PauseAllBGM()

    self:SetCharDirLight(true)

    if self.WBP_Chat_CommonEnter then
        self.WBP_Chat_CommonEnter.bInDungeonSettlement = (GWorld:GetAvatar().SettlementUidArray)
    end
end

function M:OnLoaded(...)
    M.Super.OnLoaded(self, ...)
    --设备切换监听
    self:InitDeviceInfo()
    self:InitListenEvent()
end

function M:Destruct()
    AudioManager(self):ResumeAllBGM()
    M.Super.Destruct(self)
end

function M:InitContent()
    self:InitHeadline()
    self:InitStageInfo()
    self:InitMainButtons()
    self:InitActionPointInfo()
    self:InitHardBossOrWeekyDungeonInfo()
    self:InitSwitchPanelContent()
    self:InitRewardPanel()
    self:InitPlayersHighLightData()
    self:InitDoubleModInfo()
    self:InitAutoNextRoundContent()

end

function M:InitRewardPanel()
    if self.IsTemple then
        return
    end
    DebugPrint("DungeonSettlement: Reward列表入场")
    PrintTable(self.SpRewards, 3)
    PrintTable(self.Rewards, 3)
    self.SpRewardsArray = {}-- 委托
    self.RewardsArray = {} -- 掉落物

    self:RewardsAddToArray(self.SpRewardsArray, self.SpRewards, true)
    self:RewardsAddToArray(self.RewardsArray, self.Rewards, false)
    self:SortRewardsArray(self.SpRewardsArray)
    self:SortRewardsArray(self.RewardsArray)

    if self.IsHardBoss then
        if #self.RewardsArray > 0 then
            self.Panel_Reward:SetVisibility(ESlateVisibility.Collapsed)
            self.Text_PropTitle:SetVisibility(ESlateVisibility.Collapsed)
        elseif #self.SpRewardsArray > 0 then
            self.Panel_Prop:SetVisibility(ESlateVisibility.Collapsed)
            self.Panel_Reward:SetVisibility(ESlateVisibility.Visible)
            self.Text_RewardTitle:SetVisibility(ESlateVisibility.Collapsed)
        else
            self.Switcher:SetActiveWidgetIndex(1)
        end
    else
        --现在只要两者有之一就显示
        if #self.SpRewardsArray > 0 or #self.RewardsArray > 0 then
            self.Panel_Reward:SetVisibility(ESlateVisibility.Visible)
            self.Text_RewardTitle:SetText(GText("UI_DUNGEON_ObtainType"))
            self.Panel_PropTitle:SetVisibility(ESlateVisibility.Visible)
            self.Text_PropTitle:SetText(GText("UI_DUNGEON_Drops"))
        else
            self.Switcher:SetActiveWidgetIndex(1)
        end
    end

    local _DeputeType = self:GetDeputeType()
    if _DeputeType or self.IsWeeklyDungeon then
       self:InitBanReward()
    end 
end

function M:InitPlayersHighLightData()
    -- 队伍活动结算
    if self.IsParty then
        for i = 1, 4 do
            self["Data0"..i]:SetVisibility(ESlateVisibility.Collapsed)
        end
        local ScenePlayers = GWorld.GameInstance.ScenePlayers
        if not ScenePlayers or #ScenePlayers <= 1 then return end

        for CurPlayerIndex, Player in ipairs(ScenePlayers) do
            local widget = self["TempleData0"..CurPlayerIndex]
            if widget then
                widget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                widget.Text_Index:SetText(CurPlayerIndex)

                if Player.IsMainPlayer then
                    widget:PlayAnimation(widget.Player)
                else
                    widget:PlayAnimation(widget.Other)
                end

                local completeTime = self.CombatData.PartyPlayerCompleteTime[CurPlayerIndex]
                if completeTime then
                    widget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                    widget.Text_Time:SetText(self:GetTimeStr(completeTime))
                else
                    widget.SizeBox_77:SetVisibility(ESlateVisibility.Collapsed)
                    widget.Text_Time:SetText(GText("UI_PARTY_PARKOUR_UNFINISH"))
                end

                local Slot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(widget.Text_Index)
                local Pos = Slot:GetPosition()
                local Font = widget.Text_Index.Font
                if CurPlayerIndex == 1 then
                    Slot:SetPosition(FVector2D(Pos.X, widget.TextPosY_No1))
                    Font.Size = widget.TextSize_No1
                else
                    Slot:SetPosition(FVector2D(Pos.X, widget.TextPosY_Other))
                    Font.Size = widget.TextSize_Other
                end
                widget.Text_Index:SetFont(Font)
            end
        end
        return
    end

    -- 非胜利或神庙不展示
    if not self.IsWin or self.IsTemple then
        for i = 1, 4 do
            self["Data0"..i]:SetVisibility(ESlateVisibility.Collapsed)
        end
        return
    end

    -- 初始化可见性
    for i = 1, 4 do
        self["Data0"..i]:SetRenderOpacity(0)
    end

    -- 计算玩家高光数据
    local Players = GWorld.GameInstance:CalcPlayersMVPData()

    --有没有好友可以加
    self.IsCanAddFriend = false
    for Index, value in pairs(Players) do
        if CommonUtils.Size(value) ~= 0 and value[1].Uid and self:CheckAddFriend(value[1].Uid) then
            self.IsCanAddFriend = true
        end
    end

    -- 绑定到 UI
    for Index, value in pairs(Players) do
        if CommonUtils.Size(value) ~= 0 then
            self["Data0"..Index]:Init(value[1])
        else
            self["Data0"..Index]:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
end

function M:CheckAddFriend(Uid)
    --已经是好友/黑名单不显示
    local FriendController = require "BluePrints.UI.WBP.Friend.FriendController"
    DebugPrint("DungeonSettlement: CheckAddFriend", Uid, FriendController:GetModel():GetBlackListDict()[Uid], FriendController:GetModel():GetFriendDict()[Uid])
    return (FriendController:GetModel():GetBlackListDict()[Uid] == nil) and (FriendController:GetModel():GetFriendDict()[Uid] == nil)
end

function M:InitHeadline()
    if self.IsWin then
        local HeadLineText_Win = GText("UI_MISSION_COMPLETE")
        if self.IsTemple or self.IsParty then
            HeadLineText_Win = GText("UI_TEMPLE_COMPLETE")
        end
        if self.IsHardBoss then
            HeadLineText_Win = GText("UI_HARDBOSS_COMPLETE")
        end
        self.Text_HeadLine_Victory:SetText(HeadLineText_Win)
        self.VX_Text_HeadLine:SetText(HeadLineText_Win)
    else
        local HeadLineText_Fail = GText("UI_MISSION_FAIL")
        self.Text_HeadLine_Defeat:SetText(HeadLineText_Fail)
    end
end

function M:InitDungeonClearanceTime()
    local Minute = math.floor(self.PlayerTime / 60)
    local Second = math.floor(self.PlayerTime % 60)  -- 服务端有概率CostTime传浮点数，强制转换一下
    self.TimeDict = {}
    table.insert(self.TimeDict, 1, {TimeType="Min", TimeValue=Minute})
    table.insert(self.TimeDict, 2, {TimeType="Sec", TimeValue=Second})
end

function M:InitDungeonLevelIndex()
    local DungeonInfo = self:GetDungeonInfo(self.BattleInfo)
    if DungeonInfo.DungeonType and DungeonInfo.DungeonType == "Temple" then
        return
    end
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if not GameState then 
        return 
    end
    local ChapterId
    if self.IsWeeklyDungeon then
        ChapterId = DataMgr.WeeklyDungeonId2ChapterId[GameState.DungeonId]
    else
        ChapterId = DataMgr.Dungeon2Select[GameState.DungeonId]
    end
    if not ChapterId then 
        return 
    end
    local DungeonList = nil
    if self.IsWeeklyDungeon then
        DungeonList = DataMgr.WeeklySelectDungeon[ChapterId].DungeonList
    else
        DungeonList = DataMgr.SelectDungeon[ChapterId].DungeonList
    end
    
    if not DungeonList then 
        return 
    end
    local Index = 1
    for key, value in pairs(DungeonList) do
        if value == GameState.DungeonId then
            Index = key
            goto continue
        end
    end
    ::continue::
    local RomanNum = Const.RomanNum
    self.DungeonLevelIndex = GText(RomanNum[Index])
end

function M:InitDungeonName()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        error("Avatar is nil")
    end
    self.Describe = ""
    
    if self.IsHardBoss then
        if GameState(self):IsInRegion() then
            self.Describe = GText(DataMgr.HardBossMain[self.BattleInfo.HardBossId].HardBossName)
            self.Describe = self.Describe.." "..GText("UI_LEVEL_NAME")
            local DifficultyId = Avatar.HardBossInfo.DifficultyId
            local DifficultyLevel = ""
            if DifficultyId and DataMgr.HardBossDifficulty[DifficultyId] then
                DifficultyLevel = DataMgr.HardBossDifficulty[DifficultyId].DifficultyLevel
            end
            self.Describe = self.Describe..DifficultyLevel
        else
            local HardBossDgInfo = DataMgr.HardBossDg[self.DungeonId]
            if HardBossDgInfo then
                self.Describe = GText(DataMgr.HardBossMain[HardBossDgInfo.HardBossId].HardBossName)
                self.Describe = self.Describe.." "..GText("UI_LEVEL_NAME")
                local DifficultyId = HardBossDgInfo.DifficultyId
                local DifficultyLevel = ""
                if DifficultyId and DataMgr.HardBossDifficulty[DifficultyId] then
                    DifficultyLevel = DataMgr.HardBossDifficulty[DifficultyId].DifficultyLevel
                end
                self.Describe = self.Describe..DifficultyLevel
            else
                self.Describe = ""
            end
        end
    elseif Avatar:IsInDungeon() then
        self.DungeonInfo = self:GetDungeonInfo(self.BattleInfo)
        self.Describe = self:GetDungeonName(self.DungeonInfo)
        self:InitDungeonLevelIndex()
    end
    if self.DungeonLevelIndex then 
        self.Describe = self.Describe..self.DungeonLevelIndex
        self.DungeonLevelIndex = nil
    end
end

function M:InitStageWidgets()
    --self.Text_StageName:SetVisibility(ESlateVisibility.Collapsed)
    --self.Img_Time:SetVisibility(ESlateVisibility.Collapsed)
    --self.Text_Time:SetVisibility(ESlateVisibility.Collapsed)
    self.Time:SetVisibility(ESlateVisibility.Visible)
end

function M:InitStageInfo()
    --初始化Stage相关控件(后面正式迭代应该可以直接删除)
    self:InitStageWidgets()
    --获取副本通关时间
    self:InitDungeonClearanceTime()
    --获取任务名称
    self:InitDungeonName()
    --设置Stage信息
    self.Time:SetTimeText(self.Describe, self.TimeDict)
    if self.IsTemple or self.IsParty then
        self.Time.Image_ClockIcon:SetVisibility(ESlateVisibility.Collapsed)
        self.Time.Text_TimeDesc:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:InitMainButtons()
    self.Btn_Continue:SetText(GText("UI_MISSION_AGAIN"))
    self.Btn_Continue:BindEventOnClicked(self, self.Continue)
    self.Btn_Continue:BindForbidStateExecuteEvent(self, self.ForbidContinue)
    self.Btn_Continue:SetDefaultGamePadImg("Y")

    -- 策划要求 所有副本都可以再次挑战
    -- if GWorld.DungeonSettlementAgainInVisible or self.IsWalnut then
    --     self.Again:SetVisibility(ESlateVisibility.Collapsed)
    --     GWorld.DungeonSettlementAgainInVisible = nil -- 消耗掉这个标记
    -- end
    -- 如果副本过程中核桃本刷新，再次挑战按钮置灰，点击给toast提示
    if not self:CheckAgainAvailable() then
        self.Btn_Continue:ForbidBtn(true)
        self.AgainNotAvailable = true
    end
    self:AddDispatcher(EventID.OnDungeonsUpdate, self, self.OnWalnutDungeonUpdate)

    self.Btn_Close:SetVisibility(ESlateVisibility.Visible)
    self.Btn_Close:ForbidBtn(false)
    if not self.IsTemple then
        self.Btn_Close:SetText(GText("UI_Esc_ExitDungeon"))
    else
        self.Btn_Close:SetText(GText("UI_Esc_ExitTemple"))
    end
    self.Btn_Close:BindEventOnClicked(self, self.Exit)
    self.Btn_Close:SetDefaultGamePadImg("B")

    if self.IsWin then
        self:BindToAnimationFinished(self.Victory_In, {self, self.OnInAnimationFinished})
    else
        self:BindToAnimationFinished(self.Defeat_In, {self, self.OnInAnimationFinished})
    end
    
    --self:BindToAnimationFinished(self.ProgressBarAnim, {self, self.OnProgressBarAnimationFinished})
    if self.Bar_Click then  -- 待蓝图删除后可删除
        self.Bar_Click:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:OnWalnutDungeonUpdate()
    if not self.IsWalnut then
        return
    end

    self.Btn_Continue:ForbidBtn(true)
    self.AgainNotAvailable = true
end

function M:InitActionPointInfo()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        error("Avatar is nil")
    end
    if self.IsTemple then
        return
    end
    self.CurActionPoint = Avatar.ActionPoint
    local DungeonData = DataMgr.Dungeon[self.DungeonId]
    local RawDungeonCost = 0
    self.DungeonCost = 0
    if DungeonData and DungeonData.DungeonCost then
        RawDungeonCost = DungeonData.DungeonCost[1] or 0
    end
    if Avatar.bDungeonDoubleCost then
        self.DungeonCost = RawDungeonCost * 2
    else
        self.DungeonCost = RawDungeonCost
    end

    --self.IsWeeklyDungeon = self.DungeonId and DataMgr.Dungeon[self.DungeonId] and DataMgr.Dungeon[self.DungeonId].IsWeeklyDungeon
    if self.IsHardBoss or self.IsWeeklyDungeon then
        self.Cost:SetVisibility(ESlateVisibility.Collapsed)
        return
    end

    local Params = {
        ResourceId = 103, -- 精力
        bShowDenominator = true,--现有精力
        CostText = nil,--提示文本
        Denominator = self.DungeonCost,-- 副本消耗
        Numerator = self.CurActionPoint, -- 现有精力 
        KeyIconName = nil, -- 快捷键图标，手柄图标？
        Owner = self,
    }
    self.Cost:InitContent(Params)
    self.Cost.Common_Item_Icon.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Remove(self,self.ItemMenuAnchorChanged)
    self.Cost.Common_Item_Icon.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self,self.ItemMenuAnchorChanged)
    self.Cost:SetVisibility(ESlateVisibility.Visible)
    --以下废弃 使用上面cost通用控件
    --self.Text_Consume:SetText(GText("UI_ActionPoint_Consume"))
    --self.Text_Have:SetText(GText(self.CurActionPoint))
    -- if self.CurActionPoint < self.DungeonCost then
    --     self.Text_Have:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("DD1C45"))
    -- else
    --     self.Text_Have:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("34A981"))
    -- end
    --self.Text_Need:SetText(self.DungeonCost)
    -- local ActionPointId = DataMgr.ResourceSType2Resource.ActionPoint[1]
    -- local ActionPointData = DataMgr.Resource[ActionPointId]
    -- if ActionPointData then
    --     local Icon = LoadObject(ActionPointData.Icon)
    --     self.Common_Item_Icon:Init({
    --         UIName = "DungeonSettlement",
    --         IsShowDetails = true,
    --         IsCantItemSelection = true,
    --         MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight,
    --         Id = ActionPointId,
    --         Icon = Icon,
    --         ItemType = "Resource",
    --         HandleMouseDown = true
    --     })
    --     self.Common_Item_Icon:SetVisibility(ESlateVisibility.Visible)
    -- end
end

function M:InitHardBossOrWeekyDungeonInfo()

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        error("Avatar is nil")
        return
    end

    local RemainTimes = nil
    local TotalTimes = nil

    if self.IsHardBoss then
        RemainTimes = Avatar.HardBoss.HardBossRewardTimesLeft
        TotalTimes = DataMgr.GlobalConstant.BossRewardRefresh.ConstantValue
        self.Text_Times01:SetText(GText("UI_HardBoss_ChancesRemain"))
    elseif self.IsWeeklyDungeon then
        RemainTimes = Avatar.WeeklyDungeonRewardLeft
        TotalTimes = DataMgr.GlobalConstant.DungeonRewardRefresh.ConstantValue
        self.Text_Times01:SetText(GText("UI_WeeklyDungeon_ChancesRemain"))
    end

    if RemainTimes and TotalTimes then
        self.Text_Times02:SetText(RemainTimes)
        self.Text_Times04:SetText(math.floor(TotalTimes))
        if (RemainTimes <= 0) then
            self.Text_Times02:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("DD1C45"))
        end
        self:ShowHardBossTimes(true)
        return
    end

    self:ShowHardBossTimes(false)
end

function M:ShowHardBossTimes(bIsShow)
    local NewVisibility = ESlateVisibility.Collapsed
    if bIsShow then
        NewVisibility = ESlateVisibility.Visible
    end
    self.TimesRemain:SetVisibility(NewVisibility)
end

function M:InitDoubleModInfo()
    local Avatar = GWorld:GetAvatar()
    local CurDoubleModDropEventId = ActivityController:GetDoubleModDropEventID()
    if not Avatar then
        return false
    end
    if (Avatar.ActivityTimeOpen and Avatar.ActivityTimeOpen[CurDoubleModDropEventId] and Avatar.DoubleModDrop[CurDoubleModDropEventId]) then
		-- 活动在服务端处于开启时间
        local TotalTimes
        local RemainTimes
        local IsDoubleMod, IsEliteRush = self:IsDoubleModDungeon(CurDoubleModDropEventId)
        if not IsDoubleMod and not IsEliteRush then
            return false
        end
        if IsDoubleMod then
            TotalTimes = DataMgr.ModDropConstant.DailyModDungeonAmount.ConstantValue
            RemainTimes = TotalTimes - Avatar.DoubleModDrop[CurDoubleModDropEventId].DropTimes
            self.Text_Times01:SetText(GText("UI_Event_ModDrop_DropRemain"))
        elseif IsEliteRush then
            TotalTimes = DataMgr.ModDropConstant.DailyFreeTicketAmount.ConstantValue
            local DoubleModDropInfo = Avatar.DoubleModDrop[CurDoubleModDropEventId]
            local EliteRushTimes = DoubleModDropInfo and DoubleModDropInfo.EliteRushTimes
            if not EliteRushTimes then
                return false
            end
            RemainTimes = TotalTimes - EliteRushTimes
            self.Text_Times01:SetText(GText("UI_Event_ModDrop_ChallengeRemain"))
        end
        self.TimesRemain:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        if IsEliteRush and RemainTimes == 0 then
            self.Text_Times02:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("DD1C45"))
            self.Btn_Continue:ForbidBtn(true)
            self.Btn_Continue:BindForbidStateExecuteEvent(self, function()
                UIManager(self):ShowUITip("CommonToastMain", GText("UI_Event_ModDrop_Exhausted"))
            end)
        end
        self.Text_Times02:SetText(RemainTimes)
        self.Text_Times04:SetText(TotalTimes)
    else
        local IsDoubleMod, IsEliteRush = self:IsDoubleModDungeon(CurDoubleModDropEventId)
        if IsEliteRush then
            -- 在连战副本过程中活动结束，此时禁止再次挑战
            self.Btn_Continue:ForbidBtn(true)
            self.Btn_Continue:BindForbidStateExecuteEvent(self, function()
                UIManager(self):ShowUITip("CommonToastMain", GText("UI_Event_ModDrop_Exhausted"))
            end)
        end
    end
end

function M:IsDoubleModDungeon(EventId)
    local DoubleMod, EliteRush = false, false
    if not DataMgr.DoubleModDrop[EventId] then
        return DoubleMod, EliteRush
    end
    for key,value in pairs(DataMgr.DoubleModDrop[EventId].ModDungeonId) do
        if value == self.DungeonId then
            DoubleMod = true
            return DoubleMod,EliteRush
        end
    end
    for key,value in pairs(DataMgr.DoubleModDrop[EventId].EliteRushDungeonId) do
        if value == self.DungeonId then
            EliteRush = true
            return DoubleMod,EliteRush
        end
    end
    return DoubleMod,EliteRush
end

function M:InitSwitchPanelContent()
    if not self.IsTemple then
        self.Btn_Data:SetVisibility(ESlateVisibility.Visible)
        self.Btn_Data:BindEventOnClicked(self, self.OnBtnChangePanelClicked)
        self.Btn_Data:SetCurrentTextBlock("UI_BATTLE_DATA")
        self.Text_None:SetText(GText("UI_NONE"))
        self:ActivateDropPanelScrolling(false, self.TileView_Reward)
        self:ActivateDropPanelScrolling(false, self.TileView_Prop)
        self.EMScrollBox_255:SetScrollBarVisibility(ESlateVisibility.Collapsed)  -- 暂时隐藏滚动条
        self.EMScrollBox_255:SetControlScrollbarInside(true)
    end
end

function M:OnBtnChangePanelClicked()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManger = GameInstance:GetGameUIManager()
    if UIManger then
        -- 构造弹窗参数
        local Params = {
            OnCloseCallbackObj = self,
            OnCloseCallbackFunction = self.OnCombatDataClosed
        }
        self.Popup_CombatData = UIManger:ShowCommonPopupUI(Const.Popup_CombatData, Params, self)
        self.Popup_CombatData:SetVisibility(ESlateVisibility.Collapsed)
        self.Popup_CombatData:ShowGamepadScrollBtn(true)
        self:CreateCombatData()
    end
end

function M:OnCombatDataClosed()
    if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad and self.CurInputDeviceType ~= ECommonInputType.Gamepad then
        --self:SetFocusInGamePad()
        self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
        self:UpdateMainUIWithGamePad()
    end
end

function M:CreateCombatData()
    for i = 0, self.Popup_CombatData.VB_Node:GetChildrenCount() - 1 do
        local Child = self.Popup_CombatData.VB_Node:GetChildAt(i)
        if Child.EMScrollBox_31 ~= nil then
            self.Panel_CombatData = Child
            break
        end
    end
    self:SetDetailsContent()
    self.Popup_CombatData:SetVisibility(ESlateVisibility.Visible)
    self.Panel_CombatData.EMScrollBox_31:SetScrollBarVisibility(ESlateVisibility.Collapsed)  -- 暂时隐藏滚动条
    self.Panel_CombatData.EMScrollBox_31:SetControlScrollbarInside(true)
    self.Panel_CombatData:SetFocus()
end

function M:SetAllUIVisibility(IsHide)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManger = GameInstance:GetGameUIManager()
    if UIManger then
        UIManger:HideAllUI_EX({self:GetName(), "DungeonMatchTimingBar"}, IsHide, self.HideUITag, false)
    end
    local BattleWarningUI = UIManger:GetUIObj(UIConst.DestroyAlarmName)
    if BattleWarningUI then
        AudioManager(self):StopSound(BattleWarningUI, "BattleWarning")
    end
end

function M:OnProgressBarAnimFinished()
    -- 废弃
    self.Btn_Continue:SetVisibility(ESlateVisibility.Visible)
    self.Btn_Close:SetVisibility(ESlateVisibility.Visible)
end

function M:OnInAnimationFinished()
    if self.IsTemple or self.IsParty then
        self.IsFirstFocus = false
        return
    else
        --self:CalcPropInfo(Avatar)     -- Reward列表播入场时机交给蓝图控制

        -- self.Bar_Click:SetVisibility(ESlateVisibility.Visible) 废弃
        -- self:PlayAnimation(self.ProgressBarAnim)
        for _, Widget in pairs(self.RoleItemInfos) do
            Widget.Widget:PlayExpAnim()
        end
        if self.CurInputDeviceType == ECommonInputType.Gamepad then
            self:AddTimer(1.5,function()
                self:SetFocusInGamePad()
                --self.bOpenBattleDataTip = true
            end)
        end
        self.IsFirstFocus = false
    end
end

function M:OnProgressBarAnimationFinished()
    self.Btn_Close:SetVisibility(ESlateVisibility.Visible)
    self.Btn_Close:ForbidBtn(false)
end

function M:ForbidContinue()
    DebugPrint("DungeonSettlement: ClickContinueButton Forbid")
    if not self.IsWalnut then
        return
    end
    if not self.AgainNotAvailable then
        return
    end
    GameState(self):ShowDungeonToast_Lua("UI_WALNUTDUNGEON_REFRESH_TOAST", 2, EToastType.Common)
end

function M:Continue()
    DebugPrint("DungeonSettlement: ClickContinueButton")
    if self.IsTemple then
        self:DefaultContinue()
        return
    end

    -- 再加个保底，如果结算时还能再次挑战，但点击时不可再次挑战，也置灰（按理说轮换时应该FireEvent 先这样吧
    if not self:CheckAgainAvailable() then
        self.Btn_Continue:ForbidBtn(true)
        self.AgainNotAvailable = true
        self:ForbidContinue()
        return
    end

    -- 体力不足弹窗
    if self.CurActionPoint < self.DungeonCost then
        --UIManager(self):ShowUITip("CommonToastMain", "UI_Settlement_Repeat_Notenough")
        UIUtils.ShowActionRecover(self)
        return
    end

    -- 真难度Boss挑战次数不足弹窗
    local Avatar = GWorld:GetAvatar()
    if self.IsHardBoss then
        local RemainTimes = Avatar.HardBoss.HardBossRewardTimesLeft or 0
        local IsNoMorePrompts = self:CheckNeedShowWindow("IsBossBattlePopup")
        local DifficultyId = 1
        if GameState(self):IsInRegion() then
            DifficultyId = Avatar.HardBossInfo.DifficultyId
        else
            DifficultyId = DataMgr.HardBossDg[self.DungeonId].DifficultyId
        end
        if RemainTimes > 0 or IsNoMorePrompts or (Avatar and DifficultyId and Avatar.HardBoss:GetPassCount(DifficultyId) == 0) then
            self:DefaultContinue()
        else
            self:ShowConfirmWindow()
        end
    elseif Avatar and self.IsWeeklyDungeon then
        local RemainTimes = Avatar.WeeklyDungeonRewardLeft or 0
        local IsNoMorePrompts = self:CheckNeedShowWindow("IsWeeklyDungeonPopup")
        if RemainTimes > 0 or IsNoMorePrompts then
            self:DefaultContinue()
        else
            self:ShowConfirmWindow()
        end
    else
        self:DefaultContinue()
    end
end

--是否需要弹窗（梦魇和周本奖励次数不够时专用）
function M:CheckNeedShowWindow(EMCacheKey)
    local IsNoMorePrompts = EMCache:Get(EMCacheKey.."NoMorePrompts", true) or false
    if TimeUtils and IsNoMorePrompts then
        local CachedTimestamp = EMCache:Get(EMCacheKey.."Timestamp", true)
        IsNoMorePrompts = TimeUtils.IsTimestampInCurrentWeek(CachedTimestamp)
    end
    return IsNoMorePrompts
end

function M:DefaultContinue()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end

    if self.IsAutoNextRound then
        DebugPrint("ljl@ DunegonSettlement AutoNextRound", self.AutoNextRound:GetSelectCount())
        Avatar:SetDungeonAutoProgress(self.DungeonId, self.AutoNextRound:GetSelectCount())
    end

    -- 非副本（目前仅有mycs）默认走旧的逻辑吧，先不改了
    if not Avatar:IsInNarrowDungeon() then
        self:RequestServerContinue()
        return
    end

    -- 新的重新开始挑战流程
    -- 单人单机 -> 选择核桃 or 选择门票 -> 发EnterDungeonAgain rpc -> 再次进入副本
    -- 其他情况（联机） -> 发EnterDungeonAgain rpc 等待队友同意 -> SettlementBattleEvent通知 选择核桃 or 选择门票 -> 再次进入副本
    if self.IsWalnut and self:IsStandAloneSolo() then
        DebugPrint("ljl@WBP_DungeonSettlement_C M:DefaultContinue StandAloneSolo")
        -- 单人单机 先弹核桃界面，然后监听SelectedWalnut事件，选完核桃后走后续流程
        self:AddDispatcher(EventID.SelectedWalnut, self, self.OnStandAloneSoloSelectedWalnut)
        local WalnutChoiceUI = UIManager(self):LoadUINew("WalnutChoice", CommonConst.WalnutUser.Settlement, self.DungeonId, GWorld.GameInstance.CombatData.TempTeamInfo)
        local WalnutUtils = require "BluePrints.UI.WBP.Walnut.WalnutChoice.WalnutUtils"
        local WalnutId = WalnutUtils:GetWalnutCacheIdByDungeonId(self.DungeonId)
        WalnutChoiceUI:SelectWalnutById(WalnutId)
    else
        DebugPrint("ljl@WBP_DungeonSettlement_C M:DefaultContinue Other")
        self:TryEnterDungeonAgain()
    end
end

function M:OnStandAloneSoloSelectedWalnut()
    self:RemoveDispatcher(EventID.SelectedWalnut)
    DebugPrint("ljl@WBP_DungeonSettlement_C M:OnStandAloneSoloSelectedWalnut")
    self.Btn_Continue:ForbidBtn(true)
    self:TryEnterDungeonAgain()
end

-- function M:CheckNeedTicket()
--     local Avatar = GWorld:GetAvatar()
--     if Avatar:IsInHardBoss() then
--         return false
--     end

--     local DungeonData = DataMgr.Dungeon[self.DungeonId]
--     if not DungeonData then
--         return false
--     end
--     if (DungeonData.TicketId and #DungeonData.TicketId ~= 0) or DungeonData.NoTicketEnter then
--         return true
--     end
--     return false
-- end

-- function M:ShowTicketWindow()
--     local CommonDialog = UIManager(self):ShowCommonPopupUI(100123, { DungeonId = self.DungeonId,
--     RightCallbackObj = self,
--     RightCallbackFunction = function(Obj, PackageData)
--         self:RequestServerContinue(PackageData.Content_1.TicketId)
--     end,
--     ForbiddenRightCallbackObj = self}, self)
--     CommonDialog:SetFocus()
-- end

function M:RequestServerContinue(TicketId)
    self:BlockAllUIInput(true)
    local Avatar = GWorld:GetAvatar()
    local DungeonInfo = Avatar.Dungeons[self.DungeonId]
    Avatar:ContinueDungeonSettlement(self.BattleInfo, CommonUtils.Bind(self, self.DefaultContinueCallBack), TicketId, DungeonInfo and DungeonInfo.Squad or nil)
end

function M:DefaultContinueCallBack(Ret)
    DebugPrint("DungeonSettlement: ContinueCallBack")
    self:BlockAllUIInput(false)
    if Ret == ErrorCode.RET_SUCCESS then
        self:OnCloseSettlementUI()
        return
    end
    local Error = DataMgr.ErrorCode[Ret]
    if Error ~= nil then
        UIManager(self):ShowError(Error, 1.5)
    else UIManager(self):ShowError(DataMgr.ErrorCode[-1], 1.5) end
end

function M:Exit()
    DebugPrint("DungeonSettlement: ClickExitButton")
    self:BlockAllUIInput(true, "SP_DisplayOnly")
    local Avatar = GWorld:GetAvatar()
    Avatar:ExitDungeonSettlement()
    EventManager:AddEvent(EventID.OnExitDungeon, self, self.DefaultExit)
end

function M:DefaultExit()
    DebugPrint("DungeonSettlement: ExitCallBack")
    EventManager:RemoveEvent(EventID.OnExitDungeon, self)
    self:BlockAllUIInput(false)
    self:OnCloseSettlementUI()

    local _DeputeType = self:GetDeputeType()
    if _DeputeType then
        local ExitDungeonInfo = GWorld.GameInstance:GetExitDungeonData() or {}
        ExitDungeonInfo.Type = "Depute"
        ExitDungeonInfo.DeputeType = _DeputeType
        GWorld.GameInstance:SetExitDungeonData(ExitDungeonInfo)
    end
end

-- 继续和退出抽出来共用逻辑
function M:OnCloseSettlementUI()  
    self:SetAllUIVisibility(false)

    USkillFeatureFunctionLibrary.SKillFeatureForceStop()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if Player then 
        Player:SetCanInteractiveTrigger(true)
        Player.PlayerAnimInstance:Montage_Stop(0) 
    end
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    GameInstance:ProcessSettlementCharacter()

    if self.IsWin == false then
        AudioManager(self):StopSound(Player, "FailedPlayerCharAudio")
    else
        AudioManager(self):StopSound(self, "WinSettlement")
    end

    self:SetCharDirLight(false)
    
    ChatController:GetModel():ClearReddotCount(CommonConst.ChatChannel.SettlementOnline)
    self:Close()
end

--return "Regular" or "NightBook" or "Walnut"
function M:GetDeputeType()
    -- 检查是否为普通委托
    for _, Info in pairs(DataMgr.SelectDungeon or {}) do
        for _, DungeonId in pairs (Info.DungeonList or {}) do
            if DungeonId == self.DungeonId then
                return "Regular"
            end
        end
    end

    -- 检查是否为夜航手册（mod）委托
    for _, Info in pairs(DataMgr.ModDungeonMonReward or {}) do
        for _, DungeonId in pairs (Info.DungeonList or {}) do
            if DungeonId == self.DungeonId then
                return "NightBook"
            end
        end
    end

    -- 检查是否为核桃委托
    for _, Info in pairs(DataMgr.WalnutSelectDungeon or {}) do
        for _, DungeonId in pairs (Info.DungeonId or {}) do
            if DungeonId == self.DungeonId then
                return "Walnut"
            end
        end 
    end

    return nil
end

function M:CalcRoleAndRewardsInfo()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    self:CalcRoleInfo(Avatar)
    --self:CalcPropInfo(Avatar)  -- Reward列表播入场时机交给蓝图控制
    self:PreInitPropInfo()       -- 但是在这时候需要初始化
end

function M:CalcRoleInfo(Avatar)
    local IncrsExps = self:SetIncrsExps(self.Rewards.Exps)
    for RoleName, RoleItem in pairs(self.RoleItemInfos) do
        local OldBattleInfo = self.CombatData.OldBattleInfo[RoleName.."_OldBattleInfo"]
        local CurBattleInfo = self.CombatData.CurBattleInfo[RoleName.."_CurBattleInfo"]
        if IncrsExps[RoleName] == 0 then                -- 如果任务失败，是不发经验奖励的
            CurBattleInfo = {                           -- 但结算时显示当前Level和Exp的逻辑，是直接从对应角色/武器身上获取，可能不准确（客户端记录了经验值增加，实际上结算任务失败不发经验
                Exp = OldBattleInfo.Exp,                -- 先这么处理吧，如果服务端下发的Exp为0，则直接把OldBattleInfo作为CurBattleInfo传入。之后有空再深究
                Level = OldBattleInfo.Level,
            }
        end
        RoleItem.Widget:SetItem(OldBattleInfo, RoleName, IncrsExps[RoleName], false, CurBattleInfo, self.IsNoExpDungeon)
        RoleItem.Widget:SetVisibility(ESlateVisibility.Visible)
        RoleItem.Widget:PlayInAnimation()
    end
end

function M:PreInitPropInfo()
    if not self.IsAutoBan then
        self.Switcher:SetActiveWidgetIndex(0)
    end
    self.TileView_Reward:ClearListItems()
    self.TileView_Prop:ClearListItems()
end

function M:InitRewardsInfo(RewardArr, RewardViewWidget)
    local DropItemNumEachRow, DropRowNum = UIUtils.GetTileViewContentMaxCount(RewardViewWidget, "XY", true)
    local RewardTotalNum = #RewardArr
    --switcher切换器默认是开启有奖励的状态，所以当当前奖励列表为空且委托和掉落奖励列表均为空的时候 切换到1状态 也就是没有奖励状态
    if RewardTotalNum < 1 and #self.SpRewardsArray == 0 and #self.RewardsArray == 0 then
        self.Switcher:SetActiveWidgetIndex(1)
    else
        --self.Switcher:SetActiveWidgetIndex(0)
        --交互策划希望梦魇结算时，奖励框里的空态能填满奖励栏
        if self.IsHardBoss then
            DropRowNum = math.max(self.EmptyLine or 0, DropRowNum)
        end
        local MaxItemNum = DropRowNum * DropItemNumEachRow
        if RewardTotalNum > MaxItemNum then
            -- 若实际需要显示数量大于ListView能显示的最大数量MaxItemNum，
            -- 无视MaxItemNum，显示所有的道具并用空状态补满末行
            local RealRowNum = RewardTotalNum // DropItemNumEachRow
            if (RewardTotalNum % DropItemNumEachRow) ~= 0 then
                RealRowNum = RealRowNum + 1
            end
            MaxItemNum = RealRowNum * DropItemNumEachRow

            --self:ActivateDropPanelScrolling(true, RewardViewWidget)
        end

        local AddPropKey = RewardViewWidget:GetName()--根据是委托奖励还是掉落奖励 设置两个计时器key
        self.IsAllowPropInAnimation = true
        local AddProp = function()
            local ShowNum = RewardViewWidget:GetNumItems()
            if ShowNum < MaxItemNum then
                RewardViewWidget:AddItem(self:NewPropContent(RewardArr[ShowNum + 1], RewardViewWidget))
            else
                self:RemoveTimer(AddPropKey, true)
                RewardViewWidget:SetVisibility(UIConst.VisibilityOp.Visible)
                self.IsAllowPropInAnimation = false
            end
            -- 手动设置空态格子数（用来避免空格能被导航问题）
            RewardViewWidget:SetEmptyGridItemCount(math.max(0, ShowNum - RewardTotalNum))
        end
        RewardViewWidget:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self:AddTimer(self.IntervalTime, AddProp, true, self.FirstDelayTime, AddPropKey, true)
    end
end

function M:InitRefundInfo(UnCostItemsInfo)
    --UnCostItemsInfo为nil的情况一个是UI已经在 NotifyUnCostItems方法里 被加载了，GameInstance里不会声明UnCostItemsInfo变量
    if not UnCostItemsInfo then 
        DebugPrint("thy  UnCostItemsInfo is nil")
        return
    end
    -- 体力/委托手册/密函道具
    --除了体力是返回体力数，其他的为道具的ResourceID
    --key为123
    self.RefundItemsInfo = {}
    for _, value in pairs(UnCostItemsInfo) do
        for key, val in pairs(value) do
            self.RefundItemsInfo[_] = val
        end
    end
    self.Refund:SetVisibility(ESlateVisibility.Visible)
    self.Refund:InitRefund(self.RefundItemsInfo)
    --使用完及时消耗掉返还道具信息
    GWorld.GameInstance.UnCostItemsInfo = nil
    
end

--在动效中执行
function M:CalcPropInfo()
    self:ShowCountDown()
    if self.IsTemple then
        return
    end
   
    if self.IsAutoBan then
        return
    end 
    self.TileView_Reward:DisableScroll(true)
    self.TileView_Prop:DisableScroll(true)
    self:AddTimer(0.01,function()
        self:InitRewardsInfo(self.SpRewardsArray, self.TileView_Reward)   --委托奖励
        self:InitRewardsInfo(self.RewardsArray, self.TileView_Prop)  --掉落物
        --没赢开启返还道具UI
        if not self.IsWin then
            if self.IsHardBoss then
                if GameState(self):IsInRegion() then
                    self.FailTips:InitialTips(self.BattleInfo.HardBossId, true)
                else
                    self.FailTips:InitialTips(DataMgr.HardBossDg[self.DungeonId].HardBossId, true)
                end
            else
                self.FailTips:InitialTips(self.DungeonId, false)
            end
            if CommonUtils.Size(DataMgr.FailureGuidance) > 7 then
                self.FailTipsNum = CommonUtils.Size(DataMgr.FailureGuidance)
                self.CurFailTipIndex = 0
            end
            self:InitRefundInfo(GWorld.GameInstance.UnCostItemsInfo)
        end
    end)
    --更新图标
    self:UpdateMainUI()
end

function M:SetDetailsContent()
    self.Widget_DetailsTime = self:InitDataContent(GText("UI_STAT_Time"), self:GetTimeStr(self.PlayerTime))

    self:SetOnlineDetails()
    self:SetDamageDetails()
    self:SetKillDetails()
    self:SetTakedDamageDetails()
    self:SetPhantomAttrsDetails()
    self:SetOtherDetails()

    local DeadCount = self.CombatData.DeadCount or 0
    self.Widget_DeadCount = self:InitDataContent(GText("UI_STAT_DEAD"), tostring(DeadCount))
end

function M:SetOtherDetails()
    local SpConsume = self.CombatData.SpConsume
    local BulletConsume = self.CombatData.BulletConsume
    local ChestOpenedCount = self.CombatData.ChestOpenedCount
    local BreakableItemCount = self.CombatData.BreakableItemCount
    local MaxComboCount = self.CombatData.MaxComboCount
    local MaxDamage = self.CombatData.MaxDamage

    self.Widget_Other = self:InitDataContent(GText("UI_STAT_Other"))

    local OtherDetails = {{
        Name = GText("UI_STAT_ActionPoint_Cost"),
        Value = SpConsume
    }, {
        Name = GText("UI_STAT_Bullets_Cost"),
        Value = BulletConsume
    }, {
        Name = GText("UI_STAT_Chest"),
        Value = ChestOpenedCount
    }, {
        Name = GText("UI_STAT_Destructible"),
        Value = BreakableItemCount
    }, {
        Name = GText("UI_STAT_Combo_Max"),
        Value = MaxComboCount
    }, {
        Name = GText("UI_STAT_Damage_Max"),
        Value = MaxDamage
    }}

    self:WrapedInitChildDetailContentFunc(self.Widget_Other, OtherDetails, 6)
end

function M:SetOnlineDetails()
    --没有联机不显示这一行战斗统计数据
    if not self.CombatData.IsInOnlineDungeon then 
        return 
    end
    local TitleStr = ""
    local TeammateDamageInfos = self.CombatData.TeammateDamageInfos
    local TeammateNum = self.CombatData.TeammateNum
    local TeamModel = TeamController:GetModel()
    if not TeamModel then 
        return 
    end
    --TeammateDamageInfos里面的玩家并不是按照1p2p这样排的，所以先需要顺p排序
    local SortTeammateDamageInfos = {}
    for _, TeammateDamageInfo in pairs(TeammateDamageInfos) do
        if TeammateDamageInfo and TeammateDamageInfo.Index then
            SortTeammateDamageInfos[TeammateDamageInfo.Index] = TeammateDamageInfo
        end
    end
    table.sort(SortTeammateDamageInfos)

    --生成标题
    for TeamIndex, TeammateDamageInfo in pairs(SortTeammateDamageInfos) do
        if TitleStr == "" then
            TitleStr = GText("UI_STAT_Online_P"..TeamIndex)
        else
            TitleStr = TitleStr.. "、".. GText("UI_STAT_Online_P"..TeamIndex)
        end
    end
    --显示标题
    self.Widget_OnlineDetails = self:InitDataContent(GText("UI_STAT_Online"), TitleStr)
    --显示各个联机玩家的战斗统计数据
    for TeamIndex, TeammateDamageInfo in pairs(SortTeammateDamageInfos) do
        local OnlinePlayersDetails= 
        {
            {Name = GText("UI_STAT_Online_Damage_"..TeamIndex.."P"), Value = TeammateDamageInfo.FinalDamage}, 
            {Name = GText("UI_STAT_Online_Kill_"..TeamIndex.."P"), Value = TeammateDamageInfo.TotalKillCount}
        }
        self:WrapedInitChildDetailContentFunc(self.Widget_OnlineDetails, OnlinePlayersDetails, 2)
    end
end

function M:SetPhantomAttrsDetails()
    local PhantomAttrInfos = self.CombatData.PhantomAttrInfos
    local PhantomNum = self.CombatData.PhantomNum
    local Battle = GWorld.Battle
    if not Battle then 
        DebugPrint("[THY]  Battle为nil")
        return
    end
    --未使用魅影，不显示这行统计数据
    if PhantomNum == 0 then
        DebugPrint("[THY]  没有魅影")
        return
    end
    --生成标题
    local PhantomDetails = {}
    for PhantomNumber, PhantomAttrInfo in pairs(PhantomAttrInfos) do
        if PhantomAttrInfo and PhantomAttrInfo.PhantomRoleId and PhantomAttrInfo.PhantomRoleId > 999 then
            local PhantomName = DataMgr.Char[PhantomAttrInfo.PhantomRoleId].CharName
            self["Widget_PhantomDetails"..PhantomNumber] = self:InitDataContent(GText("UI_STAT_Sigil"), GText(PhantomName))
            PhantomDetails= 
            {
                {Name = GText("UI_STAT_Sigil_DAMAGE"), Value = PhantomAttrInfo.FinalDamage}, 
                {Name = GText("UI_STAT_Sigil_SUFFER"), Value = PhantomAttrInfo.TakedDamage},
                {Name = GText("UI_STAT_Sigil_KILL"), Value = PhantomAttrInfo.TotalKillCount},
                {Name = GText("UI_STAT_Sigil_DEAD"), Value = PhantomAttrInfo.DeathCount}
            }
            self:WrapedInitChildDetailContentFunc(self["Widget_PhantomDetails"..PhantomNumber], PhantomDetails, 4)
        end
        
    end

end

function M:SetTakedDamageDetails()
    local TakeDamagePercent = self.CombatData.TakeDamagePercentage
    local TakedDamage = MiscUtils.Round(self.CombatData.TakedDamage)
    local TakedShieldDamage = self.CombatData.TakedShieldDamage
    local TakedHeal = self.CombatData.TakedHeal

    local TakeDamageText = tostring(MiscUtils.Round(TakedDamage))
    if not IsStandAlone(self) then
        TakeDamageText = TakeDamageText .. "(" .. MiscUtils.Round(TakeDamagePercent * 100) .. "%)"
    end
    self.Widget_TotalDamage = self:InitDataContent(GText("UI_STAT_SUFFER"), TakeDamageText)

    local TakedDamageDetails = {{
        Name = GText("UI_STAT_Shield"),
        Value = TakedShieldDamage
    }, {
        Name = GText("UI_STAT_Healing"),
        Value = TakedHeal
    }}

    self:WrapedInitChildDetailContentFunc(self.Widget_TotalDamage, TakedDamageDetails, 2)
end

function M:SetDamageDetails()
    local TotalDamagePercent = self.CombatData.DamagePercentage or 0
    local TotalDamage = self.CombatData.TotalDamage or 0
    local MeleeDamage = self.CombatData.MeleeDamage or 0
    local RangedDamage = self.CombatData.RangedDamage or 0
    local SkillDamage = self.CombatData.SkillDamage or 0
    local SupportDamage = self.CombatData.SupportDamage or 0

    local TotalDamageText = tostring(MiscUtils.Round(TotalDamage))
    if not IsStandAlone(self) then
        TotalDamageText = TotalDamageText .. "(" .. MiscUtils.Round(TotalDamagePercent * 100) .. "%)"
    end
    self.Widget_DamageDetail = self:InitDataContent(GText("UI_STAT_DAMAGE_TITLE"), TotalDamageText)

    -- 初始排序即为默认排序，后续的 sort 排序只有Value小于才会换位。
    local DamageDetails = {{
        Name = GText("UI_STAT_DAMAGE_MELEE"),
        Value = MeleeDamage
    }, {
        Name = GText("UI_STAT_DAMAGE_RANGE"),
        Value = RangedDamage
    }, {
        Name = GText("UI_STAT_DAMAGE_CHAR"),
        Value = SkillDamage
    }, {
        Name = GText("UI_STAT_DAMAGE_Pet"),
        Value = SupportDamage
    }}
    table.sort(DamageDetails, function(a, b)
        return a.Value > b.Value
    end)

    self:WrapedInitChildDetailContentFunc(self.Widget_DamageDetail, DamageDetails, 4)
end

function M:SetKillDetails()
    local TotalKill = self.CombatData.TotalKill or 0
    local MeleeKill = self.CombatData.MeleeKill or 0
    local RangedKill = self.CombatData.RangedKill or 0
    local SkillKill = self.CombatData.SkillKill or 0
    local SupportKill = self.CombatData.SupportKill or 0

    self.Widget_KillDetail = self:InitDataContent(GText("UI_STAT_KILL_TITLE"), tostring(MiscUtils.Round(TotalKill)))

    -- 初始排序即为默认排序，后续的 sort 排序只有Value小于才会换位。
    local KillDetails = {{
        Name = GText("UI_STAT_KILL_MELEE"),
        Value = MeleeKill
    }, {
        Name = GText("UI_STAT_KILL_RANGE"),
        Value = RangedKill
    }, {
        Name = GText("UI_STAT_KILL_CHAR"),
        Value = SkillKill
    }, {
        Name = GText("UI_STAT_KILL_Pet"),
        Value = SupportKill
    }}
    table.sort(KillDetails, function(a, b)
        return a.Value > b.Value
    end)

    self:WrapedInitChildDetailContentFunc(self.Widget_KillDetail, KillDetails, 4)
end

-- e.g.
-- local IsIntervalBg = true
-- local KillTargets = self:InitTargetContents(self.Widget_KillDetail, 4)
-- for i = 1, #KillTargets do
--     local KillDetail = KillDetails[i]
--     self:SetTargetContent(KillTargets[i], KillDetail.Name, KillDetail.Value, IsIntervalBg)
--     IsIntervalBg = not IsIntervalBg
-- end
function M:WrapedInitChildDetailContentFunc(FatherWidget, ChildInfos, ChildInfoLength)
    local IsIntervalBg = true
    local ChildTargets = self:InitTargetContents(FatherWidget, ChildInfoLength)
    for i = 1, #ChildTargets do
        local ChildInfo = ChildInfos[i]
        self:SetTargetContent(ChildTargets[i], ChildInfo.Name, ChildInfo.Value, IsIntervalBg)
        IsIntervalBg = not IsIntervalBg
    end
end

function M:InitDataContent(TextTarget, TextNumber)
    local Data_Widget = self:CreateWidgetNew("DungeonSettlementData")
    self:SetTitleContent(Data_Widget.Title, TextTarget, TextNumber)
    self.Panel_CombatData.EMScrollBox_31:AddChild(Data_Widget)
    return Data_Widget
end

function M:InitTargetContents(Data_Widget, LenNum)
    local Targets = {}
    for i=1, LenNum do
        local Target_Widget = self:CreateWidgetNew("DungeonSettlementTarget")
        Data_Widget.SubTitle:AddChildToVerticalBox(Target_Widget)
        Targets[i] = Target_Widget
    end
    return Targets
end

---@param Title WBP_Dungeon_Settlement_Title_New_C
function M:SetTitleContent(Title, TextTarget, TextNumber)
    Title.Text_Main:SetText(TextTarget)
    Title.Text_Number:SetText(TextNumber)
end

---@param Target WBP_Dungeon_Settlement_Target_New_C
function M:SetTargetContent(Target, TextMain, TextNumber, IsHideBg)
    Target.Text_Main:SetText(TextMain)
    if TextNumber then
        Target.Text_Number:SetText(MiscUtils.Round(TextNumber))
    end
    if IsHideBg then
        Target.Bg:SetVisibility(ESlateVisibility.Collapsed)
    else
        Target.Bg:SetVisibility(ESlateVisibility.HitTestInvisible)
    end
end

function M:SetIncrsExps(Exps)
    local IncrsExps = {}
    for k, _ in pairs(self.RoleItemInfos) do
        IncrsExps[k] = 0
    end

    if not Exps then
        return IncrsExps
    end

    for id, num in pairs(Exps) do
        local SumExp = RewardBox:GetCount(num)
        if id == CommonConst.CharExpItemId then
            IncrsExps.Char = SumExp
        elseif id == CommonConst.MeleeWeaponExpItemId then
            IncrsExps.MeleeWeapon = SumExp
        elseif id == CommonConst.RangedWeaponExpItemId then
            IncrsExps.RangedWeapon = SumExp
        elseif id == CommonConst.PlayerExpId then
            IncrsExps.Player = SumExp
        end
    end

    return IncrsExps
end

function M:RewardsAddToArray(TotalRewards, Rewards, IsSpecial)
    if not Rewards then
        return
    end
    -- Rewards
    -- {
    -- Type:{
    --     Id:{
    --         Normal:  Count_Normal, 
    --         Extra:   Count_Extra, 
    --         Walnut:  Count_Walnut,
    --         First:   count_First
    --         }
    --     }
    -- }

    local RewardTypes = DataMgr.RewardType
    for RewardType, RewardTypeValue in pairs(RewardTypes) do
        if not RewardTypeValue.DungeonRewardType then
            goto continue
        end
        local Reward = Rewards[RewardType.. "s"]
        if not Reward then
            goto continue
        end
        -- Reward
        -- Id:{
        --     Normal:  Count_Normal, 
        --     Extra:   Count_Extra, 
        --     Walnut:  Count_Walnut
        --     First:   count_First
        -- }

        for Id, NumTable in pairs(Reward) do
            -- NumTable
            -- {
            --     Normal:  Count_Normal, 
            --     Extra:   Count_Extra, 
            --     Walnut:  Count_Walnut
            --     First:   count_First
            -- }
            local NormalNum = RewardBox:FindCountByTag(NumTable, "Normal")
            local ExtraNum = RewardBox:FindCountByTag(NumTable, "Extra")
            local WalnutNum = RewardBox:FindCountByTag(NumTable, "Walnut")
            local FirstNum = RewardBox:FindCountByTag(NumTable, "First")
            local ResourceData = self:CreateOneReward(RewardType, RewardTypeValue, Id, NormalNum, IsSpecial, false, false, false)
            local ExtraResourceData = self:CreateOneReward(RewardType, RewardTypeValue, Id, ExtraNum, IsSpecial, true, false, false)
            local WalnutResourceData = self:CreateOneReward(RewardType, RewardTypeValue, Id, WalnutNum, IsSpecial, false, true, false)
            local FirstRewardData = self:CreateOneReward(RewardType, RewardTypeValue, Id, FirstNum, IsSpecial, false, false, true)
            if ResourceData then
                table.insert(TotalRewards, ResourceData)
            end
            if ExtraResourceData then
                table.insert(TotalRewards, ExtraResourceData)
            end
            if WalnutResourceData then
                table.insert(TotalRewards, WalnutResourceData)
            end
            if FirstRewardData then
                table.insert(TotalRewards, FirstRewardData)
            end
        end
        ::continue::
    end
end

function M:CreateOneReward(RewardType, RewardTypeValue, Id, Num, IsSpecial, IsExtra, IsWalnut, IsFirst)
    if Num == 0 then
        return
    end
    local RewardInfo = DataMgr[RewardType][tonumber(Id)]
    if RewardInfo then
        local ResourceData = {}

        ResourceData.Priority = RewardTypeValue.DungeonRewardSeq or 0
        ResourceData.Id = Id
        ResourceData.Count = Num
        ResourceData.Icon = RewardInfo.Icon
        ResourceData.Rarity = RewardInfo.Rarity or RewardInfo[RewardType.."Rarity"] or 0
        ResourceData.ItemType = RewardType
        ResourceData.IsSpecial = IsSpecial
        ResourceData.IsBonus = IsExtra
        ResourceData.IsWalnutBonus = IsWalnut
        ResourceData.IsFirst = IsFirst

        return ResourceData
    else
        return
    end
end

function M:SortRewardsArray(RewardsArray)
    -- 排序优先级：通关奖励（特殊显示）、稀有度、类型、Id、额外奖励、数量
    table.sort(RewardsArray, function(a, b)
        if a.IsFirst ~= b.IsFirst then
            return a.IsFirst
        end
        if a.IsSpecial ~= b.IsSpecial then
            return a.IsSpecial
        end
        if a.Rarity ~= b.Rarity then
            return a.Rarity > b.Rarity
        end
        if a.Priority ~= b.Priority then
            return a.Priority > b.Priority
        end
        if a.Id ~= b.Id then
            return a.Id > b.Id
        end
        if a.IsBonus ~= b.IsBonus then
            return not a.IsBonus
        end
        if a.IsWalnut ~= b.IsWalnut then
            return not a.IsWalnut
        end
        if a.Count ~= b.Count then
            return a.Count > b.Count
        end
        return false
    end)
end

function M:NewPropContent(Content, RewardViewWidget)
    ---@type WBP_Common_Item_Subsize_Small_Content_PC_C
    local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
    if Content ~= nil then
        ItemContent.ParentWidget = self
        ItemContent.Id = Content.Id
        ItemContent.Count = Content.Count
        ItemContent.AfterInitCallback = function(Widget)
            if self.IsAllowPropInAnimation and (not Widget.Content.IsPlayedInAnimation) then
                Widget:PlayInAnimation()
                Widget.Content.IsPlayedInAnimation = true
            else 
                Widget:PlayAnimation(Widget.Normal_In, Widget.Normal_In:GetEndTime())
            end

            --打开tips窗口监听
            self:OpenTipsBindEvents(Widget)
        end
        ItemContent.OnAddedToFocusPathEvent = {
            Obj = ItemContent.ParentWidget,
            Callback = function(Obj)
                if Obj.CurInputDeviceType == ECommonInputType.Gamepad then
                    Obj.EMScrollBox_255:ScrollWidgetIntoView(ItemContent.SelfWidget)
                end
            end,
            Params = {},
        }

        if Content.ItemType == "Mod" and self:CheckIsNew(Content.Id) then
            ItemContent.RedDotType = UIConst.RedDotType.NewRedDot
        end

        if Content.Icon then
            ItemContent.Icon = Content.Icon
        end
        DebugPrint("thy     Content.Icon", Content.Icon)
        ItemContent.Rarity = Content.Rarity
        ItemContent.IsShowDetails = true
        ItemContent.ItemType = Content.ItemType
        ItemContent.IsSpecial = Content.IsSpecial
        if Content.IsWalnutBonus then
            ItemContent.BonusType = 3
        end
        if Content.IsBonus then
            ItemContent.BonusType = 1
        end
        if Content.IsFirst then
            ItemContent.BonusType = 2
        end
        ItemContent.UIName = "DungeonSettlement"
    end
    return ItemContent
end

function M:CheckIsNew(Id)
    if not Id then
        return false
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    local NowTimeStamp = GWorld.GameInstance.GameEndTime
    local StartDungeonTime = NowTimeStamp - self.PlayerTime
    for ModId, GetTime in pairs(Avatar.HoldMods) do
        if ModId == Id then
            return GetTime > StartDungeonTime
        end
    end
    return false
end

function M:OpenTipsBindEvents(Widget)
    local Events = {}
    Events.OnMenuOpenChanged = self.ItemMenuAnchorChanged
    Widget:BindEvents(self, Events)
end

--物品栏打开tips监听
function M:ItemMenuAnchorChanged()
    if UIManager(self):IsHaveMenuAnchorOpen() then
        self:UpdateMainUIInGamePadClick()
    else
        -- 检查当前输入设备类型
        if self.CurInputDeviceType == ECommonInputType.Gamepad then
            self:SwitchMainUIPCToGamePad()
            self:SetFocusInGamePad()
            --显示下方快捷键提示图标
            if self.Switcher:GetActiveWidgetIndex() ~= 1 then
                if self.IsCanAddFriend then
                    self:UpdateBottomTabsInfo(GText("UI_Friend_AddFriend"), GText("UI_Controller_CheckDetails"), true, true)
                else
                    self:UpdateBottomTabsInfo(GText("UI_Controller_CheckDetails"))
                end
            end
        else
            -- PC模式下保持PC的UI状态
            self:UpdateMainUIWithPCOrMoble()
        end
    end
end

function M:OpenTempleTipsBindEvents(Widget)
    local Events = {}
    Events.OnMenuOpenChanged = self.TempleMenuAnchorChanged
    Widget:BindEvents(self, Events)
end

--物品栏打开tips监听
function M:TempleMenuAnchorChanged()
    if UIManager(self):IsHaveMenuAnchorOpen() then
        self:UpdateMainUIInGamePadClick()
        if self.WidgetRewards.Key_Controller_Qa then
            self.WidgetRewards.Key_Controller_Qa:SetVisibility(ESlateVisibility.Collapsed)
        end
    else
        -- 检查当前输入设备类型
        if self.CurInputDeviceType == ECommonInputType.Gamepad then
            if self.WidgetRewards.Key_Controller_Qa then
                self.WidgetRewards.Key_Controller_Qa:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            end
            self:SwitchMainUIPCToGamePad()
            --self:SetFocusInGamePad()
            --显示下方快捷键提示图标
            self:UpdateBottomTabsInfo(GText("UI_Controller_CheckDetails"))
        else
            -- PC模式下保持PC的UI状态
            self:UpdateMainUIWithPCOrMoble()
        end
    end
end

function M:ShowSettlementInfo()
    --self:Show(self.HideUITag)
    if self.IsWin then
        self:PlayAnimation(self.Victory_In)
        AudioManager(self):PlayUISound(self, "event:/ui/common/level_sucess_hud_show", nil, nil)
        if self.IsStarLevel then
            local Star = self.CombatData.StarLevel
            if Star == 1 then
                AudioManager(self):PlayUISound(self, "event:/ui/common/level_success_hud_show_one_star", nil, nil)
            elseif Star == 2 then
                AudioManager(self):PlayUISound(self, "event:/ui/common/level_success_hud_show_two_stars", nil, nil)
            elseif Star == 3 then
                AudioManager(self):PlayUISound(self, "event:/ui/common/level_success_hud_show_three_stars", nil, nil)
            end
        end
        local PlayStruct = FPlayFMODSoundStruct()
        PlayStruct.FMODEventPath,PlayStruct.SelectKey = AudioManager(self):ContactPlayerStringPath(self.PlayerCharacter, "vo_victory")
        PlayStruct.EventKey = "vo_victory"
        PlayStruct.bStopWhenAttachedToDestoryed = true
        PlayStruct.bPlayAs2D = true
        PlayStruct = UE4.UAudioManager.SetObjectToFPlayFMODSoundStruct(PlayStruct, self)
        local SoundEventInstance = AudioManager(self):PlayFMODSound_Sync(PlayStruct)
    else
        self:PlayAnimation(self.Defeat_In)
        AudioManager(self):PlayUISound(self, "event:/ui/common/level_fail_hud_show", nil, nil)
        AudioManager(self):PlayFMODSoundByID(self.PlayerCharacter, 211, self.PlayerCharacter, "None", {bFollowSocket = true, EventKey = "FailedPlayerCharAudio"})
    end
    self:AddTimer(5.0,function()
        self:UpdateMainUI()
    end)
end

function M:ActivateDropPanelScrolling(bIsActive, RewardViewWidget)
    if bIsActive then
        RewardViewWidget:SetScrollBarVisibility(ESlateVisibility.Visible)
        --self.TileView_Prop:SetWheelScrollMultiplier(1)
    else
        RewardViewWidget:SetScrollBarVisibility(ESlateVisibility.Collapsed)
        --self.TileView_Prop:SetWheelScrollMultiplier(0)
    end
end

-- 真难度boss战相关
function M:ShowConfirmWindow()
    local CommonDialogParams = {}
    CommonDialogParams.RightCallbackFunction = function(_, Data, PopupUI)
        PopupUI.DontPlayOutAnimation = true
        self:DefaultContinue()
        self:UpdateSelectedInfo(Data)
    end
    CommonDialogParams.LeftCallbackFunction = function(_, Data, PopupUI)
        PopupUI.DontPlayOutAnimation = false
        self:UpdateSelectedInfo(Data)
    end

    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if self.IsHardBoss then
        UIManager:ShowCommonPopupUI(Const.Popup_SecondConfirm, CommonDialogParams, self)
    elseif self.IsWeeklyDungeon then
        UIManager:ShowCommonPopupUI(100211, CommonDialogParams, self)
    end
end

function M:UpdateSelectedInfo(Data)
    local IsSelected = Data.SelectHint.IsSelected
    local CurTimestamp = TimeUtils.NowTime()

    if self.IsHardBoss then
        EMCache:Set("IsBossBattlePopupNoMorePrompts", IsSelected, true)
        EMCache:Set("IsBossBattlePopupTimestamp", CurTimestamp, true)
    elseif self.IsWeeklyDungeon then
        EMCache:Set("IsWeeklyDungeonPopupNoMorePrompts", IsSelected, true)
        EMCache:Set("IsWeeklyDungeonPopupTimestamp", CurTimestamp, true)
    end
end


function M:ShowCountDown()
    self.RemainTime = 120
    self.MaxAutoExitTime = 120
    if not self.IsWin then
        self.RemainTime = 30
        self.MaxAutoExitTime = 30
    end
    self.CurrentTime = 0
    self.ProgressInterval = 1 / 15
    self.Bar_Click:SetPercent(0)
    self.Bar_Click:SetVisibility(ESlateVisibility.Collapsed) --策划说不显示进度条了
    self:AddTimer(1, self.CountDown, true, -1, "CountDown")
    self:AddTimer(self.ProgressInterval, self.SetProgressBar, true, -1, "SetProgressBar", nil, self.ProgressInterval)
end

function M:CountDown()
    local Text = string.format(GText("UI_Text_ExitTime"), self.RemainTime)
    self.Text_ExitTime:SetText(Text)
    if self.RemainTime <= 0 then
        self:Exit()
        self:RemoveTimer("CountDown")
        self:RemoveTimer("SetProgressBar")
    end
    self.RemainTime = self.RemainTime - 1
end

function M:SetProgressBar(Interval)
    self.CurrentTime = self.CurrentTime + Interval
    self.Bar_Click:SetPercent(self.CurrentTime / self.MaxAutoExitTime)
end

function M:CheckIsAutoNextRoundMode()
    self.IsAutoNextRound = false
    if not self:IsStandAloneSolo() then
        return
    end

    local DungeonInfo = DataMgr.Dungeon[self.DungeonId]
    if DungeonInfo then
        self.IsAutoNextRound = (DungeonInfo.AutoNextRound) and (DungeonInfo.DungeonWinMode == CommonConst.DungeonWinMode.Endless)
    end 
end

function M:CheckIsNoExpMode()
    self.IsNoExpDungeon = false
    local DungeonInfo = DataMgr.Dungeon[self.DungeonId]
    if DungeonInfo then
        local GameModeType = DungeonInfo.DungeonType
        if GameModeType == "Temple" then
            self.IsNoExpDungeon = true
        elseif GameModeType == "Party" then
            self.IsNoExpDungeon = true
        elseif GameModeType == "Abyss" then     -- 虽然这个界面不给大秘境用 但万一呢
            self.IsNoExpDungeon = true      
        end
    end
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        if self.IsHardBoss then
            self.IsNoExpDungeon = true
        elseif Avatar:IsInRougeLike() then      -- 虽然这个界面不给肉鸽用 但万一呢
            self.IsNoExpDungeon = true
        end
    end
end

function M:CheckIsWalnutMode()
    self.IsWalnut = false
    local DungeonInfo = DataMgr.Dungeon[self.DungeonId]
    if DungeonInfo then
        self.IsWalnut = DungeonInfo.IsWalnutDungeon == true
    end
end

function M:CheckIsHardBossMode()
    self.IsHardBoss = false
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar:IsInHardBoss() then
        self.IsHardBoss = true
        return
    end

    local DungeonInfo = DataMgr.Dungeon[self.DungeonId]
    if DungeonInfo then
        self.IsHardBoss = DungeonInfo.DungeonType == "HardBossDg"
    end
end 

function M:CheckAgainAvailable()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return true
    end
    if not self.IsWalnut then
        return true
    end

    if Avatar.Walnuts and Avatar.Walnuts.ValidWalnutDungeons then
        for _, DungeonIds in pairs(Avatar.Walnuts.ValidWalnutDungeons) do
            for _, DungeonId in pairs(DungeonIds) do
                if DungeonId == self.DungeonId then
                    return true
                end
            end
        end
    end
    return false
end

function M:CheckIsAutoBanMode()
  self.IsAutoBan = false
      local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self.ForbidDungeonRewardCount = Avatar.ForbidDungeonRewardCount or 0
    if self.ForbidDungeonRewardCount > 0 then
        self.IsAutoBan = true
    end 
end

function M:CheckIsTempleMode()
    self.IsTemple = false
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        error("Avatar is nil")
    end
    self.GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not self.GameMode then
        return
    end
    if Avatar:IsInDungeon() then
        local DungeonInfo = self:GetDungeonInfo(self.BattleInfo)
        if DungeonInfo.DungeonType and DungeonInfo.DungeonType == "Temple" then
            self.IsTemple = true

            -- 副本和boss战结算都需要显示但神庙结算不显示的部分
            self.Panel_Main:SetVisibility(ESlateVisibility.Collapsed)
            -- self.Text_Consume:SetVisibility(ESlateVisibility.Collapsed)
            -- self.Currency:SetVisibility(ESlateVisibility.Collapsed)
            -- self.Text_Have:SetVisibility(ESlateVisibility.Collapsed)
            -- self.Text_Split:SetVisibility(ESlateVisibility.Collapsed)
            -- self.Text_Need:SetVisibility(ESlateVisibility.Collapsed)
            self.Panel_Consume:SetVisibility(ESlateVisibility.Collapsed)
            --self.Img_Time:SetVisibility(ESlateVisibility.Collapsed)
            --self.Text_Time:SetVisibility(ESlateVisibility.Collapsed)
            self.FailTips:SetVisibility(ESlateVisibility.Collapsed)
            self.Btn_Data:SetVisibility(ESlateVisibility.Collapsed)

            -- 神庙面板可见
            self.Group_Temple:SetVisibility(ESlateVisibility.Visible)
        end
    end
end

function M:CheckIsPartyMode()
    self.IsParty = false
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        error("Avatar is nil")
    end
    self.GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not self.GameMode then
        return
    end
    if Avatar:IsInDungeon() then
        local DungeonInfo = self:GetDungeonInfo(self.BattleInfo)
        if DungeonInfo.DungeonType and DungeonInfo.DungeonType == "Party" then
            self.IsParty = true

            -- 副本和boss战结算都需要显示但神庙结算不显示的部分
            self.Panel_Main:SetVisibility(ESlateVisibility.Collapsed)
            -- self.Text_Consume:SetVisibility(ESlateVisibility.Collapsed)
            -- self.Currency:SetVisibility(ESlateVisibility.Collapsed)
            -- self.Text_Have:SetVisibility(ESlateVisibility.Collapsed)
            -- self.Text_Split:SetVisibility(ESlateVisibility.Collapsed)
            -- self.Text_Need:SetVisibility(ESlateVisibility.Collapsed)
            self.Panel_Consume:SetVisibility(ESlateVisibility.Collapsed)
            --self.Img_Time:SetVisibility(ESlateVisibility.Collapsed)
            --self.Text_Time:SetVisibility(ESlateVisibility.Collapsed)
            self.FailTips:SetVisibility(ESlateVisibility.Collapsed)
            self.Btn_Data:SetVisibility(ESlateVisibility.Collapsed)

            -- 神庙面板可见
            self.Group_Temple:SetVisibility(ESlateVisibility.Visible)
        end
    end
end

function M:CalcTempleInfo()
    self.TempleInfo = DataMgr.Temple[self.DungeonId]
    if not self.TempleInfo then
        return
    end

    local StarLevel = 0
    local Score = 0
    local Collection = 0
    local Ids = self.TempleInfo.RewardId
    if #Ids == 3 then
        self.IsStarLevel = true
        if self.CombatData.StarLevel then
            StarLevel = self.CombatData.StarLevel
        end
        if StarLevel < 0 or StarLevel > 3 then
            error("本关设置星级超出可获得的范围")
        end
    elseif #Ids == 1 then
        self.IsStarLevel = false
    else
        error("本关奖励配置有误，请正确配置星级奖励或无星级奖励")
    end

    local FailReason = ""
    if not self.IsWin then
        -- 获取失败原因
        FailReason = self.CombatData.FailReason
        StarLevel = 0
    end

    -- 星级和条件栏
    self.WidgetStar = self:CreateWidgetNew("TempleItem")
    self.WidgetStar.ParentUI = self
    self.WidgetStar.Btn_Qa:SetVisibility(ESlateVisibility.Collapsed)
    --星星
    if self.IsStarLevel then
        self.WidgetStar:SetStarLevel(StarLevel, FailReason)
    else
        self.WidgetStar:SetNoStarLevel(FailReason)
    end
    --条件
    local Rule = self.TempleInfo.SucRule
    if Rule == "Time" or (Rule == "CountDown" and self.TempleInfo.UIShowType == 1) then
        local Time = 0
        if self.CombatData.TempleTime then
            Time = self.CombatData.TempleTime
        end
        local TimeText = self:CalcTimeInfo(Time)
        self.WidgetStar:SetPoints(TimeText)
        self.WidgetStar.Text_Title:SetText(GText("UI_TEMPLE_TOTAL_TIME"))
    elseif Rule == "CountDown" then
        local Time = 0
        if self.CombatData.RemainTempleTime then
            Time = self.CombatData.RemainTempleTime
        end
        local TimeText = self:CalcTimeInfo(Time)
        self.WidgetStar:SetPoints(TimeText)
        self.WidgetStar.Text_Title:SetText(GText("UI_TEMPLE_TOTAL_COUNTDOWN"))
    elseif Rule == "Score" then
        if self.CombatData.Score then
            Score = self.CombatData.Score
        end
        self.WidgetStar:SetPoints(Score)
        self.WidgetStar.Text_Title:SetText(GText("UI_TEMPLE_TOTAL_SCORE"))
    elseif Rule == "Collect" then
        if self.CombatData.Collection then
            Collection = self.CombatData.Collection
        end
        self.WidgetStar:SetPoints(Collection)
        self.WidgetStar.Text_Title:SetText(GText("UI_TEMPLE_TOTAL_COLLECT"))
    end

    self.WidgetStar:SetVisibility(ESlateVisibility.Hidden)
    self.SizeBox_Stars:AddChild(self.WidgetStar)

    -- -- 条件栏
    -- self.WidgetPoints = self:CreateWidgetNew("TempleItem")
    -- local Rule = self.TempleInfo.SucRule
    -- if Rule == "Time" then
    --     local Time = 0
    --     if self.CombatData.TempleTime then
    --         Time = self.CombatData.TempleTime
    --     end
    --     local TimeText = self:CalcTimeInfo(Time)
    --     self.WidgetPoints:SetPoints(TimeText)
    --     self.WidgetPoints.Text_Title:SetText(GText("UI_TEMPLE_TOTAL_TIME"))
    -- elseif Rule == "CountDown" then
    --     local Time = 0
    --     if self.CombatData.RemainTempleTime then
    --         Time = self.CombatData.RemainTempleTime
    --     end
    --     local TimeText = self:CalcTimeInfo(Time)
    --     self.WidgetPoints:SetPoints(TimeText)
    --     self.WidgetPoints.Text_Title:SetText(GText("UI_TEMPLE_TOTAL_COUNTDOWN"))
    -- elseif Rule == "Score" then
    --     if self.CombatData.Score then
    --         Score = self.CombatData.Score
    --     end
    --     DebugPrint("thy    Score", Score)
    --     self.WidgetPoints:SetPoints(Score)
    --     self.WidgetPoints.Text_Title:SetText(GText("UI_TEMPLE_TOTAL_SCORE"))
    -- elseif Rule == "Collect" then
    --     if self.CombatData.Collection then
    --         Collection = self.CombatData.Collection
    --     end
    --     self.WidgetPoints:SetPoints(Collection)
    --     self.WidgetPoints.Text_Title:SetText(GText("UI_TEMPLE_TOTAL_COLLECT"))
    -- end
    -- self.WidgetPoints:SetVisibility(ESlateVisibility.Hidden)
    -- self.SizeBox_Points:AddChild(self.WidgetPoints)

    -- 奖励栏
    self.WidgetRewards = self:CreateWidgetNew("TempleItem")
    self.WidgetRewards.ParentUI = self
    local RewardsInfo = {}
    if self.IsStarLevel then
        -- 星级关卡奖励栏
        local MaxTempleStar = 0
        if self.CombatData.MaxTempleStar then
            MaxTempleStar = self.CombatData.MaxTempleStar
        end
        for i = 1, #Ids do
            local ItemData = self:GetFirstRewardInfoById(Ids[i])
            local Info = self:NewTempleContent(ItemData, i)
            table.insert(RewardsInfo, Info)
        end
        self.WidgetRewards:SetStarRewards(RewardsInfo, StarLevel, MaxTempleStar)
    else
        -- 非星级关卡奖励栏
        if Ids[1] ~= nil then
            local ItemDatas = RewardUtils:GetAllRewardByRewardId(Ids[1])
            local Rewards = {}
            self:RewardsAddToArray(Rewards, ItemDatas, false)
            self:SortRewardsArray(Rewards)
            RewardsInfo = Rewards
            -- for i = 1, #Rewards do
            --     local Info = self:NewPropContent(Rewards[i], self.TileView_Reward)
            --     table.insert(RewardsInfo, Info)
            -- end
        end
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            error("Avatar is nil")
        end
        if Avatar.Dungeons[self.DungeonId] then
            local IsPass = Avatar.Dungeons[self.DungeonId].IsPass
            self.WidgetRewards:SetNoStarRewards(RewardsInfo, IsPass, self.IntervalTime, self.FirstDelayTime)
        end
    end
    self.WidgetRewards:SetVisibility(ESlateVisibility.Hidden)
    self.SizeBox_Rewards:AddChild(self.WidgetRewards)

    -- 直接初始化奖励项目表
    self.rewardItems = {
        self.WidgetRewards.Item01,
        self.WidgetRewards.Item02,
        self.WidgetRewards.Item03,
        self.WidgetRewards.Item_Repeat
    }

    local ConfigData = {
        OwnerWidget = self.WidgetRewards,
        TextContent = GText("UI_Temple_RewardDetail"),
    }
    self.WidgetRewards.Btn_Qa:Init(ConfigData)
    self.WidgetRewards.Btn_Qa:SetVisibility(ESlateVisibility.Visible)
end

function M:CalcPartyInfo()
    self.PartyInfo = DataMgr.Party[self.DungeonId]
    if not self.PartyInfo then
        return
    end

    local StarLevel = 0
    local Score = 0
    local Collection = 0
    local Ids = self.PartyInfo.RewardId
    if #Ids == 3 then
        self.IsStarLevel = true
        if self.CombatData.StarLevel then 
            StarLevel = self.CombatData.StarLevel ---1
        else
            StarLevel = 0
        end
        if StarLevel < 0 or StarLevel > 3 then
            error("本关设置星级超出可获得的范围")
        end
    elseif #Ids == 1 then
        self.IsStarLevel = false
    else
        error("本关奖励配置有误，请正确配置星级奖励或无星级奖励")
    end

    local FailReason = ""
    if not self.IsWin then
        -- -- 获取失败原因
        -- FailReason = self.CombatData.FailReason  ---2
        -- if not FailReason then
        --     FailReason = "Quit"
        --     DebugPrint("ayff    FailReason", FailReason)
        -- end
        -- FailReason = "Quit"
        StarLevel = 0
    end

    -- 星级和条件栏
    self.WidgetStar = self:CreateWidgetNew("TempleItem")
    self.WidgetStar.ParentUI = self
    self.WidgetStar.Btn_Qa:SetVisibility(ESlateVisibility.Collapsed)
    self.WidgetStar.ParentUI = self
    --星星
    if self.IsStarLevel then
        self.WidgetStar:SetStarLevel(StarLevel, FailReason)
    else
        self.WidgetStar:SetNoStarLevel(FailReason)
    end
    self.WidgetStar.Text_Title:SetText(GText("UI_TEMPLE_TOTAL_TIME"))

    -- if self.PlayerTime then
    --     local PartyTime = self:CalcTimeInfo(self.PlayerTime)
    --     self.WidgetStar.Text_PointsNum:SetText(PartyTime)
    -- else
    --     self.WidgetStar.Text_PointsNum:SetText(0)
    -- end


    local ScenePlayers = GWorld.GameInstance.ScenePlayers
    for CurPlayerIndex, Player in ipairs(ScenePlayers) do
        if Player.IsMainPlayer then
            if self.CombatData.PartyPlayerCompleteTime[CurPlayerIndex] then
                self.WidgetStar.Text_PointsNum:SetText(self:GetTimeStr(self.CombatData.PartyPlayerCompleteTime[CurPlayerIndex]))
            else
                self.WidgetStar.Text_PointsNum:SetText(GText("UI_PARTY_PARKOUR_UNFINISH"))
            end
            break
        end
    end

    self.WidgetStar:SetVisibility(ESlateVisibility.Hidden)
    self.SizeBox_Stars:AddChild(self.WidgetStar)

    -- 奖励栏
    self.WidgetRewards = self:CreateWidgetNew("TempleItem")
    self.WidgetRewards.ParentUI = self
    local RewardsInfo = {}
    local Avatar = GWorld:GetAvatar()
    if self.IsStarLevel then
        -- 星级关卡奖励栏
        local MaxTempleStar = 0
        if Avatar.Dungeons[self.DungeonId].MaxStar then  ---3
            MaxTempleStar = Avatar.Dungeons[self.DungeonId].MaxStar
        else
            MaxTempleStar = 0
        end
        for i = 1, #Ids do
            local ItemData = self:GetFirstRewardInfoById(Ids[i])
            local Info = self:NewTempleContent(ItemData, i)
            table.insert(RewardsInfo, Info)
        end
        self.WidgetRewards:SetStarRewards(RewardsInfo, StarLevel, MaxTempleStar)
    else
        -- 非星级关卡奖励栏
        if Ids[1] ~= nil then
            local ItemDatas = RewardUtils:GetAllRewardByRewardId(Ids[1])
            local Rewards = {}
            self:RewardsAddToArray(Rewards, ItemDatas, false)
            self:SortRewardsArray(Rewards)
            RewardsInfo = Rewards
            -- for i = 1, #Rewards do
            --     local Info = self:NewPropContent(Rewards[i], self.TileView_Reward)
            --     table.insert(RewardsInfo, Info)
            -- end
        end
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            error("Avatar is nil")
        end
        if Avatar.Dungeons[self.DungeonId] then
            local IsPass = Avatar.Dungeons[self.DungeonId].IsPass
            self.WidgetRewards:SetNoStarRewards(RewardsInfo, IsPass, self.IntervalTime, self.FirstDelayTime)
        end
    end
    self.WidgetRewards:SetVisibility(ESlateVisibility.Hidden)
    self.SizeBox_Rewards:AddChild(self.WidgetRewards)

    -- 直接初始化奖励项目表
    self.rewardItems = {
        self.WidgetRewards.Item01,
        self.WidgetRewards.Item02,
        self.WidgetRewards.Item03,
        self.WidgetRewards.Item_Repeat
    }

    -- 判断复通奖励
    self.WidgetRewards.Panel_RepeatReward:SetVisibility(ESlateVisibility.Collapsed)
    local Avatar = GWorld:GetAvatar()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if (not Avatar) or (not GameState) then
        return
    end
    if self.IsParty then
        -- 获取复通奖励
        local RewardInfo = DataMgr.Reward[7005] -- 银币
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        local RepeatRewardMultiplier = {
            [0] = 0,   -- 异常情况，单人进入派对在倒计时立即退出的情况下，此时self.CombatData.NumOfPlayers概率没初始化导致其为空
            [1] = 1.0,  -- 1人倍率
            [2] = 1.5,  -- 2人倍率
            [3] = 2.0,  -- 3人倍率
            [4] = 2.5   -- 4人倍率
        }
        if RewardInfo ~= nil then
            Obj.ParentWidget = self
            Obj.Id = 101
            Obj.ItemType = "Resource"
            if DataMgr.Party[self.DungeonId] then
                -- 异常情况，单人进入派对在倒计时立即退出的情况下，此时self.CombatData.NumOfPlayers概率没初始化导致其为空
                if not self.CombatData.NumOfPlayers then
                    Obj.Count = 0
                else
                    Obj.Count = DataMgr.Party[self.DungeonId].RewardCoin[self.CombatData.StarLevel+1] * RepeatRewardMultiplier[self.CombatData.NumOfPlayers]
                end
            else
                Obj.Count = 0
            end
            Obj.Icon = ItemUtils.GetItemIconPath(101, "Resource")
            Obj.Rarity = 1
            Obj.IsShowDetails = true
            Obj.bHasGot = false
            Obj.UIName = "DungeonSettlement"
            Obj.AfterInitCallback = function(Widget) 
                if self.IsAllowPropInAnimation and (not Widget.Content.IsPlayedInAnimation) then
                    Widget:PlayInAnimation()
                    Widget.Content.IsPlayedInAnimation = true
                else 
                    Widget:PlayAnimation(Widget.Normal_In, Widget.Normal_In:GetEndTime())
                end
            end
            Obj.OnMouseButtonUpEvents = {Obj = self, Callback = function()
                self.TempleNeedFocusItemIndex = 4
            end}
            self.WidgetRewards.Panel_RepeatReward:SetVisibility(ESlateVisibility.Visible)
            self.WidgetRewards.Item_Repeat:SetVisibility(ESlateVisibility.Visible)
            local Resource = DataMgr.GlobalConstant.PartyRewardDailyLimit.ConstantValue
            local Obtained = Avatar.TodayPartyReward or 0
            -- 奖励达到上限
            if (Obj.Count + Obtained) >= Resource then
                Obtained = Resource
                Obj.bHasGot = true
                UIManager(self):ShowUITip("CommonToastMain", "UI_Party_RewardCoin_OnLimit_Toast")
                self.WidgetRewards.Text_RepeatReward:SetText(string.format(GText("UI_Party_RewardCoin_OnLimit"),Obtained,Resource))
            else
                self.WidgetRewards.Text_RepeatReward:SetText(string.format(GText("UI_Party_RewardCoin"),Obtained,Resource))
            end    
            self.WidgetRewards.Item_Repeat:Init(Obj)
            local ConfigData = {
                OwnerWidget = self.WidgetRewards,
                TextContent = GText("UI_Party_RewardDetail"),
            }
            self.WidgetRewards.Btn_Qa:Init(ConfigData)
            self.WidgetRewards.Btn_Qa:SetVisibility(ESlateVisibility.Visible)
        end
    else
        -- 单人神庙与多人联机派对，奖励情况说明不同
        local ConfigData = {
            OwnerWidget = self.WidgetRewards,
            TextContent = GText("UI_Temple_RewardDetail"),
        }
        self.WidgetRewards.Btn_Qa:Init(ConfigData)
    end
end

function M:ShowTempleStars()
    if self.WidgetStar then
        self.WidgetStar:SetVisibility(ESlateVisibility.Visible)
        self.WidgetStar:PlayStarInAnim()
    end
end

function M:ShowTemplePoints()
    if self.WidgetPoints then
        self.WidgetPoints:SetVisibility(ESlateVisibility.Visible)
        self.WidgetPoints:PlayPointsInAnim()
    end
end

function M:ShowTempleRewards()
    if self.WidgetRewards then
        self.WidgetRewards:SetVisibility(ESlateVisibility.Visible)
        self.WidgetRewards:PlayRewardsInAnim()
    end
end

function M:GetFirstRewardInfoById(RewardId)
	local RewardInfo = {}
	local RewardData = DataMgr.Reward[RewardId]
	if not RewardData then
		return RewardInfo
	end
	local RewardTypes = RewardData.Type
	local RewardIds = RewardData.Id
    local RewardCounts = RewardData.Count
	if not RewardTypes or not RewardIds or not RewardCounts then
		return RewardInfo
	end
    RewardInfo.Type = RewardTypes[1]
    RewardInfo.Id = RewardIds[1]
    RewardInfo.Count = RewardCounts[1][1]
    local ItemInfo = DataMgr[RewardInfo.Type][RewardInfo.Id]
    if ItemInfo then
        RewardInfo.Name = ItemInfo.Name or ItemInfo[RewardInfo.Type.."Name"]
        RewardInfo.Rarity = ItemInfo.Rarity or ItemInfo[RewardInfo.Type.."Rarity"]
    end
	return RewardInfo
end

function M:NewTempleContent(Content, index)
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    if Content ~= nil then
        Obj.ParentWidget = self
        Obj.Id = Content.Id
        Obj.ItemType = Content.Type
        Obj.Count = Content.Count
        Obj.Icon = ItemUtils.GetItemIconPath(Content.Id, Content.Type)
        Obj.Rarity = Content.Rarity or 1
        Obj.IsShowDetails = true
        Obj.bHasGot = Content.IsGot or false
        Obj.UIName = "DungeonSettlement"
        Obj.bAsyncLoadIcon = true
        Obj.AfterInitCallback = function(Widget) 
            if self.IsAllowPropInAnimation and (not Widget.Content.IsPlayedInAnimation) then
                Widget:PlayInAnimation()
                Widget.Content.IsPlayedInAnimation = true
            else 
                Widget:PlayAnimation(Widget.Normal_In, Widget.Normal_In:GetEndTime())
            end

            --打开tips窗口监听
            self:OpenTempleTipsBindEvents(Widget)
        end
        Obj.OnMouseButtonUpEvents = {Obj = self, Callback = function()
            self.TempleNeedFocusItemIndex = index
        end}
    end
    return Obj
end

function M:CalcTimeInfo(Time)
    local Hour = math.floor(Time / 3600)
    Time = Time % 3600
    local Minute = math.floor(Time / 60)
    local Second = math.floor(Time % 60)
    -- local TimeText = ""
    -- if Hour > 0 then
    --     TimeText = TimeText..Hour..GText("UI_GameEvent_TimeRemain_Hour")
    --     if Minute < 10 then
    --         TimeText = TimeText .. "0"
    --     end
    -- end
    -- if Second < 10 then
    --     TimeText = TimeText..Minute.."分".."0"..Second..GText("UI_GameEvent_TimeRemain_Sec")
    -- else
    --     TimeText = TimeText..Minute..GText("UI_GameEvent_TimeRemain_Min")..Second..GText("UI_GameEvent_TimeRemain_Sec")
    -- end
    local FinalResult = nil
    if Hour > 0 then
        FinalResult = string.format("%02d%s%02d%s", Hour, GText("UI_GameEvent_TimeRemain_Hour"), Minute, GText("UI_GameEvent_TimeRemain_Min"))
    else
        FinalResult = string.format("%02d%s%02d%s", Minute, GText("UI_GameEvent_TimeRemain_Min"), Second, GText("UI_GameEvent_TimeRemain_Sec"))
    end
    return FinalResult
end

--------------------------------------------------------------- 手柄相关---------------------------------------------------------------

function M:InitDeviceInfo()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.NavigateWidget = self.GameInputModeSubsystem and self.GameInputModeSubsystem:GetNavigateWidget()
        --隐藏导航图标
    if self.NavigateWidget then
        self.NavigateWidget:SetVisibility(ESlateVisibility.Collapsed)
    end
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function M:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if not self:HasFocusedDescendants() and not self:HasAnyUserFocus() and self.CurInputDeviceType then
        return
    end
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        DebugPrint("thy    已经显示的是该输入模式，不需要进行刷新")
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName
    self.IsSwitchDevice = true
    --更新UI
    self:UpdateMainUI()
end

function M:UpdateMainUI()
    if not self.IsNotFirstUpdateMainUI then
        self.IsNotFirstUpdateMainUI = true
        return
    end
    if not self.CurInputDeviceType then
        self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    end
    -- body
    if self.CurInputDeviceType == ECommonInputType.Touch then
        DebugPrint("thy    IsMoblie")
        return
    end
    if not self:HasFocusedDescendants() and not self:HasAnyUserFocus() then
        DebugPrint("ljl@ 已聚焦至上级界面 不聚焦到该界面")
        return
    end
    --先聚焦到界面上，以免在切换设备时后续丢失聚焦
    self:SetFocus()
    if self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard then
        DebugPrint("thy   IsPC")
        self:UpdateMainUIWithPCOrMoble()
    else
        DebugPrint("thy   IsGamePad")
        self:UpdateMainUIWithGamePad()
    end
end

function M:SetFocusInGamePad()
    DebugPrint("jly Set Focus In GamePad")
    if self:IsAnimationPlaying(self.Defeat_In) or self:IsAnimationPlaying(self.Victory_In) then
        DebugPrint("jly Set Focus In GamePad, but animation is playing")
        return
    end
    if not self:HasFocusedDescendants() and not self:HasAnyUserFocus() then
        return
    end
    -- 神庙页面有另一套聚焦逻辑
    if self.IsTemple then
        if self.IsStarLevel then
            if self.TempleNeedFocusItemIndex then
                local Item = self.rewardItems[self.TempleNeedFocusItemIndex]
                Item:SetFocus()
            else
                self.rewardItems[1]:SetFocus()
            end
        else
            self.WidgetRewards.List_Reward:SetFocus()
        end
        return
    end
    if self.IsInAddFriendMode then
        self.Data01:SetFocus()
        return
    end
    --聚焦默认先聚焦到委托奖励栏/掉落奖励栏上
    if #self.SpRewardsArray == 0 then
        if #self.RewardsArray ~= 0 then
            if self.TileView_Prop:GetItemAt(0) and self.TileView_Prop:GetItemAt(0).SelfWidget then
                self:SetFoucsOnTileView(self.TileView_Prop)
            else
                self:SetFocusOnTileViewDelay(self.TileView_Prop)
            end
        else
            --self:SetFocus()
            self.Panel_DropAndDetails:SetFocus()
            self.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
            self.NavigateWidget:SetVisibility(ESlateVisibility.Collapsed)
        end
    else
        if self.TileView_Reward:GetItemAt(0) and self.TileView_Reward:GetItemAt(0).SelfWidget then
            self:SetFoucsOnTileView(self.TileView_Reward)
        else
            self:SetFocusOnTileViewDelay(self.TileView_Reward)
        end
        if #self.RewardsArray == 0 then
            --self.TileView_Reward:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
            self.TileView_Prop.bIsFocusable = true
        end
    end
    if self.IsCanAddFriend then
        self:UpdateBottomTabsInfo(GText("UI_Friend_AddFriend"), GText("UI_Controller_CheckDetails"),  true, true)
    else
        self:UpdateBottomTabsInfo(GText("UI_Controller_CheckDetails"))
    end
end

function M:SetFocusOnTileViewDelay(TileView)
    self:AddTimer(0.1, function()
        DebugPrint("jly Focus On TileView Delay")
        if self:IsAnimationPlaying(self.Defeat_In) or self:IsAnimationPlaying(self.Victory_In) then
            DebugPrint("jly Focus On TileView Delay, but animation is playing")
            return
        end
        local ItemContent = TileView:GetItemAt(0)
        if ItemContent and ItemContent.SelfWidget then
            self.NavigateWidget:SetVisibility(ESlateVisibility.Visible)
            TileView.bIsFocusable = true
            TileView:SetFocus()
            TileView:SetSelectedIndex(0)
            local item = ItemContent.SelfWidget
            item:StopAllAnimations()
            item:PlayAnimation(item.Hover)
            self:RemoveTimer("SetFocusInGamePad")
        end
    end, true, 0.5, "SetFocusInGamePad")
end

function M:SetFoucsOnTileView(TileView)
    self.NavigateWidget:SetVisibility(ESlateVisibility.Visible)
    TileView.bIsFocusable = true
    TileView:SetFocus()
    TileView:SetSelectedIndex(0)
    local item = TileView:GetItemAt(0).SelfWidget
    item:StopAllAnimations()
    item:PlayAnimation(item.Hover)
end

function M:UpdateBottomTabsInfo(ATipName, BTipName, AddFriendModeA, AddFriendModeB)
    if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
        return
    end
    if ATipName then
        local KeyInfo1 = {}
        if AddFriendModeA then
            KeyInfo1 = {
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "X",
                },
            },
            Desc = ATipName,
            }
        else
            KeyInfo1 = {
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "A",
                },
            },
            Desc = ATipName,
            }
        end
        self.Key_Confirm:SetVisibility(ESlateVisibility.Visible)
        self.Key_Confirm:CreateCommonKey(KeyInfo1)--A 确认
    else
        self.Key_Confirm:SetVisibility(ESlateVisibility.Collapsed)
    end
    if BTipName then
        local KeyInfo2 = {}
        if AddFriendModeB then
            KeyInfo2 = {
                KeyInfoList={
                    {
                        Type = "Img",
                        ImgShortPath = "A",
                    },
                },
                Desc = BTipName,
            }
        else
            KeyInfo2 = {
                KeyInfoList={
                    {
                        Type = "Img",
                        ImgShortPath = "B",
                    },
                },
                Desc = BTipName,
            }
        end
        self.Key_Cancel:SetVisibility(ESlateVisibility.Visible)
        self.Key_Cancel:CreateCommonKey(KeyInfo2) -- B返回
    else
        self.Key_Cancel:SetVisibility(ESlateVisibility.Collapsed)
    end
    if ATipName or BTipName then
        self.Panel_Controller:SetVisibility(ESlateVisibility.Visible)
        self.Panel_Key:SetVisibility(ESlateVisibility.Collapsed)
    else
        --self.Panel_Controller:SetVisibility(ESlateVisibility.Collapsed)
    end
end

--更新为手柄图标
function M:UpdateMainUIWithGamePad()
    if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
        return
    end
    -----以下为手柄
    if not self.IsFirstFocus then
        self:SetFocusInGamePad()
    end
    --战斗数据统计图标更换
    if self.Switch_Mode then
        self.Switch_Mode:SetActiveWidgetIndex(1)
    end
    local KeyInfo = {
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Menu",
            },
        },
    }
    self.Icon_Key_Data:CreateCommonKey(KeyInfo)
    --体力消耗左边图标更新
    local Params = {
        ResourceId = 103, -- 精力
        bShowDenominator = true,--现有精力
        CostText = nil,--提示文本
        Denominator = self.DungeonCost,-- 副本消耗
        Numerator = self.CurActionPoint, -- 现有精力 
        KeyIconName = "LS", -- 快捷键图标，手柄图标？
        Owner = self,
    }
    self.Cost:InitContent(Params)
    --再次进行按钮图标更新
    self.Btn_Continue:SetDefaultGamePadImg("Y")
    --退出关卡按钮图标更新
    self.Btn_Close:SetDefaultGamePadImg("B")
    --返还道具处图标更新，监听按键 直接聚焦到返还道具栏 再次按按键或者B退出返还道具状态
    self.Refund:Show()
    self.Refund:UpdateGamePadIcon("RS")
    --结算界面上方提示的按键图标更新
    local KeyInfo2 = {
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "RH",
            },
        },
        Desc = GText("UI_DynInteract_1"),
    }
    self.Icon_Key_FailTips:CreateCommonKey(KeyInfo2)
    if (not self.IsWin) and CommonUtils.Size(DataMgr.FailureGuidance) > 7 then
        if self.Controller_FailTips then
            self.Controller_FailTips:SetVisibility(ESlateVisibility.Visible)
        end
    else
        if self.Controller_FailTips then
            self.Controller_FailTips:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
    self.Panel_Controller:SetVisibility(ESlateVisibility.Visible)
    self.Panel_Key:SetVisibility(ESlateVisibility.Collapsed)
    if not self.IsTemple then
        if #self.SpRewardsArray > 0 or #self.RewardsArray > 0 then
            if self.IsCanAddFriend then
                self:UpdateBottomTabsInfo(GText("UI_Friend_AddFriend"), GText("UI_Controller_CheckDetails"),  true, true)
            else
                self:UpdateBottomTabsInfo(GText("UI_Controller_CheckDetails"))
            end
        else
            self:UpdateBottomTabsInfo()
        end
        -- 遍历self.TileView_Prop，设置他的导航到self.TileView_Reward
        -- for i = 0, self.TileView_Prop:GetNumItems() - 1 do
        --     local Item = self.TileView_Prop:GetItemAt(i)
        --     if Item and Item.SelfWidget then
        --         Item.SelfWidget:SetNavigationRuleExplicit(EUINavigation.Up, self.TileView_Reward)
        --     end
        -- end
        -- 遍历self.TileView_Reward，设置他的导航到self.TileView_Prop
        for i = 0, self.TileView_Reward:GetNumItems() - 1 do
            local Item = self.TileView_Reward:GetItemAt(i)
            if Item and Item.SelfWidget then
                Item.SelfWidget:SetNavigationRuleExplicit(EUINavigation.Down, self.TileView_Prop)
            end
        end
    else
        self:UpdateBottomTabsInfo(GText("UI_Controller_CheckDetails"))
        self.WidgetRewards.Key_Controller_Qa:SetVisibility(ESlateVisibility.Visible)
        self.WidgetRewards.Key_Controller_Qa:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "RS"
                }
            }
        })
        -- 设置导航规则
        local lastItem = nil
        for i, currentItem in ipairs(self.rewardItems) do
            if currentItem then
                if lastItem then
                    -- 设置双向导航
                    lastItem:SetNavigationRuleExplicit(EUINavigation.Right, currentItem)
                    currentItem:SetNavigationRuleExplicit(EUINavigation.Left, lastItem)
                else
                    -- 第一个项目左侧停止
                    currentItem:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
                end
                
                -- 最后一个有效项目右侧停止
                local nextItem = self.rewardItems[i+1]
                if not nextItem then
                    currentItem:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
                end
                lastItem = currentItem
            end
        end
    end
    if self.WBP_Chat_CommonEnter and self.WBP_Chat_CommonEnter.IsShowGamePad then
        self.WBP_Chat_CommonEnter:IsShowGamePad(true)
    end
    -- 更新自动下一轮UI样式
    self.AutoNextRound:UpdateUIStyleInPlatform(false)
end

--更新为电脑图标
function M:UpdateMainUIWithPCOrMoble()
    --战斗数据统计图标更换
    if self.Switch_Mode then
        self.Switch_Mode:SetActiveWidgetIndex(0)
    end
    
    --体力消耗左边图标更新
    local Params = {
        ResourceId = 103, -- 精力
        bShowDenominator = true,--现有精力
        CostText = nil,--提示文本
        Denominator = self.DungeonCost,-- 副本消耗
        Numerator = self.CurActionPoint, -- 现有精力 
        KeyIconName = nil, -- 快捷键图标，手柄图标？
        Owner = self,
    }
    self.Cost:InitContent(Params)
    --返还道具处图标更新，监听按键 直接聚焦到返还道具栏 再次按按键或者B退出返还道具状态
    self.Refund:UpdateGamePadIcon("None")
    --隐藏失败快捷键提示
    if self.Controller_FailTips then
        self.Controller_FailTips:SetVisibility(ESlateVisibility.Collapsed)
    end
    --隐藏返还道具手柄图标
    self.Refund:Hide()
    --隐藏下方快捷键提示图标
    if self.IsSwitchDevice and self.Panel_Controller then
        self.Panel_Controller:SetVisibility(ESlateVisibility.Collapsed)
        self.Panel_Key:SetVisibility(ESlateVisibility.Visible)
    else
        self:UpdateBottomTabsInfo()
    end
    if self.IsTemple and self.WidgetRewards.Key_Controller_Qa then
        self.WidgetRewards.Key_Controller_Qa:SetVisibility(ESlateVisibility.Collapsed)
    end
    if self.WBP_Chat_CommonEnter and self.WBP_Chat_CommonEnter.IsShowGamePad then
        self.WBP_Chat_CommonEnter:IsShowGamePad(false)
    end
    -- 更新自动下一轮UI样式
    self.AutoNextRound:UpdateUIStyleInPlatform(true)
    self.AutoNextRound:SetAutoNextRoundFocus(false)
    self.CurrentFocusType = ""             -- 热切的时候干脆让他聚焦回主界面算了
    DebugPrint("thy     Update PC")
    self:InitHandleKeyInfo()
end

--手柄模式下点击部分按钮，其他图标临时切换会PC图标(专用)
function M:UpdateMainUIInGamePadClick()
    --战斗数据统计图标更换
    if self.Switch_Mode then
        self.Switch_Mode:SetActiveWidgetIndex(0)
    end
    --体力消耗左边图标更新
    self.Cost.Key:SetVisibility(ESlateVisibility.Collapsed)
    --再次进行按钮图标更新
    self.Btn_Continue:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
    self.Btn_Continue:SetIconPanelVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    --退出关卡按钮图标更新
    self.Btn_Close:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
    self.Btn_Close:SetIconPanelVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    --隐藏失败快捷键提示
    if self.Controller_FailTips then
        self.Controller_FailTips:SetVisibility(ESlateVisibility.Collapsed)
    end
    --隐藏返还道具手柄图标
    self.Refund:Hide()
    --隐藏下方快捷键提示图标
    if self.Key_Confirm then
        self.Key_Confirm:SetVisibility(ESlateVisibility.Collapsed)
    end
    if self.Key_Cancel then
        self.Key_Cancel:SetVisibility(ESlateVisibility.Collapsed)
    end
end

--手柄模式下点击部分按钮，从PC图标切换会手柄(专用)
function M:SwitchMainUIPCToGamePad()
    --战斗数据统计图标更换
    if self.Switch_Mode then
        self.Switch_Mode:SetActiveWidgetIndex(1)
    end
    local KeyInfo = {
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Menu",
            },
        },
    }
    if self.Icon_Key_Data then
        self.Icon_Key_Data:CreateCommonKey(KeyInfo)
    end
    --体力消耗左边图标更新
    self.Cost.Key:SetVisibility(ESlateVisibility.Visible)
    --再次进行按钮图标更新
    self.Btn_Continue:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    self.Btn_Continue:SetIconPanelVisibility(UIConst.VisibilityOp["Collapsed"])
    --退出关卡按钮图标更新
    self.Btn_Close:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    self.Btn_Close:SetIconPanelVisibility(UIConst.VisibilityOp["Collapsed"])
    --返还道具处图标更新，监听按键 直接聚焦到返还道具栏 再次按按键或者B退出返还道具状态
    self.Refund:Show()
    --结算界面上方提示的按键图标更新
    if (not self.IsWin) and CommonUtils.Size(DataMgr.FailureGuidance) > 7 then
        if self.Controller_FailTips then
            self.Controller_FailTips:SetVisibility(ESlateVisibility.Visible)
        end
    else
        if self.Controller_FailTips then
            self.Controller_FailTips:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
    if not self.IsTemple then
        if #self.SpRewardsArray > 0 or #self.RewardsArray > 0 then
            if self.IsCanAddFriend then
                self:UpdateBottomTabsInfo(GText("UI_Friend_AddFriend"), GText("UI_Controller_CheckDetails"), true, true)
            else
                self:UpdateBottomTabsInfo(GText("UI_Controller_CheckDetails"))
            end
        else
            self:UpdateBottomTabsInfo()
        end
    end
end

--PC监听
function M:Handle_OnPCDown(InKeyName)
    DebugPrint("thy   Handle_OnPCDown", InKeyName)
    if InKeyName == "Escape" then
        self.Btn_Close:OnBtnClicked()
        return true
    elseif InKeyName == "V" then
        self.Btn_Data:OnBtnClicked()
        return true
    elseif InKeyName == "R" then
        self:OnBtnContinueClicked()
        return true
    end
    return false
end

--手柄监听
function M:Handle_OnGamePadDown(InKeyName)
    -- 神庙页面操作逻辑不一样
    if self.IsTemple then
        if (InKeyName == "Gamepad_FaceButton_Top") then -- 退出
            --self:Continue()
            self:OnBtnContinueClicked()
            return true
        elseif (InKeyName == "Gamepad_FaceButton_Right") then -- 重新聚焦
            if self.IsFocusInTips and self.WidgetRewards.Key_Controller_Qa then
                self.WidgetRewards.Key_Controller_Qa:SetVisibility(ESlateVisibility.Visible)
                self:SetFocusInGamePad()
                self.IsFocusInTips = false
                self.WidgetRewards.Btn_Qa:CloseMenuAnchor()
                self:UpdateBottomTabsInfo(GText("UI_Controller_CheckDetails"))
            else
                self.Btn_Close:OnBtnClicked()
                return true
            end
            return true
        elseif (InKeyName == "Gamepad_RightThumbstick") then --提示
            self.IsFocusInTips = true
            if self.WidgetRewards.Key_Controller_Qa then
                self.WidgetRewards.Key_Controller_Qa:SetVisibility(ESlateVisibility.Collapsed)
            end
            -- 检查哪个Item有焦点
            local PlayerController = self:GetOwningPlayer()
            for i, item in ipairs(self.rewardItems) do
                if item and item:HasUserFocus(PlayerController) then
                    self.TempleNeedFocusItemIndex = i
                    break
                end
            end
            self.WidgetRewards.Btn_Qa:SetFocus()
            self.WidgetRewards.Btn_Qa:OpenMenuAnchor()
            self:UpdateBottomTabsInfo(nil, GText("UI_Tips_Close"))
            return true
        end
        return false
    end
    local IsDpadUp = self.GamePadPressingKeys[Const.GamepadDPadUp] == true      -- 组合键检测：方向键上是否按下
    DebugPrint("thy    Handle_OnGamePadDown", InKeyName, "CurrentFocusType", self.CurrentFocusType, "IsDpadUp", IsDpadUp)
    if (InKeyName == "Gamepad_FaceButton_Top") then -- 继续游戏
        --self:Continue()
        -- if GWorld.DungeonSettlementAgainInVisible or self.IsWalnut then
        --     return true
        -- end
        if self.IsInAddFriendMode then
            return false
        end
        if self.CurrentFocusType == "AutoNextRound" then    -- 聚焦在自动下一轮组件时，禁用此输入，下同. todo: 写个统一的检查是否响应输入的方法 等有缘人吧
            return false 
        end
        self:OnBtnContinueClicked()
        return true
    elseif (InKeyName == "Gamepad_FaceButton_Left") then --进入加好友模式
        if self.IsCanAddFriend then
            self.IsInAddFriendMode = true
            self.Data01:SetFocus()
            --self:UpdateMainUIInGamePadClick() 
            self:UpdateBottomTabsInfo(GText("UI_Tips_Ensure"), GText("UI_Tips_Close"))
        end
        return true
    elseif (InKeyName == "Gamepad_Special_Right") then --战斗数据
        if self.IsInAddFriendMode then
            return false
        end
        if (UIManager(self):GetUIObj("CommonDialog")) then
            return false
        end
        -- if not self.bOpenBattleDataTip then
        --     return false
        -- end
        if self.CurrentFocusType == "AutoNextRound" then 
            return false 
        end
        self:OnBtnChangePanelClicked()
        return true
    elseif (InKeyName == "Gamepad_RightThumbstick") then --进入/退出返还道具栏
        -- 组合键检测：方向键上 + 右摇杆 按下，聚焦到下一轮自动开始组件
        if IsDpadUp then                                 
            if self.IsAutoNextRound then
                -- 清按键状态
                self.GamePadPressingKeys["Gamepad_DPad_Up"] = nil
                self.GamePadPressingKeys["Gamepad_RightThumbstick"] = nil
                self.AutoNextRound:SetAutoNextRoundFocus(true)          -- 聚焦到自动下一轮组件
                self.AutoNextRound:UpdateUIStyleInPlatform(true)        -- 隐藏提示按钮
                self:UpdateMainUIInGamePadClick()                       -- 临时切换为Pc图标
                self.CurrentFocusType = "AutoNextRound"
                return true
            else
                return false
            end
        else
            -- 原逻辑：只按了右摇杆 进入/退出返还道具栏
            if self.CurrentFocusType == "AutoNextRound" then 
                return false 
            end
            if not self.IsWin then
                if self.Refund:GetFocusState() then
                    self.IsInRefund = false
                    self.Refund:CancelItemListFocus()--取消返还道具栏聚焦
                    self:SetFocusInGamePad()--重新把聚焦设置到整个页面
                    self:SwitchMainUIPCToGamePad()--切换回手柄图标
                    return true
                end
                self.IsInRefund = true
                self.NavigateWidget:SetVisibility(ESlateVisibility.Visible)
                self.Refund:SetItemListFocus()
                self:UpdateMainUIInGamePadClick()--临时切换为Pc图标
                self:UpdateBottomTabsInfo(GText("UI_Controller_CheckDetails"), GText("UI_Tips_Close"))
            end
            return true
        end
    elseif (InKeyName == "Gamepad_FaceButton_Right") then --退出返还道具栏.
        if self.IsInAddFriendMode then
            self.IsInAddFriendMode = false
            self:UpdateBottomTabsInfo(GText("UI_Friend_AddFriend"), GText("UI_Controller_CheckDetails"), true, true)
            self:SetFocusInGamePad()
            return true
        end
        if self.CurrentFocusType == "AutoNextRound" then 
            self.AutoNextRound:SetAutoNextRoundFocus(false)         -- 聚焦到自动下一轮组件
            self.AutoNextRound:UpdateUIStyleInPlatform(false)       -- 显示提示按钮
            self:SwitchMainUIPCToGamePad()                          -- 切换回手柄图标
            self.CurrentFocusType = ""
            self:UpdateMainUI()
            return true 
        end
        if not self.IsInRefund then
            self.Btn_Close:OnBtnClicked()
            return true
        end
        if not self.IsWin then
            if self.Refund:GetFocusState() then
                self.IsInRefund = false
                self.Refund:CancelItemListFocus()
                self:SetFocusInGamePad()
            end
        end
        self:UpdateBottomTabsInfo(GText("UI_Tips_Ensure"), GText("UI_Tips_Close"))
        self:SwitchMainUIPCToGamePad()--切换回手柄图标
        return true
    elseif (InKeyName == "Gamepad_LeftThumbstick") then --打开体力消耗详情
        -- self.Cost:OpenTip()
        -- self:UpdateMainUIInGamePadClick()--临时切换为Pc图标
        if self.IsAutoBan then
            local Params = {}
            local PunishCountText = string.format(GText("UI_DungeonPunish_Times"), self.ForbidDungeonRewardCount)
            Params.Tips = {
                PunishCountText
            }
            AudioManager(self):PlayUISound(self, "event:/ui/activity/baned_click", nil, nil)
            UIManager(self):ShowCommonPopupUI(100333,Params)
        end
        if self.CurrentFocusType == "AutoNextRound" then
            return false
        end
        return true
    elseif (InKeyName == "Gamepad_RightStick_Right") then
        if self.CurrentFocusType == "AutoNextRound" then 
            return false 
        end
        if self.FailTipsNum then
            self.CurFailTipIndex = math.min(self.CurFailTipIndex + 1, self.FailTipsNum)
            self.FailTips.List_Tips:NavigateToIndex(self.CurFailTipIndex)
        end
        return true
    elseif (InKeyName == "Gamepad_RightStick_Left") then
        if self.CurrentFocusType == "AutoNextRound" then 
            return false 
        end
        if self.FailTipsNum then
            self.CurFailTipIndex = math.max(self.CurFailTipIndex - 1, 0)
            self.FailTips.List_Tips:NavigateToIndex(self.CurFailTipIndex)
        end
        return true
    end
    if (InKeyName == Const.GamepadSpecialLeft) then 
        if self.CurrentFocusType == "AutoNextRound" then 
            return false 
        end
        if self.WBP_Chat_CommonEnter then
            if self.WBP_Chat_CommonEnter.ControllerKeyImg then
                self.WBP_Chat_CommonEnter.ControllerKeyImg:OnButtonPressed()
            else
                self.WBP_Chat_CommonEnter:OnClick()
            end
        end
        return true
    end
    return false
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    --DebugPrint("thy    OnPreviewKeyDown", InKeyName)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        self.GamePadPressingKeys[InKeyName] = true
    end
    if InKeyName == "Enter" and self.WBP_Chat_CommonEnter and self.WBP_Chat_CommonEnter.OnClick then
        self.WBP_Chat_CommonEnter:OnClick()
        IsEventHandled = true
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

function M:OnPreviewKeyUp(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    --DebugPrint("thy    OnPreviewKeyUp", InKeyName)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        self.GamePadPressingKeys[InKeyName] = false
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

--监听PC/手柄按键
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        DebugPrint("thy    Key_IsGamepadKey", InKeyName)
        IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
    else
        DebugPrint("thy    Key_IsPC", InKeyName)
        IsEventHandled = self:Handle_OnPCDown(InKeyName) 
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == Const.GamepadSpecialLeft) then 
        if self.WBP_Chat_CommonEnter then
            if self.WBP_Chat_CommonEnter.ControllerKeyImg then
                self.WBP_Chat_CommonEnter.ControllerKeyImg:OnButtonReleased()
            end
        end
        IsEventHandled = true
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

-- function M:OnFocusReceived()
--     local CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
--     CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    
--     -- 手柄端收到聚焦时，默认选择
--     if CurInputDeviceType == UE4.ECommonInputType.Gamepad then 
--         --self:SetFocusInGamePad()
--     end
--     return true
-- end

function M:OnTeamMatchTimingStart()
    self.Btn_Continue:ForbidBtn(true)
    --self.Btn_Continue:BindForbidStateExecuteEvent(self, function()
    --    UIManager(self):ShowUITip("CommonToastMain", GText("UI_Event_ModDrop_Exhausted"))
    --end)
end

function M:OnTeamMatchTimingEnd()
    self.Btn_Continue:ForbidBtn(false)
end

function M:TryEnterDungeonAgain()
    DebugPrint("gmy@WBP_DungeonSettlement_C M:TryEnterDungeonAgain")
    -- 1. 如果是单人情况下，先选选票
    -- 2. 如果是多人情况下，直接调用并发起流程. 进入SPONSOR_WAITING_CONFIRM
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    if nil == self.DungeonId then
        return
    end

    local bIsSolo = self:IsSolo()
    local bIsStandAloneSolo = self:IsStandAloneSolo()
    local DungeonData = DataMgr.Dungeon[self.DungeonId]

    local bNeedTicket = (DungeonData.TicketId and #DungeonData.TicketId ~= 0) or DungeonData.NoTicketEnter
    
    DebugPrint("gmy@WBP_DungeonSettlement_C M:TryEnterDungeonAgain", bIsSolo, bIsStandAloneSolo, bNeedTicket)
    if bIsStandAloneSolo and bNeedTicket then
        self:OpenTicketDialog()
    elseif bIsSolo then
        if bNeedTicket then
            Avatar:EnterDungeonAgain(function(Ret)
                DebugPrint("gmy@WBP_DungeonSettlement_C M:EnterDungeonAgain Callback1", Ret)
                -- 这种情况下，是NotifySettlementAreaPlayerSelectTicket来通知打开选票
            end)
        else
            Avatar:EnterDungeonAgain(function(Ret)
                DebugPrint("gmy@WBP_DungeonSettlement_C M:EnterDungeonAgain Callback2", Ret)
                if Ret == ErrorCode.RET_SUCCESS then
                    UIManager(self):LoadUINew("DungeonMatchTimingBar",
                            self.DungeonId, Const.DUNGEON_MATCH_BAR_STATE.WAITING_MATCHING_WITH_CANCEL, true)
                end
            end)
        end
        
    else
        Avatar:EnterDungeonAgain(function(Ret)
            DebugPrint("gmy@WBP_DungeonSettlement_C M:EnterDungeonAgain Callback", Ret)
            if Ret == ErrorCode.RET_SUCCESS then
                UIManager(self):LoadUINew("DungeonMatchTimingBar",
                        self.DungeonId, Const.DUNGEON_MATCH_BAR_STATE.SPONSOR_WAITING_CONFIRM, false)
            end
        end)
    end
end

function M:IsSolo()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return true
    end
    return not Avatar:IsInMultiSettlement()
end

-- 单人且单机环境
function M:IsStandAloneSolo()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return true
    end
    return Avatar.SettlementUidArray == nil
end

function M:OpenTicketDialog(DungeonId)
    local CommonDialog = UIManager(self):ShowCommonPopupUI(100123, {
        DungeonId = self.DungeonId,
        RightCallbackObj = self,
        RightCallbackFunction = function(Obj, PackageData)
            local SelectedTicketId = PackageData.Content_1.TicketId
            if self.IsAutoNextRound then
                DebugPrint("ljl@WBP_DungeonSettlement_C M:OpenTicketDialog SetTicketId", SelectedTicketId)
                GWorld.GameInstance:SetTicketId(SelectedTicketId)
            end

            local Avatar = GWorld:GetAvatar()
            Avatar:EnterDungeonAgain(function(Ret)
                self:BlockAllUIInput(false)
                DebugPrint("gmy@WBP_DungeonSettlement_C M:OpenTicketDialog Callback", Ret)
            end, SelectedTicketId)
            self:BlockAllUIInput(true)
            self:AddTimer(10, function()
                if self and self:IsAllUIInputBlocked() then
                    self:BlockAllUIInput(false)
                end
            end)
        end,
        ForbiddenRightCallbackObj = self,
        AutoFocus = true
    }, self)
end

function M:BP_GetDesiredFocusTarget()
    DebugPrint("ljl@ BP_GetDesiredFocusTarget")
    -- if self.CurInputDeviceType == ECommonInputType.Gamepad then
    --     self:SetFocusInGamePad()
    -- end
    -- return self

    if self:IsAnimationPlaying(self.Defeat_In) or self:IsAnimationPlaying(self.Victory_In) then
        return self
    end
    -- 神庙页面有另一套聚焦逻辑
    if self.IsTemple then
        return self.WidgetRewards.List_Reward
    end
    --聚焦默认先聚焦到委托奖励栏/掉落奖励栏上
    if self.SpRewardsArray then
        if #self.SpRewardsArray == 0 then
            if #self.RewardsArray ~= 0 then
                return self.TileView_Prop
            else
                return self
            end
        else
            return self.TileView_Reward
        end
    end
end

function M:InitHandleKeyInfo()
    if ModController:IsMobile() then
        return
    end
    self.Panel_Key:SetVisibility(ESlateVisibility.Visible)
    self.WBox_Key:ClearChildren()
    local Item1 = self:CreateWidgetNew("ComKeyTextDesc")
    local Item2 = self:CreateWidgetNew("ComKeyTextDesc")
    local Item3 = self:CreateWidgetNew("ComKeyTextDesc")

    Item1:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Text",
                Text = "V",
                ClickCallback = self.OnBtnChangePanelClicked,
                Owner = self
            },
        },
        Desc = GText("UI_BATTLE_DATA"),
    })
    Item2:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Text",
                Text = "R",
                ClickCallback = function()
                    self:OnBtnContinueClicked()
                end,
                Owner = self
            },
        },
        Desc = GText("UI_MISSION_AGAIN"),
    })
    Item3:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Text",
                Text = "Esc",
                ClickCallback = self.Exit,
                Owner = self
            },
        },
        Desc = GText("UI_Esc_ExitDungeon"),
    })
    local DungeonInfo = self:GetDungeonInfo(self.BattleInfo)
    if DungeonInfo and DungeonInfo.DungeonType and DungeonInfo.DungeonType ~= "Temple" and DungeonInfo.DungeonType ~= "Party" then
        self.WBox_Key:AddChild(Item1)
    elseif self.IsHardBoss then
        self.WBox_Key:AddChild(Item1)
    end
    self.WBox_Key:AddChild(Item2)
    self.WBox_Key:AddChild(Item3)
end

function M:OnBtnContinueClicked()
    if self.Btn_Continue:IsBtnForbidden() then
        self.Btn_Continue.CurrentClickIsForbid = true
    end
    self.Btn_Continue:OnBtnClicked()
end

function M:InitAutoNextRoundContent()
    if not self.IsAutoNextRound then
        self.AutoNextRound:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end

    self.AutoNextRound:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.AutoNextRound:Init(DataMgr.Dungeon[self.DungeonId])    -- 这里只做控件的初始化，真正把选择结果报到服务端的逻辑写在continue. 该需求只有单机用，和委托页面逻辑保持一致。如果要支持联机就不这么写了
end

function M:InitBanReward()
    if self.IsAutoBan then
        self.Switcher:SetActiveWidgetIndex(2)
        self.WBP_Ban:InitPunishCount(self.ForbidDungeonRewardCount)
    end
end

AssembleComponents(M)

return M
