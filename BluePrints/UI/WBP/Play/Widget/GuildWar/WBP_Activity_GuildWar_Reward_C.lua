--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_GuildWar_Reward_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    M.Super.Construct(self)
    self.Title.Text_Title:SetText(GText("UI_Event_MidTerm_GotoPreview"))
    self.Title.BtnClose.Btn_Close.OnClicked:Add(self,function ()
        if not self:IsAnimationPlaying(self.Out) then
            self:PlayAnimation(self.Out)
        end     
    end)
    self.List_Reward:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    self.List_Reward:SetNavigationRuleBase(EUINavigation.Up,EUINavigationRule.Stop)
    --self.List_Prop:SetNavigationRuleExplicit(EUINavigation.Up, self.WB_Event:GetChildAt(0))
    self.List_Reward:SetNavigationRuleBase(EUINavigation.Left,EUINavigationRule.Stop)
    self.List_Reward:SetNavigationRuleBase(EUINavigation.Right,EUINavigationRule.Stop)
    self:AddInputMethodChangedListen()
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:Init()

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    self.Text_Group:SetText(GText("RaidDungeon_Rank_Tier"))
    self.Text_Score:SetText(GText("RaidDungeon_Rank_Percentage"))
    self.Text_Reward:SetText(GText("RaidDungeon_Rank_Reward"))
    local CurrentRaidSeasonId = Avatar.CurrentRaidSeasonId
    local RaidSeasons = Avatar.RaidSeasons[CurrentRaidSeasonId]
    local RaidSeasonData = DataMgr.RaidSeason[RaidSeasons.RaidSeasonId]

    local PreRaidRankData = DataMgr.PreRaidRank[RaidSeasonData.PreRaidRank]
    if not PreRaidRankData then
        DebugPrint("[WBP_Activity_GuildWar_Reward_C] 找不到对应的 PreRaidRankData:", RaidSeasonData.PreRaidRank)
        return
    end
    self.List_Reward:ClearListItems()
    local RankPercentArr = PreRaidRankData.RankPercent or {}
    local RankNameArr = PreRaidRankData.RankName or {}
    local RankRewardArr = PreRaidRankData.RankReward or {}

    for i, RankPercent in ipairs(RankPercentArr) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())

        Content.Parent = self
        -- 分段文本
        if i == 1 then
            Content.RankPercent = RankPercent.."%"
        else
            local prev = RankPercentArr[i - 1]
            Content.RankPercent = string.format("%d%%-%d%%", prev, RankPercent)
        end

        -- 名称和奖励
        local RankName = RankNameArr[i]
        local RankReward = RankRewardArr[i]
        if RankName then
            Content.RankName = i
        end

        if RankReward then
            Content.RankReward = RankReward
        end

        self.List_Reward:AddItem(Content)
    end

    -- self:AddTimer(0.01, function()
    --     local ItemUIs = self.List_Reward:GetDisplayedEntryWidgets()
    --     local RestCount = UIUtils.GetListViewContentMaxCount(self.List_Reward, ItemUIs, true) -
    --         ItemUIs:Length()
    --         if RestCount >= 0 then

    --         end
    --     --self.List_Reward:ScrollToTop()
    -- end, false, 0, "DeputeNightBook_TabItemListView")

    self.List_Reward:NavigateToIndex(0)
    self:PlayAnimation(self.In)

    self:RefreshControllerUI()
end

function M:RefreshControllerUI()
    local isGamepad = (UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad)

    if not isGamepad then
        -- 非手柄：隐藏手柄区域
        self.WBox_Controller:SetVisibility(ESlateVisibility.Collapsed)
        return
    end

    -- 手柄模式：显示手柄区域
    self.WBox_Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)

    self.Key_CheckReward:SetVisibility(ESlateVisibility.Collapsed)
    self.Key_Check:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Key_Check:CreateCommonKey({
        KeyInfoList = {
            { Type = "Img", ImgShortPath = "LS" }
        },
        Desc = GText("UI_Controller_Check")
    })

    self.Key_Close:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Key_Close:CreateCommonKey({
        KeyInfoList = {
            { Type = "Img", ImgShortPath = "B" }
        },
        Desc = GText("UI_BACK")
    })
end

function M:OnReturnKeyDown()
    AudioManager(self):SetEventSoundParam(self, "Play_DeputeDetail", {ToEnd = 1})
    self.Super.Close(self)
    local Item = UIManager(self):GetUIObj("GuildWarLevel")
    local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
    if Item then
        Item:SelectCellFocus()
    elseif ActivityMain then
        ActivityMain:SetFocus()  -- 活动主页聚焦
    end
    -- if not self:IsAnimationPlaying(self.Out) then
    --     self:SetVisibility(ESlateVisibility.HitTestInvisible)
    --     self:PlayAnimation(self.Out) 
    -- end
end

function M:OnAnimationFinished(InAnimation)
    -- self:PlayAnimation(self.Out)
    if InAnimation == self.Out then
        self:OnReturnKeyDown()
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == "Escape" and not self:IsAnimationPlaying(self.Out) then 
        self:PlayAnimation(self.Out)
        --self:OnReturnKeyDown()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 输入设备切换通知
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if not IsUseKeyAndMouse and (self:HasFocusedDescendants() or self:HasAnyUserFocus()) then
        self.List_Reward:NavigateToIndex(0)
    end

    self:RefreshControllerUI()
    -- if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    --     self.WBox_Controller:SetVisibility(ESlateVisibility.Collapsed)
    -- else
    --     self.WBox_Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    -- end
end

-- function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
--     local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
--     local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
--     if (InKeyName == "Gamepad_RightY") then
--         local a = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 0.5
--         local CurScrollOffset = self.List_Drop:GetScrollOffset()
--         self.List_Reward:SetScrollOffset(CurScrollOffset + a)
--     end
--     return UWidgetBlueprintLibrary.Unhandled()
-- end




return M
