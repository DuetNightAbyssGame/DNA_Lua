

local Component = {}
local CommonUtils = require "Utils.CommonUtils"

function Component:ServerSetUpDestructableBody()
    if not self:IsMonster()then 
        return 
    end

    local DistructableClass = UE4.UClass.Load(Const.CharResourcePaths.DistructableBodyBp)
    if not DistructableClass then 
        return
    end

    if not self.DestructParts then 
        --Temp
        --self:TrySetupWithDataTable()
        return 
    end
    
    -- self:GetSocketMap()
    local BindTransform = FTransform()
    for PartId, _Comp in pairs(self.DestructParts) do
        local NewDistructable = self:GetWorld():SpawnActor(DistructableClass, BindTransform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn, self, self, nil)
        if NewDistructable then 
            NewDistructable:K2_AttachToComponent(self.Mesh, "Root", UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget)
            NewDistructable:InitInfoFromComponent(self, _Comp)
        end
    end
end

-- function Component:TrySetupWithDataTable()
--     self.DistructableBodyId = self:GetDistructableBodyId()
    
--     if not self.DistructableBodyId then 
--         return 
--     end

--     local DistructableClass = UE4.UClass.Load(Const.CharResourcePaths.DistructableBodyBp)
--     if not DistructableClass then 
--         return
--     end
--     self:GetSocketMap()
    
--     if not self.SocketPartsMap then
--         self.SocketPartsMap = {}
--     end
--     self.UsingTableToInit = true
--     local BindTransform = FTransform()

--     for SocketName, SocketInfo in pairs(self.SocketMap)do
--         local NewDistructable = self:GetWorld():SpawnActor(DistructableClass, BindTransform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn, self, self, nil)
--         if NewDistructable then 
--             NewDistructable:SetAttr("Hp", self:GetAttr("Hp") * SocketInfo.Hp)
--             NewDistructable:SetAttr("MaxHp", self:GetAttr("Hp") * SocketInfo.Hp)
--             NewDistructable:CalcHpPercent()
--             NewDistructable:SetAttr("Camp", self:GetAttr("Camp"))
--             NewDistructable:SetAttr("DEF", self:GetAttr("DEF"))
--             NewDistructable:K2_AttachToComponent(self.Mesh, "Root", UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget)
--             NewDistructable.RootComponent:K2_SetRelativeTransform(FTransform(), false, nil, true)
--             self.SocketPartsMap[SocketName] = NewDistructable
--             local TableInfo = self.SocketMap[SocketName]
--             NewDistructable:InitInfo(self, SocketName,TableInfo)
--         end
--     end
--     -- print(_G.LogTag, "NewDistructableNewDistructableNewDistructableNewDistructable", self.TestShijingzhe)
-- end


function Component:RegisterAttachment(AttachmentName, Attachment)
    -- if not self.SocketPartsMap then 
    --     self.SocketPartsMap = {}
    -- end
    self.SocketPartsMap:Add(AttachmentName, Attachment)
    -- if self.UsingTableToInit then 
    --     self:RegisterAttachmentWithTable(AttachmentName, Attachment)
    --     return 
    -- end
    local PartId = Attachment.PartId
    local PartToAttach = self.DestructParts[PartId]
    Attachment.AutoActive = PartToAttach.AutoActive
    Attachment.DisableCollision = PartToAttach.DisableCollision
    print(_G.LogTag, "RegisterAttachmentRegisterAttachmentRegisterAttachment",PartId,PartToAttach.AutoActive)
	Attachment.HpPercent = PartToAttach.HpPercent
    self:RegisterAttachment_Cpp(PartToAttach, Attachment)
    print(_G.LogTag, "RegisterAttachmentRegisterAttachment", PartToAttach.ItemMeshComp)
    Attachment:SetItemMesh(self.Mesh, PartToAttach.ItemMeshComp)
    Attachment.Material = Attachment.ItemMesh:CreateDynamicMaterialInstance(0)
    local SocketPartsMapNum = self.SocketPartsMap:Length()
    local PartNum = CommonUtils.TableLength(self.DestructParts)
    assert(SocketPartsMapNum <= PartNum, "Destructable body Num Dosen't Match" .. SocketPartsMapNum, PartNum)
    print(_G.LogTag, "GZJYRegisterAttachmentRegisterAttachment", SocketPartsMapNum, PartNum)

    if (SocketPartsMapNum == PartNum) then 
        self:TryShowOrHideParts()
    end
end

-- function Component:RegisterAttachmentWithTable(AttachmentName, Attachment)
--     if not self.SocketMap then 
--         self:GetSocketMap()
--     end
--     local TableInfo = self.SocketMap[AttachmentName]
--     if not TableInfo then 
--         return 
--     end
--     Attachment.AutoActive = TableInfo.AutoActive
--     local Mesh = TableInfo.PartMesh
-- 	local MeshObj = UE4.UResourceLibrary.FindObject(self, Mesh)
-- 	if not MeshObj then 
-- 		MeshObj = LoadObject(Mesh)
-- 	end
--     Attachment:SetItemMesh_Old(self.Mesh, MeshObj)
--     Attachment.Material = Attachment.ItemMesh:CreateDynamicMaterialInstance(0)
--     Attachment.BoxComponent:K2_AttachToComponent(Attachment.ItemMesh, AttachmentName, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget, UE4.EAttachmentRule.SnapToTarget)
--     -- Attachment:SetTransferDamage(true)
--     local RelativeTransform = self:GetBoxTransform(AttachmentName)
-- 	if RelativeTransform then 
-- 		Attachment:K2_SetActorRelativeLocation(RelativeTransform.Translation, false, nil, false)
-- 		Attachment.ItemMesh:K2_SetRelativeLocation(-RelativeTransform.Translation, false, nil, false)
-- 		local Transform = Attachment.ItemMesh:GetSocketTransform(AttachmentName, UE4.ERelativeTransformSpace.RTS_Component)
-- 		local RelativeTrans = UE4.UKismetMathLibrary.MakeRelativeTransform(RelativeTransform, Transform)
-- 		Attachment.BoxComponent:K2_SetRelativeTransform(RelativeTrans, false, nil, false)
--         Attachment.JumpWordLocSocket = Attachment.BoxComponent
-- 		 --DebugPrint('222222222222222222222222222222zjy', self.BoxComponent:GetRelativeTransform().Translation, RelativeTrans)
-- 	end
--     self:TryShowOrHideParts()
--     -- self.Mesh = self.ItemMesh
-- end

function Component:TryShowOrHideParts()
    local HpNum = 0
    for Name, Comp in pairs(self.SocketPartsMap) do 
        if Comp.AutoActive then 
            HpNum = HpNum + 1
            Comp:Activate()
            self:SwitchHelpAimSocketPoint(Name, true)

        else
            Comp:Deactivate()
            self:SwitchHelpAimSocketPoint(Name, false)
        end       
    end
    self.HpNum = HpNum
    print(_G.LogTag, 'GZJY_BornWith',self.HpNum)
    self:GetOwnBlackBoardComponent():SetValueAsInt("ActivePartNum", self.HpNum)
end

function Component:GetSockeId(SocketName)
    return self.SocketPartsMap:FindRef(SocketName).PartId
end

-- function Component:OnPartBreak(SocketName)
--     local HpId = self:GetSockeId(SocketName)
--     self:SwitchHelpAimSocketPoint(SocketName, false)
--     self.HpNum = self.HpNum - 1
--     self.HpNum = UE4.UKismetMathLibrary.Clamp(self.HpNum, 0, self.MaxHpNum)
--     print(_G.LogTag, 'GZJY_OnPartBreak',self.HpNum, HpId, SocketName)
--     self:GetOwnBlackBoardComponent():SetValueAsInt("ActivePartNum", self.HpNum)
--     self:OnPartBreakedEvent(HpId)

-- end

-- function Component:ReActiveDistructBodyPart(PartIds, ActivateAll, ActivatePart)
--     if Const.UseNewCreateUnit then 
--         CallOverridden(self, PartIds, ActivateAll, ActivatePart)
--         return 
--     end
--     print(_G.LogTag, 'ReActiveDistructBodyParts',self.HpNum,PartIds:Num(),ActivateAll, ActivatePart)

--     if ActivateAll then 
--         self:ActivateParts(ActivatePart, self.SocketPartsMap)
--     else
--         self:PreActivateParts(PartIds, ActivatePart)
--     end
-- end

function Component:ActivateParts(ShouldActivate, ActivateMap)
    for Name, Comp in pairs(ActivateMap) do 
        if ShouldActivate and (not Comp.IsActivated) then 
            self.HpNum = self.HpNum + 1
            Comp:Activate()
        elseif (not ShouldActivate) and Comp.IsActivated then 
            self.HpNum = self.HpNum - 1
            Comp:Deactivate()
        elseif ShouldActivate == Comp.IsActivated then 
            print(_G.LogTag, "GZJY Has Part was Activate before Reborn")
        end
        self:SwitchHelpAimSocketPoint(Name, ShouldActivate)
    end
    print(_G.LogTag, 'GZJY_ReActiveDistructBodyPartsFinal',self.HpNum,ShouldActivate, debug.traceback('GZJY'))
    if not IsAuthority(self) then 
        return 
    end
    self:GetOwnBlackBoardComponent():SetValueAsInt("ActivePartNum", self.HpNum)
end

function Component:PreActivateParts(PartIds, ActivatePart)
    local PartToActivate = {}
    for Name, Comp in pairs(self.SocketPartsMap) do 
        if PartIds:Contains(Comp.PartId) then 
            PartToActivate[Name] = Comp
        end
    end
    self:ActivateParts(ActivatePart, PartToActivate)
    -- local DistrutableInfo = DataMgr.DistructableBody[self.DistructableBodyId]
    -- for i, v in pairs(PartIds) do 
    --     local BloodInfo = DistrutableInfo.BloodInfo[v]
    --     local SocketName = BloodInfo.socket
    --     if BloodInfo then 
    --         self:_ActivatePart(SocketName, ActivatePart)
    --     end
    -- end
    -- self.HpNum = UE4.UKismetMathLibrary.Clamp(self.HpNum, 0, self.MaxHpNum)
    -- -- self.HpNum = UE4.UKismetMathLibrary.Clamp(self.HpNum, 0, self.MaxHpNum)
    -- -- print('1111111111111111111111111111111111111111111111111111111zjy', self.HpNum)
    -- if (self.HpNum == 0) then 
    --     print(_G.LogTag, 'GZJY_ActivateParts222',self.HpNum,ActivatePart, debug.traceback('GZJY'))
    -- end
    -- print(_G.LogTag, 'GZJY_ActivateParts',self.HpNum)
    -- if not IsAuthority(self) then 
    --     return 
    -- end
    -- self:GetOwnBlackBoardComponent():SetValueAsInt("ActivePartNum", self.HpNum)
end

-- function Component:_ActivatePart(SocketName, ActivatePart)
--     if ActivatePart then 
--         self.SocketPartsMap[SocketName]:OnRecover()
--     else
--         self.SocketPartsMap[SocketName]:OnHidden()
--     end
--     self:SwitchHelpAimSocketPoint(SocketName, ActivatePart)
--     if self:IsPartDisabled(SocketName) and ActivatePart then 
--         self.HpNum = self.HpNum + 1
--     elseif not self:IsPartDisabled(SocketName) and not ActivatePart then 
--         self.HpNum = self.HpNum - 1
--     end
--     self.SocketMap[SocketName].Disabled = not ActivatePart
-- end

-- function Component:DestroyActorOnDead()
--     if not self.SocketPartsMap then 
--         return 
--     end
--     if self.SocketPartsMap:Length() == 0 then 
--         return 
--     end
--     for i, v in pairs(self.SocketPartsMap)do 
--         v:Destroy()
--     end
--     self.SocketPartsMap:Clear()
-- end


-- function Component:GetDestructablePart(SocketName)
--     if not self.SocketPartsMap then 
--         return 
--     end
--     if self.SocketPartsMap:Length() == 0 then 
--         return
--     end
--     return self.SocketPartsMap:FindRef(SocketName)
-- end

-- function Component:IsPartDisabled(SocketName)
--     if not self.SocketPartsMap then 
--         return 
--     end
--     if self.SocketPartsMap:Length() == 0 then 
--         return true
--     end
--     return not self.SocketPartsMap:FindRef(SocketName).IsActivated
-- end

-- function Component:GetDestructablePartAllLive()
    
--     local AllParts = TArray(ADistructableBodyActor)
--     if not self.SocketPartsMap then 
--         return AllParts
--     end
--     if self.SocketPartsMap:Length() == 0 then 
--         return AllParts
--     end
--     for i, v in pairs(self.SocketPartsMap) do 
--         if not self:IsPartDisabled(i) then 
--             AllParts:Add(v) 
--         end
--     end
--     return AllParts
-- end
-- function Component:GetBoxTransform(SocketName)
--     if not self.SocketMap then 
--         self:GetSocketMap()
--     end
--     local SocketMap = self.SocketMap
--     if not SocketMap[SocketName] then 
--         return 
--     end
--     local TransformList = SocketMap[SocketName].BoxTransform
--     local Translation = FVector(TransformList[1],TransformList[2],TransformList[3])
--     local Rotation = FRotator(TransformList[5], TransformList[6], TransformList[4])
--     local Scale = FVector(TransformList[7],TransformList[8],TransformList[9])
--     local Transform = FTransform()
--     Transform.Translation = Translation
--     Transform.Rotation = Rotation:ToQuat()
--     Transform.Scale3D = Scale
--     return Transform --{Translation=Translation, Rotation = Rotation, Scale = Scale}

-- end

-- function Component:GetSocketMesh(SocketName)
--     if not self.SocketMap then 
--         self:GetSocketMap()
--     end
--     local SocketMap = self.SocketMap
--     if not SocketMap[SocketName] then 
--         return 
--     end
--     return SocketMap[SocketName].PartMesh
-- end

-- function Component:IsDisableAtBegin(SocketName)
--     if not self.SocketMap then 
--         self:GetSocketMap()
--     end
--     local SocketMap = self.SocketMap
--     if not SocketMap[SocketName] then 
--         return 
--     end
--     return not SocketMap[SocketName].IsActive
-- end

-- function Component:IsPartDisabled(SocketName)
--     if not self.SocketMap then 
--         self:GetSocketMap()
--     end
--     local SocketMap = self.SocketMap
--     if not SocketMap[SocketName] then 
--         return 
--     end
--     return SocketMap[SocketName].Disabled or SocketMap[SocketName].Disabled == nil
-- end

-- function Component:HasAlreadyInit(SocketName)
--     if not self.SocketMap then 
--         self:GetSocketMap()
--     end
--     local SocketMap = self.SocketMap
--     if not SocketMap[SocketName] then 
--         return 
--     end
--     return SocketMap[SocketName].Disabled ~= nil
-- end

-- function Component:GetSocketMap()
--     if not self.SocketMap then 
--         self.SocketMap = {}
--     end
--     -- local DistrutableInfo = DataMgr.DistructableBody[self.DistructableBodyId]
--     if not self.HpNum then 
--         self.HpNum = 0
--     end
--     for i, v in pairs(DistrutableInfo.BloodInfo) do
--         -- if v.IsActive then 
--         --     self.HpNum = self.HpNum + 1
--         -- end
--         local Info = {PartId= i, Hp = v.Hp, AutoActive= v.IsActive, PartMesh = DistrutableInfo.PartMesh[i], BoxTransform = DistrutableInfo.BoxTransform[i]}
--         self.SocketMap[v.socket] = Info
--     end
--     self.MaxHpNum = #DistrutableInfo.BloodInfo
--     -- if not IsAuthority(self) then 
--     --     return 
--     -- end
--     -- self:GetOwnBlackBoardComponent():SetValueAsInt("ActivePartNum", self.HpNum)
-- end

return Component