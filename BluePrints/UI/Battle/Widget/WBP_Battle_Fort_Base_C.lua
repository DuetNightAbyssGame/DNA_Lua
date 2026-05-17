--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
require "DataMgr"

local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"

local WBP_Battle_Fort_Base_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_Battle_Fort_Base_C:Initialize(Initializer)
    WBP_Battle_Fort_Base_C.Super.Initialize(self)
end

function WBP_Battle_Fort_Base_C:Construct()
    WBP_Battle_Fort_Base_C.Super.Construct(self)
    EventManager:AddEvent(EventID.StartCanonMiniGame, self, self.OnStartCanonMiniGame)
end

function WBP_Battle_Fort_Base_C:Destruct()
    WBP_Battle_Fort_Base_C.Super.Destruct(self)
    self:RemoveTimer("BattleFortTimer")
    EventManager:RemoveEvent(EventID.StartCanonMiniGame, self)
end

function WBP_Battle_Fort_Base_C:OnLoaded(...)
    WBP_Battle_Fort_Base_C.Super.OnLoaded(self, ...)
    if self.HideUITable == nil then
        self.HideUITable = {
            Pos_Entry = 1,
            Pos_Drops = 1,
            Pos_SpecialDrops = 1,
            Pos_NewMonster = 1,
            Battle_Map = 1,
            Btn_Esc = 1,
            Btn_GuideBook = 1,
            Group_ChatEntry = 1,
            Buff = 1,
            Char_Skill = 1,
            Team = 1,
            Chat_Entry = 1,
            HBox = 1,
            SizeBox_Map = 1,
        }
    end
    self.FortEid,self.IsWeekly = ...
    self:InitInfo()
    self:CreateFortBackEntry()
    self:InitAim()
    self:InitSkillItem()
    self:InitBloodBar()
    self:HideBattleMainUI()
    self.CanExcute = false
    self:AddTimer(0.2, function ()
        self.CanExcute = true
    end, false, 0, nil, true)
    self:AddTimer(0.1, self.BattleFortTimer, true, 0, "BattleFortTimer", false, 0.1)
end

function WBP_Battle_Fort_Base_C:OnPressQuit_LeaveBtn()
    self:OnPressQuit(true)
end

function WBP_Battle_Fort_Base_C:OnPressQuit_ESC()
    self:OnPressQuit(false)
end

function WBP_Battle_Fort_Base_C:OnPressQuit(UseLeaveBtn)
    if self.CanExcute then
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        if GameMode and GameMode.EMGameState.RougeMiniGameProgressing then
            for LevelName, SubGameMode in pairs(GameMode.SubGameModeInfo) do
                if SubGameMode.EndRougeMiniGame then
                    local CommonDialogParams = {}
                    CommonDialogParams.RightCallbackFunction = function()
                        SubGameMode:EndRougeMiniGame(false)
                    end
                    UIManager(self):ShowCommonPopupUI(100188, CommonDialogParams, self)
                    break
                end
            end
        else
            local DungeonId = GWorld.GameInstance:GetCurrentDungeonId()
            if DungeonId and DataMgr.Dungeon[DungeonId] then
                local DungeonType = DataMgr.Dungeon[DungeonId].DungeonType
                if DungeonType and DungeonType == "Paotai" then
                    if not UseLeaveBtn then
                        UIUtils.OpenEsc()
                    end
                    return
                end
            end
            if self.IsWeekly then
                self.OwnerMechanism:EndInteractive(self.OwnerPlayer)
            else
                self.OwnerMechanism:Cancel()
            end
        end
    end
end

function WBP_Battle_Fort_Base_C:BattleFortTimer(DeltaTime)
    self:ChangeAimStarColorAndShowBillboard()
    self:UpdatePercentAndChangeHeatingState(DeltaTime)
    self:UpdateAmmo()
    self:UpdateSkillPanel(DeltaTime)
end

function WBP_Battle_Fort_Base_C:ChangeAimStarColorAndShowBillboard()
    if self.Panel_Aim then
        self.Panel_Aim:ChangeAimStarColorAndShowBillboard()
    end
end

function WBP_Battle_Fort_Base_C:UpdatePercentAndChangeHeatingState(DeltaTime)
    local Percent = self.OwnerMechanism.HotValue/self.OwnerMechanism.MaxHotValue
    if Percent >= 1 then
        Percent = 1
        if not self.OverHeating then
            self.OverHeating = true
        end
    else
        if self.OverHeating then
            self.OverHeating = false
        end
    end

    if (not self.TargetPercent) or self.TargetPercent ~= Percent then
        self.TargetPercent = Percent
        self.LerpAlpha = 0
        self.StartPercent = self:GetCurrentPercent()
    end

    self.LerpAlpha = self.LerpAlpha + 5 * DeltaTime
    if(self.LerpAlpha >= 1)then
        self.LerpAlpha = 1
    end
    self.Percent = UE4.UKismetMathLibrary.Lerp(self.StartPercent,self.TargetPercent,self.LerpAlpha)
end

function WBP_Battle_Fort_Base_C:UpdateAmmo()
    if self.Panel_Aim then
        self.Panel_Aim:UpdateAmmo()
    end
end

function WBP_Battle_Fort_Base_C:UpdateSkillPanel(DeltaTime)
    self:UpdateExclusiveSkill(DeltaTime)
end

function WBP_Battle_Fort_Base_C:GetCurrentPercent()
    if self.Panel_Aim then
        return self.Panel_Aim:GetCurrentPercent()
    end
    return 0
end

function WBP_Battle_Fort_Base_C:RefreshRoleSkillButton(Index)
    -- local SkillId = self.OwnerPlayer:GetSkillByType(self["FireUI_"..Index].Type)
    -- local Skill = self.OwnerPlayer:GetSkill(SkillId)
    -- self["FireUI_"..Index]:RefreshButtonStyle(self["FireUI_"..Index].SkillName, Skill, self["FireUI_"..Index].SkillEnumId, self.OwnerPlayer)
    local SkillId = self.OwnerPlayer:GetSkillByType(self["FireUI_"..Index].Type)
    local Skill = self.OwnerPlayer:GetSkill(SkillId)
    self["FireUI_"..Index]:InitItem_PaoTai(self["FireUI_"..Index].SkillName, Skill, self.OwnerPlayer, Index, self)
end

function WBP_Battle_Fort_Base_C:UpdateExclusiveSkill(DeltaTime)
    self.FireUI_1:RefreshSkillStyleInTimer_PaoTai()
    self.FireUI_2:RefreshSkillItem_HotValue(DeltaTime, self.Percent)
end

function WBP_Battle_Fort_Base_C:InitRoleSkillButton(Index)
    if Index == 1 then
        self["FireUI_"..Index].Type = UE.ESkillType.Attack
        self["FireUI_"..Index].SkillEnumId = ESkillName.Attack
        self["FireUI_"..Index].SkillName = "Attack"
    elseif Index == 2 then
        self["FireUI_"..Index].Type = UE.ESkillType.Shooting
        self["FireUI_"..Index].SkillEnumId = ESkillName.Fire
        self["FireUI_"..Index].SkillName = "Fire"
    end
    self:AddTimer(0.05, function()
        local SkillId = self.OwnerPlayer:GetSkillByType(self["FireUI_"..Index].Type)
        local SKillConfig = DataMgr.Skill[SkillId][1][0]
        self["FireUI_"..Index].IconPath = "/Game/UI/Texture/Dynamic/Atlas/Skill/T_"..SKillConfig.SkillBtnIcon
        local SkillImgIcon = LoadObject(self["FireUI_"..Index].IconPath)
        if IsValid(SkillImgIcon) then
            self["FireUI_"..Index].Icon_Skill:SetBrushResourceObject(SkillImgIcon)
            if self["FireUI_"..Index].VX_skillIcon then
                local VXSkillMat = self["FireUI_"..Index].VX_skillIcon:GetDynamicMaterial()
                VXSkillMat:SetTextureParameterValue("Mask", SkillImgIcon)
            end
        end
        self:RefreshRoleSkillButton(Index)
    end, false, 0, nil, true)
end

function WBP_Battle_Fort_Base_C:OnSkillActionInput()
    if self.OwnerMechanism.Hot then
        if self.FireUI_2:IsAnimationPlaying(self.FireUI_2.Click) then
            self.FireUI_2:StopAnimation(self.FireUI_2.Click)
        end
        if (not self.FireUI_2:IsAnimationPlaying(self.FireUI_2.Cannon_Disable)) then
            self.FireUI_2:PlayAnimation(self.FireUI_2.Cannon_Disable)
        end
        UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, "TOAST_OverHeating")
    end
end

function WBP_Battle_Fort_Base_C:InitInfo()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
    local Player = PlayerController:GetMyPawn()
    local Eid = self.FortEid or Player.MechanismEid
    local Mechanism = Battle(self):GetEntity(Eid)
    self.OwnerMechanism = Mechanism
    self.OwnerPlayer = Player
    self.OwnerPlayer:SetPlayerCameraSensitivityCannon()
    self.OwnerPlayer:SetPlayerCameraSensitivityByType("Shooting")
    self.Percent = self.OwnerMechanism.HotValue/self.OwnerMechanism.MaxHotValue
    --self.Text_Task:SetText(GText("Description_110110_1_1"))
	self:ListenForInputAction("LeaveCannon", EInputEvent.IE_Pressed, true, {self, self.OnPressQuit_LeaveBtn})
    self:ListenForInputAction("OpenMenu", EInputEvent.IE_Pressed, true, {self, self.OnPressQuit_ESC})
end

function WBP_Battle_Fort_Base_C:InitAim()
    if self.Panel_Aim then
        self.Panel_Aim:Init(self)
    end
end

function WBP_Battle_Fort_Base_C:InitBloodBar()
    if self.FortBloodBar then
        self.FortBloodBar:InitConfig(self.OwnerMechanism)
    end
end

function WBP_Battle_Fort_Base_C:InitSkillItem()
    self.FireUI_1 = self.Fire_Single
    self.FireUI_2 = self.Fire_Multi
    for i=1,2 do
        self:InitRoleSkillButton(i)
    end
end

function WBP_Battle_Fort_Base_C:TryToPlayTargetCommand(KeyName, IsAddInputCache)
    if (not IsValid(self.OwnerPlayer)) then
        return
    end
    IsAddInputCache = IsAddInputCache
    if (IsAddInputCache) then
        self.OwnerPlayer:SetInputCache(KeyName)
    end
    if not self.OwnerPlayer.InitSuccess then
        return
    end
    if (KeyName == "Attack") then
        self.OwnerPlayer:PressAttack()
    elseif (KeyName == "Fire") then
        self.OwnerPlayer:PressFire()
    end
end

function WBP_Battle_Fort_Base_C:TryToStopTargetCommand(KeyName, IsClearInputCache)
    if (not IsValid(self.OwnerPlayer)) then
        return
    end
    IsClearInputCache = IsClearInputCache
    if (IsClearInputCache) then
        self.OwnerPlayer:RemoveInputCache(KeyName)
    end
    if not self.OwnerPlayer.InitSuccess then
        return
    end
    if (KeyName == "Attack") then
        self.OwnerPlayer:ReleaseAttack()
    elseif (KeyName == "Fire") then
        self.OwnerPlayer:StopFire(false, true)
    end
end

function WBP_Battle_Fort_Base_C:HideBattleMainUI()
    local UIBattleMain = UIManager(self.Owner):GetUI("BattleMain")
    if UIBattleMain then 
        UIBattleMain:ShowBattleFortUI()
    end
    self.OwnerPlayer:TryHideAllSkillUI()

    local TaskUIObj = TaskUtils:GetTaskBarWidget()
    if TaskUIObj then
        TaskUIObj:TriggerQuestTrackPanelTips(false)
    end
end

function WBP_Battle_Fort_Base_C:ShowBattleMainUI()
    local UIBattleMain = UIManager(self.Owner):GetUI("BattleMain")
    if UIBattleMain then 
        UIBattleMain:HideBattleFortUI()
    end
    self.OwnerPlayer:TryShowAllSkillUI()

    local TaskUIObj = TaskUtils:GetTaskBarWidget()
    if TaskUIObj then
        TaskUIObj:TriggerQuestTrackPanelTips(true)
    end
end

function WBP_Battle_Fort_Base_C:TryToPlayAimDiffusionStartAnim()
    if self.Panel_Aim then
        self.Panel_Aim:TryToPlayAimDiffusionStartAnim()
    end
end

function WBP_Battle_Fort_Base_C:CreateFortBackEntry()
    local UIBattleMain = UIManager(self.Owner):GetUI("BattleMain")
    if UIBattleMain then
        local FortBackEntry = UIBattleMain:CreateFortBack()
        if FortBackEntry then
            self:InitFortBackEntry(FortBackEntry)
        end
    end
end

function WBP_Battle_Fort_Base_C:DestoryFortBackKey()
    local UIBattleMain = UIManager(self.Owner):GetUI("BattleMain")
    if UIBattleMain then
        UIBattleMain:DestoryFortBack()
    end
end

function WBP_Battle_Fort_Base_C:Close()
    self:ShowBattleMainUI()
    self:DestoryFortBackKey()
    self.OwnerPlayer:UpdateCameraSensitivityFromCache()
    self.OwnerPlayer:SetPlayerCameraSensitivityByType("Normal")
    WBP_Battle_Fort_Base_C.Super.Close(self)
end

function WBP_Battle_Fort_Base_C:OnStartCanonMiniGame()
    local ActivityFortBattle = self:CreateWidgetNew("ActivityFortBattle")
    ActivityFortBattle:Init(self)
    local Slot = self.Node_Activity:AddChild(ActivityFortBattle)
    Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
end

function WBP_Battle_Fort_Base_C:HidePaotaiName(IsHide)
    if IsHide then
        self.FortBloodBar.Text_Name:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self.FortBloodBar.Text_Name:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
end

function WBP_Battle_Fort_Base_C:InitFortBackEntry(FortBackKey)
    local IconPath = "/Game/UI/Texture/Dynamic/Atlas/Entrance/T_Entrance_Quit.T_Entrance_Quit"
    FortBackKey:InitInterface(IconPath, "Esc", GText("UI_CTL_Quit"))
    FortBackKey.Btn_top.OnClicked:Add(self, self.OnPressQuit_ESC)
end

return WBP_Battle_Fort_Base_C
