--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Rouge_Settlement_P_C
local WBP_Rouge_Settlement_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_Rouge_Settlement_C:OnLoaded(...)
    WBP_Rouge_Settlement_C.Super.OnLoaded(self, ...)

    local LogicServerInfo = ...
    self.IsWin, self.ServerInfo, self.Points, self.TalentPoints, self.OuterShopTokens, self.SeasonId = table.unpack(LogicServerInfo)
    DebugPrint("RougeSettlement: ", self.IsWin, self.Points, self.TalentPoints, self.OuterShopTokens, self.SeasonId)
    PrintTable(self.ServerInfo, 10)
    self.Blessings = self.ServerInfo.Blessings
    self.Treasures = self.ServerInfo.Treasures
    self.PassRooms = self.ServerInfo.PassRooms

    self.IsInAnimFinished = false
    self.IsShowTips = false

    self.IsShowTipsConfirm = false

    -- 改一下ScrollBox的bControlScrollbarInside，
    -- 否则ScrollWidgetIntoView会自动显示滚动条，而设置滚动条可视性会失效
    self.EMScrollBox_Bless:SetControlScrollbarInside(false)
    self.EMScrollBox_Treasure:SetControlScrollbarInside(false)
    self.EMScrollBox_Event:SetControlScrollbarInside(false)


    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        self.IsMobile = true
    else
        self.IsMobile = false
    end

    self:InitTitleInfo()
    self:InitExitButton()
    self:InitBlessingsInfo()
    self:InitTreasuresInfo()
    self:InitEventsInfo()
    self:InitPointsInfo()
    self:InitTalentPointsInfo()
    self:InitOuterShopTokenInfo()
    self:InitTipsInfo()
    self:InitInputDeviceInfo()

    self:PlayInAnimation()
end

-- 初始化胜利/失败动效文字及标题
function WBP_Rouge_Settlement_C:InitTitleInfo()
    if self.IsWin then
        self.Text_Success01:SetText(GText("UI_RougeLike_End_Success01"))
        self.Text_Success02:SetText(GText("UI_RougeLike_End_Success02"))
        self.VX_Success01:SetText(GText("UI_RougeLike_End_Success01"))
        -- self.WorldText_Success01
    else
        self.Text_Fail01:SetText(GText("UI_RougeLike_End_Fail01"))
        self.Text_Fail02:SetText(GText("UI_RougeLike_End_Fail02"))
        -- self.WorldText_Fail01 同上
    end
    self.Text_Describe:SetText(GText("UI_RougeLike_End_Desc"))
end

-- 初始化退出按钮绑定事件/文字
function WBP_Rouge_Settlement_C:InitExitButton()
    if self.IsMobile then
        self.Btn_Close:Init("Close", self, self.OnExitButtonClicked)
    else
        self.Btn_Click.OnClicked:Add(self, self.OnExitButtonClicked)
        self.Text_Tips:SetText(GText("UI_RougeLike_End__ClickEmpty"))
    end
end

function WBP_Rouge_Settlement_C:OnExitButtonClicked()
    if self.IsInAnimFinished then
        if self.IsShowTips then
            self.IsShowTips = false
            return
        end
        DebugPrint("WBP_Rouge_Settlement_C: OnExitButtonClicked")
        self:BlockAllUIInput(true,"SP_DisplayOnly")
        self:BindToAnimationFinished(self.Settlement_Out, {self, self.OnOutAnimFinished})
        self:PlayAnimation(self.Settlement_Out)
    end
end

function WBP_Rouge_Settlement_C:OnOutAnimFinished()
    AudioManager(self):SetEventSoundParam(self, "SettlementSuccess", { ToEnd = 1 })
    AudioManager(self):StopSound(self, "SettlementSuccess")
    AudioManager(self):SetEventSoundParam(self, "SettlementFail", { ToEnd = 1 })
    AudioManager(self):StopSound(self, "SettlementFail")
    local GameState = UE4.UGameplayStatics.GetGameState(self)
	if GameState:IsInRegion() then
		self:OnCloseSettlementUI()
	else
		local Avatar = GWorld:GetAvatar()
        Avatar:ExitDungeonSettlement()
        -- Avatar.ExitFromRouge=true
        EventManager:AddEvent(EventID.OnExitDungeon, self, self.OnCloseSettlementUI)
	end
end

function WBP_Rouge_Settlement_C:OnCloseSettlementUI()
    EventManager:RemoveEvent(EventID.OnExitDungeon, self)
    self:BlockAllUIInput(false)
    self:Close()
end

-- 初始化刻印列表
function WBP_Rouge_Settlement_C:InitBlessingsInfo()
    -- local BlessingsMap = GWorld.RougeLikeManager.Blessings
    -- local BlessingNum = BlessingsMap:Num()
    local BlessingNum = CommonUtils.Size(self.Blessings)
    self.Text_BlessNum:SetText(BlessingNum)
    self.Text_Bless:SetText(GText("UI_RougeLike_End_Blessing"))
    if BlessingNum > 0 then
        for BlessingId, _ in pairs(self.Blessings) do
            local BlessingData = self:GetBlessingData(BlessingId)
            local BlessingItem = self:CreateWidgetNew("RougeSettlementBlessItem")
            BlessingItem:InitInfo(BlessingData)
            self.WrapBox_Bless:AddChild(BlessingItem)
            local Callback = function(bIsOpen)
                self.IsShowTips = bIsOpen
            end
            BlessingItem.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self, Callback)
        end
        self.IsShowTipsConfirm = true
    else
        self.Text_BlessEmpty:SetText(GText("UI_RougeLike_End_NoMod"))
        self.Bless_Empty:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

function WBP_Rouge_Settlement_C:GetBlessingData(BlessingId)
    local BlessingData = {}
    local BlessingInfo = DataMgr.RougeLikeBlessing[BlessingId]
    if not BlessingInfo then
        DebugPrint("RougeSettlement: Error! 找不到对应Blessing表里的数据，BlessingId:", BlessingId)
        return BlessingData
    end

    for k,v in pairs(BlessingInfo) do
        BlessingData[k] = v
    end
    BlessingData.ItemType = "Blessing"
    return BlessingData
end

-- 初始化宝物列表
function WBP_Rouge_Settlement_C:InitTreasuresInfo()
    --local TreasuresMap = GWorld.RougeLikeManager.Treasures
    local TreasureNum = CommonUtils.Size(self.Treasures)
    self.Text_TreasureNum:SetText(TreasureNum)
    self.Text_Treasure:SetText(GText("UI_RougeLike_End_Treasure"))
    if TreasureNum > 0 then
        for TreasureId, _ in pairs(self.Treasures) do
            local TreasureData = self:GetTreasueData(TreasureId)
            local TreasureItem = self:CreateWidgetNew("RougeSettlementTreasureItem")
            TreasureItem:InitInfo(TreasureData)
            self.WrapBox_Treasure:AddChild(TreasureItem)
            local Callback = function(bIsOpen)
                self.IsShowTips = bIsOpen
            end
            TreasureItem.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self, Callback)
        end
        self.IsShowTipsConfirm = true
    else
        self.Text_TreasureEmpty:SetText(GText("UI_RougeLike_End_NoMod"))
        self.Treasure_Empty:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

function WBP_Rouge_Settlement_C:GetTreasueData(TreasureId)
    local TreasureData = {}
    local TreasureInfo = DataMgr.RougeLikeTreasure[TreasureId]
    if not TreasureInfo then
        DebugPrint("RougeSettlement: Error! 找不到对应Treasue表里的数据，TreasureId:", TreasureId)
        return TreasureInfo
    end
    for k,v in pairs(TreasureInfo) do
        TreasureData[k] = v
    end
    TreasureData.ItemType = "Treasure"
    return TreasureData
end

-- 初始化事件列表
function WBP_Rouge_Settlement_C:InitEventsInfo()
    --local PassRooms = GWorld.RougeLikeManager.PassRooms
    local Rooms = DataMgr.RougeLikeRoom
    self.Text_Event:SetText(GText("UI_RougeLike_End_Event"))
    local EventNum = 0
    for _, RoomId in pairs(self.PassRooms) do
        if Rooms[RoomId].SettlementEventMainIcon ~= nil then
            local EventItem = self:CreateWidgetNew("RougeSettlementEventItem")
            local EventData = Rooms[RoomId]
            EventItem:InitInfo(EventData)
            self.WrapBox_Event:AddChild(EventItem)
            EventNum = EventNum + 1
        end
    end
    self.Text_EventNum:SetText(EventNum)
    if EventNum > 0 then
        self.IsShowTipsConfirm = true
    else
        self.Text_EventEmpty:SetText(GText("UI_RougeLike_End_NoMod"))
        self.Event_Empty:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

-- 初始化积分
function WBP_Rouge_Settlement_C:InitPointsInfo()
    self.Text_EarnPoints:SetText(self.Points)
    self.Text_Points:SetText(GText("UI_RougeLike_End_EndPoints"))

    local IconPath = DataMgr.RougeLikeSeason[self.SeasonId].EndPointsIcon
    if IconPath then
        UE.UResourceLibrary.LoadObjectAsync(self, IconPath, {self, WBP_Rouge_Settlement_C.OnEarnPointsIconLoadFinish})
    end
end

function WBP_Rouge_Settlement_C:OnEarnPointsIconLoadFinish(Object)
    if Object and IsValid(self) then
        self.Icon_FootPrint:SetBrushResourceObject(Object)
    end
end

-- 初始化天赋点
function WBP_Rouge_Settlement_C:InitTalentPointsInfo()
    local IconPath = DataMgr.Resource[205].Icon
    UE.UResourceLibrary.LoadObjectAsync(self,IconPath,{self,WBP_Rouge_Settlement_C.OnIconLoadFinish})
    -- self.Img_Icon:SetBrushResourceObject(LoadObject(IconPath))
    self.Text_TP:SetText(self.TalentPoints)
    self.Text_TalentPoints:SetText(GText("UI_RougeLike_End_TalentPoints"))
end

function WBP_Rouge_Settlement_C:OnIconLoadFinish(Object)
    if Object and IsValid(self) then
        self.Img_Icon:SetBrushResourceObject(Object)
    end
end

-- 初始化外部代币
function WBP_Rouge_Settlement_C:InitOuterShopTokenInfo()
    local IconPath = DataMgr.Resource[215].Icon
    local Name = DataMgr.Resource[215].ResourceName
    UE.UResourceLibrary.LoadObjectAsync(self,IconPath,{self,WBP_Rouge_Settlement_C.OnOuterShopIconLoadFinish})
    -- self.Img_Icon:SetBrushResourceObject(LoadObject(IconPath))
    self.Text_TK:SetText(self.OuterShopTokens)
    self.Text_Token:SetText(GText(Name))
end

function WBP_Rouge_Settlement_C:OnOuterShopIconLoadFinish(Object)
    if Object and IsValid(self) then
        self.Img_Icon_Token:SetBrushResourceObject(Object)
    end
end

-- 初始化Tips（仅在手柄输入显示）
function WBP_Rouge_Settlement_C:InitTipsInfo()
    if self.IsMobile then
        return
    end

    local BottomKeyInfo = {}
    -- 要存在Item才在手柄模式显示"确认"提示
    if self.IsShowTipsConfirm then
        table.insert(BottomKeyInfo, {
            KeyInfoList = {{Type="Img", ImgShortPath="A"}},
            Desc = GText("UI_Tips_Ensure"),
        })
    end
    table.insert(BottomKeyInfo, {
        KeyInfoList = {{Type="Img", ImgShortPath="B"}},
        Desc = GText("UI_Tips_Close"),
    })
    self.Key_Tips:UpdateKeyInfo(BottomKeyInfo)
end

-- 初始化输入设备相关的逻辑
function WBP_Rouge_Settlement_C:InitInputDeviceInfo()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end

    self:AddDispatcher(EventID.OnRougeSettlementBoxItemFocused, self, self.OnRougeSettlementBoxItemFocused)
    self:AddDispatcher(EventID.OnRougeSettlementBoxItemMenuChanged, self, self.OnRougeSettlementBoxItemMenuChanged)

    -- 通常不需要，加个保底
    if not self.GameInputModeSubsystem then
        local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
        self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    end

    -- 放到InAnimation结束后再更新吧
    --self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
end

function WBP_Rouge_Settlement_C:OnRougeSettlementBoxItemMenuChanged(bIsOpen)
    self:SetTipsVisibilityByTag(not bIsOpen, "ItemMenuChange")
end

function WBP_Rouge_Settlement_C:OnRougeSettlementBoxItemFocused(Widget, Suffix)
    local ScrollBox = self["EMScrollBox_"..Suffix]
    if ScrollBox then
        ScrollBox:SetScrollBarVisibility(UE4.ESlateVisibility.Collapsed)
        ScrollBox:ScrollWidgetIntoView(Widget)
    end
end

function WBP_Rouge_Settlement_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end

    if CurInputDevice == ECommonInputType.MouseAndKeyboard then
        self:ShowMouseAndKeyboardView()
    elseif CurInputDevice == ECommonInputType.Gamepad then
        self:ShowGamepadView()
    end

    self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

function WBP_Rouge_Settlement_C:ShowMouseAndKeyboardView()
    -- self.Key_Tips:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self:SetTipsVisibilityByTag(false, "InputDevice")
    self.Text_Tips:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function WBP_Rouge_Settlement_C:ShowGamepadView()
    local Item = self:TryGetFirstValidItem()
    if IsValid(Item) then
        Item:SetFocus()
    else
        self:SetFocus()
    end

    -- self.Key_Tips:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self:SetTipsVisibilityByTag(true, "InputDevice")
    self.Text_Tips:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function WBP_Rouge_Settlement_C:TryGetFirstValidItem()
    local Item = self.WrapBox_Bless:GetChildAt(0)
    if IsValid(Item) then
        return Item
    end
    Item = self.WrapBox_Treasure:GetChildAt(0)
    if IsValid(Item) then
        return Item
    end
    Item = self.WrapBox_Event:GetChildAt(0)
    if IsValid(Item) then
        return Item
    end
    return
end

-- 测试用代码
-- function WBP_Rouge_Settlement_C:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
--     local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
--     local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
--     --DebugPrint("ljlOnAnalogValueChanged", InKeyName, UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent))
--     if (InKeyName == "Gamepad_RightY") then
        
--     end
--     return UE4.UWidgetBlueprintLibrary.UnHandled()
-- end

function WBP_Rouge_Settlement_C:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == Const.GamepadFaceButtonRight then
        self.IsShowTips = false
        self:OnExitButtonClicked()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

-- 播胜利/失败动效
function WBP_Rouge_Settlement_C:PlayInAnimation()
    self:BindToAnimationFinished(self.Finish_Out, {self, function() 
        self:PlayAnimation(self.Settlement_In)
        self.IsInAnimFinished = true
        if self.IsWin then
            AudioManager(self):PlayUISound(self, "event:/ui/roguelike/level_finish_reward_success", nil, nil)
        else
            AudioManager(self):PlayUISound(self, "event:/ui/roguelike/level_finish_reward_fail", nil, nil)
        end
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end})
    if self.IsWin then
        self.Success:SetVisibility(ESlateVisibility.Visible)
        self.Fail:SetVisibility(ESlateVisibility.Collapsed)
        self.Success_Text:SetVisibility(ESlateVisibility.Visible)
        self.Fail_Text:SetVisibility(ESlateVisibility.Collapsed)
        self:BindToAnimationFinished(self.Victory_In, {self, function() self:PlayAnimation(self.Finish_Out) end})
        self:PlayAnimation(self.Victory_In)
        AudioManager(self):PlayUISound(self, "event:/ui/roguelike/level_success_hud_show", "SettlementSuccess", nil)
    else
        self.Success:SetVisibility(ESlateVisibility.Collapsed)
        self.Fail:SetVisibility(ESlateVisibility.Visible)
        self.Success_Text:SetVisibility(ESlateVisibility.Collapsed)
        self.Fail_Text:SetVisibility(ESlateVisibility.Visible)
        self:BindToAnimationFinished(self.Fail_In, {self, function() self:PlayAnimation(self.Finish_Out) end})
        self:PlayAnimation(self.Fail_In)
        AudioManager(self):PlayUISound(self, "event:/ui/roguelike/level_fail_hud_show", "SettlementFail", nil)
    end
end

function WBP_Rouge_Settlement_C:SetTipsVisibilityByTag(IsShow, HideTag)
    if not self.TipsVisibilityTags then
        self.TipsVisibilityTags = {}
    end

    if IsShow then
        self.TipsVisibilityTags[HideTag] = nil
        if _G.next(self.TipsVisibilityTags) == nil then
            self.Key_Tips:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    else
        self.TipsVisibilityTags[HideTag] = true
        self.Key_Tips:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

return WBP_Rouge_Settlement_C
