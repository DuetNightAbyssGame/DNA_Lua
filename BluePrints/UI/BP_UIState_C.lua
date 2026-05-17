--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--


-- @note 脚本层的UI基类

require "UnLua"

---@alias BP_UIState_C BP_UIState_C|TimerMgr|{Super:BP_UIState_C}
---@type BP_UIState_C
local BP_UIState_C = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.Common.DelayFrameComponent", "BluePrints.UI.BP_EMUserWidgetUtils_C"})

--- 新版是否阻塞所有UI输入（目前默认开启）
local NEW_BlockAllUIInput = true

function BP_UIState_C:Initialize(Initializer)
    rawset(self, "IsInit",false)                -- 是否初始化
    rawset(self, "IsUIPopUp",nil)               -- 是否是弹窗
    rawset(self, "HideTags",{})                 -- 隐藏的Tag标签
    rawset(self, "UIStateTag",nil)              -- 界面当前的状态标签（用于分组管理）
    rawset(self, "bIsPauseWorldRendering",nil)  -- 是否打开的时候停止场景渲染
    rawset(self, "ListenEvent",{})              -- 监听的事件
    -- rawset(self, "DelayFuncs",{})
    rawset(self, "IsAllowEscape",false)         -- 允许使用esc关闭界面
    rawset(self, "IsBeginToClose",false)        -- 是否处于待关闭状态（执行关闭到真正GC之前设置，建议还是用IsMarkToRemove）
    rawset(self, "IsMarkToRemove",false)        -- 是否处于待移除状态（播放退出动画时候设置）
    rawset(self, "IsGlobalUI",false)            -- 是否是全局界面（切场景不会销毁）
    rawset(self, "IsDestroied",false)           -- 是否被销毁(给Lua内存检测计数用（后面会删除）)
    rawset(self, "IsSetEntitysVisibilityWithAnim",false)        -- 是否处于通过动画设置Entity可见性
    rawset(self, "IsAddInDeque",false)          -- 是否处于跳转队列之中
    -- self.UILuaTimerHandles = {}
end

function BP_UIState_C:Construct()
    -- 目前仅仅是为了避免调用Super的时候报错，没有实际意义，如果子类的蓝图里的构造节点没有内容，则完全可以不调用父类
    -- DebugPrint("Hy@ UIState型界面打开 Construct，名称：", self:GetUIConfigName())
    self.Overridden.Construct(self)
end

-- 设置UI名称
function BP_UIState_C:SetBaseName(Name)
    self.ConfigName = Name
end

-- 获取UI配置名称
function BP_UIState_C:GetUIConfigName()
    local NameText = self.ConfigName or self.WidgetName
    if (NameText) then
        return NameText
    end
    return self:GetName()
end

-- 设置是否暂停世界渲染
function BP_UIState_C:SetIsPauseWorldRendering(bIsPauseRendering)
    self.bIsPauseWorldRendering = bIsPauseRendering
end

-- 设置UI状态标签（用于分组管理）
function BP_UIState_C:SetUIStateTag(StateTag)
    self.UIStateTag = StateTag
end

-- 添加监听
-- function BP_UIState_C:AddDispatcher(EventName, Obj, Func)
--     if (type(Func) ~= "function") then
--         return
--     end
--     if (EventID[EventName] == nil) then
--         return
--     end
--     EventManager:AddEvent(EventName, Obj, Func)
--     self.ListenEvent[EventName] = Obj
-- end

-- 移除监听
-- function BP_UIState_C:RemoveDispatcher(EventName)
--     if (self.ListenEvent[EventName] == nil) then
--         return
--     end
--     EventManager:RemoveEvent(EventName, self.ListenEvent[EventName])
--     -- 既然移除监听了，对Obj的引用应该也需要断开
--     self.ListenEvent[EventName] = nil
-- end

-- 移除所有监听
-- function BP_UIState_C:RemoveAllDispatcher()
--     if rawget(self, "ListenEvent") then
--         for k,v in pairs(self.ListenEvent) do
--             EventManager:RemoveEvent(k, v)
--         end 
--     end

--     self:RemoveInputMethodChangedListen()
--     self.ListenEvent = {}
-- end

-- 更新参数
function BP_UIState_C:UpdateArgs(Args)
    self.ExtraArgs = self.ExtraArgs or {}
    for k,v in pairs(Args) do
        self.ExtraArgs[k] = v
    end
    self.IsAllowEscape = self.ExtraArgs.IsAllowEscape
end

-- 用于数据初始化，子类如果有需求可以重写该方法，但记得调用一下父类该方法
function BP_UIState_C:InitUIInfo(Name, IsInUIMode, EventList, ...)
    DebugPrint("Hy@ UIState型界面打开 InitUIInfo，名称：", self:GetUIConfigName())
    self:SetBaseName(Name)
    -- 判断需不需要绑定In、Out动画逻辑
    self:BindInOutAnimationWithConfigParam()

    self.IsInUIMode = IsInUIMode
    if (self.IsInUIMode) then
        self:SetInputUIOnly(true)
    end

    local Params = {...}
    -- 统一播放一下动画
    if (self.Auto_In ~= nil) then
        local WrapFunc = nil
        WrapFunc = function()
            -- self:BlockAllUIInput(false)
            self:UIOnLoaded(table.unpack(Params))
            self:UnbindFromAnimationFinished(self.Auto_In, {self, WrapFunc})
        end
        -- 自动播放入场动画
        self:BindToAnimationFinished(self.Auto_In, {self, WrapFunc}) 
        self:PlayAnimationForward(self.Auto_In)
        -- self:BlockAllUIInput(true,"SP_DisplayOnly")
        -- EMUIAnimationSubsystem:EMPlayAnimation(self, self.Auto_In)
    else
        self:UIOnLoaded(...)
    end
    if (EventList ~= nil) then
        for i, v in ipairs(EventList) do
            if (type(self[v]) == "function") then
                self:AddDispatcher(v, self, self[v]) 
            end
        end
    end
    self:AddDispatcher(EventID.OnNetDisconnect, self, self._ClearBlockUIInputTags)
    self:AddDispatcher(EventID.OnConnectSuccess, self, self._ClearBlockUIInputTags)
end

function BP_UIState_C:_ClearBlockUIInputTags()
    self:ClearBlockUIInputTags()
end

-- 绑定入场和出场动画
function BP_UIState_C:BindInOutAnimationWithConfigParam()
    local SystemUIConfig = DataMgr.SystemUI[self:GetUIConfigName()]
    if (SystemUIConfig ~= nil and SystemUIConfig.IsHideBattleUnit ~= nil) then
        if (SystemUIConfig.IsHideBattleUnit ~= UIConst.EnumHideBattleUnitStyle.NormalShowAndHideAll and 
                SystemUIConfig.IsHideBattleUnit ~= UIConst.EnumHideBattleUnitStyle.NormalShowAndHideAllExceptSelf) then
            local InAnimation = self.In ~= nil and self.In or self.Auto_In
            local OutAnimation = self.Out ~= nil and self.Out or self.Auto_Out
            if (InAnimation) then
                self:BindToAnimationStarted(InAnimation, {self, self.OnInAnimationStarted})
                self:BindToAnimationFinished(InAnimation, {self, self.OnInAnimationFinished})
            end
            if (OutAnimation) then
                self:BindToAnimationStarted(OutAnimation, {self, self.OnOutAnimationStarted})
                self:BindToAnimationFinished(OutAnimation, {self, self.OnOutAnimationFinished})
            end
        end
    end
end

-- function BP_UIState_C:CheckNeedAutoFocusWithInputType()
--     local TopUIWidget = UIManager(self):GetWidgetObjInTopStack()
--     local LastestCreateWidget = UIManager(self):GetLastestAndFocusableUIWidgetObj()
--     if (self == TopUIWidget and self == LastestCreateWidget) then
--         return true
--     else
--         return false
--     end
-- end

-- 给UI对象组装组件
function BP_UIState_C:SetComponent(CompModulePath)
    self.assembledComponents = self.assembledComponents or {}
    if not self.assembledComponents[CompModulePath] then
        self._components = {CompModulePath}
        AssembleComponents(self)
        -- 记录该组件已被组装
        self.assembledComponents[CompModulePath] = true
    end
end

-- 界面加载方法
function BP_UIState_C:UIOnLoaded(...)
    self.IsInit = true
    self:AddInputMethodChangedListen()
    self:OnLoaded(...)
    if (self.GameInputModeSubsystem) then     --给第一次打开反界面刷一下
        self:OnUpdateUIStyleByInputTypeChange(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

--region 需要外部重新的方法
function BP_UIState_C:OnLoaded(...)
    -- 接收并处理外部参数，一些通用的界面加载完成之后的统一逻辑可以放在这, 子类如有一些Load完成之后的逻辑可以重写该方法
end

-- 根据当前输入方式更新界面的样式
-- function BP_UIState_C:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
--     -- 根据当前输入方式更新界面的样式，子类重写该方法
-- end
--endregion

-- -- 添加输入方式变更监听
-- function BP_UIState_C:AddInputMethodChangedListen()
--     if (IsValid(self.GameInputModeSubsystem)) then
--         self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice) 
--     end
-- end

-- -- 移除输入方式变更监听
-- function BP_UIState_C:RemoveInputMethodChangedListen()
--     if (IsValid(self.GameInputModeSubsystem)) then
--         self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice) 
--     end
-- end

-- 通过Tag标签设置UI可见性
---@param VisibiltyTag string 可见性标签
---@param Invisible boolean 是否隐藏
---@param EDesireVisibilty ESlateVisibility 期望的可见性（可选参数，Hide的时候默认用Collapsed, Show的时候默认用SelfHitTestInvisible）
function BP_UIState_C:SetUIVisibilityTag(VisibiltyTag, Invisible, EDesireVisibilty)
    local IsVisibilityChange = false
    if (not IsValid(self)) then
        return IsVisibilityChange
    end
    if self.HideTags == nil then
        self.HideTags = {}
    end
    if Invisible then
        self.HideTags[VisibiltyTag] = 1
    else
        self.HideTags[VisibiltyTag] = nil
    end
    local IsHide = not IsEmptyTable(self.HideTags)
    if (IsHide) or self.IsHideByNode then
        EDesireVisibilty = EDesireVisibilty or UE4.ESlateVisibility.Collapsed
        if (self:GetVisibility() ~= EDesireVisibilty) then
            if (self.bIsActive) then
                -- 默认UI不会勾选这个选项
                self:DeactivateWidget()
            elseif (self:CheckIsNeedTransitionFade(VisibiltyTag, true)) then
                -- 通过跳转进行变换的UI，利用一个程序动画避免穿帮问题
                self:DealWithUIWidgetWhenStackChange(true, EDesireVisibilty)
            else
                -- 其他情况正常隐藏UI
                self:SetVisibility(EDesireVisibilty)
            end
            SystemGuideManager:HideUIEvent(self.WidgetName)
            IsVisibilityChange = true
        end
    else
        EDesireVisibilty = EDesireVisibilty or UE4.ESlateVisibility.SelfHitTestInvisible
        if (self:GetVisibility() ~= EDesireVisibilty) then
            if (self.bIsActive) then
                self:ActivateWidget()
            elseif (self:CheckIsNeedTransitionFade(VisibiltyTag, false)) then
                -- 通过跳转进行变换的UI，在显示的同时还需要额外设置一下透明度
                self:DealWithUIWidgetWhenStackChange(false, EDesireVisibilty)
            else
                self:SetVisibility(EDesireVisibilty)
            end
            SystemGuideManager:ShowUIEvent(self.WidgetName)
            IsVisibilityChange = true
        end
    end
    return IsVisibilityChange
end

-- 是否需要转场过渡
---@param VisibiltyTag string 可见性标签
---@param bIsHide boolean 是否是隐藏操作
function BP_UIState_C:CheckIsNeedTransitionFade(VisibiltyTag, bIsHide)
    -- 开关没打开，则不需要转场过渡
    if (not UIConst.IsEnablePageJumpAnimEffect) then
        return false
    end
    -- VisibiltyTag不是UIStackChange类型，则不需要转场过渡
    if (VisibiltyTag ~= UIConst.CommonHideTagName.UIStackChange) then
        return false
    end
    -- 如果是MenuLevel或者MenuWorld界面，则不需要转场过渡
    if (self:GetUIConfigName() ~= nil and UIConst.AnimWithJumpConfig[self:GetUIConfigName()] == nil) then
        return false
    end
    -- 如果当前页面需要隐藏且正在播放退场动画，则不需要转场过渡
    if (bIsHide and self:IsAnimationPlaying(self.Out)) then
        return false
    end
    -- 如果当前页面需要显示且正在播放入场动画，则不需要转场过渡
    if (not bIsHide and self:IsAnimationPlaying(self.In)) then
        return false
    end
    -- 如果当前处于待销毁移除状态，则不需要转场过渡
    if (self.IsMarkToRemove) then
        return false
    end
    return true
end

-- 通过Tag标签判断UI是否仅被某个标签隐藏
function BP_UIState_C:IsOnlyHideWithDesireTag(DesireTag)
    if self.HideTags == nil then
        return false
    end
    
    -- 获取第一个键值对
    local FirstKey, FirstValue = next(self.HideTags)
    
    -- 如果表为空
    if FirstKey == nil then
        return false
    end
    
    -- 检查第一个 key 是否是目标 key
    if FirstKey ~= DesireTag then
        return false
    end
    
    -- 检查是否还有第二个 key
    local SecondKey, SecondValue = next(self.HideTags, FirstKey)
    
    -- 如果没有第二个 key，说明只有一个 key 且是目标 key
    return SecondKey == nil
end

-- 通过Tag标签判断UI是否被隐藏
function BP_UIState_C:IsHideWithDesireTag(DesireTag)
    if self.HideTags == nil then
        return false
    end
    local IsHide = self.HideTags[DesireTag] ~= nil
    return IsHide
end

-- 判断UI是否被隐藏
function BP_UIState_C:IsHide()
    if self.HideTags == nil then
        return false
    end
    local IsHide = not IsEmptyTable(self.HideTags)
    return IsHide
end

-- 清除所有隐藏标签
function BP_UIState_C:ClearAllHideTags()
    self.HideTags = {}
end

-- 处理UI在堆栈变化时显示与隐藏的额外逻辑
---@param IsHide boolean 是否隐藏
---@param DesireVisibilty 期望的可见性
function BP_UIState_C:DealWithUIWidgetWhenStackChange(IsHide, DesireVisibilty)
    if (IsHide) then
        local SelfWidgetRenderOpacityBeforeJump = self:GetRenderOpacity() or 1.0
        local JumpConfigData = UIConst.AnimWithJumpConfig[self:GetUIConfigName()]
        if (JumpConfigData) then
            local TweenEndTime = JumpConfigData.InAnimWithJumpTime or UIManager(self):GetTopUIWidgetInAnimEndTime()
            local TweenFinalOpacity = JumpConfigData.IsNeedFadeOut and JumpConfigData.EndFadeOutValue or SelfWidgetRenderOpacityBeforeJump
            self:DoTweenOutWhenSystemStackChange(TweenEndTime, SelfWidgetRenderOpacityBeforeJump, TweenFinalOpacity, EaseType.Linear)
        else
            local TweenEndTime = math.min(UIConst.AnimWithJumpConfig.Normal.InAnimWithJumpTime, UIManager(self):GetTopUIWidgetInAnimEndTime())
            local TweenFinalOpacity = UIConst.AnimWithJumpConfig.Normal.IsNeedFadeOut and UIConst.AnimWithJumpConfig.Normal.EndFadeOutValue or SelfWidgetRenderOpacityBeforeJump
            self:DoTweenOutWhenSystemStackChange(TweenEndTime, SelfWidgetRenderOpacityBeforeJump, TweenFinalOpacity, EaseType.Linear)
        end
        self.SelfWidgetParamForStackChange = {
            RenderOpacityBeforeJump = SelfWidgetRenderOpacityBeforeJump,
            DesireVisibilty = DesireVisibilty,
        }
    else
        self:CancelTweenOutSystemStackChange()
        self:SetVisibility(DesireVisibilty)
    end
end

-- 处理UI在堆栈变化时的淡出效果
---@param bIsForce boolean 是否强制执行(忽略是否在跳转队列中)
function BP_UIState_C:BeginAnimOutToExitWithInStack(bIsForce)
    if (not self.IsAddInDeque and not bIsForce) then
        return
    end
    local PreviousUI = UIManager(self):GetUnderState()
    if (PreviousUI) then
        local JumpConfigData = UIConst.AnimWithJumpConfig[PreviousUI:GetUIConfigName()]
        if (JumpConfigData) then
            -- 暂时先用In动画
            if (PreviousUI.In) then
                local bIsNeedMatchAnimTime = JumpConfigData.bIsNeedMatchAnimTime == nil and UIConst.AnimWithJumpConfig.Normal.IsNeedMatchAnimTime or JumpConfigData.bIsNeedMatchAnimTime
                if (bIsNeedMatchAnimTime) then
                    local ExitAnimNeedTime = JumpConfigData.OutAnimWithJumpTime or UIManager(self):GetTopUIWidgetOutAnimEndTime()
                    local PreviousUIInAnimTime = PreviousUI.In:GetEndTime()
                    PreviousUI:PlayAnimationForward(PreviousUI.In, PreviousUIInAnimTime / ExitAnimNeedTime)
                else
                    PreviousUI:PlayAnimationForward(PreviousUI.In) 
                end
                PreviousUI:SetUIVisibilityTag(UIConst.CommonHideTagName.UIStackChange, false, UE4.ESlateVisibility.HitTestInvisible)
            end
        end
    end
end

-- UI界面重载Action监听
function BP_UIState_C:ListenForInputAction(ActionName, EventType, bConsume, Callback)
    if EventType < 0 or EventType > 5 then
        GWorld.logger.error(self.WidgetName .. "上绑定的" .. ActionName .. "监听事件 输入类型有问题，请检查拼写！")
        return
    end
    local ActionCallback = function()
        local IsBanned = UIManager(self):CheckIsActionBanned(ActionName)
        if not IsBanned then 
            Callback[2](Callback[1])
        else
            DebugPrint("Tianyi@ Action: " .. ActionName .. " IsBanned")
        end
    end

    self.Overridden.ListenForInputAction(self, ActionName, EventType, bConsume, {Callback[1], ActionCallback})
end

-- 停止监听输入动作
function BP_UIState_C:StopListeningForInputAction(ActionName, EventType)
    if EventType < 0 or EventType > 5 then
        GWorld.logger.error(ActionName .. "的stop监听事件 输入类型有问题，请检查拼写！")
        return
    end
    self.Overridden.StopListeningForInputAction(self, ActionName, EventType)
end

-- UI动作回调
function BP_UIState_C:UIActionCallback(ActionName, KeyEvent)
    DebugPrint("Tianyi@ UIActionCallback ActionName = " .. ActionName .. " KeyEvent = " .. KeyEvent) 

end

--UI状态变化，即使不入栈也会在load时调用一次，用于打开界面时内部刷新
function BP_UIState_C:ReceiveEnterState(StackAction)
    -- self.DelayFuncs = {}
    -- self:NavigateToDefaultWidget(StackAction == 0)
    self.Overridden.ReceiveEnterState(self,StackAction)
    local UIManager = UIManager(self)
    if (UIManager:GetWidgetObjInTopStack() == self) then
        if (rawget(self,"CurrentCameraViewTarget") ~= nil) then
            self:CameraToViewTarget(self.CurrentCameraViewTarget)
        else
            if(StackAction == 0)then
                rawset(self,"OriginalViewTarget",self:GetOwningPlayer():GetViewTarget())
                if(UIManager:StateCount() == 1)then
                    rawset(UIManager,"ViewTargetBeforeOpenSystem",self.OriginalViewTarget)
                end
            end
        end
    end
end

--UI状态变化，即使不入栈也会在unload时调用一次，用于关闭界面时内部清理
function BP_UIState_C:ReceiveExitState(StackAction)
    -- self:RemoveAllDispatcher()
    local UIManager = UIManager(self)
    if (UIManager:GetWidgetObjInTopStack() == self) then
        if (StackAction == 1 and UIManager:StateCount() == 1) then
            --最后一个系统UI关闭，将镜头还给之前的viewtarget
            if(IsValid(rawget(UIManager,"ViewTargetBeforeOpenSystem")))then
                self:CameraToViewTarget(UIManager.ViewTargetBeforeOpenSystem)
            elseif(self:GetOwningPlayer():GetViewTarget() == self:GetOwningPlayer())then
                self:CameraToViewTarget(UGameplayStatics.GetPlayerCharacter(self,0))
            end
        else
            self:SetCurrentCameraViewTarget()
        end
    end
    self.Overridden.ReceiveExitState(self, StackAction)
end

-- 相机到ViewTarget
function BP_UIState_C:CameraToViewTarget(ViewTarget)
    local Controller = self:GetOwningPlayer()
    if (Controller and IsValid(ViewTarget) and Controller:GetViewTarget() ~= ViewTarget) then
        Controller:SetViewTargetWithBlend(ViewTarget, 0, UE4.EViewTargetBlendFunction.VTBlend_Linear, 0, false)
    end
end

-- 恢复相机
function BP_UIState_C:DoRecoverCamera()
    if (IsValid(self.OriginalViewTarget)) then
        self:CameraToViewTarget(self.OriginalViewTarget)
    else
        self:CameraToViewTarget(UGameplayStatics.GetPlayerCharacter(self,0))
    end
end

--统一输入事件
-- 按键按下事件
function BP_UIState_C:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == Const.GamepadSpecialLeft or InKeyName == Const.GamepadSpecialRight then
        if TeamController and TeamController:IsTeamPopupBarOpenInGamepad() then
            DebugPrint(LXYTag, "OnPreviewKeyDown:::组队相关的弹条正在打开...")
            return UIUtils.UnHandled
        end
    end
    if (InKeyName == "Enter" or InKeyName == "Gamepad_Special_Left") then
        local SystemUIConfig = DataMgr.SystemUI[self.ConfigName or self.WidgetName] or {}
        if SystemUIConfig.IsChat then
            EventManager:FireEvent(EventID.OpenChatView, InKeyName)
        end  
    end
    return UIUtils.Unhandled
end

-- 按键释放事件
function BP_UIState_C:OnKeyUp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == Const.GamepadSpecialLeft or InKeyName == Const.GamepadSpecialRight then
        if TeamController and TeamController:IsTeamPopupBarOpenInGamepad() then
            DebugPrint(LXYTag, "OnKeyUp:::组队相关的弹条正在打开...")
            return UIUtils.Unhandled
        end
    end
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == UIConst.GamePadKey.SpecialLeft) then
            local SystemUIConfig = DataMgr.SystemUI[self.ConfigName or self.WidgetName] or {}
            if SystemUIConfig.IsChat then
                IsEventHandled = true
                EventManager:FireEvent(EventID.InterruptChatView)
            end        
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

-- 设置界面当前相机观察的ViewTarget
function BP_UIState_C:SetCurrentCameraViewTarget(ViewTarget)
    if (ViewTarget == nil) then
        rawset(self, "CurrentCameraViewTarget",self:GetOwningPlayer():GetViewTarget())
    else
        rawset(self, "CurrentCameraViewTarget",ViewTarget)
    end
end

-- 获取当前相机观察的ViewTarget
function BP_UIState_C:GetCurrentCameraViewTarget()
    return rawget(self,"CurrentCameraViewTarget")
end

-- 判断UI是否可见
function BP_UIState_C:IsUIVisible()
    return self:IsVisible()
end

-- 原始查找某个子节点
function BP_UIState_C:RawSeek(Nodekey)
    return self:SeekWidgetByName(Nodekey)
end

-- 查找某个子节点
function BP_UIState_C:Seek(Nodekey, WrapType)
    -- 与 RawSeek 的区别就是会对找到的节点之后再用WrapType包装一层
    local WidgetObj = nil
    if (WrapType ~= nil) then
        local Obj = self:SeekWidgetByName(Nodekey)
        WidgetObj = WrapType:New(Obj)
    else
        WidgetObj = self:SeekWidgetByName(Nodekey)
    end
    return WidgetObj
end

-- 设置绝对坐标
function BP_UIState_C:SetWorldPosition(Widget, Pos)
    if (Widget == nil) then
        return
    end
    Widget:SetRenderTranslation(Pos)
end

-- 暂停动画
function BP_UIState_C:PauseAnimByName(AnimName)
    local Animation = self:GetAnimationByName(AnimName)
    if Animation ~= nil then
        self:PauseAnimation(Animation)
    end
end

-- 停止动画
function BP_UIState_C:StopAnimByName(AnimName)
    local Animation = self:GetAnimationByName(AnimName)
    if Animation ~= nil then
        self:StopAnimation(Animation)
    end
end

-- 判断是否正在播放特殊动画
function BP_UIState_C:IsSpecialAnimPlaying(AnimName)
    local Animation = self:GetAnimationByName(AnimName)
    if Animation ~= nil then
        return self:IsAnimationPlaying(Animation)
    end
    return false
end

-- 是否设置输入模式为仅UI
function BP_UIState_C:SetInputUIOnly(IsUIOnly)
    -- local playerCharacter= UGameplayStatics.GetPlayerCharacter(self,0)
    local PreMode, CurMode, CurDeviceType = "PreMode", "CurMode", CommonUtils.GetDeviceTypeByPlatformName(self)
    if (not self.GameInputModeSubsystem) then
        self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    end
    PreMode = self.GameInputModeSubsystem:GetCurrentInputMode()
    local UINameText = self.WidgetName or self.ConfigName
    if (IsUIOnly) then
        local Params = FGameInputModeParams()
        if (self.bIsFocusable) then
            Params.WidgetToFocus = self
        end
        if (CurDeviceType == CommonConst.CLIENT_DEVICE_TYPE.PC) then
            Params.bShowMouseCursor = true
        end
        Params.MouseLockMode = EMouseLockMode.DoNotLock
        self.GameInputModeSubsystem:EnableInputMode(UINameText, EGameInputMode.UI, Params)
    else
        self.GameInputModeSubsystem:DisableInputMode(UINameText)
    end
    CurMode =  self.GameInputModeSubsystem:GetCurrentInputMode()

    if(PreMode ~= CurMode) then
        DebugPrint("UIState Hy@= InputModeChange => PreMode:" .. PreMode .. "," .. "CurMode:" .. CurMode .. " The Reason UIName is " .. UINameText)
        EventManager:FireEvent(EventID.SetInputMode, IsUIOnly)
    end
    --PlayerController.SetIgnoreMoveInput(PlayerController, IsUIOnly)
end

-- 隐藏UI
---@param HideTag string 显隐Tag标签
function BP_UIState_C:Hide(HideTag)
    -- DebugPrint("Hy@ UIState型界面Hide隐藏，名称：", self:GetUIConfigName())
    if (self.IsMarkToRemove) then
        DebugPrint("Hy@==UIState型界面移除当帧需要Hide，直接忽略", self:GetUIConfigName())
        return
    end
    -- if (self.UIStateTag ~= nil) then
    --     UIManager(self):AddUIToStateTagsCluster(self.UIStateTag, self.ConfigName, false)
    -- end
    if self.IgnoreHideTags and CommonUtils.HasValue(self.IgnoreHideTags, HideTag) then
        return
    end

    HideTag = HideTag or UIConst.CommonHideTagName.DefaultTag
    local IsVisibilityChange = self:SetUIVisibilityTag(HideTag, true)
    if (IsVisibilityChange) then
        DebugPrint("HY@ UI Which Named " .. self:GetUIConfigName() .. " Is desired to Hide, The Tag is " .. HideTag) 
        -- 暂停声音
        AudioManager(self):PauseObjectAllEvent(self, true)
        if (self.IsInUIMode) then
            self:SetInputUIOnly(false)
        end
        if (self.bIsPauseWorldRendering) then
            UIManager(self):SetPauseWorldRenderingSwitch(self.ConfigName, false)
        end
        if (self.IsUIPopUp == true and HideTag ~= UIConst.CommonHideTagName.UIStackChange) then
            UIManager(self):OpenResidentUI(self.WidgetName)
        end
        if self.IsStopGame then
            self:UISetGamePaused(self.WidgetName or self.ConfigName,false)
        end
        if self.KeyboardSetName and self.IsBanningAction then 
            UIManager(self):SetBannedActionCallback(self.KeyboardSetName, false, self:GetName())
            self.IsBanningAction = nil
        end
        self:OnHide(HideTag)
    end
end

function BP_UIState_C:OnHide(HideTag)
    -- 提供给子类重写
end

-- 显示UI
---@param ShowTag string Tag标签
function BP_UIState_C:Show(ShowTag)
    -- DebugPrint("Hy@ UIState型界面Show重新显示，名称：", self:GetUIConfigName())
    if (self.IsMarkToRemove) then
        DebugPrint("Hy@==UIState型界面移除当帧需要Show，直接忽略", self:GetUIConfigName())
        return
    end
    -- if (self.UIStateTag ~= nil) then
    --     UIManager(self):AddUIToStateTagsCluster(self.UIStateTag, self.ConfigName, true)
    -- end

    ShowTag = ShowTag or UIConst.CommonHideTagName.DefaultTag
    local IsVisibilityChange = self:SetUIVisibilityTag(ShowTag, false)
    if (IsVisibilityChange) then
        DebugPrint("HY@ UI Which Named " .. self:GetUIConfigName() .. " is desired to Show, The Tag is " .. ShowTag) 
        -- 恢复声音
        AudioManager(self):PauseObjectAllEvent(self, false)
        if (self.IsInUIMode) then
            self:SetInputUIOnly(true)
        end
        if (self.bIsPauseWorldRendering) then
            UIManager(self):SetPauseWorldRenderingSwitch(self.ConfigName, true)
        end
        if (self.IsUIPopUp == true and ShowTag ~= UIConst.CommonHideTagName.UIStackChange) then
            UIManager(self):CloseResidentUI(self.WidgetName)
        end
        if self.IsStopGame then
            self:UISetGamePaused(self.WidgetName or self.ConfigName,true)
        end
        if self.KeyboardSetName and not self.IsBanningAction then 
            UIManager(self):SetBannedActionCallback(self.KeyboardSetName, true, self:GetName())
            self.IsBanningAction = true
        end
        if self.GlobalGameUITag then 
            local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
            GameInstance:SetGlobalGameUITag(self.GlobalGameUITag)
        end
        self:OnShow(ShowTag)
    end
end

function BP_UIState_C:OnShow(ShowTag)
    -- 提供给子类重写
end

-- 用于创建完成之后添加到某些节点或者Viewport上面
function BP_UIState_C:Created()
    if (not UIConst.bUseHierarchicalLayer) then
        self.Overridden.Created(self)
        self:OnCreated()
        return
    end

    local SystemUIConfig = DataMgr.SystemUI[self:GetUIConfigName()] or UIConst.AllUIConfig[self:GetUIConfigName()]
    if SystemUIConfig ~= nil then
        self.HierarchicalLayerTag = SystemUIConfig.HierarchicalLayerTag
    end
    DebugPrint("Hy@ UIState型界面创建 Created，名称：", self:GetUIConfigName(), " HierarchicalLayerTag is ", self.HierarchicalLayerTag)
    if (self.HierarchicalLayerTag == UIConst.HierarchicalLayer[2]) then
        -- 战斗UI层（HUD层）
        self:AddWidgetToHierarchicalLayer(UIConst.HierarchicalLayer[2])
    elseif (self.HierarchicalLayerTag == UIConst.HierarchicalLayer[4]) then
        -- 系统UI层
        self:AddWidgetToHierarchicalLayer(UIConst.HierarchicalLayer[4])
    else
        self.Overridden.Created(self)
    end
    self:OnCreated()
end

function BP_UIState_C:OnCreated()
    -- 提供给子类重写
end

-- 用于销毁之前做一些清理工作
function BP_UIState_C:Destroyed()
    if (not UIConst.bUseHierarchicalLayer) then
        self.Overridden.Destroyed(self)
        self:OnDestroyed()
        return
    end

    if (self.HierarchicalLayerTag == UIConst.HierarchicalLayer[4]) then
        -- 系统UI层
        self.Overridden.Destroyed(self)
    else
        self.Overridden.Destroyed(self)
    end
    self:OnDestroyed()
end

function BP_UIState_C:OnDestroyed()
    -- 提供给子类重写
end

-- 获取层级节点Widget
---@param LayerName string 层级节点名称
function BP_UIState_C:GetHierarchicalLayerWidget(LayerName)
    local HierarchicalWidget = UIManager(self):GetUIObj("SceneStartUI")
    if (HierarchicalWidget == nil) then
        return nil
    end
    return HierarchicalWidget[LayerName.."_Overlay"]
end

-- 添加到层级节点
---@param LayerName string 层级节点名称
function BP_UIState_C:AddWidgetToHierarchicalLayer(LayerName)
    local LayerNodeWidget = self:GetHierarchicalLayerWidget(LayerName)
    if (LayerNodeWidget) then
        local Slot = LayerNodeWidget:AddChildToOverlay(self)
        Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
        Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    end
    return LayerNodeWidget
end

-- 入场动画开始
function BP_UIState_C:OnInAnimationStarted()
    local SystemUIConfig = DataMgr.SystemUI[self:GetUIConfigName()]
    -- In动画播放开始的时候隐藏Entity
    self:DealWithBattleUnitVisibility(SystemUIConfig.IsHideBattleUnit, true, "AnimStart")
end

-- 入场动画结束
function BP_UIState_C:OnInAnimationFinished()
    local SystemUIConfig = DataMgr.SystemUI[self:GetUIConfigName()]
    -- In动画播放结束的时候隐藏Entity
    self:DealWithBattleUnitVisibility(SystemUIConfig.IsHideBattleUnit, true, "AnimFinished")
end

-- 退场动画开始
function BP_UIState_C:OnOutAnimationStarted()        
    -- 是否需要播放主页面的In动效
    UIUtils.CheckAndPlayBattleMainInAnim(self:GetUIConfigName())

    -- 判断是否需要手动执行单位显示逻辑
    local SystemUIConfig = DataMgr.SystemUI[self:GetUIConfigName()]
    -- Out动画播放开始的时候显示出Entity
    self:DealWithBattleUnitVisibility(SystemUIConfig.IsHideBattleUnit, false, "AnimStart")
end

-- 退场动画结束
function BP_UIState_C:OnOutAnimationFinished()
    local SystemUIConfig = DataMgr.SystemUI[self:GetUIConfigName()]
    -- Out动画播放结束的时候显示Entity
    self:DealWithBattleUnitVisibility(SystemUIConfig.IsHideBattleUnit, false, "AnimFinished")
end

-- 系统跳转开始前回调（暂时不需要用到）
-- function BP_UIState_C:OnStartWhenSystemJump(StartValue)
--     DebugPrint("Hy@ UIState型界面系统跳转开始前回调 OnStartWhenSystemJump，名称：", self:GetUIConfigName(), " StartValue:", StartValue)
-- end

-- 系统跳转时更新UI状态
function BP_UIState_C:OnUpdateWhenSystemJump(CurValue)
    DebugPrint("Hy@ UIState型界面系统跳转过程中回调 OnUpdateWhenSystemJump，名称：", self:GetUIConfigName(), " CurValue:", CurValue)
    self:SetRenderOpacity(CurValue)
end

-- 系统跳转完成后回调
function BP_UIState_C:OnCompleteAfterSystemJump(EndValue)
    DebugPrint("Hy@ UIState型界面系统跳转完成后回调 OnCompleteAfterSystemJump，名称：", self:GetUIConfigName(), " EndValue:", EndValue)
    self:SetRenderOpacity(EndValue)
    if (self.SelfWidgetParamForStackChange) then
        self:SetVisibility(self.SelfWidgetParamForStackChange["DesireVisibilty"] or UE4.ESlateVisibility.Collapsed)
    else
        self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

-- 系统跳转取消后回调
function BP_UIState_C:OnCancelWhenSystemJump()
    DebugPrint("Hy@ UIState型界面系统跳转取消后回调 OnCancelWhenSystemJump，名称：", self:GetUIConfigName())
    if (self.SelfWidgetParamForStackChange) then
        self:SetRenderOpacity(self.SelfWidgetParamForStackChange["RenderOpacityBeforeJump"] or 1.0)
    else
        self:SetRenderOpacity(1.0)
    end
end

-- 处理战斗单位显示与隐藏
function BP_UIState_C:DealWithBattleUnitVisibility(HideBattleUnitType, bHideOrShow, AnimType)
    self.IsSetEntitysVisibilityWithAnim = bHideOrShow
    if (HideBattleUnitType == UIConst.EnumHideBattleUnitStyle.DelayHideAll or HideBattleUnitType == UIConst.EnumHideBattleUnitStyle.DelayHideAllExceptSelf) then
        if (AnimType == "AnimFinished") then
            UIManager(self):SetEntitiesVisibility(self:GetUIConfigName(), (HideBattleUnitType - 12) == UIConst.EnumHideBattleUnitStyle.NormalShowAndHideAll,
                    (HideBattleUnitType - 12) == UIConst.EnumHideBattleUnitStyle.NormalShowAndHideAllExceptSelf, bHideOrShow)
        end
    elseif (HideBattleUnitType == UIConst.EnumHideBattleUnitStyle.InstantShowAll or HideBattleUnitType == UIConst.EnumHideBattleUnitStyle.InstantShowAllExceptSelf) then
        if (AnimType == "AnimStart") then
            UIManager(self):SetEntitiesVisibility(self:GetUIConfigName(), (HideBattleUnitType - 10) == UIConst.EnumHideBattleUnitStyle.NormalShowAndHideAll,
                    (HideBattleUnitType - 10) == UIConst.EnumHideBattleUnitStyle.NormalShowAndHideAllExceptSelf, bHideOrShow)
        end
    end
end

-- 标记为移除状态（最好在播放退场动画之前调用一下）
---@param bIsNeedBlockInput boolean 是否需要阻断输入，默认不阻断
function BP_UIState_C:MarkToRemove(bIsNeedBlockInput)
    self.IsMarkToRemove = true
    if (bIsNeedBlockInput) then
        -- 界面真正关闭的时候会把输入阻断恢复
        self:BlockAllUIInput(true,"SP_DisplayOnly")
    end
end

-- 是否处于正在被移除状态
function BP_UIState_C:IsBeingRemoveState()
    if (self.IsMarkToRemove or self.IsBeginToClose) then
        return true
    end
    return false
end

-- 关闭UI
function BP_UIState_C:Close()
    if (not self) or (not IsValid(self)) then
        return
    end

    if (not self.IsInit) then
        -- 没有完全初始化之前不允许关闭
        -- local ErrorLog = string.format("::Error::  BP_UIState_C=Close 有系统界面移除异常，没有关闭成功，系统名称：%s", self:GetUIConfigName())
        -- UIManager(self):ShowUIError(UIConst.ErrorCategory.BasicModule, ErrorLog)
        DebugPrint(ErrorTag, "::Error::  BP_UIState_C=Close 有系统界面移除异常，可能没有关闭成功，需要检查一下，系统名称：", self:GetUIConfigName())
        return
    end

    DebugPrint("Hy@ UIState型界面关闭 Close，名称：", self:GetUIConfigName())
    self.IsBeginToClose = true

    if (self.Auto_Out) then
        -- 自动播放退出动画
        self:BindToAnimationFinished(self.Auto_Out, {self, self.RealClose})
        -- EMUIAnimationSubsystem:EMPlayAnimation(self, self.Auto_Out)
        self:PlayAnimationForward(self.Auto_Out)
        --self:BlockAllUIInput(true,"SP_DisplayOnly")
    else
        self:RealClose()
    end
end

-- 真正关闭UI
function BP_UIState_C:RealClose()
    -- DebugPrint("Hy@ UIState型界面关闭 RealClose", self:GetUIConfigName())
    -- AudioManager(self):StopObjectAllSound(self)
    --self:BlockAllUIInput(false)
    self.IsMarkToRemove = true                                -- 标记为移除状态（最好在播放退场动画之前就设置）
    if self.GamePausedHandle then 
        self:RemoveTimer(self.GamePausedHandle) 
        self.GamePausedHandle = nil 
    end

    self:UnbindFromAnimationFinished(self.Auto_Out, {self, self.RealClose})
    if self.KeyboardSetName and self.IsBanningAction then 
        UIManager(self):SetBannedActionCallback(self.KeyboardSetName, false, self:GetName())
        self.IsBanningAction = nil
    end

    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self) or GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    if (UIManager ~= nil) then
        -- 关闭的时候查询一下当前是不是栈顶界面
        self.IsNeedSearchInStack = UIManager:GetCurrentState() ~= self
        UIManager:UnLoadUI(self.ConfigName, self.WidgetName)
    end
    self:OnEndClose()
end

-- 关闭UI结束回调（给外部重写用）
function BP_UIState_C:OnEndClose()
    -- 提供给外部重写
end

-- 销毁UI,若界面有自己额外创建的对象,则应该在销毁玩自己对象之后再调用此函数(该接口用于直接继承自UIState, 没有走LoadUI接口，并且又加入Manager管理的界面使用，其余的应使用Close方法)
function BP_UIState_C:DestroyObject()
    self.Overridden.Destroyed(self)
end

-- 真正销毁UI
function BP_UIState_C:EMDestruct()
    -- DebugPrint("Hy@ UIState型界面析构 Destruct，名称：", self:GetUIConfigName())

    -- 迁移到了C++(EMDestruct_CPP)之中
    -- AudioManager(self):PauseObjectAllEvent(self, false)
    -- AudioManager(self):StopObjectAllSound(self)

    -- 将初始化变量设置为false，防止执行多次销毁逻辑
    rawset(self, "IsInit", false)

    if (type(self.EMDestruct_CPP) == "function") then
        self:EMDestruct_CPP()
    else
        DebugPrint(ErrorTag, "疑似小部件析构调用了UIState的EMDestruct, 蓝图类型是EMUserWidget, 脚本继承自BP_EMUserWidget_C可以更轻量化, 请检查一下是否真的需要这样写!!!，名称: ", self:GetUIConfigName())
        -- 此处Return意味着脚本继承了UIState但是蓝图用的是EMUserWidget类型。理论上下面的逻辑都不需要走，因此在这里只做一些清理工作便直接返回
        self:ClearScriptRegister()
        return
    end

    -- 给Lua内存检测计数用（后面会删除）
    if rawget(self, "bIsFrequentlyUI") then
        self.IsDestroied = true
    end
    if self.IsInUIMode then
        self:SetInputUIOnly(false)
    end
    if rawget(self, "bIsPauseWorldRendering") then
        UIManager(self):SetPauseWorldRenderingSwitch(self.ConfigName, false)
    end
    if rawget(self, "IsStopGame") then
       self:UISetGamePaused(self.WidgetName or self.ConfigName,false)
       self.IsStopGame=nil
    end
    if rawget(self, "IsSetEntitysVisibilityWithAnim") then
        -- 通过动画设置Entity可见性，但是没有通过动画恢复的在这里恢复一下
        UIManager(self):SetEntitiesVisibility(self:GetUIConfigName(), true, true, false)
    end

    --- 迁移到了C++(EMDestruct_CPP)之中
    -- if rawget(self, "GlobalGameUITag") then
    --     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    --     local GlobalTag=GameInstance:GetGlobalGameUITag()
    --     if GlobalTag==self.GlobalGameUITag then
    --         local allUI=UIManager(self).UIInstances:ToTable()
    --         local TopUI=nil
    --         local MaxZOrder=nil
    --         for _,widget in pairs(allUI) do
    --             if widget:IsInViewport() and widget.GlobalGameUITag and self~=widget then
    --                 if MaxZOrder==nil or MaxZOrder<widget:GetZOrder() then
    --                     MaxZOrder=widget:GetZOrder()
    --                     TopUI=widget
    --                 end
    --             end
    --         end
    --         if TopUI then
    --             GameInstance:SetGlobalGameUITag(TopUI.GlobalGameUITag)
    --         else
    --             GameInstance:SetGlobalGameUITag("")
    --         end
    --     end
    -- end

    self:ClearScriptRegister()
end

function BP_UIState_C:Destruct()
    -- 目前仅仅是为了避免调用Super的时候报错，没有实际意义，子类完全可以不调用（所有通用销毁逻辑在EMDestruct之中）
    -- DebugPrint("UIState型界面析构 Destruct, 父类Destruct逻辑已经迁移, 子类可以不需要再调用Super方法 UIName is", self:GetUIConfigName())
    -- self.Overridden.Destruct(self)
end

-- 统计性能数据用，判断是否是常用的一些UI
function BP_UIState_C:CheckIsFrequentlyUI()
    return self.bIsFrequentlyUI
end

-- 统计性能数据用，设置是否是常用的UI
function BP_UIState_C:SetIsFrequentlyUI(bIsFrequentlyUI)
    self.bIsFrequentlyUI = bIsFrequentlyUI
end

-- 在UI控件Construct阶段调用，可以设置暂停游戏的延迟时间，不设置则默认0.01秒后
function BP_UIState_C:SetGamePausedDelay(DelayTime) 
    self.GamePausedDelayTime = DelayTime
end

--如果UI需要切换输入模式并且暂停游戏，需要延迟暂停，否则按键输入状态在暂停后无法清空
function BP_UIState_C:UISetGamePaused(UIName,IsPause)
    if UIName==nil then
        return
    end
    if IsStandAlone(self) then
        local GameMode=UE4.UGameplayStatics.GetGameMode(self)
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        if UIName == "MenuLevel" and GameState and GameState.GameModeType== "SoloTreasure" then
            DebugPrint("UISetGamePaused: SoloTreasure模式下ESC不暂停游戏")
            return
        end
        if GameMode and GameMode.SetGamePaused then
            GameMode:SetGamePaused(UIName, IsPause)
        end
        UIManager(self):SetUIPauseGame(UIName, IsPause)
        EventManager:FireEvent(EventID.OnUIPauseGame)
    end
    -- local function SetGamePause()
    --     if IsStandAlone(self) then
    --         local GameMode=UE4.UGameplayStatics.GetGameMode(self)
    --         if GameMode and GameMode.SetGamePaused then
    --             GameMode:SetGamePaused(UIName,IsPause)
    --         end
    --     end
    -- end
    -- if IsPause then
    --     self.GamePausedHandle = self:AddTimer(self.GamePausedDelayTime or 0.01,SetGamePause)
    -- else SetGamePause()
    -- end
end


--设置全部UI不可交互（仅UI输入模式生效）
---@param Reason string 该接口默认会在三秒后生成一个ReconnectUI，表示等待禁止输入过久，如果不想要这个东西，需要传Reason为"SP_DisplayOnly"
function BP_UIState_C:BlockAllUIInput(bBlock, Reason)
    if NEW_BlockAllUIInput then
        if self.WidgetName == "LoadingReconnect" then return end
        local LoadingReconnectUi = UIManager():GetUIObj("LoadingReconnect")
        if not bBlock then
            if LoadingReconnectUi and LoadingReconnectUi.bDisplayOnly then
                LoadingReconnectUi:Close()
            end
            if self:IsExistTimer(self.ReconnectUITimer) then
                self:RemoveTimer(self.ReconnectUITimer)
            end
        else
            if Reason~="SP_DisplayOnly" then
                if not LoadingReconnectUi then
                    if self:IsExistTimer(self.ReconnectUITimer) then
                        self:RemoveTimer(self.ReconnectUITimer)
                    end
                    local _,TimerKey = self:AddTimer(UIConst.BlockingTime, function()
                        if not UIManager():GetUIObj("LoadingReconnect") then
                            UIManager():LoadUINew("LoadingReconnect",true)
                        end
                    end)
                    self.ReconnectUITimer = TimerKey
                end
            end
        end
    end
    if Reason == "SP_DisplayOnly" then
        Reason = nil
    end
    Reason = Reason or self.WidgetName
    DebugPrint(WarningTag, string.format("%s:BlockAllUIInput(%s, %s)",self.WidgetName, bBlock, Reason))
    self:BlockAllUIInput_CPP(bBlock, Reason or self.WidgetName)
end

function BP_UIState_C:OnFocusReceived(MyGeometry, InFocusEvent)
    -- if (CommonUtils.GetDeviceTypeByPlatformName(self) ~= "PC") then
    --     return UE4.UWidgetBlueprintLibrary.Unhandled()
    -- end
    DebugPrint("BP_UIState_C OnFocusReceived, UIName is", self:GetUIConfigName())
    -- if (self.GameInputModeSubsystem) then     --接收focus的时候不一定需要强制刷新一遍当前设备类型，业务有需要的地方按需调用吧
    --     self:OnUpdateUIStyleByInputTypeChange(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    -- end
    return UIUtils.Handled
end

-- 判断是否拥有焦点
function BP_UIState_C:HasAnyFocus()
    return self:HasAnyUserFocus() or self:HasFocusedDescendants()
end

-- 导航到默认Widget
function BP_UIState_C:NavigateToDefaultWidget(bIsDelaySet)
    if (not self.GameInputModeSubsystem) then
        self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    end
    local function SetToDesiredFocusWidget()
        if (self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad) then
            local DefaultFocusWidget = self:GetDesiredFocusTarget()
            if (DefaultFocusWidget ~= nil) then
                DebugPrint("BP_UIState_C OnFocusReceived, DefaultFocusWidget is", DefaultFocusWidget:GetName())
                DefaultFocusWidget:SetFocus()
            end
        end
    end
    if (bIsDelaySet) then
        self:AddTimer(0.1, SetToDesiredFocusWidget, false, 0, "SetToDesiredFocusWidget")
    else
        SetToDesiredFocusWidget()
    end
end

---通过SystemUI和WidgetUI表的参数配置 “IsAllowEscape:1” 可以实现默认的Esc键关闭界面
function BP_UIState_C:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == Const.GamepadSpecialLeft or InKeyName == Const.GamepadSpecialRight then
        if TeamController and TeamController:IsTeamPopupBarOpenInGamepad() then
            DebugPrint(LXYTag, "OnKeyDown:::组队相关的弹条正在打开...")
            return UIUtils.Unhandled
        end
    end
    if (InKeyName == "Escape" or InKeyName == "Android_Back") and self.IsAllowEscape then
        if not self.IsBeginToClose and self.IsInit then
            self:Close()
        end
        return UIUtils.Handled
    end
    return UIUtils.Unhandled
end

-- 隐藏所有子节点
function BP_UIState_C:HideAllChildrenNode(ParentNode, IsExcludeSelf, bHide)
    local VisiblityOp = bHide and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.SelfHitTestInvisible
    local AllChildren = ParentNode:GetAllChildren()
    for i=1,AllChildren:Length() do
        local ChildItem = AllChildren:GetRef(i)
        ChildItem:SetVisibility(VisiblityOp)
    end
    if (IsExcludeSelf) then
        ParentNode:SetVisibility(VisiblityOp)
    end
end

-- 隐藏除自身外所有界面
function BP_UIState_C:HideAllUIWithOutSelf(IsHide, Tag, bRadio)
    local ExceptUIName = TSet(FName)
    ExceptUIName:Add(self.WidgetName or self.ConfigName)
    UIManager(self):HideAllUI_EX(ExceptUIName, IsHide, Tag, bRadio)
end

-- 播放UI音效
function BP_UIState_C:SequenceEvent_PlayUISound(EventPath, EventKey)
    AudioManager(self):PlayUISound(self, EventPath, nil, nil)
end

-- 播完Auto_In之后立刻关闭（立刻播Auto_Out)
function BP_UIState_C:CloseAfterAutoIn()
    if (self.Auto_In ~= nil) then
        self:BindToAnimationFinished(self.Auto_In, {self, self.Close})
    end
end

--@region TimerOverride 覆写TimerMgr的Timer操作方法
--- 绝大多数情况下,系统面板的UI的定时器默认是不受时间膨胀影响的，所以UI默认IsRealTime为true
-- function BP_UIState_C:AddTimer(Interval, Func, IsLoop, Delay, Key, IsRealTime, ...)
--     if IsRealTime == nil then IsRealTime = true end
--     return BP_UIState_C.Super.AddTimer(self, Interval, Func, IsLoop, Delay, Key, IsRealTime, UE4.ETickingGroup.TG_EndPhysics, ...)
-- end
--@endregion TimerOverride

return BP_UIState_C
