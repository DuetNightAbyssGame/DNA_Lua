--
-- DESCRIPTION
-- 手机端队友信息
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local M = Class("BluePrints.UI.BP_EMUserWidget_C")

--- Member的数据结构
--- @type AvatarInfo
function M:InitTeamInfo(ParentWidget)
    self.List_TeamInfo_M:ClearListItems()
    local TeamData = ChatController:GetModel():GetTeamForChat()
    if not TeamData then return end
    for i = 1, TeamCommon.MaxTeamMembers, 1 do
        local Member = TeamData.Members[i]            
        -- 队友信息(包括自己)
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Data = Member
        Content.bNotNeedClickBtn = true
        Content.Owner = ParentWidget
        Content.Index = Member and Member.Index or nil
        self.List_TeamInfo_M:AddItem(Content)
    end
end

return M