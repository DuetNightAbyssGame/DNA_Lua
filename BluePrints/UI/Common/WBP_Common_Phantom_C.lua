--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type Common_GuidePoint_Phantom_C
local WBP_Common_Phantom_C = Class("BluePrints.UI.BP_UIState_C")

local PhantomStateEnum = {
    Alive = 0,
    Dead = 1,
    Resurrecting = 2
}

function WBP_Common_Phantom_C:OnLoaded(...)
end

function WBP_Common_Phantom_C:Initialize(Initializer)
    self.PhantomEid = nil
    self.PhantomActor = nil
    self.GuideIconImg = nil
    self.FrontPhantomState = nil
    self.ArrowsWidget = nil
    self.IsHostage = false
    self.PlayerIndex = nil
end

--function WBP_Common_Phantom_C:PreConstruct(IsDesignTime)
--end

function WBP_Common_Phantom_C:Construct()
    self.Super.Construct(self)
    EventManager:AddEvent(EventID.OnHostageDeadUpdateMiniMap, self, self.ChangeHostageMiniMapImage)
    EventManager:AddEvent(EventID.OnTeamRecoveryStateChange, self, self.ChangePhantomMiniMapIcon)
end

function WBP_Common_Phantom_C:Destruct()
    self.Super.Destruct(self)
    EventManager:RemoveEvent(EventID.OnHostageDeadUpdateMiniMap, self)
    EventManager:RemoveEvent(EventID.OnTeamRecoveryStateChange, self)
end

function WBP_Common_Phantom_C:ChangeHostageMiniMapImage(IsDead)
    if self.IsHostage then
        if IsDead then
            self.Img_Avatar:SetBrushResourceObject(LoadObject('/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Rescue_HostageB.T_Gp_Rescue_HostageB'))
        else
            self.Img_Avatar:SetBrushResourceObject(LoadObject('/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Rescue_HostageA.T_Gp_Rescue_HostageA'))
        end
    end
end

-- function WBP_Common_Phantom_C:CheckIsNeedChangeIconState()
--     if self.PhantomActor:IsInRecovering() and self.FrontPhantomState ~= PhantomStateEnum.Resurrecting then
--         DebugPrint("WBP_Common_Phantom_C:CheckIsNeedChangeIconStateColor Recovering", self.PhantomEid)
--         self.FrontPhantomState = PhantomStateEnum.Resurrecting
--         return true
--     elseif self.PhantomActor:IsDead() and self.FrontPhantomState == PhantomStateEnum.Alive then
--         DebugPrint("WBP_Common_Phantom_C:CheckIsNeedChangeIconStateColor dead", self.PhantomEid)
--         self.FrontPhantomState = PhantomStateEnum.Dead
--         return true
--     elseif not self.PhantomActor:IsDead() and self.FrontPhantomState ~= PhantomStateEnum.Alive then
--         self:TryPlayResurgenceSuccessFromResurrectEnd()
--         self.FrontPhantomState = PhantomStateEnum.Alive
--         DebugPrint("WBP_Common_Phantom_C:CheckIsNeedChangeIconStateColor alive", self.PhantomEid)
--         return true
--     elseif not self.PhantomActor:IsInRecovering() and self.PhantomActor:IsDead() and self.FrontPhantomState == PhantomStateEnum.Resurrecting then
--         DebugPrint("WBP_Common_Phantom_C:CheckIsNeedChangeIconStateColor dead", self.PhantomEid)
--         self.FrontPhantomState = PhantomStateEnum.Dead
--         return true
--     end

--     return false
-- end

-- function WBP_Common_Phantom_C:TryPlayResurgenceSuccessFromResurrectEnd()
--     if self.FrontPhantomState == PhantomStateEnum.Resurrecting then
--         DebugPrint("WBP_Common_Phantom_C:TryPlayResurgenceSuccessFromResurrectEnd", self.PhantomEid)
--         self:BindToAnimationFinished(self.Resurgence_Success, {self, self.PlayPhantomNormalAnimation})
--         self:PlayAnimation(self.Resurgence_Success)
--     end
-- end

-- function WBP_Common_Phantom_C:PlayPhantomNormalAnimation()
--     self:PlayAnimation(self.Normal)
-- end

-- function WBP_Common_Phantom_C:SetIconStateStyle()
--     DebugPrint("LHQ_WBP_Common_Phantom_C:SetIconStateStyle", self.PlayerIndex)
--     if not DataMgr.BattleChar[self.PhantomActor.UnitId] and not self.PlayerIndex then
--         return
--     end
--     if self.PlayerIndex and self.PlayerIndex > 0 then
--         if self.FrontPhantomState == PhantomStateEnum.Alive then
--             local TextTure = UGameplayStatics.GetGameInstance(self):GetSceneManager():GetPlayerGuideIcon(self.PlayerIndex, true)
--             local IconImage = LoadObject(TextTure)
--             self.Img_Avatar:SetBrushResourceObject(IconImage)
--         elseif self.FrontPhantomState == PhantomStateEnum.Dead then
--             local TextTure = UGameplayStatics.GetGameInstance(self):GetSceneManager():GetPlayerGuideIcon(self.PlayerIndex, false)
--             local IconImage = LoadObject(TextTure)
--             self.Img_Avatar:SetBrushResourceObject(IconImage)
--         end
--     else
--         if self.FrontPhantomState == PhantomStateEnum.Alive then
--             -- self.Panel_Bg:SetVisibility(UE4.ESlateVisibility.Collapsed)
--             self:PlayAnimation(self.Normal)
--             local MiniIconPath = "/Game/UI/Texture/Dynamic/Image/Head/Mini/"
--             local PhantomGuideIconImg = DataMgr.BattleChar[self.PhantomActor.UnitId].GuideIconImg
--             local NormalIconName = "T_Normal_"..PhantomGuideIconImg
--             local IconImage = LoadObject(MiniIconPath..NormalIconName.."."..NormalIconName)
--             self.Img_Avatar:SetBrushResourceObject(IconImage)
--         elseif self.FrontPhantomState == PhantomStateEnum.Dead then
--             -- self.Panel_Bg:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
--             -- self.Bar_Circle_Bg:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToLinearColor("DD1F47"))
--             -- self.Bg_Black01:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToLinearColor("DD1F47"))
--             self:PlayAnimation(self.Dead)
--             local MiniIconPath = "/Game/UI/Texture/Dynamic/Image/Head/Mini/"
--             local PhantomGuideIconImg = DataMgr.BattleChar[self.PhantomActor.UnitId].GuideIconImg
--             local DeadIconName = "T_Dead_"..PhantomGuideIconImg
--             local IconImage = LoadObject(MiniIconPath..DeadIconName.."."..DeadIconName)
--             self.Img_Avatar:SetBrushResourceObject(IconImage)
--         end
--     end
-- end

function WBP_Common_Phantom_C:GetCanRecoveryCount()
    if self.PhantomActor then
        return self.PhantomActor:GetRecoveryMaxCount() - self.PhantomActor:GetRecoveryCount()
     end
     return 0
end

-- function WBP_Common_Phantom_C:UpdatePhantomCanRecoveryCount()
--     if self.PhantomActor:IsDead() then
--         local CanRecoveryCount = self:GetCanRecoveryCount()
--         if CanRecoveryCount > 0 and not self.PhantomActor:IsInRecovering() then
--             self.Panel_RemainTimes:SetRenderOpacity(1.0)
--             self.Text_Times:SetText(CanRecoveryCount)
--         end
--     end
-- end

-- function WBP_Common_Phantom_C:UpdateRecoveryBarCircle()
--     if self.PhantomActor:IsInRecovering() and self.FrontPhantomState == PhantomStateEnum.Resurrecting then
--         self.Text_Percent:SetText(math.floor(self.PhantomActor:GetRecoveryPercent()))
--         self.Bar_Circle:GetDynamicMaterial():SetScalarParameterValue("Percent",  self.PhantomActor:GetRecoveryPercent() / 100)
--     end

-- end

-- function WBP_Common_Phantom_C:UpdatePhantomGuide()
--     if self.IsHostage then
--         return
--     end
--     if self:CheckIsNeedChangeIconState() then
--         self:SetIconStateStyle()
--     end

--     -- self:UpdatePhantomCanRecoveryCount()
--     -- self:UpdateRecoveryBarCircle()
-- end

function WBP_Common_Phantom_C:ChangePhantomMiniMapIcon(TargetEid, State, PrevState)
    if TargetEid ~= self.PhantomEid then
        return
    end
    if not (self.PhantomActor and DataMgr.BattleChar[self.PhantomActor.UnitId]) and not self.PlayerIndex then
        return
    end
    if self.PlayerIndex and self.PlayerIndex > 0 then
        if State == UE4.ETeamRecoveryState.Alive then
            local TextTure = UGameplayStatics.GetGameInstance(self):GetSceneManager():GetPlayerGuideIcon(self.PlayerIndex, true)
            UE4.UResourceLibrary.LoadObjectAsync(self, TextTure, {self, WBP_Common_Phantom_C.SetImgAvatar})
        elseif State == UE4.ETeamRecoveryState.Dying then
            local TextTure = UGameplayStatics.GetGameInstance(self):GetSceneManager():GetPlayerGuideIcon(self.PlayerIndex, false)
            UE4.UResourceLibrary.LoadObjectAsync(self, TextTure, {self, WBP_Common_Phantom_C.SetImgAvatar})
        end
    else
        if State == UE4.ETeamRecoveryState.Alive then
            local MiniIconPath = "/Game/UI/Texture/Dynamic/Image/Head/Mini/"
            if not self.PhantomActor then
                return
            end
            local PhantomGuideIconImg = DataMgr.BattleChar[self.PhantomActor.CurrentRoleId].GuideIconImg
            local NormalIconName = "T_Normal_"..PhantomGuideIconImg
            UE4.UResourceLibrary.LoadObjectAsync(self, MiniIconPath..NormalIconName.."."..NormalIconName, {self, WBP_Common_Phantom_C.SetImgAvatar})
        elseif State == UE4.ETeamRecoveryState.Dying then
            local MiniIconPath = "/Game/UI/Texture/Dynamic/Image/Head/Mini/"
            if not self.PhantomActor then
                return
            end
            local PhantomGuideIconImg = DataMgr.BattleChar[self.PhantomActor.CurrentRoleId].GuideIconImg
            local DeadIconName = "T_Dead_"..PhantomGuideIconImg
            UE4.UResourceLibrary.LoadObjectAsync(self, MiniIconPath..DeadIconName.."."..DeadIconName, {self, WBP_Common_Phantom_C.SetImgAvatar})
        end
    end
end

function WBP_Common_Phantom_C:SetImgAvatar(IconImage)
    self.Img_Avatar:SetBrushResourceObject(IconImage)
end

return WBP_Common_Phantom_C
