--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_Settlement_P_C
---@field ActivityId number @活动Id
---@field LevelScore number @关卡分数
---@field IsNewRecord bool @是否是新纪录
---@field IsWin bool @是否胜利
---@field Text_Title string @(可选)标题文本，不填的话就是根据胜利还是失败显示关卡完成或者关卡失败
---@field Text_GetReward string @(可选)获得奖励文本
---@field ScoreInfo table @(可选)填在右边的得分情况
---@field RewardIds table @(可选)得分情况。value为Reward表对应的Id
---@field Btn_Exit_Text string @(可选)退出按钮文本
---@field Btn_Continue_Text string @(可选)继续按钮文本
---@field TitleColor UE4.FSlateColor @(可选)标题颜色
---@field ScoreLineColor UE4.FSlateColor @(可选)得分项颜色
---@field ContinueCallback function @(可选)继续按钮回调
---@field TimeRemain number @(可选)剩余时间
---@field RewardsInfo table @(可选)奖励信息(服务器发下来的奖励，直接传进来)
---@field CostParams table @(可选)消耗参数，用于显示门票消耗信息
local M = Class({"BluePrints.UI.BP_UIState_C"})
local Model = require  "BluePrints.UI.AutoChess.AutoChessDataModel"
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

function M:OnInAnimationFinished()
    DebugPrint("JLY Test OnInAnimationFinished")
    self:UnbindAllFromAnimationFinished(self.In)
    self:UnbindAllFromAnimationFinished(self.Fail_In)
    if self.Text_Title then
        self.Text_Title:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Text_Title:SetRenderOpacity(1)
    end
    if self.Text_Title_New then
        self.Text_Title_New:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Text_Title_New:SetRenderOpacity(1)
    end
end

function M:InitParams(Params)
    self.Params = Params

    -- 自走棋编辑阶段退出 不进入结算界面
    self:InitDungeonInfo()
    self.Btn_Exit.Button_Area.OnClicked:Add(self, self.OnExitClicked)
    if self.Params and self.Params.MissionType == 2 and self.Params.IsWin then
        self.Btn_Continue:ForbidBtn(true)
        self.Btn_Continue:BindForbidStateExecuteEvent(self,function()
            UIManager(self):ShowUITip("CommonToastMain", GText("UI_AutoChess_CantStartAgain"))
        end)
    else
        self.Btn_Continue.Button_Area.OnClicked:Add(self, self.OnContinueClicked)
    end
    if self.Btn_Data then
        self.Btn_Data.Button_Area.OnClicked:Add(self, self.InitBattleInfo)
    end

    self:InitUI()
    self:StopAllAnimations()
    self:AddTimer(0.1, function()
        self:OnInAnimationFinished()
    end)
    if Params.IsWin then
        self:PlayAnimation(self.In)
        if self.EventSettlementPage and self.EventSettlementPage.WinSound then
            AudioManager(self):PlayUISound(self, self.EventSettlementPage.WinSound, "ActivitySettlement", nil)
        end
    else
        self:PlayAnimation(self.Fail_In)
        if self.EventSettlementPage and self.EventSettlementPage.FailSound then
            AudioManager(self):PlayUISound(self, self.EventSettlementPage.FailSound, "ActivitySettlement", nil)
        end
    end
    if Params.IsNewRecord then
        if self.EventSettlementPage and self.EventSettlementPage.NewRecordSound then
            AudioManager(self):PlayUISound(self, self.EventSettlementPage.NewRecordSound, "ActivitySettlement", nil)
        end
    end
    self:AddTimer(0.1, function()
        self:SetFocus()
    end)
    self.RemainTime = 100
    self:AddTimer(1, self.CountDown, true, -1, "ActivitySettlementCountDown")
    -- 设置手柄控制
    self:SetupGamepadControls()
    
    self:UpdateBottomKeyInfo(false)
end

--目前只有自走棋在用
function M:InitDungeonInfo()
    if not self.Params.DungeonType then
        return
    end
    if self.Params.DungeonType == "AutoChess" then
        GWorld.GameInstance.AutoChessMissionId = self.Params.MissionId
        GWorld.GameInstance.IsWin = self.Params.IsWin
    end
    self.ExitDungeonData = GWorld.GameInstance:GetExitDungeonData()
    if self.ExitDungeonData then
        self.ExitDungeonData.Type = self.Params.DungeonType
    else
        self.ExitDungeonData = { Type = self.Params.DungeonType }
    end
    GWorld.GameInstance:SetExitDungeonData(self.ExitDungeonData)
end

function M:CountDown()
    local Text = string.format(GText("UI_Text_ExitTime"), self.RemainTime)
    self.Text_ExitTime:SetText(Text)
    if self.RemainTime <= 0 then
        self:OnExitClicked()
        self:RemoveTimer("ActivitySettlementCountDown")
    end
    self.RemainTime = self.RemainTime - 1
end

function M:InitUI()
    local EventSettlementPage = DataMgr["EventSettlementPage"][1]
    for Id, ConfigData in pairs(DataMgr.EventSettlementPage) do
        if ConfigData.EventId == self.Params.ActivityId and ConfigData.DungeonId == self.Params.DungeonId then
            EventSettlementPage = ConfigData
        end
    end
    self.EventSettlementPage = EventSettlementPage
    if not EventSettlementPage then
        return
    end
    -- 设置总积分
    if self.Params.Text_TotalScore then
        if self.Text_TotalScore then
            self.Text_TotalScore:SetText(GText(self.Params.Text_TotalScore))
        end
    else
        if self.Text_TotalScore then
            self.Text_TotalScore:SetText(GText("UI_SettlementPage_TotalScore"))
        end
    end
    
    -- 设置分数
    if self.Params.LevelScore then
        self.Text_NewRecord:SetText(GText("UI_SettlementPage_NewRecord"))

        if self.Params.IsNewRecord then
            self.Text_NewRecord:SetVisibility(UE4.ESlateVisibility.Visible)
        else
            self.Text_NewRecord:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        
        if self.Params.TimeRemain == nil then
            -- 没有时间参数，直接显示最终分数
            self.Num_Score:SetText(self.Params.LevelScore)
        end
    end

    -- 设置消耗信息（门票等）
    if self.Cost and self.Params.CostParams then
        -- 设置Owner为当前Widget
        if self.Panel_Cost then
            self.Panel_Cost:SetVisibility(UE4.ESlateVisibility.Visible)
        else
            self.Panel_Cost:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        self.Params.CostParams.Owner = self
        self.Params.CostParams.ItemMenuAnchorChangedCallback = self.ItemMenuAnchorChanged
        self.Params.CostParams.KeyIconName = "RS"
        self.Cost:InitContent(self.Params.CostParams)
    end

    -- 设置剩余时间
    if self.Params.TimeRemain then
        self.Num_Time:SetText(string.format("%d:%02d", math.floor(self.Params.TimeRemain / 60), self.Params.TimeRemain % 60))
        self.Num_Time:SetVisibility(UE4.ESlateVisibility.Visible)
        self.VB_Time:SetVisibility(UE4.ESlateVisibility.Visible)
    else
        if self.Num_Time then
            self.Num_Time:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.VB_Time:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end

    if self.Text_TotalTime then
        self.Text_TotalTime:SetText(GText("RaidDungeon_Time_Remain"))
    end

    if self.Text_Return then
        self.Text_Return:SetText(GText("UI_Refund"))
        if self.Params and self.Params.IsShowReturnText and self.Panel_Return then
            self.Panel_Return:SetVisibility(UE4.ESlateVisibility.Visible)
        else
            self.Panel_Return:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end

    -- 设置标题文本
    if self.Text_Title then
        if self.Params.IsWin then
            self.Text_Title:SetText(GText("EventDungeonPass_Title1"))
            if self.Text_Title_1 then
                self.Text_Title_1:SetText(GText("EventDungeonPass_Title1"))
            end
        else
            self.Text_Title:SetText(GText("EventDungeonPass_Title2"))
            if self.Text_Title_1 then
                self.Text_Title_1:SetText(GText("EventDungeonPass_Title2"))
            end
        end
    end

    if self.Text_Title_New then
        if self.Params.IsWin then
            self.Text_Title_New:SetText(GText("EventDungeonPass_Title1"))
        else
            self.Text_Title_New:SetText(GText("EventDungeonPass_Title2"))
        end
    end

    -- 设置颜色
    if self.Params.TitleColor and self.Text_Title then
        self.Text_Title:SetColorAndOpacity(self.Params.TitleColor)
    end

    if self.Params.ScoreLineColor and self.Line then
        self.Line:SetBrushTintColor(self.Params.ScoreLineColor)
    end

    -- 先隐藏所有分数项控件
    self:InitScoreInfo(self.Params.ScoreInfo, self.List_ScoreItem)

    -- 按钮文本
    if self.Params.Btn_Exit_Text and self.Btn_Exit.Text_Button then
        self.Btn_Exit:SetText(GText(self.Params.Btn_Exit_Text))
    else
        self.Btn_Exit:SetText(GText("UI_CTL_Quit"))
    end

    if self.Params.Btn_Continue_Text and self.Btn_Continue.Text_Button then
        self.Btn_Continue:SetText(GText(self.Params.Btn_Continue_Text))
    else
        self.Btn_Continue:SetText(GText("UI_TEMPLE_RESTART"))
    end

    --战斗数据统计
    if self.Params.BattleInfoTextName then
        if self.Btn_Data and self.Btn_Data.Text_Function then
            self.Btn_Data.Text_Function:SetText(GText(self.Params.BattleInfoTextName))
        end
    end

    if self.Params.IsWin then
        -- 设置显隐
        if EventSettlementPage.IsShowTitle then
            self.Panel_Title:SetVisibility(UE4.ESlateVisibility.Visible)
        else
            self.Panel_Title:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end

        if EventSettlementPage.IsShowScore then
            self.VB_Score:SetVisibility(UE4.ESlateVisibility.Visible)
        else
            self.VB_Score:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    
        if EventSettlementPage.IsShowCondition then
            self.List_ScoreItem:SetVisibility(UE4.ESlateVisibility.Visible)
        else
            self.List_ScoreItem:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    
        if EventSettlementPage.IsShowReward then
            -- 获取奖励组件
            local RewardWidget = self.Settlement_RewardItem
            RewardWidget:SetVisibility(UE4.ESlateVisibility.Visible)

            if RewardWidget then
                -- 奖励
                if self.Params.RewardsInfo then
                    -- 处理服务器发来的RewardsInfo格式
                    local RewardBox = require "BluePrints.Client.CustomTypes.SimpleRewardBox"
                    local RewardType = DataMgr.RewardType
                    local hasReward = false
                    for ItemType, RewardTypeValue in pairs(RewardType) do
                        if not RewardTypeValue.DungeonRewardType then
                            goto continue
                        end
                        local Rewards = self.Params.RewardsInfo[ItemType.."s"]
                        if Rewards then
                            hasReward = true
                            local RewardInfo = DataMgr[ItemType]
                            for ItemId, ItemCount in pairs(Rewards) do
                                self.CanFocusList = true
                                local count = 0
                                if type(ItemCount) == "table" then
                                    count = RewardBox:GetCount(ItemCount)
                                elseif type(ItemCount) == "number" then
                                    count = ItemCount
                                end
                                local Rarity = ItemUtils.GetItemRarity(ItemId, ItemType)
                                local Content = NewObject(UIUtils.GetCommonItemContentClass())
                                Content.Count = count
                                Content.Id = ItemId
                                Content.Icon = DataMgr[ItemType][ItemId].Icon
                                Content.ItemType = ItemType
                                Content.Rarity = Rarity
                                Content.IsShowDetails = true
                                --这里目前只有自走棋要求隐藏跳转，其他正常显示（之前是因为道具框有bug，导致一致显示跳转）
                                if self.Params.DungeonType == "AutoChess" then
                                    Content.bNotShowAccess = true
                                end
                                Content.OnMenuOpenChangedEvents = {Obj = self, Callback = self.ItemMenuAnchorChanged}
                                RewardWidget.List_Reward:AddItem(Content)
                            end
                        end
                        ::continue::
                    end

                    if hasReward then
                        RewardWidget:SetVisibility(UE4.ESlateVisibility.Visible)
                    else
                        if self.Settlement_RewardItem then
                            self.Settlement_RewardItem:SetVisibility(UE4.ESlateVisibility.Collapsed)
                        end
                        RewardWidget:SetVisibility(UE4.ESlateVisibility.Collapsed)
                        if self.Static_TitleLine and self.Static_TitleLine_1 then
                            self.Static_TitleLine:SetVisibility(ESlateVisibility.Collapsed)
                            self.Static_TitleLine_1:SetVisibility(ESlateVisibility.Collapsed)
                        end
                    end

                    -- 设置获得奖励文本
                    if RewardWidget.Text_GetReward then
                        if self.Params.Text_GetReward and RewardWidget.Text_GetReward then
                            RewardWidget.Text_GetReward:SetText(GText(self.Params.Text_GetReward))
                        else
                            RewardWidget.Text_GetReward:SetText(GText("UI_COMMON_REWARD"))
                        end
                    end
                else
                    RewardWidget:SetVisibility(UE4.ESlateVisibility.Collapsed)
                end
            end
        else
            self.Settlement_RewardItem:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    else
        local RewardWidget = self.Settlement_RewardItem
        RewardWidget:SetVisibility(UE4.ESlateVisibility.Collapsed)

        --自走棋失败
        if self.ScroePanel then
            self.ScorePanel:SetVisibility(ESlateVisibility.Collapsed)
        end
        if self.Panel_FailTip then
            self.Panel_FailTip:SetVisibility(ESlateVisibility.Visible)
            local FailTip = {"UI_AutoChess_LoseTips1", "UI_AutoChess_LoseTips2", "UI_AutoChess_LoseTips3"}
            for i = 1, 3 do
                local Content = NewObject(UIUtils.GetCommonItemContentClass())
                Content.Text = GText(FailTip[i])
                self.List_FailTips:AddItem(Content)
            end
        end
    end

    --自走棋积分
    if self.Params.MissionType then
        if self.ScorePanel then
            if self.Params.MissionType == 1 then
                self.ScorePanel:SetVisibility(ESlateVisibility.Collapsed)
            elseif self.Params.MissionType == 2 then
                if self.Params.IsWin then
                    self.ScorePanel:SetVisibility(ESlateVisibility.Visible)
                end
                self:InitRankIcon()
            end
        end   
    end
end

function M:CheckIsTopRank(CurRank)
    --获取这个等级的信息
    local CurRankInfo = DataMgr.AutoChessPoint[CurRank]
    if not CurRankInfo then
        return
    end
end

--自走棋rank
function M:InitRankIcon()
    --获取进度条增长总时间
    self.TotalProgressBarAnimTime = self.TotalProgressBarAnimTime or 1
    --获取应该增加的分数
    self.AddScore = self.Params.Point or 0
    --对应文本赋值
    local AddScoreText = "+"..tostring(self.AddScore) 
    self.Text_Score:SetText(AddScoreText)
    local PreRankInfo = DataMgr.AutoChessPoint[self.Params.PreRankLevel]
    local RankInfo = DataMgr.AutoChessPoint[self.Params.RankLevel]
    if not PreRankInfo then
        DebugPrint("AutoChessSettlement: PreRankInfo is nil")
        return
    end
    if not RankInfo then
        DebugPrint("AutoChessSettlement: RankInfo is nil")
        return
    end
    --加载增长前积分
    local ScoreProgress = ""
    if RankInfo.RankMaxPoint then
        ScoreProgress = string.format("%d/%d", self.Params.RankScore, RankInfo.RankMaxPoint)
    else
        ScoreProgress = string.format("%d/%d", 0, 0)
    end
    self.Text_Exp:SetText(ScoreProgress)
    --加载出icon和分数条
    local CurPercent = self.Params.PreRankScore/PreRankInfo.RankMaxPoint
    self.Exp_Bar:SetRenderScale(FVector2D(CurPercent, 1.0))
    --设置当前等级的icon和文本
    self:SetCurLevelIconAndText(self.Params.PreRankLevel)

    --计算两次等级的差值
    self.LevelDiff = self.Params.RankLevel - self.Params.PreRankLevel

    self.IsPlayRankUpAnimation = self.LevelDiff > 0

    --计算计时器的间隔时间
    self:SetIntervalTimeAboutProgressAnim()

    --计算当前等级增加分数以及进度条的位置
    --self:InitScoreProgressBar()
end

--动画事件插入，用来启动进度条动画
function M:InitScoreProgressBar()
    if not (self.Params.IsWin and self.Params.MissionType == 2) then
        return
    end
    local PreRankInfo = DataMgr.AutoChessPoint[self.Params.PreRankLevel]
    local CurPercent = self.Params.PreRankScore/PreRankInfo.RankMaxPoint
    --计算当前等级增加分数以及进度条的位置
    local CurTurnNeedAddScore = math.min(PreRankInfo.RankMaxPoint - self.Params.PreRankScore, self.AddScore)
    self.AddScore = math.max(self.AddScore - CurTurnNeedAddScore, 0)
    local TargetPercent = (self.Params.PreRankScore + CurTurnNeedAddScore)/PreRankInfo.RankMaxPoint
    AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_exp_add", "BarSound", nil)
    self:InitRankUpAnimTimer(CurPercent, TargetPercent)
end

function M:SetIntervalTimeAboutProgressAnim()
    if (not self.Params.IsWin) or self.Params.MissionType ~= 2 then
        return
    end
    --拿到一共要升级多少percent
    local AddScoreTmp = self.Params.Point
    local PreRankInfo = DataMgr.AutoChessPoint[self.Params.PreRankLevel]
    local CurPercent = self.Params.PreRankScore/PreRankInfo.RankMaxPoint
    local CurTurnNeedAddScore = math.min(PreRankInfo.RankMaxPoint - self.Params.PreRankScore, AddScoreTmp)
    local TargetPercent = (self.Params.PreRankScore + CurTurnNeedAddScore)/PreRankInfo.RankMaxPoint
    local TotalPercent = TargetPercent - CurPercent
    AddScoreTmp = AddScoreTmp - CurTurnNeedAddScore
    if self.LevelDiff > 0 then
        for i = 1, self.LevelDiff do
            local CurLevelTmp = self.Params.PreRankLevel + i
            local RankInfoTmp = DataMgr.AutoChessPoint[CurLevelTmp]
            if RankInfoTmp then
                CurTurnNeedAddScore = math.min(RankInfoTmp.RankMaxPoint or 0, AddScoreTmp)
                AddScoreTmp = RankInfoTmp.RankMaxPoint and math.max(AddScoreTmp - CurTurnNeedAddScore, 0) or 0
                if AddScoreTmp > 0 then
                    TotalPercent = TotalPercent + 1
                else
                    if RankInfoTmp.RankMaxPoint then
                        TotalPercent = TotalPercent + CurTurnNeedAddScore/RankInfoTmp.RankMaxPoint
                    end
                end
            end
        end
    end
    --计算间隔增加量
    self.IntervalNum = TotalPercent / (self.TotalProgressBarAnimTime / 0.01)
end

--升级动效
function M:UpdatePlayerRankUp(CurRank)
    local CurRankInfo = DataMgr.AutoChessPoint[CurRank]
    if not CurRankInfo then
        return
    end
    if self.LevelDiff > 0 then
        self.AddScore = CurRankInfo.RankMaxPoint and math.max(self.AddScore - CurRankInfo.RankMaxPoint, 0) or 0
        --进度条直接从0升到1
        self:InitRankUpAnimTimer(0.0, 1.0)
    elseif self.LevelDiff == 0 then
        --等级差值为0时，说明是最后一次升级，计算进度条的位置
        local FinalPercent = CurRankInfo.RankMaxPoint and self.AddScore/CurRankInfo.RankMaxPoint or 0
        self.AddScore = math.min(self.AddScore, 0)
        --进度条
        self:InitRankUpAnimTimer(0.0, FinalPercent)
    else
        --结束所有定时器
        self:RemoveTimer("AutoChessRankProgressBarAnim")
        --加载增长后积分
        if self.IsPlayRankUpAnimation then
            self:PlayAnimation(self.LevelUp)
            local BarPercent = CurRankInfo.RankMaxPoint and FVector2D(self.Params.RankScore / CurRankInfo.RankMaxPoint, 1.0) or FVector2D(0, 1.0)
            self.Exp_Bar:SetRenderScale(BarPercent)
        end
        AudioManager(self):SetEventSoundParam(self, "BarSound", {ToEnd = 1})
        AudioManager(self):StopSound(self, "BarSound")
    end
end

--启动一个等级提升动效的定时器
function M:InitRankUpAnimTimer(BeginPercent, TargetPercent)
    self:AddTimer(0.01, function()
        --播放进度条动画
        BeginPercent = math.min(BeginPercent + self.IntervalNum, TargetPercent)
        self.Exp_Bar:SetRenderScale(FVector2D(BeginPercent, 1.0))
        if BeginPercent == TargetPercent then
            --删除这个定时器
            self:RemoveTimer("AutoChessRankProgressBarAnim")
            self.LevelDiff = math.max(self.LevelDiff - 1, 0)
            local CurRank = self.Params.RankLevel - self.LevelDiff
            self.LevelDiff = -1
            self:UpdatePlayerRankUp(CurRank)
            -- if self.AddScore > 0 then
            --     --等级差值计算

            -- end
        end
    end, true, -1, "AutoChessRankProgressBarAnim")
end

--不传参数就是动画的监听事件
function M:SetCurLevelIconAndText(CurRank)
    CurRank = CurRank or self.Params.RankLevel
    --获取这个等级的信息
    local CurRankInfo = DataMgr.AutoChessPoint[CurRank]
    if not CurRankInfo then
        DebugPrint("AutoChessSettlement: CurRankInfo is nil")
        return
    end
    local IconObj = LoadObject(CurRankInfo.RankIcon)
    local RankName = GText(CurRankInfo.RankName)
    if not (IconObj and RankName) then
        DebugPrint("AutoChessSettlement: IconObj or RankName is nil")
        return
    end
    self.Text_Rank:SetText(RankName)
    local DynamicMaterial = self.Icon_Rank:GetDynamicMaterial()
    if DynamicMaterial then
        DynamicMaterial:SetTextureParameterValue("MainTex", IconObj)
    end
end

--自走棋战斗数据统计
function M:InitBattleInfo()
    --创建战斗数据统计主页面Widget
    self.BattleInfoUI = UIManager(self):LoadUINew("AutoChessSettlementStatistics")
    self.BattleInfoUI:SwitchPanelUI(self.CurInputDeviceType)
    self.BattleInfoUI:SetParent(self)
    self.BattleInfoUI:InitUI()
    AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_normal_btn_click", nil, nil)
end

function M:Play_In()
    self:PlayScoreAndTimeAnimation()
end


-- 播放分数和时间动画效果
function M:PlayScoreAndTimeAnimation()
    local animationDuration = 1.0  -- 动画总时长1秒
    local startTime = UE4.UGameplayStatics.GetTimeSeconds(self)
    local targetScore = self.Params.LevelScore
    local startTimeRemain = self.Params.TimeRemain
    
    -- 初始化显示为0分和初始时间
    self.Num_Score:SetText("0")
    self.Num_Time:SetText(string.format("%d:%02d", math.floor(startTimeRemain / 60), startTimeRemain % 60))
    
    -- 清除可能存在的旧定时器
    if self.ScoreAnimationTimer then
        self:RemoveTimer(self.ScoreAnimationTimer)
        self.ScoreAnimationTimer = nil
    end
    
    -- 启动定时器更新动画
    self.ScoreAnimationTimer = self:AddTimer(0.016, function()  -- 约60fps更新
        local currentTime = UE4.UGameplayStatics.GetTimeSeconds(self)
        local elapsedTime = currentTime - startTime
        local progress = math.min(elapsedTime / animationDuration, 1.0)  -- 进度0-1
        
        -- 计算当前分数（线性插值从0到目标分数）
        local currentScore = math.floor(targetScore * progress)
        self.Num_Score:SetText(tostring(currentScore))
        
        -- 计算当前时间（线性插值从初始时间到0）
        local currentTimeRemain = math.floor(startTimeRemain * (1.0 - progress))
        self.Num_Time:SetText(string.format("%d:%02d", math.floor(currentTimeRemain / 60), currentTimeRemain % 60))
        
        -- 动画完成
        if progress >= 1.0 then
            self.Num_Score:SetText(tostring(targetScore))
            self.Num_Time:SetText("0:00")
            self:RemoveTimer(self.ScoreAnimationTimer)
            self.ScoreAnimationTimer = nil
        end
    end, true, -1, "ScoreAndTimeAnimation")
end

function M:ItemMenuAnchorChanged(IsOpen)
    if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
        if self.Key_GamePad then
            self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        return
    end
    self.IsOpenItemMenu = IsOpen
    if IsOpen then
        local BottomKeyInfo = {}
        if self.Key_GamePad then
            self.Key_GamePad:UpdateKeyInfo(BottomKeyInfo)
            self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    else
        if self.IsFocusRewardList then
            local RewardWidget = self.Settlement_RewardItem
            if RewardWidget and RewardWidget.List_Reward then
                RewardWidget.List_Reward:SetFocus()
            end
        elseif self.IsFocusCost then
            if self.Cost then
                self.Cost:SetFocus()
            end
        end
        self:UpdateBottomKeyInfo(true)
    end
end

function M:InitScoreInfo(ScoreInfo, ListWidget)
    if ScoreInfo then
        local IsMobile = ModController:IsMobile()
        ListWidget:ClearListItems()
        for i, item in ipairs(ScoreInfo) do
            local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
            ItemContent.Text = GText(item.text)
            ItemContent.IsFinish = item.isFinish
            ItemContent.IsMobile = IsMobile
            ItemContent.ParentWidget = self
            ItemContent.Idx = i
            ListWidget:AddItem(ItemContent)
        end
    end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local isHandle = false
    if self.IsFocusList then
        if (InKeyName == "Gamepad_FaceButton_Right") then
            if self.IsOpenItemMenu then
                return UE4.UWidgetBlueprintLibrary.UnHandled()
            end
            self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
            self.IsFocusList = false
            self.IsFocusRewardList = false
            self.IsFocusCost = false
            
            -- 获取奖励组件
            local RewardWidget = self.Settlement_RewardItem
            if RewardWidget and RewardWidget.Key_GamePad then
                RewardWidget.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Visible)
            end
            
            self.Btn_Exit:SetGamePadVisibility(UE4.ESlateVisibility.Visible)
            self.Btn_Continue:SetGamePadVisibility(UE4.ESlateVisibility.Visible)
            self:UpdateBottomKeyInfo(false)
            isHandle = true
        end
    else
        if (InKeyName == "Gamepad_FaceButton_Right") then
            self:OnExitClicked()
            isHandle = true
        elseif (InKeyName == "Gamepad_FaceButton_Top") then
            if self.Params and self.Params.DungeonType == "AutoChess" then
                if self.Params.MissionType == 1 then
                    self:OnContinueClicked()
                elseif self.Params.MissionType == 2 then
                    --弹个toast
                    if self.Params.IsWin then
                        UIManager(self):ShowUITip("CommonToastMain", GText("UI_AutoChess_CantStartAgain"))
                    else
                        self:OnContinueClicked()
                    end
                end
            else
                self:OnContinueClicked()
            end
            isHandle = true
        elseif (InKeyName == "Gamepad_LeftThumbstick") then
            if not self.CanFocusList then
                return UE4.UWidgetBlueprintLibrary.UnHandled()
            end
            -- 获取奖励组件
            local RewardWidget = self.Settlement_RewardItem
            if RewardWidget and RewardWidget.List_Reward then
                RewardWidget.List_Reward:SetFocus()
            end
            
            self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
            self.IsFocusList = true
            self.IsFocusRewardList = true
            
            if RewardWidget and RewardWidget.Key_GamePad then
                RewardWidget.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
            
            self.Btn_Exit:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
            self.Btn_Continue:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
            self:UpdateBottomKeyInfo(true)
            isHandle = true
        elseif (InKeyName == "Gamepad_Special_Right") then --战斗数据
            self:InitBattleInfo()
            isHandle = true
        end
    end

    if isHandle then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnExitClicked()
    self:BlockAllUIInput(true)
    if self.Params and self.Params.ExitCallback then
        local OutAnim = self.Params.IsWin and self.Out or self.Fail_Out
        if self.Params and self.Params.ExitCallback then
            self.Params.ExitCallback(self)
        end
        self:PlayAnimation(OutAnim)
    else
        local Avatar = GWorld:GetAvatar()
        Avatar:ExitDungeonSettlement()
		EventManager:AddEvent(EventID.OnExitDungeon, self, self.DefaultExit)
    end
end

function M:DefaultExit()
    EventManager:RemoveEvent(EventID.OnExitDungeon, self)
    if self.Params.IsWin then
        self:PlayAnimation(self.Out)
    else
        self:PlayAnimation(self.Fail_Out)
    end
end

function M:OnContinueClicked()
    local CallbackResult = nil
    -- 检查活动是否在时间范围内
    local IsOpen = ActivityUtils.CheckEventIsOpen(self.Params.ActivityId, nil, false)
    -- 如果不在时间范围内，就不走再次进入的逻辑，弹toast提示活动已经结束
    if not IsOpen then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_GameEvent_EventEnd"))
        return
    end
    if self.Params.ContinueCallback then
        CallbackResult = self.Params.ContinueCallback(self)
    end
    if CallbackResult == false then
        return
    end
    if self.Params.IsWin then
        self:PlayAnimation(self.Out)
    else
        self:PlayAnimation(self.Fail_Out)
    end
end

function M:OnAnimationFinished(InAnimation) 
    if InAnimation == self.Out or InAnimation == self.Fail_Out then
        self:BlockAllUIInput(false)
        self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
        self.GameInputModeSubsystem:DisableInputMode("Settlement")
        self:Close()
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        DebugPrint("jly    已经显示的是该输入模式，不需要进行刷新")
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    --更新UI
    if CurInputDevice == ECommonInputType.MouseAndKeyboard then
        if self.Switch_Mode then
            self.Switch_Mode:SetActiveWidgetIndex(0)
        end
        if self.BattleInfoUI and self.BattleInfoUI.IsVisible then
            self.BattleInfoUI:SwitchPanelUI(self.CurInputDeviceType)
        end
        if ModController:IsMobile() then
            return
        end
        
        -- 获取奖励组件
        local RewardWidget = self.Settlement_RewardItem
        if RewardWidget and RewardWidget.Key_GamePad then
            RewardWidget.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        self.IsFocusList = false
        self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    elseif CurInputDevice == ECommonInputType.Gamepad then
        if self.Switch_Mode then
            self.Switch_Mode:SetActiveWidgetIndex(1)
        end
        if self.BattleInfoUI and self.BattleInfoUI.IsVisible then
            self.BattleInfoUI:SwitchPanelUI(self.CurInputDeviceType)
        end
        -- 手柄逻辑
        if self.IsFocusList then
            local RewardWidget = self.Settlement_RewardItem
            if RewardWidget and RewardWidget.List_Reward then
                RewardWidget.List_Reward:SetFocus()
            end
        else
            self:SetFocus()
            self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
            self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        -- 获取奖励组件
        local RewardWidget = self.Settlement_RewardItem
        if RewardWidget and RewardWidget.Key_GamePad then
            RewardWidget.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Visible)
        end
        if self.Cost and self.Cost.Key then
            self.Cost.Key:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
end

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    if not self.MaxListScrollOffset then
        self.MaxListScrollOffset = UIUtils.GetMaxScrollOffsetOfListView(self.List_ScoreItem)
    end

    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local AddOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 0.5
    
    -- 死区
    if math.abs(AddOffset) < 0.01 then 
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end

    if InKeyName == "Gamepad_RightY" then
        local CurScrollOffset = self.List_ScoreItem:GetScrollOffset()
        local ScrollOffset = math.clamp(CurScrollOffset - AddOffset, 0, self.MaxListScrollOffset)
        self.List_ScoreItem:SetScrollOffset(ScrollOffset)
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:UpdateBottomKeyInfo(IsFocusList)
    if not self.Key_GamePad then
        return
    end
    self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if IsFocusList then
        local BottomKeyInfo = {
            {
                KeyInfoList = {{Type = "Img", ImgShortPath = "A"}},
                Desc = GText("UI_Controller_CheckDetails")
            },
            {
                KeyInfoList = {{Type = "Img", ImgShortPath = "B"}},
                Desc = GText("UI_Tips_Close")
            },
        }
        self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Key_GamePad:UpdateKeyInfo(BottomKeyInfo)
    else
        local BottomKeyInfo = {}
        if CommonUtils.TableLength(self.Params.ScoreInfo) > 3 then
            BottomKeyInfo = {
                {
                    KeyInfoList = {{Type = "Img", ImgShortPath = "RV"}},
                    Desc = GText("UI_CTL_CheckCondition")
                },
            }
            self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Visible)
        end
        self.Key_GamePad:UpdateKeyInfo(BottomKeyInfo)

        if self.Icon_Key_Data then
            self.Icon_Key_Data:CreateCommonKey({
            KeyInfoList = {{
                Type = "Img",
                ImgShortPath = "Menu"}
            }})
        end
        end
    end

-- 设置手柄控制
function M:SetupGamepadControls()
    -- 手柄
    local RewardWidget = self.Settlement_RewardItem
    if RewardWidget and RewardWidget.Key_GamePad then
        RewardWidget.Key_GamePad:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "LS"
                }
            }
        })
    end

    self.IsFocusList = false
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
    self.GameInputModeSubsystem:EnableInputMode("Settlement", EGameInputMode.UI, FGameInputModeParams())
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
    self.Btn_Exit:SetGamePadImg("B")
    self.Btn_Continue:SetGamePadImg("Y")
end

function M:SequenceEvent_PlayScoreItemAnim()
    self.List_ScoreItem:RequestPlayEntriesAnim()
end

function M:Destruct()
    -- 清理动画定时器
    if self.ScoreAnimationTimer then
        self:RemoveTimer(self.ScoreAnimationTimer)
        self.ScoreAnimationTimer = nil
    end
    self.GameInputModeSubsystem:DisableInputMode("Settlement")
end

return M
