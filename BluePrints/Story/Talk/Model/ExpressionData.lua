local ExpressionData_C = {}

local FeishuErrorTitle = "播放表情出错"
ExpressionData_C.New = function(ExpressionId)
    local Obj = setmetatable({}, {})
    local FacialData = DataMgr.Facial[ExpressionId]
    if not FacialData then
        local Message = "Facial表中无FacialId:"..tostring(ExpressionId)
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.TalkAction, FeishuErrorTitle, Message)
        return Obj
    end
    Obj.ExpressionId = ExpressionId
    return Obj
end

return {
    ExpressionData_C = ExpressionData_C
}
