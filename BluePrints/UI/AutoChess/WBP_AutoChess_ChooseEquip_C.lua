--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_AutoChess_ReplaceEquipment_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
local Model = require  "BluePrints.UI.AutoChess.AutoChessDataModel"

local EquipState = {
    UnLock = 0,  --未解锁
    UnEquip = 1,    --未装备
    Equiping = 2,   --装备中
}
local EquipRarity = {
    Blue = 3,
    Purple = 4,
    Gold = 5,
}

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end


function M:Construct()
    self.Btn_Equip.Button_Area.OnClicked:Add(self, self.AddEquip)
    self.Btn_Takeoff.Button_Area.OnClicked:Add(self, self.RemoveEquip)
    self.Btn_Lock.Button_Area.OnClicked:Add(self, self.OnClickFull)
    self.Btn_Close.OnClicked:Add(self, self.OnClickReturn)
    self.List_Item.OnCreateEmptyContent:Bind(self, function(self)
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        Obj.IsEmpty = true
        return Obj
    end)
end

function M:Destruct()
    self.Btn_Equip.Button_Area.OnClicked:Remove(self, self.AddEquip)
    self.Btn_Takeoff.Button_Area.OnClicked:Remove(self, self.RemoveEquip)
    self.Btn_Lock.Button_Area.OnClicked:Remove(self, self.OnClickFull)
    self.Btn_Close.OnClicked:Remove(self, self.OnClickReturn)
end

function M:OnLoaded(...)
    AudioManager(self):PlayUISound(self, "event:/ui/common/sub_panel_expand", "Open", nil)
    self:PlayAnimation(self.In)
    local Avatar = GWorld:GetAvatar()
    self.ChessData,self.ParentWidget = ...
    self.CurChess = nil
    self.CurEquip = nil
    self.Text_Title:SetTexT(GText("UI_AutoChess_EquipTitle"))
    self.List_Chess:ClearListItems()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        CommonUtils:CloseGuideTouchIfExist(self)
    end
    for key, value in pairs(Model:GetChessData()) do
        if value.Locked ~= true then
            local Content = NewObject(UIUtils.GetCommonItemContentClass())
            local EquipInfo = Model:GetMonsterEquipInfo(value.Id)
            Content.EquipCount = #EquipInfo
            Content.Id = value.Id
            Content.Parent = self
            Content.Selected = false
            if Content.Id == self.ChessData.Id then
                Content.Selected = true
            end
            self.List_Chess:AddItem(Content)
        end
    end
    self:InitNavigation()
    self.Tips_Equipment:SetVisibility(ESlateVisibility.Collapsed)
    self:FindFirstChess()
    self:InitTab()
    self:RefreshEquip(EquipRarity.Blue)
    self.Btn_Equip:SetGamePadImg("A")
    self.Btn_Takeoff:SetGamePadImg("A")
    self.Btn_Lock:SetGamePadImg("A")
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnUpdateUIStyleByInputTypeChange)
    self:OnUpdateUIStyleByInputTypeChange(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
end

function M:InitNavigation()

    self.List_Item:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.List_Item:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    self.List_Item:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    self.List_Chess:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.List_Chess:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    self.List_Chess:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)

    self.List_Item:SetNavigationRuleExplicit(EUINavigation.Right, self.List_Chess)
    self.List_Chess:SetNavigationRuleCustom(EUINavigation.Left, {self,function(_self)
        if self.CurEquip and self.CurEquip.ParentWidget then       
            return self.CurEquip.ParentWidget
        else
            return self.List_Item
        end
    end})



end

function M:OnClickChess()
    local NextTab = self.SubTab:GetCurrentTabIndex()
    local Result = 6 - NextTab
    self:RefreshEquip(Result)
end

function M:FindFirstChess()
    for _, Content in pairs(self.List_Chess:GetListItems()) do
        if Content.Id == self.ChessData.Id then
            self.CurChess = Content
            self.List_Chess:BP_NavigateToItem(Content)
            self.List_Chess:BP_SetSelectedItem(Content)
            return
        end
    end
end

function M:RefreshEquip(Rarity)
    self:PlayAnimation(self.Change)
    self.Tips_Equipment:SetVisibility(ESlateVisibility.Collapsed)
    self.List_Item:ClearListItems()
    self.CurEquipList = {}
    self.CurEquip = nil
    for key, value in pairs(DataMgr.RobotEquip) do
        if value.EquipRarity == Rarity then
            table.insert(self.CurEquipList, value)
        end
    end
    table.sort(self.CurEquipList, function(EquipA, EquipB)
        local StateA = self:GetEquipState(EquipA.EquipId, self.CurChess.Id)
        local StateB = self:GetEquipState(EquipB.EquipId, self.CurChess.Id)
        if StateA ~= StateB then
            return StateA > StateB  
        end
        if EquipA.DeployCost == EquipB.DeployCost then
            return EquipA.EquipId > EquipB.EquipId  
        else
            return EquipA.DeployCost > EquipB.DeployCost  
        end
    end)
    for key, value in pairs(self.CurEquipList) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Id = value.EquipId
        Content.ItemType = "RobotEquip"
        Content.Icon = value.EquipIcon
        Content.Rarity = value.EquipRarity
        Content.State = self:GetEquipState(value.EquipId, self.CurChess.Id)
        Content.CurrencyIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/T_Activity_AutoChess_IconCost.T_Activity_AutoChess_IconCost'"
        Content.CurrencyNum = value.DeployCost
        if Content.State == EquipState.UnLock then
            Content.LockType  = 2
        elseif  Content.State == EquipState.Equiping  then
            Content.bSelectTag = true
        end
        local New = Model:CheckEquipIsNew(value.EquipId)
        if New and Content.State ~= EquipState.UnLock then
            Content.RedDotType = UIConst.RedDotType.NewRedDot
        end
        Content.OnMouseButtonDownEvent = {Obj = self, Callback = function()
            self:OnClickEquip(Content)
            if self.UsingGamepad and not CommonUtils:IfExistSystemGuideUI(self) then
                local Equips = Model:GetMonsterEquipInfo(self.CurChess.Id)
                if Content.State == EquipState.UnEquip and #Equips ~= 2 then
                    self:AddEquip()
                elseif Content.State == EquipState.Equiping then
                    self:RemoveEquip()
                elseif #Equips == 2 then

                else
                    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_AutoChess_UnlockToast"))
                end
            end
            CommonUtils:CloseGuideTouchIfExist(self)
        end}
        Content.OnFocusReceivedEvent = {Obj = self, Callback = function()
            if self.UsingGamepad then
                self:OnClickEquip(Content)
            end
        end}
        self.List_Item:AddItem(Content)
    end
    self.List_Item:RequestFillEmptyContent()
    
    self:RefreshBtn()
end

function M:OnClickEquip(Content)
    local New = Model:CheckEquipIsNew(Content.Id)
    if New then
        Content.SelfWidget:SetRedDot(nil)
        Model:DecreaseEquipReddotById(Content.Id)
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/combat_bag_cell_place_common", nil, nil)
    if Content.State == EquipState.UnLock then
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_AutoChess_UnlockToast"))
        return
    end
    if self.CurEquip then
        self.CurEquip.SelfWidget:SetSelected(false)
    end
    Content.SelfWidget:SetSelected(true)
    self.CurEquip = Content
    self:RefreshDetail()
    self:RefreshBtn()
end

function M:RefreshDetail()
    self.Tips_Equipment:SetVisibility(ESlateVisibility.Visible)
    local Info = DataMgr.RobotEquip[self.CurEquip.Id]
    self.Tips_Equipment:Show(Info)
    -- self:SetRarity(Info.EquipRarity)
    -- self.Tips_Equipment.Text_ItemName:SetTexT(GText(Info.EquipName))
    -- self.Tips_Equipment.Text_Hold01:SetText(GText("UI_AutoChess_Holdings"))
    -- self.Tips_Equipment.Text_Hold02:SetText(1)
    -- self.Tips_Equipment.Text_CostDesc:SetText(GText("UI_AutoChess_WeaponCost"))
    -- self.Tips_Equipment.Text_Cost:SetText(Info.DeployCost)
    -- self.Tips_Equipment.Value_01:InitView(GText("UI_AutoChess_MonsterProp1"), Info.Atk)
    -- self.Tips_Equipment.Value_02:InitView(GText("UI_AutoChess_MonsterProp2"), Info.Hp)
    -- self.Tips_Equipment.Value_03:InitView(GText("UI_AutoChess_MonsterProp3"), Info.Def)
    -- self.Tips_Equipment.Value_04:InitView(GText("UI_AutoChess_MonsterProp4"), Info.Es)
    -- self.Tips_Equipment.List_Equipment:ClearListItems()
    -- local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    -- Obj.EffectText = Model:CalcEquipExtraDesc(self.CurEquip.Id)
    -- self.Tips_Equipment.List_Equipment:AddItem(Obj)
end


function M:InitTab()
    local Tabs = {}
    for i = 1, 3 do
        if i == 1 then
            local Tab = {
            Text = GText("UI_AutoChess_EquipRarity3"),
            Idx = 5
            } 
            table.insert(Tabs, Tab)          
        elseif i == 2 then
            local Tab = {
            Text = GText("UI_AutoChess_EquipRarity2"),
            Idx = 4
            }
            table.insert(Tabs, Tab)
        else
            local Tab = {
            Text = GText("UI_AutoChess_EquipRarity1"),
            Idx = 3
            }
            table.insert(Tabs, Tab)
        end
    end
    local ConfigData = {
        Owner = self,
        ChildWidgetName = "TabSubTextItem",
        Tabs = Tabs,
    }
    self.SubTab:Init(ConfigData)
    self.SubTab:BindEventOnTabSelected(self, self.OnTabSelected)
    self.SubTab:SelectTab(3)
    self.TabNum = #Tabs
end

function M:OnTabSelected()
    local NextTab = self.SubTab:GetCurrentTabIndex()
    local Res = 6 - NextTab
    self:RefreshEquip(Res)
end

function M:AddEquip()
    if not self.CurChess or not self.CurChess.Id then return end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local Equips = Model:GetMonsterEquipInfo(self.CurChess.Id)
    local cb = function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/equip_jewelry", nil, nil)
        --刷新棋子状态  --刷新装备状态
        for _, Content in pairs(self.List_Chess:GetListItems()) do
            if Content.Id == self.CurChess.Id and Content.UI then
                Content.UI:AddEquip(self.CurEquip.Id)
                break
            end
        end
        for _, Content in pairs(self.List_Item:GetListItems()) do
            if Content.Id == self.CurEquip.Id and Content.SelfWidget then
                Content.State = EquipState.Equiping
                Content.SelfWidget:SetItemSelect(true)
                break
            end
        end
        self:RefreshBtn()
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
    Avatar:AutoChessAddEquip(cb, self.CurChess.Id, self.CurEquip.Id, nil)
end


function M:RemoveEquip()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local Equips = Model:GetMonsterEquipInfo(self.CurChess.Id)
    local Index = 0
    for key, value in pairs(Equips) do
        if self.CurEquip.Id == value then
            Index = key
        end
    end
    local cb = function()
        --刷新棋子状态  --刷新装备状态
        local Equip = Model:GetMonsterEquipInfo(self.CurChess.Id)
        for _, Content in pairs(self.List_Chess:GetListItems()) do
            if Content.Id == self.CurChess.Id and Content.UI then
                Content.UI:RemoveEquip(#Equip, self.CurEquip.Id)
                break
            end
        end
        for _, Content in pairs(self.List_Item:GetListItems()) do
            if Content.Id == self.CurEquip.Id and Content.SelfWidget then
                Content.State = EquipState.UnEquip
                Content.SelfWidget:SetItemSelect(false)
                break
            end
        end
        self:RefreshBtn()
    end
    Avatar:AutoChessRemoveEquip(cb, self.CurChess.Id, Index)
end

function M:GetEquipState(EquipId, MonsterId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local Res = Avatar.AutoChess:IsEquipUnlocked(EquipId)
    if Res == false then
        return EquipState.UnLock
    end
    local Equips = Model:GetMonsterEquipInfo(MonsterId)
    if #Equips > 0 and CommonUtils.HasValue(Equips, EquipId) then
        return EquipState.Equiping
    else
        return EquipState.UnEquip
    end
end


function M:RefreshBtn()
    if not self.CurEquip then
        self.Switch_Button:SetActiveWidgetIndex(0)
        self.Btn_Equip:SetText(GText("UI_AutoChess_Equip"))
        self.Btn_Equip:ForbidBtn(true)
        return
    end
    local State = self:GetEquipState(self.CurEquip.Id, self.CurChess.Id)
    local Equips = Model:GetMonsterEquipInfo(self.CurChess.Id)
    if State == EquipState.Equiping then
        self.Switch_Button:SetActiveWidgetIndex(1)
        self.Btn_Takeoff:SetText(GText("UI_AutoChess_RemoveEquip"))
    elseif #Equips == 2 then
        self.Switch_Button:SetActiveWidgetIndex(2)
        self.Btn_Lock:SetText(GText("UI_AutoChess_FullEquip"))
    elseif State == EquipState.UnEquip then
        self.Switch_Button:SetActiveWidgetIndex(0)
        self.Btn_Equip:SetText(GText("UI_AutoChess_Equip"))
        self.Btn_Equip:ForbidBtn(false)
    end
end


function M:OnClickFull()
end

function M:OnClickReturn()
   self:BindToAnimationFinished(self.Out,
    {self, function()
        Model:DecreaseEquipReddotById()
        M.Super.Close(self)
    end})
    self:PlayAnimation(self.Out)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == "Gamepad_LeftTrigger" then
        self.SubTab:Handle_KeyEventOnGamePad(InKeyName)
        self.CurEquip = nil
        if self.List_Item:HasFocusedDescendants() or self.List_Item:HasAnyUserFocus() then
            self.List_Item:NavigateToIndex(0)
        end
        return UE4.UWidgetBlueprintLibrary.Handled()
    elseif InKeyName == "Gamepad_RightTrigger" then
        self.SubTab:Handle_KeyEventOnGamePad(InKeyName)
        self.CurEquip = nil
        if self.List_Item:HasFocusedDescendants() or self.List_Item:HasAnyUserFocus() then
            self.List_Item:NavigateToIndex(0)
        end
        return UE4.UWidgetBlueprintLibrary.Handled()
    elseif InKeyName == "A" then
        self.SubTab:Handle_KeyEventOnPC(InKeyName)
        self.CurEquip = nil
        self:RefreshBtn()
        self.Tips_Equipment:SetVisibility(ESlateVisibility.Collapsed)
    elseif InKeyName == "D" then
        self.SubTab:Handle_KeyEventOnPC(InKeyName)
        self.CurEquip = nil
        self:RefreshBtn()
        self.Tips_Equipment:SetVisibility(ESlateVisibility.Collapsed)
    elseif InKeyName == "Escape" then
        self:OnClickReturn()
    elseif InKeyName == "Gamepad_FaceButton_Right" then
        self:OnClickReturn()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end



-- function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
--     local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
--     local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
--     if InKeyName == "Gamepad_FaceButton_Bottom" then

--         return UE4.UWidgetBlueprintLibrary.Handled()
--     end
--     return UE4.UWidgetBlueprintLibrary.Unhandled()
-- end


function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if CommonUtils:IfExistSystemGuideUI(self) then
        return
    end
    self.List_Chess:SetFocus()
    return UIUtils.Handled
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    if (CurInputType == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 切换手柄端相关图标显隐
    local IsUseKeyAndMouse = CurInputType == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        self.UsingGamepad = false
    else
        self.UsingGamepad = true
        if self.CurEquip and self.CurEquip.ParentWidget then       
            return self.CurEquip.ParentWidget:SetFocus()
        else
            self.List_Chess:SetFocus()

        end
    end
end

function M:OnEndClose()
    AudioManager(self):SetEventSoundParam(self, "Open", {ToEnd = 1}) 
    if self.ParentWidget and not CommonUtils:IfExistSystemGuideUI(self) then
        self.ParentWidget:SetFocus()
    end
end



return M
