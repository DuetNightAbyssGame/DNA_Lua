--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_BattlePass_Replacement_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

local RewardBox = require "BluePrints.Client.CustomTypes.SimpleRewardBox"

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

--function M:Destruct()
--end

function M:Construct()
    self.Btn_Close.OnClicked:Add(self, self.CloseSelf)
end

function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)

    AudioManager(self):PlayUISound(self, "event:/ui/common/get_award_items_high_level", nil, nil)

    self:PlayAnimation(self.In)

    self.Text_Replacement:SetText(GText("UI_BattlePass_RefreshReminder"))
    self.Text_Tip:SetText(GText("UI_TRAIN_CLOSE"))

    local PurchaseRewards, func, ParentWidget = ...
    if func then
        self:BindActionOnClosed(func, ParentWidget)
    end

    self.RewardList = {}
    self:InitGetItemInfo(PurchaseRewards)
    self.IsShowDetails = false
end

function M:InitGetItemInfo(PurchaseRewards)
    if PurchaseRewards then
        local RewardType = DataMgr.RewardType
        for ItemType, _ in pairs(RewardType) do
            local Rewards = PurchaseRewards[ItemType.."s"]
            if Rewards then
                local RewardInfo = DataMgr[ItemType]
                for ItemId, ItemCount in pairs(Rewards) do
                    local count = 0
                    if type(ItemCount) == "table" then
                        count = RewardBox:GetCount(ItemCount)
                    end
                    if type(ItemCount) == "number" then
                        count = ItemCount
                    end
                    self.RewardList[ItemId] = { TableName = ItemType, ItemCount = count, Rarity = RewardInfo[ItemId].Rarity or RewardInfo[ItemId][ItemType.."Rarity"]}
                end
            end
        end

        self.RewardInfoList = {}
        for key, Value in pairs(self.RewardList) do
            table.insert(self.RewardInfoList, {ItemId = key, ItemInfo = Value})
        end
        table.sort(self.RewardInfoList, function(A, B)
            local RarityA = A.ItemInfo.Rarity or 1
            local RarityB = B.ItemInfo.Rarity or 1
            if RarityA > RarityB then
                return true
            elseif RarityA == RarityB then
                return A.ItemId < B.ItemId
            else
                return false
            end
        end)
        local ItemId, ItemInfo = self.RewardInfoList[1].ItemId, self.RewardInfoList[1].ItemInfo
        local Content = self:NewItemContent(ItemInfo.TableName, ItemId, ItemInfo.ItemCount)
        self.Item_Replacement:Init(Content)
        local Events = {}
        Events.OnMenuOpenChanged = self.ItemMenuAnchorChanged
        self.Item_Replacement:BindEvents(self, Events)
    end

    self:InitHandleKeyInfo()
    self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    self.CurGamepadName = UIUtils.UtilsGetCurrentGamepadName()
    self:OnUpdateUIStyleByInputTypeChange(self.CurInputDeviceType, self.CurGamepadName)
end

function M:SetDefaultFocus()
    self.Item_Replacement:SetFocus()
end

function M:BP_GetDesiredFocusTarget()
    return self.Item_Replacement
end

function M:ItemMenuAnchorChanged(bIsOpen)
    self.IsShowDetails = bIsOpen
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self:OnUpdateUIStyleByInputTypeChange(GameInputModeSubsystem:GetCurrentInputType(), GameInputModeSubsystem:GetCurrentGamepadName())
end

function M:InitHandleKeyInfo()
    self.Panel_Key:ClearChildren()
    local Item1 = self:CreateWidgetNew("ComKeyTextDesc")
    local Item2 = self:CreateWidgetNew("ComKeyTextDesc")
    Item1:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "A"
            },
        },
        Desc = GText("UI_DETAILS"),
    })
    Item2:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "B"
            },
        },
        Desc = GText("UI_BACK"),
    })
    self.Panel_Key:AddChild(Item1)
    self.Panel_Key:AddChild(Item2)
end


--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:NewItemContent(ItemType, ItemId, Count)
    local ItemData = DataMgr[ItemType][ItemId]
    --新建一个列表数据对象
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.ItemType = ItemType
    Obj.Id = ItemId
    local Name;
    if ItemType == "Draft" then
        local ProductData = DataMgr[ItemData.ProductType][ItemData.ProductId]
        Name = GText("UI_FORGING_BLUEPRINT")..GText(ProductData[ItemData.ProductType.."Name"] or ProductData["Name"])
    else
        Name = ItemUtils:GetDropName(ItemId, ItemType)
    end
    Obj.Count = Count
    Obj.Rarity = ItemUtils.GetItemRarity(ItemId, ItemType)

    if ItemType == "HeadSculpture" then
        Obj.Icon = ItemData.HeadPath
    else
        Obj.Icon = ItemUtils.GetItemIconPath(ItemId, ItemType)
    end
    Obj.IsShowDetails = true
    Obj.UIName = "GetItemPage"
    return Obj
end

function M:BindActionOnClosed(func, ParentWidget)
    self.OnClosed = func
    self.ParentWidget = ParentWidget
end

function M:CloseSelf()
    if self:IsAnimationPlaying(self.In) or self:IsAnimationPlaying(self.Out) then
        return
    end
    -- Focus到父级
    local UIState = UIManager(self):GetLastestAndFocusableUIWidgetObj()
    if UIState then
        UIState:SetFocus()
    end
    self:PlayAnimation(self.Out)
end

function M:OnAnimationFinished(Animation)
    if Animation == self.Out then
        self:Close()
        if self.OnClosed then 
            if (self.ParentWidget ~= nil) then
                self.OnClosed(self.ParentWidget)
            else
                self:OnClosed()
            end
        end
    end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        self.Panel_Key:SetVisibility(ESlateVisibility.Collapsed)
        self.Text_Tip:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 输入设备切换通知
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    self:SetDefaultFocus()
    if (IsUseKeyAndMouse) then
        -- PC逻辑
        self.Panel_Key:SetVisibility(ESlateVisibility.Collapsed)
        self.Text_Tip:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    elseif CurInputDevice == ECommonInputType.Gamepad then
        if not self.IsShowDetails then
            self.Panel_Key:SetVisibility(ESlateVisibility.Visible)
        else
            self.Panel_Key:SetVisibility(ESlateVisibility.Collapsed)
        end
        self.Text_Tip:SetVisibility(ESlateVisibility.Collapsed)
    end
end


function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false

    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    else
        if (InKeyName == "Escape") then
            IsEventHandled = true
            self:CloseSelf()
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    if InKeyName == "Gamepad_FaceButton_Right" then
        self:CloseSelf()
        IsEventHandled = true
    end
    return IsEventHandled
end

return M
