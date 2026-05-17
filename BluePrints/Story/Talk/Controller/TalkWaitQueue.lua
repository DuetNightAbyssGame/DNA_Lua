---@class TalkWaitQueue_C
local TalkWaitQueue_C = {}

---@param GroupTag string
---@param TalkWaitQueueManager TalkWaitQuqueManager_C
---@param Obj table
---@param Func function
TalkWaitQueue_C.New = function(GroupTag,TalkWaitQueueManager,QueueFinished_Obj, QueueFinished_Func, ...)
    ---@type TalkWaitQueue_C
    local Obj = {}
    setmetatable(Obj, {
        __index = TalkWaitQueue_C
    })

    Obj.GroupTag = GroupTag
    Obj.TalkWaitQueueManager = TalkWaitQueueManager
    Obj.QueueFinished_Callback = {QueueFinished_Obj, QueueFinished_Func, table.pack(...)}
    Obj.Queue = {}
    Obj.QueueItemCount = 0
    Obj.CompleteCount = 0
    Obj.bClosed = false
    Obj.bCompleted = false
    return Obj
end

function TalkWaitQueue_C:ResetWaitQueue()
    if (not self.TalkWaitQueueManager:CheckWaitQueueValid(self.GroupTag, self)) then
        return self
    end
    self.Queue = {}
    self.QueueItemCount = 0
    self.CompleteCount = 0
    self.bCompleted = false
    return self
end

---@param UniqueTag any
function TalkWaitQueue_C:RegiserWaitItem(UniqueTag)
    if(not self.TalkWaitQueueManager:CheckWaitQueueValid(self.GroupTag,self))then
        return self
    end
    DebugPrint("RegisterWaitItem",UniqueTag)
    self.Queue[UniqueTag] = false
    self.QueueItemCount = self.QueueItemCount + 1
    return self
end

---@param UniqueTag any
function TalkWaitQueue_C:CompleteWaitItem(UniqueTag)
    if(not self.TalkWaitQueueManager:CheckWaitQueueValid(self.GroupTag,self))then
        return self
    end
    if (self.bClosed) then
        return self
    end
    DebugPrint("CompleteWaitItem",UniqueTag,self.Queue[UniqueTag])
    if (self.Queue[UniqueTag] == false) then
        self.Queue[UniqueTag] = true
        self.CompleteCount = self.CompleteCount + 1
    end
    self:TryCompleteWaitQueue()
    return self
end

function TalkWaitQueue_C:TryCompleteWaitQueue()
    if self.CompleteCount == self.QueueItemCount then
        if self.bCompleted then
            --DebugPrint("TalkWaitQueue_C:CompleteWaitItem: self.bCompleted == true")
            return self
        end
        self.bCompleted = true
        local QueueFinished_Obj, QueueFinished_Func, QueueFinished_Params = table.unpack(self.QueueFinished_Callback)
        if(QueueFinished_Func) then
            QueueFinished_Func(QueueFinished_Obj, table.unpack(QueueFinished_Params))
        end
    end
end

function TalkWaitQueue_C:IsTagOnlyUncompleted(UniqueTag)
    if self.Queue[UniqueTag] == true then
        return false
    end
    if self.QueueItemCount - self.CompleteCount == 1 then
        return true
    end

    return false
end

function TalkWaitQueue_C:CloseWaitQueue()
    if(not self.TalkWaitQueueManager:CheckWaitQueueValid(self.GroupTag,self))then
        return self
    end
    self.bClosed = true
    return self
end

---@param UniqueTag any
function TalkWaitQueue_C:AddWaitItemToWaitQueue(UniqueTag)
    if(not self.TalkWaitQueueManager:CheckWaitQueueValid(self.GroupTag, self))then
        DebugPrint("TalkWaitQueue_C:AddWaitItemToWaitQueue: CheckWaitQueueValid fail")
        return
    end
    if self.Queue[UniqueTag] ~= nil then
        DebugPrint("TalkWaitQueue_C:AddWaitItemToWaitQueue: self.Queue[UniqueTag] already existed", UniqueTag)
        return
    end
    self.Queue[UniqueTag] = false
    self.QueueItemCount = self.QueueItemCount + 1
    if self.CompleteCount == self.QueueItemCount then
        local QueueFinished_Obj, QueueFinished_Func, QueueFinished_Params = table.unpack(self.QueueFinished_Callback)
        if(QueueFinished_Func) then
            QueueFinished_Func(QueueFinished_Obj, table.unpack(QueueFinished_Params))
        end
    end
end

---@param UniqueTag any
function TalkWaitQueue_C:DeleteWaitItemInWaitQueue(UniqueTag)
    if(not self.TalkWaitQueueManager:CheckWaitQueueValid(self.GroupTag, self))then
        DebugPrint("TalkWaitQueue_C:DeleteWaitItemInWaitQueue: CheckWaitQueueValid fail")
        return
    end
    if self.Queue[UniqueTag] == nil then
        DebugPrint("TalkWaitQueue_C:AddWaitItemToWaitQueue: self.Queue[UniqueTag] is unexisted", UniqueTag)
        return
    end
    if self.Queue[UniqueTag] == true then
        self.CompleteCount = self.CompleteCount - 1
    end
    self.Queue[UniqueTag] = nil
    self.QueueItemCount = self.QueueItemCount - 1
    if self.CompleteCount == self.QueueItemCount then
        local QueueFinished_Obj, QueueFinished_Func, QueueFinished_Params = table.unpack(self.QueueFinished_Callback)
        if(QueueFinished_Func) then
            QueueFinished_Func(QueueFinished_Obj, table.unpack(QueueFinished_Params))
        end
    end
end


---@class TalkWaitQueueManager_C
local TalkWaitQueueManager_C = {}
TalkWaitQueueManager_C.New = function()
    ---@type TalkTimerManager_C
    local Obj = setmetatable({}, {
        __index = TalkWaitQueueManager_C
    })
    ---@type table<any,table<TalkWaitQueue_C,boolean>>
    Obj.WaitQueueMap = {}
    return Obj
end

---@param GroupTag any
---@param RegisterList table<number,any>
---@param Obj any
---@param Func function
function TalkWaitQueueManager_C:CreateWaitQueue(GroupTag,RegisterList,Obj, Func, ...)
    local WaitQueue = TalkWaitQueue_C.New(GroupTag, self,Obj,Func, ...)
    local WaitQueueMap = self.WaitQueueMap
    WaitQueueMap[GroupTag] = WaitQueueMap[GroupTag] or {}
    WaitQueueMap[GroupTag][WaitQueue] = true

    for _,RegisterInfo in ipairs(RegisterList) do
        if(not RegisterInfo.Condition or RegisterInfo.Condition())then
            WaitQueue:RegiserWaitItem(RegisterInfo.Tag)
        end
    end
    return WaitQueue
end

---@param GroupTag any
function TalkWaitQueueManager_C:ClearGroup(GroupTag)
    self.WaitQueueMap[GroupTag] = nil
end

function TalkWaitQueueManager_C:CheckWaitQueueValid(GroupTag, WaitQueue)
    if (self.WaitQueueMap[GroupTag] and self.WaitQueueMap[GroupTag][WaitQueue]) then
        return true
    end
    return false
end


-- ---@param GroupTag any
-- ---@param WaitQueue TalkWaitQueue_C
-- function TalkWaitQueueManager_C:ResetWaitQueue(GroupTag,WaitQueue)
--     if((self.WaitQueueMap[GroupTag] or {})[WaitQueue or {}] == nil)then
--         return
--     end
--     WaitQueue:ResetWaitQueue()
-- end

-- ---@param GroupTag any
-- ---@param WaitQueue TalkWaitQueue_C
-- ---@param ItemTag any
-- function TalkWaitQueueManager_C:RegiserWaitItem(GroupTag,WaitQueue,ItemTag)
--     DebugPrint("RegiserWaitItem",GroupTag,WaitQueue,ItemTag)
--     DebugPrintTable(self.WaitQueueMap,3)
--     if((self.WaitQueueMap[GroupTag] or {})[WaitQueue or {}] == nil)then
--         return
--     end
--     WaitQueue:RegiserWaitItem(ItemTag)
-- end

-- ---@param GroupTag any
-- ---@param WaitQueue TalkWaitQueue_C
-- ---@param ItemTag any
-- function TalkWaitQueueManager_C:CompleteWaitItem(GroupTag,WaitQueue,ItemTag)
--     if((self.WaitQueueMap[GroupTag] or {})[WaitQueue or {}] == nil)then
--         return
--     end
--     WaitQueue:CompleteWaitItem(ItemTag)
-- end

-- ---@param GroupTag any
-- ---@param WaitQueue TalkWaitQueue_C
-- function TalkWaitQueueManager_C:CloseWaitQueue(GroupTag,WaitQueue)
--     if((self.WaitQueueMap[GroupTag] or {})[WaitQueue or {}] == nil)then
--         return
--     end
--     WaitQueue:CloseWaitQueue()
-- end

-- ---@param GroupTag any
-- ---@param WaitQueue TalkWaitQueue_C
-- function TalkWaitQueueManager_C:RemoveWaitQueue(GroupTag,WaitQueue)
--     if(self.WaitQueueMap[GroupTag]) then
--         self.WaitQueueMap[GroupTag][WaitQueue] = nil
--     end
-- end



return {
    TalkWaitQueue_C = TalkWaitQueue_C,
    TalkWaitQueueManager_C = TalkWaitQueueManager_C
}
