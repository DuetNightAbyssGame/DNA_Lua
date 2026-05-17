--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local SkillUtils = require "Utils.SkillUtils"
local UpgradeUtils = require "Utils.UpgradeUtils"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"

---@type WBP_Armory_Inron_P_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C",
                            "BluePrints.Common.DelayFrameComponent"})
M._components = {"BluePrints.UI.BP_EMUserWidgetUtils_C",}

function M:Construct()
    self:AddDispatcher(EventID.OnCharGradeLevelUp,self,self.OnCharGradeLevelUp)
    self:AddDispatcher(EventID.OnCharExtraGradeLevelUp,self,self.OnCharExtraGradeLevelUp)
    self:AddDispatcher(EventID.OnMenuClose,self,self.OnClickBtnFullClose)
    self.UnLockedText = GText("UI_UNLOCKED") --已解锁
    self.UnLockText = GText("UI_UNLOCK") --解锁
    self.bIsFocusable = true
    self.IsOpenDetails = false
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
    self:AddDispatcher(EventID.OnPurchaseShopItem, self, self.OnPurchaseShopItem)
end

function M:Init(Params)
    self.Params = Params
    self.Parent = Params.Parent
    self.Char = Params.Target
    self.Type = Params.Type
    self.Tag = Params.Tag
    self.IsPreviewMode = Params.IsPreviewMode or Params.IsTargetUnowned
    self._OnAddedToFocusPath = Params.OnAddedToFocusPath
    self._OnRemovedFromFocusPath = Params.OnRemovedFromFocusPath
    self.NewChar = false -- 切换了角色
    self.TotalMaxGradeLevel = tonumber(DataMgr.GlobalConstant.CharCardLevelMax.ConstantValue) + 1
    self:InitTraceMain()

    --self:InitNavigationRules()
end

function M:InitTraceMain()
    local Avatar = GWorld:GetAvatar()
    if(not Avatar)then
        return
    end
    local Char = self.Char
    if self.CharId and self.CharId ~= Char.CharId and not self.IsOpenDetails then
        self.NewChar = true
    end
    self.CharId = Char.CharId
    self.CharGradeLevel = Char.GradeLevel
    self.MaxGradeLevel = tonumber(DataMgr.GlobalConstant.CharCardLevelMax.ConstantValue)
    self.HasUltraGrade = Char:HasUltraGradeLevel()
    self.IsExtraGradeUnlocked = Char:IsExtraGradeLevelUnlocked()
    -- 有效的阶级等级（含Extra）
    self.EffectiveGradeLevel = Char:GetEffectiveGradeLevel()

    -- 根据属性变颜色
    self.Attribute = DataMgr.BattleChar[self.CharId].Attribute
    self.Line_Attr:SetColorAndOpacity(self[self.Attribute])
    self.Line_Attr_Sp:SetColorAndOpacity(self[self.Attribute])
    local BgTopAllChildren = self.Panel_BgTop:GetAllChildren():ToTable() or {}
    for index, value in ipairs(BgTopAllChildren) do
        value:SetColorAndOpacity(self[self.Attribute])
    end
    local BgBottomAllChildren = self.Panel_BgBottom:GetAllChildren():ToTable() or {}
    for index, value in ipairs(BgBottomAllChildren) do
        value:SetColorAndOpacity(self[self.Attribute])
    end
    local AllVXChildren = self.VX:GetAllChildren():ToTable() or {}
    for index, value in ipairs(AllVXChildren) do
        value:SetColorAndOpacity(self[self.Attribute .. "_VX"])
    end

    -- 处理前6级
    for i = 1,self.CharGradeLevel do
        if self['InronItem_'..i] then
            self['InronItem_'..i]:Init(self,i,false)
            if self.NewChar or not (self.Details and self.SelectTraceId and self.SelectTraceId == i or (self.LastFocusItem and self.LastFocusItem == self['InronItem_'..i] and not self['InronItem_'..i]:HasAnyUserFocus())) then
                self['InronItem_'..i]:SetNormalState()
            end
            self['InronItem_'..i].Num_Intron:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    end
    for j = self.CharGradeLevel + 1,self.MaxGradeLevel do
        if self['InronItem_'..j] then
            self['InronItem_'..j]:Init(self,j,true)
            if self.NewChar or not (self.Details and self.SelectTraceId and self.SelectTraceId == j or (self.LastFocusItem and self.LastFocusItem == self['InronItem_'..j] and not self['InronItem_'..j]:HasAnyUserFocus())) then
                self['InronItem_'..j]:SetNormalState()
            end
            self['InronItem_'..j].Num_Intron:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    end

    -- 处理第7级
    if self['InronItem_7'] then
        if self.HasUltraGrade then
            self['InronItem_7']:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            local IsLock7 = not self.IsExtraGradeUnlocked
            self['InronItem_7']:Init(self, 7, IsLock7)
            if self.NewChar or not (self.Details and self.SelectTraceId and self.SelectTraceId == 7 or (self.LastFocusItem and self.LastFocusItem == self['InronItem_7'] and not self['InronItem_7']:HasAnyUserFocus())) then
                self['InronItem_7']:SetNormalState()
            end
            self['InronItem_7'].Num_Intron:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.WS_Line:SetActiveWidgetIndex(1)
        else
            self['InronItem_7']:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.WS_Line:SetActiveWidgetIndex(0)
        end
    end

    -- 红点逻辑：前6级
    if self['InronItem_'..(self.CharGradeLevel + 1)] and (self.CharGradeLevel + 1) <= self.MaxGradeLevel then
        self['InronItem_'..(self.CharGradeLevel + 1)]:SetReddotState(self:CheckCharCanUpGradeLevel())
    end
    -- 红点逻辑：第7级
    if self.InronItem_7 and self.HasUltraGrade then
        if not self.IsExtraGradeUnlocked and self.CharGradeLevel >= self.MaxGradeLevel then
            self.InronItem_7:SetReddotState(self:CheckCharCanUpUltraGradeLevel())
        else
            self.InronItem_7:SetReddotState(false)
        end
    end

    -- 新增：第7级 New 标记
    if self.InronItem_7 and self.HasUltraGrade then
        local IsNewUltraGrade = self:CheckUltraGradeNewState()
        self.InronItem_7:SetNewState(IsNewUltraGrade)
    end

    -- 动态修改InronItem_6的导航规则：有第7级时，左/下导航到InronItem_7
    if self['InronItem_6'] then
        if self.HasUltraGrade and self['InronItem_7'] and self['InronItem_7']:GetVisibility() ~= UE4.ESlateVisibility.Collapsed then
            self['InronItem_6']:SetNavigationRuleExplicit(EUINavigation.Left, self['InronItem_7'])
            self['InronItem_6']:SetNavigationRuleExplicit(EUINavigation.Down, self['InronItem_7'])
            self['InronItem_7']:SetNavigationRuleExplicit(EUINavigation.Up, self.Parent.EMListView_SubTab)
        else
            -- 没有第7级时，左/下Escape
            self['InronItem_6']:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Escape)
            self['InronItem_6']:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Escape)
        end
    end

    for k = 1, self.TotalMaxGradeLevel do
        if self['InronItem_'..k] then
            self['InronItem_'..k]:PlayActivatableNormal()
        end
    end
    self.SelectTraceId = -1
    if self.LastFocusItem ~= nil and self.CurInputDeviceType == ECommonInputType.Gamepad and not self.IsOpenDetails and self.ShouldFocusLast then
        self.LastFocusItem:SetFocus()
        self.ShouldFocusLast = false
    end
end

--- 新增：检查第7级是否有未读的New标记
function M:CheckUltraGradeNewState()
    if self.IsPreviewMode then return false end
    if self.IsExtraGradeUnlocked then return false end
    local NodeName = DataMgr.ReddotNode.NewUltraGradeChar.Name
    local UltraNode = ReddotManager.GetTreeNode(NodeName)
    if not UltraNode or UltraNode.Count <= 0 then
        return false
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
    if not CacheDetail then
        return false
    end
    return CacheDetail[self.CharId] == 1
end

function M:LoadSkillDetailsUI()
    -- self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    local ArmoryMain = UIManager(self):GetArmoryUIObj()
    if(ArmoryMain and ArmoryMain.ActorController)then
        self.ActorController = ArmoryMain.ActorController
        self.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Char,nil,CommonConst.ArmoryType.Grade,"Detail")
    end
    self.Details = UIManager(self):LoadUINew("ArmoryTraceDetails", self, self.SelectTraceId, self.SelectMod)

    self:AddDelayFrameFunc(function()
        for i = 1, self.MaxGradeLevel do
            if self['InronItem_'..i] then
                self['InronItem_'..i].IsClick = false
                self['InronItem_'..i]:SetNormalState()
            end
        end
    end, 2, "PlayItemNormalAnim")
    
end

function M:OnTraceDetailsDestruct(SelectTraceId)
    local ArmoryMain = UIManager(self):GetArmoryUIObj()
    if(ArmoryMain)then
        ArmoryMain:SetVisibility(UIConst.VisibilityOp.Collapsed)
        ArmoryMain.Panel_SubUI:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    self.SelectTraceId = SelectTraceId
    self.DetailsClose = true
    self.Details = nil
    self.IsOpenDetails = false
    self.ShouldFocusLast = true
    if self['InronItem_'..self.SelectTraceId] then
        self.LastFocusItem = self['InronItem_'..self.SelectTraceId]
    end
end

function M:OnClickTraceItem(TraceId)
    if(self.IsOutAnimPlayed)then
        return
    end
    if self.SelectTraceId == TraceId then
        return
    end

    -- 新增：点击第7级时，标记7命New红点已读
    if TraceId == 7 and self.HasUltraGrade and not self.IsPreviewMode then
        local NodeName = DataMgr.ReddotNode.NewUltraGradeChar.Name
        local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
        if CacheDetail and CacheDetail[self.CharId] == 1 then
            ArmoryUtils:SetUltraGradeCharReddotRead(self.CharId)
            -- SetReddotRead 内部会减少节点 Count 并触发监听回调
            -- 从而自动刷新：InronItem_7 New → 溯源Tab New → 角色列表 New → 主Tab New
            if self.InronItem_7 then
                self.InronItem_7:SetNewState(false)
            end
            EventManager:FireEvent(EventID.OnCharExtraGradeItemClick, self.Char.Uuid)
        end
    end

    if not self.Details or self.Details.InFinished then
        -- 判断是否已解锁（前6级用GradeLevel，第7级用ExtraGradeLevel）
        local IsUnlocked = false
        if TraceId <= self.MaxGradeLevel then
            IsUnlocked = TraceId <= self.CharGradeLevel
        else
            IsUnlocked = self.IsExtraGradeUnlocked
        end

        if IsUnlocked then
            AudioManager(self):PlayUISound(self, "event:/ui/armory/suyuan_point_click", nil, nil)
        else
            AudioManager(self):PlayUISound(self, "event:/ui/armory/suyuan_point_click_unlock", nil, nil)
        end
    end

    if self['InronItem_'..self.SelectTraceId] then
        self['InronItem_'..self.SelectTraceId].IsClick = false
        self['InronItem_'..self.SelectTraceId]:SetNormalState()
        self['InronItem_'..self.SelectTraceId]:CollapseVX()
        self.LastFocusItem = self['InronItem_'..self.SelectTraceId]
    end
    self.SelectTraceId = TraceId

    -- 刷新前6级下一个待解锁的红点
    if self.SelectTraceId ~= self.CharGradeLevel + 1 then
        if self['InronItem_'..(self.CharGradeLevel + 1)] and (self.CharGradeLevel + 1) <= self.MaxGradeLevel then
            self['InronItem_'..(self.CharGradeLevel + 1)]:SetReddotState(self:CheckCharCanUpGradeLevel())
        end
    end
    -- 刷新第7级红点
    if self.SelectTraceId ~= 7 then
        if self['InronItem_7'] and self.HasUltraGrade and not self.IsExtraGradeUnlocked and self.CharGradeLevel >= self.MaxGradeLevel then
            self['InronItem_7']:SetReddotState(self:CheckCharCanUpUltraGradeLevel())
        end
    end

    self.SelectMod = 1
    if self.IsPreviewMode then
        -- 预览中
        self.SelectMod = 4
    elseif TraceId == 7 then
        -- 第7级特殊处理
        if self.IsExtraGradeUnlocked then
            self.SelectMod = 1   -- 已解锁
        else
            self.SelectMod = 2   -- 当前可解锁（需要前6级满）
            if self.CharGradeLevel < self.MaxGradeLevel then
                self.SelectMod = 3 -- 前置条件不满足
            end
        end
    elseif self.SelectTraceId <= self.CharGradeLevel then
        -- 已解锁的
        self.SelectMod = 1
    elseif self.SelectTraceId == self.CharGradeLevel + 1 then
        -- 当前的
        self.SelectMod = 2
    else
        -- 未解锁的
        self.SelectMod = 3
    end


    if self.IsOpenDetails and self.Details then
        self.Details:UpdateDetailInfo(self.SelectTraceId, self.SelectMod)
    else
        self:LoadSkillDetailsUI()
    end
end

function M:InitResourceNeeded()
    local Avatar = GWorld:GetAvatar()
    if(not Avatar)then
        return
    end
    local Char = self.Char
    local ResourceNeeded = {}
    local IsOrdered = false

    if self.SelectTraceId == 7 then
        -- 第7级从UltraCharCardLevelUp表读取，返回有序数组 {{Id=, Num=}, ...}
        ResourceNeeded = Char:CalculateCharUltraGradeLevelUpResources()
        IsOrdered = true
    else
        if DataMgr.CharCardLevelUp[Char.CharId] and DataMgr.CharCardLevelUp[Char.CharId][self.SelectTraceId - 1] then
            local Data = DataMgr.CharCardLevelUp[Char.CharId][self.SelectTraceId - 1]
            ResourceNeeded = Char:CalculateCharGradeLevelUpResources(Data)
        end
    end

    self.Details.HB_Item:ClearChildren()

    -- Type1:全部充足 Type2:碎片不足但月石充足 Type3:碎片不足且月石不足 Type4:未检索到碎片信息
    local ResType = 1
    local FirstResource1 = nil
    local FirstResource2 = nil

    -- 统一迭代器：有序数组用 ipairs，无序 table 用 pairs
    local function iterateResources(resources, isOrdered, callback)
        if isOrdered then
            for _, entry in ipairs(resources) do
                callback(entry.Id, entry.Num)
            end
        else
            for key, value in pairs(resources) do
                callback(key, value)
            end
        end
    end

    iterateResources(ResourceNeeded, IsOrdered, function(Key, Value)
        local Resource = Avatar.Resources[Key]
        local ResourceConf = DataMgr.Resource[Key]
        local TypeId2ShopItem = DataMgr.TypeId2ShopItem[CommonConst.DataType.Resource]
        local ShopItemId = TypeId2ShopItem and TypeId2ShopItem[Key] and TypeId2ShopItem[Key][1]
        local ShopItemData = ShopItemId and DataMgr.ShopItem[ShopItemId]
        local FakeContent = {
            Id = Key,
            Icon = ResourceConf.Icon,
            Count = Resource and Resource.Count or 0,
            ItemType = CommonConst.ItemType.Resource,
            Rarity = ResourceConf.Rarity,
            IsShowDetails = true,
            NeedCount = Value,
            ShopItemId = ShopItemId,
            CountTextWhite = true,
        }
        local Item = UIManager(self):_CreateWidgetNew("ComItemUniversalM")
        Item:BindEvents(self, {
            OnMenuOpenChanged = self.OnTipsOpenChanged,
        })
        Item.bIsFocusable = true
        self.Details.HB_Item:AddChild(Item)
        Item:Init(FakeContent)

        -- 计算当前材料的状态
        local CurType = 1
        local CurResource1 = FakeContent
        local CurResource2 = nil
        if FakeContent.Count < Value then
            local NeedNum = Value - FakeContent.Count
            local TypeId2ShopItem2 = DataMgr.TypeId2ShopItem[CommonConst.DataType.Resource]
            local ShopItemId2 = TypeId2ShopItem2 and TypeId2ShopItem2[Key] and TypeId2ShopItem2[Key][1]
            local ShopItemData2 = ShopItemId2 and DataMgr.ShopItem[ShopItemId2]
            if ShopItemData2 then
                local Resource2 = Avatar.Resources[ShopItemData2.PriceType] or {Count = 0}
                local NeedCount = ShopItemData2.Price * NeedNum
                local NeedContent = {
                    Id = ShopItemData2.PriceType,
                    Icon = DataMgr.Resource[ShopItemData2.PriceType].Icon,
                    ItemType = CommonConst.DataType.Resource,
                    Rarity = DataMgr.Resource[ShopItemData2.PriceType].Rarity,
                    Count = NeedCount,
                    ShopItemId = ShopItemId2,
                    Price = ShopItemData2.Price,
                    IsShowDetails = true,
                }
                CurResource2 = NeedContent
                if Resource2.Count >= NeedCount then
                    CurType = 2
                else
                    CurType = 3
                end
            else
                CurType = 4
            end
        end

        if CurType > ResType then
            ResType = CurType
            FirstResource1 = CurResource1
            FirstResource2 = CurResource2
        end
        -- 首次记录，确保即使全部充足也有Resource1
        if FirstResource1 == nil then
            FirstResource1 = CurResource1
            FirstResource2 = CurResource2
        end
    end)

    return {ResType, FirstResource1, FirstResource2}
end

function M:OnTipsOpenChanged(bIsOpen)
    if self.Details then
        self.Details:OnTipsOpenChanged(bIsOpen)
    end
end

function M:GetTraceDesc()
    if DataMgr.BattleChar[self.CharId].CharGradeDescription and DataMgr.BattleChar[self.CharId].CharGradeDescription[self.SelectTraceId] then
        local CharGradeDescription = GText(DataMgr.BattleChar[self.CharId].CharGradeDescription[self.SelectTraceId])
        local ReversedParameters = {}
        for index, value in pairs(DataMgr.BattleChar[self.CharId].CharGradeParameter) do
            table.insert(ReversedParameters, {Index = index, Value = value})
        end
        table.sort(ReversedParameters, function(a, b)
            return tonumber(a.Index) > tonumber(b.Index)
        end)

        for _, param in ipairs(ReversedParameters) do
            local Parameter = SkillUtils.CalcSkillDesc(param.Value, 1)
            local SignIndex = string.find(Parameter, '%%', 1)
            if SignIndex then
                Parameter = Parameter.."%"
            end
            CharGradeDescription = string.gsub(CharGradeDescription,'#'..param.Index, Parameter)
        end
        return CharGradeDescription
    elseif self.SelectTraceId == 7 then
        local SkillId = DataMgr.CharId2UltraPassiveSkillId and DataMgr.CharId2UltraPassiveSkillId[self.CharId]
        if SkillId then
            local SkillData = DataMgr.Skill[SkillId] and DataMgr.Skill[SkillId][1] and DataMgr.Skill[SkillId][1][0]
            if SkillData then
                local Desc = GText(SkillData.SkillDesc)
                -- 读取SkillDescValues中的参数并替换
                if SkillData.SkillDescValues then
                    local ReversedParameters = {}
                    for index, value in pairs(SkillData.SkillDescValues) do
                        table.insert(ReversedParameters, {Index = index, Value = value})
                    end
                    table.sort(ReversedParameters, function(a, b)
                        return tonumber(a.Index) > tonumber(b.Index)
                    end)

                    for _, param in ipairs(ReversedParameters) do
                        local Parameter = SkillUtils.CalcSkillDesc(param.Value, 1)
                        local SignIndex = string.find(Parameter, '%%', 1)
                        if SignIndex then
                            Parameter = Parameter.."%"
                        end
                        Desc = string.gsub(Desc, '#'..param.Index, Parameter)
                    end
                end
                return Desc
            end
        end
        return ""
    end
    return ""
end

function M:OnClickBtnFullClose()
    if self.SelectTraceId == -1 then
        return
    else
        if self['InronItem_'..self.SelectTraceId] then
            self['InronItem_'..self.SelectTraceId].IsClick = false
            self['InronItem_'..self.SelectTraceId]:SetNormalState()
        end
        if self['InronItem_'..(self.CharGradeLevel + 1)] and (self.CharGradeLevel + 1) <= self.MaxGradeLevel then
            self['InronItem_'..(self.CharGradeLevel + 1)].IsClick = false
        end
        self.SelectTraceId = -1
    end
end

function M:OnClickBTN(Type, Resource1, Resource2)
    -- 第7级的解锁逻辑
    if self.SelectTraceId == 7 then
        if self.IsExtraGradeUnlocked then
            return
        end
        if Type == 4 then
            UIManager(self):ShowUITip("CommonToastMain", 'UI_FORGING_MATERIAL_NOTENOUGH')
            return
        end
        if Type == 1 then
            if self['InronItem_7'] then
                self['InronItem_7']:SetReddotState(false)
            end
            local Avatar = GWorld:GetAvatar()
            if Avatar then
                self.Parent:BlockAllUIInput(true)
                local Char = self.Char
                DebugPrint("zwkkk OnClickBTN UpCharExtraGradeLevel")
                local CallServerFunc = Avatar["UpCharExtraGradeLevel"]
                CallServerFunc(Avatar,Char.Uuid)
            end
        elseif Type == 2 or Type == 3 then
            local Avatar = GWorld:GetAvatar()
            local Resource1Data = {}
            Resource1Data.Count = Avatar.Resources[Resource1.Id] and Avatar.Resources[Resource1.Id].Count or 0
            Resource1Data.ResourceName = DataMgr.Resource[Resource1.Id] and DataMgr.Resource[Resource1.Id].ResourceName or ""
            local BuyCount = Resource1.NeedCount - Resource1.Count
            local Params = {
                LeftItems = {{
                    ItemId = Resource2.Id,
                    ItemType = Resource2.ItemType,
                    Count = Resource2.Count,
                }},
                RightItems = {{
                    ItemId = Resource1.Id,
                    ItemType = Resource2.ItemType,
                    Count = BuyCount,
                }},
                ShortTextParams = {Resource2.Count, BuyCount, GText(Resource1Data.ResourceName)},
                RightCallbackFunction = function()
                    self.Parent:BlockAllUIInput(true)
                    self.IsWatingForBuyResource = true
                    self.IsWatingForUltraUpgrade = true
                    Avatar:PurchaseShopItem(Resource1.ShopItemId, BuyCount, true)
                end,
            }
            if Type == 3 then
                Params.RightCallbackFunction = function()
                    UIManager(self):ShowCommonPopupUI(100248, {
                        RightCallbackFunction = function()
                            PageJumpUtils:JumpToShopPage(CommonConst.GachaJumpToShopMainTabId, nil, nil, "Shop")
                        end
                    },self)
                end
            end
            UIManager(self):ShowCommonPopupUI(100247, Params,self)
        end
        return
    end

    -- 原有前6级逻辑
    if self.CharGradeLevel == self.MaxGradeLevel or self.SelectTraceId ~= self.CharGradeLevel + 1 then
        return
    end
    if Type == 4 then
        UIManager(self):ShowUITip("CommonToastMain", 'UI_FORGING_MATERIAL_NOTENOUGH')
        return
    end

    if Type == 1 then
        -- 碎片充足可以升级
        if self.SelectTraceId ~= -1 then
            self['InronItem_'..(self.CharGradeLevel + 1)]:SetReddotState(false)
        end
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            self.Parent:BlockAllUIInput(true)
            local Char = self.Char
            local CallServerFunc = Avatar["UpCharGradeLevel"]
            CallServerFunc(Avatar,Char.Uuid,tonumber(Char.GradeLevel))
        end
    elseif Type == 2 or Type ==3 then
        -- 碎片不足，月石充足
        local Avatar = GWorld:GetAvatar()
        local Resource1Data = {}
        Resource1Data.Count = Avatar.Resources[Resource1.Id] and Avatar.Resources[Resource1.Id].Count or 0
        Resource1Data.ResourceName = DataMgr.Resource[Resource1.Id] and DataMgr.Resource[Resource1.Id].ResourceName or ""
        local BuyCount = Resource1.NeedCount - Resource1.Count
        local Params = {
            LeftItems = {{
                ItemId = Resource2.Id,
                ItemType = Resource2.ItemType,
                Count = Resource2.Count,
            }},
            RightItems = {{
                ItemId = Resource1.Id,
                ItemType = Resource2.ItemType,
                Count = BuyCount,
            }},
            ShortTextParams = {Resource2.Count, BuyCount, GText(Resource1Data.ResourceName)},
            RightCallbackFunction = function()
                self.Parent:BlockAllUIInput(true)
                self.IsWatingForBuyResource = true
                self.IsWatingForUltraUpgrade = false
                Avatar:PurchaseShopItem(Resource1.ShopItemId, BuyCount, true)
            end,
        }
        if Type == 3 then
            Params.RightCallbackFunction = function()
                UIManager(self):ShowCommonPopupUI(100248, {
                    RightCallbackFunction = function()
                        PageJumpUtils:JumpToShopPage(CommonConst.GachaJumpToShopMainTabId, nil, nil, "Shop")
                    end
                },self)
            end
        end
        UIManager(self):ShowCommonPopupUI(100247, Params,self)
    end
end

function M:OnPurchaseShopItem(Ret)
    if(not self.IsWatingForBuyResource)then
        return
    end
    self.Parent:BlockAllUIInput(false)
    if not ErrorCode:Check(Ret) then return end
    if(self.IsWatingForBuyResource)then
        self.IsWatingForBuyResource = false
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            self.Parent:BlockAllUIInput(true)
            local Char = self.Char
            if self.IsWatingForUltraUpgrade then
                -- 第7级解锁
                DebugPrint("zwkkk OnPurchaseShopItem UpCharExtraGradeLevel")
                Avatar:UpCharExtraGradeLevel(Char.Uuid)
            else
                -- 前6级解锁
                if self.SelectTraceId ~= -1 and self['InronItem_'..(self.CharGradeLevel + 1)] then
                    self['InronItem_'..(self.CharGradeLevel + 1)]:SetReddotState(false)
                end
                local CallServerFunc = Avatar["UpCharGradeLevel"]
                CallServerFunc(Avatar,Char.Uuid,tonumber(Char.GradeLevel))
            end
        end
    end
end

function M:CheckCharCanUpGradeLevel()
    if(self.IsPreviewMode)then return end
    local Avatar = GWorld:GetAvatar()
    if(not Avatar)then
        return
    end
    local Char = self.Char
    return UpgradeUtils.CheckCharCanUpgradeCardLevel(Char)
end

-- 检查第7级是否可升级
function M:CheckCharCanUpUltraGradeLevel()
    if(self.IsPreviewMode)then return end
    local Avatar = GWorld:GetAvatar()
    if(not Avatar)then
        return
    end
    local Char = self.Char
    return UpgradeUtils.CheckCharCanUpgradeUltraCardLevel(Char)
end

function M:OnCharGradeLevelUp(Ret,CharUuid,CurrentGradeLevel)
    DebugPrint("zwkkk OnCharGradeLevelUp ", Ret, CharUuid, CurrentGradeLevel)
    self.Parent:BlockAllUIInput(false)
    if ErrorCode:Check(Ret) then
        local Avatar = GWorld:GetAvatar()
        self.Char = Avatar.Chars[self.Char.Uuid]
        self.CharGradeLevel = CurrentGradeLevel + 1
        if self['InronItem_'..self.SelectTraceId] then
            AudioManager(self):PlayUISound(self, "event:/ui/armory/card_level_unlock", nil, nil)
            self['InronItem_'..self.SelectTraceId]:PlayUnLockAnim()
        end
        if self['InronItem_'..(self.CharGradeLevel + 1)] and (self.CharGradeLevel + 1) <= self.MaxGradeLevel then
            self['InronItem_'..(self.CharGradeLevel + 1)]:SetReddotState(self:CheckCharCanUpGradeLevel())
        end
        -- 前6级满级后刷新第7级红点
        if self.CharGradeLevel >= self.MaxGradeLevel and self.HasUltraGrade and self['InronItem_7'] then
            self.IsExtraGradeUnlocked = self.Char:IsExtraGradeLevelUnlocked()
            if not self.IsExtraGradeUnlocked then
                self['InronItem_7']:SetReddotState(self:CheckCharCanUpUltraGradeLevel())
            end
        end
        if self.Details then
            self.Details:UpdateDetailInfo(self.SelectTraceId, 1)
        end
    end
end

-- 新增：第7级解锁回调
function M:OnCharExtraGradeLevelUp(Ret, CharUuid)
    self.Parent:BlockAllUIInput(false)
    if ErrorCode:Check(Ret) then
        local Avatar = GWorld:GetAvatar()
        self.Char = Avatar.Chars[self.Char.Uuid]
        self.IsExtraGradeUnlocked = true
        if self['InronItem_'..self.SelectTraceId] then
            AudioManager(self):PlayUISound(self, "event:/ui/armory/card_level_unlock", nil, nil)
            self['InronItem_'..self.SelectTraceId]:PlayUnLockAnim()
        end
        if self['InronItem_7'] then
            self['InronItem_7']:SetReddotState(false)
        end
        if self.Details then
            self.Details:UpdateDetailInfo(self.SelectTraceId, 1)
        end
    end
end

function M:ClickToNextTraceItem()
    self.Parent:BlockAllUIInput(false)
    -- if self['InronItem_'..(self.CharGradeLevel + 1)] then
    --     self['InronItem_'..(self.CharGradeLevel + 1)]:SetReddotState(self:CheckCharCanUpGradeLevel())
    --     -- self['InronItem_'..(self.CharGradeLevel + 1)]:SetClickState()
    --     -- self['InronItem_'..(self.CharGradeLevel + 1)]:SetFocus()
    -- end
end

function M:PlayInAnim()
    self.IsOutAnimPlayed = false
    self:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    if not self.IsOpenDetails and not self.DetailsClose then
        self:StopAllAnimations()
        self:FlushAnimations()
        self:PlayAnimation(self.In)
        AudioManager(self):PlayUISound(self, "event:/ui/armory/suyuan_points_show", nil, nil)
        if self.InronItem_1 then
            self.LastFocusItem = self.InronItem_1
        end
    end
    self.DetailsClose = false
end

function M:PlayOutAnim()
    self.IsOutAnimPlayed = true
    self:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])
    self:StopAllAnimations()
    self:FlushAnimations()
    self:PlayAnimation(self.Out)
    for i = 1, self.TotalMaxGradeLevel do
        if self['InronItem_'..i] then
            self['InronItem_'..i]:CollapseNiagara()
        end
    end
    return self.Out:GetEndTime()
end

function M:SetDetailsUnlockPlaying(IsPlaying)
    if self.Details then
        self.Details.UnlockPlaying = IsPlaying
    end
end

--#region 按键/聚焦/导航

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
    self.CurInputDeviceType = CurInputDevice
    -- self:UpdateGamepadKeyState()
end

-- function M:UpdateGamepadKeyState()
--     if(self.IsGamepadInput)then
--         if(self.IsResourceFocused)then
--             self.Key_GamePad:SetVisibility(UIConst.VisibilityOp["Collapsed"])
--         else
--             self.Key_GamePad:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])
--         end
--     else
--         self.Key_GamePad:SetVisibility(UIConst.VisibilityOp["Collapsed"])
--     end
-- end

function M:OnTraceItemFocused(TraceId)
    if (self.IsGamepadInput and self.IsOpenDetails) or (self.IsOpenDetails and self.CurInputDeviceType == ECommonInputType.GamePad) then
        if self['InronItem_'..TraceId] then
            -- 手柄端直接选中
            self['InronItem_'..TraceId].IsClick = false
            self['InronItem_'..TraceId]:SetClickState()
            self.LastFocusItem = self['InronItem_'..TraceId]
        end
        -- self:OnClickTraceItem(TraceId)
    end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    -- if(self.LastFocusItem)then
    --     return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self.LastFocusItem)
    -- else
    --     return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self.InronItem_1)
    -- end
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self.InronItem_1)
end

function M:OnAddedToFocusPath()
    if(self._OnAddedToFocusPath)then
        self._OnAddedToFocusPath(self.Parent,self)
    end
end

function M:OnRemovedFromFocusPath()
    -- self:OnClickBtnFullClose()
    -- if self.SelectTraceId ~= -1 then
    --     self['InronItem_'..(self.SelectTraceId)]:SetReddotState(self:CheckCharCanUpGradeLevel())
    --     self.SelectTraceId = -1
    -- end
    if(self._OnRemovedFromFocusPath)then
        self._OnRemovedFromFocusPath(self.Parent,self)
    end
end

-- function M:OnParentKeyDown(MyGeometry, InKeyEvent)
--     local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
--     local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
--     if(InKeyName == UIConst.GamePadKey.RightThumb and self.Group_Currency:IsVisible())then
--         return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self.WBP_Com_Item_Universal_S_C_0),true
--     elseif(InKeyName == UIConst.GamePadKey.FaceButtonTop)then
--         self:OnClickBTN()
--         return UIUtils.Handled,true
--     end
--     return UIUtils.Unhandled
-- end

function M:OnPopUIKeyDown(InKeyName)
    if not self.PopupUI then
        return
    end
    if InKeyName == UIConst.GamePadKey.RightThumb then
        local ItemWidget = self.PopupUI:GetContentWidgetByName("ItemSubsize")
        if ItemWidget then
            local Item = ItemWidget.Item:GetChildAt(0)
            if Item then
                local Events = {OnMenuOpenChanged = self.ItemMenuAnchorChanged}
                Item:BindEvents(self, Events)
                -- Item:SetFocus()
                Item:OpenItemMenu()
            end
        end
    end
end

--- 手柄端打开物品详情时需隐藏弹窗的手柄样式
function M:ItemMenuAnchorChanged(bIsOpen)
    if not self.PopupUI then
        return
    end
    -- self.bTipsOpen = bIsOpen
    local CurMode =  UIUtils.UtilsGetCurrentInputType()
    if CurMode ~= ECommonInputType.Gamepad then
        return
    end
    if bIsOpen then
        self.PopupUI:SetGamepadBtnKeyVisibility(false)
        self.PopupUI:HideGamepadShortcut(self.OpenTipsButtonIndex)
    else
        self.PopupUI:SetGamepadBtnKeyVisibility(true)
        self.PopupUI:ShowGamepadShortcut(self.OpenTipsButtonIndex)
    end
end

-- function M:InitNavigationRules()
--     local i = 1
--     while self["InronItem_"..i] do
--         local PreItemWidget = self["InronItem_"..i-1]
--         local ItemWidget = self["InronItem_"..i]
--         local NextItemWidget = self["InronItem_"..i+1]
--         ItemWidget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
--         if(PreItemWidget)then
--             ItemWidget:SetNavigationRuleExplicit(EUINavigation.Up, PreItemWidget)
--         end
--         if(NextItemWidget)then
--             ItemWidget:SetNavigationRuleExplicit(EUINavigation.Down, NextItemWidget)
--         end
--         ItemWidget:SetNavigationRuleBase(EUINavigation.Left,EUINavigationRule.Escape)
--         i = i + 1
--     end
-- end

function M:InitKeySetting()
end

--#endregion

AssembleComponents(M)

return M
