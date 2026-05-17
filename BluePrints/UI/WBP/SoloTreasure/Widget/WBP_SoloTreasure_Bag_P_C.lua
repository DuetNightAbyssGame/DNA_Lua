require "UnLua"
require "DataMgr"
local InventoryCommonConst = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryCommonConst")
local InventoryController = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryController")

--- @type WBP_SoloTreasure_Bag_P_C
local M = Class("BluePrints.UI.WBP.SoloTreasure.Widget.WBP_SoloTreasure_Bag")

-- UpdateComTab 防抖合并优先级：同帧多次调用时保留优先级最高的那次。
-- 数值越大越优先；未配置的 state 默认 2（BagDetail 等中等级别）。
local ComTabStatePriority = {
    Normal  = 1,  -- 最低，可被任何其他状态覆盖
    Draging = 3,  -- 最高，拖拽中不应被 Normal/BagDetail 打断
}

function M:Construct()
    self.Super.Construct(self)

    -- ====== 手柄虚拟光标 ======
    -- 光标每帧移动速度（像素/tick），由摇杆输入驱动
    self.GamepadCursorMoveSpeed = 30
    -- 光标位置插值系数，每帧向目标位置靠近的比例（值越大越跟手）
    self.GamepadCursorLerpAlpha = 0.85
    -- 光标目标位置（父容器本地坐标，左上角为锚点）；由摇杆输入和吸附系统写入
    self.GamepadCursorTargetPosition = UE4.FVector2D(0, 0)
    -- 标记本次 AddGamepadCursorOffset 是否来自摇杆输入（true=摇杆，false=吸附系统）；用于区分是否累积移动阈值
    self.bGamepadInput = false
    -- 光标父容器本地尺寸缓存（ResetCursorToCenter 时写入），避免 AddGamepadCursorOffset 每帧调用 GetCachedGeometry
    self._CursorParentLocalSize = nil

    -- ====== 手柄拖拽 ======
    -- 拖拽中手柄换向操作的历史记录（用于判断换向动作）
    self.GamepadChangeDragItemDirectionTable = {}

    -- ====== 底部按键 Tab（UpdateComTab Tick 消费） ======
    -- 同帧内待执行的目标状态（nil=无待执行）；Tick 每帧消费一次
    self._PendingComTabState = nil
    -- 对应 _PendingComTabState 的优先级（来自 ComTabStatePriority）；nil 表示无待执行
    self._PendingComTabPriority = nil
    -- 当前生效的底部按键状态名（"Normal"/"Draging"/"BagDetail" 等），OnKeyDown 分发和 diff 用
    self.CurBottomKeyState = nil
    -- 当前显示的底部按键数据快照，与新数据 diff 避免无变化时重复刷新 UI
    self.CurBottomKeyInfo = nil
    -- 当前输入设备类型字符串（"Keyboard"/"Gamepad"），_DoUpdateComTab 写入
    self.CurInputDevice = nil

    -- ====== 背包详情面板状态调度 ======
    -- 待执行的目标状态（true=进入详情/false=离开/nil=无待执行），Enter/LeaveBagDetailState 写入
    self._PendingBagDetailState = nil
    -- 防重复调度锁（true=已有 DelayFrameFunc 在队列）；必须在 OnLoaded 中重置，否则跨界面打开时永久失效
    self._BagDetailStateScheduled = false
end

function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    -- 每次打开重置背包详情调度状态，防止上次关闭时 DelayFrameFunc 未执行完导致调度锁残留
    self._BagDetailStateScheduled = nil
    self._PendingBagDetailState = nil
    -- 清空 ComTab 待消费状态，防止上次关闭时高优先级残留导致 Normal 被丢弃
    self._PendingComTabState = nil
    self._PendingComTabPriority = nil
    self:UpdateComTab("Normal")
    self.Key_Search_GamePad:CreateCommonKey({
        KeyInfoList = {{
            Type = "Img",
            ImgShortPath = UIConst.GamePadImgKey.SpecialLeft,
        }}
    })
    self.OpenKey = CommonUtils:GetActionMappingKeyName("OpenBag")
    self:AddDelayFrameFunc(function()
        self:SetFocus()
        self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
    end, 10, "PCSetFocus")
    if not self.GameInputModeSubsystem then
        self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    end
    if self.GameInputModeSubsystem then
        self.GameInputModeSubsystem:SetNavigateWidgetVisibility(false)
        self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
        local NavigateWidget = self.GameInputModeSubsystem:GetNavigateWidget(false)
        if NavigateWidget then
            self._NavigateWidgetAudioEventPath = NavigateWidget.AudioEventPath
            NavigateWidget.AudioEventPath = ""
        end
    end
end

function M:InitPCEvents()
    self:AddDispatcher(EventID.OnTreasureItemDragDetected, self, function()
        self:UpdateComTab("Draging")
    end)
    self:AddDispatcher(EventID.OnTreasureItemDrop, self, function()
        self.InventoryController:RequestUnSelected(self.InventoryController.SelectedItemWidget)
        self.InventoryController.bForbidAdsorption = true
        self:AddTimer(0.2, function()
            self.InventoryController.bForbidAdsorption = false
        end)
        self:UpdateComTab("Normal")
        if self.InventoryController.SelectedGridWidget and self.InventoryController.SelectedGridWidget:IsHovered() then
            self.InventoryController.SelectedGridWidget:OnHovered()
        end
    end)
    self:AddDispatcher(EventID.OnTreasureItemDragCancelled, self, function()
        self:UpdateComTab("Normal")
    end)
    self:AddDispatcher(EventID.GameViewportInputKeyReleased, self, function(_, Key)
		local InventoryController = self.InventoryController
        if not InventoryController then return end
        if Key.KeyName == "LeftMouseButton" then
            if InventoryController.DragWidget and InventoryController.bDraging then
                if self.Btn_Recycle and self.Btn_Recycle.CurState == InventoryCommonConst.RecycleBtnState.DragingOver then
                    return
                end
                InventoryController:CustomOnDragCancelled()
            end
        elseif Key.KeyName == Const.GamepadFaceButtonDown then
            DebugPrint("lgc@InventoryController GameViewportInputKeyReleased  Key.KeyName =", Key.KeyName)
		end
        InventoryController.bDetectDrag = false
        InventoryController.StartDetectDragPos = nil
        InventoryController.StartDetectDragGrid = nil
	end)
end

function M:RemovePCEvents()
    self:RemoveDispatcher(EventID.OnTreasureItemDragDetected, self)
    self:RemoveDispatcher(EventID.OnTreasureItemDrop, self)
    self:RemoveDispatcher(EventID.OnTreasureItemDragCancelled, self)
    self:RemoveDispatcher(EventID.GameViewportInputKeyReleased, self)
    if self.GameInputModeSubsystem and self._NavigateWidgetAudioEventPath ~= nil then
        local NavigateWidget = self.GameInputModeSubsystem:GetNavigateWidget(false)
        if NavigateWidget then
            NavigateWidget.AudioEventPath = self._NavigateWidgetAudioEventPath
        end
        self._NavigateWidgetAudioEventPath = nil
    end
end

function M:OnReturnKeyDown()
    -- keyboard-only path (Escape / OpenKey)
    -- gamepad B is handled per-state in OnKeyDown
    if InventoryController.bDraging then
        if InventoryController.CurDragEnterGridData then
            local Grid = InventoryController.CurDragEnterGridData.Grid
            if IsValid(Grid) then
                Grid:CustomOnDrop()
            end
        end
    elseif self.bInBagDetailState then
        self:LeaveBagDetailState()
    elseif self.Btn_Recycle and self.Btn_Recycle.bOpenRecycle then
        self.Btn_Recycle:OnClickBtnRecycle()
    else
        self:CloseSelf()
    end
end

-- 按状态分发 gamepad 按键，每个状态只响应它"拥有"的按键
local StateKeyHandlers = {
    Normal = {
        [Const.GamepadFaceButtonRight] = function(self)
            if self.Btn_Recycle and self.Btn_Recycle.bOpenRecycle then
                self.Btn_Recycle:OnClickBtnRecycle()
            else
                self:CloseSelf()
            end
            return true
        end,
        [Const.GamepadFaceButtonLeft] = function(self)
            local Grid = InventoryController.SelectedGridWidget
            if Grid and not Grid.bRecycle then
                local GridData = InventoryController:GetGridData(Grid.PocketData.Name, Grid.Position)
                return InventoryController:QuickTransferFromGrid(GridData, InventoryCommonConst.QuickTransferType.RightClick)
            end
        end,
        [Const.GamepadLeftThumbstick] = function(self)
            local Grid = InventoryController.SelectedGridWidget
            if not Grid then return end
            local GridData = InventoryController:GetGridData(Grid.PocketData.Name, Grid.Position)
            local TransferType = Grid.bRecycle
                and InventoryCommonConst.QuickTransferType.RightClick
                or InventoryCommonConst.QuickTransferType.AltAndLeftClick
            return InventoryController:QuickTransferFromGrid(GridData, TransferType)
        end,
        [Const.GamepadFaceButtonUp] = function(self)
            local Grid = InventoryController.SelectedGridWidget
            if not Grid then return end
            local GridData = InventoryController:GetGridData(Grid.PocketData.Name, Grid.Position)
            if GridData and GridData.TreasureData and IsValid(GridData.TreasureData.Treasure) then
                GridData.TreasureData.Treasure:OpenItemDetailsWidget()
            end
            return true
        end,
        [Const.GamepadSpecialLeft] = function(self)
            self:OnBtnSearchPressed()
            return true
        end,
        [Const.GamepadLeftTrigger] = function(self)
            if self.Bag_Sacrifice then self.Bag_Sacrifice:OnLTKey() end
            return true
        end,
        [Const.GamepadLeftShoulder] = function(self)
            if self.CurBottomKeyState == "SacrificePopup" then return false end
            self.Btn_Recycle:OnClickBtnRecycle()
            return true
        end,
        [Const.GamepadFaceButtonRight] = function(self)
            if self.CurBottomKeyState == "SacrificePopup" then return false end
            if self.Btn_Recycle.bOpenSortDetail and self.Btn_Recycle.bOpenRecycle then
                self.Btn_Recycle:EnterSortDetail(false)
                return true
            end
        end,
    },
    BagDetail = {
        [Const.GamepadFaceButtonRight] = function(self)
            self:LeaveBagDetailState()
            return true
        end,
    },
    Draging = {
        [Const.GamepadFaceButtonRight] = function(self)
            if InventoryController.CurDragEnterGridData then
                local Grid = InventoryController.CurDragEnterGridData.Grid
                if IsValid(Grid) then Grid:CustomOnDrop() end
            end
            return true
        end,
        [Const.GamepadRightThumbstick] = function(self)
            InventoryController:GamepadChangeDragWidgetDirection()
            return true
        end,
    },
    -- RecycleSort: 父级不消费任何键，全部穿透给 Btn_Recycle:OnKeyDown
    -- Btn_Recycle 自己处理：LB(toggle recycle)、B(close sort detail when bOpenSortDetail)
    RecycleSort = {},
    -- SacrificePopup: 弹窗或气泡打开时，仅 B 关闭覆盖层，其余全部拦截（不穿透给 Btn_Recycle）
    SacrificePopup = {
        [Const.GamepadFaceButtonRight] = function(self)
            if self.Bag_Sacrifice then self.Bag_Sacrifice:OnCloseSacrificeOverlay() end
            return true
        end,
    },
}

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
   if CurInputDevice == ECommonInputType.MouseAndKeyboard then
        self.BagSelect_Controller:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_Search_GamePad:SetVisibility(ESlateVisibility.Collapsed)
        self:ApplyBagDetailState(false)
        -- 热切换到键鼠：清除所有吸附状态，避免残留计算
        self.InventoryController._Adsorption = nil
        self.InventoryController.ForceAdsorption = false
        self.InventoryController.bForbidAdsorption = false
        self.InventoryController._MouseIdleTime = 0
        self.InventoryController._AdsorptionMoveDist = 0
    elseif CurInputDevice == ECommonInputType.Gamepad then

        local CursorSize = UE4.FVector2D(0, 0)
        self.BagSelect_Controller.Slot:SetSize(CursorSize)
        -- 热切换回手柄：完整重置吸附状态，防止键鼠期间的残留 flag 干扰手柄逻辑
        self.InventoryController._Adsorption = nil
        self.InventoryController.ForceAdsorption = false
        self.InventoryController.bForbidAdsorption = false
        self.InventoryController.bOpenItemDetails = false
        self.InventoryController._MouseIdleTime = 0
        self.InventoryController._AdsorptionMoveDist = 0
        -- 立即将光标定位到屏幕中心，保证可见时不会从左上角开始
        self:ResetCursorToCenter()

        self:AddDelayFrameFunc(function()
            if self and IsValid(self) then
                self.BagSelect_Controller:SetFocus()
                self.BagSelect_Controller:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                self.InventoryController:RequestAdsorptionToFirstTreasure()
            end
        end, 10, "ShowBagSelect_Controller")
        
        self.Key_Search_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)

        if self.BagSelect_Controller.Slot.ZOrder <= 0 then
            self.BagSelect_Controller.Slot:SetZOrder(5)
        end
    end
    if self.InventoryController.SelectedItemWidget then
        self.InventoryController:RequestUnSelected(self.InventoryController.SelectedItemWidget)
    end
    self:UpdateComTab(self.CurBottomKeyState or "Normal")

    if self.Btn_Recycle and self.Btn_Recycle.RefreshOpInfoByInputDevice then
        self.Btn_Recycle:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    end
    if self.Bag_Sacrifice and self.Bag_Sacrifice.RefreshOpInfoByInputDevice then
        self.Bag_Sacrifice:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    end
end 

-- 兜底：将手柄光标重置到父容器中心（无物品时的最终回退）
function M:ResetCursorToCenter()
    if not self.BagSelect_Controller then return end
    local CursorParentGeometry = self.BagSelect_Controller:GetParent():GetCachedGeometry()
    local CursorParentLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(CursorParentGeometry)
    -- 缓存父容器尺寸，AddGamepadCursorOffset 摇杆热路径直接读此值，避免每次拨杆重算
    self._CursorParentLocalSize = CursorParentLocalSize
    -- TargetPos 是光标左上角位置，要让光标中心在父容器中心，需减去光标半尺寸
    local CursorGeo = self.BagSelect_Controller:GetCachedGeometry()
    local CursorLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(CursorGeo)
    self.GamepadCursorTargetPosition = UE4.FVector2D(
        CursorParentLocalSize.X / 2 - CursorLocalSize.X / 2,
        CursorParentLocalSize.Y / 2 - CursorLocalSize.Y / 2
    )
    self.BagSelect_Controller:SetRenderTranslation(self.GamepadCursorTargetPosition)
end

-- 请求更新底部按键 Tab，同帧多次调用时优先级高的胜出，由 Tick 统一消费（每帧最多一次）。
-- 优先级规则见文件顶部 ComTabStatePriority 表；未配置的 state 默认优先级 2。
function M:UpdateComTab(TargetState)
    local priority = ComTabStatePriority[TargetState] or 2
    -- 仅当新请求优先级 >= 当前待执行优先级时才更新（相等时以最新调用为准）
    if not self._PendingComTabPriority or priority >= self._PendingComTabPriority then
        self._PendingComTabState    = TargetState
        self._PendingComTabPriority = priority
    end
end

function M:_DoUpdateComTab(TargetState)
    local BottomKeyInfo = {}
    if TargetState == "Normal" then
        if UIUtils.IsKeyboardInput() then
            BottomKeyInfo = {
                {
                    KeyInfoList = {{Type = "Text", ImgShortPath = "LeftMouseButton"}},
                    Desc = GText("UI_Keyboard_Map_ItemDetail")
                },
            }
            table.insert(BottomKeyInfo, {
                KeyInfoList = {{Type = "Text", ImgShortPath = "RightMouseButton"}},
                Desc = GText("UI_Extraction_TM_3")
            })
            table.insert(BottomKeyInfo, {
                KeyInfoList = {
                    {Type = "Text", ImgShortPath = "LeftAlt"},
                    {Type = "Text", ImgShortPath = "LeftMouseButton"},
                },
                Desc = GText("UI_Extraction_PutItIntoRecycling"),
                Type = "Add",
            })
            table.insert(BottomKeyInfo, {
                KeyInfoList = {{Type = "Text", ImgShortPath = "Escape", ClickCallback = self.OnReturnKeyDown, Owner = self}},
                Desc = GText("UI_BACK"),
            })
        elseif UIUtils.IsGamepadInput() then
            BottomKeyInfo = {
                {
                    KeyInfoList = {{Type = "Img", ImgShortPath = "A"}},
                    Desc = GText("UI_CTL_Move")
                },
            }
            if self.InventoryController.SelectedItemWidget then
                table.insert(BottomKeyInfo, {
                    KeyInfoList = {{Type = "Img", ImgShortPath = "Y"}},
                    Desc = GText("UI_Controller_CheckDetails")
                })
            end
            if self.InventoryController.SelectedItemWidget and not self.InventoryController.SelectedItemWidget.bInRecycleGrid then
                table.insert(BottomKeyInfo, {
                    KeyInfoList = {{Type = "Img", ImgShortPath = "X"}},
                    Desc = GText("UI_Extraction_TM_3")
                })
                table.insert(BottomKeyInfo, {
                    KeyInfoList = {{Type = "Img", ImgShortPath = "LS"}},
                    Desc = GText("UI_Extraction_PutItIntoRecycling"),
                })
            end
            if self.InventoryController.SelectedItemWidget and self.InventoryController.SelectedItemWidget.bInRecycleGrid then
                table.insert(BottomKeyInfo, {
                    KeyInfoList = {{Type = "Img", ImgShortPath = "LS"}},
                    Desc = GText("UI_Extraction_PutItIntoBackpack"),
                })
            end
            if UIUtils.CheckScrollBoxCanScroll(self.ScrollBoxPockets) then
                table.insert(BottomKeyInfo, {
                    KeyInfoList = {{Type = "Img", ImgShortPath = "RV"}},
                    Desc = GText("UI_Controller_Slide")
                })
            end
            table.insert(BottomKeyInfo, {
                KeyInfoList = {{Type = "Img", ImgShortPath = "B"}},
                Desc = GText("UI_BACK"),
            })
        end
    elseif TargetState == "BagDetail" then
        if UIUtils.IsKeyboardInput() then
            BottomKeyInfo = {
                {
                    KeyInfoList = {{Type = "Text", ImgShortPath = "Escape", ClickCallback = self.OnReturnKeyDown, Owner = self}},
                    Desc = GText("UI_BACK"),
                },
            }
        elseif UIUtils.IsGamepadInput() then
            BottomKeyInfo = {
                {
                    KeyInfoList = {{Type = "Img", ImgShortPath = "B"}},
                    Desc = GText("UI_BACK"),
                },
            }
        end
    elseif TargetState == "Draging" then
        if UIUtils.IsKeyboardInput() then
            BottomKeyInfo = {
                {
                    KeyInfoList = {{Type = "Text", ImgShortPath = "LeftMouseButton"}},
                    Desc = GText("UI_Tips_Ensure")
                },
            }
        elseif UIUtils.IsGamepadInput() then
            BottomKeyInfo = {
                {
                    KeyInfoList = {{Type = "Img", ImgShortPath = "A"}},
                    Desc = GText("UI_Tips_Ensure")
                },
            }
            local DragTreasureSize = InventoryController.StartDragGridData.TreasureData.Size
            if DragTreasureSize and DragTreasureSize.X ~= DragTreasureSize.Y then
                table.insert(BottomKeyInfo, {
                    KeyInfoList = {{Type = "Img", ImgShortPath = "RS"}},
                    Desc = GText("UI_Accessory_Custom_Rotation"),
                })
            end
        end
    elseif TargetState == "RecycleSort" then
        if UIUtils.IsKeyboardInput() then
            BottomKeyInfo = {}
        elseif UIUtils.IsGamepadInput() then
            BottomKeyInfo = {
                {
                    KeyInfoList = {{Type = "Img", ImgShortPath = "A"}},
                    Desc = GText("UI_CONFIRM_SELECTION"),
                },
                {
                    KeyInfoList = {{Type = "Img", ImgShortPath = "B"}},
                    Desc = GText("UI_BACK"),
                },
            }
        end
    elseif TargetState == "SacrificePopup" then
        if UIUtils.IsGamepadInput() then
            BottomKeyInfo = {
                {
                    KeyInfoList = {{Type = "Img", ImgShortPath = "B"}},
                    Desc = GText("UI_BACK"),
                },
            }
        end
    end
    
    if TargetState == "RecycleSort" then
        self.Btn_Recycle.Key_Recycle:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_Search_GamePad:SetVisibility(ESlateVisibility.Collapsed)
    elseif not self.Btn_Recycle.bOpenSortDetail and not self.InventoryController.bOpenItemDetails then
        self.Btn_Recycle.Key_Recycle:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Key_Search_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    local TargetInputDevice = nil
    if UIUtils.IsKeyboardInput() then
        TargetInputDevice = "Keyboard"
    elseif UIUtils.IsGamepadInput() then
        TargetInputDevice = "Gamepad"
    end

    local bEqual = true
    if bEqual and self.CurBottomKeyInfo and #BottomKeyInfo ~= #self.CurBottomKeyInfo then
        bEqual = false
    end
    if bEqual then
        for Index, KeyInfo in ipairs(BottomKeyInfo) do
            if self.CurBottomKeyInfo and KeyInfo.KeyInfoList[1].ImgShortPath ~= self.CurBottomKeyInfo[Index].KeyInfoList[1].ImgShortPath then
                bEqual = false
                break
            end
        end
    end
    if not self.CurBottomKeyInfo then
        bEqual = false
    end
    if not bEqual then
        self.Com_KeyTips:UpdateKeyInfo(BottomKeyInfo)
    end
    self.CurBottomKeyInfo = BottomKeyInfo
    self.CurBottomKeyState = TargetState
    self.CurInputDevice = TargetInputDevice
end

function M:EnterTreasureDetailState(bEnter)
    if not UIUtils.IsGamepadInput() then return end
    if bEnter then
        self.Com_KeyTips:SetVisibility(ESlateVisibility.Collapsed)
        self.Btn_Recycle.Key_Recycle:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_Search_GamePad:SetVisibility(ESlateVisibility.Collapsed)
        self.Btn_Recycle.Sort.Controller:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Com_KeyTips:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Recycle.Key_Recycle:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Key_Search_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Recycle.Sort.Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

function M:EnterBagDetailState()
    self._PendingBagDetailState = true
    if self._BagDetailStateScheduled then return end
    self._BagDetailStateScheduled = true
    self:AddDelayFrameFunc(function()
        self._BagDetailStateScheduled = nil
        local TargetState = self._PendingBagDetailState
        self._PendingBagDetailState = nil
        if TargetState == nil then return end
        if TargetState then
            self:ApplyBagDetailState(true)
        else
            self:ApplyBagDetailState(false)
        end
    end, 1, "ApplyBagDetailState")
end

function M:LeaveBagDetailState()
    self._PendingBagDetailState = false
    if self._BagDetailStateScheduled then return end
    self._BagDetailStateScheduled = true
    self:AddDelayFrameFunc(function()
        self._BagDetailStateScheduled = nil
        local TargetState = self._PendingBagDetailState
        self._PendingBagDetailState = nil
        if TargetState == nil then return end
        if TargetState then
            self:ApplyBagDetailState(true)
        else
            self:ApplyBagDetailState(false)
        end
    end, 1, "ApplyBagDetailState")
end

function M:ApplyBagDetailState(bEnter)
    if bEnter then
        self.Super.EnterBagDetailState(self)
        self:GamepadDetailHideKey(true)
    else
        self.Super.LeaveBagDetailState(self)
        if not UIUtils.IsGamepadInput() then return end
        self:GamepadDetailHideKey(false)
    end
end

function M:GamepadDetailHideKey(bHide)
    if bHide then
        self.Btn_Recycle.Key_Recycle:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_Search_GamePad:SetVisibility(ESlateVisibility.Collapsed)
        self.Bag_Sacrifice.QAController:SetVisibility(ESlateVisibility.Collapsed)
        self.Bag_Sacrifice.Btn_Scrifice.Controller:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Btn_Recycle.Key_Recycle:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Key_Search_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Bag_Sacrifice.QAController:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Bag_Sacrifice.Btn_Scrifice.Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

----------------------- 虚拟手柄光标的位置移动相关 -----------------------------

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    if (CommonUtils:IfExistSystemGuideUI(self)) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName == Const.GamepadDPadUp then
            if self.Btn_Recycle then
                self.Btn_Recycle:OnDPadUpKey()
                IsEventHandled = true
            end
        elseif InKeyName == Const.GamepadDPadRight then
            if self.Bag_Sacrifice then 
                self.Bag_Sacrifice:OnDPadRightKey()
                IsEventHandled = true
            end
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end


function M:OnKeyDown(MyGeometry, InKeyEvent)
    if CommonUtils:IfExistSystemGuideUI(self) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false

    if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
        local CurState = self.CurBottomKeyState or "Normal"
        local Handlers = StateKeyHandlers[CurState]
        if Handlers and Handlers[InKeyName] then
            IsEventHandled = Handlers[InKeyName](self) or false
        end
        if not IsEventHandled and InKeyName == Const.GamepadFaceButtonRight then
            self:OnReturnKeyDown()
            IsEventHandled = true
        end
    else
        if not IsEventHandled and InKeyName == "Escape" or InKeyName == self.OpenKey then
            self:OnReturnKeyDown()
            IsEventHandled = true
        end
    end

    return IsEventHandled
        and UE4.UWidgetBlueprintLibrary.Handled()
        or UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName == Const.GamepadFaceButtonDown then
            if InventoryController.SelectedGridWidget then
                DebugPrint("lgc@InventoryController OnKeyUp", InKeyName)
                InventoryController.SelectedGridWidget:OnMouseButtonUp(MyGeometry, InKeyEvent)
                IsEventHandled = true
            else
                DebugPrint("lgc@InventoryController not SelectedGridWidget", InKeyName)
            end
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end 

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    local Key = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(Key)

    if KeyName == UIConst.GamePadKey.LeftAnalogX then
        if InventoryController.ForceAdsorption then return UE4.UWidgetBlueprintLibrary.UnHandled() end
        local InputX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
        local Deadzone = InventoryCommonConst.GamepadAnalogDeadzone or 0
        DebugPrint("lgc@LeftAnalogX", InputX, Deadzone)
        if math.abs(InputX) > Deadzone then
            local MoveX = InputX * self.GamepadCursorMoveSpeed
            self:AddGamepadCursorOffset({ X = MoveX, Y = 0 }, true)
        end
    elseif KeyName == UIConst.GamePadKey.LeftAnalogY then
        if InventoryController.ForceAdsorption then return UE4.UWidgetBlueprintLibrary.UnHandled() end
        local InputY = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
        local Deadzone = InventoryCommonConst.GamepadAnalogDeadzone or 0
        if math.abs(InputY) > Deadzone then
            local MoveY = InputY * self.GamepadCursorMoveSpeed
            self:AddGamepadCursorOffset({ X = 0, Y = MoveY }, true)
        end
    elseif KeyName == UIConst.GamePadKey.RightAnalogY then
        local AddOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
        local CurScrollOffset = self.ScrollBoxPockets:GetScrollOffset()
        local ScrollOffset = 
            math.clamp(CurScrollOffset - AddOffset,0, self.ScrollBoxPockets:GetScrollOffsetOfEnd())
        self.ScrollBoxPockets:SetScrollOffset(ScrollOffset)
    end

    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:AddGamepadCursorOffset(Offset, bGamepadInput)
    -- 父容器尺寸已在 ResetCursorToCenter 缓存；父容器本地坐标原点即 (0,0)，最大边界即 LocalSize
    local MaxLocal = self._CursorParentLocalSize
    if not MaxLocal then
        -- 兜底：未缓存时（理论上不应到达）重算并写入缓存
        local Geometry = self.BagSelect_Controller:GetParent():GetCachedGeometry()
        MaxLocal = UE4.USlateBlueprintLibrary.GetLocalSize(Geometry)
        self._CursorParentLocalSize = MaxLocal
    end

    local CursorTargetPosition = self.GamepadCursorTargetPosition
    CursorTargetPosition.X = math.clamp(CursorTargetPosition.X + Offset.X, 0, MaxLocal.X)
    CursorTargetPosition.Y = math.clamp(CursorTargetPosition.Y - Offset.Y, 0, MaxLocal.Y)
    self.bGamepadInput = bGamepadInput

    -- 仅累计玩家主动拨杆产生的移动量，用于判断是否为有意图移动（吸附取消阈值）
    if bGamepadInput and self.InventoryController then
        local dx = Offset.X or 0
        local dy = Offset.Y or 0
        local dist = math.sqrt(dx * dx + dy * dy)
        self.InventoryController._AdsorptionMoveDist = (self.InventoryController._AdsorptionMoveDist or 0) + dist
    end
end

function M:CalculateGamepadCursorAbsoluteLimitPosition()
    local Geometry = self.BagSelect_Controller:GetParent():GetCachedGeometry()
    local MinAbsolutePosition = UE4.UUIFunctionLibrary.GetGeometryAbsolutePosition(Geometry)
    local AbsoluteSize = UE4.USlateBlueprintLibrary.GetAbsoluteSize(Geometry)
    local MaxAbsolutePosition = UE4.FVector2D(
            MinAbsolutePosition.X + AbsoluteSize.X,
            MinAbsolutePosition.Y + AbsoluteSize.Y
    )
    return MinAbsolutePosition, MaxAbsolutePosition
end

function M:UpdateGamepadCursorPosition()
    if not UIUtils.IsGamepadInput() then
        return
    end
    if InventoryController.bOpenItemDetails or InventoryController.bOpenRecycleSortDetail or InventoryController.bOpenSacrificePopup then
        return
    end
    local Current = self.BagSelect_Controller.RenderTransform.Translation
    local Target = self.GamepadCursorTargetPosition
    if (Current.X == Target.X and Current.Y == Target.Y) then
        return
    end
    -- 光标位置有变化时才 SetFocus，避免每帧无意义的 Slate focus 刷新
    self.BagSelect_Controller:SetFocus()
    local Alpha = self.GamepadCursorLerpAlpha
    local New = UE4.FVector2D(
            Current.X + (Target.X - Current.X) * Alpha,
            Current.Y + (Target.Y - Current.Y) * Alpha
    )

    self.BagSelect_Controller:SetRenderTranslation(New)
end

return M
