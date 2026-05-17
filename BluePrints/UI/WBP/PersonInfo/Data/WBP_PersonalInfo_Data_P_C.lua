--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR 叶轲
-- @DATE 2025.7.23
--
require "UnLua"

---@type WBP_PersonalInfo_Data_M_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
M._components = {"BluePrints.UI.WBP.PersonInfo.Data.PersonInfoDataPageBaseView"}
---仅初始化lua变量时使用，千万不要有控件操作！！
-- function M:Initialize(Initializer)
-- end

function M:Construct()
    -- self:InitTab()
    -- self:InitBaseView()
    self:AddTimer(0.2, function()
        self:InitTab()
        self:InitNormalBottonKey()
    end)
    self.Com_SortDown:BindOnRemovedFromFocusPathEvent(self, function()
        if self.IsGamePad then
            self:InitNormalBottonKey()
        end
    end)
    self:SetFocus()
end

function M:InitNormalBottonKey()
    DebugPrint("InitNormalBottonKey The Length of ScrollBox is :" .. self.ScrollBox:GetScrollOffsetOfEnd())
    if self.ScrollBox:GetScrollOffsetOfEnd() > 1 then
        self:InitTab()
    else
        self:InitTabWithoutScroll()
    end
end
function M:InitBaseView()
end

---初始化Tab，用的是主界面的Tab
function M:InitTab()
    local TabInfo = {
        Tabs = self.AllTabInfo,
        DynamicNode = {"Back", "Tip", "BottomKey"},
        BottomKeyInfo = {{
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "RV",
                Owner = self
            }},
            Desc = GText("UI_Controller_Slide")
        }, {
            KeyInfoList = {{
                Type = "Text",
                Text = "Esc",
                ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "B",
                ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            Desc = GText("UI_BACK")

        }},
        StyleName = "Text",
        OwnerPanel = self,
        TitleName = GText("UI_PersonalPage_Recount_Name"),
        BackCallback = self.OnReturnKeyDown
    }

    self.Root.Com_Tab:Init(TabInfo)
end
function M:InitTabWithScroll()
    local ScroolKeyInfo = {
        GamePadInfoList = {{
            Type = "Img",
            ImgShortPath = "RV",
            Owner = self
        }},
        Desc = GText("UI_Controller_Slide")
    }
    local BottomKeyInfo = {
        {
            GamePadInfoList = {{
                Type = "Img",
                ImgShortPath = "RV",
                Owner = self
            }},
            Desc = GText("UI_Controller_Slide")
        },
        {
        KeyInfoList = {{
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
        }},
        GamePadInfoList = {{
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
        }},
        Desc = GText("UI_BACK")

    }}
    self.Root.Com_Tab:UpdateSingleBottomKeyInfo(ScroolKeyInfo)
end

function M:InitTabWithoutScroll()
    local BottomKeyInfo = {
        -- KeyInfoList = {{
        --     Type = "Text",
        --     Text = "Esc",
        --     ClickCallback = self.OnReturnKeyDown,
        --     Owner = self
        -- }},
        -- GamePadInfoList = {{
        --     Type = "Img",
        --     ImgShortPath = "B",
        --     ClickCallback = self.OnReturnKeyDown,
        --     Owner = self
        -- }},
        -- Desc = GText("UI_BACK")

    }
    self.Root.Com_Tab:UpdateSingleBottomKeyInfo(1,BottomKeyInfo)
end
function M:InitTabInSortDown()
    local BottomKeyInfo = {{
        GamePadInfoList = {{
            Type = "Img",
            ImgShortPath = "A",
            -- ClickCallback = self.OnReturnKeyDown,
            Owner = self
        }},
        Desc = GText("UI_Tips_Ensure")
    }, {
        KeyInfoList = {{
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
        }},
        GamePadInfoList = {{
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
        }},
        Desc = GText("UI_BACK")

    }}
    self.Root.Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo)
end
-- function M:Tick(MyGeometry, InDeltaTime)
-- end

-- 交互相关
function M:OnReturnKeyDown()
    ---相关实现在通用组件
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    self.Com_SortDown:ReceiveKeyDown_Lua(MyGeometry, InKeyEvent)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        self.IsGamePad = true
        IsEventHandled = self:OnGamePadDown(InKeyName)
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        self.IsGamePad = false
        if (InKeyName == "Escape") then
            self:OnReturnKeyDown()
            IsEventHandled = true
        end
    end
    return UE4.UWidgetBlueprintLibrary.Handled()

end

-- 手柄相关
function M:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    DebugPrint("OnGamePadDown" .. InKeyName)
    if (InKeyName == UIConst.GamePadKey.FaceButtonRight) then
        self:OnReturnKeyDown()
        IsEventHandled = true
    elseif InKeyName == UIConst.GamePadKey.LeftThumb then
        self:InitTabInSortDown()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then
        self:OnClickHistoryRank()
    end

    return IsEventHandled
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == UIConst.GamePadKey.RightAnalogY) then
        local DeltaOffset = (-1) * UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 20
        if self.ScrollBox then
            self:AddDeltaOffset(DeltaOffset)
        end
    end
    return UIUtils.Handled
end

function M:AddDeltaOffset(DeltaOffset)
    local CurrentOffset = self.ScrollBox:GetScrollOffset()
    local OffsetToEnd = self.ScrollBox:GetScrollOffsetOfEnd()
    local NextOffset = math.clamp(CurrentOffset + DeltaOffset, 0, OffsetToEnd)
    DebugPrint("CurrentOffset  " .. CurrentOffset .. "  OffsetToEnd  " .. OffsetToEnd)
    self.ScrollBox:SetScrollOffset(NextOffset)
end

---
-- function M:Destruct()
-- end

AssembleComponents(M)
return M
