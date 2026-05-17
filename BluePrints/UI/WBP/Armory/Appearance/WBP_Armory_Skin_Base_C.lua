--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local ActorController = require "BluePrints.UI.WBP.Armory.ActorController.Armory_ActorController"

---@type WBP_Armory_Skin_Base_C
local M = Class("BluePrints.UI.BP_UIState_C")
M._components = {
	"BluePrints.UI.WBP.Armory.MainComponent.Armory_PointerInputComponent",
    "BluePrints.UI.WBP.Armory.MainComponent.Armory_ReddotTree_Component",
	"BluePrints.UI.WBP.Armory.ActorController.PreviewActorComponent",
    "BluePrints.UI.WBP.Armory.Appearance.Armory_AccessoryCustom_Component",
    "BluePrints.UI.WBP.Armory.Appearance.Armory_CharAppearance_Component",
    "BluePrints.UI.WBP.Armory.Appearance.Armory_WeaponAppearance_Component",
}
local GoToShopState = {
    CanGoToShop = "CanGoToShop",
    ItemIdNil = "ItemIdNil",
    ItemNotExist = "ItemNotExist",
    ItemNotOnSale = "ItemNotOnSale",
    SkinNotValid = "SkinNotValid"
}

function M:ReceiveEnterState(StackAction)
    M.Super.ReceiveEnterState(self,StackAction)
    if(self.ActorController and self.ActorController:ShouldPlaySequence())then
        self.ActorController:ReplaySequence()
    end
    if (self.Target) then
        ArmoryUtils:InitSkinLevelUpReddot(self.Target.CharId)
        self:RefreshLevelUpReddot()
    end
end

function M:ReceiveExitState(StackAction)
    M.Super.ReceiveExitState(self, StackAction)
    if(self.ActorController)then
        self.ActorController:PauseSequence()
    end
end


function M:Construct()
    M.Super.Construct(self)
    self:UnbindAllFromAnimationFinished(self.In)
    self:UnbindAllFromAnimationFinished(self.Out)
    self:BindToAnimationFinished(self.In, {self, self.OnInAnimFinished})
    self:BindToAnimationFinished(self.Out, {self, self.OnOutAnimFinished})
    self.Image_Click.OnMouseButtonDownEvent:Unbind()
    self.Image_Click.OnMouseButtonDownEvent:Bind(self,self.On_Image_Click_MouseButtonDown)
    
    self:AddDispatcher(EventID.OnPurchaseShopItem, self, self.OnPurchaseShopItem)
    self:AddDispatcher(EventID.OnResourcesChanged, self, self.UpdateBtnStateByResourceChanged)
    
    self.List_Accessory.BP_OnItemClicked:Clear()
    self.List_Accessory.BP_OnItemClicked:Add(self,self.OnAccessoryItemClicked)
    self.List_Accessory.OnCreateEmptyContent:Bind(self, function(self)
        return NewObject(UIUtils.GetCommonItemContentClass())
    end)

    self.List_Skin.OnCreateEmptyContent:Bind(self, function(self)
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        rawset(Obj,"IsEmpty",true)
        return Obj
    end)
    rawset(self,"BtnWidgetState",{
        Unequipped = 0,
        Equipped = 1,
        Locked = 2,
    })
    self.Text_Show:SetText(GText("UI_Controller_Check"))
    rawset(self,"NoneAccessoryId",DataMgr.GlobalConstant.EmptyCharAccessoryID.ConstantValue)
    self.Btn_Dye:BindEventOnClicked(self,self.OnDyeBtnClicked)
    rawset(self,"NameFont",{ nil, nil, "Font_Blue", "Font_Purple", "Font_Gold", "Font_Red"}) --分别对应稀有度1，2，3，4，5，6
end

function M:OnNewAccessoryObtained(AccessoryId)
    if(not self.Map_AccessoryContents)then
        return
    end
    local Content = self.Map_AccessoryContents[AccessoryId]
    if(not Content)then
        return
    end
    Content.IsHide = nil
    if(self.NoReddot)then
        Content.RedDotType = nil
    else
        Content.RedDotType = UIConst.RedDotType.NewRedDot
    end
    Content.LockType = nil
    if(Content.SelfWidget)then
        Content.SelfWidget:SetRedDot(Content.RedDotType)
        Content.SelfWidget:SetLock(Content.LockType)
    end
    if(Content.Widget)then
        Content.Widget:SetReddot(Content.RedDotType)
        Content.Widget.LockType = nil
        Content.Widget:InitTextStyle()
    end
    if(self.CurrentTopTabIdx ~= self.AccessoryTabIdx
     and self.CurrentTopTabIdx ~= self.MVPTabIdx
     and self.CurrentTopTabIdx ~= self.WeaponStanceFXTabIdx)then
        return
    end
    if(Content == self.ComparedContent)then
        self:UpdateAccessoryDetails(self.ComparedContent)
    end
    if(self.Type == CommonConst.ArmoryType.Char)then
        if(self.CurrentTopTabIdx == self.MVPTabIdx)then
            self:CheckMVPContentReddot(AccessoryId)
            self:InitMVPList()
        else
            self:CheckCharAccessoryContentReddot(AccessoryId)
            self:InitAccessoryListCommon()
        end
    else
        self:CheckWeaponAccessoryContentReddot(AccessoryId)
        if(self.CurrentTopTabIdx == self.WeaponStanceFXTabIdx)then
            self:InitAccessoryListCommon()
        else
            self:InitWeaponAccessoryList()
        end
    end
end

function M:OnNewSkinObtained(SkinId)
    if(not self.SkinMap)then
        return
    end
    local Content = self.SkinMap[SkinId]
    if(Content)then
        Content.LockType = nil
        if(not self.NoReddot)then
            Content.RedDotType = UIConst.RedDotType.NewRedDot
        end
        if(Content.Widget)then
            Content.Widget.LockType = Content.LockType
            Content.Widget:SetReddot(Content.RedDotType)
            Content.Widget:InitTextStyle()
        end
        if(self.SelectedSkinId == SkinId and self.CurrentTopTabIdx == self.SkinTabIdx)then
            self:UpdateSkinDetails(Content)
        end
    end
end

--region 交互事件
function M:On_Image_Click_MouseButtonDown(MyGeometry, MouseEvent)
    return self:OnPointerDown(MyGeometry, MouseEvent)
end

function M:OnMouseWheel(MyGeometry, MouseEvent)
    return self:OnMouseWheelScroll(MyGeometry, MouseEvent)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
    return self:OnPointerUp(MyGeometry, MouseEvent)
end

function M:OnMouseMove(MyGeometry, MouseEvent)
    return self:OnPointerMove(MyGeometry, MouseEvent)
end

function M:OnTouchEnded(MyGeometry, InTouchEvent)
    return self:OnPointerUp(MyGeometry, InTouchEvent)
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
    return self:OnPointerMove(MyGeometry, InTouchEvent)
end

function M:OnMouseCaptureLost()
    self:OnPointerCaptureLost()
end

function M:OnBackgroundClicked()
    if(self.bSelfHidden)then
        self:OnHideUIKeyDown()
    end
end

function M:OnBackKeyDown()
    if(self.bSelfHidden)then
        return self:OnHideUIKeyDown()
    elseif(self.bAccessoryCustomOpened)then
        return self:TryCloseAccessoryCustom()
    else
        if(self.CurrentTopTabIdx ~= self.SkinTabIdx)then
            if(self.IsAccessoryContentsCreated)then
                self:RecoverAccessory({DontStopSequance = true})
            end
            if(self.CurrentTopTabIdx == self.MVPTabIdx)then
                self.BlackScreenHandle = UIManager(self):ShowCommonBlackScreen({
                    OutAnimationPlayTime = 0.3,
                })
            end
        end
        if self.OpenPreviewDyeFromChat then
            if self.ActorController then
                self.ActorController:OnClosed()
            end
            self:Close()
        else
            self:PlayOutAnim()
        end
    end
end

function M:OnLeftConfirmBtnClicked()
    AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_confirm", nil, nil)
    --实际逻辑在Component里
end

function M:OnRightConfirmBtnClicked()
    if(self.CurrentTopTabIdx == self.SkinTabIdx)then
        AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_confirm", nil, nil)
    else
        AudioManager(self):PlayUISound(nil, "event:/ui/common/role_replace", nil, nil)
    end
    --实际逻辑在Component里
end

function M:OnSkinItemClicked(Content)
    local SelectedContent = self.SkinMap[self.SelectedSkinId]
    if(Content == SelectedContent)then
        return
    end
    self:SelectSkinByContent(Content)
end

function M:OnSkinListSelectionChanged(Content,IsSelected)
end

function M:OnMVPListSelectionChanged(Content,IsSelected)
end

function M:OnDyeBtnClicked()
    self:OpenDye()
end

--endregion 交互事件

function M:InitUIInfo(Name, IsInUIMode, EventList, Params)
    M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, Params)
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "SkinOpen", nil)
    Params = Params or {
        --Type = "Char"|"Weapon" -- 角色或武器
        --SkinId = 1101 --需要跳转到的皮肤
        --HairId = 1101 --需要跳转到的发型
        --AccessoryId = 10001 --跳转到配饰id
        --AccessoryType = "Head" -- 跳转到配饰部位并选中当前装备的配饰
    }
    self.Params = Params
    rawset(self,"SelectedSkinId",nil)
    self.Target = Params.Target
    self.Type = Params.Type
    self.OnCloseCallback = Params.OnCloseCallback
    self.Parent = Params.Parent
    self.IsTargetUnowned = Params.IsTargetUnowned
    self.IsCharacterTrialMode = Params.IsCharacterTrialMode
    self.IsPreviewMode = Params.IsPreviewMode
    self.NoReddot = self.IsPreviewMode or self.IsCharacterTrialMode or self.IsTargetUnowned
    self.OpenPreviewDyeFromChat = Params.OpenPreviewDyeFromChat
    self.OpenPreviewDyeFromShopItem = Params.OpenPreviewDyeFromShopItem
    self.OpenPreviewDyeFromChatColors = Params.Colors
    if(self.Parent and self.Parent.ActorController)then
        self.ActorController = self.Parent.ActorController
        self.ActorController.ViewUI = self
    end
   
    self:CreateTabConfig()
    self.UIName = self:GetUIConfigName()
    if(not self.ActorController)then
        self.InAnimStyle = 1
    end
    if(not self.InAnimStyle)then
        self:Init(Params)
    end
    self:PlayInAnim()
end

function M:CreateTabConfig()
    rawset(self,"SkinTabIdx",1)
    rawset(self,"TopTabs",{
        {
            TabId = self.SkinTabIdx,
            Text = GText(DataMgr.AppearanceTab[self.SkinTabIdx].Text),
            IconPath = DataMgr.AppearanceTab[self.SkinTabIdx].IconPath,
        },
    })
    if(self.Type == "Char")then
        rawset(self,"HairTabIdx",2)
        rawset(self,"AccessoryTabIdx",3)
        rawset(self,"MVPTabIdx",4)
        table.insert(self.TopTabs,{
            TabId = self.HairTabIdx,
            Text = GText(DataMgr.AppearanceTab[self.HairTabIdx].Text),
            IconPath = DataMgr.AppearanceTab[self.HairTabIdx].IconPath,
        })
        table.insert(self.TopTabs,{
            TabId = self.AccessoryTabIdx,
            Text = GText(DataMgr.AppearanceTab[self.AccessoryTabIdx].Text),
            IconPath = DataMgr.AppearanceTab[self.AccessoryTabIdx].IconPath,
        })
        table.insert(self.TopTabs,{
            TabId = self.MVPTabIdx,
            Text = GText(DataMgr.AppearanceTab[self.MVPTabIdx].Text),
            IconPath = DataMgr.AppearanceTab[self.MVPTabIdx].IconPath,
        })
    else
        rawset(self,"AccessoryTabIdx",2)
        rawset(self,"WeaponStanceFXTabIdx",3)
        table.insert(self.TopTabs,{
            Text = GText(DataMgr.AppearanceTab[3].Text),
            IconPath = DataMgr.AppearanceTab[3].IconPath,
        })
        table.insert(self.TopTabs,{
            Text = GText(DataMgr.AppearanceTab[5].Text),
            IconPath = DataMgr.AppearanceTab[5].IconPath,
        })
    end
    rawset(self,"TabConfig",{
        TitleName = GText("UI_Armory_Appearance"),
        LeftKey = self.TabLeftKey,
        RightKey = self.TabRightKey,
        Tabs = self.TopTabs,
        StyleName = self.TabStyleName,
        DynamicNode={
            "Back",
            "ResourceBar",
            "BottomKey",
        },
        BottomKeyInfo = {},
        BackCallback = self.OnBackKeyDown,
        OwnerPanel = self,
    })

    self:OnTabConfigCreated(self.TabConfig)
end

function M:Init(Params)
    if(not self.ActorController)then
        self.IsPreviewMode = true
        self.Target = self:CreatePreviewTargetData(Params)
        Params.Target = self.Target
        Params.EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon
        Params.ViewUI = self
        self.ActorController = self:CreatePreviewActor(Params)
        self.ActorController:OnOpened()
        self.TabConfig.Tabs = nil
        self.TabConfig.LeftKey = nil
        self.TabConfig.RightKey = nil
    end
    if(self.IsPreviewMode or self.IsCharacterTrialMode)then
        self.TabConfig.DynamicNode = {
            "Back",
            "BottomKey",
        }
    end

    if(self.IsPreviewMode)then
        self.WidgetSwitcher_BtnState:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.WidgetSwitcher_State:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self.WidgetSwitcher_BtnState:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.WidgetSwitcher_State:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    self.Tab_Skin:Init(self.TabConfig)
    self.AppearanceSuitIndex = self.Target.CurrentAppearanceIndex
    local AppearanceSuit = self.Target:GetAppearance(self.AppearanceSuitIndex)
    self.SelectedSkinId = AppearanceSuit.SkinId
    self.SelectedHairId = AppearanceSuit.HairId
    self.JumpToCharAccessoryType = Params.AccessoryType
    self.Tab_Skin:BindEventOnTabSelected(nil,nil)
    if(Params.AccessoryId or Params.AccessoryType)then
        local JumpToTabIdx
        if(Params.Type == CommonConst.DataType.Char)then
            if(Params.AccessoryType and Params.AccessoryType == CommonConst.CharAccessoryTypes.MVP)then
                JumpToTabIdx = self.MVPTabIdx
            else
                JumpToTabIdx = self.AccessoryTabIdx
            end
        else
            if(Params.AccessoryType and Params.AccessoryType == CommonConst.WeaponAccessoryTypes.Accessory)then
                JumpToTabIdx = self.AccessoryTabIdx
            else
                JumpToTabIdx = self.WeaponStanceFXTabIdx
            end
        end
        self.JumpToAccessoryId = Params.AccessoryId
        self.Tab_Skin:SelectTab(JumpToTabIdx)
        self:OnTopTabSelected({Idx = JumpToTabIdx})
    elseif(Params.HairId)then
        self.JumpToHairId = Params.HairId
        self.Tab_Skin:SelectTab(self.HairTabIdx)
        self:OnTopTabSelected({Idx = self.HairTabIdx})
    else
        self.JumpToSkinId = Params.SkinId
        self.Tab_Skin:SelectTab(self.SkinTabIdx)
        self:OnTopTabSelected({Idx = self.SkinTabIdx})
    end
    self.Tab_Skin:BindEventOnTabSelected(self,self.OnTopTabSelected)
    -- 皮肤升级红点
    ArmoryUtils:InitSkinLevelUpReddot(self.Target.CharId)
    self:AddTopTabReddotListen()
    if self.OpenPreviewDyeFromChat then
        self:BlockAllUIInput(true,"SP_DisplayOnly")
        self:AddTimer(0.1,function()
            if not self then return end
            self:StopAllAnimations()
            self:OpenDye()
        end, false, 0, "OpenDye")
        self:AddTimer(0.2,function()
            if not self then return end
            self:BlockAllUIInput(false)
        end, false, 0, "UnBlockAllUIInput")
    end
    self:OnInited()
end

function M:OnInited()
end

function M:OnLoaded(...)
    M.Super.OnLoaded(self, ...)
end

function M:OnTopTabSelected(TabWidget,Content)
    self:HideSkinLevelUpWidget()

    self.CurrentTopTabIdx = TabWidget.Idx
    if(self.ActorController)then
        self.ActorController:UpdateCameraPPSetting()
    end
    --实际逻辑在Component
end

--region 皮肤公共函数

---初始化皮肤列表
function M:InitSkinList()
    if self.SkinArray == nil then
        return
    end
    self.List_Skin:ClearListItems()
    for index, value in ipairs(self.SkinArray) do
        rawset(value,"Idx",index)
        rawset(value,"bSelectTag",self.SkinArray[index].SkinId == self.CurrentSkinContent.SkinId)
        self.List_Skin:AddItem(value)
    end
    self.List_Skin:RequestFillEmptyContent()
end

function M:OnSkinListEntryReleased(Widget)
    self:DelayUpdateListArrow()
end

function M:OnSkinListEntryGenerated(Widget)
    self:DelayUpdateListArrow()
end

function M:OnAccessoryListEntryGenerated(Widget)
    self:DelayUpdateListArrow()
end

function M:OnAccessoryListEntryReleased(Widget)
    self:DelayUpdateListArrow()
end

function M:DelayUpdateListArrow()
    self:AddTimer(0.2,function()
        self:UpdateListArrow()
    end)
end

function M:OnMVPListEntryGenerated()
    self:DelayUpdateListArrow()
end

function M:OnMVPListEntryReleased()
    self:DelayUpdateListArrow()
end

function M:UpdateListArrow()
    local ListWidget
    local ItemsPerLine
    local ArrowUp,ArrowDown
    if(self.CurrentTopTabIdx == self.SkinTabIdx)then
        ListWidget = self.List_Skin
        ArrowUp = self.List_Arrow_Up
        ArrowDown = self.List_Arrow_Down
        ItemsPerLine = ListWidget:GetNumItemsPerLine()
    elseif(self.CurrentTopTabIdx == self.MVPTabIdx)then
        ListWidget = self.List_SettlementAction
        ArrowUp = self.List_Arrow_Up_2
        ArrowDown = self.List_Arrow_Down_2
        ItemsPerLine = 1
    else
        ListWidget = self.List_Accessory
        ArrowUp = self.List_Arrow_Up_1
        ArrowDown = self.List_Arrow_Down_1
        ItemsPerLine = ListWidget:GetNumItemsPerLine()
    end
    local Len = ListWidget:GetNumItems()
    local MinEntryIdx,MaxEntryIdx = UIUtils.GetMinAndMaxDisplayedItemIndex(ListWidget)
    if(MinEntryIdx > ItemsPerLine)then
        ArrowUp:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        ArrowUp:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

    if(MaxEntryIdx < Len)then
        ArrowDown:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
        ArrowDown:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:SelectSkinById(SkinId)
    SkinId = SkinId or self.CurrentSkinContent.SkinId
    self:SelectSkinByContent(self.SkinMap[SkinId])
end

function M:SelectSkinByContent(Content)
    if(not Content)then return end
    local SelectedContent = self.SkinMap[self.SelectedSkinId]
    ArmoryUtils:SetItemIsSelected(SelectedContent,false)
    SelectedContent = Content
    ArmoryUtils:SetItemIsSelected(SelectedContent,true)
    self:UpdateSkinDetails(Content)
end

function M:UpdateSkinDetails(Content)
    self.Panel_Buy:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if(not Content)then
        return
    end

    if(Content.SkinId ~= self.SelectedSkinId)then
        if(not self:IsAnimationPlaying(self.In))then
            self:PlayAnimation(self.Change)
        end
    end
    self.SelectedSkinId = Content.SkinId
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
    if Content.ElementType then
        local IconName = "Armory_" .. Content.ElementType
        local AttributeIcon = LoadObject('/Game/UI/Texture/Dynamic/Atlas/Armory/T_' .. IconName .. ".T_" .. IconName)
        self.Image_Element:SetBrushResourceObject(AttributeIcon)
        self.Image_Element:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    if Content.WeaponTypeIcon then
        local TagIcon = LoadObject(Content.WeaponTypeIcon)
        self.Image_Element:SetBrushResourceObject(TagIcon)
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
    self:UpdateSkinVideo(self.SelectedSkinId)
    self:UpdateFunctionBtn(Content,self.CurrentSkinContent)
    self:UpdateActorAppearance(self.SelectedSkinId,self.SelectedHairId)
    if(Content.RedDotType and not self.NoReddot)then
        ArmoryUtils:SetItemReddotRead(Content,true)
    end
    self:RefreshSkinLevelInfo(self.SelectedSkinId)
end

function M:UpdateSkinVideo(SkinId)
    local Data = DataMgr.Skin[SkinId]
    if(not Data or Data.GetDisplayType ~= 1 or not Data.DisplayPath or not Data.VideoCover)then
        self.Panel_Video:SetVisibility(UIConst.VisibilityOp.Collapsed)
        return
    end

    rawset(self,"SkinData",Data)
    self.Panel_Video:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    local VideoCover = LoadObject(Data.VideoCover)
    if(VideoCover)then
        local MI = self.Img_Video:GetDynamicMaterial()
        if(MI)then
            MI:SetTextureParameterValue("MainTex", VideoCover)
        else
            self.Img_Video:SetBrushResourceObject(VideoCover)
        end
    end
    self.Btn_Play.Btn_Area.OnClicked:Clear()
    self.Btn_Play.Btn_Area.OnClicked:Add(self, self.OpenSkinVideo)
end

function M:UpdateAccessoryVideo(Data)
    if(not Data or not Data.VideoCover)then
        self.Panel_Video:SetVisibility(UIConst.VisibilityOp.Collapsed)
        return
    end
    self.Panel_Video:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    local VideoCover = LoadObject(Data.VideoCover)
    if(VideoCover)then
        local MI = self.Img_Video:GetDynamicMaterial()
        if(MI)then
            MI:SetTextureParameterValue("MainTex", VideoCover)
        else
            self.Img_Video:SetBrushResourceObject(VideoCover)
        end
    end
    rawset(self,"AccessoryVideoData",Data)
    self.Btn_Play.Btn_Area.OnClicked:Clear()
    self.Btn_Play.Btn_Area.OnClicked:Add(self, self.OpenAccessoryVideo)
end

function M:OpenAccessoryVideo()
    local Data = rawget(self,"AccessoryVideoData") or {}
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
    local SkinVideo = UIManager(self):LoadUINew("ArmorySkinVideo_Sp",{
        Path = Data.Video,
        SoundPath = Data.GetSoundPath,
        DestructCB = function()
            self:SetFocus()
        end
    })
    if(SkinVideo)then
        SkinVideo:SetFocus()
    end
end

function M:OpenSkinVideo()
    local Data = rawget(self,"SkinData") or {}
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
    local SkinVideo = UIManager(self):LoadUINew("ArmorySkinVideo",{
        Path = Data.DisplayPath,
        SoundPath = Data.GetSoundPath,
        DestructCB = function()
            self:SetFocus()
        end
    })
    if(SkinVideo)then
        SkinVideo:SetFocus()
    end
end

function M:UpdateFunctionBtn(Content,CurrentContent)
    self.LeftConfirmBtnFunc = nil
    self.RightConfirmBtnFunc = nil
    self.WS_Btn:SetActiveWidgetIndex(0)
    self.Ws_Btn_Go:SetActiveWidgetIndex(0)
    if(not self.IsTargetUnowned and not self.IsPreviewMode and not self.IsCharacterTrialMode and Content.bDyeable and not Content.LockType)then
        self.Panel_Dye:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Panel_Dye:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.Btn_Function:UnBindEventOnClickedByObj(self)
    self.Btn_Package_Buy:UnBindEventOnClickedByObj(self)
    self.Btn_Package_Open:UnBindEventOnClickedByObj(self)
    self.Btn_Package_Buy:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Package_Open:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.CurrentLockContent = nil
    self.UseParamsInOpt = nil
    if(CurrentContent == Content)then
        self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Equipped)
        if(self.IsTargetUnowned)then
            self.Text_Desc:SetText(GText("UI_CharPreview_Accessory_In_Trial"))
        else
            self.Text_Desc:SetText(GText("UI_Accessory_Equipped"))
        end
    else
        if(Content.LockType)then
            self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Unequipped)
            self.CurrentLockContent = Content
            local CurGoToShopState = self:CheckSkinGoToShopState()
            self.UseParamsInOpt = self:CheckIsOptReward(Content)
            if self.UseParamsInOpt then
                --可使用自选包
                self.Ws_Btn_Go:SetActiveWidgetIndex(2)
                self.Btn_Package_Open:SetText(GText("UI_Skin_UseResource"))
                self.Btn_Package_Open:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
                self.Btn_Package_Open:BindEventOnClicked(self,self.OnRightConfirmBtnClicked)
                self.RightConfirmBtnFunc = self.OnRightConfirmBtnClicked
                if CurGoToShopState == GoToShopState.CanGoToShop then
                    self.Btn_Package_Buy:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
                    self.Btn_Package_Buy:SetText(GText("UI_Skin_GotoBuy"))
                    self.Btn_Package_Buy:ForbidBtn(false)
                    self.Btn_Package_Buy:BindEventOnClicked(self,self.OnLeftConfirmBtnClicked)
                    self.LeftConfirmBtnFunc = self.OnLeftConfirmBtnClicked
                end
            else
                if CurGoToShopState == GoToShopState.CanGoToShop then
                    self.Btn_Function:SetText(GText("UI_Skin_GotoBuy"))
                    self.Btn_Function:ForbidBtn(false)
                    self.Btn_Function:BindEventOnClicked(self,self.OnRightConfirmBtnClicked)
                    self.RightConfirmBtnFunc = self.OnRightConfirmBtnClicked
                elseif CurGoToShopState == GoToShopState.ItemNotOnSale then
                    self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Equipped)
                    self.Text_Desc:SetText(GText("UI_Skin_CannotBuy"))
                elseif CurGoToShopState == GoToShopState.ItemIdNil or
                CurGoToShopState == GoToShopState.ItemNotExist or 
                CurGoToShopState == GoToShopState.SkinNotValid then
                    self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Equipped)
                    self.Text_Desc:SetText(GText("UI_Skin_CannotBuy"))
                end
            end
        else
            self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Unequipped)
            if(self.IsTargetUnowned)then
                self.Btn_Function:SetText(GText("UI_CharPreview_Cannot_Equip"))
                self.Btn_Function:ForbidBtn(true)
            else
                self.Btn_Function:SetText(GText("UI_Accessory_Equip"))
                self.Btn_Function:ForbidBtn(false)
            end
            self.Btn_Function:BindEventOnClicked(self,self.OnRightConfirmBtnClicked)
            self.RightConfirmBtnFunc = self.OnRightConfirmBtnClicked
        end
    end
    if(self.IsCharacterTrialMode)then
        if(CurrentContent == Content)then
            self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Equipped)
            self.Text_Desc:SetText(GText("UI_CharPreview_Accessory_In_Trial"))
        else
            if(Content.LockType)then
                self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Locked)
                self.Text_Lock:SetText(GText("UI_Aaccessory_Locked"))
                self.Btn_Function:ForbidBtn(true)
            else
                self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Unequipped)
                self.Btn_Function:SetText(GText("UI_CharPreview_Cannot_Equip"))
                self.Btn_Function:ForbidBtn(true)
            end
        end
    end
end

function M:CheckSkinGoToShopState()
    local SkinId = self.SelectedSkinId
    local SkinType
    if(self.CurrentTopTabIdx == self.SkinTabIdx)then
        SkinType = CommonConst.DataType.Skin
        SkinId = self.SelectedSkinId
    elseif(self.CurrentTopTabIdx == self.HairTabIdx)then
        SkinType = CommonConst.DataType.Hair
        SkinId = self.SelectedHairId
    end
    if(not SkinId or SkinId <= 0)then
        return GoToShopState.SkinNotValid
    end
    
    local SkinInfo
    if(self.Type == CommonConst.ArmoryType.Char)then
        SkinInfo = DataMgr[SkinType][SkinId]
    else
        SkinInfo = DataMgr.WeaponSkin[SkinId]
    end
    
    if not SkinInfo then 
        return GoToShopState.SkinNotValid
    end
    
    local ItemIds = SkinInfo.GoShopTypeId
    if not ItemIds or not next(ItemIds) then 
        return GoToShopState.ItemIdNil
    end
    local AllNotExist = true
    for _, ItemId in ipairs(ItemIds) do
        if DataMgr.ShopItem[ItemId] then	
            AllNotExist = false	
            break	
        end	
    end	
    if AllNotExist then	
        return GoToShopState.ItemNotExist
    end
    
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local AllInvalid = true
        for _, ItemId in ipairs(ItemIds) do	
            if Avatar:CheckIsEffective(ItemId) then	
                AllInvalid = false	
                break	
            end	
        end	
        if AllInvalid then	
            return GoToShopState.ItemNotOnSale	
        end	
    end
    
    return GoToShopState.CanGoToShop
end

--endregion 皮肤公共函数

--#region 配饰公共函数

---配饰点击时
function M:OnAccessoryItemClicked(Content)
    if(self.CurrentTopTabIdx == self.HairTabIdx)then
        --发型和配饰使用了同一个列表
        self:OnHairItemClicked(Content)
    else
        self:TrySelectAccessoryItem(Content)
    end
end

function M:OnAccessoryListSelectionChanged(Content,IsSelected)
end

function M:TrySelectAccessoryItem(Content)
    if(not Content.Icon)then
        return
    end
    if(self.ComparedContent == Content and not CommonConst.ActionAccessoryTypes[Content.AccessoryType])then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click", nil, nil)
    if(Content.AccessoryId)then
        AudioManager(self):PlayItemSound(self,Content.AccessoryId,"Equip",Content.SoundDataName)
    end
    self:SelectAccessoryItem(Content)
end

function M:SelectAccessoryItem(Content)
    ArmoryUtils:SetItemIsSelected(self.ComparedContent,false)
    self.ComparedContent = Content
    ArmoryUtils:SetItemIsSelected(self.ComparedContent,true)
    self:UpdateAccessoryDetails(Content)
    --其他逻辑在Component
end

function M:UpdateAccessoryDetails(Content)
    if(self.Type == "Char")then
        self:UpdateAccessoryCamera(Content.AccessoryId,Content.AccessoryType)
    end
    if(Content == self.NoneAccessory)then
        self:HideAllInfoExceptButton(true)
    else
        self:HideAllInfoExceptButton(false)
    end
    self.Panel_Dye:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Panel_Video:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Panel_Buy:SetVisibility(UIConst.VisibilityOp.Collapsed)
    --配饰自定义入口显隐
    self.WS_Btn:SetActiveWidgetIndex(1)
    local Panel = self.WS_Btn:GetWidgetAtIndex(1)
    if(Panel)then
        self.Btn_Custom:UnBindEventOnClickedByObj(self)
        if(Content.bAllowCustom and not self.IsCharacterTrialMode and not self.IsPreviewMode)then
            Panel:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            self.Btn_Custom:BindEventOnClicked(self,self.TryOpenAccessoryCustom)
            self.WS_Icon:SetActiveWidgetIndex(0)
        else
            Panel:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end
    --购买/装配按钮样式
    self.UseParamsInOpt = nil
    self.LeftConfirmBtnFunc = nil
    self.RightConfirmBtnFunc = nil
    rawset(self,"ResourceIdForBuyButton",nil)
    self.Btn_Function:UnBindEventOnClickedByObj(self)
    self.Ws_Btn_Go:SetActiveWidgetIndex(0)
    if(self.CurrentContent == Content)then
        self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Equipped)
        self.Text_Desc:SetText(GText("UI_Accessory_Equipped"))
        if self.IsCharacterTrialMode or self.IsTargetUnowned then
            self.Btn_Function:SetText(GText("UI_CharPreview_Accessory_In_Trial"))
        end
    else
        if(Content.LockType)then
            local ShopItemId = self:GetShopItemByAccessoryId(Content.AccessoryId)
            local ShopItemData = ShopItemId and DataMgr.ShopItem[ShopItemId]
            self.UseParamsInOpt = self:CheckIsOptReward(Content)
            local CanBuy = false
            local Price
            if(ShopItemData)then
                Price = ShopUtils:GetShopItemPrice(ShopItemData.ItemId)
                ShopItemData = setmetatable({}, {__index = ShopItemData})
                local CanPurchase = ShopUtils:CanPurchase(ShopItemData, ShopItemData.PriceType,Price)
                CanBuy = ShopUtils:GetShopItemCanShow(ShopItemId) and CanPurchase
            end
            local BuyFunc = function(Btn)
                if(not self.IsPreviewMode)then
                    self.Panel_Buy:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
                end
                self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Unequipped)
                Btn:SetText(GText("UI_SHOP_PURCHASE"))
                local ShopItemData = DataMgr.ShopItem[ShopItemId]
                local PriceType = ShopItemData.PriceType
                local Avatar = GWorld:GetAvatar()
                local ResourceCount = Avatar.Resources[PriceType] and Avatar.Resources[PriceType].Count or 0
                local FakeDenominator
                if(Price > ResourceCount)then
                    FakeDenominator = Price + ResourceCount + 1
                else
                    FakeDenominator = Price
                end
                self.WBP_Com_Cost:InitContent({
                    ResourceId = ShopItemData.PriceType,
                    --bShowDenominator = true,
                    Denominator = FakeDenominator,
                    Numerator = Price,
                })
                rawset(self,"ResourceIdForBuyButton",PriceType)
                if(Price > ResourceCount)then
                    if(PriceType == CommonConst.Coins.Coin4 or PriceType == CommonConst.Coins.Coin1)then
                        local func = function()
                            self:ShowChargeDialog(Price,PriceType)
                        end
                        Btn:ForbidBtn(false)
                        Btn:BindEventOnClicked(self,func)
                        return func
                    else
                        Btn:ForbidBtn(true)
                    end
                else
                    Btn:ForbidBtn(false)
                    Btn:BindEventOnClicked(self,self.OnBuyBtnClicked)
                    return self.OnBuyBtnClicked
                end
            end

            if self.UseParamsInOpt then
                -- 去背包使用自选包
                self.Ws_Btn_Go:SetActiveWidgetIndex(2)
                self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Unequipped)
                self.Btn_Package_Open:SetText(GText("UI_Skin_UseResource"))
                self.Btn_Package_Open:ForbidBtn(false)
                self.Btn_Package_Open:BindEventOnClicked(self,self.OnUseOptBtnClicked)
                self.RightConfirmBtnFunc = self.OnUseOptBtnClicked
                if(CanBuy)then
                    self.LeftConfirmBtnFunc = BuyFunc(self.Btn_Package_Buy)
                end
            elseif(CanBuy)then
                --可购买
                self.RightConfirmBtnFunc = BuyFunc(self.Btn_Function)
            else
                self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Locked)
                if(Content.UnlockOptionText and Content.UnlockOptionText ~= "")then
                    self.Text_Lock:SetText(Content.UnlockOptionText)
                    self.Btn_Function:ForbidBtn(true)
                else
                    self.Text_Lock:SetText(GText("UI_Aaccessory_Locked"))
                    self.Btn_Function:ForbidBtn(true)
                end
            end
            if self.IsCharacterTrialMode then
                self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Locked)
                if(Content.UnlockOptionText and Content.UnlockOptionText ~= "")then
                    self.Text_Lock:SetText(Content.UnlockOptionText)
                else
                    self.Text_Lock:SetText(GText("UI_Aaccessory_Locked"))
                end
            end
        else
            self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Unequipped)
            self.Btn_Function:SetText(GText("UI_Accessory_Equip"))
            self.Btn_Function:BindEventOnClicked(self,self.OnRightConfirmBtnClicked)
            self.RightConfirmBtnFunc = self.OnRightConfirmBtnClicked
            self.Btn_Function:ForbidBtn(false)
            if self.IsCharacterTrialMode or self.IsTargetUnowned then
                self.Btn_Function:SetText(GText("UI_CharPreview_Cannot_Equip"))
                self.Btn_Function:ForbidBtn(true)
            end
        end
    end

    --详情描述
    if(Content == self.NoneAccessory)then
        return
    end
    local Data
    if(self.Type == CommonConst.ArmoryType.Char)then
        Data = DataMgr.CharAccessory[Content.AccessoryId] or DataMgr.CharPartMesh[Content.AccessoryId]
        self.Text_CharName:SetText(GText(UIConst.AccessoryTypeTextMap[Data.AccessoryType] or ""))
    else
        Data = DataMgr.WeaponAccessory[Content.AccessoryId]
        self.Text_CharName:SetText(GText(UIConst.AccessoryTypeTextMap["WeaponAccessory"]))
        self:UpdateWeaponStanceFXInfo(Content)
    end
    self:UpdateAccessoryVideo(Data)
    if Data.Rarity and self.NameFont[Data.Rarity] and self[self.NameFont[Data.Rarity]] then
        self.Text_Name:SetFont(self[self.NameFont[Data.Rarity]])
    end
    self.Text_Name:SetText(GText(Data.Name))
    self.Text_Info:SetText(GText(Data.Des))
    self.Text_SkinName_World:SetText(EnText(Data.Name))
    self.Text_Char_None:SetVisibility(ESlateVisibility.Collapsed)
    self.Image_Element:SetVisibility(ESlateVisibility.Collapsed)
    self.Tag_Quality:SetVisibility(ESlateVisibility.Collapsed)
    local AccessoryIconPath = ArmoryUtils:GetCharNoneAccessoryIconPaths()[Data.AccessoryType]
    if AccessoryIconPath then
        local AccessoryIcon = LoadObject(AccessoryIconPath)
        self.Image_Element:SetBrushResourceObject(AccessoryIcon)
        self.Image_Element:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    if Data.Rarity then
        self.Tag_Quality:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Tag_Quality:Init(Data.Rarity)
    end
    if(not self:IsAnimationPlaying(self.In))then
        self:PlayAnimation(self.Change)
    end
    if(Content ~= self.NoneAccessory and Content.RedDotType)then
        if(not self.NoReddot)then
            ArmoryUtils:SetItemReddotRead(Content,true)
        end
    end
end

function M:HideAllInfoExceptButton(bHide)
    local Visibility = bHide and UIConst.VisibilityOp.Hidden or UIConst.VisibilityOp.SelfHitTestInvisible
    local AllChildren = self.VB_Info:GetAllChildren():ToTable() or {}
    for i = 1,#AllChildren - 1 do
        AllChildren[i]:SetVisibility(Visibility)
    end
    self.Mod_Title_Line:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Mod_Content:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:ShowChargeDialog(CostNum,CostType)
    UIManager(self):LoadUINew("ShopTargetPay",{
        CostNum = CostNum,
        CostType = CostType,
        -- RightCallbackObj = self,
        -- CallbackInfo = {
        --     Func = self.OnRechargeCallback,
        --     Obj = self,
        -- }
    }, self)
end

function M:OnUseOptBtnClicked()
    UIManager(self):LoadUINew("CharSkinPreview", self.UseParamsInOpt)
end

function M:OnBuyBtnClicked()
    local ShopItemId = self:GetShopItemByAccessoryId(self.ComparedContent.AccessoryId)
    local ShopItemData = DataMgr.ShopItem[ShopItemId]
    if(not ShopItemData)then
        return
    end
    local Price = ShopUtils:GetShopItemPrice(ShopItemData.ItemId)
    ---@type WBP_Common_Dialog_PC_C
    UIManager(self):ShowCommonPopupUI(100041, 
        { ShopItemData = ShopItemData,
        ShopType = 0,
        Funds = {{FundId = ShopItemData.PriceType,FundNeed = Price}},
        ShowParentTabCoin = true,
        RightCallbackObj = self,
        RightCallbackFunction = self.PurchaseAccessory,},
        self)
end

function M:GetOverrideTopResource()
    return self.Tab_Skin.OverridenTopResouces
end

---购买配饰
function M:PurchaseAccessory(PackageResult, DialogWidget)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local ShopItemId = self:GetShopItemByAccessoryId(self.ComparedContent.AccessoryId)
    local ShopItemData = DataMgr.ShopItem[ShopItemId]
    if(not ShopItemData)then
        return
    end
    local SelectedDiscount = nil
    if PackageResult and PackageResult.Content_1 and PackageResult.Content_1.CallObj then
        if PackageResult.Content_1.CallObj.SelectedDiscount then
            SelectedDiscount = PackageResult.Content_1.CallObj.SelectedDiscount
        end
    end
    self:BlockAllUIInput(true)
    Avatar:PurchaseShopItem(ShopItemData.ItemId, 1, nil, nil, SelectedDiscount and SelectedDiscount.VoucherId or nil)
end

function M:OnPurchaseShopItem(Ret)
    self:BlockAllUIInput(false)
    if Ret ~= ErrorCode.RET_SUCCESS then
        return
    end
end

function M:OnEquipedAccessoryContentChanged()
    ArmoryUtils:SetItemSelectTag(self.CurrentContent,false)
    ArmoryUtils:SetItemSelectTag(self.ComparedContent,true)
    self.CurrentContent = self.ComparedContent
    if(self.CurrentContent.AccessoryType)then
        self[self.CurrentContent.AccessoryType .. "Content"] = self.CurrentContent
    end
end

function M:GetShopItemByAccessoryId(AccessoryId)
    local ItemType = self.Type .. "Accessory"
    local Data = DataMgr.TypeId2ShopItem[ItemType]
    return Data and Data[AccessoryId] and Data[AccessoryId][1]
end

function M:InitAccessoryListCommon()
    local Tab = self.AccessoryTabsArray[self.CurrentAccessoryTabIdx]
    local Len = self.BP_AccessoryContents:Length()
    local FilteredContents = {}
    for i=1,Len do
        local Content = self.BP_AccessoryContents[i]
        if(Content.AccessoryId and Content.AccessoryType == Tab.AccessoryType
         and Content.AccessoryId ~= self.NoneAccessory.Id and not Content.IsHide)then
            table.insert(FilteredContents,Content)
        end
    end
    self.FilteredContents = FilteredContents
    self.List_Accessory:ClearListItems()
    table.sort(FilteredContents,function(a,b)
        if (a.LockType and b.LockType) or (not a.LockType and not b.LockType) then
            if(a.SortPriority == b.SortPriority)then
                return a.AccessoryId > b.AccessoryId
            end
            return a.SortPriority > b.SortPriority
        else
            return b.LockType
        end
    end)
    self.List_Accessory:SetVisibility(UIConst.VisibilityOp.Visible)
    --无配饰放在前面
    self.List_Accessory:AddItem(self.NoneAccessory)
    for _, Content in ipairs(FilteredContents) do
        if(self.JumpToAccessoryId)then
            if(self.JumpToAccessoryId == Content.AccessoryId)then
                self.ComparedContent = Content
            end
        end
        if(Content.bSelectTag)then
            self.CurrentContent = Content
            if(self.IsCharacterTrialMode) then
                Content.TryOutText = GText("UI_CharPreview_Accessory_In_Trial")
            end
        end
        self.List_Accessory:AddItem(Content)
    end
    self.List_Accessory:RequestFillEmptyContent()
    self.List_Accessory:RequestPlayEntriesAnim()
end

--#endregion 配饰公共函数

-- 背包跳转使用自选包
function M:CheckIsOptReward(Content)
    local OptReward = DataMgr.OptReward
    local ContentType = Content.ItemType
    if ContentType == "Hair" then
        ContentType = "Skin"
    end
    for OptRewardId, Data in pairs(OptReward) do
        local ItemType = Data.Type[1]
        if ItemType == ContentType then
            for Index = 1, #Data.Type do
                if Data.Id[Index] == (Content.ItemId or Content.Id) then
                    -- 找到对应自选包
                    local Avatar = GWorld:GetAvatar()
                    local ResourceData = Avatar.Resources[Data.ResourceId]
                    if ResourceData and ResourceData.Count > 0 then
                        local ResourceInfo = DataMgr.Resource[Data.ResourceId]
                        local UseEffectType = ResourceInfo.UseEffectType

                        local Params = {}

                        if UseEffectType == CommonConst.ResUseEffectType.SelectGeneralSkin then
                            Params = {Type = "SelectGeneralSkin", OptRewardId = OptRewardId, ResourceId = Data.ResourceId, SkinId = Data.Id[Index]}
                        elseif UseEffectType == CommonConst.ResUseEffectType.SelectCharAccessory then
                            Params = {Type = "SelectCharAccessory", OptRewardId = OptRewardId, ResourceId = Data.ResourceId, AccessoryId = Data.Id[Index]}
                        elseif UseEffectType == CommonConst.ResUseEffectType.SelectWeaponSkin then
                            Params = {Type = "SelectWeaponSkin", OptRewardId = OptRewardId, ResourceId = Data.ResourceId, SkinId = Data.Id[Index]}
                        elseif UseEffectType == CommonConst.ResUseEffectType.SelectWeaponAccessory then
                            Params = {Type = "SelectWeaponAccessory", OptRewardId = OptRewardId, ResourceId = Data.ResourceId, AccessoryId = Data.Id[Index]}
                        elseif UseEffectType == CommonConst.ResUseEffectType.SelectSkin then
                            Params = {Type = "SelectSkin", OptRewardId = OptRewardId, ResourceId = Data.ResourceId, SkinId = Data.Id[Index]}
                        elseif UseEffectType == CommonConst.ResUseEffectType.SelectGestureItem then
                            Params = {Type = "SelectGestureItem", OptRewardId = OptRewardId, ResourceId = Data.ResourceId, GestureId = Data.Id[Index]}
                        end
                        Params.SkinId = self.SelectedSkinId or (self.Target and self.Target:GetAppearance().SkinId)
                        return Params
                    end
                end
            end
        end
    end
    return nil
end
-- #endregion

function M:UpdateBtnStateByResourceChanged(ResourceId)
    local ResourceData = DataMgr.Resource[ResourceId]
    if not ResourceData then
        DebugPrint("No Resource Data for ID:" .. tostring(ResourceId))
        return
    end

    if ResourceData.MaterialClassify == 7
     or (rawget(self,"ResourceIdForBuyButton") and rawget(self,"ResourceIdForBuyButton") == ResourceId) then
        -- 自选类型资源、更新购买状态
        if (self.CurrentTopTabIdx == self.SkinTabIdx) then
            local SelectedContent = self.SkinMap[self.SelectedSkinId]
            self:UpdateFunctionBtn(SelectedContent, self.CurrentSkinContent)
        elseif (self.CurrentTopTabIdx == self.HairTabIdx) then
            local SelectedContent = self.HairMap[self.SelectedHairId]
            self:UpdateFunctionBtn(SelectedContent, self.CurrentHairContent)
        elseif (self.CurrentTopTabIdx == self.AccessoryTabIdx) then
            local SelectContent = self.ComparedContent
            self:UpdateAccessoryDetails(SelectContent)
        end
    end

    -- 刷一下皮肤升级红点
    if (ResourceId == 100 or ResourceId == 99) then
        self:RefreshLevelUpReddot()
    end
end

---隐藏UI时ESC按下/鼠标左键按下
function M:OnHideUIKeyDown()
    self.bSelfHidden = not self.bSelfHidden
    if(self.bSelfHidden)then
        self:SetRenderOpacity(0)
        self.Image_Click.Slot:SetZOrder(10)
    else
        self:SetRenderOpacity(1)
        self.Image_Click.Slot:SetZOrder(-1)
    end
end

function M:ResetTarget()
    if(self.IsPreviewMode)then
        return
    end
    local Avatar = ArmoryUtils:GetAvatar()
    if(self.Type == CommonConst.ArmoryType.Char)then
        self.Target = Avatar.Chars[self.Target.Uuid] or self.Target
    else
        self.Target = Avatar.Weapons[self.Target.Uuid] or self.Target
    end
end

function M:OpenDye()
    local Content
    local SkinType
    if(self.CurrentTopTabIdx == self.SkinTabIdx)then
        Content = self.SkinMap[self.SelectedSkinId]
        SkinType = CommonConst.DataType.Skin
    elseif(self.CurrentTopTabIdx == self.HairTabIdx)then
        Content = self.HairMap[self.SelectedHairId]
        SkinType = CommonConst.DataType.Hair
    end
    if(self.IsTargetUnowned or not Content or not Content.bDyeable or (Content.LockType and not self.IsPreviewMode))then
        return
    end
    local Params = {Target = self.Target,Type = self.Type,SkinId = self.SelectedSkinId,
    HairId = self.SelectedHairId, IsPreviewMode = self.IsPreviewMode,Parent = self,SkinType = SkinType,
    OnCloseCallback = function()
        self:ResetTarget()
    end}
    if Params.Target then
        if type(Params.Target.Uuid) == "number" then
            Params.Target.Uuid = Params.SkinId
            local RealAvatar = ArmoryUtils:GetAvatar()
            if RealAvatar and self.Type == CommonConst.ArmoryType.Char and RealAvatar.Chars then
                for CharUuid, RealChar in pairs(RealAvatar.Chars) do
                    if RealChar.CharId == Params.Target.CharId then
                        Params.Target = RealChar
                        Params.bRealCharOrWeapon = true
                        break
                    end
                end
            elseif self.Type == CommonConst.ArmoryType.Weapon and RealAvatar.Weapons then
                for WeaponUuid, RealWeapon in pairs(RealAvatar.Weapons) do
                    if RealWeapon.WeaponId == Params.Target.WeaponId then
                        Params.Target = RealWeapon
                        Params.bRealCharOrWeapon = true
                        break
                    end
                end
            end
        else
            Params.bRealCharOrWeapon = true
        end
    end
    local UIConfig = DataMgr.SystemUI.ArmoryDye
    if self.Parent then
        UIManager(self):LoadUI(UIConst.LoadInConfig, UIConfig.UIName,self:GetZOrder(),Params)
    else
        UIManager(self):LoadUI(UIConst.LoadInConfig, UIConfig.UIName,100,Params)
    end
end

function M:PlayInAnim()
    self:BlockAllUIInput(true,"SP_DisplayOnly")
    if(self.InAnimStyle)then
        self.ComBgSwitch = self:CreateWidgetNew("ComBgSwitch")
        if(self.ComBgSwitch)then
            self.ComBgSwitch:AddToViewport(self:GetZOrder())
            self.ComBgSwitch:PlayAnimation(self.ComBgSwitch.In)
            self.ComBgSwitch:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
            self:SetRenderOpacity(0)
            self:AddTimer(0.3,function()
                self:SetRenderOpacity(1)
                self:Init(self.Params)
                self:StopAnimation(self.Out)
                self:PlayAnimation(self.In)
            end,false, 0, "DelayInit")
        end
    else
        self:StopAnimation(self.Out)
        self:PlayAnimation(self.In)
    end
end

function M:PlayOutAnim()
    self:StopAnimation(self.In)
    self:PlayAnimation(self.Out)
    if(self.Parent)then
        self.ActorController.ViewUI = self.Parent
    end
    if(self.IsPreviewMode and self.ActorController)then
        self.ActorController:OnClosed()
    end
    AudioManager(self):SetEventSoundParam(self, "SkinOpen", {ToEnd = 1})
    self:BlockAllUIInput(true,"SP_DisplayOnly")
end

function M:OnInAnimFinished()
    self:BlockAllUIInput(false)
end

function M:OnOutAnimFinished()
    self:Close()
end

function M:RealClose()
    M.Super.RealClose(self)
    if(self.OnCloseCallback)then
        self.OnCloseCallback(self.Parent)
    end
end

function M:Destruct()
    if(self.ActorController)then
        if(self.Parent)then
            self.ActorController.ViewUI = self.Parent
        end
        self.ActorController:HidePlayerActor(self.UIName,false)
        self.ActorController:UpdateCameraPPSetting()
        self.ActorController:TryDestroySequenceActorController()
    end
    self:RemoveTimer("DelayInit")
    if(IsValid(self.ComBgSwitch))then
        self.ComBgSwitch:RemoveFromParent()
    end
    self:RemoveTopTabReddotListen()
    if(self.BlackScreenHandle)then
        UIManager(self):HideCommonBlackScreen(self.BlackScreenHandle)
    end
    M.Super.Destruct(self)
    if(self.bRecoverAppearanceWhenDestruct and not self.IsPreviewMode)then
        self.SelectedSkinLevel = nil
        self:UpdateActorAppearance()
    end
end

AssembleComponents(M)

return M
