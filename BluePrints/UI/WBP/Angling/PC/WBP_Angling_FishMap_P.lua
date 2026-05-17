--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Angling_FishMap_P_C
local M = Class("BluePrints.UI.BP_UIState_C")

function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    local Info = ...
    self.DefaultFishingSpotId = Info.FishingSpotId
    self.DefaultFishingRegionId = DataMgr.FishingSpot2FishingRegion[self.DefaultFishingSpotId] or 1
    self.DefaultFishResourceId = Info.FishResourceId
    if not self.DefaultFishResourceId then
        self.DefaultFishId = Info.FishId
    else
        self.DefaultFishId = DataMgr.ResourceId2FishId[self.DefaultFishResourceId]
        self.DefaultFishingSpotId = self:GetFishSpotId(self.DefaultFishId)
    end
    if not self.DefaultFishId then
        self.DefaultFishId = 101
    end
    if not self.DefaultFishingSpotId then
        GWorld.logger.error("没有找到钓鱼点数据，鱼id："..self.DefaultFishId.."，请检查鱼点表的鱼类列表")
        self.DefaultFishingSpotId = 10010101
    end
    self.RegionPointId = DataMgr.FishingSpot[self.DefaultFishingSpotId].RegionPointId
    self.RegionList = {}
    self.SpotList = {}
    self.DeviceInPc = CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile"

    -- self.List_Item.BP_OnEntryInitialized:Add(self, self.BP_OnEntryInitialized)

    self:InitCommonWidget()

    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshInfoByInputTypeChange) 
    self.CurMode = self.GameInputModeSubsystem:GetCurrentInputType()
    self:RefreshInfoByInputTypeChange(self.CurMode)

    if self.DeviceInPc then
        self.Key_GamePad:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Img",
                    ImgShortPath = "LS",
                }
            },
            -- Desc = GText('UI_GACHA_DESDETAIL'),
        })
    end
    self:PlayAnimation(self.In)
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "AnglingMapOpen", nil)
end

function M:InitCommonWidget()
    self.CurrentContentIdx = 1
    self:InitCommonTab()
    --打开时默认选中对应的钓鱼点的图鉴
    self:UpdateFishMapItem()

    self.BtnText:SetText(GText("UI_Fishing_TrackFishingSpot"))
    self.BtnText:BindEventOnClicked(self, self.OnClickTrackSpot)
    self.BtnText:TryOverrideSoundFunc(function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    end)
    self.BtnText:SetGamePadImg("Y")

    if self.DeviceInPc then
        self.Key_GamePad:CreateCommonKey({KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "LS",
            },
        },})
    end

    self.Btn_Click.OnClicked:Add(self, self.OnClickReward)
    self.Text_Tips:SetText(GText("UI_Wiki_Reward_Title"))

    self:CheckCompleteAchieveCount()
end

function M:InitCommonTab()
    local TabList = {}
    for FishingRegionId, Data in pairs(DataMgr.FishingRegion) do
        local IconPath = Data.IconPath or "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Angling01.T_Tab_Angling01"
        local Tab =
        {
            Text = GText(Data.FishingRegionName),
            ShowRedDot = false,
            IsNew = false,
            IconPath = IconPath,
            IsLocked = false,
            IsForbidden = false,
            LockReasonText = GText("UI_RegionMap_MaxMark"),
            FishingRegionId = FishingRegionId,
            IconId = Data.IconId or 0
        }
        table.insert(TabList, Tab)
    end
    table.sort(TabList, function(a, b) return a.IconId < b.IconId end)

    local FishRegion2Tab = {}
    local CurrentTabId = 1
    self.CurrentTabIndex = 1
    for i, v in pairs(TabList) do
        v.TabId = CurrentTabId
        self.RegionList[CurrentTabId] = v.FishingRegionId
        if v.FishingRegionId == self.DefaultFishingRegionId then
            self.CurrentTabIndex = CurrentTabId
        end
        CurrentTabId = CurrentTabId + 1
        FishRegion2Tab[v.FishingRegionId] = CurrentTabId
    end
    local PlatformName = CommonConst.CLIENT_DEVICE_TYPE.PC
    if not self.DeviceInPc then
        PlatformName = CommonConst.CLIENT_DEVICE_TYPE.MOBILE
    end
    self.Com_Tab:Init({
        LeftKey = "Q",
        RightKey = "E",
        Tabs = TabList,
        PlatformName = PlatformName,
        DynamicNode = {"Back", "BottomKey", "Tip"},
        OwnerPanel=self,
        BackCallback=self.OnClickReturn,
        StyleName = "TextImage",
        BottomKeyInfo = {
                            {
                                KeyInfoList = {{Type="Text", Text="", Owner=self}}, 
                                GamePadInfoList = {{Type="Img", ImgShortPath=UIConst.GamePadImgKey.RightTriggerAnalog, Owner=self}}, 
                                Desc = GText("UI_Controller_Introduction"), bLongPress = false
                            },
                            {
                                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.OnClickReturn, Owner=self}},
                                GamePadInfoList = {{Type="Img", ImgShortPath="B", Owner=self}},
                                Desc = GText("UI_BACK"), bLongPress = false
                            },
                        },
        TitleName = GText("UI_Fishing_FishBook"),
    })
    self.Com_Tab:UpdateSingleBottomKeyInfo(1, {})

    local EMCache = require "EMCache.EMCache"
    local UnLockMapData = EMCache:Get("FishMapUnLockData", true)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local FishingBook = DataMgr.FishingBook
        for FishId, BookData in pairs(FishingBook) do
            local Count = Avatar:GetFishCountByFishId(FishId)
            if Count > 0 then
                if not UnLockMapData or not UnLockMapData[FishId] or UnLockMapData[FishId] == 0 then
                    local SpotId = BookData.FishingSpot
                    local FishRegionId = DataMgr.FishingSpot2FishingRegion[SpotId]
                    local NeedNewTabId = FishRegion2Tab[FishRegionId]
                    print(_G.LogTag,"LXZ InitCommonTab", FishId, SpotId, FishRegionId, NeedNewTabId)
                    self.Com_Tab:ShowTabRedDotByTabId(NeedNewTabId - 1, true, false, false)
                end
            end
        end
    end

    self.Com_Tab:BindEventOnTabSelected(self, self.OnTabChanged)
    self.Com_Tab:SelectTab(self.CurrentTabIndex)
end

function M:UpdateFishMapRegion()
    local SubTabList = {}
    local FishingRegionId = self.RegionList[self.CurrentTabIndex]
    local RegionData = DataMgr.FishingRegion[FishingRegionId]
    if not RegionData or not RegionData.FishingSpotList then
        GWorld.logger.error("鱼区域"..self.DefaultFishingRegionId.."没有鱼点列表数据")
    end
    for _, SpotId in pairs(RegionData.FishingSpotList) do
        local Data = DataMgr.FishingSpot[SpotId]
        if Data.ShowInFishMap then
            local IconPath = Data.IconPath or "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Angling01.T_Tab_Angling01"
            local Tab =
            {
                Text = GText(Data.FishingSpotName),
                ShowRedDot = false,
                IsNew = false,
                IconPath = IconPath,
                IsLocked = false,
                IsForbidden = false,
                LockReasonText = GText("UI_RegionMap_MaxMark"),
                SpotId = SpotId,
                IconId = Data.IconId or 0
            }
            table.insert(SubTabList, Tab)
        end
    end
    if #SubTabList > 0 then
        table.sort(SubTabList, function(a, b) return a.IconId < b.IconId end)
        self.CurrentSubTabIndex = 1
        if not self.SpotList[self.CurrentTabIndex] then
            self.SpotList[self.CurrentTabIndex] = {}
        end
        local CurrentSubTabIndex = 1
        for _, SpotTab in pairs(SubTabList) do
            SpotTab.TabId = CurrentSubTabIndex
            self.SpotList[self.CurrentTabIndex][CurrentSubTabIndex] = SpotTab.SpotId
            if SpotTab.SpotId == self.DefaultFishingSpotId then
                self.CurrentSubTabIndex = CurrentSubTabIndex
            end
            CurrentSubTabIndex = CurrentSubTabIndex + 1
        end
        local PlatformName = CommonConst.CLIENT_DEVICE_TYPE.PC
        if not self.DeviceInPc then
            PlatformName = CommonConst.CLIENT_DEVICE_TYPE.MOBILE
        end
        self.Com_SubTab:Init({
            LeftKey = "A",
            RightKey = "D",
            -- ChildWidgetName = "TabSubItem6",
            Tabs = SubTabList,
            PlatformName = PlatformName,
            DynamicNode = {"Back", "BottomKey", "Tip"},
            OwnerPanel=self,
            StyleName = "Text",
        })

        local Avatar = GWorld:GetAvatar()
        local EMCache = require "EMCache.EMCache"
        local UnLockMapData = EMCache:Get("FishMapUnLockData", true)
        if Avatar then
            for _, SpotTab in pairs(SubTabList) do
                local FishIdList = DataMgr.FishingSpot2Fish[SpotTab.SpotId]
                if FishIdList then
                    for _, FishId in pairs(FishIdList) do
                        local Count = Avatar:GetFishCountByFishId(FishId)
                        if Count > 0 then
                            if not UnLockMapData or not UnLockMapData[FishId] or UnLockMapData[FishId] == 0 then
                                self.Com_SubTab:ShowTabRedDotByTabId(SpotTab.TabId, true, false, false)
                                break
                            end
                        end
                    end
                end
            end
        end
        self.Com_SubTab:BindEventOnTabSelected(self, self.OnSubTabChanged)
        self.Com_SubTab:SelectTab(self.CurrentSubTabIndex)
        if #SubTabList <= 1 then
            self.SubTab:SetVisibility(ESlateVisibility.Collapsed)
        else
            self.SubTab:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
    else
        self.List_Item:BP_ClearSelection()
        self.List_Item:ClearListItems()
    end
end

function M:UpdateFishMapItem()
    self.List_Item:BP_ClearSelection()
    self.List_Item:ClearListItems()
    local SpotId = self.SpotList[self.CurrentTabIndex][self.CurrentSubTabIndex]
    if not DataMgr.FishingSpot[SpotId] or not DataMgr.FishingSpot[SpotId].FishId then
        GWorld.logger.error("鱼点"..SpotId.."没有数据，或者没有鱼的数据")
        return
    end
    local List = {}
    for i, FishId in ipairs(DataMgr.FishingSpot[SpotId].FishId) do
        local ResourceId = DataMgr.Fish[FishId].ResourceId
        local Rarity = ItemUtils.GetItemRarity(ResourceId, "Resource")
        if not DataMgr.FishingBook[FishId] or not DataMgr.FishingBook[FishId].FishingSpot then
            GWorld.logger.error("鱼"..FishId.."没有所属钓鱼点数据")
        end
        local FishSpotId = DataMgr.FishingBook[FishId].FishingSpot
        if FishSpotId == SpotId then
            table.insert(List, {FishId = FishId, Rarity = Rarity, Idx = i})
        end
    end
    table.sort(List, function(a, b)
        if a.Rarity == b.Rarity then
            return a.Idx < b.Idx
        else
            return a.Rarity > b.Rarity
        end
    end)
    for i, FishTable in pairs(List) do
        local Content = self:NewMapContent(FishTable.FishId, i)
        if Content then
            if i == self.CurrentContentIdx then
                self.List_Item:BP_SetItemSelection(Content, true)
            end
            self.List_Item:AddItem(Content)
        end
    end
    self.List_Item:SetFocus()
end

function M:OnTabChanged(TabWidget)
    self.CurrentTabIndex = TabWidget.Idx
    -- self.Com_Tab:ShowTabRedDotByTabId(TabWidget.Idx, false, false, false)
    self:UpdateFishMapRegion()
    -- self:UpdateFishMapItem()
end

function M:OnSubTabChanged(TabWidget)
    self.CurrentSubTabIndex = TabWidget.Idx
    self.Com_SubTab:ShowTabRedDotByTabId(TabWidget.Idx, false, false, false)
    local AllItemCount = self.Com_SubTab.List_Tab:GetChildrenCount()
    local bMainTabNew = false
    for i = 1, AllItemCount, 1 do
        local SubTab = self.Com_SubTab.List_Tab:GetChildAt(i - 1)
        if SubTab.IsNew then
            bMainTabNew = true
            break
        end
    end
    if not bMainTabNew then
        self.Com_Tab:ShowTabRedDotByTabId(self.CurrentTabIndex, false, false, false)
    end
    self:UpdateFishMapItem()
    -- self:UpdateFishMapItem()
end

function M:OnClickTrackSpot()
    local SpotId = self.SpotList[self.CurrentTabIndex][self.CurrentSubTabIndex]
    self.RegionPointId = DataMgr.FishingSpot[SpotId].RegionPointId
    if not self.RegionPointId then
        GWorld.logger.error("LXZ OnClickTrackSpot 鱼点不存在地图图标编号， 鱼点Id:", self.DefaultFishingSpotId)
        return
    end
    local ConditionId = DataMgr.RegionPoint[self.RegionPointId].UnlockConditionId
    local Avatar = GWorld:GetAvatar()
    if ConditionId and Avatar and not ConditionUtils.CheckCondition(Avatar, ConditionId) then
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Fishing_FishingSpotLocked"))
        return
    end
    local SubRegionId = DataMgr.RegionPoint[self.RegionPointId].SubRegion
    local RegionId = DataMgr.SubRegion[SubRegionId].RegionId
    if RegionId then
        print(_G.LogTag,"LXZ OnClickTrackSpot", SubRegionId, RegionId, self.RegionPointId, self.RegionPointId)
        UIManager(self):LoadUINew("LevelMapMain", false, RegionId, "RegionPoint", self.RegionPointId)
    end
end

function M:OnClickReturn(TabWidget)
    AudioManager(self):SetEventSoundParam(self, "AnglingMapOpen", {ToEnd = 1})
    self:Close()
end

function M:OnClickReward(TabWidget)
    print(_G.LogTag,"LXZ OnClickReward")
    local ConfigData = {
        Items = {},
        ShowIcon=false,
        IconPath="",
        Text_Total=GText("UI_Fishing_FishingBookTotal"),
        NumMax = 0,
        NowNum = 1,
        ReceiveAllCallBack = self.GetAllRewards,
        ReceiveAllParam = {},
        ReceiveButtonText = GText("UI_Fishing_GetReward"),
        SortType = 2,
    }
    local AchievementList=DataMgr.FishingAchievement
    local List = {}
    for i, v in pairs(AchievementList) do
        table.insert(List,v)
    end
    table.sort(List, function(a, b)
        return a.FishingAchievementId < b.FishingAchievementId
    end)
    local TabId = 1
    local CompleteAchive = 0
    for i, v in pairs(List) do
        local Item = self:CreateArchieveTable(v.FishingAchievementId, v, TabId)
        table.insert(ConfigData.Items, Item)
        TabId = TabId + 1
        if Item.CanReceive or Item.RewardsGot then
            CompleteAchive = CompleteAchive + 1
        end
    end
    ConfigData.NumMax = TabId - 1
    ConfigData.NowNum = CompleteAchive
    -- table.insert(ConfigData.Items, Item1)
    UIManager(self):ShowCommonPopupUI(100178,{ConfigData = ConfigData,
                                                CloseBtnCallbackObj = self,
                                                CloseBtnCallbackFunction = self.CheckCompleteAchieveCount
                                                },self)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    print(_G.LogTag,"LXZ OnKeyDown", InKeyName)
    if InKeyName == "Escape" or InKeyName == "Gamepad_FaceButton_Right" then
        self:OnClickReturn()
    elseif InKeyName == "Gamepad_FaceButton_Top" then
        self:OnClickTrackSpot()
    elseif InKeyName == "Gamepad_LeftThumbstick" then
        self:OnClickReward()
    else
        if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
            self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName)
            self.Com_SubTab:Handle_KeyEventOnGamePad(InKeyName)
        else
            self.Com_Tab:Handle_KeyEventOnPC(InKeyName)
            self.Com_SubTab:Handle_KeyEventOnPC(InKeyName)
        end
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:GetRewards(Content)
    --Avatar发奖
    print(_G.LogTag,"LXZ Avatar发奖", Content.ConfigData.ReceiveParm.AchievementId)
    local AchievementId = Content.ConfigData.ReceiveParm.AchievementId
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local function  CallBack(Ret, Reward)
            local FishiAchv = Avatar.FishAchvs[AchievementId]
            Content.ConfigData.CanReceive = FishiAchv:IsComplete() and FishiAchv:CanRecvReward()
            Content.ConfigData.RewardsGot = not FishiAchv:CanRecvReward()
            Content.SelfWidget:RefreshBtn(Ret==0)
            local HaveReWardToGet=false
            for i = 0,Content.Owner.List_Item:GetNumItems() - 1 do
                local Item = Content.Owner.List_Item:GetItemAt(i)
                local AchievementId = Item.ConfigData.AchievementId
                local FishiAchv = Avatar.FishAchvs[AchievementId]
                local CanReceive= FishiAchv:IsComplete() and FishiAchv:CanRecvReward()
                if CanReceive then
                    HaveReWardToGet=true
                end
            end
            Content.SelfWidget.Owner:RefreshButton(HaveReWardToGet)
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Reward, false, nil, self, false)
        end
        Avatar:GetFishAchvReward(AchievementId, CallBack)
    end
end

function M:GetAllRewards(ReceiveAllParam)
    --Avatar发奖
    print(_G.LogTag,"LXZ Avatar全部发奖", ReceiveAllParam.AchievementId)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local function CallBack(Ret,Reward)
            local HaveReWardToGet=false
            for i = 0,ReceiveAllParam.SelfWidget.List_Item:GetNumItems() - 1 do
                local Item = ReceiveAllParam.SelfWidget.List_Item:GetItemAt(i)
                local AchievementId = Item.ConfigData.AchievementId
                local FishiAchv = Avatar.FishAchvs[AchievementId]
                local CanReceive= FishiAchv:IsComplete() and FishiAchv:CanRecvReward()
                print(_G.LogTag,"LXZ Avatar全部发奖 cb 1", AchievementId, CanReceive, ReceiveAllParam.SelfWidget.List_Item:GetNumItems())
                if CanReceive then
                    HaveReWardToGet=true
                end
                Item.ConfigData.CanReceive=CanReceive
                Item.ConfigData.RewardsGot=FishiAchv:IsComplete() and not FishiAchv:CanRecvReward()
                if Item.SelfWidget then
                    Item.SelfWidget:RefreshBtn(not CanReceive)
                end
            end
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Reward, false, nil, self, false)
            ReceiveAllParam.SelfWidget:RefreshButton(HaveReWardToGet)
        end
        Avatar:GetAllFishAchvReward(CallBack)
    end
end

function M:NewMapContent(FishId, Idx)
    local Class = LoadClass('/Game/UI/WBP/Angling/Widget/Angling_FishMap_Item_Content.Angling_FishMap_Item_Content')
    local Obj = NewObject(Class)
    Obj.FishId = FishId
    Obj.ContentIdx = Idx
    return Obj
end

function M:GetRewardsIcons(RewardId)
    local Res = {}
    local RewardInfo = DataMgr.Reward[RewardId]
    for i, v in pairs(RewardInfo.Id) do
        local Obj = self:GetRewardIcon(RewardInfo, i)
        table.insert(Res, Obj)
    end
    return Res
end

function M:GetRewardIcon(RewardInfo, RewardIndex)
    local Type = RewardInfo.Type[RewardIndex]
    local Id = RewardInfo.Id[RewardIndex]
    print(_G.LogTag,"LXZ GetRewardIcon", RewardIndex, Id, ItemUtils.GetItemRarity(Id, Type))
    local ItemData = DataMgr[Type][Id]
    local Class = LoadClass('/Game/UI/UI_PC/Common/Common_Item_subsize_PC_Content.Common_Item_subsize_PC_Content_C')
    local Res = {
        ItemType = Type,
        ItemId = Id,
        Count = RewardUtils:GetCount(RewardInfo.Count[RewardIndex]),
        Rarity = ItemUtils.GetItemRarity(Id, Type)
    }
    return Res
end

function M:CreateArchieveTable(AchievementId, Data, TabId)
    local Item = {
        ItemId = TabId,
        CanReceive= true,
        RewardsGot= false,
        InProgress= true,
        Rewards={},
        Nums=1,
        NotreachText="UI_GameEvent_ToBeFinished",
        Hint=string.gsub(GText(Data.Describe), '#1', Data.Target),
        ReceiveCallBack=self.GetRewards,
        LeftAligned=false,
        ReceiveParm={AchievementId = AchievementId},
        -- SourceNum = 1,
        NotShowNum = true,
        AchievementId = AchievementId,
        ReceiveButtonText = GText("UI_Achievement_GetReward")
    }
    Item.Rewards = self:GetRewardsIcons(Data.RewardId)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local FishiAchv = Avatar.FishAchvs[AchievementId]
        Item.CanReceive = FishiAchv:IsComplete() and FishiAchv:CanRecvReward()
        Item.RewardsGot = not FishiAchv:CanRecvReward()
        print(_G.LogTag,"LXZ CreateArchieveTable", AchievementId, FishiAchv:IsComplete(), FishiAchv:CanRecvReward())
    end
    return Item
end

function M:CheckCompleteAchieveCount()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local Count = 0
    local CanReceiveCount = 0
    local CompleteCount = 0
    local AchievementList=DataMgr.FishingAchievement
    for AchievementId, Data in pairs(AchievementList) do
        local FishiAchv = Avatar.FishAchvs[AchievementId]
        if FishiAchv:IsComplete() then
            CompleteCount = CompleteCount + 1
            if FishiAchv:CanRecvReward() then
                CanReceiveCount = CanReceiveCount + 1
            end
        end
        Count = Count + 1
    end
    print(_G.LogTag,"LXZ CheckCompleteAchieveCount000", CanReceiveCount)
    if CanReceiveCount > 0 then
        self:PlayAnimation(self.Reward_Remind)
        self.Reddot:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self:PlayAnimation(self.No_Reward)
        self.Reddot:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.Text_Num:SetText(CompleteCount.."/"..Count)
end

function M:RefreshInfoByInputTypeChange(CurInputDevice, CurGamepadName)
    self.CurMode = CurInputDevice
    if CurInputDevice == ECommonInputType.MouseAndKeyboard and self.DeviceInPc then
        self.Key_GamePad:SetVisibility(ESlateVisibility.Collapsed)
    elseif CurInputDevice == ECommonInputType.Gamepad and self.DeviceInPc then
        self.Key_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    elseif CurInputDevice == ECommonInputType.Touch then
        -- self.Key_GamePad:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:GetFishSpotId(FishId)
    -- local Data = DataMgr.Fish2FishingSpot[FishId]
    -- if not Data then
    --     return
    -- end
    -- for SpotId, Weight in pairs(Data) do
    --     local SpotData = DataMgr.FishingSpot[SpotId]
    --     if SpotData then
    --         return SpotId
    --     end
    -- end
    if DataMgr.FishingBook[FishId] then
        local SpotId = DataMgr.FishingBook[FishId].FishingSpot
        return SpotId
    end
    return
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
        local CurrentItem = self.CurrentItem
        if not CurrentItem then
            return UIUtils.Handled
        end
        local DeltaOffset = (-1) * UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
        local CurrentOffset = CurrentItem.Scroll_Box:GetScrollOffset()
        local NextOffset = math.clamp(CurrentOffset + DeltaOffset,0, CurrentItem.Scroll_Box:GetScrollOffsetOfEnd())
        CurrentItem.Scroll_Box:SetScrollOffset(NextOffset)
    end
    return UIUtils.Handled
end

function M:OnItemSelectionChanged(CurrentItem)
    self.CurrentItem = CurrentItem
    self.CurrentContentIdx = CurrentItem.ContentIdx
    if not UIUtils.CheckScrollBoxCanScroll(CurrentItem.Scroll_Box) then
        self.Com_Tab:UpdateSingleBottomKeyInfo(1, {})
    else
        self.Com_Tab:UpdateSingleBottomKeyInfo(1, {GamePadInfoList = {{Type="Img", ImgShortPath=UIConst.GamePadImgKey.RightTriggerAnalog, Owner=self}}, Desc = GText("UI_Controller_Introduction")})
    end
end

-- function M:ReceiveEnterState(StackAction)
--     print(_G.LogTag,"LXZ ReceiveEnterState", InKeyName)
--     M.Super.ReceiveEnterState(self, StackAction)
--     self:CheckCompleteAchieveCount()
-- end

-- function M:ReceiveExitState(StackAction)
--     M.Super.ReceiveExitState(self, StackAction)
-- end

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
