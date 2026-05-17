require "UnLua"
local UIUtils = require "Utils.UIUtils"
local AutoChessDataModel = require  "BluePrints.UI.AutoChess.AutoChessDataModel"
 
local View = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.Common.TimerMgr",
})

function View:InitView()
    local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
    if GameInputModeSubsystem then
        GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    end
    self:RefreshOpInfoByInputDevice()
    self.AccessItem.Switch_Type:SetActiveWidgetIndex(2)
    self.AccessItem.Text_Method02:SetText(GText("UI_AutoChess_AccessDes"))
end

function View:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if UIUtils.IsGamepadInput() then
        self:InitGamepadView()
    else
        self:InitKeyboardView()
    end
end

function View:InitGamepadView()
end

function View:InitKeyboardView()
end

function View:RefreshDetails(EquipData)
    local AutoChessEquipData = DataMgr.RobotEquip[EquipData.Id]
    self.Text_Name:SetText(GText(AutoChessEquipData.EquipName))
    self.Text_Hold01:SetText(GText("UI_AutoChess_Holdings"))
    self.Text_Method:SetText(GText("UI_AutoChess_AccessTitle"))
    self.Text_CostDesc:SetText(GText("UI_AutoChess_WeaponCost"))
    self.Text_Cost:SetText(AutoChessEquipData.DeployCost)
    self:SetNameRarity(AutoChessEquipData.EquipRarity)

    local Content = {}
    Content.Id = EquipData.Id
    Content.Rarity = AutoChessEquipData.EquipRarity
    Content.ItemType = "RobotEquip"
    Content.Icon = AutoChessEquipData.EquipIcon
    Content.CurrencyIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/T_Activity_AutoChess_IconCost.T_Activity_AutoChess_IconCost'"
    Content.CurrencyNum = AutoChessEquipData.DeployCost
    self.Item:Init(Content)
    
    -- 初始化属性
    self.Value_01:InitView(GText("UI_AutoChess_MonsterProp1"), EquipData.Atk)
    self.Value_02:InitView(GText("UI_AutoChess_MonsterProp2"), EquipData.Hp)
    self.Value_03:InitView(GText("UI_AutoChess_MonsterProp3"), EquipData.Def)
    self.Value_04:InitView(GText("UI_AutoChess_MonsterProp4"), EquipData.Es)

    if EquipData.Locked then
        self.Text_Hold02:SetText(0)
        self.WS_Type:SetActiveWidgetIndex(1)
    else
        self.Text_Hold02:SetText(1)
        self.WS_Type:SetActiveWidgetIndex(0)
    end

    -- 装备被动描述
    self.List_Equipment:ClearListItems()
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.EffectText = AutoChessDataModel:CalcEquipExtraDesc(EquipData.Id)
    self.List_Equipment:AddItem(Obj)
end

function View:SetNameRarity(Rarity)
    local FontMaterial = self.Text_Name:GetDynamicFontMaterial()
    if Rarity == 6 then
        FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_6)
    elseif Rarity == 5 then
        FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_5)
    elseif Rarity == 4 then
        FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_4)
    elseif Rarity == 3 then
        FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_3)
    elseif Rarity == 2 then
        FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_2)
    elseif Rarity == 1 then
        FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_1)
    else
        FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_0)
    end
end

return View

