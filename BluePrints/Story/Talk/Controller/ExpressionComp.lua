---@class ExpressionComp_C
local ExpressionComp_C = {}
local Utils = require "Utils"
local FeishuLogType = UE.EStoryLogType.Talk
local FeishuErrorTitle = "播放表情出错(资源缺失/填表错误)"
ExpressionComp_C.New = function(bResumeOnTalkEnd)
    if bResumeOnTalkEnd == nil then
        bResumeOnTalkEnd = true
    end
    ---@type ExpressionComp_C
    local Obj = setmetatable({}, {
        __index = ExpressionComp_C
    })
    Obj.bResumeOnTalkEnd = bResumeOnTalkEnd
    Obj.ResumeActors = {}
    return Obj
end

function ExpressionComp_C:PrintErrorToFeishu(TalkActor, ExpressionId, MontagePath)
    local Message = "找不Montage资源"..
    "\nNpc名字:"..TalkActor:GetName()..
    "\n表情Id(FacialId):"..ExpressionId ..
    "\nMontage路径:"..MontagePath

    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, FeishuLogType, FeishuErrorTitle, Message)
end

---@param TalkActor AActor
---@param FacialData FacialData_C
---@param TalkContext BP_TalkContext_C
---@param TalkTask TalkTaskBase_C
function ExpressionComp_C:PlayFacialAnimation(TalkActor, FacialData, TalkContext, TalkTask)
    DebugPrint("ExpressionComp_C:PlayFacialAnimation",TalkActor,FacialData.ExpressionId,TalkContext,TalkTask)
    ---@type USkeletalMeshComponent
    if not TalkActor then
        return
    end
    if self.bResumeOnTalkEnd then
        self.ResumeActors = self.ResumeActors or {}
        table.insert(self.ResumeActors, TalkActor)
    end

    TalkActor:NewPlayFacial(FacialData.ExpressionId)
end

function ExpressionComp_C:OnTalkInterrupted()
    self:OnTalkEnd()
end

function ExpressionComp_C:Clear()
    self:OnTalkEnd()
end

function ExpressionComp_C:OnTalkEnd()
    if self.bResumeOnTalkEnd then
        for _,Actor in pairs(self.ResumeActors) do
            if IsValid(Actor) and Actor.ReinitDefaultFacial then
                Actor:StopFacial()
                Actor:NewInitDefaultFacial()
            end
        end
    end
end

return ExpressionComp_C
