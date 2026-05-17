
-- 战斗内反外挂检测
local Component = Class()

local CHEAT_ORIGIN_CLIENT = 1    -- 客户端上报

function Component:ReportAntiCheatToPlatform(CheatType, CheatLog)
    DebugPrint("gmy@ReportAntiCheatToPlatform", CheatType, CheatLog)

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    
    self.CheatTypeMap = self.CheatTypeMap or {}
    if self.CheatTypeMap[CheatType] then
        return
    end
    self.CheatTypeMap[CheatType] = true
    
    DebugPrint("gmy@BattleAntiCheat Component:ReportAntiCheatToPlatform rpc", CheatLog, CheatType, CHEAT_ORIGIN_CLIENT)
    Avatar:CallServerMethod("ReportSentimentSDKCheat", CheatLog, CheatType, CHEAT_ORIGIN_CLIENT, {})
end


return Component
