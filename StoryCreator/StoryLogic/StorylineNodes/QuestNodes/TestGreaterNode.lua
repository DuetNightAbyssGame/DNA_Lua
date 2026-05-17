

local TestGreaterNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')

function TestGreaterNode:Init()
	self.Delay = 0
	self.A = 0
	self.B = 0
end

function TestGreaterNode:Execute(Callback)
	-- 异步节点需要通过Callback返回 -- Callback(ReturnPort)
	ScreenPrint("开始倒计时:Delay:"..tostring(self.Delay))
	self.ExecuteTimer = GWorld.GameInstance:AddTimer(self.Delay, function( ... )
		local Result = self.A > self.B
		ScreenPrint("计时结束:A:"..tostring(self.A).."与B:"..tostring(self.B).."的比较结果是:"..tostring(Result))
		if Callback then
			Callback(Result)
		end
	end)
end

function TestGreaterNode:Clear()
	if self.ExecuteTimer then
		GWorld.GameInstance:RemoveTimer(self.ExecuteTimer)
		self.ExecuteTimer = nil
	end
end

-- 没有Questline清理工作可以省略
function TestGreaterNode:OnQuestlineFinish()
end

-- 没有Questline成功工作可以省略
function TestGreaterNode:OnQuestlineSuccess()
end

-- 没有Questline失败工作可以省略
function TestGreaterNode:OnQuestlineFail()
end

return TestGreaterNode
