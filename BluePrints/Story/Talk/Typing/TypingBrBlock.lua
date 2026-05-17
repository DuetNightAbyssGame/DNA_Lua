local FTypingBlock = require "Blueprints.Story.Talk.Typing.TypingBlock"

local M = {}

--此类仅用于换行
function M:New()
    local TypingBrBlock = {}
    for k, v in pairs(self) do TypingBrBlock[k] = v end
    setmetatable(TypingBrBlock, {__index = FTypingBlock})
    TypingBrBlock.RichTag = "br"
    TypingBrBlock.Size = nil
    return TypingBrBlock
end

function M:GetRichText()
    return "<br/>"
end

function M:GetType()
    return "br"
end

function M:GetFullText()
    return "<br/>"
end

return M
