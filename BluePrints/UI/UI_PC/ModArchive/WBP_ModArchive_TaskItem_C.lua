--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local WBP_ModArchive_TaskItem_C = Class({"BluePrints.UI.BP_UIState_C", "BluePrints.Common.DelayFrameComponent"})

function WBP_ModArchive_TaskItem_C:OnListItemObjectSet(ListItemObject)
    ListItemObject.SelfWidget = self
    self.Content = ListItemObject
    self.Owner = self.Content.Owner
    self.TaskInfo = self.Content.TaskInfo
    self.InAnimFinished = false
    if self.Content.TaskDoNotInAnim then
        self:OnInAnimFinished()
    else
        self:PlayAnimation(self.In)
        self:BindToAnimationFinished(self.In, {self, self.OnInAnimFinished})
    end

    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()

    self:RefreshList()
    --self.Content.Owner:OnItemAdded(self.Content.Index)

    self:OnFocusLostNew()

    -- if self.Content.Index == 1 and self.Owner and not self.Owner.TitleItem.IsHovering and self.Owner:HasAnyUserFocus() then
    --     self:SetFocus()
    -- end
end

function WBP_ModArchive_TaskItem_C:RefreshList()
    self:InitTaskItem()
end

function WBP_ModArchive_TaskItem_C:InitTaskItem()
    -- 上方展示信息
    self.Text_Title:SetText(GText(self.TaskInfo.TaskName))
    self.Text_TitleNum:SetText(GText(self.TaskInfo.DisplayId))
    self.Text_Desc:SetText(GText(self.TaskInfo.TaskDes))

    -- 根据是否完成设置背景
    if self.TaskInfo.Complete and self.TaskInfo.RewardsGot then
        self.Group_EndBG:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Group_EndBG:SetVisibility(ESlateVisibility.Hidden)
    end

    -- "奖励预览"Text
    self.Text_TaskRewards:SetText(GText("UI_ModGuideBook_RewardView"))

    -- 奖励预览手柄键
    -- if self.CurInputDeviceType and self.CurInputDeviceType == ECommonInputType.GamePad then
    --     self.Key_Rewards:CreateCommonKey({
    --         KeyInfoList={
    --             {
    --                 Type = "Img",
    --                 ImgShortPath = "LS",
    --             }
    --         }
    --     })
    -- end
    if self.Key_Rewards then
        self.Key_Rewards:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "LS",
                }
            }
        })
    end

    -- 最下方Button的显示情况
    if self.TaskInfo.Complete and not self.TaskInfo.RewardsGot then
        self.WS_Bottom:SetActiveWidgetIndex(3)
        self.Btn_Reward:SetText(GText("UI_Achievement_GetReward"))
        self.Btn_Reward:UnBindEventOnClickedByObj(self)
        self.Btn_Reward:BindEventOnClicked(self, self.OnClickGetReward)
        self.Btn_Reward:SetDefaultGamePadImg("X")
    elseif self.TaskInfo.Complete and self.TaskInfo.RewardsGot then
        self.WS_Bottom:SetActiveWidgetIndex(2)
        self.Text_Got:SetText(GText("UI_Finished"))

    elseif self.TaskInfo.TaskType == "Collect" then
        self.WS_Bottom:SetActiveWidgetIndex(1)
    else
        self.WS_Bottom:SetActiveWidgetIndex(0)
        self.Btn_Build:SetText(GText("UI_GameEvent_EventPortal_Goto"))
        self.Btn_Build:UnBindEventOnClickedByObj(self)
        self.Btn_Build:BindEventOnClicked(self, self.OnClickJumpTo)
        -- self.Btn_Build:SetGamePadVisibility(true)
    end


    -- 根据是否完成设置奖励物品情况
    self.ListView_Rewards.BP_OnEntryInitialized:Clear()
    self.ListView_Rewards.BP_OnEntryInitialized:Add(self, self.OnEntryInitialized)
    self.ListView_Rewards:ClearListItems()
    local Rewards = {}
    for i = 1, #self.TaskInfo.TaskReward do
        local Reward = DataMgr.Reward[self.TaskInfo.TaskReward[i]]
        for j, ResourceId in ipairs(Reward.Id) do
            local Info = {}
            local ItemData = DataMgr[Reward.Type[j]][ResourceId]
            Info.Id = ResourceId
            Info.Count = Reward.Count[j][1]
            Info.ItemName = ItemData.ResourceName
            -- Info.ItemType = Reward.Type[j]:gsub("^%l",string.upper)
            Info.ItemType = "Resource"
            Info.Rarity = ItemData.Rarity or ItemData.WeaponRarity or 1
            Info.Icon = ItemData.Icon
            Info.IsShowDetails = true
            table.insert(Rewards, Info)
        end
    end

    self:SortRewardsArray(Rewards)
    for i = 1, #Rewards do
        local Content =  NewObject(UIUtils.GetCommonItemContentClass())
        Content.Id = Rewards[i].Id
        Content.Count = Rewards[i].Count
        -- Content.ItemName = Rewards[i].ItemName
        Content.Icon = Rewards[i].Icon
        Content.Rarity = Rewards[i].Rarity
        Content.IsShowDetails = Rewards[i].IsShowDetails
        Content.ItemType = Rewards[i].ItemType
        Content.bHasGot = self.TaskInfo.Complete and self.TaskInfo.RewardsGot
        Content.AfterInitCallback = function(Widget)
            Widget:BindEvents(self, {
                OnMenuOpenChanged = self.OnTipsOpenChanged,
            })
        end
        Content.OnMouseButtonUpEvents = {
            Obj = self,
            Callback = self.OnClickItem,
            Params = {}
        }
        self.ListView_Rewards:AddItem(Content)
    end


    self.List_Reward:ClearChildren()
    if self.TaskInfo.TaskType == "Jump" then

    elseif self.TaskInfo.TaskType == "Collect" then
        -- 收集Mod任务情况
        local TargetMods = {}
        self.Mods = {}
        local CompleteNum = 0 --记录已收集完成的个数
        self.ModNum = #self.TaskInfo.CollectTaskTypeParam
        for i = 1, self.ModNum do
            local ModId = self.TaskInfo.CollectTaskTypeParam[i]
            local ModInfo = DataMgr.Mod[self.TaskInfo.CollectTaskTypeParam[i]]
            if self.TaskInfo.ModStates[ModId] then
                CompleteNum = CompleteNum + 1
            end
            local Content = {
                Id = ModId,
                Rarity = ModInfo.Rarity,
                Icon = ModInfo.Icon,
                -- ItemName = ModInfo.Name,
                ItemType = "Mod",
                IsShowDetails = true,
                HandleMouseDown = true,
                AfterInitCallback = function(Widget)
                    -- 设置每个中间展示栏的Mod拥有情况
                    Widget.WS:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                    if self.TaskInfo.ModStates[Widget.Content.Id] or self.TaskInfo.Complete then
                        -- 已有
                        Widget.WS:SetActiveWidgetIndex(1)
                    else
                        -- 没有
                        Widget.WS:SetActiveWidgetIndex(0)
                    end
                    Widget:BindEvents(self, {
                        OnMenuOpenChanged = self.OnTipsOpenChanged,
                    })
                end
            }
            self.Mods[ModId] = self:CreateWidgetNew("ModArchiveTaskSubItem")
            self.List_Reward:AddChild(self.Mods[ModId])
            self.Mods[ModId]:Init(Content)
            self.Mods[ModId]:SetNavigationRuleCustom(EUINavigation.Left, {self, self.OnNavigateLeft})
            self.Mods[ModId]:SetNavigationRuleCustom(EUINavigation.Right, {self, self.OnNavigateRight})
            self.Mods[ModId]:SetNavigationRuleCustom(EUINavigation.Up, {self, self.OnNavigateUp})
            self.Mods[ModId]:SetNavigationRuleCustom(EUINavigation.Down, {self, self.OnNavigateDown})

            -- 设置Mod导航
            -- local test0 = self.List_Reward:GetChildAt(0)
            -- test0:SetNavigationRuleCustom(EUINavigation.Right, {self, self.OnNavigateRight})

            
        end
        self.Text_Progressing:SetText(GText("UI_ModGuideBook_Task_Collecting") .. " (" .. CompleteNum .. "/" .. #self.TaskInfo.CollectTaskTypeParam .. ")")
        
        -- 有Mod预览栏的情况下，设置奖励栏的导航规则， 向上可以导到Mod预览栏
        self.ListView_Rewards:SetNavigationRuleCustom(EUINavigation.Up, {self, self.OnRewardNavigateUp})
    end

    -- 添加一下奖励栏聚焦事件，控制手柄键的显隐
    -- self.ListView_Rewards:BindEvents(self,{
    --     OnAddedToFocusPath = self.OnRewardsAddedToFocusPath,
    --     OnRemovedFromFocusPath = self.OnRewardsRemovedFromFocusPath
    -- })
    -- self.ListView_Rewards:BindEventOnAddedToFocusPath(self,self.OnRewardsAddedToFocusPath)
    -- self.ListView_Rewards:BindEventOnRemovedFromFocusPath(self,self.OnRewardsRemovedFromFocusPath)
end

-- 点击跳转
function WBP_ModArchive_TaskItem_C:OnClickJumpTo()
    if self.TaskInfo.Complete or self.TaskInfo.TaskType == "Collect" then return end
    PageJumpUtils:JumpToTargetPageByJumpId(self.TaskInfo.JumpTaskTypeParam[1])
end

-- 排序
function WBP_ModArchive_TaskItem_C:SortRewardsArray(RewardsArray)
    -- 排序优先级：稀有度、类型、Id、额外奖励、数量
    table.sort(RewardsArray, function(a, b)
        if a.Rarity ~= b.Rarity then
            return a.Rarity > b.Rarity
        end
        if a.Id ~= b.Id then
            return a.Id > b.Id
        end
        if a.Count ~= b.Count then
            return a.Count > b.Count
        end
        return false
    end)
end

function WBP_ModArchive_TaskItem_C:OnTipsOpenChanged(bIsOpen)
    DebugPrint("zwkkk OnTipsOpenChanged", bIsOpen, self:GetName())
    self.Owner:OnTipsOpenChanged(bIsOpen, self)
    if self.CurInputDeviceType ~= ECommonInputType.GamePad then
        return
    end
    if bIsOpen then
        -- -- 需要隐藏按钮的手柄键
        -- self.Btn_Build:SetGamePadVisibility(ESlateVisibility.Collapsed)
        DebugPrint("zw1234 OnTipsOpenChanged Collapsed")
        self.Key_Rewards:SetVisibility(ESlateVisibility.Collapsed)
    else
        -- -- 需要显示按钮的手柄键
        -- if self.Owner and self.Owner.SelectItem and self.Owner.SelectItem.SelfWidget == self then
        --     self.Btn_Build:SetGamePadVisibility(ESlateVisibility.SelfHitTestInvisible)
        -- end
        if not self.ListView_Rewards:HasFocusedDescendants() then
            self.Key_Rewards:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
    end
end

-- 领取奖励
function WBP_ModArchive_TaskItem_C:OnClickGetReward()
    local Avatar = GWorld:GetAvatar()
    local CallBack = function(ErrCode, Reward)
        if ErrorCode:Check(ErrCode) then
            local ItemPage = UIManager(self):LoadUINew("GetItemPage", nil, nil, nil, Reward)
            -- ItemPage:BindActionOnClosed(self.ReturnReward, self)

            self.TaskInfo.RewardsGot = true
            self:SetReward()
            self.Owner:CheckAllRewardBtnState()
            self.Owner.Owner:RefreshReddot()
        end
    end

    Avatar:ModBookQuestGetReward(self.TaskInfo.TaskId, CallBack)
end

function WBP_ModArchive_TaskItem_C:SetReward()
    self:InitTaskItem()
end

-- 交互相关
function WBP_ModArchive_TaskItem_C:OnMouseEnter(MyGeometry, MouseEvent)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/hover_btn_large", nil, nil)
    if self.InAnimFinished then
        self:StopAllAnimations()
        self:PlayAnimation(self.Hover)
    end
    self.IsHovering = true
    if self.Owner then
        self.Owner.CurWidget = self
    end
    DebugPrint("zwkkk Hover")
end

function WBP_ModArchive_TaskItem_C:OnMouseLeave(MyGeometry, MouseEvent)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end
    -- if self.IsSelected then
    --     return
    -- end
    if self.InAnimFinished then
        self:StopAllAnimations()
        self:PlayAnimation(self.UnHover)
    end
    self.IsHovering = false
    DebugPrint("zwkkk UnHover")
end

function WBP_ModArchive_TaskItem_C:OnClickItem()
    DebugPrint("zwkkk OnClickItem")
end

-- 跳转或领奖
function WBP_ModArchive_TaskItem_C:OnStartJumpOrReward()
    if self.WS_Bottom:GetActiveWidgetIndex() == 3 then
        self.Btn_Reward:StopAllAnimations()
        self.Btn_Reward:PlayAnimation(self.Btn_Reward.Normal)
        self:OnClickGetReward()
    elseif self.WS_Bottom:GetActiveWidgetIndex() == 0 then
        self.Btn_Build:StopAllAnimations()
        self.Btn_Build:PlayAnimation(self.Btn_Build.Normal)
        self:OnClickJumpTo()
    end
end

function WBP_ModArchive_TaskItem_C:OnGamePadSelected()
    self:SetFocus()
    DebugPrint("zwkkk OnGamePadSelected")
    if self.List_Reward:GetChildrenCount() > 0 then
        DebugPrint("zwkkk 魔之楔Item被聚焦了")
        self.List_Reward:GetChildAt(0):SetFocus()
        self.SelectedModIndex = 0
    else
        DebugPrint("zwkkk 按理来说应该进到奖励栏了",self.RewardIdSelected)
        -- if self.ListView_Rewards:HasAnyUserFocus() then
        --     self.ListView_Rewards:BP_GetNumItemsSelected()
        --     DebugPrint("zwkkkk 进来的时候还没focus就有选中的 ",self.ListView_Rewards:BP_GetNumItemsSelected())
        -- end
        -- self.ListView_Rewards:BP_ClearSelection()
        -- self.ListView_Rewards:SetSelectedIndex(self.RewardIdSelected)
        self.ListView_Rewards:SetFocus()
        self:OnRewardsAddedToFocusPath()
    end

    -- self.Btn_Build:SetGamePadVisibility(ESlateVisibility.Collapsed)
    self.IsSelected = true
end

function WBP_ModArchive_TaskItem_C:OnGamePadUnSelected()
    DebugPrint("zwkkkk OnGamePadUnSelected", self.ListView_Rewards:HasAnyUserFocus())
    -- self.RewardIdSelected = self.ListView_Rewards:BP_GetNumItemsSelected()
    self.ListView_Rewards:BP_ClearSelection()
    -- if self.ListView_Rewards:HasAnyUserFocus() then
    --     self.ListView_Rewards:BP_GetNumItemsSelected()
    --     DebugPrint("zwkkkk OnGamePadUnSelected ",self.ListView_Rewards:BP_GetNumItemsSelected())
    -- end

    self.Key_Rewards:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.IsSelected = false
end

function WBP_ModArchive_TaskItem_C:OnEntryInitialized(Item, Widget)
    Widget.WidgetMap = nil
end

function WBP_ModArchive_TaskItem_C:OnFocusReceived(MyGeometry, InFocusEvent)
    DebugPrint("zwkkk12 获得聚焦")
    self.InFocus = true
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        if self.Owner and self.Owner.Owner and self.Owner.Owner.CurTipsIndex ~= 3 then
            self.Owner.Owner:SwitchComKeyTipsState(3)
        end
    end
    -- if self.IsHovering then
    --     self.owner:
    -- end
    -- if self.Owner and self.Owner.CurWidget == self then
    --     self:OnFocusNew()
    -- end
    -- self:AddDelayFrameFunc(function()
    --     self:OnFocusNew()
    -- end, 2, "Test")
end

function WBP_ModArchive_TaskItem_C:OnFocusLost(InFocusEvent)
    DebugPrint("zwkkk12 失去聚焦")
    self.InFocus = false
    -- if not self:HasAnyUserFocus() then
    --     self:OnFocusLostNew()
    -- end
    if not self:HasFocusedDescendants() then
        self:OnFocusLostNew()
    end
end

function WBP_ModArchive_TaskItem_C:OnInAnimFinished()
    self.InAnimFinished = true
    if self:HasAnyUserFocus() then
        self:OnFocusNew()
    end
    if self.IsHovering then
        self:PlayAnimation(self.Hover)
    end
end

function WBP_ModArchive_TaskItem_C:OnAddedToFocusPath(InFocusEvent)
    DebugPrint("zwkkk1234 OnAddedToFocusPath")
    if self.CurInputDeviceType and self.CurInputDeviceType == ECommonInputType.GamePad then
        self.Btn_Build:SetGamePadVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Reward:SetGamePadVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Key_Rewards:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

function WBP_ModArchive_TaskItem_C:OnRemovedFromFocusPath(InFocusEvent)
    DebugPrint("zwkkk1234 OnRemovedFromFocusPath")
    if self.CurInputDeviceType and self.CurInputDeviceType == ECommonInputType.GamePad then
        self.Btn_Build:SetGamePadVisibility(ESlateVisibility.Collapsed)
        self.Btn_Reward:SetGamePadVisibility(ESlateVisibility.Collapsed)
        self.Key_Rewards:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_ModArchive_TaskItem_C:RefreshInputDeviceType()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
end

-- 外层选中它，显示装配手柄按键和查看详情按键
function WBP_ModArchive_TaskItem_C:OnFocusNew()
    DebugPrint("zw123 OnFocusNew ", self.CurInputDeviceType,self.CurInputDeviceType == ECommonInputType.GamePad, self.Owner)
    if self.CurInputDeviceType and self.CurInputDeviceType == ECommonInputType.GamePad then
        -- self:AddDelayFrameFunc(function()
        --     self.Btn_Build:SetGamePadVisibility(ESlateVisibility.SelfHitTestInvisible)
        --     DebugPrint("zw1234 OnFocusNew SelfHitTestInvisible")
        --     self.Key_Rewards:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        -- end, 5, "OnFocusNew")
        self.Btn_Build:SetGamePadVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Reward:SetGamePadVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Key_Rewards:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end


function WBP_ModArchive_TaskItem_C:OnFocusLostNew()
    if self.CurInputDeviceType and self.CurInputDeviceType == ECommonInputType.GamePad then
        self.Btn_Build:SetGamePadVisibility(ESlateVisibility.Collapsed)
        self.Btn_Reward:SetGamePadVisibility(ESlateVisibility.Collapsed)
        self.Key_Rewards:SetVisibility(ESlateVisibility.Collapsed)
    end
end

-- Mod栏中的Item导航相关
function WBP_ModArchive_TaskItem_C:OnNavigateLeft()
    if self.SelectedModIndex <= 0 then return end
    if self.SelectedModIndex % 4 > 0 then
        -- 左边可以走
        self.SelectedModIndex = self.SelectedModIndex - 1
        self.List_Reward:GetChildAt(self.SelectedModIndex):SetFocus()
        return self.List_Reward:GetChildAt(self.SelectedModIndex)
    end
    return
end

function WBP_ModArchive_TaskItem_C:OnNavigateRight()
    if self.SelectedModIndex < 0 then return end
    if self.SelectedModIndex == self.ModNum - 1 then return end
    if self.SelectedModIndex % 4 < 3 then
        -- 右边可以走
        self.SelectedModIndex = self.SelectedModIndex + 1
        self.List_Reward:GetChildAt(self.SelectedModIndex):SetFocus()
        return self.List_Reward:GetChildAt(self.SelectedModIndex)
    end
    return
end

function WBP_ModArchive_TaskItem_C:OnNavigateUp()
    if self.SelectedModIndex < 4 then return end
    -- 上边可以走
    self.SelectedModIndex = self.SelectedModIndex - 4
    self.List_Reward:GetChildAt(self.SelectedModIndex):SetFocus()
    return self.List_Reward:GetChildAt(self.SelectedModIndex)
end

function WBP_ModArchive_TaskItem_C:OnNavigateDown()
    if self.SelectedModIndex < 0 then return end
    if self.SelectedModIndex > self.ModNum - 5 then
        -- 导到奖励栏
        self.SelectedModIndex = -1
        self.ListView_Rewards:SetFocus()
        self:OnRewardsAddedToFocusPath()
        return
    end
    -- 导到下面一格
    self.SelectedModIndex = self.SelectedModIndex + 4
    self.List_Reward:GetChildAt(self.SelectedModIndex):SetFocus()
    return self.List_Reward:GetChildAt(self.SelectedModIndex)
end

-- 奖励栏导航相关（向上可以导到Mod预览栏）
function WBP_ModArchive_TaskItem_C:OnRewardNavigateUp()
    self.SelectedModIndex = 0
    self:OnRewardsRemovedFromFocusPath()
    return self.List_Reward:GetChildAt(self.SelectedModIndex)
end

function WBP_ModArchive_TaskItem_C:OnRewardsAddedToFocusPath()
    self.FocusInRewards = true
    if self.CurInputDeviceType ~= ECommonInputType.GamePad then
        return
    end
    self.Key_Rewards:SetVisibility(ESlateVisibility.Collapsed)
    self.Btn_Build:SetGamePadVisibility(ESlateVisibility.Collapsed)
    self.Btn_Reward:SetGamePadVisibility(ESlateVisibility.Collapsed)
end

function WBP_ModArchive_TaskItem_C:OnRewardsRemovedFromFocusPath()
    self.FocusInRewards = false
    if self.CurInputDeviceType ~= ECommonInputType.GamePad then
        return
    end
    self.Key_Rewards:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Build:SetGamePadVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Reward:SetGamePadVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function WBP_ModArchive_TaskItem_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    DebugPrint("zwkkk   RefreshOpInfoByInputDevice ", CurInputDevice, CurGamepadName, self:GetName())
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName

    self:UpdateOnInputDeviceTypeChange()
end

function WBP_ModArchive_TaskItem_C:UpdateOnInputDeviceTypeChange()
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        if self:HasAnyUserFocus() or self.List_Reward:HasFocusedDescendants() then
            DebugPrint("zwjkjkkj ", self:GetName())
            self.Btn_Build:SetGamePadVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Btn_Reward:SetGamePadVisibility(ESlateVisibility.SelfHitTestInvisible)
            if self.Key_Rewards then
                self.Key_Rewards:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            end
            -- if not self.ListView_Rewards:HasAnyUserFocus() then
            --     self.Btn_Build:SetGamePadVisibility(ESlateVisibility.Collapsed)
            --     self.Key_Rewards:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            -- end
        else
            self:AddDelayFrameFunc(function()
                self.Btn_Build:SetGamePadVisibility(ESlateVisibility.Collapsed)
                self.Btn_Reward:SetGamePadVisibility(ESlateVisibility.Collapsed)
                if (self.Owner.CurWidget and self.Owner.CurWidget == self) and not self.ListView_Rewards:HasFocusedDescendants() then
                    self.Btn_Build:SetGamePadVisibility(ESlateVisibility.SelfHitTestInvisible)
                    self.Btn_Reward:SetGamePadVisibility(ESlateVisibility.SelfHitTestInvisible)
                    if self.Key_Rewards then
                        self.Key_Rewards:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                    end
                end
            end, 1, "CollapseBtn")
        end
        if self.List_Reward:HasFocusedDescendants() or self.ListView_Rewards:HasFocusedDescendants() then
            self.Owner.Owner:SwitchComKeyTipsState(2)
        end
    elseif self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard then
        -- PC
        if self.Key_Rewards then
            DebugPrint("zw1234 UpdateOnInputDeviceTypeChange Collapsed")
            self.Key_Rewards:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
end



return WBP_ModArchive_TaskItem_C
