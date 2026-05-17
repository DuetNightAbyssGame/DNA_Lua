require "UnLua"

local WBP_DungeonTrainingFloat_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_DungeonTrainingFloat_C:Initialize(Initializer)
	self.Super.Initialize(self)
	-- self.KillNum = nil
	-- self.TotalKillNum = 20
end

function WBP_DungeonTrainingFloat_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
	-- if MiscUtils.IsWithoutAvatar(self) then
	-- 	self:ListenToGameModeStandalone()
	-- else
	-- 	self:ListenToGameModeClient()
	-- end
	-- self.KillNum = 0
	-- self:UpdateWidget()
	-- self.CanvasPanel_0:SetVisibility(ESlateVisibility.Collapsed)
	-- local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
	-- local UIManager = GameInstance:GetGameUIManager()
	-- if (UIManager == nil) then
	-- 	return
	-- end
	
	-- local TaskPanel = UIManager:GetUIObj("DungeonCharacterIntro")
	-- if not TaskPanel then
	-- 	UIManager:LoadUI(UIConst.DUNGEONCHARACTERINTRO, "DungeonCharacterIntro", UIConst.ZORDER_FOR_NORMAL)
	-- end
	-- self:AddDispatcher(EventID.OnWaveStart, self, self.OnWaveStart)
	-- self:AddDispatcher(EventID.OnWaveEnd, self, self.OnWaveEnd)
end

-- function WBP_DungeonTrainingFloat_C:ListenToGameModeStandalone()
-- 	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
-- 	--BP_Avatar:RegisterGameModeEvent("OnCustomEvent", self, self.OnWaveStart)
-- 	GameMode.OnDeadDelegates:Add(self, self.OnMonsterDied)
-- end

-- function WBP_DungeonTrainingFloat_C:ListenToGameModeClient()
-- 	local GameInstance = GWorld.GameInstance
-- 	local BP_Avatar = GameInstance:GetAvatar()
-- 	if not BP_Avatar then
-- 		return
-- 	end
-- 	--BP_Avatar:RegisterGameModeEvent("OnCustomEvent", self, self.OnWaveStart)
-- 	BP_Avatar:RegisterGameModeEvent("OnDead", self, self.OnMonsterDied)
-- end

-- function WBP_DungeonTrainingFloat_C:OnMonsterDied()
-- 	self.KillNum = self.KillNum + 1
-- 	self:UpdateWidget()
-- end

-- function WBP_DungeonTrainingFloat_C:UpdateWidget()
-- 	self.TextBlock_1:SetText(tostring(self.KillNum))
-- 	local ResurgenceMat = self.Img_Bar_Kill:GetDynamicMaterial()
-- 	if ResurgenceMat then
-- 		ResurgenceMat:SetScalarParameterValue("Percent", self.KillNum / self.TotalKillNum)
-- 	end
-- end

-- function WBP_DungeonTrainingFloat_C:OnWaveStart()
-- 	self.KillNum = 0
-- 	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
-- 	self.TotalKillNum = GameMode.MonsterNum
-- 	self.TextBlock:SetText("/" .. tostring(self.TotalKillNum))
-- 	self:UpdateWidget()
-- 	local function ShowPanel()
-- 		self.CanvasPanel_0:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
-- 	end
-- 	local GameState = UE4.UGameplayStatics.GetGameState(self)
--     if not GameState then
--         return
--     end
-- 	self:AddTimer(GameState.DefenceWaveInterval, ShowPanel)
-- end

-- function WBP_DungeonTrainingFloat_C:OnWaveEnd()
-- 	self.CanvasPanel_0:SetVisibility(ESlateVisibility.Collapsed)
-- end

return WBP_DungeonTrainingFloat_C
