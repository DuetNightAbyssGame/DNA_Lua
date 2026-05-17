local Component = {}

function Component:UpdateSuitKey2Value(SuitType, SuitSubType, SuitKey, SuitValue) ----- 对于一般的 只有key 和value 单
    if not self:CheckCurrentSubRegion() then return end
    local function Callback(Ret)
        -- self.logger.debug("ZJT_ ServerCallClient UpdateSuitKey2Value RET ", Ret)
    end
    self:CallServer("UpdateSuitKey2Value", Callback, SuitType, SuitSubType, SuitKey, SuitValue)
end

function Component:UpdateSuitKey2Table(SuitType, SuitSubType, SuitKey, ...)
    if not self:CheckCurrentSubRegion() then
        return
    end
    local Args = {...}
    local function Callback(Ret)
    end

    -- GlobalTable = {
    --     [1] = Callback1,
    -- }

    self:CallServer("UpdateSuitKey2Table", Callback, SuitType, SuitSubType, SuitKey, Args)
end

return Component