local StringUtils = {}
 
function StringUtils.Split(Str, Pat)
    local t = {} 
    local fpat = "(.-)" .. Pat
    local last_end = 1
    local s, e, cap = string.find(Str, fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(t,cap)
        end
        last_end = e+1
        s, e, cap = string.find(Str, fpat, last_end)
    end
    if last_end <= string.len(Str) then
        cap = string.sub(Str, last_end)
        table.insert(t, cap)
    end
    return t
end

function StringUtils.Utf8ToTable(Str)
    local t = {}
    for ch,_ in string.gmatch(Str, utf8.charpattern) do
        table.insert(t, ch)
    end
    return t
end

--CJK字符集范围
local CJKUtf8Ranges = {
    {0xE280A6, 0xE280A6},  -- ……
    {0xE28093, 0xE2809D},  -- 一些标点符号
    {0xE38081, 0xE38095},  -- 一些标点符号
    {0xE4B880, 0xEFBC9F},  -- 中文字符范围
    {0xEAB080, 0xED9EAF},  -- 韩文字符范围
    {0xE38080, 0xE38FBF}   -- 日文字符范围
}
-- 有效的双字节字符
local DoubleByteRanges = {
    {0xC2B7, 0xC2B7},  -- ·
}
function StringUtils.CheckUtf8StrCJKLegal(Str)
    local IllegalRange = {}
    local Index = 1
    local CheckCharInRange = function(Ch, ByteCount, CharsRange)
        local UtfCh = 0
        for i=1, ByteCount do
            local ChByte = string.byte(Ch, i)
            UtfCh = UtfCh+ChByte*16^(2^(3-i))
        end
        for _, Range in ipairs(CharsRange) do
            if UtfCh >=Range[1] and UtfCh <= Range[2] then
                return true
            end
        end
        return false
    end
    for Ch, _ in string.gmatch(Str, utf8.charpattern) do
        local ChBytes = {string.byte(Ch)}
        local NewIndex = Index
        if ChBytes[1] >= 0xf0 then --四个字节的字符，直接不合法
            NewIndex = Index + 3
            table.insert(IllegalRange, {Index,NewIndex})
        elseif ChBytes[1] >= 0xe0 then --三个字节的字符，看一下在不在CJK字符范围
            NewIndex = Index + 2     
            if not CheckCharInRange(Ch, 3, CJKUtf8Ranges) then
                table.insert(IllegalRange, {Index,NewIndex})
            end
        elseif ChBytes[1] >= 0xc0 then --两个字节的字符,看一下在不在有效双字节字符范围
            NewIndex = Index + 1
            if not CheckCharInRange(Ch, 2, DoubleByteRanges) then
                table.insert(IllegalRange, {Index,NewIndex})
            end
        elseif ChBytes[1] <0x20 or ChBytes[1] >0x7e then --超过Ascii有效字符范围，直接不合法
            table.insert(IllegalRange, {Index,Index})
        end
        Index = NewIndex+1
    end
    local LegalRes = (#IllegalRange == 0)
    return LegalRes, IllegalRange
end

return StringUtils