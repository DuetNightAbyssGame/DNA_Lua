
require "UnLua"
--原本有选择等级功能，现已废弃

-- 打开的 gm 指令（保持原注释）
-- gm OpenMultiChallenge 1
-- 1 为挑战的 ID，可以换成其他参数

---@type WBP_AreaCoop_LevelChoose_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
local MultiplayerChallengeModel = require "BluePrints.UI.UI_PC.MultiplayerChallenge.AreaCoop_LevelChoose_Model"
local MonsterUtils = require "Utils.MonsterUtils"
local GamePadComp = require "BluePrints.UI.UI_PC.MultiplayerChallenge.WBP_AreaCoop_LevelChoose_GamePadCompoment"
local PCBuildBPPath= "WidgetBlueprint'/Game/UI/WBP/Build/PC/WBP_Build_DefaultList_P.WBP_Build_DefaultList_P'"
local MobileBuildBPPath= "WidgetBlueprint'/Game/UI/WBP/Build/Mobile/WBP_Build_DefaultList_M.WBP_Build_DefaultList_M'"
M._components = {
    "BluePrints.UI.UI_PC.MultiplayerChallenge.WBP_AreaCoop_LevelChoose_GamePadCompoment",
}
---仅初始化lua变量时使用，千万不要有控件操作！！
function M:Initialize(Initializer)
    --   只做 Lua 层状态初始化，不做任何控件访问或动画播放
    -- 这些状态在单人、多人进入流程和匹配状态切换中会用到
    self.IsSoloStart = false          -- 标记是否为单人开局
    self.MultiWalnut = false          -- 标记多人模式下是否走核桃选择
    self.MultiTicket = false          -- 标记多人模式下是否走门票选择
    self.CurSelectedDungeonId = nil   -- 当前选中的副本 ID（由 Model 或界面选择流程维护）
    self.IsGamePad = false            -- 当前是否使用手柄（用于输入提示与按键分配）
    self.MonsterIdToItem = {}         -- 怪物条目映射（供 WBP_MonsterInfo_TabItem_C 使用）
end

function M:Construct()
    --   UI 构造期：注册匹配状态相关事件、初始化输入模式、播放入场动画等
    self.Super.Construct(self)

    -- 注册多人匹配相关事件（开始/结束），用于置灰/恢复按钮状态、切换 UI 提示等
    if self.AddDispatcher then
        self:AddDispatcher(EventID.TeamMatchTimingStart, self, self.TeamMatchTimingStart)
        self:AddDispatcher(EventID.TeamMatchTimingEnd, self, self.TeamMatchTimingEnd)
        -- 新增：监听阵容预设选择变化（索引与缺失）
        self:AddDispatcher(EventID.CurrentSquadChange, self, self.OnCurrentSquadChange)
    end

    -- 初始化输入模式子系统（用于识别键鼠/手柄，以刷新操作提示）
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    if UGameInputModeSubsystem and PlayerController then
        self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
        if (IsValid(self.GameInputModeSubsystem)) and self.RefreshOpInfoByInputDevice then
            self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
        end
    end

    -- 播放入场动画（保持原有行为）
    if self.In then
        self:PlayAnimation(self.In)
    end

    -- 新增：确保本页能接收键盘/手柄事件
    if self.SetFocus then
        self:SetFocus()
    end

    self:InitWidgetInfoInGamePad()
    self:StaticInit()
    self.ScrollBox_Desc:ScrollToStart()

    if (CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile") then
        self:InitKeyboardView()
    end
end

function M:Destruct()
    local IsMobile = (CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile")
    local TargetGroup = IsMobile and self.Group_Mob or self.Group_PC
    TargetGroup:ClearChildren()
    self:EndInteractive()--确保停止交互，防止卡死
    self.Super.Destruct(self)
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    end
end

function M:ReceiveEnterState(StackAction)
    -- self.DelayFuncs = {}
    -- self:NavigateToDefaultWidget(StackAction == 0)
    if StackAction==1 then
        self:AddTimer(0.1,function()
            self:SetFocus()
        end)
        self.DefaultList:RefreshData()
    end

    M.Super.ReceiveEnterState(self,StackAction)
end
-- 类 WBP_AreaCoop_LevelChoose_C：在 OnLoaded 后刷新标题与图标，初始化等级列表与奖励预览
function M:OnLoaded(ChallengeId)
    if type(ChallengeId) == "table" then
        if ChallengeId.ChallengeId then
            ChallengeId = ChallengeId.ChallengeId
        else
            ScreenPrint("需要传入表，包含 MultiplayerChallenge 字段")
            DebugPrintTable(ChallengeId)
        end
    end
    --   接收 GM 或导航传入的 ChallengeId，交给 Model 初始化；不改动数据解析/填充细节
    ChallengeId = tonumber(ChallengeId)
    self.ChallengeId = ChallengeId

    -- 交由数据模型完成挑战数据的初始化与界面数据准备（列表、图片、解锁条件等）
    MultiplayerChallengeModel:Init(ChallengeId)

    self:RefreshBtnState(false)

    self:InitBaseInfo()
    -- 初始化副本相关信息
    self:InitDungeonInfo()

    self:InitTeamInfo()
end

function M:StaticInit()
        -- 设置奖励标题与按钮文本
    if self.Text_BossRewards then
        self.Text_BossRewards:SetText(GText("UI_HardBoss_Preview"))
    end
    if self.Common_Button_Text_PC and self.Common_Button_Text_PC.SetText then
        self.Common_Button_Text_PC:SetText(GText("UI_HardBoss_Start"))
    end
    if self.Btn_Coop and self.Btn_Coop.SetText then
        self.Btn_Coop:SetText(GText("DUNGEONMATCH_START"))
    end
    if self.Text_Monster then
        self.Text_Monster:SetText(GText("UI_DUNGEON_MonsterType"))
    end
    if self.Text_EliteTitle then
        self.Text_EliteTitle:SetText(GText("UI_Dungeon_SpecialMonster"))
    end

    -- 绑定按钮与列表事件（参考 HardBoss 页）
    if self.Common_Button_Close_PC and self.Common_Button_Close_PC.BindEventOnClicked then
        self.Common_Button_Close_PC:BindEventOnClicked(self, self.OnClickClose)
    end
    if self.Common_Button_Text_PC and self.Common_Button_Text_PC.BindEventOnClicked then
        self.Common_Button_Text_PC:BindEventOnClicked(self, self.OnClickChallenge)
        if self.Common_Button_Text_PC.BindForbidStateExecuteEvent then
            self.Common_Button_Text_PC:BindForbidStateExecuteEvent(self, self.OnClickChallengeForbid)
        end
    end
    if self.Btn_Coop and self.Btn_Coop.BindEventOnClicked then
        self.Btn_Coop:BindEventOnClicked(self, self.OnClickChallenge_Multi)
        if self.Btn_Coop.BindForbidStateExecuteEvent then
            self.Btn_Coop:BindForbidStateExecuteEvent(self, self.OnClickChallengeForbid)
        end
    end

    if  self.Btn_Qa then
        self.Btn_Qa.Btn_Click.OnClicked:Add(self, self.OpenDetails)
    end
end

function M:InitTeamInfo()
    -- 初始化组队头像 UI（与 HardBoss 保持一致）
    local AttachWidget = self:GetAttachWidget()
    if TeamController and TeamController.OpenHeadUI2 and not self.TeamHeadUI then
        self.TeamHeadUI = TeamController:OpenHeadUI2(AttachWidget)
        if self.TeamHeadUI then
            self.TeamHeadUI.OnTeamMainFocusChanged = function(bFocused)
                local Visibility = bFocused and "Collapsed" or "SelfHitTestInvisible"
                local KeyWidgets = {}
                if self.Btn_Coop and self.Btn_Coop.Key_GamePad then
                    table.insert(KeyWidgets, self.Btn_Coop.Key_GamePad)
                end
                if self.Common_Button_Text_PC and self.Common_Button_Text_PC.Key_GamePad then
                    table.insert(KeyWidgets, self.Common_Button_Text_PC.Key_GamePad)
                end
                if self.Key_Title_Rewards then
                    table.insert(KeyWidgets, self.Key_Title_Rewards)
                end
                for _, KeyWidget in ipairs(KeyWidgets) do
                    if KeyWidget and KeyWidget.SetVisibility then
                        KeyWidget:SetVisibility(UIConst.VisibilityOp[Visibility])
                    end
                end
            end
        end
    end
end
--初始化副本相关信息，
function M:InitDungeonInfo()
    -- 选定默认副本并刷新阵容/怪物/奖励列表
    local cfg = DataMgr.MultiplayerChallenge[self.ChallengeId]
    local dungeonId = nil
    if cfg and type(cfg.DungeonId) == "table" and #cfg.DungeonId > 0 then
        dungeonId = cfg.DungeonId[1]    -- 默认取第一个
    elseif cfg and type(cfg.DungeonId) == "number" then
        dungeonId = cfg.DungeonId
    end

    if dungeonId then
        self.CurSelectedDungeonId = dungeonId
        local DungeonLevel = DataMgr.Dungeon[dungeonId].DungeonLevel
        if DungeonLevel then
            self.Text_BossLv:SetText("Lv."..DungeonLevel)
        end
        self:InitOrRefreshSquadPreset(dungeonId)
        self:RefreshMonsterInfoList(dungeonId)
        self:InitEliteItem(dungeonId) -- Initialize the elite item
        self:RefreshRewardsListByDungeon(dungeonId)
        if PageJumpUtils and PageJumpUtils.CheckDungeonCondition and DataMgr.Dungeon[dungeonId] then
            self.IsLocked = not PageJumpUtils:CheckDungeonCondition(DataMgr.Dungeon[dungeonId].Condition)
            self:RefreshBtnState(false)
        end
    else
        DebugPrint("OnLoaded: No DungeonId configured for ChallengeId", tostring(self.ChallengeId))
    end
end

-- Initialize the elite monster item
function M:InitEliteItem(DungeonId)
    if not self.EliteItem then
        return
    end
    self.EliteItem.ParentPage=self

    local DungeonData = DataMgr.Dungeon[DungeonId]
    if not DungeonData then
        self.EliteItem:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end
    
    -- TODO: Please provide the logic to get MonRewardId here.
    -- For example: local MonRewardId = YourLogicToGetId(DungeonId)

    local MonIds = DataMgr.ModDungeon2RewardId[DungeonId]
    if not MonIds or #MonIds == 0 then
        ScreenPrint("没找到对应地牢的精英怪物ID"..tostring(DungeonId))
        return
    end
    local MonRewardId=MonIds[1]
    if not MonRewardId then
        self.EliteItem:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end

    local MonRewardData = DataMgr.ModDungeonMonReward[MonRewardId]
    if not MonRewardData then
        self.EliteItem:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end

    local Content = {
        DungeonData = DungeonData,
        MonRewardData = MonRewardData,
        ParentWidget = self,
    }
    self.EliteItem:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.EliteItem:OnListItemObjectSet(Content)
end
-- [移植新增] 获取当前选中的副本 ID（由界面或模型维护）
function M:GetCurDungeonId()
    --   该值一般在列表选择或数据模型准备阶段被设置：
    -- 例如根据 MultiplayerChallenge.lua 中 ChallengeId -> DungeonId 列表进行选中与更新。
    return self.CurSelectedDungeonId
end

-- 单人挑战入口按钮回调
function M:OnClickChallenge()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local DungeonId = self:GetCurDungeonId()
    if not DungeonId then
        return
    end

    -- 条件校验：未达成则走禁用态提示
    if not PageJumpUtils or not PageJumpUtils.CheckDungeonCondition or not PageJumpUtils:CheckDungeonCondition(DataMgr.Dungeon[DungeonId].Condition) then
        if self.OnClickChallengeForbid then
            self:OnClickChallengeForbid()
        end
        return
    end

    -- 非组队：先弹门票选择；组队：直接入场，由团队事件统一弹窗
    if Avatar:IsInTeam() then
        -- 仅在组队场景下标记 Solo 开始（与其他页面保持一致）
        if TeamController and TeamController.GetModel then
            TeamController:GetModel().bPressedSolo = true
        end
        self:EnterStandalone()
    else
        self:OpenTicketDialog_Solo()
    end
end
-- 关闭按钮回调：沿用返回键逻辑
function M:OnClickClose()
    self:OnReturnKeyDown()
end


function M:GetAttachWidget()
    local AttachWidget = self.Group_Team or self
    if AttachWidget and AttachWidget.SetVisibility then
        AttachWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    return AttachWidget
end

-- 刷新按钮/列表的可交互状态（匹配中置灰，非匹配解禁）
function M:RefreshBtnState(bInIsMatching)
    -- - 匹配中：置灰主要交互按钮、禁用列表滚动等，以避免影响匹配流程
    -- - 非匹配：恢复交互

    local IsMatching = bInIsMatching
    if IsMatching == nil and self.IsMatching then
        IsMatching = self:IsMatching()
    end
    -- 新增：禁用态统一由匹配中或未解锁状态决定
    local Forbid = IsMatching or (self.IsLocked == true)

    -- 多人匹配按钮 self.Btn_Coop、单人开始按钮 self.Common_Button_Text_PC
    if self.Btn_Coop then
        self.Btn_Coop:SetVisibility(IsMatching and UIConst.VisibilityOp.HitTestInvisible or UIConst.VisibilityOp.SelfHitTestInvisible)
        if self.Btn_Coop.ForbidBtn then
            self.Btn_Coop:ForbidBtn(Forbid)
        end
    end
    if self.Common_Button_Text_PC then
        self.Common_Button_Text_PC:SetVisibility(IsMatching and UIConst.VisibilityOp.HitTestInvisible or UIConst.VisibilityOp.SelfHitTestInvisible)
        if self.Common_Button_Text_PC.ForbidBtn then
            self.Common_Button_Text_PC:ForbidBtn(Forbid)
        end
    end
    -- -- 列表示例：选择副本/难度的 List
    -- if self.List_BossLevels then
    --     self.List_BossLevels:SetVisibility(IsMatching and UIConst.VisibilityOp.HitTestInvisible or UIConst.VisibilityOp.SelfHitTestInvisible)
    -- end

    -- Dungeon表新增 bDisableMatch ,表示是否屏蔽匹配按钮
    local CurSelectedDungeonId = self:GetCurDungeonId()
    if CurSelectedDungeonId then
        local CurSelectedDungeonData = DataMgr.Dungeon[CurSelectedDungeonId]
        if CurSelectedDungeonData and CurSelectedDungeonData.bDisableMatch then
            self.Btn_Coop:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
end

--当前是否处于匹配中（复用 Team 模块的模型状态）
function M:IsMatching()
    return TeamController and TeamController:GetModel():IsMatching() or false
end

--统一处理“进入副本”的封装（单人/多人均使用）
function M:TryEnterDungeon(Avatar, DungeonId, DungeonNetMode, OtherCallback, TicketId)
    -- - 统一做副本进入前的各种检查（如队友状态、条件达成），检查失败时重置状态位
    -- - 检查通过后调用 Avatar:EnterDungeon 进入，结果回调交给上层函数处理 UI 与状态
    if not TeamController or not TeamController:DoCheckCanEnterDungeon(DungeonId) then
        DebugPrint("DoCheckCanEnterDungeon bTeammateNotReady")
        if TeamController and TeamController:GetModel() then
            TeamController:GetModel().bPressedSolo = false
            TeamController:GetModel().bPressedMulti = false
        end
        return
    end
    DebugPrint("TryEnterDungeon ", Avatar, DungeonId, DungeonNetMode, OtherCallback, TicketId)
    -- 迁移：附带阵容ID（如未初始化则为 0）
    Avatar:EnterDungeon(DungeonId, DungeonNetMode, OtherCallback, TicketId, self.SquadId or 0)
end

-- 统一处理 EnterDungeon 的返回码（成功/失败的分支）
function M.HandleEnterDungeonRetCode(RetCode, ...)
    DebugPrint("EnterDungeonCallback RetCode", RetCode)
    if RetCode == ErrorCode.RET_SUCCESS then
        return true
    else
        if TeamController and TeamController.DoWhenEnterDungeonCheckFailed then
            TeamController:DoWhenEnterDungeonCheckFailed(RetCode, ...)
        end
        EventManager:FireEvent(EventID.TeamMatchTimingEnd)
        return false
    end
end

--多人挑战入口（联机匹配）
function M:OnClickChallenge_Multi()
    -- 入口校验流程：
    -- 1) UI解锁校验（如“匹配”功能是否解锁）
    -- 2) 获取当前选中副本 ID（由模型或列表选择过程维护）
    -- 3) 校验副本条件（等级、前置条件等）
    -- 4) 防止并发动画（如 Out_Loading）导致交互被打断
    -- 5) 通过 TryEnterMultiDungeon 进入匹配流程（DedicatedServer）
    local Avatar = GWorld:GetAvatar()
    assert(Avatar, "NO AVATAR")

    if not Avatar:CheckUIUnlocked("Match") then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(DataMgr.UIUnlockRule.Match.UIUnlockDesc))
        return
    end

    local DungeonId = self:GetCurDungeonId()
    if not DungeonId then
        return
    end

    if not PageJumpUtils:CheckDungeonCondition(DataMgr.Dungeon[DungeonId].Condition) then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Tosat_Level_Locked"))
        return
    end

    if self:IsAnimationPlaying(self.Out_Loading) then
        return
    end

    -- 多人匹配：直接进入匹配，门票选择由团队事件统一弹出
    self:TryEnterMultiDungeon(DungeonId)
end

-- 专用的多人进入流程封装：进入后拉起匹配条 UI
function M:TryEnterMultiDungeon(DungeonId)
    --  
    -- - 置 bPressedMulti 标记用于团队逻辑判断
    -- - 进入成功：根据是否在队伍中选择 Sponsor/WaitingMatching 两种匹配条状态
    TeamController:GetModel().bPressedMulti = true
    local Avatar = GWorld:GetAvatar()
    assert(Avatar, "NO AVATAR")

    self:TryEnterDungeon(Avatar, DungeonId, CommonConst.DungeonNetMode.DedicatedServer,
        function(RetCode, ...)
            local bCanEnter = M.HandleEnterDungeonRetCode(RetCode, ...)
            DebugPrint("@WBP_AreaCoop_LevelChoose_C:OnClickChallenge_Multi", bCanEnter)

            if bCanEnter then
                local bIsInTeam = Avatar:IsInTeam()
                if bIsInTeam then
                    UIManager(self):LoadUINew("DungeonMatchTimingBar",
                        DungeonId, Const.DUNGEON_MATCH_BAR_STATE.SPONSOR_WAITING_CONFIRM, true)
                else
                    UIManager(self):LoadUINew("DungeonMatchTimingBar",
                        DungeonId, Const.DUNGEON_MATCH_BAR_STATE.WAITING_MATCHING_WITH_CANCEL, true)
                end
            end
        end,
        self.TicketId)

    self:RefreshBtnState()
end

-- 弹出倍率书选择（单人）
function M:OpenTicketDialog_Solo()
    local DungeonId = self:GetCurDungeonId()
    if not DungeonId then
        return
    end
    UIManager(self):ShowCommonPopupUI(100123, {
        DungeonId = DungeonId,
        RightCallbackObj = self,
        RightCallbackFunction = function(Obj, PackageData)
            local SelectedTicketId = PackageData and PackageData.Content_1 and PackageData.Content_1.TicketId or nil
            self.TicketId = SelectedTicketId
            self:EnterStandalone(SelectedTicketId)
        end,
        ForbiddenRightCallbackObj = self,
        AutoFocus = true
    }, self)
end

-- 弹出倍率书选择（多人）
function M:OpenTicketDialog_Multi()
    local DungeonId = self:GetCurDungeonId()
    if not DungeonId then
        return
    end
    UIManager(self):ShowCommonPopupUI(100123, {
        DungeonId = DungeonId,
        RightCallbackObj = self,
        RightCallbackFunction = function(Obj, PackageData)
            self.TicketId = PackageData and PackageData.Content_1 and PackageData.Content_1.TicketId or nil
            self:TryEnterMultiDungeon(DungeonId)
        end,
        ForbiddenRightCallbackObj = self,
        AutoFocus = true
    }, self)
end

-- 团队匹配开始/结束事件回调：统一刷新 UI 状态
function M:TeamMatchTimingStart()
    -- 团队匹配开始：对齐其他页面，统一置匹配标记为真
    if TeamController and TeamController.GetModel then
        TeamController:GetModel().bPressedSolo = true
        TeamController:GetModel().bPressedMulti = true
    end
    -- 置灰按钮与列表，避免误操作
    self:RefreshBtnState(true)
end

function M:TeamMatchTimingEnd()
    -- 团队匹配结束：统一清理匹配标记
    if TeamController and TeamController.GetModel then
        TeamController:GetModel().bPressedSolo = false
        TeamController:GetModel().bPressedMulti = false
    end
    -- 恢复按钮与列表交互
    self:RefreshBtnState(false)
end

-- 直接进入副本（不需要匹配），如果当前在队伍中，需要等待队友同意
function M:EnterStandalone(TicketId)
    -- 单人开始按钮回调：直接进入当前选中副本
    -- 若需要在进入成功后关闭选择页，可在回调中 Close
    local Avatar = GWorld:GetAvatar()
    assert(Avatar, "NO AVATAR")

    local DungeonId = self:GetCurDungeonId()
    if not DungeonId then
        DebugPrint("EnterStandalone DungeonId is nil")
        return
    end

    -- 与其他页面对齐：仅在“当前处于队伍中”时记录单人开始标记
    if Avatar:IsInTeam() and TeamController and TeamController.GetModel then
        TeamController:GetModel().bPressedSolo = true
    end

    self.IsSoloStart = true
    -- 先做进入副本的前置校验，避免失败路径下输入被永久阻断
    if not (TeamController and TeamController:DoCheckCanEnterDungeon(DungeonId)) then
        DebugPrint("EnterStandalone PreCheck Failed: TeammateNotReady or ConditionNotMet")
        if TeamController and TeamController:GetModel() then
            TeamController:GetModel().bPressedSolo = false
            TeamController:GetModel().bPressedMulti = false
        end
        return
    end

    self:RefreshBtnState(true)

    -- 计算要使用的门票：优先使用显式传入的 TicketId，其次使用已缓存的 self.TicketId，默认 -1 表示不使用门票
    local TicketParam = TicketId
    if TicketParam == nil then
        TicketParam = self.TicketId
    end
    if TicketParam == nil then
        TicketParam = -1
    end

    self:TryEnterDungeon(Avatar, DungeonId, CommonConst.DungeonNetMode.Standalone,
        function(RetCode, ...)
            local bCanEnter = M.HandleEnterDungeonRetCode(RetCode, ...)
            if bCanEnter then
                -- 与梦魇Boss一致：若当前在队伍中，拉起“等待队友同意”的 Sponsor 弹窗；否则直接关闭当前页
                if Avatar:IsInTeam() then
                    UIManager(self):LoadUINew("DungeonMatchTimingBar",
                        DungeonId, Const.DUNGEON_MATCH_BAR_STATE.SPONSOR_WAITING_CONFIRM, false)
                    -- 等待确认时置灰自身交互
                    self:RefreshBtnState(true)
                else
                    self:SetDungeonExitInfo()
                    self:OnReturnKeyDown()
                end
            else
                -- 进入失败：恢复按钮可用状态
                self:RefreshBtnState(false)
            end
        end,
        TicketParam)
end

-- 保留原有的键盘/手柄输入、返回键逻辑（示例）
function M:OnReturnKeyDown()
    -- 先尝试关闭阵容预设面板（优先级高于页面关闭）
    if self:IsAnimationPlaying(self.Out) then
        return
    end 
    if self.DefaultList
        and self.DefaultList.GetVisibility
        and self.DefaultList:GetVisibility() == UE4.ESlateVisibility.SelfHitTestInvisible
        and self.DefaultList.IsShow then
        self.DefaultList:OnCloseSquadGamepad()
        return
    end
    self:EndInteractive()
    MultiplayerChallengeModel:Clear()
    self.TeamHeadUI:PlayAnimation(self.TeamHeadUI.Auto_Out)
    if self.Out then
        self:PlayAnimation(self.Out)
        self:UnbindAllFromAnimationFinished(self.Out)
        self:BindToAnimationFinished(self.Out, function()
            self:Close()
        end)
    else
        self:Close()
    end
end

function M:EndInteractive()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
    if not PlayerController then
        return
    end
    local Player = PlayerController:GetMyPawn()
    if not Player then
        return
    end
    local Eid = Player.MechanismEid
    local Mechanism = Battle(self):GetEntity(Eid)
    if Mechanism then
        DebugPrint("@WBP_AreaCoop_LevelChoose_C:EndInteractive")
        Mechanism:EndInteractive(Player, true)
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    --   保留原有的键盘/手柄输入处理，Escape 关闭界面，手柄按键做相应操作
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        self.IsGamePad = true
        IsEventHandled = self:OnGamePadDown(InKeyName)
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        self.IsGamePad = false
        if (InKeyName == "Escape") then
            self:OnReturnKeyDown()
            IsEventHandled = true
        elseif (InKeyName == "N") then
            self.ScrollBox_Desc:ScrollWidgetIntoView(self.HB_Title_Monster)
            IsEventHandled = true
        end
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnGamePadDown(InKeyName)
    -- 手柄键位说明：
    -- - FaceButtonTop（Y）：单人开始
    -- - FaceButtonLeft（X）：多人匹配开始
    -- - LeftThumb（左摇杆按下）：进入怪物列表选择模式
    -- - RightThumb（右摇杆按下）：进入奖励列表选择模式
    -- - FaceButtonRight（B）：优先关闭阵容预设，其次默认主按钮焦点/退出选择模式，最后才页面返回
    -- - SpecialRight（菜单键）：透传到队伍头像UI

    -- 组合键状态跟踪（用于 Up + B）
    self.PressedKeys = self.PressedKeys or {}
    self.PressedKeys[InKeyName] = true
    local IsDpadUp = (self.PressedKeys[UIConst.GamePadKey.DPadUp] == true)

    if (InKeyName == UIConst.GamePadKey.FaceButtonTop) then
        -- 单人开始
        if self.Common_Button_Text_PC and self.Common_Button_Text_PC.IsForbidden then
            if self.OnClickChallengeForbid then self:OnClickChallengeForbid() end
        else
            if self.OnClickChallenge then self:OnClickChallenge() end
        end
        return true

    elseif (InKeyName == UIConst.GamePadKey.FaceButtonLeft) then
        -- 多人匹配开始
        if self.Btn_Coop and self.Btn_Coop.IsForbidden then
            if self.OnClickChallengeForbid then self:OnClickChallengeForbid() end
        else
            if self.OnClickChallenge_Multi then self:OnClickChallenge_Multi() end
        end
        return true

    elseif (InKeyName == UIConst.GamePadKey.LeftThumb) then
        -- 怪物列表进入选择模式（列表可见时）
        if self.EnterSelectMode then self:EnterSelectMode(self.EliteItem.List_EliteProp) end           
        return true
        -- -- 回退：若怪物列表不可见，打开详情
        -- if self.OpenDetails then self:OpenDetails() end
        -- return true

    elseif (InKeyName == UIConst.GamePadKey.RightThumb) then
        -- 奖励列表进入选择模式（列表可见时）
            self:OpenDetails()
            return true

    elseif (InKeyName == UIConst.GamePadKey.DPadRight) then
        -- DPad 右：切换自动召唤幻灵开关（DefaultList.Preview.Switch_Summon）
        if self.OnDPadRightToggleAutoSummon and (not (self.IsFocusList and self:IsFocusList())) then
            local handled = self:OnDPadRightToggleAutoSummon()
            if handled then return true end
        end

    elseif (InKeyName == UIConst.GamePadKey.DPadLeft) then
        -- DPad 左：打开默认菜单锚点（DefaultMenuAnchor）
        -- 若菜单锚点已打开，则直接消费事件，避免重复打开导致导航异常
        local DefaultList = self.DefaultList
        if DefaultList and DefaultList.IsMenuAnchorOpen and DefaultList:IsMenuAnchorOpen() then
            return true
        end
        if self.OnDPadLeftOpenDefaultMenuAnchor and (not (self.IsFocusList and self:IsFocusList())) then
            local handled = self:OnDPadLeftOpenDefaultMenuAnchor()
            if handled then return true end
        end

    elseif (InKeyName == UIConst.GamePadKey.FaceButtonRight) then
        -- 优先处理：若默认列表的菜单锚点处于打开状态，按 B 关闭并恢复页面焦点
        local DefaultList = self.DefaultList or (self.EnsurePlatformDefaultListLoaded and self:EnsurePlatformDefaultListLoaded())
        if self.DefaultList.Preview.Btn_Qa_Summon.Btn_Click:IsChecked() then
            self.DefaultList.Preview:CloseMenuAnchor()
            DefaultList:CloseMenuAnchor() 
            return true
        end

        -- -- Up + B：打开 QA 的 Tips 弹窗
        -- if IsDpadUp and self.ShowQaTipsPopup then
        --     local handled = self:ShowQaTipsPopup()
        --     if handled then return true end
        -- end

        -- 1) 阵容预设打开：优先关闭
        if self.OnBKeyCloseDefaultList and self:OnBKeyCloseDefaultList() then
            if self.UpdateSquadPresetBottomKey then
                self:UpdateSquadPresetBottomKey()
            end
            -- 关闭后重置页面焦点到合理的首项（怪物/奖励列表），否则退回页面
            if self.SelectCellFocus then
                self:SelectCellFocus()
            end
            return true
        end

        -- 2) 列表聚焦（选择模式）：退出选择模式
        if self.IsInSelectState and self.LeaveSelectMode then
            self:LeaveSelectMode()
            return true
        end

        -- 3) 队伍头像当前聚焦：直接返回页面
        local headFocused = false
        if self.TeamHeadUI then
            if  self.TeamHeadUI:HasFocusedDescendants() or self.TeamHeadUI:HasAnyUserFocus() then
                self.bShoulFocusToLastFocusedWidget = true
                headFocused = true
            end
        end
        if  headFocused then
            self:LeaveSelectMode()
            return true
        end

        -- 4) 其它情况：返回页面
        if self.OnReturnKeyDown then self:OnReturnKeyDown() end
        return true

    elseif (InKeyName == UIConst.GamePadKey.SpecialRight) then
        -- 透传到队伍头像UI（例如打开队伍菜单）
        if self.TeamHeadUI and self.TeamHeadUI.DoGamepadBtnPress then
            self.TeamHeadUI:DoGamepadBtnPress()
            return true
        end
    end

    return false
end

-- 新增：默认列表收起后的焦点重置（供默认列表关闭时/页面兜底调用）
function M:SelectCellFocus()
    -- -- 优先把焦点落在“怪物/奖励列表”的第一个条目；否则退回页面自身焦点
    -- if self.FindNextFocusableItem then
    --     self:FindNextFocusableItem()
    --     return
    -- end
    if self.SetFocus then
        self:SetFocus()
    end
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    -- local ParentHandled = WBP_TrueHardBoss_HardLevelChoose_C.Super.OnKeyUp(self, MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    -- 组合键状态重置
    self.PressedKeys = self.PressedKeys or {}
    self.PressedKeys[InKeyName] = false

    if InKeyName == UIConst.GamePadKey.SpecialRight then
        if self.TeamHeadUI then
            self.TeamHeadUI:DoGamepadBtnRelease()
        end
        -- 调用默认列表或页面组件的“阵容预设”短按委托
        local DefaultList = self.DefaultList 
        if DefaultList and DefaultList.OnSpecialRightUp then
            local headFocused = false
            if self.TeamHeadUI then
                if self.TeamHeadUI.HasFocusedDescendants and self.TeamHeadUI:HasFocusedDescendants() then
                    headFocused = true
                elseif self.TeamHeadUI.HasAnyUserFocus and self.TeamHeadUI:HasAnyUserFocus() then
                    headFocused = true
                end
            end
            if not headFocused then
                DefaultList:OnSpecialRightUp()
                -- 同步底部按键提示
                if self.UpdateSquadPresetBottomKey then
                    self:UpdateSquadPresetBottomKey()
                end
                -- 展开：导航到首项；收起：重置页面焦点
                if DefaultList.IsShow and DefaultList.List_Default and DefaultList.List_Default.NavigateToIndex then
                    DefaultList.List_Default:NavigateToIndex(0)
                    self.CurrentFocusType = "DefaultList"
                else
                    if self.SelectCellFocus then
                        self:SelectCellFocus()
                    elseif self.SetFocus then
                        self:SetFocus()
                    end
                end
            end
        end
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end


-- 新增：处理手柄右摇杆纵向滚动描述滚动框
function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if InKeyName == UIConst.GamePadKey.RightAnalogY and self.ScrollBox_Desc and self.ScrollBox_Desc.GetScrollOffset and not self.ScrollBox_Desc:HasFocusedDescendants() then
        local Delta = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
        if Delta ~= nil then
            -- 右摇杆上推为负，向上滚；做个灵敏度调节
            local DeltaOffset = (-1) * Delta * 20
            self:AddDeltaOffset(DeltaOffset)
        end
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

-- 新增：按偏移量滚动 ScrollBox_Desc（带边界保护）
function M:AddDeltaOffset(DeltaOffset)
    if not self.ScrollBox_Desc or not self.ScrollBox_Desc.GetScrollOffset or not self.ScrollBox_Desc.SetScrollOffset then
        return
    end
    local CurrentOffset = self.ScrollBox_Desc:GetScrollOffset()
    local EndOffset = 0
    if self.ScrollBox_Desc.GetScrollOffsetOfEnd then
        EndOffset = self.ScrollBox_Desc:GetScrollOffsetOfEnd()
    else
        -- 若缺少 End 函数，则使用较大上限避免报错
        EndOffset = CurrentOffset + math.abs(DeltaOffset or 0) + 1000
    end
    local NextOffset = math.min(math.max(CurrentOffset + (DeltaOffset or 0), 0), EndOffset)
    self.ScrollBox_Desc:SetScrollOffset(NextOffset)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end
--初始化基础描述信息
function M:InitBaseInfo()
    local TitleName=MultiplayerChallengeModel:GetTitleName()
    if self.Text_BossLevel and TitleName then
        self.Text_BossLevel:SetText(GText(TitleName))
    end
    local TeleportName = MultiplayerChallengeModel:GetTeleportName()
    if self.Text_BossName and TeleportName then
        self.Text_BossName:SetText(GText(TeleportName))
    end
    local ChallengeName = MultiplayerChallengeModel:GetChallengeName()
    if self.Text_BossDetail and ChallengeName then
        self.Text_BossDetail:SetText(GText(ChallengeName))
    end
    -- if self.Text_BossDetail then
    --     local ChallengeDes = MultiplayerChallengeModel:GetChallengeDes()
    --     if ChallengeDes then
    --         self.Text_BossDetail:SetText(GText(ChallengeDes))
    --     end
    -- end

    self:SetImageIcon()
end
-- 设置图片
function M:SetImageIcon(TexturePath)
    local IconPath = MultiplayerChallengeModel:GetChallengeIconPath()
    if IconPath ~= nil then
        local ImageObject = LoadObject(IconPath)
        if not ImageObject:IsA(UE4.UTexture2D) then
            DebugPrint("IconPath需要纹理类型: 请检查填的路径: ".. tostring(ImageObject))
            return
        end
        local ImgMat = self.Image_LinShiImage:GetDynamicMaterial()
        ImgMat:SetTextureParameterValue("IconMap", ImageObject)
    end
end
function M:OpenDetails()
    UIManager(self):LoadUINew("ItemInformation",
        {
            Name = MultiplayerChallengeModel:GetChallengeName(),
            Desc = MultiplayerChallengeModel:GetChallengeDes(),
        },
        "LevelDatail")
end

-- 根据当前副本刷新阵容预设组显隐与初始化
-- 新增：统一控制阵容预设容器的显隐（PC/移动端容器）
function M:ToggleSquadPresetVisible(bShow)
    local Vis = bShow and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed
    if self.Group_PC then
        self.Group_PC:SetVisibility(Vis)
    end
    if self.Group_Mob then
        self.Group_Mob:SetVisibility(Vis)
    end
end

function M:EnsurePlatformDefaultListLoaded()
    local IsMobile = (CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile")
    local TargetGroup = IsMobile and self.Group_Mob or self.Group_PC
    local TargetPath = IsMobile and MobileBuildBPPath or PCBuildBPPath
    local FieldName = IsMobile and "DefaultList_Mob" or "DefaultList_PC"

    -- 已加载则复用
    if self[FieldName] and IsValid(self[FieldName]) then
        self.DefaultList = self[FieldName]
    else
        -- 动态创建并挂载到容器
        local ClassObj = LoadClass(TargetPath)
        if not ClassObj then
            DebugPrint("EnsurePlatformDefaultListLoaded: LoadClass failed", TargetPath)
            return nil
        end
        local Widget = NewObject(ClassObj,self)
        self[FieldName] = Widget

        -- 激活 IsLeft 条件
        if Widget.IsLeft ~= nil then
            Widget.IsLeft = true
        end

        self:AddTimer(0.3,function()
            if IsValid(Widget) and Widget.Preview and Widget.Preview.Btn_Qa_Summon then
            Widget.Preview.Btn_Qa_Summon.Tips_MenuAnchor:SetPlacement(EMenuPlacement.MenuPlacement_ComboBox)
            end
        end)
        if TargetGroup and TargetGroup.AddChild then
            TargetGroup:ClearChildren()
            TargetGroup:AddChild(Widget)
        else
            DebugPrint("EnsurePlatformDefaultListLoaded: TargetGroup missing or no AddChild")
        end

        self.DefaultList=Widget

        -- 修正：OverlaySlot 绑定应设在子控件，而不是容器
        local OverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(Widget)
        if OverlaySlot then
            OverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
            OverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
        end
    end

    -- 容器显隐与 PC 端布局应用
    if IsMobile then
        if self.Group_PC then
            self.Group_PC:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        if self.Group_Mob then
            self.Group_Mob:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    else
        if self.Group_Mob then
            self.Group_Mob:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        if self.Group_PC then
            self.Group_PC:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
        if self.DefaultList and self.DefaultList.ApplyPcUiLayout then
            --self.DefaultList:ApplyPcUiLayout()
        end
    end

    -- 新增：菜单锚点开合回调与首次进入同步底部键
    if self.DefaultList then
        local prevCB = self.DefaultList.OnMenuOpenChangedCallBack
        self.DefaultList.OnMenuOpenChangedCallBack = function(ownerWidget, bIsOpen)
            if self.UpdateSquadPresetBottomKey then
                self:UpdateSquadPresetBottomKey()
            end
            if type(prevCB) == "function" then
                prevCB(ownerWidget, bIsOpen)
            end
        end
        if self.UpdateSquadPresetBottomKey then
            self:UpdateSquadPresetBottomKey()
        end
    end

    return self.DefaultList
end


-- 新增：根据副本配置刷新阵容预设初始化（禁用幻灵、同步 SquadId）
function M:InitOrRefreshSquadPreset(DungeonId)
    local DungeonInfo = DataMgr.Dungeon[DungeonId]
    if not DungeonInfo then
        return
    end

    local bSquadEnabled = DungeonInfo.Squad and true or false
    self:ToggleSquadPresetVisible(bSquadEnabled)
    if not bSquadEnabled then
        return
    end

    local DefaultList = self:EnsurePlatformDefaultListLoaded()
    if not DefaultList then
        DebugPrint("InitOrRefreshSquadPreset: DefaultList is nil")
        return
    end

    local bDisablePhantom = false
    local DungeonType = DungeonInfo.DungeonType or DungeonInfo.Type
    if DungeonType == "Rouge" then
        bDisablePhantom = true
    end

    local Avatar = GWorld:GetAvatar()
    local SquadId = 0
    if Avatar and Avatar.DungeonSquad and DungeonType and Avatar.DungeonSquad[DungeonType] then
        SquadId = Avatar.DungeonSquad[DungeonType]
    end
    self.SquadId = SquadId


    if DefaultList.Init then
        DefaultList:Init(self, bDisablePhantom, SquadId, DungeonId)
    end
    -- 按当前输入设备单次初始化布局，避免 PC+手柄双重初始化
    local curInput = UIUtils.UtilsGetCurrentInputType()
    if curInput == ECommonInputType.MouseAndKeyboard and self.DefaultList.ApplyPcUiLayout then
        self.DefaultList:ApplyPcUiLayout()
    elseif curInput == ECommonInputType.Gamepad and self.DefaultList.InitWidgetInfoInGamePad then
        self.DefaultList:InitWidgetInfoInGamePad()
    end

    -- 修复：链式挂接默认列表的菜单开合回调（保留原有逻辑 + 正确签名）
    if DefaultList then
        local prevCB = DefaultList.OnMenuOpenChangedCallBack
        DefaultList.OnMenuOpenChangedCallBack = function(ownerWidget, bIsOpen)
            -- 页面侧先更新左侧提示
            self:UpdateSquadPresetKeyTips(bIsOpen)
            -- 底部键：按 DefaultList 状态（IsShow + IsMenuAnchorOpen）刷新
            if self.UpdateSquadPresetBottomKey then
                self:UpdateSquadPresetBottomKey()
            end
            -- 调用默认列表原回调，保证 Key_Controller_* 初始化与显隐正确
            if type(prevCB) == "function" then
                prevCB(ownerWidget, bIsOpen)
            end
        end
        -- 首次进入时根据当前开合状态刷新一次
        local isOpen = DefaultList.IsMenuAnchorOpen and DefaultList:IsMenuAnchorOpen() or false
        self:UpdateSquadPresetKeyTips(isOpen)
        -- 首次进入同步一次底部键
        if self.UpdateSquadPresetBottomKey then
            self:UpdateSquadPresetBottomKey()
        end
    end
end
-- 可选：根据关卡填充怪物预览列表
function M:RefreshMonsterInfoList(DungeonId)
    -- 改为从 Model 获取怪物预览数据
    local MonsterPreview = MultiplayerChallengeModel:GetMonsterPreviewData(DungeonId)
    if not MonsterPreview or not MonsterPreview.List or #MonsterPreview.List == 0 then
        self.ListView_Monster:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end

    self.MonsterWeaknessIcon = MonsterPreview.WeaknessIcon or {}
    self.ListView_Monster:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

    -- 新增：清空旧列表并重置父控件状态，避免重复项与空字典
    if self.ListView_Monster.ClearListItems then
        self.ListView_Monster:ClearListItems()
    end
    self.MonsterIdToItem = {}
    self.DisplayMonsters = MonsterPreview.List
    self.NowSelectingIndex = 1

    local MonsterItemContentClass = LoadClass('/Game/UI/WBP/Play/Widget/Depute/MonsterInfo_Tab_Item_Content.MonsterInfo_Tab_Item_Content')
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    for _, MonsterId in ipairs(MonsterPreview.List) do
        local MonsterData = DataMgr.Monster[MonsterId]
        if MonsterData and GameState.IsUnitRelease(MonsterId) then
            local Content = NewObject(MonsterItemContentClass)
            Content.ParentWidget = self
            Content.MonsterId = MonsterId
            Content.DisableSelect = true
            Content.SoundEvent = "event:/ui/common/click_mid"
            Content.WeaknessIcon = self.MonsterWeaknessIcon[MonsterId]
            Content.NeedFocusable = true
            Content.List = self.ListView_Monster
            Content.OnAddedToFocusPathEvent = {
            Obj = Content,
            Callback = function(Content)
                self:OnItemFocus(Content)
            end,
        }
            self.ListView_Monster:AddItem(Content)
        end
    end
end

-- 可选：点击怪物项打开怪物详情（内容类通常会调用该方法）
function M:SelectMonsterInfoItem(MonsterId)
    UIManager(self):LoadUINew("MonsterDetailInfo", self.CurSelectedDungeonId, self, MonsterId)
end
--刷新奖励列表
function M:RefreshRewardsListByDungeon(DungeonId)
    if not self.ListView_Rewards then return end
    self.ListView_Rewards:ClearListItems()
    local Rewards = MultiplayerChallengeModel:GetRewardPreviewData(DungeonId)
    if not Rewards or #Rewards == 0 then
        self.Group_Title_Rewards:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.ListView_Rewards:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end

    self.Group_Title_Rewards:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.ListView_Rewards:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

    for i = 1, #Rewards do
        local Info = Rewards[i]
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.UIName = "AreaCoopLevelChoose"
        Content.IsShowDetails = true
        Content.Id = Info.Id
        -- 不显示数量：不设置 Content.Count
        Content.Icon = Info.Icon
        Content.Rarity = Info.Rarity
        Content.ItemType = Info.Type
        Content.NeedFocusable = true
        Content.List = self.ListView_Rewards
        Content.OnAddedToFocusPathEvent = {
            Obj = Content,
            Callback = function(Content)
                self:OnItemFocus(Content)
            end,
        }

        self.ListView_Rewards:AddItem(Content)
    end
end


-- 可选：供怪物Tab项调用的最小选择管理
function M:SetTabItemSelection(Item)
    if self.SelectingItem and self.SelectingItem ~= Item and self.SelectingItem.CancelTabSelect then
        self.SelectingItem:CancelTabSelect()
    end
    self.SelectingItem = Item
end

-- 禁用态点击的兜底回调：提示未达成解锁条件
function M:OnClickChallengeForbid()
    local DungeonId = self:GetCurDungeonId()
    if not DungeonId then return end
    local Avatar = GWorld:GetAvatar()
    if Avatar and DataMgr.Dungeon[DungeonId] and ConditionUtils and ConditionUtils.CheckCondition then
        ConditionUtils.CheckCondition(Avatar, DataMgr.Dungeon[DungeonId].Condition, true)
    else
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Tosat_Level_Locked"))
    end
end

-- 新增：接收阵容预设变化事件（索引与缺失标记）
function M:OnCurrentSquadChange(SquadId, IsComMissing, CurSelectedDungeonId)
    self.SquadId = SquadId or 0
    self.IsComMissing = IsComMissing and true or false
    -- 缺失组件时提示（阵容预设组显示时）
    if self.IsComMissing and self.DefaultList and self.DefaultList:GetVisibility() == UE4.ESlateVisibility.SelfHitTestInvisible then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Squad_Miss_Challenge"))
    end
end

function M:ScrollItemIntoView(Widget)
    DebugPrint("ScrollItemIntoView")
    self.ScrollBox_Desc:ScrollWidgetIntoView(Widget)
end
-- 输入设备切换：同步页面与默认列表的布局、提示与焦点
function M:RefreshOpInfoByInputDevice(InputType, GamepadName) end

function M:OnInputDeviceChanged(InputType, GamepadName) end

-- 视图初始化：按输入设备显示手柄提示控件
function M:InitWidgetInfoInGamePad() end


-- 统一使用 SetGamePadVisibility 控制键位提示显隐
function M:SetKeyWidgetGamePadVisibility(KeyWidget, bShow) end

function M:InitGamepadView() end

function M:InitKeyboardView() end

-- -- 进入/退出选择模式（保留你之前已经添加的两列表选择行为）
-- function M:EnterSelectMode(SelectList)
--     return GamePadComp.EnterSelectMode(self, SelectList)
-- end

-- function M:LeaveSelectMode()
--     return GamePadComp.LeaveSelectMode(self)
-- end

-- function M:FocusOnDefault()
--     return GamePadComp.FocusOnDefault(self)
-- end

-- function M:SetectFirstItem(List)
--     return GamePadComp.SetectFirstItem(self, List)
-- end

-- function M:FindNextFocusableItem()
--     return GamePadComp.FindNextFocusableItem(self)
-- end

-- function M:OnNavigationUpInScrollBox(Index)
--     -- 迁移至组件，页面侧不再执行，避免重复
--     return
-- end

-- function M:OnNavigationDownInScrollBox(Index)
--     -- 迁移至组件，页面侧不再执行，避免重复
--     return
-- end

-- 与 DeputeDetail 一致的模式切换封装：统一入口
function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse) end

function M:UpdateSquadPresetKeyTips(bIsOpen) end

-- 退出副本跳转相关
function M:SetDungeonExitInfo()
    local ExitDungeonInfo = {}
    ExitDungeonInfo.IsFromRegionMechanism = true
    GWorld.GameInstance:SetExitDungeonData(ExitDungeonInfo)
end

AssembleComponents(M)
return M
