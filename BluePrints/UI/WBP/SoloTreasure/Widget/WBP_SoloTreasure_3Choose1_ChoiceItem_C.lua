--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_SoloTreasure_ChoiceItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.Common.DelayFrameComponent"})

function M:Construct()
    self.Btn_Area.OnClicked:Add(self, self.OnBtnClicked)
    self.Btn_Area.OnPressed:Add(self, self.OnBtnPressed)
    self.Btn_Area.OnHovered:Add(self, self.OnBtnHovered)
    self.Btn_Area.OnUnhovered:Add(self, self.OnBtnUnhovered)
    self.IsSelected = false
    self.Img_Select:SetRenderOpacity(0)
end

function M:InitInfo(ChoiceInfo)
    self.Parent = ChoiceInfo.Parent
    self:PlayAnimation(self.Normal)
    self.LotteryId = ChoiceInfo.LotteryId
    local LotteryData = DataMgr.ExtractionLottery[self.LotteryId]
    if not LotteryData then
        DebugPrint("@zyh 没有该Id的彩票" .. self.LotteryId)
    end
    DebugPrint("彩票的品质为".. LotteryData.Quality)
    self:SetChoiceQuality(LotteryData.Quality - 1)
    self:SetLabelType(LotteryData.Quality - 1)
    self.Choice_Buff:SetBuffQuality(LotteryData.Quality - 1)
    self.Text_Buff:SetText(GText(LotteryData.Desc))
    self.Text_Hold:SetText(GText("UI_Extraction_TM_22"))
    if ChoiceInfo.Owned then
        self.Panel_Hold:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:OnBtnClicked()
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self.Parent:OnConfirmBtnClicked()
        return
    end
    if self.IsSelected then
        self:UnSelect()
        self.Parent:SelectItem()
    else
        self.IsSelected = true
        self:StopAnimation(self.Select_Out)
        self:PlayAnimation(self.Click)
        self:PlayAnimation(self.Select_In)
        self.Parent:SelectItem(self)
    end
    
end

function M:UnSelect()
    self.IsSelected = false
    self:StopAnimation(self.Select_In)
    self:PlayAnimation(self.Select_Out)
end

function M:OnBtnPressed()
    if self.IsSelected then
        return
    end
    self:PlayAnimation(self.Press)
end

function M:OnBtnHovered()
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self:AddDelayFrameFunc(function()
            self.IsSelected = true
            self:StopAnimation(self.Select_Out)
            self:PlayAnimation(self.Click)
            self:PlayAnimation(self.Select_In)
            self.Parent:SelectItem(self)
        end, 1)
        return
    end
    if self.IsSelected then
        return
    end
    self:PlayAnimation(self.Hover)
    
end

function M:OnBtnUnhovered()
    if self.IsSelected then
        return
    end
    self:PlayAnimation(self.UnHover)
    
end

return M
