--
-- DESCRIPTION
--
-- @COMPANY ** 搜打撤献祭面板
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local InventoryController = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryController")
local InventoryCommonConst = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryCommonConst")
local SoloTreasureUtils = require("BluePrints.UI.WBP.SoloTreasure.Widget.SoloTreasureUtils")
local EMCache = require "EMCache.EMCache"

local SACRIFICE_CONFIRM_POPUP_ID = 100341
local SACRIFICE_SKIP_CONFIRM_KEY = "SoloTreasure_Sacrifice_SkipConfirm"

-- BP_GambleMech 状态机 ID（与 BP_GambleMech.lua 中 ChangeState 调用保持一致）
local GAMBLE_MECH_STATE_TRIBUTE_CANCLE  = 1310693
local GAMBLE_MECH_STATE_TRIBUTE_SUCCESS = 1310694

---@type WBP_SoloTreasure_BagSacrifice_C
local M = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.Common.TimerMgr",
    "BluePrints.Common.DelayFrameComponent",
    "BluePrints.UI.BP_EMUserWidgetUtils_C",
})

-- @description 初始化献祭面板
-- @param InitParams 初始化参数
-- @field Parent 父容器
-- @field ServerUniqueId 献祭机关的服务器唯一Id
function M:Init(InitParams)
    self.Parent = InitParams.Parent
    self.ServerUniqueId = InitParams.ServerUniqueId
    self.TributeId = InitParams.TributeId
    self.BPGambleMech = InitParams.BPGambleMech
    self:PlayInAnim()
    if not self.Parent or not InventoryController or not InventoryController.bInit then return end
    if not self.TributeId or not self.ServerUniqueId then return end
    local PocketName = InventoryCommonConst.SearchPocketNamePrefix .. self.ServerUniqueId

    local ServerEntity = GWorld:GetServerEntity()
    if not ServerEntity then return end
    self.Dungeonobject = ServerEntity:GetDungeonObject()
    if not self.Dungeonobject then return end
    local TributeInfo = DataMgr.ExtractionTreasureTribute[self.TributeId]
    if not TributeInfo then return end

    local Size = FVector2D(TributeInfo.Shape[1], TributeInfo.Shape[2])
    local PocketData = nil
    if not InventoryController.InventoryModel.Pockets[PocketName] then
        PocketData = {
            Name = PocketName,
            Size = Size,
            Parent = InventoryController.MainWidget,
            Inventory = InventoryCommonConst.PocketType.Mechanism,
            MechanismUid = self.ServerUniqueId,
        }
        InventoryController.InventoryModel.Pockets[PocketName] = PocketData
        InventoryController:InitGridsData(PocketData)
    end

    self.PocketWidget = self["WBP_Search_Bag"]
    if not self.PocketWidget then return end
    self.PocketWidget:Init({
        Name = PocketName,
        Size = Size,
        Inventory = InventoryCommonConst.PocketType.Mechanism,
        MechanismUid = self.ServerUniqueId,
        Parent = self,
        PocketData = PocketData or InventoryController.InventoryModel.Pockets[PocketName],
    })
    self:InitEvents()
    self.EMScrollBox:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Text_Search:SetText(GText("UI_Extraction_TM_10"))
    self.Btn_Scrifice.Text_Button:SetText(GText("UI_Extraction_TM_13"))
    self.Text_Value:SetText(GText("UI_Extraction_TM_12"))

    self.Btn_Qa:Init({
        OwnerWidget = self,
        TextContent = GText("UI_Extraction_TM_11"),
        OnMenuOpenChangedCallBack = function(_, bOpen)
            self:OnSacrificeOverlayOpen(bOpen)
        end,
    })

    local DungeonId = self.Dungeonobject.DungeonId
    local SoloTreasureInfo = DataMgr.SoloTreasure[DungeonId]
	if not SoloTreasureInfo then
		return
	end
    self.GamePlayIds = SoloTreasureInfo.GamePlayId or {}
	for _, GamePlayId in pairs(self.GamePlayIds) do
		local GamePlayInfo = DataMgr.SoloTreasureGamePlay[GamePlayId]
		if GamePlayInfo and GamePlayInfo.type == 2 then
			self.GameplayId = GamePlayId
		end
	end
    local GamePlayInfo = DataMgr.SoloTreasureGamePlay[self.GameplayId]
    if not GamePlayInfo then return end
    self.Thresholds = {}
    self.Thresholds[1] = 1
    for i = 1, 3 do
        self.Thresholds[i + 1] = GamePlayInfo["Gear"..i] or 9999
    end
    
    self.SacrificeItemWidgets = {
        self.SacrificeItem,
        self.SacrificeItem_1,
        self.SacrificeItem_2,
        self.SacrificeItem_3,
    }
    for i, Item in ipairs(self.SacrificeItemWidgets) do
        if Item and IsValid(Item) then
            Item:Init(self.Thresholds[i])
        end
    end
    self:InitSacrificeBtn()
    self:InitGamepadKeys()
    self.CurTotalValue = 0
    self.CurPercent = 0
    self:UpdateProgress()
end

function M:InitSacrificeBtn()
    local Btn = self.Btn_Scrifice
    if not Btn then return end
    -- 初始状态由 UpdateProgress → SetSacrificeBtnEnabled 根据口袋实际价值决定

    Btn.Btn_Click.OnHovered:Clear()
    Btn.Btn_Click.OnHovered:Add(self, function()
        if not self.bSacrificeBtnEnabled then return end
        Btn:StopAnimation(Btn.UnHover)
        Btn:PlayAnimation(Btn.Hover)
    end)
    Btn.Btn_Click.OnUnHovered:Clear()
    Btn.Btn_Click.OnUnHovered:Add(self, function()
        if not self.bSacrificeBtnEnabled then return end
        Btn:StopAnimation(Btn.Hover)
        Btn:PlayAnimation(Btn.UnHover)
    end)
    Btn.Btn_Click.OnPressed:Clear()
    Btn.Btn_Click.OnPressed:Add(self, function()
        if not self.bSacrificeBtnEnabled then return end
        Btn:PlayAnimation(Btn.Press)
    end)
    Btn.Btn_Click.OnClicked:Clear()
    Btn.Btn_Click.OnClicked:Add(self, function()
        self:TryConfirmSacrifice()
    end)
end

function M:SetSacrificeBtnEnabled(bEnabled)
    if self.bSacrificeBtnEnabled == bEnabled then return end
    self.bSacrificeBtnEnabled = bEnabled
    local Btn = self.Btn_Scrifice
    if not Btn then return end
    Btn:StopAllAnimations()
    if bEnabled then
        Btn:PlayAnimation(Btn.Normal)
    else
        Btn:PlayAnimation(Btn.Forbidden)
    end
end

function M:TryConfirmSacrifice()
    if not self.bSacrificeBtnEnabled then
        UIManager(self):ShowUITip("CommonToastMain", GText("UI_Extraction_TM_10"))
        return
    end
    -- 已勾选"下次不再提醒"，直接执行献祭
    if EMCache:Get(SACRIFICE_SKIP_CONFIRM_KEY, true) then
        self:OnSacrificeConfirm()
        return
    end
    -- 弹出二次确认弹窗（含"下次不再提醒"勾选项）
    self:OnSacrificeOverlayOpen(true)
    local Params = {
        RightCallbackFunction = function(_, Data)
            self:OnSacrificeOverlayOpen(false)
            if Data and Data.SelectHint and Data.SelectHint.IsSelected then
                EMCache:Set(SACRIFICE_SKIP_CONFIRM_KEY, true, true)
            end
            self:OnSacrificeConfirm()
        end,
        LeftCallbackFunction = function()
            self:OnSacrificeOverlayOpen(false)
        end,
    }
    UIManager(self):ShowCommonPopupUI(SACRIFICE_CONFIRM_POPUP_ID, Params)
end

function M:OnSacrificeConfirm()
    if not self.BPGambleMech or not IsValid(self.BPGambleMech) then return end
    local Btn = self.Btn_Scrifice
    if Btn then Btn:PlayAnimation(Btn.Click) end
    self.BPGambleMech:TributeSuccess()
    if self.Parent and self.Parent.CloseSelf then
        self.Parent:CloseSelf()
    end
end

function M:InitEvents()
    self:AddDispatcher(EventID.OnTreasureItemDrop, self, function()
        self:UpdateProgress()
    end)
end

function M:UpdateProgress()
    if not self.ServerUniqueId or not self.Thresholds then return end
    local PocketName = InventoryCommonConst.SearchPocketNamePrefix .. self.ServerUniqueId
    local ValueInfo = SoloTreasureUtils:GetPocketTreasureValueInfo(PocketName)
    local TotalValue = ValueInfo.TotalValue

    -- 更新当前价值数字（带滚动效果）
    local PrevValue = self.CurTotalValue or 0
    self.CurTotalValue = TotalValue
    self.Num_Value:SetText(Utils.FormatNumber(TotalValue, false))
    UIUtils.RollingNumberEffect(self, self.Num_Value, PrevValue, TotalValue - PrevValue, 0.5)

    -- 更新进度条目标值（在 Tick 里 lerp，避免突变）
    -- 进度条为分段线性：4 个阈值构成 3 段，每段占 1/3 bar 宽，段内按比例填充
    self.TargetPercent = self:CalcBarPercent(TotalValue)

    -- 更新各阶段 item 高亮状态
    for _, Item in ipairs(self.SacrificeItemWidgets or {}) do
        if Item and IsValid(Item) then
            Item:UpdateProgressNum(TotalValue)
        end
    end

    -- 同步献祭按钮可用状态
    self:SetSacrificeBtnEnabled(TotalValue > 0)
end

-- 分段线性进度：4 个阈值 → 3 段，每段占 1/3 bar 宽
-- 段 i（i=1..3）对应值域 [T[i], T[i+1]]，bar 范围 [(i-1)/3, i/3]
function M:CalcBarPercent(Value)
    local T = self.Thresholds
    if not T or #T < 2 then return 0 end
    local NumSegs = #T - 1
    local SegWidth = 1.0 / NumSegs
    if Value <= T[1] then return 0 end
    for i = 1, NumSegs do
        local SegStart = T[i]
        local SegEnd   = T[i + 1]
        if Value < SegEnd then
            return (i - 1) * SegWidth + (Value - SegStart) / (SegEnd - SegStart) * SegWidth
        end
    end
    return 1.0
end

function M:RemoveEvents()
    self:RemoveDispatcher(EventID.OnTreasureItemDrop, self)
end

function M:PlayInAnim()
    if not self.In then return end
    self:PlayAnimation(self.In)
end

function M:Tick(MyGeometry, InDeltaTime)
    if not self.ServerUniqueId then return end
    -- 进度条平滑插值
    if self.TargetPercent ~= nil then
        local Cur = self.CurPercent or 0
        local New = Cur + (self.TargetPercent - Cur) * math.min(InDeltaTime * 10, 1)
        if math.abs(New - self.TargetPercent) < 0.001 then
            New = self.TargetPercent
            self.TargetPercent = nil
        end
        self.CurPercent = New
        self.ProgressBar:SetPercent(New)
    end
    if UIUtils.CheckScrollBoxCanScroll(self.EMScrollBox) then
        local TriggerParams = {
            DeltaTime = InDeltaTime,
            ScrollBox = self.EMScrollBox,
            TriggerScrollUp = self.DragScrollTip_Up,
            TriggerScrollDown = self.DragScrollTip_Bottom,
            ShowPocketsScrollUpArrow = self.ShowSearchScrollUpArrow,
            ShowPocketsScrollDownArrow = self.ShowSearchScrollDownArrow,
            CurTouchPos = InventoryController.MainWidget and InventoryController.MainWidget.CurTouchPos or nil,
        }
        SoloTreasureUtils:TickTriggerScrollSizeBox(TriggerParams)
    end
end

function M:InitGamepadKeys()
    -- 初始化献祭按钮旁的手柄提示图标（LT）
    local Controller = self.Btn_Scrifice and self.Btn_Scrifice.Controller
    if Controller and Controller.CreateCommonKey then
        Controller:CreateCommonKey({
            KeyInfoList = {{Type = "Img", ImgShortPath = "LT"}}
        })
    end
    self.QAController:CreateCommonKey({
        KeyInfoList = {{Type = "Img", ImgShortPath = "Right"}}
    })
end

-- 手柄 LT 按键处理：与点击献祭按钮逻辑一致
function M:OnLTKey()
    self:TryConfirmSacrifice()
end

-- 手柄右方向键：切换 Btn_Qa 说明气泡
function M:OnDPadRightKey()
    local QaBtn = self.Btn_Qa
    if not QaBtn then return end
    if QaBtn:IsMenuAnchorOpen() then
        QaBtn:CloseMenuAnchor()
        QaBtn:ResetStyle()
    else
        QaBtn:SetChecked(true)
        QaBtn:OpenMenuAnchor()
    end
    if self.Parent and self.Parent.UpdateComTab then
        self.Parent:UpdateComTab("SacrificePopup")
    end
end

-- 手柄 B 键（SacrificePopup 态）：关闭说明气泡；弹窗由弹窗自身处理 B 键
function M:OnCloseSacrificeOverlay()
    local QaBtn = self.Btn_Qa
    if QaBtn and QaBtn:IsMenuAnchorOpen() then
        -- 关闭后 OnMenuOpenChangedCallBack → OnSacrificeOverlayOpen(false) 自动触发
        QaBtn:CloseMenuAnchor()
        QaBtn:ResetStyle()
    end
end

-- 统一管理 overlay（弹窗/气泡）开关状态：同步 InventoryController flag、光标可见性、底部按键提示
function M:OnSacrificeOverlayOpen(bOpen)
    self.bSacrificeOverlayOpen = bOpen
    InventoryController.bOpenSacrificePopup = bOpen
    if bOpen and self.ServerUniqueId then
        InventoryController._SacrificePocketName = InventoryCommonConst.SearchPocketNamePrefix .. self.ServerUniqueId
    elseif not bOpen then
        InventoryController._SacrificePocketName = nil
    end
    if UIUtils.IsGamepadInput() then
        local MainWidget = InventoryController.MainWidget
        if MainWidget and MainWidget.BagSelect_Controller then
            local Vis = bOpen and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible
            MainWidget.BagSelect_Controller:SetVisibility(Vis)
        end
        if not bOpen then
            self.Parent:GamepadDetailHideKey(false)
        end
    end
    if bOpen then
        self.Parent:GamepadDetailHideKey(true)
    end

    if self.Parent and self.Parent.UpdateComTab then
        self.Parent:UpdateComTab(bOpen and "SacrificePopup" or "Normal")
    end
end

function M:CloseSelf()
    -- 确保 overlay 标志和聚焦状态还原，无论面板以哪种路径关闭
    self:OnSacrificeOverlayOpen(false)
    -- 读取机关当前状态：仅未献祭时（StateId ~= SUCCESS）才通知取消，避免覆盖已完成的献祭状态
    if self.BPGambleMech and IsValid(self.BPGambleMech) then
        if self.BPGambleMech.StateId ~= GAMBLE_MECH_STATE_TRIBUTE_SUCCESS then
            self.BPGambleMech:TributeCancle()
        end
    end
    self:RemoveEvents()
    if not self:IsVisible() then return end
    if self.PocketWidget and IsValid(self.PocketWidget) then
        self.PocketWidget:Close()
    end
    local PocketName = InventoryCommonConst.SearchPocketNamePrefix .. self.ServerUniqueId
    local PocketData = InventoryController.InventoryModel.Pockets[PocketName]
    if PocketData then
        InventoryController:ClearPocketView(PocketName)
        PocketData.Pocket = nil
    end
    if not self.Out then return end
    self:PlayAnimation(self.Out)
    for _, Item in ipairs(self.SacrificeItemWidgets or {}) do
        if Item and IsValid(Item) then
            Item:CloseSelf()
        end
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
   if CurInputDevice == ECommonInputType.MouseAndKeyboard then
        self.Btn_Scrifice.Controller:SetVisibility(ESlateVisibility.Collapsed)
        self.QAController:SetVisibility(ESlateVisibility.Collapsed)
    elseif CurInputDevice == ECommonInputType.Gamepad then
        self.Btn_Scrifice.Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.QAController:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

return M
