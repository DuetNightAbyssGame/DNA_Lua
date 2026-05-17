---@alias FFlowDialogueFinishCallback fun(DialogueId:number)

---@class FFlowDialogue
---@field DialogueId number|nil
---@field EnableSkip boolean|nil
---@field bForbiddenDSL boolean
---@field bWaitAsyncTag boolean
---@field bAutoToNext boolean|nil
---@field bUseWaitClickTime boolean|nil
---@field WaitClickTime number|nil
---@field bBlack boolean|nil
---@field OnDialogueFinish FFlowDialogueFinishCallback|nil
---@field OnForceCompleteDialogue FFlowDialogueFinishCallback|nil
local FFlowDialogue = {}

---@param DialogueData table|nil
---@param DialogueSetting table|nil
---@param DialogueSection table|nil
---@return FFlowDialogue
function FFlowDialogue.New(DialogueData, DialogueSetting, DialogueSection)
    local function GetRawData(Key)
        if DialogueSection and DialogueSection[Key] ~= nil then
            return DialogueSection[Key]
        end
        if DialogueData and DialogueData[Key] ~= nil then
            return DialogueData[Key]
        end
        if DialogueSetting and DialogueSetting[Key] ~= nil then
            return DialogueSetting[Key]
        end
        return FFlowDialogue[Key]
    end

    local Obj = setmetatable({}, {
        __index = function(t, Key)
            local Value = GetRawData(Key)
            if Value then
                rawset(t, Key, Value)
            end
            return Value
        end
    })

    Obj.bForbiddenDSL = false
    Obj.bWaitAsyncTag = false
    if DialogueSection then
        Obj.EnableSkip = DialogueSection.EnableSkip
    else
        Obj.EnableSkip = true
    end
    return Obj
end

---@param Func FFlowDialogueFinishCallback
function FFlowDialogue:BindOnDialogueFinish(Func)
    self.OnDialogueFinish = Func
end

---@param ... any
function FFlowDialogue:ExecuteOnDialogueFinish(...)
    if self.OnDialogueFinish then
        self.OnDialogueFinish(...)
    end
end

---@param Func FFlowDialogueFinishCallback
function FFlowDialogue:BindOnForceCompleteDialogue(Func)
    self.OnForceCompleteDialogue = Func
end

---@param ... any
function FFlowDialogue:ExecuteOnForceCompleteDialogue(...)
    if self.OnForceCompleteDialogue then
        self.OnForceCompleteDialogue(...)
    end
end

---@return boolean
function FFlowDialogue:IsForbiddenDSL()
    return self.bForbiddenDSL
end

---@param bValue boolean
function FFlowDialogue:SetForbiddenDSL(bValue)
    self.bForbiddenDSL = bValue
end

---@return boolean
function FFlowDialogue:IsWaitAsyncTag()
    return self.bWaitAsyncTag
end

---@param bValue boolean
function FFlowDialogue:SetWaitAsyncTag(bValue)
    self.bWaitAsyncTag = bValue
end

function FFlowDialogue:SetAutoToNext()
    self.bAutoToNext = true
end

---@return boolean|nil
function FFlowDialogue:NeedAutoToNext()
    return self.bAutoToNext
end

---@param bValue boolean
function FFlowDialogue:SetEnableSkip(bValue)
    self.EnableSkip = bValue
end

function FFlowDialogue:SetOverrideDuration()
    self.DisableDuration = true
end

return {
    FFlowDialogue = FFlowDialogue
}
