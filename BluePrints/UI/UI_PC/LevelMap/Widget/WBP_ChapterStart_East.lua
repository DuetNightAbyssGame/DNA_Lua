--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_ChapterStart_East_YanJinDu_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)

    local Id = ...
    if Id then
        local Info = DataMgr.RegionShowUI[tonumber(Id)]
        if self.Text_Title then
            self.Text_Title:SetText(GText(Info.TitleText))
        end
        if self.Text_BackTitle then
            self.Text_BackTitle:SetText(GText(Info.TransText))
        end
        AudioManager(self):PlayUISound(self, Info.AudioPath, nil, nil)
    else
        DebugPrint("lk配表数据不存在")
    end   
end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M
