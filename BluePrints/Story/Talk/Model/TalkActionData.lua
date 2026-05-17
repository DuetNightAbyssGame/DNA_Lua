---@class TalkActionData_C
local TalkActionData_C = {}
TalkActionData_C.New = function(TalkActionId)
    ---@type TalkActionData_C
    local Obj = setmetatable({}, {})
    local Data = DataMgr.TalkAction[TalkActionId]

    if (Data == nil) then
        local Message = string.format("TalkActionData_C.New 执行失败, 对话动作编号 %s 在 DataMgr.TalkAction 中不存在。", TalkActionId)
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.TalkAction, "TalkActionData创建失败: TalkActionId不在表中", Message)
        return nil
    end

    Obj.TalkActionId = TalkActionId
    ---@type boolean
    Obj.IsSpecialAction = Data.IsSpecialAnim
    ---@type string
    Obj.ActionMontage = Data.ActionMontage
    ---@type string
    Obj.MontageSection = Data.MontageSection
    ---@type number
    Obj.BlendInTime = Data.BlendInTime
    ---@type number
    Obj.BlendOutTime = Data.BlendOutTime
    ---@type string
    Obj.EndLoopMontage = Data.EndLoopMontage
    ---@type string
    Obj.EndLoopMontageSection = Data.EndLoopMontageSection
    ---@type boolean
    Obj.IsOnceAction = Data.IsOnceAction
    return Obj
end

local function CreateTalkActionData(TalkActorId, TalkActionId)
        DebugPrint("Play action", TalkActorId, TalkActionId)
        return TalkActionData_C.New(TalkActionId)
end

return {
    CreateTalkActionData = CreateTalkActionData,
    TalkActionData_C = TalkActionData_C
}
