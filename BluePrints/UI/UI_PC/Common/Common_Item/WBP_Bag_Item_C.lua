--
-- DESCRIPTION
-- 背包道具Item
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local BagCommon = require "BluePrints.UI.WBP.Bag.BagCommon"
---@type WBP_Bag_Item_C
local M = Class({"BluePrints.UI.UI_PC.Common.Common_Item.WBP_Com_item_Universal_L_C"})
local LongPressInterval = 0.15-- 长按判定延迟，按住超过此时间视为长按
function M:InitData(Content)
    Content.OnMouseButtonDownEvent = {Obj = self, Callback = self.OnPressed}
    Content.OnMouseButtonUpEvents = {Obj = self, Callback = self.OnReleased}
    Content.OnMouseLeaveEvent = {Obj = self, Callback = self.OnLeaved}
    M.Super.InitData(self, Content)
    self.Content.StuffType = self.ItemType
    self.bDontRemoveSubWidget = true
    self.bAllUseAsyncLoadWidget = false
    -- self.Btn_LongPress.OnPressed:Add(self, self.OnPressed)
    -- self.Btn_LongPress.OnReleased:Add(self, self.OnReleased)

    -- 初始化长按逻辑控制变量
    self.HoldStartTime = 0               -- 记录按下按钮的时间（用于计算长按时长）
    self.bIsHolding = false              -- 当前是否处于按住的状态
    self.HoldTimerName = "HoldAddStuffTimer_Bag_Item" .. self:GetName()
    self.bIsLongPress = false            --是否已经进入长按
    self.bHasTriggeredHoldAction = false --长按逻辑是否已经触发过,如果没触发过长按，在松手的时候就保证一定执行短按

    self.ClickInterval = 1               -- 点击/长按时的基础增量步长
    self.bForbidPressAccelerate = false  -- 是否禁用长按加速

    self.HoldStartDelayHandle = nil
    self.HoldLoopHandle = nil
    self.HoldReduceHandle = nil
    self.PressGen = 0  -- 本实例的本地代号

    self.bIsDragging = false
    self.DragThreshold = 10  --拖动的阈值
    self.DragStartPos = { X = 0, Y = 0 }

    -- true = 递减，false = 递增
    --self.bIsReduceMode = false
end

function M:InitCompView()
    M.Super.InitCompView(self)
    -- 一些自己的逻辑
    if (self.ItemType == "EmptyGrid") then
        -- 空格需要额外隐藏一些内容
        self:CheckAndSetVisibility(self.CountWidget, UIConst.VisibilityOp.Collapsed)
        self:CheckAndSetVisibility(self.LevelWidget, UIConst.VisibilityOp.Collapsed)
        self:PlayFadeInAnim()
        return
    elseif (self.ItemType == CommonConst.DataType.Weapon) then
        self:CheckAndSetVisibility(self.CountWidget, UIConst.VisibilityOp.Collapsed)
        self:CheckAndSetVisibility(self.LevelWidget, UIConst.VisibilityOp.SelfHitTestInvisible)
    elseif (self.ItemType == CommonConst.DataType.Mod) then
        self:CheckAndSetVisibility(self.LevelWidget, UIConst.VisibilityOp.Collapsed)
        self:CheckAndSetVisibility(self.CountWidget, UIConst.VisibilityOp.SelfHitTestInvisible)
        self:UpdateModItem()
    else
        self:CheckAndSetVisibility(self.LevelWidget, UIConst.VisibilityOp.Collapsed)
        self:CheckAndSetVisibility(self.CountWidget, UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    self:RefreshItemsViewWithStateTag()

    ---藏宝图处理
    self:SetTreasureMapDigable(false, false)
    local ItemConf = DataMgr.Resource[self.Content.StuffId]
    if (self.ItemType == CommonConst.DataType.Resource and ItemConf and ItemConf.ResourceSType == "TreasureMap") then
        local Conf = DataMgr.Explore_Treasure[self.Content.StuffId]
        if not Conf then
            DebugPrint(ErrorTag, "藏宝图道具没有与探索组关联！！！ 道具ID: ",self.Content.StuffId)
        else
            self.RarelyId = Conf.ExploreGroupId
            local Explore = GWorld:GetAvatar().Explores[self.RarelyId]
            local bDigable = not(Explore and Explore:IsComplete() or false)
            self:SetTreasureMapDigable(true, bDigable)
            --EventID.OnExploreGroupComplete, RarelyId, TotalReward)
            -- self:RemoveDispatcher(EventID.OnExploreGroupComplete)
            -- self:AddDispatcher(EventID.OnExploreGroupComplete, self, function(self, RarelyId, _)
            --     if RarelyId ~= self.RarelyId then return end
            --     self:SetTreasureMapDigable(true, true)
            -- end)
        end
    end
    -- self:AddWidgetToNode(self.Btn_LongPress)
    -- 播放渐入动画
    self:PlayFadeInAnim()
end

-- 播放渐入动画
function M:PlayFadeInAnim()
    if (self.Content.AnimNameWithCreate and self[self.Content.AnimNameWithCreate]) then
        self.Root:SetRenderOpacity(0)
        self:PlayAnimation(self[self.Content.AnimNameWithCreate])
    end
end

-- 是否正在播放入场动画
function M:IsInAnimationPlaying()
    if (self.Content.AnimNameWithCreate and self[self.Content.AnimNameWithCreate]) then
        return self:IsAnimationPlaying(self[self.Content.AnimNameWithCreate])
    end
    return false
end

-- function M:OnClicked()

-- end

-- function M:OnReleased()
--     if self.Content.ClickCallback and type(self.Content.ClickCallback) == "function"  then
--         self.Content.ClickCallback(self.ParentWidget,self.Content)
--     end
-- end

function M:IsInSaleOrResolveState()
    local State = self.ParentWidget and self.ParentWidget.BagCurState
    return State == BagCommon.AllBagState.ChooseSaleState
        or State == BagCommon.AllBagState.WeaponResolveState
end

function M:StopHoldTimers()
    DebugPrint("BagItem==::OnPressed::StopHoldTimers 长按计时器被清除")
    if self.HoldStartDelayHandle then self:RemoveTimer(self.HoldStartDelayHandle) end
    if self.HoldLoopHandle then self:RemoveTimer(self.HoldLoopHandle) end
    if self.HoldReduceHandle then self:RemoveTimer(self.HoldReduceHandle) end
    self.HoldStartDelayHandle, self.HoldLoopHandle, self.HoldReduceHandle = nil, nil, nil
end

function M:OnPressed()
    -- 早返回：空格/不可售/不在出售或分解状态/正在播放入场动画，直接返回
    if self:IsInAnimationPlaying() then return end
    if self.ItemType == "EmptyGrid" then return end
    if not self:IsInSaleOrResolveState() then return end

    if self.Content.Price < 0 then
        -- DebugPrint("OnPressedOnPressedOnPressed")
        -- UIManager(self):ShowError(7014, nil, UIConst.Tip_CommonToast)
        return
    end

    self.bIsDragging = false
    local pos = UE4.UWidgetLayoutLibrary.GetMousePositionOnViewport(self)
    local x = pos and pos.X or 0
    local y = pos and pos.Y or 0
    self.DragStartPos = { X = x, Y = y }

    self.ParentWidget.HoldGlobalToken = (self.ParentWidget.HoldGlobalToken or 0)
    self.ParentWidget.HoldOwner       = self.ParentWidget.HoldOwner or nil

    -- 切到新的 item：强停上一个持有者的计时器
    if self.ParentWidget.HoldOwner and self.ParentWidget.HoldOwner ~= self then
        local prev        = self.ParentWidget.HoldOwner
        prev.bIsHolding   = false
        prev.bIsLongPress = false
        prev:StopHoldTimers()
    end

    self:StopAllAnimations()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == CommonConst.CLIENT_DEVICE_TYPE.PC then
        if self.Item and self.Item.Press then
            self.Item:PlayAnimation(self.Item.Press)
        end
    end

    -- 设为当前持有者 & 令牌
    self.ParentWidget.HoldOwner       = self
    self.ParentWidget.HoldGlobalToken = self.ParentWidget.HoldGlobalToken + 1
    local globalTok                   = self.ParentWidget.HoldGlobalToken

    -- 本次按压状态
    self.bIsHolding                   = true
    self.bIsLongPress                 = false
    self.HoldStartTime                = UE4.UGameplayStatics.GetRealTimeSeconds(self)
    self.PressGen                     = (self.PressGen or 0) + 1
    local gen                         = self.PressGen

    -- 防重启延迟定时器
    if self.HoldStartDelayHandle then self:RemoveTimer(self.HoldStartDelayHandle) end
    self.HoldStartDelayHandle = self:AddTimer(LongPressInterval, function()
        -- 校验任一不符则放弃
        if not self.bIsHolding or self.PressGen ~= gen
            or self.ParentWidget.HoldOwner ~= self
            or self.ParentWidget.HoldGlobalToken ~= globalTok
            or self.bIsDragging then                         -- 发生拖动则不进长按
            self.HoldStartDelayHandle = nil
            return
        end
        -- 正式进入长按：置位并开启循环
        self.bIsLongPress = true
        self.HoldStartDelayHandle = nil
        DebugPrint("BagItem==::OnPressed::HoldStartDelayHandle 长按开始")
        self:StartHoldAddStuff(gen, globalTok)
    end, false, 0, self.HoldTimerName .. "_StartDelay")
end

function M:OnReleased()
    -- 空格直接返回
    if self.ItemType == "EmptyGrid" then return end
    AudioManager(self):PlayItemSound(self, self.Id, "Click", self.ItemType)

    -- 不在出售/分解状态触发一次
    if not self:IsInSaleOrResolveState() then
        self:TriggerClickCallback(0)
        return
    end

    if self.Content.Price < 0 then
        UIManager(self):ShowError(7014, nil, UIConst.Tip_CommonToast)
        return
    end

    -- 作废当前持有者
    if self.ParentWidget.HoldOwner == self then
        self.ParentWidget.HoldGlobalToken = self.ParentWidget.HoldGlobalToken + 1
        self.ParentWidget.HoldOwner = nil
    end

    -- 结束本次按压 & 清理定时器
    self.bIsHolding = false
    self:StopHoldTimers()

    -- 若已进入长按不触发短按，直接返回
    if self.bIsLongPress then
        if not self.bHasTriggeredHoldAction then
            -- 虽然判定过长按，但没真正触发动作，当短按
            self.bIsLongPress = false
        else
            -- 已经触发过长按逻辑，才真正屏蔽短按
            self.bIsLongPress = false
            self.bHasTriggeredHoldAction = false
            return
        end
    end

    -- 未进入长按一律认定为短按
    if self.ParentWidget.BagCurState == BagCommon.AllBagState.WeaponResolveState then
        if self.Content.StateTagInfo and self.Content.StateTagInfo.Name ~= "IsToChoose" then
            self:TriggerClickCallback(1)
        else
            self:TriggerClickCallback(0)
        end
    else
        self:TriggerClickCallback(1)
    end
end

function M:OnMouseMove(MyGeometry, MouseEvent)
    -- 不在按压中Unhandled
    if not self.bIsHolding then
        return UWidgetBlueprintLibrary.Unhandled()
    end

    -- 当前鼠标位置
    local pos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(MouseEvent)
    local dx = (pos.X or 0) - (self.DragStartPos.X or 0)
    local dy = (pos.Y or 0) - (self.DragStartPos.Y or 0)
    local dist2 = dx * dx + dy * dy

    if dist2 >= (self.DragThreshold * self.DragThreshold) then
        -- 标记拖动并取消一切长按相关定时器
        if self.bIsLongPress then
            self.bIsDragging = true
            -- self.bIsLongPress = false
            -- self.bHasTriggeredHoldAction = false
            -- self:StopHoldTimers()
            self:CancelHold()
        end
    end

    return UWidgetBlueprintLibrary.Unhandled()
end

function M:OnLeaved()
    self.bIsDragging = false
    if not self:IsInSaleOrResolveState() then return end
    self:CancelHold()
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
    -- if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    --     return
    -- end
    -- 只要处于按压/长按中，离开就必须打断
    if self.bIsHolding or (self.ParentWidget and self.ParentWidget.HoldOwner == self) then
        self:CancelHold()
    end
    self.bIsDragging = false
    if not self.Content or self.NotInteractive or self.Content.IsShowTips or self:IsInAnimationPlaying() then
        return
    end
    if self.Content.IsSelect then
        if self.OnMouseLeaveEvent and self.OnMouseLeaveEvent.Callback then
            self.OnMouseLeaveEvent.Callback(self.OnMouseLeaveEvent.Obj, self.OnMouseLeaveEvent.Params)
        end
        return
    end
    self.bMouseButtonDown = false
    self.Item:StopAllAnimations()
    self.Item:PlayAnimation(self.Item.UnHover)
end

-- function M:OnTouchMoved(MyGeometry, TouchEvent)
--     if not (self.bIsHolding or (self.ParentWidget and self.ParentWidget.HoldOwner == self)) then
--         return UWidgetBlueprintLibrary.Unhandled()
--     end

--     local ScreenPos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(TouchEvent)

--     -- 判断触点是否还在当前 item 内
--     local bInside = UE4.USlateBlueprintLibrary.IsUnderLocation(MyGeometry, ScreenPos)
--     if not bInside then
--         self:CancelHold()
--         return UWidgetBlueprintLibrary.Handled()
--     end

--     return UWidgetBlueprintLibrary.Handled()
-- end

function M:OnTouchEnded(MyGeometry, TouchEvent)
    if self:IsInSaleOrResolveState() then
        if self.CancelHold then
            self:CancelHold()
        end
        self:OnMouseButtonUp(MyGeometry, TouchEvent)
        local Reply = UWidgetBlueprintLibrary.Handled()
        return UWidgetBlueprintLibrary.ReleaseMouseCapture(Reply)
    else
        return self:OnMouseButtonUp(MyGeometry, TouchEvent)
    end
end

function M:OnTouchStarted(MyGeometry, TouchEvent)
    if self:IsInSaleOrResolveState() then
        --  如果上一个 item 还在 holding 先打断
        if self.ParentWidget and self.ParentWidget.HoldOwner and self.ParentWidget.HoldOwner ~= self then
            local prev = self.ParentWidget.HoldOwner
            if prev.CancelHold then
                prev:CancelHold()
            else
                self.ParentWidget.HoldGlobalToken = (self.ParentWidget.HoldGlobalToken or 0) + 1
                self.ParentWidget.HoldOwner = nil
            end
        end

        self:OnMouseButtonDown(MyGeometry, TouchEvent)
        local Reply = UWidgetBlueprintLibrary.Handled() --M.Super.OnTouchStarted(self, MyGeometry, TouchEvent)
        return UWidgetBlueprintLibrary.CaptureMouse(Reply, self)
    else
        return self:OnMouseButtonDown(MyGeometry, TouchEvent)
    end
end



function M:CancelHold()
    -- 作废当前持有者
    if self.ParentWidget and self.ParentWidget.HoldOwner == self then
        self.ParentWidget.HoldGlobalToken = (self.ParentWidget.HoldGlobalToken or 0) + 1
        self.ParentWidget.HoldOwner = nil
    end

    self.bIsHolding = false
    self.bIsLongPress = false
    self.bHasTriggeredHoldAction = false
    self.bIsDragging = false
    self:StopHoldTimers()
end

-- 触发点击回调
function M:TriggerClickCallback(Count)
    if self.Content.ClickCallback and type(self.Content.ClickCallback) == "function" then
        if Count > 0 then
            self.Content.AddNum = Count
            -- self.Content.bMinus = self.bMinus
            if self.Content.StateTagInfo and self.Content.StateTagInfo.Name ~= "InSelectList" then
                self.ParentWidget.HoverItem = self.Content
                self.ParentWidget:RefreshBottomKeyInfo("ChooseSaleState")
            end
        end
        self.Content.ClickCallback(self.ParentWidget, self.Content)
    end
end

function M:StartHoldAddStuff(gen, globalTok)
    -- 防重复开循环
    if self.HoldLoopHandle then self:RemoveTimer(self.HoldLoopHandle) end

    local handle
    handle = self:AddTimer(0.1, function()
        -- 任一条件变化 ⇒ 自杀并清句柄
        if not self.bIsHolding or self.PressGen ~= gen
            or self.ParentWidget.HoldOwner ~= self
            or self.ParentWidget.HoldGlobalToken ~= globalTok
            or self.bIsDragging then
            if handle then self:RemoveTimer(handle) end
            if self.HoldLoopHandle == handle then self.HoldLoopHandle = nil end
            return
        end

        local PressTime = UE4.UGameplayStatics.GetRealTimeSeconds(self) - self.HoldStartTime
        local AddCount = self:GetChangeCount(PressTime)

        local CurCount, MaxCount = 0, 0
        local Info = self.Content.StateTagInfo
        local Extra = Info and Info.ExtraData

        if Info and Extra then
            if Info.Name == "InSelectList" then
                CurCount = Extra[1] or 0
                MaxCount = Extra[2] or 0
            else
                MaxCount = Extra[1] or 0
            end
        end
        DebugPrint("BagItem==::StartHoldAddStuff::PressTime = ", PressTime, " AddCount = ", AddCount, " CurCount = ", CurCount, " MaxCount = ", MaxCount)
        local FinalCount = math.min(CurCount + AddCount, MaxCount)
        local Delta = FinalCount - CurCount
        if Delta > 0 then
            -- 标记已经真正触发过长按逻辑
            self.bHasTriggeredHoldAction = true
            self:TriggerClickCallback(Delta)
        end
    end, true, 0, self.HoldTimerName)

    self.HoldLoopHandle = handle
end



function M:GetChangeCount(PressTime)
    local Multiple = 1
    if not self.bForbidPressAccelerate and self.LongPressCurve then
        Multiple = self.LongPressCurve:GetFloatValue(PressTime)
    end
    local StepCount = self.ClickInterval * Multiple
    StepCount = math.floor(StepCount + 0.5)

    local MinValue = 1
    local MaxValue = 99
    local FinalCount = math.max(MinValue, math.min(StepCount, MaxValue))
    return FinalCount
end


function M:SetTreasureMapDigable(bShow, bDigable)
    if not self.Item then 
        DebugPrint(ErrorTag, "SetTreasureMapDigable::没有Item控件不符合通用道具框结构")
        return 
    end
    if bShow then
        if not self.WidgetMap[self.TreasureDigableWidget] then
            self.TreasureDigableWidget = self:CreateWidgetNew("ComTreasureDigable")
        end
        self:AddWidgetToNode(self.TreasureDigableWidget)
        local Index = bDigable==true and 1 or 0
        self.TreasureDigableWidget.WidgetSwitcher_State:SetActiveWidgetIndex(Index)
        self.TreasureDigableWidget.Text_DigHint:SetText(GText("UI_TREASURE_COMPLETE"))
    else
        self:RemoveWidgetFromNode(self.TreasureDigableWidget)
    end
end

function M:SetStuffStyleByStateTag(Content)
    local StateTagInfo = Content.StateTagInfo
    if (StateTagInfo == nil) then
        self:RefreshItemsViewWithStateTag({Name="Normal"}, Content)
        return
    end
    if (self.Content ~= nil and self.Content.StateTagInfo ~= nil) then
        if (self.Content.StateTagInfo.Name == "IsToChoose") then
            self:CheckAndSetVisibility(self.SelectWidget, UIConst.VisibilityOp.Collapsed)
            self:CheckAndSetVisibility(self.SelectCountWidget, UIConst.VisibilityOp.Collapsed)
            self:CheckAndSetVisibility(self.MoneyWidget, UIConst.VisibilityOp.Collapsed)
        elseif (self.Content.StateTagInfo.Name == "InSelectList") then
            self:CheckAndSetVisibility(self.MinusWidget, UIConst.VisibilityOp.Collapsed)
            self:CheckAndSetVisibility(self.SelectCountWidget, UIConst.VisibilityOp.Collapsed)
            self:CheckAndSetVisibility(self.MoneyWidget, UIConst.VisibilityOp.Collapsed)
        end
    end
    self:RefreshItemsViewWithStateTag(Content)
end

function M:RefreshItemsViewWithStateTag(Content)
    self:SetItemMinus(false)
    Content = Content or self.Content
    local StateTagInfo = Content.StateTagInfo or {}
    if (StateTagInfo.Name == "IsToChoose") then
        if (StateTagInfo.ExtraData ~= nil) then
            self:SetSelectNum(Utils.FormatNumber(StateTagInfo.ExtraData[1], true))  -- Utils.FormatNumber(StateTagInfo.ExtraData[2], true)
            self:SetItemMinus(true)
            self.MinusWidget.Btn_Minus:UnBindEventOnClicked(self, self.CancelSelectClick)
            self.MinusWidget.Btn_Minus:BindEventOnClicked(self, self.CancelSelectClick)
            if (Content.ItemType ~= CommonConst.DataType.Weapon) then
                self:SetItemMoney(StateTagInfo.ExtraData[4], Utils.FormatNumber(math.floor(StateTagInfo.ExtraData[3] + 0.5), true), true)
            end
        end
        self:CheckAndSetVisibility(self.SelectWidget, UIConst.VisibilityOp.SelfHitTestInvisible)
        self:CheckAndSetVisibility(self.SelectCountWidget, UIConst.VisibilityOp.SelfHitTestInvisible)

        if (Content.ItemType == CommonConst.DataType.Weapon) then
            self:CheckAndSetVisibility(self.MoneyWidget, UIConst.VisibilityOp.Collapsed)
        else
            -- self:CheckAndSetVisibility(self.CountWidget, UIConst.VisibilityOp.Collapsed)
            self:CheckAndSetVisibility(self.MoneyWidget, UIConst.VisibilityOp.SelfHitTestInvisible)
        end
        -- local MoneyVisibility = Content.ItemType == CommonConst.DataType.Weapon and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.SelfHitTestInvisible
        -- self:CheckAndSetVisibility(self.MoneyWidget, MoneyVisibility)
    elseif (StateTagInfo.Name == "InSelectList") then
        if (StateTagInfo.ExtraData ~= nil) then
            self:SetSelectNum(Utils.FormatNumber(StateTagInfo.ExtraData[1], true))

            self:SetItemMinus(true)
            self.MinusWidget.Btn_Minus.AudioEventPath = "event:/ui/common/click_btn_minusMulti"
            self.MinusWidget.Btn_Minus:UnBindEventOnClicked(self, self.CancelSelectClick)
            self.MinusWidget.Btn_Minus:BindEventOnClicked(self, self.CancelSelectClick)
            if (Content.ItemType ~= CommonConst.DataType.Weapon) then
                self:SetItemMoney(StateTagInfo.ExtraData[4],
                    Utils.FormatNumber(math.floor(StateTagInfo.ExtraData[3] + 0.5), true), true)
            end
        end
        self:CheckAndSetVisibility(self.MinusWidget, UIConst.VisibilityOp.SelfHitTestInvisible)
        self:CheckAndSetVisibility(self.SelectCountWidget, UIConst.VisibilityOp.SelfHitTestInvisible)

        if (Content.ItemType == CommonConst.DataType.Weapon) then
            self:CheckAndSetVisibility(self.MoneyWidget, UIConst.VisibilityOp.Collapsed)
        else
            -- self:CheckAndSetVisibility(self.CountWidget, UIConst.VisibilityOp.Collapsed)
            self:CheckAndSetVisibility(self.MoneyWidget, UIConst.VisibilityOp.SelfHitTestInvisible)
        end
        -- local MoneyVisibility = Content.ItemType == CommonConst.DataType.Weapon and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.SelfHitTestInvisible
        -- self:CheckAndSetVisibility(self.MoneyWidget, MoneyVisibility)
    elseif (StateTagInfo.Name == "Normal") then
        if (StateTagInfo.ExtraData ~= nil) then
            self:SetSelectNum(0, Utils.FormatNumber(StateTagInfo.ExtraData[1], true))

            if (Content.StuffType ~= CommonConst.DataType.Weapon) then
                self:SetItemMoney(StateTagInfo.ExtraData[3], Utils.FormatNumber(math.floor(StateTagInfo.ExtraData[2] + 0.5), true), true)
            end

            self:CheckAndSetVisibility(self.MinusWidget, UIConst.VisibilityOp.Collapsed)
            self:CheckAndSetVisibility(self.SelectWidget, UIConst.VisibilityOp.Collapsed)
            self:CheckAndSetVisibility(self.SelectCountWidget, UIConst.VisibilityOp.Collapsed)

            if (Content.ItemType == CommonConst.DataType.Weapon) then
                self:CheckAndSetVisibility(self.MoneyWidget, UIConst.VisibilityOp.Collapsed)
            else
                -- self:CheckAndSetVisibility(self.CountWidget, UIConst.VisibilityOp.Collapsed)
                self:CheckAndSetVisibility(self.MoneyWidget, UIConst.VisibilityOp.SelfHitTestInvisible)
            end
        else
            self:CheckAndSetVisibility(self.MinusWidget, UIConst.VisibilityOp.Collapsed)
            self:CheckAndSetVisibility(self.SelectWidget, UIConst.VisibilityOp.Collapsed)
            self:CheckAndSetVisibility(self.SelectCountWidget, UIConst.VisibilityOp.Collapsed)
            self:CheckAndSetVisibility(self.MoneyWidget, UIConst.VisibilityOp.Collapsed)
            -- if (Content.ItemType ~= CommonConst.DataType.Weapon and Content.ItemType ~= CommonConst.DataType.Mod) then
            --     self:CheckAndSetVisibility(self.CountWidget, UIConst.VisibilityOp.SelfHitTestInvisible)
            -- end
        end
    end
    self:SetItemShowGrey(StateTagInfo.IsShowGrey)
end

-- 检查并设置可见性
function M:CheckAndSetVisibility(WidgetComp, VisibilityOp)
    if (self.WidgetMap[WidgetComp]) then
        WidgetComp:SetVisibility(VisibilityOp)
        return true
    elseif WidgetComp and (WidgetComp == self.MoneyWidget) then
        WidgetComp:SetVisibility(VisibilityOp)
        return true
    end
    return false
end

-- 设置成灰色
function M:SetItemShowGrey(bShowGrey)
    -- 先暂时用透明度代替一下
    if (bShowGrey) then
        if (self.ItemType == CommonConst.DataType.Weapon) then
            self.ShowWarningText = GText("UI_Bag_Decompose_Unable")
        elseif (self.ItemType == CommonConst.DataType.Mod) then
            self.ShowWarningText = GText("UI_Bag_ModExtract_Forbid")
        else
            self.ShowWarningText = GText("UI_Tips_CantSell")
        end
        self:SetItemConflict(true)
        -- self:SetRenderOpacity(0.6)
    else
        self:SetItemConflict(false)
    end
end

-- 取消选中
function M:CancelSelectClick()
    if (self.ParentWidget ~= nil and self.Content.StateTagInfo) then
        local AllCount = #self.Content.StateTagInfo.ExtraData
        if type(self.Content.StateTagInfo.ExtraData[AllCount]) == "function" then
            self.Content.StateTagInfo.ExtraData[AllCount](self.ParentWidget, self.Content.Uuid)
        else
            DebugPrint("StateTagInfo.ExtraData[AllCount] Not function!")
        end
    end
end

--- 设置冲突标识
---@param bConflict boolean @是否有冲突
function M:SetItemConflict(bConflict)
    self:_SetItemConflictImpl(bConflict, self.ShowWarningText)
    -- 将自身以及红点移到最上层（因为目前bAllUseAsyncLoadWidget是false，所以可以直接这样写）
    self:CheckWidgetIsTop(self.ConflictWidget)
    self:CheckWidgetIsTop(self.ComItemReddot)
end

-- function M:_SetItemConflictImpl(bConflict, Text)
--     local Callback = function(CoroutineObj)
--         if bConflict then
--             if not self.WidgetMap[self.ConflictWidget] and not IsValid(self.ConflictWidget)  then
--                 self.ConflictWidget = self:CreateWidgetAsync("ComItemConflict", CoroutineObj)
--             end
--             self.ConflictWidget.Text_SoldOut:SetText(Text)
--             self:AddWidgetToNode(self.ConflictWidget)
--         elseif self.WidgetMap[self.ConflictWidget] then
--             self:RemoveWidgetFromNode(self.ConflictWidget)
--         end
--         -- 将自身以及红点移到最上层
--         self:CheckWidgetIsTop(self.ConflictWidget)
--         self:CheckWidgetIsTop(self.ComItemReddot)
--     end
--     if self.bAllUseAsyncLoadWidget then
--         self:AsyncLoadWidgetCommon("ConflictWidget" , "SetItemConflictTask", Callback)
--     else
--         Callback()
--     end
-- end


function M:OnMouseButtonDown(MyGeometry, MouseEvent)
    if (self.ItemType == "EmptyGrid") then
        return UWidgetBlueprintLibrary.Handled()
    end

    if UE4.UKismetInputLibrary.PointerEvent_IsMouseButtonDown(MouseEvent, UE4.EKeys.RightMouseButton) then
        return UWidgetBlueprintLibrary.Handled()
    end
    return M.Super.OnMouseButtonDown(self, MyGeometry, MouseEvent)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
    if (self.ItemType == "EmptyGrid") then
        return UWidgetBlueprintLibrary.Handled()
    end
    return M.Super.OnMouseButtonUp(self, MyGeometry, MouseEvent)
end

-----------------------各自模块的更新函数----------Mod相关---------------
function M:UpdateModItem()
    local ModId = self.Content.UnitId
    if not ModId then return end
    local ModDataInfo = DataMgr.Mod[ModId]
    if not ModDataInfo then
        DebugPrint("该ModId被策划删了...", ModId)
        return
    end
    local ModCost, Mod = nil, nil
    if self.Content.Uuid then
        local ModUuid = self.Content.Uuid
        Mod = ModController:GetModel():GetMod(ModUuid)
        if not Mod then
            local Avatar = GWorld:GetAvatar()
            Mod = Avatar.Mods[ModUuid]
        end
        if (Mod) then
            ModId = Mod.ModId
            ModCost = Mod.Cost
        else
            DebugPrint("UpdateModItem Mod data not find, ModId is", ModId)
        end
    else
        ModId = self.Content.UnitId
        ModDataInfo = DataMgr.Mod[ModId]
        ModCost = ModDataInfo.Cost
    end

    if Mod then
        if Mod.Level and Mod.Level ~= 0 then
            self:SetItemStartLevel(Mod.Level)
        end
        self:ShowModStar(Mod)
    end
end

function M:ShowModStar(Mod)
    if not Mod or not Mod:HasCardLevel() then
        if IsValid(self.ModStarWidget) then
            self.ModStarWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    else
        if (not self:CheckAndSetVisibility(self.ModStarWidget, UIConst.VisibilityOp.HitTestInvisible)) then
            local Widget = UIManager(self):CreateWidget('/Game/UI/WBP/Common/Item/Widget/WBP_Com_Item_ModStar.WBP_Com_Item_ModStar')
            local WidgetSlot = self.Node_Widget:AddChild(Widget)
            WidgetSlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
            WidgetSlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
            self.ModStarWidget = Widget
            self.WidgetMap[Widget] = true
        end
        self.ModStarWidget.List_ModStar:ClearListItems()
        for i=1, (Mod.ModCardLevelMax) do
            local StarContent = NewObject(UIUtils.GetCommonItemContentClass())
            StarContent.Idx = i
            StarContent.bActivate = i<= Mod.CurrentModCardLevel
            StarContent.bGolden = false
            self.ModStarWidget.List_ModStar:AddItem(StarContent)
        end
    end
end

function M:HideNotNeccessaryWidget(bHide)
    local ChildrenCount = self.Node_Widget:GetChildrenCount()
    if ChildrenCount < 1 then
        return -- 没有子控件直接返回
    end

    for i = 0, ChildrenCount - 1 do
        local ChildWidget = self.Node_Widget:GetChildAt(i)
        if (self.WidgetMap[ChildWidget]) then
            if bHide then
                ChildWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
            else
                ChildWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            end
        end
    end
end

--#Region 一些父类方法的重写
function M:SetItemMinus(bMinus)
    self.Super.SetItemMinus(self,bMinus)
    self.Content.bMinus = bMinus
end

function M:SetSelected(IsSelected)
    if self.NotInteractive then
        return
    end
    if self.Content then 
        self.Content.IsSelect = IsSelected
    end
    -- 如果点击了道具，强制设置回透明度，防止被渐入动画影响
    self.Root:SetRenderOpacity(1)
    self.Item:StopAllAnimations()
    if IsSelected then
        if (not self.Item:IsAnimationPlaying(self.Item.Click)) then
            self.Item:PlayAnimation(self.Item.Click)
        end
    else
        self.Item:PlayAnimation(self.Item.Normal)
    end 
end

function M:SetDraftType(IsDraftType)
    local Callback = function(CoroutineObj)
        -- if self.DraftItemWidget and not IsValid(self.DraftItemWidget) then
        --     self.WidgetMap[self.DraftItemWidget] = nil
        -- end
        if IsDraftType then
            self.DraftItemWidget = self:GetOrCreateGroupWidget("DraftCompendiumItem", CoroutineObj)
            -- if not self.WidgetMap[self.DraftItemWidget] then
            --     self.DraftItemWidget = self:CreateWidgetAsync("DraftCompendiumItem",CoroutineObj)
            -- end
            -- self:AddWidgetToNode(self.DraftItemWidget)
        else
            self:RemoveGroupWidget("DraftCompendiumItem")
            -- if self.DraftItemWidget and self.WidgetMap[self.DraftItemWidget] then
            --     self:RemoveWidgetFromNode(self.DraftItemWidget)
            -- end
        end
    end

    self:AsyncLoadWidgetCommon("DraftItemWidget", "SetDraftTypeTask", Callback)
end
--#endregion

return M
