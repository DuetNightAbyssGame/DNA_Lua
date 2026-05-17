require "UnLua"
local UIUtils = require "Utils.UIUtils"
local AutoChessConst = require "BluePrints.UI.AutoChess.AutoChessConst"
local AutoChessDataModel = require  "BluePrints.UI.AutoChess.AutoChessDataModel"
local View = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.Common.TimerMgr",
})

function View:InitView(ParentWidget)
    self.ParentWidget = ParentWidget
    self.Controller_Equipment:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonTop)
    local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
    if GameInputModeSubsystem then
        GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    end
    self:RefreshOpInfoByInputDevice()
    self.AccessItem.Switch_Type:SetActiveWidgetIndex(2)
    self.AccessItem.Text_Method02:SetText(GText("UI_AutoChess_AccessDes"))
    self.Text_Method:SetText(GText("UI_AutoChess_AccessTitle"))

    local AutoChessCoinData = DataMgr.Resource[AutoChessConst.AutoChessCoin]
    if AutoChessCoinData then
        self.Icon_TotalCost:SetBrushFromTexture(LoadObject("/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/T_Activity_AutoChess_IconCost.T_Activity_AutoChess_IconCost"))
    end
end

function View:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if UIUtils.IsGamepadInput() then
        self:InitGamepadView()
    else
        self:InitKeyboardView()
    end
end

function View:InitGamepadView()
    self.Controller_Equipment:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvinsible)
end

function View:InitKeyboardView()
    self.Controller_Equipment:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function View:RefreshDetails(AutoChessData)
    self.ChessData = AutoChessData
    local CombatChessData = DataMgr.CombatChessInfo[AutoChessData.Id]
    self.Text_Name:SetText(GText(CombatChessData.CombatChessName))
    self.Text_Equipment:SetText(GText("UI_AutoChess_Equip"))
    if CombatChessData.PositionIcon then
        local ImgType = LoadObject(CombatChessData.PositionIcon)
        self.Icon_Type.Icon:SetBrushFromTexture(ImgType)
    end
    self.Text_CostDesc:SetText(GText("UI_AutoChess_MonsterCost"))
    self.Text_Cost:SetText(CombatChessData.DeployCost)
    self.Text_TotalCostDesc:SetText(GText("UI_AutoChess_TotalCost"))
    self.Text_TotalCost:SetText(AutoChessData.TotalCost)
    
    -- 初始化属性
    self.Value_01:InitView(GText("UI_AutoChess_MonsterProp1"), AutoChessData.Atk)
    self.Value_02:InitView(GText("UI_AutoChess_MonsterProp2"), AutoChessData.MaxHp)
    self.Value_03:InitView(GText("UI_AutoChess_MonsterProp3"), AutoChessData.Def)
    self.Value_04:InitView(GText("UI_AutoChess_MonsterProp4"), AutoChessData.MaxEs)

    self.List_Equipment:ClearListItems()
    if AutoChessData.Locked then
        self.WS_Type:SetActiveWidgetIndex(1)
    else
        self.WS_Type:SetActiveWidgetIndex(0)
        local EquipInfos = AutoChessData.EquipItems
        for Index, EquipId in ipairs(EquipInfos) do
            local EquipData = DataMgr.RobotEquip[EquipId]
            if EquipData then
                local Obj = NewObject(UIUtils.GetCommonItemContentClass())
                Obj.EffectText = AutoChessDataModel:CalcEquipExtraDesc(EquipId)
                self.List_Equipment:AddItem(Obj)
            end
        end
        self:UpdateEquipInfo(EquipInfos)
    end
end

function View:UpdateEquipInfo(EquipItems)
    local _UpdateSingleEquipInfo = function(EquipId, EquipIndex)
        local Widget = self:GetEquipWidgetByIndex(EquipIndex)
        if Widget then
            local AutoChessEquipData = DataMgr.RobotEquip[EquipId]
            if AutoChessEquipData then
                local Content = {}
                Content.Id = EquipId
                Content.Rarity = AutoChessEquipData.EquipRarity
                Content.ItemType = "RobotEquip"
                Content.Icon = AutoChessEquipData.EquipIcon
                Content.CurrencyIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/T_Activity_AutoChess_IconCost.T_Activity_AutoChess_IconCost'"
                Content.CurrencyNum = AutoChessEquipData.DeployCost
                Content.OnMouseButtonDownEvent = {Obj = self, Callback = function()
                    AudioManager(self):PlayUISound(self, "event:/ui/common/combat_bag_cell_place_common", nil, nil)
                    UIManager(self):LoadUINew("AutoChessChooseEquip", self.ChessData, ParentWidget)
                    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
                        CommonUtils:CloseGuideTouchIfExist(self)
                    end 
                end}
                Widget:Init(Content)
            end
        end
    end

    for Index, Equip in ipairs(EquipItems) do
        _UpdateSingleEquipInfo(Equip, Index)
    end

    for i = #EquipItems + 1, 2 do
        local Widget = self:GetEquipWidgetByIndex(i)
        if Widget then
            local Content = {bAdd = true,
            OnMouseButtonDownEvent = {Obj = self, Callback = function()
                AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
                UIManager(self):LoadUINew("AutoChessChooseEquip", self.ChessData, self)
                if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
                    CommonUtils:CloseGuideTouchIfExist(self)
                end 
            end}}
            Widget:Init(Content)
        end
    end
end

function View:GetEquipWidgetByIndex(EquipIndex)
    if EquipIndex == 1 then
        return self.Equipment_01
    elseif EquipIndex == 2 then
        return self.Equipment_02
    end
    return nil
end


return View
