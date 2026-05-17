require "UnLua"

local ModModel = ModController:GetModel()

---@type WBP_Armory_ModRecommend_C
local WBP_Armory_ModRecommend_C = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
function WBP_Armory_ModRecommend_C:Initialize(Initializer)

end

function WBP_Armory_ModRecommend_C:Construct()
    self:BindInputMethodChangedDelegate()

    local Anchors = FAnchors()
    Anchors.Minimum = FVector2D(0.0, 0)
    Anchors.Maximum = FVector2D(1, 1)
    self.Slot:SetAnchors(Anchors)

    local Offsets = self.Slot:GetOffsets()
    Offsets.Top = 0
    Offsets.Bottom = 0
    Offsets.Left = 0
    Offsets.Right = 0
    self.Slot:SetOffsets(Offsets)

    self.Text_ModRecommend:SetText(GText("UI_ModRecommandData"))

    self.Btn_Close:Init("Close", self, self.Hide)

    self.Key_Gamepad:CreateGamepadKey(UIConst.GamePadImgKey.LeftThumb)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self.Key_Gamepad:SetVisibility(UIConst.VisibilityOp.Visible)
    else
        self.Key_Gamepad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    
    self.List_Item:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    
    self.Btn_Delete:BindEventOnReleased(self, self.OnClearFliterClicked)

    self.CheckBox_Owned:BindEventOnClicked({
        Inst = self,
        Func = self.ShowOwnedChange
    })
    -- self.CheckBox_Owned:InitGamepadKey("LS")

    self.Text_Owned:SetText(GText("UI_OnlyShowMod_Get"))

    self.Btn_Delete:SetNavigationRuleExplicit(EUINavigation.Right, self.CheckBox_Owned)
    self.CheckBox_Owned:SetNavigationRuleExplicit(EUINavigation.Left, self.Btn_Delete)
    self.List_Item.BP_OnEntryGenerated:Add(self, function(self, Widget)
        if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
            if Widget.Content.Index == 1 then
                Widget:SetFocus()
            end
        end

    end)
end

function WBP_Armory_ModRecommend_C:SetData(Params)
    self.Params = Params

    local Target = ModModel:GetTarget()
    local TargetType = Target:GetTypeName()
    local Image
    if TargetType == "Weapon" or TargetType == "UWeapon" then
        local CharIconPath = DataMgr[TargetType][Target.WeaponId].BigIcon
        Image = LoadObject(CharIconPath)
    elseif TargetType == "Char" then
        local CharIconPath = DataMgr.Char[self.Params.CharId].EscMenuBg
        Image = LoadObject(CharIconPath)
    end

    if Image then
        local DynamicMaterial = self.Img_Avatar:GetDynamicMaterial()
        DynamicMaterial:SetTextureParameterValue("MainTex", Image)
    end

    -- self.Img_Avatar:SetBrush :SetBrushResourceObject(LoadObject("/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SpSideMission_Un.T_Gp_SpSideMission_Un"))
    self.Text_Avatar:SetText(Params.TargetName)

    --local Target = ModModel:GetTarget()
    --if self.CurTargetUuid == Target.Uuid then
    --     self:RefreshData()
    -- else
        self:InitRankModData(Params.RankModData, Params.UserCount)
    --end
    self:SetUpRecommendModList()

    self:UpdateDeleteBtnState()

    self:PlayAnimation(self.In)
end

-- function WBP_Armory_ModRecommend_C:RefreshData()
--     for _, RecommendModInfoList in pairs({self.OwnedRecommendModInfoList, self.RecommendModInfoList}) do
--         for _, RecommendModInfo in pairs(RecommendModInfoList) do
--             RecommendModInfo.IsEquipped = false
--             -- 同一ModId：未养成Mod和多个已养成Mod
--             for _, Mod in pairs(ModModel:GetAvatar().Mods) do
--                 if Mod.ModId == RecommendModInfo.ModId then
--                     RecommendModInfo.IsEquipped = RecommendModInfo.IsEquipped and RecommendModInfo.IsEquipped or
--                                                       ModModel:IsModIdEquiped(RecommendModInfo.ModId)
--                 end
--             end
--         end
--     end
-- end

function WBP_Armory_ModRecommend_C:UpdateEmptyTip()
    local ShowList = self.CheckBox_Owned.Checked and self.OwnedRecommendModInfoList or self.RecommendModInfoList
    
    if #ShowList > 0 then
        self.WS_State:SetActiveWidgetIndex(0)
    else
        self.WS_State:SetActiveWidgetIndex(1)
        self.Com_Empty.Text_Empty:SetText(GText("UI_ModRecommandData_NoData"))
    end
end

function WBP_Armory_ModRecommend_C:SetUpRecommendModList()
    self.List_Item:ScrollToTop()
    self.List_Item:ClearListItems()

    local ShowList = self.CheckBox_Owned.Checked and self.OwnedRecommendModInfoList or self.RecommendModInfoList
    for Index, ModInfo in ipairs(ShowList) do
        self:AddModContentToList(Index, ModInfo)
    end

    self.List_Item:RequestFillEmptyContent()

    self:UpdateEmptyTip()
end

function WBP_Armory_ModRecommend_C:AddModContentToList(Index, ModInfo)
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Index = Index
    Content.ModId = ModInfo.ModId
    Content.Rate = ModInfo.Rate
    Content.Owned = ModInfo.Owned
    Content.IsEquipped = ModInfo.IsEquipped
    Content.IsShowDetails = true
    Content.IsShowTips = true
    Content.IsSelfDeadWithUpEvent = true
    Content.SelectChangeCallbackInfo = {
        Obj = self,
        Func = self.OnRecommendModSelectChange
    }
    Content.IsSelect = ModInfo.IsSelect
    self.List_Item:AddItem(Content)
end

-- function WBP_Armory_ModRecommend_C:Tick(MyGeometry, InDeltaTime)
-- end

function WBP_Armory_ModRecommend_C:ClearFliter()
    for _, Info in pairs(self.RecommendModInfoList) do
        Info.IsSelect = false
    end
    for _, Info in pairs(self.OwnedRecommendModInfoList) do
        Info.IsSelect = false
    end

    self.CheckBox_Owned:SetIsChecked(false, false)

    ModModel:SetRecommendModIdList({})
end

function WBP_Armory_ModRecommend_C:OnClearFliterClicked()
    self:ClearFliter()
    self:SetUpRecommendModList()
    self:UpdateDeleteBtnState()

    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        local ShowList = self:GetShowList()
        if #ShowList == 0 then
            self:SetRecommendFocus()
        end
    end

    local Callback = self.Params.FliterCallbackInfo
    Callback.Func(Callback.Obj)
end

function WBP_Armory_ModRecommend_C:OnRecommendModSelectChange(IsSelect, ModId)
    for _, Info in pairs(self.RecommendModInfoList) do
        if Info.ModId == ModId then
            Info.IsSelect = IsSelect
        end
    end
    for _, Info in pairs(self.OwnedRecommendModInfoList) do
        if Info.ModId == ModId then
            Info.IsSelect = IsSelect
        end
    end

    local ModInfoList = self:GetShowList()

    local CurRecommendModIdList = {}
    -- 更新数据
    -- 从左往右推荐率递减
    for _, ModInfo in pairs(ModInfoList) do
        if ModInfo.IsSelect then
            table.insert(CurRecommendModIdList, ModInfo.ModId)
        end
    end
    ModModel:SetRecommendModIdList(CurRecommendModIdList)

    self:UpdateDeleteBtnState()

    local Callback = self.Params.FliterCallbackInfo
    Callback.Func(Callback.Obj)
end

function WBP_Armory_ModRecommend_C:ShowOwnedChange(Checked, ModId)
    self:SetUpRecommendModList()
    local ShowList = self:GetShowList()

    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        if #ShowList == 0 then
            self:SetRecommendFocus()
        end
    end
end

function WBP_Armory_ModRecommend_C:UpdateDeleteBtnState()
    if ModModel:IsRecommendModState() then
        self.Panel_Delete:SetVisibility(UIConst.VisibilityOp.Visible)
        -- self.Key_Gamepad:SetVisibility(UIConst.VisibilityOp.Visible)
    else
        self.Panel_Delete:SetVisibility(UIConst.VisibilityOp.Collapsed)
        -- self.Key_Gamepad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function WBP_Armory_ModRecommend_C:OnKeyDown(MyGeometry, InKeyEvent)
    if self:GetVisibility() == UIConst.VisibilityOp.Collapsed then
        return UIUtils.UnHandled
    end

    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if InKeyName == UIConst.GamePadKey.LeftThumb then

    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
        self:Hide()
        return UIUtils.Handled
    elseif (InKeyName == "Escape") then
        self:Hide()
        return UIUtils.Handled
    end

    return UIUtils.Handled
end

function WBP_Armory_ModRecommend_C:OnKeyUp(MyGeometry, InKeyEvent)
    if self:GetVisibility() == UIConst.VisibilityOp.Collapsed then
        return UIUtils.UnHandled
    end

    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if InKeyName == UIConst.GamePadKey.LeftThumb then
        if self.Panel_Delete:GetVisibility() == UIConst.VisibilityOp.Visible then
            self.Btn_Delete:SetFocus()
        else
            self.CheckBox_Owned:SetFocus()
        end
        return UIUtils.Handled
    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
        if self.Btn_Delete:HasFocusedDescendants() or self.CheckBox_Owned:HasFocusedDescendants() then
            self:SetRecommendFocus()
        elseif not self.List_Item:HasFocusedDescendants() then
            self:Hide()
        end
        return UIUtils.Handled
    elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then

    end
    return UIUtils.Handled
end

-- 绑定输入设备切换的委托
function WBP_Armory_ModRecommend_C:BindInputMethodChangedDelegate()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(GameInputModeSubsystem)) then
        GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChanged)
    end
end

function WBP_Armory_ModRecommend_C:UnBindInputMethodChangedDelegate()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(GameInputModeSubsystem)) then
        GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChanged)
    end
end

-- 输入设备切换触发的委托
function WBP_Armory_ModRecommend_C:OnInputMethodChanged(NewGameInputType, NewGamepadName)
    if NewGameInputType == ECommonInputType.Gamepad then
        self.Key_Gamepad:SetVisibility(UIConst.VisibilityOp.Visible)
    else
        self.Key_Gamepad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function WBP_Armory_ModRecommend_C:Destruct()
    self.CurTargetUuid = nil
    self:UnBindInputMethodChangedDelegate()
end

function WBP_Armory_ModRecommend_C:Hide()
    self:BindToAnimationFinished(self.Out, {self, function()
        self:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end})

    self:PlayAnimation(self.Out)
    ModModel:SetRecommendView(false)

    self.Params.HideCallbackInfo.Func(self.Params.HideCallbackInfo.Obj)
end

-- function WBP_Armory_ModRecommend_C:GetModRankData()
--     local Target = ModModel:GetTarget()
--     local TargetType = Target:GetTypeName()
--     local TargetId
--     if TargetType == "Weapon" then
--         TargetId = Target.WeaponId
--     elseif TargetType == "Char" then
--         TargetId = Target.CharId
--     end

--     local Avatar = GWorld:GetAvatar()
--     Avatar:GetModRankData(TargetType, TargetId, {
--         Func = self.InitRankModData,
--         Obj = self
--     })
-- end

function WBP_Armory_ModRecommend_C:InitRankModData(Data, UserCount)
    local Target = ModModel:GetTarget()
    self.CurTargetUuid = Target.Uuid
    local TargetType = Target:GetTypeName()

    local ModInfoList = {}
    if UserCount < 1000 and ModController.GM_RecommendLimit then
        self:InitRecommendModInfoList(ModInfoList)
    else
        local Amount = 0
        for _, Count in pairs(Data) do
            Amount = Amount + Count
        end
        for ModId, Count in pairs(Data) do
            table.insert(ModInfoList, {
                ModId = ModId,
                Rate = Count / Amount
            })
        end

        -- 服务器下发的数据已经按推荐率自上而下排序
        table.sort(ModInfoList, function(a, b)
            return a.Rate > b.Rate
        end)

        self:InitRecommendModInfoList(ModInfoList)
    end
end

function WBP_Armory_ModRecommend_C:InitRecommendModInfoList(ModInfoList)
    self.RecommendModInfoList = {}
    self.OwnedRecommendModInfoList = {}
    for _, ModInfo in pairs(ModInfoList) do
        local CurModInfo = {
            ModId = ModInfo.ModId,
            Rate = ModInfo.Rate,
            Owned = false,
            IsEquipped = false,
            IsSelect = false
        }

        -- 同一ModId：未养成Mod和多个已养成Mod
        for _, Mod in pairs(ModModel:GetAvatar().Mods) do
            if Mod.ModId == CurModInfo.ModId then
                CurModInfo.Owned = true
                CurModInfo.IsEquipped = CurModInfo.IsEquipped and CurModInfo.IsEquipped or ModModel:IsModIdEquiped(CurModInfo.ModId)

                local IsContain = false
                for _, OwnedRecommendModInfo in pairs(self.OwnedRecommendModInfoList) do
                    if OwnedRecommendModInfo.ModId == CurModInfo.ModId then
                        IsContain = true
                        break
                    end
                end
                if not IsContain then
                    table.insert(self.OwnedRecommendModInfoList, CurModInfo)
                end
            end
        end

        table.insert(self.RecommendModInfoList, CurModInfo)
    end
end

function WBP_Armory_ModRecommend_C:GetShowList()
    local ShowList = self.CheckBox_Owned.Checked and self.OwnedRecommendModInfoList or self.RecommendModInfoList
    return ShowList
end

function WBP_Armory_ModRecommend_C:SetRecommendFocus()
    if #self.RecommendModInfoList > 0 then
        self.List_Item:SetFocus()
    else
        self.CheckBox_Owned:SetFocus()
    end
end

return WBP_Armory_ModRecommend_C
