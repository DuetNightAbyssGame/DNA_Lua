--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Rouge_EventChat_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

--function M:Initialize(Initializer)
--end

function M:Construct()
    if self.Btn_Click then
        self.Btn_Click.OnClicked:Add(self, self.OnBtnClick)
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:InitUI(ChatInfo)
    self:PlayAnimation(self.In)
    if ChatInfo.IsAnswer then -- 如果是回答，直接设置文本
        self.Text_Content:SetText(ChatInfo.Content)
    else
        -- 1=Npc 2=主角 3=旁白
        if ChatInfo.CurrentTalkType == 1 then
            self.Switch_Role:SetActiveWidgetIndex(0)
            self.Text_Npc:SetText(ChatInfo.TalkActorName)
        elseif ChatInfo.CurrentTalkType == 2 then
            self.Switch_Role:SetActiveWidgetIndex(1)
            self.Text_Player:SetText(ChatInfo.TalkActorName)
        else
            self.SizeBox_Name:SetVisibility(ESlateVisibility.Collapsed)
        end
        self.Text_Chat:SetText(ChatInfo.Content)
    end
    self.Parent = ChatInfo.Parent
end

function M:OnBtnClick()
    self.Parent:OnIteratorDialogue()
end

return M
