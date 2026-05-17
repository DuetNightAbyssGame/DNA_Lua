---@type WBP_Battle_Training_Item_C
local WBP_Battle_Training_Item_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_Battle_Training_Item_C:OnListItemObjectSet(Content)
    self.Data = Content
    if Content.IsEmpty then 
        self.Root:SetRenderOpacity(0)
        self.Switch_Type:SetActiveWidgetIndex(1)
        self:PlayAnimation(self.In)
        self:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        return 
    else 
        self.Switch_Type:SetActiveWidgetIndex(0)
        self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end

    self.Owner = Content.Owner
    self.Index = Content.Index
    self.RuleId = Content.RuleId
    self.OnClickedCallback = Content.OnClicked
    self.OnDeclineClickedCallback = Content.OnDeclineClicked
    self.Selected = Content.Selected -- 是否为普通选中状态
    self.Checked = Content.IsChecked   -- 是否为多选状态

    self.PreferredMonsterId = Content.PreferredMonsterId
    local GallaryId = DataMgr.Monster[self.PreferredMonsterId].GalleryRuleId
    local MonsterIconPath = nil
    if GallaryId then
        MonsterIconPath = DataMgr.GalleryRule[GallaryId].MonsterIcon
    end
    if not MonsterIconPath then
        MonsterIconPath = "/Game/UI/UI_PNG/03Image/Monster_Head/Head_Empty.Head_Empty"
    end
    local MonsterIcon = LoadObject(MonsterIconPath)
    local MatInstance = LoadObject('/Game/UI/WBP/Battle/Widget/VX/MI_MaskIcon_TrainingAvatar_L.MI_MaskIcon_TrainingAvatar_L')
    self.TrainingMonsterMaskMatInstance = UE4.UKismetMaterialLibrary.CreateDynamicMaterialInstance(self, MatInstance, "None")
    self.TrainingMonsterMaskMatInstance:SetTextureParameterValue("IconMap", MonsterIcon)
    self.Img_Item:SetBrushFromMaterial(self.TrainingMonsterMaskMatInstance)
   
    
    self.Root:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Btn_Decline.Button_Area.OnClicked:Add(self, self.OnDeclineClicked)
    self.Btn_Decline.SoundFunc = function() end

    self:StopAllAnimations()
    self:SetSelected(Content.Selected)
    if Content.Locked then
        self.Group_Lock:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else 
        self.Group_Lock:SetVisibility(UE4.ESlateVisibility.Collapsed) 
    end

    self:OnItemChecked(self.Checked)
    self:PlayAnimation(self.In)    
    self:BindButtonPerformances()
    self:UpdateItemView()
end

function WBP_Battle_Training_Item_C:OnFocusReceived(MyGeometry, InFocusEvent)
    local CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    if CurInputDeviceType == UE4.ECommonInputType.Gamepad then 

    end

    return self.Super.OnFocusReceived(self, MyGeometry, InFocusEvent)
end

function WBP_Battle_Training_Item_C:OnDeclineClicked()
    if self.Data.OnDeclineClickedCallback and self.Data.OnDeclineClickedCallback.Func then 
        self.Data.OnDeclineClickedCallback.Func(self.Data.OnDeclineClickedCallback.Inst, self.Data.RuleId)
    end
end

function WBP_Battle_Training_Item_C:UnInitTrainingItem()
    if self.Out ~= nil then
        self:PlayAnimation(self.Out)
    else 
        self.Root:SetVisibility(UE4.ESlateVisibility.Collapsed) 
    end
    self:UnBindButtonPerformances()
end

function WBP_Battle_Training_Item_C:BindButtonPerformances()
    self.Btn_Click.OnClicked:Add(self, self.OnClicked)
    self.Btn_Click.OnPressed:Add(self, self.OnPressed)
    self.Btn_Click.OnReleased:Add(self, self.OnReleased)
    self.Btn_Click.OnHovered:Add(self, self.OnHovered)
    self.Btn_Click.OnUnhovered:Add(self, self.OnUnhovered)
end

function WBP_Battle_Training_Item_C:UnBindButtonPerformances()
    self.Btn_Click.OnClicked:Clear()
    self.Btn_Click.OnPressed:Clear()
    self.Btn_Click.OnReleased:Clear()
    self.Btn_Click.OnHovered:Clear()
    self.Btn_Click.OnUnhovered:Clear()
end

function WBP_Battle_Training_Item_C:UpdateItemView()
    if self.Data.CheckedNum then 
        self.Text_Num:SetText(self.Data.CheckedNum)
    end
end

function WBP_Battle_Training_Item_C:OnItemChecked(IsChecked)
    -- DebugPrint("Item = " .. self:GetName())
    if self.Data.IsEmpty then return end
    self.Checked = IsChecked
    if IsChecked then
        self.Group_Num:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        self.Text_Num:SetText(self.Data.CheckedNum)
        self.Btn_Decline:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else 
        self.Group_Num:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_Decline:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self:UpdateItemView()
end

function WBP_Battle_Training_Item_C:SetSelected(IsSelected)
    -- if self.Data.Locked then return end 
    self.Selected = IsSelected 
    if IsSelected then
        self.VX_Select:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.VX_Select:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function WBP_Battle_Training_Item_C:Check()
    if self.Data.Locked then return end 
    self.Checked = true
    self:PlayAnimation(self.Click)
end

function WBP_Battle_Training_Item_C:Uncheck()
    if self.Data.Locked then return end 
    self.Checked = false
    self:PlayAnimation(self.Normal)
end

function WBP_Battle_Training_Item_C:Release()
    if self.Data.Locked then return end 
    self:StopAnimation(self.Selected_Loop)
end

function WBP_Battle_Training_Item_C:OnClicked()
    if self.Data.IsEmpty then return end
    self:PlayAnimation(self.Click)
    local CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    if self.OnClickedCallback ~= nil and self.OnClickedCallback.Func ~= nil then
        self.OnClickedCallback.Func(self.OnClickedCallback.Inst, self)
    end  

end

function WBP_Battle_Training_Item_C:OnPressed()
    if self.Data.Locked then return end 
    self:PlayAnimation(self.Press)
    self:PlayAnimation(self.Selected_Loop, 0, 0)
end

function WBP_Battle_Training_Item_C:OnReleased()
    if self.Data.Locked then return end 
    if not self.Selected then
        self:Release()
        self:PlayAnimation(self.Hover)
    end
end

function WBP_Battle_Training_Item_C:OnHovered()
    self:PlayAnimation(self.Hover)
    if self.Data.OnItemHovered and self.Data.OnItemHovered.Func then 
        self.Data.OnItemHovered.Func(self.Data.OnItemHovered.Inst, self.Data.RuleId)
    end
end

function WBP_Battle_Training_Item_C:OnUnhovered()
    self:PlayAnimation(self.UnHover)
end

return WBP_Battle_Training_Item_C