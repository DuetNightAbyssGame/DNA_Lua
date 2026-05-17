local FTypingPage = require"Blueprints.Story.Talk.Typing.TypingPage"

local M = {}

function M:New(Size)
    local TypingBook = {}
    for k, v in pairs(self) do TypingBook[k] = v end
    TypingBook.Size = Size
    TypingBook.Pages = {}
    return TypingBook
end

function M:GetSize() return self.Size end

function M:AddBlock(Block, TypingUserWidget)
    local Page = self.Pages[#self.Pages]
    if Page then
        Block = Page:AddBlock(Block, TypingUserWidget)
        if Block then
            Page:RemoveEmptyLinesAtLast()
        end
    end
    while Block do
        Page = FTypingPage:New(self)
        local OldBlock = Block
        Block = Page:AddBlock(Block, TypingUserWidget)
        if OldBlock == Block then
            print(_G.LogTag,"Block 内容超出页大小，被丢弃。", "Block 大小：", Block:GetSize(), "Block 内容：", Block:GetRichText())
            break
        end
        table.insert(self.Pages, Page)
    end
end

function M:GetLine(Num)
    for _, Page in ipairs(self.Pages) do
        local LineCount = Page:GetLineCount()
        if(Num - LineCount < 0)then
            return Page:GetLine(Num)
        end
        Num = Num - LineCount
    end
end

function M:GetPage(Num)
    return self.Pages[Num]
end


function M:GetPageCount()
    return #self.Pages
end

function M:GetRichText()
    local Text = ""
    for Index, Page in ipairs(self.Pages) do
        Text = Text ..  "#Page " .. Index .. "\n" .. Page:GetRichText() .. "\n"
    end
    return Text
end

function M:GetFullText()
    local Text = ""
    for Index, Page in ipairs(self.Pages) do
        Text = Text ..  "#Page " .. Index .. "\n" .. Page:GetFullText() .. "\n"
    end
    return Text
end

return M
