--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Rouge_EventChatItem_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

-- function M:Construct()
-- end

function M:OnListItemObjectSet(Obj)
    self.DialogueType = Obj.DialogueType
    self.SpeakerName = Obj.SpeakerName
    self.DialogueContent = Obj.DialogueContent
    self:SetShowContent()
end

function M:SetShowContent()
    self.Group_VB:SetActiveWidgetIndex(self.DialogueType)
    if self.DialogueType == 0 then
        self.Text_LeftPlayerName:SetText(self.SpeakerName)
        self.Text_LeftDialog:SetText(self.DialogueContent)
    elseif self.DialogueType == 1 then
        self.Text_RightPlayerName:SetText(self.SpeakerName)
        self.Text_RightDialog:SetText(self.DialogueContent)
    elseif self.DialogueType == 2 then
        self.Text_ChoiceName:SetText(self.SpeakerName)
        self.Text_ChoiceDialog:SetText(self.DialogueContent)
    elseif self.DialogueType == 3 then
        self.Text_Aside:SetText(self.DialogueContent)
    end
end

return M
