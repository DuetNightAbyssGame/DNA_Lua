--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_SoloTreasure_CountDown_C
local WBP_SoloTreasure_CountDown_C = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function WBP_SoloTreasure_CountDown_C:InitUIInfo(Name, IsInUIMode, EventList, ...)
    self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
    self.Main:SetRenderOpacity(0)
    local UIBattleMain = UIManager(self):GetUI("BattleMain")
    if UIBattleMain then   
        UIBattleMain.Btn_Task:SetVisibility(ESlateVisibility.Collapsed)
        UIBattleMain.Pos_TaskBar:SetVisibility(ESlateVisibility.Collapsed)
        UIBattleMain.HBox:SetVisibility(ESlateVisibility.Collapsed)
        -- self:AddTimer(1, function()
        --     UIBattleMain.Btn_Task:SetVisibility(ESlateVisibility.Collapsed)
        --     UIBattleMain.Pos_TaskBar:SetVisibility(ESlateVisibility.Collapsed)
        --     UIBattleMain.HBox:SetVisibility(ESlateVisibility.Collapsed)
        -- end, false, nil, nil, false)
    end
    EventManager:FireEvent(EventID.OnSoloTreasureScoreAndBagUI) --加载积分与背包UI
    EventManager:AddEvent(EventID.ShowCountDownTips, self, self.ShowCountDownTips)
    self:PlayInAnimation()
    self:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
end

function WBP_SoloTreasure_CountDown_C:OnLoaded(...)
    self.DungeonId = GWorld.GameInstance:GetCurrentDungeonId()
    if not self.DungeonId then
        Utils.ScreenPrint("WBP_SoloTreasure_CountDown_C : DungeonId is nil")
        return
    end
    --初始化数据
    self:InitData()
    --初始化文本
    self:InitText()
    --初始化时间
    --self:InitCountDown()
    --初始化任务开始tip
    --self:InitTaskStartTip()
end

function WBP_SoloTreasure_CountDown_C:ShowCountDownTips()
    self:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
end

function WBP_SoloTreasure_CountDown_C:PlayInAnimation()
    local LoadingUI = GWorld.GameInstance:GetLoadingUI()
	if LoadingUI then
		EventManager:AddEvent(EventID.CloseLoading, self, function()
			EventManager:RemoveEvent(EventID.CloseLoading, self)
            self:InitTaskStartTip()
            --初始化时间
            self:InitCountDown()
		end)
	else
        self:InitTaskStartTip()
        --初始化时间
        self:InitCountDown()
	end
end

--初始化数据
function WBP_SoloTreasure_CountDown_C:InitData()
    self.SoloTreasureInfo = DataMgr.SoloTreasure[self.DungeonId]
    if not self.SoloTreasureInfo then
        Utils.ScreenPrint("WBP_SoloTreasure_CountDown_C: SoloTreasureInfo get fail")
        return
    end
    self.TimerHandleName = self.SoloTreasureInfo.TimerHandleName
    self.GameTotalTime = self.SoloTreasureInfo.GameTotalTime
    self.WarningTime = self.SoloTreasureInfo.WarningTime
end

--初始化文本
function WBP_SoloTreasure_CountDown_C:InitText()
    self.Text_Evacuation:SetText(GText("UI_Extraction_GameCountdown"))
end

--初始化任务开始tip
function WBP_SoloTreasure_CountDown_C:InitTaskStartTip()
    --弹窗提示结束后再显示倒计时
    local Parmas = {}
    Parmas.TipType = "GameStart"
    Parmas.Owner = self
    Parmas.Callback = function()
        self:PlayAnimation(self.In)
    end
    --弹窗提示(需要在动画完成后有回调把倒计时UI显示出来)
    if not self.TimeTip then
        self.TimeTip = UIManager(self):LoadUINew("SoloTreasureTimeTip", Parmas)
    else
        self.TimeTip:RealLoaded(Parmas)
    end
end

--初始化时间不足警告
function WBP_SoloTreasure_CountDown_C:InitWarningTimeTip()
    --弹窗提示结束后再显示倒计时
    local Parmas = {}
    Parmas.TipType = "TimeWarning"
    Parmas.Owner = self
    Parmas.Callback = function()
        self:PlayAnimation(self.In)
    end
    self:PlayAnimation(self.Out)
    --弹窗提示(需要在动画完成后有回调把倒计时UI显示出来)
    if not self.TimeTip then
        self.TimeTip = UIManager(self):LoadUINew("SoloTreasureTimeTip", Parmas)
    else
        self.TimeTip:RealLoaded(Parmas)
    end
end

--设置倒计时
function WBP_SoloTreasure_CountDown_C:InitCountDown()
    self.Switch_TimeType:SetActiveWidgetIndex(0)
    self.IsRed = false
    --self:AddTimer(1, self.UpdateCountDownUI, true, 0, "CountDown", true)
end

function WBP_SoloTreasure_CountDown_C:UpdateCountDownUI(DisplayRemainTime)
    if DisplayRemainTime <= 0 then
        DisplayRemainTime = 0
        self:PlayAnimation(self.Out)
        --副本结算接口
        self:GameOver()
    elseif DisplayRemainTime < 10 then
        if not self.IsRed then
            self.Switch_TimeType:SetActiveWidgetIndex(1)
            self.IsRed = true
        end
        if not self:IsPlayingAnimation(self.Warning) then
            self:PlayAnimation(self.Warning)
        end
    elseif DisplayRemainTime < self.WarningTime then
        if not self.IsRed then
            self.Switch_TimeType:SetActiveWidgetIndex(1)
            self:InitWarningTimeTip()
            self.IsRed = true
        end
    end
    if self.IsRed then
        self.Text_TimeWarning:SetText(self:GetTimeStr_Cpp(DisplayRemainTime))
    else
        self.Text_TimeNormal:SetText(self:GetTimeStr_Cpp(DisplayRemainTime))
    end
end

function WBP_SoloTreasure_CountDown_C:GameOver()
    if self.TimeTip then
        self.TimeTip:Close()
    end
end

return WBP_SoloTreasure_CountDown_C
