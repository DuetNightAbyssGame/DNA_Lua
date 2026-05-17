require "UnLua"
local WBP_Forging_Convert_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_Forging_Convert_C:Construct()
    DebugPrint("Yihan@ WBP_Forging_Convert_C.Construct")
    self:InitData()
    self:InitCompView()
end

function WBP_Forging_Convert_C:InitData()
    self.MaterialSlotTbl = {
        [1] = {  -- 索引1对应一个节点
            self.m13
        },
        [2] = {
            self.l24,
            self.r24
        },
        [3] = {
            self.l3,
            self.m13,
            self.r3
        },
        [4] = {
            self.l4,
            self.l24,
            self.r24,
            self.r4
        },
        [5] = {
            self.l4,
            self.l3,
            self.l24,
            self.m13,
            self.r24,
            self.r3,
            self.r4
        }
    }
    self.MaterialSlotBPTbl = {
        [1] = {  -- 索引1对应一组蓝图
            self.WBP_Forging_Convert_Item_18
        },
        [2] = {
            self.WBP_Forging_Convert_Item_15,
            self.WBP_Forging_Convert_Item_21
        },
        [3] = {
            self.WBP_Forging_Convert_Item_6,
            self.WBP_Forging_Convert_Item_18,
            self.WBP_Forging_Convert_Item_33
        },
        [4] = {
            self.WBP_Forging_Convert_Item,
            self.WBP_Forging_Convert_Item_15,
            self.WBP_Forging_Convert_Item_21,
            self.WBP_Forging_Convert_Item_28
        },
        [5] = {
            self.WBP_Forging_Convert_Item,
            self.WBP_Forging_Convert_Item_6,
            self.WBP_Forging_Convert_Item_15,
            self.WBP_Forging_Convert_Item_18,
            self.WBP_Forging_Convert_Item_21,
            self.WBP_Forging_Convert_Item_28,
            self.WBP_Forging_Convert_Item_33
        }
    }
    
    self.CurrentCount = 1
    -- 绑定按钮事件
    self.WBP_Com_BtnText01_1:BindEventOnClicked(self, self.OnClearAllClicked)
    self.WBP_Com_BtnText01:BindEventOnClicked(self, self.OnConfirmConvertClicked)
    self.WBP_Com_BtnText01:TryOverrideSoundFunc(function()
        AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_confirm", nil, nil)
    end)
    self.WBP_Com_BtnText01:BindForbidStateExecuteEvent(self, self.OnConfirmBtnForbidClicked)
    self.Shop.Button_Item.OnClicked:Add(self, self.OnBigItemBtnForbidClicked)

end

function WBP_Forging_Convert_C:InitCompView()
    -- self:InitMaterialSlot()
    self.TextTitle:SetText(GText("UI_Convert_Num"))
    self.WBP_Com_BtnText01_1:SetText(GText("Convert_ClearAll"))
    self.WBP_Com_BtnText01:SetText(GText("UI_Convert"))
    self.TextHas:SetText(GText("UI_FORGING_CURRENT"))
    self.TextPrompt:SetText(GText("Convert_AddResources"))
    if self.TextBlock_64 then
        self.TextBlock_64:SetText(GText("UI_Convert_AddResources"))
    end
end

function WBP_Forging_Convert_C:SetClearAllCallback(Parent, Callback)
    self.Parent = Parent
    self.ClearAllCallback = Callback
end

function WBP_Forging_Convert_C:SetShowChooseUICallback(Parent, Callback)
    self.Parent = Parent
    self.ShowChooseUICallback = Callback
end

function WBP_Forging_Convert_C:InitSlider()
    local ConfigData = {
        InitValue = 1,
        MinValue = 1,
        MaxValue = 999,
        ClickInterval = 1,
        MinusBtnCallback = self.MinusBtnCallback,
        AddBtnCallback = self.AddBtnCallback,
        SliderChangeCallback = self.SliderChangeCallback,
        SoundResPath = {Minus="event:/ui/common/click_btn_minus"},
        OwnerPanel = self,
        PlatformName = "PC",
        EnableMiniBtn = true,
        EnableMaxBtn = true,
        MinusSpecificBtnGamePadKey = "DPadLeft",
        AddSpecificBtnGamePadKey = "DPadRight",
    }
    self.WBP_Com_Slider:Init(ConfigData)
end

function WBP_Forging_Convert_C:InitSliderValue()
    self.WBP_Com_Slider:OverrideValueLimit(1, self:GetMaxCount(), 1, true)
    self.CurrentCount = 1
end

function WBP_Forging_Convert_C:MinusBtnCallback()
    self.CurrentCount = self.WBP_Com_Slider.CurrentCount
    self:UpdateCountPanel()
end

function WBP_Forging_Convert_C:AddBtnCallback()
    self.CurrentCount = self.WBP_Com_Slider.CurrentCount
    self:UpdateCountPanel()
end

function WBP_Forging_Convert_C:SliderChangeCallback(Value)
    self.CurrentCount = Value
    self:UpdateCountPanel()
end

function WBP_Forging_Convert_C:UpdateCountPanel()
    self:DataToMaterialSlot()
    self:UpdateTextPanel()
    self:UpdateConfirmButtonState()
end

function WBP_Forging_Convert_C:GetMaxCount()
    local MaxCount = 0x7FFFFFFF
    for _, Content in ipairs(self.MergeTbl) do
        local ChoosedCount = Content.ChoosedCount
        local HaveCount = self.ConvertContent.ProductType == CommonConst.ArmoryType.Mod and self:GetModCount(Content) or
                              self:GetHaveCount(Content.Id)
        MaxCount = math.min(math.floor(HaveCount / ChoosedCount), MaxCount)
    end
    return MaxCount
end

function WBP_Forging_Convert_C:GetHaveCount(Id)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return 0 end
    return Avatar:GetResourceNum(Id)
end

function WBP_Forging_Convert_C:GetModCount(Content)
    local ModModel = ModController:GetModel()
    return ModModel:GetMod(Content.Uuid).Count
end

function WBP_Forging_Convert_C:InitMaterialSlot()
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.bAdd = true
	Content.OnMouseButtonUpEvents = {
        Obj = self,
        Callback = self.OnMaterialSlotClicked,
        Params = {Content}
    }
    Content.ProductType = self.ConvertContent.ProductType

    for _, MaterialSlot in pairs(self.MaterialSlotBPTbl[5]) do
        local CurrentSlot = MaterialSlot
        CurrentSlot.WBP_Com_Item_Universal_L:Init(Content)
        CurrentSlot.Switcher:SetActiveWidgetIndex(0)
        CurrentSlot.Btn_Empty.OnClicked:Clear()
        CurrentSlot.Btn_Empty.OnClicked:Add(self, function()
            if self.bInMixAnimation then return end
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
            self.ShowChooseUICallback(self.Parent, self.MergeTbl)
            CurrentSlot:PlayAnimation(CurrentSlot.Click)
        end)
        CurrentSlot.WBP_Com_BtnImg01:BindEventOnClicked(self, self.OnEmptyClicked)
        CurrentSlot.WBP_Com_BtnImg01:TryOverrideSoundFunc(function()
            AudioManager(self):PlayItemSound(self, self.ConvertContent.ShopItemId, "Click", self.ConvertContent.ItemType)
        end)
        CurrentSlot:ShowLeftTopIcon(false)
    end
    self:CollapseAllMaterialSlot(true)
    local NeedSlotCount = DataMgr.Convert[self.ConvertContent.Idx].ConvertNum
    for _, MaterialSlot in pairs(self.MaterialSlotTbl[NeedSlotCount]) do
        MaterialSlot:SetVisibility(UE4.ESlateVisibility.Visible)
    end
    if self.TextBlock_64 then
        self.TextBlock_64:SetText(GText("UI_Convert_AddResources"))
    end
end

function WBP_Forging_Convert_C:UpdateBottomState(Tbl)
    local bIsMaterialEnough = #Tbl == DataMgr.Convert[self.ConvertContent.Idx].ConvertNum
    local TextGroup = self:SeekWidgetByName("Group_Synthesis")
    if bIsMaterialEnough then
        self.Switcher:SetActiveWidgetIndex(0)
        TextGroup:SetVisibility(UE4.ESlateVisibility.Visible)
        self.WBP_Com_Slider:SetVisibility(UE4.ESlateVisibility.Visible)
    else
        self.Switcher:SetActiveWidgetIndex(1)
        TextGroup:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.WBP_Com_Slider:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function WBP_Forging_Convert_C:UpdateConfirmButtonState()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local NeedCost = self.CostCount * self.CurrentCount
    local Count = Avatar:GetResourceNum(self.CostType)
    DebugPrint("Yihan@ UpdateConfirmButtonState", Count, NeedCost)
    self.WBP_Com_BtnText01:ForbidBtn(Count < NeedCost)
    self:UpdateTextPanel()
end

-- 点击左侧装备右侧 更新改变右边显示的方法
function WBP_Forging_Convert_C:UpdateForingConvertContent(Item)
    DebugPrint("Yihan@ UpdateForingConvertContent", Item.Id, Item.Idx)
    self.ConvertContent = NewObject(UIUtils.GetCommonItemContentClass())
    local ResourceData = DataMgr.Resource[Item.Id]
    self.ConvertContent.Position = Item.Position
    self.ConvertContent.Idx = Item.Idx
    self.ConvertContent.ShopItemId = Item.Id
    self.ConvertContent.Icon = ResourceData.Icon
    self.ConvertContent.Rarity = ResourceData.Rarity

    local ConvertConfig =  DataMgr.Convert[Item.Idx]
    self.ConvertContent.ItemType = "Resource"
    self.ConvertContent.ProductType = ConvertConfig.ProductType
    self.ConvertContent.CovertId = ConvertConfig.CovertId

    if self.ConvertContent.ProductType == CommonConst.ArmoryType.Mod then
        self.Num:SetVisibility(ESlateVisibility.Collapsed)
        self.TextHas:SetVisibility(ESlateVisibility.Collapsed)
        self.Image_6:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Num:SetVisibility(ESlateVisibility.Visible)
        self.TextHas:SetVisibility(ESlateVisibility.Visible)
        self.Image_6:SetVisibility(ESlateVisibility.Visible)
        self.Num:SetText(self:GetHaveCount(Item.Id))
    end
    
    self.Shop.Item_Shop:OnListItemObjectSet(self.ConvertContent)

    self.Shop.Text_Num:SetText("x" .. tostring(DataMgr.Convert[Item.Idx].ProductNum))
    self.Shop.Text_Name:SetText(GText(ResourceData.ResourceName))
    -- 获取需要的货币类型与消耗，并更改图标
    for CostType, CostCount in pairs(DataMgr.Convert[Item.Idx].ConvertCost) do
        self.CostType = CostType
        self.CostCount = CostCount
    end
    self.WBP_Com_ItemIcon.Icon = DataMgr.Resource[self.CostType].Icon
    self.WBP_Com_ItemIcon:SetIcon()
    
    -- 播放刷新动效
    self:PlayAnimation(self.Item_Refresh)
end

-- 更新材料槽
function WBP_Forging_Convert_C:UpdateMaterialSlot(ChoosedTbl, IsShow)
    DebugPrint("Yihan@ WBP_Forging_Convert_C.UpdateMaterialSlot", ChoosedTbl, #ChoosedTbl)
    -- 对相同的进行合并操作
    self.MergeTbl = {}
    self.CurrentCount = 1
    self.HasAnyModLocked = false
    local Seen = {} -- 记录已处理的ResourceId
    for _, Content in ipairs(ChoosedTbl) do
        if not Seen[Content.Id] then
            local NewItem = {
                Id = Content.Id,
                ItemId = Content.UnitId,
                Icon = Content.Icon,
                Rarity = Content.Rarity,
                ItemType = Content.ItemType,
                ChoosedCount = 1,
                ---@region 魔之楔相关
                Uuid = Content.Uuid,
                ModId = Content.UnitId,
                UnitId = Content.UnitId,
                IsMod = Content.ProductType == CommonConst.ArmoryType.Mod,
                LockType = Content.LockType,
                IsLocked = Content.IsLocked,
                ---endregion
            }
            if Content.IsLocked then
                self.HasAnyModLocked = true
            end
            table.insert(self.MergeTbl, NewItem)
            Seen[Content.Id] = #self.MergeTbl
        else
            local ExistIndex = Seen[Content.Id]
            self.MergeTbl[ExistIndex].ChoosedCount = self.MergeTbl[ExistIndex].ChoosedCount + 1
        end
    end
    if IsShow then
        -- 折叠所有的材料槽
        self:CollapseAllMaterialSlot(true)
        for _, CanvasPanel in ipairs(self.MaterialSlotTbl[#self.MergeTbl]) do
            CanvasPanel:SetVisibility(UE4.ESlateVisibility.Visible)
        end
        -- 将数据渲染到炉子下面的材料槽
        self:DataToMaterialSlot()
        self:UpdateTextPanel()
        self:UpdateConfirmButtonState()
        if self.TextBlock_64 then
            self.TextBlock_64:SetText(GText("UI_Convert_ReviseResources"))
        end
    else
        self:InitMaterialSlot()
    end
end

function WBP_Forging_Convert_C:DataToMaterialSlot()
    DebugPrint("Yihan@ WBP_Forging_Convert_C.DataToMaterialSlot", self.MergeTbl, #self.MergeTbl)
    for Index, Content in ipairs(self.MergeTbl) do
        local TotalCount = self.ConvertContent.ProductType == CommonConst.ArmoryType.Mod and self:GetModCount(Content) or self:GetHaveCount(Content.Id)
        self.MaterialSlotBPTbl[#self.MergeTbl][Index].Switcher:SetActiveWidgetIndex(1)
        Content.SelectNeedCount = Content.ChoosedCount * self.CurrentCount
        Content.SelectTotalCount = TotalCount
        Content.IsSelect = false
        Content.ProductType = self.ConvertContent.ProductType
        Content.OnMouseButtonUpEvents = {
            Obj = self,
            Callback = self.OnMaterialSlotClicked,
            Params = {Content}
        }
        self.MaterialSlotBPTbl[#self.MergeTbl][Index].WBP_Com_Item_Universal_L:Init(Content)
        self.MaterialSlotBPTbl[#self.MergeTbl][Index]:ShowLeftTopIcon(true)
    end
end

function WBP_Forging_Convert_C:UpdateTextPanel()
    DebugPrint("Yihan@ UpdateTextPanel", self.ConvertContent, self.ConvertContent.Idx, self.CurrentCount)
    local CostData = DataMgr.Convert[self.ConvertContent.Idx].ConvertCost
    local Avatar = GWorld:GetAvatar()
    local Count = Avatar:GetResourceNum(self.CostType)
    local Color = FSlateColor()
    if Count < self.CostCount * self.CurrentCount then
        self.Text_BuyNum:SetText(string.format("<W>%s</>", self.CostCount * self.CurrentCount))
    else
        self.Text_BuyNum:SetText(string.format("<Default>%s</>", self.CostCount * self.CurrentCount))
    end
    self.TextNumNow:SetText(self.CurrentCount)
    self.TextNumMax:SetText(self:GetMaxCount())
    self.Shop.Text_Num:SetText("x" .. tostring(self.CurrentCount * DataMgr.Convert[self.ConvertContent.Idx].ProductNum))
end

function WBP_Forging_Convert_C:CollapseAllMaterialSlot(bIsCollaspe)
    for _, CanvasPanel in ipairs(self.MaterialSlotTbl[5]) do
        if bIsCollaspe then
            CanvasPanel:SetVisibility(UE4.ESlateVisibility.Collapsed)
        else
            CanvasPanel:SetVisibility(UE4.ESlateVisibility.Visible)
        end
    end
end

-- 材料槽点击事件
function WBP_Forging_Convert_C:OnMaterialSlotClicked()
    if self.bInMixAnimation then return end
    self.ShowChooseUICallback(self.Parent, self.MergeTbl)
end

function WBP_Forging_Convert_C:OnConfirmConvertClicked()
    DebugPrint("Yihan@ WBP_Forging_Convert_C.OnConfirmConvertClicked", self.MergeTbl, self.ConvertContent.Id)
    local Params = {}
    Params.MergeTbl = self.MergeTbl
    Params.ConvertContent = self.ConvertContent
    Params.CurrentCount = self.CurrentCount
    -- Params.Title = "合成"
    
    local ResourceData = DataMgr.Resource[self.ConvertContent.ShopItemId]
    local ConvertName = GText(ResourceData.ResourceName) .. "x"
    local ConvertCount = DataMgr.Convert[self.ConvertContent.Idx].ProductNum
    Params.Str = string.format(GText("Convert_Popup_Content"), ConvertName .. tostring(self.CurrentCount * ConvertCount))

    local Funds = {}
    Funds[1] = {}
    Funds[1].FundId = self.CostType
    Funds[1].FundNeed = self.CostCount * self.CurrentCount
    Params.Funds = Funds
    Params.RightCallbackFunction = function()
        local Callback = {
            OnSuccess = function(Password)
                 -- 调用服务器给的rpc进行Convert
                local PlayerAvatar = GWorld:GetAvatar()
                if self.ConvertContent.ProductType == "Resource" then
                    local ConsumeResources = {}
                    for _, Data in ipairs(self.MergeTbl) do
                        ConsumeResources[Data.Id] = Data.ChoosedCount * self.CurrentCount
                    end
                    DebugPrint("Yihan@ WBP_Forging_Convert_C.OnConfirmConvertClicked", self.ConvertContent.Idx, self.CurrentCount)
                    PlayerAvatar:ConvertResource(function(ret)
                        -- 合成成功的callbcak
                        self:PlayMixAnimation()
                        self:ConvertResult()
                    end, self.ConvertContent.Idx, self.CurrentCount, ConsumeResources)
                else
                    local WillConsumeMods = {}
                    for _, Data in ipairs(self.MergeTbl) do
                        if WillConsumeMods[Data.Uuid] then
                            WillConsumeMods[Data.Uuid] = WillConsumeMods[Data.Uuid] + Data.ChoosedCount * self.CurrentCount
                        else
                            WillConsumeMods[Data.Uuid] = Data.ChoosedCount * self.CurrentCount
                        end
                        
                    end
                    PlayerAvatar:ConvertMod(function(ret, NewModIdList)
                        -- 合成成功的callbcak
                        self:PlayMixAnimation(NewModIdList)
                        self:ConvertResult()
                    end, self.ConvertContent.CovertId, self.CurrentCount, WillConsumeMods)
                end
            end
        }
        if self.HasAnyModLocked then
            SecondaryPasswordController:RequestSecPasswordValidation(Callback)
        else
            Callback.OnSuccess()
        end
    end
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    UIManager:ShowCommonPopupUI(100300, Params, self.Parent)
end

function WBP_Forging_Convert_C:PlayMixAnimation(NewModIdList)
    self.bInMixAnimation = true
    AudioManager(self):PlayUISound(self, "event:/ui/common/recast_material_in", nil, nil)
    self:AddTimer(1.15, function ()
        self:MixAnimationFinished(NewModIdList)
        self:RemoveTimer("TimeToShowGetItemUI")
    end, false, 0, "TimeToShowGetItemUI")
    self:PlayAnimation(self.Mix)
    self.Parent:PlayAnimation(self.Parent.Mix)
    self.Parent.WBP_Forging_Convert_Bg:PlayAnimation(self.Parent.WBP_Forging_Convert_Bg.Mix)
    self.Parent.Com_Tab:PlayOutAnim()
    self.Switcher:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.WBP_Com_Slider:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if self.Parent and self.Parent.UpdateGamePadUIOnConvertAnim then
        self.Parent:UpdateGamePadUIOnConvertAnim(true)
    end
end

function WBP_Forging_Convert_C:ConvertResult()
    DebugPrint("Yihan@ WBP_Forging_Convert_C.ConvertResult11111", self.ConvertContent.Position)
    self.WBP_Com_Slider:OverrideValueLimit(1, self:GetMaxCount(), 1, true)
    self:UpdateLeftListCount()
end

-- 将消耗的道具的数量更新在左边
function WBP_Forging_Convert_C:UpdateLeftListCount()
    local ListItems = self.Parent.EMList:GetListItems()
    for i = 1, ListItems:Num() do 
        local ListItem = ListItems:GetRef(i)
        local CurWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.Parent.EMList, self.Parent.EMList:GetIndexForItem(ListItem))
        if CurWidget then
            CurWidget:SetCount(self:GetHaveCount(ListItem.Id))
        end
    end
end

function WBP_Forging_Convert_C:MixAnimationFinished(NewModIdList)
    local ProductType, ConvertItemId, ItemCount
    local TargetTable 
    if self.ConvertContent.ProductType == CommonConst.ArmoryType.Mod then
        TargetTable = {}
        TargetTable[CommonConst.ArmoryType.Mod..'s'] = NewModIdList
        ProductType = CommonConst.ArmoryType.Mod
    else
        ProductType = "Resource"
        ConvertItemId = self.ConvertContent.ShopItemId
        ItemCount = DataMgr.Convert[self.ConvertContent.Idx].ProductNum * self.CurrentCount
    end
    
    -- 关闭窗口的回调
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(ProductType, ConvertItemId, ItemCount, TargetTable, false, function ()
        if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
            self.Parent:PlayAnimation(self.Parent.Mix_Out)
            self.Parent.WBP_Forging_Convert_Bg:PlayAnimation(self.Parent.WBP_Forging_Convert_Bg.Mix_Out)
        else
            self.Parent:PlayAnimation(self.Parent.MixOut)
            self.Parent.WBP_Forging_Convert_Bg:PlayAnimation(self.Parent.WBP_Forging_Convert_Bg.MixOut)
        end
        self.Parent.Com_Tab:PlayInAnim()
        self.Switcher:SetVisibility(UE4.ESlateVisibility.Visible)
        self.WBP_Com_Slider:SetVisibility(UE4.ESlateVisibility.Visible)
        if self.Parent and self.Parent.UpdateGamePadUIOnConvertAnim then
            self.Parent:UpdateGamePadUIOnConvertAnim(false)
        end
        self.Num:SetText(self:GetHaveCount(self.ConvertContent.ShopItemId))
        self:OnClearAllClicked()
        self.bInMixAnimation = false
    end, self)
end

function WBP_Forging_Convert_C:OnConfirmBtnForbidClicked()
    -- 合成点击后钱不够的提醒
    if self.bInMixAnimation then return end
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("Insufficient_Cash"))
end

function WBP_Forging_Convert_C:OnBigItemBtnForbidClicked()
    DebugPrint("Yihan@ WBP_Forging_Convert_C.OnBigItemBtnForbidClicked", self.ConvertContent.ShopItemId, self.ConvertContent.ItemType)
    if self.bInMixAnimation then return end
    AudioManager(self):PlayItemSound(self, self.ConvertContent.ShopItemId, "Click", self.ConvertContent.ItemType)
    self.Parent:RefreshItemDetails()
    self.Shop:PlayerClickAnimation()
end

function WBP_Forging_Convert_C:OnClearAllClicked()
    DebugPrint("Yihan@ WBP_Forging_Convert_C.OnClearAllClicked")
    self.MergeTbl = {}
    self:CollapseAllMaterialSlot(false)
    self:UpdateBottomState({})
    self:InitSliderValue()
    self.ClearAllCallback(self.Parent)
    self:UpdateTextPanel()
    if self.TextBlock_64 then
        self.TextBlock_64:SetText(GText("UI_Convert_AddResources"))
    end
end

function WBP_Forging_Convert_C:OnEmptyClicked()
    DebugPrint("Yihan@ WBP_Forging_Convert_C.OnEmptyClicked", self.bInMixAnimation)
    if self.bInMixAnimation then return end

    self.ShowChooseUICallback(self.Parent, self.MergeTbl)
    self:PlayAnimation(self.Click)
end

function WBP_Forging_Convert_C:ClearMergeTbl()
    self.MergeTbl = {}
end

function WBP_Forging_Convert_C:Destruct()
    for _, MaterialSlot in pairs(self.MaterialSlotBPTbl[5]) do
        MaterialSlot.Btn_Empty.OnClicked:Clear()
        MaterialSlot.WBP_Com_BtnImg01:UnBindEventOnClickedByObj(self)
    end
    self.WBP_Com_BtnText01_1:UnBindEventOnClickedByObj(self)
    self.WBP_Com_BtnText01:UnBindEventOnClickedByObj(self)
end

return WBP_Forging_Convert_C
