--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local WBP_BattlePass_Main_C = Class("BluePrints.UI.BP_UIState_C")
WBP_BattlePass_Main_C._components = {
    "BluePrints.UI.WBP.Armory.ActorController.PreviewActorComponent",
	"BluePrints.UI.WBP.Armory.MainComponent.Armory_PointerInputComponent",
}
local CommonUtils = require "Utils.CommonUtils"
local BattlePassController = require "BluePrints.UI.WBP.BattlePass.Controller.BattlePassController"

function WBP_BattlePass_Main_C:Construct()
    self.Super.Construct(self)
    BattlePassController:SetModelData("IsLastVersionPet", false)
    BattlePassController:SetModelData("InCold", false)
    BattlePassController:SetModelData("CurTabId", nil)
    BattlePassController:SetModelData("BPRewardTyppe", BattlePassController:GetModelData("BattlePassInfo").BPRewardTyppe)
    BattlePassController:SetModelData("TargetSkinId", nil)
    BattlePassController:SetModelData("AccessoryId", nil)
    self.CurWidget = nil
    self.AllTabInfo = {}
    self.Index2TabId = {}
    self.TabId2Index = {}
    self.TabId2Widget = {
        BattlePassReward = self.BattlePass_Book,
        BattlePassMission = self.BattlePass_Book,
        BattlePassPetSelection = self.BattlePass_PetSelection,
    }
    self.OpenKey = CommonUtils:GetActionMappingKeyName("OpenBattlePass")
    self.BattlePass_Book:Init(self)
    self.BattlePass_PetSelection:GetParent(self)
    self.DefaultTabId = "BattlePassReward"

    self.BattlePass_PetSelection:SetVisibility((UIConst.VisibilityOp.Collapsed))
    self.BattlePass_Book:SetVisibility((UIConst.VisibilityOp.Collapsed))

	EventManager:AddEvent(EventID.BattlePassVersionChange, self, self.PlayOutAnim)
    EventManager:AddEvent(EventID.BattlePassPetCanClaim, self, self.OnBattlePassPetSelectionReddotChange)
    EventManager:AddEvent(EventID.BattlePassPetClaimed, self, self.OnBattlePassPetSelectionReddotChange)
    EventManager:AddEvent(EventID.BattlePassPurchaseClose, self, self.OnBattlePassPurchaseClose)
    EventManager:AddEvent(EventID.BattlePassPetChange, self, self.PageTurnerToNext)
    EventManager:AddEvent(EventID.BattlePassSkinClose, self, self.OnBattlePassSkinClose)

	if self.Image_Click then
    	self.Image_Click.OnMouseButtonDownEvent:Unbind()
    	self.Image_Click.OnMouseButtonDownEvent:Bind(self,self.On_Image_Click_MouseButtonDown)
	end
end

function WBP_BattlePass_Main_C:Destruct()
    AudioManager(self):StopSound(self, "SystemOpenSound")
	EventManager:RemoveEvent(EventID.BattlePassVersionChange, self)
    self:RemoveRefreshPetTimer()
    BattlePassController:GetModel():RemoveModelDataRefCount("ActorController", function(Target)
        if not Target or not IsValid(Target) then return end
        Target:OnClosed()
        Target:OnDestruct()
    end)
    self.Super.Destruct(self)
end

function WBP_BattlePass_Main_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "SystemOpenSound", nil)
    self:TryDecreaceBattlePassNewVisionReddot()

    self:SetPreviewActor()

    self:PlayInAnim()
    local TargetTabId = ...
    if not TargetTabId then
        TargetTabId = self.DefaultTabId
    end
    local Avatar = BattlePassController:GetAvatar()
    if Avatar then
        BattlePassController:SetModelData("IsLastVersionPet", Avatar.BattlePassLastVersionHasUnclaimedPet)
    end
    if BattlePassController:GetModelData("IsLastVersionPet") then
        self:SwitchOneTab("BattlePassPetSelection")
    else
        self:SwitchTab(TargetTabId)
    end
    self.BattlePass_Book:CheckBattlePassAutoGetTaskReward()
end

function WBP_BattlePass_Main_C:OnBattlePassRewardReddotChange()
    self:OnReddotChange("BattlePassReward")
end

function WBP_BattlePass_Main_C:OnBattlePassMissionReddotChange()
    self:OnReddotChange("BattlePassMission")
end

function WBP_BattlePass_Main_C:OnBattlePassPetSelectionReddotChange()
    self:OnReddotChange("BattlePassPetSelection")
end

function WBP_BattlePass_Main_C:OnReddotChange(TabId)
    local Index = self.TabId2Index[TabId]
    if Index then
        local TreeNode = ReddotManager.GetTreeNode(TabId)
        local Reddot = false
        if TreeNode and TreeNode.Count > 0 then
            Reddot = true
        end

        local Item = self.Tab_BattlePass.EMScrollBox_TabItem:GetChildAt(math.max(Index - 1, 0))
        if Item and Item.Info.TabId == TabId then
            if Reddot then
                Item.Reddot:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            else
                Item.Reddot:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
        end
    end
end

function WBP_BattlePass_Main_C:PlayInAnim()
    if (self:IsAnimationPlaying(self.In)) then
        return
    end
    self:PlayAnimationForward(self.In)
end

function WBP_BattlePass_Main_C:SwitchOneTab(TargetTabId)
    self:InitTabInfo_OneTabState(TargetTabId)
    self:RealSwitchTab({TabId = TargetTabId})
    return self:GetWidgetByTabId(TargetTabId)
end

function WBP_BattlePass_Main_C:SwitchTab(TargetTabId)
    self:InitTabInfo()
    self:AddReddotListener()
    self:SelectTabByTabId(TargetTabId)
    return self:GetWidgetByTabId(TargetTabId)
end

function WBP_BattlePass_Main_C:InitTabInfo_OneTabState(TargetTabId)
    self:InitCommonTab_OneTabState(TargetTabId)
end

function WBP_BattlePass_Main_C:InitTabInfo()
    local PlayTab = CommonUtils.Copy(DataMgr.BattlePassTab)
    self.SortedTabInfo = {}
    for _, TabInfo in pairs(PlayTab) do
        table.insert(self.SortedTabInfo, TabInfo)
    end
    self:SortTab()
    self:InitSortedTab()
    self:InitCommonTab()
end

function WBP_BattlePass_Main_C:SortTab()
    table.sort(self.SortedTabInfo, function(a, b)
        return a.Sequence > b.Sequence
    end)
end

function WBP_BattlePass_Main_C:InitSortedTab()
    self.AllTabInfo = {}
    self.Index2TabId = {}
    self.TabId2Index = {}
    for Index, TabInfo in ipairs(self.SortedTabInfo) do
        local NewTabInfo = {}
        NewTabInfo.Text = GText(TabInfo.TabName)
        NewTabInfo.TabId = TabInfo.WidgetUI
        NewTabInfo.SortId = -Index
        NewTabInfo.Callback = "RealSwitchTab"
        NewTabInfo.ItemDefaultCapcity = 999
        NewTabInfo.IconPath = TabInfo.TabIcon
        table.insert(self.AllTabInfo, NewTabInfo)
        self.Index2TabId[Index] = TabInfo.WidgetUI
        self.TabId2Index[TabInfo.WidgetUI] = Index
    end
end

function WBP_BattlePass_Main_C:AddReddotListener()
    if self.Index2TabId then
        for Index, TabId in ipairs(self.Index2TabId) do
            if DataMgr.ReddotNode[TabId] then
                ReddotManager.AddListener(TabId, self, self["On" .. TabId .. "ReddotChange"])
            end
        end
    end
end

function WBP_BattlePass_Main_C:RemoveReddotListener()
    if self.Index2TabId then
        for Index, TabId in ipairs(self.Index2TabId) do
            if DataMgr.ReddotNode[TabId] then
                ReddotManager.RemoveListener(TabId, self)
            end
        end
    end
end

function WBP_BattlePass_Main_C:InitCommonTab()
    self.TabConfigData = {
        TitleName = GText("MAIN_UI_BATTLEPASS"),
        LeftKey = "Q",
        RightKey = "E",
        Tabs = self.AllTabInfo,
        DynamicNode = { "Back", "ResourceBar", "BottomKey" },
        StyleName = "TextImage",
        OwnerPanel = self,
        BackCallback = self.OnClickBack,
        BottomKeyInfo = { { KeyInfoList = { { Type = "Text", Text = "Esc", ClickCallback = self.OnClickBack, Owner = self } }, Desc = GText("UI_BACK"), bLongPress = false } }, GamePadInfoList = {{Type="Img", ImgShortPath="B"}},
        PopupInfoId = DataMgr.SystemUI["BattlePassMain"].PopupInfoId
    }
    self.Tab_BattlePass:Init(self.TabConfigData, true)
    self.Tab_BattlePass:BindEventOnTabSelected(self, self.RealSwitchTab)
end

function WBP_BattlePass_Main_C:InitCommonTab_OneTabState(TargetTabId)
    self.TabConfigData = {
        TitleName = GText("MAIN_UI_BATTLEPASS"),
        DynamicNode = { "Back", "ResourceBar", "BottomKey" },
        StyleName = "Text",
        OwnerPanel = self,
        BackCallback = self.OnClickBack,
        BottomKeyInfo = { { KeyInfoList = { { Type = "Text", Text = "Esc", ClickCallback = self.OnClickBack, Owner = self } }, Desc = GText("UI_BACK"), bLongPress = false } }, GamePadInfoList = {{Type="Img", ImgShortPath="B"}},
    }
    self.Tab_BattlePass:Init(self.TabConfigData, true)
end

function WBP_BattlePass_Main_C:UpdateBottomKeyInfo(BottomKeyInfo)
    if self.Tab_BattlePass.UpdateBottomKeyInfo then
        self.Tab_BattlePass:UpdateBottomKeyInfo(BottomKeyInfo)
    end
end

function WBP_BattlePass_Main_C:SelectTabByTabId(TabId)
    self.Tab_BattlePass:SelectTabById(TabId)
end

function WBP_BattlePass_Main_C:SelectTab(Index)
    self.Tab_BattlePass:SelectTab(Index)
end

function WBP_BattlePass_Main_C:GetWidgetByTabId(TabId)
    if self.TabId2Widget then
        return self.TabId2Widget[TabId]
    end
end

function WBP_BattlePass_Main_C:RealSwitchTab(Info, ...)
    local TabId = Info.TabId
    if Info.GetTabId then
        TabId = Info:GetTabId()
    end
    local Widget = self.TabId2Widget[TabId]
    if BattlePassController:GetModelData("CurTabId") == TabId then
        self.CurWidget:SetFocus()
        return self.CurWidget
    end
    if self.CurWidget then
        if self.CurWidget == Widget then
            self.CurWidget:SwitchState(TabId, ...)
            self.CurWidget:SetFocus()
            return self.CurWidget
        else
            if self.CurWidget and self.CurWidget.SwitchOut then
                self.CurWidget:SwitchOut(TabId, ...)
            end
        end
    end
    self.CurWidget = Widget
    if self.CurWidget and self.CurWidget.SwitchIn then
        self.CurWidget:SwitchIn(TabId, ...)
    end
    self.CurWidget:SetFocus()
    BattlePassController:SetModelData("CurTabId", TabId)
    return self.CurWidget
end

function WBP_BattlePass_Main_C:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if self.CurWidget and self.CurWidget.HandleKeyDown then
        IsEventHandled = self.CurWidget:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    end
    return IsEventHandled
end

function WBP_BattlePass_Main_C:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if self.CurWidget and self.CurWidget.HandleKeyDown then
        IsEventHandled = self.CurWidget:HandleKeyDown(MyGeometry, InKeyEvent)
    end
    if not IsEventHandled then
        if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
            IsEventHandled = self.Tab_BattlePass:Handle_KeyEventOnGamePad(InKeyName)
        else
            if (InKeyName == "Escape" or InKeyName == self.OpenKey) then
                IsEventHandled = true
                self:OnReturnKeyDown()
            elseif (InKeyName == "Q") then
                IsEventHandled = true
                self.Tab_BattlePass:TabToLeft()
            elseif (InKeyName == "E") then
                IsEventHandled = true
                self.Tab_BattlePass:TabToRight()
            end
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function WBP_BattlePass_Main_C:OnKeyUp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if self.CurWidget and self.CurWidget.HandleKeyUp then
        IsEventHandled = self.CurWidget:HandleKeyUp(MyGeometry, InKeyEvent)
    end
    if not IsEventHandled then
        if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
            
        else
            
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function WBP_BattlePass_Main_C:OnReturnKeyDown()
    UIUtils.PlayCommonBtnSe(self)
    self:OnClickBack()
end

function WBP_BattlePass_Main_C:OnClickBack()
    if self:IsAnimationPlaying(self.In) then
        return
    end
    self:PlayOutAnim()
end

function WBP_BattlePass_Main_C:PlayOutAnim()
    if (self:IsAnimationPlaying(self.Out)) then
        return
    end
    AudioManager(self):SetEventSoundParam(self, "SystemOpenSound", { ToEnd = 1 })
    self:BlockAllUIInput(true,"SP_DisplayOnly")
    self:BindToAnimationFinished(self.Out, { self, self.Close })
    self.BattlePass_Book:TryCloseLevelUpUI()
    self.BattlePass_Book:TryClosePopupUI()
    self.CurWidget:PlayAnimationForward(self.CurWidget.Out)
    self:PlayAnimationForward(self.Out)
end

function WBP_BattlePass_Main_C:ShowIntro()
end

function WBP_BattlePass_Main_C:TryDecreaceBattlePassNewVisionReddot()
    if not ReddotManager.GetTreeNode("BattlePassNewVision")  then
		ReddotManager.AddNode("BattlePassNewVision")
	end
    local Node = ReddotManager.GetTreeNode("BattlePassNewVision")
    if Node.Count > 0 then
        ReddotManager.DecreaseLeafNodeCount("BattlePassNewVision", Node.Count)
    end
end

function WBP_BattlePass_Main_C:BP_GetDesiredFocusTarget()
    return self.CurWidget
end

function WBP_BattlePass_Main_C:Close()
    self:RemoveReddotListener()
    self.Super.Close(self)
end

function WBP_BattlePass_Main_C:SetPreviewActor()
    local Avatar = BattlePassController:GetAvatar()
    if Avatar then
        local GetCurrentCharAccessory = false
        local CharId = Avatar.Chars[Avatar.CurrentChar].CharId
        local SkinId = Avatar.Chars[Avatar.CurrentChar]:GetAppearance().SkinId
        if BattlePassController:GetModelData("BPRewardTyppe") == "Skin" then
            local SkinInfo = DataMgr.Skin
            for SkinId,Info in pairs(SkinInfo) do
                if Info.SkinSeries == BattlePassController:GetModelData("BattlePassInfo").PreviewSkinSeries then
                    if Info.CharId == CharId then
                        GetCurrentCharAccessory = true
                        BattlePassController:SetModelData("TargetSkinId", SkinId)
                        break
                    else
                        if not BattlePassController:GetModelData("TargetSkinId") or SkinId < BattlePassController:GetModelData("TargetSkinId") then
                            BattlePassController:SetModelData("TargetSkinId", SkinId)
                        end
                    end
                end
            end
            self.BattlePass_Book:InitSkinOrAccessoryInfo()
        elseif BattlePassController:GetModelData("BPRewardTyppe") == "Accessory" then
            GetCurrentCharAccessory = true
            BattlePassController:SetModelData("AccessoryId", BattlePassController:GetModelData("BattlePassInfo").AccessoryId)
            self.BattlePass_Book:InitSkinOrAccessoryInfo()
        else
            GetCurrentCharAccessory = true
            BattlePassController:SetModelData("TargetSkinId", SkinId)
        end
        local Params = {
            Type = "Char",
            SkinId = BattlePassController:GetModelData("TargetSkinId"),
            EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
            SystemType = "BattlePass",
            ViewUI = self,
        }
        local TempSkyBoxColor = BattlePassController:GetModelData("BattlePassInfo").SkyBoxColor
        if TempSkyBoxColor then
            local SkyBoxColor = {}
            SkyBoxColor.ColorCurve = TempSkyBoxColor.ColorCurve
            local BaseColor2 = TempSkyBoxColor.BaseColor2
            if BaseColor2 then
                SkyBoxColor.BaseColor2 = FLinearColor(BaseColor2[1],BaseColor2[2],BaseColor2[3],BaseColor2[4])
            end
            local StarColor = TempSkyBoxColor.StarColor
            if StarColor then
                SkyBoxColor.StarColor = FLinearColor(StarColor[1],StarColor[2],StarColor[3],StarColor[4])
            end
            Params.SkyBoxColor = SkyBoxColor
        end
        if GetCurrentCharAccessory then
            if not Params.Accessory then
                Params.Accessory = {}
            end
            local Char = Avatar.Chars[Avatar.CurrentChar]
            local AppearanceSuit = Char:GetAppearance()
            for k,v in pairs(AppearanceSuit.Accessory) do
                Params.Accessory[k] = v
            end
        end
        if BattlePassController:GetModelData("AccessoryId") then
            if not Params.Accessory then
                Params.Accessory = {}
            end
            self.AccessoryType = DataMgr.CharAccessory[BattlePassController:GetModelData("AccessoryId")].AccessoryType
            Params.Accessory[CommonConst.NewCharAccessoryTypes[self.AccessoryType]] = BattlePassController:GetModelData("AccessoryId")
        end
        self.Target = self:CreatePreviewTargetData(Params)
        Params.Target = self.Target
        BattlePassController:SetModelData("ActorController", self:CreatePreviewActor(Params))
        BattlePassController:GetModelData("ActorController"):OnOpened()
        BattlePassController:GetModel():AddModelDataRefCount("ActorController")
        self:HidePlayerFXAccessory(false)
        self:AddRefreshPetTimer()
        
        self:SetCameraAnim()
    end
end

function WBP_BattlePass_Main_C:SetCameraAnim()
    if BattlePassController:GetModelData("AccessoryId") then
        BattlePassController:GetModelData("ActorController"):SetMontageAndCamera("Char",nil,"Accessory_Reward")
    else
        BattlePassController:GetModelData("ActorController"):SetMontageAndCamera("Char",nil,"Skin_Reward")
    end
end

function WBP_BattlePass_Main_C:AddRefreshPetTimer()
    if not self:IsExistTimer("RefreshPetTimer") and BattlePassController:GetModelData("ActorController") then
        local Avatar = BattlePassController:GetAvatar()
        if Avatar then
            self.PetLength = #BattlePassController:GetModelData("BattlePassInfo").PetId
            self.PetIndex = CommonUtils:RandomInt(1,self.PetLength)
            self.PetParams = {
                Location = self.PetLocation
            }
            self:AddTimer(0.1,function()
                self:RealAddRefreshPetTimer()
            end,false,0,"PreRefreshPetTimer",true)
        end
    end
end

function WBP_BattlePass_Main_C:RealAddRefreshPetTimer()
    if self.PetParams then
        BattlePassController:GetModelData("ActorController"):ChangePetModel({PetId = BattlePassController:GetModelData("BattlePassInfo").PetId[self.PetIndex], Type = "BattlePass"}, nil, self.PetParams)
        self:AddTimer(15,function()
            self.PetIndex = self.PetIndex%(self.PetLength)+1
            BattlePassController:GetModelData("ActorController"):ChangePetModel({PetId = BattlePassController:GetModelData("BattlePassInfo").PetId[self.PetIndex], Type = "BattlePass"}, nil, self.PetParams)
        end,true,0,"RefreshPetTimer",true)
    end
end

function WBP_BattlePass_Main_C:RemoveRefreshPetTimer()
    self:RemoveTimer("PreRefreshPetTimer")
    self:RemoveTimer("RefreshPetTimer")
    if BattlePassController:GetModelData("ActorController") then
        BattlePassController:GetModelData("ActorController"):DestroyPetEffectCreature()
    end
end

function WBP_BattlePass_Main_C:ChangePetActor(PetInfo)
    if(not BattlePassController:GetModelData("ActorController"))then
        return
    end
    BattlePassController:GetModelData("ActorController"):ChangePetModel(PetInfo,nil,{Rotation = FRotator(0,-10,0), Location = FVector(0,0,-40),Scale = FVector(2.68,2.68,2.68)})
end

function WBP_BattlePass_Main_C:HidePlayerActor(Tag,IsHidden)
    if(not BattlePassController:GetModelData("ActorController"))then
        return
    end
    BattlePassController:GetModelData("ActorController"):HidePlayerActor(Tag,IsHidden)
end

function WBP_BattlePass_Main_C:HidePetActor(Tag,IsHidden)
    if BattlePassController:GetModelData("ActorController") and BattlePassController:GetModelData("ActorController").EffectCreature then
        BattlePassController:GetModelData("ActorController").EffectCreature:SetActorHiddenInGame(IsHidden)
    end
end

function WBP_BattlePass_Main_C:HidePlayerFXAccessory(IsHidden)
    if self.AccessoryType and self.AccessoryType == CommonConst.CharAccessoryTypes.FX_Footprint then
        if IsHidden then
            BattlePassController:GetModelData("ActorController"):StopPlayerFX()
        else
            local Appearance = self.Target:GetAppearance()
            local AccessoryId = Appearance.Accessory[CommonConst.NewCharAccessoryTypes.FX_Footprint]
            BattlePassController:GetModelData("ActorController"):StopPlayerFX()
            BattlePassController:GetModelData("ActorController"):ShowPlayerFXAccessory(AccessoryId,CommonConst.CharAccessoryTypes.FX_Footprint)
        end
    end
end

function WBP_BattlePass_Main_C:On_Image_Click_MouseButtonDown(MyGeometry, MouseEvent)
    return self:OnPointerDown(MyGeometry, MouseEvent)
end

-- function WBP_BattlePass_Main_C:OnMouseWheel(MyGeometry, MouseEvent)
--     return self:OnMouseWheelScroll(MyGeometry, MouseEvent)
-- end

function WBP_BattlePass_Main_C:OnMouseButtonUp(MyGeometry, MouseEvent)
    return self:OnPointerUp(MyGeometry, MouseEvent)
end

function WBP_BattlePass_Main_C:OnMouseMove(MyGeometry, MouseEvent)
    return self:OnPointerMove(MyGeometry, MouseEvent)
end

function WBP_BattlePass_Main_C:OnTouchEnded(MyGeometry, InTouchEvent)
    return self:OnPointerUp(MyGeometry, InTouchEvent)
end

function WBP_BattlePass_Main_C:OnTouchMoved(MyGeometry, InTouchEvent)
    return self:OnPointerMove(MyGeometry, InTouchEvent)
end

function WBP_BattlePass_Main_C:OnMouseCaptureLost()
    self:OnPointerCaptureLost()
end

function WBP_BattlePass_Main_C:OnBackgroundClicked()
    if(self.bSelfHidden)then
        self:OnHideUIKeyDown()
    end
end

function WBP_BattlePass_Main_C:JumpToDetail()
    if BattlePassController:GetModelData("BPRewardTyppe") == "Skin" and BattlePassController:GetModelData("TargetSkinId") then
        UIManager(self):LoadUINew("CharSkinPreview", {Type = "BattlePassPreview", SkinId = BattlePassController:GetModelData("TargetSkinId")})
    elseif BattlePassController:GetModelData("BPRewardTyppe") == "Accessory" and BattlePassController:GetModelData("AccessoryId") then
        UIManager(self):LoadUINew("ArmorySkin", {Type = "Char", AccessoryId = BattlePassController:GetModelData("AccessoryId")})
    end
end

function WBP_BattlePass_Main_C:ReceiveEnterState(StackAction)
    WBP_BattlePass_Main_C.Super.ReceiveEnterState(self,StackAction)
    if BattlePassController:GetModelData("CurTabId") == "BattlePassReward" or BattlePassController:GetModelData("CurTabId") == "BattlePassMission" then
        self:AddRefreshPetTimer()
    elseif BattlePassController:GetModelData("CurTabId") == "BattlePassPetSelection" then
        self:HidePlayerActor("PetSelection", true)
        self:HidePetActor("PetSelection", true)
        self:HidePlayerFXAccessory(true)
        if self.CurSelectPetId then
            self:ChangePetActor({Type = "BattlePass",PetId = self.CurSelectPetId,})
        end
    end
end

function WBP_BattlePass_Main_C:ReceiveExitState(StackAction)
    WBP_BattlePass_Main_C.Super.ReceiveExitState(self, StackAction)
    self:RemoveRefreshPetTimer()
end

function WBP_BattlePass_Main_C:PageTurnerToNext()
    if not BattlePassController:GetModelData("InCold") then
        BattlePassController:SetModelData("InCold", true)
        self:AddTimer(1,function ()
            BattlePassController:SetModelData("InCold", false)
        end,false,0,nil,true)
        local NewPetIndex = self.PetIndex%(self.PetLength)+1
        self.PetIndex = NewPetIndex
        self:RemoveTimer("RefreshPetTimer")
        BattlePassController:GetModelData("ActorController"):ChangePetModel({PetId = BattlePassController:GetModelData("BattlePassInfo").PetId[self.PetIndex], Type = "BattlePass"}, nil, self.PetParams)
        self:RealAddRefreshPetTimer()
    end
end

function WBP_BattlePass_Main_C:PageTurnerToPrevious()
    if not BattlePassController:GetModelData("InCold") then
        BattlePassController:SetModelData("InCold", true)
        self:AddTimer(1,function ()
            BattlePassController:SetModelData("InCold", false)
        end,false,0,nil,true)
        local NewPetIndex = (self.PetIndex-1)%(self.PetLength)
        if NewPetIndex == 0 then
            NewPetIndex = self.PetLength
        end
        self.PetIndex = NewPetIndex
        self:RemoveTimer("RefreshPetTimer")
        BattlePassController:GetModelData("ActorController"):ChangePetModel({PetId = BattlePassController:GetModelData("BattlePassInfo").PetId[self.PetIndex], Type = "BattlePass"}, nil, self.PetParams)
        self:RealAddRefreshPetTimer()
    end
end

function WBP_BattlePass_Main_C:OnBattlePassPurchaseClose()
    self:SetCameraAnim()
end

function WBP_BattlePass_Main_C:OnBattlePassSkinClose()
    self:SetCameraAnim()
end

AssembleComponents(WBP_BattlePass_Main_C)

return WBP_BattlePass_Main_C
