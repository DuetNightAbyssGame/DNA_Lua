--
-- DESCRIPTION
-- 主城界面功能入口按钮
-- @COMPANY **
-- @AUTHOR JuleszzZ
-- @DATE ${date} ${time}
--

require "UnLua"

local EMCache = require "EMCache.EMCache"
local TimeUtils = require "Utils.TimeUtils"
--local GMVariable = require "BluePrints.UI.GMInterface.GMVariable"
--local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
local UIUtils = require "Utils.UIUtils"
local ReasoningUtils = require "BluePrints.UI.WBP.DetectiveMinigame.ReasoningUtils"

local WBP_HomeBaseMain_Item_C = Class({"BluePrints.UI.BP_EMUserWidget_C",
 "BluePrints.Common.TimerMgr"})
WBP_HomeBaseMain_Item_C._components = {
    "BluePrints.UI.UI_PC.Menu.Reddot.MainUIItem_ReddotTree_Component",
}

function WBP_HomeBaseMain_Item_C:Construct()
    self.Btn_top.OnClicked:Add(self, self.OnBtnClick)
    self.Btn_top.OnHovered:Add(self, self.OnBtnHovered)
    self.Btn_top.OnUnhovered:Add(self, self.OnBtnUnhovered)
    if not  self.ConditionMap then
        self.ConditionMap={}
    end
    EventManager:AddEvent(EventID.ConditionComplete, self, self.OnConditionComplete)
end

function WBP_HomeBaseMain_Item_C:OnConditionComplete(ConditionId)
    if self.ConditionMap[ConditionId] then
        self:UpdateGuidePoint()
    end

end

function WBP_HomeBaseMain_Item_C:RefreshNewClueUI()
    if not self.IsBtnTask then
        return
    end
    if ReasoningUtils:IsAllClueHasNewClue() then
        -- self.NewClue = UIManager(self):_CreateWidgetNew('CommonHudBubble')
        -- local ConfigData = {
        --         IconPath = "",
        --         Text = "Minigame_Textmap_100303",
        --         ColorType = 4,
        --         Arrow = 10,
        --     }
        --     self.NewClue:Init(ConfigData)
        --     self.NewClue:PlayInAnimation()

        if not self.NewClue then
            self.NewClue = UIManager(self):_CreateWidgetNew('ReasoningBubble')
        end
        if self.NewClue then
            self.NewClue:ShowInfo()
            self.Pos_Bubble_L:AddChild(self.NewClue)
        end
    else
        if self.NewClue then
            self.Pos_Bubble_L:ClearChildren()
        end
    end
end

function WBP_HomeBaseMain_Item_C:RefreshNewTheaterUI()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local ConditionId = 8029 -- 策划说的写死
    local PreQuestId = 400111 -- 策划说的写死
    local QuestChain = Avatar.QuestChains[PreQuestId]
    if not QuestChain then
        DebugPrint("ayff 剧院tips配置了一个不存在的任务")
        return
    end
    local isUnlock = ConditionUtils.CheckCondition(Avatar, ConditionId)
    if not isUnlock or not QuestChain:IsFinish() then
        return
    end
    self.NewTheaterBubble = UIManager(self):_CreateWidgetNew('CommonHudBubble')
    self.Pos_Bubble_L:AddChild(self.NewTheaterBubble)
    local ConfigData = {
            IconPath = "/Game/UI/Texture/Dynamic/Atlas/Interactive/T_Interactive_TheaterOnline.T_Interactive_TheaterOnline",
            Text = "UI_Theater_Waiting",
            ColorType = 0,
            Arrow = 1,
        }
    self.NewTheaterBubble:Init(ConfigData)
    self.NewTheaterBubble:PlayInAnimation()
    self.NewTheaterBubble:SetIconColor(true)
    -- local OverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(self.NewTheaterBubble)
    -- OverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Center)
    -- OverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Center)

    local HideTheaterBubble = function()
        self.NewTheaterBubble:PlayOutAnimation()
        if self:IsExistTimer("HideTheaterBubble") then
            self:RemoveTimer("HideTheaterBubble")
        end
    end
    self:AddTimer(3, HideTheaterBubble,false,0.1,"HideTheaterBubble",true)
end

function WBP_HomeBaseMain_Item_C:OnListItemObjectSet(Content)
    self.CurContent = Content
    self.CurContent.SelfWidget = self
    self:ReddotTreePlugOut()
    self:LoadImage()
    self:UpdateGuidePoint()
    self:InitListenEvent()
    if Content.bForbidReddot then 
        self:SetRedDot(false, false, nil)
    end
end


function WBP_HomeBaseMain_Item_C:UpdateGuidePoint()
    local GuidePointArray={}
    local Avatar = GWorld:GetAvatar()
    for _, GuidePointInfo in pairs(DataMgr.MainUIGuidePoint) do
        if GuidePointInfo.EnterId==self.CurContent.BtnId then
           table.insert(GuidePointArray, GuidePointInfo)
        end
    end
    local CurrentPointShow=false
    for _, GuidePointInfo in pairs(GuidePointArray) do
           if GuidePointInfo then
            local TempShow=false
            if GuidePointInfo.ShowCondition then
                TempShow=ConditionUtils.CheckCondition(Avatar,GuidePointInfo.ShowCondition)
                DebugPrint("@@@Updateguidepoint Home Base main EnterId,ShowCondition",GuidePointInfo.EnterId,TempShow)
                self.ConditionMap[GuidePointInfo.ShowCondition]=true
            end
            if GuidePointInfo.HideCondition then
                local NotShowCondition=ConditionUtils.CheckCondition(Avatar,GuidePointInfo.HideCondition)
                DebugPrint("@@@Updateguidepoint Home Base main EnterId,HideCondition",GuidePointInfo.EnterId,NotShowCondition)
                if NotShowCondition then
                    TempShow=false
                end
                self.ConditionMap[GuidePointInfo.HideCondition]=true
            end
            if not CurrentPointShow then
                DebugPrint("@@@Updateguidepoint Home Base main UpdateCurrentShow EnterId,CurrentPointShow",CurrentPointShow)
                CurrentPointShow=TempShow
            end
        end
    end
    DebugPrint("@@@Updateguidepoint Home Base main Update Final Current Show,CurrentPointShow",CurrentPointShow)
    if CurrentPointShow then
        self.Icon_GuidePoint:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Icon_GuidePoint:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end


function WBP_HomeBaseMain_Item_C:InitListenEvent()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function WBP_HomeBaseMain_Item_C:ClearListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    end
end

function WBP_HomeBaseMain_Item_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end

    self.CurInputDeviceType = CurInputDevice

    local IsUseGamePad = CurInputDevice == ECommonInputType.Gamepad
    self:InitWidgetInfoInGamePad(IsUseGamePad)
end

function WBP_HomeBaseMain_Item_C:InitWidgetInfoInGamePad(IsUseGamePad)
    if self.Key_GamePad then
        self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if not IsUseGamePad then
        return
    end
    local BtnInfo = DataMgr.MainUI
    local Id = self.CurContent.BtnId
    local ActionName = BtnInfo[Id].ActionName
    -- if ActionName then
    -- 目前只有肉鸽显示
    if ActionName == "RougeOpenBag" then
        local GamePadInfo = DataMgr.GamepadMap
        local GamepadLayout = EMCache:Get("GamepadLayout")
        if not GamepadLayout then
            GamepadLayout = tonumber(DataMgr.Option["GamepadPreset"].DefaultValue)
        end
        if GamePadInfo[ActionName] and GamePadInfo[ActionName].GamepadIcon then
            local GamepadKeys = UIUtils.GetIconListByActionName(ActionName)
            -- 目前蓝图结构不支持手柄组合键形式 若为多个，直接取第一个
            local ImgShortPath = GamepadKeys[1]
            self.Key_GamePad:CreateCommonKey({
                KeyInfoList={
                    {
                        Type = "Img",
                        ImgShortPath = ImgShortPath,
                    },
                },
            })
        end
        self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
end

function WBP_HomeBaseMain_Item_C:RebindClickEvent(Owner, Callback)
    if Owner and Callback then
        self.Btn_top.OnClicked:Clear()
        self.Btn_top.OnClicked:Add(Owner, Callback)
    end
end

function WBP_HomeBaseMain_Item_C:LoadImage(MainUIId)
    self.Common_Item_Subsize_New_PC:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Reddot:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Reddot_Num:SetVisibility(UE4.ESlateVisibility.Collapsed)
    local BtnInfo = DataMgr.MainUI
    local Id = MainUIId==nil and self.CurContent.BtnId or MainUIId
    local Icon = BtnInfo[Id].Icon
    if not UIUtils.IsMenuWorld() and BtnInfo[Id].DungeonIcon then
        Icon=BtnInfo[Id].DungeonIcon
    end
    if Icon == nil then
        Icon = "/Game/UI/Texture/Dynamic/Atlas/Entrance/T_Entrance_Armory.T_Entrance_Armory"
    end
    local ImageResource = LoadObject(Icon)
    local VSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.VerticalBox_0)
    local Anchors = FAnchors()
    if Id == CommonConst.ArmoryEnterId then
        self:UpdateArmoryIcon()
        VSlot:SetAlignment(FVector2D(1, 0))
        Anchors.Minimum = FVector2D(1,1)
        Anchors.Maximum = FVector2D(1,1)
        VSlot:SetAnchors(Anchors)
    else 
        VSlot:SetAlignment(FVector2D(0.5, 0))
        Anchors.Minimum = FVector2D(0.5,1)
        Anchors.Maximum = FVector2D(0.5,1)
        VSlot:SetAnchors(Anchors)
        if ImageResource ~= nil then
            self:SetButtonStyle(ImageResource)
        end
    end
    if Id == CommonConst.GachaEnterId then
        self:RefreshTimeLimitResource()
    end
    local ActionName = BtnInfo[Id].ActionName
    self.Name:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.IsHaveKey = false
    self.Switcher:SetActiveWidgetIndex(0)
    local KeyText = CommonUtils:GetActionMappingKeyName(ActionName)
    if ActionName and KeyText ~= "" then
        self.IsHaveKey = true
        self.Common_Key_Hud_PC:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Text",
                    Text = KeyText
                }
            },
        })
        self.Common_Key_Hud_PC:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        local IconList = UIUtils.GetIconListByActionName(ActionName)
        self.HasGamePadTips = IconList and IconList[1] == "Right" and #IconList > 1
        if self.HasGamePadTips and self.Common_Key_Hud_Gamepad then
            self.Common_Key_Hud_Gamepad:CreateCommonKey({
                KeyInfoList={
                    {
                        Type = "Img",
                        ImgShortPath = IconList[#IconList]
                    }
                },
            })
        end
    else
        self.Common_Key_Hud_PC:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    local Platform = CommonUtils.GetDeviceTypeByPlatformName(self)  --移动端还是PC端
    if Platform == 'Mobile' then
        self.Common_Key_Hud_PC:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self.Name:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Name:SetText(GText(BtnInfo[Id].Name))
    self.Switcher:SetVisibility(UE4.ESlateVisibility.Collapsed)
    --if (GMVariable.IsInDebugMode) then
    --    GMFunctionLibrary.SetShowScreenMessage(GMVariable.EnableScreenMessage)
    --end
    

    --- 红点树接入
    self:ReddotTreePlugIn(BtnInfo[Id])
end


function WBP_HomeBaseMain_Item_C:Destruct()
    EventManager:RemoveEvent(EventID.ConditionComplete, self)
    self:ReddotTreePlugOut()
    --红点树接入前过度
    local Avatar = GWorld:GetAvatar()
    if Avatar  then
        for _, SystemInfo in ipairs(DataMgr.MainUI) do
            if SystemInfo.UIUnlockRuleName then
                local UIUnlockRule = DataMgr.UIUnlockRule
                local UIUnlockRuleId = UIUnlockRule[SystemInfo.UIUnlockRuleName].UIUnlockRuleId
                if self.UnlockRuleNames then
                    Avatar:UnBindOnUIFirstTimeUnlock(UIUnlockRuleId, self.UnlockRuleNames[SystemInfo.UIUnlockRuleName])
                end
            end
        end
    end
    self:ClearListenEvent()
end

function WBP_HomeBaseMain_Item_C:UpdateTaskBtnRedDot()
    local GetRet = function ()
        local NewQuestChainTable = EMCache:Get("NewQuestChainTable", true) or {}
        local NewQuestReddotSetCache = EMCache:Get("NewQuestReddotSet", true) or {}
        if IsEmptyTable(NewQuestReddotSetCache) == false then
            for _, IsNew in pairs(NewQuestReddotSetCache) do
                if IsNew then
                    return true, true
                end
            end
        end
        if IsEmptyTable(NewQuestChainTable) then
            return true, true
        else
            for _, IsNew in pairs(NewQuestChainTable) do
                if IsNew then
                    return true, true
                end
            end
        end
        return false, false
    end
    local IsNew, OtherReddot = GetRet()
    self:SetRedDot(IsNew, OtherReddot, nil)
    self:RefreshNewClueUI()
end

function WBP_HomeBaseMain_Item_C:UpdateRedDot()
end

function WBP_HomeBaseMain_Item_C:SetRedDot(IsNew,Upgradeable,OtherReddot,Count)
    if not IsValid(self) then return end
    if type(Count) == "number" and  Count<=0 then Count = "0" end
    self.Common_Item_Subsize_New_PC:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if self.bForceInvisible and (IsNew or Upgradeable or (Count and Count~="0")) then 
        self.Reddot_Num:SetVisibility(UIConst.VisibilityOp.Collapsed)
        Traceback(ErrorTag, "Esc红点已经强制不可见了，走到这里肯定有问题的，最终容错已经做了,但还是埋个桩看看是哪里捣鬼")
        return
    end
    if IsNew then
        self.Common_Item_Subsize_New_PC:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        return
    end
    if(Upgradeable)then
        self.Reddot:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if OtherReddot == 3 then
        if Count == "0" then
            self.Reddot_Num:SetVisibility(UIConst.VisibilityOp.Collapsed)
        else
            self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.Reddot_Num:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            self.Reddot_Num:SetNum(Count)
        end
    else
        self.Reddot_Num:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function WBP_HomeBaseMain_Item_C:OnBtnClick()
    if self.CurContent == nil then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_system_entrance", nil, nil)
    if self.CurContent==nil then
        return
    end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode and GameMode.EMGameState.GameModeType == "Trial" then
        GameMode:TriggerDungeonComponentFun("ShowArmory")
    else
        UIUtils.OpenSystem(self.CurContent.BtnId)
        CommonUtils:CloseGuideTouchIfExist(self) -- todo 临时处理,刷新ListView的时候Btn_top.OnClicked会被清空
    end
    
end

function WBP_HomeBaseMain_Item_C:OnBtnHovered()
    local Platform = CommonUtils.GetDeviceTypeByPlatformName(self)  --移动端还是PC端
    if Platform == 'Mobile' then
        self.Switcher:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end
    if self.IsBubblePlaying then
        if self:IsExistTimer("HideBubble") then
            self:RemoveTimer("HideBubble")
        end
    end
    self.Switcher:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self:StopAnimation(self.HoverOut)
    self:PlayAnimation(self.Hover)
end

function WBP_HomeBaseMain_Item_C:OnBtnUnhovered()
    local Platform = CommonUtils.GetDeviceTypeByPlatformName(self)  --移动端还是PC端
    self.Switcher:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if Platform == 'Mobile' then
        self.Switcher:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.HoverOut)
    if self.IsBubblePlaying then
        self:HideBubble(self.BubbleEndTime or 3)
    end
end

function WBP_HomeBaseMain_Item_C:ShowSystemEntranceOnGamePadInput(IsShow)
    if not self.HasGamePadTips or not self.Common_Key_Hud_Gamepad then
        return
    end
    local Platform = CommonUtils.GetDeviceTypeByPlatformName(self)
    if Platform == 'Mobile' then
        self.Switcher:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Switcher:SetActiveWidgetIndex(0)
        return
    end
    if IsShow then
        self.Switcher:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Switcher:SetActiveWidgetIndex(1)
        self.Common_Key_Hud_Gamepad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Switcher:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Switcher:SetActiveWidgetIndex(0)
        self.Common_Key_Hud_Gamepad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function WBP_HomeBaseMain_Item_C:UpdateArmoryIcon()
    local Avatar = GWorld:GetAvatar()
    if(not Avatar)then
        return
    end
    local Char = Avatar.Chars[Avatar.CurrentChar]
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local CharId=Char.CharId
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameMode ~= nil and GameState ~= nil and  GameState.GameModeType == "Trial" then
        if Player then
            local Char_OldBattleInfo = Player.PlayerState:GetOldBattleInfo("Char")
            CharId= Char_OldBattleInfo.Id
        end
    end
    local CharIconPath=DataMgr.Char[CharId].EscIcon
    local CharIcon = LoadObject(CharIconPath)
    self:SetButtonStyle(CharIcon)
end

--播放限时抽卡券气泡提示，仅抽卡系统
function WBP_HomeBaseMain_Item_C:RefreshTimeLimitResource()
    self.IsBubblePlaying = false
    self.Pos_Bubble:ClearChildren()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local EndTime
    local Icon
    for key,value in pairs(DataMgr.SkinGacha) do
        for _,ResourceId in ipairs(value.GachaCostRes) do
            local ResourceInfo = DataMgr.Resource[ResourceId]
            local Count = Avatar:GetResourceNum(ResourceId)
            local TimeLimitResourceInfo = ItemUtils.GetItemLimitedInfo(ResourceId)
            if TimeLimitResourceInfo and TimeLimitResourceInfo.EndTime and Count > 0 then
                EndTime = TimeLimitResourceInfo.EndTime
                Icon = ResourceInfo.Icon
                break
            end
        end
    end
    if not EndTime then return end

    local NowTime = TimeUtils.NowTime()
    local TimeDiff = EndTime - NowTime
    local Cache = EMCache:Get("GachaBubble")
    if Cache and Cache == true then return end
    if TimeDiff > 0 and TimeDiff < CommonConst.SECOND_IN_DAY then
        self:ShowBubble(2,1,Icon)
    elseif TimeDiff >= CommonConst.SECOND_IN_DAY and TimeDiff < CommonConst.SECOND_IN_WEEKDAY then
        self:ShowBubble(1,1,Icon)
    end
end

function WBP_HomeBaseMain_Item_C:ShowBubble(ColorType,Arrow,Icon)
    if not self.HudBubbleWidget then
        self.HudBubbleWidget = UIManager(self):_CreateWidgetNew('CommonHudBubble')
    end
    self.Pos_Bubble:AddChild(self.HudBubbleWidget)
    local OverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(self.HudBubbleWidget)
    OverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Center)
    OverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Center)
    local ConfigData = {
                        IconPath = Icon,
                        Text = "UI_GachaTicket_Bubble",
                        ColorType = ColorType,
                        Arrow = Arrow,
                        }
    self.HudBubbleWidget:Init(ConfigData)
    self.HudBubbleWidget:PlayInAnimation()
    self.IsBubblePlaying = true
    EMCache:Set("GachaBubble",true)
    self:HideBubble(self.BubbleEndTime or 3)
end

function WBP_HomeBaseMain_Item_C:HideBubble(EndTime)
    if self:IsExistTimer("HideBubble") then
        self:RemoveTimer("HideBubble")
    end
    local HideBubble = function()
        self.HudBubbleWidget:PlayOutAnimation()
        self.IsBubblePlaying = false
        if self:IsExistTimer("HideBubble") then
            self:RemoveTimer("HideBubble")
        end
    end
    self:AddTimer(EndTime, HideBubble,false,0.1,"HideBubble",true)
end

function WBP_HomeBaseMain_Item_C:OnHomeBaseBtnPlayAnim(UIName,AnimationName)
    if not UIName then return end
    if not self[AnimationName] then return end
    if self.CurContent and self.CurContent.BtnId then
        local BtnInfo = DataMgr.MainUI[self.CurContent.BtnId]
        if BtnInfo.SystemUIName == UIName then
            self:PlayAnimation(self[AnimationName])
        end
    end
end

function WBP_HomeBaseMain_Item_C:OnHomeBaseeBtnShowNewClue(UIName)
    self:RefreshNewClueUI()
end

function WBP_HomeBaseMain_Item_C:InitInterface(IconPath, KeyText, Name)
    self.Common_Item_Subsize_New_PC:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Reddot:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Reddot_Num:SetVisibility(UE4.ESlateVisibility.Collapsed)
    local ImageResource = nil
    if IconPath then
        ImageResource = LoadObject(IconPath)
    end
    local VSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.VerticalBox_0)
    local Anchors = FAnchors()
    VSlot:SetAlignment(FVector2D(0.5, 0))
    Anchors.Minimum = FVector2D(0.5,1)
    Anchors.Maximum = FVector2D(0.5,1)
    VSlot:SetAnchors(Anchors)
    if ImageResource ~= nil then
        self:SetButtonStyle(ImageResource)
    end
    self.Switcher:SetActiveWidgetIndex(0)
    if KeyText then
        self.IsHaveKey = true
        self.Common_Key_Hud_PC:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Text",
                    Text = KeyText
                }
            },
        })
        self.Common_Key_Hud_PC:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.IsHaveKey = false
        self.Common_Key_Hud_PC:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if Name then
        self.Name:SetText(GText(Name))
        self.Name:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.Name:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    local Platform = CommonUtils.GetDeviceTypeByPlatformName(self)  --移动端还是PC端
    if Platform == 'Mobile' then
        self.Common_Key_Hud_PC:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self.Switcher:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

AssembleComponents(WBP_HomeBaseMain_Item_C)
return WBP_HomeBaseMain_Item_C