--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local EMCache = require "EMCache.EMCache"

local WBP_HomeBaseMain_C = Class({"BluePrints.UI.BP_UIState_C"})

function WBP_HomeBaseMain_C:Initialize(Initializer)
    self.Super.Initialize(self)
    self.Owner=nil
    --self.Battle=nil
end

function WBP_HomeBaseMain_C:Construct()
    self.Overridden.Construct(self)
    -- self:AddDispatcher(EventID.OnMainCharacterInitReady,self,self.OnMainCharacterInitReady)
    self:AddDispatcher(EventID.OnChangeKeyBoardSet,self,self.InitBtnList)
    self:AddDispatcher(EventID.OnMainUIReddotUpdate, self, self.UpdateRedDotStates)
    self:AddDispatcher(EventID.OnCompleteProduce, self, self.UpdateRedDotStates)
    self:AddDispatcher(EventID.OnBlueComplete, self, self.UpdateRedDotStates)
    self:AddDispatcher(EventID.OnReceiveNewQuest, self, self.UpdateRedDotStates)
    self:AddTimer(1.0,self.SetSignBoardNpcIdle,true,0,"SetSignBoardNpcIdle")
end

function WBP_HomeBaseMain_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self:InitBtnList()
    self:InitEsc()
    -- self:InitSystemLanguage()
    --self:InitQuest()
end

function WBP_HomeBaseMain_C:InitBtnList()
    local SystemData = DataMgr.MainUI
    self.ListView:ClearListItems()
    local ClassPath = UE4.LoadClass('/Game/UI/UI_PC/Main/Main_Btnlist_Content_PC.Main_Btnlist_Content_PC_C')
    for index,Data in pairs(SystemData) do
        if Data.IsAddToList and Data.IsShowInHomeBase then
            local Content = NewObject(ClassPath)

            Content.BtnId = index
            self.ListView:AddItem(Content)
        end
    end
end

-- 更新红点状态
function WBP_HomeBaseMain_C:UpdateRedDotStates()
    DebugPrint("Tianyi@ UpdateRedDotStates")
    local EntryList = self.ListView:GetDisplayedEntryWidgets():ToTable()
    for _, v in ipairs(EntryList) do 
        v:UpdateRedDot()
    end
end

-- function WBP_HomeBaseMain_C:InitSystemLanguage()
--     local SystemLanguage = EMCache:Get("SystemLanguage")
--     if SystemLanguage ~= nil then
--         CommonConst.SystemLanguage = SystemLanguage
--     end
-- end


function WBP_HomeBaseMain_C:InitQuest()
    local Avatar = GWorld:GetAvatar()
    if Avatar ~= nil then
        local QuestId= Avatar.QuestId
        if QuestId~=nil then
            local QuestName = DataMgr.Quest[QuestId].QuestName
            if QuestName ~=nil then
                self.Text_Mission_Title:SetText(QuestName)
                return
            end
        end
    end
end

-- function WBP_HomeBaseMain_C:OnMainCharacterInitReady()
--     self.Owner = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
--     local PlatformName = self.Owner.UIModePlatform
--     if PlatformName == "PC" then
--     elseif (PlatformName == "Mobile") then
--         self.Battle = UIManager(self):LoadUI("/Game/UI/UI_Phone/Battle/Battle.Battle_C", "BattleMain", -3)
--         self.Battle.Battle_FSVjoy.MaskTouchInBattleArea:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         self.Battle.Battle_FSVjoy.MaskTouchInHomeArea:SetVisibility(UE4.ESlateVisibility.Visible)
--         self.Battle.Battle_Skill.Battle_Skill_Spport:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         self.Battle.Battle_Weapon_Hint:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         self.Battle.Battle_Map:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         self.Battle.Battle_Char:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         --self.Battle.Battle_Skill.Battle_Skill_2:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         --self.Battle.Battle_Skill.Battle_Skill_Metee:SetVisibility(UE4.ESlateVisibility.Collapsed)
--         --self.Battle.Battle_Skill.Battle_Skill_Remote:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     end
-- end

function WBP_HomeBaseMain_C:SetSignBoardNpcIdle()
	local Avatar = GWorld:GetAvatar()
    if(Avatar == nil)then
		self:RemoveTimer("SetSignBoardNpcIdle")
		return
    end
	local IsLoadCompleteCount = 0
	for key ,value in pairs(Avatar.SignBoardNpc) do
		if value == -1 then
			IsLoadCompleteCount = IsLoadCompleteCount + 1
		else
            local NpcInfo = DataMgr.Npc[value]
            if NpcInfo == nil or NpcInfo.ShowAnimationId == nil then
                IsLoadCompleteCount = IsLoadCompleteCount + 1
            else
                local ShowAnimation = NpcInfo.ShowAnimationId
                local ShowAnimationId = ShowAnimation[key]
                local GameInstance = GWorld.GameInstance
                local GameState = UE4.UGameplayStatics.GetGameState(GameInstance)
                local Npc = GameState.NpcCharacterMap:Find(value)
                if Npc ~= nil then
                    IsLoadCompleteCount = IsLoadCompleteCount + 1
                    if ShowAnimationId == 'Sit' and key ~= 3 then
                        Npc:SetSitPoseInteractive()
                    else
                        Npc:SetIdlePose(false)
                    end
                end
            end
		end
	end
	if IsLoadCompleteCount == 3 then
		self:RemoveTimer("SetSignBoardNpcIdle")
	end
end

function WBP_HomeBaseMain_C:OpenArmory()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManger = GameInstance:GetGameUIManager()
    local Player=UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    if Player:CharacterInTag('Idle') then
        UIManager:LoadUINew('ArmoryMain')
    end
end

function WBP_HomeBaseMain_C:OpenBag()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManger = GameInstance:GetGameUIManager()
    local Player=UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    if Player:CheckCanEnterTag('Interactive') then
        UIManger:LoadUI(nil,"BagMain",UIConst.ZORDER_FOR_DESKTOP_TEMP)
    end
end

function WBP_HomeBaseMain_C:OpenCommonSetup()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
    if Player:GetESCMenuForbiddenState() then
        return
    end
       --Esc容错处理,一些高优先级的UI播放动效时无法打开Esc TODO:封装成接口
    local SystemUIConfig = DataMgr.SystemUI[UIConst.CommonSetUP]
    if SystemUIConfig and SystemUIConfig.Params.BlockedUIName then
        for _, UIName in ipairs(SystemUIConfig.Params.BlockedUIName) do
            local  BlockedUI = UIManager(self):GetUIObj(UIName)
            if BlockedUI and BlockedUI:IsPlayingAnimation() then
                return
            end
        end
    end
    UIManager(self):LoadUINew(UIConst.MenuWorld,"OutBattle")
end

function WBP_HomeBaseMain_C:InitEsc()
    self.Btn_Esc.Btn_top.OnClicked:Add(self,self.OpenCommonSetup)
    --TODO:ESC参数整理
    self.Btn_Esc:LoadImage(11)
end
return WBP_HomeBaseMain_C
