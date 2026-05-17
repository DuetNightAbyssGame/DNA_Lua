require "UnLua"
local UIUtils = require "Utils.UIUtils"
local View = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.Common.TimerMgr",
})

function View:InitView()
    self.Text_Linear:SetText(GText("UI_AutoChess_LinearMission"))
    self.Text_Random:SetText(GText("UI_AutoChess_RandomMission"))
    self.Text_Next:SetText(GText("UI_AutoChess_NewMissionRemain"))
    self:PlayAnimation(self.In)

    local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
    if GameInputModeSubsystem then
        GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    end
    self:RefreshOpInfoByInputDevice()

    self.Controller_Linear:CreateGamepadKey(UIConst.GamePadImgKey.LeftShoulder)
    self.Controller_Random:CreateGamepadKey(UIConst.GamePadImgKey.RightShoulder)

    local RedNode = ReddotManager.GetTreeNode(DataMgr.ReddotNode.AutoChessLinear.Name)
    if RedNode.Count > 0 then
        self.New_Linear:SetVisibility(ESlateVisibility.Visible)
    else
        self.New_Linear:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function View:UpdateNewReddotState(Count)
    if Count > 0 then
        self.New_Linear:SetVisibility(ESlateVisibility.Visible)
    else
        self.New_Linear:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function View:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if UIUtils.IsGamepadInput() then
        self:InitGamepadView()
    else
        self:InitKeyboardView()
    end
end

function View:InitGamepadView()
    self.Controller_Linear:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvinsible)
    self.Controller_Random:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvinsible)
end

function View:InitKeyboardView()
    self.Controller_Linear:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Controller_Random:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function View:BindEvents(OnBtnLinearClickedCallback, OnBtnRandomClickedCallback)
    self.Btn_Linear.OnClicked:Clear()
    self.Btn_Linear.OnClicked:Add(self, OnBtnLinearClickedCallback)
    self.Btn_Random.OnClicked:Clear()
    self.Btn_Random.OnClicked:Add(self, OnBtnRandomClickedCallback)
    ReddotManager.RemoveListener(DataMgr.ReddotNode.AutoChessLinear.Name, self)
    ReddotManager.AddListener(DataMgr.ReddotNode.AutoChessLinear.Name, self, self.UpdateNewReddotState)
end

function View:InitEventTimeInfos(EventTimeInfo, RequestUpdateCallback)
    self.RequestUpdateCallback = RequestUpdateCallback
    if EventTimeInfo.NextUnlockMissionId and EventTimeInfo.NextUnlockTime then
        self.Time:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvinsible)
        self.Text_Next:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvinsible)
        self.NextUnlockMissionId = EventTimeInfo.NextUnlockMissionId
        self.NextUnlockTime = EventTimeInfo.NextUnlockTime
        self.EventTimeCountdownTimer = self:AddTimer(1, self.UpdateUnlockRequiredTime, true)
        self:UpdateUnlockRequiredTime()
    else
        -- 没有下一个任务解锁了
        if self.EventTimeCountdownTImer then
            self:RemoveTimer(self.EventTimeCountdownTImer)
            self.EventTimeCountdownTImer = nil
        end
        self.Time:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Text_Next:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function View:UpdateUnlockRequiredTime()
    if self.NextUnlockMissionId and self.UpdateUnlockRequiredTime then
        self.Time:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvinsible)
        self.Text_Next:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvinsible)
        local CurrentTime = TimeUtils.NowTime()
        if CurrentTime >= self.NextUnlockTime then
            if self.RequestUpdateCallback then
                self.RequestUpdateCallback()
                if self.EventTimeCountdownTimer then
                    self:RemoveTimer(self.EventTimeCountdownTimer)
                    self.EventTimeCountdownTimer = nil
                end
            end
        else
            local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(self.NextUnlockTime, CurrentTime)
            self.Time:SetTimeText(GText(""), RemainTimeDict)
        end
    else
        self.Time:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Text_Next:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end



return View

