--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local TalkUtils = require "BluePrints.Story.Talk.View.TalkUtils"
---@type WBP_Story_Review_Interaction_Item_P_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:OnListItemObjectSet(Content)
    local HighDialogueId = Content.HighDialogueId
    local DialogueContent = TalkUtils:DialogueIdToContent(Content.DialogueId)
    if HighDialogueId == Content.DialogueId then
        self.Switcher:SetActiveWidgetIndex(0)
        self.Text_Interactive:SetText(DialogueContent)
    else
        --self:SetRenderOpacity(0)
        self.Switcher:SetActiveWidgetIndex(1)
        self.Text_Interactive02:SetText(DialogueContent)
        self.Img_Item_2:SetVisibility(Content.IsSelected and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
    end
end

return M
