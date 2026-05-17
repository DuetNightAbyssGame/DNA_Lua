local CameraGameUtils = require "BluePrints.UI.WBP.Activity.PC.CameraGame.CameraGameUtils"

local Component = {}

function Component:GetPhotoQuestFinishReward(InCallback, QuestChainId)
    local function Callback(ErrorCode, Rewards)
        self.logger.info("GetPhotoQuestFinishReward ", ErrorCode)
        if InCallback then
            InCallback(ErrorCode, Rewards)
        end
    end
    self:CallServer("GetPhotoQuestFinishReward",Callback, QuestChainId)
end

function Component:_OnPropChangePhotoActRewardGot()
    -- 刷新红点
    CameraGameUtils.RefreshReddot()
end

return Component