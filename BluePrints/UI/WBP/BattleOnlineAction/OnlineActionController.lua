--- 联机动作Controller
local OnlineActionModel = require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionModel"
local OnlineActionCommon = require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionCommon"

local M = Class("BluePrints.Common.MVC.Controller")

--gm OpenOnlineActionView 1 打开界面，以动作主人身份
--gm OpenOnlineActionView 2 打开界面，以被邀请者身份
--gm OpenOnlineActionView -1    关闭界面
--bClear 是否清除数据
function M:Init(bClear)
    if self.bInited and not bClear then
        return
    end
    DebugPrint("OnlineActionController Init")
    M.Super.Init(self)
    -- EventManager:AddEvent(EventID.CloseLoading , self, self.OnCloseLoading)
    OnlineActionModel:Init(bClear)
    self.OpenReason=nil --1代表动作主人打开，2代表被邀请者打开 其代表Btn隐藏或关闭
    self.MainPage=nil --主界面引用
    self.OnlineActionBtn=nil --BattleUI上的按钮引用
    self:InitEvent()
end

function M:InitEvent()
    --收到申请
    EventManager:RemoveEvent(EventID.ReceivedOthersOnlineActionApplication, self)
    EventManager:AddEvent(EventID.ReceivedOthersOnlineActionApplication, self, self.OnReceiveApplyInfo)
    --申请被拒绝
    EventManager:RemoveEvent(EventID.OnReceivedOnlineActionApplicationReject, self)
    EventManager:AddEvent(EventID.OnReceivedOnlineActionApplicationReject, self, self.OnReceivedRejectApply)
    --收到邀请
    EventManager:RemoveEvent(EventID.ReceivedOthersOnlineActionInvitation, self) 
    EventManager:AddEvent(EventID.ReceivedOthersOnlineActionInvitation, self, self.OnReceivedInvitation)
    --邀请被拒绝
    EventManager:RemoveEvent(EventID.OnReceivedOnlineActionInvitationReject, self)
    EventManager:AddEvent(EventID.OnReceivedOnlineActionInvitationReject, self, self.OnReceivedRejectInvitation)
    --动作关闭
    EventManager:RemoveEvent(EventID.RequestDeadRegionOnlineItem, self)
    EventManager:AddEvent(EventID.RequestDeadRegionOnlineItem, self, self.OnRequestDeadRegionOnlineItem)

    EventManager:RemoveEvent(EventID.OnReceivedOnlineActionApplicationAgree, self)
    EventManager:AddEvent(EventID.OnReceivedOnlineActionApplicationAgree, self, self.OnReceivedOnlineActionApplicationAgree)
    --收到同意邀请
    EventManager:RemoveEvent(EventID.OnReceivedOnlineActionInvitationAgree, self)
    EventManager:AddEvent(EventID.OnReceivedOnlineActionInvitationAgree, self, self.OnReceivedOnlineActionInvitationAgree)
end

function M:RemoveEvent()
     --收到申请
    EventManager:RemoveEvent(EventID.ReceivedOthersOnlineActionApplication, self)
    --申请被拒绝
    EventManager:RemoveEvent(EventID.OnReceivedOnlineActionApplicationReject, self)
    --收到邀请
    EventManager:RemoveEvent(EventID.ReceivedOthersOnlineActionInvitation, self) 
    --邀请被拒绝
    EventManager:RemoveEvent(EventID.OnReceivedOnlineActionInvitationReject, self)
    --动作关闭
    EventManager:RemoveEvent(EventID.RequestDeadRegionOnlineItem, self)
   
    EventManager:RemoveEvent(EventID.OnReceivedOnlineActionApplicationAgree, self)   

    EventManager:RemoveEvent(EventID.OnReceivedOnlineActionInvitationAgree, self)
end
-- function M:GetEventName()
--     return ""
-- end
--- 创建交互道具后调用
function M:OnCreatOnlineAction(UniqueId)
    if not OnlineActionModel:IsInRegionOnline() then
        return
    end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    local CurResourceId = Player.CurResourceId
    if CurResourceId == 0 then
        DebugPrint("角色已停止联机动作")
        return false
    end
    if OnlineActionCommon.UseSyncNearbyPlayers then
        --通知多线程查找附近玩家
        local Sync = UE4.URegionSyncSubsystem.GetInstance(GWorld.GameInstance)
        if Sync then
            Sync:StartNearbyQuery()
        end
    end
    self.OpenReason=1
    self:ChangeAction(UniqueId)
    self:ShowBtn(1)
    DebugPrint("yklua :角色创建联机机关 UniqueId "..UniqueId)
end

--改变动作，影响车的座位
function M:ChangeAction(UniqueId)
    OnlineActionModel:ChangeAction(UniqueId)
end

function M:OnRequestDeadRegionOnlineItem()
    DebugPrint("联机动作Btn收到动作关系消息，开始隐藏OnRequestDeadRegionOnlineItem")
    self:OnEndOnlineAction()
end

--外部调用，动作主人结束时调用
function M:OnEndOnlineAction()
    if OnlineActionCommon.UseSyncNearbyPlayers then
        local Sync = UE4.URegionSyncSubsystem.GetInstance(GWorld.GameInstance)
        if Sync then
            Sync:StopNearbyQuery()
        end
    end

    OnlineActionModel:ClearAllApply()
    if self.OpenReason==1  then
        if OnlineActionModel:HaveOtherInvitation() then --如果有其他邀请，切换成接受邀请的模式
            self.OpenReason=2
        else
            self.OpenReason=nil
            self:HideBtn()
        end
    end
end



--[[
----服务端相关接口
--邀请相关
-客户端调用
RequestHostInvitationOther --邀请别人
OnRequestOtherUserRegionOnlineItem --回复邀请
-服务端调用
RequestOtherUserRegionOnlineItem --收到邀请

--申请相关
-客户端调用
RequestChangeRegionOnlineItemState--申请使用
OnRequestUseOwnerRegionOnlineItem --恢复申请
-服务端调用
RequestUseOwnerRegionOnlineItem --收到申请
]]



-- function M:CheckAndOpenView(WorldContex, SelectItemId)
--     if not self:GetView(WorldContex) then
--         self:OpenView(WorldContex, SelectItemId)
--     end
-- end

---互动按钮是否打开
function M:IsShowingBtn()
    return self.OpenReason~=nil
end

function M:ShowBtn(Reason)
    --OnlineActionModel:CreatFakeInvitationInfo()
    self.OpenReason=Reason
    local BattleMain = UIManager(self):GetUIObj("BattleMain")
    if not BattleMain then
        ScreenPrint("yklua OnlineAction:ShowBtn 没有拿到BattleMain")
        return
    end
    
    -- -- 如果按钮已经存在，直接显示
    -- if BattleMain.OnlineActionBtn then
    --     BattleMain.OnlineActionBtn:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    --     return
    -- end
    
    -- 创建联机动作按钮
    local OnlineActionBtn = UIManager(self):CreateWidget(OnlineActionCommon.OnlineActionBtnBPPath)
    if not OnlineActionBtn then
        ScreenPrint("yklua OnlineAction:ShowBtn 创建按钮失败")
        return
    end
    self.OnlineActionBtn=OnlineActionBtn
    -- 将按钮添加到BattleMain界面
    BattleMain.Pos_OnlineAction:ClearChildren()
    BattleMain.Pos_OnlineAction:AddChild(OnlineActionBtn)
    BattleMain.Pos_OnlineAction:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    BattleMain.OnlineActionBtn=OnlineActionBtn
    OnlineActionBtn.Parent=BattleMain
    OnlineActionBtn:Show()

    -- if Reason==1 then
    --     OnlineActionModel:FindPlayerAround()
    -- end
    --OnlineActionModel:CreatFakeInvitationInfo()

end

function M:ShowBtnBubble(BubbleKind)
    if self.OnlineActionBtn then
        self.OnlineActionBtn:ShowOrHideBubble(BubbleKind)
    end
end

--- 隐藏互动按钮
function M:HideBtn()
    DebugPrint("OnlineAction:HideBtn")
    local BattleMain = UIManager(self):GetUIObj("BattleMain")
    if not BattleMain then
        ScreenPrint("yklua OnlineAction:HideBtn 没有拿到BattleMain")
        return
    end
    -- 先播放按钮消失动画
    if self.OnlineActionBtn and IsValid(self.OnlineActionBtn) then
        self.OnlineActionBtn:PlayOutAni(function()
            BattleMain.Pos_OnlineAction:ClearChildren()
            BattleMain.OnlineActionBtn = nil
            self.OnlineActionBtn = nil
            self.OpenReason = nil
        end)
    else
        BattleMain.Pos_OnlineAction:ClearChildren()
        BattleMain.OnlineActionBtn = nil
        self.OnlineActionBtn = nil
        self.OpenReason = nil
    end
end
--打开联机动作主界面
function M:OpenView(PlayerInfo,ForceServerData)
    DebugPrint("OnlineAction:OpenView")
    if self.OpenReason==1 then
        OnlineActionModel:FindPlayerAround()
    end
    AudioManager(self):PlayUISound(self.OnlineActionBtn, "event:/ui/common/online_invite_interact_panel_expand", "OnlineActionPageOpen", nil)
    self.MainPage = M.Super.OpenView(self, nil,OnlineActionCommon.UIName)
    self.MainPage :InitBaseView(self.OpenReason)
    return self.MainPage
end
--设置互动按钮红点隐藏
function M:SetBtnReddotRead()
    if self.OnlineActionBtn then
        self.OnlineActionBtn:ShowOrHideReddot(false)
        self.OnlineActionBtn:ShowOrHideBubble(0)
    end
end

function  M:CloseView()
    --self.MainPage:Close()
    if self.OnlineActionBtn then
        if IsValid(self.OnlineActionBtn) then
            self.OnlineActionBtn:ShowOrHideReddot(false)
            self.OnlineActionBtn:ShowOrHideBubble(0)
        end
    end
    self:CheckHideBtn()
    AudioManager(self):SetEventSoundParam(self.OnlineActionBtn, "OnlineActionPageOpen", {ToEnd = 1})
    OnlineActionModel:SetAllInfoRead()
    self.MainPage=nil 
end

function M:CheckHideBtn()
    local isDoingAction = OnlineActionModel:GetActionUniqueId()~=nil
    local hasInvitation = OnlineActionModel:HaveOtherInvitation()
    local hasApply = OnlineActionModel:HaveOtherApply()
    if not isDoingAction and not hasInvitation and not hasApply then
        self:HideBtn()
    end
end

function M:NotifyTick(InDeltaTime)
    if self.IsDestroied then
        return --按钮会在播动画后销毁，实际晚于数据销毁，在这提前终止tick
    end
    OnlineActionModel:NotifyTick(InDeltaTime)
    if  self.MainPage then
        self.MainPage:NotifyTick(InDeltaTime)
    end
end
-----------------服务端相关---------------------

function M:SendMessage(Message)
    OnlineActionModel:SendMessage(Message)
end
----申请相关
-----申请加入他人动作
function M:SendApplication(ApplyInfo)
    -- DebugPrint("OnlineAction:SendApplication",ApplyInfo)
    -- if OnlineActionModel._Avatar then
    --     OnlineActionModel._Avatar:RequestChangeRegionOnlineItemState(0, ApplyInfo.UniqueId, ApplyInfo.Eid, ApplyInfo.ActionResourceId, 0)
    -- end
end
--拒绝所有申请加入
function M:RejectAllApplications()
    DebugPrint("OnlineAction:RejectAllApplications")
    local applyInfos = OnlineActionModel:GetApplyInfos()
    if not applyInfos then return end
    for i = #applyInfos, 1, -1 do
        self:SendRejectApplication(applyInfos[i])
    end
end

---同意他人加入申请
---@param ApplyInfo 申请信息
function M:SendAcceptApplication(ApplyInfo)
    --对方正在坐坐骑时不能同意
    local applicant = OnlineActionModel:GetPlayerActor(ApplyInfo.Eid)
    if applicant and applicant.IsInRideMove and applicant:IsInRideMove() then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_RegionOnline_TargetCannotInteract"))
        OnlineActionModel:RemoveApplyInfo(ApplyInfo)
        return
    end
    --对方正在坐坐骑时不能同意 End
    DebugPrint("OnlineAction:SendAcceptApplication", ApplyInfo)
    local toReject = {}
    --local toRemoveFromView = { ApplyInfo }
    local applyInfos = OnlineActionModel:GetApplyInfos()
    
    if applyInfos then
        for _, otherApplyInfo in ipairs(applyInfos) do
            if otherApplyInfo.InteractiveId == ApplyInfo.InteractiveId and otherApplyInfo.Eid ~= ApplyInfo.Eid then
                DebugPrint("拒绝其他申请加入"..otherApplyInfo.InteractiveId.." "..otherApplyInfo.Eid.." "..ApplyInfo.InteractiveId.." "..ApplyInfo.Eid)
                table.insert(toReject, otherApplyInfo)
            end
        end
    end

    local CanSit = self:CheckCanSit(ApplyInfo.UniqueId,ApplyInfo.Eid,true)
    OnlineActionModel:RemoveApplyInfo(ApplyInfo)
    if CanSit ~= true then
        return
    end
    if OnlineActionModel._Avatar and ApplyInfo.UniqueId then
        OnlineActionModel._Avatar:OnRequestUseOwnerRegionOnlineItem(ApplyInfo.Eid,true,OnlineActionModel:GetActionUniqueId(), ApplyInfo.InteractiveId)
    else
        DebugPrint("缺少了UniqueId，应该是加假数据OnlineAction:OnReceivedRejectApply")
    end

    --移除其他相同位置的申请并发送拒绝消息
    for _, rejectInfo in ipairs(toReject) do
        self:SendRejectApplication(rejectInfo) -- This removes from model
        OnlineActionModel:RemoveApplyInfo(rejectInfo)
    end

    local Player = GWorld:GetAvatar():GetBornedChar(ApplyInfo.Eid)
    local GameState = UE4.UGameplayStatics.GetGameState(Player)
	local Mechanism = GameState.RegionOnlineMechanismMap:Find(ApplyInfo.UniqueId)
    local InteractiveComp = Mechanism.ChestInteractiveComponent
    print(_G.LogTag,"LXZ SendAcceptApplication", Mechanism, Mechanism:IsCanOnlineInteractive())
    if Mechanism and Mechanism:IsCanOnlineInteractive(Player) then
        Player:InteractiveMechanism(Mechanism.Eid, Player.Eid, InteractiveComp.NextStateId, InteractiveComp.CommonUIConfirmID, true, ApplyInfo.InteractiveId or 0)
    end

end

--拒绝他人申请加入的请求
function M:SendRejectApplication(Application)
    OnlineActionModel:RemoveApplyInfo(Application)
    DebugPrint("OnlineAction:SendRejectApplication",Application)
    if Application.UniqueId==nil then
        DebugPrint("缺少了UniqueId，应该是加假数据OnlineAction:OnReceivedRejectApply")
        return
    end
    if OnlineActionModel._Avatar then
        OnlineActionModel._Avatar:OnRequestUseOwnerRegionOnlineItem( Application.Eid, false, Application.UniqueId, Application.InteractiveId or 0)
    end
end
------邀请相关
--拒绝所有邀请加入
function M:RejectAllInvitations()
    DebugPrint("OnlineAction:RejectAllInvitations")
    local invitationInfos = OnlineActionModel:GetInvitationInfos()
    if not invitationInfos then return end
    for i = #invitationInfos, 1, -1 do
        self:SendRejectInvitation(invitationInfos[i])
    end
end
--邀请他人加入当前动作
function M:SendInvitation(InvitationInfo,Index)
    if OnlineActionModel:GetActionUniqueId()==nil then
        DebugPrint("缺少了UniqueId，应该是加假数据OnlineAction:OnReceivedRejectApply")
        return
    end
    local ret = OnlineActionModel:CheckNearbyInfoVaild(InvitationInfo,Index)
    if ret==-1 then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_RegionOnline_Invite_State"))
        return
    end
    if ret==-2 then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_RegionOnline_Invite_Sitting"))
        return
    end
    if ret==-3 then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_RegionOnline_SitOccupied"))
        return
    end
    --UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_RegionOnline_Invitation_Sent"))

    DebugPrint("OnlineAction:SendInvitation",InvitationInfo)
    if OnlineActionModel._Avatar then
        -- 将 UI 的 1 基座位索引转换为服务端的 0 基交互ID
        local interactiveId0 = math.max(0, (Index or 1) - 1)
        OnlineActionModel._Avatar:RequestHostInvitationOther( InvitationInfo.Eid, OnlineActionModel:GetActionUniqueId(), interactiveId0, 0)
    end
end

--拒绝他人邀请加入动作
function M:SendRejectInvitation(InvitationInfo)
    OnlineActionModel:RemoveInvitationInfo(InvitationInfo)
    DebugPrint("OnlineAction:SendRejectInvitation",InvitationInfo)
    if InvitationInfo.UniqueId==nil then
        DebugPrint("缺少了UniqueId，应该是加假数据OnlineAction:OnReceivedRejectApply")
        return
    end
    if OnlineActionModel._Avatar then
        OnlineActionModel._Avatar:OnRequestOtherUserRegionOnlineItem( InvitationInfo.Eid,false, InvitationInfo.UniqueId, InvitationInfo.InteractiveId or 0)
    end
end
--同意邀请,加入他人动作
function M:SendAcceptInvitation(InvitationInfo)
    OnlineActionModel:RemoveInvitationInfo(InvitationInfo)
    DebugPrint("OnlineAction:SendAcceptInvitation",InvitationInfo)
    if InvitationInfo.UniqueId==nil then
        DebugPrint("缺少了UniqueId，应该是假数据OnlineAction:OnReceivedRejectApply")
        return
    end
    local player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if player and player.IsInRideMove and player:IsInRideMove() then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_RegionOnline_CannotInteract"))
        return
    end
    local SelfEid=OnlineActionModel:GetAvatar().Eid
    local CanSit = self:CheckCanSit(InvitationInfo.UniqueId,SelfEid,InvitationInfo.InteractiveId,true)
    if not CanSit then
        OnlineActionModel:RemoveInvitationInfo(InvitationInfo)
        return
    end
    if OnlineActionModel._Avatar then
        OnlineActionModel._Avatar:OnRequestOtherUserRegionOnlineItem(InvitationInfo.Eid,true, InvitationInfo.UniqueId, InvitationInfo.InteractiveId or 0)
    end
    self:RejectAllInvitations()
end


function M:CheckSeatFree( InteractiveId,UniqueId)
    -- 需要判断一下该座位是否有效且空闲  ToDo LXZ
    if not UniqueId  then
        UniqueId=OnlineActionModel:GetActionUniqueId()
    end
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    local Mechanism = GameState.RegionOnlineMechanismMap:Find(UniqueId)
    if not Mechanism then
        ScreenPrint("交互失败：座椅不存在")
        return false
    end
    local Res = Mechanism:CheckInteractiveIdValid(InteractiveId)
    if not Res then
        ScreenPrint("交互失败：座椅被占用或者无效")
    end
    return Res
end

--检查是否可以真正坐下
function M:CheckCanSit(UniqueId,PlayerEid,InteractiveId,bInvite)
    -- 统一采用模型公共校验（0 表示有效）的约定
    local code = OnlineActionModel:CheckJoinValid(PlayerEid, UniqueId, InteractiveId)

    if code ~= 0 then
        local tipKey = bInvite and "UI_RegionOnline_Invitation_Invalid" or "UI_RegionOnline_Apply_Invalid"
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(tipKey))
        return false
    end

    return true
end

function M:RealSit(UniqueId,PlayerEid,InteractiveId)
    local Player = GWorld:GetAvatar().Player or GWorld:GetMainPlayer()
    local GameState = UE4.UGameplayStatics.GetGameState(Player)
	local Mechanism = GameState.RegionOnlineMechanismMap:Find(UniqueId)
    local InteractiveComp = Mechanism.ChestInteractiveComponent
    print(_G.LogTag,"LXZ RealSit111", Mechanism, Mechanism:IsCanOnlineInteractive())
    if Mechanism then
        Player:InteractiveMechanism(Mechanism.Eid, Player.Eid, InteractiveComp.NextStateId, InteractiveComp.CommonUIConfirmID, true, InteractiveId)
    else
    end
end

----------------收到服务端消息后调用
--- 收到邀请后调用
function M:OnReceivedInvitation(RequestEid, UniqueId, InteractiveId)
    AudioManager(self):PlayUISound(self.OnlineActionBtn, "event:/ui/common/online_invite_interact_request", "OnlineActionReceived", nil)
    ReddotManager.IncreaseLeafNodeCount("OnlineActionBtn",1)
    DebugPrint("OnlineAction:OnReceivedInvitation",RequestEid, UniqueId, InteractiveId)
    local NewInfo =OnlineActionModel:AddInvitationInfo(RequestEid, UniqueId, InteractiveId)
    if  self.OnlineActionBtn then
        --已有按钮
    else
        self:ShowBtn(2)
    end
    self:ShowBtnBubble(2)

    if self.MainPage and self.MainPage:IsVisible() then
        self.MainPage:OnReceivedNewInvitation(NewInfo)
    end
end
--- 收到申请后调用
function M:OnReceiveApplyInfo(OwnerEid, UniqueId, InteractiveId)
    AudioManager(self):PlayUISound(self.OnlineActionBtn, "event:/ui/common/online_invite_interact_request", "OnlineActionReceived", nil)
    --设置里开启自动同意申请后，自动同意该申请，不需要相关提示和UI表现
    if OnlineActionModel:GetAutoAcceptOnlineAction() == true then
        local ApplyInfo = { Eid = OwnerEid, UniqueId = UniqueId, InteractiveId = InteractiveId }
        self:SendAcceptApplication(ApplyInfo)
        return
    end
    ScreenPrint("联机动作收到申请"..OwnerEid..UniqueId..InteractiveId)
    ReddotManager.IncreaseLeafNodeCount("OnlineActionBtn",1)
    DebugPrint("OnlineAction:OnReceiveApplyInfo",OwnerEid, UniqueId, InteractiveId)
    local NewInfo =OnlineActionModel:AddApplyInfo(OwnerEid, UniqueId, InteractiveId)
    if  self.OnlineActionBtn then
    else
        self:ShowBtn(2)
    end
    self:ShowBtnBubble(1)
    if self.MainPage and self.MainPage:IsVisible() then
        self.MainPage:OnReceivedNewApplication(NewInfo)
    end
end
---收到拒绝邀请后调用
function M:OnReceivedRejectInvitation(RequestEid, UniqueId, InteractiveId)
    DebugPrint("OnlineAction:OnReceivedRejectInvitation",RequestEid, UniqueId, InteractiveId)
    -- local PlayerName=OnlineActionModel:GetPlayerName(RequestEid)
    -- local Text=string.format(GText("UI_RegionOnline_Invitation_Refused"), PlayerName)
    -- AudioManager(self):PlayUISound(self.OnlineActionBtn, "event:/ui/common/online_invite_interact_reject", "OnlineActionRejected", nil)
    -- UIManager(self):ShowUITip(UIConst.Tip_CommonToast, Text)
end
--收到拒绝申请后调用
function M:OnReceivedRejectApply(OwnerEid, UniqueId, InteractiveId)
    DebugPrint("OnlineAction:OnReceivedRejectApply",OwnerEid, UniqueId, InteractiveId)
    local PlayerName=OnlineActionModel:GetPlayerName(OwnerEid)
    local Text=string.format(GText("UI_RegionOnline_Apply_Refused"), PlayerName)
    AudioManager(self):PlayUISound(self.OnlineActionBtn, "event:/ui/common/online_invite_interact_reject", "OnlineActionRejected", nil)
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, Text)
end
-- 收到同意申请后调用
function M:OnReceivedOnlineActionApplicationAgree(OwnerEid, UniqueId, InteractiveId)
    AudioManager(self):PlayUISound(self.OnlineActionBtn, "event:/ui/common/online_invite_interact_accept", "OnlineActionAgreed", nil)
end
-- 收到同意邀请后调用
function M:OnReceivedOnlineActionInvitationAgree(RequestEid, UniqueId, InteractiveId)
    AudioManager(self):PlayUISound(self.OnlineActionBtn, "event:/ui/common/online_invite_interact_accept", "OnlineActionAgreed", nil)
end
-- 显示错误码对应的提示，待策划给出后替换为具体的错误提示
function M:ShowToastByErrorCode(IsInvite,ErrorCode)
    local Text=""
    if IsInvite then
        Text=GText("UI_RegionOnline_Invitation_Invalid")
    else
        Text=GText("UI_RegionOnline_Apply_Invalid")
    end
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, Text)
end

function M:Destory()
    -- EventManager:RemoveEvent(EventID.CloseLoading, self)
    DebugPrint("yklua 联机动作相关数据销毁OnlineAction:Destory")
    if self.OnlineActionBtn then
      self:HideBtn()
    end
    self.OpenReason=nil
    self.MainPage=nil
    M.Super.Destory(self)
end

function M:GetModel()
    return OnlineActionModel
end

function M:GetEventName()
    return ""
end

function M:GetView(WorldContex)
    return M.Super.GetView(self, WorldContex, OnlineActionCommon.UIName)
end

--endregion

return M
