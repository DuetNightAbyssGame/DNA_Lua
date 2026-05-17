--
-- DESCRIPTION
-- 用于动态加载到活动通用跳转界面，止流委托进度专用
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

---@type WBP_Activity_Jump_ZhiliuEvent_Reward_C
local M = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.Common.TimerMgr",
})

function M:InitPage(EventId)
    self.CurProgress = 0
    self.TotalProgress = 7  -- 先写死7吧 之后再改
    self.ZhiliuEventId = DataMgr.EventConstant["ZhiLiuEntrustEventID"].ConstantValue

    self.Text_TaskProgressDesc:SetText(GText("ZhiLiuEntrust_Progress"))
    self.Btn_Reward:SetText(GText("ZhiLiuEntrust_GetGrandReward"))
    self:AddTimer(0.1, function()
        self.Btn_Reward:BindEventOnClicked(self, self.OnRewardBtnClicked)
    end, false, 0, "InitDelay", true)
    self.Btn_IconClick.OnClicked:Add(self, self.OnRewardIconClicked)

    self.Key_Reward:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Y"
            }
        }
    })
    self.Key_RewardBox:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "View"
            }
        }
    })

    self:UpdatePage()

    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if IsValid(self.GameInputModeSubsystem) then
        self:OnUpdateSubUIViewStyle(self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad)
    end
end

function M:UpdatePage()
    -- 仅满足前置任务 才显示此组件
    self.IsShow = self:IsPrerequisiteSatisfied()
    DebugPrint("ZhiliuReward:UpdatePage IsShow", self.IsShow)
    if self.IsShow then
        self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    self.CurProgress = self:GetCurProgress()
    DebugPrint("ZhiliuReward:UpdatePage CurProgress", self.CurProgress)

    -- 更新进度显示
    self.Text_TaskProgressNum01:SetText(self.CurProgress)
    self.Text_TaskProgressNum02:SetText(self.TotalProgress)

    -- 更新按钮是否可以点击
    -- 初始化时Update，调用顺序可能比通用奖励按钮的Construct早。如果初始化时显示禁用态则会出问题。因此延迟处理。
    local IsPlayerAlreadyGotReward = self:IsPlayerAlreadyGotReward()
    self.IsShowReddot = not IsPlayerAlreadyGotReward
    self:AddTimer(0.1, function()
        self:SetBtnAndReddotForbid(IsPlayerAlreadyGotReward)
    end, false, 0, "UpdateDelay", true)

    -- 更新显示对应面板
    if self.CurProgress == self.TotalProgress then
        self:SwitchDisplay("Reward")
    else
        self:SwitchDisplay("Progress")
    end
end

function M:SetBtnAndReddotForbid(IsForbid)
    self.Btn_Reward:ForbidBtn(IsForbid)
    if IsForbid then
        self.Reddot:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.Reddot:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    self.IsShowReddot = not IsForbid
end

function M:OnRewardBtnClicked()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if self.CurProgress ~= self.TotalProgress then
        return
    end

    local cb = function(ErrCode, RewardBox)
        DebugPrint("ZhiliuReward:OnCombatMainBtnClickedCallback")
        if ErrorCode:Check(ErrCode) then
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, RewardBox, false, nil, self, false)
            self:SetBtnAndReddotForbid(true)
            self.Key_Reward:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
    DebugPrint("ZhiliuReward:OnCombatMainBtnClicked")
    Avatar:RpcZhiLiuEntrustGrandRewards(cb)
end

function M:OnRewardIconClicked()
    local Params = {}
    Params.ActivityId = self.ZhiliuEventId
    UIManager(self):ShowCommonPopupUI(100202, Params, self)
end

function M:IsPlayerAlreadyGotReward()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end

    return Avatar.ZhiLiuEntrustGrandRewardGot or false
end

function M:SwitchDisplay(DisplayType)
    if DisplayType == "Progress" then
        self.HB_ProgressNum:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Group_RewardBtn:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self:PlayAnimation(self.Reward, self.Reward:GetEndTime(), 1, UE4.EUMGSequencePlayMode.Reverse)
    elseif DisplayType == "Reward" then
        self.HB_ProgressNum:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Group_RewardBtn:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self:PlayAnimation(self.Reward)
    else
        assert(false, "传入了错误的DisplayType! "..DisplayType)
    end
end

-- 是否满足前置任务
function M:IsPrerequisiteSatisfied()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end

    local ZhiliuEventInfo = DataMgr.EventMain[self.ZhiliuEventId]
    if not ZhiliuEventInfo then
        ScreenPrint("EventMain表中找不到止流活动相关信息！读取的EventId:"..self.ZhiliuEventId)
        return false
    end

    local PrerequisiteQuestId = {}
    if ZhiliuEventInfo.PretextTasks1 then
        table.insert(PrerequisiteQuestId, ZhiliuEventInfo.PretextTasks1)
    end
    for _, QuestId in pairs(ZhiliuEventInfo.PretextTasks2 or {}) do
        table.insert(PrerequisiteQuestId, QuestId)
    end

    for _, QuestId in pairs(PrerequisiteQuestId) do
        local QuestChain = Avatar.QuestChains[QuestId]
        -- 不合法输入，报错
        if not QuestChain then
            ScreenPrint("Zhiliu 配置了一个不存在的任务链Id！请策划检查！Id:"..QuestId)
            return false
        end
        -- 存在未完成，直接返回错误
        if not QuestChain:IsFinish() then
            return false
        end
    end
    return true
end

-- 获得当前进度
function M:GetCurProgress()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return 0
    end

    local CurProgress = 0
    for i = 1, 7 do
        local Info = Avatar.ZhiLiuEntrustDict[i]
        if Info and Info.SubmitEntrustCompleted and Info.CombatEntrustCompleted then
            CurProgress = i
        else
            return CurProgress
        end
    end
    return CurProgress
end

-- 是否完成提交委托
function M:IsSubmitCompleted(DayIndex)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    local Id = DataMgr.ZhiliuDateTab[DayIndex].SubmitEntrustID
    local Info = Avatar.ZhiLiuEntrustDict[Id] or {}
    return Info.SubmitEntrustCompleted or false
end

-- 是否完成战斗委托
function M:IsCombatCompleted(DayIndex)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    local Id = DataMgr.ZhiliuDateTab[DayIndex].CombatEntrustID
    local Info = Avatar.ZhiLiuEntrustDict[Id] or {}
    return Info.CombatEntrustCompleted or false
end

-- 这个Widget不用聚焦
function M:OnSubWidgetReceivedFocus()
    -- if self.IsShow then
    --     self:SetFocus() -- 存疑 其实可以不需要聚焦，然后父界面直接调用自己的OnKeyDown
    --     self.Key_Reward:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- end
end

function M:OnSubWidgetLostFocus()
    -- -- 一定要可点击时才显示按Y领取
    -- if self.IsShow and self.IsShowReddot then
    --     self.Key_Reward:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- end
end

function M:OnUpdateSubUIViewStyle(IsUseGamePad)
    DebugPrint("ZhiliuReward:OnUpdateSubUIViewStyle IsShow", self.IsShow, "IsUseGamePad", IsUseGamePad, "IsShowReddot", self.IsShowReddot)
    if not self.IsShow then
        return
    end
    if IsUseGamePad then
        if self.IsShowReddot then
            self.Key_Reward:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
        self.Key_RewardBox:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Key_Reward:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Key_RewardBox:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:HandleKeyDownOnGamePad(InKeyName)
    DebugPrint("ZhiliuReward:HandleKeyDownOnGamePad", InKeyName)
    if not self.IsShow then
        return false
    end
    if not self.IsShowReddot then
        return false
    end
    if InKeyName == UIConst.GamePadKey.FaceButtonTop then
        self.Btn_Reward:OnBtnClicked()
    elseif InKeyName == UIConst.GamePadKey.SpecialLeft then
        --self.Btn_IconClick:OnBtnClicked()     感觉该调对应按钮的OnClick，先这样吧
        self:OnRewardIconClicked()
    end
end

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
