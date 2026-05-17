local M = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.Common.TimerMgr",
})
local UIUtils = require "Utils.UIUtils"

local KeyboardTrainingKeyMap = {
    -- {
    --     Type = "Text",
    --     Text = "F1",
    --     DescText = GText("UI_DUNGEON_DES_TRAINING_1"),
    --     CallbackObj = self, 
    --     CallbackFunc = self.TrainingOpenSetup
    -- },
    {
        Type = "Text",
        Text = "F2",
        DescText = GText("UI_DUNGEON_DES_TRAINING_2"),
    },
    {
        Type = "Text",
        Text = "F3",
        DescText = GText("UI_DUNGEON_DES_TRAINING_15"),
    },
    {
        Type = "Text",
        Text = "F4",
        DescText = GText("UI_DUNGEON_DES_TRAINING_3"),
    },
    {
        Type = "Text",
        Text = "F5",
        DescText = GText("UI_DUNGEON_DES_TRAINING_16"),
    }
}

local GamepadTrainingKeyMap = {
    -- {
    --     Type = "Img",
    --     DescText = GText("UI_DUNGEON_DES_TRAINING_1"),
    --     ImgShortPath = UIUtils.GetIconListByActionName("TrainingOpenSetup"),
    -- },
    {
        Type = "Img",
        DescText = GText("UI_Keyboard_Map_OpenArmory"),
        ImgShortPath = UIUtils.GetIconListByActionName("OpenArmory"),
    },
    {
        Type = "Img",
        DescText = GText("UI_DUNGEON_DES_TRAINING_2"),
        ImgShortPath = UIUtils.GetIconListByActionName("TrainingCharacterSkills"),
    },
    {
        Type = "Img",
        DescText = GText("UI_DUNGEON_DES_TRAINING_15"),
        ImgShortPath = UIUtils.GetIconListByActionName("TrainingInvincible"),
    },
    {
        Type = "Img",
        DescText = GText("UI_DUNGEON_DES_TRAINING_3"),
        ImgShortPath = UIUtils.GetIconListByActionName("TrainingKillMonsters"),
    },
    {
        Type = "Img",
        DescText = GText("UI_DUNGEON_DES_TRAINING_16"),
        ImgShortPath = UIUtils.GetIconListByActionName("TrainingMonstersActive"),
    }
}

function M:GetTrainingComp()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then 
        return GameMode:GetDungeonComponent()
    end

    return nil
end


function M:InitView()
    local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
    if (IsValid(GameInputModeSubsystem)) then
        GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    end
    self:RefreshOpInfoByInputDevice()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	self.TrainingData = DataMgr.Training[GameMode.DungeonId]
    self:AddTimer(1, function()
        self:UpdateMonsterNum()
    end, true, 0, "UpdateMonsterNumTimer")
end

function M:UpdateMonsterNum()
    local CurrentMonsterNum = self:GetTrainingComp():CheckAliveMonsterCount()
    local Text = string.format(GText("UI_DUNGEON_DES_TRAINING_41"), string.format("%d<Grey>/%d</>", CurrentMonsterNum, self.TrainingData.MaxEnemyNum))
    self.Text_TrainingTitle:SetText(Text)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if UIUtils.IsGamepadInput() then
        self:InitGamepadView()
    else
        self:InitKeyboardView()
    end
end

function M:InitGamepadView()
    local Path = UIUtils.GetIconListByActionName("TrainingOpenSetup")[1]
    self.Key_Menu:CreateCommonKey({
        KeyInfoList = {
            {
                ImgShortPath = Path,
                Type = "Img",
            }
        },
        Desc = GText("UI_DUNGEON_DES_TRAINING_1")
    })

    self.Key_List:InitKey(GamepadTrainingKeyMap)
end

function M:InitKeyboardView()
    self.Key_Menu:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Text",
                Text = "F1",
            }
        },
        Desc = GText("UI_DUNGEON_DES_TRAINING_1"),
    })

    self.Key_List:InitKey(KeyboardTrainingKeyMap)
end

function M:Destruct()
    self:RemoveTimer("UpdateMonsterNumTimer")
end

return M
