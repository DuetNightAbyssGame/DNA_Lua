require "UnLua"
local TimeUtils = require "Utils.TimeUtils"

local BattleProfile = Class()

function BattleProfile:OnFinishProfile()
    local PassTime = self.StopTime - self.StartTime
    local PassFrameCount = self.StopFrameCount - self.StartFrameCount

    local ct = {"\n"}
    Battle(self):FillBattleLog(ct)
    local ret = table.concat(ct)

    local LogStr = "战斗Profile结束，用时:[" .. tostring(PassTime) .. "]秒，用时:[" .. tostring(PassFrameCount) .. "]帧。\n平均帧率:[" .. tostring(PassFrameCount/PassTime) .. "](会受暂停/时间膨胀影响,不一定准)" .. ret
    DebugPrint(LogStr)
    
    if not PassTime or PassTime <= 0 or not PassFrameCount or PassFrameCount <= 0 then
        return
    end

    local BattleProfileInfo = {}

    BattleProfileInfo["伤害Profile"] = self:GetDamageInfo(PassTime, PassFrameCount)
    BattleProfileInfo["技能Profile"] = self:GetSkillInfo(PassTime, PassFrameCount)
    BattleProfileInfo["BuffProfile"] = self:GetBuffInfo(PassTime, PassFrameCount)
    BattleProfileInfo["BuffChangedProfile"] = self:GetBuffChangedInfo(PassTime, PassFrameCount)
    BattleProfileInfo["特效Profile"] = self:GetPlayFxInfo(PassTime, PassFrameCount)
    BattleProfileInfo["音频Profile"] = self:GetPlaySEInfo(PassTime, PassFrameCount)
    BattleProfileInfo["函数调用Profile"] = self:GetFunctionCallInfo(PassTime, PassFrameCount)
    BattleProfileInfo["UProperty调用Profile"] = self:GetUPropertyCallInfo(PassTime, PassFrameCount)
    LogStr = LogStr .. PrintTable(BattleProfileInfo, 10, "战斗Profile详情", true)

    local TimeStr = TimeUtils.TimeToYMDHMSStr(TimeUtils.RealTime(), false, "_", "_")
    local FilePath = UEMPathFunctionLibrary.GetProjectSavedDirectory().."BattleProfile/".. tostring(TimeStr) ..".txt"
    UE.URuntimeCommonFunctionLibrary.SaveFile(FilePath, LogStr)
end

function BattleProfile:GetDamageInfo(PassTime, PassFrameCount)
    local TotalTime = self.Damages:Length()
    local DamageProfileInfo = {}
    DamageProfileInfo["总伤害次数"] = TotalTime
    if TotalTime > 0 then
        local TimePerSecond = TotalTime / PassTime
        DamageProfileInfo["平均伤害次数"] = {
            ["每秒"] = TotalTime / PassTime,
            ["每帧"] = TotalTime / PassFrameCount,
        }

        -- 伤害频率每秒
        local TimeSecondInfos = {}
        local FrameCountInfos = {}
        local FrameCountToTimeSecond = {}
        for _, DamageInfo in pairs(self.Damages) do
            local TimeSecond = DamageInfo.TimeSecond
            TimeSecondInfos[TimeSecond] = (TimeSecondInfos[TimeSecond] or 0) + 1
            local FrameCount = DamageInfo.FrameCount
            FrameCountInfos[FrameCount] = (FrameCountInfos[FrameCount] or 0) + 1
            FrameCountToTimeSecond[FrameCount] = TimeSecond
        end

        local MaxNum = 0
        local MaxNumIndex = 0
        for TimeSecond, Num in pairs(TimeSecondInfos) do
            if Num > MaxNum then
                MaxNum = Num
                MaxNumIndex = TimeSecond
            end
        end

        DamageProfileInfo["最高伤害频率(每秒)"] = {
            ["一秒内最高伤害次数"] = MaxNum,
            -- ["出现在开始Profile的秒数"] = MaxNumIndex,
        }

        -- 伤害频率每帧
        local MaxNum = 0
        local MaxNumIndex = 0
        for FrameCount, Num in pairs(FrameCountInfos) do
            if Num > MaxNum then
                MaxNum = Num
                MaxNumIndex = FrameCount
            end
        end

        DamageProfileInfo["最高伤害频率(每帧)"] = {
            ["单帧最高伤害次数"] = MaxNum,
            -- ["出现在开始Profile的帧数"] = MaxNumIndex,
            -- ["出现在开始Profile的秒数"] = FrameCountToTimeSecond[MaxNumIndex],
        }

        -- 伤害分布
        local TagDamages = {}
        for _, DamageInfo in pairs(self.Damages) do
            for _, Tag in pairs(DamageInfo.DamageTag) do
                TagDamages[Tag] = (TagDamages[Tag] or 0) + 1
            end
        end
        local SortedTagDamages = {}
        for Tag, Num in pairs(TagDamages) do
            table.insert(SortedTagDamages, {
                ["伤害Tag"] = Tag,
                ["伤害数量"] = Num,
                ["占伤害数量百分比"] = tostring(math.floor(Num/TotalTime*100)) .. "%" ,
            })
        end

        table.sort(SortedTagDamages,  function(a, b)
            return a["伤害数量"] > b["伤害数量"]
        end)

        DamageProfileInfo["伤害分布(按数量从高到底)"] = SortedTagDamages

        local MaxTrueValue = 0
        for _, DamageInfo in pairs(self.Damages) do
            if DamageInfo.TrueValue > MaxTrueValue then
                MaxTrueValue = DamageInfo.TrueValue
            end
        end
        DamageProfileInfo["最高伤害值"] = MaxTrueValue
        
        local CritNum = 0
        local MaxCritLevel = 0
        for _, DamageInfo in pairs(self.Damages) do
            local IsCrit = DamageInfo.IsCrit
            if IsCrit then
                CritNum = CritNum + 1
                local DamageCritLevel = DamageInfo.DamageCritLevel
                MaxCritLevel = math.max(MaxCritLevel, DamageCritLevel)
            end
        end
        if CritNum > 0 then
            DamageProfileInfo["暴击信息"] = {
                ["总暴击频率"] = CritNum / TotalTime,
                -- ["最高暴击等级"] = MaxCritLevel,
            }
        end

    end
    return DamageProfileInfo
end

function BattleProfile:GetSkillInfo(PassTime, PassFrameCount)
    local TotalTime = self.Skills:Length()
    local SkillProfileInfo = {}
    SkillProfileInfo["技能使用次数"] = TotalTime
    if TotalTime > 0 then
        local TimePerSecond = TotalTime / PassTime
        SkillProfileInfo["平均技能次数"] = {
            ["每秒"] = TotalTime / PassTime,
            ["每帧"] = TotalTime / PassFrameCount,
        }

        -- 技能频率每秒
        local TimeSecondInfos = {}
        local FrameCountInfos = {}
        local FrameCountToTimeSecond = {}
        for _, SkillInfo in pairs(self.Skills) do
            local TimeSecond = SkillInfo.TimeSecond
            TimeSecondInfos[TimeSecond] = (TimeSecondInfos[TimeSecond] or 0) + 1
            local FrameCount = SkillInfo.FrameCount
            FrameCountInfos[FrameCount] = (FrameCountInfos[FrameCount] or 0) + 1
            FrameCountToTimeSecond[FrameCount] = TimeSecond
        end

        local MaxNum = 0
        local MaxNumIndex = 0
        for TimeSecond, Num in pairs(TimeSecondInfos) do
            if Num > MaxNum then
                MaxNum = Num
                MaxNumIndex = TimeSecond
            end
        end

        SkillProfileInfo["最高技能频率(每秒)"] = {
            ["一秒内最高技能次数"] = MaxNum,
            -- ["出现在开始Profile的秒数"] = MaxNumIndex,
        }

        -- 技能频率每帧
        local MaxNum = 0
        local MaxNumIndex = 0
        for FrameCount, Num in pairs(FrameCountInfos) do
            if Num > MaxNum then
                MaxNum = Num
                MaxNumIndex = FrameCount
            end
        end

        SkillProfileInfo["最高技能频率(每帧)"] = {
            ["单帧最高技能次数"] = MaxNum,
            -- ["出现在开始Profile的帧数"] = MaxNumIndex,
            -- ["出现在开始Profile的秒数"] = FrameCountToTimeSecond[MaxNumIndex],
        }

        -- -- 技能分布
        -- local SkillNums = {}
        -- for _, SkillInfo in pairs(self.Skills) do
        --     local SkillId = SkillInfo.Skillid
        --     SkillNums[SkillId] = (SkillNums[SkillId] or 0) + 1
        -- end
        -- local SorteSkillNums = {}
        -- for SkillId, Num in pairs(SkillNums) do
        --     table.insert(SorteSkillNums, {
        --         ["技能ID"] = SkillId,
        --         ["技能次数"] = Num,
        --         ["占技能数量百分比"] = tostring(math.floor(Num/TotalTime*100)) .. "%" ,
        --     })
        -- end

        -- table.sort(SorteSkillNums,  function(a, b)
        --     return a["技能次数"] > b["技能次数"]
        -- end)

        -- SkillProfileInfo["技能分布(按数量从高到底)"] = SorteSkillNums
    end
    return SkillProfileInfo
end

function BattleProfile:GetBuffInfo(PassTime, PassFrameCount)
    local TotalTime = self.Buffs:Length()
    local BuffProfileInfo = {}
    BuffProfileInfo["1. Buff添加次数"] = TotalTime
    if TotalTime > 0 then
        local TimePerSecond = TotalTime / PassTime
        BuffProfileInfo["平均Buff添加次数"] = {
            ["每秒"] = TotalTime / PassTime,
            ["每帧"] = TotalTime / PassFrameCount,
        }

        -- Buff频率每秒
        local TimeSecondInfos = {}
        local FrameCountInfos = {}
        local FrameCountToTimeSecond = {}
        for _, BuffInfo in pairs(self.Buffs) do
            local TimeSecond = BuffInfo.TimeSecond
            TimeSecondInfos[TimeSecond] = (TimeSecondInfos[TimeSecond] or 0) + 1
            local FrameCount = BuffInfo.FrameCount
            FrameCountInfos[FrameCount] = (FrameCountInfos[FrameCount] or 0) + 1
            FrameCountToTimeSecond[FrameCount] = TimeSecond
        end

        local MaxNum = 0
        local MaxNumIndex = 0
        for TimeSecond, Num in pairs(TimeSecondInfos) do
            if Num > MaxNum then
                MaxNum = Num
                MaxNumIndex = TimeSecond
            end
        end

        BuffProfileInfo["2. 最高Buff添加频率(每秒)"] = {
            ["一秒内最高Buff添加次数"] = MaxNum,
            -- ["出现在开始Profile的秒数"] = MaxNumIndex,
        }

        -- Buff频率每帧
        local MaxNum = 0
        local MaxNumIndex = 0
        for FrameCount, Num in pairs(FrameCountInfos) do
            if Num > MaxNum then
                MaxNum = Num
                MaxNumIndex = FrameCount
            end
        end

        BuffProfileInfo["3. 最高Buff添加频率(每帧)"] = {
            ["单帧最高Buff添加次数"] = MaxNum,
            -- ["出现在开始Profile的帧数"] = MaxNumIndex,
            -- ["出现在开始Profile的秒数"] = FrameCountToTimeSecond[MaxNumIndex],
        }

        -- Buff分布
        local BuffNums = {}
        for _, BuffInfo in pairs(self.Buffs) do
            local BuffId = BuffInfo.Buffid
            BuffNums[BuffId] = (BuffNums[BuffId] or 0) + 1
        end
        local SorteBuffNums = {}
        for BuffId, Num in pairs(BuffNums) do
            table.insert(SorteBuffNums, {
                ["BuffID"] = BuffId,
                ["Buff添加次数"] = Num,
                ["占Buff数量百分比"] = tostring(math.floor(Num/TotalTime*100)) .. "%" ,
            })
        end

        table.sort(SorteBuffNums,  function(a, b)
            return a["Buff添加次数"] > b["Buff添加次数"]
        end)

        BuffProfileInfo["4. Buff分布(按数量从高到底)"] = SorteBuffNums
    end
    return BuffProfileInfo
end

function BattleProfile:GetPlayFxInfo(PassTime, PassFrameCount)
    local TotalTime = self.PlayFxs:Length()
    local PlayFxProfileInfo = {}
    PlayFxProfileInfo["特效使用次数"] = TotalTime
    if TotalTime > 0 then
        local TimePerSecond = TotalTime / PassTime
        PlayFxProfileInfo["平均特效次数"] = {
            ["每秒"] = TotalTime / PassTime,
            ["每帧"] = TotalTime / PassFrameCount,
        }

        -- 特效频率每秒
        local TimeSecondInfos = {}
        local FrameCountInfos = {}
        local FrameCountToTimeSecond = {}
        for _, PlayFxInfo in pairs(self.PlayFxs) do
            local TimeSecond = PlayFxInfo.TimeSecond
            TimeSecondInfos[TimeSecond] = (TimeSecondInfos[TimeSecond] or 0) + 1
            local FrameCount = PlayFxInfo.FrameCount
            FrameCountInfos[FrameCount] = (FrameCountInfos[FrameCount] or 0) + 1
            FrameCountToTimeSecond[FrameCount] = TimeSecond
        end

        local MaxNum = 0
        local MaxNumIndex = 0
        for TimeSecond, Num in pairs(TimeSecondInfos) do
            if Num > MaxNum then
                MaxNum = Num
                MaxNumIndex = TimeSecond
            end
        end

        PlayFxProfileInfo["最高特效频率(每秒)"] = {
            ["一秒内最高特效次数"] = MaxNum,
            -- ["出现在开始Profile的秒数"] = MaxNumIndex,
        }

        -- 特效频率每帧
        local MaxNum = 0
        local MaxNumIndex = 0
        for FrameCount, Num in pairs(FrameCountInfos) do
            if Num > MaxNum then
                MaxNum = Num
                MaxNumIndex = FrameCount
            end
        end

        PlayFxProfileInfo["最高特效频率(每帧)"] = {
            ["单帧最高特效次数"] = MaxNum,
            -- ["出现在开始Profile的帧数"] = MaxNumIndex,
            -- ["出现在开始Profile的秒数"] = FrameCountToTimeSecond[MaxNumIndex],
        }

        -- 特效分布
        local PlayFxNums = {}
        for _, PlayFxInfo in pairs(self.PlayFxs) do
            local FxId = PlayFxInfo.FxId
            PlayFxNums[FxId] = (PlayFxNums[FxId] or 0) + 1
        end
        local SortePlayFxNums = {}
        for FxId, Num in pairs(PlayFxNums) do
            table.insert(SortePlayFxNums, {
                ["特效ID"] = FxId,
                --["特效名"] = DataMgr.VisualEffect[FxId].EffectPath:gsub('.*%/', ''),
                ["特效次数"] = Num,
                ["占特效数量百分比"] = tostring(math.floor(Num/TotalTime*100)) .. "%" ,
            })
        end

        table.sort(SortePlayFxNums,  function(a, b)
            return a["特效次数"] > b["特效次数"]
        end)

        PlayFxProfileInfo["特效分布(按数量从高到底)"] = SortePlayFxNums
    end
    return PlayFxProfileInfo
end

function BattleProfile:GetPlaySEInfo(PassTime, PassFrameCount)
    local TotalTime = self.PlaySEs:Length()
    local PlaySEProfileInfo = {}
    PlaySEProfileInfo["音效调用次数"] = TotalTime
    if TotalTime > 0 then
        PlaySEProfileInfo["平均调用次数"] = {
            ["每秒"] = TotalTime / PassTime,
            ["每帧"] = TotalTime / PassFrameCount,
        }

        -- 每一秒触发的数量 {第几秒：数量}
        local TimeSecondInfos = {}
        -- 每一帧触发的数量 {第几帧：数量}
        local FrameCountInfos = {}
        -- 音效Id对应的播放数量 {ID: Num}
        local PlaySENums = {}
        -- 根据播放数量，排序LogicEventPlayer
        --- {
        ---     LogicEventPlayer:
        ---     {
        ---         {TotalNum：Num},
        ---         {ID：{ObjectName：Num}}
        ---     }
        --- }
        local LEPlaySEs = {}
        local SoundId = nil
        local LEPName = nil
        local OName = nil
        for _, PlaySEInfo in pairs(self.PlaySEs) do
            TimeSecondInfos[PlaySEInfo.TimeSecond] = (TimeSecondInfos[PlaySEInfo.TimeSecond] or 0) + 1
            FrameCountInfos[PlaySEInfo.FrameCount] = (FrameCountInfos[PlaySEInfo.FrameCount] or 0) + 1

            SoundId = PlaySEInfo.SoundId
            PlaySENums[SoundId] = (PlaySENums[SoundId] or 0) + 1

            LEPName = PlaySEInfo.LogicEventPlayerName
            OName = PlaySEInfo.ObjectName
            LEPlaySEs[LEPName] = LEPlaySEs[LEPName] or {}
            LEPlaySEs[LEPName].TotalNum = (LEPlaySEs[LEPName].TotalNum or 0) + 1
            LEPlaySEs[LEPName].Other = LEPlaySEs[LEPName].Other or {}
            LEPlaySEs[LEPName].Other[SoundId] = LEPlaySEs[LEPName].Other[SoundId] or {}
            LEPlaySEs[LEPName].Other[SoundId][OName] = (LEPlaySEs[LEPName].Other[SoundId][OName] or 0) + 1
        end
        -- 得到触发音效最多的一秒
        local MaxNum = 0
        for _, Num in pairs(TimeSecondInfos) do
            if Num > MaxNum then
                MaxNum = Num
            end
        end
        PlaySEProfileInfo["最高音效频率(每秒)"] = {
            ["一秒内最高音效次数"] = MaxNum,
        }
        -- 得到触发音效最多的一帧
        MaxNum = 0
        for _, Num in pairs(FrameCountInfos) do
            if Num > MaxNum then
                MaxNum = Num
            end
        end
        PlaySEProfileInfo["最高音效频率(每帧)"] = {
            ["单帧最高音效次数"] = MaxNum,
        }
        -- 根据音效ID调用频次，排序音频ID
        local SortPlaySENums = {}
        for SoundId, Num in pairs(PlaySENums) do
            table.insert(SortPlaySENums, {
                ["音效ID"] = SoundId,
                ["音效次数"] = Num,
                ["占音效数量百分比"] = tostring(math.floor(Num/TotalTime*100)) .. "%" ,
            })
        end
        table.sort(SortPlaySENums,  function(a, b)
            return a["音效次数"] > b["音效次数"]
        end)
        PlaySEProfileInfo["音效分布(按数量从高到底)"] = SortPlaySENums

        -- 根据播放数量，排序LogicEventPlayer
        local SortLEPlaySEs = {}
        for Name, Info in pairs(LEPlaySEs) do
            table.insert(SortLEPlaySEs, {
                ["播放来源"] = Name,
                ["音效总数量"] = Info.TotalNum,
                ["其他信息"] = Info.Other ,
            })
        end
        table.sort(SortLEPlaySEs,  function(a, b)
            return a["音效总数量"] > b["音效总数量"]
        end)
        PlaySEProfileInfo["音效分布(按播放来源触发数量从高到低)"] = SortLEPlaySEs
    end
    return PlaySEProfileInfo
end

function BattleProfile:GetFunctionCallInfo(PassTime, PassFrameCount)
    local TotalTime = self.FunctionCallInfos:Length()
    local FunctionCallProfileInfo = {}
    if TotalTime > 0 then
        local SortedFunctionCallInfos_Lua2Cpp = {}
        local SortedFunctionCallInfos_Lua2Blueprint = {}
        local SortedFunctionCallInfos_CppOrBlueprint2Lua = {}
        for _, FunctionCallInfo in pairs(self.FunctionCallInfos) do
            local FunctionCallInfoTable = {
                ["函数名"] = FunctionCallInfo.FunctionName,
                ["类型名"] = FunctionCallInfo.ClassName,
                ["调用次数"] = FunctionCallInfo.Times,
            }
            if FunctionCallInfo.Direction == "Lua2Cpp" then
                table.insert(SortedFunctionCallInfos_Lua2Cpp, FunctionCallInfoTable)
            elseif FunctionCallInfo.Direction == "Lua2Blueprint" then
                table.insert(SortedFunctionCallInfos_Lua2Blueprint, FunctionCallInfoTable)
            else
                table.insert(SortedFunctionCallInfos_CppOrBlueprint2Lua, FunctionCallInfoTable)
            end
        end

        table.sort(SortedFunctionCallInfos_Lua2Cpp,  function(a, b)
            return a["调用次数"] > b["调用次数"]
        end)
        table.sort(SortedFunctionCallInfos_Lua2Blueprint,  function(a, b)
            return a["调用次数"] > b["调用次数"]
        end)
        table.sort(SortedFunctionCallInfos_CppOrBlueprint2Lua,  function(a, b)
            return a["调用次数"] > b["调用次数"]
        end)

        FunctionCallProfileInfo["C++/蓝图->Lua 函数调用次数(从高到低)"] = SortedFunctionCallInfos_CppOrBlueprint2Lua
        FunctionCallProfileInfo["Lua->C++ 函数调用次数(从高到低)"] = SortedFunctionCallInfos_Lua2Cpp
        FunctionCallProfileInfo["Lua->蓝图 函数调用次数(从高到低)"] = SortedFunctionCallInfos_Lua2Blueprint
    end
    return FunctionCallProfileInfo
end

function BattleProfile:GetUPropertyCallInfo(PassTime, PassFrameCount)
    local TotalTime = self.PropertyCallInfos:Length()
    local PropertyCallProfileInfo = {}
    if TotalTime > 0 then
        local SortedPropertyCallInfos = {}
        for _, PropertyCallInfo in pairs(self.PropertyCallInfos) do
            local PropertyCallInfoTable = {
                ["Property名"] = PropertyCallInfo.PropertyName,
                ["Class名"] = PropertyCallInfo.ClassName,
                ["单次调用耗时（单位是CPU周期数）"] = PropertyCallInfo.TimeConsuming,
                ["调用次数"] = PropertyCallInfo.Times,
            }
            table.insert(SortedPropertyCallInfos, PropertyCallInfoTable)
        end
        
        table.sort(SortedPropertyCallInfos, function(a, b)
            return a["调用次数"] > b["调用次数"]
        end)

        PropertyCallProfileInfo["Lua到C++UProperty调用次数(从高到低)"] = SortedPropertyCallInfos
    end
    return PropertyCallProfileInfo
end

local function GetKvString(Key, Value)
    return string.format("%s: %s", tostring(Key), tostring(Value))
end

function BattleProfile:GetBuffChangedInfo(PassTime, PassFrameCount)
    local ResultTable = {}

    local TotalTime = self.BuffsChangedInfos:Length()
    local BuffChangedInfo = {}
    BuffChangedInfo["1. BuffsChanged调用总次数"] = TotalTime
    if TotalTime > 0 then 
        local TimePerSecond = TotalTime / PassTime
        BuffChangedInfo["2. 平均BuffsChanged调用次数"] = {
            ["每秒"] = TotalTime / PassTime,
            ["每帧"] = TotalTime / PassFrameCount,
        }

        -- BuffChanged 频率每秒
        local TimeSecondInfos = {}
        local FrameCountInfos = {}
        local TotalPropIdCount = {}

        local FrameCountToTimeSecond = {}
        for _, BuffChangedInfo in pairs(self.BuffsChangedInfos) do
            local TimeSecond = BuffChangedInfo.TimeSecond
            local FrameCount = BuffChangedInfo.FrameCount

            -- DebugPrint("Tianyi@ TimeSecond: " .. tostring(TimeSecond) .. " FrameCount: " .. tostring(FrameCount))   

            local CurTimeSecondInfos = TimeSecondInfos[TimeSecond] or {}
            local CurFrameCountInfos = FrameCountInfos[FrameCount] or {}       
            CurTimeSecondInfos.PropIdCount = CurTimeSecondInfos.PropIdCount or {}
            CurFrameCountInfos.PropIdCount = CurFrameCountInfos.PropIdCount or {}


            CurTimeSecondInfos.TriggerCount = (CurTimeSecondInfos.TriggerCount or 0) + 1
            CurFrameCountInfos.TriggerCount = (CurFrameCountInfos.TriggerCount or 0) + 1
            FrameCountToTimeSecond[FrameCount] = TimeSecond

            for Index, Id in pairs(BuffChangedInfo.BuffPropIds) do 
                CurTimeSecondInfos.PropIdCount[Id] = (CurTimeSecondInfos.PropIdCount[Id] or 0) + 1
                CurFrameCountInfos.PropIdCount[Id] = (CurFrameCountInfos.PropIdCount[Id] or 0) + 1
                TotalPropIdCount[Id] = (TotalPropIdCount[Id] or 0) + 1
            end

            TimeSecondInfos[TimeSecond] = CurTimeSecondInfos
            FrameCountInfos[FrameCount] = CurFrameCountInfos
        end

        local MaxNumPS = 0  -- 最大一秒
        local AvgNumPS = 0  -- 平均每秒
        local MidNumPS = 0  -- 中位每秒
        local MidNumPSArr = {}
        local MaxNumPSIndex = 0
        for TimeSecond, Info in pairs(TimeSecondInfos) do
            AvgNumPS = AvgNumPS + Info.TriggerCount
            if Info.TriggerCount > MaxNumPS then
                MaxNumPS = Info.TriggerCount
                MaxNumPSIndex = TimeSecond
            end
            table.insert(MidNumPSArr, Info.TriggerCount)
        end
        AvgNumPS = AvgNumPS / #MidNumPSArr

        table.sort(MidNumPSArr, function(a, b)
            return a < b
        end)
        -- DebugPrint("Tianyi@ TimeSecondInfos Length: " .. tostring(#TimeSecondInfos))
        MidNumPS = MidNumPSArr[math.max(1, math.ceil(#MidNumPSArr/2))]


        -- Buff频率每帧
        local MaxNumPF = 0
        local AvgNumPF = 0  -- 平均每帧
        local MidNumPF = 0  -- 中位每帧
        local MidNumPFArr = {}
        local MaxNumPFIndex = 0
        for FrameCount, Info in pairs(FrameCountInfos) do
            AvgNumPF = AvgNumPF + Info.TriggerCount
            if Info.TriggerCount > MaxNumPF then
                MaxNumPF = Info.TriggerCount
                MaxNumPFIndex = FrameCount
            end

            table.insert(MidNumPFArr, Info.TriggerCount)
        end
        AvgNumPF = AvgNumPF / #MidNumPFArr
        table.sort(MidNumPFArr, function(a, b)
            return a < b
        end)
        MidNumPF = MidNumPFArr[math.max(1, math.ceil(#MidNumPFArr/2))]

        BuffChangedInfo["3. 最高BuffsChanged调用频率(每秒)"] = {
            ["一秒内最高BuffsChanged调用次数"] = MaxNumPS,
            ["出现在开始Profile的秒数"] = MaxNumPSIndex,
        }
        BuffChangedInfo["4. 最高BuffsChanged调用频率(每帧)"] = {
            ["单帧最高BuffsChanged调用次数"] = MaxNumPF,
            ["出现在开始Profile的秒数"] = FrameCountToTimeSecond[MaxNumPFIndex],
        }

        -- BuffChanged 频率分布
        BuffChangedInfo["5. BuffsChanged调用频率分布"] = {
            string.format("单帧最高BuffsChanged调用次数: %s", tostring(MaxNumPF)),
            string.format("出现在开始Profile的秒数: %s", tostring(FrameCountToTimeSecond[MaxNumPFIndex])),
            string.format("平均每帧: %s", tostring(AvgNumPF)),
            string.format("中位每帧: %s", tostring(MidNumPF))
        }

        table.sort(TotalPropIdCount, function(a, b)
            return a > b 
        end)


        BuffChangedInfo["6. Buff表头调用频率分布(从大到小)"] = {}
        local TotalPropIdCountOutput = {}
        for key, value in pairs(TotalPropIdCount) do
            table.insert(TotalPropIdCountOutput, {Id = key, Count = value})
        end
        table.sort(TotalPropIdCountOutput, function(a, b)
            return a.Count > b.Count
        end)

        local BuffPropNameTable = DataMgr.BuffConverts["BuffPropNameTable"]
        for _, Info in ipairs(TotalPropIdCountOutput) do
            table.insert(BuffChangedInfo["6. Buff表头调用频率分布(从大到小)"], BuffPropNameTable[Info.Id] .. ": " .. tostring(Info.Count) .. "次")    
        end

    end

    return BuffChangedInfo
end

return BattleProfile