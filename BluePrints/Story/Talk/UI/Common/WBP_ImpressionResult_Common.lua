local WBP_ImpressionResult_Common = Class({
    "BluePrints.Common.TimerMgr",
    "BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.Common.DelayFrameComponent",
})

local ECheckMode = {
    Normal = 'Normal',
    ImpressionShop = 'ImpressionShop',
}

-- CheckParams类型为table，具体所含元素见ImpressionMgr中ImpressionCheckByEnumId函数中的的Param变量
function WBP_ImpressionResult_Common:Init(ImpressionUI, PlayerValue, CheckType, CheckValue, CheckParams)
    DebugPrint("WBP_ImpressionResult_C Init", PlayerValue, CheckType, CheckValue, CheckParams)
    self.ImpressionUI = ImpressionUI
    self.PlayerValue = PlayerValue
    self.CheckType = CheckType
    self.CheckValue = CheckValue
    self.CheckParams = CheckParams
    self.OnCloseDelegate = nil
    self.bCanRetry = false 
    self.ResourceCount = 0
    self.bListenPressInput = true
    self.bListenReleaseInput = true
    self:CommonInit()
end

function WBP_ImpressionResult_Common:CommonInit()
    self.CheckTypeString = GText("Impression_Name_" .. self.CheckType)
    self:AdaptPlatform()
    self:InitPlayKey()
    self:SetBonusText()
    self:SetCheckTarget()
    self:SetDiceNumVisibility(UE4.ESlateVisibility.Collapsed)
    self:OverrideButtonSound()
    self:BindAnimations()
    self:SetGTexts()
    self:InitVisibility()
    self:SetOnReceiveRetryServerHandled()

    -- 初始化Retry Button和End Button信息
    self:InitButtons()
    self:SetFocus()
    self:AddInputMethodChangedListen()
end

function WBP_ImpressionResult_Common:Destruct(...)
    self:RemoveInputMethodChangedListen()
    self:SwitchBindFailButtonEvents(false)
end

function WBP_ImpressionResult_Common:InitVisibility()
    self.BackgroundBlur_364:SetVisibility(ESlateVisibility.Visible)
    self:SwitchShowSpaceShortCut(false)
end

function WBP_ImpressionResult_Common:SetGTexts()
    self.Text_Tip:SetText(GText("UI_Impression_Click"))
    self.Text_FailTips:SetText(GText("UI_Impression_Fail"))
end

function WBP_ImpressionResult_Common:RefreshCheckResult(bIsSucceed)
    DebugPrint("WBP_ImpressionResult_Common RefreshCheckResult ",bIsSucceed)
    if bIsSucceed then
        local SuccessText = GText("Impression_UI_CheckSucc")
        self.Text_Success:SetText(SuccessText)
    else
        local FailText = GText("Impression_UI_CheckFail")
        self.Text_Fail:SetText(FailText)
    end
end

function WBP_ImpressionResult_Common:SwitchShowFailButtons(bShow)
    DebugPrint("WBP_ImpressionResult_Common SwitchShowFailButtons",bShow)
    if bShow then
        self.Button_Retry:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Button_End:SetVisibility(UE4.ESlateVisibility.Visible)
    else
        self.Button_Retry:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Button_End:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function WBP_ImpressionResult_Common:SwitchBindFailButtonEvents(bBind)
    DebugPrint("WBP_ImpressionResult_Common SwitchBindFailButtonEvents",bBind)
    if bBind then
        self.Button_Retry:BindEventOnClicked(self, self.OnBtn_RetryClicked)
        self.Button_Retry:BindForbidStateExecuteEvent(self, self.OnBtn_RetryForbidClicked)
        self.Button_End:BindEventOnClicked(self, self.OnBtn_EndClicked)
    else
        self.Button_Retry:UnBindEventOnClickedByObj(self)
        self.Button_End:UnBindEventOnClickedByObj(self)
    end
end

function WBP_ImpressionResult_Common:SetBonusText()
    self.Text_AddNum:SetText('+' .. self.PlayerValue)
    self.VX_AddPoint:SetText('+' .. self.PlayerValue)
    self.Text_AddNumTitle:SetText(self.CheckTypeString)
end

function WBP_ImpressionResult_Common:SetCheckTarget()
    local GoalTitle = GText("Impression_UI_CheckTarget")
    self.Text_GoalTitle:SetText(GoalTitle)
    self.Text_DiceGoalNum:SetText(tostring(self.CheckValue))
end

function WBP_ImpressionResult_Common:SetDiceNum(a, b, c)
    a = tonumber(a)
    b = tonumber(b)
    c = tonumber(c)
    if a > 0 then
        self:SetDiceNum3D(a, b, c)
    else
        self:SetDiceNum2D(b, c)
    end

    self:SwitchHideHD(tonumber(a) == 0)
end

function WBP_ImpressionResult_Common:SetDiceNum2D(Rand1, Rand2, bChangeAlpha)
    if bChangeAlpha == nil then
        bChangeAlpha = true
    end

    local Rand1Text = tostring(Rand1)
    self.Text_DiceNum_2:SetText(Rand1Text)

    local Rand2Text = tostring(Rand2)
    self.Text_DiceNum_3:SetText(Rand2Text)
    
    if bChangeAlpha then
        if Rand1 == 0 then
            self:SetRand1TextAlpha(0.4)
        else
            self:SetRand1TextAlpha(1)
        end
    else
        self:SetRand1TextAlpha(1)
    end
end

function WBP_ImpressionResult_Common:SetDiceNum3D(a,b,c)
    self:SetDiceNum2D(b,c, false)
    self.Text_DiceNum_1:SetText(tostring(a))
end

function WBP_ImpressionResult_Common:SwitchHideHD(bHide)
    if bHide then
        self.Text_DiceNum_1:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.Text_DiceNum_1:SetVisibility(UE4.ESlateVisibility.Visible)
    end
end

function WBP_ImpressionResult_Common:SetDiceNumVisibility(Visibility)
    self.Text_DiceNum_2:SetVisibility(Visibility)
    self.Text_DiceNum_3:SetVisibility(Visibility)
end

function WBP_ImpressionResult_Common:OverrideButtonSound()
    self.Button_Retry:TryOverrideSoundFunc(self.PlayRetrySound)
    self.Button_End:TryOverrideSoundFunc(self.PlayContinueSound)
end

function WBP_ImpressionResult_Common:BindAnimations()
    DebugPrint("WBP_ImpressionResult_Common BindAnimations")
    self:BindToAnimationStarted(self.In, {self, self.OnInAnimationStarted})
    self:BindToAnimationStarted(self.Out, {self, self.OnOutAnimationStarted})
    self:BindToAnimationStarted(self.Success, {self, self.OnSuccessAnimationStarted})
    self:BindToAnimationStarted(self.Fail, {self, self.OnFailAnimationStarted})
    self:BindToAnimationStarted(self.Press, {self, self.OnPressAnimationStarted})
    self:BindToAnimationStarted(self.Click, {self, self.OnClickAnimationStarted})
    self:BindToAnimationStarted(self.Again, {self, self.OnAgainAnimationStarted})

    self:BindToAnimationFinished(self.In, {self, self.OnInAnimationFinished})
    self:BindToAnimationFinished(self.Out, {self, self.OnOutAnimationFinished})
    self:BindToAnimationFinished(self.Success, {self, self.OnSuccessAnimationFinished})
    self:BindToAnimationFinished(self.Fail, {self, self.OnFailAnimationFinished})
    self:BindToAnimationFinished(self.Press, {self, self.OnPressAnimationFinished})
    self:BindToAnimationFinished(self.Click, {self, self.OnClickAnimationFinished})
    self:BindToAnimationFinished(self.Add_Point, {self, self.OnAddPointAnimationFinished})
    self:BindToAnimationFinished(self.Again, {self, self.OnAgainAnimationFinished})
end


function WBP_ImpressionResult_Common:InitButtons()
    self.bForbidFailBtns = true
    self:SwitchShowFailButtons(false)
    self:SwitchBindFailButtonEvents(true)
    self.Button_Retry.Text_Button:SetText(GText('UI_Impression_Again'))
    self.Button_End.Text_Button:SetText(GText('UI_Impression_Continue'))
    local ImpressionResourceInfo = DataMgr.ImpressionResource[self.CheckParams.ImpressionAreaId]
    local Params = {
        ResourceId = ImpressionResourceInfo.ResourceId,
        bShowDenominator = true,
        Numerator = 0,
        Denominator = ImpressionResourceInfo.Count,
        CostText = GText("UI_Armory_Trace_Cost"),
        UIName = "ImpressionMainUI",
    }
    self.Com_Cost:InitContent(Params)
    self:RefreshResouces()
end

-- 刷新消耗品数量
function WBP_ImpressionResult_Common:RefreshResouces()
    DebugPrint("WBP_ImpressionResult_Common RefreshResouces")
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    -- UI显示
    local Ret = Avatar:CanImpressionCheck(self.CheckParams.ImpressionAreaId)
    self.bCanRetry = Ret.bCanCheck
    self.Com_Cost:SetPossess(Ret.ResourceCount)
    self.Button_Retry:ForbidBtn(not self.bCanRetry)
end

function WBP_ImpressionResult_Common:OnPressAnimationFinished()
    AudioManager(self):StopSound(self, "ImpressionResultPressing")
    AudioManager(self):PlayUISound(self, "event:/ui/common/image_choose_dice_rotate_end", "",nil)
end

function WBP_ImpressionResult_Common:OnClickAnimationFinished()
    DebugPrint("WBP_ImpressionResult_Common OnClickAnimationFinished")
    self:SwitchBindSkipInput(false)
    self:StopAllAnimations()
    self:TryPlayAddAnimation()
end

function WBP_ImpressionResult_Common:OnAddPointAnimationFinished()
    DebugPrint("WBP_ImpressionResult_Common OnAddPointAnimationFinished")
    self:StopAllAnimations()
    self:PlayResultAnimation()
end

function WBP_ImpressionResult_Common:PlayResultAnimation()
    DebugPrint("WBP_ImpressionResult_Common PlayResultAnimation")
    if self.bIsSucceed then
        self:PlayAnimation(self.Success)
    else
        self:PlayAnimation(self.Fail)
    end
end

function WBP_ImpressionResult_Common:TryPlayAddAnimation()
    DebugPrint("WBP_ImpressionResult_Common TryPlayAddAnimation")
    if self.bInSkipping then
        return
    end
    if self.PlayerValue > 0 then
        self:PlayAnimation(self.Add_Point)
    else
        self:OnAddPointAnimationFinished()
    end
end

function WBP_ImpressionResult_Common:OnFailAnimationFinished()
    DebugPrint("WBP_ImpressionResult_Common OnFailAnimationFinished")
    self.bInSkipping = false
    self.bForbidFailBtns = false
    self:RefreshResouces()
end

function WBP_ImpressionResult_Common:OnSuccessAnimationFinished()
    DebugPrint("WBP_ImpressionResult_Common OnSuccessAnimationFinished")
    self.bInSkipping = false
    self:Close()
end

function WBP_ImpressionResult_Common:OnOutAnimationFinished()
    DebugPrint("WBP_ImpressionResult_Common OnOutAnimationFinished")
    self:Close()
end

function WBP_ImpressionResult_Common:OnAgainAnimationFinished()
    DebugPrint("WBP_ImpressionResult_Common OnAgainAnimationFinished")
    self:OnAgainAnimationFinished_Platform()
    self:SwitchBindDicePressInput(true)
    self:PlayAnimation(self.Remind, 0, 0)
end

function WBP_ImpressionResult_Common:OnBtn_RetryClicked()
    DebugPrint("WBP_ImpressionResult_Common OnBtn_RetryClicked", self.bCanRetry, self.bForbidFailBtns)
    if self.bForbidFailBtns then
        return
    end
    self.bForbidFailBtns = true
    self:PlayAnimation(self.Again)
end

function WBP_ImpressionResult_Common:OnBtn_RetryForbidClicked()
    DebugPrint("WBP_ImpressionResult_Common OnBtn_RetryForbidClicked", self.bCanRetry, self.bForbidFailBtns)
    if self.bForbidFailBtns then
        return
    end
    -- 不可Retry的原因暂时只有一种：骰子不够。之后看需求将Bool->Enum
    if not self.bCanRetry then
        local TalkContext = GWorld.GameInstance:GetTalkContext()
        TalkContext:TalkShowUITip("CommonToastMain", "Impression_UI_Recheck_03")
        return
    end 
end

function WBP_ImpressionResult_Common:OnRetryCheck(Error, Ret, Rand1, Rand2, CheckParams, ...)
    DebugPrint("WBP_ImpressionResult_Common OnRetryCheck", Error, Ret, Rand1, Rand2, CheckParams)
    self:OnReceivedRetryResult(Error, Ret, Rand1, Rand2, CheckParams, ...)
end

function WBP_ImpressionResult_Common:OnReceivedRetryResult(Error, bCheckSucceed, Rand1, Rand2, CheckParams, ...)
    DebugPrint("WBP_ImpressionResult_Common OnReceivedRetryResult", Error, bCheckSucceed, Rand1, Rand2)
    if self.OnServerHandledCallback then
        self.OnServerHandledCallback(Error, bCheckSucceed, Rand1, Rand2, CheckParams)
    end
    if not ErrorCode:Check(Error) then
        local ErrorCodeMessage = "错误码不存在"
        local ErrorCodeData = DataMgr.ErrorCode[Error]
        if (ErrorCodeData) then
            ErrorCodeMessage = ErrorCodeData.ErrorCodeContent or "错误码不存在说明内容"
        end

        local DialogueChainStr = ""
        local DialogueChain = ...
        DialogueChain = DialogueChain or {}
        for i, DialogueId in ipairs(DialogueChain) do
            if i ~= 1 then
                DialogueChainStr = DialogueChainStr.." to\n"
            end
            DialogueChainStr = DialogueChainStr..tostring(DialogueId)
        end

        local Title = "印象系统错误"
        local Message = string.format("ErrorCode: %d\n%s, 对话链:\n%s", Error, ErrorCodeMessage, DialogueChainStr)
        UStoryLogUtils.PrintToFeiShu(self, UE.EStoryLogType.Impression, Title, Message)
        self:Close()
        if self.ImpressionUI then
            self.ImpressionUI:StopStoryLine()
        end
        return
    end
    self.bReceivedData = true
    self.bIsSucceed = bCheckSucceed or false
    self.Rand1 = Rand1
    self.Rand2 = Rand2
    self:RefreshResouces()
    self:RefreshCheckResult(self.bIsSucceed)
    self:SetDiceNum(0, self.Rand1, self.Rand2)

    self:TryFireEventsOnResultReceived()
end

function WBP_ImpressionResult_Common:OnImpressionTimeout(DialogueChain)
    if self.OnServerHandledCallback then
        self.OnServerHandledCallback(0, false, 0, 0, {})
    end
    local Title = "印象检定超时"
    local DialogueChainStr = ""
    local DialogueId = nil
    DialogueChain = DialogueChain or {}
    for i, dialogueId in ipairs(DialogueChain) do
        if i ~= 1 then
            DialogueChainStr = DialogueChainStr.." to\n"
        end
        DialogueId = dialogueId
        DialogueChainStr = DialogueChainStr..tostring(DialogueId)
    end
    local Message = string.format("印象检定未收到服务器回调，当前选项Id: %s，对话链:\n%s", DialogueId and tostring(DialogueId) or "无", DialogueChainStr)
    UStoryLogUtils.PrintToFeiShu(self, UE.EStoryLogType.Impression, Title, Message)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:DisconnectServer()
    end
    -- self:Close()
    -- if self.ImpressionUI then
    --     self.ImpressionUI:StopStoryLine()
    -- end
end

function WBP_ImpressionResult_Common:TryFireEventsOnResultReceived()
    DebugPrint("WBP_ImpressionResult_Common TryFireEventsOnResultReceived", self.bRefreshDiceOnResultReceived, self.bFireOnBtnDiceReleased)
    if self.bRefreshDiceOnResultReceived then
        self.bRefreshDiceOnResultReceived = false
        self:TryChangeDiceTextures(self.Rand1, self.Rand2)
    end

    if self.bFireSkipEvent then
        self.bFireSkipEvent = false
        self:OnSkipButtonClicked()
    elseif self.bFireOnBtnDiceReleased then
        self.bFireOnBtnDiceReleased = false
        self:StopAllAnimations()
        self:PlayAnimation(self.Click)
    end
end

function WBP_ImpressionResult_Common:OnBtn_EndClicked()
    DebugPrint("WBP_ImpressionResult_Common OnBtn_EndClicked", self.bForbidFailBtns)
    if self.bForbidFailBtns then
        return
    end
    self:PlayAnimation(self.Out)
end

function WBP_ImpressionResult_Common:SetOnCloseDelegate(Delegate)
    DebugPrint("WBP_ImpressionResult_Common SetOnCloseDelegate")
    if Delegate and Delegate[1] and Delegate[2] then
        self.OnCloseDelegate = Delegate
    end
end

function WBP_ImpressionResult_Common:SetOnInterruptedExitDelegate(Delegate)
    DebugPrint("WBP_ImpressionResult_Common SetOnInterruptedExitDelegate")
    if Delegate and Delegate[1] and Delegate[2] then
        self.OnInterruptedExitDelegate = Delegate
    end
end

function WBP_ImpressionResult_Common:FadeIn()
    DebugPrint("WBP_ImpressionResult_Common FadeIn")
    self:PlayAnimation(self.In)
end

function WBP_ImpressionResult_Common:OnInAnimationFinished()
    DebugPrint("WBP_ImpressionResult_Common OnInAnimationFinished")
    self:SwitchBindDicePressInput(true)
    self:PlayAnimation(self.Remind, 0, 0)
    self:SetFocus()
end

function WBP_ImpressionResult_Common:TryRequestCheck()
    DebugPrint("WBP_ImpressionResult_Common TryRequestCheck")
    if self.CheckMode == ECheckMode.ImpressionShop then
        self:TryRequestImpressionShopCheck()
        return
    end
    
    -- 准备Retry所需数据
    local bTalkOptions  = self.ImpressionUI.OptionData.bTalkOptions
    local ImpressionAreaId = self.CheckParams.ImpressionAreaId
    local TalkTriggerId = self.CheckParams.TalkTriggerId
    local CheckInfo = self.CheckParams.CheckInfo
    local OptionId = self.CheckParams.OptionId
    local UsingGM = self.CheckParams.UsingGM
    local Avatar = GWorld:GetAvatar()
    -- 发送Retry请求
    if self.CheckParams.Type == 'Check' then
        local DialogueChain = self.ImpressionUI.TalkTask.DialogueRecordComponent:GetChain()
        if Avatar then
            Avatar:ImpressionCheckByEnumId_New(DialogueChain, OptionId, TalkTriggerId, ImpressionAreaId, {self, self.OnRetryCheck, self.OnImpressionTimeout}, 
                CheckInfo, UsingGM, bTalkOptions)
        else
            self:OnRetryCheck(0, true, 9, 9, {
                CurrentDialogueId = OptionId,
                TalkTriggerId = TalkTriggerId,
                Type = 'Check',
                CheckInfo = CheckInfo,
            })
        end
    end
end

function WBP_ImpressionResult_Common:TryRequestImpressionShopCheck()
    DebugPrint("WBP_ImpressionResult_Common TryRequestImpressionShopCheck")
    self.OnCheckCallback()
end

function WBP_ImpressionResult_Common:OnReceiveImpressionShopRequestResult(Error, bIsSucceed, Rand1, Rand2)
    DebugPrint("WBP_ImpressionResult_Common OnReceiveImpressionShopRequestResult",bIsSucceed, Rand1, Rand2)
    self:OnReceivedRetryResult(Error, bIsSucceed, Rand1, Rand2)
end

function WBP_ImpressionResult_Common:OnBtn_EscPressed()
    DebugPrint("WBP_ImpressionResult_Common OnBtn_EscPressed")
    if not self.bListenPressInput then
        return
    end
    self:StopAllAnimations()
    self:SwitchBindDicePressInput(false)
    self:SwitchBindDiceReleaseInput(false)
    self:InterruptExit()
end

function WBP_ImpressionResult_Common:OnBtn_DicePressed()
    DebugPrint("WBP_ImpressionResult_Common OnBtn_DicePressed")
    if not self.bListenPressInput then
        return
    end
    self.bReceivedData = false
    self:StopAllAnimations()
    self:SwitchShowSpaceShortCut(false)
    self:SwitchBindDicePressInput(false)
    self:SwitchBindDiceReleaseInput(true)
    self:TryRequestCheck()
    self:PlayAnimation(self.Press, 0, 0)
end

function WBP_ImpressionResult_Common:OnBtn_DiceReleased()
    DebugPrint("WBP_ImpressionResult_Common OnBtn_DiceReleased")
    if not self.bListenReleaseInput then
        return
    end
    self:OnBtn_DiceReleased_Platform()
    self:SwitchShowSpaceShortCut(true)
    self:SwitchBindSkipInput(true)
    self:SwitchBindDiceReleaseInput(false)
    if not self.bReceivedData then
        self.bFireOnBtnDiceReleased = true
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
end

function WBP_ImpressionResult_Common:OnSkipButtonClicked()
    DebugPrint("WBP_ImpressionResult_Common:OnSkipButtonClicked", self.bReceivedData)
    self:SwitchBindSkipInput(false)
    if not self.bReceivedData then
        self.bFireSkipEvent = true
        return
    end

    self.bInSkipping = true
    self:PlayAnimation(self.Click)
    self:SetAnimationCurrentTime(self.Click, 2)
    self:AddDelayFrameFunc(function()
        self:StopAllAnimations()
        self:SetDiceNumVisibility(UE4.ESlateVisibility.Visible)
        self:TryChangeDiceTextures(self.Rand1, self.Rand2)
        self:ChangeDiceImage()
        self:PlayResultAnimation()
    end,2)
end


function WBP_ImpressionResult_Common:Close()
    DebugPrint("WBP_ImpressionResult_Common Close")
    AudioManager(self):StopSound(self, "ImpressionResultPressing")
    if self.OnCloseDelegate then
        self.OnCloseDelegate[2](self.OnCloseDelegate[1], self.bIsSucceed)
    end
    self:DisablePlayerInput(false)
    self:RemoveFromParent()
end

function WBP_ImpressionResult_Common:InterruptExit()
    DebugPrint("WBP_ImpressionResult_Common InterruptExit")
    AudioManager(self):StopSound(self, "ImpressionResultPressing")
    self:RemoveFromParent()
    if self.OnInterruptedExitDelegate then
        self.OnInterruptedExitDelegate[2](self.OnInterruptedExitDelegate[1])
    end
end

function WBP_ImpressionResult_Common:SetRand1TextAlpha(Alpha)
    DebugPrint("WBP_ImpressionResult_Common SetRand1TextAlpha", Alpha)
    self.Text_DiceNum_2.ColorAndOpacity.SpecifiedColor.A = Alpha
    self.Text_DiceNum_2:SetColorAndOpacity(self.Text_DiceNum_2.ColorAndOpacity)
end

function WBP_ImpressionResult_Common:OnInAnimationStarted()
    DebugPrint("WBP_ImpressionResult_Common OnInAnimationStarted")
    AudioManager(self):PlayUISound(self, "event:/ui/common/image_choose_hud_show","",nil)
    self:SwitchShowSpaceShortCut(true)
end

function WBP_ImpressionResult_Common:OnOutAnimationStarted()
    DebugPrint("WBP_ImpressionResult_Common OnOutAnimationStarted")
end

function WBP_ImpressionResult_Common:OnSuccessAnimationStarted()
    DebugPrint("WBP_ImpressionResult_Common OnSuccessAnimationStarted")
    --AudioManager(self):PlayUISound(self, "event:/ui/common/image_choose_dice_rotate","",nil)
end

function WBP_ImpressionResult_Common:OnFailAnimationStarted()
    DebugPrint("WBP_ImpressionResult_Common OnFailAnimationStarted")
    --AudioManager(self):PlayUISound(self, "event:/ui/common/image_choose_dice_rotate","",nil)
    self:SwitchShowFailButtons(true)
end

function WBP_ImpressionResult_Common:TryChangeDiceTextures(Rand1, Rand2)
    DebugPrint("WBP_ImpressionResult_Common TryChangeDiceTextures", Rand1, Rand2, self.bReceivedData)
    if not self.bReceivedData then
        self.bRefreshDiceOnResultReceived = true
        return
    end
    self.bRefreshDiceOnResultReceived = true
    local LDicePath = "/Game/UI/WBP/Common/VX/Impression/T_ImperssionResult_"..tostring(Rand1).."0"
    local RDicePath = "/Game/UI/WBP/Common/VX/Impression/T_ImperssionResult_"..tostring(Rand2)
    local LDice = LoadObject(LDicePath)
    local RDice = LoadObject(RDicePath)
    self.VX_DiceResult_L:SetBrushFromTexture(LDice)
    self.VX_DiceResult_R:SetBrushFromTexture(RDice)
end

function WBP_ImpressionResult_Common:OnPressAnimationStarted()
    DebugPrint("WBP_ImpressionResult_Common OnPressAnimationStarted")
    AudioManager(self):PlayUISound(self, "event:/ui/common/image_choose_dice_rotate_loop", "ImpressionResultPressing",nil)
    self:TryChangeDiceTextures(self.Rand1, self.Rand2)
end

function WBP_ImpressionResult_Common:OnClickAnimationStarted()
    DebugPrint("WBP_ImpressionResult_Common OnClickAnimationStarted")
    self:SetDiceNumVisibility(UE4.ESlateVisibility.Visible)
    self:TryChangeDiceTextures(self.Rand1, self.Rand2)
end

function WBP_ImpressionResult_Common:OnAgainAnimationStarted()
    DebugPrint("WBP_ImpressionResult_Common OnAgainAnimationStarted")
    AudioManager(self):PlayUISound(self, "event:/ui/common/image_choose_hud_show","",nil)
    self:SwitchShowFailButtons(false)
    self:TryChangeDiceTextures(0, 0)
end

-- Remind动效播放时
function WBP_ImpressionResult_Common:OnRemindAnimationStarted()
    DebugPrint("WBP_ImpressionResult_Common OnRemindAnimationStarted")
    --AudioManager(self):PlayUISound(self, "event:/ui/common/image_choose_dice_pre", "",nil)
end

-- Roll点出现时-成功
function WBP_ImpressionResult_Common:OnSuccessRollAppeared()
    DebugPrint("WBP_ImpressionResult_Common OnSuccessRollAppeared")
    AudioManager(self):PlayUISound(self, "event:/ui/common/image_choose_dice_success","",nil)
end

-- Roll点出现时-失败
function WBP_ImpressionResult_Common:OnFailRollAppeared()
    DebugPrint("WBP_ImpressionResult_Common OnFailRollAppeared")
    AudioManager(self):PlayUISound(self, "event:/ui/common/image_choose_dice_fail","",nil)
end

-- 点击"再次投掷"
function WBP_ImpressionResult_Common:PlayRetrySound()
    DebugPrint("WBP_ImpressionResult_Common PlayRetrySound")
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm","",nil)
end

-- 点击"继续"
function WBP_ImpressionResult_Common:PlayContinueSound()
    DebugPrint("WBP_ImpressionResult_Common PlayContinueSound")
    AudioManager(self):PlayUISound(self, "event:/ui/common/click","",nil)
end

function WBP_ImpressionResult_Common:ChangeDiceImage()
    local SrcNum = tonumber(self.Rand1) * 10 + tonumber(self.Rand2)
    local AddNum = tonumber(self.PlayerValue)
    local Num = SrcNum + AddNum

    local a = math.floor(Num / 100)
    Num = Num - a*100
    local b = math.floor(Num / 10)
    Num = Num - b*10
    local c = math.floor(Num)

    self:SetDiceNum(a,b,c)
end

function WBP_ImpressionResult_Common:SetOnReceiveRetryServerHandled(Callback)
    self.OnServerHandledCallback = Callback
end

-- 转换为印象商店模式
function WBP_ImpressionResult_Common:ChangeToImpressionShopMode(OnCheckCallback, CheckParams)
    DebugPrint("WBP_ImpressionResult_Common ChangeToImpressionShopMode")
    self.CheckParams = CheckParams
    self.CheckValue = CheckParams.CheckValue 
    self.PlayerValue = CheckParams.PlayerValue
    self.CheckType = CheckParams.CheckType
    self.CheckMode = ECheckMode.ImpressionShop
    self.OnCheckCallback = OnCheckCallback
    self.bReceivedData = false
    self.bListenPressInput = true
    self.bListenReleaseInput = true
    self:CommonInit()
    self:SetDiceNum(0, 0, 0)
    self:FadeIn()
    self:DisablePlayerInput(true)
end

function WBP_ImpressionResult_Common:DisablePlayerInput(bDisable)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if not IsValid(Player) then
        return
    end
    local Controller = UE4.UGameplayStatics.GetPlayerController(self, 0)
    if (bDisable) then
        if Controller and Controller:IsA(APlayerController) then
            Player:AddDisableInputTag("ImpressioShopResult")
        end
        if(Player:GetMovementComponent()) then 
            Player:GetMovementComponent():ConsumeInputVector()
        end
    else
        if Controller and Controller:IsA(APlayerController) then
            Player:RemoveDisableInputTag("ImpressioShopResult")
        end
        
    end
end

function WBP_ImpressionResult_Common:SwitchBindDicePressInput(bBind)
    DebugPrint("WBP_ImpressionResult_Common SwitchBindDicePressInput", bBind)
end

function WBP_ImpressionResult_Common:InitPlayKey()
    DebugPrint("WBP_ImpressionResult_Common:InitPlayKey")
end

function WBP_ImpressionResult_Common:AdaptPlatform()
    DebugPrint("WBP_ImpressionResult_Common:AdaptPlatform")
end

function WBP_ImpressionResult_Common:SwitchBindDiceReleaseInput(bBind)
    DebugPrint("WBP_ImpressionResult_Common SwitchBindDiceReleaseInput", bBind)
end

function WBP_ImpressionResult_Common:SwitchShowSpaceShortCut(bShow)
    DebugPrint("WBP_ImpressionResult_Common:SwitchShowSpaceShortCut", bShow)
end

function WBP_ImpressionResult_Common:SwitchBindSkipInput(bBind)
    DebugPrint("WBP_ImpressionResult_Common:SwitchBindSkipInput", bBind)
end

function WBP_ImpressionResult_Common:AddInputMethodChangedListen()
end

function WBP_ImpressionResult_Common:RemoveInputMethodChangedListen()
end

function WBP_ImpressionResult_Common:OnBtn_DiceReleased_Platform()
end

function WBP_ImpressionResult_Common:OnAgainAnimationFinished_Platform()
end

return WBP_ImpressionResult_Common
