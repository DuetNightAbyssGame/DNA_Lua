--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_ProgressOrgan_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.LeftCannonIndex = 1
    self.RightCannonIndex = 2
    self.LeftCannonKey = "Paotai_42001_02_Eid"
    self.RightCannonKey = "Paotai_42001_01_Eid"
    self.PropEffectId = 42001
    self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
    self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
        self:InitVariable()
        if not self.LeftCannon or not self.RightCannon then
            DebugPrint("@zyh 拿不到两个炮台")
            return
        end
        self.MaxCD = self.LeftCannon.ShootCD
        self.CurrentCDLeft = self.MaxCD
        self.CurrentCDRight = self.MaxCD
        self:InitListenEvents()
        if not self:IsExistTimer("UpdateSWSHUDInTimer") then
            self:AddTimer(0.1, self.UpdateUIInfoInTimer, true, 0, "UpdateSWSHUDInTimer", false)
        end
        if self.OwnerPlayer.ActivePropEffectId == self.PropEffectId then
            self:OnSwitchOnCannonProp()
        end
end

function M:InitVariable()
    if not self.OwnerPlayer then
        DebugPrint("@zyh 拿不到Player")
        return
    end
    if self.OwnerPlayer.GetInt then
        self.LeftCannonEid = self.OwnerPlayer:GetInt(self.LeftCannonKey)
        self.RightCannonEid = self.OwnerPlayer:GetInt(self.RightCannonKey)
    end
    if not self.LeftCannonEid or not self.RightCannonEid then
        DebugPrint("@zyh 拿不到两个Eid")
        return
    end
    self.LeftCannon = Battle(self):GetEntity(self.LeftCannonEid)
    self.RightCannon = Battle(self):GetEntity(self.RightCannonEid)
end

function M:InitListenEvents()
    self:AddDispatcher(EventID.OnSwitchOnCannonProp, self, self.OnSwitchOnCannonProp)
    self:AddDispatcher(EventID.OnSwitchOffCannonProp, self, self.OnSwitchOffCannonProp)
    self:AddDispatcher(EventID.OnSWSCannonFired, self, self.OnSWSCannonFired)
    self:AddDispatcher(EventID.OnSWSCannonInCD, self, self.OnSWSCannonInCD)
end

function M:OnSwitchOnCannonProp()
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_DUNGEON_SWSCannon_Equip"))
    self:PlayAnimation(self.Overlay_On)
end

function M:OnSwitchOffCannonProp()
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_DUNGEON_SWSCannon_Unequip"))
    self:PlayAnimation(self.Overlay_Off)
end

function M:OnSWSCannonFired(Index)
    local TempIndex
    if Index == self.LeftCannonIndex then
        TempIndex = "Left"
    elseif Index == self.RightCannonIndex then
        TempIndex = "Right"
    else
        DebugPrint("@Zyh 山外山大炮Index传的不对")
        return
    end
    DebugPrint("@zyh", TempIndex, "开炮")
    self["Image_Progress_"..TempIndex]:SetPercent(0)
    self["CurrentCD"..TempIndex] = 0
    self:StopAnimation(self[TempIndex.."_Full"])
    self:PlayAnimation(self[TempIndex.."_Normal"])
end

function M:OnSWSCannonInCD()
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_DUNGEON_SWSCannon_Reload"))
    self:PlayAnimation(self.NoBullet)
end

function M:UpdateUIInfoInTimer()
    self:UpdateCannonInfo(self.LeftCannon, "Left")
    self:UpdateCannonInfo(self.RightCannon, "Right")
end

function M:UpdateCannonInfo(CannonActor, Index)
    self["CurrentCD"..Index] = math.min(self["CurrentCD"..Index] + 0.1, self.MaxCD)
    local Percent = self["CurrentCD"..Index] / self.MaxCD
    self["Image_Progress_"..Index]:SetPercent(Percent)
    local CanShoot = CannonActor.CanShoot
    if CanShoot and not self["LastCanShoot"..Index] then
        self:PlayAnimation(self[Index.."_Full"])
        AudioManager(self):PlayUISound(self, "event:/ui/common/shanwaishan_cannon_charging_complete", nil, nil)
    end
    self["LastCanShoot"..Index] = CanShoot
end



--function M:Destruct()
--end


return M
