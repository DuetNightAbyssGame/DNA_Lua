--
-- DESCRIPTION
-- 手机端单个技能按键
-- @COMPANY **
-- @AUTHOR zhuyuhao
-- @DATE ${date} ${time}
--
require "UnLua"
local SkillUtils = require "Utils.SkillUtils"

---@type CharSkill_Phone_C
local M = Class("BluePrints.UI.BP_UIState_C")

function M:Initialize(Initializer)
    self.CurButtonState = {}
    self.AnimationList = {}
    self.IsEnoughSpCanUseSkill = {}
    self.SkillInfo = {}
    --self.LoadingTextureMap = {} -- key = asset name,value = Index
    self.CurButtonState = "Normal"
end

--function M:PreConstruct(IsDesignTime)
--end

function M:Destruct()
    if EMUIAnimationSubsystem:EMAnimationIsPlaying(self,self.AnimationList.UnLock) then
        self.CurButtonState = "Normal"
        EMUIAnimationSubsystem:EMStopAnimation(self, self.AnimationList.UnLock)
    end
    self.Super.Destruct(self)
end


function M:Construct()
    self.Super.Construct(self)
    self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
    self.EnergyNumMat = self.Energy_Num:GetDynamicFontMaterial()
end


function M:SetSkillIndex(Index, SkillType, SkillName, SkillAction, Parent, Panel)
    self.Index = Index
    self.SkillType = SkillType
    self.SkillName = SkillName
    self.SkillAction = SkillAction
    self.Parent = Parent
    self.OwnerPanel = Panel
    self:InitVariable()
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:InitVariable()
    self.SkillId = self.OwnerPlayer:GetSkillByType(self.SkillType)
    self.Skill = self.OwnerPlayer:GetSkill(self.SkillId)
    self:RefreshButtonStyle()
    self.AnimationList = {
        Normal = self.Skill_Normal,
        CD = self.Skill_CD,
        MP_Deficiency = self.Skill_MP_Deficiency,
        Click = self.Skill_Click,
        Disable = self.Skill_Disable,
        Sustain_Loop = self.Skill_Sustain_Loop,
        CD_Complete = self.Skill_CD_Complete,
        Lock_In = self.Skill_Lock_In,
        UnLock = self.Skill_UnLock,
        Sustain_CD = self.Skill_Sustain_CD,
        Ban = self.Skill_Ban
    }
    -- 注册按下的回调
    self.Button_Area.OnPressed:Add(self, self.OnPressedSkill)
    -- 注册松开的回调
    self.Button_Area.OnReleased:Add(self, self.OnReleasedSkill)
    self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
end


function M:OnPressedSkill()
    -- 逻辑层
    self.OwnerPanel:TryToPlayTargetCommand(self.SkillAction, true)

    -- 表现层
    self:OnPressed_Presentation(self.SkillName)
end

function M:OnReleasedSkill()
    self.OwnerPanel:TryToStopTargetCommand(self.SkillAction, true)
end

function M:OnPressed_Presentation(SkillName)
    --local Index
    --local SkillId
    --local Skill
    --if SkillName == "Skill_1" then
    --    Index = 1
    --    SkillId = self.SkillId1
    --    Skill = self.Skill1
    --else
    --    Index = 2
    --    SkillId = self.SkillId2
    --    Skill = self.Skill2
    --end
    if (self.CurButtonState == "Ban") then
        UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_SKILL_FORBIDDEN"))
        return
    end
    if (self.CurButtonState == "Empty") then
        return
    end
    self:PlayResponsiveAnimation()

end

-- 处理随着按键输入，可以叠加在其他状态上的动画
-- Click和Disable互斥 
function M:PlayResponsiveAnimation()
    if self.SkillInfo.CanNotUseInAir then
        return
    end
    if self.CurButtonState == "Lock_In" then
        return
    end
    if self.CurButtonState == "InCDTime" or
            not self.SkillInfo.HasEnoughSp or
            self.CurButtonState == "InCDTimeSustain" then
        -- 播放闪红动画 不受其他动画状态影响 
        if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self,self.AnimationList.Disable) then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.AnimationList.Disable)
        end
    else
        -- 播放点击动画 不受其他动画状态影响
        if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self,self.AnimationList.Click) then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.AnimationList.Click)
        end
    end
end

-- 处理跟着Timer判断的，可以叠加在其他状态上的动画
function M:PlayWithTimerAnimation()
    if (self.SkillInfo == nil) then
        return
    end
    if self.SkillInfo.NeedCDCompleteAnim then
        if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self,self.AnimationList.CD_Complete) then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.AnimationList.CD_Complete)
        end
        self.SkillInfo.NeedCDCompleteAnim = false
    end
end

-- 根据不同的状态执行不同的动画
function M:PlayButtonStateAnimation()
    if self.CurButtonState == "InCDTime" then
        DebugPrint(self.SkillAction, "进入CD态")
        if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self,self.AnimationList.CD) then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.AnimationList.CD)
        end
    elseif self.CurButtonState == "InCDTimeSustain" then
        DebugPrint(self.SkillAction, "进入CD持续态")
        if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self,self.AnimationList.Sustain_CD) then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.AnimationList.Sustain_CD)
        end
    elseif self.CurButtonState == "SustainLoop" then
        DebugPrint(self.SkillAction, "进入持续态")
        if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.AnimationList.Sustain_Loop)then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.AnimationList.Sustain_Loop)
        end
    elseif self.CurButtonState == "Normal" then
        DebugPrint(self.SkillAction, "进入常规态")
        --self:AddTimer(0.05, function() EMUIAnimationSubsystem:EMPlayAnimation(self, self.AnimationList.Normal) end )
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.AnimationList.Normal)
    elseif self.CurButtonState == "MP_Deficiency" then
        DebugPrint(self.SkillAction, "进入蓝量不足")
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.AnimationList.MP_Deficiency)
    elseif self.CurButtonState == "Lock_In" then
        DebugPrint(self.SkillAction, "进入锁定态")
        if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self,self.AnimationList.Lock_In) then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.AnimationList.Lock_In)
        end
    elseif self.CurButtonState == "Ban" then
        DebugPrint(self.SkillAction, "进入Ban态")
        if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self,self.AnimationList.Ban) then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.AnimationList.Ban)
        end
    end
end

function M:HandleCurButtonState(SkillId, Skill, CurButtonState)
    if (Skill == nil) then
        return
    end
    local SkillCDTime, SkillCDPercent = Skill:GetSkillCdTimeAndPercent()
    local IsSkillSustain = self.OwnerPanel:ExecuteCheckIsSkillInUsing(Skill)
    local TextCD = self.Text_CD
    local ProgressBar = self.ProgressBar_CD
    -- Normal状态
    if CurButtonState == "Normal" then
        if not self.SkillInfo.HasEnoughSp then
            self.CurButtonState = "MP_Deficiency"
        end
        if SkillCDTime > 0 and IsSkillSustain then
            self.CurButtonState = "InCDTimeSustain"
            TextCD:SetText(self:GetPreciseDecimal(SkillCDTime, 1))
        elseif SkillCDTime > 0 then
            self.CurButtonState = "InCDTime"
            TextCD:SetText(self:GetPreciseDecimal(SkillCDTime, 1))
        elseif IsSkillSustain then
            self.CurButtonState = "SustainLoop"
        end
        
    elseif CurButtonState == "InCDTime" then
        TextCD:SetText(self:GetPreciseDecimal(SkillCDTime, 1))
        ProgressBar:SetPercent(1 - SkillCDPercent)
        if IsSkillSustain then
            self.CurButtonState = "InCDTimeSustain"
        end
        if SkillCDTime <= 0 then
            if self.SkillInfo.HasEnoughSp then
                self.CurButtonState = "Normal"
                self.SkillInfo.NeedCDCompleteAnim = true
            else
                self.CurButtonState = "Normal"
            end
        end
        
    elseif CurButtonState == "InCDTimeSustain" then
        TextCD:SetText(self:GetPreciseDecimal(SkillCDTime, 1))
        ProgressBar:SetPercent(1 - SkillCDPercent)
        if SkillCDTime <= 0 and IsSkillSustain then
            self.CurButtonState = "SustainLoop"
            if self.SkillInfo.HasEnoughSp then
                self.SkillInfo.NeedCDCompleteAnim = true
            end
        elseif SkillCDTime > 0 and not IsSkillSustain then
            self.CurButtonState = "InCDTime"
        elseif not IsSkillSustain then
            if self.SkillInfo.HasEnoughSp then
                self.CurButtonState = "Normal"
                self.SkillInfo.NeedCDCompleteAnim = true
            else
                self.CurButtonState = "Normal"
            end
        end
        
    elseif CurButtonState == "SustainLoop" then
        if not IsSkillSustain  and  SkillCDTime <= 0 then
            if self.SkillInfo.HasEnoughSp then
                self.CurButtonState = "Normal"
                self.SkillInfo.NeedCDCompleteAnim = true
            else
                self.CurButtonState = "Normal"
            end
        elseif not IsSkillSustain and SkillCDTime > 0 then
            self.CurButtonState = "InCDTime"
            TextCD:SetText(self:GetPreciseDecimal(SkillCDTime, 1))
        elseif SkillCDTime > 0 then
            self.CurButtonState = "InCDTimeSustain"
            TextCD:SetText(self:GetPreciseDecimal(SkillCDTime, 1))
        end
        
    elseif CurButtonState == "MP_Deficiency" then
        if self.SkillInfo.HasEnoughSp then
            self.CurButtonState = "Normal"
            self.SkillInfo.NeedCDCompleteAnim = true
        end

    elseif CurButtonState == "Lock_In" then
        if self.SkillInfo.NeedUnlock == true then
            self:ToNormalStateAfterAnim()
            self.SkillInfo.NeedUnlock = false
        end
    end

    -- local SkillEnumId = (Index == 1) and ESkillName.Skill1 or ESkillName.Skill2
    -- if (not self.OwnerPlayer:CheckSkillIsBan(SkillEnumId) and self.CurButtonState ~= "Empty") then
    --     if (self.OwnerPlayer:CheckSkillInActive(SkillEnumId)) then
    --         self.CurButtonState = "Lock_In"
    --     else
    --         self.SkillInfo.NeedUnlock = true
    --     end
    -- end

    -- 检测到状态改变了才调用
    if CurButtonState ~= self.CurButtonState then
        self:PlayButtonStateAnimation()
    end
end

--每0.1秒调用一次
function M:UpdateSkillInTimer()
    if self.CurButtonState == "MasterBan" then
        return
    end
    local SkillId = self.SkillId
    local Skill = self.OwnerPlayer:GetSkill(SkillId)
    self:HandleCurButtonState(SkillId, Skill, self.CurButtonState)
    self:PlayWithTimerAnimation()
end

-- 根据是否在空中来控制透明度
function M:ChangeIsInAir(IsInAir)
    self:BanSkillInAir(IsInAir)
end

function M:BanSkillInAir(IsBanInAir)
    if IsBanInAir then
        self:SetRenderOpacity(0.5)
        self.SkillInfo.CanNotUseInAir = true
    else
        self:SetRenderOpacity(1.0)
        self.SkillInfo.CanNotUseInAir = false
    end
end

-- 刷新技能的图标和显示蓝耗
function M:RefreshButtonStyle()

    self.SkillId = self.OwnerPlayer:GetSkillByType(self.SkillType)
    self.Skill = self.OwnerPlayer:GetSkill(self.SkillId)
    
    if (not IsValid(self.Skill)) then
        return
    end
    local SkillBaseConfig = self.Skill.Data
    self.SkillInfo.CostSp = self:CalculateSkillCostSp(self.Skill)
    self.Energy_Num:SetText(self.SkillInfo.CostSp)

    if self.OwnerPanel and self.OwnerPanel.Skill.NowSp < self.SkillInfo.CostSp then
        self.SkillInfo.HasEnoughSp = false
        self.EnergyNumMat:SetScalarParameterValue("EnergyState", 0)
    else
        self.EnergyNumMat:SetScalarParameterValue("EnergyState", 1)
        self.SkillInfo.HasEnoughSp = true
    end
    
    if (SkillBaseConfig.SkillBtnIcon ~= nil) then
        self.LoadSkillIconId = nil
        local Handle = UE.UResourceLibrary.LoadObjectAsyncWithId(self,"Texture2D'/Game/UI/Texture/Dynamic/Atlas/Skill/T_"..SkillBaseConfig.SkillBtnIcon,{self,M.OnSkillImgIconLoadFinishWithId})
        if Handle then
            self.LoadSkillIconId = Handle.ResourceID
        end
        -- local SkillImgIcon = LoadObject('/Game/UI/UI_PNG/03Image/Skill/'..SkillBaseConfig.SkillBtnIcon)
        -- if (IsValid(SkillImgIcon)) then
        --     --self["Icon_Skill"..Index]:SetBrushResourceObject(SkillImgIcon)
        --     local SkillMat = self["Icon_Skill_"..Index]:GetDynamicMaterial()
        --     SkillMat:SetTextureParameterValue("Mask", SkillImgIcon)
        -- end
    end
end

-- 只刷新技能的显示蓝耗
function M:OnRefreshSkillSpCost(Owner)
    if (not IsValid(self.OwnerPlayer)) then
        return
    end
    if not Owner or Owner ~= self.OwnerPlayer then
        -- 部分UpdateSkillEfficiency事件是由服务端通知客户端的，因此联机下需要区分是否是自己的客户端
        return
    end
    DebugPrint("@zyh 刷新技能的显示蓝耗")
    
    if (not IsValid(self.Skill)) then
        return
    end
    self.SkillInfo.CostSp = self:CalculateSkillCostSp(self.Skill)
    self.Energy_Num:SetText(self.SkillInfo.CostSp)
    if self.OwnerPanel.Skill.NowSp < self.SkillInfo.CostSp then
        self.SkillInfo.HasEnoughSp = false
        self.EnergyNumMat:SetScalarParameterValue("EnergyState", 0)
    else
        self.EnergyNumMat:SetScalarParameterValue("EnergyState", 1)
        self.SkillInfo.HasEnoughSp = true
    end

end

function M:OnUpdateBuffSpModify()
    if (not IsValid(self.OwnerPlayer)) then
        return
    end
    
    if (not IsValid(self.Skill)) then
        return
    end
    self.SkillInfo.CostSp = self:CalculateSkillCostSp(self.Skill)
    self.Energy_Num:SetText(self.SkillInfo.CostSp)
    if self.OwnerPanel.Skill.NowSp < self.SkillInfo.CostSp then
        self.SkillInfo.HasEnoughSp = false
        self.EnergyNumMat:SetScalarParameterValue("EnergyState", 0)
    else
        self.SkillInfo.HasEnoughSp = true
        self.EnergyNumMat:SetScalarParameterValue("EnergyState", 1)
    end

end

function M:OnSkillImgIconLoadFinishWithId(Object, ResourceID)
    if not IsValid(self) or not Object or ResourceID ~= self.LoadSkillIconId then
        return
    end
    --local AssetName = Object:GetName()
    --self.LoadingTextureMap[AssetName] = nil
    self.Icon_Skill:GetDynamicMaterial():SetTextureParameterValue("Mask", Object)
end

-- 计算应该显示的蓝耗数值
function M:CalculateSkillCostSp(Skill)
    if not Skill then
        return
    end
    local SkillBaseConfig = Skill.Data
    local CostSpNum = nil
    if SkillBaseConfig.NotExecuteSpCost ~= nil then
        CostSpNum = SkillBaseConfig.NotExecuteSpCost

        CostSpNum = SkillUtils.CalcSkillDescValue(CostSpNum, Skill.SkillLevel)
    else
        local SkillNodeId = Skill.BeginNodeId
        local SkillNodeConfig = DataMgr.SkillNode[SkillNodeId] or {}
        CostSpNum = SkillNodeConfig.CostSp or 0
    end

    local ModifyValue = self.OwnerPlayer.BuffManager:GetBuffSpModify(Skill.SkillId)
    CostSpNum = math.max(math.ceil(CostSpNum + ModifyValue),0)
    return self.OwnerPlayer:ApplySkillEfficiency(CostSpNum) or 0
end

--UnLock动画特别处理，播放完就跳进Normal态
function M:ToNormalStateAfterAnim()
    self:BindToAnimationFinished(self.AnimationList.UnLock, function()
        self.CurButtonState = "Normal"
    end)
    if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self,self.AnimationList.UnLock) then
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.AnimationList.UnLock)
    end
end
return M
