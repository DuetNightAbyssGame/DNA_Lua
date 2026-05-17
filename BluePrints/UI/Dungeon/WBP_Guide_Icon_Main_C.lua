--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Guide_Icon_Main_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
function M:Initialize(Initializer)
    self.Super.Initialize(self)
    self.GuideIcons = {}
end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:AddChildToMain(GuideIconObj)
    if not GuideIconObj then
        return
    end
    local WidgetName = GuideIconObj.WidgetName
    DebugPrint("WBP_Guide_Icon_Main_C AddChildToMain", WidgetName)
    if self.GuideIcons[WidgetName] then
        DebugPrint("WBP_Guide_Icon_Main_C AddChildToMain", WidgetName, "Already Exists")
        return
    end
    self.GuideIconMain:AddChild(GuideIconObj)
    self:AddGuideIcon(GuideIconObj)
end

function M:AddGuideIcon(GuideIconObj)
    DebugPrint("WBP_Guide_Icon_Main_C AddGuideIcon", GuideIconObj.WidgetName)
    self.GuideIcons[GuideIconObj.WidgetName] = GuideIconObj
end

-- function M:GetGuideIconObj(UIName)
--     return self.GuideIcons[UIName]
-- end

function M:DeleteGuideIcon(UIName)
    DebugPrint("WBP_Guide_Icon_Main_C DeleteGuideIcon", UIName)
    self.GuideIcons[UIName] = nil
end

function M:Show(ShowTag)
    M.Super.Show(self, ShowTag)
    for k, v in pairs(self.GuideIcons) do
        if v then
            v:Show(ShowTag)
        end
    end
end

function M:Hide(HideTag)
    M.Super.Hide(self, HideTag)
    for k, v in pairs(self.GuideIcons) do
        if v then
            v:Hide(HideTag)
        end
    end
end

return M
