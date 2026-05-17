--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Play_DeputeItem_P_C
local M = Class({ "BluePrints.UI.BP_UIState_C" })

local TypeSort = {
    Char = 1,
    Weapon = 2,
    Mod = 3,
    Draft = 4,
    Reward = 5,
    Resource = 6,
}
--function M:Initialize(Initializer)
--end

function M:Construct()
    M.Super.Construct(self)
    self:AddInputMethodChangedListen()
    self.IsPC = CommonUtils.GetDeviceTypeByPlatformName(self) == "PC"
    self.Panel_DeputeLevelItem:SetRenderOpacity(0)
    self.Btn_Click.OnClicked:Add(self, self.OnClicked)
    self.Btn_Click.OnPressed:Add(self, self.OnPressed)
    self.Btn_Click.OnReleased:Add(self, self.OnReleased)
    -- self.Btn_Click.OnHovered:Add(self, self.OnHovered)
    -- self.Btn_Click.OnUnhovered:Add(self, self.OnUnhovered)

    self:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    -- self:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    -- self:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)

    self.Item1:SetNavigationRuleExplicit(EUINavigation.Right, self.Item2)
    self.Item2:SetNavigationRuleExplicit(EUINavigation.Right, self.Item3)
    self.Item3:SetNavigationRuleExplicit(EUINavigation.Right, self.Item1)

    self.Item1:SetNavigationRuleExplicit(EUINavigation.Left, self.Item3)
    self.Item2:SetNavigationRuleExplicit(EUINavigation.Left, self.Item1)
    self.Item3:SetNavigationRuleExplicit(EUINavigation.Left, self.Item2)
    self:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)

end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end

    --- 输入设备切换通知
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    self.Parent.DeputeTab:UpdateUIStyleInPlatform(not IsUseKeyAndMouse)
    local StyleOfPlay = UIManager(self):GetUIObj("StyleOfPlay")
    if  StyleOfPlay and StyleOfPlay.ComTab and  StyleOfPlay.ComTab.Group_Chat and StyleOfPlay.ComTab.Group_Chat:GetChildAt(0) then
        StyleOfPlay.ComTab.Group_Chat:GetChildAt(0).bOpen = true
        StyleOfPlay.ComTab.Group_Chat:GetChildAt(0):HideWSKey(true)
    end

    if IsUseKeyAndMouse then
        if  self.Com_Show then
            self.Com_Show:SetVisibility(ESlateVisibility.Collapsed)
        end
        if not self.IsUnLocked then
            self:StopAnimation(self.Hover)
            self:PlayAnimation(self.Unhover)
            self.bIsHovered = false
        end

    end

    self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end
function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.ChapterId = Content.ChapterId
    self.Parent = Content.Parent
    self:InitItemContent()
end

function M:InitItemContent()
    local ChapterData = DataMgr.SelectDungeon[self.ChapterId]
    if not ChapterData then
        DebugPrint("SL_找不到关卡数据:", self.ChapterId)
        return
    end
    self.bIsHovered = false
    --- 加载关卡图片
    local ChapterIcon = LoadObject(ChapterData.Path)
    local Material = self.Image_Item:GetDynamicMaterial()
    if Material then
        Material:SetTextureParameterValue("IconMap", ChapterIcon)
    end
    --- 加载关卡名称
    self.Text_PlayName:SetText(GText(ChapterData.ChapterName))

    self.Text_RewardItem:SetText(GText(ChapterData.ChapterSubName))

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

    local maxItems = 3 -- 限制最多显示的项数

    -- 从 RewardList 筛选出前三个奖励
    local SelectedRewards = {}
    for i, ItemData in pairs(RewardList) do
        if #SelectedRewards >= maxItems then
            break
        end
        table.insert(SelectedRewards, ItemData)
    end

    for i = 1, maxItems do
        local Cell = self["Item" .. i]

        if Cell then
            local Data = SelectedRewards[i]
            local Content = NewObject(UIUtils.GetCommonItemContentClass())
            if Data then
                Content.Id = Data.Id
                Content.Icon = ItemUtils.GetItemIconPath(Data.Id, Data.Type)
                Content.ParentWidget = self
                Content.ItemType = Data.Type
                Content.Rarity = Data.Rarity or 1
                Content.IsShowDetails = true
                Content.UIName = "StyleOfPlay"
                Content.HandleMouseDown = true
                Content.bAsyncLoadIcon = true

                if Data.Quantity then
                    if #Data.Quantity > 1 then
                        Content.Count = Data.Quantity[1]
                        Content.MaxCount = Data.Quantity[2]
                    else
                        Content.Count = Data.Quantity[1]
                    end
                end

                -- 只绑定一次，避免重复回调
                if not Cell.__OnMenuOpenChanged__ then
                    Cell.__OnMenuOpenChanged__ = function(_, bIsOpen)
                        self:OnStuffMenuOpenChanged(bIsOpen)
                    end
                    Cell:BindEvents(self, {
                        OnMenuOpenChanged = Cell.__OnMenuOpenChanged__,
                    })
                end

                -- 可交互 & 可见
                Cell.bIsFocusable = true
                if Cell.SetVisibility then
                    Cell:SetVisibility(ESlateVisibility.Visible)
                end
            else
                Cell.bIsFocusable = false
                if Cell.SetVisibility then
                    Cell:SetVisibility(ESlateVisibility.HitTestInvisible)
                end

                -- 调整上一格的导航，避免指向空格子
                local Prev = self["Item" .. (i - 1)]
                if Prev and Prev.SetNavigationRuleBase then
                    Prev:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
                    Prev:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
                    Prev:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
                    Prev:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
                end
            end
            Cell:Init(Content)
        end
    end
end

function M:OnStuffMenuOpenChanged(bIsOpen)
    if (UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad) then
        return
    end
    if (bIsOpen) then
        self:UpdatKeyDisplay("")
    else
        self:UpdatKeyDisplay("RewardWidget")
    end
end

function M:OnClicked()
    if self:IsAnimationPlaying(self.In) then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    local ChapterData = DataMgr.SelectDungeon[self.ChapterId]
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

-- function M:OnFocusReceived(MyGeometry, InFocusEvent)
--     -- if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
--     --     self:UpdatKeyDisplay("FocusSelfWidget")
--     --     if self.IsUnLocked or self:IsAnimationPlaying(self.In) or not self.IsPC then --or not self.IsPC--or CommonUtils.GetDeviceTypeByPlatformName()=="Mobile"
--     --         return UE4.UWidgetBlueprintLibrary.Unhandled()
--     --     end
--     --     self:StopAllAnimations()
--     --     self:PlayAnimation(self.Hover)
--     -- end
--     return UE4.UWidgetBlueprintLibrary.Unhandled()
-- end

function M:OnMouseEnter(MyGeometry, MouseEvent)
    if self.IsUnLocked or not self.IsPC then --or not self.IsPC--or CommonUtils.GetDeviceTypeByPlatformName()=="Mobile"
        return
    end
    if self.bIsHovered then
        -- 已经悬停，不再重复执行
        return
    end
    self.bIsHovered = true
    AudioManager(self):PlayUISound(self, "event:/ui/common/hover_btn_large", nil, nil)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:UpdatKeyDisplay("FocusSelfWidget")
        if self.IsUnLocked or self:IsAnimationPlaying(self.In) or not self.IsPC then --or not self.IsPC--or CommonUtils.GetDeviceTypeByPlatformName()=="Mobile"
            return UE4.UWidgetBlueprintLibrary.Unhandled()
        end
        self:StopAllAnimations()
        self:PlayAnimation(self.Hover)
    else
        self:StopAnimation(self.Unhover)
        self:PlayAnimation(self.Hover)

    end

end

function M:OnMouseLeave(MyGeometry, MouseEvent)
    if self.IsUnLocked or not self.IsPC then
        self.bIsHovered = false
        return
    end
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        if self:HasFocusedDescendants() or self:HasAnyUserFocus() then
            return
        end
        self.Com_Show:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.bIsHovered = false
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.Unhover)
end

function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.Click then
        local Item = UIManager(self):GetUIObj("StyleOfPlay")
        Item.IsOpenSelectLevel = false
        local SelectLevel = Item:OpenSubUI("DungeonSelect")
        local DungeonList = DataMgr.SelectDungeon[self.ChapterId].DungeonList
        SelectLevel:InitLevelList(DungeonList)
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
                    KeyInfoList = { { Type = "Text", Text = "Esc",  ClickCallback = SelectLevel.OnReturnKeyDown, Owner = SelectLevel } },
                    GamePadInfoList = { { Type = "Img", ImgShortPath = "B", Owner = SelectLevel } },
                    Desc = GText("UI_BACK")
                }
            },
            OwnerPanel = SelectLevel,
            BackCallback = SelectLevel.OnReturnKeyDown,
            StyleName = "Text",
            TitleName = GText("UI_Dungeon_TabName"),
            -- PopupInfoId = 100124,
            -- InfoCallback = SelectLevel.ShowIntro
        }, nil, true)
        if (UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad) then
            return
        end
        SelectLevel:UpdatKeyDisplay("SelfWidget")
    elseif InAnimation == self.In and self.bIsHovered and not self.IsUnLocked then
        self:StopAllAnimations()
        self:PlayAnimation(self.Hover)
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
    DebugPrint("SL OnGamePadDown is InKeyName", InKeyName)
    local IsEventHandled = false
    if InKeyName == "Gamepad_LeftThumbstick" then
        --self.Item1:SetFocus()
        if not self.Item1:HasAnyUserFocus() or self.Item1:HasFocusedDescendants() then
            self.Item1:SetFocus()
            IsEventHandled = true
            self:UpdatKeyDisplay("RewardWidget")
        else
            for i = 1, 3 do
                if self["Item" .. i]:HasFocusedDescendants() or self["Item" .. i]:HasAnyUserFocus() then
                    self:SetFocus()
                    self:UpdatKeyDisplay("SelfWidget")
                    IsEventHandled = false
                    break
                end
            end
        end
    elseif InKeyName == "Gamepad_FaceButton_Right" then
        for i = 1, 3 do
            if self["Item" .. i]:HasFocusedDescendants() or self["Item" .. i]:HasAnyUserFocus() then
                self:SetFocus()
                self:UpdatKeyDisplay("SelfWidget")
                IsEventHandled = true
                break
            end
        end
    else
        for i = 1, 3 do
            if self["Item" .. i]:HasFocusedDescendants() or self["Item" .. i]:HasAnyUserFocus() then
                IsEventHandled = true
                break
            end
        end
    end
    return IsEventHandled
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

    self.FocusTypeName = FocusTypeName

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
                KeyInfoList = { { Type = "Text", Text = "Esc", ClickCallback = self.Parent.CloseSelf ,Owner = self } },
                GamePadInfoList = { 
                    { Type = "Img", ImgShortPath = "B", Owner = self }
                },
                Desc = GText("UI_BACK"),
            },

        }
        self.Com_Show:SetVisibility(ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.Left_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.Right_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Parent.DeputeTab:UpdateUIStyleInPlatform(false)
        if StyleOfPlay.ComTab and StyleOfPlay.ComTab.Group_Chat and StyleOfPlay.ComTab.Group_Chat:GetChildAt(0) then
            StyleOfPlay.ComTab.Group_Chat:GetChildAt(0).bOpen = false
            StyleOfPlay.ComTab.Group_Chat:GetChildAt(0):HideWSKey(false)
        end
        StyleOfPlay.TeamHeadUI.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        -- 更新界面按键提示
        StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
    elseif FocusTypeName == "SelfWidget" or FocusTypeName == "FocusSelfWidget" then
        local BottomKeyInfo = {
            -- {
            --     GamePadInfoList = {
            --         { Type = "Img", ImgShortPath = "LS", Owner = self }
            --     },
            --     Desc = GText("UI_Controller_CheckReward"),
            --     bLongPress = false,
            -- },
            {
                GamePadInfoList = {
                    { Type = "Img", ImgShortPath = "A", Owner = self }
                },
                Desc = GText("UI_Tips_Ensure"),
                bLongPress = false,
            },
            {
                KeyInfoList = { { Type = "Text", Text = "Esc", ClickCallback = self.Parent.CloseSelf, Owner = self } },
                GamePadInfoList = {
                    { Type = "Img", ImgShortPath = "B", Owner = self }
                },
                Desc = GText("UI_BACK"),
            },

        }
        self.Com_Show:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        -- 设置右下角按钮提示
        self.Com_Show:CreateCommonKey({
            KeyInfoList = {
                { Type = "Img", ImgShortPath = "LS" }
            }
        })
        StyleOfPlay.ComTab.Left_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        StyleOfPlay.ComTab.Right_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        if StyleOfPlay.ComTab and StyleOfPlay.ComTab.Group_Chat and StyleOfPlay.ComTab.Group_Chat:GetChildAt(0) then
            StyleOfPlay.ComTab.Group_Chat:GetChildAt(0).bOpen = true
            StyleOfPlay.ComTab.Group_Chat:GetChildAt(0):HideWSKey(true)
        end
        StyleOfPlay.TeamHeadUI.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Visible)
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
        if StyleOfPlay.ComTab and StyleOfPlay.ComTab.Group_Chat and StyleOfPlay.ComTab.Group_Chat:GetChildAt(0) then
            StyleOfPlay.ComTab.Group_Chat:GetChildAt(0).bOpen = false
            StyleOfPlay.ComTab.Group_Chat:GetChildAt(0):HideWSKey(false)
        end
       
        StyleOfPlay.TeamHeadUI.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Com_Show:SetVisibility(ESlateVisibility.Collapsed)
        self.Parent.DeputeTab:UpdateUIStyleInPlatform(false)
        -- self.Parent.DeputeTab.Key_Left:ClearChildren()
        -- self.Parent.DeputeTab.Key_Right:ClearChildren()
        -- 更新界面按键提示
        StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
    end
end

return M
