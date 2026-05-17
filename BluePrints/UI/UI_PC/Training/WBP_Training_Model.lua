local MonsterUtils = require "Utils.MonsterUtils"

local Model = {}

function Model:Init(Avatar)
    self.Avatar = Avatar
    self.TabId2MonsterCampOption = {}
end

function Model:GetTabData()
    local MonsterCampData = DataMgr.MonsterCamp
    local ConfigData = {
        Tabs = {},
    }

    table.insert(ConfigData.Tabs, {
        Text = GText("UI_DUNGEON_DES_TRAINING_18"),
        TabId = #ConfigData.Tabs + 1, 
        IconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_All.T_Tab_All",
        HideText = true,
    })

    self.TabId2MonsterCampOption[1] = "All"
    local TempDatas = {}
    for CampTag, CampData in pairs(MonsterCampData) do 
        local MonCampName = CampData.MonCampName 
        local MonCampIcon = CampData.MonCampIcon or "/Game/UI/UI_PNG/03Image/Monster_Head/Head_Empty.Head_Empty"
        local TempData = {
            Text = GText(MonCampName),
            IconPath = MonCampIcon,
            Priority = CampData.Priority,
            CampTag = CampTag,
        }
        table.insert(TempDatas, TempData)
    end
    
    table.sort(TempDatas, function(A, B)
        return A.Priority < B.Priority
    end)

    for _, Data in ipairs(TempDatas) do
        local TabData = {
            Text = Data.Text,
            TabId = #ConfigData.Tabs + 1, 
            IconPath = Data.IconPath,
            HideText = true,
        }
        self.TabId2MonsterCampOption[TabData.TabId] = Data.CampTag
        table.insert(ConfigData.Tabs, TabData)
    end

    table.insert(ConfigData.Tabs, {
        Text = GText("UI_DUNGEON_DES_TRAINING_23"),
        TabId = #ConfigData.Tabs + 1, 
        IconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Monster.T_Tab_Monster",
        HideText = true,
    })
    self.TabId2MonsterCampOption[#ConfigData.Tabs] = "Other"

    ConfigData.ChildWidgetBPPath = "WidgetBlueprint'/Game/UI/WBP/Common/Tab/Widget/WBP_Com_TabSubItem08.WBP_Com_TabSubItem08'"
    ConfigData.LeftGamePadKey = "LeftShoulder"
    ConfigData.RightGamePadKey = "RightShoulder"
    return ConfigData
end

function Model:FilterItemsForMonsterGallery(TabIdx, OnlyUnlocked)
    local MonsterCampOption = self.TabId2MonsterCampOption[TabIdx] or "All"
    local MonsterGalleryData = {}
    local Avatar = GWorld:GetAvatar()
    for Id, Info in pairs(DataMgr.GalleryRule) do
        local MonsterId = Info.PreferredMonsterId
        if not self:CheckMonsterInCamp(MonsterId, MonsterCampOption) or not MonsterUtils.CheckGallerRuleByMonsterRelease(Info)  then 
            goto continue 
        end
 
        local IsRuleUnlocked = self:CheckIsRuleIdUnlocked(Id)
        if Info.DisableTrainingGround ~= true  
            and ((not OnlyUnlocked) or IsRuleUnlocked) then
                    table.insert(MonsterGalleryData, {
                        Id = Id,
                        Info = Info,
                        IsLocked = not IsRuleUnlocked,
                        Priority = Info.Priority or 99999
                    })
        end

        ::continue::
    end
    table.sort(MonsterGalleryData, function(RuleA, RuleB)
        if RuleA.IsLocked ~= RuleB.IsLocked then
            return not RuleA.IsLocked 
        end

        if RuleA.Info.Priority ~= RuleB.Info.Priority then
            local GetFirstDigit = function(InNumber)
                return tonumber(string.sub(tostring(InNumber), 1, 1))
            end 

            local FirstDigitA = GetFirstDigit(RuleA.Info.Priority)
            local FirstDigitB = GetFirstDigit(RuleB.Info.Priority)
            if FirstDigitA ~= FirstDigitB then
                return FirstDigitA < FirstDigitB
            else
                return RuleA.Info.Priority < RuleB.Info.Priority
            end
        end
    end)

    return MonsterGalleryData
end

function Model:CheckMonsterInCamp(MonsterId, CampOption) 
    -- self.TabId2MonsterCampOption[0] = "All"
    -- self.TabId2MonsterCampOption[#self.TabId2MonsterCampOption] = "Other"

    local MonsterData = DataMgr.Monster[MonsterId]
    if not MonsterData then return false end 
    if CampOption == self.TabId2MonsterCampOption[1] then return true end  
    local MonsterGamePlayTags = MonsterData.GamePlayTags or {}

    for _, Tag in ipairs(MonsterGamePlayTags) do 
        if CampOption == self.TabId2MonsterCampOption[#self.TabId2MonsterCampOption] then 
            for Index, Option in ipairs(self.TabId2MonsterCampOption) do 
                if Option == self.TabId2MonsterCampOption[0] or Option == self.TabId2MonsterCampOption[#self.TabId2MonsterCampOption] then goto continue end 
                if Tag == Option then return false end
                ::continue::
            end
        elseif Tag == CampOption then 
            return true 
        end 
    end

    return CampOption == self.TabId2MonsterCampOption[#self.TabId2MonsterCampOption]   
end

function Model:CheckIsRuleIdUnlocked(RuleId)
    local Avatar = GWorld:GetAvatar()
    if Avatar.Archives[1006].ArchiveList[RuleId] then
        return true
    end

    return false
end


return Model