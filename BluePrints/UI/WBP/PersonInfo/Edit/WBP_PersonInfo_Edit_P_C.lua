--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_PersonalInfo_Edit_M_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
M._components =
    {"BluePrints.UI.WBP.PersonInfo.Edit.WBP_PersonInfo_EditBaseView" -- "BluePrints.UI.WBP.PersonInfo.Base.PersonInfoMainPageView",
    -- "BluePrints.UI.WBP.PersonInfo.Edit.WBP_PersonInfo_EditBaseView"
    }
function M:Initialize(Initializer)
    self.FocusBoxIndex = nil -- 目前聚焦的展柜编号
end

function M:Construct()
    self.KeyEventTable = {
        ["A"] = self.OnAKeyDown,
        ["D"] = self.OnDKeyDown,

        ["Q"] = self.OnQKeyDown,
        ["E"] = self.OnEKeyDown
    }
    self.Key_R:CreateCommonKey({
        KeyInfoList = {{
            Type = "Text",
            Text = "D"
        }}
    })
    self.Key_Controller_L:SetImage("LT")
    self.Key_Controller_R:SetImage("RT")
    self.Key_R:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Btn_Cancel:SetGamePadImg("B")
    self.Btn_Confirm:SetGamePadImg("X")
    for i = 1, 3 do
        self["Edit_AvatarItem_" .. i]:SetFocusCallback(function()
            self:OnBoxFocus(i)

        end)
        self["Edit_AvatarItem_" .. i]:SetFocusLostCallback(function()
            self:OnBoxFocusLost(i)
        end)
    end
    self.WBP_PersonalInfo_Edit_Tips:SetOnFocusSelectedItemCallback(
        function(TipsWidget, TipsItemWidget)
            self:OnFocusTipsSelectedItem()
        end)
    self.WBP_PersonalInfo_Edit_Tips:SetOnFocusNotSelectedItemCallback(function()
        self:OnFocusTipsNotSelectedItem()
    end)

    self.TileView_Select_Role.BP_OnItemSelectionChanged:Clear()
    self.TileView_Select_Role.BP_OnItemSelectionChanged:Add(self, self.OnListItemSelectionChanged)
    self.TileView_Select_Role.BP_OnItemIsHoveredChanged:Clear()
    self.TileView_Select_Role.BP_OnItemIsHoveredChanged:Add(self, self.OnItemIsHoverChanged)
end
function M:InitBaseView(TabName)

    self.Root:AddTimer(0.01, function()
        self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
        if (self.GameInputModeSubsystem) then
            self:OnUpdateUIStyleByInputTypeChange(self.GameInputModeSubsystem:GetCurrentInputType(),
                self.GameInputModeSubsystem:GetCurrentGamepadName())
        end
    end)

end

function M:OnQKeyDown()
    if self.CurMainTab.Name == "Char" then
        return
    else
        self.Com_Tab.Tabs[1].UI:SetSwitchOn(true, false)
    end
end
function M:OnEKeyDown()
    if self.CurMainTab.Name ~= "Char" then
        return
    else
        self.Com_Tab.Tabs[2].UI:SetSwitchOn(true, false)
    end

end
function M:OnAKeyDown()
    if self.CurMainTab.Name == "Char" or self.SelectedWeaeponTab == "Melee" then
        return nil
    else
        self:OnMeleeSelect()
    end

end
function M:OnDKeyDown()
    if self.CurMainTab.Name == "Char" or self.SelectedWeaeponTab == "Ranged" then
        return nil
    else
        self:OnRangedSelect()
    end

end

-- function M:Tick(MyGeometry, InDeltaTime)
-- end
function M:InitTabContent(TabName)
    -- 初始化Tab
    local TabsData = DataMgr["ShowCaseTab"]
    local AllTabInfo = {
        [1] = {
            Text = GText(TabsData[1].TabName),
            IconPath = TabsData[1].Icon,
            Name = "Char",
            TabId = TabsData[1].TabId
        },
        [2] = {
            Text = GText(TabsData[2].TabName),
            IconPath = TabsData[2].Icon,
            Name = "Weapon",
            TabId = TabsData[2].TabId
        }

    }

    local TabConfigData = {
        TitleName = GText("UI_PersonInfo_ShowCase_Edit"),
        LeftKey = "Q",
        RightKey = "E",
        StyleName = "TextImage",
        Tabs = AllTabInfo,
        DynamicNode = {"Back", "ResourceBar", "BottomKey"},
        BottomKeyInfo = {{
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "B",
                Owner = self
            }},
            Desc = GText("UI_Tips_Ensure")
        }, {
            KeyInfoList = {{
                Type = "Text",
                Text = "Esc",
                ClickCallback = self.OnClose,
                Owner = self
            }},
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "B",
                ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            Desc = GText("UI_BACK")
        }},
        BackCallback = self.OnReturnKeyDown,
        OwnerPanel = self
    }

    self.Com_Tab:Init(TabConfigData)
    self.Com_Tab:BindEventOnTabSelected(self, self.OnTabItemSelected)

    if TabName == "Char" then
        self.Com_Tab:SelectTab(1)
    else
        self.Com_Tab:SelectTab(2)
    end
end

-- function M:Destruct()
-- end
---扳机事件，处理调防止主界面收到
function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    return UE4.UWidgetBlueprintLibrary.Handled()
end
function M:OnKeyDown(MyGeometry, InKeyEvent)

    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        self:OnGamePadDown(InKeyName)
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        if self.KeyEventTable[InKeyName] ~= nil then
            self.KeyEventTable[InKeyName](self)
        elseif (InKeyName == "Escape") then
            self:OnReturnKeyDown()

        end
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
end
function M:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    if self.GamePadKeyTable == nil then
        self.GamePadKeyTable = {
            [UIConst.GamePadKey.FaceButtonBottom] = self.OnGamePadAKeyDonw,
            [UIConst.GamePadKey.FaceButtonTop] = function()
                if not self.EnableY then
                    return
                end
                local FocusedIndex = self.FocusBoxIndex or 1
                local CurrentBox = self["Edit_AvatarItem_" .. FocusedIndex]
                self:OnBoxItemRemoveClick(FocusedIndex) -- 执行移除操作
                CurrentBox:PlayAnimation(CurrentBox.Normal) -- 播放默认状态动画
                CurrentBox.Btn_Click:SetVisibility(UIConst.VisibilityOp.Visible) -- 重置按钮可见性
                self.EnableY = true
            end,
            [UIConst.GamePadKey.FaceButtonLeft] = function() -- X
                if self.WBP_PersonalInfo_Edit_Tips:HasFocusedDescendants() then
                    self.WBP_PersonalInfo_Edit_Tips.Btn_Confirm.Button_Area.OnClicked:Broadcast()
                    if self.LastSelectedListContent and self.LastSelectedListContent.UI then
                        self.LastSelectedListContent.UI:SetFocus()
                    end
                    UIUtils.PlayCommonBtnSe(self)
                    return
                end
                if self.Btn_Confirm.Visibility == UIConst.VisibilityOp.Visible then
                    self:ReallySaveModelData()
                    UIUtils.PlayCommonBtnSe(self)
                end
            end,
            [UIConst.GamePadKey.FaceButtonRight] = function()
                if self.WBP_PersonalInfo_Edit_Tips:HasFocusedDescendants() then
                    self:TryToCloseTips()
                    return
                end
                if self.TileView_Select_Role:HasFocusedDescendants() then
                    self["Edit_AvatarItem_" .. self.SelectBoxIdx]:SetFocus()
                    return
                else
                    UIUtils.PlayCommonBtnSe(self)
                    self:OnReturnKeyDown()
                end
            end,
            [UIConst.GamePadKey.LeftThumb] = function()
                if not self.WS_List:HasFocusedDescendants() then ---不是列表，说明是目前foucs到某个Box，记住以便返回
                    self.IsFoucsFromBox = true
                else
                    self.IsFoucsFromBox = false
                end
                self.Common_Sort_List:SetFocus()
            end,
            [UIConst.GamePadKey.LeftTriggerThreshold] = function()
                self:OnAKeyDown()
                self:RefreshFocusItem()
            end,
            [UIConst.GamePadKey.RightTriggerThreshold] = function()
                self:OnDKeyDown()
                self:RefreshFocusItem()
            end
        }

    end
    if self.GamePadKeyTable[InKeyName] ~= nil then
        self.GamePadKeyTable[InKeyName](self)
        IsEventHandled = true
    end
    if IsEventHandled == false then
        IsEventHandled = self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName)
    end
    IsEventHandled = true -- handle所有手柄事件，不需要传到root
    return IsEventHandled
end
--- 手柄A键回调处理
--- 逻辑分支：
--- 1.聚焦与选中展柜不一致 -> 选中聚焦展柜
--- 2.聚焦与选中一致且为空 -> 打开背包
--- 3.聚焦与选中一致且有内容 -> 取消选中
function M:OnGamePadAKeyDonw()

    local FocusedIndex = self.FocusBoxIndex or 1 -- 获取当前聚焦的展柜索引
    if self.WBP_PersonalInfo_Edit_Tips:HasFocusedDescendants() then
        return
    end
    -- 情况1：聚焦与当前选中展柜不一致
    if FocusedIndex ~= self.SelectBoxIdx then
        self:OnBoxItemClick(FocusedIndex) -- 执行点击操作
        return
    end

    local CurrentBox = self["Edit_AvatarItem_" .. FocusedIndex]
    -- 情况2：展柜为空状态

    AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_large_crystal", nil, nil)
    self:SetFocusToList()

end
-- com_sort_C 需要一个GetZOrder，否则会报错
function M:GetZOrder()
    return 200
end
function M:OnFocusReceived(MyGeometry, InFocusEvent)
    return UIUtils.Handled
end
---手柄相关交互函数
-- 检测到输入设备变化，初始化手柄focus
function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    self.CurInputDeviceType = CurInputType
    if CurInputType == ECommonInputType.Gamepad then
        self:SetOriginFocus()
        self:FreshSubKeyInfo(true)
        self.Btn_Cancel:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Btn_Confirm:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        self:FreshSubKeyInfo(false)
        self.Btn_Cancel:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Btn_Confirm:SetVisibility(UIConst.VisibilityOp.Visible)
    end
end
---刷新武器界面的二级tab的key
function M:FreshSubKeyInfo(bIsGamePad)
    local idx = bIsGamePad and 1 or 0
    self.Switch_Mode_R:SetActiveWidgetIndex(idx)
    self.Switch_Mode_L:SetActiveWidgetIndex(idx)
end
---手柄聚焦入口
function M:SetOriginFocus()
    local Index = self:FindFirstEmptyBoxIndex()
    self["Edit_AvatarItem_" .. Index]:SetFocus()
end

function M:OnBoxFocus(index)
    self.FocusBoxIndex = index
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self:SetButtonPCStyle(false)
        AudioManager(self):PlayUISound(nil, "event:/ui/common/hover_btn_large_crystal", nil, nil)
        self:OnBoxItemClick(index)
    end
    if self["Edit_AvatarItem_" .. index].bIsEmpty then
        self:UpdataGamePadBottomAInfo(1)
    else
        self:UpdataGamePadBottomAInfo(2)
    end
end
function M:OnBoxFocusLost(index)
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self:SetButtonPCStyle(true)
    end
end
function M:SetButtonPCStyle(bPC)
    self.Btn_Cancel:SetPCVisibility(bPC)
    self.Btn_Confirm:SetPCVisibility(bPC)
end
function M:SetButtongamePadStyle()
    self.Key_R:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Btn_Cancel:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Btn_Confirm:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end
---  手柄特殊处理
function M:OnListItemClickedCommon()
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self.WBP_PersonalInfo_Edit_Tips:FocuesFirstItem()
    end
end
function M:OnFocusTipsSelectedItem()
    self:UpdataGamePadBottomAInfo(4)
end
function M:OnFocusTipsNotSelectedItem()
    self:UpdataGamePadBottomAInfo(3)
end
---手柄切换tab时调用，重新聚焦到新的item
function M:RefreshFocusItem()
    self.Root:AddTimer(0.01, function()
        if self.TileView_Select_Role:HasFocusedDescendants() or self.WBP_PersonalInfo_Edit_Tips:HasFocusedDescendants() then
            self:SetFocusToList()
        end
    end)
end

function M:OnSortListWidgetBack(MyGeometry, InKeyEvent)
    if (self.LastFocusList:IsVisible()) then
        return self.LastFocusList
    end
end
--- 使用手柄时，更新底部按键信息 1 A确认 B返回,  2 Y清除 A 确认 B返回, 3 A确认 B取消, 4 B取消
function M:UpdataGamePadBottomAInfo(KindNum)
    -- local keytable={
    --     "UI_Controller_CheckDetails",
    -- }
    self.EnableY = false

    local BottomKeyInfo = {{
        GamePadInfoList = {{
            Type = "Img",
            ImgShortPath = "A",
            -- ClickCallback = self.OnReturnKeyDown,
            Owner = self
        }},
        Desc = GText("UI_Tips_Ensure")
    }, {
        KeyInfoList = {{
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.OnClose,
            Owner = self
        }},
        GamePadInfoList = {{
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
        }},
        Desc = GText("UI_BACK")
    }}

    if KindNum == 2 then
        table.insert(BottomKeyInfo, 1, {
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "Y",
                -- ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            Desc = GText("UI_WeaponStrength_Clear")
        })
        self.EnableY = true
        -- BottomKeyInfo[1].Desc=GText("UI_WeaponStrength_Clear")
    elseif KindNum == 3 then
        BottomKeyInfo[2].Desc = GText("UI_PATCH_CANCEL")
    elseif KindNum == 4 then
        BottomKeyInfo[1] = BottomKeyInfo[2]
        BottomKeyInfo[2] = nil
        BottomKeyInfo[1].Desc = GText("UI_PATCH_CANCEL")
    end
    if BottomKeyInfo ~= nil then
        self.Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo)
    end

end
---策划希望聚焦到com_sort时自定义取消逻辑，但是com_sort有自己的Onkeydown逻辑，优先级更高，只好放在这里
function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == UIConst.GamePadKey.FaceButtonRight and self.Common_Sort_List:HasAnyFocus() and self.IsFoucsFromBox) then
        -- self:SetFocus()
        self:SetOriginFocus()
        return UE4.UWidgetBlueprintLibrary.Handled()

    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end
-- 手柄逻辑补充
function M:OpenTips()
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self.Common_Sort_List:SetControllerKeyHidden(true)
    end
end

AssembleComponents(M)

return M
