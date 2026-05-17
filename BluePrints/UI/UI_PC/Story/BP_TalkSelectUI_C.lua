require "UnLua"

---@type BP_TalkSelectUI_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

--region UUserWidget
-- function M:Initialize(Initializer)
-- end
-- function M:PreConstruct(IsDesignTime)
-- end
function M:Construct()
    self.ItemUIPathName = "/Game/UI/UI_PC/Story/BP_TalkSelectItemUI.BP_TalkSelectItemUI"
    self.ItemClickedInfo = nil
    self.DelayDestoryCount = 0
    self.MouseWheelTime = 0
end

function M:Tick(MyGeometry, InDeltaTime)
    if self.MouseWheelTime > 0 then
        self.MouseWheelTime =  self.MouseWheelTime - InDeltaTime
    end
end
--endregion

--region Event
---@param InObj UObject
---@param InFunc function
function M:BindItemClicked(InObj, InFunc)
    self.ItemClickedInfo = {}
    self.ItemClickedInfo.Obj = InObj
    self.ItemClickedInfo.Func = InFunc
end
function M:UnBindItemClicked()
    self.ItemClickedInfo = nil
end
--endregion

--region Item call event
---@param InItem UTalkButtonItem
function M:OnItemClicked(InItem)
    if(self.ItemClickedInfo) then
        self.ItemClickedInfo.Func(self.ItemClickedInfo.Obj, InItem)
    end
end
--endregion

--region Item operations
---@param InItem UTalkButtonItem
function M:AddItem(InItem)
    local UIManager = UIManager(self)
    -- ---@type BP_TalkSelectItemUI_C
    local ItemUI = UIManager:CreateWidget(self.ItemUIPathName)
    self.ScrollBox_TalkOptions:AddChild(ItemUI)
    ItemUI:Init(self, InItem) -- 需要在Item被添加到ScrollBox，触发UseWidget的生命周期函数后，再调用Init
    self:PostChangeItemNum()
end

---@param InVisibility ESlateVisibility
function M:SetItemsVisibility(InVisibility)
    local ChildMaxIndex = self.ScrollBox_TalkOptions:GetChildrenCount() - 1
    for i = 0, ChildMaxIndex do
        ---@type UUserWidget
        local Child = self.ScrollBox_TalkOptions:GetChildAt(i)
        Child:SetVisibility(InVisibility)
    end
end

function M:ClearListItems()
    self.ScrollBox_TalkOptions:ClearChildren()
    -- self.DelayDestoryCount = 0
    -- local ChildCount = self.ScrollBox_TalkOptions:GetChildrenCount()
    -- local ChildMaxIndex = ChildCount - 1
    -- for i = 0, ChildMaxIndex do
    --     ---@type BP_TalkSelectItemUI_C
    --     local Child = self.ScrollBox_TalkOptions:GetChildAt(i)
    --     Child:BindOutAnimFinished(self, self.ClearItemsCallBack)
    --     Child:PlayOutAnim()
    -- end
end
---@param Item BP_TalkSelectItemUI_C
-- function M:ClearItemsCallBack(Item)
--     Item:UnbindOutAnimFinished()
--     self.DelayDestoryCount = self.DelayDestoryCount + 1;
--     local ChildCount = self.ScrollBox_TalkOptions:GetChildrenCount()
--     if self.DelayDestoryCount == ChildCount then
--         self.ScrollBox_TalkOptions:ClearChildren()
--         self:PostChangeItemNum()
--     end
-- end
--endregion

--region Default
function M:PostChangeItemNum()
     local TalkOptionNum = self.ScrollBox_TalkOptions:GetChildrenCount()
     self:SetKeyMap(TalkOptionNum~= 0)
     self:UpdateImgMouse()
end

---@param IsSet boolean
function M:SetKeyMap(IsSet)
    if IsSet then
        self.CurrentSelectItemIdx=0
        self.ScrollBox_TalkOptions:GetChildAt(self.CurrentSelectItemIdx):OnSelectItem()
        self:ListenForInputAction("TalkUpSelect", EInputEvent.IE_Pressed, true, {self, self.UpSelectAction})
        self:ListenForInputAction("TalkDownSelect", EInputEvent.IE_Pressed, true, {self, self.DownSelectAction})
    else
        -- self:StopListeningForAllInputActions()
        self.CurrentSelectItemIdx = nil
    end
end

function M:UpdateImgMouse()
    if CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance) == 'Mobile' then
        return
    end

    local TalkOptionNum = self.ScrollBox_TalkOptions:GetChildrenCount()
    if TalkOptionNum < 2 then
        self.Img_Mouse:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.Img_Mouse:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        local SizeY = TalkOptionNum / 2 * 45
        if TalkOptionNum > 6 then
            SizeY = 3 * 45
        end
        local CurPosition = self.Img_Mouse.Slot:GetPosition()
        self.Img_Mouse.Slot:SetPosition(FVector2D(CurPosition.X, SizeY))
    end
end
--endregion

--region KeyMapEvent
function M:UpSelectAction()
    if self.MouseWheelTime > 0 then
        return
    end
    if(self.ScrollBox_TalkOptions:GetChildrenCount()<=0) then
        return
    end
    DebugPrint("UpSelectAction",self.CurrentSelectItemIdx)
    self.MouseWheelTime = 0.1
    local NewSelectItemIdx = 0 
    if self.CurrentSelectItemIdx > 0 then
        NewSelectItemIdx = self.CurrentSelectItemIdx - 1
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_add","",nil)
    end
    self:SelectNewItem(NewSelectItemIdx)
end

function M:SelectNewItem(NewItemIdx)
    if self.CurrentSelectItemIdx == NewItemIdx then
        return
    end
    self.ScrollBox_TalkOptions:GetChildAt(self.CurrentSelectItemIdx):OnUnselectItem()
    self.ScrollBox_TalkOptions:GetChildAt(NewItemIdx):OnSelectItem()
    self.CurrentSelectItemIdx = NewItemIdx
    self.ScrollBox_TalkOptions:ScrollWidgetIntoView(self.ScrollBox_TalkOptions:GetChildAt(self.CurrentSelectItemIdx), true)
end

function M:GetItemIndex(Item)
    local ChildMaxIndex = self.ScrollBox_TalkOptions:GetChildrenCount() - 1
    for i = 0, ChildMaxIndex do
        ---@type UUserWidget
        local Child = self.ScrollBox_TalkOptions:GetChildAt(i)
        if Child == Item then
            return i
        end
    end
    return -1
end

function M:DownSelectAction()
    if self.MouseWheelTime > 0 then
        return
    end
    if(self.ScrollBox_TalkOptions:GetChildrenCount()<=0) then
        return
    end
    DebugPrint("DownSelectAction",self.CurrentSelectItemIdx)
    self.MouseWheelTime = 0.1
    local NewSelectItemIdx = self.ScrollBox_TalkOptions:GetChildrenCount()-1
    if self.CurrentSelectItemIdx < self.ScrollBox_TalkOptions:GetChildrenCount()-1 then
        NewSelectItemIdx = self.CurrentSelectItemIdx + 1
    end
    if(NewSelectItemIdx~=self.CurrentSelectItemIdx) then
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_add","",nil)
        self.ScrollBox_TalkOptions:GetChildAt(self.CurrentSelectItemIdx):OnUnselectItem()
        self.ScrollBox_TalkOptions:GetChildAt(NewSelectItemIdx):OnSelectItem()
        self.CurrentSelectItemIdx = NewSelectItemIdx
    end
    self.ScrollBox_TalkOptions:ScrollWidgetIntoView(self.ScrollBox_TalkOptions:GetChildAt(self.CurrentSelectItemIdx), true)
end
--endregion

return M
