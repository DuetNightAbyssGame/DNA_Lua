local M = Class({ "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase" })

function M:Construct()
    self.ResultText = self.Text_Designation
    self.RoundText = self.Text_Type
    self.TimeText = self.Text_Time
    self.RecordListView = self.List_History
    self.PageText = self.Text_Page
    self.PageUpKeySwitcher = self.WS_Left
    self.PageDownKeySwitcher = self.WS_Right
    self.PageUpButton = self.Btn_Before
    self.PageDownButton = self.Btn_Next
    self.GamepadPageUpKey = self.Key_ImgLeft
    self.GamepadPageDownKey = self.Key_ImgRight
    self.EmptyRecordText = self.Text_GachaHistory_Empry
    self.RecordPanel = self.Group_Normal
    self.EmptyRecordPanel = self.Group_Empty

    self.ResultText:SetText(GText("UI_LimitedPrizePool_PrizeResult"))
    self.RoundText:SetText(GText("UI_LimitedPrizePool_PrizeRound"))
    self.TimeText:SetText(GText("UI_LimitedPrizePool_PrizeTime"))
    self.EmptyRecordText:SetText(GText("UI_LimitedPrizePool_NoHistory"))

    self.GamepadPageUpKey:CreateGamepadKey(UIConst.GamePadImgKey.DPadLeft)
    self.GamepadPageDownKey:CreateGamepadKey(UIConst.GamePadImgKey.DPadRight)

    self.PageUpButton:BindEventOnClicked(self, self.PageUp)
    self.PageDownButton:BindEventOnClicked(self, self.PageDown)

    self.PoolId = nil
    self.RecordList = nil
    self.PerPageRecordCount = 10
    self.CurrentPageNumber = 0
    self.PageCount = 0
end

function M:Destruct()
end

function M:InitContent(Params, PopupData, Owner)
    self.Super.InitContent(self, Params, PopupData, Owner)

    self.PoolId = Params.PoolId

    self.RecordList = self:GenerateServerAdaptationRewardList(Params.PoolId)

    self.PageCount = math.ceil(#self.RecordList / self.PerPageRecordCount)

    if (self.PageCount == 0) then
        self.RecordPanel:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.EmptyRecordPanel:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.RecordPanel:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.EmptyRecordPanel:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self:SetCurrentPage(1)
    end
end

function M:InitGamepadView()
    self.PageUpKeySwitcher:SetActiveWidgetIndex(1)
    self.PageDownKeySwitcher:SetActiveWidgetIndex(1)
end

function M:InitKeyboardView()
    self.PageUpKeySwitcher:SetActiveWidgetIndex(0)
    self.PageDownKeySwitcher:SetActiveWidgetIndex(0)
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
    local Key = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(Key)

    local bHandled = false
    if KeyName == UIConst.GamePadKey.DPadLeft then
        bHandled = true
        self:PageUp()
    elseif KeyName == UIConst.GamePadKey.DPadRight then
        bHandled = true
        self:PageDown()
    end
    return bHandled
end

function M:GenerateServerAdaptationRewardList(PoolId)
    local RewardList = {}
    local Avatar = GWorld:GetAvatar()
    if (Avatar) then
        local Pool = Avatar.LimitPrize[PoolId]
        if (Pool) then
            PrintTable(Pool.Record, 3)
            for _, Record in ipairs(Pool.Record) do
                table.insert(RewardList, Record.Props)
            end
        end
    end
    return RewardList
end

function M:SetCurrentPage(NewPageNumber)
    if (NewPageNumber < 1 or NewPageNumber > self.PageCount or self.CurrentPageNumber == NewPageNumber) then
        return
    end

    self.CurrentPageNumber = NewPageNumber

    self.PageText:SetText(string.format("%d/%d", self.CurrentPageNumber, self.PageCount))

    local MinRecordIndex = (self.CurrentPageNumber - 1) * self.PerPageRecordCount + 1
    local MaxRecordIndex = math.min(self.CurrentPageNumber * self.PerPageRecordCount, #self.RecordList)

    self.RecordListView:ClearListItems()
    for i = MinRecordIndex, MaxRecordIndex do
        local Record = self.RecordList[i]
        local Content = UE4.NewObject(UIUtils.GetCommonItemContentClass())
        Content.PoolId = self.PoolId
        Content.RoundNumber = Record.Round
        Content.PrizeIndex = Record.PrizeIndex
        Content.SelectedIndex = Record.SelfSelectId
        Content.Time = Record.TimeStamp
        self.RecordListView:AddItem(Content)
    end
end

function M:PageUp()
    self:SetCurrentPage(self.CurrentPageNumber - 1)
end

function M:PageDown()
    self:SetCurrentPage(self.CurrentPageNumber + 1)
end

return M
