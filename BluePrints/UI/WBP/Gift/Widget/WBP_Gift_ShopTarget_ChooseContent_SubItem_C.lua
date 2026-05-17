--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local ChatController = require "BluePrints.UI.WBP.Chat.ChatController"
local TeamController = require "BluePrints.UI.WBP.Team.TeamController"
local TeamModel = TeamController:GetModel()
local PersonInfoController = require "BluePrints.UI.WBP.PersonInfo.PersonInfoController"

---@type WBP_Gift_ShopTarget_ChooseContent_SubItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.UI.BP_EMUserWidgetUtils_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end
function M:OnListItemObjectSet(Content)
    self.Parent = Content.Parent
    if Content.IsEmpty then
        self.WS_Item:SetActiveWidgetIndex(1)
        self.Group_Empty:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        return
    end
    if Content.HeadFrameId then
        self.Com_ItemHead:SetHeadFrame(Content.HeadFrameId)
    end
    self.Com_ItemHead:SetHeadIconById(Content.HeadIconId or 10001)
    self.Name:SetText(Content.Nickname or "")
    --- 缓存头像信息供头像菜单使用
    self.Content = Content
    self.AvatarInfo = {
        Uid = Content.Uid,
        Nickname = Content.Nickname or "",
    }
   -- self.PlayAnimation(self.In)
    --self:AddInputMethodChangedListen()
end

function M:Construct()
    self.Btn_Choose.Button_Area.OnClicked:Add(self, self.OnClickChoose)
    -- 重写点击音效
    self.Btn_Choose:OverriddenSoundFunc()
    -- 头像点击：仅展示“查看档案”按钮
    if self.Com_ItemHead and self.Com_ItemHead.BindOnClickEvent then
        self.Com_ItemHead:BindOnClickEvent(function()
            self:OnClickHead()
        end)
    end
    -- 绑定头像菜单锚的内容生成与打开回调
    if self.Head_Anchor then
        self.Head_Anchor.OnGetUserMenuContentEvent:Bind(self, self.OnAnchorGetUserMenuContent)
        self.Head_Anchor.OnMenuOpenChanged:Add(self, self.HeadMenuOpenChanged)
    end
    self.GameInputModeSubsystem = self.GameInputModeSubsystem or UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    self:AddInputMethodChangedListen()
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    if CurInputType == ECommonInputType.Gamepad then
        self:InitGamePadView()
    else
        self:InitKeyBoardView()
    end
end

function M:OnClickChoose()
    local Owner = (self.Parent and self.Parent.Owner) or nil
    if Owner and Owner.OnClose then
        Owner:OnClose()
    elseif self.Parent and self.Parent.Close then
        self.Parent:Close()
    end
    GiftController:OpenGiftCardView(self.Content.Uid, self.Content.ShopItemId, 1)
end

-- 头像菜单：只保留“查看档案”逻辑
function M:OnClickHead()
    if not self.AvatarInfo or not self.AvatarInfo.Uid then return end
    if self.Head_Anchor then
        -- 使用 MenuAnchor 打开菜单，由 OnAnchorGetUserMenuContent 提供内容
        self.Head_Anchor:Open(true)
    end
end

-- 头像菜单锚内容生成：只保留“查看档案”
function M:OnAnchorGetUserMenuContent()
    local Switch = {}
    local InitShowRecordBtn = function(Content, AvatarInfo)
        Content.Text = GText("UI_Chat_ShowRecord")
        Content.Callback = function()
            GiftController:OpenPersonInfoPage(AvatarInfo.Uid)
        end
    end
    table.insert(Switch, InitShowRecordBtn)
    return ChatController:OpenPlayerBtnList(self, self.AvatarInfo, Switch)
end

function M:HeadMenuOpenChanged(bOpen)
    self.bMenuOpen = bOpen
    -- 手柄操作时：打开头像菜单隐藏底部快捷键，关闭后恢复（不做兜底，错误直接抛出）
    if self.IsGamePad and self.Parent then
        if bOpen then
            self.Parent:HideAllGamepadShortcut()
        else
            self.Parent:ShowAllGamepadShortcut()
        end
    end
end
--function M:Tick(MyGeometry, InDeltaTime)
--end
-- 预览按键：在头像菜单打开时，按手柄 B 键（FaceButton_Right）关闭菜单
function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if self.bMenuOpen then
        if InKeyName == "Gamepad_FaceButton_Right" then
            if self.Head_Anchor then
                self.Head_Anchor:Close()
            end
            self:SetFocus()
            return UE4.UWidgetBlueprintLibrary.Handled()
        end
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        -- self.PersonInfoMainPage:RotateActorForGamePad()
        self.IsGamePad = true
        IsEventHandled = self:OnGamePadDown(InKeyName)
    else
        self.IsGamePad = false
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
end

function M:OnGamePadDown(InKeyName)
    if InKeyName == UIConst.GamePadKey.SpecialLeft then
        self:OnClickHead()
        self.Parent:HideAllGamepadShortcut()
        return true
    elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom then
        self:OnClickChoose()
        return true
    end
    return false
end

function M:InitGamePadView()
    self.IsGamePad = true
    if self:HasAnyUserFocus() then
        self.ListBox_Parent:OnCellHovered()
    end
end

function M:InitKeyBoardView()
    self.IsGamePad = false
    self.ListBox_Parent:OnCellReleased()
end

function M:Destruct()
    if self.Head_Anchor then
        self.Head_Anchor.OnGetUserMenuContentEvent:Unbind()
        self.Head_Anchor.OnMenuOpenChanged:Remove(self, self.HeadMenuOpenChanged)
    end
    self:RemoveInputMethodChangedListen()
end

function M:OnAddedToFocusPath(InFocusEvent)
    if self.Parent.IsGamePad then
        self.ListBox_Parent:OnCellHovered()
    end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
    if self.Parent.IsGamePad then
        self.ListBox_Parent:OnCellUnhovered()
    end
end



AssembleComponents(M)

return M
