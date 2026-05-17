require "UnLua"
local WBP_Forging_Convert_PopUp_Choose_C = Class("BluePrints.UI.BP_UIState_C")
local ModModel = ModController:GetModel()
WBP_Forging_Convert_PopUp_Choose_C._components = {
    "BluePrints.UI.Forge.Convert.WBP_Forging_Convert_PopUp_Choose_GamePadCompoment",
}

function WBP_Forging_Convert_PopUp_Choose_C:Construct()
    DebugPrint("Yihan@ WBP_Forging_Convert_PopUp_Choose_C.Construct")
    self.TextTitle:SetText(GText("Convert_Select_Tips"))
    self.TextName:SetText(GText("UI_Bag_Sell_Select"))
    self.WBP_Com_Tips:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self:ShowItemDetailsPanel(false)
    self:InitListenEvent()
    -- 绑定确认的按钮事件
    self:SwitchBindButtonEvents(true)
    self.Btn_Yes:BindForbidStateExecuteEvent(self, self.OnYesButtonClicked)
    self.Btn_Yes:TryOverrideSoundFunc(function()
        AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_confirm", nil, nil)
    end)
end

function WBP_Forging_Convert_PopUp_Choose_C:InitAll(ConvertContent)
    -- 每次更换转化物的时候将下面已选择的置空
    self.IsChoosedTbl = {}
    self:OnSelectedMaterialCountChanged()
    self:InitSlotCount(ConvertContent)
end

function WBP_Forging_Convert_PopUp_Choose_C:SetConfirmCallback(Parent, Callback)
    self.Parent = Parent
    self.Callback = Callback
end

function WBP_Forging_Convert_PopUp_Choose_C:InitSlotCount(ConvertContent)
    DebugPrint("Yihan@ WBP_Forging_Convert_PopUp_Choose_C.InitSlotCount", ConvertContent.Idx)
    self.ConvertContent = ConvertContent
    local SlotCount = DataMgr.Convert[ConvertContent.Idx].ConvertNum
    for i = 1, 4 do
        local Item = self["Item_" .. i]
        if Item then
            Item:ShowAddImg(false)
            Item.NotInteractive = true
            if i <= SlotCount then
                Item:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
                Item.Switcher:SetActiveWidgetIndex(0)
                Item:ShowLeftTopIcon(false)
            else
                local Obj = NewObject(UIUtils.GetCommonItemContentClass())
                Obj.IsEmpty = true
                Item.Switcher:SetActiveWidgetIndex(1)
                Item:ShowLeftTopIcon(false)
                Item:Init(Obj)
                Item:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
            end
        end
    end
    -- 渲染已选后，补齐剩余空槽位的点击禁用状态
    self:UpdateEmptySlotsHitTestInvisible(ConvertContent)
end

-- 维护未填充的可添加材料槽位：显示但不可点击
-- 场景：初始化、添加/删除材料后，需要保证空槽位不参与点击命中测试
function WBP_Forging_Convert_PopUp_Choose_C:UpdateEmptySlotsHitTestInvisible(ConvertContent)
    if not (ConvertContent.Idx and DataMgr.Convert[ConvertContent.Idx]) then
        return
    end
    local LimitCount = DataMgr.Convert[ConvertContent.Idx].ConvertNum
    for i = #self.IsChoosedTbl + 1, LimitCount do
        local Item = self["Item_" .. i]
        if Item then
            Item.Switcher:SetActiveWidgetIndex(0)
            Item:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
            Item:ShowLeftTopIcon(false)
        end
    end
end
function WBP_Forging_Convert_PopUp_Choose_C:InitListenEvent()
    -- self.List_Item.BP_OnItemClicked:Add(self, self.OnListItemClicked)
end

-- 显示出所有的材料
function WBP_Forging_Convert_PopUp_Choose_C:ShowAllMaterial(ConvertContent, ChoosedMaterialTbl)
    DebugPrint("Yihan@ WBP_Forging_Convert_PopUp_Choose_C.ShowAllMaterial", ConvertContent.Idx, ConvertContent.Id)
    self.ChoosedContent = ConvertContent
    self:ShowItemDetailsPanel(false)
    self:UpdateContent(ConvertContent, ChoosedMaterialTbl)
    self:UpdateYesButtonState()
    self:ShowChoosedMaterial()
    self:OnSelectedMaterialCountChanged()
end

function WBP_Forging_Convert_PopUp_Choose_C:UpdateContent(ConvertContent, ChoosedMaterialTbl)
    if ConvertContent.ItemData.ProductType == CommonConst.ArmoryType.Mod then
        self:UpdateModMaterialContent(ConvertContent, ChoosedMaterialTbl)
    else
        self:UpdateResourceMaterialContent(ConvertContent, ChoosedMaterialTbl)
    end
end

function WBP_Forging_Convert_PopUp_Choose_C:UpdateResourceMaterialContent(ConvertContent, ChoosedMaterialTbl)
    -- 分帧加载
    self.List_Item:ClearListItems()
    self.CurSelectedContent = nil
    local ConvertData = DataMgr.Convert[ConvertContent.Idx]
    
    local ResourcesWithCount = {}
    for _, ResourceId in ipairs(ConvertData.Resource) do
        table.insert(ResourcesWithCount, {
            ResourceId = ResourceId,
            HaveCount = self:GetHaveCount(ResourceId),
            IsOwned = self:GetHaveCount(ResourceId) > 0
        })
    end
    table.sort(ResourcesWithCount, function(a, b)
        if a.IsOwned ~= b.IsOwned then
            return a.IsOwned
        end
        if a.IsOwned and b.IsOwned then
            return a.HaveCount > b.HaveCount
        end
        return false
    end)

    for index, Data in ipairs(ResourcesWithCount) do
        local ResourceId = Data.ResourceId
        DebugPrint("Yihan@ WBP_Forging_Convert_PopUp_Choose_C.GetCanUseMaterialList", ResourceId)
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        local ResourceData = DataMgr.Resource[ResourceId]
        Content.Id = ResourceId
        Content.ItemType = "Resource"
        Content.Rarity = ResourceData.Rarity
        Content.Icon = ResourceData.Icon
        Content.Parent = self
        Content.HandleMouseDown = true
        -- 获取点击某个材料的次数
        Content.ClickedCount = self:GetChoosedCount(ResourceId, ChoosedMaterialTbl)
        Content.Count = self:GetHaveCount(ResourceId)
        Content.bShadow = self:GetHaveCount(ResourceId) <= 0
        Content.OnMouseButtonUpEvents = {Obj = self, Callback = self.OnMaterialItemSelected, Params = {Content}}
        Content.OnFocusReceivedEvent = {Obj = self, Callback = self.OnMaterialItemFocusReceived, Params = {Content}}
        Content.IsHold = Content.IsNew
        Content.IsSelect = false
        if index==1 then
            Content.NeedFocus = true
        end
        self.List_Item:AddItem(Content)
    end
    self.List_Item:RequestPlayEntriesAnim()
    self.List_Item.OnCreateEmptyContent:Bind(self, function(self)
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        Obj.IsEmpty = true
        return Obj
    end)
    self.List_Item:RequestFillEmptyContent()
    self.Ws_Path:SetActiveWidgetIndex(0)
    self.Com_EmptyBg:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function WBP_Forging_Convert_PopUp_Choose_C:UpdateModMaterialContent(ConvertContent, ChoosedMaterialTbl)
    -- 分帧加载
    self.List_Item:ClearListItems()
    self.CurSelectedContent = nil

    -- 获取mods
    local ModModel = ModController:GetModel()
    local ShowMods = ModModel:GetConvertMods(ConvertContent.ItemData.ModConvert)
    self.ShowMods = ShowMods
    -- 排序
    table.sort(ShowMods, function(a, b)
        if a.Level == 0 and b.Level == 0 then
            if a.Rarity ~= b.Rarity then
                return a.Rarity > b.Rarity
            elseif a.ModId ~= b.ModId then
                return a.ModId > b.ModId
            else
                return false
            end
        elseif a.Level > 0 and b.Level > 0 then
            if a.Rarity ~= b.Rarity then
                return a.Rarity > b.Rarity
            elseif a.ModId ~= b.ModId then
                return a.ModId > b.ModId
            elseif a.Level ~= b.Level then
                return a.Level > b.Level
            else
                return false
            end
        else
            --一个养成一个未养成的情况，未养成的在前
            return a.Level < b.Level
        end
    end)
    if #ShowMods>0 then
        self.Ws_Path:SetActiveWidgetIndex(0)
        self.Com_EmptyBg:SetVisibility(UE4.ESlateVisibility.Collapsed)

        for Index, Mod in pairs(ShowMods) do
            local Content = self:CreateModContent(Mod.Uuid, Index, self.OnMaterialItemSelected,nil, ChoosedMaterialTbl)
            self.List_Item:AddItem(Content)
        end

        self.List_Item:RequestPlayEntriesAnim()
        self.List_Item.OnCreateEmptyContent:Bind(self, function(self)
            local Obj = NewObject(UIUtils.GetCommonItemContentClass())
            Obj.IsEmpty = true
            return Obj
        end)
        self.List_Item:RequestFillEmptyContent()
    else
        self.Ws_Path:SetActiveWidgetIndex(1)
        self.Com_EmptyBg:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Text_EmptyText:SetText(GText("AvailablePet_Empty"))
    end 
end

function WBP_Forging_Convert_PopUp_Choose_C:CreateModContent(Uuid, Index, Callback, ChoosedIndex, ChoosedMaterialTbl)
    local Mod = ModModel:GetMod(Uuid)
    local Content = ModModel:CreateModContent(Mod, nil, true)
    Content.bEnableDrag = false
    Content.bDontOpenTipsWhenClick = false
    Content.bAura = false
    if  Mod:IsLock() then
        Content.LockType = 1
    else
        Content.LockType = nil
    end
    
    Content.Id = Content.Uuid
    Content.ItemType = Content.Type

    if Content.Level > 0 then
        Content.Developed = true
    else
        Content.Developed = false
    end
    
    Content.bInGear = Mod:IsEquipped()

    -- 获取点击某个材料的次数
    Content.ClickedCount = self:GetChoosedCount(Content.Uuid, ChoosedMaterialTbl)
    Content.Count = Mod.Count
    Content.bShadow = Mod.Count <= 0
    Content.IsConvert = true
    Content.ProductType = CommonConst.ArmoryType.Mod
    Content.ItemName = Content.UnitName

    Content.IsSelfDeadWithUpEvent = true
    Content.OnMouseButtonUpEvents = {Obj = self, Callback = Callback, Params = {Content, Index = ChoosedIndex}}

    Content.OnFocusReceivedEvent = {
        Obj = self,
        Callback = self.OnMaterialItemFocusReceived,
        Params = {Content}
    }

    -- 音效不知道需不需要修改
    Content.SoundItemType = "Convert"
    Content.IsHold = Content.IsNew
    Content.IsSelect = false
    if Index == 1 then
        Content.NeedFocus = true
    end
    return Content
end

function WBP_Forging_Convert_PopUp_Choose_C:OnMaterialItemSelected(ItemContent)
    DebugPrint("Yihan@ WBP_Forging_Convert_PopUp_Choose_C:OnMaterialItemSelected", ItemContent, self:GetHaveCount(ItemContent.Id), ItemContent.ClickedCount)
    if ItemContent.ItemType == CommonConst.ArmoryType.Mod then
        if ItemContent.Count == 0 or ItemContent.Count < ItemContent.ClickedCount + 1 then
            self:KeepSelectState(ItemContent)
        elseif self:MaterialIsEnough() then
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("Convert_ResourcesFull"))
            self:KeepSelectState(ItemContent)
        else
            self:SelectMaterialItem(ItemContent)
        end
    else
        if self:GetHaveCount(ItemContent.Id) == 0 or self:GetHaveCount(ItemContent.Id) < ItemContent.ClickedCount + 1 then
            self:KeepSelectState(ItemContent)
        elseif self:MaterialIsEnough() then
            -- 要判断是否满了
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("Convert_ResourcesFull"))
            self:KeepSelectState(ItemContent)
        else
            self:SelectMaterialItem(ItemContent)
        end
    end

    if self.CurItemDetails ~= ItemContent or not self.bItemDetailsShowed then
    	self.CurItemDetails = ItemContent
        self:ShowItemDetailsPanel(true)

        ItemContent.ItemId = ItemContent.ItemType == CommonConst.ArmoryType.Mod and ItemContent.UnitId or ItemContent.Id
        ItemContent.bHideGamePad = false
        self.WBP_Com_Tips:PlayAnimation(self.WBP_Com_Tips.Change)
        self.WBP_Com_Tips:RefreshItemInfo(ItemContent, true)
 		self:RefreshItemDetailsByContent(ItemContent, true, false)
    end
end

function WBP_Forging_Convert_PopUp_Choose_C:OnMaterialItemFocusReceived()
end

function WBP_Forging_Convert_PopUp_Choose_C:KeepSelectState(ItemContent)
    if self.CurSelectedContent == ItemContent then return end
    local CurWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Item, self.List_Item:GetIndexForItem(ItemContent))
    DebugPrint("Yihan@ WBP_Forging_Convert_PopUp_Choose_C:OnMaterialItemSelected123123", CurWidget)
    if CurWidget then
        CurWidget:UpdateChoosedState(true)
    end
    if self.CurSelectedContent then
        local PrevWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Item, self.List_Item:GetIndexForItem(self.CurSelectedContent))
        if PrevWidget then
            PrevWidget:UpdateChoosedState(false)
        end
    end
    self.CurSelectedContent = ItemContent
end

function WBP_Forging_Convert_PopUp_Choose_C:SelectMaterialItem(Content)
    DebugPrint("Yihan@ WBP_Forging_Convert_PopUp_Choose_C:SelectMaterialItem", Content, self.CurSelectedContent, Content.Id)
    local CurWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Item, self.List_Item:GetIndexForItem(Content))
    if CurWidget then
        Content.ClickedCount = Content.ClickedCount + 1
        CurWidget:UpdateChoosedCount(Content.ClickedCount)
        CurWidget:UpdateChoosedState(true)
    end
    if self.CurSelectedContent and self.CurSelectedContent ~= Content then
        local PrevWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Item, self.List_Item:GetIndexForItem(self.CurSelectedContent))
        if PrevWidget then
            PrevWidget:UpdateChoosedState(false)
        end
    end
    self.CurSelectedContent = Content
    -- 给下面已选择的地方加上选择的材料
    table.insert(self.IsChoosedTbl, Content)
    self:OnSelectedMaterialCountChanged()
    self:UpdateYesButtonState()
    self:ShowChoosedMaterial()

end

function WBP_Forging_Convert_PopUp_Choose_C:ShowChoosedMaterial()
    DebugPrint("Yihan@ WBP_Forging_Convert_PopUp_Choose_C:ShowChoosedMaterial-------123123123123123123123----------")
    for Index, Content in ipairs(self.IsChoosedTbl) do
        DebugPrint("Yihan@ WBP_Forging_Convert_PopUp_Choose_C:ShowChoosedMaterial-----------------", Index, Content)

        local ChoosedContent
        if self.ConvertContent.ProductType == CommonConst.ArmoryType.Mod then
            ChoosedContent = self:CreateModContent(Content.Id, nil, self.OnChoosedMaterialClicked, Index)
            ChoosedContent.Count = nil
            ChoosedContent.IsSelect = false
            ChoosedContent.Empty = true
        else
            ChoosedContent = Content
            ChoosedContent.OnMouseButtonUpEvents = { Obj = self, Callback = self.OnChoosedMaterialClicked, Params = {Content, Index}}
            ChoosedContent.Count = nil
            ChoosedContent.IsSelect = false
            ChoosedContent.Empty = true
        end

        local Item = self["Item_" .. Index]
        if Item then
            Item.Switcher:SetActiveWidgetIndex(1)
            Item:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            Item:ShowLeftTopIcon(true)
            Item.WBP_Com_Item_Universal_L:Init(ChoosedContent)
            Item.WBP_Com_BtnImg01:UnBindEventOnClickedByObj(self)
            Item.WBP_Com_BtnImg01:BindEventOnClicked(self, self.OnChoosedMaterialClicked, ChoosedContent, Index)
            if Item.WBP_Com_BtnImg01 and Item.WBP_Com_BtnImg01.IsVisible and Item.WBP_Com_BtnImg01:IsVisible() then
                if UIUtils.IsGamepadInput() then
                    Item.WBP_Com_BtnImg01:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
                else
                    Item.WBP_Com_BtnImg01:SetVisibility(UIConst.VisibilityOp.Visible)
                end
            end
            local MinusPath = "Texture2D'/Game/UI/Texture/Static/Atlas/Common/T_Com_IconMinus.T_Com_IconMinus'"
            local MinusDice = LoadObject(MinusPath)
            Item.Icon_Delete:SetBrushResourceObject(MinusDice)
        end
    end

end

-- 已选择材料槽点击事件
function WBP_Forging_Convert_PopUp_Choose_C:OnChoosedMaterialClicked(Content, Index)
    if #self.IsChoosedTbl == 0 then return end
 
    local NewChoosedTbl, IsGet = {}, false
    for Index, Value in pairs(self.IsChoosedTbl) do
        if IsGet or (Value.Id ~= Content.Id) then
            table.insert(NewChoosedTbl, Value)
        else
            IsGet = true
        end
    end
    self.IsChoosedTbl = NewChoosedTbl

	self:OnSelectedMaterialCountChanged()
    self:InitSlotCount(self.ConvertContent)
    self:ShowChoosedMaterial()
    self:UpdateYesButtonState()
    local ContentItems = self.List_Item:GetListItems()
    for i = 1, ContentItems:Length() do 
        local ContentItem = ContentItems:GetRef(i)
        if ContentItem.Id == Content.Id then
            print("hzq OnChoosedMaterialClicked")
            print(ContentItem.Id,ContentItem.Uuid,ContentItem.UnitId)
            print(Content.Id,Content.Uuid,Content.UnitId)
            print("hzq OnChoosedMaterialClicked end ")
            ContentItem.ClickedCount = ContentItem.ClickedCount - 1
            
            local CurWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Item, self.List_Item:GetIndexForItem(ContentItem))
            CurWidget:UpdateChoosedCount(ContentItem.ClickedCount)
        end
    end
    if UIUtils.IsGamepadInput() then
        self:UpdataGamepadFocus(Index)
    end
end

function WBP_Forging_Convert_PopUp_Choose_C:UpdateChoosedText()
    DebugPrint("Yihan@ WBP_Forging_Convert_PopUp_Choose_C:UpdateChoosedText")
    local NowCount = #self.IsChoosedTbl
    local LimitCount = 0
    local Choosed = self.ChoosedContent or self.ConvertContent
    if Choosed and Choosed.Idx and DataMgr.Convert[Choosed.Idx] then
        LimitCount = DataMgr.Convert[Choosed.Idx].ConvertNum
    end
    self.TextNow:SetText(NowCount)
    local Color = FSlateColor()
    if NowCount < LimitCount then
        Color.SpecifiedColor.R = 1.0
        Color.SpecifiedColor.G = 0.0
        Color.SpecifiedColor.B = 0.0
        self.TextNow:SetColorAndOpacity(Color)
    else
        Color.SpecifiedColor.R = 1.0
        Color.SpecifiedColor.G = 1.0
        Color.SpecifiedColor.B = 1.0
        self.TextNow:SetColorAndOpacity(Color)
    end
    self.TextLimt:SetText(LimitCount)
end

function WBP_Forging_Convert_PopUp_Choose_C:SwitchBindButtonEvents(bBind)
    if bBind then
        self.Btn_Yes:BindEventOnClicked(self, self.OnYesButtonClicked)
        self.Btn_Close.OnClicked:Add(self, self.OnBackgroundClicked)
    else
        self.Btn_Yes:UnBindEventOnClickedByObj(self)
        self.Btn_Close.OnClicked:Clear()
    end
end

function WBP_Forging_Convert_PopUp_Choose_C:UpdateYesButtonState()
    self.Btn_Yes:SetText(GText("UI_LOGIN_ENSURE"))
    self.Btn_Yes:ForbidBtn(not self:MaterialIsEnough())
end

function WBP_Forging_Convert_PopUp_Choose_C:OnBackgroundClicked()
    DebugPrint("Yihan@ WBP_Forging_Convert_PopUp_Choose_C.OnBackgroundClicked")
    if self.bItemDetailsShowed then
        self:ShowItemDetailsPanel(false)
    else
        self:CloseChooseList()
    end
end

function WBP_Forging_Convert_PopUp_Choose_C:OnYesButtonClicked()
    DebugPrint("Yihan@ WBP_Forging_Convert_PopUp_Choose_C.OnYesButtonClicked")
    if self.Btn_Yes.IsForbidden then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("Convert_AddResources"))
    else
        -- 显示在转化炉那，并隐藏选择界面
        self:ShowChooseUI(false)
        if self.Callback then
            self.Callback(self.Parent, self.IsChoosedTbl, true)
        -- elseif self.Parent and self.Parent.UpdateConvertMaterial then
        --     self.Parent:UpdateConvertMaterial(self.IsChoosedTbl, true)
        end
    end
end

function WBP_Forging_Convert_PopUp_Choose_C:MaterialIsEnough()
    local NowCount = #self.IsChoosedTbl
    local TotalCount = 0
    local Choosed = self.ChoosedContent or self.ConvertContent
    if Choosed and Choosed.Idx and DataMgr.Convert[Choosed.Idx] then
        TotalCount = DataMgr.Convert[Choosed.Idx].ConvertNum
    end
    return NowCount == TotalCount
end

function WBP_Forging_Convert_PopUp_Choose_C:GetChoosedCount(ResourceId, ChoosedMaterialTbl)
    if not ChoosedMaterialTbl then return 0 end
    for _, Content in ipairs(ChoosedMaterialTbl) do
        if ResourceId == Content.Id then
            DebugPrint("Yihan@ WBP_Forging_Convert_PopUp_Choose_C.GetChoosedCount", Content.ChoosedCount)
            return Content.ChoosedCount
        end
    end
    return 0
end

function WBP_Forging_Convert_PopUp_Choose_C:OnKeyDown(MyGeometry, InKeyEvent)
    DebugPrint("Yihan@ WBP_Forging_Convert_PopUp_Choose_C.Escape")  
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    else
        if InKeyName == "Escape" then
            IsEventHandled = true
            if self.bItemDetailsShowed then
                self:ShowItemDetailsPanel(false)
            else
                self:CloseChooseList()
            end
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

function WBP_Forging_Convert_PopUp_Choose_C:GetHaveCount(ResourceId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return 0 end
    return Avatar:GetResourceNum(ResourceId)
end

-- 用于开启关闭detail的UI
function WBP_Forging_Convert_PopUp_Choose_C:ShowItemDetailsPanel(bIsShow)
    if bIsShow then
        self.WBP_Com_Tips:SetVisibility(UE4.ESlateVisibility.Visible)
        self.bItemDetailsShowed = true
    else
        self.WBP_Com_Tips:SetVisibility(UE4.ESlateVisibility.Hidden)
        self.bItemDetailsShowed = false
        if self.CurSelectedContent then
            local PrevWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Item, self.List_Item:GetIndexForItem(self.CurSelectedContent))
            if PrevWidget then
                PrevWidget:UpdateChoosedState(false)
            end
            self.CurSelectedContent.IsSelect = false
        end
        self.CurSelectedContent = nil
        
        if UIUtils.IsGamepadInput() then
             self:OnSelectedMaterialCountChanged()
        end
    end
end


-- 用于显示/隐藏选择界面
function WBP_Forging_Convert_PopUp_Choose_C:ShowChooseUI(bIsShow)
    if bIsShow then
        self:SetVisibility(UE4.ESlateVisibility.Visible)
        self:PlayAnimation(self.In)
        AudioManager(self):PlayUISound(self, "event:/ui/common/sub_panel_expand", "ForgeConvertChooseUIShow", nil)
        DebugPrint("Yihan@ WBP_Forging_Convert_PopUp_Choose_C.ShowChooseUI")
        self:SetFocus()
        if UIUtils.IsGamepadInput() then
            DebugPrint("聚焦 WBP_Forging_Convert_PopUp_Choose_C.ShowChooseUI Gamepad")
            self:SetDefaultMaterialFocus()
        end
    else
        self.Parent:SetFocus()
        self:PlayAnimation(self.Out)
        AudioManager(self):SetEventSoundParam(self, "ForgeConvertChooseUIShow", {ToEnd = 1})
    end
end

function WBP_Forging_Convert_PopUp_Choose_C:CloseChooseList()
    self:ShowChooseUI(false)
    if self.Callback then
        self.Callback(self.Parent, self.IsChoosedTbl, self:MaterialIsEnough())
    elseif self.Parent and self.Parent.UpdateConvertMaterial then
        self.Parent:UpdateConvertMaterial(self.IsChoosedTbl, self:MaterialIsEnough())
    end
end

function WBP_Forging_Convert_PopUp_Choose_C:OnListItemClicked(Item)
end

function WBP_Forging_Convert_PopUp_Choose_C:OnAnimationFinished(InAnimation)
    if InAnimation == self.Out then 
        self:SetVisibility(UE4.ESlateVisibility.Collapsed)
        if self.Parent and UIUtils.IsGamepadInput() then
            self.Parent:SetFocus_Lua()
        end
    end
end

function WBP_Forging_Convert_PopUp_Choose_C:Destruct()
    self:SwitchBindButtonEvents(false)
    self.Item_1.WBP_Com_BtnImg01:UnBindEventOnClickedByObj(self)
    self.Item_2.WBP_Com_BtnImg01:UnBindEventOnClickedByObj(self)
    self.Item_3.WBP_Com_BtnImg01:UnBindEventOnClickedByObj(self)
    self.Item_4.WBP_Com_BtnImg01:UnBindEventOnClickedByObj(self)
end
-----以下为手柄端逻辑
---手柄用 已选择材料槽数量变化时调用
function WBP_Forging_Convert_PopUp_Choose_C:OnSelectedMaterialCountChanged()
    if self.IsGamePad then
        if #self.IsChoosedTbl > 0 then
            self.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        else
            self.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
    self:UpdateChoosedText()
end

function WBP_Forging_Convert_PopUp_Choose_C:RefreshItemDetailsByContent(ItemContent, bPlayAnim, bHideGamePad)
    if bHideGamePad == nil then bHideGamePad = true end
    if self.CurItemDetails ~= ItemContent or not self.bItemDetailsShowed then
        self.CurItemDetails = ItemContent
        self:ShowItemDetailsPanel(true)
        local ItemDetailParam = {}
        ItemDetailParam.ItemType = ItemContent.ItemType or "Resource"
        if ItemDetailParam.ItemType == CommonConst.ArmoryType.Mod and ItemContent.UnitId then
            ItemDetailParam.ItemId = ItemContent.UnitId
        else
            ItemDetailParam.ItemId = ItemContent.Id
        end
        ItemDetailParam.bHideGamePad = true
        ItemDetailParam.HandleKeyDown = false
        if bPlayAnim and self.WBP_Com_Tips and self.WBP_Com_Tips.Change then
            self.WBP_Com_Tips:PlayAnimation(self.WBP_Com_Tips.Change)
        end
        self.WBP_Com_Tips:RefreshItemInfo(ItemDetailParam, true)
    end
end
AssembleComponents(WBP_Forging_Convert_PopUp_Choose_C)
return WBP_Forging_Convert_PopUp_Choose_C
