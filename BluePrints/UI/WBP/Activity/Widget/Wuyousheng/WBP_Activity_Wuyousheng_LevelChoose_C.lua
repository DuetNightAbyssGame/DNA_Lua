--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_Wuyousheng_LevelChoose_P_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

M._components = {
    "BluePrints.UI.WBP.Activity.Widget.Wuyousheng.WBP_Activity_Wuyousheng_LevelChoose_C_GamepadComp",
}

function M:Construct()
    self.Btn_Start.Btn_Click.OnClicked:Add(self, self.BtnStartOnClicked)
    self.Btn_Start.Btn_Click.OnPressed:Add(self, self.BtnStartOnPressed)
    self:InitLevelList()
    local DefaultSelectIndex = 1
    for i = 1, #self.DungeonList do
        if self.DungeonList[i] == self.Root.DungeonId then
            DefaultSelectIndex = i
            break
        end
    end
    self:RefreshLevelInfo(self.DungeonList[DefaultSelectIndex], DefaultSelectIndex, nil)
    self.SelectedIndex = DefaultSelectIndex
    self.Root.SelectedDungeonId = self.DungeonList[DefaultSelectIndex]

    self.Btn_Start.Text_Btn:SetText(GText("UI_WuyoushengEvent_GoToEdit"))
    self:InitGamePad()
    self:AddTimer(0.1, function()
        self:OnUpdateUIStyleByInputTypeChange(self.Root.CurInputDevice, self.Root.CurGamepadName)
    end)
    self.EMScrollBox_List.OnUserScrolled:Add(self, self.OnListViewLevelTabScrolled)
    self:AddTimer(0.1, function()
        self:OnListViewLevelTabScrolled()
    end)
end

function M:OnListViewLevelTabScrolled()
    UIUtils.UpdateScrollBoxArrow(self.EMScrollBox_List, self.List_ArrowTop, self.List_ArrowBottom)
end

function M:BtnStartOnClicked()
    if self.Btn_Start.Btn_Click:GetForbidden() then
        return
    end
    self.Root:OpenSubUI({Idx = "ActivityWuyoushengTeamBuild"}, self.Root.SelectedDungeonId)
end

function M:BtnStartOnPressed()
    if self.Btn_Start.Btn_Click:GetForbidden() then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/activity/wuyoudaguai_btn_click_enter_sub_page", nil, nil)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = true

    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsHandled = self:HandleGamepadInput(InKeyName)
    else
        if (InKeyName == "Escape") then
            self:OnReturnKeyDown()
        else
            IsHandled = false
        end
    end
    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnReturnKeyDown()
    self.Root:OpenSubUI(self.PreWidgetInfo,false,self.AbyssId,true)
end

function M:SwitchIn(...)
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self:PlayAnimation(self.In)
    self:InitTable()
    self:InitLevelList()
    self.Root.RewardText:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function M:SwitchOut()
    if not self.BindOutAnimation then
        self:BindToAnimationFinished(self.Next, {self,function()
            self:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        })
        self.BindOutAnimation = true
    end
    self:PlayAnimation(self.Next)
end

function M:InitTable()
    self.TabConfigData = {
        TitleName= GText("UI_Title_WuyoushengEvent"),
        DynamicNode={"Back", "BottomKey", "ResourceBar"}, 
        StyleName="Text", OwnerPanel=self.Root, BackCallback=self.Root.OnReturnKeyDown,
        BottomKeyInfo = { { KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.Root.OnReturnKeyDown, Owner=self.Root,}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, Desc = GText("UI_BACK"), bLongPress = false}},
    }
    self.Root:InitOtherPageTab(self.TabConfigData, nil, true)
end

function M:InitLevelList()
    if not self.Root or not self.Root.EventId then
        return
    end
    
    local EventId = self.Root.EventId
    self.DungeonList = {}
    
    -- 获取该活动的所有关卡ID
    for DungeonId, Conf in pairs(DataMgr.WuyoushengEventLevel) do
        if Conf.EventId == EventId then
            table.insert(self.DungeonList, DungeonId)
        end
    end
    
    -- 按关卡ID大小排序
    table.sort(self.DungeonList, function(a, b)
        return a < b
    end)
    
    -- 清空列表
    if self.HB_List then
        self.HB_List:ClearChildren()
    end
    
    -- 保存创建的 Widget 列表
    self.LevelTabWidgetList = {}
    self.LevelTabList = {}
    
    -- 两个一组添加Item
    local EventId = self.Root and self.Root.EventId
    for i = 1, #self.DungeonList, 2 do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.ParentWidget = self
        Content.DungeonId1 = self.DungeonList[i]
        Content.DungeonId2 = self.DungeonList[i + 1]  -- 如果是奇数，这里会是nil
        Content.Index1 = i
        Content.Index2 = i + 1
        Content.EventId = EventId
        local Widget = UIManager(self):CreateWidget("WidgetBlueprint'/Game/UI/WBP/Activity/Widget/Wuyousheng/WBP_Activity_Wuyousheng_LevelTabGroup.WBP_Activity_Wuyousheng_LevelTabGroup'")
        Widget:OnListItemObjectSet(Content)
        self.HB_List:AddChildToHorizontalBox(Widget)
        table.insert(self.LevelTabWidgetList, Widget)
        table.insert(self.LevelTabList, Widget.LevelTab_1)
        table.insert(self.LevelTabList, Widget.LevelTab_2)
    end
    
    -- 设置导航规则
    self:SetupLevelTabNavigation()
end

function M:SetupLevelTabNavigation()
    if not self.LevelTabWidgetList or #self.LevelTabWidgetList == 0 then
        return
    end
    
    local WidgetCount = #self.LevelTabWidgetList
    
    for i = 1, WidgetCount do
        local Widget = self.LevelTabWidgetList[i]
        if not Widget then
            goto continue
        end
        
        local LevelTab_1 = Widget.LevelTab_1
        local LevelTab_2 = Widget.LevelTab_2
        
        -- 设置 LevelTab_1 和 LevelTab_2 之间的导航（如果 LevelTab_2 存在）
        if LevelTab_1 and LevelTab_2 and LevelTab_2:GetVisibility() ~= ESlateVisibility.Collapsed then
            -- LevelTab_1 的 Right 导航到 LevelTab_2
            LevelTab_1:SetNavigationRuleExplicit(EUINavigation.Right, LevelTab_2)
            -- LevelTab_2 的 Left 导航到 LevelTab_1
            LevelTab_2:SetNavigationRuleExplicit(EUINavigation.Left, LevelTab_1)
        end
        
        -- 第一个 Widget 的 LevelTab_1 的 Left 设置为 Stop
        if i == 1 and LevelTab_1 then
            LevelTab_1:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
        end
        
        -- 最后一个 Widget 的最后一个 Tab 的 Right 设置为 Stop
        if i == WidgetCount then
            local LastTab = nil
            if LevelTab_2 and LevelTab_2:GetVisibility() ~= ESlateVisibility.Collapsed then
                LastTab = LevelTab_2
            elseif LevelTab_1 then
                LastTab = LevelTab_1
            end
            if LastTab then
                LastTab:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
            end
        end
        
        -- 设置相邻 Widget 之间的导航
        if i < WidgetCount then
            local NextWidget = self.LevelTabWidgetList[i + 1]
            if NextWidget and NextWidget.LevelTab_1 then
                -- 当前 Widget 的最后一个 Tab
                local CurrentLastTab = nil
                if LevelTab_2 and LevelTab_2:GetVisibility() ~= ESlateVisibility.Collapsed then
                    CurrentLastTab = LevelTab_2
                elseif LevelTab_1 then
                    CurrentLastTab = LevelTab_1
                end
                
                -- 下一个 Widget 的第一个 Tab
                local NextFirstTab = NextWidget.LevelTab_1
                
                if CurrentLastTab and NextFirstTab then
                    -- 当前 Widget 的最后一个 Tab 的 Right 导航到下一个 Widget 的 LevelTab_1
                    CurrentLastTab:SetNavigationRuleExplicit(EUINavigation.Right, NextFirstTab)
                    -- 下一个 Widget 的 LevelTab_1 的 Left 导航到当前 Widget 的最后一个 Tab
                    NextFirstTab:SetNavigationRuleExplicit(EUINavigation.Left, CurrentLastTab)
                end
            end
        end
        
        ::continue::
    end
end

function M:RefreshLevelInfo(DungeonId, Index, EndTime)
    local WuyoushengEventLevelData = DataMgr.WuyoushengEventLevel[DungeonId]
    if not WuyoushengEventLevelData then
        return
    end
    self.Text_Title:SetText(GText(WuyoushengEventLevelData.LevelName))
    self.Text_Desc:SetText(GText(WuyoushengEventLevelData.LevelDes))
    self.Text_LevelEffectDesc:SetText(GText(WuyoushengEventLevelData.LevelBuffDes))
    self.Text_GoalTitle:SetText(GText("UI_WuyoushengEvent_LevelTarget"))
    self.Text_LevelEffectTitle:SetText(GText("UI_WuyoushengEvent_LevelBuff"))
    self.Text_MonsterDetailTitle:SetText(GText("UI_WuyoushengEvent_PetDetail"))
    self.Text_SubTitleNum:SetText(Index)
    self.Text_TitleIndex:SetText(WuyoushengEventLevelData.LevelIconLetter)

    local Avatar = GWorld:GetAvatar()
    local WuyoushengData = Avatar.WuyoushengActivity[self.Root.EventId]
    local FinishStars = 0
    if WuyoushengData then
        FinishStars = WuyoushengData:GetFinishStars(DungeonId) or 0
    end
    -- 关卡目标
    for i = 1,3 do
        local GoalData = self["GoalStarItem_" .. i]
        local LevelGoalRequiredTime1 = WuyoushengEventLevelData.LevelGoalRequiredTime1[i]
        local GoalText = nil
        if LevelGoalRequiredTime1 == -1  then
            GoalText = GText("Wuyousheng_Target_FinishLevel")
        else
            GoalText = string.format(GText("Wuyousheng_Target_LevelLimitTime"), LevelGoalRequiredTime1)
        end
        GoalData.Text_GoalDesc:SetText(GoalText)
        if FinishStars >= i then
            GoalData.StarSubItem.Normal:SetVisibility(UIConst.VisibilityOp.Collapsed)
            GoalData.StarSubItem.Light:SetVisibility(UIConst.VisibilityOp.Visible)
        else
            GoalData.StarSubItem.Normal:SetVisibility(UIConst.VisibilityOp.Visible)
            GoalData.StarSubItem.Light:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    end

    -- 宠物详情
    self.MonsterList:ClearChildren()
    local PetCount = 0
    self.WidgetList = {}
    local PetNum = #WuyoushengEventLevelData.LevelPet
    if self.PetNum ~= PetNum then
        self.PetNum = PetNum
        self.WBP_Activity_Wuyousheng_BG02.Spine_Char:SetAnimation(0,"In"..PetNum,false)
        self.WBP_Activity_Wuyousheng_BG02.Spine_Char:AddAnimation(0,"Loop"..PetNum,true,0)
        AudioManager(self):PlayUISound(self, "event:/ui/activity/wuyoudaguai_sub_page_in", nil, nil)
    end
    for i = 1,PetNum do
        local PetId = WuyoushengEventLevelData.LevelPet[i]
        local Widget = self:CreateWidgetNew("ComItemUniversalM")
        local PetData = DataMgr.Pet[PetId]
        self.WidgetList[i] = Widget
        if PetData then
            local Content = {
                Id = PetId,
                ItemType = "Pet",
                Rarity = PetData.Rarity,
                Icon = PetData.Icon,
                IsShowDetails = true,
            }
            Content.OnMenuOpenChangedEvents = 
            {
                Obj = self,
                Callback = self.ItemMenuAnchorChanged
            }
            Widget:Init(Content)
            self.MonsterList:AddChildToWrapBox(Widget)
            PetCount = PetCount + 1
        end
    end
    
    -- 填充空态（补齐最后一行）
    -- 假设每行显示5个，如果WrapBox的实际每行数量不同，可以后续调整
    local ItemsPerRow = 5
    local EmptyCount = (ItemsPerRow - (PetCount % ItemsPerRow)) % ItemsPerRow
    if EmptyCount > 0 then
        for i = 1, EmptyCount do
            local EmptyWidget = self:CreateWidgetNew("ComItemUniversalM")
            local EmptyContent = {
                bEmpty = true,
            }
            EmptyWidget:Init(EmptyContent)
            self.MonsterList:AddChildToWrapBox(EmptyWidget)
        end
    end
    if EndTime and EndTime > TimeUtils.NowTime() then
        self.Btn_Start.Btn_Click:SetForbidden(true)
        local TimeStr = UIUtils.GetLeftTimeStrStyle1(EndTime)
        self.Btn_Start.Text_Btn:SetText(string.format(GText("UI_WuyoushengEvent_Lock_Time"),TimeStr))
    else
        self.Btn_Start.Btn_Click:SetForbidden(false)
        self.Btn_Start.Text_Btn:SetText(GText("UI_WuyoushengEvent_GoToEdit"))
    end
end

function M:ItemMenuAnchorChanged(bIsOpen)
    if not self.IsUseGamePad then
        return
    end
    if bIsOpen then
        self:ChangeFocusMode(3)
    else
        self:ChangeFocusMode(2)
    end
end

AssembleComponents(M)

return M
