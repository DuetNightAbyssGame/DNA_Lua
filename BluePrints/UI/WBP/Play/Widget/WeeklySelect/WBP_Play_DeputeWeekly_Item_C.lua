--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Play_DeputeWeekly_Item_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
local TypeSort = {
    Char = 1,
    Weapon = 2,
    Mod = 3,
    Draft = 4,
    Reward = 5,
    Resource = 6,
}
---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    M.Super.Construct(self)
    self:AddInputMethodChangedListen()
    self.IsPC = CommonUtils.GetDeviceTypeByPlatformName(self) == "PC"
    self.Button_LeftClick.OnClicked:Add(self, self.OnClicked)
    self.Button_LeftClick.OnPressed:Add(self, self.OnPressed)
    self.Button_LeftClick.OnReleased:Add(self, self.OnReleased)
    self.Button_LeftClick.OnHovered:Add(self, self.OnHovered)
    self.Button_LeftClick.OnUnhovered:Add(self, self.OnBtnUnhovered)
    self.List_Reward:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    self.List_Reward:SetNavigationRuleBase(EUINavigation.Right,EUINavigationRule.Stop)
    self.List_Reward:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.List_Reward:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.ChapterId = Content.ChapterId
    self.Parent = Content.Parent
    self.IsEmpty = Content.IsEmpty
    self.DeputeWeekly = Content.DeputeWeekly
    self:InitItemContent()
end

function M:InitItemContent()
    if  self.IsEmpty then
        self.WS_Item:SetActiveWidgetIndex(1)
        return
    end
    self.WS_Item:SetActiveWidgetIndex(0)
    local ChapterData = DataMgr.WeeklySelectDungeon[self.ChapterId]
    if not ChapterData then
        DebugPrint("SL_找不到关卡数据:", self.ChapterId)
        return
    end
    --- 加载关卡图片
    local ChapterIcon = LoadObject(ChapterData.Path)
    local Material = self.Image_ItemIcon:GetDynamicMaterial()
    if Material then
        Material:SetTextureParameterValue("IconMap", ChapterIcon)
    end
    --- 加载关卡名称
    self.Text_PlayName:SetText(GText(ChapterData.ChapterName))

    self.Text_PlayDesc:SetText(GText(ChapterData.ChapterSubName))

    --- 判断是否解锁
    self:PlayAnimation(self.In)
    if PageJumpUtils:CheckDungeonCondition(ChapterData.Condition) then
        self.IsUnLocked = false
        self:PlayAnimation(self.Normal) --Normal
        self.Group_Lock:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.IsUnLocked = true
        self:PlayAnimation(self.Lock)
        self.Group_Lock:SetVisibility(ESlateVisibility.Visible)
    end
    self:RefreshRewardInfoList(ChapterData.RewardViewId)
    -- self.Key_RewardTitle:SetVisibility(UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and ESlateVisibility.SelfHitTestInvisible or
    -- ESlateVisibility.Collapsed)
    -- self.Key_Title:SetVisibility(UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and ESlateVisibility.SelfHitTestInvisible or
    -- ESlateVisibility.Collapsed)
    self.Key_RewardTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Key_Title:SetVisibility(UE4.ESlateVisibility.Collapsed)

    self.Text_RewardItem:SetText(GText("UI_DUNGEON_ObtainType"))
    self.Text_GetTask:SetText(GText("UI_DUNGEON_Enter"))

end

function M:InitWidgetInfoInGamePad()
    if (UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad) then
        return
    end
    self.Key_RewardTitle:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Key_RewardTitle:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "LS",
            }
        },
        bLongPress = false,
        --Desc = GText('UI_CTL_Squad_Expand'),
    })

    self.Key_Title:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Key_Title:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "A",
            }
        },
        bLongPress = false,
        --Desc = GText('UI_CTL_Squad_Expand'),
    })


end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    if self.IsEmpty then return end
    --- 输入设备切换通知
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    --self.Parent.DeputeTab:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    if not IsUseKeyAndMouse then
        -- self:InitWidgetInfoInGamePad()
        -- self:UpdatKeyDisplay("SelfWidget")
    else
        self.Key_RewardTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Key_Title:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self:PlayAnimationReverse(self.GamePadSelected)
    end

    self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

-- 更新奖励信息列表
---@param DungeonReward number[] @奖励Id列表[RewardView]
function M:RefreshRewardInfoList(DungeonReward)
    if not DungeonReward then
        DebugPrint("SL DungeonReward is nil")
        return
    end
    local RewardList = RewardUtils:GetRewardViewInfoById(DungeonReward)
    table.sort(RewardList, function(A, B)
        if A.Rarity == B.Rarity then
            if TypeSort[A.Type] and TypeSort[B.Type] then
                if TypeSort[A.Type] == TypeSort[B.Type] then
                    return A.Id < B.Id
                end
                return TypeSort[A.Type] < TypeSort[B.Type]
            end
            return A.Id < B.Id
        end
        return A.Rarity > B.Rarity
    end)


    for _, ItemData in pairs(RewardList) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
            Content.Id = ItemData.Id
            Content.Icon = ItemUtils.GetItemIconPath(ItemData.Id, ItemData.Type)
            Content.ParentWidget = self
            Content.ItemType = ItemData.Type
            Content.Rarity = ItemData.Rarity or 1
            Content.IsShowDetails = true
            Content.UIName = "StyleOfPlay"
            --Content.HandleMouseDown = true

            if ItemData.Quantity then
                if #ItemData.Quantity > 1 then
                    Content.Count = ItemData.Quantity[1]
                    Content.MaxCount = ItemData.Quantity[2]
                else
                    Content.Count = ItemData.Quantity[1]
                end
            end
            self.List_Reward:AddItem(Content)
        end

        if self:IsExistTimer(self.NextFrameListEmpty) then
            self:RemoveTimer(self.NextFrameListEmpty)
        end
    --- 用空Item补全ListView, 加定时器是因为隔一帧才能拿到已生成的Entry
    self.NextFrameListEmpty = self:AddTimer(0.01, function()
        local len = self.List_Reward:GetNumItems()
        for i = 1, len do
            local entryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Reward, i - 1)
            if entryWidget then
                entryWidget:BindEvents(self, {
                    OnMenuOpenChanged = self.OnStuffMenuOpenChanged,
                })
            end
        end

        local RewardItemUIs = self.List_Reward:GetDisplayedEntryWidgets()
        local RestCount = UIUtils.GetListViewContentMaxCount(self.List_Reward, RewardItemUIs, true) -
            RewardItemUIs:Length()
        for i = 1, RestCount do
            self:CreateAndAddEmptyItem()
        end

    end, false, 0, "DeputeWeeklyListView")
end

function M:CreateAndAddEmptyItem()
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    -- Content.IsEmpty = true
    Content.Id = 0
    self.List_Reward:AddItem(Content)
end

function M:OnClicked()
    if self:IsAnimationPlaying(self.In) then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    local ChapterData = DataMgr.WeeklySelectDungeon[self.ChapterId]
    if ChapterData and PageJumpUtils:CheckDungeonCondition(ChapterData.Condition, true) then
        if not self.Parent.Root:IsAnimationPlaying(self.Parent.Root.Out) and not self:IsAnimationPlaying(self.Click) then
            local Item = UIManager(self):GetUIObj("StyleOfPlay")
            Item.IsOpenSelectLevel = true
            self.Clicked = true
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
            self:StopAllAnimations()
            self:PlayAnimation(self.Click)
        end
    else
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_select_lock", nil, nil)
    end
end

function M:OnPressed()
    if self.IsUnLocked or self:IsAnimationPlaying(self.In) then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Press)
end

function M:OnReleased()
    if self.IsUnLocked or self:IsAnimationPlaying(self.In) then
        return
    end
    self:PlayAnimation(self.Normal)
end

function M:OnHovered()
    if self.IsEmpty then return end
    AudioManager(self):PlayUISound(self, "event:/ui/common/hover_btn_large", nil, nil)
    if self.IsUnLocked or not self.IsPC then --or not self.IsPC--or CommonUtils.GetDeviceTypeByPlatformName()=="Mobile"
        return
    end
    self:StopAnimation(self.Unhover)
    self:PlayAnimation(self.Hover)
end

function M:OnBtnUnhovered()
    if self.IsUnLocked  or not self.IsPC then  --or self:IsAnimationPlaying(self.In)
        return
    end
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.Unhover)
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
    if self.IsUnLocked or  UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then --or not self.IsPC--or CommonUtils.GetDeviceTypeByPlatformName()=="Mobile"
        return
    end
    self:OnClicked()
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
    if self.IsEmpty then return end
    if self.IsUnLocked or  UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then --or not self.IsPC--or CommonUtils.GetDeviceTypeByPlatformName()=="Mobile"
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/hover_btn_large", nil, nil)
    --self:InitWidgetInfoInGamePad()
    self:PlayAnimation(self.GamePadSelected)
    if not self.bfMenuIsOpen then
        self:InitWidgetInfoInGamePad()
    end
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
    if self.IsEmpty then return end
    if self.IsUnLocked  or  UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then  --or self:IsAnimationPlaying(self.In)
        return
    end
    self.Key_RewardTitle:SetVisibility(ESlateVisibility.Collapsed)
    self.Key_Title:SetVisibility(ESlateVisibility.Collapsed)
    self:PlayAnimationReverse(self.GamePadSelected)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        if self.IsUnLocked or self:IsAnimationPlaying(self.In) or not self.IsPC then --or not self.IsPC--or CommonUtils.GetDeviceTypeByPlatformName()=="Mobile"
            return UE4.UWidgetBlueprintLibrary.Unhandled()
        end
        self:UpdatKeyDisplay("FocusSelfWidget")
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.Click then
        local Item = UIManager(self):GetUIObj("StyleOfPlay")
        Item.IsOpenSelectLevel = false
        local SelectLevel = Item:OpenSubUI("DungeonSelect")
        local DungeonList = DataMgr.WeeklySelectDungeon[self.ChapterId].DungeonList
        SelectLevel:InitLevelList(DungeonList, nil, Const.DeputeType.DeputeWeekly)
        Item:InitOtherPageTab({
            DynamicNode = { "Back", "ResourceBar", "BottomKey" },
            BottomKeyInfo = {
                {
                    GamePadInfoList = {
                        { Type = "Add" },
                        GamePadSubKeyInfoList = {
                            { Type = "Img", ImgShortPath = "Up", Owner = SelectLevel },
                            { Type = "Img", ImgShortPath = "Y", Owner = SelectLevel }
                        }
                    },
                    Desc = GText("UI_CTL_DeputeInfo"),
                    bLongPress = false,
                },
                {
                    KeyInfoList = { { Type = "Text", Text = "Esc", ClickCallback = SelectLevel.OnReturnKeyDown, Owner = SelectLevel } },
                    GamePadInfoList = { { Type = "Img", ImgShortPath = "B", Owner = SelectLevel } },
                    Desc = GText("UI_BACK")
                }
            },
            OwnerPanel = SelectLevel,
            BackCallback = SelectLevel.OnReturnKeyDown,
            StyleName = "Text",
            TitleName = GText("DUNGEON_WEEK"),
            -- PopupInfoId = 100124,
            -- InfoCallback = SelectLevel.ShowIntro
        }, nil, true)
    end
end

-- 更新按键显示
function M:UpdatKeyDisplay(FocusTypeName)
    if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
        return
    end
    local StyleOfPlay = UIManager(self):GetUIObj("StyleOfPlay")
    if not StyleOfPlay then
        return
    end

    if FocusTypeName == "RewardWidget" then
        local BottomKeyInfo = {
            {
                GamePadInfoList = {
                    { Type = "Img", ImgShortPath = "A", Owner = self }
                },
                Desc = GText("UI_Controller_CheckDetails"),
                bLongPress = false,
            },
            {
                KeyInfoList = { { Type = "Text", Text = "Esc", Owner = self } },  -- ClickCallback = self.Parent.CloseSelf,
                GamePadInfoList = {
                    { Type = "Img", ImgShortPath = "B", Owner = self }
                },
                Desc = GText("UI_BACK"),
            },

        }
        StyleOfPlay.ComTab.Left_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.Right_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Key_RewardTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Key_Title:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Parent.DeputeTab:UpdateUIStyleInPlatform(false)
        self.DeputeWeekly:SetBtn_ShopExChangeState(false)
        -- 更新界面按键提示
        StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
    elseif FocusTypeName == "SelfWidget" or FocusTypeName == "FocusSelfWidget"  then
        local BottomKeyInfo = {
            {
                KeyInfoList = { { Type = "Text", Text = "Esc", Owner = self } },
                GamePadInfoList = {
                    { Type = "Img", ImgShortPath = "B", Owner = self }
                },
                Desc = GText("UI_BACK"),
            },

        }
        StyleOfPlay.ComTab.Left_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        StyleOfPlay.ComTab.Right_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.DeputeWeekly:SetBtn_ShopExChangeState(true)
        self:InitWidgetInfoInGamePad()
        if self.Parent and self.Parent.DeputeTab then
            local bIsOther = FocusTypeName ~= "SelfWidget"
            self.Parent.DeputeTab:UpdateUIStyleInPlatform(true, bIsOther)
        end
        StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
    else
        local BottomKeyInfo = {}
        StyleOfPlay.ComTab.Left_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.Right_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Key_RewardTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Key_Title:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Parent.DeputeTab:UpdateUIStyleInPlatform(false)
        -- self.Parent.DeputeTab.Key_Left:ClearChildren()
        -- self.Parent.DeputeTab.Key_Right:ClearChildren()
        -- 更新界面按键提示
        StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    end
    if (IsEventHandled) then
        return UWidgetBlueprintLibrary.Handled()
    else
        return UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:OnGamePadDown(InKeyName)
    --DebugPrint("SL OnGamePadDown is InKeyName", InKeyName)
    local IsEventHandled = false
    if InKeyName == "Gamepad_LeftThumbstick" then
        local RewardItemUIs = self.List_Reward:GetDisplayedEntryWidgets()
        if not RewardItemUIs[1]:HasAnyUserFocus() then
            self.List_Reward:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.List_Reward:NavigateToIndex(0)
            self.FocusName = "List_Reward"
            self:UpdatKeyDisplay("RewardWidget")
            IsEventHandled = true
        else
            self:SetFocus()
            self.FocusName = "self"
            self:UpdatKeyDisplay("SelfWidget")
            self.List_Reward:SetVisibility(ESlateVisibility.HitTestInvisible)
            IsEventHandled = true
        end
    elseif InKeyName == "Gamepad_FaceButton_Right" then
        local RewardItemUIs = self.List_Reward:GetDisplayedEntryWidgets()
        for i = 1, RewardItemUIs:Length() do
            if RewardItemUIs[i]:HasFocusedDescendants() or RewardItemUIs[i]:HasAnyUserFocus() then
                self:SetFocus()
                 self.FocusName = "self"
                self:UpdatKeyDisplay("SelfWidget")
                self.List_Reward:SetVisibility(ESlateVisibility.HitTestInvisible)
                IsEventHandled = true
                break
            end
        end
    elseif InKeyName == "Gamepad_FaceButton_Top" and  self.FocusName ~= "List_Reward"then
        self.DeputeWeekly:OnGoToSystem()
    else
        local RewardItemUIs = self.List_Reward:GetDisplayedEntryWidgets()
        for i = 1, RewardItemUIs:Length() do
            if RewardItemUIs[i]:HasFocusedDescendants() or RewardItemUIs[i]:HasAnyUserFocus() then
                IsEventHandled = true
                break
            end
        end
    end
    return IsEventHandled
end

function M:OnStuffMenuOpenChanged(bIsOpen)
    if (UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad) then
        return
    end
    self.bfMenuIsOpen = bIsOpen
    if (bIsOpen) then
        self:UpdatKeyDisplay("")
    else
        self:UpdatKeyDisplay("RewardWidget")
    end
end

return M
