require "UnLua"

local M = {
}

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    DebugPrint("WBP_Forging_Convert_PopUp_Choose_GamePadCompoment:OnUpdateUIStyleByInputTypeChange")
    if (CurInputDevice == ECommonInputType.Gamepad) then
        self:InitGamePadView()
    else
        self:InitKeyboardView()
    end
end
---初始化键盘视图
function M:InitKeyboardView()
    self.IsGamePad = false
    if self.WBP_Com_KeyImg then
        self.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if self.Panel_GamePad then
        self.Panel_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    for i = 1, 4 do
        local Item = self["Item_" .. i]
        if Item and Item.WBP_Com_BtnImg01 then
            local Btn = Item.WBP_Com_BtnImg01
            if Btn.IsVisible and Btn:IsVisible() then
                Btn:SetVisibility(UE4.ESlateVisibility.Visible)
            end
        end
    end
end
--切换成手柄视图
function M:InitGamePadView()
    self.IsGamePad = true
    if not self.IsFirstInit then
        self.IsFirstInit = true
        self:FirstInitGamePadView()
    end
    if self.Panel_GamePad then
        self.Panel_GamePad:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    end
    for i = 1, 4 do
        local Item = self["Item_" .. i]
        if Item and Item.WBP_Com_BtnImg01 then
            local Btn = Item.WBP_Com_BtnImg01
            if Btn.IsVisible and Btn:IsVisible() then
                Btn:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
            end
        end
    end
    if self.Key_1 and self.Key_1.CreateCommonKey then
        self.Key_1:CreateCommonKey({
            KeyInfoList = {{
                Type = "Img",
                ImgShortPath = "A",
            }},
            Desc = GText("UI_CTL_Select")
        })
    end

    if #self.IsChoosedTbl > 0 then
        if self.WBP_Com_KeyImg then
            self.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        end
    else
        if self.WBP_Com_KeyImg then
            self.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end 
    end
    if self:GetVisibility() == UE4.ESlateVisibility.Visible then
        self:SetDefaultMaterialFocus()
    end
end
--只需要初始化一次的手柄逻辑
function M:FirstInitGamePadView()
    self.Btn_Yes:SetDefaultGamePadImg("X")
    self.WBP_Com_KeyImg:CreateGamepadKey("Y")
        if self.Key_2 and self.Key_2.CreateCommonKey then
        self.Key_2:CreateCommonKey({
            KeyInfoList = {{
                Type = "Img",
                ImgShortPath = "B",
            }},
            Desc = GText("UI_BACK")
        })
    end
end
---导航到选中的材料或者第一个
function M:SetDefaultMaterialFocus()
    self.List_Item:BP_ClearSelection()
    if self.CurSelectedContent then
        self.List_Item:BP_SetItemSelection(self.CurSelectedContent, true)
        self.List_Item:SetFocus()
    else
        self.List_Item:NavigateToIndex(0)
        self.List_Item:SetFocus()
    end
    if self.Key_1 and self.Key_1.SetDescription then
        self.Key_1:SetDescription(GText("UI_CTL_Select"))
    end
    self:RefreshGamepadKeyImgByFocus()
end
function M:IsInTipsFocus()
    return self.WBP_Com_Tips and (self.WBP_Com_Tips:HasAnyFocus() or self.WBP_Com_Tips:HasFocusedDescendants())
end
function M:RefreshGamepadKeyImgByFocus()
    local inChosen = self.Group_Item and self.Group_Item:HasFocusedDescendants()
    local inTips = self:IsInTipsFocus()
    if self.Panel_GamePad then
        if inTips then
            self.Panel_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        else
            self.Panel_GamePad:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        end
    end
    if inChosen or inTips then
        self.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end
    if #self.IsChoosedTbl > 0 then
        self.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    else
        self.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end
--已选择的材料变化时，更新一下选中，如果没有可选中的材料，回到待选材料列表
function M:UpdataGamepadFocus(Index)
    if #self.IsChoosedTbl > 0 then
        local FocusIndex = Index
        if FocusIndex > #self.IsChoosedTbl then
            FocusIndex = #self.IsChoosedTbl
        end
        local ItemWidget = self["Item_" .. FocusIndex]
        if ItemWidget  then
             ItemWidget:SetFocus()
             local CommonItem = ItemWidget.WBP_Com_Item_Universal_L or ItemWidget.WBP_Armory_Item_L_Mod
             if CommonItem and CommonItem.OnMouseEnter then
                 CommonItem:OnMouseEnter(nil, nil)--Item前置导致的聚焦不会触发OnmouseEnter手动调用一下
             end
             if self.Key_1 and self.Key_1.SetDescription then
                 self.Key_1:SetDescription(GText("UI_CTL_Remove"))
             end
        end
    else
        self.List_Item:SetFocus()
        if self.Key_1 and self.Key_1.SetDescription then
            self.Key_1:SetDescription(GText("UI_CTL_Select"))
        end
    end
    self:RefreshGamepadKeyImgByFocus()
end

function M:OnGamePadDown(KeyName)
    if KeyName == UIConst.GamePadKey.FaceButtonRight then
        if (self.Group_Item and self.Group_Item:HasFocusedDescendants()) or(self:IsInTipsFocus()) then
            --在材料栏里或者在tips详情面板栏里，都要回到待选材料列表
            self:SetDefaultMaterialFocus()
        else
            --如果都不在，关闭选择列表
            self:CloseChooseList()
        end
        return true
    end

    if self.bItemDetailsShowed then
        if KeyName == UIConst.GamePadKey.FaceButtonTop then
            if self:IsInTipsFocus() then
                return true
            end
            if #self.IsChoosedTbl > 0 then
                self:UpdataGamepadFocus(1)
            end
            return true
        end
    end
    if KeyName == UIConst.GamePadKey.FaceButtonLeft then
        self:OnYesButtonClicked()
        return true
    elseif KeyName == UIConst.GamePadKey.SpecialLeft then
        if not self.bItemDetailsShowed then
            self:SetDefaultMaterialFocus()
        end
        if self.WBP_Com_Tips and self.WBP_Com_Tips.TryGoToFirstItem then
            self.WBP_Com_Tips:TryGoToFirstItem()
            self:RefreshGamepadKeyImgByFocus()
            return true
        end
    end
    return true -- 其他按键都返回true，避免影响其他逻辑
end

return M
