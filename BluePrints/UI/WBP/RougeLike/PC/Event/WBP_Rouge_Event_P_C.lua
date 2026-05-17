--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local TalkUtils = require "BluePrints.Story.Talk.View.TalkUtils"

---@type WBP_Rouge_Event_P_C
local M = Class("BluePrints.UI.BP_UIState_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    --策划定的规则，写死
    self.DialogueList = {}
    self.Btn_Next.OnClicked:Add(self, self.OnIteratorDialogue)
    self.CanInteractChoices = true
    self.Callback = function ()
        if not IsValid(self) then
            return
        end
        if self.NextEventId then --如果有下一个事件，切换下一个事件
            self.StoryPath = DataMgr.RougeLikeRoom[self.NextEventId].EventStoryline
            self.NextEventId = nil
            self.CurStory = GWorld.StoryMgr:RunStory(self.StoryPath, nil, nil, self.Callback, self.Callback)
        elseif type(self.ArchiveInfo) == "table" and not self.IsRealClose then --否则如果是事件图鉴来的，重启本事件
            self:ReplayThisEvent()
        else
            self:Close()
        end
    end
    self:BindToAnimationFinished(self.Slow_In, {self, function()
        self.CurStory = GWorld.StoryMgr:RunStory(self.StoryPath, nil, nil, self.Callback, self.Callback)
    end})
    self:BindToAnimationFinished(self.Fast_In, {self, function()
        self.CurStory = GWorld.StoryMgr:RunStory(self.StoryPath, nil, nil, self.Callback, self.Callback)
    end})
    -- 这几个class挪到蓝图初始化
    --self.ChatItem = UE4.UClass.Load("WidgetBlueprint'/Game/UI/WBP/RougeLike/Widget/Event/WBP_Rouge_EventChat.WBP_Rouge_EventChat'")
    --self.EventSelectItem = UE4.UClass.Load("WidgetBlueprint'/Game/UI/WBP/RougeLike/Widget/Event/WBP_Rouge_EventSelection.WBP_Rouge_EventSelection'")
    --self.EventSelectItemNormal = UE4.UClass.Load("WidgetBlueprint'/Game/UI/WBP/RougeLike/Widget/Event/WBP_Rouge_EventSelection_Normal.WBP_Rouge_EventSelection_Normal'")
    
    self.List_Chat:ClearChildren()
    local Avatar = GWorld:GetAvatar()
    self.CoinId = Avatar and Avatar:GetCurrentRougeLikeTokenId() or 0
    self.IsSkipping = false
    self.CanInteractDialogue = false
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
    local Param = ...
    if Param[1] then
        self.RoomId = Param[1]
    elseif GWorld.RougeLikeManager then 
        self.RoomId = GWorld.RougeLikeManager.RoomId
    end
    if Param[2] then
        self.StoryId = Param[2]
    end
    if Param[3] then
        self.ArchiveInfo = Param[3] --从Archive打开的Event传来的是table，Story传来的是bool
        if type(self.ArchiveInfo) == "table" then
            self.IsArchiveEvent = true 
        end
    end
    if Param[4] then
        self.IsClientEvent = Param[4]
    end
    if Param[5] then
        self.HideResourceBar = Param[5]
    end
    DebugPrint(self.RoomId, "房间ID")
    -- 逻辑层
    self:SetFocus()
    self:InitListenEvent()
    if(self.StoryId) then
        self.StoryPath = DataMgr.RougeLikeStoryEvent[self.StoryId].EventStoryline
    else
        self.StoryPath = DataMgr.RougeLikeRoom[self.RoomId].EventStoryline
    end
    DebugPrint("读取的StoryPath", self.StoryPath)
    
    
    -- 表现层
    self:InitBagBtn()
    self:InitSkipBtn()
    self:InitResourceBar()
    self:UpdateBottomKeyInfo()
    
    AudioManager(self):PlayUISound(self, "event:/ui/roguelike/level_event_show", "SwitchRougeEvent", nil)
    local EventBG
    local RoomTypeName
    local RoomName
    if(self.StoryId) then
        EventBG = DataMgr.RougeLikeStoryEvent[self.StoryId].EventMainIcon
        RoomTypeName = DataMgr.RougeLikeStoryEvent[self.StoryId].StoryEventType
        RoomName = DataMgr.RougeLikeStoryEvent[self.StoryId].StoryEventName
        self.Panel_StoryEvent:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Panel_NormalEvent:SetVisibility(ESlateVisibility.Collapsed)
    else
        EventBG = DataMgr.RougeLikeRoom[self.RoomId].EventMainIcon
        local RoomType = DataMgr.RougeLikeRoom[self.RoomId].RoomType
        RoomTypeName = DataMgr.RougeLikeRoomType[RoomType].Name
        RoomName = DataMgr.RougeLikeRoom[self.RoomId].Name
        self.Panel_StoryEvent:SetVisibility(ESlateVisibility.Collapsed)
        self.Panel_NormalEvent:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    if EventBG then
        self.LastEventBG = EventBG
        UE.UResourceLibrary.LoadObjectAsync(self,EventBG,{self,M.OnEventBGIconLoadFinish})
    end
    
    self.Text_Type:SetText(GText(RoomTypeName))
    self.Text_Name:SetText(GText(RoomName))
    if self.ArchiveInfo then
        self:InitArchiveGroup()
        if self.IsArchiveEvent then
            self:InitEventList()
        else
            self.VB_List:SetVisibility(ESlateVisibility.Collapsed)
        end
        self.Text_EventEmpty:SetText(GText("RLArchive_EventUnlock"))
    end
    
    self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
end

function M:InitResourceBar()
    if self.HideResourceBar then
        self.Panel_ResourceBar:SetVisibility(ESlateVisibility.Collapsed)
        return
    end
    self.Panel_ResourceBar:ClearChildren()
    self.ResourceBarWidget = self:CreateWidgetNew("ResourceBarNode")
    self.Panel_ResourceBar:AddChild(self.ResourceBarWidget)
    self.ResourceBarWidget:InitResourceBar({self.CoinId})
    local ResourceBarIcon = UIUtils.UtilsGetKeyIconPathInGamepad("RS", "Generic")
    self.ResourceBarWidget:SetGamePadKeyImgByPath(ResourceBarIcon)
end

function M:InitBagBtn()
    -- 肉鸽背包
    if self.HideResourceBar then
        self.Btn_Bag:SetVisibility(ESlateVisibility.Collapsed)
        return
    end
    if self.Btn_Bag then
        self.Btn_Bag.Text_Btn:SetText(GText("UI_RougeLike_Bag"))
        self.Btn_Bag.Btn_Click.OnClicked:Add(self, function()
            AudioManager(self):PlayUISound(self, "event:/ui/roguelike/btn_black_small_click", nil, nil)
            UIManager(self):LoadUINew('RougeBag')
        end)
        self.Btn_Bag.Btn_Click.OnHovered:Add(self, function()
            AudioManager(self):PlayUISound(self, "event:/ui/roguelike/btn_black_hover", nil, nil)
        end)
        self.Btn_Bag.Key_Bag:CreateCommonKey({
            KeyInfoList = {{Type = "Img", ImgShortPath = "Menu"}}
        })
    end
end

function M:InitSkipBtn()
    -- 初始化跳过按钮
    if self.Btn_Skip then
        self.Btn_Skip:BindEventOnClicked(self, self.SkipEvent)
        self.Btn_Skip:SetCurrentTextBlock(GText("UI_TALK_SKIP_MOIILE"))
    end
end

-- 手柄按键提示
function M:UpdateBottomKeyInfo()
    if self.Btn_Skip then
        if not self.ArchiveInfo then
            self.Btn_Skip:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        else
            self.Btn_Skip:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
    if not self.Com_KeyTips then
        return
    end
    if self.ArchiveInfo then
        self.Com_KeyTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self.Com_KeyTips:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self.Com_KeyTips:UpdateKeyInfo({
            {
                KeyInfoList = {{Type = "Img", ImgShortPath = "RV"}},
                Desc = GText("UI_Controller_Slide")
            },
            {
                KeyInfoList = {{Type = "Img", ImgShortPath = "X"}},
                Desc = GText("UI_TALK_SKIP_MOIILE"),
            },
            {
                KeyInfoList = {{Type = "Img", ImgShortPath = "A"}},
                Desc = GText("UI_Tips_Ensure")
            },
        })
    else
        self.Com_KeyTips:UpdateKeyInfo({
            {
                KeyInfoList = {{Type="Text", Text="Space", ClickCallback=self.SkipEvent, Owner=self}},
                Desc = GText("UI_TALK_SKIP"),
                bLongPress = true,
            },
            {
                KeyInfoList = {{Type="Text", Text="Space", ClickCallback=self.OnIteratorDialogue, Owner=self}},
                Desc = GText("UI_REGISTER_CONTINUE")
            },
        })
    end
end

function M:HideSkipKeyInfo()
    if self.Btn_Skip then
        self.Btn_Skip:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.IsSkipKeyHide = true
    if not self.Com_KeyTips then
        return
    end
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self.Com_KeyTips:UpdateKeyInfo({
            {
                KeyInfoList = {{Type = "Img", ImgShortPath = "RV"}},
                Desc = GText("UI_Controller_Slide")
            },
            {
                KeyInfoList = {{Type = "Img", ImgShortPath = "A"}},
                Desc = GText("UI_Tips_Ensure")
            },
        })
    else
        if self.Com_KeyTips.Panel_Key:GetChildAt(0) then
            self.Com_KeyTips.Panel_Key:GetChildAt(0):OnButtonReleased()
        end
        self.Com_KeyTips:UpdateKeyInfoNew({})
    end
end

function M:InitArchiveGroup()
    self.Group_Archive:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self)
    local ComTab = self.Com_Tab_P or self.Com_Tab_M
    local TabConfigData = {
        PlatformName = self.PlatformName,
        DynamicNode = {"Back", "BottomKey"},
        StyleName = "Text",
        OwnerPanel = self,
        BackCallback = self.ArchiveClose,
        BottomKeyInfo = {
            {
                GamePadInfoList = {{Type = "Img", ImgShortPath = "RV"}},
                Desc = GText("UI_Controller_Slide"),
                bLongPress = false
            },
            {
                GamePadInfoList = {{Type = "Img", ImgShortPath = "A"}},
                Desc = GText("UI_Tips_Ensure"),
                bLongPress = false
            },
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.ArchiveClose, Owner=self,}},
                GamePadInfoList = {{Type="Img", ImgShortPath="B"}},
                Desc = GText("UI_BACK"),
                bLongPress = false
            },
        },
    }
    if self.StoryId then
        TabConfigData.TitleName = string.format(GText("RLArchive_StorySubtitle"), self.Text_Name:GetText())
    else
        TabConfigData.TitleName = string.format(GText("RLArchive_EventSubtitle"), self.Text_Name:GetText())
    end
    ComTab:Init(TabConfigData)
    self.Btn_Bag:SetVisibility(ESlateVisibility.Collapsed)
    self.Panel_ResourceBar:SetVisibility(ESlateVisibility.Collapsed)
end

function M:InitEventList()
    self.VB_List:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.List_EventTab:ClearListItems()
    local CurIndex
    for Index, Data in ipairs(self.ArchiveInfo) do
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        Obj.Index = Index - 1
        Obj.IsUnlocked = Data.IsUnlocked
        Obj.Name = Data.Name
        Obj.EventId = Data.EventId
        Obj.IsSelected = Obj.EventId == self.RoomId
        Obj.Parent = self
        self.List_EventTab:AddItem(Obj)
        if Obj.IsSelected then
            CurIndex = Index - 1
        end
    end
    self:AddDelayFrameFunc(function()
        self.List_EventTab:SetSelectedIndex(CurIndex)
    end, 2)
end

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == "Gamepad_RightY") then
        local a = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
        local CurScrollOffset = self.List_Chat:GetScrollOffset()
        local ScrollOffset = math.clamp(CurScrollOffset - a, 0, self.List_Chat:GetScrollOffsetOfEnd())
        self.List_Chat:SetScrollOffset(ScrollOffset)
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InputEvent = UWidgetBlueprintLibrary.GetInputEventFromKeyEvent(InKeyEvent)
    local IsRepeat = UKismetInputLibrary.InputEvent_IsRepeat(InputEvent)
    if(IsRepeat)then
        return UIUtils.UnHandled
    end
    local IsEventHandled=false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == "SpaceBar" and not self.ArchiveInfo then
        IsEventHandled = true
        if not self.IsSkipKeyHide then
            self:SetFocus()
            self.Com_KeyTips.Panel_Key:GetChildAt(0):OnButtonPressed(nil, true, 0, 0.5)
        end
    end
    if IsEventHandled then
        return UIUtils.Handled
    else
        return UIUtils.UnHandled
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    DebugPrint(InKeyName, "@zyh")
    if InKeyName == Const.GamepadSpecialRight then
        UIManager(self):LoadUINew('RougeBag')
    elseif InKeyName == Const.GamepadFaceButtonLeft and not self.ArchiveInfo and not self.IsSkipKeyHide then
        self:SkipEvent()
    elseif InKeyName == Const.GamepadRightThumbstick then
        self.ResourceBarWidget:SetLastFocusWidget(self.FirstSelectItem or self.Btn_Next)
        self.ResourceBarWidget:SetFocus()
    elseif InKeyName == "Escape" or InKeyName == Const.GamepadFaceButtonRight then
        if self.ArchiveInfo then
            self:ArchiveClose()
        end
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    DebugPrint(InKeyName, "OnKeyUp @zyh")
    if InKeyName == "SpaceBar" and not self.ArchiveInfo then
        if not self.IsSkipKeyHide then
            self.Com_KeyTips.Panel_Key:GetChildAt(0):OnButtonReleased()
        end
        self:OnIteratorDialogue()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnLoaded(...)
    self.Super.OnLoaded(...)
    if self.ArchiveInfo then
        self:PlayAnimation(self.Fast_In)
    else
        self:PlayAnimation(self.Slow_In)
    end

    self:PlayAnimation(self.Loop, 0, 0)
    self.Event:PlayAnimation(self.Event.Loop, 0, 0)
end

function M:OnEventBGIconLoadFinish(Object)
    if IsValid(self) and Object then
        if self.StoryId then
            local StoryEventMat = self.Img_StoryEvent:GetDynamicMaterial()
            StoryEventMat:SetTextureParameterValue("MainTex", Object)
        else
            local EventItemMat = self.Event.Img_Icon:GetDynamicMaterial()
            local EventBgMat = self.Img_Event:GetDynamicMaterial()
            local EventIconColorMat = self.Event.Img_Icon_Color:GetDynamicMaterial()
            EventItemMat:SetTextureParameterValue("IconMap", Object)
            EventBgMat:SetTextureParameterValue("IconMap", Object)
            EventIconColorMat:SetTextureParameterValue("DissolveTex", Object)
            local EventOldItemMat = self.Event_Old.Img_Icon:GetDynamicMaterial()
            local EventOldIconColorMat = self.Event_Old.Img_Icon_Color:GetDynamicMaterial()
            EventOldItemMat:SetTextureParameterValue("IconMap", Object)
            EventOldIconColorMat:SetTextureParameterValue("DissolveTex", Object)
            local EventStackItemMat = self.Event_Stack.Img_Icon:GetDynamicMaterial()
            local EventStackIconColorMat = self.Event_Stack.Img_Icon_Color:GetDynamicMaterial()
            EventStackItemMat:SetTextureParameterValue("IconMap", Object)
            EventStackIconColorMat:SetTextureParameterValue("DissolveTex", Object)
        end
    end
end

function M:OnLastEventBGIconLoadFinish(Object)
    if not Object or not IsValid(self) then return end
    local StoryEventMat = self.Img_StoryEvent_F:GetDynamicMaterial()
    StoryEventMat:SetTextureParameterValue("MainTex", Object)
end

function M:InitListenEvent()
    self:AddDispatcher(EventID.OnHomeBaseBtnPlayAnim, self, self.SetFocusWhenCloseAward)
    self:AddDispatcher(EventID.OnRougeDisplayDialogue, self, self.OnRougeDisplayDialogue) -- dialogue结构 
    self:AddDispatcher(EventID.OnRougeDisplayOptions, self, self.OnRougeDisplayOptions) -- OptionText的表
    self:AddDispatcher(EventID.OnRougeEventGetToken, self, self.OnRougeGetToken)
end

function M:OnRougeDisplayDialogue(DialogueData)
    self.CanInteractDialogue = true
    
    local DialogueId = DialogueData.DialogueId
    local TalkActorName = GText(DataMgr.Dialogue[DialogueId].SpeakNpcName)
    local TalkActorId = DialogueData.TalkActorId
    if not TalkActorName and TalkActorId then -- 如果拿不到SpeakNpcName,再去Npc表查
        TalkActorName = self:GetDialogueSpeakerName(DialogueData)
    end
    local CurrentTalkType = DataMgr.Dialogue[DialogueId].RougeTalkActorType -- 1=Npc 2=主角 3=旁白
    DebugPrint("回调OnRougeDisplayDialogue","说话者信息：", TalkActorName, TalkActorId, CurrentTalkType, "说话内容:", DialogueData.Content)
    local RougeDialogueMainIcon = DataMgr.Dialogue[DialogueId].RougeDialogueMainIcon
    if RougeDialogueMainIcon then
        self.RougeDialogueMainIcon = RougeDialogueMainIcon
        self:PlayAnimation(self.Story_Change)
        UE.UResourceLibrary.LoadObjectAsync(self,self.RougeDialogueMainIcon,{self,M.OnEventBGIconLoadFinish})
        UE.UResourceLibrary.LoadObjectAsync(self,self.LastEventBG,{self,M.OnLastEventBGIconLoadFinish})
        self.LastEventBG = self.RougeDialogueMainIcon
    end
    --if self.IsDelayDialogue then
    --    self.DelayDialogue = {
    --        TalkActorName = TalkActorName,
    --        CurrentTalkType = CurrentTalkType,
    --        Content = DialogueData.Content
    --    }
    --    return
    --end
    self:AddDialogue(TalkActorName, CurrentTalkType, DialogueData.Content)
    if not self.ArchiveInfo and self.IsSkipKeyHide then
        self.IsSkipKeyHide = false
        self:UpdateBottomKeyInfo()
    end
    if self.IsSkipping and DialogueData.IsLastText then
        self:StopSkipEvent()
    end
end

function M:AddDialogue(TalkActorName, CurrentTalkType, Content, IsAnswer)
    AudioManager(self):PlayUISound(self, "event:/ui/roguelike/level_event_line_pop_up", nil, nil)
    local OneChatInfo = {
        TalkActorName = TalkActorName,
        CurrentTalkType = CurrentTalkType,
        Content = Content,
        IsAnswer = IsAnswer,
        Parent = self,
    }
    local OneChatItem
    if IsAnswer then
        OneChatItem = UE4.UWidgetBlueprintLibrary.Create(self, self.ChatSelectionItem)
    else
        OneChatItem = UE4.UWidgetBlueprintLibrary.Create(self, self.ChatItem)
    end
    self.List_Chat:AddChild(OneChatItem)
    OneChatItem:InitUI(OneChatInfo)
    self.LastChatItem = OneChatItem
    self.Arrow:SetVisibility(ESlateVisibility.HitTestInvisible)
    if not IsAnswer then
        self:AddDelayFrameFunc(function()
            self.List_Chat:ScrollWidgetIntoView(self.LastChatItem, true)
        end, 2)
    end
    ------------------ 手柄端 -----------------------
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        local FocusItem
        FocusItem = type(self.ArchiveInfo) == "table" and self.List_EventTab or self.Btn_Next
        FocusItem:SetFocus()
    end
end

function M:OnRougeDisplayOptions(OptionTexts)
    AudioManager(self):PlayUISound(self, "event:/ui/roguelike/level_event_select_btn_show", nil, nil)
    self.CanInteractDialogue = false
    self.Arrow:SetVisibility(ESlateVisibility.Collapsed)
    self.OptionTexts = OptionTexts
    self.WBox_Selection:ClearChildren()
    self.OptionsNum = CommonUtils.Size(OptionTexts)
    for Index = 1, self.OptionsNum do
        local SelectResultDesc
        local SelectId

        if self.StoryId then -- 剧情事件
            if DataMgr.RougeLikeStoryEvent[self.StoryId].SelectResultDesc and DataMgr.RougeLikeStoryEvent[self.StoryId].SelectResultDesc[Index] then
                SelectResultDesc = GText(DataMgr.RougeLikeStoryEvent[self.StoryId].SelectResultDesc[Index])
            end
        elseif OptionTexts[Index].IsKeyOption then -- 普通事件关
            SelectId = DataMgr.RougeLikeRoom[self.RoomId].EventSelect[tonumber(Index)]
            SelectResultDesc = GText(DataMgr.RougeLikeEventSelect[SelectId].SelectResultDesc)
        end
        local IsKeyOption = OptionTexts[Index].IsKeyOption
        local SelectionInfo = {
            SelectionText = OptionTexts[Index].Text,
            IsKeyOption = IsKeyOption,
            DescribeText = SelectResultDesc,
            SelectId = SelectId,
            DialogueId = OptionTexts[Index].DialogueId,
            SelectIndex = Index,
            IsFromArchive = self.ArchiveInfo,
            Parent = self,
        }
        local SelectionItem
        if SelectionInfo.IsKeyOption and SelectResultDesc then
            SelectionItem = UE4.UWidgetBlueprintLibrary.Create(self, self.EventSelectItem)
        else
            SelectionItem = UE4.UWidgetBlueprintLibrary.Create(self, self.EventSelectItemNormal)
        end
        self.WBox_Selection:AddChild(SelectionItem)
        SelectionItem:InitUI(SelectionInfo)
        if Index == 1 then
            self.FirstSelectItem = SelectionItem
        end
        if type(self.ArchiveInfo) == "table" then
            SelectionItem.Btn_Click:SetNavigationRuleExplicit(EUINavigation.Left, self.List_EventTab)
            self.List_EventTab:SetNavigationRuleExplicit(EUINavigation.Right, self.FirstSelectItem)
        end
    end
    
    -- 手柄聚焦相关
    self:AddDelayFrameFunc(function()
        if self.FirstSelectItem then
            self.FirstSelectItem.Btn_Click:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
        end
    end, 2)
    
    self:AddTimer(self.FirstSelectItem.In:GetEndTime(), function()
        if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
            if self.FirstSelectItem then
                self.FirstSelectItem.Btn_Click:SetFocus()
            end
        end
        self.List_Chat:ScrollWidgetIntoView(self.LastChatItem, true)
    end)
    -- 跳过相关
    if self.OptionsNum > 1 and not self.ArchiveInfo then
        self:HideSkipKeyInfo()
    end
    if self.IsSkipping then
        if self.OptionsNum == 1 and not OptionTexts[self.OptionsNum].IsLastOption  then
            self.FirstSelectItem:OnBtnClicked()
        else
            self:StopSkipEvent()
        end
    end
end

function M:OnIteratorDialogue()
    if not self.CanInteractDialogue then
        return
    end
    if self.LastChatItem then
        self.LastChatItem:SetRenderOpacity(0.5)
    end
    DebugPrint("Iterator被点击")
    EventManager:FireEvent(EventID.OnRougeIteratorDialogue)
end

function M:ChooseEvent(EventId, EventName, IsUnlocked, Index, Item)
    if EventId == self.RoomId then
        return
    else
        self.RoomId = EventId
        self.StoryPath = DataMgr.RougeLikeRoom[EventId].EventStoryline
    end
    AudioManager(self):PlayUISound(self, "event:/ui/roguelike/difficulty_click", nil, nil)
    
    self.Text_Name:SetText(GText(EventName))
    self.List_EventTab:SetSelectedIndex(Index)
    self.List_EventTab:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    self.List_Chat:ClearChildren()
    self.WBox_Selection:ClearChildren()
    self.FirstSelectItem = nil
    self:PlayAnimation(self.Change)
    local ComTab = self.Com_Tab_P or self.Com_Tab_M
    local TitleName = string.format(GText("RLArchive_EventSubtitle"), GText(DataMgr.RougeLikeRoom[EventId].Name))
    ComTab:UpdateTopTitle(TitleName)
    if IsUnlocked then
        self.CanInteractDialogue = true
        self.Event:PlayAnimation(self.Event.Normal)
        self.Event_Old:PlayAnimation(self.Event_Old.Normal)
        self.Event_Stack:PlayAnimation(self.Event_Stack.Normal)
        self.Panel_Info:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Group_Empty:SetVisibility(ESlateVisibility.Collapsed)
        if ComTab.UpdateBottomKeyInfo then
            ComTab:UpdateBottomKeyInfo{
                {
                    GamePadInfoList = {{Type = "Img", ImgShortPath = "RV"}},
                    Desc = GText("UI_Controller_Slide"),
                    bLongPress = false
                },
                {
                    GamePadInfoList = {{Type = "Img", ImgShortPath = "A"}},
                    Desc = GText("UI_Tips_Ensure"),
                    bLongPress = false
                },
                {
                    KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.ArchiveClose, Owner=self,}},
                    GamePadInfoList = {{Type="Img", ImgShortPath="B"}},
                    Desc = GText("UI_BACK"),
                    bLongPress = false
                },
            }
        end
     else
         self.CanInteractDialogue = false
         self.Event:PlayAnimation(self.Event.Lock)
         self.Event_Old:PlayAnimation(self.Event_Old.Lock)
         self.Event_Stack:PlayAnimation(self.Event_Stack.Lock)
         self.Panel_Info:SetVisibility(ESlateVisibility.Collapsed)
         self.Group_Empty:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
         if ComTab.UpdateBottomKeyInfo then
             ComTab:UpdateBottomKeyInfo{
                 {
                     KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.ArchiveClose, Owner=self,}},
                     GamePadInfoList = {{Type="Img", ImgShortPath="B"}},
                     Desc = GText("UI_BACK"),
                     bLongPress = false
                 },
             }
         end
    end
    self.NextEventId = EventId
    --EventManager:FireEvent(EventID.CloseFromRougeArchive)
    GWorld.StoryMgr:StopStoryline(self.CurStory)
    
    --self:AddTimer(self.Change:GetEndTime(), function()
    --    self.CurStory = GWorld.StoryMgr:RunStory(self.StoryPath, nil, nil, self.Callback, self.Callback)
    --    self.NextEventId = nil
    --end)
end

function M:ReplayThisEvent()
    self.NextEventId = self.RoomId
    self.List_EventTab:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    self.FirstSelectItem = nil
    self:PlayAnimation(self.Text_Out)
    self:AddTimer(self.Text_Out:GetEndTime(), function()
        self.List_Chat:ClearChildren()
        self.WBox_Selection:ClearChildren()
        self:PlayAnimation(self.Text_In)
        self:AddTimer(self.Text_In:GetEndTime(), function()
            self.CanInteractDialogue = true
        end) 
        self.CurStory = GWorld.StoryMgr:RunStory(self.StoryPath, nil, nil, self.Callback, self.Callback)
        self.CanInteractDialogue = false
        self.NextEventId = nil
    end)
end

function M:ChooseItem(SelectIndex,IsKeyOption, DialogueId, Content)
    DebugPrint("所选序号:", SelectIndex)
    -- Callback内执行
    assert(GWorld:GetAvatar(), "无法取得Avatar")
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    assert(GameMode, "GameMode不存在")
    self.CanInteractChoices = false
    local CurrentTalkType = DataMgr.Dialogue[DialogueId].RougeTalkActorType
    local TalkActorId = DataMgr.Dialogue[DialogueId].SpeakNpcId
    local TalkActorName
    if TalkActorId then
        TalkActorName = GText(DataMgr.Npc[TalkActorId].UnitName)
    end
    self:AddDialogue(TalkActorName, CurrentTalkType, Content, true)
    self.FirstSelectItem = nil
    if self.StoryId then
        if IsKeyOption and not self.ArchiveInfo and not self.IsClientEvent then
            GWorld:GetAvatar():SelectStoryEvent(SelectIndex, function()
                self.CanInteractChoices = true
                self.IsStoryEvent = true
                self.IsDelayDialogue = true
                GWorld:GetAvatar():PassStory()
                EventManager:FireEvent(EventID.OnRougeChooseOption, SelectIndex)
            end)
        else
            self.CanInteractChoices = true
            self.IsDelayDialogue = true
            self.IsStoryEvent = true
            EventManager:FireEvent(EventID.OnRougeChooseOption, SelectIndex)
        end
    else
        if IsKeyOption and not self.ArchiveInfo and not self.IsClientEvent then
            -- 机关EndInteractive移到这里，保证EventPassRoom触发时机关能切到302状态
            -- 放到回调前了 因为存储要在回调前
            local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
            local Player = PlayerController:GetMyPawn()
            local Eid = Player.MechanismEid
            local Mechanism = Battle(self):GetEntity(Eid)
            if Mechanism then
                Mechanism:EndInteractive(Player, true)
            end

            GWorld:GetAvatar():SelectEvent(SelectIndex, function(ret)
                self.CanInteractChoices = true
                self.IsDelayDialogue = true
                local CurrentEventId = GWorld.RougeLikeManager.EventId
                DebugPrint("当前事件ID为：", CurrentEventId)
                if CurrentEventId > 0 then
                    local GameModeEvent = DataMgr.RougeLikeEventSelect[CurrentEventId].GameModeEvent
                    if GameModeEvent then
                        GameMode:PostCustomEvent(GameModeEvent)
                    end
                end
                EventManager:FireEvent(EventID.OnRougeChooseOption, SelectIndex)
            end)
        else
            self.IsDelayDialogue = true
            self.CanInteractChoices = true
            EventManager:FireEvent(EventID.OnRougeChooseOption, SelectIndex)
        end
    end
    self.List_EventTab:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
end

--跳过功能 跳到下一个多选项节点或 直接到最后一个节点
function M:SkipEvent()
    if self.IsSkipping then
        return
    end
    self.IsSkipping = true
    if self.SkippingTimer then return end
    if self.FirstSelectItem and self.OptionsNum == 1 and not self.OptionTexts[self.OptionsNum].IsLastOption  then
        self.FirstSelectItem:OnBtnClicked()
    end
    self.SkippingTimer = self:AddTimer(0.01, function()
        self:OnIteratorDialogue()
    end, true, nil, "SkippingEvent")
end

function M:StopSkipEvent()
    self.IsSkipping = false
    if self.SkippingTimer then
        self:RemoveTimer(self.SkippingTimer)
        self.SkippingTimer = nil
    end
end

-- 确认选项时播其他未选中的Out，由EventSelection发起调用
function M:CloseExcept(OptionIndex)
    local SelectionNum = self.WBox_Selection:GetChildrenCount()
    for Index = 1, SelectionNum do
        local SelectionItem = self.WBox_Selection:GetChildAt(Index - 1)
        if Index ~= OptionIndex then
            SelectionItem:PlayAnimation(SelectionItem.Out)
        end
    end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    DebugPrint("@zyh 执行OnUpdateUIStyleByInputTypeChange")
    self.Super.OnUpdateUIStyleByInputTypeChange(self, CurInputType, CurGamepadName)
    self:UpdateBottomKeyInfo()
    if(CurInputType == ECommonInputType.Gamepad) then
        self:InitGamepadView()
    else
        self:InitKeyboardView()
    end
end

function M:InitGamepadView()
    if self.FirstSelectItem then
        self.FirstSelectItem.Btn_Click:SetFocus()
    else
        if self.List_EventTab then
            self.List_EventTab:SetFocus()
        else
            self.Btn_Next:SetFocus()
        end
    end
    self.Btn_Bag.Key_Bag:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:InitKeyboardView()
    self.Btn_Bag.Key_Bag:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:SetFocusWhenCloseAward()
    self:SetFocus()
end

function M:OnRougeGetToken(TokenNum)
    -- 等策划配Reward表
    DebugPrint("@zyh OnRougeGetToken", TokenNum)
end

function M:Close()
    self:StopAnimation(self.Loop)
    self.Event:StopAnimation(self.Event.Loop)
    if self.IsStoryEvent then
        DebugPrint("@zyh 是剧情事件 发送事件OnRougeLikeStoryEventEnd")
        EventManager:FireEvent(EventID.OnRougeLikeStoryEventEnd)
    end
     if self.ArchiveInfo then
         EventManager:FireEvent(EventID.CloseFromArchiveStory) --仅给图鉴-剧情做UI表现
     end
    AudioManager(self):SetEventSoundParam(self, "SwitchRougeEvent", { ToEnd = 1 })
    self.Super.Close(self)
end

function M:ArchiveClose()
    self.IsRealClose = true -- 无需重启事件，直接关闭
    --EventManager:FireEvent(EventID.CloseFromRougeArchive)
    GWorld.StoryMgr:StopStoryline(self.CurStory)
    --self:Close()
end

function M:GetDialogueSpeakerName(DialogueData)
    local Name = nil
    if(DialogueData.TalkActorName) then
        Name = DialogueData.TalkActorName
    else
        local TalkActorData = DialogueData.TalkActorData
        DebugPrint("@zyh类型", DialogueData.TalkActorId)
        if(not TalkActorData) then
            Name = TalkUtils:GetTalkActorName("Npc",DialogueData.TalkActorId)
        else
            Name = TalkUtils:GetTalkActorName(TalkActorData.TalkActorType,TalkActorData.TalkActorId)
        end
    end
    return GText(Name)
end

function M:Destruct()
    self.Super.Destruct(self)
    self.List_Chat:ClearChildren()
    self.WBox_Selection:ClearChildren()
    self.Event:PlayAnimation(self.Event.Normal)
    self.Event_Old:PlayAnimation(self.Event_Old.Normal)
    self.Event_Stack:PlayAnimation(self.Event_Stack.Normal)
    self.Panel_Info:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Group_Empty:SetVisibility(ESlateVisibility.Collapsed)
    self.SkippingTimer = nil
end

function M:ReceiveEnterState(StackAction)
    self.Super.ReceiveEnterState(self, StackAction)
    local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
    Player:SetCanInteractiveTrigger(false)
end

function M:ReceiveExitState(StackAction)
    self.Super.ReceiveExitState(self, StackAction)
    local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
    Player:SetCanInteractiveTrigger(true)
end

return M
