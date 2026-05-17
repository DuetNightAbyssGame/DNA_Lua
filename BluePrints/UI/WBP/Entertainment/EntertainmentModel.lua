---@class EntertainmentModel :Model
local M = Class("BluePrints.Common.MVC.Model")
local Deque = require "BluePrints.Common.DataStructure".Deque
local EntertainmentUtil = require "BluePrints.UI.WBP.Entertainment.EntertainmentUtils"

--- @class WaitProcess_Entertainment
local WaitProcess = {}
WaitProcess.__metatable = {
    __index = WaitProcess
}
--- @return WaitProcess_Entertainment
function WaitProcess.New(...)
    local Obj = {}
    setmetatable(Obj, WaitProcess.__metatable)
    Obj:Init(...)
    return Obj
end

function WaitProcess:Init(...)
    self.Queue = Deque.New()
end

function WaitProcess:AddProcess(Task)
    self.Queue:PushBack(Task)
end

function WaitProcess:NextTask()
    if not self.bIsApply then return end
    local Task = self.Queue:PopFront()
    Task(function()
        if self.Queue:IsEmpty() then
            self.bIsApply = false
            return 
        end
        self:NextTask()
    end)
end

function WaitProcess:ApplyTask()
    if self.Queue:IsEmpty() or self.bIsApply then
        return
    end
    self.bIsApply = true
    self:NextTask()
end

function WaitProcess:Stop()
    self.bIsApply = false
end

function M:Init()
    M.Super.Init(self)
    self:RefreshRedState()
    EventManager:AddEvent(EventID.OnNewCharObtained, self, self.OnNewCharObtained)
    EventManager:AddEvent(EventID.OnCharDeleted, self, self.OnCharDeleted)
    EventManager:AddEvent(EventID.CloseLoading, self, self.TryListenEvent)
end

function M:TryListenEvent()
    local Avatar = self:GetAvatar()
    local bIsInBigWorld = Avatar and Avatar:IsInBigWorld()
    local bIsInHomeBase = Avatar and Avatar:CheckSubRegionType(Avatar:GetCurrentRegionId(), CommonConst.SubRegionType.Home)
    if Avatar and bIsInBigWorld and bIsInHomeBase then 
        -- 只在据点刷新，因为涉及Condition、物品一类的刷新才解锁角色红点的情况，触发时机多，并且每次都要刷新所有角色，可能很耗
        -- 所以暂时只在据点才刷新（据点才能使用邀约）
        EventManager:AddEvent(EventID.OnResourcesChanged, self, self.RefreshRedState)
        EventManager:AddEvent(EventID.QuestChainFinished, self, self.RefreshRedState)
        EventManager:AddEvent(EventID.OnPropSetResources, self, self.RefreshRedState)
    end
end

function M:Destory()
    M.Super.Destory(self)
    EventManager:RemoveEvent(EventID.OnNewCharObtained, self)
    EventManager:RemoveEvent(EventID.OnCharDeleted, self)
    EventManager:RemoveEvent(EventID.OnResourcesChanged, self)
    EventManager:RemoveEvent(EventID.QuestChainFinished, self)
    EventManager:RemoveEvent(EventID.OnPropSetResources, self)
    if self.WaitQueue then
        self.WaitQueue:Stop()
        self.WaitQueue = nil
    end
end

function M:OnNewCharObtained(CharUuid)
    self:RefreshCharReddot(CharUuid)
end

function M:OnCharDeleted(CharUuid)
    self:RefreshCharReddot(CharUuid)
end

function M:GetCharNodeName()
    if not self._NodeName then
        self._NodeName = DataMgr.ReddotNode.Entertainment_Char.Name
    end
    return self._NodeName
end



function M:RefreshCharReddot(Uuid)
    local NodeName = self:GetCharNodeName()
    if not ReddotManager.GetTreeNode(NodeName) then
        ReddotManager.AddNodeEx(NodeName)
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
    if not EntertainmentUtil:IsCharacterShowRedDot(Uuid) then
        if CacheDetail[Uuid] then
            ReddotManager.DecreaseLeafNodeCount(NodeName, 1)
        end
        CacheDetail[Uuid] = nil
    else
        if not CacheDetail[Uuid] then
            ReddotManager.IncreaseLeafNodeCount(NodeName, 1)
        end
        CacheDetail[Uuid] = true
    end
end

function M:RefreshRedState()
    local Avatar = self:GetAvatar()
    if not Avatar then return end
    local AllChars = Avatar.PartyNpcs
    for Uuid, Char in pairs(AllChars) do
        self:RefreshCharReddot(Uuid)
    end
end
--- @return WaitProcess_Entertainment
function M:TryGetWaitQueue()
    if self.WaitQueue then
        self.WaitQueue:Stop()
    end
    self.WaitQueue = WaitProcess.New()
    return self.WaitQueue
end

return M