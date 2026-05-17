require "UnLua"
local RewardBox = require "BluePrints.Client.CustomTypes.SimpleRewardBox"
---@type Walnut_Reward_PC_C
local M = Class("BluePrints.UI.BP_UIState_C")

local SONGLU_WALNUT_ID = 1020
local SYSTEM_GUIDE_ID = 2072

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Construct()
    self:CommonConstruct()
    if IsStandAlone(self) then
        self:StandaloneConstruct()
        self.IsStandAlone = true
    else
        self:MultiConstruct()
        self.IsStandAlone = false
        self:StartCountDown()
        self:InitTeamHeads()
    end
    self.MaxRarity = 3
    self:InitRewards()
    self:BindEvents()

    if self.NoWalnut and not self.IsStandAlone then
        self.WB_Player:GetChildAt(0).Head_Team:SetFocus()
    end

    -- 无尽副本自动选择奖励
    self:CheckIsAutoMode()
end

function M:OnLoaded(...)
    if #self.RewardList > 0 then
        self:PlayAllInAnimation()
        AudioManager(self):PlayUISound(self, "event:/ui/common/mihan_level_finish_choose_open", "WalnutReward", nil)
    else
        self:PlayNoRewardInAnimation()
        AudioManager(self):PlayUISound(self, "event:/ui/common/mihan_level_finish_choose_none_open", "WalnutReward", nil)
    end
    self:CheckRunSystemGuide()
end

function M:Close()
    AudioManager(self):SetEventSoundParam(self, "WalnutReward", {ToEnd=1})
    self.Super.Close(self)
end

function M:PlayAllInAnimation()
    self.Reward_1st:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Reward_2nd:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Reward_3rd:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Reward_1st.Main:SetRenderOpacity(1)
    self:InitSelectedReward(self.Reward_2nd)
    self:InitSelectedReward(self.Reward_3rd)
    -- self:PlayAnimation(self.Ready)
    -- self.WidgetSwitcher_State:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.WidgetSwitcher_State:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

    if self.MaxRarity == 1 then
        self:PlayAnimation(self.Ready_Gold)
        AudioManager(self):PlayUISound(self, "event:/ui/common/mihan_level_finish_choose_start_gold", nil, nil)
    elseif self.MaxRarity == 2 then
        self:PlayAnimation(self.Ready_Silver)
        AudioManager(self):PlayUISound(self, "event:/ui/common/mihan_level_finish_choose_start_normal", nil, nil)
    else
        self:PlayAnimation(self.Ready_Bronze)
        AudioManager(self):PlayUISound(self, "event:/ui/common/mihan_level_finish_choose_start_normal", nil, nil)
    end
end

function M:PlayAnimationOn1st()
    local RewardAnimation = self:GetRewardItemAnimation(1)
    self.Reward_1st:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Reward_1st:PlayAnimation(RewardAnimation)
    AudioManager(self):PlayUISound(self, "event:/ui/common/mihan_level_finish_choose_page_show", nil, nil)
end

function M:PlayAnimationOn2nd()
    local RewardAnimation = self:GetRewardItemAnimation(2)
    self.Reward_2nd:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Reward_2nd:PlayAnimation(RewardAnimation)
end

function M:PlayAnimationOn3rd()
    local RewardAnimation = self:GetRewardItemAnimation(3)
    self.Reward_3rd:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Reward_3rd:PlayAnimation(RewardAnimation)
    self.Reward_1st.Button_Area:SetFocus()
end

function M:PlayNoRewardInAnimation()
    -- self:BindToAnimationFinished(self.In, {self, function()
    --     self:UnbindAllFromAnimationFinished(self.In)
    --     self:PlayAnimation(self.Interface_In)
    -- end})
    -- self:PlayAnimation(self.In)
end

function M:GetRewardItemAnimation(Index)
    local RewardInfo = self.RewardList[Index]
    local RewardItem = self.RewardSelectWidgetList[Index]
    if RewardInfo.WalnutRewardRarity == 1 then
        return RewardItem.VX_Gold_In
    elseif RewardInfo.WalnutRewardRarity == 2 then
        return RewardItem.VX_Silver_In
    else
        return RewardItem.VX_Bronze_In
    end
end

function M:CommonConstruct()
    self.Text_Choose:SetText(GText("UI_Reward_Walnut_Choose"))
    self.Text_Selected:SetText(GText("UI_Walnut_Reward_Select"))
    self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
    self.WidgetSwitcher_Btn:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.WidgetSwitcher_Btn:SetActiveWidgetIndex(0)
    self.Panel_Info:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.SelectDone = false
    self.Reward_1st.SelectDone = false
    self.Reward_2nd.SelectDone = false
    self.Reward_3rd.SelectDone = false
    self.Btn_Confirm:TryOverrideSoundFunc(self.PlayClickButtonComfirmSound)
    self:InitGameInputMode()
end

function M:StandaloneConstruct()
    DebugPrint("Walnut_Reward StandaloneConstruct")
    self.Text_CountDown:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.WB_Player:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Btn_Confirm:SetText(GText("UI_CONFIRM_SELECTION"))
    self.Text_Empty:SetText(GText("UI_Reward_Walnut_Select_Warning"))
    self.Text_Hint_Multi:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:MultiConstruct()
    DebugPrint("Walnut_Reward MultiConstruct")
    self.Text_CountDown:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.WB_Player:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Confirm:SetText(GText("UI_CONFIRM_SELECTION"))
    self.Text_Empty:SetText(GText("UI_Reward_Walnut_Select_Wait"))
    self.Text_Hint_Multi:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Text_Hint_Multi:SetText(GText("UI_Reward_Walnut_Select_Warning"))
end

function M:InitRewards()
    self.RewardList = {}
    self.NoWalnut = false
    -- 获取奖励
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local WalnutRewardList = Avatar.Walnuts.WalnutRewardList
        DebugPrint("Walnut_Reward WalnutRewardList num", #WalnutRewardList)
        self.WalnutId = Avatar.Walnuts.WalnutId
        DebugPrint("Walnut_Reward WalnutId", self.WalnutId)
        if self.WalnutId and self.WalnutId > 0 then
            local WalnutData = DataMgr["Walnut"][self.WalnutId]
            local WalnutTypeData = DataMgr["WalnutType"][WalnutData.WalnutType]
            local WalnutIcon = WalnutData.Icon
            local WalnutNumber = WalnutData.WalnutNumber
            local Icon = LoadObject(WalnutIcon)
            self.Icon_Walnut:SetBrushResourceObject(Icon)
            if WalnutNumber then
                self.Walnut_Number:InitWalnutNumber(self.WalnutId)
                self.Walnut_Number:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            else
                self.Walnut_Number:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
        end
        PrintTable(WalnutRewardList, 8)
        if #WalnutRewardList <= 0 then
            self.NoWalnut = true
            self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
            self.WidgetSwitcher_Btn:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Panel_Preview:SetVisibility(UE4.ESlateVisibility.Collapsed)
            if self.IsStandAlone then
                self.Panel_Info:SetVisibility(UE4.ESlateVisibility.Collapsed)
                self:AddTimer(Const.StandAloneNoWalnutTipsTime, self.FinishStandNoWalnutTips, true, 0, "StandaloneNoWalnut")
            end
            return
        end
        -- PrintTable(WalnutRewardList, 8)
        for _, RewardTable in pairs(WalnutRewardList) do
            local RewardInfo = {}
            for RewardType, RewardTypeList in pairs(RewardTable) do
                -- DebugPrint("RewardType", RewardType, "RewardTypeList", RewardTypeList)
                for RewardID, Count in pairs(RewardTypeList) do
                    -- DebugPrint("RewardID", RewardID,"RewardDetail", RewardDetail)
                    local RewardCount = Count
                    if RewardCount > 0 then
                        RewardInfo.RewardID = RewardID
                        RewardInfo.RewardType = string.sub(RewardType, 1, -2)
                        RewardInfo.RewardCount = RewardCount
                        RewardInfo.WalnutRewardRarity = self:GetWalnutRewardRarity(RewardID, RewardInfo.RewardType, RewardInfo.RewardCount)
                        self.MaxRarity = math.min(self.MaxRarity, RewardInfo.WalnutRewardRarity)
                        -- DebugPrint("RewardInfo.WalnutRewardRarity", RewardInfo.WalnutRewardRarity)
                        -- DebugPrint("Count", RewardCount)
                        goto continue
                    end
                end
            end
            ::continue::
            table.insert(self.RewardList, RewardInfo)
        end
    end

    self.RewardSelectWidgetList = {self.Reward_1st, self.Reward_2nd, self.Reward_3rd}
    self.Fonts = {self.Reward_1st.Slot_Level:GetContent().Font
                        , self.Reward_2nd.Slot_Level:GetContent().Font
                        , self.Reward_3rd.Slot_Level:GetContent().Font}
    self.ColorAndOpacities = {self.Reward_1st.Slot_Level:GetContent().ColorAndOpacity
                        , self.Reward_2nd.Slot_Level:GetContent().ColorAndOpacity
                        , self.Reward_3rd.Slot_Level:GetContent().ColorAndOpacity}

    -- 显示奖励
    self:InitCommonItem(1)
    self:InitCommonItem(2)
    self:InitCommonItem(3)

    -- 当前选择的奖励
    self:OnClickReward1st()
    
end

function M:GetWalnutRewardRarity(RewardID, RewardType, RewardCount)
    if self.WalnutId then
        local WalnutData = DataMgr["Walnut"][self.WalnutId]
        local RewardLv = WalnutData["RewardLv"]
        local GoldMaxIndex = RewardLv[1]
        local SilverMaxIndex = GoldMaxIndex + RewardLv[2]
        for i = 1, 6 do
            local CurrentType = WalnutData["Type"][i]
            local CurrentId = WalnutData["Id"][i]
            local CurrentCount = WalnutData["Count"][i][1]
            if CurrentType == RewardType and CurrentId == RewardID and CurrentCount == RewardCount then
                if i <= GoldMaxIndex then
                     return 1
                elseif i <= SilverMaxIndex then
                    return 2
                else
                    return 3
                end
            end
        end
    end
    return 1
end

function M:InitCommonItem(Index)
    local CurRewardInfo = self.RewardList[Index]
    local Parent = self.RewardSelectWidgetList[Index]
    

    local ItemData = DataMgr[CurRewardInfo.RewardType][CurRewardInfo.RewardID]
    Parent.WalnutRewardRarity = CurRewardInfo.WalnutRewardRarity
    -- 初始化Icon的Content
    local Content = {}
    -- Content.UnitId = CurRewardInfo.RewardID
    -- -- Content.UnitName = ItemUtils.GetItemName(CurRewardInfo.RewardID, CurRewardInfo.RewardType)
    -- Content.Icon = ItemData.Icon
    -- Content.Parent = self
    -- -- Content.Parent = Parent
    -- Content.Type = CurRewardInfo.RewardType
    -- Content.Rarity = ItemData.Rarity or ItemData[CurRewardInfo.RewardType.."Rarity"] or 0
    -- Content.Count = CurRewardInfo.RewardCount
    -- Content.IsShowDetails = true
    -- -- DebugPrint("UnitId", Content.UnitId)
    -- -- DebugPrint("UnitName", Content.UnitName)
    -- -- DebugPrint("Icon", Content.Icon)
    -- -- DebugPrint("Type", Content.Type)
    -- -- DebugPrint("Rarity", Content.Rarity)
    -- -- DebugPrint("RealCount", Content.Count)
    -- Parent.Item_Reward:OnListItemObjectSet(Content)
    -- Parent.Item_Reward:SetCount(CurRewardInfo.RewardCount)
    -- if Content.Type == "Mod" then
    --     Parent.Item_Reward.Name:SetVisibility(UE4.ESlateVisibility.Collapsed)
    --     Parent.Item_Reward.Num:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    -- end
    -- Parent.Text_Hold:SetText(GText("UI_Bag_Sellconfirm_Hold"))
    Content.Id = CurRewardInfo.RewardID
    Content.ItemType = CurRewardInfo.RewardType
    Content.Rarity = ItemData.Rarity or ItemData[CurRewardInfo.RewardType.."Rarity"] or 0
    Content.Icon = ItemData.Icon
    Content.Parent = self
    Content.Count = CurRewardInfo.RewardCount
    Content.IsShowDetails = true
    Parent.Item_Reward:CreateWidgetNew("ComItemUniversalL")
    Parent.Item_Reward:Init(Content)
    if Content.Type == "Mod" then
        Parent.Item_Reward.ItemName:SetVisibility(UE4.ESlateVisibility.Collapsed)
        Parent.Item_Reward.Count:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    Parent.Text_Hold:SetText(GText("UI_Bag_Sellconfirm_Hold"))

    -- 初始化奖励品质
    local Img = nil
    if CurRewardInfo.WalnutRewardRarity == 1 then
        ---@type UTextBlock
        local TextBlock = NewObject(UTextBlock, self)
        TextBlock:SetText("Ⅰ")
        TextBlock:SetColorAndOpacity(self.ColorAndOpacities[1])
        TextBlock:SetFont(self.Fonts[1])
        Parent.Slot_Level:SetContent(TextBlock)
        Img = LoadObject('/Game/UI/Texture/Static/Image/Walnut/T_Walnut_Bg04.T_Walnut_Bg04')
    elseif CurRewardInfo.WalnutRewardRarity == 2 then
        ---@type UTextBlock
        local TextBlock = NewObject(UTextBlock, self)
        TextBlock:SetText("Ⅱ")
        TextBlock:SetColorAndOpacity(self.ColorAndOpacities[2])
        TextBlock:SetFont(self.Fonts[2])
        Parent.Slot_Level:SetContent(TextBlock)
        Img = LoadObject('/Game/UI/Texture/Static/Image/Walnut/T_Walnut_Bg05.T_Walnut_Bg05')
    else
        ---@type UTextBlock
        local TextBlock = NewObject(UTextBlock, self)
        TextBlock:SetText("Ⅲ")
        TextBlock:SetColorAndOpacity(self.ColorAndOpacities[3])
        TextBlock:SetFont(self.Fonts[3])
        Parent.Slot_Level:SetContent(TextBlock)
        Img = LoadObject('/Game/UI/Texture/Static/Image/Walnut/T_Walnut_Bg06.T_Walnut_Bg06')
    end
    if IsValid(Img) then
        Parent.Bg:SetBrushResourceObject(Img)
    end

    -- 初始化持有数
    local HoldNum = 0
    local PlayerAvatar = GWorld:GetAvatar()
    if (PlayerAvatar ~= nil) then
        local StuffServerData = nil
        if CurRewardInfo.RewardType == "Weapon" then
            StuffServerData = PlayerAvatar.Weapons[CurRewardInfo.RewardID]
        elseif CurRewardInfo.RewardType == "Mod" then
            StuffServerData = PlayerAvatar.Mods[CurRewardInfo.RewardID]
        elseif CurRewardInfo.RewardType == "CharAccessory" then
            StuffServerData = PlayerAvatar.CharAccessorys[CurRewardInfo.RewardID]
        elseif CurRewardInfo.RewardType == "Pet" then
            StuffServerData = PlayerAvatar.Pets[CurRewardInfo.RewardID]
        elseif CurRewardInfo.RewardType == "Draft" then
            StuffServerData = PlayerAvatar.Drafts[CurRewardInfo.RewardID]
        elseif CurRewardInfo.RewardType == "Resource" then
            StuffServerData = PlayerAvatar.Resources[CurRewardInfo.RewardID]
        end
        if StuffServerData then
            HoldNum = StuffServerData.Count
        end
    end
    DebugPrint("InitCommonItem HOLD NUMBER", HoldNum)
    Parent.Num_Hold:SetText(HoldNum)
end

function M:InitTeamHeads()
    self.TeamHeadTable = {}
    self.WB_Player:ClearChildren()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local MainPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    for i, PlayerState in pairs(GameState.PlayerArray) do
        local Eid = PlayerState.Eid
        local TeamHead = self:CreateWidgetNew("TeamHead")
        TeamHead.Eid = Eid
        TeamHead:Init("Walnut", PlayerState, i, true, PlayerState.Eid == MainPlayer.Eid, self)
        self.WB_Player:AddChild(TeamHead)
        -- DebugPrint("PlayerState.AvatarEidStr", PlayerState.AvatarEidStr)
        self.TeamHeadTable[PlayerState.AvatarEidStr] = TeamHead
    end
    -- 防止第一次Receive的时候UI还没创建
    self:ReceiveWalnutRewardChoose()
end

function M:BindEvents()
    self.Reward_1st.Button_Area.OnClicked:Add(self, self.OnClickReward1st)
    self.Reward_2nd.Button_Area.OnClicked:Add(self, self.OnClickReward2nd)
    self.Reward_3rd.Button_Area.OnClicked:Add(self, self.OnClickReward3rd)

    self.Reward_1st.Button_Area.OnPressed:Add(self, self.OnPressReward1st)
    self.Reward_2nd.Button_Area.OnPressed:Add(self, self.OnPressReward2nd)
    self.Reward_3rd.Button_Area.OnPressed:Add(self, self.OnPressReward3rd)

    self.Btn_Confirm.Button_Area.OnClicked:Add(self, self.OnClickButtonComfirm)
end

function M:OnClickReward1st()
    if self.SelectDone or self.CurrentSelectIndex == 1 then
        return
    end
    self:UpdateSelectedReward(1)
    self.Reward_1st:PlayAnimation(self.Reward_1st.Click)
    AudioManager(self):PlayUISound(self, "event:/ui/common/mihan_level_finish_choice_btn_click", "WalnutRewardOptionClick", nil)
    self.State = 0
    self:UpdateCommonKeys("LS", GText("UI_Controller_CheckDetails"))

    self:InterruptAutoMode()
end

function M:OnClickReward2nd()
    if self.SelectDone or self.CurrentSelectIndex == 2 then
        return
    end
    self:UpdateSelectedReward(2)
    self.Reward_2nd:PlayAnimation(self.Reward_2nd.Click)
    AudioManager(self):PlayUISound(self, "event:/ui/common/mihan_level_finish_choice_btn_click", "WalnutRewardOptionClick", nil)
    self.State = 0
    self:UpdateCommonKeys("LS", GText("UI_Controller_CheckDetails"))
    
    self:InterruptAutoMode()
end

function M:OnClickReward3rd()
    if self.SelectDone or self.CurrentSelectIndex == 3 then
        return
    end
    self:UpdateSelectedReward(3)
    self.Reward_3rd:PlayAnimation(self.Reward_3rd.Click)
    AudioManager(self):PlayUISound(self, "event:/ui/common/mihan_level_finish_choice_btn_click", "WalnutRewardOptionClick", nil)
    self.State = 0
    self:UpdateCommonKeys("LS", GText("UI_Controller_CheckDetails"))

    self:InterruptAutoMode()
end

function M:OnPressReward1st()
    if self.SelectDone then
        return
    end
    if self.CurrentSelectIndex == 1 then
        return
    end
    self.Reward_1st:PlayAnimation(self.Reward_1st.Press)
end

function M:OnPressReward2nd()
    if self.SelectDone then
        return
    end
    if self.CurrentSelectIndex == 2 then
        return
    end
    self.Reward_2nd:PlayAnimation(self.Reward_2nd.Press)
end

function M:OnPressReward3rd()
    if self.SelectDone then
        return
    end
    if self.CurrentSelectIndex == 3 then
        return
    end
    self.Reward_3rd:PlayAnimation(self.Reward_3rd.Press)
end

function M:OnClickButtonComfirm()
    DebugPrint("OnClickButtonComfirm SelectWalnutReward", self.CurrentSelectIndex)
    local Avatar = GWorld:GetAvatar()
    Avatar:SelectWalnutReward(self:OnSelectDone(self.CurrentSelectIndex), self.CurrentSelectIndex)
end

function M:PlayClickButtonComfirmSound()
    AudioManager(self):PlayUISound(self, "event:/ui/common/mihan_level_finish_choice_btn_confirm", "WalnutRewardClickBtnConfirm", nil)
end

function M:OnSelectDone(CurrentSelectIndex)
    local CurrentSelectedReward = self.RewardSelectWidgetList[CurrentSelectIndex]
    CurrentSelectedReward:PlayAnimation(CurrentSelectedReward.Selected)
    if CurrentSelectIndex ~= 1 then
        self.Reward_1st:PlayAnimation(self.Reward_1st.Forbidden)
    end
    if CurrentSelectIndex ~= 2 then
        self.Reward_2nd:PlayAnimation(self.Reward_2nd.Forbidden)
    end
    if CurrentSelectIndex ~= 3 then
        self.Reward_3rd:PlayAnimation(self.Reward_3rd.Forbidden)
    end
    self.SelectDone = true
    self.Reward_1st.SelectDone = true
    self.Reward_2nd.SelectDone = true
    self.Reward_3rd.SelectDone = true
    self.WidgetSwitcher_Btn:SetActiveWidgetIndex(2)
end

function M:OnClickButtonRetreat()
    DebugPrint("OnClickButtonComfirm SelectWalnutReward", self.CurrentSelectIndex)
    local Params =
    {
        LeftCallbackObj = self,
        RightCallbackObj = self,
        RightCallbackFunction = self.Retreat

    }
    UIManager(self):ShowCommonPopupUI(100141, Params)
end

function M:Retreat()
    local Avatar = GWorld:GetAvatar()
    Avatar:ExitBattle(true)
end

function M:UpdateSelectedReward(Index)
    DebugPrint("Walnut_Reward UpdateSelectedReward: ", Index)
    if self.CurrentSelectIndex then
        local CurrentSelectedReward = self.RewardSelectWidgetList[self.CurrentSelectIndex]
        self:InitSelectedReward(CurrentSelectedReward)
    end
    self.CurrentSelectIndex = Index
    self:AddTimer(0.1, function()
        self.RewardSelectWidgetList[Index].WidgetSwitcher_State:SetActiveWidgetIndex(1)
    end, false, 0, "UpdateRewardState")
    self.RewardSelectWidgetList[Index].IsSelected = true
end

function M:InitSelectedReward(RewardSelectWidget)
    if self.UpdateRewardState then
        self:RemoveTimer("UpdateRewardState")
    end
    RewardSelectWidget.WidgetSwitcher_State:SetActiveWidgetIndex(0)
    RewardSelectWidget:PlayAnimation(RewardSelectWidget.UnHover)
    RewardSelectWidget:PlayAnimation(RewardSelectWidget.Normal)
    RewardSelectWidget.IsSelected = false
end

function M:StartCountDown()
    self:AddTimer(0.1, self.WalnutRewardCountDown, true, 0, "WalnutRewardCountDown")
end

function M:WalnutRewardCountDown()
    local CurrentCountDown = self:GetRemainWalnutRewardTime()
    if CurrentCountDown < 0 then
        DebugPrint("WalnutRewardCountDown < 0 Close WalnutReward", CurrentCountDown)
        self:RemoveTimer("WalnutRewardCountDown")
        self:Close()
    end
    self.Text_CountDown:SetText(string.format("%d", math.floor(CurrentCountDown)))
    if CurrentCountDown < 1 then
        self:RemoveTimer("WalnutRewardCountDown")
    end
end

function M:FinishStandNoWalnutTips()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    GameMode:OnClientSelectedWalnutReward_StandAlone()
    self:RemoveTimer("StandaloneNoWalnut")
end

function M:GetRemainWalnutRewardTime()
    local GameState = UGameplayStatics.GetGameState(self)
    local Info = GameState.ClientTimerStruct:GetTimerInfo("ShowWalnutReward")
    local WalnutRewardVoteTime = Info.Time - (GameState.ReplicatedRealTimeSeconds - Info.RealTimeSeconds)
    return WalnutRewardVoteTime
end

function M:ReceiveWalnutRewardChoose()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local WalnutRewarPlayer = GameState.WalnutRewardPlayer:ToTable()
    for AvatarEidStr, Select in pairs(WalnutRewarPlayer) do
        DebugPrint("ReceiveWalnutRewardChoose AvatarEidStr", AvatarEidStr, "Select", Select)
        if self.TeamHeadTable[AvatarEidStr] == nil then
            goto continue
        end
        local TeamHead = self.TeamHeadTable[AvatarEidStr]
        TeamHead:SetIsChosenState(Select)
        ::continue::
    end
end

function M:ChangeSelectedHead(TeamHead)
    if TeamHead == self.SelectedHead then
        return
    end
    if self.SelectedHead then
        self.SelectedHead:OnReleaseSelected(true)
    end
    self.SelectedHead = TeamHead
end

function M:InitCommonKey()
    if not self.Panel_Key_GamePad then
        return
    end
    self.Panel_Key_GamePad:ClearChildren()
    for i = 1, 2 do
        local MenuKeyWidget = UIManager(self):_CreateWidgetNew("ComKeyTextDesc")
        -- local MenuKeyWidget = Utils.UIManager(self):CreateWidget('/Game/UI/WBP/Common/Key/WBP_Com_KeyTextDesc.WBP_Com_KeyTextDesc', false)
        self.Panel_Key_GamePad:AddChild(MenuKeyWidget)
    end
    self.Panel_Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.State = 0
    self:UpdateCommonKeys()
end

function M:UpdateCommonKeys(...)
    if not self.Panel_Key_GamePad then
        return
    end
    if self.NoWalnut then
        return
    end
    local Param = {...}
    for i = 0, 1 do
        local CurerentKey = self.Panel_Key_GamePad:GetChildAt(i)
        if CurerentKey then
            DebugPrint("TEST CurerentKey")
            if Param[i * 2 + 1] ~= nil and Param[i * 2 + 2] ~= nil then
                CurerentKey:SetVisibility(UE4.ESlateVisibility.Visible)
                CurerentKey:CreateCommonKey({
                    KeyInfoList = {
                        {
                            Type = "Img",
                            ImgShortPath = Param[i * 2 + 1],
                        }
                    },
                    Desc = Param[i * 2 + 2]
                })
            else
                CurerentKey:SetVisibility(UE4.ESlateVisibility.Collapsed)
            end
        end
    end
end

function M:GamePadToPC()
    if not self.Panel_Key_GamePad then
        return
    end
    self.Panel_Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self:SetItemRewardVisibility(true)
    self.State = 0
end

-- State = 0: 选中奖励
-- self:UpdateCommonKeys("LS", GText("UI_Controller_CheckDetails"))
-- State = 1: 未选中奖励
-- self:UpdateCommonKeys("A", GText("UI_Tips_Ensure"), "LS", GText("UI_Controller_CheckDetails"))
-- State = 2: 未选中队员
-- self:UpdateCommonKeys("A", GText("UI_Controller_CheckPlayer"))
-- State = 3: 选中队员
-- self:UpdateCommonKeys("B", GText("UI_Tips_Close"))
-- State = 4 打开奖励Tips
-- self:UpdateCommonKeys()
function M:PCToGamePad()
    if not self.Panel_Key_GamePad then
        return
    end
    self.Panel_Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    if not self.IsStandAlone then
        self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    if not self.State then
        self:UpdateCommonKeys("LS", GText("UI_Controller_CheckDetails"))
        self.State = 0
    end
    self:SetItemRewardVisibility(false)
end

function M:InitGameInputMode()
    if not self.Panel_Key_GamePad then
        return
    end
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.IsFocusInit = false
    if (IsValid(self.GameInputModeSubsystem)) then
        self.Key_GamePad:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "RS",
                }
            }
        })
        self:InitCommonKey()
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    DebugPrint("RefreshOpInfoByInputDevice",CurInputDevice, CurGamepadName)
    --- 输入设备切换通知
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        self:GamePadToPC()
    else
        self:PCToGamePad()
        self.State = 0
        self.Reward_1st.Button_Area:SetFocus()
        if self.NoWalnut then
            self.WB_Player:GetChildAt(0).Head_Team:SetFocus()
        end
    end
    self.CurInputDeviceType = CurInputDevice

    self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then  
        if self.State == 0 or self.State == 1 then
            if (InKeyName == "Gamepad_FaceButton_Top") then
                self:OnClickButtonComfirm()
                IsEventHandled = true
            elseif (InKeyName == "Gamepad_LeftThumbstick") then
                self.State = 4
                self:SetItemRewardVisibility(true)
                if self.Reward_1st.Button_Area:HasAnyUserFocus() or self.Reward_1st:HasAnyUserFocus() then
                    self.Reward_1st.Item_Reward:OpenItemMenu()
                elseif self.Reward_2nd.Button_Area:HasAnyUserFocus() or self.Reward_2nd:HasAnyUserFocus() then
                    self.Reward_2nd.Item_Reward:OpenItemMenu()
                elseif self.Reward_3rd.Button_Area:HasAnyUserFocus() or self.Reward_3rd:HasAnyUserFocus() then
                    self.Reward_3rd.Item_Reward:OpenItemMenu()
                end
                self:SetItemRewardVisibility(false)
                self:UpdateCommonKeys()
                self.Btn_Confirm:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
                self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
                IsEventHandled = true
            elseif (InKeyName == "Gamepad_RightThumbstick") then -- 查看队伍详情
                if not self.IsStandAlone then
                    self.State = 2
                    local TeamInfo = self.WB_Player:GetChildAt(0)
                    TeamInfo.Head_Team:SetFocus()
                    self.Btn_Confirm:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
                    self:UpdateCommonKeys("A", GText("UI_Controller_CheckPlayer"), "B", GText("UI_Tips_Close"))
                    self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
                    IsEventHandled = true
                end
            end
        elseif self.State == 2 then
        -- 组队模式
            if (InKeyName == "Gamepad_FaceButton_Right") or (InKeyName == "Gamepad_RightThumbstick") then
                self.State = 0
                self:UpdateCommonKeys("LS", GText("UI_Controller_CheckDetails"))
                self.Reward_1st.Button_Area:SetFocus()
                self.Btn_Confirm:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
                self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                IsEventHandled = true
            end
        elseif self.State == 3 then
            if (InKeyName == "Gamepad_FaceButton_Right") then
                self.State = 2
                local TeamInfo = self.WB_Player:GetChildAt(self.RecordCurrentTeamMember)
                TeamInfo.Head_Team:SetFocus()
                self:UpdateCommonKeys("A", GText("UI_Controller_CheckPlayer"), "B", GText("UI_Tips_Close"))
                IsEventHandled = true
            end
        end
    else
        --PC
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

function M:SetItemRewardVisibility(HitTest)
    if HitTest then
        self.Reward_1st.Item_Reward:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Reward_2nd.Item_Reward:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Reward_3rd.Item_Reward:SetVisibility(UE4.ESlateVisibility.Visible)
    else
        self.Reward_1st.Item_Reward:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        self.Reward_2nd.Item_Reward:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        self.Reward_3rd.Item_Reward:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    end
end 

function M:OnAddedToFocusPath(InFocusEvent)
    self:UpdateCommonKeys("A", GText("UI_Tips_Ensure"), "LS", GText("UI_Controller_CheckDetails"))
end

function M:RecordCurrentTeamMemberFocus()
    for i = 0, 3 do
        if self.WB_Player:GetChildAt(i) then
            local TeamInfo = self.WB_Player:GetChildAt(i)
            if TeamInfo:HasFocusedDescendants() then
                self.RecordCurrentTeamMember = i
                return
            end
        end
    end
    self.RecordCurrentTeamMember = 0
end

-- 首次通关松露核桃教学本，弹引导
function M:CheckRunSystemGuide()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    if not self.WalnutId then return end

    -- 仅单机
    if not self.IsStandAlone then
        return
    end
    -- 核桃是松露的
    if not (self.WalnutId == SONGLU_WALNUT_ID) then
        return
    end
    -- 第一次开
    local ConsumeCount = Avatar.Walnuts.ConsumeRecord[self.WalnutId] or 0
    if ConsumeCount > 0 then
        return
    end

    DebugPrint("ljl@ RunSystemGuide", SYSTEM_GUIDE_ID)
    SystemGuideManager:RunGuideById(SYSTEM_GUIDE_ID)
end

function M:CheckIsAutoMode()
    -- 服务器记录是否自动委托
    local Avatar = GWorld:GetAvatar()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if not Avatar then return end
    local DungeonId = GWorld.GameInstance:GetCurrentDungeonId()
    local IsAutoMode = Avatar.Dungeons[DungeonId].AutoProgress
    local Progress = GameState.DungeonProgress or 0
    if IsAutoMode and ( IsAutoMode + 1 >= Progress ) and IsAutoMode ~= 0 then
        local AutoCheckTime
        if DataMgr.GlobalConstant.AutoRoundsCheckTime then
            AutoCheckTime = DataMgr.GlobalConstant.AutoRoundsCheckTime.ConstantValue
        else
            AutoCheckTime = 5
        end
        self.CheckIsAutoModeTimer = self:AddTimer(1, function()
            if AutoCheckTime <= 0 then
                self:RemoveTimer(self.CheckIsAutoModeTimer)
                self:OnClickButtonComfirm()
                return
            end
            self.Btn_Confirm:SetText(string.format(GText("UI_Auto_Round_TicketConfirm_Time"), AutoCheckTime))
            AutoCheckTime = AutoCheckTime - 1
        end, true, 0, "CheckIsAutoModeTimer")
    end
end

function M:InterruptAutoMode()
    if self.CheckIsAutoModeTimer then
        self:RemoveTimer(self.CheckIsAutoModeTimer)
        self.Btn_Confirm:SetText(GText("UI_CONFIRM_SELECTION"))
        DebugPrint("ayff test InterruptAutoMode in reward choose")
    end
end

return M
