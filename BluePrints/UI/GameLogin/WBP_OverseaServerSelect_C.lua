require "UnLua"

---@class WBP_Login_OverSeaServerContent : UEMUserWidget
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

function M:InitContent(Params, PopupData, Owner)
    self:SetFocus(true)
    ---@type WBP_Common_Dialog_PC_C
    self.Owner = Owner
    
    self.ServerInfos = Params.ServerInfos or {}
    self.Avatars = Params.Avatars or {}
    local RecommandSelectHostnum = Params.RecommandSelectHostnum or nil
    local DefaultSelectHostnum = Params.DefaultSelectHostnum or nil
    local RecommandSelectArea = nil
    local DefaultSelectArea = nil
    local Avatars = {}
    local MaxLevel = 0
    local MaxLevelHostnum = nil
    for _, Avatar in pairs(self.Avatars) do
        Avatars[tonumber(Avatar.Hostnum)] = Avatar
        if not RecommandSelectHostnum and Avatar.AvatarInfo.Level > MaxLevel then
            MaxLevel = Avatar.AvatarInfo.Level
            MaxLevelHostnum = Avatar.Hostnum
        end
    end
    local NewServerInfos = {}
    local ServerAreas = {}
    if RecommandSelectHostnum then
        local ServerInfo = self.ServerInfos[tonumber(RecommandSelectHostnum)]
        if ServerInfo then
            ServerAreas[ServerInfo.area] = true
            NewServerInfos[tonumber(RecommandSelectHostnum)] = ServerInfo
            RecommandSelectArea = ServerInfo.area
        end
    end
    if DefaultSelectHostnum then
        local ServerInfo = self.ServerInfos[tonumber(DefaultSelectHostnum)]
        if ServerInfo and not ServerAreas[ServerInfo.area] then
            ServerAreas[ServerInfo.area] = true
            NewServerInfos[tonumber(DefaultSelectHostnum)] = ServerInfo
            DefaultSelectArea = ServerInfo.area
        end
    end
    if not DefaultSelectArea then
        DefaultSelectArea = RecommandSelectArea
    end
    for k, v in pairs(self.ServerInfos) do
        if Avatars[tonumber(k)] then
            local RemoveServers = {}
            if ServerAreas[v.area] then
                for kk, vv in pairs(NewServerInfos) do
                    if vv.area == v.area then
                        DebugPrint("Replace server in area " .. v.area .. " from hostnum " .. tostring(vv.hostnum) .. " to hostnum " .. tostring(v.hostnum))
                        table.insert(RemoveServers, kk)
                    end
                end
            end
            for _, Hostnum in ipairs(RemoveServers) do
                NewServerInfos[Hostnum] = nil
            end
            ServerAreas[v.area] = true
            NewServerInfos[tonumber(k)] = v
        end
    end
    for k, v in pairs(self.ServerInfos) do
        if not ServerAreas[v.area] then
            ServerAreas[v.area] = true
            NewServerInfos[tonumber(k)] = v
        end
    end
    local Contents = {}
    for k, v in pairs(NewServerInfos) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        if Content then
            Content.Parent = self
            Content.ServerInfo = v
            if Avatars[v.hostnum] then
                Content.Avatar = Avatars[v.hostnum]
            end
            if MaxLevelHostnum then
                if v.hostnum == MaxLevelHostnum then
                    Content.bRecommand = true
                end
            elseif RecommandSelectArea and v.area == RecommandSelectArea then
                Content.bRecommand = true
            end
            if DefaultSelectArea and v.area == DefaultSelectArea then
                Content.bSelected = true
            end
            table.insert(Contents, Content)

        else
            DebugPrint("Failed to create content for server: " .. tostring(v))
        end
    end
    table.sort(Contents, function(a, b)
        -- if a.bDefaultSelect then
        --     return true
        -- elseif b.bDefaultSelect then
        --     return false
        -- end
        -- if a.Avatar and b.Avatar then
        --     return a.Avatar.AvatarInfo.Level > b.Avatar.AvatarInfo.Level
        -- end
        -- if a.Avatar then
        --     return true
        -- end
        -- if b.Avatar then
        --     return false
        -- end
        return a.ServerInfo.area < b.ServerInfo.area
    end)
    -- if #Contents > 0 then
    --     Contents[1].bSelected = true
    -- end
    for _, Content in ipairs(Contents) do
        if Content then
            self.List_Item:AddItem(Content)
        end
    end

end

function M:OnSelected(Content)
    if self.CurrentSelectedContent and self.CurrentSelectedContent ~= Content then
        if self.CurrentSelectedContent.CurrentEntry then
            self.CurrentSelectedContent.CurrentEntry:SetSelected(false)
        end
        self.CurrentSelectedContent.bSelected = false
    end
    self.CurrentSelectedContent = Content
end

function M:PackageData()
    if self.CurrentSelectedContent then
        return self.CurrentSelectedContent.ServerInfo
    end
    return nil
end

return M