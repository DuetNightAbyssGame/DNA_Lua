--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR zhangdongxu
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Vote_Dialog_Ticket_C
local M = Class({"BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"})

--function M:Initialize(Initializer)
--end

function M:Construct()
    self:AddDispatcher(EventID.DungeonSelectTicketEnd, self, self.OnDungeonSelectTicketEnd)
end

function M:Destruct()
    -- TeamController:UnRegisterEvent(self)
end

function M:InitContent(Params, PopupData, Owner)
    self.Super.InitContent(self, Params, PopupData, Owner)
    self.Owner = Owner
    self.DungeonId = Params.DungeonId
    self:InitItemList(self.DungeonId)
    local Avatar = GWorld:GetAvatar()
    assert(Avatar, "NO AVATAR")
    
    self.Text_Choose:SetText(GText("UI_Ticket_Choose"))
    self.bIsInTeam = Avatar:IsInMultiSettlement() or Avatar:IsInTeam()
    self.bIsInMultiDungeon = Avatar:IsInMultiDungeon()
    self.bIsInTempScene = GWorld.GameInstance:IsInTempScene()
    if self.bIsInMultiDungeon then
        self:BindDialogEvent("OnRightBtnClicked", self.OnRightBtnClicked)
        self.VB_CountDown:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.CountdownSeconds = DataMgr.GlobalConstant.TicketSelectTime.ConstantValue
        self:StartSelectCountDownInDungeon()
    else
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        print(_G.LogTag,"LXZ OnLoaded Ticket", GameState.DungeonProgress, Avatar.Dungeons[self.DungeonId].AutoProgress)
        if GameState.DungeonProgress - 1 <= Avatar.Dungeons[self.DungeonId].AutoProgress then
            self.LastTicketId = GWorld.GameInstance:GetTicketId() or -1
            self.AutoSelectTime = DataMgr.GlobalConstant.AutoRoundsCheckTime.ConstantValue or 5
            self:AddTimer(0.1, self.OnAutoSelectCountDown, true, -0.1, "OnAutoSelectCountDown")
            self.VB_CountDown:SetVisibility(UE4.ESlateVisibility.Collapsed)
        else
            self.VB_CountDown:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        -- self.VB_CountDown:SetVisibility(UE4.ESlateVisibility.Collapsed)
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
        return
    end
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
        print(_G.LogTag,"Error:LXZ TicketId List is nil")
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
    if self.bIsInMultiDungeon then
        self:OnItemClicked(self.TicketIds[1], true)
    else
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            return
        end
        local TicketId = -1
        local ResourceServerData = Avatar.Resources[self.LastTicketId]
        if ResourceServerData then
            local Count = ResourceServerData.Count
            if Count > 0 then
                TicketId = self.LastTicketId
            end
        end
        self:OnItemClicked(TicketId, true)
        
    -- else
    --     self:OnItemClicked(self.TicketIds[1], true)
    end
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
            local LastTicketId = GWorld.GameInstance:GetTicketId(TicketId)
            if not self.bIsInMultiDungeon and TicketId ~= LastTicketId then
                GWorld.GameInstance:SetTicketId(TicketId)
                self.Owner:GetButtonBar().Btn_Yes:SetText(GText("UI_CONFIRM_SELECTION"))
                self:RemoveTimer("OnAutoSelectCountDown")
                self.VB_CountDown:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
        else
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_disable", nil, nil)
        end
    end
end

function M:PackageData()
    return {TicketId = self.TicketId , DungeonId = self.DungeonId}
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

function M:OnDungeonSelectTicketEnd()
    DebugPrint("TeamBattleEvent_SelectTicket  OnDungeonSelectTicketEnd ")
    self.Owner:OnClose()
end

function M:OnAutoSelectCountDown()
    self.AutoSelectTime = self.AutoSelectTime - 0.1
    local IntCountDown = math.ceil(self.AutoSelectTime)
    IntCountDown = math.max(IntCountDown, 0)
    -- self.Text_CountDown:SetText(tostring(IntCountDown))
    local Text = string.format(GText("UI_Auto_Round_TicketConfirm_Time"), IntCountDown)
    self.Owner:GetButtonBar().Btn_Yes:SetText(Text)
    if self.AutoSelectTime <= 0 then
        EventManager:FireEvent(EventID.OnSelectTicketTimeout, self.TicketId)
        self.Owner:OnClose()
        self:RemoveTimer("OnAutoSelectCountDown")
    end
end

return M
