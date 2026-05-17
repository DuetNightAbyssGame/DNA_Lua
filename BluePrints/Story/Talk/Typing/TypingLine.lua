local FTypingTextBlock = require"Blueprints.Story.Talk.Typing.TypingTextBlock"
local MiscUtils = require "Utils.MiscUtils"

local M = {}

function M:New(Page)
    local TypingLine = {}
    for k, v in pairs(self) do TypingLine[k] = v end
    TypingLine.Page = Page
    TypingLine.Size = UE4.FVector2D(0,0)
    TypingLine.TextSize = UE4.FVector2D(0,0)
    TypingLine.SuperscriptSize = UE4.FVector2D(0,0)
    TypingLine.Blocks = {}
    TypingLine.SuperscriptBlocks = {}
    return TypingLine
end

function M:GetMaxSize() return self.Page:GetMaxSize() end
function M:GetRemainSize() return FVector2D(self:GetMaxSize().X - self.Size.X, self.Page:GetRemainHeight()) end
function M:GetSize() return self.Size end
function M:GetTextSize() return self.TextSize end
function M:GetSuperscriptSize() return self.SuperscriptSize end

function M:GetSuperscriptCount() return #self.SuperscriptBlocks end
function M:GetSuperscript(Num) return self.SuperscriptBlocks[Num] end

function M:CanInsertBlock(Block)
    local RemainSize = self:GetRemainSize()
    local SBlock = Block:GetAttr("superscript_block")
    local MaxTY = math.max(self.TextSize.Y,Block:GetSize().Y)
    local MaxSY = self.SuperscriptSize.Y
    if(SBlock)then
        local SSize = SBlock:GetSize()
        MaxSY = math.max(self.SuperscriptSize.Y,SSize.Y)
    end
    return RemainSize.Y > MaxTY + MaxSY
end

function M:AddBlock(Block, TypingUserWidget)
    if(not self:CanInsertBlock(Block))then
        return Block
    end
    --根据是否需要换行Block会被分成左右两部分
    local LBlock = nil
    local RBlock = nil
    local RemainSize = self:GetRemainSize()
    local BlockSize = Block:GetSize()
    if(RemainSize.X >= BlockSize.X)then
        LBlock = Block
    else
        if(Block:GetAttr("superscript_block"))then
            return Block
        end
        RBlock = Block
        local BlockType = Block:GetType()
        if(BlockType == "img")then
            --
        elseif(BlockType == "text")then
            if(#Block.Text == 0 or BlockSize.X <= 0)then
                print(_G.LogTag,"Block 内容为空或大小为0，被丢弃。", "Block 大小：", BlockSize, "Block 内容：", Block:GetRichText())
                return
            end
            local LText,RText = self:SplitText(Block,RemainSize, TypingUserWidget)
            LText = string.sub(LText,1,#LText - 1)
            LBlock = FTypingTextBlock:New(LText,Block.RichTag,Block.Attrs)
            local LTextSize = TypingUserWidget.CalcRichTextBlockSize(LBlock:GetRichText())
            LBlock:SetSize(LTextSize)
            if(RText and RText ~= Block.Text)then
                --Block被切分过
                RBlock = FTypingTextBlock:New(RText,Block.RichTag,Block.Attrs)
                local RTextSize = TypingUserWidget.CalcRichTextBlockSize(RBlock:GetRichText())
                RBlock:SetSize(RTextSize)
            elseif(LText and LText == Block.Text)then
                RBlock = nil
            end
        end
    end
    if(LBlock)then
        local LSize = LBlock:GetSize()
        self.TextSize.X = self.TextSize.X + LSize.X
        self.TextSize.Y = math.max(self.TextSize.Y,LSize.Y)
        table.insert(self.Blocks,LBlock)
        local SuperscriptBlock = Block:GetAttr("superscript_block") --上标
        LBlock:SetAttr("superscript_block",nil)
        if(SuperscriptBlock)then
            local SSize = SuperscriptBlock:GetSize()
            self.SuperscriptSize.Y = math.max(self.SuperscriptSize.Y,SSize.Y)
            SuperscriptBlock.RelativePosX = self.TextSize.X - LSize.X / 2 - SSize.X / 2
            table.insert(self.SuperscriptBlocks,SuperscriptBlock)
        end
        self.Size.X = self.TextSize.X
        self.Size.Y = self.TextSize.Y + self.SuperscriptSize.Y
    end
    return RBlock
end

function M:SplitText(Block,RemainSize, TypingUserWidget)
    local Words = Utils.Split(Block.Text," ")
    local RemainWidth = RemainSize.X
    local LText = ""
    local RText = nil
    local SpaceWidth = TypingUserWidget.CalcRichTextBlockSize("<" .. Block.RichTag .. "> </>").X
    for _, Word in ipairs(Words) do
        local WordWidth = TypingUserWidget.CalcRichTextBlockSize("<" .. Block.RichTag .. ">" .. Word .. "</>").X
        if(RemainWidth >= WordWidth)then
            RemainWidth = RemainWidth - WordWidth - SpaceWidth
            LText = LText .. Word .. " "
        else
            if(not MiscUtils.IsSingleByteWord(Word) and (
                CommonConst.SystemLanguage == CommonConst.SystemLanguages.CN or 
                CommonConst.SystemLanguage == CommonConst.SystemLanguages.JP or
                CommonConst.SystemLanguage == CommonConst.SystemLanguages.TC))then
                --切割非英文单词
                local WordLen = UE4.UKismetStringLibrary.Len(Word)
                local Left = 0
                local Mid = 0
                local Right = WordLen
                local LWord = ""
                while Left < Right do
                    local t = math.floor((Right-Left) / 2) + Left
                    if(t == Mid)then
                        break
                    end
                    Mid = t
                    --使用UE的方法切割字符串，防止乱码
                    LWord = UE4.UKismetStringLibrary.GetSubstring(Word,0,Mid)
                    local LWordWidth = TypingUserWidget.CalcRichTextBlockSize("<" .. Block.RichTag .. ">" .. LWord .. "</>").X
                    if(RemainWidth > LWordWidth)then
                        Left = Mid
                    else
                        Right = Mid
                    end
                end
                LText = LText .. LWord
                RText = string.sub(Block.Text,#LText + 1,#Block.Text)
                --分配标点符号，处理标点符号换行
                LText,RText = self:AssignPunctuation(LText,RText)
                --Split会删除空格，补一个空格
                LText = LText .. " "
                if(RText == "")then
                    RText = nil
                end
            else
                RText = string.sub(Block.Text,#LText + 1,#Block.Text)
            end
            break
        end
    end

    return LText,RText
end

function M:AssignPunctuation(LText,RText)
    local RLen = UE4.UKismetStringLibrary.Len(RText)
    if(RLen <= 0 )then
        return LText,RText
    end
    local LLen = UE4.UKismetStringLibrary.Len(LText)
    local LLastChar = UE4.UKismetStringLibrary.GetSubstring(LText,LLen - 1,1)
    if(string.find("([{〈《「『【〔〖（“‘",LLastChar,1,true)) then
        --如果左侧字符串的尾字符是开括号则将其移动到下一行
        LText = UE4.UKismetStringLibrary.GetSubstring(LText,0,LLen - 1)
        RText = LLastChar .. RText
        return LText,RText
    end
    local RFirtChar = UE4.UKismetStringLibrary.GetSubstring(RText,0,1)
    ---不换行标点
    local NoBreakLinePunctuations = ",.?;~!%，、。；：？！·)]}〉》」』】〕〗）”’"
    ---破折号、省略号
    local EllipsisAndDash = "—…"
    if( string.find(EllipsisAndDash,RFirtChar,1,true))then
        --如果右侧字符串首个字符是破折号或省略号，在左侧字符串倒序的首个非标点符号字符处截断并拼接到下一行行首
        for i = LLen-1,1,-1 do
            local LChar = UE4.UKismetStringLibrary.GetSubstring(LText,i,1)
            if(not string.find(EllipsisAndDash,LChar,1,true)
            and not string.find(NoBreakLinePunctuations,LChar,1,true))then
                RText = UE4.UKismetStringLibrary.GetSubstring(LText,i,LLen) .. RText
                LText = UE4.UKismetStringLibrary.GetSubstring(LText,0,i)
                break
            end
        end
    else
        local RPunctuations = ""
        local RChar = RFirtChar
        local RPunctuationsEnd = 0
        repeat
            if(RChar ~= "" and string.find(NoBreakLinePunctuations,RChar,1,true))then
                RPunctuationsEnd = RPunctuationsEnd + 1
                RPunctuations = RPunctuations .. RChar
                if(RPunctuationsEnd > 2 )then
                    break
                end
                RChar = UE4.UKismetStringLibrary.GetSubstring(RText,RPunctuationsEnd,1)
            else
                break
            end
        until(RPunctuationsEnd > RLen)
        if(RPunctuationsEnd > 2 )then
            --如果右侧字符串有连续三个不换行标点，在左侧字符串倒序的首个非不换行标点字符处截断并拼接到下一行行首
            local LLen = UE4.UKismetStringLibrary.Len(LText)
            for i = LLen,1,-1 do
                local LChar = UE4.UKismetStringLibrary.GetSubstring(LText,i,1)
                if(not string.find(NoBreakLinePunctuations,LChar,1,true))then
                    RText = UE4.UKismetStringLibrary.GetSubstring(LText,i,LLen) .. RText
                    LText = UE4.UKismetStringLibrary.GetSubstring(LText,0,i)
                    return LText,RText
                end
            end
        end
        --如果右侧字符串有连续两个或以内不换行标点，将该标点拼接到左侧字符串
        LText = LText .. RPunctuations
        RText = UE4.UKismetStringLibrary.GetSubstring(RText,RPunctuationsEnd,RLen)
    end
    return LText,RText
end

function M:GetRichText()
    local Text = ""
    for _, Block in ipairs(self.Blocks) do
        Text = Text .. Block:GetRichText()
    end
    return Text
end

return M