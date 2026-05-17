--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local EMCache = require "EMCache.EMCache"

local WBP_ModArchive_Archive_Item_C = Class({"BluePrints.UI.BP_UIState_C"})

function WBP_ModArchive_Archive_Item_C:Construct()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
end

function WBP_ModArchive_Archive_Item_C:OnListItemObjectSet(ListItemObject)
    ListItemObject.SelfWidget = self
    self.Info = ListItemObject
    self.Owner = self.Info.Owner
    self:PlayAnimation(self.In)
    -- DebugPrint("zwkk 添加了一个item",self.Info.TabId,GWorld:GetCurrentTime())
    self.Text_ArchiveTitle:SetText(GText(self.Info.Name))
    -- self.CurSelectedItem = nil
    self.CurSelectedItem = nil
    self.Owner:UpdateListWidgets(self)
    DebugPrint("zwkkkkkkk 现在的Index ", self.Info.Index, #self.Info.ModList)
    -- 集齐该系列魔之楔共可获得%d历练经验文本提示
    local Exp = 0
    for i = 1, #self.Info.ModList do
        local Info = DataMgr.Mod[self.Info.ModList[i]]
        if Info and Info.CollectRewardExp then
            Exp = Exp + Info.CollectRewardExp
        end
    end
    self.Text_ExpHint:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Text_ExpHint:SetText(string.format(GText("UI_ModArchive_TotalExpReward"), tostring(Exp)))


    if self.Key_TitleReward then
        self.Key_TitleReward:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "LS",
                },
            },
            -- Desc = GText("UI_Controller_CheckReward")
            Desc = ""
        })
    end
    if self.Key_TitleReward then
        self.Key_TitleReward:SetVisibility(ESlateVisibility.Collapsed)
    end
    
    -- 判断未揭晓或未解锁
    self.LockState = 1  --1 解锁   2 未揭晓   3 未解锁
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        if (self.Info.ShowCondition and not ConditionUtils.CheckCondition(Avatar, self.Info.ShowCondition)) then
            self.LockState = 2
        elseif (self.Info.UnlockCondition and not ConditionUtils.CheckCondition(Avatar, self.Info.UnlockCondition)) then
            self.LockState = 3
        end
    end

    self:InitListMod()
    self:SetReward()

    self.List_Item:DisableScroll(true)
end

-- 添加Mod
function WBP_ModArchive_Archive_Item_C:InitListMod()
    -- DebugPrint("zwkk self.LockState",self.LockState)
    self.List_Item.BP_OnEntryInitialized:Clear()
    self.List_Item.BP_OnEntryInitialized:Add(self, self.OnEntryInitialized)
    self.List_Item:ClearListItems()
    --self.List_SuitItem:ClearChildren()
    self.Mods = {}
    self.HasModNum = 0
    for i = 1, #self.Info.ModList do
        local ModInfo = DataMgr.Mod[self.Info.ModList[i]]
        -- local Content = {
        --     Id = self.Info.ModList[i],
        --     Rarity = ModInfo.Rarity,
        --     Icon = ModInfo.Icon,
        --     ItemName = "sssdddddddddddddddddddddddddddddddddddddddddddddd",
        --     ItemType = "Mod",
        --     OnMouseButtonUpEvents = {
        --         Obj = self,
        --         Callback = self.OnClickItem,
        --         Params = {ModInfo, i}
        --     }
        -- }
        -- if self.LockState == 1 then
        --     local HasThisMod = self.Owner.HasMod[Content.Id]
        --     Content.bShadow = not HasThisMod
        --     if HasThisMod then
        --         self.HasModNum = self.HasModNum + 1
        --     end
        -- elseif self.LockState == 2 then
        --     -- 未揭晓
        --     Content.bOutline = true
        -- elseif self.LockState == 3 then
        --     -- 未解锁
        --     Content.LockType = 2
        -- end

        -- self.Mods[i] = self:CreateWidgetNew("ModArchiveSuitItem")
        -- self.List_SuitItem:AddChild(self.Mods[i])
        -- self.Mods[i]:Init(Content)
        -- self.Mods[i].bIsFocusable = true
        -- self.Mods[i]:SetIsDealWithVirtualAccept(true)

        local Content =  NewObject(UIUtils.GetCommonItemContentClass())
        Content.Id = self.Info.ModList[i]
        Content.Rarity = ModInfo.Rarity
        Content.Icon = ModInfo.Icon
        Content.ItemName = ModInfo.Name
        Content.ItemType = "Mod"

        -- New标
        -- if self.Info.RedDotNewStates and self.Info.RedDotNewStates[tostring(Content.Id)] then
        --     Content.RedDotType = UIConst.RedDotType.NewRedDot
        -- end
        if self.Info.RedDotNewStates and self.Info.RedDotNewStates[Content.Id] then
            Content.RedDotType = UIConst.RedDotType.NewRedDot
        end

        Content.AfterInitCallback = function(Widget)
            self.Mods[i] = Widget
            if i == 1 and self.Info.Index == 1 and self.Owner.FirstSelected then
                self.Owner:OnGamepadFirstSelect()
                self.Owner:SetTipsInfo(ModInfo, self.LockState)
            else
                Widget.Item:PlayAnimation(Widget.Item.Normal)
            end
            
            Widget.bIsFocusable = true
            Widget:SetIsDealWithVirtualAccept(true)
            Widget:SetNavigationRuleCustom(EUINavigation.Left, {self, self.OnNavigateLeft})
            Widget:SetNavigationRuleCustom(EUINavigation.Right, {self, self.OnNavigateRight})
            Widget:SetNavigationRuleCustom(EUINavigation.Up, {self, self.OnNavigateUp})
            Widget:SetNavigationRuleCustom(EUINavigation.Down, {self, self.OnNavigateDown})

            -- 之前选中的Mod不在窗口中的话，再次出现的时候应该有选中态
            if self.Owner and self.Owner.CurGroupId and self.Owner.CurGroupId == self.Info.Id and self.Owner.CurSelectedItemIndex and self.Owner.CurSelectedItemIndex == i then
                Widget:SetSelected(true)
                self.CurSelectedItem = Widget
            end
        end
        Content.OnMouseButtonUpEvents = {
            Obj = self,
            Callback = self.OnClickItem,
            Params = {ModInfo, i}
        }
        local HasThisMod = self.Owner.HasMod[Content.Id]
        if HasThisMod then
            self.HasModNum = self.HasModNum + 1
        end
        if self.LockState == 1 then
            Content.bShadow = not HasThisMod
        elseif self.LockState == 2 then
            -- 未揭晓
            -- Content.bUnrevealed = true
            Content.bShadow = true
            Content.ItemName = nil
            Content.Icon = '/Game/UI/Texture/Dynamic/Atlas/Prop/Mod/T_ModArchive_Unrevealed.T_ModArchive_Unrevealed'
        elseif self.LockState == 3 then
            -- 未解锁
            Content.LockType = 2
        end
        self.List_Item:AddItem(Content)

    end



    -- -- 导航规则
    -- for i = 1, #self.Mods do
    --     self.Mods[i]:SetNavigationRuleCustom(EUINavigation.Left, {self, self.OnNavigateLeft})
    --     self.Mods[i]:SetNavigationRuleCustom(EUINavigation.Right, {self, self.OnNavigateRight})
    --     self.Mods[i]:SetNavigationRuleCustom(EUINavigation.Up, {self, self.OnNavigateUp})
    --     self.Mods[i]:SetNavigationRuleCustom(EUINavigation.Down, {self, self.OnNavigateDown})
    -- end

    self.Text_ArchiveSuitNum:SetColorAndOpacity(self.Color_Normal)
    self.Text_ArchiveSuitNum:SetText(self.HasModNum .. "/" .. #self.Info.ModList)
    if self.LockState ~= 1 then
        self.Group_Lock:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        -- self.Text_ArchiveSuitNum:SetColorAndOpacity(self.Color_Lock)
        if self.LockState == 2 then
            -- 未揭晓，读Condition表的提示文本
            local Text = DataMgr.Condition[self.Info.ShowCondition].ConditionText
            self.Text_ArchiveSuitLock:SetText(GText(Text))
        elseif self.LockState == 3 then
            -- 未解锁，读Condition表的提示文本
            local Text = DataMgr.Condition[self.Info.UnlockCondition].ConditionText
            self.Text_ArchiveSuitLock:SetText(GText(Text))
        end
    else
        self.Group_Lock:SetVisibility(ESlateVisibility.Collapsed)
        -- self.Text_ArchiveSuitNum:SetColorAndOpacity(self.Color_Normal)
    end
end

-- 点击Mod回调
function WBP_ModArchive_Archive_Item_C:OnClickItem(ModInfo, Index)
    DebugPrint("zwkk OnClickItem", ModInfo.Id, Index)

    self.Owner:OnItemClicked(ModInfo, self.LockState, self.Info.Index, Index, self.Mods[Index], self.Info.Id)
    if self.CurSelectedItem and self.CurSelectedItem == self.Mods[Index] then
        return
    end
    
    self.Owner:PlayAnimation(self.Owner.Switch)
    -- if self.CurInputDeviceType == ECommonInputType.GamePad then
    --     return
    -- end

    if self.CurSelectedItem then
        self.CurSelectedItem:SetSelected(false)
        DebugPrint("zzzzzz self.CurSelectedItem", self.CurSelectedItem:GetName(), self.Mods[Index]:GetName())
    end
    self.CurSelectedItem = self.Mods[Index]
    self.CurSelectedItem:SetSelected(true)
end

-- 同一Tab页下，其他的组中Mod被选中，自己应该取消现在选中的状态
function WBP_ModArchive_Archive_Item_C:OnOtherArchiveItemSelected()
    if self.CurSelectedItem then
        self.CurSelectedItem:SetSelected(false)
        self.CurSelectedItem = nil
    end
end

-- 奖励栏
function WBP_ModArchive_Archive_Item_C:SetReward()
    local RewardInfo = self:GetFirstRewardInfoById(self.Info.RewardId)
    local Content = {
        ParentWidget = self,
        Id = RewardInfo.Id,
        Count = RewardInfo.Count,
        ItemType = RewardInfo.Type,
        Icon = RewardInfo.Icon,
        Rarity = RewardInfo.Rarity or 1,
        IsShowDetails = false,
        HandleMouseDown = true
    }
    local Avatar = GWorld:GetAvatar()
    local bHasGot = Avatar.HoldModRewards[self.Info.Id]
    Content.bHasGot = bHasGot
    local bCanGetReward = self.Owner.CanGetRewardGroups[self.Info.Id]
    if not bHasGot and bCanGetReward then
        Content.bCanGet = true
        Content.RedDotType = UIConst.RedDotType.CommonRedDot
        Content.OnMouseButtonUpEvents = {
            Obj = self,
            Callback = self.OnClickReward
        }
        Content.IsShowDetails = false
    else
        Content.IsShowDetails = true
        Content.AfterInitCallback = function(Widget)
            Widget:BindEvents(self, {
                OnMenuOpenChanged = self.OnTipsOpenChanged,
            })
        end
    end
    if self.Item_Title.WidgetMap then
        self.Item_Title.WidgetMap = nil
    end
    self.Item_Title:Init(Content)
end

-- 判断奖励是否可领取
function WBP_ModArchive_Archive_Item_C:CheckRewardCanGet()
    return self.Owner.CanGetRewardGroups[self.Info.Id]
end



function WBP_ModArchive_Archive_Item_C:OnClickReward()
    local Avatar = GWorld:GetAvatar()
    local CallBack = function(ErrCode, Reward)
        if ErrorCode:Check(ErrCode) then
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Reward, false, function()
                self:ReturnReward()
            end, self, false)
            self.Item_Title:ClearEventOnMouseButtonUp(self)
            -- 重新添加一次Reward
            self:SetReward()

            -- 红点情况
            local ModBookCanGetRewards = EMCache:Get("ModBookCanGetRewards", true)
            -- if ModBookCanGetRewards and ModBookCanGetRewards[tostring(self.Info.Id)] then
            --     ModBookCanGetRewards[tostring(self.Info.Id)] = false
            -- end
            if ModBookCanGetRewards and ModBookCanGetRewards[self.Info.Id] then
                ModBookCanGetRewards[self.Info.Id] = false
                local ReddotNode = DataMgr.ModGuideBookArchiveTab[self.Owner.CurTab].ReddotNode
                local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotNode)
                if CacheDetail.RedNum then
                    CacheDetail.RedNum = CacheDetail.RedNum - 1
                end
                ReddotManager.DecreaseLeafNodeCount(ReddotNode, 1, CacheDetail)
                if CacheDetail.RedNum <= 0 then
                    if CacheDetail.NewNum and CacheDetail.NewNum > 0 then
                        self.Owner.ArchiveTab:ShowTabRedDot(self.Owner.CurTab, true, false)
                    else
                        self.Owner.ArchiveTab:ShowTabRedDot(self.Owner.CurTab, false, false)
                    end
                end
            end
            EMCache:Set("ModBookCanGetRewards", ModBookCanGetRewards, true)
            self.Owner.Owner:RefreshDot()

            -- 刷新一次Owner全部领取按钮的状态
            self.Owner.CanGetRewardGroups[self.Info.Id] = false
            self.Owner:RefreshBtnRewardState()
            if self.CurInputDeviceType == ECommonInputType.GamePad then
                self.Owner.Owner:SwitchComKeyTipsState(3)
            end
        end
    end

    Avatar:GetModGuideBookArchiveReward(self.Info.Id, CallBack)


    -- self.Item_Title:ClearEventOnMouseButtonUp(self)
end

-- 从奖励弹窗回来，重新聚焦
function WBP_ModArchive_Archive_Item_C:ReturnReward()
    -- if self.Owner and self.Owner.CurItemWidget then
    --     self.Owner.CurItemWidget:SetFocus()
    -- end
    if self.CurInputDeviceType == ECommonInputType.GamePad and self.Item_Title:HasAnyUserFocus() then
        self.Owner.Owner:SwitchComKeyTipsState(2)
    end
end


function WBP_ModArchive_Archive_Item_C:GetRewards()
    DebugPrint("zwjkijki OnClickReward", self.Info.Id)
    local Avatar = GWorld:GetAvatar()
    if not Avatar.HoldModRewards[self.Info.Id] then
        return
    end
    -- 
end

function WBP_ModArchive_Archive_Item_C:GetFirstRewardInfoById(RewardId)
	local RewardInfo = {}
	local RewardData = DataMgr.Reward[RewardId]
	if not RewardData then
		return RewardInfo
	end
	local RewardTypes = RewardData.Type
	local RewardIds = RewardData.Id
    local RewardCounts = RewardData.Count
	if not RewardTypes or not RewardIds or not RewardCounts then
		return RewardInfo
	end
    RewardInfo.Type = RewardTypes[1]
    RewardInfo.Id = RewardIds[1]
    RewardInfo.Count = RewardCounts[1][1]
    local ItemInfo = DataMgr[RewardInfo.Type][RewardInfo.Id]
    if ItemInfo then
        RewardInfo.Name = ItemInfo.Name or ItemInfo[RewardInfo.Type.."Name"]
        RewardInfo.Rarity = ItemInfo.Rarity or ItemInfo[RewardInfo.Type.."Rarity"]
        RewardInfo.Icon = ItemInfo.Icon or ItemInfo[RewardInfo.Type.."Icon"]
    end
	return RewardInfo
end

function WBP_ModArchive_Archive_Item_C:SetItemSelected(Index)
    DebugPrint("zwkkk SetItemSelected", Index)
    local ModInfo = DataMgr.Mod[self.Info.ModList[Index]]
    if self.Mods[Index] then
        DebugPrint("zwkkkkk ModInfo",GText(ModInfo.Name))
        self:OnClickItem(ModInfo, Index)
        -- self.Owner:OnItemClicked(ModInfo, self.LockState, self.Info.Index, Index)
        -- if self.CurSelectedItem then
        --     self.CurSelectedItem:SetSelected(false)
        -- end
        -- self.CurSelectedItem = self.Mods[Index]
        -- self.CurSelectedItem:SetSelected(true)
    end
end

function WBP_ModArchive_Archive_Item_C:SetRewardTextVisibility(Show)
    if (self.CurInputDeviceType ~= ECommonInputType.GamePad) then return end
    if Show then
        self.Key_TitleReward:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Key_TitleReward:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_ModArchive_Archive_Item_C:OnTipsOpenChanged(bIsOpen)
    DebugPrint("zwkkk OnTipsOpenChanged", bIsOpen, self:GetName())
    self.Owner:OnTipsOpenChanged(bIsOpen, self)
end

function WBP_ModArchive_Archive_Item_C:OnEntryInitialized(Item, Widget)
    if Widget and Widget.WidgetMap and Widget.WidgetMap[Widget.NameWidget] and Item and Item.ItemName == nil then
        Widget:RemoveWidgetFromNode(Widget.NameWidget)
        Widget:ClearBackGroundHeight(true)
    end
end



-- Mod栏中的Item导航相关
function WBP_ModArchive_Archive_Item_C:OnNavigateLeft()
    DebugPrint("zwkkkkkk OnNavigateLeft")
    if not self.Owner then return end
    local CurSelectedItemIndex = self.Owner.CurSelectedItemIndex - 1
    if CurSelectedItemIndex % 10 <= 0 then return end
    -- 可以向左走
    self:SetItemSelected(CurSelectedItemIndex)
    self.Mods[CurSelectedItemIndex]:SetFocus()
    return
end

function WBP_ModArchive_Archive_Item_C:OnNavigateRight()
    DebugPrint("zwkkkkkk OnNavigateRight")
    if not self.Owner then return end
    local CurSelectedItemIndex = self.Owner.CurSelectedItemIndex
    if CurSelectedItemIndex % 10 <= 0 then return end
    if CurSelectedItemIndex + 1 > #self.Mods then return end
    -- 可以向右走
    self:SetItemSelected(CurSelectedItemIndex + 1)
    self.Mods[CurSelectedItemIndex + 1]:SetFocus()
    return
end

function WBP_ModArchive_Archive_Item_C:OnNavigateUp()
    DebugPrint("zwkkkkkk OnNavigateUp")
    if not self.Owner then return end
    local CurSelectedItemIndex = self.Owner.CurSelectedItemIndex - 10
    if CurSelectedItemIndex <= 0 then
        -- 判断上一层能不能走
        local GroupIndex = self.Owner.CurGroupIndex
        local PreGroupIndex = GroupIndex - 1
        local Item = self.Owner.List_ModArchive:GetItemAt(PreGroupIndex - 1)
        local Widget = self.Owner.Widgets[PreGroupIndex]
        if Widget and Widget.Info and Widget.Info.ModList then
            -- 判断上一层有没有对齐的，没有就选到最右边那个
            local Index = self.Owner.CurSelectedItemIndex % 10
            local TenNum = math.floor(#self.Owner.GroupInfo[PreGroupIndex].ModList / 10)
            local LastRowNum = #self.Owner.GroupInfo[PreGroupIndex].ModList % 10
            -- DebugPrint("tttttt ", Index, TenNum, LastRowNum, PreGroupIndex, #Widget.Info.ModList, #self.Owner.GroupInfo[PreGroupIndex].ModList) 
            -- ListView中的Item会服用，上一个还没显示出来的话，直接取取到的是之前下面消失掉时的数据，要读Owner的总数据，然后延时后聚焦
            if LastRowNum >= Index then
                DebugPrint("kwz 111")
                -- 最后一排有对齐的
                self.Owner.List_ModArchive:NavigateToIndex(PreGroupIndex - 1)
                self.Owner.List_ModArchive:SetSelectedIndex(PreGroupIndex - 1)

                self:AddDelayFrameFunc(function()
                    self.Owner.List_ModArchive:ScrollIndexIntoView(PreGroupIndex - 1)
                    self.Owner.Widgets[PreGroupIndex]:SetItemSelected(TenNum * 10 + Index)
                    self.Owner.Widgets[PreGroupIndex].Mods[TenNum * 10 + Index]:SetFocus()
                end, 2, "GoToUpMod")
            elseif TenNum > 0 then
                DebugPrint("kwz 222")
                -- 最后一排没有对齐的，选到上一排对齐的那个
                self.Owner.List_ModArchive:NavigateToIndex(PreGroupIndex - 1)
                self.Owner.List_ModArchive:SetSelectedIndex(PreGroupIndex - 1)

                self:AddDelayFrameFunc(function()
                    self.Owner.List_ModArchive:ScrollIndexIntoView(PreGroupIndex - 1)
                    self.Owner.Widgets[PreGroupIndex]:SetItemSelected((TenNum - 1) * 10 + Index)
                    self.Owner.Widgets[PreGroupIndex].Mods[(TenNum - 1) * 10 + Index]:SetFocus()
                end, 2, "GoToUpMod")
            else
                -- 导到上一层最后一个
                DebugPrint("kwz 333")
                self.Owner.List_ModArchive:NavigateToIndex(PreGroupIndex - 1)
                self.Owner.List_ModArchive:SetSelectedIndex(PreGroupIndex - 1)

                self:AddDelayFrameFunc(function()
                    self.Owner.List_ModArchive:ScrollIndexIntoView(PreGroupIndex - 1)
                    self.Owner.Widgets[PreGroupIndex]:SetItemSelected(#Widget.Mods)
                    self.Owner.Widgets[PreGroupIndex].Mods[#Widget.Mods]:SetFocus()
                end, 2, "GoToUpMod")

            end
        end
        return
    end
    -- 本层上面还有Item，可以选择
    self:SetItemSelected(CurSelectedItemIndex)
    self.Mods[CurSelectedItemIndex]:SetFocus()
    return
end

function WBP_ModArchive_Archive_Item_C:OnNavigateDown()
    DebugPrint("zwkkkkkk OnNavigateDown")
    if not self.Owner then return end
    local CurSelectedItemIndex = self.Owner.CurSelectedItemIndex + 10
    if CurSelectedItemIndex > #self.Mods then
        -- 判断下一层能不能走
        local GroupIndex = self.Owner.CurGroupIndex
        local Item = self.Owner.List_ModArchive:GetItemAt(GroupIndex)
        local Widget = self.Owner.Widgets[GroupIndex + 1]
        if Widget and self.Owner.GroupInfo and self.Owner.GroupInfo[GroupIndex + 1] and self.Owner.GroupInfo[GroupIndex + 1].ModList then
            -- 判断下一层有没有对齐的，没有就选到最右边那个
            local Index = self.Owner.CurSelectedItemIndex % 10
            local HaveIndex = self.Owner.GroupInfo[GroupIndex + 1].ModList[Index]
            -- DebugPrint("tttttt ", #Widget.Mods, #Widget.Info.ModList, Widget:GetName(), GroupIndex)

            -- 下一层还没显示的话，#Widget.Mods是0，但是Widget是可以取到的。要读Owner的总数据，然后延时后聚焦
            if HaveIndex then
                -- Item.SelfWidget:SetFocus()
                -- DebugPrint("zwkkkkkk 准备导到下面一行去")
                -- self.Owner.List_ModArchive:ScrollIndexIntoView(GroupIndex)
                -- self.Owner.List_ModArchive:SetSelectedIndex(GroupIndex)
                self.Owner.List_ModArchive:NavigateToIndex(GroupIndex)
                self.Owner.List_ModArchive:SetSelectedIndex(GroupIndex)

                -- DebugPrint("zwkkkkkk OnNavigateDown", Index, Item.SelfWidget:GetName(), Item.SelfWidget.Mods[Index]:GetName())
                -- Item.SelfWidget:SetItemSelected(Index)
                -- Item.SelfWidget.Mods[Index]:SetFocus()

                self:AddDelayFrameFunc(function()
                    -- DebugPrint("zwkkkkkk OnNavigateDown", Index, Item.SelfWidget:GetName(), Item.SelfWidget.Mods[Index]:GetName())
                    -- Item.SelfWidget:SetItemSelected(Index)
                    -- Item.SelfWidget.Mods[Index]:SetFocus()
                    self.Owner.List_ModArchive:ScrollIndexIntoView(GroupIndex)
                    --DebugPrint("zzzzzz focus到下层item了 ", GWorld:GetCurrentTime())
                    DebugPrint("zwkkkkkk GroupIndex ", GroupIndex + 1)
                    self.Owner.Widgets[GroupIndex + 1]:SetItemSelected(Index)
                    self.Owner.Widgets[GroupIndex + 1].Mods[Index]:SetFocus()
                end, 2, "GoToDownMod")
            else
                -- 没有对齐的，导到下排最后一个
                self.Owner.List_ModArchive:NavigateToIndex(GroupIndex)
                self.Owner.List_ModArchive:SetSelectedIndex(GroupIndex)
                self:AddDelayFrameFunc(function()
                    self.Owner.List_ModArchive:ScrollIndexIntoView(GroupIndex)
                    local MaxIndex = #Item.SelfWidget.Mods
                    self.Owner.Widgets[GroupIndex + 1]:SetItemSelected(MaxIndex)
                    self.Owner.Widgets[GroupIndex + 1].Mods[MaxIndex]:SetFocus()
                end, 2, "GoToDownMod")
                -- Item.SelfWidget:SetFocus()
                -- DebugPrint("zwkkkkkk OnNavigateDown else", Index)
                -- Item.SelfWidget:SetItemSelected(#Item.SelfWidget.Mods)
                -- Item.SelfWidget.Mods[#Item.SelfWidget.Mods]:SetFocus()
            end
        end
        return
    end
    -- 本层下面还有Item，可以选择
    self:SetItemSelected(CurSelectedItemIndex)
    self.Mods[CurSelectedItemIndex]:SetFocus()
    return
end

function WBP_ModArchive_Archive_Item_C:OnLBKeyDown()
    if not self.RewardInFocus then
        self.RewardInFocus = true
    end
    self.Item_Title:SetFocus()
    self:SetRewardTextVisibility(false)
end

-- function WBP_ModArchive_Archive_Item_C:OnFocusReceived(MyGeometry, InFocusEvent)
--     DebugPrint("获得了聚焦", self:GetName())
--     return UE4.UWidgetBlueprintLibrary.Unhandled()
--     -- if not self.Info or not self.Info.Index then return end
--     -- if not self.Owner then return end
--     -- for i = 1, #self.Owner.Widgets[self.Info.Index].Mods do
--     --     DebugPrint("获得了聚焦？ ", self.Owner.Widgets[self.Info.Index].Mods[i].BaseItem:GetName())
--     --     self.Owner.Widgets[self.Info.Index].Mods[i].BaseItem:StopAllAnimations()
--     --     self.Owner.Widgets[self.Info.Index].Mods[i].BaseItem:PlayAnimation(self.Owner.Widgets[self.Info.Index].Mods[i].BaseItem.Normal)
--     -- end
-- end

function WBP_ModArchive_Archive_Item_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    DebugPrint("zwkkk   RefreshOpInfoByInputDevice ", CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName

    self:UpdateOnInputDeviceTypeChange()
end

function WBP_ModArchive_Archive_Item_C:UpdateOnInputDeviceTypeChange()
    if self.CurInputDeviceType == ECommonInputType.Gamepad then

    elseif self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard then
        if self.Key_TitleReward then
            self.Key_TitleReward:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
end


return WBP_ModArchive_Archive_Item_C
