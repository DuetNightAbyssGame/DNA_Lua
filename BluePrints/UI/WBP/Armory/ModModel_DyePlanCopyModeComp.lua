local json = require "rapidjson"

---@type ModModel
local Component = {}

local SKIN_VALIDATORS = {
    Char   = function(id) return DataMgr.Skin[id] end,
    Weapon = function(id) return DataMgr.WeaponSkin[id] and (not DataMgr.Weapon[id]) end,
    Hair   = function(id) return DataMgr.Hair[id] end,
}

--region 染色方案分享到聊天频道相关
function Component:CacheDyePlanInfoCopyed(DyePlanInfo)
    self.DyePlanInfoCopyed = {
        MsgCopyed = string.format(GText("UI_Chat_DyeSuitFormat"),DyePlanInfo.TargetName),
        TargetName = DyePlanInfo.TargetName,
        PlanName = DyePlanInfo.PlanName,
        SkinType = DyePlanInfo.SkinType,
        SkinId = DyePlanInfo.SkinId,
        CharId = DyePlanInfo.CharId,
        colorStrings = {}
    }
    
    if DyePlanInfo.Colors then
        for i, colorId in ipairs(DyePlanInfo.Colors) do
            table.insert(self.DyePlanInfoCopyed.colorStrings, tostring(colorId or 0))
        end
    end
    ULowEntryExtendedStandardLibrary.ClipboardSet(self.DyePlanInfoCopyed.MsgCopyed)
end

function Component:GetDyePlanInfoCopyed()
    return self.DyePlanInfoCopyed
end

---检测当前消息是否为染色分享信息
function Component:IsDyeShareInfoMsg(InMsgStr)
    local DyePlanInfoCopyed = self:GetDyePlanInfoCopyed()
    if not DyePlanInfoCopyed then return false end
    if InMsgStr ~= DyePlanInfoCopyed.MsgCopyed then
        return false
    end
    return true
end

function Component:GenerateDyeShareMsg()
    local DyePlanInfoCopyed = self:GetDyePlanInfoCopyed()
    if not DyePlanInfoCopyed then return nil end
    
    -- 检查是否有有效的染色信息
    if not DyePlanInfoCopyed.SkinType or not DyePlanInfoCopyed.SkinId then
        return nil
    end
    
    local Table = {
        TargetName = DyePlanInfoCopyed.TargetName,
        PlanName = DyePlanInfoCopyed.PlanName,
        SkinType = DyePlanInfoCopyed.SkinType,
        SkinId = DyePlanInfoCopyed.SkinId,
        CharId = DyePlanInfoCopyed.CharId,
        Colors = DyePlanInfoCopyed.colorStrings or {}
    }
    
    return ChatCommon.DyePlanCopyHeader..json.encode(Table)
end
--endregion

--region 社区配色码相关
-- 将数字转换为Base36字符串（0-9, A-Z）
function Component:NumberToBase36(num, minLength)
    if not num or num < 0 then
        return string.rep("0", minLength or 1)
    end
    
    local chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local result = ""
    
    if num == 0 then
        result = "0"
    else
        while num > 0 do
            local remainder = num % 36
            result = string.sub(chars, remainder + 1, remainder + 1) .. result
            num = math.floor(num / 36)
        end
    end
    
    -- 补齐到最小长度
    if minLength and string.len(result) < minLength then
        result = string.rep("0", minLength - string.len(result)) .. result
    end
    
    return result
end

-- 将Base36字符串转换为数字
function Component:Base36ToNumber(str)
    if not str or str == "" then
        return 0
    end
    
    local chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local result = 0
    local base = 1
    
    for i = string.len(str), 1, -1 do
        local char = string.sub(str, i, i)
        local value = string.find(chars, char) - 1
        if value < 0 then
            value = 0
        end
        result = result + value * base
        base = base * 36
    end
    
    return result
end

function Component:GenerateShareCommunityCopyCode(DyePlanInfo)
    if not DyePlanInfo then
        return ""
    end
    
    local code = ""
    
    -- 编码SkinType (1位): C=Char, W=Weapon
    if DyePlanInfo.SkinType == "Char" then
        code = code .. "C"
    elseif DyePlanInfo.SkinType == "Hair" then
        code = code .. "H"
    else
        code = code .. "W"
    end
    
    -- 编码SkinId (10位Base36)
    local skinId = tonumber(DyePlanInfo.SkinId) or 0
    code = code .. self:NumberToBase36(skinId, 10)
    
    -- 编码Colors数组 (每个颜色ID用2位Base36)
    if DyePlanInfo.Colors then
        for i = 1, #DyePlanInfo.Colors do
            local colorId = tonumber(DyePlanInfo.Colors[i]) or 0
            code = code .. self:NumberToBase36(colorId, 2)
        end
    end
    
    return code
end

function Component:AnalysisShareCommunityCopyCode(CommunityCopyCode)
    if not CommunityCopyCode or CommunityCopyCode == "" then
        return nil
    end
    
    local code = string.upper(CommunityCopyCode)
    local codeLength = string.len(code)
    
    -- 检测位数：最少11位(1位SkinType + 10位SkinId)，颜色部分必须是偶数位
    if codeLength < 11 then
        return nil -- 位数不足
    end
    
    local colorPartLength = codeLength - 11
    if colorPartLength % 2 ~= 0 then
        return nil -- 颜色部分位数不正确
    end
    
    local pos = 1
    local DyePlanInfo = {}
    
    -- 解码SkinType (1位)
    if pos <= string.len(code) then
        local skinTypeChar = string.sub(code, pos, pos)
        if skinTypeChar == "C" then
            DyePlanInfo.SkinType = "Char"
        elseif skinTypeChar == "W" then
            DyePlanInfo.SkinType = "Weapon"
        elseif skinTypeChar == "H" then
            DyePlanInfo.SkinType = "Hair"
        else
            return nil -- 无效的配色码
        end
        pos = pos + 1
    else
        return nil
    end
    
    -- 解码SkinId (10位)
    if pos + 9 > string.len(code) then
        return nil
    end

    local skinIdStr = string.sub(code, pos, pos + 9)
    DyePlanInfo.SkinId = self:Base36ToNumber(skinIdStr)

    local Validator = SKIN_VALIDATORS[DyePlanInfo.SkinType]
    if not (Validator and Validator(DyePlanInfo.SkinId)) then
        return nil -- 无效的类型或校验未通过
    end
    pos = pos + 10
    
    -- 解码Colors数组 (每个颜色ID用2位)
    DyePlanInfo.Colors = {}
    while pos + 1 <= string.len(code) do
        local colorIdStr = string.sub(code, pos, pos + 1)
        local colorId = self:Base36ToNumber(colorIdStr)
        table.insert(DyePlanInfo.Colors, colorId)
        pos = pos + 2
    end
    
    return DyePlanInfo
end

--endregion
return Component