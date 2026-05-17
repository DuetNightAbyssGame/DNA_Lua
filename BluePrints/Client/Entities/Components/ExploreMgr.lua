local Component = {}

function Component:ExploreIdActive(RarelyId, SubRegionId)
    if not self:IsRealInBigWorld() then return end
    if not DataMgr.SubRegion[SubRegionId] then return end
    local Explore = self.Explores[RarelyId]
    if Explore and not Explore:IsInActive() then
        return
    end
    local function Callback(RetCode)
        if self:CheckRegionErrorCode(RetCode) then
            EventManager:FireEvent(EventID.OnExploreGroupActive, RarelyId)
        else
            GWorld.logger.error(string.format("ZJT_ 该探索组激活失败 该探索组唯一ID：%d 服务器返回错误码：%d", RarelyId, RetCode) )
        end
    end
    self:CallServer("ExploreIdActive", Callback, RarelyId, SubRegionId)
end

function Component:SetExploreSpecialActiveState(RarelyId)
    if not self.Explores[RarelyId] then
        DebugPrint("ZJT_ 不存在探索组数据 特殊激活失败 ",RarelyId)
        return 
    end
    if not self.Explores[RarelyId]:IsDoing() then
        DebugPrint("ZJT_ 存在探索组数据 状态非激活 特殊激活失败 ",RarelyId)
        return 
    end
    local function Callback(Ret)
        DebugPrint("ZJT_ SetExploreSpecialActiveState ServerCallClient ", RarelyId, Ret)
        if self:CheckRegionErrorCode(Ret) then
            EventManager:FireEvent(EventID.OnExploreGroupSpecialActive, RarelyId)
        end
    end
    self:CallServer("SetExploreSpecialActiveState", Callback, RarelyId)
end

function Component:ExploreIdsActive(RarelyIdTable)
    if not self:IsRealInBigWorld() then return end
    if not RarelyIdTable or type(RarelyIdTable) ~= "table" then return end
    if next(RarelyIdTable) == nil then return end
    local function Callback(Ret, ActiveRarelyIds)
        if not self:CheckRegionErrorCode(Ret) or not ActiveRarelyIds or #ActiveRarelyIds == 0 then
            GWorld.logger.error(string.format( "ZJT_ 本次探索组的激活全部失败 请联系服务端同学帮忙查看 错误码： %d ", Ret))
            return
        end
        self:CombineAddRegionData(true)
        for _, Result in ipairs(ActiveRarelyIds) do
            for RarelyId, RetCode in pairs(Result) do
                if self:CheckRegionErrorCode(RetCode) then
                    EventManager:FireEvent(EventID.OnExploreGroupActive, RarelyId)
                else
                    GWorld.logger.error(string.format("ZJT_ 该探索组激活失败 该探索组唯一ID：%d 服务器返回错误码：%d", RarelyId, RetCode) )
                end
            end
        end
        self:CombineAddRegionData(false)
    end
    self:CallServer("ExploreIdsActive", Callback, RarelyIdTable)
end



function Component:ExploreIdCompleteLimit(RarelyId)
    if not self:IsRealInBigWorld() then return end
    local function Callback(Ret)
        if self:CheckRegionErrorCode(Ret) then
            EventManager:FireEvent(EventID.OnExploreGroupLimitComplete, RarelyId)
        end
    end
    self:CallServer("SetExploreChallageComplete", Callback, RarelyId)
end

----------- 区域对于探索的保存可以放到这里进行发送RPC ------------------
function Component:ExploreIdComplete(RarelyId)
    if not self:IsRealInBigWorld() then return end
    if not self.Explores[RarelyId] then return end
    local function Callback(Ret, TotalReward)
        if self:CheckRegionErrorCode(Ret) then
            EventManager:FireEvent(EventID.OnExploreGroupComplete, RarelyId, TotalReward)
        else
            GWorld.logger.error(string.format("ZJT_ 该探索组完成失败 该探索组唯一ID：%d 服务器返回错误码：%d", RarelyId, Ret) )
        end
    end
    self:CallServer("ExploreIdComplete", Callback, RarelyId or 0) -- 后面补RarelyDatas
end

function Component:ExploreIdsComplete(RarelyIdTable)
    if not self:IsRealInBigWorld() then return end
    if not RarelyIdTable or type(RarelyIdTable) ~= "table" then return end
    if next(RarelyIdTable) == nil then return end
    local function Callback(Ret, CompleteRarelyIdTable)
        if self:CheckRegionErrorCode(Ret) then
            for _, Result in ipairs(CompleteRarelyIdTable) do
                for RarelyId, RetCode in pairs(Result) do
                    if self:CheckRegionErrorCode(RetCode) then
                        EventManager:FireEvent(EventID.OnExploreGroupComplete, RarelyId)
                    else
                        GWorld.logger.error(string.format("ZJT_ 该探索组完成失败 %该探索组唯一ID：d 服务器返回错误码：%d", RarelyId, Ret) )
                    end
                end
                
            end
        else
            GWorld.logger.error("ZJT_ 该探索组完成全部失败 ", RarelyIdTable)
        end
    end
    self:CallServer("ExploreIdsComplete", Callback, RarelyIdTable)
end

function Component:UpdateExploreData(RarelyId, DataKey, DataValue)
    if not self.Explores[RarelyId] then return end
    if not self.Explores[RarelyId]:IsDoing() or not DataKey then return end
    local function Callback(Ret)
    end
    self:CallServer("UpdateExploreData", Callback, RarelyId, DataKey, DataValue)
end

function Component:ResetingExplore(RarelyId, SubRegionId)
    if not RarelyId then return end
    local ClientExplore = self.Explores[RarelyId]
    if not ClientExplore then return end
    if ClientExplore:IsInActive() then return end
    local function Callback(Ret)
        self.logger.info("ZJT_ ResetingExplore ",RarelyId, SubRegionId, Ret)
        if self:CheckRegionErrorCode(Ret) then ---- 清除缓存 RarelyData
            EventManager:FireEvent(EventID.OnExploreGroupDeactive, RarelyId)
            EventManager:FireEvent(EventID.OnExploreGroupReset, RarelyId)
        end
    end
    self:CallServer("ResetingExplore", Callback, RarelyId)
end

function Component:SetState2InExploreChanllenge(ExploreId)
    if not ExploreId or ExploreId <= 0 then
        self.logger.debug("ZJT_ ExitState2InExploreChanllenge 开启失败 没有探索Id ",ExploreId)
        return
    end
    local Explore = self.Explores[ExploreId]
    if not Explore then 
        self.logger.debug("ZJT_ ExitState2InExploreChanllenge 开启失败 没有探索数据 ",ExploreId)
        return
    end
    if not Explore:IsDoing() then
        self.logger.debug("ZJT_ ExitState2InExploreChanllenge 开启失败 不在执行中 ",ExploreId)
        return 
    end
    if self:InExploreChanllenge() then
        self.logger.debug("ZJT_ ExitState2InExploreChanllenge 开启失败 当前在挑战中 ",ExploreId)
        return
    end
    local function Callback(Ret)
        self.logger.debug("ZJT_ SetAvatarState2InExploreChanllenge 开启成功 ", Ret, ExploreId)
    end
    self:CallServer("SetState2InExploreChanllenge", Callback, ExploreId)
end

function Component:ExitState2InExploreChanllenge(ExploreId)
    if not ExploreId or ExploreId <= 0 then
        self.logger.debug("ZJT_ ExitState2InExploreChanllenge 退出失败 没有探索Id ",ExploreId)
        return
    end
    local Explore = self.Explores[ExploreId]
    if not Explore then 
        self.logger.debug("ZJT_ ExitState2InExploreChanllenge 退出失败 没有探索数据 ",ExploreId)
        return
    end
    if not Explore:IsDoing() then
        self.logger.debug("ZJT_ ExitState2InExploreChanllenge 退出失败 不在执行中 ",ExploreId)
        return 
    end
    if not self:InExploreChanllenge() then
        self.logger.debug("ZJT_ ExitState2InExploreChanllenge 退出失败 不在挑战中 ",ExploreId)
        return
    end
    local function Callback(Ret)
        self.logger.debug("ZJT_ ExitState2InExploreChanllenge 退出成功 ", Ret, ExploreId)
    end
    self:CallServer("ExitState2InExploreChanllenge", Callback, ExploreId)
end


return Component