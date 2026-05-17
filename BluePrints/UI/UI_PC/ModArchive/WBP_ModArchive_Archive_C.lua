--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local EMCache = require "EMCache.EMCache"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local ModModel = ModController:GetModel()

local WBP_ModArchive_Archive_C = Class({"BluePrints.UI.BP_UIState_C", "BluePrints.Common.DelayFrameComponent"})

function WBP_ModArchive_Archive_C:Construct()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
    self.Node_ResourceBar:BindEvents(self,{
        OnAddedToFocusPath = self.OnResourceBarAddedToFocusPath,
        OnRemovedFromFocusPath = self.OnResourceBarRemovedFromFocusPath,
        OnMenuOpenChanged = self.OnMenuOpenChanged
    })
    self.Btn_Reward:UnBindEventOnClicked(self, self.OnClickGetAllRewards)
    self.Btn_Reward:BindEventOnClicked(self, self.OnClickGetAllRewards)
    self.Btn_Reward:SetGamePadImg("Y")
    if self.Key_Rewards then
        self.Key_Rewards:CreateGamepadKey("View")
    end
end

function WBP_ModArchive_Archive_C:OnSelected(Params)
    if Params then
        self.Owner = Params.Owner
        self.Index = Params.Index
    end
    self:SetFocus()

    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()

    -- 下排按键刷新
    if (self.CurInputDeviceType == ECommonInputType.GamePad) then
        self.Owner:SwitchComKeyTipsState(7)
    else
        self.Owner:SwitchComKeyTipsState(1)
    end

    self.HasSelected = true

    -- 所有的mod
    self.AllMods = DataMgr.ModGuideBookArchive

    self.UIName = self.Owner.WidgetName

    -- 为了顺序遍历，记录key
    self.Keys = {}
    for archiveId, _ in pairs(self.AllMods) do
        table.insert(self.Keys, archiveId)
    end
    -- table.sort(self.Keys, function(a, b) return a < b end)

    -- for _, archiveId in ipairs(self.Keys) do
    --     local modData = self.AllMods[archiveId]
    --     DebugPrint("zwkk 遍历Item 他的 ArchiveId 是 ", modData.ArchiveId)
    -- end
    
    self.CurSelectItem = nil

    self:RefreshInfo()
end

-- 初始化Tab
function WBP_ModArchive_Archive_C:InitTab()
    local Tabs = {}
    for i, v in pairs(DataMgr.ModGuideBookArchiveTab) do
        local Tab = {
            Text = GText(v.Name),
            Idx = i
        }
        table.insert(Tabs, Tab)
    end
    local ConfigData = {
        Owner = self,
        ChildWidgetName = "TabSubTextItem",
        Tabs = Tabs,
        SoundFuncReceiver = self,
        SoundFunc = self.TabClickSoundFunc
    }
    self.ArchiveTab:Init(ConfigData)
    self.ArchiveTab:BindEventOnTabSelected(self, self.OnTabSelected)
    if self.CurTab then
        self.ArchiveTab:SelectTab(self.CurTab)
    else
        self.ArchiveTab:SelectTab(1)
    end
    -- self.ArchiveTab:SelectTab(1)
    
    self.TabNum = #Tabs
end

-- 上方Tab点击事件，切换Panel
function WBP_ModArchive_Archive_C:OnTabSelected()
    DebugPrint("zwkjkj OnTabSelected")
    self.FirstSelected = true
    local NextTab = self.ArchiveTab:GetCurrentTabIndex()
    -- if NextTab ~= self.CurTab then
    --     self.CurTab = NextTab
    --     self.List_ModArchive:ClearListItems()
    --     self:InitTabList()
    --     --self.TabMain[self.CurTab]:OnSelected()
    -- end
    if self.CurTab then
        self.PreTab = self.CurTab
    end
    self.CurTab = NextTab
    self.List_ModArchive:ClearListItems()

    table.sort(self.Keys, function(a, b)
        local ModInfoA = self.AllMods[a]
        local ModInfoB = self.AllMods[b]
    
        local CanA = self:CheckHasGetReward(ModInfoA.ArchiveId)
        local CanB = self:CheckHasGetReward(ModInfoB.ArchiveId)
    
        -- 第一级优先级：bCanGetReward 为 true 的优先
        if CanA ~= CanB then
            return not CanA -- 未领奖在前
        end
    
        -- 第二级优先级：ArchiveId 越小越靠前
        return ModInfoA.ArchiveId < ModInfoB.ArchiveId
    end)

    self:InitTabList()
    --self.TabMain[self.CurTab]:OnSelected()
end

-- 添加当前Tab下的数据
function WBP_ModArchive_Archive_C:InitTabList()
    local Index = 0
    self:HandlePreTab()
    self.GroupInfo = {}
    self.Widgets = {}

    self.CanGetRewardGroups = {}  -- 每个组的奖励领取状态
    -- CommonUtils.Size(self.CanGetRewardGroups)

    
    -- New标
    local ModBookModsViewState = EMCache:Get("ModBookModsViewState", true)

    for i, ArchiveId in ipairs(self.Keys) do
        local ModInfo = self.AllMods[ArchiveId]
        if ModInfo.TabId == self.CurTab then
            -- DebugPrint("zwkk Index", i)
            -- 版本控制，如果这一组全部mod都在当前版本之外，则不添加这组
            local AllNotInControl = false
            local InControlModList = {}
            for _, ModId in ipairs(ModInfo.ModList) do
                local ReleaseVersion = DataMgr.Mod[ModId].ReleaseVersion
                if (not ReleaseVersion) or (ReleaseVersion <= DataMgr.GlobalConstant.CurrentVersion.ConstantValue) then
                    AllNotInControl = true
                    table.insert(InControlModList, ModId)
                end
            end
            if not AllNotInControl then
                goto continue
            end
            Index = Index + 1
            local Content =  NewObject(UIUtils.GetCommonItemContentClass())
            --Content.ClickCallback = self.ClickSelectSquadItem
            Content.Owner = self
            Content.Index = Index
            Content.Id = ModInfo.ArchiveId
            Content.ModList = InControlModList
            Content.RewardId = ModInfo.RewardId
            Content.UnlockCondition = ModInfo.UnlockCondition
            Content.ShowCondition = ModInfo.ShowCondition
            Content.Name = ModInfo.Name
            Content.TabId = ModInfo.TabId
            if ModBookModsViewState and ModBookModsViewState[ModInfo.ArchiveId] then
                Content.RedDotNewStates = ModBookModsViewState[ModInfo.ArchiveId]
            end
            Content.AfterInitCallback = function(Widget)

            end
            local bCanGetReward = self:CheckCanGetReward(ModInfo.ArchiveId, ModInfo.ModList)
            Content.bCanGetReward = bCanGetReward
            self.List_ModArchive:AddItem(Content)
            self.GroupInfo[Index] = ModInfo
        end
        ::continue::
    end

    -- 全部领取按钮显示状态
    self:RefreshBtnRewardState()

    DebugPrint("zwkkkkk InitTabList ", self:GetName(), self.CurGroupIndex, self.CurSelectedItemIndex, self.CurGroupId)
    self.List_ModArchive:NavigateToIndex(0)

    -- -- 刷新New和红点信息
    -- EMCache:Set("ModBookModsViewState", ModBookModsViewState, true)
    -- self.Owner:RefreshDot()
end

-- 检查其中一组是否可领奖
function WBP_ModArchive_Archive_C:CheckCanGetReward(ArchiveId, ModList)
    local Avatar = GWorld:GetAvatar()
    for _, ModId in pairs(ModList) do
        if not Avatar.HoldMods[ModId] or Avatar.HoldModRewards[ArchiveId] then
            self.CanGetRewardGroups[ArchiveId] = false
            return false
        end
    end

    local Info = DataMgr.ModGuideBookArchive[ArchiveId]
    if (Info.ShowCondition and not ConditionUtils.CheckCondition(Avatar, Info.ShowCondition)) or (Info.UnlockCondition and not ConditionUtils.CheckCondition(Avatar, Info.UnlockCondition)) then
        self.CanGetRewardGroups[ArchiveId] = false
        return false
    end
    self.CanGetRewardGroups[ArchiveId] = true
    return true
end

-- 排序用检测是否可领奖
function WBP_ModArchive_Archive_C:CheckCanGetRewardOrder(ArchiveId, ModList)
    local Avatar = GWorld:GetAvatar()
    for _, ModId in pairs(ModList) do
        if not Avatar.HoldMods[ModId] or Avatar.HoldModRewards[ArchiveId] then
            return false
        end
    end
    return true
end

-- 检测是否已领奖
function WBP_ModArchive_Archive_C:CheckHasGetReward(ArchiveId)
    local Avatar = GWorld:GetAvatar()
    if Avatar.HoldModRewards[ArchiveId] then
        return true
    end
    return false
end

-- 检查是否还有可以领取的奖励
function WBP_ModArchive_Archive_C:CheckRewardRemain()
    for i, v in pairs(self.CanGetRewardGroups) do
        DebugPrint("检查中 ", i, v)
        if v then
            return true
        end
    end
    return false
end

-- 刷新全部领取按钮的显隐状态
function WBP_ModArchive_Archive_C:RefreshBtnRewardState()
    DebugPrint("zwkzwk 刷新按钮状态 ")
    if self:CheckRewardRemain() then
        -- 还有可以领取的奖励
        -- self.Btn_Reward:SetVisibility(ESlateVisibility.Visible)
        self.Group_GetAll:SetVisibility(ESlateVisibility.Visible)
        if (self.CurInputDeviceType == ECommonInputType.Gamepad) then
            if self.Widgets[self.CurGroupIndex] then
                local Res = self.Widgets[self.CurGroupIndex]:CheckRewardCanGet()
                -- if Res then
                --     self.Owner:SwitchComKeyTipsState(5)
                -- else
                --     self.Owner:SwitchComKeyTipsState(3)
                -- end
                self.Owner:SwitchComKeyTipsState(7)
            end
        else
            self.Owner:SwitchComKeyTipsState(4)
        end
    else
        -- 没有能领的了
        -- self.Btn_Reward:SetVisibility(ESlateVisibility.Collapsed)
        self.Group_GetAll:SetVisibility(ESlateVisibility.Collapsed)
        if (self.CurInputDeviceType == ECommonInputType.Gamepad) then
            self.Owner:SwitchComKeyTipsState(7)
        else
            self.Owner:SwitchComKeyTipsState(1)
        end
    end
    self.Node_ResourceBar:UpdateResource()
end

function WBP_ModArchive_Archive_C:OnGamepadFirstSelect()
    if self.Widgets and self.Widgets[1] then
        DebugPrint("第一次Select Widget", self.Widgets[1]:GetName())
        if self.Owner.ShouldShowTips then
            return
        end
        if self.Owner.TabMain[self.Index] then
            local DelayFrame = 2
            self:AddDelayFrameFunc(function()
                if self.FirstSelected then
                    self.List_ModArchive:SetSelectedIndex(0)
                    self.List_ModArchive:ScrollIndexIntoView(0)
                    -- self.List_ModArchive:BP_CancelScrollIntoView()
                    if self.Widgets and self.Widgets[1] then
                        self.Widgets[1]:SetItemSelected(1)
                        self.Widgets[1].Mods[1]:SetFocus()
                    end
                    self:TrySetMousePosition()
                end
            end, DelayFrame, "SelectFirstMod")
        else
            self.List_ModArchive:SetSelectedIndex(0)
            self.List_ModArchive:ScrollIndexIntoView(0)
            -- self.List_ModArchive:BP_CancelScrollIntoView()
            self.Widgets[1]:SetItemSelected(1)
            self.Widgets[1].Mods[1]:SetFocus()
            self:TrySetMousePosition()
        end

    end
end

function WBP_ModArchive_Archive_C:OnShowTipsClose()
    self:OnGamepadFirstSelect()
end

function WBP_ModArchive_Archive_C:UpdateListWidgets(Widget)
    DebugPrint("zwkkkkkkk Widget", Widget.Info.Index, #Widget.Info.ModList, Widget:GetName())
    -- if not self.Widgets then
    --     self.Widgets = {}
    -- end
    self.Widgets[Widget.Info.Index] = Widget
end

-- 有Mod被点击
function WBP_ModArchive_Archive_C:OnItemClicked(ModInfo, LockState, GroupIndex, Index, Widget, GroupId)
    -- 检查是否选中了不同组的Item
    DebugPrint("zwkkk123 GroupIndex", GroupIndex)
    self.FirstSelected = false
    if self.CurGroupIndex and self.CurGroupIndex ~= GroupIndex then
        -- local Item = self.List_ModArchive:GetItemAt(self.CurGroupIndex - 1)
        -- if Item then
        --     DebugPrint("zwkkkk Item", Item:GetName())
        --     Item.SelfWidget:OnOtherArchiveItemSelected()
        -- end
        -- DebugPrint("zzzzzz GroupIndex", GroupIndex)
        if self.Widgets and self.Widgets[self.CurGroupIndex] then
            self.Widgets[self.CurGroupIndex]:OnOtherArchiveItemSelected()
            self.Widgets[self.CurGroupIndex]:SetRewardTextVisibility(false)
        end
        -- self.List_ModArchive:SetSelectedIndex(self.CurGroupIndex - 1)
    end
    self.CurGroupIndex = GroupIndex
    self.CurSelectedItemIndex = Index
    self.CurGroupId = GroupId

    if self.Widgets[self.CurGroupIndex] then
        self.Widgets[self.CurGroupIndex]:SetRewardTextVisibility(true)
        if self.CurInputDeviceType == ECommonInputType.GamePad then
            -- 手柄下判断下方按键显示什么情况
            -- if self.Widgets[self.CurGroupIndex]:CheckRewardCanGet() then
            --     self.Owner:SwitchComKeyTipsState(5)
            -- else
            --     self.Owner:SwitchComKeyTipsState(3)
            -- end
            self.Owner:SwitchComKeyTipsState(7)
        end
    end

    self:SetTipsInfo(ModInfo, LockState)

    -- 下方按钮形态刷新
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self.Btn_Reward:SetGamePadVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Key_Rewards:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        if self.CanFocusTips then
            -- 查看方式里有可以聚焦的
            --self.Owner:SwitchComKeyTipsState(1)
        else
            -- 查看方式里没有可以聚焦的
            --self.Owner:SwitchComKeyTipsState(1)
        end
    end

    self.CurItemWidget = Widget
    self.IsInViewTips = false

    -- New标相关
    local ModBookModsViewState = EMCache:Get("ModBookModsViewState", true)
    if ModBookModsViewState[GroupId] and ModBookModsViewState[GroupId][ModInfo.Id] then
        ModBookModsViewState[GroupId][ModInfo.Id] = false
        Widget:SetRedDot(nil)
        local ReddotNode = DataMgr.ModGuideBookArchiveTab[self.CurTab].ReddotNode
        local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotNode)
        if CacheDetail.NewNum then
            CacheDetail.NewNum = CacheDetail.NewNum - 1
            if CacheDetail.States and CacheDetail.States[ModInfo.Id] then
                CacheDetail.States[ModInfo.Id] = false
            end
        end
        ReddotManager.DecreaseLeafNodeCount(ReddotNode, 1, CacheDetail)
    end
    EMCache:Set("ModBookModsViewState", ModBookModsViewState, true)
    -- 刷新New和红点信息
    self.Owner:RefreshDot()
end

-- 右边Tips信息的设置
function WBP_ModArchive_Archive_C:SetTipsInfo(ModInfo, LockState)
    -- 判断空态（未揭晓/未解锁）
    if LockState == 2 then
        self.VB_Tips:SetVisibility(ESlateVisibility.Collapsed)
        self.List_ModStar:SetVisibility(ESlateVisibility.Collapsed)
        self.Text_ItemName:SetVisibility(ESlateVisibility.Collapsed)
        self.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
        self.Group_Empty:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Text_Empty:SetText(GText("UI_ModGuideBook_Task_Block"))
        return
    else
        -- 可以显示，设置控件显示状态
        self.VB_Tips:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.List_ModStar:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Text_ItemName:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Panel_Hold:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Group_Empty:SetVisibility(ESlateVisibility.Collapsed)
    end

    -- 名字
    self.Text_ItemName:SetText(ModModel:GetModFullNameByConf(ModInfo.Id))
    -- local RaritySlateColor = UE4.UUIFunctionLibrary.StringToSlateColor(UIConst.RarityColor[ModInfo.Rarity])
    -- self.Text_ItemName:SetColorAndOpacity(RaritySlateColor)
    local FontMaterial = self.Text_ItemName:GetDynamicFontMaterial()
    if ModInfo.Rarity and ModInfo.Rarity > 0 then
        FontMaterial:SetTextureParameterValue("IconTex", self["Img_Text_"..ModInfo.Rarity])
    else
        FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_0)
    end

    -- 数量
    local PlayerAvatar = ModController:GetAvatar()
    local Count = 0
    if PlayerAvatar and ModInfo.Id and PlayerAvatar.GetModCount2ModId then
        Count = PlayerAvatar:GetModCount2ModId(ModInfo.Id)
    end
    self.Text_Hold02:SetText(Count)

    -- Tips
    self.Text_Describe:SetText(GText(ModInfo.FunctionDes))

    -- 容量 & 极性
    self.Text_Polarity01:SetText(GText("UI_Tips_Polarity_Cost"))

    if ModInfo.Polarity ~= CommonConst.NonePolarity then
        self.Text_Polarity:SetVisibility(UIConst.VisibilityOp.Visible)
        local PolarityText = ModModel:GetPolarityText(ModInfo.Polarity)
        self.Text_Polarity:SetText(PolarityText)
    else
        self.Text_Polarity:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

    -- MOD等级
    self.Text_MaxLevel:SetText(ModInfo.MaxLevel)
    self.Text_Level:SetText(ModInfo.MaxLevel)

    -- Cost
    self.Text_Polarity02:SetText(ModInfo.Cost + ModInfo.MaxLevel * ModInfo.CostChange)

    -- Mod数值
    self:UpdataEffectDetails(ModInfo, ModInfo.MaxLevel)

    -- 适用类型
    if self.Text_Tag then
        self.Text_Tag:SetVisibility(UIConst.VisibilityOp.Visible)
        local AppTypeTexts = {}
        for i ,TagText in ipairs(DataMgr.ModTag[ModInfo.ApplicationType].ModTagText) do
            table.insert(AppTypeTexts,GText(TagText))
        end
        local AppTypeText = GText("UI_Tips_ModApplicationType")..table.concat(AppTypeTexts,", ")
        self.Text_Tag:SetText(AppTypeText)
    end

    -- 提示最大预览
    self.Com_Tips_Line:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Com_Tips_Line.Text_Level:SetText(GText("UI_ModTips_MaxLvPreview"))
    self.Com_Tips_Line.Bg02:SetColorAndOpacity(self.Com_Tips_Line.Yellow)

    self.Content = {
        Test = 1
    }

    -- self.Tips_Mod:InitItemInfo("Mod", ModInfo.Id, nil)
    self.Text_Hold01:SetText(GText("UI_Bag_Sellconfirm_Hold"))
    self.Text_TaskRewards:SetText(GText("UI_Tips_Obtining"))
    self:SetAccessItem("Mod", ModInfo.Id)


    -- 星级
    self.List_ModStar:ClearListItems()

    local StarNum = ModInfo.Rarity
    local StarNum = ModInfo.ModCardLevelMax
    if StarNum and StarNum > 0 then
        self.List_ModStar:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        for i = 1, StarNum do
            local Content = NewObject(UIUtils.GetCommonItemContentClass())
            Content.bActivate = false
            -- 待回调里置灰

            self.List_ModStar:AddItem(Content)
        end
    else
        self.List_ModStar:SetVisibility(ESlateVisibility.Collapsed)
    end


    -- 光环图标
    if ModInfo and ModInfo.ApplySlot and #ModInfo.ApplySlot == 1 and ModInfo.ApplySlot[1] == 9 then
        self.Icon_Halo:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Icon_Halo:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function WBP_ModArchive_Archive_C:UpdataEffectDetails(ModDataInfo, ModLevel)
    self.EffectDetails:ClearChildren()
    local ModAttrs = ModDataInfo.AddAttrs
    if ModAttrs then
        for _, ModAttr in ipairs(ModAttrs) do
            local AttrConfig = DataMgr.AttrConfig[ModAttr.AttrName]
            if not AttrConfig then goto continue end
            local _, ValueStr = ArmoryUtils:GenModAttrData(ModAttr, ModLevel, AttrConfig, ModDataInfo.Id)
            local ModAttrText = GText(AttrConfig.Name)..ValueStr
            local EffectItem = UIManager(self):_CreateWidgetNew("CommonItemDetailsEffect")
            EffectItem.Text_Effect:SetText(ModAttrText)
            EffectItem.Switch_Type:SetActiveWidgetIndex(0)
            self.EffectDetails:AddChild(EffectItem)
            ::continue::
        end
    end
    if (ModDataInfo.PassiveEffectsDesc) then
        local ModDescText = ArmoryUtils:GenModPassiveEffectDesc(ModDataInfo, ModLevel)
        local EffectItem = UIManager(self):_CreateWidgetNew("CommonItemDetailsEffect")
        EffectItem.Text_Effect01:SetText(GText("UI_MOD_Effect")..ModDescText)
        EffectItem.Switch_Type:SetActiveWidgetIndex(1)
        self.EffectDetails:AddChild(EffectItem)
    end
end


-- 存一下已有的Mod
function WBP_ModArchive_Archive_C:GetMods()
    if not self.HasMod then
        self.HasMod = {}
    end
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        -- for _, Mod in pairs(Avatar.Mods) do
        --     self.HasMod[Mod.ModId] = true
        -- end

        -- 从Avatar记录的获得过的Mod里读
        for ModId, GetTime in pairs(Avatar.HoldMods) do
            DebugPrint("zwki ", ModId, GetTime)
            self.HasMod[ModId] = true
        end
    end
end

-- 获取所有的ModItem
function WBP_ModArchive_Archive_C:GetAllModItem()
    -- self.ModItems = {}
    for i = 1, self.List_ModArchive:GetNumItems() do
        --DebugPrint("zwkkkkkk i", i)
        local v = self.List_ModArchive:GetItemAt(i - 1)
        if v and v.SelfWidget and v.SelfWidget.Mods then
            --DebugPrint("zwkkkkkk v", #v.SelfWidget.Mods)
        end
        -- table.insert(self.ModItems, v.SelfWidget)
    end
end

-- 全部领取按钮点击后
function WBP_ModArchive_Archive_C:OnClickGetAllRewards()
    local Avatar = GWorld:GetAvatar()
    local CallBack = function(ErrCode, Rewards)
        DebugPrint("zwzwkzwk ", ErrorCode, ErrorCode:Check(ErrCode), self:GetName())
        if ErrorCode:Check(ErrCode) then
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function()
                if self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard then
                    self:SetFocus()
                end
            end, self, false)
            -- ItemPage:BindActionOnClosed(self.RefreshInfo, self)
            for _, Widget in pairs(self.Widgets) do
                if Widget then
                    Widget:SetReward()
                end
            end
            local ModBookCanGetRewards = EMCache:Get("ModBookCanGetRewards", true)
            for ArchiveId, bCanGetReward in pairs(self.CanGetRewardGroups) do
                if bCanGetReward then
                    self.CanGetRewardGroups[ArchiveId] = false
                end
                -- 红点情况
                -- if ModBookCanGetRewards and ModBookCanGetRewards[tostring(ArchiveId)] then
                --     ModBookCanGetRewards[tostring(ArchiveId)] = false
                -- end
                if ModBookCanGetRewards and ModBookCanGetRewards[ArchiveId] then
                    ModBookCanGetRewards[ArchiveId] = false
                end
                EMCache:Set("ModBookCanGetRewards", ModBookCanGetRewards, true)
                self.Owner:RefreshDot()
            end
            local ReddotNode = DataMgr.ModGuideBookArchiveTab[self.CurTab].ReddotNode
            local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotNode)
            local RedNum = 0
            if CacheDetail.RedNum then
                RedNum = CacheDetail.RedNum
                CacheDetail.RedNum = 0
            end
            ReddotManager.DecreaseLeafNodeCount(ReddotNode, RedNum, CacheDetail)
            if CacheDetail.NewNum and CacheDetail.NewNum > 0 then
                self.ArchiveTab:ShowTabRedDot(self.CurTab, true, false)
            else
                self.ArchiveTab:ShowTabRedDot(self.CurTab, false, false)
            end


            self:RefreshBtnRewardState()

            -- -- 红点情况
            -- local ModBookCanGetRewards = EMCache:Get("ModBookCanGetRewards", true)
            -- for i, v in pairs(DataMgr.)
            -- if ModBookCanGetRewards and ModBookCanGetRewards[self.Info.Id] then
            --     ModBookCanGetRewards[self.Info.Id] = false
            -- end
            -- EMCache:Set("ModBookCanGetRewards", ModBookCanGetRewards, true)
            -- self.Owner.Owner:RefreshDot()
        end
    end

    local Ids = {}
    for ArchiveId, bCanGetReward in pairs(self.CanGetRewardGroups) do
        if bCanGetReward then
            table.insert(Ids, ArchiveId)
        end
    end
    Avatar:GetAllModGuideBookArchiveReward(Ids, CallBack)
end

-- 获取跳转途径
function WBP_ModArchive_Archive_C:SetAccessItem(ItemType,ItemId)
    self.Method:ClearChildren(ItemType, ItemId)
    local ItemInfo = DataMgr[ItemType][ItemId]
    assert(ItemInfo, "不存在该物品：", ItemType, ItemId)
    self.Panel_Method:SetVisibility(ESlateVisibility.Collapsed)
    self.Access = {}
    -- 获取途径
    if ItemInfo.AccessKey then
        for _, Access in pairs(ItemInfo.AccessKey) do
            PageJumpUtils:GetItemAccess(self, ItemId, ItemType, Access, self.UIName)
        end
        PageJumpUtils:SortAccessItem(self.Method)
        local Tips = self.Method:GetChildrenCount()
        if Tips > 0 then
            self.Panel_Method:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            local TipsChildren = self.Method:GetAllChildren()
            for i = 1, TipsChildren:Length() do
                local Child = TipsChildren:Get(i)
                if Child.JumpFunc then
                    -- 先结束引导
                    local Func = Child.JumpFunc
                    Child.JumpFunc = function ()
                        CommonUtils:CloseGuideTouchIfExist(self)
                        Func()
                    end
                    self.CanFocusTips = true
                    table.insert(self.Access, Child)
                end
            end
        end
    end
end

function WBP_ModArchive_Archive_C:TabClickSoundFunc()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_03", nil, nil)
end


function WBP_ModArchive_Archive_C:TrySetMousePosition()
    -- local i = self.List_ModArchive:HasFocusedDescendants()
    
    -- local Item = self.List_ModArchive:BP_GetSelectedItem()
    -- DebugPrint("zzzzzz 子空间是否有聚焦？ ", i)
    -- if Item then
    --     DebugPrint("zzzzzz 当前子控件Content ", Item:GetName())
    --     self.List_ModArchive:GetIndexForItem(Item)
    -- end
    if (self.CurInputDeviceType == ECommonInputType.Gamepad) then
        ULowEntryExtendedStandardLibrary.SetMousePositionInPercentages(0.0, 0.0)
    end
end

function WBP_ModArchive_Archive_C:TryGetAllRewards()
    if self:CheckRewardRemain() then
        self:OnClickGetAllRewards()
    end
end

-- 聚焦回来后重新选定Item
function WBP_ModArchive_Archive_C:RefreshInfo()
    DebugPrint("聚焦回来了 WBP_ModArchive_Archive_C")

    local PreGroupId = 0
    if self.CurGroupIndex then
        PreGroupId = self.CurGroupId
    end
    local PreIndex = 0
    if self.CurSelectedItemIndex then
        PreIndex = self.CurSelectedItemIndex
    end

    -- 记录已有的Mod
    self:GetMods()

    -- 上方页签
    self:InitTab()
    self:SetVisibility(ESlateVisibility.Visibility)
    self:PlayAnimation(self.In)
    self.Btn_Reward:SetText(GText("UI_Achievement_GetAllReward"))

    -- 资源栏
    local SystemUIConfig = DataMgr.SystemUI["ModArchiveMain"]
    local TopResource = SystemUIConfig.TabCoin
    self.Node_ResourceBar:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Node_ResourceBar:InitResourceBar(TopResource)
    local ResourceBarIcon = UIUtils.UtilsGetKeyIconPathInGamepad("RS", self.CurGamepadName)
    self.Node_ResourceBar:SetGamePadKeyImgByPath(ResourceBarIcon)

    -- 回到之前的
    -- if PreGroupId > 0 and PreIndex > 0 then
    --     DebugPrint("聚焦回来了11准备delay ", PreGroupId, PreIndex)
    --     self:AddDelayFrameFunc(function()
    --         DebugPrint("聚焦回来了11delay刚完 ", PreGroupId, PreIndex)
    --         local Index = 0
    --         local NewGroupId = 1
    --         for i, ArchiveId in ipairs(self.Keys) do
    --             local ModInfo = self.AllMods[ArchiveId]
    --             if ModInfo.TabId == self.CurTab then
    --                 Index = Index + 1
    --                 if ModInfo.ArchiveId == PreGroupId then
    --                     NewGroupId = i
    --                     DebugPrint("聚焦回来了22 ", PreGroupId, PreIndex)
    --                     self.List_ModArchive:NavigateToIndex(NewGroupId - 1)
    --                     self.List_ModArchive:SetSelectedIndex(NewGroupId - 1)
    --                     self.List_ModArchive:ScrollIndexIntoView(NewGroupId - 1)
    --                     self:AddDelayFrameFunc(function()
    --                         DebugPrint("聚焦回来了33 ", PreGroupId, PreIndex)
    --                         -- self.List_ModArchive:ScrollIndexIntoView(NewGroupId - 1)
    --                         -- local SelectItem = self.List_ModArchive:BP_GetSelectedItem()
    --                         -- if SelectItem and SelectItem.SelfWidget then
    --                         --     SelectItem.SelfWidget:SetFocus()
    --                         --     SelectItem.SelfWidget:RefreshInputDeviceType()
    --                         --     SelectItem.SelfWidget:SetItemSelected(1)
    --                         -- end
            
    --                         self.List_ModArchive:ScrollIndexIntoView(NewGroupId - 1)
    --                         self.Widgets[NewGroupId]:SetItemSelected(PreIndex)
    --                         self.Widgets[NewGroupId].Mods[PreIndex]:SetFocus()
    --                     end, 2, "DelayFocus")
    --                     break
    --                 end
    --             end
    --         end
    --     end, 100, "ArchiveReturnFocus")


    --     -- DebugPrint("聚焦回来了11delay刚完 ", PreGroupId, PreIndex)
    --     -- local Index = 0
    --     -- local NewGroupId = 1
    --     -- for i, ArchiveId in ipairs(self.Keys) do
    --     --     local ModInfo = self.AllMods[ArchiveId]
    --     --     if ModInfo.TabId == self.CurTab then
    --     --         Index = Index + 1
    --     --         if ModInfo.ArchiveId == PreGroupId then
    --     --             NewGroupId = i
    --     --             break
    --     --         end
    --     --     end
    --     -- end
    --     -- DebugPrint("聚焦回来了22 ", PreGroupId, PreIndex)
    --     -- self.List_ModArchive:NavigateToIndex(NewGroupId - 1)
    --     -- self.List_ModArchive:SetSelectedIndex(NewGroupId - 1)
    --     -- self:AddDelayFrameFunc(function()
    --     --     DebugPrint("聚焦回来了00 ", PreGroupId, PreIndex)
    --     --     -- self.List_ModArchive:ScrollIndexIntoView(NewGroupId - 1)
    --     --     -- local SelectItem = self.List_ModArchive:BP_GetSelectedItem()
    --     --     -- if SelectItem and SelectItem.SelfWidget then
    --     --     --     SelectItem.SelfWidget:SetFocus()
    --     --     --     SelectItem.SelfWidget:RefreshInputDeviceType()
    --     --     --     SelectItem.SelfWidget:SetItemSelected(1)
    --     --     -- end

    --     --     self.List_ModArchive:ScrollIndexIntoView(NewGroupId - 1)
    --     --     -- self.Widgets[NewGroupId]:SetItemSelected(PreIndex)
    --     --     -- self.Widgets[NewGroupId].Mods[PreIndex]:SetFocus()
    --     --     local SelectItem = self.List_ModArchive:BP_GetSelectedItem()
    --     --     if SelectItem and SelectItem.SelfWidget then
    --     --         DebugPrint("聚焦回来了33 ", PreGroupId, PreIndex)
    --     --         SelectItem.SelfWidget:SetFocus()
    --     --         SelectItem.SelfWidget:RefreshInputDeviceType()
    --     --         SelectItem.SelfWidget:SetItemSelected(PreIndex)
    --     --     end
    --     -- end, 100, "DelayFocus")
    -- end
end

function WBP_ModArchive_Archive_C:ReceiveEnterState(StackAction)
    WBP_ModArchive_Archive_C.Super.ReceiveEnterState(self, StackAction)
    DebugPrint("zwkkk ReceiveEnterState WBP_ModArchive_Archive_C")
    -- 刷新一下
    -- if self.TabMain and self.TabMain[self.CurTab] and self.TabMain[self.CurTab].HasSelected and self.TabMain[self.CurTab].RefreshInfo then
    --     self.TabMain[self.CurTab]:RefreshInfo()
    -- end
end

-- 刷新New标
function WBP_ModArchive_Archive_C:RefreshTabNew(SubTabNew)
    for i = 1, self.TabNum do
        if SubTabNew[i] then
            self.ArchiveTab:ShowTabRedDot(i, true, false)
        else
            self.ArchiveTab:ShowTabRedDot(i, false, false)
        end
    end
end

-- 刷新红点
function WBP_ModArchive_Archive_C:RefreshTabReddot(SubTabRed)
    for i = 1, self.TabNum do
        if SubTabRed[i] then
            self.ArchiveTab:ShowTabRedDot(i, false, true)
        end
    end
end

-- 红点树相关
function WBP_ModArchive_Archive_C:AddTabReddotListen()
    -- 图鉴页子Tab红点监听
    for i = 1, #DataMgr.ModGuideBookArchiveTab do
        local ReddotName = DataMgr.ModGuideBookArchiveTab[i].ReddotNode
        if ReddotName then
            ReddotManager.AddListenerEx(ReddotName, self, function(self, Count, RdType, RdName)
                if Count>0 then
                    if RdType == EReddotType.Normal then
                        if self.ArchiveTab then
                            self.ArchiveTab:ShowTabRedDot(i, false, true)
                        end
                    elseif RdType == EReddotType.New then
                        if self.ArchiveTab then
                            self.ArchiveTab:ShowTabRedDot(i, true, false)
                        end
                    end
                else
                    if self.ArchiveTab then
                        self.ArchiveTab:ShowTabRedDot(i, false, false)
                    end
                end
            end)
        end
    end
end

function WBP_ModArchive_Archive_C:OnNodeChange(Count, RdType, RdName)
    if Count>0 then
        if RdType == EReddotType.Normal then
            if self.ArchiveTab then
                self.ArchiveTab:ShowTabRedDot(self.CurTab, false, true)
            end
        elseif RdType == EReddotType.New then
            if self.ArchiveTab then
                self.ArchiveTab:ShowTabRedDot(self.CurTab, true, false)
            end
        end
    else
        if self.ArchiveTab then
            self.ArchiveTab:ShowTabRedDot(self.CurTab, false, false)
        end
    end
end

function WBP_ModArchive_Archive_C:RemoveTabReddotListen()
    for i = 1, #DataMgr.ModGuideBookArchiveTab do
        local ReddotName = DataMgr.ModGuideBookArchiveTab[i].ReddotNode
        if ReddotName then
            ReddotManager.RemoveListener(ReddotName, self)
        end
    end
end

function WBP_ModArchive_Archive_C:OnTipsOpenChanged(bIsOpen)
    self.Owner:OnTipsOpenChanged(bIsOpen)
    if self.CurInputDeviceType ~= ECommonInputType.GamePad then
        return
    end
    if bIsOpen then
        self.Node_ResourceBar:HideGamePadKey(true)
        self.ArchiveTab.Key_Left:SetVisibility(ESlateVisibility.Hidden)
        self.ArchiveTab.Key_Right:SetVisibility(ESlateVisibility.Hidden)
    else
        self.Node_ResourceBar:HideGamePadKey(false)
        self.ArchiveTab.Key_Left:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.ArchiveTab.Key_Right:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

-- 资源栏中tips打开关闭
function WBP_ModArchive_Archive_C:OnMenuOpenChanged(bIsOpen)
    self.Owner:OnTipsOpenChanged(bIsOpen)
    if self.CurInputDeviceType ~= ECommonInputType.GamePad then
        return
    end
    -- if bIsOpen then
    --     self.ArchiveTab.Key_Left:SetVisibility(ESlateVisibility.Hidden)
    --     self.ArchiveTab.Key_Right:SetVisibility(ESlateVisibility.Hidden)
    -- else
    --     self.ArchiveTab.Key_Left:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    --     self.ArchiveTab.Key_Right:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    -- end
end

function WBP_ModArchive_Archive_C:HandlePreTab()
    if not self.GroupInfo then
        return
    end
    local ModBookModsViewState = EMCache:Get("ModBookModsViewState", true)
    if not ModBookModsViewState then
        return
    end
    local Num = 0
    for _, ModInfo in pairs(self.GroupInfo) do
        if ModInfo then
            for i = 1, #ModInfo.ModList do
                local ModId = ModInfo.ModList[i]
                if ModBookModsViewState and ModBookModsViewState[ModInfo.ArchiveId] and ModBookModsViewState[ModInfo.ArchiveId][ModId] then
                    Num = Num + 1
                    ModBookModsViewState[ModInfo.ArchiveId][ModId] = false
                end
            end
        end
    end
    EMCache:Set("ModBookModsViewState", ModBookModsViewState, true)
    self.Owner:RefreshDot()

    if self.PreTab then
        local ReddotNode = DataMgr.ModGuideBookArchiveTab[self.PreTab].ReddotNode
        local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotNode)
        local DecreaseNum = 0
        if CacheDetail.NewNum then
            DecreaseNum = CacheDetail.NewNum
            CacheDetail.NewNum = 0
        end
        if CacheDetail.States then
            for index, value in pairs(CacheDetail.States) do
                CacheDetail.States[index] = false
            end
        end
        CacheDetail.NewNum = 0
        ReddotManager.DecreaseLeafNodeCount(ReddotNode, DecreaseNum, CacheDetail)
    end
end

function WBP_ModArchive_Archive_C:PreClose()
    if not self.PreTab then
        self.PreTab = 1
    end
    self:HandlePreTab()
end



-- function WBP_ModArchive_Archive_C:ReceiveEnterState(StackAction)
--     WBP_ModArchive_Archive_C.Super.ReceiveEnterState(self, StackAction)
--     DebugPrint("112233 ReceiveEnterState", self:GetName())

-- end


-- 监听PC/手柄按键
function WBP_ModArchive_Archive_C:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        DebugPrint("zwk    Key_IsGamepadKey", InKeyName)
        IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
    else
        DebugPrint("zwk    Key_IsPC", InKeyName)
        IsEventHandled = self:Handle_OnPCDown(InKeyName) 
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

-- PC按键按下
function WBP_ModArchive_Archive_C:Handle_OnPCDown(InKeyName)
    if (InKeyName == "A") then
        self.ArchiveTab:TabToLeft()
        return true
    elseif (InKeyName == "D") then
        self.ArchiveTab:TabToRight()
        return true
    elseif (InKeyName == "SpaceBar") then  -- 空格全部领取
        self:OnSpaceBarKeyDown()
        return true
    -- elseif (InKeyName == "Q") then
    --     self.Owner.ModArchive_Tab:TabToRight()
    --     return true
    -- elseif (InKeyName == "E") then
    --     self.Owner.ModArchive_Tab:TabToRight()
    --     return true
    end
    return false
end

function WBP_ModArchive_Archive_C:OnSpaceBarKeyDown()
    self:TryGetAllRewards()
end

-- 手柄按键按下
function WBP_ModArchive_Archive_C:Handle_OnGamePadDown(InKeyName)
    DebugPrint("zwkkk  Handle_OnGamePadDown", InKeyName, self:GetName())
    if (InKeyName == "Gamepad_DPad_Up" or InKeyName == "Gamepad_LeftStick_Up") then

        return true
    elseif (InKeyName == "Gamepad_FaceButton_Right") then -- 返回
        if self.IsInViewTips and self.CurItemWidget then
            DebugPrint("返回聚焦：", self.CurItemWidget:GetName())
            self.CurItemWidget:SetFocus()
            self.IsInViewTips = false
            self.Owner:SwitchComKeyTipsState(7)
        elseif self.Widgets[self.CurGroupIndex] and self.Widgets[self.CurGroupIndex].RewardInFocus then
            -- 正聚焦在奖励box上
            self.Widgets[self.CurGroupIndex].RewardInFocus = false
            if self.CurItemWidget then
                self.CurItemWidget:SetFocus()
                self.Widgets[self.CurGroupIndex]:SetRewardTextVisibility(true)
                -- 从奖励图标聚回到Mod上，显示查看详情+返回
                -- if self.Widgets[self.CurGroupIndex]:CheckRewardCanGet() then
                --     self.Owner:SwitchComKeyTipsState(5)
                -- else
                --     self.Owner:SwitchComKeyTipsState(3)
                -- end
                self.IsInViewRewards = false
                self.Owner:SwitchComKeyTipsState(7)
            end
        -- elseif self.IsFocusInResourceBar then
        --     self:ExitResourceSelectMode()
        else
            self.Owner:OnClose()
        end
        return true
    elseif (InKeyName == "Gamepad_FaceButton_Top") then  -- Y领取全部奖励
        self:TryGetAllRewards()
        return true
    elseif (InKeyName == "Gamepad_FaceButton_Left") then  -- X键领取奖励
        -- 现在X不再能领取奖励
        -- if self.Widgets[self.CurGroupIndex] and self.Widgets[self.CurGroupIndex]:CheckRewardCanGet() then
        --     self.Widgets[self.CurGroupIndex]:OnClickReward()
        -- end
        return true
    elseif (InKeyName == "Gamepad_RightThumbstick") then  -- 右摇杆按下
        if self.CurItemWidget then
            self.Node_ResourceBar:SetLastFocusWidget(self.CurItemWidget)
        end
        self.Node_ResourceBar:FocusToResource()
        return true
    elseif (InKeyName == "Gamepad_LeftThumbstick") then  -- 左摇杆按下 查看奖励
        if self.Widgets[self.CurGroupIndex] and not self.IsInViewTips then
            self.Widgets[self.CurGroupIndex]:OnLBKeyDown()
            -- 聚到了奖励图标上，切换下面按键显示
            if self.Widgets[self.CurGroupIndex].Item_Title.IsShowDetails then
                self.Owner:SwitchComKeyTipsState(2)
            else
                self.Owner:SwitchComKeyTipsState(6)
            end
            self.IsInViewRewards = true
        end
        return true
    elseif (InKeyName == "Gamepad_LeftTrigger") then -- 左切页
        self.ArchiveTab:TabToLeft()
        return true
    elseif (InKeyName == "Gamepad_RightTrigger") then -- 右切页
        self.ArchiveTab:TabToRight()
        return true
    elseif (InKeyName == "Gamepad_Special_Left") then  -- 左菜单键查看获取渠道
        if self.CanFocusTips and not self.IsInViewTips and #self.Access > 0 and not self.IsInViewRewards then
            self.IsInViewTips = true
            self.Access[1]:SetFocus()
            self.Owner:SwitchComKeyTipsState(3)
        end
        return true
    end
    return false
end

-- 监听松开按键
function WBP_ModArchive_Archive_C:OnKeyUp(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        -- DebugPrint("zwkkk    Key_IsGamepadKey", InKeyName)
        IsEventHandled = self:Handle_OnGamePadUp(InKeyName)
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

-- 手柄按键松开
function WBP_ModArchive_Archive_C:Handle_OnGamePadUp(InKeyName)
    DebugPrint("zwkkk  Handle_OnGamePadUp", InKeyName, self:GetName())
    if (InKeyName == "Gamepad_FaceButton_Bottom") then  -- 确定
        -- if self.CanFocusTips and not self.IsInViewTips and #self.Access > 0 then
        --     self.IsInViewTips = true
        --     self.Access[1]:SetFocus()
        -- end
        return true
    end
    return false
end

function WBP_ModArchive_Archive_C:OnResourceBarAddedToFocusPath()
    DebugPrint("zwkkkkk OnResourceBarAddedToFocusPath")
    self:EnterResourceSelectMode()
    self.Node_ResourceBar:UpdateResource()
end

function WBP_ModArchive_Archive_C:OnResourceBarRemovedFromFocusPath()
    DebugPrint("zwkkkkk OnResourceBarRemovedFromFocusPath")
    -- if self.IsFocusInResourceBar then
    --     self:ExitResourceSelectMode()
    -- end
    self:ExitResourceSelectMode()
end

function WBP_ModArchive_Archive_C:EnterResourceSelectMode()
    -- 进入资源选择
    if (self.CurInputDeviceType == ECommonInputType.Gamepad) then
        self.ArchiveTab.Key_Left:SetVisibility(UIConst.VisibilityOp["Hidden"])
        self.ArchiveTab.Key_Right:SetVisibility(UIConst.VisibilityOp["Hidden"])
        -- self.IsFocusInResourceBar = true
    end
end

function WBP_ModArchive_Archive_C:ExitResourceSelectMode()
    -- 离开资源选择
    if (self.CurInputDeviceType == ECommonInputType.Gamepad) then
        self.ArchiveTab.Key_Left:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.ArchiveTab.Key_Right:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        DebugPrint("zwkkkkk 离开资源选择",self.CurGroupIndex, self.CurSelectedItemIndex)
        -- self:AddDelayFrameFunc(function()
        --     if self.CurGroupIndex and self.CurSelectedItemIndex then
        --         -- local PreGroup = self.List_ModArchive:GetItemAt(self.CurGroupIndex - 1)
        --         -- if PreGroup and PreGroup.SelfWidget then
        --         --     DebugPrint("zwkkkkk PreGroup",self.CurGroupIndex, self.CurSelectedItemIndex)
        --         --     PreGroup.SelfWidget.Mods[self.CurSelectedItemIndex]:SetFocus()
        --         -- end
        --         local PreGroup = self.Widgets[self.CurGroupIndex]
        --         if PreGroup then
        --             PreGroup.Mods[self.CurSelectedItemIndex]:SetFocus()
        --             self.IsFocusInResourceBar = false
        --         end
        --     end
        -- end, 1, "OnExitResourceSelectMode")
    end
end

function WBP_ModArchive_Archive_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
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

function WBP_ModArchive_Archive_C:UpdateOnInputDeviceTypeChange()
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        if self.Widgets[self.CurGroupIndex] and self.Widgets[self.CurGroupIndex].Key_TitleReward and not self.Widgets[self.CurGroupIndex].Item_Title:HasAnyUserFocus() then
            self.Widgets[self.CurGroupIndex].Key_TitleReward:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
        self.Key_Rewards:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    elseif self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard then
        -- PC
        if self.Widgets[self.CurGroupIndex] and self.Widgets[self.CurGroupIndex].Key_TitleReward then
            self.Widgets[self.CurGroupIndex].Key_TitleReward:SetVisibility(ESlateVisibility.Collapsed)
        end
        if self.Key_Rewards then
            self.Key_Rewards:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
end

function WBP_ModArchive_Archive_C:OnSwitchToGamepad()
    if self.CurGroupIndex and self.CurSelectedItemIndex then
        self.List_ModArchive:SetSelectedIndex(self.CurGroupIndex - 1)
        self.List_ModArchive:ScrollIndexIntoView(self.CurGroupIndex - 1)
        self:AddDelayFrameFunc(function()
            self.Widgets[self.CurGroupIndex]:SetItemSelected(self.CurSelectedItemIndex)
            self.Widgets[self.CurGroupIndex].Mods[self.CurSelectedItemIndex]:SetFocus()
        end, 2, "DelayReturnFocusCurItem")
    else
        self.List_ModArchive:SetSelectedIndex(0)
        self.List_ModArchive:ScrollIndexIntoView(0)
        self:AddDelayFrameFunc(function()
            self.Widgets[1]:SetItemSelected(1)
            self.Widgets[1].Mods[1]:SetFocus()
        end, 2, "DelayReturnFocusCurItem")
    end
end


return WBP_ModArchive_Archive_C
