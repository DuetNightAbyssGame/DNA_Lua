--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_PersonalInfo_Data_Sub02_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end
--[[
Contents={
{
    SubTitle=string,
    Count=Int
}
}
]]
function M:OnListItemObjectSet(TabInfo)
    self.Text_DataDetailTitle:SetText(GText(TabInfo.Name))
    local Contents=TabInfo.Contents
    for i=1,#Contents do
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        Obj.Des=Contents[i].Des or ""
        Obj.Count=Contents[i].Count 
        Obj.Index=i
        self.List_Data:AddItem(Obj)
    end
end
-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
