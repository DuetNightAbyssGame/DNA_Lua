--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local M = Class("BluePrints/Item/Chest/BP_MechanismBase_C")

function M:OpenMechanism()
    if self.OpenState then return end
    self:UpdateRegionData("OpenState", true)
    self:CreateReward()
    self:DeactiveGuide()
    EventManager:FireEvent(EventID.OnDeliveryMeshanismOpen,self.CreatorId)
end

function M:OnActorReady(Info)
    M.Super.OnActorReady(self, Info)
    self:GMUnlock()
end

function M:GMUnlock()
    if not Const.UnlockRegionTeleport then
        return
    end
    if self.StateId == 901000 then
        self:ChangeState("GM", 0, 901001)
    elseif self.StateId == 901010 then
        self:ChangeState("GM", 0, 901011)
    end
end

function M:ShowToast(ToastText)
    if not DataMgr.TeleportStaticId2TeleportPointName[self.CreatorId] then
        GWorld.logger.error("传送点"..self:GetName()..", 静态刷新点ID"..self.CreatorId.."表内配置缺失")
        return true
    end
    local AnchorName = DataMgr.TeleportStaticId2TeleportPointName[self.CreatorId]["TeleportPointName"]
    if not AnchorName then
        GWorld.logger.error("传送点"..self:GetName()..", 静态刷新点ID"..self.CreatorId.."表内配置缺少名字")
        return true
    end
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    UIManager:ShowUITip(UIConst.Tip_CommonTop, GText(AnchorName)..GText(ToastText))
    return true
end

function M:InitTempleInteractiveComponent()
	if not DataMgr.TeleportStaticId2TeleportPointName[self.CreatorId] then
		return
	end
    self.TempleIds = DataMgr.TeleportStaticId2TeleportPointName[self.CreatorId]["Temples"]
    if not self.TempleIds then
        return
    end
    self.TempleOrder = {}  -- 记录一下每个神庙前置神庙的Id，用于检测能否进入当前神庙  {当前id : 前置id}
    self.TempleInteractiveComponents = {}
	for i = 1, #self.TempleIds do
        -- 添加神庙交互组件
        local ComponentClass = LoadClass('/Game/BluePrints/Item/Delivery/BP_DeliveryTempleInteractiveComponent.BP_DeliveryTempleInteractiveComponent_C')
	    local Component = self:AddComponentByClass(ComponentClass, false, FTransform(), false)
        Component:SetTempleId(self.TempleIds[i])
        Component:SetInteractiveDistance(self.DefaultInteractiveComponent.InteractiveDistance)
        Component.InteractiveAngle = self.DefaultInteractiveComponent.InteractiveAngle
        Component.InteractiveFaceAngle = self.DefaultInteractiveComponent.InteractiveFaceAngle
        Component:InitCommonUIConfirmID(self.Data.InteractiveId)
        self.TempleInteractiveComponents[i] = Component
        if i >= 2 then
            self.TempleOrder[self.TempleIds[i]] = self.TempleIds[i - 1]
        end
    end
end

function M:DisplayInteractiveBtn(PlayerActor)
    if self.TempleInteractiveComponents then
        for i = 1, #self.TempleInteractiveComponents do
            self.TempleInteractiveComponents[i]:DisplayInteractiveBtn(PlayerActor)
        end
    end
end

function M:NotDisplayInteractiveBtn(PlayerActor)
    if self.TempleInteractiveComponents then
        for i = 1, #self.TempleInteractiveComponents do
            self.TempleInteractiveComponents[i]:NotDisplayInteractiveBtn(PlayerActor)
        end
    end
end

function M:OnEnterState(NowStateId)
    if not self.UnitParams.TempleStateId then
        return
    end
	if NowStateId == self.UnitParams.TempleStateId then
        self:InitTempleInteractiveComponent()
    end
end

------- 第一步：在传送机关执行EndPlay的时候 每一个传送机关向Avatar注册自己的信息 两个字段
--- 1. 该传送机关的WorldRegionEid
--- 2. 该传送机关的CreatorId
------- 第二步：在切换区域的时候通过 通过收集的信息去遍历有没有解锁
------- 如果没有解锁任何传送机关 则通过CreatorId去表里判断是不是默认解锁，并向服务器存储信息
-------




return M
