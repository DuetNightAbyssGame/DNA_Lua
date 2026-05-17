

local BaseClientEvent = Class('StoryCreator.StoryLogic.StorylineNodes.NodeObject')

function BaseClientEvent:Init(...)
	-- 状态分为
	-- 	未激活:Inactive,默认状态
	-- 	激活中:Activate,激活了等待运行
	-- 	运行中:Inprocess,正在运行Event的逻辑
	-- 	结束:Finish,结束了，这时候要进入销毁逻辑了
	self.State = "Inactive"

	-- Event Type
	self.Type = nil

	self:InitEvent(...)
	-- self:StartEvent(...)
end

function BaseClientEvent:StartEvent( ... )
	self:OnStartEvent()
end

function BaseClientEvent:OnStartEvent( ... )
	-- local SpecialQuestConfig = DataMgr.SpecialQuestConfig[self.SpecialQuestId]
	-- assert(SpecialQuestConfig, "找不到特殊任务编号:【" .. tostring(self.SpecialQuestId) .. "】")
	-- SpecialQuestConfig.
end

function BaseClientEvent:TryActivateEvent( ... )
	
end

function BaseClientEvent:OnActivateEvent( ... )
	-- body
end

function BaseClientEvent:TryFinishEvent(Result, Info)
	-- body
end

function BaseClientEvent:OnFinishEvent(Result, Info)
	-- body
	self:Destroy()
end

function BaseClientEvent:Destroy(Result, Info)
	-- body
end

return BaseClientEvent