local FSM = {}
FSM.__index = FSM 

function FSM.New(Owner, States)
    local self = setmetatable({}, FSM)
    self.Owner = Owner
    self.CurrentState = nil 
    self.CurrentStateName = nil
    self.States = States
    return self
end

local FSMMethods = {}

function FSMMethods:Current()
    return self.CurrentStateName
end

function FSMMethods:Enter(NewState)
    if not self.States[NewState] then
        DebugPrint("Tianyi@  进入了不存在的状态")
        return 
    end

    if NewState == self.CurrentStateName then 
        return 
    end

    if self.CurrentState and self.CurrentState.OnLeave then 
        self.CurrentState.OnLeave(self.Owner, NewState)
    end

    self.CurrentStateName = NewState
    DebugPrint("Tianyi@ ControllerFSM 进入状态: ", self.CurrentStateName)
    self.CurrentState = self.States[NewState]

    if self.CurrentState.OnEnter then 
        self.CurrentState.OnEnter(self.Owner)
    end
    if self.CurrentState.OnAfterEnter then
        self.CurrentState.OnAfterEnter(self.Owner,NewState)
    end
end

function FSMMethods:Reset()
    self.CurrentStateName = nil
end

FSM.__index = FSMMethods

return FSM