require "UnLua"

local M = Class("BluePrints.UI.BP_UIState_C")

function M:OnLoaded(...)
    self.TransformID = ...
    self:InitEscButton()
    self:InitCameraButton()
    self:InitTransformButtons()
end

function M:ReceiveEnterState(StackAction)
    M.Super.ReceiveEnterState(self,StackAction)
    if(self.CloseByChild)then
        self.CloseByChild = false
        self:BlockAllUIInput(true)
        self:AddTimer(0.1,function()
            self:BlockAllUIInput(false)
            self:Close()
        end)
    end
end

function M:Construct()
    self:PlayAnimation(self.In)
    self:BindToAnimationFinished(self.Out, {self, self.OnOutAnimationFinished})
	self:AddDispatcher(EventID.OnInitScreenshotParams,self,self.OnInitScreenshotParams)
    self:AddDispatcher(EventID.OnTeamRecoveryStateChange, self, self.CloseOnPlayerDead)  -- 玩家死亡时关闭界面
end

function M:Destruct()
    self:UnbindAllFromAnimationFinished(self.Out)
    self.Btn_Close.OnClicked:Clear()
end

function M:CloseOnPlayerDead(Eid, Type, PrevType)
    local Controller = self:GetOwningPlayer()
    local Player = Controller:K2_GetPawn()
    if Player and (Eid == Player:GetEid()) then
        if (Type == UE4.ETeamRecoveryState.Dying) then
            self:Close()
        end
    end
end

function M:InitEscButton()
    self.Btn_Close.OnClicked:Add(self,self.CloseSelf)
end

function M:InitCameraButton()
    self.Pos_Entry:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Btn_Camera:PlayAnimation(self.Btn_Camera.Normal)
    -- 设置图片
    local CameraData = DataMgr.MainUI[15]
    if not CameraData then
        return
    end
    local Texture = LoadObject(CameraData.Icon)
    self.Btn_Camera.Image_Top:SetBrushFromTexture(Texture)
    -- 按钮事件
    self.Btn_Camera.Btn_top.OnClicked:Clear()
    self.Btn_Camera.Btn_top.OnClicked:Add(self,self.OpenCamera)
    -- 按键提示
    self.Btn_Camera.Common_Key_Hud_PC:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Camera.Name:SetText(GText(CameraData.Name))
end

-- 打开相机
function M:OpenCamera()
    -- 跳过解锁条件
    UIManager(self):LoadUINew("PhotoCameraMain")
end

function M:OnInitScreenshotParams(Params)
    Params.IsAprilFoolsDayActivity = true
    Params.TargetActors ={ UE4.UGameplayStatics.GetPlayerCharacter(self, 0) }
    Params.IsLargeRange = true
    Params.DetectTargetMethod = 3
    Params.AFDTransformID = self.TransformID
end

-- 再次随机
function M:Randomransform()
    self:CloseSelf()
    self.LoadUIName = "AprilFoolDayRandomTrans"
end

-- 切换变形
function M:SwitchTransform()
    self:CloseSelf()
    self.LoadUIName = "AprilFoolDayTransList"
end

-- 关闭UI
function M:CloseSelf()
    if self:IsAnimationPlaying(self.In) then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
    self:PlayAnimation(self.Out)
end

function M:OnOutAnimationFinished()
    self:Close()
end

function M:Close()
    if(rawget(self,"bClosed"))then
        return
    end
    if(UIManager(self):GetUIObj("PhotoCameraMain"))then
        return
    end
    rawset(self,"bClosed",true)
    M.Super.Close(self)

    if self.LoadUIName then
        UIManager():LoadUINew(self.LoadUIName, self.TransformID)
        self.LoadUIName = nil
    else
        -- 恢复主界面UI
        -- local UIManager = GWorld.GameInstance:GetGameUIManager()
        -- local BattleMainUI = UIManager:GetUI('BattleMain')
        -- if BattleMainUI then
        --     BattleMainUI:TryRecoverUI()
        -- end
        -- 取消变身
        local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
        if PlayerCharacter and IsValid(PlayerCharacter) then
            PlayerCharacter:CancelAFDTransform()
        end
    end
end

-- Begin 子类实现，用于区分手机和PC
function M:InitTransformButtons()
end
-- End 子类实现

return M