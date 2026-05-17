require "UnLua"
local WBP_AutoChess_MonsterEquipTips = Class("BluePrints.UI.BP_EMUserWidget_C")
local Model = require "BluePrints.UI.AutoChess.AutoChessDataModel"

local RarityToSuffix = {
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [4] = 4,
    [5] = 5,
}

function WBP_AutoChess_MonsterEquipTips:Show(EquipInfo)
    if not EquipInfo then
        DebugPrint("--------------------EquipInfo---------------------")
        return
    end
    self.CurEquipId = EquipInfo.EquipId
    self:ShowEquipInfo(EquipInfo)
    self:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
end

function WBP_AutoChess_MonsterEquipTips:Hide()
    DebugPrint("[EquipTips] Hide")
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function WBP_AutoChess_MonsterEquipTips:ShowEquipInfo(EquipInfo)
    if not EquipInfo then
        return
    end

    -- 名称
    if self.Text_ItemName then
        self.Text_ItemName:SetText(GText(EquipInfo.EquipName))
    end

    -- 部署费用
    if self.Text_Cost then
        self.Text_Cost:SetText(GText(tostring(EquipInfo.DeployCost)))
    end

    -- 部署花费描述
    if self.Text_CostDesc then
        self.Text_CostDesc:SetText(GText("UI_AutoChess_WeaponCost"))
    end

    local EquipAttrInfo = Model:GetEquipInfoByEquipId(EquipInfo.EquipId)

    if self.Value_01 then
        self.Value_01:InitView(GText("UI_AutoChess_MonsterProp1"), EquipAttrInfo.Atk)
    end

    if self.Value_02 then
        self.Value_02:InitView(GText("UI_AutoChess_MonsterProp2"), EquipAttrInfo.Hp)
    end

    if self.Value_03 then
        self.Value_03:InitView(GText("UI_AutoChess_MonsterProp3"), EquipAttrInfo.Def)
    end

    if self.Value_04 then
        self.Value_04:InitView(GText("UI_AutoChess_MonsterProp4"), EquipAttrInfo.Es)
    end

    if self.OutLine_Quality then
        local Rarity = EquipAttrInfo.Rarity
        local Suffix = RarityToSuffix[Rarity]

        if not Suffix then
            DebugPrint("未找到稀有度对应图片：", Rarity)
            return
        end

        local texturePath =
            string.format(
            "Texture2D'/Game/UI/Texture/Static/Image/Common/Tips/T_Com_TipsLineColor_%d.T_Com_TipsLineColor_%d'",
            Suffix,
            Suffix
        )

        local ImgObj = LoadObject(texturePath)
        self.OutLine_Quality:SetBrushFromTexture(ImgObj)
    end

    -- 装备被动描述
    self.List_Equipment:ClearListItems()
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())

    Obj.EffectText = Model:CalcEquipExtraDesc(EquipInfo.EquipId)

    self.List_Equipment:AddItem(Obj)
end

return WBP_AutoChess_MonsterEquipTips
