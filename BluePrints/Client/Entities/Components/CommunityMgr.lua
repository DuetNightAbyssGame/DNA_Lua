local Component = {}

--标记社媒已关注
function Component:MarkCommunityFollowed(CommunityId)
    self.logger.debug("MarkCommunityFollowed Begin",CommunityId)
    local function Callback(Ret)
		self.logger.debug("MarkCommunityFollowed Callback", Ret,CommunityId)
	end
    self:CallServer("MarkCommunityFollowed", Callback,CommunityId)
end

--获取社媒关注奖励
function Component:GetCommunityFollowedReward(CommunityId)
    self.logger.debug("GetCommunityFollowedReward Begin",CommunityId)
    local function Callback(Ret)
		self.logger.debug("GetCommunityFollowedReward Callback", Ret,CommunityId)
	end
    self:CallServer("GetCommunityFollowedReward", Callback,CommunityId)
end

--皎皎角成功注册回调
function Component:OnCommunityQuerySignUp(CommunityId)
    self.logger.debug("OnCommunityQuerySignUp",CommunityId)
    EventManager:FireEvent(EventID.OnCommunityFollowActivityJJJFinish, CommunityId)
end

return Component