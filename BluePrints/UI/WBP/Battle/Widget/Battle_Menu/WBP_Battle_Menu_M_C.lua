local TITLE_TEXT_KEYS =
{
    "BATTLE_WHEEL_DISPLAY_TITLE1",
    "BATTLE_WHEEL_DISPLAY_TITLE2",
    "BATTLE_WHEEL_DISPLAY_TITLE3",
}

---@type WBP_Battle_Menu_M_C
local M = Class("BluePrints.UI.BP_UIState_C")

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:InitUIInfo(Name,bInUIMode,EventList,...)
    M.Super.InitUIInfo(self,Name,bInUIMode,EventList,...)

    self.Button_Area.OnClicked:Add(self, self.SwitchBattleWheel)
    self.Text_Option:SetText(GText("BATTLE_MENU_MOBILE_SWITCH"))
    
    if self.Battle_Menu and self.Battle_Menu.Owner then
        self.Battle_Menu.Owner = self
    end
    self.QuestBattleWheelID = ...
    self.Battle_Menu:InitQuestBattleWheel(self.QuestBattleWheelID)
    if self.Btn_FullClose then
        self.Btn_FullClose.OnClicked:Add(self, function()
            if not self then return end
            self:StopAllAnimations()
            self:Close()
        end)
    end
end

function M:OnLoaded()
    DebugPrint("lgc@WBP_Battle_Menu_M_C M:OnLoaded", self, self.Battle_Menu)
    self.Battle_Menu:OnLoaded()
end

function M:Hide(HideTag)
    M.Super.Hide(self, HideTag)
    local BattleMainUI = UIManager(self):GetUI('BattleMain')
    if (BattleMainUI ~= nil and BattleMainUI.Char_Skill ~= nil and type(BattleMainUI.Char_Skill.HandleEventByInterrupt) == "function") then
        BattleMainUI.Char_Skill:HandleEventByInterrupt()
    end
end

function M:UpdateArgs(Params)
    DebugPrint("gmy@WBP_Battle_Menu_P_C M:UpdateArgs", Params)
    self.Battle_Menu:UpdateArgs(Params)
end

function M:SelectAndCloseMenu()
    self:StopAllAnimations()
    self.Battle_Menu:SelectAndCloseMenu()
    self:Close()
end

function M:BindMenuButton(MenuButton)
    self.Battle_Menu:BindMenuButton(MenuButton)
end

function M:SetWheelCenter(Widget)
    -- DebugPrint("gmy@WBP_Battle_Menu_M_C M:SetWheelCenter")
    
    self.Battle_Menu:SetWheelCenter(Widget)
end

function M:SwitchBattleWheel()
    DebugPrint("gmy@WBP_Battle_Menu_M_C M:SwitchBattleWheel")
    self.Battle_Menu:OnChangeDisplayWheel()
    self:RefreshDisplayIndex()
end

function M:RefreshDisplayIndex()
    local DisplayIndex = self.Battle_Menu.DisplayIndex
    local TitleText = GText(TITLE_TEXT_KEYS[DisplayIndex])
    --local NextTitleText = GText(TITLE_TEXT_KEYS[(DisplayIndex - 1 + 1) % 3 + 1])

    -- TODO : 没有Text_Name. 暂时不需要
    --self.Text_Name:SetText(TitleText)
    --self.Text_Option:SetText(NextTitleText)
end

return M
