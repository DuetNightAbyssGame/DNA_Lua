--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Build_DefaultList_P_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

--function M:Initialize(Initializer)
--end

function M:Construct()
    M.Super.Construct(self)
    --EventManager:AddEvent(EventID.OpenSquadGamepad, self, self.OnOpenSquadGamepad)
    --EventManager:AddEvent(EventID.CloseSquadGamepad, self, self.OnCloseSquadGamepad)
    --EventManager:AddEvent(EventID.EntryReceiveEnterState,self,self.OnEntryReceiveEnterState)
    self:AddDispatcher(EventID.EntryReceiveEnterState, self, self.OnEntryReceiveEnterState)
    self:AddDispatcher(EventID.GuilfWarLevelSelectReceiveEnterState, self, self.OnEntryReceiveEnterState)
    self.List_Default:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.List_Default:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    self.List_Default:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    self.List_Default:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)

    self:AddInputMethodChangedListen()
    self:AddDispatcher(EventID.NightBookSpecialRightUp, self, self.OnSpecialRightUp)
    self.IsShow = false
    self.Btn_Build:SetVisibility(UE4.ESlateVisibility.Collapsed)

    local ArmoryConfigData = {
        OwnerWidget = self,
        TextContent = GText("UI_ArmourySquad_Tips"),
        --ClickCallback=self.QaArmoryClickCallBack,
        OnMenuOpenChangedCallBack = self.OnMenuOpenChangedCallBack
    }
    --self.Btn_Qa_Armory:Init(ArmoryConfigData)

    local DefaultConfigData = {
        OwnerWidget = self,
        TextContent = GText("UI_CustomSquad_Tips"),
        --ClickCallback=self.QaDefaultClickCallBack,
        OnMenuOpenChangedCallBack = self.OnMenuOpenChangedCallBack
    }
    self.Btn_Qa_Default:Init(DefaultConfigData)

    self.Team_Armory:SetNavigationRuleCustom(EUINavigation.Down, { self, function()
        self.List_Default:NavigateToIndex(0)
        -- local Content = self.List_Default:GetItemAt(0)
        -- local entryWidget = Content.UI
        -- if entryWidget then
        --     DebugPrint("entryWidgetentryWidgetentryWidgetentryWidgetentryWidget")
        -- end
        -- return entryWidget
    end })
    self.Team_Armory:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.Team_Armory:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    self.Team_Armory:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)

    self.Text_Title_Armory:SetText(GText("UI_ArmourySquad_Title"))
    self.Text_Title_Default:SetText(GText("UI_CustomSquad_Title"))
end

function M:OnSpecialRightUp()
    local Parent = self.Parent
    if not Parent then return end

    -- 可选日志（放在判空之后，避免 Parent 为 nil 崩）
    if Parent.GetName then
        DebugPrint("OnSpecialRightUp Parent", Parent:GetName())
    end
    -- 在聚焦list和轮次界面时不允许切换 
    local hasFocusListFn = type(Parent.IsFocusList) == "function"
        local isFocusList = hasFocusListFn and Parent:IsFocusList() or false
        
        local hasAutoNextFn = type(Parent.IsFocusAutoNextRound) == "function"
        local isAutoNext = hasAutoNextFn and Parent:IsFocusAutoNextRound() or false
        
        -- 是否允许切换
        local allowToggle = not (isFocusList or isAutoNext)
        
        local doOpen  = (not self.IsShow) and allowToggle
        local doClose = (self.IsShow)     and allowToggle
        
        if doOpen then
            self:OnOpenSquadGamepad()
            Parent.CurrentFocusType = "DefaultList"
        elseif doClose then
            self:OnCloseSquadGamepad()
        end
        
end

-- function M:QaDefaultClickCallBack(IsChecked)
--     self.IsDefaultChecked = IsChecked
-- end

-- function M:QaArmoryClickCallBack(IsChecked)
--     self.IsArmoryChecked = IsChecked
--     DebugPrint("self.IsArmoryChecked  ",self.IsArmoryChecked)
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end
function M:OpeArmorynMenuAnchor()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_01", nil, nil)
    -- self.Btn_Qa_Armory.Btn_Click:SetChecked(true)
    -- self.Btn_Qa_Armory:OpenMenuAnchor()
end

function M:OpenDefaultMenuAnchor()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_01", nil, nil)
    self.Btn_Qa_Default:PlayAnimation(self.Btn_Qa_Default.Click)
    self.Btn_Qa_Default.Btn_Click:SetChecked(true)
    self.Btn_Qa_Default:OpenMenuAnchor()
end

function M:IsMenuAnchorOpen()
    return self.Btn_Qa_Default:IsMenuAnchorOpen()
end

function M:CloseMenuAnchor()
    --self.Btn_Qa_Armory:CloseMenuAnchor()
    self.Btn_Qa_Default:CloseMenuAnchor()
end

function M:OnMenuOpenChangedCallBack(bIsOpen)
    if UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad then
        if(bIsOpen) then
            --self.Key_Armory:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Key_Default:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Btn_Build:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
            self.Btn_Close:SetVisibility(UE4.ESlateVisibility.Visible)
            self:UpdatKeyDisplay("")
        else
            --self.Key_Armory:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.Key_Default:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.Btn_Build:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            self.Btn_Close:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
            self:UpdatKeyDisplay("Selected")
        end
    else
        if(bIsOpen) then
            self.Btn_Close:SetVisibility(UE4.ESlateVisibility.Collapsed)

        else
            self.Btn_Close:SetVisibility(UE4.ESlateVisibility.Visible)

        end
    end
end

function M:Init(Parent,bDisablePhantom,Index,CurSelectedDungeonId,bGuildWar)
    self.Avatar = GWorld:GetAvatar()
    if not self.Avatar then
        return
    end

    self.bGuildWar = bGuildWar
    self.CurSelectedDungeonId = CurSelectedDungeonId
    self.CurrentSquad = Index
    self.bDisablePhantom = bDisablePhantom
    self.Parent = Parent
    self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Panel_List:SetRenderOpacity(0)
    self.BackgroundBlur_59:SetRenderOpacity(0)
    self.Btn_Close:SetVisibility(ESlateVisibility.Collapsed)
    self.Btn_Close.OnClicked:Add(self.Preview, self.Preview.OnClicked)
    self.List_Default.BP_OnItemClicked:Add(self,self.OnListItemSelected)
    self.List_Default.BP_OnItemIsHoveredChanged:Add(self,self.OnItemIsHoverChanged)
    self.Btn_Build:SetText(GText("UI_Squad_Edit"))
    self.Btn_Build.Button_Area.OnClicked:Add(self, self.OnGoToSystem)
    self:InitWidgetInfoInGamePad()
    self:RefreshData()

    if CommonUtils.GetDeviceTypeByPlatformName() == "Mobile" then
        self.List_Default:SetControlScrollbarInside(false)
    else
        self.List_Default:SetControlScrollbarInside(true)
    end

    if self.CurrentSquad == 0 then
        self.Team_Armory:UpSelected()
    end

end

function M:RefreshData()
    self.SquadList = self.Avatar.Squad
    self:UpdateSquadListInfo()
    self:InitSquadList()
    self:UpdateCurrentDungeonSquad(self.CurrentSquad)
    self.Preview:InitSquadData(self,self.bDisablePhantom,self.CurrentSquad)
end

function M:OnGoToSystem()
     AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
     if self.CurrentSquad == 0 then return end
     local SquadMainUI = UIManager(self):GetUIObj("SquadMainUINew")
     if SquadMainUI then
        SquadMainUI.IsFromDungeonPage = true
        PageJumpUtils:JumpToTargetPage("SquadMainUINew")
        SquadMainUI:JumpToEditSquadByIndex(self.CurrentSquad)
     else
        PageJumpUtils:JumpToTargetPage("SquadMainUINew",self.CurrentSquad)
     end
end

--更新当前选择副本使用的阵容预设
function M:UpdateCurrentDungeonSquad(Index)
    local function HandleEmptySquadView()
        self.CurrentSquad = 0
        self.Preview:UpdateView(self.SquadNewInfo,Index)
        self.CurrentCharId = self.SquadNewInfo.CharId
        self.CurrentCharLevel = self.SquadNewInfo.CharLevel
        if self.CurSelectContent then
            self.CurSelectContent.IsSelected = false
            if self.CurSelectContent.UI then
                self.CurSelectContent.UI:SetIsSelected(false)
            end
            self.CurSelectContent = nil
        end
        self.Preview.WS_Type:SetActiveWidgetIndex(1)
        self.Btn_Build:ForbidBtn(true)
        self.Btn_Build:BindForbidStateExecuteEvent(self, self.OnForbiddenBtnClicked)
        EventManager:FireEvent(EventID.CurrentSquadChange, 0, false,self.CurSelectedDungeonId)
    end
    if Index == 0 then
        HandleEmptySquadView()
        return
    end
    self.Btn_Build:ForbidBtn(false)
    self.Preview.WS_Type:SetActiveWidgetIndex(0)
    for _, value in pairs(self.SquadInfoList) do
        if value.Index == Index then
            self.CurrentSquad = Index
            self.Preview:UpdateView(value,Index)
            self.CurrentCharId = value.CharId
            self.CurrentCharLevel = value.CharLevel
            local IsComMissing = value.CharId == nil
                or value.MeleeWeaponId == nil
                or value.RangedWeaponId == nil
            EventManager:FireEvent(EventID.CurrentSquadChange, value.Index, IsComMissing,self.CurSelectedDungeonId)
            return
        end
    end
    -- 如果没有找到匹配的Index，执行默认逻辑
    HandleEmptySquadView()
end

--更新预设阵容列表信息
function M:UpdateSquadListInfo()
    self.SquadInfoList = {}
    --self:UpdateSquadListFromAvatar()
    --初始化阵容信息item
    local Index = 0
    for key, value in pairs(self.SquadList) do
        local SquadInfo = {}
        Index = Index + 1
        if not key then
            SquadInfo.SquadName = GText("Squad_DefaultName1")
         else
             SquadInfo.SquadName = key --预设阵容名字
         end
        SquadInfo.Index = Index
        for Name, Id in pairs(value.Props) do
            if Name == "Char" or Name == "Phantom1" or Name == "Phantom2" then
                if Id ~= "" and self.Avatar.Chars[Id] then
                    SquadInfo[Name .. "Id"] = self.Avatar.Chars[Id].CharId
                    SquadInfo[Name .. "Level"] = self.Avatar.Chars[Id].Level
                end
                SquadInfo[Name] = Id
            elseif Name == "MeleeWeapon" or Name == "RangedWeapon" or Name == "PhantomWeapon1" or Name == "PhantomWeapon2" then
                if Id ~= "" and self.Avatar.Weapons[Id]  and self.Avatar.Weapons[Id].WeaponId ~= 0 then
                    SquadInfo[Name .. "Id"] = self.Avatar.Weapons[Id].WeaponId
                    SquadInfo[Name .. "Level"] = self.Avatar.Weapons[Id].Level
                end
                SquadInfo[Name] = Id
            elseif Name == "Pet" and self.Avatar.Pets[Id] then
                SquadInfo[Name.."Id"] = self.Avatar.Pets[Id].Props.PetId
                SquadInfo[Name.."Level"] = self.Avatar.Pets[Id].Level
            else
                SquadInfo[Name] = Id
            end
            -- DebugPrint("InitInitInitInitInitInit  Name  ",Name)
            -- DebugPrint("InitInitInitInitInitInit  Id  ",Id)
        end
        table.insert(self.SquadInfoList, SquadInfo)
    end

    --整备阵容预设
    local TempSquad = self.Avatar:CreateTempSquad()
    self.SquadNewInfo = {}
    for Name, Id in pairs(TempSquad.Props) do
        if Name == "Char" or Name == "Phantom1" or Name == "Phantom2" then
            if Id ~= "" and self.Avatar.Chars[Id] then
                self.SquadNewInfo[Name .. "Id"] = self.Avatar.Chars[Id].CharId
                self.SquadNewInfo[Name .. "Level"] = self.Avatar.Chars[Id].Level
            end
            self.SquadNewInfo[Name] = Id
        elseif Name == "MeleeWeapon" or Name == "RangedWeapon" or Name == "PhantomWeapon1" or Name == "PhantomWeapon2" then
            if Id ~= "" and self.Avatar.Weapons[Id] and self.Avatar.Weapons[Id].WeaponId ~=0 then
                self.SquadNewInfo[Name .. "Id"] = self.Avatar.Weapons[Id].WeaponId
                self.SquadNewInfo[Name .. "Level"] = self.Avatar.Weapons[Id].Level
            end
            self.SquadNewInfo[Name] = Id
        elseif Name == "Pet" and self.Avatar.Pets[Id] then
            self.SquadNewInfo[Name.."Id"] = self.Avatar.Pets[Id].Props.PetId
            self.SquadNewInfo[Name.."Level"] = self.Avatar.Pets[Id].Level
        else
            self.SquadNewInfo[Name] = Id
        end
        -- DebugPrint("InitInitInitInitInitInit  Name  ",Name)
        -- DebugPrint("InitInitInitInitInitInit  Id  ",Id)
    end
    self.SquadNewInfo.Name = GText("UI_ArmourySquad_Title")
end

function M:InitSquadList()
    self.List_Default:ClearListItems()
    for _, value in pairs(self.SquadInfoList) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.SquadInfo = value
        Content.Parent = self
        self.List_Default:AddItem(Content)
    end

    local SquadMax = DataMgr.GlobalConstant.SquadMax.ConstantValue or 10
    if SquadMax > #self.SquadInfoList then
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.SquadInfo = nil
        self.List_Default:AddItem(Content)
    end
    self.List_Default:SetNavigationRuleCustom(EUINavigation.Up, { self, function()
        return self.Team_Armory
    end })
    self.Team_Armory:InitItemContent(self.SquadNewInfo, self)
    -- self:AddTimer(0.01, function()
    --     local Content = self.List_Default:GetItemAt(0)
    --     local entryWidget = Content.UI
    --     if entryWidget then
    --         DebugPrint("AddTimerentryWidgetentryWidgetentryWidgetentryWidgetentryWidget")

    --     end
    -- end, false, 0, "WBP_Build_DefaultList")
end


function M:OnItemIsHoverChanged(Item, bIsHovered)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        local Entry = Item.UI
        if not Entry then
            return
        end
        if  not Entry.IsSelected then
            self:UpdatKeyDisplay("NotSelected")
        else
            self:UpdatKeyDisplay("Selected")
        end
    end
end

function M:OnListItemSelected(Content)
    if not Content or self.CurSelectContent == Content then
        return
    end

    -- 检查组件缺失
    local IsComMissing = false
    if Content.SquadInfo then
        IsComMissing = Content.SquadInfo.CharId == nil
            or Content.SquadInfo.MeleeWeaponId == nil
            or Content.SquadInfo.RangedWeaponId == nil
    end

    -- 如果组件缺失，只播放红闪，不取消之前的选中
    if IsComMissing or not Content.SquadInfo then
        if Content.UI then
            Content.UI:ShowMissingComponentHint()
        end
        return  -- 直接退出，不设置选中状态
    end

    -- 清除 Team_Armory 状态
    if self.Team_Armory then
        self.Team_Armory.IsSelected = false
        self.Team_Armory:PlayAnimation(self.Team_Armory.Normal)
    end

    -- 清除旧项状态
    if self.CurSelectContent then
        self.CurSelectContent.IsSelected = false
        if self.CurSelectContent.UI then
            self.CurSelectContent.UI:SetIsSelected(false)
        end
    end

    -- 设置新选中项
    self.CurSelectContent = Content
    Content.IsSelected = true
    if Content.UI then
        Content.UI:SetIsSelected(true)
    end
end

function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.In then
        self.Btn_Close:SetVisibility(ESlateVisibility.Visible)
    elseif InAnimation == self.Out then
        self.Btn_Close:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:OnEntryReceiveEnterState(StackAction)
    if StackAction == 1 and self.IsShow then
        self:UpdatKeyDisplay("NotSelected")
        self:RefreshData()
        self.Team_Armory:SetFocus()
    end
end

function M:OnOpenSquadGamepad()
    self.Preview.Parent = self
    self.Preview:OnClicked()
    if self.CurrentSquad == 0 then
        self:BlockAllUIInput(true,"SP_DisplayOnly")
        self:AddTimer(
            0.1,
            function()
                self:BlockAllUIInput(false)
                self.Team_Armory:SetFocus()
            end,
            false, 0, "OnOpenSquadGamepad")
        self.Team_Armory:OnMouseButtonDown()
    else
        self.List_Default:NavigateToIndex(0)
        self:UpdatKeyDisplay("")
    end
end

function M:OnCloseSquadGamepad()
    self.Preview.Parent = self
    self.Preview:OnClicked()
    if self.Parent.SelectCell then
        local LevelButton = nil 
        if not self.bGuildWar then
            LevelButton = self.Parent.SelectCell.Bg_List.Button_Area
        else
            LevelButton = self.Parent.SelectCell.Btn_Click
        end
        if not LevelButton then return end
        if not LevelButton:HasAnyUserFocus() and type(self.Parent.SelectCellFocus) == "function"then
            self.Parent:SelectCellFocus()
        end
    end
end

function M:InitWidgetInfoInGamePad()
    self.Mobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
    if self.Mobile then
        return
    end
    if (UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad) then
        return
    end
    if not self.IsShow then
        self.Preview.WS_Controller:SetActiveWidgetIndex(1)
        self.Preview.Key_Controller_Fold:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Img",
                    ImgShortPath = "Menu",
                }
            },
            -- bLongPress = false,
            -- Desc = GText('UI_CTL_Squad_Expand'),
        })
        self.Preview.Key_Controller_Summon:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Preview.Key_Controller_Summon:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Img",
                    ImgShortPath = "Left",
                }
            },
        })

        self.Preview.Key_Controller_Summon_Switch:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Preview.Key_Controller_Summon_Switch:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Img",
                    ImgShortPath = "Right",
                }
            },
        })

    end

    -- self.Key_Armory:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- self.Key_Armory:CreateCommonKey({
    --     KeyInfoList = {
    --         {
    --             Type = "Img",
    --             ImgShortPath = "Left",
    --         }
    --     },
    --     bLongPress = false,
    -- })

    self.Key_Default:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Key_Default:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "LS",
            }
        },
        bLongPress = false,
    })

    self.Btn_Build:SetGamePadImg("X")
    self.Btn_Build:SetGamePadVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 输入设备切换通知
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if not IsUseKeyAndMouse then
        if self.IsShow then
            self.Team_Armory:SetFocus()
        end
        self:InitWidgetInfoInGamePad()
    else
        self:ApplyPcUiLayout()
    end

    self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

function M:ApplyPcUiLayout()
    if CommonUtils.GetDeviceTypeByPlatformName()=="Mobile" then return end
    --self.KeyArmory:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Key_Default:SetVisibility(UE4.ESlateVisibility.Collapsed)

    self.Preview.WS_Controller:SetActiveWidgetIndex(0)
    self.Preview.Key_Controller_Summon:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Preview.Key_Controller_Summon_Switch:SetVisibility(UE4.ESlateVisibility.Collapsed)

    self.Btn_Build:SetGamePadVisibility(UIConst.VisibilityOp["Collapsed"])
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    if not self.IsShow then
        return UWidgetBlueprintLibrary.UnHandled()
    end
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName == "Gamepad_LeftThumbstick" then
            if self.IsShow then
                self:OpenDefaultMenuAnchor()
                IsEventHandled = true
            end
        elseif InKeyName == "Gamepad_DPad_Left" then
            if self.IsShow then
                self:OpeArmorynMenuAnchor()
                IsEventHandled = true
            end
        end
    end
    if (IsEventHandled) then
        return UWidgetBlueprintLibrary.Handled()
    else
        return UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:UpdatKeyDisplay(FocusTypeName)
    local StyleOfPlay = UIManager(self):GetUIObj("StyleOfPlay")
    if not StyleOfPlay then
        return
    end

    if not self.IsShow then
        return
    end

    if FocusTypeName == "Armory" then
        if self:IsMenuAnchorOpen() then return end
        local BottomKeyInfo = {
            {
                KeyInfoList = { { Type = "Text", Text = "Esc", Owner = self } },
                GamePadInfoList = {
                    { Type = "Img", ImgShortPath = "B", Owner = self }
                },
                Desc = GText("UI_BACK"),
            }
        }
        -- 更新界面按键提示
        StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
        -- self:UpdateUIStyleInPlatform(true)
        -- StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        -- StyleOfPlay.ComTab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
        -- self.Cost.Key:SetVisibility(UE4.ESlateVisibility.Collapsed)
        -- self.Tab_Info:UpdateUIStyleInPlatform(true)
        -- self:UpdateKeyMoreVisibility()

        if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
            self.Btn_More:SetVisibility(ESlateVisibility.Collapsed)
        end

    elseif FocusTypeName == "NotSelected" then
        if self:IsMenuAnchorOpen() then return end
        local BottomKeyInfo = {
            {
                GamePadInfoList = {
                    { Type = "Img", ImgShortPath = "A", Owner = self }
                },
                Desc = GText("ModFilter_Confirm"),
                bLongPress = false,
            },
            {
                KeyInfoList = { { Type = "Text", Text = "Esc", Owner = self } },
                GamePadInfoList = {
                    { Type = "Img", ImgShortPath = "B", Owner = self }
                },
                Desc = GText("UI_BACK"),
            }
        }
        -- 更新界面按键提示
        StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)

    elseif FocusTypeName == "Selected" then
        if self:IsMenuAnchorOpen() then return end
        local BottomKeyInfo = {
            {
                KeyInfoList = { { Type = "Text", Text = "Esc", Owner = self } },
                GamePadInfoList = {
                    { Type = "Img", ImgShortPath = "B", Owner = self }
                },
                Desc = GText("UI_BACK"),
            }
        }
        -- 更新界面按键提示
        StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
    else
        local BottomKeyInfo = {
            {
                KeyInfoList = { { Type = "Text", Text = "Esc", Owner = self } },
                GamePadInfoList = {
                    { Type = "Img", ImgShortPath = "B", Owner = self }
                },
                Desc = GText("UI_CTL_CloseTips"),
            }
        }
        -- 更新界面按键提示
        StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
    end
end

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
    local IsEventHandled = false
    if InKeyName == Const.GamepadFaceButtonRight and self.Parent.FocusTypeName ~= "RewardWidget" then
        if self:IsMenuAnchorOpen() then
            self:CloseMenuAnchor()
            if self.Team_Armory.IsSelected then
                self.Team_Armory:SetFocus()
            else
                local Widgets = self.List_Default:GetDisplayedEntryWidgets()
                for _, Widget in pairs(Widgets) do
                    if Widget.IsSelected then
                        Widget:SetFocus()
                        break
                    end
                end
            end
            IsEventHandled = true
        else
            IsEventHandled = false
        end
    elseif InKeyName == Const.GamepadFaceButtonLeft and self.Parent.FocusTypeName ~= "RewardWidget" then
            if self.CurrentSquad == 0 then
                self:OnForbiddenBtnClicked()
            end
           IsEventHandled = true

    elseif InKeyName == "Gamepad_Special_Right" then
        if self.bGuildWar then
            self:OnSpecialRightUp()
            IsEventHandled = true
        end
    end 
    return IsEventHandled
end

function M:OnForbiddenBtnClicked()
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, "UI_ArmourySquad_Edit_Toast")
end

return M
