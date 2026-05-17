local M = {}

-- 定义的 c++ 委托，传递到 c++ 函数时：
-- 从 lua 构造委托，传递到 lua 重写的函数，还是 table 形式。
-- 从 c++ 构造委托，传递到 lua 重写的函数，还是 c++ 形式。
-- 因此提供该接口，供 lua 侧调用 c++ 委托。
function M:ExecuteStoryDelegate(StoryDelegate, ...)
    if (StoryDelegate) then
        if (StoryDelegate.Execute) then
            StoryDelegate:Execute(...)
        else
            if (StoryDelegate[1] and StoryDelegate[2]) then
                StoryDelegate[2](StoryDelegate[1], ...)
            end
        end
    end
end

return M
