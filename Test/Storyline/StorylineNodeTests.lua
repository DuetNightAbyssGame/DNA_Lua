---@class UE4.AFunctionalTest
local M = Class()

function M:ReceiveStartTest()
	--[[
	测试期间项目任意位置产生错误日志，无论当前测试结果如何，测试均会显示失败。
	运行测试等价项目开发，具备开发时的运行环境。
	--]]

	local StorylineUtils = require 'StoryCreator.StoryLogic.StorylineUtils'

	-- 测试 Wait of time node
	local WaitOfTimeNode = StorylineUtils.CreateQuestNode("WaitOfTimeNode")
	WaitOfTimeNode.WaitTime = 1
	WaitOfTimeNode:Execute(function()
		self:FinishTest(UE4.EFunctionalTestResult.Succeeded, "Test succeeded")
	end)
end

return M
