--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
require "DataMgr"

local TalkUtils = require "BluePrints.Story.Talk.View.TalkUtils"

---@type BP_Fault_Black_UI_C
local BP_Fault_Black_UINew_C = Class("BluePrints.Story.Talk.UI.BP_TalkBaseUINew_C")

-- function M:Initialize(Initializer)
-- end

-- region UUserWidget
-- function BP_Fault_Black_UINew_C:PreConstruct(IsDesignTime)
--     self.Super.PreConstruct(self, IsDesignTime)
-- end

function BP_Fault_Black_UINew_C:Construct()
    self.Overridden.Construct(self) ---@author: hxp 2023-03-17 10:31:12: 蓝图有 TA 写的故障代码。
    self:BindToAnimationFinished(self.Random, {self, self.OnWholeDialogueTypingFinsihed})
    self.Super.Construct(self)
    if(self.CommonLoading) then
        self.AllTalkEnd = false
        self.CanShowCommonLoading = false
        self.CommonLoading:SetVisibility(ESlateVisibility.Collapsed)
        EventManager:AddEvent(EventID.SetPlayerLocWithLoadLevel, self, self.SetPlayerLocWithLoadLevelEvent)
    end
    self.CanvasPanel_0:SetRenderOpacity(0)
    self.BackGround:SetRenderOpacity(0)
    AudioManager(self):PlayUISound(self, "event:/snapshot/ui/filter_fade_ui", "FaultBlackUI", nil)
    self:SetStoryInputModeEnabled(true)
    self:RefreshBaseInfo()
end

function BP_Fault_Black_UINew_C:Destruct()
    EventManager:RemoveEvent(EventID.SetPlayerLocWithLoadLevel, self)
    AudioManager(self):StopSound(self, "FaultBlackUI")
    self.Super.Destruct(self)
end

function BP_Fault_Black_UINew_C:SetPlayerLocWithLoadLevelEvent()
    self.CanShowCommonLoading = true
    if(self.AllTalkEnd) then
        self:ShowCommonLoading()
    end
end

function BP_Fault_Black_UINew_C:ShowCommonLoading()
    self.CommonLoading:SetVisibility(ESlateVisibility.Visible)
    self.CommonLoading:PlayAnimation(self.CommonLoading.In)
    self.CommonLoading:BindToAnimationFinished(self.CommonLoading.In, {self.CommonLoading, function()
    self.CommonLoading:UnbindAllFromAnimationFinished(self.CommonLoading.In)
    self.CommonLoading:PlayAnimation(self.CommonLoading.Loop, 1, 0)
    end})
end


---@param TaskData TalkTaskDataBase_C
function BP_Fault_Black_UINew_C:PreEnterTalkTask(TalkTask, TaskData, OnPreEnterTalkTaskFinished)
    -- self:PlayAnimation(self.FadeInAnimation)
    self.Super.PreEnterTalkTask(self,TalkTask, TaskData, OnPreEnterTalkTaskFinished)
end

---@param TaskData TalkTaskDataBase_C
function BP_Fault_Black_UINew_C:PreExitTalkTask(TalkTask, TaskData, OnPreExitTalkTaskFinished)
    if(self.CommonLoading) then self.CommonLoading:PlayAnimation(self.CommonLoading.Out) end
    -- self:PlayAnimation(self.FadeOutAnimation)
    self.Super.PreExitTalkTask(self, TalkTask, TaskData, OnPreExitTalkTaskFinished)
end

-- endregion

-- region BP_TalkBaseUI_C
-- function BP_Fault_Black_UI_C:Init(Context)
--     self.Super.Init(self, Context)
--     self.OnTalkClicked_Callback = Context:CreateDelegateInContext()
--     self.OnAutoPlayChanged_Callback = Context:CreateDelegateInContext()
--     self.OnSkipped_Callback = Context:CreateDelegateInContext()
--     self.OnPlayComplete_Callback = Context:CreateDelegateInContext()
--     self.OnOptionItemClicked_Callback = Context:CreateDelegateInContext()

--     self:BindToAnimationFinished(self.Random, {self, self.OnTalkPlayComplete})
-- end

-- function BP_Fault_Black_UI_C:OnNodeStart(TalkId)
--     self.Super.OnNodeStart(self, TalkId)
-- end

-- function BP_Fault_Black_UI_C:OnNodeEnd(TalkId)
--     self.Super.OnNodeEnd(self, TalkId)
-- end

---@param TalkTask TalkTaskBase_C
---@param DialogueData DialogueDataBase_C
---@param TaskData TalkTaskDataBase_C
function BP_Fault_Black_UINew_C:PlayDialogue(TalkTask,DialogueData,TaskData)
    local Content = DialogueData.Content
    self.CanvasPanel_0:SetRenderOpacity(1)
    self.BackGround:SetRenderOpacity(1)
    self.Text_Talk:SetText(Content)
    self:PlayAnimation(self.Random)
    if(DataMgr.Dialogue[DialogueData.DialogueId].NextDialogues == nil) then
        self:BindToAnimationFinished(self.Random, {self, function()
            -- self:UnbindAllFromAnimationFinished(self.Random)
            self.AllTalkEnd = true
            if(self.CommonLoading and self.CanShowCommonLoading) then
                self:ShowCommonLoading()
            end
        end})
    end
end

function BP_Fault_Black_UINew_C:OnWholeDialogueTypingFinsihed()
    self.WholeDialogueTypingFinished_Delegate:Fire(true)
end

function BP_Fault_Black_UINew_C:HasPageTypingFinished()
    return true
end

function BP_Fault_Black_UINew_C:HasWholeDialogueTypingFinished()
    return true
end
-- endregion

function BP_Fault_Black_UINew_C:IsAutoPlay()
    return true
end

return BP_Fault_Black_UINew_C
