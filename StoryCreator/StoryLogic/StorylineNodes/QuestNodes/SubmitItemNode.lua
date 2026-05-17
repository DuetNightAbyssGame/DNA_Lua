local SubmitItemNode = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')

function SubmitItemNode:Init()
	self.AssociatedObjectType = "Npc"
	self.AssociatedObjectId = 0
	self.InteractionId = 0
	self.bGuideUIEnable = false
	self.GuideType = 'P'
	self.GuidePointName = ''
	self.SubmitId = 0
end

function SubmitItemNode:Execute(Callback)
    local Avatar = GWorld:GetAvatar()
    if (Avatar and Avatar:GetIsSubmitComplete(self.SubmitId)) then
        Callback()
        return
    end
    self.Callback = Callback
    
    if self.AssociatedObjectType == "Npc" then
        self:BindNpcInteraction()
    elseif self.AssociatedObjectType == "Drop" then
        self:BindDropInteraction()
    end

    self:AddGuide()
end

function SubmitItemNode:BindNpcInteraction()
    local NpcIdWithGender = self.AssociatedObjectId
    if NpcIdWithGender then
        NpcIdWithGender = URuntimeCommonFunctionLibrary.GetNPCIdByGender(GWorld.GameInstance, NpcIdWithGender)
    end
    
    -- 为NPC动态挂载提交物品交互组件
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    local Npc = GameState.NpcCharacterMap:FindRef(NpcIdWithGender)
    if IsValid(Npc) then
        self:MountSubmitComponentToActor(Npc, function()
            self.Callback()
        end)
    end
    
    self.NpcIdWithGender = NpcIdWithGender
end

function SubmitItemNode:BindDropInteraction()
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    local DropActor = nil

    local StaticCreator = GameState:GetStaticCreatorInfo(self.AssociatedObjectId)
    if StaticCreator then
        local ChildDrop = StaticCreator:GetChildEids():ToTable()
        if #ChildDrop > 0 then
            local Eid = ChildDrop[1]
            DropActor = GameState.CombatItemMap:FindRef(Eid)
        end
    end

    if IsValid(DropActor) then
        self:MountSubmitComponentToActor(DropActor, function()
            self.Callback()
        end)
    end
end

function SubmitItemNode:MountSubmitComponentToActor(Actor, Callback)
    if not IsValid(Actor) then return end
    
    -- 检查是否已经挂载了该组件，避免重复挂载
    if Actor.SubmitItemInteractiveComponent then
        -- 确保更新 SubmitId，以防同一个Actor被多个任务复用
        if Actor.SubmitItemInteractiveComponent.SetSubmitId then
             Actor.SubmitItemInteractiveComponent:SetSubmitId(self.SubmitId)
        end
        return
    end

    UResourceLibrary.LoadClassAsync(Actor, "/Game/BluePrints/Story/Interactive/InteractiveComponent/BP_SubmitItemInteractiveComponent", { 
        Actor, function(_, ClassObject)
            if not IsValid(Actor) then return end
            -- 使用 NPC 现有的 AddInteractiveComponent 接口
            local Component = nil
            if Actor.AddInteractiveComponent then
                 Component = Actor:AddInteractiveComponent(ClassObject)
            else
                 -- 对于Drop/Mechanism，直接创建组件并Attach
                 Component = NewObject(ClassObject, Actor)
                 Component:K2_AttachToComponent(Actor.RootComponent, "", EAttachmentRule.SnapToTarget, EAttachmentRule.SnapToTarget, EAttachmentRule.SnapToTarget, true)
                 URuntimeCommonFunctionLibrary.RegisterComponent(Component)
                 if Actor.InteractiveComponents then
                     Actor.InteractiveComponents:Add(Component)
                 end
            end

            if IsValid(Component) then
                Component:InitCommonUIConfirmID(self.InteractionId)
                Component:SetSubmitId(self.SubmitId)
                Component:BindSuccessCallback(Callback)
                Actor.SubmitItemInteractiveComponent = Component
            end
        end
    })
end

function SubmitItemNode:Clear()
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    if self.NpcIdWithGender then
         
         -- 卸载组件逻辑
         local Npc = GameState.NpcCharacterMap:FindRef(self.NpcIdWithGender)
         if IsValid(Npc) and Npc.SubmitItemInteractiveComponent then
             Npc.SubmitItemInteractiveComponent:K2_DestroyComponent(Npc)
             Npc.SubmitItemInteractiveComponent = nil
         end
    elseif self.AssociatedObjectType == "Drop" then
         -- 尝试查找并卸载Drop/Mechanism上的组件
         local DropActor = nil
         local StaticCreator = GameState:GetStaticCreatorInfo(self.AssociatedObjectId)
         if StaticCreator then
             local ChildDrop = StaticCreator:GetChildEids():ToTable()
             if #ChildDrop > 0 then
                 local Eid = ChildDrop[1]
                 DropActor = GameState.CombatItemMap:FindRef(Eid)
             end
         end
         if IsValid(DropActor) and DropActor.SubmitItemInteractiveComponent then
             DropActor.SubmitItemInteractiveComponent:K2_DestroyComponent(DropActor)
             DropActor.SubmitItemInteractiveComponent = nil
         end
    end
    
    self:ClearGuide()
end

function SubmitItemNode:AddGuide()
    if self.bGuideUIEnable then
        MissionIndicatorManager:ActiveMissionIndicatorByNode(self)
    end
end

function SubmitItemNode:ClearGuide()
	if self.bGuideUIEnable then
		MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
	end
end

function SubmitItemNode:OnCancelTrack()
end

function SubmitItemNode:OnChooseTrack()
end

return SubmitItemNode
