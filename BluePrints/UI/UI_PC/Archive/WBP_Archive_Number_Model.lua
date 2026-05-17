local MonsterUtils = require "Utils.MonsterUtils"
---@class ArchiveNumberModel
local ArchiveNumberModel = {}
ArchiveNumberModel.ArchiveType2Name = {
    [1001] = "Character",
    [1002] = "Melee",
    [1003] = "Ranged",
    [1004] = "Resource",
    [1005] = "Read",
    [1006] = "Enemy",
}

function ArchiveNumberModel:GetCharacterSumNumber()
    local CurrentVersion = DataMgr.GlobalConstant.CurrentVersion.ConstantValue
    local Sum = 0
    local Flag = false
    for _,Info in pairs(DataMgr.Char) do
        if not Info.IsNotOpen then
            if not Info.ReleaseVersion or CurrentVersion >= Info.ReleaseVersion then
                if Info.GenderTag then
                    if not Flag then
                        Flag = true
                        Sum = Sum + 1
                    end
                else
                    Sum = Sum + 1
                end
            end
        end
    end
    return Sum
end

function ArchiveNumberModel:GetMeleeSumNumber()
    local CurrentVersion = DataMgr.GlobalConstant.CurrentVersion.ConstantValue
    local Sum = 0
    for _,Info in pairs(DataMgr.Weapon) do
        local WeaponTags = DataMgr.BattleWeapon[Info.WeaponId].WeaponTag
        if not Info.IsNotOpen and WeaponTags then
            if not Info.ReleaseVersion or CurrentVersion >= Info.ReleaseVersion then
                for _,Tag in pairs(WeaponTags) do
                    if Tag == "Melee" then
                        Sum = Sum + 1
                        break
                    end
                end
            end
        end
    end
    return Sum
end

function ArchiveNumberModel:GetRangedSumNumber()
    local CurrentVersion = DataMgr.GlobalConstant.CurrentVersion.ConstantValue
    local Sum = 0
    for _,Info in pairs(DataMgr.Weapon) do
        local WeaponTags = DataMgr.BattleWeapon[Info.WeaponId].WeaponTag
        if not Info.IsNotOpen and WeaponTags then
            if not Info.ReleaseVersion or CurrentVersion >= Info.ReleaseVersion then
                for _,Tag in pairs(WeaponTags) do
                    if Tag == "Ranged" then
                        Sum = Sum + 1
                        break
                    end
                end
            end
        end
    end
    return Sum
end

function ArchiveNumberModel:GetResourceSumNumber()
    local Sum = 0
    for _,Info in pairs(DataMgr.Resource) do
        if Info.ItemArchiveType == 1 or Info.ItemArchiveType == 2 then
            Sum = Sum + 1
        end
    end
    return Sum
end

function ArchiveNumberModel:GetReadSumNumber()
    local BookSeries = {}
    local Sum = 0
    for _,Info in pairs(DataMgr.Resource) do
        if Info.BookSeriesId and DataMgr.BookSeriesArchive[Info.BookSeriesId] then
            if not BookSeries[Info.BookSeriesId] then
                BookSeries[Info.BookSeriesId] = 1
                Sum = Sum + 1
            end
        end
    end
    return Sum
end

function ArchiveNumberModel:GetEnemySumNumber()
    local Sum = 0
    for _,Info in pairs(DataMgr.GalleryRule) do
        if not Info.DisableArchive and MonsterUtils.CheckGallerRuleByMonsterRelease(Info) then
            Sum = Sum + 1
        end
    end
    return Sum
end

function ArchiveNumberModel:GetCurrentNumber(ArchiveType)
    local Avatar = GWorld:GetAvatar()
    local CurrentNum = 0
    if ArchiveType == 1005 then
        CurrentNum = self:GetCurrentBookNumber()
        -- local BookSeries = {}
        -- for _,Info in pairs(DataMgr.Resource) do
        --     if Info.BookSeriesId then
        --         if not BookSeries[Info.BookSeriesId] then
        --             BookSeries[Info.BookSeriesId] = {}
        --         end
        --         BookSeries[Info.BookSeriesId][Info.ResourceId] = 1
        --     end
        -- end
        -- if Avatar then
        --     local ArchiveList = Avatar.Archives[ArchiveType].ArchiveList
        --     for Id,_ in pairs(ArchiveList) do
        --         if BookSeries[DataMgr.Resource[Id].BookSeriesId] then
        --             BookSeries[DataMgr.Resource[Id].BookSeriesId][Id] = 2
        --         end
        --     end
        --     for BookSeriesId,SeriesInfo in pairs(BookSeries) do
        --         local Flag = true
        --         for Id,State in pairs(SeriesInfo) do
        --             if State == 1 then
        --                 Flag = false
        --                 break
        --             end
        --         end
        --         if Flag then
        --             CurrentNum = CurrentNum + 1
        --         end
        --     end
        -- end
    else
        if Avatar then
            if ArchiveType == 1001 then
                local Char = DataMgr.Char
                local Flag = false
                for Id,_ in pairs(Avatar.Archives[ArchiveType].ArchiveList) do
                    if Char[Id].GenderTag then
                        if not Flag then
                            Flag = true
                            CurrentNum = CurrentNum + 1
                        end
                    else
                        CurrentNum = CurrentNum + 1
                    end
                end
            else
                CurrentNum = Avatar.Archives[ArchiveType]:GetArchiveCount()
            end
        end
    end
    return CurrentNum
end

function ArchiveNumberModel:GetCurrentBookNumber()
    local Avatar = GWorld:GetAvatar()
    local RemainBookSeries = {}
    local ReadSumNumber = 0
    for _,Info in pairs(DataMgr.Resource) do
        if Info.BookSeriesId and DataMgr.BookSeriesArchive[Info.BookSeriesId] then
            if not RemainBookSeries[Info.BookSeriesId] then
                ReadSumNumber = ReadSumNumber + 1
                RemainBookSeries[Info.BookSeriesId] = {}
            end
            RemainBookSeries[Info.BookSeriesId][Info.ResourceId] = 1
        end
    end
    if Avatar then
        local ArchiveList = Avatar.Archives[1005].ArchiveList
        for Id,_ in pairs(ArchiveList) do
            if RemainBookSeries[DataMgr.Resource[Id].BookSeriesId] then
                RemainBookSeries[DataMgr.Resource[Id].BookSeriesId][Id] = nil
                if IsEmptyTable(RemainBookSeries[DataMgr.Resource[Id].BookSeriesId]) then
                    RemainBookSeries[DataMgr.Resource[Id].BookSeriesId] = nil
                end
            end
        end
    end
    local RemainBookSeriesNum = 0
    for _,_ in pairs(RemainBookSeries) do
        RemainBookSeriesNum = RemainBookSeriesNum + 1
    end
    local CurrentNum = ReadSumNumber - RemainBookSeriesNum
    return CurrentNum
end

return ArchiveNumberModel