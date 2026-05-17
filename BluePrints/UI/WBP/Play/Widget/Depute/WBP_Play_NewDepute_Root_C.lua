--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Play_DeputeRoot_P_C
local M = Class({ "BluePrints.UI.BP_UIState_C" })

function M:Construct()
    M.Super.Construct(self)
    self.IsPC = CommonUtils.GetDeviceTypeByPlatformName(self) == "PC"
    self:AddInputMethodChangedListen()
    EventManager:AddEvent(EventID.OnDungeonsUpdate, self, self.OnDungeonsUpdate)
    self:OpenDeputeUI("Regular")
    self:InitTab()

    self.SubUIJumpFunc = function(Root, ...)
        local args = {...}
        local deputeType = args[1]
        local index = self:GetDeputeTabIndex(deputeType)
        if deputeType == "NightBook" then
            if args[2] then
                self.JumpNightBooKTabName = args[2]
                local PlayEntry =  UIManager(self):GetUIObj("StyleOfPlay")
                if PlayEntry then
                    PlayEntry.SubUI["DungeonSelect"] = nil
                end
            end
        end
        self.DeputeTab:SelectTab(index)
        self.JumpNightBooKTabName = nil
    end
end

function M:GetDeputeTabIndex(deputeType)
    local deputeTabMap = {
        ["Regular"] = 1,
        ["NightBook"] = 2,
        ["Walnut"] = 3,
        ["WeeklySelectDungeon"] = 4
    }
    return deputeTabMap[deputeType] or 1
end

function M:Destruct()
    self:PlayAnimation(self.Out)
end

-- 刷新委托内容
function M:RefreshDepute(ui, uiName)
    if ui then
        ui:InitContent(self)
    else
        print("Error: " .. uiName .. " SL is not initialized.")
    end
end


--打开指定的委托
function M:OpenDeputeUI(deputeType)
    if self.DeputeTabType == deputeType and IsValid(self[deputeType .. "UI"]) then
        return -- 已经是同一个页面，不重复刷新
    end
    self.DeputeTabType = deputeType
    self.PanelRoot:ClearChildren()

    local uiName = deputeType .. "UI"
    if not IsValid(self[uiName]) then
        self[uiName] = UIManager(self):_CreateWidgetNew("Depute_" .. deputeType)
    end

    local ui = self[uiName]
    self.PanelRoot:AddChild(ui)
    local Slot = ui.Slot
    Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    self:RefreshDepute(ui, uiName)
end


-- 初始化 Tab 页
function M:InitTab()
    local SubTabList = {}
    local PlayTabInfo = {}

    local Avatar = GWorld:GetAvatar()
    if Avatar == nil then return end


    -- 排序
        for _, Data in pairs(DataMgr.PlaySubTab) do
            if Data.WidgetUI == "NewDeputeRoot" then
                local bUnlocked = true
                if Data.SubTabUnlockRuleId then
                    bUnlocked = Avatar:CheckUIUnlocked(Data.SubTabUnlockRuleId)
                end
                if bUnlocked then
                    table.insert(PlayTabInfo, Data)
                end
            end
        end

    if #PlayTabInfo < 2 then
        self.DeputeTab:SetVisibility(ESlateVisibility.Collapsed)
        return
    else
        self.DeputeTab:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end

    table.sort(PlayTabInfo, function(a, b)
        return a.Sequence > b.Sequence
    end)

    self.PlayTabInfo = PlayTabInfo

    for i, Data in ipairs(PlayTabInfo) do
        local SubTab = {
            Text = GText(Data.SubTabName),
            Img = Data.EnterImage,
            TabId = i,
        }
        if Data.SubWidgetUI == "DeputeNightBook" then
            SubTab.TipsData = {
                TipsName = GText("UI_JingLi_NoCost"),
                Icon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_Coin_Other_Jingli.T_Coin_Other_Jingli",
            }
        end
        table.insert(SubTabList, SubTab)
    end

    -- 初始化 Tab 控件
    self.DeputeTab:Init({
        LeftKey = "A",
        RightKey = "D",
        Tabs = SubTabList,
        ChildWidgetBPPath = "/Game/UI/WBP/Play/Widget/Depute/WBP_Depute_TabSubItem.WBP_Depute_TabSubItem",
        SoundFunc = function ()
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_02", nil, nil)
        end,
    })
    self.DeputeTab:SelectTab(1)
    self.DeputeTab:BindEventOnTabSelected(self, self.OnSubTabChanged)
end

-- Tab 选择变化
function M:OnSubTabChanged(TabWidget)
    local SubTabData = self.PlayTabInfo[TabWidget.Idx]
    if not SubTabData then
        return
    end

    if SubTabData.SubWidgetUI == "NewDeputeRoot" then
        self:OpenDeputeUI("Regular")
    elseif SubTabData.SubWidgetUI == "DeputeNightBook" then
        self:OpenDeputeUI("NightBook")
    elseif SubTabData.SubWidgetUI == "DeputeWalnut" then
        self:OpenDeputeUI("Walnut")
    elseif SubTabData.SubWidgetUI == "WeeklySelectDungeon" then
        self:OpenDeputeUI("WeeklySelectDungeon")
    end
end

-- 处理按键事件
function M:HandleKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    -- self.DeputeTab:Handle_KeyEventOnPC(InKeyName)

    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self.DeputeTab:Handle_KeyEventOnGamePad(InKeyName)
    else
        if InKeyName == "A" then
            if self.DeputeTab then
                self.DeputeTab:TabToLeft()
                IsEventHandled = true
            end
        elseif InKeyName == "D" then
            if self.DeputeTab then
                self.DeputeTab:TabToRight()
                IsEventHandled = true
            end
        end
    end
    return IsEventHandled
end

--刷新密函委托
function M:OnDungeonsUpdate()
    if self["Depute_WalnutUI"] then
        self:RefreshDepute(self["Depute_WalnutUI"], "Depute_Walnut")
    end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then return UE4.UWidgetBlueprintLibrary.Unhandled() end
    if (self:HasFocusedDescendants() or self:HasAnyUserFocus()) then
        -- self:AddTimer(0.01, function()

        -- end, false, 0, "DeputeDetailListView")
        if self.DeputeTabType == "Regular" then
            self.RegularUI.List_Depute:NavigateToIndex(0)
        elseif self.DeputeTabType == "NightBook" then
            --self.NightBookUI.List_NightBookItem:SetFocus()
            self.NightBookUI.List_NightBookItem:NavigateToIndex(0)
        elseif self.DeputeTabType == "Walnut" then
            --self.WalnutUI.List_Walnut:NavigateToIndex(0)
        elseif self.DeputeTabType == "WeeklySelectDungeon" then
            self.WeeklySelectDungeonUI.List_Weekly:SetFocus()
        end
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:SwitchIn()
    self:UpdatKeyDisplay()
end

-- function M:SetTabFocus()
--     if not UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
--        return
--     end
--     self:UpdatKeyDisplay()
--     if self.DeputeTabType == "Regular" then
--         self.RegularUI.List_Depute:NavigateToIndex(0)
--     elseif self.DeputeTabType == "NightBook" then
--         self.NightBookUI.List_NightBookItem:NavigateToIndex(0)
--     elseif self.DeputeTabType == "Walnut" then
--         self.WalnutUI.List_Walnut:NavigateToIndex(0)
--     end
--     -- self:AddTimer(0.01, function()
--     -- end, false, 0, "DeputeRoot_P")
-- end
function M:UpdatKeyDisplay()
    -- if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "PC" then
    --     return
    -- end
    if not UIUtils.IsGamepadInput() then
        local Item = UIManager(self):GetUIObj("StyleOfPlay")
        if not Item then
            return
        end
        local BottomKeyInfo = {}
        -- 通用的按键信息
        BottomKeyInfo = {
            {
                KeyInfoList = { { Type = "Text", Text = "Esc",ClickCallback =  self.CloseSelf, Owner = self } },
                GamePadInfoList = {
                    { Type = "Img", ImgShortPath = "B", Owner = self }
                },
                Desc = GText("UI_BACK"),
            }
        }
        -- 更新界面按键提示
        Item:UpdateOtherPageTab(BottomKeyInfo)
    end
end

function M:CloseSelf()
    local Item = UIManager(self):GetUIObj("StyleOfPlay")
    self:PlayAnimation(self.Out)
    Item:OnClickBack()
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 输入设备切换通知
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    local ActiveWidgetIndex = IsUseKeyAndMouse and 0 or 1
    if (IsUseKeyAndMouse) then
        self:UpdatKeyDisplay()
        -- PC逻辑
    else
        if (self:HasFocusedDescendants() or self:HasAnyUserFocus()) then
            -- if self.DeputeTabType == "Regular" then
            --     self.RegularUI.List_Depute:NavigateToIndex(0)
            -- elseif self.DeputeTabType == "NightBook" then
            --     --self.NightBookUI.List_NightBookItem:SetFocus()
            --     self.NightBookUI.List_NightBookItem:NavigateToIndex(0)
            -- elseif self.DeputeTabType == "Walnut" then
            --     self.WalnutUI.List_Walnut:NavigateToIndex(0)
            -- elseif self.DeputeTabType == "WeeklySelectDungeon" then
            --     self.WeeklySelectDungeonUI.List_Weekly:SetFocus()
            -- end
        end
    end
    --self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

return M
