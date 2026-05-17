--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Fame_Progress_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.IsPC = CommonUtils.GetRuntimePlatform(self) == "PC"
    self.Text_Level:SetText(GText("ReputationLevel_Title"))  --text 声名等级
    self.Text_Limit:SetText(GText("ReputationExp_WeekLimit"))--text 本周声名获取上限
    self.Button_Area.OnClicked:Add(self, self.OnClicked)
    self.Button_Area.OnPressed:Add(self, self.OnPressed)
    self.Button_Area.OnReleased:Add(self, self.OnReleased)
    self.Button_Area.OnHovered:Add(self, self.OnHovered)
    self.Button_Area.OnUnhovered:Add(self, self.OnUnhovered)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


-- @param CurRegionTabId number 当前选中的区域 Tab ID       
-- @param CurRegionTabData table  当前区域配置数据（RegionReputation 表）       
-- @param AvatarReputation table  玩家当前声望数据（Avatar）      
function M:Init(CurRegionTabId, AvatarReputation)
    self.CurRegionData = DataMgr.RegionReputation[CurRegionTabId]
    local Title = GText("RegionReputation_Title")
    local RegionTitle = GText(self.CurRegionData.RegionName)
    self.Text_RegioName:SetText(RegionTitle.."·"..Title)
    self:UpdateRegionUIIcon()
    -- ===============================
    -- 当周声望是否达到上限
    -- ===============================
    local CurWeekScore = AvatarReputation.ReputationScore or 0 --当周的声望积分（Avatar）
    local WeekLimit    = self.CurRegionData.WeekLimit     --周声望上限（读表 RegionReputation）

    if CurWeekScore >= WeekLimit then
        -- 当周声望已达上限
        self.WidgetSwitcher_1:SetActiveWidgetIndex(1)
        self.Text_Limit_1:SetText(GText("ReputationExp_AchievedWeekLimit"))
    else
        -- 当周声望未达上限
        self.WidgetSwitcher_1:SetActiveWidgetIndex(0)
        self.Num_Now:SetText(CurWeekScore)
        self.Num_Total:SetText(WeekLimit)
    end

    -- ===============================
    -- 区域声望等级是否达到最大
    -- ===============================
    local RegionLevelCfg = DataMgr.ReputationLevel[CurRegionTabId]
        and DataMgr.ReputationLevel[CurRegionTabId][AvatarReputation.ReputationLevel + 1]

    --如果ReputationLevel表存在当前区域的等级数据 说明未满级    
    local CurLevel   = AvatarReputation.ReputationLevel or 0    --当前区域的声望等级（Avatar）
    if RegionLevelCfg then
        local CurLevelExp    = AvatarReputation.ReputationExp or 0  
        local MaxLevelExp = RegionLevelCfg.ReputationLevelMaxExp --当前区域的声望等级上限（读表 ReputationLevel）

        -- 区域声望未满级
        self.WidgetSwitcher_0:SetActiveWidgetIndex(0)
        self.Num_Total_1:SetText(MaxLevelExp)
        self.Num_Now_1:SetText(AvatarReputation.ReputationExp or 0)     --当前区域的声望经验（Avatar）
        self.Num_Fame:SetText(CurLevel)
        self.ProgressBar_Fame:SetPercent(CurLevelExp / MaxLevelExp)
    else
        -- 区域声望已满级
        self.Num_Fame:SetText(CurLevel)
        self.WidgetSwitcher_0:SetActiveWidgetIndex(1)
        self.TextBlock_206:SetText(GText("Reputation_MaxLevel"))
        self.ProgressBar_Fame:SetPercent(1)
    end

    self:PlayAnimation(self.Normal)
end

function M:BindEventOnClicked(Obj, Func, ...)
    if not Obj or not Func then
        return
    end
    self.Obj = Obj
    self.Func = Func
    self.Params = {...}
end

function M:OnClicked()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
end

function M:OnPressed()
    self:StopAllAnimations()
    self:PlayAnimation(self.Press)
end

function M:OnReleased()
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
end

function M:OnHovered()
    if not self.IsPC then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
end

function M:OnUnhovered()
    if not self.IsPC then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.UnHover)
end

function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.Click then
        if self.Obj and self.Func then
            self.Func(self.Obj, table.unpack(self.Params))
        end
    end
end

function M:UpdateRegionUIIcon()
    local RegionUIIcon = self.CurRegionData and self.CurRegionData.RegionUIIcon
    if self.RegionUIIcon then
        if self.RegionUIIcon == RegionUIIcon then
            return
        end
    end
    self.RegionUIIcon = RegionUIIcon
    local Icon = LoadObject(self.RegionUIIcon)
    if not Icon then
        return
    end
    local DynamicMaterial = self.Image_Region:GetDynamicMaterial()
    if not IsValid(DynamicMaterial) then
       return
    end
    DynamicMaterial:SetTextureParameterValue("IconTex", Icon)
   
end



return M
