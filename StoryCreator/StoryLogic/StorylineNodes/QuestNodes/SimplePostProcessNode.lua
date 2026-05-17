local SimplePostProcessNode = Class('StoryCreator.StoryLogic.StorylineNodes.Questline.QuestNode')
local LibraryPath = '/Game/Asset/Effect/Blueprint/PostProcess/PostProcessFunctionLibrary'
local UPostProcessFunctionLibrary = LoadClass(LibraryPath)

function SimplePostProcessNode:Init()
	self.bEnablePP = true
	self.PPEnum = 0
end

function SimplePostProcessNode:Start(Context)
    local Player = UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	if not IsValid(Player) then
        local Message = "设置相机后处理效果时，玩家PlayerCharacter无效\n"
        local Title = "后处理节点错误"
        UStoryLogUtils.PrintToFeiShu(self, UE.EStoryLogType.Quest, Title, Message)
		self:FinishAction()
        return
    end
    self.Player = Player
	if self.bEnablePP then
		if not self.PPEnum or type(self.PPEnum) ~= 'number' then
			local Message = "后处理效果枚举值无效:".."\n"..tostring(self.PPEnum or "")
	        local Title = "后处理节点错误"
	        UStoryLogUtils.PrintToFeiShu(self, UE.EStoryLogType.Quest, Title, Message)
			self:FinishAction()
			return
		end
		self:ClearPostProcess(Player)
		local MaterialInst = UPostProcessFunctionLibrary.SimplePostProcess(self.PPEnum)
    	rawset(Player, "SimplePPMaterial", MaterialInst)
	else
		self:ClearPostProcess(Player)
	end
	self:FinishAction()
end

function SimplePostProcessNode:ClearPostProcess(Player)
	local MaterialCache = rawget(Player, "SimplePPMaterial")
	if MaterialCache then
		UPostProcessFunctionLibrary.ClearSimplePostProcess(MaterialCache)
		rawset(Player, "SimplePPMaterial", nil)
	end
end

function SimplePostProcessNode:FinishAction()
	self:Finish()
end

return SimplePostProcessNode