--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local WBP_Rouge_TalentMenu_P_C = Class({
    "BluePrints.Common.TimerMgr",
    "BluePrints.UI.BP_EMUserWidget_C",
})

--function M:Initialize(Initializer)
--end

--function WBP_Rouge_TalentMenu_P_C:Destruct()
--end

function WBP_Rouge_TalentMenu_P_C:Construct()
    self.LoadTalentTreeFinish = false
    local RetainerBoxCanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.RetainerBox)
    local EMScrollBoxCanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.EMScrollBox_84)
    local RetainerBoxMargin = RetainerBoxCanvasSlot:GetOffsets()
    local EMScrollBoxMargin = EMScrollBoxCanvasSlot:GetOffsets()
    self.OffsetX = RetainerBoxMargin.Left + RetainerBoxMargin.Right + EMScrollBoxMargin.Left + EMScrollBoxMargin.Right
    local RetainerBoxAnchors = RetainerBoxCanvasSlot:GetAnchors()
    self.OffsetAnchors = RetainerBoxAnchors.Minimum.X + (1-RetainerBoxAnchors.Maximum.X)
    local Avatar = GWorld:GetAvatar()
    self.Com_Cost:InitContent({ResourceId = Avatar and Avatar:GetCurrentRougeLikeTalentId(), Numerator = 1, Denominator = 1, bShowDenominator = false})
end

function WBP_Rouge_TalentMenu_P_C:Destruct()
	AudioManager(self):StopSound(self, "RougeTalentOpenSound")
end

function WBP_Rouge_TalentMenu_P_C:OnReturnKeyDown()
    local WidgetUI = self.Root:OpenSubUI("RougeTalentPage")
	self.Root.IsOpenSelectLevel = false
	WidgetUI:InitTable()
	WidgetUI:SetInfo()
	AudioManager(self):SetEventSoundParam(self,"RougeTalentOpenSound",{ToEnd=1})
end

function WBP_Rouge_TalentMenu_P_C:InitTable(SelectIndex)
    if not self.LoadTalentTreeFinish then
        self:LoadTalentTree()
        self:InitText()
        self.LoadTalentTreeFinish = true
    end
    self:RefreshTalentPoint()
	AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "RougeTalentOpenSound", nil)
    self.BranchType = {}
    for _,TalentInfo in pairs(DataMgr.RougeLikeTalent) do
        self.BranchType[TalentInfo.Branch] = true
    end
    self.Index2Branch = {}
    self.Branch2Index = {}
    for Branch,_ in pairs(self.BranchType) do
        table.insert(self.Index2Branch,Branch)
    end
    table.sort(self.Index2Branch,function(a,b)
        return a < b
    end)
    for Index,Branch in pairs(self.Index2Branch) do
        self.Branch2Index[Branch] = Index
    end
    self.AllTabInfo = {}
    for Branch,_ in ipairs(self.Index2Branch) do
        local NewTabInfo = {}
        NewTabInfo.Text = GText(DataMgr.RougeLikeTalentBranch[Branch].Name)
        NewTabInfo.IconPath = DataMgr.RougeLikeTalentBranch[Branch].Icon
        NewTabInfo.TabId = Branch
        NewTabInfo.Callback = "ChangeBranch"
        NewTabInfo.ItemDefaultCapcity = 999
        table.insert(self.AllTabInfo, NewTabInfo)
    end

    self:SetTabReddot()

    self.TabConfigData = {
        TitleName=GText("System_Name_Rouge_TalentTree"),
        LeftKey="Q", RightKey="E", Tabs=self.AllTabInfo, 
        DynamicNode={"Back", "ResourceBar", "BottomKey"}, 
        StyleName="TextImage", OwnerPanel=self, BackCallback=self.OnReturnKeyDown,
        BottomKeyInfo = {
            {
                KeyInfoList = {{Type="Text", Text="Space", ClickCallback=self.OnSpaceKeyDown, Owner=self,}},
                Desc = GText("UI_Rouge_Talent_Shortcut"),
                bLongPress = false
            },
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.OnReturnKeyDown, Owner=self,}},
                GamePadInfoList = {{Type="Img", ImgShortPath="B"}},
                Desc = GText("UI_BACK"),
                bLongPress = false
            }
        },
    }
    local ResoucesTab = DataMgr.SystemUI["RougeTalentMenu"].TabCoin
    self.Root:InitOtherPageTab(self.TabConfigData, ResoucesTab, true, self, self.ChangeBranch)
    self.Root:SelectTab(SelectIndex)
end

function WBP_Rouge_TalentMenu_P_C:SetTabReddot()
    self.RougeTalent = DataMgr.RougeLikeTalent
    self.Lines = {}
    self.ReachableTable = {}
    self.ReddotCondition = {}
    self.AllActiveTalent = {}
    for Branch, Index in pairs(self.Branch2Index) do
        self.ReddotCondition[Branch] = false
    end
    for TalentId, RougeTalentInfo in pairs(self.RougeTalent) do
        if RougeTalentInfo.UnLock then
            for _, PostTalentId in pairs(RougeTalentInfo.UnLock) do
                if not self.Lines[PostTalentId] then
                    self.Lines[PostTalentId] = {}
                end
                self.Lines[PostTalentId][TalentId] = 1
            end
        end
    end
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        self.AllActiveTalent = Avatar.RougeLike.Talent
    end
    for TalentId, RougeTalentInfo in pairs(self.RougeTalent) do
        if not self.ReddotCondition[RougeTalentInfo.Branch] then
            if self:CheckReachable(TalentId) then
                if not self.AllActiveTalent[TalentId] then
                    self.ReddotCondition[RougeTalentInfo.Branch] = true
                end
            end
        end
    end
    for Branch, Reddot in pairs(self.ReddotCondition) do
        local Index = self.Branch2Index[Branch]
        self.AllTabInfo[Index].ShowRedDot = Reddot
    end
end

function WBP_Rouge_TalentMenu_P_C:UpdateTabReddot()
    self:SetTabReddot()
    local Item = UIManager(self):GetUIObj("StyleOfPlay")
    for Index, Info in pairs(self.AllTabInfo) do
        Item.ComTab.Tabs[Index].ShowRedDot = Info.ShowRedDot
        Item.ComTab.Tabs[Index].Upgradeable = Info.ShowRedDot
    end
    Item.ComTab:UpdateReddots()
end

function WBP_Rouge_TalentMenu_P_C:CheckReachable(TalentId)
	if self.ReachableTable[TalentId] == 1 then
        return true
    elseif self.ReachableTable[TalentId] == 0 then
        return false
    end
    if self.AllActiveTalent[TalentId] then
        self.ReachableTable[TalentId] = 1
        return true
    end
    if self.Lines[TalentId] then
        for FrontTalentId, _ in pairs(self.Lines[TalentId]) do
            if not self:CheckReachable(FrontTalentId) then
                self.ReachableTable[TalentId] = 0
                return false
            end
        end
    end
    if self.RemainingTalentPoint >= self.RougeTalent[TalentId].LevelUpPoint then
        self.ReachableTable[TalentId] = 1
        return true
    else
        self.ReachableTable[TalentId] = 0
        return false
    end
end

function WBP_Rouge_TalentMenu_P_C:ChangeBranch(WidgetInfo, TabsInfo)
    local Branch = self.Index2Branch[WidgetInfo.Idx]
    local CurActiveTalent, CurSumTalent = self.TalentTree:ChangeBranch(Branch)
    self:RefreshActivedTalentNumAndIcon(CurActiveTalent, CurSumTalent, Branch)
    if not self:IsAnimationPlaying(self.In) then
        self:PlayAnimation(self.Switch_Tab)
    end
    -- if self.TipsId then
    --     self.TipsId = nil
    --     self.VerticalBox_1:SetVisibility(UE4.ESlateVisibility.Collapsed)
    --     self:PlayAnimation(self.Tips_Out)
    -- end
end

-- function WBP_Rouge_TalentMenu_P_C:ScrollToPoint(Id)
--     if not self.BottomOffset then
--         self.EMScrollBox_84:ScrollToEnd()
--         self:AddTimer(0.001,function()
--             self.BottomOffset = self.EMScrollBox_84:GetScrollOffset()
--             local ViewportSize = UWidgetLayoutLibrary.GetViewportSize(self)
--             local ViewportScale = UWidgetLayoutLibrary.GetViewportScale(self)
--             UE.UKismetSystemLibrary.PrintString(self,"gyy BottomOffset:"..self.BottomOffset)
--             UE.UKismetSystemLibrary.PrintString(self,"gyy ViewportSizeX:"..ViewportSize.X)
--             UE.UKismetSystemLibrary.PrintString(self,"gyy ViewportScale:"..ViewportScale)
--             local Length = self.TalentTree.FarthestX - self.TalentTree.ShortestX
--             self.EMScrollBox_84:SetScrollOffset(self.BottomOffset*(self.TalentTree.Points[Id].Data.IconLoc[1]/Length))
--         end,false,0,nil,true)
--     else

--     end
-- end

function WBP_Rouge_TalentMenu_P_C:ScrollToPoint(Id)
    local ViewportSize = UWidgetLayoutLibrary.GetViewportSize(self)
    local ViewportScale = UWidgetLayoutLibrary.GetViewportScale(self)
    local SizeX = ViewportSize.X/ViewportScale*(1-self.OffsetAnchors) - self.OffsetX
    local FullSizeX = self.TalentTree:GetFullSizeX()
    local BottomOffset = FullSizeX - SizeX
    if BottomOffset <= 0 then
        self.EMScrollBox_84:ScrollToStart()
    else
        local TargetOffset = 0
        if self.TalentTree.Points[Id].Data.IconLoc[1] < SizeX/2 then
            TargetOffset = 0
            --self.EMScrollBox_84:ScrollToStart()
        elseif self.TalentTree.Points[Id].Data.IconLoc[1] > FullSizeX-SizeX/2 then
            TargetOffset = BottomOffset
            --self.EMScrollBox_84:ScrollToEnd()
        else
            TargetOffset = self.TalentTree.Points[Id].Data.IconLoc[1]-SizeX/2
            --self:SetScrollOffset_Lerp(self.TalentTree.Points[Id].Data.IconLoc[1]-SizeX/2)
        end
        self:SetScrollOffset_Lerp(TargetOffset)
    end
end

function WBP_Rouge_TalentMenu_P_C:SetScrollOffset_Lerp(TargetOffset)
    local ChangeSpeed = 3
    local CurrentOffset = self.EMScrollBox_84:GetScrollOffset()
    self.LerpAlpha = 0
    self:RemoveTimer(self.ScrollTimer)
    self.ScrollTimer = self:AddTimer(0.033,function(_,DeltaTime)
        self.LerpAlpha = self.LerpAlpha + ChangeSpeed * DeltaTime
        if(self.LerpAlpha >= 1)then
            self.LerpAlpha = 1
            self.EMScrollBox_84:SetScrollOffset(TargetOffset)
            -- self:ScrolledTo(TargetOffset)
            -- self.ScrollBox:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            self:RemoveTimer(self.ScrollTimer)
            self.ScrollTimer = nil
            return
        end
        local Offset = UE4.UKismetMathLibrary.Lerp(CurrentOffset,TargetOffset,self.LerpAlpha)
        self.EMScrollBox_84:SetScrollOffset(Offset)
        --self:ScrolledTo(Offset)
    end, true, 0, "UpdateOffset", true, 0.033)
end

function WBP_Rouge_TalentMenu_P_C:LoadTalentTree()
    local Path = "/Game/UI/WBP/RougeLike/Widget/TalentTree/WBP_Rouge_TalentTree.WBP_Rouge_TalentTree"
    self.TalentTree = UIManager(self):CreateWidget(Path, false)
    self.EMScrollBox_84:AddChild(self.TalentTree)
    self.TalentTree.Parent = self
    self.TalentTree:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function WBP_Rouge_TalentMenu_P_C:InitText()
    self.WorldText01:SetText(EnText("UI_Rouge_Talent_HaveActive_World"))
    self.Text_Activated:SetText(GText("UI_Rouge_Talent_HaveActive"))
    --self.Btn_Active:SetKeyPanelVisibility(UE4.ESlateVisibility.Collapsed)
    self.Btn_Active:BindEventOnClicked(self, self.ActiveTalent)
    self.Btn_Active:BindForbidStateExecuteEvent(self, self.ActiveTalent)
    self.Btn_Active:SetText(GText("UI_Rouge_Talent_ActiveBtn"))
    self.Btn_Active:SetDefaultGamePadImg("A")
end

function WBP_Rouge_TalentMenu_P_C:OpenTips(Id, DoNotPlayAnimation)
    self.Switch_Btn:SetActiveWidgetIndex(0)
    if not DoNotPlayAnimation then
        self:PlayAnimation(self.Tips_In)
    else
        self.TalentTree.Points[Id]:SetFocus()
        self:ScrollToPoint(Id)
    end
    local RougeTalentInfo = DataMgr.RougeLikeTalent[Id]
    self.Text_TalentName:SetText(GText(RougeTalentInfo.Name))
    local Desc=UIUtils.GenRougeTalentDesc(Id)
    self.Text_Describe:SetText(Desc)
    self.TipsId = Id
    self:RefreshTalentPoint()
end

function WBP_Rouge_TalentMenu_P_C:ActiveTalent()
    -- if self.TalentTree:CheckIsActive(self.TipsId) then
    --     return
    -- end
    -- local Avatar = GWorld:GetAvatar()
    -- local UIManager = GWorld.GameInstance:GetGameUIManager()
    -- if Avatar and Avatar:IsRougeLikeInProgress() then
    --     UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("UI_Rou_Toast_27022"))
    -- else
    --     local RougeLikeTalent = DataMgr.RougeLikeTalent
    --     local RougeTalentInfo = RougeLikeTalent[self.TipsId]
    --     if not self.TalentTree:CheckCanActive(self.TipsId) then
    --         UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("UI_Rou_Toast_27021"))
    --     elseif self.RemainingTalentPoint < RougeTalentInfo.LevelUpPoint then
    --         UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("UI_Rou_Toast_27020"))
    --     else
    --         self.TalentTree:ActiveTalent(self.TipsId)
    --     end
    -- end
    if self.TalentTree:CheckIsActive(self.TipsId) then
        return
    end
    local Avatar = GWorld:GetAvatar()
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local RougeLikeTalent = DataMgr.RougeLikeTalent
    local RougeTalentInfo = RougeLikeTalent[self.TipsId]
    if not self.TalentTree:CheckCanActive(self.TipsId) then
        UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("UI_Rou_Toast_27021"))
    elseif self.RemainingTalentPoint < RougeTalentInfo.LevelUpPoint then
        UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("UI_Rou_Toast_27020"))
    else
        if not Avatar then
            return
        end
        if Avatar:IsRougeLikeInProgress() then
            UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("UI_Rou_Toast_27022"))
        else
            self.TalentTree:ActiveTalent(self.TipsId)
        end
    end
end

function WBP_Rouge_TalentMenu_P_C:GetCurPoint()
    if self.TipsId then
        return self.TalentTree:GetPoint(self.TipsId)
    end
end

function WBP_Rouge_TalentMenu_P_C:RefreshTalentPoint()
    local RougeLikeTalent = DataMgr.RougeLikeTalent
    local Avatar = GWorld:GetAvatar()
    -- local TalentPoint = 0
    -- local ConsumedTalentPoint = 0
    -- local Talent = {}
    -- if Avatar then
    --     TalentPoint = Avatar:GetResourceNum(CommonConst.RougeLikeTalent)
    --     Talent = Avatar.RougeLike.Talent
    -- end
    -- for Id,Level in pairs(Talent) do
    --     ConsumedTalentPoint = ConsumedTalentPoint + RougeLikeTalent[Id].LevelUpPoint * Level
    -- end
    -- self.RemainingTalentPoint = TalentPoint - ConsumedTalentPoint
    if Avatar then
        self.RemainingTalentPoint = Avatar:GetCurrentRougeLikeTalent()
    else
        self.RemainingTalentPoint = 0
    end
    if self.TipsId then
        local RougeTalentInfo = RougeLikeTalent[self.TipsId]
        local IconPath=RougeTalentInfo.Icon
        if IconPath then
            local image=LoadObject(IconPath)
            if image then
                self.Icon_Slot:SetBrushFromTexture(image,true)
            end
        end
        --self.Com_Cost:InitContent({ResourceId = Avatar and Avatar:GetCurrentRougeLikeTalentId(), Numerator = RougeTalentInfo.LevelUpPoint, Denominator = self.RemainingTalentPoint, bShowDenominator = false})
        self.Com_Cost:SetCost(self.RemainingTalentPoint, RougeTalentInfo.LevelUpPoint)
        self.Com_Cost:SetIsEnough(self.RemainingTalentPoint>=RougeTalentInfo.LevelUpPoint)
        self.Com_Cost:SetGamePadIconVisible(false)
        self.Btn_Active.IsForbidden = false


        if self.TalentTree:CheckIsActive(self.TipsId) then
            self.Switch_Btn:SetActiveWidgetIndex(1)
            self.Hint.WidgetSwitcher_State:SetActiveWidgetIndex(1)
            self.Hint.Text_Hint_Positive:SetText(GText("UI_Rouge_Talent_HaveActive"))
        elseif not self.TalentTree:CheckCanActive(self.TipsId) then
            self.Switch_Btn:SetActiveWidgetIndex(1)
            self.Hint.WidgetSwitcher_State:SetActiveWidgetIndex(2)
            self.Hint.Text_Hint_Locked:SetText(GText("UI_Rouge_Talent_NeedFront"))
        elseif self.RemainingTalentPoint < RougeTalentInfo.LevelUpPoint then
            self.Btn_Active.IsForbidden = true
            self.Switch_Btn:SetActiveWidgetIndex(0)
            self.Btn_Active:SetText(GText("UI_Rouge_Talent_ActiveBtn"))
        else
            if Avatar:IsRougeLikeInProgress() then
                self.Switch_Btn:SetActiveWidgetIndex(1)
                self.Hint.WidgetSwitcher_State:SetActiveWidgetIndex(2)
                self.Hint.Text_Hint_Locked:SetText(GText("UI_Rouge_Talent_CantActive"))
            else
                self.Switch_Btn:SetActiveWidgetIndex(0)
                self.Btn_Active:SetText(GText("UI_Rouge_Talent_ActiveBtn"))
            end
        end
        if self.Btn_Active.IsForbidden then
            self.Btn_Active:PlayAnimationForward(self.Btn_Active.Forbidden)
        else
            self.Btn_Active:PlayAnimationForward(self.Btn_Active.Normal)
        end
    end
end

function WBP_Rouge_TalentMenu_P_C:RefreshActivedTalentNumAndIcon(CurActiveTalent, CurSumTalent, BranchId)
    local IconPath=DataMgr.RougeLikeTalentBranch[BranchId].Icon
    if IconPath then
        local image=LoadObject(IconPath)
        if image then
            self.Icon_Type:SetBrushFromTexture(image,true)
        end
    end
    self.Text_TalentType:SetText(GText(DataMgr.RougeLikeTalentBranch[BranchId].Name))
    if CurActiveTalent then
        self.Text_Has:SetText(CurActiveTalent)
    end
    if CurSumTalent then
        self.Text_All:SetText(CurSumTalent)
    end
    local SlateColor = FSlateColor()
    if CurActiveTalent == CurSumTalent then
        SlateColor.SpecifiedColor = self.Color_Max
    else
        SlateColor.SpecifiedColor = self.Color_Normal
    end
    self.Text_Has:SetColorAndOpacity(SlateColor)
    self.Text_All:SetColorAndOpacity(SlateColor)
    self.Text_Split:SetColorAndOpacity(SlateColor)
end

function WBP_Rouge_TalentMenu_P_C:OnSpaceKeyDown()
    if self.TipsId then
        self:ActiveTalent()
    end
end

function WBP_Rouge_TalentMenu_P_C:SetVisibility(InVisibility)
    self.Overridden.SetVisibility(self,InVisibility)
    self.EMScrollBox_84:SetVisibility(InVisibility)
end

function WBP_Rouge_TalentMenu_P_C:HandleKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then

    else
        if (InKeyName == "Escape") then
            IsEventHandled = true
            self:OnReturnKeyDown()
        end
    end
    return IsEventHandled
end

function WBP_Rouge_TalentMenu_P_C:HandlePreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then

    else
        if (InKeyName == "SpaceBar") then
            IsEventHandled = true
            self:OnSpaceKeyDown()
        end
    end
    return IsEventHandled
end

return WBP_Rouge_TalentMenu_P_C
