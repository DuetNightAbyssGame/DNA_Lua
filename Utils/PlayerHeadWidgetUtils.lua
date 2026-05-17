local PlayerHeadWidgetUtils = {}

function PlayerHeadWidgetUtils:EnableHeadWidget(WidgetComp,WidgetName,bEnable,...)
    if not WidgetComp then
        return
    end
    if (bEnable) then
        WidgetComp:EnableWidget(WidgetName,...)
    else
        WidgetComp:DisableWidget(WidgetName,...)
    end
end

function PlayerHeadWidgetUtils:RefreshRegionNameInfo(WidgetComp,UId, ObjId)
    local Name = ""
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local RegionAvatars = Avatar.RegionAvatars or {}
        local OtherAvatar = RegionAvatars[ObjId]
        Name = OtherAvatar and OtherAvatar.AvatarInfo.Nickname
    end
    local Member, Pos = TeamController:GetModel():GetTeamMember(UId)
    self:EnableHeadWidget(WidgetComp,"Name", false)
    local Style = "Player"
    if Pos == 0 or not Pos then
        Style = nil
    end
    self:EnableHeadWidget(WidgetComp,"Name", true, Name, Style, Pos)
end

function PlayerHeadWidgetUtils:RefreshTitleInfo(WidgetComp,ObjId)
     local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    -- if Avatar then
    local RegionAvatars = Avatar.RegionAvatars or {}
    local OtherAvatar = RegionAvatars[ObjId]
    if not OtherAvatar or not OtherAvatar.AvatarInfo then
        return 
    end
    local PrefixId = OtherAvatar.AvatarInfo.TitleBefore
    local SuffixId = OtherAvatar.AvatarInfo.TitleAfter
    local TitleFrameId = OtherAvatar.AvatarInfo.TitleFrame
    print(_G.LogTag, "RefreshTitleInfo", PrefixId, SuffixId, TitleFrameId)
    self:RefreshTitle(WidgetComp,PrefixId, SuffixId, TitleFrameId)
    -- end
end


function PlayerHeadWidgetUtils:EnableTitle(WidgetComp,PrefixId, SuffixId, TitleFrameId)
    self:EnableHeadWidget(WidgetComp,"Title", true, PrefixId, SuffixId, TitleFrameId)
end

function PlayerHeadWidgetUtils:DisableTitle(WidgetComp)
    self:EnableHeadWidget(WidgetComp,"Title", false)
end

function PlayerHeadWidgetUtils:RefreshTitle(WidgetComp,PrefixId, SuffixId, TitleFrameId)
    self:DisableTitle(WidgetComp)
    self:EnableTitle(WidgetComp,PrefixId, SuffixId, TitleFrameId)
end

function PlayerHeadWidgetUtils:PlayEmoji(WidgetComp, EmojiPath)
    self:EnableHeadWidget(WidgetComp, "Bubble_Emoji", true, EmojiPath)
end

function PlayerHeadWidgetUtils:StopEmoji(WidgetComp)
    self:EnableHeadWidget(WidgetComp, "Bubble_Emoji", false)
end

return PlayerHeadWidgetUtils