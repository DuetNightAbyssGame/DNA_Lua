local ok, CommonConst = pcall(require, "CommonConst")
if not ok then
    CommonConst = { SystemLanguage = "TextMapContent" ,SystemLanguages = {Default = "TextMapContent"}}
end

local KeyboardText = setmetatable({}, {
    __index = function (t, key)
        local tbl = DataMgr["KeyboardText_" .. CommonConst.SystemLanguage]
		if not tbl then
			tbl = DataMgr["KeyboardText_"..CommonConst.SystemLanguages.Default]
		end
		return tbl[key]
    end,
    __pairs = function(t)
        local realTbl = DataMgr["KeyboardText_" .. CommonConst.SystemLanguage]
		if not realTbl then
			realTbl = DataMgr["KeyboardText_"..CommonConst.SystemLanguages.Default]
		end
        local mt = getmetatable(realTbl)
        if mt and mt.__pairs then
            return mt.__pairs(realTbl)
        else
            return next, realTbl, nil
        end
    end,
})

return KeyboardText