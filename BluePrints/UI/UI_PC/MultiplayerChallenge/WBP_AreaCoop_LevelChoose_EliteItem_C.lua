--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR
-- @DATE 2024-07-22 15:20:05
--
require "UnLua"
local MonsterUtils = require "Utils.MonsterUtils"

---@class WBP_AreaCoop_LevelChoose_EliteItem_C
local M = Class({ "BluePrints.UI.BP_UIState_C" })

function M:Construct()
    M.Super.Construct(self)
    self:AddInputMethodChangedListen()

    -- The entire item should be clickable. Assuming a Button_Area covers the item.
    if self.Button_Area then
        self.Button_Area.OnClicked:Add(self, self.OnClicked)
    end

    -- self.List_EliteProp:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    -- self.List_EliteProp:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    -- self.List_EliteProp:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    -- self.List_EliteProp:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)

    self.List_EliteProp.OnCreateEmptyContent:Bind(self, self.CreateAndAddEmptyItem)
end

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.IsEmpty = Content.IsEmpty
    if not self.IsEmpty then
        self.Root = Content.Root
        self.Parent = Content.Parent
        self.DungeonData = Content.DungeonData
        self.MonRewardData = Content.MonRewardData
    end

    self:InitItemContent()
end

function M:InitItemContent()
    --self.Group_NightBookItem:SetRenderOpacity(0)

    self.Mobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
    self.IsEnter = false

    -- Empty item handling
    if self.IsEmpty then
        self.WS_Item:SetActiveWidgetIndex(1)
        self:PlayAnimation(self.In)
        self.bIsFocusable = false
        self:SetVisibility(ESlateVisibility.HitTestInvisible)
        return
    end

    -- Normal item initialization
    self.bIsFocusable = true
    self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    --self.WS_Item:SetActiveWidgetIndex(0)
    self.List_EliteProp:ClearListItems()

    local InputType = UIUtils.UtilsGetCurrentInputType()
    local IsGamepad = InputType == ECommonInputType.Gamepad
    self.List_EliteProp:SetVisibility(IsGamepad and ESlateVisibility.HitTestInvisible or ESlateVisibility.SelfHitTestInvisible)

    if self.MonRewardData then
        self:PlayAnimation(self.In)

        local IsLocked = not PageJumpUtils:CheckDungeonCondition(self.MonRewardData.Condition)
        self.IsUnLocked = IsLocked
        self:PlayAnimation(IsLocked and self.Locked or self.Normal)

        local MonsterData = DataMgr.Monster[self.MonRewardData.MonsterUnitId]
        local MonsterInfo = {
            WeaknessIcon = self:GetMonsterWeaknessIcon(self.MonRewardData.MonsterUnitId)
        }

        self.Monster_Elite:SetBasicData(self.MonRewardData.MonsterUnitId, MonsterInfo)
        self.Monster_Elite:SetVisibility(ESlateVisibility.HitTestInvisible)

        -- self.Text_MonsterTitleName:SetText(GText(MonsterData.UnitName))
        -- self.Text_MonsterTitleDesc:SetText(GText("UI_Dungeon_MonsterReward"))

        self:RefreshRewardInfoList(self.MonRewardData.DungeonRewardView)
    end
end

-- Set the weakness attribute of the Night Navigator
function M:GetMonsterWeaknessIcon(MonsterId)
    local MonsterWeaknessIcon = self.MonsterWeaknessIconCache or {}
    self.MonsterWeaknessIconCache = MonsterWeaknessIcon

    if MonsterWeaknessIcon[MonsterId] then
        return MonsterWeaknessIcon[MonsterId]
    end

    local AllBuffs = MonsterUtils.GetRealMonsterBuffs(self.MonRewardData.DungeonList[1], MonsterId)

    -- Traverse all buffs of the monster to find the weakness icon
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
        return
    end
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        if self.Com_Reward then
            self.Com_Reward:SetVisibility(ESlateVisibility.Collapsed)
        end
        self.List_EliteProp:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        if self.IsEnter then
            self:PlayAnimation(self.Unhover)
        end
    else
        --self.List_EliteProp:SetVisibility(ESlateVisibility.HitTestInvisible)
    end

    self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

function M:OnClicked()
    if self.IsUnLocked or self:IsAnimationPlaying(self.In) then
        PageJumpUtils:CheckDungeonCondition(self.MonRewardData.Condition, true)
        return
    end
    
    -- NOTE: The following logic is ported from DeputeNightBook and likely needs to be adapted
    -- for the AreaCoop context.
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
    }, nil, true)
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
    if self.IsEmpty then return end
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:OnClicked()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

-- function M:OnMouseEnter(MyGeometry, MouseEvent)
--     self.IsEnter = true
--     if self.IsUnLocked or self.Mobile or self.IsEmpty or self:IsAnimationPlaying(self.In) or  UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
--         return
--     end
--     self:StopAllAnimations()
--     self:PlayAnimation(self.Hover)
-- end

-- function M:OnMouseLeave(MyGeometry, MouseEvent)
--     self.IsEnter = false
--     if self.IsUnLocked or self.Mobile or self.IsEmpty or self:IsAnimationPlaying(self.In) or  UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
--         return
--     end
--     self:StopAllAnimations()
--     self:PlayAnimation(self.Unhover)
--     if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and not self.IsEmpty then
--         self.Com_Reward:SetVisibility(ESlateVisibility.Collapsed)
--     end
-- end

-- Update reward information list
---@param DungeonReward number[] @Reward ID list [RewardView]
function M:RefreshRewardInfoList(DungeonReward)
    if not DungeonReward then
        return
    end
    local RewardList = RewardUtils:GetRewardViewInfoById(DungeonReward)

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    -- Instantiate the reward list one by one
    for _, ItemData in pairs(RewardList) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())

        -- Basic attribute assignment
        Content.Id = ItemData.Id
        Content.Icon = ItemUtils.GetItemIconPath(ItemData.Id, ItemData.Type)
        Content.ParentWidget = self
        Content.ItemType = ItemData.Type
        Content.Rarity = ItemData.Rarity or 1
        Content.IsShowDetails = true
        Content.UIName = "StyleOfPlay"
        --Content.bAsyncLoadIcon = true

        if ItemData.DropType then
            Content.bRare = DataMgr.DropProbType[ItemData.DropType].IsRareItem
        end

        -- Process quantity information
        if ItemData.Quantity then
            Content.Count = ItemData.Quantity[1]
            Content.MaxCount = ItemData.Quantity[2] or nil
        end
        -- Process grayed out state
        Content.bShadow = false
        if Content.ItemType == "Mod" then
            local ModModel = ModController:GetModel()
            Content.bShadow = ModModel:GetModCountById(Content.Id) <= 0
        elseif Content.ItemType == "Walnut" then
            -- Get the walnuts in the player's backpack
            local WalnutsInBag = Avatar.Walnuts.WalnutBag
            Content.bShadow = (WalnutsInBag[Content.Id] or 0) <= 0
        end

        Content.List = self.List_EliteProp
        -- 注入：添加到聚焦路径时触发 Hover（复用鼠标进入的逻辑判定）
        Content.OnAddedToFocusPathEvent = {
            Obj = Content,
            Callback = function(Content)
                self.ParentPage:OnItemFocus(Content)
            end,
        }
        self.List_EliteProp:AddItem(Content)
    end
    
    if self:IsExistTimer(self.NextFrameListEmpty) then
        self:RemoveTimer(self.NextFrameListEmpty)
    end
    
    --- Use empty Item to complete the ListView, add a timer because it takes one frame to get the generated Entry
    self.NextFrameListEmpty = self:AddTimer(0.01, function()
        -- local len = self.List_EliteProp:GetNumItems()
        -- for i = 1, len do
        --     local entryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_EliteProp, i - 1)
        --     if entryWidget then
        --         entryWidget:BindEvents(self, {
        --             OnMenuOpenChanged = self.OnStuffMenuOpenChanged,
        --         })
        --     end
        -- end
        self.List_EliteProp:RequestFillEmptyContent()
    end, false, 0, "DeputeDetailListView")
end

function M:CreateAndAddEmptyItem()
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Id = 0
    return Content
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