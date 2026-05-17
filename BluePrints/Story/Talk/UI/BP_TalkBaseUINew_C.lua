require "UnLua"
require "DataMgr"
---@class BP_TalkBaseUINew_C:BP_UIState_C
local BP_TalkBaseUINew_C = Class("BluePrints.UI.BP_UIState_C")

local NotHidePicTags = {
    [require"BluePrints.UI.UI_PC.Impression.ImpressionConst".ImpressionItemHideUITag] = 1,
    Review = 1,
    Wiki = 1,
}

BP_TalkBaseUINew_C._components = {
    "BluePrints.Story.Talk.UI.TalkBaseUI_MobileKeyComponent"
}

local BP_UIState_C = require "BluePrints.UI.BP_UIState_C"
local TalkUtils = require "BluePrints.Story.Talk.View.TalkUtils"
local WikiController = require "BluePrints.UI.WBP.Wiki.WikiController"

function BP_TalkBaseUINew_C:Initialize(Initializer)
    BP_UIState_C.Initialize(self, Initializer)
end

function BP_TalkBaseUINew_C:Construct()
    BP_TalkBaseUINew_C.Super.Construct(self)
    ---@type number
    self.UIDeactiveTimer = 0
    ---@type boolean
    self.bUIActive = false
    ---@type FVector2D 
    self.CachedMouseLocation2D = nil
    ---@type number
    self.LongPressTimer = 0
    ---@type BP_EMGameInstance_C
    local GameInstance = GWorld.GameInstance
    ---@type BP_TalkContext_C
    self.TalkContext = GameInstance:GetTalkContext()

    self.bStoryInputModeEnabled = false
    self.bInMobile = self.TalkContext.bInMobile
    self.DisableKeyTags = {}
    self.bPlayKeyEnabled = true
    if self.bInMobile then
        self:InitMobileButtons()
    end

    self.GameInputModeTag = "Talk"
end

function BP_TalkBaseUINew_C:Destruct()
    self:SetStoryInputModeEnabled(false)
    if self.bInMobile then
        self:UnInitMobileButtons()
    end
    if IsValid(self.ImgItemUI) then
        self.ImgItemUI:Close()
    end
    if IsValid(self.ImgRecallUI) then
        self.ImgRecallUI:Close()
    end
    BP_TalkBaseUINew_C.Super.Destruct(self)
end

function BP_TalkBaseUINew_C:SetUpTalkTask(TalkTask)
    self.TalkTask = TalkTask
end

function BP_TalkBaseUINew_C:SetStoryInputModeEnabled(bIsEnable)
    if (self.bStoryInputModeEnabled ~= bIsEnable) then
        self.bStoryInputModeEnabled = bIsEnable
        DebugPrint("BP_TalkBaseUINew_C:SetStoryInputModeEnabled", bIsEnable)

        local Subsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
        if not Subsystem then
            return
        end
        if (bIsEnable) then
            local Params = FGameInputModeParams()
            Params.WidgetToFocus = self
            Params.MouseLockMode = EMouseLockMode.LockOnCapture
            Params.bHideCursorDuringCapture = false
            Params.bShowMouseCursor = true
            Subsystem:EnableInputMode(self.GameInputModeTag, EGameInputMode.GameAndUI, Params)
            UIManager(self):SetUIInputEnable(false, self.GameInputModeTag)
        else
            Subsystem:DisableInputMode(self.GameInputModeTag)
            UIManager(self):SetUIInputEnable(true, self.GameInputModeTag)
        end
    end
end

---@param TalkTask TalkTaskBase_C
---@param TaskData TalkTaskDataBase_C
---@param OnPreEnterTalkTaskFinished TalkDelegate_C
function BP_TalkBaseUINew_C:PreEnterTalkTask(TalkTask, TaskData, OnPreEnterTalkTaskFinished)
    local TalkDelegateManager = TaskData.TalkContext.TalkDelegateManager
    self.DialoguePanelClicked_Delegate = TalkDelegateManager:CreateDelegate(TalkTask)
    self.WholeDialogueTypingFinished_Delegate = TalkDelegateManager:CreateDelegate(TalkTask)
    self.OptionItemClicked_Delegate = TalkDelegateManager:CreateDelegate(TalkTask)
    self.AutoPlayChanged_Delegate = TalkDelegateManager:CreateDelegate(TalkTask)
    self.SkipButtonClicked_Delegate = TalkDelegateManager:CreateDelegate(TalkTask)
    self.StopStoryline_Delegate = TalkDelegateManager:CreateDelegate(TalkTask)
    if OnPreEnterTalkTaskFinished then
        OnPreEnterTalkTaskFinished:Fire()
    end
end

---@param TalkTask TalkTaskBase_C
---@param TaskData TalkTaskDataBase_C
---@param OnPostEnterTalkTaskFinished TalkDelegate_C
function BP_TalkBaseUINew_C:PostEnterTalkTask(TalkTask, TaskData, OnPostEnterTalkTaskFinished)
    if OnPostEnterTalkTaskFinished then
        OnPostEnterTalkTaskFinished:Fire()
    end
end

---@param TalkTask TalkTaskBase_C
---@param TaskData TalkTaskDataBase_C
---@param OnPreExitTalkTaskFinished TalkDelegate_C
function BP_TalkBaseUINew_C:PreExitTalkTask(TalkTask, TalkData, OnPreExitTalkTaskFinished)
    self:ForceHideDialoguePic()

    if OnPreExitTalkTaskFinished then
        OnPreExitTalkTaskFinished:Fire()
    end
end

---@param TalkTask TalkTaskBase_C
---@param TaskData TalkTaskDataBase_C
---@param OnPostExitTalkTaskFinished TalkDelegate_C
function BP_TalkBaseUINew_C:PostExitTalkTask(TalkTask, TalkData, OnPostExitTalkTaskFinished)
    if OnPostExitTalkTaskFinished then
        OnPostExitTalkTaskFinished:Fire()
    end
end

function BP_TalkBaseUINew_C:RemoveInputMethodChangedListen()
    if (IsValid(self) and IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice) 
    end
end

function BP_TalkBaseUINew_C:Tick(MyGeometry, InDeltaTime)
    if self.LongPressTimer then
        self.LongPressTimer = self.LongPressTimer + InDeltaTime
    else
        self.LongPressTimer = 0
    end
    self:UpdateUIActiveness(InDeltaTime)
end

---@param InDeltaTime number
function BP_TalkBaseUINew_C:UpdateUIActiveness(InDeltaTime)
    if(not self.EnableDeactiveUI) then
        return
    end
    if self.CachedMouseLocation2D then
        local CurrentMouseLocation2D = UWidgetLayoutLibrary.GetMousePositionOnViewport(self)
        if (not UKismetMathLibrary.EqualEqual_Vector2DVector2D(self.CachedMouseLocation2D, CurrentMouseLocation2D)) then
            self.UIDeactiveTimer = 0
            if (self.bUIActive == false) then
                self:OnPlayerActiveUI()
            end
            self.bUIActive = true
        else
            self.UIDeactiveTimer = self.UIDeactiveTimer + InDeltaTime
            if (self.UIDeactiveTimer > Const.TalkUIDeactiveTimeThreshold and self.bUIActive == true) then
                self:OnPlayerDeactiveUI()
                self.bUIActive = false
            end
        end
        self.CachedMouseLocation2D = CurrentMouseLocation2D
    else
        self.CachedMouseLocation2D = UWidgetLayoutLibrary.GetMousePositionOnViewport(self)
        if(self.DefaultDeactiveUI) then
            self:OnPlayerDeactiveUI()
            self.bUIActive = false
        end
    end

    if self.bInMobile then
        local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
        PlayerController.bShowMouseCursor = false
    end
end

function BP_TalkBaseUINew_C:ActiveUI()
    --DebugPrint("ActiveUI")
    self.UIDeactiveTimer = 0
    if (self.bUIActive == false) then
        self:OnPlayerActiveUI()
        self.bUIActive = true
    end
end

function BP_TalkBaseUINew_C:OnTalkClickPressed()
    self.LongPressTimer = 0
end

function BP_TalkBaseUINew_C:OnTalkClickReleased()
    DebugPrint("OnTalkClickReleased", self.LongPressTimer)
    if self.LongPressTimer and self.LongPressTimer < Const.ShortPressThreshold then
        self.LongPressTimer = nil
        if self.WBP_Story_PlayKey_P then
            self.WBP_Story_PlayKey_P:OnConfirmKeyReleased()
        end
		self.DialoguePanelClicked_Delegate:Fire()
    end
end

function BP_TalkBaseUINew_C:SkipDialogueTyping()
    local TypingFinished = false
    if self:HasWholeDialogueTypingFinished() then
        self:SkipNextPageTimer()
        TypingFinished = true
    elseif not self:HasPageTypingFinished() then
        self:ToPageEnd()
    else
        self:NextPage()
    end
    return TypingFinished
end

function BP_TalkBaseUINew_C:SwitchEnableSkipButton(bEnable)
    self:ShowSkipButton(bEnable)
    self:SwitchBindSkip(bEnable, self, self.OnSkipButtonClicked)
end

function BP_TalkBaseUINew_C:SwitchEnableConfirmButton(bEnable)
    self:ShowConfirmButton(bEnable)
end

function BP_TalkBaseUINew_C:SwitchEnableAutoPlayButton(bEnable)
    self:ShowAutoPlayButton(bEnable)
    self:SwitchBindAutoPlay(bEnable, self, self.OnAutoPlayButtonClicked)
end

function BP_TalkBaseUINew_C:SwitchEnableReviewButton(bEnable)
    self:ShowReviewButton(bEnable)
    self:SwitchBindReview(bEnable, self, self.OnReviewButtonClicked)
end

function BP_TalkBaseUINew_C:SwitchEnableWikiButton(bEnable)
    self:ShowWikiButton(bEnable)
    self:SwitchBindWiki(bEnable, self, self.OnWikiButtonClicked)
end


function BP_TalkBaseUINew_C:ShowSkipButton(bShow)
    if self.bInMobile then
        if (IsValid(self.Story_PlayBtn)) then
            self.Story_PlayBtn:ShowSkipButton(bShow)
        end
    else
        self.WBP_Story_PlayKey_P:ShowSkipButton(bShow)
    end
end

function BP_TalkBaseUINew_C:ShowConfirmButton(bShow)
    if self.bInMobile then
        return
    end
    self.WBP_Story_PlayKey_P:ShowConfirmButton(bShow)
end

function BP_TalkBaseUINew_C:ShowAutoPlayButton(bShow)
    if self.bInMobile then
        if (IsValid(self.Story_PlayBtn)) then
            self.Story_PlayBtn:ShowAutoPlayButton(bShow)
        end
    else
        self.WBP_Story_PlayKey_P:ShowAutoPlayButton(bShow)
    end
end

function BP_TalkBaseUINew_C:ShowReviewButton(bShow)
    if self.bInMobile then
        if (IsValid(self.Story_PlayBtn)) then
            self.Story_PlayBtn:ShowReviewButton(bShow)
        end
    else
        self.WBP_Story_PlayKey_P:ShowReviewButton(bShow)
    end
end

function BP_TalkBaseUINew_C:ShowWikiButton(bShow)
    if self.bInMobile then
        if (IsValid(self.Story_PlayBtn)) then
            if bShow then
                self.Story_PlayBtn:ShowEncyclopedia()
            else
                self.Story_PlayBtn:HideEncyclopedia()
            end
        end
    else
        if bShow then
            self.WBP_Story_PlayKey_P:ShowEncyclopedia()
        else
            self.WBP_Story_PlayKey_P:HideEncyclopedia()
        end
    end
end

function BP_TalkBaseUINew_C:SwitchBindSkip(bBind, Obj, Func)
    DebugPrint("BP_TalkBaseUINew_C:SwitchBindSkip", bBind, Obj, Func)
    if self.bInMobile then
        if (IsValid(self.Story_PlayBtn)) then
            self.Story_PlayBtn:SwitchBindMobileSkip(bBind, Obj, Func)
        end
    else
        self.WBP_Story_PlayKey_P:SwitchBindSkip(bBind, Obj, Func)
        self:StopListeningForInputAction("TalkSkip", EInputEvent.IE_Pressed)
        self:StopListeningForInputAction("TalkSkip", EInputEvent.IE_Released)
        if (bBind) then
            self:ListenForInputAction("TalkSkip", EInputEvent.IE_Pressed, false, {self.WBP_Story_PlayKey_P, self.WBP_Story_PlayKey_P.OnSkipKeyPressed})
            self:ListenForInputAction("TalkSkip", EInputEvent.IE_Released, false, {self.WBP_Story_PlayKey_P, self.WBP_Story_PlayKey_P.OnSkipKeyReleased})
            self:ListenForInputAction("TalkSkip", EInputEvent.IE_Pressed, false, {self, self.ActiveUI})
            self:ListenForInputAction("TalkSkip", EInputEvent.IE_Released, false, {self, self.ActiveUI})
        end
    end
end

function BP_TalkBaseUINew_C:SwitchBindAutoPlay(bBind, Obj, Func)
    DebugPrint("BP_TalkBaseUINew_C:SwitchBindAutoPlay", bBind, Obj, Func)
    if self.bInMobile then
        if (IsValid(self.Story_PlayBtn)) then
            self.Story_PlayBtn:SwitchBindMobileAutoPlay(bBind, Obj, Func)
        end
    else
        self.WBP_Story_PlayKey_P:SwitchBindAutoPlay(bBind, Obj, Func)
        self:StopListeningForInputAction("TalkAutoPlay", EInputEvent.IE_Pressed)
        self:StopListeningForInputAction("TalkAutoPlay", EInputEvent.IE_Released)
        if (bBind) then
            self:ListenForInputAction("TalkAutoPlay", EInputEvent.IE_Pressed, false,{self.WBP_Story_PlayKey_P, self.WBP_Story_PlayKey_P.OnAutoKeyPressed})
            self:ListenForInputAction("TalkAutoPlay", EInputEvent.IE_Released, false,{self.WBP_Story_PlayKey_P, self.WBP_Story_PlayKey_P.OnAutoKeyReleased})
            self:ListenForInputAction("TalkAutoPlay", EInputEvent.IE_Pressed, false, {self, self.ActiveUI})
            self:ListenForInputAction("TalkAutoPlay", EInputEvent.IE_Released, false, {self, self.ActiveUI})
        end
    end
end

function BP_TalkBaseUINew_C:SwitchBindReview(bBind, Obj, Func)
    DebugPrint("BP_TalkBaseUINew_C:SwitchBindReview", bBind, Obj, Func)
    if self.bInMobile then
        if (IsValid(self.Story_PlayBtn)) then
            self.Story_PlayBtn:SwitchBindMobileReview(bBind, Obj, Func)
        end
    else
        self.WBP_Story_PlayKey_P:SwitchBindReview(bBind, Obj, Func)
        self:StopListeningForInputAction("TalkReview", EInputEvent.IE_Pressed)
        self:StopListeningForInputAction("TalkReview", EInputEvent.IE_Released)
        if (bBind) then
            self:ListenForInputAction("TalkReview", EInputEvent.IE_Pressed, false,{self.WBP_Story_PlayKey_P, self.WBP_Story_PlayKey_P.OnReviewKeyPressed})
            self:ListenForInputAction("TalkReview", EInputEvent.IE_Released, false,{self.WBP_Story_PlayKey_P, self.WBP_Story_PlayKey_P.OnReviewKeyReleased})
            self:ListenForInputAction("TalkReview", EInputEvent.IE_Pressed, false, {self, self.ActiveUI})
            self:ListenForInputAction("TalkReview", EInputEvent.IE_Released, false, {self, self.ActiveUI})
        end
    end
end

function BP_TalkBaseUINew_C:SwitchBindWiki(bBind, Obj, Func)
    DebugPrint("BP_TalkBaseUINew_C:SwitchBindWiki", bBind, Obj, Func)
    if self.bInMobile then
        if (IsValid(self.Story_PlayBtn)) then
            self.Story_PlayBtn:SwitchBindMobileWiki(bBind, Obj, Func)
        end
    else
        self.WBP_Story_PlayKey_P:SwitchBindWiki(bBind, Obj, Func)
        self:StopListeningForInputAction("TalkWiki", EInputEvent.IE_Pressed)
        self:StopListeningForInputAction("TalkWiki", EInputEvent.IE_Released)
        if (bBind) then
            self:ListenForInputAction("TalkWiki", EInputEvent.IE_Pressed, false,{self.WBP_Story_PlayKey_P, self.WBP_Story_PlayKey_P.OnWikiKeyPressed})
            self:ListenForInputAction("TalkWiki", EInputEvent.IE_Released, false,{self.WBP_Story_PlayKey_P, self.WBP_Story_PlayKey_P.OnWikiKeyReleased})
            self:ListenForInputAction("TalkWiki", EInputEvent.IE_Pressed, false, {self, self.ActiveUI})
            self:ListenForInputAction("TalkWiki", EInputEvent.IE_Released, false, {self, self.ActiveUI})
        end
    end
end

function BP_TalkBaseUINew_C:OnSkipButtonClicked()
    self:SwitchEnableSkipButton(false)
    self.SkipButtonClicked_Delegate:Fire()
end

function BP_TalkBaseUINew_C:OnAutoPlayButtonClicked()
    if self.bInMobile then
        self:ChangeAutoPlay()
        self:ChangeAutoPlayUI()
        if self:IsAutoPlay() then
            self:TryPlayNextPage()
        else
            self:RemoveTimer("NextPage")
        end
        self.AutoPlayChanged_Delegate:Fire(self.bAutoPlay)
    else
        self:SwitchAutoPlay()
        if self:IsAutoPlay() then
            self:TryPlayNextPage()
        else
            self:RemoveTimer("NextPage")
        end
        self.AutoPlayChanged_Delegate:Fire()
    end
end

function BP_TalkBaseUINew_C:OnReviewButtonClicked()
    --self:SwitchEnableReviewButton(false)
    local ReviewPage = UIManager(self):GetUIObj("StoryReviewMain")
    if not ReviewPage then
        ReviewPage = UIManager(self):LoadUINew("StoryReviewMain", function()
            self:Show("Review")
            self:OnPauseResumed()
        end)
    end
    if ReviewPage then 
        self:Hide("Review")
        self:OnPaused() 
    end
end

function BP_TalkBaseUINew_C:OnWikiButtonClicked()
    --self:SwitchEnableReviewButton(false)
    local Ret = WikiController:OpenDialogueWiki(self.WikiEntryIds, nil, function()
        self:Show("Wiki")
        self:OnPauseResumed()
    end)
    if Ret then 
        self:Hide("Wiki")
        self:OnPaused() 
    end
end

function BP_TalkBaseUINew_C:PlayWikiRemindAnim()
    if self.WBP_Story_PlayKey_P then
        self.WBP_Story_PlayKey_P:PlayAnimation(self.WBP_Story_PlayKey_P.Reminder)
    end
    if self.Button_Encyclopedia then
        self.Button_Encyclopedia:PlayAnimation(self.Button_Encyclopedia.Reminder)
    end
end

function BP_TalkBaseUINew_C:TryShowWikiButton(TalkTask)
    if self.HasShowWikiButton then
        return
    end
    if WikiController:CheckEntriesUnlocked(self.WikiEntryIds) then
        self:SwitchEnableWikiButton(TalkTask.TalkTaskData.bShowWikiButton)
        self.HasShowWikiButton=true
        -- self:PlayWikiRemindAnim()
    else
        DebugPrint("@ljh,Need show Wiki but locked")
    end
end

function BP_TalkBaseUINew_C:SetUIHidden(bHidden)
    if (bHidden) then
        self:SetVisibility(UE.ESlateVisibility.Collapsed)
    else
        self:SetVisibility(UE.ESlateVisibility.Visible)
    end
end

function BP_TalkBaseUINew_C:TryShowDialoguePic(DialogueData)
    if (not DialogueData) or (not DialogueData.DialoguePanelType) then
        return 
    end
    local DialoguePanelType = string.lower(DialogueData.DialoguePanelType or '')
    local type = TalkUtils:FindTargetString(DialoguePanelType, 'type')
    if not type then
        return 
    end
    if string.lower(type) == 'showpic' then
        local dir = TalkUtils:FindTargetString(DialoguePanelType, 'dir')
        DebugPrint("WBP_Simple_Common:ShowDialoguePic",type,dir)
        self:ShowPicture(dir)
    end
end

function BP_TalkBaseUINew_C:ShowPicture(dir, fadeInTime, fadeOutTime, duration)
    if fadeInTime and fadeOutTime and duration then
        if fadeInTime + fadeOutTime + duration <= 0 then
            return
        end
    end
    local Picture = UStoryFunctionLibrary.LoadResourceWithGender(self, dir, self)
    DebugPrint("BP_TalkBaseUINew_C:@ShowPicture",dir,Picture,fadeInTime,fadeOutTime,duration)
    if Picture then
        if not IsValid(self.ImgItemUI) then
            self.ImgItemUI = UIManager(self):_CreateWidgetNew("StoryImgItem")
            if not self.ImgItemUI then
                DebugPrint("Error: 播放图片时控件无效,请检查WBP_Story_ImgItem蓝图")  
                return
            end
            local ZOrder = self:GetZOrder()
            self.ImgItemUI:AddToViewport(ZOrder>0 and ZOrder-1 or 0)
        end
        self.ImgItemUI:PlayFadeAnim(true, Picture, fadeInTime, fadeOutTime, duration)
    else
        DebugPrint("Error: 无法找到图片路径:",dir,",请检查Dialogue配置")  
    end
end

function BP_TalkBaseUINew_C:TryHideLastDialoguePic()
    DebugPrint("BP_TalkBaseUINew_C:TryHideLastDialoguePic")
    if IsValid(self.ImgItemUI) then
        self.ImgItemUI:PlayFadeAnim(false)
    end
end

function BP_TalkBaseUINew_C:ForceHideDialoguePic()
    if IsValid(self.ImgItemUI) then
        self.ImgItemUI:Close()
    end
end

function BP_TalkBaseUINew_C:SetUISkippable(bSkippable)
    self.bUISkippable = bSkippable
end

---@param bHidden boolean
function BP_TalkBaseUINew_C:SetAutoPlayButtonHidden(bHidden)
end

---@param bHidden boolean
function BP_TalkBaseUINew_C:SetSkipButtonHidden(bHidden)
end

function BP_TalkBaseUINew_C:SetTextBorderHidden(bHidden)
end

function BP_TalkBaseUINew_C:SetTipImageHidden(bHidden)
end

function BP_TalkBaseUINew_C:SetAutoPlayChecked(bChecked)
end

function BP_TalkBaseUINew_C:SetBlackborderHidden(bHidden)
end

--- @param TalkTask TalkTaskBase_C
--- @param DialogueId number
--- @param Player BP_PlayerCharacter_C
function BP_TalkBaseUINew_C:PlayDialogue(TalkTask,DialogueData, TaskData)
end

---@param OptionTexts table<number,string>
function BP_TalkBaseUINew_C:ShowOptions(TalkTask, OptionTexts, OptionData, OnOptionItemClicked)
    OnOptionItemClicked(1)
end

function BP_TalkBaseUINew_C:ClearOptions()
end

---@param FadeTime number
---@param Callback table
function BP_TalkBaseUINew_C:FadeIn(FadeTime, Callback)
    if (Callback) then
        Callback.Func(Callback.Obj, table.unpack(Callback.Params or {}))
    end
end

---@param FadeTime number
---@param Callback table
function BP_TalkBaseUINew_C:FadeOut(FadeTime, Callback)
    if (Callback) then
        Callback.Func(Callback.Obj, table.unpack(Callback.Params or {}))
    end
end

function BP_TalkBaseUINew_C:ToPageEnd()
end

function BP_TalkBaseUINew_C:NextPage()
    self:RemoveTimer("NextPage")
    self.TypingText:NextPage()
    -- self:SetTipImageHidden(true)
end

function BP_TalkBaseUINew_C:InitDialogueData(DialogueData)
    self.DialogueData = DialogueData
end

function BP_TalkBaseUINew_C:TryPlayNextPage()
    if self:HasPageTypingFinished() and not self:HasWholeDialogueTypingFinished() then
        self:NextPage()
    end
end

function BP_TalkBaseUINew_C:OnWholeDialogueTypingFinished(FinishOrPageEnd)
    DebugPrint("BP_TalkBaseUINew_C:OnWholeDialogueTypingFinished", FinishOrPageEnd, self:IsAutoPlay())
    if FinishOrPageEnd then
        if self:IsRealAutoPlay() then
            self:AddNextPageTimer()
        else
            self.WholeDialogueTypingFinished_Delegate:Fire(true)
        end
    else
        self:SetTipImageHidden(false)
        if self:IsAutoPlay() then
            self:AddTimer(DataMgr.GlobalConstant.TalkWaitForNewPage.ConstantValue, self.NextPage, false, 0, "NextPage", true)
            --Todo RemoveTimer
        end
    end
end

function BP_TalkBaseUINew_C:AddNextPageTimer()
    self:AddTimer(DataMgr.GlobalConstant.TalkWaitForNewPage.ConstantValue, function()
        self.WholeDialogueTypingFinished_Delegate:Fire(true)
    end, false, 0, "TypeFinish", true)
end

function BP_TalkBaseUINew_C:SkipNextPageTimer()
    if self:IsExistTimer("TypeFinish") then
        self:RemoveTimer("TypeFinish")
        self.WholeDialogueTypingFinished_Delegate:Fire(true)
    end
end

function BP_TalkBaseUINew_C:HasPageTypingFinished()
end

function BP_TalkBaseUINew_C:HasWholeDialogueTypingFinished()
end

-- 玩家输入激活UI
function BP_TalkBaseUINew_C:OnPlayerActiveUI()
end

-- 玩家停止输入一段时间吊销UI
function BP_TalkBaseUINew_C:OnPlayerDeactiveUI()
end

function BP_TalkBaseUINew_C:OnNotPlayRecallGraph()
    self.LastRecallGraph = nil
    if IsValid(self.ImgRecallUI) then
        self.ImgRecallUI:OnCollapsingGraph()
    end
end

function BP_TalkBaseUINew_C:OnPlayRecallGraph(DialogueData, bSkip)
    local GraphPath, bNotRecall = DialogueData.DialogueGraphPath, DialogueData.bNotRecall
    DebugPrint("OnPlayRecallGraph",GraphPath, self.LastRecallGraph, bNotRecall, self.LastNotRecall)
    if GraphPath == self.LastRecallGraph then
        -- 图片路径和是否是回忆都不变时，无需处理
        if bNotRecall == nil or bNotRecall == self.LastNotRecall then
            return
        end
    else
        self.LastNotRecall = false
    end
    self.LastRecallGraph = GraphPath
    if bNotRecall ~= nil then
        self.LastNotRecall = bNotRecall
    end
    self.bShowingRecall = true
    if not self.ImgRecallUI then
        self.ImgRecallUI = UIManager(self):_CreateWidgetNew("StoryImgRecall")
        if not self.ImgRecallUI then
            DebugPrint("Error: 播放回忆图片时控件无效,请检查WBP_Story_ImgRecall蓝图")  
            return
        end
        local ZOrder = self:GetZOrder()
        self.ImgRecallUI:AddToViewport(ZOrder>0 and ZOrder-1 or 0)
    end
    self.ImgRecallUI:InitGraph(GraphPath, bNotRecall, bSkip)
    self:DelayPlayRecallAnim(true)
end

function BP_TalkBaseUINew_C:DelayPlayRecallAnim(bInAnim)
    DebugPrint("BP_TalkBaseUINew_C@DelayPlayRecallAnim", bInAnim)
    if IsValid(self.ImgRecallUI) then
        self.ImgRecallUI:PlayRecallAnim(bInAnim)
    end
end

function BP_TalkBaseUINew_C:SetRecallGraphHidden()
    if IsValid(self.ImgRecallUI) then
        self.ImgRecallUI:Close()
    end
end

---@param Obj table
---@param Func function
function BP_TalkBaseUINew_C:AddDelegate_DialoguePanelClicked(Obj, Func, ...)
    self.DialoguePanelClicked_Delegate:Add(Obj, Func, ...)
end

---@param Obj table
function BP_TalkBaseUINew_C:RemoveDelegate_DialoguePanelClicked(Obj, Func)
    if(self.DialoguePanelClicked_Delegate == nil) then
        return
    end
    self.DialoguePanelClicked_Delegate:Remove(Obj, Func)
end

---@param Obj table
---@param Func function
function BP_TalkBaseUINew_C:AddDelegate_AutoPlayChanged(Obj, Func, ...)
    self.AutoPlayChanged_Delegate:Add(Obj, Func, ...)
end

---@param Obj table
---@param Func function
function BP_TalkBaseUINew_C:RemoveDelegate_AutoPlayChanged(Obj, Func)
    if(self.AutoPlayChanged_Delegate == nil) then
        return
    end
    self.AutoPlayChanged_Delegate:Remove(Obj, Func)
end

---@param Obj table
---@param Func function
function BP_TalkBaseUINew_C:AddDelegate_SkipButtonClicked(Obj, Func, ...)
    self.SkipButtonClicked_Delegate:Add(Obj, Func, ...)
end

---@param Obj table
---@param Func function
function BP_TalkBaseUINew_C:RemoveDelegate_SkipButtonClicked(Obj, Func)
    if(self.SkipButtonClicked_Delegate == nil) then
        return
    end
    self.SkipButtonClicked_Delegate:Remove(Obj, Func)
end

---@param Obj table
---@param Func function
function BP_TalkBaseUINew_C:AddDelegate_WholeDialogueTypingFinished(Obj, Func, ...)
    self.WholeDialogueTypingFinished_Delegate:Add(Obj, Func, ...)
end

---@param Obj table
---@param Func function
function BP_TalkBaseUINew_C:RemoveDelegate_WholeDialogueTypingFinished(Obj, Func)
    if(self.WholeDialogueTypingFinished_Delegate == nil) then
        return
    end
    self.WholeDialogueTypingFinished_Delegate:Remove(Obj, Func)
end

---@param Obj table
---@param Func function
function BP_TalkBaseUINew_C:AddDelegate_StopStoryline(Obj, Func, ...)
    self.StopStoryline_Delegate:Add(Obj, Func, ...)
end

---@param Obj table
---@param Func function
function BP_TalkBaseUINew_C:RemoveDelegate_StopStoryline(Obj, Func)
    if self.StopStoryline_Delegate then
        self.StopStoryline_Delegate:Remove(Obj, Func)
    end
end

function BP_TalkBaseUINew_C:IsAutoPlay()
    if (self.DialogueData and (self.DialogueData.DialoguePanelType == "None" or self.DialogueData.DialoguePanelType == "AllHide")) then
        return true
    else
        return self:IsRealAutoPlay()
    end
end

function BP_TalkBaseUINew_C:IsRealAutoPlay()
    if not self.bDefaultShowAutoPlayButton then
        return false
    else
        return GWorld.GameInstance.bGlobalAutoPlay
    end
end

function BP_TalkBaseUINew_C:SwitchAutoPlay()
    GWorld.GameInstance.bGlobalAutoPlay = not GWorld.GameInstance.bGlobalAutoPlay
end

function BP_TalkBaseUINew_C:GetOverridenAutoPlayDurationTimer()
    return nil
end

function BP_TalkBaseUINew_C:Clear()
    DebugPrint("BP_TalkBaseUINew_C:Clear")
end

function BP_TalkBaseUINew_C:OnPaused()
    DebugPrint("BP_TalkBaseUINew_C:OnPaused")
    self:SetPlayKeyEnabled(false, "Pause")
    if self.TypingText then
        self.TypingText:Pause(true)
    end
    if self.TalkTask then
        self.TalkTask:PauseTaskExternal(true, self)
    end
    if self:IsAutoPlay() then
        self.WasAutoPlay = true
        self:RemoveTimer("NextPage")
    end

    self:SetIsEnabled(false)
end

function BP_TalkBaseUINew_C:OnPauseResumed()
    DebugPrint("BP_TalkBaseUINew_C:OnPauseResumed")
    self:SetPlayKeyEnabled(true, "Pause")
    if self.TypingText then
        self.TypingText:Pause(false)
    end
    if self.TalkTask then
        self.TalkTask:PauseTaskExternal(false, self)
    end
    if self.WasAutoPlay then
        self.WasAutoPlay = nil
        self:TryPlayNextPage()
    end

    self:SetIsEnabled(true)
end

function BP_TalkBaseUINew_C:RefreshBaseInfo()
    -- 刷新一些基础信息
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

-- function BP_TalkBaseUINew_C:IsFocused()
--     return self:HasFocusedDescendants() or self:HasAnyUserFocus()
-- end

-- function BP_TalkBaseUINew_C:OnFocusReceived(MyGeometry, InFocusEvent)
--     self:RefreshBaseInfo()
--     return BP_TalkBaseUINew_C.Super.OnFocusReceived(self, MyGeometry, InFocusEvent)
-- end

function BP_TalkBaseUINew_C:OnInterrupted()
    DebugPrint("BP_TalkBaseUINew_C:OnInterrupted")
    self:Clear()
end

function BP_TalkBaseUINew_C:Hide(HideTag)
    BP_TalkBaseUINew_C.Super.Hide(self, HideTag)
    if not HideTag or not NotHidePicTags[HideTag] then
        if IsValid(self.ImgItemUI) then
            self.ImgItemUI:SetVisibility(ESlateVisibility.Collapsed)
        end
        if IsValid(self.ImgRecallUI) then
            self.ImgRecallUI:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
    self:SetPlayKeyEnabled(false, "Visibility")
end

function BP_TalkBaseUINew_C:Show(ShowTag)
    BP_TalkBaseUINew_C.Super.Show(self, ShowTag)
    if IsValid(self.ImgItemUI) then
        self.ImgItemUI:SetVisibility(ESlateVisibility.HitTestInvisible)
    end
    if IsValid(self.ImgRecallUI) then
        self.ImgRecallUI:SetVisibility(ESlateVisibility.HitTestInvisible)
    end
    if IsEmptyTable(self.HideTags) then
        self:SetPlayKeyEnabled(true, "Visibility")
    end
end

function BP_TalkBaseUINew_C:SetPlayKeyEnabled(bEnable, DisableTag)
    if not (IsValid(self.WBP_Story_PlayKey_P)) then
        return
    end
    if bEnable then
        if DisableTag then
            self.DisableKeyTags[DisableTag] = nil
        end
    else
        self.DisableKeyTags[DisableTag] = 1
    end

    local bPlayKeyEnabled = IsEmptyTable(self.DisableKeyTags)
    if (self.bPlayKeyEnabled == bPlayKeyEnabled) then
        return
    end
    self.bPlayKeyEnabled = bPlayKeyEnabled
    if bPlayKeyEnabled then
        self.WBP_Story_PlayKey_P:Enable()
    else
        self.WBP_Story_PlayKey_P:Disable()
    end
end

function BP_TalkBaseUINew_C:SwitchWaitState(bEnableClick)
    DebugPrint("BP_TalkBaseUINew_C:SwitchWaitState", bEnableClick)
    if bEnableClick == nil or self.WS_Type == nil then
        return
    end
    if self.UIWaitState and bEnableClick == self.UIWaitState then
        return
    end
    if bEnableClick then
        self.WS_Type:SetActiveWidgetIndex(0)
        if self.State_Wait then
            self.State_Wait:UnbindAllFromAnimationFinished(self.State_Wait.Loop)
            self.State_Wait:StopAnimation(self.State_Wait.Loop)
        end
    else
        self.WS_Type:SetActiveWidgetIndex(1)
        if self.State_Wait then
            self.State_Wait:PlayAnimation(self.State_Wait.Loop)
            self.State_Wait:BindToAnimationFinished(self.State_Wait.Loop, {self, function() self.State_Wait:PlayAnimation(self.State_Wait.Loop) end})
        end
    end
    self.UIWaitState = bEnableClick
end

function BP_TalkBaseUINew_C:ResetNormalButton()
end

AssembleComponents(BP_TalkBaseUINew_C)

return BP_TalkBaseUINew_C
