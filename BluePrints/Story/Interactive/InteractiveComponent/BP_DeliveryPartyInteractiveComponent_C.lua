require "UnLua"
require "DataMgr"

local BP_DeliveryPartyInteractiveComponent_C = Class("BluePrints.Story.Interactive.InteractiveComponent.BP_InteractiveBaseComponent_C")

local LuaConst = require("EMLuaConst")

function BP_DeliveryPartyInteractiveComponent_C:ReceiveBeginPlay()
    self.Super.ReceiveBeginPlay(self)
    self.Owner = self:GetOwner()
    -- self.InteractiveDistance = 200
	-- self.InteractiveFaceAngle = 180
	-- self.InteractiveAngle = 360

	self.PartyId = 0
	self.LockByCondition = false
	self.ConditionId = 0
end

function BP_DeliveryPartyInteractiveComponent_C:TriggerTick(PlayerActor)
    self.Overridden.TriggerTick(self, PlayerActor)
end

function BP_DeliveryPartyInteractiveComponent_C:IsCanInteractive(PlayerActor)
	local Avatar = GWorld:GetAvatar()
    if Avatar then
        local UIUnlockRule = DataMgr.UIUnlockRule
        local UIUnlockRuleId = UIUnlockRule.Party.UIUnlockRuleId
        local bUnlocked = Avatar:CheckUIUnlocked(UIUnlockRuleId)
        if not bUnlocked then
            return false
        end
    end
	local Controller = PlayerActor:GetController()
	if Controller:GetStoryModeState() then
		return false
	end
    if LuaConst.OpenComputeInteractive then
		return  self:GetInteractiveName() ~= "" and
        self:GetDistanceCheckResult() and
        self.CFaceToACheckComponent(self, PlayerActor, self.InteractiveFaceAngle, false) and 
        self.AFaceToCCheckComponent(PlayerActor, self, self.InteractiveAngle, false)
	else
		return self:GetInteractiveName() ~= "" and
        self.DistanceCheckComponent(self, PlayerActor, self.InteractiveDistance, false) and
        self.CFaceToACheckComponent(self, PlayerActor, self.InteractiveFaceAngle, false) and 
        self.AFaceToCCheckComponent(PlayerActor, self, self.InteractiveAngle, false)
	end
end

function BP_DeliveryPartyInteractiveComponent_C:UpdateDisplayInteractiveBtn(PlayerActor)
	local bCanInteractive = self:IsCanInteractive(PlayerActor)
	if not PlayerActor:IsMainPlayer() then
		return
	end
	if bCanInteractive and not self:IsBtnDisplayed(PlayerActor) then
		self.Owner:DisplayInteractiveBtn(PlayerActor)
	elseif bCanInteractive and self:IsBtnDisplayed(PlayerActor) then
		self:RefreshInteractiveBtn(PlayerActor)
	elseif bCanInteractive == false and self:IsBtnDisplayed(PlayerActor) then
		self:NotDisplayInteractiveBtn(PlayerActor)
	end
end

function BP_DeliveryPartyInteractiveComponent_C:DisplayInteractiveBtn(PlayerActor)
	local UIManager = UGameplayStatics.GetGameInstance(self):GetGameUIManager()
	local InteractiveUI = UIManager:GetUIObj(UIConst.InteractiveUIName)
	-- local InteractiveUI = UIManager:LoadUINew(UIConst.InteractiveUIName)
	if not InteractiveUI then
		InteractiveUI = UIManager:LoadUINew(UIConst.InteractiveUIName)
	end
	if not InteractiveUI then
		return
	end
	InteractiveUI:AddInteractiveItem(self)
	for i = 0, InteractiveUI.ScrollBox_Interactive:GetChildrenCount() - 1 do
		local InteractiveItem = InteractiveUI.ScrollBox_Interactive:GetChildAt(i)
        if InteractiveItem.InteractiveInfo == self then
			local Avatar = GWorld:GetAvatar()
			if not Avatar then
				error("Avatar is nil")
			end
            if not self:IsLocked() and not Avatar.Dungeons[self.PartyId] then
                InteractiveItem.Tag_New:SetVisibility(ESlateVisibility.Visible)
            end
            break
        end
	end
	self:SetBtnDisplayed(PlayerActor, true)
	self:RefreshInteractiveBtn(PlayerActor)
end

function BP_DeliveryPartyInteractiveComponent_C:NotDisplayInteractiveBtn(PlayerActor)
	self:SetBtnDisplayed(PlayerActor, false)
	local UIManager = UGameplayStatics.GetGameInstance(self):GetGameUIManager()
	local InteractiveUI = UIManager:GetUIObj(UIConst.InteractiveUIName)
	if not InteractiveUI then
		return
	end
	InteractiveUI:RemoveInteractiveItem(self)
end

function BP_DeliveryPartyInteractiveComponent_C:GetInteractiveName()
	if self.PartyId ~= 0 then
		local DungeonInfo = DataMgr.Dungeon[self.PartyId]
		if not DungeonInfo then
			return
		end
		return GText(DungeonInfo.DungeonName)
	end
	return ""
end

function BP_DeliveryPartyInteractiveComponent_C:StartInteractive(PlayerActor)
    if self:IsCanInteractive(PlayerActor) and not self:IsForbidden() then
		-- 弹窗确认
		local DungeonInfo = DataMgr.Dungeon[self.PartyId]
		local UIManager = UGameplayStatics.GetGameInstance(self):GetGameUIManager()
		local PopupId=100117
		local Params = {}
		Params.RightCallbackObj = self
		Params.RightCallbackFunction = self.EnterParty
		Params.ShortText = string.format(GText("UI_COMMONPOP_TEXT_100117"), GText(DungeonInfo.DungeonName))
		UIManager:ShowCommonPopupUI(PopupId, Params, self)
		self.Owner:NotDisplayInteractiveBtn(PlayerActor)
    end
end

function BP_DeliveryPartyInteractiveComponent_C:EnterParty()
	local Avatar = GWorld:GetAvatar()
	if Avatar then
		local function Callback(Ret, ...)
			if Ret ~= 0 then
				UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Disabled_Des_Temple"))
			end 
		end
		Avatar:EnterDungeon(self.PartyId, nil, Callback)
	end
end

function BP_DeliveryPartyInteractiveComponent_C:BtnPressed(PlayerActor)
	if self:IsLocked() then
		self:LockInteractive()
		return
	end
	self:StartInteractive(PlayerActor)
end

function BP_DeliveryPartyInteractiveComponent_C:OnClicked_Forbidden()
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Disabled_Des_Temple"))
end

function BP_DeliveryPartyInteractiveComponent_C:GetUUID()
    return self:GetClass():GetName() .. tostring(self.PartyId)
end

function BP_DeliveryPartyInteractiveComponent_C:IsLocked()
	local Avatar = GWorld:GetAvatar()
    if not Avatar then
        error("Avatar is nil")
    end

	local PrePartyId = self.Owner.PartyOrder[self.PartyId]
	if PrePartyId ~= nil and Avatar.Dungeons and not Avatar.Dungeons[PrePartyId] then
		return true
	end
	if PrePartyId ~= nil and Avatar.Dungeons and Avatar.Dungeons[PrePartyId] and not Avatar.Dungeons[PrePartyId].IsPass then
		return true
	end
	local DungeonInfo = DataMgr.Dungeon[self.PartyId]
	local Conditions = DungeonInfo.Condition
	if Conditions and #Conditions > 0 and not ConditionUtils.CheckCondition(Avatar, Conditions[1]) then
		self.LockByCondition = true
		self.ConditionId = Conditions[1]
		return true
	end
	if self.Owner and self.Owner.TempleIds and #self.Owner.TempleIds > 0 then
		for i = 1, #self.Owner.TempleIds do
			local TempleId = self.Owner.TempleIds[i]
			if TempleId ~= nil and Avatar.Dungeons and not Avatar.Dungeons[TempleId] then
				return true
			end
			if TempleId ~= nil and Avatar.Dungeons and Avatar.Dungeons[TempleId] and not Avatar.Dungeons[TempleId].IsPass then
				return true
			end
		end
	end
	return false
end

function BP_DeliveryPartyInteractiveComponent_C:LockInteractive()
	if self.LockByCondition and self.ConditionId > 0 then
		UIManager(self):ShowUITip(UIConst.Tip_CommonTop, string.format(GText("UI_Party_Lockedcondition"), GText("Name_"..self.ConditionId)))
	else
		UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Tosat_Party_Locked"))
	end
end

function BP_DeliveryPartyInteractiveComponent_C:IsForbidden()
    local Avatar = GWorld:GetAvatar()
	return Avatar:IsInTeam() or Avatar.InSpecialQuest
end

function BP_DeliveryPartyInteractiveComponent_C:GetStars()
	if self:IsLocked() then
		return nil
	end
	local Avatar = GWorld:GetAvatar()
    if not Avatar then
        error("Avatar is nil")
    end
	if self.PartyId <= 0 then return nil end

	local PartyInfo = DataMgr.Party[self.PartyId]
	if Avatar.Dungeons[self.PartyId] then
		-- 进过，读取服务器保存数据
		if not PartyInfo.RewardId then
			return nil
		elseif #PartyInfo.RewardId == 1 and Avatar.Dungeons[self.PartyId].IsPass then
			-- -1表示无星级关卡通关
			return -1
		elseif #PartyInfo.RewardId == 1 and not Avatar.Dungeons[self.PartyId].IsPass then
			return -2
		else
			return Avatar.Dungeons[self.PartyId].MaxStar
		end
	else
		-- 没进过，服务器没有保存数据
		if #PartyInfo.RewardId <= 0 then
			return nil
		elseif #PartyInfo.RewardId == 1 then
			-- -2表示无星级关卡灰态
			return -2
		else
			return 0
		end
	end
end

function BP_DeliveryPartyInteractiveComponent_C:GetInteractiveIcon(PlayerActor)
	if self:IsLocked() then
		return "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Interactive/T_Interactive_Lock.T_Interactive_Lock'"
	end

	-- return "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Interactive/T_Interactive_Temple.T_Interactive_Temple'"
	return nil
end

function BP_DeliveryPartyInteractiveComponent_C:SetPartyId(Id)
	self.PartyId = Id
end

return BP_DeliveryPartyInteractiveComponent_C
