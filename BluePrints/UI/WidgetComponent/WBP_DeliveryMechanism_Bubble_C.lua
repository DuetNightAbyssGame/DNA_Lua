--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local WBP_DeliveryMechanism_Bubble_C = Class("BluePrints.UI.BP_UIState_C")


function WBP_DeliveryMechanism_Bubble_C:Initialize(Initializer)
    -- self.IconDisplayDistance = 0
    -- self.MechanismLoc = FVector(0, 0, 0)
    -- self.BubbleHideTags = {}
    -- self.CurrentMissionIndicators = {}
end

--function WBP_DeliveryMechanism_Bubble_C:PreConstruct(IsDesignTime)
--end

function WBP_DeliveryMechanism_Bubble_C:Construct()
    self.Super.Construct(self)
    EventManager:AddEvent(EventID.OnChangeTaskIndicator, self, self.SetCurrentTrackingTaskIndicatorNames)
    self.IsDestroied = false
end

function WBP_DeliveryMechanism_Bubble_C:Destruct()
    self.Super.Destruct(self)
    EventManager:RemoveEvent(EventID.OnChangeTaskIndicator, self)
    self.IsDestroied = true
end

--function WBP_DeliveryMechanism_Bubble_C:Tick(MyGeometry, InDeltaTime)
--end

function WBP_DeliveryMechanism_Bubble_C:SetCurrentTrackingTaskIndicatorNames()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local CurrentMissionIndicators = MissionIndicatorManager:GetIndicatorUIObjByQuestChainIdWithType(Avatar.TrackingQuestChainId, "Task")
    self.IndicatorUINames:Clear()
    if not IsEmptyTable(CurrentMissionIndicators) then
        for _, UI in pairs(CurrentMissionIndicators) do
            self.IndicatorUINames:Add(UI:GetName())
        end
    end

    local CurrentSpecialSideTrackIndicators = MissionIndicatorManager:GetSpecialSideIndicatorUIObj()
    if not IsEmptyTable(CurrentSpecialSideTrackIndicators) then
        for _, UI in pairs(CurrentSpecialSideTrackIndicators) do
            self.IndicatorUINames:Add(UI:GetName())
        end
    end
end

-- function WBP_DeliveryMechanism_Bubble_C:TryHideByIconDisplayDistance()
--     if self.IconDisplayDistance == 0 then
--         return
--     end


--     if self:CheckIsNeedCollapseByDistance() then
--         self.BubbleHideTags["Distance"] = true
--     else
--         self.BubbleHideTags["Distance"] = false
--     end

--     if self:CheckIsNeedCollapseByTaskGuide() then
--         self.BubbleHideTags["TaskGuide"] = true
--     else
--         self.BubbleHideTags["TaskGuide"] = false
--     end
   
--     if self.BubbleHideTags["Distance"] == false and self.BubbleHideTags["TaskGuide"] == false then
--         self.Img_Entrance:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--     else
--         self.Img_Entrance:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     end

-- end

-- function WBP_DeliveryMechanism_Bubble_C:CheckIsNeedCollapseByDistance()
--     local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
--     if Player then
--         local Distance = UKismetMathLibrary.Vector_Distance(Player.CurrentLocation, self.MechanismLoc) / 100.0

--         if Distance > self.IconDisplayDistance then
--             return true
--         else
--             return false
--         end
--     end
-- end

-- function WBP_DeliveryMechanism_Bubble_C:CheckIsNeedCollapseByTaskGuide()
--     if not IsEmptyTable(self.CurrentMissionIndicators) then
--         for _, UI in pairs(self.CurrentMissionIndicators) do
--             local TaskIndicator = UI
--             if TaskIndicator and DataMgr.RegionGraph[TaskIndicator.PlayerRegionId] and 
--             DataMgr.RegionGraph[TaskIndicator.PlayerRegionId].SubRegionTarget and
--             DataMgr.RegionGraph[TaskIndicator.PlayerRegionId].SubRegionTarget.RegionTarget then
--                 local Data = DataMgr.RegionGraph[TaskIndicator.PlayerRegionId].SubRegionTarget.RegionTarget
--                 for _, v in pairs(Data) do
--                     if TaskIndicator.TargetPointName == v[2] and TaskIndicator.Guide_Node.Visibility == UE4.ESlateVisibility.SelfHitTestInvisible then
--                         return true
--                     end
--                 end
--             end
--         end
--     end
   
--     return false
-- end

return WBP_DeliveryMechanism_Bubble_C
