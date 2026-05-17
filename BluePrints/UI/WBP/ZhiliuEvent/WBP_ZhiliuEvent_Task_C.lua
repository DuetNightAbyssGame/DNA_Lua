--
-- DESCRIPTION
-- 止流委托，主界面
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local EMCache = require "EMCache.EMCache"
local TimeUtils = require "Utils.TimeUtils"
local CommonUtils = require "Utils.CommonUtils"
local AnnounceModel = AnnounceController:GetModel()

local DebugUnlockAllCondition = false

---@type WBP_Activity_ZhiliuEvent_Task_P_C
local M = Class({
    "BluePrints.UI.BP_UIState_C",
    "BluePrints.Common.TimerMgr",
})

function M:OnLoaded(...)
    M.Super.OnLoaded(self, ...)

    self:SetFocus()

    self.IsListPanelShow = false
    --self.IsShowCombatPanel = true
    --self.CurDayIndex = 1
    self.ZhiliuEventId = DataMgr.EventConstant.ZhiLiuEntrustEventID.ConstantValue
    self.ZhiliuTotalDayNum = 7

    self:InitMainTitle()
    self:InitMainButton()
    self:InitDaySwitchButton()
    self:InitTypeSwitchButton()
    self:InitTabs()
    self:InitRewardProgress()

    self:InitInputDeviceInfo()

    self:PlayAnimation(self.In)

    UIManager(self):SwitchFixedCamera(true, 220040, "Zhiliu", self,  "ZhiliuEventTask", {bDestroyNpc=true, IsHaveInOutAnim=false})
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "OpenZhiliuEvent", nil)
end

function M:Close()
    self:BindToAnimationFinished(self.Out, function()
        UIManager(self):SwitchFixedCamera(false, 220040,"Zhiliu", self, "ZhiliuEventTask",{bDestroyNpc=true, IsHaveInOutAnim=false})
        M.Super.Close(self)
    end)
    AudioManager(self):SetEventSoundParam(self, "OpenZhiliuEvent", {ToEnd = 1})
    self:PlayAnimation(self.Out)
end

-- 初始化主标题（左下角标题+文字说明+商店按钮）
function M:InitMainTitle()
    -- 策划要求折叠
    self.Text_DescTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Text_Desc:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Text_Shop:SetText(GText("MAIN_UI_SHOP"))
    self.Btn_Shop.OnClicked:Add(self, self.OnClicked_Shop)
    self.Btn_Shop.OnHovered:Add(self, self.OnHovered_Shop)
    self.Group_Shop:SetVisibility(UE4.ESlateVisibility.Collapsed)       -- shop被干掉了
end

function M:OnClicked_Shop()
    DebugPrint("ZhiliuEventTask:OnClicked_Shop")
    -- local GameInstance = GWorld.GameInstance
    -- local UIManager = GameInstance:GetGameUIManager()
    -- local ShopMainPage = UIManager:GetUIObj("ActivityShop")
    -- if (not ShopMainPage) then
    --     ShopMainPage = UIManager:LoadUINew('ActivityShop', 10001, nil, "ZhiLiuEntrust")
    --     UIManager:AddToJumpPageDeque(ShopMainPage)
    -- else
    --     -- 已经存在的界面
    --     UIManager:PlaceJumpUIToTop(ShopMainPage, "ActivityShop")
    --     ShopMainPage:InitShop(10001, nil, "ZhiLiuEntrust")
    -- end
    -- AudioManager(self):PlayUISound(self, "event:/ui/activity/zhiliu_shop_click", nil, nil)
end

function M:OnHovered_Shop()
    AudioManager(self):PlayUISound(self, "event:/ui/activity/zhiliu_shop_hover", nil, nil)
end

-- 初始化左下角委托完成进度
function M:InitRewardProgress()
    local RewardResource = DataMgr.EventConstant.ZhiLiuEntrustRewardResource.ConstantValue or 10100
    local IconPath = DataMgr.Resource[RewardResource].Icon
    local RewardNum = DataMgr.EventConstant.ZhiLiuEntrustRewardResourceNum.ConstantValue or 1

    self.Group_TaskProgress:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Text_RewardNum:SetText("x"..tostring(RewardNum))
    self.Text_TaskProgressTitle:SetText(GText("ZhiLiuEntrust_Progress"))
    UE.UResourceLibrary.LoadObjectAsync(self,IconPath,{self,M.OnRewardProgressIconLoaded})

    self.Btn_TaskProgress.OnClicked:Add(self, self.OnClicked_RewardBtn)
    self.Btn_TaskProgress.OnHovered:Add(self, self.OnHovered_RewardBtn)
    self.Btn_TaskProgress.OnUnhovered:Add(self, self.OnUnhovered_RewardBtn)
    self:UpdateRewardProgress()
end

function M:OnRewardProgressIconLoaded(Obj)
    if Obj and IsValid(self) then
        self.Image_RewardIcon01:SetBrushFromTexture(Obj)
        self.Image_RewardIcon02:SetBrushFromTexture(Obj)
    end
end

function M:OnClicked_RewardBtn()
    DebugPrint("ZhiliuEventTask: OnClicked_RewardBtn", self.IsRewardBtnClickable)
    if not self.IsRewardBtnClickable then
        if not self:IsPlayerAlreadyGotReward() then
            UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("ZhiLiuEntrustGrandRewardTips"), 2)
        end
        return
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local cb = function(ErrCode, RewardBox)
        DebugPrint("ZhiliuEventTask:OnClicked_RewardBtnCallback")
        if ErrorCode:Check(ErrCode) then
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, RewardBox, false, nil, self)
            self:SetRewardBtnClickable(false)
        end
    end
    Avatar:RpcZhiLiuEntrustGrandRewards(cb)
    self:PlayAnimation(self.Shop_Click)
end

function M:OnHovered_RewardBtn()
    if not self.IsRewardBtnClickable then
        return
    end
    self:PlayAnimation(self.Shop_Hover)
end

function M:OnUnhovered_RewardBtn()
    if not self.IsRewardBtnClickable then
        return
    end
    self:PlayAnimation(self.Shop_UnHover)
end

function M:UpdateRewardProgress()
    local CurrentProgress = self:GetCurrentProgress()
    self.Text_TaskProgress_1:SetText(CurrentProgress)
    self.Text_TaskProgress_2:SetText(self.ZhiliuTotalDayNum)

    local IsClickable = false
    if (CurrentProgress >= self.ZhiliuTotalDayNum) and (not self:IsPlayerAlreadyGotReward()) then
        IsClickable = true
    end
    self:SetRewardBtnClickable(IsClickable)
end

function M:SetRewardBtnClickable(IsClickable)
    if (self.IsRewardBtnClickable ~= nil) and (self.IsRewardBtnClickable == IsClickable) then
        return
    end
    self.IsRewardBtnClickable = IsClickable
    if IsClickable then
        self:PlayAnimation(self.Receive)
        self.Reddot:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        if self:IsPlayerAlreadyGotReward() then
            self:PlayAnimation(self.Received)
        else
            self:PlayAnimation(self.Receive_Normal)
        end
        self.Reddot:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self.Btn_TaskProgress:SetForbidden(not IsClickable)
end

function M:IsPlayerAlreadyGotReward()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end

    return Avatar.ZhiLiuEntrustGrandRewardGot or false
end

function M:GetCurrentProgress()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return 0
    end

    local CurProgress = 0
    for i = 1, self.ZhiliuTotalDayNum do
        if not self:IsCombatCompleted(i) then
            break
        end
        if not self:IsSubmitCompleted(i) then
            break
        end
        CurProgress = CurProgress + 1
    end
    return CurProgress
end

-- 初始化用于切换日期的按钮
function M:InitDaySwitchButton()
    -- 前一天所有内容已提交，且战斗任务已完成
    local FirstShowIndex = 0
    local IsCurIndexCompleted = false
    for i = 1, self.ZhiliuTotalDayNum do
        if self:IsTimeSatisfied(i) then
            FirstShowIndex = i
        else
            break
        end
        IsCurIndexCompleted = self:IsSubmitCompleted(i) and self:IsCombatCompleted(i)
        if not IsCurIndexCompleted then
            break
        end
    end
    DebugPrint("ZhiliuEventTask:InitDaySwitchButton", FirstShowIndex)

    for i = 1, self.ZhiliuTotalDayNum do 
        local DayTaskTab = self["Tab_"..i]
        if i < FirstShowIndex then
            DayTaskTab:InitTaskTab(self, i, "Completed")
        elseif i > FirstShowIndex then
            DayTaskTab:InitTaskTab(self, i, "Locked")
        else
            if IsCurIndexCompleted then
                DayTaskTab:InitTaskTab(self, i, "Completed")
            else
                DayTaskTab:InitTaskTab(self, i, "Normal")
            end
        end
    end

    if FirstShowIndex > 0 then
        self.MuteDaySwitchAudioOnLoaded = true
        self.MuteTypeSwitchAudioOnLoaded = true
        self["Tab_"..FirstShowIndex]:OnClickedEvent()
    end
end

function M:OnDaySwitchButtonClicked(TabIndex)
    self:ShowDailyPanel(TabIndex)

    for i = 1, self.ZhiliuTotalDayNum do
        if i ~= TabIndex then
            local DayTaskTab = self["Tab_"..i]
            DayTaskTab:SetNormal(self, i)
        end
    end

    if self.MuteDaySwitchAudioOnLoaded then
        self.MuteDaySwitchAudioOnLoaded = false
    else
        AudioManager(self):PlayUISound(self, "event:/ui/activity/zhiliu_btn_mid_btn", nil, nil)
    end
end

function M:OnDaySwitchButtonLockedClicked(TabIndex)
    if not self:IsTimeSatisfied(TabIndex) then
        local NowTime = TimeUtils.NowTime()
        local ConfigedTime = DataMgr.ZhiliuDateTab[TabIndex].Time
        if ConfigedTime then
            local TotalDiffTime = ConfigedTime - NowTime
            local DiffDay = math.floor((TotalDiffTime) / CommonConst.SECOND_IN_DAY)
            TotalDiffTime = TotalDiffTime - DiffDay * CommonConst.SECOND_IN_DAY
            local DiffHour = math.floor((TotalDiffTime) / CommonConst.SECOND_IN_HOUR)
            TotalDiffTime = TotalDiffTime - DiffHour * CommonConst.SECOND_IN_HOUR
            local DiffMin = math.floor((TotalDiffTime) / CommonConst.SECOND_IN_MINUTE)
            local TimeArgs = TArray(FFormatArgumentData)
            local FinalStr = ""
            if DiffDay > 0 then
                AnnounceModel:_AddFormatArg(TimeArgs, "DD", DiffDay)
                AnnounceModel:_AddFormatArg(TimeArgs, "H", DiffHour)
                FinalStr = UKismetTextLibrary.Format(GText("ZhiLiuEntrust_Lock_Time1"), TimeArgs)
            else
                AnnounceModel:_AddFormatArg(TimeArgs, "H", DiffHour)
                AnnounceModel:_AddFormatArg(TimeArgs, "M", DiffMin)
                FinalStr = UKismetTextLibrary.Format(GText("ZhiLiuEntrust_Lock_Time2"), TimeArgs)
            end
            UIManager(self):ShowUITip(UIConst.Tip_CommonTop, FinalStr)
        end
    else
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, string.format(GText("ZhiLiuEntrust_Lock_PretextTasks"), TabIndex - 1))
    end
end

-- 初始化用于切换提交任务和战斗任务的按钮
function M:InitTypeSwitchButton()
    self.Btn_TabBattle.OnPressed:Add(self, self.OnPressed_CombatTab)
    self.Btn_TabBattle.OnHovered:Add(self, self.OnHovered_CombatTab)
    self.Btn_TabBattle.OnUnHovered:Add(self, self.OnUnHovered_CombatTab)
    self.Btn_TabBattle.OnClicked:Add(self, self.OnClicked_CombatTab)

    self.Btn_TabTrade.OnPressed:Add(self, self.OnPressed_SubmitTab)
    self.Btn_TabTrade.OnHovered:Add(self, self.OnHovered_SubmitTab)
    self.Btn_TabTrade.OnUnHovered:Add(self, self.OnUnHovered_SubmitTab)
    self.Btn_TabTrade.OnClicked:Add(self, self.OnClicked_SubmitTab)

    -- local CombatImgpath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/RougeLike/T_Rouge_Talent_Melee_AttackUP.T_Rouge_Talent_Melee_AttackUP'"
    -- local CombatImg = LoadObject(CombatImgpath)
    -- self.Image_TitleBattleIcon:SetBrushResourceObject(CombatImg)
    -- self.Image_SideTabBattleIcon:SetBrushResourceObject(CombatImg)
    -- local SubmitImgpath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/RougeLike/T_Rouge_Talent_SkillSustainUP.T_Rouge_Talent_SkillSustainUP'"
    -- local SubmitImg = LoadObject(SubmitImgpath)
    -- self.Image_TitleTradeIcon:SetBrushResourceObject(SubmitImg)
    -- self.Image_SideTabTradeIcon:SetBrushResourceObject(SubmitImg)

    self.Group_List:SetRenderOpacity(0)
end

function M:SetTypeSwitchButtonState(IsCombat, IsShow)
    local NewVisibility
    if IsShow then
        NewVisibility = UE4.ESlateVisibility.Visible
    else
        NewVisibility = UE4.ESlateVisibility.Collapsed
    end
    if IsCombat then
        self.Battle_New:SetVisibility(NewVisibility)
    else
        self.Trade_New:SetVisibility(NewVisibility)
    end
end

-- 不希望已经显示战斗tab的时候，再次点击时重复触发刷新逻辑（其实主要是那个刷新动效
-- 调用来源是切换日期tab时，IsForceUpdate传true；直接点击传nil
-- 如果后续有问题，那就单独处理刷新动效吧
function M:OnClicked_CombatTab(IsForceUpdate)
    self:StopAnimation(self.Battle_Press)
    self:PlayAnimation(self.Battle_Click)
    if (not IsForceUpdate) and (self.IsShowCombatPanel == true) then
        return
    end
    self:ShowCombatPanel()
    self:PlayAnimation(self.Trade_Normal)
    self:PlayAnimation(self.Change)

    local CacheName = "ZhiliuEvent_Task_ShowedCombat_"..self.CurDayIndex
    EMCache:Set(CacheName, true, true)
    self:SetTypeSwitchButtonState(true, false)

    if self.MuteTypeSwitchAudioOnLoaded then
        self.MuteTypeSwitchAudioOnLoaded = false
    else
        AudioManager(self):PlayUISound(self, "event:/ui/activity/zhiliu_btn_small_tab", nil, nil)
    end
end

function M:OnPressed_CombatTab()
    if self.IsShowCombatPanel then return end
    self:PlayAnimation(self.Battle_Press)
end

function M:OnHovered_CombatTab()
    if self.IsShowCombatPanel then return end
    self:PlayAnimation(self.Battle_Hover)
end

function M:OnUnHovered_CombatTab()
    if self.IsShowCombatPanel then return end
    self:PlayAnimation(self.Battle_UnHover)
end
--
-- 同OnClicked_CombatTab
function M:OnClicked_SubmitTab(IsForceUpdate)
    self:StopAnimation(self.Trade_Press)
    self:PlayAnimation(self.Trade_Click)
    if (not IsForceUpdate) and (self.IsShowCombatPanel == false) then
        return
    end
    self:ShowSubmitPanel()
    self:PlayAnimation(self.Battle_Normal)
    self:PlayAnimation(self.Change)

    local CacheName = "ZhiliuEvent_Task_ShowedSubmit_"..self.CurDayIndex
    EMCache:Set(CacheName, true, true)
    self:SetTypeSwitchButtonState(false, false)

    if self.MuteTypeSwitchAudioOnLoaded then
        self.MuteTypeSwitchAudioOnLoaded = false
    else
        AudioManager(self):PlayUISound(self, "event:/ui/activity/zhiliu_btn_small_tab", nil, nil)
    end
end

function M:OnPressed_SubmitTab()
    if not self.IsShowCombatPanel then return end
    self:PlayAnimation(self.Trade_Press)
end

function M:OnHovered_SubmitTab()
    if not self.IsShowCombatPanel then return end
    self:PlayAnimation(self.Trade_Hover)
end

function M:OnUnHovered_SubmitTab()
    if not self.IsShowCombatPanel then return end
    self:PlayAnimation(self.Trade_UnHover)
end

-- 初始化每日数据
function M:ShowDailyPanel(DayIndex)
    if self.CurDayIndex == DayIndex then
        return
    end
    self.CurDayIndex = DayIndex

    -- 先获取待显示数据
    self:RequestSubmitInfo()
    self:RequestCombatInfo()

    if not self:IsCombatCompleted(self.CurDayIndex) then
        self:OnClicked_CombatTab(true)
    elseif not self:IsSubmitCompleted(self.CurDayIndex) then
        self:OnClicked_SubmitTab(true)
    else
        self:OnClicked_CombatTab(true)
    end
end

function M:IsSubmitCompleted(DayIndex)
    -- -- 测试用
    if DebugUnlockAllCondition then
        return true
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    if Avatar.ZhiLiuEntrustDict[DayIndex] then
        return Avatar.ZhiLiuEntrustDict[DayIndex].SubmitEntrustCompleted or false
    end
    return false
end

function M:IsCombatCompleted(DayIndex)
    -- -- 测试用
    if DebugUnlockAllCondition then
        return true
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    if Avatar.ZhiLiuEntrustDict[DayIndex] then
        return Avatar.ZhiLiuEntrustDict[DayIndex].CombatEntrustCompleted  or false
    end
    return false
end

function M:IsTimeSatisfied(DayIndex)
    -- -- 测试用
    if DebugUnlockAllCondition then
        return true
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    local ConfigedTime = DataMgr.ZhiliuDateTab[DayIndex].Time
    if not ConfigedTime then
        return true    -- 保底处理 如果没填就认为已解锁
    end
    local CurTime = TimeUtils.NowTime()
    return CurTime >= ConfigedTime
end

function M:RequestSubmitInfo()
    self.CurSubmitId = DataMgr.ZhiliuDateTab[self.CurDayIndex].SubmitEntrustID
    local SubmitConfig = DataMgr.ZhiliuEntrust[self.CurSubmitId]
    self.CurSubmitText = SubmitConfig.EntrustText
    self.CurSubmitRewardId = SubmitConfig.RewardId or 0
    self.CurSubmitType = SubmitConfig.ChildClass or 1
    self.CurSubmitNeeded = SubmitConfig.Resource or {}      -- 读表出来的原始数据，如果有需求，可使用处理后的表self.CurSubmitInfoTable
    self.CurSubmitListLen = #self.CurSubmitNeeded

    local CacheName = "ZhiliuEvent_Task_ShowedSubmit_"..self.CurDayIndex
    local CacheData = EMCache:Get(CacheName, true)
    self:SetTypeSwitchButtonState(false, not CacheData)

    local IsSubmitCompleted = self:IsSubmitCompleted(self.CurDayIndex)
    self:ShowSubmitCompleted(IsSubmitCompleted)
end

function M:RequestCombatInfo()
    self.CurCombatId = DataMgr.ZhiliuDateTab[self.CurDayIndex].CombatEntrustID
    local CombatConfig = DataMgr.ZhiliuEntrust[self.CurCombatId]
    self.CurCombatText = CombatConfig.EntrustText
    self.CurCombatRewardId = CombatConfig.RewardId or 0
    self.CurMonsterTargets = CombatConfig.EntrustMonsters or {}
    self.CurCombatQuestChainId = CombatConfig.QuestChainId or 0

    local CacheName = "ZhiliuEvent_Task_ShowedCombat_"..self.CurDayIndex
    local CacheData = EMCache:Get(CacheName, true)
    self:SetTypeSwitchButtonState(true, not CacheData)

    local IsCombatCompleted = self:IsCombatCompleted(self.CurDayIndex)
    self:ShowCombatCompleted(IsCombatCompleted)
end

function M:ShowCombatCompleted(IsShow)
    if IsShow then
        self:PlayAnimation(self.Battle_Complete)
    else
        self:PlayAnimation(self.Battle_Complete, self.Battle_Complete:GetEndTime(), 1, UE4.EUMGSequencePlayMode.Reverse)
    end
end

function M:ShowSubmitCompleted(IsShow)
    if IsShow then
        self:PlayAnimation(self.Trade_Complete)
    else
        self:PlayAnimation(self.Trade_Complete, self.Trade_Complete:GetEndTime(), 1, UE4.EUMGSequencePlayMode.Reverse)
    end
end

function M:ShowCombatPanel()
    self.IsShowCombatPanel = true
    DebugPrint("ZhiliuEventTask:ShowCombatPanel", self.CurDayIndex)

    self:ShowListPanel(false)

    self.Text_DetailTitle:SetText(GText("ZhiLiuEntrust_Battle"))
    self.Text_MidDescText:SetText(GText(self.CurCombatText))
    self.Text_RewardTitle:SetText(GText("UI_GameEvent_EventPortal_RewardPreview"))
    self.Text_TradeTitle:SetText(GText("ZhiLiuEntrust_Objective"))

    self.WS_TitleIcon:SetActiveWidgetIndex(0)
    self.WS_DetailImg:SetActiveWidgetIndex(0)

    -- 初始化奖励列表
    self:InitRewardList()

    -- 初始化委托对象列表
    self.TradeItem:ClearListItems()
    for _, UnitId in pairs(self.CurMonsterTargets) do
        local MonsterInfo = DataMgr.Monster[UnitId]
        local MonsterGalleryInfo = DataMgr.GalleryRule[MonsterInfo.GalleryRuleId]
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Id = UnitId
        Content.ItemType = "Monster"
        -- Content.Rarity = MonsterInfo.Rarity
        Content.Icon = MonsterGalleryInfo.MonsterIcon
        Content.ParentWidget = self
        -- Content.IsShowDetails = true
        -- Content.UIName = self.WidgetName
        Content.NotInteractive = true
        self.TradeItem:AddItem(Content)
    end

    -- 初始化按钮
    local MainButtonNewState = self:GetMainButtonState_Combat()
    self.Btn_Trade["SetTaskBtn"..MainButtonNewState](self.Btn_Trade)

    -- 初始化"已完成"横幅
    local IsCompleted = self:IsCombatCompleted(self.CurDayIndex)
    self:ShowTargetCompleteBanner(IsCompleted)

    self:AddTimer(0.1, function()
        self:BP_GetDesiredFocusTarget():SetFocus()
        --self:FocusToCombatSubmitList()
    end)
end

-- 未接取任务链，点击接取，显示“接取”，状态"Normal"
-- 已接取任务链，不可点击，显示“进行中”，状态"Forbid"
-- 任务链完成，不可点击，显示“已完成”，状态"Complete"
function M:GetMainButtonState_Combat()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return "Normal"
    end
    local QuestChain = Avatar.QuestChains[self.CurCombatQuestChainId]
    if not QuestChain then
        ScreenPrint("配置了一个不存在的任务链Id！请策划检查！Id:"..self.CurCombatQuestChainId)
        return "Normal"
    end
    --if QuestChain:IsFinish() then
    if self:IsCombatCompleted(self.CurDayIndex) then    -- 这里用jiangshuai的接口判断吧
        return "Complete"
    end
    if QuestChain:IsDoing() then
        return "Forbid"
    end
    return "Normal"
end

function M:ShowSubmitPanel()
    self.IsShowCombatPanel = false
    DebugPrint("ZhiliuEventTask:ShowSubmitPanel", self.CurDayIndex)

    self.Text_DetailTitle:SetText(GText("ZhiLiuEntrust_Resource"))
    self.Text_MidDescText:SetText(GText(self.CurSubmitText))
    self.Text_RewardTitle:SetText(GText("UI_GameEvent_EventPortal_RewardPreview"))
    self.Text_TradeTitle:SetText(GText("ZhiLiuEntrust_Objective"))

    self.WS_TitleIcon:SetActiveWidgetIndex(1)
    self.WS_DetailImg:SetActiveWidgetIndex(1)

    -- 初始化奖励列表
    self:InitRewardList()

    -- 初始化按钮
    local MainButtonNewState = self:GetMainButtonState_Submit()
    self.Btn_Trade["SetTaskBtn"..MainButtonNewState](self.Btn_Trade)

    -- 初始化上传内容相关显示
    if self.CurSubmitType == 1 then
        self:InitSubmitContent_1()
    elseif self.CurSubmitType == 2 then
        self:InitSubmitContent_2()
    end

    -- 初始化"已完成"横幅
    local IsCompleted = self:IsSubmitCompleted(self.CurDayIndex)
    self:ShowTargetCompleteBanner(IsCompleted)

    self:AddTimer(0.1, function()
        self:BP_GetDesiredFocusTarget():SetFocus()
        --self:FocusToCombatSubmitList()
    end)
end

-- 提交方式1：自动提交，直接显示待提交的列表
function M:InitSubmitContent_1()
    self.CurSubmitInfoTable = {}        -- 统一处理后的数据，不用每次都读那个抽象表了 {ResourceId = resourceId，, CurCount = , NeedCount = }   注意到不要用id作为Key，否则会乱序
    local Avatar = GWorld:GetAvatar()
    for _, sometable in ipairs(self.CurSubmitNeeded) do
        for _ResourceId, _ in pairs(sometable) do
            local InfoTable = {
                ResourceId = _ResourceId,
                CurCount = 0,
                NeedCount = sometable[_ResourceId],
            }
            if Avatar and Avatar.Resources then
                local CountInBag = 0
                if Avatar.Resources[_ResourceId] then
                    CountInBag = tonumber(Avatar.Resources[_ResourceId].Props.Count)
                end
                InfoTable.CurCount = CountInBag
            end
            table.insert(self.CurSubmitInfoTable, InfoTable)
        end
    end

    self.PendingSubmitList = {}
    self.SubmitContentList = {}
    self.TradeItem:ClearListItems()
    for _, Info in pairs(self.CurSubmitInfoTable) do
        local ResourceId = Info.ResourceId
        local ResourceInfo = DataMgr.Resource[ResourceId]
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Id = ResourceId
        Content.ItemType = "Resource"
        Content.Rarity = ResourceInfo.Rarity
        Content.Icon = ResourceInfo.Icon
        Content.ParentWidget = self
        Content.Count = Info.CurCount
        Content.NeedCount = Info.NeedCount
        Content.IsShowDetails = true
        Content.UIName = self.WidgetName
        self.TradeItem:AddItem(Content)
        table.insert(self.PendingSubmitList, ResourceId)
        table.insert(self.SubmitContentList, Content)
    end
end

-- 提交方式2：手动提交，显示背包
function M:InitSubmitContent_2()
    self.TileView_Select_Role:ClearListItems()
    -- 这个之前也是用Id作为key的，功能暂时用不上，到时候要用了再改
    self.CurSubmitInfoTable = {}        -- 统一处理后的数据，不用每次都读那个抽象表了 key = resourceId， value = count
    local ConfigedResourceIds = {}      -- table 用来sort的时候优先判断，单独写是为了sort逻辑不那么抽象
    for _, sometable in ipairs(self.CurSubmitNeeded) do
        for ResourceId, _ in pairs(sometable) do
            self.CurSubmitInfoTable[ResourceId] = sometable[ResourceId]
            ConfigedResourceIds[ResourceId] = true
        end
    end

    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar.Resources then
        local AllResourceIds = CommonUtils.Keys(Avatar.Resources)

        table.sort(AllResourceIds, function(a, b)
            -- 优先显示策划配置的
            if ConfigedResourceIds[a] ~= ConfigedResourceIds[b] then
                return ConfigedResourceIds[a] or false
            end

            local ResourceInfoA = DataMgr.Resource[a]
            local ResourceInfoB = DataMgr.Resource[b]
            -- 显示MaterialClassify为3的资源
            if ResourceInfoA.MaterialClassify ~= ResourceInfoB.MaterialClassify then
                if ResourceInfoA.MaterialClassify == 3 then
                    return true
                end
                if ResourceInfoB.MaterialClassify == 3 then
                    return false
                end
            end
            -- 再按稀有度排序
            if ResourceInfoA.Rarity ~= ResourceInfoB.Rarity then
                return ResourceInfoA.Rarity > ResourceInfoB.Rarity
            end
            -- 最后按Id从小到大排序
            return a < b
        end)

        for _, ResourceId in ipairs(AllResourceIds) do
            local ResourceInfo = DataMgr.Resource[ResourceId]
            local Content = NewObject(UIUtils.GetCommonItemContentClass())
            Content.Id = ResourceId
            Content.ItemType = "Resource"
            Content.Rarity = ResourceInfo.Rarity
            Content.Icon = ResourceInfo.Icon
            Content.ParentWidget = self
            Content.Count = tonumber(Avatar.Resources[ResourceId].Props.Count)
            Content.OnMouseButtonUpEvents = {
                Obj = self,
                Callback = self.OnBagItemClicked,
                Params = table.pack(Content),
            }
            self.TileView_Select_Role:AddItem(Content)
        end
    end
    self.TileView_Select_Role:RequestFillEmptyContent()

    -- 初始化提交列表
    self.PendingSubmitList = {}     -- 待提交的ResourceId列表
    self.SubmitContentList = {}     -- 用来索引待提交的道具框
    self.SubmitContentIndex = 1     -- 触发点击背包事件，下一个可以用于更新的道具框index
    self.TradeItem:ClearListItems()
    for i = 1, self.CurSubmitListLen do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.bAdd = true
        Content.ParentWidget = self
        Content.OnMouseButtonUpEvents = {
            Obj = self,
            Callback = self.OnSubmitItemClicked,
            Params = table.pack(Content),
        }
        self.TradeItem:AddItem(Content)
        self.SubmitContentList[i] = Content
    end
end

function M:OnBagItemClicked(ItemContent)
    DebugPrint("ZhiliuEventTask:OnBagItemClicked", ItemContent.Id)
    -- 防止过多选中
    if #self.PendingSubmitList >= self.CurSubmitListLen then
        return
    end
    -- 防止重复选中
    if CommonUtils.HasValue(self.PendingSubmitList, ItemContent.Id) then
        return
    end

    local NeedNum = self.CurSubmitInfoTable[ItemContent.Id] or 1        -- 策划配置的，待提交ResourceId所需的数量
    local TotalNumInBag = ItemContent.Count                             -- 玩家背包里现存的Resource数量
    local SelectNum =  math.min(NeedNum, TotalNumInBag)                 -- 玩家可以提交的数量
    ItemContent.SelectNeedCount = SelectNum
    ItemContent.SelectTotalCount = TotalNumInBag
    ItemContent.SelfWidget:SetSelectNum(SelectNum, TotalNumInBag)

    -- 上面的ItemContent指背包List里的Content
    -- 下面的SubmitContent指待提交List里的Content
    if self.SubmitContentIndex > #self.SubmitContentList then
        ScreenPrint("ZhiliuEventTask:尝试加入待提交列表的内容大于可提交内容的长度！")
        return
    end
    local SubmitContent = self.SubmitContentList[self.SubmitContentIndex]
    SubmitContent.bAdd = false
    SubmitContent.Id = ItemContent.Id
    SubmitContent.ItemType = ItemContent.ItemType
    SubmitContent.Rarity = ItemContent.Rarity
    SubmitContent.Icon = ItemContent.Icon
    SubmitContent.Count = SelectNum
    SubmitContent.NeedCount  = NeedNum
    SubmitContent.SelfWidget:Init(SubmitContent)

    table.insert(self.PendingSubmitList, ItemContent.Id)

    -- 处理提交按钮是否可点击
    self.SubmitContentIndex = self.SubmitContentIndex + 1
    if self.SubmitContentIndex > #self.SubmitContentList then
        self.Btn_Trade:SetTaskBtnNormal()
    end
end

function M:OnSubmitItemClicked(ItemContent)
    DebugPrint("ZhiliuEventTask:OnSubmitItemClicked", ItemContent.Id)
    self:ShowListPanel(true)
    self.TileView_Select_Role:SetFocus()
end

function M:GetMainButtonState_Submit()
    if self:IsSubmitCompleted(self.CurDayIndex) then
        return "Complete"
    else
        return "Normal"
    end
end

function M:InitRewardList()
    local IsShowGot = false
    if self.IsShowCombatPanel then
        IsShowGot = self:IsCombatCompleted(self.CurDayIndex)
    else
        IsShowGot = self:IsSubmitCompleted(self.CurDayIndex)
    end

    self.RewardItem:ClearListItems()
    self.RewardContentList = {}     -- 用来索引奖励道具框
    local CurRewardId
    if self.IsShowCombatPanel then
        CurRewardId = self.CurCombatRewardId
    else
        CurRewardId = self.CurSubmitRewardId
    end
    local RewardInfo = DataMgr.Reward[CurRewardId]
    if RewardInfo then
        local RewardLen = #RewardInfo.Id
        for i = 1, RewardLen do
            local Id = RewardInfo.Id[i]
            local Type = RewardInfo.Type[i]
            local ResourceInfo = DataMgr[Type][Id]  -- 通常是从Resource表中获取
            local Content = NewObject(UIUtils.GetCommonItemContentClass())
            Content.Id = Id
            Content.ItemType = Type
            Content.Rarity = ResourceInfo.Rarity
            Content.Icon = ResourceInfo.Icon
            Content.ParentWidget = self
            Content.Count = RewardInfo.Count[i][1]
            Content.IsShowDetails = true
            Content.UIName = self.WidgetName
            Content.bHasGot = IsShowGot
            self.RewardItem:AddItem(Content)
            table.insert(self.RewardContentList, Content)
        end
    end
end

-- 显示或隐藏背包列表
function M:ShowListPanel(IsShow)
    if self.IsListPanelShow == IsShow then
        return
    end
    self.IsListPanelShow = IsShow

    if IsShow then
        self:PlayAnimation(self.List_In)
    else
        self:PlayAnimation(self.List_Out)
    end
end

-- 显示或隐藏提交预览框上方"已完成"的横幅
function M:ShowTargetCompleteBanner(IsShow)
    if IsShow then
        self.Group_Done:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        if self.IsShowCombatPanel then
            self.Text_Done:SetText(GText("UI_Entrust_Complete"))
        else
            self.Text_Done:SetText(GText("UI_Entrust_Submitted"))
        end
    else
        self.Group_Done:SetVisibility(ESlateVisibility.Collapsed)
    end
end

-- 初始化用于提交任务的主要按钮
function M:InitMainButton()
    self.Btn_Trade:InitTaskBtn(self)
end

function M:OnTaskMainBtnClicked()
    if self.IsShowCombatPanel then
        self:OnCombatMainBtnClicked()
    else
        self:OnSubmitMainBtnClicked()
    end
    AudioManager(self):PlayUISound(self, "event:/ui/activity/zhiliu_btn_accept", nil, nil)
end

function M:OnCombatMainBtnClicked()
    -- 做接取任务链的逻辑
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local QuestChain = Avatar.QuestChains[self.CurCombatQuestChainId]
    if not QuestChain then
        ScreenPrint("Zhiliu 配置了一个不存在的任务链Id！请策划检查！Id:"..self.CurCombatQuestChainId)
        return
    end
    if not DataMgr.QuestChain[self.CurCombatQuestChainId] then
        ScreenPrint("Zhiliu 该任务链Id不存在于QuestChain表中！Id:"..self.CurCombatQuestChainId)
        return
    end
    if QuestChain:IsDoing() or QuestChain:IsFinish() then
        ScreenPrint("Zhiliu 该任务链Id已经在进行中或已完成！Id:"..self.CurCombatQuestChainId)
        return
    end

    local cb = function(Ret)
        DebugPrint("ZhiliuEventTask:OnCombatMainBtnClickedCallback")
        self:BlockAllUIInput(false)
        if ErrorCode:Check(Ret) then
            self.Btn_Trade:SetTaskBtnForbid()
            PageJumpUtils:JumpToTargetPageByJumpId(23, self.CurCombatQuestChainId)
        end
    end
    self:BlockAllUIInput(true)
    DebugPrint("ZhiliuEventTask:OnCombatMainBtnClicked")
    Avatar:HandleQuestChainDoing(self.CurCombatQuestChainId, cb)
end

function M:OnSubmitMainBtnClicked()
    -- 做上报服务端的逻辑
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    DebugPrint("ZhiliuEventTask:OnSubmitMainBtnClicked")
    PrintTable(self.PendingSubmitList)

    local cb = function(ErrCode, RewardBox)
        DebugPrint("ZhiliuEventTask:OnSubmitMainBtnClickedCallback")
        if ErrorCode:Check(ErrCode) then
            self:OnSubmitSucceed(RewardBox, self.CurDayIndex)
        else
            self:CheckSubmitItemAndSetRed()
        end
        -- 这个方法也会SetFocus到该界面，导致后续Load奖励UI时，不会Focus到奖励UI上。改下执行顺序，先Focus奖励UI能解决这个问题（先这样
        self:BlockAllUIInput(false)
    end
    self:BlockAllUIInput(true)
    Avatar:RpcZhiLiuEntrustSubmitResource(self.CurDayIndex, self.PendingSubmitList, cb)
end

-- 提交任务成功，回调处理
function M:OnSubmitSucceed(RewardBox, DayIndex)
    -- 弹出奖励界面
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, RewardBox, false, nil, self)
    -- 主按钮设为完成
    self.Btn_Trade:StopAnimation(self.Btn_Trade.Click)
    self:AddTimer(0.1, function()
        self.Btn_Trade:PlayAnimation(self.Btn_Trade.Click, self.Btn_Trade.Click:GetEndTime())
        self.Btn_Trade:SetTaskBtnComplete()
    end)
    -- 右侧切换按钮设为完成
    self:ShowSubmitCompleted(true)
    -- 如果战斗任务已完成，当前日期tab设为完成，并且尝试解锁下一个日期
    if self:IsCombatCompleted(DayIndex) then
        self["Tab_"..DayIndex]:SetCompleted()
        local IsNextDayTabTimeSatisified = false
        if DayIndex + 1 <= self.ZhiliuTotalDayNum then
            IsNextDayTabTimeSatisified = self:IsTimeSatisfied(DayIndex + 1)
        end
        local NextDayTab = self["Tab_"..(DayIndex+1)]
        if IsNextDayTabTimeSatisified and NextDayTab then
            NextDayTab.IsLocked = false
            NextDayTab:SetNormal()
        end
    end
    -- 奖励列表设为已领取
    for _, RewardContent in pairs(self.RewardContentList) do
        if IsValid(RewardContent) then
            RewardContent.SelfWidget:SetIsGot(true)
        end
    end
    -- 显示"已完成"横幅
    self:ShowTargetCompleteBanner(true)
    -- 刷新下进度界面
    self:UpdateRewardProgress()
end

function M:CheckSubmitItemAndSetRed()
    -- 这里的OuterItem指的是外部包的那一层Widget，而非通用道具框
    local OuterItems = self.TradeItem:GetDisplayedEntryWidgets()
    for i, Item in pairs(OuterItems) do
        local SubmitContent = self.SubmitContentList[i]
        if IsValid(SubmitContent) then
            local ResourceId = SubmitContent.Id
            if not self.CurSubmitInfoTable[i] then
                Item:PlayAnimation(Item.Warning)
            elseif SubmitContent.Count < SubmitContent.NeedCount then
                Item:PlayAnimation(Item.Warning)
            end
        end
    end
end

-- 初始化设置Tab信息
function M:InitTabs()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        local ConfigData = {
            PlatformName = "PC",
            DynamicNode={
                "Back",
                "ResourceBar",
                "Tip",
            },
            TitleName = GText(DataMgr.EventMain[self.ZhiliuEventId].EventName),
            OwnerPanel = self,
            BackCallback = self.Close,
        }
        self.Com_Tab_P:Init(ConfigData, false)
        -- 有点抽象，不该在外部设置通用按钮内部的属性，先这样吧
        if self.Com_Tab_P.Com_KeyTips then
            self.Com_Tab_P.Com_KeyTips:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        -- 移到手柄显示里去了
        -- self.Com_KeyTips:UpdateKeyInfo({
        --     {
        --         KeyInfoList = {{Type="Text", Text="ESC"}},
        --         Desc = GText("UI_BACK"),
        --     },
        -- })
    elseif CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        local ConfigData = {
            PlatformName = "Mobile",
            DynamicNode={
                "Back",
                "ResourceBar",
                "Tip",
            },
            TitleName = GText(DataMgr.EventMain[self.ZhiliuEventId].EventName),
            OwnerPanel = self,
            BackCallback = self.Close,
        }
        self.Com_Tab_M:Init(ConfigData, false)
    end
end

--function M:Initialize(Initializer)
--end

function M:Construct()
    M.Super.Construct(self)
    self.TileView_Select_Role.OnCreateEmptyContent:Bind(self, function(self)
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Conf = nil
        Content.IsSelected = false
        Content.Parent = self
        return Content
    end)
end

function M:Destruct()
    self.TileView_Select_Role.OnCreateEmptyContent:Unbind()
    M.Super.Destruct(self)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:InitInputDeviceInfo()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end

    -- 通常不需要(基类做过了)，加个保底
    if not self.GameInputModeSubsystem then
        local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
        self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    end

    -- 初始化手柄按钮
    -- 每日Tab切换图标
    self.Key_TabLeft:CreateCommonKey({KeyInfoList = {{Type = "Img", ImgShortPath = "LB"}}})
    self.Key_TabRight:CreateCommonKey({KeyInfoList = {{Type = "Img", ImgShortPath = "RB"}}})
    -- 类型切换图标
    self.Key_ControllerBattle:CreateCommonKey({KeyInfoList = {{Type = "Img", ImgShortPath = "Up"}}})
    self.Key_ControllerTrade:CreateCommonKey({KeyInfoList = {{Type = "Img", ImgShortPath = "Down"}}})
    -- 奖励点击图标
    self.Key_RewardTitle:CreateCommonKey({KeyInfoList = {{Type = "Img", ImgShortPath = "LS"}}})
    -- 主按钮点击图标
    self.Btn_Trade.Key_Controller:CreateCommonKey({KeyInfoList = {{Type = "Img", ImgShortPath = "Y"}}})
    -- 商店点击图标
    self.Key_Shop:CreateCommonKey({KeyInfoList = {{Type = "Img", ImgShortPath = "Left"}}})
    -- 奖励领取图标
    self.Key_TaskProgress:CreateCommonKey({KeyInfoList = {{Type = "Img", ImgShortPath = "Menu"}}})

    self:OnUpdateUIStyleByInputTypeChange(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end

    if CurInputDevice == ECommonInputType.MouseAndKeyboard then
        self:ShowMouseAndKeyboardView()
    elseif CurInputDevice == ECommonInputType.Gamepad then
        self:ShowGamepadView()
    end
end

function M:ShowMouseAndKeyboardView()
    -- 隐藏每日Tab切换图标
    self.Key_TabLeft:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Key_TabRight:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- 隐藏类型切换图标
    self.Key_ControllerBattle:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Key_ControllerTrade:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- 隐藏奖励点击图标
    self.Key_RewardTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- 隐藏主按钮点击图标
    self.Btn_Trade.Key_Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- 隐藏商店点击图标
    self.Key_Shop:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- 隐藏奖励领取图标
    self.Key_TaskProgress:SetVisibility(UE4.ESlateVisibility.Collapsed)

    -- 更新最下方tips显示
    self:UpdateBottomTabTips("MouseAndKeyboard")
end

function M:ShowGamepadView()
    -- 显示每日Tab切换图标
    self.Key_TabLeft:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Key_TabRight:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- 显示类型切换图标
    self.Key_ControllerBattle:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Key_ControllerTrade:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- 显示奖励点击图标
    self.Key_RewardTitle:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- 显示主按钮点击图标
    self.Btn_Trade.Key_Controller:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Trade.Key_Controller:SetForbidKey(self.Btn_Trade.CurState ~= "Normal")
    -- 显示商店点击图标
    self.Key_Shop:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- 显示奖励领取图标
    self.Key_TaskProgress:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

    -- RefreshOpInfoByInputDevice不要主动做聚焦，需要聚焦的放到BP_GetDesiredFocusTarget
    --self:FocusToCombatSubmitList()

    -- 更新最下方tips显示
    self:UpdateBottomTabTips("Gamepad")
end

function M:UpdateBottomTabTips(InputType)
    if InputType == "MouseAndKeyboard" then
        self.Com_KeyTips:UpdateKeyInfo({
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=function()
                    self:Close()
                end}},
                Desc = GText("UI_BACK"),
            },
        })
    elseif InputType == "Gamepad" then
        self.Com_KeyTips:UpdateKeyInfo({
            {
                KeyInfoList = {{Type="Img", ImgShortPath="A"}},
                Desc = GText("UI_Tips_Ensure"),
            },
            {
                KeyInfoList = {{Type="Img", ImgShortPath="B"}},
                Desc = GText("UI_BACK"),
            },
        })
    end
end

-- 统一接口，聚焦到最下方的委托对象列表
function M:FocusToCombatSubmitList()
    self.TradeItem:SetFocus()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    DebugPrint("ZhiliuEventTask:OnKeyDown", InKeyName)
    if InKeyName == Const.GamepadLeftThumbstick then
        self:SwitchFocusRewardList()
    elseif InKeyName == Const.GamepadRightShoulder then
        self:DaySwitchBtnMoveRight(1)
    elseif InKeyName == Const.GamepadLeftShoulder then
        self:DaySwitchBtnMoveRight(-1)
    elseif InKeyName == Const.GamepadFaceButtonUp then
        self.Btn_Trade:OnClickedEvent()
    elseif InKeyName == Const.GamepadFaceButtonRight then
        self:Close()
    elseif InKeyName ==Const.GamepadSpecialRight then
        self:OnClicked_RewardBtn()
    end
    return M.Super.OnKeyDown(self, MyGeometry, InKeyEvent)
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = false
    DebugPrint("ZhiliuEventTask:OnPreviewKeyDown", InKeyName)
    if InKeyName == Const.GamepadDPadUp then
        IsHandled = true
        self:OnClicked_CombatTab()
    elseif InKeyName == Const.GamepadDPadDown then
        IsHandled = true
        self:OnClicked_SubmitTab()
    elseif InKeyName == Const.GamepadDPadLeft then
        IsHandled = true
        self:OnClicked_Shop()
    end

    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

-- 切换聚焦奖励列表
function M:SwitchFocusRewardList()
    if not self.IsFocusRewardList then
        self.RewardItem:SetFocus()
        self.IsFocusRewardList = true
    else
        self:FocusToCombatSubmitList()
        self.IsFocusRewardList = false
    end
end

-- 向右切换每日列表(传入负数则向左)
function M:DaySwitchBtnMoveRight(Value)
    if not self.CurDayIndex then
        return
    end
    local NewDayIndex = self.CurDayIndex + Value
    local NewActiveTab = self["Tab_"..NewDayIndex]
    if not NewActiveTab then
        return
    end
    NewActiveTab:OnClickedEvent()
end

function M:BP_GetDesiredFocusTarget()
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local ShopMainPage = UIManager:GetUIObj("ActivityShop")
    if ShopMainPage then
        return ShopMainPage.List_Item
    end
    if self.IsFocusRewardList then
        return self.RewardItem
    else
        return self.TradeItem
    end
end

return M
