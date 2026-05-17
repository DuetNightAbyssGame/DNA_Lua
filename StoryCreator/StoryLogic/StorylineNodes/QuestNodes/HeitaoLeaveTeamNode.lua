local HeitaoLeaveTeamNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')


function HeitaoLeaveTeamNode:Init()
end

function HeitaoLeaveTeamNode:FinishAction()
	self:Finish()
end

function HeitaoLeaveTeamNode:Execute(Callback)
	local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
	local Avatar = GWorld:GetAvatar()
	if not Avatar and Callback then
		Callback()
	end

	local function FinishNode(ret, ResourceReturn)
		GWorld.GameInstance:RemoveTimer(self.DebugTimer)
		if ret ~= 0 then
			GWorld.logger.error("黑桃离队节点 角色切换失败，请检查备选角色和新手卡池角色Id是否一致。ErrorCode:"..ret)
			return
		end
		UIManager(GWorld.GameInstance):HideCommonBlackScreen(self.BlackHandle)
		UIManager(self):ShowUITip(UIConst.Tip_StoryToast, GText("Quest_Chapter01_HeitaoLeave_Toast"))

		local ResourceInfoList = {}
		local bHasResource = false
		if ResourceReturn then
			for ResourceId, Count in pairs(ResourceReturn) do
				local ResourceData = DataMgr.Resource[ResourceId]
				local ResourceInfo = {
					ItemType = "Resource",
					ItemId = ResourceId,
					Count = Count, 
					Rarity = ResourceData.Rarity
				}
				table.insert(ResourceInfoList, ResourceInfo)
				bHasResource = true
			end
		end
		if bHasResource then
			UIUtils.ShowHudReward(GText("Quest_Chapter01_HeitaoLeave_Tips"), ResourceInfoList)
		end
		if Callback then
			Callback()
		end
	end
	
	self.DebugTimer = GWorld.GameInstance:AddTimer(5, function()
		GWorld.logger.error("黑桃离队节点 服务器超时")
	end)
	self.BlackHandle = UIManager(GWorld.GameInstance):ShowCommonBlackScreen({})
	Avatar:ChangeChar(FinishNode)
end

return HeitaoLeaveTeamNode