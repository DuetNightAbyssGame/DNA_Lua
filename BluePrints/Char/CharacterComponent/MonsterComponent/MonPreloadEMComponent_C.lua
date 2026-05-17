require "UnLua"

local M = Class()

function M:PreloadMonAccessory()
    -- Accessory Mesh
    local Paths = {}
    if self.Owner.Data.AccessoryIds and self.Owner.Data.AccessoryIds.Normal then
        for i = 1, #self.Owner.Data.AccessoryIds.Normal do
            local Path = DataMgr.BodyAccessory[self.Owner.Data.AccessoryIds.Normal[i]].ModelPath
            table.insert(Paths, Path)
        end
    end
        
    if self.Owner.Data.AccessoryIds and self.Owner.Data.AccessoryIds.Random then
        for i = 1, #self.Owner.Data.AccessoryIds.Random do
            local Path = DataMgr.BodyAccessory[self.Owner.Data.AccessoryIds.Random[i]].ModelPath
            table.insert(Paths, Path)
        end
    end

    -- Accessory BP
    table.insert(Paths, Const.CharResourcePaths.AccessoryBP)
    return Paths
end

function M:PreloadMonsterInitDependMontage()
	local ModelData = DataMgr.Model[self.Owner:GetCharModelComponent():GetCurrentModelId()]

    local Paths = {}
    -- 出生蒙太奇
    -- local BirthMontagePath = self.Owner:GetMonBirthMontagePath(ModelData)
    -- table.insert(Paths, BirthMontagePath)
    local RotationMontagePath = self.Owner:GetCharModelComponent():GetRotationMontagePath()
    table.insert(Paths, RotationMontagePath)
    -- CheckResourceExistOnDisk 有点耗
    -- if UResourceLibrary.CheckResourceExistOnDisk(BirthMontagePath) then 
    --     table.insert(Paths, BirthMontagePath)
    -- end

    self:MultiAssetPreload(Paths, ERoleInitAssetType.InitDependMontage, false)
end

function M:RegisterMonsterCustomConfig()
    -- todo wuzhijun: 需要处理Path=NULL的情况，这种情况Streamable回调的是CancelDelegate，我们代码只注册了CompleteDelegate
    -- 零散资源预加载
    self.CustomAssetsConfig = {}
    local function Register(_getPathFunc)
        table.insert(self.CustomAssetsConfig, _getPathFunc)
    end

    -- 注册
    Register(function() return self.Owner.Data.MiniMapIcon end)

    
    -- 注册 End

    if #self.CustomAssetsConfig == 0 then
        return
    end
    local Paths = {}
    for _, Func in pairs(self.CustomAssetsConfig) do
        table.insert(Paths, Func())
    end
    self:MultiAssetPreload(Paths, ERoleInitAssetType.CustomAssets, false)
end

function M:PreloadDistructableBody()
    self.Owner.DistructableBodyId = self.Owner:GetDistructableBodyId()
    -- DistructableBodyBp
    self:SingleAssetPreload(Const.CharResourcePaths.DistructableBodyBp, ERoleInitAssetType.DistructableBody, true)
   
    -- DistructableMesh
    -- local Paths = {}
    -- if self.Owner.DistructableBodyId then 
    --     local DistructableInfo = DataMgr.DistructableBody[self.Owner.DistructableBodyId]
    --     self.Owner.DistructableMeshNum = #DistructableInfo.PartMesh
    --     for i, v in pairs(DistructableInfo.PartMesh) do 
    --         table.insert(Paths, v)
    --     end
    -- end
    -- self:MultiAssetPreload(Paths, ERoleInitAssetType.DistructableMesh, false)
end

return M