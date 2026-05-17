local M = Class("BluePrints.Story.FlowGraph.FlowNode.TalkFlowNode.FlowNode_TalkNodeBase")
local CommonPopupUIId = 100222
local CameraBlendTime = 1
local FlowLogType = UE.EStoryLogType.TalkFlow

function M:Start()
    self.bHandled = false
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        self:FinishCancel()
        return
    end
    if Avatar.CatName and Avatar.CatName ~= "" then
        self:FinishAccept()
        return
    end
    local TalkTask = self:TryGetTalkTask()
    TalkTask:HideUI(true, "CatName")

    local CommonDialogParams = {
    	UseGenaral = true,
        MultilineType = 1,
        TextLenMax = DataMgr.GlobalConstant.CatNameMaxLen.ConstantValue,
        OnSDKChecked = function(bRes, InputWidget, Text)
            if self.bHandled then return end
            self.bHandled = true
          	if not bRes then return end
          	local Callback = function(ErrCode)
          		if not ErrorCode:Check(ErrCode) then
          			local ErrorCodeMessage = "错误码不存在"
			        local ErrorCodeData = DataMgr.ErrorCode[ErrCode]
			        if (ErrorCodeData) then
			            ErrorCodeMessage = ErrorCodeData.ErrorCodeContent or "错误码不存在说明内容"
			        end
			        local Title = "猫猫起名错误"
			        local Message = string.format("ErrorCode: %d\n%s\n名称为：%s", ErrCode, ErrorCodeMessage, Text)
			        UStoryLogUtils.PrintToFeiShu(self, FlowLogType, Title, Message)
          			self:FinishCancel()
          			return 
          		end
            	self:FinishAccept()
          	end
          	Avatar:SetCatName(Text,Callback)
        end,
    }
    CommonDialogParams.LeftCallbackFunction = function()
        if self.bHandled then return end
        self.bHandled = true 
        self:FinishCancel()
    end
    CommonDialogParams.CloseBtnCallbackFunction = CommonDialogParams.LeftCallbackFunction
    CommonDialogParams.Owner = self
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    UIManager:ShowCommonPopupUI(CommonPopupUIId, CommonDialogParams, TalkTask.UI)
end

function M:K2_Cleanup()
    local TalkTask = self:TryGetTalkTask()
    TalkTask:HideUI(false, "CatName")
end

function M:CanSkip()
    return false
end

return M