require "UnLua"
local UIUtils = require "Utils.UIUtils"
local Model = require  "BluePrints.UI.AutoChess.AutoChessDataModel"
local View = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.Common.TimerMgr",
})

function View:OnListItemObjectSet(Content)
    self.Content = Content
    self:InitView(Content)
    self.Btn_Click.OnClicked:Clear()
    self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)

    -- 绑定四态事件
    if self.Btn_Click.OnHovered then
        self.Btn_Click.OnHovered:Clear()
        self.Btn_Click.OnHovered:Add(self, self.OnHovered)
    end

    if self.Btn_Click.OnUnhovered then
        self.Btn_Click.OnUnhovered:Clear()
        self.Btn_Click.OnUnhovered:Add(self, self.OnUnhovered)
    end

    if self.Btn_Click.OnPressed then
        self.Btn_Click.OnPressed:Clear()
        self.Btn_Click.OnPressed:Add(self, self.OnPressed)
    end
end

function View:InitView(Content)
    if Content.IsEmpty then
        self.BG.WidgetSwitcher_State:SetActiveWidgetIndex(1)
        self.Group_Item:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Panel_Lock:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    else
        self.BG.WidgetSwitcher_State:SetActiveWidgetIndex(0)
        self.Group_Item:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvinsible)
    end
    local AutoChessEquipId = Content.Data.Id
    local AutoChessEquipData = DataMgr.RobotEquip[AutoChessEquipId]
    
    -- 图标
    local ImgEquip = nil
    if AutoChessEquipData.EquipIcon then
        ImgEquip = LoadObject(AutoChessEquipData.EquipIcon)
    else
        ImgEquip = LoadObject("/Game/UI/Texture/Dynamic/Image/Head/Monster/T_Head_Empty.T_Head_Empty")
    end
    local DynamicMaterial = self.BG.Item_BG:GetDynamicMaterial()
    if DynamicMaterial then
        DynamicMaterial:SetTextureParameterValue("IconMap", ImgEquip)
    end

    -- 稀有度
    local DynamicMaterial = self.BG.Item_BG:GetDynamicMaterial()
    DynamicMaterial:SetScalarParameterValue("IconOpacity", 1)
    DynamicMaterial:SetScalarParameterValue("Index", Content.Data.Rarity)

    self.Text_Name:SetText(GText(AutoChessEquipData.EquipName))
    self.Text_Cost:SetText(AutoChessEquipData.DeployCost)

    -- 锁定态
    if Content.Data.Locked then
        self.Panel_Lock:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvinsible)
    else
        self.Panel_Lock:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    -- New红点
    if Content.Data.IsNew then
        self.New:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvinsible)
    else
        self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    -- 选中态
    if Content.IsSelected then
        local EndTime = self.BG.Click:GetEndTime()
        self:SetAnimationCurrentTime(self.BG.Click, EndTime)
    else
        self.BG:PlayAnimation(self.BG.Normal)
    end

end

function View:OnFocusReceived(MyGeometry, InFocusEvent)
    if self.Content and self.Content.OnFocusReceivedCallback then
        self.Content.OnFocusReceivedCallback(self.Content.Data.Id)
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function View:SetIsNew(bIsNew)
    self.Content.Data.IsNew = bIsNew
    if bIsNew then
        self.New:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvinsible)
    else
        self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function View:SetSelected(bSelected)
    self.Content.IsSelected = bSelected
    if bSelected then
        self.BG:PlayAnimation(self.BG.Click)
        self:PlayAnimation(self.Click)
    else
        self.BG:PlayAnimation(self.BG.Normal)
        self:PlayAnimation(self.Normal)
    end
end

function View:OnBtnClicked()
    AudioManager(self):PlayUISound(self, "event:/ui/common/combat_bag_cell_place_common", nil, nil)
    if self.Content and self.Content.OnBtnClickedCallback then
        self.Content.OnBtnClickedCallback(self.Content.Data.Id)
    end
end

-- 四态：Hover、UnHover、Press、Normal
function View:OnHovered()
    if self.Content.IsSelected then return end
    self.BG:PlayAnimation(self.BG.Hover)
end

function View:OnUnhovered()
    if self.Content.IsSelected then return end
    self.BG:StopAnimation(self.BG.Hover)
    self.BG:PlayAnimation(self.BG.UnHover)
end

function View:OnPressed()
    if self.Content.IsSelected then return end
    self.BG:StopAnimation(self.BG.Hover)
    self.BG:PlayAnimation(self.BG.Press)
end

function View:OnAnimationFinished(Animation)
    DebugPrint("OnAnimationFinished: ".. Animation:GetName())
end


return View