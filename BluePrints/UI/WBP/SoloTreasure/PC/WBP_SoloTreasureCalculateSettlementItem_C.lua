--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_SoloTreasure_SettlementItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:OnListItemObjectSet(Content)
    self.Content = Content
    if self.Content.IsEmpty then
        --自己控件
        self.Content.SelfWidget = self
        self:PlayAnimation(self.Empty)
        return
    end
    self:LoadItem(Content)
end

function M:LoadItem(Content)
    self.Content = Content
    --索引
    self.ItemIndex = Content.ItemIndex
    --图标地址
    self.IconPath = Content.Icon
    --稀有度
    self.Rarity = Content.Rarity
    --价值
    self.Value = Content.Value
    --真正价值
    self.RealValue = Content.Value
    --物资类型
    self.TreasureType = Content.TreasureType
    --能得到的buff稀有度
    self.BuffRarity = Content.BuffRarity
    --buff数值
    self.BuffRate = Content.BuffRate
    --buff类型
    self.BuffType = Content.BuffType
    --buff作用对象参数1
    self.BuffParam1 = Content.BuffParam1
    --buff作用对象参数2
    self.BuffParam2 = Content.BuffParam2
    --父页面
    self.Owner = Content.Owner

    self.RarityToAnimation = {
        self.White_In,
        self.Green_In,
        self.Blue_In,
        self.Purple_In,
        self.Gold_In,
        self.Red_In,
    }
    --计算物品的真正价值
    self:CalItemRealValue()
    --初始化UI
    self:InitUI()
end

--外部调用播放In动效和联动的彩票倍数动效
function M:PlayAnimationByRarity()
    if self.RarityToAnimation[self:GetShowRarity()] then
        self:PlayAnimation(self.RarityToAnimation[self:GetShowRarity()])
    end
    if self:CheckBuffCondition() then
        self.BuffLable:SetVisibility(ESlateVisibility.Visible)
        self.BuffLable:SetLableType(self.BuffRarity - 1)
        self.BuffLable:PlayAnimation(self.BuffLable.In)
        self.Owner.WBP_Buff02:PlayAnimation(self.Owner.WBP_Buff02.Buff_Add)
    end
end

--获取要显示的稀有度颜色
function M:GetShowRarity()
    local TreasureRarityInfo = DataMgr.ExtractionTreasureRarity
    if TreasureRarityInfo then
        return TreasureRarityInfo[self.Rarity].ShowRarity
    end
    return 2
end

--外部调用获取真正价值
function M:GetItemRealValue()
    return self.RealValue
end

--计算物品的真正价值
function M:CalItemRealValue()
    if self:CheckBuffCondition() then
        self.RealValue = self.Value * self.BuffRate
    end
end

--检测彩票能否适用于该物品
function M:CheckBuffCondition()
    if not self.BuffType then
        return false
    end
    if self.BuffType == 1 then
        return self.Rarity == self.BuffParam1
    elseif self.BuffType == 2 then
        return self.TreasureType == self.BuffParam1
    else
        return false
    end
end

function M:InitUI()
    --图标初始化
    self:UpdateIcon()
    --更新背景品质色
    self:UpdateBg()
    --价值初始化
    self:UpdateValue()
    --是否播放动画
    self:CheckPlayInAnimation()
end

--是否播放动画
function M:CheckPlayInAnimation()
    if not self.Owner then
        return
    end
    if self.Owner.CurIndex == self.ItemIndex then
        self:PlayAnimationByRarity()
        self.Owner.CurWidget = self
    else
        self:PlayAnimation(self.Normal)
    end
end

--图标初始化
function M:UpdateIcon()
    local Material = self.WBP_Item.Item_BG:GetDynamicMaterial()
    if Material and self.IconPath then
        Material:SetTextureParameterValue("IconMap",LoadObject(self.IconPath))
    end
end

--价值初始化
function M:UpdateValue()
    local NumText = string.format("%s", Utils.FormatNumber(self.Value, false))
    self.Text_Num:SetText(NumText)
end

--更新背景品质色
function M:UpdateBg()
    local Material = self.WBP_Item.Item_BGPanel:GetDynamicMaterial()
    if Material then
        Material:SetScalarParameterValue("Index", self:GetShowRarity())
    end
end

return M
