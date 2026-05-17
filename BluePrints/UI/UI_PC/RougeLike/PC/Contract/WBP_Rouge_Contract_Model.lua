local SkillUtils = require "Utils.SkillUtils"

---@class RougeContractModel
local RougeContractModel = {}

function RougeContractModel:InitModel(Avatar)
    self.Avatar = Avatar
    self.SeasonId = self.Avatar.RougeLike.ProgressingSeasonId
    
    self.SelectedContracts = {}
    for ContractId, ContractLevel in pairs(self.Avatar.RougeLike.Contract) do 
        self.SelectedContracts[ContractId] = ContractLevel
    end
end

---@param OnlySelected bool 是否只返回被选中的
function RougeContractModel:GetContractItemList(OnlySelected)
    local ContractItemList = {}
    if not self.SeasonId then 
        DebugPrint("获取契约列表失败，当前赛季为空!")
        UE.ARougeLikeManager.ShowRougeLikeError("获取契约列表失败，当前赛季为空! 请策划排查!")
        return 
    end
    local ContractSeasonData = DataMgr.RougeLikeSeason[self.SeasonId]
    if not ContractSeasonData then 
        DebugPrint("获取契约列表失败，当前赛季不存在!")
        UE.ARougeLikeManager.ShowRougeLikeError("获取契约列表失败，当前赛季不存在! 请策划排查!")
        return 
    end

    local OpenContracts = ContractSeasonData.OpenContract

    for Index, ContractId in ipairs(OpenContracts) do 
        local SelectedLevel = self:GetContractLevel(ContractId)
        if OnlySelected and SelectedLevel <= 0 then 
            goto continue
        end

        local ContractData = DataMgr.RougeLikeContract[ContractId]
        local ItemObj = NewObject(UIUtils.GetCommonItemContentClass())
        ItemObj.ContractId = ContractId
        ItemObj.Icon = ContractData.Icon
        ItemObj.Name = GText(ContractData.Name)
        ItemObj.MaxLevel = ContractData.MaxLevel
        ItemObj.HeatValuePerLevel = ContractData.HeatValue
        ItemObj.Icon = ContractData.Icon
        ItemObj.SelectedLevel = SelectedLevel
        ItemObj.Desc = self:MakeContractDesc(ContractData, ItemObj.SelectedLevel)
        ItemObj.Model = self
        table.insert(ContractItemList, ItemObj)

        ::continue::
    end

    return ContractItemList
end

function RougeContractModel:SetContractLevel(ContractId, Level)
    self.SelectedContracts[ContractId] = Level
    if Level <= 0 then 
        self.SelectedContracts[ContractId] = nil
    end
end
function RougeContractModel:GetContractLevel(ContractId)
    return self.SelectedContracts[ContractId] or 0
end

function RougeContractModel:ResetContractLevel()
    self.SelectedContracts = {}
end

function RougeContractModel:MakeContractDesc(ContractData, Level)
    Level = Level or 0
    local ResultDesc = string.gsub(GText(ContractData.Desc) or "", "#%d", function(Word) 
        local Index = tonumber(string.sub(Word, 2, 2))
        if Index and ContractData.DescValues[Index] then 
            return SkillUtils.CalcSkillDesc(ContractData.DescValues[Index], math.max(Level - 1, 0))
        end

        DebugPrint("找不到契约" .. ContractData.Id .. " 的第 " .. Index  .. " 条描述, 请策划排查, 查看RougeLikeContract表!")
        UE.ARougeLikeManager.ShowRougeLikeError("找不到契约" .. ContractData.Id .. " 的第 " .. Index  .. " 条描述,  请策划排查, 查看RougeLikeContract表!")
        return "?"
    end)

    -- ...
    return ResultDesc
end

-- 获得当前热度值
function RougeContractModel:GetCurrentHeatValue()
    local HeatValue = 0
    for ContractId, ContractLevel in pairs(self.SelectedContracts) do 
        local ContractData = DataMgr.RougeLikeContract[ContractId]
        if ContractData then 
            HeatValue = HeatValue + ContractData.HeatValue * ContractLevel
        end
    end

    return HeatValue
end

-- 获得当前热度积分加成
function RougeContractModel:GetCurrentContractPointRate()
    local ContractSeasonData = DataMgr.RougeLikeSeason[self.SeasonId]
    if ContractSeasonData then 
        -- TODO: 检查是否填了赛季积分倍率
        if not ContractSeasonData.PointContractRate then 
            UE.ARougeLikeManager.ShowRougeLikeError("当前赛季未填写赛季积分倍率! 请策划排查")
            return 0
        end
        return (ContractSeasonData.PointContractRate * self:GetCurrentHeatValue())
    end

    return 0
end

function RougeContractModel:ConfirmSelectedContract()
    self.Avatar.RougeLike.Contract = self.SelectedContracts
    self.Avatar:SaveContract(nil, self.Avatar.RougeLike.Contract)
end



return RougeContractModel