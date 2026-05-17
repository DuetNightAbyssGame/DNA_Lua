--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Shop_BuyWalnutPart_Popup_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Text_Title:SetText(GText("UI_ModHolding_Title"))
end

function M:InitModList(ModId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self.VB_Content:ClearChildren()

    local Dict = self:GetModLevel2Count()

    local ModData = {}
    for k, v in pairs(Dict[ModId]) do
        table.insert(ModData, {
            Level = k,
            Count = v.Count,
            bMaxLevel = v.bMaxLevel
        })
    end

    table.sort(ModData, function(a, b)
        return a.Level < b.Level
    end)
    for _, v in ipairs(ModData) do
        local ModItemWidget = UIManager(self):_CreateWidgetNew("ModPopupItem")
        ModItemWidget:InitModItem(ModId, v.Level, v.Count, v.bMaxLevel)
        self.VB_Content:AddChild(ModItemWidget)
    end
end

function M:GetModLevel2Count()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local Dict = {}
    for ModUid, Data in pairs(Avatar.Mods) do
        if not Dict[Data.ModId] then
            Dict[Data.ModId] = {}
        end

        if not Dict[Data.ModId][Data.Level] then
            Dict[Data.ModId][Data.Level] = {}
        end
        if ((Data.MaxLevel or 0) + (Data.ModCardLevelMax or 0)) == Data.Level then
            Dict[Data.ModId][Data.Level].bMaxLevel = true
        end
        Dict[Data.ModId][Data.Level].Count = (Dict[Data.ModId][Data.Level].Count or 0) + Data.Count
    end
    return Dict
end

--function M:Destruct()
--end


return M
