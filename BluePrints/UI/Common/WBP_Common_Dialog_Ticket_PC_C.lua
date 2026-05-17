--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR zhangdongxu
-- @DATE ${date} ${time}
--
require "UnLua"

---@type Common_Dialog_Ticket_PC_C
local M = Class({"BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"})

--function M:Initialize(Initializer)
--end

function M:Construct()
    self:AddDispatcher(EventID.TeamMatchOneRefused, self, self.OnTeamMatchCancel)
    self:AddDispatcher(EventID.TeamMatchStartMatching, self, self.OnTeamMatchStartMatching)
    self:AddDispatcher(EventID.DungeonSelectTicketEnd, self, self.OnDungeonSelectTicketEnd)
    self:AddDispatcher(EventID.TeamMatchCancel, self, self.OnTeamMatchCancel)
    TeamController:RegisterEvent(self, function(self, EventId, ...)
        if EventId == TeamCommon.EventId.TeamOnInit or EventId == TeamCommon.EventId.TeamLeave then
            self.Owner:OnClose()
        end
    end)
end

function M:Destruct()
    TeamController:UnRegisterEvent(self)
end

function M:InitContent(Params, PopupData, Owner)
    self.Super.InitContent(self, Params, PopupData, Owner)
    self.Owner = Owner
    self.DungeonId = Params.DungeonId
    self:InitItemList(self.DungeonId)
    local Avatar = GWorld:GetAvatar()
    assert(Avatar, "NO AVATAR")
    
    self.Text_Choose:SetText(GText("UI_Ticket_Choose"))
    DebugPrint("gmy@WBP_Common_Dialog_Ticket_PC_C M:InitContent", Avatar:IsInMultiSettlement(), Avatar:IsInTeam())
    self.bIsInTeam = Avatar:IsInMultiSettlement() or Avatar:IsInTeam()
    self.bIsInMultiDungeon = Avatar:IsInMultiDungeon()
    self.bIsInTempScene = GWorld.GameInstance:IsInTempScene()
    if  self.bIsInTeam then
        self:BindDialogEvent("OnRightBtnClicked", self.OnRightBtnClicked)
        self.VB_CountDown:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.CountdownSeconds = DataMgr.GlobalConstant.TicketSelectTime.ConstantValue
        self:StartSelectCountDown()
    elseif self.bIsInMultiDungeon and not self.bIsInTempScene then
        self:BindDialogEvent("OnRightBtnClicked", self.OnRightBtnClicked)
        self.VB_CountDown:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.CountdownSeconds = DataMgr.GlobalConstant.TicketSelectTime.ConstantValue
        self:StartSelectCountDownInDungeon()
    else
        self.VB_CountDown:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end
--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:OnRightBtnClicked()
    self.Owner:ForbidRightBtn(true)
end


function M:InitItemList(DungeonId)
    self.TicketItemTable = {}
    if not DungeonId then
        DebugPrint("ZDX_DungeonId is nil")
        return
    end
    DebugPrint("ZDX_DungeonId is", DungeonId)
    self.DungeonId = DungeonId
    local DungeonData = DataMgr.Dungeon[DungeonId]
    self.TicketIds = {}
    if DungeonData.NoTicketEnter then
        table.insert(self.TicketIds, -1)
    end
    if DungeonData.TicketId then
        for i, Id in pairs(DungeonData.TicketId) do
            table.insert(self.TicketIds, Id)
        end
    end
    if #self.TicketIds ~= 0 then
        for i, Id in pairs(self.TicketIds) do
            local Item = self:CreateWidgetNew("DeputeTicket")
            Item.Button_Area.OnClicked:Add(self, function()
                self:OnItemClicked(Id)
            end)
            self.Item:AddChild(Item)
            Item:InitInfo(Id, self.Owner, self)
            self.TicketItemTable[Id] = Item
        end
    else
        DebugPrint("ZDX_TicketId List is nil")
    end
end

function M:OnContentFocusReceived(MyGeometry, InFocusEvent)
    --当聚焦到item的时候 设置聚焦到第一个关卡按钮
    --self.ScrollBox_List:GetChildAt(5).Bg_List.Button_Area:SetFocus()
    if self.Item:GetChildAt(0) then
        self.Item:GetChildAt(0):SetFocus()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        if self.Item:GetChildAt(0)  then
            self.Item:GetChildAt(0):SetFocus()
        end
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:PostInitContent(Params, PopupData, Owner)
    self:OnItemClicked(self.TicketIds[1], true)
    self.LastTickedItem:SetFocus()
end

function M:OnItemClicked(TicketId, bNotPlayAnim)
    if self.bIsInTeam then
        self.Owner:ForbidRightBtn(false)
    end
    if TicketId then
        local bSelected = self.TicketItemTable[TicketId]:OnClicked()
        if self.LastTickedItem and self.LastTickedItem ~= self.TicketItemTable[TicketId] and bSelected then
            self.LastTickedItem:OnCellUnSelect()
        end
        if bSelected then
            if not bNotPlayAnim then
                AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
            end
            self.LastTickedItem = self.TicketItemTable[TicketId]
            self.TicketId = TicketId
        else
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_disable", nil, nil)
        end
    end
end

function M:PackageData()
    return {TicketId = self.TicketId , DungeonId = self.DungeonId}
end


function M:StartSelectCountDown()
    local EndTime = TimeUtils.NowTime() + self.CountdownSeconds

    self:AddTimer(0.1, function()
        local RemainSeconds = math.max(0, math.floor(EndTime - TimeUtils.NowTime()))

        -- 更新UI：显示剩余秒数
        self.Text_CountDown:SetText(tostring(RemainSeconds))

        -- 倒计时结束处理
        if RemainSeconds <= 0 then
            local Avatar = GWorld:GetAvatar()
            if not Avatar then return end
            -- 服务端会处理超时拒绝，这里会导致选了多倍书，但只要倒计时走完也会拒绝
            -- Avatar:VoteStartBattle(false)
            self.Owner:OnClose()
            self:RemoveTimer("TicketSelectCountDown")
        end
    end, true, 0, "TicketSelectCountDown")
end

function M:StartSelectCountDownInDungeon()
    local GameState = UGameplayStatics.GetGameState(self)
    local Info = GameState.ClientTimerStruct:GetTimerInfo("SelectTicket")
    local NowTime = GameState.ReplicatedRealTimeSeconds
    self:AddTimer(0.1, function()
        local CurrentCountDown, CountDownPercent = self:GetRemainDungeonSelectTicketTime()
        local IntCountDown = math.ceil(CurrentCountDown)
        IntCountDown = math.max(IntCountDown, 0)
        self.Text_CountDown:SetText(tostring(IntCountDown))
        if CurrentCountDown < 1 then
            EventManager:FireEvent(EventID.OnSelectTicketTimeout, self.TicketId)
            self.Owner:OnClose()
            self:RemoveTimer("TicketSelectCountDown")
        end
    end, true, 0, "TicketSelectCountDown")
end

function M:GetRemainDungeonSelectTicketTime()
    local GameState = UGameplayStatics.GetGameState(self)
    local Info = GameState.ClientTimerStruct:GetTimerInfo("SelectTicket")
    local RemainVoteTime = Info.Time - (GameState.ReplicatedRealTimeSeconds - Info.RealTimeSeconds)
    local RemainPercent = (GameState.ReplicatedRealTimeSeconds - Info.RealTimeSeconds) / Info.Time
    return RemainVoteTime, RemainPercent
end

function M:OnTeamMatchCancel()
    --UIManager(self):ShowUITip("CommonToastMain", GText("TOAST_DUNGEON_CANCEL_REJECT"), 1.5)
    DebugPrint("TeamBattleEvent_SelectTicket  OnTeamMatchCancel ")
    self.Owner:OnClose()
end

function M:OnTeamMatchStartMatching()
    local Avatar = GWorld:GetAvatar()
    assert(Avatar, "Avatar is nil")
    local bIsInTeam = Avatar:IsInTeam()
    
    DebugPrint("gmy@WBP_Common_Dialog_Ticket_PC_C M:OnTeamMatchStartMatching", bIsInTeam, Avatar:IsInMultiSettlement())
    if bIsInTeam or Avatar:IsInMultiSettlement() then
        UIManager(self):LoadUINew("DungeonMatchTimingBar",
            self.DungeonId, Const.DUNGEON_MATCH_BAR_STATE.WAITING_MATCHING, true)
    end
    DebugPrint("TeamBattleEvent_SelectTicket  OnTeamMatchStartMatching ")
    self.Owner:OnClose()
end

function M:OnDungeonSelectTicketEnd()
    DebugPrint("TeamBattleEvent_SelectTicket  OnDungeonSelectTicketEnd ")
    self.Owner:OnClose()
end

return M
