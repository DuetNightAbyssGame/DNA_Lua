require "UnLua"

local Component = {}
local TipsBpPath="WidgetBlueprint'/Game/UI/WBP/AreaCoop/Widget/WBP_AreaCoop_MapTips.WBP_AreaCoop_MapTips'"

function Component:InitComponentCoroutine()
    local Coroutine = CreateCoroutine(self.InitMultiplayerChallenge)
    table.insert(self.InitCoroutines, Coroutine)
    coroutine.resume(Coroutine, self, #self.InitCoroutines)
end

function Component:ClearData()
    if self.ChallengePoints then
        for _, widget in pairs(self.ChallengePoints) do
            widget:RemoveFromParent()
        end
        self.ChallengePoints = {}
    end
    self.TeleportIdToChallengeId = {}
    if self.ChanllengeTips then
        self.ChanllengeTips:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function Component:InitMultiplayerChallenge(CoroutineIndex)
    self.ChallengePoints = {}
    self.ChallengePointLocation = {}
    self.ChallengePoint2FloorId = {}
    self.Challenge2LocalPos = {}
    self.CurrentChallengeId = nil
    self.TeleportIdToChallengeId = {}

    local Avatar = GWorld:GetAvatar()
    for  ChallengeId, ChallengeData in pairs(DataMgr.MultiplayerChallenge or {}) do
        local TeleportId = ChallengeData.TeleportId
        local TeleportData = TeleportId and DataMgr.TeleportPoint[TeleportId] or nil
        if TeleportData and TeleportData.MechanismPos and TeleportData.TeleportPointSubRegion then
            local SubRegionId = TeleportData.TeleportPointSubRegion
            local RegionId = DataMgr.SubRegion[SubRegionId] and DataMgr.SubRegion[SubRegionId].RegionId
            if RegionId == self.RegionData.RegionId then
                -- 只在已解锁时生成点位
                local isUnlock = true
                if ChallengeData.UnlockCondition ~= nil then
                    isUnlock = ConditionUtils.CheckCondition(Avatar, ChallengeData.UnlockCondition, false)
                end
                if not isUnlock then
                    -- 未解锁则不显示，不生成点位
                    -- 继续下一项
                else
                    local point, select = self:NewPointAsync(self.InitCoroutines[CoroutineIndex])

                    point:Init(self, TeleportData, true, self.OnChallengePointClick, self.OnChallengeHover, self.OnChallengeUnhover)
                    local x, y = TeleportData.MechanismPos[1], TeleportData.MechanismPos[2]
                    local position = self:TransformWorldLocToUILoc(x, y)
                    point:SetRenderTranslation(position)
                    select:SetRenderTranslation(position)

                    local TelePortDataId = TeleportData.Id
                    self.ChallengePoints[TelePortDataId] = point
                    self.SelectWidgetTable[TelePortDataId] = select
                    self.ChallengePointLocation[TelePortDataId] = FVector2D(x, y)
                    self.TeleportIdToChallengeId[TelePortDataId] = ChallengeId

                    local floorId = self.MaxFloorId
                    if TeleportData.BuildingNameAndId then
                        local _, buildingFloor = self:GetBuildingNameAndId(TeleportData.BuildingNameAndId)
                        floorId = buildingFloor or self.MaxFloorId
                    end
                    self.ChallengePoint2FloorId[TelePortDataId] = floorId

                    local TrackingId = self:GetTrackingId(CommonConst.RegionMapTrackingType.MultiplayerChallenge)
                    if TelePortDataId == TrackingId then
                        point:PlayAnimation(point.Loop, 0, 0)
                        self:CreateTrackIndicator(point)
                    end
                end
            end
        end
    end

    self:InitCoroutineCheck(CoroutineIndex)
end

function Component:ShowFloor_Component(FloorId)
    if not self.ChallengePoints then return end
    for id, point in pairs(self.ChallengePoints) do
        local floorType = (self.ChallengePoint2FloorId[id] or self.MaxFloorId) - FloorId
        point:SetFloor(floorType)
    end
end

function Component:OnScaleChange_Component(Percent)
    if not self.ChallengePoints then return end

    local TrackingID = self:GetTrackingId(CommonConst.RegionMapTrackingType.MultiplayerChallenge)
    local Visible = self:GetMapIconVisible("UI_TELEPORTPOINT", Percent)

    for id, point in pairs(self.ChallengePoints) do
        if not self.IsMinimap then
            if Visible or id == self.CurrentChallengeId or id == TrackingID then
                if point:GetVisibility() ~= ESlateVisibility.SelfHitTestInvisible or not point.PlayForward then
                    if point:SetPointVisibility("Scale", true) then
                        point:StopAnimation(point.In)
                        point:PlayAnimation(point.In)
                        point.PlayForward = true
                    end
                end
            else
                if point:GetVisibility() ~= ESlateVisibility.Collapsed or point.PlayForward then
                    if not point:IsAnimationPlaying(point.In) or point.PlayForward then
                        point:StopAnimation(point.In)
                        point:PlayAnimationReverse(point.In)
                        point.PlayForward = false
                    end
                    point:SetPointVisibility("Scale", false)
                end
            end
        end

        if point:GetVisibility() ~= ESlateVisibility.Collapsed and self.ChallengePointLocation[id] or self.IsMinimap then
            local pos = self:TransformWorldLocToUILoc(self.ChallengePointLocation[id].X, self.ChallengePointLocation[id].Y)
            point:SetRenderTranslation(pos)
            self.SelectWidgetTable[id]:SetRenderTranslation(pos)
        end
    end
end

-- 打开挑战点Tips
function Component:FreshOrCreatTips(ChallengeId)
    ScreenPrint("FreshOrCreatTips")
    if not self.ChanllengeTips or not IsValid(self.ChanllengeTips) then
        self.ChanllengeTips = UIManager(self):CreateWidgetAsync(nil,self.CoroutineInitObj,TipsBpPath) 
        if not self.ChanllengeTips then
            ScreenPrint("创建多人传送点详情失败")
            return
        end
        self.MainMap.Convey_Area_Coop:AddChild(self.ChanllengeTips)
        self.ChanllengeTips:SetVisibility(ESlateVisibility.Collapsed)
    end

    if self.ChanllengeTips then
        local wasVisible = self.ChanllengeTips:GetVisibility() == ESlateVisibility.SelfHitTestInvisible
        self.ChanllengeTips:Refresh(ChallengeId)
        self.ChanllengeTips:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        if not wasVisible then
            self.ChanllengeTips:PlayAnimation(self.ChanllengeTips.In)
        end
        self.ChanllengeTips:SetFocus()
        --self.ChanllengeTips.Common_Button_Text_PC:BindSingleEventOnClicked(self, self.OnConveyClicked)
        -- 打开Tips时隐藏Tab和其他UI
        -- if self.MainMap.Tab then
        --     self.MainMap.Tab:SetVisibility(ESlateVisibility.Collapsed)
        -- end
        -- if self.MainMap.FloorWidget then
        --     self.MainMap.FloorWidget:SetVisibility(ESlateVisibility.Collapsed)
        -- end
        -- if self.MainMap.Entrance_Dispatch then
        --     self.MainMap.Entrance_Dispatch:SetVisibility(ESlateVisibility.Collapsed)
        -- end
        -- 可根据实际需求继续隐藏其他UI
    end
end

-- function Component:ClosePanel()
--     self:CloseChallengeTips()
-- end

function Component:CloseChallengeTips(IsImmediately)
    if self.ChanllengeTips and self.ChanllengeTips:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
        if IsImmediately then
            self.ChanllengeTips:SetVisibility(ESlateVisibility.Collapsed)
        else
            -- 播放 Out 动画，播放完毕后再隐藏
            if self.ChanllengeTips.UnbindAllFromAnimationFinished and self.ChanllengeTips.BindToAnimationFinished then
                self.ChanllengeTips:UnbindAllFromAnimationFinished(self.ChanllengeTips.Out)
                self.ChanllengeTips:BindToAnimationFinished(self.ChanllengeTips.Out, function()
                    if self.ChanllengeTips then
                        self.ChanllengeTips:SetVisibility(ESlateVisibility.Collapsed)
                    end
                end)
            end
            self.ChanllengeTips:PlayAnimation(self.ChanllengeTips.Out)
            return true
        end
    end
end


function Component:OnChallengePointClick(Id)
    local ChallengeId = self.TeleportIdToChallengeId[Id]
    local ChallengeData = (DataMgr.MultiplayerChallenge or {})[ChallengeId]
    if not ChallengeData or not self:CheckControlPriority_Normal() then
        return
    end
    -- 已打开且为同一挑战点：执行“二次点击关闭”并返回
    local IsTipsVisible = self.ChanllengeTips and self.ChanllengeTips:GetVisibility() == ESlateVisibility.SelfHitTestInvisible
    local CurrentTipsId = IsTipsVisible and self.ChanllengeTips.CurChallengeId or nil
    if IsTipsVisible and CurrentTipsId == ChallengeId then
        self:ClosePanel(true)
        return
    end
    -- 异点或首次打开：不关闭Tips，更新选择并刷新内容
    if not self:CheckSelect(self.ChallengePoints[Id]) then
        return
    end

    self.CurrentSelectPoint = self.ChallengePoints[Id]
    self.CurrentSelectPoint.Slot:SetZOrder(20)
    self.SelectWidgetTable[Id]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.SelectWidgetTable[Id]:PlayAnimation(self.SelectWidgetTable[Id].Click)

    if self.ClickedSelectWidget then
        self.ClickedSelectWidget:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.ClickedSelectWidget = self.SelectWidgetTable[Id]
    self.CurrentChallengeId = Id
    self.CurrentConveyId = Id

    local floorId = self.ChallengePoint2FloorId[Id]
    if floorId then
        self:OnFloorBtnClicked(floorId, true)
    end

    self:OnPanelOpen(2)
    self:FreshOrCreatTips(ChallengeId)

    -- 将地图移动到传送点位置，Id就是TeleportData.Id
    if Id then
        self:MoveMapToTelepoint(Id)
    end
end

function Component:OnChallengeHover(Id)
    if self.ChallengePoints[Id] and self.SelectWidgetTable[Id] ~= self.ClickedSelectWidget then
        self.SelectWidgetTable[Id]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.SelectWidgetTable[Id]:PlayAnimation(self.SelectWidgetTable[Id].Hover)
    end
end

function Component:OnChallengeUnhover(Id)
    if self.ChallengePoints[Id] and self.SelectWidgetTable[Id] ~= self.ClickedSelectWidget then
        self.SelectWidgetTable[Id]:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function Component:Destruct()
    if self.ChanllengeTips and IsValid(self.ChanllengeTips) then
        self.ChanllengeTips:RemoveFromParent()
    end
    self.ChanllengeTips = nil
end

return Component
