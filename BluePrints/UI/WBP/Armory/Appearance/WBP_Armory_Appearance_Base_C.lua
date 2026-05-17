require "UnLua"
local UIUtils = require "Utils.UIUtils"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"

---@type WBP_Armory_Appearance_Base_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C",})
M._components = {"BluePrints.UI.BP_EMUserWidgetUtils_C",}

function M:Init(Params)
    self.Parent = Params.Parent
    self.ActorController = self.Parent.ActorController
    self.Target = Params.Target
    self.Type = Params.Type
    self.IsPreviewMode = Params.IsPreviewMode
    self.bFormPersonalPage = Params.bFormPersonalPage
    self.IsTargetUnowned = Params.IsTargetUnowned
    self.IsCharacterTrialMode = Params.IsCharacterTrialMode
    self.NoReddot = self.IsPreviewMode or self.IsTargetUnowned or self.IsCharacterTrialMode
    self:InitDispatcher()
    self:ResetTarget()
    if(self.Type == CommonConst.ArmoryType.Char)then
        self.WS_State:SetActiveWidgetIndex(0)
        self:InitCharAppearance()
        --临时处理，先不管外面传进来的AppearanceIndex
        --self:SwitchCharAppearanceSuits(Params.AppearanceIndex or self.Target.CurrentAppearanceIndex or 1)
        self:SwitchCharAppearanceSuits(self.Target.CurrentAppearanceIndex or 1)
        if(self.IsPreviewMode or self.IsTargetUnowned)then
            self.Plan_Char:SetVisibility(UIConst.VisibilityOp.Hidden)
        else
            self.Plan_Char:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            self:ResetAppearancePlanName()
        end
    else
        self.WS_State:SetActiveWidgetIndex(1)
        self:InitWeaponAppearanceSuits()
        self:AddWeaponAppearanceReddotListen(self.Target.WeaponId)
    end
end

--#region 外观命名
function M:GetAppearancePlanNames()
    local AppearanceNames = {}
    for index, value in ipairs(self.Target.AppearanceSuits) do
        local Name = value.AppearanceName
        if(not Name or Name == "")then
            Name = "UI_Squad_Appearance_TITLE" .. index
        end
        local AppearanceText = GText(Name)
        table.insert(AppearanceNames,AppearanceText)
    end
    return AppearanceNames
end

function M:ResetAppearancePlanName()
    local AppearanceNames = self:GetAppearancePlanNames()
    self.Plan_Char:Init({
        Owner = self,
        OnEditBtnClicked = self.OnAppearanceNameEditBtnClicked,
        OnPlanChanged = self.OnSuitsItemClicked,
        PlanNames = AppearanceNames,
        SelectedItemIndex = self.CurrentSuitsIdx,
    })
end

---改名按钮点击
function M:OnAppearanceNameEditBtnClicked()
    local AppearanceNames = self:GetAppearancePlanNames()
    local Data = DataMgr.GlobalConstant.CharPlanNameMax or {ConstantValue = 14}
    self.NameEditDialog = UIManager(self):ShowCommonPopupUI(100176, {
        EditTextConfig = {
            Text = AppearanceNames[self.CurrentSuitsIdx],
            IsMultiLine = false,
            Owner = self,
            TextLimit = Data.ConstantValue,
            bLimitSpaces = true,
            bNotAllowEmpty = true,
            Events = {
                OnTextChanged = function(self,Text)
                    if(Text == AppearanceNames[self.CurrentSuitsIdx])then
                        self.NameEditDialog:GetButtonBar().Btn_Yes:ForbidBtn(true)
                    else
                        self.NameEditDialog:GetButtonBar().Btn_Yes:ForbidBtn(false)
                    end
                end,
            },
            bNeedCheckStringSensitive = true,
            OnCheckStringSensitive = function(_,bSuccess,Name)
                if(bSuccess)then
                    Name = Name or ""
                    if(Name ~= "")then
                        local Avatar = GWorld:GetAvatar()
                        Avatar:UpdateCharAppearanceSuitName(self.Target.Uuid, self.CurrentSuitsIdx, Name)
                    end
                else
                end
            end
        },
    }, self)
end

function M:OnCharAppearanSuitRenamed(Ret, CharUuid, AppearanceIndex, NewName)
    if(not ErrorCode:Check(Ret))then
        return
    end
    if(CharUuid ~= self.Target.Uuid)then
        return
    end
    self:ResetTarget()
    self:ResetAppearancePlanName()
end

--#endregion 外观命名

function M:InitDispatcher()
    if(self.Type == CommonConst.ArmoryType.Char)then
        self:AddDispatcher(EventID.OnCharAppearanceChanged, self, self.OnCharAppearanceChanged)
        self:AddDispatcher(EventID.OnCharAccessorySetted, self, self.ResetTarget)
        self:AddDispatcher(EventID.OnCharAccessoryRemoved, self, self.ResetTarget)
        self:AddDispatcher(EventID.OnCharShowPartMesh, self, self.ResetTarget)
        self:AddDispatcher(EventID.OnCharCornerVisibilityChanged, self, self.ResetTarget)
        self:AddDispatcher(EventID.OnCharSkinChanged, self, self.ResetTarget)
        self:AddDispatcher(EventID.OnCharAppearanSuitRenamed, self, self.OnCharAppearanSuitRenamed)
    else
        self:AddDispatcher(EventID.OnWeaponAppearanSuitRenamed, self, self.OnWeaponAppearanSuitRenamed)
    end
end

--region 角色外观

function M:InitCharAppearance()
    self.AccessoryWidget2Type = {
        [self.Head_Skin] = CommonConst.CharAccessoryTypes.Head,
        [self.Face_Skin] = CommonConst.CharAccessoryTypes.Face,
        [self.Waist_Skin] = CommonConst.CharAccessoryTypes.Waist,
        [self.Back_Skin] = CommonConst.CharAccessoryTypes.Back,
        [self.FX_Dead_Skin] = CommonConst.CharAccessoryTypes.FX_Dead,
        [self.FX_Teleport_Skin] = CommonConst.CharAccessoryTypes.FX_Teleport,
        [self.FX_Footprint_Skin] = CommonConst.CharAccessoryTypes.FX_Footprint,
        [self.FX_Body_Skin] = CommonConst.CharAccessoryTypes.FX_Body,
        [self.FX_PlungingATK_Skin] = CommonConst.CharAccessoryTypes.FX_PlungingATK,
        [self.FX_HelixLeap_Skin] = CommonConst.CharAccessoryTypes.FX_HelixLeap,
        [self.Cap_Skin] = CommonConst.CharAccessoryTypes.Hat,
        [self.SettlementAction_Skin] = CommonConst.CharAccessoryTypes.MVP,
        [self.Tail_Skin] = CommonConst.CharAccessoryTypes.Tail,
    }
    self.DefaultCharAccessoryIds = ArmoryUtils:GetDefaultCharAccessoryIds()
    self.AccessoryType2Widget = {}
    for key, value in pairs(self.AccessoryWidget2Type) do
        self.AccessoryType2Widget[value] = key
    end
    self.NoneAccessoryIconPaths = ArmoryUtils:GetCharNoneAccessoryIconPaths()
end

function M:InitCharAppearanceSuits()
    local AppearanceSuit = self.Target.AppearanceSuits[self.CurrentSuitsIdx]
    local CharData = self.Target:Data()
    local Avatar = ArmoryUtils:GetAvatar()
    local CommonChar = Avatar.CommonChars[self.Target.CharId]
--region 皮肤
    local SkinId = AppearanceSuit.SkinId or CharData.DefaultSkinId
    local SkinData = DataMgr.Skin[SkinId]
    if(not SkinData)then
        SkinData = DataMgr.Skin[CharData.DefaultSkinId]
    end
    local Skin = CommonChar and CommonChar.OwnedSkins[SkinId]
    local CharDyeInfos, CurrentDyePlanIndex
    if(self.bFormPersonalPage)then
        CharDyeInfos = Skin and Skin.Colors or {}
        CurrentDyePlanIndex = Skin and Skin.CurrentPlanIndex or nil
    end
    local SkinItemContent = {
        bDyeable = not (CharData.DefaultSkinId == SkinId),
        IconPath = SkinData.LongIcon,
        Owner = self,
        Type = self.Type,
        IsPreviewMode = self.IsPreviewMode,
        IsTargetUnowned = self.IsTargetUnowned,
        DyeInfos = CharDyeInfos,
        DyePlanIndex = CurrentDyePlanIndex,
        NoState = true,
        OnClicked = function()
            if self.bFormPersonalPage then
                return
            end
            local Params = {
                Target = self.Target,
                Type = self.Type,
                SkinId = SkinId,
                OnCloseCallback = self.OnSkinClosed,
                Parent = self,
                IsCharacterTrialMode = self.IsCharacterTrialMode,
                IsTargetUnowned = self.IsTargetUnowned,
            }
            self:OpenSkin(Params)
        end,
        TipType = "Skin",
        ItemId = SkinId,
        Rarity = SkinData.Rarity,
    }
    self:OnSkinItemContentCreated(SkinItemContent)
    self.Char_Skin:OnListItemObjectSet(SkinItemContent)
--endregion 皮肤

--region 发型
    local HairId
    if(AppearanceSuit.HairId and AppearanceSuit.HairId > 0)then
        HairId = AppearanceSuit.HairId
    else
        HairId = CharData.DefaultHairId or self.Target.CharId
    end
    local HairData = DataMgr.Hair[HairId]
    if(not HairData)then
        HairData = DataMgr.Hair[CharData.DefaultHairId]
    end
    local Hair = CommonChar and CommonChar.OwnedHairs[SkinId]
    local HairDyeInfos, CurrentHairDyePlanIndex
    if(self.bFormPersonalPage)then
        HairDyeInfos = Hair and Hair.Colors or {}
        CurrentHairDyePlanIndex = Hair and Hair.CurrentPlanIndex or nil
    end
    local HairItemContent = {
        bDyeable = not (CharData.DefaultHairId == SkinId),
        IconPath = HairData.Icon,
        Owner = self,
        Type = self.Type,
        IsPreviewMode = self.IsPreviewMode,
        IsTargetUnowned = self.IsTargetUnowned,
        DyeInfos = HairDyeInfos,
        DyePlanIndex = CurrentHairDyePlanIndex,
        NoState = true,
        OnClicked = function()
            if self.bFormPersonalPage then
                return
            end
            local Params = {
                Target = self.Target,
                Type = self.Type,
                HairId = HairId,
                OnCloseCallback = self.OnSkinClosed,
                Parent = self,
                IsCharacterTrialMode = self.IsCharacterTrialMode,
                IsTargetUnowned = self.IsTargetUnowned,
            }
            self:OpenSkin(Params)
        end,
        TipType = "Hair",
        ItemId = HairId,
        Rarity = HairData.Rarity,
    }
    self:OnAccessoryItemContentCreated(HairItemContent)
    self.Hair_Skin:OnListItemObjectSet(HairItemContent)
--endregion 发型

--region 配饰
    local PartMeshAccessoryId,PartMeshAccessoryType = self.Target:GetPartMeshAccessoryInfo(SkinId)
    for CharAccessoryType, AccessoryTypeIdx in pairs(CommonConst.NewCharAccessoryTypes) do
        local AccessoryId = AppearanceSuit.Accessory[AccessoryTypeIdx] or self.NoneAccessoryId
        if( (AccessoryId <= 0)
            and PartMeshAccessoryType
            and PartMeshAccessoryType == CharAccessoryType)then
            AccessoryId = PartMeshAccessoryId
        end
        local Widget = self.AccessoryType2Widget[CharAccessoryType]
        if(Widget)then
            local Obj = self:NewCharAccessoryItemContent(AccessoryId,CharAccessoryType,SkinId)
            self:OnAccessoryItemContentCreated(Obj)
            Widget:OnListItemObjectSet(Obj)
        end
    end
--endregion 配饰
end

function M:NewCharAccessoryItemContent(AccessoryId,AccessoryType,SkinId)
    local CharAccessoryData = DataMgr.CharAccessory[AccessoryId] or DataMgr.CharPartMesh[AccessoryId]
    local Obj = {
        Owner = self,
        OnClicked = function()
            AudioManager(self):PlayUISound(nil, "event:/ui/common/click_mid", nil, nil)
            if self.bFormPersonalPage then
                return
            end
            local Params = {
                Target = self.Target,
                Type = self.Type,
                AccessoryId = AccessoryId,
                AccessoryType = AccessoryType,
                OnCloseCallback = self.OnSkinClosed,
                IsCharacterTrialMode = self.IsCharacterTrialMode,
                IsTargetUnowned = self.IsTargetUnowned,
                Parent = self,}
            self:OpenSkin(Params)
        end,
        IsPreviewMode = self.IsPreviewMode,
        IsTargetUnowned = self.IsTargetUnowned,
        TipType = DataMgr.CharAccessory[AccessoryId] and "CharAccessory" or "CharPartMesh",
    }
    Obj.AccessoryId = AccessoryId
    Obj.AccessoryType = AccessoryType
    Obj.IsCharacterTrialMode = self.IsCharacterTrialMode
    if(CharAccessoryData
    and self.DefaultCharAccessoryIds[AccessoryType] ~= AccessoryId
    and ArmoryUtils:IsSkinSupportAccessory(SkinId,AccessoryId))then
        Obj.IconPath = CharAccessoryData.Icon
        Obj.IsNoneIcon = false
        Obj.IsDressed = Obj.ItemId and Obj.ItemId > 0 and Obj.ItemId ~= DataMgr.GlobalConstant.EmptyCharAccessoryID.ConstantValue
        Obj.Rarity = CharAccessoryData.Rarity
    else
        Obj.IconPath = self.NoneAccessoryIconPaths[AccessoryType]
        Obj.IsNoneIcon = true
    end
    return Obj
end

function M:OpenSkin(Params)
    local UIConfig = DataMgr.SystemUI.ArmorySkin
    UIManager(self):LoadUI(UIConst.LoadInConfig, UIConfig.UIName,self.Parent:GetZOrder(),Params)
end

--endregion 角色外观

function M:OnAccessoryItemContentCreated(Content)
end

function M:OnSkinItemContentCreated(Content)
end

--region 武器外观

function M:InitWeaponAppearanceSuits()
    local Appearacne = self.Target:GetAppearance()
    local WeaponData = self.Target:Data()
    ------武器皮肤
    local SkinId = Appearacne.SkinId
    if(not SkinId or SkinId <=0 )then
        SkinId = self.Target.WeaponId
    end
    local SkinData = DataMgr.WeaponSkin[SkinId] or {LongIcon = WeaponData.LongIcon or WeaponData.GachaIcon}
    local ColorInfos, CurrentDyePlanIndex
    local SpecialColor
    if(self.bFormPersonalPage)then
        local WeaponDyeInfos = self.Target:GetSkin(SkinId)
        ColorInfos = WeaponDyeInfos.Colors
        SpecialColor = WeaponDyeInfos.SpecialColor
        CurrentDyePlanIndex = WeaponDyeInfos.CurrentPlanIndex
    end

    local SkinItemContent = {
        bDyeable = true,
        IconPath = SkinData.LongIcon,
        Rarity = SkinData.Rarity,
        Owner = self,
        Type = self.Type,
        bFormPersonalPage = self.bFormPersonalPage,
        IsPreviewMode = self.IsPreviewMode,
        IsTargetUnowned = self.IsTargetUnowned,
        --IsCharacterTrialMode = self.IsCharacterTrialMode,
        DyeInfos = ColorInfos,
        DyePlanIndex = CurrentDyePlanIndex,
        SpecialColor = SpecialColor,
        NoState = true,
        -- Target = self.Target,
        -- SkinId = SkinId,
        OnClicked = function()
            local Params = {
                Target = self.Target,
                Type = self.Type,
                SkinId = SkinId,
                OnCloseCallback = self.OnSkinClosed,
                IsCharacterTrialMode = self.IsCharacterTrialMode,
                IsTargetUnowned = self.IsTargetUnowned,
                Parent = self,}
            self:OpenSkin(Params)
        end,
        ItemId = SkinId or nil,
        TipType = DataMgr.WeaponSkin[SkinId] and "WeaponSkin" or nil,
    }
    self:OnSkinItemContentCreated(SkinItemContent)
    self.Weapon_Skin:OnListItemObjectSet(SkinItemContent)
    --------武器配饰
    self.AccessoryWidget2Type = {
        [self.Accessory_Skin] = CommonConst.WeaponAccessoryTypes.Accessory,
        [self.WeaponSpecial_Skin] = CommonConst.WeaponAccessoryTypes.RunAttack,
    }
    self.AccessoryType2Widget = {}
    for key, value in pairs(self.AccessoryWidget2Type) do
        self.AccessoryType2Widget[value] = key
    end
    local WeaponAccessoryData
    for Widget, AccessoryType in pairs(self.AccessoryWidget2Type) do
        local AccessoryId = Appearacne.Accessory[CommonConst.WeaponAccessoryTypes[AccessoryType]] or -1
        WeaponAccessoryData = DataMgr.WeaponAccessory[AccessoryId]
        local AccessoryContent = {
            Owner = self,
            OnClicked = function()
                local Params = {
                    Target = self.Target,
                    Type = self.Type,
                    AccessoryId = AccessoryId,
                    AccessoryType = AccessoryType,
                    OnCloseCallback = self.OnSkinClosed,
                    Parent = self,
                    IsCharacterTrialMode = self.IsCharacterTrialMode,
                    IsTargetUnowned = self.IsTargetUnowned,
                }
                self:OpenSkin(Params)
            end,
            Rarity = WeaponAccessoryData and WeaponAccessoryData.Rarity,
            IsPreviewMode = self.IsPreviewMode,
            IsTargetUnowned = self.IsTargetUnowned,
            --IsCharacterTrialMode = self.IsCharacterTrialMode,
            TipType = "WeaponAccessory",
            AccessoryId = AccessoryId
        }
        if(not WeaponAccessoryData)then
            AccessoryContent.IconPath = UIUtils.GetNoneAccessoryIconPath()
            AccessoryContent.IsNoneIcon = true
        else
            AccessoryContent.IconPath = WeaponAccessoryData.Icon
            AccessoryContent.IsNoneIcon = false
        end
        self:OnAccessoryItemContentCreated(AccessoryContent)
        Widget:OnListItemObjectSet(AccessoryContent)
    end
end

--endregion 武器外观


function M:Construct()
    self.NoneAccessoryId = DataMgr.GlobalConstant.EmptyCharAccessoryID.ConstantValue
    self.EMScrollBox.OnUserScrolled:Add(self, self.OnScrollBoxScrolled)
    self:AddTimer(0.2,function()
        self:OnScrollBoxScrolled(self.EMScrollBox:GetScrollOffset())
    end)
end

function M:OnScrollBoxScrolled(CurrScrollOffset)
    if CurrScrollOffset >= self.EMScrollBox:GetScrollOffsetOfEnd() - 10 then
        self.List_Arrow_Down:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self.List_Arrow_Down:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
end

function M:OnSkinClosed()
    self.Parent:BlockAllUIInput(false)
    local ArmoryMain = UIManager(self):GetArmoryUIObj()
    if(ArmoryMain)then
        ArmoryMain:ResetActorRotation()
        ArmoryMain:UpdateMontageAndCamera()
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

--region Tab

function M:SwitchCharAppearanceSuits(SuitsIdx)
    self.CurrentSuitsIdx = SuitsIdx
    self:InitCharAppearanceSuits()
    self:AddCharAppearanceReddotListen(self.Target.CharId)
end

function M:OnSuitsItemClicked(Index)
    self.Parent:BlockAllUIInput(true)
    local Avatar = GWorld:GetAvatar()
    Avatar:SwitchCurrentCharAppearance(self.Target.Uuid,Index)
end

function M:OnCharAppearanceChanged(Ret,CharUuid, AppearancIndex)
    self.Parent:BlockAllUIInput(false)
    if not ErrorCode:Check(Ret) then return end
    self:ResetTarget()
    self:SwitchCharAppearanceSuits(self.Target.CurrentAppearanceIndex)
    if(self.ActorController and self.ActorController.ArmoryPlayer)then
        self.ActorController:ChangeCharAppearance(self.Target:DumpAppearanceSuit(GWorld:GetAvatar()))
        self.ActorController.DelayFrame = 30
        self.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Char,nil,CommonConst.ArmoryTag.Appearance)
    end
    self:PlayAnimation(self.Change)
end

function M:ResetTarget()
    local Avatar = ArmoryUtils:GetAvatar()
    if(self.Type == CommonConst.ArmoryType.Char)then
        self.Target = Avatar.Chars[self.Target.Uuid] or self.Target
    else
        self.Target = Avatar.Weapons[self.Target.Uuid] or self.Target
    end
end

function M:PlayInAnim()
    self:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    self:StopAnimation(self.Out)
    self:PlayAnimation(self.In)
end

function M:PlayOutAnim()
    self:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])
    self:StopAnimation(self.In)
    self:PlayAnimation(self.Out)
end

--endregion Tab

--#region 红点

function M:AddCharAppearanceReddotListen(CharId)
    if(self.NoReddot)then return end
    self.AppearanceNodeNames = self.AppearanceNodeNames or {}
    self:RemoveAppearanceReddotListen()
    local Avatar = GWorld:GetAvatar()
    local CommonChar = Avatar.CommonChars[CharId]
    for _,Type in pairs(CommonConst.CharAccessoryTypes) do
        local LeafNodes = {}
        local NodeName = CharId .. CommonConst.DataType.CharAccessory.. Type
        if(self.AccessoryType2Widget[Type])then
            local LeafNodeName = CommonConst.DataType.CharAccessory..Type
            LeafNodes[LeafNodeName] = ReddotManager.GetTreeNode(LeafNodeName) and 1 or nil
            for key, Skin in pairs(CommonChar.OwnedSkins) do
                LeafNodeName = LeafNodeName..Skin.SkinId
                LeafNodes[LeafNodeName] = ReddotManager.GetTreeNode(LeafNodeName) and 1 or nil
            end
            if not IsEmptyTable(LeafNodes) then
                ReddotManager.AddListener(NodeName, self,  function(_self,Count)
                    local Content = self.AccessoryType2Widget[Type].Content
                    Content.IsNew = Count > 0
                    ArmoryUtils:UpdateContentRetDotType(Content)
                    self.AccessoryType2Widget[Type]:SetReddot(Content.RedDotType)
                end,LeafNodes)
                self.AppearanceNodeNames[NodeName] = 1
            end
        end
    end
    local NodeName = CommonConst.DataType.Char .. CommonConst.DataType.Skin..CharId
    ReddotManager.AddListener(NodeName, self, function(_self,Count)
        local Content = self.Char_Skin.Content
        Content.Upgradeable = ArmoryUtils:CanSkinUpgrade(self.Char_Skin.ItemId)
        Content.IsNew = Count > 0
        ArmoryUtils:UpdateContentRetDotType(Content)
        self.Char_Skin:SetReddot(Content.RedDotType)
    end,nil,true)
    self.AppearanceNodeNames[NodeName] = 1
    NodeName = CommonConst.DataType.Char .. CommonConst.DataType.Hair..CharId
    ReddotManager.AddListener(NodeName, self, function(_self,Count)
        local Content = self.Hair_Skin.Content
        Content.IsNew = Count > 0
        ArmoryUtils:UpdateContentRetDotType(Content)
        self.Hair_Skin:SetReddot(Content.RedDotType)
    end,nil,true)
    self.AppearanceNodeNames[NodeName] = 1
end

function M:RemoveAppearanceReddotListen()
    if(self.NoReddot)then return end
    for key, value in pairs(self.AppearanceNodeNames) do
        ReddotManager.RemoveListener(key, self)
    end
    self.AppearanceNodeNames = {}
end

function M:AddWeaponAppearanceReddotListen(WeaponId)
    if(self.NoReddot)then return end
    self.AppearanceNodeNames = self.AppearanceNodeNames or {}
    self:RemoveAppearanceReddotListen()
    local NodeName = WeaponId .. CommonConst.DataType.Weapon .. CommonConst.DataType.WeaponSkin
    local LeafNodes = {}
    local Data = DataMgr.Weapon[WeaponId]
    if(Data and Data.SkinApplicationType)then
        for _, value in pairs(Data.SkinApplicationType) do
            local LeafNodeName = CommonConst.DataType.WeaponSkin .. (value or "")
            LeafNodes[LeafNodeName] = ReddotManager.GetTreeNode(LeafNodeName) and 1 or nil
        end
    end
    self.AppearanceNodeNames[NodeName] = 1
    if(not IsEmptyTable(LeafNodes))then
        ReddotManager.AddListener(NodeName, self, function(_self,Count)
            local Content = self.Weapon_Skin.Content
            Content.IsNew = Count > 0
            ArmoryUtils:UpdateContentRetDotType(Content)
            self.Weapon_Skin:SetReddot(Content.RedDotType)
        end,LeafNodes)
    end

    local WeaponAccessoryNodeName = CommonConst.DataType.WeaponAccessory
    self.AppearanceNodeNames[WeaponAccessoryNodeName] = 1
    ReddotManager.AddListener(WeaponAccessoryNodeName, self, function(_self,Count)
        local Content = self.Accessory_Skin.Content
        Content.IsNew = Count > 0
        ArmoryUtils:UpdateContentRetDotType(Content)
        self.Accessory_Skin:SetReddot(Content.RedDotType)
    end,nil,true)
end

--#endregion 红点

function M:Destruct()
    self:RemoveAppearanceReddotListen()
end

AssembleComponents(M)

return M