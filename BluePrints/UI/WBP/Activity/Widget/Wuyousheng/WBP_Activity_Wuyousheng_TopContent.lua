--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_Wuyousheng_HUD_TipsContent_C
local M =Class("BluePrints.UI.BP_EMDungeonWidget_C")

function M:InitDungeonWidget()
    M.Super.InitDungeonWidget(self)
    self:AddToBattleMain("Pos_WuyoushengTips","Overlay")

    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local TextPrefix, CurNum, MaxNum, IsVisible = GameMode:TriggerDungeonComponentFun("GetTopContent")
    self:OnShowWuyoushengTop(TextPrefix, IsVisible)
    self:OnRepWuyoushengTop(CurNum, MaxNum)

    self:InitPetIcon()
    self:SetTipVisibility(false)
    
    -- 初始化动画队列
    self.LevelUpQueue = {}
    self.bIsPlayingAnimation = false
end

function M:InitListenEvent()
    M.Super.InitListenEvent(self)
    self:AddDispatcher(EventID.OnRepWuyoushengTop, self, self.OnRepWuyoushengTop)
    self:AddDispatcher(EventID.OnWuyoushengLevelUp, self, self.OnWuyoushengLevelUp)
    self:AddDispatcher(EventID.OnShowWuyoushengTop, self, self.OnShowWuyoushengTop)
    self:BindToAnimationFinished(self.Tips_In,{self, self.OnTipsInAnimationFinished})
    self:BindToAnimationFinished(self.Tips_Out,{self, self.OnTipsOutAnimationFinished})
end

function M:Destruct()
    M.Super.Destruct(self)
    self:UnbindAllFromAnimationFinished(self.Tips_In)
    self:UnbindAllFromAnimationFinished(self.Tips_Out)
end

function M:OnShowWuyoushengTop(Text, IsVisible)
    self.TextPrefix = Text
    if IsVisible then
        if self.IsShow then return end
        self.IsShow = true
        self:SetTopProgressVisibility(true)
        self:PlayAnimation(self.In)
    else
        if self.IsShow == nil then          -- 为nil说明是初始化，这时不用播Out动效
            self:SetTopProgressVisibility(false)
            return
        elseif self.IsShow == false then    -- 已经是false 无需处理
            return
        end
        self:BindToAnimationFinished(self.Out, function()
            self:SetTopProgressVisibility(false)
        end)
        self:PlayAnimation(self.Out)
        self.IsShow = false
    end
end

function M:OnRepWuyoushengTop(CurNum, MaxNum)
    local DisplayText = GText(self.TextPrefix)..CurNum.."/"..MaxNum
    self.Text_TipsProgressTitle:SetText(DisplayText)

    local Percent = CurNum / MaxNum
    self.Image_ProgressBar:SetPercent(Percent)
 
    local PointSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.PointAnchor)
    local Position = PointSlot:GetPosition()
    Position.X = self.Group_ProgressBar.WidthOverride * Percent
    PointSlot:SetPosition(Position)
end

function M:InitPetIcon()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local DungeonId = GameState and GameState.DungeonId or 0
    local EventId = DataMgr.WuyoushengEventLevel[DungeonId].EventId
    local Avatar = GWorld:GetAvatar()
    if DungeonId and EventId then
        local Avatar = GWorld:GetAvatar()
        if Avatar and Avatar.WuyoushengActivity then
            local WuyoushengData = Avatar.WuyoushengActivity[EventId]
            if WuyoushengData then
                local SavedSquad = WuyoushengData:GetSquadInfo(DungeonId)
                local PetId = SavedSquad.Pet.Id
                self.PetId = PetId
                if PetId then
                    local BattlePetInfo = DataMgr.BattlePet[PetId]
                    local SkillInfo = DataMgr.Skill[BattlePetInfo.SupportSkillId]
                    local IconName = SkillInfo[1][0].SkillBtnIcon
                    if(IconName)then
                        local Icon = LoadObject("/Game/UI/Texture/Dynamic/Atlas/Skill/T_"..IconName..".T_"..IconName)
                        local IconDynaMaterial = self.Image_Icon:GetDynamicMaterial()
                        if(IconDynaMaterial)then
                            IconDynaMaterial:SetTextureParameterValue("Mask", Icon)
                        end
                    end
                end
            end
        end
    end
end

function M:OnWuyoushengLevelUp(Level)
    -- 如果正在播放动画（Tips_In 或 Tips_Out），将升级信息加入队列
    if self.bIsPlayingAnimation or self:IsAnimationPlaying(self.Tips_In) or self:IsAnimationPlaying(self.Tips_Out) then
        table.insert(self.LevelUpQueue, Level)
        return
    end
    
    -- 立即播放升级动画
    self:PlayLevelUpAnimation(Level)
    AudioManager(self):PlayUISound(self, "event:/ui/activity/wuyoudaguai_toast_pet_upgrade", nil, nil)
end

function M:PlayLevelUpAnimation(Level)
    self.bIsPlayingAnimation = true
    self:SetTipVisibility(true)
    self:PlayAnimation(self.Tips_In)
    self.Text_TipsDetailTitle:SetText(GText("UI_WuyoushengEvent_LvUp") .. "Lv." .. Level)
    local DetailText = DataMgr.Pet[self.PetId].WysSkillDesLv[Level]
    self.Text_TipsDetail:SetText(GText(DetailText))
end

function M:SetTopProgressVisibility(IsVisible)
    if IsVisible then
        self.Group_TipsProgress:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Group_TipsProgress:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:SetTipVisibility(IsVisible)
    if IsVisible then
        self.Group_Tips:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Group_Tips:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:OnTipsOutAnimationFinished()
    self:SetTipVisibility(false)
    self.bIsPlayingAnimation = false
    
    -- 检查队列中是否有待播放的升级动画
    if #self.LevelUpQueue > 0 then
        local NextLevel = table.remove(self.LevelUpQueue, 1)
        -- 延迟一小段时间再播放下一个，确保Out动画完全结束
        self:AddTimer(0.1, function()
            self:PlayLevelUpAnimation(NextLevel)
        end)
    end
end

function M:OnTipsInAnimationFinished()
    self:AddTimer(1, function()
        self:PlayAnimation(self.Tips_Out)
    end)
end

return M
