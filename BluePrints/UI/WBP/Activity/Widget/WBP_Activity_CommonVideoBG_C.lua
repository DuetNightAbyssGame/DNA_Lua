--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_CommonVideoBG_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
-- function M:Initialize(Initializer)
-- end

-- function M:Construct()
-- end

function M:PlayBGVideo(ActivityConfigData, PageConfigData)
    self.VideoPlayer:Stop()
    local BgPath = ActivityConfigData.VideoPath
    if ActivityConfigData.BgBGM then
        self.CurrentBgMusic = ActivityConfigData.BgBGM
        AudioManager(self):PlayUISound(self, ActivityConfigData.BgBGM, "BGVideoSound", nil)
    end
    self.VideoPlayer:SetUrlByMediaSource(LoadObject(BgPath))
    self.VideoPlayer:SetLooping(true)
    self.VideoPlayer:Play()
end

function M:Destruct()
    self.VideoPlayer:Stop()
    AudioManager(self):StopSound(self, "BGVideoSound")
    DebugPrint("ayff test stop bg video music")
end


return M
