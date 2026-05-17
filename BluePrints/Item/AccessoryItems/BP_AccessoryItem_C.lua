require "UnLua"
require "DataMgr"

local BP_AccessoryItem_C = Class()

---------c++--------------
-- function BP_AccessoryItem_C:InitModelInfo(MeshResId, AttachRules, Attacher, SocketOwner, RulesId)
--     if not MeshResId then 
--         return 
--     end
--     local AccessoryItemMeshRes = MeshResId
--     local AccessoryItemMeshResInfo = DataMgr.Model[MeshResId]

--     if AccessoryItemMeshResInfo then 

--         AccessoryItemMeshRes = "/Game/" .. AccessoryItemMeshResInfo.SkeletonMeshPath
--     end

--     local ItemMeshRes = LoadObject(AccessoryItemMeshRes)
--     self:SetItemMesh(ItemMeshRes)
--     self.ItemMesh:CreateDynamicMaterialInstance(0)
--     self.SocketOwner = SocketOwner
--     -- local RelativeSocket = self.AttachRules.SocketA
--     -- local AttachToSocket = self.AttachRules.SocketB
--     -- if not RelativeSocket then 
--     --     RelativeSocket = "Root"
--     -- end
--     -- self:K2_AttachToComponent(self.SocketOwner.Mesh, AttachToSocket, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget)
--     -- self:_InverseAccessoryPosition(RelativeSocket)
--     -- local IsUsingWeapon = self.SocketOwner.UsingWeapon and self.SocketOwner.UsingWeapon.WeaponId == self.Attacher.WeaponId
--     -- if IsAuthority(self)then 
--     self.AttachRules = AttachRules
--     self.Attacher = Attacher
--     self.DataId = RulesId
--     print(_G.LogTag, 'InitModelInfozjy', self.Attacher.WeaponId, self.DataId)
--     -- end
--     if self.Attacher.InHand then 
--         self:WhenWeaponBindToHand()
--     else
--         self:WhenWeaponUnbindFromHand()
--     end
-- end

-- function BP_AccessoryItem_C:OnRep_DataId()
--     if self.AttachRules ~= nil then 
--         return 
--     end
--     if not self.Attacher then 
--         return 
--     end
--     print(_G.LogTag, 'OnRep_DataIdzjy', self.Attacher.WeaponId, self.DataId)
--     self:TryInitModelInfo()
-- end

-- function BP_AccessoryItem_C:OnRep_Attacher()
--     if self.AttachRules ~= nil then 
--         return 
--     end
--     if not self.DataId then 
--         return 
--     end
--     print(_G.LogTag, 'OnRep_Attacherzjy', self.Attacher.WeaponId, self.DataId)
--     self:TryInitModelInfo()
-- end

-- function BP_AccessoryItem_C:TryInitModelInfo()
--     print(_G.LogTag, 'TryInitModelInfozjy11')
--     -- PrintTable({TryInitModelInfozjy=self.Attacher}, 1000)
--     if not self.Attacher then 
--         return 
--     end
--     if not self.Attacher.ServerInitSuccess then 
--         return 
--     end
--     if not self.DataId then
--         return  
--     end
--     if not self.Attacher then 
--         return 
--     end
--     print(_G.LogTag, 'TryInitModelInfozjy', self.Attacher.WeaponId, self.DataId)
--     self.AttachRules = DataMgr.BattleWeapon[self.Attacher.WeaponId].WipCharmsAttachRules[self.DataId]
--     local MeshResId = DataMgr.BattleWeapon[self.Attacher.WeaponId].WipCharmsResIds[self.DataId]
--     local SocketOwner = self.Attacher:GetOwner()
--     self:InitModelInfo(MeshResId, self.AttachRules, self.Attacher, SocketOwner, self.DataId)
-- end

---------c++--------------
-- function BP_AccessoryItem_C:_InverseAccessoryPosition(SocketName)
--     -- PrintTable({_InverseWeaponPosition=SocketName})
--     local Transform = self.ItemMesh:GetSocketTransform(SocketName, UE4.ERelativeTransformSpace.RTS_Component)
--     local InverseTransform = Transform:Inverse()
--     self.ItemMesh:K2_SetRelativeTransform(InverseTransform, false, nil, true)
    
--     local Scale = Const.OneVector
--     if self.Attacher and self.Attacher.ScalerFactor then 
--         Scale = Scale * self.Attacher.ScalerFactor
--     end
--     self:SetActorScale3D(Scale)

-- end


-- function BP_AccessoryItem_C:OnEnter()
--     -- if not self.Attacher or not self.Attacher.InitSuccess then
--     --     return
--     -- end
-- end

-- function BP_AccessoryItem_C:OnLeave()
--     if not self.Attacher or not self.Attacher.InitSuccess then
--         return
--     end
--     -- not Current Weapon
--     self:OnWeaponNotUsing()
-- end

-- function BP_AccessoryItem_C:OnDismiss()
    
--     -- not equip weapon
--     self:OnWeaponNotUsing()
-- end

-- --------c++
-- function BP_AccessoryItem_C:WhenWeaponBindToHand()
--     if not self.Attacher or not self.Attacher.InitSuccess then
--         return
--     end
--     if not self.SocketOwner or not self.SocketOwner.InitSuccess then 
--         -- self:SetActorHideTag("BindToHand", true, false)
--         return
--     end
--     -- self:SetActorHideTag("UnbindFromHand", false, false)
--     local HandHoldSocket = self.AttachRules["HandHold"]
--     if not HandHoldSocket then 
--         -- self:SetActorHideTag("BindToHand", true, false)
--         return
--     end
--     local RelativeSocket = HandHoldSocket.SocketA
--     local AttachToSocket = HandHoldSocket.SocketB
--     if not RelativeSocket then 
--         RelativeSocket = "Root"
--     end
    
--     self:K2_AttachToComponent(self.SocketOwner.Mesh, AttachToSocket, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.KeepWorld)
--     self:_InverseAccessoryPosition(RelativeSocket)
--     -- self:SetActorHideTag("BindToHand", false, false)
-- end

function BP_AccessoryItem_C:OnWeaponNotUsing()
    -- if not self.Attacher or not self.Attacher.InitSuccess then
    --     return
    -- end
    -- if self.AttachRules and self.AttachRules.VisibleWhenNotCurrentWeapon then 
    --     -- self:SetActorHideTag("NotUsing", false, false)
    --     return 
    -- end
    -- print('1111OnWeaponNotUsing1111zjy', self.Attacher.WeaponId)
    -- self:SetActorHideTag("NotUsing", true, false) 
end

-------c+
-- function BP_AccessoryItem_C:WhenWeaponUnbindFromHand()
--     if not self.Attacher or not self.Attacher.InitSuccess then
--         -- self:SetActorHideTag("UnBindFromHand", true, false)
--         return
--     end
--     if not self.SocketOwner or not self.SocketOwner.InitSuccess then 
--         -- self:SetActorHideTag("UnBindFromHand", true, false)
--         return
--     end
--     -- self:SetActorHideTag("BindToHand", false, false)
--     if not self.AttachRules then
--         -- self:SetActorHideTag("UnBindFromHand", true, false)
--         return 
--     end
--     local UnbindSocket = self.AttachRules["UnbindHand"]
--     if not UnbindSocket then 
--         -- self:SetActorHideTag("UnBindFromHand", true, false)
--         return
--     end
--     local RelativeSocket = UnbindSocket.SocketA
--     local AttachToSocket = UnbindSocket.SocketB
--     if not RelativeSocket then 
--         RelativeSocket = "Root"
--     end
    
--     self:K2_AttachToComponent(self.SocketOwner.Mesh, AttachToSocket, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.KeepWorld)
--     self:_InverseAccessoryPosition(RelativeSocket)
--     print(_G.LogTag, 'WhenWeaponUnbindFromHandzjy', 'UnBindFromHand Visible')
--     -- self:SetActorHideTag("UnBindFromHand", false, false)
--     if not self.SocketOwner.UsingWeapon or self.SocketOwner.UsingWeapon.WeaponId ~= self.Attacher.WeaponId then
--         self:OnWeaponNotUsing()
--         return
--     end
-- end


return BP_AccessoryItem_C
