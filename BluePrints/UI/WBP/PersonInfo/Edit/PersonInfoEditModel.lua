--- 个人主页Edit Model
local UnLua = require "UnLua"
-- 由于大部分逻辑依赖与personinfo model所以很多编辑界面的东西还放在那里，这里目前是item的数据
local M = Class("BluePrints.Common.MVC.Model")
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
function M:Init()
    M.Super.Init(self)
    self._Avatar = nil
    self:GetAvatar()

    -- self:InitPersonInfo()

end
-- 根据tag得到展柜可选择的item数据。tag为Ranged或Melee
function M:GetWeaponItemsData(WeaponTag)
    local Avatar = self._Avatar
    self[WeaponTag .. "ItemContentsMap"] = {}
    self[WeaponTag .. "ItemContentsArray"] = {}
    local ItemContentsMap = self[WeaponTag .. "ItemContentsMap"]
    local ItemContentsArray = self[WeaponTag .. "ItemContentsArray"]
    local Obj = nil
    for Uuid, Weapon in pairs(Avatar.Weapons) do
        if (Weapon:HasTag(WeaponTag)) then
            Obj = ArmoryUtils:NewCharOrWeaponItemContent(Weapon, CommonConst.ArmoryType.Weapon, self.WeaponTag, true)
            table.insert(ItemContentsArray, Obj)
            ItemContentsMap[Uuid] = Obj
        end
    end
    return ItemContentsArray
end
function M:GetCharItemsData()

    local Avatar = self._Avatar
    self.CharItemContentsMap = {}
    self.CharItemContentsArray = {}
    -- self.BP_CharItemContents:Clear()
    local Obj = nil
    for Uuid, Char in pairs(Avatar.Chars) do
        Obj =
            ArmoryUtils:NewCharOrWeaponItemContent(Char, CommonConst.ArmoryType.Char, CommonConst.ArmoryTag.Char, true)
        Obj.IsNew = false -- 个人主页不需要nil
        self.CharItemContentsMap[Uuid] = Obj
        table.insert(self.CharItemContentsArray, Obj)
    end
    return self.CharItemContentsArray
end
function M:GetMeleeItemsData()
    return self:GetWeaponItemsData("Melee")
end
function M:GetRangedItemsData()
    return self:GetWeaponItemsData("Ranged")
end

-- 存table里可能会被gc，需要转换存放至c++Tarray
function M:InitEditData(EditPage)
    if not self._Avatar then
        self._Avatar=GWorld:GetAvatar()
    end
    EditPage.MeleeItemContentsCache:Clear()
    EditPage.RangedItemContentsCache:Clear()
    EditPage.CharItemContentsCache:Clear()
    -- 转换MeleeItems数据
    local MeleeItems = self:GetMeleeItemsData()
    if MeleeItems then
        for i = 1, #MeleeItems do
            local Item = MeleeItems[i]
            if Item then
                EditPage.MeleeItemContentsCache:Add(Item)
            else
                DebugPrint("Invalid MeleeItem at index:" .. tostring(i))
            end
        end
    end

    -- 转换RangedItems数据
    local RangedItems = self:GetRangedItemsData()
    if RangedItems then
        for i = 1, #RangedItems do
            local Item = RangedItems[i]
            if Item then
                EditPage.RangedItemContentsCache:Add(Item)
            else
                DebugPrint("Invalid RangedItem at index:" .. tostring(i))
            end
        end
    end

    -- 转换CharItems数据

    local CharItems = self:GetCharItemsData()
    if CharItems then
        for i = 1, #CharItems do
            local Item = CharItems[i]
            if Item then
                EditPage.CharItemContentsCache:Add(Item)
            else
                DebugPrint("Invalid CharItem at index:" .. tostring(i))
            end
        end
    end
end
function M:Destory()
    M.Super.Destory(self)
end

return M
