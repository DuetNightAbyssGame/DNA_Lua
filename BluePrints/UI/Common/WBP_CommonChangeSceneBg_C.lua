--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
require "DataMgr"
local EMCache = require "EMCache.EMCache"
local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"
local SpecialLoadingRule = require "Utils.LoadingUtils"
---@type CommonChangeSceneBg_PC_C
local WBP_CommonChangeSceneBg_C = Class({"BluePrints.Common.TimerMgr","BluePrints.UI.BP_EMUserWidget_C"})
WBP_CommonChangeSceneBg_C._components = {
    "BluePrints.UI.WidgetComponent.ChangeTextToKeyInfoComponent",
}
function WBP_CommonChangeSceneBg_C:Initialize(Initializer)
   
end


function WBP_CommonChangeSceneBg_C:OnShowLoading()
    self.NowLoadLevelName = nil
    self.NowLoadAssetId = nil
    self.IsRandomScene = true
    self.NowPercentNum = 0.0
    self.QueenShow = {}
    self.Index = 1
    self.CurrentIndex = 0
    self.Next = 0
    self.DynamicFunc = {}
    self.ShowTipsInterval = Const.LoadingTipsInterval
    --self.CurrentInputDevice = {"KeyboardKey","MouseButton"}
    self.WidgetLoading = nil
    self.bIsInLoading = true
    DebugPrint(WarningTag, LXYTag, "Loading界面打开....")
    --需要强制结束上一个未执行完的AfterLoadingMgr
    UIManager():DestroyAfterLoadingMgr()
    EventManager:FireEvent(EventID.InLoading)
    --打开Loading的时候触发一次本地缓存的保存
    if GWorld:GetAvatar() then
        EMCache:SaveUser()
    end
    EMCache:SaveCommon()
    -- 打开Loading时关闭同步加载优化
    print(_G.LogTag, "SetSyncLoaderOptimization False")
    GWorld.GameInstance:SetSyncLoaderOptimization(false)
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if PlayerCharacter then
        PlayerCharacter:SetCanInteractiveTrigger(false, "Loading")
    end

    local GameInputSubsystem = USubsystemBlueprintLibrary.GetLocalPlayerSubsystem(self, UGameInputModeSubsystem)
    if GameInputSubsystem then
        GameInputSubsystem:DisableInputMode("Talk")
    end

    local isDungeonData = true
    self.bEnableTick = true

    self:ConstructSoundFunc()
    --self:AddTimer(0.1, self.SetFocus, true, 0, "ReSetFocus")
    local SojournsGameInstanceSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, USojournsGameInstanceSubsystem)
    self:SetIsShowNavigateGuide(false)
    if SojournsGameInstanceSubsystem and SojournsGameInstanceSubsystem:IsInInvitation() then
        self:PlayAnimation(self.In)
        self.WidgetSwitcher_Root:SetActiveWidgetIndex(1)
        local Widget = UIManager(self):_CreateWidgetNew("InvitationLoading")
        self.InvitationRoot:ClearChildren()
        local Slot = self.InvitationRoot:AddChildToOverlay(Widget)
        Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
        Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
        Widget:PlayAnimation(Widget.In)
        local PartyNpcData = SojournsGameInstanceSubsystem.PartyNPCData
        assert(PartyNpcData, "PartyNpcData is nil")
        local BattleCharData = DataMgr.BattleChar[PartyNpcData.CharId]
        assert(BattleCharData, "BattleCharData is nil" .. PartyNpcData.CharId)
        Widget.Text_CharacterName:SetText(GText(BattleCharData.CharName))
        Widget.WorldText_Name:SetText(EnText(BattleCharData.CharName))
        local IconDynaMaterial = Widget.Icon_Avatar:GetDynamicMaterial()
		IconDynaMaterial:SetTextureParameterValue("Mask", LoadObject(PartyNpcData.AvatarIconPath))
        local PartyTopicData = SojournsGameInstanceSubsystem.PartyTopicData
        assert(PartyTopicData, "PartyTopicData is nil")
        Widget.Text_TopicName:SetText(GText(PartyTopicData.PartyTopicName))
    else
        self.WidgetSwitcher_Root:SetActiveWidgetIndex(0)
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            self.Text_Uid:SetText(string.format("UID:%s", tostring(Avatar.Uid)))
        end
        self:SetRandomTips()
    
        self:UpdateShowUI()
        self:PlayAnimation(self.In)
        self:PlayAnimation(self.Loop, 0, 0)
        local DungeonData = DataMgr.Dungeon[WorldTravelSubsystem():GetCurrentSceneId()]
        local LoginPage = UIManager(self):GetUIObj("LoginMainPage")
       
        if LoginPage then
            self.IsFromLoginPage = true
            self.Panel_Bg:SetContent(UIManager(self):CreateWidget(Const.LoadingBgBluePrint))
        elseif not DungeonData then
            isDungeonData = false
            -- local RandomBg = self:RandomBackgroud()
            -- if not RandomBg then --报错变打印，避免Loading界面卡顿过久，独立进程模式测试更方便
            --     Utils.ScreenPrint(debug.traceback(ErrorTag.."随机加载Loading背景失败，已知独立进程模式会有问题，不影响包体和编辑器"))
            -- end
            -- self.Panel_Bg:SetContent(RandomBg)

        elseif DungeonData.DungeonUIBG then
            self.Panel_Bg:SetContent(UIManager(self):CreateWidget(DungeonData.DungeonUIBG))
        end
        if self.Panel_Bg:GetContent() and self.Panel_Bg:GetContent().In_Loading then
            self.Panel_Bg:GetContent():PlayAnimation(self.Panel_Bg:GetContent().In_Loading)
        end
        self.Text_BottomTips:SetText(GText("UI_Loading_Testing"))

    end

    if not isDungeonData then
        self.WidgetSwitcher_Root:SetActiveWidgetIndex(1) 
        local LoadingData, SpecialLoadingBp = SpecialLoadingRule:GetLoadingBpPath(true)
        if SpecialLoadingBp then 
            self.WidgetLoading = UIManager(self):CreateWidget(SpecialLoadingBp)
            if self.WidgetLoading.InitLoadingData then 
                self.WidgetLoading:InitLoadingData(LoadingData, self)
            end
        else 
            self.WidgetLoading = UIManager(self):_CreateWidgetNew("ComLoadingXiaoBai")
        end
        local Widget = self.WidgetLoading
        self.InvitationRoot:ClearChildren()
        local Slot = self.InvitationRoot:AddChildToOverlay(Widget)
        Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
        Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
        self:UpdateShowUI()
        -- Widget:Init()
        -- Widget:PlayAnimation(Widget.In)  
        -- self:SetXiaoBaiRandomTips()
        -- Widget.Button_461.OnClicked:Clear()
    end

    local GameInputSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if IsValid(GameInputSubsystem) then
        local Params = FGameInputModeParams()
        Params.bShowMouseCursor = false
        Params.MouseLockMode = EMouseLockMode.DoNotLock
        GameInputSubsystem:EnableInputMode("CommonChangeScene", EGameInputMode.UI, Params)
    end

    self:SetMouseCursorVisable(false)

        -- local PlayerController = UGameplayStatics.GetPlayerController(self, 0)
        -- if PlayerController then
        --     UWidgetBlueprintLibrary.SetInputMode_UIOnlyEx(PlayerController)
        --     PlayerController.bShowMouseCursor = true
        -- end
        -- self:SetMouseCursorVisable(false)

    self.bShowThisFrame = true
end

function WBP_CommonChangeSceneBg_C:Construct()
    self.Overridden.Construct(self)
    UIManager(self):GetGameInputModeSubsystem().OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    self.Button_461.OnClicked:Add(self, self.SetRandomTips)
    self:SetFocus()
    self:UpdateUIStyleInPlatform(UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad)
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self.CurrentInputDevice = {"GamepadKey"}
    else
        self.CurrentInputDevice = {"KeyboardKey","MouseButton"}
    end
    -- self:OnShowLoading()   
end

function WBP_CommonChangeSceneBg_C:ConstructSoundFunc()
    AudioManager(self):PlayUISound(self, "event:/ui/common/loading_common", "Loading", nil)

    -- local bus = UE4.UFMODBlueprintStatics.FindAssetByName("bus:/sfx")
    -- UE4.UFMODBlueprintStatics.BusSetVolume(bus:Cast(UE4.UFMODBus), 0)

    AudioManager(self):PausePlayBGMCauseIsLoadingOrBlackScreen()
    AudioManager(self):AddAuANotifyForbidTag("LoadingUI")
end

function WBP_CommonChangeSceneBg_C:Destruct()
    DebugPrint(WarningTag, LXYTag, "Loading界面应该销毁了")
    self.Overridden.Destruct(self)
    -- UIManager(self):GetGameInputModeSubsystem().OnInputMethodChanged:Remove(self,self.RefreshOpInfoByInputDevice)
    local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
    if GameInputModeSubsystem and GameInputModeSubsystem.OnInputMethodChanged then
        GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    end
    self:DestructSoundFunc()
end

local EMCache = require "EMCache.EMCache"

function WBP_CommonChangeSceneBg_C:DestructSoundFunc()
    -- local bus = UE4.UFMODBlueprintStatics.FindAssetByName("bus:/sfx")
    -- local sfxvolume = EMCache:Get("FMODVolume") and EMCache:Get("FMODVolume")[3] or 1
    -- UE4.UFMODBlueprintStatics.BusSetVolume(bus:Cast(UE4.UFMODBus), sfxvolume)

    AudioManager(self):SetEventSoundParam(self, "Loading", { ToEnd = 1 })

    AudioManager(self):ResumePlayBGMCauseIsLoadingOrBlackScreen()
    AudioManager(self):RemoveAuANotifyForbidTag("LoadingUI")
end

function WBP_CommonChangeSceneBg_C:Tick(MyGeometry, InDeltaTime)

    if not self.bEnableTick then
        return
    end

    self.Overridden.Tick(self, MyGeometry, InDeltaTime)

    self.bShowThisFrame = false

    local PlayerController = UGameplayStatics.GetPlayerController(self, 0)
    if PlayerController and not self.bReset then
        self.bReset = true
    end
    -- local UIManager = UIManager(self)
    -- if PlayerController and UIManager and UIManager:GetUIObj("CommonDialog") then
    --     self:SetMouseCursorVisable(true)
    -- else
    --     self:SetMouseCursorVisable(false)
    -- end
    if not PlayerController then
        self.bReset = false
    end

    self.ShowTipsInterval = self.ShowTipsInterval - InDeltaTime
    if self.ShowTipsInterval <= 0 then
        self:SetRandomTips()
        if self.WidgetLoading and self.WidgetLoading.SetRandomTips then 
            self.WidgetLoading:SetRandomTips()
        end
    end
    if self.NowPercentNum >= 100  then
        self.NowPercentNum = 100
        self:UpdateShowUI()
        self:Close()
        return
    end
    if (math.abs(self.NowPercentNum - self.Next) < 0.1 ) or self.NowPercentNum >= self.Next then
        local NextNum = self:RemoveQueen()
        if NextNum > 0 then
            self.Next = NextNum
        end
    end
    if self.NowPercentNum <= self.Next then
        self.NowPercentNum = math.min(self.NowPercentNum +  InDeltaTime * 100, self.Next)
    end
    self:UpdateShowUI()

    
end


function WBP_CommonChangeSceneBg_C:UpdateShowUI()
    self.ProgressBar:SetPercent(self.NowPercentNum / 100)
    if self.NowPercentNum >= 100 then
        self.NowPercentNum = 100
    end
    self.Progress_Text_Bar:SetText(string.format("%.0f", self.NowPercentNum))
    if self.WidgetLoading then
        if self.WidgetLoading.UpdateProgressBar then 
            self.WidgetLoading:UpdateProgressBar(self.NowPercentNum)
        else 
            self.WidgetLoading.ProgressBar:SetPercent(self.NowPercentNum / 100)
            self.WidgetLoading.Text_Progress:SetText(string.format("%.0f", self.NowPercentNum))
            self.WidgetLoading.Text_Progress_Back:SetText(string.format("%.0f", self.NowPercentNum))
            -- if self.NowPercentNum >= 100 then
            --     self.WidgetLoading:PlayAnimation(self.WidgetLoading.Out)  
            -- end
        end
    end
end


---------- 往队列里添加数据   ------
function WBP_CommonChangeSceneBg_C:AddQuene(Progress)
    table.insert(self.QueenShow, Progress)
    DebugPrint("SL_LoadingDBG", "AddQuene: +", Progress, "  QueueLen =", #self.QueenShow)
    if Progress >= 100 then
        DebugPrint(WarningTag, LXYTag, "Loading进度应该结束了才对")
    end
end

function WBP_CommonChangeSceneBg_C:RemoveQueen()
    local NextNum = 0
    if not self.QueenShow[self.Index] then
        return 0 
    end
    NextNum = self.QueenShow[self.Index]
    self.CurrentIndex = self.Index
    self.Index = self.Index + 1
    if self.WidgetLoading then
        DebugPrint("SL_LoadingDBG", "RemoveQueen: pop=", NextNum, " NewIndex=", self.Index , "UIName = ",self.WidgetLoading:GetName())
    end
    return NextNum
end

function WBP_CommonChangeSceneBg_C:AddDynamic(FuncName)
    if type(FuncName) == "function" then
        table.insert(self.DynamicFunc, FuncName)
    end
end

function WBP_CommonChangeSceneBg_C:ExeDyanmicFunc()
    for _,func in ipairs(self.DynamicFunc) do
        func()
    end
    self:ClearDynamicFunc()
end

function WBP_CommonChangeSceneBg_C:ClearDynamicFunc()
    self.DynamicFunc = {}
end

function WBP_CommonChangeSceneBg_C:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function WBP_CommonChangeSceneBg_C:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    if not self.Com_KeyTitle then return end
    if IsUseKeyAndMouse then
        self.Com_KeyTitle:SetVisibility(ESlateVisibility.Collapsed)
        self.CurrentInputDevice = {"KeyboardKey","MouseButton"}
    else
        self.CurrentInputDevice = {"GamepadKey"}
        self.Com_KeyTitle:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Com_KeyTitle:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Img",
                    ImgShortPath = "A",
                },
            },
            bLongPress = false,
            Desc = GText('UI_CTL_Loading_Next'),
        })
    end
end

function WBP_CommonChangeSceneBg_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 输入设备切换通知
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    self:SetRandomTips()
end

-- function WBP_CommonChangeSceneBg_C:OnPreviewKeyDown(MyGeometry, InKeyEvent)

--     local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
--     local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
--     local IsEventHandled = false
--     if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
--         if InKeyName == Const.GamepadFaceButtonDown then
--             EventManager:FireEvent(EventID.OnLoadingGamePadA)
--             DebugPrint("OnPreviewKeyDownOnPreviewKeyDownOnPreviewKeyDownOnPreviewKeyDown")
--             --IsEventHandled = true
--         end
--     end
--     if (IsEventHandled) then
--         return UWidgetBlueprintLibrary.Handled()
--     else
--         return UWidgetBlueprintLibrary.UnHandled()
--     end
-- end


function WBP_CommonChangeSceneBg_C:GetSceneLoadProgress()
    if self.IsRandomScene then
        if (self.NowPercentNum >= 100.0) then
            self:Close()
        end
    else
        if (self.NowLoadLevelName ~= nil and self.NowLoadAssetId ~= nil) then
            self.NowPercentNum = UE4.UResourceLibrary.GetLoadProgress(self, self.NowLoadLevelName, self.NowLoadAssetId)
        end
    end
    return self.NowPercentNum / 100.0
end

-- function WBP_CommonChangeSceneBg_C:SetXiaoBaiRandomTips()
--     --self.ShowTipsInterval = Const.LoadingTipsInterval
--     local RandomTips = self:GetRandomLoadingTips()
--     self.WidgetLoading.Text_Title:SetText(RandomTips.Title)
--     local Messages = self:AnalyzeText(RandomTips.Message)
--     local Content = ""
--     for _, Message in ipairs(Messages) do
--         if string.find(Message, "&") then
--             local ActionName = string.sub(Message, 2, -2)
--             -- print(_G.LogTag, ActionName)
--             local Key, KeyType = self:GetKeyName(ActionName)        
--             Content = Content .. Key
--         else
--             Content = Content .. Message
--         end
--     end
--     self.WidgetLoading.Text_Message:SetText(Content)
-- end

function WBP_CommonChangeSceneBg_C:SetRandomTips()
    -- while self.VerticalBox_Message:GetChildrenCount() > 1 do
    --     self.VerticalBox_Message:RemoveChildAt(1)
    -- end
    self.ShowTipsInterval = Const.LoadingTipsInterval
    local RandomTips = self:GetRandomLoadingTips()
    self.Text_Title:SetText(RandomTips.Title)
    local Messages = self:GetFinalContentText(RandomTips.Message,self.CurrentInputDevice)
    -- local Content = ""
    -- for _, Message in ipairs(Messages) do
    --     if string.find(Message, "&") then
    --         local ActionName = string.sub(Message, 2, -2)
    --         -- print(_G.LogTag, ActionName)
    --         local Key, KeyType = self:GetKeyName(ActionName)        
    --         Content = Content .. Key
    --     else
    --         Content = Content .. Message
    --     end
    -- end
    self.Text_Message:SetText(Messages)
    -- ---@type UHorizontalBox
    -- local HorizontalBox = NewObject(UHorizontalBox, self)
    -- local Slot = self.VerticalBox_Message:AddChildToVerticalBox(HorizontalBox)
    -- Slot:SetPadding(FMargin(0, 30, 0, 0))
    -- Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Center)
    -- for _, Message in ipairs(Messages) do
    --     if string.find(Message, "&") then
    --         ---@type Common_Key_Hud_PC_C
    --         local CommonKeyUI = NewObject(self.ImageContentClass, self)
    --         local TextSlot = HorizontalBox:AddChildToHorizontalBox(CommonKeyUI)
    --         TextSlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    --         self:SetCommonKey(CommonKeyUI, Message)
    --     else
    --         ---@type UTextBlock
    --         local TextBlock = NewObject(UTextBlock, self)
    --         local TextSlot = HorizontalBox:AddChildToHorizontalBox(TextBlock)
    --         TextBlock:SetText(Message)
    --         TextBlock:SetAutoWrapText(true)
    --         TextBlock:SetColorAndOpacity(self.TextColorOpacity)
    --         TextBlock:SetFont(self.TextFont)
    --         TextBlock:SetJustification(ETextJustify.Center)
    --         TextSlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    --     end

    --     if string.find(Message, "\n") then
    --         HorizontalBox = NewObject(UHorizontalBox, self)
    --         Slot = self.VerticalBox_Message:AddChildToVerticalBox(HorizontalBox)
    --         Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Center)
    --     end
    -- end
  --  self.Text_Message:SetText(RandomTips.Message)
end

---@param CommonKeyUI Common_Key_Hud_PC_C
function WBP_CommonChangeSceneBg_C:SetCommonKey(CommonKeyUI, KeyInfo)
    local ActionName = string.sub(KeyInfo, 2, -2)
    -- print(_G.LogTag, ActionName)
    local Key, KeyType = self:GetKeyName(ActionName)

    if ActionName == "ControlAngle" then
        CommonKeyUI:SetImgByFullPath("Texture2D'/Game/UI/UI_PNG/Common/Key/Icon_Mouse_Button.Icon_Mouse_Button'")
        return
    end

    if ActionName == "ControlMove" then
        CommonKeyUI:SetTextInfo("WASD")
        return
    end

    if KeyType == "KeyboardKey" then
        CommonKeyUI:SetTextInfo(Key)
    elseif KeyType == "MouseButton" or KeyType == "GamepadKey" then
        CommonKeyUI:SetImgInfo(Key)
    end
end

-- function WBP_CommonChangeSceneBg_C:AnalyzeText(MessageContent)
--     if not MessageContent then
--         return {}
--     end
--     local MatchRes = {}
--     local MatchWord = string.gmatch(MessageContent, "&%w+&")
--     for word in MatchWord do
--         -- print(_G.LogTag, word)
--         local start_index, end_index = string.find(MessageContent, word)
--         table.insert(MatchRes, string.sub(MessageContent, 1, start_index - 1))
--         table.insert(MatchRes, word)
--         MessageContent = string.sub(MessageContent, end_index + 1)
--     end
--     table.insert(MatchRes, MessageContent)
--     return MatchRes
-- end

function WBP_CommonChangeSceneBg_C:GetRandomLoadingTips()
    if not self.TipsPoolByPlatform then
        self.TipsPoolByPlatform = {
            PC = {},
            Mobile = {},
            Gamepad = {}
        }

        local TipsTable = DataMgr.Message

        for _, v in pairs(TipsTable) do
            if v.MessageType == "LoadingText" then
                -- PC Tips
                if v.MessageContentPC then
                    table.insert(self.TipsPoolByPlatform.PC, {
                        Title = GText(v.MessageTitlePC or ""),
                        Message = GText(v.MessageContentPC)
                    })
                end

                -- Mobile Tips
                if v.MessageContentPhone then
                    table.insert(self.TipsPoolByPlatform.Mobile, {
                        Title = GText(v.MessageTitlePC or ""),
                        Message = GText(v.MessageContentPhone)
                    })
                end

                -- Gamepad Tips
                --Gamepad：优先使用 GamePad 字段，否则使用 PC 字段
                local gamepadMsg = v.MessageContentGamePad or v.MessageContentPC
                if gamepadMsg then
                    table.insert(self.TipsPoolByPlatform.Gamepad, {
                        Title =  GText(v.MessageTitlePC or ""),
                        Message = GText(gamepadMsg)
                    })
                end
            end
        end
    end

    local TipsList = nil
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        TipsList = self.TipsPoolByPlatform.Gamepad
    elseif CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        TipsList = self.TipsPoolByPlatform.PC
    elseif CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        TipsList = self.TipsPoolByPlatform.Mobile
    end

    -- 防止空
    if not TipsList or #TipsList == 0 then
        return { Title = "", Message = "" }
    end

    local RandomIndex = math.random(1, #TipsList)
    return TipsList[RandomIndex]
end

---废弃，改到AfterLoadingMgr里面
-- function WBP_CommonChangeSceneBg_C:SystemGuideInitData()
--     SystemGuideManager:AddListenerSystemGuide()
-- 	local DungeonId = GWorld.GameInstance:GetCurrentDungeonId()
-- 	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
--     if(not GWorld.GameInstance:IsNullDungeonId(DungeonId)) then
--         DebugPrint("SystemGuide Enter Dungeon" )
--         EventManager:FireEvent(EventID.ExitRegion)
--         EventManager:FireEvent(EventID.SystemGuideEnterDungeon, DungeonId)
--         -- self:AddTimer(0.1,
-- 		-- function() --延迟触发等切到玩家模式
--         --     EventManager:FireEvent(EventID.SystemGuideEnterDungeon, DungeonId)
--         -- end,
-- 		-- false, 0, "WBP_CommonChangeSceneBg_C_Close", true)
--     elseif(GameMode ~= nil and GameMode.IsInRegion and GameMode:IsInRegion()) then
--         local CurMode =  UE4.URuntimeCommonFunctionLibrary.GetInputMode(GWorld.GameInstance:GetWorld())
--         DebugPrint("SystemGuide Enter Region" ,CurMode)
--         EventManager:FireEvent(EventID.SystemGuideEnterRegion)
--         -- self:AddTimer(0.1,
-- 		-- function() --延迟触发等切到玩家模式
--         --     EventManager:FireEvent(EventID.SystemGuideEnterRegion)
--         -- end,
-- 		-- false, 0, "WBP_CommonChangeSceneBg_C_Close", true)
--     else
--         DebugPrint( "ERROR:SystemGuide Not Enter Region And Not Enter Dungeon")
--     end

-- end

function WBP_CommonChangeSceneBg_C:RealCloseLoading()
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    EventManager:FireEvent(EventID.CloseLoading, PlayerCharacter and PlayerCharacter.Eid)
    self.bIsInLoading = nil
    if self.WidgetLoading then
        self.bEnableTick = false
        DebugPrint("SL_LoadingDBG 关闭当前Loading  UIName :",self.WidgetLoading:GetName())
        if self.WidgetLoading.Out then
            self.WidgetLoading:UnbindAllFromAnimationFinished(self.WidgetLoading.Out)
            self.WidgetLoading:BindToAnimationFinished(self.WidgetLoading.Out, {self , self.OnOutAnimationFinished})
            self.WidgetLoading:PlayAnimation(self.WidgetLoading.Out)
        else
            self:OnOutAnimationFinished()
        end
    else
        if not self.bShowThisFrame then
            GWorld.GameInstance:CloseLoadingUI()
            ---@note Loading之后要处理的其他模块业务逻辑已经迁移到AfterLoadingMgr.lua里面了
            --- 后面有在Loading之后执行操作的需求，要么监听CloseLoading事件，要么在AfterLoadingMgr的状态机里扩展一个状态
            UIManager(self):LaunchAfterLoadingMgr()
        end 
    end
    self:SetMouseCursorVisable(true)
    
    -- 关Loading后开启同步加载优化
     print(_G.LogTag, "SetSyncLoaderOptimization True")
     GWorld.GameInstance:SetSyncLoaderOptimization(true)
end

function WBP_CommonChangeSceneBg_C:Close()
    self:ExeDyanmicFunc()
    self:RealCloseLoading()
end

function WBP_CommonChangeSceneBg_C:OnLevelRemovedFromWorld_Lua()
    self.bReset = false
end

function WBP_CommonChangeSceneBg_C:OnOutAnimationFinished()
    if not self.WidgetLoading then
        return
    end
    if not self.bShowThisFrame then
        DebugPrint("SL_LoadingDBG OnOutAnimationFinished 销毁当前Loading  UIName :",self.WidgetLoading:GetName())
        GWorld.GameInstance:CloseLoadingUI()
        UIManager(self):LaunchAfterLoadingMgr()
    end
end

AssembleComponents(WBP_CommonChangeSceneBg_C)
return WBP_CommonChangeSceneBg_C