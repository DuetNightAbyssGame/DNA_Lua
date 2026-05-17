--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_SoloTreasure_HudScore_C
local WBP_SoloTreasure_HudScore_C = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function WBP_SoloTreasure_HudScore_C:Destruct()
    self:UnbindAllFromAnimationFinished(self.Score_Add)
    EventManager:RemoveEvent(EventID.OnUpdateGameScore, self)
    self:StopListeningForInputAction("OpenSoloTreasaureBagOnGamepad1", EInputEvent.IE_Pressed)
    self:StopListeningForInputAction("OpenSoloTreasaureBagOnGamepad1", EInputEvent.IE_Released)
    self:StopListeningForInputAction("OpenSoloTreasaureBagOnGamepad2", EInputEvent.IE_Pressed)
    EventManager:RemoveEvent(EventID.OnRepAbyssBattleCount, self)
end

function WBP_SoloTreasure_HudScore_C:InitWidgetUI(NoBagBtn)
    --初始化DungeonObject
    self:InitDungeoObject()
    --初始化数据和变量
    self:InitData()
    --初始化文本
    self:InitText()
    --初始化按钮
    self:InitBtn()
    --注册更新积分事件
    EventManager:AddEvent(EventID.OnUpdateGameScore, self, self.OnUpdateGameScore)
    if NoBagBtn == nil then
        self:ListenForInputAction("OpenSoloTreasaureBagOnGamepad1", EInputEvent.IE_Pressed, false, {self, self.PrePressOpenBagOnGamepad})
        self:ListenForInputAction("OpenSoloTreasaureBagOnGamepad1", EInputEvent.IE_Released, false, {self, self.ReleasedOpenBagOnGamepad})
        self:ListenForInputAction("OpenSoloTreasaureBagOnGamepad2", EInputEvent.IE_Pressed, false, {self, self.CheckOpenBagOnGamepad})
        self:ListenForInputAction("OpenBag", EInputEvent.IE_Pressed, false, {self, self.OpenBag})
        EventManager:AddEvent(EventID.OnChangeKeyBoardSet,self,self.InitBtn)
        self:CloseBattleMainOpenBagListen()
    else
        self.Btn_Bag:SetVisibility(ESlateVisibility.Collapsed)
    end
    --绑定动画事件
    self:BindToAnimationFinished(self.Score_Add, {self, self.ResetAddScore})
end

function WBP_SoloTreasure_HudScore_C:InitDungeoObject()
    self.ServerEntity = GWorld:GetServerEntity()
	if not self.ServerEntity then
		return
	end

	self.DungeonObject = self.ServerEntity:GetDungeonObject()
	if not self.DungeonObject then
		return
	end
end

function WBP_SoloTreasure_HudScore_C:CloseBattleMainOpenBagListen()
    local BattleMain = UIManager(self):GetUIObj("BattleMain")
    if BattleMain then
        BattleMain:CloseOpenBagListening()
        BattleMain:CloseOpenGuideMainListening()
    end
end

function WBP_SoloTreasure_HudScore_C:InitData()
    --当前游戏战斗积分
    self.CurGameScore = self.DungeonObject and self.DungeonObject.KillMonsterScore or 0
    --预达到游戏战斗积分
    self.TargetScore = self.DungeonObject and self.DungeonObject.KillMonsterScore or 0
    --需要更新的游戏战斗积分
    self.AddGameScore = 0
    --积分更新时间
    self.UpdateGameScoreTotalTime = 0.5
    --积分滚动更新间隔时间
    self.IntervalTime = 0.01
end

function WBP_SoloTreasure_HudScore_C:InitText()
    self.Text_AllNum:SetText(self.CurGameScore)
end

function WBP_SoloTreasure_HudScore_C:InitBtn()
    local ClassPath = UE4.LoadClass('/Game/UI/WBP/Battle/Widget/WBP_Main_Btnlist_Content.WBP_Main_Btnlist_Content_C')
    local Content = NewObject(ClassPath)
    Content.BtnId = 2
    self.Btn_Bag.CurContent = Content
    self.Btn_Bag:LoadImage()
    self.Btn_Bag:RebindClickEvent(self, self.OpenBag)
end

function WBP_SoloTreasure_HudScore_C:PrePressOpenBagOnGamepad()
    self.IsPressed = true
    self.Btn_Bag:ShowSystemEntranceOnGamePadInput(true)
end

function WBP_SoloTreasure_HudScore_C:ReleasedOpenBagOnGamepad()
    self.IsPressed = false
    self.Btn_Bag:ShowSystemEntranceOnGamePadInput()
end

--给外部使用 隐藏UI
function WBP_SoloTreasure_HudScore_C:PlayOutAnimation()
    self:PlayAnimation(self.Out)
end

--给外部使用 显示UI
function WBP_SoloTreasure_HudScore_C:PlayInAnimation()
    self:PlayAnimation(self.In)
end

function WBP_SoloTreasure_HudScore_C:CheckOpenBagOnGamepad()
    if self.IsPressed then
        self:OpenBag()
    end
end

function WBP_SoloTreasure_HudScore_C:OpenBag()
    --是否需要隐藏UI和显示UI
    --已提供外部接口PlayOutAnimation 和 PlayInAnimation
    UIManager(self):LoadUINew("SoloTreasureBag", function(LoadedWidget)
        DebugPrint("lgc@WBP_SoloTreasure_HudScore_C SoloTreasureBag AsyncLoaded")
    end, "Async")
end

--设置积分数量（是否需要与服务器同步积分）
function WBP_SoloTreasure_HudScore_C:ResetAddScore()
    self.AddGameScore = 0
end

--更新游戏积分事件回调
function WBP_SoloTreasure_HudScore_C:OnUpdateGameScore(Score, TargetScore)
    self.AddGameScore = self.AddGameScore + Score
    local AddGameScoreText = ""
    if self.AddGameScore > 0 then
        AddGameScoreText = string.format("+%d", self.AddGameScore)
    else
        AddGameScoreText = string.format("%d", self.AddGameScore)
    end
    self.Text_AddNum:SetText(AddGameScoreText)
    self.TargetScore = TargetScore
    if (not self:IsPlayingAnimation(self.Score_Add)) and self.AddGameScore > 0 then
        self:PlayAnimation(self.Score_Add)
    end
    self:SetGameScoreWithScrollAnimation()
end

--数字滚动逻辑 0.5s内完成
function WBP_SoloTreasure_HudScore_C:SetGameScoreWithScrollAnimation()
    if self:IsExistTimer("UpdateGameScore") then
        return
    end
    local IsDone = false
    local AddScorePerTime = self.AddGameScore / (self.UpdateGameScoreTotalTime / self.IntervalTime)
    self:AddTimer(self.IntervalTime, function()
        if IsDone then
            self.AddGameScore = 0
            self:RemoveTimer("UpdateGameScore")
            return
        end
        self.CurGameScore = self.CurGameScore + AddScorePerTime
        if AddScorePerTime < 0 then
            self.CurGameScore = math.max(self.CurGameScore, self.TargetScore)
        else
            self.CurGameScore = math.min(self.CurGameScore, self.TargetScore)
        end
        if self.CurGameScore == self.TargetScore then
            IsDone = true
        end
        self.Text_AllNum:SetText(Utils.FormatNumber(self.CurGameScore, false))
    end, true, 1, "UpdateGameScore", true)
end

return WBP_SoloTreasure_HudScore_C
