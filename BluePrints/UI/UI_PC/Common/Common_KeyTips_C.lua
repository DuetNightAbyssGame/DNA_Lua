--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_KeyTips_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
--- 备注：该控件适用于某些界面没有Com_Tab，但又要求底部展示按键提示的地方
--- 如果界面中已经用Com_Tab，请用Com_Tab里封装的函数
--- 有需要扩展功能的自行扩展功能

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

-- 实例：
--BottomKeyInfo = {
--    { 单个按键
--        KeyInfoList = {{Type = "Img", ImgShortPath = "RV"}},
--        Desc = "滚动浏览"
--    },
--    { Add型组合键
--        KeyInfoList = {
--            {Type = "Img", ImgShortPath = "LT"},
--            {Type = "Img", ImgShortPath = "RS"},
--        },
--        Desc = "滚动套装列表",
--        Type = "Add",
--     }
--}
function M:UpdateKeyInfo(BottomKeyInfo)
    self.Panel_Key:ClearChildren()
    self.ComKeys={}
    for i, KeyInfo in ipairs(BottomKeyInfo) do
        local KeyWidget = UIManager(self):_CreateWidgetNew("ComKeyTextDesc")
        self.Panel_Key:AddChild(KeyWidget)
        table.insert(self.ComKeys,KeyWidget)
        if #KeyInfo.KeyInfoList > 1 then
            KeyWidget:CreateSubKeyDesc(KeyInfo)
        else
            KeyWidget:CreateCommonKey(KeyInfo)
        end
    end
end
function M:UpdateKeyInfoNew(BottomKeyInfo)
    self.ComKeys = self.ComKeys or {}
    for i, _ in ipairs(BottomKeyInfo) do
        local BottomKeyWidget = self.ComKeys[i]
        if (not IsValid(BottomKeyWidget)) then
            BottomKeyWidget = UIManager(self):_CreateWidgetNew("ComKeyTextDesc")
            self.ComKeys[i] = BottomKeyWidget
            self.Panel_Key:AddChild(BottomKeyWidget)
        else
            --BottomKeyWidget.Key:ClearChildren()
            BottomKeyWidget:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
    end
    for i = #BottomKeyInfo+1,#self.ComKeys do
        local BottomKeyWidget = self.ComKeys[i]
        if ( IsValid(BottomKeyWidget)) then
            BottomKeyWidget:RemoveFromParent()
        end
        self.ComKeys[i] = nil
    end
    for i, KeyInfo in ipairs(BottomKeyInfo) do
        local KeyWidget = self.ComKeys[i]
        if #KeyInfo.KeyInfoList > 1 then
            KeyWidget:CreateSubKeyDesc(KeyInfo)
        else
            KeyWidget:CreateCommonKey(KeyInfo)
        end
    end
end
function M:GetComKeyById(Index)
    return self.ComKeys[Index]
end
function M:ClearChildren()
    self.Panel_Key:ClearChildren()
    self.ComKeys = nil
end

return M
