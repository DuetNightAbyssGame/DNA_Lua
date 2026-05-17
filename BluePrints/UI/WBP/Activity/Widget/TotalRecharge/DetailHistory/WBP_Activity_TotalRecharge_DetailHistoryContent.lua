--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local GachaModel = require "BluePrints.UI.WBP.Gacha.GachaModel"

---@type WBP_Gacha_DetailContent_C
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

function M:Construct()
    self.Super.Construct(self)
    self.PerPageRecordCount = 10      --每页记录数
    self.Text_Designation:SetText(GText("UI_Event_CumulativeTopUpEvent_GoodsName"))
    -- self.Text_Quality:SetText(GText("UI_RARITY_NAME"))
    self.Text_Type:SetText(GText("UI_Event_CumulativeTopUpEvent_GoodsToCredit"))
    self.Text_Time:SetText(GText("UI_Event_CumulativeTopUpEvent_CreditTime"))
    self.Text_History_Empty:SetText(GText('UI_Event_CumulativeTopUpEvent_Empty'))
    -- self.Btn_Before.SoundFunc = function ()
    --     AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_03", nil, nil)
    -- end
    -- self.Btn_Next.SoundFunc = function ()
    --     AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_03", nil, nil)
    -- end
    self.Btn_Before:BindEventOnClicked(self,self.OnFlipBefore)
    self.Btn_Next:BindEventOnClicked(self,self.OnFlipNext)
    self.Key_ImgLeft:CreateGamepadKey(UIConst.GamePadImgKey.DPadLeft)
    self.Key_ImgRight:CreateGamepadKey(UIConst.GamePadImgKey.DPadRight)
 end

function M:InitContent(Params, PopupData, Owner)
    self.Super.InitContent(self, Params, PopupData, Owner)
    self.EventId = Params.EventId
    self.Parent = Params.Parent
    self:BindDialogEvent(DialogEvent.OnTitleTabSelected, self.OnTabSelected)
    -- self.ButtonIndexA = self:ShowGamepadShortcutBtn({
    --     KeyInfoList={
    --         {
    --             Type = "Img",
    --             ImgShortPath = UIConst.GamePadImgKey.FaceButtonBottom
    --         },
    --     },
    --     Desc = GText("UI_Controller_Check"),
    -- })
    self.ButtonIndexRV = self:ShowGamepadShortcutBtn({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = UIConst.GamePadImgKey.RightTriggerAnalog
            },
        },
        Desc = GText("UI_Controller_Slide"),
    })
    -- self:HideGamepadShortcut(self.ButtonIndexRV)
    local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem(self)
    GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
    self.NowTabId = 1
    -- self.WS:SetActiveWidgetIndex(self.NowTabId - 1)
    self:InitHelpContent()
    self:InitListHistory()
    -- self.List_Probability:SetFocus()
end

function M:InitHelpContent()
    local Config = DataMgr.CumulativeTopUpEvent[self.EventId]
    self.TextTitle_1:SetText(GText("UI_Event_CumulativeTopUpEvent_CreditGetRuleTitle"))
    self.TextContent_1:SetText(GText(Config.EventRule))
    self.TextTitle_2:SetText(GText("UI_Event_CumulativeTopUpEvent_CreditInhertRuleTitle"))
    self.TextContent_2:SetText(GText("UI_Event_CumulativeTopUpEvent_CreditInhertRuleDes"))
    self.PointsRules.Text_Name:SetText(GText("UI_Event_CumulativeTopUpEvent_GoodsName"))
    self.PointsRules.Text_Integral:SetText(GText("UI_Event_CumulativeTopUpEvent_GoodsToCredit"))

    self.PointsRules.List_HelpItem:DisableScroll(true)
    self.PointsRules.List_HelpItem:ClearListItems()
    local PayGoodsToScore = DataMgr.PayGoodsToScore[self.EventId]
    local keys = {}
    for k, _ in pairs(PayGoodsToScore) do
        table.insert(keys, k)
    end
    table.sort(keys)
    for index, key in ipairs(keys) do
        local Item = PayGoodsToScore[key]
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.GoodsName = Item.GoodsName
        Content.Score = Item.PayGoodsScore
        Content.Id = index
        self.PointsRules.List_HelpItem:AddItem(Content)
    end
end

function M:InitListHistory()
    local PlayerAvatar = GWorld:GetAvatar()
    if not PlayerAvatar then return end

    self.ActivityData = PlayerAvatar and PlayerAvatar.AccumulateRecharge and PlayerAvatar.AccumulateRecharge[self.EventId]

    local RecordData = self.ActivityData and self.ActivityData.ScoreRecord
    local RecordLength = RecordData and RecordData:Length() or 0
    if RecordLength == 0 then
        self.Group_Normal:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Group_Empty:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Group_Normal:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Group_Empty:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.PageIndex = 1
        self.PageMax = (RecordLength + self.PerPageRecordCount - 1) // self.PerPageRecordCount
        self.Btn_Before:ForbidBtn(false)
        self.Btn_Next:ForbidBtn(false)
        if self.PageIndex == self.PageMax then
            self.Btn_Before:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Btn_Next:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Text_Page:SetText(self.PageMax)
        else
            self.Btn_Before:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.Btn_Next:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.Text_Page:SetText(self.PageIndex.."/"..self.PageMax)
            self.Btn_Before:ForbidBtn(true)
        end
        self:UpdateListRecord()
    end
end

function M:UpdateListRecord()
    local RecordData = self:GetScoreRecord((self.PageIndex - 1) * self.PerPageRecordCount, self.PerPageRecordCount)

    local AllPayConfig = DataMgr.PayGoodsToScore or {}
    local PayGoodsToScore = AllPayConfig[self.EventId] or {}

    self.List_History:ClearListItems()
    
    for key, value in ipairs(RecordData) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        local goodsConfig = PayGoodsToScore[value.GoodsId]
        Content.Id = key
        Content.GoodsName = goodsConfig and goodsConfig.GoodsName or "Unknown Goods"
        Content.Score = value.Score
        Content.ScoreTime = value.TimeStamp
        self.List_History:AddItem(Content)
    end
    self.List_History:ScrollIndexIntoView(0)
end

function M:GetScoreRecord(StartIndex, Limit)
    local RecordData = self.ActivityData and self.ActivityData.ScoreRecord
    if not RecordData then return {} end

    local RecordLength = RecordData:Length()
    if RecordLength == 0 then return {} end

    local Result = {}
    local Count = 0
    for i = RecordLength - StartIndex, 1, -1 do
        if Count >= Limit then break end
        
        if RecordData[i] then
            table.insert(Result, RecordData[i])
            Count = Count + 1
        end
    end
    
    return Result
end

function M:OnTabSelected(TabWidget)
    self.NowTabId = TabWidget.Idx
    self.Owner:SetFocus()
    if self.FocusOnSubItem then
        self.FocusOnSubItem = false
    end
    self.Ws_Content:SetActiveWidgetIndex(self.NowTabId - 1)
    local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem(self)
    -- GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
    if self.Ws_Content:GetActiveWidgetIndex() == 0 then
        -- self:ShowGamepadShortcut(self.ButtonIndexA)
        self:ShowGamepadShortcut(self.ButtonIndexRV)
    else
        -- self:HideGamepadShortcut(self.ButtonIndexA)
        self:HideGamepadShortcut(self.ButtonIndexRV)
    end
end

function M:OnContentAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
   local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
   local AddOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
   if InKeyName == UIConst.GamePadKey.RightAnalogY and self.Ws_Content:GetActiveWidgetIndex() == 0 then
       local CurScrollOffset = self.ScrollBox_Integral:GetScrollOffset()
       local ScrollOffset = math.clamp(CurScrollOffset - AddOffset, 0, self.ScrollBox_Integral:GetScrollOffsetOfEnd())
       self.ScrollBox_Integral:SetScrollOffset(ScrollOffset)
       return UIUtils.Handled
   end
   return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    end
    return IsEventHandled
end

function M:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    if InKeyName == UIConst.GamePadKey.DPadLeft then
        self:OnFlipBefore()
        IsEventHandled = true
    elseif InKeyName == UIConst.GamePadKey.DPadRight then
        self:OnFlipNext()
        IsEventHandled = true
    end
    return IsEventHandled
end

function M:OnFlipBefore()
    if self.PageIndex == 1 then
        return
    end
    if self.PageIndex == self.PageMax then
        self.Btn_Next:ForbidBtn(false)
    end
    self.PageIndex = self.PageIndex - 1
    if self.PageIndex == 1 then
        self.Btn_Before:ForbidBtn(true)
    end
    self.Text_Page:SetText(self.PageIndex.."/"..self.PageMax)
    self:UpdateListRecord()
end

function M:OnFlipNext()
    if self.PageIndex == self.PageMax then
        return
    end
    if self.PageIndex == 1 then
        self.Btn_Before:ForbidBtn(false)
    end
    self.PageIndex = self.PageIndex + 1
    if self.PageIndex == self.PageMax then
        self.Btn_Next:ForbidBtn(true)
    end
    self.Text_Page:SetText(self.PageIndex.."/"..self.PageMax)
    self:UpdateListRecord()
end

return M