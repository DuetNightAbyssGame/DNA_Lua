require "UnLua"

---@type BP_TalkSelectItemUI_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

--region UUserWidget
--function M:Initialize(Initializer)
--end
--function M:PreConstruct(IsDesignTime)
--end
-- function M:Construct()
-- end
--function M:Tick(MyGeometry, InDeltaTime)
--end
--endregion

--region Life
---@param InSelectUI BP_TalkSelectUI_C
---@param InItem UTalkButtonItem
function M:Init(InSelectUI, InItem)
    self.SelectUI = InSelectUI
    self.Item = InItem
    self.OutAnimFinishedInfo = nil
    
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.KeyNode:SetVisibility(ESlateVisibility.Hidden)
    else
        self.KeyNode:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.Border_ItemBg:SetVisibility(ESlateVisibility.Hidden)
    self.Noise:SetVisibility(ESlateVisibility.Collapsed)
    self.TextBlock_Name:SetText(self.Item.OptionTopic)

    if (InItem.bIsSelected) then
        self:PlayAnimation(self["Read"])
    else
        self:PlayAnimation(self["in"])
    end
    
    self.Button_Select.OnClicked:Add(self, self.OnItemClicked)
    self.Button_Select.OnHovered:Add(self, self.OnHoverItem)
    self:BindToAnimationFinished(self.Pickup, {self, self.OnPickupAnimFinished})
    -- self.BindToAnimationFinished(self, self.PickUp, {self, self.OnPickUpAnimFinished})
    -- self.BindToAnimationFinished(self, self.Out, {self, self.OnOutAnimFinished})
    self.Key_PickUp:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Text",
                Text = "F"
            }
        }
    })
    self.Key_PickUp:AddExecuteLogic(self, self.OnAutoPlayClicked)
end
--endregion

--region BindEvent
function M:OnItemClicked()
    UIUtils.PlayCommonBtnSe(self)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm","",nil)
    self:PlayAnimation(self.Pickup)
    self.SelectUI:SetItemsVisibility(ESlateVisibility.HitTestInvisible)
end

function M:OnPickupAnimFinished()
    self.SelectUI:OnItemClicked(self.Item)
end

function M:OnHoverItem()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_add","",nil)
    DebugPrint(self.SelectUI:GetItemIndex(self))
    self.SelectUI:SelectNewItem(self.SelectUI:GetItemIndex(self))
end

function M:OnSelectItem()
    self.Noise:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.KeyNode:SetVisibility(UE4.ESlateVisibility.Visible)
    else
        self.KeyNode:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if not self:IsAnimationPlaying(self["in"]) then
        self:PlayAnimation(self.Loop, 0, 0)
    end
    self.Border_ItemBg:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self:ListenForInputAction("TalkOption", EInputEvent.IE_Pressed, false, {self,self.OnItemClicked})
end

function M:OnUnselectItem()
    self.Noise:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.KeyNode:SetVisibility(UE4.ESlateVisibility.Hidden)
    else
        self.KeyNode:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self:StopAnimation(self.Loop)
    self.Border_ItemBg:SetVisibility(UE4.ESlateVisibility.Hidden)
    self:StopListeningForInputAction("TalkOption", EInputEvent.IE_Pressed)
end

function M:OnAnimationFinished(InAnimation)
    if self["in"] == InAnimation then
        if self.Noise:GetVisibility() ~= ESlateVisibility.Collapsed then
            self:PlayAnimation(self.Loop, 0, 0)
        end
    end
end

--endregion

--region Bind
function M:BindOutAnimFinished(InObj, InFunc)
    self.OutAnimFinishedInfo = {}
    self.OutAnimFinishedInfo.Obj = InObj
    self.OutAnimFinishedInfo.Func = InFunc
end
function M:UnbindOutAnimFinished()
    self.OutAnimFinishedInfo = nil
end
--endregion

--region Default
function M:PlayOutAnim()
    self.OutAnimFinishedInfo.Func(self.OutAnimFinishedInfo.Obj, self)
end
--endregion

return M
