--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Play_TaskRoot_P_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"
---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self:InitTab()
end

function M:Destruct()
    if self.WidgetNameToIndex then
        for WidgetName,_ in pairs(self.WidgetNameToIndex) do
            if DataMgr.ReddotNode[WidgetName] then
                ReddotManager.RemoveListener(WidgetName, self)
            end
        end
    end
end
-- 初始化 Tab 页
function M:InitTab()
    local Avatar = GWorld:GetAvatar()
    if Avatar == nil then return end
    local SubTabList = {}
    local PlayTabInfo = {}
    -- 排序
    for _, Data in pairs(DataMgr.PlaySubTab) do
        if Data.WidgetUI == "PlayTaskRoot" then
            if Data.SubTabUnlockRuleId then
                local bUnlocked = Avatar:CheckUIUnlocked(Data.SubTabUnlockRuleId)
                if bUnlocked then
                    table.insert(PlayTabInfo, Data)
                end
            end
        end
    end

    if #PlayTabInfo < 2 then
        self.Tab:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Tab:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    table.sort(PlayTabInfo, function(a, b)
        return a.Sequence > b.Sequence
    end)
    self.PlayTabInfo = PlayTabInfo
    local SelectTabIndex = nil
    local IsSelectStartQuest = not ActivityUtils.CheckStarterQuestAllDone()
    for i, Data in ipairs(PlayTabInfo) do
        local SubTab = {
            Text = GText(Data.SubTabName),
            Img = Data.EnterImage,
            TabId = i,
        }
        if Data.SubWidgetUI == "StarterQuest" then 
            SelectTabIndex = IsSelectStartQuest and i or SelectTabIndex
        elseif not SelectTabIndex then
            SelectTabIndex = i
        end
        table.insert(SubTabList, SubTab)
    end

    -- 初始化 Tab 控件
    self.Tab:Init({
        LeftKey = "A",
        RightKey = "D",
        Tabs = SubTabList,
        ChildWidgetBPPath = "/Game/UI/WBP/Play/Widget/Depute/WBP_Depute_TabSubItem.WBP_Depute_TabSubItem",
        SoundFunc = function ()
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_02", nil, nil)
        end,
    })
    self.Tab:BindEventOnTabSelected(self, self.OnSubTabChanged)
    self.Tab:SelectTab(SelectTabIndex or 1)
    self.WidgetNameToIndex = {}
    for i, Data in ipairs(PlayTabInfo) do
        local WidgetName = Data.SubWidgetUI
        if DataMgr.ReddotNode[WidgetName] then
            self.WidgetNameToIndex[WidgetName] = i
            ReddotManager.AddListener(WidgetName, self, self["On" .. WidgetName .. "ReddotChange"])
        end
    end

end
function M:OnStarterQuestReddotChange()
    self:OnReddotChange("StarterQuest")
end
function M:OnDailyMainReddotChange()
    self:OnReddotChange("DailyMain")
end
function M:OnReddotChange(SystemUIName)
    local Index = self.WidgetNameToIndex[SystemUIName]
    if Index then
        local TreeNode = ReddotManager.GetTreeNode(SystemUIName)
        local Reddot = false
        if TreeNode and TreeNode.Count > 0 then
            Reddot = true
        end

        local Item = self.Tab.List_Tab:GetChildAt(math.max(Index - 1, 0))
        if Item then
            Item.Reddot:SetVisibility(Reddot and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
        end
    end
end
-- Tab 选择变化
function M:OnSubTabChanged(TabWidget)
    local SubTabData = self.PlayTabInfo[TabWidget.Idx]
    if not SubTabData then
        return
    end
    self:OnOpenTaskUI(SubTabData.SubWidgetUI)
end
--打开指定的委托
function M:SubUIJumpFunc(UIName)
    for Index,TabInfo in ipairs(self.PlayTabInfo) do 
        if TabInfo.SubWidgetUI == UIName then 
            self.Tab:SelectTab(Index)
            return
        end
    end
end
function M:OnOpenTaskUI(UIName)
    self.IsHideGamepadKey = nil
    self.PanelRoot:ClearChildren()

    if not IsValid(self[UIName]) then
        self[UIName] = UIManager(self):_CreateWidgetNew(UIName)
    end

    local WidgetUI = self[UIName]
    self.PanelRoot:AddChild(WidgetUI)
    local Slot = WidgetUI.Slot
    Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    if WidgetUI.InitContent then
        WidgetUI:InitContent(self)
    end
    self.CurSubUI = WidgetUI
    self.CurSubUI:SetFocus()
    self:PlayAnimationIn(WidgetUI, true)
end

function M:PlayAnimationIn(WidgetUI, bForce)
    if not WidgetUI or not WidgetUI.In then 
        return
    end
    if WidgetUI:IsPlayingAnimation(WidgetUI.In) then
        WidgetUI:StopAnimation(WidgetUI.In)
    end
    WidgetUI:PlayAnimation(WidgetUI.In)
end

function M:SwitchIn()
    if not self.CurSubUI then 
        return 
    end
    if self.CurSubUI.SwitchIn then 
        self.CurSubUI:SwitchIn()
    end
    self:PlayAnimationIn(self.CurSubUI, false)
    -- if self.CurSubUI.SetNavigateToIndex then
    --     self.CurSubUI:SetNavigateToIndex()
    -- end
end
function M:SwitchGamepadKeyShow(IsShow)
    self.Tab:UpdateUIStyleInPlatform(IsShow)
    self.IsHideGamepadKey = not IsShow
end
-- 处理按键事件
function M:HandleKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if not self.IsHideGamepadKey then
            IsEventHandled = self.Tab:Handle_KeyEventOnGamePad(InKeyName)
        end
    else
        IsEventHandled = self.Tab:Handle_KeyEventOnPC(InKeyName)
    end
    return IsEventHandled
end
function M:BP_GetDesiredFocusTarget()
    if self.CurSubUI and self.CurSubUI.NodeName == "StarterQuest" and not UIUtils.HasAnyFocus(self.CurSubUI) then 
        return self.CurSubUI:ReGetDesiredFocusTarget()
    end
    return self.CurSubUI or self
end
return M
