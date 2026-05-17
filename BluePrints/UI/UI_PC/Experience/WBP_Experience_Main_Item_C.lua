--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Experience_Main_item_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.Common.TimerMgr"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.List_UnlockItem.bManualControlScrollbar = true
    self.List_UnlockItem.OnCreateEmptyContent:Bind(self, function(self)
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.IsEmpty = true
        return Content
    end)
    self.ComKey_Title:CreateCommonKey(
        {
            KeyInfoList = {{Type = "Img",ImgShortPath = "View"}},
        }
    )

    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
    self:InitListenEvent()
end

function M:Destruct()
    self:ClearListenEvent()
end

function M:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function M:ClearListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        return
    end
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
end

function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    if IsUseKeyAndMouse then
		self:InitKeyboardView()
	else
		self:InitGamepadView()
	end
end

function M:InitGamepadView()
    if self.Content and self.Content.Type == "Walnut" and not self.Content.Root.IsInSelectState then
        self.ComKey_Title:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        self.ComKey_Title:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:InitKeyboardView()
    self.ComKey_Title:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:ItemIconRefresh()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:BP_OnEntryReleased()
    if (self.Content) then
        self.Content.Entry = nil
    end
end

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.Content.Entry = self

    self:ItemIconRefresh()

    self.List_UnlockItem:ClearListItems()
    if Content.Type == "Walnut" and Content.SortedItemInfos then
        self.Switch_Content:SetActiveWidgetIndex(1)
        for _,Info in pairs(Content.SortedItemInfos) do
            local WalnutContent = NewObject(UIUtils.GetCommonItemContentClass())
            WalnutContent.UIName = "ExperienceMain"
            WalnutContent.IsShowDetails = true
            WalnutContent.Id = Info.TypeId
            WalnutContent.Icon = ItemUtils.GetItemIconPath(Info.TypeId, Info.ItemType)
            WalnutContent.Rarity = ItemUtils.GetItemRarity(Info.TypeId, Info.ItemType)
            WalnutContent.ItemType = Info.ItemType
            WalnutContent.OnMenuOpenChangedEvents = {
                Obj = self,
                Callback = self.MenuOpenChangedEvent
            }
            self.List_UnlockItem:AddItem(WalnutContent)
        end
        self:AddTimer(0.01, function()
            self.List_UnlockItem:RequestFillEmptyContent()
        end,false,0,nil,true)
    elseif Content.Type == "Text" then
        self.Switch_Content:SetActiveWidgetIndex(0)
        self.Text_Promote:SetText(GText(Content.Content.Text))
    end
    self.Text_Title:SetText(GText(Content.Title))
end

function M:MenuOpenChangedEvent(IsOpened)
    if ModController:IsMobile() then
        return
    end
    if IsOpened then
        self.Content.Root:InitItemTipOpenTab()
    else
        self.Content.Root:InitSelectTab()
    end
end

return M
