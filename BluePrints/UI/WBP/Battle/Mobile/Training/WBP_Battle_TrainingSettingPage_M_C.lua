local M = Class("BluePrints.UI.BP_UIState_C")
local UIUtils = require "Utils.UIUtils"

function M:BindEvents()
    self.Btn_Close:Init("Close", self, self.OnBtnCloseClicked)
    self.Btn_Kill:BindEventOnClicked(self, self.OnBtnKillClicked)  
    self.Btn_Skill:BindEventOnClicked(self, self.OnBtnSkillClicked)
    self.Btn_Menu:BindEventOnClicked(self, self.OnBtnMenuClicked)
end

function M:GetTrainingComp()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then 
        return GameMode:GetDungeonComponent()
    end

    return nil
end

function M:OnLoaded()
    local TrainingComp = self:GetTrainingComp()

    -- self.Text_ChooseTitle_Bottom:SetText(string.format(GText("UI_DUNGEON_DES_TRAINING_36"), TrainingComp.MaxMonsterCount))
    self.Text_PageTitle:SetText(GText("UI_DUNGEON_DES_TRAINING_14"))
    self.Text_ChooseTitle_Bottom:SetText(GText("UI_DUNGEON_DES_TRAINING_36"))
    self.Text_Kill:SetText(GText("UI_DUNGEON_DES_TRAINING_3"))
    self.Btn_Skill:SetText(GText("UI_DUNGEON_DES_TRAINING_2"))
    self.Btn_Menu:SetText(GText("UI_DUNGEON_DES_TRAINING_1"))

    self:BindEvents()
    local Configs = {
        {
            Title = GText("UI_DUNGEON_DES_TRAINING_16"), 
            OnCheckStateChanged = {self, self.TrainingDisableMonsterAI},
            IsChecked = TrainingComp:GetIsMonsterAIEnabled()
        },
        {
            Title = GText("UI_DUNGEON_DES_TRAINING_15"),
            OnCheckStateChanged = {self, self.TrainingSetPlayerInvincible},
            IsChecked = TrainingComp:GetIsPlayerInvincible()
        },
    }

    self.List_Setting:ClearListItems()
    for Index, Config in ipairs(Configs) do
        local Obj = NewObject(UIUtils.GetCommonItemContentClass())
        Obj.Title = Config.Title
        Obj.OnCheckStateChanged = Config.OnCheckStateChanged
        Obj.IsChecked = Config.IsChecked
        self.List_Setting:AddItem(Obj)
    end

    self.Text_ChooseNum_Bottom:SetText(self:GetTrainingComp():CheckAliveMonsterCount())

    self:PlayAnimation(self.In)
end


function M:TrainingDisableMonsterAI(IsChecked)
    self:GetTrainingComp():TrainingDisableMonsterAI()
end

function M:TrainingSetPlayerInvincible(IsChecked)
    self:GetTrainingComp():TrainingSetPlayerInvincible()
end

function M:OnBtnKillClicked()
    self:GetTrainingComp():TrainingKillMonsters()
    self:ClosePanel()
end

function M:OnBtnSkillClicked()
    self:ClosePanel()
    self:GetTrainingComp():TrainingCharacterSkills()
end

function M:OnBtnMenuClicked()
    self:ClosePanel()
    self:GetTrainingComp():TrainingOpenSetup()
end

function M:OnBtnCloseClicked()
    self:ClosePanel()
end

function M:ClosePanel()
    self:PlayAnimation(self.Out)
end

function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.Out then
        self:Close()
    end
end

return M