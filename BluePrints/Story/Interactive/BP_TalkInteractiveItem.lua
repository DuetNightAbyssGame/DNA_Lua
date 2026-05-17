local EMCache = require "EMCache.EMCache"

local M = Class({ "BluePrints.Item.SceneItemBase" })

function M:ReceiveBeginPlay()
	M.Super.ReceiveBeginPlay(self)

	self.bAccessed = true
    self.CacheKey = "IconGuide" .. self.TalkTriggerId

	-- 性能优化，设置Tick间隔为 1 秒。
	self:SetActorTickInterval(1);
	self:SetGuideInfo()
	self:SetInteractiveInfo()
end

function M:AuthorityInitInfo(Info)
	M.Super.AuthorityInitInfo(self, Info)

	if Info.Creator then
		self.TalkTriggerId = Info.Creator.TalkTriggerId
		self.InteractiveId = Info.Creator.TalkInteractiveId
        self.CacheKey = "IconGuide" .. self.TalkTriggerId
	end

	if DataMgr.CommonUIConfirm[self.InteractiveId] then
		local Data = DataMgr.CommonUIConfirm[self.InteractiveId]
		self.InteractiveDistance = Data.InteractiveRadius
		self.PlayerFaceAngle = Data.PlayerFaceAngle
		self.TalkItemFaceAngle = Data.InteractiveAngle
		self.IconPath = Data.Icon
	end

	self:SetGuideInfo()
	self:SetInteractiveInfo()
end

function M:CreateRegionData()
	--区域数据只保存这俩，其余读CommonUIConfirm表
	self.RegionData = {
		TalkTriggerId = self.TalkTriggerId,
		InteractiveId = self.InteractiveId
	}
end

function M:SetGuideInfo()
	if (not IsValid(self.IconComponent) or self.InteractiveId <= 0 or self.TalkTriggerId <= 0) then
		return
	end

	local bAccessed = EMCache:Get(self.CacheKey, true) or false
	self:SetAccessibility(bAccessed)
 
    self.IconComponent:SetWidgetHiddenByTag(true, "TalkMechanism")
end

function M:SetInteractiveInfo()
	if (not IsValid(self.TalkItemInteractiveComponent) or self.InteractiveId <= 0 or self.TalkTriggerId <= 0) then
		return
	end

	local Info = {}
	Info.InteractiveId = self.InteractiveId
	Info.InteractiveDistance = self.InteractiveDistance
	Info.TalkItemFaceAngle = self.TalkItemFaceAngle
	Info.PlayerFaceAngle = self.PlayerFaceAngle
	Info.StartInteractiveCallback = function(PlayerActor)
		local TalkContext = GWorld.GameInstance:GetTalkContext()
		TalkContext:RegisterInteractiveActor(self)
		TalkContext:StartTalk(self.TalkTriggerId, nil, nil, PlayerActor, self, {
			Func = function()
				TalkContext:UnregisterInteractiveActor()
				self:SetAccessibility(true)
			end, Obj = self
		})
	end

	self.TalkItemInteractiveComponent:SetInteractiveInfo(Info)
end

function M:HandleOnGuideVisibilityChanged(bVisible)
	if (not IsValid(self.IconComponent)) then
		return
	end

	self.IconComponent:SetWidgetHiddenByTag(not bVisible, "TalkMechanism")
end

function M:SetAccessibility(bNewAccessed)
	if (bNewAccessed == self.bAccessed) then
		return
	end

	self.bAccessed = bNewAccessed

    EMCache:Set(self.CacheKey, bNewAccessed, true)

	if (IsValid(self.IconComponent)) then
		self.IconComponent:SetAccessibility(bNewAccessed)
	end
end

function M:IsAccessed()
	return self.bAccessed
end

return M
