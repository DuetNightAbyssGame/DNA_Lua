local M = Class()

-- 兼容旧接口，内部改为计数器实现
function M:SetInSkip(bInSkip)
    if bInSkip then
        self:EnterSkip()
    else
        self:ExitSkip()
    end
end

-- 进入 skip 状态，计数加一
function M:EnterSkip()
    self.SkipCount = (self.SkipCount or 0) + 1
end

-- 退出 skip 状态，计数减一（用于嵌套场景）
function M:ExitSkip()
    self.SkipCount = math.max(0, (self.SkipCount or 1) - 1)
end

-- 彻底清除 skip 状态（保底清理）
function M:ClearSkip()
    self.SkipCount = 0
end

function M:IsInSkip()
    return (self.SkipCount or 0) > 0
end

return M