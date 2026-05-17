--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@class BP_PickUpInteractiveComponent_C : BP_InteractiveBaseComponent_C
local BP_PickUpInteractiveComponent_C = Class("BluePrints.Story.Interactive.InteractiveComponent.BP_InteractiveBaseComponent_C")


-- function BP_PickUpInteractiveComponent_C:ReceiveBeginPlay()
--     self.Super.ReceiveBeginPlay(self)
-- end

-- function BP_PickUpInteractiveComponent_C:TargetActorCanBePick(Character, Owner, ...)
-- 	if not IsValid(Character) then
-- 		return false
-- 	end
-- 	if Character:IsPhantom() then
-- 		local PhantomGetDrop = DataMgr.PhantomGetDrop[Owner.UnitId]
-- 		if not PhantomGetDrop or not PhantomGetDrop.IsCanDrop then
-- 			return false
-- 		end
-- 	end
-- 	return true
-- end

-- function BP_PickUpInteractiveComponent_C:IsCanInteractive(PlayerActor)
--     return self:IsCanInteractiveInternal(PlayerActor)
-- end

-- function BP_PickUpInteractiveComponent_C:CanInteractive(PlayerActor)
--     local Owner = self:GetOwner()
--     if not IsValid(Owner) then
--         return false
--     end
--     return self.DistanceCheck(Owner, PlayerActor, self.InteractiveDistance) and
--     self.BFaceToACheck(Owner, PlayerActor, self.InteractiveFaceAngle) and
--     self.BFaceToACheck(PlayerActor, Owner, self.InteractiveAngle)
-- end

function BP_PickUpInteractiveComponent_C:GetInteractiveName()
    if self.CommonUIConfirmID and self.CommonUIConfirmID > 0 then
        return self.Super.GetInteractiveName(self)
    end
    local ItemId = self:GetOuter():GetItemId()
    local ItemInfo = DataMgr.Drop[ItemId]
    return GText(ItemInfo.DropName)
end

function BP_PickUpInteractiveComponent_C:GetInteractiveIcon(PlayerActor)
    if self.CommonUIConfirmID and self.CommonUIConfirmID > 0 then
        return self.Super.GetInteractiveIcon(self, PlayerActor)
    end
    local ItemId = self:GetOuter():GetItemId()
    local ItemInfo = DataMgr.Drop[ItemId]
    local ImagePath = ItemInfo.Icon
    local ImageResource = nil
    if ImagePath then
        if string.find(ImagePath, "/Game/") == nil then
            ImagePath = '/Game/'..ImagePath
        end
        -- ImageResource = LoadObject(ImagePath)
    end
    return ImagePath, true
end

function BP_PickUpInteractiveComponent_C:BtnClicked(PlayerActor, InPressTimeSeconds)
    if not self:CheckInteractiveSucc(PlayerActor.Eid) then
        self:InteractiveFailed() 
        return
    end
    -- self:GetOuter():TryToSelectItem(true, PlayerActor)
    if self:GetOuter():CanBePickedUp(PlayerActor)  then
        self:GetOuter():ClearGuideIconComponent()
        self:GetOuter().ToCharacter = PlayerActor
        self:GetOuter():PickupOnTouch(PlayerActor)
    end
end

function BP_PickUpInteractiveComponent_C:GetRarity()
    if self.CommonUIConfirmID and self.CommonUIConfirmID > 0 then
        return 1
    end
    local ItemId = self:GetOuter():GetItemId()
    local ItemInfo = DataMgr.Drop[ItemId]
    return ItemInfo.Rarity
end

-- 是否可以被一键拾取
function BP_PickUpInteractiveComponent_C:CanPickUpWithOneClick()
    local ItemId = self:GetOuter():GetItemId()
    local ItemInfo = DataMgr.Drop[ItemId]
    local Res
    if ItemInfo.NotResDrop ~= nil then
        Res = not ItemInfo.NotResDrop
    else
        Res = true
    end
    return Res
end

-- function BP_PickUpInteractiveComponent_C:TriggerExit(PlayerActor)
--     self.Overridden.TriggerExit(self, PlayerActor)
--     local Owner = self:GetOwner()
--     Owner.IsJumping = false
-- 	if not (IsValid(self.ToCharacter) and self.IsBeingAutoPickup) then
--         Owner:CloseAutoPickup()
--     end
-- end

function BP_PickUpInteractiveComponent_C:GetQuestID()
    local Owner = self:GetOwner()
    if Owner then
        return Owner.QuestChainId
    end
    return nil
end

function BP_PickUpInteractiveComponent_C:GetSpecialQuestID()
    local Owner = self:GetOwner()
    if Owner then
        return Owner.ExtraRegionInfo.SpecialQuestId
    end
	return nil
end

return BP_PickUpInteractiveComponent_C
