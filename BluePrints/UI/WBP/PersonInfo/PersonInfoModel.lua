--- 个人主页Model
local PersonInfoCommon = require "BluePrints.UI.WBP.PersonInfo.PersonInfoCommon"
---
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
---
local M = Class("BluePrints.Common.MVC.Model")
function M:Init()
    M.Super.Init(self)
    self._Avatar = nil
    self:GetAvatar()
    self._ModelInfo = {}
    self._PersonID = nil
    self._DisplayPlan = {}
    self.OtherPersonInfo = nil
    self.OtherBattleDumpInfo = nil
    -- self:fakaini() 无服务端时测试用

end

-- 以下是参考数据样式
-- self._DisplayPlan.CharDisplayPlans = {{
--     CharId = uuid,
--     AppearancePlan = 1,
--     ModPlan = 2
-- }, {
--     CharId = -1,
--     AppearancePlan = 1,
--     ModPlan = 2
-- }, {
--     CharId = -1,
-- }}
-- self._DisplayPlan.WeaponDisplayPlans={
--  {WeaponId=uuid,ModPlan=1},
--  {WeaponId=uuid,ModPlan=1},
--  {WeaponId=-1}
-- }
function M:InitData(PlayerInfo)
    if self._Avatar == nil then
        self._Avatar = GWorld:GetAvatar()
    end
    if PlayerInfo ~= nil then
        self._PersonID = PlayerInfo.Uuid
        self.OtherPersonInfo = PlayerInfo
    else
        self._PersonID = nil
        self.OtherPersonInfo = nil
    end
    self.OtherRaidSeasonRankRecord = nil

    self._DisplayPlan = {}
    self._DisplayPlan.CharDisplayPlans = {
        [1] = {},
        [2] = {},
        [3] = {}
    }

    self._DisplayPlan.WeaponDisplayPlans = {
        [1] = {},
        [2] = {},
        [3] = {}
    }

    if self._PersonID ~= nil then
        local CharInfo = self:ChangeToCharBattleDumpInfo(PlayerInfo.Char)
        local WeaponInfo = self:ChangeToWeaponBattleDumpInfo(PlayerInfo.Weapon)
        self.OtherBattleDumpInfo = {
            Char = CharInfo,
            Weapon = WeaponInfo
        }
        self.OtherPersonInfo = PlayerInfo
        for i = 1, 3 do
            if self.OtherPersonInfo.Char[i] then
                self.OtherPersonInfo.Char[i].RoleId = self.OtherPersonInfo.Char[i].CharId
                self._DisplayPlan.CharDisplayPlans[i] = {
                    CharId = self.OtherPersonInfo.Char[i].CharId
                }
            end
            if self.OtherPersonInfo.Weapon[i] then
                self.OtherPersonInfo.Weapon[i].RoleId = self.OtherPersonInfo.Weapon[i].WeaponId
                self._DisplayPlan.WeaponDisplayPlans[i] = {
                    WeaponId = self.OtherPersonInfo.Weapon[i].WeaponId
                }
            end
        end

    else

        for i = 1, 3 do
            if self._Avatar.PersonalInfo.CharDisplay[i] ~= nil then
                if self._Avatar.Chars[self._Avatar.PersonalInfo.CharDisplay[i].Id] == nil then
                    self._Avatar.PersonalInfo.CharDisplay[i].Id = -1 -- 服务端传的ID无效
                end
                self._DisplayPlan.CharDisplayPlans[i] = {
                    CharId = self._Avatar.PersonalInfo.CharDisplay[i].Id,
                    AppearancePlan = self._Avatar.PersonalInfo.CharDisplay[i].AppearancePlan,
                    ModPlan = self._Avatar.PersonalInfo.CharDisplay[i].ModPlan
                }
            end
            if self._Avatar.PersonalInfo.WeaponDisplay[i] ~= nil then
                if self._Avatar.Weapons[self._Avatar.PersonalInfo.WeaponDisplay[i].Id] == nil then
                    self._Avatar.PersonalInfo.WeaponDisplay[i].Id = -1 -- 服务端传的ID无效
                end
                self._DisplayPlan.WeaponDisplayPlans[i] = {
                    WeaponId = self._Avatar.PersonalInfo.WeaponDisplay[i].Id,
                    ModPlan = self._Avatar.PersonalInfo.WeaponDisplay[i].ModPlan
                }
            end
        end

    end

    for i = 1, 3 do
        local Plan = self._DisplayPlan.CharDisplayPlans[i]
        if Plan == nil then
            self._DisplayPlan.CharDisplayPlans[i] = {
                CharId = -1
            }
        else
            if Plan.CharId == nil then
                Plan.CharId = -1
            end
        end

        Plan = self._DisplayPlan.WeaponDisplayPlans[i]
        if Plan == nil then
            self._DisplayPlan.WeaponDisplayPlans[i] = {
                WeaponId = -1
            }
        else
            if Plan.WeaponId == nil then
                Plan.WeaponId = -1
            end
        end

    end
end

function M:IniOthersAvatar()
end
-- 随机生成展览方案，无服务端时测试用
function M:fakaini()
    local i = 1;
    for __, char in pairs(self._Avatar.Chars) do
        if (i > 3) then
            break
        end
        self._DisplayPlan.CharDisplayPlans[i] = {
            CharId = char.Uuid,
            AppearancePlan = 1,
            ModPlan = 2
        }
        i = i + 1
    end
    i = 1;
    for __, weapon in pairs(self._Avatar.Weapons) do
        if (i > 3) then
            break
        end
        self._DisplayPlan.WeaponDisplayPlans[i] = {
            WeaponId = weapon.Uuid,
            ModPlan = 2
        }
        i = i + 1
    end
end
function M:SetPersonID(PersonID)
    self._PersonID = PersonID
end

-- 主界面展柜内容初始化
function M:GetDisplayContent()
    local DisplayContent = {
        CharContent = {},
        WeaponContent = {}
    }
    if self:IsOwener() then
        for index, Plan in ipairs(self._DisplayPlan.CharDisplayPlans) do
            -- body
            local uuid = Plan.CharId
            local CharData = {}
            if (uuid ~= -1) then
                local id = self._Avatar.Chars[uuid].CharId
                CharData.Id = id
                local IconPath = DataMgr["Char"][id].Icon
                CharData.Icon = IconPath
                local Rarity = DataMgr.Char[id].CharRarity
                CharData.Rarity = Rarity
                CharData.ItemType = "Char"
                CharData.Level = self._Avatar.Chars[uuid].Level
            else
                CharData.Id = uuid
            end
            DisplayContent.CharContent[index] = CharData

        end
        for index, Plan in ipairs(self._DisplayPlan.WeaponDisplayPlans) do
            -- body
            local WeaponData = {}
            local uuid = Plan.WeaponId

            if (uuid ~= -1) then
                local id = self._Avatar.Weapons[uuid].WeaponId

                WeaponData.Id = id
                local IconPath = DataMgr["Weapon"][id].Icon
                WeaponData.Icon = IconPath
                local Rarity = DataMgr.Weapon[id].WeaponRarity
                WeaponData.Rarity = Rarity
                WeaponData.Level = self._Avatar.Weapons[uuid].Level
            else
                WeaponData.Id = -1
            end
            DisplayContent.WeaponContent[index] = WeaponData
        end
    else -- 他人的主页
        for i = 1, 3 do
            -- body
            local CharData = {}
            if (self.OtherPersonInfo and self.OtherPersonInfo.Char and self.OtherPersonInfo.Char[i]) then
                local id = self.OtherPersonInfo.Char[i].CharId
                CharData.Id = id
                local IconPath = DataMgr["Char"][id].Icon
                CharData.Icon = IconPath
                local Rarity = DataMgr.Char[id].CharRarity
                CharData.Rarity = Rarity
                CharData.ItemType = "Char"
                CharData.Level = self.OtherPersonInfo.Char[i].Level
            else
                CharData.Id = -1
            end
            DisplayContent.CharContent[i] = CharData
        end

        for i = 1, 3 do
            -- body
            local WeaponData = {}
            if (self.OtherPersonInfo and self.OtherPersonInfo.Weapon and self.OtherPersonInfo.Weapon[i]) then
                local id = self.OtherPersonInfo.Weapon[i].WeaponId
                WeaponData.Id = id
                local IconPath = DataMgr["Weapon"][id].Icon
                WeaponData.Icon = IconPath
                WeaponData.ItemType = "Weapon"
                local Rarity = DataMgr.Weapon[id].WeaponRarity
                WeaponData.Rarity = Rarity
                WeaponData.Level = self.OtherPersonInfo.Weapon[i].Level
            else
                WeaponData.Id = -1
            end
            DisplayContent.WeaponContent[i] = WeaponData

        end
        DisplayContent.Birthday = self.OtherPersonInfo.Birthday
    end

    return DisplayContent

end

function M:GetCharSuitIndex(index)
    if index == -1 or index == nil then
        DebugPrint("index 不能为-1或0")
        return
    end
    local Uuid = self._DisplayPlan.CharDisplayPlans[index].CharId
    local suitindex = self._DisplayPlan.CharDisplayPlans[index].AppearancePlan
    if suitindex == -1 or suitindex == 0 then
        DebugPrint("外观方案为-1或0")
    end

    return Uuid, suitindex
end
function M:GetShowCharBaseInfo(index)
    if index == -1 then
        return nil
    end
    local CharId
    if self:IsOwener() then
        CharId = self._Avatar.Chars[self._DisplayPlan.CharDisplayPlans[index].CharId].CharId
    else
        if self.OtherPersonInfo and self.OtherPersonInfo.Char[index] and self.OtherPersonInfo.Char[index].CharId then
            CharId = self.OtherPersonInfo.Char[index].CharId
        else
            return nil
        end
    end
    local ElmtType = DataMgr.BattleChar[CharId].Attribute
    local IconName = "Armory_" .. ElmtType
    local AttributeIcon = LoadObject('/Game/UI/Texture/Dynamic/Atlas/Armory/T_' .. IconName .. ".T_" .. IconName)

    local Rarity = DataMgr.Char[CharId].CharRarity
    local Name = DataMgr.Char[CharId].CharName


    if not self:IsOwener() then
        --如果查看别人主页的男女主，直接拿到的是自己的名字，在这里转换成别人的名字
        if CharId==160101 or CharId==1601 then
            if self.OtherPersonInfo and self.OtherPersonInfo.Nickname then
                Name = self.OtherPersonInfo.Nickname
            end
        end
    end

    local CharData = {
        ["AttributeIcon"] = AttributeIcon,
        ["Rarity"] = Rarity,
        ["Name"] = Name
    }
    return CharData
end
function M:GetShowCharData(index)
    if self:IsOwener() then
        local CharData = self._Avatar.Chars[self._DisplayPlan.CharDisplayPlans[index].CharId]
        return CharData
    else
        for i, Char in pairs(self._fakeAvatar.Chars) do
            if Char.CharId == self.OtherBattleDumpInfo.Char[index].RoleId then
                return Char
            end
        end
        ScreenPrint("未找到对应的武器数据" ..  debug.traceback())
        return self._fakeAvatar.Chars[index]
    end
end

function M:GetShowWeaponData(index)
    if index == -1 then
        return nil
    end
    if self:IsOwener() then
        local WeaponData = self._Avatar.Weapons[self._DisplayPlan.WeaponDisplayPlans[index].WeaponId]
        return WeaponData
    else
        for i, weapon in pairs(self._fakeAvatar.Weapons) do
            if weapon.WeaponId == self.OtherBattleDumpInfo.Weapon[index].WeaponId then
                return weapon
            end
        end
        ScreenPrint("未找到对应的武器数据" .. debug.traceback())
    end

end

function M:IsOwener()
    if (self._PersonID ~= nil) then
        return false
    else
        return true
    end
end


--个人主页的基础数据
function M:GetPersonalBaseInfo()
    local _ModelInfo = {}
    if self:IsOwener() then
        _ModelInfo.PlayerName = self._Avatar.Nickname
        _ModelInfo.PlayerSignature = self._Avatar.Signature
        _ModelInfo.CurrentLevel = self._Avatar.Level
        _ModelInfo.HeadIconId = self._Avatar.HeadIconId
        _ModelInfo.HeadFrameId = self._Avatar.HeadFrameId
        _ModelInfo.Uid = self._Avatar.Uid
        _ModelInfo.IsOwner = true
        _ModelInfo.TitleFrame=self._Avatar.TitleFrame
        _ModelInfo.TitleAfter=self._Avatar.TitleAfter
        _ModelInfo.TitleBefore=self._Avatar.TitleBefore
    else
        _ModelInfo.PlayerName = self.OtherPersonInfo.Nickname
        _ModelInfo.PlayerSignature = self.OtherPersonInfo.Signature
        _ModelInfo.CurrentLevel = self.OtherPersonInfo.Level
        _ModelInfo.HeadIconId = self.OtherPersonInfo.HeadIconId
        _ModelInfo.HeadFrameId = self.OtherPersonInfo.HeadFrameId
        _ModelInfo.Uid = self.OtherPersonInfo.Uuid
        _ModelInfo.TitleFrame = self.OtherPersonInfo.TitleFrame
        _ModelInfo.TitleAfter = self.OtherPersonInfo.TitleAfter
        _ModelInfo.TitleBefore = self.OtherPersonInfo.TitleBefore
    end

    return _ModelInfo

end

function M:Destory()
    M.Super.Destory(self)
end
function M:GetWeaponUuid()
    return self._Avatar.WeaponUuid
end
function M:GetHeadIcon()
    local HeadFrameId = self._ModelInfo.HeadIconId
    if HeadFrameId then
        if HeadFrameId == -1 then
            return nil
        else
            local Path = DataMgr.HeadFrame[HeadFrameId].SmallIcon
            local ImageResource = LoadObject(Path)
            return ImageResource
        end
    end
end

function M:GetDisplayItemsUuid(bisweapon, index)
    local str
    if bisweapon == true then
        str = "Weapon"
    else
        str = "Char"
    end
    local uuid = self._DisplayPlan[str .. "DisplayPlans"][index][str .. "Id"]
    return uuid
end


function M:GetTemporModelPlan(bisweapon, index, Plans)
    local str, tempplans
    if bisweapon == true then
        str = "Weapon"
        tempplans = Plans.TempWeaponShowPlan
    else
        str = "Char"
        tempplans = Plans.TempCharShowPlan
    end
    if tempplans ~= nil and tempplans[index] then
        local plan = tempplans[index]
        return plan
    else
        return self._DisplayPlan[str .. "DisplayPlans"][index]
    end

end
function M:GetTemporModelBoxItemData(bisweapon, index, Plans)
    local data = self:GetTempEditBoxItemData(bisweapon, index, Plans)
    if data == -1 then
        return nil
    end -- temp中指出数据已被删除，不再加载model里的。
    if data == nil then
        return self:GetEditBoxItemData(bisweapon, index)
    end
    return data
end
function M:GetEditBoxItemData(bisweapon, index)
    local str
    if bisweapon == true then
        str = "Weapon"
    else
        str = "Char"
    end
    local uuid = self._DisplayPlan[str .. "DisplayPlans"][index][str .. "Id"]
    if uuid == -1 then
        return nil
    end
    local id = self._Avatar[str .. "s"][uuid][str .. "Id"]
    local data = {}
    local IconPath = DataMgr[str][id].GachaIcon
    data.image = LoadObject(IconPath)
    data.name = DataMgr[str][id][str .. "Name"]
    data.lv = self._Avatar[str .. "s"][uuid].Level
    local Rarity = DataMgr[str][id][str .. "Rarity"]
    data.Rarity = Rarity
    if bisweapon then
        data.Tag = self._Avatar[str .. "s"][uuid].WeaponTag
    end
    data.Uuid = uuid
    return data
end
-- 如果更换了展览方案但还没有保存，优先加载缓存的方案
function M:GetTempEditBoxItemData(bisweapon, index, Plans)
    local str, tempplan
    if bisweapon == true then
        str = "Weapon"
        tempplan = Plans.TempWeaponShowPlan
    else
        str = "Char"
        tempplan = Plans.TempCharShowPlan
    end
    local uuid
    if tempplan ~= nil and tempplan[index] then
        uuid = tempplan[index][str .. "Id"]

    end
    if uuid == -1 then
        return -1
    elseif uuid == nil then
        return nil
    end
    local id = self._Avatar[str .. "s"][uuid][str .. "Id"]
    local data = {}
    local IconPath = DataMgr[str][id].GachaIcon
    data.image = LoadObject(IconPath)
    data.name = DataMgr[str][id][str .. "Name"]
    data.lv = self._Avatar[str .. "s"][uuid].Level
    local Rarity = DataMgr[str][id][str .. "Rarity"]
    data.Rarity = Rarity
    if bisweapon then
        data.Tag = self._Avatar[str .. "s"][uuid].WeaponTag
    end
    data.Uuid = uuid

    return data
end
function M:GetItemName(bisweapon, content)
    local str
    if bisweapon then
        str = "Weapon"
    else
        str = "Char"
    end
    local id = content["UnitId"]
    return DataMgr[str][id][str .. "Name"]
end

function M:GetItemUuid(content)
    local id = content["Uuid"]
    return id
end
-- 提供的服务端接口参考
--  Avatar:AddCharDisplay(Callback, Id, AppearancePlan, ModPlan)
-- Avatar:RemoveCharDisplay(Callback, Index)
-- Avatar:UpdateCharDisplay(Callback, Index, Id, AppearancePlan, ModPlan)
-- Avatar:AddWeaponDisplay(Callback, Id, ModPlan)
-- Avatar:RemoveWeaponDisplay(Callback, Index)
-- Avatar:UpdateWeaponDisplay(Callback, Index, Id, ModPlan)
---保存展览信息
function M:SaveShowPlan(TempCharShowPlan, TempWeaponShowPlan)
    local strs = {"Char", "Weaqpon"}

    if TempCharShowPlan ~= nil then
        for i = 1, 3 do
            if TempCharShowPlan[i] ~= nil then
                local Plan = TempCharShowPlan[i]
                self:LocalUpdateCharDisplay(i, Plan.CharId, Plan.AppearancePlan, Plan.ModPlan)
            end
        end
        self:SortCharDisplay()

        for i = 1, 3 do
            if self._DisplayPlan.CharDisplayPlans[i] ~= nil then
                local Plan = self._DisplayPlan.CharDisplayPlans[i]
                if Plan.CharId ~= -1 and self._Avatar.PersonalInfo.CharDisplay[i] then
                    self._Avatar:UpdateCharDisplay(self.ReallyUpdate, i, Plan.CharId, Plan.AppearancePlan, Plan.ModPlan)
                elseif Plan.CharId ~= -1 and not self._Avatar.PersonalInfo.CharDisplay[i] then
                    self._Avatar:AddCharDisplay(self.ReallyUpdate, Plan.CharId, Plan.AppearancePlan, Plan.ModPlan)
                end

            end
        end
        -- 倒着遍历是因为Remove会影响后面角色的位置
        for i = 3, 1, -1 do
            if self._DisplayPlan.CharDisplayPlans[i] ~= nil then
                local Plan = self._DisplayPlan.CharDisplayPlans[i]
                if Plan.CharId == -1 and self._Avatar.PersonalInfo.CharDisplay[i] then
                    self._Avatar:RemoveCharDisplay(self.ReallyUpdate, i)
                end
            end
        end
    end

    if TempWeaponShowPlan ~= nil then
        for i = 1, 3 do
            if TempWeaponShowPlan[i] ~= nil then
                local Plan = TempWeaponShowPlan[i]
                self:LocalUpdateWeaponDisplay(i, Plan.WeaponId, Plan.ModPlan)
            end
        end
        self:SortWeaponDisplay()
        for i = 1, 3 do
            if self._DisplayPlan.WeaponDisplayPlans[i] ~= nil then
                local Plan = self._DisplayPlan.WeaponDisplayPlans[i]
                if Plan.WeaponId ~= -1 and self._Avatar.PersonalInfo.WeaponDisplay[i] then
                    self._Avatar:UpdateWeaponDisplay(self.ReallyUpdate, i, Plan.WeaponId, Plan.ModPlan)
                elseif Plan.WeaponId ~= -1 and not self._Avatar.PersonalInfo.WeaponDisplay[i] then
                    self._Avatar:AddWeaponDisplay(self.ReallyUpdate, Plan.WeaponId, Plan.ModPlan)
                end
            end
        end
        -- 倒着遍历是因为Remove会影响后面角色的位置
        for i = 3, 1, -1 do
            if self._DisplayPlan.WeaponDisplayPlans[i] ~= nil then
                local Plan = self._DisplayPlan.WeaponDisplayPlans[i]

                if Plan.WeaponId == -1 and self._Avatar.PersonalInfo.WeaponDisplay[i] then
                    self._Avatar:RemoveWeaponDisplay(self.ReallyUpdate, i)

                end
            end
        end

    end

end
---获得展柜上的角色信息
function M:GetDisplayCharInfos()
    local CharInfos = {}
    if self:IsOwener() then
        local Avatar = GWorld:GetAvatar()
        for index = 1, 3 do
            if self._DisplayPlan.CharDisplayPlans[index].CharId == -1 then
                return CharInfos
            end
            local Char = self._Avatar.Chars[self._DisplayPlan.CharDisplayPlans[index].CharId]
            ---补丁，同步角色展柜与预览模式的mod套装索引
            local ExtraModSuitIndex = self._DisplayPlan.CharDisplayPlans[index].ModPlan
            local AppearanceIndex = self._DisplayPlan.CharDisplayPlans[index].AppearancePlan
            local CharInfo = AvatarUtils:GetCharBattleInfo(Avatar, Char, ExtraModSuitIndex).RoleInfo
            CharInfo.AppearanceSuit = Char:DumpAppearanceSuit(Avatar, AppearanceIndex)
            table.insert(CharInfos, CharInfo)
        end
    else
        CharInfos = self.OtherBattleDumpInfo.Char
    end
    return CharInfos
end
---获得展柜上的武器信息
function M:GetDisplayWeaponInfos()
    local WeaponInfos = {}
    if self:IsOwener() then
        local Avatar = GWorld:GetAvatar()
        for index = 1, 3 do
            if self._DisplayPlan.WeaponDisplayPlans[index].WeaponId == -1 then
                return WeaponInfos
            end
            local Weapon = self._Avatar.Weapons[self._DisplayPlan.WeaponDisplayPlans[index].WeaponId]
            ---补丁，同步武器展柜与预览模式的mod套装索引
            local ExtraModSuitIndex = self._DisplayPlan.WeaponDisplayPlans[index].ModPlan
            local AvatarInfo = AvatarUtils:GetWeaponBattleInfo(Avatar, Weapon, ExtraModSuitIndex)
            local WeaponInfo
            if Weapon:IsMelee() then
                WeaponInfo = AvatarInfo.MeleeWeapon
            else
                WeaponInfo = AvatarInfo.RangedWeapon
            end
            table.insert(WeaponInfos, WeaponInfo)
        end
    else
        WeaponInfos = self.OtherBattleDumpInfo.Weapon
    end
    return WeaponInfos
end

-- 将服务器数据转换成军械库可用的BattleDump数据格式
function M:ChangeToCharBattleDumpInfo(CharInfos)
    local Chars = {}
    for i, CharInfo in ipairs(CharInfos) do
        local AppearanceSuit = {
            Colors = CharInfo.Appearance.SkinColors[CharInfo.Appearance.CurrentPlanIndex],
            SkinId = CharInfo.Appearance.SkinId,
            AccessorySuit = CharInfo.Appearance.Accessory,
            HairId = CharInfo.Appearance.HairId,
            HairColors = CharInfo.Appearance.HairColors,
        }
        local SkillInfos = {}
        for _, Skill in ipairs(CharInfo.Skills) do
            if not (Skill.LockState == 1) then
                local bOnlyPhantom = false
                local SkillData = DataMgr.Skill[Skill.SkillId][Skill.Level][CharInfo.GradeLevel]
                if SkillData then
                    bOnlyPhantom = SkillData.OnlyPhantom
                end
                if bOnlyPhantom then
                    goto continue
                end
                local SkillInfo = {}
                SkillInfo.Level = Skill.Level
                SkillInfo.ExtraLevel = Skill.ExtraLevel
                if CharInfo.GradeLevel ~= 0 then
                    SkillInfo.Grade = CharInfo.GradeLevel -- 角色阶级，就是技能阶级
                end
                table.insert(SkillInfos, {
                    SkillId = Skill.SkillId,
                    SkillInfo = SkillInfo
                })
            end
            ::continue::
        end
        local SlotData = {}
        local ModData = {}
        for Index, ModSuit in ipairs(CharInfo.ModSuit) do
            table.insert(SlotData, {
                ModEid = ModSuit.Mod and ModSuit.Mod.ModId or nil,
                SlotId = Index,
                Polarity = ModSuit.Polarity
            })

            if ModSuit.Mod then
                table.insert(ModData, {
                    Uuid = ModSuit.Mod.ModId,
                    ModId = ModSuit.Mod.ModId,
                    Level = ModSuit.Mod.Level,
                    CurrentModCardLevel = ModSuit.Mod.CurrentModCardLevel
                })
            end
        end

        local Char = {
            AppearanceSuit = AppearanceSuit,
            RoleId = CharInfo.CharId,
            Level = CharInfo.Level,
            GradeLevel = CharInfo.GradeLevel,
            EnhanceLevel = CharInfo.EnhanceLevel,
            SkillInfos = SkillInfos,
            SlotData = SlotData,
            ModData = ModData,
            SkillTreeInfos=CharInfo.SkillTree,
            ModSuitIndex = 1
        }
        table.insert(Chars, Char)
    end
    return Chars
end

-- 将服务器数据转换成军械库可用的BattleDump数据格式
function M:ChangeToWeaponBattleDumpInfo(WeaponInfos)
    local Weapons = {}
    for i, WeaponInfo in ipairs(WeaponInfos) do
        local AppearanceInfo = {
            SkinId = WeaponInfo.Appearance.SkinId,
            AccessoryId = WeaponInfo.Appearance.Accessory[1],
            Colors = {
                Colors = WeaponInfo.Appearance.SkinColors[WeaponInfo.Appearance.CurrentPlanIndex],
                SpecialColor = WeaponInfo.Appearance.SpecialColor[WeaponInfo.Appearance.CurrentPlanIndex]
            }
        }

        local SlotData = {}
        local ModData = {}
        for Index, ModSuit in ipairs(WeaponInfo.ModSuit) do
            table.insert(SlotData, {
                ModEid = ModSuit.Mod and ModSuit.Mod.ModId or nil,
                SlotId = Index,
                Polarity = ModSuit.Polarity
            })

            if ModSuit.Mod then
                table.insert(ModData, {
                    Uuid = ModSuit.Mod.ModId,
                    ModId = ModSuit.Mod.ModId,
                    Level = ModSuit.Mod.Level,
                    CurrentModCardLevel = ModSuit.Mod.CurrentModCardLevel
                })
            end
        end
        local Weapon = {
            AppearanceInfo = AppearanceInfo,
            WeaponId = WeaponInfo.WeaponId,
            Level = WeaponInfo.Level,
            GradeLevel = WeaponInfo.GradeLevel,
            EnhanceLevel = WeaponInfo.EnhanceLevel,
            SlotData = SlotData,
            ModData = ModData,
            ModSuitIndex = 1
        }
        table.insert(Weapons, Weapon)
    end
    return Weapons
end

-- 同步本地修改展柜方案，功能同对应服务端代码，
-- AppearancePlan = 1,
-- ModPlan = 2
function M:LocalUpdateCharDisplay(index, CharId, AppearancePlan, ModPlan)
    self._DisplayPlan.CharDisplayPlans[index] = {
        ["CharId"] = CharId or -1,
        ["AppearancePlan"] = AppearancePlan or 1,
        ["ModPlan"] = ModPlan or 1
    }
end
function M:LocalUpdateWeaponDisplay(index, WeaponId, ModId)
    self._DisplayPlan.WeaponDisplayPlans[index] = {
        ["WeaponId"] = WeaponId or -1,
        ["ModPlan"] = ModId or 1
    }
end
function M:ReallyUpdate()
    DebugPrint("yklua66 SuccessCallback")
end
-- 武器和角色展览方案会往左靠
function M:SortCharDisplay()
    local j = 1

    for i = 1, #self._DisplayPlan.CharDisplayPlans do
        local temp = self._DisplayPlan.CharDisplayPlans[i]
        if temp ~= nil and temp.CharId ~= -1 then
            if i ~= j then
                self._DisplayPlan.CharDisplayPlans[j] = self._DisplayPlan.CharDisplayPlans[i]
                self._DisplayPlan.CharDisplayPlans[i] = {
                    CharId = -1
                } -- 清空原位置元素
            end
            j = j + 1 -- 更新 j 的位置
        end
    end
    -- 移除多余的 nil 元素
    for k = j, #self._DisplayPlan.CharDisplayPlans do
        self._DisplayPlan.CharDisplayPlans[k] = {
            CharId = -1
        }
    end
end
function M:SortWeaponDisplay()
    local j = 1
    for i = 1, #self._DisplayPlan.WeaponDisplayPlans do
        local temp = self._DisplayPlan.WeaponDisplayPlans[i]
        if temp ~= nil and temp.WeaponId ~= -1 then
            if i ~= j then
                self._DisplayPlan.WeaponDisplayPlans[j] = self._DisplayPlan.WeaponDisplayPlans[i]
                self._DisplayPlan.WeaponDisplayPlans[i] = {
                    WeaponId = -1
                } -- 清空原位置元素
            end
            j = j + 1 -- 更新 j 的位置
        end
    end
    -- 移除多余的 nil 元素
    for k = j, #self._DisplayPlan.WeaponDisplayPlans do
        self._DisplayPlan.WeaponDisplayPlans[k] = {
            WeaponId = -1
        }
    end
end
---详情界面使用，返回指定box的展示方案
---@param bisweapon boolean 是否为武器
---@param index number 展示方案索引
---@return AppearancePlan, ModPlan 展示方案
function M:GetAppearanceAndModPlan(bisweapon, index)
    local str, plan = "Char", self._DisplayPlan.CharDisplayPlans[index]
    if bisweapon == true then
        str = "Weapon"
        plan = self._DisplayPlan.WeaponDisplayPlans[index]
    end
    if plan ~= nil then
        if bisweapon then
            return 1, plan.ModPlan
        else
            return plan.AppearancePlan, plan.ModPlan
        end
    else
        return 1, 1
    end
end
---------------打开别人页面相关--------------------------------------------------------

---查看他人主页调用，创建_fakeAvatar
function M:GetFakeAvatar()
    if self._fakeAvatar == nil then
        ArmoryUtils:CreateDummyAvatar({
            CharInfos = {self.OtherBattleDumpInfo.Char[1], self.OtherBattleDumpInfo.Char[2],
                         self.OtherBattleDumpInfo.Char[3]},
            WeaponInfos = {self.OtherBattleDumpInfo.Weapon[1], self.OtherBattleDumpInfo.Weapon[2],
                           self.OtherBattleDumpInfo.Weapon[3]}
        })
        ArmoryUtils:SwitchPreviewTargetState(ArmoryUtils.PreviewTargetStates.Custom)
        local Avatar = ArmoryUtils:GetAvatar()
        self._fakeAvatar = Avatar
        return Avatar
    else
        return self._fakeAvatar
    end
end
---打开他人主页关闭时调用，删除_fakeAvatar
function M:DeleteFakeAvatar()
    if self._fakeAvatar ~= nil then
        ArmoryUtils:DestroyDummyAvatar()
        self._fakeAvatar = nil
    end
end
---打开他人主页时获取数据界面可见性
function M:GetDataPageVisibility()
    if self:IsOwener() then
        ScreenPrint("不应该获取自己界面的可见性")
    else
    return self.OtherPersonInfo.Visible
    end
end
function M:ClearModel()
    self._ModelInfo = {}
    self._PersonID = nil
    self._DisplayPlan = {}
    self.OtherPersonInfo = nil
    self.OtherBattleDumpInfo = nil
end

-- 工会战历史记录相关数据函数
function M:GetGuildWarHistoryBaseInfo()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return {}
    end
    if self:IsOwener() then
        return {
            Uid = Avatar.Uid,
            Nickname = Avatar.Nickname,
            Level = Avatar.Level,
            HeadIconId = Avatar.HeadIconId,
            HeadFrameId = Avatar.HeadFrameId,
            TitleBefore = Avatar.TitleBefore,
            TitleAfter = Avatar.TitleAfter,
            TitleFrame = Avatar.TitleFrame,
        }
    end
    local Other = self.OtherPersonInfo or {}
    return {
        Uid = Other.Uuid,
        Nickname = Other.Nickname,
        Level = Other.Level,
        HeadIconId = Other.HeadIconId,
        HeadFrameId = Other.HeadFrameId,
        TitleBefore = Other.TitleBefore,
        TitleAfter = Other.TitleAfter,
        TitleFrame = Other.TitleFrame,
    }
end

function M:BuildGuildWarHistoryTopN(BaseInfo, RankRecord)
    -- DebugPrint("BuildGuildWarHistoryTopN Called")
    -- DebugPrintTable(BaseInfo, "BaseInfo")
    -- DebugPrintTable(RankRecord, "RankRecord")
    local List = {}
    for SeasonId, Record in pairs(RankRecord or {}) do
        local RankInfo = {}
        RankInfo.Uid = BaseInfo.Uid
        RankInfo.Nickname = BaseInfo.Nickname
        RankInfo.Level = BaseInfo.Level
        RankInfo.HeadFrameId = BaseInfo.HeadFrameId
        RankInfo.HeadIconId = BaseInfo.HeadIconId
        RankInfo.TitleBefore = BaseInfo.TitleBefore
        RankInfo.TitleAfter = BaseInfo.TitleAfter
        RankInfo.TitleFrame = BaseInfo.TitleFrame
        RankInfo.Score = Record.Score
        RankInfo.Rank = Record.Rank
        RankInfo.DisplayRank = Record.Rank
        RankInfo.MaxSquad = Record.Squad
        RankInfo.SeasonId = Record.SeasonId or SeasonId
        RankInfo.UpdateTime = Record.UpdateTime
        RankInfo.PreRaidGroupId = Record.PreRaidGroupId
        table.insert(List, RankInfo)
    end
    table.sort(List, function(a, b)
        local A = a.SeasonId or 0
        local B = b.SeasonId or 0
        if A == B then
            return (a.UpdateTime or 0) > (b.UpdateTime or 0)
        end
        return A > B
    end)
    return List
end

function M:BuildGuildWarHistorySelfRank(TopNInfo)
    if not TopNInfo or #TopNInfo == 0 then
        return {}
    end
    local First = TopNInfo[1]
    return {
        Rank = First.Rank,
        Score = First.Score,
        MaxSquad = First.MaxSquad,
        SeasonId = First.SeasonId,
        UpdateTime = First.UpdateTime,
        PreRaidGroupId = First.PreRaidGroupId,
    }
end

return M
