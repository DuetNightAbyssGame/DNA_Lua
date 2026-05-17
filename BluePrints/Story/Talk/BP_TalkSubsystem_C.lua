local M = Class({ "BluePrints.Common.TimerMgr" })

local ETalkType = require "BluePrints.Story.Talk.Base.ETalkType"
local ETaskState = require "BluePrints.Story.Talk.Base.ETaskState"
local ETaskCheckResult = require "BluePrints.Story.Talk.Base.ETaskCheckResult"
local ETalkInterruptType = require "BluePrints.Story.Talk.Base.ETalkInterruptType"
local FTalkTaskDataProcesser = Class("BluePrints.Story.Talk.Base.TalkTaskDataProcesser")
local FTalkInterruptComponent = Class("BluePrints.Story.Talk.Base.TalkInterruptComponent")
local TalkUtils = require "BluePrints.Story.Talk.View.TalkUtils"

local PauseLightTalkTypes = {
	[ETalkType.Guide] = true,
	[ETalkType.ForgingGuide] = true,
	[ETalkType.HintGuide] = true,
	[ETalkType.Bubble] = true,
	[ETalkType.Boss] = true,
	[ETalkType.AudioOnly] = true,
}

local DeathAffectTalkTypes = {
	ETalkType.Guide,
	ETalkType.HintGuide,
	ETalkType.QueueGuide,
	ETalkType.ForgingGuide,
	ETalkType.UnimportGuide,
}

function M:ReceiveInitialize()
	self.TalkTaskDataProcesser = FTalkTaskDataProcesser:New()
	self.TalkInterruptComponent = FTalkInterruptComponent:New()
	self.TalkTasks = {}
	self.TalkTaskDatas = {}
	self.TaskKeys = {}
	self.PausedTasks = {}
	self.PausedByTasks = {}
	self.RegisteredDatas = {}
	self.RegisteredDataKey = 0
	self.PauseAffectTaskTag = {}
	self:InitializeTaskTables()

	self.bPauseAdvance = false
	self.bGamePaused = false
	self.bPauseLightTask = false

	EventManager:AddEvent(EventID.CharRecover, self, self.OnPlayerRecover)
	EventManager:AddEvent(EventID.CharDie, self, self.OnPlayerDead)
end

function M:ReceiveDeinitialize()
	EventManager:RemoveEvent(EventID.CharRecover, self)
	EventManager:RemoveEvent(EventID.CharDie, self)

	self:CleanTimer()

	if (self.TalkTasks) then
		local TempTalkTasks = {}
		for _, Task in pairs(self.TalkTasks) do
			TempTalkTasks[_] = Task
		end
		for _, Task in pairs(TempTalkTasks) do
			Task:Clear()
		end
	end

	self.TalkTasks = {}
	self.TalkTaskDatas = {}
	self.PausedTasks = {}
	self.PausedByTasks = {}
	self.RegisteredDatas = {}
	self.TalkTaskDataProcesser:Clear()
	self.TalkInterruptComponent:Clear()
end

function M:PlayTalk(TalkConfigKey, TalkAction, AudioAttachActor)
	if (not TalkConfigKey) or (not TalkAction) then
		return false
	end

	local TalkEndCallback = function()
		if IsValid(TalkAction) and TalkAction.OnPlayTalkEnd then
			TalkAction.OnPlayTalkEnd:Broadcast()
		end
	end

	DebugPrint("TS:PlayTalk", TalkConfigKey, TalkAction)
	local TalkData = self:GetRegisteredTalkData(TalkConfigKey)
	if TalkData then
		TalkData.AudioAttachActor = AudioAttachActor
		self:RegisterTalkTask(TalkConfigKey, TalkEndCallback)
		return true
	end

	local TalkTriggerInfo = DataMgr.TalkTrigger[TalkConfigKey]
	if not TalkTriggerInfo then
		local TalkContext = GWorld.GameInstance:GetTalkContext()
		TalkContext:StartTalk(nil, TalkConfigKey .. ".story", TalkConfigKey, nil, nil, { Func = TalkEndCallback, Obj = TalkAction }, nil)
		return true
	end

	if TalkTriggerInfo.StoryLinePath then
		local TalkContext = GWorld.GameInstance:GetTalkContext()
		if TalkContext then
			TalkContext:StartTalk(TalkConfigKey, nil, nil, nil, nil, { Func = TalkEndCallback, Obj = TalkAction })
			return true
		end
	else
		local RawData = {
			AudioAttachActor = AudioAttachActor,
			TalkType = TalkTriggerInfo.TalkType,
			FirstDialogueId = TalkTriggerInfo.DialogueId,
			BlendInTime = 0.5,
			BlendOutTime = 0.5,
		}
		local Key = self:RegisterTalkData(RawData)
		self:RegisterTalkTask(Key, TalkEndCallback)
		return true
	end

	return false
end

function M:RegisterTalkTask(Key, OnTalkEndCallback, OnFailCallback)
	local TalkTask, TalkTaskData = self:CreateTalkTaskData(Key)
	TalkTask.OnTalkEndCallback = OnTalkEndCallback
	TalkTask.OnFailCallback = OnFailCallback

	if self.bPauseAdvance then
		self:DelayRegisterTask(Key, TalkTask)
	else
		self:RegisterTalkTaskInternal(Key, TalkTask)
	end
end

function M:ForceInterruptTalk(TalkTask)
	DebugPrint("@@@ ForceInterruptTalk 调用强制中断对话接口", TalkTask)
	if not self:CheckTalkCanBeInterrupted(TalkTask) then
		DebugPrint("@@@ 对话无法被打断", TalkTask)
		return
	end
	self:OnTaskInterrupted(TalkTask)
end

function M:ForceInterruptTalkTaskData(CheckFunc)
	DebugPrint("@@@ ForceInterruptTalkTaskData 调用强制中断对话接口", CheckFunc)
	local Tasks = self:GetAllTasks()

	local CopyTasks = {}
	for _, Task in pairs(Tasks) do
		CopyTasks[_] = Task
	end

	for _, Task in pairs(CopyTasks) do
		local TaskData = self:GetTaskDataFromTalkTask(Task)
		if TaskData then
			if CheckFunc(TaskData) then
				self:ForceInterruptTalk(Task)
			end
		end
	end
end

function M:ForceInterruptAllTalks()
	DebugPrint("@@@ ForceInterruptAllTalks 调用强制中断所有对话接口")
	self:ForceInterruptTalkTaskData(function(TalkTaskData)
		return true
	end)
end

function M:InterruptAllLightTask()
	local LightTaskMap = {
		AudioOnly = true,
		Boss = true,
		Bubble = true,
		ForgingGuide = true,
		Guide = true,
		HintGuide = true,
		QueueGuide = true,
		UnimportGuide = true,
	}
	self:ForceInterruptTalkTaskData(function(TalkTaskData)
		return LightTaskMap[TalkTaskData.TalkType]
	end)
end

function M:ForcePauseTalk(Task, Pauser)
	DebugPrint("@@@ 调用强制暂停对话接口", Task, Pauser)
	self:RecordPausedTasks(Pauser, Task)
	self:OnDifferentStateTaskPaused(Task)
	self:MoveTaskState(Task, ETaskState.Paused)
end

function M:TryResumePauseTalk(Pauser)
	DebugPrint("@@@ 尝试恢复被暂停的Talk", Pauser)
	local Tasks = self:GetPausedTasks(Pauser) or {}
	self:RemovePausedTasks(Pauser)
	for Task, _ in pairs(Tasks) do
		self:OnDifferentLastStateTaskPauseResumed(Task)
	end
end

function M:TryAdvanceTaskQueue()
	DebugPrint("@@@ TS:TryAdvanceTaskQueue 尝试推动队列中的下一个TalkTask")
	local NextTask
	for _, Type in pairs(ETalkType) do
		local TQ = self:GetTasksQueue(ETaskState.Queue, Type)
		for _, Task in pairs(TQ) do
			NextTask = Task
			break
		end
		if NextTask then
			break
		end
	end

	if NextTask then
		DebugPrint("@@@ TS:TryAdvanceTaskQueue 下一个TalkTask存在，尝试Working", NextTask)
		self:TryWorkingTask(NextTask)
	end
end

function M:RegisterTalkData(TalkData)
	self.RegisteredDataKey = self.RegisteredDataKey + 1
	local Key = self.RegisteredDataKey
	self.RegisteredDatas[Key] = TalkData
	DebugPrint("@@@ 注册任务数据", TalkData, Key)
	return Key
end

function M:UnregisterTalkData(Key)
	if (not Key) then
		return
	end
	self.RegisteredDatas[Key] = nil
end

function M:ForceSetStorySkipable(bSet)
	local Avatar = GWorld:GetAvatar()
	if Avatar then
		Avatar.bForceSetStorySkipable = bSet
	end
end

function M:GetForceStorySkipable()
	local Avatar = GWorld:GetAvatar()
	if Avatar then
		return Avatar.bForceSetStorySkipable
	else
		return false
	end
end

function M:ExceptionInterruptTaskBySTL(Key)
	if not Key then
		return
	end
	local TalkTask = self.TalkTasks[Key]
	if not TalkTask then
		return
	end
	DebugPrint("TS:ExceptionInterruptTaskBySTL", TalkTask, Key)

	TalkTask:OnExceptionInterruptedBySTL()

	-- Guide任务特殊处理：Guide的被STL打断规则是异步的，因此此时不应先清除引用，等其异步结束后清理
	if TalkTask:GetBasicTalkType() ~= ETalkType.Guide then
		self:MoveTaskState(TalkTask, ETaskState.Finished)
		self:ClearRefs(TalkTask)
	end
	self:TryFireLeaveStoryEvent()
end

--Debug接口
function M:GetAllWorkingTaskDebugLogs()
	local Tasks = self:GetAllTasks()
	local Res = {}
	for _, Task in pairs(Tasks) do
		if Task:GetState() == ETaskState.Working then
			table.insert(Res, Task:GetDebugMetaInfo())
		end
	end
	return Res
end

------------------外部可调用接口-------------------

------------------初始化函数-------------------
function M:InitializeTaskTables()
	for _, Type in pairs(ETalkType) do
		for _, State in pairs(ETaskState) do
			self[State .. "TasksOf" .. Type] = {}
		end
	end
end

------------------初始化函数-------------------






------------------流程函数-------------------
function M:RegisterTalkTaskInternal(Key, TalkTask)
	DebugPrint("@@@ RegisterTalkTaskInternal", Key, TalkTask)
	local CheckRes = self:CheckCanRegisterTask(TalkTask, TalkTask.TaskData)
	if CheckRes ~= ETaskCheckResult.Succeed then
		self:OnCannotRegisterTask(CheckRes)
		if TalkTask.OnFailCallback then
			TalkTask.OnFailCallback()
		end
		return
	end

	self:RecordTalkTaskAndData(TalkTask, TalkTask.TaskData, Key)
	self:MoveTaskState(TalkTask, ETaskState.Default)
	self:TryWorkingTask(TalkTask)
end

function M:DelayRegisterTask(Key, TalkTask)
	self.DelayRegisterQueue = self.DelayRegisterQueue or {}
	self.DelayRegisterQueue[Key] = TalkTask
end

function M:GetDelayRegisterTasks()
	return self.DelayRegisterQueue
end

function M:RemoveDelayRegisterTasks()
	self.DelayRegisterQueue = nil
end

function M:StartRegisterTasks(DelayRegisterQueue)
	if not DelayRegisterQueue then
		return
	end
	for Key, TalkTask in pairs(DelayRegisterQueue) do
		self:RegisterTalkTaskInternal(Key, TalkTask)
	end
end

function M:TryWorkingTask(TalkTask)
	local TaskData = self.TalkTaskDatas[TalkTask]
	if (not TaskData) then
		self:ClearRefs(TalkTask)
		return
	end
	DebugPrint("@@@ TS:尝试启动Talk", TalkTask, TaskData.TalkNodeName)

	if TalkTask:IsWorking() then
		DebugPrint("@@@ TS:Talk已在工作中", TalkTask, TaskData.TalkNodeName)
		return
	end

	if self:IsTaskShouldQueue(TalkTask, TaskData) then
		DebugPrint("@@@ TS:Task需排队，已加入队列中", TalkTask, TaskData.TalkNodeName)
		self:OnTaskQueued(TalkTask)
		return
	end

    if (self.bPauseLightTask and PauseLightTalkTypes[TalkTask:GetTalkType()]) then
        self:MoveTaskState(TalkTask, ETaskState.WaitGameUnpause)
	    return
    end

	self:WorkingTaskInternal(TalkTask)
end

function M:WorkingTaskInternal(TalkTask)
	DebugPrint("@@@ WorkingTaskInternal", TalkTask)
	self:ProcessTalkInterruptEvents(TalkTask)
	self:OnTaskWorking(TalkTask)

	local TalkTaskData = self.TalkTaskDatas[TalkTask]
	TalkTask:StartWorking(TalkTaskData, { self, self.OnTaskFinished })

	self:ProcessDelayRegisterTasks()
end

function M:ProcessDelayRegisterTasks()
	--开始注册在打断过程中，由回调函数创建但被延迟注册的新Task，必须和ProcessTalkInterruptEvents配套使用
	local DelayRegisterTasks = self:GetDelayRegisterTasks()
	self:RemoveDelayRegisterTasks()
	self:StartRegisterTasks(DelayRegisterTasks)
end

function M:ProcessTalkInterruptEvents(TalkTask)
	DebugPrint("@@@ 处理TalkTask的Interrupt关系", TalkTask)
	--延迟新TalkTask注册，防止打断过程中回调函数创建新Task与正在启动的Task冲突
	self.bPauseAdvance = true
	self:TasksInterruptedByTask(TalkTask)
	self.bPauseAdvance = false

	self:TasksPausedByTask(TalkTask)
end

function M:TasksInterruptedByTask(InstigatorTask)
	DebugPrint("@@@ 尝试打断其他对话", InstigatorTask)
	self:PreClearInterruptedTasks(InstigatorTask)
	local TalkType = InstigatorTask:GetTalkType()
	local InterruptTypes = self.TalkInterruptComponent:GetSpecificInterruptTypes(TalkType, ETalkInterruptType.Interrupt)
	for _, Type in pairs(InterruptTypes) do
		self:InterruptTaskQueue(ETaskState.Working, Type)
		self:InterruptTaskQueue(ETaskState.Paused, Type)
	end
end

function M:TasksPausedByTask(InstigatorTask)
	DebugPrint("@@@ 尝试暂停其他对话", InstigatorTask)
	local TalkType = InstigatorTask:GetTalkType()
	local InterruptTypes = self.TalkInterruptComponent:GetSpecificInterruptTypes(TalkType, ETalkInterruptType.Pause)
	for _, Type in pairs(InterruptTypes) do
		self:PauseTaskQueue(InstigatorTask, ETaskState.Working, Type)
		self:PauseTaskQueue(InstigatorTask, ETaskState.Paused, Type)
	end
end

function M:OnCannotRegisterTask(Reason)
	DebugPrint("@@@ 注册任务失败:", Reason)
end

function M:OnTaskWorking(TalkTask)
	DebugPrint("@@@ Talk开始工作", TalkTask)
	self:MoveTaskState(TalkTask, ETaskState.Working)
	self:TryFireEnterStoryEvent(TalkTask)
end

function M:OnTaskFinished(TalkTask, TaskFinishType, OptionIndex)
	DebugPrint("@@@ TalkTask执行结束", TalkTask)--Todo 补充打印信息
	self:MoveTaskState(TalkTask, ETaskState.Finished)
	self:OnTaskFinishedInternal(TalkTask, TaskFinishType, OptionIndex)
end

function M:OnTaskFinishedInternal(TalkTask, TaskFinishType, OptionIndex)
	DebugPrint("@@@ TS:OnTaskFinishedInternal", TalkTask, TaskFinishType, OptionIndex)
	self:TryResumePauseTalk(TalkTask)
	self:ClearRefs(TalkTask)
	self:TryFireLeaveStoryEvent()
	if TalkTask.OnTalkEndCallback then
		TalkTask.OnTalkEndCallback(TaskFinishType, OptionIndex)
	end
	if not self.bPauseAdvance then
		self:TryAdvanceTaskQueue()
	end
end

function M:OnTaskQueued(Task)
	DebugPrint("@@@ TS:OnTaskQueued", Task)
	self:MoveTaskState(Task, ETaskState.Queue)
end

function M:OnTaskInterrupted(Task)
	DebugPrint("@@@ TS:OnTaskInterrupted", Task)
	self:OnDifferentStateTaskInterrupted(Task)
	self:MoveTaskState(Task, ETaskState.Interrupted)
	self:ClearRefs(Task)
	if Task.OnTalkEndCallback then
		Task.OnTalkEndCallback()
	end
	self:TryFireLeaveStoryEvent()
end

function M:OnDifferentStateTaskInterrupted(Task)
	local State = Task:GetState()
	DebugPrint("@@@ OnDifferentStateTaskInterrupted", Task, State)
	if State == ETaskState.Working then
		Task:OnInterrupted()
	elseif State == ETaskState.Paused then
		Task:OnInterrupted()
	else
		DebugPrint("@@@ 无法打断除Working以外状态的对话", State, Task)
		return
	end
end

function M:OnDifferentStateTaskPaused(Task)
	DebugPrint("@@@ TS:OnDifferentStateTaskPaused", Task, Task:GetState())
	local State = Task:GetState()
	if State == ETaskState.Working then
		Task:OnPaused()
	elseif State == ETaskState.Paused then
	else
		DebugPrint("@@@ 无法暂停除Working以外状态的对话", State, Task)
		return
	end
end

function M:OnDifferentLastStateTaskPauseResumed(Task)
	DebugPrint("@@@ TS:OnDifferentLastStateTaskPauseResumed", Task)
	local State = Task:GetState()
	if State ~= ETaskState.Paused then
		DebugPrint("@@@ 无法恢复暂停除Paused以外状态的对话", State, Task)
		return
	end
	local Pausers = self:GetPausedByTasks(Task)
	if not IsEmptyTable(Pausers) then
		return
	end
	local LastState = Task:GetLastState()
	if LastState == ETaskState.Working then
		self:MoveTaskState(Task, ETaskState.Working)
		Task:OnPauseResumed()
	else
		DebugPrint("@@@ 无法恢复暂停原状态为Working以外的对话", LastState, Task)
		self:ClearRefs(Task)
		return
	end
end

function M:OnGamePauseChanged(bPaused)
	local GameModePauser = "GameModePause"
	if (bPaused) then
		self:PauseLightTalkTask(GameModePauser)
	else
		self:ResumeLightTalkTask(GameModePauser)
	end
end

local LightTaskPauser = "LightTaskPauser"
function M:PauseLightTalkTask(Pauser)
    DebugPrint("@@@ TalkSubsystem:PauseLightTalkTask", Pauser)
    local bPaused = not table.isempty(self.PauseAffectTaskTag)
    self.PauseAffectTaskTag[Pauser] = true
	self.bPauseLightTask = true
    if not bPaused then
        for Type, _ in pairs(PauseLightTalkTypes) do
            self:PauseTaskQueue(LightTaskPauser, ETaskState.Working, Type)
			self:PauseTaskQueue(LightTaskPauser, ETaskState.Paused, Type)			
        end
    end
end

function M:ResumeLightTalkTask(Pauser)
    DebugPrint("@@@ TalkSubsystem:ResumeLightTalkTask", Pauser)
    self.PauseAffectTaskTag[Pauser] = nil
    local bPaused = not table.isempty(self.PauseAffectTaskTag)

    if self.bPauseLightTask and (not bPaused) then
		self.bPauseLightTask = bPaused
        self:TryResumePauseTalk(LightTaskPauser)
		self:TryWorkingWaitGameUnpauseTasks()
    end
end

function M:TryWorkingWaitGameUnpauseTasks()
    for Type, _ in pairs(PauseLightTalkTypes) do
        local TaskQueue = self:GetTasksQueue(ETaskState.WaitGameUnpause, Type)
        local TempTaskQueue = {}
        for _, Task in pairs(TaskQueue) do
            TempTaskQueue[_] = Task
        end

        for _, Task in pairs(TempTaskQueue) do
            DebugPrint("@@@ TryWorkingWaitGameUnpauseTasks", Task, Type)
            self:TryWorkingTask(Task)
        end
    end
end

local DeathPauser = "DeathPause"
function M:OnPlayerDead()
	for _, Type in pairs(DeathAffectTalkTypes) do
		self:PauseTaskQueue(DeathPauser, ETaskState.Working, Type)
		self:PauseTaskQueue(DeathPauser, ETaskState.Paused, Type)
	end
end

function M:OnPlayerRecover()
	self:TryResumePauseTalk(DeathPauser)
end

------------------流程函数-------------------


---------------------内部开发提供函数-------------------
-- @return <Task,Task>
function M:GetTasksQueue(State, Type)
	self:CheckType(Type)
	return self[State .. "TasksOf" .. Type]
end

function M:GetRegisteredTalkData(Key)
	local Data = self.RegisteredDatas[Key]
	return Data
end

function M:GetTaskDataFromTalkTask(TalkTask)
	if (not TalkTask) then
		return
	end
	local TaskData = self.TalkTaskDatas[TalkTask]
	if not TaskData then
		return
	end

	return TaskData
end

function M:GetPausedTasks(Pauser)
	return self.PausedTasks[Pauser]
end

function M:GetPausedByTasks(Task)
	return self.PausedByTasks[Task]
end

function M:GetAllTasks()
	return self.TalkTasks
end

function M:RemovePausedTasks(Pauser, bRecursive)
	DebugPrint("@@@ 清除被暂停的TalkTask", Pauser, bRecursive)
	local Tasks = self:GetPausedTasks(Pauser)
	if (not Tasks) then
		return
	end

	for Task, _ in pairs(Tasks) do
		if (bRecursive) then
			self:RemovePausedTasks(Task, bRecursive)
		end
		self.PausedByTasks[Task][Pauser] = nil
	end

	self.PausedTasks[Pauser] = nil
end

function M:CheckType(Type)
	local bValid = Type and ETalkType[Type] ~= nil
	if not bValid then
		error("尝试访问非ETalkType中的Type，具体为" .. Type)
		return
	end
	return true
end

function M:CheckTalkCanBeInterrupted(TalkTask)
	--DebugPrint("@@@ 检查对话是否可被打断", TalkTask)

	local State = TalkTask:GetState()
	if State == ETaskState.Interrupted or
			State == ETaskState.Finished then

		--DebugPrint("@@@ 该状态TalkTask不可被打断",State)
		return false
	end

	return true
end

function M:IsTaskShouldQueue(TalkTask, TaskData)
	local TalkType = TalkTask:GetTalkType()
	local QueueTaskTypes = self.TalkInterruptComponent:GetSpecificInterruptTypes(TalkType, ETalkInterruptType.Queue)
	for _, Type in pairs(QueueTaskTypes) do
		local TQ = self:GetTasksQueue(ETaskState.Working, Type)
		if not IsEmptyTable(TQ) then
			return true
		end
	end
	return false
end
---------------------内部开发提供函数-------------------







------------------闲杂函数-------------------
function M:TryFireEnterStoryEvent(TalkTask)
	if not self.bInImmersiveTalk then
		self.bInImmersiveTalk = self:CheckInImmersiveTalk()
		DebugPrint("TS:TryFireEnterStoryEvent", self.bInImmersiveTalk)
		if self.bInImmersiveTalk then
			local TalkTaskData = self.TalkTaskDatas[TalkTask]
			EventManager:FireEvent(EventID.EnterImmersiveTalk, TalkTaskData and TalkTaskData.TalkTriggerId)
			if self.OnStoryBegin then
				self.OnStoryBegin:Broadcast()
			end
		end
	end
	if GWorld.GameInstance then
		DebugPrint("TS: 开TalkContext Tick")
		GWorld.GameInstance.bTalkContextTickable = true
	end
end

function M:TryFireLeaveStoryEvent()
	if self.bInImmersiveTalk then
		self.bInImmersiveTalk = self:CheckInImmersiveTalk()
		DebugPrint("TS:TryFireLeaveStoryEvent", self.bInImmersiveTalk)
		if not self.bInImmersiveTalk then
			EventManager:FireEvent(EventID.LeaveImmersiveTalk)
			if self.OnStoryEnd then
				self.OnStoryEnd:Broadcast()
			end
		end
	end
	TalkUtils:RemovePlayerInvincible()
	if IsEmptyTable(self.TalkTasks) then
		if GWorld.GameInstance then
			DebugPrint("TS: 停TalkContext Tick")
			GWorld.GameInstance.bTalkContextTickable = false
		end
	end
end

local ImmersiveTalkTypes = {
	ETalkType.Black,
	ETalkType.BlackISS,
	ETalkType.Cinematic,
	ETalkType.Show,
	ETalkType.FaultBlack,
	ETalkType.FixSimple,
	ETalkType.FreeSimple,
	ETalkType.Simple,
	ETalkType.Impression,
	ETalkType.QuestImpression,
}
function M:CheckInImmersiveTalk()
	local bRes = false
	local ExistType = nil
	for _, Type in pairs(ImmersiveTalkTypes) do
		local Queue = self:GetTasksQueue(ETaskState.Working, Type)
		if (not IsEmptyTable(Queue)) then
			bRes = true
			ExistType = Type
			break
		end
	end
	DebugPrint("TS:CheckInImmersiveTalk 检测是否处于沉浸式剧情中:", bRes, ExistType)
	return bRes
end

function M:CheckCanRegisterTask(TalkTask, TalkTaskData)
	if self:CheckBlockedByOthers(TalkTask:GetTalkType()) then
		return ETaskCheckResult.BlockedByOtherTask
	end

	return ETaskCheckResult.Succeed
end

function M:CheckBlockedByOthers(TalkType)
	DebugPrint("@@@ CheckBlockedByOthers", TalkType)
	local BlockingTypes = self.TalkInterruptComponent:GetSpecificInterruptTypes(TalkType, ETalkInterruptType.Blocked)
	for _, Type in pairs(BlockingTypes) do
		DebugPrint("@@@ CheckBlockedBy", Type)
		local Queue = self:GetTasksQueue(ETaskState.Working, Type)
		if not IsEmptyTable(Queue) then
			DebugPrint("@@@ " .. TalkType .. "任务被正在运行中的" .. Type .. "任务阻塞")
			return true
		end
	end
	return false
end

function M:RecordTalkTaskAndData(TalkTask, TalkTaskData, Key)
	DebugPrint("@@@ RecordTalkTaskAndData", TalkTask)
	if TalkTask and Key then
		self.TaskKeys[TalkTask] = Key
		self.TalkTasks[Key] = TalkTask
		self.TalkTaskDatas[TalkTask] = TalkTaskData
	end
end

function M:UnrecordTalkTask(TalkTask)
	if not TalkTask then
		return
	end
	DebugPrint("@@@ UnrecordTalkTaskAndData", TalkTask)
	local Key = self.TaskKeys[TalkTask]
	if Key then
		self.TalkTasks[Key] = nil
		self.TalkTaskDatas[TalkTask] = nil
		self.TaskKeys[TalkTask] = nil
	end
end

function M:MoveTaskState(Task, NewState)
	local CurrentState = Task:GetState()
	if (CurrentState == NewState) then
		return
	end

	self:OnTaskExitState(Task)
	Task:SetState(NewState)
	self:OnTaskEnterState(Task)

	DebugPrint("@@@ TS: 移动TaskState " .. CurrentState .. " -> " .. NewState, Task)
end

function M:OnTaskEnterState(Task)
	local State = Task:GetState()
	local Type = Task:GetTalkType()
	local Queue = self:GetTasksQueue(State, Type)
	Queue[Task] = Task
end

function M:OnTaskExitState(Task)
	local State = Task:GetState()
	local Type = Task:GetTalkType()
	local Queue = self:GetTasksQueue(State, Type)
	Queue[Task] = nil
end

function M:CreateTalkTaskData(Key)
	local RawTalkData = self:GetRegisteredTalkData(Key)
	local TalkTask, TalkTaskData = self.TalkTaskDataProcesser:ProcessRawTalkData(RawTalkData)
	return TalkTask, TalkTaskData
end

function M:ClearRefs(TalkTask)
	DebugPrint("@@@ TS:ClearRefs", TalkTask)
	self:MoveTaskState(TalkTask, ETaskState.Finished)
	self:UnrecordTalkTask(TalkTask)
	self:ClearInvalidTaskQueues()
end

function M:ClearInvalidTaskQueues()
	for _, Type in pairs(ETalkType) do
		self:ClearTaskQueue(ETaskState.Finished, Type)
		self:ClearTaskQueue(ETaskState.Interrupted, Type)
	end
end

function M:ClearTaskQueue(State, Type)
	self[State .. "TasksOf" .. Type] = {}
end

function M:InterruptTaskQueue(State, Type)
	local TQ = self:GetTasksQueue(State, Type)
	local tmpTQ = {}
	for _, Task in pairs(TQ) do
		tmpTQ[_] = Task
	end

	for _, Task in pairs(tmpTQ) do
		DebugPrint("@@@ InterruptTaskQueue", Task, State, Type)
		self:ForceInterruptTalk(Task)
	end
end

function M:PauseTaskQueue(PauserTask, State, Type)
	DebugPrint("@@@ 暂停TalkTask队列", PauserTask, State, Type)
	local TQ = self:GetTasksQueue(State, Type)
	local tmpTQ = {}
	for _, Task in pairs(TQ) do
		tmpTQ[_] = Task
	end

	for _, Task in pairs(tmpTQ) do
		DebugPrint("@@@ PauseTaskQueue", Task, State, Type)
		self:ForcePauseTalk(Task, PauserTask)
	end
end

function M:RecordPausedTasks(Pauser, PauseTask)
	DebugPrint("@@@ 记录被暂停的TalkTask", Pauser, PauseTask)
	self.PausedTasks[Pauser] = self.PausedTasks[Pauser] or {}
	self.PausedTasks[Pauser][PauseTask] = 1
	self.PausedByTasks[PauseTask] = self.PausedByTasks[PauseTask] or {}
	self.PausedByTasks[PauseTask][Pauser] = 1
end

-- 提前清除可能会被InstigatorTask打断的对话（例如A）身上的数据，避免递归。
-- 例如清除被A暂停的Task，这样A被打断之后，被A暂停的Task会随之打断
function M:PreClearInterruptedTasks(InstigatorTask)
	local TalkType = InstigatorTask:GetTalkType()
	local InterruptTypes = self.TalkInterruptComponent:GetSpecificInterruptTypes(TalkType, ETalkInterruptType.Interrupt)
	for _, Type in pairs(InterruptTypes) do
		local TQ = self:GetTasksQueue(ETaskState.Working, Type)
		for _, Task in pairs(TQ) do
			self:RemovePausedTasks(Task, true)
		end
	end
end

function M:PlayUIAnimationSequenceEvent(UIName, AnimationName, QuestChainId, bCloseUI)
	DebugPrint("BP_TalkSubsystem:PlayUIAnimationSequenceEvent", UIName, AnimationName, bCloseUI)
	local UI = UIManager(self):GetUIObj(UIName)
	if not UI then
		UI = UIManager(self):LoadUINew(UIName, QuestChainId)
	end

	if (not UI) or (not UI[AnimationName]) then
		return
	end

	UI:PlayAnimation(UI[AnimationName])
	if bCloseUI then
		self:AddTimer(UI[AnimationName]:GetEndTime(), function()
			UIManager(self):UnLoadUINew(UIName)
		end)
	end
end

function M:ScreenCaptureForUISequenceEvent(UIName, WidgetName, MaterialParamName)
	local UI = UIManager(self):GetUIObj(UIName)
	if not UI or not UI[WidgetName] then
		return
	end
	local Material = UI[WidgetName]:GetDynamicMaterial()
	if not Material then
		return
	end
	local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
	local RenderTexture = UKismetRenderingLibrary.CreateRenderTarget2D(self)
	local Size = UWidgetLayoutLibrary.GetViewportSize(self)
	URuntimeCommonFunctionLibrary.RenderTarget2DResize(RenderTexture, Size.X, Size.Y)
	local SceneCaptureComponent = NewObject(USceneCaptureComponent2D, Player)
	SceneCaptureComponent:K2_AttachToComponent(Player.CharCameraComponent)
	SceneCaptureComponent:K2_SetRelativeTransform(FTransform(), false, nil, false)
	URuntimeCommonFunctionLibrary.RegisterComponent(SceneCaptureComponent)
	SceneCaptureComponent.FOVAngle = Player.CharCameraComponent.FieldOfView
	SceneCaptureComponent.TextureTarget = RenderTexture
	SceneCaptureComponent.CaptureSource = ESceneCaptureSource.SCS_FinalColorHDR
	SceneCaptureComponent:SetComponentTickEnabled(false)
	SceneCaptureComponent.bCaptureEveryFrame = false
	SceneCaptureComponent.bCaptureOnMovement = false

	for _, Name in pairs(MaterialParamName:ToTable()) do
		Material:SetTextureParameterValue(Name, RenderTexture)
	end
	SceneCaptureComponent:CaptureScene()
	SceneCaptureComponent:K2_DestroyComponent(SceneCaptureComponent)
end

function M:GetNpcPlayDialogueCallback(NpcId)
	local NpcData = DataMgr.Npc[NpcId]
	if not NpcData then
		return nil
	end
	if NpcData.NpcType == "Show" then
		return { Func = function(Obj, DialogueId)
			local Avatar = GWorld:GetAvatar()
			if not Avatar then
				return
			end
			-- if Avatar:CheckSignBoardNpcTalkIsRecord(NpcId, DialogueId) then
			-- 	return
			-- end
			if not Avatar:CheckSignBoardNpcTalkValid(NpcId, DialogueId) then
				return
			end
			Avatar:TriggerRecordSignBoardNpcTalk(NpcId, DialogueId)
		end }
	end
end

return M
