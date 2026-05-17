--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local AnnounceModel = AnnounceController:GetModel()

---@type WBP_Activity_Fort_ListTab_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.ListenerAdded = false
    self.Avatar = GWorld:GetAvatar()
    self.Button_Area.OnClicked:Add(self, self.OnCellClicked)
    self.Button_Area.OnHovered:Add(self, self.OnCellHovered)
    self.Button_Area.OnUnhovered:Add(self, self.OnCellUnhovered)
    self.Button_Area.OnPressed:Add(self, self.OnCellPressed)
    self.Button_Area.OnReleased:Add(self, self.OnCellReleased)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    self.ListenerAdded = false
    ReddotManager.RemoveListener("PaotaiEventNewLevel",self)
end

function M:BP_OnEntryReleased()
    if (self.Content) then
        self.Content.Entry = nil
    end
end

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.Content.Entry = self
    local PaotaiGame = self.Avatar.PaotaiGame
    self:UnBindEventOnClicked()
    if self.Content.ClickEvent then
        self:BindEventOnClicked(self.Content.ClickEvent.Obj,self.Content.ClickEvent.Func,self.Content.ClickEvent.Params)
    end
    self.Text_Num:SetText(self.Content.Id)
    self.Text_MaxScore:SetText(GText("PaotaiGame_MaxScore"))
    local CurrentTime = TimeUtils.NowTime()
    if CurrentTime < self.Content.StartTime then
        self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
        self.Text_Lock:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self:SetRefreshTimer()
        self.Content.LockReason = "Time"
    else
        self.Text_Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self:RemoveRefreshTimer()
        if self.Content.PreDungeon then
            local PrePaotaiMiniGameInfo = DataMgr.PaotaiMiniGame[self.Content.PreDungeon]
            local IsLock = false
            if PrePaotaiMiniGameInfo and PaotaiGame then
                local PaotaiGameEventInfo = PaotaiGame[self.Content.EventId]
                local PaotaiGameLevelInfo = nil
                if PaotaiGameEventInfo then
                    PaotaiGameLevelInfo = PaotaiGameEventInfo[self.Content.PreDungeon]
                end
                if PaotaiGameLevelInfo then
                    local MaxScore = PaotaiGameLevelInfo.MaxScore or 0
                    local StarNum = 0
                    for _,TargetScore in ipairs(PrePaotaiMiniGameInfo.Level) do
                        if MaxScore >= TargetScore then
                            StarNum = StarNum + 1
                        end
                    end
                    if StarNum < DataMgr.PaotaiEventConstant.PreDungeonRequiredStar.ConstantValue then
                        IsLock = true
                    end
                else
                    IsLock = true
                end
            end
            if not IsLock then
                self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
                self.Content.LockReason = nil
            else
                self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
                self.Content.LockReason = "PreDungeon"
            end
        else
            self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
            self.Content.LockReason = nil
        end
    end
    if self.Content.LockReason then
        self:PlayAnimation(self.Lock)
    else
        self:PlayAnimation(self.Normal)
    end
    self.PaotaiGameLevelInfo = nil
    if PaotaiGame then
        local PaotaiGameEventInfo = PaotaiGame[self.Content.EventId]
        if PaotaiGameEventInfo then
            self.PaotaiGameLevelInfo = PaotaiGameEventInfo[self.Content.DungeonId]
        end
    end
    local MaxScore = 0
    if self.PaotaiGameLevelInfo and self.PaotaiGameLevelInfo.MaxScore then
        MaxScore = self.PaotaiGameLevelInfo.MaxScore
    end
    self.Num_Score:SetText(MaxScore)
    local StarNum = 0
    for _,TargetScore in ipairs(self.Content.Level) do
        if MaxScore >= TargetScore then
            StarNum = StarNum + 1
        end
    end
    for i=1,3 do
        local StarSwitcher = self["WS_Star_"..i]
        if StarNum >= i then
            StarSwitcher:SetActiveWidgetIndex(1)
        else
            StarSwitcher:SetActiveWidgetIndex(0)
        end
    end

    if not self.ListenerAdded then
        self.ListenerAdded = true
        if not ReddotManager.GetTreeNode("PaotaiEventNewLevel") then
            ReddotManager.AddNodeEx("PaotaiEventNewLevel")
        end
        ReddotManager.AddListenerEx("PaotaiEventNewLevel",self,self.UpdateReddot)
    end
end

function M:RemoveRefreshTimer()
    self:RemoveTimer("CountDownTimer")
end

function M:SetRefreshTimer()
    self:AddTimer(1, self.SetTime, true, -1, "CountDownTimer", true)
end

function M:SetTime()
    if not self.Content.StartTime then
        return
    end
    local NowTime = TimeUtils.NowTime()
    if self.Content.StartTime <= NowTime then
        self:RemoveRefreshTimer()
        self:OnListItemObjectSet(self.Content)
        return
    end
    local TotalDiffTime = self.Content.StartTime - NowTime
    local DiffDay = math.floor((TotalDiffTime) / CommonConst.SECOND_IN_DAY)
    TotalDiffTime = TotalDiffTime - DiffDay * CommonConst.SECOND_IN_DAY
    local DiffHour = math.floor((TotalDiffTime) / CommonConst.SECOND_IN_HOUR)
    TotalDiffTime = TotalDiffTime - DiffHour * CommonConst.SECOND_IN_HOUR
    local DiffMin = math.floor((TotalDiffTime) / CommonConst.SECOND_IN_MINUTE)
    local TimeArgs = TArray(FFormatArgumentData)
    local FinalStr = ""
    if DiffDay > 0 then
        AnnounceModel:_AddFormatArg(TimeArgs, "DD", DiffDay)
        AnnounceModel:_AddFormatArg(TimeArgs, "H", DiffHour)
        FinalStr = UKismetTextLibrary.Format(GText("ZhiLiuEntrust_Lock_Time1"), TimeArgs)
    else
        AnnounceModel:_AddFormatArg(TimeArgs, "H", DiffHour)
        AnnounceModel:_AddFormatArg(TimeArgs, "M", DiffMin)
        FinalStr = UKismetTextLibrary.Format(GText("ZhiLiuEntrust_Lock_Time2"), TimeArgs)
    end
    self.Text_Lock:SetText(FinalStr)
end

function M:BindEventOnClicked(Obj, Func, Params)
    if not Obj or not Func then
        return
    end
    self.Obj = Obj
    self.Func = Func
    self.Params = Params
end

function M:UnBindEventOnClicked()
    self.Obj = nil
    self.Func = nil
    self.Params = nil
end

function M:OnCellClicked()
    local Ans = self:OnCellClickedWithoutSound()
    if Ans then
        AudioManager(self):PlayUISound(self, "event:/ui/common/special_content_01_click", nil, nil)
    end
end

function M:OnCellClickedWithoutSound()
    if not ReddotManager.GetTreeNode("PaotaiEventNewLevel") then
        ReddotManager.AddNodeEx("PaotaiEventNewLevel")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("PaotaiEventNewLevel")
    if CacheDetail[self.Content.DungeonId] == 1 then
        CacheDetail[self.Content.DungeonId] = 0
        ReddotManager.DecreaseLeafNodeCount("PaotaiEventNewLevel")
    end

    if self.Content.IsSelect then
        return false
    end
    if self.Content.LockReason then
        if self.Content.LockReason == "PreDungeon" then
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(DataMgr.PaotaiMiniGame[self.Content.DungeonId].LockToast))
        end
        return false
    else
        if self.Obj and self.Func then
            self.Func(self.Obj, table.unpack(self.Params))
        end
        self:StopAllAnimations()
        self:PlayAnimation(self.Click)
        return true
    end
end

function M:OnCellHovered()
    if self.Content.IsSelect then
        return
    end
    self.Hovered = true
    self:StopAnimation(self.Normal)
    self:StopAnimation(self.Lock)
    self:PlayAnimation(self.Hover)
end

function M:OnCellUnhovered()
    if self.Content.IsSelect then
        return
    end
    self.Hovered = false
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.UnHover)
    if self.Content.LockReason then
        self:PlayAnimation(self.Lock)
    else
        self:PlayAnimation(self.Normal)
    end
end

function M:OnCellPressed()
    if self.Content.IsSelect then
        return
    end
    self:PlayAnimation(self.Press)
end

function M:OnCellReleased()
    if self.Content.IsSelect then
        return
    end
    self:StopAnimation(self.Press)
    if self.Hovered then
        self:PlayAnimation(self.Hover)
    else
        if self.Content.LockReason then
            self:PlayAnimation(self.Lock)
        else
            self:PlayAnimation(self.Normal)
        end
    end
end

function M:SetSelected(IsSelect)
    self.Content.IsSelect = IsSelect
    self:StopAllAnimations()
    if IsSelect then
        --self:PlayAnimation(self.Click)
    else
        if self.Content.LockReason then
            self:PlayAnimation(self.Lock)
        else
            self:PlayAnimation(self.Normal)
        end
    end
end

function M:SelectOnGamePad()
    self:OnCellClicked()
end

function M:UpdateReddot()
    if not ReddotManager.GetTreeNode("PaotaiEventNewLevel") then
        ReddotManager.AddNodeEx("PaotaiEventNewLevel")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("PaotaiEventNewLevel")
    if CacheDetail[self.Content.DungeonId] == 1 then
        self.New:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    else
        self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

return M
