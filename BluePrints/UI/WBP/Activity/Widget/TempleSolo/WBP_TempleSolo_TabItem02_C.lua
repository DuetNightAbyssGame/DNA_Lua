--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_Temple_Solo_Tab02_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Btn_Click.OnClicked:Add(self, self.OnButtonClicked)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    ReddotManager.RemoveListener("TempleSoloNewLevel",self)
end

function M:OnListItemObjectSet(Content)
    self:Init(Content)
    self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)

    if not self.ListenerAdded then
        self.ListenerAdded = true
        if not ReddotManager.GetTreeNode("TempleSoloNewLevel") then
            ReddotManager.AddNodeEx("TempleSoloNewLevel")
        end
        ReddotManager.AddListenerEx("TempleSoloNewLevel",self,self.UpdateReddot)
    end
end

function M:Init(Content)
    self.Content = Content
    self.TempleId = Content.TempleId
    self.TempleTypeId = Content.TempleTypeId
    self.IsHardMode = Content.IsHardMode
    self.Level = Content.Level
    self.Parent = Content.Parent
    self.EventId = Content.EventId
    self.State = "Received"
    self.IsSelected = false

    self.Text_Num:SetText(tostring(Content.Level))
    self.Text_Num_Hover:SetText(tostring(Content.Level))
    if self.IsHardMode then
        self.Panel_Challenge:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Text_Challenge:SetText(GText("UI_TempleEvent_HardModeShort"))
    else
        self.Panel_Challenge:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self.TEMPLE_TYPE_COLOR = {
        [1080011] = "Red",
        [1080012] = "Blue",
        [1080013] = "Yellow",
    }
    self:SetColor()
    self:SetState(self.TempleId)

    if Content.DelaySelected then
        self:SetSelected(true)
    end
end

function M:SetState(TempleId)
    if not TempleId then
        TempleId = self.TempleId
    end
    self.State = "Received"
    local TempleLevelConf = DataMgr.TempleEventLevel[TempleId]
    local PreDungeon = TempleLevelConf.PreDungeon
    if not TempleLevelConf then return end
    local UnlockTime = TempleLevelConf.UnlockDate
    if UnlockTime and UnlockTime > TimeUtils.NowTime() then
        self.State = "Lock"
    elseif not self.Parent:CheckPreDungeonPass(PreDungeon) then
        self.State = "Lock"
    else
        local Avatar = GWorld:GetAvatar()
        if Avatar and Avatar.Temple[self.EventId] then
            local IsMaxStar = Avatar.Temple[self.EventId].FinishStars[TempleId] or 0
            if self.IsHardMode then
                if IsMaxStar == 3 then
                    self.State = "Clear"
                end
            elseif IsMaxStar == 3 then
                self.State = "Clear"
            end
        end
    end
    self:PlayAnimation(self[self.State])
    self:TryIncreaceTempleSoloNewLevelReddot()
end

function M:OnButtonClicked()
    if self.IsSelected then return end
    self.IsSelected = true
    self.Parent:OnSubTabItemClicked(self.Content)
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
    if not self.IsSelected then
        self:PlayAnimation(self.Hover)
        self.IsHoverState = true
    end
end

function M:OnMouseLeave(MouseEvent)
    if not self.IsSelected and self.IsHoverState then
        self:PlayAnimation(self.UnHover)
        self.IsHoverState = false
    end
end

function M:SetSelected(bIsSelected)
    if bIsSelected then
        self.IsSelected = true
        self:StopAllAnimations()
        if self.State == "Lock" then
            self:PlayAnimation(self.Lock_Click)
        else
            self:PlayAnimation(self.Click)
        end

        if not ReddotManager.GetTreeNode("TempleSoloNewLevel") then
            ReddotManager.AddNodeEx("TempleSoloNewLevel")
        end
        local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("TempleSoloNewLevel")
        if CacheDetail[self.Content.TempleId] == 1 then
            CacheDetail[self.Content.TempleId] = 0
            ReddotManager.DecreaseLeafNodeCount("TempleSoloNewLevel")

            --这里概率没有触发tabitem01的updatereddot
            local CurWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.Parent.List_Tab, self.Parent.List_Tab:GetIndexForItem(self.Parent.CurrentSelectTabContent))
            if CurWidget then
                CurWidget:UpdateReddot()
            end
            self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    else
        self.IsSelected = false
        self:PlayAnimation(self.Normal)
        self:AddTimer(0.01, function()
            self:PlayAnimation(self[self.State])
        end)
    end
end

function M:SetColor()
    local Color = self.TEMPLE_TYPE_COLOR[self.TempleTypeId]
    self.Text_Num:SetColorAndOpacity(self["Color_"..Color])
    self.Text_Challenge:SetColorAndOpacity(self["Color_"..Color])

    self.BG_VX_Click_1:SetBrushTintColor(self["Color_"..Color])
    self.BG_VX_Glow:SetBrushTintColor(self["Color_"..Color])
    self.BG_VX_Glow_1:SetBrushTintColor(self["Color_"..Color])

    local BoxMT = self.RetainerBox_0:GetEffectMaterial()
    if BoxMT then
        BoxMT:SetVectorParameterValue("MainColor", self["Color_"..Color].SpecifiedColor)
    end
end

function M:UpdateReddot()
    if not ReddotManager.GetTreeNode("TempleSoloNewLevel") then
        ReddotManager.AddNodeEx("TempleSoloNewLevel")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("TempleSoloNewLevel")
    if CacheDetail[self.Content.TempleId] == 1 then
        self.New:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    else
        self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:TryIncreaceTempleSoloNewLevelReddot()
    if not ReddotManager.GetTreeNode("TempleSoloNewLevel") then
        ReddotManager.AddNodeEx("TempleSoloNewLevel")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("TempleSoloNewLevel")
    if not CacheDetail[self.Content.TempleId] and self.State ~= "Lock" then
        CacheDetail[self.Content.TempleId] = 1
        ReddotManager.IncreaseLeafNodeCount("TempleSoloNewLevel")
        self.New:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    end
end

return M
