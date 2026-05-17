

local LookToHookNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode')

-- 没有初始化可以省略
function LookToHookNode:Init()
	self.StaticCreatorIdList = {}
    self.bOpenNode = true
    self.DurationTime = 3
	-- ScreenPrint("TestPrintNode:Init")
end

function LookToHookNode:Execute()
    local GameState = UGameplayStatics.GetGameState(GWorld.GameInstance)
    GameState.LookHookTime = self.DurationTime
    if self.bOpenNode then
        for i, v in pairs(self.StaticCreatorIdList) do
            print(_G.LogTag,"LXZ LookToHookNode:Execute()", v)
            GameState:AddHookLookToList(v)
        end
    else
        GameState.HookLookToList:Clear()
    end
    -- 同步节点的返回值表示节点的出口，nil表示默认出口Out
    return nil
end

function LookToHookNode:Clear()
	-- ScreenPrint("lxz TestPrintNode:Clear")
    -- local GameState = UGameplayStatics.GetGameState(GWorld.GameInstance)
    -- GameState.HookLookToList:Clear()
end

function LookToHookNode:OnQuestlineFinish()
	ScreenPrint("lxz TestPrintNode:OnQuestlineFinish")
    local GameState = UGameplayStatics.GetGameState(GWorld.GameInstance)
    GameState.HookLookToList:Clear()
end

return LookToHookNode