require "UnLua"

---@type WBP_Activity_SoloTreasure_Level_P_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.Common.TimerMgr"})
local SoloTreasureDataModel = require "BluePrints.UI.WBP.Activity.Widget.SoloTreasure.SoloTreasureDataModel"
local UIUtils = require "Utils.UIUtils"
local TimeUtils = require "Utils.TimeUtils"

M._components = {
    "BluePrints.UI.WBP.Activity.Widget.SoloTreasure.WBP_Activity_SoloTreasure_Level_GamepadComp",
    "BluePrints.UI.WBP.Activity.Widget.SoloTreasure.WBP_Activity_Solotreasure_Level_LoadSceneComp"
}

M.DungeonMode = {Repeat = 1, Story = 2}

-- 模式描述表
M.DungeonModeDes = {
    [M.DungeonMode.Repeat] = {
        Show = function(self)
            return {self.List_Level, self.LevelDetails.Btn_Difficulty, self.Board}
        end,
        Hide = function(self)
            return {self.LevelDetails.Panel_Bird}
        end,
        Load = function(self, EventId)
            return SoloTreasureDataModel:GetRepeatLevelDataByEventId(EventId)
        end
    },
    [M.DungeonMode.Story] = {
        Show = function(self)
            return {self.LevelDetails.Panel_Bird, self.Board}
        end,
        Hide = function(self)
            return {self.List_Level, self.LevelDetails.Btn_Difficulty}
        end,
        Load = function(self, EventId)
            return SoloTreasureDataModel:GetStoryLevelDataByEventId(EventId)
        end
    }
}

M.LevelLockType = {
    None = 0,
    Time = 1,
    Condition = 2
}

function M:IsValidCell(Value)
    if Value == nil then
        return false
    end

    if type(Value) == "string" then
        return Value ~= ""
    end

    if type(Value) == "number" then
        return true
    end

    return true
end

-- 只有 Easy 和 Hard 都填了（Fee + DungeonId）才显示下拉
function M:HasDifficultyDropdown(Row)
    if not Row then
        return false
    end
    local EasyOK = self:IsValidCell(Row.EasyModeFee) and self:IsValidCell(Row.EasyDungeonId)
    local HardOK = self:IsValidCell(Row.HardModeFee) and self:IsValidCell(Row.HardDungeonId)
    return EasyOK and HardOK
end

-- M:SS
function M:FormatTimeMS(totalSeconds)
    if not totalSeconds or totalSeconds < 0 then
        return "0:00"
    end

    local minutes = math.floor(totalSeconds / 60)
    local seconds = totalSeconds % 60

    -- 分钟不补 0，秒补 0
    return string.format("%d:%02d", minutes, seconds)
end

function M:Construct()
    self.LevelDetails.Btn_Prepare.Button_Area.OnClicked:Add(self, self.OnPrepareClicked)
    self.LevelDetails.Btn_Qa_CoinTip.Btn_Click.OnClicked:Add(self, self.OnCoinTip)
    self:InitGamePad()
    MissionIndicatorManager:TriggerAllIndicatorVisible(false)
end

function M:Destruct()
    if self.ActorController then
        self.ActorController:OnDestruct()
        self.ActorController = nil
    end
    SoloTreasureDataModel:RefreshAllSoloTreasureNewReddot(self.EventId)
    MissionIndicatorManager:TriggerAllIndicatorVisible(true)
end

function M:OnCoinTip()
    self:OnRuleTipPressed()
end

function M:OnPrepareClicked()
    local bIsDifficult = self:IsDifficult()
    -- 分包检查：根据当前难度获取实际副本ID，若资源未下载则弹出下载UI
    local Row = self.LevelData and self.LevelData[self.CurrentIndex]
    local DungeonId = Row and ((bIsDifficult and Row.HardDungeonId) or Row.EasyDungeonId or Row.HardDungeonId)
    if DungeonId and not self:EnsureOptionalPatchDownloaded(DungeonId) then
        return
    end
    self.bReturningFromPrepare = true
    DebugPrint("------------------当前关卡情况： " .. self.CurMode .. " " .. self.CurEventDungeonId)
    self.Root:OpenSubUI({Idx = "ActivitySoloTreasurePrepare"}, self.CurMode, self.CurEventDungeonId, bIsDifficult)
end

function M:SwitchOut()
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if self.ActorController then
        self.ActorController:OnDestruct()
        self.ActorController = nil
    end
    self.ActorController = nil
    SoloTreasureDataModel:RefreshAllSoloTreasureNewReddot(self.EventId)
end

function M:SwitchIn(Mode, bIsDifficult, EventDugeonId)
    self.CurMode = Mode or self.DungeonMode.Repeat
    self.EventId = SoloTreasureDataModel:GetEventId()
    self.Score = SoloTreasureDataModel:GetUserCurrentScore(self.EventId)
    self.DefaultEventDugeonId = EventDugeonId
    if bIsDifficult ~= nil and not self.bReturningFromPrepare then
        self.CurDifficulty = bIsDifficult and "Hard" or "Normal"
    end

    if not self.Score then
        DebugPrint(ErrorTag, "----------请求Score数据失败-----------")
    end
    if not self.EventId then
        DebugPrint(ErrorTag, "----------请求EventId数据失败-----------")
    end

    local bBackFromPrepare = (self.bReturningFromPrepare == true)
    self.bReturningFromPrepare = bBackFromPrepare
    if bBackFromPrepare then
        self.bWaitEscRelease = true
    -- DebugPrint("---- 从 Prepare 返回 ----")
    end

    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self:PlayAnimation(self.In)
    self:InitTable()

    self:LoadDataFromModel()
    self:ApplyModeUI()
    self:InitView()
    -- 加载场景
    self:LoadSkyBoxScene(self.NewResult)
    -- ReddotManager.PrintNodeTree("SoloTreasure_LevelListView")
end

function M:InitView()
    self:InitStaticUI()

    if self.CurMode == self.DungeonMode.Repeat then
        DebugPrint("--------------【初始化】复刷关卡---------------")

        SoloTreasureDataModel:RefreshLevelListNewReddot(self.EventId)
        self:InitSelectLevelList()
        self:InitDifficultyDropdown()
    else
        DebugPrint("--------------【初始化】剧情关卡---------------")
        self.LevelDetails:RefreshStoryLevelDetailPanel(self.NewResult)
    end

    -- 不再区分模式，统一刷 Board
    self:InitBoardView()
end

function M:InitBoardView()
    if not self.Board then
        return
    end

    if self.Board.LoadDataToBoard then
        self.Board:LoadDataToBoard(self.EventId, self.OldResult, self.NewResult)
    end

    if self.Board.RefreshProgressBoard then
        self.Board:RefreshProgressBoard(self.OldResult or self.NewResult)
    end

    if not self.NewResult then
        SoloTreasureDataModel:CommitBoardSnapshotByResult(self.EventId, self.Result or self.OldResult)
        return
    end

    local bPlayStageBoard = self.AnimInfo and self.AnimInfo.bPlayStageBoard
    local bPlayScore = self.AnimInfo and self.AnimInfo.bPlayScore

    if bPlayScore then
        if self.Board.Num_Coin_Add then
            self.Board.Num_Coin_Add:SetText(tostring(self.AnimInfo.ScoreDelta))
        end
    end

    self.Board.bPendingPlayStage = (bPlayStageBoard and bPlayScore) == true

    if bPlayStageBoard and bPlayScore then
        self:AddTimer(
            0.2,
            function()
                if self.Board and self.Board.PlayScoreAnim then
                    self.Board:PlayScoreAnim()
                end
            end,
            nil,
            nil,
            nil,
            true
        )
    elseif bPlayScore then
        self:AddTimer(
            0.2,
            function()
                if self.Board and self.Board.PlayScoreAnim then
                    self.Board:PlayScoreAnim()
                end
            end,
            nil,
            nil,
            nil,
            true
        )
    elseif bPlayStageBoard then
        self:AddTimer(
            0.2,
            function()
                if self.Board and self.Board.PlayStageAnim then
                    self.Board:PlayStageAnim()
                end
            end,
            nil,
            nil,
            nil,
            true
        )
    else
        if self.Board.RefreshProgressBoard then
            self.Board:RefreshProgressBoard(self.NewResult)
        end
        SoloTreasureDataModel:CommitBoardSnapshotByResult(self.EventId, self.NewResult)
    end
end

function M:InitTable()
    self.bCanShowRV = false

    self.TabConfigData = {
        TitleName = GText("UI_SoloTreasure_LevelChooseTitle"),
        DynamicNode = {"Back", "BottomKey", "ResourceBar"},
        StyleName = "Text",
        OwnerPanel = self.Root,
        BackCallback = self.Root.OnReturnKeyDown
    }
    if self.CurMode == self.DungeonMode.Repeat then
        self.TabConfigData.BottomKeyInfo = {
            {
                KeyInfoList = {
                    {Type = "Text", Text = "Esc", ClickCallback = self.Root.OnReturnKeyDown, Owner = self.Root}
                },
                GamePadInfoList = {{Type = "Img", ImgShortPath = "B"}},
                Desc = GText("UI_BACK"),
                bLongPress = false
            }
        }
        if self.bCanShowRV then
            table.insert(
                self.TabConfigData.BottomKeyInfo,
                {
                    GamePadInfoList = {{Type = "Img", ImgShortPath = "RV"}},
                    Desc = GText("UI_Controller_Slide"),
                    bLongPress = false
                }
            )
        end
        self:SetFocusState(self.FocusState.Focus1) -- 默认进入时 为状态1
    else
        self.TabConfigData.BottomKeyInfo = {
            {
                GamePadInfoList = {{Type = "Img", ImgShortPath = "B"}},
                Desc = GText("UI_BACK"),
                bLongPress = false
            }
        }
        self:SetFocusState(self.FocusState.Focus4)
    end
    self.Root:InitOtherPageTab(self.TabConfigData, nil, true)
end

function M:InitSelectLevelList()
    if not self.List_Level then
        return
    end
    self.List_Level:ClearListItems()

    if not self.LevelData or #self.LevelData == 0 then
        return
    end

    local EventId = self.EventId
    local LatestUnlockedIndex = nil
    local LatestUnlockedAndReadIndex = nil -- 最新“已解锁且已读(无New)”的关
    local UnlockAnimIndex = nil -- 本次需要播解锁动效的关（只取最靠后的一个）

    for Index = 1, #self.LevelData do
        local Row = self.LevelData[Index]
        local LevelObj = NewObject(UIUtils.GetCommonItemContentClass())
        LevelObj.Index = Index
        LevelObj.DungeonName = Row.DungeonName
        LevelObj.EventDungeonId = Row.EventDugeonId
        LevelObj.UnlockDate = Row.UnlockDate
        LevelObj.DungeonImage = Row.DungeonImage
        LevelObj.IsSelected = false
        LevelObj.Parent = self

        -- 判断是否为铜币关
        LevelObj.bIsExtraLevel = self:IsExtraLevelRow(Row)

        -- 判断当前Level是否开启
        LevelObj.LockType = self.LevelLockType.None
        LevelObj.RemainSeconds = 0

        local LockType, Remain = self:GetLevelLockInfo(Row)
        LevelObj.LockType = LockType
        LevelObj.RemainSeconds = Remain
        LevelObj.bForbidden = (LockType ~= self.LevelLockType.None)

        -- ====== 1) 记录“最新已解锁” ======
        if not LevelObj.bForbidden then
            LatestUnlockedIndex = Index
            self.LatestUnlockedIndex = Index
        end

        -- ====== 2) 计算“最新已解锁且已读(无New)” ======
        if (not LevelObj.bForbidden) and EventId then
            local bRead = SoloTreasureDataModel:IsLevelEntryRead(EventId, Index)
            if bRead then
                LatestUnlockedAndReadIndex = Index
            end
        end

        -- ====== 3) 解锁动效：只在 “上次锁定 -> 这次解锁” 触发 ======
        LevelObj.bNeedPlayUnlockAnim = false
        if EventId and LevelObj.EventDungeonId then
            local WasForbidden, bHasHistory = SoloTreasureDataModel:GetLastForbiddenEx(EventId, LevelObj.EventDungeonId)
            local NowForbidden = LevelObj.bForbidden

            -- 有历史才判定“锁->解锁”，避免首次打开界面就误播
            if bHasHistory then
                if WasForbidden and (not NowForbidden) then
                    local bPlayed = SoloTreasureDataModel:IsUnlockAnimPlayed(EventId, LevelObj.EventDungeonId)
                    if not bPlayed then
                        UnlockAnimIndex = Index
                        LevelObj.bNeedPlayUnlockAnim = true
                    end
                end
            end

            -- 每次都写入“上次锁定状态”
            SoloTreasureDataModel:SetLastForbidden(EventId, LevelObj.EventDungeonId, NowForbidden)
        end

        -- 添加Btn事件
        LevelObj.OnBtnClickedCallback = function(Index) -- 想要回调出来的参数
            self:OnLevelBtnClicked(Index)
        end
        -- 手柄聚焦时的回调
        LevelObj.OnFocusReceivedCallback = function(EntryWidget)
            if UIUtils.IsGamepadInput() then
                self.CurrentIndex = Index

                if EntryWidget then
                    self.LastFocusWidget = EntryWidget
                end

                DebugPrint("-----------------聚焦到：", self.CurrentIndex)
                if not LevelObj.bForbidden then
                    self:SelectLevelItem(Index)
                end
            end
        end

        self.List_Level:AddItem(LevelObj)
    end

    -- 在 OnListItemObjectSet 之前执行
    local TargetIndex = nil

    -- 如果有默认关卡（从副本返回）
    if self.DefaultEventDugeonId then
        local Idx = self:FindIndexByEventDungeonId(self.DefaultEventDugeonId)
        if Idx then
            TargetIndex = Idx
        end
        -- 用完就清
        self.DefaultEventDugeonId = nil
    elseif self.bReturningFromPrepare and self.CurrentIndex then
        -- 从prepare界面返回保持选中
        TargetIndex = tonumber(self.CurrentIndex)
    else
        -- 默认选“最新已解锁且无New(已读)”；找不到就选最新已解锁；再兜底1
        TargetIndex = LatestUnlockedAndReadIndex or LatestUnlockedIndex or 1
    end

    self.CurrentIndex = TargetIndex
    self.OldIndex = 0

    -- ====== 5) 给需要播解锁动效的那一关打标记（不在这里写已播） ======
    self.UnlockAnimIndex = UnlockAnimIndex
    if self.UnlockAnimIndex then
        local Obj = self.List_Level:GetItemAt(self.UnlockAnimIndex - 1)
        if Obj then
            Obj.bNeedPlayUnlockAnim = true
        end
    end

    -- ====== 6) 设置默认选中并刷新详情 ======
    local Obj = self.List_Level:GetItemAt(TargetIndex - 1)
    if Obj then
        Obj.IsSelected = true
    end
    self:SelectLevelItem(self.CurrentIndex)
    -- 延迟一会确保拿到Entry
    self:AddTimer(
        0.1,
        function()
            self:ApplySequentialLockNavigation()
        end,
        nil,
        nil,
        nil,
        true
    )
end

function M:GetLevelLockInfo(Row)
    -- 1) 时间锁优先
    if Row.UnlockDate and TimeUtils.NowTime() < Row.UnlockDate then
        local Remain = math.max(0, Row.UnlockDate - TimeUtils.NowTime())
        return self.LevelLockType.Time, Remain
    end

    -- 2) 再判断解锁条件
    local Avatar = GWorld:GetAvatar()
    if not ConditionUtils.CheckCondition(Avatar, Row.UnlockCondition) then
        return self.LevelLockType.Condition, 0
    end

    return self.LevelLockType.None, 0
end

function M:RefreshDungeonDetail(Index, bIsExtraLevel)
    self.LevelDetails:PlayAnimation(self.LevelDetails.Refresh)
    if not self.LevelData then
        return
    end
    local TargetRow = self.LevelData[Index]

    if self.LevelDetails.Text_Info then
        self.LevelDetails.Text_Info:SetText(GText(TargetRow.DungeonDes))
    end
    if self.LevelDetails.Text_Map then
        self.LevelDetails.Text_Map:SetText(GText(TargetRow.DungeonName))
    end
    if self.LevelDetails.Img_Map and TargetRow.DungeonImage then
        local MapImgObj = LoadObject(TargetRow.DungeonImage)
        if MapImgObj then
            self.LevelDetails.Img_Map:SetBrushFromTexture(MapImgObj)
        end
    end

    local ResourceId = DataMgr.GlobalConstant["SoloTreasureCurrent"].ConstantValue

    -- 如果是铜币关额外更新内容
    if bIsExtraLevel then
        self.bCanShowRuleTip = true
        self.LevelDetails.Panel_CoinTip:SetVisibility(UE4.ESlateVisibility.Visible)
        self.LevelDetails.Text_CoinTip:SetText(GText("UI_SoloTreasure_TicketLevelDes"))
        ResourceId = DataMgr.GlobalConstant["SoloTreasureTicketResourceId"].ConstantValue
        if UIUtils.IsGamepadInput() then
            self:RefreshRuleTipKey()
        end
    else
        self.bCanShowRuleTip = false
        if self.LevelDetails.Panel_CoinTip then
            self.LevelDetails.Panel_CoinTip:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        if UIUtils.IsGamepadInput() then
            self:RefreshRuleTipKey()
        end
    end

    -- 刷新消耗Icon
    local CoinIconPath = DataMgr.Resource[ResourceId].Icon
    local CoinObj = LoadObject(CoinIconPath)
    if CoinObj then
        self.LevelDetails.Icon_Cost:SetBrushFromTexture(CoinObj)
    end

    -- 判断关卡描述是否超出一屏
    self:AddTimer(
        0.1,
        function()
            local bRVChanged = self:UpdateRVOverflowFlag()
            if bRVChanged and UIUtils.IsGamepadInput() and self.CurFocusState == self.FocusState.Focus1 then
                self:RefreshKeyTips()
            end
        end,
        nil,
        nil,
        nil,
        true
    )
end

function M:SelectLevelItem(Index)
    if not Index or not self.LevelData or not self.LevelData[Index] then
        return
    end

    local Row = self.LevelData[Index]
    local bIsExtraLevel = self:IsExtraLevelRow(Row)

    self.CurEventDungeonId = Row.EventDugeonId
    if not self.CurEventDungeonId then
        DebugPrint(ErrorTag, "------------没拿到当前关卡Id------------")
    end

    local PrevIndex = self.OldIndex

    if self.OldIndex ~= Index then
        self:RefreshDungeonDetail(Index, bIsExtraLevel)
        self:RefreshDifficultyAreaByRow(Row)
        self:ChangeHightlight(Index, PrevIndex)
    end

    self.OldIndex = Index
    self.List_Level:SetSelectedIndex(Index - 1)
    self.List_Level:NavigateToIndex(Index - 1)

    SoloTreasureDataModel:MarkLevelEntryRead(Index)
end

function M:ChangeHightlight(NewLevelIndex, OldLevelIndex)
    local NewLevelData = self.List_Level:GetItemAt(NewLevelIndex - 1)
    local OldLevelData = self.List_Level:GetItemAt(OldLevelIndex - 1)

    if OldLevelData and (not OldLevelData.bForbidden) then
        OldLevelData.IsSelected = false
    end

    if NewLevelData and (not NewLevelData.bForbidden) then
        NewLevelData.IsSelected = true
    end

    local OldEntry = self:GetEntryByIndex(OldLevelIndex)
    local NewEntry = self:GetEntryByIndex(NewLevelIndex)
    if OldEntry and (not OldLevelData.bForbidden) then
        OldEntry:SetSelected(OldLevelData.IsSelected)
    end
    if NewEntry and (not NewLevelData.bForbidden) then
        NewEntry:SetSelected(NewLevelData.IsSelected)
    end
end

-- ===================
-- === 下拉菜单相关 ===
-- ===================
function M:RefreshDifficultyAreaByRow(Row)
    if not self.LevelDetails or not self.LevelDetails.Btn_Difficulty then
        return
    end

    local bHasDropdown = self:HasDifficultyDropdown(Row)
    self.bHasDifficultyDropdown = bHasDropdown
    if
        UIUtils.IsGamepadInput() and self.CurFocusState == self.FocusState.Focus3 and
            (self.bHasDifficultyDropdown ~= true)
     then
        self:SetFocusState(self.FocusState.Focus1)
    end
    -- 1) 控制下拉显隐
    self.LevelDetails.Btn_Difficulty:SetVisibility(
        bHasDropdown and UE4.ESlateVisibility.Visible or UE4.ESlateVisibility.Collapsed
    )

    if bHasDropdown then
        if UIUtils.IsGamepadInput() then
            self:SetOtherKeyTipsEnabled(true)
        end
        -- 2) 有下拉：记忆/默认

        if not self.CurDifficulty then
            self.CurDifficulty = "Normal"
        end

        local Idx = (self.CurDifficulty == "Hard") and 2 or 1
        self.LevelDetails.Btn_Difficulty:SelectItem(Idx)
        self:RefreshTimeAndCostByDifficulty(self.CurDifficulty)
    else
        -- 3) 没下拉：直接用“存在的那套”刷新入场费/时间
        local Fee = nil
        local DungeonId = nil

        -- 记录：当前是“单模式关”，下一次进入有下拉的关时需要重置默认
        self.bCurLevelNoDropdown = true

        if self:IsValidCell(Row.EasyModeFee) and self:IsValidCell(Row.EasyDungeonId) then
            -- 不要：self.CurDifficulty = "Normal"
            Fee = Row.EasyModeFee
            DungeonId = Row.EasyDungeonId
        elseif self:IsValidCell(Row.HardModeFee) and self:IsValidCell(Row.HardDungeonId) then
            -- 不要：self.CurDifficulty = "Hard"
            Fee = Row.HardModeFee
            DungeonId = Row.HardDungeonId
        else
            -- 两套都没配：兜底
            Fee = 0
            DungeonId = nil
        end

        if DungeonId then
            local TotalTime = SoloTreasureDataModel:GetDungeonGameTotalTime(DungeonId)
            local TimeStr = self:FormatTimeMS(TotalTime)

            if self.LevelDetails.Text_Cost then
                self.LevelDetails.Text_Cost:SetText(tostring(Fee or 0))
            end
            if self.LevelDetails.Text_Time then
                self.LevelDetails.Text_Time:SetText(TimeStr)
            end
        end
    end
end

function M:InitDifficultyDropdown()
    local DifficultyList = {
        "UI_SoloTreasure_NormalMode",
        "UI_SoloTreasure_HardMode"
    }

    self.LevelDetails.Btn_Difficulty:Init(DifficultyList, "X", self)
    self.LevelDetails.Btn_Difficulty:BindEventOnSelectionsChanged(self, self.OnDifficultyChanged)

    local Idx = 1
    if self.bReturningFromPrepare and self.CurDifficulty then
        Idx = (self.CurDifficulty == "Hard") and 2 or 1
    end

    self.LevelDetails.Btn_Difficulty:SelectItem(Idx)
end

-- 难度选择变更事件
function M:OnDifficultyChanged(SortIndex)
    local Row = self.LevelData and self.LevelData[self.CurrentIndex]
    if Row and (not self:HasDifficultyDropdown(Row)) then
        return
    end

    DebugPrint("---------[LevelDetails] OnDifficultyChanged:", SortIndex)
    local Difficulty = (SortIndex == 1) and "Normal" or "Hard"
    self.CurDifficulty = Difficulty
    self:RefreshTimeAndCostByDifficulty(Difficulty)
end

-- 下拉菜单关闭之后希望得到焦点的控件
function M:BP_GetDesiredFocusTarget()
    if not UIUtils.IsGamepadInput() then
        return nil
    end
    local ShouldFocusItem = self:GetEntryByIndex(self.CurrentIndex)
    if ShouldFocusItem then
        return ShouldFocusItem
    end
    return nil
end

-- 刷新对应难度撤离时间/入场费
function M:RefreshTimeAndCostByDifficulty(Difficulty)
    local EventDungeonId = self.CurEventDungeonId
    if not EventDungeonId then
        DebugPrint(ErrorTag, "[LevelDetails] RefreshTimeAndCostByDifficulty: CurEventDungeonId is nil")
        return
    end

    local TargetRow = nil
    local isHard = (Difficulty == "Hard")

    for _, Row in ipairs(self.LevelData) do
        if Row.EventDugeonId == self.CurEventDungeonId then
            TargetRow = Row
        end
    end

    if not TargetRow then
        DebugPrint(ErrorTag, "[LevelDetails] No config row for EventDungeonId =", EventDungeonId)
        return
    end

    local Fee = isHard and TargetRow.HardModeFee or TargetRow.EasyModeFee -- 入场费资源类型（用于icon）
    local DungeonId = isHard and TargetRow.HardDungeonId or TargetRow.EasyDungeonId
    local TotalTime = SoloTreasureDataModel:GetDungeonGameTotalTime(DungeonId) -- 对应难度的 DungeonId 查撤离时限
    local TimeStr = self:FormatTimeMS(TotalTime)

    -- 刷新UI
    if self.LevelDetails and self.LevelDetails.Text_Cost then
        self.LevelDetails.Text_Cost:SetText(tostring(Fee))
    end
    if self.LevelDetails and self.LevelDetails.Text_Time then
        self.LevelDetails.Text_Time:SetText(TimeStr)
    end
end

-- 初始化静态UI
function M:InitStaticUI()
    if not self.LevelDetails then
        return
    end
    if self.LevelDetails.Text_Desc then
        self.LevelDetails.Text_Desc:SetText(GText("UI_SoloTreasure_LevelDes"))
    end

    if self.LevelDetails.Text_TimeDesc then
        self.LevelDetails.Text_TimeDesc:SetText(GText("UI_SoloTreasure_LimitTime"))
    end

    if self.LevelDetails.Text_CostDesc then
        self.LevelDetails.Text_CostDesc:SetText(GText("UI_SoloTreasureEvent_EntryCost"))
    end

    if self.LevelDetails.Btn_Prepare.Text_Button then
        self.LevelDetails.Btn_Prepare.Text_Button:SetText(GText("UI_SoloTreasureEvent_EntryArmory"))
        self.LevelDetails.Btn_Prepare:BindPrepareBtnState()
    end

    if self.LevelDetails and (self.CurMode == self.DungeonMode.Story) then -- 剧情关UI
        if self.LevelDetails.Text_Bird then
            self.LevelDetails.Text_Bird:SetText(GText("UI_SoloTreasure_PetCon"))
        end
    end
end

function M:LoadDataFromModel()
    local DungeonModeDes = self.DungeonModeDes[self.CurMode]
    if not DungeonModeDes then
        DebugPrint("Invalid Mode:", tostring(self.CurMode))
        return
    end
    self.LevelData = DungeonModeDes.Load(self, self.EventId)

    -- 拿到活动进度表数据
    local TreasureHuntProgressData = SoloTreasureDataModel:GetTreasureHuntProgressData(self.EventId)
    if not TreasureHuntProgressData then
        DebugPrint(ErrorTag, "--------------TreasureHuntProgressData is nil--------------")
    else
        self.TreasureHuntProgressData = TreasureHuntProgressData
    end

    -- 进度板前后数据
    local OldResult, NewResult, Anim =
        SoloTreasureDataModel:GetBoardOldNewAndAnim(self.EventId, self.Score, self.TreasureHuntProgressData)

    self.OldResult = OldResult -- 玩家登录时缓存 的进度数据
    self.NewResult = NewResult -- 玩家最新 所处进度数据
    self.AnimInfo = Anim -- 播放动效相关标志和数据
    if self.NewResult then
        self.CurEventDungeonId = self.TreasureHuntProgressData[self.NewResult.CurStageIndex].EventDugeonId
    end
end

local function SetVisible(W, b)
    if not W then
        return
    end
    W:SetVisibility(b and UE4.ESlateVisibility.Visible or UE4.ESlateVisibility.Collapsed)
end

-- 只负责显示/隐藏控件（不掺业务）
function M:ApplyModeUI()
    local Desc = self.DungeonModeDes[self.CurMode]
    if not Desc then
        return
    end

    local HideList = Desc.Hide and Desc.Hide(self) or {}
    for _, w in ipairs(HideList) do
        SetVisible(w, false)
    end

    local ShowList = Desc.Show and Desc.Show(self) or {}
    for _, w in ipairs(ShowList) do
        SetVisible(w, true)
    end
end

function M:OnLevelBtnClicked(Index)
    self.CurrentIndex = Index
    self:SelectLevelItem(Index)
end

function M:IsDifficult()
    if self.CurMode ~= self.DungeonMode.Repeat then
        DebugPrint("----------未能成功获取到当前关卡难度，当前为剧情关------------")
        return nil
    end

    local Row = self.LevelData and self.LevelData[self.CurrentIndex]
    if not Row then
        DebugPrint(ErrorTag, "----------未能成功获取到当前关卡数据------------")
        return nil
    end

    -- 有下拉时，按当前选择
    if self:HasDifficultyDropdown(Row) then
        return self.CurDifficulty == "Hard"
    end

    -- 没下拉时，按实际配置判断
    if self:IsValidCell(Row.HardModeFee) and self:IsValidCell(Row.HardDungeonId) then
        return true
    end

    return false
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if self.bClosing then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    local IsHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        -- 手柄
        IsHandled = self:HandleGamepadInput(MyGeometry, InKeyEvent)
    end
    if (IsHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

-- ！esc的监听交给root界面 否则长按会一直退
function M:OnReturnKeyDown()
    if self.bClosing then
        return
    end

    self.bClosing = true

    if self.Out then
        self:PlayAnimation(self.Out)
    else
        -- 没有Out动画就直接退
        self.bClosing = false
        if self.Root and self.Root.ReturnPreWidget then
            self.Root:ReturnPreWidget()
        elseif self.Root and self.Root.OnCloseAll then
            self.Root:OnCloseAll()
        end
    end
end

function M:OnAnimationFinished(Animation)
    if Animation == self.Out then
        self.bClosing = false
        -- 直接返回上一界面/关闭整个界面（由通用组件决定）
        if self.Root and self.Root.ReturnPreWidget then
            self.Root:ReturnPreWidget()
        elseif self.Root and self.Root.OnCloseAll then
            self.Root:OnCloseAll()
        end
    end

    if Animation == self.In then
        local Entries = self.List_Level:GetDisplayedEntryWidgets()
        for _, Entry in pairs(Entries or {}) do
            if Entry and Entry.UnLockLevel and Entry.bNeedPlayUnlockAnim then
                self:AddTimer(
                    0.5,
                    function()
                        if not Entry then
                            return
                        end

                        -- 写“已播”到EMCache（用 Content 上的 EventDungeonId）
                        local Obj = Entry.Content
                        if Obj and self.EventId and Obj.EventDungeonId then
                            SoloTreasureDataModel:MarkUnlockAnimPlayed(self.EventId, Obj.EventDungeonId)
                        end

                        Entry:UnLockLevel()
                    end,
                    nil,
                    nil,
                    nil,
                    true
                )
            end
        end
    end
end

function M:ShowLockedToastByObj(LevelObj)
    if not LevelObj then
        return
    end

    if LevelObj.LockType == self.LevelLockType.Time then
        local T = self:FormatRemainTimeForToast(LevelObj.RemainSeconds)
        local Content = string.format(GText("UI_Toast_SoloTreasure_RemainUnlockTime"), T)
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, Content)
    elseif LevelObj.LockType == self.LevelLockType.Condition then
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Toast_SoloTreasure_UnlockCondition"))
    else
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Toast_SoloTreasure_UnlockCondition"))
    end
end

function M:GetEntryByIndex(Index)
    local AllDisplayedEntries = self.List_Level:GetDisplayedEntryWidgets()
    -- 高亮新的Item
    for _, Entry in pairs(AllDisplayedEntries) do
        if Index == Entry.Content.Index then
            return Entry
        end
    end
    return nil
end

function M:OnGamepadConfirm()
    if self.CurMode == self.DungeonMode.Story then
        self:OnPrepareClicked()
        return
    end
end

function M:FindIndexByEventDungeonId(EventDugeonId)
    if not EventDugeonId or not self.LevelData then
        return nil
    end

    for i, Row in ipairs(self.LevelData) do
        if Row.EventDugeonId == EventDugeonId then
            return i
        end
    end

    return nil
end

-- 铜币关判断
function M:IsExtraLevelRow(Row)
    if not Row then
        return false
    end

    local EasyScoreToResource = self:IsValidCell(Row.EasyScoreToResource)
    local EasyMaxConvertResource = self:IsValidCell(Row.EasyMaxConvertResource)
    local HardScoreToResource = self:IsValidCell(Row.HardScoreToResource)
    local HardMaxConvertResource = self:IsValidCell(Row.HardMaxConvertResource)

    local AllExist = EasyScoreToResource and EasyMaxConvertResource and HardScoreToResource and HardMaxConvertResource
    local NoneExist =
        (not EasyScoreToResource) and (not EasyMaxConvertResource) and (not HardScoreToResource) and
        (not HardMaxConvertResource)

    if AllExist then
        return true -- 铜币关
    end

    if NoneExist then
        return false -- 普通关
    end
    return false
end

function M:FormatRemainTimeForToast(sec)
    sec = math.max(0, math.floor(tonumber(sec) or 0))

    local day = math.floor(sec / 86400)
    local hour = math.floor((sec % 86400) / 3600)
    local min = math.floor((sec % 3600) / 60)

    if day > 0 then
        return string.format(
            "%s%s",
            string.format(GText("UI_Time_Day"), day),
            string.format(GText("UI_Time_Hour"), hour)
        )
    elseif hour > 0 then
        return string.format(
            "%s%s",
            string.format(GText("UI_Time_Hour"), hour),
            string.format(GText("UI_Time_Min"), min)
        )
    else
        return string.format(GText("UI_Time_Min"), math.max(1, min))
    end
end

-- 分包下载，无资产时弹出下载UI
function M:EnsureOptionalPatchDownloaded(DungeonId)
    local PatchCond = DataMgr.DungeonPatchCondition and DataMgr.DungeonPatchCondition[DungeonId]
    local NecessaryPatch = PatchCond and PatchCond.NecessaryPatch

    -- 没配置，返回 true
    if not NecessaryPatch or #NecessaryPatch == 0 then
        return true
    end

    local HotUpdateSubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UE4.UHotUpdateSubsystem)
    if not HotUpdateSubsystem then
        return true
    end
    if NecessaryPatch and not HotUpdateSubsystem:IsAllPatchOptionalSignsDownloaded(NecessaryPatch) then
        UIManager(self):LoadUINew("OptionalPatch", NecessaryPatch)
        return false
    end
    return true
end

AssembleComponents(M)

return M
