





local ChangeNpcDefaultDataNode = Class('StoryCreator.StoryLogic.StorylineNodes.Questline.QuestNode')


function ChangeNpcDefaultDataNode:Init()
	self.ChangeNpcDefaultDataList = nil
end

function ChangeNpcDefaultDataNode:Start(Context)
    self.Context = Context
    if not IsEmptyTable(self.ChangeNpcDefaultDataList) then
        for _, Data in pairs(self.ChangeNpcDefaultDataList) do
	        self:DoChangeNpcChangeDefaultData(Data)
        end
    end
    self:FinishAction()
end

function ChangeNpcDefaultDataNode:DoChangeNpcChangeDefaultData(InNpcDefaultData)
    local GameInstance = GWorld.GameInstance
	local EMGameState = UE4.UGameplayStatics.GetGameState(GameInstance)
    if InNpcDefaultData.TargetNpcUnitId <= 0 then
        return
    end
	local TargetNpc = EMGameState.NpcCharacterMap:FindRef(InNpcDefaultData.TargetNpcUnitId)
    if TargetNpc then

        if DataMgr.Npc[InNpcDefaultData.TargetNpcUnitId] then
            local DefaultActionData = DataMgr.Npc[InNpcDefaultData.TargetNpcUnitId].DefaultAction
            if DefaultActionData and DefaultActionData[InNpcDefaultData.DefaultActionId] then
                TargetNpc:NewPlayAction(DefaultActionData[InNpcDefaultData.DefaultActionId])
            end
        end

        if DataMgr.Npc[InNpcDefaultData.TargetNpcUnitId] then
            local DefaultFacialData = DataMgr.Npc[InNpcDefaultData.TargetNpcUnitId].DefaultExpression
            if DefaultFacialData and DefaultFacialData[InNpcDefaultData.DefaultFacialId] then
                TargetNpc:NewPlayFacial(DefaultFacialData[InNpcDefaultData.DefaultFacialId])
            end
        end

        self.Context:SaveSuitUpdateData("UpdateSuitKey2Table", CommonConst.SuitType.PlayerCharacterSuit, 
        CommonConst.PlayerCharacterSuit.NpcExpression, InNpcDefaultData.TargetNpcUnitId, 
        {
            DefaultActionId = InNpcDefaultData.DefaultActionId, 
            ExpressId = InNpcDefaultData.DefaultFacialId
        })
    end
end

function ChangeNpcDefaultDataNode:FinishAction()
	self:Finish()
end

return ChangeNpcDefaultDataNode