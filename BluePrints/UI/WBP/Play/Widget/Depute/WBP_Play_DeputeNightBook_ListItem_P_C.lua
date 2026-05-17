--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR shilei
-- @DATE ${date} ${time}
--
require "UnLua"
local MonsterUtils = require "Utils.MonsterUtils"
local ActivityController = require "BluePrints.UI.WBP.Activity.ActivityController"
---@type WBP_Play_DeputeNightBook_ListItem_P_C
local M = Class({ "BluePrints.UI.BP_UIState_C" })
local TypeSort = {
    Char = 1,
    Weapon = 2,
    Mod = 3,
    Draft = 4,
    Reward = 5,
    Resource = 6,
    Drop = 7
}
--function M:Initialize(Initializer)
--end

function M:Construct()
    M.Super.Construct(self)
    self:AddInputMethodChangedListen()
    --self.Group_NightBookItem:SetRenderOpacity(0)
    self.Btn_Goto.Button_Area.OnClicked:Add(self, self.OnClicked)
    self.Btn_DoubleMod.Button_Area.OnClicked:Add(self, self.OnClicked)
    self.List_Reward:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.List_Reward:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    self.List_Reward:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    self.List_Reward:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    self.List_Reward.BP_OnEntryInitialized:Add(self, function(self,Content, Widget)
        if Content.Id ~= 0 then
            Widget:BindEvents(self, {
                OnMenuOpenChanged = self.OnStuffMenuOpenChanged,
            })
        end
        --self.List_Reward:SetWheelScrollMultiplier(1)
    end)
    self.Btn_Goto.bAutoButtonChange = false
    self.Btn_DoubleMod.bAutoButtonChange = false

    self.List_Reward.OnCreateEmptyContent:Bind(self, self.CreateAndAddEmptyItem)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        self.List_Reward.OnMouseMove:Add(self, self.OnListRewardMouseMove)
        self.List_Reward.OnMouseButtonUp:Add(self, self.OnListRewardMouseUp)
        self.ListRewardMouseBeginPos = nil
    end
    -- self:SetNavigationRuleCustom(EUINavigation.Down, { self, function()
    --     self.List_Reward:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    --     local RewardItemUIs = self.List_Reward:GetDisplayedEntryWidgets()
    --     return RewardItemUIs[1]
    -- end })
end

function M:OnListRewardMouseMove(MyGeometry,PointerEvent)
    if not self.List_Reward:HasMouseCapture() then return end
    local MouseSpeed = 0.015
    if not self.ListRewardMouseBeginPos then
        self.ListRewardMouseBeginPos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(PointerEvent)
    end
    local MousePos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(PointerEvent)
    local OffsetY = MousePos.Y-self.ListRewardMouseBeginPos.Y
    if math.abs(OffsetY) > 10 then
        local ListView = self.Parent.List_NightBookItem
        local MouseDelta = UE4.UKismetInputLibrary.PointerEvent_GetCursorDelta(PointerEvent)
        MouseDelta = math.clamp(-MouseDelta.Y*MouseSpeed, -1, 1)
        local MaxScrollOffset = UIUtils.GetMaxScrollOffsetOfListView(ListView)
        local ScrollOffset = math.clamp(ListView:GetScrollOffset()+MouseDelta*ListView.WheelScrollMultiplier, 0 , MaxScrollOffset)
        ListView:SetScrollOffset(ScrollOffset)
    end
end

function M:OnListRewardMouseUp(MyGeometry, PointerEvent)
    self.ListRewardMouseBeginPos = nil
end

function M: OnRemovedFromFocusPath(MyGeometry, MouseEvent) 
    self.ListRewardMouseBeginPos = nil
    return UIUtils.Unhandled
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

-- function M:Destruct()
--     M.Super.Destruct(self)
-- end

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.IsEmpty = Content.IsEmpty
    if not self.IsEmpty then
        self.Root = Content.Root
        self.Parent = Content.Parent
        self.DungeonData = Content.DungeonData
        self.MonRewardData = Content.MonRewardData
        self.DoubleMod = Content.Parent.DoubleMod    --是否开启双倍活动
        self.ContinuousCombat = Content.Parent.ContinuousCombat --是否开启连战模式
    end

    self:InitItemContent()
end


function M:InitItemContent()
    self.List_Reward:SetWheelScrollMultiplier(0)
    self.Mobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
    self.IsEnter = false

    -- 空项处理
    if self.IsEmpty then
        self.WS_Item:SetActiveWidgetIndex(1)
        self.bIsFocusable = false
        self:SetVisibility(ESlateVisibility.HitTestInvisible)
        return
    end

    -- 正常项初始化
    self.bIsFocusable = true
    self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.WS_Item:SetActiveWidgetIndex(0)
    self.List_Reward:ClearListItems()

    local InputType = UIUtils.UtilsGetCurrentInputType()
    local IsGamepad = InputType == ECommonInputType.Gamepad
    self.List_Reward:SetVisibility(IsGamepad and ESlateVisibility.HitTestInvisible or ESlateVisibility.SelfHitTestInvisible)

    if self.MonRewardData then

        local IsLocked = not PageJumpUtils:CheckDungeonCondition(self.MonRewardData.Condition)
        self.IsUnLocked = IsLocked
        self:PlayAnimation(IsLocked and self.Locked or self.Normal)
        self.Btn_Goto:ForbidBtn(IsLocked)
        self.Btn_DoubleMod:ForbidBtn(IsLocked)

        local MonsterData = DataMgr.Monster[self.MonRewardData.MonsterUnitId]
        local MonsterInfo = {
            WeaknessIcon = self:GetMonsterWeaknessIcon(self.MonRewardData.MonsterUnitId)
        }

        self.DeputeMonsterTab:SetBasicData(self.MonRewardData.MonsterUnitId, MonsterInfo)
        self.DeputeMonsterTab:SetVisibility(ESlateVisibility.HitTestInvisible)

        self.Text_MonsterTitleName:SetText(GText(MonsterData.UnitName))
        self.Text_MonsterTitleDesc:SetText(GText("UI_Dungeon_MonsterReward"))
        self.Btn_Goto.Text_Button:SetText(GText("UI_GameEvent_Goto"))
        self.Btn_DoubleMod.Text_Button:SetText(GText("UI_GameEvent_Goto"))

        
        if self.DoubleMod then
            local IsDoubleModDungeon = false
            local EventId = GWorld.GameInstance.DoubleModDropEventID
            local DoubleModDrop = DataMgr.DoubleModDrop and DataMgr.DoubleModDrop[EventId]
            local ModDungeonIds = DoubleModDrop and DoubleModDrop.ModDungeonId
            if ModDungeonIds and self.MonRewardData and self.MonRewardData.DungeonList then
                local DungeonId = self.MonRewardData.DungeonList[1]
                for _, ModDungeonId in pairs(ModDungeonIds) do
                    if DungeonId == ModDungeonId then
                        IsDoubleModDungeon = true
                        break
                    end
                end
            end
            local ConfigValue = (DataMgr and DataMgr.ModDropConstant 
            and DataMgr.ModDropConstant.EventBonus 
            and DataMgr.ModDropConstant.EventBonus.ConstantValue) or 0
            local BonusText = "+" .. math.floor(ConfigValue / 100) .. "%"
            self.Text_DoubleModSign:SetText(BonusText)
        
            if self.ContinuousCombat then
                self.Group_DoubleModSign:SetVisibility(ESlateVisibility.Collapsed)
                self.WS_Btn:SetActiveWidgetIndex(1)
                self.VX_EffectBG:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            elseif IsDoubleModDungeon then
                self.Group_DoubleModSign:SetVisibility(self.Parent.DropRemaining  <= 0 and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.SelfHitTestInvisible)
                -- self.Group_DoubleModSign:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                self.WS_Btn:SetActiveWidgetIndex(0)
                self.VX_EffectBG:SetVisibility(ESlateVisibility.Collapsed)
            else
                self.WS_Btn:SetActiveWidgetIndex(0)
                self.Group_DoubleModSign:SetVisibility(ESlateVisibility.Collapsed)
                self.VX_EffectBG:SetVisibility(ESlateVisibility.Collapsed)
            end
        else
            self.WS_Btn:SetActiveWidgetIndex(0)
            self.Group_DoubleModSign:SetVisibility(ESlateVisibility.Collapsed)
            self.VX_EffectBG:SetVisibility(ESlateVisibility.Collapsed)
        end
        

        self:RefreshRewardInfoList(self.MonRewardData.DungeonRewardView)

        if IsGamepad then
            self.Btn_Goto:SetPCVisibility(true)
            self.Btn_DoubleMod:SetPCVisibility(true)
        end
    end
end
--设置夜航号令者的弱点属性
function M:GetMonsterWeaknessIcon(MonsterId)
    local MonsterWeaknessIcon = self.MonsterWeaknessIconCache or {}

    self.MonsterWeaknessIconCache = MonsterWeaknessIcon

    if MonsterWeaknessIcon[MonsterId] then
        return MonsterWeaknessIcon[MonsterId]
    end

    local AllBuffs = MonsterUtils.GetRealMonsterBuffs( self.MonRewardData.DungeonList[1], MonsterId)

    -- 遍历怪物的所有Buff，查找弱点图标
    for _, BuffId in ipairs(AllBuffs) do
        local BuffInfo = DataMgr.Buff[BuffId]
        if BuffInfo and BuffInfo.WeaknessType then
            local WeaknessIcon = DataMgr.DamageType[BuffInfo.WeaknessType] and
                DataMgr.DamageType[BuffInfo.WeaknessType].WeaknessIcon
            if WeaknessIcon then
                MonsterWeaknessIcon[MonsterId] = MonsterWeaknessIcon[MonsterId] or {}

                MonsterWeaknessIcon[MonsterId][WeaknessIcon] = true
            end
        end
    end

    return MonsterWeaknessIcon[MonsterId]
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 输入设备切换通知
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    --self.Root.DeputeTab:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    if (IsUseKeyAndMouse) then
        -- PC逻辑
        self.Btn_Goto:SetPCVisibility(true)
        self.Btn_DoubleMod:SetPCVisibility(true)
        if self.Com_Reward then
            self.Com_Reward:SetVisibility(ESlateVisibility.Collapsed)
        end
        self.List_Reward:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        if self.IsEnter then
            --self:StopAllAnimations()
            self:PlayAnimation(self.Unhover)
        end
    else
        self.List_Reward:SetVisibility(ESlateVisibility.HitTestInvisible)
    end

    self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

function M:OnClicked()
    if self.IsUnLocked or self:IsAnimationPlaying(self.In) then
        PageJumpUtils:CheckDungeonCondition(self.MonRewardData.Condition, true)
        return
    end
    local Item = UIManager(self):GetUIObj("StyleOfPlay")
    Item.IsOpenSelectLevel = false
    local SelectLevel = Item:OpenSubUI("DungeonSelect")
    local DungeonList = self.MonRewardData.DungeonList
    SelectLevel:SetNightFlightManualRewardView(self.MonRewardData.DungeonRewardView)
    SelectLevel:InitLevelList(DungeonList, nil, Const.DeputeType.NightFlightManualDepute,nil)

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
        TitleName = GText("UI_Dungeon_Tab_ModDungeon"),
        -- PopupInfoId = 100124,
        -- InfoCallback = SelectLevel.ShowIntro
    }, nil, true)
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
    if self.IsEmpty then return end
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:OnClicked()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
    self.IsEnter = true
    if self.IsUnLocked or self.Mobile or self.IsEmpty or self:IsAnimationPlaying(self.In) or  UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and not self.IsEmpty then
        self.Btn_Goto:SetPCVisibility(false)
        self.Btn_DoubleMod:SetPCVisibility(false)
    end
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
    self.IsEnter = false
    if self.IsUnLocked or self.Mobile or self.IsEmpty or self:IsAnimationPlaying(self.In) or  UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Unhover)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and not self.IsEmpty then
        self.Com_Reward:SetVisibility(ESlateVisibility.Collapsed)
        self.Btn_Goto:SetPCVisibility(true)
        self.Btn_DoubleMod:SetPCVisibility(true)
    end
end

-- 更新奖励信息列表
---@param DungeonReward number[] @奖励Id列表[RewardView]
function M:RefreshRewardInfoList(DungeonReward)
    if not DungeonReward then
        DebugPrint("SL DungeonReward is nil")
        return
    end
    local RewardList = RewardUtils:GetRewardViewInfoById(DungeonReward)
    -- table.sort(RewardList, function(A, B)
    --     if A.Rarity == B.Rarity then
    --         if TypeSort[A.Type] and TypeSort[B.Type] then
    --             if TypeSort[A.Type] == TypeSort[B.Type] then
    --                 return A.Id < B.Id
    --             end
    --             return TypeSort[A.Type] < TypeSort[B.Type]
    --         end
    --         return A.Id < B.Id
    --     end
    --     return A.Rarity > B.Rarity
    -- end)

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    self.List_Reward:ClearListItems()
    -- 逐个实例化奖励列表
    for _, ItemData in pairs(RewardList) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())

        -- 基本属性赋值
        Content.Id = ItemData.Id
        Content.Icon = ItemUtils.GetItemIconPath(ItemData.Id, ItemData.Type)
        Content.ParentWidget = self
        Content.ItemType = ItemData.Type
        Content.Rarity = ItemData.Rarity or 1
        Content.IsShowDetails = true
        Content.UIName = "StyleOfPlay"
        Content.bAsyncLoadIcon = true
        Content.HandleMouseDown = false
        --Content.HandleMouseDown = true
        if ItemData.DropType then
            Content.bRare = DataMgr.DropProbType[ItemData.DropType].IsRareItem
        end

        -- 处理数量信息
        if ItemData.Quantity then
            Content.Count = ItemData.Quantity[1]
            Content.MaxCount = ItemData.Quantity[2] or nil
        end

        -- 处理置灰状态
        Content.bShadow = false
        if Content.ItemType == "Mod" then
            local ModModel = ModController:GetModel()
            Content.bShadow = ModModel:GetModCountById(Content.Id) <= 0
        elseif Content.ItemType == "Walnut" then
            -- 获取玩家背包中的核桃
            local WalnutsInBag = Avatar.Walnuts.WalnutBag
            Content.bShadow = (WalnutsInBag[Content.Id] or 0) <= 0
        end

        -- 添加到奖励列表
        self.List_Reward:AddItem(Content)
    end
    self.List_Reward:RequestFillEmptyContent()
end

function M:CreateAndAddEmptyItem()
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    -- Content.IsEmpty = true
    Content.Id = 0
    return Content
end

function M:OnStuffMenuOpenChanged(bIsOpen)
    if (UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad) then
        return
    end
    if (bIsOpen) then
        self:UpdatKeyDisplay("")
        self.Btn_Goto:SetPCVisibility(true)
        self.Btn_DoubleMod:SetPCVisibility(true)
    else
        self.Btn_Goto:SetPCVisibility(true)
        self.Btn_DoubleMod:SetPCVisibility(true)
        self:UpdatKeyDisplay("RewardWidget")
    end
end

-- function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
-- end
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
            self.Parent.bFocusList_Reward = true
            self:UpdatKeyDisplay("RewardWidget")
            if  not self.IsEmpty then
                self.Btn_Goto:SetPCVisibility(true)
                self.Btn_DoubleMod:SetPCVisibility(true)
            end
            IsEventHandled = true
        else
            self:SetFocus()
            self.Parent.bFocusList_Reward = false
            self:UpdatKeyDisplay("SelfWidget")
            self.List_Reward:SetVisibility(ESlateVisibility.HitTestInvisible)
            IsEventHandled = true
        end
    elseif InKeyName == "Gamepad_FaceButton_Right" then
        local RewardItemUIs = self.List_Reward:GetDisplayedEntryWidgets()
        for i = 1, RewardItemUIs:Length() do
            if RewardItemUIs[i]:HasFocusedDescendants() or RewardItemUIs[i]:HasAnyUserFocus() then
                self:SetFocus()
                self.Parent.bFocusList_Reward = false
                self:UpdatKeyDisplay("SelfWidget")
                self.List_Reward:SetVisibility(ESlateVisibility.HitTestInvisible)
                IsEventHandled = true
                break
            end
        end
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


function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:UpdatKeyDisplay("FocusSelfWidget")
        if not self.IsEmpty then
           self.Btn_Goto:SetPCVisibility(false)
           self.Btn_DoubleMod:SetPCVisibility(false)
        end
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

-- 更新按键显示
function M:UpdatKeyDisplay(FocusTypeName)
    if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
        return
    end
    self.Parent:UpdatKeyDisplay()
    local StyleOfPlay = UIManager(self):GetUIObj("StyleOfPlay")
    if not StyleOfPlay then
        return -- 防止空引用错误
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
                KeyInfoList = { { Type = "Text", Text = "Esc", ClickCallback = self.Root.CloseSelf, Owner = self } },
                GamePadInfoList = {
                    { Type = "Img", ImgShortPath = "B", Owner = self }
                },
                Desc = GText("UI_BACK"),
            },

        }

        self.Com_Reward:SetVisibility(ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.Left_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.Right_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)

        if self.Root then
            self.Root.DeputeTab:UpdateUIStyleInPlatform(false)
        end

        -- 更新界面按键提示
        StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
    elseif FocusTypeName == "SelfWidget" or FocusTypeName == "FocusSelfWidget" then
        local BottomKeyInfo = {
            {
                KeyInfoList = { { Type = "Text", Text = "Esc", ClickCallback = self.Root.CloseSelf, Owner = self } },
                GamePadInfoList = {
                    { Type = "Img", ImgShortPath = "B", Owner = self }
                },
                Desc = GText("UI_BACK"),
            },
        }

        self.Com_Reward:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        -- 设置右下角按钮提示
        self.Com_Reward:CreateCommonKey({
            KeyInfoList = {
                { Type = "Img", ImgShortPath = "LS" }
            }
        })

        StyleOfPlay.ComTab.Left_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        StyleOfPlay.ComTab.Right_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

        if self.Root and self.Root.DeputeTab then
            local bIsOther = FocusTypeName ~= "SelfWidget"
            self.Root.DeputeTab:UpdateUIStyleInPlatform(true, bIsOther)
        end
        StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
    else
        local BottomKeyInfo = {}

        StyleOfPlay.ComTab.Left_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.Right_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)

        if self.Root then
            self.Root.DeputeTab:UpdateUIStyleInPlatform(false)
        end
        -- 更新界面按键提示
        StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
    end

end

function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.In then
        if self.IsEnter then
            if self.IsUnLocked or self.Mobile or self.IsEmpty or UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
                return
            end
            self:StopAllAnimations()
            self:PlayAnimation(self.Hover)
        end
    end
end

return M
