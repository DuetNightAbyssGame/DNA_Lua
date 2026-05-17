require "UnLua"
local GuildWarUtils = require "BluePrints.UI.WBP.Activity.Widget.GuildWar.GuildWarUtils"

local M = Class("BluePrints.UI.BP_EMUserWidget_C")
M._components = {
    "BluePrints.UI.BP_EMUserWidgetUtils_C",
}

function M:Construct()
    self:AddDispatcher(EventID.OnPreRaidRankInfo, self, self.OnPreRaidRankInfo)  -- 预选赛分组
    self:AddDispatcher(EventID.OnRaidRankInfo, self, self.OnRaidRankInfo)  -- 正式赛排名
    self:AddDispatcher(EventID.OnRaidRankStart, self, self.OnRaidRankStart)  -- 正式赛开赛
    self:AddDispatcher(EventID.OnActivityEntryShowVisible, self, self.OnActivityEntryShowVisible)  -- 选关页退回到主页
end

function M:Destruct()
    self:RemoveInputMethodChangedListen()
end

-- 通用界面刷新接口实现
function M:Update()
    if self.SkipNextRefresh  then
        self.SkipNextRefresh = false
        return
    end
    self:RefreshBoardWidget()
end

-- 选关页退出走这里播动画，Update播动画与活动页播动画不同步
function M:OnActivityEntryShowVisible()
    self.SkipNextRefresh  = true
    self:RefreshBoardWidget()
end

-- 通用界面初始化接口实现
function M:Init(ActivityConfigData, PageConfigData, PlayerAvatar)
    self.Avatar = PlayerAvatar
    self.RootWidget = self.ParentWidget and self.ParentWidget.ParentWidget
    self.EventId = ActivityConfigData.EventId

    self:RefreshBoardWidget()
    -- 输入设备切换监听
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    self:AddInputMethodChangedListen()
    self:RefreshOpInfoByInputDevice(
        self.GameInputModeSubsystem:GetCurrentInputType(),
        self.GameInputModeSubsystem:GetCurrentGamepadName()
    )
    -- 选关页按钮是否禁用
    self:SetJumpPageButtonDisable()
end

-- 附带处理下跳转选关页按钮的禁用状态
function M:SetJumpPageButtonDisable()
    if GuildWarUtils.IsRaidTime() then  -- 赛事期间
        return
    end
    local ParentWidget = self.ParentWidget
    if ParentWidget and ParentWidget.WS then
        ParentWidget.WS:SetActiveWidgetIndex(2)
        ParentWidget.Text_Complete:SetText(GText("UI_GameEvent_EventEnd"))
    end
end

-- 刷新公告板
function M:RefreshBoardWidget()
    if GuildWarUtils.IsPreRaidTime()  then  -- 预选赛
        self:RefreshQualificationBoard()
    else -- 正式赛
        self:RefreshOfficialBoard()
    end
end

-- 刷新预选赛公告板
function M:RefreshQualificationBoard()
    local SeasonData, _ = GuildWarUtils.GetSeasonAndEventData()
    if not SeasonData then
        return
    end

    local PreRaidDuration = SeasonData.PreRaidTime * 3600 -- 预选赛持续时间
    local CurEventData = DataMgr.EventMain[self.EventId]  -- 事件数据
    local QualificationEndTime = CurEventData.EventStartTime + PreRaidDuration   -- 预选赛结束时间

    self.WS_Type:SetActiveWidgetIndex(0)
    self.WS_Type:SetVisibility(UIConst.VisibilityOp.Collapsed)

    local BoardWidget = self.WB_QualificationBoard
    BoardWidget.Key_Reward:CreateCommonKey({
        KeyInfoList={{ Type = "Img", ImgShortPath = "View"}}
    })
    local QualificationEndDate = TimeUtils.TimestampToDataObj(QualificationEndTime)
    local OfficalMathcStartDateText = table.concat({
        self:PadZero(QualificationEndDate.month), "-", self:PadZero(QualificationEndDate.day), " ",
        self:PadZero(QualificationEndDate.hour), ":", self:PadZero(QualificationEndDate.min)
    })
    BoardWidget.Text_Status:SetText(OfficalMathcStartDateText)
    BoardWidget.Text_QualificationMatch:SetText(GText("RaidDungeon_PreRaid_Rank"))
    BoardWidget.Text_OfficialMathch:SetText(GText("RaidDungeon_Raid_Rank"))

    if GuildWarUtils.IsPreRaidTime() then -- 预选赛期间：显示倒计时
        BoardWidget.WS_Time:SetActiveWidgetIndex(0)
        local RemainTimeDict, _ = UIUtils.GetLeftTimeStrStyle2(QualificationEndTime)
        BoardWidget.Time:SetTimeText(GText("UI_Disptach_RemainTime"), RemainTimeDict)
    else  -- 预选赛已结束
        BoardWidget.WS_Time:SetActiveWidgetIndex(1)
        BoardWidget.Text_End:SetText(GText("RaidDungeon_PreRaid_End"))
    end

    local RaidSeasons = self.Avatar.RaidSeasons[self.Avatar.CurrentRaidSeasonId]  -- 赛季数据
    if not RaidSeasons then
        return
    end

    -- BanState = 0(未封禁)，1(预选赛封禁)， 2(正式赛封禁)
    if RaidSeasons.BanState ~= 1 then -- 预选赛未封禁
        BoardWidget.WS_Type:SetActiveWidgetIndex(0)
        -- 获取预选赛分组信息
        self.Avatar:RaidSeasonGetPreRaidRankInfo(function(ErrCode)
            if (not ErrorCode:Check(ErrCode)) and self then
                self:SetRankTextureImage(BoardWidget, 0)
            end
        end)
        -- 奖励预览
        BoardWidget.Text_Reward:SetVisibility(UIConst.VisibilityOp.Visible)
        BoardWidget.Text_Reward:SetText(GText("UI_Event_MidTerm_GotoPreview"))
        BoardWidget.Btn_Check:SetVisibility(UIConst.VisibilityOp.Visible)
        BoardWidget.Btn_Check:Init({ ClickCallback = self.OnRewardPreviewClicked, OwnerWidget = self})
    else  -- 已封禁
        BoardWidget.WS_Type:SetActiveWidgetIndex(1)
        BoardWidget.Text_Ban:SetText(GText("RaidDungeon_Rank_Ban"))
        -- 隐藏奖励预览
        BoardWidget.Text_Reward:SetVisibility(UIConst.VisibilityOp.Collapsed)
        BoardWidget.Btn_Check:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

    self:AddTimer(0.2, function()
        self.WS_Type:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        BoardWidget:PlayAnimation(BoardWidget.In)
    end)
end

-- 刷新正式赛公告板
function M:RefreshOfficialBoard()
    local SeasonData, _ = GuildWarUtils.GetSeasonAndEventData()
    if not SeasonData then
        return
    end

    local RaidSeasons = self.Avatar.RaidSeasons[self.Avatar.CurrentRaidSeasonId]  -- 赛季数据
    if not RaidSeasons then
        return
    end

    self.WS_Type:SetActiveWidgetIndex(1)
    self.WS_Type:SetVisibility(UIConst.VisibilityOp.Collapsed)

    local PreRaidDuration = SeasonData.PreRaidTime * 3600 -- 预选赛持续时间
    local RaidDuration= SeasonData.RaidTime * 3600  -- 正式赛持续时间
    local CurEventData = DataMgr.EventMain[self.EventId]  -- 事件数据
    local QualificationEndTime = CurEventData.EventStartTime + PreRaidDuration   -- 预选赛结束时间
    local RaidEndTime = QualificationEndTime + RaidDuration  -- 正式赛结束时间

    local BoardWidget = self.WB_OfficialBoard
    BoardWidget.Text_Ranking:SetVisibility(UIConst.VisibilityOp.Collapsed)
    BoardWidget.Btn_GainReward.Key_Controller:CreateCommonKey({
        KeyInfoList={{ Type = "Img", ImgShortPath = "View"}}
    })
    BoardWidget.Text_Status:SetText(GText("RaidDungeon_PreRaid_End"))
    BoardWidget.Text_QualificationMatch:SetText(GText("RaidDungeon_PreRaid_Rank"))
    BoardWidget.Text_OfficialMathch:SetText(GText("RaidDungeon_Raid_Rank"))

    if GuildWarUtils.IsRaidTime() then  -- 正式赛期间：显示倒计时
        BoardWidget.WS_Time:SetActiveWidgetIndex(0)
        local RemainTimeDict, _ = UIUtils.GetLeftTimeStrStyle2(RaidEndTime)
        BoardWidget.Time:SetTimeText(GText("UI_Disptach_RemainTime"), RemainTimeDict)
    else  -- 正式赛已结束
        BoardWidget.WS_Time:SetActiveWidgetIndex(1)
        BoardWidget.Text_End:SetText(GText("RaidDungeon_PreRaid_End"))
    end

    self:RefreshPreRaidRewardGot(BoardWidget)

    -- BanState = 0(未封禁)，1(预选赛封禁)， 2(正式赛封禁)
    if RaidSeasons.BanState ~= 1 then -- 预选赛阶段未被封禁
        BoardWidget.WS_Type:SetActiveWidgetIndex(0)
        -- 设置分组图片
        self:SetRankTextureImage(BoardWidget, RaidSeasons.PreRaidGroupId)
        -- 获取正式赛排名信息
        self.Avatar:RaidSeasonGetRaidRankInfo(function(ErrCode)
            if (not ErrorCode:Check(ErrCode)) and self then
                self:InitRaidRankText(0)
            end
        end)
    else  -- 已封禁
        BoardWidget.WS_Type:SetActiveWidgetIndex(1)
        BoardWidget.Text_Ban:SetText(GText("RaidDungeon_Rank_Ban"))
    end

    self:AddTimer(0.2, function()
        self.WS_Type:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        BoardWidget:PlayAnimation(BoardWidget.In)
    end)
end

-- 预选赛分组设置
function M:OnPreRaidRankInfo(RankInfo)
    if RankInfo and GuildWarUtils.IsPreRaidTime() then
        self:SetRankTextureImage(self.WB_QualificationBoard, RankInfo.PreRaidGroupId)
    end
end

-- 正式赛排名设置
function M:OnRaidRankInfo(RankInfo)
    local Rank = RankInfo and RankInfo.Rank
    self:InitRaidRankText(Rank)
end

-- 正式赛开赛后更新分组
function M:OnRaidRankStart(_, RaidGroupId)
    self:RefreshOfficialBoard()
    if RaidGroupId then
        self:SetRankTextureImage(self.WB_OfficialBoard, RaidGroupId)
    end
end

-- 预选赛奖励是否领取
function M:RefreshPreRaidRewardGot(BoardWidget)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    -- 赛季数据
    local RaidSeasons = Avatar.RaidSeasons[Avatar.CurrentRaidSeasonId]
    if not RaidSeasons then
        return
    end

    -- 参加了预选赛 & 预选赛奖励没领取
    if self:CanGetPreRaidReward() then
        BoardWidget.Btn_GainReward:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        BoardWidget.Btn_GainReward:Init(self, self.OnRewardGotBtnClicked)
    else
        BoardWidget.Btn_GainReward:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    GuildWarUtils.RefreshRewardGotReddot()  -- 刷新下领奖红点
end

-- 正式赛排名文本
function M:InitRaidRankText(RankNum)
    local TextWidget = self.WB_OfficialBoard.Text_Ranking
    if not TextWidget then
        return
    end
    if RankNum and RankNum > 0 then
        TextWidget:SetText(GText("RaidDungeon_Rank") .. " " .. RankNum)
        TextWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        TextWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

-- 是否可以领取预选赛奖励
function M:CanGetPreRaidReward()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end

    local RaidSeasons = Avatar.RaidSeasons[Avatar.CurrentRaidSeasonId]
    if not RaidSeasons then
        return false
    end

    -- 没参加预选赛
    if (RaidSeasons.PreRaidGroupId <= 0)then
        return false
    end

    -- 奖励是否已领取
    local CanGetReward = (not RaidSeasons:IsPreRaidRewardGot())
    return CanGetReward
end

-- 领取预选赛奖励
function M:OnRewardGotBtnClicked()
    -- 是否可以领取预选赛奖励
    if not self:CanGetPreRaidReward() then
        return
    end

    AudioManager(self):PlayUISound(self, "event:/ui/activity/shop_small_btn_click","",nil)
    local function Callback(ErrCode, Ret)
        if self.RootWidget and self.RootWidget.BlockAllUIInput then
            self.RootWidget:BlockAllUIInput(false)
        end
        -- 刷新客户端数据
        self:RefreshPreRaidRewardGot(self.WB_OfficialBoard)  -- 刷新奖励按钮的状态
        -- 错误码处理
        if not ErrorCode:Check(ErrCode) then
            return
        end
        -- 获取领奖数据
        local PreRaidRankData = DataMgr.PreRaidRank[1]
        local RaidSeasons = self.Avatar.RaidSeasons[self.Avatar.CurrentRaidSeasonId]
        if not RaidSeasons or not RaidSeasons.PreRaidGroupId then
            DebugPrint("获取不到预选赛分组信息!")
            return
        end
        local RewardId = PreRaidRankData.RankReward[RaidSeasons.PreRaidGroupId]
        local AllRewards = RewardUtils:GetRewards(RewardId, nil)
        -- 弹出领奖弹窗
        if (self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad) then
            self:AddTimer(0.8, function()
                UIManager(self):LoadUINew("GetItemPage",  nil, nil, nil, AllRewards, self.PlayOutAnim, self, true)
            end)
        else
            UIManager(self):LoadUINew("GetItemPage",  nil, nil, nil, AllRewards, self.PlayOutAnim, self, true)
        end
    end
    if self.RootWidget and self.RootWidget.BlockAllUIInput then
        self.RootWidget:BlockAllUIInput(true)
    end
    self.Avatar:RaidSeasonGetPreRankReward(Callback)
end

-- 预选赛：奖励预览
function M:OnRewardPreviewClicked(IsChecked)
    local RaidSeasons = self.Avatar.RaidSeasons[self.Avatar.CurrentRaidSeasonId]  -- 赛季数据
    if not RaidSeasons then
        return
    end

    if RaidSeasons.BanState == 1 then -- 预选赛已封禁
        return
    end

    AudioManager(self):PlayUISound(self, "event:/ui/activity/shop_small_btn_click","",nil)
    local GuildWarRewardPop = UIManager(self):LoadUINew("GuildWarRewardPop")
    GuildWarRewardPop:Init()
end

function M:SetRankTextureImage(Widget, GroupId)
    local IconIndex = GroupId or 0
    if IconIndex < 0 or type(IconIndex) ~= "number" then
        IconIndex = 0
    end
    local RankIcon = self["Rank_" .. IconIndex]
    Widget.Icon_Rank:SetBrush(RankIcon)
end

function M:PadZero(Num)
    return Num < 10 and ("0" .. tostring(Num)) or tostring(Num)
end

function M:GetDateText(Timestamp)
    if type(Timestamp) ~= "number" then
        return
    end
    local Date = TimeUtils.TimestampToDataObj(Timestamp)
    return table.concat({ Date.year, "-", self:PadZero(Date.month), "-", self:PadZero(Date.day)})
end

function M:AddInputMethodChangedListen()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice) 
    end
end

function M:RemoveInputMethodChangedListen()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice) 
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        self:InitKeyBoardView()
    elseif CurInputDevice==ECommonInputType.Gamepad then
        self:InitGamepadView()
    end
end

function M:InitKeyBoardView()
    local RaidSeasons = self.Avatar.RaidSeasons[self.Avatar.CurrentRaidSeasonId]
    if not RaidSeasons then
        return
    end

    if GuildWarUtils.IsPreRaidTime()then -- 预选赛奖励预览
        if RaidSeasons.BanState ~= 1 then -- 未封禁
            self.WB_QualificationBoard.WS_Controller:SetVisibility(UIConst.VisibilityOp.Visible)
            self.WB_QualificationBoard.WS_Controller:SetActiveWidget(self.WB_QualificationBoard.Btn_Check)
        else
            self.WB_QualificationBoard.WS_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    else -- 正式赛：预选赛奖励领取手柄按键
        self.WB_OfficialBoard.Btn_GainReward.Key_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:InitGamepadView()
    local RaidSeasons = self.Avatar.RaidSeasons[self.Avatar.CurrentRaidSeasonId]
    if not RaidSeasons then
        return
    end

    if GuildWarUtils.IsPreRaidTime() then -- 预选赛奖励预览
        if RaidSeasons.BanState ~= 1 then -- 未封禁
            self.WB_QualificationBoard.WS_Controller:SetVisibility(UIConst.VisibilityOp.Visible)
            self.WB_QualificationBoard.WS_Controller:SetActiveWidget(self.WB_QualificationBoard.Key_Reward)
        else
            self.WB_QualificationBoard.WS_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    elseif self:CanGetPreRaidReward() then  -- 正式赛: 预选赛奖励未获取
        self.WB_OfficialBoard.Btn_GainReward.Key_Controller:SetVisibility(UIConst.VisibilityOp.Visible)
    end
end

function M:HandleKeyDownOnGamePad(InKeyName)
    local IsEventHandled=false
    if InKeyName== UIConst.GamePadKey.SpecialLeft then
        IsEventHandled=true
        if GuildWarUtils.IsPreRaidTime() then  -- 预选赛奖励预览
            self:OnRewardPreviewClicked()
        else
            self:OnRewardGotBtnClicked()  -- 正式赛奖励领取
        end
    end
    return IsEventHandled
end

AssembleComponents(M)

return M