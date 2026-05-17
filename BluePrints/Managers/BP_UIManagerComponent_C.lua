--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local StrLib             = require "BluePrints.Common.DataStructure"
local Deque              = StrLib.Deque
local Stack              = StrLib.Stack
local EMCache = require "EMCache.EMCache"
local GMVariable = require "BluePrints.UI.GMInterface.GMVariable"
local CommonUtils = require "Utils.CommonUtils"
local GameFlowUtils = require "Utils.GameFlowUtils"
-- UIConst = require "BluePrints.UI.UIConst"

---@class BP_UIManagerComponent_C:UUIManagerComponent
local BP_UIManagerComponent_C = Class({"BluePrints.Common.TimerMgr"})

-- 界面管理器状态模式集合
-- nil: 普通模式
-- ExclusiveMode: 当前页面独立模式, 其他页面加载时候会先默认隐藏
-- ConditionMode：条件检测模式
-- StoryMode：剧情模式
-- SkillFeatureMode：当前页面独占模式，与1的区别是其他页面加载时候会阻止创建而非创建了再隐藏，非必要情况不建议使用
-- GMMode：GM下的沉浸模式
local EUIManageLoadStateTags = {
    NormalMode = "Normal",
    StoryMode = Const.TalkHideTag,
    SkillFeatureMode = Const.SkillFeatureHideTag,
    GMMode = "GM",
}

-- 界面显示状态模式集合
-- StateTag nil: 普通模式
-- ExclusiveMode: 当前页面独立模式, 其他页面加载时候会先默认隐藏
-- ConditionMode：条件检测模式
-- BlockedMode：  阻塞模式
local ENormalModeSubState = {
	ExclusiveMode = "Exclusive",
	ConditionMode = "Condition",
    BlockedMode = "Blocked",
}

function BP_UIManagerComponent_C:Initialize(Initializer)
    self.UniqueCount = {}                                   -- 计数标识符
    self.AllNotRenderWorldUI = {}                           -- 不用绘制场景的所有UI列表
    self.WidgetComponentList = {}                           -- 所有WidgetComponent
    self.WaitToTriggerTipsInfo = {}                         -- 等待触发提示信息
    self.HideByStateTagUIList = {}                          -- 被UIManager不同状态影响的UI列表
    self.AllUIStateTagsCluster = {}                         -- 所有界面状态集合
    self.PopUpUIWidgetRecord = {}                           -- PopUp设置的状态位
    self.ShortCutHudKeys = {}                               -- 快捷键设置
    self.BanActionCallbackMap = {}                          -- 禁止操作回调
    self.GMShowUIOnly = nil                                 -- 是否是GM模式显示UI
    self.ShowInStoryUINames = {}                            -- 剧情模式下显示的UI
    self.AllUIActorCameraHelper = {}                        -- 所有界面Actor的辅助Actor(主要用于相机)
    self.AllUINpcActor = {}                                 -- 当前World之中所有UI上显示的Actor
    self.CacheModifyHiddenEntity = {}                       -- TODO后续需要删除，用Tag去隐藏
    self.IsMenuAnchorOpen = false                           -- 菜单锚点是否打开
    self.GameInputModeSubsystem = nil                       -- 游戏输入模式子系统
    self.FlowList = {}                                      -- 所有打开的Flow

    self.BlockingReasons = {}
    --region 异步加载界面相关的上下文
    self.AsyncLoadHandlers = {}
    self.AsyncGetUIContexts = {}
    self.AsyncUnloadFlags = {}
    --endregion
    -- 系统打开互斥控制
    self.SystemOpenFrameFlag = 0                           -- 记录系统打开的帧，防止同一帧打开多个系统
    
    self:InitAllContainerData()
    self:InitUIConfigBySetting()
end

--region 界面初始化相关
-- 初始化UI配置
function BP_UIManagerComponent_C:InitUIConfigBySetting()
	if(EMCache)then
		local GMInfo = EMCache:Get("GMInfo")
        if (GMInfo and GMInfo.DisableScreenMessages) then
            UE4.UKismetSystemLibrary.ExecuteConsoleCommand(nil,"DisableAllScreenMessages")
        else
            UE4.UKismetSystemLibrary.ExecuteConsoleCommand(nil,"EnableAllScreenMessages")
        end
	end
end

-- 初始化所有队列数据
function BP_UIManagerComponent_C:InitAllContainerData()
    self.UILoadingDeque = Deque.New()                       -- 界面加载队列
    self.UIJumpToDeque = Deque.New()                        -- 跳转逻辑专用

    self._CommonToastQueue = Deque.New()                    -- 通用界面内部Toast
    self._CommonToastTimer = "UIManager_CommonToastTimer"
    self._CommonToastSet = {}

    self._StoryToastQueue = Deque.New()                     -- 剧情专用Toast
    self._StoryToastTimer = "UIManager_StoryToastTimer"
    self._StoryToastSet = {}

    self.UIManagerModeTagsStack = Stack.New()                   -- UIManager的状态模式栈
    self:PushCurrentModeStateTag(EUIManageLoadStateTags.NormalMode)
end

-- 初始化UI状态
function BP_UIManagerComponent_C:InitUIStates()
    self:_InitGameDPI()
    local SceneManager = GWorld.GameInstance:GetSceneManager()
    local IsPIE = UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(GWorld.GameInstance)
    if not IsPIE and not UUCloudGameInstanceSubsystem.IsCloudGame() then
        -- local SceneManager = GWorld.GameInstance:GetSceneManager()
        if SceneManager then
            SceneManager:SetWindowDeactivatedEventDelegate()  -- 点击游戏画面外最小化相关
            SceneManager:SetOnWindowResizedDelegate()  -- 窗口改变大小相关
            SceneManager:SetOnWindowMovedDelegate() -- 窗口移动位置相关
        end
    else
        -- 在PIE模式下或者云游戏模式下，设置UI的DPI基准值
        if SceneManager then
            local UInputSettings = UE4.UInputSettings.GetInputSettings()
            local bPCCloudGame = UE4.UUCloudGameInstanceSubsystem.IsPCCloudGame()
            if (bPCCloudGame) then
                -- PC云游戏采用PC的DPI基准值
                SceneManager:UpdateUIDPIStandValue(UIConst.DPIBaseOnSize.PC.X, UIConst.DPIBaseOnSize.PC.Y)
            elseif (UInputSettings.GetInputSettings().bUseMouseForTouch) then
                -- 非PC云游戏，且使用触控交互方式，采用移动端的DPI基准值
                SceneManager:UpdateUIDPIStandValue(UIConst.DPIBaseOnSize.Mobile.X, UIConst.DPIBaseOnSize.Mobile.Y)
            else
                -- 其他情况采用PC的DPI基准值
                SceneManager:UpdateUIDPIStandValue(UIConst.DPIBaseOnSize.PC.X, UIConst.DPIBaseOnSize.PC.Y)
            end
        end
    end
    self.Overridden.InitUIStates(self)
    UE4.UMainBar.SetIsForbidenShowBloodUI(false)
end

-- 预加载UI
function BP_UIManagerComponent_C:PreloadUI()
    local bMobile = (CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile")
    for UIName, UIData in pairs(DataMgr.SystemUI) do
        if UIData.IsPreloadBP then
            local Class = nil
            if bMobile then
                Class = LoadClass(UIData.MobileBPPath)
            else
                Class = LoadClass(UIData.PCBPPath)
            end
            if Class then
                self.PreLoadUIStates:Add(UIName, Class)
            end
        end
    end
    for UIName, UIData in pairs(DataMgr.WidgetUI) do
        if UIData.PreCreateNum and  UIData.PreCreateNum > 0 then
            local Class = nil
            if bMobile then
                Class = LoadClass(UIData.MobileBPPath)
            else
                Class = LoadClass(UIData.BPPath)
            end
            if Class then
                self:PreCreateWidgetUI(UIName, Class, UIData.PreCreateNum)
            end
        end
    end
end

-- 初始化游戏DPI相关设置
function BP_UIManagerComponent_C:_InitGameDPI()
    local HUDSizeConf = DataMgr.Option["HUDSize"]
    if not (HUDSizeConf) then return end
    local HUDSizeVal = EMCache:Get(HUDSizeConf.EMCacheName)
    if not (HUDSizeVal) or HUDSizeVal == 0 then 
        for i,ValStr in ipairs(HUDSizeConf.UnFoldText) do
            if i == math.floor(tonumber(HUDSizeConf.DefaultValue)) then 
                HUDSizeVal =  tonumber(table.pack(string.gsub(ValStr,"%%",""))[1])*0.01
				EMCache:Set(HUDSizeConf.EMCacheName,HUDSizeVal)
                break
            end
        end
    end
    UE.UUIFunctionLibrary.SetGameDPI(HUDSizeVal)
end

-- function BP_UIManagerComponent_C:ReceiveBeginPlay()
-- end

--function BP_UIManagerComponent_C:ReceiveEndPlay()
--end

-- function BP_UIManagerComponent_C:ReceiveTick(DeltaSeconds)
-- end

--endregion

--region 非UIState类型界面创建相关接口
-- 添加WidgetComponent到列表
function BP_UIManagerComponent_C:AddWidgetComponentToList(ActorEid, WidgetName, WidgetComp)
    if not self.WidgetComponentList[ActorEid] then
        self.WidgetComponentList[ActorEid] = {}
    end
    self.WidgetComponentList[ActorEid][WidgetName] = WidgetComp
    EventManager:FireEvent(EventID.OnAddWidgetComponent, {WidgetName = WidgetName, WidgetComponent = WidgetComp})
    if self:CheckUIMgrIsInSpecialState()==EUIManageLoadStateTags.GMMode then
        if WidgetName ~= self.GMShowUIOnly then
            if (type(WidgetComp.SetWidgetHiddenByTag) == "function") then
                WidgetComp:SetWidgetHiddenByTag(true, UIConst.CommonHideTagName.GMShowUIOnly)
            else
                local Widget = WidgetComp:GetWidget()
                if Widget then
                    Widget:Hide(UIConst.CommonHideTagName.GMShowUIOnly)
                end
            end
        end
    end
    if self.HideWidgetComponentTags then
        local TempWidgetComponent = {
            [ActorEid] = {
                [WidgetName] = WidgetComp
            }
        }
        for Tag, Comps in pairs(self.HideWidgetComponentTags) do
            for CompName, Value in pairs(Comps) do
                self:PrivateHideAllComponentUI(Value, Tag, CompName, TempWidgetComponent)
            end
        end
    end
end

-- 从列表中移除WidgetComponent
function BP_UIManagerComponent_C:RemoveWidgetComponentToList(ActorEid, WidgetName)
    if (self.WidgetComponentList[ActorEid] ~= nil) then
        self.WidgetComponentList[ActorEid][WidgetName] = nil
        if IsEmptyTable(self.WidgetComponentList[ActorEid]) then
            self.WidgetComponentList[ActorEid] = nil
        end
    end
end

-- 创建并附加到父级Widget
function BP_UIManagerComponent_C:CreateAndAttachToParentWidget(BPClassPath, UIName, ParentWidget, IsWrapChildWithPanel)
    local UIConfig = UIConst.AllUIConfig[UIName] or {}
	local ExistUIObj = self:GetUI(UIName)
    if (ExistUIObj ~= nil and not UIConfig["allowmulti"]) then
        return ExistUIObj
    end
    if (BPClassPath == nil) then
        print(self:GetLogMask(), "The UI Whitch Named "..UIName.."BPClass is nil !!!!!!!")
        return
    end
    local UMG_Class = nil
    if type(BPClassPath) == "string" then
        UMG_Class = UE4.UClass.Load(BPClassPath)
    elseif type(BPClassPath) == "userdata" then
        UMG_Class = BPClassPath
    elseif type(BPClassPath) == "table" then
        UMG_Class = BPClassPath
    else
        print(self:GetLogMask(), "BPClassPath is not valid")
        return
    end
    local UIObj = self.Overridden.CreateAndAttachToParentWidget(self, UMG_Class, UIName, ParentWidget, IsWrapChildWithPanel)
    return UIObj
end

-- 请用self:CreateWidgetNew(UIName)  这里的self是UIState
---@param UIName string 界面的名字
function BP_UIManagerComponent_C:_CreateWidgetNew(UIName)
    local WidgetUIConfig = DataMgr.WidgetUI[UIName]
    assert(WidgetUIConfig, "UI:" .. UIName .. "不在WidgetUI表中")
    
    local PlatformName, BPClassPath = CommonUtils.GetDeviceTypeByPlatformName(self), nil
    if (PlatformName == CommonConst.CLIENT_DEVICE_TYPE.PC) then
        BPClassPath = WidgetUIConfig.BPPath
    elseif (PlatformName == CommonConst.CLIENT_DEVICE_TYPE.MOBILE) then
        BPClassPath =  WidgetUIConfig.MobileBPPath or WidgetUIConfig.BPPath
    else
        -- 默认都先用PC的
        BPClassPath = WidgetUIConfig.BPPath
    end
    local bIsAddToCachePool = UIConst.OptimizeSwitch[PlatformName].UI_ADD_IN_CACHE and WidgetUIConfig.IsAddToCachePool
    local Widget = self:CreateWidget(BPClassPath, WidgetUIConfig.NeedShowInWindow, WidgetUIConfig.ZOrder, nil, bIsAddToCachePool)
    self:UpdateArgs(Widget, WidgetUIConfig.Params)
    return Widget
end

---异步加载子蓝图
---@param UIName string 界面名称
---@param CoroutineOrCBFunc function|thread 协程或者回调函数
---@param BPPath string 子蓝图路径(填了的话不会去WidgetUI表里面查询)
---@return UUserWidget 注意，如果参数传的回调函数，返回值始终是nil，UI要在回调函数的参数里取
function BP_UIManagerComponent_C:CreateWidgetAsync(UIName, CoroutineOrCBFunc, BPPath,...)
    --如果没有协程或者回调，则退回到同步加载模式
    if not CoroutineOrCBFunc then
        if UIName then
            return self:_CreateWidgetNew(UIName)
        elseif BPPath then
            return self:CreateWidget(BPPath,...)
        end
    end
    local WidgetUIConfig, BPClassPath = nil, nil

    local PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self)
    if (BPPath) then
        BPClassPath = BPPath
        local NeedShowInWindow, ZOrder, ExUIName, bIsAddToCachePool = ...
        WidgetUIConfig = UIConst.AllUIConfig[UIName] or {
            NeedShowInWindow = NeedShowInWindow,
            ZOrder = ZOrder,
            IsAddToCachePool = bIsAddToCachePool and UIConst.OptimizeSwitch[PlatformName].UI_ADD_IN_CACHE 
        }
    else
        WidgetUIConfig = DataMgr.WidgetUI[UIName]
        assert(WidgetUIConfig, "UI:" .. UIName .. "不在WidgetUI表中")

        if (PlatformName == CommonConst.CLIENT_DEVICE_TYPE.PC) then
            BPClassPath = WidgetUIConfig.BPPath
        elseif (PlatformName == CommonConst.CLIENT_DEVICE_TYPE.MOBILE) then
            BPClassPath =  WidgetUIConfig.MobileBPPath or WidgetUIConfig.BPPath
        else
            -- 默认都先用PC的
            BPClassPath = WidgetUIConfig.BPPath
        end
    end

    local AfterLoadUMGClassDone = function (UMG_Class, CbFunc)
        local UMG_Widget_Ins = self:_CreateWidgetByUMGClass(UMG_Class, WidgetUIConfig.NeedShowInWindow, WidgetUIConfig.ZOrder, nil, WidgetUIConfig.IsAddToCachePool)
        if UMG_Widget_Ins == nil then
            DebugPrint(ErrorTag,"BP_UIManagerComponent_C: CreateWidget Error, BPClassPath is ", BPClassPath)
            local ErrorLog = string.format("::Error::  Widget创建失败，界面名称：%s", UIName or "None")
            self:ShowUIError(UIConst.ErrorCategory.BasicModule, ErrorLog)
        end
        if CbFunc then CbFunc(UMG_Widget_Ins) end 
        return UMG_Widget_Ins
    end
    local UMG_Class = nil
    DebugPrint("CreateWidget 开始异步加载UMGCLass",UIName)
    local Handler = nil
    Handler = UE.UResourceLibrary.LoadClassAsync(self, BPClassPath, {self, function(self, UIClass)
        DebugPrint("CreateWidget 异步加载UMGCLass完成", UIName)
        UMG_Class = UIClass
        if type(CoroutineOrCBFunc) == "function" then
            if Handler then
                AfterLoadUMGClassDone(UIClass, CoroutineOrCBFunc)
            end
        elseif type(CoroutineOrCBFunc) == "thread" then
            if coroutine.status(CoroutineOrCBFunc) == "suspended" then
                coroutine.resume(CoroutineOrCBFunc, UIClass)
            end
        end
    end})
    if not UMG_Class then
        if not UResourceLibrary.IsValidResource(self, Handler) then
            return
        end
        DebugPrint("CreateWidget 等待异步加载UMGCLass...",UIName)
        if type(CoroutineOrCBFunc) == "thread" then
            UMG_Class = coroutine.yield()
        elseif type(CoroutineOrCBFunc) == "function" then
            return
        end
    end
    return AfterLoadUMGClassDone(UMG_Class)
end

-- 创建Widget
---@param BPClassPath string 界面的蓝图路径 
---@param NeedShowInWindow boolean 是否需要显示在窗口之中
---@param ZOrder number 界面在Z轴上的顺序
---@param UIName string 界面的名字，一般情况下不传，只有需要添加到管理类之中的Widget(类型是UIState)才需要传入Name
---@param bIsAddToCachePool boolean 是否需要添加到缓存池之中
function BP_UIManagerComponent_C:CreateWidget(BPClassPath, NeedShowInWindow, ZOrder, UIName, bIsAddToCachePool)
    local UMG_Class = nil
    if (type(BPClassPath) == "string") then
        UMG_Class = LoadClass(BPClassPath)
    else
        UMG_Class = BPClassPath
    end
    local PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self)
    bIsAddToCachePool = UIConst.OptimizeSwitch[PlatformName].UI_ADD_IN_CACHE and bIsAddToCachePool
    local Widget = self:_CreateWidgetByUMGClass(UMG_Class, NeedShowInWindow, ZOrder, UIName, bIsAddToCachePool)
    if (Widget == nil) then
        DebugPrint(ErrorTag, "BP_UIManagerComponent_C: CreateWidget fail, Maybe The Current World is Null or tearing down, BPClassPath is ", BPClassPath)
    end
    return Widget
end

-- 真正创建Widget
function BP_UIManagerComponent_C:_CreateWidgetByUMGClass(UMG_Class, NeedShowInWindow, ZOrder, UIName, bIsAddToCachePool)
    if (UMG_Class == nil) then
        return
    end
    local UMG_Widget_Ins = nil
    if (UIName ~= nil) then
        UMG_Widget_Ins = self:CreateWidgetAndAddToMgr(UMG_Class, UIName, bIsAddToCachePool)
    else
        UMG_Widget_Ins = self:CreateWidgetWithParams(UMG_Class, nil, nil, bIsAddToCachePool) 
    end
    if (UMG_Widget_Ins ~= nil) then
        if (NeedShowInWindow) then
            if (UIConst.bUseHierarchicalLayer) then
                self:AddWidgetToHierarchicalLayer(UIName, UMG_Widget_Ins, ZOrder)
            else
                UMG_Widget_Ins:AddToViewport(ZOrder)
            end
        elseif (ZOrder ~= nil) then
            UMG_Widget_Ins:SetZOrder(ZOrder)
        end
    end
    return UMG_Widget_Ins
end

-- 添加Widget到分层容器
---@param UIName string 界面名称
---@param WidgetObject UUserWidget 界面对象
function BP_UIManagerComponent_C:AddWidgetToHierarchicalLayer(UIName, WidgetObject, ZOrder)
    local WidgetUIConfig = DataMgr.WidgetUI[UIName]
    if (WidgetUIConfig == nil or WidgetUIConfig.HierarchicalLayer == nil) then
        WidgetObject:AddToViewport(ZOrder)
        return
    end
    local LayerName = WidgetUIConfig.HierarchicalLayer
    local HierarchicalWidget = UIManager(self):GetUIObj("SceneStartUI")
    if (HierarchicalWidget) then
        local LayerNodeWidget = HierarchicalWidget[LayerName.."_Overlay"]
        if (LayerNodeWidget) then
            local Slot = LayerNodeWidget:AddChildToOverlay(WidgetObject)
            Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
            Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
        else
            WidgetObject:AddToViewport(ZOrder)
        end
    else
        WidgetObject:AddToViewport(ZOrder)
    end
end
--endregion

--region 界面状态模式相关
function BP_UIManagerComponent_C:AddUIToStateTagsCluster(UIStateTag, UIName, IsAdd)
    if IsAdd then
        if (self.AllUIStateTagsCluster[UIStateTag] == nil) then
            self.AllUIStateTagsCluster[UIStateTag] = {}
        end
        self.AllUIStateTagsCluster[UIStateTag][UIName] = 1
    else
        if (self.AllUIStateTagsCluster[UIStateTag] ~= nil) then
            self.AllUIStateTagsCluster[UIStateTag][UIName] = nil
        end
    end
end

function BP_UIManagerComponent_C:GenerateSpecialUIListBeforeUICreate(UIName, KeyInList)
    local ResultStateTag, ResultList = ENormalModeSubState.ConditionMode, {}
    if (KeyInList == UIConst.WidgetAllStateTag.Queue) then
        -- 队列依次显示类型的界面
        for k, v in pairs(self.AllUIStateTagsCluster[KeyInList]) do
            table.insert(ResultList, k)
        end
    elseif (KeyInList == UIConst.WidgetAllStateTag.Precedence) then
        -- 需要竞争显示类型的界面
        for k, v in pairs(self.AllUIStateTagsCluster[KeyInList]) do
            local SystemUIConfig = DataMgr.SystemUI[k]
            if (SystemUIConfig ~= nil and SystemUIConfig.SpecialUINameList ~= nil) then
                for _, CheckUIName in ipairs(SystemUIConfig.SpecialUINameList) do
                    if (ResultList[CheckUIName] == nil) then
                        ResultList[CheckUIName] = {k}
                    else
                        table.insert(ResultList[CheckUIName], k)
                    end
                end
            end
        end
    elseif (KeyInList == UIConst.WidgetAllStateTag.Mutual) then
        -- 互斥类型的界面
        local SystemUIConfig = DataMgr.SystemUI[UIName]
        if (SystemUIConfig ~= nil and SystemUIConfig.SpecialUINameList ~= nil) then
            for _, CheckUIName in ipairs(SystemUIConfig.SpecialUINameList) do
                table.insert(ResultList, CheckUIName)
            end
        end
    elseif (KeyInList == UIConst.WidgetAllStateTag.Group) then
        -- 同组类型的界面
        for k, v in pairs(self.AllUIStateTagsCluster[KeyInList]) do
            local SystemUIConfig = DataMgr.SystemUI[k]
            if (SystemUIConfig ~= nil and SystemUIConfig.SpecialUINameList ~= nil) then
                for _, CheckUIName in ipairs(SystemUIConfig.SpecialUINameList) do
                    if (ResultList[k] == nil) then
                        ResultList[k] = {CheckUIName}
                    else
                        table.insert(ResultList[k], CheckUIName)
                    end
                end
            end
        end
    end

    return ResultStateTag, ResultList
end

-- 判断当前界面管理器的状态
function BP_UIManagerComponent_C:CheckUIMgrIsInSpecialState()
    local CurrentLevelName = UGameplayStatics.GetCurrentLevelName(self)
    if (CurrentLevelName == "Login" or CurrentLevelName == "Game_Start") then
        -- 登录场景
        return EUIManageLoadStateTags.NormalMode
    end
    if (self.GMShowUIOnly) then
        -- GM沉浸模式
        return EUIManageLoadStateTags.GMMode
    end

    local CurrentUIMgrStateTag = self:GetCurrentModeStateTag()
    return CurrentUIMgrStateTag
end

-- 在UIMgr正常状态下获取子状态
function BP_UIManagerComponent_C:GetSubTagInNormalState(UIName)
    local SubTag, SpecialUINameList = nil, {}
    if (self:CheckUIMgrIsInSpecialState() == EUIManageLoadStateTags.GMMode) then
        -- 该模式下直接返回
        return SubTag, SpecialUINameList
    end

    if (not IsEmptyTable(self.AllUIStateTagsCluster)) then
        local SubWidgetList = nil
        -- UI条件检测模式 (通过填表的一系列UI显隐规则)
        if (not IsEmptyTable(self.AllUIStateTagsCluster[UIConst.WidgetAllStateTag.Exclusive])) then
            -- 有Exclusive类型界面存在，新界面默认隐藏
            SubTag = ENormalModeSubState.ExclusiveMode
        elseif (not IsEmptyTable(self.AllUIStateTagsCluster[UIConst.WidgetAllStateTag.Blocked])) then
            -- 有Blocked类型界面存在，新界面不创建
            SubTag = ENormalModeSubState.BlockedMode
        else
            if (not IsEmptyTable(self.AllUIStateTagsCluster[UIConst.WidgetAllStateTag.Precedence])) then
                -- 竞争类型的界面
                SubTag, SubWidgetList = self:GenerateSpecialUIListBeforeUICreate(UIName, UIConst.WidgetAllStateTag.Precedence)
                SpecialUINameList[UIConst.WidgetAllStateTag.Precedence] = SubWidgetList
            end
            if (not IsEmptyTable(self.AllUIStateTagsCluster[UIConst.WidgetAllStateTag.Mutual]) and 
                        self.AllUIStateTagsCluster[UIConst.WidgetAllStateTag.Mutual][UIName] ~= nil) then
                -- 互斥类型的界面
                SubTag, SubWidgetList = self:GenerateSpecialUIListBeforeUICreate(UIName, UIConst.WidgetAllStateTag.Mutual)
                SpecialUINameList[UIConst.WidgetAllStateTag.Mutual] = SubWidgetList
            end
            if (not IsEmptyTable(self.AllUIStateTagsCluster[UIConst.WidgetAllStateTag.Queue])) then
                -- 队列依次显示类型的界面
                SubTag, SubWidgetList = self:GenerateSpecialUIListBeforeUICreate(UIName, UIConst.WidgetAllStateTag.Queue)
                SpecialUINameList[UIConst.WidgetAllStateTag.Queue] = SubWidgetList
            end
            if (not IsEmptyTable(self.AllUIStateTagsCluster[UIConst.WidgetAllStateTag.Group])) then
                -- 同组类型的界面
                SubTag, SubWidgetList = self:GenerateSpecialUIListBeforeUICreate(UIName, UIConst.WidgetAllStateTag.Group)
                SpecialUINameList[UIConst.WidgetAllStateTag.Group] = SubWidgetList
            end 
        end
    end
    return SubTag, SpecialUINameList
end

-- 添加当前UIMgr状态
function BP_UIManagerComponent_C:AddUIManagerCurrentModeTag(ModeStateTag)
    self:PushCurrentModeStateTag(ModeStateTag)
    if (ModeStateTag == EUIManageLoadStateTags.SkillFeatureMode or ModeStateTag == EUIManageLoadStateTags.StoryMode) then
        -- 隐藏当前显示着的所有界面
        self:RefreshAllUIVisibilityBySpecialTag(true, ModeStateTag)
        -- 隐藏所有指引点
        local Objs = MissionIndicatorManager:GetAllIndicatorUIObjs()
        if not IsEmptyTable(Objs) then
            for Name, UIObj in pairs(Objs) do
                UIObj:Hide(ModeStateTag)
            end
        end
    end
end

-- 移除当前UIMgr状态
function BP_UIManagerComponent_C:RemoveUIManagerCurrentModeTag(ModeStateTag)
    if (ModeStateTag == nil) then
        ModeStateTag = self:GetCurrentModeStateTag()
    end
    local Result = self:PopCurrentModeStateTag(ModeStateTag)
    if (Result ~= nil) then
        if (ModeStateTag == EUIManageLoadStateTags.SkillFeatureMode or ModeStateTag == EUIManageLoadStateTags.StoryMode) then
            -- 去除当前界面的特定隐藏Tag
            self:RefreshAllUIVisibilityBySpecialTag(false, ModeStateTag)
            -- 隐藏所有指引点
            local Objs = MissionIndicatorManager:GetAllIndicatorUIObjs()
            if not IsEmptyTable(Objs) then
                for Name, UIObj in pairs(Objs) do
                    UIObj:Show(ModeStateTag)
                end
            end
        end
    end
end

-- 获取当前UIManager的状态
function BP_UIManagerComponent_C:GetCurrentModeStateTag()
    return self.UIManagerModeTagsStack:Peek()
end

-- 设置当前UIManager的状态
function BP_UIManagerComponent_C:PushCurrentModeStateTag(ModeStateTag)
    self.UIManagerModeTagsStack:Push(ModeStateTag)
end

-- 弹出当前UIManager的状态
function BP_UIManagerComponent_C:PopCurrentModeStateTag(ModeStateTag)
    local Result = nil
    if (ModeStateTag ~= nil) then
        Result = self.UIManagerModeTagsStack:FindAndRemove(ModeStateTag)
    else
        Result = self.UIManagerModeTagsStack:Pop()
    end
    return Result
end

-- 获取当前栈顶UI元素的入场动画时长
function BP_UIManagerComponent_C:GetTopUIWidgetInAnimEndTime()
    local TopUIState = UIManager(self):GetCurrentState()
    if (TopUIState and TopUIState.In) then
        if (type(TopUIState.In) == "userdata" and type(TopUIState.In.GetEndTime) == "function") then
            return TopUIState.In:GetEndTime() or UIConst.AnimWithJumpConfig.Normal.InAnimWithJumpTime
        elseif (type(TopUIState.Auto_In) == "userdata" and type(TopUIState.Auto_In.GetEndTime) == "function") then
            return TopUIState.Auto_In:GetEndTime() or UIConst.AnimWithJumpConfig.Normal.InAnimWithJumpTime
        end
    end
    return UIConst.AnimWithJumpConfig.Normal.InAnimWithJumpTime
end

-- 获取当前栈顶UI元素的退场动画时长
function BP_UIManagerComponent_C:GetTopUIWidgetOutAnimEndTime()
    local TopUIState = UIManager(self):GetCurrentState()
    if (TopUIState and TopUIState.Out) then
        if (type(TopUIState.Out) == "userdata" and type(TopUIState.Out.GetEndTime) == "function") then
            return TopUIState.Out:GetEndTime() or UIConst.AnimWithJumpConfig.Normal.OutAnimWithJumpTime
        elseif (type(TopUIState.Auto_Out) == "userdata" and type(TopUIState.Auto_Out.GetEndTime) == "function") then
            return TopUIState.Auto_Out:GetEndTime() or UIConst.AnimWithJumpConfig.Normal.OutAnimWithJumpTime
        end
    end
    return UIConst.AnimWithJumpConfig.Normal.OutAnimWithJumpTime
end
--endregion

--region 界面跳转相关
function BP_UIManagerComponent_C:PlaceJumpUIToTop(JumpUIObj, JumpUIName)
    self:PlaceItemToQueueBack(JumpUIObj)
    self:PlaceUIStateToTop(JumpUIName)
end

function BP_UIManagerComponent_C:PrintJumpPageDequeInfo()
    local DequeSize = self.UIJumpToDeque:Size()
    for i = 1, DequeSize do
        local CurrentFirstUIObj = self.UIJumpToDeque:Get(i)
        if (type(CurrentFirstUIObj.GetCameraViewCurrentTarget) == "function") then
            DebugPrint("BP_UIManagerComponent_C: PrintJumpPageDequeInfo, The Info is: ", 
                        CurrentFirstUIObj:GetName(), CurrentFirstUIObj:GetCameraViewCurrentTarget():GetName())
        else
            DebugPrint("BP_UIManagerComponent_C: PrintJumpPageDequeInfo, The Info is: ", 
                        CurrentFirstUIObj:GetName(), "Has No CameraViewTarget")
        end
    end
end

-- 添加到跳转页面队列
function BP_UIManagerComponent_C:AddToJumpPageDeque(UIObj)
    if (not UIObj) then
        return
    end
    local DequeSize = self.UIJumpToDeque:Size()
    if (DequeSize >= 3) then
        local FirstUIObj = self.UIJumpToDeque:PopFront()
        if (IsValid(FirstUIObj)) then
            -- FirstUIObj.IsAddInDeque = nil
            FirstUIObj.IsNeedSearchInStack = true
            if (type(FirstUIObj.Close) == "function") then
                FirstUIObj:Close()
            else
                self:UnLoadUI(FirstUIObj.ConfigName, FirstUIObj.WidgetName) 
            end
        end
    end

    UIObj.IsAddInDeque = true
    -- if (UIObj and UIObj.In and UIObj:IsAnimationPlaying(UIObj.In)) then
    --     UIObj:SetAnimationCurrentTime(UIObj.In, UIObj.In:GetEndTime() - 0.01)
    --     UIObj:PlayAnimation(UIObj.In)
    -- end

    self.UIJumpToDeque:PushBack(UIObj)

    EventManager:FireEvent(EventID.OnJumpToPage, self:GetLastJumpPage(),UIObj)
end

-- 从跳转页面队列中移除
function BP_UIManagerComponent_C:RemoveToJumpPageDeque(UIObj)
    local CurrentLastUIObj = self.UIJumpToDeque:Back()
    if (CurrentLastUIObj == UIObj) then
        self.UIJumpToDeque:PopBack()
        EventManager:FireEvent(EventID.OnJumpBackToPage, UIObj, self:GetLastJumpPage())
    end
end

-- 获取最近一个被添加进来的跳转页面
function BP_UIManagerComponent_C:GetLastJumpPage()
    return self.UIJumpToDeque:Back()
end

-- 将元素添加到队列的末尾
function BP_UIManagerComponent_C:PlaceItemToQueueBack(Element)
    if (Element == nil) then
        return
    end
    -- 更新队列之中的元素
    local Index = self:CheckIsInJumpPageDeque(Element)
    local DequeSize = self.UIJumpToDeque:Size()
    if (Index == nil) then
        self:AddToJumpPageDeque(Element)
    else
        for i = Index, DequeSize - 1 do
            local NextUIObj = self.UIJumpToDeque:Get(i + 1)
            self.UIJumpToDeque:Set(i, NextUIObj) 
        end
        self.UIJumpToDeque:Set(DequeSize, Element) 
    end
end

-- 检查跳转页面队列之中是否存在该界面
function BP_UIManagerComponent_C:CheckIsInJumpPageDeque(UIObj)
    -- 查询跳转队列之中有无该界面
    local DequeSize, SearchIndex = self.UIJumpToDeque:Size(), nil
    for i = 1, DequeSize, 1 do
        local TargetUIObj = self.UIJumpToDeque:Get(i)
        if (TargetUIObj == UIObj) then
            SearchIndex = i
            break
        end
    end
    return SearchIndex
end

-- 检查Loading队列之中是否存在该界面
function BP_UIManagerComponent_C:CheckIsInLoadingDeque(CheckList, UIName)
    if (#CheckList == 1 and CheckList[1] == UIName) then
        -- 只有自身
        return true
    end
    -- 查询Loading队列之中有无该界面
    local DequeSize, IsInDeque = self.UILoadingDeque:Size(), false
    for i = 1, DequeSize, 1 do
        local UIInfo = self.UILoadingDeque:Get(i)
        if (UIInfo and UIInfo.UIName == UIName) then
            IsInDeque = true
            break
        end
    end
    return IsInDeque
end
--endregion

--region UserWidget类型界面加载、卸载相关接口
---@param UIName string 界面名称
---@param ... any 参数
---@return BP_UIState_C 界面对象
function BP_UIManagerComponent_C:LoadUINew(UIName, ...)
    local SystemUIConfig = DataMgr.SystemUI[UIName]
    assert(SystemUIConfig, "UI:" .. UIName .. "不在SystemUI表中")
    return self:LoadUI(UIConst.LoadInConfig, UIName, SystemUIConfig.ZOrder, ...)
end

---UI蓝图异步加载
---@param CoroutineOrCBFunc function|thread 协程或者回调函数
---@return BP_UIState_C 注意，如果参数传的回调函数，返回值始终是nil，UI要在回调函数的参数里取
function BP_UIManagerComponent_C:LoadUIAsync(UIName, CoroutineOrCBFunc, ...)
    local SystemUIConfig = DataMgr.SystemUI[UIName]
    assert(SystemUIConfig, "UI:" .. UIName .. "不在SystemUI表中")
    local Param = {...}
    table.insert(Param, CoroutineOrCBFunc)
    table.insert(Param, "Async")
    return self:LoadUI(UIConst.LoadInConfig, UIName, SystemUIConfig.ZOrder, table.unpack(Param))
end

-- 实际界面加载函数
---@param BPClassPath string 界面蓝图路径
---@param UIName string 界面名称
---@param ZOrder number 界面在Z轴上的顺序
---@param ... any 参数
---@return BP_UIState_C 界面对象
function BP_UIManagerComponent_C:LoadUI(BPClassPath, UIName, ZOrder, ...)
    if IsDedicatedServer(self) then
        return
    end
    -- FinalName为最终UI对象的名字
    local FinalName, ExistUIObj, UIConfig = UIName, nil, nil
    local SpecialSignPos = string.find(UIName, "#")
    if (SpecialSignPos ~= nil) then
        -- 带#号的，前半部分是config里面的名字，后半部分是实际的名字(此类命名方式一般用于有确定对应关系的UI,因此不支持Multi)
        local UINameDataArray = Split(UIName, "#")
        UIName = UINameDataArray[1]
        FinalName = UINameDataArray[2]
    end
    ExistUIObj = self:GetUI(FinalName)
    if (IsValid(ExistUIObj)) then
        DebugPrint("The Widget is Already Exist, Name is ", UIName)
        -- 是否已经存在了这个UI对象，则直接返回
        return ExistUIObj
    end
    if UIUtils.CheckCdnHide(UIName,true) then
        return
    end
    local SystemUI = DataMgr.SystemUI[UIName]
    if (SystemUI ~= nil) then
        -- 判断界面打开条件
        local IsConditionSuccess, ShowConditiontext = self:CheckCombatcondition(SystemUI.CombatconditionIdList, SystemUI.ConditiontextList)
        if (not IsConditionSuccess) then
            if(ShowConditiontext) then
                self:ShowUITip(UIConst.Tip_CommonTop,GText(ShowConditiontext))
                return
            else
                DebugPrint("The UI Load in fail, Because Combatcondition is not met, UIName is", UIName)
                return
            end
        end

        -- 判断是否是仅限于开发版本加载的界面
        if (SystemUI.IfDevOnly and not GMVariable.IsInDebugMode) then
            DebugPrint("The UI Load in fail, Because IfDevOnly Set in SystemUI Config, UIName is", UIName)
            return
        end
    end
    -- 如果是从表里获取数据的界面，在这里填充内容
    UIConfig, BPClassPath = self:SetUIConfig(BPClassPath, UIName, SystemUI)

    if (UIConfig["allowmulti"]) then
        -- 判断是否是可以同时显示多个的界面类型
        local UICount = self.UniqueCount[UIName] or 0
        local LimitCount = UIConfig["limitcount"] or UIConst.MAXEXISTNUM
        if UICount + 1 <= LimitCount then
            self.UniqueCount[UIName] = UICount + 1
        else
            self.UniqueCount[UIName] = 1
        end
        FinalName = UIName..tostring(self.UniqueCount[UIName])
    end

    if (UIConfig["statetag"] ~= nil) then
        -- 设置界面的状态Tag
        self:AddUIToStateTagsCluster(UIConfig["statetag"], UIName, true)
    end

    local Params = {...}
    local NormalStateSubTag, SpecialUINameList = self:GetSubTagInNormalState(UIName)

    -- 处理一下Block状态以及Queue配置的界面
    if (UIConfig["specialvisiblemode"] ~= "forceshow") then
        if (NormalStateSubTag == ENormalModeSubState.BlockedMode) then
            DebugPrint("The UI Whitch Named "..UIName.." Create Fail, It has been Blocked")
            return
        elseif (NormalStateSubTag == ENormalModeSubState.ConditionMode and UIConfig["statetag"] == UIConst.WidgetAllStateTag.Queue) then
            local AllLoadingListUI = SpecialUINameList[UIConst.WidgetAllStateTag.Queue]
            if (AllLoadingListUI ~= nil and #AllLoadingListUI > 0 and not self:CheckIsInLoadingDeque(AllLoadingListUI, UIName)) then
                self.UILoadingDeque:PushBack({UIName=UIName, Params=Params})
                DebugPrint("The UI Whitch Named "..UIName.." Create Fail, It has been Added in Loading Queue, It Will show when Condition met")
                return
            end
        end
    end
    if (type(BPClassPath) == "table" and UIConfig["haschildBP"]) then
        -- 蓝图有子蓝图
        local SubChildrenName = Params[1]
        BPClassPath = BPClassPath[SubChildrenName]
        table.remove(Params, 1)
    end
    if (BPClassPath == nil) then
        DebugPrint("The UI Whitch Named "..UIName.." BPClass is nil !!!!!!!")
        local ErrorLog = string.format("::Error::  系统界面创建失败，BPClassPath找不到，系统名称：%s", UIName)
        self:ShowUIError(UIConst.ErrorCategory.BasicModule, ErrorLog)
        return
    end
    if (ZOrder == nil) then
        ZOrder = UIConfig["zorder"] or UIConst.ZORDER_FOR_ZERO
    end

    local AfterLoadUMGClassDone = function (UMG_Class, CbFunc)
        local UIObj = nil
        if not self.AsyncUnloadFlags[UIName] and UMG_Class then
            if (UIConfig["IsGlobalUI"]) then
                local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
                UIObj = GameInstance:LoadGlobalUI(UMG_Class, FinalName, ZOrder)
                if (UIObj ~= nil) then
                    UIObj.IsGlobalUI = true
                end
            else
                local IsAddToStack = not not UIConfig["addtostack"]
                UIObj = self.Overridden.LoadUI(self, UMG_Class, FinalName, ZOrder, IsAddToStack) 
            end
            if UIObj ~= nil then
                local NowUIMgrStateTag = self:CheckUIMgrIsInSpecialState()
                self:UpdateUIObjByConfig(UIObj, UIConfig, UIName, FinalName, Params, 
                            NowUIMgrStateTag, NormalStateSubTag, SpecialUINameList)
                -- UI对象加载完成
                self:OnUIObjLoadCompleted(UIName, UIConfig)
            end
        end
        if not UMG_Class then
            DebugPrint(ErrorTag, "BPClassPath is not valid")
            local ErrorLog = string.format("::Error::  系统界面异步创建传进来的Class对象是个空，系统名称：%s", UIName)
            self:ShowUIError(UIConst.ErrorCategory.BasicModule, ErrorLog)
        end
        if self.AsyncLoadHandlers[UIName] then
            self.AsyncLoadHandlers[UIName] = nil 
        end
        ---GetUIObjAync的回调过程应该比LoadUIAsync的回调过程晚，延迟一帧
        if self.AsyncGetUIContexts[UIName] then
            self:AddTimer(0.01,function()
                DebugPrint(LXYTag, "GetUIObjAsync异步回调处理")
                for _,CoroutineOrCBFunc in ipairs(self.AsyncGetUIContexts[UIName]) do
                    if type(CoroutineOrCBFunc) == "function" then
                        CoroutineOrCBFunc(UIObj)
                    elseif type(CoroutineOrCBFunc) == "thread" then
                        if coroutine.status(CoroutineOrCBFunc) == "suspended" then
                            coroutine.resume(CoroutineOrCBFunc, UIObj)
                        end
                    end
                end
                self.AsyncGetUIContexts[UIName] = nil
            end,false,0,nil,true)
        end
        self.AsyncUnloadFlags[UIName] = nil
        ---处理异步回调
        if CbFunc then CbFunc(UIObj) end    
        return UIObj
    end

    -- 先尝试从PreLoad里面拿Class
    local UMG_Class = self:GetPreloadUIClass(UIName)
    if (UMG_Class == nil) then
        if (type(BPClassPath) == "string") then
            local CoroutineOrCBFunc = nil
            if Params[#Params] == "Async" then
                table.remove(Params, #Params)
                CoroutineOrCBFunc = Params[#Params]
                table.remove(Params, #Params)
            end
            if CoroutineOrCBFunc then
                DebugPrint(LXYTag,"开始异步加载UMGClass",UIName, BPClassPath)
                local Handler = UE.UResourceLibrary.LoadClassAsync(self, BPClassPath, {self, function(self, UIClass)
                    if not IsValid(UIClass) then 
                        DebugPrint(LXYTag, "回调内，异步加载UMGCLass失败",UIName, BPClassPath)
                        return
                    end
                    DebugPrint(LXYTag, "异步加载UMGCLass完成",UIName,BPClassPath)
                    UMG_Class = UIClass
                    if type(CoroutineOrCBFunc) == "function" or type(CoroutineOrCBFunc) == "nil" then
                        if self.AsyncLoadHandlers[UIName] then
                            AfterLoadUMGClassDone(UIClass, CoroutineOrCBFunc)
                        end
                    elseif type(CoroutineOrCBFunc) == "thread" then
                        if coroutine.status(CoroutineOrCBFunc) == "suspended" then
                            coroutine.resume(CoroutineOrCBFunc, UIClass)
                        end
                    end
                end})
                if not UMG_Class then
                    if UResourceLibrary.IsValidResource(self, Handler) then
                        DebugPrint(LXYTag, "等待异步加载UMGCLass...",UIName)
                        self.AsyncLoadHandlers[UIName] = Handler
                    else
                        DebugPrint(LXYTag, "异步加载UMGCLass失败，估计路径有问题",UIName, BPClassPath)
                        return
                    end
                    if type(CoroutineOrCBFunc) == "thread" then
                        UMG_Class = coroutine.yield()
                    elseif type(CoroutineOrCBFunc) == "function" then
                        return
                    end
                end
            else
                UMG_Class = UE4.UClass.Load(BPClassPath) 
            end
        elseif (type(BPClassPath) == "userdata") then
            UMG_Class = BPClassPath
        elseif (type(BPClassPath) == "table") then
            UMG_Class = BPClassPath
        end
    end
    return AfterLoadUMGClassDone(UMG_Class)
end

-- 恢复停止游戏状态
function BP_UIManagerComponent_C:RevertRealStopGame(IsStopGame)
    if IsStopGame == nil then
        return false
    end
    if IsStopGame == true then
        return true
    end
    local Avatar = GWorld:GetAvatar()
    if  Avatar and Avatar.CurrentOnlineType and Avatar.CurrentOnlineType ~= -1 then 
        return IsStopGame > 0 and IsStopGame < 2
    end
    return IsStopGame ~= nil and IsStopGame ~= false and IsStopGame > 0
end

-- 根据表里参数设置UI配置
function BP_UIManagerComponent_C:SetUIConfig(BPClassPath, UIName, SystemUI)
    local UIConfig = UIConst.AllUIConfig[UIName] or {}
    BPClassPath = BPClassPath or UIConfig["resource"]
    if (BPClassPath == UIConst.LoadInConfig) then
        -- 蓝图通过配置表来定义（读取表里面的一些配置）
        if (SystemUI ~= nil) then
            UIConfig["zorder"] = SystemUI.ZOrder
            UIConfig["popup"] = SystemUI.Popup
            UIConfig["statetag"] = SystemUI.StateTag
            UIConfig["ExtraArgs"] = SystemUI.Params
            UIConfig["IsStopGame"] = self:RevertRealStopGame(SystemUI.IsStopGame)
            UIConfig["GlobalGameUITag"]= SystemUI.GlobalGameUITag
            UIConfig["IsHideBattleUnit"]= SystemUI.IsHideBattleUnit
            UIConfig["IgnoreHideTags"]= SystemUI.IgnoreHideTags
            UIConfig["KeyboardSetName"]= SystemUI.KeyboardSetName
            UIConfig["IsHideDrop"] = SystemUI.IsHideDrop
            UIConfig["ShowInStory"] = SystemUI.ShowInStory
            UIConfig["ConditionShowStateTags"] = SystemUI.ConditionShowStateTags
            UIConfig["System"] = SystemUI.System
            UIConfig["PauseAfterLoadingState"] = SystemUI.PauseAfterLoadingState
            UIConfig["IsHideInImmersionMode"]=SystemUI.IsHideInImmersionMode
            UIConfig["IsGlobalUI"] = SystemUI.IsGlobalUI
            --如果SystemUIConfig不为空，则从表中读取
            if SystemUI.ConfigName then
                local SystemUIConfig=DataMgr.SystemUIConfig[SystemUI.ConfigName]
                if (SystemUIConfig) then
                    UIConfig["addtostack"]=SystemUIConfig.AddToStack
                    UIConfig["allowmulti"]=SystemUIConfig.AllowMulti~=nil and SystemUIConfig.AllowMulti or false
                    UIConfig["haschildBP"]=SystemUIConfig.HasChildBP~=nil and SystemUIConfig.HasChildBP or false
                    UIConfig["limitcount"]=SystemUIConfig.limitcount or UIConst.MAXEXISTNUM
                    UIConfig["specialvisiblemode"]=SystemUIConfig.SpecialVisibleMode
                    UIConfig["StopWorldRender"]=SystemUIConfig.StopWorldRender
                    UIConfig["eventlist"]=SystemUIConfig.EventList
                    UIConfig["needuimode"]=SystemUIConfig.NeedUIMode~=nil and SystemUIConfig.NeedUIMode or false
                end
            end
            local PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self)
            if (UIConfig["haschildBP"]) then
                -- 如果有子蓝图则用子蓝图路径(目前指引点有用到，因为指引点蓝图太多，就没有全部填到表里，只填了一个任务指引点)
                BPClassPath = UIConfig["resource"]
            elseif (PlatformName == "PC") then
                BPClassPath = SystemUI.PCBPPath
                UIConfig["resource"] = BPClassPath
            elseif (PlatformName == "Mobile") then
                BPClassPath = SystemUI.MobileBPPath or SystemUI.PCBPPath
                UIConfig["resource"] = BPClassPath
            end
        end
    end

    self:RecordShowInStoryConfig(UIConfig, UIName)
    return UIConfig, BPClassPath
end

-- 界面加载完成之后根据配置设置UI对象的状态以及参数
function BP_UIManagerComponent_C:UpdateUIObjByConfig(UIObj, UIConfig, UIName, FinalName, Params, NowUIMgrStateTag, NormalStateSubState, SpecialUINameList)
    if (UIConfig["popup"] == true) then
        UIObj.IsUIPopUp = true
        self:CloseResidentUI(FinalName)
    end
    -- 设置是否有忽略Hide的Tag
    if UIConfig.IgnoreHideTags then
        UIObj.IgnoreHideTags = UIConfig.IgnoreHideTags
    end
    -- 被HideAllUI接口隐藏的UI会在这一步隐藏
    local IsHideCurUIObj = false
    if (UIConfig.specialvisiblemode ~= "forceshow") then
        IsHideCurUIObj = self:HideUIByAllFlag(UIObj) 
    end
    -- 把一把填在表里的额外参数传递给UI对象，初始化UI对象
    self:UpdateArgs(UIObj, UIConfig.ExtraArgs)
    if (type(UIObj.InitUIInfo) == "function") then
        UIObj:InitUIInfo(UIName, UIConfig.needuimode, UIConfig.eventlist, table.unpack(Params, 1, 15))
    end
    if (UIConfig["StopWorldRender"]) then
        -- 是否开启停止场景绘制
        UIObj:SetIsPauseWorldRendering(true)
        self:SetPauseWorldRenderingSwitch(UIName, true)
    end
    if (UIConfig["statetag"] ~= nil) then
        -- 一些特殊状态的设置
        UIObj:SetUIStateTag(UIConfig["statetag"])
    end

    if (UIConfig.System == "Battle" or UIConfig.System == "Common") then
        -- 设置是否是常用UI
        UIObj:SetIsFrequentlyUI(true)
    end

    if (UIConfig.IsHideInImmersionMode) then
        -- 设置是否是沉浸式模式下隐藏的UI
        IsHideCurUIObj = self:SetIsHideInImmersionMode(UIObj)
    end

    if (not IsHideCurUIObj) then
        -- 处理一下界面的可见性相关
        IsHideCurUIObj = self:DealWithOtherWidgetsVisibilityByUIShow(UIName, UIObj, UIConfig, NowUIMgrStateTag, NormalStateSubState, SpecialUINameList)
    end

    if (UIConfig.IsStopGame) then
        -- 如果有暂停逻辑，并且当前界面没有被Hide掉，则暂停游戏
        UIObj.IsStopGame=true
        if (not IsHideCurUIObj) then
            UIObj:UISetGamePaused(UIName, true)
        end
    end

    if UIConfig.GlobalGameUITag then
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        GameInstance:SetGlobalGameUITag(UIConfig.GlobalGameUITag)
        UIObj.GlobalGameUITag = UIConfig.GlobalGameUITag
    end
    if UIConfig.KeyboardSetName then 
        UIObj.KeyboardSetName = UIConfig.KeyboardSetName
        UIManager(self):SetBannedActionCallback(UIConfig.KeyboardSetName, true, UIObj:GetName())
        UIObj.IsBanningAction = true
    end
    if UIConfig.PauseAfterLoadingState and UIObj then
        self:TryPauseAfterLoadingMgr(UIConfig.PauseAfterLoadingState)
    end
end

-- 进行特殊隐藏规则条件判断
function BP_UIManagerComponent_C:DealWithOtherWidgetsVisibilityByUIShow(UIName, UIObj, UIConfig, NowUIMgrStateTag, NormalStateSubState, SpecialUINameList)
    local IsHideCurUIObj = false
    if (UIConfig.specialvisiblemode ~= "forceshow") then
        if (NowUIMgrStateTag == EUIManageLoadStateTags.GMMode) then
            -- GM专有模式
            if (UIName ~= self.GMShowUIOnly) then
                IsHideCurUIObj = true
                UIObj:Hide(UIConst.CommonHideTagName.GMShowUIOnly) 
                if (self.HideByStateTagUIList[NowUIMgrStateTag] == nil) then
                    self.HideByStateTagUIList[NowUIMgrStateTag] = {UIObj}
                else
                    table.insert(self.HideByStateTagUIList[NowUIMgrStateTag], UIObj)
                end
            end
        elseif (NowUIMgrStateTag ~= EUIManageLoadStateTags.NormalMode) then
            -- 其他一些特殊模式
            local ConditionShowStateTags, IsInHideList = UIConfig.ConditionShowStateTags, true
            if (ConditionShowStateTags) then
                for index, value in ipairs(ConditionShowStateTags) do
                    if (value == NowUIMgrStateTag) then
                        -- 这部分UI支持在其他模式下显示
                        IsInHideList = false
                        break
                    end
                end
            end
            if (IsInHideList) then
                DebugPrint("The UI Whitch Named "..UIName.." Will Hide And delay to Show, Now is in "..NowUIMgrStateTag.." State!")
                IsHideCurUIObj = true
                UIObj:Hide(NowUIMgrStateTag) 
                -- 额外再处理一下可见性
                self:HandleUIWidgetsVisibilityByUIShow(UIName, UIObj, NormalStateSubState, SpecialUINameList)
            end
        else
            IsHideCurUIObj = self:HandleUIWidgetsVisibilityByUIShow(UIName, UIObj, NormalStateSubState, SpecialUINameList)
        end
    end
    return IsHideCurUIObj
end

-- 实际处理相关的可见性(UI添加的时候)
function BP_UIManagerComponent_C:HandleUIWidgetsVisibilityByUIShow(UIName, UIObj, NormalStateSubState, SpecialUINameList)            
    -- 正常模式
    local ReasonString, IsHideCurUIObj = "InUIConfigure", false
    if (NormalStateSubState == ENormalModeSubState.ExclusiveMode) then
        -- 当前界面独占模式，新创建的页面需要隐藏
        IsHideCurUIObj = true
        UIObj:Hide(ReasonString..NormalStateSubState) 
        if (self.HideByStateTagUIList[NormalStateSubState] == nil) then
            self.HideByStateTagUIList[NormalStateSubState] = {UIObj}
        else
            table.insert(self.HideByStateTagUIList[NormalStateSubState], UIObj)
        end
    elseif (NormalStateSubState == ENormalModeSubState.ConditionMode) then
        local function HideUIWithConditionMode(UIObjInst, UINameText, ReasonStr, SubState)
            UIObjInst:Hide(ReasonStr..UINameText) 
            if (self.HideByStateTagUIList[SubState] == nil) then
                self.HideByStateTagUIList[SubState] = {}
                self.HideByStateTagUIList[SubState][UINameText] = {UIObjInst}
            elseif (self.HideByStateTagUIList[SubState][UINameText] == nil) then
                self.HideByStateTagUIList[SubState][UINameText] = {UIObjInst}
            else
                table.insert(self.HideByStateTagUIList[SubState][UINameText], UIObjInst)
            end 
        end

        if (SpecialUINameList[UIConst.WidgetAllStateTag.Precedence] ~= nil) then
            -- 显隐条件检测模式 - 抢占关系
            for CheckUIName, Value in pairs(SpecialUINameList[UIConst.WidgetAllStateTag.Precedence]) do
                if (CheckUIName == UIName) then
                    IsHideCurUIObj = true
                    for _, v in ipairs(Value) do
                        if (self:GetUIObj(CheckUIName) ~= nil) then
                            DebugPrint("UIManagerComponent PrecedenceMode: The UI Which Named "..UIName.." Hide, The Reason is Effected by "..v)
                            HideUIWithConditionMode(UIObj, v, ReasonString, NormalStateSubState)
                        end
                    end
                else
                    local IsInEffectList, CheckUIObj = false, self:GetUIObj(CheckUIName)
                    for _, v in ipairs(Value) do
                        if (v == UIName) then
                            IsInEffectList = true
                            break
                        end
                    end
                    if (IsInEffectList) then
                        if (CheckUIObj == nil) then
                            self:GetUIObjAsync(CheckUIName, function(UIObjInst)
                                if UIObjInst then
                                    DebugPrint("UIManagerComponent PrecedenceMode: The UI Which Named "..CheckUIName.." Hide, The Reason is Effected by "..UIName)
                                    HideUIWithConditionMode(UIObjInst, UIName, ReasonString, NormalStateSubState)
                                end
                            end)  
                        else  
                            DebugPrint("UIManagerComponent PrecedenceMode: The UI Which Named "..CheckUIName.." Hide, The Reason is Effected by "..UIName)
                            HideUIWithConditionMode(CheckUIObj, UIName, ReasonString, NormalStateSubState)
                        end
                    end
                end
            end
        end
        if (SpecialUINameList[UIConst.WidgetAllStateTag.Mutual] ~= nil) then
            -- 显隐条件检测模式 - 互斥关系
            for _, CheckUIName in ipairs(SpecialUINameList[UIConst.WidgetAllStateTag.Mutual]) do
                local CheckUIObj = self:GetUIObj(CheckUIName)
                if (CheckUIObj == nil) then
                    self:GetUIObjAsync(CheckUIName, function(UIObjInst)
                        if UIObjInst then
                            DebugPrint("UIManagerComponent MutualMode: The UI Which Named "..CheckUIName.." Hide, The Reason is Effected by "..UIName)
                            HideUIWithConditionMode(UIObjInst, UIName, ReasonString, NormalStateSubState)
                        end
                    end)  
                else
                    DebugPrint("UIManagerComponent MutualMode: The UI Which Named "..CheckUIName.." Hide, The Reason is Effected by "..UIName)
                    HideUIWithConditionMode(CheckUIObj, UIName, ReasonString, NormalStateSubState)
                end
            end 
        end
        if (SpecialUINameList[UIConst.WidgetAllStateTag.Group] ~= nil) then
            IsHideCurUIObj = self:DealWithGroupUIVisibility(SpecialUINameList[UIConst.WidgetAllStateTag.Group], UIName, UIObj, NormalStateSubState, ReasonString)
        end
    end
    return IsHideCurUIObj
end

function BP_UIManagerComponent_C:SetIsHideInImmersionMode(UIObj)
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if  PlayerCharacter and PlayerCharacter.IsImmersionModel then
        UIObj:Hide("ImmersionMode")
        UIObj:SetRenderOpacity(0)
    end
end

-- 异步加载指引图标
function BP_UIManagerComponent_C:LoadGuideIconAsync(BPClassPath, UIName, ZOrder, CoroutineOrCBFunc, ...)
    local Param = {...}
    table.insert(Param, CoroutineOrCBFunc)
    table.insert(Param, "Async")
    return self:LoadUI(BPClassPath, UIName, ZOrder, table.unpack(Param))
end

-- 更新UI参数
function BP_UIManagerComponent_C:UpdateArgs(UIObj, Args)
    -- 注意子类对象里的变量名不要和表里填的额外参数的变量名重名！！！！
    if not UIObj or not UIObj.UpdateArgs then
        return
    end
    if not Args then
        return
    end
    UIObj:UpdateArgs(Args)
end
--endregion

-- 获取按键禁用组名称列表
function BP_UIManagerComponent_C:GetBannedActionNameList(KeyboardSetName)
    local KeyboardSetData = DataMgr.UIKeyboardSet[KeyboardSetName] 
    if not KeyboardSetData then 
        DebugPrint("Tianyi@ 找不到按键禁用组: " .. KeyboardSetName) 
        return nil
    end

    if KeyboardSetData.IsWhiteList then 
        local AllActionList = DataMgr.KeyboardMap
        local ActionNameList = {}
        for Key, _ in pairs(AllActionList) do 
            for _, ActionName in ipairs(KeyboardSetData.ActionNameList or {}) do 
                if Key == ActionName then 
                    goto continue
                end
            end
            table.insert(ActionNameList, Key) 
            
            ::continue::
        end
        return ActionNameList 
    else 
        return KeyboardSetData.ActionNameList 
    end
end

-- 检查战斗条件是否满足
function BP_UIManagerComponent_C:CheckCombatcondition(CombatconditionIdList, ConditiontextList)
    if (CombatconditionIdList == nil) then
        return true
    end
    ConditiontextList = ConditiontextList or {}
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local IsConditionSuccess, ShowConditiontext = true, nil
    local TraceInfo="From BP_UIManagerComponent_C:CheckCombatcondition"
    for i, v in ipairs(CombatconditionIdList) do
        local ConditionSucc = Battle(self):CheckConditionNew(v, PlayerCharacter, nil,TraceInfo)
        if (not ConditionSucc) then
            IsConditionSuccess = false
            ShowConditiontext = ConditiontextList[i]
            break
        end
    end
    return IsConditionSuccess, ShowConditiontext
end

---@param ActionList string[] 禁用快捷键名称列表
---@param IsBanned boolean 是否禁用
function BP_UIManagerComponent_C:SetBannedActionCallback(KeyboardSetName, IsBanned, UIName)
    UIName = UIName or "Common"
    self.ActivateBannedUI = self.ActivateBannedUI or {} -- 防止同一个UI多次调用该方法,记录一下正在生效的UI名称
    if self.ActivateBannedUI[UIName] and IsBanned == true then 
        -- DebugPrint("Tianyi@ this UI is already banned")
        return 
    end
    self.ActivateBannedUI[UIName] = true


    -- 禁用玩家身上绑定的按键
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    if not Player then 
        DebugPrint("Tianyi@ Player is not valid")
        return 
    end

    local ActionList = self:GetBannedActionNameList(KeyboardSetName) 
    if not ActionList then return end

    if IsBanned then 
        local AllActionList = DataMgr.KeyboardMap
        local AllowedList = TArray(FName)

        for _, Action in pairs(AllActionList) do 
            local Flag = false
            for _, BannedAction in ipairs(ActionList) do 
                if Action.ActionName == BannedAction then 
                    Flag = true 
                    break 
                end
            end

            if not Flag then 
                AllowedList:Add(Action.ActionName) 
            end
        end

        Player:FlushInputKeyExcept(AllowedList)
    end

    DebugPrint("Tianyi@ 设置禁用Action: , IsBanned = " .. tostring(IsBanned))
    
    self.BanActionCallbackMap = self.BanActionCallbackMap or {}
    for _, Action in ipairs(ActionList) do 
        if IsBanned then 
            Player:AddToActionGroups("UI", Action)
            self.BanActionCallbackMap[Action] = (self.BanActionCallbackMap[Action] or 0) + 1
        else 
            Player:RemoveFromGroups("UI", Action)          
            self.BanActionCallbackMap[Action] = (self.BanActionCallbackMap[Action] or 0) - 1
            if self.BanActionCallbackMap[Action] <= 0 then 
                self.BanActionCallbackMap[Action] = nil 
            end
        end
    end

    if IsBanned then 
        Player:AddForbidTag("UI")
    else 
        Player:MinusForbidTag("UI")
        self.ActivateBannedUI[UIName] = nil 
    end
end

-- 设置所有战斗实体的可见性
function BP_UIManagerComponent_C:SetAllBattleEntityHidden(bHidden, TagName, UnitType)
    -- TODO 隐藏特定的Entity (临时写法，后面需要统一一下)
    local BattleUtils = Battle(self)
    if not BattleUtils then return end
    local Entities = BattleUtils:GetAllEntities()
    if bHidden then
        ---@type TMap<int, AActor>
        for _, Entity in pairs(Entities) do
            if IsValid(Entity) and (Entity.UnitType == UnitType) and (not Entity.bHidden) then
                Entity:SetActorHiddenInGame(true)
            end
        end
        self.CacheModifyHiddenEntity[TagName] = 1
    else
        self.CacheModifyHiddenEntity[TagName] = nil
        if (IsEmptyTable(self.CacheModifyHiddenEntity)) then
            for _, Entity in pairs(Entities) do
                if IsValid(Entity) and (Entity.UnitType == UnitType) and Entity.bHidden then
                    Entity:SetActorHiddenInGame(false) 
                end
            end 
        end
    end
end

-- 检查是否禁止某个动作
function BP_UIManagerComponent_C:CheckIsActionBanned(ActionName)
    local IsActionBanned = self.BanActionCallbackMap and self.BanActionCallbackMap[ActionName]
    return IsActionBanned
end

-- 批量处理UI的显隐
function BP_UIManagerComponent_C:DealWithGroupUIVisibility(CheckList, UIName, UIObj, NormalStateSubState, ReasonString) 
    local IsHideCurUIObj = false
    -- 显隐条件检测模式 - 同组关系
    for CheckUIName, Value in pairs(CheckList) do
        if (type(Value) == "table") then
            if (UIName == CheckUIName) then
                -- 隐藏掉所有非同组界面
                local AllUI = self.UIInstances:ToTable()
                for _UIName, TargetWidget in pairs(AllUI) do
                    local IsNeedHide = true
                    for _, _CheckUIName in ipairs(Value) do
                        if (_UIName == _CheckUIName or _UIName == UIName) then
                            -- 自身以及同组界面需要显示
                            IsNeedHide = false
                            break
                        end
                    end
                    if (IsNeedHide) then
                        DebugPrint("UIManagerComponent GroupMode: The UI Which Named ".._UIName.." Hide, The Reason is Effected by "..UIName)
                        TargetWidget:Hide(ReasonString..UIName) 
                        if (self.HideByStateTagUIList[NormalStateSubState] == nil) then
                            self.HideByStateTagUIList[NormalStateSubState] = {}
                            self.HideByStateTagUIList[NormalStateSubState][UIName] = {TargetWidget}
                        elseif (self.HideByStateTagUIList[NormalStateSubState][UIName] == nil) then
                            self.HideByStateTagUIList[NormalStateSubState][UIName] = {TargetWidget}
                        else
                            table.insert(self.HideByStateTagUIList[NormalStateSubState][UIName], TargetWidget)
                        end
                    end
                end
            else
                -- 如果有非同组界面创建，也一并隐藏
                local IsNeedHide = true
                for _, _CheckUIName in ipairs(Value) do
                    if (_CheckUIName == UIName) then
                        IsNeedHide = false
                    end
                end
                if (IsNeedHide) then
                    DebugPrint("UIManagerComponent GroupMode: The UI Which Named "..UIName.." Hide, The Reason is Effected by "..CheckUIName)
                    IsHideCurUIObj = true
                    UIObj:Hide(ReasonString..CheckUIName) 
                    if (self.HideByStateTagUIList[NormalStateSubState] == nil) then
                        self.HideByStateTagUIList[NormalStateSubState] = {}
                        self.HideByStateTagUIList[NormalStateSubState][CheckUIName] = {UIObj}
                    elseif (self.HideByStateTagUIList[NormalStateSubState][CheckUIName] == nil) then
                        self.HideByStateTagUIList[NormalStateSubState][CheckUIName] = {UIObj}
                    else
                        table.insert(self.HideByStateTagUIList[NormalStateSubState][CheckUIName], UIObj)
                    end
                end
            end
        end
    end
    return IsHideCurUIObj
end

--隐藏/恢复特定的Entity方法
--function BP_UIManagerComponent_C:SetEntitiesVisibility(UIName, UIConfig, ShouldHide)
--    -- 其他模式的显隐走自己的接口去设置
--    if (UIConfig.IsHideBattleUnit ~= UIConst.EnumHideBattleUnitStyle.NormalShowAndHideAll and 
--        UIConfig.IsHideBattleUnit ~= UIConst.EnumHideBattleUnitStyle.NormalShowAndHideAllExceptSelf) then
--        return
--    end
--
--    local HideActorEffectCreatures = function(Actor, ShouldHide)
--        if Actor.EffectCreatures then
--            for _, value in pairs(Actor.EffectCreatures) do
--                for _, obj in pairs(value) do
--                    if IsValid(obj) then
--                        if (obj.HideEffectCreatureByTag) then
--                            obj:HideEffectCreatureByTag(UIName, ShouldHide)
--                        elseif (obj.SetActorHideTag) then
--                            obj:SetActorHideTag(UIName, ShouldHide)
--                        else
--                            obj:SetActorHiddenInGame(ShouldHide)
--                        end
--                    end
--                end
--            end
--        end
--    end
--    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
--    if not IsValid(Player) then
--        return
--    end
--    -- 只有NormalHideAll才会对主角进行操作
--    if (UIConfig.IsHideBattleUnit == UIConst.EnumHideBattleUnitStyle.NormalShowAndHideAll) then
--        Player:SetActorHideTag(UIName, ShouldHide)
--        HideActorEffectCreatures(Player,ShouldHide)
--    end
--    
--    local BattlePet = Player:GetBattlePet()
--    if BattlePet then
--        BattlePet:HideBattlePet(UIName,ShouldHide)
--    end
--
--    local Entities = Battle(self):GetAllEntities()
--    for _, entity in pairs(Entities) do
--        if IsValid(entity) then
--            if (entity.IsMonster and entity:IsMonster()) or 
--            (entity.IsMechanismSummon and entity:IsMechanismSummon()) or 
--            (entity.IsSummonMonster and entity:IsSummonMonster()) or
--            (entity.IsSkillCreature and entity:IsSkillCreature())  then
--            -- (entity.IsCombatItemBasethen and entity:IsCombatItemBasethen()) 
--                if entity.SetActorHideTag then
--                    entity:SetActorHideTag(UIName, ShouldHide)
--                else
--                    entity:SetActorHiddenInGame(ShouldHide)
--                end
--                HideActorEffectCreatures(entity,ShouldHide)
--            end
--        end
--    end
--end

-- 当UI对象加载完成时调用
function BP_UIManagerComponent_C:OnUIObjLoadCompleted(UIName, UIConfig)
--region 隐藏特定的Entity
    self:SetEntitiesVisibility(UIName, UIConfig.IsHideBattleUnit == UIConst.EnumHideBattleUnitStyle.NormalShowAndHideAll,
            UIConfig.IsHideBattleUnit == UIConst.EnumHideBattleUnitStyle.NormalShowAndHideAllExceptSelf, true)
--[[
    if (UIConfig.IsHideBattleUnit) then
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
        Player:SetActorHideTag(UIName, true)
        if Player.EffectCreatures then
            for _, value in pairs(Player.EffectCreatures) do
                for _, obj in pairs(value) do
                    if(IsValid(obj) and obj.SetActorHiddenInGame)then
                        obj:SetActorHiddenInGame(true)
                    end
                end
            end
        end
        local Entities = Battle(self):GetAllEntities()
        for _, entity in pairs(Entities) do
            if IsValid(entity) then
                if (entity.IsMonster and entity:IsMonster())
                    or (entity.IsMechanismSummon and entity:IsMechanismSummon())
                    or (entity.IsSummonMonster and entity:IsSummonMonster())  or
                    (entity.IsSkillCreature and entity:IsSkillCreature()) then
                    if(entity.SetActorHideTag) then
                        entity:SetActorHideTag(UIName, true)
                    else
                        entity:SetActorHiddenInGame(true)
                    end
                end
            end
        end
    end
    --]]
--endregion
    if (UIConfig.IsHideDrop) then
        self:SetAllBattleEntityHidden(true, UIName, "Drop")
    end
    EventManager:FireEvent(EventID.LoadUI, UIName)
end

function BP_UIManagerComponent_C:UnLoadUINew(UIName)
    local SystemUIConfig = DataMgr.SystemUI[UIName]
    assert(SystemUIConfig, "UI:" .. UIName .. "不在SystemUI表中")
    if UIConst.AllUIConfig[UIName] then
        UIConst.AllUIConfig[UIName] = {
            resource = UIConst.LoadInConfig
        }
    end
    return self:UnLoadUI(UIName, UIName)
end

function BP_UIManagerComponent_C:UnLoadUI(UIConfigName, UIName)
    if IsDedicatedServer(self) then
        return
    end
    -- UIConfigName为UIConst里面配置的Name，UIName为UI实际的名字。一般情况下两者相同（同时会出现多个类型的UI两者不同）
    UIName = UIName or UIConfigName
    local UIConfig = UIConst.AllUIConfig[UIConfigName] or {}
    local SystemUI = DataMgr.SystemUI[UIName]
    if (SystemUI == nil) then
        SystemUI = DataMgr.SystemUI[UIConfigName]
    end
    if (SystemUI ~= nil) then
        UIConfig["popup"] = SystemUI.Popup or UIConfig["popup"]
        UIConfig["statetag"] = SystemUI.StateTag
        UIConfig["IsStopGame"]= self:RevertRealStopGame(SystemUI.IsStopGame)
        UIConfig["GlobalGameUITag"]= SystemUI.GlobalGameUITag
        UIConfig["IsHideBattleUnit"]= SystemUI.IsHideBattleUnit
        UIConfig["IsHideDrop"]= SystemUI.IsHideDrop
        UIConfig["PauseAfterLoadingState"] = SystemUI.PauseAfterLoadingState

        if SystemUI.ConfigName then
            local SystemUIConfig=DataMgr.SystemUIConfig[SystemUI.ConfigName]
            if (SystemUIConfig) then
                UIConfig["addtostack"]=SystemUIConfig.AddToStack
                UIConfig["StopWorldRender"]=SystemUIConfig.StopWorldRender
            end
        end
    end

    if (UIConfig["popup"] == true) then
        self:OpenResidentUI(UIName)
    end
    -- 清除一些显隐状态
    self:DealWithOtherWidgetsVisibilityByUIHide(UIConfigName, UIName, UIConfig["statetag"])

    -- 跳转队列
    local UIObj = self:GetUIObj(UIName)
    if (UIObj and UIObj.IsAddInDeque) then
        self:RemoveToJumpPageDeque(UIObj)
    end
--region 恢复隐藏特定的Entity
    self:SetEntitiesVisibility(UIConfigName, UIConfig.IsHideBattleUnit == UIConst.EnumHideBattleUnitStyle.NormalShowAndHideAll,
            UIConfig.IsHideBattleUnit == UIConst.EnumHideBattleUnitStyle.NormalShowAndHideAllExceptSelf, false)
--[[    
    if UIConfig.IsHideBattleUnit then
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
        Player:SetActorHideTag(UIName, false)
        if Player.EffectCreatures then
            for _, value in pairs(Player.EffectCreatures) do
                for _, obj in pairs(value) do
                    if IsValid(obj) and obj.SetActorHiddenInGame then
                        obj:SetActorHiddenInGame(false)
                    end
                end
            end
        end
        local Entities = Battle(self):GetAllEntities()
        for _, entity in pairs(Entities) do
            if IsValid(entity) then
                if (entity.IsMonster and entity:IsMonster())
                    or (entity.IsMechanismSummon and entity:IsMechanismSummon())
                    or (entity.IsSummonMonster and entity:IsSummonMonster())  then
                        if(entity.SetActorHideTag)then
                            entity:SetActorHideTag(UIName, false)
                        else
                            entity:SetActorHiddenInGame(false)
                        end
                end
            end
        end
    end
    ]]
--endregion
    if (UIConfig.IsHideDrop) then
        self:SetAllBattleEntityHidden(false, UIConfigName, "Drop")
    end

    if (UIConfig.PauseAfterLoadingState and UIObj) then
        self:TryResumeAfterLoadingMgr(UIConfig.PauseAfterLoadingState)
    end

    if (UIConfig["IsGlobalUI"]) then
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        GameInstance:CloseGlobalUI(UIName)
    else
        -- IsNeedSearchInStack 为True时，表示需要搜寻UI在Stack之中的位置。如果有一些非常规需求之中，比如某个在Stack之中但是并非是当前最顶层的界面，期望关闭它时需要设置此变量
        local bIsRemoveInStack = not not UIConfig["addtostack"]
        self:UnLoadUI_CPP(UIName, bIsRemoveInStack, UIObj and UIObj.IsNeedSearchInStack)
        -- self.Overridden.UnLoadUI(self, UIName, IsRemoveInStack, UIObj and UIObj.IsNeedSearchInStack)
    end

    --region 处理异步加载的句柄
    if (self.AsyncLoadHandlers[UIConfigName]) then
        self.AsyncUnloadFlags[UIConfigName] = true
    end
    --endregion

    EventManager:FireEvent(EventID.UnLoadUI, UIName)

    -- 移除Flow
    if (self.FlowList[UIName]) then
        local flow = self.FlowList[UIName]
        self.FlowList[UIName] = nil
        GameFlowUtils:RemoveFlow(flow)
        DebugPrint("WXT UIManagerComponent_C:RemoveFlow", UIName)
    end
end

-- 更新UI显隐状态列表（在界面关闭后）
---@param UIName string 界面名称
---@param UIStatetag number 界面状态标签
function BP_UIManagerComponent_C:DealWithOtherWidgetsVisibilityByUIHide(UIConfigName, UIName, UIStatetag)
    if (UIStatetag == nil or UIStatetag == UIConst.WidgetAllStateTag.Blocked) then
        return
    end
    self:AddUIToStateTagsCluster(UIStatetag, UIName, false)
    -- 一些显隐状态，需要在界面关闭的时候恢复一下状态
    if (UIStatetag == UIConst.WidgetAllStateTag.Queue) then
        if (self.UILoadingDeque:Size() > 0) then
            local NextLoadUI = self.UILoadingDeque:PopFront()
            self:AddTimer(0.1, self.LoadUINew, false, 0, "LoadUIInQueue", nil, NextLoadUI.UIName, table.unpack(NextLoadUI.Params))
        end
    else
        self:HandleUIWidgetsVisibilityByUIHide(UIConfigName, UIName, UIStatetag)
    end
end

-- 实际处理相关的可见性(UI移除的时候)
function BP_UIManagerComponent_C:HandleUIWidgetsVisibilityByUIHide(UIConfigName, UIName, UIStatetag)
    local HideUIList, ReShowUIWithReasonStr = nil, "InUIConfigure"
    if (UIStatetag == UIConst.WidgetAllStateTag.Exclusive) then
        local AllExclusiveUI = self.AllUIStateTagsCluster[UIStatetag]
        if (IsEmptyTable(AllExclusiveUI)) then
            HideUIList = self.HideByStateTagUIList[ENormalModeSubState.ExclusiveMode]
            self:ReShowUIWithReason(HideUIList, ReShowUIWithReasonStr..ENormalModeSubState.ExclusiveMode)
            self.HideByStateTagUIList[ENormalModeSubState.ExclusiveMode] = nil
        end
        return     
    end

    local ConditionUIList = self.HideByStateTagUIList[ENormalModeSubState.ConditionMode]
    if (UIStatetag == UIConst.WidgetAllStateTag.Precedence or UIStatetag == UIConst.WidgetAllStateTag.Group) then
        -- 被Precedence、Group类型UI的影响到的其他UI，在这里进行恢复
        if (ConditionUIList ~= nil) then
            if (UIConfigName ~= nil) then
                HideUIList = ConditionUIList[UIConfigName]
                ConditionUIList[UIConfigName] = nil
                self:ReShowUIWithReason(HideUIList, ReShowUIWithReasonStr..UIConfigName)
            else
                HideUIList = ConditionUIList[UIName]
                ConditionUIList[UIName] = nil
                self:ReShowUIWithReason(HideUIList, ReShowUIWithReasonStr..UIName)
            end
        end
    end

    if (not IsEmptyTable(ConditionUIList)) then
        -- 被Mutual类型UI的影响到的其他UI，在这里进行恢复
        for k, v in pairs(ConditionUIList) do
            if (type(v) == "table") then
                local NeedRemoveIndex = nil
                for Index, CheckName in ipairs(v) do
                    if (CheckName == UIConfigName) then
                        NeedRemoveIndex = Index
                        break
                    end
                end
                if (NeedRemoveIndex) then
                    local NeedShowUI = self:GetUIObj(k)
                    if (NeedShowUI) then
                        NeedShowUI:Show(ReShowUIWithReasonStr..v[NeedRemoveIndex]) 
                    end
                    table.remove(v, NeedRemoveIndex)
                    -- self.HideByStateTagUIList[ENormalModeSubState.ConditionMode][k] = v 
                end
            end
        end
    end
end

-- 根据一些逻辑显示特定UI
function BP_UIManagerComponent_C:ReShowUIWithReason(UIList, ReasonString)
    if (UIList == nil or type(UIList) ~= "table") then
        return
    end
    for i, v in ipairs(UIList) do
        local UIWidget = v
        if (type(v) == "string") then
            UIWidget = self:GetUIObj(v)
        end
        if (IsValid(UIWidget)) then
            UIWidget:Show(ReasonString) 
        end 
    end
end

-- 获取UI对象
function BP_UIManagerComponent_C:GetUIObj(UIName, bUseRegularMatch)
    if (bUseRegularMatch) then
        local UIPathes = self:GetUIPathFromString(UIName)
        local len = #UIPathes
        if (len > 1) then
            local root_ui = self:GetUI(UIPathes[1])
            for i=2,len do
                root_ui = root_ui[UIPathes[i]]
            end
            return root_ui
        end
    end
    return self:GetUI(UIName)
end

-- 获取UI对象异步
---@param CoroutineOrCBFunc function|thread 协程或者回调函数
---@return UUIState
function BP_UIManagerComponent_C:GetUIObjAsync(UIName, CoroutineOrCBFunc)
    local UI = self:GetUIObj(UIName)
    if not UI and self.AsyncLoadHandlers[UIName] then
        DebugPrint(LXYTag, "开始异步GetUIObj...", UIName)
        if not self.AsyncGetUIContexts[UIName] then
            self.AsyncGetUIContexts[UIName] = {}
        end
        table.insert(self.AsyncGetUIContexts[UIName], CoroutineOrCBFunc)
        if type(CoroutineOrCBFunc) == "thread" then
            UI = coroutine.yield()
            return UI
        end
    end
    if type(CoroutineOrCBFunc) == "function" then
        CoroutineOrCBFunc(UI)
    end
    return UI
end

-- 获取UI对象是否正在异步加载
function BP_UIManagerComponent_C:GetUIObjIsAsyncLoading(UIName)
    return self.AsyncLoadHandlers[UIName] ~= nil
end

-- 从字符串中获取UI路径
function BP_UIManagerComponent_C:GetUIPathFromString(InputString)
    if not InputString then
        return nil
    end
    local Parents = {}
    for v in string.gmatch(InputString, "%a+[_%a+%d*]*") do
        table.insert(Parents,v)
    end
    return Parents
end

-- 根据ConfigName获取UI对象数量
function BP_UIManagerComponent_C:GetUIObjCountByBaseName(UIName)
    return self.Overridden.GetUIObjCountByBaseName(self,UIName)
end

-- 根据ConfigName隐藏或显示UI
function BP_UIManagerComponent_C:HideOrShowUIByBaseName(UIName, IsShow)
    local UIConfig = UIConst.AllUIConfig[UIName] or {}
    if (UIConfig["allowmulti"]) then
        local UICount = self.UniqueCount[UIName] or 1
        for i = 1, UICount, 1 do
            local FinalName = UIName..tostring(i)
            local ExistUIObj = self:GetUI(FinalName)
            if (ExistUIObj ~= nil) then
                if (IsShow) then
                    ExistUIObj:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible) 
                else
                    ExistUIObj:SetVisibility(UE4.ESlateVisibility.Collapsed)
                end
            end
        end
    else
        local ExistUIObj = self:GetUI(UIName)
        if (ExistUIObj ~= nil) then
            if (IsShow) then
                ExistUIObj:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            else
                ExistUIObj:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
        end
    end
end

-- 获取纹理资源
function BP_UIManagerComponent_C:GetTexture2DResource(TexturePath)
    if string.find(TexturePath, "/Game/") == nil then
        TexturePath = '/Game/'..TexturePath
    end
    local ImageResource = LoadObject(TexturePath)
    return ImageResource
end

-- 获取日志掩码
function BP_UIManagerComponent_C:GetLogMask()
    return _G.LogTag
end

-- From UIManagerComponent.cpp
-- function BP_UIManagerComponent_C:GetViewportSize()
--     -- 获取当前游戏视口大小，比如1024*720
--     local ScreenSize = FVector2D(0, 0)
--     UE4.UWidgetLayoutLibrary.GetViewportSize(self, ScreenSize)
--     return ScreenSize
-- end

-- From UIManagerComponent.cpp
-- function BP_UIManagerComponent_C:GetDesignedScreenSize()
--     -- UI设计时屏幕基准大小（当游戏运行时候的视口大小刚好与UI设计时大小不一致时候会进行一定规则的缩放）
--     local ScreenSize = self:GetViewportSize()
--     local DesignedSizeX = ScreenSize.X / UE4.UWidgetLayoutLibrary.GetViewportScale(self)
--     local DesignedSizeY = ScreenSize.Y / UE4.UWidgetLayoutLibrary.GetViewportScale(self)
--     return FVector2D(DesignedSizeX, DesignedSizeY)
-- end

-- 判断是否需要再次进行一次PopUp的显示
function BP_UIManagerComponent_C:CheckIsExistPopUpWidget()
    local bIsExistPopUp = false
    for key, value in pairs(self.PopUpUIWidgetRecord) do
        local CheckUIWidget = self:GetUIObj(key)
        if (CheckUIWidget and not CheckUIWidget:IsBeingRemoveState()) then
            -- 界面存在且没有处于待移除状态
            if (not CheckUIWidget:IsHide()) then
                -- 当然存在PopUp界面且显示着，则不需要重新PopUp
                bIsExistPopUp = true
                break
            elseif (CheckUIWidget:IsOnlyHideWithDesireTag(UIConst.CommonHideTagName.UIStackChange)) then
                -- 虽然界面是隐藏状态，但是是因为UI堆栈变化导致的隐藏，则也认为是PopUp状态
                bIsExistPopUp = true
                break
            end
        end
    end
    return bIsExistPopUp
end

-- 隐藏常驻UI
function BP_UIManagerComponent_C:CloseResidentUI(PopUIName)
    DebugPrint("HY@ UIManagerComponent CloseResidentUI:", PopUIName)
    if (self:CheckIsExistPopUpWidget()) then
        -- 已经是PopUp状态了，只需要记录值
        if (PopUIName ~= nil) then
            self.PopUpUIWidgetRecord[PopUIName] = 1
        end
        return
    end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if Player then
        Player:SetCanInteractiveTrigger(false)
    end
    --self:InactivateVirtualJoystick()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
	local SceneMgrComponent = GameInstance:GetSceneManager()
    if (IsValid(SceneMgrComponent)) then
        SceneMgrComponent:ShowOrHideAllSceneGuideIcon(false, "UIPopUp") 
    end
    self:HideAllComponentUI(true, "UIPopUp")
    local Result = self:GetCurrnetAllUIBySystem(UIConst.PopUpUIName.SpecificSystemList)
    for i, v in ipairs(UIConst.PopUpUIName.SpecificUIList) do
        if (Result[v] == nil) then
            local UIWidget = self:GetUI(v)
            if (UIWidget ~= nil) then
                Result[v] = UIWidget
            end
        end 
    end

    for UIName, Widget in pairs(Result) do
        if UIName =='BattleMain' then
            if not Widget.IsPlayOutAnim then
                Widget:Hide("UIPopUp")
                Widget:AddPlayInOutSystems(PopUIName)
            end
        else
            Widget:Hide("UIPopUp")
        end
    end

    -- for _, v in pairs(UIConst.TASKINDICATORUI) do
    --     Result = self:GetAllUINameByBPClass(UE4.UClass.Load(v))
    --     for i = 1, Result:Length() do
    --         local UIName = Result:GetRef(i)
    --         local UIObj = self:GetUIObj(UIName)
    --         UIObj:Hide("UIPopUp")
    --     end
    -- end

    local Objs = MissionIndicatorManager:GetAllIndicatorUIObjs()
    if not IsEmptyTable(Objs) then
        for Name, UIObj in pairs(Objs) do
            UIObj:Hide("UIPopUp")
        end
    end

    if (PopUIName ~= nil) then
        self.PopUpUIWidgetRecord[PopUIName] = 1
    end
end

-- 恢复常驻UI的显示
function BP_UIManagerComponent_C:OpenResidentUI(PopUIName)
    DebugPrint("HY@ UIManagerComponent OpenResidentUI:", PopUIName)
    if (PopUIName ~= nil) then
        -- 恢复一下记录的值
        self.PopUpUIWidgetRecord[PopUIName] = nil 
    end
    if (self:CheckIsExistPopUpWidget()) then
        -- 仍然需要保持PopUp，不需要恢复
        return
    end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if Player then
        Player:SetCanInteractiveTrigger(true)
    end
    --self:ActivateVirtualJoystick()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
	local SceneMgrComponent = GameInstance:GetSceneManager()
    if (IsValid(SceneMgrComponent)) then
        SceneMgrComponent:ShowOrHideAllSceneGuideIcon(true, "UIPopUp") 
    end
    self:HideAllComponentUI(false, "UIPopUp")
    local Result = self:GetCurrnetAllUIBySystem(UIConst.PopUpUIName.SpecificSystemList)
    for i, v in ipairs(UIConst.PopUpUIName.SpecificUIList) do
        if (Result[v] == nil) then
            local UIWidget = self:GetUI(v)
            if (UIWidget ~= nil) then
                Result[v] = UIWidget
            end
        end 
    end
    for UIName, Widget in pairs(Result) do
        if UIName == 'BattleMain' then
            local Player =UE4.UGameplayStatics.GetPlayerCharacter(self,0)
            if Player and Player.CleanInputWhenEnterTalk then
                Player:CleanInputWhenEnterTalk(false)
            end
            -- 主界面自己监听了界面的关闭逻辑，统一进行了移除，因此不需要这里手动移除
            -- Widget:RemovePlayInOutSystems(PopUIName)
        end
        Widget:Show("UIPopUp")
    end
    -- for _, v in pairs(UIConst.TASKINDICATORUI) do
    --     Result = self:GetAllUINameByBPClass(UE4.UClass.Load(v))
    --     for i = 1, Result:Length() do
    --         local UIName = Result:GetRef(i)
    --         local UIObj = self:GetUIObj(UIName)
    --         UIObj:Show("UIPopUp")
    --     end
    -- end
    local Objs = MissionIndicatorManager:GetAllIndicatorUIObjs()
    if not IsEmptyTable(Objs) then
        for Name, UIObj in pairs(Objs) do
            UIObj:Show("UIPopUp")
        end
    end
end

-- 检查是否需要恢复PopUp
function BP_UIManagerComponent_C:CheckNeedExitPopUp(ExceptUIName)
    local NeedRecover = true
    for k, v in pairs(self.PopUpUIWidgetRecord) do
        if (k ~= ExceptUIName and v == 1) then
            NeedRecover = false
            break
        end
    end
    return NeedRecover
end

-- TODO可以迁移到C++
-- 获取当前所属系统的所有UI
function BP_UIManagerComponent_C:GetCurrnetAllUIBySystem(SystemList)
    local AllUI, Result = self.UIInstances:ToTable(), {}
    for _, Widget in pairs(AllUI) do
        local ConfigUIName = Widget.ConfigName or Widget.WidgetName
        local UIConfigData = DataMgr.SystemUI[ConfigUIName]
        if (UIConfigData ~= nil) then
            local IsNeedAddInList = false
            for i, SystemName in ipairs(SystemList) do
                if (UIConfigData.System == SystemName) then
                    IsNeedAddInList = true
                    break
                end
            end
            if (IsNeedAddInList) then
                Result[ConfigUIName] = Widget 
            end
        end
    end
    return Result
end

function BP_UIManagerComponent_C:GetUIManagerShowStateInViewport()
    local BattleWidget = self:GetUIObj("BattleMain")
    if (BattleWidget) then
        if (BattleWidget:IsInViewport() and BattleWidget:IsVisible()) then
            return UIConst.GameUIShowState.HUD
        else
            return UIConst.GameUIShowState.System
        end
    end
end

-- 判断是否在HUD显示模式下
function BP_UIManagerComponent_C:IsInHUDShowMode()
    return self:GetUIManagerShowStateInViewport() == UIConst.GameUIShowState.HUD
end

--region 一些外部调用的系统向接口
-- 显示通用弹窗，适配老弹窗参数
function BP_UIManagerComponent_C:ShowCommonPopupUI_Old(PopupId, CallbackObj, YesCallBackFunction, NoCallBackFunction, BlankAreaClicked, OverrideText)
    ---@type Common_Dialog_Params
    local Params = {}
    Params.LeftCallbackFunction = NoCallBackFunction
    Params.LeftCallbackObj = CallbackObj
    Params.RightCallbackFunction = YesCallBackFunction 
    Params.RightCallbackObj = CallbackObj
    Params.CloseBtnCallbackFunction = BlankAreaClicked 
    Params.CloseBtnCallbackObj = CallbackObj
    Params.ShortText = OverrideText
    Params.LongText = OverrideText
    return self:ShowCommonPopupUI(PopupId, Params)
end

function BP_UIManagerComponent_C:ShowDisconnectUIConfirm(PopupId, IsStopGame, Params)
    ---@type Common_Dialog_Params
    local DisconnectUIName = "NetDisConnectedDialog"
    if (UIConst.AllUIConfig[DisconnectUIName] == nil) then
        -- 把表里的数据读出来
        local NewUIConfig = self:SetUIConfig(UIConst.LoadInConfig, DisconnectUIName, DataMgr.SystemUI[DisconnectUIName])
        UIConst.AllUIConfig[DisconnectUIName] = NewUIConfig
    end
    UIConst.AllUIConfig[DisconnectUIName].IsStopGame = IsStopGame
    local PopupUI = self:LoadUI(UIConst.AllUIConfig[DisconnectUIName].resource, DisconnectUIName) 
    if (PopupUI ~= nil) then
        Params = Params or {}
        Params.OnCloseCallbackFunction = function ()
            EventManager:FireEvent(EventID.OnToggleDisconnectUI, false)
        end
        EventManager:FireEvent(EventID.OnToggleDisconnectUI, true)

        PopupUI:ShowPopup(PopupId, Params)
        local StorySubsystem = UEMCommonInputSubsystem.Get(self)
        if(StorySubsystem)then
            StorySubsystem:ClearUIInputBlock()
        end
    end
    return PopupUI
end

---private 不可滥用
function BP_UIManagerComponent_C:_BlockAllUIInput(bBlock, Reason)
    local LoadingReconnectUi = self:GetUIObj("LoadingReconnect")
    if bBlock==false then
        if LoadingReconnectUi and LoadingReconnectUi.bDisplayOnly then
            LoadingReconnectUi:Close()
        end
        if self:IsExistTimer(self.ReconnectUITimer) then
            self:RemoveTimer(self.ReconnectUITimer)
        end
        self.BlockingReasons[Reason]=nil
    else
        if not LoadingReconnectUi and Reason ~="SP_DisplayOnly" then
            if self:IsExistTimer(self.ReconnectUITimer) then
                self:RemoveTimer(self.ReconnectUITimer)
            end
            local _,TimerKey = self:AddTimer(UIConst.BlockingTime, function()
                if not self:GetUIObj("LoadingReconnect") then
                    self:LoadUINew("LoadingReconnect",true)
                end
            end)
            self.ReconnectUITimer = TimerKey
        end
        if not self.BlockingReasons then
            self.BlockingReasons = {}
        end
        self.BlockingReasons[Reason]=1
    end
    DebugPrint(WarningTag, string.format("BP_UIManagerComponent_C:_BlockAllUIInput(%s, %s)",bBlock, Reason))
    self:BlockAllUIInput(bBlock, Reason)
end

-- 显示通用弹窗
function BP_UIManagerComponent_C:ShowCommonPopupUI(PopupId, Params, ParentWidget, Coroutine, ZOrderOverride)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    
    -- 如果当前不允许弹窗，缓存下来直到允许弹窗为止
    if not GameInstance:CheckCanShowPopup() then 
        GameInstance:RequestShowPopup(PopupId, Params, ParentWidget)
        return
    end

    local PopupData = DataMgr.CommonPopupUIContext[PopupId]
    local PopupStyle = DataMgr.CommonPopupUIStyle[PopupData.Style]
    local PopupUI = nil

    local SystemUIConfig = DataMgr.SystemUI["CommonDialog"]
    local Param = {}
    if Coroutine then
        table.insert(Param, Coroutine)
        table.insert(Param, "Async")
        PopupUI = self:LoadUI(UIConst.LoadInConfig, "CommonDialog", ZOrderOverride or SystemUIConfig.ZOrder, table.unpack(Param))
    else
        PopupUI = self:LoadUI(UIConst.LoadInConfig, "CommonDialog", ZOrderOverride or SystemUIConfig.ZOrder, table.unpack(Param))
    end
    PopupUI:ShowPopup(PopupId, Params, ParentWidget)
    if Params and Params.BindScript and PopupUI.Script then
        return PopupUI.Script
    else
        return PopupUI
    end
end

-- 插队显示通用弹窗，不销毁当前弹窗
function BP_UIManagerComponent_C:ShowCommonPopupUI_Push(PopupId, Params, ParentWidget)
    local CommonDialog = self:GetUI("CommonDialog")
    if not CommonDialog then
        return self:ShowCommonPopupUI(PopupId, Params, ParentWidget)
    end
    CommonDialog:ShowPopupPush(PopupId, Params, ParentWidget)
    return CommonDialog
end

--[[
ShowCommonPopupUI_Suspend 用法：
- 挂起当前 CommonDialog，显示新弹窗
- Params.SuspendAutoResume 默认 true：关闭后恢复
- 设为 false：关闭后不恢复，并关闭原 CommonDialog
- 返回 PopupUI，可改 PopupUI.SuspendAutoResume
- 右键回调可设为 false；左键回调设为 true
- 关闭按开关：true→Show("Suspend")；false→Close()
]]
function BP_UIManagerComponent_C:ShowCommonPopupUI_Suspend(PopupId, Params, ParentWidget)
    local CommonDialog = self:GetUI("CommonDialog")
    if not CommonDialog then
        return self:ShowCommonPopupUI(PopupId, Params, ParentWidget)
    end
    CommonDialog:Hide("Suspend")
    local SystemUIConfig = DataMgr.SystemUI["CommonDialog"]
    local PopupUI = self:LoadUI(UIConst.LoadInConfig, "CommonDialog#CommonDialog_Suspend", SystemUIConfig.ZOrder)
    local NewParams = {}
    if Params then
        for k,v in pairs(Params) do NewParams[k]=v end
    end
    local AutoResume = NewParams.SuspendAutoResume
    if AutoResume == nil then AutoResume = true end
    PopupUI.SuspendAutoResume = AutoResume
    NewParams.OnCloseCallbackFunction = function ()
        if IsValid(CommonDialog) then
            if PopupUI.SuspendAutoResume then
                CommonDialog:Show("Suspend")
            else
                CommonDialog:Close()
            end
        end
    end
    PopupUI:ShowPopup(PopupId, NewParams, ParentWidget)
    return PopupUI
end

-- 关闭当前弹窗，根据新参数显示一个新的弹窗，当新弹窗关闭后，重新打开当前弹窗
-- 注意重新打开当前弹窗后，数据都会被重置
function BP_UIManagerComponent_C:ShowCommonPopupUI_Interrupt(PopupId, Params, ParentWidget)
    local CommonDialog = self:GetUI("CommonDialog")
    if not CommonDialog then
        DebugPrint("Tianyi@ ShowCommonPopupUI_Interrupt 只能在通用弹窗显示出来的时候调用!")
        return
    end

    CommonDialog:ShowPopupInterrupt(PopupId, Params, ParentWidget)
    return CommonDialog
end

-- 预览通用弹窗样式
function BP_UIManagerComponent_C:PreviewCommonPopupStyle(StyleId)
    local PopupStyle = DataMgr.CommonPopupUIStyle[StyleId]
    if not PopupStyle then 
        DebugPrint("TianyI@ PopupStyle is nil")
        return 
    end

    local PopupWidget = self:LoadUINew("CommonDialog")
    PopupWidget:PlayAnimation(PopupWidget.In)
    PopupWidget:UpdateView(StyleId)
end

-- 获取游戏输入模式子系统
function BP_UIManagerComponent_C:GetGameInputModeSubsystem()
    if not self.GameInputModeSubsystem then
        self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(GWorld.GameInstance)
    end
    return self.GameInputModeSubsystem
end

-- 显示错误信息
---@param ErrCode number 错误码
---@param Duration number 显示时间
---@param TipType number 提示类型
---@param ... any 参数
function BP_UIManagerComponent_C:ShowError(ErrCode,Duration,TipType,...)
    if TipType == nil then TipType = UIConst.Tip_CommonTop end
    local Err = DataMgr.ErrorCode[ErrCode]
    if Err then
        local Content = ErrorCode:GetText(ErrCode)
        Content = string.format(Content or "",...)
        if not Content or Content == "" then
            self:ShowUITip(TipType, "Unconfigured ErrorCode：" .. tostring(ErrCode),Duration)
        else
            self:ShowUITip(TipType, Content,Duration)
        end
    else
        self:ShowUITip(TipType, "Unknown ErrorCode：" .. tostring(ErrCode),Duration)
    end
end

-- 显示提示信息（通用Tips）
---@param TipType number 提示类型
---@param TipContent string 提示内容
---@param LastTime number 显示时间
---@param IsWaitToTrigger boolean 是否等待触发
---@param ExtraData table 额外数据
function BP_UIManagerComponent_C:ShowUITip(TipType, TipContent, LastTime, IsWaitToTrigger, ExtraData)
    if not ExtraData then ExtraData = {} end
    --if IsClient(self) and self:IsPlayer() and MiscUtils.IsAutonomousProxy(self) then
        LastTime = LastTime or 2.0
        if (TipType == UIConst.Tip_Quest) then
            -- 剧情任务里用
            if (type(TipContent) == "table") then
                -- 目前仅支持两个
                local TaskStateInfo = ExtraData.TaskStateStr
                local UITips = UE4.UUIStateAsyncActionBase.ShowQuestBeginEndTip(self, TipContent[1], TaskStateInfo[1], LastTime) 
                UITips.OnGuideEnd:Add(self, function () UE4.UUIStateAsyncActionBase.ShowQuestBeginEndTip(self, TipContent[2], TaskStateInfo[2], LastTime) end)
            else
                if (IsWaitToTrigger) then
                    self.WaitToTriggerTipsInfo[TipType] = {Content=TipContent, Extra=ExtraData}
                else
                    local WaitToTriggerTipsInfo = self.WaitToTriggerTipsInfo[TipType]
                    if (WaitToTriggerTipsInfo) then
                        local UITips = UE4.UUIStateAsyncActionBase.ShowQuestBeginEndTip(self, WaitToTriggerTipsInfo.Content, 
                                                                                        WaitToTriggerTipsInfo.Extra.TaskStateStr, LastTime) 
                        UITips.OnGuideEnd:Add(self, function () UE4.UUIStateAsyncActionBase.ShowQuestBeginEndTip(self, TipContent, ExtraData.TaskStateStr, LastTime) end)
                        self.WaitToTriggerTipsInfo[TipType] = nil
                    else
                        local QuestBeginEnd = self:GetUI("QuestBeginEnd")
                        if QuestBeginEnd and QuestBeginEnd.IsShowing then
                            print(_G.LogTag,"BP_UIManagerComponent_C:ShowUITip Now Tip Is Showing,Discard This Tip, Id: ",TipContent)
                            return
                        end
                        UE4.UUIStateAsyncActionBase.ShowQuestBeginEndTip(self, TipContent, ExtraData.TaskStateStr, LastTime)   
                    end
                end
            end 
        elseif (TipType == UIConst.Tip_CommonTop or TipType == UIConst.Tip_CommonToast) then 
            -- 战斗HUD里面用 (2024.9.19 界面里的也用此形式)
            TipContent = GText(TipContent)
            local UITipList = self:GetUI("CommonTopToastList")
            if (UITipList == nil) then
                UITipList = self:LoadUINew("CommonTopToastList", TipContent,LastTime)
            elseif (UITipList:IsHide()) then
				UITipList:ClearAllHideTags()
				UITipList:Show()
            end
            -- 更新当前现有的Tips
            local NextTipsIndex = UITipList:AddAndUpdateCurrentUITips()
            RunAsyncTask(self, TipContent..tostring(NextTipsIndex), function(CoroutineObj)
                local UITopTip = self:CreateWidgetAsync(DataMgr.WidgetUI.CommonToastItem.UIName, CoroutineObj)
                if (UITopTip ~= nil) then
                    UITopTip:SetNeedPaintDeferred(self.IsMenuAnchorOpen and not self:IsInHUDShowMode())
                    UITipList:AddNewUITips(UITopTip)
                    UITopTip:OnLoaded(TipContent, LastTime) 
                    if ExtraData.Color then 
                        UITopTip:ChangeFlashColor(ExtraData.Color)
                    end
                    -- 播放一个音效
				    AudioManager(self):PlayUISound(UITopTip, "event:/ui/common/toast_normal", nil, nil)
                end
            end)
		elseif (TipType == UIConst.Tip_CommonWarning) then
            -- 副本里用警告提示
            local WrapLoadWarningTip = function ()
                if IsValid(self.WarningToastUI) and not self.WarningToastUI.IsClose then
                    self.WarningToastUI:Close()
                end
                -- 进行异步加载（防止卡顿）
                if (not self:GetUIObjIsAsyncLoading("WarningToast")) then
                    RunAsyncTask(self, TipContent, function(CoroutineObj)
                        local UITopTip = self:LoadUIAsync("WarningToast", CoroutineObj, TipContent, LastTime)
                        -- local UITopTip = self:LoadUI(UIConst.WARNINGTOAST, "WarningToast", UIConst.ZORDER_FOR_TOP_TIP, TipContent, LastTime)
                        AudioManager(self):PlayUISound(UITopTip, "event:/ui/common/toast_warning", nil,nil)
                        local Pos = FVector2D(0,0)
                        UITopTip.Panel_Toast:SetRenderTranslation(Pos)
                        self.WarningToastUI = UITopTip
                        self.WarningToastUI.Panel_Toast:SetRenderOpacity(1.0)
                        if (ExtraData) then
                            self:HideWarningUITip(ExtraData)
                            UITopTip.MessageId = ExtraData
                        end
                    end)
                else
                    -- 策划说当前只会有一条显示内容，如果后续有需求可以把下面这段放开
                    -- 正在处于异步加载中，等加载完成后更新内容
                    -- self:GetUIObjAsync("WarningToast", function(UITopTip)
                    --     if UITopTip then
                    --         UITopTip:UpdateContent(TipContent)
                    --         if (ExtraData) then
                    --             self:HideWarningUITip(ExtraData)
                    --             UITopTip.MessageId = ExtraData
                    --         end
                    --     end
                    -- end)
                    DebugPrint("Hy@ UIManager:ShowUItip WarningToast, Async Loading Skip", TipContent)
                end
            end

            if IsValid(self.WarningToastUI) and not self.WarningToastUI.IsClose then
                self.WarningToastUI:BindToAnimationFinished(self.WarningToastUI.Out,{self.WarningToastUI, WrapLoadWarningTip})
                self.WarningToastUI:PlayAnimation(self.WarningToastUI.Out)
            else
                WrapLoadWarningTip()
            end
        elseif (TipType == UIConst.Tip_CombineWarning) then
            -- 组合型警告提示
            local WrapLoadWarningTip = function ()
                if IsValid(self.CombineWarningToastUI) and not self.CombineWarningToastUI.IsClose then
                    self.CombineWarningToastUI:Close()
                end
                -- 进行异步加载（防止卡顿）
                if (not self:GetUIObjIsAsyncLoading("CombineWarningToast")) then
                    RunAsyncTask(self, TipContent, function(CoroutineObj)
                        local UITopTip = self:LoadUIAsync("WarningToast02", CoroutineObj, TipContent, LastTime)
                        -- local UITopTip = self:LoadUI(UIConst.WARNINGTOAST, "WarningToast", UIConst.ZORDER_FOR_TOP_TIP, TipContent, LastTime)
                        AudioManager(self):PlayUISound(UITopTip, "event:/ui/common/toast_warning", nil,nil)
                        local Pos = FVector2D(0,0)
                        UITopTip.Panel_Toast:SetRenderTranslation(Pos)
                        self.CombineWarningToastUI = UITopTip
                        self.CombineWarningToastUI.Panel_Toast:SetRenderOpacity(1.0)
                        -- if (ExtraData) then
                        --     self:HideWarningUITip(ExtraData)
                        --     UITopTip.MessageId = ExtraData
                        -- end
                    end)
                end
            end

            WrapLoadWarningTip()
            -- if IsValid(self.CombineWarningToastUI) and not self.CombineWarningToastUI.IsClose then
            --     self.CombineWarningToastUI:BindToAnimationFinished(self.CombineWarningToastUI.Out,{self.CombineWarningToastUI, WrapLoadWarningTip})
            --     self.CombineWarningToastUI:PlayAnimation(self.CombineWarningToastUI.Out)
            -- else
            --     WrapLoadWarningTip()
            -- end
        elseif (TipType == UIConst.Tip_StoryToast) then
            -- 剧情系统里用，带去重和队列显示功能 @todo 队列的去重可能要考虑用TextMapId做key，因为文本有重复的
            if self._StoryToastSet[TipContent] then
                DebugPrint("UIManager:ShowUItip StoryToast, Repeat Toast", TipContent)
                return
            end
            self._StoryToastSet[TipContent] = true
            if self._StoryToastQueue:Size() > 0 and not ExtraData.bPopWait then
                self:_BreakInTopToastInQueue("_StoryToastQueue", "_StoryToastSet", 
                                                "_StoryToastTimer", "CommonStoryToast", ExtraData)
            end
            self._StoryToastQueue:PushFront({TipContent,LastTime})
            if not self:IsExistTimer(self._StoryToastTimer) then
                self:_ProcessCommonToastQueue("_StoryToastQueue", "_StoryToastSet", 
                                                "_StoryToastTimer", "CommonStoryToast", ExtraData)
            end
        elseif (TipType == UIConst.Tip_ExcavationToast) then
            -- 挖掘关的提示Toast
            local UITipList = self:GetUI("CommonTopToastList")
            if UITipList == nil then
                UITipList = self:LoadUINew("CommonTopToastList", TipContent,LastTime)
            end
            local ExcavationToast = self:CreateWidget(UIConst.EXCAVATIONDUNGEONTEXTFLOAT, false)
            UITipList.VerticalBox_Toast:AddChildToVerticalBox(ExcavationToast)
            ExcavationToast:OnLoaded(LastTime, TipContent, ExtraData.Level, ExtraData.OrderText)
        end
    --end
end

-- 依次处理弹条（通用Toast内部接口）
function BP_UIManagerComponent_C:_ProcessCommonToastQueue(QueneContainerName, SetContainerName, TimerKeyName, ToastUIName,ExtraData)
    local TipContent, ToastLastTime = table.unpack(self[QueneContainerName]:Back())
    local SoundEvent = ExtraData and ExtraData.SoundEvent or nil
    self:LoadUINew(ToastUIName,TipContent, ToastLastTime, SoundEvent)
    self:AddTimer(ToastLastTime+0.1, function()
        local ToastUI = self:GetUI(ToastUIName)
        if IsValid(ToastUI) then
            ToastUI:Close()
        end
        self:_DoPopNextToastQueue(QueneContainerName, SetContainerName, TimerKeyName, ToastUIName, ExtraData)
    end, false, 0, self[TimerKeyName],true)
end

-- 弹出下一个Toast（通用Toast内部接口）
function BP_UIManagerComponent_C:_DoPopNextToastQueue(QueneContainerName, SetContainerName, TimerKeyName, ToastUIName, ExtraData)
    local TipContent = table.unpack(self[QueneContainerName]:Back())
    self[QueneContainerName]:PopBack()
    if (self[SetContainerName] ~= nil) then
        self[SetContainerName][TipContent] = nil
    end
    if not self[QueneContainerName]:IsEmpty() then
        self:_ProcessCommonToastQueue(QueneContainerName, SetContainerName, TimerKeyName, ToastUIName,ExtraData)
    else
        self[SetContainerName] = {}
    end
end

-- 中断在队列中的Toast（通用Toast内部接口）
function BP_UIManagerComponent_C:_BreakInTopToastInQueue(QueneContainerName, SetContainerName, TimerKeyName, ToastUIName, ExtraData)
    local ToastUI = self:GetUI(ToastUIName)
    if ToastUI then
        ToastUI:Close()
    end
    self:RemoveTimer(self[TimerKeyName])
    self:_DoPopNextToastQueue(QueneContainerName, SetContainerName, TimerKeyName, ToastUIName, ExtraData)
end

-- 专门给战斗用的Toast
function BP_UIManagerComponent_C:ShowUITip_BattleCommonTop(TipType, TipContent, LastTime, IsWaitToTrigger, ExtraData)
    if TipType == UIConst.Tip_CommonTop then
        if not self["BattleCommonTopInCD_"..TipContent] then
            self:ShowUITip(TipType, GText(TipContent), LastTime, IsWaitToTrigger, ExtraData)
            self["BattleCommonTopInCD_"..TipContent] = true
            local TimerFunc = function()
                self["BattleCommonTopInCD_"..TipContent] = false
            end
            self:AddTimer(Const.BattleTip_CommonTop_CD, TimerFunc, false, 0, TipContent, true)
        end
        return
    end
end

-- 隐藏警告UI提示
---@param MessageId number 消息ID
function BP_UIManagerComponent_C:HideWarningUITip(MessageId)
    if self.WarningToastUI and self.WarningToastUI.MessageId == MessageId then
        self.WarningToastUI:PlayOutAnim()
    end
end
--endregion

--region 通用黑屏功能
-- 显示 通用黑屏
function BP_UIManagerComponent_C:ShowCommonBlackScreen(Params)
    local NewHandleName = Params.BlackScreenHandle
    if NewHandleName == nil then
        self.CommonBlackScreenAutoCounter = (self.CommonBlackScreenAutoCounter or 0) + 1
        NewHandleName = "AutoGenBlackScreenHandle"..self.CommonBlackScreenAutoCounter
        Params.BlackScreenHandle = NewHandleName
    end

    if self.CommonBlackScreenInstances == nil then
        self.CommonBlackScreenInstances = {}
    end

    if IsValid(self.CommonBlackScreenInstances[NewHandleName]) then
        DebugPrint("Common_BlackScreen: 相同的HandleName已存在！")
        return NewHandleName
    end
    
    local NewBlackScreen = self:LoadUINew("CommonBlackScreen", Params)
    --self.CommonBlackScreenInstances[NewHandleName] = NewBlackScreen
    DebugPrint("Common_BlackScreen: NewBlackScreen", NewHandleName)
    return NewHandleName
end

-- 注册黑屏实例
function BP_UIManagerComponent_C:RegisterBlackScreenInstance(NewHandleName, BlackScreenInstance)
    if self.CommonBlackScreenInstances == nil then
        self.CommonBlackScreenInstances = {}
    end
    self.CommonBlackScreenInstances[NewHandleName] = BlackScreenInstance
    DebugPrint("Common_BlackScreen: RegisterBlackScreenInstance", NewHandleName)
end

-- 关闭 通用黑屏
function BP_UIManagerComponent_C:HideCommonBlackScreen(BlackScreenHandle)
    assert(BlackScreenHandle, "HideCommonBlackScreen必须输入BlackScreenHandle！")
    if self.CommonBlackScreenInstances == nil then
        self.CommonBlackScreenInstances = {}
    end
    local CommonBlackScreen = self.CommonBlackScreenInstances[BlackScreenHandle]
    if IsValid(CommonBlackScreen) then
        CommonBlackScreen:HideCommonBlackScreen()
    end
end

-- 当通用黑屏关闭时调用
function BP_UIManagerComponent_C:OnCommonBlackScreenClosed(BlackScreenHandle)
    if self.CommonBlackScreenInstances == nil then
        self.CommonBlackScreenInstances = {}
    end
    self.CommonBlackScreenInstances[BlackScreenHandle] = nil
    DebugPrint("Common_BlackScreen: OnCommonBlackScreenClosed", BlackScreenHandle)
end

-- 检查是否存在通用黑屏
function BP_UIManagerComponent_C:IsCommonBlackScreenExist(BlackScreenHandle)
    assert(BlackScreenHandle, "IsCommonBlackScreenExist必须输入BlackScreenHandle！")
    if self.CommonBlackScreenInstances == nil then
        self.CommonBlackScreenInstances = {}
    end
    return IsValid(self.CommonBlackScreenInstances[BlackScreenHandle])
end

-- 关闭通用黑屏（不调用回调）
function BP_UIManagerComponent_C:CloseCommonBlackScreenWithoutCB(BlackScreenHandle)
    assert(BlackScreenHandle, "CloseCommonBlackScreenWithoutCB必须输入BlackScreenHandle！")
    if self.CommonBlackScreenInstances == nil then
        self.CommonBlackScreenInstances = {}
    end
    local CommonBlackScreen = self.CommonBlackScreenInstances[BlackScreenHandle]
    if IsValid(CommonBlackScreen) then
        self:OnCommonBlackScreenClosed(BlackScreenHandle)
        CommonBlackScreen:Close()
        DebugPrint("Common_BlackScreen: CloseCommonBlackScreenWithoutCB", BlackScreenHandle)
    end
end
--endregion

--region 一些特定功能向的通用接口
-- 获取菜单锚点是否打开
function BP_UIManagerComponent_C:IsHaveMenuAnchorOpen()
    return self.IsMenuAnchorOpen
end

-- 设置菜单锚点是否打开
function BP_UIManagerComponent_C:SetIsMenuAnchorOpen(bIsOpen)
    self.IsMenuAnchorOpen = bIsOpen
end

-- 显示和鸣等级、角色、武器的升级Toast
---@param Level number 等级 
---@param Type String 升级类型
---@param Id number Id 
function BP_UIManagerComponent_C:ShowLevelUpToast(Level, Type, Id)
    self:CacheLevelUpInfo(Level, Type, Id)
    local LevelUpUI = self:LoadUIAsync("CharLevelUp", function()end, false)
end

function BP_UIManagerComponent_C:ShowPlayerLevelUpToast(IsInSystem)
    if IsInSystem then
        self:LoadUIAsync("CharLevelUp_System", function()end, true)
    else
        self:LoadUIAsync("CharLevelUp", function()end, true)
    end
end

-- 缓存升级Toast的信息，但不立即弹出
function BP_UIManagerComponent_C:CacheLevelUpInfo(Level, Type, Id)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    if GameInstance.LevelUpToastQueue == nil then
        GameInstance.LevelUpToastQueue = {
            Player = nil,           -- 和鸣等级
            Role = nil,             -- 角色等级
            MeleeWeapon = nil,      -- 近战武器等级
            RangedWeapon = nil      -- 远程武器等级
        }
    end
    GameInstance.LevelUpToastQueue[Type] = {Level, Type, Id}
end

-- 尝试显示玩家等级升级信息
function BP_UIManagerComponent_C:TryShowPlayerLevelUpInfo(LevelUpInfo)
    local Avatar = GWorld:GetAvatar()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if not Avatar then return end
    if not GameInstance.LevelUpToastQueue then
        GameInstance.LevelUpToastQueue = {}
    end
    GameInstance.LevelUpToastQueue["Player"] = LevelUpInfo
    if Avatar:IsInDungeon() and LevelUpInfo.ShowProgressBar then 
        return 
    end
    if GameState and (GameState.GameModeType == "Temple" or GameState.GameModeType == "Party" or GameState.GameModeType == "SoloTreasure" or GameState.GameModeType == "MonsterRush") then
        return
    end

    if not self:IsInHUDShowMode() then
        local SupportUIName = DataMgr.SystemUI["CharLevelUp_System"].Params.SupportUIName
        if SupportUIName then
            for _, UIName in ipairs(SupportUIName) do
                local UIObj = self:GetUI(UIName)
                if UIObj then
                    -- DebugPrint("Tianyi@ 当前处于Hud模式")
                    self:ShowPlayerLevelUpToast(true)
                    return
                end
            end
        end

        if not self.WaitToShowPlayerLevelUpTimerHandle then 
            self.WaitToShowPlayerLevelUpTimerHandle = self:AddTimer(1, function()
                if self:IsInHUDShowMode() then 
                    self:ShowPlayerLevelUpToast()
                    if self.WaitToShowPlayerLevelUpTimerHandle then 
                        self:RemoveTimer(self.WaitToShowPlayerLevelUpTimerHandle)
                        self.WaitToShowPlayerLevelUpTimerHandle = nil
                    end
                end
            end, true)
        end
        
        return
    end
    
    self:ShowPlayerLevelUpToast()
end

local CreateArmoryPlayerActor = function(self,Char,InAvatar)
    local Player=UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    local actor = self:GetWorld():SpawnActor(LoadClass('/Game/BluePrints/Char/BP_PlayerCharacter.BP_PlayerCharacter_C'), Player:GetTransform(), UE4.ESpawnActorCollisionHandlingMethod.Default, Player, Player, nil)
    if(actor)then
        actor:RemoveBuffManager()
        actor:SetTickableWhenPaused(true)
        local Avatar = InAvatar or GWorld:GetAvatar()
        if(not Char)then
            Char = Avatar.Chars[Avatar.CurrentChar]
        end
        local AvatarBattleInfo = AvatarUtils:GetDefaultBattleInfo(Avatar, {Char = Char})
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        if GameMode then
            -- AvatarBattleInfo = AvatarUtils:UpdateAvatarInfo({}, AvatarBattleInfo)
            AvatarBattleInfo = GameMode:SimplifyInfoForInit(AvatarBattleInfo)
            -- PrintTable({AvatarBattleInfo=AvatarBattleInfo},10, 'AvatarBattleInfo')
            AvatarBattleInfo.FromOtherWorld = true
            AvatarBattleInfo.FromArmory = true
            actor:InitCharacterInfo(AvatarBattleInfo)
        end
        actor:ForceClearActorHideTag()
        actor.CapsuleComponent:SetCollisionEnabled(ECollisionEnabled.NoCollision)
        actor.CameraFadeCapsule:SetCollisionEnabled(ECollisionEnabled.NoCollision)
        actor.Mesh:SetCollisionEnabled(ECollisionEnabled.NoCollision)
        actor.Mesh:SetTickableWhenPaused(true)
        actor.Mesh.bComponentUseFixedSkelBounds = false
        actor.DitherDisabled=true
    end
    return actor
end

-- 创建或获取ArmoryPlayerActor（用于军械库显示角色相关）
---@param Char any 角色
---@param InAvatar any 角色
---@return any 角色
function BP_UIManagerComponent_C:CreateOrGetArmoryPlayerActor(Char,InAvatar)
    local IsCreated = false
    if(not self.ArmoryPlayer or not self.ArmoryPlayer:IsValid())then
        self.ArmoryPlayer = CreateArmoryPlayerActor(self,Char,InAvatar)
        IsCreated = true
    end
   return self.ArmoryPlayer,IsCreated
end

function BP_UIManagerComponent_C:CreateOrGetPlayerReflection(Char,InAvatar)
    local IsCreated = false
    if(not self.PlayerReflection or not self.PlayerReflection:IsValid())then
        self.PlayerReflection = CreateArmoryPlayerActor(self,Char,InAvatar)
        IsCreated = true
    end
   return self.PlayerReflection,IsCreated
end

-- 创建ShowWeapon（用于UI展示武器）
function BP_UIManagerComponent_C:CreateShowWeapon(Owner,Params,Callback)
    self.ShowWeaponOwners = self.ShowWeaponOwners or {}
    self.ShowWeaponOwners[Owner] = Params
    if(self.ShowWeapon)then
        self.ShowWeapon:SetActorHideTag("CreateShowWeapon",true)
    end
    if(self.ShowWeaponReflection)then
        self.ShowWeaponReflection:SetActorHideTag("CreateShowWeapon",true)
    end

    local OnAllWeaponSpawned = function()
        if(not Callback)then
            return
        end
        Callback(self.ShowWeapon,self.ShowWeaponReflection)
    end
    local SpawnShowWeaponAsync = function(OnSpawned)
        local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
        PlayerCharacter:SpawnShowWeaponAsync(Params.WeaponId,
                        Params.Transform, Params.ReplaceAttrs, Params.SkillInfos,
                        Params.AppearanceInfo, Params.WeaponInfo, function(WeaponActor)
                            if(WeaponActor)then
                                WeaponActor:SetActorHideTag("CreateShowWeapon",false)
                            end
                            OnSpawned(WeaponActor)
                        end)
    end
    local OnShowWeaponSpawned = function(WeaponActor)
        self:ForceDestroyShowWeapon(self.ShowWeapon)
        self:ForceDestroyShowWeapon(self.ShowWeaponReflection)
        self.ShowWeapon = WeaponActor
        if(not self.ShowWeaponOwners[Owner])then
            self:DestroyShowWeapon(Owner)
            return
        end
        if(Params.bEnableReflection)then
            --创建武器倒影
            local OnShowWeaponReflectionSpawned = function(WeaponActor)
                self.ShowWeaponReflection = WeaponActor
                if(not self.ShowWeaponOwners[Owner])then
                    self:DestroyShowWeapon(Owner)
                    return
                end
                OnAllWeaponSpawned()
            end
            SpawnShowWeaponAsync(OnShowWeaponReflectionSpawned)
        else
            OnAllWeaponSpawned()
        end
    end
    SpawnShowWeaponAsync(OnShowWeaponSpawned)
end

function BP_UIManagerComponent_C:DestroyShowWeapon(Owner)
    self.ShowWeaponOwners = self.ShowWeaponOwners or {}
    if(Owner)then
        self.ShowWeaponOwners[Owner] = nil
    end
    if(next(self.ShowWeaponOwners))then
        --如果武器还有引用则不销毁
        return
    end
    self:ForceDestroyShowWeapon(self.ShowWeapon)
    self.ShowWeapon = nil
    self:ForceDestroyShowWeapon(self.ShowWeaponReflection)
    self.ShowWeaponReflection = nil
end

-- 强制销毁ShowWeapon
function BP_UIManagerComponent_C:ForceDestroyShowWeapon(ShowWeapon)
    if(IsValid(ShowWeapon))then
        if(ShowWeapon.ChildWeapon)then
            ShowWeapon.ChildWeapon:K2_DestroyActor()
        end
        ShowWeapon:K2_DestroyActor()
    end
end

-- 创建和获取UIActor（用于界面NPC相关）
---@param NpcId number NPCID
---@return any UIActor
function BP_UIManagerComponent_C:CreateAndGetUINpcActor(NpcId)
    local ToCreateUIActor = self.AllUINpcActor[NpcId]
    if (ToCreateUIActor ~= nil and IsValid(ToCreateUIActor) and ToCreateUIActor.NpcId == NpcId) then
        if (ToCreateUIActor.IsInOutAnim) then
            -- ToCreateUIActor:EMActorDestroy(EDestroyReason.UINpcBaiClose) 
            ToCreateUIActor:DestroyActorTemp()
        else
            return ToCreateUIActor
        end
    end
    -- 创建一个新的UIActor
    local SpawnNpcConfig = DataMgr.SpawnNPC[NpcId]
    if (SpawnNpcConfig == nil) then
        return
    end
    local DistanceRadius = SpawnNpcConfig.SpawnRadius
    local DistanceAngle = tonumber(SpawnNpcConfig.SpawnAngle)
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    local PlayerForwardVector = PlayerCharacter:GetActorForwardVector()
    PlayerForwardVector:Normalize()
    local PlayerTransform = PlayerCharacter:GetTransform()
    local NPCPointVector = UE4.UKismetMathLibrary.RotateAngleAxis(PlayerForwardVector, DistanceAngle, PlayerCharacter:GetActorUpVector())
    PlayerTransform.Translation.X = PlayerTransform.Translation.X + DistanceRadius * NPCPointVector.X
    PlayerTransform.Translation.Y = PlayerTransform.Translation.Y + DistanceRadius * NPCPointVector.Y

    local PlayerBackVector = UE4.UKismetMathLibrary.RotateAngleAxis(PlayerForwardVector, 180, PlayerCharacter:GetActorUpVector())
    local TraceEndPos = PlayerTransform.Translation + PlayerBackVector * SpawnNpcConfig.DetectionDiatance -- trace fron 0.5 meter
    local HitWallResult = FHitResult()
    local bHitWall = UE4.UKismetSystemLibrary.LineTraceSingle(self, PlayerTransform.Translation, TraceEndPos, ETraceTypeQuery.TraceExceptChar, false, nil, 0, HitWallResult, true)
    local NewNpcRotation = PlayerTransform.Rotation:ToRotator()
    if (bHitWall) then
        NewNpcRotation.Pitch, NewNpcRotation.Yaw, NewNpcRotation.Roll = 0, NewNpcRotation.Yaw - 90, 0
    else
        NewNpcRotation.Pitch, NewNpcRotation.Yaw, NewNpcRotation.Roll = 0, NewNpcRotation.Yaw + 90, 0
    end
    PlayerTransform.Rotation = NewNpcRotation:ToQuat() 
    ToCreateUIActor = self:GetWorld():SpawnActor(LoadClass(SpawnNpcConfig.BPPath), PlayerTransform, UE4.ESpawnActorCollisionHandlingMethod.AdjustIfPossibleButAlwaysSpawn, 
                                                            PlayerCharacter, PlayerCharacter, nil)
    local function TryGetActorOverlapImpactLocation(Actor)
        local ActorCapsuleRaduis = Actor.CapsuleComponent:GetUnscaledCapsuleRadius()
        local Start = Actor.CapsuleComponent:K2_GetComponentLocation()
        local End = Actor.CapsuleComponent:K2_GetComponentLocation()
        Start.Z = Start.Z + Actor.CapsuleComponent:GetUnscaledCapsuleHalfHeight()
        End.Z = End.Z - Actor.CapsuleComponent:GetUnscaledCapsuleHalfHeight() * 0.5 --直接使用胶囊体椭圆柱底部会与地板Overlap，所以End做一定缩放
        local HitResult = FHitResult()
        local bHit = UE4.UKismetSystemLibrary.SphereTraceSingle(Actor, Start, End, ActorCapsuleRaduis, ETraceTypeQuery.TraceExceptChar, true, nil, 0, HitResult, true, UE4.FLinearColor(1, 0, 0, 1),UE4.FLinearColor(0, 1, 0, 1), 5)
        if bHit then
            return HitResult.ImpactPoint
        else 
            return nil
        end
    end
    local FirstImpactLocation = TryGetActorOverlapImpactLocation(ToCreateUIActor)
    if FirstImpactLocation ~= nil then --第一次若有重叠就设置在碰撞点外加Z轴方向上半个胶囊体半高处
        PlayerTransform.Translation.X = FirstImpactLocation.X
        PlayerTransform.Translation.Y = FirstImpactLocation.Y
        PlayerTransform.Translation.Z = FirstImpactLocation.Z + ToCreateUIActor.CapsuleComponent:GetUnscaledCapsuleHalfHeight()
        ToCreateUIActor:K2_SetActorTransform(PlayerTransform, false, nil, false)
        local SecondImpactLocation = TryGetActorOverlapImpactLocation(ToCreateUIActor)
        if SecondImpactLocation ~= nil then --第二次若有重叠就设置在最近导航网格外加Z轴方向上胶囊体半高处
            local CurLocationVector = PlayerTransform.Translation
            local NewLocationVector = UE.UNavigationFunctionLibrary.ProjectPointToNavigation(CurLocationVector, ToCreateUIActor)
            if NewLocationVector.X > 0 and NewLocationVector.Y > 0 and NewLocationVector.Z > 0 then
                PlayerTransform.Translation.X = NewLocationVector.X
                PlayerTransform.Translation.Y = NewLocationVector.Y
                PlayerTransform.Translation.Z = NewLocationVector.Z + ToCreateUIActor.CapsuleComponent:GetUnscaledCapsuleHalfHeight()
                ToCreateUIActor:K2_SetActorTransform(PlayerTransform, false, nil, false)
            end
        end
    end                                
    if (ToCreateUIActor) then
        ToCreateUIActor.NpcId = NpcId
        ToCreateUIActor.ModelId = DataMgr.Npc[NpcId].ModelId
        ToCreateUIActor.CapsuleComponent:SetCollisionEnabled(ECollisionEnabled.NoCollision)
        ToCreateUIActor.Mesh:SetCollisionEnabled(ECollisionEnabled.NoCollision)
        ToCreateUIActor:SetTickableWhenPaused(true)
        ToCreateUIActor.Mesh:SetTickableWhenPaused(true)     
        -- local ComponentClass = LoadObject('/Game/Asset/Char/Npc/Npc_Bai_Tongxun/Mesh/BaiTX_Part01_SM.BaiTX_Part01_SM')
        -- local RelativeTransform = FTransform()
        -- RelativeTransform.Location = FVector(100,-5,-60)
        -- RelativeTransform.Rotation = FVector(0,0,90)
        -- local Component = ToCreateUIActor:AddComponentByClass(USkeletalMeshComponent:StaticClass(), false, RelativeTransform, false)
        -- Component:SetSkeletalMesh(ComponentClass)
    end
    ToCreateUIActor.IsNeedSetPos = false
    self.AllUINpcActor[NpcId] = ToCreateUIActor
    return ToCreateUIActor
end

-- 获取UINpcActor
---@param NpcId number NPCID
---@return any UINpcActor
function BP_UIManagerComponent_C:GetUINpcActor(NpcId)
    return self.AllUINpcActor[NpcId]
end

-- 隐藏或显示玩家特效
---@param Player any 玩家
---@param bHide boolean 是否隐藏
---@param Tag string 标签
function BP_UIManagerComponent_C:HideOrShowPlayerFX(Player,bHide,Tag)
    if(Player and Player.Mesh)then
        local Components = TArray(USceneComponent)
        URuntimeCommonFunctionLibrary.SetSceneComponentHiddenInGame(Player.Mesh,bHide,true,Tag,Components)
    end
end

-- 隐藏或显示其他Npc
---@param bHide boolean 是否隐藏
---@param HideTag string 隐藏标签
---@param ExNpcId number 例外NpcID
function BP_UIManagerComponent_C:HideOrShowOtherUINpcActor(bHide, HideTag, ExNpcId)
    for NpcId, UINpcActor in pairs(self.AllUINpcActor) do
        if (NpcId ~= ExNpcId) then
            if(UINpcActor.SetActorHideTag)then
                UINpcActor:SetActorHideTag(HideTag, bHide)
            else
                UINpcActor:SetActorHiddenInGame(bHide)
            end
        end
    end
    if(IsValid(self.ArmoryPlayer))then
        self.ArmoryPlayer:SetActorHideTag(HideTag, bHide)
        self.ArmoryPlayer:HideAllEffectCreature(HideTag, bHide)
    end
end

-- 隐藏NpcActor
---@param bHide boolean 是否隐藏
---@param HideTag string 隐藏标签
---@param ExNpcId number 例外NpcID
function BP_UIManagerComponent_C:HideNpcActor(bHide, HideTag, ExNpcId)
    for NpcId, UINpcActor in pairs(self.AllUINpcActor) do
        if (NpcId ~= ExNpcId) then
            if(UINpcActor.SetActorHideTag)then
                UINpcActor:SetActorHideTag(HideTag, bHide)
            else
                UINpcActor:SetActorHiddenInGame(bHide)
            end
        end
    end
end

--- 只隐藏指定ID的Npc
---@param NpcId number Npc的唯一ID
---@param bHide boolean 是否隐藏
---@param HideTag string 隐藏标签（可选）
function BP_UIManagerComponent_C:HideNpcById(NpcId, bHide, HideTag)
    local UINpcActor = self.AllUINpcActor and self.AllUINpcActor[NpcId]
    if not UINpcActor then
        DebugPrint("HideNpcById  找不到npc")
        return
    end

    -- 如果有带 HideTag 的方法则优先使用
    if UINpcActor.SetActorHideTag then
        UINpcActor:SetActorHideTag(HideTag or "DefaultHideTag", bHide)
    else
        UINpcActor:SetActorHiddenInGame(bHide)
    end
end


-- 创建UIActorCameraHelper
---@param Player any 玩家
---@return any UIActorCameraHelper
function BP_UIManagerComponent_C:CreateUIActorCameraHelper(Player)
    local ToCreateUIActorCameraHelper = self:GetWorld():SpawnActor(LoadClass('/Game/BluePrints/Char/BP_PlayerCharacterArmoryHelper.BP_PlayerCharacterArmoryHelper_C'), Player:GetTransform(), 
    UE4.ESpawnActorCollisionHandlingMethod.Default)
    ToCreateUIActorCameraHelper:K2_SetActorTransform(Player.Mesh:GetSocketTransform('Root',ERelativeTransformSpace.RTS_World),false,nil,false)
    ToCreateUIActorCameraHelper:K2_AddActorLocalOffset(FVector(0, 0, 0), false, nil, false)
    return ToCreateUIActorCameraHelper
end

-- 获取UIActorCameraHelper
---@param NpcId number NPCID
---@return any UIActorCameraHelper
function BP_UIManagerComponent_C:GetUIActorCameraHelper(NpcId)
    return self.AllUIActorCameraHelper[NpcId]
end

-- 播放Npc的UI动画
---@param bInOut boolean 是否入场
---@param UIName string 界面名称
---@param NpcId number NPCID
---@param Params table<string, any> 参数
function BP_UIManagerComponent_C:PlayUINpcAnimation(bInOut, UIName, NpcId, Params)
    local UINpcActor = self:GetUINpcActor(NpcId)
    local SpawnNpcConfig = DataMgr.SpawnNPC[NpcId]
    if(UINpcActor == nil or SpawnNpcConfig == nil)then
        return
    end
    local bDestroyNpc = Params.bDestroyNpc
    local IsHaveInOutAnim = Params.IsHaveInOutAnim
    if(bInOut)then
        local OnInActionFinished = Params.OnInActionFinished
        if (UINpcActor.IsNeedSetPos) then
            local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
            local DistanceRadius = SpawnNpcConfig.SpawnRadius
            local DistanceAngle = SpawnNpcConfig.SpawnAngle
            local PlayerForwardVector = Player:GetActorForwardVector()
            PlayerForwardVector:Normalize()
            local PlayerTransform = Player:GetTransform()
            local NPCPointVector = UE4.UKismetMathLibrary.RotateAngleAxis(PlayerForwardVector, DistanceAngle, Player:GetActorUpVector())
            PlayerTransform.Translation.X = PlayerTransform.Translation.X + DistanceRadius * NPCPointVector.X
            PlayerTransform.Translation.Y = PlayerTransform.Translation.Y + DistanceRadius * NPCPointVector.Y

            local PlayerBackVector = UE4.UKismetMathLibrary.RotateAngleAxis(PlayerForwardVector, 180, Player:GetActorUpVector())
            local TraceEndPos = PlayerTransform.Translation + PlayerBackVector * SpawnNpcConfig.DetectionDiatance -- trace fron 0.5 meter
            local HitWallResult = FHitResult()
            local bHitWall = UE4.UKismetSystemLibrary.LineTraceSingle(self, PlayerTransform.Translation, TraceEndPos, ETraceTypeQuery.TraceExceptChar, false, nil, 0, HitWallResult, true)
            local NewNpcRotation = PlayerTransform.Rotation:ToRotator()
            if (bHitWall) then
                NewNpcRotation.Pitch, NewNpcRotation.Yaw, NewNpcRotation.Roll = 0, NewNpcRotation.Yaw - 90, 0
            else
                NewNpcRotation.Pitch, NewNpcRotation.Yaw, NewNpcRotation.Roll = 0, NewNpcRotation.Yaw + 90, 0
            end
            PlayerTransform.Rotation = NewNpcRotation:ToQuat() 
            UINpcActor:K2_SetActorTransform(PlayerTransform, false, nil, false) 
            local function TryGetActorOverlapImpactLocation(Actor)
                local ActorCapsuleRaduis = Actor.CapsuleComponent:GetUnscaledCapsuleRadius()
                local Start = Actor.CapsuleComponent:K2_GetComponentLocation()
                local End = Actor.CapsuleComponent:K2_GetComponentLocation()
                Start.Z = Start.Z + Actor.CapsuleComponent:GetUnscaledCapsuleHalfHeight()
                End.Z = End.Z - Actor.CapsuleComponent:GetUnscaledCapsuleHalfHeight() * 0.5 --直接使用胶囊体椭圆柱底部会与地板Overlap，所以End做一定缩放
                local HitResult = FHitResult()
                local bHit = UE4.UKismetSystemLibrary.SphereTraceSingle(Actor, Start, End, ActorCapsuleRaduis, ETraceTypeQuery.TraceExceptChar, true, nil, 0, HitResult, true, UE4.FLinearColor(1, 0, 0, 1),UE4.FLinearColor(0, 1, 0, 1), 5)
                if bHit then
                    return HitResult.ImpactPoint
                else 
                    return nil
                end
            end
            local FirstImpactLocation = TryGetActorOverlapImpactLocation(UINpcActor)
            if FirstImpactLocation ~= nil then --第一次若有重叠就设置在碰撞点外加Z轴方向上胶囊体半高处
                PlayerTransform.Translation.X = FirstImpactLocation.X
                PlayerTransform.Translation.Y = FirstImpactLocation.Y
                PlayerTransform.Translation.Z = FirstImpactLocation.Z + UINpcActor.CapsuleComponent:GetUnscaledCapsuleHalfHeight()
                UINpcActor:K2_SetActorTransform(PlayerTransform, false, nil, false)
                local SecondImpactLocation = TryGetActorOverlapImpactLocation(UINpcActor)
                if SecondImpactLocation ~= nil then --第二次若有重叠就设置在最近导航网格外加Z轴方向上胶囊体半高处
                    local CurLocationVector = PlayerTransform.Translation
                    local NewLocationVector = UE.UNavigationFunctionLibrary.ProjectPointToNavigation(CurLocationVector, UINpcActor)
                    PlayerTransform.Translation.X = NewLocationVector.X
                    PlayerTransform.Translation.Y = NewLocationVector.Y
                    PlayerTransform.Translation.Z = NewLocationVector.Z + UINpcActor.CapsuleComponent:GetUnscaledCapsuleHalfHeight()
                    UINpcActor:K2_SetActorTransform(PlayerTransform, false, nil, false)
                end
            end    
        end
        -- 隐藏其他Npc
        self:HideOrShowOtherUINpcActor(true, UIName, NpcId)
        -- UINpcActor.CameraControlComponent:SetArmoryCamera('')
        local function PlayInActionFinished()
            UINpcActor:SetCharacterTag('Interactive')
            if(OnInActionFinished)then
                OnInActionFinished()
            end
        end
        if (IsHaveInOutAnim and SpawnNpcConfig.StartDialogue ~= nil) then
            UINpcActor:PlayUITalkAction(SpawnNpcConfig.StartDialogue, {self, PlayInActionFinished})
        else
            PlayInActionFinished()
        end
    else
        if UINpcActor.BaiBox then
            UINpcActor.BaiBox:SetHiddenInGame(true,false) --设置小白显隐
        end
        local ToCreateUIActorCameraHelper = self.AllUIActorCameraHelper[NpcId]
        local function PlayOutActionFinished()
            -- 先暂时改为删除Npc
            if (bDestroyNpc and IsValid(UINpcActor)) then
                -- UINpcActor:EMActorDestroy(EDestroyReason.UINpcBaiClose)
                UINpcActor:DestroyActorTemp()
                self.AllUINpcActor[NpcId] = nil 
            else
                CommonUtils:SetActorTickableWhenPaused(UINpcActor, false)
                if (type(UINpcActor.SetEmoIdleEnabled) == "function") then
                    UINpcActor:SetEmoIdleEnabled(true) 
                end
                if (type(UINpcActor.KawaiiSwitch) == "function") then
                    UINpcActor:KawaiiSwitch(true)
                end
                UINpcActor.IsNeedSetPos = true
                UINpcActor:SetCharacterTag('Idle')
                UINpcActor:K2_SetActorLocation(FVector(-1000000,-1000000,-1000000), false, nil, false)
                UINpcActor:SetActorHiddenInGame(true)
            end
            self:HideOrShowOtherUINpcActor(false, UIName, NpcId)
            ToCreateUIActorCameraHelper:K2_DestroyActor()
        end

        if (IsHaveInOutAnim and SpawnNpcConfig.EndDialogue ~= nil) then
            UINpcActor.IsInOutAnim = true 
            UINpcActor:PlayUITalkAction(SpawnNpcConfig.EndDialogue, {self, PlayOutActionFinished})
        else
            PlayOutActionFinished()
        end
    end
end

---@param bNpcCamera bool 是否将镜头移到Npc
---@param UIName string 界面对象名称
---@param NpcId number 对象Npc的ID
---@param Params table<string, any> 配置参数，选择性填写
function BP_UIManagerComponent_C:SwitchUINpcCamera(bNpcCamera,UIName, NpcId, Params)
    -- 若有创建条件，先判断条件是否满足
    local SpawnNpcConfig, UINpcActorForCreate = DataMgr.SpawnNPC[NpcId], nil
    if (SpawnNpcConfig == nil) then
        DebugPrint("BP_UIManagerComponent_C SwitchUINpcCamera SpawnNpcConfig is nil, NpcId is ", NpcId)
        return
    end
    if (SpawnNpcConfig.ConditionID ~= nil) then
        local PlayerAvatar = GWorld:GetAvatar()
        if (PlayerAvatar ~= nil and not ConditionUtils.CheckCondition(PlayerAvatar, SpawnNpcConfig.ConditionID)) then
            return
        end
    end
    local IsOnlyMoveCamera = SpawnNpcConfig.IsOnlyMoveCamera
    if (IsOnlyMoveCamera == nil) then
        -- 需要创建Npc
        UINpcActorForCreate = self:CreateAndGetUINpcActor(NpcId)
        if (UINpcActorForCreate == nil or not IsValid(UINpcActorForCreate)) then
            DebugPrint("BP_UIManagerComponent_C SwitchUINpcCamera Create UIActor failed, The NpcId is", NpcId)
            return
        end
        if UINpcActorForCreate.BaiBox then
            UINpcActorForCreate.BaiBox:SetHiddenInGame(false,false) --设置小白显隐
        end
    end
    -- if SpawnNpcConfig.UseXFOV then -- 是否固定镜头锁X轴向 开启后修改FOV为水平视野锁定模式，即纵横比变化，只裁剪上下视野范围，水平视野范围不变。
    --     if bNpcCamera then
    --         DebugPrint("SwitchFixedCamera：固定镜头锁X轴向")
    --         UE.UUIFunctionLibrary.StartHorizontalFOV()
    --     else
    --         DebugPrint("SwitchFixedCamera：固定镜头锁恢复轴向")
    --         UE.UUIFunctionLibrary.StopHorizontalFOV()
    --     end
    -- end
    Params = Params or {}
    local RecoverTime, IsHaveInOutAnim = Params.RecoverTime, Params.IsHaveInOutAnim
    -- 查询对应的Helper类是否存在（TODO 后续看看是否有性能问题）
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local UIActorCameraHelper = self:GetUIActorCameraHelper(NpcId)
    if (UIActorCameraHelper == nil or not IsValid(UIActorCameraHelper)) then
        UIActorCameraHelper = self:CreateUIActorCameraHelper(Player)
        self.AllUIActorCameraHelper[NpcId] = UIActorCameraHelper
    end

    if (not IsValid(UIActorCameraHelper)) then
        DebugPrint("SwitchUINpcCamera UIActorCameraHelper Create Failed, Npc Id is ", NpcId)
        return
    end

    local ViewTargetActor = self:GetUINpcActor(NpcId)
    if (IsOnlyMoveCamera) then
        if (ViewTargetActor == nil) then
            -- 一开始需要设置镜头起始位置
            local CameraComponent = Player:GetComponentByClass(UCameraComponent:StaticClass())
            UIActorCameraHelper:SetCameraStartTrans(CameraComponent:K2_GetComponentToWorld(),CameraComponent.FieldOfView, Player)
        end
        self:SetCameraParamWithConfigData(UIActorCameraHelper, SpawnNpcConfig)
        return
    end

    if bNpcCamera then
        self:SetTargetActorState(true, UINpcActorForCreate, UIName, IsHaveInOutAnim)
        self:PlayUINpcAnimation(true,UIName, NpcId, Params)
        -- ToCreateUIActorCameraHelper:K2_AttachToActor(UINpcActorForCreate)

        local CameraComponent = Player:GetComponentByClass(UCameraComponent:StaticClass())
        UIActorCameraHelper:SetCameraStartTrans(CameraComponent:K2_GetComponentToWorld(),CameraComponent.FieldOfView, UINpcActorForCreate)
        -- 将相机移动过去
        self:SetCameraParamWithConfigData( UIActorCameraHelper, SpawnNpcConfig)
    else
        if (IsHaveInOutAnim) then
            if (IsValid(Player) and Player.IsInAir) then
                -- 关闭的时候如果角色在空中，强行不播放动画，直接进行Npc销毁或者隐藏
                IsHaveInOutAnim = false
            end
            local UIObj = self:GetUIObj(UIName)
            if (UIObj ~= nil and UIObj.IsAddInDeque) then
                IsHaveInOutAnim = false
            end 
        end
        -- ToCreateUIActorCameraHelper:RecoverActors()
        -- ToCreateUIActorCameraHelper:K2_AttachToActor(Player)
        self:SetTargetActorState(false, UINpcActorForCreate, UIName, IsHaveInOutAnim)
        self:PlayUINpcAnimation(false,UIName, NpcId, Params)

        if (RecoverTime ~= nil) then
            local OnRecorverCameraEnd = function()
                local TargetUI = self:GetUIObj(UIName)
                if(TargetUI and TargetUI.OnRecorverCameraEnd)then
                    TargetUI:OnRecorverCameraEnd()
                end
            end
            UIActorCameraHelper:RecorverCamera(self, OnRecorverCameraEnd, RecoverTime) 
        end
    end
end

---该函数用于移动到可配置的固定镜头,如果没有配置固定镜头或者配置了但是没有找到固定镜头或NPC则会生成NPC。
---@param bInOut boolean 是否切换到固定视角
---@param NpcId 读表的spawnnpc的npcId，
---@param Hidetag 可选参数,不填则不隐藏
---@param OriginSelf 传UI界面即可
---@--ViewTargetActor,UIName,Parms可选，填了后如果表内没有固定镜头则会生成相对镜头,如果没有UIName则直接返回
local FixedCameraCache = {}
function BP_UIManagerComponent_C:SwitchFixedCamera(bInOut, NpcId, Hidetag, OriginSelf, UIName, Parms)
    if NpcId == nil then
        ScreenPrint("SwitchFixedCamera:跳转镜头失败NpcId为空")
        DebugPrint("SwitchFixedCamera Failed NpcId is nil ")
        return
    end

    local PlayerController = UGameplayStatics.GetPlayerController(self, 0)
    local PlayerCharacter = UGameplayStatics.GetPlayerCharacter(self, 0)
    local SpawnNpcConfig, UINpcActorForCreate = DataMgr.SpawnNPC[NpcId], nil
    if (SpawnNpcConfig == nil) then
        ScreenPrint("SwitchFixedCamera:没有找到表内数据，请检查NpcId" .. (NpcId or "NpcId为空"))
        DebugPrint("SwitchFixedCamera:没有找到表内数据 SpawnNpcConfig 为空 ")
        return
    end
    local function CreatNpcAndSwitch()
        if UIName then -- SwitchUINpcCamera会自动判断是生成还是恢复
            self:SwitchUINpcCamera(bInOut, UIName, NpcId, Parms)
        else
            ScreenPrint("生成NPC镜头UIName为空")
        end
    end
    local cameraPath
    local CurrentPlatform = CommonUtils.GetDeviceTypeByPlatformName(self)
    if CurrentPlatform == "Mobile" and SpawnNpcConfig.FixedCameraM then
        cameraPath = SpawnNpcConfig.FixedCameraM
    elseif SpawnNpcConfig.FixedCamera then
        cameraPath = SpawnNpcConfig.FixedCamera
    else
        DebugPrint("SwitchFixedCamera:表内没有配置固定镜头：生成NPC镜头")
        CreatNpcAndSwitch()
        return
    end
    -- 此处为距离太远，npc消失便使用固定镜头的逻辑，暂时没用上先注释掉
    -- local Map = UE4.UGameplayStatics.GetGameState(self).NpcCharacterMap
    -- local NPC = Map:Find(NpcId)
    -- if not NPC then
    --     DebugPrint("SwitchFixedCamera:NPC模型不在场景中：生成NPC镜头")
    --     CreatNpcAndSwitch()
    --     return
    -- end

    -- 缓存管理逻辑
    local function GetOrCreateCamera()
        -- 检查缓存有效性
        if FixedCameraCache[cameraPath] and IsValid(FixedCameraCache[cameraPath].actor) then
            return FixedCameraCache[cameraPath].actor
        end

        -- 动态加载蓝图类
        local CameraClass = LoadClass(cameraPath)
        if not CameraClass then
            ScreenPrint("SwitchFixedCamera:无法加载相机蓝图类，请检查路径是否正确：" .. cameraPath)
            return nil
        end

        -- 查找场景中的实例
        local actor = UGameplayStatics.GetActorOfClass(OriginSelf, CameraClass)
        if not actor then
            ScreenPrint("SwitchFixedCamera:[WARNING] 未找到相机实例")
            return
        end
        -- 更新缓存
        FixedCameraCache[cameraPath] = {
            class = CameraClass,
            actor = actor
        }
        return actor
    end
    local ShopCamera = GetOrCreateCamera()
    if not ShopCamera then ---
        ScreenPrint("未找到相机实例")
        CreatNpcAndSwitch()
        return
    end
    if bInOut then
        ---@type BP_ShopCamera_C
        local ShopCamera = GetOrCreateCamera()
        -- local ShopCamera = UGameplayStatics.GetActorOfClass(self, self.CameraClass)
        if ShopCamera then
            ShopCamera.Camera:K2_SetRelativeLocation(ShopCamera.DefaultLocation, false, nil, false)
            PlayerController:SetViewTargetWithBlend(ShopCamera, 0, EViewTargetBlendFunction.VTBlend_Linear, 0, false)
            self.MoveFixedCamera(OriginSelf, ShopCamera.Camera)
        end
        -- ...其余角色隐藏逻辑...
        if PlayerCharacter and Hidetag then
            PlayerCharacter:SetActorHideTag(Hidetag, true)
        end
        if SpawnNpcConfig.UseXFOV then
            DebugPrint("SwitchFixedCamera：固定镜头锁X轴向")
            UE.UUIFunctionLibrary.StartHorizontalFOV()
        end
        DebugPrint("SwitchFixedCamera:切换到固定镜头：" .. (cameraPath or "cameraPath为空"))
    else
        if IsValid(OriginSelf.CameraHandle) then
            ULTweenBPLibrary.KillIfIsTweening(OriginSelf, OriginSelf.CameraHandle)
        end
        local CachedViewTarget = rawget(OriginSelf, "OriginalViewTarget") -- 在uistete镜头逻辑保存了
        if (IsValid(CachedViewTarget)) then
            PlayerController:SetViewTargetWithBlend(CachedViewTarget, 0, UE4.EViewTargetBlendFunction.VTBlend_Linear, 0,
                false)
        else
            DebugPrint("SwitchFixedCamera:UIState的OriginalViewTarget为空  " .. (UIName or "UIName为空"))
            OriginSelf:GetOwningPlayer():SetViewTargetWithBlend(PlayerCharacter, 0,
                UE4.EViewTargetBlendFunction.VTBlend_Linear, 0, false)
        end

        ---@type BP_PlayerCharacter_C
        if PlayerCharacter and Hidetag then
            PlayerCharacter:SetActorHideTag(Hidetag, false)
        end
        if SpawnNpcConfig.UseXFOV then
            DebugPrint("SwitchFixedCamera：固定镜头锁恢复轴向")
            UE.UUIFunctionLibrary.StopHorizontalFOV()
        end
    end
end

--- func SwitchFixedCamera所用的移动镜头函数
---@param Camera  使用的镜头
function BP_UIManagerComponent_C:MoveFixedCamera(Camera)
    local StartPosition = Camera.RelativeLocation
    local EndPosition = FVector(0)
    self.CameraHandle = ULTweenBPLibrary.Vector3To(self, {self, function(_, Value)
        Camera:K2_SetRelativeLocation(Value, false, nil, false)
    end}, StartPosition, EndPosition, 0.5, 0, 17)
end

    --local SceneManager = GWorld.GameInstance:GetSceneManager()
    --local size = SceneManager:GetWindowSize()
-- 设置相机参数
---@param ToCreateUIActorCameraHelper any 相机助手
---@param SpawnNpcConfig table<string, any> 配置数据
function BP_UIManagerComponent_C:SetCameraParamWithConfigData(ToCreateUIActorCameraHelper, SpawnNpcConfig)
        local CameraPositionStart
        local CameraRotationStart
        local CameraPosition
        local CameraRotation
        local PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self)
        if PlatformName == "Mobile" and SpawnNpcConfig.CameraPositionStartM then
            CameraPositionStart = SpawnNpcConfig.CameraPositionStartM
            CameraRotationStart = SpawnNpcConfig.CameraRotationStartM
            CameraPosition = SpawnNpcConfig.CameraPositionM
            CameraRotation = SpawnNpcConfig.CameraRotationM
            CameraRotation =self:CalculatorCameraRotationbyResolution(SpawnNpcConfig,CameraRotation,true)
        else
            CameraPositionStart = SpawnNpcConfig.CameraPositionStart
            CameraRotationStart = SpawnNpcConfig.CameraRotationStart
            CameraPosition = SpawnNpcConfig.CameraPosition
            CameraRotation = SpawnNpcConfig.CameraRotation
            --根据纵横比修改镜头位置和旋转
            CameraRotation =self:CalculatorCameraRotationbyResolution(SpawnNpcConfig,CameraRotation)
        end
        local StartCameraLocation = FVector(CameraPositionStart[1], CameraPositionStart[2], CameraPositionStart[3])
        local StartCameraRotation = FRotator(CameraRotationStart[1],CameraRotationStart[2], CameraRotationStart[3])
        local Controller = UE4.UGameplayStatics.GetPlayerController(self,0)
        Controller:SetViewTargetWithBlend(ToCreateUIActorCameraHelper, 0, UE4.EViewTargetBlendFunction.VTBlend_Linear, 0, false)
        if SpawnNpcConfig.CameraFov then
            ToCreateUIActorCameraHelper:StartFOVAnim(SpawnNpcConfig.CameraFov,SpawnNpcConfig.CameraTime,14)
        end
        DebugPrint("小白镜头 相机位置"..CameraPosition[1]..","..CameraPosition[2]..","..CameraPosition[3])
        DebugPrint("小白镜头 相机旋转"..CameraRotation[1]..","..CameraRotation[2]..","..CameraRotation[3])
        -- self:TweenToMoveCamera(ToCreateUIActorCameraHelper.Camera, FVector(SpawnNpcConfig.CameraPosition[1], SpawnNpcConfig.CameraPosition[2], SpawnNpcConfig.CameraPosition[3]))
        ToCreateUIActorCameraHelper:TransformCamera(FVector(CameraPosition[1], CameraPosition[2], CameraPosition[3]), 
                            FRotator(CameraRotation[1], CameraRotation[2], CameraRotation[3]), SpawnNpcConfig.CameraTime, 17, StartCameraLocation, StartCameraRotation)
end

      
---根据分辨率计算相机最终的偏移位置，根据填入的23：9下的参考旋转使用线性插值
function BP_UIManagerComponent_C:CalculatorCameraRotationbyResolution(SpawnNpcConfig,CameraRotation,bMobile)
    local CameraRotationDelta=bMobile and SpawnNpcConfig.CameraRotationDeltaM or SpawnNpcConfig.CameraRotationDelta
    if(CameraRotationDelta==nil)then
        return CameraRotation
    end
    if type(CameraRotationDelta) ~= "table" or not CameraRotationDelta[1] or not CameraRotationDelta[2] or not CameraRotationDelta[3] then
        ScreenPrint("SpawnNpc表中的CameraRotationDelta数据有误，没找到对应的3个坐标")
        return CameraRotation
    end
    local FinalCameraRotation={
        CameraRotation[1]+CameraRotationDelta[1],
        CameraRotation[2]+CameraRotationDelta[2],
        CameraRotation[3]+CameraRotationDelta[3],
    }
    local resolution=UWidgetLayoutLibrary.GetViewportSize(self) / UWidgetLayoutLibrary.GetViewportScale(self)

    local width=resolution.X
    local height=resolution.Y
    local Aspectratio=width/height
    local Aspectratio23To9=23/9
    local Aspectratio16To9=16/9
    local Aspectratio4To3=4/3
    local Alalpha=(Aspectratio-Aspectratio16To9)/(Aspectratio23To9-Aspectratio16To9)
    -- 限制在4:3到23:9的范围内
    local minAlpha = (Aspectratio4To3-Aspectratio16To9)/(Aspectratio23To9-Aspectratio16To9)
    local maxAlpha = 1.0
    Alalpha=math.clamp(Alalpha,minAlpha,maxAlpha)
    local AimCameraRotationEnd={
        math.lerp(CameraRotation[1] or 0,FinalCameraRotation[1] or 0,Alalpha) or 0,
        math.lerp(CameraRotation[2] or 0,FinalCameraRotation[2] or 0,Alalpha) or 0,
        math.lerp(CameraRotation[3]or 0,FinalCameraRotation[3] or 0,Alalpha) or 0
    }
    DebugPrint("小白镜头 相机旋转"..CameraRotation[1]..","..CameraRotation[2]..","..CameraRotation[3])
    DebugPrint("小白镜头 相机旋转偏移"..CameraRotationDelta[1]..","..CameraRotationDelta[2]..","..CameraRotationDelta[3])
    DebugPrint("小白镜头 相机旋转最终"..AimCameraRotationEnd[1]..","..AimCameraRotationEnd[2]..","..AimCameraRotationEnd[3])
    DebugPrint("小白镜头 屏幕参数 Aspectratio:"..(Aspectratio or "nil").." Alalpha:"..(Alalpha or "nil") .."resolution X:"..(width or "nil").." Y:"..(height or "nil"))
    return AimCameraRotationEnd
end

-- 移动相机
---@param Camera any 相机
---@param EndPosition any 结束位置
function BP_UIManagerComponent_C:TweenToMoveCamera(Camera, EndPosition)
    if (not IsValid(Camera)) then
        return
    end
    if (self.UINpcCameraHandle) then
        ULTweenBPLibrary.KillIfIsTweening(self, self.UINpcCameraHandle)
    end
    local StartPosition = Camera.RelativeLocation
    self.UINpcCameraHandle = ULTweenBPLibrary.Vector3To(self,{self, function(_, Value)
        Camera:K2_SetRelativeLocation(Value, false, nil, false)
    end },
    StartPosition, EndPosition, 0.5, 0, 17)
end

-- 设置目标界面Actor状态
---@param IsLoaded boolean 是否加载
---@param TargetActor any 目标Actor
---@param ReasonStr string 原因字符串
---@param IsHaveInOutAnim boolean 是否拥有入场动画
function BP_UIManagerComponent_C:SetTargetActorState(IsLoaded, TargetActor, ReasonStr, IsHaveInOutAnim)
    if (IsValid(TargetActor) and not IsHaveInOutAnim) then
        CommonUtils:SetActorTickableWhenPaused(TargetActor,IsLoaded)
        if(TargetActor.MeleeWeapon)then
           CommonUtils:SetActorTickableWhenPaused(TargetActor.MeleeWeapon,IsLoaded)
        end
        if(TargetActor.RangedWeapon)then
            CommonUtils:SetActorTickableWhenPaused(TargetActor.RangedWeapon,IsLoaded)
        end
        if(TargetActor.UltraWeapon)then
            CommonUtils:SetActorTickableWhenPaused(TargetActor.UltraWeapon,IsLoaded)
        end
        if (type(TargetActor.SetEmoIdleEnabled) == "function") then
            TargetActor:SetEmoIdleEnabled(not IsLoaded) 
        end
        if (type(TargetActor.KawaiiSwitch) == "function") then
            TargetActor:KawaiiSwitch(IsLoaded)
        end
        TargetActor:SetActorHiddenInGame(not IsLoaded)
    end
end

-- 注册战斗快捷键
function BP_UIManagerComponent_C:RegisterBattleShortCutHudKey(ShortCutKeyHud)
    DebugPrint("RegisterBattleShortCutHudKey:"..tostring(ShortCutKeyHud))
    if(ShortCutKeyHud==nil)then
        return
    end
    self.ShortCutHudKeys[ShortCutKeyHud] = true
end

-- 注销战斗快捷键
function BP_UIManagerComponent_C:UnRegisterBattleShortCutHudKey(ShortCutKeyHud)
    DebugPrint("UnRegisterBattleShortCutHudKey:"..tostring(ShortCutKeyHud))
    if(ShortCutKeyHud==nil)then
        return
    end
    self.ShortCutHudKeys[ShortCutKeyHud] = nil
end

-- 设置战斗快捷键显隐
function BP_UIManagerComponent_C:SetBattleShortCutHudKeysHidden(bHidden)
    if(bHidden) then
        for KeyHud,_ in pairs(self.ShortCutHudKeys) do
            if(IsValid(KeyHud))then
                KeyHud:SetVisibility(UE4.ESlateVisibility.Hidden)
            end
        end
    else
        for KeyHud,_ in pairs(self.ShortCutHudKeys) do
            if(IsValid(KeyHud))then
                KeyHud:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            end
        end
    end
end

function BP_UIManagerComponent_C:PrivateHideAllComponentUI(IsHide, Tag, CompName, WidgetComponentList)
    for Eid, WidgetInfo in pairs(WidgetComponentList) do
        for WidgetName, WidgetComp in pairs(WidgetInfo) do

            if CompName and CompName ~= "" and CompName ~= WidgetName then
                goto continue
            end

            if IsValid(WidgetComp) then
                local Widget = WidgetComp:GetWidget()
                if WidgetName == "Billboard" then
                    -- 无需在这里主动显示
                    if not IsHide then
                        if Widget and (Widget:Cast(UMainBar) or Widget:Cast(UHUD_ToughnessBar)) then
                            goto continue
                        end
                    end
                end

                if (type(WidgetComp.SetWidgetHiddenByTag) == "function") then
                    WidgetComp:SetWidgetHiddenByTag(IsHide, Tag)
                else
                    if Widget then
                        if IsHide then
                            Widget:Hide(Tag)
                        else
                            Widget:Show(Tag)
                        end
                    end
                end
            end
            :: continue ::
        end
    end
end

-- 隐藏所有组件UI
---@param IsHide boolean 是否隐藏
---@param Tag string 标签
---@param CompName string 组件名称
function BP_UIManagerComponent_C:HideAllComponentUI(IsHide, Tag, CompName)

    -- 血条如果也用Hide和Show可能会导致性能问题，并且大部分时候血条不需要显示
    -- 因此加一个变量控制它在HideAllComponent期间不显示即可
    -- 如果将来Hide和Show这一套东西迁移C++了@wangpengshu修改
    if CompName == "Billboard" or CompName == nil then
        DebugPrint("BP_UIManagerComponent_C:HideAllComponentUI SetIsForbidenShowBloodUI",IsHide, Tag)
        UE4.UMainBar.SetIsForbidenShowBloodUI(IsHide)
    end
    self:PrivateHideAllComponentUI(IsHide, Tag, CompName, self.WidgetComponentList)
    local HideWidgetComponentTags = self.HideWidgetComponentTags or {}
    self.HideWidgetComponentTags = HideWidgetComponentTags
    if CompName == nil or CompName == "" then
        CompName = ""
    end
    local CompHideTags = self.HideWidgetComponentTags[Tag] or {}
    self.HideWidgetComponentTags[Tag] = CompHideTags
    if IsHide then
        CompHideTags[CompName] = true
    else
        CompHideTags[CompName] = nil
    end
    EventManager:FireEvent(EventID.OnHideAllComponentUI, IsHide, Tag)
end

-- 播放屏幕特效动画
---@param BPPath string 蓝图路径
---@param EffectName string 特效名称
---@param AnimInfoList table<string, any> 动画信息列表
function BP_UIManagerComponent_C:PlayScreenEffectAnim(BPPath, EffectName, AnimInfoList)
    local ScreenEffectUI = self:LoadUI(BPPath, EffectName, UIConst.ZORDER_SCREEN_EFFECT)
    if (ScreenEffectUI == nil) then
        return
    end
    ScreenEffectUI:Show()
    if (#AnimInfoList > 1) then
        -- 目前支持两个动画
        if (not ScreenEffectUI:IsAnimationPlaying(ScreenEffectUI[AnimInfoList[1].AnimName]) and not ScreenEffectUI:IsAnimationPlaying(ScreenEffectUI[AnimInfoList[2].AnimName])) then
            local function PlayAnimFinished(EffectPanelUI)
                if (IsValid(EffectPanelUI)) then
                    EffectPanelUI:PlayAnimation(EffectPanelUI[AnimInfoList[2].AnimName], AnimInfoList[2].StartTime, AnimInfoList[2].LoopNums)
                end
            end
            ScreenEffectUI:BindToAnimationFinished(ScreenEffectUI[AnimInfoList[1].AnimName], {ScreenEffectUI, PlayAnimFinished})
            ScreenEffectUI:PlayAnimation(ScreenEffectUI[AnimInfoList[1].AnimName], AnimInfoList[1].StartTime, AnimInfoList[1].LoopNums)
        end
    else
        local AnimInfo = AnimInfoList[1]
        if (not ScreenEffectUI:IsAnimationPlaying(ScreenEffectUI[AnimInfo.AnimName])) then
            ScreenEffectUI:PlayAnimation(ScreenEffectUI[AnimInfo.AnimName], AnimInfo.StartTime, AnimInfo.LoopNums)
        end
    end
    return ScreenEffectUI
end

---@deprecated
-- 检查是否需要退出UI模式
---@param ExceptUI any 例外UI
---@return boolean 是否需要退出UI模式
function BP_UIManagerComponent_C:CheckNeedExitUIMode(ExceptUI)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local TalkContext = GameInstance:TryGetTalkContext()
    if TalkContext and TalkContext:HasHiddenGameUI() then
        return false
    end

    local allUI=self.UIInstances:ToTable()
    for _,widget in pairs(allUI) do
        if widget.IsInUIMode and widget~=ExceptUI and (widget:GetParent() or widget:IsInViewport()) then
            return false
        end
    end
    return true
end

function BP_UIManagerComponent_C:GetTopUIModeUI(ExceptUI)
    local allUI=self.UIInstances:ToTable()
    local ZOrder = -10000
    local TopWidget = nil
    for _,widget in pairs(allUI) do
        if widget.IsInUIMode and widget~=ExceptUI and (widget:GetParent() or widget:IsInViewport()) then
            local CurZOeder = widget:GetZOrder()
            if CurZOeder >= ZOrder then
                ZOrder = CurZOeder
                TopWidget = widget
            end
        end
    end
    return TopWidget
end

function BP_UIManagerComponent_C:SetPauseWorldRenderingSwitch(UIName, bOpen)
    if (bOpen) then
        self.AllNotRenderWorldUI[UIName] = 1
        if (UE4.UGameplayStatics.GetEnableWorldRendering(self)) then
            -- 停止掉场景绘制
            UE4.UGameplayStatics.SetEnableWorldRendering(self, false) 
        end
    else
        self.AllNotRenderWorldUI[UIName] = nil
        if (IsEmptyTable(self.AllNotRenderWorldUI)) then
            UE4.UGameplayStatics.SetEnableWorldRendering(self, true)
        end
    end
end

function BP_UIManagerComponent_C:ShowBossBattleOpenTitle(bIsShow)  --真难度Boss战UI Title显示
	local BossBattleOpenUI = self:GetUIObj("HardBossBattleOpen")
    if BossBattleOpenUI then
        BossBattleOpenUI:ShowHardBossTitle(bIsShow)
    else
        DebugPrint("找不到Boss战开战UI")
	end
end

function BP_UIManagerComponent_C:RecordShowInStoryConfig(UIConfig, UIName)
    self.ShowInStoryUINames = self.ShowInStoryUINames or {}
    if UIConfig.ShowInStory then
        self.ShowInStoryUINames[UIName] = UIName
    end
end

function BP_UIManagerComponent_C:GetShowInStoryUINames()
    return self.ShowInStoryUINames or {}
end

-- function BP_UIManagerComponent_C:CheckModGuideOpen()
--     return ActivityUtils.CheckEventIsOpen(104001)
-- end

function BP_UIManagerComponent_C:LoadBossSkillTipsUI(BossSkillToastId)
    local BossSkillToastConfig = DataMgr.BossSkillToast[BossSkillToastId]
    local TipsStyle = BossSkillToastConfig.TipsStyle or "Common"
    TipsStyle = string.lower(TipsStyle)
    local UIName
    if TipsStyle == "common" then
        UIName = "BossSkillToast"
    else
        UIName = "SpecialBossSkillToast"
    end
    local BossSkillTipsUI = self:GetUIObj(UIName)
    if BossSkillTipsUI then
        BossSkillTipsUI:Close()
    end
    return self:LoadUINew(UIName, BossSkillToastId)
end

function BP_UIManagerComponent_C:GetArmoryUIObj()
    return self:GetUI("ArmoryDetail") or self:GetUI("ArmoryMain")
end

-- 显示派遣提示
function BP_UIManagerComponent_C:ShowDispatchTip(DispatchId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local RegionId = DataMgr.Dispatch[DispatchId].RegionId
    local Condition = DataMgr.Region[RegionId].RegionDispCondition
    local Check = ConditionUtils.CheckCondition(Avatar, Condition)
    if Check == false then
        DebugPrint("事件所在区域未解锁")
        return
    end
    local DispatchUIId = DataMgr.Dispatch[DispatchId].DispatchUIId
    local DispatchName = DataMgr.DispatchUI[DispatchUIId].DispatchName
    
    self:AddTimer(1.8, function()
        local Text = string.format(GText("UI_Dispatch_Toast_Unlock"), "【"..GText(DispatchName).."】")
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, Text) 
        DebugPrint("lkkkShowDispatchTip ",  DispatchId)
    end,false,0,nil,false)
end
-- endregion

-- region AfterLoading状态机相关
function BP_UIManagerComponent_C:LaunchAfterLoadingMgr()
    DebugPrint(WarningTag, "UIManager.AfterLoadingMgr, 启动状态机")
    self:DestroyAfterLoadingMgr()
    local AfterLoadingMgr = require "BluePrints.UI.Common.AfterLoadingMgr"
    ---@type AfterLoadingMgr
    self.AfterLoadingMgr = AfterLoadingMgr.New()
    EventManager:RemoveEvent(EventID.OnGuideEnd, self)
    EventManager:AddEvent(EventID.OnGuideEnd, self.AfterLoadingMgr, 
        function(_, GuidId)
            self.AfterLoadingMgr.bGuideEndPending = true
            self:TryResumeAfterLoadingMgr({"TriggerGuide","MainLineQuest","DynamicQuest"})
        end)
    self.BlockingReasons = {}
    EventManager:RemoveEvent(EventID.OnNetDisconnect, self)
    EventManager:AddEvent(EventID.OnNetDisconnect, self,  self.ResetAllBlockReasons)
    EventManager:RemoveEvent(EventID.OnConnectSuccess, self)
    EventManager:AddEvent(EventID.OnConnectSuccess, self, self.ResetAllBlockReasons)
    self.AfterLoadingMgr:Continue()
    --self:AddTimer(0.03, self.FallbackAfterLoadingMgr, true, 0, "LoopCheckFallback")
end

function BP_UIManagerComponent_C:ResetAllBlockReasons()
    for BlockReason ,_ in ipairs(self.BlockingReasons) do
        self:_BlockAllUIInput(false, BlockReason)
    end
    self.BlockingReasons = {}
end

function BP_UIManagerComponent_C:DestroyAfterLoadingMgr()
    if self.AfterLoadingMgr and not self.AfterLoadingMgr:IsEnd() then
        DebugPrint(WarningTag, "UIManager.AfterLoadingMgr, 强制清理掉上次没执行完的状态机")
    end
    -- if self:IsExistTimer("LoopCheckFallback") then
    --     self:RemoveTimer("LoopCheckFallback")
    -- end
    if self.AfterLoadingMgr then
        EventManager:RemoveEvent(EventID.OnGuideEnd, self.AfterLoadingMgr)
    end
    self.AfterLoadingMgr = nil
end

function BP_UIManagerComponent_C:TryPauseAfterLoadingMgr(PauseAfterLoadingState)
    if not self.AfterLoadingMgr then return end
    for _,State in ipairs(PauseAfterLoadingState) do
        if self.AfterLoadingMgr:IsCurrentState(State) then
            DebugPrint(WarningTag, "UIManager.AfterLoadingMgr, UI打开触发继续状态机暂停")
            self.AfterLoadingMgr:Pause()
            return
        end
    end
end

function BP_UIManagerComponent_C:FallbackAfterLoadingMgr()
    if not self.AfterLoadingMgr then return end
    if self.AfterLoadingMgr.bPause then return end
    DebugPrint(WarningTag, "UIManager.AfterLoadingMgr, 保底继续执行状态机，避免卡住")
    self.AfterLoadingMgr:Fallback()
end

function BP_UIManagerComponent_C:TryResumeAfterLoadingMgr(PauseAfterLoadingState)
    if not self.AfterLoadingMgr then return end
    for _,State in ipairs(PauseAfterLoadingState) do
        if self.AfterLoadingMgr:IsCurrentState(State) then
            self:AddTimer(0.01, function()
                if self.AfterLoadingMgr and (not self.AfterLoadingMgr:IsEnd()) then
                    DebugPrint(WarningTag, "UIManager.AfterLoadingMgr, UI关闭触发继续执行状态机")
                    self.AfterLoadingMgr:Continue()
                end
                return
            end,false,0,State)
            return
        end
    end
end
-- endregion

---UImanager的定时器不应该受时间膨胀影响
function BP_UIManagerComponent_C:AddTimer(Interval, Func, IsLoop, Delay, Key, IsRealTime, ...)
    if IsRealTime == nil then IsRealTime = true end
    return BP_UIManagerComponent_C.Super.AddTimer(self, Interval, Func, IsLoop, Delay, Key, IsRealTime, ...)
end

function BP_UIManagerComponent_C:SetUIPauseGame(UIName, IsPause)
    if not self.UIPauseGameMap then
        self.UIPauseGameMap = {}
    end
    self.UIPauseGameMap[UIName] = IsPause and true or nil
end

function BP_UIManagerComponent_C:IsUIPauseGame()
    if not self.UIPauseGameMap then
        return false
    end
    local Num = CommonUtils.TableLength(self.UIPauseGameMap)
    return Num > 0
end
--[[
变色弹窗测试用指令
lua.do  GWorld.GameInstance:GetGameUIManager():NotifyClientShowDungeonToast(EToastColor.Red)
]]

function BP_UIManagerComponent_C:NotifyClientShowDungeonToast(Color)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    UE4.UGameplayStatics.GetGameMode():NotifyClientShowDungeonToast("AvailablePet_Empty", 1.0, EToastType.Common,Color or EToastColor.Yellow)
end
---根据称号样式ID，从TitleFreme获取地址加载称号Widget
function BP_UIManagerComponent_C:LoadTitleFrameWidget(TitleFrameID)
    local TitleConfig = DataMgr.TitleFrame[TitleFrameID]
    if not TitleConfig then
        ScreenPrint("称号加载失败：TitleFrame 表内没有配置TitleFrameID="..TitleFrameID or "空")
        return
    end 
    local BPPath=TitleConfig.FramePath
    if not BPPath then
        ScreenPrint("称号加载失败：TitleFrame 表内没有配置资源地址，先用默认的="..TitleFrameID or "空")
        BPPath="WidgetBlueprint'/Game/UI/WBP/PersonalInfo/Widget/Title/Title/WBP_PersonalInfo_Title_01.WBP_PersonalInfo_Title_01'"
    end 
    local Widget=self:CreateWidget(BPPath,false)
    return Widget
end
function BP_UIManagerComponent_C:GetCurrentWindowSize()
    return GWorld.GameInstance:GetSceneManager():GetWindowSize()
end

function BP_UIManagerComponent_C:AddFlow(WidgetName, Flow)
    self.FlowList[WidgetName] = Flow	
    DebugPrint("WXT UIManagerComponent_C:AddFlow", WidgetName)
end

-- 检查并设置系统打开标记，防止同一帧打开多个系统
-- @param source 系统来源标识，用于日志记录
-- @return boolean 是否允许打开系统
function BP_UIManagerComponent_C:TryOpenSystem(source)
    local currentFrame = UKismetSystemLibrary.GetFrameCount()
    
    if self.SystemOpenFrameFlag ~= currentFrame and self.SystemOpenFrameFlag ~= currentFrame-1 then
        self.SystemOpenFrameFlag = currentFrame
        return true
    end
    
    DebugPrint("防止同一帧打开多个系统:", "来源:", source, "帧号:", currentFrame)
    return false
end

function BP_UIManagerComponent_C:InitGlobalVersionDisplay()
    if UE.URuntimeCommonFunctionLibrary.IsDistribution() then
        return
    end
    local bpPath = "WidgetBlueprint'/Game/UI/WBP/Battle/Widget/WBP_Battle_Version.WBP_Battle_Version'"
    local function AfterLoadVersionWidget(versionWidget)
        if versionWidget then
            self.GlobalVersionWidget = versionWidget
            local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
            GameInstance.GlobalVersionWidget = versionWidget
            versionWidget:InitVersionDisplay()
        end
    end
    -- local versionWidget = self:CreateWidget(bpPath, true, 999)  -- ZOrder=999确保最顶层显示
    self:LoadUIAsync("WBP_Battle_Version", AfterLoadVersionWidget)
end

function BP_UIManagerComponent_C:ShowGlobalVersion()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    if GameInstance.GlobalVersionWidget then
        GameInstance.GlobalVersionWidget:Show()
    end
end
function BP_UIManagerComponent_C:HideGlobalVersion()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    if GameInstance.GlobalVersionWidget then
        GameInstance.GlobalVersionWidget:Hide()
    end
end

-- 示例：UIManager(self):ShowUIError(UIConst.ErrorCategory.Announcement, "公告错误测试")
---@param ErrorCategory 错误类型，一般为UIConst.ErrorCategory的一种
---@param Text 具体的描述信息
---@param ShowTraceback 是否显示Traceback
function BP_UIManagerComponent_C:ShowUIError(ErrorCategory, Text, ShowTraceback)
    self:ShowUIErrorLua(Text, ErrorCategory, ShowTraceback)
end

function BP_UIManagerComponent_C:ShowUIErrorLua(Text, ErrorCategory, ShowTraceback)
    if nil == Text then
        DebugPrint(ErrorTag, "ShowUIErrorLua:参数Text为nil")
        return
    end

    if nil == ErrorCategory then
        DebugPrint(ErrorTag, "ShowUIErrorLua:参数ErrorCategory为nil")
        return
    end

    local bDistribution = UE4.URuntimeCommonFunctionLibrary.IsDistribution()
    local bEnableShippingLog = UE4.URuntimeCommonFunctionLibrary.EnableLogInShipping()
    if bDistribution and not bEnableShippingLog then
        return
    end

    local Space = "=========================================================\n"
    local ct = {
        Space,
        "报错文本:\n\t",
        tostring(Text), "\n",
    }

    -- traceback
    if ShowTraceback == nil or ShowTraceback == true then
        table.insert(ct, Space)
        table.insert(ct, "Traceback:\n\t")
        table.insert(ct, debug.traceback())
        table.insert(ct, "\n")    
    end
    table.insert(ct, Space)
    self:_FillUIErrorLog(ct)
    table.insert(ct, Space)
    local Ret = table.concat(ct)

    if UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
        ScreenPrint("UI报错:\n"..Ret)
    end
    GWorld.ErrorDict = GWorld.ErrorDict or {}
    if GWorld.ErrorDict[Text] then
        return
    end
    GWorld.ErrorDict[Text] = true

    local TraceType = {
        first = "UI报错",
        second = ErrorCategory,
        third = Text,
    }
    local DescribeInfo = {
        title = "UI报错",
        trace_content = Ret,
    }

    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local LocalUser = UE4.UKismetSystemLibrary:GetPlatformUserName()
        local Ret = "设备名："..LocalUser.."\n"..Ret
        Avatar:SendTraceToQaWeb(TraceType, DescribeInfo)
        return
    end
    local DSEntity = GWorld:GetDSEntity()
    if DSEntity then
        DSEntity:SendTraceToQaWeb(TraceType, DescribeInfo)
        return
    end
end

function BP_UIManagerComponent_C:_FillUIErrorLog(ct)
    if not ct and type(ct) ~= "table" then
        return
    end
    
    local Avatar = GWorld:GetAvatar()
    table.insert(ct, "环境:")
    if IsClient(self) then
        table.insert(ct, "联机客户端\n")
    elseif IsDedicatedServer(self) then
        table.insert(ct, "联机服务端\n")
    elseif Avatar and Avatar:IsInHardBoss() then
        table.insert(ct, "梦魇残声")
        if Avatar.HardBossInfo then
            table.insert(ct, ":编号[")
            local HardBossId = Avatar.HardBossInfo.HardBossId
            table.insert(ct, HardBossId)
            table.insert(ct, "]")
            local Context = nil
            if DataMgr.HardBossMain[HardBossId] then
                local HardBossName = DataMgr.HardBossMain[HardBossId].HardBossName
                if DataMgr.TextMap[HardBossName] then
                    Context = GText(HardBossName)
                end
            end
            if Context then
                table.insert(ct, "[")
                table.insert(ct, Context)
                table.insert(ct, "]")
            end
            local DifficultyId = Avatar.HardBossInfo.DifficultyId
            local DifficultyLevel = nil
            if DifficultyId and DataMgr.HardBossDifficulty[DifficultyId] then
                DifficultyLevel = DataMgr.HardBossDifficulty[DifficultyId].DifficultyLevel
            end
            table.insert(ct, ":难度等级[")
            table.insert(ct, DifficultyLevel)
            table.insert(ct, "]")
        end
        table.insert(ct, "\n")
    else
        table.insert(ct, "单机\n")
    end

    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if IsDedicatedServer(self) then
        local AllPlayer = GameMode:GetAllPlayer()
        for i, Player in pairs(AllPlayer) do
            table.insert(ct, "[")
            table.insert(ct, i)
            table.insert(ct, "]")
            self:_FillCharacterLog_UI(ct, Player)
            table.insert(ct, "\n")
        end
    else
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
        local CurrentRoleId = nil
        if Player then
            CurrentRoleId = Player.CurrentRoleId
        end
        self:_FillCharacterLog_UI(ct, Player)
        table.insert(ct, "\n")
    end

    local GameState = UE4.UGameplayStatics.GetGameState(self.Player)
    if IsValid(GameState) then
        local DungeonId = GameState.DungeonId
        if DungeonId and DungeonId > 0 then
            table.insert(ct, "副本ID:")
            table.insert(ct, tostring(DungeonId))
            local DungeonInfo = DataMgr.Dungeon[DungeonId]
            if DungeonInfo then
                local DungeonName = DungeonInfo.DungeonName
                if DataMgr.TextMap[DungeonName] then
                    DungeonName = GText(DungeonName)
                end
                table.insert(ct, "(")
                table.insert(ct, tostring(DungeonName))
                table.insert(ct, ")")
            end
            table.insert(ct, "\n")
        end
    end

    if IsValid(GameMode) and GameMode.IsInRegion and GameMode:IsInRegion() and Avatar then
        local RegionId = Avatar:GetCurrentRegionId()
        table.insert(ct, "子区域ID:")
        table.insert(ct, tostring(RegionId))
        local RegionInfo = DataMgr.SubRegion[RegionId]
        if RegionInfo then
            local RegionName = RegionInfo.SubRegionName
            if DataMgr.TextMap[RegionName] then
                RegionName = GText(RegionName)
            end
            table.insert(ct, "(")
            table.insert(ct, tostring(RegionName))
            table.insert(ct, ")")
        end
        table.insert(ct, "\n")
    end
end

function BP_UIManagerComponent_C:_FillCharacterLog_UI(ct, Player)
    if not ct and type(ct) ~= "table" then
        return
    end
    if not Player then
        return
    end
    local CurrentRoleId = Player.CurrentRoleId
    table.insert(ct, "使用角色ID:")
    table.insert(ct, tostring(CurrentRoleId))
    if DataMgr.BattleChar[CurrentRoleId] then
        local RoleName = GText(DataMgr.BattleChar[CurrentRoleId].CharName)
        table.insert(ct, "(")
        table.insert(ct, tostring(RoleName))
        table.insert(ct, ")")
    end
    if Player:IsPlayer() then
        local Flag = false
        local PhantomTeammate = Player:GetPhantomTeammates()
        for _, Target in pairs(PhantomTeammate) do
            if Target ~= Player then
                if not Flag then
                    table.insert(ct, "\n正在使用的魅影信息:")
                    Flag = true
                end
                table.insert(ct, "\n\t")
                self:_FillCharacterLog_UI(ct, Target)
            end
        end
    end
end

-- 启动脚本检测
function BP_UIManagerComponent_C:StartScriptDetectionCheck()
    -- 判断是否需要开启脚本检测
    if Const.bOpenScriptDetectionCheck then
        local SceneManager = GWorld.GameInstance:GetSceneManager()
        if (SceneManager and SceneManager:GetIsEnableScriptDetectionCheck()) then
            -- 开启鼠标类型脚本检测
            SceneManager:StartScriptDetectionCheck(Const.ScriptDetectionCheckType.OnMouse)
            SceneManager:StartScriptDetectionCheck(Const.ScriptDetectionCheckType.OnKeyboard)
        end
    end
end

function BP_UIManagerComponent_C:ShowWaterMarkUI()
    if GWorld.bShouldShowWaterMark then
        local CurrentLanguage = EMCache:Get("SystemLanguage")
        local SystemLanguage = EMCache:Get("SystemLanguage")
        if not SystemLanguage then
            if UE.AHotUpdateGameMode.IsGlobalPak() then
                SystemLanguage = "EN"
            else
                SystemLanguage = "CN"
            end
        end
        local Content = GWorld.WaterMarkContent
        local Text = Content and Content[SystemLanguage]
        self:LoadUINew("WaterMark", Text)
    end
end

function BP_UIManagerComponent_C:MarkKeyLongPressSuccess(InKey)
    if not self.LongPressTbl then self.LongPressTbl = {} end
    self.LongPressTbl[InKey] = 1
end

function BP_UIManagerComponent_C:CheckAndCleanKeyLongPressSuccess(InKey)
    if self.LongPressTbl then
        local Res = self.LongPressTbl[InKey]
        self:ClearKeyLongPressSuccess(InKey)
        return Res
    end
    return false
end

function BP_UIManagerComponent_C:ClearKeyLongPressSuccess(InKey)
    if self.LongPressTbl and self.LongPressTbl[InKey] then
        self.LongPressTbl[InKey] = nil
    end
end

function BP_UIManagerComponent_C:ClearCachedViewTarget()
    rawset(self,"ViewTargetBeforeOpenSystem",nil)
end

return BP_UIManagerComponent_C
