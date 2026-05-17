require "UnLua"
---@class BP_HeadWidgetComponent_C
local BP_HeadWidgetComponent_C = Class("BluePrints.Common.TimerMgr")
local TaskUtils = require "BluePrints.UI.TaskPanel.TaskUtils"
local Const = require "Const"

---
---
---


function BP_HeadWidgetComponent_C:Initialize(Initializer)
    self.OwnerLocation = nil
    self.State = 0
end

function BP_HeadWidgetComponent_C:ReceiveBeginPlay()
    --self.OcclusionTestIntervel = 1
    self.Owner = self:GetOwner()
    if self.Owner.Eid then
        UIManager(self):AddWidgetComponentToList(self.Owner.Eid, "NPCHeadWidget", self) 
    else
        UIManager(self):AddWidgetComponentToList(self.Owner, "NPCHeadWidget", self) 
    end

    self.Overridden.ReceiveBeginPlay(self)
end

function BP_HeadWidgetComponent_C:ReceiveEndPlay(EndPlayReason)
    UIManager(self):RemoveWidgetComponentToList(self.Owner.Eid, "NPCHeadWidget")
    self:TryReleaseWidgetInternal()
    self.Owner = nil
end


-- function BP_HeadWidgetComponent_C:UnsetAttachedWidget(Widget)
--     Widget.AttachedWidgetComponent = nil
-- end

-- function BP_HeadWidgetComponent_C:GetOrCreateWidget(WidgetName)
--     -- if not self:CheckCanGetWidget(WidgetName) then
--     --     --- 之前芃黍改过后本质上永远为True了，已经跑了好久了，先直接注释了
--     --     return
--     -- end
--     --DebugPrint("GetOrCreateWidget", self.ReleaseTimer ,self:GetOwner():GetName())
--     -- if self.ReleaseTimer then
--     --     self:RemoveTimer(self.ReleaseTimer)
--     --     self.ReleaseTimer = nil
--     -- end
--     return self.Overridden.GetOrCreateWidget(self, WidgetName)

--     --[[
--     local Widget = self:GetWidget()
--     if IsValid(Widget) then
--         return Widget
--     end

--     local HeadUISubsystem = UNpcHeadUISubsystem.GetHeadUISubsystem(self)
--     if HeadUISubsystem then
--         Widget = HeadUISubsystem:TryGetHeadWidget(self)
--     end
--     if not Widget then
--         local Title = "获取头顶UI失败"
--         local Message = string.format("HeadWidgetComponent获取头顶Widget时失败 NPCId:%d", self:GetOwner().NpcId)
--         UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.NPC, Title, Message)
--         return
--     end

--     if self.bIsRegionPlayerHeadUI or self:GetOwner():IsA(UE4.APlayerCharacter) then
--         local bScale, MinScale, MaxScale, MinScaleDis, MaxScaleDis = Widget:GetTotalWidgetScaleParams()
--         self:AddDistanceTestInfo(Widget.VB, MinScale, MaxScale, MinScaleDis, MaxScaleDis)
--     end

--     Widget:InitSubWidgets()
--     self:SetWidget(Widget)
--     Widget:SetAttachedWidget(self)
--     Widget:SetWidgetInitBubble(self)
--     self:RefreshUniformWidgetVisibility(false)
--     self:OcclusionTestFuncWithoutAnim()
--     return Widget
--     ]]
-- end

-- function BP_HeadWidgetComponent_C:CheckCanGetWidget(WidgetName)
--     local RegionSyncSubsys = UE4.URegionSyncSubsystem.GetInstance(self)
--     local bRegionClientOnlyShowUI = RegionSyncSubsys ~= nil
--     if bRegionClientOnlyShowUI then
--         return true
--     end
--     if WidgetName == 'Impression' or WidgetName == 'Name' then
--         if not self.Owner or not self.Owner.Mesh or not self.Owner.Mesh.SkeletalMesh then
--             return false
--         end
--     end
--     if not self.Owner then
--         return false
--     end
--     return true
-- end

-- function BP_HeadWidgetComponent_C:TryReleaseWidgetInternal()
--     --恢复遮挡改变的渲染不透明度
--     -- self:SetWidgetRenderOpacity(1.0)
--     -- self:CleanTimer()
--     self.Overridden.TryReleaseWidgetInternal(self)

--     --[[
--     self:RemoveOcclusionTestTimer()
--     self:SetUniformWidgetHideTag(false, "Occlusion")

--     local Widget = self:GetWidget()
--     local HeadUISubsystem = UNpcHeadUISubsystem.GetHeadUISubsystem(self) 

--     if not IsValid(Widget) then
--         return
--     end

--     self:RemoveDistanceTestInfo(Widget)
--     if self:GetOwner() and HeadUISubsystem then
--         HeadUISubsystem:TryReleaseHeadWidget(self, Widget)
--     end
--     Widget.HideTags = {}

--     self:SetWidget(nil)
--     Widget:UnsetAttachedWidget()
--     self.ReleaseTimer = nil
--     --DebugPrint("GetOrCreateWidget TryReleaseWidgetInternal", self.ReleaseTimer ,self:GetOwner():GetName())
--     ]]
-- end

function BP_HeadWidgetComponent_C:EnableWidget(WidgetName, ...)
    local Widget = self:GetOrCreateWidget(WidgetName)
    --DebugPrint("BP_HeadWidgetComponent_C:EnableWidget", Widget,WidgetName, ...)
    if not IsValid(Widget) then
        return
    end
    Widget:EnableWidget(WidgetName, ...) 
end

function BP_HeadWidgetComponent_C:DisableWidget(WidgetName, ...)
    local Widget = self:GetWidget()
    --DebugPrint("BP_HeadWidgetComponent_C:DisableWidget", Widget, WidgetName, ...)
    if Widget then
        Widget:DisableWidget(WidgetName, ...)
    end
    
end

function BP_HeadWidgetComponent_C:NeedForceInit()
    return self.StateCount == 0
end

-- function BP_HeadWidgetComponent_C:DisableAllWidget()
--     self:OnChangeActiveWidgets(0)
-- end

-- function BP_HeadWidgetComponent_C:OnChangeActiveWidgets(State)
--     --DebugPrint("@@@myfd :OnChangeActiveWidgets",self:GetOwner():GetName(),State)
--     self.State = State
--     if State == 0 then
--         if not self.ReleaseTimer then
--             self.ReleaseTimer = self:AddTimer(0.3, self.TryReleaseWidgetInternal)
--         end
--     else
--         self:AddOcclusionTestTimer()
--     end
-- end

-- function BP_HeadWidgetComponent_C:SetWidgetRenderOpacity(Opacity)
--     local Widget = self:GetWidget()
--     if IsValid(Widget) then
--         Widget.Root:SetRenderOpacity(Opacity)
--     end
-- end

local function CalculateBubbleTime(Text, bShortBubble)
    local Language = CommonConst.SystemLanguage
    local Size  = 3.
    if Language == CommonConst.SystemLanguages.EN then
        Size = 2. -- 英语一个字符长度,显示宽度占位1个，东亚语言3个字符长度，显示宽度占位2个
    end
    local Len = string.len(Text) / 3.
    local LineCount = Len / (bShortBubble and 10 or 22) -- 短气泡长度10，长气泡长度22
    return math.max(LineCount * Const.BubbleTimePerLine, Const.BubbleTimePerLine)
end

function BP_HeadWidgetComponent_C:EnableBubbleWidget(TextMapId, Time, bShortBubble)
    local WidgetName = "Long_Bubble"
    if bShortBubble then
        WidgetName = "Short_Bubble"
    end
    self:DisableWidget(WidgetName)
    if self.DisableBubbleTimer then
        self:RemoveTimer(self.DisableBubbleTimer)
        self.DisableBubbleTimer = nil
    end
    local Text = GText(TextMapId)
    if Time and Time < 0 then
        Time = CalculateBubbleTime(Text, bShortBubble)
    end
    self:EnableWidget(WidgetName, Text, nil, Time)
    if Time and Time >= 0 then
        self.DisableBubbleTimer = self:AddTimer(Time, function() 
            self:DisableWidget(WidgetName)
        end, false)
    end
end


---------------废弃代码--------------
-- function BP_HeadWidgetComponent_C:RefreshImpressionWidget()
--     self.HeadImpressionWidgetMgr:RefreshImpressionWidget()
-- end

-- -- 调整Ratation，面向玩家
-- function BP_HeadWidgetComponent_C:FaceToViewTarget()
--     if not self.ViewTargetController then
--         return
--     end
--     self.ViewTarget = self.ViewTargetController:GetViewTarget()
--     self.ViewLocation, self.ViewRotation = self.ViewTarget:GetActorEyesViewPoint()
--     self.ViewRotation.Yaw = self.ViewRotation.Yaw + 180
--     self.ViewRotation.Pitch = self.ViewRotation.Pitch * -1

--     self:K2_SetWorldRotation(self.ViewRotation, false, nil, true)
-- end

-- -- 调整大小，使其在玩家视角下大小不变
-- function BP_HeadWidgetComponent_C:AdjustScaleByDistance()
--     self.OwnerLocation = self:GetOwner():K2_GetActorLocation()

--     local ViewPos =  UE4.URuntimeCommonFunctionLibrary.WorldToView(self, self.OwnerLocation)
--     self.DesiredScale = math.abs(ViewPos.Z) / 1000 * self.BaseScale

--     self.DesiredScale = math.max(0.2, self.DesiredScale)
--     self:SetRelativeScale3D(FVector(1, self.DesiredScale, self.DesiredScale))
-- end

-- function BP_HeadWidgetComponent_C:InitViewTargetInfo()
--     local PlayerController = UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
--     if PlayerController then
--         self.ViewTargetController = UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
--         self.ViewTarget = self.ViewTargetController:GetViewTarget()
--         self.ViewLocation, self.ViewRotation = self.ViewTarget:GetActorEyesViewPoint()
--         self.ViewRotation.Yaw = self.ViewRotation.Yaw + 180
--         self.ViewRotation.Pitch = self.ViewRotation.Pitch * -1
--     else
--         self:AddTimer(0.5, self.InitViewTargetInfo, false, 0, "InitViewTargetInfo", true)
--     end
-- end
---------------废弃代码--------------

return BP_HeadWidgetComponent_C
