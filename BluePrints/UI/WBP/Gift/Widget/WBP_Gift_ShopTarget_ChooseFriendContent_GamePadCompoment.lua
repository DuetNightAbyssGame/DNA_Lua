-- 通用商店跳转好友选择界面的弹窗
require "UnLua"
local M={}

function M:InitContent(Content)
end

function M:InitKeyboardView()
    self.IsGamePad = false
    --self.Key_Qa:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Title.Key_Title:SetVisibility(UIConst.VisibilityOp.Collapsed)

end

function M:InitGamepadView()
    self.IsGamePad = true
    if not self.InitGamePad then
        self:FirstInitGamepadView()
    end
    --self.Key_Qa:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Title.Key_Title:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self:InitOriginFocus()
end

function M:FirstInitGamepadView()
   --self.Key_Qa:CreateGamepadKey()
       self.Title.Key_Title:CreateGamepadKey("Menu")
       self.CheckPlayerBtnIdx = self.Owner:InitGamepadShortcut({
        KeyInfoList = {{
            Type = "Img",
            ImgShortPath = "View"
        }},
        Desc = GText("UI_Controller_CheckPlayer")
    }, 2)
end

function M:InitOriginFocus()
    -- if self.IsInSelectMode then
    --     self:ExitSelectItemMode()
    --     return
    -- end
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
        local qa = self.Title.Com_QaQA or self.Title.Com_Qa
        if qa then
            if qa.Btn_Click and qa.Btn_Click.SetChecked then
                qa.Btn_Click:SetChecked(true)
            end
            if qa.OpenMenuAnchor then
                qa:OpenMenuAnchor()
            end
        end
        return true
    elseif KeyName == UIConst.GamePadKey.FaceButtonRight then
        -- 仅当气泡已打开时关闭，并恢复默认聚焦
        local qa = self.Title.Com_QaQA or self.Title.Com_Qa
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



return M
