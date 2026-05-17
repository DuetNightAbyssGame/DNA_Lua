local M = Class()

-- 关闭角色接收场景投影
function M:OnEnableSceneShadowCharacter(bEnable)
    local TalkContext = GWorld.GameInstance:GetTalkContext()
    if not IsValid(TalkContext) then
        return
    end
    TalkContext:SetCharacterShadowSetting(bEnable)
end

-- 关闭自动曝光
function M:OnEnableEyeAdaptation(bEnable)
    if bEnable then
        if not self.SavedEyeAdaptationQuality then
            self.SavedEyeAdaptationQuality = UKismetSystemLibrary.GetConsoleVariableIntValue("r.EyeAdaptationQuality")
        end
        UKismetSystemLibrary.ExecuteConsoleCommand(self, "r.EyeAdaptationQuality 0")
    elseif self.SavedEyeAdaptationQuality then
        UKismetSystemLibrary.ExecuteConsoleCommand(self, "r.EyeAdaptationQuality ".. tostring(self.SavedEyeAdaptationQuality or 2))
        self.SavedEyeAdaptationQuality = nil
    end
end

return M
