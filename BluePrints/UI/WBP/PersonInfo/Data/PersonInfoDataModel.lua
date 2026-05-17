require "UnLua"
local M = {}

local DesignatedName2Func
function M:Init(OtherPersonInfo)
    if OtherPersonInfo then
        self:InitOthers(OtherPersonInfo)
    else
        self:InitSelf()
    end
end
function M:Clear()
    
end
function M:InitSelf()
 
    self._Avatar = GWorld:GetAvatar()
    self.IsSelf = true
    self.PersonalInfoVisible=self._Avatar.PersonalInfo.Visible or 1
    -- 基础信息
    self.Name = self._Avatar.Nickname or " "
    self.Uid = self._Avatar.Uid or 0
    local totalSeconds = self._Avatar.TotalOnlineTime or 0
    self.TotalOnlineTime = string.format("%.1f", totalSeconds / 3600)
    DebugPrint("TotalOnlineTime:",self.TotalOnlineTime)
    self.CreateTime =  os.date("%Y/%m/%d", self._Avatar.CreateTime) or ""
    DebugPrint("CreateTime:",self.CreateTime)

    -- 数量统计
    self.CharsCount = self._Avatar.Chars:Length()-- 角色
    self.MeleeCount, self.RangedCount = AvatarUtils:GetPlayerPersonalInfoWeaponCount(self._Avatar)
    self.MeleeCount=self._Avatar.Archives[1002]:GetArchiveCount()
    self.RangedCount=self._Avatar.Archives[1003]:GetArchiveCount()
    self.PetCount=self._Avatar.Pets:Length()
    self.ModCount = self._Avatar.Mods:Length() -- 模组

    self.CharSkinCount = AvatarUtils:GetPlayerPersonalInfoCharSkinCount(self._Avatar) -- 角色皮肤
    self.WeaponSkinCount = self._Avatar.OwnedWeaponSkins:Length()-- 武器皮肤
    self.CharAccessorys = self._Avatar.CharAccessorys:Length()-- 角色配饰
    self.WeaponAccessorys = self._Avatar.WeaponAccessorys:Length() -- 武器配饰

    -- 成就统计
    self.Achievement_Array, self.Achievement_Count = AvatarUtils:GetPlayerPersonalInfoAchievementCount(self._Avatar)
    for i=1,3 do
        if not self.Achievement_Array[i] then
             self.Achievement_Array[i] = 0
        end
    end

    -- 额外Tab信息
    self.Abyss_Difficulty, self.Abyss_Step, self.Abyss_Star = table.unpack(AvatarUtils:GetAbyssSeasonMaxProgress(self._Avatar))
    self.Rouge_Difficulty=AvatarUtils:GetPlayerPersonalInfoRougeLikeProgress(self._Avatar)
end
function M:InitOthers(OtherPersonInfo)
    self.IsSelf = false
    self.OtherPersonInfo = OtherPersonInfo
    self.PersonalInfoVisible=OtherPersonInfo.Visible or 1
    -- 基础信息
    self.Name = OtherPersonInfo.Nickname or " "
    self.Uid = OtherPersonInfo.Uuid or 0

    self.TotalOnlineTime = string.format("%.1f", OtherPersonInfo.TotalOnlineTime / 3600)
    DebugPrint("yklua TotalOnlineTime:"..self.TotalOnlineTime)
    self.CreateTime =  os.date("%Y/%m/%d", OtherPersonInfo.CreateTime) or ""
    DebugPrint("yklua CreateTime:"..self.CreateTime)
    -- 数量统计
    self.CharsCount = OtherPersonInfo.CharCount or 0-- 角色
    self.MeleeCount = OtherPersonInfo.MeleeWeaponCount or 0 -- 近战
    self.RangedCount = OtherPersonInfo.RangedWeaponCount or 0 -- 远程
    self.CharSkinCount =   OtherPersonInfo.CharSkinCount or 0 -- 角色皮肤
    self.WeaponSkinCount = OtherPersonInfo.WeaponSkinCount or 0-- 武器皮肤
    self.CharAccessorys = OtherPersonInfo.CharAccessoryCount or 0-- 角色配饰
    self.WeaponAccessorys = OtherPersonInfo.WeaponAccessoryCount or 0 -- 武器配饰
    self.ModCount = OtherPersonInfo.ModCount or 0
    self.PetCount=OtherPersonInfo.PetCount or 0
    -- 成就统计
    self.Achievement_Array = OtherPersonInfo.AchievementCount or {}
    self.Achievement_Count=0
    for i=1,3 do
        if not self.Achievement_Array[i] then
             self.Achievement_Array[i] = 0
        end
        self.Achievement_Count= self.Achievement_Count+self.Achievement_Array[i]
    end
    --其他信息
    self.Rouge_Difficulty = OtherPersonInfo.RougeLikeProgress
    local AbyssProgress=OtherPersonInfo.AbyssProgress or {}
    for i=1,3 do
        if not AbyssProgress[i] then
             AbyssProgress[i] = 0
        end
    end
    self.Abyss_Difficulty, self.Abyss_Step, self.Abyss_Star = table.unpack(AbyssProgress)

end
function M:CalulatorCreateTime()
    -- Timestamp = Timestamp or TimeUtils.NowTime()
	-- if UserServerTimezone == nil then
	-- 	UserServerTimezone = true
	-- end
	-- if UserServerTimezone then
	-- 	Timestamp = os.time(os.date("!*t", Timestamp)) + TimeUtils.ServerTimeZone * 3600
	-- end
end
function M:GetIsSelf()
    return self.IsSelf
end
function M:GetPersonalInfoVisible()
    return self.PersonalInfoVisible
end
function M:GetPlayerName()
    return self.Name
end
function M:GetPlayerUid()
    return self.Uid
end
function M:GetPlayTime()
    return self.TotalOnlineTime
end
function M:GetCreateTime()
    return self.CreateTime
end

function M:GetRougeLikeProgress()
    return self.RougeLikeProgress
end

---获取显示动态配表的显示数据
function M:GetUniqueDatailedDatas()
    local OriginData= DataMgr["PersonalUniqueDetails"]
    local UniqueDatailedDatas={}
    for k,value in pairs(OriginData) do
        local Copy={}
        Copy.Count=self:GetUniqueDatailedNumber(value.Event)
        Copy.Name=value.Des
        Copy.Sort=value.Sort
        table.insert(UniqueDatailedDatas,Copy)
    end
    table.sort(UniqueDatailedDatas, function(a, b) return a.Sort < b.Sort end)
    return UniqueDatailedDatas
end
--获取表内指定数据的数量
function M:GetUniqueDatailedNumber(Key)
    print("GetUniqueDatailedNumber:",Key)
    if DesignatedName2Func[Key]==nil then
        ScreenPrint("Key 不存在 Key="..Key)
        for k,value in pairs(DataMgr["PersonalUniqueDetails"]) do
            ScreenPrint("Key=",Key,"value= ",value)
        end
        return nil
    end
    return DesignatedName2Func[Key](self) or "888"
end
--初始化可配置的Tab信息
--参考结构--
--[[
table = {
    [101] = {
        Name = "MAIN_UI_PLAY",
        TabID = 101,
        Cotents = {{
            Name = "MAIN_UI_PLAY",
            TabID = 101,
            Event = "Collection_Melee",
            Sort = 1
            Count=555 --此数据从acatar中获取
        }, {
            Name = "MAIN_UI_PLAY",
            TabID = 101,
            Event = "Collection_Range",
            Sort = 2
            Count=5
        }, {
            Name = "MAIN_UI_PLAY",
            TabID = 101,
            Event = "Collection_Skin",
            Sort = 3
            Count=999
        }}
    }
    [102] = {
        ...
    }
}
]]
function M:SortDetailedTabInfo()
    if self.DetailedTabInfo==nil then
        self.DetailedTabInfo={}
    end
    local OriginTabsInfo=DataMgr["PersonalDetailsTab"]
    self.DetailedTabInfo={}
    for index, value in pairs(OriginTabsInfo) do
        local copy={}
        copy.Name=value.Name
        copy.TabID=value.TabID
        self.DetailedTabInfo[value.TabID]=copy
        -- body
    end
    table.sort( self.DetailedTabInfo,function(a,b)return a.Sort < b.Sort end)
    local RawData=DataMgr["PersonalDetails"]
    local SortData={}
    for k,value in pairs(RawData) do
        table.insert(SortData,value)
    end
    --根据优先级排序
    table.sort(SortData, function(a, b) return a.Sort < b.Sort end)

    --初始化字典
    for k,value in pairs(SortData) do
        if  value.TabID then
            if   self.DetailedTabInfo[value.TabID]==nil then
                goto continue
            end
            if self.DetailedTabInfo[value.TabID].Contents ==nil then
                self.DetailedTabInfo[value.TabID].Contents={}
            end
            local copy={}
            copy.Des=value.Des
            copy.Event=value.Event
            copy.Count=self:GetUniqueDatailedNumber(value.Event)--装配实际显示数据
            table.insert(self.DetailedTabInfo[value.TabID].Contents,copy)
        else
            ScreenPrint("PersonalDetailsTab 表内TabID为空,Event为："..value.Event or "空"  )
        end
        ::continue::
    end
end

function M:GetHaveCharsCount()
    return self.CharsCount or 0
end
function M:GetHaveMeleeCount()
    return self.MeleeCount or 0
end
function M:GetHaveRangedCount()
    return self.RangedCount or 0
end
function M:GetHaveCharSkinCount()
    return self.CharSkinCount or 0
end
function M:GetHaveWeaponSkinCount()
    return self.WeaponSkinCount or 0
end
function M:GetHaveCharAccessoryCount() --
    return self.CharAccessorys or 0 -- 
end
function M:GetHaveWeaponAccessoryCount()
    return self.WeaponAccessorys or 0 -- 
end
function M:GetHaveModCount()
    return self.ModCount or 0 
end
function M:GetHavePetCount()
    return self.PetCount or 0 
end
function M:GetHaveModCount()
    return self.ModCount or 0 
end
function M:GetAccoutCreateTime()
    return self.CreateTime or 0
end
function M:GetAchievementCount()
    return self.Achievement_Count or 0
end
function M:GetAchievementArray()
    return self.Achievement_Array or {0,0,0}
end
---读表获取动态的Tab信息
function M:GetMoreDetailedTabs()
    return self.DetailedTabInfo
end
function M:FindTabDetailedData(TabName)
    return DataMgr["PersonalDetails"][TabName]
end
function M:GetChildInfoInTab(TabIndex)
    return DataMgr["PersonalDetails"][TabIndex]
end
-- 获取剧院通过难度
function M:GetAbyss_Difficulty()
    local Text
    local AbyssSeasonConfig
    for index, value in pairs( DataMgr.AbyssSeason) do
        -- body
        if value.AbyssType== self.Abyss_Difficulty then
            AbyssSeasonConfig=value
            break
        end
    end
        local MaxAbyssProgress =self.Abyss_Step
        local MaxAbyssProgressStr = string.format(GText("Abyss_LevelName"), MaxAbyssProgress)
        Text = string.format("%s%s%s", GText(AbyssSeasonConfig.AbyssIdName), "/", MaxAbyssProgressStr)
    
    return Text
end
-- 获取剧院通过层数
function M:GetAbyss_Step()
    return self.Abyss_Step
end
-- 获取剧院赛季星星
function M:GetAbyss_Star()
    return self.Abyss_Star
end
-- 获取迷津通过难度
function M:GetRouge_Difficulty()
    local LevelId=self.Rouge_Difficulty
    local LevelData=DataMgr.RougeLikeDifficulty[LevelId]
    if not LevelData then
        ScreenPrint("RougeLikeDifficulty 表内没有对应ID的数据,ID为："..tostring(LevelId) )
        return 0
    end
    local RecommendLevel=LevelData.RecommendLevel
    if not RecommendLevel then
        ScreenPrint("RougeLikeDifficulty 表内对应数据没有RecommendLevel,ID为："..tostring(LevelId) )
        return 0
    end
    if RecommendLevel==0 then
        return RecommendLevel --0则不显示LV
    end
    return GText("UI_LEVEL_NAME")..(tostring(RecommendLevel) or 0)
end

function M:SetInfoVisibility(Visible)
    self._Avatar:SetPersonalInfoVisible(Visible)
end
function M:ClearModel()
    self._Avatar = nil
end
-- 事件名称到函数的映射表
DesignatedName2Func = {
    Collection_Char = M.GetHaveCharsCount,
    Collection_Melee = M.GetHaveMeleeCount,
    Collection_Range = M.GetHaveRangedCount,
    Collection_Skin = M.GetHaveCharSkinCount,
    Collection_WeaponSkin = M.GetHaveWeaponSkinCount,
    Collection_CharAccessory = M.GetHaveCharAccessoryCount,
    Collection_WeaponAccessory = M.GetHaveWeaponAccessoryCount,
    Collection_Mod = M.GetHaveModCount,
    Collection_Pet = M.GetHavePetCount,
    Rouge_Difficulty = M.GetRouge_Difficulty,
    Abyss_Star=M.GetAbyss_Star,
    Abyss_Step=M.GetAbyss_Step,
    Abyss_Difficulty=M.GetAbyss_Difficulty,
}
return M
