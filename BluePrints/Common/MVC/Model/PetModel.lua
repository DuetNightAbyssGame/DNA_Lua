local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"

---仅包含本地缓存数据
---@class PetModel
local M=Class()

local _ResourcePetMap = {}
local _PetMap = {}
function M:Init(Pets)
    _PetMap = {}
    _ResourcePetMap = {}
    if(Pets)then
        for key, Pet in pairs(Pets) do
            _PetMap[key] = key
            if(Pet:IsResourcePet())then
                _ResourcePetMap[key] = key
            end
        end
    end
    EventManager:AddEvent(EventID.OnNewPetObtained, self, self.OnNewPetObtained)
    EventManager:AddEvent(EventID.OnPetDeleted, self, self.OnPetDeleted)
    try({
        exec = function()
            ArmoryUtils:CreateReddotInfos(CommonConst.DataType.Pet)
        end,
        catch = function (err)
            local trace = debug.traceback()
            err = err or ""
            DebugPrint("Error: 宠物红点数据创建失败！".."\n"..trace)
        end,
    })
    self.Inited = true
end

function M:IsPetExist(UniqueID)
    return not not _PetMap[UniqueID],not not _ResourcePetMap[UniqueID]
end

---新增宠物时
function M:OnNewPetObtained(UniqueID)
    if(not self.Inited)then return end
    local Avatar = GWorld:GetAvatar()
    local Pet = Avatar.Pets[UniqueID]
    if(Pet)then
        _PetMap[UniqueID] = UniqueID
        if(Pet:IsResourcePet())then
            _ResourcePetMap[UniqueID] = UniqueID
        end
        ArmoryUtils:TryAddNewPetReddot(Pet, UniqueID)
    end
end

---删除宠物时
function M:OnPetDeleted(UniqueID)
    if(not self.Inited)then return end
    _PetMap[UniqueID] = nil
    _ResourcePetMap[UniqueID] = nil
    ArmoryUtils:SetItemReddotRead({ItemType = CommonConst.DataType.Pet,UniqueId = UniqueID},true,true,true)
end

function M:Destory()
    self.Inited = false
    _PetMap = {}
    _ResourcePetMap = {}
    EventManager:RemoveEvent(EventID.OnNewPetObtained, self)
    EventManager:RemoveEvent(EventID.OnPetDeleted, self)
end

return M