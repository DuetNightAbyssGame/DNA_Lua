
local FSM = {}
FSM.__index = FSM
FSM._InvalidState = {Name = ""}
local DataStructure      = require "BluePrints.Common.DataStructure"

local OnStateChanged
local CheckIsStateValid
local OnPeakInvalidState
local PeakUntilValidRecursion
local PopUntilValidRecursion

--region public

FSM.Operation = {Push = 0,Pop = 1}

function FSM:New(Owner,Params)
	local Obj = setmetatable({}, self)
	Obj:Init(Owner,Params or {})
	return Obj
end

function FSM:Init(Owner,Params)
    self._Owner = Owner
    self._StateDeque = DataStructure.Deque.New()
    self._MaxSize = Params.MaxSize or 100                   --大小，超过该大小时移除最早加入的状态
    self._StateNames = Params.StateNames or {}              --所有状态名称，暂时没用
    self._OnStateChanged = Params.OnStateChanged            --状态改变通知: function(Owner,NewState,OldState,Operation)
    self._CheckFunction = Params.CheckFunction              --状态合法性检测函数 function(Owner,State)
    self._OnPeakInvalidState = Params.OnPeakInvalidState    --Peak到不合法状态时的回调，为空时使用默认函数（会移除非法状态）function(Owner,State)
    self._SupportNilState = false                           --是否支持空状态
    self._bReplaceSameState = true                          --是否替换相同的状态，true则替换并且不会通知状态改变
end

---获取一个不可用的状态
function FSM:GetInvalidState()
    return self._InvalidState
end

function FSM:Clear()
    self._StateDeque:Init()
end

---@param State table 
function FSM:Push(State)
    local OldState = self._StateDeque:Back() or self:GetInvalidState()
    local OldStateName = OldState.Name
    local NewStateName = State and State.Name
    if(not self._SupportNilState)then
        if(State == nil or State.Name == nil)then
            DebugPrint("Error: FSM Push State Fail! Reason: State or State Name is nil!")
            return
        end
    end
    if(self._bReplaceSameState)then
        if(NewStateName == OldStateName)then
            self._StateDeque:PopBack()
        end
    end
    self._StateDeque:PushBack(State)
    if(OldStateName ~= NewStateName)then
        OnStateChanged(self,State,OldState,self.Operation.Push)
    end
    if(self._StateDeque:Size() > self._MaxSize)then
        return self._StateDeque:PopFront()
    end
end

function FSM:NativePeak()
    return self._StateDeque:Back() or self:GetInvalidState()
end

function FSM:NativePop()
    local OladState = self._StateDeque:PopBack() or self:GetInvalidState()
    local OldStateName = OladState.Name
    if(not self._SupportNilState)then
        if(OladState == nil or OldStateName == nil)then
            DebugPrint("Warning: FSM Pop Nil State!")
        end
    end
    local NewState = self._StateDeque:Back() or self:GetInvalidState()
    local NewStateName = NewState.Name
    if(OldStateName ~= NewStateName)then
        OnStateChanged(self,NewState,OladState,self.Operation.Pop)
    end
    return OladState
end

function FSM:Peak()
    if(self._StateDeque:Size() <= 0)then
        return self:GetInvalidState()
    end
    local State = self._StateDeque:Back()
    local IsValidState = CheckIsStateValid(self,State)
    if(not IsValidState)then
        PeakUntilValidRecursion(self)
    end
    return self._StateDeque:Back() or self:GetInvalidState()
end

function FSM:Pop()
    if(self._StateDeque:Size() <= 0)then
        return self:GetInvalidState()
    end
    local OladState = self._StateDeque:PopBack() or self:GetInvalidState()
    local OldStateName = OladState.Name
    local IsValidState = CheckIsStateValid(self,OladState)
    if(not IsValidState)then
        PopUntilValidRecursion(self)
    end
    local NewState = self._StateDeque:Back() or self:GetInvalidState()
    local NewStateName = NewState.Name
    if(OldStateName ~= NewStateName)then
        OnStateChanged(self,NewState,OladState,self.Operation.Pop)
    end
    return OladState or self:GetInvalidState()
end

--TODO:支持前进后退

--endregion public

--region private

OnStateChanged = function(self,NewState,OldState,Operation)
    if(self._OnStateChanged)then
        self._OnStateChanged(self._Owner,NewState,OldState,Operation)
    end
end

CheckIsStateValid = function(self,State)
    if(self._CheckFunction)then
        return self._CheckFunction(self._Owner,State)
    end
    return true
end

OnPeakInvalidState = function(self,State)
    if(self._OnPeakInvalidState)then
        self._OnPeakInvalidState(self._Owner,State)
    else
        self._StateDeque:PopBack()
    end
end

PeakUntilValidRecursion = function(self)
    local State = self._StateDeque:Back()
    OnPeakInvalidState(self,State)
    if(self._StateDeque:Size() <= 0)then
        return self:GetInvalidState()
    end
    local IsValidState = CheckIsStateValid(self,self._StateDeque:Back())
    if(not IsValidState)then
        PeakUntilValidRecursion(self)
    end
end

PopUntilValidRecursion = function(self)
    self._StateDeque:PopBack()
    if(self._StateDeque:Size() <= 0)then
        return self:GetInvalidState()
    end
    local IsValidState = CheckIsStateValid(self,self._StateDeque:Back())
    if(not IsValidState)then
        return PopUntilValidRecursion(self)
    end
end

--endregion private

return FSM