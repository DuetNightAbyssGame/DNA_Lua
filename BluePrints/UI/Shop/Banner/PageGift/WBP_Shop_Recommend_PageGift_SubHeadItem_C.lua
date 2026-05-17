require "UnLua"

---@type WBP_Shop_Recommend_PageGift_SubHeadItem_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Init(Content, ParentWidget)
    self.TabId = Content.TabId
    self.CharId = Content.CharId
    self.SkinId = Content.SkinId
    -- self.ClickCallback = Content.ClickCallback
    self.ParentWidget = ParentWidget
    local IconPath = nil
    if self.SkinId then
        IconPath = DataMgr.Skin[self.SkinId].Icon or "/Game/UI/Texture/Dynamic/Image/Head/Avatar/T_Head_Heitao"
    else
        IconPath = DataMgr.Char[self.CharId].Icon or "/Game/UI/Texture/Dynamic/Image/Head/Avatar/T_Head_Heitao"
    end
    if IconPath then
        local Image = LoadObject(IconPath)
        if Image then
            local DynamicMaterial = self.Image_Head:GetDynamicMaterial()
            DynamicMaterial:SetTextureParameterValue("IconMap",Image)
        end
    end
    self.Text_Index:SetText(self.TabId)

    self.Btn_Click.OnClicked:Add(self, self.OnItemClick)
    self.Btn_Click.OnHovered:Add(self, self.OnItemHovered)
    self.Btn_Click.OnUnhovered:Add(self, self.OnItemUnhovered)
    self.Btn_Click.OnPressed:Add(self, self.OnItemOnPressed)

    self:BindClickEvent(Content.ClickEvent)
    if Content.bIsSelected then
        self:OnItemClick(nil, true)
    else
        self:UnSelect()
    end

    self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:BindClickEvent(ClickEvent)
    self.ClickObj = ClickEvent.Obj
    self.ClickCallback = ClickEvent.Callback
end

function M:OnItemClick(bTriggerWhenHover, bNotPlayMusic)
    if self.bSelected then
        if not bTriggerWhenHover and (type(self.VirtualClickCallback) == "function") then
            self.VirtualClickCallback(self.Parent, self.BannerId)
        end
        return
    end
    if not self.ClickCallback then
        return
    end
    self.bSelected = true
    self:PlayAnimation(self.Click)
    self.ClickCallback(self.ClickObj, self.TabId, self)
end

function M:OnItemHovered()
    if self.bSelected then
        return
    end
    self:PlayAnimation(self.Hover)
end

function M:OnItemUnhovered()
    if self.bSelected then
        return
    end
    self:PlayAnimation(self.Unhover)
end

function M:OnItemOnPressed()
    if self.bSelected then
        return
    end
    self:PlayAnimation(self.Press)
end

function M:UnSelect()
    self.bSelected = false
    self:PlayAnimation(self.Normal)
end

function M:OnBtnClick()
    if self.bIsSelected then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/activity/sub_btn_click", nil, nil)
end

function M:SetIsSelected(bIsSelected)
    self.bIsSelected = bIsSelected
    self.Btn_Click:SetChecked(bIsSelected)
    if (bIsSelected) then
        self.Btn_Click:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Btn_Click:SetVisibility(UIConst.VisibilityOp.Visible)
        self:PlayAnimation(self.Normal)
    end
end

function M:OnBtnStateChange(IsChecked)
    if (IsChecked) then
        if (self.ClickCallback) then
            self.ClickCallback(self.ParentWidget, self.TabId, self)
        end
    end
end

function M:OnBtnHover()
    if (self.bIsSelected) then
        return
    end
    self:PlayAnimationForward(self.Hover)
end

function M:OnBtnUnHover()
    if (self.bIsSelected) then
        return
    end
    self:PlayAnimationForward(self.UnHover)
end

function M:Destruct()
    -- if self.ActivityId then
    --     ActivityReddotHelper.RemoveReddotListenByEventId(self.ActivityId, self)
    -- end
end

return M
