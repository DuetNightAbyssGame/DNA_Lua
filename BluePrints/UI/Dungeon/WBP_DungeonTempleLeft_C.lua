--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Dungeon_Temple_Left_C
local M = Class("BluePrints.UI.Dungeon.WBP_DungeonUIBase_C")

function M:Initialize(Initializer)
    self.Super.Initialize(self)
    --self.ScoreOrCollect = 0   --总分
    -- self.InAnimationScore = 0   --记录在播放动画的过程中累积的得分
    self.CurTime = 0  -- 剩余时间
    --self.CurStar = 0  -- 当前达成的星级
    --self.IsStarTemple = false  -- 是否为星级神庙
end

function M:AddTaskToOverlay(BattleMainUI)
    self.Super.AddTaskToOverlay(self, BattleMainUI)

    -- local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    -- if not GameInstance then
    --     return
    -- end
    -- local DungeonId = GameInstance:GetCurrentDungeonId()
    -- local DungeonInfo = DataMgr.Dungeon[DungeonId]
    -- if DungeonInfo.DungeonType == "Temple" then
    --     BattleMainUI:SetOverrideInfo(BattleMainUI.SizeMap_Normal, BattleMainUI.Task_SoloTemple)
    -- elseif DungeonInfo.DungeonType == "Party" then
    --     BattleMainUI:SetOverrideInfo(BattleMainUI.SizeMap_MutTemple, BattleMainUI.Task_MutTemple)
    -- end
    -- BattleMainUI.RetainerBox_0:SetVisibility(UE4.ESlateVisibility.Collapsed)
    BattleMainUI.SizeBox_Map:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:InitListenEvent()
	self.Super.InitListenEvent(self)
    self:AddDispatcher(EventID.OnSetTempleLimit, self, self.OnSetTempleLimit)
    self:AddDispatcher(EventID.OnTempleTimeChanged, self, self.OnTempleTimeChanged)
    -- self:AddDispatcher(EventID.OnTempleScoreCollectChanged, self, self.OnTempleScoreCollectChanged)
    self:AddDispatcher(EventID.OnTempleEnter, self, self.OnTempleEnter)
    self:AddDispatcher(EventID.OnTempleTipButtonShow, self, self.OnTempleTipButtonShow)

    self:AddDispatcher(EventID.OnUpdatePartyLeftUI, self, self.OnUpdatePartyLeftUI)
end

function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self:InitListenEvent()
    EventManager:FireEvent(EventID.OnTempleRightUI)
    self:InitInfo()
    self.ShouldListenInput = false
    if not self:IsListeningForInputAction("ActiveGuide") then
        self:ListenForInputAction("ActiveGuide", EInputEvent.IE_Pressed, true, {self, self.OnTipButtonClicked})
    end
    self.Btn_Click:UnBindEventOnClicked(self, self.OnTipButtonClicked)
    self.Btn_Click:BindEventOnClicked(self, self.OnTipButtonClicked)
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
    self:RefreshTipInfo()
end

function M:InitInfo()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    if not GameInstance then
        return
    end
    self.DungeonId = GameInstance:GetCurrentDungeonId()
    self.DungeonInfo = DataMgr.Dungeon[self.DungeonId]
    if not self.DungeonInfo then
        return
    end
    if self.DungeonInfo.DungeonType == "Temple" then
        self.TempleInfo = DataMgr.Temple[self.DungeonId]
        self:InitTemple()
    elseif self.DungeonInfo.DungeonType == "Party" then
        self.TempleInfo = DataMgr.Party[self.DungeonId]
        if self.TempleInfo.SucRule == "Parkour" then
            EventManager:FireEvent(EventID.OnPartyProgressStart)
        end
        self:InitParty()
    end
    self.Btn_Click:SetText(GText("UI_TEMPLE_TIPS_"..self.DungeonId))
    self.Text_TempleKeyDesc:SetText(GText("UI_TEMPLE_TIPS_"..self.DungeonId))
    self:InitTipsKey()
end

function M:InitTemple()
    -- 神庙左侧UI
    self.IsCountDown = false
    if self.TempleInfo.SucRule == "CountDown" then
        self.IsCountDown = true
        self.HB_Time:SetVisibility(ESlateVisibility.Collapsed)
    elseif self.TempleInfo.UIHideFailCond == 1 then
        self.HB_Time:SetVisibility(ESlateVisibility.Collapsed)
        self:InitTargetInfo()
    else
        self.HB_Time:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self:InitTargetInfo()
    end

    -- 设置连击效果显隐
    self.Combo = UIManager(self):GetUIObj("BattleCombo")
    if self.Combo ~= nil then 
        if self.TempleInfo.UIHideCombo == 1 then
            self.Combo:SetRenderOpacity(0)
        end
    end

    -- 隐藏任务栏
    
    local UIBattleMain = UIManager(self):GetUI("BattleMain")
    if UIBattleMain then   
        self:AddTimer(1, function()
            UIBattleMain.Btn_Task:SetVisibility(ESlateVisibility.Collapsed)
        end, false, nil, nil, false)
        -- UIBattleMain.Btn_Task:SetVisibility(ESlateVisibility.Collapsed)
        -- DebugPrint("dskjhfaksjdhfsadjkhfsakjfhsadkjhfd")
    end
end


function M:InitParty()
    -- 派对左侧UI
    -- 目前，派对只有一种模式 跑酷 parkour
    self.IsCountDown = false
    self.HB_Time:SetVisibility(ESlateVisibility.Collapsed)
    self:InitPartyTargetInfo()

    -- 设置连击效果显隐
    self.Combo = UIManager(self):GetUIObj("BattleCombo")
    if self.Combo ~= nil then 
        if self.TempleInfo.UIHideCombo == 1 then
            self.Combo:SetRenderOpacity(0)
        end
    end

    self.Text_Time:SetText(self:GetTimeStr(0))

    -- 隐藏任务栏

    local UIBattleMain = UIManager(self):GetUI("BattleMain")
    if UIBattleMain then   
        self:AddTimer(1, function()
            UIBattleMain.Btn_Task:SetVisibility(ESlateVisibility.Collapsed)
        end, false, nil, nil, false)
        -- UIBattleMain.Btn_Task:SetVisibility(ESlateVisibility.Collapsed)
        -- DebugPrint("dskjhfaksjdhfsadjkhfsakjfhsadkjhfd")
    end
end

function M:OnTempleTimeChanged(CurrentTime, ThresholdTime)
    -- 超过1s的时间变化用动画加减
    local Time = ThresholdTime - CurrentTime
    local ChangeValue = Time - self.CurTime
    if ChangeValue > 1 then
        self.Text_TimeNumChange:SetText("+" .. ChangeValue)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Time_Add)
    elseif ChangeValue < -1 then
        self.Text_TimeNumChange:SetText(ChangeValue)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Time_Minus)
    end

    if self.TempleInfo.SucRule == "Time" then
        self.Text_Time:SetText(self:GetTimeStr(CurrentTime))
    end
    if self.Limit == "TIME" then
        -- local Time = ThresholdTime - CurrentTime
        self.CurTime = Time
        if Time >= 0 then
            self.Text_Time:SetText(self:GetTimeStr(Time))
        end
    end
    -- self:CheckStar()
end

function M:OnSetTempleLimit(Limit, Value)
    self.Limit = Limit
    if Limit == "TIME" then
        self.TimeThreshold = Value
        self.CurTime = Value
        local Time = self:GetTimeStr(Value)
        self.Text_Time:SetText(Time)
    else
        self.Text_Time:SetText(Value)
    end

    if self.IsCountDown then
        self:InitTargetInfo()
    end
end

function M:InitTargetInfo()
    local TextRule2 = ""
    if self.TempleInfo.SucRule == "Time" then
        TextRule2 = "SECONDS"
    elseif self.TempleInfo.SucRule == "CountDown" then
        TextRule2 = "SECONDS"
    elseif self.TempleInfo.SucRule == "Score" then
        TextRule2 = "SCORE"
        --self.HB_ScoreNum:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        --self.Text_ScoreTitle:SetText(GText("UI_TEMPLE_TOTAL_" .. string.upper(self.TempleInfo.SucRule)) .. ": ")
    elseif self.TempleInfo.SucRule == "Collect" then
        TextRule2 = "COUNT"
        --self.HB_ScoreNum:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        --self.Text_ScoreTitle:SetText(GText("UI_TEMPLE_TOTAL_" .. string.upper(self.TempleInfo.SucRule)) .. ": ")
    end
    self.Text_TempleTitle:SetText(GText("DUNGEON_NAME_" .. self.DungeonId))
    self.Text_TempleDescTitle:SetText(GText("UI_TEMPLE_" .. self.DungeonId))

    if self.TempleInfo.UIHideDes == 1 then
        self.Text_TempleDesc:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.Text_TempleDesc:SetText(GText("UI_TEMPLE_DES_" .. self.DungeonId))
    end
end

function M:InitPartyTargetInfo()
    self.Text_TempleTitle:SetText(GText("DUNGEON_NAME_" .. self.DungeonId))
    self.Text_TempleDescTitle:SetText(GText("UI_PARTY_" .. self.DungeonId))
    self.Text_TempleDesc:SetText(GText("UI_PARTY_DES_" .. self.DungeonId))
end

function M:OnTempleEnter()
    EMUIAnimationSubsystem:EMStopAnimation(self, self.Point_Add)
    EMUIAnimationSubsystem:EMStopAnimation(self, self.Point_Minus)
    EMUIAnimationSubsystem:EMStopAnimation(self, self.Time_Add)
    EMUIAnimationSubsystem:EMStopAnimation(self, self.Time_Minus)
end

function M:OnTempleTipButtonShow(IsShow)
    if IsShow then
        self.ShouldListenInput = true
        self:RefreshTipInfo()
        self.Group_Btn:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self:PlayAnimation(self.Btn_In)
        AudioManager(self):PlayUISound(self, "event:/ui/common/guide_button_show", "TipBtnShow", nil)
    else
        self.ShouldListenInput = false
        -- self.Group_Btn:SetVisibility(ESlateVisibility.Collapsed)
        self:PlayAnimation(self.Btn_Out)
    end
end

function M:OnTipButtonClicked()
    if not self.ShouldListenInput then
        return
    end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
        GameMode:GetDungeonComponent():OnClickShowTips()
    end
end

function M:OnUpdatePartyLeftUI(Time)
    self.Text_Time:SetText(self:GetTimeStr(Time))
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName
    self:RefreshTipInfo()
end

function M:RefreshTipInfo()
    -- 根据当前输入模式显示提示内容。提示没激活的话略过
    if not self.ShouldListenInput then
        return
    end
    if CommonUtils.GetRuntimePlatform(self) == "Mobile" or self.CurInputDeviceType == ECommonInputType.Touch then
        -- 手机
        self.WS_Btn:SetActiveWidgetIndex(0)
    elseif self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard then
        -- 键鼠
        self.WS_Btn:SetActiveWidgetIndex(1)
        self.Com_KeyAdd:SetVisibility(ESlateVisibility.Collapsed)
        self.Com_KeyText:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    elseif self.CurInputDeviceType == ECommonInputType.Gamepad then
        -- 手柄
        self.WS_Btn:SetActiveWidgetIndex(1)
        self.Com_KeyText:SetVisibility(ESlateVisibility.Collapsed)
        self.Com_KeyAdd:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

function M:InitTipsKey()
    self.Com_KeyText:CreateCommonKey({
        KeyInfoList = {{
            Type = "Text",
            Text = CommonUtils:GetActionMappingKeyName("ActiveGuide")
        }}
    })
    local ActiveGuide1 = UIUtils.GetIconListByActionName("ActiveGuide")[1]
    local ActiveGuide2 = UIUtils.GetIconListByActionName("ActiveGuide")[2]
    self.Com_KeyAdd:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = ActiveGuide1,
            },
            {
                Type = "Img",
                ImgShortPath = ActiveGuide2,
            },
        },
        Type = "Add"
    })
end

return M
