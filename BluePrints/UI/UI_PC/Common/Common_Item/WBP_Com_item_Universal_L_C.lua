--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_item_Universal_L_C
local M = Class({"BluePrints.UI.UI_PC.Common.Common_Item.WBP_Com_Item_Base_C"})
M._components = {
    "BluePrints.UI.UI_PC.Common.Common_Item.Comp.WBP_Com_Item_TimeTag_Comp",
    "BluePrints.UI.UI_PC.Common.Common_Item.Comp.WBP_Com_Item_CustomTag_Comp",
    "BluePrints.Ui.UI_PC.Common.Common_Item.Comp.WBP_Com_Item_NewGlow_Comp",
}

function M:InitData(Content)
    M.Super.InitData(self, Content)
    self.bConflict = Content.bConflict
    self.bMinus = Content.bMinus
    
    self.CurrencyId = Content.CurrencyId
    self.CurrencyNum = Content.CurrencyNum
    self.CurrencyIcon = Content.CurrencyIcon

    self.Polarity = Content.Polarity
    self.PolarityNum = Content.PolarityNum

    self.bSelectTag = Content.bSelectTag

    self.bSet = Content.bSet
    self.SetOwnText = Content.SetOwnText

    self.bUnrevealed = Content.bUnrevealed
    self.LevelCardNum = Content.LevelCardNum
    self.StartLevelNum = Content.StartLevelNum
    -- 整备界面所需属性
    self.AttrIcon = Content.AttrIcon                        -- 属性图标
    self.IsPhantom = Content.IsPhantom                      -- 是否为魅影
    self.bAura = Content.bAura                              -- 光环Mod标记
    -- 大秘境队伍标识
    self.TeamIdx = Content.TeamIdx
    self.TeamCharId = Content.TeamCharId

    --预设阵容列表标识
    self.NavigationRule = Content.NavigationRule

    --Mod
    self.ModLevel = Content.Level
    self.ProductType = Content.ProductType

    self.bNewGlow = Content.bNewGlow
end

function M:InitCommonView()
    if self.bDontRemoveSubWidget then
        for _, Widget in pairs(self.Node_Widget:GetAllChildren()) do
            Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    else
        self.Node_Widget:ClearChildren()
        self.WidgetMap = {}
    end
    M.Super.InitCommonView(self)
end

function M:InitCompView()
    M.Super.InitCompView(self)

    --- 层级0
    self:SetCount(self.Count, self.NeedCount, self.MaxCount, self.NotCountFormat, self.bShowNotHaveStyle)
    self:SetBonus(self.BonusType, self.ExtraBonusText)
    if self.ProductType == CommonConst.ArmoryType.Mod then
        if self.ModLevel and self.ModLevel > 0 then
            self:SetItemStartLevel(self.ModLevel)
        end
    else
        self:SetName(self.ItemName)
        self:SetLevel(self.Level)
        self:SetItemStartLevel(self.StartLevelNum)
    end
    
    self:SetIsCanGet(self.bCanGet, self.CanGetStyle)
    self:SetAttrIcon(self.AttrIcon)
    self:SetOutline(self.bOutline)
    if self.Content.Type == CommonConst.ArmoryType.Pet then
        self:SetPetStarLevel(self.Content.BreakNum)
        self:SetPetPremium(self.Content.IsPremium)
        if(self.Content.PetEntry and #self.Content.PetEntry > 0)then
            self:SetLevel(nil)
            self:SetPetEntryId(self.Content.PetEntry)
        end
    elseif self.Content.Type == nil and self.Content.bEmpty then
        self:SetPetPremium(false)
        self:SetPetEntryId()
    else
        self:SetPetPremium(false)
    end
    if self.ItemType == "Weapon" then
        self:SetWeaponPhantomIcon(self.Uuid)
    end
    self:SetItemPolarity(self.Polarity, self.PolarityNum)
    self:SetItemLevelCard(self.LevelCardNum)
    
    self:SetItemMoney(self.CurrencyId, self.CurrencyNum, false, self.CurrencyIcon)
    self:SetItemSold(self.bSold)
    self:SetAura(self.bAura)
    --- 层级1
    self:SetItemConflict(self.bConflict)
    self:SetIsGot(self.bHasGot)
    self:SetLock(self.LockType)
    self:SetItemMinus(self.bMinus)
    self:SetItemSelect(self.bSelectTag)
    self:SetSelectNum(self.SelectNeedCount, self.SelectTotalCount)
    self:SetItemSet(self.bSet, self.SetOwnText)
    self:SetShadow(self.bShadow)
    self:SetPhantomWeaponIcon(self.Id, self.IsPhantom)
    self:SetItemUnrevealed(self.bUnrevealed)
    self:SetRareTag(self.bRare)
    self:SetTryOutText(self.TryOutText)
    self:SetSquadBuildTryOutText(self.SquadBuildTryOutText)
    self:SetTimeLimitData(self.TimeLimitData)
    --- 层级2
    
    self:SetTeamIcon(self.TeamIdx, self.TeamCharId)
    self:SetInGear(self.bInGear)

    self:SetTimeTag(self.Content.TimeTagList)
    self:SetCustomTag(self.Content.bAllowCustom)
    self:SetWeaponMiniPhantomIcon(self.WeaponMiniPhantomIconCharId)
    self:SetNewGlow(self.bNewGlow)
    self:SetRedDot(self.RedDotType)
end
AssembleComponents(M)
return M
