--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

local SkillUtils = require "Utils.SkillUtils"

local WBP_Player_SkillItem_PC_C = Class("BluePrints.UI.BP_UIState_C")

WBP_Player_SkillItem_PC_C._components = {
    "BluePrints.UI.Battle.Widget.WBP_Battle_FortItem_P_C",
}

local AllButtonStyleName, DefaultSkillStyleNodeName = {"Common_Btn", "Sprint_Multi", "Switch"}, "Common_Btn"

function WBP_Player_SkillItem_PC_C:Initialize(Initializer)
    self.Super.Initialize(self)
    self.LastButtonState = nil
    self.OwnerPlayer = nil
    self.SkillName = nil
    self.SkillEnumId = nil
    self.SkillStyleNode = nil
    self.SkillInfo = {}

    -- 缓存Tick中使用的变量
    self.Energy_Num_Color_1 = UE4.UUIFunctionLibrary.StringToSlateColor("7B7B7BFF")
    self.Energy_Num_Color_2 = UE4.UUIFunctionLibrary.StringToSlateColor("FF4646FF")
    self.Energy_Num_Color_3 = UE4.UUIFunctionLibrary.StringToSlateColor("674740FF")
    self.Energy_Num_Bg_Color_1 = UE4.UUIFunctionLibrary.StringToLinearColor("FFFFFFFF")
    self.Energy_Num_Bg_Color_2 = UE4.UUIFunctionLibrary.StringToLinearColor("000000FF")
    self.Energy_Num_Bg_Color_3 = UE4.UUIFunctionLibrary.StringToLinearColor("FFFFFFFF")
    self.EnergyBgMatLinearColor1 = UE4.FLinearColor(1.0, 1.0, 1.0, 1.0)
    self.EnergyBgMatLinearColor2 = UE4.FLinearColor(1.0, 1.0, 1.0, 1.0)
    self.EnergyBgMatLinearColor3 = UE4.FLinearColor(1.5, 1.3, 1.0, 1.0)
    self.InActiveStates_Cover = { -- UI上直接遮住的禁用态
        "Lock",
        "Ban",
        "Empty",
    }
    self.InActiveStates_Opacity = { -- UI上显示半透明的禁用态（策划要求这种状态继续显示CD）
        "RegionBan",
        "Hooking",
    }
end

function WBP_Player_SkillItem_PC_C:Construct()
    self.EnergyBgMat = self.Energy_Num_Bg:GetDynamicMaterial()
    self.IsSkillEnoughSpCanUse = true
    self.CurButtonState = nil
    self:ClearRemainAnim()
    self:UnEmptySkill()
end

function WBP_Player_SkillItem_PC_C:Destruct()
    if EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Unlock) then
        EMUIAnimationSubsystem:EMStopAnimation(self, self.Unlock)
    end
    WBP_Player_SkillItem_PC_C.Super.Destruct(self)
end

function WBP_Player_SkillItem_PC_C:SetGamepadIcons()
    if not self.SkillName then return end 
    local SkillIcon = UIUtils.GetIconListByActionName(self.SkillName)[2]
    self.Key_Img:CreateCommonKey({ KeyInfoList = {{Type = "Img", ImgShortPath = SkillIcon}} })
end

function WBP_Player_SkillItem_PC_C:RefreshButtonStyle(SkillName, Skill, SkillEnumId, Owner)
    self.OwnerPlayer = Owner
    local SkillCostSp, SkillBtnStyle, SkillBaseConfig = 0, "", {}
    if Skill then
        SkillBaseConfig = Skill.Data
        -- 设置各自节点的通用样式
        SkillBtnStyle = SkillBaseConfig.SkillBtnStyle or DefaultSkillStyleNodeName
        if (SkillBtnStyle ~= nil) then
            for i, v in ipairs(AllButtonStyleName) do
                if (self[v] ~= nil) then
                    if (v == SkillBtnStyle) then
                        self[v]:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                    else
                        self[v]:SetVisibility(UE4.ESlateVisibility.Collapsed)
                    end
                end
            end
        end
        if (SkillBaseConfig.SkillBtnIcon ~= nil) then
            local Path = "/Game/UI/Texture/Dynamic/Atlas/Skill/T_"..SkillBaseConfig.SkillBtnIcon
            --local SkillImgIcon = LoadObject("/Game/UI/Texture/Dynamic/Atlas/Skill/T_"..SkillBaseConfig.SkillBtnIcon)
            self.LoadSkillIconID = nil
            local Handle = UE.UResourceLibrary.LoadObjectAsyncWithId(self, Path, {self,WBP_Player_SkillItem_PC_C.OnIconLoadFinishWithID})
            if Handle then
                self.LoadSkillIconID = Handle.ResourceID
            end
            --if (IsValid(SkillImgIcon)) then
            --    self.Icon_Skill:SetBrushResourceObject(SkillImgIcon)
            --    local VXSkillMat = self.VX_skillIcon:GetDynamicMaterial()
            --    VXSkillMat:SetTextureParameterValue("Mask", SkillImgIcon)
            --end
        end
        SkillCostSp = self:CalculateSkillCostSp(Skill)
        self.Energy_Num:SetText(SkillCostSp)
        if (SkillBaseConfig.SkillBtnDesc ~= nil) then
            self.Text_Skill:SetText(GText(SkillBaseConfig.SkillBtnDesc))
        end
        self.SkillName = SkillName
        self.SkillEnumId = SkillEnumId
        self.SkillStyleNode = SkillBtnStyle
        if (not self.OwnerPlayer:CheckSkillInActive(SkillEnumId)) then
            self:SetButtonStyleByState(SkillEnumId, "UnLock")
        else
            if(not self.OwnerPlayer:CheckSkillIsBan(SkillEnumId) and self.CurButtonState ~= "Empty") then
                self:SetButtonStyleByState(SkillEnumId, "Lock")
            end
        end
        self.SkillInfo[SkillName] = {SkillId=Skill.SkillId, SkillCostSp=SkillCostSp, SkillBtnStyle=SkillBtnStyle, SkillConfigData=SkillBaseConfig}
        self:UpdateCharSpInfo(SkillName)
    end
end

function WBP_Player_SkillItem_PC_C:RemoveAllListenInput()
    for i = 1, 2, 1 do
        local SkillName = "Skill"..tostring(i)
        self:StopListeningForInputAction(SkillName, UE4.EInputEvent.IE_Pressed)
    end
end

function WBP_Player_SkillItem_PC_C:CalculateSkillCostSp(SkillObj)
    if not SkillObj then
        return 0
    end
    local SkillBaseConfig = SkillObj.Data
    local CostSpNum = nil
    if SkillBaseConfig.NotExecuteSpCost ~= nil then
        CostSpNum = SkillBaseConfig.NotExecuteSpCost

        CostSpNum = SkillUtils.CalcSkillDescValue(CostSpNum, SkillObj.SkillLevel)
    else
        local SkillNodeId = SkillObj.BeginNodeId
        local SkillNodeConfig = DataMgr.SkillNode[SkillNodeId] or {}
        CostSpNum = SkillNodeConfig.CostSp or 0
    end
    
    local ModifyValue = self.OwnerPlayer.BuffManager:GetBuffSpModify(SkillObj.SkillId)
    CostSpNum = math.max(math.ceil(CostSpNum + ModifyValue),0)
    return self.OwnerPlayer:ApplySkillEfficiency(CostSpNum) or 0
end

function WBP_Player_SkillItem_PC_C:CheckSkillHaveEnoughSp(SkillName)
    local SkillCostSp = self.SkillInfo[SkillName].SkillCostSp
    if (not IsValid(self.OwnerPlayer)) then
        return false
    end
    return self.OwnerPlayer:GetAttr("Sp") >= SkillCostSp
end

function WBP_Player_SkillItem_PC_C:SetButtonStyleByState(SkillEnumId, StateName)
    if (StateName == self.CurButtonState) then
        return
    end
    if (StateName == "UnLock") then
        self:RemoveAllListenInput()
        self:AddSkillListeningInput()
        if (self.CurButtonState == "Lock") then
            -- 从未解锁切换成解锁
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.UnLock)
            -- self.Panel_Skill:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible) 
        end
    elseif (StateName == "Lock") then
        self:RemoveAllListenInput()
        self:PlayAnimationForward(self.Lock_In)
        -- self.Panel_Skill:SetVisibility(UE4.ESlateVisibility.Collapsed)
    elseif (StateName == "Ban") then
        self:RemoveAllListenInput()
        self:PlayAnimationForward(self.Ban)
    elseif (StateName == "UnBan") then
        self:RemoveAllListenInput()
        self:AddSkillListeningInput()
        if (self.CurButtonState ~= "Lock") then
            EMUIAnimationSubsystem:EMPlayAnimation(self,self.Normal)
        end
    elseif (StateName == "RegionBan") then
        self:RemoveAllListenInput()
        self:SetPanelOpacityForBan(true)
    elseif (StateName == "RegionUnBan") then
        self:RemoveAllListenInput()
        self:AddSkillListeningInput()
        self:SetPanelOpacityForBan(false)
    elseif (StateName == "Empty") then
        self:RemoveAllListenInput()
        self:EmptySkill()
    elseif (StateName == "UnEmpty") then
        self:RemoveAllListenInput()
        self:AddSkillListeningInput()
        self:UnEmptySkill()
    elseif (StateName == "Hooking") then
        self:SetPanelOpacityForBan(true)
    elseif (StateName == "EndHooking") then
        self:SetPanelOpacityForBan(false)
    end
    if (StateName == "Ban") then
        if(self.CurButtonState ~= "Lock") then
            self.CurButtonState = StateName
        end
    else
        self.CurButtonState = StateName
    end
end

function WBP_Player_SkillItem_PC_C:EmptySkill()
    self.Switcher_Skill:SetActiveWidgetIndex(1)
    self.Bg01:SetBrushTintColor(UE4.UUIFunctionLibrary.GetSlateColorByRGBA(0,0,0,0.2))
end

function WBP_Player_SkillItem_PC_C:UnEmptySkill()
    self:SetPanelOpacityForBan(false)
    self.Switcher_Skill:SetActiveWidgetIndex(0)
    self.Bg01:SetBrushTintColor(UE4.UUIFunctionLibrary.GetSlateColorByRGBA(0,0,0,0.55))
end

function WBP_Player_SkillItem_PC_C:CheckIsCanUseSkillByName(SkillName)
    -- 判断是否可以使用技能
    if (not IsValid(self.OwnerPlayer)) then
        return false
    end
    local SkillId = self.SkillInfo[SkillName].SkillId
    return self.OwnerPlayer:DoCheckUseSkill(SkillId)
end

function WBP_Player_SkillItem_PC_C:ExecuteCheckIsSkillInUsing(SkillId)
    -- 判断技能是否处于使用状态
    local Skill = self.OwnerPlayer:GetSkill(SkillId)
    if not Skill then
        return false
    end
    -- DebugPrint("ExecuteCheckIsSkillInUsing---", Skill.SkillId, Skill.CombatCondition)
    if (Skill.CombatConditionID) then
        local TraceInfo="From WBP_Player_SkillItem_PC_C:ExecuteCheckIsSkillInUsing"
        return Battle(self):CheckConditionNew(Skill.CombatConditionID, self.OwnerPlayer, nil,TraceInfo)
    end
    return false
end

function WBP_Player_SkillItem_PC_C:RefreshSkillStyleInTimer(SkillName)
    -- 刷新玩家技能CD时间相关
    if not IsValid(self.OwnerPlayer) then
        return
    end
    -- 技能按钮样式刷新
    if (self.SkillInfo[SkillName] == nil) then
        return
    end
    local SkillId = self.SkillInfo[SkillName].SkillId
    if (SkillId == nil or CommonUtils.HasValue(self.InActiveStates_Cover, self.CurButtonState)) then
        return
    end
    local SkillBtnStyleName = self.SkillInfo[SkillName].SkillBtnStyle

    local SkillCdTime, SkillCdPercent = self.OwnerPlayer:GetSkillCdTimeAndPercent(SkillId)
    -- 统一逻辑刷新
    if SkillCdTime > 0 then
        self.Text_CD:SetText(self:GetPreciseDecimal(SkillCdTime, 1))
        self.Bar_Skill_CD:SetPercent(1 - SkillCdPercent)
    end
    if(CommonUtils.HasValue(self.InActiveStates_Opacity, self.CurButtonState)) then
        return
    end
    if (SkillCdTime > 0) then
        -- 技能处于CD状态
        self.CurButtonState = "InCDTime"
    elseif (not self.IsSkillEnoughSpCanUse) then
        self.CurButtonState = "EnergyNotEnough"
    else
        self.CurButtonState = "UnLock"
    end
    self:HandleButtonStateChange(SkillName)

    -- 各自节点特殊逻辑刷新
    if (SkillBtnStyleName == "Sprint_Multi") then
        local SkillCanUseCount = self.OwnerPlayer:GetSkillCanUseTime(SkillId)
        -- local SkillConfigCount = self.SkillInfo[SkillName].SkillConfigData.MaxUseTime
        self.Charge_Num:SetText(tostring(SkillCanUseCount))
        local MultiTimeMat = self.Bar_Charge:GetDynamicMaterial()
        MultiTimeMat:SetScalarParameterValue("Percent", math.max(1 - SkillCdPercent, 0))
    elseif (SkillBtnStyleName == "Switch") then
        local IsInUseSkill = self:ExecuteCheckIsSkillInUsing(SkillId)
        if (IsInUseSkill) then
            if (not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Sustain_Loop) and self.VX_skillIcon:GetRenderOpacity() < 1.0) then
                EMUIAnimationSubsystem:EMPlayAnimation(self, self.Sustain_Loop)
            end
        else
            if (self.VX_skillIcon:GetRenderOpacity() >= 1.0 and self.IsSkillEnoughSpCanUse) then
                EMUIAnimationSubsystem:EMPlayAnimation(self, self.Sustain_Loop, 1)
            end
        end
    end
end

function WBP_Player_SkillItem_PC_C:HandleButtonStateChange(SkillName)
    if (self.LastButtonState ~= self.CurButtonState) then
        if (self.CurButtonState == "InCDTime") then
            self.Text_CD:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.VX_Energy_Num_Bg:SetVisibility(UE4.ESlateVisibility.Collapsed)
            if self.IsSkillEnoughSpCanUse then
                if EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Skill_Complete) then
                    EMUIAnimationSubsystem:EMStopAnimation(self, self.Skill_Complete)
                end
                EMUIAnimationSubsystem:EMPlayAnimation(self, self.Cd_Graying)
            end
            self.Icon_Skill:SetRenderOpacity(0.2)
        else
            if (self.CurButtonState == "UnLock") then
                self.Icon_Skill:SetRenderOpacity(1.0)
                if (not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Skill_Complete)) then
                    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Skill_Complete)
                end
            end
            -- 正常状态
            self.Bar_Skill_CD:SetPercent(0)
            self.Text_CD:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self:UpdateCharSpInfo(SkillName) -- 转好CD之后需要判断一次是否足够蓝
        end
    end
    self.LastButtonState = self.CurButtonState
end

-- 根据是否在空中来控制透明度
function WBP_Player_SkillItem_PC_C:ChangeIsInAir(IsInAir)
    self.CanNotUseInAir = IsInAir
    self:SetPanelOpacityForBan(IsInAir)
end

function WBP_Player_SkillItem_PC_C:SetPanelOpacityForBan(IsBan)
    if IsBan then
        self.Panel_Skill01:SetRenderOpacity(0.6)
    else
        self.Panel_Skill01:SetRenderOpacity(1.0)
    end
end

-- 随着蓝量变化事件而调用，主要刷新和蓝量有关的UI
function WBP_Player_SkillItem_PC_C:UpdateCharSpInfo(SkillName, NowSp)
    if not IsValid(self.OwnerPlayer)then
        return
    end
    if (self.SkillInfo[SkillName] == nil) then
        return
    end
    local SkillId = self.SkillInfo[SkillName].SkillId
    if (SkillId == nil or self.CurButtonState == "Lock") then
        return
    end
    if not NowSp then
        NowSp = self.OwnerPlayer:GetAttr("Sp")
    end
    if (self.SkillInfo[SkillName].State == "Open") then
        self.IsSkillEnoughSpCanUse = NowSp >= (self.SkillInfo[SkillName].CloseSkillCostSp or 0)
    else
        self.IsSkillEnoughSpCanUse = NowSp >= self.SkillInfo[SkillName].SkillCostSp
    end
    if (self.LastSkillEnoughSpCanUse ~= self.IsSkillEnoughSpCanUse) then
        if (not self.IsSkillEnoughSpCanUse) then
            -- 技能缺蓝
            self.Bar_Skill_CD:SetPercent(0)
            if EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Skill_Complete) then
                EMUIAnimationSubsystem:EMStopAnimation(self, self.Skill_Complete)
            end
            EMUIAnimationSubsystem:EMPlayAnimation(self,self.Mp_Lack)
            self.Icon_Skill:SetRenderOpacity(0.2)
        else
            self.Icon_Skill:SetRenderOpacity(1.0)
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Mp_Lack, 1)
            if(self.CurButtonState == "InCDTime") then
                EMUIAnimationSubsystem:EMPlayAnimation(self, self.Cd_Graying)
            end
        end
    end
    self.LastSkillEnoughSpCanUse = self.IsSkillEnoughSpCanUse
end

function WBP_Player_SkillItem_PC_C:UpdateSkillEfficiency(SkillName, NowSp)
    if not IsValid(self.OwnerPlayer)then
        return
    end
    if (self.SkillInfo[SkillName] == nil) then
        return
    end
    local SkillId = self.SkillInfo[SkillName].SkillId
    if (SkillId == nil or self.CurButtonState == "Lock") then
        return
    end
    local Skill = self.OwnerPlayer:GetSkill(SkillId)
    if not Skill then
        return
    end
    local SkillCostSp = self:CalculateSkillCostSp(Skill)
    self.Energy_Num:SetText(SkillCostSp)
    self.SkillInfo[SkillName].SkillCostSp = SkillCostSp
    self:UpdateCharSpInfo(SkillName, NowSp)
end

function WBP_Player_SkillItem_PC_C:UpdateBuffSpModify(SkillName, NowSp)
    if (self.SkillInfo[SkillName] == nil) then
        return
    end
    local SkillId = self.SkillInfo[SkillName].SkillId
    if (SkillId == nil or self.CurButtonState == "Lock") then
        return
    end
    local Skill = self.OwnerPlayer:GetSkill(SkillId)
    local SkillCostSp = self:CalculateSkillCostSp(Skill)
    self.Energy_Num:SetText(SkillCostSp)
    self.SkillInfo[SkillName].SkillCostSp = SkillCostSp
    self:UpdateCharSpInfo(SkillName, NowSp)
end

function WBP_Player_SkillItem_PC_C:RefreshSkillIconAndText(SkillName, SkillId, State)
    local Skill = self.OwnerPlayer:GetSkill(SkillId)
    if not Skill then return end
    local SkillBaseConfig = Skill.Data
    -- local SkillBtnStyleName = self.SkillInfo[SkillName].SkillBtnStyle
    if (SkillBaseConfig.SkillBtnIcon ~= nil) then
        local Path = "/Game/UI/Texture/Dynamic/Atlas/Skill/T_"..SkillBaseConfig.SkillBtnIcon
        self.LoadSkillIconID = nil
        local Handle = UE.UResourceLibrary.LoadObjectAsyncWithId(self, Path, {self,WBP_Player_SkillItem_PC_C.OnIconLoadFinishWithID})
        if Handle then
            self.LoadSkillIconID = Handle.ResourceID
        end
        --local SkillImgIcon = LoadObject("/Game/UI/Texture/Dynamic/Atlas/Skill/T_"..SkillBaseConfig.SkillBtnIcon)
        --if (IsValid(SkillImgIcon)) then
        --    self.Icon_Skill:SetBrushResourceObject(SkillImgIcon)
        --end
    end
    local SkillNodeId = Skill.BeginNodeId
    local SkillNodeConfig = DataMgr.SkillNode[SkillNodeId] or {}
    local SkillCostSp = self:CalculateSkillCostSp(Skill)
    self.Energy_Num:SetText(SkillCostSp)
    if (SkillBaseConfig.SkillBtnDesc ~= nil) then
        self.Text_Skill:SetText(GText(SkillBaseConfig.SkillBtnDesc))
    end
    self.SkillInfo[SkillName].State = State
    self.SkillInfo[SkillName].CloseSkillCostSp = SkillCostSp
end

function WBP_Player_SkillItem_PC_C:OnSkillActionInput()
    if (self.CurButtonState == "Lock" or self.CanNotUseInAir) then
        return
    end
    if (self.CurButtonState == "EnergyNotEnough" or self.CurButtonState == "InCDTime") then
        -- 能量不足、CD中
        self.Icon_Skill:SetRenderOpacity(0.2)
        if (not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Skills_Disable)) then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Skills_Disable)
        end
    elseif (self.CurButtonState == "UnLock") then
        -- 正常使用
        if (not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Click)) then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
        end
    end
end

function WBP_Player_SkillItem_PC_C:OnIconLoadFinishWithID(Object, ResourceID)
    if not Object or not IsValid(self) or ResourceID ~= self.LoadSkillIconID then 
        return
    end
    self.Icon_Skill:SetBrushResourceObject(Object)
    local VXSkillMat = self.VX_skillIcon:GetDynamicMaterial()
    VXSkillMat:SetTextureParameterValue("Mask", Object)
end

function WBP_Player_SkillItem_PC_C:AddSkillListeningInput()
    self:ListenForInputAction(self.SkillName, UE4.EInputEvent.IE_Pressed, false, {self, self.OnSkillActionInput})
end

-- 清除残留的动效 一般用在换角色/切场景时
function WBP_Player_SkillItem_PC_C:ClearRemainAnim()
    if(self.VX_skillIcon and self.VX_skillIcon:GetRenderOpacity() > 0.0) then
        self:PlayAnimation(self.Sustain_Loop, self.Sustain_Loop:GetEndTime(), 1, UE4.EUMGSequencePlayMode.Reverse)
    end
    if(self.VX_CompleteGlow and self.VX_CompleteGlow:GetVisibility() ~= ESlateVisibility.Collapsed) then
        self.Icon_Skill:SetRenderOpacity(1.0)
        if not self.PaoTaiItem then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Skill_Complete)
        end
    end
    if (self.VX_guide_Flash and self.VX_guide_Flash:GetRenderOpacity() >= 1.0) then
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Guide_Remind, 1)
    end
end

AssembleComponents(WBP_Player_SkillItem_PC_C)
return WBP_Player_SkillItem_PC_C