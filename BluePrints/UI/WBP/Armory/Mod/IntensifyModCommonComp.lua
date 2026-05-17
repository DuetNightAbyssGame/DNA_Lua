local ModModel = ModController:GetModel()

--Mod养成会用到的一些公共方法
local Component = {}
local ModOriginPos = nil


function Component:UpdateTopResourceBar()
    local Level = self.Target.Level
    if Level == 0 then Level = 1 end
    local ResInfo = {}
    for Key, Val in pairs(DataMgr.ModLevel[Level].ConsumeRarity[self.Target.Rarity]) do
        table.insert(ResInfo, Key)
    end
    self.Tab_Intensify:OverrideTopResource(ResInfo,true)
end

function Component:OnViewportSizeChanged_Mod()
    local PanelModSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Panel_Mod)
    if ModController.CurrUIName == ModCommon.ArmoryMod then 
        local VPScale = UWidgetLayoutLibrary.GetViewportScale(self)
        local VPSize = UWidgetLayoutLibrary.GetViewportSize(self)/VPScale
        local ModAttachVPos = ModController:GetModAttachBoneVPos()/VPScale
        ModAttachVPos.X = ModAttachVPos.X-VPSize.X*0.5
        ModAttachVPos.Y = ModAttachVPos.Y-VPSize.Y*0.5
        PanelModSlot:SetPosition(ModAttachVPos)
    elseif ModOriginPos then
        PanelModSlot:SetPosition(ModOriginPos)
    end
end

function Component:PlayModUICameraAnim()
    if not ModOriginPos then
        local PanelModSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Panel_Mod)
        ModOriginPos = PanelModSlot:GetPosition()
    end
    self:AddDispatcher(EventID.GameViewportSizeChanged, self, self.OnViewportSizeChanged_Mod)
    ModController:SetUICamera(self.ModCameraOffset)
    local TotalTime,Interval,MaxTime, MaxSameCount = 0, 0.03, 3, 100
    local CameraMgr = UGameplayStatics.GetPlayerCameraManager(self, 0)
    local LastCameraLoc = nil
    local SameCount = 0
    local _, Ticker = self:AddTimer(Interval, function()
        local NowCameraLoc = CameraMgr:GetCameraLocation()
        if LastCameraLoc and LastCameraLoc == NowCameraLoc then
            SameCount = SameCount + 1
        end
        if TotalTime >= MaxTime or SameCount>=MaxSameCount then
            self:RemoveTimer(self.PanelModTicker)
            return
        end
        LastCameraLoc = NowCameraLoc
        self:OnViewportSizeChanged_Mod()
        TotalTime = TotalTime + Interval
    end, true, 0, nil, true)
    self.PanelModTicker = Ticker
end

function Component:SetModDataUI()
    local ModIconPath = self.Target:Data().Icon
    UResourceLibrary.LoadObjectAsync(self, ModIconPath, {self, function(_, Icon)
        self.Icon_Mod:SetBrushResourceObject(Icon)
    end})
    
    self.TextBlock_Name:SetText(self.Target:GetName())
    self.ListView_Star:SetVisibility(UIConst.VisibilityOp.Collapsed)
    --self:SetStars(self.Target.Rarity)
    local WidgetPath = ""
    if ModController.CurrUIName == ModCommon.AbyssMod then
        WidgetPath = "/Game/UI/WBP/Abyss/Widget/WBP_Abyss_Mod_bg.WBP_Abyss_Mod_bg_C"
    elseif ModController.CurrUIName == ModCommon.Wuyousheng then
        WidgetPath = "/Game/UI/WBP/Activity/Widget/Wuyousheng/WBP_Activity_Wuyousheng_BG03.WBP_Activity_Wuyousheng_BG03"
    end
    if ModController.CurrUIName ~= ModCommon.ArmoryMod then
        self.AbyssBg = UIManager():CreateWidget(WidgetPath)
        self.BackGround:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.BackGround.background_blur:GetParent():AddChild(self.AbyssBg)
        local Slot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.AbyssBg)
        local Anchors = FAnchors()
        Anchors.Minimum = FVector2D(0,0)
        Anchors.Maximum = FVector2D(1,1)
        Slot:SetAnchors(Anchors)
        Slot:SetOffsets(FMargin(0,0,0,0))
    end
    self.Panel_Info:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function Component:UpdateAttrListUI(Attrs, ComparedAttrs, Level)
    ModModel:UpdateModAttrListForIntensify(Attrs, ComparedAttrs, self.Target, Level)
end

function Component:UpdateModCostUI(Attrs, ComparedAttrs, Level)
    self.bTakeOff = ModModel:UpdateModCostPreviewForIntensify(Attrs, ComparedAttrs, self.Target, Level)
    if self.bTakeOff then
        self.WidgetSwitcher_Hint:SetVisibility(UIConst.VisibilityOp.Visible)
        self:ShowWarning(GText("UI_Mod_Cost_Overflow"))
    else
        self.WidgetSwitcher_Hint:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self:ShowWarning(false)
    end
end

function Component:CloseForModCommon()
    ModController:UnRegisterEvent(self)
    ModController:SetUICamera(FVector(0,0,0))
    local SelectStuff = ModModel:GetSelectStuff()
    if SelectStuff then
        ModController:SetSelectedStuff(nil,nil)
        ModController:SetSelectedStuff(SelectStuff.ModUuid, SelectStuff.SlotId)
    end
    if IsValid(self.AbyssBg) then
        self.AbyssBg:RemoveFromParent()
        self.AbyssBg = nil
    end
end

return Component