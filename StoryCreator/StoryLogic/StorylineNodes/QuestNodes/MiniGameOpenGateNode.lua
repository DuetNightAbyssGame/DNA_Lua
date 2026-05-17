local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"
local MiniGameOpenGateNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')


function MiniGameOpenGateNode:Init()
	self.bGuideUIEnable = true
	self.GuideType = nil
	self.GuidePointName = ''
	self.StaticCreatorId = -1
	self.bFinish = false
end

function MiniGameOpenGateNode:Execute(Callback)
	self:MiniGame(Callback)
end

function MiniGameOpenGateNode:MiniGame(Callback)
    DebugPrint("------------ MiniGameOpenGateNode ------------------", self.StaticCreatorId)
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)

    local function MiniGameOpenGateNodeCallback()
    	GameMode:RemoveMiniGameSuccessCallback(self.StaticCreatorId)
    	self:FinishAction(Callback)
    end

	local MiniGame
	if self.StaticCreatorId ~= -1 then
		local StaticCreator = GameMode.EMGameState:GetStaticCreatorInfo(self.StaticCreatorId, false, GameMode.LevelName)
		for i = 1, StaticCreator.ChildEids:Length() do
			MiniGame = Battle(GameMode):GetEntity(StaticCreator.ChildEids:GetRef(i))
		end
	end

	if not IsValid(MiniGame) then
		DebugPrint("------------ MiniGameOpenGateNode ------------------节点开始时小游戏机关不存在")
		EventManager:RemoveEvent(EventID.OnMechanismEnterState, self)
		MiniGameOpenGateNodeCallback()
		return
	end

	if self.bGuideUIEnable then
		if MiniGame.PlayerEid == 0 then
    		MissionIndicatorManager:ActiveMissionIndicatorByNode(self)
		else
			EventManager:AddEvent(EventID.OnMechanismEnterState, self, self.ShowMissionIndicator)
		end
	end

	if MiniGame:IsCombatItemBase("MiniGame") then
		assert(MiniGame.FiniStateId, "LXZ STL里用到的小游戏没有定义FiniStateId参数(小游戏机关结束状态的id)")
		if MiniGame.StateId == MiniGame.FiniStateId then
			MiniGameOpenGateNodeCallback()
			return
		end
	end
	print(_G.LogTag, "LXZ MiniGameOpenGateNode", self.StaticCreatorId)
	GameMode:AddMiniGameSuccessCallback(self.StaticCreatorId, MiniGameOpenGateNodeCallback)
end

function MiniGameOpenGateNode:ShowMissionIndicator(CreatorId, StateId)
	if CreatorId ~= self.StaticCreatorId then
		return
	end
	local MiniGame
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	if self.StaticCreatorId ~= -1 then
		local StaticCreator = GameMode.EMGameState:GetStaticCreatorInfo(self.StaticCreatorId, false, GameMode.LevelName)
		for i = 1, StaticCreator.ChildEids:Length() do
			MiniGame = Battle(GameMode):GetEntity(StaticCreator.ChildEids:GetRef(i))
		end
	end
	if IsValid(MiniGame) and not self.bFinish then
		MissionIndicatorManager:ActiveMissionIndicatorByNode(self)
		EventManager:RemoveEvent(EventID.OnMechanismEnterState, self)
	end
end

function MiniGameOpenGateNode:FinishAction(Callback)
	self.bFinish = true
	if self.bGuideUIEnable then
		MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
	end
	Callback()
end

function MiniGameOpenGateNode:Clear()
	if self.bGuideUIEnable then
		MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
	end
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	GameMode:RemoveMiniGameSuccessCallback(self.StaticCreatorId)
end

return MiniGameOpenGateNode