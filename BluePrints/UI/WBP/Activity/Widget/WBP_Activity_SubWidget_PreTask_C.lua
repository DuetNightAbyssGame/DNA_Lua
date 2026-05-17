--
-- DESCRIPTION
-- 活动跳转界面，前置任务组件
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_PreTask_Item_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:InitPage(EventId)
    self.EventId = EventId
    self.EventInfo = DataMgr.EventMain[self.EventId]
    if not self.EventInfo then
        ScreenPrint("初始化前置任务组件读表失败！EventId:", self.EventId)
        return
    end

    self:UpdateVisibility()

    self.Text_TaskTitle:SetText(GText("UI_PretextTasks"))

    -- 其实只用得上两个按钮，没必要用ListView来做，先这样吧
    self.TaskListContents = {}
    -- 主任务按钮
    local MainQuestInfo = self:GetMainQuestInfo()
    if MainQuestInfo.DisplayTextName then   -- GetMainQuestInfo接口保底会返回个空table，暂时拿这个元素是否存在做是否成功的判断吧
        local MainQuestContent = NewObject(UIUtils.GetCommonItemContentClass())
        MainQuestContent.ParentWidget = self
        MainQuestContent.OnClickedParams = {
            Obj = self,
            Callback = self.OnClicked_TaskBtn,
            Params = table.pack(MainQuestInfo.JumpQuestChainId),
        }
        MainQuestContent.BtnName = "Main"
        MainQuestContent.DisplayText = MainQuestInfo.DisplayTextName
        MainQuestContent.IsShowLock = MainQuestInfo.IsShowLock
        MainQuestContent.IsForbidClick = MainQuestInfo.IsForbidClick
        MainQuestContent.IsShowFinish = MainQuestInfo.IsShowFinish
        self.List_Task:AddItem(MainQuestContent)
        table.insert(self.TaskListContents, MainQuestContent)
    end
    -- 副任务按钮
    local SideQuestInfo = self:GetSideQuestInfo()
    if SideQuestInfo.DisplayTextName then
        local SideQuestContent = NewObject(UIUtils.GetCommonItemContentClass())
        SideQuestContent.ParentWidget = self
        SideQuestContent.OnClickedParams = {
            Obj = self,
            Callback = self.OnClicked_TaskBtn,
            Params = table.pack(SideQuestInfo.JumpQuestChainId),
        }
        SideQuestContent.BtnName = "Side"
        SideQuestContent.DisplayText = SideQuestInfo.DisplayTextName
        SideQuestContent.IsShowLock = SideQuestInfo.IsShowLock
        SideQuestContent.IsForbidClick = SideQuestInfo.IsForbidClick
        SideQuestContent.IsShowFinish = SideQuestInfo.IsShowFinish
        SideQuestContent.IsShowTip = SideQuestInfo.IsShowTip
        self.List_Task:AddItem(SideQuestContent)
        table.insert(self.TaskListContents, SideQuestContent)
    end

    self.Key_PerTaskTitle:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "View"
            }
        }
    })

    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if IsValid(self.GameInputModeSubsystem) then
        self:OnUpdateSubUIViewStyle(self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad)
    end
end

function M:UpdatePage()
    self:UpdateVisibility()

    for _, QuestContent in pairs(self.TaskListContents) do
        if IsValid(QuestContent) then
            local FunName = "Get"..QuestContent.BtnName.."QuestInfo"
            local NewQuestInfo = FunName(self)
            QuestContent.OnClickedParams = {
                Obj = self,
                Callback = self.OnClicked_TaskBtn,
                Params = table.pack(NewQuestInfo.JumpQuestChainId),
            }
            QuestContent.DisplayText = NewQuestInfo.DisplayTextName
            QuestContent.IsShowLock = NewQuestInfo.IsShowLock
            QuestContent.IsForbidClick = NewQuestInfo.IsForbidClick
            QuestContent.IsShowFinish = NewQuestInfo.IsShowFinish
            QuestContent.IsShowTip = NewQuestInfo.IsShowTip
            QuestContent.SelfWidget:OnListItemObjectSet(QuestContent)
        end
    end
end

function M:UpdateVisibility()
    self.IsShow = self:IsNeedShow()
    DebugPrint("PreTaskSubWidget:UpdateVisibility IsShow", self.IsShow)
    if self.IsShow then
        self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:OnSubWidgetReceivedFocus()
    if self.IsShow then
        self.List_Task:SetFocus()
        self.Key_PerTaskTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    return "SelectView", self.List_Task
end

function M:OnSubWidgetLostFocus()
    if self.IsShow then
        self.Key_PerTaskTitle:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    return nil, nil
end

function M:OnUpdateSubUIViewStyle(IsUseGamePad)
    if self.IsShow then
        if IsUseGamePad then
            self.Key_PerTaskTitle:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else
            self.Key_PerTaskTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
end

-- 存在某前置任务未完成，才显示
function M:IsNeedShow()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end

    local EventInfo = DataMgr.EventMain[self.EventId]
    if not EventInfo then
        ScreenPrint("EventMain表中找不到止流活动相关信息！读取的EventId:"..self.EventId)
        return false
    end

    local PrerequisiteQuestId = {}
    if EventInfo.PretextTasks1 then
        table.insert(PrerequisiteQuestId, EventInfo.PretextTasks1)
    end
    for _, QuestId in pairs(EventInfo.PretextTasks2 or {}) do
        table.insert(PrerequisiteQuestId, QuestId)
    end

    for _, QuestId in pairs(PrerequisiteQuestId) do
        -- local QuestChain = Avatar.QuestChains[QuestId]
        -- -- 拿不到说明未接取
        -- if not QuestChain then
        --     return true
        -- end
        -- if not QuestChain:IsFinish() then
        --     return true
        -- end
        local IsQuestFinished = Avatar:IsQuestFinished(QuestId)
        local IsQuestAssumeFinished = Avatar:IsQuestAssumeFinished(QuestId)
        if (not IsQuestFinished) and (not IsQuestAssumeFinished) then
            return true
        end
    end
    return false
end


function M:OnClicked_TaskBtn(JumpQuestChainId)
    DebugPrint("OnClicked_JumpQuestChainId", JumpQuestChainId)
    PageJumpUtils:JumpToTargetPageByJumpId(23, JumpQuestChainId)
end

-- return table
-- {
--      DisplayTextName = string,
--      IsShowLock = bool,
--      IsForbidClick = bool,
--      IsShowFinish = bool,
--      JumpQuestChainId = int,
-- }
function M:GetMainQuestInfo()
    local Res = {}

    local ConfigedMainQuestChainId = self.EventInfo.PretextTasks1
    if not ConfigedMainQuestChainId then
        return Res
    end
    local ConfigedMainQuestChainState = self:GetQuestChainState(ConfigedMainQuestChainId)
    if ConfigedMainQuestChainState == "Unlock" then
        -- 配置的主线任务链未解锁，找到当前正在进行的主线任务，并跳转
        local Avatar = GWorld:GetAvatar()
        for QuestChainId, Data in pairs(Avatar.QuestChains) do
            local QuestChainType = DataMgr.QuestChain[QuestChainId].QuestChainType
            if (QuestChainType == Const.MainQuestChainType) and Data:IsDoing() then
                Res.JumpQuestChainId = QuestChainId
                break
            end
        end
        Res.IsShowLock = true
        Res.IsForbidClick = false
    else
        -- 配置的主线任务链已解锁，跳转到该任务界面
        Res.JumpQuestChainId = ConfigedMainQuestChainId
        Res.IsShowLock = false
        if ConfigedMainQuestChainState == "Doing" then
            Res.IsForbidClick = false
            Res.IsShowFinish = false
        else
            Res.IsForbidClick = true
            Res.IsShowFinish = true
        end
    end
    local ChapterName = DataMgr.QuestChain[ConfigedMainQuestChainId].ChapterName or ""
    local QuestChainName = DataMgr.QuestChain[ConfigedMainQuestChainId].QuestChainName or ""
    Res.DisplayTextName = GText(ChapterName) .. "·" .. GText(QuestChainName)

    return Res
end

-- return table
-- {
--      DisplayTextName = string,
--      IsShowLock = bool,
--      IsForbidClick = bool,
--      IsShowFinish = bool,
--      IsShowTip = bool,
--      JumpQuestChainId = int,
-- }
function M:GetSideQuestInfo()
    local Res = {}

    local ConfigedSideQuestChainIds = self.EventInfo.PretextTasks2
    if not ConfigedSideQuestChainIds then
        return Res
    end
    local FirstDoingQuestChainId = 0
    local IsAllFinished = true
    for _, SideQuestChainId in pairs(ConfigedSideQuestChainIds) do
        local SideQuestChainState = self:GetQuestChainState(SideQuestChainId)
        IsAllFinished = IsAllFinished and (SideQuestChainState == "Finish")
        if SideQuestChainState == "Doing" then
            FirstDoingQuestChainId = SideQuestChainId
            break
        end
    end

    local LastQuestChainId = ConfigedSideQuestChainIds[#ConfigedSideQuestChainIds]
    local ChapterName = DataMgr.QuestChain[LastQuestChainId].ChapterName or ""
    local QuestChainName = DataMgr.QuestChain[LastQuestChainId].QuestChainName or ""
    Res.DisplayTextName = GText(ChapterName) .. "·" .. GText(QuestChainName)

    Res.IsShowLock = FirstDoingQuestChainId ~= LastQuestChainId     -- 仅在正在进行的任务链Id为配置的最后一个任务链Id时，显示已解锁状态（即，只要最后一个任务链Id未解锁，就显示未解锁）
    Res.IsForbidClick = IsAllFinished                               -- 仅所有任务完成，才不可点击
    Res.IsShowTip = FirstDoingQuestChainId == 0                     -- 若没有已解锁的支线任务，点击会弹tips
    Res.JumpQuestChainId = FirstDoingQuestChainId                   -- 跳转到正在进行的任务（若为0，会弹tips
    Res.IsShowFinish = IsAllFinished                                -- 如果所有的任务都完成了，显示完成状态

    return Res
end

function M:GetQuestChainState(QuestChainId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return ""
    end
    -- ljl: 只要是合法的QuestChainId，我都能 Avatar.QuestChains[QuestChainId] 拿到吗
    -- zjt: 前提是玩家已经获取到了这个任务链
    -- 那我就当玩家没接这个任务链处理了
    if not Avatar.QuestChains[QuestChainId] then
        return "Unlock"
    end

    if Avatar.QuestChains[QuestChainId]:IsFinish() then
        return "Finish"
    elseif Avatar.QuestChains[QuestChainId]:IsDoing() then
        return "Doing"
    else
        return "Unlock"
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
