local EMCache = require "EMCache.EMCache"

local Component = {}

-- 这个函数在初始化的时候调用，暂时偷个懒把初始化要读的音频全局参数表读进来
-- function Component:RecoverSavedData()
--     Component:RecoverVolumeData()
--     Component:ReadSeGlobalParameters()
-- end

-- 读音频全局参数表，并存储
function Component:ReadSeGlobalParameters()
    Component.GlobalParams = {}
    Component.GlobalParams["VoHitHeavyDmg"] = DataMgr.SeGlobalParameter["VoHitHeavyDmg"].SeGlobalValue
    Component.GlobalParams["VoHitHeavySeId"] = DataMgr.SeGlobalParameter["VoHitHeavySeId"].SeGlobalValue
    Component.GlobalParams["VoHitLightSeId"] = DataMgr.SeGlobalParameter["VoHitLightSeId"].SeGlobalValue
end

function Component:GetGlobalParamsTable(ParamKey)
    return Component.GlobalParams[ParamKey]
end

-- 恢复音量数据
function Component:RecoverVolumeData()
    DebugPrint("Recover Volume")
    local RecordedVolume = EMCache:Get("FMODVolume")
    if not RecordedVolume then
        return
    end
    for Bus,VolumeValue in pairs(RecordedVolume) do
        DebugPrint("Recover Volume", Bus, VolumeValue)
        self:SetBusVolume(Bus, VolumeValue)
    end
end

-- 存储音量数据
function Component:SaveVolumeData(Bus, VolumeValue)
    local RecordedVolume = EMCache:Get("FMODVolume")
    RecordedVolume = RecordedVolume or {}
    RecordedVolume[Bus] = VolumeValue
    DebugPrint("Current Volume Setting")
    PrintTable(RecordedVolume,2)
end

return Component