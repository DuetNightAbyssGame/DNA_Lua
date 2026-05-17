--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local WBP_ModArchive_Recommend_C = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.Common.DelayFrameComponent"})

function WBP_ModArchive_Recommend_C:Construct()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
end

function WBP_ModArchive_Recommend_C:OnSelected(Params)
    if Params then
        self.Owner = Params.Owner
    end
    self:SetFocus()
    self.HasSelected = true  -- 被选中过，从主界面重新聚焦后根据这个变量判断要不要刷新一下了列表
    self.Avatar = GWorld:GetAvatar()

    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()

    -- 下排按键刷新
    if (self.CurInputDeviceType == ECommonInputType.GamePad) then
        self.Owner:SwitchComKeyTipsState(3)
    else
        self.Owner:SwitchComKeyTipsState(1)
    end

    -- 搭配表
    self.Recommends = DataMgr.ModGuideBookBuild

    self:SetVisibility(ESlateVisibility.Visibility)

    self.Avatar = GWorld:GetAvatar()
    self:SortRecommends()
    self:CheckHasMod()

    self:InitTab()
    -- self:InitRecommends()
end

function WBP_ModArchive_Recommend_C:InitTab()
    local Tabs = {}
    for i, v in ipairs(DataMgr.ModGuideBookBuildTab) do
        local Tab = {
            Text = GText(v.Name),
            Idx = i
        }
        table.insert(Tabs, Tab)
    end
    local ConfigData = {
        Owner = self,
        ChildWidgetName = "TabSubTextItem",
        Tabs = Tabs,
        SoundFuncReceiver = self,
        SoundFunc = self.TabClickSoundFunc
    }
    self.RecommendTab:Init(ConfigData)
    self.RecommendTab:BindEventOnTabSelected(self, self.OnTabSelected)
    self.RecommendTab:SelectTab(1)
    self.TabNum = #Tabs
end

function WBP_ModArchive_Recommend_C:SortRecommends()
    self.Keys = {}
    for BuildId, _ in pairs(self.Recommends) do
        table.insert(self.Keys, BuildId)
    end
    -- 排序
    local function SortFunc(a, b)
        local RecommendInfoA = self.Recommends[a]
        local aInfo = {}
        aInfo.Id = RecommendInfoA.BuildId
        aInfo.HasThis = false
        if RecommendInfoA.TargetType and string.find(RecommendInfoA.TargetType, "Char") then
            local Info = DataMgr.Char[RecommendInfoA.TargetId]
            aInfo.Rarity = Info.CharRarity
            for _, Char in pairs(self.Avatar.Chars) do
                if Char.CharId == RecommendInfoA.TargetId then
                    aInfo.HasThis = true
                    break
                end
            end
        elseif RecommendInfoA.TargetType and string.find(RecommendInfoA.TargetType, "Weapon") then
            local Info = DataMgr.Weapon[RecommendInfoA.TargetId]
            aInfo.Rarity = Info.WeaponRarity
            for _, Weapon in pairs(self.Avatar.Weapons) do
                if Weapon.WeaponId == RecommendInfoA.TargetId then
                    aInfo.HasThis = true
                    break
                end
            end
        end

        local RecommendInfoB = self.Recommends[b]
        local bInfo = {}
        bInfo.Id = RecommendInfoB.BuildId
        bInfo.HasThis = false
        if RecommendInfoB.TargetType and string.find(RecommendInfoB.TargetType, "Char") then
            local Info = DataMgr.Char[RecommendInfoB.TargetId]
            bInfo.Rarity = Info.CharRarity
            for _, Char in pairs(self.Avatar.Chars) do
                if Char.CharId == RecommendInfoB.TargetId then
                    bInfo.HasThis = true
                    break
                end
            end
        elseif RecommendInfoB.TargetType and string.find(RecommendInfoB.TargetType, "Weapon") then
            local Info = DataMgr.Weapon[RecommendInfoB.TargetId]
            bInfo.Rarity = Info.WeaponRarity
            for _, Weapon in pairs(self.Avatar.Weapons) do
                if Weapon.WeaponId == RecommendInfoB.TargetId then
                    bInfo.HasThis = true
                    break
                end
            end
        end

        if aInfo.HasThis ~= bInfo.HasThis then
            return aInfo.HasThis
        end
        if aInfo.Rarity ~= bInfo.Rarity then
            return aInfo.Rarity > bInfo.Rarity
        end
        if aInfo.Id ~= bInfo.Id then
            return aInfo.Id < bInfo.Id
        end
    end

    table.sort(self.Keys, SortFunc)
end

function WBP_ModArchive_Recommend_C:OnTabSelected(Idx)
    self.FirstSelected = true
    local NextTab = self.RecommendTab:GetCurrentTabIndex()
    self.CurTab = NextTab
    self:InitRecommends()
end

function WBP_ModArchive_Recommend_C:InitRecommends()
    self.List_Recommend:ClearListItems()
    local Index = 0
    for k, v in ipairs(self.Keys) do
        local RecommendInfo = self.Recommends[v]
        if RecommendInfo.TabId == self.CurTab then

            local HasThis = false
            if RecommendInfo.TargetType and string.find(RecommendInfo.TargetType, "Char") then
                for _, Char in pairs(self.Avatar.Chars) do
                    if Char.CharId == RecommendInfo.TargetId then
                        HasThis = true
                        break
                    end
                end
            elseif RecommendInfo.TargetType and string.find(RecommendInfo.TargetType, "Weapon") then
                for _, Weapon in pairs(self.Avatar.Weapons) do
                    if Weapon.WeaponId == RecommendInfo.TargetId then
                        HasThis = true
                        break
                    end
                end
            end
            if HasThis then
                Index = Index + 1
                local Content =  NewObject(UIUtils.GetCommonItemContentClass())
                --Content.ClickCallback = self.ClickSelectSquadItem
                Content.Owner = self
                Content.Index = Index
                Content.TargetType = RecommendInfo.TargetType
                Content.TargetId = RecommendInfo.TargetId
                Content.ModList = RecommendInfo.ModList
                Content.DesList = RecommendInfo.DesList
                Content.InterfaceJumpId = RecommendInfo.InterfaceJumpId
                self.List_Recommend:AddItem(Content)
            end
        end
    end

    self.Widgets = {}
    self.List_Recommend:NavigateToIndex(0)
    -- 手柄相关
    if (self.CurInputDeviceType == ECommonInputType.Gamepad)  then
        self:AddDelayFrameFunc(function()
            if self.Widgets and self.Widgets[1] then
                self.Widgets[1]:SetFocus()
                self.CurWidget = self.Widgets[1]
                self.List_Recommend:SetSelectedIndex(0)
                self.CurWidget:SetGamepadBtnState(true)
            end
        end, 5, "SelectFirstTab")
    end
end

-- 存ListView里的Item
function WBP_ModArchive_Recommend_C:UpdateListWidgets(Widget)
    self.Widgets[Widget.Info.Index] = Widget
end

-- 记录表中所有的Mod拥有状态
function WBP_ModArchive_Recommend_C:CheckHasMod()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    self.ModStates = {}  -- ModId对应是否拥有
    for i, v in pairs(self.Recommends) do
        local ModList = v.ModList
        for k = 1, #ModList do
            self.ModStates[ModList[k]] = false
        end
        -- for k = 1, #ModList do
        --     if Avatar.HoldMods[ModList[k]] then
        --         self.ModStates[ModList[k]] = true
        --     else
        --         self.ModStates[ModList[k]] = false
        --     end
        -- end
    end
    for _, Mod in pairs(Avatar.Mods) do
        if self.ModStates[Mod.ModId] == false then
            self.ModStates[Mod.ModId] = true
        end
    end


end

function WBP_ModArchive_Recommend_C:RefreshInfo()
    self:SetFocus()
    self:InitRecommends()
end

-- function WBP_ModArchive_Recommend_C:OnFocusReceived(MyGeometry, InFocusEvent)
--     DebugPrint("zwkkk 333333")
--     -- 刷新一下
--     if self.ShouldFocusEvent then
        
--     end
-- end

-- 蓝图里的函数
function WBP_ModArchive_Recommend_C:OnSelectionChanged(Item, IsSelected)
    if Item and Item.SelfWidget and self.CurWidget and Item.SelfWidget ~= self.CurWidget then
        DebugPrint("zwjkjkjk OnSelectionChanged", Item.SelfWidget:GetName())
        self.CurWidget:OnDeSelected()
        self.CurWidget = Item.SelfWidget
        -- self.CurWidget:SetGamepadBtnState(true)
    end
end

function WBP_ModArchive_Recommend_C:TabClickSoundFunc()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_03", nil, nil)
end



-- 监听PC/手柄按键
function WBP_ModArchive_Recommend_C:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        DebugPrint("zwk    Key_IsGamepadKey", InKeyName)
        IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
    else
        DebugPrint("zwk    Key_IsPC", InKeyName)
        IsEventHandled = self:Handle_OnPCDown(InKeyName) 
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

-- PC按键按下
function WBP_ModArchive_Recommend_C:Handle_OnPCDown(InKeyName)
    if (InKeyName == "A") then
        self.RecommendTab:TabToLeft()
        return true
    elseif (InKeyName == "D") then
        self.RecommendTab:TabToRight()
        return true
    end
    return false
end

-- 手柄按键按下
function WBP_ModArchive_Recommend_C:Handle_OnGamePadDown(InKeyName)
    DebugPrint("zwkkk  Handle_OnGamePadDown", InKeyName, self:GetName())
    if (InKeyName == "Gamepad_DPad_Up" or InKeyName == "Gamepad_LeftStick_Up") then

        return true
    -- elseif (InKeyName == "Gamepad_FaceButton_Right") then -- 返回
    --     -- 退出
    --     self.Owner:OnClose()
    --     return true
    -- elseif (InKeyName == "Gamepad_FaceButton_Bottom") then  -- 确定
    --     -- DebugPrint("zwkkk A键按下", self.CurWidget)
    --     -- if self.CurWidget then
    --     --     self.CurWidget:OnSelected()
    --     -- end
    --     return true
    elseif (InKeyName == "Gamepad_RightThumbstick") then  -- 右摇杆按下
        
        return true
    elseif (InKeyName == "Gamepad_FaceButton_Left") then -- X键 进入装配
        -- local SelectItem = self.List_Recommend:BP_GetSelectedItem()
        -- if SelectItem and SelectItem.SelfWidget then
        --     DebugPrint("zwjkjkjk SelectItem.SelfWidget:GetName()")
        --     SelectItem.SelfWidget:OnClickJumpTo()
        -- end
        -- DebugPrint("zwkkk X键按下", self.CurWidget)
        -- if self.CurWidget then
        --     self.CurWidget:OnClickJumpTo()
        -- end
        return true
    elseif (InKeyName == "Gamepad_LeftTrigger") then -- 左切页
        self.RecommendTab:TabToLeft()
        return true
    elseif (InKeyName == "Gamepad_RightTrigger") then -- 右切页
        self.RecommendTab:TabToRight()
        return true
    end
    return false
end

-- Item返回选择
function WBP_ModArchive_Recommend_C:OnGamepadReturnKeyDown(Index)
    DebugPrint("123123321 OnGamepadReturnKeyDown")
    if not self.SelectingModItem then
        self.Owner:OnClose()
    end
    self.List_Recommend:SetFocus()
    self.List_Recommend:SetSelectedIndex(Index - 1)
    if self.Owner then
        self.Owner:HideTabKey(false)
        self.Owner:SwitchComKeyTipsState(3)
    end
    local Item = self.List_Recommend:BP_GetSelectedItem()
    if Item and Item.SelfWidget then
        Item.SelfWidget:SetGamepadBtnState(true)
        Item.SelfWidget:SetFocus()
    end
    -- if self.CurWidget then
    --     self.CurWidget:OnSelected()
    -- end
    self.SelectingModItem = false
end

-- Item进入选择
function WBP_ModArchive_Recommend_C:OnGamepadEnterKeyDown()
    DebugPrint("123123321 OnGamepadEnterKeyDown")
    if self.Owner then
        self.Owner:HideTabKey(true)
        self.Owner:SwitchComKeyTipsState(2)
    end
    local Item = self.List_Recommend:BP_GetSelectedItem()
    if Item and Item.SelfWidget then
        -- Item.SelfWidget:SetGamepadBtnState(false)
    end
    -- if self.CurWidget then
    --     self.CurWidget:OnSelected()
    -- end
    self.SelectingModItem = true
end

-- Tips打开
function WBP_ModArchive_Recommend_C:OnMenuOpenChanged(bIsOpen)
    if not self.Owner then return end
    if self.CurInputDeviceType ~= ECommonInputType.GamePad then return end
    self.Owner:OnTipsOpenChanged(bIsOpen)
    if not bIsOpen then
        self.Owner:HideTabKey(true)
        self.Owner:SwitchComKeyTipsState(2)
    end

    if bIsOpen then
        self.RecommendTab.Key_Left:SetVisibility(ESlateVisibility.Hidden)
        self.RecommendTab.Key_Right:SetVisibility(ESlateVisibility.Hidden)
    else
        self.RecommendTab.Key_Left:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.RecommendTab.Key_Right:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

function WBP_ModArchive_Recommend_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    DebugPrint("zwkkk   RefreshOpInfoByInputDevice ", CurInputDevice, CurGamepadName, self:GetName())
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName
end




return WBP_ModArchive_Recommend_C
