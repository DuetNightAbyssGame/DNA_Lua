local StringUtils = require "Utils.StringUtils"

local SkillUtils = {}

function SkillUtils.NeedSplitEval(Str, Rep)
    local GText = GText
    local ReStr = '[' .. Rep .. ']' .. '([^' .. Rep .. ']*)' .. '[' .. Rep .. ']'
    string.gsub(Str, ReStr, function(W)
        if W == '' then
            W = "''"
        end
        local LuaStr = 'return ' .. W
        local load_fun = _G.loadstring or load
        local f = load_fun(LuaStr)
        -- PrintTable({LuaStr=LuaStr})
        return ""
    end)
    -- return true

    -- local ReStr = '['..Rep..']'..'([^'..Rep..']*)'..'['..Rep..']'
    local _NeedSplitEval = string.match(Str, ReStr)
    return _NeedSplitEval
end

function SkillUtils.SplitEval(Str, Rep, Args)
    local GText = GText
    local ReStr = '[' .. Rep .. ']' .. '([^' .. Rep .. ']*)' .. '[' .. Rep .. ']'
    Str = string.gsub(Str, ReStr, function(W)
        if W == '' then
            W = "''"
        end
        local LuaStr = 'return ' .. W

        if not Args then
            Args = {}
        end
		Args.GText = GText or function( ... ) return "" end
        Args._G = _G
        Args.SkillUtils = SkillUtils
        setmetatable(Args, { __index = _G })
        local load_fun = _G.loadstring or load
        local f = load_fun(LuaStr, LuaStr, 't', Args)

        -- print(LogTag, "LuaStr",LuaStr)
        local Ret = f()
        local RetNum = tonumber(Ret)
		if RetNum then -- 如果Ret能被转为number(有可能是拆分出的string)
            if Args.ImpactAttrs and next(Args.ImpactAttrs) then
                if CommonUtils.HasValue(Args.ImpactAttrs, "SkillEfficiency") and CommonUtils.HasValue(Args.ImpactAttrs, "SkillSustain") then
                    Ret = SkillUtils.ApplySkillSustainAndEfficiency(RetNum, Args.Attrs["SkillSustain"], Args.Attrs["SkillEfficiency"])
                elseif CommonUtils.HasValue(Args.ImpactAttrs, "SkillEfficiency") then
                    Ret = SkillUtils.ApplySkillEfficiencyWithLimit(RetNum, Args.Attrs["SkillEfficiency"])
                elseif CommonUtils.HasValue(Args.ImpactAttrs, "SkillSustain") then
                    Ret = SkillUtils.ApplySkillSustain(RetNum, Args.Attrs["SkillSustain"])
                elseif CommonUtils.HasValue(Args.ImpactAttrs, "SkillIntensity") then
                    Ret = SkillUtils.ApplySkillIntensity(RetNum, Args.Attrs["SkillIntensity"])
                elseif CommonUtils.HasValue(Args.ImpactAttrs, "SkillRange") then
                    Ret = SkillUtils.ApplySkillRange(RetNum, Args.Attrs["SkillRange"])
                end
            end
        end
        return tostring(Ret)
    end)
    return Str
end

function SkillUtils.CalcSkillDescValue(Desc, SkillLevel, Args)
    local Str = SkillUtils.CalcSkillDesc(Desc, SkillLevel, Args, true)
    local NewStr = tonumber(Str)
    if NewStr then
        return NewStr
    end
    return Str
end

function SkillUtils.CalcSkillDesc(Desc, SkillLevel, Args, ...)
    -- print('原字符串   : '..Desc)
    -- Desc = string.gsub(Desc, '#', 'DataMgr.')
    local NewDesc = string.gsub(Desc, '#', 'SkillUtils.NewGrowDesc(' .. SkillLevel .. ').')
    local IgnoreFranch = ...
    if not IgnoreFranch then
        local index = string.find(NewDesc, '%%', 1)
        if index and CommonConst.SystemLanguage == CommonConst.SystemLanguages.FR then
            NewDesc = string.gsub(NewDesc, "%%","\u{00A0}%%")
        end 
    end

    -- print('新字符串   : '..NewDesc)
    local ok, ret = pcall(SkillUtils.SplitEval, NewDesc, '$', Args)
    if not ok then
        if GWorld.GameInstance then
            Battle(GWorld.GameInstance):ShowBattleError("识别技能描述【" .. tostring(Desc) .. "】失败!实际描述为【" .. tostring(NewDesc) .. "】请策划检查表格填写\nError:" .. tostring(ret))
        end
        return NewDesc
    end
    if not IgnoreFranch then
        ret = CommonUtils.FormatNumInFrench(ret)
    end

    return ret
end

-- 根据SkillId， 获取该技能等级下的所有描述， 以键值对方式给出
---@alias SkillDescInfo {Desc:string, Value:number, Hint:string}
---@return table<SkillDescInfo>
function SkillUtils.GetSkillAllDesc(SkillId, SkillLevel, SkillGrade, Avatar, Target)
    SkillGrade = SkillGrade or 0
    local Result = {}
    local Attrs
    local MeleeWeapon, RangedWeapon = nil, nil
    if Avatar and Avatar.MeleeWeapon then
        MeleeWeapon = Avatar.Weapons[Avatar.MeleeWeapon]
    end
    if Avatar and Avatar.RangedWeapon then
        RangedWeapon = Avatar.Weapons[Avatar.RangedWeapon]
    end
    local ExtraInfo = { MeleeWeapon = MeleeWeapon, RangedWeapon = RangedWeapon }
    if Avatar and Target then
        Attrs = Target:DumpDefaultBattleAttr(Avatar, ExtraInfo).TotalValues
    end
    if DataMgr.Skill[SkillId] and DataMgr.Skill[SkillId][SkillLevel] then
        local SkillData = DataMgr.Skill[SkillId][SkillLevel][SkillGrade]
        if SkillData and SkillData.SkillDescKeys then
            for Index, DescKey in pairs(SkillData.SkillDescKeys) do
                local AttrConfigIdList = (SkillData.SkillDescHints and SkillData.SkillDescHints[Index]) or {}
                local AttrDesc = GText(DescKey)
                local Args = {
                    Attrs = Attrs,
                    ImpactAttrs = AttrConfigIdList,
                }
                local ValueStr = SkillUtils.CalcSkillDesc(SkillData.SkillDescValues[Index], SkillLevel, Args, true)
                ValueStr = SkillUtils.FormatDescValue2(ValueStr)
                local AttrHint = ""
                local Caesura = GText("Caesura")
                for _, AttrConfigId in ipairs(AttrConfigIdList) do
                    local AttrConfig = DataMgr.AttrConfig[AttrConfigId]
                    if AttrConfig then
                        local ConfigName = GText(AttrConfig.Name)
                        if AttrHint == "" then
                            AttrHint = ConfigName
                        else
                            AttrHint = string.format("%s" .. Caesura .. "%s", AttrHint, ConfigName)
                        end
                    end
                end

                table.insert(Result, {Index = Index, Desc = AttrDesc, Value = ValueStr, Hint = AttrHint })
            end
        end
    end
    table.sort(Result,function(a, b)
        return a.Index < b.Index
    end)
    return Result
end

-- 根据SkillId， 获取该技能等级下的SkillDesc描述
---@return string
function SkillUtils.GetSkillDesc(SkillId, SkillLevel, ExpectLevel, SkillGrade)
    local Desc
    SkillGrade = SkillGrade or 0
    if DataMgr.Skill[SkillId] and DataMgr.Skill[SkillId][SkillLevel] then
        local SkillData = DataMgr.Skill[SkillId][SkillLevel][SkillGrade]
        if SkillData and SkillData.SkillDesc then
            Desc = SkillData.SkillDesc and GText(SkillData.SkillDesc) or ""
            if not SkillData.SkillDesc then return Desc end
            ExpectLevel = ExpectLevel == nil and SkillLevel or ExpectLevel
            local CastTo
            if SkillData.SkillDescValues then
                for i, DescValue in pairs(SkillData.SkillDescValues) do
                    Desc, CastTo = SkillUtils.ReplaceAndChekDescValueCast(Desc, i)
                    local Percent = string.match(DescValue, "%%") or ""
           
                    local ValStr = ""
                    local function SkillGrowDesc(DescValue, BaseLevel, ExpectLevel, Percent)
                        local Ret
                        local OldValStr = SkillUtils.CalcSkillDesc(DescValue, BaseLevel, nil, true) .. Percent
                        local NewValStr = SkillUtils.CalcSkillDesc(DescValue, ExpectLevel, nil, true) .. Percent
                        if (OldValStr ~= NewValStr) then
                            OldValStr = SkillUtils.FormatDescValue1(OldValStr, CastTo)
                            NewValStr = SkillUtils.FormatDescValue1(NewValStr, CastTo)
                            Ret = OldValStr .. " -> " .. string.format("<H>%s</>", NewValStr) or NewValStr
                        else
                            NewValStr = SkillUtils.FormatDescValue1(NewValStr, CastTo)
                            Ret = NewValStr
                        end
                        return Ret
                    end
                    ValStr = ValStr == "" and SkillGrowDesc(DescValue, SkillLevel, ExpectLevel, Percent) or ValStr
                    Desc = string.gsub(Desc, "#" .. i, ValStr)
                end
            end
        end
    end
    return Desc
end

-- 当前技能能否升到目标等级
function SkillUtils.CalcSkillCanLvup(SkillId, CurLevel, TarLevel, CharUuid)
    local ResourceUse = {}
    local CharBreakLevelNeed = 0

    local CanLevelUp = true
    local IsResourceEnough = true
    local IsBreakLevelEnough = true

    if TarLevel > SkillUtils.GetMaxLevel(SkillId) then
        CanLevelUp = false
    else
        local ResourceData = DataMgr.SkillLevelUp[SkillId]
        if TarLevel == CurLevel + 1 then
            if ResourceData and ResourceData[CurLevel] then
                for i = 1, 4 do
                    local ResourceId = ResourceData[CurLevel].ItemId[i]
                    local ResourceValue = ResourceData[CurLevel].ItemNum[i]

                    if ResourceId and ResourceValue then
                        table.insert(ResourceUse, { ResourceId = ResourceId, Count = ResourceValue })
                    end
                end
                CharBreakLevelNeed = math.max(CharBreakLevelNeed, ResourceData[CurLevel].CharBreakLevel)
			end
		else -- 目前技能不支持连续升多级，下面的不会走进去
            local ResourceCounter = {}
            if ResourceData then
                for i = CurLevel, TarLevel - 1 do
                    if ResourceData[i] then
                        for j = 1, 4 do
                            local ResourceId = ResourceData[i].ItemId[j]
                            local ResourceValue = ResourceData[i].ItemNum[j]

                            if ResourceId and ResourceValue then
                                ResourceCounter[ResourceId] = (ResourceCounter[ResourceId] or 0) + ResourceValue
                            end
                        end

                        CharBreakLevelNeed = math.max(CharBreakLevelNeed, ResourceData[i].CharBreakLevel)
                    end
                end
            end

            for k, v in pairs(ResourceCounter) do
                table.insert(ResourceUse, { ResourceId = k, Count = v })
            end
        end

        -- 检查所需资源
        local Avatar = GWorld:GetAvatar()
        for _, Res in ipairs(ResourceUse) do
            if not Avatar.Resources[Res.ResourceId] or Avatar.Resources[Res.ResourceId].Count < Res.Count then
                IsResourceEnough = false
                break
            end
        end

        -- 检查角色突破等级
        local Char = Avatar.Chars[CharUuid or Avatar.CurrentChar]
        local BreakLevel = Char.EnhanceLevel
        if ResourceData and ResourceData[TarLevel - 1] then
            local BreakLevelNeed = ResourceData[TarLevel - 1].CharBreakLevel
            IsBreakLevelEnough = BreakLevel >= BreakLevelNeed
		end
	end



	return {
		ResourceUse = ResourceUse,
		CanLevelUp = CanLevelUp and IsResourceEnough and IsBreakLevelEnough,
        BreakLevelNeed = CharBreakLevelNeed,
        IsResourceEnough = IsResourceEnough,
        IsBreakLevelEnough = IsBreakLevelEnough
    }
end

-- 获得技能的最高等级
function SkillUtils.GetMaxLevel(SkillId)
    local SkillLevelUpInfo = DataMgr.SkillLevelUp[SkillId]
    if SkillLevelUpInfo then
        return #SkillLevelUpInfo + 1
    end
	return 1
end


function SkillUtils.GrowDescIndex(_FinalProxy, Key)
	-- PrintTable({s=5,_FinalProxy=_FinalProxy,Key=Key},3)
    local RawData = rawget(_FinalProxy, 'RawData')
    assert(RawData, "找不到DataMgr." .. tostring(_FinalProxy.DataProxy._GrowType) .. "[" .. tostring(_FinalProxy.ID) .. "]的数据")
    local Value = RawData[Key]
    assert(Value, "找不到DataMgr." .. tostring(_FinalProxy.DataProxy._GrowType) .. "[" .. tostring(_FinalProxy.ID) .. "]里某个Key[" .. tostring(Key) .. "]的数据")

    local GrowData = rawget(_FinalProxy, 'GrowData')
    if type(Value) == "string" and string.sub(Value, 1, 1) == '#' then
        assert(GrowData, tostring(rawget(_FinalProxy, "Error")))
        local Index = tonumber(string.sub(Value, 2, -1))
        local IndexData = GrowData[Index]
        assert(IndexData, tostring(rawget(_FinalProxy, "Error")) .. 'Index为[' .. tostring(Index) .. ']')
        Value = IndexData.Value
    end

    if type(Value) ~= 'table' then
        -- PrintTable({Finish = 1})
        return Value
    end
    return SkillUtils.CreateFinalProxy(_FinalProxy.DataProxy, _FinalProxy.ID, GrowData, Value, rawget(_FinalProxy, "Error"))
end

function SkillUtils.CreateFinalProxy(_DataProxy, ID, GrowData, RawData, Error)
    local _FinalProxy = {
        DataProxy = _DataProxy,
        GrowData = GrowData,
        RawData = RawData,
        Error = Error,
        ID = ID,
    }
    setmetatable(_FinalProxy, {
        __index = SkillUtils.GrowDescIndex,
    })
    -- PrintTable({S=6,_FinalProxy=_FinalProxy,Key=key},5)
    return _FinalProxy
end

function SkillUtils.NewGrowDesc(SkillLevel)
    local bDistribution = UE4 and UE4.URuntimeCommonFunctionLibrary.IsDistribution()
    -- 技能等级层
    local _Proxy = {
        _SkillLevel = SkillLevel,
    }
    -- PrintTable({s=1})
    setmetatable(_Proxy, {
        -- 导表层
        __index = function(M, GrowType)
            local _DataProxy = {
                _GrowType = GrowType,
                _SkillLevel = M._SkillLevel,
            }
            -- PrintTable({s=2})

            -- 表格编号层
            setmetatable(_DataProxy, {
                __index = function(M, ID)
                    -- PrintTable({s=3})
                    local RawData = DataMgr[M._GrowType][ID]
                    local Data, Error = SkillUtils.GetGrowData(M._GrowType, ID, M._SkillLevel)
                    -- 如果没有成长数据，直接返回原始数据
                    if not Data then
                        if bDistribution then
                            return RawData
                        end
                        -- 编辑器环境下，增加代理用于报错
                        return SkillUtils.CreateFinalProxy(_DataProxy, ID, nil, RawData, Error)
                    end

                    -- PrintTable({s=4})
                    -- 如果有成长数据，构建成长数据代理
                    local FinalProxy = SkillUtils.CreateFinalProxy(_DataProxy, ID, Data, RawData, Error)
                    return FinalProxy
                end
            })
            -- 因为每次都是全新的，所以不需要rawset
            -- rawset(M, GrowType, _DataProxy)
            return _DataProxy
        end,
    })
    return _Proxy
end

function SkillUtils.GetGrowData(GrowType, ID, SkillLevel)
    -- PrintTable({Grow=DataMgr.SkillGrow,GrowType=GrowType,ID=ID,SkillLevel=SkillLevel},10)
    local _Data = DataMgr.SkillGrow[GrowType]
    if not _Data then
        return nil, "缺少类型为[" .. tostring(GrowType) .. "]的成长数据"
    end
    _Data = _Data[ID]
    if not _Data then
        return nil, "缺少类型为[" .. tostring(GrowType) .. "]编号为[" .. tostring(ID) .. "]的成长数据"
    end
    _Data = _Data[SkillLevel]
    if not _Data then
        return nil, "缺少类型为[" .. tostring(GrowType) .. "]编号为[" .. tostring(ID) .. "]等级为[" .. tostring(SkillLevel) .. "]的成长数据"
    end
    return _Data, "缺少类型为[" .. tostring(GrowType) .. "]编号为[" .. tostring(ID) .. "]等级为[" .. tostring(SkillLevel) .. "]的成长数据"
end

function SkillUtils.GrowProxyBySkillLevel(GrowType, ID, SkillLevel, RawData, Args)
    local GrowProxy = {
        _GrowType = GrowType,
        _ID = ID,
        _SkillLevel = SkillLevel or 1,
        _RawData = RawData,
        _Args = Args,
    }

    return SkillUtils._GrowProxy(GrowProxy, GrowType, ID, RawData, Args)
end

function SkillUtils.GrowProxy(GrowType, ID, SkillLevelSource, RawData, Args)
    local GrowProxy = {
        _GrowType = GrowType,
        _ID = ID,
        _SkillLevel = 1, -- 默认
        _RawData = RawData,
        _Args = Args,
    }
    if SkillLevelSource then
        GrowProxy._SkillLevel = SkillLevelSource:GetSkillLevelInfo().SkillLevel
    end

    return SkillUtils._GrowProxy(GrowProxy, GrowType, ID, RawData, Args)
end

function SkillUtils._GrowProxy(GrowProxy, GrowType, ID, RawData, Args)
    local NeedSplitEvalProxy = false
    if DataMgr.SkillSplitEval[GrowType] and DataMgr.SkillSplitEval[GrowType][ID] then
        NeedSplitEvalProxy = true
    end

    local Data, _ = SkillUtils.GetGrowData(GrowProxy._GrowType, GrowProxy._ID, GrowProxy._SkillLevel)
    if not Data then
        return SkillUtils.SplitEvalProxy(NeedSplitEvalProxy, GrowProxy._SkillLevel, RawData, GrowProxy._Args)
    end

    GrowProxy._GrowData = Data
    setmetatable(GrowProxy, {
        __index = function(M, key)
            local Value = M._RawData[key]
            if M._GrowData and type(Value) == "string" and string.sub(Value, 1, 1) == '#' then
                local GrowIndex = tonumber(string.sub(Value, 2, -1))
                -- 这里需要导表检查支持
                local IndexData = M._GrowData[GrowIndex]
                if IndexData then
                    Value = IndexData.Value
                else
                    Value = 0
                end
                -- print(LogTag, '111------'..tostring(Value))
            end
            rawset(M, key, Value)
            return Value
        end,
    })

    return SkillUtils.SplitEvalProxy(NeedSplitEvalProxy, GrowProxy._SkillLevel, GrowProxy, GrowProxy._Args)
end

function SkillUtils.SplitEvalProxy(NeedSplitEvalProxy, SkillLevel, RawData, Args)
    if not NeedSplitEvalProxy then
        return RawData
    end
    local SplitEvalProxy = {
        _SkillLevel = SkillLevel,
        _RawData = RawData,
        _Args = Args,
    }

    setmetatable(SplitEvalProxy, {
        __index = function(M, key)
            local Value = M._RawData[key]
            if type(Value) == "string" then
                Value = SkillUtils.CalcSkillDescValue(Value, M._SkillLevel, Args)
                -- print(LogTag, '222------'..tostring(Value))
            end
            rawset(M, key, Value)
            return Value
        end,
    })
    return SplitEvalProxy
end

function SkillUtils.HasAnyUpgradeableSkill(Char)
    if (not Char) then
        return
    end
    local IsResourceEnough, IsBreakLevelEnough = false, false
    for _, Skill in ipairs(Char.Skills) do
        local SkillData = DataMgr.Skill[Skill.SkillId]
        if SkillData and SkillData[1] and SkillData[1][0] then
            local Res = SkillUtils.CalcSkillCanLvup(Skill.SkillId, Skill.Level, Skill.Level + 1)
            if (Res.CanLevelUp) then
                return true
            end
        end
    end
    return false
end

function SkillUtils.CalcSpCostByData(Player, SkillData, Char)
    -- 由于军械库内PlayerCharacter上的Attr还没刷新，因此需要拿Avatar上的Attr去计算
    local Avatar = GWorld:GetAvatar()
    local Attrs = (Char or Avatar.Chars[Avatar.CurrentChar]):DumpDefaultBattleAttr(Avatar).TotalValues
    local CostSpNum = nil
    if (SkillData.NotExecute) then
        -- 不执行技能节点
        if (SkillData.PassiveEffects) then
            for _, PassiveEffectId in pairs(SkillData.PassiveEffects) do
                local AllVars = DataMgr.PassiveEffect[PassiveEffectId].Vars
                for k, v in pairs(AllVars) do
                    if (k == "SpCost") then
                        CostSpNum = v
                        break
                    end
                end
            end
        end
    else
        local SkillNodeId = SkillData.BeginNodeId
        local SkillNodeConfig = DataMgr.SkillNode[SkillNodeId] or {}
        CostSpNum = SkillNodeConfig.CostSp
    end
    local SkillEfficiency = math.min(Attrs.SkillEfficiency, Const.MaxSkillEfficiency)
    return Player:ApplySkillEfficiencyByAttr(CostSpNum, SkillEfficiency) or 0
end

---计算武器被动描述
function SkillUtils.CalcWeaponPassiveEffectsDesc(WeaponData, GradeLevel, ComparedGradeLevel)
    local data = DataMgr.BattleWeapon[WeaponData.WeaponId]
    local SkillDesc = nil
    if data and data.PassiveEffectsDesc then
        SkillDesc = GText(data.PassiveEffectsDesc)
        if data.PassiveEffectsDescValues then
            local CastTo
            for i, value in ipairs(data.PassiveEffectsDescValues) do
                SkillDesc, CastTo = SkillUtils.ReplaceAndChekDescValueCast(SkillDesc, i)
                local valueStr = SkillUtils.CalcSkillDesc(value, math.min(DataMgr.DataConst.MaxSkillLevel, (GradeLevel or WeaponData.GradeLevel or 0) + 1),nil,true)
                valueStr = SkillUtils.FormatDescValue1(valueStr, CastTo)
                if (ComparedGradeLevel) then
                    local ComparedValueStr = SkillUtils.CalcSkillDesc(value, math.min(DataMgr.DataConst.MaxSkillLevel, (ComparedGradeLevel or 0) + 1),nil,true)
                    ComparedValueStr = SkillUtils.FormatDescValue1(ComparedValueStr, CastTo)
                    if (valueStr ~= ComparedValueStr) then
                        valueStr = valueStr .. "->" .. ComparedValueStr
                    end
                end

                SkillDesc = string.gsub(SkillDesc, '#' .. i, valueStr)
            end
        end
    end
    return SkillDesc
end

function SkillUtils.CalcPetEntryDesc(EntryId)
    local Data = DataMgr.PetEntry[EntryId]
    if (not Data) then
        return
    end
    local BattePetData = DataMgr.BattlePet[Data.BattlePetID]
    if (BattePetData and BattePetData.PassiveEffectDesc) then
        local Desc = GText(BattePetData.PassiveEffectDesc)
        if BattePetData.PassiveEffectDescParameter then
            for i, value in ipairs(BattePetData.PassiveEffectDescParameter) do
                local valueStr = SkillUtils.CalcSkillDesc(value, Data.BattlePetLevel or 1)
                local index = string.find(valueStr, '%%', 1)
                if index then
                    valueStr = valueStr .. '%'
                end
                Desc = string.gsub(Desc, '#' .. i, valueStr)
            end
        end
        return Desc
    end
end
---获取词条进阶的富文本，传入词条和升级后的词条，可以得到类似螺旋飞跃速度+20.0%->40.0%（黄色）的文本
function SkillUtils.CalcPetEntryEnhanceDesc(EntryId, NewEntryId)
    local Data = DataMgr.PetEntry[EntryId]
    local NewData = DataMgr.PetEntry[NewEntryId]
    if (not Data or not NewData) then
        error("没有获取到词条")
        return
    end

    local BattePetData = DataMgr.BattlePet[Data.BattlePetID]
    local NewBattePetData = DataMgr.BattlePet[NewData.BattlePetID]
    if (BattePetData and BattePetData.PassiveEffectDesc) then
        local Desc = GText(BattePetData.PassiveEffectDesc)
        if BattePetData.PassiveEffectDescParameter then
            for i, value in ipairs(BattePetData.PassiveEffectDescParameter) do
                local valueStr = SkillUtils.CalcSkillDesc(value, Data.BattlePetLevel or 1)
                local NewvalueStr = SkillUtils.CalcSkillDesc(NewBattePetData.PassiveEffectDescParameter[i], NewData.BattlePetLevel or 1)
                local index = string.find(valueStr, '%%', 1)
                if index then
                    valueStr = valueStr .. '%'
                end
                Desc = string.gsub(Desc, '#' .. i, valueStr)

                -- local newindex= string.find(NewvalueStr,'%%',1)
                -- if newindex then
                -- 	NewvalueStr=NewvalueStr..'%'
                -- end
                if NewvalueStr ~= nil then
                    Desc = Desc .. " -> " .. string.format("<H>%s</>", NewvalueStr)
                else
                    DebugPrint("没找到升级后的词条数据")
                end
            end
        end
        return Desc
    end


end
function SkillUtils.ReplaceAndChekDescValueCast(Desc, Idx)
    if (string.find(Desc, "{[I|i][N|n][T|t]}#" .. Idx)) then
        return string.gsub(Desc, "{[I|i][N|n][T|t]}#" .. Idx, "#" .. Idx), {"int"}
    elseif(string.find(Desc, "{[F|f][L|l][O|o][A|a][T|t][0-9]}#" .. Idx))then
        local Start,End = string.find(Desc, "{[F|f][L|l][O|o][A|a][T|t][0-9]}#")
        local Decimal = string.sub(Desc,Start+6,End-2)
        return string.gsub(Desc, "{[F|f][L|l][O|o][A|a][T|t][0-9]}#" .. Idx, "#" .. Idx), {"float",Decimal}
    else
        return Desc, false
    end
end

function SkillUtils.FormatDescValue1(str, CastTo)
    local Res = str
    local value = string.match(str, "(%d+%.?%d*)")
    if value then
        local newValue = tonumber(value)
        local _pattern
        if(CastTo)then
            if (CastTo[1] == "int") then
                value = math.floor(tonumber(value))
                _pattern = "%d"
            elseif(CastTo[1] == "float" and CastTo[2])then
                if string.sub(str, -1) == "%" then
                    --百分比小数保留位数-2
                    local d = tonumber(CastTo[2]) or 0
                    d = d - 2
                    if d < 0 then d = 0 end
                    _pattern = "%.".. d .. "f"
                else
                    _pattern = "%.".. CastTo[2] .. "f"
                end
            end
        else
            _pattern = "%.1f" --默认至少一位小数
        end
        if string.sub(str, -1) == "%" then
            newValue = string.format(_pattern .. "%%", value)
        else
            newValue = string.format(_pattern, newValue)
        end
        Res = newValue
    end
    local index = string.find(Res, '%%', 1)
    if index then
		if CommonConst.SystemLanguage == CommonConst.SystemLanguages.FR then
			Res = string.gsub(Res, "%%","\u{00A0}%%%%")
		else
			Res = Res .. '%'
		end
    end 
    Res = CommonUtils.FormatNumInFrench(Res)
    return Res
end

---保留最多两位小数
function SkillUtils.FormatDescValue2(str)
    local _start, _end = string.find(str, "%d+%.?%d*")
    local num = tonumber(string.sub(str, _start, _end))
    if (num and math.floor(num) ~= math.ceil(num)) then
        --如果不是整数则四舍五入取小数点后两位
        num = math.floor(num * 100 + 0.5) / 100
        str = string.sub(str, 1, _start - 1) .. num .. string.sub(str, _end + 1, #str)
    end

    str = CommonUtils.FormatNumInFrench(str)
    return str
end

function SkillUtils.ApplySkillEfficiencyWithLimit(CostSp, SkillEfficiency)
    local CostSp_F = SkillUtils.SafeCeil(CostSp * (2 - SkillEfficiency))
    local Cost_Limit = SkillUtils.SafeCeil(DataMgr.AttrLimit.SpChangeLimitPercent.LimitValue * CostSp)
    return math.max(CostSp_F, Cost_Limit)
end

function SkillUtils.ApplySkillIntensity(Value, SkillIntensity)
    return Value * SkillIntensity
end

function SkillUtils.ApplySkillRange(Value, SkillRange)
    return Value * SkillRange
end

function SkillUtils.ApplySkillSustain(Value, SkillSustain)
    return Value * SkillSustain
end

function SkillUtils.ApplySkillSustainAndEfficiency(Value, SkillSustain, SkillEfficiency)
    local CostSp_F = SkillUtils.SafeCeil(Value * (2 - SkillEfficiency) / SkillSustain)
    local CostSp_Limit = SkillUtils.SafeCeil(DataMgr.AttrLimit.SpChangeLimitPercent.LimitValue * Value)
    return math.max(CostSp_F, CostSp_Limit)
end

function SkillUtils.CanSkillTreeNodeUnlock(Char, TreeBranchIdx, NodeIdx)
    local Res = {}
    local SkillTreeUnlockData = DataMgr.SKillTreeUnlock[Char.CharId]
    if (not SkillTreeUnlockData) then
        return Res
    end
    local IsPreNodeActivated = Char:CheckSkillTreeNodeIsActive(TreeBranchIdx, NodeIdx - 1)
    Res.IsPreNodeNeed = not IsPreNodeActivated
    local CharSkills = {}
    for key, value in pairs(Char.Skills) do
        CharSkills[value.SkillId] = value
    end
    local Avatar = GWorld:GetAvatar()
    for key, Data in pairs(SkillTreeUnlockData) do
        if (Data.Skill and Data.Skill[1] == TreeBranchIdx and Data.Skill[2] == NodeIdx) then
            if (Data.NeedBreak and Char.EnhanceLevel < Data.NeedBreak) then
                Res.BreakLevelNeed = Data.NeedBreak
            end
            if (Data.NeedLevel and Char.Level < Data.NeedLevel) then
                Res.LevelNeed = Data.NeedLevel
            end
            if (Data.NeedSkill) then
                for SkillId, SkillLevel in pairs(Data.NeedSkill) do
                    if (CharSkills[SkillId]) then
                        if (CharSkills[SkillId].Level < SkillLevel) then
                            Res.SkillLevelNeed = SkillLevel
                            Res.SkillNeed = SkillId
                            break
                        end
                    else
                        --表里填了技能等级但是角色没有该技能
                        Res.SkillNeed = SkillId
                    end
                end
            end
            if (Data.Condition) then
                for _, Condition in ipairs(Data.Condition) do
                    if (not Avatar:CheckCondition(Condition)) then
                        Res.ConditionNeed = Condition
                        break
                    end
                end
            end
            local ResourceUse = {}
            local ResourceIds = Data.ResourceID or {}
            local ResourceAmounts = Data.Amount or {}
            for i, RId in ipairs(ResourceIds) do
                local Num = (ResourceAmounts[i] or 0)
                table.insert(ResourceUse, { ResourceId = RId, Count = Num })
                local ServerResource = Avatar.Resources[RId] or { Count = 0 }
                if ServerResource.Count < Num then
                    Res.IsResourceNeed = true
                end
            end
            Res.ResourceUse = ResourceUse
            break
        end
    end
    Res.CanUnlock = not Res.BreakLevelNeed and not Res.ConditionNeed and not Res.SkillNeed and not Res.LevelNeed and not Res.IsPreNodeNeed and not Res.IsResourceNeed
    return Res
end

function SkillUtils.GetSkillName(SkillId)
    local Data = DataMgr.Skill[SkillId]
    local SkillData = Data and Data[1] and Data[1][0]
    if (SkillData) then
        return GText(SkillData.SkillName)
    end
end

function SkillUtils.SafeCeil(x)
    local integer_part = math.floor(x)
    if math.abs(x - integer_part) < 1e-10 then
        return integer_part
    else
        return math.ceil(x)
    end
end

return SkillUtils