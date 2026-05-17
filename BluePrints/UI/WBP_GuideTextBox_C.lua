require "UnLua"
require "DataMgr"

local ExpressionComp_C = require "BluePrints.Story.Talk.Controller.ExpressionComp"

---@class WBP_GuideTextBox_C:BP_TalkBaseUINew_C
local WBP_GuideTextBox_C = Class("BluePrints.UI.BP_UIState_C")
local EMCache = require "EMCache.EMCache"

function WBP_GuideTextBox_C:Initialize(Initializer)
    WBP_GuideTextBox_C.Super.Initialize(self, Initializer)
end

function WBP_GuideTextBox_C:Construct()
    self.GuideManIdx = 0
    self.GuideManInfos = {}
    self.ExpressionComp = ExpressionComp_C.New()
    self.LastGuideManActor = nil
    self.bIsFocusable = true
    self:SetKeyboardFocus()
    for i=0 ,10 do
        self:AddTimer(0.05 * i, self.SetKeyboardFocus)
        -- DebugPrint(i, "===============================SetKeyboardFocus============================================")
    end
    self:InitGamePadKeyButton()
    WBP_GuideTextBox_C.Super.Construct(self)
    self.IsDestroied = false
    self:InitListenEvent()
    self:SetFocus()
end

function WBP_GuideTextBox_C:Destruct()
    WBP_GuideTextBox_C.Super.Destruct(self)
    self.Btn_Skip.OnClicked:Remove(self, self.OpenWindow)
    if(self.IsTimePause) then 
        self:UISetGamePaused("GuideTextBox",false)
    end
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self,self.RefreshOpInfoByInputDevice) 
    end
    local GameInstance = GWorld.GameInstance
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    self:SetInputUIOnly(false)
    if PlayerCharacter then
        PlayerCharacter:RemoveDisableInputTag("ResetPlayerState")
    end
end

function WBP_GuideTextBox_C:OpenWindow()
    if self.bOpenWindow then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/special_content_01_click", nil, nil)
    if self.Controller_Skip then
        self.Controller_Skip:PlayAnimation(self.Controller_Skip.Normal)
    end
    local GuideSkip = EMCache:Get("GuideSkip", true)
    if GuideSkip then
        self:SkipGuide()
        return
    end
    self.bOpenWindow = true
    local Params = {}
    Params.RightCallbackObj = self
    Params.RightCallbackFunction = function(_, Data, PopupUI)
        self:SkipGuide()
        self:UpdateSelectedInfo(Data)
    end
    Params.OnCloseCallbackFunction = function(_, Data, PopupUI)
        self.bOpenWindow = false
    end
    UIManager(self):ShowCommonPopupUI(100291, Params, self, nil, 105)

end

function WBP_GuideTextBox_C:UpdateSelectedInfo(Data)
    local IsSelected = Data.SelectHint.IsSelected
    EMCache:Set("GuideSkip", IsSelected, true)
end




function WBP_GuideTextBox_C:GuideUIInit_TextGuide(UIKey, MessageId, GuidemanHead, GuideManPosEnum, Time, ExecuteLogic, IsTimeDilation, IsForceClick, IsResetPlayer, IsForbidInAnim, IsForbidOutAnim)
    self:AddGuideMessage(UIKey, MessageId, IsTimeDilation, GuidemanHead, GuideManPosEnum, IsResetPlayer, IsForbidInAnim, IsForbidOutAnim)
end

function WBP_GuideTextBox_C:Hide(HideTag)
    -- 重新一下基类的方法
    -- if (self.UIStateTag ~= nil) then
    --     UIManager(self):AddUIToStateTagsCluster(self.UIStateTag, self.ConfigName, false)
    -- end
    -- 暂停声音
    AudioManager(self):PauseObjectAllEvent(self, true)
    if self.IgnoreHideTags and CommonUtils.HasValue(self.IgnoreHideTags, HideTag) then
        return
    end
    HideTag = HideTag or "DefaultTag"
    self:SetUIVisibilityTag(HideTag, true)
    self:SetInputUIOnly(false)
    if (self.IsUIPopUp == true) then
        UIManager(self):OpenResidentUI(self.WidgetName)
    end
    if self.IsTimePause then
        self:UISetGamePaused(self.WidgetName or self.ConfigName,false)
    end
    if self.KeyboardSetName and self.IsBanningAction then 
        UIManager(self):SetBannedActionCallback(self.KeyboardSetName, false, self:GetName())
        self.IsBanningAction = nil
    end
end

function WBP_GuideTextBox_C:Show(ShowTag)
    -- 重新一下基类的方法
    -- if (self.UIStateTag ~= nil) then
    --     UIManager(self):AddUIToStateTagsCluster(self.UIStateTag, self.ConfigName, true)
    -- end
    -- 开启声音
    AudioManager(self):PauseObjectAllEvent(self, false)
    ShowTag = ShowTag or "DefaultTag"
    self:SetUIVisibilityTag(ShowTag, false)
    --if (self.IsInUIMode) then
        self:SetInputUIOnly(true)
    --end
    if (self.IsUIPopUp == true) then
        UIManager(self):CloseResidentUI(self.WidgetName)
    end
    if self.IsTimePause then
        self:UISetGamePaused(self.WidgetName or self.ConfigName,true)
    end
    if self.KeyboardSetName and not self.IsBanningAction then 
        UIManager(self):SetBannedActionCallback(self.KeyboardSetName, true, self:GetName())
        self.IsBanningAction = true
    end
end

function WBP_GuideTextBox_C:AddGuideMessage(UIKey, MessageId, IsTimePause, GuidemanHead, GuideManPosEnum, IsResetPlayer, IsForbidInAnim, IsForbidOutAnim)
    self.IsForbidInAnim = IsForbidInAnim
    self.IsForbidOutAnim = IsForbidOutAnim
    self.MessageId = MessageId
    self.UIKey = UIKey
    self.IsTimePause = IsTimePause
    self.Btn_Confirm:SetGamePadImg("A")
    local TextMapId = CommonUtils.ChooseOptionByPlatform(DataMgr.Message[MessageId].MessageContentPC, DataMgr.Message[MessageId].MessageContentPhone)
    local TitleId = DataMgr.Message[MessageId].MessageTitlePC
    local MessageContent = GText(TextMapId)
    local TitleContent = GText(TitleId)
    self.TitleContent = TitleContent
    self.Text_Guide_Name:SetText(TitleContent)
    self.Btn_Confirm:SetGamePadIconVisible(true)
    local function ParseActionMapContent(SourceContent)
        local FirstIndex = string.find(SourceContent, "&")
        if not FirstIndex then
            return SourceContent
        end
        local SecondIndex = string.find(SourceContent, "&", FirstIndex + 1)
        local ActionContent = string.sub(SourceContent, FirstIndex + 1, SecondIndex - 1)
        local ActionMapContent = GText(DataMgr.KeyboardMap[ActionContent].Key)

        local sub1 = string.sub(SourceContent, 1, FirstIndex - 1)
        local sub2 = string.sub(SourceContent, SecondIndex + 1)

        return sub1..ActionMapContent..sub2
    end
    MessageContent = ParseActionMapContent(MessageContent)

    self.Text_Content:SetText(MessageContent)
    -- UE4.UGameplayStatics.SetGlobalTimeDilation(self, 0)
    self:PlayInAnimation()
    local GameInputSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    self.PreMode = GameInputSubsystem:GetCurrentInputMode()
    -- self.PreMode = UE4.URuntimeCommonFunctionLibrary.GetInputMode(self:GetWorld())
    self:SetInputUIOnly(true)
    if(self.IsTimePause) then
        self:UISetGamePaused("GuideTextBox",true)
        -- self.HadPaused = false
        -- local CurGameMode = UE4.UGameplayStatics.GetGameMode(self)
        -- local IsPaused = false
		-- if CurGameMode then
		-- 	IsPaused = UE4.UGameplayStatics.IsGamePaused(CurGameMode)
		-- end
		-- if(not IsPaused) then
        --     self:UISetGamePaused("GuideTextBox",true)
        --     self.HadPaused = true
        -- end
    end
    self.Btn_Confirm:SetText(GText("UI_LOGIN_ENSURE"))
    self.Btn_Confirm:BindEventOnClicked(self, self.PlayOutAnimation)
    self.Btn_Skip.OnClicked:Add(self, self.OpenWindow)
    DebugPrint("WBP_GuideTextBox_C:GuideUIInit_TextGuide: GuideManPosEnum", GuideManPosEnum)
    self:SetGuideCanvasRelativePosition(GuideManPosEnum)
    self:PlayTextGuide(GuidemanHead)
    if IsResetPlayer then
        local GameInstance = GWorld.GameInstance
        local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
        local Battle = Battle(PlayerCharacter)
         local TraceInfo="From WBP_GuideTextBox_C:AddGuideMessage"
        if (PlayerCharacter:CharacterInTag("Idle") == false or Battle:CheckConditionNew(11, PlayerCharacter, nil,TraceInfo) == false) then
            self:BlackScreenUIFadeIn()
            -- self:AddTimer(0.1, self.BlackScreenUIFadeIn)
            --self:AddTimer(1, self.BlackScreenUIFadeOut)
        end
    end
    self:InitGamePadKeyButton()
    self.bSkip = 0
    if SystemGuideManager.RunningId ~= -1 then
        self.bSkip = DataMgr.SystemGuide[SystemGuideManager.RunningId].GuideSkip
    end
    if self.bSkip == 1 then
        self.Text_Skip:SetText(GText("UI_SkipGuide"))
        self.Panel_Skip:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Panel_Skip:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end 
    local bIsGamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
    if bIsGamepad and self.bSkip == 1 then
        self.Controller_Skip:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    end
    

end

function WBP_GuideTextBox_C:BlackScreenUIFadeIn()
    self.OriginalVisibility = self:GetVisibility()
    self:SetVisibility(UE4.ESlateVisibility.Hidden)
    local GameInstance = GWorld.GameInstance
    local UIManger = GameInstance:GetGameUIManager()
    local Params = {}

    Params.InAnimationObj = self
    Params.InAnimationCallback = self.ResetPlayerStateStart
    Params.InAnimationPlayTime = 0.5
    Params.BlackScreenHandle = "GuideTextBox"
    Params.OutAnimationObj = self
    Params.OutAnimationCallback = self.ResetPlayerStateEnd
    Params.OutAnimationPlayTime = 0.5
    UIManger:ShowCommonBlackScreen(Params)
    self:AddTimer(1, function()
        UIManger:HideCommonBlackScreen("GuideTextBox")
    end)
	-- self.BlackScreenUI:AddToViewport()
	-- self.BlackScreenUI:FadeIn(0.5, {
	-- 	Obj = self,
	-- 	Func = self.ResetPlayerStateStart,
	-- 	Params = {}
	-- })
end

function WBP_GuideTextBox_C:BlackScreenUIFadeOut()
    -- local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    -- local UIManger = GameInstance:GetGameUIManager()
    -- self:SetVisibility(self.OriginalVisibility)
    -- Params.InAnimationObj = self
    -- Params.InAnimationCallback = self.ResetPlayerStateStart
    -- Params.InAnimationPlayTime = 0.5

    -- UIManger:ShowCommonBlackScreen(Params)
    -- self.BlackScreenUI:FadeOut(0.5, {
	-- 	Obj = self,
	-- 	Func = self.ResetPlayerStateEnd,
	-- 	Params = {}
	-- })
end

function WBP_GuideTextBox_C:ResetPlayerStateStart()
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
        self:UISetGamePaused("GuideTextBox",false)
    end
    -- GameMode:SetGamePaused("ResetPlayerState", true)
	PlayerCharacter:AddDisableInputTag("ResetPlayerState")
    -- self:AddTimer(0.5, self.ResetPlayerStateEnd)
end

function WBP_GuideTextBox_C:ResetPlayerStateEnd()
    DebugPrint("==========================================================ResetPlayerStateEnd")
    local GameInstance = GWorld.GameInstance
    local GameMode = UE4.UGameplayStatics.GetGameMode(GameInstance)
    if self.IsTimePause then
        self:UISetGamePaused("GuideTextBox",true)
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

function WBP_GuideTextBox_C:SetGuideCanvasRelativePosition(GuideManPosEnum)
    local CanvasSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Panel_Guide)
    local ViewportSize = UIManager(self):GetViewportSize()
    local RelativePositionScaleTable = {
        ["Up"] = {x = 0, y = -0.1},
        ["Down"] = {x = 0, y = 0.1},
        ["Left"] = {x = -0.1, y = 0},
        ["Right"] = {x = 0.1, y = 0},
        ["Middle"] = {x = 0, y = 0},
        ["Upleft"] = {x = -0.1, y = -0.1},
        ["DownLeft"] = {x = -0.1, y = 0.1},
        ["UpRight"] = {x = 0.1, y = -0.1},
        ["DownRight"] = {x = 0.1, y = 0.1},
    }
    local ViewPortScale = UWidgetLayoutLibrary.GetViewportScale(self)
    DebugPrint("WBP_GuideTextBox_C:SetGuideCanvasRelativePosition:", ViewportSize, ViewportSize.X * RelativePositionScaleTable[GuideManPosEnum].x, ViewportSize.Y * RelativePositionScaleTable[GuideManPosEnum].y)
    CanvasSlot:SetPosition(FVector2D(ViewportSize.X / ViewPortScale * RelativePositionScaleTable[GuideManPosEnum].x, ViewportSize.Y / ViewPortScale * RelativePositionScaleTable[GuideManPosEnum].y))
end

function WBP_GuideTextBox_C:PlayTextGuide(GuidemanHead)
	self:MakeGuideManInfo(GuidemanHead)
end



function WBP_GuideTextBox_C:GetOrCreateNewGuideManInfo(GuidemanConfigId, GuidemanConfigData)
    if self.GuideManInfos[GuidemanConfigId] then
        local Info = self.GuideManInfos[GuidemanConfigId]
        return Info.GuideMan,Info.Idx,Info.DriveCameraConfig
    end

    local function JointFinalAnimPath(ModelId,Path,SubPath)
        local ModelData = DataMgr.Model[ModelId]
        local MontageFolder = ModelData.MontageFolder
        local Prefix = ModelData.MontagePrefix
        -- 将MontageFolder中的Montage替换为Sequence
        local SequenceFolder = string.gsub(MontageFolder,"Montage","Sequence")
        return SequenceFolder..SubPath.."/"..Prefix..Path
    end

    local GuideManIdx = self.GuideManIdx
    self.GuideManIdx = self.GuideManIdx + 1
    local Transform = FTransform(FRotator(0, 0, 0):ToQuat(), FVector(0, 0 + GuideManIdx * 10000, -50000))
    local GuideMan = nil
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then
        return
    end
    local function LoadFinishCallback(Unit)
        GuideMan = Unit
    end
    GameMode.EMGameState.EventMgr:CreateAIUnit({
        UnitId = GuidemanConfigData.NpcId,
        RoleId = GuidemanConfigData.NpcId,
        UnitType = "Npc",
        Loc = FVector(Transform.Translation.X, Transform.Translation.Y, Transform.Translation.Z),
        ActorPath = "Blueprint'/Game/AssetDesign/Char/Npc/GuideMan/BP_GuideMan.BP_GuideMan_C'",
        LoadFinishCallback = LoadFinishCallback,
    }, true)


    local NpcData = DataMgr.Npc[GuidemanConfigData.NpcId]
    local MeshPath = GuidemanConfigData.OverrideNpcMeshPath or DataMgr.Model[NpcData.ModelId].SkeletonMeshPath
    local TargetMesh = LoadObject("/Game/"..MeshPath)
    local CaptureTargetMesh = LoadObject("/Game/AssetDesign/Char/Npc/GuideMan/RT_GuideTextNodeMan.RT_GuideTextNodeMan")


    GuideMan.Mesh:SetSkeletalMesh(TargetMesh)
    GuideMan.CaptureCam.TextureTarget = CaptureTargetMesh
    GuideMan.CaptureCam:ShowOnlyComponent(GuideMan.Mesh)
    GuideMan.CaptureCam:ShowOnlyComponent(GuideMan.ExpressionMask)
    GuideMan.CaptureCam:ShowOnlyComponent(GuideMan.Sphere)

    local AnimInstance = GuideMan.Mesh:GetAnimInstance()
    if (AnimInstance) then
        local FinalAnimPath = JointFinalAnimPath(NpcData.ModelId,GuidemanConfigData.GuidemanDefaultActionPath,"Interactive")
        local DefaultAnim = LoadObject(FinalAnimPath)
        if not DefaultAnim then
            FinalAnimPath = JointFinalAnimPath(NpcData.ModelId,GuidemanConfigData.GuidemanDefaultActionPath, "Locomotion")
            DefaultAnim = LoadObject(FinalAnimPath)
        end
        DebugPrint("DefaultAnim",DefaultAnim,FinalAnimPath)
        AnimInstance:SetNpcDefaultAnimEnable(true)
        AnimInstance:SetNpcDefaultAnim(DefaultAnim)
    end
    local DriveCameraConfig = {
        CameraHeight = GuidemanConfigData.CameraHeight,
        CameraYaw = GuidemanConfigData.CameraYaw,
        CameraDistance = GuidemanConfigData.CameraDistance,
        SocketName = GuidemanConfigData.SocketName,
        CameraFOV = GuidemanConfigData.CameraFOV
    }
    self.GuideManInfos[GuidemanConfigId] = {
        GuideMan = GuideMan,
        Idx = GuideManIdx,
        DriveCameraConfig = DriveCameraConfig
    }
    return GuideMan, GuideManIdx, DriveCameraConfig
end

function WBP_GuideTextBox_C:CameraFocusActor(Idx, TalkActor, CameraParams)
    -- 获取TalkActor 骨骼位置
    local SocketName = CameraParams.SocketName or "head"
    local SocketLoc = TalkActor.Mesh:GetSocketLocation(SocketName)
    local TalkActorRot = TalkActor:K2_GetActorRotation()
    local TalkActorLoc = TalkActor:K2_GetActorLocation()
    DebugPrint("CameraFocusActor",SocketLoc)
    
    local FinalLoc = UKismetMathLibrary.Add_VectorVector( FVector(SocketLoc.X,SocketLoc.Y,SocketLoc.Z+CameraParams.CameraHeight),
    UKismetMathLibrary.Multiply_VectorFloat(UKismetMathLibrary.Conv_RotatorToVector(
        FRotator(TalkActorRot.Pitch,TalkActorRot.Yaw-CameraParams.CameraYaw,TalkActorRot.Roll)),CameraParams.CameraDistance))
    local FinalRot = UKismetMathLibrary.FindLookAtRotation(FinalLoc,FVector(TalkActorLoc.X,TalkActorLoc.Y,FinalLoc.Z))
    DebugPrint("CameraFocusActor",SocketLoc,TalkActorRot,FinalRot,FinalLoc)
    if(self.LastGuideManActor) then
        self.LastGuideManActor.CaptureCam:SetComponentTickEnabled(false)
    end
    TalkActor.CaptureCam:SetComponentTickEnabled(true)
    DebugPrint("K2_SetWorldTransform",FinalLoc,FinalRot)
    TalkActor.CaptureCam:K2_SetWorldTransform(UE4.UKismetMathLibrary.MakeTransform(FinalLoc,FinalRot), false, nil, false)

    TalkActor.CaptureCam.FOVAngle =  CameraParams.CameraFOV or 20

    self.LastGuideManActor = TalkActor
end


function WBP_GuideTextBox_C:GetImageWidget()
    return self.Img_Animation01
end

function WBP_GuideTextBox_C:MakeGuideManInfo(GuidemanHead)
    if GuidemanHead == nil or GuidemanHead == '' then
        self:GetImageWidget():SetVisibility(UE4.ESlateVisibility.Collapsed)
        if (self.TitleContent == nil or self.TitleContent == "") then
            self.Line:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    else
        local Success = UIUtils.SwitchGuideHead(GuidemanHead, self.GuideManMID)
        if Success == false then
            self:GetImageWidget():SetVisibility(UE4.ESlateVisibility.Collapsed)
            if (self.TitleContent == nil or self.TitleContent == "") then
                self.Line:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
        else
            self:GetImageWidget():SetVisibility(UE4.ESlateVisibility.Visible)
        end
    end
end

function WBP_GuideTextBox_C:PlayInAnimation()
    local InAnimation = self.Auto_In
    self:PlayAnimation(InAnimation)
    DebugPrint("================WBP_GuideTextBox_C:PlayInAnimation==================",self.IsForbidInAnim)
    if self.IsForbidInAnim ~= true then
        self:PlayAnimation(self.Bg_In)
    else
        self.Bg_Black:SetRenderOpacity(1)
    end
end

function WBP_GuideTextBox_C:PlayOutAnimation()
    if self.IsPlayingOutAnimation then
        return
    end
    self.IsPlayingOutAnimation = true
    local TimerTime = 0
    local OutAnimation = self.Auto_Out
    self:PlayAnimation(OutAnimation)
    TimerTime = OutAnimation:GetEndTime() * UE4.UGameplayStatics.GetGlobalTimeDilation(self)
    self:AddTimer(TimerTime, self.Close)
    DebugPrint("================WBP_GuideTextBox_C:PlayOutAnimation==================",self.IsForbidOutAnim)
    if self.IsForbidOutAnim ~= true then
        self:PlayAnimation(self.Bg_Out)
    end
end

function WBP_GuideTextBox_C:Close()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManger = GameInstance:GetGameUIManager()

    local IsNeedResetInputMode = false
    IsNeedResetInputMode = self.PreMode ~= EGameInputMode.UI and self.PreMode ~= EGameInputMode.GameAndUI
    IsNeedResetInputMode = true
    -- IsNeedResetInputMode = self.PreMode ~= "UIOnly" and self.PreMode ~= "GameAndUI"
    if(IsNeedResetInputMode) then
        self:SetInputUIOnly(false)
    else
        local TopUI = UIManger:GetTopUIModeUI(self)
        if(TopUI ~= nil) then
            DebugPrint("=SystemGuide==GuideTextBox==TopUI:SetKeyboardFocus=============TopUIName:", TopUI:GetName())
            --TopUI.bIsFocusable = true
            TopUI:SetKeyboardFocus()
        end
    end
    if(self.IsTimePause) then -- and self.HadPaused) then
        self:UISetGamePaused("GuideTextBox",false)
    end
    
    UIManger:UnLoadUI(self.UIKey)

    if SystemGuideManager.RunningId > 0 then
        DebugPrint("GuideTextBox UploadTrackLog_Lua guide_step_client step_id:", SystemGuideManager.RunningId, "branch_guide_id:", self.MessageId)
        HeroUSDKSubsystem():UploadTrackLog_Lua("guide_step_client", 
        { 
            step_id = SystemGuideManager.RunningId,
            branch_guide_id = self.MessageId
        })
    end

    if self.OnGuideEnd:IsBound() then
        self.OnGuideEnd:Broadcast()
    end
    self.IsDestroied = true
end

-- function WBP_GuideTextBox_C:Destruct()
--     WBP_GuideTextBox_C.Super.Destruct(self)
   
-- end
function WBP_GuideTextBox_C:SkipGuide()
    -- if self.IsFromStl then
    --     SystemGuideManager:RemoveCurStl()
    -- end

    -- local StorylineUtils = require "StoryCreator.StoryLogic.StorylineUtils"
    -- StorylineUtils.MarkGuideStoryError()
    local Path =  DataMgr.SystemGuide[SystemGuideManager.RunningId].GuideStoryline
    GWorld.StoryMgr:StopStoryline(Path,false)

    --尝试恢复暂停的AfterLoading状态机
    --UIManager():TryResumeAfterLoadingMgr({"TriggerGuide","MainLineQuest","DynamicQuest"})
    self:Close()



end

function WBP_GuideTextBox_C:OnKeyDown(MyGeometry, InKeyEvent)
    -- DebugPrint("===================WBP_GuideTextBox_C======OnKeyDown===============================================================")
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == "Gamepad_FaceButton_Bottom") then
        self:PlayOutAnimation()
    elseif  InKeyName == "Gamepad_Special_Right" and self.bSkip == 1 then
        self.Controller_Skip:OnButtonPressed()
     end
    
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function WBP_GuideTextBox_C:OnKeyUp(MyGeometry, InKeyEvent)
    -- DebugPrint("===================WBP_GuideTextBox_C======OnKeyDown===============================================================")
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if InKeyName == "Gamepad_Special_Right" then
        self.Controller_Skip:OnButtonReleased()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end


function WBP_GuideTextBox_C:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    -- local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    -- local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    -- local InputEvent = UWidgetBlueprintLibrary.GetInputEventFromKeyEvent(InKeyEvent)
    -- local IsRepeat = UKismetInputLibrary.InputEvent_IsRepeat(InputEvent)
    -- if IsRepeat then
    --     return  UWidgetBlueprintLibrary.Handled()
    -- end
    -- if (InKeyName == "Gamepad_FaceButton_Bottom") then
    --     self:PlayOutAnimation()
    -- elseif InKeyName == "Gamepad_Special_Right" and self.bSkip then
    --     self.Controller_Skip:OnButtonPressed()
    -- end
    -- return UE4.UWidgetBlueprintLibrary.Handled()
end

-- function WBP_GuideTextBox_C:OnPreviewKeyUp(MyGeometry, InKeyEvent)
--     local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
--     local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
--     if (InKeyName == "Gamepad_FaceButton_Bottom") then
--         self:PlayOutAnimation()
--     elseif InKeyName == "Gamepad_Special_Right" then
--         self.Controller_Skip:OnButtonReleased()
--     end
--     return UE4.UWidgetBlueprintLibrary.Handled()
-- end

function WBP_GuideTextBox_C:InitKeyButton()
    self.Key_Skip:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Text",
                Text = "Esc",
            }
        },
    })
end

function WBP_GuideTextBox_C:InitGamePadKeyButton()
    self.Controller_Skip:CreateCommonKey({
        KeyInfoList = {
            {
                ImgShortPath = "Menu",
                Type = "Img",
            }
        },
        bLongPress = true,
        
    })
    self.Controller_Skip:AddExecuteLogic(self, self.OpenWindow)
end



--------------------手柄相关------------------------------




function WBP_GuideTextBox_C:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice) 
    end
end

function WBP_GuideTextBox_C:RefreshBaseInfo()
    -- 刷新一些基础信息
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function WBP_GuideTextBox_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 切换手柄端相关图标显隐
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        if self.bSkip == 1 then
            self.Controller_Skip:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end

    else
        if self.bSkip == 1 then
            self.Controller_Skip:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        end

         --self:SetFocusTarget(self.Btn_Confirm)
         self:AddTimer(0.01, function()
            if not self.bOpenWindow then
                self.GameInputModeSubsystem:SetTargetUIFocusWidget(self)
            end
        --  self.Btn_Confirm:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
        --  self.Btn_Confirm:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
        --  self.Btn_Confirm:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
        --  self.Btn_Confirm:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
         end)
         
    end
end



return WBP_GuideTextBox_C
