--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type LevelMap_Convey_Widget_PC_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Construct()
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(UGameplayStatics.GetPlayerController(self, 0))
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnUpdateUIStyleByInputTypeChange) 
end

function M:Destruct()
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnUpdateUIStyleByInputTypeChange) 
end

function M:InitialTempleAndPartyInfo(Temples, TelepointIcon, RegionIcon)
    -- Temples包含了神庙和派对的Id
    if #Temples >= 4 then
        error("WBP_Map_Convey中要加载的神庙/派对数量超过预设蓝图数")
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        error("Avatar is nil")
    end
    for i = 1, #Temples do
        self["WBP_LevelMap_TempleConveyItem_"..i]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        local Callback = function()
            self.WildMap:ClosePanel()
        end
        local TempleInfo = {Name = "", PassInfo = "", TempleId = Temples[i], Star = 0, ConditionId = 0, CloseFunc = Callback}
        local DungeonInfo = DataMgr.Dungeon[Temples[i]]
        if not DungeonInfo then
            self.Group_Temple:SetVisibility(ESlateVisibility.Collapsed)
			error("Region表中配置了不存在的神庙ID，错误的神庙ID：" .. Temples[i])
		end

        local Conditions = DungeonInfo.Condition
        local CompleteCondition = true
        if Conditions and #Conditions > 0 then
            CompleteCondition = ConditionUtils.CheckCondition(Avatar, Conditions[1])
            TempleInfo.ConditionId = Conditions[1]
        end

        local Name = GText(DungeonInfo.DungeonName)
        TempleInfo.Name = Name

        TempleInfo.IsStarLevel = false
        local Temple = DataMgr.Temple[Temples[i]] or DataMgr.Party[Temples[i]]
        if #Temple.RewardId > 1 then
            TempleInfo.IsStarLevel = true
        end

        if not Temple.RewardId then
            TempleInfo.PassInfo = "NoConfigReward" -- 未配置奖励
        elseif not Avatar.Dungeons[Temples[i]] then
			TempleInfo.PassInfo = self:CheckStatus(i, Temples)
        elseif not Avatar.Dungeons[Temples[i]].IsPass then
            TempleInfo.PassInfo = "NoPass" -- 未通关
        elseif #Temple.RewardId == 1 then
            TempleInfo.PassInfo = "PassNoStar" -- 无星级关卡通关
        else
            TempleInfo.PassInfo = "PassStar" -- 星级关卡通关
            TempleInfo.Star = Avatar.Dungeons[Temples[i]].MaxStar
        end

        if Avatar.InSpecialQuest and TempleInfo.PassInfo ~= "Lock" then
            TempleInfo.PassInfo = "InSpecialQuest" -- 处于特殊任务中
        end
        if not CompleteCondition and TempleInfo.PassInfo ~= "Lock" then
            TempleInfo.PassInfo = "NoCompleteCondition" -- 未达成条件
        end

        self["WBP_LevelMap_TempleConveyItem_"..i]:ShowTempleInfo(TempleInfo)
        self["WBP_LevelMap_TempleConveyItem_"..i]:SetNavigationRuleBase(EUINavigation.Down, i == #Temples and EUINavigationRule.Stop or EUINavigationRule.Escape)
    end
    for i = #Temples + 1, 3 do
        self["WBP_LevelMap_TempleConveyItem_"..i]:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.Img_GuidePoint_Icon:SetBrushFromTexture(TelepointIcon)
    if RegionIcon then
        local Icon = LoadObject(RegionIcon)
        if Icon then
            self.Icon_Camp:SetBrushFromTexture(Icon)
        end
    end
    if #Temples > 0 then
        table.insert(self.WildMap.MainMap.BackGamePadKey, 1, {
            KeyInfoList={
                {
                    Type="Img",
                    ImgShortPath="RS"
                }
            },
            Desc = GText("UI_RegionMap_SeeTemple"),
        })
        self.WildMap.MainMap:UpdateWildMapKeys()
    end
end

function M:InitWildMap(WildMap)
    self.WildMap = WildMap
end

function M:CheckStatus(i, Temples)
    -- Avatar中没有当前神庙的信息，判断一下是没进过还是未解锁
    local PassInfo = nil
    if i == 1 then
        PassInfo = "NoEnterInfo" -- 未进入
    else
        local Avatar = GWorld:GetAvatar()
        if not Avatar.Dungeons[Temples[i-1]] then
            PassInfo = "Lock" -- 未解锁
        elseif not Avatar.Dungeons[Temples[i-1]].IsPass then
            PassInfo = "Lock" -- 未解锁
        else
            PassInfo = "NoEnterInfo" -- 未进入
        end
    end
    return PassInfo
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
        local ActiveWidget = self.Switch_Button:GetActiveWidget()
        if ActiveWidget.Btn_Click then--Todo:搜打撤复用代码但是通用控件却没复用，也没人接控件
            ActiveWidget.Btn_Click.OnClicked:Broadcast()
        else
            ActiveWidget:OnBtnClicked()
        end
        return UWidgetBlueprintLibrary.Handled()
    elseif InKeyName == "Escape" or InKeyName == UIConst.GamePadKey.FaceButtonRight then
        if self.Focused then
            self:RemoveKey()
            self.WildMap:ClosePanel()
        else
            self.Group_Temple:SetVisibility(ESlateVisibility.HitTestInvisible)
            self:SetFocus()
        end
        -- return UWidgetBlueprintLibrary.Handled()
    elseif InKeyName == UIConst.GamePadKey.RightThumb then
        if self.Group_Temple:GetVisibility() == ESlateVisibility.SelfHitTestInvisible
        or self.Group_Temple:GetVisibility() == ESlateVisibility.HitTestInvisible then
            self.Group_Temple:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.WBP_LevelMap_TempleConveyItem_1:SetFocus()
            self.Focused = false
        end
    end
    return UWidgetBlueprintLibrary.Handled()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    self.Focused = true
    return UWidgetBlueprintLibrary.Handled()
end

function M:RemoveKey()
    if self.WildMap.MainMap.BackGamePadKey and self.WildMap.MainMap.BackGamePadKey[1].KeyInfoList[1].ImgShortPath == "RS" then
        table.remove(self.WildMap.MainMap.BackGamePadKey,1)
        self.WildMap.MainMap:UpdateWildMapKeys()
    end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    if self.Group_Temple:GetVisibility() == ESlateVisibility.Collapsed then
        return
    end
    self.Group_Temple:SetVisibility(CurInputDevice == ECommonInputType.Gamepad and ESlateVisibility.HitTestInvisible or ESlateVisibility.SelfHitTestInvisible)
    self:SetFocus()
end

return M
