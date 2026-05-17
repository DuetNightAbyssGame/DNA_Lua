--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Battle_OnlineAction_P_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
M._components = {"BluePrints.UI.WBP.BattleOnlineAction.WBP_Battle_OnlineActionBaseView"}
local OnlineActionCommon = require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionCommon"
---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end
local RefreshKey=OnlineActionCommon.RefreshAllKey
local RefuseKey=  OnlineActionCommon.RejectAllKey
function M:InitKeyInfos()
    -- 键鼠：刷新
    self.RefreshKeyInfo = {
        KeyInfoList = {
            {
                Type = "Text",
                Text = RefreshKey,
                ClickCallback = function()
                    self:OnRefreshAllKeyDown()
                end
            }
        },
        Desc = GText("UI_RegionOnline_Refresh"),
    }
    -- 手柄：刷新
    self.GamePadRefreshKeyInfo = {
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "LS",
                ClickCallback = function()
                    self:OnRefreshAllKeyDown()
                end
            }
        },
        Desc = GText("UI_RegionOnline_Refresh"),
    }

    -- 键鼠：拒绝全部
    self.RefuseKeyInfo = {
        KeyInfoList = {
            {
                Type = "Text",
                Text = RefuseKey,
                ClickCallback = function()
                    self:OnRejectAllKeyDown()
                end
            },
            GamepadKey = "FaceButtonRight",
        },
        Desc = GText("UI_RegionOnline_RefruseAll"),
    }
    -- 手柄：拒绝全部
    self.GamePadRefuseKeyInfo = {
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "RS",
                ClickCallback = function()
                    self:OnRejectAllKeyDown()
                end
            }
        },
        Desc = GText("UI_RegionOnline_RefruseAll"),
    }

    -- 键鼠：返回
    self.CloseKeyInfo = {
        KeyInfoList = {
            {
                Type = "Text",
                Text = "Esc",
                ClickCallback = function()
                    self:OnReturnKeyDown()
                end
            }
        },
        Desc = GText("UI_BACK"),
    }
    -- 手柄：返回
    self.GamePadCloseKeyInfo = {
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "B",
                ClickCallback = function()
                    self:OnReturnKeyDown()
                end
            }
        },
        Desc = GText("UI_BACK"),
    }
end

function M:Construct()
    self.M=M
    -- 确保实例 KeyInfo 初始化在任何样式刷新之前
    self:InitKeyInfos()

    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if (IsValid(GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(GameInputModeSubsystem:GetCurrentInputType())
        GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice) 
    end
end

function M:StaticInit()

    -- self.Key_Refresh:CreateCommonKey(RefreshKeyInfo)
    -- self.Key_Refuse:CreateCommonKey(RefuseKeyInfo)
    -- self.Key_Close:CreateCommonKey(CloseKeyInfo)
end
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    DebugPrint("BattleOnlineAction_P_C Received OnKeyDown" .. InKeyName)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        self.IsGamePad = true
        IsEventHandled=self.Tab_OnlineAction:Handle_KeyEventOnGamePad(InKeyName)
        if not IsEventHandled then
            IsEventHandled = self:OnGamePadDown(InKeyName)
        end
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        self.IsGamePad = false
        if (InKeyName == "Escape") then
            self:OnReturnKeyDown()
        elseif InKeyName=="Q" then
            self:OnLeftTabKeyDown()
        elseif InKeyName=="E" then
            self:OnRightTabKeyDown()
        elseif (InKeyName == OnlineActionCommon.RefreshAllKey) then
            if self.IsInRefreshCD then
            else
                self:OnRefreshAllKeyDown()
                self.IsInRefreshCD = true
                self:AddTimer(OnlineActionCommon.RefreshAllCD or 1, function()
                    self.IsInRefreshCD = false
                end)
            end
        elseif (InKeyName == OnlineActionCommon.RejectAllKey) then
            if self.Tab_OnlineAction.CurrentTab ~= 2 then
                self:OnRejectAllKeyDown()
            end
        end
    end
    return UE4.UWidgetBlueprintLibrary.Handled()

end
function M:OnGamePadDown(InKeyName)
    if not self.GamePadInputMap then
    self.GamePadInputMap={
        [UIConst.GamePadKey.FaceButtonRight]=self.OnGamePadReturnKeyDown,
        [UIConst.GamePadKey.LeftThumb]=self.OnRefreshAllKeyDown,
        [UIConst.GamePadKey.RightThumb]=self.OnRejectAllKeyDown,
        [UIConst.GamePadKey.LeftShoulder]=self.OnLeftTabKeyDown,
        [UIConst.GamePadKey.RightShoulder]=self.OnRightTabKeyDown,
    }
    end
    if self.GamePadInputMap[InKeyName] then
        self.GamePadInputMap[InKeyName](self)
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
end

function M:OnGamePadReturnKeyDown()
    local FocusItem=self.List_Invite:BP_GetSelectedItem()
    -- if FocusItem and FocusItem.UI and FocusItem.UI:IsVisible() and FocusItem.UI.HB_Option:HasFocusedDescendants() then
    --     FocusItem.UI:HidePositionUI()
    --     return UE4.UWidgetBlueprintLibrary.Handled()
    -- end
    if FocusItem and FocusItem.UI.WS_Btn:GetActiveWidgetIndex() ~= 1 then -- 位置选择按钮
        FocusItem.UI:HidePositionUI()
        FocusItem.UI.Option_1.Btn_Area:SetFocus()
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    
    self:OnReturnKeyDown()
end
-- 根据当前输入方式更新界面的样式
function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    -- 根据当前输入方式更新界面的样式，子类重写该方法
    DebugPrint("BattleOnlineAction_P_C OnUpdateUIStyleByInputTypeChange CurInputType:"..CurInputType)
    if CurInputType == ECommonInputType.MouseAndKeyboard then
        self:InitKeyboardUI()
    elseif CurInputType == ECommonInputType.Gamepad then
        self:InitGamepadUI()
    end
end

function M:InitKeyboardUI()
    if not self.RefreshKeyInfo then
        self:InitKeyInfos()
    end

    self.Key_Refresh:CreateCommonKey(self.RefreshKeyInfo)
    self.Key_Refuse:CreateCommonKey(self.RefuseKeyInfo)
    self.Key_Close:CreateCommonKey(self.CloseKeyInfo)
    self.IsGamePad = false
end

function M:InitGamepadUI()
    if not self.GamePadRefreshKeyInfo then
        self:InitKeyInfos()
    end

    self.IsGamePad = true
    self.Key_Refresh:CreateCommonKey(self.GamePadRefreshKeyInfo)
    self.Key_Refuse:CreateCommonKey(self.GamePadRefuseKeyInfo)
    self.Key_Close:CreateCommonKey(self.GamePadCloseKeyInfo)
    if self:HasAnyFocus() and self:IsListHaveItem() then
        self.List_Invite:BP_ClearSelection()
        self:FocusFirstItem()
        return
    end
end
function M:SwitchEmptyBG()
    self:SetFocus()
end


function M:FocusNextItem(NowItem)
    local Index=self.List_Invite:GetIndexForItem(NowItem)
    local ItemNum=self.List_Invite:GetNumItems()
    if Index+1<ItemNum then
        Index=Index+1
        DebugPrint("联机动作Focus FocusNextItem:Next Item Index:"..Index)
    elseif Index-1>=0 then
        Index=Index-1
        DebugPrint("联机动作Focus FocusNextItem:Pre Item Index:"..Index)
    else
        self:SwitchEmptyBG(self.TabKind)
        self:SetFocus()
        DebugPrint("联机动作Focus FocusNextItem:No Item")
        return
    end
    local NewItem=self.List_Invite:GetItemAt(Index)
    self.List_Invite:BP_NavigateToItem(NewItem)
    
    -- if NewItem.UI and NewItem.UI:IsVisible() then
    --     NewItem.UI:SetFocus()
    -- end
    --self.List_Invite:SetSelectedIndex(Index)
end

--function M:Destruct()
--end

AssembleComponents(M)
return M
