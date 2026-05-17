--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Angling_FishUnlock_C
local M = Class("BluePrints.UI.BP_UIState_C")
local RarityBG = {
    '/Game/UI/Texture/Dynamic/Image/Angling/T_Angling_Quality_Grey.T_Angling_Quality_Grey',
    '/Game/UI/Texture/Dynamic/Image/Angling/T_Angling_Quality_Green.T_Angling_Quality_Green',
    '/Game/UI/Texture/Dynamic/Image/Angling/T_Angling_Quality_Blue.T_Angling_Quality_Blue',
    '/Game/UI/Texture/Dynamic/Image/Angling/T_Angling_Quality_Purple.T_Angling_Quality_Purple',
    '/Game/UI/Texture/Dynamic/Image/Angling/T_Angling_Quality_Yellow.T_Angling_Quality_Yellow'
}

local RarityAnim = {
    "Grey",
    "Green",
    "Blue",
    "Purple",
    "Yellow",
}
function M:OnLoaded(...)
    local Info = ...
    print(_G.LogTag,"LXZ OnLoaded", Info.FishingSpotId, Info.FishId)
    self.DeviceInPc = CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile"
    self.FishId = Info.FishId
    self.FishingPage = Info.FishingPage
    self.FishSize = Info.FishSize
    self.FishingSpotId = Info.FishingSpotId
    self.bIsNew = Info.IsNew
    self.ExtraRewards = Info.Rewards

    self:BindToAnimationFinished(self.Out, {self, self.OnOutEnd})
    self.Btn_Empty.OnClicked:Add(self, self.OnClickEmpty)
    self.Btn_Empty:SetFocus()

    self.Text_Tips:SetText(GText("UI_TRAIN_CLOSE"))
    if self.DeviceInPc then
        self.Key_Continue_Gamepad:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "A"
                }
            },
            Desc = GText("UI_CTL_Continue"),
        })
        self.Key_Check_Gamepad:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = UIConst.GamePadImgKey.RightTriggerAnalog
                }
            },
            Desc = GText("UI_Controller_Introduction"),
        })
        self.Key_Check_Gamepad_1:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = UIConst.GamePadImgKey.FaceButtonBottom
                }
            },
            Desc = GText("UI_Controller_CheckDetails"),
        })
        self.Key_Back_Gamepad:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight
                }
            },
            Desc = GText("UI_BACK"),
        })
        self.Key_Extra_GamePad:CreateGamepadKey(UIConst.GamePadImgKey.LeftThumb)
    end
    self:InitUnLockWidget()
    self:InitExtraRewardList()

    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshInfoByInputTypeChange)
    self.CurMode = self.GameInputModeSubsystem:GetCurrentInputType()
    self:RefreshInfoByInputTypeChange(self.CurMode)

    self:BindToAnimationFinished(self.Get_In, {self, self.OnINEnd})
    self.VX_Waterwave:SetVisibility(ESlateVisibility.HitTestInvisible)
end

function M:OnClickEmpty()
    if self:IsPlayingAnimation(self.Get_In) then
        return
    end
    self:PlayAnimation(self.Out)
end

function M:OnINEnd()
    if not UIUtils.CheckScrollBoxCanScroll(self.Scroll_Box) then
        self.Key_Check_Gamepad:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:OnOutEnd()
    local ResourceId = DataMgr.Fish[self.FishId].ResourceId
    UIUtils.ShowHudReward(GText("UI_Fishing_Reward"), {{
        ItemType = "Resource",
        ItemId = ResourceId,
        Count = 1,
        Rarity = ItemUtils.GetItemRarity(ResourceId, "Resource")
    }})
    -- UIUtils.ShowGotItemTipsUI("Resource", ResourceId, 1)
    self:Close()
end

function M:InitUnLockWidget()
    local Data = DataMgr.Fish[self.FishId]
    if not Data or not Data.ResourceId then
        GWorld.logger.error("鱼"..self.FishId.."没有数据或资源id")
        return
    end
    local ResourceData = DataMgr.Resource[Data.ResourceId]
    if not ResourceData then
        GWorld.logger.error("鱼资源"..Data.ResourceId.."没有资源数据")
        return
    end

    local IconPath = DataMgr.Fish[self.FishId].IconPath
    if IconPath then
        local Icon = LoadObject(IconPath)
        self.Icon_Fish:SetBrushResourceObject(Icon)
    end
    if Data.FishType == 3 then
        self.Panel_Title:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Text_Title:SetText(GText("UI_Fishing_FishType_3"))
        self.Text_Title:SetColorAndOpacity(self.Text_King)
        self.WS_Type:SetActiveWidgetIndex(0)
    elseif Data.FishType == 2 then
        self.Panel_Title:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Text_Title:SetText(GText("UI_Fishing_FishType_2"))
        self.Text_Title:SetColorAndOpacity(self.Text_Variation)
        self.WS_Type:SetActiveWidgetIndex(1)
    elseif Data.FishType == 4 then
        self.Panel_Title:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Text_Title:SetText(GText("UI_Fishing_FishType_4"))
        self.Text_Title:SetColorAndOpacity(self.Text_Variation)
        self.WS_Type:SetActiveWidgetIndex(1)
    else
        self.Panel_Title:SetVisibility(ESlateVisibility.Collapsed)
    end
    local Rarity = ResourceData.Rarity
    local Icon = LoadObject(RarityBG[Rarity])
    self.Img_Quality:GetDynamicMaterial():SetTextureParameterValue("MainTex", Icon)
    self:PlayAnimation(self[RarityAnim[Rarity]])
    if self.bIsNew then
        if Rarity > 3 then
            self:PlayAnimation(self.Unlock_SSR)
        else
            self:PlayAnimation(self.Unlock_R)
        end
    else
        self:PlayAnimation(self.Get_In)
    end
    if Rarity ~= 5 then
        AudioManager(self):PlayUISound(self, "event:/ui/minigame/fish_info_unlock", nil, nil)
    else
        AudioManager(self):PlayUISound(self, "event:/ui/minigame/fish_info_unlock_gold", nil, nil)
    end
    -- self.Img_Quality:SetBrushResourceObject(Icon)
    self.Text_FishName:SetText(GText(ResourceData.ResourceName))
    self.Text_Describe:SetText(GText(ResourceData.DetailDes))
    self.Text_Lv:SetText(Data.FishLevel)
    -- self.Img_Icon:SetBrushFromTexture(LoadObject(PartyNpcData.AvatarIconPath))
    self.List_Text:ClearListItems()
    local Weight = self:GetWeight()
    local WeightContent = self:NewTextContent('/Game/UI/Texture/Dynamic/Atlas/Angling/T_Angling_Size.T_Angling_Size', Weight)
    self.List_Text:AddItem(WeightContent)

    local Place = self:GetPlace()
    local PlaceContent = self:NewTextContent('/Game/UI/Texture/Dynamic/Atlas/Angling/T_Angling_Location.T_Angling_Location', Place)
    self.List_Text:AddItem(PlaceContent)

    if self.bIsNew then
        self.New:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Text_Top:SetText(GText("UI_Fishing_UnlockFishBook"))
        self.Text_VX:SetText(GText("UI_Fishing_UnlockFishBook"))
    else
        self.New:SetVisibility(ESlateVisibility.Collapsed)
        self.Text_Top:SetText(GText("UI_Fishing_Success"))
        self.Text_VX:SetText(GText("UI_Fishing_Success"))
    end

    local Text, FishAppearPeriod = self:GetDayNight()
    local DayNightContent = self:NewTextContent('/Game/UI/Texture/Dynamic/Atlas/Angling/T_Angling_Time.T_Angling_Time', Text, FishAppearPeriod)
    self.List_Text:AddItem(DayNightContent)
end

function M:GetWeight()
    --如果Weight是-1，这个面板是隐藏的，所以无所谓
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return 10
    end
    return self.FishSize
end

function M:GetPlace()
    local SpotData = DataMgr.FishingSpot[self.FishingSpotId]
    if not SpotData or not SpotData.FishingSpotName then
        return "找不到钓鱼点"
    end
    local Name = SpotData.FishingSpotName
    return Name
end

function M:GetDayNight()
    local Data = DataMgr.Fish[self.FishId]
    if not Data then
        return "找不到鱼数据", nil
    end
    local FishAppearPeriod = Data.FishAppearPeriod
    if not FishAppearPeriod then
        return "找不到鱼活跃时段", nil
    end
    return nil, FishAppearPeriod
end

function M:NewTextContent(IconPath, Text, FishAppearPeriod)
    local Class = LoadClass('/Game/UI/WBP/Angling/Widget/Angling_TextItem_Content.Angling_TextItem_Content')
    local Obj = NewObject(Class)
    Obj.IconPath = IconPath
    Obj.Text = Text
    if FishAppearPeriod then
        Obj.IsTime = true
        for i, v in pairs(FishAppearPeriod) do
            if v == 1 then
                Obj.IsMorn = true
            elseif v == 2 then
                Obj.IsNoon = true
            elseif v == 3 then
                Obj.IsNight = true
            end
        end
    end
    return Obj
end

function M:Play_ItemGlow()
    if self.ExtraRewards then
        AudioManager(self):PlayUISound(self, "event:/ui/minigame/fish_info_unlock_bonus", nil, nil)
    end

end

function M:InitExtraRewardList()
    self.List_ExtraItem:ClearListItems()
    if not self.ExtraRewards then
        self.Panel_Extra:SetVisibility(ESlateVisibility.Collapsed)
    else
        AudioManager(self):PlayUISound(self, "event:/ui/minigame/fish_info_unlock_bonus", nil, nil)
        self.Text_Extra:SetText(GText("UI_Fishing_ExtraReward"))
        self.Panel_Extra:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        -- self.VX_List:SetVisibility(ESlateVisibility.HitTestInvisible)
        if self.ExtraRewards.PetUniqueId then
            local Avatar = GWorld:GetAvatar()
            local PetUnique = Avatar.Pets[self.ExtraRewards.PetUniqueId]
            local Entry = PetUnique.Entry
            local EntryList = {}
            for i, v in pairs(Entry) do
                table.insert(EntryList, v)
            end
            local Content = self:NewItemContent("Pet", PetUnique.PetId, nil, EntryList)
            Content.Type = "Pet"
            Content.BreakNum = 0
            Content.IsPremium = false
            self.List_ExtraItem:AddItem(Content)
        else
            for RewardType, RewardInfo in pairs(self.ExtraRewards) do
                local RealType = string.gsub(RewardType, "s$", "")
                for ItemId, ItemTable in pairs(RewardInfo) do
                    local Content = self:NewItemContent(RealType, ItemId, ItemTable["1"])
                    self.List_ExtraItem:AddItem(Content)
                end
            end
        end
    end
end
function M:NewItemContent(ItemType, ItemId, Count, EntryIds)
    if ItemId == 0 or not DataMgr[ItemType] then
        return nil
    end
    local ItemData = DataMgr[ItemType][ItemId]
    if not ItemData then
        print(_G.LogTag, "Error: Item Data is nil, ItemType:", ItemType, "ItemId", ItemId)
        return nil
    end
    --新建一个通用道具框数据对象
    print(_G.LogTag,"LXZ NewItemContent", ItemId, Count, ItemData.Icon, EntryIds)
    PrintTable(EntryIds)
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.ItemType = ItemType:gsub("^%l",string.upper)
    Obj.Id = ItemId
    Obj.Rarity = ItemData.Rarity or ItemData.WeaponRarity or 1
    Obj.Icon = ItemData.Icon
    Obj.Count = Count
    Obj.IsShowDetails = true
    Obj.PetEntry = EntryIds
    return Obj
end

function M:Play_ItemGlow()
    for _, Widget in pairs(self.List_ExtraItem:GetDisplayedEntryWidgets()) do
        if Widget.Content then
            Widget.Content.bNewGlow = true
            Widget:SetNewGlow(true)
        end
    end
end

function M:RefreshInfoByInputTypeChange(CurInputDevice, CurGamepadName)
    if CurInputDevice == ECommonInputType.MouseAndKeyboard and self.DeviceInPc then
        self.Switcher_Text:SetActiveWidgetIndex(0)
        self.Key_Extra_GamePad:SetVisibility(ESlateVisibility.Collapsed)
        self.Scroll_Box:SetVisibility(ESlateVisibility.Visible)
    elseif CurInputDevice == ECommonInputType.Gamepad and self.DeviceInPc then
        self.Switcher_Text:SetActiveWidgetIndex(1)
        self.Key_Extra_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Scroll_Box:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    elseif CurInputDevice == ECommonInputType.Touch then
        self.Switcher_Text:SetActiveWidgetIndex(0)
        self.Key_Extra_GamePad:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if(InKeyName == "Gamepad_RightX")then
        self.MoveDeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    elseif(InKeyName == "Gamepad_RightY")then
        self.MoveDeltaY = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    end
    local InKeyName = nil
    if self.MoveDeltaY and self.MoveDeltaY ~= 0 then
        if self.MoveDeltaY > 0.5 then
            InKeyName = "Gamepad_RightStick_Up"
        elseif self.MoveDeltaY < -0.5 then
            InKeyName = "Gamepad_RightStick_Down"
        end
        local DeltaOffset = (-1) * UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
        local CurrentOffset = self.Scroll_Box:GetScrollOffset()
        local NextOffset = math.clamp(CurrentOffset + DeltaOffset,0, self.Scroll_Box:GetScrollOffsetOfEnd())
        self.Scroll_Box:SetScrollOffset(NextOffset)
    end
    self.MoveDeltaY = 0
    self.MoveDeltaY = 0
    return UIUtils.Handled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    if not self.DeviceInPc then
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName == "Gamepad_LeftThumbstick" then
            self:OnClickLeftThumbstick()
        elseif InKeyName == "Gamepad_FaceButton_Right" then
            self:OnClickFaceButtonRight()
        elseif InKeyName == "Gamepad_FaceButton_Bottom" then
            self:OnClickFaceButtonBottom()
        end
    end
    if InKeyName == "Escape" then
        self:OnClickEmpty()
    end
end

function M:OnClickLeftThumbstick()
    if self.Switcher_Text:GetActiveWidgetIndex() == 1 then
        self.List_ExtraItem:SetFocus()
        self.Switcher_Text:SetActiveWidgetIndex(2)
        self.Key_Extra_GamePad:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:OnClickFaceButtonRight()
    if self.Switcher_Text:GetActiveWidgetIndex() == 2 then
        self:SetFocus()
        self.Switcher_Text:SetActiveWidgetIndex(1)
        self.Key_Extra_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

function M:OnClickFaceButtonBottom()
    if self.Switcher_Text:GetActiveWidgetIndex() == 1 then
        self:OnClickEmpty()
    end
end

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
