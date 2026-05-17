--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}

--NPC和Monster的共同父类，需将NPC和Monster的共同逻辑逐步移到这里

require "UnLua"

---@class BP_AICharacterBase_C : BP_CharacterBase_C
local BP_AICharacterBase_C = Class({
    "BluePrints.Char.BP_CharacterBase_C",
})

BP_AICharacterBase_C._components = {
    --"BluePrints.Char.CharacterComponent.AddGuideComponent",
}

function BP_AICharacterBase_C:ActiveGuide(OpType)
    -- 激活指引
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local SceneMgrComponent = GameInstance:GetSceneManager()
    if (IsValid(SceneMgrComponent) and self.Data and self.Data.GuideIconAni) then
        SceneMgrComponent:UpdateSceneGuideIcon(self.Eid, self, nil, OpType, true, self.Data)
    end
end

function BP_AICharacterBase_C:DeactiveGuide()
    -- 关闭指引
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local SceneMgrComponent = GameInstance:GetSceneManager()
    if (IsValid(SceneMgrComponent) and self.Data and self.Data.GuideIconAni) then
        SceneMgrComponent:UpdateSceneGuideIcon(self.Eid, self, nil, "Delete", true, self.Data)
    end
end

function BP_AICharacterBase_C:OnClaimRegionData_Lua(LuaTableIndex)
	local SubSystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, URegionDataMgrSubsystem:StaticClass())
	if SubSystem then
		self.RegionDataType = SubSystem.DataPool.RegionData[LuaTableIndex].RegionDataType
		self.QuestChainId = SubSystem.DataPool.RegionData[LuaTableIndex].QuestChainId
		self.RarelyId = SubSystem.DataPool.RegionData[LuaTableIndex].RarelyId
	end
end

-- function BP_AICharacterBase_C:GetBillboardWidgetHeight()
--     local res = 0
--     if (self.BillboardComponent ~= nil) then
--         if self.IsBillboardWidgetVisibility then
--             res =  self.BillboardComponent.RelativeLocation.Z 
--         else
--             res =  self.BillboardComponent.RelativeLocation.Z 
--         end
--     end
--     return res * self.RootComponent:K2_GetComponentScale().Z
-- end

function BP_AICharacterBase_C:CommonFreeAICharacterBaseMemory()
    self.IsDestroied = true
    if self.BornInfo then
        self.BornInfo = nil
    end
    -- 引用InitLogicComp 的 InitFinalInfo
    if self.InfoForInit then
        self.InfoForInit.IsDestroied = true
        self.InfoForInit = nil
    end
    if self.BattleCharInfo then
        self.BattleCharInfo = nil
    end
    if self.ServerBornInfo then
        self.ServerBornInfo = nil
    end
end

AssembleComponents(BP_AICharacterBase_C)
return BP_AICharacterBase_C
