--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local EMCache = require "EMCache.EMCache"

---@type WBP_Battle_BulletJump_M_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

M._components = {
    "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent",
}

function M:Construct()
    self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
    self.Btn_BulletJump.OnPressed:Add(self, self.OnBtnPressed)
    self.Btn_BulletJump.OnReleased:Add(self, self.OnBtnReleased)
    self.LocalTurnSpeed_Horizontal = 4.5
    self.LocalTurnSpeed_Vertical = 2
    self.InActiveTags = {}
    self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
    self:ActiveBulletJump()
end


function M:OnBtnPressed()
    -- 逻辑层
    if self.OwnerPlayer:CheckSkillInActive(ESkillName.BulletJump) then
        return
    end
    self.OwnerPanel:TryToPlayTargetCommand("BulletJump")
    
    --表现层
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
    
end

function M:OnBtnReleased()
    -- AutoBulletJump 开启时，松手停止触发
    if EMCache:Get("AutoBulletJump") then
        self:StopAutoRetryTimer()
        self.OwnerPanel:TryToStopTargetCommand("BulletJump")
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
        return
    end
    -- 逻辑层
    if self.OwnerPlayer:CheckSkillInActive(ESkillName.BulletJump) then
        return
    end
    self.OwnerPanel:TryToStopTargetCommand("BulletJump")
    --表现层
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
end

-- 启动持续重试定时器（AutoBulletJump 模式）
function M:StartAutoRetryTimer()
    if self.BulletJumpRetryTimer then
        return
    end
    self.BulletJumpRetryTimer = self:AddTimer(0.1, function()
        if not self.OwnerPlayer then
            return
        end
        -- 技能已激活后技能层自会管理，UI 侧持续发送请求即可
        self.OwnerPanel:TryToPlayTargetCommand("BulletJump")
    end, true, 0, "BulletJumpRetryTimer", true)
end

-- 停止持续重试定时器
function M:StopAutoRetryTimer()
    if self.BulletJumpRetryTimer then
        self:RemoveTimer(self.BulletJumpRetryTimer)
        self.BulletJumpRetryTimer = nil
    end
end

function M:ButtonBulletJumpDown(Index, StartPos)
    if self.OwnerPlayer:CheckSkillInActive(ESkillName.BulletJump) then
        return
    end
    -- AutoBulletJump 开启：按住持续触发，同时允许滑动调整视角
    
    self.HasAutoBulletJump = EMCache:Get("AutoBulletJump")
    self.HasBulletJumpCancel = EMCache:Get("BulletJumpCamRotate")
    if self.HasBulletJumpCancel then
        if not self.IsOccupied then -- self.IsOccupied 代表是否有另一个子弹跳按钮占据了控制权
            self.OwnerPanel:SetBulletJumpOccupied(true, self)
        else
            return
        end
        EventManager:FireEvent(EventID.OnEnterBulletJumpAim)
        self:ChangeBattleWheelState(false)
        self.IsBtnDown = true
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
        self.OwnerPlayer:SetCanInteractiveTrigger(false, "BulletJumpAim")
        --如果开启了自动子弹跳，在这里立即触发一次，并启动定时器持续触发
        if self.HasAutoBulletJump then
            -- 立即触发一次
            self.OwnerPanel:TryToPlayTargetCommand("BulletJump")
            -- 启动重复定时器持续触发
            self:StartAutoRetryTimer()
        end
    else
        self.OwnerPanel:TryToPlayTargetCommand("BulletJump")
        --如果开启了自动子弹跳，在这里启动定时器持续触发
        if self.HasAutoBulletJump then
            self:StartAutoRetryTimer()
            EventManager:FireEvent(EventID.OnEnterBulletJumpAim)
             EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
        else
            -- body
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
        end
        
    end
    -- 按下时镜头变化
    if self.OwnerPlayer and self.OwnerPlayer.CameraControlComponent
        and self.OwnerPlayer:CheckBulletJumpConditionForUI() then
        self.OwnerPlayer.CameraControlComponent:PushCameraStateFromPreset("BulletJumpAim", 0.2, 3)
    end
end

function M:ButtonBulletJumpMove(TouchFingerCount, Index, LastPos, TotalDeltaDis, LastDeltaDis, TouchLocalPos, ScreenSpacePos)
    if self.OwnerPlayer:CheckSkillInActive(ESkillName.BulletJump) then
        return
    end

    if not self.HasBulletJumpCancel then
        return
    end
    if self.IsOccupied then
        return
    end
    self.IsUnderCancelBtn = USlateBlueprintLibrary.IsUnderLocation(self.CancelBtn:GetCachedGeometry(), ScreenSpacePos)
    if self.IsUnderCancelBtn and not self.LastUnderCancelBtn then
        EMUIAnimationSubsystem:EMPlayAnimation(self.CancelBtn, self.CancelBtn.Loop, EUMGSequencePlayMode.Forward, true)
    elseif not self.IsUnderCancelBtn and self.LastUnderCancelBtn then
        EMUIAnimationSubsystem:EMStopAnimation(self.CancelBtn, self.CancelBtn.Loop)
    end
    self.LastUnderCancelBtn = self.IsUnderCancelBtn
    local WorldDeltaTime = UE4.UGameplayStatics.GetWorldDeltaSeconds(self)
    -- Pitch轴旋转
    self.OwnerPlayer:AddCharacterPitchInput(-self.LocalTurnSpeed_Vertical * LastDeltaDis.Y * WorldDeltaTime)
    -- Yaw轴旋转
    self.OwnerPlayer:AddCharacterYawInput(self.LocalTurnSpeed_Horizontal * LastDeltaDis.X * WorldDeltaTime)
end

function M:ButtonBulletJumpUp(Index, WidgetLocalPos, LastWidgetTouchPos, EndTouchPos, TotalDeltaDis, ScreenSpacePos)
    if self.OwnerPlayer:CheckSkillInActive(ESkillName.BulletJump) then
        return
    end
    if self.HasBulletJumpCancel then
        self.OwnerPanel:SetBulletJumpOccupied(false, self)
        if self.IsOccupied then
            return
        end
        EventManager:FireEvent(EventID.OnQuitBulletJumpAim)
        self.OwnerPlayer:SetCanInteractiveTrigger(true, "BulletJumpAim")
        self:ChangeBattleWheelState(true)
          -- AutoBulletJump 开启：松手停止持续触发
        if self.HasAutoBulletJump then
            self:StopAutoRetryTimer()
            self.IsBtnDown = false
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
        else
            if ScreenSpacePos and USlateBlueprintLibrary.IsUnderLocation(self.CancelBtn:GetCachedGeometry(), ScreenSpacePos) then
                EMUIAnimationSubsystem:EMStopAnimation(self.CancelBtn, self.CancelBtn.Loop)
                self.IsBtnDown = false
            elseif not ScreenSpacePos then
                self.IsBtnDown = false
            end
            if not self.IsBtnDown then
                -- 确保取消时也恢复相机状态
                if self.OwnerPlayer and self.OwnerPlayer.CameraControlComponent then
                    self.OwnerPlayer.CameraControlComponent:PopCameraState("BulletJumpAim")
                end
                EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
                return
            end
            self.IsBtnDown = false
            self.OwnerPanel:TryToPlayTargetCommand("BulletJump")
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
        end
    else
        if self.HasAutoBulletJump then
            self:StopAutoRetryTimer()
            self.IsBtnDown = false
            EventManager:FireEvent(EventID.OnQuitBulletJumpAim)
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
        else
            self.OwnerPanel:TryToStopTargetCommand("BulletJump")
        end
    end
      -- 松开时镜头变化
    if self.OwnerPlayer and self.OwnerPlayer.CameraControlComponent then
        self.OwnerPlayer.CameraControlComponent:PopCameraState("BulletJumpAim")
    end
end

function M:ActiveBulletJump(Tag)
    CommonUtils.RemoveValue(self.InActiveTags, Tag)
    if #self.InActiveTags == 0 then
        self:SetRenderOpacity(1)
    end
end

function M:InActiveBulletJump(Tag)
    if not CommonUtils.HasValue(self.InActiveTags, Tag) then
        table.insert(self.InActiveTags, Tag)
    end
    self:SetRenderOpacity(0.5)
end

function M:UpdateButtonInTimer()
    if self.OwnerPlayer:CheckSkillInActive(ESkillName.BulletJump) then
        return
    end
    if self.OwnerPlayer:CheckBulletJumpConditionForUI() then
        self:ActiveBulletJump("NoTime")
    else
        self:InActiveBulletJump("NoTime")
    end
end

function M:ChangeBattleWheelState(bShow)
    if not self.OwnerPlayer then
        return
    end
    local PlayerController = self.OwnerPlayer:GetController()
    if not PlayerController then
        return
    end
    if not bShow then
        self.OwnerPanel:ChangeBattleWheelState(PlayerController.bEnableBattleWheel, false)
    else
        self.OwnerPanel:ChangeBattleWheelState(PlayerController.bEnableBattleWheel, PlayerController.bShowBattleWheel)
        
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

AssembleComponents(M)

return M
