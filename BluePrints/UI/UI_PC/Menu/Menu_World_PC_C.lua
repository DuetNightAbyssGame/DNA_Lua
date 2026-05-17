--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local TimeUtils = require "Utils.TimeUtils"
local UIUtils = require "Utils.UIUtils"
---@class Menu_World_C
local Menu_World_PC_C = Class({"Blueprints.UI.BP_UIState_C"})
Menu_World_PC_C._components = {
    "BluePrints.UI.UI_PC.Menu.Reddot.MainUIItem_ReddotTree_Component",
    "BluePrints.UI.WBP.PersonInfo.PersonInfoEditListCompoment"
}

function Menu_World_PC_C:Initialize(Initializer)
    self.Super.Initialize(self)
    
    self.BtnIdx = 0
    self.CloseBySelf=false
    self.CloseByChild=false
    self.FunctionButtonNum=30
    self.ActivityEntranceId=19
    self.ShopEntranceId=4
    self.RelatedProductEntranceId = 27
    self.CloudGameEntranceId = 30
end

function Menu_World_PC_C:OnLoaded(...)
    self.Super.OnLoaded(self,...)
    local ConfigData={}
    --ConfigData.ClickCallBack=self.LoadExpTip
    ConfigData.OwnerWidget=self
    ConfigData.SoundFunc= function ()
        AudioManager(self):PlayUISound(nil,"event:/ui/common/click_btn_small", nil, nil)
    end
    ConfigData.TextContent=GText("UI_Toast_Experience_Content")
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    self:SetPlayerInfo(Player)
    self.PlayerCurrentTag = Player:GetCharacterTag()
    if IsStandAlone(Player) then
        --Player:SetCharacterTag('Interactive')
        Player:SetCanInteractiveTrigger(false)
    end
    --self.BtnNums = #self.BtnName
    AudioManager(self):PlayUISound(self, "event:/ui/common/esc_menu_open", "EscMenuOpen", nil)
    self:InitCommonBtn()
    self:InitSystemItem()
    --self:InitBtnList()
    self:InitExperienceBtn()
    self:InitTitle()
    self:InitBg()
    self:InitBanReward()
    self.Panel_Edit:SetVisibility(UIConst.VisibilityOp.Collapsed)
  
    self.Text_Empty:SetText(GText("UI_Menu_Sign_None"))
    self:AddDispatcher(EventID.OnMainUIReddotUpdate, self, self.UpdateRedDotStates)
    self:AddDispatcher(EventID.OnCompleteProduce, self, self.UpdateRedDotStates)
    self:AddDispatcher(EventID.OnBlueComplete, self, self.UpdateRedDotStates)
    self:AddDispatcher(EventID.OnAchvRedPoint, self, self.UpdateRedDotStates)
    self:AddDispatcher(EventID.OnReceiveNewQuest, self, self.UpdateRedDotStates)
    self:AddDispatcher(EventID.OnGotTopicReward, self, self.UpdateRedDotStates)
    local BattleMainUI = UIManager(self):GetUI('BattleMain')
    if (BattleMainUI ~= nil) then
        BattleMainUI:PlayOutAnim(nil,nil,self.WidgetName)
    end
    self:SetFocus()
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    self:AddInputMethodChangedListen()
    self:AddReddotListener("EditBtn",self.OnEditBtnReddotChange)
    self:AddReddotListener("ExperienceMain",self.OnExperienceReddotChange)
    self.Edit_List:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.SizeBox_EditList:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    self.ScrollBox_Function.OnUserScrolled:Add(self, self.OnScrollBox_FunctionScrolled)
    --初始化时额外更新一次
    self:AddTimer(0.1, function()
        self:OnScrollBox_FunctionScrolled()
    end)
    UIUtils.BindScrollBoxReddotAndNewClickEvent(
        self.ScrollBox_Function,
        self.Com_RedDot_Up,
        self.Com_RedDot_Down,
        nil,
        nil,
        function(Widget)
            if not Widget then
                return false,false
            end
            local bHasReddot = Widget.Reddot and (Widget.Reddot:GetVisibility() == 0 or Widget.Reddot:GetVisibility() == 3 or Widget.Reddot:GetVisibility() == 4)
            local bHasNew = Widget.New and (Widget.New:GetVisibility() == 0 or Widget.New:GetVisibility() == 3 or Widget.New:GetVisibility() == 4)
            return bHasReddot, bHasNew
        end
    )
    self.Entrance_Activity:SetNavigationRuleCustom(UE4.EUINavigation.Down, {self, self.OnActivityNavigateDown})
end

function Menu_World_PC_C:InitTitle()
    local Avatar = GWorld:GetAvatar()
    local TitleBefore=Avatar.TitleBefore or -1
    local TitleAfter=Avatar.TitleAfter or -1
    local TitleFrame=Avatar.TitleFrame or -1
    --self.WBP_PersonalInfo_TitleSetting.Btn_SetTitle.OnClicked:Add(self,self.OnClickChangeTitle)
    --self.WBP_PersonalInfo_TitleSetting.Btn_ChangeTitle.OnClicked:Add(self,self.OnClickChangeTitle)
    self:Freshtitle(TitleBefore,TitleAfter,TitleFrame)
    -- self.Title:ClearChildren()
    -- local Avatar = GWorld:GetAvatar()
    -- local FrameId = Avatar.TitleFrame
    -- local Widget = UIManager(self):LoadTitleFrameWidget(FrameId)
    -- if Widget then
    --     self.Title:AddChildToOverlay(Widget)
    -- end
end

function Menu_World_PC_C:Freshtitle(TitleBefore, TitleAfter, TitleFrame)
   if TitleBefore == -1 and TitleAfter == -1 then
       self.WBP_PersonalInfo_TitleSetting.WS_Title:SetActiveWidgetIndex(1)
   else
       self.WBP_PersonalInfo_TitleSetting.WS_Title:SetActiveWidgetIndex(2)
       local TileFrameWidget = UIManager(self):LoadTitleFrameWidget(TitleFrame)
       if not TileFrameWidget then
           return
       end
       local TitleText = UIUtils.CalculateHoleTitle(TitleBefore, TitleAfter)
       TileFrameWidget.Text_Title:SetText(TitleText)
       self.WBP_PersonalInfo_TitleSetting.Group_Title:AddChildToOverlay(TileFrameWidget)
   end
end


function Menu_World_PC_C:OnActivityNavigateDown()
    local Item = self.Panel_Function:GetChildAt(2)
    if Item then
        return Item
    end
    return self.Panel_Function:GetChildAt(0)
end

function Menu_World_PC_C:IsFoucsLeftPanelFunctionBtn()
    local Item1 = self.Panel_Function:GetChildAt(0)
    local Item2 = self.Panel_Function:GetChildAt(1)
    if Item1 and (Item1:HasFocusedDescendants() or Item1:HasAnyUserFocus()) then
        return true
    end
    if Item2 and (Item2:HasFocusedDescendants() or Item2:HasAnyUserFocus()) then
        return true
    end
    return false
end

function Menu_World_PC_C:OnScrollBox_FunctionScrolled()
    local ReddotAndNewCalFunc = function(...)
        local Widget = ...
        if not Widget then
            return false, false
        end
        local bHasReddot = Widget.Reddot and (Widget.Reddot:GetVisibility() == 0 or Widget.Reddot:GetVisibility() == 3 or Widget.Reddot:GetVisibility() == 4)
        local bHasNew = Widget.New and (Widget.New:GetVisibility() == 0 or Widget.New:GetVisibility() == 3 or Widget.New:GetVisibility() == 4)
        return bHasReddot, bHasNew
    end
    self:AddTimer(0.2, function()
        if not self then return end
        UIUtils.UpdateScrollBoxReddot(
            self.ScrollBox_Function,
            self.Com_RedDot_Up,
            self.Com_RedDot_Down,
            nil,
            nil,
            ReddotAndNewCalFunc
        )
    end)
end

function Menu_World_PC_C:ReceiveEnterState(EnteredState)
	self.Super.ReceiveEnterState(self, EnteredState)
	if EnteredState == 1 then
        self:SetFocus()
        if self.CloseByChild then
            self:AddTimer(0.01,self.Close,false,0,nil,true)
        -- elseif self.ResumeAnnouncementMain then
        --     AnnounceController:OpenAnnouncementMain(AnnounceCommon.ShowTag.InGame,nil, nil, self)
        end 
	end
end

function Menu_World_PC_C:InitCommonBtn()
    --self.Btn_LogOut:SetText(GText('UI_Esc_Exit'))
    -- self.Button_Setting:SetText(GText('UI_Esc_CommonSet'))
    -- self.Button_Setting.Button_Area.OnClicked:Add(self, self.OnClickCommonSet)
    if UE4.UUCloudGameInstanceSubsystem.IsCloudGame() then
        self.Button_Logout:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.Button_Logout:BindEventOnClicked(self,self.OnClickExitGame)
    self.Button_Logout.AudioEventPath="event:/ui/common/click_btn_small"
    self.Btn_TEXT.OnClicked:Add(self,self.OnClickChangeSignature)
    self.Button_Copy.AudioEventPath="event:/ui/common/click_btn_small"
    self.Button_Copy.OnClicked:Add(self, function ()
    self.Button_Area_Experience:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:StopPress()
    self:OnCopyUID()
end)

    self.Head_Player.Button_Area.OnClicked:Add(self, self.OnClickChangePortrait)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Key_Copy:CreateCommonKey({
            KeyInfoList = {
                {
                    ImgShortPath = "View",
                    Type = "Img"
                }
            },
        })
        self.Key_Edit:CreateCommonKey({
            KeyInfoList = {
                {
                    ImgShortPath = "Y",
                    Type = "Img"
                }
            },
        })
        self.Com_KeyTips:UpdateKeyInfo({
            {
                KeyInfoList = {{Type = "Img", ImgShortPath = "X"}},
                Desc = GText("UI_CTL_ESC_Exit"),
                bLongPress = true
            },
            {
                KeyInfoList = {{Type = "Img", ImgShortPath = "A"}},
                Desc = GText("UI_Tips_Ensure")
            },
            {
                KeyInfoList = {{Type = "Img", ImgShortPath = "B"}},
                Desc = GText("UI_Tips_Close")
            },
        })
        self.LogOutKey = self.Com_KeyTips:GetComKeyById(1)
        self.LogOutKey:AddExecuteLogic(self, self.OnClickExitGame)
    end
end
-- function Menu_World_PC_C:InitAvatorList(UnLocked)
--     self.List_Avatar:ClearListItems()
--     local Avatar = GWorld:GetAvatar()
--     if(not Avatar)then
--         return
--     end
--     --local ClassPath = '/Game/UI/WBP/Menu/Widget/Menu_Avatar_Cell_Content.Menu_Avatar_Cell_Content_C'
--     local ClassPath = UIUtils.GetCommonItemContentClass()
--     local Char = Avatar.Chars[Avatar.CurrentChar]
--     local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
--     local MeleeIcon='/Game/UI/Texture/Dynamic/Atlas/Battle/T_Battle_Team_Melee.T_Battle_Team_Melee'
--     local RangedIcon='/Game/UI/Texture/Dynamic/Atlas/Battle/T_Battle_Team_Ranged.T_Battle_Team_Ranged'
--     local SpecialIcon='/Game/UI/UI_PNG/Common/Icon/Icon_Menu_Special.Icon_Menu_Special'
--     local CharIconPath=DataMgr.Char[Char.CharId].EscIcon
--     local  CharIcon = LoadObject(CharIconPath)
--     self.Icon_Avatar:SetBrushResourceObject(CharIcon)
--     self.Text_AvatarLevel:SetText(Char.Level)
--     self.Text_UIDName:SetText(GText("UI_UID"))
--     self.Text_AvatarLevelName:SetText(GText("UI_LEVEL_NAME"))
--     local MeleeWeapon,RangedWeapon,ProminentWeapon
--     if PlayerCharacter.MeleeWeapon and UnLocked then
--         MeleeWeapon=self:LoadSetContent(MeleeIcon,2,ClassPath,DataMgr.Weapon[PlayerCharacter.MeleeWeapon.WeaponId].WeaponName,PlayerCharacter.MeleeWeapon:GetAttr("Level"))
--     else
--         MeleeWeapon=self:LoadSetContent(nil,nil,ClassPath)
--     end
--     if PlayerCharacter.RangedWeapon and UnLocked then
--         RangedWeapon=self:LoadSetContent(RangedIcon,3,ClassPath,DataMgr.Weapon[PlayerCharacter.RangedWeapon.WeaponId].WeaponName,PlayerCharacter.RangedWeapon:GetAttr("Level"))
--     else
--         RangedWeapon=self:LoadSetContent(nil,nil,ClassPath)
--     end
--     if PlayerCharacter.UltraWeapon and UnLocked and Avatar:CheckUIUnlocked('UWeapon') then
--         ProminentWeapon=self:LoadSetContent(SpecialIcon,4,ClassPath,DataMgr.UWeapon[PlayerCharacter.UltraWeapon.WeaponId].WeaponName,PlayerCharacter.UltraWeapon:GetAttr("Level"))
--     else
--         ProminentWeapon=self:LoadSetContent(nil,nil,ClassPath)
--     end
--     self.List_Avatar:ClearListItems()
--     local ContentList={MeleeWeapon,RangedWeapon,ProminentWeapon}
--     for _, Content in ipairs(ContentList) do
--         if Content then
--             self.List_Avatar:AddItem(Content)
--         end
--     end


-- end

-- function Menu_World_PC_C:LoadSetContent(Icon,Id,ContentPath,Name,Level)
--     --local ClassPath = UE4.LoadClass(ContentPath)
--     local AvatarContent = NewObject(ContentPath)
--     if Icon==nil or GText(Name) ==Name then
--         AvatarContent.IsEmptyContent=true
--         AvatarContent.IsWorld=true
--         return AvatarContent
--     end
--     AvatarContent.Text_Info=GText(Name)
--     AvatarContent.Text_LevelInfo=Level
--     AvatarContent.Id=Id
--     AvatarContent.IconPath=Icon
--     AvatarContent.IsWorld=true
--     AvatarContent.Text_LevelInfo_Name=GText("UI_LEVEL_NAME")
--     return AvatarContent
-- end

function Menu_World_PC_C:OnKeyDown(MyGeometry, InKeyEvent)
    -- 判断是否有二级界面存在
    local DungenonBattleCount = UIManager(self):GetUI("DungenonBattleCount")
    local CommonConfirmPanel = UIManager(self):GetUI("CommonConfirmPanel")
    local CommonDialogTip = UIManager(self):GetUI(UIConst.CommonDialogTip)
    local SettingSkill = UIManager(self):GetUI(UIConst.SkillDetails)
    if (DungenonBattleCount ~= nil or CommonConfirmPanel ~= nil or CommonDialogTip or SettingSkill) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName == UIConst.GamePadKey.SpecialLeft then
            self:OnCopyUID()
        elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then
            self.LogOutKey:OnButtonPressed()
        elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
            if not self.IsEditOpen and self.OnClickEdit then
                self:OnClickEdit()
            end
        elseif InKeyName == UIConst.GamePadKey.LeftThumb then
            if self.WBP_Ban:GetVisibility() == UIConst.VisibilityOp.SelfHitTestInvisible then
                local Params = {}
                local Avatar = GWorld:GetAvatar()
                if not Avatar then
                    return
                end
                local ForbidDungeonRewardCount = Avatar.ForbidDungeonRewardCount or 30
                local PunishCountText = string.format(GText("UI_DungeonPunish_Times"), ForbidDungeonRewardCount)
                Params.Tips = {
                    PunishCountText
                }
                AudioManager(self):PlayUISound(self, "event:/ui/activity/baned_click", nil, nil)
                UIManager(self):ShowCommonPopupUI(100333, Params)
            end
        end
    else
        if (InKeyName == "Escape") then
            if  self.CanCloseByHotKey then
                self:Close()
            end
        end
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function Menu_World_PC_C:OnKeyUp(MyGeometry, InKeyEvent)
    self.CanCloseByHotKey=true
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == UIConst.GamePadKey.FaceButtonLeft) then
            IsEventHandled = true
            self.LogOutKey:OnButtonReleased()
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function Menu_World_PC_C:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled=false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName==UIConst.GamePadKey.FaceButtonRight and not self.IsEditOpen then
                self:Close()
                IsEventHandled=true
        end
    end
    if IsEventHandled then
        return UIUtils.Handled
    else
        return UIUtils.Unhandled
    end
end



function Menu_World_PC_C:InitExperienceBtn()
    --self.Text_Experience:SetText(GText("UI_Player_Level_Reward"))
    local Params={}
    Params.Name=GText("PlayerLevel_ExpSource")
    Params.OpenDialog=function ()
        AudioManager(self):PlayUISound(nil,"event:/ui/common/click_level_03", nil, nil)
        UIManager(self):ShowCommonPopupUI(100249,{Parent=self},self.ExperienceBtn_EX)
    end
    self.ExperienceBtn_EX:Init(Params)
    Params.Name=GText("PlayerLevel_Buff")
    Params.OpenDialog=function ()
        AudioManager(self):PlayUISound(nil,"event:/ui/common/click_level_03", nil, nil)
        UIManager(self):ShowCommonPopupUI(100245,{Parent=self},self.ExperienceBtn_Buff)
    end
    self.ExperienceBtn_Buff:Init(Params)
    self.Btn_Experience.AudioEventPath="event:/ui/common/click_btn_small"
end



function Menu_World_PC_C:OnClickContinueGame()
    self:Close()
end

function Menu_World_PC_C:CheckName()
    -- local function func()
    --     UIManager(self):ShowCommonPopupUI_Old(100060, self, self.ClickConfirmExitInBattle)
    -- end
    -- self:AddTimer(0.1, func)
end




function Menu_World_PC_C:OnClickCommonSet()
    self:StopPress()
    local Setting = UIManager(self):LoadUINew("Setting")
    if Setting then
        self:PlayOutAnim()
    end
end



function Menu_World_PC_C:OnClickExitGame()
    --AudioManager(self):PlayUISound(nil,"event:/ui/common/click_btn_small", nil, nil)
    self:StopPress()
    if self.IsEditOpen then
        self.IsEditOpen=false
        self:PlayAnimation(self.Edit_List_Out)
    end
    local Params = {}
    Params.RightCallbackObj = self
    Params.RightCallbackFunction = self.ClickConfirmExitOutBattle
    UIManager(self):ShowCommonPopupUI(100008, Params,self)
end

function Menu_World_PC_C:ClickConfirmExitOutBattle()
    GWorld.NetworkMgr:OnDisconnectAndLoginAgain()
    self:Close()
end


function Menu_World_PC_C:Close()
    if self:IsAnimationPlaying(self.In) then
        return
    end
    AudioManager(self):SetEventSoundParam(self, "EscMenuOpen", {ToEnd = 1})
    local AnimObj = self:GetAnimationByName("Out")
    if self:IsAnimationPlaying(self.Out) then
        return
    end
    self.CloseBySelf=true
    local BattleMainUI = UIManager(self):GetUI('BattleMain')
    self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
	self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    if (BattleMainUI ~= nil) then
        if self.bRecoverImmersionMode then
            local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
            if not IsValid(Player) then
                return
            end
            if Player.IsImmersionModel then--只做关闭的情况
                Player:ImmersionModel()
            end
        end
        if BattleMainUI:RemovePlayInOutSystems(self.WidgetName) and BattleMainUI:TryRecoverUI() then
            BattleMainUI:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        end
        BattleMainUI:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)

    end
    if self.IsEditOpen then
        self.IsEditOpen=false
        self:PlayAnimation(self.Edit_List_Out)
    end
    local function PlayAnimFinished()
        self:ReddotTreePlugOut()
        if self.HudRewardList then
            UIUtils.ShowHudReward(self.HudRewardTitle, self.HudRewardList) -- 关闭Esc之后才显示Reward
        end
        self:UnbindAllFromAnimationFinished(self.Out)
        self.Super.Close(self)
    end
    if self.CloseByChild then
        PlayAnimFinished()
    else
        self:PlayAnimation(AnimObj)
        self:BindToAnimationFinished(AnimObj, {self, PlayAnimFinished})
    end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if IsStandAlone(Player) then
        -- Player:SetCharacterTag(self.PlayerCurrentTag)
        Player:SetCanInteractiveTrigger(true)
    end
end

function Menu_World_PC_C:UpdateRedDotStates()
    for id=1,self.FunctionButtonNum do
        local Item=self.Panel_Function:GetChildAt(id-1)
        if(Item) then
            Item:UpdateRedDot()
        end
    end
    self.Entrance_Shop:UpdateRedDot()
    self.Entrance_Activity:UpdateRedDot()
end

-- function Menu_World_PC_C:UpdateRedDot()
--     if self.ShowRedDotFunc then 
--         local IsNew,Upgradeable,OtherReddot = self:ShowRedDotFunc()
--         self:SetRedDot(IsNew,Upgradeable,OtherReddot) 
--     end
-- end

-- function Menu_World_PC_C:SetRedDot(IsNew,Upgradeable,OtherReddot,Count)
--     self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     self.Reddot:SetVisibility(UE4.ESlateVisibility.Collapsed)
--     if IsNew then
--         self.New:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--         return
--     end
--     if(Upgradeable)then
--         self.Reddot:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--     end
-- end

function Menu_World_PC_C:SetPlayerInfo()
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            local PlayerName =Avatar.Nickname
            local PlayerSignature=Avatar.Signature
            local CurrentLevel=Avatar.Level
            local CurrentExp=Avatar.Exp
            local HeadIconId=Avatar.HeadIconId
            local HeadFrameId=Avatar.HeadFrameId
            local MaxExp=nil
            local LevelInfo=DataMgr.PlayerLevelUp[CurrentLevel]
            local ExpName=GText("UI_Player_Level")
            local LevelName=GText("RESOURCE_NAME_2001")
            if(LevelInfo) then MaxExp=LevelInfo.PlayerLevelMaxExp end
            if PlayerName ==nil or CurrentLevel==nil or CurrentExp==nil or MaxExp==nil then
                DebugPrint("[Esc] PlayerInfo is nil")
            end
            if CurrentExp then self.Exp_Now:SetText(tostring(CurrentExp)) end
            if MaxExp then self.Exp_Total:SetText(tostring(MaxExp)) end
            if CurrentLevel then self.Text_Level:SetText(tostring(CurrentLevel)) end
            if PlayerName then self.Text_Name:SetText(GText(PlayerName)) end
            if PlayerSignature~="" then
                self.Switcher_Input:SetActiveWidgetIndex(1)
                self.Text_Input:SetText(PlayerSignature)
            else
                self.Switcher_Input:SetActiveWidgetIndex(0)
            end
            --if ExpPanel then self.Text_Exp:SetText(GText(ExpPanel)) end
            if ExpName  then self.Text_ExpName:SetText(GText("RESOURCE_NAME_2001")) end
            if Avatar.Uid then self.Text_UID:SetText(tostring(Avatar.Uid)) end
            self.Head_Player:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            if HeadIconId then
                self.Head_Player:SetHeadIconById(HeadIconId)
            end
            if HeadFrameId then
                if HeadFrameId==-1 then
                    self.Head_Frame:SetVisibility(UIConst.VisibilityOp.Collapsed)
                else
                    local Path=DataMgr.HeadFrame[HeadFrameId].SmallIcon
                    local ImageResource = LoadObject(Path)
                    if ImageResource ~= nil then
                        self.Head_Frame:SetBrushResourceObject(ImageResource)
                    end
                    self.Head_Frame:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
                end
            end
            if CurrentExp~=nil and MaxExp~=nil then
                self.Progress_Exp:SetPercent(CurrentExp/MaxExp)
            end
        end
end

function Menu_World_PC_C:InitBg()
    local Avatar = GWorld:GetAvatar()
    if(not Avatar)then
        return
    end
    local Char = Avatar.Chars[Avatar.CurrentChar]
    local CharIconPath=DataMgr.Char[Char.CharId].EscMenuBg
    local Image = LoadObject(CharIconPath)
    if Image then
        local DynamicMaterial = self.Img_Avatar:GetDynamicMaterial()
        DynamicMaterial:SetTextureParameterValue("MainTex",Image)
    end
end


function Menu_World_PC_C:PlayInAnim()
    self:UnbindAllFromAnimationFinished(self.Out)
    self:StopAnimation(self.Out)
    self:PlayAnimation(self.In)
end

function Menu_World_PC_C:PlayOutAnim()
    self:StopAnimation(self.In)
    self:PlayAnimation(self.Out)
end

function Menu_World_PC_C:HideOrShowReddot(Content,id)
        local BtnInfo=DataMgr.MainUI[id]
        local UIUnlockRuleName = BtnInfo.UIUnlockRuleName
        if UIUnlockRuleName then
            local UIUnlockRule = DataMgr.UIUnlockRule
            local UIUnlockRuleId = UIUnlockRule[UIUnlockRuleName].UIUnlockRuleId
            local Avatar = GWorld:GetAvatar()
            if Avatar then
               local bUnlocked= Avatar:CheckUIUnlocked(UIUnlockRuleId)
                    if bUnlocked then
                        Content.New:SetRenderOpacity(1)
                        Content.Reddot:SetRenderOpacity(1)
                    else
                        Content.New:SetRenderOpacity(0)
                        Content.Reddot:SetRenderOpacity(0)
                    end
            end
        end
end

function Menu_World_PC_C:InitSystemItem()
    self.Panel_Function:ClearChildren()
    self.WB_Entrance:ClearChildren()
    self.Entrance_Shop:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Entrance_Activity:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Entrance_Shop.WidgetSwitcher_State:SetActiveWidgetIndex(1)
    self.Entrance_Activity.WidgetSwitcher_State:SetActiveWidgetIndex(1)
    local ItemNum = #DataMgr.MainUI
    local InitSuccNum=0
    local  SmallWidgetNum=0
    local SystemData = DataMgr.MainUI
    self.SystemSortList = {}
    for index,Data in pairs(SystemData) do
        table.insert(self.SystemSortList,{Id = index,Sequence = Data.Sequence or 0})
    end
    table.sort(self.SystemSortList,function (Data1, Data2)
        return Data1.Sequence < Data2.Sequence
    end)
    local Avatar = GWorld:GetAvatar()
    local UnlockNum=0
    for _,Value in pairs(self.SystemSortList) do
        local id=Value.Id
        local MainUIConfig=DataMgr.MainUI[Value.Id]
        local bUnlocked=true
        local UIUnlockRuleName = DataMgr.MainUI[id].UIUnlockRuleName
        if UIUnlockRuleName == "GameEvent" then
            local a= 1
        end
        if UIUnlockRuleName then
            local UIUnlockRule = DataMgr.UIUnlockRule
            local UIUnlockRuleId = UIUnlockRule[UIUnlockRuleName].UIUnlockRuleId
            if Avatar then
                bUnlocked = Avatar:CheckUIUnlocked(UIUnlockRuleId)
            end
        end
        if  MainUIConfig and UIUtils.CheckCdnHide(MainUIConfig.SystemUIName) then
            bUnlocked=false
        end
        if DataMgr.MainUI[id].EscShowCondition and bUnlocked then
            local Type=nil
            local WidgetName="MenuEntranceBtn"
            if DataMgr.MainUI[id].EscShowType==1 then
                Type="Small"
                WidgetName="MenuEntranceBtnS"
            end
            local ChannelId = HeroUSDKSubsystem(self):GetChannelId()
            local IgnoreCNChannelIds = {
                [46] = true,          --安卓-B站
                [303] = true,         --安卓-oppo
                [269] = true,         --PC-B站
                [286] = true,         --PC-Wegame
                [297] = true,         --PC-联想
                [301] = true,         --IOS-云游戏
                [300] = true,         --安卓-云游戏
            }
            local Item
            if(id==self.ShopEntranceId or id==self.ActivityEntranceId) then
                Type="Large"
                if(id==self.ShopEntranceId) then
                    Item=self.Entrance_Shop
                else
                    Item=self.Entrance_Activity
                end
            elseif id == self.RelatedProductEntranceId and UE.AHotUpdateGameMode.IsGlobalPak() then --海外包和部分渠道包屏蔽周边商场
                goto continue
            elseif id == self.CloudGameEntranceId and (UE.AHotUpdateGameMode.IsGlobalPak() or IgnoreCNChannelIds[ChannelId]) then --海外包和部分渠道包屏蔽云游戏
                goto continue
            else
                local TaskName="MenuEntranceBtn_"..id
                 Item =UIManager(GWorld.GameInstance):_CreateWidgetNew(WidgetName)
                --  self:AsyncLoadWidgetCommon(TaskName, function(CoroutineObj)
                --      Item = CoroutineObj
                --  end)
            end
            if Item then
                local ConditionSucc = ConditionUtils.CheckCondition(Avatar, DataMgr.MainUI[id].EscShowCondition)
                if ConditionSucc then
                    self:HideOrShowReddot(Item,id)
                    Item.BtnId=id
                    if id == CommonConst.ArmoryEnterId then
                        self.ArmoryItem=Item
                    end
                    Item:LoadImage(id,Type)
                    Item.Owner=self
                    Item.LinkName = DataMgr.MainUI[id].Link
                    if Type=="Small" then
                        self.WB_Entrance:AddChildToWrapBox(Item)
                    else
                        if Type~="Large" then
                            self.Panel_Function:AddChildToWrapBox(Item)
                            InitSuccNum=InitSuccNum+1
                        end
                        Item.WidgetSwitcher_State:SetActiveWidgetIndex(0)
                    end
                    local IsForbid,ForbidToast=self:CheckSystemForbid(MainUIConfig.SystemUIName)
                    Item:InitButton(self,IsForbid,ForbidToast)
                end
            end
        else
            if(id==4 or id==18) then
                UnlockNum=UnlockNum+1
            end
            if UnlockNum==2 then
                self.Entrance_Shop:SetVisibility(UIConst.VisibilityOp.Collapsed)
                self.Entrance_Activity:SetVisibility(UIConst.VisibilityOp.Collapsed)
            end
        end
        ::continue::
    end
    --填充4的整倍数
    ItemNum=ItemNum+4-ItemNum%4
    local EmptyNum=ItemNum- InitSuccNum
    for id=1,EmptyNum do
        local Item =UIManager(GWorld.GameInstance):_CreateWidgetNew("MenuEntranceBtn")
        if Item then
            Item.WidgetSwitcher_State:SetActiveWidgetIndex(1)
            Item:InitButton(self)
            self.Panel_Function:AddChildToWrapBox(Item)
        end
    end
end

function Menu_World_PC_C:LoadExpTip()
    self:StopPress()
    local TipTitle=GText("UI_Toast_Experience_Title")
    local TipContent=GText("UI_Toast_Experience_Content")
    AudioManager(self):PlayUISound(nil,"event:/ui/common/click_btn_small", nil, nil)
    UIManager(self):LoadUINew(UIConst.CommonDialogTip,TipTitle,TipContent)
end

function Menu_World_PC_C:OnCopyUID()
    --AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_small",nil, nil)
    local CopyStr = self.Text_UID:GetText()
    UE.UUIFunctionLibrary.ClipboardCopy(CopyStr)
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_Tosat_Menu_CopyUID"))
end

function Menu_World_PC_C:OnClickArmory()
    UIUtils.PlayCommonBtnSe(self)
    UIUtils.OpenSystem(1,true)
end



-- 关闭Esc之后才显示的轻量化Reward列表
function Menu_World_PC_C:ShowHudRewardAfterClose(HudRewardTitle, HudRewardList)
    self.HudRewardTitle = HudRewardTitle
    self.HudRewardList = HudRewardList
end

function Menu_World_PC_C:Show(ShowTag)
    self.Super.Show(self,ShowTag)
      if  self.ArmoryItem then
        self.ArmoryItem:UpdateArmoryIcon()
    end
    self:SetPlayerInfo()
end


function Menu_World_PC_C:AddInputMethodChangedListen()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice) 
    end
end

function Menu_World_PC_C:RemoveInputMethodChangedListen()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice) 
    end
end


function Menu_World_PC_C:InitArmoryButton()
    self.Button_Area.OnClicked:Add(self,self.OnBtnClicked)
    self.Button_Area.OnPressed:Add(self,self.OnBtnPressed)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Button_Area.OnHovered:Add(self,self.OnBtnHovered)
        self.Button_Area.OnUnhovered:Add(self,self.OnBtnUnhovered)
    end
    self.Button_Area.OnReleased:Add(self,self.OnBtnReleased)
end
function Menu_World_PC_C:AddReddotListener(ReddotNodeName,func)
    self:RemoveReddotListener(ReddotNodeName)
    ReddotManager.AddListener(ReddotNodeName,self, func)
    if not self.ListenedReddot then self.ListenedReddot = {} end
    self.ListenedReddot[ReddotNodeName] = true
end

function Menu_World_PC_C:RemoveReddotListener(ReddotNodeName)
    if(self.ListenedReddot and self.ListenedReddot[ReddotNodeName]) then
        ReddotManager.RemoveListener(ReddotNodeName,self)
        self.ListenedReddot[ReddotNodeName] = false
    end
end

function Menu_World_PC_C:OnEditBtnReddotChange(Count)
    self.Button_Edit.New:SetEnable(Count>0)
end

function Menu_World_PC_C:OnExperienceReddotChange()
    if not ReddotManager.GetTreeNode("ExperienceMain") then
        ReddotManager.AddNode("ExperienceMain")
    end
    local TreeNode = ReddotManager.GetTreeNode("ExperienceMain")
    if TreeNode.Count > 0 then
        self.Btn_Experience:SetReddotVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Btn_Experience:SetReddotVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function Menu_World_PC_C:Destruct()
    self:RemoveReddotListener("EditBtn",self.OnEditBtnReddotChange)
    self:RemoveReddotListener("ExperienceMain")
    self:RemoveInputMethodChangedListen()
    self.Super.Destruct(self)
end


----------------------------------------- 按钮 Click -----------------------------------------------
function Menu_World_PC_C:PlayButtonClickSound()
    UIUtils.PlayCommonBtnSe(self)
end

function Menu_World_PC_C:PlayButtonClickAnimation()
    --self:StopAllAnimations()
    self:PlayAnimation(self.Click)
end

function Menu_World_PC_C:OnBtnClicked()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self:PlayButtonClickAnimation()
    else
        self:StopAnimation(self.Press)
        self:PlayAnimation(self.Normal)
    end
    if self.IsEditOpen then
        self.IsEditOpen = false
        local function PlayAnimFinished()
            self:OnClickArmory()
            self:UnbindAllFromAnimationFinished(self.Edit_List_Out)
        end
        self:BindToAnimationFinished(self.Edit_List_Out, {self, PlayAnimFinished})
        self:PlayAnimation(self.Edit_List_Out)
    else
        self:OnClickArmory()
    end
end
----------------------------------------- 按钮 Click -----------------------------------------------

----------------------------------------- 按钮 Press -----------------------------------------------
function Menu_World_PC_C:PlayButtonPressAnim()
    --self:StopAllAnimations()
    self:PlayAnimation(self.Press)
end

function Menu_World_PC_C:OnBtnPressed()
    --self:SoundFunc(self)
    self.IsPressing = true
    self:PlayButtonPressAnim()
end
----------------------------------------- 按钮 Press -----------------------------------------------

----------------------------------------- 按钮 Hover -----------------------------------------------
function Menu_World_PC_C:PlayButtonHoverAnim()
    --self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
end

function Menu_World_PC_C:OnBtnHovered()
    self.IsHovering = true
    self:PlayButtonHoverAnim()
end

function Menu_World_PC_C:SetBtnHovered(IsHovered)
    if IsHovered then 
        self:OnBtnHovered()
    else 
        self:OnBtnUnhovered()
    end
end 

----------------------------------------- 按钮 Hover -----------------------------------------------

----------------------------------------- 按钮 Release -----------------------------------------------
function Menu_World_PC_C:PlayButtonReleaseButHoverAnim()
    self:StopAnimation(self.Click)
    self:PlayButtonHoverAnim()
end

function Menu_World_PC_C:PlayButtonReleaseAndUnHoverAnim()
    --self:StopAllAnimations()
    self:SwitchNormalAnimation()
end

function Menu_World_PC_C:OnBtnReleased()
    self.IsPressing = false
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        if  not self.IsHovering then
            self:PlayButtonReleaseAndUnHoverAnim()
        else
            self:PlayButtonReleaseButHoverAnim()
        end
    else
        self:PlayAnimation(self.Normal)
    end
end
----------------------------------------- 按钮 Release -----------------------------------------------

----------------------------------------- 按钮 UnHover -----------------------------------------------
function Menu_World_PC_C:PlayButtonUnHoverAnim()
   -- self:StopAllAnimations()
    self:SwitchNormalAnimation()
end

function Menu_World_PC_C:OnBtnUnhovered()
    self.IsHovering = false
    if not self.IsPressing then
        self:PlayButtonUnHoverAnim()
    end
end
----------------------------------------- 按钮  UnHover -----------------------------------------------

function Menu_World_PC_C:SwitchNormalAnimation()
    self:PlayAnimation(self.UnHover)
    --self:PlayAnimation(self.Normal)
end

--处理两个button同时按另一个丢响应残留动效问题
function Menu_World_PC_C:StopPress()
    if not CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self:StopAnimation(self.Press)
        self:PlayAnimation(self.Normal)
    end
end

--------------------------------------------按键动效-----------------------------------------
---
---
-----------------------手柄端部分--------------------------
function Menu_World_PC_C:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
    if CurInputType == ECommonInputType.Gamepad then
        self:InitGamepadView()
    elseif CurInputType == ECommonInputType.MouseAndKeyboard then
        self:InitKeyboardView()
    end
end


function Menu_World_PC_C:OnPanelNavigationToBoundary(NavigationDirection)
    if(NavigationDirection == EUINavigation.Up)then
        local IsFocusLeft=self:IsFoucsLeftPanelFunctionBtn()
        local LeftUnlocked=self.Entrance_Shop.WidgetSwitcher_State:GetActiveWidgetIndex()==0
        local RightUnlocked=self.Entrance_Activity.WidgetSwitcher_State:GetActiveWidgetIndex()==0
        if LeftUnlocked and RightUnlocked then
            if IsFocusLeft then
                self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.Entrance_Shop.Button_Area)
            else
                self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.Entrance_Activity.Button_Area)
            end
        elseif LeftUnlocked then
            self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.Entrance_Shop.Button_Area)
        elseif RightUnlocked then
            self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.Entrance_Activity.Button_Area)
        else
            self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.Btn_TEXT)
        end
    end
end

function Menu_World_PC_C:OnBtnTextDown(NavigationDirection)
    if(NavigationDirection == EUINavigation.Down)then
        if self.Entrance_Shop.WidgetSwitcher_State:GetActiveWidgetIndex()==0 then
            self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.Entrance_Shop.Button_Area)
        elseif self.Entrance_Activity.WidgetSwitcher_State:GetActiveWidgetIndex()==0 then
            self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.Entrance_Activity.Button_Area)
        else
            local Item=self.Panel_Function:GetChildAt(0)
            if Item then
                self.GameInputModeSubsystem:SetTargetUIFocusWidget(Item)
            end
        end
    end
end


function Menu_World_PC_C:OnWBEntranceNavigateRight(NavigationDirection)
    if(NavigationDirection == EUINavigation.Right)then
        if self.Entrance_Shop.WidgetSwitcher_State:GetActiveWidgetIndex()==0 then
            self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.Entrance_Shop.Button_Area)
        elseif self.Entrance_Activity.WidgetSwitcher_State:GetActiveWidgetIndex()==0 then
            self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.Entrance_Activity.Button_Area)
        else
            local Item=self.Panel_Function:GetChildAt(0)
            if Item then
                self.GameInputModeSubsystem:SetTargetUIFocusWidget(Item)
            end
        end
    end
end


function Menu_World_PC_C:ForbidNavigate()
    self.Button_Edit:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Btn_Experience:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Button_Copy:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Close_Area:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function Menu_World_PC_C:RecoverNavigate()
    self.Button_Edit:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Btn_Experience:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Button_Copy:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Close_Area:SetVisibility(UIConst.VisibilityOp.Visible)
end

function Menu_World_PC_C:SwitchToPC()
    if not UE4.UUCloudGameInstanceSubsystem.IsCloudGame() then
        self.Button_Logout:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Com_KeyTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Icon_Copy:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Key_Copy:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.Key_Edit:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function Menu_World_PC_C:SwitchToGamePad()
    if not UE4.UUCloudGameInstanceSubsystem.IsCloudGame() then
        self.Button_Logout:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Com_KeyTips:SetVisibility(UIConst.VisibilityOp.Visible)
        self.Icon_Copy:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Key_Copy:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    self.Key_Edit:SetVisibility(UIConst.VisibilityOp.Visible)
end

function Menu_World_PC_C:InitGamepadView()
	--self.Switch_Key:SetActiveWidgetIndex(1)
    self:ForbidNavigate()
    self:SwitchToGamePad()
    if self:HasFocusedDescendants() or self:HasAnyUserFocus() then
        if self.IsEditOpen then
            self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.Btn_PersonalInfo.Button_Area)
        else
            if self.Entrance_Shop.WidgetSwitcher_State:GetActiveWidgetIndex()==0 then
                self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.Entrance_Shop.Button_Area)
            else
                local Item=self.Panel_Function:GetChildAt(0)
                if Item then
                    self.GameInputModeSubsystem:SetTargetUIFocusWidget(Item)
                end
            end 
        end
        self.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
    end
end

function Menu_World_PC_C:InitKeyboardView()
    self:RecoverNavigate()
    self:SwitchToPC()
end

function Menu_World_PC_C:SetFocus_Lua()
    if not self.GameInputModeSubsystem then
        return
    end
    if self.GameInputModeSubsystem:GetCurrentInputType()==ECommonInputType.Gamepad then
        self:AddTimer(0.01,function ()
        if self.IsEditOpen then
            self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.Btn_PersonalInfo.Button_Area)
            self.Btn_PersonalInfo.Button_Area:SetFocus()
        else
            if self.Entrance_Shop.WidgetSwitcher_State:GetActiveWidgetIndex()==0 then
                --self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.Entrance_Shop.Button_Area)
                self.Entrance_Shop.Button_Area:SetFocus()
            else
                --self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.Head_Player.Button_Area)
                self.Head_Player.Button_Area:SetFocus()

            end 
        end
    end,false,0,nil,true)
        --self.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
    end
end
-- 检测系统是否被禁用，目前只有昼夜系统
local DayAndNightForbidFunc = function(self)
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    if not GameMode then return true end
    local SubSystem = GameMode:GetRegionDataMgrSubSystem()
    if not SubSystem then return true end
    local CurSubRegionId = SubSystem:GetCurSubRegionId()
    if not CurSubRegionId or CurSubRegionId <= 0 then return true end
    local SubRegionData = DataMgr.SubRegion[CurSubRegionId]
    if not SubRegionData then return true end
    return not (SubRegionData.TODSetting == true)
end

local ForbidFunc={
    DayAndNight=DayAndNightForbidFunc
}
local ForbidToasts={
    DayAndNight="UI_Disabled_Des_SetTime"
}

function Menu_World_PC_C:CheckSystemForbid(SystemUIName)
    local ForbidFunc=ForbidFunc[SystemUIName]
    local ForbidToast=ForbidToasts[SystemUIName]
    if ForbidFunc then
        return ForbidFunc(self),ForbidToast
    else
        return false
    end
end
-- local USE_ASYNC = false  --- 一键退化为同步加载

-- ---@param TaskName string 协程任务Id，确保不要跟任何对象中的成员重名
-- ---@param Callback fun 回调
-- function Menu_World_PC_C:AsyncLoadWidgetCommon(TaskName, Callback)
--     if not self.ComItemAsyncTasks then
--         self.ComItemAsyncTasks = {}
--     end
--     if USE_ASYNC  then
--         self.ComItemAsyncTasks[TaskName] = 1
--         ForceStopAsyncTask(self, TaskName)
--         local CallbackWrapper = function(CoroutineObj)
--             Callback(CoroutineObj)
--             self.ComItemAsyncTasks[TaskName] = nil
--         end
--         RunAsyncTask(self, TaskName, CallbackWrapper)
--     else
--         Callback()
--     end
-- end

function Menu_World_PC_C:InitBanReward()
    if not self.WBP_Ban then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local ForbidDungeonRewardCount = Avatar.ForbidDungeonRewardCount or 30
    if ForbidDungeonRewardCount > 0 then
        self.WBP_Ban:InitPunishCount(ForbidDungeonRewardCount)
        self.WBP_Ban:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.WBP_Ban:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end


AssembleComponents(Menu_World_PC_C)
return Menu_World_PC_C
