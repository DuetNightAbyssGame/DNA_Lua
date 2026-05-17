--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local PageJumpFunctionLibrary = require "Utils.PageJumpFunctionConfig"

local WBP_ModArchive_Recommend_Item_C = Class({"BluePrints.UI.BP_UIState_C", "BluePrints.Common.DelayFrameComponent"})

function WBP_ModArchive_Recommend_Item_C:Construct()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
end

function WBP_ModArchive_Recommend_Item_C:OnListItemObjectSet(ListItemObject)
    ListItemObject.SelfWidget = self
    self.Info = ListItemObject
    self.Owner = self.Info.Owner
    self:PlayAnimation(self.In)
    self.Btn_Build:SetText(GText("UI_GameEvent_EventPortal_Goto"))

    self.Avatar = GWorld:GetAvatar()
    -- self.HasThis = false
    -- if self.Info.TargetType == "Char" then
    --     local Info = DataMgr.Char[self.Info.TargetId]
    --     for _, Char in pairs(self.Avatar.Chars) do
    --         if Char.CharId == self.Info.TargetId then
    --             self.HasThis = true
    --             break
    --         end
    --     end
    -- elseif self.Info.TargetType == "Weapon" then
    --     local Info = DataMgr.Weapon[self.Info.TargetId]
    --     for _, Weapon in pairs(self.Avatar.Weapons) do
    --         if Weapon.WeaponId == self.Info.TargetId then
    --             self.HasThis = true
    --             break
    --         end
    --     end
    -- end

    -- if self.HasThis then
    --     self.Btn_Build:ForbidBtn(false)
    --     self.Btn_Build:BindEventOnClicked(self, self.OnClickJumpTo)
    -- else
    --     self.Btn_Build:ForbidBtn(true)
    --     self.Btn_Build:BindForbidStateExecuteEvent(self, self.OnClickForbidden)
    -- end

    self.Btn_Build:ForbidBtn(false)
    self.Btn_Build:UnBindEventOnClicked(self, self.OnClickJumpTo)
    self.Btn_Build:BindEventOnClicked(self, self.OnClickJumpTo)

    self.Owner:UpdateListWidgets(self)

    self:RefreshList()
    self.List_RecommendMod:DisableScroll(true)
end

function WBP_ModArchive_Recommend_Item_C:RefreshList()
    self:InitGroupInfo()
    self:InitListMod()
end

-- 设置目标名称、图标
function WBP_ModArchive_Recommend_Item_C:InitGroupInfo()
    self.TargetInfo = {}
    if self.Info.TargetType and string.find(self.Info.TargetType, "Char") then
        self.Image_Head:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Image_Weapon:SetVisibility(ESlateVisibility.Collapsed)
        self.TargetInfo = DataMgr.Char[self.Info.TargetId]
        local Path = self.TargetInfo.EscMenuBg
        local IconDynaMaterial = self.Image_Head:GetDynamicMaterial()
        if IconDynaMaterial then
            IconDynaMaterial:SetTextureParameterValue("IconMap", LoadObject(Path))
        end
        self.Text_Title:SetText(GText(self.TargetInfo.CharName))
    elseif self.Info.TargetType and string.find(self.Info.TargetType, "Weapon") then
        self.Image_Head:SetVisibility(ESlateVisibility.Collapsed)
        self.Image_Weapon:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.TargetInfo = DataMgr.Weapon[self.Info.TargetId]
        local Type = self.TargetInfo.GUIPathVariableType
        local Name = self.TargetInfo.GUIPathVariableName
        local Path = "/Game/UI/Texture/Dynamic/Image/Menu/Weapon/T_Menu_" .. Type .. "_" .. Name
        local IconDynaMaterial = self.Image_Weapon:GetDynamicMaterial()
        if IconDynaMaterial then
            local Texture = LoadObject(Path)
            if Texture then
                IconDynaMaterial:SetTextureParameterValue("IconMap", Texture)
            end
        end
        self.Text_Title:SetText(GText(self.TargetInfo.WeaponName))
    end
end

-- 添加ModItem
function WBP_ModArchive_Recommend_Item_C:InitListMod()
    self.Mods = {}
    self.List_RecommendMod:ClearListItems()
    for i = 1, #self.Info.ModList do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Owner = self
        Content.Index = i
        Content.ItemType = "Mod"
        Content.ModId = self.Info.ModList[i]
        if self.Info.DesList and self.Info.DesList[i] then
            Content.Des = self.Info.DesList[i]
        end
        Content.HasMod = self.Info.Owner.ModStates[self.Info.ModList[i]]
        self.List_RecommendMod:AddItem(Content)
    end


    -- 先关掉按钮手柄图标的显示
    self.Btn_Build:SetGamePadImg("X")
    self.Btn_Build:SetGamePadVisibility(ESlateVisibility.Collapsed)
end

-- 点击跳转
function WBP_ModArchive_Recommend_Item_C:OnClickJumpTo()
    DebugPrint("zwkk 跳转？ ", self.Info.InterfaceJumpId)
    if self.Info.InterfaceJumpId and self.Info.InterfaceJumpId > 0 then
        -- 填了跳转ID，按ID跳转
        PageJumpUtils:JumpToTargetPageByJumpId(self.Info.InterfaceJumpId)
    else
        -- 根据TargetType和TargetId进行自定义跳转
        PageJumpFunctionLibrary.JumpToArmory(self.Info.TargetType, "Mod", self.Info.TargetId)
    end
end

-- 未持有状态下点击跳转
function WBP_ModArchive_Recommend_Item_C:OnClickForbidden()
    if self.Info.TargetType and string.find(self.Info.TargetType, "Char") then
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("没有当前角色111"))
    elseif self.Info.TargetType and string.find(self.Info.TargetType, "Weapon") then
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("没有当前武器111"))
    end
end




function WBP_ModArchive_Recommend_Item_C:OnFocusReceived(MyGeometry, InFocusEvent)
    if (self.CurInputDeviceType == ECommonInputType.Gamepad)  then
        DebugPrint("11122233 OnFocusReceived",self:GetName())
        self.Image_Select:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Image_Head:SetRenderOpacity(1.0)
        self.Image_Weapon:SetRenderOpacity(1.0)
        self.Btn_Build:SetGamePadVisibility(ESlateVisibility.SelfHitTestInvisible)

        self:AddDelayFrameFunc(function()
            if self.Owner.SelectingModItem then
                self.List_RecommendMod:SetFocus()
                -- self.List_RecommendMod:NavigateToIndex(0)
                self.List_RecommendMod:SetSelectedIndex(0)
                self.Owner:OnGamepadEnterKeyDown()
            else
                self.Owner.Owner:HideTabKey(false)
            end
        end, 1, "CheckShouldEnterMod")
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function WBP_ModArchive_Recommend_Item_C:OnFocusLost(InFocusEvent)
    if not self:HasFocusedDescendants() then
        DebugPrint("11122233 OnFocusLost",self:GetName())
        if self.Image_Select then
            self.Image_Select:SetVisibility(ESlateVisibility.Collapsed)
        end
        self.Image_Head:SetRenderOpacity(0.8)
        self.Image_Weapon:SetRenderOpacity(0.8)
        self.Btn_Build:SetGamePadVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_ModArchive_Recommend_Item_C:SetGamepadBtnState(Show)
    if Show then
        self.Btn_Build:SetGamePadVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Btn_Build:SetGamePadVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_ModArchive_Recommend_Item_C:OnSelected()
    if (self.CurInputDeviceType == ECommonInputType.Gamepad)  then
        DebugPrint("11122233 Item选中",self:GetName())
        self.Image_Select:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Image_Head:SetRenderOpacity(1.0)
        self.Image_Weapon:SetRenderOpacity(1.0)
        self.Btn_Build:SetGamePadVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.List_RecommendMod:SetFocus()
        self.List_RecommendMod:SetSelectedIndex(0)
        self.InSelect = true
    end
end

function WBP_ModArchive_Recommend_Item_C:OnDeSelected()
    if (self.CurInputDeviceType == ECommonInputType.Gamepad) then
        -- self:AddDelayFrameFunc(function()

        -- end, 2, "OnDeSelected")
        DebugPrint("11122233 OnDeSelected",self:GetName())
        self.Image_Select:SetVisibility(ESlateVisibility.Collapsed)
        self.Image_Head:SetRenderOpacity(0.8)
        self.Image_Weapon:SetRenderOpacity(0.8)
        self.Btn_Build:SetGamePadVisibility(ESlateVisibility.Collapsed)
        self.InSelect = false
    end
end

function WBP_ModArchive_Recommend_Item_C:OnRemovedFromFocusPath(InFocusEvent)
    if self.CurInputDeviceType ~= ECommonInputType.Gamepad then return end
    if self.Owner.SelectingModItem then
        self.Image_Select:SetVisibility(ESlateVisibility.Collapsed)
        self.Image_Head:SetRenderOpacity(0.8)
        self.Image_Weapon:SetRenderOpacity(0.8)
        self.Btn_Build:SetGamePadVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_ModArchive_Recommend_Item_C:OnMenuOpenChanged(bIsOpen)
    self.HasTipsOpen = bIsOpen
    DebugPrint("zwjki ", self.Owner:GetName())
    self.Owner:OnMenuOpenChanged(bIsOpen)
    if self.CurInputDeviceType ~= ECommonInputType.Gamepad then return end
    if not self.Owner or not self.Owner.CurWidget or self.Owner.CurWidget ~= self then return end
    if bIsOpen then
        self.Btn_Build:SetGamePadVisibility(ESlateVisibility.Collapsed)
    else
        self.Btn_Build:SetGamePadVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end


-- 监听PC/手柄按键
function WBP_ModArchive_Recommend_Item_C:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        DebugPrint("zwk    Key_IsGamepadKey", InKeyName)
        IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
    else
        DebugPrint("zwk    Key_IsPC", InKeyName)
        -- IsEventHandled = self:Handle_OnPCDown(InKeyName) 
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

-- PC按键按下
function WBP_ModArchive_Recommend_Item_C:Handle_OnPCDown(InKeyName)
    -- if (InKeyName == "A") then
    --     return true
    -- elseif (InKeyName == "D") then
    --     return true
    -- elseif (InKeyName == "Q") then
    --     self.Owner.ModArchive_Tab:TabToRight()
    --     return true
    -- elseif (InKeyName == "E") then
    --     self.Owner.ModArchive_Tab:TabToRight()
    --     return true
    -- end
    -- return false
end

-- 手柄按键按下
function WBP_ModArchive_Recommend_Item_C:Handle_OnGamePadDown(InKeyName)
    DebugPrint("zwkkk  Handle_OnGamePadDown", InKeyName, self:GetName())
    if (InKeyName == "Gamepad_DPad_Up" or InKeyName == "Gamepad_LeftStick_Up") then

        return true
    elseif (InKeyName == "Gamepad_FaceButton_Right") then -- 返回
    
        if self.Owner and self.Info and not self.HasTipsOpen then
            self.Owner:OnGamepadReturnKeyDown(self.Info.Index)
        end
        return true
    -- elseif (InKeyName == "Gamepad_FaceButton_Bottom") then  -- 确定
    --     self:OnSelected()
    --     return true
    elseif (InKeyName == "Gamepad_FaceButton_Left") then -- X键
        if not self.XInPress then
            self.XInPress = true
            self.Btn_Build:PlayAnimation(self.Btn_Build.Press)
        end
        return true
    end
    return false
end


-- 监听松开按键
function WBP_ModArchive_Recommend_Item_C:OnKeyUp(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        -- DebugPrint("zwkkk    Key_IsGamepadKey", InKeyName)
        IsEventHandled = self:Handle_OnGamePadUp(InKeyName)
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

-- 手柄按键松开
function WBP_ModArchive_Recommend_Item_C:Handle_OnGamePadUp(InKeyName)
    DebugPrint("zwkkk  Handle_OnGamePadUp", InKeyName, self:GetName())
    if (InKeyName == "Gamepad_FaceButton_Bottom") then  -- 确定
        self:OnSelected()
        self.Owner:OnGamepadEnterKeyDown()
        return true
    elseif (InKeyName == "Gamepad_FaceButton_Left") then -- X键
        if self.XInPress then
            self.XInPress = false
            self.Btn_Build:StopAllAnimations()
            self.Btn_Build:PlayAnimation(self.Btn_Build.Normal)
            self:OnClickJumpTo()
        end
        return true
    end
    return false
end

function WBP_ModArchive_Recommend_Item_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    DebugPrint("zwkkk   RefreshOpInfoByInputDevice ", CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName

    self:UpdateOnInputDeviceTypeChange()
end

function WBP_ModArchive_Recommend_Item_C:UpdateOnInputDeviceTypeChange()
    DebugPrint("zwzwzwk ",self.CurInputDeviceType)
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        if self:HasAnyUserFocus() then
            self.Image_Select:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Image_Head:SetRenderOpacity(1.0)
            self.Image_Weapon:SetRenderOpacity(1.0)
            self.Btn_Build:SetGamePadVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.List_RecommendMod:SetFocus()
            self.List_RecommendMod:SetSelectedIndex(0)
        else
            self:AddDelayFrameFunc(function()
                self.Image_Select:SetVisibility(ESlateVisibility.Collapsed)
                self.Image_Head:SetRenderOpacity(0.8)
                self.Image_Weapon:SetRenderOpacity(0.8)
                self.Btn_Build:SetGamePadVisibility(ESlateVisibility.Collapsed)
            end, 1, "CollapseBtn")
        end
    elseif self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard then
        -- PC
        DebugPrint("zwzwzwk ")
        if self.Image_Select then
            self.Image_Select:SetVisibility(ESlateVisibility.Collapsed)
        end
        self.Image_Head:SetRenderOpacity(0.8)
        self.Image_Weapon:SetRenderOpacity(0.8)
        self.Btn_Build:SetGamePadVisibility(ESlateVisibility.Collapsed)
    end

end

return WBP_ModArchive_Recommend_Item_C
