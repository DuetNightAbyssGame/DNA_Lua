
require "UnLua"

---@type Battle_Menu_Phone_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

M._components = {
    "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent",
}

local BATTLE_WHEEL_CNT = 8

local BATTLE_WHEEL_STATE = {
    NORMAL = 0,
    CANCEL = 1,
}

function M:Initialize(Initializer)
end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    self:RefreshEquipInfo()
	self:InitSlotAnimation()

    self.Switcher_State:SetActiveWidgetIndex(BATTLE_WHEEL_STATE.NORMAL)
    
    -- 注册事件
    self:InitEventDispatcher()
end

function M:InitEventDispatcher()
    EventManager:AddEvent(EventID.OnChangeBattleWheel,self,self.RefreshEquipInfo)
    EventManager:AddEvent(EventID.OnTakeOffBattleWheel,self,self.RefreshEquipInfo)
    EventManager:AddEvent(EventID.OnExchangeBattleWheel,self,self.RefreshEquipInfo)
    EventManager:AddEvent(EventID.OnPropChangeWheels,self,self.RefreshEquipInfo)
    EventManager:AddEvent(EventID.OnChangeWheel,self,self.RefreshEquipInfo)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:OnPressedButton()
    local PlayerCharacter = self.OwnerPanel.OwnerPlayer
    if PlayerCharacter then
        PlayerCharacter:OpenBattleWheel()
        RunAsyncTask(self, "OnPressedButtonTask", function(CoroutineObj)
            local InBattleWheelMenu = UIManager(self):GetUIObjAsync("InBattleWheelMenu",CoroutineObj)
            InBattleWheelMenu:SetWheelCenter(self.Bg)
            InBattleWheelMenu:BindMenuButton(self)
            self:SelectNoneSlot()
			
			EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
            self.Switcher_State:SetActiveWidgetIndex(BATTLE_WHEEL_STATE.CANCEL)
        end)
    end
end

function M:OnReleasedButton()
    DebugPrint("gmy@OnReleasedButton")
    RunAsyncTask(self,"OnReleasedButtonTask", function(CoroutineObj)
        -- 找到 UIManager:GetUIObj("InBattleWheelMenu"), 尝试调用SelectAndCloseMenu
        local InBattleWheelMenu = UIManager(self):GetUIObjAsync("InBattleWheelMenu",CoroutineObj)
        if InBattleWheelMenu then
            InBattleWheelMenu:SelectAndCloseMenu()
        end
        
        self:ClearSelectSlot()
        self.Switcher_State:SetActiveWidgetIndex(BATTLE_WHEEL_STATE.NORMAL)
    end)
end

function M:SelectSlot(Index)
	EMUIAnimationSubsystem:EMPlayAnimation(self, self["Select_" .. Index])
end

function M:ClearSelectSlot()
    self:StopAllAnimations()
    
	EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
end

function M:SelectNoneSlot()
	EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
end

function M:RefreshEquipInfo()
    -- 检查战斗轮盘的槽位的装备情况
    local Avatar = GWorld:GetAvatar()
    if Avatar == nil then return end

    local CurrentWheel = Avatar.Wheels[Avatar.WheelIndex]
	for Index = 1, BATTLE_WHEEL_CNT do
		local AvatarSlot = CurrentWheel[Index]

		if AvatarSlot then
			if not IsEmptyTable(AvatarSlot) and AvatarSlot.ResourceId ~= 0 then
				EMUIAnimationSubsystem:EMPlayAnimation(self, self["Set_" .. Index], EUMGSequencePlayMode.Forward)
			else
				EMUIAnimationSubsystem:EMPlayAnimation(self, self["Set_" .. Index], EUMGSequencePlayMode.Reverse)
			end
		end
	end
end

function M:Destruct()
    EventManager:RemoveEvent(EventID.OnChangeBattleWheel,self)
    EventManager:RemoveEvent(EventID.OnTakeOffBattleWheel,self)
    EventManager:RemoveEvent(EventID.OnExchangeBattleWheel,self)
    EventManager:RemoveEvent(EventID.OnPropChangeWheels,self,self.RefreshEquipInfo)
    EventManager:RemoveEvent(EventID.OnChangeWheel,self,self.RefreshEquipInfo)
end

function M.BattleMenuDown(BattlePhone, Index, StartPos)
    DebugPrint("gmy@WBP_Battle_Menu_Phone_C M.BattleMenuDown", BattlePhone, Index, StartPos)
    local BattleMenu = BattlePhone.Battle_Menu

    local PlayerCharacter = BattleMenu.OwnerPanel.OwnerPlayer
    BattleMenu.TotalDeltaDis = FVector2D(0, 0)
	
    if PlayerCharacter and PlayerCharacter:GetController().bEnableBattleWheel then
        PlayerCharacter:OpenBattleWheel()
        RunAsyncTask(M, "OnPressedButtonTask", function(CoroutineObj)
            local InBattleWheelMenu = UIManager(BattleMenu):GetUIObjAsync("InBattleWheelMenu",CoroutineObj)
            if InBattleWheelMenu then
                InBattleWheelMenu:SetWheelCenter(BattleMenu.Bg)
                InBattleWheelMenu:BindMenuButton(BattleMenu)
            end
        end)
        -- 按下时，所有槽位都置为按下状态(anim名字为click)
        DebugPrint(LXYTag, "轮盘按钮播放打开动效")
        EMUIAnimationSubsystem:EMPlayAnimation(BattleMenu, BattleMenu.Press)
        BattleMenu.Switcher_State:SetActiveWidgetIndex(BATTLE_WHEEL_STATE.CANCEL)
    end
end

function M.BattleMenuMove(BattlePhone, TouchFingerCount, Index, LastPos, TotalDeltaDis, LastDeltaDis)
    DebugPrint("gmy@BattleMenuMove", TouchFingerCount, Index, LastPos, TotalDeltaDis, LastDeltaDis)
    local BattleMenu = BattlePhone.Battle_Menu

    BattleMenu.TotalDeltaDis = TotalDeltaDis
end

function M.BattleMenuUp(BattlePhone, Index, WidgetLocalPos, LastWidgetTouchPos, EndTouchPos, TotalDeltaDis)
    DebugPrint("gmy@BattleMenuUp", Index, WidgetLocalPos, LastWidgetTouchPos, EndTouchPos, TotalDeltaDis)
    local BattleMenu = BattlePhone.Battle_Menu

	local PlayerCharacter = BattleMenu.OwnerPanel.OwnerPlayer
	if PlayerCharacter and PlayerCharacter:GetController().bEnableBattleWheel then
		PlayerCharacter:CloseBattleWheel()
	else
		return
	end
    DebugPrint(LXYTag, "轮盘按钮播放关闭动效")
    BattleMenu:ClearSelectSlot()
    BattleMenu.Switcher_State:SetActiveWidgetIndex(BATTLE_WHEEL_STATE.NORMAL)
    BattleMenu.TotalDeltaDis = FVector2D(0, 0)
end

function M:InitSlotAnimation()
	EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
end

AssembleComponents(M)

return M
