--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local EMCache = require "EMCache.EMCache"

---@class WBP_Common_Dialog_Announcement_PC_C : Common_Dialog_Announcement_PC_C
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

function M:GetLocalizationContent(Content)
    
end

function M:InitContent(Params, PopupData, Owner)
    local Info = Params.NoticeInfo 
    if not Info then return end 

    -- Content列表存放的是多语言版本的内容，这里先默认运营会配置好，拿第一个显示
    local Content = Info.Content[1] 
    local SystemLanguage = EMCache:Get("SystemLanguage")
    for _, InfoContent in ipairs(Info.Content) do 
        if InfoContent.language == SystemLanguage then 
            Content = InfoContent
            break 
        end
    end

    local Title = Content.title   
    local Body = Content.body  

    local dateTimeTable = os.date("*t", math.floor(Info.StartTimestamp))

    -- 提取年月日等信息
    local Year = dateTimeTable.year
    local Month = dateTimeTable.month
    local Day = dateTimeTable.day

    -- DebugPrint("Tianyi@ Year: " .. Year .. " Month: " .. Month .. " Day: " .. Day)
    local DateStr = GDate("Date_YMD", {Year=Year, Month=Month, Day=Day})
    self.Text_Date:SetText(DateStr)
    self.Text_Title:SetText(Title)
    self.Text_Details:SetText(Body)

end

return M
