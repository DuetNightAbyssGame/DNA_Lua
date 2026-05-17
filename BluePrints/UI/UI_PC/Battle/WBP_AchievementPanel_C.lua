--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local WBP_AchievementPanel_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_AchievementPanel_C:Initialize(Initializer)
    WBP_AchievementPanel_C.Super.Initialize(self, Initializer)
    self.AchievementId = nil
    self.AchievementConfigData = nil
    self.ShowQueen = {}
    self.index = 1
    self.StartTime = 0
end

function WBP_AchievementPanel_C:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    local AchievementId,CountStage,TargetNeedCount, NewIndex= ...
    -- self.AchievementConfigData = DataMgr.Achievement[self.AchievementId]
    -- if (self.OwnerPlayer == nil or not UE4.UKismetSystemLibrary.IsValid(self.OwnerPlayer)) then
    --     self.OwnerPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    -- end
    -- local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    -- local TalkContext = GameInstance:GetTalkContext()
    -- if TalkContext:IsInTalk() then
    --     self:CloseSelfBlend()
    -- end
    -- self.ProgressMaterial=self.Image_Progress:GetDynamicMaterial()
    self.IconMaterial=self.VX_Icon_Light:GetDynamicMaterial()
    self:SetVisibility(ESlateVisibility.HitTestInvisible)
    local Offset = self.Offset_M
    if Offset then
        if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
            local Padding = self.Padding
            Padding.Bottom = Offset
            self:SetPadding(Padding)
        end
    end

    -- self:UpdateAchievementPage(CountStage,TargetNeedCount, NewIndex)
    self:PlayAnimation(self.FadeIn,self.FadeIn:GetEndTime() ,1, EUMGSequencePlayMode.Reverse, 1, false)
    self:AddQuene(AchievementId,CountStage,TargetNeedCount, NewIndex)
    self:AddTimer(0.01,function()
        if self:GetVisibility()~=ESlateVisibility.Collapsed then--有可能打开的时候被对话屏蔽了，先入队延迟一下再生效
            self:Text_Title_End_Event()
        end
    end)
end

function WBP_AchievementPanel_C:Destruct()
    self.Super.Destruct(self)
    -- self.ProgressMaterial=nil
    self.IconMaterial=nil
end
--
function WBP_AchievementPanel_C:CloseProgressBar(CurrentProgress)
    self.TriggerUnlockItem=nil
    local AchvData = DataMgr.Achievement[self.AchievementId]
    local TargetCount = 1
    if AchvData.TargetProgressRenew then
        TargetCount = #AchvData.TargetProgressRenew + 1
    end
    -- if TargetCount == 1 then
    --     -- self.ProgressMaterial:SetScalarParameterValue('TargeHeight',0)
    --     self.HB_Progress:SetVisibility(ESlateVisibility.Collapsed)
    -- else
        -- self.ProgressMaterial:SetScalarParameterValue('SegmentsNumber',TargetCount)
        -- self.ProgressMaterial:SetScalarParameterValue('TargeHeight',CurrentProgress/TargetCount)
        -- local progressItem=nil
        -- for i=1,TargetCount do
        --     progressItem=self['Achievement_HudProgressItem_PC_'..i]
        --     progressItem:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        --     if i<CurrentProgress then
        --     progressItem:PlayAnimation(progressItem.Locked)
        --     elseif i==CurrentProgress then
        --         progressItem:PlayAnimation(progressItem.Normal)
        --         self.TriggerUnlockItem=progressItem
        --     else
        --         progressItem:PlayAnimation(progressItem.Normal)
        --     end
        -- end
        -- if TargetCount<5 then
        --     for i=TargetCount+1,5 do 
        --         self['Achievement_HudProgressItem_PC_'..i]:SetVisibility(ESlateVisibility.Collapsed)
        --     end
        -- end
        -- self.HB_Progress:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    -- end
end

function WBP_AchievementPanel_C:UpdateAchievementPage(CountStage,TargetNeedCount, NewIndex)
    if (not self.AchievementConfigData) then
        print(_G.LogTag,"ZJT_ UpdateAchievementPage Not exist ")
        return
    end
    -- local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    -- local TalkContext = GameInstance:GetTalkContext()
    -- if TalkContext:IsInTalk() then
    --     self:OpenSelfBlend()
    -- end
    
    ----- 显示几次
    local wrapfunc = function()
        if self:IsAnimationPlaying(self.FadeIn) or self:IsAnimationPlaying(self.FadeOut) then
            self:StopAnimation(self.FadeIn)
            self:StopAnimation(self.FadeOut)
        end
        self:PlayAnimation(self.FadeOut, 0 ,1, EUMGSequencePlayMode.Forward, 1, true)
    end
    self:AddTimer(5.0, wrapfunc)
    self.StartTime = UE4.UGameplayStatics.GetTimeSeconds(self)
    local Text_Title_Info = GText(self.AchievementConfigData.AchievementName)
    -- local Straight_matter_Desc = GText(self.AchievementConfigData.AchievementDescribe)
    -- local desc=CountStage.."/"..TargetNeedCount
    local Straight_matter_Desc = GText("UI_AchievementToast_Progress")
    local desc = ""
    local PercentValue = 0
    local TargetCount = 1
    if self.AchievementConfigData.TargetProgressRenew then
        TargetCount = #self.AchievementConfigData.TargetProgressRenew + 1
    end
    if TargetCount == 1 then
        desc= 1 .. "/" .. 1
        PercentValue = 1.0
    else
        desc = CountStage .. "/" .. TargetNeedCount
        PercentValue = CountStage / TargetNeedCount
    end
    -- Straight_matter_Desc = string.gsub(Straight_matter_Desc,"#1",desc)
    Straight_matter_Desc = Straight_matter_Desc .. " " .. desc
    -- 设置进度条
    self.ProgressBar_Achievement:SetPercent(PercentValue)
    -- local EffectMaterial = self.RetainerBox_Text:GetEffectMaterial()
    -- if EffectMaterial then
    --     EffectMaterial:SetScalarParameterValue("HPValue1", PercentValue)
    -- end

    self.Text_Title:SetText(Text_Title_Info)
    -- self.Text_Title_1:SetText(Text_Title_Info)
    self.Straight_matter:SetText(Straight_matter_Desc)
    local Icon=LoadObject(DataMgr.AchievementType[DataMgr.Achievement[self.AchievementId].AchievementType].AchievementTypeIcon2)
    if Icon then
        self.Icon:GetDynamicMaterial():SetTextureParameterValue("IconMap", Icon)
        self.VX_Icon_Light:GetDynamicMaterial():SetTextureParameterValue("IconMap", Icon)
    end
    self:CloseProgressBar(NewIndex)
    if self:IsAnimationPlaying(self.FadeIn) or self:IsAnimationPlaying(self.FadeOut) then
        self:StopAnimation(self.FadeIn)
        self:StopAnimation(self.FadeOut)
    end
    self:PlayAnimation(self.FadeIn,0 ,1, EUMGSequencePlayMode.Forward, 1, false)
end
function WBP_AchievementPanel_C:AddQuene(AchvId, Count, TargetNeedCount, NewIndex)
    local info = {}
    info.AchievementId = AchvId
    info.Count = Count
    info.NewIndex = NewIndex
    info.TargetNeedCount = TargetNeedCount
    table.insert(self.ShowQueen, info)
end

function WBP_AchievementPanel_C:Text_Title_End_Event()
    local avatar=GWorld:GetAvatar()
    if self.ShowQueen[self.index] ~= nil and avatar then
        local Info = self.ShowQueen[self.index]
        self.AchievementId = Info.AchievementId
        self.AchievementConfigData = DataMgr.Achievement[Info.AchievementId]
        local Count = Info.Count
        local NewIndex = Info.NewIndex
        local TargetNeedCount = Info.TargetNeedCount
        self:StopAllAnimations()
        local achieve=avatar.Achvs:GetAchv(self.AchievementId)
        if achieve and achieve:IsIndividual() then
            Count=achieve.CompletionValue
        end
        self:UpdateAchievementPage(Count, TargetNeedCount, NewIndex)
        self.ShowQueen[self.index] = nil
        self.index = self.index + 1
        if not self.ShowQueen[self.index] then--空了需要重置index
            self.index = 1
        end
        return
    end
    self:Close()
end

function WBP_AchievementPanel_C:TriggerUnlock()
    if self.TriggerUnlockItem then
        AudioManager(self):PlayUISound(self, "event:/ui/common/achieve_toast_check", "", nil)
        self.TriggerUnlockItem:StopAllAnimations()
        self.TriggerUnlockItem:PlayAnimation(self.TriggerUnlockItem.Unlock)
    end
end

function WBP_AchievementPanel_C:CloseSelfBlend()
    if self.AchievCanvasPanel then
        self.AchievCanvasPanel:SetRenderOpacity(0)
    end
end

function WBP_AchievementPanel_C:OpenSelfBlend()
    if self.AchievCanvasPanel then
        self.AchievCanvasPanel:SetRenderOpacity(1)
    end
end

function WBP_AchievementPanel_C:StartTalk()
    -- self:CloseSelfBlend()
end

function WBP_AchievementPanel_C:EndTalk()
    -- if UE4.UGameplayStatics.GetTimeSeconds(self) - self.StartTime >= 5.0 then
    --     return
    -- end
    -- self:OpenSelfBlend()
end

function WBP_AchievementPanel_C:Show(HideTag)
    WBP_AchievementPanel_C.Super.Show(self,HideTag)
    local IsHide = not IsEmptyTable(self.HideTags)
    if (not IsHide) then
        self:Text_Title_End_Event()
    end
end

-- function WBP_AchievementPanel_C:Tick(MyGeometry,DeltaSeconds)
--     self.Overridden.Tick(self, MyGeometry,DeltaSeconds)
--     print(_G.LogTag, "ZJT_ ;;;;;;;;;;;;;;;;; ")
-- end
return WBP_AchievementPanel_C
