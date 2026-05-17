--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_WarmUp_P_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
local ActivityUtils = require "Blueprints.UI.WBP.Activity.ActivityUtils"

function M:Construct()
    self.CurrentAngle = self.DynamicEntryBox_List.RadialBoxSettings.StartingAngle
    self.SectorCentralAngle = self.DynamicEntryBox_List.RadialBoxSettings.SectorCentralAngle
    self.ListUIWheelSpeed = 5
    self.ListUIDragSpeed = 100
    self.MinAngle = self.DynamicEntryBoxList_Start or 318
    self.MaxAngle = self.DynamicEntryBoxList_End or 350
    self.Slider_Time:BindScroolEvent(self,self.OnScrollList, self.ListUIWheelSpeed)
    self.Slider_Time:BindDragEvent(self,self.OnDragList, self.ListUIDragSpeed)
    self.Slider_Time:BindDragEndEvent(self,self.OnDragEndList)
    self.TrainingLevel_RewardBtn.Btn_TrainingLevelGetAll.OnClicked:Add(self, self.OnGetAllReward)
    self.List_RedDotTop.Btn_Click.OnClicked:Add(self, self.OnClickListRedDotTop)
    self.List_RedDotBottom.Btn_Click.OnClicked:Add(self, self.OnClickListRedDotBottom)
    self.List_RedDotTop:PlayAnimation(self.List_RedDotTop.Loop_T)
    self.List_RedDotBottom:PlayAnimation(self.List_RedDotBottom.Loop_D)

    self.FocusMode = 1
    self.GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
        self:AddTimer(0.1, function()
            self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
        end)
    end
    self.FocusWidgetName = "CheckRewardView"
end

function M:ReceiveEnterStateSelf(StackAction)
    if (StackAction == 1) then
        if self.FocusMode == 3 then
            -- self.FocusWidget.IconItems["TrainingLevel_IconItem_" .. 1]:SetFocus()
            DebugPrint("JLy FocusIndex"..self.FocusIndex)
            local FocusWidget = self.WidgetList[self.FocusIndex]
            if (self.FocusIndex and FocusWidget) then
                FocusWidget.IconItems["TrainingLevel_IconItem_" .. 1]:SetFocus()
            end
            self:UpdateActivityKeyTips("SelectView")
        end
    end
end

function M:OnMouseWheel(MyGeometry, MouseEvent)
    local WheelDelta = UE4.UKismetInputLibrary.PointerEvent_GetWheelDelta(MouseEvent)
    self:OnScrollList(-WheelDelta*self.ListUIWheelSpeed)
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnScrollList(Delta)
    local newAngle = self.CurrentAngle + Delta
    self.CurrentAngle = math.clamp(newAngle, self.MinAngle, self.MaxAngle)

    local FRadialBoxSetting = FRadialBoxSettings()
    FRadialBoxSetting.StartingAngle = self.CurrentAngle
    FRadialBoxSetting.SectorCentralAngle = self.SectorCentralAngle
    self.DynamicEntryBox_List:SetRadialSettings(FRadialBoxSetting)
    
    -- 更新箭头显示
    self:UpdateScrollArrows()
end

--- 滚动到指定角度
---@param TargetAngle number 目标角度
function M:ScrollToAngle(TargetAngle)
    -- 限制在有效范围内
    self.CurrentAngle = math.clamp(TargetAngle, self.MinAngle, self.MaxAngle)
    
    local FRadialBoxSetting = FRadialBoxSettings()
    FRadialBoxSetting.StartingAngle = self.CurrentAngle
    FRadialBoxSetting.SectorCentralAngle = self.SectorCentralAngle
    self.DynamicEntryBox_List:SetRadialSettings(FRadialBoxSetting)
    
    -- 更新箭头显示
    self:UpdateScrollArrows()
end

--- 滚动到指定Widget（通过索引）
---@param WidgetIndex number Widget索引（1-based）
function M:ScrollToWidget(WidgetIndex)
    if not self.WidgetAngles or not self.WidgetAngles[WidgetIndex] then
        return
    end
    
    local TargetAngle = self.WidgetAngles[WidgetIndex]
    self:ScrollToAngle(TargetAngle)
end

function M:OnDragList(Delta)
    local newAngle = self.CurrentAngle + Delta
    self.CurrentAngle = math.clamp(newAngle, self.MinAngle, self.MaxAngle)

    local FRadialBoxSetting = FRadialBoxSettings()
    FRadialBoxSetting.StartingAngle = self.CurrentAngle
    FRadialBoxSetting.SectorCentralAngle = self.SectorCentralAngle
    self.DynamicEntryBox_List:SetRadialSettings(FRadialBoxSetting)
    
    -- 更新箭头显示
    self:UpdateScrollArrows()
end

function M:OnDragEndList()
    self.bIsSmoothingDay = false
end

function M:InitPage(ActivityId, ParentTabId, AllActivityId, ParentWidget)
    local ActivityConfigData = DataMgr.EventMain[ActivityId]
    self.ActivityEndTime = ActivityConfigData.EventEndTime and ActivityConfigData.EventEndTime or ActivityConfigData.PermanenEventTime
    self.RewardEndTime = ActivityConfigData.RewardEndTime
    self.CurActivityId = ActivityId
    self.ParentTabId = ParentTabId
    self.AllActivityIds = AllActivityId
    self.ParentWidget = ParentWidget
    self:InitUI()
    self:RefreshRewardState()
end

function M:InitUI()
    local ActivityConfigData = DataMgr.EventMain[self.CurActivityId]
    self.TrainingLevel_RewardBtn.Text_TrainingLevelGetAll:SetText(GText("UI_Mail_Recieveall"))
    self.WBP_Activity_WarmUp_Title.Text_Title:SetText(GText(ActivityConfigData.EventName))
    self.WBP_Activity_WarmUp_Title.Text_SubTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)

    -- 刷新剩余时间
    local Avatar = GWorld:GetAvatar()
    local IsComplete = false
    if Avatar and self.FinishCondition then
        IsComplete = ConditionUtils.CheckCondition(Avatar, self.FinishCondition)
    end
    if IsComplete then
        local NextDayFiveStamp = TimeUtils.TimestampNextClock(5)
        local RemainActivityTimeDict = UIUtils.GetLeftTimeStrStyle2(NextDayFiveStamp)
        self.Activity_Time:SetTimeText(GText("UI_Event_RemoveRemainTime"), RemainActivityTimeDict)
    else
        self.Activity_Time:SetForeverTimeText(GText("UI_GameEvent_EventTimeRemain"))
    end

    self.Text_ActivityDesc:SetText(GText(ActivityConfigData.EventDes))
    self.Text_ActivityDesc_White:SetText(GText(ActivityConfigData.EventDes))
    self.TrainingLevel_RewardBtn.Key_GetAll:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "A"
            }
        }
    })
    self:InitTimeInfo()
end

function M:InitTimeInfo()
    if (self.ActivityEndTime ~= nil or self.RewardEndTime ~= nil) and self.Activity_Time then
        ActivityUtils.RefreshLeftTime(self, self.Activity_Time)
        self:AddTimer(1.0, ActivityUtils.RefreshLeftTime, true, 0, "RefreshLeftTime", true, self.Activity_Time)
    else
        ActivityUtils.SetLeftTimeView(self.Activity_Time, true)
    end
end

function M:OnGetAllReward()
    local PlayerAvatar = GWorld:GetAvatar()
    if PlayerAvatar == nil then return end
    local function callback(Ret, Rewards)
        if Ret == ErrorCode.RET_SUCCESS then
            UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function()
                self:RefreshRewardState()
            end, nil, nil)
            ActivityUtils.TrySubActivityReddotCommon("Red", self.CurActivityId)
        end
    end
    PlayerAvatar:DailyLoginGetRewardAuto(self.CurActivityId, callback, self.CurActivityId)
end

function M:OnClickListRedDotTop()
    self:ScrollToAngle(self.MinAngle)
end

function M:CleanSelf(bIsRemoveSelf)
    self:RemoveTimer("RefreshLeftTime")
end

function M:OnClickListRedDotBottom()
    self:ScrollToAngle(self.MaxAngle)
end

function M:RefreshRewardState()
    local PageConfigData = self:GetPageConfigData()
    self.DynamicEntryBox_List:Reset()
    self.WidgetList = {}
    self.WidgetStateList = {}
    local bIsCanGet = false
    local CanRewardIndex = PageConfigData.LoginDuration
    for i=1,PageConfigData.LoginDuration do
        local ListWidget=self.DynamicEntryBox_List:BP_CreateEntry()
        -- 保存一下这个ListWidget到self.WidgetList中
        self.WidgetList[i] = ListWidget
        local RewardState = self:InitListWidget(ListWidget, i, PageConfigData.EventReward[i])
        -- 如果有一个可以领奖，则设置为可以领奖
        if RewardState == ActivityUtils.EnumPlayerSignRewardState.SignedNotRecv and not bIsCanGet then
            -- 记录第一个可以领奖的index
            CanRewardIndex = i
            bIsCanGet = true
        end
        self.WidgetStateList[i] = RewardState == ActivityUtils.EnumPlayerSignRewardState.SignedNotRecv
    end

    -- 记录一下每个Widget对应的角度，第一个是最大的角度self.MaxAngle，依次递减，平均分布的
    self.WidgetAngles = {}
    local TotalDays = PageConfigData.LoginDuration
    local AngleStep = (self.MaxAngle - self.MinAngle) / (TotalDays - 1)
    
    for i = 1, TotalDays do
        -- 第一个Widget对应最大角度self.MinAngle，依次递减
        local Angle = self.MaxAngle - (i - 1) * AngleStep
        self.WidgetAngles[i] = Angle
    end
    
    if bIsCanGet then
        self.TrainingLevel_RewardBtn.Btn_TrainingLevelGetAll:SetForbidden(false)
    else
        self.TrainingLevel_RewardBtn.Btn_TrainingLevelGetAll:SetForbidden(true)
    end
    self:InitNavigationRule()
    -- 初始化箭头显示
    self:UpdateScrollArrows()
    self:ScrollToWidget(CanRewardIndex)
end

function M:InitListWidget(ListWidget, Index, RewardId)
    local PlayerAvatar = GWorld:GetAvatar()
    if PlayerAvatar == nil then return end
    local DailyLoginServerData = PlayerAvatar.DailyLogin[self.CurActivityId]
    local RewardState = ActivityUtils.GetCurSignRewardState(Index, DailyLoginServerData)
    local isGot = RewardState == ActivityUtils.EnumPlayerSignRewardState.Completed
    local bCanGet = RewardState == ActivityUtils.EnumPlayerSignRewardState.SignedNotRecv
    
    -- 先停止所有动画，确保Widget状态正确
    ListWidget:StopAllAnimations()
    
    if RewardState == ActivityUtils.EnumPlayerSignRewardState.NotSign then
        ListWidget:PlayAnimation(ListWidget.Normal)
        DebugPrint("JLy RewardState is Normal", Index, RewardId)
    elseif RewardState == ActivityUtils.EnumPlayerSignRewardState.SignedNotRecv then
        ListWidget:PlayAnimation(ListWidget.Complete)
        DebugPrint("JLy RewardState is Completed", Index, RewardId)
    elseif RewardState == ActivityUtils.EnumPlayerSignRewardState.Completed then
        ListWidget:PlayAnimation(ListWidget.Received)
    end


    ListWidget:SetDateText(Index)
    local RewardInfo = DataMgr.Reward[RewardId]
    for j = 1, 2 do
        local RewardItem = ListWidget.IconItems["TrainingLevel_IconItem_" .. j]
        local Content = {
            Count = RewardInfo.Count[j][1],
            Id = RewardInfo.Id[j],
            Icon = DataMgr[RewardInfo.Type[j]][RewardInfo.Id[j]].Icon,
            ItemType = RewardInfo.Type[j],
            Rarity = ItemUtils.GetItemRarity(RewardInfo.Id[j], RewardInfo.Type[j]),
            -- Uuid = RewardInfo.Id[j],
            bHasGot = isGot,
            bCanGet = bCanGet,
            IsShowDetails = true,
            OnMenuOpenChangedEvents = {
                Obj = self,
                Callback = self.MenuOpenChangedEvent
            }
        }
        if (ModController:IsMobile()) then
            RewardItem.WS_Item:SetActiveWidgetIndex(1)
            RewardItem.Com_Item_Universal_S.WidgetMap = nil
            RewardItem.Com_Item_Universal_S:Init(Content)
            if bCanGet then
                RewardItem.Com_Item_Universal_S:SetIsCanGet(true)
            end
        else
            RewardItem.WS_Item:SetActiveWidgetIndex(0)
            RewardItem.Com_Item_Universal_M.WidgetMap = nil
            RewardItem.Com_Item_Universal_M:Init(Content)
            if bCanGet then
                RewardItem.Com_Item_Universal_M:SetIsCanGet(true)
            end
        end
    end

    return RewardState
end

function M:MenuOpenChangedEvent(IsOpened, Content)
    if IsOpened then
        self.IsOpenTip = true
        self:UpdateActivityKeyTips("EmptyView")
    else
        self.IsOpenTip = false
        self:UpdateActivityKeyTips("SelectView")
    end
end

function M:GetPageConfigData()
    return DataMgr.DailyLogin[self.CurActivityId]
end

function M:PlayFadeIn()
    self:PlayAnimation(self.In)
end

function M:UpdatePage(OperateSrc)
    self:RefreshRewardState()
end

function M:ShowPage(IsNeedPlayInAnim)
    if (IsNeedPlayInAnim) then
        self:PlayFadeIn()
    end
    self:RefreshRewardState()
    self:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
end

function M:HidePage(IsNeedPlayOutAnim)
    if (IsNeedPlayOutAnim) then
        self:PlayFadeOut()
    end
    self:SetVisibility(UIConst.VisibilityOp["Collapsed"])
end

function M:PlayFadeOut(IsRemoveFromParent)
    -- 播放退场动画
    self:PlayAnimation(self.Out)
end

function M:HandleKeyDownInPage(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadButtonDown(InKeyName)
    end
    return IsEventHandled
end

function M:OnGamePadButtonDown(InKeyName)
    if (InKeyName == UIConst.GamePadKey.FaceButtonBottom and self.FocusMode == 1) then
        self:OnGetAllReward()
        return true
    elseif (InKeyName == UIConst.GamePadKey.LeftThumb) then
        if (self.FocusMode == 1) then
            self:SwitchToRewardViewMode()
            return true
        end
        if (self.FocusMode == 2) then
            self.FocusWidget.IconItems["TrainingLevel_IconItem_" .. 1]:SetFocus()
            self.FocusMode = 3
            self:UpdateActivityKeyTips("SelectView")
            return true
        end
        return true
    elseif (InKeyName == UIConst.GamePadKey.FaceButtonRight) then
        if (self.FocusMode == 2) then
            self:SetFocus()
            self.FocusMode = 1
            self:UpdateActivityKeyTips("CheckRewardView")
            self.TrainingLevel_RewardBtn.Key_GetAll:SetVisibility(UE4.ESlateVisibility.Visible)
            return true
        end
        if (self.FocusMode == 3) then
            -- self.FocusWidget:SetFocus()
            if self.FocusIndex and self.WidgetList[self.FocusIndex] then
                self.WidgetList[self.FocusIndex]:SetFocus()
            end
            self.FocusMode = 2
            self:UpdateActivityKeyTips("CheckRewardView")
            return true
        end
        return false
    end
    return false
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName
    self:UpdateUIByInputDevice(self.CurInputDeviceType)
end


function M:UpdateUIByInputDevice(CurInputDeviceType)
    if(CurInputDeviceType == ECommonInputType.Gamepad) then
        self.TrainingLevel_RewardBtn.Key_GetAll:SetVisibility(UE4.ESlateVisibility.Visible)
        self.FocusMode = 1
    else
        self:UpdateActivityKeyTips(self.FocusWidgetName)
        self.TrainingLevel_RewardBtn.Key_GetAll:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

--- 更新滚动箭头的显示（基于RadialBox的角度）
function M:UpdateScrollArrows()
    -- 如果数量少于五个，直接全部隐藏
    if #self.WidgetList <= 5 then
        self.Group_ListTop:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Group_ListBottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end
    -- 方案1：基于角度判断（简单高效）
    local IsAtTop = self.CurrentAngle <= self.WidgetAngles[2]
    local IsAtBottom = self.CurrentAngle >= self.WidgetAngles[#self.WidgetAngles - 1]
    
    -- 检测上方是否有红点
    local HasReddotTop = false
    local HasReddotBottom = false
    
    if not IsAtTop then
        -- 检查上方区域（角度小于当前角度的Widget）是否有红点
        for i = 1, #self.WidgetAngles do
            if self.WidgetAngles[i] < self.CurrentAngle and self.WidgetStateList[i] then
                HasReddotTop = true
                break
            end
        end
    end
    
    if not IsAtBottom then
        -- 检查下方区域（角度大于当前角度的Widget）是否有红点
        for i = 1, #self.WidgetAngles do
            if self.WidgetAngles[i] > self.CurrentAngle and self.WidgetStateList[i] then
                HasReddotBottom = true
                break
            end
        end
    end
    
    -- 更新上方箭头/红点显示
    self.Group_ListTop:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if not IsAtTop then
        if HasReddotTop then
            self.List_RedDotTop:SetVisibility(UE4.ESlateVisibility.Visible)
            self.List_ArrowTop:SetVisibility(UE4.ESlateVisibility.Collapsed)
        else
            self.List_RedDotTop:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.List_ArrowTop:SetVisibility(UE4.ESlateVisibility.Visible)
        end
        self.Group_ListTop:SetVisibility(UE4.ESlateVisibility.Visible)
    else
        self.List_RedDotTop:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.List_ArrowTop:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    
    -- 更新下方箭头/红点显示
    self.Group_ListBottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if not IsAtBottom then
        if HasReddotBottom then
            self.List_RedDotBottom:SetVisibility(UE4.ESlateVisibility.Visible)
            self.List_ArrowBottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
        else
            self.List_RedDotBottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.List_ArrowBottom:SetVisibility(UE4.ESlateVisibility.Visible)
        end
        self.Group_ListBottom:SetVisibility(UE4.ESlateVisibility.Visible)
    else
        self.List_RedDotBottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.List_ArrowBottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    
    -- 【可选】方案2：基于CanvasPanel可视区域的精确检测
    -- 如果需要更精确的检测（考虑实际Entry的位置），可以启用下面的代码
    -- local HasHiddenTop, HasHiddenBottom, HasReddotTop, HasReddotBottom = self:CheckEntriesInCanvasPanel()

    -- self.Group_ListTop:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- self.Group_ListBottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
    -- if HasReddotTop then
    --     self.List_RedDotTop:SetVisibility(UE4.ESlateVisibility.Visible)
    --     self.List_ArrowTop:SetVisibility(UE4.ESlateVisibility.Collapsed)
    --     self.Group_ListTop:SetVisibility(UE4.ESlateVisibility.Visible)
    -- elseif HasHiddenTop then
    --     self.List_RedDotTop:SetVisibility(UE4.ESlateVisibility.Collapsed)
    --     self.List_ArrowTop:SetVisibility(UE4.ESlateVisibility.Visible)
    --     self.Group_ListTop:SetVisibility(UE4.ESlateVisibility.Visible)
    -- end

    -- if HasReddotBottom then
    --     self.List_RedDotBottom:SetVisibility(UE4.ESlateVisibility.Visible)
    --     self.List_ArrowBottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
    --     self.Group_ListBottom:SetVisibility(UE4.ESlateVisibility.Visible)
    -- elseif HasHiddenBottom then
    --     self.List_RedDotBottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
    --     self.List_ArrowBottom:SetVisibility(UE4.ESlateVisibility.Visible)
    --     self.Group_ListBottom:SetVisibility(UE4.ESlateVisibility.Visible)
    -- end
end

--- 判断Widget是否被父容器完全裁切（不可见）
---@param Widget UWidget 要检查的Widget
---@param ParentWidget UWidget 父容器Widget
---@return boolean IsFullyCulled 是否被完全裁切（完全不可见）
local function IsWidgetFullyCulled(Widget, ParentWidget)
    if not Widget or not ParentWidget then
        return false
    end
    
    -- 获取Widget的实际渲染边界（考虑Transform）
    local WidgetGeometry = Widget:GetCachedGeometry()
    local WidgetLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(WidgetGeometry)
    local WidgetTopLeft = UE4.USlateBlueprintLibrary.LocalToAbsolute(WidgetGeometry, UE4.FVector2D(0, 0))
    local WidgetBottomRight = UE4.USlateBlueprintLibrary.LocalToAbsolute(WidgetGeometry, UE4.FVector2D(WidgetLocalSize.X, WidgetLocalSize.Y))
    
    -- 获取父容器的裁切区域（考虑Transform）
    local ParentGeometry = ParentWidget:GetCachedGeometry()
    local ParentLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(ParentGeometry)
    local ParentTopLeft = UE4.USlateBlueprintLibrary.LocalToAbsolute(ParentGeometry, UE4.FVector2D(0, 0))
    local ParentBottomRight = UE4.USlateBlueprintLibrary.LocalToAbsolute(ParentGeometry, UE4.FVector2D(ParentLocalSize.X, ParentLocalSize.Y))
    
    -- 判断Widget是否完全在父容器外（被完全裁切）
    if WidgetBottomRight.X < ParentTopLeft.X or   -- Widget完全在左侧
       WidgetTopLeft.X > ParentBottomRight.X or   -- Widget完全在右侧
       WidgetBottomRight.Y < ParentTopLeft.Y or   -- Widget完全在上方
       WidgetTopLeft.Y > ParentBottomRight.Y then -- Widget完全在下方
        return true
    end
    
    return false
end

--- 检测WidgetList中的Widget是否有被裁切的（显示滚动箭头）
function M:CheckEntriesInCanvasPanel()
    if not self.WidgetList or #self.WidgetList == 0 then
        return false, false, false, false
    end
    
    -- 获取Canvas的实际边界（考虑Transform）
    local CanvasGeometry = self.List:GetCachedGeometry()
    local CanvasLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(CanvasGeometry)
    local CanvasTopLeft = UE4.USlateBlueprintLibrary.LocalToAbsolute(CanvasGeometry, UE4.FVector2D(0, 0))
    local CanvasBottomRight = UE4.USlateBlueprintLibrary.LocalToAbsolute(CanvasGeometry, UE4.FVector2D(CanvasLocalSize.X, CanvasLocalSize.Y))
    
    local CanvasTop = CanvasTopLeft.Y
    local CanvasBottom = CanvasBottomRight.Y
    
    local HasHiddenTop = false
    local HasHiddenBottom = false
    local HasReddotTop = false
    local HasReddotBottom = false
    
    -- 遍历WidgetList检测裁切状态
    for i = 1, #self.WidgetList do
        local Widget = self.WidgetList[i]
        
        -- 判断Widget是否被完全裁切
        local IsFullyCulled = IsWidgetFullyCulled(Widget, self.List)
        
        if IsFullyCulled then
            -- Widget完全被裁切，判断在上方还是下方
            local WidgetGeometry = Widget:GetCachedGeometry()
            local WidgetTopLeft = UE4.USlateBlueprintLibrary.LocalToAbsolute(WidgetGeometry, UE4.FVector2D(0, 0))
            
            if WidgetTopLeft.Y < CanvasTop then
                HasHiddenTop = true
                if self.WidgetStateList[i] then
                    HasReddotTop = true
                end
            else
                HasHiddenBottom = true
                if self.WidgetStateList[i] then
                    HasReddotBottom = true
                end
            end
        end
    end
    
    return HasHiddenTop, HasHiddenBottom, HasReddotTop, HasReddotBottom
end

function M:InitNavigationRule()
    -- 遍历self.WidgetList，设置每个Widget的NavigationRule
    -- 首先Widget之间上下导航,要注意边界情况
    local WidgetCount = #self.WidgetList
    for i=1,WidgetCount-1 do
        local Widget = self.WidgetList[i]
        local NextWidget = self.WidgetList[i+1]
        Widget:SetNavigationRuleCustom(EUINavigation.Up, {self, function()
            if IsWidgetFullyCulled(NextWidget, self.List) then
                self:OnScrollList(-10)
            end
            self.FocusWidget = NextWidget
            self.FocusIndex = i + 1
            return NextWidget
        end})

        NextWidget:SetNavigationRuleCustom(EUINavigation.Down, {self, function()
            if IsWidgetFullyCulled(Widget, self.List) then
                self:OnScrollList(10)
            end
            self.FocusWidget = Widget
            self.FocusIndex = i
            return Widget
        end})
    end
    self.WidgetList[1]:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    self.WidgetList[WidgetCount]:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)

    -- 每个Widget里面的子Item，设置互相左右导航
    for i=1,WidgetCount do
        local Widget = self.WidgetList[i]
        -- 直接拿两个Item，设置互相左右导航 
        local Item = Widget.IconItems["TrainingLevel_IconItem_" .. 1]
        local Item2 = Widget.IconItems["TrainingLevel_IconItem_" .. 2]
        Item:SetNavigationRuleExplicit(EUINavigation.Right, Item2)
        Item2:SetNavigationRuleExplicit(EUINavigation.Left, Item)

        Widget:SetNavigationRuleCustom(EUINavigation.Left, {self, function()
            self.FocusMode = 1
            self:UpdateActivityKeyTips("CheckRewardView")
            self.TrainingLevel_RewardBtn.Key_GetAll:SetVisibility(UE4.ESlateVisibility.Visible)
            return self
        end})
        Item:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
        Item:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
        Item2:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
        Item2:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    end
end

function M:GetCurFocusWidgetInfo()
    return self.FocusWidgetName, self.FocusWidget
end

--- 更新ActivityMain的按键提示（统一接口）
---@param ViewType string "CheckRewardView" | "SelectView" | "EmptyView"
function M:UpdateActivityKeyTips(ViewType)
    if ModController:IsMobile() then
        return
    end
    
    local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
    if ActivityMain then
        ActivityMain:UpdateActivityKeyTips(ViewType)
    end
end

--- 切换到奖励查看模式（FocusMode = 2）
function M:SwitchToRewardViewMode()
    if self.WidgetList and #self.WidgetList > 0 then
        self.WidgetList[1]:SetFocus()
        self:OnScrollList(50)
        self.FocusWidget = self.WidgetList[1]
        self.FocusIndex = 1
        self.FocusMode = 2
        self:UpdateActivityKeyTips("CheckRewardView")
        self.TrainingLevel_RewardBtn.Key_GetAll:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:OnSubTabNavigationRight()
    self:SwitchToRewardViewMode()
end

return M
