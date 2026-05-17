local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"

local M = {}
local MAX_SKIN_LEVEL = 3

function M:Construct()
    self:AddDispatcher(EventID.OnCharAccessorySetted, self, self.OnCharAccessoryChanged)
    self:AddDispatcher(EventID.OnCharAccessoryRemoved, self, self.OnCharAccessoryChanged)
    self:AddDispatcher(EventID.OnCharAppearanceChanged, self, self.OnCharAppearanceChanged)
    self:AddDispatcher(EventID.OnCharShowPartMesh, self, self.OnCharShowPartMesh)
    self:AddDispatcher(EventID.OnCharSkinChanged, self, self.OnCharSkinChanged)
    self:AddDispatcher(EventID.OnCharHairChanged, self, self.OnCharHairChanged)

    self:AddDispatcher(EventID.OnNewCharSkinObtained, self, self.OnNewCharSkinObtained)
    self:AddDispatcher(EventID.OnNewCharAccessoryObtained, self, self.OnNewCharAccessoryObtained)
    self:AddDispatcher(EventID.OnNewCharHairObtained, self, self.OnNewCharHairObtained)

end

function M:CreateConstVariable()
    if(rawget(self,"bConstVariableCreated"))then
        return
    end
    rawset(self,"bConstVariableCreated",true)
    rawset(self,"AccessoryTypes",{
        CommonConst.CharAccessoryTypes.Hat,
        CommonConst.CharAccessoryTypes.Head,
        CommonConst.CharAccessoryTypes.Face,
        CommonConst.CharAccessoryTypes.Back,
        CommonConst.CharAccessoryTypes.Tail,
        CommonConst.CharAccessoryTypes.Waist,
        CommonConst.CharAccessoryTypes.FX_Teleport,
        CommonConst.CharAccessoryTypes.FX_Footprint,
        CommonConst.CharAccessoryTypes.FX_Body,
        CommonConst.CharAccessoryTypes.FX_PlungingATK,
        CommonConst.CharAccessoryTypes.FX_HelixLeap,
        CommonConst.CharAccessoryTypes.FX_Dead,
    })
    rawset(self,"FXAccessoryTypes",{
        [CommonConst.CharAccessoryTypes.FX_Dead] = true,
        [CommonConst.CharAccessoryTypes.FX_Teleport] = true,
        [CommonConst.CharAccessoryTypes.FX_Footprint] = true,
        [CommonConst.CharAccessoryTypes.FX_PlungingATK] = true,
        [CommonConst.CharAccessoryTypes.FX_HelixLeap] = true,
        [CommonConst.CharAccessoryTypes.MVP] = true,
    })
    rawset(self,"AttachableFXAccessoryTypes",{
        [CommonConst.CharAccessoryTypes.FX_Footprint] = true,
    })
    rawset(self,"HidePlayerAccessoryTypes",{
        [CommonConst.CharAccessoryTypes.FX_Dead] = true,
        [CommonConst.CharAccessoryTypes.FX_Footprint] = true,
    })
end

function M:OnNewCharSkinObtained(SkinId,CharId)
    self:OnNewSkinObtained(SkinId)
end

function M:OnNewCharHairObtained(HairId,CharId)
    if(not self.HairMap)then
        return
    end
    local Content = self.HairMap[HairId]
    if(Content)then
        Content.LockType = nil
        if(not self.NoReddot)then
            Content.RedDotType = UIConst.RedDotType.NewRedDot
        end
        if(Content.SelfWidget)then
            Content.SelfWidget:OnListItemObjectSet(Content)
        end
        if(self.SelectedHairId == HairId and self.CurrentTopTabIdx == self.HairTabIdx)then
            self:UpdateHairDetails(Content)
        end
    end
end

function M:OnNewCharAccessoryObtained(AccessoryId)
    self:OnNewAccessoryObtained(AccessoryId)
end

function M:AddTopTabReddotListen()
    if(self.NoReddot)then
        return
    end
    if(self.Type ~= CommonConst.ArmoryType.Char)then
        return
    end

    self:AddCharAppearanceReddotListen(self.UpdateTopTabReddot, self.Target.CharId,{CommonConst.CharAccessoryTypes.MVP})
end

local SetTopTabReddot = function(self,TabIdx,IsNew, IsNormal)
    local Content = self.TopTabs[TabIdx]
    Content.IsNew = IsNew
    Content.IsNormal = IsNormal
    if IsValid(Content.UI) then
        Content.UI:SetReddot(Content.IsNew, Content.IsNormal)
    end
end

function M:UpdateTopTabReddot()
    local Avatar = GWorld:GetAvatar()
    local CommonChar = Avatar.CommonChars[self.Target.CharId]
    if(not CommonChar)then
        return
    end

    local LeafNodeName = CommonConst.DataType.Char .. CommonConst.DataType.Skin.."LevelUp"..self.Target.CharId
    local SkinLevelUpNode = ReddotManager.GetTreeNode(LeafNodeName)
    local SkinLevelUpCount = SkinLevelUpNode and SkinLevelUpNode.Count or 0

    local LeafNodeName = CommonConst.DataType.Char .. CommonConst.DataType.Skin..self.Target.CharId
    local NewSkinNode = ReddotManager.GetTreeNode(LeafNodeName)
    local NewSkinCount = NewSkinNode and NewSkinNode.Count or 0

    local LeafNodeName = CommonConst.DataType.Char .. CommonConst.DataType.Hair..self.Target.CharId
    local NewHairNode = ReddotManager.GetTreeNode(LeafNodeName)
    local NewHairCount = NewHairNode and NewHairNode.Count or 0

    local NewAccessoryCount = 0
    local NewMVPCount = 0
    for _,Type in pairs(CommonConst.CharAccessoryTypes) do
        LeafNodeName = CommonConst.DataType.CharAccessory..Type
        local NewAccessoryNode = ReddotManager.GetTreeNode(LeafNodeName)
        if(Type == CommonConst.CharAccessoryTypes.MVP)then
            NewMVPCount = NewMVPCount + (NewAccessoryNode and NewAccessoryNode.Count or 0)
        else
            NewAccessoryCount = NewAccessoryCount + (NewAccessoryNode and NewAccessoryNode.Count or 0)
            for key, Skin in pairs(CommonChar.OwnedSkins) do
                LeafNodeName = LeafNodeName..Skin.SkinId
                NewAccessoryNode = ReddotManager.GetTreeNode(LeafNodeName)
                NewAccessoryCount = NewAccessoryCount + (NewAccessoryNode and NewAccessoryNode.Count or 0)
            end
        end
    end
    if SkinLevelUpCount > 0 then
        SetTopTabReddot(self, 1,false, true)
    else
        SetTopTabReddot(self, 1,NewSkinCount > 0)
    end

    SetTopTabReddot(self, 2,NewHairCount > 0)
    SetTopTabReddot(self, 3,NewAccessoryCount > 0)
    SetTopTabReddot(self, 4,NewMVPCount > 0)
end

function M:RemoveTopTabReddotListen()
    if(self.NoReddot)then
        return
    end
    self:RemoveCharAppearanceReddotListen()
end

--region 角色皮肤

---初始化角色皮肤界面
function M:InitCharSkin()
    if(self.ActorController)then
        self.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Char,"","","")
        self.ActorController:HidePlayerActor(self.UIName,false)
    end
    local SkinId = self.JumpToSkinId or self.SelectedSkinId
    if(self.JumpToSkinId)then
        self.LastCharSkinId = self.JumpToSkinId
    end
    self.JumpToSkinId = nil
    self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
    self:InitCharSkinList(self.Target)
    self:SelectSkinById(SkinId)
    self:RefreshLevelUpReddot()
end

function M:InitCharSkinList(Char)
    if(self.bCharSkinListInited)then
        return
    end
    rawset(self,"bCharSkinListInited",true)
    rawset(self,"SkinMap",{})
    rawset(self,"SkinArray",{})
    local Avatar = GWorld:GetAvatar()
    local DefaultSkinId = Char:GetDefaultSkinId()
    rawset(self,"DefaultSkinId",DefaultSkinId)
    local LeafNodeName = CommonConst.DataType.Char .. CommonConst.DataType.Skin .. Char.CharId
    local CacheDetail = {}
    if(not self.NoReddot)then
        CacheDetail = ReddotManager.GetLeafNodeCacheDetail(LeafNodeName) or {}
    end
    local OtherCharSkins = Avatar.OtherCharSkins[Char.CharId] or {}
    local OtherOwnedSkins = {}
    for key, value in pairs(OtherCharSkins) do
        OtherOwnedSkins[value] = true
    end
    for SkinId, Data in pairs(DataMgr.Skin) do
        if(Data.CharId ~= Char.CharId)then
            goto continue
        end
        if((not OtherOwnedSkins[SkinId] and not Char:GetSkin(SkinId,Avatar)) and not UIUtils.ShouldDisplayItem(CommonConst.DataType.Skin,SkinId))then
            goto continue
        end
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        rawset(Obj,"IsCharacterTrialMode",self.IsCharacterTrialMode)
        rawset(Obj,"SkinId",SkinId)
        rawset(Obj,"ItemId",SkinId)
        rawset(Obj,"IconPath",Data.LongIcon)
        rawset(Obj,"Rarity",Data.Rarity)
        rawset(Obj,"Name",GText(Data.SkinName))
        rawset(Obj,"Name_World",EnText(Data.SkinName))
        rawset(Obj,"Rarity",Data.Rarity)
        rawset(Obj,"Text",GText(Data.SkinDescribe))
        rawset(Obj,"CharId",Char.CharId)
        rawset(Obj,"ItemType",CommonConst.DataType.Skin)
        rawset(Obj,"Owner",self)
        rawset(Obj,"OnClicked",self.OnSkinItemClicked)
        rawset(Obj,"bDyeable",SkinId ~= DefaultSkinId)
        rawset(Obj,"IsTargetUnowned",self.IsTargetUnowned)
        rawset(Obj,"IsNew", CacheDetail[SkinId]==1)
        if ArmoryUtils:CanSkinUpgrade(SkinId) then
            rawset(Obj,"Upgradeable", true)
            rawset(Obj,"RedDotType",UIConst.RedDotType.CommonRedDot)
        else
            rawset(Obj,"RedDotType",UIConst.RedDotType.NewRedDot)
        end

        if(Char:GetSkin(SkinId,Avatar))then
            rawset(Obj,"LockType",false)
        else
            if(OtherOwnedSkins[SkinId])then
                rawset(Obj,"LockType",false)
            else
                rawset(Obj,"LockType",SkinId ~= DefaultSkinId)
            end
        end
        local CharInfo = DataMgr.BattleChar[Data.CharId]
        if CharInfo then
            rawset(Obj,"ElementType",CharInfo.Attribute)
            rawset(Obj,"CharName",GText(CharInfo.CharName))
        end
        if Avatar and not Avatar:CheckCharEnough({[Data.CharId] = 1}) then
            rawset(Obj,"NotOwned",true)
        end
        rawset(Obj,"IsEquipped",false)
        self.SkinMap[SkinId] = Obj
        self:OnSkinContentCreated(Obj)
        table.insert(self.SkinArray,Obj)
		::continue::
    end
    table.sort(self.SkinArray,function(a,b)
        return a.SkinId < b.SkinId
    end)
    local AppearanceSuit = Char:GetAppearance()
    local SkinId = AppearanceSuit  and AppearanceSuit.SkinId
    if(not SkinId or SkinId <= 0)then
        SkinId = DefaultSkinId
    end
    if(SkinId and self.SkinMap[SkinId])then
        self.CurrentSkinContent = self.SkinMap[SkinId]
        self.CurrentSkinContent.IsEquipped = true
    end
    self:InitSkinList()
end

function M:OnSkinContentCreated()
end

function M:OnCharSkinConfirmBtnClicked()
    if(not self.SelectedSkinId or self.SelectedSkinId <= 0)then
        return
    end

    -- 皮肤不同时切换
    if not self:IsEquipedSelectedSkin() then
        self:BlockAllUIInput(true, "ChangeCharAppearanceSkin")
        local Avatar = GWorld:GetAvatar()
        Avatar:ChangeCharAppearanceSkin(self.Target.Uuid,self.AppearanceSuitIndex,self.SelectedSkinId)
    end

    -- 切换皮肤等级
    self:ChangeCharSkinLevel()
end

function M:OnCharSkinGotoBagBtnClicked()
    UIManager(self):LoadUINew("CharSkinPreview", self.UseParamsInOpt)
end

function M:OnCharHairGotoBagBtnClicked()
    UIManager(self):LoadUINew("CharSkinPreview", self.UseParamsInOpt)
end

function M:OnCharSkinGoToShopBtnClicked()
    if(not self.SelectedSkinId or self.SelectedSkinId <= 0)then
        return
    end
    local SkinInfo = DataMgr.Skin[self.SelectedSkinId]
    if not SkinInfo then return end
    local ItemIds = SkinInfo.GoShopTypeId
    if not ItemIds or not next(ItemIds) then return end
    for _, ItemId in ipairs(ItemIds) do
        local ShopItemData = DataMgr.ShopItem[ItemId]
        if ShopItemData then
            local AccessData = DataMgr.Access["Shop_Main"]
            local IsShopAccessValid = AccessData and AccessData.UIUnlockRuleId and PageJumpUtils:IsValidAccess(AccessData.UIUnlockRuleId)
            local bSuccess,JumpToPage = PageJumpUtils:CreateJumpToShopAccess(ShopItemData.ItemType,"Shop",ShopItemData.TypeId)
            if bSuccess and JumpToPage then
                JumpToPage()
                return
            end	
        end	
    end
    Utils.ScreenPrint("皮肤表对应的商品Id可能没配对,麻烦策划检查一下")
end

function M:OnCharHairGoToShopBtnClicked()
    if(not self.SelectedHairId or self.SelectedHairId <= 0)then
        return
    end
    local HairInfo = DataMgr.Hair[self.SelectedHairId]
    if not HairInfo then return end
    local ItemIds = HairInfo.GoShopTypeId
    if not ItemIds or not next(ItemIds) then return end
    for _, ItemId in ipairs(ItemIds) do
        local ShopItemData = DataMgr.ShopItem[ItemId]
        if ShopItemData then
            local AccessData = DataMgr.Access["Shop_Main"]
            local IsShopAccessValid = AccessData and AccessData.UIUnlockRuleId and PageJumpUtils:IsValidAccess(AccessData.UIUnlockRuleId)
            local bSuccess,JumpToPage = PageJumpUtils:CreateJumpToShopAccess(ShopItemData.ItemType,"Shop",ShopItemData.TypeId)
            if bSuccess and JumpToPage then
                JumpToPage()
                return
            end	
        end	
    end
    Utils.ScreenPrint("发型表对应的商品Id可能没配对,麻烦策划检查一下")
end

function M:OnCharSkinChanged(Ret,CharUuid, AppearanceIndex, SkinId)
    self:BlockAllUIInput(false, "ChangeCharAppearanceSkin")
    if(not ErrorCode:Check(Ret))then
        return
    end
    self:ResetTarget()
    if(self.CurrentSkinContent)then
        ArmoryUtils:SetItemSelectTag(self.CurrentSkinContent,false)
    end
    self.CurrentSkinContent = self.SkinMap[SkinId]
    ArmoryUtils:SetItemSelectTag(self.CurrentSkinContent,true)
    self:UpdateFunctionBtn(self.CurrentSkinContent,self.CurrentSkinContent)
end

--endregion 角色皮肤

--region 角色发型

function M:InitCharHair()
    if(self.ActorController)then
        self.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Char,"","","")
        self.ActorController:HidePlayerActor(self.UIName,false)
    end
    local HairId = self.JumpToHairId or self.SelectedHairId
    if(self.JumpToHairId)then
        self.LastCharHairId = self.JumpToHairId
    end
    self.JumpToHairId = nil
    self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
    self.Mask_Tab:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:CreateHairContents(self.Target)
    self:InitCharHairList()
    self:SelectHairById(HairId)
end

function M:CreateHairContents(Target)
    if(self.bHairContentsCreated)then
        return
    end
    local Char = Target
    rawset(self,"bHairContentsCreated",true)
    rawset(self,"HairMap",{})
    rawset(self,"HairArray",{})
    local Avatar = GWorld:GetAvatar()
    local DefaultHairId = Char:GetDefaultHairId()
    rawset(self,"DefaultHairId",DefaultHairId)
    local LeafNodeName = CommonConst.DataType.Char .. CommonConst.DataType.Hair .. Char.CharId
    local CacheDetail = {}
    if(not self.NoReddot)then
        CacheDetail = ReddotManager.GetLeafNodeCacheDetail(LeafNodeName) or {}
    end
    local OtherCharHairs = Avatar.OtherCharHairs[Char.CharId] or {}
    local OtherOwnedHairs = {}
    for key, value in pairs(OtherCharHairs) do
        OtherOwnedHairs[value] = true
    end
    self.BP_HairContents:Clear()
    for HairId, Data in pairs(DataMgr.Hair) do
        if(Data.CharId ~= Char.CharId)then
            goto continue
        end
        if((not OtherOwnedHairs[HairId] and not Char:GetHair(HairId,Avatar)) and not UIUtils.ShouldDisplayItem(CommonConst.DataType.Hair,HairId))then
            goto continue
        end
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        rawset(Obj,"IsCharacterTrialMode",self.IsCharacterTrialMode)
        rawset(Obj,"HairId",HairId)
        rawset(Obj,"ItemId",HairId)
        rawset(Obj,"Id",HairId)
        rawset(Obj,"IconPath",Data.Icon)
        rawset(Obj,"Icon",Data.Icon)
        rawset(Obj,"Rarity",Data.Rarity)
        rawset(Obj,"Name",GText(Data.Name))
        rawset(Obj,"Name_World",EnText(Data.Name))
        rawset(Obj,"Rarity",Data.Rarity)
        rawset(Obj,"Text",GText(Data.HairDescribe))
        rawset(Obj,"CharId",Char.CharId)
        rawset(Obj,"ItemType",CommonConst.DataType.Hair)
        rawset(Obj,"Owner",self)
        rawset(Obj,"bDyeable",HairId ~= DefaultHairId)
        rawset(Obj,"RedDotType",CacheDetail[HairId]==1 and UIConst.RedDotType.NewRedDot)
        rawset(Obj,"IsTargetUnowned",self.IsTargetUnowned)
        if(Char:GetHair(HairId,Avatar))then
            rawset(Obj,"LockType",false)
        else
            if(OtherOwnedHairs[HairId])then
                rawset(Obj,"LockType",false)
            else
                rawset(Obj,"LockType",HairId ~= DefaultHairId and 2)
            end
        end
        local CharInfo = DataMgr.BattleChar[Data.CharId]
        if CharInfo then
            rawset(Obj,"ElementType",CharInfo.Attribute)
            rawset(Obj,"CharName",GText(CharInfo.CharName))
        end
        if Avatar and not Avatar:CheckCharEnough({[Data.CharId] = 1}) then
            rawset(Obj,"NotOwned",true)
        end
        rawset(Obj,"bSelectTag",false)
        self.HairMap[HairId] = Obj
        self.BP_HairContents:Add(Obj)
        self:OnHairContentCreated(Obj)
        table.insert(self.HairArray,Obj)
		::continue::
    end
    table.sort(self.HairArray,function(a,b)
        return a.HairId < b.HairId
    end)
    local AppearanceSuit = Char:GetAppearance()
    local HairId = AppearanceSuit  and AppearanceSuit.HairId
    if(not HairId or HairId <= 0)then
        HairId = DefaultHairId
    end
    if(HairId and self.HairMap[HairId])then
        self.CurrentHairContent = self.HairMap[HairId]
        self.CurrentHairContent.bSelectTag = true
    end
end

function M:InitCharHairList()
    if self.HairArray == nil then
        return
    end
    self.List_Accessory:ClearListItems()
    for index, value in ipairs(self.HairArray) do
        self.List_Accessory:AddItem(value)
    end
    self.List_Accessory:RequestFillEmptyContent()
end

function M:OnMVPContentCreated()
end

function M:OnHairContentCreated()
end

function M:OnCharHairConfirmBtnClicked()
    if(not self.SelectedHairId or self.SelectedHairId <= 0)then
        return
    end
    self:BlockAllUIInput(true)
    local Avatar = GWorld:GetAvatar()
    Avatar:ChangeCharAppearanceHair(self.Target.Uuid,self.AppearanceSuitIndex,self.SelectedHairId)
end

function M:OnCharHairGoToShopBtnClicked()
    if(not self.SelectedHairId or self.SelectedHairId <= 0)then
        return
    end
    local HairInfo = DataMgr.Hair[self.SelectedHairId]
    if not HairInfo then return end
    local ItemIds = HairInfo.GoShopTypeId
    if not ItemIds or not next(ItemIds) then return end
    for _, ItemId in ipairs(ItemIds) do
        local ShopItemData = DataMgr.ShopItem[ItemId]
        if ShopItemData then
            local AccessData = DataMgr.Access["Shop_Main"]
            local IsShopAccessValid = AccessData and AccessData.UIUnlockRuleId and PageJumpUtils:IsValidAccess(AccessData.UIUnlockRuleId)
            local bSuccess,JumpToPage = PageJumpUtils:CreateJumpToShopAccess(ShopItemData.ItemType,"Shop",ShopItemData.TypeId)
            if IsShopAccessValid and bSuccess and JumpToPage then
                JumpToPage()
                return
            end	
        end	
    end
    Utils.ScreenPrint("发型表对应的商品Id可能没配对,麻烦策划检查一下")
end

function M:OnCharHairChanged(Ret,CharUuid, AppearanceIndex, HairId)
    self:BlockAllUIInput(false)
    if(not ErrorCode:Check(Ret))then
        return
    end
    self:ResetTarget()
    if(self.CurrentHairContent)then
        ArmoryUtils:SetItemSelectTag(self.CurrentHairContent,false)
    end
    self.CurrentHairContent = self.HairMap[HairId]
    ArmoryUtils:SetItemSelectTag(self.CurrentHairContent,true)
    self:UpdateFunctionBtn(self.CurrentHairContent,self.CurrentHairContent)
end

function M:OnHairItemClicked(Content)
    local SelectedContent = self.HairMap[self.SelectedHairId]
    if(Content == SelectedContent)then
        return
    end
    self:SelectHairByContent(Content)
end

function M:SelectHairById(HairId)
    HairId = HairId or self.CurrentHairContent.HairId
    self:SelectHairByContent(self.HairMap[HairId])
end

function M:SelectHairByContent(Content)
    if(not Content)then return end
    local SelectedContent = self.HairMap[self.SelectedHairId]
    ArmoryUtils:SetItemIsSelected(SelectedContent,false)
    SelectedContent = Content
    ArmoryUtils:SetItemIsSelected(SelectedContent,true)
    self:UpdateHairDetails(Content)
end

function M:UpdateHairDetails(Content)
    if(not Content)then
        return
    end

    if(Content.HairId ~= self.SelectedHairId)then
        if(not self:IsAnimationPlaying(self.In))then
            self:PlayAnimation(self.Change)
        end
    end
    self.Panel_Buy:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.SelectedHairId = Content.HairId
    if(Content.Name  and Content.Name ~= "")then
        self:HideAllInfoExceptButton(false)
    else
        self:HideAllInfoExceptButton(true)
    end
    if Content.Rarity and self.NameFont[Content.Rarity] and self[self.NameFont[Content.Rarity]] then
        self.Text_Name:SetFont(self[self.NameFont[Content.Rarity]])
    end
    self.Text_Name:SetText(Content.Name)
    self.Text_Info:SetText(Content.Text)
    
    self.Text_SkinName_World:SetText(Content.Name_World)
    self.Image_Element:SetVisibility(ESlateVisibility.Collapsed)
    self.Text_Char_None:SetVisibility(ESlateVisibility.Collapsed)
    self.Tag_Quality:SetVisibility(ESlateVisibility.Collapsed)
    local AccessoryIconPath = ArmoryUtils:GetCharNoneAccessoryIconPaths()[CommonConst.DataType.Hair]
    if AccessoryIconPath then
        local AccessoryIcon = LoadObject(AccessoryIconPath)
        self.Image_Element:SetBrushResourceObject(AccessoryIcon)
        self.Image_Element:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    if Content.CharName then
        self.Text_CharName:SetText(Content.CharName)
    else
        self.Text_CharName:SetText("")
    end
    if Content.NotOwned then
        self.Text_Char_None:SetText(GText("UI_SkinPreview_CharNotOwned"))
        self.Text_Char_None:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    if Content.Rarity and (Content.Name or Content.Text) then
        self.Tag_Quality:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Tag_Quality:Init(Content.Rarity)
    end
    self.Panel_Video:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:UpdateFunctionBtn(Content,self.CurrentHairContent)
    self:UpdateActorAppearance(self.SelectedSkinId,self.SelectedHairId)
    if(Content.RedDotType and not self.NoReddot)then
        ArmoryUtils:SetItemReddotRead(Content,true)
    end
end

--endregion 角色发型

--region 角色配饰

---初始化角色配饰界面
function M:InitCharAccessory()
    self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
    self.Mask_Tab:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:CreateConstVariable()
    self:CreateCharAccessoryTabInfo()
    self:CreateCharAccessoryContents(self.Target,self.SelectedSkinId,{
        OnContentCreated = self.OnAccessoryContentCreated
    })
    local Avatar = GWorld:GetAvatar()
    for _, AccessoryId in pairs(Avatar.CharAccessorys) do
        self:CheckCharAccessoryContentReddot(AccessoryId)
    end
    rawset(self.NoneAccessory,"Icon",UIUtils.GetNoneAccessoryIconPath())
    self:CreateCurrentCharAccessoryContent(self.Target)
    self:CharAccessoryJumpTo()
    self:AddAccessoryTabReddotListen()
end

---角色配饰跳转逻辑
function M:CharAccessoryJumpTo()
    local AccessoryId,AccessoryType = self.JumpToAccessoryId, self.JumpToCharAccessoryType
    local Content = self.Map_AccessoryContents[AccessoryId]
    if(Content)then
        local AccessoryTab = self.AccessoryTabsMap[Content.AccessoryType]
        if(AccessoryTab)then
            self.Tab_Accessory:SelectTab(AccessoryTab.Idx)
            return
        end
    else
        local AccessoryTab = self.AccessoryTabsMap[AccessoryType]
        if(AccessoryTab)then
            self.Tab_Accessory:SelectTab(AccessoryTab.Idx)
            return
        end
    end
    self.Tab_Accessory:SelectTab(1)
end

---创建角色配饰Tab
function M:CreateCharAccessoryTabInfo(Recreate)
    if(rawget(self,"IsAccessoryTabInited") and not Recreate)then
        return
    end
    rawset(self,"IsAccessoryTabInited",true)
    rawset(self,"CurrentAccessoryTabIdx",nil)
    rawset(self,"AccessoryTabsMap",{})
    rawset(self,"AccessoryTabsArray",{})
    for i, value in ipairs(self.AccessoryTypes) do
        local Tab = {
                    Owner = self,
                    AccessoryType = value,
                    Text = "",
                    Idx = i,
                    IconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_"..value..".T_Tab_Fashion_"..value}
        self.AccessoryTabsMap[Tab.AccessoryType] = Tab
        table.insert(self.AccessoryTabsArray,Tab)
        self:OnAccessoryTabContentCreated(Tab)
    end
    rawset(self,"TabConfigData",{
        ChildWidgetName = "TabSubIconItem",
        Tabs = self.AccessoryTabsArray,
        SoundFunc = function(self)
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_sort_tab", nil, nil)
        end,
        SoundFuncReceiver = self,
    })
    self.Tab_Accessory:Init(self.TabConfigData)
    self.Tab_Accessory:BindEventOnTabSelected(self,self.OnCharAccessoryTabClicked)
end

function M:OnAccessoryTabContentCreated(Content)
end

function M:GetDefaultCharAccessoryIds()
    if(not rawget(self,"DefaultCharAccessoryIds"))then
        rawset(self,"DefaultCharAccessoryIds",ArmoryUtils:GetDefaultCharAccessoryIds())
    end
    return self.DefaultCharAccessoryIds
end

---创建角色配饰数据 
function M:CreateCharAccessoryContents(Char,SkinId,Params)
    Params = Params or {}
    -- 配饰数据需要根据皮肤创建，暂时每次重新创建
    -- if(rawget(self,"IsAccessoryContentsCreated") and not Params.bRecreate)then
    --     return
    -- end
    local OnContentCreated = Params.OnContentCreated or function() end
    rawset(self,"IsAccessoryContentsCreated",true)
    rawset(self,"CurrentContent",nil)
    rawset(self,"ComparedContent",nil)
    rawset(self,"NoneAccessory",NewObject(UIUtils.GetCommonItemContentClass()))
    rawset(self.NoneAccessory,"Id",self.NoneAccessoryId)
    rawset(self.NoneAccessory,"AccessoryId",self.NoneAccessoryId)
    rawset(self.NoneAccessory,"Parent",self)
    rawset(self.NoneAccessory,"ItemType",CommonConst.DataType.CharAccessory)
    OnContentCreated(self,self.NoneAccessory)
    self.BP_AccessoryContents:Clear()
    self.BP_AccessoryContents:Add(self.NoneAccessory)
    rawset(self,"Map_AccessoryContents",{})
    local Avatar = GWorld:GetAvatar()
    for AccessoryId, Data in pairs(DataMgr.CharAccessory) do
        if(Avatar:IsCharAccessoryExist(AccessoryId) or UIUtils.ShouldDisplayItem(CommonConst.DataType.CharAccessory,AccessoryId))then
            local Content = self:CreateCharAccessoryContent(Data)
            if(Content)then
                Content.SoundDataName = "CharAccessory"
                self.BP_AccessoryContents:Add(Content)
                self.Map_AccessoryContents[AccessoryId] = Content
                OnContentCreated(self,Content)
            end
        end
    end
    rawset(self,"PartMeshAccessory",nil)
    local AppearanceSuit = Char:GetAppearance()
    local PartMeshId,PartMeshType = Char:GetPartMeshAccessoryInfo(SkinId)
    for Id, Data in pairs(DataMgr.CharPartMesh) do
        if(UIUtils.ShouldDisplayItem("CharPartMesh",Id))then
            local Content = self:CreateCharAccessoryContent(Data)
            if(Content)then
                rawset(Content,"bAllowCustom",false)
                rawset(Content,"SoundDataName","CharPartMesh")
                self.BP_AccessoryContents:Add(Content)
                self.Map_AccessoryContents[Data.AccessoryId] = Content
                if(PartMeshType and PartMeshType == Content.AccessoryType)then
                    rawset(self,"PartMeshAccessory",Content)
                    
                end
                OnContentCreated(self,Content)
            end
        end
    end

    for _, AccessoryId in pairs(Avatar.CharAccessorys) do
        local Content = self.Map_AccessoryContents[AccessoryId]
        if Content then
            Content.IsHide = nil
            Content.LockType = nil
        end
    end
    if(rawget(self,"PartMeshAccessory"))then
        rawset(self.PartMeshAccessory,"IsSelect",false)
        rawset(self.PartMeshAccessory,"bSelectTag",false)
        local AccessoryId = AppearanceSuit.Accessory[CommonConst.NewCharAccessoryTypes[self.PartMeshAccessory.AccessoryType]]
        if(AccessoryId <= 0)then
            rawset(self.PartMeshAccessory,"bSelectTag",true)
        end
        local Skin = Char:GetSkin(SkinId or AppearanceSuit.SkinId,Avatar)
        if(Skin)then
            rawset(self.PartMeshAccessory,"LockType",nil)
        else
            rawset(self.PartMeshAccessory,"LockType",2)
        end
    end
end

--创建各部位当前穿戴的配饰对应的变量
function M:CreateCurrentCharAccessoryContent(Char)
    local AppearanceSuit = Char:GetAppearance()
    local CharAccessory = AppearanceSuit.Accessory
    for _, AccessoryType in ipairs(self.AccessoryTypes) do
        local AccessoryTypeIndex = CommonConst.NewCharAccessoryTypes[AccessoryType]
        if(AccessoryTypeIndex)then
            local AccessoryId = CharAccessory[AccessoryTypeIndex] or -1
            if(AccessoryId == self.NoneAccessoryId)then
                self[AccessoryType .. "Content"] = self.NoneAccessory
            else
                self[AccessoryType .. "Content"] = self.Map_AccessoryContents[AccessoryId]
            end
        end
    end
    if(self.PartMeshAccessory and self.PartMeshAccessory.bSelectTag)then
        self[self.PartMeshAccessory.AccessoryType .. "Content"] = self.PartMeshAccessory
    end
    for _, AccessoryType in ipairs(self.AccessoryTypes) do
        if(self[AccessoryType .. "Content"])then
            self[AccessoryType .. "Content"].bSelectTag = true
        end
    end
end

function M:CheckCharAccessoryContentReddot(AccessoryId)
    if(self.NoReddot)then
        return
    end
    local Content = self.Map_AccessoryContents[AccessoryId]
    if not(Content)then return end
    local CharAccessoryData = DataMgr.CharAccessory[AccessoryId]
    --检查配饰是否显示红点
    if(CharAccessoryData and CharAccessoryData.AccessoryType)then
        local NodeName = CommonConst.DataType.CharAccessory..CharAccessoryData.AccessoryType
        for _, _SkinId in ipairs(CharAccessoryData.Skin or {""}) do
            if ReddotManager.GetTreeNode(NodeName.._SkinId) then
                local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName.._SkinId)
                Content.RedDotType = (CacheDetail[AccessoryId]==1) and UIConst.RedDotType.NewRedDot
                if Content.RedDotType then
                    if(self.AccessoryTabsMap[CharAccessoryData.AccessoryType])then
                        self.AccessoryTabsMap[CharAccessoryData.AccessoryType].IsNew = true
                    end
                    break
                end
            end
        end
    end
end

--检查MVP是否显示红点
function M:CheckMVPContentReddot(AccessoryId)
    if(self.NoReddot)then
        return
    end
    local Content = self.Map_MVPContents[AccessoryId]
    if not(Content)then return end
    local CharAccessoryData = DataMgr.CharAccessory[AccessoryId]
    if(CharAccessoryData and CharAccessoryData.AccessoryType == CommonConst.CharAccessoryTypes.MVP)then
        local NodeName = CommonConst.DataType.CharAccessory..CharAccessoryData.AccessoryType
        for _, _SkinId in ipairs(CharAccessoryData.Skin or {""}) do
            if ReddotManager.GetTreeNode(NodeName.._SkinId) then
                local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName.._SkinId)
                Content.RedDotType = (CacheDetail[AccessoryId]==1) and UIConst.RedDotType.NewRedDot
            end
        end
    end
end

function M:CreateCharAccessoryContent(Data)
    if(Data.AccessoryType)then
        local DefaultCharAccessoryIds = self:GetDefaultCharAccessoryIds()
        if(Data.AccessoryId == DefaultCharAccessoryIds)then
            return
        end
        local bCreateContent = true
        if(Data.Skin)then
            bCreateContent = false
            local SkinId = self.SelectedSkinId
            for _, Id in ipairs(Data.Skin) do
                if(Id == SkinId)then
                    bCreateContent = true
                    break
                end
            end
        end
        if(bCreateContent)then
            local Obj = NewObject(UIUtils.GetCommonItemContentClass())
            rawset(Obj,"ItemType",CommonConst.DataType.CharAccessory)
            rawset(Obj,"Icon",Data.Icon or "")
            if(Data.AccessoryType == CommonConst.CharAccessoryTypes.MVP)then
                --临时处理
                if(Data.AccessoryId == 31002)then
                    rawset(Obj,"Icon","Texture2D'/Game/UI/Texture/Dynamic/Image/SettlementAction/T_SettlementAction_02.T_SettlementAction_02'")
                elseif(Data.AccessoryId == 31001)then
                    rawset(Obj,"Icon","Texture2D'/Game/UI/Texture/Dynamic/Image/SettlementAction/T_SettlementAction_01.T_SettlementAction_01'")
                end
            end
            rawset(Obj,"Id",Data.AccessoryId)
            rawset(Obj,"AccessoryId",Data.AccessoryId)
            rawset(Obj,"SortPriority",Data.SortPriority or 0)
            rawset(Obj,"IsHide",Data.IsHide)
            rawset(Obj,"LockType",2)
            rawset(Obj,"Rarity",Data.Rarity or 0)
            rawset(Obj,"bSelectTag",false)
            rawset(Obj,"IsSelect",false)
            rawset(Obj,"AccessoryType",Data.AccessoryType)
            rawset(Obj,"UnlockOptionText",GText(Data.UnlockOption or ""))
            rawset(Obj,"Parent",self)
            local CustomOffset = DataMgr.CustomOffset[Data.AccessoryType]
            rawset(Obj,"bAllowCustom",not Data.IsForbidCustom and CustomOffset and CustomOffset.AllowCustom)
            return Obj
        end
    end
end

---监听Tab红点
function M:AddAccessoryTabReddotListen()
    if(self.NoReddot)then
        return
    end
    self:RemoveAccessoryTabReddotListen()
    local SkinId = self.SelectedSkinId
    if not self.TabNodeNames then self.TabNodeNames = {} end
    for AccessoryType, Tab in pairs(self.AccessoryTabsMap) do
        local NodeName = AccessoryType
        local LeafNodes = {}
        local LeafNodeName = CommonConst.DataType.CharAccessory..AccessoryType
        LeafNodes[LeafNodeName] = ReddotManager.GetTreeNode(LeafNodeName) and 1 or nil
        LeafNodeName = LeafNodeName..SkinId
        LeafNodes[LeafNodeName] = ReddotManager.GetTreeNode(LeafNodeName) and 1 or nil
        if not self.TabNodeNames[NodeName] and not IsEmptyTable(LeafNodes) then
            ReddotManager.AddListener(NodeName, self, function(self, Count)
                Tab.IsNew = Count>0
                if(Tab.UI)then
                    Tab.UI:SetReddot(Tab.IsNew)
                end
                self:UpdateTopTabReddot()
            end,LeafNodes)
            self.TabNodeNames[NodeName] = 1
        end
    end
end

function M:RemoveAccessoryTabReddotListen()
    if(self.NoReddot)then
        return
    end
    for NodeName,_ in pairs(self.TabNodeNames or {}) do
        ReddotManager.RemoveListener(NodeName, self)
    end
    self.TabNodeNames = nil
end

function M:SetCurrentTabItemsReddotsRead()
    if(self.NoReddot)then
        return
    end
    if(self.FilteredContents)then
        for key, Content in pairs(self.FilteredContents) do
            if(Content.RedDotType)then
                ArmoryUtils:SetItemReddotRead(Content,true)
            end
        end
    end
end

function M:OnCharAccessoryTabClicked(TabWidget)
    local Tab = self.AccessoryTabsArray[TabWidget.Idx]
    -- if(Tab.Idx == self.CurrentAccessoryTabIdx)then
    --     return
    -- end
    if(self.ActorController)then
        self.ActorController:ResetActorRotation()
        if(self.HidePlayerAccessoryTypes[Tab.AccessoryType])then
            self.ActorController:HidePlayerActor(self.UIName,true)
        else
            self.ActorController:HidePlayerActor(self.UIName,false)
        end
    end
    self:RecoverAccessory()
    self:SetCurrentTabItemsReddotsRead()
    self.CurrentAccessoryTabIdx = Tab.Idx
    self.CurrentAccessoryTabWidget = TabWidget

    self.NoneAccessory.bSelectTag = false
    self.NoneAccessory.IsSelect = false
    self.NoneAccessory.AccessoryType = Tab.AccessoryType
    local DefaultCharAccessoryIds = self:GetDefaultCharAccessoryIds()
    self.NoneAccessory.Id = DefaultCharAccessoryIds[Tab.AccessoryType] or self.NoneAccessoryId
    self.NoneAccessory.AccessoryId = self.NoneAccessory.Id
    self.CurrentContent = self.NoneAccessory
    if(self.ComparedContent)then
        self.ComparedContent.IsSelect = false
    end
    self.ComparedContent = nil

    self:InitAccessoryListCommon()

    self.JumpToAccessoryId = nil
    self.JumpToCharAccessoryType = nil
    self.CurrentContent.bSelectTag = true
    self.ComparedContent = self.ComparedContent or self.CurrentContent
    self.CurrentContent.IsSelect = true
    self:SelectAccessoryItem(self.ComparedContent)
    if(self.NoneAccessory.SelfWidget)then
        self.NoneAccessory.SelfWidget:OnListItemObjectSet(self.NoneAccessory)
    end
    self.List_Accessory:BP_ScrollItemIntoView(self.ComparedContent)
end

function M:RecoverAccessory(Params)
    if(self.Type ~= CommonConst.ArmoryType.Char)then
        return
    end
    self.ActorController:DestoryCreature(CommonConst.CharAccessoryTypes.FX_Dead)
    self.ActorController:StopPlayerFX()
    self.ActorController:StopPlayerMontage(Params)
    self.ActorController:DestoryPlayerMeleeWeapon()
    if(not self.ComparedContent or self.ComparedContent == self.CurrentContent)then
        return
    end
    local AccessoryType = self.ComparedContent.AccessoryType
    if(self.FXAccessoryTypes[AccessoryType] and not self.AttachableFXAccessoryTypes[AccessoryType])then
        return
    end
    self.ActorController:ChangeCharAccessory(self.CurrentContent.AccessoryId,AccessoryType,
                                            self:GetCurrentAccessoryTransformOffset(self.AppearanceSuitIndex,self.CurrentContent.AccessoryId))
end

function M:SelectAccessoryItem(Content)
    if(self.Type ~= CommonConst.ArmoryType.Char)then
        return
    end
    self.ActorController:StopPlayerFX()
    self.ActorController:StopPlayerMontage()
    local AccessoryType = Content.AccessoryType
    if(self.FXAccessoryTypes[AccessoryType])then
        self.ActorController:ShowPlayerFXAccessory(Content.AccessoryId,AccessoryType)
        if(self.AttachableFXAccessoryTypes[AccessoryType])then
            self.ActorController:ChangeCharAccessory(Content.AccessoryId,AccessoryType,
                                                    self:GetAccessoryTransformOffset(Content))
        end
    else
        self.ActorController:ChangeCharAccessory(Content.AccessoryId,AccessoryType,
                                            self:GetAccessoryTransformOffset(Content))
    end
end

function M:Replay(Content)
    if(self.Type ~= CommonConst.ArmoryType.Char)then
        return
    end
    self.ActorController:StopPlayerFX()
    self.ActorController:StopPlayerMontage()
    local AccessoryType = Content.AccessoryType
    if(self.FXAccessoryTypes[AccessoryType])then
        self.ActorController:ShowPlayerFXAccessory(Content.AccessoryId,AccessoryType)
    end
end

---角色配饰发RPC
function M:OnCharAccessoryConfirmBtnClicked()
    if(not self.ComparedContent)then
        return
    end
    if(self.ComparedContent.LockType)then
        return
    end
    self:BlockAllUIInput(true)
    local Avatar = GWorld:GetAvatar()
    if(self.ComparedContent == self.NoneAccessory)then
        if(self.CurrentContent == self.PartMeshAccessory)then
            Avatar:SetCharSkinShowPart(self.Target.Uuid, self.SelectedSkinId, false)
        else
            Avatar:RemoveCharAppearanceAccessory(self.Target.Uuid, self.AppearanceSuitIndex, self.CurrentContent.AccessoryId)
        end
    else
        if(self.ComparedContent == self.PartMeshAccessory)then
            Avatar:SetCharSkinShowPart(self.Target.Uuid, self.SelectedSkinId, true)
        else
            self:CreateComparedAccessoryCustomOffset(self.ComparedContent)
            local CustomParams = self:CreateCustomParamsByComparedOffset()
            Avatar:SetCharAppearanceAccessory(self.Target.Uuid, self.AppearanceSuitIndex, self.ComparedContent.AccessoryId,CustomParams)
        end
    end
end

--region 角色配饰服务器回调

---服务器装备/移除配饰
function M:OnCharAccessoryChanged(Ret,CharUuid, AppearanceIndex, AccessoryId,CustomParams)
    self:BlockAllUIInput(false)
    if not ErrorCode:Check(Ret) then
        return
    end
    local Avatar = GWorld:GetAvatar()
    self.Target = Avatar.Chars[CharUuid]
    self:OnEquipedAccessoryContentChanged()
    if(rawget(self,"bAccessoryCustomOpened"))then
        self:OnCharAccessoryCustomChanged()
    else
        self:UpdateAccessoryDetails(self.CurrentContent)
    end
end

---服务器切换配饰套装
function M:OnCharAppearanceChanged(Ret, CharUuid, CharAccessoryIndex)
    self:BlockAllUIInput(false)
    if(Ret == ErrorCode.RET_SUCCESS)then
        local Avatar = GWorld:GetAvatar()
        self.Target = Avatar.Chars[CharUuid]
    else
        UIManager(self):ShowError(Ret,1.5)
    end
end

---服务器显隐披风
function M:OnCharShowPartMesh(Ret, CharUuid, CharAccessorySuitIndex, IsShowPartMesh)
    self:BlockAllUIInput(false)
    if(Ret == ErrorCode.RET_SUCCESS)then
        local Avatar = GWorld:GetAvatar()
        self.Target = Avatar.Chars[CharUuid]
        self:OnEquipedAccessoryContentChanged()
        self:UpdateAccessoryDetails(self.CurrentContent)
    else
        UIManager(self):ShowError(Ret, 1.5)
    end
end

--endregion

--endregion 角色配饰

--region 结算动作(MVP)

function M:InitCharMVP()
    self.WidgetSwitcher_State:SetActiveWidgetIndex(2)
    self:CreateConstVariable()
    --MVP属于配饰，先创建配饰数据
    self:CreateCharAccessoryContents(self.Target,self.SelectedSkinId,{
        OnContentCreated = self.OnMVPContentCreated,
    })
    self:CreateMVPContentMap()
    for key, value in pairs(self.Map_MVPContents) do
        self:CheckMVPContentReddot(key)
    end
    self:InityMVPNoneAccessory()
    if(self.ComparedContent)then
        rawset(self.ComparedContent,"IsSelect",false)
    end
    rawset(self,"ComparedContent",nil)
    rawset(self,"CurrentContent",self.NoneAccessory)
    self:CreateCurrentMVPContent(self.Target)
    self:InitMVPList()

    self.JumpToAccessoryId = nil
    self.JumpToCharAccessoryType = nil
    rawset(self,"ComparedContent",rawget(self,"ComparedContent") or rawget(self,"CurrentContent"))
    rawset(self.CurrentContent,"bSelectTag",true)
    rawset(self.CurrentContent,"IsSelect",true)
    self:SelectAccessoryItem(self.ComparedContent)
    self:UpdateAccessoryDetails(self.ComparedContent)
    self.List_SettlementAction:BP_ScrollItemIntoView(self.ComparedContent)
end

function M:CreateCurrentMVPContent(Char)
    local AppearanceSuit = Char:GetAppearance()
    local CharAccessory = AppearanceSuit.Accessory
    local AccessoryTypeIndex = CommonConst.NewCharAccessoryTypes.MVP
    if(AccessoryTypeIndex)then
        local AccessoryId = CharAccessory[AccessoryTypeIndex] or -1
        if(AccessoryId == self.NoneAccessoryId)then
            self.MVPContent = self.NoneAccessory
        else
            self.MVPContent = self.Map_MVPContents[AccessoryId]
        end
    end
    if(self.MVPContent)then
        self.MVPContent.bSelectTag = true
    end
end

function M:CreateMVPContentMap()
    if(not rawget(self,"Map_AccessoryContents"))then
        return
    end
    rawset(self,"Map_MVPContents",{})
    for AccessoryId,Content in pairs(self.Map_AccessoryContents) do
        if(Content.AccessoryType == CommonConst.CharAccessoryTypes.MVP)then
            self.Map_MVPContents[AccessoryId] = Content
            rawset(Content,"Owner",self)
            rawset(Content,"OnClicked",self.OnMVPItemClicked)
        end
    end
end

function M:InityMVPNoneAccessory()
    rawset(self.NoneAccessory,"Icon","Texture2D'/Game/UI/Texture/Dynamic/Image/SettlementAction/T_SettlementAction_Default.T_SettlementAction_Default'")
    rawset(self.NoneAccessory,"bSelectTag",false)
    rawset(self.NoneAccessory,"IsSelect",false)
    rawset(self.NoneAccessory,"AccessoryType",CommonConst.CharAccessoryTypes.MVP)
    rawset(self.NoneAccessory,"Owner",self)
    rawset(self.NoneAccessory,"OnClicked",self.OnMVPItemClicked)
    local DefaultCharAccessoryIds = self:GetDefaultCharAccessoryIds()
    rawset(self.NoneAccessory,"Id",DefaultCharAccessoryIds[CommonConst.CharAccessoryTypes.MVP] or self.NoneAccessoryId)
    rawset(self.NoneAccessory,"AccessoryId",self.NoneAccessory.Id)
end

function M:InitMVPList()
    local MVPContents = {}
    for _, Content in pairs(self.Map_MVPContents) do
        table.insert(MVPContents,Content)
    end
    self.List_SettlementAction:ClearListItems()
    table.sort(MVPContents,function(a,b)
        if (a.LockType and b.LockType) or (not a.LockType and not b.LockType) then
            if(a.SortPriority == b.SortPriority)then
                return a.AccessoryId > b.AccessoryId
            end
            return a.SortPriority > b.SortPriority
        else
            return b.LockType
        end
    end)
    self.List_SettlementAction:SetVisibility(UIConst.VisibilityOp.Visible)
    --默认动作放在前面
    self.List_SettlementAction:AddItem(self.NoneAccessory)
    if(self.JumpToAccessoryId and self.Map_MVPContents[self.JumpToAccessoryId])then
        self.ComparedContent = self.Map_MVPContents[self.JumpToAccessoryId]
    end
    for _, Content in ipairs(MVPContents) do
        if(Content.bSelectTag)then
            self.CurrentContent = Content
        end
        self.List_SettlementAction:AddItem(Content)
    end
    self.List_SettlementAction:RequestFillEmptyContent()
    self.List_SettlementAction:RequestPlayEntriesAnim()
end

function M:OnMVPItemClicked(Content)
    if(self.ComparedContent and self.ComparedContent == Content)then
        return
    end
    ArmoryUtils:SetItemIsSelected(self.ComparedContent,false)
    self.ComparedContent = Content
    ArmoryUtils:SetItemIsSelected(self.ComparedContent,true)
    self:SelectAccessoryItem(Content)
    self:UpdateAccessoryDetails(Content)
end

--endregion 结算动作(MVP)

function M:OnTopTabSelected(TabWidget,Content)
    if(self.Type ~= CommonConst.ArmoryType.Char)then
        return
    end
    self:BlockAllUIInput(true,"OnTopTabSelected")
    self:AddTimer(0.3,function()
        self:BlockAllUIInput(false,"OnTopTabSelected")
    end)
    self.EnableDrag = true
    self.EnableMouseWheel = true
    self.ActorController:TryDestroySequenceActorController()
    if(self.CurrentTopTabIdx == self.SkinTabIdx)then
        rawset(self,"bRecoverAppearanceWhenDestruct",true)
        if(self.IsAccessoryContentsCreated)then
            self:RecoverAccessory()
        end
        self:InitCharSkin()
    elseif(self.CurrentTopTabIdx == self.HairTabIdx)then
        rawset(self,"bRecoverAppearanceWhenDestruct",true)
        if(self.IsAccessoryContentsCreated)then
            self:RecoverAccessory()
        end
        self:InitCharHair()
    elseif(self.CurrentTopTabIdx == self.AccessoryTabIdx)then
        if(self.ActorController)then
            self.ActorController:UpdateCameraPPSetting({IsAccessoryPPSetting = true})
        end
        self.Tab_Accessory:SetVisibility(UIConst.VisibilityOp.Visible)
        self:InitCharAccessory()
    elseif(self.CurrentTopTabIdx == self.MVPTabIdx)then
        self.EnableDrag = false
        self.EnableMouseWheel = false
        if(self.IsAccessoryContentsCreated)then
            self:RecoverAccessory()
        end
        self.ActorController:ResetActorRotation()
        self.ActorController:TryCreateSequenceActorController()
        self:InitCharMVP()
    end
    self:UpdateCharAppearanceResourceBar()
end

function M:UpdateCharAppearanceResourceBar()
    if(self.IsPreviewMode)then
        return
    end
    if(self.CurrentTopTabIdx == self.MVPTabIdx)then
        for _, Content in pairs(self.Map_MVPContents or {}) do
            local ShopItemId = self:GetShopItemByAccessoryId(Content.AccessoryId)
            local ShopItemData = DataMgr.ShopItem[ShopItemId]
            local PriceType = ShopItemData and ShopItemData.PriceType
            if(PriceType)then
                self.Tab_Skin:OverrideTopResource({PriceType},true)
                break
            end
        end
    else
        self.Tab_Skin:OverrideTopResource(nil,true)
    end
end

local RemoveUnsupportedAccessories = function(SkinId,AccessorySuit)
    local UnsupportedAcceesoryIdx = {}
    for key, value in pairs(AccessorySuit) do
        if(not ArmoryUtils:IsSkinSupportAccessory(SkinId,value))then
            table.insert(UnsupportedAcceesoryIdx,key)
        end
    end
    for index, value in ipairs(UnsupportedAcceesoryIdx) do
        AccessorySuit[value] = nil
    end
end

---更新皮肤模型
function M:UpdateActorAppearance(SkinId,HairId)
    if(self.Type ~= CommonConst.ArmoryType.Char)then
        return
    end
    if(not self.ActorController)then
        return
    end
    local Avatar = ArmoryUtils:GetAvatar()
    local AppearanceSuitInfo = self.Target:DumpAppearanceSuit(Avatar,self.AppearanceSuitIndex)
    AppearanceSuitInfo.SkinId = SkinId or AppearanceSuitInfo.SkinId
    AppearanceSuitInfo.HairId = HairId or AppearanceSuitInfo.HairId
    AppearanceSuitInfo.SkinLevel = self.SelectedSkinLevel or AppearanceSuitInfo.SkinLevel
    AppearanceSuitInfo.Colors = self.Target:DumpColors(Avatar,AppearanceSuitInfo.SkinId)
    AppearanceSuitInfo.HairColors = self.Target:DumpHairColors(Avatar,AppearanceSuitInfo.HairId)
    AppearanceSuitInfo.AccessorySuit = AppearanceSuitInfo.AccessorySuit or {}
    --暂时卸下当前皮肤不支持的配饰
    RemoveUnsupportedAccessories(AppearanceSuitInfo.SkinId,AppearanceSuitInfo.AccessorySuit)
    --换皮肤同时更新配饰偏移
    self.ActorController:ChangeCharAppearance(AppearanceSuitInfo)

    if(self.LastCharSkinId and AppearanceSuitInfo.SkinId ~= self.LastCharSkinId)then
        self.ActorController.DelayFrame = 30
        self.ActorController.bPlaySameMontage = true
    else
        self.ActorController.bPlaySameMontage = false
    end
    self.LastCharSkinId = SkinId
    self.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Char,"","","")
end

function M:OnLeftConfirmBtnClicked()
    if(self.Type ~= CommonConst.ArmoryType.Char)then
        return
    end
    if(self.CurrentTopTabIdx == self.SkinTabIdx) then
        if (self.CurrentLockContent) then
            if self.UseParamsInOpt then
                self:OnCharSkinGoToShopBtnClicked()
            end
        end
    elseif(self.CurrentTopTabIdx == self.HairTabIdx)then
        if (self.CurrentLockContent) then
            if self.UseParamsInOpt then
                self:OnCharHairGoToShopBtnClicked()
            end
        end
    end
end

function M:OnRightConfirmBtnClicked()
    if(self.Type ~= CommonConst.ArmoryType.Char)then
        return
    end
    if(self.CurrentTopTabIdx == self.SkinTabIdx) then
        if (self.CurrentLockContent) then
            if self.UseParamsInOpt then
                self:OnCharSkinGotoBagBtnClicked()
            else
                self:OnCharSkinGoToShopBtnClicked()
            end
        else
            self:OnCharSkinConfirmBtnClicked()
        end
    elseif(self.CurrentTopTabIdx == self.HairTabIdx)then
        if (self.CurrentLockContent) then
            if self.UseParamsInOpt then
                self:OnCharHairGotoBagBtnClicked()
            else
                self:OnCharHairGoToShopBtnClicked()
            end
        else
            self:OnCharHairConfirmBtnClicked()
        end
    else
        self:OnCharAccessoryConfirmBtnClicked()
    end
end

-- region 皮肤升级

-- 隐藏皮肤升级控件
function M:HideSkinLevelUpWidget()
    self.Panel_LevelUp:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

-- 刷新皮肤等级信息
function M:RefreshSkinLevelInfo(SkinId)
    local IsDisplay = DataMgr.SkinUpgrade and DataMgr.SkinUpgrade[SkinId]
    if not IsDisplay then
        self.Panel_LevelUp:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Btn_Function.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
        return
    end

    local IsLocked = function(CurLevel)
        if self.IsPreviewMode then
            return false
        end

        local Skin = self:GetOwnedSkinData(SkinId)
        if not Skin then return true end

        return (CurLevel > Skin.Level)
    end

    self.Panel_LevelUp:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    local MaxLevel = self.WB_LevelUp:GetChildrenCount()

    for Index = 1, MaxLevel do
        local LevelUpWidget = self["WBP_Armory_Skin_LevelUp_" .. Index]
        if LevelUpWidget then
            local Params = {
                Level = Index,
                IsLocked = IsLocked(Index),
                IsShowReddot = ArmoryUtils:CanSkinUpgrade(SkinId, Index),
                Obj = self,
                ClickedCallback = self.OnLevelUpWidgetClicked
            }
            LevelUpWidget:InitContent(Params)
        end
    end

    self.SelectedSkinLevel = 1
    local Skin = self:GetOwnedSkinData(SkinId)
    local IsOwned = (Skin ~= nil)
    if IsOwned then  -- 已拥有
        local IsEquiped = self:IsEquipedSelectedSkin()
        self.SelectedSkinLevel = IsEquiped and Skin.SelectedLevel or Skin.Level
    end

    self["WBP_Armory_Skin_LevelUp_" .. self.SelectedSkinLevel]:PlaySelectedAnimation()
end

-- 已拥有的皮肤对应ID的皮肤数据
function M:GetOwnedSkinData(SkinId)
    local Avatar = GWorld:GetAvatar()
    if(not Avatar or not Avatar.CommonChars)then
        return
    end

    local CommonChar = Avatar.CommonChars[self.Target.CharId]
    local Skin = CommonChar and CommonChar.OwnedSkins[SkinId]
    return Skin
end

-- 是否装配选中皮肤
function M:IsEquipedSelectedSkin()
    local Char = self.Target
    if not (self.SelectedSkinId or Char) then
        return false
    end

    local Skin = self:GetOwnedSkinData(self.SelectedSkinId)
    local AppearanceSuit = Char:GetAppearance()
    if not (Skin or AppearanceSuit) then
        return false 
    end
    return (AppearanceSuit.SkinId == self.SelectedSkinId)
end

-- 皮肤等级按钮点击事件
function M:OnLevelUpWidgetClicked(Level)
    if Level == self.SelectedSkinLevel then
        return
    end

    -- 恢复上个控件恢复Normal动画
    local LastLevelUpWidget = self["WBP_Armory_Skin_LevelUp_" .. self.SelectedSkinLevel]
    if LastLevelUpWidget then
        LastLevelUpWidget:PlayNormalAnimation()
    end

    -- 更新数据
    self.SelectedSkinLevel = Level
    self.Panel_Buy:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Function.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:UpdateActorAppearance(self.SelectedSkinId,self.SelectedHairId)

    -- 已装配
    local SkinData = self:GetOwnedSkinData(self.SelectedSkinId)
    local IsEquiped = SkinData and self:IsEquipedSelectedSkin()
    if IsEquiped and (SkinData.SelectedLevel == Level) then  -- 装配皮肤选中等级
        self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Equipped)
        self.Text_Desc:SetText(GText("UI_Accessory_Equipped"))
        return
    end

    -- 已拥有，未装配
    local SkinData = self:GetOwnedSkinData(self.SelectedSkinId)
    local IsOwned = SkinData and (SkinData.Level >= Level)
    if IsOwned then
        self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Unequipped)
        self.Btn_Function:ForbidBtn(false)
        self.Btn_Function:SetText(GText("UI_Accessory_Equip"))
        self.Btn_Function:BindSingleEventOnClicked(self,self.OnRightConfirmBtnClicked)
        self.RightConfirmBtnFunc = self.OnRightConfirmBtnClicked
        return
    else  -- 未拥有
        -- 使用之前的装配逻辑，无需显示代币
        if Level == 1 then
            local SelectedContent = self.SkinMap[self.SelectedSkinId]
            self:UpdateFunctionBtn(SelectedContent, self.CurrentSkinContent)
            return
        end

        -- 未解锁上一等级
        if not SkinData or (SkinData.Level < Level - 1) then
            self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Locked)
            self.Text_Lock:SetText(GText("UI_Skin_Upgrade_Locked"))
            self.Btn_Function:ForbidBtn(true)
            return
        end

        -- 代币数量和红色
        local SkinLevelUpData = DataMgr.SkinUpgrade[self.SelectedSkinId][Level]
        self.Panel_Buy:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.WBP_Com_Cost:InitContent({
                CostText = GText("UI_Skin_Upgrade_Cost"),
                ResourceId = SkinLevelUpData.UnlockCurrency,
                Numerator = SkinLevelUpData.UnlockAmount,
        })

        -- 升级判断
        self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Unequipped)
        self.Btn_Function:SetText(GText("UI_FUNC_LEVELUP"))  -- 升级
        local Avatar = GWorld:GetAvatar()
        local OwnedAmount = Avatar:GetResourceNum(SkinLevelUpData.UnlockCurrency)

        if (OwnedAmount < SkinLevelUpData.UnlockAmount) then   -- 代币不足
            self.Btn_Function:ForbidBtn(true)
            return
        else  -- 代币充足，皮肤升级
            self.Btn_Function:ForbidBtn(false)
            self.Btn_Function:BindSingleEventOnClicked(self,self.OnUpgradeSkinLevelClicked)
            self.RightConfirmBtnFunc = self.OnUpgradeSkinLevelClicked  -- 手柄调用
            self.Btn_Function.Reddot:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)  -- 显示红点
        end
    end
end

-- 切换皮肤等级
function M:ChangeCharSkinLevel()
    if not self.SelectedSkinLevel then
        return
    end

    -- 皮肤不可以升级
    local SKinUpData = DataMgr.SkinUpgrade[self.SelectedSkinId]
    if not SKinUpData then
        return
    end

    -- 未拥有改皮肤
    local SkinData = self:GetOwnedSkinData(self.SelectedSkinId)
    if (not SkinData) then
        return
    end

    if (SkinData.SelectedLevel == self.SelectedSkinLevel) then
        return
    end

    local Callback = function(Ret, SkinId, NewLevel)
        self:BlockAllUIInput(false, "SwitchCharSkinSelectedLevel")
        if (not ErrorCode:Check(Ret)) then
            return
        end

        -- 按钮状态更新
        self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Equipped)
        self.Text_Desc:SetText(GText("UI_Accessory_Equipped"))

        -- 更新角标
        local SelectedContent = self.SkinMap[SkinId]
        if (SelectedContent and SelectedContent.Widget) then
            SelectedContent.Widget:UpdateSKinLevel(NewLevel)
        end
    end

    self:BlockAllUIInput(true, "SwitchCharSkinSelectedLevel")
    local Avatar = GWorld:GetAvatar()
    Avatar:SwitchCharSkinSelectedLevel(Callback, self.SelectedSkinId, self.SelectedSkinLevel)
end

-- 升级皮肤事件
function M:OnUpgradeSkinLevelClicked()
    if not (self.SelectedSkinId or self.SelectedSkinLevel) then
        return
    end

    local UpgradeDatas = DataMgr.SkinUpgrade[self.SelectedSkinId]
    local SelectedUpgradeData = UpgradeDatas and UpgradeDatas[self.SelectedSkinLevel]
    if not SelectedUpgradeData then
        return
    end

    local Callback = function(ErrCode)
        self:BlockAllUIInput(false)
        if (not ErrorCode:Check(ErrCode)) and self then
            return
        end
        -- 刷新解锁状态
        local CurLevelUpWidget = self["WBP_Armory_Skin_LevelUp_" .. self.SelectedSkinLevel]
        CurLevelUpWidget:UnlockLevel()
        -- 隐藏代币
        self.Panel_Buy:SetVisibility(UIConst.VisibilityOp.Collapsed)
        -- 切换为装配按钮
        self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Unequipped)
        self.Btn_Function:ForbidBtn(false)
        self.Btn_Function:SetText(GText("UI_Accessory_Equip"))
        self.Btn_Function:BindSingleEventOnClicked(self,self.OnRightConfirmBtnClicked)
        self.RightConfirmBtnFunc = self.OnRightConfirmBtnClicked
        self:RefreshLevelUpReddot()
    end

    local Avatar = GWorld:GetAvatar()
    local Params = {
        ShortText = "UI_Skin_Upgrade_Confirm",
        ItemList = {{
            ItemId = SelectedUpgradeData.UnlockCurrency,
            ItemType = CommonConst.ItemType.Resource,
            ItemNum = Avatar:GetResourceNum(SelectedUpgradeData.UnlockCurrency),
            ItemNeed = SelectedUpgradeData.UnlockAmount,
        }},
        RightCallbackFunction = function(Obj, Data)  -- 购买
            self:BlockAllUIInput(true,"SP_DisplayOnly")
            Avatar:UpCharSkinLevel(Callback, self.SelectedSkinId, self.SelectedSkinLevel)
        end,
    }

    UIManager(self):ShowCommonPopupUI(100342, Params, self)
end

-- 刷新皮肤升级红点
function M:RefreshLevelUpReddot()
    if self.NoReddot then
        return
    end

    local CharId = self.Target.CharId
    local NodeName = CommonConst.DataType.Char .. CommonConst.DataType.Skin.."LevelUp"..CharId
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
    if not CacheDetail then
        return
    end

    local Avatar = GWorld:GetAvatar()
    local IsShowTabReddot = false

    for SkinId, _ in pairs(CacheDetail) do
        local UpgradeData = DataMgr.SkinUpgrade[SkinId]
        local SkinData = self:GetOwnedSkinData(SkinId)
        if not UpgradeData or not SkinData then
            goto continue
        end

        local CurLevel = SkinData.Level
        local NewLevel = CurLevel

        if (CurLevel < MAX_SKIN_LEVEL) then  -- Level未达最大级别
            local NextLevel = CurLevel + 1
            local ResourceId = UpgradeData[NextLevel].UnlockCurrency
            local UnlockAmount = UpgradeData[NextLevel].UnlockAmount
            local ResourceNum  = Avatar:GetResourceNum(ResourceId)
            NewLevel = (ResourceNum >= UnlockAmount) and NextLevel or NewLevel
        end
        
        local IsShowReddot = (NewLevel > CurLevel)
        -- Tab
        if IsShowReddot then
            IsShowTabReddot = true
        end
        -- 皮肤Item
        local CurContent = self.SkinMap[SkinId]
        if CurContent and CurContent.Widget then
            rawset(CurContent,"Upgradeable", (not IsShowReddot))
            CurContent.Widget:SetReddot(IsShowReddot and UIConst.RedDotType.CommonRedDot)
        end
        -- 皮肤等级
        self["WBP_Armory_Skin_LevelUp_" .. NewLevel]:SetReddotState(IsShowReddot)
        -- 装配按钮
        if (NewLevel == self.SelectedSkinLevel) then
            if IsShowReddot then
                self.Btn_Function.Reddot:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            else
                self.Btn_Function.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
            end
        end

        CacheDetail[SkinId] = SkinData.Level
        ::continue::
    end

    local SkinLevelUpNode = ReddotManager.GetTreeNode(NodeName)
    local SkinLevelUpCount = SkinLevelUpNode and SkinLevelUpNode.Count or 0
    if (IsShowTabReddot) then
        if SkinLevelUpCount == 0 then
            ReddotManager.IncreaseLeafNodeCount(NodeName)
        end
    else
        ReddotManager.ClearLeafNodeCount(NodeName)
    end
end

-- endregion 皮肤升级

function M:Destruct()
    self:RemoveAccessoryTabReddotListen()
end

return M