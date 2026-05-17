local HotUpdateUtils = {}
local EMLuaConst = require("EMLuaConst")
local SettingUtils = require "Utils.SettingUtils"

-- 全局存储已积累的 NecessoryPatchSigns，跨 UI 生命周期持久存在
local _NecessoryPatchSigns = {}

---@param IncomingSigns table|userdata|nil
---@return table
function HotUpdateUtils.NormalizeNecessoryPatchSigns(IncomingSigns)
    if not IncomingSigns then
        return {}
    end
    local Signs = IncomingSigns
    if type(Signs) ~= "table" then
        if Signs.ToTable then
            Signs = Signs:ToTable()
        else
            return {}
        end
    end
    local Result = {}
    local Existing = {}
    for _, Sign in pairs(Signs) do
        if Sign and Sign ~= "" and not Existing[Sign] then
            table.insert(Result, Sign)
            Existing[Sign] = true
        end
    end
    return Result
end

--- 将传入的 NecessoryPatchSigns 与全局存储的进行合并去重，结果写回全局存储
---@param IncomingSigns table|nil 本次传入的必要 Patch ID 列表
function HotUpdateUtils.MergeNecessoryPatchSigns(IncomingSigns)
    if not EMLuaConst.bEnableOptionalPatch then
        _NecessoryPatchSigns = {}
        return
    end
    IncomingSigns = HotUpdateUtils.NormalizeNecessoryPatchSigns(IncomingSigns)
    if #IncomingSigns == 0 then
        return
    end
    local Existing = {}
    for _, v in ipairs(_NecessoryPatchSigns) do
        Existing[v] = true
    end
    for _, v in ipairs(IncomingSigns) do
        if v and not Existing[v] then
            table.insert(_NecessoryPatchSigns, v)
            Existing[v] = true
        end
    end
end

--- 获取全局存储的 NecessoryPatchSigns
---@return table
function HotUpdateUtils.GetNecessoryPatchSigns()
    if not EMLuaConst.bEnableOptionalPatch then
        _NecessoryPatchSigns = {}
    end
    return _NecessoryPatchSigns
end

--- 自动开始下载下一个必要分包（按 SortPriority 最小优先）
---@param WorldContextObject userdata
function HotUpdateUtils.TryAutoDownloadNextNecessoryPatch(WorldContextObject)
    local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(WorldContextObject, UHotUpdateSubsystem)
    if not HotUpdateSubsystem or HotUpdateSubsystem:IsCommonGameUpdating() or HotUpdateSubsystem:HasDownloadTask() then
        return
    end
    if not SettingUtils.GetEMCache("AutoBackground", nil, true) then
        return
    end
    local NecessoryPatchSigns = HotUpdateUtils.GetNecessoryPatchSigns()
    local UsePatchSigns = NecessoryPatchSigns
    if not NecessoryPatchSigns or #NecessoryPatchSigns == 0 then
        for PatchId, PatchData in pairs(DataMgr.PatchResource) do
            if PatchData and PatchData.SortPriority then
                table.insert(UsePatchSigns, PatchId)
            end
        end
        -- return
    end
    local BestSign = nil
    local BestPriority = math.huge
    for _, PatchId in ipairs(UsePatchSigns) do
        if not HotUpdateSubsystem:IsAllPatchOptionalSignsDownloaded({PatchId}) then
            local PatchData = DataMgr.PatchResource[PatchId]
            local Priority = (PatchData and PatchData.SortPriority) or 1e308
            if Priority < BestPriority then
                BestPriority = Priority
                BestSign = PatchId
            end
        end
    end
    if BestSign then
        HotUpdateSubsystem:TryStartUpdate(BestSign, {BestSign}, true)
    end
end

function HotUpdateUtils.IsCurrentNecessoryPatchSign(PatchSign)
    local NecessoryPatchSigns = HotUpdateUtils.GetNecessoryPatchSigns()
    if not NecessoryPatchSigns or #NecessoryPatchSigns == 0 then
        return false
    end
    local HotUpdateSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld, UHotUpdateSubsystem)
    if not HotUpdateSubsystem then
        return false
    end
    local BestSign = nil
    local BestPriority = math.huge
    for _, PatchId in ipairs(NecessoryPatchSigns) do
        if not HotUpdateSubsystem:IsAllPatchOptionalSignsDownloaded({PatchId}) then
            local PatchData = DataMgr.PatchResource[PatchId]
            local Priority = (PatchData and PatchData.SortPriority) or 1e308
            if Priority < BestPriority then
                BestPriority = Priority
                BestSign = PatchId
            end
        end
    end
    return BestSign == PatchSign
end

return HotUpdateUtils
