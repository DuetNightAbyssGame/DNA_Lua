require "UnLua"
require "DataMgr"
local InventoryCommonConst = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryCommonConst")
local InventoryController = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryController")
local SoloTreasureUtils = require("BluePrints.UI.WBP.SoloTreasure.Widget.SoloTreasureUtils")

local M = Class({"BluePrints.UI.BP_UIState_C"})

function M:Construct()
    self.NumChangePeriod = self.NumChangePeriod or 0.5
end

function M:Destruct()

end

-- @param MechanismUid 搜索id,每次与机关交互后打开背包传入
-- @param BagId 背包id，进入副本初始化时传入，来源是服务器
function M:OnLoaded(...)
    local ServerEntity = GWorld:GetServerEntity()
    if not ServerEntity then
        GWorld.logger.error("搜打撤副本内才能打开背包")
        self.Super.Close(self)
        return
    end
    self.Dungeonobject = ServerEntity:GetDungeonObject()
    if not self.Dungeonobject then
        GWorld.logger.error("搜打撤副本内才能打开背包")
        self.Super.Close(self)
        return
    end

    local Params = ...
    if type(Params) == "table" and Params.bSacrifice then
        self.SacrificeParams = Params
        self.MechanismUid = nil
    elseif type(Params) == "string" or type(Params) == "number" then
        self.MechanismUid = Params
        self.SacrificeParams = nil
    else
        self.MechanismUid = nil
        self.SacrificeParams = nil
    end
    local ControllerInitParams = {
        MainWidget = self,
    }
    self.InventoryController = InventoryController
    InventoryController:Init(ControllerInitParams)

    self.BagId = InventoryController.InventoryModel.BagId
    InventoryController:OnMainWidgetLoaded(ControllerInitParams)

    self:InitBagSection()
    if self.SacrificeParams then
        self.Bag_Search:SetVisibility(ESlateVisibility.Collapsed)
        self:InitSacrificeSection(self.SacrificeParams)
    else
        self:InitSearchSection(self.MechanismUid)
    end
    self:InitRecycleSection()
    self:InitEvents()
    self:InitBuff()
    self:SetVisibility(ESlateVisibility.Collapsed)
    self:AddDelayFrameFunc(function()
        self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self:PlayInAnim()
    end, self.DelayFrame, "PlayInAnim")
    EventManager:FireEvent(EventID.ShowCountDownTips)
end

function M:InitBagSection()
    self.WBP_Close:BindEventOnPressed(self, function()
        if not UIUtils.IsGamepadInput() then return end
        self:CloseSelf()
    end)
    self.WBP_Close:BindEventOnClicked(self, function()
        if UIUtils.IsGamepadInput() then return end
        self:CloseSelf()
    end)

    self.Text_Top:SetText(GText("UI_Extraction_TotalScore"))
    self.Btn_Search:BindEventOnPressed(self, function()
        if UIUtils.IsGamepadInput() then return end
        self:OnBtnSearchPressed()
    end)
    local InitParams = {
        Parent = self,
    }
    self.Bag_Detail:Init(InitParams)
    self.Bag_Detail:SetVisibility(ESlateVisibility.Collapsed)

    self:AddDelayFrameFunc(function() -- 口袋分帧加载完成后更新
        self:UpdateTreasureValues()
        self:UpdateBagGridOccupancy()
    end, self.DelayFrame, "UpdateTreasureValues")
    self:UpdateShowTotalScore(0)

    self.Text_Center:SetText(GText("UI_Extraction_TreasureStorage"))
    self.Text_Capacity:SetText(GText("UI_Extraction_BackpackSpace"))
    self.Text_Title:SetText(GText("UI_Extraction_Backpack"))
end

function M:UpdateTreasureValues()
    local BagTreasureValue = InventoryController:GetBagTreasureValue()
    self.Dungeonobject:OnNotifyGameModeDungeonEvent_OnUpdateTreasureScore(BagTreasureValue)
end

function M:UpdateBagGridOccupancy()
    local BagGridOccupancyData = InventoryController:GetBagGridOccupancyData()
    if BagGridOccupancyData then
        self.Text_CapacityNum:SetText(tostring(BagGridOccupancyData.OccupancyGridNum .. "/" .. BagGridOccupancyData.AllGridNum))
    end
end

function M:InitSearchSection(MechanismUid)
    if MechanismUid then
        local InitParams = {
            Parent = self,
            MechanismUid = MechanismUid,
        }
        self.Bag_Search.Panel_Search:SetVisibility(ESlateVisibility.Collapsed)
        self:AddDelayFrameFunc(function()
            self.Bag_Search:Init(InitParams)
            self.Bag_Search:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end, self.DelayFrame, "InitSearchSection")
    else
        self.Bag_Search:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:InitSacrificeSection(SacrificeParams)
    if not self.Bag_Sacrifice then return end
    local InitParams = {
        Parent = self,
        ServerUniqueId = SacrificeParams.ServerUniqueId,
        TributeId = SacrificeParams.TributeId,
        BPGambleMech = SacrificeParams.BPGambleMech,
    }
    self.Bag_Sacrifice.Panel_Search:SetVisibility(ESlateVisibility.Collapsed)
    self:AddDelayFrameFunc(function()
        self.Bag_Sacrifice:Init(InitParams)
        self.Bag_Sacrifice:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end, self.DelayFrame, "InitSacrificeSection")
end

function M:InitRecycleSection()
    local RecycleParams = {
        Parent = self,
    }
    self:AddDelayFrameFunc(function()
        self.Btn_Recycle:Init(RecycleParams)
    end, self.DelayFrame + 1, "InitRecycleSection")
end

function M:InitEvents()
    self.ScrollBoxPockets.OnUserScrolled:Add(self, function()
        InventoryController.bDetectDrag = false
    end)
    InventoryController.bDetectDrag = false
    self:AddDispatcher(EventID.OnTreasureItemDrop, self, function(_, MoveInfo)
        self:UpdateTreasureValues()
        self:UpdateBagGridOccupancy()
        self.ScrollBoxPockets:SetVisibility(ESlateVisibility.Visible)
    end)

    self:AddDispatcher(EventID.OnTreasureItemDragDetected, self, function(_, DragGridData)
        self.ScrollBoxPockets:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end)
    self:AddDispatcher(EventID.OnTreasureItemDragCancelled, self, function(_)
        self.ScrollBoxPockets:SetVisibility(ESlateVisibility.Visible)
    end)

    self:AddDispatcher(EventID.OnUpdateBagTreasureScore, self, function(CallObj, AddTreasureScore)
        self:UpdateShowTotalScore(AddTreasureScore)
    end)
    self:AddDispatcher(EventID.MainPlayerBeAttacked, self, function(_)
        if self._hitAnimOnCD then
            return
        end
        self._hitAnimOnCD = true
        self:StopAnimation(self.Hit)
        self:PlayAnimation(self.Hit)
        self:AddTimer(1.0, function(s)
            s._hitAnimOnCD = false
        end, false, 0, "HitAnimCD")
    end)
    if self.InitPCEvents then
        self:InitPCEvents()
    end
end

function M:UpdateShowTotalScore(AddTreasureScore)
    self.TotalScore = (self.Dungeonobject.TreasureScore or 0) + (self.Dungeonobject.KillMonsterScore or 0)
    self.Text_Num:SetText(Utils.FormatNumber(self.TotalScore, false))
    UIUtils.RollingNumberEffect(self, self.Text_Num, self.TotalScore - AddTreasureScore, AddTreasureScore, self.NumChangePeriod)
end

function M:InitBuff()
    self.ActivatedTicketId = self.Dungeonobject.SoloTreasureTicketId
    if not self.ActivatedTicketId then
        self.Buff:SetVisibility(ESlateVisibility.Collapsed)
    else
        local LotteryData = DataMgr.ExtractionLottery[self.ActivatedTicketId]
        if not LotteryData then
            DebugPrint("@zyh 没有该Id的彩票" .. self.ActivatedTicketId)
        end
        DebugPrint("彩票的品质为".. LotteryData.Quality)
        self.Buff:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Buff:InitData({
            Description = LotteryData.Desc,
            Quality = LotteryData.Quality,
        })
    end
end

function M:RemoveEvents()
    self:RemoveDispatcher(EventID.OnTreasureItemDrop, self)
    self:RemoveDispatcher(EventID.OnTreasureItemDragDetected, self)
    self:RemoveDispatcher(EventID.OnTreasureItemDragCancelled, self)
    self:RemoveDispatcher(EventID.OnUpdateBagTreasureScore, self)
    self:RemoveDispatcher(EventID.MainPlayerBeAttacked, self)
    if self.RemovePCEvents then
        self:RemovePCEvents()
    end
end

function M:Tick(Geometry, DeltaTime)
    if InventoryController and InventoryController.bInit then
        InventoryController:Tick(Geometry, DeltaTime)
    end
    -- ComTab 消费：UpdateComTab 只写 pending state，Tick 每帧消费一次，天然防重入
    if self._PendingComTabState then
        local state = self._PendingComTabState
        self._PendingComTabState    = nil
        self._PendingComTabPriority = nil
        self:_DoUpdateComTab(state)
    end
    if UIUtils.IsGamepadInput() then
        self:UpdateGamepadCursorPosition()
    end
    if not self.ScrollBoxPocketsCanScroll then
        self.ScrollBoxPocketsCanScroll = UIUtils.CheckScrollBoxCanScroll(self.ScrollBoxPockets)
    end
    if self.ScrollBoxPocketsCanScroll then
        local TriggerParams = {
            DeltaTime = DeltaTime,
            ScrollBox = self.ScrollBoxPockets,
            TriggerScrollUp = self.DragScrollTip_Up,
            TriggerScrollDown = self.DragScrollTip_Bottom,
            ShowPocketsScrollUpArrow = self.ShowPocketsScrollUpArrow,
            ShowPocketsScrollDownArrow = self.ShowPocketsScrollDownArrow,
            CurTouchPos = self.CurTouchPos or nil, -- 移动端
        }
        SoloTreasureUtils:TickTriggerScrollSizeBox(TriggerParams)
    end
    if self.MechanismUid then
        self.Bag_Search:Tick(Geometry, DeltaTime)
    end
    if self.SacrificeParams and self.Bag_Sacrifice then
        self.Bag_Sacrifice:Tick(Geometry, DeltaTime)
    end
end

function M:PlayInAnim()
    self:PlayAnimation(self.In)
end

function M:CloseSelf()
    self:StopAllAnimations()
    self:PlayAnimation(self.Out, 0 , 1, EUMGSequencePlayMode.Forward, 1.5)
    self:RemoveEvents()
    self:BindToAnimationFinished(self.Out, {self, function()
        self:UnbindAllFromAnimationFinished(self.Out)
        self:TryClose()
    end})
    if self.Bag_Search and IsValid(self.Bag_Search) and self.MechanismUid then
        self.Bag_Search:CloseSelf()
    end
    if self.Bag_Sacrifice and IsValid(self.Bag_Sacrifice) and self.SacrificeParams then
        self.Bag_Sacrifice:CloseSelf()
    end
    self.Btn_Recycle:CloseSelf()
    self.Bag_Detail:CloseSelf()
    for CurBagPocketName, CurBagPocketInfo in pairs(InventoryController.CurBagPocketNames) do
        local CurBagPocketWidget = self[CurBagPocketName]
        if CurBagPocketWidget and IsValid(CurBagPocketWidget) then
            CurBagPocketWidget:Close()
        end
    end
end

function M:TryClose()
    if self.GameInputModeSubsystem then
        self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
    end
    self.MechanismUid = nil
    self.TempBagId = nil
    InventoryController:OnMainWidgetClosed()
    self.Super.Close(self)
end

function M:OnBtnSearchPressed()
    if InventoryController.bDraging then return end
    if self.bInBagDetailState then
        self:LeaveBagDetailState()
    else
        self:EnterBagDetailState()
    end
end

function M:EnterBagDetailState()
    if self.bInBagDetailState or InventoryController.bDraging then return end
    self.Bag_Detail:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Bag_Detail:PlayInAnim()
    self.bInBagDetailState = true
    if self.UpdateComTab then
        self:UpdateComTab("BagDetail")
    end
end

function M:LeaveBagDetailState()
    if not self.bInBagDetailState or InventoryController.bDraging then return end
    self.Bag_Detail:PlayOutAnim()
    self.bInBagDetailState = false
    if self.UpdateComTab then
        self:UpdateComTab("Normal")
    end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if UIUtils.IsGamepadInput() then
        self.BagSelect_Controller:SetFocus()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

return M
