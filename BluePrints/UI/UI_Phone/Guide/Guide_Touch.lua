--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
require "DataMgr"

local Guide_Touch = Class("BluePrints.UI.BP_UIState_C")


function Guide_Touch:GuideUIInit(UIKey, MessageId, Time, Actions, IsTimeDilation, IsForceClick)
    self:AddTimer(0.1,function()
        DebugPrint( "ERROR:GuideTouch GuideUIInit is not Support:" .. "MessageId:" .. MessageId)
        local UIManager = UE4.UGameplayStatics.GetGameInstance(self):GetGameUIManager()
        UIManager:UnLoadUI(UIManager.CurGuideTouchName)
        --UE4.UGameplayStatics.GetGameInstance(self):GetGameUIManager():UnLoadUI("GuideTouch")
        if self.OnGuideEnd:IsBound() then
            self.OnGuideEnd:Broadcast()
        end
        self.IsDestroied = true
    end)
end

function Guide_Touch:GuideUIInit_Bubble(UIKey, MessageId, Time, DelayTime, Actions, IsTimePause, IsTimeDilation, IsForceClick, IsControlPlayer, IsShowCursor,
    HighLightUIPath, UICompName, UIShape, IsAdapted,
    UICompSizeOffset, UICompLocOffset,
    MessageParentLoc, MessageLoc, MessageLocOffset, IsResetPlayer, IsForbidInAnim, IsForbidOutAnim, GamePadWidgetName, IsAutoClick, IsAutoClickByGamepad,IsFindByMainUI, IsByToastButton)
    self:Init(MessageId, Time, DelayTime, Actions, IsForceClick, IsControlPlayer, IsTimePause, IsTimeDilation, IsShowCursor,
    HighLightUIPath, UICompName, UIShape, IsAdapted,
    UICompSizeOffset, UICompLocOffset,
    MessageParentLoc, MessageLoc, MessageLocOffset, IsResetPlayer, IsForbidInAnim, IsForbidOutAnim, GamePadWidgetName,IsAutoClick, IsAutoClickByGamepad,IsFindByMainUI, IsByToastButton)
    self.IsDestroied = false
end

-- 初始化 input Type: int, bool, bool
function Guide_Touch:Init(MessageId, LastTime, DelayTime, Actions, IsForceClick, IsControlPlayer, IsTimePause, IsTimeDilation, IsShowCursor,
    HighLightUIPath, UICompName, UIShape, IsAdapted,
    UICompSizeOffset, UICompLocOffset,
    MessageParentLoc, MessageLoc, MessageLocOffset, IsResetPlayer, IsForbidInAnim, IsForbidOutAnim, GamePadWidgetName,IsAutoClick, IsAutoClickByGamepad, IsFindByMainUI, IsByToastButton)
    local Message = DataMgr.Message[MessageId]
    if not Message then
        UEPrint("Message Id Wrong")
        return
    end
    --self:SetFocus()

    -- 获取提示文字
    local TextMapIndex = CommonUtils.ChooseOptionByPlatform(Message.MessageContentPC, Message.MessageContentPhone)
    self.MessageContent = GText(TextMapIndex)
    self.MessageContent = CommonUtils:StringReplaceActionName(self.MessageContent)
    self.IsAutoClick = IsAutoClick
    self.IsAutoClickByGamepad = IsAutoClickByGamepad
    self.IsFindByMainUI = IsFindByMainUI
    -- 获取 UIComp
    self.HighLightUIPath = HighLightUIPath
    self.UICompName = UICompName
    self.GamePadWidgetName = GamePadWidgetName
    if not self.UICompName and not self.HighLightUIPath then
        UEPrint("Require UIPath!")
        return
    end
    self:InitListenEvent()
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    if(self.HighLightUIPath == "PlayerVirtualJoysticks") then
        self.IsPlayerVirtualJoystick = true
    end
    self.bIsFocusable = true
    self.IsForbidInAnim = IsForbidInAnim
    self.IsForbidOutAnim = IsForbidOutAnim
    self.MessageId = MessageId
    self.UIComp = nil
    self.UICompPairs = TArray(UE4.UWidget)
    self.GuaranteeTime = 0
    self.SizeZeroCount = 0
    self.FocusCount = 0
    self.IsShowCursor = IsShowCursor
    self.GamePadKey = nil
    -- 获取形状
    self.UIShape = UIShape
    self.IsPlayInAnimation = false
    self.IsInUIMode = true
    self.bOpenWindow = false
    -- 根据 UIComp 设置位置 相关的数据
    self.IsAdapted = IsAdapted
    self.UICompSizeOffset = FVector2D(UICompSizeOffset.X,UICompSizeOffset.Y)
    self.UICompLocOffset = FVector2D(UICompLocOffset.X,UICompLocOffset.Y)
    self.MessageParentLoc = MessageParentLoc
    self.MessageLoc = self:GetPositionScale(MessageLoc)
    self.MessageLocOffset = FVector2D(MessageLocOffset.X,MessageLocOffset.Y)

    self.LastTime = LastTime
    self.DelayTime = DelayTime
    self.IsForceClick = IsForceClick
    self.IsControlPlayer = IsControlPlayer
    self.IsTimePause = IsTimePause
    self.IsTimeDilation = IsTimeDilation
    self.Actions = Actions:ToTable()
    EventManager:RemoveEvent(EventID.LoadUI, self)
    EventManager:RemoveEvent(EventID.UnLoadUI, self)
    if IsByToastButton then
        EventManager:AddEvent(EventID.LoadUI, self, self.LoadUIEvent)
        EventManager:AddEvent(EventID.UnLoadUI, self, self.UnLoadUIEvent)
    end

    -- 禁止玩家输入或时间膨胀
    if self.LastTime == -2 then
        local CurMode =  UE4.URuntimeCommonFunctionLibrary.GetInputMode(GWorld.GameInstance:GetWorld())
        self.PrebShowMouseCursor = (CurMode == "UIOnly" or CurMode == "GameAndUI")
        -- local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
        -- self.PrebShowMouseCursor = PlayerController.bShowMouseCursor
        self:SetInputUIOnly(true)
        self.bIsFocusable = true
        self:SetKeyboardFocus()
        -- for i=0 ,10 do
        --     self:AddTimer(0.05 * i, self.SetKeyboardFocus)
        -- end
        if IsResetPlayer then
            local GameInstance = GWorld.GameInstance
            local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
            local Battle = Battle(PlayerCharacter)
            local TraceInfo="From Guide_Touch:Init"
            if (PlayerCharacter:CharacterInTag("Idle") == false or Battle:CheckConditionNew(11, PlayerCharacter, nil,TraceInfo) == false) then
                self:BlackScreenUIFadeIn()
                --self:AddTimer(1, self.BlackScreenUIFadeOut)
            end
        end
    end
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" and IsForceClick and IsTimeDilation then
        local CurMode =  UE4.URuntimeCommonFunctionLibrary.GetInputMode(GWorld.GameInstance:GetWorld())
        self.PrebShowMouseCursor = (CurMode == "UIOnly" or CurMode == "GameAndUI")
        self:SetInputUIOnly(true)
        self.bIsFocusable = true
    end
    self.Panel_Box:SetVisibility(UE4.ESlateVisibility.Hidden)
    self.Panel_Touch:SetVisibility(UE4.ESlateVisibility.Hidden)
    self.Btn_Area:SetVisibility(UE4.ESlateVisibility.Visible)
    self.Mask:SetVisibility(UE4.ESlateVisibility.Visible)
    -- 延迟开始设置
    self:AddTimer(self.DelayTime, self.DelayShow, false, 0, nil, true)

end

function Guide_Touch:BlackScreenUIFadeIn()
    local GameInstance = GWorld.GameInstance
    local UIManger = GameInstance:GetGameUIManager()

    local Params = {}

    Params.InAnimationObj = self
    Params.InAnimationCallback = self.ResetPlayerStateStart
    Params.InAnimationPlayTime = 0.5
    Params.BlackScreenHandle = "GuideTouch"
    Params.OutAnimationObj = self
    Params.OutAnimationCallback = self.ResetPlayerStateEnd
    Params.OutAnimationPlayTime = 0.5
    UIManger:ShowCommonBlackScreen(Params)
    self:AddTimer(1, function()
        UIManger:HideCommonBlackScreen("GuideTouch")
    end)

end

function Guide_Touch:BlackScreenUIFadeOut()
    -- self.BlackScreenUI:FadeOut(0.5, {
	-- 	Obj = self,
	-- 	Func = self.ResetPlayerStateEnd,
	-- 	Params = {}
	-- })
end

function Guide_Touch:ResetPlayerStateStart()
    DebugPrint("==========================================================ResetPlayerStateStart")
    -- self:SetInputUIOnly(false)
    local GameInstance = GWorld.GameInstance
    local GameMode = UE4.UGameplayStatics.GetGameMode(GameInstance)
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    GameMode:KillHatredMonsters()
    local Transform = PlayerCharacter:GetTransform()
	Transform.Translation = PlayerCharacter:GetLastSafeLocation() 
    Transform.Translation.Z = Transform.Translation.Z + PlayerCharacter.OriginHalfHeight
	GameMode:TriggerFallingCallable(PlayerCharacter,Transform,10000,false)
	GameMode:SwitchToQuestRole(0)
    if self.IsTimePause then
        self:UISetGamePaused("GuideTouch",false)
    end
    -- GameMode:SetGamePaused("ResetPlayerState", true)
	PlayerCharacter:AddDisableInputTag("ResetPlayerState")
    -- self:AddTimer(0.5, self.ResetPlayerStateEnd)
end

function Guide_Touch:ResetPlayerStateEnd()
    DebugPrint("==========================================================ResetPlayerStateEnd")
    local GameInstance = GWorld.GameInstance
    local GameMode = UE4.UGameplayStatics.GetGameMode(GameInstance)
    if self.IsTimePause then
        self:UISetGamePaused("GuideTouch",true)
    end
    -- GameMode:SetGamePaused("ResetPlayerState", false)
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
	PlayerCharacter:RemoveDisableInputTag("ResetPlayerState")
    -- self:SetInputUIOnly(true)
    if (self.BlackScreenUI ~= nil) then
		self.BlackScreenUI:RemoveFromViewport()
		self.BlackScreenUI = nil
	end
end

function Guide_Touch:DelayShow()
    self:SetSelfAppearance()
end


function Guide_Touch:SetSelfAppearance()
    self:SetUIShape()
        if self:GetUIComp() == false then
            if self.GuaranteeTime < 3 then
                self:AddTimer(0.3, self.SetSelfAppearance)
                 self.GuaranteeTime = self.GuaranteeTime + 0.3
            else
                DebugPrint( "ERROR:GuideTouch path is not valid:" .. self.HighLightUIPath .."." .. self.UICompName .. " -> " .. "Cant Find in 3s")
                self:ErrorExit()
            end
            return
        end

        self.Panel_Box:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Panel_Touch:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self:ChangePlayerInputable(false)
        if self.LastTime == -2 or (#self.Actions > 0 and self.IsForceClick) then
            self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.Panel_Box:SetRenderOpacity(1)
            self.Bg01:SetVisibility(UE4.ESlateVisibility.Visible)
            self.Bg02:SetVisibility(UE4.ESlateVisibility.Visible)
            self.Bg03:SetVisibility(UE4.ESlateVisibility.Visible)
            self.Bg04:SetVisibility(UE4.ESlateVisibility.Visible)
            self.Bg05:SetVisibility(UE4.ESlateVisibility.Visible)
            self.Bg06:SetVisibility(UE4.ESlateVisibility.Visible)
            self.Bg07:SetVisibility(UE4.ESlateVisibility.Visible)
            self.Bg08:SetVisibility(UE4.ESlateVisibility.Visible)
        else
            self:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
            self.Bg01:SetVisibility(UE4.ESlateVisibility.Hidden)
            self.Bg02:SetVisibility(UE4.ESlateVisibility.Hidden)
            self.Bg03:SetVisibility(UE4.ESlateVisibility.Hidden)
            self.Bg04:SetVisibility(UE4.ESlateVisibility.Hidden)
            self.Bg05:SetVisibility(UE4.ESlateVisibility.Hidden)
            self.Bg06:SetVisibility(UE4.ESlateVisibility.Hidden)
            self.Bg07:SetVisibility(UE4.ESlateVisibility.Hidden)
            self.Bg08:SetVisibility(UE4.ESlateVisibility.Hidden)
        end       
        DebugPrint("=========================self.IsShowCursor======================",self.IsShowCursor)
        if self.IsShowCursor == false then
            self.OriginalCursor = self.Cursor
            if self.OriginalCursor == 0 then
                self.OriginalCursor = 1
                DebugPrint("guidetouch OriginalCursor is 0, reset to 1")
            end
            self:HideCursor()
            self:AddTimer(0.1, self.HideCursor)
        end
        self.Mask:SetVisibility(UE4.ESlateVisibility.Hidden)
        self:InitClickLogic()
        if self.IsAdapted then
            self:SetGrid()
        end
        if self.UsingGamepad then
            self:SetFocus()
            self.GamePadKey = self:GetUICompGamePadInfo()
        end
        self:PlayInAnimation()
        if self.MessageLoc then
            self:CreateSelfGuideBubble()
        end
        if self.IsAutoClick then
            self:AddTimer(0.01,function()
                self:AutoClick()
            end)
            return
        end
        if self.IsAutoClickByGamepad then
            if self.HighLightUIPath == "ArmoryMod.Mod_1" then
                if self.UsingGamepad then
                    self:AddTimer(0.01,function()
                        local Widget = self.UICompPairs[self.UICompPairs:Length() - 1]
                        local Parent = self.UICompPairs[self.UICompPairs:Length() - 2]
                        local Mod = Widget.SlotUIData:GetMod()
                        ModController:SetSelectedStuff(Mod.Uuid, 1)
                        Parent:ShowModDetailPanel(Mod, 1)
                        self:Close()
                    end)
                else
                    self:AddTimer(0.01,function()
                        self:AutoClick()
                    end)
                end
                return
            end  
        end
        if self.LastTime >0 then
            self:AddTimer(self.LastTime, self.PlayOutAnimation, false, 0, "GuideTouchPlayOutAnimation",false)
        end
        self:AddTimer(0.1, self.RefreshPos, true, 0, "GuideTouchRefreshPos", true)
end

function Guide_Touch:HideCursor()
    self:SetCursor(0)
    self:QueryCursor()
    DebugPrint("=========================HideCursor======================")
end

function Guide_Touch:RefreshPos()
    if self.IsAdapted then
        self:SetGrid()
    end
    if self.MessageLoc then
        self:CalcBubblePosition(true)
    end

    if self.LastTime >0 or self.LastTime == -2 then
        local IsUICompHide = false
        if(self.UICompPairs:Length() > 0) then
            for i = self.UICompPairs:Length(), 1, -1 do
                local Widget = self.UICompPairs[i]
                if CommonUtils:IsWidgetHide(Widget) then
                    IsUICompHide = true
                end
            end
        end
        if IsUICompHide == false then
            local GameInstance = GWorld.GameInstance
            local UIManager = GameInstance:GetGameUIManager()
            local MapUI = UIManager:GetUIObj("LevelMapMain")
            if(MapUI ~= nil and MapUI:IsHide() == false) then
                IsUICompHide = true
            end
        end
        if self:CheckDispatchGuide() then
            IsUICompHide = false
        end

        if IsUICompHide and self:GetVisibility() ~= UE4.ESlateVisibility.Hidden then
            DebugPrint("Guide_Touch hide==========================================")
            self:SetVisibility(UE4.ESlateVisibility.Hidden)
        elseif IsUICompHide == false and self:GetVisibility() ~= UE4.ESlateVisibility.HitTestInvisible and self.LastTime ~= -2 then
            DebugPrint("Guide_Touch show==========================================")
            self:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        elseif IsUICompHide == false and self:GetVisibility() ~= UE4.ESlateVisibility.SelfHitTestInvisible and self.LastTime == -2 then
            DebugPrint("Guide_Touch show==========================================")
            self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
        if IsUICompHide and self.Bubble:GetVisibility() ~= UE4.ESlateVisibility.Hidden then
            DebugPrint("Guide_Touch Bubble hide==========================================")
            self.Bubble:SetVisibility(UE4.ESlateVisibility.Hidden)
        elseif IsUICompHide == false and self.Bubble and self.Bubble:GetVisibility() ~= self.Bubble.VisibilityType then
            DebugPrint("Guide_Touch Bubble show==========================================")
            self.Bubble:SetVisibility(self.Bubble.VisibilityType)
        end
    end
end

function Guide_Touch:CheckDispatchGuide()
    return string.find(self.HighLightUIPath, "Dispatch") or string.find(self.UICompName, "Dispatch")
end

-- 设置自己的形状
function Guide_Touch:SetUIShape()
    -- if self.UIShape == "Circle" then
    --     self.Ring:SetVisibility(UE4.ESlateVisibility.Visible)
    -- elseif self.UIShape == "Square" then
    --     self.Square:SetVisibility(UE4.ESlateVisibility.Visible)
    -- end
end

function Guide_Touch:SetWidgetParent(Widget, CildWidget, ChildWidgetName)
    if(CildWidget == nil) then
        self:ErrorAndFinish(self.HighLightUIPath .."." .. self.UICompName .. " -> " .. ChildWidgetName)
        return false
    end
    Widget = CildWidget
    self.UICompPairs:Add(CildWidget)
    return Widget
end

function Guide_Touch:IsUICompHide()
    local IsUICompHide = false
    if(self.UICompPairs:Length() > 0) then
        for i = self.UICompPairs:Length(), 1, -1 do
            local Widget = self.UICompPairs[i]
            if CommonUtils:IsWidgetHide(Widget) then
                IsUICompHide = true
            end
        end
    end
    return IsUICompHide
end

-- 获取框选的UI
function Guide_Touch:GetUIComp()
    if self.IsPlayerVirtualJoystick then
        self.UIComp = "PlayerVirtualJoysticks"
        return true
    end
    local path = self.HighLightUIPath
    if self.UICompName and self.UICompName ~="" then
        path = path  .."." .. self.UICompName
    end
    local Parents = self:GetPathFromString(path)

    if not Parents then
        self:ErrorAndFinish(path)
        return false
    end

    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManger = GameInstance:GetGameUIManager()
    local Widget = UIManger:GetUIObj(Parents[1])
    self.WidgetUIRoot = Widget
    if(Widget == nil) then
        self:ErrorAndFinish(path)
        return false
    end
    if(Widget:IsHide()) then
        self:ErrorAndFinish(path .. " => UI Is Hide")
        return false
    end
    self:SetWidgetParent(Widget, Widget, Parents[1])
    for i=2,#Parents do
        if(string.match(Parents[i], "%a+[_%a+%d*]*:%-?%w+[:%-?%w+]*")) then
            local Names = Split(Parents[i], ":")
            local IsListView = false
            Widget = self:SetWidgetParent(Widget, Widget[Names[1]], Names[1])
            if(Widget == nil or Widget == false) then
                self:ErrorAndFinish(path)
                return false
            end
            if(Widget:Cast(UE4.UPanelWidget)) then
                IsListView = false
            elseif(Widget:Cast(UE4.UListView)) then
                IsListView = true
            else
                self:ErrorAndFinish(path)
                return false
            end

            for j=2,#Names do
                local Index = -1
                if(IsListView) then
                    if(tonumber(Names[j]) == nil) then
                        Index = self:GetIndexByListItemName(Widget, Names[j])
                    else
                        local Number= tonumber(Names[j])
                        if Number > 0 then
                            Index = Number - 1
                        elseif Number < 0 then
                            Index = Widget:GetNumItems() + Number
                        end
                        local Widget0 = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(Widget,0)
                        if(Widget0 ~= nil and Widget0.CurContent ~= nil and Widget0.CurContent.BtnId ~= nil) then
                            -- MainUI表里的特殊处理Index是读表的
                            self:DisableMapBtn()
                            local BtnId = tonumber(Names[j])
                            Index = self:GetIndexByBtnId(Widget, BtnId)
                        else
                            if Index >=  Widget:GetNumItems() or Index < 0 then
                                self:ErrorAndFinish(path)
                            end
                        end
                    end
                    Widget = self:SetWidgetParent(Widget, UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(Widget,Index), Names[1] .. ":" .. Index)
                    if(Widget == nil or Widget == false) then
                        self:ErrorAndFinish(path)
                        return false
                    end
                else
                    if(tonumber(Names[j]) == nil) then
                        Index = self:GetIndexByWidgetName(Widget, Names[j])
                    else
                        local Number= tonumber(Names[j])
                        if Number > 0 then
                        Index = Number - 1
                        elseif Number < 0 then
                            Index = Widget:GetChildrenCount() + Number
                        end
                        if (Index >=  Widget:GetChildrenCount() or Index < 0) and not Widget:Cast(UE4.UEMMenuAnchor) then
                            self:ErrorAndFinish(path)
                        end
                    end
                    --MainUI的特殊处理
                    if self.IsFindByMainUI and Names[1] == "Panel_Function" then
                        local Child = nil
                        for key, value in pairs(Widget:GetAllChildren()) do
                            if value.EnterId == tonumber(Names[2]) then
                                Child = value
                                break   
                            end
                        end
                        if Child then
                            Widget = self:SetWidgetParent(Widget, Child, Child:GetName())
                        else
                            return false
                        end
                    elseif Widget:Cast(UE4.UEMMenuAnchor) then   --战术背包的引导特殊处理
                        local LastWidget = self.UICompPairs[i+1]
                        if LastWidget.CommonItemDetails then
                            Widget = self:SetWidgetParent(Widget, LastWidget.CommonItemDetails, Names[1] .. ":" .. Index)
                        end
                    else
                        Widget = self:SetWidgetParent(Widget, Widget:GetChildAt(Index), Names[1] .. ":" .. Index)
                    end
                    if(Widget == nil or Widget == false) then
                        self:ErrorAndFinish(path)
                        return false
                    end
                end
                if(j ~= #Names) then
                    if(Widget:Cast(UE4.UPanelWidget)) then
                        IsListView = false
                    elseif(Widget:Cast(UE4.UListView)) then
                        IsListView = true
                    else
                        self:ErrorAndFinish(path)
                        return false
                    end
                end
            end
        else
            Widget = self:SetWidgetParent(Widget, Widget[Parents[i]], Parents[i])
            if(Widget == nil or Widget == false) then
                self:ErrorAndFinish(path)
                return false
            end
        end
        if(Widget == nil or Widget == false) then
            self:ErrorAndFinish(path)
            return false
        end
    end
    self.UIComp = Widget
    local geometry = self.UIComp:GetTickSpaceGeometry()
    local size = UE4.USlateBlueprintLibrary.GetAbsoluteSize(geometry)
    if(size.X == 0 or size.Y == 0) then
        DebugPrint( "ERROR:GuideTouch path is not valid:" .. self.HighLightUIPath .."." .. self.UICompName .. " -> " .. "Widget Size Is Zero")
        return false
    end
    if(self:IsUICompHide()) then
        self:ErrorAndFinish(path .. " => UIComp Is Hide")
        return false
    end
    return true
end

function Guide_Touch:GetIndexByBtnId(ListView, BtnId)
    local Nums = ListView:GetNumItems()
    for i=0, Nums-1 do
        local Item = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(ListView,i)
        if Item ~= nil and Item.CurContent ~= nil and Item.CurContent.BtnId ~= nil and Item.CurContent.BtnId == BtnId then
            DebugPrint("guidetouch MainUI BtnId:", BtnId, "Index:", i)
            return i
        end
    end
    return -1
end

function Guide_Touch:GetIndexByWidgetName(ParentWidget, WidgetName)
    local Nums = ParentWidget:GetChildrenCount()
    for i=0, Nums-1 do
        local Item = ParentWidget:GetChildAt(i)
        if Item ~= nil and string.match(Item:GetName(), WidgetName) ~= nil then
            DebugPrint("guidetouch GetIndexByWidgetName Item:GetName() WidgetName:", Item:GetName(), WidgetName, "Index:", i)
            return i
        end
    end
    return -1
end

function Guide_Touch:GetIndexByListItemName(ListView, WidgetName)
    local Nums = ListView:GetNumItems()
    for i=0, Nums-1 do
        local Item = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(ListView,i)
        if Item ~= nil and string.match(Item:GetName(), WidgetName) ~= nil then
            DebugPrint("guidetouch GetIndexByListItemName Item:GetName() WidgetName:", Item:GetName(), WidgetName, "Index:", i)
            return i
        end
    end
    return -1
end

function Guide_Touch:ErrorAndFinish(path)
    DebugPrint( "ERROR:GuideTouch path is not valid:" .. path)
    -- UE4.UGameplayStatics.GetGameInstance(self):GetGameUIManager():UnLoadUI("GuideTouch")
    -- if self.LastTime == -2 then
    --     self:ChangePlayerInputable(true)
    -- end
    -- if self.OnGuideEnd:IsBound() then
    --     self.OnGuideEnd:Broadcast()
    -- end
end

function Guide_Touch:ErrorExit()
    DebugPrint( "ERROR:GuideTouch path is not valid:" .. "ErrorExit")
    self:RemoveTimer("GuideTouchRefreshPos")
    self:ChangePlayerInputable(true, true)
    if self.IsFromStl then
        SystemGuideManager:RemoveCurStl()
        -- EventManager:FireEvent(EventID.OnSystemGuideNodeFinished)
        DebugPrint("GuideTouch RemoveCurStl")
    end

    local StorylineUtils = require "StoryCreator.StoryLogic.StorylineUtils"
    StorylineUtils.MarkGuideStoryError()

    --尝试恢复暂停的AfterLoading状态机
    UIManager():TryResumeAfterLoadingMgr({"TriggerGuide","MainLineQuest","DynamicQuest"})

    -- if self.OnGuideEnd:IsBound() then
    --     self.OnGuideEnd:Broadcast()
    -- end

    self:EnableMapBtn()
    self:Close()
    --UIManager():UnLoadUI("GuideTouch")
    --self.IsDestroied = true
end


function Guide_Touch:GuideSkip()
    self:RemoveTimer("GuideTouchRefreshPos")
    self:ChangePlayerInputable(true, true)
    if DataMgr.SystemGuide[SystemGuideManager.RunningId] then
        local Path =  DataMgr.SystemGuide[SystemGuideManager.RunningId].GuideStoryline
        GWorld.StoryMgr:StopStoryline(Path,false)
        self:EnableMapBtn()
        self:Close()
    else
        DebugPrint("@lkkkERROR:GuideTouchSkip引导id不存在",SystemGuideManager.RunningId)
    end

end



-- 点击逻辑
function Guide_Touch:InitClickLogic()
    self.Btn_Area:SetVisibility(UE4.ESlateVisibility.Collapsed)

    if not self.UIComp then
        UEPrint("Can not Find UIComp, Please check your Param again")
        return
    end

    if  #self.Actions > 0 then
        self:AddActions()
    end

    if self.LastTime ~= -2 then
        return
    end

    if self.UIComp.ExecuteOnGuideTouchOpen then
        self.UIComp:ExecuteOnGuideTouchOpen()
    end
    if self.IsForceClick and #self.Actions == 0 then
        if self.UIComp.OnClicked and self.UIComp.OnClicked:IsBound()  and  self.HighLightUIPath ~= "GetCharPage" then
            self.UIComp.OnClicked:Add(self, self.PlayOutAnimation)
        elseif self.UICompPairs:Length() > 2
        and self.UICompPairs[self.UICompPairs:Length()-2]
        and self.UICompPairs[self.UICompPairs:Length()-2]:Cast(UE4.UListView) then
            self.UICompPairs[self.UICompPairs:Length()-2].BP_OnItemClicked:Add(self,self.PlayOutAnimationByListViewItem)
        -- else
        --     self.Btn_Area:SetVisibility(UE4.ESlateVisibility.Visible)
        --     self.Btn_Area.OnClicked:Add(self, self.PlayOutAnimation)
        end
        if(self.UICompPairs:Length() > 0) then
            for i = self.UICompPairs:Length(), 1, -1 do
                local Widget = self.UICompPairs[i]
                if Widget:Cast(UE4.UEMListView) and Widget:IsDisableScroll() == false then
                    Widget:DisableScroll(true)
                    self.DisableScrollWidget = Widget
                    DebugPrint("guidetouch EMListView DisableScroll:", Widget:GetName())
                    break
                end
            end
            for i = self.UICompPairs:Length(), 1, -1 do
                local Widget = self.UICompPairs[i]
                if Widget:GetName() == "EMScrollBox_84" and self.WidgetUIRoot and self.WidgetUIRoot:GetName() == "StyleOfPlay" and Widget:Cast(UE4.UEMScrollBox) then
                    CommonUtils:DisableScroll(Widget, true)
                    self.DisableScrollBoxWidget = Widget
                    DebugPrint("guidetouch EMScrollBox DisableScroll:", Widget:GetName(), self.WidgetUIRoot:GetName())
                    break
                end
            end
        end
    else
        -- 点击空白区域消失
        self.Btn_Area:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Btn_Area.OnClicked:Add(self, self.PlayOutAnimation)
    end
end

function Guide_Touch:AddActions()
    self.ActionIndex = 1
    self:AddAction()
end

function Guide_Touch:AddAction()
    local EnumSkill = UE4.ESkillName
    local ActionName = EnumSkill:GetNameByValue(self.Actions[self.ActionIndex])
    self:StartBattleButtonGuide(ActionName)
    self.CurActionName = ActionName
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    if ActionName == "ControlMove" then
        self:AddTimer(0.1,self.WaitControlMoveLogicExecute, true, 0, "TryControlMove")
    elseif ActionName == "ControlAngle" then
        self:AddTimer(0.1,self.WaitControlAngleLogicExecute, true, 0, "TryControlAngle")
    elseif ActionName == "FireInAir" then
        self.CurEventFlag = "NeedFireEvent"
        PlayerCharacter[self.CurEventFlag] = true
        self.CurEventID = EventID["OnFirePressed"]
        EventManager:AddEvent(self.CurEventID, self, self.OnActionEvent)
    elseif ActionName == "ContinuousShooting" then
        self.CurEventFlag = "NeedFireEvent"
        self.CurSecEventFlag = "NeedFireReleaseEvent"
        PlayerCharacter[self.CurEventFlag] = true
        PlayerCharacter[self.CurSecEventFlag] = true
        self.CurEventID = EventID["OnFirePressed"]
        self.CurSecEventID = EventID["OnFireRelease"]
        EventManager:AddEvent(self.CurEventID, self, self.OnActionEvent)
        EventManager:AddEvent(self.CurSecEventID, self, self.OnSecActionEvent)
    elseif ActionName == "BulletJump" then
        self.CurEventFlag = "Need" .. ActionName .. "Event"
        PlayerCharacter[self.CurEventFlag] = true
        self.CurEventID = EventID["On" .. ActionName .. "Started"]
        EventManager:AddEvent(self.CurEventID, self, self.OnActionEvent)
    else
        self.CurEventFlag = "Need" .. ActionName .. "Event"
        PlayerCharacter[self.CurEventFlag] = true
        self.CurEventID = EventID["On" .. ActionName .. "Pressed"]
        EventManager:AddEvent(self.CurEventID, self, self.OnActionEvent)
    end
end

function Guide_Touch:OnActionEvent(NoEvent)
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    if self.CurActionName == "FireInAir" and PlayerCharacter.IsInAir == false then
        return
    end
    if self.CurActionName == "ContinuousShooting" then
        self:AddTimer(2, function()
            EventManager:RemoveEvent(self.CurEventID, self)
            EventManager:RemoveEvent(self.CurSecEventID, self)
            PlayerCharacter[self.CurEventFlag] = false
            PlayerCharacter[self.CurSecEventFlag] = false
            if(self.ActionIndex == #self.Actions) then
                self:PlayOutAnimation()
            else
                self.ActionIndex = self.ActionIndex + 1
                self:AddAction()
            end
        end, false, 0, "TryContinuousShooting")
        return
    end
    if NoEvent ~= true then
        EventManager:RemoveEvent(self.CurEventID, self)
        PlayerCharacter[self.CurEventFlag] = false
    end

    if(self.ActionIndex == #self.Actions) then
        self:PlayOutAnimation()
    else
        self.ActionIndex = self.ActionIndex + 1
        self:AddAction()
    end
end

function Guide_Touch:OnSecActionEvent()
    if self.CurActionName == "ContinuousShooting" then
        self:RemoveTimer("TryContinuousShooting")
    end
end

function Guide_Touch:WaitControlMoveLogicExecute()
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    if PlayerCharacter.MoveInput.X ~= 0 or PlayerCharacter.MoveInput.Y ~= 0 then
        self:RemoveTimer("TryControlMove")
        self:OnActionEvent(true)
    end
end

function Guide_Touch:WaitControlAngleLogicExecute()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self,0)
    if not self.ControllerLastRotator then
        self.ControllerLastRotator = PlayerController:GetControlRotation()
    end
    if PlayerController:GetControlRotation() ~= self.ControllerLastRotator then
        self:RemoveTimer("TryControlAngle")
        self:OnActionEvent(true)
    else
        self.ControllerLastRotator = PlayerController:GetControlRotation()
    end
end

function Guide_Touch:RemoveActions()
end

function Guide_Touch:SetGrid()
    if not self.UIComp then
        DebugPrint("ERROR:GuideTouch Can not Find UIComp, Please check your Param again", self.HighLightUIPath .."." .. self.UICompName)
        return
    end

    local screen_size = UE4.UWidgetLayoutLibrary.GetViewportSize(self)
    local screen_scale = UE4.UWidgetLayoutLibrary.GetViewportScale(self)
    local screen_real_size = screen_size / screen_scale

    if self.IsPlayerVirtualJoystick then
        local Controller = UGameplayStatics.GetPlayerController(self, 0)
        local TouchInterface = Controller.CurrentTouchInterface
        if not TouchInterface then
            return
        end
        local VisualCenter = TouchInterface.Controls[1].Center
        local VisualSize = TouchInterface.Controls[1].VisualSize
        local real_Pos = FVector2D(VisualCenter.X * screen_real_size.X, VisualCenter.Y * screen_real_size.Y) - VisualSize/2 + self.UICompLocOffset
        local ColumnFill0 = real_Pos.X + 20 - self.UICompSizeOffset.X/2
        local ColumnFill1 = VisualSize.X + self.UICompSizeOffset.X
        local ColumnFill2 = screen_real_size.X - ColumnFill0 - ColumnFill1 + 40
        local RowFill0 = real_Pos.Y + 20 - self.UICompSizeOffset.Y/2
        local RowFill1 = VisualSize.Y + self.UICompSizeOffset.Y
        local RowFill2 = screen_real_size.Y - RowFill0 - RowFill1 + 40
        self.Panel_Box:SetColumnFill(0,ColumnFill0)
        self.Panel_Box:SetColumnFill(1,ColumnFill1)
        self.Panel_Box:SetColumnFill(2,ColumnFill2)
        self.Panel_Box:SetRowFill(0,RowFill0)
        self.Panel_Box:SetRowFill(1,RowFill1)
        self.Panel_Box:SetRowFill(2,RowFill2)
        self.Panel_Touch:SetColumnFill(0,ColumnFill0)
        self.Panel_Touch:SetColumnFill(1,ColumnFill1)
        self.Panel_Touch:SetColumnFill(2,ColumnFill2)
        self.Panel_Touch:SetRowFill(0,RowFill0)
        self.Panel_Touch:SetRowFill(1,RowFill1)
        self.Panel_Touch:SetRowFill(2,RowFill2)
        self.TouchPos = real_Pos + VisualSize/2 - screen_real_size/2
        self.TouchSize = VisualSize + self.UICompSizeOffset
        return
    end

    local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.UIComp)
    if CanvasSlot then
        local geometry = self.UIComp:GetTickSpaceGeometry()
        local size = UE4.USlateBlueprintLibrary.GetAbsoluteSize(geometry)
        if(size.X == 0 or size.Y == 0) then
            self.SizeZeroCount = self.SizeZeroCount + 1
            DebugPrint( "ERROR:GuideTouch path is not valid:" .. self.HighLightUIPath .."." .. self.UICompName .. " -> " .. "Widget Size Is Zero")
            if self.SizeZeroCount > 100 then
                self:Close()
                return
            end
        end
        local position = CanvasSlot:GetPosition()
        local offset= CanvasSlot:GetOffsets()
        position = position - FVector2D(offset.Left, offset.Top)
        local vPos,_ = UE4.USlateBlueprintLibrary.LocalToViewport(self,geometry,position)
        local real_Pos = vPos / screen_scale + self.UICompLocOffset
        local real_Size = size / screen_scale
        local ColumnFill0 = real_Pos.X + 20 - self.UICompSizeOffset.X/2
        local ColumnFill1 = real_Size.X + self.UICompSizeOffset.X
        local ColumnFill2 = screen_real_size.X - ColumnFill0 - ColumnFill1 + 40
        local RowFill0 = real_Pos.Y + 20 - self.UICompSizeOffset.Y/2
        local RowFill1 = real_Size.Y + self.UICompSizeOffset.Y
        local RowFill2 = screen_real_size.Y - RowFill0 - RowFill1 + 40
        self.Panel_Box:SetColumnFill(0,ColumnFill0)
        self.Panel_Box:SetColumnFill(1,ColumnFill1)
        self.Panel_Box:SetColumnFill(2,ColumnFill2)
        self.Panel_Box:SetRowFill(0,RowFill0)
        self.Panel_Box:SetRowFill(1,RowFill1)
        self.Panel_Box:SetRowFill(2,RowFill2)
        self.Panel_Touch:SetColumnFill(0,ColumnFill0)
        self.Panel_Touch:SetColumnFill(1,ColumnFill1)
        self.Panel_Touch:SetColumnFill(2,ColumnFill2)
        self.Panel_Touch:SetRowFill(0,RowFill0)
        self.Panel_Touch:SetRowFill(1,RowFill1)
        self.Panel_Touch:SetRowFill(2,RowFill2)
        self.TouchPos = real_Pos + real_Size/2 - screen_real_size/2
        self.TouchSize = real_Size + self.UICompSizeOffset
    else--if UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(self.UIComp) then
        local OverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(self.UIComp)

        local geometry = self.UIComp:GetTickSpaceGeometry()
        local size = UE4.USlateBlueprintLibrary.GetAbsoluteSize(geometry);
        -- -- 获取父级控件的位置和大小
        -- local ParentWidget = OverlaySlot.Parent
        -- local ParentGeometry = ParentWidget:GetTickSpaceGeometry()
        -- local ParentSize = UE4.USlateBlueprintLibrary.GetAbsoluteSize(ParentGeometry)

        -- local HorizontalAlignment = OverlaySlot.HorizontalAlignment
        -- local VerticalAlignment = OverlaySlot.VerticalAlignment

        local PositionX = 0
        local PositionY = 0

        -- if HorizontalAlignment == EHorizontalAlignment.HAlign_Center then
        --     local X = (ParentSize.X - size.X) / 2
        --     if X < 0 then
        --         X = 0
        --     end
        --     PositionX = X
        -- elseif HorizontalAlignment == EHorizontalAlignment.HAlign_Right then
        --     local X = ParentSize.X - size.X
        --     if X < 0 then
        --         X = 0
        --     end
        --     PositionX = X
        -- end

        -- if VerticalAlignment == EVerticalAlignment.VAlign_Center then
        --     local Y = (ParentSize.Y - size.Y) / 2
        --     if Y < 0 then
        --         Y = 0
        --     end
        --     PositionY = Y
        -- elseif VerticalAlignment == EVerticalAlignment.VAlign_Bottom then
        --     local Y = ParentSize.Y - size.Y
        --     if Y < 0 then
        --         Y = 0
        --     end
        --     PositionY = Y
        -- end
        -- local Padding = OverlaySlot.Padding

        -- PositionX = PositionX + Padding.Left
        -- PositionY = PositionY + Padding.Top

        -- 计算OverlaySlot在屏幕上的位置
        local vPos = UE4.USlateBlueprintLibrary.LocalToViewport(self, geometry, FVector2D(PositionX, PositionY))     
        local real_Pos = vPos / screen_scale + self.UICompLocOffset
        local real_Size = size / screen_scale
        local ColumnFill0 = real_Pos.X + 20 - self.UICompSizeOffset.X/2
        local ColumnFill1 = real_Size.X + self.UICompSizeOffset.X
        local ColumnFill2 = screen_real_size.X - ColumnFill0 - ColumnFill1 + 40
        local RowFill0 = real_Pos.Y + 20 - self.UICompSizeOffset.Y/2
        local RowFill1 = real_Size.Y + self.UICompSizeOffset.Y
        local RowFill2 = screen_real_size.Y - RowFill0 - RowFill1 + 40
        self.Panel_Box:SetColumnFill(0,ColumnFill0)
        self.Panel_Box:SetColumnFill(1,ColumnFill1)
        self.Panel_Box:SetColumnFill(2,ColumnFill2)
        self.Panel_Box:SetRowFill(0,RowFill0)
        self.Panel_Box:SetRowFill(1,RowFill1)
        self.Panel_Box:SetRowFill(2,RowFill2)
        self.Panel_Touch:SetColumnFill(0,ColumnFill0)
        self.Panel_Touch:SetColumnFill(1,ColumnFill1)
        self.Panel_Touch:SetColumnFill(2,ColumnFill2)
        self.Panel_Touch:SetRowFill(0,RowFill0)
        self.Panel_Touch:SetRowFill(1,RowFill1)
        self.Panel_Touch:SetRowFill(2,RowFill2)
        self.TouchPos = real_Pos + real_Size/2 - screen_real_size/2
        self.TouchSize = real_Size + self.UICompSizeOffset
    -- else
    --     DebugPrint("ERROR:GuideTouch UIComp ParentWidget CanvasSlot or OverlaySlot is nil", self.HighLightUIPath .."." .. self.UICompName,self.UIComp)
    --     self:Close()
    --     return
    end
end

function Guide_Touch:PlayInAnimation()
    if self.IsPlayInAnimation then
        return
    end
    self.IsPlayInAnimation = true
    local TimerTime = 0
    local InAnimation = nil
    -- if self.UIShape == "Circle" then
    --     InAnimation = self.Ring_in
    -- elseif self.UIShape == "Square" then
    --     InAnimation = self.Square_in
    -- end
    if self.IsForceClick then
        InAnimation = self.In
    else
        InAnimation = self.In02
    end
    --self:SetPlaybackSpeed(InAnimation, 1/UE4.UGameplayStatics.GetGlobalTimeDilation(self))
    if self.IsForbidInAnim then
        if self.IsForceClick then
            self.InnerBox:Play_Guide_HighLightBoxInner_In()
        else
            self.InnerBox:Play_Guide_HighLightBoxInner_In02()
        end

    else
        self:PlayAnimation(InAnimation)
    end
    TimerTime = InAnimation:GetEndTime()-- * UE4.UGameplayStatics.GetGlobalTimeDilation(self)
    self:AddTimer(TimerTime, self.PlayLoopAnimation)
    self:PlaySound()
end

function Guide_Touch:PlayLoopAnimation()
    -- local TimerTime = 0
    local InAnimation = nil
    -- if self.UIShape == "Circle" then
    --     InAnimation = self.Ring_Loop
    -- elseif self.UIShape == "Square" then
    --     InAnimation = self.Square_Loop
    -- end
    if self.IsForceClick then
        InAnimation = self.InnerBox.Loop
    else
        InAnimation = self.InnerBox.Loop02
    end
    -- self:SetPlaybackSpeed(InAnimation, 1/UE4.UGameplayStatics.GetGlobalTimeDilation(self))
    self.InnerBox:PlayAnimation(InAnimation, 0, 0)
    -- TimerTime = InAnimation:GetEndTime() * UE4.UGameplayStatics.GetGlobalTimeDilation(self)
    -- self:AddTimer(TimerTime, self.PlayLoopAnimation)
end

function Guide_Touch:PlayOutAnimationByListViewItem(Item)
    self:PlayOutAnimation()
end

function Guide_Touch:PlayOutAnimation()
    DebugPrint("Guide_Touch:PlayOutAnimation")
    -- UE4.UGameplayStatics.SetGlobalTimeDilation(self, 1)
    local TimerTime = 0
    local InAnimation = nil
    -- if self.UIShape == "Circle" then
    --     InAnimation = self.Ring_Out
    -- elseif self.UIShape == "Square" then
    --     InAnimation = self.Square_Out
    -- end

    if self.IsForceClick then
        InAnimation = self.Out
    else
        InAnimation = self.Out02
    end
    --self:SetPlaybackSpeed(InAnimation, 1/UE4.UGameplayStatics.GetGlobalTimeDilation(self))
    if self.IsForbidOutAnim then
        if self.IsForceClick then
            self.InnerBox:Play_Guide_HighLightBoxInner_Out()
        else
            self.InnerBox:Play_Guide_HighLightBoxInner_Out02()
        end
    else
        self:PlayAnimation(InAnimation)
    end
    
    
    
    if self.LastTime >0 then
        self:RemoveTimer("GuideTouchPlayOutAnimation")
    end
    self:StopSound()

    TimerTime = InAnimation:GetEndTime()-- * UE4.UGameplayStatics.GetGlobalTimeDilation(self)
    if self.IsForbidOutAnim then
        self:Close()
    else
        self:AddTimer(TimerTime, self.Close)
    end
end

-- 结束
function Guide_Touch:Close()
    DebugPrint("Guide_Touch:Close")
    self:StopSound()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManger = GameInstance:GetGameUIManager()
    --if self.Bubble then
        UIManger:UnLoadUI("GuideBubble")
    --end
    self.Bubble = nil 
    self:EndBattleButtonGuide()
    if self.Btn_Area.OnClicked:IsBound() then
        self.Btn_Area.OnClicked:Clear()
    end
    if self.IsForceClick and #self.Actions == 0 then
        if self.UIComp and self.UIComp.OnClicked and self.UIComp.OnClicked:IsBound() then
            self.UIComp.OnClicked:Remove(self, self.PlayOutAnimation)
        elseif self.UICompPairs:Length() > 2
        and self.UICompPairs[self.UICompPairs:Length()-2]
        and self.UICompPairs[self.UICompPairs:Length()-2]:Cast(UE4.UListView) then
            self.UICompPairs[self.UICompPairs:Length()-2].BP_OnItemClicked:Remove(self,self.PlayOutAnimationByListViewItem)
        end
        if(self.DisableScrollWidget) then
            self.DisableScrollWidget:DisableScroll(false)
            DebugPrint("guidetouch EMListView EnableScroll:", self.DisableScrollWidget:GetName())
            self.DisableScrollWidget = nil
        end
        if(self.DisableScrollBoxWidget) then
            CommonUtils:DisableScroll(self.DisableScrollBoxWidget, false)
            DebugPrint("guidetouch EMScrollBox EnableScroll:", self.DisableScrollBoxWidget:GetName())
            self.DisableScrollBoxWidget = nil
        end
    end

    if #self.Actions > 0 then
        self:RemoveActions()
    end
    --UIManger:UnLoadUI(UIManager().CurGuideTouchName)
    

    if self.UIComp and self.UIComp.ExecuteOnGuideTouchClose then
        self.UIComp:ExecuteOnGuideTouchClose()
    end
    self:RemoveTimer("GuideTouchRefreshPos")

    if SystemGuideManager.RunningId > 0 then
        DebugPrint("guidetouch UploadTrackLog_Lua guide_step_client step_id:", SystemGuideManager.RunningId, "branch_guide_id:", self.MessageId)
        HeroUSDKSubsystem():UploadTrackLog_Lua("guide_step_client", 
        { 
            step_id = SystemGuideManager.RunningId,
            branch_guide_id = self.MessageId
        })
    end
    

    self:EnableMapBtn()
    self.bIsFocusable = false
    self.IsDestroied = true
    if self.OnGuideEnd:IsBound() then
        self.OnGuideEnd:Broadcast()
    end
    Guide_Touch.Super.Close(self)
end

function Guide_Touch:StartBattleButtonGuide(ActionName)
    local Widget = UIManager(self):GetUIObj("BattleMain")
    if not IsValid(Widget) or not IsValid(Widget.Char_Skill) or not IsValid(Widget.Char_Skill.Jump) then
        return
    end
    Widget.Char_Skill.Jump:OnGuideStart(ActionName)
end

function Guide_Touch:EndBattleButtonGuide()
    local Widget = UIManager(self):GetUIObj("BattleMain")
    if not IsValid(Widget) or not IsValid(Widget.Char_Skill) or not IsValid(Widget.Char_Skill.Jump) then
        return
    end
    Widget.Char_Skill.Jump:OnGuideEnd()
end

function Guide_Touch:Destruct()
    
    self:RemoveTimer("GuideTouchRefreshPos")
    self:SetInputUIOnly(false)
    local GameInstance = GWorld.GameInstance
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    if PlayerCharacter then
        PlayerCharacter:RemoveDisableInputTag("ResetPlayerState")
    end
    if self.UsingGamepad then
        self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
    end
    -- if self.IsTimePause then
    --     self:UISetGamePaused("GuideTouch",false)
    --     -- UE4.UGameplayStatics.SetGlobalTimeDilation(self, 0)
    -- end
    if self.IsByToastButton then
        EventManager:RemoveEvent(EventID.LoadUI, self)
        EventManager:RemoveEvent(EventID.UnLoadUI, self)
    end
    self.FocusCount = 0
    self:ChangePlayerInputable(true)
    Guide_Touch.Super.Destruct(self)
end

-- 按钮逻辑
function Guide_Touch:ExecuteForceLogic()
    if self.UIComp.OnClicked and self.UIComp.OnClicked:IsBound() then
        self.UIComp.OnClicked:Broadcast()
        return
    end
end

-- 生成 Guide_Bubble
function Guide_Touch:CreateSelfGuideBubble()
    if not self.BublleAddToViewport then
        UEPrint("MessageLoc is invaild")
        return
    end
    if self.HighLightUIPath == "GetCharPage" then
        return
    end
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManger = GameInstance:GetGameUIManager()
    self.Bubble = UIManger:GetUIObj("GuideBubble")
    if self.UsingGamepad then
        if not self.GamePadKey then
            self.GamePadKey = self:GetUICompGamePadInfo()
        end
        self.MessageContent = GText(DataMgr.Message[self.MessageId].MessageContentGamePad)
        
        --self.MessageContent = CommonUtils:StringReplaceActionName(self.MessageContent)
    else

        local Message = DataMgr.Message[self.MessageId]
        if not Message then
            UEPrint("Message Id Wrong")
            return
        end
        -- 获取提示文字
        local TextMapIndex = CommonUtils.ChooseOptionByPlatform(Message.MessageContentPC, Message.MessageContentPhone)
        self.MessageContent = GText(TextMapIndex)
        self.MessageContent = CommonUtils:StringReplaceActionName(self.MessageContent)
    end
    self.bSkip = 0
    if SystemGuideManager.RunningId ~= -1 then
        self.bSkip = DataMgr.SystemGuide[SystemGuideManager.RunningId].GuideSkip
    end
    if not self.Bubble then
        if self.UsingGamepad then

            self.Bubble = UIManger:LoadUI('/Game/UI/WBP/Guide/Widget/WBP_Guide_ContentBlock.WBP_Guide_ContentBlock', "GuideBubble", self:GetZOrder(), self.MessageContent, self.MessageLoc, self.GamePadKey, self.bSkip, self)
            if self.bSkip == 1 then
                self.Bubble.Controller_Skip:SetVisibility(UE4.ESlateVisibility.Visible)
            end
        else
            
            self.Bubble = UIManger:LoadUI('/Game/UI/WBP/Guide/Widget/WBP_Guide_ContentBlock.WBP_Guide_ContentBlock', "GuideBubble", self:GetZOrder(), self.MessageContent, self.MessageLoc, nil, self.bSkip, self)
            self.Bubble.Controller_Skip:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        
    else
        if self.UsingGamepad then
            self.Bubble:InitMessage(self.MessageContent, self.MessageLoc, self.GamePadKey, self.bSkip, self)
            if self.bSkip == 1 then
                self.Bubble.Controller_Skip:SetVisibility(UE4.ESlateVisibility.Visible)
            end
        else
            self.Bubble:InitMessage(self.MessageContent, self.MessageLoc, nil, self.bSkip, self)
            self.Bubble.Controller_Skip:SetVisibility(UE4.ESlateVisibility.Collapsed)

        end
        
    end
    self:AddTimer(0.1, function()
        self:CalcBubblePosition()
    end)
end

function Guide_Touch:CalcBubblePosition(IsRefresh)
    if self.HighLightUIPath == "GetCharPage" then
        return
    end
    local BubbleSize = self.Bubble:GetTextRealSize()
    local BubblePosition
    if(self.MessageParentLoc == "Global") then

        local ScreenViewportSize = UE4.UWidgetLayoutLibrary.GetViewportSize(self)
        local ScreenViewportScale = UE4.UWidgetLayoutLibrary.GetViewportScale(self)
        local ScreenBublleDistance = ScreenViewportSize/ScreenViewportScale/2 - BubbleSize/2
        BubblePosition = ScreenBublleDistance*self.MessageLoc + self.MessageLocOffset
    else
        if self.TouchSize == nil then
            self:ErrorExit()
            return
        end
        local TouchBublleDistance = self.TouchSize/2 + BubbleSize/2 - FVector2D(20,20)
        BubblePosition = self.TouchPos + TouchBublleDistance*self.MessageLoc + self.MessageLocOffset
    end
    self.BubblePosition = BubblePosition
    self:BubbleSlotSetPosition()
    -- if(IsRefresh == true) then
    --     self.BubblePosition = BubblePosition
    --     self:BubbleSlotSetPosition()
    --     return
    -- end
    --self:SetBubblePosition(BubblePosition)
end

-- function Guide_Touch:SetBubblePosition(BubblePosition)
--     if self.BubblePosition ~= BubblePosition then
--         self.Bubble:SetWidgetOpacity(0)
--         self.BubblePosition = BubblePosition
--         local TimerTime = 0.1-- * UE4.UGameplayStatics.GetGlobalTimeDilation(self)
--         self:AddTimer(TimerTime, self.CalcBubblePosition)
--         return
--     end
--     self.Bubble:SetWidgetOpacity(1)
--     self:BubbleSlotSetPosition()
-- end

function Guide_Touch:BubbleSlotSetPosition()
    local BubbleSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Bubble.Panel_Text)
    if(self.MessageLoc.X ~= 0 and self.MessageLoc.Y ~= 0 ) then
        BubbleSlot:SetPosition(self.BubblePosition - FVector2D(self.MessageLoc.X * 70, 0))
    else
        BubbleSlot:SetPosition(self.BubblePosition)
    end
end

-- 根据读表的 xxx.yyy 分别获取字符串 xxx yyy
function Guide_Touch:GetPathFromString(InputString)
    if not InputString then
        return nil
    end
    local Parents = Split(InputString, ".")
    return Parents
end

-- 根据读表的 MessageLoc 获取 Guide_Bubble 应该生成在哪个角落
function Guide_Touch:GetPositionScale(MessgaeLoc)
    self.BublleAddToViewport = true
    local PositionScale = FVector2D(0,0)
    if not MessgaeLoc or MessgaeLoc == "" then
        self.BublleAddToViewport = false
        return
    end
    if string.match(MessgaeLoc, "Left") then
        PositionScale.X = -1
    end
    if string.match(MessgaeLoc, "Right") then
        PositionScale.X = 1
    end
    if string.match(MessgaeLoc, "Up") then
        PositionScale.Y = -1
    end
    if string.match(MessgaeLoc, "Down") then
        PositionScale.Y = 1
    end
    return PositionScale
end
-- [工具函数]

-- 限制玩家不可输入
function Guide_Touch:ChangePlayerInputable(IfAble, IsErrorExit)
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    if not IfAble then
        if self.LastTime == -2 then
            self:SetInputUIOnly(true)
        end
        if self.IsTimeDilation then
            UE4.UGameplayStatics.SetGlobalTimeDilation(self, 0.2)
        end
        if self.IsTimePause then
            self:UISetGamePaused("GuideTouch",true)
            -- UE4.UGameplayStatics.SetGlobalTimeDilation(self, 0)
        end
    else
        DebugPrint(self.IsControlPlayer, self.PrebShowMouseCursor, self.IsTimePause, IsErrorExit, "GuideTouch: self.IsControlPlayer, self.PrebShowMouseCursor, self.IsTimePause, IsErrorExit")
        if(self.IsControlPlayer or (self.PrebShowMouseCursor ~= true and IsErrorExit)) then 
            self:SetInputUIOnly(false)
        else
            local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
            local UIManger = GameInstance:GetGameUIManager()
            local TopUI = UIManger:GetTopUIModeUI(self)
            if(TopUI ~= nil) then
                DebugPrint("=SystemGuide==Guidetouch==TopUI:SetKeyboardFocus=============TopUIName:", TopUI:GetName())
                --TopUI.bIsFocusable = true
                if not (TopUI.ConfigName == "Entertainment" and self.UsingGamepad) then --- 邀约先特殊处理
                    TopUI:SetKeyboardFocus()
                end
            end
        end
        if self.IsTimePause then
            self:UISetGamePaused("GuideTouch",false)
            -- UE4.UGameplayStatics.SetGlobalTimeDilation(self, 1)
        end
        if self.IsTimeDilation then
            UE4.UGameplayStatics.SetGlobalTimeDilation(self, 1)
        end
    end
end

function Guide_Touch:Hide(HideTag)
    -- 重新一下基类的方法
    -- if (self.UIStateTag ~= nil) then
    --     UIManager(self):AddUIToStateTagsCluster(self.UIStateTag, self.ConfigName, false)
    -- end
    -- 暂停声音
    HideTag = HideTag or UIConst.CommonHideTagName.DefaultTag
    local IsVisibilityChange = self:SetUIVisibilityTag(HideTag, true)
    if (IsVisibilityChange) then
        AudioManager(self):PauseObjectAllEvent(self, true)
        if self.IgnoreHideTags and CommonUtils.HasValue(self.IgnoreHideTags, HideTag) then
            return
        end
        HideTag = HideTag or "DefaultTag"
        self:SetUIVisibilityTag(HideTag, true)
        if (self.IsInUIMode) then
            self:SetInputUIOnly(false)
        end
        if (self.IsUIPopUp == true) then
            UIManager(self):OpenResidentUI(self.WidgetName)
        end
        if self.IsTimePause then
            self:UISetGamePaused("GuideTouch",false)
        end
        if self.KeyboardSetName and self.IsBanningAction then 
            UIManager(self):SetBannedActionCallback(self.KeyboardSetName, false, self:GetName())
            self.IsBanningAction = nil
        end
    end
    
end

function Guide_Touch:Show(ShowTag)
    -- 重新一下基类的方法
    -- if (self.UIStateTag ~= nil) then
    --     UIManager(self):AddUIToStateTagsCluster(self.UIStateTag, self.ConfigName, true)
    -- end
    -- 开启声音
    ShowTag = ShowTag or UIConst.CommonHideTagName.DefaultTag
    local IsVisibilityChange = self:SetUIVisibilityTag(ShowTag, false)
    if (IsVisibilityChange) then
        AudioManager(self):PauseObjectAllEvent(self, false)
        ShowTag = ShowTag or "DefaultTag"
        self:SetUIVisibilityTag(ShowTag, false)
        if (self.IsInUIMode) then
            self:SetInputUIOnly(true)
        end
        if (self.IsUIPopUp == true) then
            UIManager(self):CloseResidentUI(self.WidgetName)
        end
        if self.IsTimePause then
            self:UISetGamePaused("GuideTouch",true)
        end
        if self.KeyboardSetName and not self.IsBanningAction then 
            UIManager(self):SetBannedActionCallback(self.KeyboardSetName, true, self:GetName())
            self.IsBanningAction = true
        end
    end



    -- local IsVisibilityChange = self:SetUIVisibilityTag(HideTag, true)
    -- if (IsVisibilityChange) then
        
    -- end
    
end

function Guide_Touch:OnKeyDown(MyGeometry, InKeyEvent)
    
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)  
    local Handle = false
    if InKeyName == "Gamepad_Special_Right" and self.bSkip == 1 then
        self.Bubble.Controller_Skip:OnButtonPressed()
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    if self.IsShowCursor and not self.UsingGamepad then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    if(InKeyName == "LeftAlt") then
        if(self.OriginalCursor == nil) then
            self.OriginalCursor = self.Cursor
        end
        if(self.Cursor ~= self.OriginalCursor) then
            self:SetCursor(self.OriginalCursor)
            self:QueryCursor()
            DebugPrint("Alt==Down========================", self.Cursor)
        end
    end
    if not self.GamePadKey then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    local KeyName = Const.ShortKeyToGamePadKey[self.GamePadKey]
    if InKeyName == KeyName then
        Handle = self:AutoClick()
    end
    if Handle then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end

end

function Guide_Touch:OnKeyUp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == "Gamepad_Special_Right" then
        self.Bubble.Controller_Skip:OnButtonReleased()
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    if self.IsShowCursor then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    if(InKeyName == "LeftAlt") then
        if(self.Cursor ~= 0) then
            self:SetCursor(0)
            self:QueryCursor()
            DebugPrint("Alt==Up========================", self.Cursor)
        end
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function Guide_Touch:PlaySound()
    AudioManager(self):PlayUISound(nil, "event:/ui/common/guider_highlight_loop", "Guide_Touch_PlaySound", nil)
end

function Guide_Touch:StopSound()
    AudioManager(self):SetEventSoundParam(nil, "Guide_Touch_PlaySound", {ToEnd = 1})
end

function Guide_Touch:DisableMapBtn()
    local GameInstance = GWorld.GameInstance
    local UIManager = GameInstance:GetGameUIManager()
    local battleMap=nil
    local battleMain=UIManager:GetUI('BattleMain') or UIManager:GetUI('HomeBaseMain')
    if battleMain then
        battleMap=battleMain.Battle_Map or battleMain.Battle_Map_PC
    end
    if battleMap then
        self.BattleMap = battleMap
        self.BattleMap.IsDisableClick = true
        DebugPrint("Guide_Touch:DisableMapBtn")
    end
end

function Guide_Touch:EnableMapBtn()
    if self.BattleMap then
        self.BattleMap.IsDisableClick = false
        self.BattleMap = nil
        DebugPrint("Guide_Touch:EnableMapBtn")
    end
end

function Guide_Touch:AutoClick()
    if self.Btn_Area:GetVisibility() == ESlateVisibility.Visible then
        self.Btn_Area.OnClicked:Broadcast()
        return true
    elseif self.UIComp:Cast(UButton) then
        if self.UIComp.OnClicked:IsBound() then
            self.UIComp.OnClicked:Broadcast()
        end
        if self.UIComp.OnReleased:IsBound() then
            self.UIComp.OnReleased:Broadcast()
        end
        return true
    else
        if self.HighLightUIPath == "ArmoryMod.Mod_1" then
            self.UICompPairs[2]:OnMouseButtonDown()
            self.UICompPairs[2]:OnMouseButtonUp()  
            return true
        end
        if self.HighLightUIPath == "ArmoryMod.List_Select_Mod:1" then
            self.UICompPairs[3]:OnMouseButtonDown()
            self.UICompPairs[3]:OnMouseButtonUp()  
            return true
        end
        if self.UICompPairs[self.UICompPairs:Length()-2] and self.UICompPairs[self.UICompPairs:Length()-2].BP_OnItemClicked and self.UICompPairs[self.UICompPairs:Length()-2].BP_OnItemClicked:IsBound() then
            local Name = self.UICompPairs[self.UICompPairs:Length()-2]:GetName()
            local startPos, endPos = string.find(self.HighLightUIPath, Name)
            local Index = self.HighLightUIPath:sub(endPos + 2, endPos + 2)
            local Content = self.UICompPairs[self.UICompPairs:Length()-2]:GetItemAt(tonumber(Index) - 1)
            self.UICompPairs[self.UICompPairs:Length()-2].BP_OnItemClicked:Broadcast(Content)
            return true
        end
        if self.UIComp:Cast(UUserWidget) then
            if self.HighLightUIPath == "ArmoryMain.Panel_SubUI:2.List_Item:1.Item" then
                local Content = self.UICompPairs[self.UICompPairs:Length()-3]:GetItemAt(tonumber(1) - 1)
                if self.UICompPairs[self.UICompPairs:Length()-3].BP_SetSelectedItem then
                    self.UICompPairs[self.UICompPairs:Length()-3]:BP_SetSelectedItem(Content)
                end
                return true
            else
                self.UIComp:OnMouseButtonDown()
                self.UIComp:OnMouseButtonUp()
                return true
            end
        end
    end  
    return false
end


---------------------手柄相关-----------------------

function Guide_Touch:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice) 
    end
end

function Guide_Touch:RefreshBaseInfo()
    -- 刷新一些基础信息
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function Guide_Touch:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 切换手柄端相关图标显隐
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        self.UsingGamepad = false
        self:CreateSelfGuideBubble()
    else
        self.UsingGamepad = true
        self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
        self:CreateSelfGuideBubble()
        if self.bOpenWindow == false then
            self:SetFocus()
        end
    end
end

function Guide_Touch:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = false

     --宠物捕获空格
    if self.HighLightUIPath == "PetCapture" and self.UICompName == "Panel_Tip" then
        if (InKeyName == "SpaceBar" or InKeyName == "Gamepad_FaceButton_Bottom") then
            local path = self.HighLightUIPath
            if self.UICompName and self.UICompName ~="" then
                path = path  .."." .. "Button_Throw"
            end
            local Parents = self:GetPathFromString(path)
            local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
            local UIManger = GameInstance:GetGameUIManager()
            local Widget = UIManger:GetUIObj(Parents[1])
            self.UIComp =  Widget[Parents[2]]
            if self.UIComp then
                self.UIComp.OnClicked:Broadcast()     
            end
        end
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    if not self.GamePadKey then
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    local KeyName = Const.ShortKeyToGamePadKey[self.GamePadKey]
    if InKeyName == KeyName then
        IsHandled = self:AutoClick()
    end
    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end


function Guide_Touch:OnFocusLost(InFocusEvent)
    if self.UsingGamepad then
        if self.bOpenWindow  then return end
        if not self.FocusCount then return end
        self.FocusCount = self.FocusCount + 1
        if self.FocusCount > 10 then
            return
        end
        self:SetFocus()
    end
end

function Guide_Touch:OnRemovedFromFocusPath(InFocusEvent)
    if self.UsingGamepad then
        if self.bOpenWindow  then return end
        if not self.FocusCount then return end
        self.FocusCount = self.FocusCount + 1
        if self.FocusCount > 10 then
            return
        end
        self:SetFocus()
    end
end

function Guide_Touch:LoadUIEvent(UIKey)
    if not self.UIKey and UIManager(self):StateCount() > 0 then
        self.UIKey = UIKey
        self:SetVisibility(UE4.ESlateVisibility.Hidden)
        if self.Bubble then
            self.Bubble:SetVisibility(UE4.ESlateVisibility.Hidden)
            self:RemoveTimer("GuideTouchRefreshPos")
        end
    end

end

function Guide_Touch:UnLoadUIEvent(UIKey)
    if self.UIKey == UIKey then
        self:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        if self.Bubble then
            self.Bubble:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
            self:AddTimer(0.35, function()
                self:AddTimer(0.1, self.RefreshPos, true, 0, "GuideTouchRefreshPos", true)
            end)

        end
        self.UIKey = nil
    end
end

function Guide_Touch:GetUICompGamePadInfo()
    if not self.UIComp then
        return
    end 
    if not self.IsForceClick then
        return "A"
    end
    if self.UIComp:Cast(UButton) then
        local Widget = self.UICompPairs[self.UICompPairs:Length() - 1]       
        if self.GamePadWidgetName ~= "" then
            local GamePadWidget = nil
            if Widget[self.GamePadWidgetName] then
                GamePadWidget = Widget[self.GamePadWidgetName]
            else
                DebugPrint(self.GamePadWidgetName.."没有开放变量")
                return "A"
            end
            if GamePadWidget.KeyInfoList or GamePadWidget.GamePadImgName then
                local Key = nil
                if GamePadWidget.KeyInfoList then
                    Key = GamePadWidget.KeyInfoList[1]["ImgShortPath"]
                elseif GamePadWidget.GamePadImgName then
                    Key =  GamePadWidget.GamePadImgName
                end
                if Key then
                    return Key
                end
            end
        elseif Widget.KeyInfoList or Widget.GamePadImgName then
            local Key = nil
            if Widget.KeyInfoList then
                Key = Widget.KeyInfoList[1]["ImgShortPath"]
            elseif Widget.GamePadImgName then
                if Widget.GamePadImgName == "None" then
                    Key = "A"
                else
                    Key =  Widget.GamePadImgName
                end
            end
            if Key then
                return Key
            end

        else
            DebugPrint("Stl节点缺少手柄按键配置")
            return "A"
        end  
    else
        return "A"
    end
end



return Guide_Touch
