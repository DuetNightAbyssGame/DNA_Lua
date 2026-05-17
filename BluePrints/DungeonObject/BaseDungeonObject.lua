
local BaseDungeonObject = DungeonClass.Class()

BaseDungeonObject.__Name__ = "BaseDungeonObject"

BaseDungeonObject.__Component__ = {
	"BluePrints.DungeonObject.DungeonObjectRPC",
}


-- 初始化
function BaseDungeonObject:Init(Env)
	if not Env then
		return
	end

	if type(Env) ~= "table" then
		return
	end

	for k, v in pairs(Env) do
		rawset(self, k, v)
	end
end

function BaseDungeonObject:InitExtra(Info)
end

function BaseDungeonObject:BeginPlay()
end

function BaseDungeonObject:EndPlay()
end

-- 增加定时器
--- @DeltaTime float 执行间隔
--- @Callback function 回调函数
--- @return Handler
function BaseDungeonObject:AddTimer(DeltaTime, Callback)
end

-- 增加循环定时器
--- @DelayTime float 首次执行回调的延时
--- @LoopTime float 回调执行间隔
--- @Callback function 回调函数
--- @Handle string 定时器句柄，可不传使用默认句柄
--- @return string 定时器句柄
function BaseDungeonObject:AddLoopTimer(DelayTime, LoopTime, Callback, Handle)
end

-- 移除定时器
function BaseDungeonObject:RemoveTimer(Handle)
end

-- 获取定时器下一次执行剩余的时间，以秒为单位，已经执行过或者不存在的Timer返回-1
function BaseDungeonObject:GetTimerRemainTime(Handle)
end

-- 通知逻辑服上的Avatar对象
function BaseDungeonObject:NotifyServerAvatar(EventName, AvatarEid, ...)
end

-- 广播到逻辑服上所有的Avatar对象
function BaseDungeonObject:MulticastServerAvatar(EventName, ...)
end

-- 调用逻辑服的Avatar对象同时接受回调
function BaseDungeonObject:CallServerAvatarWithCallback(EventName, AvatarEid, Callback, ...)
end

-- 日志
function BaseDungeonObject:Log(...)
end

-- 属性同步
function BaseDungeonObject:Replicated(PropName, Value, OnRepFunc)
end

-- 生成奖励
--- @UnitId int 原TriggerRewardEvent的Unit参数一致
--- @Reason RewardReason 原TriggerRewardEvent的Reason参数一致
--- @ExtraInfo table 原TriggerRewardEvent的ExtraInfo参数一致
--- @Callback function 回调，逻辑服会将此次生成的奖励中的掉落物以table的形式返回，格式是RewardBox DumpAll后Drops对应的table，没有掉落物则为nil
function BaseDungeonObject:TriggerRewardEvent(UnitId, Reason, ExtraInfo, Callback)
end

-- 副本结算
--- @IsWin bool 副本是否胜利结算
--- @Eid ObjId 玩家Eid，单机可不传，联机需要指定被结算的玩家Eid
function BaseDungeonObject:DungeonFinish(IsWin, Eid)
	local CustomInfoFunc = self["CustomFinishInfo"]
	local CustomInfo = CustomInfoFunc and CustomInfoFunc(self) or {}
	self:NotifyServerAvatar("DungeonFinish", Eid, IsWin, CustomInfo)
end

DungeonClass.AssembleComponents(BaseDungeonObject)
return BaseDungeonObject