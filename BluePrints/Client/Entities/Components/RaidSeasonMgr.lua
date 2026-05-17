local Component = {}
local PersonInfoModel = require "BluePrints.UI.WBP.PersonInfo.PersonInfoModel"

function Component:OnRaidSeasonEnd()
    self.logger.debug("ZJT_ OnRaidSeasonEnd 赛季结束 ")
end

function Component:OnRaidSeasonStart(CurrentRaidSeasonId)
    self.logger.debug("ZJT_ OnRaidSeasonEnd 赛季开始 ", CurrentRaidSeasonId)
end

-- 正式赛开始通知
function Component:OnRaidRankStart(CurrentRaidSeasonId, PreRaidGroupId)
    EventManager:FireEvent(EventID.OnRaidRankStart, CurrentRaidSeasonId, PreRaidGroupId)
    self.logger.debug("OnRaidRankStart 正式赛开始", CurrentRaidSeasonId, PreRaidGroupId)
end

-- 获取预算赛排行信息
function Component:RaidSeasonGetPreRaidRankInfo(InCallBack)
	self.logger.info("RaidSeasonGetPreRaidRankInfo")
    local function Cb(ErrCode)
        DebugPrint("RaidSeasonGetPreRaidRankInfo",ErrorCode:Name(ErrCode))
        if InCallBack then
            InCallBack(ErrCode)
        end
    end
	self:CallServer("RaidSeasonGetPreRaidRankInfo", Cb) 
end

-- 预选赛排行信息回调
function Component:OnGetPreRaidRankInfo(RankInfo)
    self.logger.debug("OnGetPreRaidRankInfo", RankInfo)
    EventManager:FireEvent(EventID.OnPreRaidRankInfo, RankInfo)
    --[[
        RankInfo = {
            NextScore = number, 晋级所需积分
            PreRaidGroupId = number, 当前排名组
        }
        历史最高积分直接读RaidSeason属性结构的MaxPreRaidScore
    ]]
end

-- 获取正式赛排行信息
function Component:RaidSeasonGetRaidRankInfo(InCallBack)
	self.logger.info("RaidSeasonGetRaidRankInfo")
    local function Cb(ErrCode)
        DebugPrint("RaidSeasonGetRaidRankInfo",ErrorCode:Name(ErrCode))
        if InCallBack then
            InCallBack(ErrCode)
        end
    end
	self:CallServer("RaidSeasonGetRaidRankInfo", Cb) 
end

-- 正式赛排行信息回调
function Component:OnGetRaidRankInfo(RankInfo)
    self.logger.debug("OnGetRaidRankInfo", RankInfo)
    EventManager:FireEvent(EventID.OnRaidRankInfo, RankInfo)
    --[[
        RankInfo = {
            Rank =  当前排名
            MaxSquad = 上榜的最大阵容
        }
        历史最高积分直接读RaidSeason属性结构的MaxRaidScore
        排名前的ss分组读RaidSeason属性结构的PreRaidGroupId
    ]]
end

-- 获取正式赛TopN
function Component:RaidSeasonGetRaidRankTopN(InCallBack)
	self.logger.info("RaidSeasonGetRaidRankTopN")
    local function Cb(ErrCode)
        DebugPrint("RaidSeasonGetRaidRankTopN",ErrorCode:Name(ErrCode))
        if InCallBack then
            InCallBack(ErrCode)
        end
    end
	self:CallServer("RaidSeasonGetRaidRankTopN", Cb) 
end

-- 正式赛TopN回调
function Component:OnGetRaidRankTopN(ErrCode, TopNInfo)
    self.logger.debug("OnGetRaidRankTopN", ErrCode, TopNInfo)
    EventManager:FireEvent(EventID.OnRaidRankInfoTopN, TopNInfo)
    --[[
        {
            {
            Uid = 玩家id
            Nickname = 昵称
            Level = 等级
            Score = 积分
            HeadFrameId = 头像框id
            HeadIconId = 头像id
            TitleBefore = 称号前
            TitleAfter = 称号后
            TitleFrame = 称号框
            Squad = {  最高积分对应的阵容
                [CharId] = Level,
            }
            Char = {
                CharId = 当前主控角色
                SkinId = 皮肤id
                Accessory = 配饰
                SkinColors = 染色
            }
            Weapon = {
                WeaponId = 当前主角武器
                SkinId = 皮肤id
                Accessory = 配饰
                SkinColors = 染色
            }
            ...
            },
            ...
        }
    ]]
end

-- 领取预选赛结算奖励
function Component:RaidSeasonGetPreRankReward(InCallBack)
	self.logger.info("RaidSeasonGetPreRankReward")
    local function Cb(ErrCode,Ret)
        DebugPrint("RaidSeasonGetPreRankReward",ErrorCode:Name(ErrCode))
        if InCallBack then
            InCallBack(ErrCode,Ret)
        end
    end
	self:CallServer("RaidSeasonGetPreRankReward", Cb) 
end

-- 公会战玩家赛季排行历史记录回调
    function Component:OnPlayerRaidRankRecord(RankInfo)
        DebugPrintTable(RankInfo)
        self.logger.debug("OnPlayerRaidRankRecord", RankInfo)
        PersonInfoModel.OtherRaidSeasonRankRecord = RankInfo
        DebugPrint("PersonInfoModel.OtherRaidSeasonRankRecord updated:", RankInfo)
    --[[
    {
        [SeasonId] = {
            SeasonId = 赛季id，
            Rank = 排名，
            PreRaidGroupId = 分组，
            Score = 分数，
            UpdateTime = 上榜时间，
            Squad = 上榜阵容，
        }，
    }
    ]]
end

-- 获取自己的公会战赛季历史记录
function Component:GetRaidSeasonRankRecord(InCallBack)
	self.logger.info("GetRaidSeasonRankRecord")
    local function Cb(ErrCode,Ret)
        DebugPrint("GetRaidSeasonRankRecord",ErrorCode:Name(ErrCode))
        if InCallBack then
            InCallBack(ErrCode,Ret)
        end
    end
	self:CallServer("GetRaidSeasonRankRecord", Cb) 
end

return Component
