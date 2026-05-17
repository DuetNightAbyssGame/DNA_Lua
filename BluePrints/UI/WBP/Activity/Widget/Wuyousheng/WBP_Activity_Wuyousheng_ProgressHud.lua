--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_Wuyousheng_HUD_ProgressContent_C
local M =Class("BluePrints.UI.BP_EMDungeonWidget_C")


function M:InitDungeonWidget()
    M.Super.InitDungeonWidget(self)
    self:AddToBattleMain("Task","Overlay")
    self:UpdateProgress(0, 20)
    self.Level = 0
    self:UpdateLevelText(0)
    self:InitPetIcon()
    self:PlayAnimation(self.Normal)
end

function M:InitListenEvent()
    M.Super.InitListenEvent(self)
    self:AddDispatcher(EventID.OnWuyoushengLevelProgress, self, self.OnWuyoushengLevelProgress)
end

function M:InitPetIcon()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local DungeonId = GameState and GameState.DungeonId or 0
    local EventId = DataMgr.WuyoushengEventLevel[DungeonId].EventId
    local Avatar = GWorld:GetAvatar()
    if DungeonId and EventId then
        local Avatar = GWorld:GetAvatar()
        if Avatar and Avatar.WuyoushengActivity then
            local WuyoushengData = Avatar.WuyoushengActivity[EventId]
            if WuyoushengData then
                local SavedSquad = WuyoushengData:GetSquadInfo(DungeonId)
                local PetId = SavedSquad.Pet.Id
                if PetId then
                    local BattlePetInfo = DataMgr.BattlePet[PetId]
                    local SkillInfo = DataMgr.Skill[BattlePetInfo.SupportSkillId]
                    local IconName = SkillInfo[1][0].SkillBtnIcon
                    if(IconName)then
                        local Icon = LoadObject("/Game/UI/Texture/Dynamic/Atlas/Skill/T_"..IconName..".T_"..IconName)
                        local IconDynaMaterial = self.Image_Icon:GetDynamicMaterial()
                        if(IconDynaMaterial)then
                            IconDynaMaterial:SetTextureParameterValue("Mask", Icon)
                        end
                        local IconDynaMaterial1 = self.Image_Icon_1:GetDynamicMaterial()
                        if(IconDynaMaterial1)then
                            IconDynaMaterial1:SetTextureParameterValue("Mask", Icon)
                        end
                    end
                end
            end
        end
    end
end

function M:UpdateProgress(Progress, MaxProgress)
    -- 进入材质设置progress进度
    local DynamicMaterial = self.Image_Progress:GetDynamicMaterial()
    local DynamicMaterial1 = self.Image_Progress_1:GetDynamicMaterial()
    if DynamicMaterial and IsValid(DynamicMaterial) then
        local Percent = 0
        if MaxProgress and MaxProgress > 0 then
            Percent = math.max(0, math.min(1, Progress / MaxProgress))
        end
        DynamicMaterial:SetScalarParameterValue("Percent", Percent)
        DynamicMaterial1:SetScalarParameterValue("Percent", Percent)
    end
end

function M:UpdateLevelText(Level)
    if self.Level ~= Level then
        if Level == 4 then
            self:PlayAnimation(self.LevelUp_Max)
            self:PlayAnimation(self.Max)
        else
            self:PlayAnimation(self.LevelUp)
        end
    end
    self.Level = Level
    if Level == 4 then
        self.Text_WuyoushengLevel:SetText(GText("UI_WuyoushengEvent_LvMax"))
    else
        self.Text_WuyoushengLevel:SetText(GText("UI_WuyoushengEvent_Lv") .. Level)
    end
end

function M:OnWuyoushengLevelProgress(Progress, MaxProgress, Level)
    self:UpdateProgress(Progress, MaxProgress)
    self:UpdateLevelText(Level)
end

return M
