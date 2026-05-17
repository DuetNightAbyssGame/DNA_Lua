-- 通用商店跳转好友选择界面的弹窗
require "UnLua"
local M={}

function M:InitContent(Content)
    -- 底部快捷键索引在 FirstInitGamepadView 中按好友状态创建
end

function M:InitKeyboardView()
    self.IsGamePad = false
    self.Key_Qa:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:InitGamepadView()
    self.IsGamePad = true
    if not self.InitGamePad then
        self:FirstInitGamepadView()
    end
    self.Key_Qa:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self:InitOriginFocus()
end

function M:FirstInitGamepadView()
   self.Key_Qa:CreateGamepadKey("Menu")

   -- 奖励详情（LS）快捷键：总是创建
   self.CheckItemBtnIdx = self.Owner:InitGamepadShortcut({
        KeyInfoList = {{
            Type = "Img",
            ImgShortPath = "LS"
        }},
        Desc = GText("UI_Controller_CheckDetails")
    }, 3)

   -- 根据是否有好友，决定是否创建“查看玩家(View)”与“选择(A)”两个快捷键
   local hasFriends = false
   local ListView = self.List_FriendContent
   if ListView and ListView.GetNumItems then
        hasFriends = (ListView:GetNumItems() or 0) > 0
   end

   if hasFriends then
        self.CheckPlayerBtnIdx = self.Owner:InitGamepadShortcut({
            KeyInfoList = {{
                Type = "Img",
                ImgShortPath = "View"
            }},
            Desc = GText("UI_Controller_CheckPlayer")
        }, 2)

        self.ConfirmBtnIdx = self.Owner:InitGamepadShortcut({
            KeyInfoList = {{
                Type = "Img",
                ImgShortPath = "A"
            }},
            Desc = GText("UI_CTL_Select")
        }, 4)
   else
        self.CheckPlayerBtnIdx = nil
        self.ConfirmBtnIdx = nil
   end
end
function M:InitOriginFocus()
    if self.IsInSelectMode then
        self:ExitSelectItemMode()
        return
    end
    local ListView = self.List_FriendContent
    if ListView and ListView:GetNumItems() > 0 then
        ListView:SetSelectedIndex(0) -- 聚焦到第一个item
        ListView:NavigateToIndex(0)
    else
        self.Owner:SetFocus()
    end
end

function M:OnGamePadDown(KeyName)
    if KeyName == UIConst.GamePadKey.SpecialRight then
        -- 打开气泡，同时将按钮置为选中态（与 PC 点击一致）
        local qa = self.Com_Qa
        if qa then
            if qa.Btn_Click and qa.Btn_Click.SetChecked then
                qa.Btn_Click:SetChecked(true)
            end
            if qa.OpenMenuAnchor then
                qa:OpenMenuAnchor()
            end
            return true
        end
        return false
    elseif KeyName == UIConst.GamePadKey.LeftThumb then
        self:EnterSelectItemMode()
        return UE4.UWidgetBlueprintLibrary.Handled()
    elseif KeyName == UIConst.GamePadKey.FaceButtonRight then
        -- 保持原有：在奖励列表聚焦时退出选择模式
        if (self.List_Item:HasAnyUserFocus() or self.List_Item:HasFocusedDescendants()) then
            self:ExitSelectItemMode()
            return true
        end
        -- 仅当气泡已打开时关闭，并恢复默认聚焦
        local qa = self.Com_Qa
        if qa and qa.IsMenuAnchorOpen and qa:IsMenuAnchorOpen() then
            if qa.Btn_Click and qa.Btn_Click.SetChecked then
                qa.Btn_Click:SetChecked(false)
            end
            if qa.CloseMenuAnchor then
                qa:CloseMenuAnchor()
            end
            self:InitOriginFocus()
            return true
        end
        return false
    end
    return false
end

function M:FocusRewardItem()
    local ListView = self.List_Item
    if ListView and ListView:GetNumItems() > 0 then
        ListView:SetSelectedIndex(0) -- 聚焦到第一个item
        ListView:SetFocus()
    else
        self.Owner:SetFocus()
    end
end

function M:EnterSelectItemMode()
    -- 聚焦到奖励列表
    self.IsInSelectMode=true
    self:FocusRewardItem()

    -- 将 A 键文案改为“查看详情”并隐藏查看玩家/物品两个快捷键
    if self.Owner and self.ConfirmBtnIdx then
        local ConfirmKey = self.Owner:GetGamepadShortcutByIndex(self.ConfirmBtnIdx)
        if ConfirmKey and ConfirmKey.SetDescription then
            ConfirmKey:SetDescription(GText("UI_Controller_CheckDetails"))
        end
    end

    if self.Owner and self.CheckPlayerBtnIdx then
        self.Owner:HideGamepadShortcut(self.CheckPlayerBtnIdx)
    end

    if self.Owner and self.CheckItemBtnIdx then
        self.Owner:HideGamepadShortcut(self.CheckItemBtnIdx)
    end
end

function M:ExitSelectItemMode()
    self.IsInSelectMode=false
    -- 恢复初始聚焦
    self:InitOriginFocus()

    -- 恢复 A 键文案为“选择”并重新显示两个快捷键
    if self.Owner and self.ConfirmBtnIdx then
        local ConfirmKey = self.Owner:GetGamepadShortcutByIndex(self.ConfirmBtnIdx)
        if ConfirmKey and ConfirmKey.SetDescription then
            ConfirmKey:SetDescription(GText("UI_CTL_Select"))
        end
    end

    if self.Owner and self.CheckPlayerBtnIdx then
        self.Owner:ShowGamepadShortcut(self.CheckPlayerBtnIdx)
    end

    if self.Owner and self.CheckItemBtnIdx then
        self.Owner:ShowGamepadShortcut(self.CheckItemBtnIdx)
    end
end

function M:OnContentFocusReceived(MyGeometry, InFocusEvent)
    DebugPrint("弹窗收到聚焦，恢复默认聚焦 OnContentFocusReceived")
    self:AddTimer(0.1, function()
        self:InitOriginFocus()
    end)
end

return M
