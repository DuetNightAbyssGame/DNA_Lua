--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local BagGameModel = require "BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameModel"
local BagGameController = require "BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameController"
local TimeUtils = require "Utils.TimeUtils"

---@type WBP_Activity_BagGameMain_P_C
local M = Class({"BluePrints.UI.BP_UIState_C",})
M._components = {
    "BluePrints.UI.WBP.Activity.Widget.BagGame.WBP_Activity_BagGameMain_Base_C_GamepadComp",
}
local BagGamePlayBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/Widget/BagGame/WBP_Activity_BagGame_Play.WBP_Activity_BagGame_Play'"
local FIXED_SELECT_POSITION = 4     -- 固定选中位置：列表中第5个可见位置（索引4），即居中
---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    M.Super.Construct(self)
    self.WBP_Btn_Begin.Button_Area.OnClicked:Add(self, self.OnBeginBtnClicked)
    self.Wrap_Normal_L.OnListViewScrolled:Add(self, self._OnListItemScrolled)
    self.Wrap_Normal_L.OnMouseButtonUp:Add(self, self.OnListItemReleased)

    -- self.Wrap_Normal_L.bIsShowNavigateGuide = false
    -- 初始化选中相关变量
    self.CurrentSelectedContent = nil  -- 当前选中的item内容
    self.CurrentSelectedIndex = nil  -- 当前选中的item索引
    self.LastSelectedEntry = nil  -- 记录上一个选中的Entry Widget
    self.LastSelectedIndex = nil  -- 上一次选中的索引
    self.LastSelectedContentId = nil  -- 上一次选中的内容Id
    -- 列表相关变量
    self.OriginalDataList = {}  -- 原始数据列表
    self.OriginalDataCount = 0  -- 原始数据数量（不包括占位格子）
    self.bIsScrollingToTarget = false  -- 是否正在滚动到目标位置
    self.Text_Title02:SetText(GText("UI_BackpackPuzzle_BackgroundPosition"))
    self.Text_Rule:SetText(GText("UI_GameEvent_BagGame_LevelDes"))
    self.Text_Score:SetText(GText("UI_BackpackPuzzle_HighestScore"))
    self.WBP_Btn_Begin.Text_Button:SetText(GText("UI_BackpackPuzzle_StartGame"))
    self._ViewedLevelIds = nil
    self.BeginKey = self.WBP_Btn_Begin.Key_GamePad
    self:InitListenEvent()
    self:RefreshBaseInfo()
end

function M:Destruct()
    self.Wrap_Normal_L.OnListViewScrolled:Remove(self, self._OnListItemScrolled)
    self.Wrap_Normal_L.OnMouseButtonUp:Remove(self, self.OnListItemReleased)
    self._ViewedLevelIds = nil

    M.Super.Destruct(self)
end

function M:InitUIInfo(Name, IsInUIMode, EventList, Params)
    self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, Params)
    self._Avatar = GWorld:GetAvatar()

    self:InitMainTab()
    self.Btn_Arward:Init()
    self:InitLevelList()
    self:PlayAnimation(self.In)
    self:SetFocus()
    
    -- 初始化列表滚动缩放效果
    self:InitScrollEffect()
    
    local CurInputDevice = UIUtils.UtilsGetCurrentInputType()
    self:InitGamePadKey()
    -- self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
end

function M:OnBeginBtnClicked()
    -- 检查是否有选中的Content
    if not self.CurrentSelectedContent then
        print("警告：未选中任何关卡")
        return
    end

    local bCanBegin = self:IsSelectedLevelUnlockedByPrerequisite(self.CurrentSelectedContent) and
        (self:GetSelectedLevelRemainUnlockSeconds(self.CurrentSelectedContent) <= 0)
    if not bCanBegin then
        return
    end
    
    local LevelId = self.CurrentSelectedContent.LevelId
    local TargetScoreMax = BagGameModel:GetLevelMaxTargetScore(LevelId)
    print("开始游戏 - 关卡ID:", LevelId, 
          ", 标题:", self.CurrentSelectedContent.LevelName,
          ", 最高目标分:", TargetScoreMax)
    
    -- 通过 Controller 打开游戏界面
    BagGameController:OpenPlayUI(LevelId, self.CurrentSelectedContent, self)
end

--- 滚动到前一个关卡
function M:ScrollToPreviousItem()
    if self.bIsScrollingToTarget then return end
    local CurrentRealIndex = self:GetCurrentRealLevelIndex()
    if CurrentRealIndex <= 0 then return end  -- 已在第一关
    self:ScrollToRealIndex(CurrentRealIndex - 1)
end

--- 滚动到后一个关卡
function M:ScrollToNextItem()
    if self.bIsScrollingToTarget then return end
    local CurrentRealIndex = self:GetCurrentRealLevelIndex()
    if CurrentRealIndex >= self.OriginalDataCount - 1 then return end  -- 已在最后一关
    self:ScrollToRealIndex(CurrentRealIndex + 1)
end

--- 滚动到指定真实关卡索引（0-based）
--- 列表结构: [占位×N] [真实关卡×M] [占位×N]
--- 当 ScrollOffset = RealIndex 时，真实关卡 RealIndex 正好位于固定选中位置
---@param RealIndex number 真实关卡索引（0-based）
function M:ScrollToRealIndex(RealIndex)
    self.bIsScrollingToTarget = true
    
    -- 限制到有效范围
    if RealIndex < 0 then RealIndex = 0 end
    if RealIndex > self.OriginalDataCount - 1 then RealIndex = self.OriginalDataCount - 1 end
    
    self.Wrap_Normal_L:SetScrollOffset(RealIndex)
    
    self:AddTimer(0.05, function()
        self.bIsScrollingToTarget = false
        self:UpdateSelectedItem()
        self:UpdateArrowButtons()
    end, false)
end

--- 获取当前选中的真实关卡索引（0-based）
--- ScrollOffset 取整后即为真实关卡索引
---@return number 当前真实关卡索引
function M:GetCurrentRealLevelIndex()
    local ScrollOffset = self.Wrap_Normal_L:GetScrollOffset()
    local RealIndex = math.floor(ScrollOffset + 0.5)
    if RealIndex < 0 then RealIndex = 0 end
    if self.OriginalDataCount > 0 and RealIndex > self.OriginalDataCount - 1 then
        RealIndex = self.OriginalDataCount - 1
    end
    return RealIndex
end

function M:InitMainTab()
    self.Tab:Init({
        Tabs = self.Tabs,
        DynamicNode={"Back" ,"BottomKey"},
        BottomKeyInfo = {
            {GamePadInfoList = {{Type="Or"},GamePadSubKeyInfoList = {{Type="Img", ImgShortPath="LB"}, {Type="Img", ImgShortPath="RB"}}},
            Desc = GText("切换关卡"), bLongPress = false},
            {KeyInfoList = {{Type="Text", Text="Escape", ClickCallback=self.CloseSelf, Owner=self}},
            GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseSelf}},
            Desc = GText("UI_BACK"), bLongPress = false}
        },
        OwnerPanel = self,
        BackCallback = self.CloseSelf,
        StyleName = "TextImage",
        TitleName = GText("Event_Title_103015"),
    })
end

function M:UpdateInfoTips(Content)
    self.Text_Title01:SetText(GText(Content.LevelName))
    self.Text_Message01:SetText(GText(Content.LevelDes))
    
    local LevelId = Content.LevelId
    -- 未通关显示0，已通关（至少1星）显示玩家最高结算分
    local StarCount = BagGameModel:GetPlayerStarCount(LevelId)
    local DisplayScore = StarCount > 0 and BagGameModel:GetPlayerFinishScore(LevelId) or 0
    self.Text_Score_Num:SetText(DisplayScore)
    
    -- 使用 Model 获取玩家星数
    local FinishCount = BagGameModel:GetPlayerStarCount(LevelId)
    local TotalStars = Content.TargetScore and #Content.TargetScore or 0
    
    -- 更新星星显示
    if Content.TargetScore then
        local PlayerScore = Content.PlayerScore or 0
        for i, TargetScore in ipairs(Content.TargetScore) do
            local IsFinish = PlayerScore >= TargetScore
            if IsFinish then
                self["ScoreItem0"..i].WS_Type:SetActiveWidgetIndex(1)
                self["ScoreItem0"..i].Text_ScoreInfo_Star:SetText(string.format(GText("UI_BackpackPuzzle_Target"..i), TargetScore))
            else
                self["ScoreItem0"..i].WS_Type:SetActiveWidgetIndex(0)
                self["ScoreItem0"..i].Text_ScoreInfo_Empty:SetText(string.format(GText("UI_BackpackPuzzle_Target"..i), TargetScore))
            end
        end
    end
    self.Text_Target:SetText(string.format(GText("UI_BackpackPuzzle_TargetScore").." (%d/%d)", FinishCount, TotalStars))
    self:RefreshBeginButtonText()
end

--- 设置开始按钮文本（兼容按钮封装与直设文本）
---@param TextValue string
function M:SetBeginButtonText(TextValue)
    if self.WBP_Btn_Begin and self.WBP_Btn_Begin.SetText then
        self.WBP_Btn_Begin:SetText(TextValue)
    elseif self.WBP_Btn_Begin and self.WBP_Btn_Begin.Text_Button then
        self.WBP_Btn_Begin.Text_Button:SetText(TextValue)
    end
end

--- 判断选中关卡是否满足前置关卡解锁
---@param Content table
---@return boolean
function M:IsSelectedLevelUnlockedByPrerequisite(Content)
    if not Content or not Content.Id or Content.Id <= 1 then
        return true
    end
    if not self.OriginalDataList then
        return true
    end

    local PrevInfo = self.OriginalDataList[Content.Id - 1]
    if not PrevInfo then
        return true
    end
    return BagGameModel:GetPlayerStarCount(PrevInfo.LevelId) > 0
end

--- 规范化 UnlockDate 为时间戳（秒）
---@param UnlockDate any
---@return number
function M:NormalizeUnlockTimestamp(UnlockDate)
    if UnlockDate == nil then
        return 0
    end
    if type(UnlockDate) == "number" then
        return math.floor(UnlockDate)
    end
    if type(UnlockDate) == "string" then
        return math.floor(tonumber(UnlockDate) or 0)
    end
    if type(UnlockDate) == "table" and UnlockDate.GetTime then
        return math.floor(UnlockDate:GetTime() or 0)
    end
    return 0
end

--- 获取关卡剩余解锁时间（秒）
---@param Content table
---@return number
function M:GetSelectedLevelRemainUnlockSeconds(Content)
    if not Content then
        return 0
    end
    local UnlockTs = self:NormalizeUnlockTimestamp(Content.UnlockDate)
    if UnlockTs <= 0 then
        return 0
    end
    local NowTs = TimeUtils.NowTime()
    return math.max(0, UnlockTs - NowTs)
end

---@param Seconds number
---@return string
function M:FormatUnlockCountdownText(Seconds)
    local Total = math.max(0, math.floor(Seconds or 0))
    local Hour = math.floor(Total / 3600)
    local Minute = math.floor((Total % 3600) / 60)
    local Second = Total % 60
    return string.format(GText("UI_GameEvent_BagGame_LockDes_Time").." %02d:%02d:%02d", Hour, Minute, Second)
end

--- 根据前置与时间条件刷新开始按钮文案
function M:RefreshBeginButtonText()
    if not self.CurrentSelectedContent then
        self:SetBeginButtonText(GText("UI_BackpackPuzzle_StartGame"))
        return
    end

    if not self:IsSelectedLevelUnlockedByPrerequisite(self.CurrentSelectedContent) then
        self:SetBeginButtonText("UI_GameEvent_BagGame_LockDes_PerviousLevel")
        return
    end

    local RemainSeconds = self:GetSelectedLevelRemainUnlockSeconds(self.CurrentSelectedContent)
    if RemainSeconds > 0 then
        self:SetBeginButtonText(self:FormatUnlockCountdownText(RemainSeconds))
        return
    end

    self:SetBeginButtonText(GText("UI_BackpackPuzzle_StartGame"))
end

function M:InitLevelList()
    self.LevelList = {}
    local LevelsInfo = BagGameModel:GetLevelsInfo()
    self.OriginalDataList = LevelsInfo
    self.OriginalDataCount = #LevelsInfo
    
    self.Wrap_Normal_L:ClearListItems()
    
    -- 添加左侧占位格子（FIXED_SELECT_POSITION 个，使第一关可以居中显示）
    for i = 1, FIXED_SELECT_POSITION do
        local Placeholder = NewObject(UIUtils.GetCommonItemContentClass())
        Placeholder.Owner = self
        Placeholder.IsPlaceholder = true
        Placeholder.Index = -i
        self.Wrap_Normal_L:AddItem(Placeholder)
    end
    
    -- 添加真实关卡数据
    for DataIndex, Info in ipairs(LevelsInfo) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Owner = self
        
        -- 使用 Model 构建 Content 数据
        local LevelContent = BagGameModel:BuildLevelListContent(Info, DataIndex)
        for Key, Value in pairs(LevelContent) do
            Content[Key] = Value
        end
        
        Content.Index = DataIndex - 1  -- 真实索引（0-based）
        Content.RealDataIndex = DataIndex - 1
        Content.IsPlaceholder = false
        Content.PlayerScore = BagGameModel:GetPlayerFinishScore(Info.LevelId)
        
        self.Wrap_Normal_L:AddItem(Content)
    end
    
    -- 添加右侧占位格子（FIXED_SELECT_POSITION 个，使最后一关可以居中显示）
    for i = 1, 8 do
        local Placeholder = NewObject(UIUtils.GetCommonItemContentClass())
        Placeholder.Owner = self
        Placeholder.IsPlaceholder = true
        Placeholder.Index = self.OriginalDataCount + i - 1
        self.Wrap_Normal_L:AddItem(Placeholder)
    end
    
    -- self.Wrap_Normal_L:RequestFillEmptyContent()
    self.Wrap_Normal_L:RequestPlayEntriesAnim()

    -- 列表构建完毕后刷新 BagGameNew 红点
    self:_TryRefreshBagGameNewReddot()
end

--- 从 Play 返回后刷新关卡列表，并按现有选中规则重新定位
---@param PreferLevelId number|nil 兼容参数（当前不使用，统一按规则选中）
function M:RefreshLevelListAfterPlay(PreferLevelId)
    self._bIsAutoSelecting = true
    self:InitLevelList()

    -- 与 InitScrollEffect 保持一致的规则：
    -- 1. 最低未首通；2. 最高已首通；3. 默认第一关
    local TargetRealIndex = nil
    local UncompletedIndex = self:FindFirstUncompletedLevelIndex()
    if UncompletedIndex ~= nil then
        TargetRealIndex = UncompletedIndex
    else
        local HighestIndex = self:FindHighestCompletedLevelIndex()
        if HighestIndex ~= nil then
            TargetRealIndex = HighestIndex
        else
            TargetRealIndex = 0
        end
    end

    self:AddTimer(0.05, function()
        self:ScrollToRealIndex(TargetRealIndex)
        self:AddTimer(0.1, function()
            -- 列表重建后需重置选中缓存，否则同索引不会重新触发选中逻辑
            self.CurrentSelectedIndex = nil
            self.CurrentSelectedContent = nil
            self.LastSelectedEntry = nil
            self.LastSelectedIndex = nil
            self.LastSelectedContentId = nil
            self:UpdateSelectedItem()
            self:UpdateArrowButtons()
            self._bIsAutoSelecting = false
        end, false)
    end, false)
end

--region 列表选中逻辑
--- 检查关卡是否首通完成（完成第一个目标分数）
---@param LevelInfo table 关卡信息
---@return boolean 是否首通完成
function M:IsLevelFirstClearCompleted(LevelInfo)
    if not LevelInfo or not LevelInfo.TargetScore or #LevelInfo.TargetScore == 0 then
        return false
    end
    
    local FirstTargetScore = LevelInfo.TargetScore[1]
    local PlayerScore = BagGameModel:GetPlayerFinishScore(LevelInfo.LevelId)

    return PlayerScore >= FirstTargetScore
end

--- 查找未完成首通的最低关卡索引
---@return number|nil 关卡索引（0-based），如果没有则返回nil
function M:FindFirstUncompletedLevelIndex()
    for Index, LevelInfo in ipairs(self.OriginalDataList) do
        if not self:IsLevelFirstClearCompleted(LevelInfo) then
            return Index - 1  -- 转换为0-based索引
        end
    end
    return nil
end

--- 查找已首通的最高关卡索引
---@return number|nil 关卡索引（0-based），如果没有则返回nil
function M:FindHighestCompletedLevelIndex()
    local HighestIndex = nil
    for Index, LevelInfo in ipairs(self.OriginalDataList) do
        if self:IsLevelFirstClearCompleted(LevelInfo) then
            HighestIndex = Index - 1  -- 转换为0-based索引
        else
            break  -- 找到第一个未完成的，停止
        end
    end
    return HighestIndex
end

--- 初始化定位与选中效果
--- 定位规则：
--- 1. 若存在未完成首通关卡，定位至最低的那个
--- 2. 若所有关卡已首通，定位至最高已首通关卡
--- 3. 默认定位至第一关
function M:InitScrollEffect()
    self._bIsAutoSelecting = true
    self:AddTimer(0.1, function()
        local TargetRealIndex = nil
        
        -- 1. 优先查找未完成首通的最低关卡
        local UncompletedIndex = self:FindFirstUncompletedLevelIndex()
        if UncompletedIndex ~= nil then
            TargetRealIndex = UncompletedIndex
            print("初始化定位：未完成首通关卡，真实索引:", TargetRealIndex)
        else
            -- 2. 所有关卡已首通，定位到最高已首通关卡
            local HighestIndex = self:FindHighestCompletedLevelIndex()
            if HighestIndex ~= nil then
                TargetRealIndex = HighestIndex
                print("初始化定位：最高已首通关卡，真实索引:", TargetRealIndex)
            else
                -- 3. 默认定位到第一关
                TargetRealIndex = 0
                print("初始化定位：默认第一关")
            end
        end
        
        -- 滚动到目标位置
        self:ScrollToRealIndex(TargetRealIndex)
        
        self:AddTimer(0.15, function()
            -- 强制刷新列表布局，确保 widget 已准备好
            self.Wrap_Normal_L:ForceLayoutPrepass()
            
            -- 重置选中状态
            self.CurrentSelectedIndex = nil
            self.LastSelectedEntry = nil
            self.LastSelectedIndex = nil
            self.LastSelectedContentId = nil
            
            self:UpdateSelectedItem()
            self:UpdateArrowButtons()
            self._bIsAutoSelecting = false
        end)
    end)
end
function M:OnListItemReleased()
    self:SnapToNearestItem()
end

--- 获取当前在固定选中位置的列表索引
--- 列表结构: [占位×N] [真实关卡×M] [占位×N]，真实关卡从索引 FIXED_SELECT_POSITION 开始
---@return number 列表索引
function M:GetItemIndexAtSelectPosition()
    local RealIndex = self:GetCurrentRealLevelIndex()
    -- 列表索引 = 左侧占位数 + 真实索引
    return FIXED_SELECT_POSITION + RealIndex
end

function M:GetCurrentSelectedContent()
    return self.CurrentSelectedContent
end

function M:HasSelectedContent()
    return self.CurrentSelectedContent ~= nil
end

--- 更新选中的 item（根据滚动位置选中居中的关卡）
function M:UpdateSelectedItem()
    if self.bIsScrollingToTarget then
        return
    end
    
    local NewSelectedIndex = self:GetItemIndexAtSelectPosition()
    if NewSelectedIndex == nil then
        return
    end
    
    -- 获取 Widget，跳过占位格子
    local CurWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.Wrap_Normal_L, NewSelectedIndex)
    if not CurWidget or not CurWidget.Content or CurWidget.Content.IsPlaceholder then
        return
    end
    
    if self.CurrentSelectedIndex ~= NewSelectedIndex then
        -- 取消上一个选中 item 的选中状态
        if self.LastSelectedEntry and self.LastSelectedEntry.PlayUnselected then
            if self.LastSelectedContentId and self.LastSelectedEntry.Content 
               and self.LastSelectedEntry.Content.Id == self.LastSelectedContentId then
                if self.LastSelectedEntry ~= CurWidget then
                    self.LastSelectedEntry:PlayUnselected()
                end
            end
        end
        
        self.CurrentSelectedIndex = NewSelectedIndex
        
        if CurWidget then
            if CurWidget.PlaySelected then
                CurWidget:PlaySelected()
            end
            self.LastSelectedEntry = CurWidget
            self.LastSelectedIndex = NewSelectedIndex
            
            if CurWidget.Content then
                self.CurrentSelectedContent = CurWidget.Content
                self.LastSelectedContentId = CurWidget.Content.Id
                local RealIndex = NewSelectedIndex - FIXED_SELECT_POSITION
                print("选中 Item - 列表索引:", NewSelectedIndex,
                      ", 真实索引:", RealIndex,
                      ", Id:", CurWidget.Content.Id,
                      ", LevelId:", CurWidget.Content.LevelId)
                self:UpdateInfoTips(self.CurrentSelectedContent)
                -- 选中关卡后清除该关卡的 New 红点
                self:_TryClearNewReddotForLevel(self.CurrentSelectedContent.LevelId)
            else
                self.CurrentSelectedContent = nil
                self.LastSelectedContentId = nil
            end
        else
            self.CurrentSelectedContent = nil
            self.LastSelectedContentId = nil
        end
    end
end

--- 更新箭头按钮状态（根据当前选中位置启用/禁用左右箭头）
function M:UpdateArrowButtons()
    local RealIndex = self:GetCurrentRealLevelIndex()
    
    -- 第一关时左箭头置灰，最后一关时右箭头置灰
    local bCanScrollLeft = RealIndex > 0
    local bCanScrollRight = RealIndex < self.OriginalDataCount - 1
    
    local ListIndex = self:GetItemIndexAtSelectPosition()
    local CurWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.Wrap_Normal_L, ListIndex)
    if CurWidget and CurWidget.SetArrowButtonState then
        CurWidget:SetArrowButtonState(bCanScrollLeft, bCanScrollRight)
    end
end

--- 限制滚动范围：不能超出第一关和最后一关
function M:ClampScrollPosition()
    if self.OriginalDataCount <= 0 then return false end
    
    local ScrollOffset = self.Wrap_Normal_L:GetScrollOffset()
    local MinOffset = 0
    local MaxOffset = self.OriginalDataCount - 1
    
    if ScrollOffset < MinOffset then
        self.Wrap_Normal_L:SetScrollOffset(MinOffset)
        return true
    elseif ScrollOffset > MaxOffset then
        self.Wrap_Normal_L:SetScrollOffset(MaxOffset)
        return true
    end
    return false
end

--- 吸附到最近的整数位置（鼠标释放时调用）
function M:SnapToNearestItem()
    local ScrollOffset = self.Wrap_Normal_L:GetScrollOffset()
    local SnappedOffset = math.floor(ScrollOffset + 0.5)
    
    -- 限制到有效范围
    if SnappedOffset < 0 then SnappedOffset = 0 end
    if self.OriginalDataCount > 0 and SnappedOffset > self.OriginalDataCount - 1 then
        SnappedOffset = self.OriginalDataCount - 1
    end
    
    self.Wrap_Normal_L:SetScrollOffset(SnappedOffset)
    self:UpdateSelectedItem()
    self:UpdateArrowButtons()
end

--- 列表滚动事件处理（带边界限制）
--- 当item滚动到固定选中位置时，立即触发选中逻辑
function M:_OnListItemScrolled(ItemOffset, DistanceRemaining)
    -- 1. 限制滚动范围（不超出第一关/最后一关）
    self:ClampScrollPosition()

    -- 2. 当居中位置对应的item变化时，立即更新选中状态
    local NewSelectedIndex = self:GetItemIndexAtSelectPosition()
    if NewSelectedIndex ~= self.CurrentSelectedIndex then
        self:UpdateSelectedItem()
        self:UpdateArrowButtons()
    end
end

--endregion

function M:CloseSelf()
    if self:IsAnimationPlaying(self.In) then
        return
    end
    -- 退出时清除所有未被选中查看的 New 红点
    self:_ClearUnviewedNewReddots()
    self:BindToAnimationFinished(self.Out, { self, self.Close })
    EventManager:FireEvent(EventID.OnReturnToActivityEntry)
    self:PlayAnimation(self.Out)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false

    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:HandleGamepadInput(InKeyName)
    else
        if (InKeyName == "Escape") then
            self:CloseSelf()
        end
    end

    if IsEventHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

--region 红点交互
--- 列表刷新时检查每个关卡的 New 状态
--- 解锁条件：第1关默认解锁；后续关卡需前一关≥1星 + 解锁时间已到
--- 标记条件：已解锁 + 未首通(0星) + 缓存无记录(nil)
function M:_TryRefreshBagGameNewReddot()
    local NewNode = ReddotManager.GetTreeNode("BagGameNew")
    if not NewNode then return end
    local NewCacheDetail = ReddotManager.GetLeafNodeCacheDetail("BagGameNew")
    if not NewCacheDetail then return end

    local LevelsInfo = self.OriginalDataList
    if not LevelsInfo or #LevelsInfo == 0 then return end

    for i, LevelInfo in ipairs(LevelsInfo) do
        local LevelId = LevelInfo.LevelId
        -- 跳过已有缓存记录的关卡（true=当前New, false=已查看过）
        if NewCacheDetail[LevelId] ~= nil then
            goto continue
        end

        -- 检查关卡是否已解锁
        local bUnlocked = false
        if i == 1 then
            -- 第一关默认解锁
            bUnlocked = true
        else
            -- 前一关≥1星 + 解锁时间已到
            local PrevLevelId = LevelsInfo[i - 1].LevelId
            if BagGameModel:GetPlayerStarCount(PrevLevelId) > 0 then
                local UnlockTs = self:NormalizeUnlockTimestamp(LevelInfo.UnlockDate)
                bUnlocked = UnlockTs <= 0 or TimeUtils.NowTime() >= UnlockTs
            end
        end

        -- 已解锁 + 未首通(0星) → 标记 New
        if bUnlocked and BagGameModel:GetPlayerStarCount(LevelId) == 0 then
            ReddotManager.IncreaseLeafNodeCount("BagGameNew", 1, {LevelId = LevelId})
        end

        ::continue::
    end
end

--- 选中关卡时清除该关卡的 New 红点（自动选中时不清除，仅手动切换/滑动时清除）
function M:_TryClearNewReddotForLevel(LevelId)
    if not LevelId then return end
    if self._bIsAutoSelecting then return end
    local NewCacheDetail = ReddotManager.GetLeafNodeCacheDetail("BagGameNew")
    if NewCacheDetail and NewCacheDetail[LevelId] then
        ReddotManager.DecreaseLeafNodeCount("BagGameNew", 1, {LevelId = LevelId})
    end
    self._ViewedLevelIds = self._ViewedLevelIds or {}
    self._ViewedLevelIds[LevelId] = true
end

--- 退出选关页面时清除所有未被选中查看的 New 红点
function M:_ClearUnviewedNewReddots()
    local NewNode = ReddotManager.GetTreeNode("BagGameNew")
    if not NewNode or NewNode.Count <= 0 then return end
    local NewCacheDetail = ReddotManager.GetLeafNodeCacheDetail("BagGameNew")
    if not NewCacheDetail then return end

    local LevelIdsToRemove = {}
    for LevelId, Flag in pairs(NewCacheDetail) do
        if type(LevelId) == "number" and Flag == true then
            if not self._ViewedLevelIds or not self._ViewedLevelIds[LevelId] then
                table.insert(LevelIdsToRemove, LevelId)
            end
        end
    end
    for _, LevelId in ipairs(LevelIdsToRemove) do
        ReddotManager.DecreaseLeafNodeCount("BagGameNew", 1, {LevelId = LevelId})
    end
    self._ViewedLevelIds = nil
end
--endregion

function M:BP_GetDesiredFocusTarget()
    return self
end

AssembleComponents(M)
return M