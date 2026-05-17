local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"

local M = {}

function M:Construct()
    self:AddDispatcher(EventID.OnWeaponAccessoryChanged, self, self.OnWeaponAccessoryChanged)
    self:AddDispatcher(EventID.OnWeaponSkinChanged, self, self.OnWeaponSkinChanged)

    self:AddDispatcher(EventID.OnWeaponColorsChanged,self,self.OnWeaponColorsChanged)

    self:AddDispatcher(EventID.OnNewWeaponSkinObtained, self, self.OnNewWeaponSkinObtained)
    self:AddDispatcher(EventID.OnNewWeaponAccessoryObtained, self, self.OnNewWeaponAccessoryObtained)
end

function M:OnWeaponColorsChanged()
    self:ResetTarget()
end

function M:OnNewWeaponAccessoryObtained(AccessoryId)
    self:AddTimer(0.01,function()
        self:OnNewAccessoryObtained(AccessoryId)
    end)
end

function M:OnNewWeaponSkinObtained(SkinId)
    self:AddTimer(0.01,function()
        self:OnNewSkinObtained(SkinId)
    end)
end

function M:AddTopTabReddotListen()
    if(self.NoReddot)then
        return
    end
    if(self.Type ~= CommonConst.ArmoryType.Weapon)then
        return
    end
    local SetTopTabReddot = function(TabIdx,IsNew)
        local Content = self.TopTabs[TabIdx]
        Content.IsNew = IsNew
        if IsValid(Content.UI) then
            Content.UI:SetReddot(Content.IsNew)
        end
    end
    self:AddWeaponAppearanceReddotListen(function()
        local NewSkinCount = 0
        local Data = DataMgr.Weapon[self.Target.WeaponId]
        if(Data and Data.SkinApplicationType)then
            for _, value in pairs(Data.SkinApplicationType) do
                local NodeName = CommonConst.DataType.WeaponSkin .. (value or "")
                local NewSkinNode = ReddotManager.GetTreeNode(NodeName)
                NewSkinCount = NewSkinCount + (NewSkinNode and NewSkinNode.Count or 0)
            end
        end

        local NewAccessoryNode = ReddotManager.GetTreeNode(CommonConst.DataType.WeaponAccessory)
        local NewAccessoryCount = NewAccessoryNode and NewAccessoryNode.Count or 0
        SetTopTabReddot(1,NewSkinCount > 0)
        SetTopTabReddot(2,NewAccessoryCount > 0)
    end, self.Target.WeaponId)
end

function M:RemoveTopTabReddotListen()
    if(self.NoReddot)then
        return
    end
    self:RemoveWeaponAppearanceReddotListen()
end

---初始化武器皮肤界面
function M:InitWeaponSkin()
    local SkinId = self.JumpToSkinId or self.SelectedSkinId
    self.JumpToSkinId = nil
    self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
    self:InitWeaponSkinList()
    self:SelectSkinById(SkinId)
end

function M:InitWeaponSkinList()
    if(self.bWeaponSkinListInited)then
        return
    end
    self.bWeaponSkinListInited = true
    self.SkinMap = {}
    self.SkinArray = {}
    local Avatar = GWorld:GetAvatar()
    local CurWeaponId = self.Target.WeaponId
    local CurSkin = self.Target:GetCurrentSkin() or {}
    local CurSkinId = CurSkin.SkinId or CurWeaponId
    local LeafNodeNamePre = CommonConst.DataType.WeaponSkin
    for SkinId, Data in pairs(DataMgr.WeaponSkin) do
        if(not UIUtils.CanApplyWeaponSkin(CurWeaponId,Data.ApplicationType))then
            goto continue
        end
        if(not Avatar.OwnedWeaponSkins[SkinId] and not UIUtils.ShouldDisplayItem(CommonConst.DataType.WeaponSkin,SkinId))then
            goto continue
        end
        local CacheDetail = {}
        if(not self.NoReddot)then
            CacheDetail = ReddotManager.GetLeafNodeCacheDetail(LeafNodeNamePre .. (Data.ApplicationType or "")) or {}
        end
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        rawset(Obj,"SkinId",Data.SkinID)
        rawset(Obj,"ItemId",Data.SkinID)
        rawset(Obj,"IconPath",Data.LongIcon)
        rawset(Obj,"Name",GText(Data.Name))
        rawset(Obj,"Name_World",EnText(Data.Name))
        rawset(Obj,"Rarity",Data.Rarity)
        rawset(Obj,"Text",GText(Data.Dec))
        rawset(Obj,"Owner",self)
        rawset(Obj,"OnClicked",self.OnSkinItemClicked)
        rawset(Obj,"bDyeable",true)
        rawset(Obj,"RedDotType",CacheDetail[SkinId]==1 and UIConst.RedDotType.NewRedDot)
        rawset(Obj,"ItemType",CommonConst.DataType.WeaponSkin)
        rawset(Obj,"IsTargetUnowned",self.IsTargetUnowned)
        rawset(Obj,"SkinId",Data.SkinID)
        if(Avatar.OwnedWeaponSkins[SkinId])then
            rawset(Obj,"LockType",false)
        else
            rawset(Obj,"LockType",SkinId ~= CurWeaponId)
        end
        local WeaponTypeInfo = DataMgr.WeaponTypeContrast[Data.ApplicationType]
        if WeaponTypeInfo then
            rawset(Obj,"CharName",string.format(GText("UI_SkinPreview_WeaponType"), GText(WeaponTypeInfo.WeaponTagTextmap)))
            rawset(Obj,"WeaponTypeIcon",WeaponTypeInfo.Icon)
        end
        self.SkinMap[Obj.SkinId] = Obj
        table.insert(self.SkinArray,Obj)
        self:OnSkinContentCreated(Obj)
		::continue::
    end
    table.sort(self.SkinArray,function(a,b)
        return a.SkinId < b.SkinId
    end)
    local WeaponData = self.Target:Data()
    --默认皮肤放前面
    local DefaultSkin = NewObject(UIUtils.GetCommonItemContentClass())
    rawset(DefaultSkin,"SkinId",CurWeaponId)
    rawset(DefaultSkin,"IconPath",WeaponData.LongIcon or WeaponData.GachaIcon)
    rawset(DefaultSkin,"Owner",self)
    rawset(DefaultSkin,"OnClicked",self.OnSkinItemClicked)
    rawset(DefaultSkin,"bDyeable",true)
    rawset(DefaultSkin,"IsTargetUnowned",self.IsTargetUnowned)
    self.SkinMap[DefaultSkin.SkinId] = DefaultSkin
    table.insert(self.SkinArray,1,DefaultSkin)
    self:OnSkinContentCreated(DefaultSkin)
    if(CurSkinId and self.SkinMap[CurSkinId])then
        self.CurrentSkinContent = self.SkinMap[CurSkinId]
        self.CurrentSkinContent.IsEquipped = true
    end
    self:InitSkinList()
end

---服务器武器换皮肤
function M:OnWeaponSkinChanged(Ret,WeaponUuid,SkinId)
    self:BlockAllUIInput(false)
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


function M:OnWeaponSkinConfirmBtnClicked()
    if(not self.SelectedSkinId or self.SelectedSkinId <= 0)then
        return
    end
    self:BlockAllUIInput(true)
    local Avatar = GWorld:GetAvatar()
    Avatar:ChangeWeaponAppearanceSkin(self.Target.Uuid,self.SelectedSkinId)
end

--region 武器配饰

---初始化武器配饰界面
function M:InitWeaponAccessory()
    self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
    self:CreateWeaponAccessoryContents(self.Target)
    if(self.ActorController)then
        self.ActorController:ResetActorRotation()
    end
    self.NoneAccessory.bSelectTag = false
    self.NoneAccessory.IsSelect = false
    self.CurrentContent = self.NoneAccessory
    if(#self.Array_WeaponAccessoryContents <= 0)then
        --self.Empty:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.List_Accessory:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self:UpdateAccessoryDetails(self.CurrentContent)
        return
    end
    if(self.ComparedContent)then
        self.ComparedContent.IsSelect = false
        if(self.ComparedContent.SelfWidget)then
            self.ComparedContent.SelfWidget:SetSelected(self.ComparedContent.IsSelect)
        end
    end
    self.ComparedContent = nil
    self:InitWeaponAccessoryList()
    self:SelectAccessoryItem(self.ComparedContent)
    self.List_Accessory:BP_ScrollItemIntoView(self.ComparedContent)
    self:AddWeaponAccessoryTabReddotListen()
end

---监听左边Tab红点
function M:AddWeaponAccessoryTabReddotListen()
    if(self.NoReddot)then
        return
    end
    self:RemoveWeaponAccessoryTabReddotListen()
    if not self.TabNodeNames then self.TabNodeNames = {} end
    for AccessoryType, Tab in pairs(self.AccessoryTabsMap or {}) do
        local NodeName = AccessoryType
        local LeafNodes = {}
        local LeafNodeName = CommonConst.DataType.WeaponAccessory..AccessoryType
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

function M:RemoveWeaponAccessoryTabReddotListen()
    if(self.NoReddot)then
        return
    end
    for NodeName,_ in pairs(self.TabNodeNames or {}) do
        ReddotManager.RemoveListener(NodeName, self)
    end
    self.TabNodeNames = nil
end

local AddWeaponAccessoryContent = function(self,AccessoryId)
    local Data = DataMgr.WeaponAccessory[AccessoryId]
    local Content = self:CreateWeaponAccessoryContent(Data)
    if(Content)then
        Content.SoundDataName = "WeaponAccessory"
        self.BP_AccessoryContents:Add(Content)
        self.Map_AccessoryContents[AccessoryId] = Content
        table.insert(self.Array_WeaponAccessoryContents,Content)
        self:CheckWeaponAccessoryContentReddot(AccessoryId)
        self:OnAccessoryContentCreated(Content)
    end
end

function M:CheckWeaponAccessoryContentReddot(AccessoryId)
    if(self.NoReddot)then
        return
    end
    local Content = self.Map_AccessoryContents[AccessoryId]
    if(not Content)then
        return
    end
    local CacheDetail = {}
    local ReddotName = CommonConst.DataType.WeaponAccessory
    if ReddotManager.GetTreeNode(ReddotName) then
        CacheDetail = ReddotManager.GetLeafNodeCacheDetail(CommonConst.DataType.WeaponAccessory) or {}
    end
    Content.RedDotType = (CacheDetail[AccessoryId]==1) and UIConst.RedDotType.NewRedDot
end

function M:CreateWeaponAccessoryContents(Weapon,bRecreate)
    if(self.IsAccessoryContentsCreated and not bRecreate)then
        return
    end
    self.IsAccessoryContentsCreated = true
    self.CurrentContent = nil
    self.ComparedContent = nil
    self.NoneAccessory = NewObject(UIUtils.GetCommonItemContentClass())
    self.NoneAccessory.Id = -1
    self.NoneAccessory.Parent = self
    self.NoneAccessory.Icon = UIUtils.GetNoneAccessoryIconPath()
    self.NoneAccessory.ItemType = CommonConst.DataType.WeaponAccessory
    self.BP_AccessoryContents:Clear()
    self.BP_AccessoryContents:Add(self.NoneAccessory)
    self:OnAccessoryContentCreated(self.NoneAccessory)
    self.Map_AccessoryContents = {}
    self.Array_WeaponAccessoryContents = {}
    local Avatar = GWorld:GetAvatar()
    for AccessoryId, Data in pairs(DataMgr.WeaponAccessory) do
        if(Avatar:IsWeaponAccessoryExist(AccessoryId) or UIUtils.ShouldDisplayItem(CommonConst.DataType.WeaponAccessory,AccessoryId))then
            AddWeaponAccessoryContent(self,AccessoryId)
        end
    end
    for key, AccessoryId in pairs(Avatar.WeaponAccessorys) do
        local Content = self.Map_AccessoryContents[AccessoryId]
        if(Content)then
            Content.IsHide = nil
            Content.LockType = nil
        end
    end
    
    local AppearanceSuit = Weapon:GetAppearance()
    for _, AccessoryId in pairs(AppearanceSuit.Accessory) do
        local Content = self.Map_AccessoryContents[AccessoryId]
        if(Content)then
            Content.bSelectTag = true
        end
    end
end

function M:OnAccessoryContentCreated(Content)
end

local CreateStanceFXTag2ModId = function(self)
    if(rawget(self,"StanceFXTag2ModId"))then
        return
    end
    local TargetModApplicationTypes = {}
    for _, value in pairs(self.Target.ModApplicationType or {}) do
        if not DataMgr.ModTag[value] then goto continue end
        TargetModApplicationTypes[value] = true
        ::continue::
    end
    rawset(self,"StanceFXTag2ModId",{})
    for ModId, value in pairs(DataMgr.Mod) do
        if(TargetModApplicationTypes[value.ApplicationType] and value.ModActivateSkills)then
            for SkillId, StanceFXTag in pairs(value.ModActivateSkills) do
                self.StanceFXTag2ModId[StanceFXTag] = ModId
            end
        end
    end
end

function M:CreateWeaponAccessoryContent(Data)
    if(Data.BeginTime)then
        local Time = TimeUtils.NowTime()
        if(Time < Data.BeginTime:GetTime())then
            return
        end
    end
    if(Data.StanceFXTag)then
        CreateStanceFXTag2ModId(self)
        if(not self.StanceFXTag2ModId[tonumber(Data.StanceFXTag)])then
            return
        end
    end
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    rawset(Obj,"ItemType",CommonConst.DataType.WeaponAccessory)
    rawset(Obj,"Icon",Data.Icon or "")
    rawset(Obj,"Id",Data.WeaponAccessoryId)
    rawset(Obj,"AccessoryId",Data.WeaponAccessoryId)
    rawset(Obj,"SortPriority",Data.SortPriority or 0)
    rawset(Obj,"LockType",2)
    rawset(Obj,"IsHide",Data.IsHide)
    rawset(Obj,"IsSelect",false)
    rawset(Obj,"UnlockOptionText",GText(Data.UnlockOption or ""))
    rawset(Obj,"Parent",self)
    rawset(Obj,"Rarity",Data.Rarity or 0)
    rawset(Obj,"AccessoryType",Data.StanceFXType)
    rawset(Obj,"StanceFXTag",tonumber(Data.StanceFXTag))
    if(rawget(self,"StanceFXTag2ModId"))then
        rawset(Obj,"ModId",self.StanceFXTag2ModId[rawget(Obj,"StanceFXTag")])
    end
    return Obj
end

function M:InitWeaponAccessoryList()
    self.List_Accessory:ClearListItems()
    table.sort(self.Array_WeaponAccessoryContents,function(a,b)
        if (a.LockType and b.LockType) or (not a.LockType and not b.LockType) then
            if(a.SortPriority == b.SortPriority)then
                return a.AccessoryId > b.AccessoryId
            end
            return a.SortPriority > b.SortPriority
        else
            return b.LockType
        end
    end)
    self.List_Accessory:AddItem(self.NoneAccessory)
    self.List_Accessory:SetVisibility(UIConst.VisibilityOp.Visible)
    self.FilteredContents = {}
    for _, Content in ipairs(self.Array_WeaponAccessoryContents) do
        if(not Content.IsHide)then
            if(self.JumpToAccessoryId)then
                if(self.JumpToAccessoryId == Content.AccessoryId)then
                    self.ComparedContent = Content
                end
            end
            if(Content.bSelectTag)then
                self.CurrentContent = Content
            end
            self.List_Accessory:AddItem(Content)
            table.insert(self.FilteredContents,Content)
        end
    end
    self.JumpToAccessoryId = nil
    self.CurrentContent.IsSelect = true
    self.ComparedContent = self.ComparedContent or self.CurrentContent
    self.ComparedContent.IsSelect = true
end

function M:OnWeaponSkinGoToShopBtnClicked()
    if(not self.SelectedSkinId or self.SelectedSkinId <= 0)then
        return
    end
    local SkinInfo = DataMgr.WeaponSkin[self.SelectedSkinId]
    if not SkinInfo then return end
    local ItemIds = SkinInfo.GoShopTypeId
    if not ItemIds or not next(ItemIds) then return end
    for _, ItemId in ipairs(ItemIds) do
        local ShopItemData = DataMgr.ShopItem[ItemId]
        if ShopItemData then
            local bSuccess,JumpToPage = PageJumpUtils:CreateJumpToShopAccess(ShopItemData.ItemType,"Shop",ShopItemData.TypeId)
            if bSuccess and JumpToPage then
                JumpToPage()
                return
            end	
        end	
    end
    Utils.ScreenPrint("皮肤表对应的商品Id可能没配对,麻烦策划检查一下")
end

function M:SelectAccessoryItem(Content)
    if(self.Type ~= CommonConst.ArmoryType.Weapon)then
        return
    end
    self.ActorController:ChangeWeaponAccessory(Content.AccessoryId,Content.AccessoryType)
end

function M:RecoverAccessory()
    if(self.Type ~= CommonConst.ArmoryType.Weapon)then
        return
    end
    if(not self.ComparedContent or self.ComparedContent == self.CurrentContent)then
        return
    end
    self.ActorController:ChangeWeaponAccessory(self.CurrentContent.AccessoryId,self.CurrentContent.AccessoryType)
end

function M:OnWeaponAccessoryConfirmBtnClicked()
    -- if(not self.ComparedContent)then
    --     return
    -- end
    -- if(self.ComparedContent.LockType)then
    --     return
    -- end
    self:BlockAllUIInput(true)
    local Avatar = GWorld:GetAvatar()
    local ComparedAccessoryId = self.ComparedContent.AccessoryId
    if(ComparedAccessoryId and ComparedAccessoryId > 0 and ComparedAccessoryId ~= self.NoneAccessoryId)then
        Avatar:ChangeWeaponAppearanceAccessory(self.Target.Uuid,self.ComparedContent.AccessoryId)
    else
        Avatar:RemoveWeaponAppearanceAccessory(self.Target.Uuid,self.CurrentContent.AccessoryId)
    end
end

---服务器改变武器配饰
function M:OnWeaponAccessoryChanged(Ret,WeaponUuid,AccessoryId)
    self:BlockAllUIInput(false)
    if(not ErrorCode:Check(Ret))then
        return
    end
    self:ResetTarget()
    self:OnEquipedAccessoryContentChanged()
    self:UpdateAccessoryDetails(self.CurrentContent)
end

--endregion 武器配饰

--region 武器架势特效
local CreateWeaponStanceFXConstVariable = function(self)
    if(rawget(self,"bWeaponStanceFXConstVariableCreated"))then
        return
    end
    rawset(self,"bWeaponStanceFXConstVariableCreated",true)
    rawset(self,"AccessoryTypes",{
        CommonConst.WeaponAccessoryTypes.RunAttack,
        CommonConst.WeaponAccessoryTypes.HeavyAttack,
        CommonConst.WeaponAccessoryTypes.FallAttack,
        CommonConst.WeaponAccessoryTypes.SlideAttack,
    })
end

function M:InitWeaponStanceFX()
    self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
    CreateWeaponStanceFXConstVariable(self)
    self:CreateWeaponStanceFXTabInfo()
    self:CreateWeaponAccessoryContents(self.Target)
    self:CreateWeaponStanceFXContents()
    if(self.ActorController)then
        self.ActorController:ResetActorRotation()
    end
    self.NoneAccessory.bSelectTag = false
    self.NoneAccessory.IsSelect = false
    self.CurrentContent = self.NoneAccessory
    if(next(self.Map_StanceFXContents) == nil)then
        --self.Empty:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.List_Accessory:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self:UpdateAccessoryDetails(self.CurrentContent)
        return
    end
    self:CreateCurrentWeaponAccessoryContent(self.Target)
    self:WeaponStanceFXJumpTo()
    self:AddStanceFXTabReddotListen()
end

---监听武器架势Tab红点
function M:AddStanceFXTabReddotListen()
    if(self.NoReddot)then
        return
    end
    self:RemoveStanceFXTabReddotListen()
    if not self.TabNodeNames then self.TabNodeNames = {} end
    for AccessoryType, Tab in pairs(self.AccessoryTabsMap) do
        local NodeName = AccessoryType
        local LeafNodes = {}
        local LeafNodeName = CommonConst.DataType.WeaponAccessory..AccessoryType
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

function M:RemoveStanceFXTabReddotListen()
    if(self.NoReddot)then
        return
    end
    for NodeName,_ in pairs(self.TabNodeNames or {}) do
        ReddotManager.RemoveListener(NodeName, self)
    end
    self.TabNodeNames = nil
end

---武器架势特效跳转逻辑
function M:WeaponStanceFXJumpTo()
    local AccessoryId,AccessoryType = self.JumpToAccessoryId, self.JumpToWeaponAccessoryType
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

function M:CreateCurrentWeaponAccessoryContent(Target)
    local AppearanceSuit = Target:GetAppearance()
    local WeaponAccessory = AppearanceSuit.Accessory
    for _, AccessoryType in ipairs(self.AccessoryTypes) do
        local AccessoryTypeIndex = CommonConst.WeaponAccessoryTypeIndex[AccessoryType]
        if(AccessoryTypeIndex)then
            local AccessoryId = WeaponAccessory[AccessoryTypeIndex] or -1
            if(AccessoryId == self.NoneAccessoryId)then
                self[AccessoryType .. "Content"] = self.NoneAccessory
            else
                self[AccessoryType .. "Content"] = self.Map_AccessoryContents[AccessoryId]
            end
        end
    end
    for _, AccessoryType in ipairs(self.AccessoryTypes) do
        if(self[AccessoryType .. "Content"])then
            self[AccessoryType .. "Content"].bSelectTag = true
        end
    end
end

function M:CreateWeaponStanceFXTabInfo(Recreate)
    if(rawget(self,"IsStanceFXTabInited") and not Recreate)then
        return
    end
    rawset(self,"IsStanceFXTabInited",true)
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
    self.Tab_Accessory:BindEventOnTabSelected(self,self.OnWeaponStanceFXTabClicked)
end

function M:OnWeaponStanceFXTabClicked(TabWidget)
    local Tab = self.AccessoryTabsArray[TabWidget.Idx]
    if(self.ActorController)then
        self.ActorController:ResetActorRotation()
    end
    self.CurrentAccessoryTabIdx = Tab.Idx
    self.CurrentAccessoryTabWidget = TabWidget

    self.NoneAccessory.bSelectTag = false
    self.NoneAccessory.IsSelect = false
    self.NoneAccessory.AccessoryType = Tab.AccessoryType
    self.NoneAccessory.Id = self.NoneAccessoryId
    self.NoneAccessory.AccessoryId = self.NoneAccessory.Id
    self.CurrentContent = self.NoneAccessory
    if(self.ComparedContent)then
        self.ComparedContent.IsSelect = false
    end
    self.ComparedContent = nil

    self:InitAccessoryListCommon()

    self.JumpToAccessoryId = nil
    self.JumpToWeaponAccessoryType = nil
    self.CurrentContent.bSelectTag = true
    self.ComparedContent = self.ComparedContent or self.CurrentContent
    self.CurrentContent.IsSelect = true

    self:SelectAccessoryItem(self.ComparedContent)

    if(self.NoneAccessory.SelfWidget)then
        self.NoneAccessory.SelfWidget:OnListItemObjectSet(self.NoneAccessory)
    end
    self.List_Accessory:BP_ScrollItemIntoView(self.ComparedContent)
end

function M:CreateWeaponStanceFXContents()
    if(not rawget(self,"Map_AccessoryContents"))then
        return
    end
    rawset(self,"Map_StanceFXContents",{})
    for AccessoryId,Content in pairs(self.Map_AccessoryContents) do
        if(Content.AccessoryType and Content.AccessoryType ~= CommonConst.WeaponAccessoryTypes.Accessory)then
            self.Map_StanceFXContents[AccessoryId] = Content
            rawset(Content,"Owner",self)
            rawset(Content,"OnClicked",self.OnStanceFXItemClicked)
        end
    end
end

---更新武器架势信息
function M:UpdateWeaponStanceFXInfo(Content)
    if(not Content.StanceFXTag or not Content.ModId)then
        return
    end
    self.TextTitleMod:SetText(GText("适用魔之楔(未配表)"))
    local Params = {
        Parant = self,
        Target = self.Target,
        Type = self.Type,
        Tag = self.Tag,
        IsPreviewMode = self.IsPreviewMode or self.IsCharacterTrialMode or self.IsTargetUnowned,
        ModId = Content.ModId
    }
    self.WBP_Armory_SkinMod:Init(Params)
    self.Mod_Title_Line:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Mod_Content:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

--endregion 武器架势特效

function M:OnTopTabSelected(TabWidget,Content)
    if(self.Type ~= CommonConst.ArmoryType.Weapon)then
        return
    end
    if(self.CurrentTopTabIdx == self.SkinTabIdx)then
        rawset(self,"bRecoverAppearanceWhenDestruct",true)
        if(self.IsAccessoryContentsCreated)then
            self:RecoverAccessory()
        end
        self:InitWeaponSkin()
    elseif(self.CurrentTopTabIdx == self.WeaponStanceFXTabIdx)then
        if(self.IsAccessoryContentsCreated)then
            self:RecoverAccessory()
        end
        self.Mask_Tab:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self:InitWeaponStanceFX()
    else
        self.Tab_Accessory:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Mask_Tab:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self:InitWeaponAccessory()
    end
end

function M:UpdateActorAppearance(SkinId)
    if(self.Type ~= CommonConst.ArmoryType.Weapon)then
        return
    end
    SkinId = SkinId or (self.CurrentSkinContent and self.CurrentSkinContent.SkinId)
    if(not SkinId)then
        return
    end
    self:UpdateActorSkin(SkinId)
    self:UpdateActorColors(SkinId)
end

---更新皮肤模型
function M:UpdateActorSkin(SkinId)
    if(self.Type ~= CommonConst.ArmoryType.Weapon)then
        return
    end
    self.ActorController:ChangeWeaponSkin(SkinId)
end

---更新皮肤当前染色
function M:UpdateActorColors(SkinId)
    if(self.Type ~= CommonConst.ArmoryType.Weapon)then
        return
    end
    local ColorInfo = self.Target:DumpColors(SkinId)
    self.ActorController:ChangeWeaponColor(ColorInfo)
end

function M:OnRightConfirmBtnClicked()
    if(self.Type ~= CommonConst.ArmoryType.Weapon)then
        return
    end
    if(self.CurrentTopTabIdx == self.SkinTabIdx) and (not self.CurrentLockContent) then
        self:OnWeaponSkinConfirmBtnClicked()
    elseif (self.CurrentTopTabIdx == self.SkinTabIdx) and self.CurrentLockContent then
        self:OnWeaponSkinGoToShopBtnClicked()
    else
        self:OnWeaponAccessoryConfirmBtnClicked()
    end
end

function M:Destruct()
    self:RemoveAccessoryTabReddotListen()
end

return M