--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR zhangdongxu
-- @DATE ${date} ${time}
--
require "UnLua"

local RougeConst = require "BluePrints.UI.UI_PC.RougeLike.RougeAchive.RougeConst"
---@class WBP_Rouge_CheckDetail_Item_P_C:WBP_Rouge_Item_Info_Base_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
    self.IsSelected = false
    self.Button_Item.OnHovered:Add(self, self.OnBtnHovered)
    self.Button_Item.OnUnhovered:Add(self, self.OnBtnUnhovered)
    self.Button_Item.OnPressed:Add(self, self.OnBtnPressed)
    self.Button_Item.OnReleased:Add(self, self.OnBtnReleased)
    self.Button_Item.OnClicked:Add(self, self.OnBtnClicked)
    self.Text_CanUpgrade:SetText(GText("UI_RougeLike_Blessing_Upgraded"))
end

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.RougeDataModel = Content.DataModel
    self.ShopId = Content.ShopId
    self.ItemId = Content.ItemId
    if not self.ItemId or self.ItemId == 0 then
        self:InitEmptyItem(true)
        return
    else
        self:InitEmptyItem(false)
    end
    self.RougeGuideName = Content.RougeGuideName
    self.ItemType = Content.ShopItemType
    self.Level = 0
    self.Parent = Content.Parent
    self.RougeItemFocusChanged= Content.RougeItemFocusChanged
    self.Index = Content.Index
    local ItemData = DataMgr["RougeLike"..self.ItemType][self.ItemId]
    local Name = ItemData.Name
    self.Text_Name:SetText(GText(Name))
    local IconPath = ItemData.Icon
    self.Rarity = ItemData[self.ItemType.."Rarity"]
    self:SetIcon(IconPath)
    self:SetRarity(self.Rarity)
    self:SetDesc()
    local BuffIconPath = ItemData.TypeIcon
    if self.ItemType == "Blessing" then
        self.Group_Buff:SetVisibility(ESlateVisibility.Visible)
        self:SetBuffType(BuffIconPath)
    else
        self.Group_Buff:SetVisibility(ESlateVisibility.Collapsed)
    end

    self.New:SetVisibility(ESlateVisibility.Collapsed)
    if self.RougeGuideName then
        local ArchiveId = ItemData.RLArchiveId
        self.Text_Index:SetText(string.format(GText("RLArchive_ID"), string.format("%03d", ArchiveId)))
        self.Text_Index:SetVisibility(ESlateVisibility.SelfHitTestInvisible)

        local RougeItemData = self.RougeDataModel:GetArchiveDataByArchiveType(RougeConst.ArchiveType[self.RougeGuideName])
        self.IsUnlocked = RougeItemData.Data[self.ItemId].IsUnlocked
        if self.IsUnlocked then
            self:InitNewTag()
            self.Group_Lock:SetVisibility(ESlateVisibility.Collapsed)
        else
            self.Group_Lock:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Text_Name:SetText(GText("RLArchive_UnlockEntry"))
            self.Text_Desc:SetText(GText(ItemData.UnlockConditionText))
        end
    end
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
end

function M:InitEmptyItem(bEmpty)
    if bEmpty then
        self.Group_Normal:SetVisibility(ESlateVisibility.Collapsed)
        self.Group_Empty:SetVisibility(ESlateVisibility.Visible)
    else
        self.Group_Normal:SetVisibility(ESlateVisibility.Visible)
        self.Group_Empty:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:SetIcon(IconPath)
    if not IconPath then
        return
    end
    if self.ItemType == "Blessing" then
        self.WS_Item:SetActiveWidgetIndex(0)
        if self.Rarity == 1 then
            self.WBP_Rouge_BlessIcon:PlayAnimation(self.WBP_Rouge_BlessIcon.Blue)
        elseif self.Rarity == 2 then
            self.WBP_Rouge_BlessIcon:PlayAnimation(self.WBP_Rouge_BlessIcon.Purple)
        elseif self.Rarity == 3 then
            self.WBP_Rouge_BlessIcon:PlayAnimation(self.WBP_Rouge_BlessIcon.Yellow)
        end
        local IconDynaMaterial = self.WBP_Rouge_BlessIcon.Image_Icon:GetDynamicMaterial()
        if(IsValid(IconDynaMaterial))then
            IconDynaMaterial:SetTextureParameterValue("MainTex",LoadObject(IconPath))
        end
    elseif self.ItemType == "Treasure" then
        self.WS_Item:SetActiveWidgetIndex(1)
        self.Image_TreasureIcon:SetBrushResourceObject(LoadObject(IconPath))
    end
end

function M:SetBuffType(IconPath)
    if not IconPath then
        return
    end
    self.Group_Buff:SetVisibility(ESlateVisibility.Visible)
    self.Image_BuffType:SetBrushResourceObject(LoadObject(IconPath))
end

function M:SetRarity(Rarity)
    local Quality, QualityLine
    if Rarity > 0 and Rarity <= 3 then
        Quality = self["Img_Quality_"..Rarity]
        QualityLine = self["Img_QualityLine_"..Rarity]
     elseif Rarity > 3 then
        Quality = self.Img_Quality_4
        QualityLine = self.Img_QualityLine_4
    end
    self.Img_Quality:SetBrushResourceObject(Quality)
    self.Img_QualityLine:SetBrushResourceObject(QualityLine)
end

function M:InitNewTag()
    if self.RougeDataModel:CheckArchiveItemIsNew(RougeConst.ArchiveType[self.RougeGuideName], self.ItemId) then
        self.New:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.New:SetVisibility(ESlateVisibility.Collapsed)
    end
end
function M:SetItemWatched()
    self.RougeDataModel:MarkArchiveItemSeened(RougeConst.ArchiveType[self.RougeGuideName], self.ItemId)
    self.RougeDataModel:UpdateArchiveReddot(RougeConst.ArchiveType[self.RougeGuideName])
    self:InitNewTag()
end

function M:SetDesc()
    local Desc
    if self.ItemType == "Blessing" then
        local RougeLikeManager = GWorld.RougeLikeManager
        if RougeLikeManager then
            self.Level = math.max(RougeLikeManager:GetBlessingLevel(self.ItemId) - 1, 0)
        end

        -- 是否已升级
        if self.Level ~= 0 then
            self.Group_CanUpgrade:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        else
            self.Group_CanUpgrade:SetVisibility(ESlateVisibility.Collapsed)
        end

        -- 祝福描述
        Desc = UIUtils.GenRougeBlessingDesc(self.ItemId,self.Level)
        local GroupId = DataMgr.RougeLikeBlessing[self.ItemId].BlessingGroup
        assert(GroupId, "未找到祝福对应套装Id："..self.ItemId)
        local GroupData = DataMgr.BlessingGroup[GroupId]
        assert(GroupData, "未找到套装数据："..GroupId)
        self.Text_SuitName:SetVisibility(ESlateVisibility.SelfHitTestInvisible)

        -- 套装名
        self.Text_SuitName:SetText(GText(GroupData.Name))
    elseif self.ItemType == "Treasure" then
        self.Text_SuitName:SetVisibility(ESlateVisibility.Collapsed)
        Desc = UIUtils.GenRougeTreasureDesc(self.ItemId)
    end
    local ItemData = DataMgr["RougeLike"..self.ItemType]
    local ExplanationList = ItemData[self.ItemId].ExplanationId or {}
    local TermsList = {}
    for _, ExplanationId in ipairs(ExplanationList) do
        local ExplanationInfo = DataMgr.CombatTerm[ExplanationId]
        local CombatTermId = ExplanationInfo.CombatTermId
        table.insert(TermsList, CombatTermId)
    end
    Desc = UIUtils.GenRougeCombatTermDesc(Desc, TermsList)
    self.Text_Desc:SetText(GText(Desc))
end

function M:OnBtnHovered()
    if self:IsAnimationPlaying(self.In) then
        return
    end
    if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Touch then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
end

function M:OnBtnUnhovered()
    if self:IsAnimationPlaying(self.In) then
        return
    end
    if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Touch then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
end

function M:OnBtnPressed()
    if self:IsAnimationPlaying(self.In) then
        return
    end
    -- self.StartPressTime = os.clock()
    self:PlayAnimation(self.Press)
end

function M:OnBtnReleased()
    if self:IsAnimationPlaying(self.In) then
        return
    end
    -- if self.StartPressTime then
    --     self.PressedTime = os.clock() - self.StartPressTime or os.clock()
    -- else
    --     self.PressedTime = 0
    -- end
    -- if self.PressedTime > 0.2 then
    --     self.IsLongPress = true
    -- end
    self:StopAnimation(self.Press)
    self:PlayAnimation(self.Normal)
end

function M:OnBtnClicked()
    if self:IsAnimationPlaying(self.In) then
        return
    end
    -- if not self.IsLongPress then
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
    self:PlayAnimation(self.Click)
    self:ShowItemDetail()
    if self.RougeGuideName then
        self:SetItemWatched()
    end
    -- end
    -- self.IsLongPress = false
end

function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.UnHover then
        self:PlayAnimation(self.Normal)
    end
    if InAnimation == self.In then
        self:PlayAnimation(self.Normal)
    end
    if InAnimation == self.Click then
        self:PlayAnimation(self.Normal)
    end
end

function M:ShowItemDetail()
    if self.RougeGuideName then
        if self.IsUnlocked then
            UIManager(self):LoadUINew("RougeItemDetailPopUp", self.ItemId, self.ItemType, self.Level, true, self.IsUnlocked)
        else
            UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("RLArchive_"..self.RougeGuideName.."UnlockToast"))
        end
    else
        -- UIManager(self):LoadUINew("RougeBagItemPopUp", self.ItemId, self.ItemType, self.Level)
        UIManager(self):LoadUINew("RougeItemDetailPopUp", self.ItemId, self.ItemType, self.Level, false, true)
    end
end

function M:OnAddedToFocusPath(InFocusEvent)
    self.Content.Focused= true
    if self.RougeItemFocusChanged then
        self.RougeItemFocusChanged(self.Parent, true)
    end
    if self.Parent.Owner then
        self.Parent.Owner.CatalogueScroll:ScrollWidgetIntoView(self, true, UE4.EDescendantScrollDestination.IntoView)
    end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
    self.Content.Focused= false
    if self.RougeItemFocusChanged then
        self.RougeItemFocusChanged(self.Parent, false)
    end
end

function M:OnDetailNavigateUp()
    if self.Index > 0 then
        return self.Parent.List_Box:GetChildAt(self.Index - 1)
    else
        self.Parent.Owner.CatalogueScroll:ScrollWidgetIntoView(self.Parent.Title_Button, true, UE4.EDescendantScrollDestination.IntoView)
        return self.Parent.Title_Button
    end
end

function M:OnDetailNavigateDown()
    if self.Index < self.Parent.List_Box:GetChildrenCount() - 1 then
        return self.Parent.List_Box:GetChildAt(self.Index + 1)
    else
        return self.Parent:GetNextListSuitItem()
    end
end

return M
