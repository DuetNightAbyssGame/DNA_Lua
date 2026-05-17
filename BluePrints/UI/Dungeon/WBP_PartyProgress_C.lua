--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Dungeon_MultTempleProgress_C
local M = Class({ "BluePrints.UI.BP_UIState_C"})

function M:Initialize(Initializer)
    self.Super.Initialize(self)
    self.PlayerEids = {}
    self.PreProgress = {}      -- 用于记录上一次收到通知时的进度，更新间隔约1s
    self.CurProgress = {}      -- 最新一次通知的进度，更新间隔约1s
    self.DeltaProgress = {}
    self.LastProgress = {}     -- 用于tick中的记录当前进度，tick里用的时候就是当前时刻的真正百分比进度
    self.CurMode = 1           -- 1 小于1/8进程  2 1/8到7/8进程  3 大于7/8进程
    self.PlayersInfo = {}
    self.ArchivePoints = {}    -- 记录存档点  {第i个存档点：百分比}
    self.Points = {}           -- 存档点UI图标控件
    self.RealPoints = {}       -- 真正存档点机关
    self.PointActiveState = {} -- 存档点是否已激活，激活过就不再播激活动画
    self.BuffTime = {}         -- 记录每个玩家身上的buff时间
    self.GameEnd = false

    self.Length = 396.0      -- 进度条长度，根据这个设置头像等的位置，先写死
    self.CompleteNum = 0
    self.AllPlayNum = 0
end

function M:UpdateProgress()
    if not self.PartyPlayerDisPercentValues or self.LastProgress == {} or self.PlayersInfo == {} or not self.GameState or self.IsInFallTrigger or self.GameEnd then return end
    -- 设置玩家头像位置
    for Eid, Percent in pairs(self.LastProgress) do
        self.LastProgress[Eid] = self.LastProgress[Eid] + self.DeltaProgress[Eid]
        local Pos = FVector2D(0.0, 0.0)
        -- DebugPrint("zwkkk 进度更新", self.LastProgress[Eid], self.DeltaProgress[Eid])
        if Eid == self.CurPlayer.Eid then
            -- 主控玩家判断一下现在是在哪个阶段
            if self.LastProgress[Eid] < 0.125 and self.CurMode ~= 1 then
                -- 说明从2阶段掉到1阶段
                self.CurMode = 1
                self:PlayAnimationReverse(self.ProgressBG_ToMid)
                self.StartPoint:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            elseif self.LastProgress[Eid] > 0.125 and self.LastProgress[Eid] < 0.875 and self.CurMode == 1 then
                -- 1->2
                self.CurMode = 2
                self:PlayAnimation(self.ProgressBG_ToMid)
                self.StartPoint:SetVisibility(ESlateVisibility.Hidden)
            elseif self.LastProgress[Eid] > 0.125 and self.LastProgress[Eid] < 0.875 and self.CurMode == 3 then
                -- 3->2
                self.CurMode = 2
                self:PlayAnimationReverse(self.ProgressBG_ToRight)
                self.EndPoint:SetVisibility(ESlateVisibility.Hidden)
            elseif self.LastProgress[Eid] > 0.875 and self.CurMode ~= 3 then
                -- 2->3
                self.CurMode = 3
                self:PlayAnimation(self.ProgressBG_ToRight)
                self.EndPoint:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            end
            -- 主控玩家前1/8头像动，1/8 -> 7/8头像不动背景动，7/8 -> 1头像动
            if self.CurMode == 1 then
                -- 主控玩家在1阶段
                local PosX = self.Length * math.clamp((self.LastProgress[Eid] / 0.125) * 0.5, 0.0, 0.5)
                Pos.X = PosX
            elseif self.CurMode == 2 then
                -- 主控玩家在2阶段
                local PosX = self.Length * 0.5
                Pos.X = PosX
            elseif self.CurMode == 3 then
                -- 主控玩家在3阶段
                local PosX = self.Length * math.clamp((0.5 + ((self.LastProgress[Eid] - 0.875) / 0.125) * 0.5), 0.5, 1.0)
                Pos.X = PosX
            end
        else
            -- 其他玩家头像位置
            if self.CurMode == 1 then
                if self.LastProgress[Eid] < 0.25 then
                    -- 其他玩家小于1/4，直接进度0-1映射到0-1/4
                    local PosX = self.Length * self.LastProgress[Eid] * 4
                    Pos.X = PosX
                else
                    -- >= 0.25，固定最右侧
                    Pos.X = self.Length
                end
            elseif self.CurMode == 2 then
                local MainPlayerProgress = self.LastProgress[self.CurPlayer.Eid]
                if self.LastProgress[Eid] < MainPlayerProgress - 0.125 then
                    -- 其他玩家小于主控玩家进度-1/8，直接最左

                elseif self.LastProgress[Eid] > MainPlayerProgress + 0.125 then
                    -- 其他玩家大于主控玩家进度+1/8，直接最右
                    Pos.X = self.Length
                else
                    -- 与玩家比较接近，根据与玩家的实际进度差距映射显示位置
                    local Delta = self.LastProgress[Eid] - MainPlayerProgress
                    local PosX = self.Length * math.clamp(0.5 + (Delta / 0.25), 0.0, 1.0)
                    Pos.X = PosX
                end
            elseif self.CurMode == 3 then
                if self.LastProgress[Eid] < 0.75 then
                    -- 其他玩家小于1/4，直接最左

                else
                    -- 其他玩家大于1/4，0.75-1.0映射到0.0-1.0
                    Pos.X = self.Length * math.clamp((self.LastProgress[Eid] - 0.75) / 0.25, 0.0, 1.0)
                end
            end
        end
        self.PlayersInfo[Eid][2]:SetRenderTranslation(Pos)
        self.PlayersInfo[Eid][3]:SetRenderTranslation(Pos)
    end
    -- 设置存档点图标位置
    if self.ArchivePoints and #self.ArchivePoints > 2 then
        for i = 2, #self.ArchivePoints - 1 do
            if self.Points[i] then
                self.Points[i]:SetVisibility(ESlateVisibility.Hidden)
            end
            local ArchivePoint = self.GameState.ArchivePointMap:Find(i)
            if ArchivePoint and ArchivePoint:CheckIsActive(self.CurPlayer.Eid) then
                if not self.PointActiveState[i] then
                    self.PointActiveState[i] = true
                    self.Points[i]:PlayAnimation(self.Points[i].Switch)
                    AudioManager(self):PlayUISound(self, "event:/ui/common/multi_player_challenge_achieve_stage", nil, nil)
                end
            end
            local Percent = self.ArchivePoints[i] -- 当前存档点的百分比
            local Pos = FVector2D(0.0, 0.0)
            if self.CurMode == 1 and Percent < 0.25 then
                local PosX = self.Length * self.ArchivePoints[i] * 4
                Pos.X = PosX
                self.Points[i]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            elseif self.CurMode == 2 then
                local PerDis = Percent - self.LastProgress[self.CurPlayer.Eid]
                if PerDis > -0.125 and PerDis < 0.125 then
                    local PosX = self.Length * math.clamp(0.5 + (PerDis / 0.25), 0.0, 1.0)
                    Pos.X = PosX
                    self.Points[i]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                end
            elseif self.CurMode == 3 and Percent > 0.75 then
                local PosX = self.Length * math.clamp((Percent - 0.75) / 0.25, 0.0, 1.0)
                Pos.X = PosX
                self.Points[i]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            end
            self.Points[i]:SetRenderTranslation(Pos)
        end
    end
end

function M:ConstructInfo()
    self:InitListenEvent()
    self:InitInfo()
end

function M:InitListenEvent()
    self:AddDispatcher(EventID.OnPartyProgressUpdate, self, self.OnPartyProgressUpdate)
    self:AddDispatcher(EventID.OnPartyPlayerGetBuff, self, self.OnPartyPlayerGetBuff)
    self:AddDispatcher(EventID.OnUpdatePartyRightUI, self, self.OnUpdatePartyRightUI)
    self:AddDispatcher(EventID.OnPlayerEnterToExit, self, self.OnPlayerEnterToExit)
    self:AddDispatcher(EventID.OnOnePlayerEnd, self, self.OnOnePlayerEnd)
    self:AddDispatcher(EventID.OnPartyPlayerTriggerFallTrigger, self, self.OnPartyPlayerTriggerFallTrigger)
    self:AddDispatcher(EventID.OnPlayerGetDeBuff, self, self.OnPlayerGetDeBuff)
end

function M:InitInfo()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    if not GameInstance then
        return
    end
    self.DungeonId = GameInstance:GetCurrentDungeonId()
    self.DungeonInfo = DataMgr.Dungeon[self.DungeonId]
    if not self.DungeonInfo then
        return
    end

    self:AddTimer(0.02, self.UpdateProgress, true, 0, "UpdateProgress")
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)

    self.Group_ProgressSign:ClearChildren()
    self.Group_ProgressHeadOther:ClearChildren()
    self.Group_ProgressHeadMine:ClearChildren()

    self.Text_MulrTempleProgressTitle:SetText(GText("UI_Party_Parkour_FinishingRate").. " 0%")

    self:SetVisibility(ESlateVisibility.Hidden)
end

function M:OnPartyProgressUpdate()
    -- 大概一秒一次同步信息，短间隔定时器里做插值
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    self.GameState = GameState
    self.CurPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if not GameState or not self.CurPlayer then
        return
    end
    if self.GameEnd then return end
    self.PartyPlayerDisPercentValues = GameState.PartyPlayerDisPercentValues
    DebugPrint("zwk 派对当前人数：", self.PartyPlayerDisPercentValues:Num())
    if not self.PartyPlayerDisPercentValues then
        return
    end
    if not self.HasAdd then
        self.HasAdd = true
        self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self:PlayAnimation(self.In)
        self:PlayAnimation(self.ProgressBG_Left)

        -- 先添加存档点
        local PointNum = GameState.ArchivePointProgress:Num()
        DebugPrint("zzz000 ", PointNum)
        for i = 1, PointNum do
            self.ArchivePoints[i] = GameState.ArchivePointProgress:Find(i)
            DebugPrint("zzz111 ", self.ArchivePoints[i])
        end
        for i = 1, PointNum do
            self.ArchivePoints[i] = GameState.ArchivePointProgress:Find(i)
            if i > 1 and i < PointNum then
                -- 为存档点添加UI图标
                if not self.Points[i] then
                    local Point = self:CreateWidgetNew("PartyPoint")
                    self.Group_ProgressSign:AddChild(Point)
                    local SlotArrow = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(Point)
                    local Anchors = SlotArrow:GetAnchors()
                    Anchors.Minimum = FVector2D(0.0, 0.5)
                    Anchors.Maximum = FVector2D(0.0, 0.5)
                    SlotArrow:SetAnchors(Anchors)
                    SlotArrow:SetAlignment(FVector2D(0.5, 0.5))
                    SlotArrow:SetPosition(FVector2D(0.0, 0.0))
                    self.Points[i] = Point
                    if self.ArchivePoints[i] > 0.25 then
                        self.Points[i]:SetVisibility(ESlateVisibility.Hidden)
                    else
                        local PosX = self.Length * self.ArchivePoints[i] * 4
                        local Pos = FVector2D(PosX, 0.0)
                        self.Points[i]:SetRenderTranslation(Pos)
                    end
                end
            end
        end

        self.AllPlayNum = 0
        for Eid, Percent in pairs(self.PartyPlayerDisPercentValues) do
            local Bar = self:CreateWidgetNew("PartyHeadArrow")
            self.Group_ProgressSign:AddChild(Bar)
            local Head = self:CreateWidgetNew("PartyHead")

            if Eid == self.CurPlayer.Eid then
                -- 是当前玩家
                self.Group_ProgressHeadMine:AddChild(Head)
                Head.Image_MyselfBG:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
                Bar.WS_SubItem02:SetActiveWidgetIndex(1)
            else
                -- 是其他玩家
                self.Group_ProgressHeadOther:AddChild(Head)
                Bar.WS_SubItem02:SetActiveWidgetIndex(0)
            end

            self.PlayersInfo[Eid] = {Percent, Bar, Head}
            self.AllPlayNum = self.AllPlayNum + 1

            -- 箭头初始相关
            local SlotArrow = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(Bar)
            local Anchors = SlotArrow:GetAnchors()
            Anchors.Minimum = FVector2D(0.0, 0.5)
            Anchors.Maximum = FVector2D(0.0, 0.5)
            SlotArrow:SetAnchors(Anchors)
            SlotArrow:SetAlignment(FVector2D(0.5, 0.5))
            SlotArrow:SetPosition(FVector2D(0.0, 0.0))
            if Eid == self.CurPlayer.Eid then
                SlotArrow:SetZOrder(1)
            end

            -- 头像初始相关
            local SlotHead = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(Head)
            local Anchors = SlotHead:GetAnchors()
            Anchors.Minimum = FVector2D(0.0, 0.5)
            Anchors.Maximum = FVector2D(0.0, 0.5)
            SlotHead:SetAnchors(Anchors)
            SlotHead:SetAlignment(FVector2D(0.5, 0.5))
            SlotHead:SetPosition(FVector2D(0.0, 0.0))
            SlotHead:SetAutoSize(true)
            local Player = Battle(self):GetEntity(Eid)
            local CharName = DataMgr.Char[Player.CurrentRoleId].GUIPathVariable
            local Path = "/Game/UI/Texture/Dynamic/Image/Head/Mini/T_Normal_Mini_" .. CharName
            local IconDynaMaterial = Head.Image_Head:GetDynamicMaterial()
            if IconDynaMaterial then
                local Texture = LoadObject(Path)
                if not Texture then
                    Texture = LoadObject("/Game/UI/Texture/Dynamic/Image/Head/Mini/T_Normal_Mini_Heitao")
                end
                IconDynaMaterial:SetTextureParameterValue("MainTex", Texture)
            end

            Head:PlayAnimation(Head.Normal)

            self.BuffTime[Eid] = {0.0, 0.0}  -- 正面buff剩余时间，负面buff剩余时间
        end

        -- 添加起始点和终点，并隐藏终点
        self.StartPoint = self:CreateWidgetNew("PartyStartPoint")
        self.Group_ProgressSign:AddChild(self.StartPoint)
        local SlotStartPoint = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.StartPoint)
        local Anchors = SlotStartPoint:GetAnchors()
        Anchors.Minimum = FVector2D(0.0, 0.5)
        Anchors.Maximum = FVector2D(0.0, 0.5)
        SlotStartPoint:SetAnchors(Anchors)
        SlotStartPoint:SetAlignment(FVector2D(0.5, 0.5))
        SlotStartPoint:SetPosition(FVector2D(0.0, 0.0))
        self.StartPoint:SetRenderTranslation(FVector2D(0.0, 0.0))

        self.EndPoint = self:CreateWidgetNew("PartyEndPoint")
        self.Group_ProgressSign:AddChild(self.EndPoint)
        local SlotEndPoint = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.EndPoint)
        local Anchors = SlotEndPoint:GetAnchors()
        Anchors.Minimum = FVector2D(0.0, 0.5)
        Anchors.Maximum = FVector2D(0.0, 0.5)
        SlotEndPoint:SetAnchors(Anchors)
        SlotEndPoint:SetAlignment(FVector2D(0.5, 0.5))
        SlotEndPoint:SetPosition(FVector2D(0.0, 0.0))
        self.EndPoint:SetVisibility(ESlateVisibility.Hidden)
        self.EndPoint:SetRenderTranslation(FVector2D(self.Length, 0.0))
    end
    for Eid, Info in pairs(self.PlayersInfo) do
        if Info[2] then
            Info[2]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
        if Info[3] then
            Info[3]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
    end

    for Eid, Percent in pairs(self.PartyPlayerDisPercentValues) do
        self.CurProgress[Eid] = math.clamp(Percent, 0.0, 1.0)
    end
    for Eid, Percent in pairs(self.PartyPlayerDisPercentValues) do
        if not self.PreProgress[Eid] then
            self.PreProgress[Eid] = 0.0
        end
        self.DeltaProgress[Eid] = (self.CurProgress[Eid] - self.PreProgress[Eid]) * 0.02
        -- DebugPrint("zwkkk OnPartyProgressUpdate ", self.CurProgress[Eid], self.PreProgress[Eid], self.DeltaProgress[Eid])
        self.LastProgress[Eid] = self.PreProgress[Eid]
        self.PreProgress[Eid] = self.CurProgress[Eid]
        if self.PlayersInfo[Eid][4] then
            self.LastProgress[Eid] = self.PreProgress[Eid]
            self.DeltaProgress[Eid] = 0.0
            self:UpdateProgress()
            self.PlayersInfo[Eid][4] = false
            -- self.PlayersInfo[Eid][3]:PlayAnimation(self.PlayersInfo[Eid][3].Normal)
            self.PlayersInfo[Eid][3]:StopAllAnimations()
            self.PlayersInfo[Eid][3]:UnbindAllFromAnimationFinished(self.PlayersInfo[Eid][3].Rebirth_In)
            if Eid == self.CurPlayer.Eid then
                AudioManager(self):PlayUISound(self, "event:/ui/common/multi_player_challenge_revive", nil, nil)
            end
            self.PlayersInfo[Eid][3]:BindToAnimationFinished(self.PlayersInfo[Eid][3].Rebirth_In, function()
                if self:IsExistTimer("PlayerGetBuff_" .. Eid) then
                    if self.PlayersInfo[Eid] and self.PlayersInfo[Eid][3] then
                        if self.PlayersInfo[Eid][5] then
                            self.PlayersInfo[Eid][3]:PlayAnimation(self.PlayersInfo[Eid][3].Victory)
                        else
                            self.PlayersInfo[Eid][3]:PlayAnimation(self.PlayersInfo[Eid][3].Failure)
                        end
                    end
                end
            end)
            self.PlayersInfo[Eid][3]:PlayAnimation(self.PlayersInfo[Eid][3].Rebirth_In)
            local RebirthPlayerPosX = self.PlayersInfo[Eid][3].RenderTransform.Translation.X
            local MinX = self.Length
            local MinIndex = 1
            for i, v in pairs(self.Points) do
                if math.abs(v.RenderTransform.Translation.X - RebirthPlayerPosX) < MinX then
                    MinX = v.RenderTransform.Translation.X
                    MinIndex = i
                end
            end
            self.Points[MinIndex]:PlayAnimation(self.Points[MinIndex].Rebirth_In)
        end
    end
end

function M:OnPartyPlayerGetBuff(Eid, BuffId, IsPositive, Time)
    if self.PlayersInfo[Eid] and self.PlayersInfo[Eid][3] then
        self.PlayersInfo[Eid][5] = IsPositive
        if IsPositive then
            self.PlayersInfo[Eid][3]:PlayAnimation(self.PlayersInfo[Eid][3].Victory)
        else
            self.PlayersInfo[Eid][3]:PlayAnimation(self.PlayersInfo[Eid][3].Failure)
        end
        local PlayNormal = function ()
            if self.PlayersInfo[Eid] and self.PlayersInfo[Eid][3] then
                self.PlayersInfo[Eid][3]:PlayAnimation(self.PlayersInfo[Eid][3].Normal)
            end
        end
        self:RemoveTimer("PlayerGetBuff_" .. Eid)
        self:AddTimer(Time, PlayNormal, false, 0, "PlayerGetBuff_" .. Eid)
    end
end

function M:OnPlayerGetDeBuff(BuffId, LastTime, Eid)
    DebugPrint("zwkkk OnPlayerGetDeBuff", BuffId, LastTime, Eid)
    if not DataMgr.PartyDebuff or not DataMgr.PartyDebuff[BuffId] then return end
    if self.PlayersInfo[Eid] and self.PlayersInfo[Eid][3] then
        self.PlayersInfo[Eid][5] = false
        self.PlayersInfo[Eid][3]:PlayAnimation(self.PlayersInfo[Eid][3].Failure)
        local PlayNormal = function ()
            if self.PlayersInfo[Eid] and self.PlayersInfo[Eid][3] then
                self.PlayersInfo[Eid][3]:PlayAnimation(self.PlayersInfo[Eid][3].Normal)
            end
        end
        self:RemoveTimer("PlayerGetBuff_" .. Eid)
        self:AddTimer(LastTime, PlayNormal, false, 0, "PlayerGetBuff_" .. Eid)
    end
end

function M:OnUpdatePartyRightUI(CompletionRate, Rank, TotalNum)
    if self.AlreadyFinish then return end
    if self.RemainTime ~= nil then return end
    if self.GameState and self.GameState.CurPlayerComplete then
        self.Text_MulrTempleProgressTitle:SetText(GText("UI_Evacuated"))
    else
        self.Text_MulrTempleProgressTitle:SetText(GText("UI_Party_Parkour_FinishingRate") .. " " .. self:GetCompletionRate(CompletionRate).."%")
    end
end

function M:OnPlayerEnterToExit(Info, bIsWaiting)
    -- bIsWaiting是true就是当前玩家（Player0）到终点了
    DebugPrint("zwk OnPlayerEnterToExit ",self.GameState.ExitCountDown,self.GameState.ReplicatedTimeSeconds,Info.StartExitCountdownTime,Info.WaitingPlayerNum,bIsWaiting)
    if self.GameEnd then return end
    -- self.CompleteNum = self.CompleteNum + 1
    self.RemainTime = self.GameState.ExitCountDown - math.max(math.floor(self.GameState.ReplicatedTimeSeconds - Info.StartExitCountdownTime),0)

    if bIsWaiting then
        -- 更新一下等待其他玩家（2/4）这种信息
        self.Text_MulrTempleProgressTitle:SetText(string.format(GText("UI_PARTY_PARKOUR_ENDPOINTWAIT"), self.CompleteNum, self.AllPlayNum))
    end
    if bIsWaiting and not self.AlreadyFinish then
        -- 自己到了终点，只进来一次，播放动效和Toast
        self.AlreadyFinish = true
        self:PlayAnimation(self.TextRefresh)
        self.GameState:ShowDungeonToast_Lua("UI_PARTY_PARKOUR_ENDPOINTREACH", 3, EToastType.Success)
    end
    if not self.AlreadyFinish then
        -- 还没完成，需要显示剩余时间信息
        self:PlayAnimation(self.TextRefresh)
        if self.RemainTime > self.MinTime then
            self.Text_MulrTempleProgressTitle:SetText(GText("UI_PARTY_PARKOUR_TEAMWAIT") .. "(" .. (self:GetTimeStr(self.RemainTime)).. ")")
        else
            self.Text_MulrTempleProgressTitle:SetText(GText("UI_PARTY_PARKOUR_TEAMWAIT") .. "(" .. '<Warning>' .. (self:GetTimeStr(self.RemainTime)) .. '</>' .. ")")
            AudioManager(self):PlayUISound(self, "event:/ui/common/countdown_warning_short_reverb", nil, nil)
        end
    end

    if not self.FirstNotify then
        -- 第一次收到到达撤离点的通知时，根据是否完成弹不同Toast
        self.FirstNotify = true
        if not bIsWaiting then
            self.GameState:ShowDungeonToast_Lua("UI_PARTY_PARKOUR_ENDPOINT", 3, EToastType.Common)
        end
        -- 倒计时
        self:AddTimer(1, self.UpdateRemainTime, true, 0, "UpdateRemainTime")
    end
end

function M:UpdateRemainTime()
    if self.RemainTime <= 0 then
        self.Text_MulrTempleProgressTitle:SetText(GText("UI_PARTY_PARKOUR_TEAMWAIT") .. "(" .. '<Warning>' .. (self:GetTimeStr(0)) .. '</>' .. ")")
        self.GameEnd = true
        self:OnGameEnd()
        return
    end
    if self.AlreadyFinish then return end
    self.RemainTime = self.RemainTime - 1
    if self.RemainTime > self.MinTime then
        self.Text_MulrTempleProgressTitle:SetText(GText("UI_PARTY_PARKOUR_TEAMWAIT") .. "(" .. (self:GetTimeStr(self.RemainTime)).. ")")
    else
        self.Text_MulrTempleProgressTitle:SetText(GText("UI_PARTY_PARKOUR_TEAMWAIT") .. "(" .. '<Warning>' .. (self:GetTimeStr(self.RemainTime)) .. '</>' .. ")")
        AudioManager(self):PlayUISound(self, "event:/ui/common/countdown_warning_short_reverb", nil, nil)
    end
end

function M:OnOnePlayerEnd(Eid)
    self.PlayersInfo[Eid][3].Image_Done:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    local Complete = 0
    for i, v in pairs(self.PlayersInfo) do
        if v[3] and v[3].Image_Done:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
            Complete = Complete + 1
        end
    end
    self.CompleteNum = Complete
    if self.GameEnd then return end
    if self.AlreadyFinish then
        -- 更新一下等待其他玩家（2/4）这种信息
        self.Text_MulrTempleProgressTitle:SetText(string.format(GText("UI_PARTY_PARKOUR_ENDPOINTWAIT"), self.CompleteNum, self.AllPlayNum))
    end
end

function M:OnPartyPlayerTriggerFallTrigger(Eid)
    DebugPrint("zwkkk OnPartyPlayerTriggerFallTrigger", Eid)
    if self.PlayersInfo[Eid] then
        self.PlayersInfo[Eid][2]:SetVisibility(ESlateVisibility.Hidden)
        self.PlayersInfo[Eid][3]:SetVisibility(ESlateVisibility.Hidden)
        self.PlayersInfo[Eid][3]:PlayAnimation(self.PlayersInfo[Eid][3].Normal)
        self.PlayersInfo[Eid][4] = true
    end
end

function M:GetCompletionRate(CompletionRate)
    if CompletionRate < 0 then
        return 0
    end
    local PercentValue = math.floor(CompletionRate * 100)
    if PercentValue > 100 then
        PercentValue = 100
    end
    return PercentValue
end

function M:OnGameEnd()
    self:RemoveDispatcher(EventID.OnPartyProgressUpdate)
    self:RemoveDispatcher(EventID.OnPartyPlayerGetBuff)
    self:RemoveDispatcher(EventID.OnUpdatePartyRightUI)
    self:RemoveDispatcher(EventID.OnPlayerEnterToExit)
    self:RemoveDispatcher(EventID.OnOnePlayerEnd)
    self:RemoveDispatcher(EventID.OnPartyPlayerTriggerFallTrigger)
    self:RemoveDispatcher(EventID.OnPlayerGetDeBuff)
    self:RemoveTimer("UpdateRemainTime")
end


function M:Destruct()
    self:RemoveTimer("UpdateProgress")
    M.Super.Destruct(self)
end


return M
