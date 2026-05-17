--- 联机动作Model

local OnlineActionCommon = require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionCommon"
local M = Class("BluePrints.Common.MVC.Model")
local EMLuaConst = require "EMLuaConst"
function M:Init()
    -- if self._Avatar and self._Avatar== self:GetAvatar() then
    --     return true--初始化一次后不再初始化
    -- end
    DebugPrint("OnlineActionModel Init")
    M.Super.Init(self)
    self._Avatar = nil
    self:GetAvatar()

    self.ActionResourceId=0 --当前正在进行的联机动作ID
    self.ActionUniqueId=0 --当前正在进行的联机动作的UniqueId
    self.MaxPlayerNum=0 --当前动作的最大容纳人数

    self.NearbyPlayerInfos ={} --附近可邀请的玩家列表
    --[[
        Uid = AvatarInfo.AvatarInfo.Uid,
        NickName = AvatarInfo.AvatarInfo.Nickname,
        Eid = ObjId,
        Actor = OtherPlayer,

        ActionResourceId=0

        HeadIconId=AvatarInfo.AvatarInfo.HeadIconId,
        HeadFrameId=AvatarInfo.AvatarInfo.HeadFrameId,

        TitleBefore=AvatarInfo.AvatarInfo.TitleBefore,
        TitleAfter=AvatarInfo.AvatarInfo.TitleAfter,
        TitleFrame=AvatarInfo.AvatarInfo.TitleFrame,
    ]]

    self.ApplyInfos ={} -- 收到的申请加入信息
    --[[
        Uid = AvatarInfo.AvatarInfo.Uid,
        NickName = AvatarInfo.AvatarInfo.Nickname,
        Actor = OtherPlayer,
        Eid = AvatarInfo.AvatarInfo.Eid,

        UniqueId = UniqueId,
        InteractiveId=InteractiveId,
        ActionResourceId=0

        HeadIconId=AvatarInfo.AvatarInfo.HeadIconId,
        HeadFrameId=AvatarInfo.AvatarInfo.HeadFrameId,
        
        TitleBefore=AvatarInfo.AvatarInfo.TitleBefore,
        TitleAfter=AvatarInfo.AvatarInfo.TitleAfter,
        TitleFrame=AvatarInfo.AvatarInfo.TitleFrame,

        bNew=true
        RecivedTime=os.time(),
        RemainTime=OnlineActionCommon.AutoRejectTime,
    ]]

    self.InvitationInfos={} --收到的邀请信息
    --[[
        Uid = AvatarInfo.AvatarInfo.Uid,
        NickName = AvatarInfo.AvatarInfo.Nickname,
        Actor = OtherPlayer,
        Eid = AvatarInfo.AvatarInfo.Eid,
        UniqueId = UniqueId,

        ActionResourceId=0

        HeadIconId=AvatarInfo.AvatarInfo.HeadIconId,
        HeadFrameId=AvatarInfo.AvatarInfo.HeadFrameId,
        
        TitleBefore=AvatarInfo.AvatarInfo.TitleBefore,
        TitleAfter=AvatarInfo.AvatarInfo.TitleAfter,
        TitleFrame=AvatarInfo.AvatarInfo.TitleFrame,

        bNew=true
        RecivedTime=os.time(),
        RemainTime=OnlineActionCommon.AutoRejectTime,
    ]]
    --self:CreatFakeInvitationInfo()

    self.NameTemp={-- 记住发起申请/邀请时的玩家名，直到达到最大回复时间 这是为了防止玩家在回复时间下线或传送周
        --Eid=NickName
        --RemainTime
    }
    ReddotManager.AddNodeEx("OnlineActionBtn")
    self:InitConst()
    self.LastNearbyQueryTime = 0
end

function M:InitConst()
    DebugPrint("OnlineActionModel InitConst RegionOnlineNearbyMaxCount "..EMLuaConst.RegionOnlineNearbyMaxCount.." RegionOnlineNearbyMaxDist "..EMLuaConst.RegionOnlineNearbyMaxDist)
    EMLuaConst.RegionOnlineNearbyMaxCount=OnlineActionCommon.MaxNearbyPlayers
    EMLuaConst.RegionOnlineNearbyMaxDist=OnlineActionCommon.NearbtPlayDistance
    DebugPrint("AfterOnlineActionModel InitConst RegionOnlineNearbyMaxCount "..EMLuaConst.RegionOnlineNearbyMaxCount.." RegionOnlineNearbyMaxDist "..EMLuaConst.RegionOnlineNearbyMaxDist)
end

function M:CreatFakeInvitationInfo()
    self.InvitationInfos={}
    self.ApplyInfos={}
    for i=1,20 do
        local FakeInvitationInfo={
            Uid = "FakeUid" .. i,
            NickName = "FakePlayer" .. i,
            Actor = nil,
            Eid = "FakeEid" .. i,
            Level=10,

            HeadIconId=10001,
            HeadFrameId=-1,
            
            TitleBefore=10001,
            TitleAfter=0,
            TitleFrame=10001,
    
            bNew=true,
            RecivedTime=os.clock(),
            RemainTime=OnlineActionCommon.AutoRejectTime,
        }
        table.insert(self.InvitationInfos,FakeInvitationInfo)

        local FakeApplyInfo={
            Uid = "FakeUid" .. i,
            NickName = "FakePlayer" .. i,
            Actor = nil,
            Eid = "FakeEid" .. i,
            Level=10,
            
            InteractiveId=1,

            HeadIconId=10001,
            HeadFrameId=-1,
            
            TitleBefore=10001,
            TitleAfter=0,
            TitleFrame=10001,
    
            bNew=true,
            RecivedTime=os.clock(),
            RemainTime=OnlineActionCommon.AutoRejectTime,
        }
        table.insert(self.ApplyInfos,FakeApplyInfo)

        local FakeNearbyPlayerInfo={
            Uid = "FakeUid" .. i,
            NickName = "FakePlayer" .. i,
            ObjId = "FakeObjId" .. i,
            Actor = nil,
            Level=10,
    
            HeadIconId=10001,
            HeadFrameId=-1,
            
            TitleBefore=10001,
            TitleAfter=0,
            TitleFrame=10001,
        }
        table.insert(self.NearbyPlayerInfos,FakeNearbyPlayerInfo)
    
    end
    ReddotManager.IncreaseLeafNodeCount("OnlineActionBtn",1)

end
--获得机关的ID
function M:GetActionUniqueId()
    if self.ActionUniqueId~=0 then
        return self.ActionUniqueId
    end
    return nil
end

--通过UniqueId获取交互道具Id
function M:GetResourceIdByUniqueId(UniqueId)
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
	local Mechanism = GameState.RegionOnlineMechanismMap:Find(UniqueId)
    if not Mechanism then
        return 0
    end
    return Mechanism.ResourceId
end

function M:GetActionNameByUniqueId(UniqueId)
    local ResourceId = self:GetResourceIdByUniqueId(UniqueId)
    if ResourceId == 0 then
        return ""
    end
    if DataMgr["Resource"][ResourceId] and DataMgr["Resource"][ResourceId]["ResourceName"] then
        return DataMgr["Resource"][ResourceId]["ResourceName"]
    end
    return ""
end

function M:GetMaxInteractiveNum(UniqueId)
    local ResourceId = self:GetResourceIdByUniqueId(UniqueId)
    if ResourceId == 0 then
        return 1
    end
    if DataMgr["Resource"][ResourceId] and DataMgr["Resource"][ResourceId]["InteractPlayerNum"] then
        return DataMgr["Resource"][ResourceId]["InteractPlayerNum"]
    end
    return 1
end

--获得当前动作的可容纳人数,没找到或没填默认1
function M:GetMaxPlayerNum()
    self.ActionResourceId=self:GetResourceIdByUniqueId(self.ActionUniqueId)
    if not self.ActionResourceId or self.ActionResourceId == 0 then
        if not self.ActionUniqueId then
            ScreenPrint("获得当前动作的可容纳人数失败，没找到对应的Resource self.ActionResourceId=" .. tostring(self.ActionResourceId))
            return 1
        end
        self.ActionResourceId=self:GetResourceIdByUniqueId(self.ActionUniqueId)
    end
    if not self.ActionResourceId or self.ActionResourceId == 0 then
        ScreenPrint("获得当前动作的可容纳人数仍然失败，没找到对应的Resource self.ActionResourceId=" .. tostring(self.ActionResourceId))
        return 1
    end
    if DataMgr["Resource"][self.ActionResourceId] and DataMgr["Resource"][self.ActionResourceId]["InteractPlayerNum"] then
       self.MaxPlayerNum=DataMgr["Resource"][self.ActionResourceId]["InteractPlayerNum"]
    else
        if not DataMgr["Resource"][self.ActionResourceId] then
            ScreenPrint("获得当前动作的可容纳人数仍然失败，没找到对应的Resource self.ActionResourceId=" .. tostring(self.ActionResourceId))
            return 1
        end
        DebugPrintTable(DataMgr["Resource"][self.ActionResourceId])
        ScreenPrint("！！！！请检查资源表的InteractPlayerNum获得当前动作的可容纳人数失败，没找到对应的InteractPlayer self.ActionResourceId=" .. tostring(self.ActionResourceId))
        self.MaxPlayerNum=1
    end
    DebugPrint("联机动作获取人数 GetMaxPlayerNum: MaxPlayerNum=" .. tostring(self.MaxPlayerNum))
    return   self.MaxPlayerNum or 1
end
--是否有可邀请的其他玩家
function M:HaveOtherInvitation()
    if  not self.InvitationInfos or next(self.InvitationInfos) == nil then
        return false
    end
    return true
end

--是否有其他申请加入信息
function M:HaveOtherApply()
    if  not self.ApplyInfos or next(self.ApplyInfos) == nil then
        return false
    end
    return true
end
--获取附近可邀请的玩家列表
function M:GetNearbyPlayerInfos()
    return self.NearbyPlayerInfos
end
--获取收到的申请加入信息
function M:GetApplyInfos()
    return self.ApplyInfos
end
--获取收到的邀请加入信息
function M:GetInvitationInfos()
    return self.InvitationInfos
end
--移除邀请加入信息
function M:RemoveInvitationInfo(Info)
    for index, InvitationInfo in pairs(self.InvitationInfos or {}) do
        if InvitationInfo == Info then
            table.remove(self.InvitationInfos, index)
            DebugPrint("RemoveInvitationInfo: Removed invitation for Uid: " .. (Info.Uid or ""))
            -- 新增：当为被邀请方（OpenReason == 2）且邀请列表为空时，隐藏按钮
            self:CheckIsNeedHideBtn()
            return
        end
    end
    DebugPrint("RemoveInvitationInfo: Info not found in invitations: " .. (Info.Uid or ""))
end
--检查是否需要隐藏按钮
function M:CheckIsNeedHideBtn()
    local Controller = self:GetController()
    -- 非动作主人（OpenReason ~= 1）且邀请与申请均为空时，隐藏按钮
    if Controller and Controller.OpenReason ~= 1 then
        local hasInvitation = (self.InvitationInfos and next(self.InvitationInfos) ~= nil)
        local hasApply = (self.ApplyInfos and next(self.ApplyInfos) ~= nil)
        if not hasInvitation and not hasApply then
            Controller:HideBtn()
        end
    end
    if Controller and Controller.OpenReason == 2 then
        local invs = self.InvitationInfos
        if not invs or next(invs) == nil then
            Controller:HideBtn()
        end
    end
end

function M:RemoveApplyInfo(Info)
    for index, ApplyInfo in pairs(self.ApplyInfos) do
        if ApplyInfo == Info then
            table.remove(self.ApplyInfos, index)
            DebugPrint("RemoveApplyInfo: Removed apply for Uid: " .. tostring(Info and Info.Uid or ""))
            self:CheckIsNeedHideBtn()
            return
        end
    end
    DebugPrint("RemoveApplyInfo: Info not found in applys: " .. tostring(Info and Info.Uid or ""))
end
--关闭弹窗消除红点
function M:SetAllInfoRead()
    for _, InvitationInfo in pairs(self.InvitationInfos) do
        InvitationInfo.bNew = false
    end
    for _, ApplyInfo in pairs(self.ApplyInfos) do
        ApplyInfo.bNew = false
    end
    ReddotManager.ClearLeafNodeCount("OnlineActionBtn")
end

-- 修改正在进行的动作
function M:ChangeAction(UniqueId)
    if UniqueId then
        self.ActionUniqueId=UniqueId
        -- self.ActionResourceId=self:GetResourceIdByUniqueId(UniqueId)
        -- if not self.ActionResourceId then
        --     self.MaxPlayerNum=1
        --     ScreenPrint("找不到对应的资源数据 UniqueId为" .. tostring(UniqueId))
        --     return
        -- end
        -- local Data=DataMgr["Resource"][self.ActionResourceId]
        -- if Data  then
        --     local MaxPlayerNum=tonumber(Data.InteractPlayerNum) or 0
        --     self.MaxPlayerNum=MaxPlayerNum
        -- else
        --     ScreenPrint("找不到对应的资源数据 UniqueId为" .. tostring(UniqueId))
        -- end
    else
        self.MaxPlayerNum=1
    end
end
-- 寻找附近可邀请的玩家（接入 C++ 缓存结果）
function M:FindPlayerAround()
    self._Avatar=GWorld:GetAvatar()
    -- 初始化附近玩家列表
    if self._Avatar.CurrentOnlineType == -1 then
        return
    end
    self.NearbyPlayerInfos = {}
    if OnlineActionCommon.UseSyncNearbyPlayers then
        local Sync = UE4.URegionSyncSubsystem.GetInstance(GWorld.GameInstance)
        if not Sync or Sync:IsNearbyResultUninitialized() then
            ScreenPrint("::意外错误，多线程查找附近玩家失败,多线程数据没有准备好")
            --self:FindPlayerAroundOld()
            return
        end

        local NearbyIds = Sync:GetNearbyPlayersIDs()
        if not NearbyIds then
            return
        end
        DebugPrint("开始使用多线程查找结果生成待邀请列表")
        local added = 0
        for i = 1, NearbyIds:Length()  do
            local eidstr = NearbyIds:GetRef(i)
            local eid = CommonUtils.Str2ObjId(eidstr)
            local OtherPlayer = self._Avatar:GetBornedChar(eid)
            local AvatarData = self._Avatar.RegionAvatars[eid]
            if OtherPlayer and AvatarData and AvatarData.AvatarInfo and not OtherPlayer:CharacterInTag("Seating") then --如果玩家已经处于交互状态，不能被邀请
                table.insert(self.NearbyPlayerInfos, {
                    Uid = AvatarData.AvatarInfo.Uid,
                    NickName = AvatarData.AvatarInfo.Nickname,
                    Eid = eid,
                    Actor = OtherPlayer,
                    Level = AvatarData.AvatarInfo.Level or 1,
                    TitleBefore = AvatarData.AvatarInfo.TitleBefore,
                    TitleAfter = AvatarData.AvatarInfo.TitleAfter,
                    TitleFrame = AvatarData.AvatarInfo.TitleFrame or 10001,
                    HeadIconId = AvatarData.AvatarInfo.HeadIconId,
                    HeadFrameId = AvatarData.AvatarInfo.HeadFrameId,
                })
                added = added + 1
                if added >= EMLuaConst.RegionOnlineNearbyMaxCount then
                    break
                end
            end
        end
        return
    else
        DebugPrint("关闭多线程查找附近玩家，在Lua层寻找")
        --self:FindPlayerAroundOld()
    end
          -- 获取当前玩家的位置
end
-- 因性能问题，废弃的lua寻找附近玩家的逻辑，
-- function M:FindPlayerAroundOld()
--     -- 获取当前玩家的Actor
--     local MainPlayer = UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
--     if not MainPlayer then
--         ScreenPrint("FindPlayerAround: MainPlayer is nil")
--         return
--     end
--     local MainPlayerLocation = MainPlayer:K2_GetActorLocation()
--     -- ScreenPrint("FindPlayerAround: MainPlayerLocation: " .. tostring(MainPlayerLocation))
--     local CalDistanceFunc = UE4.UKismetMathLibrary.Vector_Distance
--     local SelfRegionId = self._Avatar.CurrentRegionId
--     -- 遍历所有在线玩家
--     for ObjId, AvatarData in pairs(self._Avatar.RegionAvatars) do
--         DebugPrint("FindPlayerAround: Checking player with ObjId: " .. tostring(ObjId))
        
--         local OtherPlayer = self._Avatar:GetBornedChar(ObjId)
--         if OtherPlayer and AvatarData.AvatarInfo.CurrentRegionId==self._Avatar.CurrentRegionId then
--             DebugPrint("FindPlayerAround: OtherPlayer found for ObjId: " .. tostring(ObjId))

--             -- 获取其他玩家的位置
--             local OtherPlayerLocation = OtherPlayer:K2_GetActorLocation()
--             DebugPrint("FindPlayerAround: OtherPlayerLocation for ObjId " .. tostring(ObjId) .. ": " .. tostring(OtherPlayerLocation))
--             -- 计算距离
--             local Distance =CalDistanceFunc(MainPlayerLocation, OtherPlayerLocation)
--             DebugPrint("FindPlayerAround: Distance to ObjId " .. tostring(ObjId) .. ": " .. tostring(Distance))
            
--             -- 如果距离小于设定的阈值，则加入附近玩家列表
--             if Distance < OnlineActionCommon.NearbtPlayDistance then
--                 DebugPrint("FindPlayerAround: Player with ObjId " .. tostring(AvatarData.AvatarInfo.Nickname) .. " is nearby")
--                 if not OtherPlayer:CharacterInTag("Seating") then --如果玩家已经处于交互状态，不能被邀请
--                 DebugPrint("FindPlayerAround: Player with ObjId " .. tostring(AvatarData.AvatarInfo.Nickname) .. " is not in the same region")

--                     table.insert(self.NearbyPlayerInfos, {
--                         Uid = AvatarData.AvatarInfo.Uid,
--                         NickName = AvatarData.AvatarInfo.Nickname,
--                         Eid = ObjId,
--                         Actor = OtherPlayer,
--                         Level = AvatarData.AvatarInfo.Level or 1,
--                         TitleBefore = AvatarData.AvatarInfo.TitleBefore,
--                         TitleAfter = AvatarData.AvatarInfo.TitleAfter,
--                         TitleFrame = AvatarData.AvatarInfo.TitleFrame or 10001,
--                         HeadIconId = AvatarData.AvatarInfo.HeadIconId,
--                         HeadFrameId = AvatarData.AvatarInfo.HeadFrameId
--                     })
--                     if #self.NearbyPlayerInfos >= EMLuaConst.RegionOnlineNearbyMaxCount then
--                         DebugPrint(
--                             "FindPlayerAround: RegionOnlineNearbyMaxCount reached 达到最大玩家人数，不再搜索")
--                         break
--                     end
--                 end
--             else
--                 DebugPrint("FindPlayerAround: Player with ObjId " .. tostring(ObjId) .. " is too far")
--             end
--         else
--             DebugPrint("FindPlayerAround: OtherPlayer is nil for ObjId: " .. tostring(ObjId))
--         end
--     end
--     ::EndFindPlayerAround::
--     DebugPrint("FindPlayerAround: Found " .. tostring(#self.NearbyPlayerInfos) .. " nearby players")
--     self.LastNearbyQueryTime = os.time()
-- end

function M:CheckNearbyInfoVaild(NearbyInfo, Index)
    local Eid = NearbyInfo.Eid
    local Char=self._Avatar:GetBornedChar(Eid)
    if not Char then
        ScreenPrint("CheckNearbyInfoVaild: 玩家"..CommonUtils.ObjId2Str(Eid).."不存在")
        return -1
    end

    -- 计算主角与目标玩家的距离，超过阈值不可邀请
    local MainPlayer = UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if not MainPlayer then
        DebugPrint("CheckNearbyInfoVaild: MainPlayer is nil")
        return -1
    end
    local MainPlayerLocation = MainPlayer:K2_GetActorLocation()
    local OtherPlayerLocation = Char:K2_GetActorLocation()
    local CalDistanceFunc = UE4.UKismetMathLibrary.Vector_Distance
    local Distance = CalDistanceFunc(MainPlayerLocation, OtherPlayerLocation)
    if Distance >= OnlineActionCommon.NearbtPlayDistance then
        --此时距离已经太远，不能被邀请
        return -1
    end

    if Char:CharacterInTag("Seating") then
        --已经坐下的玩家，不能被邀请
        return -2
    end

    -- 指定座位占用检查：Index 为 UI 的 1 基座位编号
    -- 仅当当前有有效动作且传入了具体座位时进行检查
    if self.ActionUniqueId and Index ~= nil then
        local Mechanism = self:GetMechanism()
        if Mechanism then
            local interactiveId0 = math.max(0, (Index or 1) - 1)
            local ok = self:IsSeatValid(Mechanism, interactiveId0)
            if not ok then
                -- 指定座位不可用（占用/无效）
                return -3
            end
        end
    end
    return true
end
--增加新的邀请数据
function M:AddInvitationInfo(RequestEid, UniqueId, InteractiveId)
    self._Avatar=GWorld:GetAvatar()
    local AvatarData = self._Avatar.RegionAvatars[RequestEid]
    if not AvatarData then return end

    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    local InvitationInfo = {
        Uid = AvatarData.AvatarInfo.Uid,
        NickName = AvatarData.AvatarInfo.Nickname,
        Actor = self._Avatar:GetBornedChar(AvatarData.AvatarInfo.ObjId),
        Eid = RequestEid,
        UniqueId = UniqueId,
        Level = AvatarData.AvatarInfo.Level or 1,
        InteractiveId = InteractiveId,
        HeadIconId = AvatarData.AvatarInfo.HeadIconId,
        HeadFrameId = AvatarData.AvatarInfo.HeadFrameId,
        TitleBefore = AvatarData.AvatarInfo.TitleBefore,
        TitleAfter = AvatarData.AvatarInfo.TitleAfter,
        TitleFrame = AvatarData.AvatarInfo.TitleFrame,
        bNew = true,
        RecivedTime = GameState and GameState.ReplicatedRealTimeSeconds or 0.0,
        RemainTime = OnlineActionCommon.AutoRejectTime,
    }
    table.insert(self.InvitationInfos, InvitationInfo)
    return InvitationInfo
end
--增加新的申请数据
function M:AddApplyInfo(OwnerEid, UniqueId, InteractiveId)
    self._Avatar=GWorld:GetAvatar()
    local AvatarData = self._Avatar.RegionAvatars[OwnerEid]
    if not AvatarData then 
        ScreenPrint("OnlineAction 收到了申请，但是玩家"..CommonUtils.ObjId2Str(OwnerEid).."不存在")
        return
    end

    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    local NewApplication = {
        Uid = AvatarData.AvatarInfo.Uid,
        NickName = AvatarData.AvatarInfo.Nickname,
        Actor = self._Avatar:GetBornedChar(AvatarData.AvatarInfo.ObjId),
        Eid = OwnerEid,
        Level = AvatarData.AvatarInfo.Level or 1,
        UniqueId = UniqueId,
        InteractiveId = InteractiveId,
        HeadIconId = AvatarData.AvatarInfo.HeadIconId,
        HeadFrameId = AvatarData.AvatarInfo.HeadFrameId,
        TitleBefore = AvatarData.AvatarInfo.TitleBefore,
        TitleAfter = AvatarData.AvatarInfo.TitleAfter,
        TitleFrame = AvatarData.AvatarInfo.TitleFrame,
        bNew = true,
        RecivedTime = GameState and GameState.ReplicatedRealTimeSeconds or 0.0,
        RemainTime = OnlineActionCommon.AutoRejectTime,
    }
    table.insert(self.ApplyInfos, NewApplication)
    return NewApplication
end

function M:NotifyTick(InDeltaTime)
    local Controller = self:GetController()
    local bHasChanged = false
    if not self.UGameplayStatics then
        self.UGameplayStatics = UE4.UGameplayStatics
    end
    if not self.GameInstance then
        self.GameInstance = GWorld.GameInstance
    end 
    local nowSeconds = self.UGameplayStatics and self.UGameplayStatics.GetRealTimeSeconds(self.GameInstance) or 0.0
    -- invitations
    if not self.ActionUniqueId then
        return
    end
    for i = #self.InvitationInfos, 1, -1 do
        local InvitationInfo = self.InvitationInfos[i]
        local expire =  OnlineActionCommon.AutoRejectTime
        local start  = InvitationInfo.RecivedTime or nowSeconds
        InvitationInfo.RemainTime = expire - (nowSeconds - start)
        if InvitationInfo.RemainTime <= 0 then
            Controller:SendRejectInvitation(InvitationInfo)
            self:RemoveInvitationInfo(InvitationInfo)
            bHasChanged = true
        end
    end

    -- applications
    for i = #self.ApplyInfos, 1, -1 do
        local ApplyInfo = self.ApplyInfos[i]
        local expire = OnlineActionCommon.AutoRejectTime
        local start  = ApplyInfo.RecivedTime or nowSeconds
        ApplyInfo.RemainTime = expire - (nowSeconds - start)
        if ApplyInfo.RemainTime <= 0 then
            Controller:SendRejectApplication(ApplyInfo)
            self:RemoveApplyInfo(ApplyInfo)
            bHasChanged = true
        end
    end

    if bHasChanged then
        self:CheckbHasAnyNewInfo()
    end
end

--清除所有申请
function M:ClearAllApply()
    self.ApplyInfos = {}
end
--- 检查是否有新的邀请或申请
function M:CheckbHasAnyNewInfo()
    for _,InvitationInfo in pairs(self.InvitationInfos) do
        if InvitationInfo.bNew then
            return true
        end
    end
    for _,ApplyInfo in pairs(self.ApplyInfos) do
        if ApplyInfo.bNew then
            return true
        end
    end
    --self:GetController():SetBtnReddotRead()
    return false
end
--
function M:GetPlayerName(Eid)
    
    local AvatarData=self._Avatar.RegionAvatars[Eid]
    if AvatarData then
        return AvatarData.AvatarInfo.Nickname
    else
        ScreenPrint("OnlineAction 收到了申请，但是玩家"..tostring(Eid).."不存在")
    end
    return ""
end

--检查玩家是否有效，主要判断玩家是否在区域内
function M:GetPlayerActor(Eid)
    if Eid==self._Avatar.Eid then
        return UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    end
    local AvatarData=self._Avatar.RegionAvatars[Eid]
    if not AvatarData then
        return false--下线或离开区域联机
    end
    local Actor =  self._Avatar:GetBornedChar(Eid)
    if not Actor then
        return false--玩家Actor不存在,可能时距离太远或者其他BUG
    end
    return Actor
end
-- --检查邀请是否有效
-- -- -1 玩家不存在
-- -- -2 机关距离过远
-- -- -3 玩家已在交互状态
-- -- -4 座位已经被占用
-- function M:CheckIsInvitationValid(InvitationInfo)
--     -- 返回错误码：0 表示有效
--     -- 支持传入 Eid 或 InvitationInfo 表
--     local Eid, UniqueId, InteractiveId
--     if type(InvitationInfo) == "table" then
--         Eid = InvitationInfo.Eid
--         UniqueId = InvitationInfo.UniqueId or self.ActionUniqueId
--         InteractiveId = InvitationInfo.InteractiveId
--     else
--         Eid = InvitationInfo
--         UniqueId = self.ActionUniqueId
--     end

--     -- 玩家存在性
--     local Actor = self:GetPlayerActor(Eid)
--     if not Actor then
--         return -1
--     end

--     -- 玩家当前是否已在交互（坐下）
--     if Actor:CharacterInTag("Seating") then
--         return -3
--     end

--     -- 机制与交互半径
--     local Mechanism = self:GetMechanismByUniqueId(UniqueId)
--     if not Mechanism then
--         -- 找不到机关，视为不在有效交互范围（项目约定用 -2 表示）
--         return -2
--     end
--     -- 玩家与机关的距离采用统一常量阈值判断
--     local actorLoc = Actor:K2_GetActorLocation()
--     local dist = UE4.UKismetMathLibrary.Vector_Distance(actorLoc,  Mechanism:K2_GetActorLocation())
--     if dist > OnlineActionCommon.NearbtPlayDistance then
--         return -2
--     end

--     -- 座位有效性（若有具体交互位）
--     if InteractiveId ~= nil then
--         local ok = self:IsSeatValid(Mechanism, InteractiveId)
--         if not ok then
--             return -4
--         end
--     else
--         -- 未指定具体座位时，至少要存在可用座位
--         if not self:IfHaveSeatValid() then
--             return -4
--         end
--     end

--     return 0
-- end
-- --检查申请是否有效
-- -- -1 玩家不存在
-- -- -2 距离过远
-- -- -3 玩家已在交互状态
-- -- -4 座位已经被占用
-- function M:CheckApplyValid(ApplyInfo)
--     -- 返回错误码：0 表示有效
--     -- 支持传入 Eid 或 ApplyInfo 表
--     local Eid, UniqueId, InteractiveId
--     if type(ApplyInfo) == "table" then
--         Eid = ApplyInfo.Eid or ApplyInfo.ObjId
--         UniqueId = ApplyInfo.UniqueId or self.ActionUniqueId
--         InteractiveId = ApplyInfo.InteractiveId
--     else
--         Eid = ApplyInfo
--         UniqueId = self.ActionUniqueId
--     end

--     -- 玩家存在性
--     local Actor = self:GetPlayerActor(Eid)
--     if not Actor then
--         return -1
--     end

--     -- 玩家是否已在交互（坐下）
--     if Actor:CharacterInTag("Seating") then
--         return -3
--     end

--     -- 机制与交互半径
--     local Mechanism = self:GetMechanismByUniqueId(UniqueId)
--     if not Mechanism then
--         return -2
--     end
--     -- 玩家与机关的距离采用统一常量阈值判断
--     local actorLoc = Actor:K2_GetActorLocation()
--     local dist = UE4.UKismetMathLibrary.Vector_Distance(actorLoc,  Mechanism:K2_GetActorLocation())
--     if dist > OnlineActionCommon.NearbtPlayDistance then
--         return -2
--     end

--     -- 指定座位有效性
--     if InteractiveId ~= nil then
--         local ok = self:IsSeatValid(Mechanism, InteractiveId)
--         if not ok then
--             return -4
--         end
--     else
--         if not self:IfHaveSeatValid() then
--             return -4
--         end
--     end

--     return 0
-- end
--获取玩家昵称
function M:GetPlayerName(Eid)
    local AvatarData=self._Avatar.RegionAvatars[Eid]
    if AvatarData then
        return AvatarData.AvatarInfo.Nickname
    end
    return ""
end
--判断是否再区域联机
function M:IsInRegionOnline()
    return self._Avatar and self._Avatar.IsInRegionOnline
end

function M:GetController()
    if self.Controller then
        return self.Controller
    else
        self.Controller=require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController"
    end
    return self.Controller
end

function M:Destory()
    DebugPrint("OnlineActionModel Destory")
    self.NearbyPlayerInfos = nil
    self.ApplyInfos =nil
    self.InvitationInfos=nil 
    self.Controller=nil
    self.UGameplayStatics=nil
    self.GameInstance=nil
    M.Super.Destory(self)
end
-- OnlineActionModel: 合并的按剩余时间排序函数（kind: 1=申请, 3=邀请）--性能不太好，暂时废弃，用倒序遍历代替
function M:SortByRemainTime(kind, desc)
    local list
    if kind == 1 then
        list = self.ApplyInfos
    elseif kind == 3 then
        list = self.InvitationInfos
    else
        return
    end
    if not list or next(list) == nil then return end

    local descending = (desc ~= false)
    table.sort(list, function(a, b)
        local ra = (a and a.RemainTime) or 0
        local rb = (b and b.RemainTime) or 0
        if ra ~= rb then
            if descending then
                return ra > rb
            else
                return ra < rb
            end
        end

        local ta = (a and a.RecivedTime) or 0
        local tb = (b and b.RecivedTime) or 0
        if ta ~= tb then
            if descending then
                return ta < tb
            else
                return ta > tb
            end
        end

        -- 完全相等时保持稳定：返回 false
        return false
    end)
end

function  M:GetMechanism()
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    local Mechanism = GameState.RegionOnlineMechanismMap:Find(self.ActionUniqueId)
    if not Mechanism then
        DebugPrint("寻找机关失败，机关不存在  "..self.ActionUniqueId)
        return false
    end
    return Mechanism
end

function M:GetSeatVaildInfo()
    local Mechanism = self:GetMechanism()
    if not Mechanism then
        return false
    end
    local ValidPoint = Mechanism:GetValidPoint()
    DebugPrintTable(ValidPoint)
    return ValidPoint
end

function M:IfHaveSeatValid()
    local SeatVaildInfo = self:GetSeatVaildInfo()
    if not SeatVaildInfo then
        return false
    end
    for index,Info in pairs(SeatVaildInfo) do
        if Info.Valid and index+1<=self.MaxPlayerNum then
            return true
        end
    end
    return false
end

-- 公共工具函数：按 UniqueId 获取机关
function M:GetMechanismByUniqueId(UniqueId)
    if not UniqueId then return false end
    local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
    if not GameState then return false end
    return GameState.RegionOnlineMechanismMap:Find(UniqueId)
end
-- 公共工具函数：检查座位是否有效
function M:IsSeatValid(Mechanism, InteractiveId)
    if not Mechanism then return false end
    if InteractiveId == nil then return false end
    return Mechanism:CheckInteractiveIdValid(InteractiveId)
end

-- 公共校验：申请/邀请通用的合法性检查
-- 返回：0 有效；-1 玩家不存在；-2 距离过远/机关无效；-3 玩家在交互状态；-4 座位不可用
function M:CheckJoinValid(Eid, UniqueId, InteractiveId)
    -- 玩家存在性
    local Actor = self:GetPlayerActor(Eid)
    if not Actor then
        return -1
    end

    -- 玩家是否已在交互（坐下）
    if Actor:CharacterInTag("Seating") then
        return -3
    end

    -- 机制与交互半径（统一常量 OnlineActionCommon.NearbtPlayDistance）
    local Mechanism = self:GetMechanismByUniqueId(UniqueId)
    if not Mechanism then
        return -2
    end
    local actorLoc = Actor:K2_GetActorLocation()
    local mechLoc = Mechanism:K2_GetActorLocation()
    local dist = UE4.UKismetMathLibrary.Vector_Distance(actorLoc, mechLoc)
    if dist > OnlineActionCommon.NearbtPlayDistance then
        return -2
    end

    -- 座位有效性（若指定了交互位）
    if InteractiveId ~= nil then
        local ok = self:IsSeatValid(Mechanism, InteractiveId)
        if not ok then
            return -4
        end
    else
        -- 未指定具体座位时，至少要存在可用座位
        if not self:IfHaveSeatValid() then
            return -4
        end
    end

    return 0
end
--读取设置界面中是否自动接受互动申请的变量
function M:GetAutoAcceptOnlineAction()
    local AutoAcceptOnlineAction = EMCache:Get("AutoAcceptOnlineAction")
    DebugPrint("AutoAcceptOnlineAction", AutoAcceptOnlineAction)
    return AutoAcceptOnlineAction
end

return M
