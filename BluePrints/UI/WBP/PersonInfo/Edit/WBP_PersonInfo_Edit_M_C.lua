--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_PersonalInfo_Edit_M_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})
M._components = {"BluePrints.UI.WBP.PersonInfo.Edit.WBP_PersonInfo_EditBaseView"}
function M:Initialize(Initializer)
end

function M:Construct()
end
function M:InitBaseView(TabName, BoxIndex)
    self:SetFocus()
end

function M:InitTabContent(TabName)
    -- 初始化Tab

    local TabsData = DataMgr["ShowCaseTab"]
    local AllTabInfo = {
        [1] = {
            Text = GText(TabsData[1].TabName),
            IconPath = TabsData[1].Icon,
            Name = "Char",
            TabId = TabsData[1].TabId
        },
        [2] = {
            Text = GText(TabsData[2].TabName),
            IconPath = TabsData[2].Icon,
            Name = "Weapon",
            TabId = TabsData[2].TabId
        }

    }

    local TabConfigData = {
        TitleName = GText("UI_PersonInfo_ShowCase_Edit"),
        -- LeftKey = "Q",
        -- RightKey = "E",
        StyleName = "Text",
        Tabs = AllTabInfo,
        DynamicNode = {"Back", "ResourceBar", "BottomKey"},
        BottomKeyInfo = {{
            KeyInfoList = {{
                Type = "Text",
                Text = "Esc",
                ClickCallback = self.OnClose,
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
        BottomKeyInfo = {{
            KeyInfoList = {{
                Type = "Text",
                Text = CommonUtils:GetKeyText("U"),
                ClickCallback = self.OnUKeyDown,
                Owner = self
            }},
            Desc = GText("UI_Dye_HideUI"),
            bLongPress = false
        }, {
            KeyInfoList = {{
                Type = "Text",
                Text = "Esc",
                ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            Desc = GText("UI_BACK")
        }},
        BackCallback = self.OnReturnKeyDown,
        OwnerPanel = self
    }

    self.Com_Tab:Init(TabConfigData)
    self.Com_Tab:BindEventOnTabSelected(self, self.OnTabItemSelected)

    if TabName == "Char" then
        self.Com_Tab:SelectTab(1)
    else
        self.Com_Tab:SelectTab(2)
    end
end
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == "Escape" or "Android_Back") then
        self:OnReturnKeyDown()
        IsEventHandled = true
    end
    
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end
-- com_sort_C 需要一个GetZOrder，否则会报错
function M:GetZOrder()
    return 0
end
AssembleComponents(M)
return M
