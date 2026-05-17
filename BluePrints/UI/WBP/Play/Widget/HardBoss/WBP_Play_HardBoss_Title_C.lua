--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Play_HardBoss_Title_Xibi_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:SetInfo(Name)
    if Name then
        local Text = GText(Name)
        if Text then
            local Length = string.len(Text)
            local left_quote  = "“"
            local right_quote = "”"
            local left_len  = #left_quote
            local right_len = #right_quote
            if Length >= left_len + right_len then
                if Text:sub(1, left_len) == left_quote and Text:sub(-right_len) == right_quote then
                    Text = Text:sub(left_len+1, -right_len-1)
                end
            end
        end
        self.Text_BossName:SetText(Text)
        self.Text_WorldBossName:SetText(EnText(Name))
    end
end

return M
