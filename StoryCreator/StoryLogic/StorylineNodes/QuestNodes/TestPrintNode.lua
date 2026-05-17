

local TestPrintNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode')

-- 没有初始化可以省略
function TestPrintNode:Init()
	self.Text = nil
	-- ScreenPrint("TestPrintNode:Init")
end

function TestPrintNode:Execute()
    local Str = "[TestPrint]Text为:"
    if self.Text then
        Str = Str .. "'"..self.Text.."'"
    end
    ScreenPrint(Str)

    -- 同步节点的返回值表示节点的出口，nil表示默认出口Out
    return nil
end

-- 没有Node自身清理工作可以省略
function TestPrintNode:Clear()
	-- ScreenPrint("TestPrintNode:Clear")
end

-- 没有Questline清理工作可以省略
function TestPrintNode:OnQuestlineFinish()
	-- ScreenPrint("TestPrintNode:OnQuestlineFinish")
end

-- 没有Questline成功工作可以省略
function TestPrintNode:OnQuestlineSuccess()
	-- ScreenPrint("TestPrintNode:OnQuestlineSuccess")
end

-- 没有Questline失败工作可以省略
function TestPrintNode:OnQuestlineFail()
	-- ScreenPrint("TestPrintNode:OnQuestlineFail")
end

return TestPrintNode