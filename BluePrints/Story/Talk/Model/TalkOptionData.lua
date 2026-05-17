local TalkUtils = require "BluePrints.Story.Talk.View.TalkUtils"

local ETalkOptionType = {
    Dialogue = "dialogue",
    Normal = "normal",
    Random = "random",
    Plus = "plus",
    Check = "check",
    RougeLike = "rougeLike",
    Branch = "branch",
}

---@class TalkOptionData_C
---@field public OptionType string | "'dialogue'" | "'normal'" | "'random'" | "'plus'" | "'check'" | "'RougeLike'"
---@field public RandomOptionNum number
---@field public Options table<number, table>
local TalkOptionData_C = {}

---@param OptionType string | "'dialogue'" | "'normal'" | "'random'" | "'plus'" | "'check'" | "'RougeLike'"
TalkOptionData_C.New = function(OptionType, TalkNodeData, DialogueOptionData, DialogueIterComp)
    ---@type TalkOptionData_C
    local Obj = setmetatable({}, {__index = TalkOptionData_C})
    Obj.OptionType  = OptionType
    Obj.bHasFinalDialogue = DialogueIterComp and DialogueIterComp:HasFinalDialogue()
    Obj.SavedOptions = DialogueIterComp and DialogueIterComp:GetSavedOptions() or {}
    Obj.Options = {}
    Obj.OptionId2Idx = {}
    if not TalkNodeData and not DialogueOptionData then
        DebugPrint("TalkOptionData_C.New:TalkNodeData与DialogueOptionData都为nil")
        return
    end
    local Avatar = GWorld:GetAvatar()
    if OptionType == ETalkOptionType.Dialogue then
        for idx, Option in ipairs(DialogueOptionData) do
            local bIsClientSelected = Obj.bHasFinalDialogue and DialogueIterComp and DialogueIterComp:IsOptionSelected(Option)
            local bIsServerSaved = TalkUtils:IsOptionSavedOnServer(Option)
            local OptionInfo = {
                Index = idx,
                OptionId = Option,
                OptionText = TalkUtils:OptionIdToContent(Option),
                bIsSelected = bIsClientSelected or bIsServerSaved,
            }
            table.insert(Obj.Options, OptionInfo)
            Obj.OptionId2Idx[Option] = idx
        end
    elseif(OptionType == ETalkOptionType.Normal) then
        Obj.RandomOptionNum = TalkNodeData.RandomOptionNum
        for idx,Option in ipairs(TalkNodeData.NormalOptions) do
            local bIsServerSaved = TalkUtils:IsOptionSavedOnServer(Option.OptionText)
            table.insert(Obj.Options,{
                OptionId = tonumber(Option.OptionText),
                OptionText = TalkUtils:OptionIdToContent(Option.OptionText),
                OverrideBlend = Option.OverrideBlend,
                OverrideOutype = Option.OverrideOutype,
                OverrideOutTime = Option.OverrideOutTime,
                bIsSelected =  bIsServerSaved,
                Index = idx,
            })
            Obj.OptionId2Idx[tonumber(Option.OptionText)] = idx
        end
    elseif(OptionType == ETalkOptionType.Random) then
        Obj.RandomOptionNum = TalkNodeData.RandomOptionNum
        for idx,Option in ipairs(TalkNodeData.RandomOptions) do
            local bIsServerSaved = TalkUtils:IsOptionSavedOnServer(Option.OptionText)
            table.insert(Obj.Options,{
                OptionId = tonumber(Option.OptionText),
                OptionText = TalkUtils:OptionIdToContent(Option.OptionText),
                OverrideBlend = Option.OverrideBlend,
                OverrideOutype = Option.OverrideOutype,
                OverrideOutTime = Option.OverrideOutTime,
                bIsSelected =  bIsServerSaved,
                Index = idx,
            })
        end
    elseif(OptionType == ETalkOptionType.Plus) then
        if TalkNodeData then
            Obj.RandomOptionNum = TalkNodeData.RandomOptionNum
            for idx,Option in ipairs(TalkNodeData.PlusOptions) do
                local OptionId = tonumber(Option.OptionText)
                table.insert(Obj.Options,{
                    OptionId = OptionId,
                    OptionText = TalkUtils:OptionIdToContent(Option.OptionText),
                    OverrideBlend = Option.OverrideBlend,
                    OverrideOutype = Option.OverrideOutype,
                    OverrideOutTime = Option.OverrideOutTime,
                    PlusId = Option.PlusId,
                    Index = idx,
                })
                Obj.OptionId2Idx[OptionId] = idx
                if Avatar and Avatar:IsImpressionCheckSuccess(OptionId) then
                    table.insert(Obj.SavedOptions, OptionId)
                end
            end
        elseif DialogueOptionData then
            for idx,Option in ipairs(DialogueOptionData) do
                local DialogueData = DataMgr.Dialogue[Option]
                local OptionInfo = {
                    Index = idx,
                    OptionId = Option,
                    OptionText = TalkUtils:OptionIdToContent(Option),
                    PlusId = DialogueData.ImprPlusId
                }
                table.insert(Obj.Options, OptionInfo)
                Obj.OptionId2Idx[Option] = idx
            end
        end
    elseif(OptionType == ETalkOptionType.Check) then
        if TalkNodeData then
            Obj.RandomOptionNum = TalkNodeData.RandomOptionNum
            for idx,Option in ipairs(TalkNodeData.CheckOptions) do
                local OptionId = tonumber(Option.OptionText)
                table.insert(Obj.Options,{
                    OptionId = OptionId,
                    OptionText = TalkUtils:OptionIdToContent(Option.OptionText),
                    OverrideBlend = Option.OverrideBlend,
                    OverrideOutype = Option.OverrideOutype,
                    OverrideOutTime = Option.OverrideOutTime,
                    CheckId = Option.CheckId,
                    NotCheck = Option.NotCheck, 
                    Index = idx,
                })
                Obj.OptionId2Idx[OptionId] = idx
                if Avatar and Avatar:IsImpressionCheckSuccess(OptionId) then
                    table.insert(Obj.SavedOptions, OptionId)
                end
            end
        elseif DialogueOptionData then
            for idx,Option in ipairs(DialogueOptionData) do
                local DialogueData = DataMgr.Dialogue[Option]
                local OptionInfo = {
                    Index = idx,
                    OptionId = Option,
                    OptionText = TalkUtils:OptionIdToContent(Option),
                    CheckId = DialogueData.ImprCheckId
                }
                table.insert(Obj.Options, OptionInfo)
                Obj.OptionId2Idx[Option] = idx
            end
        end
    elseif (OptionType == ETalkOptionType.RougeLike) then
        for i, Option in ipairs(TalkNodeData.RougeLikeOptions) do
            table.insert(Obj.Options, {
                Index = i,
                OptionId = tonumber(Option.OptionText),
                OptionText = Option.OptionText,
                OverrideBlend = Option.OverrideBlend,
                OverrideOutype = Option.OverrideOutype,
                OverrideOutTime = Option.OverrideOutTime,
            })
        end
    else
        --DebugPrint("Error: Unknown OptionType: ", OptionType)
    end
    --读取OptionTemplate表额外属性
    for _, Option in ipairs(Obj.Options) do
        local OptionId = Option.OptionId
        local Template = TalkUtils:OptionIdToTemplate(OptionId)
        Option.OptionStyle = Template.OptionStyle
        Option.bSaveToServer = Template.bSaveToServer
        Option.bCanReselect = Template.bCanReselect
    end
    return Obj
end

function TalkOptionData_C:GetOptionTexts()
    local OptionTexts = {}
    for _,Option in ipairs(self.Options) do
        table.insert(OptionTexts,Option.OptionText)
    end
    return OptionTexts
end

function TalkOptionData_C:IsShow()
    return self.OptionType ~= ETalkOptionType.Branch
end

return {
    TalkOptionData_C = TalkOptionData_C,
    ETalkOptionType = ETalkOptionType
}
