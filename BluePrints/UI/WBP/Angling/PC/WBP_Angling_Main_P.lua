--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local EMCache = require "EMCache.EMCache"
local TimeUtils = require "Utils.TimeUtils"
---@type WBP_Angling_Main_P_C
local M = Class("BluePrints.UI.BP_UIState_C")

function M:Init(RootPage, FishingSpotId, NeedMontage)
    self.RootPage = RootPage
    self.RootPage.FishingRodId = 0
    self.RootPage.FishingLureId = 0
    self.RootPage.FishingSpotId = FishingSpotId
    self.bDisplayLure = false
    self.bSelectingLure = false
    self:InitCommonWidget(NeedMontage)
    self:InitText()
    self:InitDisplayFish()
    self:InitFishRodButton()
    self:InitFishLureButton()
    self:CheckCompleteAchieveCount()
    self:CheckSkipFishingPet()

    --print(_G.LogTag,"LXZ AnglingMain")
    if NeedMontage then
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
        Player:AsyncCreateEffectCreature(30101, FTransform(), true, nil)
        self.RootPage:PlayPlayerMontage(4)
        self:AddTimer(0.1, self.UpdateFishingRodModelId, true, 0 , "UpdateFishingRodModelId")
    end

    if self.PopupUI then
        self.Main:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Main:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end

    self.Tip_DayAndNight:Init()

    self:CheckReddotCount()
end

function M:UpdateFishingRodModelId()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local Creatures = Player:GetEffectCreatureByTag("Fish")
    if Creatures:Length() == 0 then
        return
    end
    self:RemoveTimer("UpdateFishingRodModelId")
    self.RootPage:UpdateFishingRodModelId()
end

function M:InitCommonWidget(NeedBindEvent)
    if not NeedBindEvent then
        return
    end
    local SpotData = DataMgr.FishingSpot[self.RootPage.FishingSpotId]
    local SpotName = SpotData["FishingSpotName"]
    self:SetBaseName("AnglingMain")
    
    self.Com_Tab:Init({
        LeftKey = "Q",
        RightKey = "E",
        PlatformName = "PC",
        DynamicNode = {"Back", "BottomKey", "Tip", "ResourceBar"},
        OwnerPanel=self,
        BackCallback=self.OnClickReturn,
        StyleName = "Text",
        BottomKeyInfo = {
                            {
                                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.OnClickReturn, Owner=self}},
                                GamePadInfoList = {{Type="Img", ImgShortPath="B", Owner=self}}, 
                                Desc=GText("UI_BACK")
                            },
                            {
                                GamePadInfoList = {{Type="Img", ImgShortPath="X", Owner=self}}, Desc = GText("UI_Fishing_FishingRod")
                            },
                            {
                                GamePadInfoList = {{Type="Img", ImgShortPath="Y", Owner=self}}, Desc = GText("UI_Fishing_FishingLure")
                            },
                            {
                                GamePadInfoList = {{Type="Img", ImgShortPath="A", Owner=self}}, Desc = GText("UI_PATCH_ENSURE")
                            },
                        },
        TitleName = GText(SpotName),
        InfoCallback = self.OnClickTabInfo,
        -- PopupInfoId = 100152,
    })
    self.Com_Tab:BindEventOnTabSelected(self, self.OnTabItemClick)
    self.Com_Tab:SelectTab(1)
    self.DayNightButton = UIManager(self):CreateWidget("WidgetBlueprint'/Game/UI/WBP/Angling/Widget/WBP_Angling_DayAndNightBtn.WBP_Angling_DayAndNightBtn'", true)
    self.DayNightButton:Init()
    self.Com_Tab.Pos_DayAndNight:AddChild(self.DayNightButton)
    self.Com_Tab.Pos_DayAndNight:SetVisibility(ESlateVisibility.Visible)

    self.BtnText:SetText(GText("UI_Fishing_StartFishing"))
    self.BtnText:BindEventOnClicked(self, self.OnClickGameStart)
    self.BtnText:TryOverrideSoundFunc(function()
        AudioManager(self):PlayUISound(self, "event:/ui/minigame/fish_start_click", nil, nil)
    end)
    if self.RootPage.DeviceInPc then
        self.Com_Tab:UpdateSingleBottomKeyInfo(4, {})
    end

    self.BtnImg01:BindEventOnClicked(self, self.OnClickOpenShop)
    self.BtnImg01:TryOverrideSoundFunc(function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    end)
    self.BtnImg02:BindEventOnClicked(self, self.OnClickOpenBag)
    self.BtnImg02:TryOverrideSoundFunc(function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    end)
    self.BtnImg03:BindEventOnClicked(self, self.OnClickOpenDialog)
    self.BtnImg03:TryOverrideSoundFunc(function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    end)

    if self.RootPage.DeviceInPc then
        self.Key_Bag:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "Up"
                }
            },
            Desc = GText("MAIN_UI_BAG"),
        })
        self.Key_FishMap:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "Right"
                }
            },
            Desc = GText("UI_Fishing_FishBook"),
        })
        self.Key_Shop:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "Down"
                }
            },
            Desc = GText("UI_SHOP_Fishing"),
        })
        self.Key_GamePad:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "LS"
                }
            },
        })
    end

    self:AddReddotListener()

    self.Btn_Empty.OnClicked:Add(self, self.OnClickEmpty)
end

function M:InitText()
    local SpotData = DataMgr.FishingSpot[self.RootPage.FishingSpotId]
    self:RefreshShopRefreshTime(SpotData["ReplenishDay"])
    self.Text_Place:SetText(string.format(GText("UI_Fishing_UpdateTime"), self.RootPage.RemainTimeStr))

    self:AddTimer(1, self.UpdateReplenishTime, true, 0, "FishUpdateReplenishTime")
end

function M:UpdateReplenishTime()
    local SpotData = DataMgr.FishingSpot[self.RootPage.FishingSpotId]
    self:RefreshShopRefreshTime(SpotData["ReplenishDay"])
    self.Text_Place:SetText(string.format(GText("UI_Fishing_UpdateTime"), self.RootPage.RemainTimeStr))
end

function M:InitDisplayFish()
    self.List_Fish:ClearListItems()
    local ShowFishIds = DataMgr.FishingSpot[self.RootPage.FishingSpotId]["ShowFishId"]
    self.DisplayNum = 0
    for i, v in pairs(ShowFishIds) do
        local FishData = DataMgr.Fish[v]
        local FishResourceId = FishData.ResourceId
        if FishResourceId and DataMgr.Resource[FishResourceId] then
            local Params = {Obj = self, Callback = self.OnClickDisplayFish, Params = {v}}
            local Content = self:NewItemContent("Resource", FishResourceId, nil, false, true, Params)
            if Content then
                local Avatar = GWorld:GetAvatar()
                if Avatar then
                    Content.OnAddedToFocusPathEvent = {Obj = self, Callback = self.OnAddFocusDisplayFish}
                    Content.OnRemovedFromFocusPathEvent = {Obj = self, Callback = self.OnRemovedFocusDisplayFish}
                    if Avatar:GetFishCountByFishId(v) < 1 then
                        local TimeTagList = FishData.FishAppearPeriod
                        print(_G.LogTag,"LXZ InitDisplayFish", TimeTagList, #TimeTagList)
                        if TimeTagList and #TimeTagList < 3 and #TimeTagList > 0 then
                            Content.TimeTagList = TimeTagList
                        end
                        Content.NotInteractive = true
                        Content.bOutline = true
                    else
                        self.DisplayNum = self.DisplayNum + 1
                        Content.NotInteractive = false
                        Content.IsShowDetails = true
                    end
                end
                self.List_Fish:AddItem(Content)
            end
        end
    end
    if self.DisplayNum == 0 and self.RootPage.DeviceInPc then
        self.Key_GamePad:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:InitFishRodButton()
    --鱼竿id
    self.RootPage.FishingRodId = self:GetDefaultFishRodId()
    local ResourceId = DataMgr.FishingRod[self.RootPage.FishingRodId]["ResourceId"]
    local Params = {Obj = self, Callback = self.OnClickFishRod, Params = {self.RootPage.FishingRodId}}
    local Content = self:NewItemContent("Resource",  ResourceId, nil, false, true, Params)
    if Content then
        self.Item02:Init(Content)
    end
end

function M:InitFishLureButton()
    local Avatar = GWorld:GetAvatar()
    --鱼饵id
    local CacheLureId = nil
    if not Avatar then
        self.RootPage.FishingLureId = 101
    else
        CacheLureId = EMCache:Get("FishingLureId", true)
        self.RootPage.FishingLureId = CacheLureId and CacheLureId or 101
    end

    -- self.VB01:ClearChildren()
    -- for i, v in pairs(DataMgr.FishingLure) do
    --     if not CacheLureId and self.RootPage.FishingLureId > i then
    --         self.RootPage.FishingLureId = i
    --     end
    --     local ResourceId = v.ResourceId
    --     local Params = {Obj = self, Callback = self.OnClickFishLureButton, Params = {i, ResourceId}}
    --     local Count = self:GetResourceCount(ResourceId)
    --     local Content = self:NewItemContent("Resource", ResourceId, Count, false, false, Params)
    --     if Content then
    --         local Widget = self:CreateWidgetNew("ComItemUniversalS")
    --         Widget.bIsFocusable = true
    --         self.VB01:AddChild(Widget)
    --         Widget:Init(Content)
    --         self.LureList[ResourceId] = {Widget = Widget, LureId = i}
    --     end
    -- end

    local ResourceId = DataMgr.FishingLure[self.RootPage.FishingLureId].ResourceId
    local Params = {Obj = self, Callback = self.OnClickSelectFishLureButton, Params = {ResourceId}}
    local Count = self:GetResourceCount(ResourceId)
    local Content = self:NewItemContent("Resource", ResourceId, Count, false, false, Params)
    self.Item01:SetNavigationRuleCustom(EUINavigation.Up,{self,self.LureNavigation})
    self.Item01:Init(Content)
    if Count == 0 then
        self.BtnText:ForbidBtn(true)
    else
        self.BtnText:ForbidBtn(false)
    end
end

function M:OnClickTabInfo()
	-- local UIStateAsyncActionBase = UE4.UUIStateAsyncActionBase.ShowGuideUI(self, 72)
	-- local OnGuideEnded = function ()
	-- end
	-- UIStateAsyncActionBase.OnGuideEnd:Add(self, OnGuideEnded)
    UIManager(self):LoadUINew("GuideBook", 5, 84)
end
function M:OnClickReturn(TabWidget)
    -- self.RootPage:PlayPlayerMontage("Fish_FishAllEnd_Montage")
    if self.PopupUI then
        if self.PopupUI.CloseBtnCallbackFunction then
            local Data = self.PopupUI:PackageResult()
            self.PopupUI.CloseBtnCallbackFunction(self.PopupUI.CloseBtnCallbackObj,Data)
        end
        return
    end
    self:RemoveReddotListener()
    self:RemoveTimer("FishUpdateReplenishTime")

    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    Player:RemoveEffectCreature(30101)
    self.RootPage:PlayPlayerMontage(-1, nil)
    self.RootPage:Close()
end
function M:OnClickGameStart()
    print(_G.LogTag,"LXZ OnClickGameStart")
    self.RootPage:SwitchOnGamePage()
end
function M:OnClickOpenShop()
    print(_G.LogTag,"LXZ OnClickOpenShop")
    PageJumpUtils:JumpToShopPage(801, 8010, nil, "FishingShop")
end
function M:OnClickOpenBag()
    print(_G.LogTag,"LXZ OnClickOpenBag")
    UIUtils.OpenSystem(2,false,6)
end
function M:OnClickOpenDialog()
    print(_G.LogTag,"LXZ OnClickOpenDialog")
    PageJumpUtils:JumpToAnglingMap({FishingSpotId = self.RootPage.FishingSpotId})
end
function M:OnClickDisplayFish(FishResourceId)
    print(_G.LogTag,"LXZ OnClickDisplayFish", FishResourceId)
end
function M:OnAddFocusDisplayFish()
    if self.RootPage.DeviceInPc and not self.RootPage.CurMode then
        self.BtnText:SetPCVisibility(true)
    end
end
function M:OnRemovedFocusDisplayFish()
    if self.RootPage.DeviceInPc and not self.RootPage.CurMode then
        self.BtnText:SetPCVisibility(false)
    end
end
function M:OnClickFishRod(RodId)
    -- local Widget = self:CreateWidgetNew("AnglingDialog")
    -- self.Node_Dialog:AddChild(Widget)
    -- Widget:InitContent(1, {RodId = RodId, RootPage = self.RootPage})
    -- print(_G.LogTag,"LXZ OnClickFishRod",Widget:GetName())
    local PopParam = {
        RodId = RodId,
        RootPage = self.RootPage,
        CloseBtnCallbackObj = self,
        CloseBtnCallbackFunction = self.OnDialogClose,
        AutoFocus = true,
        ShowBKeyClose = false,
        TabConfigData = {
            Tabs = {
                {
                    Text = GText("UI_Fishing_FishingRod"),
                    TabId = 1,
                },
                {
                    Text = GText("UI_Fishing_FishingLure"),
                    TabId = 2,
                }
            },
            DefaultTabId = 1
        }
    }
    self.PopupUI = UIManager(self):_CreateWidgetNew("CommonDialogWidget")
    self.Node_Dialog:AddChild(self.PopupUI)
    self.PopupUI:InitWidgetView(100159, PopParam)
    self:OnDialogOpen()
    -- UIManager(self):ShowCommonPopupUI(100159,{RodId = RodId, RootPage = self.RootPage, CloseBtnCallbackObj = self, CloseBtnCallbackFunction = self.OnDialogClose, AutoFocus = true},self)

end
function M:OnClickSelectFishLureButton(LureResourceId)
    print(_G.LogTag,"LXZ OnClickSelectFishLureButton", self.bSelectingLure)
    local PopParam = {
        LureId = LureResourceId,
        RootPage = self.RootPage,
        CloseBtnCallbackObj = self,
        CloseBtnCallbackFunction = self.OnDialogClose,
        AutoFocus = true,
        ShowBKeyClose = false,
        TabConfigData = {
            Tabs = {
                {
                    Text = GText("UI_Fishing_FishingRod"),
                    TabId = 1,
                },
                {
                    Text = GText("UI_Fishing_FishingLure"),
                    TabId = 2,
                }
            },
            DefaultTabId = 2
        }
    }
    self.PopupUI = UIManager(self):_CreateWidgetNew("CommonDialogWidget")
    self.Node_Dialog:AddChild(self.PopupUI)
    self.PopupUI:InitWidgetView(100159, PopParam)
    self:OnDialogOpen()
end

function M:OnSelectFirstDisplayFish()
    local ListItems = self.List_Fish:GetListItems()
    for i, v in pairs(ListItems) do
        if v.IsShowDetails then
            self.List_Fish:BP_NavigateToItem(v)
            self.bSelectDisplay = true
            return
        end
    end
end

function M:RefreshFishRod(RodId)
    print(_G.LogTag,"LXZ RefreshFishRod",RodId)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        EMCache:Set("FishingRodId", RodId, true)
    end
    local ResourceId = DataMgr.FishingRod[RodId]["ResourceId"]
    local Params = {Obj = self, Callback = self.OnClickFishRod, Params = {self.RootPage.FishingRodId}}
    local Content = self:NewItemContent("Resource",  ResourceId, 1, false, true, Params)
    if Content then
        self.Item02:Init(Content)
    end
end

function M:RefreshFishLure(LureId)
    print(_G.LogTag,"LXZ RefreshFishLure",LureId)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        EMCache:Set("FishingLureId", LureId, true)
    end
    local ResourceId = DataMgr.FishingLure[LureId]["ResourceId"]
    local Params = {Obj = self, Callback = self.OnClickSelectFishLureButton, Params = {ResourceId}}
    local Count = self:GetResourceCount(ResourceId)
    local Content = self:NewItemContent("Resource", ResourceId, Count, false, false, Params)
    if Content then
        self.Item01:Init(Content)
    end
    self.RootPage.Angling_Fishing.ResourceBar:InitResourceBar({ResourceId})
    self.RootPage.Angling_Fishing.WBP_Angling_Fishing_Btn:SwitchWaitStart(false)
    self.BtnText:ForbidBtn(false)
end

function M:NewItemContent(ItemType, ItemId, Count, NotInteractive, NotCountFormat, OnMouseButtonUpEvents, IsShowDetails)
    if ItemId == 0 then
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        return Obj
    end
    local ItemData = DataMgr[ItemType][ItemId]
    if not ItemData then
        print(_G.LogTag, "Error: Item Data is nil, ItemType:", ItemType, "ItemId", ItemId)
        return nil
    end
    --新建一个列表数据对象
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.ItemType = ItemType:gsub("^%l",string.upper)
    Obj.Id = ItemId
    Obj.Rarity = ItemData.Rarity or ItemData.WeaponRarity or 1
    Obj.Icon = ItemData.Icon
    Obj.Count = Count
    Obj.NotInteractive = NotInteractive
    Obj.NotCountFormat = NotCountFormat
    Obj.OnMouseButtonUpEvents = OnMouseButtonUpEvents
    Obj.bSold = Count == 0
    Obj.IsShowDetails = IsShowDetails
    return Obj
end

function M:OnGetLure(ResourceId)
    print(_G.LogTag,"LXZ OnGetLure", ResourceId, self.RootPage.FishingLureId)
    if ResourceId == DataMgr.FishingLure[self.RootPage.FishingLureId]["ResourceId"] then
        self.RootPage.Angling_Fishing.WBP_Angling_Fishing_Btn:SwitchWaitStart(false)
        self:RefreshFishLure(self.RootPage.FishingLureId)
    end
    if not self.PopupUI then
        return
    end
    local DialogContent = self.PopupUI:GetContentWidgetByName("Angling_Rod")
    DialogContent:OnGetLure(ResourceId)
    
end

function M:GetResourceCount(ResourceId)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        return Avatar:GetResourceNum(ResourceId)
    else
        return 1
    end
end

function M:GetDefaultFishRodId()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local CacheRodId = EMCache:Get("FishingRodId", true)
        if CacheRodId then
            return CacheRodId
        end
        local Res = 101
        local ResRarity = 1
        local ResLevel = 1
        for RodId, Data in pairs(DataMgr.FishingRod) do
            local Num = Avatar:GetResourceNum(Data.ResourceId)
            if Num >= 1 then
                local TmpLevel = Data.FishingRodLevel
                if TmpLevel > ResLevel then
                    Res = RodId
                    ResLevel = TmpLevel
                elseif TmpLevel == ResLevel then
                    local ResourceId = Data.ResourceId
                    local TmpRarity = DataMgr.Resource[ResourceId].Rarity
                    if TmpRarity >= ResRarity then
                        Res = RodId
                        ResRarity = TmpRarity
                    end
                end
            end
        end
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            EMCache:Set("FishingRodId", Res, true)
        end
        return Res
    else
        return 101
    end
end

function M:OnDialogOpen()
    self.RootPage.FishingSpot:SetCamera("Select")
    self.Main:SetVisibility(ESlateVisibility.Collapsed)
    if self.RootPage.CurMode == ECommonInputType.Gamepad and self.RootPage.DeviceInPc then
        self.Com_Tab:UpdateSingleBottomKeyInfo(2, {})
        self.Com_Tab:UpdateSingleBottomKeyInfo(3, {})
        -- self.Com_Tab:SetSingleBottomKeyInfoVisibility(2, ESlateVisibility.Collapsed)
        -- self.Com_Tab:SetSingleBottomKeyInfoVisibility(3, ESlateVisibility.Collapsed)
    end
end

function M:OnDialogClose()
    print(_G.LogTag, "LXZ OnDialogClose")
    self.Item02:SetSelected(false)
    if self.PopupUI then
        self.Node_Dialog:ClearChildren()
        self.PopupUI = nil
    end
    self.RootPage.FishingSpot:SetCamera("Main")

    self.Main:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self:SetFocus()
    if self.RootPage.CurMode == ECommonInputType.Gamepad and self.RootPage.DeviceInPc then
        self.Com_Tab:UpdateSingleBottomKeyInfo(2, {GamePadInfoList = {{Type="Img", ImgShortPath="X", Owner=self}}, Desc = GText("UI_Fishing_FishingRod")})
        self.Com_Tab:UpdateSingleBottomKeyInfo(3, {GamePadInfoList = {{Type="Img", ImgShortPath="Y", Owner=self}}, Desc = GText("UI_Fishing_FishingLure")})
        -- self.Com_Tab:SetSingleBottomKeyInfoVisibility(2, ESlateVisibility.SelfHitTestInvisible)
        -- self.Com_Tab:SetSingleBottomKeyInfoVisibility(3, ESlateVisibility.SelfHitTestInvisible)
    end
end

function M:AddReddotListener()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self:RemoveReddotListener()
    ReddotManager.AddListener("AnglingMap", self, self.OnAnglingMapReddotChange)
    self.ListenedReddot = true
end

function M:RemoveReddotListener()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if not self.ListenedReddot then
        return
    end
    ReddotManager.RemoveListener("AnglingMap", self)
    self.ListenedReddot = false
end

function M:OnAnglingMapReddotChange(Count)
    print(_G.LogTag,"LXZ OnReddotChange", Count)
    if self.BtnImg03.Reddot:GetVisibility() ~= ESlateVisibility.Collapsed then
        return
    end
    if Count <= 0 then
        self.BtnImg03.New:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.BtnImg03.New:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

function M:Handle_KeyEventOnPC(InKeyName)
    print(_G.LogTag,"LXZ Handle_KeyEventOnPC")
    if InKeyName == "Escape" then
        self:OnClickReturn()
    else
        self.Com_Tab:Handle_KeyEventOnPC(InKeyName)
    end
    return true
end

function M:Handle_KeyEventOnGamePad(InKeyName)
    print(_G.LogTag,"LXZ Handle_KeyEventOnGamePad", InKeyName, self.bDisplayLure)
    if self.PopupUI then
        return false
    end
    if InKeyName == "Gamepad_Special_Right" then
        self.Com_Tab:OnInfoClick()
    elseif InKeyName == "Gamepad_FaceButton_Top" then
        self:OnClickSelectFishLureButton()
    elseif InKeyName == "Gamepad_FaceButton_Right" then
        if not self.bSelectDisplay then 
            self:OnClickReturn()
        else
            self.bSelectDisplay = false
            self:SetFocus()
        end
    elseif InKeyName == "Gamepad_FaceButton_Bottom" and not self.BtnText:IsBtnForbidden() then
        self:OnClickGameStart()
    elseif InKeyName == "Gamepad_FaceButton_Left" then
        self.bDisplayRod = true
        self:OnClickFishRod(self.RootPage.FishingRodId)
    elseif InKeyName == "Gamepad_LeftThumbstick" then
        self:OnSelectFirstDisplayFish()
    elseif InKeyName == "Gamepad_RightThumbstick" then
        self.Com_Tab.WBP_Com_Tab_ResourceBar:FocusToResource()
    elseif InKeyName == "Gamepad_Special_Left" then
        self.DayNightButton:OnOpenDayAndNight()
    else
        self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName)
    end
    return true
end

function M:Handle_KeyUpEventOnGamePad(InKeyName)
    print(_G.LogTag,"LXZ Handle_KeyUpEventOnGamePad", InKeyName, self.bDisplayLure)
    -- if InKeyName == "Gamepad_FaceButton_Bottom" and not self.bDisplayLure then
    --     self:OnClickGameStart()
    -- end
    return true
end

function M:Handle_PreviewKeyEventOnGamePad(InKeyName)
    print(_G.LogTag,"LXZ Handle_PreviewKeyEventOnGamePad", InKeyName, self.bDisplayLure)
    if self.bDisplayLure or self.PopupUI then
        return false
    end
    if InKeyName == "Gamepad_DPad_Up" then
        self:OnClickOpenBag()
    elseif InKeyName == "Gamepad_DPad_Right" then
        self:OnClickOpenDialog()
    elseif InKeyName == "Gamepad_DPad_Down" then
        self:OnClickOpenShop()
    end
    return true
end

function M:CheckCompleteAchieveCount()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local CanReceiveCount = 0
    local AchievementList=DataMgr.FishingAchievement
    for AchievementId, Data in pairs(AchievementList) do
        local FishiAchv = Avatar.FishAchvs[AchievementId]
        if FishiAchv and FishiAchv:IsComplete() and FishiAchv:CanRecvReward() then
            CanReceiveCount = CanReceiveCount + 1
        end
    end
    if CanReceiveCount > 0 then
        self.BtnImg03.New:SetVisibility(ESlateVisibility.Collapsed)
        self.BtnImg03.Reddot:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.BtnImg03.Reddot:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:CheckSkipFishingPet()
    local bCanSkip = self.RootPage:CheckSkipFishingPet()

    if bCanSkip then
        self.Text_Auto:SetText(GText("UI_Fishing_AutoFishing"))
        self.Panel_Auto:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Panel_Auto:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:RefreshInfoByInputTypeChange(CurInputDevice, CurGamepadName)
    if CurInputDevice == ECommonInputType.MouseAndKeyboard and self.RootPage.DeviceInPc then
        self.WidgetSwitcher_MP:SetActiveWidgetIndex(0)
        self.Key_GamePad:SetVisibility(ESlateVisibility.Collapsed)
    elseif CurInputDevice == ECommonInputType.Gamepad and self.RootPage.DeviceInPc then
        self.WidgetSwitcher_MP:SetActiveWidgetIndex(1)
        if self.DisplayNum ~= 0 then
            self.Key_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
    elseif CurInputDevice == ECommonInputType.Touch then
        -- self.WidgetSwitcher_MP:SetActiveWidgetIndex(0)
    end
end

function M:LureNavigation(Navigation)
    -- if Navigation == EUINavigation.Up then
    --     local FirstLure = self.VB01:GetChildAt(self.CurrentItemIdx)
    --     return FirstLure
    -- elseif Navigation == EUINavigation.Left then
    --     return self.Item02
    -- elseif Navigation == EUINavigation.Down then
    --     return self.BtnText
    -- end
end

function M:OnLureItemNavigation(NavigationDirection)
    print(_G.LogTag,"LXZ OnLureItemNavigation", NavigationDirection)
    local MaxItemIdx = self.VB01:GetChildrenCount()
    if NavigationDirection == EUINavigation.Up then
        self.CurrentItemIdx = self.CurrentItemIdx - 1
        if self.CurrentItemIdx < 0 then
            self.CurrentItemIdx = MaxItemIdx - 1
        end
    elseif NavigationDirection == EUINavigation.Down then
        self.CurrentItemIdx = (self.CurrentItemIdx + 1) % MaxItemIdx
    end
    local Lure = self.VB01:GetChildAt(self.CurrentItemIdx)
    return Lure
end

--ShopRefreshBeginTime是统一的刷新起始时间
function M:RefreshShopRefreshTime(RefreshTime)
    local ShopRefreshBeginTime = CommonConst.ShopRefreshBeginTime
    local StartTime = os.time{year=ShopRefreshBeginTime[1], month=ShopRefreshBeginTime[2], day=ShopRefreshBeginTime[3], 
    hour=ShopRefreshBeginTime[4], min=ShopRefreshBeginTime[5], sec=ShopRefreshBeginTime[6]}
    -- 转换为表结构
    local NextRefreshTimeTable = os.date("*t", StartTime)
    -- 计算下次刷新时间
    -- 如果单位是Hour、Day、Week，直接计算起始日期到当前日期时间差，求余数
    -- 如果单位是Month，则从起始日开始增加月数找到下一次刷新的时间
    local CurrentTime = TimeUtils.NowTime()
    local Interval = 0
    local timeDifference = 0
    local RemainRefreshTime = 0
    if RefreshTime then
        Interval = RefreshTime * 60 * 60
        timeDifference = CurrentTime - StartTime
        RemainRefreshTime = Interval - (timeDifference % Interval)
    end
    local RemainTimeStr = ""
    local TimeCount = 0
    if RemainRefreshTime > 24 * 60 * 60 then
        TimeCount = TimeCount + 1
        RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_DAY"), math.floor(RemainRefreshTime / (24 * 60 * 60)))
        RemainRefreshTime = RemainRefreshTime % (24 * 60 * 60)
    end
    if RemainRefreshTime > 60 * 60 or TimeCount == 1 then
        TimeCount = TimeCount + 1
        RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_HOUR"), math.floor(RemainRefreshTime / (60 * 60)))
        RemainRefreshTime = RemainRefreshTime % (60 * 60)
    end
    if (RemainRefreshTime > 60 and TimeCount < 2) or TimeCount == 1 then
        TimeCount = TimeCount + 1
        RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_MINUTE"), math.floor(RemainRefreshTime / 60))
        RemainRefreshTime = RemainRefreshTime % 60
    end
    if (RemainRefreshTime > 0 and TimeCount < 2) or TimeCount == 1 then
        TimeCount = TimeCount + 1
        RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_SECOND"), RemainRefreshTime)
    end
    self.RootPage.RemainTimeStr = RemainTimeStr
end

function M:BP_GetDesiredFocusTarget()
    if self.PopupUI then
        return self.PopupUI
    end
    return self
end

function M:OnClickEmpty()
    -- if self.bSelectingLure then
    --     self.bSelectingLure = false
    --     self:PlayAnimation(self.Switch_Off)
    -- end
end

function M:CheckReddotCount()
    local UnLockData = EMCache:Get("FishUnLockData", true)
    local UnLockMapData = EMCache:Get("FishMapUnLockData", true)
    if not UnLockData then
        return
    end
    local UnLockCount = 0
    if UnLockData then
        for Id, State in pairs(UnLockData) do
            UnLockCount = UnLockCount + 1
        end
    end
    local UnLockMapCount = 0
    if UnLockMapData then
        for Id, State in pairs(UnLockMapData) do
            UnLockMapCount = UnLockMapCount + 1
        end
    end
    if UnLockCount <= UnLockMapCount then
        return
    end
    ReddotManager.ClearLeafNodeCount("AnglingMap")
    ReddotManager.IncreaseLeafNodeCount("AnglingMap", UnLockCount - UnLockMapCount)
end

return M