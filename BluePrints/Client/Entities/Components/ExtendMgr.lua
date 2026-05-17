local Component = {}
function Component:SetRefreshRobberMonster(NewValue)
    self:CallServerMethod("SetRefreshRobberMonster", NewValue)
end


function Component:SetTalkTag(TargetTag, TagValueType, ClientCallback)
    local function Callback(Ret)
        if (ErrorCode:Check(Ret)) then
            if ClientCallback then
                ClientCallback()
            end
        end
    end
    local Results = Utils.Split(TagValueType, "_")
    local ResultValue = tonumber(Results[2])
    if not DataMgr.TalkTag[TargetTag] or DataMgr.TalkTag[TargetTag].TalkTagId ~= TargetTag or
        not DataMgr.TalkTag[TargetTag].Value or not ResultValue or not DataMgr.TalkTag[TargetTag].Value[ResultValue] then
        local Message = string.format("SetTalkTag 失败: Tag: %s, Value: %s", TargetTag, TagValueType)
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Script, "对话运行时出错", Message)
        return
    end
    local TagValue = DataMgr.TalkTag[TargetTag].Value[ResultValue]
    self.TalkTags[TargetTag] = TagValue
    self:CallServer("SetTalkTag", Callback, TargetTag, TagValueType)
end

function Component:UnSetTalkTag(TargetTag, ClientCallback)
    local function Callback(Ret)
        if (ErrorCode:Check(Ret)) then
            if ClientCallback then
                ClientCallback()
            end
        end
    end
    if not DataMgr.TalkTag[TargetTag] or DataMgr.TalkTag[TargetTag].TalkTagId ~= TargetTag then
        local Message = string.format("UnSetTalkTag 失败: Tag: %s", TargetTag)
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Script, "对话运行时出错", Message)
        return
    end
    self.TalkTags[TargetTag] = nil
    self:CallServer("UnSetTalkTag", Callback, TargetTag)
end

function Component:GetTalkTag(TargetTag)
    return self.TalkTags[TargetTag]
end


return Component