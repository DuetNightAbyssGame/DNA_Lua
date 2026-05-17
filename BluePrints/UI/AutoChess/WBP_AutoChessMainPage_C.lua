require "UnLua"
local UIUtils = require "Utils.UIUtils"
local TimeUtils = require "Utils.TimeUtils"
local AutoChessConst = require "BluePrints.UI.AutoChess.AutoChessConst"
local Model = require  "BluePrints.UI.AutoChess.AutoChessDataModel"
local View = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
    "Blueprints.UI.AutoChess.AutoChessPageInterface",
    "BluePrints.Common.TimerMgr",
})

function View:InitView()
    self.LevelSelect:InitView()
    self.Rank:UpdateRankInfo(Model:GetRankInfo())

    self.Title.Text_Title:SetText(GText("Event_Title_103016"))
    self.Btn_Monster.Text_Name:SetText(GText("UI_AutoChess_MonsterOverview"))
    self.Btn_Equipment.Text_Name:SetText(GText("UI_AutoChess_WeaponOverview"))
    self.Entrance_Shop:SetText(GText("UI_AutoChess_ShopName"))
    self.Entrance_Task:SetText(GText("UI_AutoChess_QuestName"))

    self.Title:PlayAnimation(self.Title.In)

    local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
    if GameInputModeSubsystem then
        GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    end
    self:RefreshOpInfoByInputDevice()

    -- 初始化手柄图标相关
    self.Entrance_Shop.Key_Controller:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonLeft)
    self.Entrance_Task.Key_Controller:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonTop)
    self.Btn_Monster.Key_Controller:CreateGamepadKey(UIConst.GamePadImgKey.DPadUp)
    self.Btn_Equipment.Key_Controller:CreateGamepadKey(UIConst.GamePadImgKey.DPadDown)

    -- 红点相关
    ReddotManager.AddListenerEx("AutoChessMonster", self, self.OnMonsterReddotChanged)
    ReddotManager.AddListenerEx("AutoChessEquip", self, self.OnEquipReddotChanged)
    self.Entrance_Task:InitReddot("AutoChessReward")
end

function View:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if UIUtils.IsGamepadInput() then
        self:InitGamepadView()
    else
        self:InitKeyboardView()
    end
end

function View:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = false
    if UIUtils.IsGamepadInput() then
        IsHandled = self:Handle_PreviewKeyDownOnGamePad(InKeyName)
    else
        -- IsHandled = self:Handle_PreviewKeyDownOnKeyboard(InKeyName)
    end 

    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function View:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = false
    if UIUtils.IsGamepadInput() then
        IsHandled = self:Handle_KeyDownOnGamePad(InKeyName)
    else
        IsHandled = self:Handle_KeyDownOnKeyboard(InKeyName)
    end

    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function View:Handle_KeyDownOnKeyboard(InKeyName)
    local IsHandled = false
    return IsHandled
end

function View:Handle_PreviewKeyDownOnGamePad(InKeyName)
    local IsHandled = false
    if InKeyName == Const.GamepadDPadUp then
        if self.BindedCallbacks and self.BindedCallbacks.OnBtnMonsterClicked then
            self.BindedCallbacks.OnBtnMonsterClicked()
            IsHandled = true
        end
    elseif InKeyName == Const.GamepadDPadDown then
        if self.BindedCallbacks and self.BindedCallbacks.OnBtnEquipmentClicked then
            self.BindedCallbacks.OnBtnEquipmentClicked()
            IsHandled = true
        end
    end

    return IsHandled
end

function View:Handle_KeyDownOnGamePad(InKeyName)
    local IsHandled = false
    if InKeyName == Const.GamepadFaceButtonLeft then
        if self.BindedCallbacks and self.BindedCallbacks.OnBtnOpenShopClicked then
            self.BindedCallbacks.OnBtnOpenShopClicked()
            IsHandled = true
        end
    elseif InKeyName == Const.GamepadFaceButtonUp then
        if self.BindedCallbacks and self.BindedCallbacks.OnBtnOpenQuestClicked then
            self.BindedCallbacks.OnBtnOpenQuestClicked()
            IsHandled = true
        end
    elseif InKeyName == Const.GamepadLeftShoulder then
        if self.BindedCallbacks and self.BindedCallbacks.OnBtnLinearLevelClicked then
            self.BindedCallbacks.OnBtnLinearLevelClicked()
            IsHandled = true
        end
    elseif InKeyName == Const.GamepadRightShoulder then
        if self.BindedCallbacks and self.BindedCallbacks.OnBtnRandomLevelClicked then
            self.BindedCallbacks.OnBtnRandomLevelClicked()
            IsHandled = true
        end
    end

    return IsHandled
end

function View:GetDefaultControllerFSMState()
    return AutoChessConst.FSMStates.MainPage
end

function View:InitGamepadView()
    self.Entrance_Shop.Key_Controller:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvinsible)
    self.Entrance_Task.Key_Controller:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvinsible)
    self.Btn_Monster.Key_Controller:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvinsible)
    self.Btn_Equipment.Key_Controller:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvinsible)
end

function View:InitKeyboardView()
    self.Entrance_Shop.Key_Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Entrance_Task.Key_Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Btn_Monster.Key_Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Btn_Equipment.Key_Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
end


function View:InitEventTimeInfos(EventTimeInfo, RequestUpdateCallback)
    self.LevelSelect:InitEventTimeInfos(EventTimeInfo, RequestUpdateCallback)
end

function View:BindEvents(Callbacks)
    self.BindedCallbacks = Callbacks
    self.LevelSelect:BindEvents(Callbacks.OnBtnLinearLevelClicked, Callbacks.OnBtnRandomLevelClicked)
    self.Btn_Monster.Btn_Click.OnClicked:Add(self, Callbacks.OnBtnMonsterClicked)
    self.Btn_Equipment.Btn_Click.OnClicked:Add(self, Callbacks.OnBtnEquipmentClicked)
    self.Entrance_Shop.Btn_Click.OnClicked:Add(self, Callbacks.OnBtnOpenShopClicked)
    self.Entrance_Task.Btn_Click.OnClicked:Add(self, Callbacks.OnBtnOpenQuestClicked)
end

function View:OnMonsterReddotChanged(Count,RdType,RdName)
    DebugPrint("Tianyi@ OnMonsterReddotChanged, Count: "..tostring(Count)..", RdType: "..tostring(RdType)..", RdName: "..tostring(RdName))
    if Count > 0 then
        self.Btn_Monster.New:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvinsible)
    else
        self.Btn_Monster.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function View:OnEquipReddotChanged(Count,RdType,RdName)
    DebugPrint("Tianyi@ OnEquipReddotChanged, Count: "..tostring(Count)..", RdType: "..tostring(RdType)..", RdName: "..tostring(RdName))
    if Count > 0 then
        self.Btn_Equipment.New:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvinsible)
    else
        self.Btn_Equipment.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function View:EMDestruct()
    ReddotManager.RemoveListener("AutoChessMonster", self)
    ReddotManager.RemoveListener("AutoChessEquip", self)
    self.Super.EMDestruct(self)
end

return View