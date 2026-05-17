--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--通用阵容预设 控件名 WBP_Build_DefaultList
require "UnLua"

---@type WBP_Build_Common_DefaultList_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

local GAMEPAD_KEY_EXPAND_SQUAD = Const.GamepadDPadDown

function M:Construct()
    M.Super.Construct(self)
    self.Btn_Show.OnClicked:Add(self, self.OnClicked)
    self.Btn_Show.OnPressed:Add(self, self.OnPressed)
    self.Btn_Show.OnHovered:Add(self, self.OnHovered)
    self.Btn_Show.OnUnhovered:Add(self, self.OnUnhovered)
    self.Btn_Close.OnClicked:Add(self, self.OnClicked)
    local DefaultConfigData = {
        OwnerWidget = self,
        TextContent = GText("UI_CustomSquad_Tips"),
        --ClickCallback=self.QaDefaultClickCallBack,
        OnMenuOpenChangedCallBack = self.OnMenuOpenChangedCallBack
    }
    self.Btn_Qa_Default:Init(DefaultConfigData)
    self:AddDispatcher(EventID.CurrentSquadChange, self, self.OnCurrentSquadChange)
    self:InitInputSettings()
    self:InitNavigation()
    self.Team_Armory:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.Team_Armory:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    self.Team_Armory:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


function M:Init(Parent,Index,DungeonId)
    self.Avatar = GWorld:GetAvatar()
    if not self.Avatar then
        return
    end
    self.CurrentSquad = Index
    self.Parent = Parent
    self.IsExpand = false
    self.DungeonId = DungeonId
    -- 建议进入时播放一个重置动画
    self:PlayAnimation(self.Fold_Normal)
    self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self:RefreshData()
    self:UpdateCurrentDungeonSquad(Index)
    --self.Panel_List:SetRenderOpacity(0)
    self.Btn_Close:SetVisibility(ESlateVisibility.Collapsed)
    self.Key_Default:SetVisibility(UE4.ESlateVisibility.Collapsed)

    self.List_Default.BP_OnItemClicked:Add(self,self.OnListItemSelected)
    self.List_Default.BP_OnItemIsHoveredChanged:Add(self,self.OnItemIsHoverChanged)
    --self:InitWidgetInfoInGamePad()

    if CommonUtils.GetDeviceTypeByPlatformName() == "Mobile" then
        self.List_Default:SetControlScrollbarInside(false)
    else
        self.List_Default:SetControlScrollbarInside(true)
    end

    if self.CurrentSquad == 0 then
        self.Team_Armory:UpSelected()
    end

    self.Text_Title_Armory:SetText(GText("UI_ArmourySquad_Title"))
    self.Text_Title_Default:SetText(GText("UI_CustomSquad_Title"))
    self.Text_Close:SetText(GText("UI_RougeLike_End__ClickEmpty"))

end

function M:RefreshData()
    self.SquadList = self.Avatar.Squad
    self:UpdateSquadListInfo()
    self:InitSquadList()
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


    self.List_Default:SetNavigationRuleCustom(EUINavigation.Up, { self, function()
        return self.Team_Armory
    end })
    self.Team_Armory:InitItemContent(self.SquadNewInfo, self)
end

function M:OnCurrentSquadChange(SquadId, IsComMissing,CurSelectedDungeonId)
    if  self.DungeonId == CurSelectedDungeonId then
        self.CurrentSquad = SquadId
    end
end

--更新当前选择副本使用的阵容预设
function M:UpdateCurrentDungeonSquad(Index)
    local function HandleEmptySquadView()
        self.CurrentSquad = 0
        self:SetCurrentIcon(self.SquadNewInfo)
        self.CurrentCharId = self.SquadNewInfo.CharId
        if self.CurSelectContent then
            self.CurSelectContent.IsSelected = false
            if self.CurSelectContent.UI then
                self.CurSelectContent.UI:SetIsSelected(false)
            end
            self.CurSelectContent = nil
        end
        self.Btn_Build:ForbidBtn(true)
        self.Btn_Build:BindForbidStateExecuteEvent(self, self.OnForbiddenBtnClicked)
        --EventManager:FireEvent(EventID.CurrentSquadChange, 0, false)
    end
    if Index == 0 then
        HandleEmptySquadView()
        return
    end
    self.Btn_Build:ForbidBtn(false)
    for _, value in pairs(self.SquadInfoList) do
        if value.Index == Index then
            self.CurrentSquad = Index
            self:SetCurrentIcon(value)
            self.CurrentCharId = value.CharId
            local IsComMissing = value.CharId == nil
                or value.MeleeWeaponId == nil
                or value.RangedWeaponId == nil
            --EventManager:FireEvent(EventID.CurrentSquadChange, value.Index, IsComMissing)
            return
        end
    end
    -- 如果没有找到匹配的Index，执行默认逻辑
    HandleEmptySquadView()
end

--设置当前选中的阵容显示
function M:SetCurrentIcon(SquadInfo)
    -- 设置预设阵容名字
    self.Text_Name:SetText(SquadInfo.Name)

    -- 通用设置图标
    local function SetIconComponent(Component, Category, Id, EmptyCategory)
        local Icon = nil
        if Id  and DataMgr[Category][Id] then
            Icon = DataMgr[Category][Id].Icon or ""
        end
        Component:InitIcon(Icon and Category or EmptyCategory, Icon)
        Component.Panel_Level:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    -- 设置角色、武器、宠物图标
    SetIconComponent(self.Character, "Char", SquadInfo.CharId, "Empty")
    SetIconComponent(self.Melee, "Weapon", SquadInfo.MeleeWeaponId, "Empty")
    SetIconComponent(self.Range, "Weapon", SquadInfo.RangedWeaponId, "Empty")
    SetIconComponent(self.Pet, "Pet", SquadInfo.PetId, "EmptyPet")

    -- 设置魅影图标
    DebugPrint("gmy@WBP_Build_Common_DefaultList_C M:SetCurrentIcon111", self.CurrentSquad)

    if self.CurrentSquad == 0 then
        self.WS_Type:SetActiveWidgetIndex(1)
    else
        self.WS_Type:SetActiveWidgetIndex(0)
    end
    
    if not self.bDisablePhantom then
        for i = 1, 2 do
            local PhantomId = SquadInfo["Phantom" .. i .. "Id"]
            local WeaponId = SquadInfo["PhantomWeapon" .. i .. "Id"]
            local SwitchWidget = self["Switch_Type0" .. i]
            local HeadWidget = self["Head_Phantom0" .. i]
            
            if PhantomId then
                if WeaponId then
                    local MiniIconPath = "/Game/UI/Texture/Dynamic/Image/Head/Mini/"
                    local PhantomGuideIconImg = DataMgr.BattleChar[PhantomId].GuideIconImg
                    local NormalIconName = "T_Normal_" .. PhantomGuideIconImg
                    local IconPath = MiniIconPath .. NormalIconName .. "." .. NormalIconName
                    HeadWidget:SetBrushResourceObject(LoadObject(IconPath))
                    SwitchWidget:SetActiveWidgetIndex(0)
                else
                    SwitchWidget:SetActiveWidgetIndex(2) -- 有魅影但武器缺失 显示叹号
                end
            else
                SwitchWidget:SetActiveWidgetIndex(1)
            end
        end
    else
        self.Switch_Type01:SetActiveWidgetIndex(3)
        self.Switch_Type02:SetActiveWidgetIndex(3)
    end

    -- 设置轮盘图标
    self.Roulette:SetWheelIcon(nil, SquadInfo.WheelIndex or 1)

    -- 显示缺失提示
    self.IsMissing = not SquadInfo.CharId or not SquadInfo.MeleeWeaponId or not SquadInfo.RangedWeaponId
end

function M:OnClicked()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
    --self:PlayAnimation(self.Click)
    
    DebugPrint("gmy@WBP_Build_Common_DefaultList_C M:OnClicked", self.IsExpand)
    if self.IsExpand then
        self:FoldPanel()
    else
        self:UnfoldPanel()
    end
end

function M:OnPressed()
    --self:PlayAnimation(self.Press)
end

function M:OnHovered()
-- DebugPrint("OnHoveredOnHoveredOnHovered")
--     self:StopAllAnimations()
--     self:PlayAnimation(self.Hover)
end

function M:OnUnhovered()
    -- self:StopAllAnimations()
    -- self:PlayAnimation(self.UnHover)
end

function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.Unfold then
        self.Btn_Close:SetVisibility(ESlateVisibility.Visible)
    elseif InAnimation == self.Fold then
        self.Btn_Close:SetVisibility(ESlateVisibility.Collapsed)
    end
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

function M:OnMenuOpenChangedCallBack(bIsOpen)
    if UIUtils.UtilsGetCurrentInputType()==ECommonInputType.Gamepad then
        if (bIsOpen) then
            self.Key_Default:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Btn_Close:SetVisibility(UE4.ESlateVisibility.Visible)
            self:UpdatKeyDisplay("")
        else
            self.Key_Default:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
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

function M:UpdatKeyDisplay(FocusTypeName)
    local StyleOfPlay = UIManager(self):GetUIObj("StyleOfPlay")
    if not StyleOfPlay then
        return
    end
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

function M:InitInputSettings()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)

    self:AddDispatcher(EventID.GameViewportInputKeyReleased, self, function(self, Key)
        if Key.KeyName == GAMEPAD_KEY_EXPAND_SQUAD then
            DebugPrint("gmy@WBP_Build_Common_DefaultList_C M:InitInputSettings UnfoldPanel", Key.KeyName)
            if not self.IsExpand then
                self:UnfoldPanel()
            else
                -- TODO: 如果已经展开了，按下这个键就切换阵容
                
            end
        elseif Key.KeyName == Const.GamepadFaceButtonRight then
            DebugPrint("gmy@WBP_Build_Common_DefaultList_C M:InitInputSettings FoldPanel", Key.KeyName)
            if self.IsExpand then
                self:FoldPanel()
            end
        elseif Key.KeyName == Const.GamepadFaceButtonDown then
            DebugPrint("gmy@WBP_Build_Common_DefaultList_C M:InitInputSettings Select", Key.KeyName)

            if self.IsExpand then
                -- TODO: 如果已经展开了，切换选定的阵容

            end
        elseif Key.KeyName == Const.GamepadLeftThumbstick then
            if  self:IsMenuAnchorOpen() then            
                self:CloseMenuAnchor()
            else
                self:OpenDefaultMenuAnchor()
            end
        end
    end)

    self.Key_Controller_Show:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "Down",
            }
        },
        -- bLongPress = false,
        -- Desc = GText('UI_CTL_Squad_Expand'),
    })
    self.Gamepad_Shortcut01:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "A",
            }
        },
        Desc = GText("UI_SQUAD_SELECT_CONFIRM")
    })

    self.Gamepad_Shortcut02:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "B",
            }
        },
        Desc = GText("UI_SQUAD_SELECT_FOLD")
    })
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
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    DebugPrint("gmy@WBP_Build_Common_DefaultList_C M:OnUpdateUIStyleByInputTypeChange", CurInputDevice, CurGamepadName)

    if (self.CurInputDeviceType == CurInputDevice) then
        return
    end
    self.CurInputDeviceType = CurInputDevice

    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end

    --- 切换手柄端相关图标显隐
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if IsUseKeyAndMouse then
        self.UsingGamepad = false
        
        self:InitKeyAndMousePanel()
    else
        self.UsingGamepad = true
        
        -- 切换手柄端相关图标显隐
        self:InitGamepadPanel()

        if self.CurrentSquad == 0 then
            self.Team_Armory:SetFocus()
            self.Team_Armory:OnMouseButtonDown()
        else
            self.List_Default:NavigateToIndex(0)
            self:UpdatKeyDisplay("")
        end
    end
end

function M:InitGamepadPanel()
    if self.IsExpand then
        self.WS_Controller:SetActiveWidgetIndex(0)
    else
        self.WS_Controller:SetActiveWidgetIndex(1)
    end
    self.WS_Controller_Close:SetActiveWidgetIndex(1)
    self.Key_Default:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function M:InitKeyAndMousePanel()
    self.WS_Controller:SetActiveWidgetIndex(0)
    self.WS_Controller_Close:SetActiveWidgetIndex(0)
    self.Key_Default:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:FoldPanel()
    DebugPrint("gmy@WBP_Build_Common_DefaultList_C M:FoldPanel")
    if(CommonUtils:IfExistSystemGuideUI(self)) then
        return
    end
    AudioManager(self):SetEventSoundParam(self, "Play_Build_Select", {ToEnd = 1})
    self:StopAllAnimations()
    self:PlayAnimation(self.Fold)
    self:PlayAnimationReverse(self.ArrowFlip)
    self.IsExpand = false
    
    if self.UsingGamepad then
        self.WS_Controller:SetActiveWidgetIndex(1)
    end
    
    EventManager:FireEvent(EventID.TeamMatchSquadFold)
end

function M:UnfoldPanel()
    DebugPrint("gmy@WBP_Build_Common_DefaultList_C M:UnfoldPanel", self.CurrentSquad)
    AudioManager(self):PlayUISound(self, "event:/ui/common/preset_team_panel_expand", "Play_Build_Select", nil)
    self:StopAllAnimations()
    self:PlayAnimation(self.Unfold)
    self:PlayAnimation(self.ArrowFlip)
    
    self.IsExpand = true
    
    -- 展开列表时，手柄按键显示切回箭头
    self.WS_Controller:SetActiveWidgetIndex(0)
    
    -- 必须先发
    EventManager:FireEvent(EventID.TeamMatchSquadUnfold)

    -- focus 相关
    if self.CurrentSquad == 0 then
        self.Team_Armory:SetFocus()
        self.Team_Armory:OnMouseButtonDown()
    else
        self.List_Default:NavigateToIndex(0)
        self:UpdatKeyDisplay("")
    end
end

function M:InitNavigation()
end

return M
