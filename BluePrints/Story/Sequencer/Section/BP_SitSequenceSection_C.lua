local M = Class()

function M:LoadMontage(Character)
    if not Character then return end
    local MontageName = nil
    local MontagePrePath = "Interactive/"
    if self.SitMontageName then
        MontageName = self.SitMontageName.."_Montage"
    end
    
    local MontPath = Character:GetMontagePath(MontagePrePath, MontageName)
    return LoadObject(MontPath)
end

function M:StartSit(Character, bImmediate)
    if not Character then return end
    DebugPrint("WXT SitSection StartSit", Character.UnitId, bImmediate)
    Character:SetSitPoseWithoutInteractive(function()
        DebugPrint("WXT SitSection StartSit ->End", Character.UnitId, bImmediate)
    end, bImmediate, self:LoadMontage(Character))
end

function M:SitEnd(Character, bImmediate)
    if not Character then return end
    DebugPrint("WXT SitSection SitEnd", Character.UnitId, bImmediate)
    Character:RealSetIdlePoseBySpecialSit(function()
        DebugPrint("WXT SitSection SitEnd ->End", Character.UnitId, bImmediate)
    end, bImmediate)
end

function M:StartSitEnd(Character, bImmediate)
    if not Character then return end
    if not Character.IsSitting then
        Character:SetSitPoseWithoutInteractive(function()
            Character:RealSetIdlePoseBySpecialSit(function()
                DebugPrint("WXT SitSection SitEnd ->End", Character.UnitId, bImmediate)
            end, bImmediate)
        end, true, self:LoadMontage(Character))
    else
        Character:RealSetIdlePoseBySpecialSit(function()
            DebugPrint("WXT SitSection SitEnd ->End", Character.UnitId, bImmediate)
        end, bImmediate)
    end
end

return M