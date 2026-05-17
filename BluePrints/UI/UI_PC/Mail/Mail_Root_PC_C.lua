--@Mail_Root_PC_C

require "UnLua"
local TimeUtils = require "Utils.TimeUtils"

local NormalMailName = DataMgr.ReddotNode.NormalMail.Name

local M = Class({ "Blueprints.UI.BP_UIState_C" })

function M:Init(Parent, ShowMailId)
    self.Parent = Parent
    self.ShowMailId = ShowMailId
    self:GetCurrentSystemLanguage()
    self:InitRpcEvent()
    self:InitCommonTab()
    self:InitMailMain()
    self:PlayInAnim()
    self:AddReddotListen()
end

function M:AddReddotListen()
    ReddotManager.AddListener(NormalMailName, self, function(self, Count)
        self:SetMailTabRedDot(Count)
    end)
end

function M:RemoveReddotListen()
    ReddotManager.RemoveListener(NormalMailName, self)
end

function M:GetCurrentSystemLanguage()
    local SystemLanguages = {
        CN = "TextMapContent",
        EN = "ContentEN",
        JP = "ContentJP",
        KR = "ContentKR",
        TC = "ContentTC",
        FR = "ContentFR",
    }
    self.CurrentSystemLanguage = 'CN'
    for key, value in pairs(SystemLanguages) do
        if CommonConst.SystemLanguage == value then
            self.CurrentSystemLanguage = key
        end
    end
end

function M:InitRpcEvent()
    self:AddDispatcher(EventID.OnGetMailRewards, self, self.OnGetMailRewards)
    self:AddDispatcher(EventID.OnMarkMailStar, self, self.OnMarkMailStar)
    self:AddDispatcher(EventID.OnCancelMailStar, self, self.OnCancelMailStar)
    self:AddDispatcher(EventID.OnDeleteMail, self, self.OnDeleteMail)
    self:AddDispatcher(EventID.OnMarkMailReaded, self, self.OnMarkMailReaded)
    self:AddDispatcher(EventID.OnGetAllMailReward, self, self.OnGetAllMailReward)
    self:AddDispatcher(EventID.OnChangePropMailUniqueID, self, self.InitMailMain)
end

function M:InitCommonTab()
    self:InitBtnTab()
    self.NowTabId = 1
    self.CurContent = nil
    self.GamePadState = "ListMail"
    self.Text_Empty:SetText(GText('UI_Mail_Empty'))
    self.Text_MailDetail_Empry:SetText(GText('UI_Mail_Nochosen'))
    self.Button_Receive_All:SetText(GText('UI_Mail_Recieveall'))
    self.Button_Receive_All:BindEventOnClicked(self, self.OnClickButtonReceiveAll)
    self.Button_Receive_All:SetGamePadImg("Y")
    --self.Button_Receive:SetText(GText('UI_Mail_Recieve'))
    self.Button_Receive:SetGamePadIconVisible(true)
    self.Button_Receive:SetGamePadImg("A")
    self.Button_Receive:BindEventOnClicked(self, self.OnClickButtonReceive)
    self.Btn_Normal:BindEventOnClicked(self, self.OnClickButtonReceive)
    self.Button_DeleteAllRead:SetText(GText('UI_Mail_Delete_All'))
    self.Button_DeleteAllRead:BindEventOnClicked(self, self.OnClickButtonDeleteAllRead)
    self.Button_DeleteAllRead:SetGamePadImg("X")
    self.SortList = { GText('UI_Mail_Date_Recieve'), GText('UI_Mail_Date_Remain') }
    self.Text_RewardTitle:SetText(GText('UI_Mail_Reward'))
    self.Button_Collect:BindEventOnClicked(self, self.OnClickButtonCollect)
    -- UIManager(self):SetIsCanKeyNavigation(false)
end

function M:InitBtnTab()
    self.Platform = CommonUtils.GetDeviceTypeByPlatformName(self)  --移动端还是PC端
    local SubTabList = {
        [1] = {
            Text = GText('UI_Mail_Tab_Common'),
            TabId = 1,
        },
        [2] = {
            Text = GText('UI_Mail_Tab_Star'),
            TabId = 2,
        }
    }
    self.WBP_Com_TabSub01:Init({
        PlatformName = self.Platform,
        LeftKey = "A",
        RightKey = "D",
        Tabs = SubTabList
    })
    self.WBP_Com_TabSub01:BindEventOnTabSelected(self, self.OnSubTabChanged)
    self.WBP_Com_TabSub01:SelectTab(self.NowTabId)
    local CanvasSlotList = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.WS_MailList)
    local SlotSizeList = CanvasSlotList:GetSize()
    local CanvasSlotListCommon = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Group_MailListCommon)
    local SlotSizeListCommon = CanvasSlotListCommon:GetSize()
    local CanvasSlotDetail = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.WS_MailDetail)
    local CanvasSlotDetailOffsets = CanvasSlotDetail:GetOffsets()
    if self.Platform == "PC" then
        CanvasSlotList:SetSize(FVector2D(self.ListSizeX_P, SlotSizeList.Y))
        CanvasSlotListCommon:SetSize(FVector2D(self.ListSizeX_P, SlotSizeListCommon.Y))
        CanvasSlotDetailOffsets.Left = self.DetailOffsetLeft_P
        CanvasSlotDetail:SetOffsets(CanvasSlotDetailOffsets)
    else
        CanvasSlotList:SetSize(FVector2D(self.ListSizeX_M, SlotSizeList.Y))
        CanvasSlotListCommon:SetSize(FVector2D(self.ListSizeX_M, SlotSizeListCommon.Y))
        CanvasSlotDetailOffsets.Left = self.DetailOffsetLeft_M
        CanvasSlotDetail:SetOffsets(CanvasSlotDetailOffsets)
    end
    self.Key_Collect:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "Menu",
            },
        },
    })
    self.Key_Delete:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "RS",
            },
        },
    })
    self.Key_RewardTitle:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Img",
                ImgShortPath = "LS",
            },
        },
    })
    self.Tab01 = self.WBP_Com_TabSub01.List_Tab:GetChildAt(0)
    self.Btn_Delete:BindEventOnClicked(self, self.OnClickDeleteMail)
end

function M:InitMailMain()
    self.NormalMailList = {}
    self.NorMailNums = 0
    self.StarMailList = {}
    self.StarMailNums = 0
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        if Avatar.MailInbox then
            for Id, Data in pairs(Avatar.MailInbox) do
                self.NorMailNums = self.NorMailNums + 1
                self.NormalMailList[Id] = {}
                self.NormalMailList[Id].RewardGot = Data.RewardGot
                self.NormalMailList[Id].MailReaded = Data.MailReaded
                self.NormalMailList[Id].ItemList = Data.ItemList
                self.NormalMailList[Id].MailDate = Data.MailDate
                self.NormalMailList[Id].MailId = Data.MailId
                self.NormalMailList[Id].IsStar = false
                self.NormalMailList[Id].DueTime = self:CalculateDueTime(Data)
                self.NormalMailList[Id].RealDueTime = self:CalcuateRealDueTime(Data)
                self.NormalMailList[Id].HeadIconId = Data.HeadIconId
            end
        end
        if Avatar.StarMails then
            for Id, Data in pairs(Avatar.StarMails) do
                self.StarMailNums = self.StarMailNums + 1
                self.StarMailList[Id] = {}
                self.StarMailList[Id].RewardGot = Data.RewardGot
                self.StarMailList[Id].MailReaded = Data.MailReaded
                self.StarMailList[Id].ItemList = Data.ItemList
                self.StarMailList[Id].MailDate = Data.MailDate
                self.StarMailList[Id].MailId = Data.MailId
                self.StarMailList[Id].IsStar = true
                self.StarMailList[Id].DueTime = self:CalculateDueTime(Data)
                self.StarMailList[Id].RealDueTime = self:CalcuateRealDueTime(Data)
                self.StarMailList[Id].HeadIconId = Data.HeadIconId
            end
        end
    end
    self:UpdateMailNum()
    self.WBP_Com_TabSub01:SelectTab(self.NowTabId)
end

function M:CalculateDueTime(MailData)
    local DueTime = CommonConst.MailMaxDueTime
    local NowTime = TimeUtils.NowTime()
    if MailData.MailId == -1 then
        DueTime = math.max(0, CommonConst.GMMailTimeLimit * CommonConst.SECOND_IN_DAY - NowTime + MailData.MailDate)
    else
        local MailInfo = DataMgr.Mail[MailData.MailId]
        if MailInfo.MailTimeLimit == -1 then
            return DueTime
        end
        DueTime = math.max(0, MailInfo.MailTimeLimit * CommonConst.SECOND_IN_DAY - NowTime + MailData.MailDate)
    end
    return DueTime
end

function M:CalcuateRealDueTime(MailData)
    if MailData.MailId == -1 then
        return MailData.MailDate + CommonConst.GMMailTimeLimit * CommonConst.SECOND_IN_DAY
    else
        local MailInfo = DataMgr.Mail[MailData.MailId]
        if MailInfo.MailTimeLimit == -1 then
            return nil
        end
        return MailData.MailDate + MailInfo.MailTimeLimit * CommonConst.SECOND_IN_DAY
    end
end

function M:UpdateMailNum()
    local ConstantInfo = DataMgr.GlobalConstant
    self.Text_NormalMailNum:SetText((self.NorMailNums + self.StarMailNums) .. '/' .. math.floor(ConstantInfo.MailMaxSave.ConstantValue))
    self.Text_StarMailNum:SetText(self.StarMailNums .. '/' .. math.floor(ConstantInfo.StarMailMaxSave.ConstantValue))
end

function M:OnSubTabChanged(TabWidget)
    self:OnMailListTabClicked(TabWidget.Idx, 1)
end

function M:OnMailListTabClicked(TabId, SelectMailIndex, bKeepScrollOffset)
    SelectMailIndex = SelectMailIndex or 1
    if self.CurContent then
        self.CurContent.IsSelected = false
        self.CurContent.SelfWidget:ClearListItemObjectSelectState()
    end
    self.NowTabId = TabId
    if TabId == 1 then
        self.Button_Receive_All:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Button_DeleteAllRead:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self:CheckHaveRewardToReceiveAll()
        self:CheckHaveReadToDeleteAll()
        --self.Button_DeleteAllRead:ForbidBtn(false)
    else
        self.Button_Receive_All:ForbidBtn(true)
        self.Button_DeleteAllRead:ForbidBtn(true)
    end
    if self.NowTabId == 1 then
        self.WS_MailNum:SetActiveWidgetIndex(0)
        if self.NorMailNums + self.StarMailNums > 0 then
            self.WS_MailList:SetActiveWidgetIndex(1)
            self:InitListMail(SelectMailIndex, bKeepScrollOffset, self.NormalMailList, self.StarMailList)
        else
            self.CurContent = nil
            self.WS_MailList:SetActiveWidgetIndex(0)
            self.WS_MailDetail:SetActiveWidgetIndex(0)
        end
    else
        self.WS_MailNum:SetActiveWidgetIndex(1)
        if self.StarMailNums > 0 then
            self.WS_MailList:SetActiveWidgetIndex(1)
            self:InitListMail(SelectMailIndex, bKeepScrollOffset, self.StarMailList)
        else
            self.CurContent = nil
            self.WS_MailList:SetActiveWidgetIndex(0)
            self.WS_MailDetail:SetActiveWidgetIndex(0)
        end
    end
    if self.List_Mail:GetNumItems() > 0 and self.WS_MailList:GetActiveWidgetIndex() == 1 then
        self.List_Mail.BP_OnEntryInitialized:Add(self, function()
            self:AddTimer(0.1, function()
                self:UpdateFocusState("ListMail", SelectMailIndex)
            end)
            self.List_Mail.BP_OnEntryInitialized:Clear()
        end)
    else
        self:UpdateFocusState("ListMail", SelectMailIndex)
    end
    self:InitListReddot()
end

function M:SetMailTabRedDot(Nums)
    self.Tab01:SetReddotNum(Nums)
end

function M:CheckHaveRewardToReceiveAll()
    local HaveReward = false
    for key, value in pairs(self.NormalMailList) do
        if value.RewardGot == 0 then
            HaveReward = true
        end
    end
    for key, value in pairs(self.StarMailList) do
        if value.RewardGot == 0 then
            HaveReward = true
        end
    end
    if HaveReward and self.NowTabId == 1 then
        self.Button_Receive_All:ForbidBtn(false)
    else
        self.Button_Receive_All:ForbidBtn(true)
    end
    return HaveReward
end

function M:CheckHaveReadToDeleteAll()
    local HaveRead = false
    for key, value in pairs(self.NormalMailList) do
        if value.MailReaded == 1 and value.RewardGot == 1 then
            HaveRead = true
        end
    end
    if HaveRead and self.NowTabId == 1 then
        self.Button_DeleteAllRead:ForbidBtn(false)
    else
        self.Button_DeleteAllRead:ForbidBtn(true)
    end
    return HaveRead
end

function M:CheckHaveRewardToReceive(IsGot)
    if IsGot == 0 then
        self.Button_Receive:ForbidBtn(false)
    else
        if self:IsGift(self.CurContent) then
            self.Button_Receive:ForbidBtn(false)
        else
            self.Button_Receive:ForbidBtn(true)
        end
    end
end

function M:MergeMailList(...)
    local Res = {}
    for i = 1, select("#", ...) do
        local Arg = select(i, ...)
        for k, v in pairs(Arg) do
            Res[k] = v
        end
    end
    return Res
end

function M:GetMailListData(bKeepScrollOffset, ...)
    local ListData = self:MergeMailList(...)
    local SortTable = nil
    if bKeepScrollOffset then
        SortTable = {}
        local MailContentList = self.MailContentList
        if MailContentList then
            for OldSort, Content in ipairs(MailContentList) do
                SortTable[Content.UniqueId] = OldSort
            end
        end
    end
    return ListData, SortTable
end

function M:InitListMail(SelectMailIndex, bKeepScrollOffset, ...)
    local ListData, SortTable = self:GetMailListData(bKeepScrollOffset, ...)
    local ScrollOffset = self.List_Mail:GetScrollOffset()
    self.List_Mail:ClearListItems()
    self.MailContentList = {}
    local ClassPath = UE4.LoadClass('/Game/UI/WBP/Mail/Widget/WBP_Mail_List_Item_Content.WBP_Mail_List_Item_Content_C')
    for UniqueId, Data in pairs(ListData) do
        local MailContent = NewObject(ClassPath)
        MailContent.UniqueId = UniqueId
        MailContent.MailId = Data.MailId
        MailContent.MailReaded = Data.MailReaded
        MailContent.MailDate = Data.MailDate
        MailContent.RewardGot = Data.RewardGot
        MailContent.IsStar = Data.IsStar
        MailContent.DueTime = Data.DueTime
        MailContent.ParentWidget = self
        MailContent.IsSelected = false
        MailContent.HeadIconId = Data.HeadIconId
        table.insert(self.MailContentList, MailContent)
    end
    -- local SortBy, SortType = self.Common_SortList_PC:GetSortInfos()
    self:SortListMail(SortTable)
    if SelectMailIndex > #self.MailContentList then
        SelectMailIndex = #self.MailContentList
    end

    for Index, Content in ipairs(self.MailContentList) do
        Content.Id = Index
        self.List_Mail:AddItem(Content)
        if self.ShowMailId and self.ShowMailId == Content.MailId then
            SelectMailIndex = Index
        end
    end

    self.MailContentList[SelectMailIndex].IsSelected = true
    self.SelectMailUniqueId = self.MailContentList[SelectMailIndex].UniqueId

    if self:IsExistTimer("AddEmpty") then
        self:RemoveTimer("AddEmpty")
    end
    self:AddTimer(0.01, function()
        self.ShowMailId = nil
        local Final = function()
            -- self.List_Mail:RegenerateAllEntries()
            if bKeepScrollOffset then
                self.List_Mail:SetScrollOffset(ScrollOffset)
            else
                self.List_Mail:ScrollToTop()
            end
        end
        local MailItemUIs = self.List_Mail:GetDisplayedEntryWidgets()
        local RestCount = UIUtils.GetListViewContentMaxCount(self.List_Mail, MailItemUIs) - #self.MailContentList
        if (RestCount <= 0) then
            self.List_Mail:SetScrollbarVisibility(UIConst.VisibilityOp.Visible)
            self.ScrollBox_MailList:SetScrollbarVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            Final()
            return
        end
        local ClassPath = UE4.LoadClass('/Game/UI/WBP/Mail/Widget/WBP_Mail_List_Item_Content.WBP_Mail_List_Item_Content_C')
        for i = 1, RestCount do
            local MailEmptyContent = NewObject(ClassPath)
            MailEmptyContent.UniqueId = -1
            self.List_Mail:AddItem(MailEmptyContent)
        end
        self.List_Mail:SetScrollbarVisibility(UIConst.VisibilityOp["Collapsed"])
        self.ScrollBox_MailList:SetScrollbarVisibility(UIConst.VisibilityOp["Collapsed"])
        Final()
    end, false, 0, "AddEmpty")
end

function M:InitListReddot()
    self.List_Mail.OnListViewScrolled:Clear()
    local bShowReddot = false
    if self.NowTabId == 1 then
        if self.NorMailNums + self.StarMailNums > 0 then
            bShowReddot = true
        end
    else
        if self.StarMailNums > 0 then
            bShowReddot = true
        end
    end
    if not bShowReddot then
        self.GroupListReddot:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        return
    else
        self.GroupListReddot:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    end
    self.List_Mail.OnListViewScrolled:Add(self, self.OnList_MailScrolled)
    self:AddTimer(0.1, function()
        self:OnList_MailScrolled()
    end)
    UIUtils.BindListViewReddotAndNewClickEvent(
            self.List_Mail,
            self.List_RedDotTop,
            self.List_RedDotBottom,
            nil,
            nil,
            function(...)
                local Content = ...
                if not Content then
                    return false, false
                end
                local bHasReddot = (Content.RewardGot == 0)
                local bHasNew = (Content.MailReaded == 0)
                return bHasReddot, bHasNew
            end
    )
end

function M:OnList_MailScrolled()
    -- 节流处理
    if not self then
        return
    end
    if self.List_MailCooldown then
        self.List_MailPending = true
        return
    end
    self.List_MailCooldown = true
    self.List_MailPending = false
    self:AddTimer(0.1, function()
        if not self then
            return
        end
        self.List_MailCooldown = false
        if self.List_MailPending then
            self.List_MailPending = false
            self:OnList_MailScrolled()
        end
    end)
    local ReddotAndNewCalFunc = function(...)
        local Content = ...
        if not Content then
            return false, false
        end
        local bHasReddot = (Content.RewardGot == 0)
        local bHasNew = (Content.MailReaded == 0)
        return bHasReddot, bHasNew
    end
    self:AddTimer(0.033, function()
        if not self then
            return
        end
        UIUtils.UpdateListReddot(
                self.List_Mail,
                self.List_RedDotTop,
                self.List_RedDotBottom,
                nil,
                nil,
                ReddotAndNewCalFunc
        )
    end)
end

function M:SortListMail(SortTable)
    local SortKeys = { 'MailDate', 'DueTime' }
    table.sort(self.MailContentList, function(Data1, Data2)
        local nOldSort1 = SortTable and SortTable[Data1.UniqueId] or nil
        local nOldSort2 = SortTable and SortTable[Data2.UniqueId] or nil
        if nOldSort1 and nOldSort2 then
            return nOldSort1 < nOldSort2
        elseif not (nOldSort1 or nOldSort2) then
        else
            return nOldSort1 ~= nil
        end
        if Data1.RewardGot ~= Data2.RewardGot then
            return Data1.RewardGot < Data2.RewardGot
        end
        if Data1.MailReaded == Data2.MailReaded then
            -- if SortType == CommonConst.DESC then
            --     return Data1[SortKeys[SortKey]] > Data2[SortKeys[SortKey]]
            -- else
            --     return Data1[SortKeys[SortKey]] < Data2[SortKeys[SortKey]]
            -- end
            if Data1.IsStar ~= Data2.IsStar then
                return Data1.IsStar
            end
            if Data1.MailDate == Data2.MailDate then
                return Data1.UniqueId < Data2.UniqueId
            end
            return Data1.MailDate > Data2.MailDate
        else
            return Data1.MailReaded < Data2.MailReaded
        end
    end)
end

function M:ClearMailListItemClickState(Content)
    local EntryList = self.List_Mail:GetDisplayedEntryWidgets():ToTable()
    for _, v in ipairs(EntryList) do
        v:ClearListItemObjectSelectState(Content)
    end
end

function M:OnMailListItemClicked(Content)
    if self.CurContent then
        self.CurContent.IsSelected = false
        self.CurContent.SelfWidget:ClearListItemObjectSelectState()
    end
    -- self:ClearMailListItemClickState(Content)
    self.SelectMailUniqueId = Content.UniqueId
    self.CurContent = Content
    self.WS_MailDetail:SetActiveWidgetIndex(1)
    local Avatar = GWorld:GetAvatar()
    local MailInfo
    MailInfo = self:GetMailInfo(Content)
    self.Text_MailTitle:SetText(GText(MailInfo.MailTitle))

    local Name = MailInfo.Nickname
    if not Name then
        local NpcId = MailInfo.MailSenderId
        Name = 'Mail_Sender_Default'
        if NpcId then
            local NpcInfo = DataMgr.Npc[NpcId]
            if NpcInfo and NpcInfo.UnitName then
                Name = NpcInfo.UnitName
            end
        end
    end

    self.Text_From:SetText(GText(Name))
    self.Text_MailTime_Title:SetText(GText('UI_Mail_Date_Detail') .. ':')
    self.Text_Time:SetText(TimeUtils.TimeToYMDStr(Content.MailDate, nil, '-'))
    if Content.IsStar then
        self.Static_ImageStar:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Static_ImageStar:SetRenderOpacity(1.0)
        self.VX_StarOff:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.Static_ImageStar:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.VX_StarOff:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.VX_StarOff:SetRenderOpacity(1.0)
    end
    self.Text_MailDetail:SetText(GText(MailInfo.MailContent))
    self.ScrollBox_TaskDetail:ScrollToStart()
    if Content.MailReaded == 0 then
        self:BlockAllUIInput(true)
        Avatar:MarkMailReaded(Content.UniqueId)
    end
    -- if not self:IsHaveValidMailReward(MailInfo.MailReward) then
    if not MailInfo.MailReward then
        self.Group_MailDetailItem:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.WS_Bottom:SetActiveWidgetIndex(1)
    else
        self.Group_MailDetailItem:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.WS_Bottom:SetActiveWidgetIndex(0)
        self:CheckHaveRewardToReceive(Content.RewardGot)
        self:InitTileViewMailGift(MailInfo.MailReward, Content.RewardGot)
    end
    if self:IsExistTimer("RefreshTabBottomKey") then
        self:RemoveTimer("RefreshTabBottomKey")
    end
    local RefreshTabBottomKey = function()
        self.Parent:RefreshTabBottomKey()
    end
    self:AddTimer(0.066, RefreshTabBottomKey, false, 0, "RefreshTabBottomKey")
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self.Key_RewardTitle:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Group_KeyCollect:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Key_Collect:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Group_KeyDelete:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Key_Delete:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Key_RewardTitle:SetVisibility(ESlateVisibility.Collapsed)
        self.Group_KeyCollect:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_Collect:SetVisibility(ESlateVisibility.Collapsed)
        self.Group_KeyDelete:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_Delete:SetVisibility(ESlateVisibility.Collapsed)
    end

    self:UpdateBtnReceive()
end

function M:UpdateBtnReceive()
    if self:IsGift(self.CurContent) then
        if self.CurContent.RewardGot == 1 then
            self.WS_Btn:SetActiveWidgetIndex(1)
            self.Btn_Normal:SetText(GText('UI_SendGift_ViewGift2'))
        else
            self.WS_Btn:SetActiveWidgetIndex(0)
            self.Button_Receive:SetText(GText('UI_SendGift_ViewGift'))
        end
        self.ImageGiftSign:SetVisibility(UIConst.VisibilityOp["Visible"])
    else
        self.WS_Btn:SetActiveWidgetIndex(0)
        self.Button_Receive:SetText(GText('UI_Mail_Recieve'))
        self.ImageGiftSign:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

-- function M:IsHaveValidMailReward(MailReward)
--     if MailReward == nil then
--         return false
--     else
--         if type(MailReward) == "number" then
--             if DataMgr.Reward[MailReward] == nil then
--                 return false
--             end
--         elseif type(MailReward) == "table" then
--             if #MailReward == 0 then
--                 return false
--             end
--         end
--     end
--     return true
-- end

function M:GetMailInfo(Content)
    local MailInfo = {}
    local Avatar = GWorld:GetAvatar()
    local Mail
    if Content.IsStar then
        Mail = Avatar.StarMails[Content.UniqueId]
    else
        Mail = Avatar.MailInbox[Content.UniqueId]
    end

    if Content.MailId == -1 then
        MailInfo.MailTitle = Mail.MailTitle[self.CurrentSystemLanguage] or Mail.MailTitle['CN']
        MailInfo.MailTimeLimit = CommonConst.GMMailTimeLimit
        MailInfo.MailContent = GText(Mail.MailContent[self.CurrentSystemLanguage] or Mail.MailContent['CN'])
    else
        local MailData = DataMgr.Mail[Content.MailId]
        MailInfo.MailSenderId = MailData.MailSenderId
        MailInfo.MailTimeLimit = MailData.MailTimeLimit
        local MailData = DataMgr.Mail[Content.MailId]
        if Mail.HeadIconId ~= 0 then
            MailInfo.MailContent = GText(Mail.MailContent[self.CurrentSystemLanguage] or Mail.MailContent['CN'])
            MailInfo.Nickname = Mail.Nickname
        else
            MailInfo.MailContent = GText(MailData.MailContent)
        end

        MailInfo.MailTitle = GText(MailData.MailTitle)
        for key, value in pairs(Mail.FormatText or {}) do
            MailInfo.MailContent = string.gsub(MailInfo.MailContent, '{' .. key .. '}', GText(value))
            MailInfo.MailTitle = string.gsub(MailInfo.MailTitle, '{' .. key .. '}', GText(value))
        end
    end

    if Mail.ItemList[1] then
        MailInfo.MailReward = Mail.ItemList
    else
        MailInfo.MailReward = nil
    end
    if MailInfo.MailContent then
        if string.find(MailInfo.MailContent, 'href') and string.find(MailInfo.MailContent, 'Uuid') then
            local Uuid = Avatar.Uid
            MailInfo.MailContent = string.gsub(MailInfo.MailContent, 'Uuid', Uuid)
        end
    end
    MailInfo.MailSenderId = Mail.MailSender
    return MailInfo
end

function M:CheckMailHasHref()
    local Text = self.Text_MailDetail:GetText()
    if self.WS_MailDetail:GetActiveWidgetIndex() == 1 and string.find(Text, 'href') then
        return true
    end
    return false
end

function M:InitTileViewMailGift(RewardIds, IsGot)
    self.TileView_MailGift:ClearListItems()
    self.RewardList = {}
    for key, value in pairs(RewardIds) do
        table.insert(self.RewardList, { ItemId = value.ItemID, TableName = value.ItemType, Count = value.ItemNum,
                                        Rarity = ItemUtils.GetItemRarity(value.ItemID, value.ItemType) })
    end
    self:SortRewardList()
    self:AddRewardListItem(IsGot)
end

function M:SortRewardList()
    table.sort(self.RewardList, function(Data1, Data2)
        if Data1.Rarity == Data2.Rarity then
            return Data1.ItemId > Data2.ItemId
        else
            return Data1.Rarity > Data2.Rarity
        end
    end)
end

function M:AddRewardListItem(IsGot)
    for _, Data in pairs(self.RewardList) do
        local MailRewardContent = NewObject(UIUtils.GetCommonItemContentClass())
        MailRewardContent.Id = Data.ItemId
        MailRewardContent.ItemType = Data.TableName
        MailRewardContent.IsShowDetails = true
        if Data.TableName == CommonConst.DataType.Char then
            MailRewardContent.IsShowDetails = false
            MailRewardContent.OnMouseButtonUpEvents = {
                Obj = self,
                Callback = self.OpenShowCharDetail,
                Params = { Data.ItemId }
            }
        elseif Data.TableName == CommonConst.DataType.Weapon then
            MailRewardContent.IsShowDetails = false
            MailRewardContent.OnMouseButtonUpEvents = {
                Obj = self,
                Callback = self.OpenShowWeaponDetail,
                Params = { Data.ItemId }
            }
        end
        MailRewardContent.Count = Data.Count
        MailRewardContent.Icon = ItemUtils.GetItemIconPath(Data.ItemId, Data.TableName)
        MailRewardContent.Rarity = Data.Rarity
        MailRewardContent.ParentWidget = self
        MailRewardContent.UIName = "MailMain"
        if IsGot == 0 then
            MailRewardContent.bHasGot = false
        else
            MailRewardContent.bHasGot = true
        end
        MailRewardContent.OnMenuOpenChangedEvents = {
            Obj = self,
            Callback = self.ItemMenuAnchorChanged
        }
        self.TileView_MailGift:AddItem(MailRewardContent)
    end
    self.TileView_MailGift:RequestPlayEntriesAnim()
end

function M:ItemMenuAnchorChanged(bIsOpen)
    if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
        return
    end
    if bIsOpen then
        self.Parent.Common_Tab.Com_KeyTips.Panel_Key:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.TileView_MailGift:SetFocus()
        self.Parent.Common_Tab.Com_KeyTips.Panel_Key:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

function M:OpenShowCharDetail(CharId)
    UIManager(self):LoadUINew("ArmoryDetail", {
        PreviewCharIds = { CharId },
        EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
        bHideCharAppearance = true, --隐藏角色外观
        bHideWeaponAppearance = true, --隐藏武器外观
        bHideBoxBtn = true, --隐藏左下角列表展开按钮
        bNoEndCamera = true, --不需要收场镜头
    })
end

function M:OpenShowWeaponDetail(WeaponId)
    UIManager(self):LoadUINew("ArmoryDetail", {
        PreviewWeaponIds = { WeaponId },
        bHideCharAppearance = true, --隐藏角色外观
        bHideWeaponAppearance = true, --隐藏武器外观
        bHideBoxBtn = true, --隐藏左下角列表展开按钮
        bNoEndCamera = true, --不需要收场镜头
        EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
    })
end

--function M:ClearListSelectState()
--    for i = 0,self.List_Mail:GetNumItems() - 1 do
--        local Item = self.List_Mail:GetItemAt(i)
--        if Item.SelfWidget then
--            Item.SelfWidget:ClearListItemObjectSelectState()
--        end
--    end
--end

function M:SetTileListGotState()
    for i = 0, self.TileView_MailGift:GetNumItems() - 1 do
        local Item = self.TileView_MailGift:GetItemAt(i)
        if Item and Item.SelfWidget and Item.SelfWidget.SetIsGot then
            Item.SelfWidget:SetIsGot(true)
        end
    end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    self.Super.OnUpdateUIStyleByInputTypeChange(self, CurInputType, CurGamepadName)
    if CurInputType == ECommonInputType.Gamepad and IsValid(self.Parent) and self.Parent:HasAnyFocus() then
        self:InitGamepadView()
    else
        self:InitKeyboardView()
    end
end

function M:InitGamepadView()
    self:UpdateFocusState("ListMail", (self.CurContent and (self.CurContent.Id)) or 0)
    self.Key_RewardTitle:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Group_KeyCollect:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Key_Collect:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Group_KeyDelete:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Key_Delete:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function M:InitKeyboardView()
    self.Key_RewardTitle:SetVisibility(ESlateVisibility.Collapsed)
    self.Group_KeyCollect:SetVisibility(ESlateVisibility.Collapsed)
    self.Key_Collect:SetVisibility(ESlateVisibility.Collapsed)
    self.Group_KeyDelete:SetVisibility(ESlateVisibility.Collapsed)
    self.Key_Delete:SetVisibility(ESlateVisibility.Collapsed)
end

function M:OnMailRootPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == UIConst.GamePadKey.DPadRight and self.GamePadState == "ListMail" then
        if self:CheckMailHasHref() then
            self:UpdateFocusState("Hyperlink")
        end
    elseif (self.GamePadState == "Hyperlink" and self.CurrentUrlWidgetIndex >= 0) then
        if (self.CurrentUrlWidgetIndex == 0 and InKeyName == UIConst.GamePadKey.DPadLeft) then
            self:ResetFocusState()
        elseif (InKeyName == UIConst.GamePadKey.DPadUp or InKeyName == UIConst.GamePadKey.DPadLeft) then
            self.CurrentUrlWidgetIndex = self.Text_MailDetail:FindLastFocsableUrlWidget(self.CurrentUrlWidgetIndex)
        elseif (InKeyName == UIConst.GamePadKey.DPadDown or InKeyName == UIConst.GamePadKey.DPadRight) then
            self.CurrentUrlWidgetIndex = self.Text_MailDetail:FindNextFocusableUrlWidget(self.CurrentUrlWidgetIndex)
        end
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnMailRootKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false

    if (UE4.UKismetStringLibrary.StartsWith(InKeyName, "GamePad")) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    elseif (InKeyName == "Escape") then
        self.Parent:OnPressESC()
    elseif (InKeyName == "SpaceBar") then
        self:OnPressSPACE()
    elseif (InKeyName == "F11") then
        self:AddTimer(0.5, self.SetFocus, false, 0, "ReSetFocus")
        UE4.UKismetSystemLibrary.ExecuteConsoleCommand(self, "LevelEditor.ToggleImmersive")
    elseif InKeyName == "A" and self.NowTabId ~= 1 then
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_02", nil, nil)
        self.WBP_Com_TabSub01:TabToLeft()
    elseif InKeyName == "D" and self.NowTabId ~= 2 then
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_02", nil, nil)
        self.WBP_Com_TabSub01:TabToRight()
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    if InKeyName == UIConst.GamePadKey.LeftTriggerThreshold or InKeyName == UIConst.GamePadKey.RightTriggerThreshold and self.GamePadState == "ListMail" then
        self.WBP_Com_TabSub01:Handle_KeyEventOnGamePad(InKeyName)
    elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft and self.GamePadState == "ListMail" then
        self:OnClickButtonDeleteAllRead()
    elseif InKeyName == UIConst.GamePadKey.RightThumb and self.GamePadState == "ListMail" then
        self:OnClickDeleteMail()
        -- elseif InKeyName == UIConst.GamePadKey.DPadRight and self.GamePadState == "ListMail" then
        --     if self:CheckMailHasHref() then
        --         self:UpdateFocusState("Hyperlink")
        --     end
    elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom and self.GamePadState == "ListMail" then
        self:OnClickButtonReceive()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonTop and self.GamePadState == "ListMail" then
        self:OnClickButtonReceiveAll()
    elseif InKeyName == UIConst.GamePadKey.SpecialRight and self.GamePadState == "ListMail" then
        self:OnClickButtonCollect()
        -- elseif InKeyName == UIConst.GamePadKey.LeftThumb and self.GamePadState == "ListMail" then
        --     self:UpdateFocusState("WidgetSort")
    elseif InKeyName == UIConst.GamePadKey.LeftThumb and self.Group_MailDetailItem:IsVisible() then
        if self.GamePadState == "ListReward" then
            self:UpdateFocusState("ListMail")
        else
            self:UpdateFocusState("ListReward")
        end
    elseif self.GamePadState ~= "ListMail" then
        if InKeyName == UIConst.GamePadKey.FaceButtonRight then
            self:UpdateFocusState("ListMail", (self.CurContent and (self.CurContent.Id)) or 0)
            IsEventHandled = true
        end
    else
        IsEventHandled = self.Parent.Common_Tab:Handle_KeyEventOnGamePad(InKeyName)
    end
    return IsEventHandled
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local AddOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5

    if InKeyName == UIConst.GamePadKey.RightAnalogY and self.GamePadState == "ListMail" then
        local CurScrollOffset = self.ScrollBox_TaskDetail:GetScrollOffset()
        local ScrollOffset = math.clamp(CurScrollOffset - AddOffset, 0, self.ScrollBox_TaskDetail:GetScrollOffsetOfEnd())
        self.ScrollBox_TaskDetail:SetScrollOffset(ScrollOffset)
    elseif InKeyName == UIConst.GamePadKey.LeftAnalogX then
        local DeltaOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
        if DeltaOffset <= -1 and self.GamePadState == "Hyperlink" then
            self:UpdateFocusState("ListMail", (self.CurContent and (self.CurContent.Id)) or 0)
        elseif DeltaOffset >= 1 and self.GamePadState == "ListMail" then
            if self:CheckMailHasHref() then
                self:UpdateFocusState("Hyperlink")
            end
        end
    elseif InKeyName == UIConst.GamePadKey.LeftAnalogY then
        local DeltaOffsetY = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
        if (self.GamePadState == "Hyperlink") then
            local Direction = DeltaOffsetY <= 0 and "Next" or "Last"
            self:OnNavigatUrlWithAxis(math.abs(DeltaOffsetY), Direction)
        end
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:ResetFocusState()
    self.CurrentUrlWidgetIndex = -1
    self.GamePadState = "ListMail"
    self:UpdateFocusState("ListMail", (self.CurContent and (self.CurContent.Id)) or 0)
end

function M:UpdateFocusState(State, SelectIndex)
    if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
        return
    end
    if self:IsExistTimer("SetFocus") then
        self:RemoveTimer("SetFocus")
    end
    if self.GamePadState == "GetItemPage" then
        return
    end
    self.GamePadState = State
    --self.Common_SortList_PC.Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self:SetCommonGamePadVisibility(ESlateVisibility.SelfHitTestInvisible)
    -- if self.Common_SortList_PC:HasAnyUserFocus() or self.Common_SortList_PC:HasFocusedDescendants() then
    --     self.Common_SortList_PC.Controller:SetVisibility(ESlateVisibility.Collapsed)
    -- end
    if State == "ListMail" then
        if (self.NowTabId == 1)
                or (self.NowTabId == 2 and self.StarMailNums > 0) then
            local SetFocus = function()
                if self.GamePadState == "GetItemPage" then
                    return
                end
                if CommonUtils:IfExistSystemGuideUI(self) then
                    return
                end
                --self.List_Mail:SetFocus()
                self.List_Mail:NavigateToIndex((SelectIndex and (SelectIndex - 1)) or 0)
            end
            self:AddTimer(0.066, SetFocus, false, 0, "SetFocus")
        else
            self:SetFocus()
        end
    elseif State == "Hyperlink" then
        self:SetIsDealWithVirtualAccept(false)
        self.CurrentUrlWidgetIndex = self.Text_MailDetail:NavigateToUrlWidget()
        self:SetCommonGamePadVisibility(ESlateVisibility.Collapsed)
        self.Parent.Common_Tab.Com_KeyTips.Panel_Key:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    elseif State == "ListReward" then
        self.TileView_MailGift:SetFocus()
        self:SetCommonGamePadVisibility(ESlateVisibility.Collapsed)
    end
end

function M:OnNavigatUrlWithAxis(DeltaOffsetValue, Direction)
    -- 当前帧是否按下（假设大于0.5即为按下，小于0.5认为是松开）
    local bIsPressed = (DeltaOffsetValue > 0.5)
    if (not self.bWasLeftStickPressedLast and bIsPressed) then
        self.bWasLeftStickPressedLast = true
        if (Direction == "Last") then
            self.CurrentUrlWidgetIndex = self.Text_MailDetail:FindLastFocsableUrlWidget(self.CurrentUrlWidgetIndex)
        elseif (Direction == "Next") then
            self.CurrentUrlWidgetIndex = self.Text_MailDetail:FindNextFocusableUrlWidget(self.CurrentUrlWidgetIndex)
        end
    elseif (self.bWasLeftStickPressedLast and not bIsPressed) then
        self.bWasLeftStickPressedLast = false -- 执行一次松开
    end
end

function M:SetCommonGamePadVisibility(Op)
    self.WBP_Com_TabSub01.Key_Left:SetVisibility(Op)
    self.WBP_Com_TabSub01.Key_Right:SetVisibility(Op)
    self.Key_RewardTitle:SetVisibility(Op)
    -- self.Parent.Common_Tab.Com_KeyTips.Panel_Key:SetVisibility(Op)
    if self.Parent then
        self.Parent:RefreshTabBottomKey()
    end
    self.Group_KeyCollect:SetVisibility(Op)
    self.Key_Collect:SetVisibility(Op)
    self.Group_KeyDelete:SetVisibility(Op)
    self.Key_Delete:SetVisibility(Op)
    self.Button_DeleteAllRead:SetGamePadVisibility(Op)
    self.Button_Receive_All:SetGamePadVisibility(Op)
    self.Button_Receive:SetGamePadVisibility(Op)
end

function M:OnClickButtonCollect()
    if not self.CurContent then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if self.CurContent.IsStar then
        --self.List_Mail:ScrollIndexIntoView(self.CurContent.Id - 1)
        local CurContent = self.CurContent
        local function ConfirmCancel()
            self:BlockAllUIInput(true)
            Avatar:CancelMailStar(CurContent.UniqueId)
        end

        local Data = self.StarMailList[CurContent.UniqueId]
        local RealDueTime = Data and Data.RealDueTime
        if RealDueTime and RealDueTime <= TimeUtils.NowTime() then
            UIManager(self):ShowCommonPopupUI(100196, {
                LeftCallbackFunction = function()
                    --self:BlockAllUIInput(false)
                end,
                RightCallbackFunction = function()
                    ConfirmCancel()
                end
            })
        else
            ConfirmCancel()
        end
    else
        local ConstantInfo = DataMgr.GlobalConstant
        if self.StarMailNums == ConstantInfo.StarMailMaxSave.ConstantValue then
            local Ret = ErrorCode.RET_MAIL_STAR_FULL
            UIManager(self):ShowError(Ret)
            return
        end
        self:BlockAllUIInput(true)
        --self.List_Mail:ScrollIndexIntoView(self.CurContent.Id - 1)
        Avatar:MarkMailStar(self.CurContent.UniqueId)
    end
end

function M:OnPressSPACE()
    self:OnClickButtonReceiveAll()
end

function M:OnClickButtonReceiveAll()
    if not self.CurContent then
        return
    end
    if not self:CheckHaveRewardToReceiveAll() then
        return
    end
    if self.NowTabId ~= 1 then
        return
    end
    local Avatar = GWorld:GetAvatar()
    self:BlockAllUIInput(true)
    Avatar:GetAllMailReward()
end

function M:OnClickButtonReceive()
    if not self.CurContent then
        return
    end

    local MailInfo = self:GetMailInfo(self.CurContent)
    if (self.CurContent.RewardGot == 1 or MailInfo.MailReward == nil) and not self:IsGift(self.CurContent) then
        -- UIManager(self):ShowUITip(UIConst.Tip_CommonToast,GText('UI_Tosat_Mail_Noreward'))
        return
    else
        local Avatar = GWorld:GetAvatar()
        local Mail
        if self.CurContent.IsStar then
            Mail = Avatar.StarMails[self.CurContent.UniqueId]
        else
            Mail = Avatar.MailInbox[self.CurContent.UniqueId]
        end

        if self:IsGift(self.CurContent) then
            local ShopItemId = string.match(Mail.CtxId, "ShopItemId:(.-) ")
            GiftController:OpenGiftCardView(Mail.MailSender, ShopItemId, 2, Mail)
        else
            local Avatar = GWorld:GetAvatar()
            self:BlockAllUIInput(true)
            Avatar:GetMailRewards(self.CurContent.UniqueId)
        end
    end
end

function M:OnClickButtonDeleteAllRead()
    if self.NowTabId ~= 1 then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    UIManager(self):ShowCommonPopupUI(100194, {
        LeftCallbackFunction = function()
            self:BlockAllUIInput(false)
        end,
        RightCallbackFunction = function()
            self:BlockAllUIInput(true)
            Avatar:DeleteReadedMails()
        end
    })
end

function M:OnClickDeleteMail()
    if not self.CurContent then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local UniqueId = self.CurContent.UniqueId
    UIManager(self):ShowCommonPopupUI(100195, {
        LeftCallbackFunction = function()
            self:BlockAllUIInput(false)
        end,
        RightCallbackFunction = function()
            self:BlockAllUIInput(true)
            Avatar:DeleteMail(UniqueId)
        end
    })
end

function M:BindEventOnSelectionsChanged()
    self:OnMailListTabClicked(self.NowTabId, 1)
end

function M:BindEventOnSortTypeChanged()
    self:OnMailListTabClicked(self.NowTabId, 1)
end

function M:OnPressESC()
    self:PlayOutAnim()
end

function M:GetMailRewardIds(UniqueIds)
    local RewardIds = {}
    if type(UniqueIds) == "table" then
        for _, UniqueId in pairs(UniqueIds) do
            local ItemList
            if self.NormalMailList[UniqueId] then
                ItemList = self.NormalMailList[UniqueId].ItemList
            else
                ItemList = self.StarMailList[UniqueId].ItemList
            end
            for key, value in pairs(ItemList) do
                if RewardIds[value.ItemType .. 's'] then
                    if RewardIds[value.ItemType .. 's'][value.ItemID] then
                        RewardIds[value.ItemType .. 's'][value.ItemID] = RewardIds[value.ItemType .. 's'][value.ItemID] + value.ItemNum
                    else
                        RewardIds[value.ItemType .. 's'][value.ItemID] = value.ItemNum
                    end
                else
                    RewardIds[value.ItemType .. 's'] = {}
                    RewardIds[value.ItemType .. 's'][value.ItemID] = value.ItemNum
                end
            end
        end
    elseif type(UniqueIds) == "number" then
        local ItemList
        if self.NormalMailList[UniqueIds] then
            ItemList = self.NormalMailList[UniqueIds].ItemList
        else
            ItemList = self.StarMailList[UniqueIds].ItemList
        end
        for key, value in pairs(ItemList) do
            if RewardIds[value.ItemType .. 's'] then
                if RewardIds[value.ItemType .. 's'][value.ItemID] then
                    RewardIds[value.ItemType .. 's'][value.ItemID] = RewardIds[value.ItemType .. 's'][value.ItemID] + value.ItemNum
                else
                    RewardIds[value.ItemType .. 's'][value.ItemID] = value.ItemNum
                end
            else
                RewardIds[value.ItemType .. 's'] = {}
                RewardIds[value.ItemType .. 's'][value.ItemID] = value.ItemNum
            end
        end
    end
    return RewardIds
end

function M:OnGetMailRewards(Ret, UniqueID, UniqueIds)
    if Ret == ErrorCode.RET_SUCCESS then
        self:BlockAllUIInput(false)
        if self.NormalMailList[UniqueID] then
            self.NormalMailList[UniqueID].RewardGot = 1
            self.NormalMailList[UniqueID].MailReaded = 1
        end
        if self.StarMailList[UniqueID] then
            self.StarMailList[UniqueID].RewardGot = 1
            self.StarMailList[UniqueID].MailReaded = 1
        end
        local Rewards = self:GetMailRewardIds(UniqueIds)
        self.GamePadState = "GetItemPage"
        self.CurContent.RewardGot = 1
        self.CurContent.MailReaded = 1
        UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function(obj)
            self:ResetFocusState()
        end, self)
        self:SetTileListGotState()
        self:CheckHaveRewardToReceive(self.CurContent.RewardGot)
        if not self:CheckHaveRewardToReceiveAll() then
            self.Parent:RefreshTabBottomKey()
        end
        self:CheckHaveReadToDeleteAll()
        self.CurContent.SelfWidget:SetListItemObjectReadState()
        self.CurContent.SelfWidget:SetListItemObjectRewardGotState()
    else
        self:HandleAvatarRet(Ret)
    end

    self:UpdateBtnReceive()
end

function M:OnGetAllMailReward(Ret, UniqueIds)
    if Ret == ErrorCode.RET_SUCCESS then
        self:BlockAllUIInput(false)
        if UniqueIds then
            local Rewards = self:GetMailRewardIds(UniqueIds)
            self.GamePadState = "GetItemPage"
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function()
                self:ResetFocusState()
            end, self)
        end
        self:InitMailMain()
    else
        self:HandleAvatarRet(Ret)
    end
end

function M:OnMarkMailStar(Ret, UniqueID, UniqueIds)
    if Ret == ErrorCode.RET_SUCCESS then
        self:BlockAllUIInput(false)
        self.StarUniqueId = UniqueID
        self:CheckHaveRewardToReceive(1)
        if self.NormalMailList[UniqueID].RewardGot ~= 1 and self.NormalMailList[UniqueID].ItemList[1] then
            local Rewards = self:GetMailRewardIds(UniqueID)
            self.NormalMailList[UniqueID].RewardGot = 1
            self.GamePadState = "GetItemPage"
            self.bMarkMailStar = true
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function(obj)
                self:PlayStarAnim()
            end, self)
        else
            self:PlayStarAnim()
        end
    else
        self:HandleAvatarRet(Ret)
    end
end

function M:PlayStarAnim()
    self:PlayAnimation(self.Collect)
    self.CurContent.IsStar = true
    self.NormalMailList[self.StarUniqueId].IsStar = true
    self.NormalMailList[self.StarUniqueId].MailReaded = 1
    local TempData = self.NormalMailList[self.StarUniqueId]
    self.NormalMailList[self.StarUniqueId] = nil
    self.StarMailList[self.StarUniqueId] = TempData
    local SelectMailIndex = self.CurContent.Id
    self.StarMailNums = self.StarMailNums + 1
    self.NorMailNums = self.NorMailNums - 1
    self.CurContent.SelfWidget:PlayAnimation(self.CurContent.SelfWidget.List_Collect)
    if self:IsExistTimer("StarMail") then
        self:RemoveTimer("StarMail")
    end
    local StarMail = function()
        self:BlockAllUIInput(false)
        self:ResetFocusState()
        self:OnMailListTabClicked(self.NowTabId, SelectMailIndex, true)
        self:UpdateMailNum()
        self.bMarkMailStar = false
    end
    local AnimTime = self.CurContent.SelfWidget.List_Collect:GetEndTime()
    self:AddTimer(AnimTime, StarMail, false, 0, "StarMail", true)
end

function M:OnCancelMailStar(Ret, UniqueID)
    if Ret == ErrorCode.RET_SUCCESS then
        self:PlayAnimation(self.UnCollect)
        self.CurContent.IsStar = false
        local TempData = self.StarMailList[UniqueID]
        self.StarMailList[UniqueID] = nil
        self.NormalMailList[UniqueID] = TempData
        self.NormalMailList[UniqueID].IsStar = false
        local SelectMailIndex = self.CurContent.Id
        self.StarMailNums = self.StarMailNums - 1
        self.NorMailNums = self.NorMailNums + 1
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText('UI_Tosat_Mail_Remove'))
        if self:IsExistTimer("CancelStar") then
            self:RemoveTimer("CancelStar")
        end
        local CancelStar = function()
            self:BlockAllUIInput(false)
            --self.Static_ImageStar:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self:OnMailListTabClicked(self.NowTabId, SelectMailIndex, self.NowTabId == 1)
            self:UpdateMailNum()
        end
        local AnimTime = self.UnCollect:GetEndTime()
        self:AddTimer(AnimTime, CancelStar, false, 0, "CancelStar")
    else
        self:HandleAvatarRet(Ret)
    end
end

function M:OnMarkMailReaded(Ret, UniqueID)
    if Ret == ErrorCode.RET_SUCCESS then
        local MailInfo
        MailInfo = self:GetMailInfo(self.CurContent)
        if MailInfo.MailReward == nil then
            if self.NormalMailList[UniqueID] then
                self.NormalMailList[UniqueID].RewardGot = 1
            end
            if self.StarMailList[UniqueID] then
                self.StarMailList[UniqueID].RewardGot = 1
            end
            self.CurContent.RewardGot = 1
        end
        if self.NormalMailList[UniqueID] then
            self.NormalMailList[UniqueID].MailReaded = 1
        end
        if self.StarMailList[UniqueID] then
            self.StarMailList[UniqueID].MailReaded = 1
        end
        self.CurContent.MailReaded = 1
        self.CurContent.SelfWidget:SetListItemObjectReadState()
        self.CurContent.SelfWidget:SetListItemObjectRewardGotState()
        self:BlockAllUIInput(false)
        self:CheckHaveReadToDeleteAll()
    else
        self:HandleAvatarRet(Ret)
    end
end

function M:OnDeleteMail(Ret, UniqueID)
    self:BlockAllUIInput(false)
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Mail_Delete_Success"))
    self:InitMailMain()
end

function M:HandleAvatarRet(Ret)
    self:BlockAllUIInput(false)
    if DataMgr.ErrorCode[Ret] then
        UIManager(self):ShowError(Ret)
    else
        local ErrorText = "Unknown_Error"
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(ErrorText), 1.5)
    end
end

function M:PlayInAnim()
    -- self:PlayAnimation(self.In)
end

function M:PlayOutAnim()
    -- self:PlayAnimation(self.Out)
end

function M:IsGift(Content)
    return Content.HeadIconId and Content.HeadIconId ~= 0
end

return M