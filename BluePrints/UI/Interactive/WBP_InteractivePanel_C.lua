--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
require "DataMgr"

---@class WBP_InteractivePanel_C : WBP_Battle_Interactive_P_C, BP_UIState
local WBP_InteractivePanel_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_InteractivePanel_C:Initialize(Initializer)
    self.Super.Initialize(self)

    self.PickUpOwner = nil
    self.MouseWheelTime = 0
    self.bConstructed = false
    self.BattleInteractiveComp = {}

    ---@type WBP_InteractiveItem_C
    self.PickAllInteractiveItem = nil
end

function WBP_InteractivePanel_C:Construct()
    self.Super.Construct(self)

    if self.bConstructed then
        return
    end

    self.bConstructed = true

    self.IsSetedKeyMap = false
    self.MergeActors = {}
    ---@type WBP_InteractiveItem_C
    self.CurSelectedItem = nil

    self.ScrollBox_Interactive:ClearChildren()

    self.PlatformName = CommonUtils.GetDeviceTypeByPlatformName()

    -- 存放具体交互选项，用于添加到列表
    rawset(self, "PriorityItemList", {})
    -- 存放优先级，用于排序 从大到小
    rawset(self, "PriorityLevelList", {})

    self.CurInputDeviceType = nil
    self:InitListenEvent()
end

function WBP_InteractivePanel_C:Destruct()
    self:ClearListenEvent()
    WBP_InteractivePanel_C.Super.Destruct(self)
end

function WBP_InteractivePanel_C:InitListenEvent()
    -- 刷新一些基础信息
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end

    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function WBP_InteractivePanel_C:ClearListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    end
end

function WBP_InteractivePanel_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end

    if self.CurSelectedItem then
        self.CurSelectedItem:UseGamePadStyle(CurInputDevice == ECommonInputType.Gamepad)
    end

    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        if CurInputDevice == ECommonInputType.MouseAndKeyboard then
            local ResourceIconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Key/PC/T_Key_MouseScroll.T_Key_MouseScroll'"
            rawset(self, "LoadResourceID", nil)
            local Handle = UE4.UResourceLibrary.LoadObjectAsyncWithId(self, ResourceIconPath, {self, WBP_InteractivePanel_C.OnInteractiveTipIconLoadFinished})
            if Handle then
                rawset(self, "LoadResourceID", Handle.ResourceID)
            end
            -- self:SetMouseImgByPath("Texture2D'/Game/UI/Texture/Dynamic/Atlas/Key/T_Key_MouseScroll.T_Key_MouseScroll'")
            if self.Panel_Capture then
                local CapturePanel = self.Panel_Capture:GetChildAt(0)
                if CapturePanel then
                    CapturePanel.WS_Type:SetActiveWidgetIndex(0)
                end
            end
        else
            self:UpdateMouseGamePadImage(CurGamepadName)
        end
    end

    self.CurInputDeviceType = CurInputDevice
end

function WBP_InteractivePanel_C:Tick(MyGeometry, InDeltaTime)
    if self.MouseWheelTime > 0 then
        self.MouseWheelTime =  self.MouseWheelTime - InDeltaTime
    end
    if self.bPressed and IsValid(self:GetCurrentInteractiveItem()) then
        if self:GetCurrentInteractiveItem():IsLocked() or self:GetCurrentInteractiveItem():IsForbidden(UGameplayStatics.GetPlayerCharacter(self, 0)) then
            self:ReleasedSelectAction()
        end
    end
end

function WBP_InteractivePanel_C:ReceiveExitState(StackAction)
    self.Super.ReceiveExitState(self, StackAction)
end

function WBP_InteractivePanel_C:AddNormalInteractiveItem(InItem)
    local ExistedItem, bMerge = self:CheckItemDataExist(InItem) 
    if ExistedItem then
        ExistedItem:ReAdd()
        if bMerge then
            assert(self.MergeActors[InItem.MergeName], "找不到已经存在的合并交互" .. InItem.MergeName)
            self.MergeActors[InItem.MergeName]:AddMergeList(InItem:GetOwner():GetName(), InItem)
        end
        return
    end

    if InItem.MergeName == nil then
        self:AddUIItem(InItem)
        return InItem
    else
        local Ret = nil
        if self.MergeActors[InItem.MergeName] == nil then
            local UnitSpawnPath = UE4.UClass.Load("/Game/BluePrints/Item/Chest/MergeMechanism.MergeMechanism")
            local MergeActor = self:GetWorld():SpawnActor(UnitSpawnPath, FTransform(), UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
            self.MergeActors[InItem.MergeName] = MergeActor
            MergeActor.BP_MergeInteractiveComponent.TemplateInteractiveComponent = InItem
            MergeActor.BP_MergeInteractiveComponent:SetInteractiveName(InItem:GetInteractiveName())
            MergeActor.BP_MergeInteractiveComponent.MergeActorName = InItem.MergeName
            MergeActor.BP_MergeInteractiveComponent.ListPriority = 0
            self:AddUIItem(MergeActor.BP_MergeInteractiveComponent)
            Ret = MergeActor.BP_MergeInteractiveComponent
        end
        self.MergeActors[InItem.MergeName]:AddMergeList(InItem:GetOwner():GetName(), InItem)
        return Ret
    end
end

function WBP_InteractivePanel_C:AddBattleInteractiveItem(InItem)
    local HasDuplicateKey = false
    for _, Comp in ipairs(self.BattleInteractiveComp)do
        if Comp == InItem then
            HasDuplicateKey = true
        end
    end
    if not HasDuplicateKey then
        table.insert(self.BattleInteractiveComp, InItem)
        return InItem
    end
end

function WBP_InteractivePanel_C:RemoveBattleInteractiveItem(InItem)
    local IndexToRemove = -1
    for i, Item in ipairs(self.BattleInteractiveComp) do
        if Item == InItem then
            IndexToRemove = i
        end
    end
    if IndexToRemove ~= -1 then
        self:ReleasedSelectAction()
        table.remove(self.BattleInteractiveComp, IndexToRemove)
        if #self.BattleInteractiveComp == 0 then
            ---@type WBP_Battle_Capture_C
            local CapturePanel = self.Panel_Capture:GetChildAt(0)
            if CapturePanel then
                CapturePanel:UnbindAllFromAnimationFinished(CapturePanel.Out)
                CapturePanel:BindToAnimationFinished(CapturePanel.Out, 
                { self, 
                function()
                    self.WidgetSwitcher:SetActiveWidget(self.Panel_Interactive)
                    self.bPressed = false
                    self.Panel_Capture:ClearChildren()
                    self:Close()
                end })
                CapturePanel:PlayAnimation(CapturePanel.Out)
            end
        end
    end
end

---@param InItem BP_InteractiveBaseComponent_C
function WBP_InteractivePanel_C:AddInteractiveItem(InItem)
    if not InItem then
        return
    end
    local NewItem = nil
    local Priority = InItem.Priority or "Normal"
    if Priority == "Battle" then
        NewItem = self:AddBattleInteractiveItem(InItem)    
    else    
        NewItem = self:AddNormalInteractiveItem(InItem)
    end

    if NewItem then
        self:PostChangeInteractiveBtn(NewItem, Priority)
    end
end

---@param InItem BP_InteractiveBaseComponent_C
function WBP_InteractivePanel_C:AddUIItem(InItem)
    ---@type BP_UIManagerComponent_C
    local UIManager = UIManager(self)
    assert(UIManager, "Can't get UIManager")
    ---@type WBP_InteractiveItem_C
    local InteractiveItem = UIManager:GetWidgetFromPreload("InteractiveItem")
    if not InteractiveItem then
        InteractiveItem = UIManager:_CreateWidgetNew("InteractiveItem")
    end
    InteractiveItem:InitInteractiveInfo(InItem)
    local Index = self:GetIndexByPriority(InteractiveItem)
    local TmpItemList = {}
    for i = Index, self.ScrollBox_Interactive:GetChildrenCount() - 1 do
        local Item = self.ScrollBox_Interactive:GetChildAt(i)
        table.insert(TmpItemList, Item)
    end
    local Slot = self.ScrollBox_Interactive:AddChild(InteractiveItem)
    Slot:SetHorizontalAlignment(UE4.EHorizontalAlignment.HAlign_Left)
    for i = 1, #TmpItemList do
        rawset(TmpItemList[i], "bSkipDestruct", true)
        Slot = self.ScrollBox_Interactive:AddChild(TmpItemList[i])
        rawset(TmpItemList[i], "bSkipDestruct", false)
        Slot:SetHorizontalAlignment(UE4.EHorizontalAlignment.HAlign_Left)
    end
    if Index == 0 then
        self:SelectFirstItem()
    end
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        if self.ScrollBox_Interactive:GetChildrenCount() > 1 then
            self.Img_Mouse:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        else
            self.Img_Mouse:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
    -- local CacheInItem = nil
    -- local CurrentInItem = InItem
    -- --把按钮信息依次往下覆盖，省掉AddChild的消耗
    -- for i = Index, self.ScrollBox_Interactive:GetChildrenCount() - 1 do
    --     local Slot = self.ScrollBox_Interactive:GetChildAt(i)
    --     CacheInItem = Slot.InteractiveInfo
    --     Slot:InitInteractiveInfo(CurrentInItem)
    --     CurrentInItem = CacheInItem
    -- end
end

---@param InItem WBP_InteractiveItem_C
function WBP_InteractivePanel_C:GetIndexByPriority(InItem)
    local ItemPriorityLevel = InItem:GetInteractivePriority()
    local ListIndex = -1
    if self.PriorityItemList[ItemPriorityLevel] == nil then
        self.PriorityItemList[ItemPriorityLevel] = {InItem}
        table.insert(self.PriorityLevelList, ItemPriorityLevel)
        table.sort(self.PriorityLevelList, function(a, b)
            return a > b
        end)
        ListIndex = ListIndex + 1
    else
        table.insert(self.PriorityItemList[ItemPriorityLevel], InItem)
        ListIndex = ListIndex + #self.PriorityItemList[ItemPriorityLevel]
    end
    for _, Level in ipairs(self.PriorityLevelList) do
        if Level > ItemPriorityLevel then
            ListIndex = ListIndex + #self.PriorityItemList[Level]
        else
            break
        end
    end
    return ListIndex
end

---@param InItem BP_InteractiveBaseComponent_C
function WBP_InteractivePanel_C:InteractiveItemPlayAnim(InItem, AnimName)
    if not InItem then
        return
    end
    
    local Priority = InItem.Priority or "Normal"
    if AnimName == "Out" and Priority == "Battle" then
        self:RemoveBattleInteractiveItem(InItem)
    end

    local ExistedItem = self:CheckItemDataExist(InItem)
    if not ExistedItem then
        return
    end
    if ExistedItem == self.CurSelectedItem then
        self:ReleasedSelectAction(false)
    end

    if InItem.MergeName == nil then
        self:PlayItemAnimation(InItem, AnimName)
    else
        local MergeActor = self.MergeActors[InItem.MergeName]
        if MergeActor and MergeActor:DeleteMergeList(InItem:GetOwner():GetName()) then

            self:PlayItemAnimation(MergeActor.BP_MergeInteractiveComponent, AnimName)
        end
    end
end

---@param InItem BP_InteractiveBaseComponent_C
function WBP_InteractivePanel_C:PlayItemAnimation(InItem, AnimName, bNormalPlay)
    for i = 0, self.ScrollBox_Interactive:GetChildrenCount() - 1 do

        ---@type WBP_InteractiveItem_C
        local InteractiveItem = self.ScrollBox_Interactive:GetChildAt(i)
        
        if InteractiveItem.InteractiveInfo == InItem or self:IsInteractiveContentEqual(InteractiveItem.InteractiveInfo, InItem) then
            if not bNormalPlay then
                InteractiveItem:PlayInteractiveItemAnim(AnimName)
            else
                InteractiveItem:PlayAnimation(InteractiveItem:GetAnimation(AnimName))
            end
            break
        end
    end
end

---@param InItem BP_InteractiveBaseComponent_C
function WBP_InteractivePanel_C:RemoveInteractiveItem(InItem)
    self:InteractiveItemPlayAnim(InItem, "Out")
end

function WBP_InteractivePanel_C:AddPickAllInteractiveItem()
    if self.PickAllInteractiveItem then
        self.PickAllInteractiveItem:ReAdd()
        return
    end
    ---@type BP_UIManagerComponent_C1
    local UIManager = UIManager(self)
    assert(UIManager, "Can't get UIManager")
    ---@type WBP_InteractiveItem_C
    local InteractiveItem = UIManager:GetWidgetFromPreload("InteractiveItem")
    if not InteractiveItem then
        InteractiveItem = UIManager:_CreateWidgetNew("InteractiveItem")
    end
    InteractiveItem:InitPickAllInfo()
    local InsertIndex = self:GetIndexByPriority(InteractiveItem)
    local TempItemList = {}
    for i = InsertIndex, self.ScrollBox_Interactive:GetChildrenCount() - 1 do
        local Item = self.ScrollBox_Interactive:GetChildAt(i)
        table.insert(TempItemList, Item)
    end
    local Slot = self.ScrollBox_Interactive:AddChild(InteractiveItem)
    Slot:SetHorizontalAlignment(UE4.EHorizontalAlignment.HAlign_Left)
    for i = 1, #TempItemList do
        rawset(TempItemList[i], "bSkipDestruct", true)
        Slot = self.ScrollBox_Interactive:AddChild(TempItemList[i])
        rawset(TempItemList[i], "bSkipDestruct", false)
        Slot:SetHorizontalAlignment(UE4.EHorizontalAlignment.HAlign_Left)
    end
    if InsertIndex == 0 then
        self:SelectFirstItem()
    end
    self.PickAllInteractiveItem = InteractiveItem
    
end

function WBP_InteractivePanel_C:RemovePickAllInteractiveItem()
    if not self.PickAllInteractiveItem then
        return
    end
    if not self.PickAllInteractiveItem:IsAnimationPlaying(self.PickAllInteractiveItem.Out) then
        self.PickAllInteractiveItem:PlayAnimation(self.PickAllInteractiveItem.Out)
        rawset(self, "bRemoveingPickUpAllItem", true)
    end
end

function WBP_InteractivePanel_C:CanDoAction()
    if not self.CurSelectedItem and #self.BattleInteractiveComp == 0 then
        return false
    elseif self.CurSelectedItem then
        return self.CurSelectedItem:CanDoAction()
    end
    return true
end

---@return BP_InteractiveBaseComponent_C
function WBP_InteractivePanel_C:GetCurrentInteractiveItem()
    if #self.BattleInteractiveComp > 0 then
        return self.BattleInteractiveComp[1]
    end
    return self.CurSelectedItem.InteractiveInfo
end

function WBP_InteractivePanel_C:PressedSelectAction(bFromItem)
    if not self:CanDoAction() then
        return
    end
    if self.bPressed then
        return
    end
    self.TouchStartTime = UGameplayStatics.GetTimeSeconds(self)
    self.bPressed = true
    if IsValid(self:GetCurrentInteractiveItem()) then
        self.bCurrentForbid = self:GetCurrentInteractiveItem():IsForbidden(UGameplayStatics.GetPlayerCharacter(self, 0))
        self.bCurrentLocked = self:GetCurrentInteractiveItem():IsLocked()
        self:GetCurrentInteractiveItem():BtnPressed(UE4.UGameplayStatics.GetPlayerCharacter(self, 0))
    end
    if self.CurSelectedItem and #self.BattleInteractiveComp == 0 then
        self.CurSelectedItem:PlayPressAnim()
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
    if (self.CurInputDeviceType == ECommonInputType.Gamepad) then
        local CapturePanel = self.Panel_Capture:GetChildAt(0)
        -- 配合捕捉特效UI一起播放. WaitCallBack:当有交互动画时，必须等回调完成才能重新发起交互
        if CapturePanel and self:GetCurrentInteractiveItem().Capturing then 
            CapturePanel.Key_Controller:OnButtonPressed(nil, true, 0, 2.5)
        end
    end
end

function WBP_InteractivePanel_C:ReleasedSelectAction(bFromItem)
    if not self.CurSelectedItem and #self.BattleInteractiveComp == 0 then
        self.bCurrentForbid = false
        self.bCurrentLocked = false
        return
    end
    if not self.bPressed then
        self.bCurrentForbid = false
        self.bCurrentLocked = false
        return
    end
    self.bPressed = false
    if self.CurSelectedItem and not self.CurSelectedItem:CanDoAction() then
        self.bCurrentForbid = false
        self.bCurrentLocked = false
        return
    end
    local CurTime = UGameplayStatics.GetTimeSeconds(self)
    if IsValid(self:GetCurrentInteractiveItem()) then
        self:GetCurrentInteractiveItem():BtnReleased(UE4.UGameplayStatics.GetPlayerCharacter(self, 0), CurTime - self.TouchStartTime)
    end
    if self.CurSelectedItem and #self.BattleInteractiveComp == 0 then
        self.CurSelectedItem:PlayReleaseAnim()
    end
    if not bFromItem then
        self:TryClickItem(CurTime)
    end
    if self.CurSelectedItem and #self.BattleInteractiveComp == 0 then
        self.CurSelectedItem.Tag_New:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self.bCurrentForbid = false
    self.bCurrentLocked = false
    -- self.CurSelectedItem.Tag_New:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if (self.CurInputDeviceType == ECommonInputType.Gamepad) then
        local CapturePanel = self.Panel_Capture:GetChildAt(0)
        if CapturePanel then
            CapturePanel.Key_Controller:OnButtonReleased()
        end
    end
end

function WBP_InteractivePanel_C:ClickSelectAction()
    if not self:CanDoAction() then
        return
    end
    --self.bPressed = false
    local CurTime = UGameplayStatics.GetTimeSeconds(self)
    self:TryClickItem(CurTime)
    if self.CurSelectedItem and #self.BattleInteractiveComp == 0 then
        self.CurSelectedItem.Tag_New:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

---@param InUIItem WBP_InteractiveItem_C
function WBP_InteractivePanel_C:HoveredSelectAction(InUIItem)
    if not InUIItem then
        return
    end
    self:SelectSpecifiedItem(InUIItem)
end

function WBP_InteractivePanel_C:TryClickItem(CurTime)
    if not UIManager(self):TryOpenSystem("InteractiveItem") then return end
    if IsValid(self:GetCurrentInteractiveItem()) then
        if #self.BattleInteractiveComp == 0 and self.bCurrentForbid or self.bCurrentLocked then
            self.CurSelectedItem:PlayInteractiveItemAnim("Click")
        else
            self:GetCurrentInteractiveItem():BtnClicked(UE4.UGameplayStatics.GetPlayerCharacter(self, 0), self.bPressed and (CurTime - self.TouchStartTime) or 0)
        end
    end
    self:OnItemClicked()
end

function WBP_InteractivePanel_C:OnItemClicked()
    if not self.bUploadCD then
        self.bUploadCD = true
        self:AddTimer(1, function()
            self.bUploadCD = false
        end)
        local Avatar = GWorld:GetAvatar()
        local CurrentRegionId = 0
        if Avatar then
            CurrentRegionId = Avatar.CurrentRegionId
        end
        if IsValid(self:GetCurrentInteractiveItem()) then
            local InteractiveObjId
            local InteractiveObjPosition = UGameplayStatics.GetPlayerCharacter(self, 0):K2_GetActorLocation()
            local InteractiveOwner = self:GetCurrentInteractiveItem():GetOwner()
            if InteractiveOwner then
                if InteractiveOwner.UnitType and InteractiveOwner.UnitId then
                    InteractiveObjId = InteractiveOwner.UnitType .. "_" .. tostring(InteractiveOwner.UnitId)
                end
                InteractiveObjPosition = InteractiveOwner:K2_GetActorLocation()
            end
            HeroUSDKSubsystem():UploadTrackLog_Lua("event_interaction",
            {
                map_id = WorldTravelSubsystem():GetCurrentSceneId(),
                sub_region_id = CurrentRegionId,
                interaction_id = tostring(self:GetCurrentInteractiveItem().CommonUIConfirmID) or "0",
                interaction_type = self:GetCurrentInteractiveItem():GetName(),
                position = tostring(InteractiveObjPosition),
                interaction_object_id = InteractiveObjId or "null"
            })
        elseif self.CurSelectedItem == self.PickAllInteractiveItem then
            local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
            if Player then
                HeroUSDKSubsystem():UploadTrackLog_Lua("event_interaction",
                {
                    map_id = WorldTravelSubsystem():GetCurrentSceneId(),
                    sub_region_id = CurrentRegionId,
                    interaction_id = "0",
                    interaction_type = "PickUpAll",
                    position = tostring(Player:K2_GetActorLocation()),
                    interaction_object_id = "null"
                })
            end
            self:RemovePickAllInteractiveItem()
            self.IsPickingAllInteractiveItem = true
            self.ScrollBox_Interactive.Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Top)
            self:DoPickUpAllPickUpItems()
        end
    end
end
function WBP_InteractivePanel_C:GetCanPickUpItems()
    local TmpItemList = {}
    for i = 0, self.ScrollBox_Interactive:GetChildrenCount() - 1 do
        if not self.PickUpAllList then
            self.PickAllItemList = {}
        end
        ---@type WBP_InteractiveItem_C
        local EntryItem = self.ScrollBox_Interactive:GetChildAt(i)
        if not self.PickAllItemList[EntryItem] and EntryItem:IsPickUpItemWithOneClick() then
            self.PickAllItemList[EntryItem] = true
            table.insert(TmpItemList, 1, EntryItem)
        end
    end
    return TmpItemList
end

function WBP_InteractivePanel_C:DoPickUpAllPickUpItems()
    self.TouchStartTime = -1
    self.bPressed = false
    ---@type WBP_InteractiveItem_C[]
    local TmpItemList = self:GetCanPickUpItems()
    local DelayTime = 0.1
    for i = 1, #TmpItemList do
        rawset(TmpItemList[i], "bPickAll", true)
        self:AddTimer(DelayTime * i, function()
            TmpItemList[i]:OnInteractiveItemClicked()
        end)
    end
    local ClickAnimationTime  = 0.3
    self:AddTimer(DelayTime * #TmpItemList + ClickAnimationTime, function()
        self.IsPickingAllInteractiveItem = false
        self.ScrollBox_Interactive.Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Center)
        local CanPickUpItems = self:GetCanPickUpItems()
        if #CanPickUpItems > 1 and not self.IsPickingAllInteractiveItem  then
            self:AddPickAllInteractiveItem()
        else
            if self.Img_Mouse then
                self.Img_Mouse:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
            self:SelectFirstItem()
        end
    end)
end

function WBP_InteractivePanel_C:SelectFirstItem()
    self:AddDelayFrameFunc(
        function()
            if self.ScrollBox_Interactive:GetChildrenCount() <= 0 then
                self.CurSelectedItem = nil
                return
            end
            if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
                self:ReleasedSelectAction()
                self.CurSelectedItem = nil
                return
            end
            -- if self.CurSelectedItem then
            --     return
            -- end
            self:SelectSpecifiedItem(self.ScrollBox_Interactive:GetChildAt(0))
        end, 2)
end

---@param InUIItem WBP_InteractiveItem_C
function WBP_InteractivePanel_C:SelectSpecifiedItem(InUIItem, bSelectBattleItem)
    if not bSelectBattleItem and #self.BattleInteractiveComp > 0 then
        return
    end
    if not InUIItem then
        return
    end
    if self.ScrollBox_Interactive:GetChildIndex(InUIItem) == -1 then
        return
    end
    if InUIItem == self.CurSelectedItem then
        InUIItem:SelectEntryItem(true, self.CurInputDeviceType == ECommonInputType.Gamepad)
        return
    end

    if IsValid(self.CurSelectedItem) then
        self.CurSelectedItem:SelectEntryItem(false, self.CurInputDeviceType == ECommonInputType.Gamepad)
        self:ReleasedSelectAction(true)
    end
    InUIItem:SelectEntryItem(true, self.CurInputDeviceType == ECommonInputType.Gamepad)
    self.CurSelectedItem = InUIItem
end

function WBP_InteractivePanel_C:UpSelectAction()
    if self.bPressed then
        return
    end
    if self.ScrollBox_Interactive:GetChildrenCount() == 0 then
        return
    end
    if self.MouseWheelTime > 0 then
        return
    end
    local CurSelectIndex = 0
    for i = 0, self.ScrollBox_Interactive:GetChildrenCount() - 1 do
        if self.ScrollBox_Interactive:GetChildAt(i) == self.CurSelectedItem then
            CurSelectIndex = i
        end
    end
    self.MouseWheelTime = 0.1
    if CurSelectIndex > 0 then
        CurSelectIndex = CurSelectIndex - 1
    end
    self:SelectSpecifiedItem(self.ScrollBox_Interactive:GetChildAt(CurSelectIndex))
    self.ScrollBox_Interactive:ScrollWidgetIntoView(self.ScrollBox_Interactive:GetChildAt(CurSelectIndex), true)
end

function WBP_InteractivePanel_C:DownSelectAction()
    if self.bPressed then
        return
    end
    if self.ScrollBox_Interactive:GetChildrenCount() == 0 then
        return
    end
    if self.MouseWheelTime > 0 then
        return
    end
    local CurSelectIndex = 0
    for i = 0, self.ScrollBox_Interactive:GetChildrenCount() - 1 do
        if self.ScrollBox_Interactive:GetChildAt(i) == self.CurSelectedItem then
            CurSelectIndex = i
        end
    end
    self.MouseWheelTime = 0.1
    if CurSelectIndex < self.ScrollBox_Interactive:GetChildrenCount() - 1 then
        CurSelectIndex = CurSelectIndex + 1
    end
    self:SelectSpecifiedItem(self.ScrollBox_Interactive:GetChildAt(CurSelectIndex))
    self.ScrollBox_Interactive:ScrollWidgetIntoView(self.ScrollBox_Interactive:GetChildAt(CurSelectIndex), true)
end

---@return WBP_InteractiveItem_C
function WBP_InteractivePanel_C:CheckItemDataExist(InItem)
    local CheckFunction = function(InInteractiveItem)
        for i = 0, self.ScrollBox_Interactive:GetChildrenCount() - 1 do
            if self.ScrollBox_Interactive:GetChildAt(i).InteractiveInfo == InInteractiveItem then
                return self.ScrollBox_Interactive:GetChildAt(i)
            end
            local ItemInfo = self.ScrollBox_Interactive:GetChildAt(i).InteractiveInfo
            if self:IsInteractiveContentEqual(ItemInfo, InItem) then
                return self.ScrollBox_Interactive:GetChildAt(i)
            end
        end
        return false
    end

    if InItem.MergeName then
        local MergeActor = self.MergeActors[InItem.MergeName]
        if MergeActor then
            return CheckFunction(MergeActor.BP_MergeInteractiveComponent), true
        end
        return false
    end
    return CheckFunction(InItem)
end

-- 某些情况下，这个传入的InItem可能会改变，所以用一个Content来判断一下，防止拿不到正确的UI，然后一直无法销毁
function WBP_InteractivePanel_C:IsInteractiveContentEqual(InItem1, InItem2)
    if InItem1 == nil or InItem2 == nil then
        return false
    end
    if InItem1.Content ~= nil and InItem2.Content~=nil then
        if CommonUtils.IsEqual(InItem1.Content, InItem2.Content) then
            return true
        end
    end
    return false
end

function WBP_InteractivePanel_C:PostChangeInteractiveBtn(InteractiveInfo, Priority)
    local CapturePanel = self.Panel_Capture:GetChildAt(0)
    if #self.BattleInteractiveComp == 0 then
        if self.IsPickingAllInteractiveItem then
            return
        end
        self.WidgetSwitcher:SetActiveWidget(self.Panel_Interactive)
        -- 要是当前还没有拾取全部按钮
        if not self.PickAllInteractiveItem then
            -- 获取所有可拾取物
            local PickItemCount = 0
            for i = 0, self.ScrollBox_Interactive:GetChildrenCount() - 1 do
                ---@type WBP_InteractiveItem_C
                local InteractiveItem = self.ScrollBox_Interactive:GetChildAt(i)
                if InteractiveItem:IsPickUpItemWithOneClick() then
                    PickItemCount = PickItemCount + 1
                end
            end
            if PickItemCount > 1 and not self.IsPickingAllInteractiveItem  then
                -- 若可拾取物数量大于1个，并且目前并没有在一键拾取过程中 添加一键拾取按钮
                self:AddPickAllInteractiveItem()
            else
                self:RemovePickAllInteractiveItem()
            end
        else
            local PickUpItemCount = 0
            for i = 0, self.ScrollBox_Interactive:GetChildrenCount() - 1 do
                if self.ScrollBox_Interactive:GetChildAt(i):IsPickUpItemWithOneClick() then
                    PickUpItemCount = PickUpItemCount + 1
                end
            end
            if PickUpItemCount < 2 and not self.IsPickingAllInteractiveItem  then
                self:RemovePickAllInteractiveItem()
            elseif rawget(self, "bRemoveingPickUpAllItem") then
                self:AddPickAllInteractiveItem()
            end
        end
        if self.ScrollBox_Interactive:GetChildrenCount() > 0
        and (self.CurSelectedItem == nil or self.CurSelectedItem.InteractiveInfo == InteractiveInfo)
        and not self.IsPickingAllInteractiveItem then
            self:SelectFirstItem()
        elseif self.ScrollBox_Interactive:GetChildrenCount() <= 0 then
            self.CurSelectedItem = nil
        end
    elseif self.WidgetSwitcher:GetActiveWidget() ~= self.Panel_Capture or (CapturePanel and CapturePanel:IsAnimationPlaying(CapturePanel.Out)) then
        if CapturePanel then
            CapturePanel:StopAnimation(CapturePanel.Out)
        end
        self.WidgetSwitcher:SetActiveWidget(self.Panel_Capture)
        self:InitCapturePanel()
    end

    self:SetKeyMap(self.ScrollBox_Interactive:GetChildrenCount() ~= 0 or #self.BattleInteractiveComp > 0)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        if self.ScrollBox_Interactive:GetChildrenCount() > 1 and not self.IsPickingAllInteractiveItem  then
            self.Img_Mouse:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        else
            self.Img_Mouse:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
end

function WBP_InteractivePanel_C:SetKeyMap(IsSet)
    if IsSet == self.IsSetedKeyMap then return end
    self.IsSetedKeyMap = IsSet
    if IsSet then
        self:ListenForInputAction("UpSelect", EInputEvent.IE_Pressed, true, {self, self.UpSelectAction})
        self:ListenForInputAction("DownSelect", EInputEvent.IE_Pressed, true, {self, self.DownSelectAction})
        self:ListenForInputAction("Interactive", EInputEvent.IE_Pressed, true, {self, self.PressedSelectAction});
        self:ListenForInputAction("Interactive", EInputEvent.IE_Released, true, {self, self.ReleasedSelectAction});
    else self:StopListeningForAllInputActions() end
end

function WBP_InteractivePanel_C:TryClose()
    if not self:CheckNeedUnload() then
        return
    end
    self:Close()
end

function WBP_InteractivePanel_C:CheckNeedUnload()
    return self.ScrollBox_Interactive:GetChildrenCount() == 0 and #self.BattleInteractiveComp == 0
end

function WBP_InteractivePanel_C:Close()
    local UIManager = UIManager(self)
    assert(UIManager, "Can't get UIManager")
    for i = 0, self.ScrollBox_Interactive:GetChildrenCount() - 1 do
        ---@type WBP_InteractiveItem_C
        local InteractiveItem = self.ScrollBox_Interactive:GetChildAt(i)
        UIManager:RecycleWidgetToPreload("InteractiveItem", InteractiveItem)
    end
    self.ScrollBox_Interactive:ClearChildren()
    self.Super.Close(self)
end

---@param InInteractiveItem WBP_InteractiveItem_C
function WBP_InteractivePanel_C:OnInteractiveItemRemoveAnimFinish(InInteractiveItem)
    if self.PickAllItemList then
        self.PickAllItemList[InInteractiveItem] = nil
    end
    local UIManager = UIManager(self)
    assert(UIManager, "Can't get UIManager")
    UIManager:RecycleWidgetToPreload("InteractiveItem", InInteractiveItem)
    self:OnInteractiveChildRemoved(InInteractiveItem)
    self.ScrollBox_Interactive:RemoveChild(InInteractiveItem)
    if IsValid(InInteractiveItem.InteractiveInfo) and InInteractiveItem.InteractiveInfo.MergeActorName then
        local MergeActor = self.MergeActors[InInteractiveItem.InteractiveInfo.MergeActorName]
        if MergeActor then
            MergeActor:K2_DestroyActor()
            self.MergeActors[InInteractiveItem.InteractiveInfo.MergeActorName] = nil
        end
    end
    self:SetInteractiveItemBtnDisplayed(InInteractiveItem, false)
    self:PostChangeInteractiveBtn(InInteractiveItem.InteractiveInfo, InInteractiveItem.InteractiveInfo)
    self:TryClose()
    if InInteractiveItem == self.PickAllInteractiveItem then
        self.PickAllInteractiveItem = nil
        rawset(self, "bRemoveingPickUpAllItem", false)
    end
    InInteractiveItem.InteractiveInfo = nil
end

function WBP_InteractivePanel_C:SetInteractiveItemBtnDisplayed(InInteractiveItem, bDisplay)
    if not IsValid(InInteractiveItem.InteractiveInfo) then
        return
    end
    InInteractiveItem.InteractiveInfo:SetBtnDisplayed(UE4.UGameplayStatics.GetPlayerCharacter(self, 0), bDisplay)
end

---@param InInteractiveItem WBP_InteractiveItem_C
function WBP_InteractivePanel_C:OnInteractiveChildRemoved(InInteractiveItem)
    if not IsValid(InInteractiveItem) then
        return
    end
    if not InInteractiveItem.IsPickUpAllItem and not IsValid(InInteractiveItem.InteractiveInfo) then
        return
    end
    local ItemPriorityLevel = InInteractiveItem:GetInteractivePriority()
    if #self.PriorityItemList[ItemPriorityLevel] == 1 then
        self.PriorityItemList[ItemPriorityLevel] = nil
        for i, Level in ipairs(self.PriorityLevelList) do
            if Level == ItemPriorityLevel then
                table.remove(self.PriorityLevelList, i)
                break
            end
        end
    else
        local Index = 0
        for i, v in ipairs(self.PriorityItemList[ItemPriorityLevel]) do
            if v == InInteractiveItem then
                Index = i
                break
            end
        end
        table.remove(self.PriorityItemList[ItemPriorityLevel], Index)
    end
end

function WBP_InteractivePanel_C:InitCapturePanel()
    ---@type WBP_Battle_Capture_C
    local CapturePanel = self.Panel_Capture:GetChildAt(0)
    local IsPC = CommonUtils.GetDeviceTypeByPlatformName(CapturePanel) == "PC"
    local WidgetName = ""
    if IsPC then
        WidgetName = "InteractiveCapturePC"
    else
        WidgetName = "InteractiveCaptureMobile"
    end
    if not CapturePanel then
        CapturePanel = self:CreateWidgetNew(WidgetName)
        CapturePanel.Btn_Capture.OnPressed:Add(self, self.PressedSelectAction)
        CapturePanel.Btn_Capture.OnClicked:Add(self, self.ClickSelectAction)
        CapturePanel.Btn_Capture.OnReleased:Add(self, self.ReleasedSelectAction)
        CapturePanel.IsPC = IsPC
        if not IsPC and CapturePanel.Text_Progress then
            CapturePanel.Text_Progress:SetText(GText("CAPTURE_LONGPRESS"))
            CapturePanel.Text_Percent:SetVisibility(ESlateVisibility.Collapsed)
        end
        self.bPressed = false
        self.Panel_Capture:AddChild(CapturePanel)
    end
    if not CapturePanel then
        return  
    end
    -- if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    --     CapturePanel.Panel_Key:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- end
    CapturePanel.Root:SetRenderOpacity(1)
    if IsPC then
        CapturePanel.Text_Tips:SetText(GText("CAPTURE_LONGPRESS"))
        local CaptureButtonNameIndex = CommonUtils:GetActionMappingKeyName("Interactive")
        local CaptureButtonName = CommonUtils:GetKeyText(CaptureButtonNameIndex)
        CapturePanel.Text_Button:SetText(CaptureButtonName)
        CapturePanel.Key_Controller:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "Y"
                }
            },
            bLongPress = true,
            bButton = true,
        })
        if self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard then
            CapturePanel.WS_Type:SetActiveWidgetIndex(0)
        else
            CapturePanel.WS_Type:SetActiveWidgetIndex(1)
        end
    end
    CapturePanel:UnbindAllFromAnimationFinished(CapturePanel.In)
    CapturePanel:BindToAnimationFinished(CapturePanel.In, 
    { self, function()
        CapturePanel:PlayAnimation(CapturePanel.Loop, 0, 0)
    end
    })
	CapturePanel:PlayAnimation(CapturePanel.In)
    CapturePanel:PauseAnimation(CapturePanel.Loop, 0, 0)
	AudioManager(self):PlayUISound(self, "event:/ui/common/catch_hud_show", nil, nil)
end

function WBP_InteractivePanel_C:TryDoCapture(InteractiveTime)
    ---@type WBP_Battle_Capture_C
    local CapturePanel = self.Panel_Capture:GetChildAt(0)
    if not CapturePanel then
        return  
    end
    if CapturePanel:IsAnimationPlaying(CapturePanel.ProgressTest) then
        return
    end
    if not CapturePanel.IsPC and CapturePanel.Text_Progress then
        if CapturePanel.SpendTime and CapturePanel.SpendTime <=0 then
            CapturePanel.TotalTime = InteractiveTime
            CapturePanel.SpendTime = 0.001
            DebugPrint("WPSWPSWPS")
            CapturePanel:StartCapture()
            self:AddTimer(0.1,function ()
                if not IsValid(CapturePanel) then return end
                CapturePanel.SpendTime = CapturePanel.SpendTime + 0.1
                local Percent = math.floor((CapturePanel.SpendTime/InteractiveTime)*100)
                CapturePanel.Text_Progress:SetText(Percent)
                CapturePanel.Text_Percent:SetVisibility(ESlateVisibility.Visibility)
            end,true,0,"MobileCaptureUpdateText")
        end
        return
    end
    local Speed =  CapturePanel.ProgressTest:GetEndTime() / InteractiveTime
    CapturePanel:PlayAnimation(CapturePanel.ProgressTest, 0, 0, EUMGSequencePlayMode.Forward, Speed, false)
end

function WBP_InteractivePanel_C:OnCaptureSuccess()
    ---@type WBP_Battle_Capture_C
    local CapturePanel = self.Panel_Capture:GetChildAt(0)
    if not CapturePanel then
        return  
    end
    if CapturePanel:IsAnimationPlaying(CapturePanel.Success) then
        return
    end
    CapturePanel:UnbindAllFromAnimationFinished(CapturePanel.Success)
    CapturePanel:BindToAnimationFinished(CapturePanel.Success, 
    { self,
    function()
        self.WidgetSwitcher:SetActiveWidget(self.Panel_Interactive)
    end })
    self:StopAllAnimations()
    CapturePanel:PlayAnimation(CapturePanel.Success)
    if not CapturePanel.IsPC then
        self:RemoveTimer("MobileCaptureUpdateText")
    end
    self:StopCapture()
end

function WBP_InteractivePanel_C:StopCapture()
    ---@type WBP_Battle_Capture_C
    local CapturePanel = self.Panel_Capture:GetChildAt(0)
    if not CapturePanel then
        return  
    end
    CapturePanel:StopAnimation(CapturePanel.ProgressTest)
    if not CapturePanel.IsPC and CapturePanel.Text_Progress then
        CapturePanel.Text_Progress:SetText(GText("CAPTURE_LONGPRESS"))
        CapturePanel.Text_Percent:SetVisibility(ESlateVisibility.Collapsed)
        CapturePanel.TotalTime = 0
        CapturePanel.SpendTime = -1
        CapturePanel:StopCapture()
        self:RemoveTimer("MobileCaptureUpdateText")
    end
end

function WBP_InteractivePanel_C:UpdateInteractiveItemState(InteractiveComponent)
    for i = 0, self.ScrollBox_Interactive:GetChildrenCount() - 1 do
        ---@type WBP_InteractiveItem_C
        local InteractiveItem = self.ScrollBox_Interactive:GetChildAt(i)
        if InteractiveItem.InteractiveInfo == InteractiveComponent then
            InteractiveItem:UpdateInteractiveItemState()
            break
        end
    end
end
-------------------------------输入设备相关--------------------------
function WBP_InteractivePanel_C:UpdateMouseGamePadImage(CurGamepadName)
    -- 手柄资源选择按键图片
    local ResourceIconPath = UIUtils.UtilsGetKeyIconPathInGamepad("Vertical", CurGamepadName)
    -- self:SetMouseImgByPath(ResourceIconPath)
    rawset(self, "LoadResourceID", nil)
    local Handle = UE4.UResourceLibrary.LoadObjectAsyncWithId(self, ResourceIconPath, {self, WBP_InteractivePanel_C.OnInteractiveTipIconLoadFinished})
    if Handle then
        rawset(self, "LoadResourceID", Handle.ResourceID)
    end
    local CapturePanel = self.Panel_Capture:GetChildAt(0)
    if CapturePanel then
        CapturePanel.WS_Type:SetActiveWidgetIndex(1)
    end
end

function WBP_InteractivePanel_C:OnInteractiveTipIconLoadFinished(Object, ResourceID)
    if not Object or rawget(self, "LoadResourceID") ~= ResourceID then
        return
    end
    self.Img_Mouse:SetBrushFromTexture(Object)
end

return WBP_InteractivePanel_C

