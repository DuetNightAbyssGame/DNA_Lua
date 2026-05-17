---@class SetPhantomStatusNode : BaseQuestNode
local SetPhantomStatusNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseQuestNode')

function SetPhantomStatusNode:Init()
    self.BuffList = {}
    self.PhantomRoleId = 0
end

function SetPhantomStatusNode:Execute()
    local Avatar = GWorld:GetAvatar()
    local GameInstance = GWorld.GameInstance
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(GameInstance, 0)
	local PlayerCharacter = PlayerController:GetMyPawn()
    local Phantoms = PlayerCharacter:GetPhantomTeammates(false, true)
    local NPCPhantoms = PlayerCharacter:GetNpcPhantoms()
    local PhantomsTable = Phantoms:ToTable()
    local NPCPhantomsTable = NPCPhantoms:ToTable()

    DebugPrint("Tianyi@ 开始执行魅影加Buff节点, PhantomId = " .. tostring(self.PhantomRoleId))
    
    for _,Teammate in pairs(PhantomsTable) do
        -- DebugPrint("Tianyi@ 遍历队友魅影: " .. tostring(Teammate.UnitId))
        if Teammate.UnitId == self.PhantomRoleId then
            self:AddBuffsToPhantom(Teammate)
            return
        end
    end

    for _,NPCPhantom in pairs(NPCPhantomsTable) do
        -- DebugPrint("Tianyi@ 遍历NPC魅影: " .. tostring(NPCPhantom.UnitId))
        if NPCPhantom.UnitId == self.PhantomRoleId then
            self:AddBuffsToPhantom(NPCPhantom)
            return
        end
    end

end

function SetPhantomStatusNode:Clear()
    
end

function SetPhantomStatusNode:AddBuffsToPhantom(Phantom)
    -- DebugPrint("Tianyi@ 开始给魅影加Buff: " .. tostring(Phantom.UnitId))
    for _, Buff in pairs(self.BuffList) do
        DebugPrint("Tianyi@ 给魅影加Buff: " .. tostring(Buff.Id))
        Battle(Phantom):AddBuffToTarget(Phantom, Phantom, Buff.Id, Buff.LastTime, Buff.Value, nil)
    end
end

return SetPhantomStatusNode
