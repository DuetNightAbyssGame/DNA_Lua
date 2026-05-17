
---@type Battle_Skill_UI_Base
local M = Class("BluePrints.UI.BP_UIState_C")
local MOBILE_SCALE = 0.8
local PC_SCALE = 1

function M:OnLoaded()
	self.IsInit = true
	self:AddDispatcher(EventID.OnMobileHudPlanChanged, self, self.OnMobileHudPlanChanged)
end

function M:OnMobileHudPlanChanged(OpType, LayoutPlan, _, _)
	--DebugPrint("gmy@Battle_Skill_UI_Base M:OnMobileHudPlanChanged", "OpType =", OpType, LayoutPlan)
	if OpType == "Update" then
		self:ApplyServerLayoutPosition(LayoutPlan)
	end
end

function M:RemoveSelf()
    self:Close()
end

function M:IsMainPlayerSummon(Summoner, UIOwner, UISummonId)
	if Summoner and UIOwner and Summoner.UnitId == UISummonId then
		if Summoner:GetRootSourceEid() == UIOwner.Eid then
			return true
		end
	end
	
	return false
end

--function M:SetFollowNode()
--	-- 设置位置跟随 UIBattleMain.ExclusiveSkill
--	if nil == self.BattleNode then
--		local UIBattleMain = UIManager(self.Owner):GetUI("BattleMain")
--		if UIBattleMain then
--			self.BattleNode = UIBattleMain.ExclusiveSkill
--			self.UIBattleMain = UIBattleMain
--		end
--	end
--	
--	if self.BattleNode then
--		local BattleGeometry = self.BattleNode:GetTickSpaceGeometry()
--		local BattleLocalCenter = USlateBlueprintLibrary.GetLocalSize(BattleGeometry) / 2
--		local BattleNodePos = USlateBlueprintLibrary.LocalToAbsolute(BattleGeometry, BattleLocalCenter)
--		
--		if self.OldBattleLocalCenter == nil or self.OldBattleLocalCenter ~= BattleNodePos then
--			self.OldBattleLocalCenter = FVector2D(BattleNodePos.X, BattleNodePos.Y)
--
--			local _, ViewportPosition = USlateBlueprintLibrary.AbsoluteToViewport(self.UIBattleMain, BattleNodePos)
--
--			local RootNode = self.SizeNode
--			assert(RootNode ~= nil, "gmy@M:SetFollowNode RootNode is nil!!!")
--			local CharSkillSize = RootNode.Brush.ImageSize
--
--			if ViewportPosition.X == 0 and ViewportPosition.Y == 0 then
--				assert(false, "gmy@M:SetFollowNode ViewportPosition is 0!!!")
--				return
--			end
--
--			DebugPrint("gmy@M:SetFollowNode ", ViewportPosition, CharSkillSize)
--
--			self:SetPositionInViewport(ViewportPosition - CharSkillSize / 2, false)
--		end
--	end
--end

function M:InitBattleCharUI(CharUIId, GradeLevel)
    local CharUIInfo = DataMgr.BattleCharUI[CharUIId][GradeLevel]
    if CharUIInfo then
        if CharUIInfo.ScaleNode then
            self:InitQuantityScale(CharUIInfo.ScaleNode)
        end

		local MainNode = self.Main
		local Offset = self.Offset_M
		if MainNode and Offset then
			if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
				local bHasServerLayout = self:HasServerLayoutPosition()
				if bHasServerLayout then
					--DebugPrint("gmy@Battle_Skill_UI_Base M:InitBattleCharUI", "检测到服务端自定义位置，跳过 Offset_M Padding 设置, Offset =", Offset)
				else
					--DebugPrint("gmy@Battle_Skill_UI_Base M:InitBattleCharUI", "无服务端自定义位置，使用 Offset_M Padding, Offset =", Offset)
					local Slot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(MainNode)
					local Padding = Slot.Padding
					--Padding.Bottom = Padding.Bottom + Offset
					Padding.Bottom = Offset
					Slot:SetPadding(Padding)
				end
			end
		end
    end
	self.FrameCount = 0

	-- 根据服务端自定义布局数据设置 Main 节点位置
	self:ApplyServerLayoutPosition()
end

function M:HasServerLayoutPosition()
	local BattleMain = UIManager(self.Owner):GetUI("BattleMain")
	if not BattleMain then
		return false
	end
	local LayoutInfo = BattleMain:GetLayoutInfoFromServer("SpSkillPos")

	return LayoutInfo ~= nil
end

function M:ApplyServerLayoutPosition(LayoutPlan)
	if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
		return
	end

	local BattleMain = UIManager(self.Owner):GetUI("BattleMain")
	if not BattleMain then
		DebugPrint("gmy@Battle_Skill_UI_Base M:ApplyServerLayoutPosition", "BattleMain UI 未找到，跳过服务端布局设置")
		return
	end

	local LayoutInfo = BattleMain:GetLayoutInfoFromServer("SpSkillPos", LayoutPlan)
	if not LayoutInfo then
		DebugPrint("gmy@Battle_Skill_UI_Base M:ApplyServerLayoutPosition", "服务端无 SpSkillPos 布局数据，使用默认位置")
		return
	end
	--DebugPrint("gmy@Battle_Skill_UI_Base M:ApplyServerLayoutPosition", "SpSkillPos =>",
	--	"PosX =", LayoutInfo.PosX, "PosY =", LayoutInfo.PosY,
	--	"ScaleX =", LayoutInfo.ScaleX, "ScaleY =", LayoutInfo.ScaleY)

	local MainNode = self.Main
	if not MainNode then
		DebugPrint("gmy@Battle_Skill_UI_Base M:ApplyServerLayoutPosition", "self.Main 节点不存在，无法应用布局数据")
		return
	end

	local Slot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(MainNode)
	local Padding = Slot.Padding
	Padding.Left = LayoutInfo.PosX
	Padding.Bottom = -LayoutInfo.PosY
	Slot:SetPadding(Padding)
	--DebugPrint("gmy@Battle_Skill_UI_Base M:ApplyServerLayoutPosition", "SetPadding Left =>", LayoutInfo.PosX, ", Bottom (negated PosY) =>", -LayoutInfo.PosY)

	if LayoutInfo.ScaleX ~= nil and LayoutInfo.ScaleY ~= nil then
		local NewScale = FVector2D(LayoutInfo.ScaleX, LayoutInfo.ScaleY)
		MainNode:SetRenderScale(NewScale)
	end
end


function M:Tick(MyGeometry, InDeltaTime)
	self.FrameCount = self.FrameCount or 0
	self.FrameCount = self.FrameCount + 1
end

function M:InitQuantityScale(ScaleNode)
    -- 手机端会缩放为0.8，PC端为1
    local bIsMobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
    local Scale = bIsMobile and MOBILE_SCALE or PC_SCALE
    if self[ScaleNode] then
        self[ScaleNode]:SetRenderScale(FVector2D(Scale, Scale))
    end
end

function M:TrySetSummon(SummonId, bIsSummonMonster)
	-- buff和创生物之间的初始化未必能保证顺序
	if nil == self.Summoner then
		local Player = GWorld:GetMainPlayer()
		if Player then
			local Summons = Player:GetSummonsList(SummonId, bIsSummonMonster, not bIsSummonMonster)

			for _, Eid in pairs(Summons) do
				local Summoner = Battle(self):GetEntity(Eid)

				if IsValid(Summoner) and Summoner.UnitId == SummonId then
					DebugPrint("gmy@Battle_Skill_UI_Base M:TrySetSummon", Summoner)
					self.Summoner = Summoner

					if self.OnSummonerAdd then
						self:OnSummonerAdd(Summoner)
					end
					return
				end
			end
		end
	end
end

return M