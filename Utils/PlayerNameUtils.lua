local TimerMgr = require "BluePrints.Common.TimerMgr"

local PlayerNameUtils = {}

local DoubleByteRanges = {
    {0xC2B7, 0xC2B7},  -- ·
}
local CjkUTFRanges = {
    {0xE280A6, 0xE280A6},  -- ……
    {0xE28093, 0xE2809D},  -- 一些标点符号
    {0xE38081, 0xE38095},  -- 一些标点符号
    {0xE4B880, 0xEFBC9F},  -- 中文字符范围
    {0xEAB080, 0xED9EAF},  -- 韩文字符范围
    {0xE38080, 0xE38FBF}   -- 日文字符范围
}

function PlayerNameUtils.CheckIsAllSpace(Name)
    return string.match(Name, "^%s*$")
end

function PlayerNameUtils.ReplaceMultiSpaceInName(Name)
    return string.gsub(Name, "%s%s+", " ")
end

--返回值 ErrorType为-2：含有不合法字符
function PlayerNameUtils.CheckNameLegal(NewName,MaxNum)
    --默认12
    MaxNum= MaxNum or 12
    local IllegalRange = {}
    local SpaceRange = {}
    local RealName = NewName
    local NameLength = 0
    local ErrorType = 0
    local i = 1
    while true do
        local CurByte = string.byte(NewName, i)
        local ByteNum = 1
        if CurByte >= 240 then
            ByteNum = 4
            table.insert(IllegalRange, {i, i+3})
        elseif CurByte >= 224 then
            if not PlayerNameUtils.CheckCharInAnyRange(NewName, i, CjkUTFRanges) then
                table.insert(IllegalRange, {i, i+2})
            end
            ByteNum = 3
        elseif CurByte >= 192 then
            ByteNum = 2
            if not PlayerNameUtils.CheckDoubleCharInAnyRange(NewName, i, DoubleByteRanges) then
                table.insert(IllegalRange, {i, i+1})
            end
        else
            if CurByte < 32 or CurByte > 126 then
                table.insert(IllegalRange, {i, i})
            end
            ByteNum = 1
        end

        NameLength = NameLength + 1
        if NameLength > MaxNum then
            RealName = string.sub(NewName, 1, i - 1)
            break
        end
        i = i + ByteNum
        if i > #NewName then
            break
        end
    end
    if #IllegalRange > 0 then
        ErrorType = -2
    end

    return NameLength, RealName, IllegalRange, ErrorType
end

function PlayerNameUtils.GetWordLength(WordFirstByte)
    if WordFirstByte >= 240 then
        return 4
    elseif WordFirstByte >= 224 then
        return 3
    elseif WordFirstByte >= 192 then
        return 2
    else
        return 1
    end
    return 0
end

function PlayerNameUtils.CheckDoubleCharInAnyRange(NewName, i, AllRange)
    local CharByte1 = string.byte(NewName, i)
    local CharByte2 = string.byte(NewName, i + 1)
    for i, Range in pairs(AllRange) do
        if PlayerNameUtils.ContainsDoubleChar(CharByte1, CharByte2, Range) then
            return true
        end
    end
    return false
end

function PlayerNameUtils.ContainsDoubleChar(CharByte1, CharByte2, Range)
    local ByteNum = CharByte1*16^2 + CharByte2
    -- 检查字符是否在范围内
    if ByteNum >= Range[1] and ByteNum <= Range[2] then
        return true
    end

    return false
end

function PlayerNameUtils.CheckCharInAnyRange(NewName, i, AllRange)
    local CharByte1 = string.byte(NewName, i)
    local CharByte2 = string.byte(NewName, i + 1)
    local CharByte3 = string.byte(NewName, i + 2)
    for i, Range in pairs(AllRange) do
        if PlayerNameUtils.ContainsCJK(CharByte1, CharByte2, CharByte3, Range) then
            return true
        end
    end
    return false
end

function PlayerNameUtils.ContainsCJK(CharByte1, CharByte2, CharByte3, Range)
    local ByteNum = CharByte1*16^4 + CharByte2*16^2 + CharByte3
    -- 检查字符是否在范围内
    if ByteNum >= Range[1] and ByteNum <= Range[2] then
        return true
    end

    return false
end

function PlayerNameUtils.HighLightWord(Str, WordStart, WordEnd)
    local InsertStrStart = "<Warning>"
    local InsertStrEnd = "</>"
    local first = string.sub(Str, 1, WordStart - 1)
    local Middle = string.sub(Str, WordStart, WordEnd)
    local last = string.sub(Str, WordEnd+1, -1)
    return string.format("%s%s%s%s%s",first,InsertStrStart,Middle,InsertStrEnd,last)
end

function PlayerNameUtils.HighLightIllegal(Name, IllegalRange)
    local InsertStrStart = "<Warning>"
    local InsertStrEnd = "</>"
    local Res = Name
    for i, v in pairs(IllegalRange) do
        local ExtraLength = 12 * (i - 1)
        Res = PlayerNameUtils.HighLightWord(Res, v[1] + ExtraLength, v[2] + ExtraLength)
    end
    return Res
end

function PlayerNameUtils.DeleteHeadAndTailSpace(Name)
    -- local StartIdx = 1
    -- for i = 1, #Name do
    --     print(_G.LogTag,"LXZ DeleteHeadAndTailSpace111  ", i)
    --     local CurByte = string.byte(Name, i)
    --     if CurByte ~= 20 then
    --         StartIdx = i
    --         break
    --     end
    -- end

    -- local EndIdx = #Name
    -- for i = #Name, 1 do
        
    --     local CurByte = string.byte(Name, i)
    --     print(_G.LogTag,"LXZ DeleteHeadAndTailSpace222  ", i, CurByte)
    --     if CurByte ~= 20 then
    --         EndIdx = i
    --         break
    --     end
    -- end
    -- if EndIdx<=StartIdx then
    --     return Name
    -- else
    --     return string.sub(Name, StartIdx, EndIdx)
    -- end
    return string.gsub(Name, "^%s*(.-)%s*$", "%1")
end

return PlayerNameUtils