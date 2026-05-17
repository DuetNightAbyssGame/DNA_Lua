require "UnLua"

local M = Class({"BluePrints.UI.BP_UIState_C"})
local HUDUIName = "AprilFoolDayHUD"


function M:Construct()
    -- 进入动画结束后后播放随机动画
    self:BindToAnimationFinished(self.In, {self, self.StartRandom})
    -- 随机动画结束后显示变身Icon并变身
    self:BindToAnimationFinished(self.Draw, {self, self.OnRandomFinished})
    -- 关闭界面后打开主界面
    self:BindToAnimationFinished(self.Out, {self, self.OnOutAnimationFinished})
    -- 玩家死亡时关闭界面
    self:AddDispatcher(EventID.OnTeamRecoveryStateChange, self, self.CloseOnPlayerDead)
    self.Avatar = GWorld:GetAvatar()

    self:PlayAnimation(self.In)
    AudioManager(self):PlayUISound(self, "event:/ui/activity/fools_day_transform_panel_show", nil,nil)
end

function M:Destruct()
    self:UnbindAllFromAnimationFinished(self.In)
    self:UnbindAllFromAnimationFinished(self.Draw)
    self:UnbindAllFromAnimationFinished(self.Out)
end

-- 玩家死亡时关闭界面
function M:CloseOnPlayerDead(Eid, Type, PrevType)
    local Controller = self:GetOwningPlayer()
    local Player = Controller:K2_GetPawn()
    if Player and (Eid == Player:GetEid()) then
        if (Type == UE4.ETeamRecoveryState.Dying) then
            self.SkipOpenFoolHUD = true
            self:Close()
        end
    end
end

-- 开始随机
function M:StartRandom()
    self:PlayAnimation(self.Draw)  -- 播放随机动画
    self.TransformID, self.IsUnOwned = self:GetRandomTransformData()
end

-- 随机 变身的数据
function M:GetRandomTransformData()
    if (not self.Avatar) or (not self.Avatar.UnlockedFoolsDayTransforms) then
        return
    end

    local OwnedIds  = {} -- 已拥有的变身
    local UnownedIds  = {}  -- 未拥有的变身
    for _, Data in pairs(DataMgr.TransformAFDayEvent or {}) do
        local Id = Data.TransformID
        if self.Avatar.UnlockedFoolsDayTransforms[Id] then  -- 服务器表变身表
            table.insert(OwnedIds, Id)
        else
            table.insert(UnownedIds, Id)
        end
    end

    if #OwnedIds == 0 and #UnownedIds == 0 then
        return
    end

    if #UnownedIds > 0 then  -- 存在未拥有的，从未拥有表中随机
        local RandIndex = CommonUtils:RandomInt(1, #UnownedIds)
        return UnownedIds[RandIndex], true
    else
        local RandIndex = CommonUtils:RandomInt(1, #OwnedIds)
        return OwnedIds[RandIndex], false
    end
end

-- 随机动画结束后：显示变身Icon & 变身 & 关闭界面
function M:OnRandomFinished()
    if not self.TransformID then
        self:Close()
        return
    end
    -- 显示变身Icon
    self.DrawItem:StartDrawAnimation(self.TransformID)
    -- 服务端记录变身ID
    if self.IsUnOwned then
        self.Avatar:FoolsDayUnlockTransform(self.TransformID)
    end
    -- 数据埋点
    self.Avatar:CallServerMethod("FoolsDayUseTransform")

    self:AddTimer(1, function()
        self:PlayAnimation(self.Out)
    end)
end

-- 关闭界面后打开主界面
function M:OnOutAnimationFinished()
    --客户端玩家变身
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local Avatar = GWorld:GetAvatar()
    if PlayerCharacter and IsValid(PlayerCharacter) then
        PlayerCharacter:ApplyAFDTransform(self.TransformID)
        Avatar:RegionOnlineTransformAFDay(self.TransformID)
        AudioManager(self):PlayFMODSound(PlayerCharacter, nil, "event:/ui/activity/fools_day_transform_player_3d")
    end
    -- 关闭界面
    self:Close()
    -- 打开主界面
    if not self.SkipOpenFoolHUD then
        UIManager():LoadUINew(HUDUIName, self.TransformID)
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    return UE4.UWidgetBlueprintLibrary.Handled()
end


return M